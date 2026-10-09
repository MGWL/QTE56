/**
 * gen_qnetwork.d — привязки Qt-сети: QUrl, QNetworkRequest, QNetworkReply,
 * QNetworkAccessManager.
 *
 * DLL: qte56_network.dll / libqte56_network.so
 * Блок индексов: 20005–20045  (следующий свободный: 20046)
 *
 * Кросс-платформенность: Windows 32-bit dmd + Linux 64-bit ldc2.
 * `long` в D всегда 64-бит и соответствует C `long long` в extern(C) —
 * обе платформы согласованы, поэтому колбэки downloadProgress работают
 * без дополнительных приведений типов.
 *
 * SSL (Windows): положите libssl-1_1.dll + libcrypto-1_1.dll рядом с exe
 * (находятся в C:\Qt5_13_2\5.13.2\mingw73_32\bin\ или в бинарном пакете
 * OpenSSL 1.1).
 * SSL (Linux): системный libssl подключается автоматически.
 *
 * QNetworkReply всегда принадлежит Qt (возвращается методами get/post/put/...).
 * Используйте QNetworkReply.wrap(ptr) — не удаляйте вручную;
 * вызывайте deleteLater() после завершения использования объекта.
 */
module gen_qnetwork;

import std.utf : toUTF16;
import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__qp, t_qp__qp_qp, t_qp__qp_qp_i, t_qp__qp_i,
                   t_v__qp, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp_i,
                   t_v__qp_i,
                   t_i__qp, toQString, fromQString;
import gen_qbytearray : QByteArray;

// ── Новые псевдонимы типов функций (отсутствуют в gen_qcore) ──────────────

// void* function(void*, void*, void*) — post/put (mgr, req, body_ba)
mixin(generateAlias("qp__qp_qp_qp"));

// void function(void*, void*, int, void*, int) — setRawHeader (req, name, nlen, val, vlen)
mixin(generateAlias("v__qp_qp_i_qp_i"));

// ── Загрузка функций из DLL ────────────────────────────────────────────────

/**
 * Загружает все функции модуля qte56_network из таблицы pFunQt.
 *
 * Вызывается автоматически через registerModule при первом обращении
 * к любому классу этого модуля. Регистрирует 41 функцию (индексы 20005–20045)
 * для четырёх Qt-классов: QUrl, QNetworkRequest, QNetworkReply,
 * QNetworkAccessManager.
 *
 * Note: все generateFunQt-вызовы используют имя модуля "QNetworkAccessManager"
 * как единый ключ регистрации — это обязательное требование архитектуры
 * (см. gotcha в MEMORY.md: несовпадение имён модуля приводит к null и краши).
 */
