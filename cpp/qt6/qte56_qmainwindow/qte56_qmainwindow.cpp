#ifndef QTE56_QMAINWINDOW_BUILD
#define QTE56_QMAINWINDOW_BUILD
#endif
#include "qte56_qmainwindow.h"
#include <QMainWindow>
#include <QByteArray>
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
class eQMainWindow : public QMainWindow {
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

    explicit eQMainWindow(QWidget* parent = nullptr) : QMainWindow(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QMainWindow::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QMainWindow::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QMainWindow::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QMainWindow::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QMainWindow::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QMainWindow::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QMainWindow::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QMainWindow::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QMainWindow::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QMainWindow::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QMainWindow::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QMainWindow::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QMainWindow::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QMainWindow::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QMainWindow::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QMainWindow::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QMainWindow::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQMainWindow_create(void* parent) {
    return new eQMainWindow((QWidget*)parent);
}

void qteQMainWindow_delete(void* w) {
    delete (eQMainWindow*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQMainWindow_iconSize(void* _obj) {
    return new QSize(((QMainWindow*)_obj)->iconSize());
}

void qteQMainWindow_setIconSize(void* _obj, void* iconSize) {
    ((QMainWindow*)_obj)->setIconSize(*(const QSize*)iconSize);
}

int qteQMainWindow_toolButtonStyle(void* _obj) {
    return ((QMainWindow*)_obj)->toolButtonStyle();
}

void qteQMainWindow_setToolButtonStyle(void* _obj, int toolButtonStyle) {
    ((QMainWindow*)_obj)->setToolButtonStyle((Qt::ToolButtonStyle)toolButtonStyle);
}

int qteQMainWindow_isAnimated(void* _obj) {
    return ((QMainWindow*)_obj)->isAnimated() ? 1 : 0;
}

int qteQMainWindow_isDockNestingEnabled(void* _obj) {
    return ((QMainWindow*)_obj)->isDockNestingEnabled() ? 1 : 0;
}

int qteQMainWindow_documentMode(void* _obj) {
    return ((QMainWindow*)_obj)->documentMode() ? 1 : 0;
}

void qteQMainWindow_setDocumentMode(void* _obj, int enabled) {
    ((QMainWindow*)_obj)->setDocumentMode((enabled != 0));
}

int qteQMainWindow_tabShape(void* _obj) {
    return ((QMainWindow*)_obj)->tabShape();
}

void qteQMainWindow_setTabShape(void* _obj, int tabShape) {
    ((QMainWindow*)_obj)->setTabShape((QTabWidget::TabShape)tabShape);
}

int qteQMainWindow_tabPosition(void* _obj, int area) {
    return ((QMainWindow*)_obj)->tabPosition((Qt::DockWidgetArea)area);
}

void qteQMainWindow_setTabPosition(void* _obj, int areas, int tabPosition) {
    ((QMainWindow*)_obj)->setTabPosition((Qt::DockWidgetAreas)areas, (QTabWidget::TabPosition)tabPosition);
}

void qteQMainWindow_setDockOptions(void* _obj, int options) {
    ((QMainWindow*)_obj)->setDockOptions((QMainWindow::DockOptions)options);
}

int qteQMainWindow_dockOptions(void* _obj) {
    return ((QMainWindow*)_obj)->dockOptions();
}

int qteQMainWindow_isSeparator(void* _obj, void* pos) {
    return ((QMainWindow*)_obj)->isSeparator(*(const QPoint*)pos) ? 1 : 0;
}

void* qteQMainWindow_menuBar(void* _obj) {
    return (void*)((QMainWindow*)_obj)->menuBar();
}

void qteQMainWindow_setMenuBar(void* _obj, void* menubar) {
    ((QMainWindow*)_obj)->setMenuBar((QMenuBar*)menubar);
}

void* qteQMainWindow_menuWidget(void* _obj) {
    return (void*)((QMainWindow*)_obj)->menuWidget();
}

void qteQMainWindow_setMenuWidget(void* _obj, void* menubar) {
    ((QMainWindow*)_obj)->setMenuWidget((QWidget*)menubar);
}

void* qteQMainWindow_statusBar(void* _obj) {
    return (void*)((QMainWindow*)_obj)->statusBar();
}

void qteQMainWindow_setStatusBar(void* _obj, void* statusbar) {
    ((QMainWindow*)_obj)->setStatusBar((QStatusBar*)statusbar);
}

void* qteQMainWindow_centralWidget(void* _obj) {
    return (void*)((QMainWindow*)_obj)->centralWidget();
}

void qteQMainWindow_setCentralWidget(void* _obj, void* widget) {
    ((QMainWindow*)_obj)->setCentralWidget((QWidget*)widget);
}

void* qteQMainWindow_takeCentralWidget(void* _obj) {
    return (void*)((QMainWindow*)_obj)->takeCentralWidget();
}

void qteQMainWindow_setCorner(void* _obj, int corner, int area) {
    ((QMainWindow*)_obj)->setCorner((Qt::Corner)corner, (Qt::DockWidgetArea)area);
}

int qteQMainWindow_corner(void* _obj, int corner) {
    return ((QMainWindow*)_obj)->corner((Qt::Corner)corner);
}

void qteQMainWindow_addToolBarBreak(void* _obj, int area) {
    ((QMainWindow*)_obj)->addToolBarBreak((Qt::ToolBarArea)area);
}

void qteQMainWindow_insertToolBarBreak(void* _obj, void* before) {
    ((QMainWindow*)_obj)->insertToolBarBreak((QToolBar*)before);
}

void qteQMainWindow_addToolBar_pp(void* _obj, int area, void* toolbar) {
    ((QMainWindow*)_obj)->addToolBar((Qt::ToolBarArea)area, (QToolBar*)toolbar);
}

void qteQMainWindow_addToolBar_p(void* _obj, void* toolbar) {
    ((QMainWindow*)_obj)->addToolBar((QToolBar*)toolbar);
}

void* qteQMainWindow_addToolBar_s(void* _obj, void* title) {
    return (void*)((QMainWindow*)_obj)->addToolBar(*(QString*)title);
}

void qteQMainWindow_insertToolBar(void* _obj, void* before, void* toolbar) {
    ((QMainWindow*)_obj)->insertToolBar((QToolBar*)before, (QToolBar*)toolbar);
}

void qteQMainWindow_removeToolBar(void* _obj, void* toolbar) {
    ((QMainWindow*)_obj)->removeToolBar((QToolBar*)toolbar);
}

void qteQMainWindow_removeToolBarBreak(void* _obj, void* before) {
    ((QMainWindow*)_obj)->removeToolBarBreak((QToolBar*)before);
}

int qteQMainWindow_unifiedTitleAndToolBarOnMac(void* _obj) {
    return ((QMainWindow*)_obj)->unifiedTitleAndToolBarOnMac() ? 1 : 0;
}

int qteQMainWindow_toolBarBreak(void* _obj, void* toolbar) {
    return ((QMainWindow*)_obj)->toolBarBreak((QToolBar*)toolbar) ? 1 : 0;
}

void qteQMainWindow_addDockWidget_pp(void* _obj, int area, void* dockwidget) {
    ((QMainWindow*)_obj)->addDockWidget((Qt::DockWidgetArea)area, (QDockWidget*)dockwidget);
}

void qteQMainWindow_addDockWidget_ppp(void* _obj, int area, void* dockwidget, int orientation) {
    ((QMainWindow*)_obj)->addDockWidget((Qt::DockWidgetArea)area, (QDockWidget*)dockwidget, (Qt::Orientation)orientation);
}

void qteQMainWindow_splitDockWidget(void* _obj, void* after, void* dockwidget, int orientation) {
    ((QMainWindow*)_obj)->splitDockWidget((QDockWidget*)after, (QDockWidget*)dockwidget, (Qt::Orientation)orientation);
}

void qteQMainWindow_tabifyDockWidget(void* _obj, void* first, void* second) {
    ((QMainWindow*)_obj)->tabifyDockWidget((QDockWidget*)first, (QDockWidget*)second);
}

void qteQMainWindow_removeDockWidget(void* _obj, void* dockwidget) {
    ((QMainWindow*)_obj)->removeDockWidget((QDockWidget*)dockwidget);
}

int qteQMainWindow_restoreDockWidget(void* _obj, void* dockwidget) {
    return ((QMainWindow*)_obj)->restoreDockWidget((QDockWidget*)dockwidget) ? 1 : 0;
}

int qteQMainWindow_dockWidgetArea(void* _obj, void* dockwidget) {
    return ((QMainWindow*)_obj)->dockWidgetArea((QDockWidget*)dockwidget);
}

void* qteQMainWindow_createPopupMenu(void* _obj) {
    return (void*)((QMainWindow*)_obj)->createPopupMenu();
}

void qteQMainWindow_setAnimated(void* _obj, int enabled) {
    ((QMainWindow*)_obj)->setAnimated((enabled != 0));
}

void qteQMainWindow_setDockNestingEnabled(void* _obj, int enabled) {
    ((QMainWindow*)_obj)->setDockNestingEnabled((enabled != 0));
}

void qteQMainWindow_setUnifiedTitleAndToolBarOnMac(void* _obj, int set) {
    ((QMainWindow*)_obj)->setUnifiedTitleAndToolBarOnMac((set != 0));
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQMainWindow_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQMainWindow* obj = (eQMainWindow*)w;
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


// ── State persistence ─────────────────────────────────────────────────────────

void* qteQMainWindow_saveState(void* w) {
    return new QByteArray(((QMainWindow*)w)->saveState());
}

int qteQMainWindow_restoreState(void* w, const void* data, int len) {
    QByteArray ba((const char*)data, len);
    return ((QMainWindow*)w)->restoreState(ba) ? 1 : 0;
}

} // extern "C"
