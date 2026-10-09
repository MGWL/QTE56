#ifndef QTE56_QTABWIDGET_BUILD
#define QTE56_QTABWIDGET_BUILD
#endif
#include "qte56_qtabwidget.h"
#include <QTabWidget>
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
class eQTabWidget : public QTabWidget {
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

    explicit eQTabWidget(QWidget* parent = nullptr) : QTabWidget(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QTabWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QTabWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QTabWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QTabWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QTabWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QTabWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QTabWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QTabWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QTabWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QTabWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QTabWidget::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QTabWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QTabWidget::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QTabWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QTabWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QTabWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QTabWidget::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTabWidget_create(void* parent) {
    return new eQTabWidget((QWidget*)parent);
}

void qteQTabWidget_delete(void* w) {
    delete (eQTabWidget*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQTabWidget_show(void* _obj) {
    ((QTabWidget*)_obj)->show();
}

void qteQTabWidget_hide(void* _obj) {
    ((QTabWidget*)_obj)->hide();
}

void qteQTabWidget_update(void* _obj) {
    ((QTabWidget*)_obj)->update();
}

int qteQTabWidget_addTab(void* _obj, void* widget, void* p1) {
    return ((QTabWidget*)_obj)->addTab((QWidget*)widget, *(QString*)p1);
}

int qteQTabWidget_insertTab(void* _obj, int index, void* widget, void* p2) {
    return ((QTabWidget*)_obj)->insertTab(index, (QWidget*)widget, *(QString*)p2);
}

void qteQTabWidget_removeTab(void* _obj, int index) {
    ((QTabWidget*)_obj)->removeTab(index);
}

int qteQTabWidget_isTabEnabled(void* _obj, int index) {
    return ((QTabWidget*)_obj)->isTabEnabled(index) ? 1 : 0;
}

void qteQTabWidget_setTabEnabled(void* _obj, int index, int p1) {
    ((QTabWidget*)_obj)->setTabEnabled(index, (p1 != 0));
}

void* qteQTabWidget_tabText(void* _obj, int index) {
    return new QString(((QTabWidget*)_obj)->tabText(index));
}

void qteQTabWidget_setTabText(void* _obj, int index, void* p1) {
    ((QTabWidget*)_obj)->setTabText(index, *(QString*)p1);
}

void* qteQTabWidget_tabToolTip(void* _obj, int index) {
    return new QString(((QTabWidget*)_obj)->tabToolTip(index));
}

void qteQTabWidget_setTabToolTip(void* _obj, int index, void* tip) {
    ((QTabWidget*)_obj)->setTabToolTip(index, *(QString*)tip);
}

void qteQTabWidget_setTabWhatsThis(void* _obj, int index, void* text) {
    ((QTabWidget*)_obj)->setTabWhatsThis(index, *(QString*)text);
}

void* qteQTabWidget_tabWhatsThis(void* _obj, int index) {
    return new QString(((QTabWidget*)_obj)->tabWhatsThis(index));
}

int qteQTabWidget_currentIndex(void* _obj) {
    return ((QTabWidget*)_obj)->currentIndex();
}

void* qteQTabWidget_currentWidget(void* _obj) {
    return (void*)((QTabWidget*)_obj)->currentWidget();
}

void* qteQTabWidget_widget(void* _obj, int index) {
    return (void*)((QTabWidget*)_obj)->widget(index);
}

int qteQTabWidget_indexOf(void* _obj, void* widget) {
    return ((QTabWidget*)_obj)->indexOf((QWidget*)widget);
}

int qteQTabWidget_count(void* _obj) {
    return ((QTabWidget*)_obj)->count();
}

int qteQTabWidget_tabPosition(void* _obj) {
    return ((QTabWidget*)_obj)->tabPosition();
}

void qteQTabWidget_setTabPosition(void* _obj, int p0) {
    ((QTabWidget*)_obj)->setTabPosition((QTabWidget::TabPosition)p0);
}

int qteQTabWidget_tabsClosable(void* _obj) {
    return ((QTabWidget*)_obj)->tabsClosable() ? 1 : 0;
}

void qteQTabWidget_setTabsClosable(void* _obj, int closeable) {
    ((QTabWidget*)_obj)->setTabsClosable((closeable != 0));
}

int qteQTabWidget_isMovable(void* _obj) {
    return ((QTabWidget*)_obj)->isMovable() ? 1 : 0;
}

void qteQTabWidget_setMovable(void* _obj, int movable) {
    ((QTabWidget*)_obj)->setMovable((movable != 0));
}

int qteQTabWidget_tabShape(void* _obj) {
    return ((QTabWidget*)_obj)->tabShape();
}

void qteQTabWidget_setTabShape(void* _obj, int s) {
    ((QTabWidget*)_obj)->setTabShape((QTabWidget::TabShape)s);
}

void* qteQTabWidget_sizeHint(void* _obj) {
    return new QSize(((QTabWidget*)_obj)->sizeHint());
}

void* qteQTabWidget_minimumSizeHint(void* _obj) {
    return new QSize(((QTabWidget*)_obj)->minimumSizeHint());
}

int qteQTabWidget_heightForWidth(void* _obj, int width) {
    return ((QTabWidget*)_obj)->heightForWidth(width);
}

int qteQTabWidget_hasHeightForWidth(void* _obj) {
    return ((QTabWidget*)_obj)->hasHeightForWidth() ? 1 : 0;
}

void qteQTabWidget_setCornerWidget(void* _obj, void* w, int corner) {
    ((QTabWidget*)_obj)->setCornerWidget((QWidget *)w, (Qt::Corner)corner);
}

void* qteQTabWidget_cornerWidget(void* _obj, int corner) {
    return (void*)((QTabWidget*)_obj)->cornerWidget((Qt::Corner)corner);
}

int qteQTabWidget_elideMode(void* _obj) {
    return ((QTabWidget*)_obj)->elideMode();
}

void qteQTabWidget_setElideMode(void* _obj, int p0) {
    ((QTabWidget*)_obj)->setElideMode((Qt::TextElideMode)p0);
}

void* qteQTabWidget_iconSize(void* _obj) {
    return new QSize(((QTabWidget*)_obj)->iconSize());
}

void qteQTabWidget_setIconSize(void* _obj, void* size) {
    ((QTabWidget*)_obj)->setIconSize(*(const QSize*)size);
}

int qteQTabWidget_usesScrollButtons(void* _obj) {
    return ((QTabWidget*)_obj)->usesScrollButtons() ? 1 : 0;
}

void qteQTabWidget_setUsesScrollButtons(void* _obj, int useButtons) {
    ((QTabWidget*)_obj)->setUsesScrollButtons((useButtons != 0));
}

int qteQTabWidget_documentMode(void* _obj) {
    return ((QTabWidget*)_obj)->documentMode() ? 1 : 0;
}

void qteQTabWidget_setDocumentMode(void* _obj, int set) {
    ((QTabWidget*)_obj)->setDocumentMode((set != 0));
}

int qteQTabWidget_tabBarAutoHide(void* _obj) {
    return ((QTabWidget*)_obj)->tabBarAutoHide() ? 1 : 0;
}

void qteQTabWidget_setTabBarAutoHide(void* _obj, int enabled) {
    ((QTabWidget*)_obj)->setTabBarAutoHide((enabled != 0));
}

void qteQTabWidget_clear(void* _obj) {
    ((QTabWidget*)_obj)->clear();
}

void* qteQTabWidget_tabBar(void* _obj) {
    return (void*)((QTabWidget*)_obj)->tabBar();
}

void qteQTabWidget_setCurrentIndex(void* _obj, int index) {
    ((QTabWidget*)_obj)->setCurrentIndex(index);
}

void qteQTabWidget_setCurrentWidget(void* _obj, void* widget) {
    ((QTabWidget*)_obj)->setCurrentWidget((QWidget*)widget);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQTabWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQTabWidget* obj = (eQTabWidget*)w;
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
