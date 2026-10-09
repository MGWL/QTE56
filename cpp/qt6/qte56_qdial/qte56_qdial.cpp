#ifndef QTE56_QDIAL_BUILD
#define QTE56_QDIAL_BUILD
#endif
#include "qte56_qdial.h"
#include <QDial>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQDial_create(void* parent) {
    return new QDial((QWidget*)parent);
}

void qteQDial_delete(void* w) {
    delete (QDial*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQDial_wrapping(void* _obj) {
    return ((QDial*)_obj)->wrapping() ? 1 : 0;
}

int qteQDial_notchSize(void* _obj) {
    return ((QDial*)_obj)->notchSize();
}

void qteQDial_setNotchTarget(void* _obj, double target) {
    ((QDial*)_obj)->setNotchTarget(target);
}

double qteQDial_notchTarget(void* _obj) {
    return ((QDial*)_obj)->notchTarget();
}

int qteQDial_notchesVisible(void* _obj) {
    return ((QDial*)_obj)->notchesVisible() ? 1 : 0;
}

void qteQDial_setNotchesVisible(void* _obj, int visible) {
    ((QDial*)_obj)->setNotchesVisible((visible != 0));
}

void qteQDial_setWrapping(void* _obj, int on) {
    ((QDial*)_obj)->setWrapping((on != 0));
}

} // extern "C"
