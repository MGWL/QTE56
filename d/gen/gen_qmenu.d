/**
 * gen_qmenu.d — GENERATED wrapper for QMenu.
 * Module: QMenu  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmenu;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, ptrListFromQStr, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("qp__qp_qp_i_qp_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("qp__qp_qp_qp_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMenu() {
    mixin(generateFunQt(4000, "qteQMenu_create", "QMenu"));
    mixin(generateFunQt(4001, "qteQMenu_delete", "QMenu"));
    mixin(generateFunQt(4002, "qteQMenu_create_text", "QMenu"));
    mixin(generateFunQt(4006, "qteQMenu_addAction_s", "QMenu"));
    mixin(generateFunQt(4007, "qteQMenu_addAction_sp", "QMenu"));
    mixin(generateFunQt(4008, "qteQMenu_addAction_sop", "QMenu"));
    mixin(generateFunQt(4009, "qteQMenu_addMenu_p", "QMenu"));
    mixin(generateFunQt(4010, "qteQMenu_addMenu_s", "QMenu"));
    mixin(generateFunQt(4011, "qteQMenu_addSeparator", "QMenu"));
    mixin(generateFunQt(4012, "qteQMenu_addSection", "QMenu"));
    mixin(generateFunQt(4013, "qteQMenu_insertMenu", "QMenu"));
    mixin(generateFunQt(4014, "qteQMenu_insertSeparator", "QMenu"));
    mixin(generateFunQt(4015, "qteQMenu_insertSection", "QMenu"));
    mixin(generateFunQt(4016, "qteQMenu_isEmpty", "QMenu"));
    mixin(generateFunQt(4017, "qteQMenu_clear", "QMenu"));
    mixin(generateFunQt(4018, "qteQMenu_setTearOffEnabled", "QMenu"));
    mixin(generateFunQt(4019, "qteQMenu_isTearOffEnabled", "QMenu"));
    mixin(generateFunQt(4020, "qteQMenu_isTearOffMenuVisible", "QMenu"));
    mixin(generateFunQt(4021, "qteQMenu_showTearOffMenu_v", "QMenu"));
    mixin(generateFunQt(4022, "qteQMenu_showTearOffMenu_p", "QMenu"));
    mixin(generateFunQt(4023, "qteQMenu_hideTearOffMenu", "QMenu"));
    mixin(generateFunQt(4024, "qteQMenu_setDefaultAction", "QMenu"));
    mixin(generateFunQt(4025, "qteQMenu_defaultAction", "QMenu"));
    mixin(generateFunQt(4026, "qteQMenu_setActiveAction", "QMenu"));
    mixin(generateFunQt(4027, "qteQMenu_activeAction", "QMenu"));
    mixin(generateFunQt(4028, "qteQMenu_popup", "QMenu"));
    mixin(generateFunQt(4029, "qteQMenu_exec_v", "QMenu"));
    mixin(generateFunQt(4030, "qteQMenu_exec_pp", "QMenu"));
    mixin(generateFunQt(4032, "qteQMenu_actionGeometry", "QMenu"));
    mixin(generateFunQt(4033, "qteQMenu_actionAt", "QMenu"));
    mixin(generateFunQt(4034, "qteQMenu_menuAction", "QMenu"));
    mixin(generateFunQt(4035, "qteQMenu_title", "QMenu"));
    mixin(generateFunQt(4036, "qteQMenu_setTitle", "QMenu"));
    mixin(generateFunQt(4037, "qteQMenu_setNoReplayFor", "QMenu"));
    mixin(generateFunQt(4038, "qteQMenu_platformMenu", "QMenu"));
    mixin(generateFunQt(4039, "qteQMenu_setPlatformMenu", "QMenu"));
    mixin(generateFunQt(4040, "qteQMenu_setAsDockMenu", "QMenu"));
    mixin(generateFunQt(4041, "qteQMenu_separatorsCollapsible", "QMenu"));
    mixin(generateFunQt(4042, "qteQMenu_setSeparatorsCollapsible", "QMenu"));
    mixin(generateFunQt(4043, "qteQMenu_toolTipsVisible", "QMenu"));
    mixin(generateFunQt(4044, "qteQMenu_setToolTipsVisible", "QMenu"));
    mixin(generateFunQt(4045, "qteQMenu_setEventHandler", "QMenu"));
    // Icon
    mixin(generateFunQt(4046, "qteQMenu_addAction_is",  "QMenu"));
    mixin(generateFunQt(4047, "qteQMenu_setIcon",       "QMenu"));
    mixin(generateFunQt(4048, "qteQMenu_icon",          "QMenu"));
    mixin(generateFunQt(4049, "qteQMenu_addMenu_is",    "QMenu"));
    mixin(generateFunQt(4050, "qteQMenu_addAction_p",        "QMenu"));
    mixin(generateFunQt(4051, "qteQMenu_connect_triggered",  "QMenu"));
    mixin(generateFunQt(4052, "qteQMenu_connect_hovered",    "QMenu"));
    mixin(generateFunQt(4053, "qteQMenu_actionGeometry_xywh","QMenu"));
    mixin(generateFunQt(4054, "qteQMenu_actions",            "QMenu"));
}

static this() {
    registerModule("QMenu", "qte56_mainwin.dll", &loadQMenu);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMenu.
@live class QMenu : QWidget {
public:
    /// Create QMenu. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[4000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QMenu* (e.g. returned by addMenu / addMenu_text).
    /// The returned D object does NOT own the Qt object — Qt will delete it.
    static QMenu wrap(void* wh) {
        auto m = new QMenu(true);
        m._wh = wh;
        m._qt_owned = true;
        return m;
    }

    /// Create QMenu with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[4002])(
            _ws, parent);
    }

    /// addAction
    void* addAction(string text) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4006])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction
    void* addAction(string text, int functor) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[4007])(_wh, _ws_text, functor);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction
    void* addAction(string text, void* context, int functor) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_qp_i)pFunQt[4008])(_wh, _ws_text, context, functor);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addMenu
    void* addMenu(void* menu) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4009])(_wh, menu);
    }

    /// addMenu
    void* addMenu(string title) {
        auto _ws_title = toQString(title);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4010])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
    }

    /// addSeparator
    void* addSeparator() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4011])(_wh);
    }

    /// addSection
    void* addSection(string text) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4012])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// insertMenu
    void* insertMenu(void* before, void* menu) {
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4013])(_wh, before, menu);
    }

    /// insertSeparator
    void* insertSeparator(void* before) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4014])(_wh, before);
    }

    /// insertSection
    void* insertSection(void* before, string text) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4015])(_wh, before, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// isEmpty
    bool isEmpty() {
        return cast(bool)(cast(t_i__qp)pFunQt[4016])(_wh);
    }

    /// clear
    QMenu clear() {
        (cast(t_v__qp)pFunQt[4017])(_wh);
        return this;
    }

    /// setTearOffEnabled
    QMenu setTearOffEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[4018])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isTearOffEnabled
    bool isTearOffEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[4019])(_wh);
    }

    /// isTearOffMenuVisible
    bool isTearOffMenuVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[4020])(_wh);
    }

    /// showTearOffMenu
    QMenu showTearOffMenu() {
        (cast(t_v__qp)pFunQt[4021])(_wh);
        return this;
    }

    /// showTearOffMenu
    QMenu showTearOffMenu(void* pos) {
        (cast(t_v__qp_qp)pFunQt[4022])(_wh, pos);
        return this;
    }

    /// hideTearOffMenu
    QMenu hideTearOffMenu() {
        (cast(t_v__qp)pFunQt[4023])(_wh);
        return this;
    }

    /// setDefaultAction
    QMenu setDefaultAction(void* p0) {
        (cast(t_v__qp_qp)pFunQt[4024])(_wh, p0);
        return this;
    }

    /// defaultAction
    void* defaultAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4025])(_wh);
    }

    /// setActiveAction
    QMenu setActiveAction(void* act) {
        (cast(t_v__qp_qp)pFunQt[4026])(_wh, act);
        return this;
    }

    /// activeAction
    void* activeAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4027])(_wh);
    }

    /// popup
    QMenu popup(void* pos, void* at) {
        (cast(t_v__qp_qp_qp)pFunQt[4028])(_wh, pos, at);
        return this;
    }

    /// exec
    void* exec() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4029])(_wh);
    }

    /// exec
    void* exec(void* pos, void* at) {
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4030])(_wh, pos, at);
    }

    /// actionGeometry
    DRect actionGeometry(void* p0) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[4032])(_wh, p0);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// actionAt
    void* actionAt(void* p0) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4033])(_wh, p0);
    }

    /// menuAction
    void* menuAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4034])(_wh);
    }

    /// title
    string title() {
        void* _qs = (cast(t_qp__qp)pFunQt[4035])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTitle
    QMenu setTitle(string title) {
        auto _ws_title = toQString(title);
        (cast(t_v__qp_qp)pFunQt[4036])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        return this;
    }

    /// setNoReplayFor
    QMenu setNoReplayFor(void* widget) {
        (cast(t_v__qp_qp)pFunQt[4037])(_wh, widget);
        return this;
    }

    /// platformMenu
    void* platformMenu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4038])(_wh);
    }

    /// setPlatformMenu
    QMenu setPlatformMenu(void* platformMenu) {
        (cast(t_v__qp_qp)pFunQt[4039])(_wh, platformMenu);
        return this;
    }

    /// setAsDockMenu
    QMenu setAsDockMenu() {
        (cast(t_v__qp)pFunQt[4040])(_wh);
        return this;
    }

    /// separatorsCollapsible
    bool separatorsCollapsible() {
        return cast(bool)(cast(t_i__qp)pFunQt[4041])(_wh);
    }

    /// setSeparatorsCollapsible
    QMenu setSeparatorsCollapsible(bool collapse) {
        (cast(t_v__qp_i)pFunQt[4042])(_wh, collapse ? 1 : 0);
        return this;
    }

    /// toolTipsVisible
    bool toolTipsVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[4043])(_wh);
    }

    /// setToolTipsVisible
    QMenu setToolTipsVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[4044])(_wh, visible ? 1 : 0);
        return this;
    }

    // ── Icon methods ──────────────────────────────────────────────────

    /// addAction with icon. icon is QIcon.getPtr(), returns QAction*.
    void* addActionWithIcon(void* icon, string text) {
        auto _ws = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4046])(_wh, icon, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    /// Add existing QAction to menu. action is QAction* (e.g. from QAction.wrap().getWH()).
    override QMenu addAction(void* action) {
        (cast(t_v__qp_qp)pFunQt[4050])(_wh, action);
        return this;
    }

    /// Set menu icon. icon is QIcon.getPtr().
    QMenu setIcon(void* icon) {
        (cast(t_v__qp_qp)pFunQt[4047])(_wh, icon);
        return this;
    }

    /// Get menu icon. Returns new heap-allocated QIcon* (caller takes ownership).
    void* icon() {
        return (cast(t_qp__qp)pFunQt[4048])(_wh);
    }

    /// addMenu with icon. icon is QIcon.getPtr(), returns QMenu*.
    void* addMenuWithIcon(void* icon, string title) {
        auto _ws = toQString(title);
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4049])(_wh, icon, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    /// Connect signal aboutToShow → ESlot
    QMenu connect_aboutToShow(ESlot eslot) {
        connectQt(_wh, "aboutToShow()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal aboutToHide → ESlot
    QMenu connect_aboutToHide(ESlot eslot) {
        connectQt(_wh, "aboutToHide()", eslot, "invoke_v()");
        return this;
    }

    /// Signal triggered(QAction*). cb: extern(C) void function(void* ud, void* action)
    QMenu connect_triggered(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[4051])(_wh, cb, ud);
        return this;
    }
    /// Signal hovered(QAction*). cb: extern(C) void function(void* ud, void* action)
    QMenu connect_hovered(void* cb, void* ud = null) {
        (cast(t_v__qp_qp_qp)pFunQt[4052])(_wh, cb, ud);
        return this;
    }
    /// actions — список QAction* в меню
    void*[] actions() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[4054])(_wh));
    }
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QMenu setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[4045])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenu onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenu onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenu onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMenu onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMenu onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMenu onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QMenu onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMenu onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QMenu onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenu onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenu onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenu onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenu onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QMenu onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMenu onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMenu onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QMenu onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QMenu
