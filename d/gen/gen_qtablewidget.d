/**
 * gen_qtablewidget.d — GENERATED wrapper for QTableWidget.
 * Module: QTableWidget  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtablewidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, freeQStringList, ptrListFromQStr, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString, toQStringList;
import gen_qtableview : QTableView;
import gen_qfont : QFont;
import gen_qicon : QIcon;
import gen_qbrush : QBrush;

// New aliases for this module:
mixin(generateAlias("qp__qp_i"));    // void* function(void*, int) — for tableItem(text)
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_i_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i"));
mixin(generateAlias("v__qp_i_i_qp"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTableWidget() {
    mixin(generateFunQt(9200, "qteQTableWidget_create", "QTableWidget"));
    mixin(generateFunQt(9201, "qteQTableWidget_delete", "QTableWidget"));
    mixin(generateFunQt(9205, "qteQTableWidget_setRowCount", "QTableWidget"));
    mixin(generateFunQt(9206, "qteQTableWidget_rowCount", "QTableWidget"));
    mixin(generateFunQt(9207, "qteQTableWidget_setColumnCount", "QTableWidget"));
    mixin(generateFunQt(9208, "qteQTableWidget_columnCount", "QTableWidget"));
    mixin(generateFunQt(9209, "qteQTableWidget_row", "QTableWidget"));
    mixin(generateFunQt(9210, "qteQTableWidget_column", "QTableWidget"));
    mixin(generateFunQt(9211, "qteQTableWidget_item", "QTableWidget"));
    mixin(generateFunQt(9212, "qteQTableWidget_setItem", "QTableWidget"));
    mixin(generateFunQt(9213, "qteQTableWidget_takeItem", "QTableWidget"));
    mixin(generateFunQt(9214, "qteQTableWidget_verticalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9215, "qteQTableWidget_setVerticalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9216, "qteQTableWidget_takeVerticalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9217, "qteQTableWidget_horizontalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9218, "qteQTableWidget_setHorizontalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9219, "qteQTableWidget_takeHorizontalHeaderItem", "QTableWidget"));
    mixin(generateFunQt(9220, "qteQTableWidget_currentRow", "QTableWidget"));
    mixin(generateFunQt(9221, "qteQTableWidget_currentColumn", "QTableWidget"));
    mixin(generateFunQt(9222, "qteQTableWidget_currentItem", "QTableWidget"));
    mixin(generateFunQt(9223, "qteQTableWidget_setCurrentItem_p", "QTableWidget"));
    mixin(generateFunQt(9224, "qteQTableWidget_setCurrentItem_pp", "QTableWidget"));
    mixin(generateFunQt(9225, "qteQTableWidget_setCurrentCell_ii", "QTableWidget"));
    mixin(generateFunQt(9226, "qteQTableWidget_setCurrentCell_iip", "QTableWidget"));
    mixin(generateFunQt(9227, "qteQTableWidget_sortItems", "QTableWidget"));
    mixin(generateFunQt(9230, "qteQTableWidget_editItem", "QTableWidget"));
    mixin(generateFunQt(9231, "qteQTableWidget_openPersistentEditor", "QTableWidget"));
    mixin(generateFunQt(9232, "qteQTableWidget_closePersistentEditor", "QTableWidget"));
    mixin(generateFunQt(9233, "qteQTableWidget_isPersistentEditorOpen", "QTableWidget"));
    mixin(generateFunQt(9234, "qteQTableWidget_cellWidget", "QTableWidget"));
    mixin(generateFunQt(9235, "qteQTableWidget_setCellWidget", "QTableWidget"));
    mixin(generateFunQt(9236, "qteQTableWidget_removeCellWidget", "QTableWidget"));
    mixin(generateFunQt(9237, "qteQTableWidget_isItemSelected", "QTableWidget"));
    mixin(generateFunQt(9238, "qteQTableWidget_setItemSelected", "QTableWidget"));
    mixin(generateFunQt(9239, "qteQTableWidget_visualRow", "QTableWidget"));
    mixin(generateFunQt(9240, "qteQTableWidget_visualColumn", "QTableWidget"));
    mixin(generateFunQt(9241, "qteQTableWidget_itemAt_p", "QTableWidget"));
    mixin(generateFunQt(9242, "qteQTableWidget_itemAt_ii", "QTableWidget"));
    mixin(generateFunQt(9243, "qteQTableWidget_visualItemRect", "QTableWidget"));
    mixin(generateFunQt(9244, "qteQTableWidget_itemPrototype", "QTableWidget"));
    mixin(generateFunQt(9245, "qteQTableWidget_setItemPrototype", "QTableWidget"));
    mixin(generateFunQt(9246, "qteQTableWidget_scrollToItem", "QTableWidget"));
    mixin(generateFunQt(9247, "qteQTableWidget_insertRow", "QTableWidget"));
    mixin(generateFunQt(9248, "qteQTableWidget_insertColumn", "QTableWidget"));
    mixin(generateFunQt(9249, "qteQTableWidget_removeRow", "QTableWidget"));
    mixin(generateFunQt(9250, "qteQTableWidget_removeColumn", "QTableWidget"));
    mixin(generateFunQt(9251, "qteQTableWidget_clear", "QTableWidget"));
    mixin(generateFunQt(9252, "qteQTableWidget_clearContents", "QTableWidget"));
    mixin(generateFunQt(9253, "qteQTableWidget_setEventHandler", "QTableWidget"));
    // ── QTableWidgetItem helpers ──────────────────────────────────────────────
    mixin(generateFunQt(9254, "qteQTableWidgetItem_create", "QTableWidget"));
    mixin(generateFunQt(9255, "qteQTableWidgetItem_create_empty", "QTableWidget"));
    mixin(generateFunQt(9256, "qteQTableWidgetItem_delete", "QTableWidget"));
    mixin(generateFunQt(9257, "qteQTableWidgetItem_text", "QTableWidget"));
    mixin(generateFunQt(9258, "qteQTableWidgetItem_setText", "QTableWidget"));
    mixin(generateFunQt(9259, "qteQTableWidgetItem_flags", "QTableWidget"));
    mixin(generateFunQt(9260, "qteQTableWidgetItem_setFlags", "QTableWidget"));
    mixin(generateFunQt(9261, "qteQTableWidgetItem_textAlignment", "QTableWidget"));
    mixin(generateFunQt(9262, "qteQTableWidgetItem_setTextAlignment", "QTableWidget"));
    mixin(generateFunQt(9263, "qteQTableWidgetItem_setCheckState", "QTableWidget"));
    mixin(generateFunQt(9264, "qteQTableWidgetItem_checkState", "QTableWidget"));
    mixin(generateFunQt(9265, "qteQTableWidgetItem_setToolTip", "QTableWidget"));
    mixin(generateFunQt(9266, "qteQTableWidgetItem_toolTip", "QTableWidget"));
    mixin(generateFunQt(9267, "qteQTableWidgetItem_setStatusTip", "QTableWidget"));
    mixin(generateFunQt(9268, "qteQTableWidgetItem_statusTip", "QTableWidget"));
    mixin(generateFunQt(9269, "qteQTableWidgetItem_setWhatsThis", "QTableWidget"));
    mixin(generateFunQt(9270, "qteQTableWidgetItem_whatsThis", "QTableWidget"));
    mixin(generateFunQt(9271, "qteQTableWidgetItem_setFont", "QTableWidget"));
    mixin(generateFunQt(9272, "qteQTableWidgetItem_font", "QTableWidget"));
    mixin(generateFunQt(9273, "qteQTableWidgetItem_setIcon", "QTableWidget"));
    mixin(generateFunQt(9274, "qteQTableWidgetItem_icon", "QTableWidget"));
    mixin(generateFunQt(9275, "qteQTableWidgetItem_setBackground", "QTableWidget"));
    mixin(generateFunQt(9276, "qteQTableWidgetItem_background", "QTableWidget"));
    mixin(generateFunQt(9277, "qteQTableWidgetItem_setForeground", "QTableWidget"));
    mixin(generateFunQt(9278, "qteQTableWidgetItem_foreground", "QTableWidget"));
    mixin(generateFunQt(9279, "qteQTableWidgetItem_setSelected", "QTableWidget"));
    mixin(generateFunQt(9280, "qteQTableWidgetItem_isSelected", "QTableWidget"));
    mixin(generateFunQt(9281, "qteQTableWidgetItem_row", "QTableWidget"));
    mixin(generateFunQt(9282, "qteQTableWidgetItem_column", "QTableWidget"));
    mixin(generateFunQt(9283, "qteQTableWidgetItem_setData_i", "QTableWidget"));
    mixin(generateFunQt(9284, "qteQTableWidgetItem_data_i", "QTableWidget"));
    mixin(generateFunQt(9285, "qteQTableWidgetItem_setData_s", "QTableWidget"));
    mixin(generateFunQt(9286, "qteQTableWidgetItem_data_s", "QTableWidget"));
    mixin(generateFunQt(9287, "qteQTableWidgetItem_clone", "QTableWidget"));
    mixin(generateFunQt(19837, "qteQTableWidget_setHorizontalHeaderLabels", "QTableWidget"));
    mixin(generateFunQt(19838, "qteQTableWidget_setVerticalHeaderLabels",   "QTableWidget"));
    mixin(generateFunQt(19841, "qteQTableWidget_selectedItems",             "QTableWidget"));
}

static this() {
    registerModule("QTableWidget", "qte56_views.dll", &loadQTableWidget);
}

// ====================================================================
// QTableWidgetItem class
// ====================================================================

/**
 * D wrapper for QTableWidgetItem.
 *
 * Ownership rules (same as QWidget children):
 *   - new QTableWidgetItem("text") — D owns it, dtor deletes.
 *   - After tw.setItem(row, col, item) — Qt owns it; D dtor does NOT delete.
 *     The typed overload setItem(row, col, QTableWidgetItem) calls disown() automatically.
 *   - QTableWidgetItem.wrap(ptr) — wraps a Qt-owned pointer (from item()), dtor does NOT delete.
 *   - takeItemObj(row, col) — returns caller-owned item; dtor WILL delete.
 */
