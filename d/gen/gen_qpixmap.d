/**
 * gen_qpixmap.d — wrapper for QPixmap (value type).
 * DLL: qte56_foundation.dll  |  Index block: 17600–17613, 20001–20002
 */
module gen_qpixmap;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_i__qp_qp, t_qp__, t_qp__i, t_qp__i_i, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_qp, toQString;
import gen_qbytearray : QByteArray;

// New aliases not already in gen_qcore:
mixin(generateAlias("qp__qp_i_i_i"));   // void* function(void*, int, int, int) — scaled
mixin(generateAlias("v__qp_i_i_i_i"));  // void function(void*, int, int, int, int) — fill
mixin(generateAlias("i__qp_qp_i_qp_i")); // int(void*, void*, int, void*, int) — loadFromData
mixin(generateAlias("qp__qp_qp_i_i"));   // void*(void*, void*, int, int) — saveToBuffer

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQPixmap() {
    mixin(generateFunQt(17600, "qteQPixmap_create",        "QPixmap"));
    mixin(generateFunQt(17601, "qteQPixmap_from_file",     "QPixmap"));
    mixin(generateFunQt(17602, "qteQPixmap_from_wh",       "QPixmap"));
    mixin(generateFunQt(17603, "qteQPixmap_delete",        "QPixmap"));
    mixin(generateFunQt(17604, "qteQPixmap_isNull",        "QPixmap"));
    mixin(generateFunQt(17605, "qteQPixmap_width",         "QPixmap"));
    mixin(generateFunQt(17606, "qteQPixmap_height",        "QPixmap"));
    mixin(generateFunQt(17607, "qteQPixmap_load",          "QPixmap"));
    mixin(generateFunQt(17608, "qteQPixmap_save",          "QPixmap"));
    mixin(generateFunQt(17609, "qteQPixmap_scaled",        "QPixmap"));
    mixin(generateFunQt(17610, "qteQPixmap_scaledToWidth", "QPixmap"));
    mixin(generateFunQt(17611, "qteQPixmap_scaledToHeight","QPixmap"));
    mixin(generateFunQt(17612, "qteQPixmap_fill",          "QPixmap"));
    mixin(generateFunQt(17613, "qteQLabel_setPixmap",      "QPixmap"));
    // Memory I/O
    mixin(generateFunQt(20001, "qteQPixmap_loadFromData",  "QPixmap"));
    mixin(generateFunQt(20002, "qteQPixmap_saveToBuffer",  "QPixmap"));
}

static this() {
    registerModule("QPixmap", "qte56_foundation.dll", &loadQPixmap);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QPixmap (value type — no parent widget).
///
/// Usage:
///   auto px = new QPixmap("image.png");     // load from file
///   auto px = new QPixmap(200, 150);        // create sized (uninitialized)
///   auto px = new QPixmap();                // null pixmap
///   label.setPixmap(px.getWH());            // pass to QLabel.setPixmap
@live class QPixmap {
private:
    void* _wh;
    bool  _qt_owned;   // true → do NOT delete on ~this

    /// No-op constructor for wrap() — does NOT call the C++ ctor.
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create an empty (null) pixmap.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[17600])();
    }

    /// Load pixmap from file path (PNG, JPG, BMP, etc.).
    this(string path) {
        _qt_owned = false;
        auto _ws = toQString(path);
        _wh = (cast(t_qp__qp)pFunQt[17601])(_ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    /// Create a pixmap of given size (pixels uninitialised — call fill() after).
    this(int w, int h) {
        _qt_owned = false;
        _wh = (cast(t_qp__i_i)pFunQt[17602])(w, h);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[17603] !is null) {
            (cast(t_v__qp)pFunQt[17603])(_wh);
            _wh = null;
        }
    }

    /// Raw Qt object handle — pass to widget methods that accept void*.
    void* getWH() { return _wh; }

    /// Wrap a heap-allocated C++ QPixmap* — D takes ownership and deletes on ~this.
    static QPixmap wrap(void* ptr) {
        if (ptr is null) return null;
        auto px = new QPixmap(false);
        px._wh = ptr;
        return px;
    }

    // ── Properties ────────────────────────────────────────────────────────

    /// True when the pixmap is null (not loaded or created with valid size).
    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[17604])(_wh);
    }

    /// Width in pixels (0 for null pixmap).
    int width() {
        return cast(int)(cast(t_i__qp)pFunQt[17605])(_wh);
    }

    /// Height in pixels (0 for null pixmap).
    int height() {
        return cast(int)(cast(t_i__qp)pFunQt[17606])(_wh);
    }

    // ── Load / Save ───────────────────────────────────────────────────────

    /// Load image from file into this pixmap. Returns true on success.
    bool load(string path) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[17607])(
            _wh, _ws);
    }

    /// Save pixmap to file. Format inferred from extension. Returns true on success.
    bool save(string path) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[17608])(
            _wh, _ws);
    }

    /// Load pixmap from memory buffer. fmt: "PNG", "JPEG", "" = auto-detect.
    bool loadFromData(const(ubyte)[] data, string fmt = "") {
        return (cast(t_i__qp_qp_i_qp_i)pFunQt[20001])(
            _wh, cast(void*)data.ptr, cast(int)data.length,
            cast(void*)fmt.ptr, cast(int)fmt.length) != 0;
    }

    /// Save pixmap to a QByteArray in memory. fmt: "PNG", "JPEG", etc. (default "PNG").
    /// Returns null QByteArray if save failed.
    QByteArray saveToBuffer(string fmt = "PNG", int quality = -1) {
        void* ba = (cast(t_qp__qp_qp_i_i)pFunQt[20002])(
            _wh, cast(void*)fmt.ptr, cast(int)fmt.length, quality);
        return QByteArray.wrap(ba);
    }

    // ── Transforms ────────────────────────────────────────────────────────

    /// Return a scaled copy.
    /// aspectMode: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding
    QPixmap scaled(int w, int h, int aspectMode = 1) {
        void* ptr = (cast(t_qp__qp_i_i_i)pFunQt[17609])(_wh, w, h, aspectMode);
        return QPixmap.wrap(ptr);
    }

    /// Return a copy scaled to the given width while preserving aspect ratio.
    QPixmap scaledToWidth(int w) {
        void* ptr = (cast(t_qp__qp_i)pFunQt[17610])(_wh, w);
        return QPixmap.wrap(ptr);
    }

    /// Return a copy scaled to the given height while preserving aspect ratio.
    QPixmap scaledToHeight(int h) {
        void* ptr = (cast(t_qp__qp_i)pFunQt[17611])(_wh, h);
        return QPixmap.wrap(ptr);
    }

    // ── Fill ──────────────────────────────────────────────────────────────

    /// Fill the entire pixmap with a solid color (RGBA, 0–255 each).
    QPixmap fill(int r = 0, int g = 0, int b = 0, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[17612])(_wh, r, g, b, a);
        return this;
    }
}
