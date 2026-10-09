/**
 * ole_adox.d — Full ADOX (ADO Extended) wrapper for Microsoft Access databases.
 * Works with .mdb (Jet 4.0) and .accdb (ACE) via OLE DB.
 *
 * Provides: Catalog, Table, Column, Index, Key, View, Procedure
 * For "problematic" MDB files where DAO doesn't see tables.
 *
 * Usage:
 *   auto cat = new AdoxCatalog(`C:\Data\file.mdb`);
 *   foreach (name; cat.tableNames()) { writeln(name); }
 *   auto cols = cat.columns("Клиенты");
 *   auto q = cat.query("SELECT * FROM [Клиенты]");
 *   while (q.next()) { writeln(q.valueString(0)); }
 */
module ole_adox;

import ole_automation;
import std.string : startsWith, endsWith, toLower;
import std.conv : to;

// ── AdoxDataType ─────────────────────────────────────────────────────────────

/// ADOX data type constants (matching ADOX DataTypeEnum).
enum AdoxDataType : int {
    adEmpty      = 0,
    adSmallInt   = 2,
    adInteger    = 3,
    adSingle     = 4,
    adDouble     = 5,
    adCurrency   = 6,
    adDate       = 7,
    adBSTR       = 8,
    adIDispatch  = 9,
    adBoolean    = 11,
    adVariant    = 12,
    adIUnknown   = 13,
    adDecimal    = 14,
    adTinyInt    = 16,
    adUnsignedTinyInt = 17,
    adUnsignedSmallInt = 18,
    adUnsignedInt = 19,
    adBigInt     = 20,
    adUnsignedBigInt = 21,
    adFileTime   = 64,
    adGUID       = 72,
    adBinary     = 128,
    adChar       = 129,
    adWChar      = 130,
    adNumeric    = 131,
    adUserDefined = 132,
    adDBDate     = 133,
    adDBTime     = 134,
    adDBTimeStamp = 135,
    adVarChar    = 200,
    adLongVarChar = 201,
    adVarWChar   = 202,
    adLongVarWChar = 203,
    adVarBinary  = 204,
    adLongVarBinary = 205,
}

// ── AdoxColumnInfo ───────────────────────────────────────────────────────────

/// Column metadata.
struct AdoxColumnInfo {
    string name;           /// Column name
    int type;              /// AdoxDataType
    int definedSize;       /// Max size
    int numericPrecision;  /// For numeric
    int numericScale;      /// For numeric
    bool nullable;         /// NULL allowed
    bool hasDefault;       /// Has default value
    string defaultValue;   /// Default value string
    string description;    /// Description
}

// ── AdoxIndexInfo ────────────────────────────────────────────────────────────

/// Index metadata.
struct AdoxIndexInfo {
    string name;           /// Index name
    bool unique;           /// Unique index
    bool primaryKey;       /// Primary key
    string[] columns;      /// Column names in index
}

// ── AdoxKeyInfo ──────────────────────────────────────────────────────────────

/// Foreign key metadata.
struct AdoxKeyInfo {
    string name;           /// Key name
    string type;           /// Primary / Foreign / Unique
    string relatedTable;   /// Related table (for foreign keys)
    string[] columns;      /// Column names
}

// ── AdoxCatalog ──────────────────────────────────────────────────────────────

@live
/// ADOX Catalog — represents an entire database.
class AdoxCatalog {
private:
    OleObject _catalog;
    string _path;
    string _connStr;
    string _lastError;

public:
    /**
     * Open database via ADOX.
     * Params:
     *   path = path to .mdb or .accdb file
     *   password = database password (optional)
     */
    this(string path, string password = "") {
        loadOleHelper("ole_helper.dll");
        oleInit();

        _path = path;
        _catalog = new OleObject("ADOX.Catalog");

        // Build connection string
        if (path.toLower().endsWith(".accdb")) {
            _connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" ~ path ~ ";";
        } else {
            _connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" ~ path ~ ";";
        }
        if (password.length > 0) {
            _connStr ~= "Jet OLEDB:Database Password=" ~ password ~ ";";
        }

        _catalog.set("ActiveConnection", _connStr);
    }

    ~this() {
        close();
    }

    void close() {
        if (_catalog !is null) {
            _catalog.release();
            _catalog = null;
        }
    }

    bool isOpen() { return _catalog !is null; }
    string path() { return _path; }
    string lastError() { return _lastError; }

    // ── Tables ──────────────────────────────────────────────────

