/**
 * gen_qpushbutton.d — GENERATED wrapper for QPushButton.
 * Module: QPushButton  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qpushbutton;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, toQString;
import gen_qabstractbutton : QAbstractButton;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQPushButton() {
    mixin(generateFunQt(400, "qteQPushButton_create", "QPushButton"));
    mixin(generateFunQt(401, "qteQPushButton_delete", "QPushButton"));
    mixin(generateFunQt(405, "qteQPushButton_create_text", "QPushButton"));
    mixin(generateFunQt(410, "qteQPushButton_autoDefault", "QPushButton"));
    mixin(generateFunQt(411, "qteQPushButton_setAutoDefault", "QPushButton"));
    mixin(generateFunQt(412, "qteQPushButton_isDefault", "QPushButton"));
    mixin(generateFunQt(413, "qteQPushButton_setDefault", "QPushButton"));
    mixin(generateFunQt(414, "qteQPushButton_setMenu", "QPushButton"));
    mixin(generateFunQt(415, "qteQPushButton_menu", "QPushButton"));
    mixin(generateFunQt(416, "qteQPushButton_setFlat", "QPushButton"));
    mixin(generateFunQt(417, "qteQPushButton_isFlat", "QPushButton"));
    mixin(generateFunQt(418, "qteQPushButton_showMenu", "QPushButton"));
    mixin(generateFunQt(419, "qteQPushButton_setEventHandler", "QPushButton"));
}

static this() {
    registerModule("QPushButton", "qte56_widgets.dll", &loadQPushButton);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QPushButton.
@live class QPushButton : QAbstractButton {
public:
    /// Create QPushButton. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QPushButton* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QPushButton wrap(void* wh) {
        auto w = new QPushButton(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// Create QPushButton with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[405])(
            _ws, parent);
    }

    /// autoDefault
    bool autoDefault() {
        return cast(bool)(cast(t_i__qp)pFunQt[410])(_wh);
    }

    /// setAutoDefault
    QPushButton setAutoDefault(bool p0) {
        (cast(t_v__qp_i)pFunQt[411])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isDefault
    bool isDefault() {
        return cast(bool)(cast(t_i__qp)pFunQt[412])(_wh);
    }

    /// setDefault
    QPushButton setDefault(bool p0) {
        (cast(t_v__qp_i)pFunQt[413])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setMenu
    QPushButton setMenu(void* menu) {
        (cast(t_v__qp_qp)pFunQt[414])(_wh, menu);
        return this;
    }

    /// menu
    void* menu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[415])(_wh);
    }

    /// setFlat
    QPushButton setFlat(bool p0) {
        (cast(t_v__qp_i)pFunQt[416])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isFlat
    bool isFlat() {
        return cast(bool)(cast(t_i__qp)pFunQt[417])(_wh);
    }

    /// showMenu
    QPushButton showMenu() {
        (cast(t_v__qp)pFunQt[418])(_wh);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QPushButton setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[419])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPushButton onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPushButton onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPushButton onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QPushButton onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QPushButton onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QPushButton onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QPushButton onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QPushButton onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QPushButton onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QPushButton onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QPushButton onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QPushButton onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QPushButton onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QPushButton onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QPushButton onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QPushButton onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QPushButton onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QPushButton
