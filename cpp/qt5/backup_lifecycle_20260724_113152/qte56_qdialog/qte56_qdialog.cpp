#ifndef QTE56_QDIALOG_BUILD
#define QTE56_QDIALOG_BUILD
#endif
#include "qte56_qdialog.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QDialog>
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
class eQDialog : public QDialog {
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

    explicit eQDialog(QWidget* parent = nullptr, Qt::WindowFlags flags = Qt::WindowFlags())
        : QDialog(parent, flags) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QDialog::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QDialog::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QDialog::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QDialog::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QDialog::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QDialog::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QDialog::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QDialog::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QDialog::closeEvent(e);  // default: calls reject()
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QDialog::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QDialog::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QDialog::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QDialog::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QDialog::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QDialog::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QDialog::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QDialog::contextMenuEvent(e);
    }
};

extern "C" {

void* qteQDialog_create(void* parent, int flags) {
    return qte_createTracked(new eQDialog((QWidget*)parent, (Qt::WindowFlags)flags));
}
void qteQDialog_delete(void* _obj) {
    delete (eQDialog*)_obj;
}
int qteQDialog_exec(void* _obj) {
    return ((eQDialog*)_obj)->exec();
}
void qteQDialog_accept(void* _obj) {
    ((eQDialog*)_obj)->accept();
}
void qteQDialog_reject(void* _obj) {
    ((eQDialog*)_obj)->reject();
}
void qteQDialog_done(void* _obj, int result) {
    ((eQDialog*)_obj)->done(result);
}
int qteQDialog_result(void* _obj) {
    return ((eQDialog*)_obj)->result();
}
void qteQDialog_setModal(void* _obj, int modal) {
    ((eQDialog*)_obj)->setModal(modal != 0);
}
int qteQDialog_isModal(void* _obj) {
    return ((eQDialog*)_obj)->isModal() ? 1 : 0;
}
void qteQDialog_open(void* _obj) {
    ((eQDialog*)_obj)->open();
}
void qteQDialog_setSizeGripEnabled(void* _obj, int enabled) {
    ((eQDialog*)_obj)->setSizeGripEnabled(enabled != 0);
}
int qteQDialog_isSizeGripEnabled(void* _obj) {
    return ((eQDialog*)_obj)->isSizeGripEnabled() ? 1 : 0;
}
void qteQDialog_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQDialog* obj = (eQDialog*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;
        default: break;
    }
}

} // extern "C"
