/**
 * gen_qfile.d — D wrapper for QFile.
 * Module: QFile | DLL: qte56_foundation.dll
 * MANUALLY WRITTEN
 *
 * Index block: 18500–18528 (29 functions)
 *
 * File I/O through Qt: open, read, write, copy, rename, remove.
 * Not a QWidget — value-type-like pattern (raw _ptr, destructor).
 *
 * Usage:
 *   auto f = new QFile("test.txt");
 *   f.open(OpenMode.WriteOnly | OpenMode.Text);
 *   f.writeText("Hello, world!\n");
 *   f.close();
 *
 *   f.open(OpenMode.ReadOnly | OpenMode.Text);
 *   string s = f.readAllText();
 *   f.close();
 */
module gen_qfile;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString, t_b__qp_i, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_ip, t_v__qp, t_v__qp_qp;

// New aliases for QFile:
mixin(generateAlias("i__qp_qp_i")); // t_i__qp_qp_i  : int function(void*, void*, int) — write(f, data, len)

/// QIODevice::OpenMode flags
enum OpenMode : int {
    ReadOnly   = 0x0001,
    WriteOnly  = 0x0002,
    ReadWrite  = 0x0003,
    Append     = 0x0004,
    Truncate   = 0x0008,
    Text       = 0x0010,
    Unbuffered = 0x0020,
}

// ====================================================================
// Load function addresses
// ====================================================================

static this() { registerModule("QFile", "qte56_foundation.dll", &loadQFile); }

void loadQFile() {
    mixin(generateFunQt(18500, "qteQFile_create",         "QFile"));
    mixin(generateFunQt(18501, "qteQFile_create_path",    "QFile"));
    mixin(generateFunQt(18502, "qteQFile_delete",         "QFile"));
    mixin(generateFunQt(18503, "qteQFile_open",           "QFile"));
    mixin(generateFunQt(18504, "qteQFile_close",          "QFile"));
    mixin(generateFunQt(18505, "qteQFile_isOpen",         "QFile"));
    mixin(generateFunQt(18506, "qteQFile_fileName",       "QFile"));
    mixin(generateFunQt(18507, "qteQFile_setFileName",    "QFile"));
    mixin(generateFunQt(18508, "qteQFile_exists",         "QFile"));
    mixin(generateFunQt(18509, "qteQFile_exists_static",  "QFile"));
    mixin(generateFunQt(18510, "qteQFile_size",           "QFile"));
    mixin(generateFunQt(18511, "qteQFile_pos",            "QFile"));
    mixin(generateFunQt(18512, "qteQFile_seek",           "QFile"));
    mixin(generateFunQt(18513, "qteQFile_atEnd",          "QFile"));
    mixin(generateFunQt(18514, "qteQFile_readAll",        "QFile"));
    mixin(generateFunQt(18515, "qteQFile_freeBuffer",     "QFile"));
    mixin(generateFunQt(18516, "qteQFile_write",          "QFile"));
    mixin(generateFunQt(18517, "qteQFile_flush",          "QFile"));
    mixin(generateFunQt(18518, "qteQFile_remove",         "QFile"));
    mixin(generateFunQt(18519, "qteQFile_remove_static",  "QFile"));
    mixin(generateFunQt(18520, "qteQFile_rename",         "QFile"));
    mixin(generateFunQt(18521, "qteQFile_copy",           "QFile"));
    mixin(generateFunQt(18522, "qteQFile_copy_static",    "QFile"));
    mixin(generateFunQt(18523, "qteQFile_error",          "QFile"));
    mixin(generateFunQt(18524, "qteQFile_errorString",    "QFile"));
    mixin(generateFunQt(18525, "qteQFile_permissions",    "QFile"));
    mixin(generateFunQt(18526, "qteQFile_setPermissions", "QFile"));
    mixin(generateFunQt(18527, "qteQFile_resize",         "QFile"));
    mixin(generateFunQt(18528, "qteQFile_readAll_text",   "QFile"));
}

// ====================================================================
// QFile D wrapper
// ====================================================================

@live class QFile {
private:
    void* _ptr;

public:
    /// Create empty QFile (call setFileName before open).
    this() {
        _ptr = (cast(t_qp__)pFunQt[18500])();
    }

    /// Create QFile with file path.
    this(string path) {
        auto ws = toQString(path);
        _ptr = (cast(t_qp__qp)pFunQt[18501])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }

    ~this() {
        if (_ptr !is null && pFunQt[18502] !is null) {
            (cast(t_v__qp)pFunQt[18502])(_ptr);
            _ptr = null;
        }
    }

    void* getPtr() { return _ptr; }

    // ── Open / Close ──────────────────────────────────────────────────────────

    /// Open file. mode: combination of OpenMode flags.
    bool open(int mode) {
        return (cast(t_b__qp_i)pFunQt[18503])(_ptr, mode) != 0;
    }

