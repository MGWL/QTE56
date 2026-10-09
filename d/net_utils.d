/**
 * net_utils.d — синхронные HTTP-хелперы поверх Qt Network.
 *
 * Модуль предоставляет блокирующие обёртки над асинхронным QNetworkAccessManager,
 * реализуя «синхронность» через цикл $(D processEvents) — вызов пока запрос
 * не завершится или не истечёт таймаут.
 *
 * Поддерживаемые методы: GET, POST, PUT, DELETE, HEAD.
 * Поддерживаемые протоколы: http, https (SSL через Qt, без внешних DLL).
 *
 * Предварительные условия:
 *   До первого вызова любой функции обязательно выполнить:
 *   $(OL
 *     $(LI $(D LoadQt("./dll")) — загрузить DLL-зависимости)
 *     $(LI $(D new QApplication(name)) — создать экземпляр Qt-приложения)
 *   )
 *   FTP, SFTP и SCP не поддерживаются — используйте $(D curl_utils.d).
 *
 * Потокобезопасность: НЕТ. Модуль использует глобальное состояние (__gshared)
 * для хранения ответа. Одновременно допустим только один запрос.
 *
 * Тесты: $(D test/test_net_utils.d) — lifecycle + опциональные сетевые тесты
 *        (запустить с $(D NETWORK_TEST=1)).
 *
 * See_Also: $(D curl_utils.d) — альтернатива без Qt (FTP/SFTP/SCP/HTTP/HTTPS).
 *
 * ---
 * Примеры использования:
 * ---
 *
 * // ── Простой GET ──────────────────────────────────────────────────────────
 * string body = httpGet("https://api.example.com/data");
 *
 * // ── POST с JSON ──────────────────────────────────────────────────────────
 * string resp = httpPost("https://api.example.com/items",
 *                        `{"name":"test"}`, "application/json");
 *
 * // ── Полный контроль через httpFetch ──────────────────────────────────────
 * string[string] hdrs;
 * hdrs["Authorization"] = "Bearer my-token";
 * hdrs["Accept"]        = "application/json";
 * auto res = httpFetch("https://api.example.com/data", "GET", "", hdrs, "", 15_000);
 * if (!res.timedOut && res.errorCode == 0)
 *     writeln(res.body);
 *
 * // ── Скачивание бинарных данных ───────────────────────────────────────────
 * ubyte[] png = httpGetBytes("https://example.com/image.png");
 */
module net_utils;

import std.datetime.stopwatch : StopWatch, AutoStart;
import std.string             : split;

import qte56_core;
import qte56_loader;
import gen_qcore   : t_v__qp, toQString, fromQString;
import gen_qnetwork;
import gen_qbytearray : QByteArray;


// ══════════════════════════════════════════════════════════════════════════════
// HttpResponse — результат HTTP-запроса
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Результат синхронного HTTP-запроса, возвращаемый функцией $(D httpFetch).
 *
 * При успехе: $(D errorCode == 0), $(D timedOut == false),
 *             $(D statusCode) содержит HTTP-статус (например 200).
 * При таймауте: $(D timedOut == true), $(D statusCode == 0).
 * При сетевой ошибке: $(D errorCode != 0), $(D errorStr) содержит описание.
 *
 * Note:
 *   $(D errorCode == 0) означает отсутствие ошибки на уровне сети, но
 *   не гарантирует успешный HTTP-статус. Для проверки успеха HTTP
 *   используйте $(D statusCode >= 200 && statusCode < 300).
 */
struct HttpResponse {
    /// HTTP-статус ответа (200, 404, 500 и т.д.); 0 при ошибке или таймауте.
    int    statusCode;

    /// Тело ответа в кодировке UTF-8.
    /// Для HEAD-запросов — пустая строка (тело не передаётся по протоколу).
    string body;

    /// Описание сетевой ошибки от Qt (пустое при успехе).
    /// Примеры: "Host not found", "Connection refused", "SSL handshake failed".
    string errorStr;

    /// Код ошибки QNetworkReply::NetworkError; 0 означает NoError.
    /// Ненулевые коды см. в документации Qt: QNetworkReply::NetworkError enum.
    int    errorCode;

    /// $(D true) если запрос не завершился за отведённое время $(D timeoutMs).
    /// При таймауте соединение разрывается через $(D QNetworkReply::abort()).
    bool   timedOut;
}


// ══════════════════════════════════════════════════════════════════════════════
// Глобальное состояние (один запрос одновременно)
// ══════════════════════════════════════════════════════════════════════════════

/// Флаг завершения текущего запроса (устанавливается в коллбэке _onFinished).
private __gshared bool   _done;

/// HTTP-статус последнего завершённого запроса.
private __gshared int    _status;

/// Тело ответа последнего завершённого запроса (UTF-8).
private __gshared string _body;

/// Текстовое описание ошибки Qt для последнего запроса.
private __gshared string _errStr;

/// Числовой код ошибки Qt для последнего запроса.
private __gshared int    _errCode;

