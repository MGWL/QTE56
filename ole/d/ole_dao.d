/**
 * ole_dao.d — Low-level DAO/ACE wrapper over ole_automation.d.
 * Standalone module (no QTE56 dependency).
 *
 * Provides: DaoEngine, DaoDatabase, DaoRecordset.
 * Works with .mdb (DAO 3.6) and .accdb (ACE 12+).
 */
module ole_dao;

import ole_automation;
import std.string : startsWith;
import std.conv : to;

// ── DaoVersion ───────────────────────────────────────────────────────────────

/// DAO/ACE engine version. Auto-detect by default.
enum DaoVersion {
    autoDetect,  /// Try ACE 16 → 15 → 14 → 12 → DAO 3.6
    v36,         /// DAO 3.6 — .mdb only, 32-bit only
    ace12,       /// Access 2010 — .mdb + .accdb
    ace14,       /// Access 2013 — .mdb + .accdb
    ace15,       /// Access 2016 — .mdb + .accdb
    ace16,       /// Access 2019/365 — .mdb + .accdb
}

/// DAO field type constants (matching DAO db* constants).
enum DaoFieldType : int {
    dbBoolean     = 1,
    dbByte        = 2,
    dbInteger     = 3,
    dbLong        = 4,
    dbCurrency    = 5,
    dbSingle      = 6,
    dbDouble      = 7,
    dbDate        = 8,
    dbBinary      = 9,
    dbText        = 10,
    dbLongBinary  = 11,
    dbMemo        = 12,
    dbGUID        = 15,
}

// ── DaoEngine ────────────────────────────────────────────────────────────────

private __gshared int g_engineCount = 0;

@live
/// Low-level DAO DBEngine wrapper.
class DaoEngine {
private:
    OleObject _engine;
    DaoVersion _ver;
    string _verStr;

public:
    /**
     * Create DAO/ACE engine.
     * Params:
     *   ver = version to use (autoDetect tries ACE 16→15→14→12→3.6)
     *   dllPath = path to ole_helper.dll (default: "ole_helper.dll")
     */
    this(DaoVersion ver = DaoVersion.autoDetect, string dllPath = "ole_helper.dll") {
        loadOleHelper(dllPath);
        if (g_engineCount == 0) {
            oleInit();
        }
        g_engineCount++;

        if (ver == DaoVersion.autoDetect) {
            _tryCreateEngine([
                DaoVersion.ace16,
                DaoVersion.ace15,
                DaoVersion.ace14,
                DaoVersion.ace12,
                DaoVersion.v36
            ]);
        } else {
            _createEngine(ver);
        }
    }

    ~this() {
        if (_engine !is null) {
            _engine.release();
            _engine = null;
        }
        g_engineCount--;
        if (g_engineCount <= 0) {
            oleUninit();
            // Note: don't unloadOleHelper() — may cause SIGSEGV if GC runs after
        }
    }

    /// Release the engine COM object.
    void release() {
        if (_engine !is null) {
            _engine.release();
            _engine = null;
        }
    }

    /// Engine version string (e.g. "DAO 3.6", "ACE 12.0").
    string engineVersionString() const { return _verStr; }

    /// Engine version enum.
    DaoVersion engineVersion() const { return _ver; }

    /// Open existing database.
    DaoDatabase openDatabase(string path, bool exclusive = false, bool readOnly = false) {
        if (_engine is null)
            throw new Exception("Engine not initialized");

        auto db = _engine.callObject("OpenDatabase",
            OleVariant.fromString(path),
            OleVariant.fromInt(exclusive ? 1 : 0),
            OleVariant.fromInt(readOnly ? 1 : 0));

        auto result = new DaoDatabase(db);
        result._ws = _defaultWorkspace();
        return result;
    }

    /// Create new database (overwrites if exists).
    /// For DAO 3.6: connect = ";LANGID=0x0409;CP=1252;COUNTRY=0"
    DaoDatabase createDatabase(string path, string connect = "") {
        if (_engine is null)
            throw new Exception("Engine not initialized");

        // Default connect string for Jet 4.0 / ACE
        if (connect.length == 0) {
            connect = ";LANGID=0x0409;CP=1252;COUNTRY=0";
        }

        auto db = _engine.callObject("CreateDatabase",
            OleVariant.fromString(path),
            OleVariant.fromString(connect));

        auto result = new DaoDatabase(db);
        result._ws = _defaultWorkspace();
        return result;
    }

private:
    /// Default workspace (Workspaces(0)) — уровень транзакций DAO.
    OleObject _defaultWorkspace() {
        auto wss = _engine.getObject("Workspaces");
        scope(exit) wss.release();
        auto v = wss.get("Item", OleVariant.fromInt(0));
        scope(exit) v.clear();
        return new OleObject(v.asDispatch());
    }

public:

private:
    void _tryCreateEngine(DaoVersion[] versions) {
        foreach (v; versions) {
            try {
                _createEngine(v);
                return;
            } catch (Exception e) {
                // Try next version
                continue;
            }
        }
        throw new Exception("Cannot create any DAO/ACE engine. " ~
            "Make sure Office/Access or ACE Redistributable is installed.");
    }

