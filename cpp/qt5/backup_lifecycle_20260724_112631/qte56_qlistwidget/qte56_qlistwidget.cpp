#ifndef QTE56_QLISTWIDGET_BUILD
#define QTE56_QLISTWIDGET_BUILD
#endif
#include "qte56_qlistwidget.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QListWidget>
#include <QListWidgetItem>
#include <QString>
#include <QIcon>
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

// ─── Event + Signal proxy ─────────────────────────────────────────────────────
class eQListWidget : public QListWidget {
public:
    // 17 event callbacks
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

    // Signal callbacks (direct, no eSlot needed)
    void* cb_itemClicked     = nullptr; void* dt_itemClicked     = nullptr;
    void* cb_itemDblClicked  = nullptr; void* dt_itemDblClicked  = nullptr;
    void* cb_itemChanged     = nullptr; void* dt_itemChanged     = nullptr;
    void* cb_currentRowChan  = nullptr; void* dt_currentRowChan  = nullptr;
    void* cb_currentTextChan = nullptr; void* dt_currentTextChan = nullptr;
    void* cb_selChanged      = nullptr; void* dt_selChanged      = nullptr;
    void* cb_itemActivated   = nullptr; void* dt_itemActivated   = nullptr;

    explicit eQListWidget(QWidget* parent = nullptr) : QListWidget(parent) {
        connect(this, &QListWidget::itemClicked, this, &eQListWidget::onItemClicked);
        connect(this, &QListWidget::itemDoubleClicked, this, &eQListWidget::onItemDblClicked);
        connect(this, &QListWidget::itemChanged, this, &eQListWidget::onItemChanged);
        connect(this, &QListWidget::currentRowChanged, this, &eQListWidget::onCurrentRowChanged);
        connect(this, &QListWidget::currentTextChanged, this, &eQListWidget::onCurrentTextChanged);
        connect(this, &QListWidget::itemSelectionChanged, this, &eQListWidget::onSelChanged);
        connect(this, &QListWidget::itemActivated, this, &eQListWidget::onItemActivated);
    }

    // ── Signal slots ──────────────────────────────────────────────────────────
    void onItemClicked(QListWidgetItem* item) {
        if (cb_itemClicked) ((void(*)(void*,int,void*))cb_itemClicked)(dt_itemClicked, 0, (void*)item);
    }
    void onItemDblClicked(QListWidgetItem* item) {
        if (cb_itemDblClicked) ((void(*)(void*,int,void*))cb_itemDblClicked)(dt_itemDblClicked, 0, (void*)item);
    }
    void onItemChanged(QListWidgetItem* item) {
        if (cb_itemChanged) ((void(*)(void*,int,void*))cb_itemChanged)(dt_itemChanged, 0, (void*)item);
    }
    void onCurrentRowChanged(int row) {
        if (cb_currentRowChan) ((void(*)(void*,int,int))cb_currentRowChan)(dt_currentRowChan, 0, row);
    }
    void onCurrentTextChanged(const QString& text) {
        if (cb_currentTextChan) ((void(*)(void*,int,void*))cb_currentTextChan)(dt_currentTextChan, 0, (void*)&text);
    }
    void onSelChanged() {
        if (cb_selChanged) ((void(*)(void*,int))cb_selChanged)(dt_selChanged, 0);
    }
    void onItemActivated(QListWidgetItem* item) {
        if (cb_itemActivated) ((void(*)(void*,int,void*))cb_itemActivated)(dt_itemActivated, 0, (void*)item);
    }

