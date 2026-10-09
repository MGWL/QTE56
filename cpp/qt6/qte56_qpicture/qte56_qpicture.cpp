#ifndef QTE56_QPICTURE_BUILD
#define QTE56_QPICTURE_BUILD
#endif
#include "qte56_qpicture.h"
#include <QPicture>
#include <QPainter>
#include <QString>
#include <QRect>

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────

void* qteQPicture_create() {
    return new QPicture();
}

void qteQPicture_delete(void* w) {
    delete (QPicture*)w;
}

// ── Properties ────────────────────────────────────────────────────────────

int qteQPicture_isNull(void* w) {
    return ((QPicture*)w)->isNull() ? 1 : 0;
}

// ── Play ──────────────────────────────────────────────────────────────────

int qteQPicture_play(void* w, void* painter) {
    return ((QPicture*)w)->play((QPainter*)painter) ? 1 : 0;
}

// ── Load / Save ───────────────────────────────────────────────────────────

int qteQPicture_load(void* w, void* path) {
    QString qs = *(QString*)path;
    return ((QPicture*)w)->load(qs) ? 1 : 0;
}

int qteQPicture_save(void* w, void* path) {
    QString qs = *(QString*)path;
    return ((QPicture*)w)->save(qs) ? 1 : 0;
}

// ── Size / Bounds ─────────────────────────────────────────────────────────

int qteQPicture_size(void* w) {
    return ((QPicture*)w)->size();
}

void qteQPicture_boundingRect(void* w, int* x, int* y, int* bw, int* bh) {
    QRect r = ((QPicture*)w)->boundingRect();
    *x = r.x();
    *y = r.y();
    *bw = r.width();
    *bh = r.height();
}

void qteQPicture_setBoundingRect(void* w, int x, int y, int bw, int bh) {
    ((QPicture*)w)->setBoundingRect(QRect(x, y, bw, bh));
}

} // extern "C"
