#ifndef QTE56_QPROGRESSBAR_BUILD
#define QTE56_QPROGRESSBAR_BUILD
#endif
#include "qte56_qprogressbar.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QProgressBar>
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
class eQProgressBar : public QProgressBar {
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

    explicit eQProgressBar(QWidget* parent = nullptr) : QProgressBar(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QProgressBar::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QProgressBar::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QProgressBar::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QProgressBar::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QProgressBar::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QProgressBar::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QProgressBar::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QProgressBar::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QProgressBar::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QProgressBar::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QProgressBar::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QProgressBar::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QProgressBar::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QProgressBar::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QProgressBar::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QProgressBar::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QProgressBar::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQProgressBar_create(void* parent) {
    return qte_createTracked(new eQProgressBar((QWidget*)parent);
}

void qteQProgressBar_delete(void* w) {
    delete (eQProgressBar*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQProgressBar_minimum(void* _obj) {
    return ((QProgressBar*)_obj)->minimum();
}

int qteQProgressBar_maximum(void* _obj) {
    return ((QProgressBar*)_obj)->maximum();
}

int qteQProgressBar_value(void* _obj) {
    return ((QProgressBar*)_obj)->value();
}

void* qteQProgressBar_text(void* _obj) {
    return new QString(((QProgressBar*)_obj)->text());
}

void qteQProgressBar_setTextVisible(void* _obj, int visible) {
    ((QProgressBar*)_obj)->setTextVisible((visible != 0));
}

int qteQProgressBar_isTextVisible(void* _obj) {
    return ((QProgressBar*)_obj)->isTextVisible() ? 1 : 0;
}

int qteQProgressBar_alignment(void* _obj) {
    return ((QProgressBar*)_obj)->alignment();
}

void qteQProgressBar_setAlignment(void* _obj, int alignment) {
    ((QProgressBar*)_obj)->setAlignment((Qt::Alignment)alignment);
}

int qteQProgressBar_orientation(void* _obj) {
    return ((QProgressBar*)_obj)->orientation();
}

void qteQProgressBar_setInvertedAppearance(void* _obj, int invert) {
    ((QProgressBar*)_obj)->setInvertedAppearance((invert != 0));
}

int qteQProgressBar_invertedAppearance(void* _obj) {
    return ((QProgressBar*)_obj)->invertedAppearance() ? 1 : 0;
}

void qteQProgressBar_setTextDirection(void* _obj, int textDirection) {
    ((QProgressBar*)_obj)->setTextDirection((QProgressBar::Direction)textDirection);
}

int qteQProgressBar_textDirection(void* _obj) {
    return ((QProgressBar*)_obj)->textDirection();
}

void qteQProgressBar_setFormat(void* _obj, void* format) {
    ((QProgressBar*)_obj)->setFormat(*(QString*)format);
}

void qteQProgressBar_resetFormat(void* _obj) {
    ((QProgressBar*)_obj)->resetFormat();
}

void* qteQProgressBar_format(void* _obj) {
    return new QString(((QProgressBar*)_obj)->format());
}

void qteQProgressBar_reset(void* _obj) {
    ((QProgressBar*)_obj)->reset();
}

void qteQProgressBar_setRange(void* _obj, int minimum, int maximum) {
    ((QProgressBar*)_obj)->setRange(minimum, maximum);
}

void qteQProgressBar_setMinimum(void* _obj, int minimum) {
    ((QProgressBar*)_obj)->setMinimum(minimum);
}

void qteQProgressBar_setMaximum(void* _obj, int maximum) {
    ((QProgressBar*)_obj)->setMaximum(maximum);
}

void qteQProgressBar_setValue(void* _obj, int value) {
    ((QProgressBar*)_obj)->setValue(value);
}

void qteQProgressBar_setOrientation(void* _obj, int p0) {
    ((QProgressBar*)_obj)->setOrientation((Qt::Orientation)p0);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQProgressBar_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQProgressBar* obj = (eQProgressBar*)w;
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
