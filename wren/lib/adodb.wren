// adodb.wren — ADODB database wrapper
// Usage: import "adodb" for Database, Recordset

import "ole" for OleObject

class Recordset {
    construct wrap(rs) {
        _rs = rs
    }

    // Is at end of data?
    eof { _rs.get("EOF") }

    // Move to next row
    moveNext() { _rs.call("MoveNext") }
    moveFirst() { _rs.call("MoveFirst") }
    moveLast() { _rs.call("MoveLast") }
    movePrevious() { _rs.call("MovePrevious") }

    // Get field value by name or index
    field(name) {
        var fields = _rs.get("Fields")
        var f = fields.call("Item", name)
        var val = f.get("Value")
        f.release()
        fields.release()
        return val
    }

    // Get field value shortcut
    [name] { field(name) }

    // Number of records (may not be available for forward-only cursors)
    recordCount { _rs.get("RecordCount") }

    // Number of fields
    fieldCount {
        var fields = _rs.get("Fields")
        var count = fields.get("Count")
        fields.release()
        return count
    }

    // Get field name by index
    fieldName(index) {
        var fields = _rs.get("Fields")
        var f = fields.call("Item", index)
        var name = f.get("Name")
        f.release()
        fields.release()
        return name
    }

    // Iterate all rows — calls fn(recordset) for each row
    each(fn) {
        while (!eof) {
            fn.call(this)
            moveNext()
        }
    }

    // Collect all rows into list of maps
    toList() {
        var result = []
        var fc = fieldCount
        each {|rs|
            var row = {}
            var i = 0
            while (i < fc) {
                var name = fieldName(i)
                row[name] = field(i)
                i = i + 1
            }
            result.add(row)
        }
        return result
    }

    close() { _rs.call("Close") }

    release() {
        _rs.release()
    }
}

class Database {
    // Open connection with connection string
    construct open(connStr) {
        _conn = OleObject.create("ADODB.Connection")
        if (_conn.isNull) Fiber.abort("Cannot create ADODB.Connection: %(OleObject.lastError)")
        _conn.call("Open", connStr)
    }

    // Open with provider + data source
    static openAccess(path) {
        return Database.open("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%(path)")
    }

    static openSqlServer(server, database) {
        return Database.open("Provider=SQLOLEDB;Server=%(server);Database=%(database);Integrated Security=SSPI")
    }

    // Execute SQL returning a Recordset
    query(sql) {
        var rs = _conn.call("Execute", sql)
        return Recordset.wrap(rs)
    }

    // Execute SQL without returning data (INSERT, UPDATE, DELETE)
    execute(sql) {
        _conn.call("Execute", sql)
    }

    // Execute and return scalar (first field of first row)
    scalar(sql) {
        var rs = query(sql)
        var val = null
        if (!rs.eof) {
            val = rs.field(0)
        }
        rs.close()
        rs.release()
        return val
    }

    // Connection state (0=closed, 1=open)
    state { _conn.get("State") }

    close() {
        _conn.call("Close")
    }

    release() {
        _conn.release()
    }
}
