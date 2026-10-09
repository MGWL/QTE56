#include "qte56_qbuttongroup.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QButtonGroup>
#include <QAbstractButton>

void* qteQButtonGroup_create(void* parent) {
    return qte_createTracked(new QButtonGroup((QObject*)parent);
}
void qteQButtonGroup_destroy(void* obj) {
    delete (QButtonGroup*)obj;
}

void qteQButtonGroup_setExclusive(void* obj, int v) {
    ((QButtonGroup*)obj)->setExclusive(v != 0);
}
int qteQButtonGroup_exclusive(void* obj) {
    return ((QButtonGroup*)obj)->exclusive() ? 1 : 0;
}

void qteQButtonGroup_addButton(void* obj, void* btn, int id) {
    ((QButtonGroup*)obj)->addButton((QAbstractButton*)btn, id);
}
void qteQButtonGroup_removeButton(void* obj, void* btn) {
    ((QButtonGroup*)obj)->removeButton((QAbstractButton*)btn);
}
void qteQButtonGroup_setId(void* obj, void* btn, int id) {
    ((QButtonGroup*)obj)->setId((QAbstractButton*)btn, id);
}
int qteQButtonGroup_id(void* obj, void* btn) {
    return ((QButtonGroup*)obj)->id((QAbstractButton*)btn);
}
int qteQButtonGroup_checkedId(void* obj) {
    return ((QButtonGroup*)obj)->checkedId();
}

void qteQButtonGroup_connect_buttonClicked(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*, int);
    auto cbf = (Cb)cb;
    // Use int overload: buttonClicked(int)
    QObject::connect((QButtonGroup*)obj,
        static_cast<void(QButtonGroup::*)(int)>(&QButtonGroup::buttonClicked),
        [=](int id) { cbf(dthis, id); });
}

void* qteQButtonGroup_buttons(void* _obj) {
    QList<QAbstractButton*> list = ((QButtonGroup*)_obj)->buttons();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}

void qteQButtonGroup_connect_buttonToggled(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*, int, int);
    auto cbf = (Cb)cb;
    // Use int+bool overload: buttonToggled(int, bool)
    QObject::connect((QButtonGroup*)obj,
        static_cast<void(QButtonGroup::*)(int, bool)>(&QButtonGroup::buttonToggled),
        [=](int id, bool checked) { cbf(dthis, id, checked ? 1 : 0); });
}
