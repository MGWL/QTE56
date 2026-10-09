/**
 * gen_qpicture.d — wrapper for QPicture (value type, QPaintDevice).
 * DLL: qte56_foundation.dll  |  Index block: 18400–18408
 */
module gen_qpicture;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DRect, t_i__qp, t_i__qp_qp, t_qp__, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, toQString;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));          // int(void*, void*) — play(QPainter*)
mixin(generateAlias("v__qp_i_i_i_i"));     // void(void*, int, int, int, int) — setBoundingRect (5 args)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQPicture() {
    // Lifecycle
    mixin(generateFunQt(18400, "qteQPicture_create",         "QPicture"));
    mixin(generateFunQt(18401, "qteQPicture_delete",         "QPicture"));
    // Properties
    mixin(generateFunQt(18402, "qteQPicture_isNull",         "QPicture"));
    // Play
    mixin(generateFunQt(18403, "qteQPicture_play",           "QPicture"));
    // Load / Save
    mixin(generateFunQt(18404, "qteQPicture_load",           "QPicture"));
    mixin(generateFunQt(18405, "qteQPicture_save",           "QPicture"));
    // Size / Bounds
    mixin(generateFunQt(18406, "qteQPicture_size",           "QPicture"));
    mixin(generateFunQt(18407, "qteQPicture_boundingRect",   "QPicture"));
    mixin(generateFunQt(18408, "qteQPicture_setBoundingRect","QPicture"));
}

static this() {
    registerModule("QPicture", "qte56_foundation.dll", &loadQPicture);
}

// ====================================================================
// Class wrapper — value type (QPaintDevice)
// ====================================================================

/// D wrapper for Qt class QPicture.
/// QPicture is a QPaintDevice — QPainter can paint into it.
///
/// Usage:
///   auto pic = new QPicture();
///   auto p = new QPainter(pic.getWH(), true);  // begin() on picture
///   p.drawRect(10, 10, 80, 80);
///   p.end();
///   pic.save("drawing.pic");
@live class QPicture {
private:
    void* _wh;

public:
    /// Create an empty QPicture.
    this() {
        _wh = (cast(t_qp__)pFunQt[18400])();
    }

    ~this() {
        if (_wh !is null && pFunQt[18401] !is null) {
            (cast(t_v__qp)pFunQt[18401])(_wh);
            _wh = null;
        }
    }

    /// Raw Qt object handle — pass to QPainter constructor as device.
    void* getWH() { return _wh; }

    // ── Properties ────────────────────────────────────────────────────────

    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[18402])(_wh);
    }

    // ── Play ──────────────────────────────────────────────────────────────

    /// Replay the picture using a QPainter. Pass painter.getWH().
    bool play(void* painter) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18403])(_wh, painter);
    }

    // ── Load / Save ───────────────────────────────────────────────────────

    bool load(string path) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18404])(
            _wh, _ws);
    }

    bool save(string path) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18405])(
            _wh, _ws);
    }

    // ── Size / Bounds ─────────────────────────────────────────────────────

    /// Data size in bytes.
    int size() {
        return cast(int)(cast(t_i__qp)pFunQt[18406])(_wh);
    }

    /// Bounding rect of all drawing commands.
    DRect boundingRect() {
        DRect _vt;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[18407])(_wh, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// Set bounding rect explicitly.
    QPicture setBoundingRect(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18408])(_wh, x, y, w, h);
        return this;
    }
}
