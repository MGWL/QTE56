/**
 * gen_qdao.d — QTE56-обёртка DAO/ACE (Microsoft Access .mdb/.accdb).
 *
 * QTE56-стиль (ген-слой), но НЕ через pFunQt: COM-вызовы идут через
 * ole_dao.d → ole_automation.d → ole_helper.dll (см. TASK_DAO_ACE_INTEGRATION.md).
 * Модуль регистрируется в QTE56 для единообразия загрузки (ole_helper.dll
 * подхватывается из той же папки DLL), pFunQt-индексы не используются.
 *
 * Классы: QDaoDatabase, QDaoQuery. Типы: DaoVersion, DaoFieldType,
 * QDaoFieldInfo (= DaoFieldInfo), QDaoRelationship (= DaoRelationship).
 *
 * Реализовано вручную (не генератором).
 */
module gen_qdao;

import qte56_core;
import qte56_loader : registerModule;
import ole_dao;

public import ole_dao : DaoVersion, DaoFieldType;

/// Метаданные поля таблицы (см. ole_dao.DaoFieldInfo).
alias QDaoFieldInfo    = DaoFieldInfo;
/// Связь между таблицами (см. ole_dao.DaoDatabase.DaoRelationship).
alias QDaoRelationship = DaoDatabase.DaoRelationship;
/// Информация о прилинкованной таблице.
alias QDaoLinkedTable  = DaoDatabase.LinkedTableInfo;

// ====================================================================
// Регистрация модуля в QTE56 (единый механизм загрузки DLL).
// ole_helper.dll грузится из той же папки, что и qte56 DLL.
// pFunQt-индексов нет — load-функция пустая.
// ====================================================================

static this() {
    registerModule("QDao", "ole_helper.dll", &loadQDao);
}

void loadQDao() {
    // COM-вызовы идут через ole_dao.d напрямую, pFunQt не используется.
}

// ====================================================================
// Вспомогательное: путь к ole_helper.dll
// ====================================================================

private string _oleHelperPath() {
    import std.file : exists;
    // Предпочитаем DLL из папки проекта (та же, что у qte56 dll32)
    if (exists("dll/dll32/ole_helper.dll")) return "dll/dll32/ole_helper.dll";
    if (exists("dll32/ole_helper.dll"))    return "dll32/ole_helper.dll";
    return "ole_helper.dll";  // поиск по PATH / рядом с exe
}

// ====================================================================
// QDaoDatabase — аналог QSqlDatabase
// ====================================================================

/// D wrapper for DAO/ACE database (Microsoft Access .mdb/.accdb).
@live class QDaoDatabase {
private:
    DaoEngine   _engine;
    DaoDatabase _db;
    string      _path;
    bool        _inTrans;

public:
    /// Пустой объект (isOpen() == false). Используйте фабрики open*/create*.
    this() {}

    ~this() { close(); }

    // ── Фабрики ─────────────────────────────────────────────────

    /// Открыть базу с автоопределением версии DAO/ACE (ACE 16 → 12 → DAO 3.6).
    static QDaoDatabase open(string path) {
        return open(path, DaoVersion.autoDetect);
    }

    /// Открыть базу с явным указанием версии.
    static QDaoDatabase open(string path, DaoVersion ver) {
        auto self = new QDaoDatabase();
        self._engine = new DaoEngine(ver, _oleHelperPath());
        self._db = self._engine.openDatabase(path);
        self._path = path;
        return self;
    }

    /// Открыть .mdb через DAO 3.6 (32-bit only, без установки Office).
    static QDaoDatabase openMdb(string path) {
        return open(path, DaoVersion.v36);
    }

    /// Открыть .accdb (требуется ACE 12+, автоопределение версии).
    static QDaoDatabase openAccdb(string path) {
        return open(path, DaoVersion.autoDetect);
    }

    /// Создать новую базу (перезаписывает существующую).
    static QDaoDatabase create(string path, DaoVersion ver = DaoVersion.autoDetect) {
        auto self = new QDaoDatabase();
        self._engine = new DaoEngine(ver, _oleHelperPath());
        self._db = self._engine.createDatabase(path);
        self._path = path;
        return self;
    }

