/**
 * gen_qmdiarea.d — GENERATED wrapper for QMdiArea.
 * Module: QMdiArea  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmdiarea;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, ptrListFromQStr, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qabstractscrollarea : QAbstractScrollArea;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMdiArea() {
    mixin(generateFunQt(7600, "qteQMdiArea_create", "QMdiArea"));
    mixin(generateFunQt(7601, "qteQMdiArea_delete", "QMdiArea"));
    mixin(generateFunQt(7607, "qteQMdiArea_currentSubWindow", "QMdiArea"));
    mixin(generateFunQt(7608, "qteQMdiArea_activeSubWindow", "QMdiArea"));
    mixin(generateFunQt(7609, "qteQMdiArea_addSubWindow", "QMdiArea"));
    mixin(generateFunQt(7610, "qteQMdiArea_removeSubWindow", "QMdiArea"));
    mixin(generateFunQt(7611, "qteQMdiArea_activationOrder", "QMdiArea"));
    mixin(generateFunQt(7612, "qteQMdiArea_setActivationOrder", "QMdiArea"));
    mixin(generateFunQt(7613, "qteQMdiArea_setOption", "QMdiArea"));
    mixin(generateFunQt(7614, "qteQMdiArea_testOption", "QMdiArea"));
    mixin(generateFunQt(7615, "qteQMdiArea_setViewMode", "QMdiArea"));
    mixin(generateFunQt(7616, "qteQMdiArea_viewMode", "QMdiArea"));
    mixin(generateFunQt(7617, "qteQMdiArea_documentMode", "QMdiArea"));
    mixin(generateFunQt(7618, "qteQMdiArea_setDocumentMode", "QMdiArea"));
    mixin(generateFunQt(7619, "qteQMdiArea_setTabsClosable", "QMdiArea"));
    mixin(generateFunQt(7620, "qteQMdiArea_tabsClosable", "QMdiArea"));
    mixin(generateFunQt(7621, "qteQMdiArea_setTabsMovable", "QMdiArea"));
    mixin(generateFunQt(7622, "qteQMdiArea_tabsMovable", "QMdiArea"));
    mixin(generateFunQt(7623, "qteQMdiArea_setTabShape", "QMdiArea"));
    mixin(generateFunQt(7624, "qteQMdiArea_tabShape", "QMdiArea"));
    mixin(generateFunQt(7625, "qteQMdiArea_setTabPosition", "QMdiArea"));
    mixin(generateFunQt(7626, "qteQMdiArea_tabPosition", "QMdiArea"));
    mixin(generateFunQt(7627, "qteQMdiArea_setActiveSubWindow", "QMdiArea"));
    mixin(generateFunQt(7628, "qteQMdiArea_tileSubWindows", "QMdiArea"));
    mixin(generateFunQt(7629, "qteQMdiArea_cascadeSubWindows", "QMdiArea"));
    mixin(generateFunQt(7630, "qteQMdiArea_closeActiveSubWindow", "QMdiArea"));
    mixin(generateFunQt(7631, "qteQMdiArea_closeAllSubWindows", "QMdiArea"));
    mixin(generateFunQt(7632, "qteQMdiArea_activateNextSubWindow", "QMdiArea"));
    mixin(generateFunQt(7633, "qteQMdiArea_activatePreviousSubWindow", "QMdiArea"));
    mixin(generateFunQt(7651, "qteQMdiArea_subWindowList",             "QMdiArea"));
    mixin(generateFunQt(7650, "qteQMdiArea_setEventHandler", "QMdiArea"));
}

static this() {
    registerModule("QMdiArea", "qte56_views.dll", &loadQMdiArea);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMdiArea.
@live class QMdiArea : QAbstractScrollArea {
public:
    /// Create QMdiArea. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[7600])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// currentSubWindow
    void* currentSubWindow() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7607])(_wh);
    }

    /// activeSubWindow
    void* activeSubWindow() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7608])(_wh);
    }

    /// addSubWindow
    void* addSubWindow(void* widget, int flags) {
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[7609])(_wh, widget, flags);
    }

    /// removeSubWindow
    QMdiArea removeSubWindow(void* widget) {
        (cast(t_v__qp_qp)pFunQt[7610])(_wh, widget);
        return this;
    }

    /// activationOrder
    int activationOrder() {
        return cast(int)(cast(t_i__qp)pFunQt[7611])(_wh);
    }

    /// setActivationOrder
    QMdiArea setActivationOrder(int order) {
        (cast(t_v__qp_i)pFunQt[7612])(_wh, order);
        return this;
    }

    /// setOption
    QMdiArea setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[7613])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int opton) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[7614])(_wh, opton);
    }

    /// setViewMode
    QMdiArea setViewMode(int mode) {
        (cast(t_v__qp_i)pFunQt[7615])(_wh, mode);
        return this;
    }

    /// viewMode
    int viewMode() {
        return cast(int)(cast(t_i__qp)pFunQt[7616])(_wh);
    }

    /// documentMode
    bool documentMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[7617])(_wh);
    }

    /// setDocumentMode
    QMdiArea setDocumentMode(bool enabled) {
        (cast(t_v__qp_i)pFunQt[7618])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// setTabsClosable
    QMdiArea setTabsClosable(bool closable) {
        (cast(t_v__qp_i)pFunQt[7619])(_wh, closable ? 1 : 0);
        return this;
    }

    /// tabsClosable
    bool tabsClosable() {
        return cast(bool)(cast(t_i__qp)pFunQt[7620])(_wh);
    }

    /// setTabsMovable
    QMdiArea setTabsMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[7621])(_wh, movable ? 1 : 0);
        return this;
    }

    /// tabsMovable
    bool tabsMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[7622])(_wh);
    }

    /// setTabShape
    QMdiArea setTabShape(int shape) {
        (cast(t_v__qp_i)pFunQt[7623])(_wh, shape);
        return this;
    }

    /// tabShape
    int tabShape() {
        return cast(int)(cast(t_i__qp)pFunQt[7624])(_wh);
    }

    /// setTabPosition
    QMdiArea setTabPosition(int position) {
        (cast(t_v__qp_i)pFunQt[7625])(_wh, position);
        return this;
    }

    /// tabPosition
    int tabPosition() {
        return cast(int)(cast(t_i__qp)pFunQt[7626])(_wh);
    }

    /// setActiveSubWindow
    QMdiArea setActiveSubWindow(void* window) {
        (cast(t_v__qp_qp)pFunQt[7627])(_wh, window);
        return this;
    }

    /// tileSubWindows
    QMdiArea tileSubWindows() {
        (cast(t_v__qp)pFunQt[7628])(_wh);
        return this;
    }

    /// cascadeSubWindows
    QMdiArea cascadeSubWindows() {
        (cast(t_v__qp)pFunQt[7629])(_wh);
        return this;
    }

    /// closeActiveSubWindow
    QMdiArea closeActiveSubWindow() {
        (cast(t_v__qp)pFunQt[7630])(_wh);
        return this;
    }

    /// closeAllSubWindows
    QMdiArea closeAllSubWindows() {
        (cast(t_v__qp)pFunQt[7631])(_wh);
        return this;
    }

    /// activateNextSubWindow
    QMdiArea activateNextSubWindow() {
        (cast(t_v__qp)pFunQt[7632])(_wh);
        return this;
    }

    /// activatePreviousSubWindow
    QMdiArea activatePreviousSubWindow() {
        (cast(t_v__qp)pFunQt[7633])(_wh);
        return this;
    }

    /// subWindowList — возвращает список указателей на все субокна
    void*[] subWindowList() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[7651])(_wh));
    }

    // Signal subWindowActivated — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QMdiArea setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[7650])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiArea onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiArea onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMdiArea onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMdiArea onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMdiArea onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMdiArea onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QMdiArea onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMdiArea onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QMdiArea onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiArea onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiArea onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiArea onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QMdiArea onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QMdiArea onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMdiArea onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMdiArea onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QMdiArea onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QMdiArea
