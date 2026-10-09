#ifndef QTE56_QTABLEWIDGET_BUILD
#define QTE56_QTABLEWIDGET_BUILD
#endif
#include "qte56_qtablewidget.h"
#include <QTableWidget>
#include <QStringList>
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
class eQTableWidget : public QTableWidget {
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

    explicit eQTableWidget(QWidget* parent = nullptr) : QTableWidget(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QTableWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QTableWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QTableWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QTableWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QTableWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QTableWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QTableWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QTableWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QTableWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QTableWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QTableWidget::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QTableWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QTableWidget::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QTableWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QTableWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QTableWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QTableWidget::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTableWidget_create(void* parent) {
    return new eQTableWidget((QWidget*)parent);
}

void qteQTableWidget_delete(void* w) {
    delete (eQTableWidget*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQTableWidget_setRowCount(void* _obj, int rows) {
    ((QTableWidget*)_obj)->setRowCount(rows);
}

int qteQTableWidget_rowCount(void* _obj) {
    return ((QTableWidget*)_obj)->rowCount();
}

void qteQTableWidget_setColumnCount(void* _obj, int columns) {
    ((QTableWidget*)_obj)->setColumnCount(columns);
}

int qteQTableWidget_columnCount(void* _obj) {
    return ((QTableWidget*)_obj)->columnCount();
}

int qteQTableWidget_row(void* _obj, void* item) {
    return ((QTableWidget*)_obj)->row((const QTableWidgetItem*)item);
}

int qteQTableWidget_column(void* _obj, void* item) {
    return ((QTableWidget*)_obj)->column((const QTableWidgetItem*)item);
}

void* qteQTableWidget_item(void* _obj, int row, int column) {
    return (void*)((QTableWidget*)_obj)->item(row, column);
}

void qteQTableWidget_setItem(void* _obj, int row, int column, void* item) {
    ((QTableWidget*)_obj)->setItem(row, column, (QTableWidgetItem*)item);
}

void* qteQTableWidget_takeItem(void* _obj, int row, int column) {
    return (void*)((QTableWidget*)_obj)->takeItem(row, column);
}

void* qteQTableWidget_verticalHeaderItem(void* _obj, int row) {
    return (void*)((QTableWidget*)_obj)->verticalHeaderItem(row);
}

void qteQTableWidget_setVerticalHeaderItem(void* _obj, int row, void* item) {
    ((QTableWidget*)_obj)->setVerticalHeaderItem(row, (QTableWidgetItem*)item);
}

void* qteQTableWidget_takeVerticalHeaderItem(void* _obj, int row) {
    return (void*)((QTableWidget*)_obj)->takeVerticalHeaderItem(row);
}

void* qteQTableWidget_horizontalHeaderItem(void* _obj, int column) {
    return (void*)((QTableWidget*)_obj)->horizontalHeaderItem(column);
}

void qteQTableWidget_setHorizontalHeaderItem(void* _obj, int column, void* item) {
    ((QTableWidget*)_obj)->setHorizontalHeaderItem(column, (QTableWidgetItem*)item);
}

void* qteQTableWidget_takeHorizontalHeaderItem(void* _obj, int column) {
    return (void*)((QTableWidget*)_obj)->takeHorizontalHeaderItem(column);
}

int qteQTableWidget_currentRow(void* _obj) {
    return ((QTableWidget*)_obj)->currentRow();
}

int qteQTableWidget_currentColumn(void* _obj) {
    return ((QTableWidget*)_obj)->currentColumn();
}

void* qteQTableWidget_currentItem(void* _obj) {
    return (void*)((QTableWidget*)_obj)->currentItem();
}

void qteQTableWidget_setCurrentItem_p(void* _obj, void* item) {
    ((QTableWidget*)_obj)->setCurrentItem((QTableWidgetItem*)item);
}

void qteQTableWidget_setCurrentItem_pp(void* _obj, void* item, int command) {
    ((QTableWidget*)_obj)->setCurrentItem((QTableWidgetItem*)item, (QItemSelectionModel::SelectionFlags)command);
}

void qteQTableWidget_setCurrentCell_ii(void* _obj, int row, int column) {
    ((QTableWidget*)_obj)->setCurrentCell(row, column);
}

void qteQTableWidget_setCurrentCell_iip(void* _obj, int row, int column, int command) {
    ((QTableWidget*)_obj)->setCurrentCell(row, column, (QItemSelectionModel::SelectionFlags)command);
}

void qteQTableWidget_sortItems(void* _obj, int column, int order) {
    ((QTableWidget*)_obj)->sortItems(column, (Qt::SortOrder)order);
}

void qteQTableWidget_editItem(void* _obj, void* item) {
    ((QTableWidget*)_obj)->editItem((QTableWidgetItem*)item);
}

void qteQTableWidget_openPersistentEditor(void* _obj, void* item) {
    ((QTableWidget*)_obj)->openPersistentEditor((QTableWidgetItem*)item);
}

void qteQTableWidget_closePersistentEditor(void* _obj, void* item) {
    ((QTableWidget*)_obj)->closePersistentEditor((QTableWidgetItem*)item);
}

int qteQTableWidget_isPersistentEditorOpen(void* _obj, void* item) {
    return ((QTableWidget*)_obj)->isPersistentEditorOpen((QTableWidgetItem*)item) ? 1 : 0;
}

void* qteQTableWidget_cellWidget(void* _obj, int row, int column) {
    return (void*)((QTableWidget*)_obj)->cellWidget(row, column);
}

void qteQTableWidget_setCellWidget(void* _obj, int row, int column, void* widget) {
    ((QTableWidget*)_obj)->setCellWidget(row, column, (QWidget*)widget);
}

void qteQTableWidget_removeCellWidget(void* _obj, int row, int column) {
    ((QTableWidget*)_obj)->removeCellWidget(row, column);
}

int qteQTableWidget_isItemSelected(void* _obj, void* item) {
    // Qt6: isItemSelected() removed, use QTableWidgetItem::isSelected()
    (void)_obj;
    return ((QTableWidgetItem*)item)->isSelected() ? 1 : 0;
}

void qteQTableWidget_setItemSelected(void* _obj, void* item, int select) {
    // Qt6: setItemSelected() removed, use QTableWidgetItem::setSelected()
    (void)_obj;
    ((QTableWidgetItem*)item)->setSelected((select != 0));
}

int qteQTableWidget_visualRow(void* _obj, int logicalRow) {
    return ((QTableWidget*)_obj)->visualRow(logicalRow);
}

int qteQTableWidget_visualColumn(void* _obj, int logicalColumn) {
    return ((QTableWidget*)_obj)->visualColumn(logicalColumn);
}

void* qteQTableWidget_itemAt_p(void* _obj, void* p) {
    return (void*)((QTableWidget*)_obj)->itemAt(*(const QPoint*)p);
}

void* qteQTableWidget_itemAt_ii(void* _obj, int x, int y) {
    return (void*)((QTableWidget*)_obj)->itemAt(x, y);
}

void* qteQTableWidget_visualItemRect(void* _obj, void* item) {
    return new QRect(((QTableWidget*)_obj)->visualItemRect((const QTableWidgetItem*)item));
}

void* qteQTableWidget_itemPrototype(void* _obj) {
    return (void*)((QTableWidget*)_obj)->itemPrototype();
}

void qteQTableWidget_setItemPrototype(void* _obj, void* item) {
    ((QTableWidget*)_obj)->setItemPrototype((const QTableWidgetItem*)item);
}

void qteQTableWidget_scrollToItem(void* _obj, void* item, int hint) {
    ((QTableWidget*)_obj)->scrollToItem((const QTableWidgetItem*)item, (QAbstractItemView::ScrollHint)hint);
}

void qteQTableWidget_insertRow(void* _obj, int row) {
    ((QTableWidget*)_obj)->insertRow(row);
}

void qteQTableWidget_insertColumn(void* _obj, int column) {
    ((QTableWidget*)_obj)->insertColumn(column);
}

void qteQTableWidget_removeRow(void* _obj, int row) {
    ((QTableWidget*)_obj)->removeRow(row);
}

void qteQTableWidget_removeColumn(void* _obj, int column) {
    ((QTableWidget*)_obj)->removeColumn(column);
}

void qteQTableWidget_clear(void* _obj) {
    ((QTableWidget*)_obj)->clear();
}

void qteQTableWidget_clearContents(void* _obj) {
    ((QTableWidget*)_obj)->clearContents();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQTableWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQTableWidget* obj = (eQTableWidget*)w;
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

// ── QTableWidgetItem helpers ──────────────────────────────────────────────────
void* qteQTableWidgetItem_create(void* text) {
    return new QTableWidgetItem(*(QString*)text);
}

void* qteQTableWidgetItem_create_empty(void* /*unused*/) {
    return new QTableWidgetItem();
}

void qteQTableWidgetItem_delete(void* item) {
    delete (QTableWidgetItem*)item;
}

void* qteQTableWidgetItem_text(void* item) {
    return new QString(((QTableWidgetItem*)item)->text());
}

void qteQTableWidgetItem_setText(void* item, void* text) {
    ((QTableWidgetItem*)item)->setText(*(QString*)text);
}

int qteQTableWidgetItem_flags(void* item) {
    return (int)((QTableWidgetItem*)item)->flags();
}

void qteQTableWidgetItem_setFlags(void* item, int flags) {
    ((QTableWidgetItem*)item)->setFlags((Qt::ItemFlags)flags);
}

int qteQTableWidgetItem_textAlignment(void* item) {
    return ((QTableWidgetItem*)item)->textAlignment();
}

void qteQTableWidgetItem_setTextAlignment(void* item, int alignment) {
    ((QTableWidgetItem*)item)->setTextAlignment(alignment);
}

// ── QStringList helpers (sep=\x01) ───────────────────────────────────────────

static QStringList qsListFromSep1_tw(void* qs) {
    if (!qs) return QStringList();
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1));
}

void qteQTableWidget_setHorizontalHeaderLabels(void* _obj, void* items_sep1) {
    ((QTableWidget*)_obj)->setHorizontalHeaderLabels(qsListFromSep1_tw(items_sep1));
}

void qteQTableWidget_setVerticalHeaderLabels(void* _obj, void* items_sep1) {
    ((QTableWidget*)_obj)->setVerticalHeaderLabels(qsListFromSep1_tw(items_sep1));
}

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQTableWidget_selectedItems(void* _obj) {
    QList<QTableWidgetItem*> list = ((QTableWidget*)_obj)->selectedItems();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}

} // extern "C"
