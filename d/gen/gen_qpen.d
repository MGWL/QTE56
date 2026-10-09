/**
 * gen_qpen.d — wrapper for QPen (value type, like QColor/QFont).
 * Module: QPen  |  DLL: qte56_drawing.dll
 * Index block: 19748–19760 (13 functions)
 */
module gen_qpen;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i;

// New aliases for this module:
mixin(generateAlias("qp__qp_ui_i_i")); // void*(void*, uint, int, int)  — create_rgba
mixin(generateAlias("v__qp_ui"));      // void(void*, uint)              — setColor
mixin(generateAlias("ui__qp"));        // uint(void*)                    — color

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQPen() {
    mixin(generateFunQt(19748, "qteQPen_create",              "QPen"));
    mixin(generateFunQt(19749, "qteQPen_delete",              "QPen"));
    mixin(generateFunQt(19750, "qteQPen_create_rgba",         "QPen"));
    mixin(generateFunQt(19751, "qteQPen_setColor",            "QPen"));
    mixin(generateFunQt(19752, "qteQPen_color",               "QPen"));
    mixin(generateFunQt(19753, "qteQPen_setWidth",            "QPen"));
    mixin(generateFunQt(19754, "qteQPen_width",               "QPen"));
    mixin(generateFunQt(19755, "qteQPen_setStyle",            "QPen"));
    mixin(generateFunQt(19756, "qteQPen_style",               "QPen"));
    mixin(generateFunQt(19757, "qteQPen_setCapStyle",         "QPen"));
    mixin(generateFunQt(19758, "qteQPen_capStyle",            "QPen"));
    mixin(generateFunQt(19759, "qteQPen_setJoinStyle",        "QPen"));
    mixin(generateFunQt(19760, "qteQPen_joinStyle",           "QPen"));
    // QPainter extensions (also in qte56_drawing.dll, loaded here):
    mixin(generateFunQt(19786, "qteQDrawing_painter_setPen",  "QPen"));
    mixin(generateFunQt(19787, "qteQDrawing_painter_setBrush","QPen"));
}

static this() {
    registerModule("QPen", "qte56_drawing.dll", &loadQPen);
}

// ====================================================================
// Class wrapper — value type (like QFont, QColor)
// ====================================================================

/// D wrapper for Qt class QPen (value type).
@live class QPen {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create default QPen.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19748])(null);
    }

    /// Create QPen with ARGB colour, pixel width and pen style.
    /// style: 0=NoPen, 1=SolidLine, 2=DashLine, 3=DotLine, 4=DashDotLine, 5=DashDotDotLine
    this(uint rgba, int width = 1, int style = 1 /*SolidLine*/) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp_ui_i_i)pFunQt[19750])(null, rgba, width, style);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19749] !is null) {
            (cast(t_v__qp)pFunQt[19749])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated QPen pointer. Dtor WILL delete.
    static QPen wrap(void* ptr) {
        if (ptr is null) return null;
        auto p = new QPen(false);
        p._wh = ptr;
        return p;
    }

    // ── Colour ───────────────────────────────────────────────────────

    /// Set pen colour from packed ARGB value (0xAARRGGBB).
    QPen setColor(uint rgba) {
        (cast(t_v__qp_ui)pFunQt[19751])(_wh, rgba);
        return this;
    }

    /// Pen colour as packed ARGB (0xAARRGGBB).
    uint color() {
        return cast(uint)(cast(t_ui__qp)pFunQt[19752])(_wh);
    }

    // ── Width ────────────────────────────────────────────────────────

    /// Set pen width in pixels (integer).
    QPen setWidth(int w) {
        (cast(t_v__qp_i)pFunQt[19753])(_wh, w);
        return this;
    }

    /// Pen width in pixels.
    int width() {
        return cast(int)(cast(t_i__qp)pFunQt[19754])(_wh);
    }

    // ── Style ────────────────────────────────────────────────────────

    /// Set pen style (Qt::PenStyle).
    QPen setStyle(int s) {
        (cast(t_v__qp_i)pFunQt[19755])(_wh, s);
        return this;
    }

    /// Pen style (Qt::PenStyle).
    int style() {
        return cast(int)(cast(t_i__qp)pFunQt[19756])(_wh);
    }

    // ── Cap style ────────────────────────────────────────────────────

    /// Set cap style (Qt::PenCapStyle).
    QPen setCapStyle(int s) {
        (cast(t_v__qp_i)pFunQt[19757])(_wh, s);
        return this;
    }

    /// Cap style (Qt::PenCapStyle).
    int capStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[19758])(_wh);
    }

    // ── Join style ───────────────────────────────────────────────────

    /// Set join style (Qt::PenJoinStyle).
    QPen setJoinStyle(int s) {
        (cast(t_v__qp_i)pFunQt[19759])(_wh, s);
        return this;
    }

    /// Join style (Qt::PenJoinStyle).
    int joinStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[19760])(_wh);
    }

    // ── Helpers ──────────────────────────────────────────────────────

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QPen