    // ── Event overrides ───────────────────────────────────────────────────────
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int,int))cb_01)(dt_01, 1, e->x(), e->y(), e->button()); else QListWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int,int))cb_02)(dt_02, 2, e->x(), e->y(), e->button()); else QListWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int,int))cb_03)(dt_03, 3, e->x(), e->y(), e->button()); else QListWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int,int,int))cb_04)(dt_04, 4, e->x(), e->y(), e->buttons()); else QListWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, 5, e->key()); else QListWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, 6, e->key()); else QListWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        QListWidget::resizeEvent(e);
        if (cb_07) ((void(*)(void*,int,int,int))cb_07)(dt_07, 7, e->size().width(), e->size().height());
    }
    void moveEvent(QMoveEvent* e) override {
        QListWidget::moveEvent(e);
        if (cb_08) ((void(*)(void*,int,int,int))cb_08)(dt_08, 8, e->pos().x(), e->pos().y());
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) { int accept = 1; ((void(*)(void*,int,void*))cb_09)(dt_09, 9, &accept); if (!accept) { e->ignore(); return; } } e->accept();
    }
    void showEvent(QShowEvent* e) override {
        QListWidget::showEvent(e);
        if (cb_10) ((void(*)(void*,int))cb_10)(dt_10, 10);
    }
    void hideEvent(QHideEvent* e) override {
        QListWidget::hideEvent(e);
        if (cb_11) ((void(*)(void*,int))cb_11)(dt_11, 11);
    }
    void enterEvent(QEvent* e) override {
        QListWidget::enterEvent(e);
        if (cb_12) ((void(*)(void*,int))cb_12)(dt_12, 12);
    }
    void leaveEvent(QEvent* e) override {
        QListWidget::leaveEvent(e);
        if (cb_13) ((void(*)(void*,int))cb_13)(dt_13, 13);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) { ((void(*)(void*,int,int,int))cb_14)(dt_14, 14, e->angleDelta().y(), e->modifiers()); e->accept(); } else QListWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        QListWidget::focusInEvent(e);
        if (cb_15) ((void(*)(void*,int,int))cb_15)(dt_15, 15, e->reason());
    }
    void focusOutEvent(QFocusEvent* e) override {
        QListWidget::focusOutEvent(e);
        if (cb_16) ((void(*)(void*,int,int))cb_16)(dt_16, 16, e->reason());
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) { ((void(*)(void*,int,int,int))cb_17)(dt_17, 17, e->x(), e->y()); e->accept(); } else QListWidget::contextMenuEvent(e);
    }
};

// ── QListWidgetItem lifecycle ─────────────────────────────────────────────────

void* qteQListWidgetItem_create(void* listwidget, int type) {
    return new QListWidgetItem((QListWidget*)listwidget, type);
}

void* qteQListWidgetItem_create_text(void* text, void* listwidget, int type) {
    return new QListWidgetItem(*(QString*)text, (QListWidget*)listwidget, type);
}

void qteQListWidgetItem_delete(void* item) {
    delete (QListWidgetItem*)item;
}

// ── QListWidgetItem methods ───────────────────────────────────────────────────

void* qteQListWidgetItem_text(void* item) {
    return new QString(((QListWidgetItem*)item)->text());
}

void qteQListWidgetItem_setText(void* item, void* text) {
    ((QListWidgetItem*)item)->setText(*(QString*)text);
}

int qteQListWidgetItem_isSelected(void* item) {
    return ((QListWidgetItem*)item)->isSelected() ? 1 : 0;
}

void qteQListWidgetItem_setSelected(void* item, int sel) {
    ((QListWidgetItem*)item)->setSelected(sel != 0);
}

int qteQListWidgetItem_checkState(void* item) {
    return (int)((QListWidgetItem*)item)->checkState();
}

void qteQListWidgetItem_setCheckState(void* item, int state) {
    ((QListWidgetItem*)item)->setCheckState((Qt::CheckState)state);
}

int qteQListWidgetItem_flags(void* item) {
    return (int)((QListWidgetItem*)item)->flags();
}

void qteQListWidgetItem_setFlags(void* item, int flags) {
    ((QListWidgetItem*)item)->setFlags((Qt::ItemFlags)flags);
}

void qteQListWidgetItem_setIcon(void* item, void* icon) {
    ((QListWidgetItem*)item)->setIcon(*(const QIcon*)icon);
}

void* qteQListWidgetItem_toolTip(void* item) {
    return new QString(((QListWidgetItem*)item)->toolTip());
}

void qteQListWidgetItem_setToolTip(void* item, void* text) {
    ((QListWidgetItem*)item)->setToolTip(*(QString*)text);
}

