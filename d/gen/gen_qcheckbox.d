/**
 * gen_qcheckbox.d — GENERATED wrapper for QCheckBox.
 * Module: QCheckBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qcheckbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, toQString;
import gen_qabstractbutton : QAbstractButton;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQCheckBox() {
    mixin(generateFunQt(1200, "qteQCheckBox_create", "QCheckBox"));
    mixin(generateFunQt(1201, "qteQCheckBox_delete", "QCheckBox"));
    mixin(generateFunQt(1202, "qteQCheckBox_create_text", "QCheckBox"));
    mixin(generateFunQt(1208, "qteQCheckBox_setTristate", "QCheckBox"));
    mixin(generateFunQt(1209, "qteQCheckBox_isTristate", "QCheckBox"));
    mixin(generateFunQt(1210, "qteQCheckBox_checkState", "QCheckBox"));
    mixin(generateFunQt(1211, "qteQCheckBox_setCheckState", "QCheckBox"));
    mixin(generateFunQt(1212, "qteQCheckBox_setEventHandler", "QCheckBox"));
}

static this() {
    registerModule("QCheckBox", "qte56_widgets.dll", &loadQCheckBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QCheckBox.
@live class QCheckBox : QAbstractButton {
public:
    /// Create QCheckBox. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[1200])(parent);
    }

    /// Create QCheckBox without parent (top-level widget).
    this() { this(cast(void*)null); }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QCheckBox* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QCheckBox wrap(void* wh) {
        auto w = new QCheckBox(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// Create QCheckBox with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[1202])(
            _ws, parent);
    }

    /// setTristate
    QCheckBox setTristate(bool y) {
        (cast(t_v__qp_i)pFunQt[1208])(_wh, y ? 1 : 0);
        return this;
    }

    /// isTristate
    bool isTristate() {
        return cast(bool)(cast(t_i__qp)pFunQt[1209])(_wh);
    }

    /// checkState
    int checkState() {
        return cast(int)(cast(t_i__qp)pFunQt[1210])(_wh);
    }

    /// setCheckState
    QCheckBox setCheckState(int state) {
        (cast(t_v__qp_i)pFunQt[1211])(_wh, state);
        return this;
    }

    /// Connect signal stateChanged → ESlot
    QCheckBox connect_stateChanged(ESlot eslot) {
        connectQt(_wh, "stateChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QCheckBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[1212])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QCheckBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QCheckBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QCheckBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QCheckBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QCheckBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QCheckBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QCheckBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QCheckBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QCheckBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QCheckBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QCheckBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QCheckBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QCheckBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QCheckBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QCheckBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QCheckBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QCheckBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QCheckBox
