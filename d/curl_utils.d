/**
 * curl_utils.d — высокоуровневый API для работы с сетью через libcurl.
 *
 * Модуль предоставляет класс $(D CurlSession) — объектно-ориентированную
 * обёртку над низкоуровневым C-интерфейсом libcurl с fluent-цепочками вызовов.
 *
 * Поддерживаемые протоколы (определяются по схеме URL):
 *   http / https  — HTTP-запросы: заголовки, тело, аутентификация, редиректы
 *   ftp  / ftps   — скачивание и загрузка файлов по FTP
 *   sftp          — защищённая передача файлов: пароль или SSH-ключ
 *   scp           — копирование через SSH-ключ
 *
 * Зависимости:
 *   Перед созданием CurlSession обязательно вызвать LoadQt("./dll"),
 *   чтобы загрузился qte56_curl.dll (который сам загружает libcurl.dll/so).
 *   На Windows: libcurl.dll — рядом с qte56_curl.dll или в PATH;
 *             cacert.pem ищется автоматически (рядом с exe в ./dll,
 *             затем C:\Users\Public\QTE56\bin513).
 *   На Linux: установить пакет libcurl4-openssl-dev; cacert.pem не нужен
 *             (система использует системные сертификаты).
 *
 * Потокобезопасность: НЕТ. Один запрос на сессию в каждый момент времени.
 *
 * Тесты: $(D test/test_curl.d) — интеграционные проверки HTTP/HTTPS/FTP/SFTP.
 *
 * ---
 * Примеры использования:
 * ---
 *
 * // ── Простой GET-запрос ──────────────────────────────────────────────
 * auto c = new CurlSession();
 * string body = c.get("https://api.example.com/data");
 *
 * // ── POST с JSON-телом ────────────────────────────────────────────────
 * string resp = c.post("https://api.example.com/items",
 *                       `{"name":"test"}`, "application/json");
 *
 * // ── Fluent-цепочка: заголовки, таймаут, результат ───────────────────
 * auto res = c.reset()
 *              .url("https://api.example.com/data")
 *              .header("Authorization", "Bearer my-token")
 *              .header("Accept", "application/json")
 *              .timeout(30)
 *              .execute();
 * if (res.ok)
 *     writeln(res.body);
 * else
 *     writefln("Ошибка %d: %s", res.curlCode, res.error);
 *
 * // ── Скачивание файла (HTTP / FTP / SFTP) ─────────────────────────────
 * bool ok = c.reset().download("https://example.com/file.zip", "./file.zip");
 *
 * // ── SFTP с паролем ───────────────────────────────────────────────────
 * bool ok = c.reset()
 *             .auth("user", "pass")
 *             .download("sftp://host/remote/file.txt", "./local.txt");
 *
 * // ── SFTP с SSH-ключом ────────────────────────────────────────────────
 * bool ok = c.reset()
 *             .sshKey("/home/user/.ssh/id_rsa")
 *             .download("sftp://user@host/remote/file.txt", "./local.txt");
 *
 * // ── Загрузка файла на FTP ────────────────────────────────────────────
 * bool ok = c.reset()
 *             .auth("ftpuser", "ftppass")
 *             .upload("./report.csv", "ftp://ftp.example.com/pub/report.csv");
 */
module curl_utils;

import std.string : fromStringz;
import std.conv   : to;

import qte56_core : pFunQt;
import gen_qcurl;   // низкоуровневые хелперы _curl_*

// ── Поиск cacert.pem (CA-бандл для HTTPS) ──────────────────────────────────

/**
 * Ищет cacert.pem в известных местах (в порядке приоритета):
 *   1. <каталог exe>/dll/cacert.pem  — приложение несёт свой бандл
 *   2. ./dll/cacert.pem              — legacy: относительно рабочего каталога
 *   3. C:\Users\Public\QTE56\bin513\cacert.pem — развёрнутый runtime
 * Если нигде не найден — возвращает legacy-путь "./dll/cacert.pem"
 * (ошибка curl 77 скажет пользователю, что файл не найден).
 */
