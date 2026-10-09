/**
 * gen_qlistwidget.d — D wrapper for QListWidget and QListWidgetItem.
 * Module: QListWidget | DLL: qte56_views.dll
 * MANUALLY WRITTEN
 *
 * Index blocks:
 *   41000–41014 : QListWidgetItem lifecycle + methods
 *   41020–41039 : QListWidget lifecycle + methods + event handler
 *   41050–41056 : QListWidget signal connections
 *
 * Signal callbacks (set once, called directly from C++):
 *   itemClicked/DoubleClicked/Activated/Changed(item):
 *       extern(C) void cb(void* dthis, int n, void* item)
 *   currentRowChanged(row):
 *       extern(C) void cb(void* dthis, int n, int row)
 *   currentTextChanged(text):
 *       extern(C) void cb(void* dthis, int n, void* qs_text)
 *   itemSelectionChanged():
 *       extern(C) void cb(void* dthis, int n)
 *
 * Qt::ItemFlags: Selectable=1, Editable=2, Enabled=32; Default=33
 * Qt::CheckState: Unchecked=0, PartiallyChecked=1, Checked=2
 */
module gen_qlistwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, ptrListFromQStr, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_qp__qp_qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString;
import gen_qabstractitemview : QAbstractItemView;

// Aliases not in gen_qcore:
mixin(generateAlias("v__qp_qp"));         // void(void*, void*)          — addItemW, scrollToItem
mixin(generateAlias("qp__qp_i_qp_i"));   // void*(void*, int, void*, int) — item_create_text
mixin(generateAlias("v__qp_i_qp_i"));    // void(void*, int, void*, int) — insertItem text
mixin(generateAlias("v__qp_i_qp"));      // void(void*, int, void*)      — insertItemW
mixin(generateAlias("i__qp_qp"));         // int(void*, void*)            — row(item)
mixin(generateAlias("qp__qp_i_i"));       // void*(void*, int, int)       — itemAt(x,y)
mixin(generateAlias("v__qp_qp_qp"));     // void(void*, void*, void*)    — signal connect

// ====================================================================
// Load function addresses at runtime
// ====================================================================

static this() { registerModule("QListWidget", "qte56_views.dll", &loadQListWidget); }

