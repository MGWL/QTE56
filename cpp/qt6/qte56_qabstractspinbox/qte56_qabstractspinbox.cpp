#ifndef QTE56_QABSTRACTSPINBOX_BUILD
#define QTE56_QABSTRACTSPINBOX_BUILD
#endif
#include "qte56_qabstractspinbox.h"
#include <QAbstractSpinBox>
#include <QString>
#include <QValidator>
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
class eQAbstractSpinBox : public QAbstractSpinBox {
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

    explicit eQAbstractSpinBox(QWidget* parent = nullptr) : QAbstractSpinBox(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QAbstractSpinBox::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QAbstractSpinBox::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QAbstractSpinBox::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QAbstractSpinBox::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QAbstractSpinBox::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QAbstractSpinBox::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QAbstractSpinBox::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QAbstractSpinBox::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QAbstractSpinBox::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QAbstractSpinBox::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QAbstractSpinBox::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QAbstractSpinBox::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QAbstractSpinBox::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QAbstractSpinBox::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QAbstractSpinBox::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QAbstractSpinBox::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QAbstractSpinBox::contextMenuEvent(e);
    }
    QValidator::State validate(QString &input, int &pos) const override {
        // Pure virtual, must override. Default: accept all input.
        (void)input; (void)pos;
        return QValidator::Acceptable;
    }
    void fixup(QString &input) const override {
        // Pure virtual, must override. Default: no fixup.
        (void)input;
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQAbstractSpinBox_create(void* parent) {
    return new eQAbstractSpinBox((QWidget*)parent);
}

void qteQAbstractSpinBox_delete(void* w) {
    delete (eQAbstractSpinBox*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQAbstractSpinBox_buttonSymbols(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->buttonSymbols();
}

void qteQAbstractSpinBox_setButtonSymbols(void* _obj, int bs) {
    ((QAbstractSpinBox*)_obj)->setButtonSymbols((QAbstractSpinBox::ButtonSymbols)bs);
}

void qteQAbstractSpinBox_setCorrectionMode(void* _obj, int cm) {
    ((QAbstractSpinBox*)_obj)->setCorrectionMode((QAbstractSpinBox::CorrectionMode)cm);
}

int qteQAbstractSpinBox_correctionMode(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->correctionMode();
}

int qteQAbstractSpinBox_hasAcceptableInput(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->hasAcceptableInput() ? 1 : 0;
}

void* qteQAbstractSpinBox_text(void* _obj) {
    return new QString(((QAbstractSpinBox*)_obj)->text());
}

void* qteQAbstractSpinBox_specialValueText(void* _obj) {
    return new QString(((QAbstractSpinBox*)_obj)->specialValueText());
}

void qteQAbstractSpinBox_setSpecialValueText(void* _obj, void* txt) {
    ((QAbstractSpinBox*)_obj)->setSpecialValueText(*(QString*)txt);
}

int qteQAbstractSpinBox_wrapping(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->wrapping() ? 1 : 0;
}

void qteQAbstractSpinBox_setWrapping(void* _obj, int w) {
    ((QAbstractSpinBox*)_obj)->setWrapping((w != 0));
}

void qteQAbstractSpinBox_setReadOnly(void* _obj, int r) {
    ((QAbstractSpinBox*)_obj)->setReadOnly((r != 0));
}

int qteQAbstractSpinBox_isReadOnly(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->isReadOnly() ? 1 : 0;
}

void qteQAbstractSpinBox_setKeyboardTracking(void* _obj, int kt) {
    ((QAbstractSpinBox*)_obj)->setKeyboardTracking((kt != 0));
}

int qteQAbstractSpinBox_keyboardTracking(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->keyboardTracking() ? 1 : 0;
}

void qteQAbstractSpinBox_setAlignment(void* _obj, int flag) {
    ((QAbstractSpinBox*)_obj)->setAlignment((Qt::Alignment)flag);
}

int qteQAbstractSpinBox_alignment(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->alignment();
}

void qteQAbstractSpinBox_setFrame(void* _obj, int p0) {
    ((QAbstractSpinBox*)_obj)->setFrame((p0 != 0));
}

int qteQAbstractSpinBox_hasFrame(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->hasFrame() ? 1 : 0;
}

void qteQAbstractSpinBox_setAccelerated(void* _obj, int on) {
    ((QAbstractSpinBox*)_obj)->setAccelerated((on != 0));
}

int qteQAbstractSpinBox_isAccelerated(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->isAccelerated() ? 1 : 0;
}

void qteQAbstractSpinBox_setGroupSeparatorShown(void* _obj, int shown) {
    ((QAbstractSpinBox*)_obj)->setGroupSeparatorShown((shown != 0));
}

int qteQAbstractSpinBox_isGroupSeparatorShown(void* _obj) {
    return ((QAbstractSpinBox*)_obj)->isGroupSeparatorShown() ? 1 : 0;
}

void qteQAbstractSpinBox_interpretText(void* _obj) {
    ((QAbstractSpinBox*)_obj)->interpretText();
}

int qteQAbstractSpinBox_event(void* _obj, void* event) {
    return ((QAbstractSpinBox*)_obj)->event((QEvent*)event) ? 1 : 0;
}

void qteQAbstractSpinBox_fixup(void* _obj, void* input) {
    QString str = *(QString*)input;
    ((QAbstractSpinBox*)_obj)->fixup(str);
}

void qteQAbstractSpinBox_stepBy(void* _obj, int steps) {
    ((QAbstractSpinBox*)_obj)->stepBy(steps);
}

void qteQAbstractSpinBox_stepUp(void* _obj) {
    ((QAbstractSpinBox*)_obj)->stepUp();
}

void qteQAbstractSpinBox_stepDown(void* _obj) {
    ((QAbstractSpinBox*)_obj)->stepDown();
}

void qteQAbstractSpinBox_selectAll(void* _obj) {
    ((QAbstractSpinBox*)_obj)->selectAll();
}

void qteQAbstractSpinBox_clear(void* _obj) {
    ((QAbstractSpinBox*)_obj)->clear();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQAbstractSpinBox_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQAbstractSpinBox* obj = (eQAbstractSpinBox*)w;
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