void loadQNetwork() {
    // ── QUrl (индексы 20005–20012) ─────────────────────────────────────────
    mixin(generateFunQt(20005, "qteQUrl_create",     "QNetworkAccessManager")); /// Создать QUrl из UTF-16 строки
    mixin(generateFunQt(20006, "qteQUrl_delete",     "QNetworkAccessManager")); /// Удалить QUrl
    mixin(generateFunQt(20007, "qteQUrl_toString",   "QNetworkAccessManager")); /// Полное строковое представление URL
    mixin(generateFunQt(20008, "qteQUrl_isValid",    "QNetworkAccessManager")); /// Проверить синтаксическую корректность URL
    mixin(generateFunQt(20009, "qteQUrl_scheme",     "QNetworkAccessManager")); /// Извлечь схему (http, https, ftp, ...)
    mixin(generateFunQt(20010, "qteQUrl_host",       "QNetworkAccessManager")); /// Извлечь хост
    mixin(generateFunQt(20011, "qteQUrl_path",       "QNetworkAccessManager")); /// Извлечь путь
    mixin(generateFunQt(20012, "qteQUrl_port",       "QNetworkAccessManager")); /// Извлечь порт (-1 если не задан)
    // ── QNetworkRequest (индексы 20013–20018) ─────────────────────────────
    mixin(generateFunQt(20013, "qteQNetworkRequest_create",                       "QNetworkAccessManager")); /// Создать запрос с URL
    mixin(generateFunQt(20014, "qteQNetworkRequest_delete",                       "QNetworkAccessManager")); /// Удалить запрос
    mixin(generateFunQt(20015, "qteQNetworkRequest_setRawHeader",                 "QNetworkAccessManager")); /// Установить заголовок (имя + значение как UTF-16)
    mixin(generateFunQt(20016, "qteQNetworkRequest_setUrl",                       "QNetworkAccessManager")); /// Изменить URL запроса
    mixin(generateFunQt(20017, "qteQNetworkRequest_url",                          "QNetworkAccessManager")); /// Получить текущий URL запроса
    mixin(generateFunQt(20018, "qteQNetworkRequest_setAttribute_followRedirects", "QNetworkAccessManager")); /// Разрешить автоматическое следование редиректам
    // ── QNetworkReply (индексы 20019–20032) ───────────────────────────────
    mixin(generateFunQt(20019, "qteQNetworkReply_error",                    "QNetworkAccessManager")); /// Код ошибки (0 = NoError)
    mixin(generateFunQt(20020, "qteQNetworkReply_errorString",              "QNetworkAccessManager")); /// Текстовое описание ошибки
    mixin(generateFunQt(20021, "qteQNetworkReply_readAll",                  "QNetworkAccessManager")); /// Прочитать все доступные данные в QByteArray
    mixin(generateFunQt(20022, "qteQNetworkReply_statusCode",               "QNetworkAccessManager")); /// HTTP-статус ответа (200, 404, ...)
    mixin(generateFunQt(20023, "qteQNetworkReply_url",                      "QNetworkAccessManager")); /// Конечный URL (после редиректов)
    mixin(generateFunQt(20024, "qteQNetworkReply_rawHeader",                "QNetworkAccessManager")); /// Значение заголовка ответа по имени
    mixin(generateFunQt(20025, "qteQNetworkReply_deleteLater",              "QNetworkAccessManager")); /// Отложенное удаление через event loop
    mixin(generateFunQt(20026, "qteQNetworkReply_abort",                    "QNetworkAccessManager")); /// Прервать незавершённый запрос
    mixin(generateFunQt(20027, "qteQNetworkReply_bytesAvailable",           "QNetworkAccessManager")); /// Количество байт, доступных для чтения
    mixin(generateFunQt(20028, "qteQNetworkReply_isFinished",               "QNetworkAccessManager")); /// Завершён ли запрос
    mixin(generateFunQt(20029, "qteQNetworkReply_connect_finished",         "QNetworkAccessManager")); /// Сигнал: запрос завершён
    mixin(generateFunQt(20030, "qteQNetworkReply_connect_readyRead",        "QNetworkAccessManager")); /// Сигнал: доступны новые данные для чтения
    mixin(generateFunQt(20031, "qteQNetworkReply_connect_errorOccurred",    "QNetworkAccessManager")); /// Сигнал: произошла ошибка
    mixin(generateFunQt(20032, "qteQNetworkReply_connect_downloadProgress", "QNetworkAccessManager")); /// Сигнал: прогресс загрузки (received, total)
    // ── QNetworkAccessManager (индексы 20033–20041) ───────────────────────
    mixin(generateFunQt(20033, "qteQNetworkAccessManager_create",           "QNetworkAccessManager")); /// Создать менеджер (с родителем или без)
    mixin(generateFunQt(20034, "qteQNetworkAccessManager_delete",           "QNetworkAccessManager")); /// Удалить менеджер (только если D-owned)
    mixin(generateFunQt(20035, "qteQNetworkAccessManager_get",              "QNetworkAccessManager")); /// Отправить GET-запрос
    mixin(generateFunQt(20036, "qteQNetworkAccessManager_post",             "QNetworkAccessManager")); /// Отправить POST-запрос с телом QByteArray
    mixin(generateFunQt(20037, "qteQNetworkAccessManager_put",              "QNetworkAccessManager")); /// Отправить PUT-запрос с телом QByteArray
    mixin(generateFunQt(20038, "qteQNetworkAccessManager_deleteResource",   "QNetworkAccessManager")); /// Отправить DELETE-запрос
    mixin(generateFunQt(20039, "qteQNetworkAccessManager_head",             "QNetworkAccessManager")); /// Отправить HEAD-запрос
    mixin(generateFunQt(20040, "qteQNetworkAccessManager_setUseSystemProxy","QNetworkAccessManager")); /// Использовать системный прокси
    mixin(generateFunQt(20041, "qteQNetworkAccessManager_connect_finished", "QNetworkAccessManager")); /// Сигнал: любой ответ менеджера завершён
    // ── QNetworkReply extras (индексы 20042–20045) ─────────────────────────
    mixin(generateFunQt(20042, "qteQNetworkReply_ignoreSslErrors",          "QNetworkAccessManager")); /// Игнорировать SSL-ошибки сертификата
    mixin(generateFunQt(20043, "qteQNetworkReply_connect_sslErrors",        "QNetworkAccessManager")); /// Сигнал: SSL-ошибки при установлении соединения
    mixin(generateFunQt(20044, "qteQNetworkReply_connect_uploadProgress",   "QNetworkAccessManager")); /// Сигнал: прогресс отправки данных (sent, total)
    mixin(generateFunQt(20045, "qteQNetworkReply_rawHeaderList",            "QNetworkAccessManager")); /// Список имён заголовков ответа (через \x01)
}