    void _createEngine(DaoVersion ver) {
        string progid;
        string verName;

        final switch (ver) {
            case DaoVersion.v36:    progid = "DAO.DBEngine.36";  verName = "DAO 3.6"; break;
            case DaoVersion.ace12:  progid = "DAO.DBEngine.120"; verName = "ACE 12.0"; break;
            case DaoVersion.ace14:  progid = "DAO.DBEngine.140"; verName = "ACE 14.0"; break;
            case DaoVersion.ace15:  progid = "DAO.DBEngine.150"; verName = "ACE 15.0"; break;
            case DaoVersion.ace16:  progid = "DAO.DBEngine.160"; verName = "ACE 16.0"; break;
            case DaoVersion.autoDetect:
                throw new Exception("autoDetect should not reach _createEngine");
        }

        _engine = new OleObject(progid);
        _ver = ver;
        _verStr = verName;
    }
}

// ── DaoDatabase ──────────────────────────────────────────────────────────────

@live
/// Low-level DAO Database wrapper.
class DaoDatabase {
private:
    OleObject _db;
    OleObject _ws;  // default workspace (уровень транзакций DAO)

public:
    this(OleObject db) {
        _db = db;
    }

    ~this() {
        close();
    }

    /// Close database.
    void close() {
        if (_ws !is null) {
            _ws.release();
            _ws = null;
        }
        if (_db !is null) {
            try {
                _db.callVoid("Close");
            } catch (Exception e) {
                // Ignore close errors
            }
            _db.release();
            _db = null;
        }
    }

    /// Execute SQL (INSERT, UPDATE, DELETE, CREATE, etc.).
    /// Returns affected row count or -1.
    int execute(string sql, int options = 128 /*dbFailOnError*/) {
        if (_db is null)
            throw new Exception("Database not open");

        auto result = _db.call("Execute",
            OleVariant.fromString(sql),
            OleVariant.fromInt(options));

        int affected = result.asInt();
        result.clear();
        return affected;
    }

    /// Open recordset for SELECT query.
    DaoRecordset openRecordset(string sql, int type = 2 /*dbOpenDynaset*/) {
        if (_db is null)
            throw new Exception("Database not open");

        auto rs = _db.callObject("OpenRecordset",
            OleVariant.fromString(sql),
            OleVariant.fromInt(type));

        return new DaoRecordset(rs);
    }

    /// Get list of user table names (excluding system tables).
    string[] tableNames() {
        if (_db is null)
            throw new Exception("Database not open");

        string[] names;

        // Method 1: Try TableDefs collection
        try {
            auto tds = _db.getObject("TableDefs");
            scope(exit) tds.release();

            int count = tds.getInt("Count");
            for (int i = 0; i < count; i++) {
                auto td = _daoItem(tds, OleVariant.fromInt(i));
                scope(exit) td.release();

                string name = td.getString("Name");
                // Skip system tables
                if (name.startsWith("MSys") || name.startsWith("~"))
                    continue;

                // Check Attributes - user tables have Attributes = 0
                try {
                    int attrs = td.getInt("Attributes");
                    if (attrs != 0)
                        continue;
                } catch (Exception e) {
                    // If can't read Attributes, use name filter only
                }

                names ~= name;
            }
        } catch (Exception e) {
            // Method 2: Fallback to MSysObjects query
            try {
                auto rs = openRecordset(
                    "SELECT Name FROM MSysObjects WHERE Type=1 AND Flags=0");
                scope(exit) rs.close();

                while (!rs.eof()) {
                    auto v = rs.fieldValue(0);
                    scope(exit) v.clear();
                    string name = v.asString();
                    if (!name.startsWith("MSys") && !name.startsWith("~"))
                        names ~= name;
                    rs.moveNext();
                }
            } catch (Exception e2) {
                // MSysObjects may be restricted
            }
        }

        return names;
    }