void loadQListWidget() {
    // ── QListWidgetItem ──────────────────────────────────────────────────────
    mixin(generateFunQt(7000, "qteQListWidgetItem_create",        "QListWidget"));
    mixin(generateFunQt(7001, "qteQListWidgetItem_create_text",   "QListWidget"));
    mixin(generateFunQt(7002, "qteQListWidgetItem_delete",        "QListWidget"));
    mixin(generateFunQt(7003, "qteQListWidgetItem_text",          "QListWidget"));
    mixin(generateFunQt(7004, "qteQListWidgetItem_setText",       "QListWidget"));
    mixin(generateFunQt(7005, "qteQListWidgetItem_isSelected",    "QListWidget"));
    mixin(generateFunQt(7006, "qteQListWidgetItem_setSelected",   "QListWidget"));
    mixin(generateFunQt(7007, "qteQListWidgetItem_checkState",    "QListWidget"));
    mixin(generateFunQt(7008, "qteQListWidgetItem_setCheckState", "QListWidget"));
    mixin(generateFunQt(7009, "qteQListWidgetItem_flags",         "QListWidget"));
    mixin(generateFunQt(7010, "qteQListWidgetItem_setFlags",      "QListWidget"));
    mixin(generateFunQt(7011, "qteQListWidgetItem_setIcon",       "QListWidget"));
    mixin(generateFunQt(7012, "qteQListWidgetItem_toolTip",       "QListWidget"));
    mixin(generateFunQt(7013, "qteQListWidgetItem_setToolTip",    "QListWidget"));
    mixin(generateFunQt(7014, "qteQListWidgetItem_type",          "QListWidget"));
    // ── QListWidget ──────────────────────────────────────────────────────────
    mixin(generateFunQt(7015, "qteQListWidget_create",            "QListWidget"));
    mixin(generateFunQt(7016, "qteQListWidget_delete",            "QListWidget"));
    mixin(generateFunQt(7017, "qteQListWidget_addItem",           "QListWidget"));
    mixin(generateFunQt(7018, "qteQListWidget_insertItem",        "QListWidget"));
    mixin(generateFunQt(7019, "qteQListWidget_addItemW",          "QListWidget"));
    mixin(generateFunQt(7020, "qteQListWidget_insertItemW",       "QListWidget"));
    mixin(generateFunQt(7021, "qteQListWidget_count",             "QListWidget"));
    mixin(generateFunQt(7022, "qteQListWidget_item",              "QListWidget"));
    mixin(generateFunQt(7023, "qteQListWidget_row",               "QListWidget"));
    mixin(generateFunQt(7024, "qteQListWidget_currentRow",        "QListWidget"));
    mixin(generateFunQt(7025, "qteQListWidget_setCurrentRow",     "QListWidget"));
    mixin(generateFunQt(7026, "qteQListWidget_currentItem",       "QListWidget"));
    mixin(generateFunQt(7027, "qteQListWidget_takeItem",          "QListWidget"));
    mixin(generateFunQt(7028, "qteQListWidget_clear",             "QListWidget"));
    mixin(generateFunQt(7029, "qteQListWidget_sortItems",         "QListWidget"));
    mixin(generateFunQt(7030, "qteQListWidget_isSortingEnabled",  "QListWidget"));
    mixin(generateFunQt(7031, "qteQListWidget_setSortingEnabled", "QListWidget"));
    mixin(generateFunQt(7032, "qteQListWidget_itemAt",            "QListWidget"));
    mixin(generateFunQt(7033, "qteQListWidget_scrollToItem",      "QListWidget"));
    mixin(generateFunQt(7034, "qteQListWidget_setEventHandler",   "QListWidget"));
    // ── Signals ──────────────────────────────────────────────────────────────
    mixin(generateFunQt(7035, "qteQListWidget_connectItemClicked",          "QListWidget"));
    mixin(generateFunQt(7036, "qteQListWidget_connectItemDoubleClicked",    "QListWidget"));
    mixin(generateFunQt(7037, "qteQListWidget_connectItemChanged",          "QListWidget"));
    mixin(generateFunQt(7038, "qteQListWidget_connectCurrentRowChanged",    "QListWidget"));
    mixin(generateFunQt(7039, "qteQListWidget_connectCurrentTextChanged",   "QListWidget"));
    mixin(generateFunQt(7040, "qteQListWidget_connectItemSelectionChanged", "QListWidget"));
    mixin(generateFunQt(7041, "qteQListWidget_connectItemActivated",        "QListWidget"));
    mixin(generateFunQt(7042, "qteQListWidget_selectedItems",               "QListWidget"));
}

// ====================================================================
// QListWidgetItem
// ====================================================================

/// D wrapper for a single QListWidgetItem.
/// Items are Qt-owned once added to a QListWidget.
@live class QListWidgetItem {
    void* _ptr;
    bool  _qt_owned;

protected:
    /// Internal: wrap existing pointer without creating a C++ object.
    this(void* ptr, bool qtOwned) {
        _ptr = ptr;
        _qt_owned = qtOwned;
    }

public:
    /// Create standalone item (not in any list).
    this() {
        _ptr = (cast(t_qp__qp_i)pFunQt[7000])(null, 0);
        _qt_owned = false;
    }

    /// Create item with text, optionally add to a list immediately.
    /// listwidget: QListWidget._wh or null
    this(string text, void* listwidget = null, int type = 0) {
        auto _ws = toQString(text);
        _ptr = (cast(t_qp__qp_qp_i)pFunQt[7001])(
            _ws, listwidget, type);
        _qt_owned = (listwidget !is null);
    }

