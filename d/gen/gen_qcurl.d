/**
 * gen_qcurl.d — низкоуровневая обёртка над qte56_curl.dll для D.
 *
 * Этот модуль является внутренним (machine-generated-style) и предназначен
 * только для использования из curl_utils.d. Прямое использование не рекомендуется.
 *
 * Тесты: $(D test/test_curl.d) — косвенно, через curl_utils.d.
 *
 * Что делает модуль:
 *   - Регистрирует DLL "qte56_curl.dll" в системе qte56_loader через static this().
 *   - При загрузке DLL заполняет таблицу указателей pFunQt[20046..20072].
 *   - Сразу вызывает qteCurl_globalInit() для загрузки libcurl внутри DLL.
 *   - Предоставляет package-функции _curl_* для curl_utils.d.
 *
 * Индексный блок: 20046–20072 (следующий свободный: 20073).
 *
 * Соответствие индексов функциям DLL:
 *   20046  qteCurl_globalInit        — загружает libcurl.dll/so внутри DLL
 *   20047  qteCurl_globalCleanup     — выгружает libcurl
 *   20048  qteCurl_create            — создаёт CurlSession (→ void*)
 *   20049  qteCurl_destroy           — уничтожает CurlSession
 *   20050  qteCurl_setUrl            — задаёт URL (wchar*, len)
 *   20051  qteCurl_setUser           — имя пользователя
 *   20052  qteCurl_setPassword       — пароль
 *   20053  qteCurl_setSslVerify      — проверка SSL-сертификата (0/1)
 *   20054  qteCurl_setCaInfo         — путь к cacert.pem
 *   20055  qteCurl_setSshPrivateKey  — путь к приватному SSH-ключу
 *   20056  qteCurl_setSshPublicKey   — путь к публичному SSH-ключу
 *   20057  qteCurl_setKnownHosts     — путь к файлу known_hosts
 *   20058  qteCurl_setTimeout        — таймаут в секундах (int)
 *   20059  qteCurl_setFollowRedirects — следовать редиректам (0/1)
 *   20060  qteCurl_setVerbose        — отладочный вывод в stderr (0/1)
 *   20061  qteCurl_setMethod         — HTTP-метод (wchar*, len)
 *   20062  qteCurl_setPostBody       — тело POST/PUT (wchar*, len)
 *   20063  qteCurl_addHeader         — добавить заголовок "Name: Value"
 *   20064  qteCurl_clearHeaders      — очистить все добавленные заголовки
 *   20065  qteCurl_setUploadFile     — локальный файл для загрузки (upload)
 *   20066  qteCurl_setDownloadFile   — локальный файл для скачивания
 *   20067  qteCurl_perform           — выполнить запрос → CURLcode (int)
 *   20068  qteCurl_getBody           — тело ответа (const char*, UTF-8)
 *   20069  qteCurl_getStatusCode     — HTTP/FTP-статус (int)
 *   20070  qteCurl_getError          — описание ошибки (const char*)
 *   20071  qteCurl_getTransferSize   — байт передано (long long)
 *   20072  qteCurl_reset             — сброс всех опций сессии
 *
 * Примечание о строках:
 *   D-сторона всегда передаёт wstring (2-байтовый UTF-16), что соответствует
 *   функциям с сигнатурой (void* h, const wchar_t* str, int len) в C++.
 *   На Linux wchar_t = 4 байта, поэтому C++ использует QString::fromUtf16()
 *   вместо fromWCharArray() для корректной интерпретации 2-байтовых данных.
 */
module gen_qcurl;

import std.utf    : toUTF16;       // конвертация D string (UTF-8) → wstring (UTF-16)
import std.string : fromStringz;   // const(char)* → D string (нулевой терминатор)

import qte56_core;                 // pFunQt[], generateAlias, generateFunQt
import qte56_loader : loadFn, registerModule;  // регистрация DLL

// Импортируем типы функций из gen_qcore, чтобы не дублировать их здесь:
//   t_v__qp      = void function(void*)              — destroy, reset
//   t_v__qp_i    = void function(void*, int)          — setSslVerify, setTimeout...
//   t_v__qp_qp_i = void function(void*, void*, int)   — setUrl, setUser... (wchar-строки)
//   t_qp__       = void* function()                   — create
//   t_i__qp      = int function(void*)                — perform, getStatusCode
import gen_qcore : t_v__qp, t_v__qp_i, t_v__qp_qp_i,
                   t_qp__, t_i__qp;


