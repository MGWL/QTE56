/**
 * gen_qtabwidget.d — GENERATED wrapper for QTabWidget.
 * Module: QTabWidget  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtabwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_i_qp, t_i__qp_i_qp_qp, t_i__qp_qp, t_i__qp_qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;
import gen_qtabbar : QTabBar;
import gen_qobject : QObject; // для типизированных перегрузок addTab/insertTab

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_qp_qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("i__qp_qp_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTabWidget() {
    mixin(generateFunQt(2600, "qteQTabWidget_create", "QTabWidget"));
    mixin(generateFunQt(2601, "qteQTabWidget_delete", "QTabWidget"));
    mixin(generateFunQt(2605, "qteQTabWidget_addTab", "QTabWidget"));
    mixin(generateFunQt(2606, "qteQTabWidget_insertTab", "QTabWidget"));
    mixin(generateFunQt(2607, "qteQTabWidget_removeTab", "QTabWidget"));
    mixin(generateFunQt(2608, "qteQTabWidget_isTabEnabled", "QTabWidget"));
    mixin(generateFunQt(2609, "qteQTabWidget_setTabEnabled", "QTabWidget"));
    mixin(generateFunQt(2610, "qteQTabWidget_tabText", "QTabWidget"));
    mixin(generateFunQt(2611, "qteQTabWidget_setTabText", "QTabWidget"));
    mixin(generateFunQt(2612, "qteQTabWidget_tabToolTip", "QTabWidget"));
    mixin(generateFunQt(2613, "qteQTabWidget_setTabWhatsThis", "QTabWidget"));
    mixin(generateFunQt(2614, "qteQTabWidget_tabWhatsThis", "QTabWidget"));
    mixin(generateFunQt(2615, "qteQTabWidget_currentIndex", "QTabWidget"));
    mixin(generateFunQt(2647, "qteQTabWidget_currentWidget", "QTabWidget"));
    mixin(generateFunQt(2648, "qteQTabWidget_widget", "QTabWidget"));
    mixin(generateFunQt(2616, "qteQTabWidget_indexOf", "QTabWidget"));
    mixin(generateFunQt(2617, "qteQTabWidget_count", "QTabWidget"));
    mixin(generateFunQt(2618, "qteQTabWidget_tabPosition", "QTabWidget"));
    mixin(generateFunQt(2619, "qteQTabWidget_setTabPosition", "QTabWidget"));
    mixin(generateFunQt(2620, "qteQTabWidget_tabsClosable", "QTabWidget"));
    mixin(generateFunQt(2621, "qteQTabWidget_setTabsClosable", "QTabWidget"));
    mixin(generateFunQt(2622, "qteQTabWidget_isMovable", "QTabWidget"));
    mixin(generateFunQt(2623, "qteQTabWidget_setMovable", "QTabWidget"));
    mixin(generateFunQt(2624, "qteQTabWidget_tabShape", "QTabWidget"));
    mixin(generateFunQt(2625, "qteQTabWidget_setTabShape", "QTabWidget"));
    mixin(generateFunQt(2629, "qteQTabWidget_hasHeightForWidth", "QTabWidget"));
    mixin(generateFunQt(2630, "qteQTabWidget_setCornerWidget", "QTabWidget"));
    mixin(generateFunQt(2631, "qteQTabWidget_cornerWidget", "QTabWidget"));
    mixin(generateFunQt(2632, "qteQTabWidget_elideMode", "QTabWidget"));
    mixin(generateFunQt(2633, "qteQTabWidget_setElideMode", "QTabWidget"));
    mixin(generateFunQt(2634, "qteQTabWidget_iconSize", "QTabWidget"));
    mixin(generateFunQt(2635, "qteQTabWidget_setIconSize", "QTabWidget"));
    mixin(generateFunQt(2636, "qteQTabWidget_usesScrollButtons", "QTabWidget"));
    mixin(generateFunQt(2637, "qteQTabWidget_setUsesScrollButtons", "QTabWidget"));
    mixin(generateFunQt(2638, "qteQTabWidget_documentMode", "QTabWidget"));
    mixin(generateFunQt(2639, "qteQTabWidget_setDocumentMode", "QTabWidget"));
    mixin(generateFunQt(2640, "qteQTabWidget_tabBarAutoHide", "QTabWidget"));
    mixin(generateFunQt(2641, "qteQTabWidget_setTabBarAutoHide", "QTabWidget"));
    mixin(generateFunQt(2642, "qteQTabWidget_clear", "QTabWidget"));
    mixin(generateFunQt(2643, "qteQTabWidget_tabBar", "QTabWidget"));
    mixin(generateFunQt(2644, "qteQTabWidget_setCurrentIndex", "QTabWidget"));
    mixin(generateFunQt(2645, "qteQTabWidget_setCurrentWidget", "QTabWidget"));
    mixin(generateFunQt(2646, "qteQTabWidget_setEventHandler", "QTabWidget"));
    mixin(generateFunQt(2649, "qteQTabWidget_setTabToolTip", "QTabWidget"));
}

static this() {
    registerModule("QTabWidget", "qte56_widgets.dll", &loadQTabWidget);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTabWidget.
@live class QTabWidget : QWidget {
public:
    /// Create QTabWidget. parent=null → top-level widget.
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[2600])(parent);
    }

    /// No-op constructor for super() calls and wrap().
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QTabWidget* (e.g. from QUiLoader or findChild).
    static QTabWidget wrap(void* wh) {
        auto w = new QTabWidget(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// addTab
    int addTab(void* widget, string p1) {
        auto _ws_p1 = toQString(p1);
        return cast(int)(cast(t_i__qp_qp_qp)pFunQt[2605])(_wh, widget, _ws_p1);
        (cast(t_v__qp)pFunQt[22])(_ws_p1);
    }

    /// Типизированная версия addTab: автоматически передаёт ownership Qt.
    int addTab(QObject w, string label) {
        if (w is null) return -1;
        auto wh = w.getWH();
        w.disown();
        auto ws = toQString(label);
        auto res = cast(int)(cast(t_i__qp_qp_qp)pFunQt[2605])(_wh, wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return res;
    }

    /// insertTab
    int insertTab(int index, void* widget, string p2) {
        auto _ws_p2 = toQString(p2);
        return cast(int)(cast(t_i__qp_i_qp_qp)pFunQt[2606])(_wh, index, widget, _ws_p2);
        (cast(t_v__qp)pFunQt[22])(_ws_p2);
    }

    /// Типизированная версия insertTab: автоматически передаёт ownership Qt.
    int insertTab(int index, QObject w, string label) {
        if (w is null) return -1;
        auto wh = w.getWH();
        w.disown();
        auto ws = toQString(label);
        auto res = cast(int)(cast(t_i__qp_i_qp_qp)pFunQt[2606])(_wh, index, wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return res;
    }

    /// removeTab
    QTabWidget removeTab(int index) {
        (cast(t_v__qp_i)pFunQt[2607])(_wh, index);
        return this;
    }

    /// isTabEnabled
    bool isTabEnabled(int index) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[2608])(_wh, index);
    }

    /// setTabEnabled
    QTabWidget setTabEnabled(int index, bool p1) {
        (cast(t_v__qp_i_i)pFunQt[2609])(_wh, index, p1 ? 1 : 0);
        return this;
    }

    /// tabText
    string tabText(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[2610])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTabText
    QTabWidget setTabText(int index, string p1) {
        auto _ws_p1 = toQString(p1);
        (cast(t_v__qp_i_qp)pFunQt[2611])(_wh, index, _ws_p1);
        (cast(t_v__qp)pFunQt[22])(_ws_p1);
        return this;
    }

    /// tabToolTip
    string tabToolTip(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[2612])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTabToolTip
    QTabWidget setTabToolTip(int index, string tip) {
        auto _ws_tip = toQString(tip);
        (cast(t_v__qp_i_qp)pFunQt[2649])(_wh, index, _ws_tip);
        (cast(t_v__qp)pFunQt[22])(_ws_tip);
        return this;
    }

    /// setTabWhatsThis
    QTabWidget setTabWhatsThis(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[2613])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// tabWhatsThis
    string tabWhatsThis(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[2614])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// currentIndex
    int currentIndex() {
        return cast(int)(cast(t_i__qp)pFunQt[2615])(_wh);
    }

    /// currentWidget
    void* currentWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[2647])(_wh);
    }

    /// widget
    void* widget(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[2648])(_wh, index);
    }

    /// indexOf
    int indexOf(void* widget) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[2616])(_wh, widget);
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[2617])(_wh);
    }

    /// tabPosition
    int tabPosition() {
        return cast(int)(cast(t_i__qp)pFunQt[2618])(_wh);
    }

    /// setTabPosition
    QTabWidget setTabPosition(int p0) {
        (cast(t_v__qp_i)pFunQt[2619])(_wh, p0);
        return this;
    }

    /// tabsClosable
    bool tabsClosable() {
        return cast(bool)(cast(t_i__qp)pFunQt[2620])(_wh);
    }

    /// setTabsClosable
    QTabWidget setTabsClosable(bool closeable) {
        (cast(t_v__qp_i)pFunQt[2621])(_wh, closeable ? 1 : 0);
        return this;
    }

    /// isMovable
    bool isMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[2622])(_wh);
    }

    /// setMovable
    QTabWidget setMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[2623])(_wh, movable ? 1 : 0);
        return this;
    }

    /// tabShape
    int tabShape() {
        return cast(int)(cast(t_i__qp)pFunQt[2624])(_wh);
    }

    /// setTabShape
    QTabWidget setTabShape(int s) {
        (cast(t_v__qp_i)pFunQt[2625])(_wh, s);
        return this;
    }

    /// setCornerWidget
    QTabWidget setCornerWidget(void* w, int corner) {
        (cast(t_v__qp_qp_i)pFunQt[2630])(_wh, w, corner);
        return this;
    }

    /// cornerWidget
    void* cornerWidget(int corner) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[2631])(_wh, corner);
    }

    /// elideMode
    int elideMode() {
        return cast(int)(cast(t_i__qp)pFunQt[2632])(_wh);
    }

    /// setElideMode
    QTabWidget setElideMode(int p0) {
        (cast(t_v__qp_i)pFunQt[2633])(_wh, p0);
        return this;
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[2634])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setIconSize
    QTabWidget setIconSize(void* size) {
        (cast(t_v__qp_qp)pFunQt[2635])(_wh, size);
        return this;
    }

    /// usesScrollButtons
    bool usesScrollButtons() {
        return cast(bool)(cast(t_i__qp)pFunQt[2636])(_wh);
    }

    /// setUsesScrollButtons
    QTabWidget setUsesScrollButtons(bool useButtons) {
        (cast(t_v__qp_i)pFunQt[2637])(_wh, useButtons ? 1 : 0);
        return this;
    }

    /// documentMode
    bool documentMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[2638])(_wh);
    }

    /// setDocumentMode
    QTabWidget setDocumentMode(bool set) {
        (cast(t_v__qp_i)pFunQt[2639])(_wh, set ? 1 : 0);
        return this;
    }

    /// tabBarAutoHide
    bool tabBarAutoHide() {
        return cast(bool)(cast(t_i__qp)pFunQt[2640])(_wh);
    }

    /// setTabBarAutoHide
    QTabWidget setTabBarAutoHide(bool enabled) {
        (cast(t_v__qp_i)pFunQt[2641])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// clear
    QTabWidget clear() {
        (cast(t_v__qp)pFunQt[2642])(_wh);
        return this;
    }

    /// tabBar — возвращает Qt-owned QTabBar
    QTabBar tabBar() {
        void* p = (cast(t_qp__qp)pFunQt[2643])(_wh);
        return QTabBar.wrapOwned(p);
    }

    /// setCurrentIndex
    QTabWidget setCurrentIndex(int index) {
        (cast(t_v__qp_i)pFunQt[2644])(_wh, index);
        return this;
    }

    /// setCurrentWidget
    QTabWidget setCurrentWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[2645])(_wh, widget);
        return this;
    }

    /// Connect signal currentChanged → ESlot
    QTabWidget connect_currentChanged(ESlot eslot) {
        connectQt(_wh, "currentChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabCloseRequested → ESlot
    QTabWidget connect_tabCloseRequested(ESlot eslot) {
        connectQt(_wh, "tabCloseRequested(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabBarClicked → ESlot
    QTabWidget connect_tabBarClicked(ESlot eslot) {
        connectQt(_wh, "tabBarClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal tabBarDoubleClicked → ESlot
    QTabWidget connect_tabBarDoubleClicked(ESlot eslot) {
        connectQt(_wh, "tabBarDoubleClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QTabWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[2646])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTabWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTabWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTabWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTabWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTabWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTabWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QTabWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTabWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QTabWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QTabWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QTabWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QTabWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QTabWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QTabWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTabWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTabWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QTabWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QTabWidget
