/**
 * gen_qstandarditem.d — D wrapper for QStandardItem (value type).
 * Module: QStandardItem  |  DLL: qte56_qmodelview.dll
 *
 * QStandardItem — value-класс, передаётся как heap-указатель.
 * D-объект владеет C++ QStandardItem и удаляет его в dtor,
 * если item не был передан в модель/родителя (disown()).
 */
module gen_qstandarditem;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString;
import gen_qfont : QFont;
import gen_qicon : QIcon;
import gen_qbrush : QBrush;
import gen_qmodelindex : QModelIndex;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_i"));      // void*(void*, int, int) — child
mixin(generateAlias("v__qp_i_i"));       // void(void*, int, int) — setData_i
mixin(generateAlias("v__qp_i_qp"));      // void(void*, int, void*) — setData_s
mixin(generateAlias("v__qp_i_i_qp"));    // void(void*, int, int, void*) — setChild

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQStandardItem() {
    mixin(generateFunQt(24250, "qteQStandardItem_create",        "QStandardItem"));
    mixin(generateFunQt(24251, "qteQStandardItem_create_text",   "QStandardItem"));
    mixin(generateFunQt(24252, "qteQStandardItem_delete",        "QStandardItem"));
    mixin(generateFunQt(24253, "qteQStandardItem_text",          "QStandardItem"));
    mixin(generateFunQt(24254, "qteQStandardItem_setText",       "QStandardItem"));
    mixin(generateFunQt(24255, "qteQStandardItem_icon",          "QStandardItem"));
    mixin(generateFunQt(24256, "qteQStandardItem_setIcon",       "QStandardItem"));
    mixin(generateFunQt(24257, "qteQStandardItem_toolTip",       "QStandardItem"));
    mixin(generateFunQt(24258, "qteQStandardItem_setToolTip",    "QStandardItem"));
    mixin(generateFunQt(24259, "qteQStandardItem_statusTip",     "QStandardItem"));
    mixin(generateFunQt(24260, "qteQStandardItem_setStatusTip",  "QStandardItem"));
    mixin(generateFunQt(24261, "qteQStandardItem_whatsThis",     "QStandardItem"));
    mixin(generateFunQt(24262, "qteQStandardItem_setWhatsThis",  "QStandardItem"));
    mixin(generateFunQt(24263, "qteQStandardItem_font",          "QStandardItem"));
    mixin(generateFunQt(24264, "qteQStandardItem_setFont",       "QStandardItem"));
    mixin(generateFunQt(24265, "qteQStandardItem_background",    "QStandardItem"));
    mixin(generateFunQt(24266, "qteQStandardItem_setBackground", "QStandardItem"));
    mixin(generateFunQt(24267, "qteQStandardItem_foreground",    "QStandardItem"));
    mixin(generateFunQt(24268, "qteQStandardItem_setForeground", "QStandardItem"));
    mixin(generateFunQt(24269, "qteQStandardItem_checkState",    "QStandardItem"));
    mixin(generateFunQt(24270, "qteQStandardItem_setCheckState", "QStandardItem"));
    mixin(generateFunQt(24271, "qteQStandardItem_isCheckable",   "QStandardItem"));
    mixin(generateFunQt(24272, "qteQStandardItem_setCheckable",  "QStandardItem"));
    mixin(generateFunQt(24273, "qteQStandardItem_isEditable",    "QStandardItem"));
    mixin(generateFunQt(24274, "qteQStandardItem_setEditable",   "QStandardItem"));
    mixin(generateFunQt(24275, "qteQStandardItem_isSelectable",  "QStandardItem"));
    mixin(generateFunQt(24276, "qteQStandardItem_setSelectable", "QStandardItem"));
    mixin(generateFunQt(24277, "qteQStandardItem_isEnabled",     "QStandardItem"));
    mixin(generateFunQt(24278, "qteQStandardItem_setEnabled",    "QStandardItem"));
    mixin(generateFunQt(24279, "qteQStandardItem_data_i",        "QStandardItem"));
    mixin(generateFunQt(24280, "qteQStandardItem_data_s",        "QStandardItem"));
    mixin(generateFunQt(24281, "qteQStandardItem_setData_i",     "QStandardItem"));
    mixin(generateFunQt(24282, "qteQStandardItem_setData_s",     "QStandardItem"));
    mixin(generateFunQt(24283, "qteQStandardItem_row",           "QStandardItem"));
    mixin(generateFunQt(24284, "qteQStandardItem_column",        "QStandardItem"));
    mixin(generateFunQt(24285, "qteQStandardItem_parent",        "QStandardItem"));
    mixin(generateFunQt(24286, "qteQStandardItem_child",         "QStandardItem"));
    mixin(generateFunQt(24287, "qteQStandardItem_setChild",      "QStandardItem"));
    mixin(generateFunQt(24288, "qteQStandardItem_removeRow",     "QStandardItem"));
    mixin(generateFunQt(24289, "qteQStandardItem_removeRows",    "QStandardItem"));
    mixin(generateFunQt(24290, "qteQStandardItem_removeColumn",  "QStandardItem"));
    mixin(generateFunQt(24291, "qteQStandardItem_removeColumns", "QStandardItem"));
    mixin(generateFunQt(24292, "qteQStandardItem_appendRow",     "QStandardItem"));
    mixin(generateFunQt(24293, "qteQStandardItem_appendColumn",  "QStandardItem"));
    mixin(generateFunQt(24294, "qteQStandardItem_insertRow",     "QStandardItem"));
    mixin(generateFunQt(24295, "qteQStandardItem_insertColumn",  "QStandardItem"));
    mixin(generateFunQt(24296, "qteQStandardItem_rowCount",      "QStandardItem"));
    mixin(generateFunQt(24297, "qteQStandardItem_columnCount",   "QStandardItem"));
    mixin(generateFunQt(24298, "qteQStandardItem_hasChildren",   "QStandardItem"));
    mixin(generateFunQt(24299, "qteQStandardItem_index",         "QStandardItem"));
    mixin(generateFunQt(24300, "qteQStandardItem_model",         "QStandardItem"));
    mixin(generateFunQt(24301, "qteQStandardItem_clone",         "QStandardItem"));
    mixin(generateFunQt(24302, "qteQStandardItem_type",          "QStandardItem"));
}