    /// Get field info for a table.
    DaoFieldInfo[] fields(string tableName) {
        if (_db is null)
            throw new Exception("Database not open");

        DaoFieldInfo[] result;
        auto tds = _db.getObject("TableDefs");
        scope(exit) tds.release();

        auto td = _daoItem(tds, OleVariant.fromString(tableName));
        scope(exit) td.release();

        auto fds = td.getObject("Fields");
        scope(exit) fds.release();

        int count = fds.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto fd = _daoItem(fds, OleVariant.fromInt(i));
            scope(exit) fd.release();

            DaoFieldInfo info;
            info.name = fd.getString("Name");
            info.type = fd.getInt("Type");
            info.size = fd.getInt("Size");
            info.required = fd.getBool("Required");
            info.allowZeroLength = false;
            info.description = "";

            // Try to get Description property (may not exist)
            try {
                auto props = fd.getObject("Properties");
                scope(exit) props.release();
                auto desc = props.call("Item", OleVariant.fromString("Description"));
                scope(exit) desc.clear();
                info.description = desc.asString();
            } catch (Exception e) {
                // Description property may not exist
            }

            // Try AllowZeroLength
            try {
                info.allowZeroLength = fd.getBool("AllowZeroLength");
            } catch (Exception e) {
                // May not be available for all field types
            }

            result ~= info;
        }

        return result;
    }

    /// Begin transaction (уровень Workspace — у Database этого метода нет).
    void beginTrans() {
        if (_ws is null) throw new Exception("Database not open");
        _ws.callVoid("BeginTrans");
    }

    /// Commit transaction.
    void commitTrans() {
        if (_ws is null) throw new Exception("Database not open");
        _ws.callVoid("CommitTrans");
    }

    /// Rollback transaction.
    void rollback() {
        if (_ws is null) throw new Exception("Database not open");
        _ws.callVoid("Rollback");
    }

    // ── Linked Tables ───────────────────────────────────────────

    /// Information about a linked (attached) table.
    struct LinkedTableInfo {
        string name;           /// Table name in this database
        string sourceTable;    /// Original table name in source database
        string connectString;  /// Connection string to source (ODBC or Jet)
        bool isLinked;         /// True if this is a linked table
    }

    /// Get info for all linked tables.
    LinkedTableInfo[] linkedTables() {
        if (_db is null) throw new Exception("Database not open");
        LinkedTableInfo[] result;

        auto tds = _db.getObject("TableDefs");
        scope(exit) tds.release();

        int count = tds.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto td = _daoItem(tds, OleVariant.fromInt(i));
            scope(exit) td.release();

            string name = td.getString("Name");
            if (name.startsWith("MSys") || name.startsWith("~"))
                continue;

            LinkedTableInfo info;
            info.name = name;

            // Check if linked: Connect property is non-empty for linked tables
            try {
                info.connectString = td.getString("Connect");
                info.isLinked = (info.connectString.length > 0);
            } catch (Exception e) {
                info.connectString = "";
                info.isLinked = false;
            }

            // For linked tables, get the source table name
            if (info.isLinked) {
                try {
                    info.sourceTable = td.getString("SourceTableName");
                } catch (Exception e) {
                    info.sourceTable = "";
                }
            }

            if (info.isLinked) {
                result ~= info;
            }
        }
        return result;
    }

    /// Get linked table info by name. Returns info with isLinked=false if not found/not linked.
    LinkedTableInfo linkedTableInfo(string tableName) {
        if (_db is null) throw new Exception("Database not open");

        auto tds = _db.getObject("TableDefs");
        scope(exit) tds.release();

        auto td = _daoItem(tds, OleVariant.fromString(tableName));
        scope(exit) td.release();

        LinkedTableInfo info;
        info.name = tableName;

        try {
            info.connectString = td.getString("Connect");
            info.isLinked = (info.connectString.length > 0);
        } catch (Exception e) {
            info.isLinked = false;
        }

        if (info.isLinked) {
            try {
                info.sourceTable = td.getString("SourceTableName");
            } catch (Exception e) {
                info.sourceTable = "";
            }
        }

        return info;
    }

    // ── Relationships ───────────────────────────────────────────

    /// Information about a relationship between two tables.
    struct DaoRelationship {
        string name;           /// Relationship name
        string parentTable;    /// Table with primary key ("one" side)
        string childTable;     /// Table with foreign key ("many" side)
        string[] parentFields; /// Fields in parent table
        string[] childFields;  /// Fields in child table
        bool cascadeUpdate;    /// Cascade update related fields
        bool cascadeDelete;    /// Cascade delete related records
    }

    /// Get all relationships in the database.
    DaoRelationship[] relationships() {
        if (_db is null) throw new Exception("Database not open");
        DaoRelationship[] result;

        auto rels = _db.getObject("Relations");
        scope(exit) rels.release();

        int count = rels.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto rel = _daoItem(rels, OleVariant.fromInt(i));
            scope(exit) rel.release();

            DaoRelationship r;
            r.name = rel.getString("Name");
            r.parentTable = rel.getString("Table");
            r.childTable = rel.getString("ForeignTable");

            // Cascade rules: Attributes bit flags
            // dbRelationUpdateCascade = 256, dbRelationDeleteCascade = 4096
            try {
                int attrs = rel.getInt("Attributes");
                r.cascadeUpdate = (attrs & 256) != 0;
                r.cascadeDelete = (attrs & 4096) != 0;
            } catch (Exception e) {
                r.cascadeUpdate = false;
                r.cascadeDelete = false;
            }

            // Fields in relationship (parent/child columns)
            try {
                auto flds = rel.getObject("Fields");
                scope(exit) flds.release();
                int fldCount = flds.getInt("Count");
                for (int j = 0; j < fldCount; j++) {
                    auto fv = flds.get("Item", OleVariant.fromInt(j));
                    scope(exit) fv.clear();
                    auto f = new OleObject(fv.asDispatch());
                    scope(exit) f.release();

                    r.childFields ~= f.getString("Name");
                    r.parentFields ~= f.getString("ForeignName");
                }
            } catch (Exception e) {
                // Fields collection may not be available
            }

            result ~= r;
        }
        return result;
    }

    /// Get relationships for a specific table (as parent or child).
    DaoRelationship[] relationships(string tableName) {
        if (_db is null) throw new Exception("Database not open");
        DaoRelationship[] result;

        auto allRels = relationships();
        foreach (r; allRels) {
            if (r.parentTable == tableName || r.childTable == tableName) {
                result ~= r;
            }
        }
        return result;
    }
}

