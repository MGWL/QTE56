/**
 * gen_qmdisubwindow.d — GENERATED wrapper for QMdiSubWindow.
 * Module: QMdiSubWindow  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmdisubwindow;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMdiSubWindow() {
    mixin(generateFunQt(7800, "qteQMdiSubWindow_create", "QMdiSubWindow"));
    mixin(generateFunQt(7801, "qteQMdiSubWindow_delete", "QMdiSubWindow"));
    mixin(generateFunQt(7807, "qteQMdiSubWindow_setWidget", "QMdiSubWindow"));
    mixin(generateFunQt(7808, "qteQMdiSubWindow_widget", "QMdiSubWindow"));
    mixin(generateFunQt(7809, "qteQMdiSubWindow_maximizedButtonsWidget", "QMdiSubWindow"));
    mixin(generateFunQt(7810, "qteQMdiSubWindow_maximizedSystemMenuIconWidget", "QMdiSubWindow"));
    mixin(generateFunQt(7811, "qteQMdiSubWindow_isShaded", "QMdiSubWindow"));
    mixin(generateFunQt(7812, "qteQMdiSubWindow_setOption", "QMdiSubWindow"));
    mixin(generateFunQt(7813, "qteQMdiSubWindow_testOption", "QMdiSubWindow"));
    mixin(generateFunQt(7814, "qteQMdiSubWindow_setKeyboardSingleStep", "QMdiSubWindow"));
    mixin(generateFunQt(7815, "qteQMdiSubWindow_keyboardSingleStep", "QMdiSubWindow"));
    mixin(generateFunQt(7816, "qteQMdiSubWindow_setKeyboardPageStep", "QMdiSubWindow"));
    mixin(generateFunQt(7817, "qteQMdiSubWindow_keyboardPageStep", "QMdiSubWindow"));
    mixin(generateFunQt(7818, "qteQMdiSubWindow_setSystemMenu", "QMdiSubWindow"));
    mixin(generateFunQt(7819, "qteQMdiSubWindow_systemMenu", "QMdiSubWindow"));
    mixin(generateFunQt(7820, "qteQMdiSubWindow_mdiArea", "QMdiSubWindow"));
    mixin(generateFunQt(7821, "qteQMdiSubWindow_showSystemMenu", "QMdiSubWindow"));
    mixin(generateFunQt(7822, "qteQMdiSubWindow_showShaded", "QMdiSubWindow"));
    mixin(generateFunQt(7823, "qteQMdiSubWindow_setEventHandler", "QMdiSubWindow"));
}

static this() {
    registerModule("QMdiSubWindow", "qte56_views.dll", &loadQMdiSubWindow);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMdiSubWindow.
@live class QMdiSubWindow : QWidget {
public:
    /// Create QMdiSubWindow. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[7800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setWidget
    QMdiSubWindow setWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[7807])(_wh, widget);
        return this;
    }

    /// widget
    void* widget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7808])(_wh);
    }

    /// maximizedButtonsWidget
    void* maximizedButtonsWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7809])(_wh);
    }

    /// maximizedSystemMenuIconWidget
    void* maximizedSystemMenuIconWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7810])(_wh);
    }

    /// isShaded
    bool isShaded() {
        return cast(bool)(cast(t_i__qp)pFunQt[7811])(_wh);
    }

    /// setOption
    QMdiSubWindow setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[7812])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int p0) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[7813])(_wh, p0);
    }

    /// setKeyboardSingleStep
    QMdiSubWindow setKeyboardSingleStep(int step) {
        (cast(t_v__qp_i)pFunQt[7814])(_wh, step);
        return this;
    }

    /// keyboardSingleStep
    int keyboardSingleStep() {
        return cast(int)(cast(t_i__qp)pFunQt[7815])(_wh);
    }

    /// setKeyboardPageStep
    QMdiSubWindow setKeyboardPageStep(int step) {
        (cast(t_v__qp_i)pFunQt[7816])(_wh, step);
        return this;
    }

    /// keyboardPageStep
    int keyboardPageStep() {
        return cast(int)(cast(t_i__qp)pFunQt[7817])(_wh);
    }

    /// setSystemMenu
    QMdiSubWindow setSystemMenu(void* systemMenu) {
        (cast(t_v__qp_qp)pFunQt[7818])(_wh, systemMenu);
        return this;
    }

    /// systemMenu
    void* systemMenu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7819])(_wh);
    }

    /// mdiArea
    void* mdiArea() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7820])(_wh);
    }

    /// showSystemMenu
    QMdiSubWindow showSystemMenu() {
        (cast(t_v__qp)pFunQt[7821])(_wh);
        return this;
    }

    /// showShaded
    QMdiSubWindow showShaded() {
        (cast(t_v__qp)pFunQt[7822])(_wh);
        return this;
    }

    // Signal windowStateChanged — unsupported parameter types
    /// Connect signal aboutToActivate → ESlot
    QMdiSubWindow connect_aboutToActivate(ESlot eslot) {
        connectQt(_wh, "aboutToActivate()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QMdiSubWindow setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[7823])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiSubWindow onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiSubWindow onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiSubWindow onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMdiSubWindow onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMdiSubWindow onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMdiSubWindow onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QMdiSubWindow onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMdiSubWindow onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QMdiSubWindow onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiSubWindow onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiSubWindow onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiSubWindow onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiSubWindow onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QMdiSubWindow onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMdiSubWindow onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMdiSubWindow onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QMdiSubWindow onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QMdiSubWindow