/**
 * Коллбэк сигнала QNetworkAccessManager::finished(QNetworkReply*).
 *
 * Вызывается из Qt при завершении запроса (успех или ошибка).
 * Читает данные ответа из reply, сохраняет в глобальные переменные,
 * ставит флаг $(D _done) и планирует удаление reply через deleteLater().
 *
 * Params:
 *   dthis    = указатель D-объекта (не используется, передаётся как null).
 *   n        = порядковый номер сигнала (не используется).
 *   replyPtr = непрозрачный указатель на QNetworkReply в DLL.
 */
extern(C) private void _onFinished(void* dthis, int n, void* replyPtr) {
    auto reply  = QNetworkReply.wrap(replyPtr);
    _status     = reply.statusCode();
    _body       = reply.readAllString();
    _errCode    = reply.error();
    if (_errCode != 0) _errStr = reply.errorString();
    _done       = true;
    reply.deleteLater();
}

/// Тип функции void() для вызова QApplication::processEvents() через pFunQt[53].
private alias t_v__ = extern(C) void function();


// ══════════════════════════════════════════════════════════════════════════════
// httpFetch — универсальная функция выполнения HTTP-запроса
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Выполняет HTTP-запрос синхронно через цикл $(D processEvents).
 *
 * Создаёт QNetworkAccessManager, подключает сигнал finished к внутреннему
 * коллбэку $(D _onFinished) и крутит цикл processEvents до завершения
 * запроса или истечения таймаута.
 *
 * Params:
 *   url         = целевой URL (http:// или https://).
 *   method      = HTTP-метод: "GET", "POST", "PUT", "DELETE", "HEAD".
 *                 Любое другое значение трактуется как GET.
 *   body        = тело запроса в UTF-8 (для POST/PUT; для остальных — "").
 *   headers     = дополнительные HTTP-заголовки в виде AA строк ("Имя" → "значение").
 *   contentType = значение заголовка Content-Type (применяется после headers,
 *                 поэтому перекрывает одноимённый заголовок из AA).
 *   timeoutMs   = таймаут в миллисекундах (по умолчанию 10 000 = 10 секунд).
 *
 * Returns: $(D HttpResponse) с кодом статуса, телом и информацией об ошибке.
 *
 * Note: Не потокобезопасно. Использует глобальное состояние __gshared.
 *       Одновременно допустим только один вызов httpFetch/httpGet/httpPost.
 *
 * Example:
 * ---
 * string[string] hdrs;
 * hdrs["Authorization"] = "Bearer token";
 * auto res = httpFetch("https://api/data", "GET", "", hdrs, "", 5_000);
 * if (!res.timedOut && res.errorCode == 0 && res.statusCode == 200)
 *     process(res.body);
 * ---
 */
HttpResponse httpFetch(
    string         url,
    string         method      = "GET",
    string         body        = "",
    string[string] headers     = null,
    string         contentType = "",
    int            timeoutMs   = 10_000)
{
    // Сброс глобального состояния перед новым запросом
    _done = false; _status = 0; _body = ""; _errStr = ""; _errCode = 0;

    auto mgr = new QNetworkAccessManager(null);
    scope(exit) mgr.destroy();

    // Подключаем сигнал finished — срабатывает ровно один раз на ответ
    mgr.connect_finished(null, 0, cast(void*)&_onFinished);

    auto req = new QNetworkRequest(url);
    scope(exit) req.destroy();

    // Применяем пользовательские заголовки
    foreach (k, v; headers)
        req.setRawHeader(k, v);
    // Content-Type применяется последним — перекрывает одноимённый из AA
    if (contentType.length > 0)
        req.setRawHeader("Content-Type", contentType);
    req.setFollowRedirects(true);

    QNetworkReply reply;

    switch (method) {
    case "POST":
        auto ba = new QByteArray(body);
        reply = mgr.post(req, ba);
        ba.destroy();
        break;
    case "PUT":
        auto ba = new QByteArray(body);
        reply = mgr.put(req, ba);
        ba.destroy();
        break;
    case "DELETE":
        reply = mgr.deleteResource(req);
        break;
    case "HEAD":
        reply = mgr.head(req);
        break;
    default: // GET и всё остальное
        reply = mgr.get(req);
        break;
    }

    // Цикл ожидания: processEvents крутится пока _done не станет true или не истечёт таймаут
    auto sw = StopWatch(AutoStart.yes);
    while (!_done && sw.peek.total!"msecs" < timeoutMs) {
        (cast(t_v__)pFunQt[53])();   // QApplication::processEvents()
    }

    HttpResponse res;
    if (!_done) {
        // Таймаут: явно прерываем соединение
        reply.abort();
        res.timedOut   = true;
        res.statusCode = 0;
        res.errorStr   = "timeout after " ~ timeoutMs.to!string ~ " ms";
        res.errorCode  = -1;
    } else {
        res.statusCode = _status;
        res.body       = _body;
        res.errorStr   = _errStr;
        res.errorCode  = _errCode;
    }
    return res;
}


// ══════════════════════════════════════════════════════════════════════════════
// Удобные однострочники
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Синхронный HTTP GET — возвращает тело ответа как строку.
 *
 * При ошибке или таймауте возвращает пустую строку.
 * Для проверки причины ошибки используйте $(D httpFetch).
 *
 * Params:
 *   url       = целевой URL (http:// или https://).
 *   timeoutMs = таймаут в миллисекундах (по умолчанию 10 000).
 * Returns: тело ответа в UTF-8, либо "" при ошибке.
 *
 * Example:
 * ---
 * string json = httpGet("https://api.example.com/status");
 * ---
 */
string httpGet(string url, int timeoutMs = 10_000) {
    return httpFetch(url, "GET", "", null, "", timeoutMs).body;
}

/**
 * Синхронный HTTP POST — возвращает тело ответа как строку.
 *
 * При ошибке или таймауте возвращает пустую строку.
 *
 * Params:
 *   url         = целевой URL (http:// или https://).
 *   body        = тело запроса в UTF-8 (JSON, form-data и т.п.).
 *   contentType = значение заголовка Content-Type
 *                 (по умолчанию "application/json").
 *   timeoutMs   = таймаут в миллисекундах (по умолчанию 10 000).
 * Returns: тело ответа в UTF-8, либо "" при ошибке.
 *
 * Example:
 * ---
 * string resp = httpPost("https://api.example.com/items",
 *                        `{"name":"test"}`, "application/json");
 * ---
 */
string httpPost(string url, string body,
                string contentType = "application/json",
                int    timeoutMs   = 10_000)
{
    return httpFetch(url, "POST", body, null, contentType, timeoutMs).body;
}

/**
 * Синхронный HTTP GET — возвращает тело ответа как массив байт.
 *
 * Удобен для скачивания бинарных данных (изображения, архивы и т.п.).
 * При ошибке или таймауте возвращает пустой массив.
 *
 * Params:
 *   url       = целевой URL (http:// или https://).
 *   timeoutMs = таймаут в миллисекундах (по умолчанию 10 000).
 * Returns: тело ответа как $(D ubyte[]), либо [] при ошибке.
 *
 * Example:
 * ---
 * ubyte[] png = httpGetBytes("https://example.com/logo.png");
 * std.file.write("logo.png", png);
 * ---
 */
ubyte[] httpGetBytes(string url, int timeoutMs = 10_000) {
    return cast(ubyte[]) httpFetch(url, "GET", "", null, "", timeoutMs).body.dup;
}


// ══════════════════════════════════════════════════════════════════════════════
// Встроенные модульные тесты
// ══════════════════════════════════════════════════════════════════════════════
//
// Все рабочие функции (httpGet/httpPost/httpFetch) требуют LoadQt() +
// QApplication + реального сетевого соединения и не могут быть протестированы
// без Qt-окружения.
//
// Встроенные unittest охватывают только чистую логику структуры HttpResponse,
// которая не зависит от DLL.
// Полное интеграционное покрытие: test/test_net_utils.d.

unittest {
    // ── Дефолтные значения полей HttpResponse ─────────────────────────────
    // Нулевой инициализатор D-структуры: все числа = 0, строки = "", bool = false
    HttpResponse r;
    assert(r.statusCode == 0,   "statusCode по умолчанию должен быть 0");
    assert(r.body       == "",  "body по умолчанию должна быть пустой строкой");
    assert(r.errorStr   == "",  "errorStr по умолчанию должна быть пустой строкой");
    assert(r.errorCode  == 0,   "errorCode по умолчанию должен быть 0 (NoError)");
    assert(r.timedOut   == false, "timedOut по умолчанию должен быть false");

    // ── Присвоение полей ──────────────────────────────────────────────────
    HttpResponse ok200;
    ok200.statusCode = 200;
    ok200.body       = `{"status":"ok"}`;
    ok200.errorCode  = 0;
    ok200.timedOut   = false;
    assert(ok200.statusCode == 200);
    assert(ok200.body       == `{"status":"ok"}`);
    assert(!ok200.timedOut);
    assert(ok200.errorCode  == 0);

    // ── Таймаут-ответ ─────────────────────────────────────────────────────
    HttpResponse tout;
    tout.timedOut   = true;
    tout.statusCode = 0;
    tout.errorStr   = "timeout after 5000 ms";
    tout.errorCode  = -1;
    assert(tout.timedOut);
    assert(tout.statusCode == 0);
    assert(tout.errorStr.length > 0);
    assert(tout.errorCode == -1);

    // ── Сетевая ошибка (errorCode != 0) ───────────────────────────────────
    HttpResponse err;
    err.errorCode = 3;   // QNetworkReply::HostNotFoundError
    err.errorStr  = "Host not found";
    assert(err.errorCode != 0);
    assert(err.errorStr  == "Host not found");
    assert(!err.timedOut);           // ошибка ≠ таймаут

    // ── Структура является значимым типом (копируется, не ссылочный) ──────
    HttpResponse a;
    a.statusCode = 404;
    a.body = "Not Found";
    HttpResponse b = a;             // копия
    b.statusCode = 200;             // меняем копию
    assert(a.statusCode == 404);    // оригинал не изменился
    assert(b.statusCode == 200);
}

// import std.conv нужен для .to!string внутри httpFetch
private import std.conv : to;
