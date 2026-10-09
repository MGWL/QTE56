#ifndef QTE56_QTABBAR_BUILD
#define QTE56_QTABBAR_BUILD
#endif
#include "qte56_qtabbar.h"
#include <QTabBar>
#include <QIcon>
#include <QColor>
#include <QPoint>
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
class eQTabBar : public QTabBar {
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

    explicit eQTabBar(QWidget* parent = nullptr) : QTabBar(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QTabBar::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QTabBar::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QTabBar::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QTabBar::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QTabBar::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QTabBar::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QTabBar::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QTabBar::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QTabBar::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QTabBar::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QTabBar::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QTabBar::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QTabBar::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QTabBar::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QTabBar::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QTabBar::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QTabBar::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTabBar_create(void* parent) {
    return new eQTabBar((QWidget*)parent);
}

void qteQTabBar_delete(void* w) {
    delete (eQTabBar*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQTabBar_show(void* _obj) {
    ((QTabBar*)_obj)->show();
}

void qteQTabBar_hide(void* _obj) {
    ((QTabBar*)_obj)->hide();
}

void qteQTabBar_update(void* _obj) {
    ((QTabBar*)_obj)->update();
}

int qteQTabBar_shape(void* _obj) {
    return ((QTabBar*)_obj)->shape();
}

void qteQTabBar_setShape(void* _obj, int shape) {
    ((QTabBar*)_obj)->setShape((QTabBar::Shape)shape);
}

int qteQTabBar_addTab_s(void* _obj, void* text) {
    return ((QTabBar*)_obj)->addTab(*(QString*)text);
}

int qteQTabBar_addTab_ps(void* _obj, void* icon, void* text) {
    return ((QTabBar*)_obj)->addTab(*(const QIcon*)icon, *(QString*)text);
}

int qteQTabBar_insertTab(void* _obj, int index, void* text) {
    return ((QTabBar*)_obj)->insertTab(index, *(QString*)text);
}

void qteQTabBar_removeTab(void* _obj, int index) {
    ((QTabBar*)_obj)->removeTab(index);
}

void qteQTabBar_moveTab(void* _obj, int from, int to) {
    ((QTabBar*)_obj)->moveTab(from, to);
}

int qteQTabBar_isTabEnabled(void* _obj, int index) {
    return ((QTabBar*)_obj)->isTabEnabled(index) ? 1 : 0;
}

void qteQTabBar_setTabEnabled(void* _obj, int index, int p1) {
    ((QTabBar*)_obj)->setTabEnabled(index, (p1 != 0));
}

void* qteQTabBar_tabText(void* _obj, int index) {
    return new QString(((QTabBar*)_obj)->tabText(index));
}

void qteQTabBar_setTabText(void* _obj, int index, void* text) {
    ((QTabBar*)_obj)->setTabText(index, *(QString*)text);
}

void* qteQTabBar_tabTextColor(void* _obj, int index) {
    return new QColor(((QTabBar*)_obj)->tabTextColor(index));
}

void qteQTabBar_setTabTextColor(void* _obj, int index, void* color) {
    ((QTabBar*)_obj)->setTabTextColor(index, *(const QColor*)color);
}

void* qteQTabBar_tabIcon(void* _obj, int index) {
    return new QIcon(((QTabBar*)_obj)->tabIcon(index));
}

void qteQTabBar_setTabIcon(void* _obj, int index, void* icon) {
    ((QTabBar*)_obj)->setTabIcon(index, *(const QIcon*)icon);
}

int qteQTabBar_elideMode(void* _obj) {
    return ((QTabBar*)_obj)->elideMode();
}

void qteQTabBar_setElideMode(void* _obj, int p0) {
    ((QTabBar*)_obj)->setElideMode((Qt::TextElideMode)p0);
}

void qteQTabBar_setTabToolTip(void* _obj, int index, void* tip) {
    ((QTabBar*)_obj)->setTabToolTip(index, *(QString*)tip);
}

void* qteQTabBar_tabToolTip(void* _obj, int index) {
    return new QString(((QTabBar*)_obj)->tabToolTip(index));
}

void qteQTabBar_setTabWhatsThis(void* _obj, int index, void* text) {
    ((QTabBar*)_obj)->setTabWhatsThis(index, *(QString*)text);
}

void* qteQTabBar_tabWhatsThis(void* _obj, int index) {
    return new QString(((QTabBar*)_obj)->tabWhatsThis(index));
}

void* qteQTabBar_tabRect(void* _obj, int index) {
    return new QRect(((QTabBar*)_obj)->tabRect(index));
}

int qteQTabBar_tabAt(void* _obj, void* pos) {
    return ((QTabBar*)_obj)->tabAt(*(const QPoint*)pos);
}

int qteQTabBar_currentIndex(void* _obj) {
    return ((QTabBar*)_obj)->currentIndex();
}

int qteQTabBar_count(void* _obj) {
    return ((QTabBar*)_obj)->count();
}

void* qteQTabBar_sizeHint(void* _obj) {
    return new QSize(((QTabBar*)_obj)->sizeHint());
}

void* qteQTabBar_minimumSizeHint(void* _obj) {
    return new QSize(((QTabBar*)_obj)->minimumSizeHint());
}

void qteQTabBar_setDrawBase(void* _obj, int drawTheBase) {
    ((QTabBar*)_obj)->setDrawBase((drawTheBase != 0));
}

int qteQTabBar_drawBase(void* _obj) {
    return ((QTabBar*)_obj)->drawBase() ? 1 : 0;
}

void* qteQTabBar_iconSize(void* _obj) {
    return new QSize(((QTabBar*)_obj)->iconSize());
}

void qteQTabBar_setIconSize(void* _obj, void* size) {
    ((QTabBar*)_obj)->setIconSize(*(const QSize*)size);
}

int qteQTabBar_usesScrollButtons(void* _obj) {
    return ((QTabBar*)_obj)->usesScrollButtons() ? 1 : 0;
}

void qteQTabBar_setUsesScrollButtons(void* _obj, int useButtons) {
    ((QTabBar*)_obj)->setUsesScrollButtons((useButtons != 0));
}

int qteQTabBar_tabsClosable(void* _obj) {
    return ((QTabBar*)_obj)->tabsClosable() ? 1 : 0;
}

void qteQTabBar_setTabsClosable(void* _obj, int closable) {
    ((QTabBar*)_obj)->setTabsClosable((closable != 0));
}

void qteQTabBar_setTabButton(void* _obj, int index, int position, void* widget) {
    ((QTabBar*)_obj)->setTabButton(index, (QTabBar::ButtonPosition)position, (QWidget*)widget);
}

void* qteQTabBar_tabButton(void* _obj, int index, int position) {
    return (void*)((QTabBar*)_obj)->tabButton(index, (QTabBar::ButtonPosition)position);
}

int qteQTabBar_selectionBehaviorOnRemove(void* _obj) {
    return ((QTabBar*)_obj)->selectionBehaviorOnRemove();
}

void qteQTabBar_setSelectionBehaviorOnRemove(void* _obj, int behavior) {
    ((QTabBar*)_obj)->setSelectionBehaviorOnRemove((QTabBar::SelectionBehavior)behavior);
}

int qteQTabBar_expanding(void* _obj) {
    return ((QTabBar*)_obj)->expanding() ? 1 : 0;
}

void qteQTabBar_setExpanding(void* _obj, int enabled) {
    ((QTabBar*)_obj)->setExpanding((enabled != 0));
}

int qteQTabBar_isMovable(void* _obj) {
    return ((QTabBar*)_obj)->isMovable() ? 1 : 0;
}

void qteQTabBar_setMovable(void* _obj, int movable) {
    ((QTabBar*)_obj)->setMovable((movable != 0));
}

int qteQTabBar_documentMode(void* _obj) {
    return ((QTabBar*)_obj)->documentMode() ? 1 : 0;
}

void qteQTabBar_setDocumentMode(void* _obj, int set) {
    ((QTabBar*)_obj)->setDocumentMode((set != 0));
}

int qteQTabBar_autoHide(void* _obj) {
    return ((QTabBar*)_obj)->autoHide() ? 1 : 0;
}

void qteQTabBar_setAutoHide(void* _obj, int hide) {
    ((QTabBar*)_obj)->setAutoHide((hide != 0));
}

int qteQTabBar_changeCurrentOnDrag(void* _obj) {
    return ((QTabBar*)_obj)->changeCurrentOnDrag() ? 1 : 0;
}

void qteQTabBar_setChangeCurrentOnDrag(void* _obj, int change) {
    ((QTabBar*)_obj)->setChangeCurrentOnDrag((change != 0));
}

void* qteQTabBar_accessibleTabName(void* _obj, int index) {
    return new QString(((QTabBar*)_obj)->accessibleTabName(index));
}

void qteQTabBar_setAccessibleTabName(void* _obj, int index, void* name) {
    ((QTabBar*)_obj)->setAccessibleTabName(index, *(QString*)name);
}

void qteQTabBar_setCurrentIndex(void* _obj, int index) {
    ((QTabBar*)_obj)->setCurrentIndex(index);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQTabBar_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQTabBar* obj = (eQTabBar*)w;
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