/**
 * Статический конструктор модуля — регистрирует загрузчик в системе DLL.
 *
 * Вызывается один раз при старте программы. Функции DLL будут загружены
 * лениво при первом вызове LoadQt().
 */
static this() {
    registerModule("QNetworkAccessManager", "qte56_network.dll", &loadQNetwork);
}

// ============================================================
// QUrl — тип-значение, владелец D, ~this() удаляет объект
// ============================================================

/**
 * Обёртка над Qt QUrl.
 *
 * Представляет единственный URL: разбирает строку на компоненты (схема,
 * хост, путь, порт). Объект принадлежит D: деструктор вызывает
 * qteQUrl_delete через pFunQt[20006].
 *
 * Note: не передавайте объект Qt в качестве родителя — QUrl не является
 * QObject. Передавайте getPtr() туда, где нужен void* на QUrl.
 *
 * Example:
 * ---
 * auto u = new QUrl("https://example.com:8080/api");
 * assert(u.isValid());
 * assert(u.scheme() == "https");
 * assert(u.host()   == "example.com");
 * assert(u.port()   == 8080);
 * assert(u.path()   == "/api");
 * ---
 */
@live class QUrl {
private:
    void* _ptr; /// Указатель на C++ QUrl (выделен в куче DLL)

public:
    /**
     * Создаёт QUrl из D-строки (UTF-8 → UTF-16 для передачи в Qt).
     *
     * Params:
     *   url = строка URL в любом корректном формате Qt QUrl
     */
    this(string url) {
        wstring ws = url.toUTF16;
        _ptr = (cast(t_qp__qp_i)pFunQt[20005])(cast(void*)ws.ptr, cast(int)ws.length);
    }

    /**
     * Деструктор: освобождает C++ QUrl через DLL.
     *
     * Note: проверяет _ptr и наличие функции в таблице — безопасен
     * при вызове до загрузки DLL (например, при падении в конструкторе).
     */
    ~this() {
        if (_ptr !is null && pFunQt[20006] !is null) {
            (cast(t_v__qp)pFunQt[20006])(_ptr);
            _ptr = null;
        }
    }

    /**
     * Полное строковое представление URL.
     *
     * Returns: строка вида "https://host:port/path?query#fragment"
     */
    override string toString() { auto qs = (cast(t_qp__qp)pFunQt[20007])(_ptr); return _freeQs(qs); }

    /**
     * Проверяет синтаксическую корректность URL.
     *
     * Returns: true если URL синтаксически правильный (не проверяет доступность хоста)
     */
    bool    isValid()  { return (cast(t_i__qp)pFunQt[20008])(_ptr) != 0; }

    /**
     * Возвращает схему URL в нижнем регистре.
     *
     * Returns: "http", "https", "ftp", "file" и т.д.; "" если схема не задана
     */
    string  scheme()   { auto qs = (cast(t_qp__qp)pFunQt[20009])(_ptr); return _freeQs(qs); }

    /**
     * Возвращает хост из URL.
     *
     * Returns: "example.com", "192.168.1.1" и т.д.; "" если хост не задан
     */
    string  host()     { auto qs = (cast(t_qp__qp)pFunQt[20010])(_ptr); return _freeQs(qs); }

    /**
     * Возвращает путь из URL (без query string и фрагмента).
     *
     * Returns: "/api/v1/users" и т.д.; "" если путь не задан
     */
    string  path()     { auto qs = (cast(t_qp__qp)pFunQt[20011])(_ptr); return _freeQs(qs); }

    /**
     * Возвращает порт из URL.
     *
     * Returns: номер порта 1–65535, или -1 если порт явно не задан в строке URL
     */
    int     port()     { return (cast(t_i__qp)pFunQt[20012])(_ptr); }

    /// Возвращает сырой указатель на C++ QUrl для передачи в другие Qt-функции.
    void*   getPtr() { return _ptr; }
}

// ============================================================
// QNetworkRequest — тип-значение, владелец D, ~this() удаляет объект
// ============================================================

/**
 * Обёртка над Qt QNetworkRequest.
 *
 * Описывает один HTTP-запрос: URL, заголовки, атрибуты. Объект принадлежит D.
 * Передайте экземпляр в методы QNetworkAccessManager (get/post/put/...).
 *
 * Note: Qt копирует QNetworkRequest при вызове manager.get/post — исходный
 * D-объект можно уничтожать сразу после отправки запроса.
 *
 * Example:
 * ---
 * auto req = new QNetworkRequest("https://api.example.com/data");
 * req.setRawHeader("Accept", "application/json");
 * req.setFollowRedirects(true);
 * auto reply = mgr.get(req);
 * ---
 */
