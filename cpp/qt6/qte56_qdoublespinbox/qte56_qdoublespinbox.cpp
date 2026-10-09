#ifndef QTE56_QDOUBLESPINBOX_BUILD
#define QTE56_QDOUBLESPINBOX_BUILD
#endif
#include "qte56_qdoublespinbox.h"
#include <QDoubleSpinBox>
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
class eQDoubleSpinBox : public QDoubleSpinBox {
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

    explicit eQDoubleSpinBox(QWidget* parent = nullptr) : QDoubleSpinBox(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QDoubleSpinBox::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QDoubleSpinBox::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QDoubleSpinBox::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QDoubleSpinBox::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QDoubleSpinBox::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QDoubleSpinBox::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QDoubleSpinBox::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QDoubleSpinBox::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QDoubleSpinBox::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QDoubleSpinBox::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QDoubleSpinBox::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QDoubleSpinBox::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QDoubleSpinBox::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QDoubleSpinBox::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QDoubleSpinBox::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QDoubleSpinBox::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QDoubleSpinBox::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQDoubleSpinBox_create(void* parent) {
    return new eQDoubleSpinBox((QWidget*)parent);
}

void qteQDoubleSpinBox_delete(void* w) {
    delete (eQDoubleSpinBox*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
double qteQDoubleSpinBox_value(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->value();
}

void* qteQDoubleSpinBox_prefix(void* _obj) {
    return new QString(((QDoubleSpinBox*)_obj)->prefix());
}

void qteQDoubleSpinBox_setPrefix(void* _obj, void* prefix) {
    ((QDoubleSpinBox*)_obj)->setPrefix(*(QString*)prefix);
}

void* qteQDoubleSpinBox_suffix(void* _obj) {
    return new QString(((QDoubleSpinBox*)_obj)->suffix());
}

void qteQDoubleSpinBox_setSuffix(void* _obj, void* suffix) {
    ((QDoubleSpinBox*)_obj)->setSuffix(*(QString*)suffix);
}

void* qteQDoubleSpinBox_cleanText(void* _obj) {
    return new QString(((QDoubleSpinBox*)_obj)->cleanText());
}

double qteQDoubleSpinBox_singleStep(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->singleStep();
}

void qteQDoubleSpinBox_setSingleStep(void* _obj, double val) {
    ((QDoubleSpinBox*)_obj)->setSingleStep(val);
}

double qteQDoubleSpinBox_minimum(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->minimum();
}

void qteQDoubleSpinBox_setMinimum(void* _obj, double min) {
    ((QDoubleSpinBox*)_obj)->setMinimum(min);
}

double qteQDoubleSpinBox_maximum(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->maximum();
}

void qteQDoubleSpinBox_setMaximum(void* _obj, double max) {
    ((QDoubleSpinBox*)_obj)->setMaximum(max);
}

void qteQDoubleSpinBox_setRange(void* _obj, double min, double max) {
    ((QDoubleSpinBox*)_obj)->setRange(min, max);
}

int qteQDoubleSpinBox_stepType(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->stepType();
}

void qteQDoubleSpinBox_setStepType(void* _obj, int stepType) {
    ((QDoubleSpinBox*)_obj)->setStepType((QDoubleSpinBox::StepType)stepType);
}

int qteQDoubleSpinBox_decimals(void* _obj) {
    return ((QDoubleSpinBox*)_obj)->decimals();
}

void qteQDoubleSpinBox_setDecimals(void* _obj, int prec) {
    ((QDoubleSpinBox*)_obj)->setDecimals(prec);
}

double qteQDoubleSpinBox_valueFromText(void* _obj, void* text) {
    return ((QDoubleSpinBox*)_obj)->valueFromText(*(QString*)text);
}

void* qteQDoubleSpinBox_textFromValue(void* _obj, double val) {
    return new QString(((QDoubleSpinBox*)_obj)->textFromValue(val));
}

void qteQDoubleSpinBox_setValue(void* _obj, double val) {
    ((QDoubleSpinBox*)_obj)->setValue(val);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQDoubleSpinBox_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQDoubleSpinBox* obj = (eQDoubleSpinBox*)w;
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
