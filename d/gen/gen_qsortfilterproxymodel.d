/**
 * gen_qsortfilterproxymodel.d — D wrapper for QSortFilterProxyModel.
 * Module: QSortFilterProxyModel  |  DLL: qte56_qmodelview.dll
 */
module gen_qsortfilterproxymodel;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString;
import gen_qobject : QObject;
import gen_qmodelindex : QModelIndex;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_i_qp"));   // void*(void*, int, int, void*) — index
mixin(generateAlias("i__qp_i_qp"));      // int(void*, int, void*) — removeRow/removeColumn
mixin(generateAlias("i__qp_i_i_qp"));    // int(void*, int, int, void*) — removeRows
mixin(generateAlias("i__qp_qp_i"));      // int(void*, void*, int) — data_i/flags

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSortFilterProxyModel() {
    mixin(generateFunQt(24600, "qteQSortFilterProxyModel_create",        "QSortFilterProxyModel"));
    mixin(generateFunQt(24601, "qteQSortFilterProxyModel_delete",        "QSortFilterProxyModel"));
    mixin(generateFunQt(24602, "qteQSortFilterProxyModel_setSourceModel","QSortFilterProxyModel"));
    mixin(generateFunQt(24603, "qteQSortFilterProxyModel_sourceModel",   "QSortFilterProxyModel"));
    mixin(generateFunQt(24604, "qteQSortFilterProxyModel_mapToSource",   "QSortFilterProxyModel"));
    mixin(generateFunQt(24605, "qteQSortFilterProxyModel_mapFromSource", "QSortFilterProxyModel"));
    mixin(generateFunQt(24606, "qteQSortFilterProxyModel_setFilterFixedString","QSortFilterProxyModel"));
    mixin(generateFunQt(24607, "qteQSortFilterProxyModel_setFilterWildcard","QSortFilterProxyModel"));
    mixin(generateFunQt(24608, "qteQSortFilterProxyModel_setFilterRegExp","QSortFilterProxyModel"));
    mixin(generateFunQt(24609, "qteQSortFilterProxyModel_filterRegExp",  "QSortFilterProxyModel"));
    mixin(generateFunQt(24610, "qteQSortFilterProxyModel_setFilterCaseSensitivity","QSortFilterProxyModel"));
    mixin(generateFunQt(24611, "qteQSortFilterProxyModel_filterCaseSensitivity","QSortFilterProxyModel"));
    mixin(generateFunQt(24612, "qteQSortFilterProxyModel_setSortCaseSensitivity","QSortFilterProxyModel"));
    mixin(generateFunQt(24613, "qteQSortFilterProxyModel_sortCaseSensitivity","QSortFilterProxyModel"));
    mixin(generateFunQt(24614, "qteQSortFilterProxyModel_setFilterRole", "QSortFilterProxyModel"));
    mixin(generateFunQt(24615, "qteQSortFilterProxyModel_filterRole",    "QSortFilterProxyModel"));
    mixin(generateFunQt(24616, "qteQSortFilterProxyModel_setSortRole",   "QSortFilterProxyModel"));
    mixin(generateFunQt(24617, "qteQSortFilterProxyModel_sortRole",      "QSortFilterProxyModel"));
    mixin(generateFunQt(24618, "qteQSortFilterProxyModel_setDynamicSortFilter","QSortFilterProxyModel"));
    mixin(generateFunQt(24619, "qteQSortFilterProxyModel_dynamicSortFilter","QSortFilterProxyModel"));
    mixin(generateFunQt(24620, "qteQSortFilterProxyModel_setFilterKeyColumn","QSortFilterProxyModel"));
    mixin(generateFunQt(24621, "qteQSortFilterProxyModel_filterKeyColumn","QSortFilterProxyModel"));
    mixin(generateFunQt(24622, "qteQSortFilterProxyModel_invalidate",    "QSortFilterProxyModel"));
    mixin(generateFunQt(24623, "qteQSortFilterProxyModel_sort",          "QSortFilterProxyModel"));
    mixin(generateFunQt(24624, "qteQSortFilterProxyModel_rowCount",      "QSortFilterProxyModel"));
    mixin(generateFunQt(24625, "qteQSortFilterProxyModel_columnCount",   "QSortFilterProxyModel"));
    mixin(generateFunQt(24626, "qteQSortFilterProxyModel_index",         "QSortFilterProxyModel"));
    mixin(generateFunQt(24627, "qteQSortFilterProxyModel_parent",        "QSortFilterProxyModel"));
    mixin(generateFunQt(24628, "qteQSortFilterProxyModel_data_s",        "QSortFilterProxyModel"));
    mixin(generateFunQt(24629, "qteQSortFilterProxyModel_data_i",        "QSortFilterProxyModel"));
    mixin(generateFunQt(24630, "qteQSortFilterProxyModel_flags",         "QSortFilterProxyModel"));
}

static this() {
    registerModule("QSortFilterProxyModel", "qte56_qmodelview.dll", &loadQSortFilterProxyModel);
}