@live class QNetworkRequest {
private:
    void* _ptr; /// Указатель на C++ QNetworkRequest (выделен в куче DLL)

public:
    /**
     * Создаёт QNetworkRequest с заданным URL.
     *
     * Params:
     *   url = строка URL запроса (UTF-8, конвертируется в UTF-16 для Qt)
     */
    this(string url) {
        wstring ws = url.toUTF16;
        _ptr = (cast(t_qp__qp_i)pFunQt[20013])(cast(void*)ws.ptr, cast(int)ws.length);
    }

    /**
     * Деструктор: освобождает C++ QNetworkRequest через DLL.
     *
     * Note: безопасен при двойном вызове (проверяет _ptr != null).
     */
    ~this() {
        if (_ptr !is null && pFunQt[20014] !is null) {
            (cast(t_v__qp)pFunQt[20014])(_ptr);
            _ptr = null;
        }
    }

    /**
     * Устанавливает произвольный HTTP-заголовок запроса.
     *
     * Params:
     *   name  = имя заголовка (ASCII, например "Content-Type", "Authorization")
     *   value = значение заголовка (UTF-8)
     *
     * Note: оба параметра конвертируются в UTF-16 перед передачей в Qt.
     * Вызов с одним и тем же именем перезаписывает предыдущее значение.
     *
     * Example:
     * ---
     * req.setRawHeader("Content-Type", "application/json; charset=utf-8");
     * req.setRawHeader("Authorization", "Bearer " ~ token);
     * ---
     */
    QNetworkRequest setRawHeader(string name, string value) {
        wstring wn = name.toUTF16;
        wstring wv = value.toUTF16;
        (cast(t_v__qp_qp_i_qp_i)pFunQt[20015])(
            _ptr,
            cast(void*)wn.ptr, cast(int)wn.length,
            cast(void*)wv.ptr, cast(int)wv.length);
        return this;
    }

    /**
     * Изменяет URL запроса после создания объекта.
     *
     * Params:
     *   url = новый URL (UTF-8)
     */
    QNetworkRequest setUrl(string url) {
        wstring ws = url.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[20016])(_ptr, cast(void*)ws.ptr, cast(int)ws.length);
        return this;
    }

    /**
     * Возвращает текущий URL запроса.
     *
     * Returns: строка URL в том виде, в каком она задана в запросе
     */
    string url() { auto qs = (cast(t_qp__qp)pFunQt[20017])(_ptr); return _freeQs(qs); }

    /**
     * Разрешает или запрещает автоматическое следование HTTP 3xx-редиректам.
     *
     * Params:
     *   v = true — Qt автоматически переходит по Location-заголовку;
     *       false — редиректы не выполняются (по умолчанию в Qt 5)
     *
     * Note: соответствует QNetworkRequest::RedirectPolicyAttribute /
     * FollowRedirectsAttribute в Qt 5.13.
     */
    QNetworkRequest setFollowRedirects(bool v) {
        (cast(t_v__qp_i)pFunQt[20018])(_ptr, v ? 1 : 0);
        return this;
    }

    /// Возвращает сырой указатель на C++ QNetworkRequest.
    void* getPtr() { return _ptr; }
}

// ============================================================
// QNetworkReply — всегда принадлежит Qt; используйте wrap(),
//                 вызывайте deleteLater() после завершения
// ============================================================

/**
 * Обёртка над Qt QNetworkReply.
 *
 * Объект ВСЕГДА принадлежит Qt (создаётся менеджером, удаляется event loop).
 * Никогда не создавайте напрямую — только через QNetworkReply.wrap(ptr).
 * Никогда не вызывайте delete/destroy вручную — только deleteLater().
 *
 * Типичный сценарий использования:
 * ---
 * // Синхронное ожидание (spin loop через processEvents):
 * auto reply = mgr.get(req);
 * while (!reply.isFinished())
 *     app.processEvents();
 * string body = reply.readAllString();
 * reply.deleteLater();
 * ---
 *
 * Note: сигналы (connect_finished/connect_readyRead/...) используют прямые
 * колбэки без ESlot. Подпись: `extern(C) void cb(void* dthis, int n, ...)`.
 */
@live class QNetworkReply {
private:
    void* _wh;  /// Сырой указатель на C++ QNetworkReply (Qt-owned)

    /// Приватный конструктор — только через wrap()
    this() {}

public:
    /**
     * Оборачивает сырой C++ QNetworkReply* в D-объект.
     *
     * Params:
     *   p = указатель, возвращённый методами manager.get/post/put/...
     *
     * Returns: новый D-объект QNetworkReply без права владения (Qt-owned)
     */
    static QNetworkReply wrap(void* p) {
        auto r = new QNetworkReply();
        r._wh = p;
        return r;
    }
    // ~this() не определён: объект принадлежит Qt, вызывайте deleteLater() явно.

