/**
 * gen_qtabbar.d — GENERATED wrapper for QTabBar.
 * Module: QTabBar  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtabbar;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_i_qp, t_i__qp_qp, t_i__qp_qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, toQString;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("i__qp_qp_qp_i"));
mixin(generateAlias("qp__qp_i_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_qp"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTabBar() {
    mixin(generateFunQt(16000, "qteQTabBar_create", "QTabBar"));
    mixin(generateFunQt(16001, "qteQTabBar_delete", "QTabBar"));
    mixin(generateFunQt(16002, "qteQTabBar_show", "QTabBar"));
    mixin(generateFunQt(16003, "qteQTabBar_hide", "QTabBar"));
    mixin(generateFunQt(16004, "qteQTabBar_update", "QTabBar"));
    mixin(generateFunQt(16005, "qteQTabBar_shape", "QTabBar"));
    mixin(generateFunQt(16006, "qteQTabBar_setShape", "QTabBar"));
    mixin(generateFunQt(16007, "qteQTabBar_addTab_s", "QTabBar"));
    mixin(generateFunQt(16008, "qteQTabBar_addTab_ps", "QTabBar"));
    mixin(generateFunQt(16009, "qteQTabBar_insertTab", "QTabBar"));
    mixin(generateFunQt(16010, "qteQTabBar_removeTab", "QTabBar"));
    mixin(generateFunQt(16011, "qteQTabBar_moveTab", "QTabBar"));
    mixin(generateFunQt(16012, "qteQTabBar_isTabEnabled", "QTabBar"));
    mixin(generateFunQt(16013, "qteQTabBar_setTabEnabled", "QTabBar"));
    mixin(generateFunQt(16014, "qteQTabBar_tabText", "QTabBar"));
    mixin(generateFunQt(16015, "qteQTabBar_setTabText", "QTabBar"));
    mixin(generateFunQt(16016, "qteQTabBar_tabTextColor", "QTabBar"));
    mixin(generateFunQt(16017, "qteQTabBar_setTabTextColor", "QTabBar"));
    mixin(generateFunQt(16018, "qteQTabBar_tabIcon", "QTabBar"));
    mixin(generateFunQt(16019, "qteQTabBar_setTabIcon", "QTabBar"));
    mixin(generateFunQt(16020, "qteQTabBar_elideMode", "QTabBar"));
    mixin(generateFunQt(16021, "qteQTabBar_setElideMode", "QTabBar"));
    mixin(generateFunQt(16022, "qteQTabBar_setTabToolTip", "QTabBar"));
    mixin(generateFunQt(16023, "qteQTabBar_tabToolTip", "QTabBar"));
    mixin(generateFunQt(16024, "qteQTabBar_setTabWhatsThis", "QTabBar"));
    mixin(generateFunQt(16025, "qteQTabBar_tabWhatsThis", "QTabBar"));
    mixin(generateFunQt(16026, "qteQTabBar_tabRect", "QTabBar"));
    mixin(generateFunQt(16027, "qteQTabBar_tabAt", "QTabBar"));
    mixin(generateFunQt(16028, "qteQTabBar_currentIndex", "QTabBar"));
    mixin(generateFunQt(16029, "qteQTabBar_count", "QTabBar"));
    mixin(generateFunQt(16030, "qteQTabBar_sizeHint", "QTabBar"));
    mixin(generateFunQt(16031, "qteQTabBar_minimumSizeHint", "QTabBar"));
    mixin(generateFunQt(16032, "qteQTabBar_setDrawBase", "QTabBar"));
    mixin(generateFunQt(16033, "qteQTabBar_drawBase", "QTabBar"));
    mixin(generateFunQt(16034, "qteQTabBar_iconSize", "QTabBar"));
    mixin(generateFunQt(16035, "qteQTabBar_setIconSize", "QTabBar"));
    mixin(generateFunQt(16036, "qteQTabBar_usesScrollButtons", "QTabBar"));
    mixin(generateFunQt(16037, "qteQTabBar_setUsesScrollButtons", "QTabBar"));
    mixin(generateFunQt(16038, "qteQTabBar_tabsClosable", "QTabBar"));
    mixin(generateFunQt(16039, "qteQTabBar_setTabsClosable", "QTabBar"));
    mixin(generateFunQt(16040, "qteQTabBar_setTabButton", "QTabBar"));
    mixin(generateFunQt(16041, "qteQTabBar_tabButton", "QTabBar"));
    mixin(generateFunQt(16042, "qteQTabBar_selectionBehaviorOnRemove", "QTabBar"));
    mixin(generateFunQt(16043, "qteQTabBar_setSelectionBehaviorOnRemove", "QTabBar"));
    mixin(generateFunQt(16044, "qteQTabBar_expanding", "QTabBar"));
    mixin(generateFunQt(16045, "qteQTabBar_setExpanding", "QTabBar"));
    mixin(generateFunQt(16046, "qteQTabBar_isMovable", "QTabBar"));
    mixin(generateFunQt(16047, "qteQTabBar_setMovable", "QTabBar"));
    mixin(generateFunQt(16048, "qteQTabBar_documentMode", "QTabBar"));
    mixin(generateFunQt(16049, "qteQTabBar_setDocumentMode", "QTabBar"));
    mixin(generateFunQt(16050, "qteQTabBar_autoHide", "QTabBar"));
    mixin(generateFunQt(16051, "qteQTabBar_setAutoHide", "QTabBar"));
    mixin(generateFunQt(16052, "qteQTabBar_changeCurrentOnDrag", "QTabBar"));
    mixin(generateFunQt(16053, "qteQTabBar_setChangeCurrentOnDrag", "QTabBar"));
    mixin(generateFunQt(16054, "qteQTabBar_accessibleTabName", "QTabBar"));
    mixin(generateFunQt(16055, "qteQTabBar_setAccessibleTabName", "QTabBar"));
    mixin(generateFunQt(16056, "qteQTabBar_setCurrentIndex", "QTabBar"));
    mixin(generateFunQt(16057, "qteQTabBar_setEventHandler", "QTabBar"));
}

static this() {
    registerModule("QTabBar", "qte56_widgets.dll", &loadQTabBar);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTabBar.
@live class QTabBar {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    /// No-op constructor for wrapOwned().
    this(bool _noOp) {}

public:
    /// Create QTabBar. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[16000])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[16001] !is null) {
            (cast(t_v__qp)pFunQt[16001])(_wh);
            _wh = null;
        }
    }

    /// show
    QTabBar show() {
        (cast(t_v__qp)pFunQt[16002])(_wh);
        return this;
    }

    /// hide
    QTabBar hide() {
        (cast(t_v__qp)pFunQt[16003])(_wh);
        return this;
    }

    /// update
    QTabBar update() {
        (cast(t_v__qp)pFunQt[16004])(_wh);
        return this;
    }

    /// shape
    int shape() {
        return cast(int)(cast(t_i__qp)pFunQt[16005])(_wh);
    }

    /// setShape
    QTabBar setShape(int shape) {
        (cast(t_v__qp_i)pFunQt[16006])(_wh, shape);
        return this;
    }

    /// addTab
    int addTab(string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_qp)pFunQt[16007])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addTab
    int addTab(void* icon, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_qp_qp)pFunQt[16008])(_wh, icon, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// insertTab
    int insertTab(int index, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_i_qp)pFunQt[16009])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// removeTab
    QTabBar removeTab(int index) {
        (cast(t_v__qp_i)pFunQt[16010])(_wh, index);
        return this;
    }

    /// moveTab
    QTabBar moveTab(int from, int to) {
        (cast(t_v__qp_i_i)pFunQt[16011])(_wh, from, to);
        return this;
    }

    /// isTabEnabled
    bool isTabEnabled(int index) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[16012])(_wh, index);
    }

    /// setTabEnabled
    QTabBar setTabEnabled(int index, bool p1) {
        (cast(t_v__qp_i_i)pFunQt[16013])(_wh, index, p1 ? 1 : 0);
        return this;
    }

    /// tabText
    string tabText(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[16014])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTabText
    QTabBar setTabText(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[16015])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// tabTextColor
    void* tabTextColor(int index) {
        return (cast(t_qp__qp_i)pFunQt[16016])(_wh, index);
    }

    /// setTabTextColor
    QTabBar setTabTextColor(int index, void* color) {
        (cast(t_v__qp_i_qp)pFunQt[16017])(_wh, index, color);
        return this;
    }

    /// tabIcon
    void* tabIcon(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[16018])(_wh, index);
    }

    /// setTabIcon
    QTabBar setTabIcon(int index, void* icon) {
        (cast(t_v__qp_i_qp)pFunQt[16019])(_wh, index, icon);
        return this;
    }

    /// elideMode
    int elideMode() {
        return cast(int)(cast(t_i__qp)pFunQt[16020])(_wh);
    }

    /// setElideMode
    QTabBar setElideMode(int p0) {
        (cast(t_v__qp_i)pFunQt[16021])(_wh, p0);
        return this;
    }

    /// setTabToolTip
    QTabBar setTabToolTip(int index, string tip) {
        auto _ws_tip = toQString(tip);
        (cast(t_v__qp_i_qp)pFunQt[16022])(_wh, index, _ws_tip);
        (cast(t_v__qp)pFunQt[22])(_ws_tip);
        return this;
    }

    /// tabToolTip
    string tabToolTip(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[16023])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTabWhatsThis
    QTabBar setTabWhatsThis(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[16024])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// tabWhatsThis
    string tabWhatsThis(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[16025])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// tabRect
    DRect tabRect(int index) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_i)pFunQt[16026])(_wh, index);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// tabAt
    int tabAt(void* pos) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[16027])(_wh, pos);
    }

    /// currentIndex
    int currentIndex() {
        return cast(int)(cast(t_i__qp)pFunQt[16028])(_wh);
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[16029])(_wh);
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[16030])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// minimumSizeHint
    DSize minimumSizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[16031])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setDrawBase
    QTabBar setDrawBase(bool drawTheBase) {
        (cast(t_v__qp_i)pFunQt[16032])(_wh, drawTheBase ? 1 : 0);
        return this;
    }

    /// drawBase
    bool drawBase() {
        return cast(bool)(cast(t_i__qp)pFunQt[16033])(_wh);
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[16034])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setIconSize
    QTabBar setIconSize(void* size) {
        (cast(t_v__qp_qp)pFunQt[16035])(_wh, size);
        return this;
    }

    /// usesScrollButtons
    bool usesScrollButtons() {
        return cast(bool)(cast(t_i__qp)pFunQt[16036])(_wh);
    }

    /// setUsesScrollButtons
    QTabBar setUsesScrollButtons(bool useButtons) {
        (cast(t_v__qp_i)pFunQt[16037])(_wh, useButtons ? 1 : 0);
        return this;
    }

    /// tabsClosable
    bool tabsClosable() {
        return cast(bool)(cast(t_i__qp)pFunQt[16038])(_wh);
    }

    /// setTabsClosable
    QTabBar setTabsClosable(bool closable) {
        (cast(t_v__qp_i)pFunQt[16039])(_wh, closable ? 1 : 0);
        return this;
    }

    /// setTabButton
    QTabBar setTabButton(int index, int position, void* widget) {
        (cast(t_v__qp_i_i_qp)pFunQt[16040])(_wh, index, position, widget);
        return this;
    }

    /// tabButton
    void* tabButton(int index, int position) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[16041])(_wh, index, position);
    }

    /// selectionBehaviorOnRemove
    int selectionBehaviorOnRemove() {
        return cast(int)(cast(t_i__qp)pFunQt[16042])(_wh);
    }

    /// setSelectionBehaviorOnRemove
    QTabBar setSelectionBehaviorOnRemove(int behavior) {
        (cast(t_v__qp_i)pFunQt[16043])(_wh, behavior);
        return this;
    }

    /// expanding
    bool expanding() {
        return cast(bool)(cast(t_i__qp)pFunQt[16044])(_wh);
    }

    /// setExpanding
    QTabBar setExpanding(bool enabled) {
        (cast(t_v__qp_i)pFunQt[16045])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// isMovable
    bool isMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[16046])(_wh);
    }

    /// setMovable
    QTabBar setMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[16047])(_wh, movable ? 1 : 0);
        return this;
    }

    /// documentMode
    bool documentMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[16048])(_wh);
    }

    /// setDocumentMode
    QTabBar setDocumentMode(bool set) {
        (cast(t_v__qp_i)pFunQt[16049])(_wh, set ? 1 : 0);
        return this;
    }

    /// autoHide
    bool autoHide() {
        return cast(bool)(cast(t_i__qp)pFunQt[16050])(_wh);
    }

    /// setAutoHide
    QTabBar setAutoHide(bool hide) {
        (cast(t_v__qp_i)pFunQt[16051])(_wh, hide ? 1 : 0);
        return this;
    }

    /// changeCurrentOnDrag
    bool changeCurrentOnDrag() {
        return cast(bool)(cast(t_i__qp)pFunQt[16052])(_wh);
    }

    /// setChangeCurrentOnDrag
    QTabBar setChangeCurrentOnDrag(bool change) {
        (cast(t_v__qp_i)pFunQt[16053])(_wh, change ? 1 : 0);
        return this;
    }

    /// accessibleTabName
    string accessibleTabName(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[16054])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setAccessibleTabName
    QTabBar setAccessibleTabName(int index, string name) {
        auto _ws_name = toQString(name);
        (cast(t_v__qp_i_qp)pFunQt[16055])(_wh, index, _ws_name);
        (cast(t_v__qp)pFunQt[22])(_ws_name);
        return this;
    }

    /// setCurrentIndex
    QTabBar setCurrentIndex(int index) {
        (cast(t_v__qp_i)pFunQt[16056])(_wh, index);
        return this;
    }

    /// Connect signal currentChanged → ESlot
    QTabBar connect_currentChanged(ESlot eslot) {
        connectQt(_wh, "currentChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabCloseRequested → ESlot
    QTabBar connect_tabCloseRequested(ESlot eslot) {
        connectQt(_wh, "tabCloseRequested(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabMoved → ESlot
    QTabBar connect_tabMoved(ESlot eslot) {
        connectQt(_wh, "tabMoved(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal tabBarClicked → ESlot
    QTabBar connect_tabBarClicked(ESlot eslot) {
        connectQt(_wh, "tabBarClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabBarDoubleClicked → ESlot
    QTabBar connect_tabBarDoubleClicked(ESlot eslot) {
        connectQt(_wh, "tabBarDoubleClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    QTabBar setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[16057])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QTabBar onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QTabBar onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QTabBar onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QTabBar onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QTabBar onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QTabBar onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    QTabBar onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QTabBar onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    QTabBar onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    QTabBar onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    QTabBar onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    QTabBar onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    QTabBar onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    QTabBar onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QTabBar onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QTabBar onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    QTabBar onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    /// Mark as Qt-owned (call after setLayout / reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

    /// Wrap a Qt-owned QTabBar pointer (does NOT delete on dtor).
    static QTabBar wrapOwned(void* ptr) {
        auto w = new QTabBar(true);
        w._wh = ptr;
        w._qt_owned = true;
        return w;
    }

} // class QTabBar
