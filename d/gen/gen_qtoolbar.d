/**
 * gen_qtoolbar.d — GENERATED wrapper for QToolBar.
 * Module: QToolBar  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtoolbar;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, ptrListFromQStr, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp, toQString;
import gen_qwidget : QWidget;
import gen_qobject : QObject; // для типизированной перегрузки addWidget

// New aliases for this module:
mixin(generateAlias("i__qp_i"));          // t_i__qp_i : int function(void*, int)
mixin(generateAlias("qp__qp_i_i"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("qp__qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_i_qp_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("qp__qp_qp_qp_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQToolBar() {
    mixin(generateFunQt(6400, "qteQToolBar_create", "QToolBar"));
    mixin(generateFunQt(6401, "qteQToolBar_delete", "QToolBar"));
    mixin(generateFunQt(6402, "qteQToolBar_create_text", "QToolBar"));
    mixin(generateFunQt(6406, "qteQToolBar_setMovable", "QToolBar"));
    mixin(generateFunQt(6407, "qteQToolBar_isMovable", "QToolBar"));
    mixin(generateFunQt(6408, "qteQToolBar_setAllowedAreas", "QToolBar"));
    mixin(generateFunQt(6409, "qteQToolBar_allowedAreas", "QToolBar"));
    mixin(generateFunQt(6410, "qteQToolBar_setOrientation", "QToolBar"));
    mixin(generateFunQt(6411, "qteQToolBar_orientation", "QToolBar"));
    mixin(generateFunQt(6412, "qteQToolBar_clear", "QToolBar"));
    mixin(generateFunQt(6413, "qteQToolBar_addAction_s", "QToolBar"));
    mixin(generateFunQt(6414, "qteQToolBar_addAction_sp", "QToolBar"));
    mixin(generateFunQt(6415, "qteQToolBar_addAction_sop", "QToolBar"));
    mixin(generateFunQt(6416, "qteQToolBar_addSeparator", "QToolBar"));
    mixin(generateFunQt(6417, "qteQToolBar_insertSeparator", "QToolBar"));
    mixin(generateFunQt(6418, "qteQToolBar_addWidget", "QToolBar"));
    mixin(generateFunQt(6419, "qteQToolBar_insertWidget", "QToolBar"));
    mixin(generateFunQt(6420, "qteQToolBar_actionGeometry", "QToolBar"));
    mixin(generateFunQt(6421, "qteQToolBar_actionAt_p", "QToolBar"));
    mixin(generateFunQt(6422, "qteQToolBar_actionAt_ii", "QToolBar"));
    mixin(generateFunQt(6423, "qteQToolBar_toggleViewAction", "QToolBar"));
    mixin(generateFunQt(6424, "qteQToolBar_iconSize", "QToolBar"));
    mixin(generateFunQt(6425, "qteQToolBar_toolButtonStyle", "QToolBar"));
    mixin(generateFunQt(6426, "qteQToolBar_widgetForAction", "QToolBar"));
    mixin(generateFunQt(6427, "qteQToolBar_isFloatable", "QToolBar"));
    mixin(generateFunQt(6428, "qteQToolBar_setFloatable", "QToolBar"));
    mixin(generateFunQt(6429, "qteQToolBar_isFloating", "QToolBar"));
    mixin(generateFunQt(6430, "qteQToolBar_setIconSize", "QToolBar"));
    mixin(generateFunQt(6431, "qteQToolBar_setToolButtonStyle", "QToolBar"));
    mixin(generateFunQt(6432, "qteQToolBar_setEventHandler", "QToolBar"));
    // Icon
    mixin(generateFunQt(6433, "qteQToolBar_addAction_is", "QToolBar"));
    mixin(generateFunQt(6434, "qteQToolBar_addAction_p",              "QToolBar"));
    mixin(generateFunQt(6435, "qteQToolBar_iconSize_wh",              "QToolBar"));
    mixin(generateFunQt(6436, "qteQToolBar_isAreaAllowed",            "QToolBar"));
    mixin(generateFunQt(6437, "qteQToolBar_connect_actionTriggered",  "QToolBar"));
    mixin(generateFunQt(6438, "qteQToolBar_connect_iconSizeChanged",  "QToolBar"));
    mixin(generateFunQt(6439, "qteQToolBar_connect_orientationChanged","QToolBar"));
    mixin(generateFunQt(6440, "qteQToolBar_connect_visibilityChanged", "QToolBar"));
    mixin(generateFunQt(6441, "qteQToolBar_actions",                   "QToolBar"));
}

static this() {
    registerModule("QToolBar", "qte56_mainwin.dll", &loadQToolBar);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QToolBar.
@live class QToolBar : QWidget {
public:
    /// Create QToolBar. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[6400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap a Qt-owned QToolBar* (returned by QMainWindow::addToolBar(string) etc.)
    static QToolBar wrap(void* wh) {
        auto obj = new QToolBar(true);
        obj._wh = wh;
        obj._qt_owned = true;
        return obj;
    }

    /// Create QToolBar with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[6402])(
            _ws, parent);
    }

    /// setMovable
    QToolBar setMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[6406])(_wh, movable ? 1 : 0);
        return this;
    }

    /// isMovable
    bool isMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[6407])(_wh);
    }

    /// setAllowedAreas
    QToolBar setAllowedAreas(int areas) {
        (cast(t_v__qp_i)pFunQt[6408])(_wh, areas);
        return this;
    }

    /// allowedAreas
    int allowedAreas() {
        return cast(int)(cast(t_i__qp)pFunQt[6409])(_wh);
    }

    /// setOrientation
    QToolBar setOrientation(int orientation) {
        (cast(t_v__qp_i)pFunQt[6410])(_wh, orientation);
        return this;
    }

    /// orientation
    int orientation() {
        return cast(int)(cast(t_i__qp)pFunQt[6411])(_wh);
    }

    /// clear
    QToolBar clear() {
        (cast(t_v__qp)pFunQt[6412])(_wh);
        return this;
    }

    /// addAction
    void* addAction(string text) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6413])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction
    void* addAction(string text, int functor) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[6414])(_wh, _ws_text, functor);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction
    void* addAction(string text, void* context, int functor) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_qp_i)pFunQt[6415])(_wh, _ws_text, context, functor);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction with icon. icon is QIcon.getPtr(), returns QAction*.
    void* addActionWithIcon(void* icon, string text) {
        auto _ws = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[6433])(_wh, icon, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    /// Add existing QAction to toolbar. action is QAction*.
    override QToolBar addAction(void* action) {
        (cast(t_v__qp_qp)pFunQt[6434])(_wh, action);
        return this;
    }
    /// Check if toolbar area is allowed. area: Qt::ToolBarArea (1=Left,2=Right,4=Top,8=Bottom).
    bool isAreaAllowed(int area) {
        return (cast(t_i__qp_i)pFunQt[6436])(_wh, area) != 0;
    }
    /// Signal actionTriggered(QAction*). cb: extern(C) void function(void* ud, void* action)
    QToolBar connect_actionTriggered(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[6437])(_wh, cb, ud);
        return this;
    }
    /// Signal iconSizeChanged(QSize). cb: extern(C) void function(void* ud, int w, int h)
    QToolBar connect_iconSizeChanged(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[6438])(_wh, cb, ud);
        return this;
    }
    /// Signal orientationChanged(Qt::Orientation). cb: extern(C) void function(void* ud, int orientation)
    QToolBar connect_orientationChanged(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[6439])(_wh, cb, ud);
        return this;
    }
    /// Signal visibilityChanged(bool). cb: extern(C) void function(void* ud, int visible)
    QToolBar connect_visibilityChanged(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[6440])(_wh, cb, ud);
        return this;
    }
    /// actions — список QAction* в тулбаре
    void*[] actions() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[6441])(_wh));
    }

    /// addSeparator
    void* addSeparator() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6416])(_wh);
    }

    /// insertSeparator
    void* insertSeparator(void* before) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6417])(_wh, before);
    }

    /// addWidget
    void* addWidget(void* widget) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6418])(_wh, widget);
    }

    /// Типизированная версия addWidget: автоматически передаёт ownership Qt.
    /// Возвращает QAction* (handle), ассоциированный с виджетом.
    void* addWidget(QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6418])(_wh, wh);
    }

    /// insertWidget
    void* insertWidget(void* before, void* widget) {
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[6419])(_wh, before, widget);
    }

    /// actionGeometry
    DRect actionGeometry(void* action) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[6420])(_wh, action);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// actionAt
    void* actionAt(void* p) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6421])(_wh, p);
    }

    /// actionAt
    void* actionAt(int x, int y) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[6422])(_wh, x, y);
    }

    /// toggleViewAction
    void* toggleViewAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6423])(_wh);
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[6424])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// toolButtonStyle
    int toolButtonStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[6425])(_wh);
    }

    /// widgetForAction
    void* widgetForAction(void* action) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[6426])(_wh, action);
    }

    /// isFloatable
    bool isFloatable() {
        return cast(bool)(cast(t_i__qp)pFunQt[6427])(_wh);
    }

    /// setFloatable
    QToolBar setFloatable(bool floatable) {
        (cast(t_v__qp_i)pFunQt[6428])(_wh, floatable ? 1 : 0);
        return this;
    }

    /// isFloating
    bool isFloating() {
        return cast(bool)(cast(t_i__qp)pFunQt[6429])(_wh);
    }

    /// setIconSize
    QToolBar setIconSize(void* iconSize) {
        (cast(t_v__qp_qp)pFunQt[6430])(_wh, iconSize);
        return this;
    }

    /// setToolButtonStyle
    QToolBar setToolButtonStyle(int toolButtonStyle) {
        (cast(t_v__qp_i)pFunQt[6431])(_wh, toolButtonStyle);
        return this;
    }

    // Signal actionTriggered — unsupported parameter types
    /// Connect signal movableChanged → ESlot
    QToolBar connect_movableChanged(ESlot eslot) {
        connectQt(_wh, "movableChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // Signal allowedAreasChanged — unsupported parameter types
    // Signal orientationChanged — unsupported parameter types
    // Signal iconSizeChanged — unsupported parameter types
    // Signal toolButtonStyleChanged — unsupported parameter types
    /// Connect signal topLevelChanged → ESlot
    QToolBar connect_topLevelChanged(ESlot eslot) {
        connectQt(_wh, "topLevelChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal visibilityChanged → ESlot
    QToolBar connect_visibilityChanged(ESlot eslot) {
        connectQt(_wh, "visibilityChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QToolBar setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[6432])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBar onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBar onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBar onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolBar onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolBar onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolBar onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QToolBar onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolBar onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QToolBar onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBar onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBar onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBar onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBar onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QToolBar onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolBar onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolBar onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QToolBar onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QToolBar
