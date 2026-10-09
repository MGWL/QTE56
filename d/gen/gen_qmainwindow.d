/**
 * gen_qmainwindow.d — GENERATED wrapper for QMainWindow.
 * Module: QMainWindow  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmainwindow;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_i, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp, t_v__qp_qp_qp_i, toQString;
import gen_qwidget : QWidget;
import gen_qbytearray : QByteArray;
import gen_qobject : QObject; // для типизированных перегрузок setCentralWidget

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp"));
mixin(generateAlias("i__qp_qp_i"));       // int(void*, void*, int) — restoreState

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMainWindow() {
    mixin(generateFunQt(6200, "qteQMainWindow_create", "QMainWindow"));
    mixin(generateFunQt(6201, "qteQMainWindow_delete", "QMainWindow"));
    mixin(generateFunQt(6205, "qteQMainWindow_iconSize", "QMainWindow"));
    mixin(generateFunQt(6206, "qteQMainWindow_setIconSize", "QMainWindow"));
    mixin(generateFunQt(6207, "qteQMainWindow_toolButtonStyle", "QMainWindow"));
    mixin(generateFunQt(6208, "qteQMainWindow_setToolButtonStyle", "QMainWindow"));
    mixin(generateFunQt(6209, "qteQMainWindow_isAnimated", "QMainWindow"));
    mixin(generateFunQt(6210, "qteQMainWindow_isDockNestingEnabled", "QMainWindow"));
    mixin(generateFunQt(6211, "qteQMainWindow_documentMode", "QMainWindow"));
    mixin(generateFunQt(6212, "qteQMainWindow_setDocumentMode", "QMainWindow"));
    mixin(generateFunQt(6213, "qteQMainWindow_tabShape", "QMainWindow"));
    mixin(generateFunQt(6214, "qteQMainWindow_setTabShape", "QMainWindow"));
    mixin(generateFunQt(6215, "qteQMainWindow_tabPosition", "QMainWindow"));
    mixin(generateFunQt(6216, "qteQMainWindow_setTabPosition", "QMainWindow"));
    mixin(generateFunQt(6217, "qteQMainWindow_setDockOptions", "QMainWindow"));
    mixin(generateFunQt(6218, "qteQMainWindow_dockOptions", "QMainWindow"));
    mixin(generateFunQt(6219, "qteQMainWindow_isSeparator", "QMainWindow"));
    mixin(generateFunQt(6220, "qteQMainWindow_menuBar", "QMainWindow"));
    mixin(generateFunQt(6221, "qteQMainWindow_setMenuBar", "QMainWindow"));
    mixin(generateFunQt(6222, "qteQMainWindow_menuWidget", "QMainWindow"));
    mixin(generateFunQt(6223, "qteQMainWindow_setMenuWidget", "QMainWindow"));
    mixin(generateFunQt(6224, "qteQMainWindow_statusBar", "QMainWindow"));
    mixin(generateFunQt(6225, "qteQMainWindow_setStatusBar", "QMainWindow"));
    mixin(generateFunQt(6226, "qteQMainWindow_centralWidget", "QMainWindow"));
    mixin(generateFunQt(6227, "qteQMainWindow_setCentralWidget", "QMainWindow"));
    mixin(generateFunQt(6228, "qteQMainWindow_takeCentralWidget", "QMainWindow"));
    mixin(generateFunQt(6229, "qteQMainWindow_setCorner", "QMainWindow"));
    mixin(generateFunQt(6230, "qteQMainWindow_corner", "QMainWindow"));
    mixin(generateFunQt(6231, "qteQMainWindow_addToolBarBreak", "QMainWindow"));
    mixin(generateFunQt(6232, "qteQMainWindow_insertToolBarBreak", "QMainWindow"));
    mixin(generateFunQt(6233, "qteQMainWindow_addToolBar_pp", "QMainWindow"));
    mixin(generateFunQt(6234, "qteQMainWindow_addToolBar_p", "QMainWindow"));
    mixin(generateFunQt(6235, "qteQMainWindow_addToolBar_s", "QMainWindow"));
    mixin(generateFunQt(6236, "qteQMainWindow_insertToolBar", "QMainWindow"));
    mixin(generateFunQt(6237, "qteQMainWindow_removeToolBar", "QMainWindow"));
    mixin(generateFunQt(6238, "qteQMainWindow_removeToolBarBreak", "QMainWindow"));
    mixin(generateFunQt(6239, "qteQMainWindow_unifiedTitleAndToolBarOnMac", "QMainWindow"));
    mixin(generateFunQt(6240, "qteQMainWindow_toolBarBreak", "QMainWindow"));
    mixin(generateFunQt(6241, "qteQMainWindow_addDockWidget_pp", "QMainWindow"));
    mixin(generateFunQt(6242, "qteQMainWindow_addDockWidget_ppp", "QMainWindow"));
    mixin(generateFunQt(6243, "qteQMainWindow_splitDockWidget", "QMainWindow"));
    mixin(generateFunQt(6244, "qteQMainWindow_tabifyDockWidget", "QMainWindow"));
    mixin(generateFunQt(6245, "qteQMainWindow_removeDockWidget", "QMainWindow"));
    mixin(generateFunQt(6246, "qteQMainWindow_restoreDockWidget", "QMainWindow"));
    mixin(generateFunQt(6247, "qteQMainWindow_dockWidgetArea", "QMainWindow"));
    mixin(generateFunQt(6248, "qteQMainWindow_createPopupMenu", "QMainWindow"));
    mixin(generateFunQt(6249, "qteQMainWindow_setAnimated", "QMainWindow"));
    mixin(generateFunQt(6250, "qteQMainWindow_setDockNestingEnabled", "QMainWindow"));
    mixin(generateFunQt(6251, "qteQMainWindow_setUnifiedTitleAndToolBarOnMac", "QMainWindow"));
    mixin(generateFunQt(6252, "qteQMainWindow_setEventHandler", "QMainWindow"));
    // State persistence
    mixin(generateFunQt(6253, "qteQMainWindow_saveState",    "QMainWindow"));
    mixin(generateFunQt(6254, "qteQMainWindow_restoreState", "QMainWindow"));
}

static this() {
    registerModule("QMainWindow", "qte56_mainwin.dll", &loadQMainWindow);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMainWindow.
@live class QMainWindow : QWidget {
public:
    /// Create QMainWindow. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[6200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[6205])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setIconSize
    QMainWindow setIconSize(void* iconSize) {
        (cast(t_v__qp_qp)pFunQt[6206])(_wh, iconSize);
        return this;
    }

    /// toolButtonStyle
    int toolButtonStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[6207])(_wh);
    }

    /// setToolButtonStyle
    QMainWindow setToolButtonStyle(int toolButtonStyle) {
        (cast(t_v__qp_i)pFunQt[6208])(_wh, toolButtonStyle);
        return this;
    }

    /// isAnimated
    bool isAnimated() {
        return cast(bool)(cast(t_i__qp)pFunQt[6209])(_wh);
    }

    /// isDockNestingEnabled
    bool isDockNestingEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[6210])(_wh);
    }

    /// documentMode
    bool documentMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[6211])(_wh);
    }

    /// setDocumentMode
    QMainWindow setDocumentMode(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6212])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// tabShape
    int tabShape() {
        return cast(int)(cast(t_i__qp)pFunQt[6213])(_wh);
    }

    /// setTabShape
    QMainWindow setTabShape(int tabShape) {
        (cast(t_v__qp_i)pFunQt[6214])(_wh, tabShape);
        return this;
    }

    /// tabPosition
    int tabPosition(int area) {
        return cast(int)(cast(t_i__qp_i)pFunQt[6215])(_wh, area);
    }

    /// setTabPosition
    QMainWindow setTabPosition(int areas, int tabPosition) {
        (cast(t_v__qp_i_i)pFunQt[6216])(_wh, areas, tabPosition);
        return this;
    }

    /// setDockOptions
    QMainWindow setDockOptions(int options) {
        (cast(t_v__qp_i)pFunQt[6217])(_wh, options);
        return this;
    }

    /// dockOptions
    int dockOptions() {
        return cast(int)(cast(t_i__qp)pFunQt[6218])(_wh);
    }

    /// isSeparator
    bool isSeparator(void* pos) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[6219])(_wh, pos);
    }

    /// menuBar
    void* menuBar() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6220])(_wh);
    }

    /// setMenuBar
    QMainWindow setMenuBar(void* menubar) {
        (cast(t_v__qp_qp)pFunQt[6221])(_wh, menubar);
        return this;
    }

    /// menuWidget
    void* menuWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6222])(_wh);
    }

    /// setMenuWidget
    QMainWindow setMenuWidget(void* menubar) {
        (cast(t_v__qp_qp)pFunQt[6223])(_wh, menubar);
        return this;
    }

    /// statusBar
    void* statusBar() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6224])(_wh);
    }

    /// setStatusBar
    QMainWindow setStatusBar(void* statusbar) {
        (cast(t_v__qp_qp)pFunQt[6225])(_wh, statusbar);
        return this;
    }

    /// centralWidget
    void* centralWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6226])(_wh);
    }

    /// setCentralWidget
    QMainWindow setCentralWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[6227])(_wh, widget);
        return this;
    }

    /// Типизированная версия setCentralWidget: автоматически передаёт ownership Qt.
    QMainWindow setCentralWidget(QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        (cast(t_v__qp_qp)pFunQt[6227])(_wh, wh);
        return this;
    }

    /// takeCentralWidget
    void* takeCentralWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6228])(_wh);
    }

    /// setCorner
    QMainWindow setCorner(int corner, int area) {
        (cast(t_v__qp_i_i)pFunQt[6229])(_wh, corner, area);
        return this;
    }

    /// corner
    int corner(int corner) {
        return cast(int)(cast(t_i__qp_i)pFunQt[6230])(_wh, corner);
    }

    /// addToolBarBreak
    QMainWindow addToolBarBreak(int area) {
        (cast(t_v__qp_i)pFunQt[6231])(_wh, area);
        return this;
    }

    /// insertToolBarBreak
    QMainWindow insertToolBarBreak(void* before) {
        (cast(t_v__qp_qp)pFunQt[6232])(_wh, before);
        return this;
    }

    /// addToolBar
    QMainWindow addToolBar(int area, void* toolbar) {
        (cast(t_v__qp_i_qp)pFunQt[6233])(_wh, area, toolbar);
        return this;
    }

    /// addToolBar
    QMainWindow addToolBar(void* toolbar) {
        (cast(t_v__qp_qp)pFunQt[6234])(_wh, toolbar);
        return this;
    }

    /// addToolBar
    void* addToolBar(string title) {
        auto _ws_title = toQString(title);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6235])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
    }

    /// insertToolBar
    QMainWindow insertToolBar(void* before, void* toolbar) {
        (cast(t_v__qp_qp_qp)pFunQt[6236])(_wh, before, toolbar);
        return this;
    }

    /// removeToolBar
    QMainWindow removeToolBar(void* toolbar) {
        (cast(t_v__qp_qp)pFunQt[6237])(_wh, toolbar);
        return this;
    }

    /// removeToolBarBreak
    QMainWindow removeToolBarBreak(void* before) {
        (cast(t_v__qp_qp)pFunQt[6238])(_wh, before);
        return this;
    }

    /// unifiedTitleAndToolBarOnMac
    bool unifiedTitleAndToolBarOnMac() {
        return cast(bool)(cast(t_i__qp)pFunQt[6239])(_wh);
    }

    /// toolBarBreak
    bool toolBarBreak(void* toolbar) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[6240])(_wh, toolbar);
    }

    /// addDockWidget
    QMainWindow addDockWidget(int area, void* dockwidget) {
        (cast(t_v__qp_i_qp)pFunQt[6241])(_wh, area, dockwidget);
        return this;
    }

    /// addDockWidget
    QMainWindow addDockWidget(int area, void* dockwidget, int orientation) {
        (cast(t_v__qp_i_qp_i)pFunQt[6242])(_wh, area, dockwidget, orientation);
        return this;
    }

    /// splitDockWidget
    QMainWindow splitDockWidget(void* after, void* dockwidget, int orientation) {
        (cast(t_v__qp_qp_qp_i)pFunQt[6243])(_wh, after, dockwidget, orientation);
        return this;
    }

    /// tabifyDockWidget
    QMainWindow tabifyDockWidget(void* first, void* second) {
        (cast(t_v__qp_qp_qp)pFunQt[6244])(_wh, first, second);
        return this;
    }

    /// removeDockWidget
    QMainWindow removeDockWidget(void* dockwidget) {
        (cast(t_v__qp_qp)pFunQt[6245])(_wh, dockwidget);
        return this;
    }

    /// restoreDockWidget
    bool restoreDockWidget(void* dockwidget) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[6246])(_wh, dockwidget);
    }

    /// dockWidgetArea
    int dockWidgetArea(void* dockwidget) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[6247])(_wh, dockwidget);
    }

    /// createPopupMenu
    void* createPopupMenu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6248])(_wh);
    }

    /// setAnimated
    QMainWindow setAnimated(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6249])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// setDockNestingEnabled
    QMainWindow setDockNestingEnabled(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6250])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// setUnifiedTitleAndToolBarOnMac
    QMainWindow setUnifiedTitleAndToolBarOnMac(bool set) {
        (cast(t_v__qp_i)pFunQt[6251])(_wh, set ? 1 : 0);
        return this;
    }

    // Signal iconSizeChanged — unsupported parameter types
    // Signal toolButtonStyleChanged — unsupported parameter types
    // Signal tabifiedDockWidgetActivated — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QMainWindow setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[6252])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMainWindow onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMainWindow onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMainWindow onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMainWindow onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMainWindow onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMainWindow onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QMainWindow onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMainWindow onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QMainWindow onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QMainWindow onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QMainWindow onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QMainWindow onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QMainWindow onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QMainWindow onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMainWindow onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMainWindow onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QMainWindow onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }


    // ── State persistence ────────────────────────────────────────────────────

    /// Save toolbar/dock layout to QByteArray. Combine with saveGeometry().
    QByteArray saveState() {
        void* ba = (cast(t_qp__qp)pFunQt[6253])(_wh);
        return QByteArray.wrap(ba);
    }

    /// Restore toolbar/dock layout from previously saved QByteArray.
    bool restoreState(QByteArray state) {
        auto sl = state.toSlice();
        return (cast(t_i__qp_qp_i)pFunQt[6254])(
            _wh, cast(void*)sl.ptr, cast(int)sl.length) != 0;
    }

    /// Convenience: restore from raw bytes.
    bool restoreState(const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[6254])(
            _wh, cast(void*)data.ptr, cast(int)data.length) != 0;
    }

} // class QMainWindow
