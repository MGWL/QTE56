/**
 * gen_qicon.d — wrapper for QIcon (value type).
 * Module: QIcon  |  DLL: qte56_foundation.dll
 *
 * QIcon is a Qt value type (not a QWidget). It's managed as an opaque
 * heap-allocated pointer. The D object owns the C++ QIcon and must
 * destroy it (via destructor or explicit destroy()).
 */
module gen_qicon;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DSize, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for this module:
mixin(generateAlias("l__qp"));               // t_l__qp : long function(void*)
mixin(generateAlias("i__qp_i"));             // t_i__qp_i : int function(void*, int)
mixin(generateAlias("qp__qp_i_i_i_i"));     // t_qp__qp_i_i_i_i : void* function(void*, int, int, int, int)
mixin(generateAlias("v__qp_qp_i_i_i_i")); // t_v__qp_qp_i_i_i_i : void function(void*, void*, int, int, int, int, int)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQIcon() {
    mixin(generateFunQt(6600, "qteQIcon_create",        "QIcon"));
    mixin(generateFunQt(6601, "qteQIcon_delete",        "QIcon"));
    mixin(generateFunQt(6602, "qteQIcon_create_file",   "QIcon"));
    mixin(generateFunQt(6603, "qteQIcon_isNull",        "QIcon"));
    mixin(generateFunQt(6604, "qteQIcon_name",          "QIcon"));
    mixin(generateFunQt(6605, "qteQIcon_cacheKey",      "QIcon"));
    mixin(generateFunQt(6606, "qteQIcon_addFile",       "QIcon"));
    mixin(generateFunQt(6607, "qteQIcon_setIsMask",     "QIcon"));
    mixin(generateFunQt(6608, "qteQIcon_isMask",        "QIcon"));
    mixin(generateFunQt(6609, "qteQIcon_fromTheme",     "QIcon"));
    mixin(generateFunQt(6610, "qteQIcon_hasThemeIcon",  "QIcon"));
    mixin(generateFunQt(6611, "qteQIcon_actualSize",    "QIcon"));
}

static this() {
    registerModule("QIcon", "qte56_foundation.dll", &loadQIcon);
}

// ====================================================================
// QIcon enums
// ====================================================================

/// QIcon::Mode
enum IconMode : int {
    Normal   = 0,
    Disabled = 1,
    Active   = 2,
    Selected = 3,
}

/// QIcon::State
enum IconState : int {
    On  = 0,
    Off = 1,
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt value type QIcon.
/// Unlike QWidget subclasses, QIcon has no parent ownership —
/// the D object owns the C++ QIcon and must destroy it.
@live class QIcon {
private:
    void* _ptr;  // QIcon* on heap

public:
    /// Create empty (null) icon.
    this() {
        _ptr = (cast(t_qp__qp)pFunQt[6600])(null);
    }

    /// Create icon from file path (e.g. ":/icons/save.png" or "C:/icons/save.png").
    this(string path) {
        auto ws = toQString(path);
        _ptr = (cast(t_qp__qp)pFunQt[6602])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }

    /// Private ctor for wrap/fromTheme.
    private this(void* ptr, bool dummy) {
        _ptr = ptr;
    }

    ~this() {
        if (_ptr !is null && pFunQt[6601] !is null) {
            (cast(t_v__qp)pFunQt[6601])(_ptr);
            _ptr = null;
        }
    }

    /// Wrap an existing QIcon* (takes ownership — caller must not delete).
    static QIcon wrap(void* ptr) {
        return new QIcon(ptr, true);
    }

    /// Get raw pointer for passing to Qt functions that accept const QIcon&.
    void* getPtr() { return _ptr; }

    /// Returns true if the icon is null (no image data).
    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[6603])(_ptr);
    }

    /// Returns the icon's name (from theme or resource).
    string name() {
        void* qs = (cast(t_qp__qp)pFunQt[6604])(_ptr);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);  // qteQString_free
        return s;
    }

    /// Returns a unique cache key for this icon.
    long cacheKey() {
        return (cast(t_l__qp)pFunQt[6605])(_ptr);
    }

    /// Returns true if this icon is a mask.
    bool isMask() {
        return cast(bool)(cast(t_i__qp)pFunQt[6608])(_ptr);
    }

    /// Set whether this icon is a mask.
    QIcon setIsMask(bool mask) {
        (cast(t_v__qp_i)pFunQt[6607])(_ptr, mask ? 1 : 0);
        return this;
    }

    /// Add a file to the icon for the given size, mode, and state.
    /// Pass w=0, h=0 for any size.
    QIcon addFile(string path, int w = 0, int h = 0,
                 int mode = IconMode.Normal, int state = IconState.Off) {
        auto ws = toQString(path);
        (cast(t_v__qp_qp_i_i_i_i)pFunQt[6606])(
            _ptr, ws,
            w, h, mode, state);
        return this;
    }

    /// Returns the actual size for the requested size, mode, state.
    DSize actualSize(int w, int h,
                     int mode = IconMode.Normal, int state = IconState.Off) {
        DSize sz;
        void* qsz = (cast(t_qp__qp_i_i_i_i)pFunQt[6611])(
            _ptr, w, h, mode, state);
        (cast(t_v__qp_ip_ip)pFunQt[37])(qsz, &sz.w, &sz.h);
        return sz;
    }

    // ── Static methods ───────────────────────────────────────────────────

    /// Create icon from current theme by name.
    static QIcon fromTheme(string name) {
        auto ws = toQString(name);
        void* ptr = (cast(t_qp__qp)pFunQt[6609])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return new QIcon(ptr, true);
    }

    /// Check if the current theme has an icon with the given name.
    static bool hasThemeIcon(string name) {
        auto ws = toQString(name);
        return cast(bool)(cast(t_i__qp)pFunQt[6610])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }
}
