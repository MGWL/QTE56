/**
 * gen_qtreewidget.d — GENERATED wrapper for QTreeWidget.
 * Module: QTreeWidget  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtreewidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, freeQStringList, ptrListFromQStr, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString, toQStringList;
import gen_qtreeview : QTreeView;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_i_i"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_i_i"));
mixin(generateAlias("v__qp_qp_i_qp"));
// Extra aliases for item helpers:
mixin(generateAlias("i__qp_qp_i")); // int(void*, void*, int) — isPersistentEditorOpen
mixin(generateAlias("i__qp_i"));     // int(void*, int) — checkState(col), etc.
mixin(generateAlias("qp__qp_i"));    // void*(void*, int) — text(col), child(idx)
mixin(generateAlias("v__qp_i_i_qp")); // void(void*, int, int, void*) — setText(col, ws, len) — wait, need 4 params
// text(item, col) → void*(void*, int); setText(item, col, wchar*, len) → void(void*, int, void*, int)
mixin(generateAlias("v__qp_i_qp_i")); // void(void*, int, void*, int) — setText
mixin(generateAlias("v__qp_qp_qp")); // void(void*, void*, void*) — signal connect w/ 2 ptrs

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTreeWidget() {
    mixin(generateFunQt(9600, "qteQTreeWidget_create", "QTreeWidget"));
    mixin(generateFunQt(9601, "qteQTreeWidget_delete", "QTreeWidget"));
    mixin(generateFunQt(9605, "qteQTreeWidget_columnCount", "QTreeWidget"));
    mixin(generateFunQt(9606, "qteQTreeWidget_setColumnCount", "QTreeWidget"));
    mixin(generateFunQt(9607, "qteQTreeWidget_invisibleRootItem", "QTreeWidget"));
    mixin(generateFunQt(9608, "qteQTreeWidget_topLevelItem", "QTreeWidget"));
    mixin(generateFunQt(9609, "qteQTreeWidget_topLevelItemCount", "QTreeWidget"));
    mixin(generateFunQt(9610, "qteQTreeWidget_insertTopLevelItem", "QTreeWidget"));
    mixin(generateFunQt(9611, "qteQTreeWidget_addTopLevelItem", "QTreeWidget"));
    mixin(generateFunQt(9612, "qteQTreeWidget_takeTopLevelItem", "QTreeWidget"));
    mixin(generateFunQt(9613, "qteQTreeWidget_indexOfTopLevelItem", "QTreeWidget"));
    mixin(generateFunQt(9614, "qteQTreeWidget_headerItem", "QTreeWidget"));
    mixin(generateFunQt(9615, "qteQTreeWidget_setHeaderItem", "QTreeWidget"));
    mixin(generateFunQt(9616, "qteQTreeWidget_setHeaderLabel", "QTreeWidget"));
    mixin(generateFunQt(9617, "qteQTreeWidget_currentItem", "QTreeWidget"));
    mixin(generateFunQt(9618, "qteQTreeWidget_currentColumn", "QTreeWidget"));
    mixin(generateFunQt(9619, "qteQTreeWidget_setCurrentItem_p", "QTreeWidget"));
    mixin(generateFunQt(9620, "qteQTreeWidget_setCurrentItem_pi", "QTreeWidget"));
    mixin(generateFunQt(9621, "qteQTreeWidget_setCurrentItem_pip", "QTreeWidget"));
    mixin(generateFunQt(9622, "qteQTreeWidget_itemAt_p", "QTreeWidget"));
    mixin(generateFunQt(9623, "qteQTreeWidget_itemAt_ii", "QTreeWidget"));
    mixin(generateFunQt(9624, "qteQTreeWidget_visualItemRect", "QTreeWidget"));
    mixin(generateFunQt(9625, "qteQTreeWidget_sortColumn", "QTreeWidget"));
    mixin(generateFunQt(9626, "qteQTreeWidget_sortItems", "QTreeWidget"));
    mixin(generateFunQt(9627, "qteQTreeWidget_editItem", "QTreeWidget"));
    mixin(generateFunQt(9628, "qteQTreeWidget_openPersistentEditor", "QTreeWidget"));
    mixin(generateFunQt(9629, "qteQTreeWidget_closePersistentEditor", "QTreeWidget"));
    mixin(generateFunQt(9630, "qteQTreeWidget_isPersistentEditorOpen", "QTreeWidget"));
    mixin(generateFunQt(9631, "qteQTreeWidget_itemWidget", "QTreeWidget"));
    mixin(generateFunQt(9632, "qteQTreeWidget_setItemWidget", "QTreeWidget"));
    mixin(generateFunQt(9633, "qteQTreeWidget_removeItemWidget", "QTreeWidget"));
    mixin(generateFunQt(9634, "qteQTreeWidget_isItemSelected", "QTreeWidget"));
    mixin(generateFunQt(9635, "qteQTreeWidget_setItemSelected", "QTreeWidget"));
    mixin(generateFunQt(9636, "qteQTreeWidget_isItemHidden", "QTreeWidget"));
    mixin(generateFunQt(9637, "qteQTreeWidget_setItemHidden", "QTreeWidget"));
    mixin(generateFunQt(9638, "qteQTreeWidget_isItemExpanded", "QTreeWidget"));
    mixin(generateFunQt(9639, "qteQTreeWidget_setItemExpanded", "QTreeWidget"));
    mixin(generateFunQt(9640, "qteQTreeWidget_isFirstItemColumnSpanned", "QTreeWidget"));
    mixin(generateFunQt(9641, "qteQTreeWidget_setFirstItemColumnSpanned", "QTreeWidget"));
    mixin(generateFunQt(9642, "qteQTreeWidget_itemAbove", "QTreeWidget"));
    mixin(generateFunQt(9643, "qteQTreeWidget_itemBelow", "QTreeWidget"));
    mixin(generateFunQt(9645, "qteQTreeWidget_scrollToItem", "QTreeWidget"));
    mixin(generateFunQt(9646, "qteQTreeWidget_expandItem", "QTreeWidget"));
    mixin(generateFunQt(9647, "qteQTreeWidget_collapseItem", "QTreeWidget"));
    mixin(generateFunQt(9648, "qteQTreeWidget_clear", "QTreeWidget"));
    mixin(generateFunQt(9649, "qteQTreeWidget_setEventHandler", "QTreeWidget"));
    // ── Signal connections ────────────────────────────────────────────────────
    mixin(generateFunQt(9650, "qteQTreeWidget_connectItemClicked",         "QTreeWidget"));
    mixin(generateFunQt(9651, "qteQTreeWidget_connectItemDoubleClicked",   "QTreeWidget"));
    mixin(generateFunQt(9652, "qteQTreeWidget_connectItemChanged",         "QTreeWidget"));
    mixin(generateFunQt(9653, "qteQTreeWidget_connectItemActivated",       "QTreeWidget"));
    mixin(generateFunQt(9654, "qteQTreeWidget_connectItemExpanded",        "QTreeWidget"));
    mixin(generateFunQt(9655, "qteQTreeWidget_connectItemCollapsed",       "QTreeWidget"));
    mixin(generateFunQt(9656, "qteQTreeWidget_connectCurrentItemChanged",  "QTreeWidget"));
    mixin(generateFunQt(9657, "qteQTreeWidget_connectItemSelectionChanged","QTreeWidget"));
    // ── QTreeWidgetItem helpers ───────────────────────────────────────────────
    mixin(generateFunQt(9658, "qteQTreeWidgetItem_create",       "QTreeWidget"));
    mixin(generateFunQt(9659, "qteQTreeWidgetItem_create_text",  "QTreeWidget"));
    mixin(generateFunQt(9660, "qteQTreeWidgetItem_delete",       "QTreeWidget"));
    mixin(generateFunQt(9661, "qteQTreeWidgetItem_text",         "QTreeWidget"));
    mixin(generateFunQt(9662, "qteQTreeWidgetItem_setText",      "QTreeWidget"));
    mixin(generateFunQt(9663, "qteQTreeWidgetItem_flags",        "QTreeWidget"));
    mixin(generateFunQt(9664, "qteQTreeWidgetItem_setFlags",     "QTreeWidget"));
    mixin(generateFunQt(9665, "qteQTreeWidgetItem_isExpanded",   "QTreeWidget"));
    mixin(generateFunQt(9666, "qteQTreeWidgetItem_setExpanded",  "QTreeWidget"));
    mixin(generateFunQt(9667, "qteQTreeWidgetItem_isSelected",   "QTreeWidget"));
    mixin(generateFunQt(9668, "qteQTreeWidgetItem_setSelected",  "QTreeWidget"));
    mixin(generateFunQt(9669, "qteQTreeWidgetItem_isHidden",     "QTreeWidget"));
    mixin(generateFunQt(9670, "qteQTreeWidgetItem_setHidden",    "QTreeWidget"));
    mixin(generateFunQt(9671, "qteQTreeWidgetItem_parent",       "QTreeWidget"));
    mixin(generateFunQt(9672, "qteQTreeWidgetItem_childCount",   "QTreeWidget"));
    mixin(generateFunQt(9673, "qteQTreeWidgetItem_child",        "QTreeWidget"));
    mixin(generateFunQt(9674, "qteQTreeWidgetItem_addChild",     "QTreeWidget"));
    mixin(generateFunQt(9675, "qteQTreeWidgetItem_insertChild",  "QTreeWidget"));
    mixin(generateFunQt(9676, "qteQTreeWidgetItem_takeChild",    "QTreeWidget"));
    mixin(generateFunQt(9677, "qteQTreeWidgetItem_removeChild",  "QTreeWidget"));
    mixin(generateFunQt(9678, "qteQTreeWidgetItem_indexOfChild", "QTreeWidget"));
    mixin(generateFunQt(9679, "qteQTreeWidgetItem_checkState",   "QTreeWidget"));
    mixin(generateFunQt(9680, "qteQTreeWidgetItem_setCheckState","QTreeWidget"));
    mixin(generateFunQt(9682, "qteQTreeWidget_setHeaderLabels",  "QTreeWidget"));
    mixin(generateFunQt(9681, "qteQTreeWidget_selectedItems",    "QTreeWidget"));
}

static this() {
    registerModule("QTreeWidget", "qte56_views.dll", &loadQTreeWidget);
}

// ====================================================================
// QTreeWidgetItem class
// ====================================================================

/**
 * D wrapper for QTreeWidgetItem.
 *
 * Ownership:
 *   - new QTreeWidgetItem("text") — D-owned; dtor deletes C++ object.
 *   - After addTopLevelItem(item) / addChild(item) — Qt owns it; call disown() or use typed overloads.
 *   - QTreeWidgetItem.wrap(ptr) — Qt-owned wrapper; dtor does NOT delete.
 *   - takeTopLevelItem/takeChild — returns caller-owned item; dtor WILL delete.
 *
 * Text is per-column: item.text(0), item.setText(0, "foo").
 * Children: addChild, insertChild, takeChild, child(index), childCount.
 */
