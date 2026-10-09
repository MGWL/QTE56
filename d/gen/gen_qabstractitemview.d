/**
 * gen_qabstractitemview.d — GENERATED wrapper for QAbstractItemView.
 * Module: QAbstractItemView  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qabstractitemview;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qabstractscrollarea : QAbstractScrollArea;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQAbstractItemView() {
    mixin(generateFunQt(8800, "qteQAbstractItemView_create", "QAbstractItemView"));
    mixin(generateFunQt(8801, "qteQAbstractItemView_delete", "QAbstractItemView"));
    mixin(generateFunQt(8805, "qteQAbstractItemView_setModel", "QAbstractItemView"));
    mixin(generateFunQt(8806, "qteQAbstractItemView_model", "QAbstractItemView"));
    mixin(generateFunQt(8807, "qteQAbstractItemView_setSelectionModel", "QAbstractItemView"));
    mixin(generateFunQt(8808, "qteQAbstractItemView_selectionModel", "QAbstractItemView"));
    mixin(generateFunQt(8809, "qteQAbstractItemView_setItemDelegate", "QAbstractItemView"));
    mixin(generateFunQt(8810, "qteQAbstractItemView_itemDelegate", "QAbstractItemView"));
    mixin(generateFunQt(8811, "qteQAbstractItemView_setSelectionMode", "QAbstractItemView"));
    mixin(generateFunQt(8812, "qteQAbstractItemView_selectionMode", "QAbstractItemView"));
    mixin(generateFunQt(8813, "qteQAbstractItemView_setSelectionBehavior", "QAbstractItemView"));
    mixin(generateFunQt(8814, "qteQAbstractItemView_selectionBehavior", "QAbstractItemView"));
    mixin(generateFunQt(8815, "qteQAbstractItemView_setEditTriggers", "QAbstractItemView"));
    mixin(generateFunQt(8816, "qteQAbstractItemView_editTriggers", "QAbstractItemView"));
    mixin(generateFunQt(8817, "qteQAbstractItemView_setVerticalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8818, "qteQAbstractItemView_verticalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8819, "qteQAbstractItemView_resetVerticalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8820, "qteQAbstractItemView_setHorizontalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8821, "qteQAbstractItemView_horizontalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8822, "qteQAbstractItemView_resetHorizontalScrollMode", "QAbstractItemView"));
    mixin(generateFunQt(8823, "qteQAbstractItemView_setAutoScroll", "QAbstractItemView"));
    mixin(generateFunQt(8824, "qteQAbstractItemView_hasAutoScroll", "QAbstractItemView"));
    mixin(generateFunQt(8825, "qteQAbstractItemView_setAutoScrollMargin", "QAbstractItemView"));
    mixin(generateFunQt(8826, "qteQAbstractItemView_autoScrollMargin", "QAbstractItemView"));
    mixin(generateFunQt(8827, "qteQAbstractItemView_setTabKeyNavigation", "QAbstractItemView"));
    mixin(generateFunQt(8828, "qteQAbstractItemView_tabKeyNavigation", "QAbstractItemView"));
    mixin(generateFunQt(8829, "qteQAbstractItemView_setDropIndicatorShown", "QAbstractItemView"));
    mixin(generateFunQt(8830, "qteQAbstractItemView_showDropIndicator", "QAbstractItemView"));
    mixin(generateFunQt(8831, "qteQAbstractItemView_setDragEnabled", "QAbstractItemView"));
    mixin(generateFunQt(8832, "qteQAbstractItemView_dragEnabled", "QAbstractItemView"));
    mixin(generateFunQt(8833, "qteQAbstractItemView_setDragDropOverwriteMode", "QAbstractItemView"));
    mixin(generateFunQt(8834, "qteQAbstractItemView_dragDropOverwriteMode", "QAbstractItemView"));
    mixin(generateFunQt(8835, "qteQAbstractItemView_setDragDropMode", "QAbstractItemView"));
    mixin(generateFunQt(8836, "qteQAbstractItemView_dragDropMode", "QAbstractItemView"));
    mixin(generateFunQt(8837, "qteQAbstractItemView_setDefaultDropAction", "QAbstractItemView"));
    mixin(generateFunQt(8838, "qteQAbstractItemView_defaultDropAction", "QAbstractItemView"));
    mixin(generateFunQt(8839, "qteQAbstractItemView_setAlternatingRowColors", "QAbstractItemView"));
    mixin(generateFunQt(8840, "qteQAbstractItemView_alternatingRowColors", "QAbstractItemView"));
    mixin(generateFunQt(8841, "qteQAbstractItemView_setIconSize", "QAbstractItemView"));
    mixin(generateFunQt(8842, "qteQAbstractItemView_iconSize", "QAbstractItemView"));
    mixin(generateFunQt(8843, "qteQAbstractItemView_setTextElideMode", "QAbstractItemView"));
    mixin(generateFunQt(8844, "qteQAbstractItemView_textElideMode", "QAbstractItemView"));
    mixin(generateFunQt(8845, "qteQAbstractItemView_keyboardSearch", "QAbstractItemView"));
    mixin(generateFunQt(8846, "qteQAbstractItemView_sizeHintForRow", "QAbstractItemView"));
    mixin(generateFunQt(8847, "qteQAbstractItemView_sizeHintForColumn", "QAbstractItemView"));
    mixin(generateFunQt(8848, "qteQAbstractItemView_setItemDelegateForRow", "QAbstractItemView"));
    mixin(generateFunQt(8849, "qteQAbstractItemView_itemDelegateForRow", "QAbstractItemView"));
    mixin(generateFunQt(8850, "qteQAbstractItemView_setItemDelegateForColumn", "QAbstractItemView"));
    mixin(generateFunQt(8851, "qteQAbstractItemView_itemDelegateForColumn", "QAbstractItemView"));
    mixin(generateFunQt(8852, "qteQAbstractItemView_reset", "QAbstractItemView"));
    mixin(generateFunQt(8853, "qteQAbstractItemView_doItemsLayout", "QAbstractItemView"));
    mixin(generateFunQt(8854, "qteQAbstractItemView_selectAll", "QAbstractItemView"));
    mixin(generateFunQt(8855, "qteQAbstractItemView_clearSelection", "QAbstractItemView"));
    mixin(generateFunQt(8858, "qteQAbstractItemView_currentIndex", "QAbstractItemView"));
    mixin(generateFunQt(8856, "qteQAbstractItemView_scrollToTop", "QAbstractItemView"));
    mixin(generateFunQt(8857, "qteQAbstractItemView_scrollToBottom", "QAbstractItemView"));
    mixin(generateFunQt(8877, "qteQAbstractItemView_setEventHandler", "QAbstractItemView"));
}

static this() {
    registerModule("QAbstractItemView", "qte56_views.dll", &loadQAbstractItemView);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAbstractItemView.
@live class QAbstractItemView : QAbstractScrollArea {
public:
    /// Create QAbstractItemView. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[8800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setModel
    QAbstractItemView setModel(void* model) {
        (cast(t_v__qp_qp)pFunQt[8805])(_wh, model);
        return this;
    }

    /// model
    void* model() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8806])(_wh);
    }

    /// setSelectionModel
    QAbstractItemView setSelectionModel(void* selectionModel) {
        (cast(t_v__qp_qp)pFunQt[8807])(_wh, selectionModel);
        return this;
    }

    /// selectionModel
    void* selectionModel() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8808])(_wh);
    }

    /// setItemDelegate
    QAbstractItemView setItemDelegate(void* delegate_) {
        (cast(t_v__qp_qp)pFunQt[8809])(_wh, delegate_);
        return this;
    }

    /// itemDelegate
    void* itemDelegate() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8810])(_wh);
    }

    /// setSelectionMode
    QAbstractItemView setSelectionMode(int mode) {
        (cast(t_v__qp_i)pFunQt[8811])(_wh, mode);
        return this;
    }

    /// selectionMode
    int selectionMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8812])(_wh);
    }

    /// setSelectionBehavior
    QAbstractItemView setSelectionBehavior(int behavior) {
        (cast(t_v__qp_i)pFunQt[8813])(_wh, behavior);
        return this;
    }

    /// selectionBehavior
    int selectionBehavior() {
        return cast(int)(cast(t_i__qp)pFunQt[8814])(_wh);
    }

    /// setEditTriggers
    QAbstractItemView setEditTriggers(int triggers) {
        (cast(t_v__qp_i)pFunQt[8815])(_wh, triggers);
        return this;
    }

    /// editTriggers
    int editTriggers() {
        return cast(int)(cast(t_i__qp)pFunQt[8816])(_wh);
    }

    /// setVerticalScrollMode
    QAbstractItemView setVerticalScrollMode(int mode) {
        (cast(t_v__qp_i)pFunQt[8817])(_wh, mode);
        return this;
    }

    /// verticalScrollMode
    int verticalScrollMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8818])(_wh);
    }

    /// resetVerticalScrollMode
    QAbstractItemView resetVerticalScrollMode() {
        (cast(t_v__qp)pFunQt[8819])(_wh);
        return this;
    }

    /// setHorizontalScrollMode
    QAbstractItemView setHorizontalScrollMode(int mode) {
        (cast(t_v__qp_i)pFunQt[8820])(_wh, mode);
        return this;
    }

    /// horizontalScrollMode
    int horizontalScrollMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8821])(_wh);
    }

    /// resetHorizontalScrollMode
    QAbstractItemView resetHorizontalScrollMode() {
        (cast(t_v__qp)pFunQt[8822])(_wh);
        return this;
    }

    /// setAutoScroll
    QAbstractItemView setAutoScroll(bool enable) {
        (cast(t_v__qp_i)pFunQt[8823])(_wh, enable ? 1 : 0);
        return this;
    }

    /// hasAutoScroll
    bool hasAutoScroll() {
        return cast(bool)(cast(t_i__qp)pFunQt[8824])(_wh);
    }

    /// setAutoScrollMargin
    QAbstractItemView setAutoScrollMargin(int margin) {
        (cast(t_v__qp_i)pFunQt[8825])(_wh, margin);
        return this;
    }

    /// autoScrollMargin
    int autoScrollMargin() {
        return cast(int)(cast(t_i__qp)pFunQt[8826])(_wh);
    }

    /// setTabKeyNavigation
    QAbstractItemView setTabKeyNavigation(bool enable) {
        (cast(t_v__qp_i)pFunQt[8827])(_wh, enable ? 1 : 0);
        return this;
    }

    /// tabKeyNavigation
    bool tabKeyNavigation() {
        return cast(bool)(cast(t_i__qp)pFunQt[8828])(_wh);
    }

    /// setDropIndicatorShown
    QAbstractItemView setDropIndicatorShown(bool enable) {
        (cast(t_v__qp_i)pFunQt[8829])(_wh, enable ? 1 : 0);
        return this;
    }

    /// showDropIndicator
    bool showDropIndicator() {
        return cast(bool)(cast(t_i__qp)pFunQt[8830])(_wh);
    }

    /// setDragEnabled
    QAbstractItemView setDragEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[8831])(_wh, enable ? 1 : 0);
        return this;
    }

    /// dragEnabled
    bool dragEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[8832])(_wh);
    }

    /// setDragDropOverwriteMode
    QAbstractItemView setDragDropOverwriteMode(bool overwrite) {
        (cast(t_v__qp_i)pFunQt[8833])(_wh, overwrite ? 1 : 0);
        return this;
    }

    /// dragDropOverwriteMode
    bool dragDropOverwriteMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[8834])(_wh);
    }

    /// setDragDropMode
    QAbstractItemView setDragDropMode(int behavior) {
        (cast(t_v__qp_i)pFunQt[8835])(_wh, behavior);
        return this;
    }

    /// dragDropMode
    int dragDropMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8836])(_wh);
    }

    /// setDefaultDropAction
    QAbstractItemView setDefaultDropAction(int dropAction) {
        (cast(t_v__qp_i)pFunQt[8837])(_wh, dropAction);
        return this;
    }

    /// defaultDropAction
    int defaultDropAction() {
        return cast(int)(cast(t_i__qp)pFunQt[8838])(_wh);
    }

    /// setAlternatingRowColors
    QAbstractItemView setAlternatingRowColors(bool enable) {
        (cast(t_v__qp_i)pFunQt[8839])(_wh, enable ? 1 : 0);
        return this;
    }

    /// alternatingRowColors
    bool alternatingRowColors() {
        return cast(bool)(cast(t_i__qp)pFunQt[8840])(_wh);
    }

    /// setIconSize
    QAbstractItemView setIconSize(void* size) {
        (cast(t_v__qp_qp)pFunQt[8841])(_wh, size);
        return this;
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[8842])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setTextElideMode
    QAbstractItemView setTextElideMode(int mode) {
        (cast(t_v__qp_i)pFunQt[8843])(_wh, mode);
        return this;
    }

    /// textElideMode
    int textElideMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8844])(_wh);
    }

    /// keyboardSearch
    QAbstractItemView keyboardSearch(string search) {
        auto _ws_search = toQString(search);
        (cast(t_v__qp_qp)pFunQt[8845])(_wh, _ws_search);
        (cast(t_v__qp)pFunQt[22])(_ws_search);
        return this;
    }

    /// sizeHintForRow
    int sizeHintForRow(int row) {
        return cast(int)(cast(t_i__qp_i)pFunQt[8846])(_wh, row);
    }

    /// sizeHintForColumn
    int sizeHintForColumn(int column) {
        return cast(int)(cast(t_i__qp_i)pFunQt[8847])(_wh, column);
    }

    /// setItemDelegateForRow
    QAbstractItemView setItemDelegateForRow(int row, void* delegate_) {
        (cast(t_v__qp_i_qp)pFunQt[8848])(_wh, row, delegate_);
        return this;
    }

    /// itemDelegateForRow
    void* itemDelegateForRow(int row) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[8849])(_wh, row);
    }

    /// setItemDelegateForColumn
    QAbstractItemView setItemDelegateForColumn(int column, void* delegate_) {
        (cast(t_v__qp_i_qp)pFunQt[8850])(_wh, column, delegate_);
        return this;
    }

    /// itemDelegateForColumn
    void* itemDelegateForColumn(int column) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[8851])(_wh, column);
    }

    /// reset
    QAbstractItemView reset() {
        (cast(t_v__qp)pFunQt[8852])(_wh);
        return this;
    }

    /// doItemsLayout
    QAbstractItemView doItemsLayout() {
        (cast(t_v__qp)pFunQt[8853])(_wh);
        return this;
    }

    /// selectAll
    QAbstractItemView selectAll() {
        (cast(t_v__qp)pFunQt[8854])(_wh);
        return this;
    }

    /// clearSelection
    QAbstractItemView clearSelection() {
        (cast(t_v__qp)pFunQt[8855])(_wh);
        return this;
    }

    /// currentIndex — returns QModelIndex wrapper (caller-owned)
    import gen_qmodelindex : QModelIndex;
    QModelIndex currentIndex() {
        return QModelIndex.wrap((cast(t_qp__qp)pFunQt[8858])(_wh));
    }

    /// scrollToTop
    QAbstractItemView scrollToTop() {
        (cast(t_v__qp)pFunQt[8856])(_wh);
        return this;
    }

    /// scrollToBottom
    QAbstractItemView scrollToBottom() {
        (cast(t_v__qp)pFunQt[8857])(_wh);
        return this;
    }

    /// Connect signal viewportEntered → ESlot
    QAbstractItemView connect_viewportEntered(ESlot eslot) {
        connectQt(_wh, "viewportEntered()", eslot, "invoke_v()");
        return this;
    }

    // Signal iconSizeChanged — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QAbstractItemView setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8877])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractItemView onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractItemView onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractItemView onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractItemView onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractItemView onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractItemView onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QAbstractItemView onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractItemView onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QAbstractItemView onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractItemView onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractItemView onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractItemView onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractItemView onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QAbstractItemView onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractItemView onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractItemView onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QAbstractItemView onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QAbstractItemView
