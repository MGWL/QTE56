/**
 * gen_qpointf.d — GENERATED wrapper for QPointF.
 * Module: QPointF  |  DLL: qte56_qpointf.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 * Use --patch to update only generated sections while keeping manual edits.
 */
// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-07-25T22:55:53
// command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h --module QPointF --qt-mod core --cpp-out ../cpp/qt5/qte56_qpointf --d-out ../d/gen --index-start 21800
// header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h
// qt: 5.13.2
// module: QPointF
// dll: qte56_qpointf.dll
// d-parent: (root class)
// index-block: 21800 (--index-start)
// index-range: 21800-21808
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 7 wrapper(s), 0 signal(s), lifecycle=no
// skipped-unsupported: 2
//   qreal & rx() [method] — return type 'qreal &'
//   qreal & ry() [method] — return type 'qreal &'
// ===GENERATOR-INFO-END===
module gen_qpointf;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__qp, t_v__qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, ESlot, connectQt, fromQString, DRect, DPoint, DSize;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("v__qp_d"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================
// ===AUTO-GENERATED-LOAD-FUNC-START===

void loadQPointF() {
    mixin(generateFunQt(21800, "qteQPointF_create", "QPointF"));
    mixin(generateFunQt(21801, "qteQPointF_delete", "QPointF"));
    mixin(generateFunQt(21802, "qteQPointF_manhattanLength", "QPointF"));
    mixin(generateFunQt(21803, "qteQPointF_isNull", "QPointF"));
    mixin(generateFunQt(21804, "qteQPointF_x", "QPointF"));
    mixin(generateFunQt(21805, "qteQPointF_y", "QPointF"));
    mixin(generateFunQt(21806, "qteQPointF_setX", "QPointF"));
    mixin(generateFunQt(21807, "qteQPointF_setY", "QPointF"));
    mixin(generateFunQt(21808, "qteQPointF_toPoint", "QPointF"));
}

static this() {
    registerModule("QPointF", "qte56_qpointf.dll", &loadQPointF);
}

// ===AUTO-GENERATED-LOAD-FUNC-END===

// ====================================================================
// Class wrapper
// ====================================================================
// ===AUTO-GENERATED-CLASS-START===

/// D wrapper for Qt class QPointF.
@live class QPointF {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QPointF. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[21800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    /// Child classes set _wh themselves after calling super().
    protected this(bool _noOp) {}
    /// Wrap an existing Qt-owned QPointF* — the D object does NOT delete it.
    static QPointF wrap(void* wh) {
        auto w = new QPointF(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[21801] !is null) {
            (cast(t_v__qp)pFunQt[21801])(_wh);
            _wh = null;
        }
    }

    /// manhattanLength
    double manhattanLength() {
        return cast(double)(cast(t_d__qp)pFunQt[21802])(_wh);
    }

    /// isNull
    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[21803])(_wh);
    }

    /// x
    double x() {
        return cast(double)(cast(t_d__qp)pFunQt[21804])(_wh);
    }

    /// y
    double y() {
        return cast(double)(cast(t_d__qp)pFunQt[21805])(_wh);
    }

    /// setX
    QPointF setX(double x) {
        (cast(t_v__qp_d)pFunQt[21806])(_wh, x);
        return this;
    }

    /// setY
    QPointF setY(double y) {
        (cast(t_v__qp_d)pFunQt[21807])(_wh, y);
        return this;
    }

    /// toPoint
    DPoint toPoint() {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[21808])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    // ===MANUAL-METHODS-START===
    // ===MANUAL-METHODS-END===

    /// Mark as Qt-owned. Typed overloads (addWidget, setLayout, etc.)
    /// call disown() automatically. For void* API — call manually.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QPointF
// ===AUTO-GENERATED-CLASS-END===
