#ifndef QTE56_QABSTRACTBUTTON_BUILD
#define QTE56_QABSTRACTBUTTON_BUILD
#endif
#include "qte56_qabstractbutton.h"
#include <QAbstractButton>
#include <QIcon>
#include <QString>
#include <QPaintEvent>
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
class eQAbstractButton : public QAbstractButton {
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

    explicit eQAbstractButton(QWidget* parent = nullptr) : QAbstractButton(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QAbstractButton::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QAbstractButton::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QAbstractButton::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QAbstractButton::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QAbstractButton::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QAbstractButton::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QAbstractButton::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QAbstractButton::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QAbstractButton::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QAbstractButton::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QAbstractButton::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QAbstractButton::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QAbstractButton::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QAbstractButton::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QAbstractButton::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QAbstractButton::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QAbstractButton::contextMenuEvent(e);
    }
    void paintEvent(QPaintEvent* e) override {
        // Pure virtual in QAbstractButton, must be overridden
        // Default: do nothing (abstract button is not painted)
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQAbstractButton_create(void* parent) {
    return new eQAbstractButton((QWidget*)parent);
}

void qteQAbstractButton_delete(void* w) {
    delete (eQAbstractButton*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQAbstractButton_setText(void* _obj, void* text) {
    ((QAbstractButton*)_obj)->setText(*(QString*)text);
}

void* qteQAbstractButton_text(void* _obj) {
    return new QString(((QAbstractButton*)_obj)->text());
}

void* qteQAbstractButton_iconSize(void* _obj) {
    return new QSize(((QAbstractButton*)_obj)->iconSize());
}

void qteQAbstractButton_setCheckable(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setCheckable((p0 != 0));
}

int qteQAbstractButton_isCheckable(void* _obj) {
    return ((QAbstractButton*)_obj)->isCheckable() ? 1 : 0;
}

int qteQAbstractButton_isChecked(void* _obj) {
    return ((QAbstractButton*)_obj)->isChecked() ? 1 : 0;
}

void qteQAbstractButton_setDown(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setDown((p0 != 0));
}

int qteQAbstractButton_isDown(void* _obj) {
    return ((QAbstractButton*)_obj)->isDown() ? 1 : 0;
}

void qteQAbstractButton_setAutoRepeat(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setAutoRepeat((p0 != 0));
}

int qteQAbstractButton_autoRepeat(void* _obj) {
    return ((QAbstractButton*)_obj)->autoRepeat() ? 1 : 0;
}

void qteQAbstractButton_setAutoRepeatDelay(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setAutoRepeatDelay(p0);
}

int qteQAbstractButton_autoRepeatDelay(void* _obj) {
    return ((QAbstractButton*)_obj)->autoRepeatDelay();
}

void qteQAbstractButton_setAutoRepeatInterval(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setAutoRepeatInterval(p0);
}

int qteQAbstractButton_autoRepeatInterval(void* _obj) {
    return ((QAbstractButton*)_obj)->autoRepeatInterval();
}

void qteQAbstractButton_setAutoExclusive(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setAutoExclusive((p0 != 0));
}

int qteQAbstractButton_autoExclusive(void* _obj) {
    return ((QAbstractButton*)_obj)->autoExclusive() ? 1 : 0;
}

void* qteQAbstractButton_group(void* _obj) {
    return (void*)((QAbstractButton*)_obj)->group();
}

void qteQAbstractButton_setIconSize(void* _obj, void* size) {
    ((QAbstractButton*)_obj)->setIconSize(*(const QSize*)size);
}

void qteQAbstractButton_animateClick(void* _obj, int msec) {
    // Qt6: animateClick() takes no arguments
    (void)msec;
    ((QAbstractButton*)_obj)->animateClick();
}

void qteQAbstractButton_click(void* _obj) {
    ((QAbstractButton*)_obj)->click();
}

void qteQAbstractButton_toggle(void* _obj) {
    ((QAbstractButton*)_obj)->toggle();
}

void qteQAbstractButton_setChecked(void* _obj, int p0) {
    ((QAbstractButton*)_obj)->setChecked((p0 != 0));
}

// ── Icon ─────────────────────────────────────────────────────────────────────
void qteQAbstractButton_setIcon(void* _obj, void* icon) {
    ((QAbstractButton*)_obj)->setIcon(*(const QIcon*)icon);
}

void* qteQAbstractButton_icon(void* _obj) {
    return new QIcon(((QAbstractButton*)_obj)->icon());
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQAbstractButton_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQAbstractButton* obj = (eQAbstractButton*)w;
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