    // ── Состояние ───────────────────────────────────────────────

    /// true если COM-движок создан.
    bool isValid() { return _engine !is null; }
    /// true если база открыта.
    bool isOpen()  { return _db !is null; }
    /// Путь к файлу базы.
    string path()  { return _path; }
    /// Строка версии движка ("DAO 3.6", "ACE 12.0", ...).
    string versionString()  { return _engine is null ? "" : _engine.engineVersionString(); }
    /// То же, что versionString() (совместимость с тестами).
    string engineVersion()  { return versionString(); }
    /// Enum версии движка.
    DaoVersion daoVersion() { return _engine is null ? DaoVersion.autoDetect
                                                     : _engine.engineVersion(); }

    // ── Метаданные ──────────────────────────────────────────────

    /// Список пользовательских таблиц (без MSys* и временных).
    string[] tables() {
        _checkOpen();
        return _db.tableNames();
    }

    /// Количество пользовательских таблиц.
    int tableCount() { return cast(int) tables().length; }

    /// true если таблица существует.
    bool tableExists(string name) {
        import std.algorithm : canFind;
        return tables().canFind(name);
    }

    /// Информация о полях таблицы.
    QDaoFieldInfo[] fields(string tableName) {
        _checkOpen();
        return _db.fields(tableName);
    }

    /// Прилинкованные таблицы.
    QDaoLinkedTable[] linkedTables() {
        _checkOpen();
        return _db.linkedTables();
    }

    /// Связи между таблицами (все / для конкретной таблицы).
    QDaoRelationship[] relationships() {
        _checkOpen();
        return _db.relationships();
    }
    /// ditto
    QDaoRelationship[] relationships(string tableName) {
        _checkOpen();
        return _db.relationships(tableName);
    }

    // ── CRUD ────────────────────────────────────────────────────

    /// Выполнить SQL без результата (INSERT/UPDATE/DELETE/CREATE...).
    /// Возвращает количество затронутых строк или -1 при ошибке.
    int execute(string sql) {
        _checkOpen();
        try {
            return _db.execute(sql);
        } catch (Exception) {
            return -1;
        }
    }

    /// Создать объект запроса и выполнить SELECT.
    QDaoQuery query(string sql) {
        _checkOpen();
        auto q = new QDaoQuery(this);
        q.exec(sql);
        return q;
    }

    // ── Транзакции ──────────────────────────────────────────────

    bool beginTransaction() {
        _checkOpen();
        _db.beginTrans();
        _inTrans = true;
        return true;
    }

    bool commit() {
        _checkOpen();
        _db.commitTrans();
        _inTrans = false;
        return true;
    }

    bool rollback() {
        _checkOpen();
        _db.rollback();
        _inTrans = false;
        return true;
    }

    bool inTransaction() { return _inTrans; }

    // ── Жизненный цикл ──────────────────────────────────────────

    /// Закрыть базу (идемпотентно).
    void close() {
        if (_db !is null) {
            _db.close();
            _db = null;
        }
        if (_engine !is null) {
            _engine.release();
            _engine = null;
        }
        _inTrans = false;
    }

private:
    void _checkOpen() {
        if (_db is null)
            throw new Exception("QDaoDatabase: database is not open");
    }
}

// ====================================================================
// QDaoQuery — аналог QSqlQuery
// ====================================================================

/// D wrapper for DAO Recordset (результат SELECT).
@live class QDaoQuery {
private:
    QDaoDatabase _db;
    DaoRecordset _rs;
    bool         _started;   // DAO открывает recordset на первой записи

public:
    /// Пустой запрос, привязанный к базе. Выполнить — exec(sql).
    this(QDaoDatabase db) {
        _db = db;
    }

    ~this() { close(); }

    /// Выполнить SELECT-запрос.
    bool exec(string sql) {
        if (_db is null || !_db.isOpen())
            throw new Exception("QDaoQuery: database is not open");
        close();
        _rs = _db._db.openRecordset(sql);
        _started = false;
        return true;
    }

