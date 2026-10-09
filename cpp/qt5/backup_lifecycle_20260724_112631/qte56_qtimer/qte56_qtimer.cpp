#ifndef QTE56_QTIMER_BUILD
#define QTE56_QTIMER_BUILD
#endif
#include "qte56_qtimer.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTimer>
#include <QObject>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTimer_create(void* parent) {
    return qte_createTracked(new QTimer((QObject*)parent);
}

void qteQTimer_delete(void* w) {
    delete (QTimer*)w;
}

// ── Properties ───────────────────────────────────────────────────────────
int qteQTimer_interval(void* _obj) {
    return ((QTimer*)_obj)->interval();
}

int qteQTimer_isSingleShot(void* _obj) {
    return ((QTimer*)_obj)->isSingleShot() ? 1 : 0;
}

void qteQTimer_setInterval(void* _obj, int msec) {
    ((QTimer*)_obj)->setInterval(msec);
}

void qteQTimer_setSingleShot(void* _obj, int singleShot) {
    ((QTimer*)_obj)->setSingleShot((singleShot != 0));
}

int qteQTimer_remainingTime(void* _obj) {
    return ((QTimer*)_obj)->remainingTime();
}

int qteQTimer_isActive(void* _obj) {
    return ((QTimer*)_obj)->isActive() ? 1 : 0;
}

int qteQTimer_timerId(void* _obj) {
    return ((QTimer*)_obj)->timerId();
}

// ── Slots ────────────────────────────────────────────────────────────────
void qteQTimer_start_i(void* _obj, int msec) {
    ((QTimer*)_obj)->start(msec);
}

void qteQTimer_start_v(void* _obj) {
    ((QTimer*)_obj)->start();
}

void qteQTimer_stop(void* _obj) {
    ((QTimer*)_obj)->stop();
}

} // extern "C"