    /**
     * Код ошибки сетевого запроса.
     *
     * Returns: значение QNetworkReply::NetworkError; 0 = NoError (успех)
     *
     * Note: ненулевое значение означает сетевую/протокольную ошибку,
     * а не HTTP-ошибку (4xx/5xx) — для HTTP используйте statusCode().
     */
    int    error()          { return (cast(t_i__qp)pFunQt[20019])(_wh); }

    /**
     * Текстовое описание ошибки на английском.
     *
     * Returns: "" если ошибок нет, иначе строка вида "Connection refused"
     */
    string errorString()    { auto qs = (cast(t_qp__qp)pFunQt[20020])(_wh); return _freeQs(qs); }

    /**
     * Читает все доступные данные ответа в QByteArray.
     *
     * Returns: новый QByteArray, принадлежащий D — вызывайте ba.destroy() после использования.
     *
     * Note: вызывайте только после isFinished() == true или в обработчике
     * сигнала readyRead/finished. Повторный вызов вернёт пустой QByteArray.
     */
    QByteArray readAll() {
        void* p = (cast(t_qp__qp)pFunQt[20021])(_wh);
        return QByteArray.wrap(p);   // D владеет возвращённым QByteArray
    }

    /**
     * Удобный метод: читает все данные ответа как D-строку (UTF-8).
     *
     * Эквивалент: readAll() → toString() → destroy(). Экономит три строки кода.
     *
     * Returns: тело ответа как UTF-8 D string
     *
     * Note: если сервер вернул не текстовые данные (изображение, бинарный файл),
     * используйте readAll() и работайте с QByteArray напрямую.
     */
    string readAllString() {
        auto ba = readAll();
        scope(exit) ba.destroy();
        return ba.toString();   // QByteArray.toString() возвращает UTF-8 D string
    }

    /**
     * HTTP-статус ответа.
     *
     * Returns: целое число (200, 301, 404, 500 и т.д.); 0 если статус недоступен
     *
     * Note: статус доступен только после завершения запроса (isFinished() == true).
     */
    int    statusCode()     { return (cast(t_i__qp)pFunQt[20022])(_wh); }

    /**
     * Конечный URL ответа (после всех редиректов).
     *
     * Returns: строка URL; может отличаться от URL запроса при наличии 3xx-редиректов
     */
    string url()            { auto qs = (cast(t_qp__qp)pFunQt[20023])(_wh); return _freeQs(qs); }

    /**
     * Возвращает значение HTTP-заголовка ответа по имени.
     *
     * Params:
     *   name = имя заголовка (регистр не важен для HTTP/1.1, Qt нормализует)
     *
     * Returns: значение заголовка или "" если заголовок отсутствует
     *
     * Example:
     * ---
     * string ct = reply.rawHeader("Content-Type");   // "application/json"
     * string cl = reply.rawHeader("Content-Length"); // "1234"
     * ---
     */
    string rawHeader(string name) {
        wstring wn = name.toUTF16;
        auto qs = (cast(t_qp__qp_qp_i)pFunQt[20024])(
            _wh, cast(void*)wn.ptr, cast(int)wn.length);
        return _freeQs(qs);
    }

    /**
     * Планирует удаление объекта через event loop Qt.
     *
     * Вызывайте вместо delete/destroy. Qt удалит объект после возврата
     * управления в event loop. Безопасен из любого потока.
     *
     * Note: ОБЯЗАТЕЛЬНО вызывайте после завершения работы с reply,
     * иначе возникнет утечка памяти.
     */
    QNetworkReply deleteLater()      { (cast(t_v__qp)pFunQt[20025])(_wh); return this; }

    /**
     * Прерывает незавершённый сетевой запрос.
     *
     * Note: после abort() сигнал errorOccurred сработает с кодом
     * QNetworkReply::OperationCanceledError. Вызывайте deleteLater() после.
     */
    QNetworkReply abort()            { (cast(t_v__qp)pFunQt[20026])(_wh); return this; }

    /**
     * Количество байт, доступных для чтения прямо сейчас.
     *
     * Returns: число байт в буфере; -1 если запрос ещё не начался
     */
    int  bytesAvailable()   { return (cast(t_i__qp)pFunQt[20027])(_wh); }

    /**
     * Проверяет, завершён ли запрос (успешно или с ошибкой).
     *
     * Returns: true если Qt больше не ждёт данных от сервера
     */
    bool isFinished()       { return (cast(t_i__qp)pFunQt[20028])(_wh) != 0; }

