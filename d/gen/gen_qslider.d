/**
 * gen_qslider.d — GENERATED wrapper for QSlider.
 * Module: QSlider  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qslider;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip;
import gen_qabstractslider : QAbstractSlider;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSlider() {
    mixin(generateFunQt(2000, "qteQSlider_create", "QSlider"));
    mixin(generateFunQt(2001, "qteQSlider_delete", "QSlider"));
    mixin(generateFunQt(2007, "qteQSlider_setTickPosition", "QSlider"));
    mixin(generateFunQt(2008, "qteQSlider_tickPosition", "QSlider"));
    mixin(generateFunQt(2009, "qteQSlider_setTickInterval", "QSlider"));
    mixin(generateFunQt(2010, "qteQSlider_tickInterval", "QSlider"));
    mixin(generateFunQt(2011, "qteQSlider_event", "QSlider"));
    mixin(generateFunQt(2036, "qteQSlider_setEventHandler", "QSlider"));
}

static this() {
    registerModule("QSlider", "qte56_widgets.dll", &loadQSlider);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSlider.
@live class QSlider : QAbstractSlider {
public:
    /// Create QSlider. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[2000])(parent);
    }

    /// Create QSlider without parent (top-level widget).
    this() { this(cast(void*)null); }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QSlider* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QSlider wrap(void* wh) {
        auto w = new QSlider(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// setTickPosition
    QSlider setTickPosition(int position) {
        (cast(t_v__qp_i)pFunQt[2007])(_wh, position);
        return this;
    }

    /// tickPosition
    int tickPosition() {
        return cast(int)(cast(t_i__qp)pFunQt[2008])(_wh);
    }

    /// setTickInterval
    QSlider setTickInterval(int ti) {
        (cast(t_v__qp_i)pFunQt[2009])(_wh, ti);
        return this;
    }

    /// tickInterval
    int tickInterval() {
        return cast(int)(cast(t_i__qp)pFunQt[2010])(_wh);
    }

    /// event
    override bool event(void* event) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[2011])(_wh, event);
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QSlider setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[2036])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSlider onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSlider onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSlider onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSlider onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSlider onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSlider onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QSlider onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSlider onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QSlider onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QSlider onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QSlider onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QSlider onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QSlider onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QSlider onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSlider onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSlider onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QSlider onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QSlider
