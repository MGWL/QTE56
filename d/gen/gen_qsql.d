/**
 * gen_qsql.d — D wrapper for Qt SQL (hybrid approach).
 * Module: QSql | DLL: qte56_sql.dll
 * MANUALLY WRITTEN
 *
 * Index block: 19100–19132
 *
 * QSqlDatabase (via QteDbConn) + QSqlQuery.
 * QVariant hidden in C++ — D gets typed bindInt/valueString etc.
 * Supports SQLite, ODBC, PostgreSQL — switch by driver string.
 *
 * Usage:
 *   auto db = QSqlDatabase.openSqlite("mydb.sqlite");
 *   auto q = new QSqlQuery(db);
 *   q.exec("CREATE TABLE t (id INTEGER PRIMARY KEY, name TEXT)");
 *   q.prepare("INSERT INTO t (name) VALUES (?)");
 *   q.bindString(0, "hello");
 *   q.execPrepared();
 *   q.exec("SELECT * FROM t");
 *   while (q.next()) {
 *       writefln("%d %s", q.valueInt(0), q.valueString(1));
 *   }
 */
module gen_qsql;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_i, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for QSql:
mixin(generateAlias("qp__qp_qp_qp_i_qp_qp")); // dbOpen(driver,dbName,host,port,user,pass)
mixin(generateAlias("v__qp_i_l"));    // bindLong
mixin(generateAlias("v__qp_i_d"));    // bindDouble
mixin(generateAlias("i__qp_i"));      // valueInt, isNull
mixin(generateAlias("l__qp_i"));      // valueLong
mixin(generateAlias("d__qp_i"));      // valueDouble
mixin(generateAlias("l__qp"));        // lastInsertId

// ====================================================================
// Load function addresses
// ====================================================================

static this() { registerModule("QSql", "qte56_sql.dll", &loadQSql); }

void loadQSql() {
    // Database (19100–19109)
    mixin(generateFunQt(19100, "qteQSql_dbOpen",        "QSql"));
    mixin(generateFunQt(19101, "qteQSql_dbClose",       "QSql"));
    mixin(generateFunQt(19102, "qteQSql_dbIsOpen",      "QSql"));
    mixin(generateFunQt(19103, "qteQSql_dbLastError",   "QSql"));
    mixin(generateFunQt(19104, "qteQSql_dbTransaction", "QSql"));
    mixin(generateFunQt(19105, "qteQSql_dbCommit",      "QSql"));
    mixin(generateFunQt(19106, "qteQSql_dbRollback",    "QSql"));
    mixin(generateFunQt(19107, "qteQSql_dbTables",      "QSql"));
    mixin(generateFunQt(19108, "qteQSql_dbDriverName",  "QSql"));
    mixin(generateFunQt(19109, "qteQSql_addPluginPath", "QSql"));
    // Query (19110–19132)
    mixin(generateFunQt(19110, "qteQSql_qCreate",          "QSql"));
    mixin(generateFunQt(19111, "qteQSql_qDelete",          "QSql"));
    mixin(generateFunQt(19112, "qteQSql_qExec",            "QSql"));
    mixin(generateFunQt(19113, "qteQSql_qPrepare",         "QSql"));
    mixin(generateFunQt(19114, "qteQSql_qExecPrepared",    "QSql"));
    mixin(generateFunQt(19115, "qteQSql_qBindInt",         "QSql"));
    mixin(generateFunQt(19116, "qteQSql_qBindLong",        "QSql"));
    mixin(generateFunQt(19117, "qteQSql_qBindDouble",      "QSql"));
    mixin(generateFunQt(19118, "qteQSql_qBindString",      "QSql"));
    mixin(generateFunQt(19134, "qteQSql_qBindBytes",       "QSql"));
    mixin(generateFunQt(19119, "qteQSql_qBindNull",        "QSql"));
    mixin(generateFunQt(19120, "qteQSql_qNext",            "QSql"));
    mixin(generateFunQt(19121, "qteQSql_qValueInt",        "QSql"));
    mixin(generateFunQt(19122, "qteQSql_qValueLong",       "QSql"));
    mixin(generateFunQt(19123, "qteQSql_qValueDouble",     "QSql"));
    mixin(generateFunQt(19124, "qteQSql_qValueString",     "QSql"));
    mixin(generateFunQt(19133, "qteQSql_qValueBytes",      "QSql"));
    mixin(generateFunQt(19125, "qteQSql_qIsNull",          "QSql"));
    mixin(generateFunQt(19126, "qteQSql_qNumRows",         "QSql"));
    mixin(generateFunQt(19127, "qteQSql_qNumCols",         "QSql"));
    mixin(generateFunQt(19128, "qteQSql_qFieldName",       "QSql"));
    mixin(generateFunQt(19129, "qteQSql_qLastError",       "QSql"));
    mixin(generateFunQt(19130, "qteQSql_qLastInsertId",    "QSql"));
    mixin(generateFunQt(19131, "qteQSql_qNumRowsAffected", "QSql"));
    mixin(generateFunQt(19132, "qteQSql_qClear",           "QSql"));
}