    // ── Сигналы (прямые колбэки, без ESlot) ──────────────────────────────

    /**
     * Подключает колбэк на сигнал finished (запрос завершён).
     *
     * Params:
     *   dthis = указатель на D-объект, передаётся первым аргументом в cb
     *   n     = произвольный int-тег, передаётся вторым аргументом в cb
     *   cb    = extern(C) void cb(void* dthis, int n)
     *
     * Note: в момент вызова cb данные уже готовы — можно сразу вызывать readAll().
     */
    QNetworkReply connect_finished(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20029])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Подключает колбэк на сигнал readyRead (новые данные для чтения).
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n)
     *
     * Note: сигнал может срабатывать многократно до finished при потоковой
     * передаче (chunked transfer). Используйте bytesAvailable() для порционного чтения.
     */
    QNetworkReply connect_readyRead(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20030])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Подключает колбэк на сигнал errorOccurred (ошибка сети или протокола).
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n, int errorCode)
     *           errorCode — значение QNetworkReply::NetworkError
     *
     * Note: после errorOccurred сигнал finished тоже сработает — не вызывайте
     * deleteLater() дважды.
     */
    QNetworkReply connect_errorOccurred(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20031])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Подключает колбэк на сигнал downloadProgress (прогресс загрузки).
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n, long received, long total)
     *           received — загружено байт; total — ожидаемый размер (-1 если неизвестен)
     *
     * Note: D `long` = 64-бит на Win32 и Linux64, соответствует C `long long` —
     * приведений типов не требуется ни на одной из платформ.
     */
    QNetworkReply connect_downloadProgress(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20032])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Отключает проверку SSL-сертификата сервера.
     *
     * Note: используйте только для отладки или при работе с самоподписанными
     * сертификатами во внутренних сетях. В продакшене это небезопасно.
     * Вызывайте ДО отправки запроса или в обработчике connect_sslErrors.
     */
    QNetworkReply ignoreSslErrors() { (cast(t_v__qp)pFunQt[20042])(_wh); return this; }

    /**
     * Подключает колбэк на сигнал sslErrors (ошибки SSL-соединения).
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n, int errorCount)
     *           errorCount — количество SSL-ошибок в списке
     *
     * Note: в обработчике можно вызвать ignoreSslErrors() чтобы продолжить
     * несмотря на ошибки.
     */
    QNetworkReply connect_sslErrors(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20043])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Подключает колбэк на сигнал uploadProgress (прогресс отправки данных).
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n, long sent, long total)
     *           sent — отправлено байт; total — полный размер тела (-1 если неизвестен)
     *
     * Note: актуален для POST/PUT с большим телом. `long` = 64-бит на обеих платформах.
     */
    QNetworkReply connect_uploadProgress(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20044])(_wh, cb, dthis, n);
        return this;
    }

    /**
     * Возвращает список имён заголовков ответа.
     *
     * C++ сторона соединяет имена через символ `\x01` в одну строку Qt,
     * D сторона разбивает по `\x01` и возвращает массив.
     *
     * Returns: массив строк с именами заголовков (например ["Content-Type",
     *          "Content-Length", "Server"]), или [] если заголовков нет
     *
     * Example:
     * ---
     * foreach (name; reply.rawHeaderList())
     *     writeln(name, ": ", reply.rawHeader(name));
     * ---
     */
    string[] rawHeaderList() {
        import std.string : split;
        void* qs = (cast(t_qp__qp)pFunQt[20045])(_wh);
        string s = _freeQs(qs);
        if (s.length == 0) return [];
        return s.split('\x01');
    }

    /// Возвращает сырой Qt-указатель (для передачи в другие функции).
    void* getWH() { return _wh; }
}

// ============================================================
// QNetworkAccessManager — QObject; parent может быть null или win.getWH()
// ============================================================

/**
 * Обёртка над Qt QNetworkAccessManager.
 *
 * Центральный объект для отправки HTTP/HTTPS-запросов. Все методы
 * (get/post/put/deleteResource/head) возвращают Qt-owned QNetworkReply.
 *
 * Владение: если передан parent != null, объект принадлежит Qt (Qt-owned).
 * Если parent == null, объект принадлежит D и удаляется деструктором.
 *
 * Note: на одно приложение обычно создаётся один менеджер и переиспользуется
 * для всех запросов — Qt поддерживает пул соединений внутри.
 *
 * Example:
 * ---
 * auto mgr = new QNetworkAccessManager();
 * auto req = new QNetworkRequest("https://httpbin.org/get");
 * auto reply = mgr.get(req);
 * while (!reply.isFinished())
 *     app.processEvents();
 * writeln(reply.statusCode());      // 200
 * writeln(reply.readAllString());   // JSON-ответ
 * reply.deleteLater();
 * ---
 */
