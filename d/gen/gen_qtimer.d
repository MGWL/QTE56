/**
 * gen_qtimer.d — GENERATED wrapper for QTimer.
 * Module: QTimer  |  DLL: qte56_foundation.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtimer;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i;

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTimer() {
    mixin(generateFunQt(4400, "qteQTimer_create",        "QTimer"));
    mixin(generateFunQt(4401, "qteQTimer_delete",        "QTimer"));
    mixin(generateFunQt(4402, "qteQTimer_interval",      "QTimer"));
    mixin(generateFunQt(4403, "qteQTimer_isSingleShot",  "QTimer"));
    mixin(generateFunQt(4404, "qteQTimer_stop",          "QTimer"));
    mixin(generateFunQt(4405, "qteQTimer_setInterval",   "QTimer"));
    mixin(generateFunQt(4407, "qteQTimer_setSingleShot", "QTimer"));
    mixin(generateFunQt(4408, "qteQTimer_isActive",      "QTimer"));
    mixin(generateFunQt(4409, "qteQTimer_timerId",       "QTimer"));
    mixin(generateFunQt(4410, "qteQTimer_remainingTime", "QTimer"));
    mixin(generateFunQt(4418, "qteQTimer_start_i",       "QTimer"));
    mixin(generateFunQt(4419, "qteQTimer_start_v",       "QTimer"));
}

static this() {
    registerModule("QTimer", "qte56_foundation.dll", &loadQTimer);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTimer.
@live class QTimer {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QTimer. parent=null → top-level (not a widget, parent is QObject).
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[4400])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[4401] !is null) {
            (cast(t_v__qp)pFunQt[4401])(_wh);
            _wh = null;
        }
    }

    /// interval
    int interval() {
        return cast(int)(cast(t_i__qp)pFunQt[4402])(_wh);
    }

    /// isSingleShot
    bool isSingleShot() {
        return cast(bool)(cast(t_i__qp)pFunQt[4403])(_wh);
    }

    /// stop
    QTimer stop() {
        (cast(t_v__qp)pFunQt[4404])(_wh);
        return this;
    }

    /// setInterval
    QTimer setInterval(int msec) {
        (cast(t_v__qp_i)pFunQt[4405])(_wh, msec);
        return this;
    }

    /// setSingleShot
    QTimer setSingleShot(bool singleShot) {
        (cast(t_v__qp_i)pFunQt[4407])(_wh, singleShot ? 1 : 0);
        return this;
    }

    /// isActive
    bool isActive() {
        return cast(bool)(cast(t_i__qp)pFunQt[4408])(_wh);
    }

    /// timerId — returns -1 when not active
    int timerId() {
        return cast(int)(cast(t_i__qp)pFunQt[4409])(_wh);
    }

    /// remainingTime
    int remainingTime() {
        return cast(int)(cast(t_i__qp)pFunQt[4410])(_wh);
    }

    /// start with explicit interval
    QTimer start(int msec) {
        (cast(t_v__qp_i)pFunQt[4418])(_wh, msec);
        return this;
    }

    /// start with stored interval
    QTimer start() {
        (cast(t_v__qp)pFunQt[4419])(_wh);
        return this;
    }

    /// Connect signal timeout → ESlot (invoke_v)
    QTimer connect_timeout(ESlot eslot) {
        connectQt(_wh, "timeout()", eslot, "invoke_v()");
        return this;
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTimer
