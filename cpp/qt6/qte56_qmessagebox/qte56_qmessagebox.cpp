#ifndef QTE56_QMESSAGEBOX_BUILD
#define QTE56_QMESSAGEBOX_BUILD
#endif
#include "qte56_qmessagebox.h"
#include <QMessageBox>
#include <QString>
#include <QAbstractButton>
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
class eQMessageBox : public QMessageBox {
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

    explicit eQMessageBox(QWidget* parent = nullptr) : QMessageBox(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QMessageBox::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QMessageBox::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QMessageBox::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QMessageBox::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QMessageBox::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QMessageBox::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QMessageBox::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QMessageBox::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QMessageBox::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QMessageBox::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QMessageBox::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QMessageBox::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QMessageBox::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QMessageBox::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QMessageBox::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QMessageBox::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QMessageBox::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQMessageBox_create(void* parent) {
    return new eQMessageBox((QWidget*)parent);
}

void qteQMessageBox_delete(void* w) {
    delete (eQMessageBox*)w;
}

void* qteQMessageBox_create_text(void* /*text*/, void* parent) {
    // Qt5 QMessageBox has no (text, parent) ctor — fall back to bare parent ctor
    return new eQMessageBox((QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQMessageBox_show(void* _obj) {
    ((QMessageBox*)_obj)->show();
}

void qteQMessageBox_hide(void* _obj) {
    ((QMessageBox*)_obj)->hide();
}

void qteQMessageBox_update(void* _obj) {
    ((QMessageBox*)_obj)->update();
}

void qteQMessageBox_addButton_pp(void* _obj, void* button, int role) {
    ((QMessageBox*)_obj)->addButton((QAbstractButton*)button, (QMessageBox::ButtonRole)role);
}

void* qteQMessageBox_addButton_sp(void* _obj, void* text, int role) {
    return (void*)((QMessageBox*)_obj)->addButton(*(QString*)text, (QMessageBox::ButtonRole)role);
}

void* qteQMessageBox_addButton_p(void* _obj, int button) {
    return (void*)((QMessageBox*)_obj)->addButton((QMessageBox::StandardButton)button);
}

void qteQMessageBox_removeButton(void* _obj, void* button) {
    ((QMessageBox*)_obj)->removeButton((QAbstractButton*)button);
}

int qteQMessageBox_buttonRole(void* _obj, void* button) {
    return ((QMessageBox*)_obj)->buttonRole((QAbstractButton*)button);
}

void qteQMessageBox_setStandardButtons(void* _obj, int buttons) {
    ((QMessageBox*)_obj)->setStandardButtons((QMessageBox::StandardButtons)buttons);
}

int qteQMessageBox_standardButtons(void* _obj) {
    return ((QMessageBox*)_obj)->standardButtons();
}

int qteQMessageBox_standardButton(void* _obj, void* button) {
    return ((QMessageBox*)_obj)->standardButton((QAbstractButton*)button);
}

void* qteQMessageBox_button(void* _obj, int which) {
    return (void*)((QMessageBox*)_obj)->button((QMessageBox::StandardButton)which);
}

void* qteQMessageBox_defaultButton(void* _obj) {
    return (void*)((QMessageBox*)_obj)->defaultButton();
}

void qteQMessageBox_setDefaultButton(void* _obj, int button) {
    ((QMessageBox*)_obj)->setDefaultButton((QMessageBox::StandardButton)button);
}

void* qteQMessageBox_escapeButton(void* _obj) {
    return (void*)((QMessageBox*)_obj)->escapeButton();
}

void qteQMessageBox_setEscapeButton(void* _obj, int button) {
    ((QMessageBox*)_obj)->setEscapeButton((QMessageBox::StandardButton)button);
}

void* qteQMessageBox_clickedButton(void* _obj) {
    return (void*)((QMessageBox*)_obj)->clickedButton();
}

void* qteQMessageBox_text(void* _obj) {
    return new QString(((QMessageBox*)_obj)->text());
}

void qteQMessageBox_setText(void* _obj, void* text) {
    ((QMessageBox*)_obj)->setText(*(QString*)text);
}

int qteQMessageBox_icon(void* _obj) {
    return ((QMessageBox*)_obj)->icon();
}

void qteQMessageBox_setIcon(void* _obj, int p0) {
    ((QMessageBox*)_obj)->setIcon((QMessageBox::Icon)p0);
}

int qteQMessageBox_textFormat(void* _obj) {
    return ((QMessageBox*)_obj)->textFormat();
}

void qteQMessageBox_setTextFormat(void* _obj, int format) {
    ((QMessageBox*)_obj)->setTextFormat((Qt::TextFormat)format);
}

void qteQMessageBox_setTextInteractionFlags(void* _obj, int flags) {
    ((QMessageBox*)_obj)->setTextInteractionFlags((Qt::TextInteractionFlags)flags);
}

int qteQMessageBox_textInteractionFlags(void* _obj) {
    return ((QMessageBox*)_obj)->textInteractionFlags();
}

void qteQMessageBox_setCheckBox(void* _obj, void* cb) {
    ((QMessageBox*)_obj)->setCheckBox((QCheckBox*)cb);
}

void* qteQMessageBox_checkBox(void* _obj) {
    return (void*)((QMessageBox*)_obj)->checkBox();
}

int qteQMessageBox_information_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton) {
    return ((QMessageBox*)_obj)->information((QWidget*)parent, *(QString*)title, *(QString*)text, (QMessageBox::StandardButtons)buttons, (QMessageBox::StandardButton)defaultButton);
}

int qteQMessageBox_warning_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton) {
    return ((QMessageBox*)_obj)->warning((QWidget*)parent, *(QString*)title, *(QString*)text, (QMessageBox::StandardButtons)buttons, (QMessageBox::StandardButton)defaultButton);
}

int qteQMessageBox_critical_wsspp(void* _obj, void* parent, void* title, void* text, int buttons, int defaultButton) {
    return ((QMessageBox*)_obj)->critical((QWidget*)parent, *(QString*)title, *(QString*)text, (QMessageBox::StandardButtons)buttons, (QMessageBox::StandardButton)defaultButton);
}

void qteQMessageBox_about(void* _obj, void* parent, void* title, void* text) {
    ((QMessageBox*)_obj)->about((QWidget*)parent, *(QString*)title, *(QString*)text);
}

void qteQMessageBox_aboutQt(void* _obj, void* parent, void* title) {
    ((QMessageBox*)_obj)->aboutQt((QWidget*)parent, *(QString*)title);
}

int qteQMessageBox_information_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2) {
    return ((QMessageBox*)_obj)->information((QWidget*)parent, *(QString*)title, *(QString*)text, button0, button1, button2);
}

int qteQMessageBox_information_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber) {
    return ((QMessageBox*)_obj)->information((QWidget*)parent, *(QString*)title, *(QString*)text, *(QString*)button0Text, *(QString*)button1Text, *(QString*)button2Text, defaultButtonNumber, escapeButtonNumber);
}

int qteQMessageBox_question_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2) {
    return ((QMessageBox*)_obj)->question((QWidget*)parent, *(QString*)title, *(QString*)text, button0, button1, button2);
}

int qteQMessageBox_question_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber) {
    return ((QMessageBox*)_obj)->question((QWidget*)parent, *(QString*)title, *(QString*)text, *(QString*)button0Text, *(QString*)button1Text, *(QString*)button2Text, defaultButtonNumber, escapeButtonNumber);
}

int qteQMessageBox_warning_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2) {
    return ((QMessageBox*)_obj)->warning((QWidget*)parent, *(QString*)title, *(QString*)text, button0, button1, button2);
}

int qteQMessageBox_warning_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber) {
    return ((QMessageBox*)_obj)->warning((QWidget*)parent, *(QString*)title, *(QString*)text, *(QString*)button0Text, *(QString*)button1Text, *(QString*)button2Text, defaultButtonNumber, escapeButtonNumber);
}

int qteQMessageBox_critical_wssiii(void* _obj, void* parent, void* title, void* text, int button0, int button1, int button2) {
    return ((QMessageBox*)_obj)->critical((QWidget*)parent, *(QString*)title, *(QString*)text, button0, button1, button2);
}

int qteQMessageBox_critical_wsssssii(void* _obj, void* parent, void* title, void* text, void* button0Text, void* button1Text, void* button2Text, int defaultButtonNumber, int escapeButtonNumber) {
    return ((QMessageBox*)_obj)->critical((QWidget*)parent, *(QString*)title, *(QString*)text, *(QString*)button0Text, *(QString*)button1Text, *(QString*)button2Text, defaultButtonNumber, escapeButtonNumber);
}