// ══════════════════════════════════════════════════════════════════════════════
// Дополнительные псевдонимы типов функций
// ══════════════════════════════════════════════════════════════════════════════

/// void function() — для globalInit / globalCleanup (без аргументов)
private alias t_v__ = extern(C) void function();

/// const(char)* function(void*) — для getBody / getError (возвращают C-строку)
/// Указатель действителен до следующего вызова perform() или reset().
private alias t_cp__qp = extern(C) const(char)* function(void*);

/// long function(void*) — для getTransferSize (64-бит на обеих платформах)
private alias t_ll__qp = extern(C) long function(void*);


// ══════════════════════════════════════════════════════════════════════════════
// Загрузка DLL: регистрация адресов всех функций в pFunQt[]
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Вызывается системой qte56_loader при первом вызове LoadQt().
 * Заполняет pFunQt[20046..20072] адресами функций из qte56_curl.dll.
 * После заполнения немедленно вызывает globalInit для загрузки libcurl.
 */
void loadQCurl() {
    // Каждый mixin вызывает GetProcAddress/dlsym и сохраняет результат в pFunQt[N]
    mixin(generateFunQt(20046, "qteCurl_globalInit",      "QCurl"));
    mixin(generateFunQt(20047, "qteCurl_globalCleanup",   "QCurl"));
    mixin(generateFunQt(20048, "qteCurl_create",          "QCurl"));
    mixin(generateFunQt(20049, "qteCurl_destroy",         "QCurl"));
    mixin(generateFunQt(20050, "qteCurl_setUrl",          "QCurl"));
    mixin(generateFunQt(20051, "qteCurl_setUser",         "QCurl"));
    mixin(generateFunQt(20052, "qteCurl_setPassword",     "QCurl"));
    mixin(generateFunQt(20053, "qteCurl_setSslVerify",    "QCurl"));
    mixin(generateFunQt(20054, "qteCurl_setCaInfo",       "QCurl"));
    mixin(generateFunQt(20055, "qteCurl_setSshPrivateKey","QCurl"));
    mixin(generateFunQt(20056, "qteCurl_setSshPublicKey", "QCurl"));
    mixin(generateFunQt(20057, "qteCurl_setKnownHosts",   "QCurl"));
    mixin(generateFunQt(20058, "qteCurl_setTimeout",      "QCurl"));
    mixin(generateFunQt(20059, "qteCurl_setFollowRedirects","QCurl"));
    mixin(generateFunQt(20060, "qteCurl_setVerbose",      "QCurl"));
    mixin(generateFunQt(20061, "qteCurl_setMethod",       "QCurl"));
    mixin(generateFunQt(20062, "qteCurl_setPostBody",     "QCurl"));
    mixin(generateFunQt(20063, "qteCurl_addHeader",       "QCurl"));
    mixin(generateFunQt(20064, "qteCurl_clearHeaders",    "QCurl"));
    mixin(generateFunQt(20065, "qteCurl_setUploadFile",   "QCurl"));
    mixin(generateFunQt(20066, "qteCurl_setDownloadFile", "QCurl"));
    mixin(generateFunQt(20067, "qteCurl_perform",         "QCurl"));
    mixin(generateFunQt(20068, "qteCurl_getBody",         "QCurl"));
    mixin(generateFunQt(20069, "qteCurl_getStatusCode",   "QCurl"));
    mixin(generateFunQt(20070, "qteCurl_getError",        "QCurl"));
    mixin(generateFunQt(20071, "qteCurl_getTransferSize", "QCurl"));
    mixin(generateFunQt(20072, "qteCurl_reset",           "QCurl"));

    // Сразу инициализируем libcurl внутри DLL — загружает libcurl.dll/so
    // и вызывает curl_global_init(CURL_GLOBAL_DEFAULT)
    (cast(t_v__)pFunQt[20046])();
}