    /// Get list of user table names (optionally include linked tables).
    string[] tableNames(bool includeLinked = true) {
        if (_catalog is null) return [];
        string[] names;
        auto tbls = _catalog.getObject("Tables");
        scope(exit) tbls.release();

        int count = tbls.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = tbls.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto t = new OleObject(v.asDispatch());
            scope(exit) t.release();

            string tname = t.getString("Name");
            string ttype = t.getString("Type");

            // Skip system tables
            if (tname.startsWith("MSys")) continue;

            // Filter by type
            if (ttype == "TABLE" || ttype == "ACCESS TABLE") {
                names ~= tname;
            } else if (includeLinked && ttype == "LINK") {
                names ~= tname;
            }
        }
        return names;
    }

    /// Get list of linked table names only.
    string[] linkedTableNames() {
        if (_catalog is null) return [];
        string[] names;
        auto tbls = _catalog.getObject("Tables");
        scope(exit) tbls.release();

        int count = tbls.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = tbls.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto t = new OleObject(v.asDispatch());
            scope(exit) t.release();

            string tname = t.getString("Name");
            string ttype = t.getString("Type");

            if (ttype == "LINK" && !tname.startsWith("MSys")) {
                names ~= tname;
            }
        }
        return names;
    }

    /// Check if table exists.
    bool tableExists(string name) {
        foreach (t; tableNames()) {
            if (t == name) return true;
        }
        return false;
    }

    /// Get table object by name.
    AdoxTable getTable(string name) {
        if (_catalog is null) return null;
        auto tbls = _catalog.getObject("Tables");
        scope(exit) tbls.release();

        auto v = tbls.get("Item", OleVariant.fromString(name));
        scope(exit) v.clear();
        auto t = new OleObject(v.asDispatch());

        return new AdoxTable(t, name);
    }

    /// Create new table.
    AdoxTable createTable(string name) {
        if (_catalog is null) return null;
        auto t = _catalog.callObject("Create", OleVariant.fromString(name));
        return new AdoxTable(t, name);
    }

    /// Delete table.
    void deleteTable(string name) {
        if (_catalog is null) return;
        auto tbls = _catalog.getObject("Tables");
        scope(exit) tbls.release();
        tbls.callVoid("Delete", OleVariant.fromString(name));
    }

    // ── Columns ─────────────────────────────────────────────────

    /// Get columns for a table.
    AdoxColumnInfo[] columns(string tableName) {
        auto t = getTable(tableName);
        if (t is null) return [];
        scope(exit) t.release();
        return t.columns();
    }

    // ── Indexes ─────────────────────────────────────────────────

    /// Get indexes for a table.
    AdoxIndexInfo[] indexes(string tableName) {
        auto t = getTable(tableName);
        if (t is null) return [];
        scope(exit) t.release();
        return t.indexes();
    }

    // ── Keys ────────────────────────────────────────────────────

    /// Get keys (foreign keys) for a table.
    AdoxKeyInfo[] keys(string tableName) {
        auto t = getTable(tableName);
        if (t is null) return [];
        scope(exit) t.release();
        return t.keys();
    }

    // ── Views ───────────────────────────────────────────────────

    /// Get list of view names.
    string[] viewNames() {
        if (_catalog is null) return [];
        string[] names;
        auto views = _catalog.getObject("Views");
        scope(exit) views.release();

        int count = views.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = views.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto view = new OleObject(v.asDispatch());
            scope(exit) view.release();
            names ~= view.getString("Name");
        }
        return names;
    }

    // ── Procedures ──────────────────────────────────────────────

    /// Get list of stored procedure names.
    string[] procedureNames() {
        if (_catalog is null) return [];
        string[] names;
        auto procs = _catalog.getObject("Procedures");
        scope(exit) procs.release();

        int count = procs.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = procs.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto p = new OleObject(v.asDispatch());
            scope(exit) p.release();
            names ~= p.getString("Name");
        }
        return names;
    }

    // ── Data access via ADO ─────────────────────────────────────

    /// Execute SQL (INSERT, UPDATE, DELETE, CREATE, etc.).
    void execute(string sql) {
        if (_catalog is null) throw new Exception("Catalog not open");

        // Get ActiveConnection (ADO Connection)
        auto connVar = _catalog.get("ActiveConnection");
        scope(exit) connVar.clear();
        auto conn = new OleObject(connVar.asDispatch());
        scope(exit) conn.release();

        conn.callVoid("Execute", OleVariant.fromString(sql));
    }

    /// Create query for SELECT.
    AdoxRecordset query(string sql) {
        if (_catalog is null) throw new Exception("Catalog not open");

        auto connVar = _catalog.get("ActiveConnection");
        scope(exit) connVar.clear();
        auto conn = new OleObject(connVar.asDispatch());
        scope(exit) conn.release();

        auto rs = conn.callObject("Execute", OleVariant.fromString(sql));
        return new AdoxRecordset(rs);
    }

    /// Compact/repair database.
    static void compactDatabase(string srcPath, string dstPath) {
        loadOleHelper("ole_helper.dll");
        oleInit();

        auto cat = new OleObject("ADOX.Catalog");
        scope(exit) cat.release();

        string srcConn, dstConn;
        if (srcPath.toLower().endsWith(".accdb")) {
            srcConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" ~ srcPath ~ ";";
            dstConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" ~ dstPath ~ ";";
        } else {
            srcConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" ~ srcPath ~ ";";
            dstConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" ~ dstPath ~ ";";
        }

        cat.callVoid("CompactDatabase", OleVariant.fromString(srcConn), OleVariant.fromString(dstConn));
    }
}