    QFile close() {
        (cast(t_v__qp)pFunQt[18504])(_ptr);
        return this;
    }

    bool isOpen() {
        return (cast(t_i__qp)pFunQt[18505])(_ptr) != 0;
    }

    // ── File name ─────────────────────────────────────────────────────────────

    string fileName() {
        void* _qs = (cast(t_qp__qp)pFunQt[18506])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    QFile setFileName(string path) {
        auto ws = toQString(path);
        (cast(t_v__qp_qp)pFunQt[18507])(_ptr, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Existence ─────────────────────────────────────────────────────────────

    bool exists() {
        return (cast(t_i__qp)pFunQt[18508])(_ptr) != 0;
    }

    /// Static: check if file exists by path.
    static bool fileExists(string path) {
        auto ws = toQString(path);
        bool r = (cast(t_i__qp)pFunQt[18509])(ws) != 0;
        (cast(t_v__qp)pFunQt[22])(ws);
        return r;
    }

    // ── Size / Position ───────────────────────────────────────────────────────

    int size() { return (cast(t_i__qp)pFunQt[18510])(_ptr); }
    int pos()  { return (cast(t_i__qp)pFunQt[18511])(_ptr); }

    bool seek(int p) {
        return (cast(t_b__qp_i)pFunQt[18512])(_ptr, p) != 0;
    }

    bool atEnd() {
        return (cast(t_i__qp)pFunQt[18513])(_ptr) != 0;
    }

    // ── Read ──────────────────────────────────────────────────────────────────

    /// Read entire file as binary. Returns D-owned ubyte[].
    ubyte[] readAll() {
        int len;
        void* buf = (cast(t_qp__qp_ip)pFunQt[18514])(_ptr, &len);
        if (buf is null || len == 0) return null;
        ubyte[] result = (cast(ubyte*)buf)[0 .. len].dup;
        (cast(t_v__qp)pFunQt[18515])(buf); // freeBuffer
        return result;
    }

    /// Read entire file as UTF-8 text string.
    string readAllText() {
        void* _qs = (cast(t_qp__qp)pFunQt[18528])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Write ─────────────────────────────────────────────────────────────────

    /// Write raw bytes. Returns number of bytes written, or -1 on error.
    int write(const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[18516])(
            _ptr, cast(void*)data.ptr, cast(int)data.length);
    }

    /// Write UTF-8 string. Returns number of bytes written, or -1 on error.
    int writeText(string text) {
        return (cast(t_i__qp_qp_i)pFunQt[18516])(
            _ptr, cast(void*)text.ptr, cast(int)text.length);
    }

    bool flush() {
        return (cast(t_i__qp)pFunQt[18517])(_ptr) != 0;
    }

    // ── File operations ───────────────────────────────────────────────────────

    /// Remove this file. File must be closed.
    bool remove() {
        return (cast(t_i__qp)pFunQt[18518])(_ptr) != 0;
    }

    /// Static: remove file by path.
    static bool fileRemove(string path) {
        auto ws = toQString(path);
        bool r = (cast(t_i__qp)pFunQt[18519])(ws) != 0;
        (cast(t_v__qp)pFunQt[22])(ws);
        return r;
    }

    /// Rename this file. File must be closed.
    bool rename(string newName) {
        auto ws = toQString(newName);
        bool r = (cast(t_i__qp_qp)pFunQt[18520])(_ptr, ws) != 0;
        (cast(t_v__qp)pFunQt[22])(ws);
        return r;
    }

    /// Copy this file to newName.
    bool copy(string newName) {
        auto ws = toQString(newName);
        bool r = (cast(t_i__qp_qp)pFunQt[18521])(_ptr, ws) != 0;
        (cast(t_v__qp)pFunQt[22])(ws);
        return r;
    }

    /// Static: copy file from src to dst.
    static bool fileCopy(string src, string dst) {
        auto wss = toQString(src);
        auto wsd = toQString(dst);
        bool r = (cast(t_i__qp_qp)pFunQt[18522])(wss, wsd) != 0;
        (cast(t_v__qp)pFunQt[22])(wss);
        (cast(t_v__qp)pFunQt[22])(wsd);
        return r;
    }

    // ── Error ─────────────────────────────────────────────────────────────────

    /// QFileDevice::FileError enum value. 0=NoError.
    int error() { return (cast(t_i__qp)pFunQt[18523])(_ptr); }

    string errorString() {
        void* _qs = (cast(t_qp__qp)pFunQt[18524])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Permissions / Resize ──────────────────────────────────────────────────

    int permissions() { return (cast(t_i__qp)pFunQt[18525])(_ptr); }

    bool setPermissions(int perms) {
        return (cast(t_b__qp_i)pFunQt[18526])(_ptr, perms) != 0;
    }

    bool resize(int sz) {
        return (cast(t_b__qp_i)pFunQt[18527])(_ptr, sz) != 0;
    }

} // class QFile
