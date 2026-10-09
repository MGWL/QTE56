/**
 * gen_qobject.d — D wrapper for QObject (root of Qt object hierarchy).
 * Module: QObject  |  DLL: qte56_foundation.dll
 * MANUALLY WRITTEN — QObject is the root base class, not generated.
 *
 * Index block: 25000–25099
 * Methods: objectName, setObjectName, deleteLater, blockSignals,
 *          signalsBlocked, parent, inherits
 *
 * Design notes:
 *  - _wh and _qt_owned live here; all subclasses inherit them.
 *  - QObject.~this() guards on (_wh !is null) — child dtors must
 *    null _wh after their own delete to prevent double-free.
 *  - QObject methods accept void* — valid for any QObject subclass.
 *    (QWidget._wh is a QWidget* which IS a QObject* in C++.)
 */
module gen_qobject;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, connectQt, ESlot,
    t_i__qp,
    t_qp__, t_qp__qp, t_qp__qp_i,
    t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp,
    toQString;

// New aliases needed by this module:
mixin(generateAlias("i__qp_i"));     // int func(void*, int)              — blockSignals
mixin(generateAlias("i__qp_i_i"));   // int func(void*, int, int)         — startTimer
mixin(generateAlias("i__qp_cp"));    // int func(void*, const(char)*)     — inherits
mixin(generateAlias("i__qp_qp"));    // int func(void*, void*)            — event
mixin(generateAlias("i__qp_qp_qp")); // int func(void*, void*, void*)     — eventFilter
mixin(generateAlias("qp__qp_i"));    // void* func(void*, int)            — childrenAt

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

static this() { registerModule("QObject", "qte56_foundation.dll", &loadQObject); }

