#ifndef QTE56_QIMAGE_BUILD
#define QTE56_QIMAGE_BUILD
#endif
#include "qte56_qimage.h"
#include <QImage>
#include <QPixmap>
#include <QColor>
#include <QString>
#include <QByteArray>
#include <QBuffer>

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────

void* qteQImage_create() {
    return new QImage();
}

void* qteQImage_create_wh(int w, int h, int format) {
    return new QImage(w, h, (QImage::Format)format);
}

void* qteQImage_from_file(void* path) {
    QString qs = *(QString*)path;
    return new QImage(qs);
}

void qteQImage_delete(void* w) {
    delete (QImage*)w;
}

// ── Properties ────────────────────────────────────────────────────────────

int qteQImage_isNull(void* w) {
    return ((QImage*)w)->isNull() ? 1 : 0;
}

int qteQImage_width(void* w) {
    return ((QImage*)w)->width();
}

int qteQImage_height(void* w) {
    return ((QImage*)w)->height();
}

int qteQImage_depth(void* w) {
    return ((QImage*)w)->depth();
}

int qteQImage_format(void* w) {
    return (int)((QImage*)w)->format();
}

int qteQImage_bytesPerLine(void* w) {
    return ((QImage*)w)->bytesPerLine();
}

int qteQImage_sizeInBytes(void* w) {
    return (int)((QImage*)w)->sizeInBytes();
}

// ── Raw data access ───────────────────────────────────────────────────────

void* qteQImage_bits(void* w) {
    return (void*)((QImage*)w)->bits();
}

const void* qteQImage_constBits(void* w) {
    return (const void*)((QImage*)w)->constBits();
}

// ── Fill ──────────────────────────────────────────────────────────────────

void qteQImage_fill_rgb(void* w, int r, int g, int b, int a) {
    ((QImage*)w)->fill(QColor(r, g, b, a));
}

void qteQImage_fill_gc(void* w, int gc) {
    ((QImage*)w)->fill((Qt::GlobalColor)gc);
}

// ── Pixel access ──────────────────────────────────────────────────────────

unsigned int qteQImage_pixel(void* w, int x, int y) {
    return ((QImage*)w)->pixel(x, y);
}

void qteQImage_setPixel(void* w, int x, int y, unsigned int rgb) {
    ((QImage*)w)->setPixel(x, y, rgb);
}

void* qteQImage_pixelColor(void* w, int x, int y) {
    return new QColor(((QImage*)w)->pixelColor(x, y));
}

void qteQImage_setPixelColor(void* w, int x, int y, void* color) {
    ((QImage*)w)->setPixelColor(x, y, *(const QColor*)color);
}

int qteQImage_valid(void* w, int x, int y) {
    return ((QImage*)w)->valid(x, y) ? 1 : 0;
}

// ── Load / Save ───────────────────────────────────────────────────────────

int qteQImage_load(void* w, void* path) {
    QString qs = *(QString*)path;
    return ((QImage*)w)->load(qs) ? 1 : 0;
}

int qteQImage_save(void* w, void* path, int quality) {
    QString qs = *(QString*)path;
    return ((QImage*)w)->save(qs, nullptr, quality) ? 1 : 0;
}

// ── Transforms ────────────────────────────────────────────────────────────

void* qteQImage_scaled(void* w, int width, int height, int aspectMode, int transformMode) {
    return new QImage(((QImage*)w)->scaled(
        width, height, (Qt::AspectRatioMode)aspectMode, (Qt::TransformationMode)transformMode));
}

void* qteQImage_scaledToWidth(void* w, int width, int mode) {
    return new QImage(((QImage*)w)->scaledToWidth(width, (Qt::TransformationMode)mode));
}

void* qteQImage_scaledToHeight(void* w, int height, int mode) {
    return new QImage(((QImage*)w)->scaledToHeight(height, (Qt::TransformationMode)mode));
}

void* qteQImage_mirrored(void* w, int horiz, int vert) {
    return new QImage(((QImage*)w)->mirrored(horiz != 0, vert != 0));
}

void* qteQImage_copy_rect(void* w, int x, int y, int cw, int ch) {
    return new QImage(((QImage*)w)->copy(x, y, cw, ch));
}

void* qteQImage_convertToFormat(void* w, int fmt) {
    return new QImage(((QImage*)w)->convertToFormat((QImage::Format)fmt));
}

void qteQImage_invertPixels(void* w, int mode) {
    ((QImage*)w)->invertPixels((QImage::InvertMode)mode);
}

// ── Alpha ─────────────────────────────────────────────────────────────────

int qteQImage_hasAlphaChannel(void* w) {
    return ((QImage*)w)->hasAlphaChannel() ? 1 : 0;
}

void qteQImage_setAlphaChannel(void* w, void* alphaChannel) {
    ((QImage*)w)->setAlphaChannel(*(const QImage*)alphaChannel);
}

void* qteQImage_createAlphaMask(void* w) {
    return new QImage(((QImage*)w)->createAlphaMask());
}

// ── Misc ──────────────────────────────────────────────────────────────────

void* qteQImage_rgbSwapped(void* w) {
    return new QImage(((QImage*)w)->rgbSwapped());
}

void* qteQImage_toPixmap(void* w) {
    return new QPixmap(QPixmap::fromImage(*(QImage*)w));
}

void* qteQImage_fromPixmap(void* pixmap) {
    return new QImage(((QPixmap*)pixmap)->toImage());
}

// ── DPI ───────────────────────────────────────────────────────────────────

void qteQImage_setDotsPerMeterX(void* w, int dpm) {
    ((QImage*)w)->setDotsPerMeterX(dpm);
}

void qteQImage_setDotsPerMeterY(void* w, int dpm) {
    ((QImage*)w)->setDotsPerMeterY(dpm);
}

int qteQImage_dotsPerMeterX(void* w) {
    return ((QImage*)w)->dotsPerMeterX();
}

int qteQImage_dotsPerMeterY(void* w) {
    return ((QImage*)w)->dotsPerMeterY();
}


// ── Memory I/O ────────────────────────────────────────────────────────────

int qteQImage_loadFromData(void* img, const void* data, int len, const void* fmt, int fmtLen) {
    QByteArray ba((const char*)data, len);
    QByteArray fmtBa;
    const char* fmtStr = nullptr;
    if (fmtLen > 0) {
        fmtBa = QByteArray((const char*)fmt, fmtLen);
        fmtStr = fmtBa.constData();
    }
    return ((QImage*)img)->loadFromData(ba, fmtStr) ? 1 : 0;
}

void* qteQImage_saveToBuffer(void* img, const void* fmt, int fmtLen, int quality) {
    QByteArray* ba = new QByteArray();
    QBuffer buf(ba);
    buf.open(QIODevice::WriteOnly);
    QByteArray fmtBa = (fmtLen > 0) ? QByteArray((const char*)fmt, fmtLen) : QByteArray("PNG");
    bool ok = ((QImage*)img)->save(&buf, fmtBa.constData(), quality);
    buf.close();
    if (!ok) { delete ba; return nullptr; }
    return ba;
}

} // extern "C"
