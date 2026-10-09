/**
 * gen_qtoolbox.d — GENERATED wrapper for QToolBox.
 * Module: QToolBox  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtoolbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_i_qp, t_i__qp_i_qp_qp, t_i__qp_qp, t_i__qp_qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, toQString;
import gen_qframe : QFrame;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_qp_qp_i"));
mixin(generateAlias("i__qp_qp_qp_qp"));
mixin(generateAlias("i__qp_i_qp_qp_qp"));
mixin(generateAlias("i__qp_i_qp_qp_qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("i__qp_qp_qp_i"));
mixin(generateAlias("i__qp_qp_qp_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQToolBox() {
    mixin(generateFunQt(11000, "qteQToolBox_create", "QToolBox"));
    mixin(generateFunQt(11001, "qteQToolBox_delete", "QToolBox"));
    mixin(generateFunQt(11005, "qteQToolBox_addItem_ws", "QToolBox"));
    mixin(generateFunQt(11006, "qteQToolBox_addItem_wps", "QToolBox"));
    mixin(generateFunQt(11007, "qteQToolBox_insertItem_iws", "QToolBox"));
    mixin(generateFunQt(11008, "qteQToolBox_insertItem_iwps", "QToolBox"));
    mixin(generateFunQt(11009, "qteQToolBox_removeItem", "QToolBox"));
    mixin(generateFunQt(11010, "qteQToolBox_setItemEnabled", "QToolBox"));
    mixin(generateFunQt(11011, "qteQToolBox_isItemEnabled", "QToolBox"));
    mixin(generateFunQt(11012, "qteQToolBox_setItemText", "QToolBox"));
    mixin(generateFunQt(11013, "qteQToolBox_itemText", "QToolBox"));
    mixin(generateFunQt(11014, "qteQToolBox_setItemIcon", "QToolBox"));
    mixin(generateFunQt(11015, "qteQToolBox_itemIcon", "QToolBox"));
    mixin(generateFunQt(11016, "qteQToolBox_setItemToolTip", "QToolBox"));
    mixin(generateFunQt(11017, "qteQToolBox_itemToolTip", "QToolBox"));
    mixin(generateFunQt(11018, "qteQToolBox_currentIndex", "QToolBox"));
    mixin(generateFunQt(11019, "qteQToolBox_currentWidget", "QToolBox"));
    mixin(generateFunQt(11020, "qteQToolBox_widget", "QToolBox"));
    mixin(generateFunQt(11021, "qteQToolBox_indexOf", "QToolBox"));
    mixin(generateFunQt(11022, "qteQToolBox_count", "QToolBox"));
    mixin(generateFunQt(11023, "qteQToolBox_setCurrentIndex", "QToolBox"));
    mixin(generateFunQt(11024, "qteQToolBox_setCurrentWidget", "QToolBox"));
    mixin(generateFunQt(11025, "qteQToolBox_setEventHandler", "QToolBox"));
}

static this() {
    registerModule("QToolBox", "qte56_mainwin.dll", &loadQToolBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QToolBox.
@live class QToolBox : QFrame {
public:
    /// Create QToolBox. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[11000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// addItem
    int addItem(void* widget, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_qp_qp)pFunQt[11005])(_wh, widget, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addItem
    int addItem(void* widget, void* icon, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_qp_qp_qp)pFunQt[11006])(_wh, widget, icon, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// insertItem
    int insertItem(int index, void* widget, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_i_qp_qp)pFunQt[11007])(_wh, index, widget, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// insertItem
    int insertItem(int index, void* widget, void* icon, string text) {
        auto _ws_text = toQString(text);
        return cast(int)(cast(t_i__qp_i_qp_qp_qp)pFunQt[11008])(_wh, index, widget, icon, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// removeItem
    QToolBox removeItem(int index) {
        (cast(t_v__qp_i)pFunQt[11009])(_wh, index);
        return this;
    }

    /// setItemEnabled
    QToolBox setItemEnabled(int index, bool enabled) {
        (cast(t_v__qp_i_i)pFunQt[11010])(_wh, index, enabled ? 1 : 0);
        return this;
    }

    /// isItemEnabled
    bool isItemEnabled(int index) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[11011])(_wh, index);
    }

    /// setItemText
    QToolBox setItemText(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[11012])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// itemText
    string itemText(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[11013])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setItemIcon
    QToolBox setItemIcon(int index, void* icon) {
        (cast(t_v__qp_i_qp)pFunQt[11014])(_wh, index, icon);
        return this;
    }

    /// itemIcon
    void* itemIcon(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[11015])(_wh, index);
    }

    /// setItemToolTip
    QToolBox setItemToolTip(int index, string toolTip) {
        auto _ws_toolTip = toQString(toolTip);
        (cast(t_v__qp_i_qp)pFunQt[11016])(_wh, index, _ws_toolTip);
        (cast(t_v__qp)pFunQt[22])(_ws_toolTip);
        return this;
    }

    /// itemToolTip
    string itemToolTip(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[11017])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// currentIndex
    int currentIndex() {
        return cast(int)(cast(t_i__qp)pFunQt[11018])(_wh);
    }

    /// currentWidget
    void* currentWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[11019])(_wh);
    }

    /// widget
    void* widget(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[11020])(_wh, index);
    }

    /// indexOf
    int indexOf(void* widget) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[11021])(_wh, widget);
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[11022])(_wh);
    }

    /// setCurrentIndex
    QToolBox setCurrentIndex(int index) {
        (cast(t_v__qp_i)pFunQt[11023])(_wh, index);
        return this;
    }

    /// setCurrentWidget
    QToolBox setCurrentWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[11024])(_wh, widget);
        return this;
    }

    /// Connect signal currentChanged → ESlot
    QToolBox connect_currentChanged(ESlot eslot) {
        connectQt(_wh, "currentChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QToolBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[11025])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QToolBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QToolBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QToolBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QToolBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QToolBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QToolBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QToolBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QToolBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QToolBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QToolBox
