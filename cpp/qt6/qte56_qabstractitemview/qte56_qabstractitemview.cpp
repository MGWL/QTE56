#ifndef QTE56_QABSTRACTITEMVIEW_BUILD
#define QTE56_QABSTRACTITEMVIEW_BUILD
#endif
#include "qte56_qabstractitemview.h"
#include <QAbstractItemView>
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
class eQAbstractItemView : public QAbstractItemView {
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

    explicit eQAbstractItemView(QWidget* parent = nullptr) : QAbstractItemView(parent) {}

    // ── Pure virtual stubs ────────────────────────────────────────────────────
    // QAbstractItemView is abstract; must implement all pure virtuals.
    // These stubs are never called directly — concrete subclasses (QListView, etc.)
    // override them. Our proxy is used only for intermediate D-class hierarchy.
    QRect visualRect(const QModelIndex &) const override { return QRect(); }
    void scrollTo(const QModelIndex &, ScrollHint = EnsureVisible) override {}
    QModelIndex indexAt(const QPoint &) const override { return QModelIndex(); }
    QModelIndex moveCursor(CursorAction, Qt::KeyboardModifiers) override { return QModelIndex(); }
    int horizontalOffset() const override { return 0; }
    int verticalOffset() const override { return 0; }
    bool isIndexHidden(const QModelIndex &) const override { return false; }
    void setSelection(const QRect &, QItemSelectionModel::SelectionFlags) override {}
    QRegion visualRegionForSelection(const QItemSelection &) const override { return QRegion(); }

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QAbstractItemView::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QAbstractItemView::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QAbstractItemView::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QAbstractItemView::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QAbstractItemView::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QAbstractItemView::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QAbstractItemView::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QAbstractItemView::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QAbstractItemView::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QAbstractItemView::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QAbstractItemView::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QAbstractItemView::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QAbstractItemView::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QAbstractItemView::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QAbstractItemView::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QAbstractItemView::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QAbstractItemView::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQAbstractItemView_create(void* parent) {
    return new eQAbstractItemView((QWidget*)parent);
}

void qteQAbstractItemView_delete(void* w) {
    delete (eQAbstractItemView*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQAbstractItemView_setModel(void* _obj, void* model) {
    ((QAbstractItemView*)_obj)->setModel((QAbstractItemModel*)model);
}

void* qteQAbstractItemView_model(void* _obj) {
    return (void*)((QAbstractItemView*)_obj)->model();
}

void qteQAbstractItemView_setSelectionModel(void* _obj, void* selectionModel) {
    ((QAbstractItemView*)_obj)->setSelectionModel((QItemSelectionModel*)selectionModel);
}

void* qteQAbstractItemView_selectionModel(void* _obj) {
    return (void*)((QAbstractItemView*)_obj)->selectionModel();
}

void qteQAbstractItemView_setItemDelegate(void* _obj, void* delegate) {
    ((QAbstractItemView*)_obj)->setItemDelegate((QAbstractItemDelegate*)delegate);
}

void* qteQAbstractItemView_itemDelegate(void* _obj) {
    return (void*)((QAbstractItemView*)_obj)->itemDelegate();
}

void qteQAbstractItemView_setSelectionMode(void* _obj, int mode) {
    ((QAbstractItemView*)_obj)->setSelectionMode((QAbstractItemView::SelectionMode)mode);
}

int qteQAbstractItemView_selectionMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->selectionMode();
}

void qteQAbstractItemView_setSelectionBehavior(void* _obj, int behavior) {
    ((QAbstractItemView*)_obj)->setSelectionBehavior((QAbstractItemView::SelectionBehavior)behavior);
}

int qteQAbstractItemView_selectionBehavior(void* _obj) {
    return ((QAbstractItemView*)_obj)->selectionBehavior();
}

void qteQAbstractItemView_setEditTriggers(void* _obj, int triggers) {
    ((QAbstractItemView*)_obj)->setEditTriggers((QAbstractItemView::EditTriggers)triggers);
}

int qteQAbstractItemView_editTriggers(void* _obj) {
    return ((QAbstractItemView*)_obj)->editTriggers();
}

void qteQAbstractItemView_setVerticalScrollMode(void* _obj, int mode) {
    ((QAbstractItemView*)_obj)->setVerticalScrollMode((QAbstractItemView::ScrollMode)mode);
}

int qteQAbstractItemView_verticalScrollMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->verticalScrollMode();
}

void qteQAbstractItemView_resetVerticalScrollMode(void* _obj) {
    ((QAbstractItemView*)_obj)->resetVerticalScrollMode();
}

void qteQAbstractItemView_setHorizontalScrollMode(void* _obj, int mode) {
    ((QAbstractItemView*)_obj)->setHorizontalScrollMode((QAbstractItemView::ScrollMode)mode);
}

int qteQAbstractItemView_horizontalScrollMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->horizontalScrollMode();
}

void qteQAbstractItemView_resetHorizontalScrollMode(void* _obj) {
    ((QAbstractItemView*)_obj)->resetHorizontalScrollMode();
}

void qteQAbstractItemView_setAutoScroll(void* _obj, int enable) {
    ((QAbstractItemView*)_obj)->setAutoScroll((enable != 0));
}

int qteQAbstractItemView_hasAutoScroll(void* _obj) {
    return ((QAbstractItemView*)_obj)->hasAutoScroll() ? 1 : 0;
}