int qteQListWidgetItem_type(void* item) {
    return ((QListWidgetItem*)item)->type();
}

// ── QListWidget lifecycle ─────────────────────────────────────────────────────

void* qteQListWidget_create(void* parent) {
    return qte_createTracked(new eQListWidget((QWidget*)parent);
}

void qteQListWidget_delete(void* w) {
    delete (eQListWidget*)w;
}

// ── QListWidget methods ───────────────────────────────────────────────────────

void qteQListWidget_addItem(void* w, void* text) {
    ((QListWidget*)w)->addItem(*(QString*)text);
}

void qteQListWidget_insertItem(void* w, int row, void* text) {
    ((QListWidget*)w)->insertItem(row, *(QString*)text);
}

void qteQListWidget_addItemW(void* w, void* item) {
    ((QListWidget*)w)->addItem((QListWidgetItem*)item);
}

void qteQListWidget_insertItemW(void* w, int row, void* item) {
    ((QListWidget*)w)->insertItem(row, (QListWidgetItem*)item);
}

int qteQListWidget_count(void* w) {
    return ((QListWidget*)w)->count();
}

void* qteQListWidget_item(void* w, int row) {
    return (void*)((QListWidget*)w)->item(row);
}

int qteQListWidget_row(void* w, void* item) {
    return ((QListWidget*)w)->row((QListWidgetItem*)item);
}

int qteQListWidget_currentRow(void* w) {
    return ((QListWidget*)w)->currentRow();
}

void qteQListWidget_setCurrentRow(void* w, int row) {
    ((QListWidget*)w)->setCurrentRow(row);
}

void* qteQListWidget_currentItem(void* w) {
    return (void*)((QListWidget*)w)->currentItem();
}

void* qteQListWidget_takeItem(void* w, int row) {
    return (void*)((QListWidget*)w)->takeItem(row);
}

void qteQListWidget_clear(void* w) {
    ((QListWidget*)w)->clear();
}

void qteQListWidget_sortItems(void* w, int order) {
    ((QListWidget*)w)->sortItems((Qt::SortOrder)order);
}

int qteQListWidget_isSortingEnabled(void* w) {
    return ((QListWidget*)w)->isSortingEnabled() ? 1 : 0;
}

void qteQListWidget_setSortingEnabled(void* w, int enable) {
    ((QListWidget*)w)->setSortingEnabled(enable != 0);
}

void* qteQListWidget_itemAt(void* w, int x, int y) {
    return (void*)((QListWidget*)w)->itemAt(x, y);
}

void qteQListWidget_scrollToItem(void* w, void* item) {
    ((QListWidget*)w)->scrollToItem((QListWidgetItem*)item);
}

// ── Signal connect functions ──────────────────────────────────────────────────
extern "C" {

void qteQListWidget_connectItemClicked(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_itemClicked = cb; obj->dt_itemClicked = dthis;
}

void qteQListWidget_connectItemDoubleClicked(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_itemDblClicked = cb; obj->dt_itemDblClicked = dthis;
}

void qteQListWidget_connectItemChanged(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_itemChanged = cb; obj->dt_itemChanged = dthis;
}

void qteQListWidget_connectCurrentRowChanged(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_currentRowChan = cb; obj->dt_currentRowChan = dthis;
}

void qteQListWidget_connectCurrentTextChanged(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_currentTextChan = cb; obj->dt_currentTextChan = dthis;
}

void qteQListWidget_connectItemSelectionChanged(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_selChanged = cb; obj->dt_selChanged = dthis;
}

void qteQListWidget_connectItemActivated(void* w, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
    obj->cb_itemActivated = cb; obj->dt_itemActivated = dthis;
}

} // end extern "C" signal connect functions

// ── Event handler ─────────────────────────────────────────────────────────────
void qteQListWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQListWidget* obj = (eQListWidget*)w;
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

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQListWidget_selectedItems(void* _obj) {
    QList<QListWidgetItem*> list = ((QListWidget*)_obj)->selectedItems();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}
