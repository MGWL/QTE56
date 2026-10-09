#ifndef QTE56_QMENU_BUILD
#define QTE56_QMENU_BUILD
#endif
#include "qte56_qmenu.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QMenu>
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
class eQMenu : public QMenu {
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

    explicit eQMenu(QWidget* parent = nullptr) : QMenu(parent) {}
    explicit eQMenu(const QString& text, QWidget* parent = nullptr) : QMenu(text, parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QMenu::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QMenu::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QMenu::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QMenu::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QMenu::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QMenu::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QMenu::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QMenu::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QMenu::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QMenu::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QMenu::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QMenu::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QMenu::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QMenu::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QMenu::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QMenu::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QMenu::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQMenu_create(void* parent) {
    return qte_createTracked(new eQMenu((QWidget*)parent);
}

void qteQMenu_delete(void* w) {
    delete (eQMenu*)w;
}

void* qteQMenu_create_text(void* text, void* parent) {
    return qte_createTracked(new eQMenu(*(QString*)text, (QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQMenu_addAction_s(void* _obj, void* text) {
    return (void*)((QMenu*)_obj)->addAction(*(QString*)text);
}

void* qteQMenu_addAction_sp(void* _obj, void* text, int /*functor*/) {
    // Functor overload not available on Qt5/Windows — fall back to simple addAction
    return (void*)((QMenu*)_obj)->addAction(*(QString*)text);
}

void* qteQMenu_addAction_sop(void* _obj, void* text, void* /*context*/, int /*functor*/) {
    // Context+Functor overload not available on Qt5/Windows — fall back to simple addAction
    return (void*)((QMenu*)_obj)->addAction(*(QString*)text);
}

void* qteQMenu_addMenu_p(void* _obj, void* menu) {
    return (void*)((QMenu*)_obj)->addMenu((QMenu*)menu);
}

void* qteQMenu_addMenu_s(void* _obj, void* title) {
    return (void*)((QMenu*)_obj)->addMenu(*(QString*)title);
}

void* qteQMenu_addSeparator(void* _obj) {
    return (void*)((QMenu*)_obj)->addSeparator();
}

void* qteQMenu_addSection(void* _obj, void* text) {
    return (void*)((QMenu*)_obj)->addSection(*(QString*)text);
}

void* qteQMenu_insertMenu(void* _obj, void* before, void* menu) {
    return (void*)((QMenu*)_obj)->insertMenu((QAction*)before, (QMenu*)menu);
}

void* qteQMenu_insertSeparator(void* _obj, void* before) {
    return (void*)((QMenu*)_obj)->insertSeparator((QAction*)before);
}

void* qteQMenu_insertSection(void* _obj, void* before, void* text) {
    return (void*)((QMenu*)_obj)->insertSection((QAction*)before, *(QString*)text);
}

int qteQMenu_isEmpty(void* _obj) {
    return ((QMenu*)_obj)->isEmpty() ? 1 : 0;
}

void qteQMenu_clear(void* _obj) {
    ((QMenu*)_obj)->clear();
}

void qteQMenu_setTearOffEnabled(void* _obj, int p0) {
    ((QMenu*)_obj)->setTearOffEnabled((p0 != 0));
}

int qteQMenu_isTearOffEnabled(void* _obj) {
    return ((QMenu*)_obj)->isTearOffEnabled() ? 1 : 0;
}

int qteQMenu_isTearOffMenuVisible(void* _obj) {
    return ((QMenu*)_obj)->isTearOffMenuVisible() ? 1 : 0;
}

void qteQMenu_showTearOffMenu_v(void* _obj) {
    ((QMenu*)_obj)->showTearOffMenu();
}

void qteQMenu_showTearOffMenu_p(void* _obj, void* pos) {
    ((QMenu*)_obj)->showTearOffMenu(*(const QPoint*)pos);
}

void qteQMenu_hideTearOffMenu(void* _obj) {
    ((QMenu*)_obj)->hideTearOffMenu();
}

void qteQMenu_setDefaultAction(void* _obj, void* p0) {
    ((QMenu*)_obj)->setDefaultAction((QAction*)p0);
}

void* qteQMenu_defaultAction(void* _obj) {
    return (void*)((QMenu*)_obj)->defaultAction();
}

void qteQMenu_setActiveAction(void* _obj, void* act) {
    ((QMenu*)_obj)->setActiveAction((QAction*)act);
}

void* qteQMenu_activeAction(void* _obj) {
    return (void*)((QMenu*)_obj)->activeAction();
}

void qteQMenu_popup(void* _obj, void* pos, void* at) {
    ((QMenu*)_obj)->popup(*(const QPoint*)pos, (QAction*)at);
}

void* qteQMenu_exec_v(void* _obj) {
    return (void*)((QMenu*)_obj)->exec();
}

void* qteQMenu_exec_pp(void* _obj, void* pos, void* at) {
    return (void*)((QMenu*)_obj)->exec(*(const QPoint*)pos, (QAction*)at);
}

void* qteQMenu_actionGeometry(void* _obj, void* p0) {
    return new QRect(((QMenu*)_obj)->actionGeometry((QAction*)p0));
}

void* qteQMenu_actionAt(void* _obj, void* p0) {
    return (void*)((QMenu*)_obj)->actionAt(*(const QPoint*)p0);
}

void* qteQMenu_menuAction(void* _obj) {
    return (void*)((QMenu*)_obj)->menuAction();
}

void* qteQMenu_title(void* _obj) {
    return new QString(((QMenu*)_obj)->title());
}

void qteQMenu_setTitle(void* _obj, void* title) {
    ((QMenu*)_obj)->setTitle(*(QString*)title);
}

void qteQMenu_setNoReplayFor(void* _obj, void* widget) {
    ((QMenu*)_obj)->setNoReplayFor((QWidget*)widget);
}

void* qteQMenu_platformMenu(void* _obj) {
    return (void*)((QMenu*)_obj)->platformMenu();
}

void qteQMenu_setPlatformMenu(void* _obj, void* platformMenu) {
    ((QMenu*)_obj)->setPlatformMenu((QPlatformMenu*)platformMenu);
}

void qteQMenu_setAsDockMenu(void* /*_obj*/) {
    // macOS-only — no-op on Windows
}

int qteQMenu_separatorsCollapsible(void* _obj) {
    return ((QMenu*)_obj)->separatorsCollapsible() ? 1 : 0;
}

void qteQMenu_setSeparatorsCollapsible(void* _obj, int collapse) {
    ((QMenu*)_obj)->setSeparatorsCollapsible((collapse != 0));
}

int qteQMenu_toolTipsVisible(void* _obj) {
    return ((QMenu*)_obj)->toolTipsVisible() ? 1 : 0;
}

void qteQMenu_setToolTipsVisible(void* _obj, int visible) {
    ((QMenu*)_obj)->setToolTipsVisible((visible != 0));
}

// ── Icon-based methods ───────────────────────────────────────────────────────
void* qteQMenu_addAction_is(void* _obj, void* icon, void* text) {
    return (void*)((QMenu*)_obj)->addAction(*(const QIcon*)icon, *(QString*)text);
}
void qteQMenu_addAction_p(void* _obj, void* action) {
    ((QMenu*)_obj)->addAction((QAction*)action);
}

void qteQMenu_setIcon(void* _obj, void* icon) {
    ((QMenu*)_obj)->setIcon(*(const QIcon*)icon);
}

void* qteQMenu_icon(void* _obj) {
    return new QIcon(((QMenu*)_obj)->icon());
}

void* qteQMenu_addMenu_is(void* _obj, void* icon, void* title) {
    return (void*)((QMenu*)_obj)->addMenu(*(const QIcon*)icon, *(QString*)title);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQMenu_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQMenu* obj = (eQMenu*)w;
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

// ── Signals with QAction* parameter ─────────────────────────────────────────
// cb: void function(void* ud, void* action)
void qteQMenu_connect_triggered(void* obj, void (*cb)(void*, void*), void* ud) {
    QObject::connect((QMenu*)obj, &QMenu::triggered,
        [cb, ud](QAction* a){ cb(ud, (void*)a); });
}
void qteQMenu_connect_hovered(void* obj, void (*cb)(void*, void*), void* ud) {
    QObject::connect((QMenu*)obj, &QMenu::hovered,
        [cb, ud](QAction* a){ cb(ud, (void*)a); });
}

// ── actionGeometry ────────────────────────────────────────────────────────────
void qteQMenu_actionGeometry_xywh(void* obj, void* action, int* x, int* y, int* w, int* h) {
    QRect r = ((QMenu*)obj)->actionGeometry((QAction*)action);
    *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
}

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQMenu_actions(void* _obj) {
    QList<QAction*> list = ((QMenu*)_obj)->actions();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}

} // extern "C"