    /// Wrap existing Qt-owned item (do not delete in dtor).
    static QListWidgetItem wrap(void* ptr) {
        if (ptr is null) return null;
        return new QListWidgetItem(ptr, true);
    }

    ~this() {
        if (!_qt_owned && _ptr !is null && pFunQt[7002] !is null) {
            (cast(t_v__qp)pFunQt[7002])(_ptr);
            _ptr = null;
        }
    }

    void* getPtr() { return _ptr; }
    /// Alias for compatibility with other classes.
    void* getWH()  { return _ptr; }
    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }

    // ── Text ──────────────────────────────────────────────────────────────────
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[7003])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }
    QListWidgetItem setText(string t) {
        auto _ws = toQString(t);
        (cast(t_v__qp_qp)pFunQt[7004])(_ptr, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── Selection ────────────────────────────────────────────────────────────
    bool isSelected() { return cast(bool)(cast(t_i__qp)pFunQt[7005])(_ptr); }
    QListWidgetItem setSelected(bool v) { (cast(t_v__qp_i)pFunQt[7006])(_ptr, v ? 1 : 0); return this; }

    // ── Check state ──────────────────────────────────────────────────────────
    int checkState() { return (cast(t_i__qp)pFunQt[7007])(_ptr); }
    QListWidgetItem setCheckState(int s) { (cast(t_v__qp_i)pFunQt[7008])(_ptr, s); return this; }

    // ── Flags ────────────────────────────────────────────────────────────────
    int flags() { return (cast(t_i__qp)pFunQt[7009])(_ptr); }
    QListWidgetItem setFlags(int f) { (cast(t_v__qp_i)pFunQt[7010])(_ptr, f); return this; }

    // ── Icon ─────────────────────────────────────────────────────────────────
    /// Pass QIcon.getPtr() as icon.
    QListWidgetItem setIcon(void* icon) { (cast(t_v__qp_qp)pFunQt[7011])(_ptr, icon); return this; }

    // ── Tooltip ──────────────────────────────────────────────────────────────
    string toolTip() {
        void* _qs = (cast(t_qp__qp)pFunQt[7012])(_ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }
    QListWidgetItem setToolTip(string t) {
        auto _ws = toQString(t);
        (cast(t_v__qp_qp)pFunQt[7013])(_ptr, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    int type() { return (cast(t_i__qp)pFunQt[7014])(_ptr); }

} // QListWidgetItem


// ====================================================================
// QListWidget
// ====================================================================

/// D wrapper for QListWidget (a list of selectable items).
@live class QListWidget : QAbstractItemView {
public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[7015])(parent);
    }

    protected this(bool _noOp) { super(_noOp); }

    static QListWidget wrap(void* wh) {
        auto w = new QListWidget(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[7016] !is null) {
            (cast(t_v__qp)pFunQt[7016])(_wh);
            _wh = null;
        }
    }

    // ── Add items ─────────────────────────────────────────────────────────────

    /// Add text item to the end of the list.
    QListWidget addItem(string text) {
        auto _ws = toQString(text);
        (cast(t_v__qp_qp)pFunQt[7017])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// Добавить несколько текстовых элементов сразу.
    QListWidget addItems(string[] items) {
        foreach (s; items) addItem(s);
        return this;
    }

    /// Insert text item at given row.
    QListWidget insertItem(int row, string text) {
        auto _ws = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[7018])(_wh, row, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// Add QListWidgetItem object (widget takes ownership).
    QListWidget addItem(QListWidgetItem item) {
        item._qt_owned = true;
        (cast(t_v__qp_qp)pFunQt[7019])(_wh, item.getPtr());
        return this;
    }

    /// Insert QListWidgetItem object at row (widget takes ownership).
    QListWidget insertItem(int row, QListWidgetItem item) {
        item._qt_owned = true;
        (cast(t_v__qp_i_qp)pFunQt[7020])(_wh, row, item.getPtr());
        return this;
    }

    // ── Item access ───────────────────────────────────────────────────────────

    /// Number of items.
    int count() { return (cast(t_i__qp)pFunQt[7021])(_wh); }

    /// Raw item pointer at row (Qt-owned — do not delete).
    void* itemPtr(int row) { return (cast(t_qp__qp_i)pFunQt[7022])(_wh, row); }

    /// Typed item at row — Qt-owned wrapper (dtor does NOT delete).
    QListWidgetItem item(int row) {
        return QListWidgetItem.wrap((cast(t_qp__qp_i)pFunQt[7022])(_wh, row));
    }

    /// Convenience: get text of item at row.
    string itemText(int row) {
        void* ptr = itemPtr(row);
        if (ptr is null) return "";
        void* _qs = (cast(t_qp__qp)pFunQt[7003])(ptr);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Get the row of an item (raw pointer).
    int row(void* item) { return (cast(t_i__qp_qp)pFunQt[7023])(_wh, item); }

    /// Get the row of a typed item.
    int row(QListWidgetItem item) { return (cast(t_i__qp_qp)pFunQt[7023])(_wh, item.getPtr()); }

    /// Currently selected row (-1 if none).
    int currentRow() { return (cast(t_i__qp)pFunQt[7024])(_wh); }

    /// Set selected row.
    QListWidget setCurrentRow(int row) { (cast(t_v__qp_i)pFunQt[7025])(_wh, row); return this; }

    /// Raw pointer to current item (Qt-owned).
    void* currentItemPtr() { return (cast(t_qp__qp)pFunQt[7026])(_wh); }

    /// Typed current item — Qt-owned wrapper.
    QListWidgetItem currentItem() {
        return QListWidgetItem.wrap((cast(t_qp__qp)pFunQt[7026])(_wh));
    }

    /// Remove item at row and return raw pointer (caller owns — must delete).
    void* takeItemPtr(int row) { return (cast(t_qp__qp_i)pFunQt[7027])(_wh, row); }

    /// Remove item at row and return typed wrapper (caller-owned — dtor WILL delete).
    QListWidgetItem takeItem(int row) {
        void* ptr = (cast(t_qp__qp_i)pFunQt[7027])(_wh, row);
        if (ptr is null) return null;
        return new QListWidgetItem(ptr, false);
    }

    /// Delete item at row (takes then deletes).
    QListWidget deleteItem(int row) {
        void* ptr = takeItemPtr(row);
        if (ptr !is null)
            (cast(t_v__qp)pFunQt[7002])(ptr);
        return this;
    }

    /// Remove all items.
    QListWidget clear() { (cast(t_v__qp)pFunQt[7028])(_wh); return this; }

    // ── Sorting ───────────────────────────────────────────────────────────────

    /// Sort items. order: 0=Ascending, 1=Descending.
    QListWidget sortItems(int order = 0) { (cast(t_v__qp_i)pFunQt[7029])(_wh, order); return this; }
    bool isSortingEnabled() { return cast(bool)(cast(t_i__qp)pFunQt[7030])(_wh); }
    QListWidget setSortingEnabled(bool e) { (cast(t_v__qp_i)pFunQt[7031])(_wh, e ? 1 : 0); return this; }

    // ── Navigation ────────────────────────────────────────────────────────────

    /// Get item at pixel coords (null if none).
    void* itemAtPtr(int x, int y) { return (cast(t_qp__qp_i_i)pFunQt[7032])(_wh, x, y); }

    /// Scroll to make item visible (raw).
    QListWidget scrollToItem(void* item) { (cast(t_v__qp_qp)pFunQt[7033])(_wh, item); return this; }
    /// Scroll to make item visible (typed).
    QListWidget scrollToItem(QListWidgetItem item) { (cast(t_v__qp_qp)pFunQt[7033])(_wh, item.getPtr()); return this; }

    // ── Signals ───────────────────────────────────────────────────────────────

    /// Connect itemClicked signal.
    /// cb: extern(C) void function(void* dthis, int n, void* item_ptr)
    QListWidget onItemClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7035])(_wh, cb, dthis);
        return this;
    }

    /// Connect itemDoubleClicked signal.
    QListWidget onItemDoubleClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7036])(_wh, cb, dthis);
        return this;
    }

    /// Connect itemChanged signal (fires when checkbox/text changes).
    QListWidget onItemChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7037])(_wh, cb, dthis);
        return this;
    }

    /// Connect currentRowChanged signal.
    /// cb: extern(C) void function(void* dthis, int n, int row)
    QListWidget onCurrentRowChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7038])(_wh, cb, dthis);
        return this;
    }

    /// Connect currentTextChanged signal.
    /// cb: extern(C) void function(void* dthis, int n, void* qs_text)
    /// Use fromQString(qs_text) to get the string value.
    QListWidget onCurrentTextChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7039])(_wh, cb, dthis);
        return this;
    }

    /// Connect itemSelectionChanged signal (fires on any selection change).
    /// cb: extern(C) void function(void* dthis, int n)
    QListWidget onItemSelectionChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7040])(_wh, cb, dthis);
        return this;
    }

    /// Connect itemActivated signal (double-click or Enter key).
    QListWidget onItemActivated(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[7041])(_wh, cb, dthis);
        return this;
    }

    /// selectedItems — список выделенных QListWidgetItem*
    void*[] selectedItems() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[7042])(_wh));
    }

    // ── Event handlers (override QWidget) ────────────────────────────────────

    /// Set event handler. id: 1-17 (same as QWidget).
    override QListWidget setEventHandler(int id, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[7034])(_wh, id, cb, dthis);
        return this;
    }

    override QListWidget onMousePress(void* cb, void* dthis = null)    { setEventHandler(1,  cb, dthis); return this; }
    override QListWidget onMouseRelease(void* cb, void* dthis = null)  { setEventHandler(2,  cb, dthis); return this; }
    override QListWidget onMouseDoubleClick(void* cb, void* dthis = null) { setEventHandler(3,  cb, dthis); return this; }
    override QListWidget onMouseMove(void* cb, void* dthis = null)     { setEventHandler(4,  cb, dthis); return this; }
    override QListWidget onKeyPress(void* cb, void* dthis = null)      { setEventHandler(5,  cb, dthis); return this; }
    override QListWidget onKeyRelease(void* cb, void* dthis = null)    { setEventHandler(6,  cb, dthis); return this; }
    override QListWidget onResize(void* cb, void* dthis = null)        { setEventHandler(7,  cb, dthis); return this; }
    override QListWidget onMove(void* cb, void* dthis = null)          { setEventHandler(8,  cb, dthis); return this; }
    override QListWidget onClose(void* cb, void* dthis = null)         { setEventHandler(9,  cb, dthis); return this; }
    override QListWidget onShow(void* cb, void* dthis = null)          { setEventHandler(10, cb, dthis); return this; }
    override QListWidget onHide(void* cb, void* dthis = null)          { setEventHandler(11, cb, dthis); return this; }
    override QListWidget onEnter(void* cb, void* dthis = null)         { setEventHandler(12, cb, dthis); return this; }
    override QListWidget onLeave(void* cb, void* dthis = null)         { setEventHandler(13, cb, dthis); return this; }
    override QListWidget onWheel(void* cb, void* dthis = null)         { setEventHandler(14, cb, dthis); return this; }
    override QListWidget onFocusIn(void* cb, void* dthis = null)       { setEventHandler(15, cb, dthis); return this; }
    override QListWidget onFocusOut(void* cb, void* dthis = null)      { setEventHandler(16, cb, dthis); return this; }
    override QListWidget onContextMenu(void* cb, void* dthis = null)   { setEventHandler(17, cb, dthis); return this; }

} // QListWidget
