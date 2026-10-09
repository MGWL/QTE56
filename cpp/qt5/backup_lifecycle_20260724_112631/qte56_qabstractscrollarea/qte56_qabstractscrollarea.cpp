#ifndef QTE56_QABSTRACTSCROLLAREA_BUILD
#define QTE56_QABSTRACTSCROLLAREA_BUILD
#endif
#include "qte56_qabstractscrollarea.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QAbstractScrollArea>
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
class eQAbstractScrollArea : public QAbstractScrollArea {
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

    explicit eQAbstractScrollArea(QWidget* parent = nullptr) : QAbstractScrollArea(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QAbstractScrollArea::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QAbstractScrollArea::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QAbstractScrollArea::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QAbstractScrollArea::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QAbstractScrollArea::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QAbstractScrollArea::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QAbstractScrollArea::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QAbstractScrollArea::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QAbstractScrollArea::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QAbstractScrollArea::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QAbstractScrollArea::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QAbstractScrollArea::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QAbstractScrollArea::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QAbstractScrollArea::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QAbstractScrollArea::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QAbstractScrollArea::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QAbstractScrollArea::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQAbstractScrollArea_create(void* parent) {
    return qte_createTracked(new eQAbstractScrollArea((QWidget*)parent);
}

void qteQAbstractScrollArea_delete(void* w) {
    delete (eQAbstractScrollArea*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQAbstractScrollArea_verticalScrollBarPolicy(void* _obj) {
    return ((QAbstractScrollArea*)_obj)->verticalScrollBarPolicy();
}

void qteQAbstractScrollArea_setVerticalScrollBarPolicy(void* _obj, int p0) {
    ((QAbstractScrollArea*)_obj)->setVerticalScrollBarPolicy((Qt::ScrollBarPolicy)p0);
}

void* qteQAbstractScrollArea_verticalScrollBar(void* _obj) {
    return (void*)((QAbstractScrollArea*)_obj)->verticalScrollBar();
}

void qteQAbstractScrollArea_setVerticalScrollBar(void* _obj, void* scrollbar) {
    ((QAbstractScrollArea*)_obj)->setVerticalScrollBar((QScrollBar*)scrollbar);
}

int qteQAbstractScrollArea_horizontalScrollBarPolicy(void* _obj) {
    return ((QAbstractScrollArea*)_obj)->horizontalScrollBarPolicy();
}

void qteQAbstractScrollArea_setHorizontalScrollBarPolicy(void* _obj, int p0) {
    ((QAbstractScrollArea*)_obj)->setHorizontalScrollBarPolicy((Qt::ScrollBarPolicy)p0);
}

void* qteQAbstractScrollArea_horizontalScrollBar(void* _obj) {
    return (void*)((QAbstractScrollArea*)_obj)->horizontalScrollBar();
}

void qteQAbstractScrollArea_setHorizontalScrollBar(void* _obj, void* scrollbar) {
    ((QAbstractScrollArea*)_obj)->setHorizontalScrollBar((QScrollBar*)scrollbar);
}

void* qteQAbstractScrollArea_cornerWidget(void* _obj) {
    return (void*)((QAbstractScrollArea*)_obj)->cornerWidget();
}

void qteQAbstractScrollArea_setCornerWidget(void* _obj, void* widget) {
    ((QAbstractScrollArea*)_obj)->setCornerWidget((QWidget*)widget);
}

void qteQAbstractScrollArea_addScrollBarWidget(void* _obj, void* widget, int alignment) {
    ((QAbstractScrollArea*)_obj)->addScrollBarWidget((QWidget*)widget, (Qt::Alignment)alignment);
}

void* qteQAbstractScrollArea_viewport(void* _obj) {
    return (void*)((QAbstractScrollArea*)_obj)->viewport();
}

void qteQAbstractScrollArea_setViewport(void* _obj, void* widget) {
    ((QAbstractScrollArea*)_obj)->setViewport((QWidget*)widget);
}

void* qteQAbstractScrollArea_maximumViewportSize(void* _obj) {
    return new QSize(((QAbstractScrollArea*)_obj)->maximumViewportSize());
}

void qteQAbstractScrollArea_setupViewport(void* _obj, void* viewport) {
    ((QAbstractScrollArea*)_obj)->setupViewport((QWidget*)viewport);
}

int qteQAbstractScrollArea_sizeAdjustPolicy(void* _obj) {
    return ((QAbstractScrollArea*)_obj)->sizeAdjustPolicy();
}

void qteQAbstractScrollArea_setSizeAdjustPolicy(void* _obj, int policy) {
    ((QAbstractScrollArea*)_obj)->setSizeAdjustPolicy((QAbstractScrollArea::SizeAdjustPolicy)policy);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQAbstractScrollArea_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQAbstractScrollArea* obj = (eQAbstractScrollArea*)w;
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