// ── AdoxTable ────────────────────────────────────────────────────────────────

@live
/// ADOX Table wrapper.
class AdoxTable {
private:
    OleObject _table;
    string _name;

public:
    this(OleObject table, string name) {
        _table = table;
        _name = name;
    }

    ~this() {
        release();
    }

    void release() {
        if (_table !is null) {
            _table.release();
            _table = null;
        }
    }

    string name() { return _name; }

    /// Get table type: "TABLE", "ACCESS TABLE", "LINK", "SYSTEM TABLE", "VIEW".
    string tableType() {
        if (_table is null) return "";
        try {
            return _table.getString("Type");
        } catch (Exception e) {
            return "";
        }
    }

    /// For linked tables: get the source catalog (connection string).
    string linkedCatalog() {
        if (_table is null) return "";
        try {
            return _table.getString("ParentCatalog");
        } catch (Exception e) {
            return "";
        }
    }

    /// Get columns.
    AdoxColumnInfo[] columns() {
        if (_table is null) return [];
        AdoxColumnInfo[] result;

        auto cols = _table.getObject("Columns");
        scope(exit) cols.release();

        int count = cols.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = cols.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto c = new OleObject(v.asDispatch());
            scope(exit) c.release();

            AdoxColumnInfo info;
            info.name = c.getString("Name");
            info.type = c.getInt("Type");
            try { info.definedSize = c.getInt("DefinedSize"); } catch (Exception e) {}
            try { info.numericPrecision = c.getInt("NumericPrecision"); } catch (Exception e) {}
            try { info.numericScale = c.getInt("NumericScale"); } catch (Exception e) {}

            // Properties may not exist for all columns
            try { info.nullable = c.getBool("Nullable"); } catch (Exception e) {}
            try { info.hasDefault = false; } catch (Exception e) {}
            try { info.description = c.getString("Description"); } catch (Exception e) {}

            result ~= info;
        }
        return result;
    }

    /// Get indexes.
    AdoxIndexInfo[] indexes() {
        if (_table is null) return [];
        AdoxIndexInfo[] result;

        auto idxs = _table.getObject("Indexes");
        scope(exit) idxs.release();

        int count = idxs.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = idxs.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto idx = new OleObject(v.asDispatch());
            scope(exit) idx.release();

            AdoxIndexInfo info;
            info.name = idx.getString("Name");
            info.unique = idx.getBool("Unique");
            info.primaryKey = idx.getBool("PrimaryKey");

            // Get columns in index
            auto cols = idx.getObject("Columns");
            scope(exit) cols.release();
            int colCount = cols.getInt("Count");
            for (int j = 0; j < colCount; j++) {
                auto cv = cols.get("Item", OleVariant.fromInt(j));
                scope(exit) cv.clear();
                auto c = new OleObject(cv.asDispatch());
                scope(exit) c.release();
                info.columns ~= c.getString("Name");
            }

            result ~= info;
        }
        return result;
    }

    /// Get keys (foreign keys).
    AdoxKeyInfo[] keys() {
        if (_table is null) return [];
        AdoxKeyInfo[] result;

        auto ks = _table.getObject("Keys");
        scope(exit) ks.release();

        int count = ks.getInt("Count");
        for (int i = 0; i < count; i++) {
            auto v = ks.get("Item", OleVariant.fromInt(i));
            scope(exit) v.clear();
            auto k = new OleObject(v.asDispatch());
            scope(exit) k.release();

            AdoxKeyInfo info;
            info.name = k.getString("Name");
            // KeyType enum: 1 = Primary, 2 = Foreign, 3 = Unique
            try {
                int kt = k.getInt("Type");
                switch (kt) {
                    case 1: info.type = "Primary"; break;
                    case 2: info.type = "Foreign"; break;
                    case 3: info.type = "Unique"; break;
                    default: info.type = "Unknown(" ~ to!string(kt) ~ ")"; break;
                }
            } catch (Exception e) {
                info.type = "";
            }
            try { info.relatedTable = k.getString("RelatedTable"); } catch (Exception e) {}

            // Get columns
            auto cols = k.getObject("Columns");
            scope(exit) cols.release();
            int colCount = cols.getInt("Count");
            for (int j = 0; j < colCount; j++) {
                auto cv = cols.get("Item", OleVariant.fromInt(j));
                scope(exit) cv.clear();
                auto c = new OleObject(cv.asDispatch());
                scope(exit) c.release();
                info.columns ~= c.getString("Name");
            }

            result ~= info;
        }
        return result;
    }
}