// ====================================================================
// Class wrapper
// ====================================================================

@live class QSortFilterProxyModel : QObject {
public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[24600])(parent);
    }

    protected this(bool _noOp) { super(_noOp); }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[24601] !is null) {
            (cast(t_v__qp)pFunQt[24601])(_wh);
            _wh = null;
        }
    }

    // ── Source model ──────────────────────────────────────────────────

    QSortFilterProxyModel setSourceModel(QObject model) {
        (cast(t_v__qp_qp)pFunQt[24602])(_wh, model.getWH());
        return this;
    }

    void* sourceModel() {
        return (cast(t_qp__qp)pFunQt[24603])(_wh);
    }

    // ── Mapping ───────────────────────────────────────────────────────

    QModelIndex mapToSource(QModelIndex index) {
        return QModelIndex.wrap((cast(t_qp__qp_qp)pFunQt[24604])(_wh, index.getPtr()));
    }

    QModelIndex mapFromSource(QModelIndex index) {
        return QModelIndex.wrap((cast(t_qp__qp_qp)pFunQt[24605])(_wh, index.getPtr()));
    }

    // ── Filter ────────────────────────────────────────────────────────

    QSortFilterProxyModel setFilterFixedString(string pattern) {
        auto ws = toQString(pattern);
        (cast(t_v__qp_qp)pFunQt[24606])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    QSortFilterProxyModel setFilterWildcard(string pattern) {
        auto ws = toQString(pattern);
        (cast(t_v__qp_qp)pFunQt[24607])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    QSortFilterProxyModel setFilterRegExp(string pattern) {
        auto ws = toQString(pattern);
        (cast(t_v__qp_qp)pFunQt[24608])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string filterRegExp() {
        void* qs = (cast(t_qp__qp)pFunQt[24609])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QSortFilterProxyModel setFilterCaseSensitivity(int cs) { (cast(t_v__qp_i)pFunQt[24610])(_wh, cs); return this; }
    int  filterCaseSensitivity()          { return cast(int)(cast(t_i__qp)pFunQt[24611])(_wh); }

    QSortFilterProxyModel setSortCaseSensitivity(int cs)   { (cast(t_v__qp_i)pFunQt[24612])(_wh, cs); return this; }
    int  sortCaseSensitivity()            { return cast(int)(cast(t_i__qp)pFunQt[24613])(_wh); }

    QSortFilterProxyModel setFilterRole(int role)          { (cast(t_v__qp_i)pFunQt[24614])(_wh, role); return this; }
    int  filterRole()                     { return cast(int)(cast(t_i__qp)pFunQt[24615])(_wh); }

    QSortFilterProxyModel setSortRole(int role)            { (cast(t_v__qp_i)pFunQt[24616])(_wh, role); return this; }
    int  sortRole()                       { return cast(int)(cast(t_i__qp)pFunQt[24617])(_wh); }

    QSortFilterProxyModel setDynamicSortFilter(bool e)     { (cast(t_v__qp_i)pFunQt[24618])(_wh, e ? 1 : 0); return this; }
    bool dynamicSortFilter()              { return (cast(t_i__qp)pFunQt[24619])(_wh) != 0; }

    QSortFilterProxyModel setFilterKeyColumn(int col)      { (cast(t_v__qp_i)pFunQt[24620])(_wh, col); return this; }
    int  filterKeyColumn()                { return cast(int)(cast(t_i__qp)pFunQt[24621])(_wh); }

    QSortFilterProxyModel invalidate()                     { (cast(t_v__qp)pFunQt[24622])(_wh); return this; }

    // ── Sort ──────────────────────────────────────────────────────────

    QSortFilterProxyModel sort(int col, int order) {
        (cast(t_v__qp_i_i)pFunQt[24623])(_wh, col, order);
        return this;
    }

    // ── Dimensions / index / data ─────────────────────────────────────

    int rowCount(QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return cast(int)(cast(t_i__qp_qp)pFunQt[24624])(_wh, p);
    }

    int columnCount(QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return cast(int)(cast(t_i__qp_qp)pFunQt[24625])(_wh, p);
    }

    QModelIndex index(int row, int col, QModelIndex parent = null) {
        void* p = (parent is null) ? null : parent.getPtr();
        return QModelIndex.wrap((cast(t_qp__qp_i_i_qp)pFunQt[24626])(_wh, row, col, p));
    }

    QModelIndex parent(QModelIndex index) {
        return QModelIndex.wrap((cast(t_qp__qp_qp)pFunQt[24627])(_wh, index.getPtr()));
    }

    string data_str(QModelIndex index, int role) {
        void* qs = (cast(t_qp__qp_qp_i)pFunQt[24628])(_wh, index.getPtr(), role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    int data_int(QModelIndex index, int role) {
        return cast(int)(cast(t_i__qp_qp_i)pFunQt[24629])(_wh, index.getPtr(), role);
    }

    int flags(QModelIndex index) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[24630])(_wh, index.getPtr());
    }
}
