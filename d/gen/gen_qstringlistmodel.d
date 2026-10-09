/**
 * gen_qstringlistmodel.d — D wrapper for QStringListModel.
 * Module: QStringListModel  |  DLL: qte56_qmodelview.dll
 */
module gen_qstringlistmodel;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString, toQStringList, freeQStringList;
import gen_qobject : QObject;
import gen_qmodelindex : QModelIndex;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_i_qp"));   // void*(void*, int, int, void*) — index
mixin(generateAlias("i__qp_i_i_qp"));    // int(void*, int, int, void*) — removeRows/insertRows
mixin(generateAlias("i__qp_qp_i"));      // int(void*, void*, int) — data_i/flags
mixin(generateAlias("i__qp_qp_qp_i"));   // int(void*, void*, void*, int) — setData

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQStringListModel() {
    mixin(generateFunQt(24700, "qteQStringListModel_create",        "QStringListModel"));
    mixin(generateFunQt(24701, "qteQStringListModel_create_sl",     "QStringListModel"));
    mixin(generateFunQt(24702, "qteQStringListModel_delete",        "QStringListModel"));
    mixin(generateFunQt(24703, "qteQStringListModel_rowCount",      "QStringListModel"));
    mixin(generateFunQt(24713, "qteQStringListModel_index",         "QStringListModel"));
    mixin(generateFunQt(24704, "qteQStringListModel_data_s",        "QStringListModel"));
    mixin(generateFunQt(24705, "qteQStringListModel_data_i",        "QStringListModel"));
    mixin(generateFunQt(24706, "qteQStringListModel_setData_s",     "QStringListModel"));
    mixin(generateFunQt(24707, "qteQStringListModel_flags",         "QStringListModel"));
    mixin(generateFunQt(24708, "qteQStringListModel_setStringList", "QStringListModel"));
    mixin(generateFunQt(24709, "qteQStringListModel_stringList",    "QStringListModel"));
    mixin(generateFunQt(24710, "qteQStringListModel_removeRows",    "QStringListModel"));
    mixin(generateFunQt(24711, "qteQStringListModel_insertRows",    "QStringListModel"));
    mixin(generateFunQt(24712, "qteQStringListModel_sort",          "QStringListModel"));
}

static this() {
    registerModule("QStringListModel", "qte56_qmodelview.dll", &loadQStringListModel);
}

// ====================================================================
// Class wrapper
// ====================================================================

@live class QStringListModel : QObject {
public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[24700])(parent);
    }

    this(string[] strings, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto ws = toQStringList(strings);
        _wh = (cast(t_qp__qp_qp)pFunQt[24701])(ws, parent);
        freeQStringList(ws);
    }

    protected this(bool _noOp) { super(_noOp); }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[24702] !is null) {
            (cast(t_v__qp)pFunQt[24702])(_wh);
            _wh = null;
        }
    }

    // ── Dimensions / data ─────────────────────────────────────────────

    int rowCount(QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return cast(int)(cast(t_i__qp_qp)pFunQt[24703])(_wh, p);
    }

    QModelIndex index(int row, int col, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return QModelIndex.wrap((cast(t_qp__qp_i_i_qp)pFunQt[24713])(_wh, row, col, p));
    }

    string data_str(QModelIndex index, int role) {
        void* qs = (cast(t_qp__qp_qp_i)pFunQt[24704])(_wh, index.getPtr(), role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    int data_int(QModelIndex index, int role) {
        return cast(int)(cast(t_i__qp_qp_i)pFunQt[24705])(_wh, index.getPtr(), role);
    }

    bool setData(QModelIndex index, string value, int role) {
        auto ws = toQString(value);
        int r = (cast(t_i__qp_qp_qp_i)pFunQt[24706])(_wh, index.getPtr(), ws, role);
        (cast(t_v__qp)pFunQt[22])(ws);
        return r != 0;
    }

    int flags(QModelIndex index) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[24707])(_wh, index.getPtr());
    }

    // ── String list ───────────────────────────────────────────────────

    QStringListModel setStringList(string[] strings) {
        auto ws = toQStringList(strings);
        (cast(t_v__qp_qp)pFunQt[24708])(_wh, ws);
        freeQStringList(ws);
        return this;
    }

    string[] stringList() {
        void* qs = (cast(t_qp__qp)pFunQt[24709])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        import std.array : split;
        return (s.length == 0) ? [] : s.split("\x01");
    }

    // ── Rows / sort ───────────────────────────────────────────────────

    bool removeRows(int row, int count, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_i_qp)pFunQt[24710])(_wh, row, count, p) != 0;
    }

    bool insertRows(int row, int count, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return (cast(t_i__qp_i_i_qp)pFunQt[24711])(_wh, row, count, p) != 0;
    }

    QStringListModel sort(int col, int order) {
        (cast(t_v__qp_i_i)pFunQt[24712])(_wh, col, order);
        return this;
    }
}