private string _findCaBundle() {
    import std.file : exists, thisExePath;
    import std.path : dirName, buildPath;

    version(Windows) {
        immutable candidates = [
            buildPath(thisExePath.dirName, "dll", "cacert.pem"),
            `./dll/cacert.pem`,
            `C:\Users\Public\QTE56\bin513\cacert.pem`,
        ];
    } else {
        immutable candidates = [
            `./dll/cacert.pem`,
        ];
    }
    foreach (c; candidates)
        if (exists(c)) return c;
    return "./dll/cacert.pem";
}


// ══════════════════════════════════════════════════════════════════════════════
// CurlResult — результат выполнения одного запроса
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Результат выполнения HTTP/FTP/SFTP-запроса, возвращаемый методом $(D execute()).
 *
 * При успехе: curlCode == 0, ok == true, statusCode содержит HTTP-статус.
 * При ошибке: curlCode != 0, error содержит текстовое описание от libcurl.
 */
struct CurlResult {
    /// Код ответа протокола: HTTP (200, 404, 500…), FTP (226 = OK), 0 если не применимо.
    int    statusCode;

    /// Тело ответа в кодировке UTF-8.
    /// Для file-download (downloadFile) — пустая строка; данные записаны в файл.
    string body;

    /// Текстовое описание ошибки от libcurl (пусто при успехе).
    /// Примеры: "Could not resolve host", "SSL certificate problem".
    string error;

    /// CURLcode: 0 = CURLE_OK. Ненулевые коды см. в документации libcurl.
    int    curlCode;

    /// Количество переданных байт (скачано или загружено).
    long   bytes;

    /// Возвращает true если запрос завершился без ошибки libcurl (curlCode == 0).
    /// Не проверяет HTTP-статус — используйте isHttp2xx для проверки по статусу.
    @property bool ok() const { return curlCode == 0; }

    /// Возвращает true если HTTP-статус в диапазоне 200–299 (успех).
    @property bool isHttp2xx() const { return statusCode >= 200 && statusCode < 300; }
}


// ══════════════════════════════════════════════════════════════════════════════
// CurlSession — сессия для выполнения запросов
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Сессия libcurl для выполнения HTTP/FTP/SFTP/SCP-запросов.
 *
 * Один экземпляр = один дескриптор CURL (easy handle) внутри qte56_curl.dll.
 * Поддерживает fluent-цепочки: каждый метод настройки возвращает $(D this).
 *
 * Типичный цикл работы:
 * $(OL
 *   $(LI Создать: `auto c = new CurlSession();`)
 *   $(LI Настроить: `.url(...).header(...).timeout(...)`)
 *   $(LI Выполнить: `.execute()` или `.get()` / `.post()` / `.download()`)
 *   $(LI Сбросить для следующего запроса: `.reset()`)
 * )
 *
 * Примечание: reset() нужен между разными запросами; без него параметры
 * предыдущего запроса (URL, заголовки, тело) остаются активными.
 */
class CurlSession {
private:
    void* _h;   // непрозрачный указатель на CurlSession внутри DLL


// ── Жизненный цикл ────────────────────────────────────────────────────────

public:

    /**
     * Создаёт новую сессию libcurl.
     *
     * По умолчанию устанавливает:
     *   - CA-бандл: ./dll/cacert.pem (для проверки HTTPS-сертификатов)
     *   - SSL verify: включён (CURLOPT_SSL_VERIFYPEER = 1)
     *   - Следовать редиректам: включено
     *   - Таймаут: 30 секунд
     *
     * LoadQt("./dll") должен быть вызван ДО создания CurlSession.
     */
    this() {
        _h = _curl_create();
        // Устанавливаем CA-файл по умолчанию (поиск в известных местах)
        _curl_wset(20054, _h, _findCaBundle());
    }

    /**
     * Уничтожает сессию и освобождает дескриптор libcurl.
     * Открытые файловые дескрипторы (upload/download) закрываются в C++-стороне.
     */
    ~this() {
        // После app.deleteApp() pFunQt[] обнулён — C++ cleanup пропускаем
        // (иначе вызов по null-указателю в GC-финализаторе → AV на выходе).
        // OS освободит память DLL при завершении процесса.
        if (_h !is null && pFunQt[20049] !is null)
            _curl_destroy(_h);
        _h = null;
    }


// ── Целевой URL ───────────────────────────────────────────────────────────

