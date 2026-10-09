/**
 * gen_qrectf.d — GENERATED wrapper for QRectF.
 * Module: QRectF  |  DLL: qte56_qrectf.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 * Use --patch to update only generated sections while keeping manual edits.
 */
// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-07-25T22:55:54
// command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h --module QRectF --qt-mod core --cpp-out ../cpp/qt5/qte56_qrectf --d-out ../d/gen --index-start 21900
// header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h
// qt: 5.13.2
// module: QRectF
// dll: qte56_qrectf.dll
// d-parent: (root class)
// index-block: 21900 (--index-start)
// index-range: 21900-21948
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 47 wrapper(s), 0 signal(s), lifecycle=no
// skipped-unsupported: 6
//   void getRect(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
//   void getCoords(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
//   QSizeF size() [method] — return type 'QSizeF'
//   void setSize(const QSizeF&) [method] — param type 'const QSizeF&'
//   QRectF marginsAdded(const QMarginsF&) [method] — param type 'const QMarginsF&'
//   QRectF marginsRemoved(const QMarginsF&) [method] — param type 'const QMarginsF&'
// ===GENERATOR-INFO-END===
module gen_qrectf;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, ESlot, connectQt, fromQString, DRect, DPoint, DSize;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_d_d"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_d_d"));
mixin(generateAlias("qp__qp_d_d_d_d"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d"));
mixin(generateAlias("v__qp_d_d_d_d"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================
// ===AUTO-GENERATED-LOAD-FUNC-START===

void loadQRectF() {
    mixin(generateFunQt(21900, "qteQRectF_create", "QRectF"));
    mixin(generateFunQt(21901, "qteQRectF_delete", "QRectF"));
    mixin(generateFunQt(21902, "qteQRectF_isNull", "QRectF"));
    mixin(generateFunQt(21903, "qteQRectF_isEmpty", "QRectF"));
    mixin(generateFunQt(21904, "qteQRectF_isValid", "QRectF"));
    mixin(generateFunQt(21905, "qteQRectF_normalized", "QRectF"));
    mixin(generateFunQt(21906, "qteQRectF_x", "QRectF"));
    mixin(generateFunQt(21907, "qteQRectF_y", "QRectF"));
    mixin(generateFunQt(21908, "qteQRectF_setLeft", "QRectF"));
    mixin(generateFunQt(21909, "qteQRectF_setTop", "QRectF"));
    mixin(generateFunQt(21910, "qteQRectF_setRight", "QRectF"));
    mixin(generateFunQt(21911, "qteQRectF_setBottom", "QRectF"));
    mixin(generateFunQt(21912, "qteQRectF_center", "QRectF"));
    mixin(generateFunQt(21913, "qteQRectF_setTopLeft", "QRectF"));
    mixin(generateFunQt(21914, "qteQRectF_setBottomRight", "QRectF"));
    mixin(generateFunQt(21915, "qteQRectF_setTopRight", "QRectF"));
    mixin(generateFunQt(21916, "qteQRectF_setBottomLeft", "QRectF"));
    mixin(generateFunQt(21917, "qteQRectF_moveLeft", "QRectF"));
    mixin(generateFunQt(21918, "qteQRectF_moveTop", "QRectF"));
    mixin(generateFunQt(21919, "qteQRectF_moveRight", "QRectF"));
    mixin(generateFunQt(21920, "qteQRectF_moveBottom", "QRectF"));
    mixin(generateFunQt(21921, "qteQRectF_moveTopLeft", "QRectF"));
    mixin(generateFunQt(21922, "qteQRectF_moveBottomRight", "QRectF"));
    mixin(generateFunQt(21923, "qteQRectF_moveTopRight", "QRectF"));
    mixin(generateFunQt(21924, "qteQRectF_moveBottomLeft", "QRectF"));
    mixin(generateFunQt(21925, "qteQRectF_moveCenter", "QRectF"));
    mixin(generateFunQt(21926, "qteQRectF_translate_dd", "QRectF"));
    mixin(generateFunQt(21927, "qteQRectF_translate_pf", "QRectF"));
    mixin(generateFunQt(21928, "qteQRectF_translated_dd", "QRectF"));
    mixin(generateFunQt(21929, "qteQRectF_translated_pf", "QRectF"));
    mixin(generateFunQt(21930, "qteQRectF_transposed", "QRectF"));
    mixin(generateFunQt(21931, "qteQRectF_moveTo_dd", "QRectF"));
    mixin(generateFunQt(21932, "qteQRectF_moveTo_pf", "QRectF"));
    mixin(generateFunQt(21933, "qteQRectF_setRect", "QRectF"));
    mixin(generateFunQt(21934, "qteQRectF_setCoords", "QRectF"));
    mixin(generateFunQt(21935, "qteQRectF_adjust", "QRectF"));
    mixin(generateFunQt(21936, "qteQRectF_adjusted", "QRectF"));
    mixin(generateFunQt(21937, "qteQRectF_width", "QRectF"));
    mixin(generateFunQt(21938, "qteQRectF_height", "QRectF"));
    mixin(generateFunQt(21939, "qteQRectF_setWidth", "QRectF"));
    mixin(generateFunQt(21940, "qteQRectF_setHeight", "QRectF"));
    mixin(generateFunQt(21941, "qteQRectF_contains_rf", "QRectF"));
    mixin(generateFunQt(21942, "qteQRectF_contains_pf", "QRectF"));
    mixin(generateFunQt(21943, "qteQRectF_contains_dd", "QRectF"));
    mixin(generateFunQt(21944, "qteQRectF_united", "QRectF"));
    mixin(generateFunQt(21945, "qteQRectF_intersected", "QRectF"));
    mixin(generateFunQt(21946, "qteQRectF_intersects", "QRectF"));
    mixin(generateFunQt(21947, "qteQRectF_toRect", "QRectF"));
    mixin(generateFunQt(21948, "qteQRectF_toAlignedRect", "QRectF"));
}

static this() {
    registerModule("QRectF", "qte56_qrectf.dll", &loadQRectF);
}

// ===AUTO-GENERATED-LOAD-FUNC-END===

// ====================================================================
// Class wrapper
// ====================================================================
// ===AUTO-GENERATED-CLASS-START===

/// D wrapper for Qt class QRectF.
@live class QRectF {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QRectF. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[21900])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    /// Child classes set _wh themselves after calling super().
    protected this(bool _noOp) {}
    /// Wrap an existing Qt-owned QRectF* — the D object does NOT delete it.
    static QRectF wrap(void* wh) {
        auto w = new QRectF(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[21901] !is null) {
            (cast(t_v__qp)pFunQt[21901])(_wh);
            _wh = null;
        }
    }

    /// isNull
    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[21902])(_wh);
    }

    /// isEmpty
    bool isEmpty() {
        return cast(bool)(cast(t_i__qp)pFunQt[21903])(_wh);
    }

    /// isValid
    bool isValid() {
        return cast(bool)(cast(t_i__qp)pFunQt[21904])(_wh);
    }

    /// normalized
    void* normalized() {
        return (cast(t_qp__qp)pFunQt[21905])(_wh);
    }

    /// x
    double x() {
        return cast(double)(cast(t_d__qp)pFunQt[21906])(_wh);
    }

    /// y
    double y() {
        return cast(double)(cast(t_d__qp)pFunQt[21907])(_wh);
    }

    /// setLeft
    QRectF setLeft(double pos) {
        (cast(t_v__qp_d)pFunQt[21908])(_wh, pos);
        return this;
    }

    /// setTop
    QRectF setTop(double pos) {
        (cast(t_v__qp_d)pFunQt[21909])(_wh, pos);
        return this;
    }

    /// setRight
    QRectF setRight(double pos) {
        (cast(t_v__qp_d)pFunQt[21910])(_wh, pos);
        return this;
    }

    /// setBottom
    QRectF setBottom(double pos) {
        (cast(t_v__qp_d)pFunQt[21911])(_wh, pos);
        return this;
    }

    /// center
    void* center() {
        return (cast(t_qp__qp)pFunQt[21912])(_wh);
    }

    /// setTopLeft
    QRectF setTopLeft(void* p) {
        (cast(t_v__qp_qp)pFunQt[21913])(_wh, p);
        return this;
    }

    /// setBottomRight
    QRectF setBottomRight(void* p) {
        (cast(t_v__qp_qp)pFunQt[21914])(_wh, p);
        return this;
    }

    /// setTopRight
    QRectF setTopRight(void* p) {
        (cast(t_v__qp_qp)pFunQt[21915])(_wh, p);
        return this;
    }

    /// setBottomLeft
    QRectF setBottomLeft(void* p) {
        (cast(t_v__qp_qp)pFunQt[21916])(_wh, p);
        return this;
    }

    /// moveLeft
    QRectF moveLeft(double pos) {
        (cast(t_v__qp_d)pFunQt[21917])(_wh, pos);
        return this;
    }

    /// moveTop
    QRectF moveTop(double pos) {
        (cast(t_v__qp_d)pFunQt[21918])(_wh, pos);
        return this;
    }

    /// moveRight
    QRectF moveRight(double pos) {
        (cast(t_v__qp_d)pFunQt[21919])(_wh, pos);
        return this;
    }

    /// moveBottom
    QRectF moveBottom(double pos) {
        (cast(t_v__qp_d)pFunQt[21920])(_wh, pos);
        return this;
    }

    /// moveTopLeft
    QRectF moveTopLeft(void* p) {
        (cast(t_v__qp_qp)pFunQt[21921])(_wh, p);
        return this;
    }

    /// moveBottomRight
    QRectF moveBottomRight(void* p) {
        (cast(t_v__qp_qp)pFunQt[21922])(_wh, p);
        return this;
    }

    /// moveTopRight
    QRectF moveTopRight(void* p) {
        (cast(t_v__qp_qp)pFunQt[21923])(_wh, p);
        return this;
    }

    /// moveBottomLeft
    QRectF moveBottomLeft(void* p) {
        (cast(t_v__qp_qp)pFunQt[21924])(_wh, p);
        return this;
    }

    /// moveCenter
    QRectF moveCenter(void* p) {
        (cast(t_v__qp_qp)pFunQt[21925])(_wh, p);
        return this;
    }

    /// translate
    QRectF translate(double dx, double dy) {
        (cast(t_v__qp_d_d)pFunQt[21926])(_wh, dx, dy);
        return this;
    }

    /// translate
    QRectF translate(void* p) {
        (cast(t_v__qp_qp)pFunQt[21927])(_wh, p);
        return this;
    }

    /// translated
    void* translated(double dx, double dy) {
        return (cast(t_qp__qp_d_d)pFunQt[21928])(_wh, dx, dy);
    }

    /// translated
    void* translated(void* p) {
        return (cast(t_qp__qp_qp)pFunQt[21929])(_wh, p);
    }

    /// transposed
    void* transposed() {
        return (cast(t_qp__qp)pFunQt[21930])(_wh);
    }

    /// moveTo
    QRectF moveTo(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[21931])(_wh, x, y);
        return this;
    }

    /// moveTo
    QRectF moveTo(void* p) {
        (cast(t_v__qp_qp)pFunQt[21932])(_wh, p);
        return this;
    }

    /// setRect
    QRectF setRect(double x, double y, double w, double h) {
        (cast(t_v__qp_d_d_d_d)pFunQt[21933])(_wh, x, y, w, h);
        return this;
    }

    /// setCoords
    QRectF setCoords(double x1, double y1, double x2, double y2) {
        (cast(t_v__qp_d_d_d_d)pFunQt[21934])(_wh, x1, y1, x2, y2);
        return this;
    }

    /// adjust
    QRectF adjust(double x1, double y1, double x2, double y2) {
        (cast(t_v__qp_d_d_d_d)pFunQt[21935])(_wh, x1, y1, x2, y2);
        return this;
    }

    /// adjusted
    void* adjusted(double x1, double y1, double x2, double y2) {
        return (cast(t_qp__qp_d_d_d_d)pFunQt[21936])(_wh, x1, y1, x2, y2);
    }

    /// width
    double width() {
        return cast(double)(cast(t_d__qp)pFunQt[21937])(_wh);
    }

    /// height
    double height() {
        return cast(double)(cast(t_d__qp)pFunQt[21938])(_wh);
    }

    /// setWidth
    QRectF setWidth(double w) {
        (cast(t_v__qp_d)pFunQt[21939])(_wh, w);
        return this;
    }

    /// setHeight
    QRectF setHeight(double h) {
        (cast(t_v__qp_d)pFunQt[21940])(_wh, h);
        return this;
    }

    /// contains
    bool contains_rf(void* r) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[21941])(_wh, r);
    }

    /// contains
    bool contains_pf(void* p) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[21942])(_wh, p);
    }

    /// contains
    bool contains(double x, double y) {
        return cast(bool)(cast(t_i__qp_d_d)pFunQt[21943])(_wh, x, y);
    }

    /// united
    void* united(void* other) {
        return (cast(t_qp__qp_qp)pFunQt[21944])(_wh, other);
    }

    /// intersected
    void* intersected(void* other) {
        return (cast(t_qp__qp_qp)pFunQt[21945])(_wh, other);
    }

    /// intersects
    bool intersects(void* r) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[21946])(_wh, r);
    }

    /// toRect
    DRect toRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[21947])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// toAlignedRect
    DRect toAlignedRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[21948])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
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

} // class QRectF
// ===AUTO-GENERATED-CLASS-END===
