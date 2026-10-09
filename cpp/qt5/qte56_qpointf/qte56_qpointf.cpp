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
#define QTE56_QPOINTF_BUILD
#include "qte56_qpointf.h"
#include <QPointF>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQPointF_create(void* parent) {
    return new QPointF();
}

void qteQPointF_delete(void* w) {
    delete (QPointF*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
double qteQPointF_manhattanLength(void* _obj) {
    return ((QPointF*)_obj)->manhattanLength();
}

int qteQPointF_isNull(void* _obj) {
    return ((QPointF*)_obj)->isNull() ? 1 : 0;
}

double qteQPointF_x(void* _obj) {
    return ((QPointF*)_obj)->x();
}

double qteQPointF_y(void* _obj) {
    return ((QPointF*)_obj)->y();
}

void qteQPointF_setX(void* _obj, double x) {
    ((QPointF*)_obj)->setX(x);
}

void qteQPointF_setY(void* _obj, double y) {
    ((QPointF*)_obj)->setY(y);
}

void* qteQPointF_toPoint(void* _obj) {
    return new QPoint(((QPointF*)_obj)->toPoint());
}

} // extern "C"
