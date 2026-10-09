#ifndef QTE56_QBYTEARRAY_BUILD
#define QTE56_QBYTEARRAY_BUILD
#endif
#include "qte56_qbytearray.h"
#include <QByteArray>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────────

void* qteQByteArray_create() {
    return new QByteArray();
}
void* qteQByteArray_fromPtr(const void* data, int len) {
    return new QByteArray((const char*)data, len);
}
void qteQByteArray_delete(void* ba) {
    delete (QByteArray*)ba;
}
void* qteQByteArray_copy(void* ba) {
    return new QByteArray(*(QByteArray*)ba);
}

// ── Size / access ────────────────────────────────────────────────────────────

int qteQByteArray_size(void* ba) {
    return ((QByteArray*)ba)->size();
}
int qteQByteArray_isEmpty(void* ba) {
    return ((QByteArray*)ba)->isEmpty() ? 1 : 0;
}
const void* qteQByteArray_constData(void* ba) {
    return (const void*)((QByteArray*)ba)->constData();
}
int qteQByteArray_at(void* ba, int i) {
    return (unsigned char)((QByteArray*)ba)->at(i);
}
void qteQByteArray_set(void* ba, int i, int byte) {
    (*((QByteArray*)ba))[i] = (char)byte;
}

// ── Mutation ─────────────────────────────────────────────────────────────────

void qteQByteArray_append(void* ba, const void* data, int len) {
    ((QByteArray*)ba)->append((const char*)data, len);
}
void qteQByteArray_prepend(void* ba, const void* data, int len) {
    ((QByteArray*)ba)->prepend((const char*)data, len);
}
void qteQByteArray_resize(void* ba, int size) {
    ((QByteArray*)ba)->resize(size);
}
void qteQByteArray_clear(void* ba) {
    ((QByteArray*)ba)->clear();
}
void qteQByteArray_chop(void* ba, int n) {
    ((QByteArray*)ba)->chop(n);
}

// ── Slicing / transform ──────────────────────────────────────────────────────

void* qteQByteArray_mid(void* ba, int pos, int len) {
    return new QByteArray(((QByteArray*)ba)->mid(pos, len));
}
void* qteQByteArray_left(void* ba, int n) {
    return new QByteArray(((QByteArray*)ba)->left(n));
}
void* qteQByteArray_right(void* ba, int n) {
    return new QByteArray(((QByteArray*)ba)->right(n));
}
void* qteQByteArray_toUpper(void* ba) {
    return new QByteArray(((QByteArray*)ba)->toUpper());
}
void* qteQByteArray_toLower(void* ba) {
    return new QByteArray(((QByteArray*)ba)->toLower());
}
void* qteQByteArray_trimmed(void* ba) {
    return new QByteArray(((QByteArray*)ba)->trimmed());
}

// ── Search ───────────────────────────────────────────────────────────────────

int qteQByteArray_indexOf(void* ba, const void* data, int len, int from) {
    return ((QByteArray*)ba)->indexOf(QByteArray((const char*)data, len), from);
}
int qteQByteArray_contains(void* ba, const void* data, int len) {
    return ((QByteArray*)ba)->contains(QByteArray((const char*)data, len)) ? 1 : 0;
}
int qteQByteArray_startsWith(void* ba, const void* data, int len) {
    return ((QByteArray*)ba)->startsWith(QByteArray((const char*)data, len)) ? 1 : 0;
}
int qteQByteArray_endsWith(void* ba, const void* data, int len) {
    return ((QByteArray*)ba)->endsWith(QByteArray((const char*)data, len)) ? 1 : 0;
}

// ── Encoding ─────────────────────────────────────────────────────────────────

void* qteQByteArray_toHex(void* ba) {
    return new QByteArray(((QByteArray*)ba)->toHex());
}
void* qteQByteArray_toBase64(void* ba) {
    return new QByteArray(((QByteArray*)ba)->toBase64());
}
void* qteQByteArray_fromBase64(void* ba) {
    return new QByteArray(QByteArray::fromBase64(*(QByteArray*)ba));
}

// ── QString interop ──────────────────────────────────────────────────────────

void* qteQByteArray_toQString(void* ba) {
    return new QString(QString::fromUtf8(*(QByteArray*)ba));
}
void* qteQByteArray_fromQString(void* qs) {
    return new QByteArray(((QString*)qs)->toUtf8());
}

// ── Comparison ───────────────────────────────────────────────────────────────

int qteQByteArray_equal(void* a, void* b) {
    return (*(QByteArray*)a == *(QByteArray*)b) ? 1 : 0;
}

} // extern "C"