    /**
     * Устанавливает URL запроса. Протокол определяется автоматически по схеме:
     *   "http://"  "https://"  "ftp://"  "ftps://"  "sftp://"  "scp://"
     *
     * Params:
     *   u = полный URL включая схему.
     * Returns: this (для цепочки вызовов).
     */
    CurlSession url(string u) {
        _curl_wset(20050, _h, u);
        return this;
    }


// ── Аутентификация ────────────────────────────────────────────────────────

    /**
     * Устанавливает логин и пароль для HTTP Basic Auth, FTP или SFTP
     * (пароль вместо SSH-ключа).
     *
     * Для HTTP используется в заголовке Authorization: Basic ...
     * Для FTP/SFTP передаётся в протоколе напрямую.
     *
     * Params:
     *   user = имя пользователя.
     *   pass = пароль.
     * Returns: this.
     */
    CurlSession auth(string user, string pass) {
        _curl_wset(20051, _h, user);
        _curl_wset(20052, _h, pass);
        return this;
    }


// ── SSL / TLS ─────────────────────────────────────────────────────────────

    /**
     * Отключает проверку SSL-сертификата сервера.
     *
     * Используйте только для тестирования с самоподписанными сертификатами!
     * В production всегда оставляйте проверку включённой (по умолчанию).
     *
     * Returns: this.
     */
    CurlSession skipSsl() {
        _curl_set_i(20053, _h, 0);   // CURLOPT_SSL_VERIFYPEER = 0, VERIFYHOST = 0
        return this;
    }

    /**
     * Задаёт путь к файлу CA-бандла (cacert.pem) для проверки HTTPS.
     *
     * По умолчанию используется ./dll/cacert.pem (устанавливается в конструкторе).
     * На Linux обычно не нужен — система имеет свои системные сертификаты.
     *
     * Params:
     *   path = путь к файлу в формате PEM (например "/etc/ssl/certs/ca-certificates.crt").
     * Returns: this.
     */
    CurlSession caFile(string path) {
        _curl_wset(20054, _h, path);
        return this;
    }


// ── SSH / SFTP ────────────────────────────────────────────────────────────

    /**
     * Указывает файл SSH-ключа для аутентификации при SFTP / SCP
     * (альтернатива паролю через auth()).
     *
     * Если pubKey не задан, libcurl ищет публичный ключ как "privKey.pub".
     *
     * Params:
     *   privKey = путь к файлу приватного ключа (id_rsa, id_ed25519 и т.п.).
     *   pubKey  = путь к файлу публичного ключа (необязательно).
     * Returns: this.
     *
     * Example:
     * ---
     * c.sshKey("/home/user/.ssh/id_rsa")
     *  .download("sftp://user@host/file.txt", "./file.txt");
     * ---
     */
    CurlSession sshKey(string privKey, string pubKey = "") {
        _curl_wset(20055, _h, privKey);
        if (pubKey.length > 0) _curl_wset(20056, _h, pubKey);
        return this;
    }

    /**
     * Задаёт файл known_hosts для проверки подлинности SSH-сервера.
     *
     * Если не вызвать, libcurl пропускает проверку хоста (аналог
     * StrictHostKeyChecking=no в ssh_config). Укажите файл для безопасного
     * соединения: обычно ~/.ssh/known_hosts.
     *
     * Params:
     *   path = путь к файлу known_hosts.
     * Returns: this.
     */
    CurlSession knownHosts(string path) {
        _curl_wset(20057, _h, path);
        return this;
    }


// ── Параметры передачи ────────────────────────────────────────────────────

    /**
     * Устанавливает таймаут всего запроса в секундах.
     *
     * По умолчанию: 30 секунд.
     * Значение 0 отключает таймаут (ждать бесконечно).
     *
     * Params:
     *   seconds = максимальное время ожидания в секундах.
     * Returns: this.
     */
    CurlSession timeout(int seconds) {
        _curl_set_i(20058, _h, seconds);
        return this;
    }

    /**
     * Управляет автоматическим следованием HTTP-редиректам (301, 302, 307, 308).
     *
     * По умолчанию: включено (v = true).
     *
     * Params:
     *   v = true — следовать редиректам, false — остановиться на первом.
     * Returns: this.
     */
    CurlSession followRedirects(bool v = true) {
        _curl_set_i(20059, _h, v ? 1 : 0);
        return this;
    }

