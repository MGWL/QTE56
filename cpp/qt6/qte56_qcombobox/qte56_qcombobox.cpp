#ifndef QTE56_QCOMBOBOX_BUILD
#define QTE56_QCOMBOBOX_BUILD
#endif
#include "qte56_qcombobox.h"
#include <QComboBox>
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
class eQComboBox : public QComboBox {
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

    explicit eQComboBox(QWidget* parent = nullptr) : QComboBox(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QComboBox::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QComboBox::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QComboBox::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QComboBox::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QComboBox::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QComboBox::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QComboBox::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QComboBox::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QComboBox::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QComboBox::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QComboBox::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QComboBox::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QComboBox::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QComboBox::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QComboBox::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QComboBox::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QComboBox::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQComboBox_create(void* parent) {
    return new eQComboBox((QWidget*)parent);
}

void qteQComboBox_delete(void* w) {
    delete (eQComboBox*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQComboBox_show(void* _obj) {
    ((QComboBox*)_obj)->show();
}

void qteQComboBox_hide(void* _obj) {
    ((QComboBox*)_obj)->hide();
}

void qteQComboBox_update(void* _obj) {
    ((QComboBox*)_obj)->update();
}

int qteQComboBox_maxVisibleItems(void* _obj) {
    return ((QComboBox*)_obj)->maxVisibleItems();
}

void qteQComboBox_setMaxVisibleItems(void* _obj, int maxItems) {
    ((QComboBox*)_obj)->setMaxVisibleItems(maxItems);
}

int qteQComboBox_count(void* _obj) {
    return ((QComboBox*)_obj)->count();
}

void qteQComboBox_setMaxCount(void* _obj, int max) {
    ((QComboBox*)_obj)->setMaxCount(max);
}

int qteQComboBox_maxCount(void* _obj) {
    return ((QComboBox*)_obj)->maxCount();
}

int qteQComboBox_autoCompletion(void* _obj) {
    // autoCompletion removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQComboBox_setAutoCompletion(void* _obj, int enable) {
    // setAutoCompletion removed in Qt6 — no-op
    (void)_obj; (void)enable;
}

int qteQComboBox_autoCompletionCaseSensitivity(void* _obj) {
    // autoCompletionCaseSensitivity removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQComboBox_setAutoCompletionCaseSensitivity(void* _obj, int sensitivity) {
    // setAutoCompletionCaseSensitivity removed in Qt6 — no-op
    (void)_obj; (void)sensitivity;
}

int qteQComboBox_duplicatesEnabled(void* _obj) {
    return ((QComboBox*)_obj)->duplicatesEnabled() ? 1 : 0;
}

void qteQComboBox_setDuplicatesEnabled(void* _obj, int enable) {
    ((QComboBox*)_obj)->setDuplicatesEnabled((enable != 0));
}

void qteQComboBox_setFrame(void* _obj, int p0) {
    ((QComboBox*)_obj)->setFrame((p0 != 0));
}

int qteQComboBox_hasFrame(void* _obj) {
    return ((QComboBox*)_obj)->hasFrame() ? 1 : 0;
}

int qteQComboBox_insertPolicy(void* _obj) {
    return ((QComboBox*)_obj)->insertPolicy();
}

void qteQComboBox_setInsertPolicy(void* _obj, int policy) {
    ((QComboBox*)_obj)->setInsertPolicy((QComboBox::InsertPolicy)policy);
}

int qteQComboBox_sizeAdjustPolicy(void* _obj) {
    return ((QComboBox*)_obj)->sizeAdjustPolicy();
}

void qteQComboBox_setSizeAdjustPolicy(void* _obj, int policy) {
    ((QComboBox*)_obj)->setSizeAdjustPolicy((QComboBox::SizeAdjustPolicy)policy);
}

int qteQComboBox_minimumContentsLength(void* _obj) {
    return ((QComboBox*)_obj)->minimumContentsLength();
}

void qteQComboBox_setMinimumContentsLength(void* _obj, int characters) {
    ((QComboBox*)_obj)->setMinimumContentsLength(characters);
}

void* qteQComboBox_iconSize(void* _obj) {
    return new QSize(((QComboBox*)_obj)->iconSize());
}

void qteQComboBox_setIconSize(void* _obj, void* size) {
    ((QComboBox*)_obj)->setIconSize(*(const QSize*)size);
}

int qteQComboBox_isEditable(void* _obj) {
    return ((QComboBox*)_obj)->isEditable() ? 1 : 0;
}

void qteQComboBox_setEditable(void* _obj, int editable) {
    ((QComboBox*)_obj)->setEditable((editable != 0));
}

void qteQComboBox_setLineEdit(void* _obj, void* edit) {
    ((QComboBox*)_obj)->setLineEdit((QLineEdit*)edit);
}

void qteQComboBox_setValidator(void* _obj, void* v) {
    ((QComboBox*)_obj)->setValidator((const QValidator*)v);
}

void qteQComboBox_setCompleter(void* _obj, void* c) {
    ((QComboBox*)_obj)->setCompleter((QCompleter*)c);
}

void qteQComboBox_setItemDelegate(void* _obj, void* delegate) {
    ((QComboBox*)_obj)->setItemDelegate((QAbstractItemDelegate*)delegate);
}

void qteQComboBox_setModel(void* _obj, void* model) {
    ((QComboBox*)_obj)->setModel((QAbstractItemModel*)model);
}

int qteQComboBox_modelColumn(void* _obj) {
    return ((QComboBox*)_obj)->modelColumn();
}

void qteQComboBox_setModelColumn(void* _obj, int visibleColumn) {
    ((QComboBox*)_obj)->setModelColumn(visibleColumn);
}

int qteQComboBox_currentIndex(void* _obj) {
    return ((QComboBox*)_obj)->currentIndex();
}

void* qteQComboBox_currentText(void* _obj) {
    return new QString(((QComboBox*)_obj)->currentText());
}

void* qteQComboBox_itemText(void* _obj, int index) {
    return new QString(((QComboBox*)_obj)->itemText(index));
}

void qteQComboBox_addItem(void* _obj, void* text) {
    ((QComboBox*)_obj)->addItem(*(QString*)text);
}

void qteQComboBox_insertItem(void* _obj, int index, void* text) {
    ((QComboBox*)_obj)->insertItem(index, *(QString*)text);
}

void qteQComboBox_insertSeparator(void* _obj, int index) {
    ((QComboBox*)_obj)->insertSeparator(index);
}

void qteQComboBox_removeItem(void* _obj, int index) {
    ((QComboBox*)_obj)->removeItem(index);
}

void qteQComboBox_setItemText(void* _obj, int index, void* text) {
    ((QComboBox*)_obj)->setItemText(index, *(QString*)text);
}

void qteQComboBox_setView(void* _obj, void* itemView) {
    ((QComboBox*)_obj)->setView((QAbstractItemView*)itemView);
}

void* qteQComboBox_sizeHint(void* _obj) {
    return new QSize(((QComboBox*)_obj)->sizeHint());
}

void* qteQComboBox_minimumSizeHint(void* _obj) {
    return new QSize(((QComboBox*)_obj)->minimumSizeHint());
}

void qteQComboBox_showPopup(void* _obj) {
    ((QComboBox*)_obj)->showPopup();
}

void qteQComboBox_hidePopup(void* _obj) {
    ((QComboBox*)_obj)->hidePopup();
}

int qteQComboBox_event(void* _obj, void* event) {
    return ((QComboBox*)_obj)->event((QEvent*)event) ? 1 : 0;
}

void qteQComboBox_clear(void* _obj) {
    ((QComboBox*)_obj)->clear();
}

void qteQComboBox_clearEditText(void* _obj) {
    ((QComboBox*)_obj)->clearEditText();
}

void qteQComboBox_setEditText(void* _obj, void* text) {
    ((QComboBox*)_obj)->setEditText(*(QString*)text);
}

void qteQComboBox_setCurrentIndex(void* _obj, int index) {
    ((QComboBox*)_obj)->setCurrentIndex(index);
}

void qteQComboBox_setCurrentText(void* _obj, void* text) {
    ((QComboBox*)_obj)->setCurrentText(*(QString*)text);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQComboBox_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQComboBox* obj = (eQComboBox*)w;
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