// ====================================================================
// QSqlDatabase
// ====================================================================

@live class QSqlDatabase {
private:
    void* _ptr; // QteDbConn*

public:
    /// Full constructor: open database with explicit driver/connection params.
    this(string driver, string dbName,
         string host = "", int port = 0,
         string user = "", string pass = "")
    {
        auto _wd = toQString(driver);
        auto _wn = toQString(dbName);
        auto _wh = toQString(host);
        auto _wu = toQString(user);
        auto _wp = toQString(pass);
        _ptr = (cast(t_qp__qp_qp_qp_i_qp_qp)pFunQt[19100])(
            _wd,
            _wn,
            _wh,
            port,
            _wu,
            _wp);
        (cast(t_v__qp)pFunQt[22])(_wd);
        (cast(t_v__qp)pFunQt[22])(_wn);
        (cast(t_v__qp)pFunQt[22])(_wh);
        (cast(t_v__qp)pFunQt[22])(_wu);
        (cast(t_v__qp)pFunQt[22])(_wp);
    }

    // Private ctor for static factory methods
    private this(void* ptr) { _ptr = ptr; }

    /// Open SQLite database file.
    static QSqlDatabase openSqlite(string path) {
        auto db = new QSqlDatabase("QSQLITE", path);
        return db;
    }

    /// Open in-memory SQLite database.
    static QSqlDatabase openMemory() {
        return new QSqlDatabase("QSQLITE", ":memory:");
    }

    /// Add plugin search path (e.g. for sqldrivers). Static, no connection needed.
    static void addPluginPath(string path) {
        auto _w = toQString(path);
        (cast(t_v__qp)pFunQt[19109])(_w);
        (cast(t_v__qp)pFunQt[22])(_w);
    }

    ~this() { close(); }

    /**
     * Детерминированное закрытие соединения (идемпотентно, повторный вызов — no-op).
     *
     * Вызывать ДО app.deleteApp() и до завершения main(). Иначе соединение
     * закроется из GC-финализатора на выходе процесса — уже после уничтожения
     * QApplication и частичной разгрузки ODBC/Winsock, что у QODBC даёт каскад
     * ошибок "Unable to disconnect / free connection / environment handle".
     */
    void close() {
        if (_ptr !is null && pFunQt[19101] !is null) {
            (cast(t_v__qp)pFunQt[19101])(_ptr);
            _ptr = null;
        }
    }

    void* getPtr() { return _ptr; }

    /// true if dbOpen() succeeded (non-null ptr) and DB is open.
    bool isValid() { return _ptr !is null; }

    bool isOpen() {
        if (_ptr is null) return false;
        return cast(bool)(cast(t_i__qp)pFunQt[19102])(_ptr);
    }

    string lastError() {
        if (_ptr is null) return "(null db)";
        void* _qs = (cast(t_qp__qp)pFunQt[19103])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    bool transaction() {
        return cast(bool)(cast(t_i__qp)pFunQt[19104])(_ptr);
    }

    bool commit() {
        return cast(bool)(cast(t_i__qp)pFunQt[19105])(_ptr);
    }

    bool rollback() {
        return cast(bool)(cast(t_i__qp)pFunQt[19106])(_ptr);
    }

    /// List of table names (Qt tables() → \x01-joined → split).
    string[] tables() {
        import std.string : split;
        void* _qs = (cast(t_qp__qp)pFunQt[19107])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        if (_r.length == 0) return [];
        return _r.split("\x01");
    }

    string driverName() {
        void* _qs = (cast(t_qp__qp)pFunQt[19108])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

} // class QSqlDatabase

// ====================================================================
// QSqlQuery
// ====================================================================

@live class QSqlQuery {
private:
    void* _ptr; // QSqlQuery*

public:
    this(QSqlDatabase db) {
        _ptr = (cast(t_qp__qp)pFunQt[19110])(db.getPtr());
    }

    ~this() {
        if (_ptr !is null && pFunQt[19111] !is null) {
            (cast(t_v__qp)pFunQt[19111])(_ptr);
            _ptr = null;
        }
    }

    // ── Execute ──────────────────────────────────────────────────────────────

    bool exec(string sql) {
        auto _w = toQString(sql);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[19112])(
            _ptr, _w);
    }

    bool prepare(string sql) {
        auto _w = toQString(sql);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[19113])(
            _ptr, _w);
    }

    bool execPrepared() {
        return cast(bool)(cast(t_i__qp)pFunQt[19114])(_ptr);
    }

    // ── Bind ─────────────────────────────────────────────────────────────────

    QSqlQuery bindInt(int idx, int val) {
        (cast(t_v__qp_i_i)pFunQt[19115])(_ptr, idx, val);
        return this;
    }

    QSqlQuery bindLong(int idx, long val) {
        (cast(t_v__qp_i_l)pFunQt[19116])(_ptr, idx, val);
        return this;
    }

    QSqlQuery bindDouble(int idx, double val) {
        (cast(t_v__qp_i_d)pFunQt[19117])(_ptr, idx, val);
        return this;
    }