/**
 * static this() регистрирует модуль в системе загрузки при первом импорте.
 * Реальная загрузка происходит позже — при вызове LoadQt("./dll").
 * На Linux DLL-имя автоматически преобразуется в libqte56_curl.so.
 */
static this() {
    registerModule("QCurl", "qte56_curl.dll", &loadQCurl);
}


// ══════════════════════════════════════════════════════════════════════════════
// Низкоуровневые хелперы — используются только из curl_utils.d
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Передаёт строку D в C++ как (void* h, wchar_t* ptr, int length).
 *
 * D wstring всегда 2-байтовый UTF-16 на любой платформе.
 * C++ принимает его через QString::fromUtf16(), что корректно на Linux
 * (где wchar_t = 4 байта, поэтому fromWCharArray() не используется).
 *
 * Params:
 *   idx = индекс функции в pFunQt (например 20050 для setUrl).
 *   h   = указатель на CurlSession в DLL.
 *   s   = строка D в кодировке UTF-8 (будет конвертирована в UTF-16).
 */
public void _curl_wset(int idx, void* h, string s) {
    wstring ws = s.toUTF16;   // конвертируем UTF-8 → UTF-16 (2 байта/символ)
    (cast(t_v__qp_qp_i)pFunQt[idx])(h, cast(void*)ws.ptr, cast(int)ws.length);
}

/**
 * Создаёт новый дескриптор CurlSession в DLL.
 * Возвращает непрозрачный указатель; null если libcurl не загружена.
 */
public void* _curl_create() {
    return (cast(t_qp__)pFunQt[20048])();
}

/**
 * Уничтожает дескриптор CurlSession, освобождает всю память DLL.
 * После вызова указатель h становится недействительным.
 */
public void _curl_destroy(void* h) {
    (cast(t_v__qp)pFunQt[20049])(h);
}

/**
 * Выполняет запрос с текущими настройками сессии.
 * Блокирует поток до завершения.
 * Returns: CURLcode: 0 = успех, иначе код ошибки libcurl.
 */
public int _curl_perform(void* h) {
    return (cast(t_i__qp)pFunQt[20067])(h);
}

/**
 * Возвращает тело ответа как D-строку (копия через idup).
 * Указатель C++ действителен до следующего perform() или reset().
 * Возвращает "" если указатель null.
 */
public string _curl_body(void* h) {
    auto p = (cast(t_cp__qp)pFunQt[20068])(h);
    return p ? p.fromStringz.idup : "";
}

/**
 * Возвращает HTTP/FTP-статус последнего выполненного запроса.
 * Примеры: 200 (HTTP OK), 226 (FTP transfer complete), 0 (не применимо).
 */
public int _curl_status(void* h) {
    return (cast(t_i__qp)pFunQt[20069])(h);
}

/**
 * Возвращает текстовое описание последней ошибки libcurl (копия через idup).
 * Пустая строка если последний запрос завершился успешно.
 */
public string _curl_error(void* h) {
    auto p = (cast(t_cp__qp)pFunQt[20070])(h);
    return p ? p.fromStringz.idup : "";
}

/**
 * Возвращает количество байт, переданных в последнем запросе (64-бит).
 * Для download: байт принято; для upload: байт отправлено.
 */
public long _curl_size(void* h) {
    return (cast(t_ll__qp)pFunQt[20071])(h);
}

/**
 * Сбрасывает все опции сессии до значений по умолчанию.
 * Дескриптор CURL сохраняется и может использоваться повторно.
 * Замечание: CA-файл также сбрасывается; curl_utils.d восстанавливает его
 * в "./dll/cacert.pem" после вызова этого хелпера.
 */
public void _curl_reset(void* h) {
    (cast(t_v__qp)pFunQt[20072])(h);
}

/**
 * Устанавливает целочисленный параметр сессии.
 * Используется для флагов и числовых опций: setSslVerify, setTimeout,
 * setFollowRedirects, setVerbose, clearHeaders.
 *
 * Params:
 *   idx = индекс функции в pFunQt (20053–20064).
 *   h   = указатель на CurlSession в DLL.
 *   v   = целочисленное значение параметра.
 */
public void _curl_set_i(int idx, void* h, int v) {
    (cast(t_v__qp_i)pFunQt[idx])(h, v);
}