// ── DaoRecordset ─────────────────────────────────────────────────────────────

@live
/// Low-level DAO Recordset wrapper.
class DaoRecordset {
private:
    OleObject _rs;

public:
    this(OleObject rs) {
        _rs = rs;
    }

    ~this() {
        close();
    }

    /// Close recordset.
    void close() {
        if (_rs !is null) {
            try {
                _rs.callVoid("Close");
            } catch (Exception e) {
                // Ignore close errors
            }
            _rs.release();
            _rs = null;
        }
    }

    /// Move to next record. Returns false if EOF.
    bool moveNext() {
        if (_rs is null) return false;
        _rs.callVoid("MoveNext");
        return !eof();
    }

    /// Move to first record.
    bool moveFirst() {
        if (_rs is null) return false;
        _rs.callVoid("MoveFirst");
        return !eof();
    }

    /// True if at end of file.
    bool eof() {
        if (_rs is null) return true;
        return _rs.getBool("EOF");
    }

    /// Record count (-1 if not available).
    int recordCount() {
        if (_rs is null) return -1;
        return _rs.getInt("RecordCount");
    }

    /// Number of fields.
    int fieldCount() {
        if (_rs is null) return 0;
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        return fields.getInt("Count");
    }

    /// Get field name by index.
    string fieldName(int index) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(index));
        scope(exit) v.clear();
        auto fd = new OleObject(v.asDispatch());
        scope(exit) fd.release();
        return fd.getString("Name");
    }

    /// Get field type by index.
    int fieldType(int index) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(index));
        scope(exit) v.clear();
        auto fd = new OleObject(v.asDispatch());
        scope(exit) fd.release();
        return fd.getInt("Type");
    }

    /// Get field size by index.
    int fieldSize(int index) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(index));
        scope(exit) v.clear();
        auto fd = new OleObject(v.asDispatch());
        scope(exit) fd.release();
        return fd.getInt("Size");
    }

    /// Get field value by index.
    OleVariant fieldValue(int index) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        // DAO Fields collection: Item(index) — indexed property (Property Get with args)
        auto v = fields.get("Item", OleVariant.fromInt(index));
        scope(exit) v.clear();
        auto fd = new OleObject(v.asDispatch());
        scope(exit) fd.release();
        return fd.get("Value");
    }

    /// Get field value by name.
    OleVariant fieldValue(string name) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        // DAO Fields collection: Item(name) — indexed property
        auto v = fields.get("Item", OleVariant.fromString(name));
        scope(exit) v.clear();
        auto fd = new OleObject(v.asDispatch());
        scope(exit) fd.release();
        return fd.get("Value");
    }
}

/// Получить элемент коллекции DAO через property-get Item(arg).
/// Важно: callObject("Item", fromString) падает ("Операция не поддерживается"),
/// а get("Item", ...) работает и для строковых, и для числовых ключей.
private OleObject _daoItem(OleObject coll, OleVariant arg) {
    auto v = coll.get("Item", arg);
    scope(exit) v.clear();
    return new OleObject(v.asDispatch());
}

// ── DaoFieldInfo ─────────────────────────────────────────────────────────────

/// Field metadata structure.
struct DaoFieldInfo {
    string name;           /// Field name
    int type;              /// DaoFieldType
    int size;              /// Field size
    bool required;         /// Required field
    bool allowZeroLength;  /// Allow empty string
    string description;    /// Field description/comment
}
