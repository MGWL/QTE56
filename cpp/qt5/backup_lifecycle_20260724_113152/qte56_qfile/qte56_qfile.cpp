#ifndef QTE56_QFILE_BUILD
#define QTE56_QFILE_BUILD
#endif
#include "qte56_qfile.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QFile>
#include <QString>
#include <QByteArray>
#include <cstdlib>
#include <cstring>

// Helper: build QString from char16_t buffer
static inline QString qs(void* p) {
    return *(QString*)p;
}

// ── Lifecycle ─────────────────────────────────────────────────────────────────

void* qteQFile_create() {
    return qte_createTracked(new QFile());
}

void* qteQFile_create_path(void* path) {
    return qte_createTracked(new QFile(qs(path)));
}

void qteQFile_delete(void* f) {
    delete (QFile*)f;
}

// ── Open / Close ──────────────────────────────────────────────────────────────

int qteQFile_open(void* f, int mode) {
    return ((QFile*)f)->open((QIODevice::OpenMode)mode) ? 1 : 0;
}

void qteQFile_close(void* f) {
    ((QFile*)f)->close();
}

int qteQFile_isOpen(void* f) {
    return ((QFile*)f)->isOpen() ? 1 : 0;
}

// ── File name ─────────────────────────────────────────────────────────────────

void* qteQFile_fileName(void* f) {
    return new QString(((QFile*)f)->fileName());
}

void qteQFile_setFileName(void* f, void* path) {
    ((QFile*)f)->setFileName(qs(path));
}

// ── Existence ─────────────────────────────────────────────────────────────────

int qteQFile_exists(void* f) {
    return ((QFile*)f)->exists() ? 1 : 0;
}

int qteQFile_exists_static(void* path) {
    return QFile::exists(qs(path)) ? 1 : 0;
}

// ── Size / Position ───────────────────────────────────────────────────────────

int qteQFile_size(void* f) {
    return (int)((QFile*)f)->size();
}

int qteQFile_pos(void* f) {
    return (int)((QFile*)f)->pos();
}

int qteQFile_seek(void* f, int pos) {
    return ((QFile*)f)->seek((qint64)pos) ? 1 : 0;
}

int qteQFile_atEnd(void* f) {
    return ((QFile*)f)->atEnd() ? 1 : 0;
}

// ── Read / Write ──────────────────────────────────────────────────────────────

void* qteQFile_readAll(void* f, int* outLen) {
    QByteArray ba = ((QFile*)f)->readAll();
    *outLen = ba.size();
    if (ba.isEmpty()) return nullptr;
    void* buf = malloc(ba.size());
    memcpy(buf, ba.constData(), ba.size());
    return buf;
}

void qteQFile_freeBuffer(void* buf) {
    free(buf);
}

int qteQFile_write(void* f, const void* data, int len) {
    return (int)((QFile*)f)->write((const char*)data, (qint64)len);
}

int qteQFile_flush(void* f) {
    return ((QFile*)f)->flush() ? 1 : 0;
}

// ── File operations ───────────────────────────────────────────────────────────

int qteQFile_remove(void* f) {
    return ((QFile*)f)->remove() ? 1 : 0;
}

int qteQFile_remove_static(void* path) {
    return QFile::remove(qs(path)) ? 1 : 0;
}

int qteQFile_rename(void* f, void* newName) {
    return ((QFile*)f)->rename(qs(newName)) ? 1 : 0;
}

int qteQFile_copy(void* f, void* newName) {
    return ((QFile*)f)->copy(qs(newName)) ? 1 : 0;
}

int qteQFile_copy_static(void* src,
                          void* dst) {
    return QFile::copy(qs(src), qs(dst)) ? 1 : 0;
}

// ── Error ─────────────────────────────────────────────────────────────────────

int qteQFile_error(void* f) {
    return (int)((QFile*)f)->error();
}

void* qteQFile_errorString(void* f) {
    return new QString(((QFile*)f)->errorString());
}

// ── Permissions / Resize ──────────────────────────────────────────────────────

int qteQFile_permissions(void* f) {
    return (int)((QFile*)f)->permissions();
}

int qteQFile_setPermissions(void* f, int perms) {
    return ((QFile*)f)->setPermissions((QFileDevice::Permissions)perms) ? 1 : 0;
}

int qteQFile_resize(void* f, int sz) {
    return ((QFile*)f)->resize((qint64)sz) ? 1 : 0;
}

// ── Text convenience ──────────────────────────────────────────────────────────

void* qteQFile_readAll_text(void* f) {
    return new QString(((QFile*)f)->readAll());
}
