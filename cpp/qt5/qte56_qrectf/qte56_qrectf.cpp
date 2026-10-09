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
#define QTE56_QRECTF_BUILD
#include "qte56_qrectf.h"
#include <QRectF>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQRectF_create(void* parent) {
    return new QRectF();
}

void qteQRectF_delete(void* w) {
    delete (QRectF*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQRectF_isNull(void* _obj) {
    return ((QRectF*)_obj)->isNull() ? 1 : 0;
}

int qteQRectF_isEmpty(void* _obj) {
    return ((QRectF*)_obj)->isEmpty() ? 1 : 0;
}

int qteQRectF_isValid(void* _obj) {
    return ((QRectF*)_obj)->isValid() ? 1 : 0;
}

void* qteQRectF_normalized(void* _obj) {
    return new QRectF(((QRectF*)_obj)->normalized());
}

double qteQRectF_x(void* _obj) {
    return ((QRectF*)_obj)->x();
}

double qteQRectF_y(void* _obj) {
    return ((QRectF*)_obj)->y();
}

void qteQRectF_setLeft(void* _obj, double pos) {
    ((QRectF*)_obj)->setLeft(pos);
}

void qteQRectF_setTop(void* _obj, double pos) {
    ((QRectF*)_obj)->setTop(pos);
}

void qteQRectF_setRight(void* _obj, double pos) {
    ((QRectF*)_obj)->setRight(pos);
}

void qteQRectF_setBottom(void* _obj, double pos) {
    ((QRectF*)_obj)->setBottom(pos);
}

void* qteQRectF_center(void* _obj) {
    return new QPointF(((QRectF*)_obj)->center());
}

void qteQRectF_setTopLeft(void* _obj, void* p) {
    ((QRectF*)_obj)->setTopLeft(*(const QPointF*)p);
}

void qteQRectF_setBottomRight(void* _obj, void* p) {
    ((QRectF*)_obj)->setBottomRight(*(const QPointF*)p);
}

void qteQRectF_setTopRight(void* _obj, void* p) {
    ((QRectF*)_obj)->setTopRight(*(const QPointF*)p);
}

void qteQRectF_setBottomLeft(void* _obj, void* p) {
    ((QRectF*)_obj)->setBottomLeft(*(const QPointF*)p);
}

void qteQRectF_moveLeft(void* _obj, double pos) {
    ((QRectF*)_obj)->moveLeft(pos);
}

void qteQRectF_moveTop(void* _obj, double pos) {
    ((QRectF*)_obj)->moveTop(pos);
}

void qteQRectF_moveRight(void* _obj, double pos) {
    ((QRectF*)_obj)->moveRight(pos);
}

void qteQRectF_moveBottom(void* _obj, double pos) {
    ((QRectF*)_obj)->moveBottom(pos);
}

void qteQRectF_moveTopLeft(void* _obj, void* p) {
    ((QRectF*)_obj)->moveTopLeft(*(const QPointF*)p);
}

void qteQRectF_moveBottomRight(void* _obj, void* p) {
    ((QRectF*)_obj)->moveBottomRight(*(const QPointF*)p);
}

void qteQRectF_moveTopRight(void* _obj, void* p) {
    ((QRectF*)_obj)->moveTopRight(*(const QPointF*)p);
}

void qteQRectF_moveBottomLeft(void* _obj, void* p) {
    ((QRectF*)_obj)->moveBottomLeft(*(const QPointF*)p);
}

void qteQRectF_moveCenter(void* _obj, void* p) {
    ((QRectF*)_obj)->moveCenter(*(const QPointF*)p);
}

void qteQRectF_translate_dd(void* _obj, double dx, double dy) {
    ((QRectF*)_obj)->translate(dx, dy);
}

void qteQRectF_translate_pf(void* _obj, void* p) {
    ((QRectF*)_obj)->translate(*(const QPointF*)p);
}

void* qteQRectF_translated_dd(void* _obj, double dx, double dy) {
    return new QRectF(((QRectF*)_obj)->translated(dx, dy));
}

void* qteQRectF_translated_pf(void* _obj, void* p) {
    return new QRectF(((QRectF*)_obj)->translated(*(const QPointF*)p));
}

void* qteQRectF_transposed(void* _obj) {
    return new QRectF(((QRectF*)_obj)->transposed());
}

void qteQRectF_moveTo_dd(void* _obj, double x, double y) {
    ((QRectF*)_obj)->moveTo(x, y);
}

void qteQRectF_moveTo_pf(void* _obj, void* p) {
    ((QRectF*)_obj)->moveTo(*(const QPointF*)p);
}

void qteQRectF_setRect(void* _obj, double x, double y, double w, double h) {
    ((QRectF*)_obj)->setRect(x, y, w, h);
}

void qteQRectF_setCoords(void* _obj, double x1, double y1, double x2, double y2) {
    ((QRectF*)_obj)->setCoords(x1, y1, x2, y2);
}

void qteQRectF_adjust(void* _obj, double x1, double y1, double x2, double y2) {
    ((QRectF*)_obj)->adjust(x1, y1, x2, y2);
}

void* qteQRectF_adjusted(void* _obj, double x1, double y1, double x2, double y2) {
    return new QRectF(((QRectF*)_obj)->adjusted(x1, y1, x2, y2));
}

double qteQRectF_width(void* _obj) {
    return ((QRectF*)_obj)->width();
}

double qteQRectF_height(void* _obj) {
    return ((QRectF*)_obj)->height();
}

void qteQRectF_setWidth(void* _obj, double w) {
    ((QRectF*)_obj)->setWidth(w);
}

void qteQRectF_setHeight(void* _obj, double h) {
    ((QRectF*)_obj)->setHeight(h);
}

int qteQRectF_contains_rf(void* _obj, void* r) {
    return ((QRectF*)_obj)->contains(*(const QRectF*)r) ? 1 : 0;
}

int qteQRectF_contains_pf(void* _obj, void* p) {
    return ((QRectF*)_obj)->contains(*(const QPointF*)p) ? 1 : 0;
}

int qteQRectF_contains_dd(void* _obj, double x, double y) {
    return ((QRectF*)_obj)->contains(x, y) ? 1 : 0;
}

void* qteQRectF_united(void* _obj, void* other) {
    return new QRectF(((QRectF*)_obj)->united(*(const QRectF*)other));
}

void* qteQRectF_intersected(void* _obj, void* other) {
    return new QRectF(((QRectF*)_obj)->intersected(*(const QRectF*)other));
}

int qteQRectF_intersects(void* _obj, void* r) {
    return ((QRectF*)_obj)->intersects(*(const QRectF*)r) ? 1 : 0;
}

void* qteQRectF_toRect(void* _obj) {
    return new QRect(((QRectF*)_obj)->toRect());
}

void* qteQRectF_toAlignedRect(void* _obj) {
    return new QRect(((QRectF*)_obj)->toAlignedRect());
}

} // extern "C"
