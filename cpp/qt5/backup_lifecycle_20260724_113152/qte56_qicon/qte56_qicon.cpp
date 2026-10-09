#ifndef QTE56_QICON_BUILD
#define QTE56_QICON_BUILD
#endif
#include "qte56_qicon.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QIcon>
#include <QString>
#include <QSize>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────────

void* qteQIcon_create(void* reserved) {
    (void)reserved;
    return new QIcon();
}

void* qteQIcon_create_file(void* path) {
    return new QIcon(*(QString*)path);
}

void qteQIcon_delete(void* icon) {
    delete (QIcon*)icon;
}

// ── Methods ──────────────────────────────────────────────────────────────────

int qteQIcon_isNull(void* icon) {
    return ((QIcon*)icon)->isNull() ? 1 : 0;
}

void* qteQIcon_name(void* icon) {
    return new QString(((QIcon*)icon)->name());
}

long long qteQIcon_cacheKey(void* icon) {
    return ((QIcon*)icon)->cacheKey();
}

int qteQIcon_isMask(void* icon) {
    return ((QIcon*)icon)->isMask() ? 1 : 0;
}

void qteQIcon_setIsMask(void* icon, int mask) {
    ((QIcon*)icon)->setIsMask(mask != 0);
}

void qteQIcon_addFile(void* icon, void* path,
                       int w, int h, int mode, int state) {
    ((QIcon*)icon)->addFile(
        *(QString*)path,
        QSize(w, h),
        (QIcon::Mode)mode,
        (QIcon::State)state
    );
}

void* qteQIcon_actualSize(void* icon, int w, int h, int mode, int state) {
    return new QSize(((QIcon*)icon)->actualSize(
        QSize(w, h),
        (QIcon::Mode)mode,
        (QIcon::State)state
    ));
}

// ── Static ───────────────────────────────────────────────────────────────────

void* qteQIcon_fromTheme(void* name) {
    return new QIcon(QIcon::fromTheme(*(QString*)name));
}

int qteQIcon_hasThemeIcon(void* name) {
    return QIcon::hasThemeIcon(*(QString*)name) ? 1 : 0;
}

} // extern "C"