@live class QTableWidgetItem {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    /// Internal: wrap an existing Qt pointer.
    this(void* ptr, bool qtOwned) {
        _wh = ptr;
        _qt_owned = qtOwned;
    }

public:
    /// Create with text.
    this(string text) {
        auto ws = toQString(text);
        _wh = (cast(t_qp__qp)pFunQt[9254])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        _qt_owned = false;
    }

    /// Create empty item.
    this() {
        _wh = (cast(t_qp__qp)pFunQt[9255])(null);
        _qt_owned = false;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[9256] !is null) {
            (cast(t_v__qp)pFunQt[9256])(_wh);
            _wh = null;
        }
    }

    /// Get the underlying Qt pointer.
    void* getWH() const { return cast(void*)_wh; }

    /// Mark as Qt-owned — destructor will NOT delete.
    /// Call manually after passing to the void*-based setItem().
    void disown() { _qt_owned = true; }

    /// Wrap an existing Qt-owned pointer (e.g. returned by item()).
    /// Returned object is Qt-owned: dtor will NOT delete.
    static QTableWidgetItem wrap(void* ptr) {
        if (ptr is null) return null;
        return new QTableWidgetItem(ptr, true);
    }

    // ── Methods ──────────────────────────────────────────────────────────────

    string text() {
        void* qs = (cast(t_qp__qp)pFunQt[9257])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTableWidgetItem setText(string text) {
        auto ws = toQString(text);
        (cast(t_v__qp_qp)pFunQt[9258])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    int flags() {
        return cast(int)(cast(t_i__qp)pFunQt[9259])(_wh);
    }

    QTableWidgetItem setFlags(int flags) {
        (cast(t_v__qp_i)pFunQt[9260])(_wh, flags);
        return this;
    }

    int textAlignment() {
        return cast(int)(cast(t_i__qp)pFunQt[9261])(_wh);
    }

    QTableWidgetItem setTextAlignment(int alignment) {
        (cast(t_v__qp_i)pFunQt[9262])(_wh, alignment);
        return this;
    }

    QTableWidgetItem setCheckState(int state) {
        (cast(t_v__qp_i)pFunQt[9263])(_wh, state);
        return this;
    }

    int checkState() {
        return cast(int)(cast(t_i__qp)pFunQt[9264])(_wh);
    }

    QTableWidgetItem setToolTip(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[9265])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string toolTip() {
        void* qs = (cast(t_qp__qp)pFunQt[9266])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTableWidgetItem setStatusTip(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[9267])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string statusTip() {
        void* qs = (cast(t_qp__qp)pFunQt[9268])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTableWidgetItem setWhatsThis(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[9269])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string whatsThis() {
        void* qs = (cast(t_qp__qp)pFunQt[9270])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTableWidgetItem setFont(QFont f) {
        (cast(t_v__qp_qp)pFunQt[9271])(_wh, f.getWH());
        return this;
    }

    QFont font() {
        return QFont.wrap((cast(t_qp__qp)pFunQt[9272])(_wh));
    }

    QTableWidgetItem setIcon(QIcon i) {
        (cast(t_v__qp_qp)pFunQt[9273])(_wh, i.getPtr());
        return this;
    }

    QIcon icon() {
        return QIcon.wrap((cast(t_qp__qp)pFunQt[9274])(_wh));
    }

    QTableWidgetItem setBackground(QBrush b) {
        (cast(t_v__qp_qp)pFunQt[9275])(_wh, b.getWH());
        return this;
    }

    QBrush background() {
        return QBrush.wrap((cast(t_qp__qp)pFunQt[9276])(_wh));
    }

    QTableWidgetItem setForeground(QBrush b) {
        (cast(t_v__qp_qp)pFunQt[9277])(_wh, b.getWH());
        return this;
    }

    QBrush foreground() {
        return QBrush.wrap((cast(t_qp__qp)pFunQt[9278])(_wh));
    }

    QTableWidgetItem setSelected(int sel) {
        (cast(t_v__qp_i)pFunQt[9279])(_wh, sel);
        return this;
    }

    bool isSelected() {
        return cast(bool)(cast(t_i__qp)pFunQt[9280])(_wh);
    }

    int row() {
        return cast(int)(cast(t_i__qp)pFunQt[9281])(_wh);
    }

    int column() {
        return cast(int)(cast(t_i__qp)pFunQt[9282])(_wh);
    }

    QTableWidgetItem setData(int role, int value) {
        (cast(t_v__qp_i_i)pFunQt[9283])(_wh, role, value);
        return this;
    }

    int data_int(int role) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9284])(_wh, role);
    }

    QTableWidgetItem setData(int role, string value) {
        auto ws = toQString(value);
        (cast(t_v__qp_i_qp)pFunQt[9285])(_wh, role, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string data_str(int role) {
        void* qs = (cast(t_qp__qp_i)pFunQt[9286])(_wh, role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QTableWidgetItem clone() {
        void* p = (cast(t_qp__qp)pFunQt[9287])(_wh);
        if (p is null) return null;
        return new QTableWidgetItem(p, false);
    }

} // class QTableWidgetItem

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTableWidget.
@live class QTableWidget : QTableView {
public:
    /// Create QTableWidget. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[9200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setRowCount
    QTableWidget setRowCount(int rows) {
        (cast(t_v__qp_i)pFunQt[9205])(_wh, rows);
        return this;
    }

    /// rowCount
    int rowCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9206])(_wh);
    }

    /// setColumnCount
    QTableWidget setColumnCount(int columns) {
        (cast(t_v__qp_i)pFunQt[9207])(_wh, columns);
        return this;
    }

    /// columnCount
    int columnCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9208])(_wh);
    }

    /// row
    int row(void* item) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9209])(_wh, item);
    }

    /// column
    int column(void* item) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9210])(_wh, item);
    }

    /// item
    void* item(int row, int column) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[9211])(_wh, row, column);
    }

    /// setItem (raw void*)
    QTableWidget setItem(int row, int column, void* item) {
        (cast(t_v__qp_i_i_qp)pFunQt[9212])(_wh, row, column, item);
        return this;
    }

    /// setItem (typed — Qt takes ownership, item.disown() called automatically)
    QTableWidget setItem(int row, int column, QTableWidgetItem item) {
        (cast(t_v__qp_i_i_qp)pFunQt[9212])(_wh, row, column, item.getWH());
        item.disown();
        return this;
    }

    /// takeItem (raw void* — caller owns, must delete manually)
    void* takeItem(int row, int column) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[9213])(_wh, row, column);
    }

    /// Get item as typed wrapper (Qt-owned — do NOT delete, use QTableWidgetItem.wrap()).
    QTableWidgetItem itemObj(int row, int column) {
        return QTableWidgetItem.wrap((cast(t_qp__qp_i_i)pFunQt[9211])(_wh, row, column));
    }

    /// takeItem as typed wrapper — caller owns, dtor will delete.
    QTableWidgetItem takeItemObj(int row, int column) {
        void* p = (cast(t_qp__qp_i_i)pFunQt[9213])(_wh, row, column);
        if (p is null) return null;
        return new QTableWidgetItem(p, false);
    }

    /// verticalHeaderItem
    void* verticalHeaderItem(int row) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9214])(_wh, row);
    }

    /// setVerticalHeaderItem (raw)
    QTableWidget setVerticalHeaderItem(int row, void* item) {
        (cast(t_v__qp_i_qp)pFunQt[9215])(_wh, row, item);
        return this;
    }

    /// setVerticalHeaderItem (typed)
    QTableWidget setVerticalHeaderItem(int row, QTableWidgetItem item) {
        (cast(t_v__qp_i_qp)pFunQt[9215])(_wh, row, item.getWH());
        item.disown();
        return this;
    }

    /// takeVerticalHeaderItem
    void* takeVerticalHeaderItem(int row) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9216])(_wh, row);
    }

    /// horizontalHeaderItem
    void* horizontalHeaderItem(int column) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9217])(_wh, column);
    }

    /// setHorizontalHeaderItem (raw)
    QTableWidget setHorizontalHeaderItem(int column, void* item) {
        (cast(t_v__qp_i_qp)pFunQt[9218])(_wh, column, item);
        return this;
    }

    /// setHorizontalHeaderItem (typed)
    QTableWidget setHorizontalHeaderItem(int column, QTableWidgetItem item) {
        (cast(t_v__qp_i_qp)pFunQt[9218])(_wh, column, item.getWH());
        item.disown();
        return this;
    }

    /// Установить заголовки всех столбцов сразу (удобная версия через QStringList).
    QTableWidget setHorizontalHeaderLabels(string[] labels) {
        void* wa = toQStringList(labels);
        (cast(t_v__qp_qp)pFunQt[19837])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    /// Установить заголовки всех строк сразу (удобная версия через QStringList).
    QTableWidget setVerticalHeaderLabels(string[] labels) {
        void* wa = toQStringList(labels);
        (cast(t_v__qp_qp)pFunQt[19838])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    /// selectedItems — список выделенных QTableWidgetItem*
    void*[] selectedItems() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[19841])(_wh));
    }

    /// takeHorizontalHeaderItem
    void* takeHorizontalHeaderItem(int column) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[9219])(_wh, column);
    }

    /// currentRow
    int currentRow() {
        return cast(int)(cast(t_i__qp)pFunQt[9220])(_wh);
    }

    /// currentColumn
    int currentColumn() {
        return cast(int)(cast(t_i__qp)pFunQt[9221])(_wh);
    }

    /// currentItem (raw)
    void* currentItem() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9222])(_wh);
    }

    /// currentItem (typed — Qt-owned wrapper)
    QTableWidgetItem currentItemObj() {
        return QTableWidgetItem.wrap((cast(t_qp__qp)pFunQt[9222])(_wh));
    }

    /// setCurrentItem (raw)
    QTableWidget setCurrentItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9223])(_wh, item);
        return this;
    }

    /// setCurrentItem (typed)
    QTableWidget setCurrentItem(QTableWidgetItem item) {
        (cast(t_v__qp_qp)pFunQt[9223])(_wh, item.getWH());
        return this;
    }

    /// setCurrentItem (raw, with command)
    QTableWidget setCurrentItem(void* item, int command) {
        (cast(t_v__qp_qp_i)pFunQt[9224])(_wh, item, command);
        return this;
    }

    /// setCurrentItem (typed, with command)
    QTableWidget setCurrentItem(QTableWidgetItem item, int command) {
        (cast(t_v__qp_qp_i)pFunQt[9224])(_wh, item.getWH(), command);
        return this;
    }

    /// setCurrentCell
    QTableWidget setCurrentCell(int row, int column) {
        (cast(t_v__qp_i_i)pFunQt[9225])(_wh, row, column);
        return this;
    }

    /// setCurrentCell
    QTableWidget setCurrentCell(int row, int column, int command) {
        (cast(t_v__qp_i_i_i)pFunQt[9226])(_wh, row, column, command);
        return this;
    }

    /// sortItems
    QTableWidget sortItems(int column, int order) {
        (cast(t_v__qp_i_i)pFunQt[9227])(_wh, column, order);
        return this;
    }

    /// editItem
    QTableWidget editItem(void* item) {
        (cast(t_v__qp_qp)pFunQt[9230])(_wh, item);
        return this;
    }

    /// openPersistentEditor
    QTableWidget openPersistentEditor(void* item) {
        (cast(t_v__qp_qp)pFunQt[9231])(_wh, item);
        return this;
    }

    /// closePersistentEditor
    QTableWidget closePersistentEditor(void* item) {
        (cast(t_v__qp_qp)pFunQt[9232])(_wh, item);
        return this;
    }

    /// isPersistentEditorOpen
    bool isPersistentEditorOpen(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9233])(_wh, item);
    }

    /// cellWidget
    void* cellWidget(int row, int column) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[9234])(_wh, row, column);
    }

    /// setCellWidget
    QTableWidget setCellWidget(int row, int column, void* widget) {
        (cast(t_v__qp_i_i_qp)pFunQt[9235])(_wh, row, column, widget);
        return this;
    }

    /// removeCellWidget
    QTableWidget removeCellWidget(int row, int column) {
        (cast(t_v__qp_i_i)pFunQt[9236])(_wh, row, column);
        return this;
    }

    /// isItemSelected
    bool isItemSelected(void* item) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[9237])(_wh, item);
    }

    /// setItemSelected
    QTableWidget setItemSelected(void* item, bool select) {
        (cast(t_v__qp_qp_i)pFunQt[9238])(_wh, item, select ? 1 : 0);
        return this;
    }

    /// visualRow
    int visualRow(int logicalRow) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9239])(_wh, logicalRow);
    }

    /// visualColumn
    int visualColumn(int logicalColumn) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9240])(_wh, logicalColumn);
    }

    /// itemAt
    void* itemAt(void* p) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[9241])(_wh, p);
    }

    /// itemAt
    void* itemAt(int x, int y) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[9242])(_wh, x, y);
    }

    /// visualItemRect
    DRect visualItemRect(void* item) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[9243])(_wh, item);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// itemPrototype
    void* itemPrototype() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9244])(_wh);
    }

    /// setItemPrototype
    QTableWidget setItemPrototype(void* item) {
        (cast(t_v__qp_qp)pFunQt[9245])(_wh, item);
        return this;
    }

    /// scrollToItem
    QTableWidget scrollToItem(void* item, int hint) {
        (cast(t_v__qp_qp_i)pFunQt[9246])(_wh, item, hint);
        return this;
    }

    /// insertRow
    QTableWidget insertRow(int row) {
        (cast(t_v__qp_i)pFunQt[9247])(_wh, row);
        return this;
    }

    /// insertColumn
    QTableWidget insertColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9248])(_wh, column);
        return this;
    }

    /// removeRow
    QTableWidget removeRow(int row) {
        (cast(t_v__qp_i)pFunQt[9249])(_wh, row);
        return this;
    }

    /// removeColumn
    QTableWidget removeColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9250])(_wh, column);
        return this;
    }

    /// clear
    QTableWidget clear() {
        (cast(t_v__qp)pFunQt[9251])(_wh);
        return this;
    }

    /// clearContents
    QTableWidget clearContents() {
        (cast(t_v__qp)pFunQt[9252])(_wh);
        return this;
    }

    // Signal itemPressed — unsupported parameter types
    // Signal itemClicked — unsupported parameter types
    // Signal itemDoubleClicked — unsupported parameter types
    // Signal itemActivated — unsupported parameter types
    // Signal itemEntered — unsupported parameter types
    // Signal itemChanged — unsupported parameter types
    // Signal currentItemChanged — unsupported parameter types
    /// Connect signal itemSelectionChanged → ESlot
    QTableWidget connect_itemSelectionChanged(ESlot eslot) {
        connectQt(_wh, "itemSelectionChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal cellPressed → ESlot
    QTableWidget connect_cellPressed(ESlot eslot) {
        connectQt(_wh, "cellPressed(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal cellClicked → ESlot
    QTableWidget connect_cellClicked(ESlot eslot) {
        connectQt(_wh, "cellClicked(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal cellDoubleClicked → ESlot
    QTableWidget connect_cellDoubleClicked(ESlot eslot) {
        connectQt(_wh, "cellDoubleClicked(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal cellActivated → ESlot
    QTableWidget connect_cellActivated(ESlot eslot) {
        connectQt(_wh, "cellActivated(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal cellEntered → ESlot
    QTableWidget connect_cellEntered(ESlot eslot) {
        connectQt(_wh, "cellEntered(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal cellChanged → ESlot
    QTableWidget connect_cellChanged(ESlot eslot) {
        connectQt(_wh, "cellChanged(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    // Signal currentCellChanged — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QTableWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[9253])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTableWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTableWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTableWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTableWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTableWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTableWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QTableWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTableWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QTableWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QTableWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QTableWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QTableWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QTableWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QTableWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTableWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTableWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QTableWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QTableWidget

// ── QTableWidgetItem standalone helpers ──────────────────────────────────────
/// Create a new QTableWidgetItem with text. Caller owns the item until it is
/// passed to setItem() (after which QTableWidget takes ownership).
void* tableItem(string text) {
    auto ws = toQString(text);
    return (cast(t_qp__qp)pFunQt[9254])(ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Create an empty QTableWidgetItem.
void* tableItemEmpty() {
    return (cast(t_qp__qp)pFunQt[9255])(null);  // dummy null arg
}

/// Delete a QTableWidgetItem not owned by any table (e.g., after takeItem).
void tableItemDelete(void* item) {
    (cast(t_v__qp)pFunQt[9256])(item);
}

/// Get text of a QTableWidgetItem.
string tableItemText(void* item) {
    import gen_qcore : fromQString;
    void* qs = (cast(t_qp__qp)pFunQt[9257])(item);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}

/// Set text of a QTableWidgetItem.
void tableItemSetText(void* item, string text) {
    auto ws = toQString(text);
    (cast(t_v__qp_qp)pFunQt[9258])(item, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Get item flags (Qt::ItemFlags as int).
int tableItemFlags(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9259])(item);
}

/// Set item flags.
void tableItemSetFlags(void* item, int flags) {
    (cast(t_v__qp_i)pFunQt[9260])(item, flags);
}

/// Get text alignment.
int tableItemTextAlignment(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9261])(item);
}

/// Set text alignment.
void tableItemSetTextAlignment(void* item, int alignment) {
    (cast(t_v__qp_i)pFunQt[9262])(item, alignment);
}

/// Set check state (Qt::CheckState).
void tableItemSetCheckState(void* item, int state) {
    (cast(t_v__qp_i)pFunQt[9263])(item, state);
}

/// Get check state (Qt::CheckState).
int tableItemCheckState(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9264])(item);
}

/// Set tool tip.
void tableItemSetToolTip(void* item, string s) {
    auto ws = toQString(s);
    (cast(t_v__qp_qp)pFunQt[9265])(item, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Get tool tip.
string tableItemToolTip(void* item) {
    void* qs = (cast(t_qp__qp)pFunQt[9266])(item);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}

/// Set status tip.
void tableItemSetStatusTip(void* item, string s) {
    auto ws = toQString(s);
    (cast(t_v__qp_qp)pFunQt[9267])(item, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Get status tip.
string tableItemStatusTip(void* item) {
    void* qs = (cast(t_qp__qp)pFunQt[9268])(item);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}

/// Set "what's this" text.
void tableItemSetWhatsThis(void* item, string s) {
    auto ws = toQString(s);
    (cast(t_v__qp_qp)pFunQt[9269])(item, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Get "what's this" text.
string tableItemWhatsThis(void* item) {
    void* qs = (cast(t_qp__qp)pFunQt[9270])(item);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}

/// Set font (pass QFont.getWH()).
void tableItemSetFont(void* item, void* font) {
    (cast(t_v__qp_qp)pFunQt[9271])(item, font);
}

/// Set icon (pass QIcon.getPtr()).
void tableItemSetIcon(void* item, void* icon) {
    (cast(t_v__qp_qp)pFunQt[9273])(item, icon);
}

/// Set background brush (pass QBrush.getWH()).
void tableItemSetBackground(void* item, void* brush) {
    (cast(t_v__qp_qp)pFunQt[9275])(item, brush);
}

/// Set foreground brush (pass QBrush.getWH()).
void tableItemSetForeground(void* item, void* brush) {
    (cast(t_v__qp_qp)pFunQt[9277])(item, brush);
}

/// Set selected flag.
void tableItemSetSelected(void* item, int sel) {
    (cast(t_v__qp_i)pFunQt[9279])(item, sel);
}

/// Get selected flag.
int tableItemIsSelected(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9280])(item);
}

/// Get row (-1 if not in table).
int tableItemRow(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9281])(item);
}

/// Get column (-1 if not in table).
int tableItemColumn(void* item) {
    return cast(int)(cast(t_i__qp)pFunQt[9282])(item);
}

/// Set integer user data.
void tableItemSetData_i(void* item, int role, int value) {
    (cast(t_v__qp_i_i)pFunQt[9283])(item, role, value);
}

/// Get integer user data.
int tableItemData_i(void* item, int role) {
    return cast(int)(cast(t_i__qp_i)pFunQt[9284])(item, role);
}

/// Set string user data.
void tableItemSetData_s(void* item, int role, string s) {
    auto ws = toQString(s);
    (cast(t_v__qp_i_qp)pFunQt[9285])(item, role, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}

/// Get string user data.
string tableItemData_s(void* item, int role) {
    void* qs = (cast(t_qp__qp_i)pFunQt[9286])(item, role);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}
