/**
 * gen_qpalette.d — wrapper for QPalette (value type, like QColor/QFont).
 * Module: QPalette  |  DLL: qte56_drawing.dll
 * Index block: 19768–19775 (8 functions)
 */
module gen_qpalette;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_qp;

// New aliases for this module:
mixin(generateAlias("ui__qp_i"));     // uint(void*, int)            — color(role)
mixin(generateAlias("v__qp_i_ui"));   // void(void*, int, uint)      — setColor(role, rgba)
mixin(generateAlias("ui__qp_i_i"));   // uint(void*, int, int)       — colorGroup(grp, role)
mixin(generateAlias("v__qp_i_i_ui")); // void(void*, int, int, uint) — setColorGroup(grp, role, rgba)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQPalette() {
    mixin(generateFunQt(19768, "qteQPalette_create",           "QPalette"));
    mixin(generateFunQt(19769, "qteQPalette_delete",           "QPalette"));
    mixin(generateFunQt(19770, "qteQPalette_color",            "QPalette"));
    mixin(generateFunQt(19771, "qteQPalette_setColor",         "QPalette"));
    mixin(generateFunQt(19772, "qteQPalette_colorGroup",       "QPalette"));
    mixin(generateFunQt(19773, "qteQPalette_setColorGroup",    "QPalette"));
    mixin(generateFunQt(19774, "qteQPalette_setWidgetPalette", "QPalette"));
    mixin(generateFunQt(19775, "qteQPalette_getWidgetPalette", "QPalette"));
}

static this() {
    registerModule("QPalette", "qte56_drawing.dll", &loadQPalette);
}

// ====================================================================
// Class wrapper — value type (like QFont, QColor)
// ====================================================================

/// D wrapper for Qt class QPalette (value type).
@live class QPalette {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create default QPalette (application palette).
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19768])(null);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19769] !is null) {
            (cast(t_v__qp)pFunQt[19769])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated QPalette pointer. Dtor WILL delete.
    static QPalette wrap(void* ptr) {
        if (ptr is null) return null;
        auto p = new QPalette(false);
        p._wh = ptr;
        return p;
    }

    // ── Active group colour access ────────────────────────────────────

    /// Get colour for role in the Active group → packed ARGB (0xAARRGGBB).
    /// role: see ColorRole enum (WindowText=0, Button=1, … Window=10, etc.)
    uint color(int role) {
        return cast(uint)(cast(t_ui__qp_i)pFunQt[19770])(_wh, role);
    }

    /// Set colour for role in all groups → packed ARGB (0xAARRGGBB).
    QPalette setColor(int role, uint rgba) {
        (cast(t_v__qp_i_ui)pFunQt[19771])(_wh, role, rgba);
        return this;
    }

    // ── Per-group colour access ───────────────────────────────────────

    /// Get colour for group+role → packed ARGB.
    /// grp: 0=Active, 1=Disabled, 2=Inactive
    uint colorGroup(int grp, int role) {
        return cast(uint)(cast(t_ui__qp_i_i)pFunQt[19772])(_wh, grp, role);
    }

    /// Set colour for group+role.
    QPalette setColorGroup(int grp, int role, uint rgba) {
        (cast(t_v__qp_i_i_ui)pFunQt[19773])(_wh, grp, role, rgba);
        return this;
    }

    // ── Widget helpers ────────────────────────────────────────────────

    /// Apply this palette to a widget (pass widget.getWH()).
    QPalette setWidgetPalette(void* widget) {
        (cast(t_v__qp_qp)pFunQt[19774])(widget, _wh);
        return this;
    }

    /// Get the current palette of a widget — returns caller-owned QPalette copy.
    static QPalette getWidgetPalette(void* widget) {
        void* p = (cast(t_qp__qp)pFunQt[19775])(widget);
        return QPalette.wrap(p);
    }

    // ── Helpers ──────────────────────────────────────────────────────

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QPalette
