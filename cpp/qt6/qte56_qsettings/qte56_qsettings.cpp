#ifndef QTE56_QSETTINGS_BUILD
#define QTE56_QSETTINGS_BUILD
#endif
#include "qte56_qsettings.h"
#include <QSettings>
#include <QByteArray>
#include <QVariant>
#include <QString>
#include <QVariant>

// Helper: build QString from char16_t buffer
static inline QString qs(void* p) {
    return *(QString*)p;
}

// ── Lifecycle ─────────────────────────────────────────────────────────────────

void* qteQSettings_create_app(void* org,
                               void* app,
                               void* parent) {
    return new QSettings(qs(org), qs(app), (QObject*)parent);
}

void* qteQSettings_create_file(void* fname,
                                int format, void* parent) {
    return new QSettings(qs(fname),
                         (QSettings::Format)format, (QObject*)parent);
}

void qteQSettings_delete(void* s) {
    delete (QSettings*)s;
}

// ── String values ─────────────────────────────────────────────────────────────

void qteQSettings_setValue_s(void* s, void* key,
                              void* val) {
    ((QSettings*)s)->setValue(qs(key), QVariant(qs(val)));
}

void* qteQSettings_value_s(void* s, void* key,
                            void* defval) {
    QVariant v = ((QSettings*)s)->value(qs(key), QVariant(qs(defval)));
    return new QString(v.toString());
}

// ── Integer values ────────────────────────────────────────────────────────────

void qteQSettings_setValue_i(void* s, void* key, int val) {
    ((QSettings*)s)->setValue(qs(key), QVariant(val));
}

int qteQSettings_value_i(void* s, void* key, int defval) {
    return ((QSettings*)s)->value(qs(key), QVariant(defval)).toInt();
}

// ── Boolean values ────────────────────────────────────────────────────────────

void qteQSettings_setValue_b(void* s, void* key, int val) {
    ((QSettings*)s)->setValue(qs(key), QVariant(val != 0));
}

int qteQSettings_value_b(void* s, void* key, int defval) {
    return ((QSettings*)s)->value(qs(key), QVariant(defval != 0)).toBool() ? 1 : 0;
}

// ── Double values ─────────────────────────────────────────────────────────────

void qteQSettings_setValue_d(void* s, void* key, double val) {
    ((QSettings*)s)->setValue(qs(key), QVariant(val));
}

double qteQSettings_value_d(void* s, void* key, double defval) {
    return ((QSettings*)s)->value(qs(key), QVariant(defval)).toDouble();
}

// ── Key management ────────────────────────────────────────────────────────────

int qteQSettings_contains(void* s, void* key) {
    return ((QSettings*)s)->contains(qs(key)) ? 1 : 0;
}

void qteQSettings_remove(void* s, void* key) {
    ((QSettings*)s)->remove(qs(key));
}

void qteQSettings_clear(void* s) {
    ((QSettings*)s)->clear();
}

void qteQSettings_sync(void* s) {
    ((QSettings*)s)->sync();
}

// ── Groups ────────────────────────────────────────────────────────────────────

void qteQSettings_beginGroup(void* s, void* prefix) {
    ((QSettings*)s)->beginGroup(qs(prefix));
}

void qteQSettings_endGroup(void* s) {
    ((QSettings*)s)->endGroup();
}

void* qteQSettings_group(void* s) {
    return new QString(((QSettings*)s)->group());
}

// ── Status ────────────────────────────────────────────────────────────────────

int qteQSettings_status(void* s) {
    return (int)((QSettings*)s)->status();
}

int qteQSettings_isWritable(void* s) {
    return ((QSettings*)s)->isWritable() ? 1 : 0;
}

void* qteQSettings_fileName(void* s) {
    return new QString(((QSettings*)s)->fileName());
}

// ── Binary values ─────────────────────────────────────────────────────────────

void qteQSettings_setValue_ba(void* s, void* key, const void* data, int len) {
    QByteArray ba((const char*)data, len);
    ((QSettings*)s)->setValue(qs(key), QVariant(ba));
}

void* qteQSettings_value_ba(void* s, void* key) {
    QVariant v = ((QSettings*)s)->value(qs(key));
    if (!v.isValid() || v.isNull()) return nullptr;
    QByteArray ba = v.toByteArray();
    if (ba.isEmpty()) return nullptr;
    return new QByteArray(ba);
}