    QSqlQuery bindString(int idx, string val) {
        auto _w = toQString(val);
        (cast(t_v__qp_i_qp)pFunQt[19118])(_ptr, idx, _w);
        (cast(t_v__qp)pFunQt[22])(_w);
        return this;
    }

    /**
     * Привязывает параметр как сырые байты (`QByteArray`).
     *
     * Используется для записи в legacy `char/varchar`-поля с национальной
     * кодировкой (cp1251, cp866 и т.п.) через явное приведение типа в SQL:
     *
     * ---
     * import gen_qsql, gen_qtextcodec;
     *
     * auto q = new QSqlQuery(db);
     * q.prepare("INSERT INTO clients ([Имя]) VALUES (CAST(? AS VARCHAR(100)))");
     * q.bindBytes(0, QTextCodec.toCp1251("Иван"));
     * q.execPrepared();
     * ---
     *
     * Альтернатива (полагаться на implicit conversion SQL Server):
     * `bindString(idx, "Иван")` — Qt отдаст параметр как nvarchar, сервер
     * сам сконвертирует в cp1251 по collation колонки. Работает для большинства
     * случаев, но `bindBytes` гарантирует бит-в-бит точное представление.
     *
     * Params:
     *   idx  = 0-based индекс плейсхолдера `?` в подготовленном запросе.
     *   data = сырые байты для привязки. Пустой массив → пустой QByteArray.
     */
    QSqlQuery bindBytes(int idx, scope const(ubyte)[] data) {
        (cast(t_v__qp_i_qp_i)pFunQt[19134])(
            _ptr, idx, cast(void*)data.ptr, cast(int)data.length);
        return this;
    }

    QSqlQuery bindNull(int idx) {
        (cast(t_v__qp_i)pFunQt[19119])(_ptr, idx);
        return this;
    }

    // ── Iterate ──────────────────────────────────────────────────────────────

    bool next() {
        return cast(bool)(cast(t_i__qp)pFunQt[19120])(_ptr);
    }

    // ── Read values ──────────────────────────────────────────────────────────

    int valueInt(int col) {
        return (cast(t_i__qp_i)pFunQt[19121])(_ptr, col);
    }

    long valueLong(int col) {
        return (cast(t_l__qp_i)pFunQt[19122])(_ptr, col);
    }

    double valueDouble(int col) {
        return (cast(t_d__qp_i)pFunQt[19123])(_ptr, col);
    }

    string valueString(int col) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[19124])(_ptr, col);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /**
     * Возвращает сырые байты колонки как `ubyte[]` (новая GC-копия).
     *
     * Использование:
     * $(UL
     *   $(LI Для **BLOB/VARBINARY/RAW** полей — возвращает байты драйвера
     *        как есть. Безопасно использовать любой `QTextCodec.fromXxx()`
     *        чтобы декодировать legacy-кодировки.)
     *   $(LI Для **VARCHAR/CHAR** полей в legacy-БД (cp1251, cp866 и т.п.) —
     *        ОБЯЗАТЕЛЬНО делать в SELECT приведение `CAST(field AS BINARY)`
     *        (MySQL) или `CAST(field AS VARBINARY(MAX))` (MS SQL), иначе
     *        ODBC-драйвер сам преобразует QString с применением своего
     *        (часто неверного) кодека и информация будет потеряна ещё до
     *        того, как Qt получит данные.)
     * )
     *
     * Example: чтение поля cp1251 из MS SQL через ODBC:
     * ---
     * import gen_qsql, gen_qtextcodec;
     *
     * auto q = new QSqlQuery();
     * q.exec("SELECT CAST(name AS VARBINARY(MAX)) FROM clients");
     * while (q.next()) {
     *     ubyte[] raw  = q.valueBytes(0);
     *     string  name = QTextCodec.fromCp1251(raw);
     *     writeln(name);
     * }
     * ---
     *
     * Returns: GC-копия байтов; пустой массив если поле NULL/empty.
     */
    ubyte[] valueBytes(int col) {
        import gen_qbytearray : QByteArray;
        void* _ba = (cast(t_qp__qp_i)pFunQt[19133])(_ptr, col);
        if (_ba is null) return null;
        auto wrap = QByteArray.wrap(_ba);  // GC-владелец → авто-delete
        return wrap.toSlice();
    }

    bool isNull(int col) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[19125])(_ptr, col);
    }

    // ── Metadata ─────────────────────────────────────────────────────────────

    /// SQLite returns -1 (driver limitation). Use next() loop instead.
    int numRows() {
        return (cast(t_i__qp)pFunQt[19126])(_ptr);
    }

    int numCols() {
        return (cast(t_i__qp)pFunQt[19127])(_ptr);
    }

    string fieldName(int col) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[19128])(_ptr, col);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    string lastError() {
        void* _qs = (cast(t_qp__qp)pFunQt[19129])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    long lastInsertId() {
        return (cast(t_l__qp)pFunQt[19130])(_ptr);
    }

    int numRowsAffected() {
        return (cast(t_i__qp)pFunQt[19131])(_ptr);
    }

    QSqlQuery clear() {
        (cast(t_v__qp)pFunQt[19132])(_ptr);
        return this;
    }

} // class QSqlQuery