    /**
     * Включает/выключает подробный вывод отладки libcurl в stderr.
     *
     * Полезно при отладке: выводит заголовки запроса/ответа, SSL-информацию.
     * В production должно быть выключено (по умолчанию).
     *
     * Params:
     *   v = true — включить отладочный вывод.
     * Returns: this.
     */
    CurlSession verbose(bool v = true) {
        _curl_set_i(20060, _h, v ? 1 : 0);
        return this;
    }


// ── HTTP-специфичные настройки ────────────────────────────────────────────

    /**
     * Устанавливает HTTP-метод запроса.
     *
     * Стандартные значения: "GET", "POST", "PUT", "DELETE", "HEAD", "PATCH".
     * Для GET/POST/HEAD/PUT используются оптимизированные флаги libcurl.
     * Остальные методы передаются через CURLOPT_CUSTOMREQUEST.
     *
     * Params:
     *   m = строка метода (регистр важен, используйте верхний).
     * Returns: this.
     */
    CurlSession method(string m) {
        _curl_wset(20061, _h, m);
        return this;
    }

    /**
     * Устанавливает тело запроса для POST / PUT.
     *
     * Строка должна быть в UTF-8. libcurl копирует данные внутренне,
     * поэтому исходный буфер можно освободить после вызова.
     *
     * Вызов автоматически активирует POST-режим (CURLOPT_POST = 1).
     * Не забудьте задать Content-Type через header() или используйте post().
     *
     * Params:
     *   body = тело запроса в UTF-8 (JSON, form-data и т.п.).
     * Returns: this.
     *
     * Example:
     * ---
     * c.url("https://api/items")
     *  .header("Content-Type", "application/json")
     *  .postBody(`{"name":"test"}`)
     *  .method("POST")
     *  .execute();
     * ---
     */
    CurlSession postBody(string body) {
        _curl_wset(20062, _h, body);
        return this;
    }

    /**
     * Добавляет один HTTP-заголовок к запросу.
     *
     * Заголовки накапливаются; каждый вызов header() добавляет новый.
     * Для очистки всех заголовков используйте clearHeaders().
     *
     * Params:
     *   name  = имя заголовка (например "Content-Type", "Authorization").
     *   value = значение заголовка.
     * Returns: this.
     *
     * Example:
     * ---
     * c.header("Authorization", "Bearer eyJhb...")
     *  .header("Accept", "application/json")
     *  .header("X-Request-Id", "abc123");
     * ---
     */
    CurlSession header(string name, string value) {
        // Формируем строку в формате "Name: Value" как требует протокол HTTP
        _curl_wset(20063, _h, name ~ ": " ~ value);
        return this;
    }

    /**
     * Удаляет все добавленные HTTP-заголовки.
     *
     * Полезно при повторном использовании сессии с другим набором заголовков.
     * Стандартные заголовки libcurl (User-Agent, Content-Length и т.п.)
     * при этом не удаляются — только те, что добавлены через header().
     *
     * Returns: this.
     */
    CurlSession clearHeaders() {
        _curl_set_i(20064, _h, 0);  // в C++: slist_free + CURLOPT_HTTPHEADER = null
        return this;
    }


// ── Файловая передача ─────────────────────────────────────────────────────

    /**
     * Задаёт локальный файл для загрузки на сервер (upload).
     *
     * Используется совместно с url() для FTP PUT, SFTP upload или HTTP PUT.
     * Файл открывается в момент вызова execute(). Для выполнения
     * используйте execute() или upload().
     *
     * Params:
     *   localPath = путь к локальному файлу для отправки.
     * Returns: this.
     */
    CurlSession uploadFile(string localPath) {
        _curl_wset(20065, _h, localPath);
        return this;
    }

    /**
     * Задаёт локальный файл для сохранения скачанных данных (download).
     *
     * Если задан, тело ответа пишется в файл, а не в память.
     * Это предпочтительный способ для больших файлов.
     * Для выполнения используйте execute() или download().
     *
     * Params:
     *   localPath = путь к файлу назначения (будет создан или перезаписан).
     * Returns: this.
     */
    CurlSession downloadFile(string localPath) {
        _curl_wset(20066, _h, localPath);
        return this;
    }


// ── Выполнение запроса ────────────────────────────────────────────────────