@live class QTreeWidgetItem {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    /// Internal: wrap existing pointer without creating C++ object.
    this(void* ptr, bool qtOwned) {
        _wh = ptr;
        _qt_owned = qtOwned;
    }

public:
    /// Create empty item (D-owned).
    this() {
        _wh = (cast(t_qp__qp)pFunQt[9658])(null);
        _qt_owned = false;
    }

    /// Create item with text in column 0 (D-owned).
    this(string text) {
        auto ws = toQString(text);
        _wh = (cast(t_qp__qp)pFunQt[9659])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        _qt_owned = false;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[9660] !is null) {
            (cast(t_v__qp)pFunQt[9660])(_wh);
            _wh = null;
        }
    }

    void* getWH() const { return cast(void*)_wh; }

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown() { _qt_owned = true; }

    /// Wrap a Qt-owned pointer (e.g. from topLevelItem/child). Dtor does NOT delete.
    static QTreeWidgetItem wrap(void* ptr) {
        if (ptr is null) return null;
        return new QTreeWidgetItem(ptr, true);
    }

    // ── Text ─────────────────────────────────────────────────────────────────

    string text(int column = 0) {
        void* qs = (cast(t_qp__qp_i)pFunQt[9661])(_wh, column);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTreeWidgetItem setText(int column, string text) {
        auto ws = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[9662])(_wh, column, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Flags ─────────────────────────────────────────────────────────────────

    int flags() { return cast(int)(cast(t_i__qp)pFunQt[9663])(_wh); }
    QTreeWidgetItem setFlags(int flags) { (cast(t_v__qp_i)pFunQt[9664])(_wh, flags); return this; }

    // ── Expand / Hide / Select ────────────────────────────────────────────────

    bool isExpanded() { return cast(bool)(cast(t_i__qp)pFunQt[9665])(_wh); }
    QTreeWidgetItem setExpanded(bool v) { (cast(t_v__qp_i)pFunQt[9666])(_wh, v ? 1 : 0); return this; }

    bool isSelected() { return cast(bool)(cast(t_i__qp)pFunQt[9667])(_wh); }
    QTreeWidgetItem setSelected(bool v) { (cast(t_v__qp_i)pFunQt[9668])(_wh, v ? 1 : 0); return this; }

    bool isHidden() { return cast(bool)(cast(t_i__qp)pFunQt[9669])(_wh); }
    QTreeWidgetItem setHidden(bool v) { (cast(t_v__qp_i)pFunQt[9670])(_wh, v ? 1 : 0); return this; }

    // ── Parent / Children ─────────────────────────────────────────────────────

    /// Parent item (null if top-level). Qt-owned wrapper.
    QTreeWidgetItem parent() {
        return QTreeWidgetItem.wrap((cast(t_qp__qp)pFunQt[9671])(_wh));
    }

    int childCount() { return cast(int)(cast(t_i__qp)pFunQt[9672])(_wh); }

    /// Get child at index — Qt-owned wrapper.
    QTreeWidgetItem child(int index) {
        return QTreeWidgetItem.wrap((cast(t_qp__qp_i)pFunQt[9673])(_wh, index));
    }

    /// Add child (Qt takes ownership, child.disown() called automatically).
    QTreeWidgetItem addChild(QTreeWidgetItem c) {
        (cast(t_v__qp_qp)pFunQt[9674])(_wh, c.getWH());
        c.disown();
        return this;
    }

    /// Insert child at index (Qt takes ownership, child.disown() called automatically).
    QTreeWidgetItem insertChild(int index, QTreeWidgetItem c) {
        (cast(t_v__qp_i_qp)pFunQt[9675])(_wh, index, c.getWH());
        c.disown();
        return this;
    }

    /// Remove and return child at index — caller-owned; dtor WILL delete.
    QTreeWidgetItem takeChild(int index) {
        void* p = (cast(t_qp__qp_i)pFunQt[9676])(_wh, index);
        if (p is null) return null;
        return new QTreeWidgetItem(p, false);
    }

    /// Remove child (does NOT delete C++ object — ownership unclear; use takeChild instead).
    QTreeWidgetItem removeChild(QTreeWidgetItem c) {
        (cast(t_v__qp_qp)pFunQt[9677])(_wh, c.getWH());
        return this;
    }

    int indexOfChild(QTreeWidgetItem c) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9678])(_wh, c.getWH());
    }

    // ── Check state ──────────────────────────────────────────────────────────

    int checkState(int column = 0) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9679])(_wh, column);
    }
    QTreeWidgetItem setCheckState(int column, int state) {
        (cast(t_v__qp_i_i)pFunQt[9680])(_wh, column, state);
        return this;
    }

} // class QTreeWidgetItem

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTreeWidget.
@live class QTreeWidget : QTreeView {
public:
    /// Create QTreeWidget. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[9600])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// columnCount
    int columnCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9605])(_wh);
    }

    /// setColumnCount
    QTreeWidget setColumnCount(int columns) {
        (cast(t_v__qp_i)pFunQt[9606])(_wh, columns);
        return this;
    }

    /// invisibleRootItem
    void* invisibleRootItem() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9607])(_wh);
    }

    /// topLevelItem
    void* topLevelItem(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9608])(_wh, index);
    }

    /// topLevelItemCount
    int topLevelItemCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9609])(_wh);
    }

    /// insertTopLevelItem
    QTreeWidget insertTopLevelItem(int index, void* item) {
        (cast(t_v__qp_i_qp)pFunQt[9610])(_wh, index, item);
        return this;
    }

    /// addTopLevelItem
    QTreeWidget addTopLevelItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9611])(_wh, item);
        return this;
    }

    /// takeTopLevelItem
    void* takeTopLevelItem(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9612])(_wh, index);
    }

    /// indexOfTopLevelItem
    int indexOfTopLevelItem(void* item) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9613])(_wh, item);
    }

    /// headerItem
    void* headerItem() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9614])(_wh);
    }

    /// setHeaderItem
    QTreeWidget setHeaderItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9615])(_wh, item);
        return this;
    }

    /// setHeaderLabel
    QTreeWidget setHeaderLabel(string label) {
        auto _ws_label = toQString(label);
        (cast(t_v__qp_qp)pFunQt[9616])(_wh, _ws_label);
        (cast(t_v__qp)pFunQt[22])(_ws_label);
        return this;
    }

    /// Установить заголовки всех колонок сразу. Количество заголовков должно
    /// совпадать с columnCount() (или изменит columnCount автоматически).
    QTreeWidget setHeaderLabels(string[] labels) {
        void* wa = toQStringList(labels);
        (cast(t_v__qp_qp)pFunQt[9682])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    /// selectedItems — список выделенных QTreeWidgetItem*
    void*[] selectedItems() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[9681])(_wh));
    }

    /// currentItem
    void* currentItem() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9617])(_wh);
    }

    /// currentColumn
    int currentColumn() {
        return cast(int)(cast(t_i__qp)pFunQt[9618])(_wh);
    }

    /// setCurrentItem
    QTreeWidget setCurrentItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9619])(_wh, item);
        return this;
    }

    /// setCurrentItem
    QTreeWidget setCurrentItem(void* item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9620])(_wh, item, column);
        return this;
    }

    /// setCurrentItem
    QTreeWidget setCurrentItem(void* item, int column, int command) {
        (cast(t_v__qp_qp_i_i)pFunQt[9621])(_wh, item, column, command);
        return this;
    }

    /// itemAt
    void* itemAt(void* p) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[9622])(_wh, p);
    }

    /// itemAt
    void* itemAt(int x, int y) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[9623])(_wh, x, y);
    }

    /// visualItemRect
    DRect visualItemRect(void* item) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[9624])(_wh, item);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// sortColumn
    int sortColumn() {
        return cast(int)(cast(t_i__qp)pFunQt[9625])(_wh);
    }

    /// sortItems
    QTreeWidget sortItems(int column, int order) {
        (cast(t_v__qp_i_i)pFunQt[9626])(_wh, column, order);
        return this;
    }

    /// editItem
    QTreeWidget editItem(void* item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9627])(_wh, item, column);
        return this;
    }

    /// openPersistentEditor
    QTreeWidget openPersistentEditor(void* item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9628])(_wh, item, column);
        return this;
    }

    /// closePersistentEditor
    QTreeWidget closePersistentEditor(void* item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9629])(_wh, item, column);
        return this;
    }

    /// isPersistentEditorOpen
    bool isPersistentEditorOpen(void* item, int column) {
        return cast(bool)(cast(t_i__qp_qp_i)pFunQt[9630])(_wh, item, column);
    }

    /// itemWidget
    void* itemWidget(void* item, int column) {
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[9631])(_wh, item, column);
    }

    /// setItemWidget
    QTreeWidget setItemWidget(void* item, int column, void* widget) {
        (cast(t_v__qp_qp_i_qp)pFunQt[9632])(_wh, item, column, widget);
        return this;
    }

    /// removeItemWidget
    QTreeWidget removeItemWidget(void* item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9633])(_wh, item, column);
        return this;
    }

    /// isItemSelected
    bool isItemSelected(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9634])(_wh, item);
    }

    /// setItemSelected
    QTreeWidget setItemSelected(void* item, bool select) {
        (cast(t_v__qp_qp_i)pFunQt[9635])(_wh, item, select ? 1 : 0);
        return this;
    }

    /// isItemHidden
    bool isItemHidden(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9636])(_wh, item);
    }

    /// setItemHidden
    QTreeWidget setItemHidden(void* item, bool hide) {
        (cast(t_v__qp_qp_i)pFunQt[9637])(_wh, item, hide ? 1 : 0);
        return this;
    }

    /// isItemExpanded
    bool isItemExpanded(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9638])(_wh, item);
    }

    /// setItemExpanded
    QTreeWidget setItemExpanded(void* item, bool expand) {
        (cast(t_v__qp_qp_i)pFunQt[9639])(_wh, item, expand ? 1 : 0);
        return this;
    }

    /// isFirstItemColumnSpanned
    bool isFirstItemColumnSpanned(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9640])(_wh, item);
    }

    /// setFirstItemColumnSpanned
    QTreeWidget setFirstItemColumnSpanned(void* item, bool span) {
        (cast(t_v__qp_qp_i)pFunQt[9641])(_wh, item, span ? 1 : 0);
        return this;
    }

    /// itemAbove
    void* itemAbove(void* item) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[9642])(_wh, item);
    }

    /// itemBelow
    void* itemBelow(void* item) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[9643])(_wh, item);
    }

    /// scrollToItem
    QTreeWidget scrollToItem(void* item, int hint) {
        (cast(t_v__qp_qp_i)pFunQt[9645])(_wh, item, hint);
        return this;
    }

    /// expandItem
    QTreeWidget expandItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9646])(_wh, item);
        return this;
    }

    /// collapseItem
    QTreeWidget collapseItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9647])(_wh, item);
        return this;
    }

    /// clear
    QTreeWidget clear() {
        (cast(t_v__qp)pFunQt[9648])(_wh);
        return this;
    }

    // ── Typed overloads (QTreeWidgetItem) ───────────────────────────────────

    /// addTopLevelItem — Qt takes ownership; item.disown() called automatically.
    QTreeWidget addTopLevelItem(QTreeWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9611])(_wh, item.getWH());
        item.disown();
        return this;
    }

    /// insertTopLevelItem — Qt takes ownership.
    QTreeWidget insertTopLevelItem(int index, QTreeWidgetItem item) {
        (cast(t_v__qp_i_qp)pFunQt[9610])(_wh, index, item.getWH());
        item.disown();
        return this;
    }

    /// topLevelItem — returns Qt-owned wrapper.
    QTreeWidgetItem topLevelItemObj(int index) {
        return QTreeWidgetItem.wrap((cast(t_qp__qp_i)pFunQt[9608])(_wh, index));
    }

    /// takeTopLevelItem — returns caller-owned item; dtor WILL delete.
    QTreeWidgetItem takeTopLevelItemObj(int index) {
        void* p = (cast(t_qp__qp_i)pFunQt[9612])(_wh, index);
        if (p is null) return null;
        return new QTreeWidgetItem(p, false);
    }

    /// invisibleRootItem — returns Qt-owned wrapper.
    QTreeWidgetItem invisibleRootItemObj() {
        return QTreeWidgetItem.wrap((cast(t_qp__qp)pFunQt[9607])(_wh));
    }

    /// headerItem — returns Qt-owned wrapper.
    QTreeWidgetItem headerItemObj() {
        return QTreeWidgetItem.wrap((cast(t_qp__qp)pFunQt[9614])(_wh));
    }

    /// setHeaderItem (typed) — Qt takes ownership.
    QTreeWidget setHeaderItem(QTreeWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9615])(_wh, item.getWH());
        item.disown();
        return this;
    }

    /// currentItem — returns Qt-owned wrapper.
    QTreeWidgetItem currentItemObj() {
        return QTreeWidgetItem.wrap((cast(t_qp__qp)pFunQt[9617])(_wh));
    }

    /// setCurrentItem (typed).
    QTreeWidget setCurrentItem(QTreeWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9619])(_wh, item.getWH());
        return this;
    }

    /// setCurrentItem (typed, with column).
    QTreeWidget setCurrentItem(QTreeWidgetItem item, int column) {
        (cast(t_v__qp_qp_i)pFunQt[9620])(_wh, item.getWH(), column);
        return this;
    }

    /// indexOfTopLevelItem (typed).
    int indexOfTopLevelItem(QTreeWidgetItem item) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9613])(_wh, item.getWH());
    }

    /// itemAbove — returns Qt-owned wrapper.
    QTreeWidgetItem itemAboveObj(QTreeWidgetItem item) {
        return QTreeWidgetItem.wrap((cast(t_qp__qp_qp)pFunQt[9642])(_wh, item.getWH()));
    }

    /// itemBelow — returns Qt-owned wrapper.
    QTreeWidgetItem itemBelowObj(QTreeWidgetItem item) {
        return QTreeWidgetItem.wrap((cast(t_qp__qp_qp)pFunQt[9643])(_wh, item.getWH()));
    }

    /// visualItemRect (typed).
    DRect visualItemRect(QTreeWidgetItem item) {
        return visualItemRect(item.getWH());
    }

    /// scrollToItem (typed).
    QTreeWidget scrollToItem(QTreeWidgetItem item, int hint = 0) {
        (cast(t_v__qp_qp_i)pFunQt[9645])(_wh, item.getWH(), hint);
        return this;
    }

    /// expandItem (typed).
    QTreeWidget expandItem(QTreeWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9646])(_wh, item.getWH());
        return this;
    }

    /// collapseItem (typed).
    QTreeWidget collapseItem(QTreeWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9647])(_wh, item.getWH());
        return this;
    }

    /// isItemSelected (typed).
    bool isItemSelected(QTreeWidgetItem item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9634])(_wh, item.getWH());
    }

    /// setItemSelected (typed).
    QTreeWidget setItemSelected(QTreeWidgetItem item, bool select) {
        (cast(t_v__qp_qp_i)pFunQt[9635])(_wh, item.getWH(), select ? 1 : 0);
        return this;
    }

    /// isItemHidden (typed).
    bool isItemHidden(QTreeWidgetItem item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9636])(_wh, item.getWH());
    }

    /// setItemHidden (typed).
    QTreeWidget setItemHidden(QTreeWidgetItem item, bool hide) {
        (cast(t_v__qp_qp_i)pFunQt[9637])(_wh, item.getWH(), hide ? 1 : 0);
        return this;
    }

    /// isItemExpanded (typed).
    bool isItemExpanded(QTreeWidgetItem item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9638])(_wh, item.getWH());
    }

    /// setItemExpanded (typed).
    QTreeWidget setItemExpanded(QTreeWidgetItem item, bool expand) {
        (cast(t_v__qp_qp_i)pFunQt[9639])(_wh, item.getWH(), expand ? 1 : 0);
        return this;
    }

    // ── Signal connection methods ────────────────────────────────────────────
    /// onItemClicked: cb = extern(C) void function(void* dthis, int n, void* item, int col)
    QTreeWidget onItemClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9650])(_wh, cb, dthis);
        return this;
    }

    /// onItemDoubleClicked: cb = extern(C) void function(void* dthis, int n, void* item, int col)
    QTreeWidget onItemDoubleClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9651])(_wh, cb, dthis);
        return this;
    }

    /// onItemChanged: cb = extern(C) void function(void* dthis, int n, void* item, int col)
    QTreeWidget onItemChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9652])(_wh, cb, dthis);
        return this;
    }

    /// onItemActivated: cb = extern(C) void function(void* dthis, int n, void* item, int col)
    QTreeWidget onItemActivated(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9653])(_wh, cb, dthis);
        return this;
    }

    /// onItemExpanded: cb = extern(C) void function(void* dthis, int n, void* item)
    QTreeWidget onItemExpanded(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9654])(_wh, cb, dthis);
        return this;
    }

    /// onItemCollapsed: cb = extern(C) void function(void* dthis, int n, void* item)
    QTreeWidget onItemCollapsed(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9655])(_wh, cb, dthis);
        return this;
    }

    /// onCurrentItemChanged: cb = extern(C) void function(void* dthis, int n, void* current, void* previous)
    QTreeWidget onCurrentItemChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9656])(_wh, cb, dthis);
        return this;
    }

    /// onItemSelectionChanged: cb = extern(C) void function(void* dthis, int n)
    QTreeWidget onItemSelectionChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[9657])(_wh, cb, dthis);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QTreeWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[9649])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTreeWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTreeWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTreeWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTreeWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTreeWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTreeWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QTreeWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTreeWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QTreeWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QTreeWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QTreeWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QTreeWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QTreeWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QTreeWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTreeWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTreeWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QTreeWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QTreeWidget
