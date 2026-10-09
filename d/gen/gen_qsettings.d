/**
 * gen_qsettings.d — D wrapper for QSettings.
 * Module: QSettings | DLL: qte56_foundation.dll
 * MANUALLY WRITTEN
 *
 * Index block: 42000–42020
 *
 * Supports string, int, bool, double values.
 * Not a QWidget — inherits QObject.
 *
 * Usage:
 *   auto s = new QSettings("MyOrg", "MyApp");
 *   s.setValue("width", 800);
 *   int w = s.valueInt("width", 640);
 *   s.sync();
 *
 * Formats: NativeFormat=0 (registry on Windows), IniFormat=1
 */
module gen_qsettings;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, t_i__qp, t_i__qp_qp, t_i__qp_qp_i, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString;
import gen_qbytearray : QByteArray;

// Aliases for QSettings (new QString* API — no length ints):
mixin(generateAlias("qp__qp_qp_qp"));     // void*(void*,void*,void*)    — create_app / value_s
mixin(generateAlias("qp__qp_i_qp"));      // void*(void*,int,void*)      — create_file
mixin(generateAlias("v__qp_qp_d"));       // void(void*,void*,double)    — setValue_d
mixin(generateAlias("d__qp_qp_d"));       // double(void*,void*,double)  — value_d
mixin(generateAlias("v__qp_qp_qp_i"));   // void(void*,void*,void*,int) — setValue_ba

// ====================================================================
// Load function addresses
// ====================================================================

static this() { registerModule("QSettings", "qte56_foundation.dll", &loadQSettings); }

void loadQSettings() {
    mixin(generateFunQt(7200, "qteQSettings_create_app",  "QSettings"));
    mixin(generateFunQt(7201, "qteQSettings_create_file", "QSettings"));
    mixin(generateFunQt(7202, "qteQSettings_delete",      "QSettings"));
    mixin(generateFunQt(7203, "qteQSettings_setValue_s",  "QSettings"));
    mixin(generateFunQt(7204, "qteQSettings_value_s",     "QSettings"));
    mixin(generateFunQt(7205, "qteQSettings_setValue_i",  "QSettings"));
    mixin(generateFunQt(7206, "qteQSettings_value_i",     "QSettings"));
    mixin(generateFunQt(7207, "qteQSettings_setValue_b",  "QSettings"));
    mixin(generateFunQt(7208, "qteQSettings_value_b",     "QSettings"));
    mixin(generateFunQt(7209, "qteQSettings_setValue_d",  "QSettings"));
    mixin(generateFunQt(7210, "qteQSettings_value_d",     "QSettings"));
    mixin(generateFunQt(7211, "qteQSettings_contains",    "QSettings"));
    mixin(generateFunQt(7212, "qteQSettings_remove",      "QSettings"));
    mixin(generateFunQt(7213, "qteQSettings_clear",       "QSettings"));
    mixin(generateFunQt(7214, "qteQSettings_sync",        "QSettings"));
    mixin(generateFunQt(7215, "qteQSettings_beginGroup",  "QSettings"));
    mixin(generateFunQt(7216, "qteQSettings_endGroup",    "QSettings"));
    mixin(generateFunQt(7217, "qteQSettings_group",       "QSettings"));
    mixin(generateFunQt(7218, "qteQSettings_status",      "QSettings"));
    mixin(generateFunQt(7219, "qteQSettings_isWritable",  "QSettings"));
    mixin(generateFunQt(7220, "qteQSettings_fileName",    "QSettings"));
    // Binary values
    mixin(generateFunQt(7221, "qteQSettings_setValue_ba", "QSettings"));
    mixin(generateFunQt(7222, "qteQSettings_value_ba",    "QSettings"));
}

// ====================================================================
// QSettings D wrapper
// ====================================================================

/// D wrapper for QSettings (persistent application settings).
/// Call sync() before destroying to ensure writes are flushed.
@live class QSettings {
private:
    void* _ptr;

public:
    /// Create QSettings backed by native storage (registry on Windows).
    this(string org, string app, void* parent = null) {
        auto _wo = toQString(org);
        auto _wa = toQString(app);
        _ptr = (cast(t_qp__qp_qp_qp)pFunQt[7200])(
            _wo,
            _wa,
            parent);
        (cast(t_v__qp)pFunQt[22])(_wo);
        (cast(t_v__qp)pFunQt[22])(_wa);
    }

    /// Create QSettings backed by a file.
    /// format: 0=NativeFormat, 1=IniFormat
    this(string filename, int format = 1, void* parent = null) {
        auto _wf = toQString(filename);
        _ptr = (cast(t_qp__qp_i_qp)pFunQt[7201])(
            _wf, format, parent);
        (cast(t_v__qp)pFunQt[22])(_wf);
    }

    ~this() {
        if (_ptr !is null && pFunQt[7202] !is null) {
            (cast(t_v__qp)pFunQt[7202])(_ptr);
            _ptr = null;
        }
    }

    void* getPtr() { return _ptr; }

    // ── String values ─────────────────────────────────────────────────────────

    QSettings setValue(string key, string value) {
        auto _k = toQString(key);
        auto _v = toQString(value);
        (cast(t_v__qp_qp_qp)pFunQt[7203])(_ptr, _k, _v);
        (cast(t_v__qp)pFunQt[22])(_k);
        (cast(t_v__qp)pFunQt[22])(_v);
        return this;
    }

