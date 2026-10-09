/**
 * gen_qmodelindex.d — D wrapper for QModelIndex (value type).
 * Module: QModelIndex  |  DLL: qte56_qmodelview.dll
 *
 * QModelIndex — value-класс, передаётся как heap-указатель.
 * D-объект владеет C++ QModelIndex и удаляет его в dtor.
 */
module gen_qmodelindex;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_i"));   // void*(void*, int, int) — sibling

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQModelIndex() {
    mixin(generateFunQt(24200, "qteQModelIndex_create",        "QModelIndex"));
    mixin(generateFunQt(24202, "qteQModelIndex_delete",        "QModelIndex"));
    mixin(generateFunQt(24203, "qteQModelIndex_row",           "QModelIndex"));
    mixin(generateFunQt(24204, "qteQModelIndex_column",        "QModelIndex"));
    mixin(generateFunQt(24205, "qteQModelIndex_parent",        "QModelIndex"));
    mixin(generateFunQt(24206, "qteQModelIndex_sibling",       "QModelIndex"));
    mixin(generateFunQt(24207, "qteQModelIndex_flags",         "QModelIndex"));
    mixin(generateFunQt(24208, "qteQModelIndex_internalId",    "QModelIndex"));
    mixin(generateFunQt(24209, "qteQModelIndex_internalPointer","QModelIndex"));
    mixin(generateFunQt(24210, "qteQModelIndex_model",         "QModelIndex"));
    mixin(generateFunQt(24211, "qteQModelIndex_isValid",       "QModelIndex"));
    mixin(generateFunQt(24212, "qteQModelIndex_data_i",        "QModelIndex"));
    mixin(generateFunQt(24213, "qteQModelIndex_data_s",        "QModelIndex"));
    mixin(generateFunQt(24214, "qteQModelIndex_equals",        "QModelIndex"));
    mixin(generateFunQt(24215, "qteQModelIndex_notEquals",     "QModelIndex"));
}

static this() {
    registerModule("QModelIndex", "qte56_qmodelview.dll", &loadQModelIndex);
}

// ====================================================================
// Class wrapper — value type
// ====================================================================

/// D wrapper for Qt value type QModelIndex.
/// D owns the C++ heap copy; dtor deletes it.
@live class QModelIndex {
private:
    void* _ptr;
    bool  _borrowed;   // true = Qt-owned, dtor НЕ удаляет

public:
    /// Create invalid QModelIndex.
    this() {
        _ptr = (cast(t_qp__)pFunQt[24200])();
    }

    /// Private ctor for wrap().
    private this(void* ptr, bool dummy) {
        _ptr = ptr;
    }

    ~this() {
        if (!_borrowed && _ptr !is null && pFunQt[24202] !is null) {
            (cast(t_v__qp)pFunQt[24202])(_ptr);
            _ptr = null;
        }
    }

    /// Wrap an existing QModelIndex* (takes ownership — caller must not delete).
    static QModelIndex wrap(void* ptr) {
        if (ptr is null) return null;
        return new QModelIndex(ptr, true);
    }

    /// Wrap a borrowed QModelIndex* (Qt-owned, valid only during a callback).
    /// Dtor will NOT delete. Не хранить за пределами коллбэка!
    static QModelIndex wrapBorrowed(void* ptr) {
        if (ptr is null) return null;
        auto m = new QModelIndex(ptr, true);
        m._borrowed = true;
        return m;
    }

    /// Raw pointer for passing to Qt functions.
    void* getPtr() { return _ptr; }

    // ── Methods ───────────────────────────────────────────────────────

    int row()    { return cast(int)(cast(t_i__qp)pFunQt[24203])(_ptr); }
    int column() { return cast(int)(cast(t_i__qp)pFunQt[24204])(_ptr); }

    QModelIndex parent() {
        return QModelIndex.wrap((cast(t_qp__qp)pFunQt[24205])(_ptr));
    }

    QModelIndex sibling(int row, int col) {
        return QModelIndex.wrap((cast(t_qp__qp_i_i)pFunQt[24206])(_ptr, row, col));
    }

    int flags() { return cast(int)(cast(t_i__qp)pFunQt[24207])(_ptr); }
    long internalId() { return (cast(t_l__qp)pFunQt[24208])(_ptr); }
    void* internalPointer() { return (cast(t_qp__qp)pFunQt[24209])(_ptr); }
    void* model() { return (cast(t_qp__qp)pFunQt[24210])(_ptr); }
    bool isValid() { return (cast(t_i__qp)pFunQt[24211])(_ptr) != 0; }

    int data_int(int role) { return cast(int)(cast(t_i__qp_i)pFunQt[24212])(_ptr, role); }

    string data_str(int role) {
        void* qs = (cast(t_qp__qp_i)pFunQt[24213])(_ptr, role);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    bool equals(QModelIndex other) {
        if (other is null) return false;
        return (cast(t_i__qp_qp)pFunQt[24214])(_ptr, other.getPtr()) != 0;
    }

    bool notEquals(QModelIndex other) {
        if (other is null) return true;
        return (cast(t_i__qp_qp)pFunQt[24215])(_ptr, other.getPtr()) != 0;
    }
}
