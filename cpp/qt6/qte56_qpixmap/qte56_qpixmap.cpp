#ifndef QTE56_QPIXMAP_BUILD
#define QTE56_QPIXMAP_BUILD
#endif
#include "qte56_qpixmap.h"
#include <QPixmap>
#include <QLabel>
#include <QString>
#include <QByteArray>
#include <QBuffer>

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────

void* qteQPixmap_create() {
    return new QPixmap();  // null/empty pixmap
}

void* qteQPixmap_from_file(void* path) {
    QString qs = *(QString*)path;
    return new QPixmap(qs);
}

void* qteQPixmap_from_wh(int w, int h) {
    return new QPixmap(w, h);
}

void qteQPixmap_delete(void* w) {
    delete (QPixmap*)w;
}

// ── Properties ────────────────────────────────────────────────────────────

int qteQPixmap_isNull(void* w) {
    return ((QPixmap*)w)->isNull() ? 1 : 0;
}

int qteQPixmap_width(void* w) {
    return ((QPixmap*)w)->width();
}

int qteQPixmap_height(void* w) {
    return ((QPixmap*)w)->height();
}

// ── Load / Save ───────────────────────────────────────────────────────────

int qteQPixmap_load(void* w, void* path) {
    QString qs = *(QString*)path;
    return ((QPixmap*)w)->load(qs) ? 1 : 0;
}

int qteQPixmap_save(void* w, void* path) {
    QString qs = *(QString*)path;
    return ((QPixmap*)w)->save(qs) ? 1 : 0;
}

// ── Transforms ────────────────────────────────────────────────────────────

void* qteQPixmap_scaled(void* w, int width, int height, int aspectMode) {
    return new QPixmap(((QPixmap*)w)->scaled(
        width, height, (Qt::AspectRatioMode)aspectMode));
}

void* qteQPixmap_scaledToWidth(void* w, int width) {
    return new QPixmap(((QPixmap*)w)->scaledToWidth(width));
}

void* qteQPixmap_scaledToHeight(void* w, int height) {
    return new QPixmap(((QPixmap*)w)->scaledToHeight(height));
}

// ── Fill ──────────────────────────────────────────────────────────────────

void qteQPixmap_fill(void* w, int r, int g, int b, int a) {
    ((QPixmap*)w)->fill(QColor(r, g, b, a));
}

// ── QLabel helper ─────────────────────────────────────────────────────────

void qteQLabel_setPixmap(void* label, void* pixmap) {
    ((QLabel*)label)->setPixmap(*(QPixmap*)pixmap);
}


// ── Memory I/O ────────────────────────────────────────────────────────────

int qteQPixmap_loadFromData(void* pxm, const void* data, int len, const void* fmt, int fmtLen) {
    QByteArray ba((const char*)data, len);
    QByteArray fmtBa;
    const char* fmtStr = nullptr;
    if (fmtLen > 0) {
        fmtBa = QByteArray((const char*)fmt, fmtLen);
        fmtStr = fmtBa.constData();
    }
    return ((QPixmap*)pxm)->loadFromData(ba, fmtStr) ? 1 : 0;
}

void* qteQPixmap_saveToBuffer(void* pxm, const void* fmt, int fmtLen, int quality) {
    QByteArray* ba = new QByteArray();
    QBuffer buf(ba);
    buf.open(QIODevice::WriteOnly);
    QByteArray fmtBa = (fmtLen > 0) ? QByteArray((const char*)fmt, fmtLen) : QByteArray("PNG");
    bool ok = ((QPixmap*)pxm)->save(&buf, fmtBa.constData(), quality);
    buf.close();
    if (!ok) { delete ba; return nullptr; }
    return ba;
}

} // extern "C"