    /**
     * Выполняет запрос с текущими настройками и возвращает результат.
     *
     * Блокирует поток до завершения передачи или истечения таймаута.
     * После вызова можно прочитать результат через возвращённый CurlResult,
     * либо через свойства statusCode / body / error / bytes.
     *
     * Returns: $(D CurlResult) со всеми данными ответа.
     *
     * Example:
     * ---
     * auto res = c.url("https://api/data").header("Accept","application/json").execute();
     * if (res.ok && res.isHttp2xx)
     *     writeln(res.body);
     * ---
     */
    CurlResult execute() {
        int rc = _curl_perform(_h);
        CurlResult r;
        r.curlCode   = rc;
        r.statusCode = _curl_status(_h);
        r.bytes      = _curl_size(_h);
        r.body       = _curl_body(_h);
        r.error      = _curl_error(_h);
        return r;
    }


// ── Удобные однострочники ─────────────────────────────────────────────────

    /**
     * Выполняет HTTP GET и возвращает тело ответа.
     *
     * Упрощённый вариант для быстрых GET-запросов без дополнительных настроек.
     * При ошибке возвращает пустую строку (проверить детали через свойства
     * statusCode / error).
     *
     * Params:
     *   u = URL для GET-запроса.
     * Returns: тело ответа в UTF-8, либо "" при ошибке libcurl.
     *
     * Example:
     * ---
     * string json = c.get("https://httpbin.org/uuid");
     * ---
     */
    string get(string u) {
        _curl_wset(20050, _h, u);
        _curl_wset(20061, _h, "GET");
        int rc = _curl_perform(_h);
        return rc == 0 ? _curl_body(_h).idup : "";
    }

    /**
     * Выполняет HTTP POST и возвращает тело ответа.
     *
     * Автоматически устанавливает заголовок Content-Type.
     * При ошибке возвращает пустую строку.
     *
     * Params:
     *   u           = URL для POST-запроса.
     *   body        = тело запроса в UTF-8.
     *   contentType = значение заголовка Content-Type
     *                 (по умолчанию "application/json").
     * Returns: тело ответа в UTF-8, либо "" при ошибке libcurl.
     *
     * Example:
     * ---
     * string resp = c.post("https://api/items", `{"name":"test"}`);
     * // или с form-encoded:
     * string resp = c.post(url, "key=value&other=123",
     *                      "application/x-www-form-urlencoded");
     * ---
     */
    string post(string u, string body, string contentType = "application/json") {
        _curl_wset(20050, _h, u);
        // Устанавливаем Content-Type через механизм заголовков
        _curl_wset(20063, _h, "Content-Type: " ~ contentType);
        _curl_wset(20062, _h, body);
        int rc = _curl_perform(_h);
        return rc == 0 ? _curl_body(_h).idup : "";
    }

    /**
     * Скачивает файл по URL и сохраняет его на диск.
     *
     * Работает для HTTP, HTTPS, FTP, FTPS, SFTP, SCP.
     * Не загружает тело в память — сразу пишет в файл (эффективно для
     * больших файлов).
     *
     * Params:
     *   u         = URL источника (любой поддерживаемый протокол).
     *   localPath = путь к файлу назначения (создаётся или перезаписывается).
     * Returns: true если передача завершилась без ошибки (curlCode == 0).
     *
     * Example:
     * ---
     * // HTTP
     * bool ok = c.download("https://example.com/file.zip", "./file.zip");
     * // SFTP с паролем
     * bool ok = c.auth("user","pass")
     *             .download("sftp://host/data/report.csv", "./report.csv");
     * ---
     */
    bool download(string u, string localPath) {
        _curl_wset(20050, _h, u);
        _curl_wset(20066, _h, localPath);
        return _curl_perform(_h) == 0;
    }

    /**
     * Загружает локальный файл на удалённый сервер.
     *
     * Работает для FTP PUT, SFTP upload, HTTP PUT.
     *
     * Params:
     *   localPath = путь к локальному файлу для отправки.
     *   u         = URL назначения на сервере.
     * Returns: true если передача завершилась без ошибки.
     *
     * Example:
     * ---
     * bool ok = c.auth("ftpuser","ftppass")
     *             .upload("./report.csv", "ftp://ftp.example.com/pub/report.csv");
     * ---
     */
    bool upload(string localPath, string u) {
        _curl_wset(20050, _h, u);
        _curl_wset(20065, _h, localPath);
        return _curl_perform(_h) == 0;
    }


// ── Свойства последнего результата ────────────────────────────────────────

