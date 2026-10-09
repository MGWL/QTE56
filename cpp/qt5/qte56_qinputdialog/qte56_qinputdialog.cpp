#ifndef QTE56_QINPUTDIALOG_BUILD
#define QTE56_QINPUTDIALOG_BUILD
#endif
#include "qte56_qinputdialog.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QInputDialog>
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
class eQInputDialog : public QInputDialog {
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

    explicit eQInputDialog(QWidget* parent = nullptr) : QInputDialog(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QInputDialog::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QInputDialog::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QInputDialog::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QInputDialog::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QInputDialog::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QInputDialog::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QInputDialog::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QInputDialog::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QInputDialog::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QInputDialog::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QInputDialog::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QInputDialog::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QInputDialog::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QInputDialog::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QInputDialog::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QInputDialog::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QInputDialog::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQInputDialog_create(void* parent) {
    return qte_createTracked(new eQInputDialog((QWidget*)parent));
}

void qteQInputDialog_delete(void* w) {
    delete (eQInputDialog*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQInputDialog_show(void* _obj) {
    ((QInputDialog*)_obj)->show();
}

void qteQInputDialog_hide(void* _obj) {
    ((QInputDialog*)_obj)->hide();
}

void qteQInputDialog_update(void* _obj) {
    ((QInputDialog*)_obj)->update();
}

void qteQInputDialog_setInputMode(void* _obj, int mode) {
    ((QInputDialog*)_obj)->setInputMode((QInputDialog::InputMode)mode);
}

int qteQInputDialog_inputMode(void* _obj) {
    return ((QInputDialog*)_obj)->inputMode();
}

void qteQInputDialog_setLabelText(void* _obj, void* text) {
    ((QInputDialog*)_obj)->setLabelText(*(QString*)text);
}

void* qteQInputDialog_labelText(void* _obj) {
    return new QString(((QInputDialog*)_obj)->labelText());
}

void qteQInputDialog_setOption(void* _obj, int option, int on) {
    ((QInputDialog*)_obj)->setOption((QInputDialog::InputDialogOption)option, (on != 0));
}

int qteQInputDialog_testOption(void* _obj, int option) {
    return ((QInputDialog*)_obj)->testOption((QInputDialog::InputDialogOption)option) ? 1 : 0;
}

void qteQInputDialog_setOptions(void* _obj, int options) {
    ((QInputDialog*)_obj)->setOptions((QInputDialog::InputDialogOptions)options);
}

int qteQInputDialog_options(void* _obj) {
    return ((QInputDialog*)_obj)->options();
}

void qteQInputDialog_setTextValue(void* _obj, void* text) {
    ((QInputDialog*)_obj)->setTextValue(*(QString*)text);
}

void* qteQInputDialog_textValue(void* _obj) {
    return new QString(((QInputDialog*)_obj)->textValue());
}

void qteQInputDialog_setTextEchoMode(void* _obj, int mode) {
    ((QInputDialog*)_obj)->setTextEchoMode((QLineEdit::EchoMode)mode);
}

int qteQInputDialog_textEchoMode(void* _obj) {
    return ((QInputDialog*)_obj)->textEchoMode();
}

void qteQInputDialog_setComboBoxEditable(void* _obj, int editable) {
    ((QInputDialog*)_obj)->setComboBoxEditable((editable != 0));
}

int qteQInputDialog_isComboBoxEditable(void* _obj) {
    return ((QInputDialog*)_obj)->isComboBoxEditable() ? 1 : 0;
}

void qteQInputDialog_setIntValue(void* _obj, int value) {
    ((QInputDialog*)_obj)->setIntValue(value);
}

int qteQInputDialog_intValue(void* _obj) {
    return ((QInputDialog*)_obj)->intValue();
}

void qteQInputDialog_setIntMinimum(void* _obj, int min) {
    ((QInputDialog*)_obj)->setIntMinimum(min);
}

int qteQInputDialog_intMinimum(void* _obj) {
    return ((QInputDialog*)_obj)->intMinimum();
}

void qteQInputDialog_setIntMaximum(void* _obj, int max) {
    ((QInputDialog*)_obj)->setIntMaximum(max);
}

int qteQInputDialog_intMaximum(void* _obj) {
    return ((QInputDialog*)_obj)->intMaximum();
}

void qteQInputDialog_setIntRange(void* _obj, int min, int max) {
    ((QInputDialog*)_obj)->setIntRange(min, max);
}

void qteQInputDialog_setIntStep(void* _obj, int step) {
    ((QInputDialog*)_obj)->setIntStep(step);
}

int qteQInputDialog_intStep(void* _obj) {
    return ((QInputDialog*)_obj)->intStep();
}

void qteQInputDialog_setDoubleValue(void* _obj, double value) {
    ((QInputDialog*)_obj)->setDoubleValue(value);
}

double qteQInputDialog_doubleValue(void* _obj) {
    return ((QInputDialog*)_obj)->doubleValue();
}

void qteQInputDialog_setDoubleMinimum(void* _obj, double min) {
    ((QInputDialog*)_obj)->setDoubleMinimum(min);
}

double qteQInputDialog_doubleMinimum(void* _obj) {
    return ((QInputDialog*)_obj)->doubleMinimum();
}

void qteQInputDialog_setDoubleMaximum(void* _obj, double max) {
    ((QInputDialog*)_obj)->setDoubleMaximum(max);
}

double qteQInputDialog_doubleMaximum(void* _obj) {
    return ((QInputDialog*)_obj)->doubleMaximum();
}

void qteQInputDialog_setDoubleRange(void* _obj, double min, double max) {
    ((QInputDialog*)_obj)->setDoubleRange(min, max);
}

void qteQInputDialog_setDoubleDecimals(void* _obj, int decimals) {
    ((QInputDialog*)_obj)->setDoubleDecimals(decimals);
}

int qteQInputDialog_doubleDecimals(void* _obj) {
    return ((QInputDialog*)_obj)->doubleDecimals();
}

void qteQInputDialog_setOkButtonText(void* _obj, void* text) {
    ((QInputDialog*)_obj)->setOkButtonText(*(QString*)text);
}

void* qteQInputDialog_okButtonText(void* _obj) {
    return new QString(((QInputDialog*)_obj)->okButtonText());
}

void qteQInputDialog_setCancelButtonText(void* _obj, void* text) {
    ((QInputDialog*)_obj)->setCancelButtonText(*(QString*)text);
}

void* qteQInputDialog_cancelButtonText(void* _obj) {
    return new QString(((QInputDialog*)_obj)->cancelButtonText());
}

void* qteQInputDialog_minimumSizeHint(void* _obj) {
    return new QSize(((QInputDialog*)_obj)->minimumSizeHint());
}

void* qteQInputDialog_sizeHint(void* _obj) {
    return new QSize(((QInputDialog*)_obj)->sizeHint());
}

void qteQInputDialog_setVisible(void* _obj, int visible) {
    ((QInputDialog*)_obj)->setVisible((visible != 0));
}

void* qteQInputDialog_getText(void* _obj, void* parent, void* title, void* label, int echo, void* text, void* ok, int flags, int inputMethodHints) {
    return new QString(QInputDialog::getText((QWidget*)parent, *(QString*)title, *(QString*)label, (QLineEdit::EchoMode)echo, *(QString*)text, (bool*)ok, (Qt::WindowFlags)flags, (Qt::InputMethodHints)inputMethodHints));
}

void* qteQInputDialog_getMultiLineText(void* _obj, void* parent, void* title, void* label, void* text, void* ok, int flags, int inputMethodHints) {
    return new QString(QInputDialog::getMultiLineText((QWidget*)parent, *(QString*)title, *(QString*)label, *(QString*)text, (bool*)ok, (Qt::WindowFlags)flags, (Qt::InputMethodHints)inputMethodHints));
}

int qteQInputDialog_getInt(void* _obj, void* parent, void* title, void* label, int value, int minValue, int maxValue, int step, void* ok, int flags) {
    return QInputDialog::getInt((QWidget*)parent, *(QString*)title, *(QString*)label, value, minValue, maxValue, step, (bool*)ok, (Qt::WindowFlags)flags);
}

double qteQInputDialog_getDouble_wssdddipp(void* _obj, void* parent, void* title, void* label, double value, double minValue, double maxValue, int decimals, void* ok, int flags) {
    return QInputDialog::getDouble((QWidget*)parent, *(QString*)title, *(QString*)label, value, minValue, maxValue, decimals, (bool*)ok, (Qt::WindowFlags)flags);
}

double qteQInputDialog_getDouble_wssdddippd(void* _obj, void* parent, void* title, void* label, double value, double minValue, double maxValue, int decimals, void* ok, int flags, double step) {
    return QInputDialog::getDouble((QWidget*)parent, *(QString*)title, *(QString*)label, value, minValue, maxValue, decimals, (bool*)ok, (Qt::WindowFlags)flags, step);
}

// setComboBoxItems: items — строки, объединённые \x01
void qteQInputDialog_setComboBoxItems(void* _obj, void* items_sep1) {
    if (!items_sep1) { ((QInputDialog*)_obj)->setComboBoxItems(QStringList()); return; }
    const QString& s = *(const QString*)items_sep1;
    ((QInputDialog*)_obj)->setComboBoxItems(s.isEmpty() ? QStringList() : s.split(QChar(1)));
}

void qteQInputDialog_setDoubleStep(void* _obj, double step) {
    ((QInputDialog*)_obj)->setDoubleStep(step);
}

double qteQInputDialog_doubleStep(void* _obj) {
    return ((QInputDialog*)_obj)->doubleStep();
}

void qteQInputDialog_done(void* _obj, int result) {
    ((QInputDialog*)_obj)->done(result);
}

int qteQInputDialog_result(void* _obj) {
    return ((QInputDialog*)_obj)->result();
}

void qteQInputDialog_setSizeGripEnabled(void* _obj, int p0) {
    ((QInputDialog*)_obj)->setSizeGripEnabled((p0 != 0));
}

int qteQInputDialog_isSizeGripEnabled(void* _obj) {
    return ((QInputDialog*)_obj)->isSizeGripEnabled() ? 1 : 0;
}

void qteQInputDialog_setModal(void* _obj, int modal) {
    ((QInputDialog*)_obj)->setModal((modal != 0));
}

void qteQInputDialog_setResult(void* _obj, int r) {
    ((QInputDialog*)_obj)->setResult(r);
}

void qteQInputDialog_open(void* _obj) {
    ((QInputDialog*)_obj)->open();
}

int qteQInputDialog_exec(void* _obj) {
    return ((QInputDialog*)_obj)->exec();
}

void qteQInputDialog_accept(void* _obj) {
    ((QInputDialog*)_obj)->accept();
}

void qteQInputDialog_reject(void* _obj) {
    ((QInputDialog*)_obj)->reject();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQInputDialog_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQInputDialog* obj = (eQInputDialog*)w;
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
