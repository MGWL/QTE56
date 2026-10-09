/**
 * gen_qtoolbutton.d — GENERATED wrapper for QToolButton.
 * Module: QToolButton  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtoolbutton;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp;
import gen_qabstractbutton : QAbstractButton;

// New aliases for this module:
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQToolButton() {
    mixin(generateFunQt(10400, "qteQToolButton_create", "QToolButton"));
    mixin(generateFunQt(10401, "qteQToolButton_delete", "QToolButton"));
    mixin(generateFunQt(10407, "qteQToolButton_toolButtonStyle", "QToolButton"));
    mixin(generateFunQt(10408, "qteQToolButton_arrowType", "QToolButton"));
    mixin(generateFunQt(10409, "qteQToolButton_setArrowType", "QToolButton"));
    mixin(generateFunQt(10410, "qteQToolButton_setMenu", "QToolButton"));
    mixin(generateFunQt(10411, "qteQToolButton_menu", "QToolButton"));
    mixin(generateFunQt(10412, "qteQToolButton_setPopupMode", "QToolButton"));
    mixin(generateFunQt(10413, "qteQToolButton_popupMode", "QToolButton"));
    mixin(generateFunQt(10414, "qteQToolButton_defaultAction", "QToolButton"));
    mixin(generateFunQt(10415, "qteQToolButton_setAutoRaise", "QToolButton"));
    mixin(generateFunQt(10416, "qteQToolButton_autoRaise", "QToolButton"));
    mixin(generateFunQt(10417, "qteQToolButton_showMenu", "QToolButton"));
    mixin(generateFunQt(10418, "qteQToolButton_setToolButtonStyle", "QToolButton"));
    mixin(generateFunQt(10419, "qteQToolButton_setDefaultAction", "QToolButton"));
    mixin(generateFunQt(10444, "qteQToolButton_setEventHandler", "QToolButton"));
    mixin(generateFunQt(10445, "qteQToolButton_connect_triggered", "QToolButton"));
}

static this() {
    registerModule("QToolButton", "qte56_mainwin.dll", &loadQToolButton);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QToolButton.
@live class QToolButton : QAbstractButton {
public:
    /// Create QToolButton. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[10400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// toolButtonStyle
    int toolButtonStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[10407])(_wh);
    }

    /// arrowType
    int arrowType() {
        return cast(int)(cast(t_i__qp)pFunQt[10408])(_wh);
    }

    /// setArrowType
    QToolButton setArrowType(int type) {
        (cast(t_v__qp_i)pFunQt[10409])(_wh, type);
        return this;
    }

    /// setMenu
    QToolButton setMenu(void* menu) {
        (cast(t_v__qp_qp)pFunQt[10410])(_wh, menu);
        return this;
    }

    /// menu
    void* menu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10411])(_wh);
    }

    /// setPopupMode
    QToolButton setPopupMode(int mode) {
        (cast(t_v__qp_i)pFunQt[10412])(_wh, mode);
        return this;
    }

    /// popupMode
    int popupMode() {
        return cast(int)(cast(t_i__qp)pFunQt[10413])(_wh);
    }

    /// defaultAction
    void* defaultAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10414])(_wh);
    }

    /// setAutoRaise
    QToolButton setAutoRaise(bool enable) {
        (cast(t_v__qp_i)pFunQt[10415])(_wh, enable ? 1 : 0);
        return this;
    }

    /// autoRaise
    bool autoRaise() {
        return cast(bool)(cast(t_i__qp)pFunQt[10416])(_wh);
    }

    /// showMenu
    QToolButton showMenu() {
        (cast(t_v__qp)pFunQt[10417])(_wh);
        return this;
    }

    /// setToolButtonStyle
    QToolButton setToolButtonStyle(int style) {
        (cast(t_v__qp_i)pFunQt[10418])(_wh, style);
        return this;
    }

    /// setDefaultAction
    QToolButton setDefaultAction(void* p0) {
        (cast(t_v__qp_qp)pFunQt[10419])(_wh, p0);
        return this;
    }

    /// Connect signal triggered → прямой callback (DSlot_ptr)
    /// cb: extern(C) void function(void* dthis, int n, void* ptr)
    QToolButton connect_triggered(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[10445])(_wh, cb, dthis);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QToolButton setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[10444])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolButton onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolButton onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolButton onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolButton onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolButton onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolButton onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QToolButton onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolButton onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QToolButton onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolButton onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolButton onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolButton onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolButton onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QToolButton onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolButton onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolButton onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QToolButton onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QToolButton