    /**
     * HTTP/FTP-статус последнего выполненного запроса.
     * Дублирует CurlResult.statusCode; удобен без сохранения результата.
     */
    @property int statusCode() { return _curl_status(_h); }

    /**
     * Тело ответа последнего запроса (UTF-8).
     * Дублирует CurlResult.body; копирует строку (idup).
     */
    @property string body()    { return _curl_body(_h).idup; }

    /**
     * Текстовое описание ошибки последнего запроса (пусто при успехе).
     * Дублирует CurlResult.error; копирует строку (idup).
     */
    @property string error()   { return _curl_error(_h).idup; }

    /**
     * Количество байт, переданных в последнем запросе.
     * Дублирует CurlResult.bytes.
     */
    @property long bytes()     { return _curl_size(_h); }


// ── Сброс сессии ──────────────────────────────────────────────────────────

    /**
     * Сбрасывает все настройки сессии для повторного использования.
     *
     * Очищает: URL, логин/пароль, SSH-ключи, метод, тело, заголовки,
     * пути файлов, таймаут. Восстанавливает значения по умолчанию:
     * SSL verify включён, таймаут 30 с, следовать редиректам.
     * CA-файл восстанавливается в ./dll/cacert.pem.
     *
     * Дескриптор CURL сохраняется (переиспользуется), что эффективнее
     * создания нового CurlSession для каждого запроса.
     *
     * Returns: this (для немедленной цепочки настроек нового запроса).
     *
     * Example:
     * ---
     * auto c = new CurlSession();
     * c.get("https://api/first");
     * c.reset().auth("user","pass").download("ftp://host/file", "./file");
     * ---
     */
    CurlSession reset() {
        _curl_reset(_h);
        // Восстанавливаем CA-файл по умолчанию (reset в C++ его очищает)
        _curl_wset(20054, _h, _findCaBundle());
        return this;
    }

    /**
     * Возвращает непрозрачный указатель на внутренний дескриптор сессии DLL.
     * Используется только для отладки или низкоуровневого взаимодействия.
     *
     * Returns: указатель на CurlSession внутри qte56_curl.dll; null если DLL
     *          не загружена или создание сессии завершилось неудачей.
     */
    void* getHandle() { return _h; }
}


// ══════════════════════════════════════════════════════════════════════════════
// Встроенные модульные тесты (dmd -unittest curl_utils.d ...)
// Проверяют только чистую логику без DLL и сети.
// ══════════════════════════════════════════════════════════════════════════════

unittest {
    // ── CurlResult.ok ─────────────────────────────────────────────────────
    // ok == true только при curlCode == 0 (CURLE_OK)
    assert(CurlResult(200, "body", "", 0, 1024).ok  == true,  "ok при curlCode=0");
    assert(CurlResult(0,   "",     "", 6, 0).ok     == false, "!ok при curlCode=6 (CURLE_COULDNT_RESOLVE_HOST)");
    assert(CurlResult(404, "body", "", 0, 512).ok   == true,  "ok не зависит от HTTP-статуса");

    // ── CurlResult.isHttp2xx ──────────────────────────────────────────────
    // Диапазон 200–299 включительно
    assert(CurlResult(200, "", "", 0, 0).isHttp2xx == true,  "200 OK");
    assert(CurlResult(201, "", "", 0, 0).isHttp2xx == true,  "201 Created");
    assert(CurlResult(299, "", "", 0, 0).isHttp2xx == true,  "299 граница");
    assert(CurlResult(199, "", "", 0, 0).isHttp2xx == false, "199 ниже границы");
    assert(CurlResult(300, "", "", 0, 0).isHttp2xx == false, "300 редирект");
    assert(CurlResult(404, "", "", 0, 0).isHttp2xx == false, "404 Not Found");
    assert(CurlResult(500, "", "", 0, 0).isHttp2xx == false, "500 Server Error");
}
