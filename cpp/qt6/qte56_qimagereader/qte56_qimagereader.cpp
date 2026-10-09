#ifndef QTE56_QIMAGEREADER_BUILD
#define QTE56_QIMAGEREADER_BUILD
#endif
#include "qte56_qimagereader.h"
#include <QImageReader>
#include <QImage>
#include <QString>
#include <QByteArray>
#include <QSize>
#include <QList>

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────

void* qteQImageReader_create() {
    return new QImageReader();
}

void* qteQImageReader_create_file(void* path) {
    QString qs = *(QString*)path;
    return new QImageReader(qs);
}

void qteQImageReader_delete(void* w) {
    delete (QImageReader*)w;
}

// ── File ──────────────────────────────────────────────────────────────────

void qteQImageReader_setFileName(void* w, void* path) {
    QString qs = *(QString*)path;
    ((QImageReader*)w)->setFileName(qs);
}

int qteQImageReader_fileName(void* w, char16_t* buf, int buf_len) {
    QString s = ((QImageReader*)w)->fileName();
    int len = qMin(s.length(), buf_len);
    memcpy(buf, s.utf16(), len * sizeof(char16_t));
    return len;
}

// ── Read ──────────────────────────────────────────────────────────────────

int qteQImageReader_canRead(void* w) {
    return ((QImageReader*)w)->canRead() ? 1 : 0;
}

void* qteQImageReader_read(void* w) {
    QImage img = ((QImageReader*)w)->read();
    if (img.isNull()) return nullptr;
    return new QImage(img);
}

// ── Format ────────────────────────────────────────────────────────────────

int qteQImageReader_format(void* w, char* buf, int buf_len) {
    QByteArray ba = ((QImageReader*)w)->format();
    int len = qMin(ba.length(), buf_len);
    memcpy(buf, ba.constData(), len);
    return len;
}

void qteQImageReader_setFormat(void* w, const char* fmt, int fmt_len) {
    QByteArray ba(fmt, fmt_len);
    ((QImageReader*)w)->setFormat(ba);
}

// ── Size ──────────────────────────────────────────────────────────────────

void qteQImageReader_size(void* w, int* out_w, int* out_h) {
    QSize sz = ((QImageReader*)w)->size();
    *out_w = sz.width();
    *out_h = sz.height();
}

// ── Animation ─────────────────────────────────────────────────────────────

int qteQImageReader_imageCount(void* w) {
    return ((QImageReader*)w)->imageCount();
}

int qteQImageReader_currentImageNumber(void* w) {
    return ((QImageReader*)w)->currentImageNumber();
}

int qteQImageReader_jumpToImage(void* w, int n) {
    return ((QImageReader*)w)->jumpToImage(n) ? 1 : 0;
}

int qteQImageReader_jumpToNextImage(void* w) {
    return ((QImageReader*)w)->jumpToNextImage() ? 1 : 0;
}

// ── Options ───────────────────────────────────────────────────────────────

void qteQImageReader_setScaledSize(void* w, int sw, int sh) {
    ((QImageReader*)w)->setScaledSize(QSize(sw, sh));
}

void qteQImageReader_setAutoDetectImageFormat(void* w, int enable) {
    ((QImageReader*)w)->setAutoDetectImageFormat(enable != 0);
}

// ── Error ─────────────────────────────────────────────────────────────────

int qteQImageReader_error(void* w) {
    return (int)((QImageReader*)w)->error();
}

int qteQImageReader_errorString(void* w, char16_t* buf, int buf_len) {
    QString s = ((QImageReader*)w)->errorString();
    int len = qMin(s.length(), buf_len);
    memcpy(buf, s.utf16(), len * sizeof(char16_t));
    return len;
}

// ── Static ────────────────────────────────────────────────────────────────

int qteQImageReader_supportedImageFormats(char* buf, int buf_len) {
    QList<QByteArray> fmts = QImageReader::supportedImageFormats();
    QByteArray joined;
    for (int i = 0; i < fmts.size(); i++) {
        if (i > 0) joined.append(';');
        joined.append(fmts[i]);
    }
    int len = qMin(joined.length(), buf_len);
    memcpy(buf, joined.constData(), len);
    return len;
}

} // extern "C"
