#include "qte56_qbuttongroup.h"
#include <QButtonGroup>
#include <QAbstractButton>

void* qteQButtonGroup_create(void* parent) {
    return new QButtonGroup((QObject*)parent);
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
    QButtonGroup* bg = (QButtonGroup*)obj;
    // Qt6: only QAbstractButton* overload remains; get id via checkedId()
    QObject::connect(bg,
        &QButtonGroup::buttonClicked,
        [=](QAbstractButton* btn) { cbf(dthis, bg->id(btn)); });
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
    QButtonGroup* bg = (QButtonGroup*)obj;
    // Qt6: only QAbstractButton*+bool overload remains; get id via id()
    QObject::connect(bg,
        &QButtonGroup::buttonToggled,
        [=](QAbstractButton* btn, bool checked) { cbf(dthis, bg->id(btn), checked ? 1 : 0); });
}