    string value(string key, string defval = "") {
        auto _k = toQString(key);
        auto _d = toQString(defval);
        void* _qs = (cast(t_qp__qp_qp_qp)pFunQt[7204])(_ptr, _k, _d);
        (cast(t_v__qp)pFunQt[22])(_k);
        (cast(t_v__qp)pFunQt[22])(_d);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Integer values ────────────────────────────────────────────────────────

    QSettings setValue(string key, int value) {
        auto _k = toQString(key);
        (cast(t_v__qp_qp_i)pFunQt[7205])(_ptr, _k, value);
        (cast(t_v__qp)pFunQt[22])(_k);
        return this;
    }

    int valueInt(string key, int defval = 0) {
        auto _k = toQString(key);
        int r = (cast(t_i__qp_qp_i)pFunQt[7206])(_ptr, _k, defval);
        (cast(t_v__qp)pFunQt[22])(_k);
        return r;
    }

    // ── Boolean values ────────────────────────────────────────────────────────

    QSettings setValue(string key, bool value) {
        auto _k = toQString(key);
        (cast(t_v__qp_qp_i)pFunQt[7207])(_ptr, _k, value ? 1 : 0);
        (cast(t_v__qp)pFunQt[22])(_k);
        return this;
    }

    bool valueBool(string key, bool defval = false) {
        auto _k = toQString(key);
        bool r = cast(bool)(cast(t_i__qp_qp_i)pFunQt[7208])(_ptr, _k, defval ? 1 : 0);
        (cast(t_v__qp)pFunQt[22])(_k);
        return r;
    }

    // ── Double values ─────────────────────────────────────────────────────────

    QSettings setValue(string key, double value) {
        auto _k = toQString(key);
        (cast(t_v__qp_qp_d)pFunQt[7209])(_ptr, _k, value);
        (cast(t_v__qp)pFunQt[22])(_k);
        return this;
    }

    double valueDouble(string key, double defval = 0.0) {
        auto _k = toQString(key);
        double r = (cast(t_d__qp_qp_d)pFunQt[7210])(_ptr, _k, defval);
        (cast(t_v__qp)pFunQt[22])(_k);
        return r;
    }

    // ── Key management ────────────────────────────────────────────────────────

    bool contains(string key) {
        auto _k = toQString(key);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[7211])(_ptr,
            _k);
    }

    QSettings remove(string key) {
        auto _k = toQString(key);
        (cast(t_v__qp_qp)pFunQt[7212])(_ptr, _k);
        (cast(t_v__qp)pFunQt[22])(_k);
        return this;
    }

    QSettings clear() { (cast(t_v__qp)pFunQt[7213])(_ptr); return this; }

    /// Flush all pending changes to persistent storage.
    QSettings sync() { (cast(t_v__qp)pFunQt[7214])(_ptr); return this; }

    // ── Groups ────────────────────────────────────────────────────────────────

    QSettings beginGroup(string prefix) {
        auto _k = toQString(prefix);
        (cast(t_v__qp_qp)pFunQt[7215])(_ptr, _k);
        (cast(t_v__qp)pFunQt[22])(_k);
        return this;
    }

    QSettings endGroup() { (cast(t_v__qp)pFunQt[7216])(_ptr); return this; }

    string group() {
        void* _qs = (cast(t_qp__qp)pFunQt[7217])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Status ────────────────────────────────────────────────────────────────

    /// 0=NoError, 1=AccessError, 2=FormatError
    int status() { return (cast(t_i__qp)pFunQt[7218])(_ptr); }
    bool isWritable() { return cast(bool)(cast(t_i__qp)pFunQt[7219])(_ptr); }

    string fileName() {
        void* _qs = (cast(t_qp__qp)pFunQt[7220])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }


    // ── Binary values ─────────────────────────────────────────────────────────

    /// Store raw bytes under key (persisted as base64 in INI, binary in registry).
    QSettings setBytes(string key, const(ubyte)[] data) {
        auto _wk = toQString(key);
        (cast(t_v__qp_qp_qp_i)pFunQt[7221])(
            _ptr, _wk, cast(void*)data.ptr, cast(int)data.length);
        (cast(t_v__qp)pFunQt[22])(_wk);
        return this;
    }

    /// Store QByteArray under key.
    QSettings setBytes(string key, QByteArray ba) {
        setBytes(key, ba.toSlice());
        return this;
    }

    /// Retrieve raw bytes for key. Returns null if key absent or not binary.
    ubyte[] getBytes(string key) {
        auto _wk = toQString(key);
        void* ba = (cast(t_qp__qp_qp)pFunQt[7222])(_ptr, _wk);
        (cast(t_v__qp)pFunQt[22])(_wk);
        if (ba is null) return null;
        auto result = QByteArray.wrap(ba);
        return result.toSlice();
    }

    /// Retrieve bytes as QByteArray. Returns null if key absent.
    QByteArray getBytesQBA(string key) {
        auto _wk = toQString(key);
        void* ba = (cast(t_qp__qp_qp)pFunQt[7222])(_ptr, _wk);
        (cast(t_v__qp)pFunQt[22])(_wk);
        return QByteArray.wrap(ba); // null-safe
    }

} // class QSettings
