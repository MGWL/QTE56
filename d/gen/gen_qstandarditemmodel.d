/**
 * gen_qstandarditemmodel.d — D wrapper for QStandardItemModel.
 * Module: QStandardItemModel  |  DLL: qte56_qmodelview.dll
 *
 * QStandardItemModel — QObject, передаётся как heap-указатель.
 * D-объект владеет C++ объект, если не передан в Qt parent (disown()).
 */
module gen_qstandarditemmodel;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString, toQStringList, freeQStringList;
import gen_qobject : QObject;
import gen_qmodelindex : QModelIndex;
import gen_qstandarditem : QStandardItem;

// New aliases for this module:
mixin(generateAlias("qp__i_i_qp"));      // void*(int, int, void*) — create_rc
mixin(generateAlias("qp__qp_i_i_qp"));   // void*(void*, int, int, void*) — index
mixin(generateAlias("i__qp_i_qp"));      // int(void*, int, void*) — removeRow/removeColumn
mixin(generateAlias("i__qp_i_i_qp"));    // int(void*, int, int, void*) — removeRows/removeColumns
mixin(generateAlias("v__qp_i_i_qp"));    // void(void*, int, int, void*) — setItem
mixin(generateAlias("v__qp_i_qp"));      // void(void*, int, void*) — insertRow/insertColumn/setHeaderItem
mixin(generateAlias("qp__qp_qp_i"));     // void*(void*, void*, int) — data_s
mixin(generateAlias("i__qp_qp_i_i"));    // int(void*, void*, int, int) — setData_i
mixin(generateAlias("i__qp_qp_qp_i"));   // int(void*, void*, void*, int) — setData_s

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQStandardItemModel() {
    mixin(generateFunQt(24400, "qteQStandardItemModel_create",        "QStandardItemModel"));
    mixin(generateFunQt(24401, "qteQStandardItemModel_create_rc",     "QStandardItemModel"));
    mixin(generateFunQt(24402, "qteQStandardItemModel_delete",        "QStandardItemModel"));
    mixin(generateFunQt(24403, "qteQStandardItemModel_rowCount",      "QStandardItemModel"));
    mixin(generateFunQt(24404, "qteQStandardItemModel_columnCount",   "QStandardItemModel"));
    mixin(generateFunQt(24405, "qteQStandardItemModel_index",         "QStandardItemModel"));
    mixin(generateFunQt(24406, "qteQStandardItemModel_parent",        "QStandardItemModel"));
    mixin(generateFunQt(24407, "qteQStandardItemModel_data_i",        "QStandardItemModel"));
    mixin(generateFunQt(24408, "qteQStandardItemModel_data_s",        "QStandardItemModel"));
    mixin(generateFunQt(24409, "qteQStandardItemModel_setData_i",     "QStandardItemModel"));
    mixin(generateFunQt(24410, "qteQStandardItemModel_setData_s",     "QStandardItemModel"));
    mixin(generateFunQt(24411, "qteQStandardItemModel_flags",         "QStandardItemModel"));
    mixin(generateFunQt(24412, "qteQStandardItemModel_item",          "QStandardItemModel"));
    mixin(generateFunQt(24413, "qteQStandardItemModel_setItem",       "QStandardItemModel"));
    mixin(generateFunQt(24414, "qteQStandardItemModel_itemFromIndex", "QStandardItemModel"));
    mixin(generateFunQt(24415, "qteQStandardItemModel_indexFromItem", "QStandardItemModel"));
    mixin(generateFunQt(24416, "qteQStandardItemModel_invisibleRootItem","QStandardItemModel"));
    mixin(generateFunQt(24417, "qteQStandardItemModel_appendRow",     "QStandardItemModel"));
    mixin(generateFunQt(24418, "qteQStandardItemModel_appendColumn",  "QStandardItemModel"));
    mixin(generateFunQt(24419, "qteQStandardItemModel_insertRow",     "QStandardItemModel"));
    mixin(generateFunQt(24420, "qteQStandardItemModel_insertColumn",  "QStandardItemModel"));
    mixin(generateFunQt(24421, "qteQStandardItemModel_removeRow",     "QStandardItemModel"));
    mixin(generateFunQt(24422, "qteQStandardItemModel_removeRows",    "QStandardItemModel"));
    mixin(generateFunQt(24423, "qteQStandardItemModel_removeColumn",  "QStandardItemModel"));
    mixin(generateFunQt(24424, "qteQStandardItemModel_removeColumns", "QStandardItemModel"));
    mixin(generateFunQt(24425, "qteQStandardItemModel_clear",         "QStandardItemModel"));
    mixin(generateFunQt(24426, "qteQStandardItemModel_setHorizontalHeaderLabels","QStandardItemModel"));
    mixin(generateFunQt(24427, "qteQStandardItemModel_setVerticalHeaderLabels","QStandardItemModel"));
    mixin(generateFunQt(24428, "qteQStandardItemModel_horizontalHeaderItem","QStandardItemModel"));
    mixin(generateFunQt(24429, "qteQStandardItemModel_setHorizontalHeaderItem","QStandardItemModel"));
    mixin(generateFunQt(24430, "qteQStandardItemModel_verticalHeaderItem","QStandardItemModel"));
    mixin(generateFunQt(24431, "qteQStandardItemModel_setVerticalHeaderItem","QStandardItemModel"));
    mixin(generateFunQt(24432, "qteQStandardItemModel_sort",          "QStandardItemModel"));
    mixin(generateFunQt(24433, "qteQStandardItemModel_itemPrototype", "QStandardItemModel"));
    mixin(generateFunQt(24434, "qteQStandardItemModel_setItemPrototype","QStandardItemModel"));
}

