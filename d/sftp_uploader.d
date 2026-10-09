/**
 * d/sftp_uploader.d — обёртка над CurlSession для SFTP-загрузки файла.
 *
 * Объединяет в одной функции построение URL, авторизацию, отключение
 * known_hosts (для прототипа — без strict host key checking) и обработку ошибок.
 *
 * $(B Зависимости:) qte56_curl.dll должен быть загружен (LoadQt) ДО вызова.
 *
 * Минимальный пример:
 * ---
 * import sftp_uploader;
 *
 * string err;
 * bool ok = sftpUpload(
 *     SftpConfig(
 *         "ndt-rus.ru", 22,
 *         "mgwndtrusru", "mypassword",
 *         "/home/mgwndtrusru/sert.csv"),
 *     "./sert.csv",
 *     err);
 *
 * if (!ok) writeln("SFTP failed: ", err);
 * ---
 */
module sftp_uploader;

import std.conv   : to;
import std.string : startsWith;

import curl_utils : CurlSession;

/**
 * Параметры подключения к SFTP-серверу.
 */
struct SftpConfig {
    string host;          /// hostname или IP
    int    port = 22;     /// SSH/SFTP порт
    string user;          /// логин
    string password;      /// пароль (для прототипа); ключи не используются
    string remotePath;    /// абсолютный путь к файлу на сервере (`/home/u/sert.csv`)

    /// Сформировать URL для CurlSession.
    string url() const {
        // sftp://user@host:port/path  (без пароля в URL — он передаётся через USERPWD)
        // remotePath может начинаться с '/' или нет — нормализуем
        string p = remotePath;
        if (p.length == 0 || p[0] != '/') p = "/" ~ p;
        return "sftp://" ~ host ~ ":" ~ port.to!string ~ p;
    }
}

/**
 * Загружает локальный файл на SFTP-сервер.
 *
 * Params:
 *   cfg       = параметры соединения и удалённый путь.
 *   localPath = путь к локальному файлу-источнику.
 *   error     = выходной параметр: текст ошибки libcurl при неудаче.
 *
 * Returns: true при успехе, false при любой ошибке (libcurl rc != 0).
 *
 * $(B Поведение известных тонкостей:)
 * $(UL
 *   $(LI known_hosts проверка ОТКЛЮЧЕНА (insecure для прототипа). Для продакшена
 *        раскомментировать вызов `.knownHosts("./known_hosts")` или передать
 *        ожидаемый MD5/SHA256 fingerprint через `.sshHostKey(...)` после
 *        соответствующего расширения CurlSession.)
 *   $(LI Файл на сервере перезаписывается. Нет промежуточного `.tmp` + rename.)
 *   $(LI Таймаут 60 секунд — для маленьких файлов (1-2 МБ) с запасом.)
 * )
 */
bool sftpUpload(in SftpConfig cfg, string localPath, out string error) {
    auto c = new CurlSession();
    if (c.getHandle() is null) {
        error = "qte56_curl.dll не загружен (LoadQt('./dll'))";
        return false;
    }

    c.auth(cfg.user, cfg.password)
     .timeout(60)
     .skipSsl();             // отключаем strict host key + SSL-сертификат (для прототипа)

    bool ok = c.upload(localPath, cfg.url());
    if (!ok) {
        error = c.error;
        if (error.length == 0) error = "SFTP upload failed (rc != 0)";
    }
    destroy(c);  // детерминированное освобождение — не ждём GC-финализатор
    return ok;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты (только проверка построения URL, без сетевых вызовов)
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    auto cfg = SftpConfig("ndt-rus.ru", 22, "user", "pass", "/home/user/sert.csv");
    assert(cfg.url() == "sftp://ndt-rus.ru:22/home/user/sert.csv");

    // путь без ведущего слеша — нормализуется
    auto cfg2 = SftpConfig("host", 2222, "u", "p", "sert.csv");
    assert(cfg2.url() == "sftp://host:2222/sert.csv");

    // пустой remotePath
    auto cfg3 = SftpConfig("host", 22, "u", "p", "");
    assert(cfg3.url() == "sftp://host:22/");
}