static this() {
    registerModule("QStandardItem", "qte56_qmodelview.dll", &loadQStandardItem);
}

// ====================================================================
// Class wrapper — value type
// ====================================================================

/// D wrapper for Qt value type QStandardItem.
/// D owns the C++ heap copy; dtor deletes it unless disown() was called.
@live class QStandardItem {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create empty item.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[24250])();
    }

    /// Create item with text.
    this(string text) {
        _qt_owned = false;
        auto ws = toQString(text);
        _wh = (cast(t_qp__qp)pFunQt[24251])(ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }

    /// Private ctor for wrap().
    private this(void* ptr, bool qtOwned) {
        _wh = ptr;
        _qt_owned = qtOwned;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[24252] !is null) {
            (cast(t_v__qp)pFunQt[24252])(_wh);
            _wh = null;
        }
    }

    /// Wrap an existing QStandardItem* (Qt-owned — dtor will NOT delete).
    static QStandardItem wrap(void* ptr) {
        if (ptr is null) return null;
        return new QStandardItem(ptr, true);
    }

    /// Mark as Qt-owned (model/parent takes ownership).
    void disown()  { _qt_owned = true; }
    bool qtOwned() { return _qt_owned; }
    void* getWH()  { return _wh; }

    // ── Text ──────────────────────────────────────────────────────────

    string text() {
        void* qs = (cast(t_qp__qp)pFunQt[24253])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QStandardItem setText(string text) {
        auto ws = toQString(text);
        (cast(t_v__qp_qp)pFunQt[24254])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Icon ──────────────────────────────────────────────────────────

    QIcon icon() { return QIcon.wrap((cast(t_qp__qp)pFunQt[24255])(_wh)); }
    QStandardItem setIcon(QIcon icon) { (cast(t_v__qp_qp)pFunQt[24256])(_wh, icon.getPtr()); return this; }

    // ── ToolTip / StatusTip / WhatsThis ───────────────────────────────

    string toolTip() {
        void* qs = (cast(t_qp__qp)pFunQt[24257])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }
    QStandardItem setToolTip(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[24258])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string statusTip() {
        void* qs = (cast(t_qp__qp)pFunQt[24259])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }
    QStandardItem setStatusTip(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[24260])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    string whatsThis() {
        void* qs = (cast(t_qp__qp)pFunQt[24261])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }
    QStandardItem setWhatsThis(string s) {
        auto ws = toQString(s);
        (cast(t_v__qp_qp)pFunQt[24262])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Font / Background / Foreground ────────────────────────────────

    QFont font() { return QFont.wrap((cast(t_qp__qp)pFunQt[24263])(_wh)); }
    QStandardItem setFont(QFont f) { (cast(t_v__qp_qp)pFunQt[24264])(_wh, f.getWH()); return this; }

    QBrush background() { return QBrush.wrap((cast(t_qp__qp)pFunQt[24265])(_wh)); }
    QStandardItem setBackground(QBrush b) { (cast(t_v__qp_qp)pFunQt[24266])(_wh, b.getWH()); return this; }

    QBrush foreground() { return QBrush.wrap((cast(t_qp__qp)pFunQt[24267])(_wh)); }
    QStandardItem setForeground(QBrush b) { (cast(t_v__qp_qp)pFunQt[24268])(_wh, b.getWH()); return this; }

    // ── Check state / flags ───────────────────────────────────────────

    int  checkState() { return cast(int)(cast(t_i__qp)pFunQt[24269])(_wh); }
    QStandardItem setCheckState(int state) { (cast(t_v__qp_i)pFunQt[24270])(_wh, state); return this; }

    bool isCheckable() { return (cast(t_i__qp)pFunQt[24271])(_wh) != 0; }
    QStandardItem setCheckable(bool c) { (cast(t_v__qp_i)pFunQt[24272])(_wh, c ? 1 : 0); return this; }

    bool isEditable() { return (cast(t_i__qp)pFunQt[24273])(_wh) != 0; }
    QStandardItem setEditable(bool e) { (cast(t_v__qp_i)pFunQt[24274])(_wh, e ? 1 : 0); return this; }

    bool isSelectable() { return (cast(t_i__qp)pFunQt[24275])(_wh) != 0; }
    QStandardItem setSelectable(bool s) { (cast(t_v__qp_i)pFunQt[24276])(_wh, s ? 1 : 0); return this; }

    bool isEnabled() { return (cast(t_i__qp)pFunQt[24277])(_wh) != 0; }
    QStandardItem setEnabled(bool e) { (cast(t_v__qp_i)pFunQt[24278])(_wh, e ? 1 : 0); return this; }

    // ── User data ─────────────────────────────────────────────────────

    int data_int(int role) { return cast(int)(cast(t_i__qp_i)pFunQt[24279])(_wh, role); }

    string data_str(int role) {
        void* qs = (cast(t_qp__qp_i)pFunQt[24280])(_wh, role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    QStandardItem setData(int role, int value) { (cast(t_v__qp_i_i)pFunQt[24281])(_wh, role, value); return this; }

    QStandardItem setData(int role, string value) {
        auto ws = toQString(value);
        (cast(t_v__qp_i_qp)pFunQt[24282])(_wh, role, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Position / parent / children ──────────────────────────────────

    int row()    { return cast(int)(cast(t_i__qp)pFunQt[24283])(_wh); }
    int column() { return cast(int)(cast(t_i__qp)pFunQt[24284])(_wh); }

    QStandardItem parent() { return QStandardItem.wrap((cast(t_qp__qp)pFunQt[24285])(_wh)); }

    QStandardItem child(int row, int col) {
        return QStandardItem.wrap((cast(t_qp__qp_i_i)pFunQt[24286])(_wh, row, col));
    }

    QStandardItem setChild(int row, int col, QStandardItem child) {
        (cast(t_v__qp_i_i_qp)pFunQt[24287])(_wh, row, col, child.getWH());
        child.disown();
        return this;
    }

    QStandardItem removeRow(int row) { (cast(t_v__qp_i)pFunQt[24288])(_wh, row); return this; }
    QStandardItem removeRows(int row, int count) { (cast(t_v__qp_i_i)pFunQt[24289])(_wh, row, count); return this; }
    QStandardItem removeColumn(int col) { (cast(t_v__qp_i)pFunQt[24290])(_wh, col); return this; }
    QStandardItem removeColumns(int col, int count) { (cast(t_v__qp_i_i)pFunQt[24291])(_wh, col, count); return this; }

    QStandardItem appendRow(QStandardItem child) {
        (cast(t_v__qp_qp)pFunQt[24292])(_wh, child.getWH());
        child.disown();
        return this;
    }
    QStandardItem appendColumn(QStandardItem child) {
        (cast(t_v__qp_qp)pFunQt[24293])(_wh, child.getWH());
        child.disown();
        return this;
    }
    QStandardItem insertRow(int row, QStandardItem child) {
        (cast(t_v__qp_i_qp)pFunQt[24294])(_wh, row, child.getWH());
        child.disown();
        return this;
    }
    QStandardItem insertColumn(int col, QStandardItem child) {
        (cast(t_v__qp_i_qp)pFunQt[24295])(_wh, col, child.getWH());
        child.disown();
        return this;
    }

    int rowCount()    { return cast(int)(cast(t_i__qp)pFunQt[24296])(_wh); }
    int columnCount() { return cast(int)(cast(t_i__qp)pFunQt[24297])(_wh); }
    bool hasChildren() { return (cast(t_i__qp)pFunQt[24298])(_wh) != 0; }

    QModelIndex index() { return QModelIndex.wrap((cast(t_qp__qp)pFunQt[24299])(_wh)); }
    void* model() { return (cast(t_qp__qp)pFunQt[24300])(_wh); }

    QStandardItem clone() { return QStandardItem.wrap((cast(t_qp__qp)pFunQt[24301])(_wh)); }
    int type() { return cast(int)(cast(t_i__qp)pFunQt[24302])(_wh); }
}
