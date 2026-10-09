#ifndef QTE56_QTOOLBOX_BUILD
#define QTE56_QTOOLBOX_BUILD
#endif
#include "qte56_qtoolbox.h"
#include <QToolBox>
#include <QIcon>
#include <QString>
#include <QCloseEvent>
#include <QContextMenuEvent>
#include <QFocusEvent>
#include <QHideEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QMoveEvent>
#include <QResizeEvent>
#include <QShowEvent>
#include <QWheelEvent>

// ─── Event proxy ──────────────────────────────────────────────────────────────
class eQToolBox : public QToolBox {
public:
    void* cb_01 = nullptr;  void* dt_01 = nullptr;  // 1: mousePressEvent
    void* cb_02 = nullptr;  void* dt_02 = nullptr;  // 2: mouseReleaseEvent
    void* cb_03 = nullptr;  void* dt_03 = nullptr;  // 3: mouseDoubleClickEvent
    void* cb_04 = nullptr;  void* dt_04 = nullptr;  // 4: mouseMoveEvent
    void* cb_05 = nullptr;  void* dt_05 = nullptr;  // 5: keyPressEvent
    void* cb_06 = nullptr;  void* dt_06 = nullptr;  // 6: keyReleaseEvent
    void* cb_07 = nullptr;  void* dt_07 = nullptr;  // 7: resizeEvent
    void* cb_08 = nullptr;  void* dt_08 = nullptr;  // 8: moveEvent
    void* cb_09 = nullptr;  void* dt_09 = nullptr;  // 9: closeEvent
    void* cb_10 = nullptr;  void* dt_10 = nullptr;  // 10: showEvent
    void* cb_11 = nullptr;  void* dt_11 = nullptr;  // 11: hideEvent
    void* cb_12 = nullptr;  void* dt_12 = nullptr;  // 12: enterEvent
    void* cb_13 = nullptr;  void* dt_13 = nullptr;  // 13: leaveEvent
    void* cb_14 = nullptr;  void* dt_14 = nullptr;  // 14: wheelEvent
    void* cb_15 = nullptr;  void* dt_15 = nullptr;  // 15: focusInEvent
    void* cb_16 = nullptr;  void* dt_16 = nullptr;  // 16: focusOutEvent
    void* cb_17 = nullptr;  void* dt_17 = nullptr;  // 17: contextMenuEvent

    explicit eQToolBox(QWidget* parent = nullptr) : QToolBox(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QToolBox::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QToolBox::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QToolBox::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QToolBox::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QToolBox::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QToolBox::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QToolBox::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QToolBox::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QToolBox::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QToolBox::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QToolBox::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QToolBox::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QToolBox::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QToolBox::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QToolBox::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QToolBox::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QToolBox::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQToolBox_create(void* parent) {
    return new eQToolBox((QWidget*)parent);
}

void qteQToolBox_delete(void* w) {
    delete (eQToolBox*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQToolBox_addItem_ws(void* _obj, void* widget, void* text) {
    return ((QToolBox*)_obj)->addItem((QWidget*)widget, *(QString*)text);
}

int qteQToolBox_addItem_wps(void* _obj, void* widget, void* icon, void* text) {
    return ((QToolBox*)_obj)->addItem((QWidget*)widget, *(const QIcon*)icon, *(QString*)text);
}

int qteQToolBox_insertItem_iws(void* _obj, int index, void* widget, void* text) {
    return ((QToolBox*)_obj)->insertItem(index, (QWidget*)widget, *(QString*)text);
}

int qteQToolBox_insertItem_iwps(void* _obj, int index, void* widget, void* icon, void* text) {
    return ((QToolBox*)_obj)->insertItem(index, (QWidget*)widget, *(const QIcon*)icon, *(QString*)text);
}

void qteQToolBox_removeItem(void* _obj, int index) {
    ((QToolBox*)_obj)->removeItem(index);
}

void qteQToolBox_setItemEnabled(void* _obj, int index, int enabled) {
    ((QToolBox*)_obj)->setItemEnabled(index, (enabled != 0));
}

int qteQToolBox_isItemEnabled(void* _obj, int index) {
    return ((QToolBox*)_obj)->isItemEnabled(index) ? 1 : 0;
}

void qteQToolBox_setItemText(void* _obj, int index, void* text) {
    ((QToolBox*)_obj)->setItemText(index, *(QString*)text);
}

void* qteQToolBox_itemText(void* _obj, int index) {
    return new QString(((QToolBox*)_obj)->itemText(index));
}

void qteQToolBox_setItemIcon(void* _obj, int index, void* icon) {
    ((QToolBox*)_obj)->setItemIcon(index, *(const QIcon*)icon);
}

void* qteQToolBox_itemIcon(void* _obj, int index) {
    return new QIcon(((QToolBox*)_obj)->itemIcon(index));
}

void qteQToolBox_setItemToolTip(void* _obj, int index, void* toolTip) {
    ((QToolBox*)_obj)->setItemToolTip(index, *(QString*)toolTip);
}

void* qteQToolBox_itemToolTip(void* _obj, int index) {
    return new QString(((QToolBox*)_obj)->itemToolTip(index));
}

int qteQToolBox_currentIndex(void* _obj) {
    return ((QToolBox*)_obj)->currentIndex();
}

void* qteQToolBox_currentWidget(void* _obj) {
    return (void*)((QToolBox*)_obj)->currentWidget();
}

void* qteQToolBox_widget(void* _obj, int index) {
    return (void*)((QToolBox*)_obj)->widget(index);
}

int qteQToolBox_indexOf(void* _obj, void* widget) {
    return ((QToolBox*)_obj)->indexOf((QWidget*)widget);
}

int qteQToolBox_count(void* _obj) {
    return ((QToolBox*)_obj)->count();
}

void qteQToolBox_setCurrentIndex(void* _obj, int index) {
    ((QToolBox*)_obj)->setCurrentIndex(index);
}

void qteQToolBox_setCurrentWidget(void* _obj, void* widget) {
    ((QToolBox*)_obj)->setCurrentWidget((QWidget*)widget);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQToolBox_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQToolBox* obj = (eQToolBox*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;  // mousePressEvent
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;  // mouseReleaseEvent
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;  // mouseDoubleClickEvent
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;  // mouseMoveEvent
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;  // keyPressEvent
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;  // keyReleaseEvent
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;  // resizeEvent
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;  // moveEvent
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;  // closeEvent
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;  // showEvent
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;  // hideEvent
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;  // enterEvent
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;  // leaveEvent
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;  // wheelEvent
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;  // focusInEvent
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;  // focusOutEvent
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;  // contextMenuEvent
        default: break;
    }
}

} // extern "C"
