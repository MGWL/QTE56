/**
 * gen_qbrush.d — wrapper for QBrush (value type, like QColor/QFont).
 * Module: QBrush  |  DLL: qte56_drawing.dll
 * Index block: 19761–19767 (7 functions)
 */
module gen_qbrush;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i;

// New aliases for this module:
mixin(generateAlias("qp__qp_ui_i")); // void*(void*, uint, int)  — create_rgba
mixin(generateAlias("v__qp_ui"));    // void(void*, uint)         — setColor
mixin(generateAlias("ui__qp"));      // uint(void*)               — color

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQBrush() {
    mixin(generateFunQt(19761, "qteQBrush_create",       "QBrush"));
    mixin(generateFunQt(19762, "qteQBrush_delete",       "QBrush"));
    mixin(generateFunQt(19763, "qteQBrush_create_rgba",  "QBrush"));
    mixin(generateFunQt(19764, "qteQBrush_setColor",     "QBrush"));
    mixin(generateFunQt(19765, "qteQBrush_color",        "QBrush"));
    mixin(generateFunQt(19766, "qteQBrush_setStyle",     "QBrush"));
    mixin(generateFunQt(19767, "qteQBrush_style",        "QBrush"));
}

static this() {
    registerModule("QBrush", "qte56_drawing.dll", &loadQBrush);
}

// ====================================================================
// Class wrapper — value type (like QFont, QColor)
// ====================================================================

/// D wrapper for Qt class QBrush (value type).
@live class QBrush {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create default QBrush (NoBrush / no colour).
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19761])(null);
    }

    /// Create QBrush with ARGB colour and brush style.
    /// style: 0=NoBrush, 1=SolidPattern, 2=Dense1Pattern … 15=HorPattern etc.
    this(uint rgba, int style = 1 /*SolidPattern*/) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp_ui_i)pFunQt[19763])(null, rgba, style);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19762] !is null) {
            (cast(t_v__qp)pFunQt[19762])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated QBrush pointer. Dtor WILL delete.
    static QBrush wrap(void* ptr) {
        if (ptr is null) return null;
        auto b = new QBrush(false);
        b._wh = ptr;
        return b;
    }

    // ── Colour ───────────────────────────────────────────────────────

    /// Set brush colour from packed ARGB value (0xAARRGGBB).
    QBrush setColor(uint rgba) {
        (cast(t_v__qp_ui)pFunQt[19764])(_wh, rgba);
        return this;
    }

    /// Brush colour as packed ARGB (0xAARRGGBB).
    uint color() {
        return cast(uint)(cast(t_ui__qp)pFunQt[19765])(_wh);
    }

    // ── Style ────────────────────────────────────────────────────────

    /// Set brush style (Qt::BrushStyle).
    QBrush setStyle(int s) {
        (cast(t_v__qp_i)pFunQt[19766])(_wh, s);
        return this;
    }

    /// Brush style (Qt::BrushStyle).
    int style() {
        return cast(int)(cast(t_i__qp)pFunQt[19767])(_wh);
    }

    // ── Helpers ──────────────────────────────────────────────────────

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QBrush