// ── AdoxRecordset ────────────────────────────────────────────────────────────

@live
/// ADO Recordset wrapper for SELECT queries.
class AdoxRecordset {
private:
    OleObject _rs;

public:
    this(OleObject rs) {
        _rs = rs;
    }

    ~this() {
        close();
    }

    void close() {
        if (_rs !is null) {
            try {
                _rs.callVoid("Close");
            } catch (Exception e) {}
            _rs.release();
            _rs = null;
        }
    }

    // ── Iteration ───────────────────────────────────────────────

    bool next() {
        if (_rs is null) return false;
        _rs.callVoid("MoveNext");
        return !eof();
    }

    bool first() {
        if (_rs is null) return false;
        _rs.callVoid("MoveFirst");
        return !eof();
    }

    bool eof() {
        if (_rs is null) return true;
        return _rs.getBool("EOF");
    }

    int recordCount() {
        if (_rs is null) return -1;
        return _rs.getInt("RecordCount");
    }

    // ── Read values by index ────────────────────────────────────

    int valueInt(int col) {
        auto v = _fieldValue(col);
        int r = v.asInt();
        v.clear();
        return r;
    }

    long valueLong(int col) {
        auto v = _fieldValue(col);
        long r = v.asInt();
        v.clear();
        return r;
    }

    double valueDouble(int col) {
        auto v = _fieldValue(col);
        double r = v.asDouble();
        v.clear();
        return r;
    }

    string valueString(int col) {
        auto v = _fieldValue(col);
        string r = v.asString();
        v.clear();
        return r;
    }

    bool valueBool(int col) {
        auto v = _fieldValue(col);
        bool r = v.asBool();
        v.clear();
        return r;
    }

    string valueDate(int col) {
        auto v = _fieldValue(col);
        string r = v.asString();
        v.clear();
        return r;
    }

    bool isNull(int col) {
        auto v = _fieldValue(col);
        bool r = (v.type() == 0 /*VT_EMPTY*/);
        v.clear();
        return r;
    }

    // ── Read values by name ─────────────────────────────────────

    int valueInt(string name) {
        auto v = _fieldValue(name);
        int r = v.asInt();
        v.clear();
        return r;
    }

    string valueString(string name) {
        auto v = _fieldValue(name);
        string r = v.asString();
        v.clear();
        return r;
    }

    double valueDouble(string name) {
        auto v = _fieldValue(name);
        double r = v.asDouble();
        v.clear();
        return r;
    }

    bool valueBool(string name) {
        auto v = _fieldValue(name);
        bool r = v.asBool();
        v.clear();
        return r;
    }

    // ── Metadata ────────────────────────────────────────────────

    int fieldCount() {
        if (_rs is null) return 0;
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        return fields.getInt("Count");
    }

    string fieldName(int col) {
        if (_rs is null) return "";
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(col));
        scope(exit) v.clear();
        auto f = new OleObject(v.asDispatch());
        scope(exit) f.release();
        return f.getString("Name");
    }

    int fieldType(int col) {
        if (_rs is null) return 0;
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(col));
        scope(exit) v.clear();
        auto f = new OleObject(v.asDispatch());
        scope(exit) f.release();
        return f.getInt("Type");
    }

    int fieldSize(int col) {
        if (_rs is null) return 0;
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(col));
        scope(exit) v.clear();
        auto f = new OleObject(v.asDispatch());
        scope(exit) f.release();
        return f.getInt("DefinedSize");
    }

private:
    OleVariant _fieldValue(int index) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromInt(index));
        scope(exit) v.clear();
        auto f = new OleObject(v.asDispatch());
        scope(exit) f.release();
        return f.get("Value");
    }

    OleVariant _fieldValue(string name) {
        auto fields = _rs.getObject("Fields");
        scope(exit) fields.release();
        auto v = fields.get("Item", OleVariant.fromString(name));
        scope(exit) v.clear();
        auto f = new OleObject(v.asDispatch());
        scope(exit) f.release();
        return f.get("Value");
    }
}
