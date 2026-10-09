/**
 * gen_qdial.d — GENERATED wrapper for QDial.
 * Module: QDial  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qdial;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip;
import gen_qabstractslider : QAbstractSlider;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("v__qp_d"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQDial() {
    mixin(generateFunQt(5400, "qteQDial_create", "QDial"));
    mixin(generateFunQt(5401, "qteQDial_delete", "QDial"));
    mixin(generateFunQt(5402, "qteQDial_wrapping", "QDial"));
    mixin(generateFunQt(5403, "qteQDial_notchSize", "QDial"));
    mixin(generateFunQt(5404, "qteQDial_setNotchTarget", "QDial"));
    mixin(generateFunQt(5405, "qteQDial_notchTarget", "QDial"));
    mixin(generateFunQt(5406, "qteQDial_notchesVisible", "QDial"));
    mixin(generateFunQt(5409, "qteQDial_setNotchesVisible", "QDial"));
    mixin(generateFunQt(5410, "qteQDial_setWrapping", "QDial"));
}

static this() {
    registerModule("QDial", "qte56_widgets.dll", &loadQDial);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QDial.
@live class QDial : QAbstractSlider {
public:
    /// Create QDial. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[5400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// wrapping
    bool wrapping() {
        return cast(bool)(cast(t_i__qp)pFunQt[5402])(_wh);
    }

    /// notchSize
    int notchSize() {
        return cast(int)(cast(t_i__qp)pFunQt[5403])(_wh);
    }

    /// setNotchTarget
    QDial setNotchTarget(double target) {
        (cast(t_v__qp_d)pFunQt[5404])(_wh, target);
        return this;
    }

    /// notchTarget
    double notchTarget() {
        return cast(double)(cast(t_d__qp)pFunQt[5405])(_wh);
    }

    /// notchesVisible
    bool notchesVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[5406])(_wh);
    }

    /// setNotchesVisible
    QDial setNotchesVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[5409])(_wh, visible ? 1 : 0);
        return this;
    }

    /// setWrapping
    QDial setWrapping(bool on) {
        (cast(t_v__qp_i)pFunQt[5410])(_wh, on ? 1 : 0);
        return this;
    }

} // class QDial