void qteQAbstractItemView_setAutoScrollMargin(void* _obj, int margin) {
    ((QAbstractItemView*)_obj)->setAutoScrollMargin(margin);
}

int qteQAbstractItemView_autoScrollMargin(void* _obj) {
    return ((QAbstractItemView*)_obj)->autoScrollMargin();
}

void qteQAbstractItemView_setTabKeyNavigation(void* _obj, int enable) {
    ((QAbstractItemView*)_obj)->setTabKeyNavigation((enable != 0));
}

int qteQAbstractItemView_tabKeyNavigation(void* _obj) {
    return ((QAbstractItemView*)_obj)->tabKeyNavigation() ? 1 : 0;
}

void qteQAbstractItemView_setDropIndicatorShown(void* _obj, int enable) {
    ((QAbstractItemView*)_obj)->setDropIndicatorShown((enable != 0));
}

int qteQAbstractItemView_showDropIndicator(void* _obj) {
    return ((QAbstractItemView*)_obj)->showDropIndicator() ? 1 : 0;
}

void qteQAbstractItemView_setDragEnabled(void* _obj, int enable) {
    ((QAbstractItemView*)_obj)->setDragEnabled((enable != 0));
}

int qteQAbstractItemView_dragEnabled(void* _obj) {
    return ((QAbstractItemView*)_obj)->dragEnabled() ? 1 : 0;
}

void qteQAbstractItemView_setDragDropOverwriteMode(void* _obj, int overwrite) {
    ((QAbstractItemView*)_obj)->setDragDropOverwriteMode((overwrite != 0));
}

int qteQAbstractItemView_dragDropOverwriteMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->dragDropOverwriteMode() ? 1 : 0;
}

void qteQAbstractItemView_setDragDropMode(void* _obj, int behavior) {
    ((QAbstractItemView*)_obj)->setDragDropMode((QAbstractItemView::DragDropMode)behavior);
}

int qteQAbstractItemView_dragDropMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->dragDropMode();
}

void qteQAbstractItemView_setDefaultDropAction(void* _obj, int dropAction) {
    ((QAbstractItemView*)_obj)->setDefaultDropAction((Qt::DropAction)dropAction);
}

int qteQAbstractItemView_defaultDropAction(void* _obj) {
    return ((QAbstractItemView*)_obj)->defaultDropAction();
}

void qteQAbstractItemView_setAlternatingRowColors(void* _obj, int enable) {
    ((QAbstractItemView*)_obj)->setAlternatingRowColors((enable != 0));
}

int qteQAbstractItemView_alternatingRowColors(void* _obj) {
    return ((QAbstractItemView*)_obj)->alternatingRowColors() ? 1 : 0;
}

void qteQAbstractItemView_setIconSize(void* _obj, void* size) {
    ((QAbstractItemView*)_obj)->setIconSize(*(const QSize*)size);
}

void* qteQAbstractItemView_iconSize(void* _obj) {
    return new QSize(((QAbstractItemView*)_obj)->iconSize());
}

void qteQAbstractItemView_setTextElideMode(void* _obj, int mode) {
    ((QAbstractItemView*)_obj)->setTextElideMode((Qt::TextElideMode)mode);
}

int qteQAbstractItemView_textElideMode(void* _obj) {
    return ((QAbstractItemView*)_obj)->textElideMode();
}

void qteQAbstractItemView_keyboardSearch(void* _obj, void* search) {
    ((QAbstractItemView*)_obj)->keyboardSearch(*(QString*)search);
}

int qteQAbstractItemView_sizeHintForRow(void* _obj, int row) {
    return ((QAbstractItemView*)_obj)->sizeHintForRow(row);
}

int qteQAbstractItemView_sizeHintForColumn(void* _obj, int column) {
    return ((QAbstractItemView*)_obj)->sizeHintForColumn(column);
}

void qteQAbstractItemView_setItemDelegateForRow(void* _obj, int row, void* delegate) {
    ((QAbstractItemView*)_obj)->setItemDelegateForRow(row, (QAbstractItemDelegate*)delegate);
}

void* qteQAbstractItemView_itemDelegateForRow(void* _obj, int row) {
    return (void*)((QAbstractItemView*)_obj)->itemDelegateForRow(row);
}

void qteQAbstractItemView_setItemDelegateForColumn(void* _obj, int column, void* delegate) {
    ((QAbstractItemView*)_obj)->setItemDelegateForColumn(column, (QAbstractItemDelegate*)delegate);
}

void* qteQAbstractItemView_itemDelegateForColumn(void* _obj, int column) {
    return (void*)((QAbstractItemView*)_obj)->itemDelegateForColumn(column);
}

void qteQAbstractItemView_reset(void* _obj) {
    ((QAbstractItemView*)_obj)->reset();
}

void qteQAbstractItemView_doItemsLayout(void* _obj) {
    ((QAbstractItemView*)_obj)->doItemsLayout();
}

void qteQAbstractItemView_selectAll(void* _obj) {
    ((QAbstractItemView*)_obj)->selectAll();
}

void qteQAbstractItemView_clearSelection(void* _obj) {
    ((QAbstractItemView*)_obj)->clearSelection();
}

void qteQAbstractItemView_scrollToTop(void* _obj) {
    ((QAbstractItemView*)_obj)->scrollToTop();
}

void qteQAbstractItemView_scrollToBottom(void* _obj) {
    ((QAbstractItemView*)_obj)->scrollToBottom();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQAbstractItemView_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQAbstractItemView* obj = (eQAbstractItemView*)w;
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
