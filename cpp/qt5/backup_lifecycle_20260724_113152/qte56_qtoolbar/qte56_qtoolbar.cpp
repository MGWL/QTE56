#ifndef QTE56_QTOOLBAR_BUILD
#define QTE56_QTOOLBAR_BUILD
#endif
#include "qte56_qtoolbar.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QToolBar>
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
class eQToolBar : public QToolBar {
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

    explicit eQToolBar(QWidget* parent = nullptr) : QToolBar(parent) {}
    explicit eQToolBar(const QString& text, QWidget* parent = nullptr) : QToolBar(text, parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QToolBar::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QToolBar::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QToolBar::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QToolBar::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QToolBar::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QToolBar::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QToolBar::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QToolBar::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QToolBar::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QToolBar::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QToolBar::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QToolBar::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QToolBar::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QToolBar::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QToolBar::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QToolBar::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QToolBar::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQToolBar_create(void* parent) {
    return qte_createTracked(new eQToolBar((QWidget*)parent));
}

void qteQToolBar_delete(void* w) {
    delete (eQToolBar*)w;
}

void* qteQToolBar_create_text(void* text, void* parent) {
    return qte_createTracked(new eQToolBar(*(QString*)text, (QWidget*)parent));
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQToolBar_setMovable(void* _obj, int movable) {
    ((QToolBar*)_obj)->setMovable((movable != 0));
}

int qteQToolBar_isMovable(void* _obj) {
    return ((QToolBar*)_obj)->isMovable() ? 1 : 0;
}

void qteQToolBar_setAllowedAreas(void* _obj, int areas) {
    ((QToolBar*)_obj)->setAllowedAreas((Qt::ToolBarAreas)areas);
}

int qteQToolBar_allowedAreas(void* _obj) {
    return ((QToolBar*)_obj)->allowedAreas();
}

void qteQToolBar_setOrientation(void* _obj, int orientation) {
    ((QToolBar*)_obj)->setOrientation((Qt::Orientation)orientation);
}

int qteQToolBar_orientation(void* _obj) {
    return ((QToolBar*)_obj)->orientation();
}

void qteQToolBar_clear(void* _obj) {
    ((QToolBar*)_obj)->clear();
}

void* qteQToolBar_addAction_s(void* _obj, void* text) {
    return (void*)((QToolBar*)_obj)->addAction(*(QString*)text);
}

void* qteQToolBar_addAction_sp(void* _obj, void* text, int functor) {
    return (void*)((QToolBar*)_obj)->addAction(*(QString*)text);
}

void* qteQToolBar_addAction_sop(void* _obj, void* text, void* context, int functor) {
    return (void*)((QToolBar*)_obj)->addAction(*(QString*)text);
}

void* qteQToolBar_addSeparator(void* _obj) {
    return (void*)((QToolBar*)_obj)->addSeparator();
}

void* qteQToolBar_insertSeparator(void* _obj, void* before) {
    return (void*)((QToolBar*)_obj)->insertSeparator((QAction*)before);
}

void* qteQToolBar_addWidget(void* _obj, void* widget) {
    return (void*)((QToolBar*)_obj)->addWidget((QWidget*)widget);
}

void* qteQToolBar_insertWidget(void* _obj, void* before, void* widget) {
    return (void*)((QToolBar*)_obj)->insertWidget((QAction*)before, (QWidget*)widget);
}

void* qteQToolBar_actionGeometry(void* _obj, void* action) {
    return new QRect(((QToolBar*)_obj)->actionGeometry((QAction*)action));
}

void* qteQToolBar_actionAt_p(void* _obj, void* p) {
    return (void*)((QToolBar*)_obj)->actionAt(*(const QPoint*)p);
}

void* qteQToolBar_actionAt_ii(void* _obj, int x, int y) {
    return (void*)((QToolBar*)_obj)->actionAt(x, y);
}

void* qteQToolBar_toggleViewAction(void* _obj) {
    return (void*)((QToolBar*)_obj)->toggleViewAction();
}

void* qteQToolBar_iconSize(void* _obj) {
    return new QSize(((QToolBar*)_obj)->iconSize());
}

int qteQToolBar_toolButtonStyle(void* _obj) {
    return ((QToolBar*)_obj)->toolButtonStyle();
}

void* qteQToolBar_widgetForAction(void* _obj, void* action) {
    return (void*)((QToolBar*)_obj)->widgetForAction((QAction*)action);
}

int qteQToolBar_isFloatable(void* _obj) {
    return ((QToolBar*)_obj)->isFloatable() ? 1 : 0;
}

void qteQToolBar_setFloatable(void* _obj, int floatable) {
    ((QToolBar*)_obj)->setFloatable((floatable != 0));
}

int qteQToolBar_isFloating(void* _obj) {
    return ((QToolBar*)_obj)->isFloating() ? 1 : 0;
}

void qteQToolBar_setIconSize(void* _obj, void* iconSize) {
    ((QToolBar*)_obj)->setIconSize(*(const QSize*)iconSize);
}

void qteQToolBar_setToolButtonStyle(void* _obj, int toolButtonStyle) {
    ((QToolBar*)_obj)->setToolButtonStyle((Qt::ToolButtonStyle)toolButtonStyle);
}

// ── Icon-based addAction ─────────────────────────────────────────────────────
void* qteQToolBar_addAction_is(void* _obj, void* icon, void* text) {
    return (void*)((QToolBar*)_obj)->addAction(*(const QIcon*)icon, *(QString*)text);
}
void qteQToolBar_addAction_p(void* _obj, void* action) {
    ((QToolBar*)_obj)->addAction((QAction*)action);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQToolBar_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQToolBar* obj = (eQToolBar*)w;
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

// ── iconSize getter ───────────────────────────────────────────────────────────
void qteQToolBar_iconSize_wh(void* obj, int* w, int* h) {
    QSize s = ((QToolBar*)obj)->iconSize();
    *w = s.width(); *h = s.height();
}

// ── isAreaAllowed ─────────────────────────────────────────────────────────────
int qteQToolBar_isAreaAllowed(void* obj, int area) {
    return ((QToolBar*)obj)->isAreaAllowed((Qt::ToolBarArea)area) ? 1 : 0;
}

// ── Signals ───────────────────────────────────────────────────────────────────
// actionTriggered: cb(void* ud, void* action)
void qteQToolBar_connect_actionTriggered(void* obj, void (*cb)(void*, void*), void* ud) {
    QObject::connect((QToolBar*)obj, &QToolBar::actionTriggered,
        [cb, ud](QAction* a){ cb(ud, (void*)a); });
}
// iconSizeChanged: cb(void* ud, int w, int h)
void qteQToolBar_connect_iconSizeChanged(void* obj, void (*cb)(void*, int, int), void* ud) {
    QObject::connect((QToolBar*)obj, &QToolBar::iconSizeChanged,
        [cb, ud](const QSize& s){ cb(ud, s.width(), s.height()); });
}
// orientationChanged: cb(void* ud, int orientation)
void qteQToolBar_connect_orientationChanged(void* obj, void (*cb)(void*, int), void* ud) {
    QObject::connect((QToolBar*)obj, &QToolBar::orientationChanged,
        [cb, ud](Qt::Orientation o){ cb(ud, (int)o); });
}
// visibilityChanged: cb(void* ud, int visible)
void qteQToolBar_connect_visibilityChanged(void* obj, void (*cb)(void*, int), void* ud) {
    QObject::connect((QToolBar*)obj, &QToolBar::visibilityChanged,
        [cb, ud](bool v){ cb(ud, v ? 1 : 0); });
}

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQToolBar_actions(void* _obj) {
    QList<QAction*> list = ((QToolBar*)_obj)->actions();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}

} // extern "C"