@live class QNetworkAccessManager {
private:
    void* _wh;       /// Сырой указатель на C++ QNetworkAccessManager
    bool  _qt_owned; /// true если Qt владеет объектом (parent != null)

public:
    /**
     * Создаёт QNetworkAccessManager.
     *
     * Params:
     *   parent = родительский QObject (win.getWH()) или null.
     *            При parent != null Qt управляет временем жизни объекта;
     *            при parent == null D-деструктор вызывает delete через DLL.
     */
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[20033])(parent);
    }

    /**
     * Деструктор: удаляет C++ объект если он принадлежит D (parent == null).
     *
     * Note: при _qt_owned == true удаление пропускается — Qt сам уничтожит
     * объект при удалении родителя.
     */
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[20034] !is null) {
            (cast(t_v__qp)pFunQt[20034])(_wh);
            _wh = null;
        }
    }

    /**
     * Отправляет HTTP GET-запрос.
     *
     * Params:
     *   req = объект запроса с URL и заголовками
     *
     * Returns: Qt-owned QNetworkReply; вызовите deleteLater() после использования
     */
    QNetworkReply get(QNetworkRequest req) {
        void* p = (cast(t_qp__qp_qp)pFunQt[20035])(_wh, req.getPtr());
        return QNetworkReply.wrap(p);
    }

    /**
     * Отправляет HTTP POST-запрос с бинарным телом QByteArray.
     *
     * Params:
     *   req  = объект запроса (обычно содержит Content-Type в заголовках)
     *   body = тело запроса как QByteArray (D-owned)
     *
     * Returns: Qt-owned QNetworkReply
     *
     * Note: Qt копирует данные из body — можно уничтожать ba после вызова.
     */
    QNetworkReply post(QNetworkRequest req, QByteArray body) {
        void* p = (cast(t_qp__qp_qp_qp)pFunQt[20036])(_wh, req.getPtr(), body.getWH());
        return QNetworkReply.wrap(p);
    }

    /**
     * Удобный метод: HTTP POST с телом в виде D-строки (UTF-8).
     *
     * Создаёт временный QByteArray из строки, вызывает post() и уничтожает QByteArray.
     *
     * Params:
     *   req  = объект запроса
     *   body = строка тела запроса (UTF-8)
     *
     * Returns: Qt-owned QNetworkReply
     *
     * Example:
     * ---
     * req.setRawHeader("Content-Type", "application/json");
     * auto reply = mgr.postString(req, `{"key":"value"}`);
     * ---
     */
    QNetworkReply postString(QNetworkRequest req, string body) {
        auto ba = new QByteArray(body);
        scope(exit) ba.destroy();
        return post(req, ba);
    }

    /**
     * Отправляет HTTP PUT-запрос с бинарным телом QByteArray.
     *
     * Params:
     *   req  = объект запроса
     *   body = тело запроса как QByteArray
     *
     * Returns: Qt-owned QNetworkReply
     */
    QNetworkReply put(QNetworkRequest req, QByteArray body) {
        void* p = (cast(t_qp__qp_qp_qp)pFunQt[20037])(_wh, req.getPtr(), body.getWH());
        return QNetworkReply.wrap(p);
    }

    /**
     * Отправляет HTTP DELETE-запрос.
     *
     * Params:
     *   req = объект запроса с URL ресурса для удаления
     *
     * Returns: Qt-owned QNetworkReply
     */
    QNetworkReply deleteResource(QNetworkRequest req) {
        void* p = (cast(t_qp__qp_qp)pFunQt[20038])(_wh, req.getPtr());
        return QNetworkReply.wrap(p);
    }

    /**
     * Отправляет HTTP HEAD-запрос (только заголовки, без тела).
     *
     * Params:
     *   req = объект запроса
     *
     * Returns: Qt-owned QNetworkReply (тело всегда пустое)
     *
     * Note: используйте для проверки существования ресурса или получения
     * метаданных (Content-Length, Last-Modified) без скачивания тела.
     */
    QNetworkReply head(QNetworkRequest req) {
        void* p = (cast(t_qp__qp_qp)pFunQt[20039])(_wh, req.getPtr());
        return QNetworkReply.wrap(p);
    }

    /**
     * Включает использование системного прокси-сервера.
     *
     * На Linux читает переменные окружения http_proxy / https_proxy.
     * На Windows использует системные настройки из Internet Explorer / WinINET.
     *
     * Note: вызывайте один раз до отправки первого запроса.
     */
    QNetworkAccessManager setUseSystemProxy() {
        (cast(t_v__qp)pFunQt[20040])(_wh);
        return this;
    }

    /**
     * Подключает колбэк на сигнал finished менеджера.
     *
     * Срабатывает когда ЛЮБОЙ QNetworkReply, созданный этим менеджером,
     * завершается. Удобен для централизованной обработки ответов.
     *
     * Params:
     *   dthis = указатель на D-объект
     *   n     = произвольный int-тег
     *   cb    = extern(C) void cb(void* dthis, int n, void* replyPtr)
     *           replyPtr — сырой Qt-указатель на завершённый reply;
     *           оборачивайте через QNetworkReply.wrap(replyPtr) внутри cb
     *
     * Note: в отличие от reply.connect_finished, этот сигнал даёт доступ
     * к указателю на reply, что позволяет идентифицировать запрос.
     */
    QNetworkAccessManager connect_finished(void* dthis, int n, void* cb) {
        (cast(t_v__qp_qp_qp_i)pFunQt[20041])(_wh, cb, dthis, n);
        return this;
    }

    /// Возвращает сырой Qt-указатель (для передачи в другие Qt-функции).
    void* getWH() { return _wh; }

    /**
     * Передаёт право владения объектом Qt (помечает как Qt-owned).
     *
     * После вызова D-деструктор не будет удалять C++ объект.
     * Используйте если передали менеджер в Qt-виджет как дочерний объект.
     */
    void  disown() { _qt_owned = true; }
}