static this() {
    registerModule("QStandardItemModel", "qte56_qmodelview.dll", &loadQStandardItemModel);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QStandardItemModel.
@live class QStandardItemModel : QObject {
public:
    /// Create QStandardItemModel. parent must be explicitly passed (null for top-level).
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[24400])(parent);
    }

    /// Create QStandardItemModel with rows x cols.
    this(int rows, int cols, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__i_i_qp)pFunQt[24401])(rows, cols, parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[24402] !is null) {
            (cast(t_v__qp)pFunQt[24402])(_wh);
            _wh = null;
        }
    }

    // ── Dimensions ────────────────────────────────────────────────────

    int rowCount(QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return cast(int)(cast(t_i__qp_qp)pFunQt[24403])(_wh, p);
    }

    int columnCount(QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return cast(int)(cast(t_i__qp_qp)pFunQt[24404])(_wh, p);
    }

    // ── Index access ──────────────────────────────────────────────────

    QModelIndex index(int row, int col, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return QModelIndex.wrap((cast(t_qp__qp_i_i_qp)pFunQt[24405])(_wh, row, col, p));
    }

    QModelIndex parent(QModelIndex index) {
        return QModelIndex.wrap((cast(t_qp__qp_qp)pFunQt[24406])(_wh, index.getPtr()));
    }

    // ── Data ──────────────────────────────────────────────────────────

    int data_int(QModelIndex index, int role) {
        return cast(int)(cast(t_i__qp_qp_i)pFunQt[24407])(_wh, index.getPtr(), role);
    }

    string data_str(QModelIndex index, int role) {
        void* qs = (cast(t_qp__qp_qp_i)pFunQt[24408])(_wh, index.getPtr(), role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    bool setData(QModelIndex index, int value, int role) {
        return (cast(t_i__qp_qp_i_i)pFunQt[24409])(_wh, index.getPtr(), value, role) != 0;
    }

    bool setData(QModelIndex index, string value, int role) {
        auto ws = toQString(value);
        int r = (cast(t_i__qp_qp_qp_i)pFunQt[24410])(_wh, index.getPtr(), ws, role);
        (cast(t_v__qp)pFunQt[22])(ws);
        return r != 0;
    }

    int flags(QModelIndex index) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[24411])(_wh, index.getPtr());
    }

    // ── Items ─────────────────────────────────────────────────────────

    QStandardItem item(int row, int col) {
        return QStandardItem.wrap((cast(t_qp__qp_i_i)pFunQt[24412])(_wh, row, col));
    }

    QStandardItemModel setItem(int row, int col, QStandardItem item) {
        (cast(t_v__qp_i_i_qp)pFunQt[24413])(_wh, row, col, item.getWH());
        item.disown();
        return this;
    }

    // t_v__qp_i_i_qp = void(void*, int, int, void*) — уже есть

    QStandardItem itemFromIndex(QModelIndex index) {
        return QStandardItem.wrap((cast(t_qp__qp_qp)pFunQt[24414])(_wh, index.getPtr()));
    }

    QModelIndex indexFromItem(QStandardItem item) {
        return QModelIndex.wrap((cast(t_qp__qp_qp)pFunQt[24415])(_wh, item.getWH()));
    }

    QStandardItem invisibleRootItem() {
        return QStandardItem.wrap((cast(t_qp__qp)pFunQt[24416])(_wh));
    }

    // ── Row/column operations ─────────────────────────────────────────

    QStandardItemModel appendRow(QStandardItem item) {
        (cast(t_v__qp_qp)pFunQt[24417])(_wh, item.getWH());
        item.disown();
        return this;
    }

    QStandardItemModel appendColumn(QStandardItem item) {
        (cast(t_v__qp_qp)pFunQt[24418])(_wh, item.getWH());
        item.disown();
        return this;
    }

    QStandardItemModel insertRow(int row, QStandardItem item) {
        (cast(t_v__qp_i_qp)pFunQt[24419])(_wh, row, item.getWH());
        item.disown();
        return this;
    }

    QStandardItemModel insertColumn(int col, QStandardItem item) {
        (cast(t_v__qp_i_qp)pFunQt[24420])(_wh, col, item.getWH());
        item.disown();
        return this;
    }

    bool removeRow(int row, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_qp)pFunQt[24421])(_wh, row, p) != 0;
    }

    bool removeRows(int row, int count, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_i_qp)pFunQt[24422])(_wh, row, count, p) != 0;
    }

    bool removeColumn(int col, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_qp)pFunQt[24423])(_wh, col, p) != 0;
    }

    bool removeColumns(int col, int count, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_i_qp)pFunQt[24424])(_wh, col, count, p) != 0;
    }

    QStandardItemModel clear() {
        (cast(t_v__qp)pFunQt[24425])(_wh);
        return this;
    }

    // ── Headers ───────────────────────────────────────────────────────

    QStandardItemModel setHorizontalHeaderLabels(string[] labels) {
        void* wa = toQStringList(labels);
        (cast(t_v__qp_qp)pFunQt[24426])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    QStandardItemModel setVerticalHeaderLabels(string[] labels) {
        void* wa = toQStringList(labels);
        (cast(t_v__qp_qp)pFunQt[24427])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    QStandardItem horizontalHeaderItem(int col) {
        return QStandardItem.wrap((cast(t_qp__qp_i)pFunQt[24428])(_wh, col));
    }

    QStandardItemModel setHorizontalHeaderItem(int col, QStandardItem item) {
        (cast(t_v__qp_i_qp)pFunQt[24429])(_wh, col, item.getWH());
        item.disown();
        return this;
    }

    QStandardItem verticalHeaderItem(int row) {
        return QStandardItem.wrap((cast(t_qp__qp_i)pFunQt[24430])(_wh, row));
    }

    QStandardItemModel setVerticalHeaderItem(int row, QStandardItem item) {
        (cast(t_v__qp_i_qp)pFunQt[24431])(_wh, row, item.getWH());
        item.disown();
        return this;
    }

    // ── Sort / prototype ──────────────────────────────────────────────

    QStandardItemModel sort(int col, int order) {
        (cast(t_v__qp_i_i)pFunQt[24432])(_wh, col, order);
        return this;
    }

    QStandardItem itemPrototype() {
        return QStandardItem.wrap((cast(t_qp__qp)pFunQt[24433])(_wh));
    }

    QStandardItemModel setItemPrototype(QStandardItem item) {
        (cast(t_v__qp_qp)pFunQt[24434])(_wh, item.getWH());
        item.disown();
        return this;
    }
}