    /// Следующая запись. false на EOF.
    /// DAO открывает recordset уже позиционированным на первую запись,
    /// поэтому первый next() не двигает курсор.
    bool next() {
        if (_rs is null) return false;
        if (!_started) {
            _started = true;
            return !_rs.eof();
        }
        return _rs.moveNext();
    }

    /// true если достигнут конец набора.
    bool eof() { return _rs is null || _rs.eof(); }

    /// Перейти к первой записи.
    bool first() {
        if (_rs is null) return false;
        _started = true;
        return _rs.moveFirst();
    }

    /// Количество записей (может быть -1 для dynaset до полного обхода).
    int recordCount() { return _rs is null ? -1 : _rs.recordCount(); }

    // ── Чтение значений по индексу ──────────────────────────────

    int valueInt(int col) {
        auto v = _value(col);
        scope(exit) v.clear();
        return isNull(col) ? 0 : v.asInt();
    }

    long valueLong(int col) {
        return cast(long) valueInt(col);
    }

    double valueDouble(int col) {
        auto v = _value(col);
        scope(exit) v.clear();
        return isNull(col) ? 0.0 : v.asDouble();
    }

    string valueString(int col) {
        auto v = _value(col);
        scope(exit) v.clear();
        return isNull(col) ? "" : v.asString();
    }

    bool valueBool(int col) {
        auto v = _value(col);
        scope(exit) v.clear();
        return !isNull(col) && v.asBool();
    }

    /// Дата как строка (формат определяет DAO/ACE).
    string valueDate(int col) {
        return valueString(col);
    }

    /// true если значение NULL.
    bool isNull(int col) {
        auto v = _value(col);
        scope(exit) v.clear();
        // VT_EMPTY = 0, VT_NULL = 1
        return v.type() == 0 || v.type() == 1;
    }

    // ── Чтение значений по имени поля ───────────────────────────

    int valueInt(string name)    { return _valueByName!int(name, "int"); }
    long valueLong(string name)  { return cast(long) _valueByName!int(name, "int"); }
    double valueDouble(string name) {
        auto v = _value(name);
        scope(exit) v.clear();
        return isNull(name) ? 0.0 : v.asDouble();
    }
    string valueString(string name) {
        auto v = _value(name);
        scope(exit) v.clear();
        return isNull(name) ? "" : v.asString();
    }
    bool valueBool(string name) {
        auto v = _value(name);
        scope(exit) v.clear();
        return !isNull(name) && v.asBool();
    }
    string valueDate(string name) { return valueString(name); }
    bool isNull(string name) {
        auto v = _value(name);
        scope(exit) v.clear();
        return v.type() == 0 || v.type() == 1;
    }

    // ── Метаданные ──────────────────────────────────────────────

    int fieldCount()          { return _rs is null ? 0 : _rs.fieldCount(); }
    string fieldName(int col) { return _rs is null ? "" : _rs.fieldName(col); }
    /// Тип поля (см. DaoFieldType).
    int fieldType(int col)    { return _rs is null ? 0 : _rs.fieldType(col); }
    int fieldSize(int col)    { return _rs is null ? 0 : _rs.fieldSize(col); }

    // ── Жизненный цикл ──────────────────────────────────────────

    /// Закрыть recordset (идемпотентно).
    void close() {
        if (_rs !is null) {
            _rs.close();
            _rs = null;
        }
        _started = false;
    }

private:
    import ole_automation : OleVariant;

    OleVariant _value(int col) {
        if (_rs is null) throw new Exception("QDaoQuery: not executed");
        return _rs.fieldValue(col);
    }

    OleVariant _value(string name) {
        if (_rs is null) throw new Exception("QDaoQuery: not executed");
        return _rs.fieldValue(name);
    }

    T _valueByName(T)(string name, string kind) {
        auto v = _value(name);
        scope(exit) v.clear();
        static if (is(T == int))
            return isNull(name) ? 0 : v.asInt();
        else
            return T.init;
    }
}
