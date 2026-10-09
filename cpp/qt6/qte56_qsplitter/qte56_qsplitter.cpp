#ifndef QTE56_QSPLITTER_BUILD
#define QTE56_QSPLITTER_BUILD
#endif
#include "qte56_qsplitter.h"
#include <QSplitter>
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
class eQSplitter : public QSplitter {
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

    explicit eQSplitter(QWidget* parent = nullptr) : QSplitter(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QSplitter::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QSplitter::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QSplitter::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QSplitter::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QSplitter::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QSplitter::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QSplitter::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QSplitter::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QSplitter::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QSplitter::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QSplitter::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QSplitter::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QSplitter::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QSplitter::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QSplitter::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QSplitter::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QSplitter::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQSplitter_create(void* parent) {
    return new eQSplitter((QWidget*)parent);
}

void qteQSplitter_delete(void* w) {
    delete (eQSplitter*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQSplitter_addWidget(void* _obj, void* widget) {
    ((QSplitter*)_obj)->addWidget((QWidget*)widget);
}

void qteQSplitter_insertWidget(void* _obj, int index, void* widget) {
    ((QSplitter*)_obj)->insertWidget(index, (QWidget*)widget);
}

void* qteQSplitter_replaceWidget(void* _obj, int index, void* widget) {
    return (void*)((QSplitter*)_obj)->replaceWidget(index, (QWidget*)widget);
}

void qteQSplitter_setOrientation(void* _obj, int p0) {
    ((QSplitter*)_obj)->setOrientation((Qt::Orientation)p0);
}

int qteQSplitter_orientation(void* _obj) {
    return ((QSplitter*)_obj)->orientation();
}

void qteQSplitter_setChildrenCollapsible(void* _obj, int p0) {
    ((QSplitter*)_obj)->setChildrenCollapsible((p0 != 0));
}

int qteQSplitter_childrenCollapsible(void* _obj) {
    return ((QSplitter*)_obj)->childrenCollapsible() ? 1 : 0;
}

void qteQSplitter_setCollapsible(void* _obj, int index, int p1) {
    ((QSplitter*)_obj)->setCollapsible(index, (p1 != 0));
}

int qteQSplitter_isCollapsible(void* _obj, int index) {
    return ((QSplitter*)_obj)->isCollapsible(index) ? 1 : 0;
}

void qteQSplitter_setOpaqueResize(void* _obj, int opaque) {
    ((QSplitter*)_obj)->setOpaqueResize((opaque != 0));
}

int qteQSplitter_opaqueResize(void* _obj) {
    return ((QSplitter*)_obj)->opaqueResize() ? 1 : 0;
}

void qteQSplitter_refresh(void* _obj) {
    ((QSplitter*)_obj)->refresh();
}

int qteQSplitter_handleWidth(void* _obj) {
    return ((QSplitter*)_obj)->handleWidth();
}

void qteQSplitter_setHandleWidth(void* _obj, int p0) {
    ((QSplitter*)_obj)->setHandleWidth(p0);
}

int qteQSplitter_indexOf(void* _obj, void* w) {
    return ((QSplitter*)_obj)->indexOf((QWidget*)w);
}

void* qteQSplitter_widget(void* _obj, int index) {
    return (void*)((QSplitter*)_obj)->widget(index);
}

int qteQSplitter_count(void* _obj) {
    return ((QSplitter*)_obj)->count();
}

void qteQSplitter_getRange(void* _obj, int index, void* p1, void* p2) {
    ((QSplitter*)_obj)->getRange(index, (int*)p1, (int*)p2);
}

void* qteQSplitter_handle(void* _obj, int index) {
    return (void*)((QSplitter*)_obj)->handle(index);
}

void qteQSplitter_setStretchFactor(void* _obj, int index, int stretch) {
    ((QSplitter*)_obj)->setStretchFactor(index, stretch);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQSplitter_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQSplitter* obj = (eQSplitter*)w;
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

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQSplitter_sizes(void* _obj) {
    QList<int> list = ((QSplitter*)_obj)->sizes();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number(list[i]);
    }
    return new QString(result);
}

void qteQSplitter_setSizes(void* _obj, void* qs_sizes) {
    if (!qs_sizes) return;
    QList<int> sizes;
    for (const QString& p : ((const QString*)qs_sizes)->split('|'))
        sizes.append(p.toInt());
    ((QSplitter*)_obj)->setSizes(sizes);
}

} // extern "C"