// ── Приватный вспомогательный метод ──────────────────────────────────────

/**
 * Конвертирует возвращённый QString* в D-строку и освобождает память Qt.
 *
 * Все публичные методы, возвращающие строки, используют этот хелпер:
 * C++ DLL возвращает `new QString(...)`, D читает его через fromQString(),
 * затем удаляет через pFunQt[22] (qteQString_free).
 *
 * Params:
 *   qs = указатель на C++ QString, выделенный DLL; может быть null
 *
 * Returns: D-строка (UTF-8); "" если qs == null
 *
 * Note: pFunQt[22] — это qteQString_free, общий для всех модулей индекс
 * в блоке QCore (1–76).
 */
private string _freeQs(void* qs) {
    import gen_qcore : t_v__qp;
    if (qs is null) return "";
    string s = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);   // qteQString_free — освобождаем QString из DLL
    return s;
}

// ── unittest ──────────────────────────────────────────────────────────────

/**
 * Модульные тесты для gen_qnetwork.
 *
 * Note: полное интеграционное тестирование (реальные HTTP-запросы,
 * SSL, сигналы) находится в test/test_net_utils.d и требует загруженной
 * DLL qte56_network.dll.
 *
 * Здесь тестируется только чистая D-логика, не требующая DLL:
 * разбиение \x01-строки, которую rawHeaderList() использует внутри.
 * Именно этот же код (`s.split('\x01')`) выполняется на пути D после
 * получения склеенной строки из C++.
 */
unittest {
    import std.string : split;
    import std.conv   : to;

    // ── Тест 1: разбиение типичной \x01-строки заголовков ──────────────────
    {
        string joined = "Content-Type\x01Content-Length\x01Server";
        string[] headers = joined.split('\x01');
        assert(headers.length == 3,
               "rawHeaderList: ожидалось 3 элемента, получено " ~
               to!string(headers.length));
        assert(headers[0] == "Content-Type");
        assert(headers[1] == "Content-Length");
        assert(headers[2] == "Server");
    }

    // ── Тест 2: пустая строка → пустой массив (ветка `if (s.length == 0)`) ─
    {
        string empty = "";
        // rawHeaderList() возвращает [] без вызова split при пустой строке
        string[] result = (empty.length == 0) ? [] : empty.split('\x01');
        assert(result.length == 0,
               "rawHeaderList: пустая строка должна давать пустой массив");
    }

    // ── Тест 3: один заголовок без разделителя ─────────────────────────────
    {
        string single = "X-Custom-Header";
        string[] headers = single.split('\x01');
        assert(headers.length == 1);
        assert(headers[0] == "X-Custom-Header");
    }

    // ── Тест 4: заголовки содержат кириллицу (нестандартные значения) ───────
    {
        string joined = "X-Ru-Header\x01X-Another";
        string[] headers = joined.split('\x01');
        assert(headers.length == 2);
        assert(headers[0] == "X-Ru-Header");
        assert(headers[1] == "X-Another");
    }

    // ── Тест 5: многие заголовки (типичный HTTP/1.1 ответ) ──────────────────
    {
        string[] expected = [
            "Date", "Content-Type", "Content-Length",
            "Connection", "Server", "X-Request-Id"
        ];
        import std.array : join;
        string joined = expected.join('\x01');
        string[] got = joined.split('\x01');
        assert(got == expected,
               "rawHeaderList: несоответствие при разбиении 6 заголовков");
    }
}
