#ifndef QTE56_QPROGRESSDIALOG_BUILD
#define QTE56_QPROGRESSDIALOG_BUILD
#endif
#include "qte56_qprogressdialog.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QProgressDialog>
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
class eQProgressDialog : public QProgressDialog {
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

    explicit eQProgressDialog(QWidget* parent = nullptr) : QProgressDialog(parent) {}
    explicit eQProgressDialog(const QString& text, QWidget* parent = nullptr)
        : QProgressDialog(text, QString(), 0, 100, parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QProgressDialog::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QProgressDialog::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QProgressDialog::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QProgressDialog::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QProgressDialog::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QProgressDialog::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QProgressDialog::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QProgressDialog::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QProgressDialog::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QProgressDialog::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QProgressDialog::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QProgressDialog::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QProgressDialog::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QProgressDialog::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QProgressDialog::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QProgressDialog::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QProgressDialog::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQProgressDialog_create(void* parent) {
    return qte_createTracked(new eQProgressDialog((QWidget*)parent));
}

void qteQProgressDialog_delete(void* w) {
    delete (eQProgressDialog*)w;
}

void* qteQProgressDialog_create_text(void* text, void* parent) {
    return qte_createTracked(new eQProgressDialog(*(QString*)text, (QWidget*)parent));
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQProgressDialog_setLabel(void* _obj, void* label) {
    ((QProgressDialog*)_obj)->setLabel((QLabel*)label);
}

void qteQProgressDialog_setCancelButton(void* _obj, void* button) {
    ((QProgressDialog*)_obj)->setCancelButton((QPushButton*)button);
}

void qteQProgressDialog_setBar(void* _obj, void* bar) {
    ((QProgressDialog*)_obj)->setBar((QProgressBar*)bar);
}

int qteQProgressDialog_wasCanceled(void* _obj) {
    return ((QProgressDialog*)_obj)->wasCanceled() ? 1 : 0;
}

int qteQProgressDialog_minimum(void* _obj) {
    return ((QProgressDialog*)_obj)->minimum();
}

int qteQProgressDialog_maximum(void* _obj) {
    return ((QProgressDialog*)_obj)->maximum();
}

int qteQProgressDialog_value(void* _obj) {
    return ((QProgressDialog*)_obj)->value();
}

void* qteQProgressDialog_labelText(void* _obj) {
    return new QString(((QProgressDialog*)_obj)->labelText());
}

int qteQProgressDialog_minimumDuration(void* _obj) {
    return ((QProgressDialog*)_obj)->minimumDuration();
}

void qteQProgressDialog_setAutoReset(void* _obj, int reset) {
    ((QProgressDialog*)_obj)->setAutoReset((reset != 0));
}

int qteQProgressDialog_autoReset(void* _obj) {
    return ((QProgressDialog*)_obj)->autoReset() ? 1 : 0;
}

void qteQProgressDialog_setAutoClose(void* _obj, int close) {
    ((QProgressDialog*)_obj)->setAutoClose((close != 0));
}

int qteQProgressDialog_autoClose(void* _obj) {
    return ((QProgressDialog*)_obj)->autoClose() ? 1 : 0;
}

void qteQProgressDialog_cancel(void* _obj) {
    ((QProgressDialog*)_obj)->cancel();
}

void qteQProgressDialog_reset(void* _obj) {
    ((QProgressDialog*)_obj)->reset();
}

void qteQProgressDialog_setMaximum(void* _obj, int maximum) {
    ((QProgressDialog*)_obj)->setMaximum(maximum);
}

void qteQProgressDialog_setMinimum(void* _obj, int minimum) {
    ((QProgressDialog*)_obj)->setMinimum(minimum);
}

void qteQProgressDialog_setRange(void* _obj, int minimum, int maximum) {
    ((QProgressDialog*)_obj)->setRange(minimum, maximum);
}

void qteQProgressDialog_setValue(void* _obj, int progress) {
    ((QProgressDialog*)_obj)->setValue(progress);
}

void qteQProgressDialog_setLabelText(void* _obj, void* text) {
    ((QProgressDialog*)_obj)->setLabelText(*(QString*)text);
}

void qteQProgressDialog_setCancelButtonText(void* _obj, void* text) {
    ((QProgressDialog*)_obj)->setCancelButtonText(*(QString*)text);
}

void qteQProgressDialog_setMinimumDuration(void* _obj, int ms) {
    ((QProgressDialog*)_obj)->setMinimumDuration(ms);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQProgressDialog_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQProgressDialog* obj = (eQProgressDialog*)w;
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