void loadQObject() {
    mixin(generateFunQt(3600, "qteQObject_create",        "QObject"));
    mixin(generateFunQt(3601, "qteQObject_delete",        "QObject"));
    mixin(generateFunQt(3602, "qteQObject_objectName",    "QObject"));
    mixin(generateFunQt(3603, "qteQObject_setObjectName", "QObject"));
    mixin(generateFunQt(3604, "qteQObject_deleteLater",   "QObject"));
    mixin(generateFunQt(3605, "qteQObject_blockSignals",  "QObject"));
    mixin(generateFunQt(3606, "qteQObject_signalsBlocked","QObject"));
    mixin(generateFunQt(3607, "qteQObject_parent",        "QObject"));
    mixin(generateFunQt(3608, "qteQObject_inherits",      "QObject"));
    // ── Thread affinity / timers / tree / events / introspection ─────────
    mixin(generateFunQt(3609, "qteQObject_thread",                "QObject"));
    mixin(generateFunQt(3610, "qteQObject_moveToThread",          "QObject"));
    mixin(generateFunQt(3611, "qteQObject_startTimer",            "QObject"));
    mixin(generateFunQt(3612, "qteQObject_killTimer",             "QObject"));
    mixin(generateFunQt(3613, "qteQObject_setParent",             "QObject"));
    mixin(generateFunQt(3614, "qteQObject_isWidgetType",          "QObject"));
    mixin(generateFunQt(3615, "qteQObject_isWindowType",          "QObject"));
    mixin(generateFunQt(3616, "qteQObject_dumpObjectTree",        "QObject"));
    mixin(generateFunQt(3617, "qteQObject_dumpObjectInfo",        "QObject"));
    mixin(generateFunQt(3618, "qteQObject_childrenCount",         "QObject"));
    mixin(generateFunQt(3619, "qteQObject_childrenAt",            "QObject"));
    mixin(generateFunQt(3620, "qteQObject_event",                 "QObject"));
    mixin(generateFunQt(3621, "qteQObject_eventFilter",           "QObject"));
    mixin(generateFunQt(3622, "qteQObject_installEventFilter",    "QObject"));
    mixin(generateFunQt(3623, "qteQObject_removeEventFilter",     "QObject"));
    mixin(generateFunQt(3624, "qteQObject_connect_destroyed",     "QObject"));
    // ── Lifecycle tracking ──────────────────────────────────────────────────
    mixin(generateFunQt(24100, "qte_lifecycle_shouldDelete",      "QObject"));
    mixin(generateFunQt(24101, "qte_lifecycle_isValid",           "QObject"));
    mixin(generateFunQt(24102, "qte_lifecycle_installAppFilter",  "QObject"));
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QObject — root of the Qt object hierarchy.
/// Holds _wh (raw Qt pointer) and _qt_owned (lifetime flag).
/// All widget classes inherit these fields.
/// @live enforces explicit ownership management, preventing GC from interfering.
@live class QObject {
protected:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create a standalone QObject. parent=null for root objects.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[3600])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    /// Child classes set _wh themselves after calling super().
    protected this(bool _noOp) {}

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[3601] !is null && pFunQt[24100] !is null) {
            // Lifecycle: удаляем только если C++ объект жив и не имеет Qt parent
            if ((cast(t_i__qp)pFunQt[24100])(_wh) != 0) {
                (cast(t_v__qp)pFunQt[3601])(_wh);
            }
            _wh = null;
        }
    }

    /// True if the underlying C++ object is still alive (not destroyed).
    bool isValid() {
        return _wh !is null && pFunQt[24101] !is null &&
               (cast(t_i__qp)pFunQt[24101])(_wh) != 0;
    }

    // ── objectName ───────────────────────────────────────────────────

    /// Return the object name (set via setObjectName).
    string objectName() {
        void* _qs = (cast(t_qp__qp)pFunQt[3602])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Set the object name.
    QObject setObjectName(string name) {
        auto _ws = toQString(name);
        (cast(t_v__qp_qp)pFunQt[3603])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── Signal control ───────────────────────────────────────────────

    /// Block/unblock all signals. Returns previous blocked state.
    bool blockSignals(bool block) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[3605])(_wh, block ? 1 : 0);
    }

    /// Returns true if signals are currently blocked.
    bool signalsBlocked() {
        return cast(bool)(cast(t_i__qp)pFunQt[3606])(_wh);
    }

    // ── Object tree ──────────────────────────────────────────────────

    /// Returns parent as raw void* (cast to typed D class when needed).
    void* parent() {
        return (cast(t_qp__qp)pFunQt[3607])(_wh);
    }

    /// deleteLater — schedule deletion via Qt event loop (safe in slots).
    QObject deleteLater() {
        (cast(t_v__qp)pFunQt[3604])(_wh);
        return this;
    }

    // ── Introspection ────────────────────────────────────────────────

    /// Returns true if this object's Qt class inherits the given class name.
    /// Example: widget.inherits("QWidget") == true for any QWidget subclass.
    bool inherits(string className) {
        import std.string : toStringz;
        return cast(bool)(cast(t_i__qp_cp)pFunQt[3608])(_wh, toStringz(className));
    }

    // ── Thread affinity ─────────────────────────────────────────────────

    /// Returns the QThread* this object lives in (raw void*).
    void* thread() {
        return (cast(t_qp__qp)pFunQt[3609])(_wh);
    }

    /// Move this object to `thread` (pass QThread.getWH() or another void*).
    QObject moveToThread(void* thread) {
        (cast(t_v__qp_qp)pFunQt[3610])(_wh, thread);
        return this;
    }

    // ── Timers ──────────────────────────────────────────────────────────

    /// Starts a timer and returns its id (>0). timerType: 0=Precise, 1=Coarse, 2=VeryCoarse.
    int startTimer(int interval, int timerType = 1) {
        return (cast(t_i__qp_i_i)pFunQt[3611])(_wh, interval, timerType);
    }

    /// Kill timer by id returned from startTimer().
    QObject killTimer(int id) {
        (cast(t_v__qp_i)pFunQt[3612])(_wh, id);
        return this;
    }

    // ── Object tree ─────────────────────────────────────────────────────

    /// Sets the parent. parent=null removes object from the tree.
    QObject setParent(QObject parent) {
        (cast(t_v__qp_qp)pFunQt[3613])(_wh, parent.getWH());
        return this;
    }

    /// ditto — raw void* overload.
    QObject setParent(void* parent) {
        (cast(t_v__qp_qp)pFunQt[3613])(_wh, parent);
        return this;
    }

    /// True if the object is a widget.
    bool isWidgetType() {
        return (cast(t_i__qp)pFunQt[3614])(_wh) != 0;
    }

    /// True if the object is a window (top-level surface).
    bool isWindowType() {
        return (cast(t_i__qp)pFunQt[3615])(_wh) != 0;
    }

    /// Number of child objects.
    int childrenCount() {
        return (cast(t_i__qp)pFunQt[3618])(_wh);
    }

    /// Returns raw pointer of i-th child, or null if out of range.
    void* childrenAt(int index) {
        return (cast(t_qp__qp_i)pFunQt[3619])(_wh, index);
    }

    // ── Event handling ──────────────────────────────────────────────────

    /// Deliver event `e` (QEvent* as void*) to this object. Returns true if handled.
    bool event(void* e) {
        return (cast(t_i__qp_qp)pFunQt[3620])(_wh, e) != 0;
    }

    /// Filter event for `watched` object. Returns true to stop further processing.
    bool eventFilter(QObject watched, void* e) {
        return (cast(t_i__qp_qp_qp)pFunQt[3621])(_wh, watched.getWH(), e) != 0;
    }

    /// ditto — raw void* overload for watched.
    bool eventFilter(void* watched, void* e) {
        return (cast(t_i__qp_qp_qp)pFunQt[3621])(_wh, watched, e) != 0;
    }

    /// Install another QObject as event filter.
    QObject installEventFilter(QObject filterObj) {
        (cast(t_v__qp_qp)pFunQt[3622])(_wh, filterObj.getWH());
        return this;
    }

    /// ditto — raw void* overload.
    QObject installEventFilter(void* filterObj) {
        (cast(t_v__qp_qp)pFunQt[3622])(_wh, filterObj);
        return this;
    }

    /// Remove previously installed event filter.
    QObject removeEventFilter(QObject filterObj) {
        (cast(t_v__qp_qp)pFunQt[3623])(_wh, filterObj.getWH());
        return this;
    }

    /// ditto — raw void* overload.
    QObject removeEventFilter(void* filterObj) {
        (cast(t_v__qp_qp)pFunQt[3623])(_wh, filterObj);
        return this;
    }

    // ── Debug/introspection ─────────────────────────────────────────────

    /// Dumps object tree to stdout (debug builds) or does nothing.
    QObject dumpObjectTree() { (cast(t_v__qp)pFunQt[3616])(_wh); return this; }

    /// Dumps object info to stdout (debug builds) or does nothing.
    QObject dumpObjectInfo() { (cast(t_v__qp)pFunQt[3617])(_wh); return this; }

    // ── Signals ─────────────────────────────────────────────────────────

    /// Connect `destroyed(QObject*)` signal to a raw callback.
    /// cb signature: extern(C) void function(void* dthis, int n, void* obj)
    QObject connect_destroyed(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[3624])(_wh, cb, dthis);
        return this;
    }

    /// Connect `objectNameChanged(const QString&)` signal to an ESlot.
    QObject connect_objectNameChanged(ESlot eslot) {
        connectQt(_wh, "objectNameChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Lifetime helpers (used by all subclasses) ─────────────────────

    /// Mark as Qt-owned (call after addWidget / reparenting).
    /// Prevents D destructor from deleting the Qt object.
    void disown()  { _qt_owned = true; }

    /// Returns true when Qt owns the lifetime of this object.
    bool qtOwned() { return _qt_owned; }

    /// Raw Qt object pointer. Pass to C++ wrappers that expect void*.
    void* getWH()  { return _wh; }

} // class QObject
