#ifndef QTE56_QIMAGEWRITER_BUILD
#define QTE56_QIMAGEWRITER_BUILD
#endif
#include "qte56_qimagewriter.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QImageWriter>
#include <QImage>
#include <QString>
#include <QByteArray>

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────

void* qteQImageWriter_create() {
    return new QImageWriter();
}

void* qteQImageWriter_create_file(void* path) {
    QString qs = *(QString*)path;
    return new QImageWriter(qs);
}

void qteQImageWriter_delete(void* w) {
    delete (QImageWriter*)w;
}

// ── File ──────────────────────────────────────────────────────────────────

void qteQImageWriter_setFileName(void* w, void* path) {
    QString qs = *(QString*)path;
    ((QImageWriter*)w)->setFileName(qs);
}

int qteQImageWriter_fileName(void* w, char16_t* buf, int buf_len) {
    QString s = ((QImageWriter*)w)->fileName();
    int len = qMin(s.length(), buf_len);
    memcpy(buf, s.utf16(), len * sizeof(char16_t));
    return len;
}

// ── Write ─────────────────────────────────────────────────────────────────

int qteQImageWriter_canWrite(void* w) {
    return ((QImageWriter*)w)->canWrite() ? 1 : 0;
}

int qteQImageWriter_write(void* w, void* image) {
    return ((QImageWriter*)w)->write(*(const QImage*)image) ? 1 : 0;
}

// ── Format / quality ──────────────────────────────────────────────────────

void qteQImageWriter_setFormat(void* w, const char* fmt, int fmt_len) {
    QByteArray ba(fmt, fmt_len);
    ((QImageWriter*)w)->setFormat(ba);
}

void qteQImageWriter_setQuality(void* w, int quality) {
    ((QImageWriter*)w)->setQuality(quality);
}

// ── Error ─────────────────────────────────────────────────────────────────

int qteQImageWriter_error(void* w) {
    return (int)((QImageWriter*)w)->error();
}

int qteQImageWriter_errorString(void* w, char16_t* buf, int buf_len) {
    QString s = ((QImageWriter*)w)->errorString();
    int len = qMin(s.length(), buf_len);
    memcpy(buf, s.utf16(), len * sizeof(char16_t));
    return len;
}

} // extern "C"