void* qteQMessageBox_buttonText(void* _obj, int button) {
    return new QString(((QMessageBox*)_obj)->buttonText(button));
}

void qteQMessageBox_setButtonText(void* _obj, int button, void* text) {
    ((QMessageBox*)_obj)->setButtonText(button, *(QString*)text);
}

void* qteQMessageBox_informativeText(void* _obj) {
    return new QString(((QMessageBox*)_obj)->informativeText());
}

void qteQMessageBox_setInformativeText(void* _obj, void* text) {
    ((QMessageBox*)_obj)->setInformativeText(*(QString*)text);
}

void* qteQMessageBox_detailedText(void* _obj) {
    return new QString(((QMessageBox*)_obj)->detailedText());
}

void qteQMessageBox_setDetailedText(void* _obj, void* text) {
    ((QMessageBox*)_obj)->setDetailedText(*(QString*)text);
}

void qteQMessageBox_setWindowTitle(void* _obj, void* title) {
    ((QMessageBox*)_obj)->setWindowTitle(*(QString*)title);
}

void qteQMessageBox_setWindowModality(void* _obj, int windowModality) {
    ((QMessageBox*)_obj)->setWindowModality((Qt::WindowModality)windowModality);
}

int qteQMessageBox_exec(void* _obj) {
    return ((QMessageBox*)_obj)->exec();
}

int qteQMessageBox_result(void* _obj) {
    return ((QMessageBox*)_obj)->result();
}

void qteQMessageBox_setVisible(void* _obj, int visible) {
    ((QMessageBox*)_obj)->setVisible((visible != 0));
}

void* qteQMessageBox_sizeHint(void* _obj) {
    return new QSize(((QMessageBox*)_obj)->sizeHint());
}

void* qteQMessageBox_minimumSizeHint(void* _obj) {
    return new QSize(((QMessageBox*)_obj)->minimumSizeHint());
}

void qteQMessageBox_setSizeGripEnabled(void* _obj, int p0) {
    ((QMessageBox*)_obj)->setSizeGripEnabled((p0 != 0));
}

int qteQMessageBox_isSizeGripEnabled(void* _obj) {
    return ((QMessageBox*)_obj)->isSizeGripEnabled() ? 1 : 0;
}

void qteQMessageBox_setModal(void* _obj, int modal) {
    ((QMessageBox*)_obj)->setModal((modal != 0));
}

void qteQMessageBox_setResult(void* _obj, int r) {
    ((QMessageBox*)_obj)->setResult(r);
}

void qteQMessageBox_open(void* _obj) {
    ((QMessageBox*)_obj)->open();
}

void qteQMessageBox_done(void* _obj, int p0) {
    ((QMessageBox*)_obj)->done(p0);
}

void qteQMessageBox_accept(void* _obj) {
    ((QMessageBox*)_obj)->accept();
}

void qteQMessageBox_reject(void* _obj) {
    ((QMessageBox*)_obj)->reject();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQMessageBox_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQMessageBox* obj = (eQMessageBox*)w;
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

// ── question(StandardButtons) — manual addition ──────────────────────────────
int qteQMessageBox_question_wsspp(void* /*_obj*/, void* parent, void* title, void* text, int buttons, int defaultButton) {
    return QMessageBox::question((QWidget*)parent, *(QString*)title, *(QString*)text, (QMessageBox::StandardButtons)buttons, (QMessageBox::StandardButton)defaultButton);
}

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
// Signal: buttonClicked(QAbstractButton*)
void qteQMessageBox_connect_buttonClicked(void* w, void* cb, void* dthis) {
    QObject::connect((QMessageBox*)w, &QMessageBox::buttonClicked,
        [cb, dthis](QAbstractButton* p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)p);
        });
}

} // extern "C"
