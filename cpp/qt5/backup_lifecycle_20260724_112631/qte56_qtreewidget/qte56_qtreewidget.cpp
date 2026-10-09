#ifndef QTE56_QTREEWIDGET_BUILD
#define QTE56_QTREEWIDGET_BUILD
#endif
#include "qte56_qtreewidget.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTreeWidget>
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
class eQTreeWidget : public QTreeWidget {
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

    explicit eQTreeWidget(QWidget* parent = nullptr) : QTreeWidget(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QTreeWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QTreeWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QTreeWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QTreeWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QTreeWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QTreeWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QTreeWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QTreeWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QTreeWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QTreeWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QTreeWidget::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QTreeWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QTreeWidget::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QTreeWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QTreeWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QTreeWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QTreeWidget::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTreeWidget_create(void* parent) {
    return qte_createTracked(new eQTreeWidget((QWidget*)parent);
}

void qteQTreeWidget_delete(void* w) {
    delete (eQTreeWidget*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQTreeWidget_columnCount(void* _obj) {
    return ((QTreeWidget*)_obj)->columnCount();
}

void qteQTreeWidget_setColumnCount(void* _obj, int columns) {
    ((QTreeWidget*)_obj)->setColumnCount(columns);
}

void* qteQTreeWidget_invisibleRootItem(void* _obj) {
    return (void*)((QTreeWidget*)_obj)->invisibleRootItem();
}

void* qteQTreeWidget_topLevelItem(void* _obj, int index) {
    return (void*)((QTreeWidget*)_obj)->topLevelItem(index);
}

int qteQTreeWidget_topLevelItemCount(void* _obj) {
    return ((QTreeWidget*)_obj)->topLevelItemCount();
}

void qteQTreeWidget_insertTopLevelItem(void* _obj, int index, void* item) {
    ((QTreeWidget*)_obj)->insertTopLevelItem(index, (QTreeWidgetItem*)item);
}

void qteQTreeWidget_addTopLevelItem(void* _obj, void* item) {
    ((QTreeWidget*)_obj)->addTopLevelItem((QTreeWidgetItem*)item);
}

void* qteQTreeWidget_takeTopLevelItem(void* _obj, int index) {
    return (void*)((QTreeWidget*)_obj)->takeTopLevelItem(index);
}

int qteQTreeWidget_indexOfTopLevelItem(void* _obj, void* item) {
    return ((QTreeWidget*)_obj)->indexOfTopLevelItem((QTreeWidgetItem*)item);
}

void* qteQTreeWidget_headerItem(void* _obj) {
    return (void*)((QTreeWidget*)_obj)->headerItem();
}

void qteQTreeWidget_setHeaderItem(void* _obj, void* item) {
    ((QTreeWidget*)_obj)->setHeaderItem((QTreeWidgetItem*)item);
}

void qteQTreeWidget_setHeaderLabel(void* _obj, void* label) {
    ((QTreeWidget*)_obj)->setHeaderLabel(*(QString*)label);
}

void* qteQTreeWidget_currentItem(void* _obj) {
    return (void*)((QTreeWidget*)_obj)->currentItem();
}

int qteQTreeWidget_currentColumn(void* _obj) {
    return ((QTreeWidget*)_obj)->currentColumn();
}

void qteQTreeWidget_setCurrentItem_p(void* _obj, void* item) {
    ((QTreeWidget*)_obj)->setCurrentItem((QTreeWidgetItem*)item);
}

void qteQTreeWidget_setCurrentItem_pi(void* _obj, void* item, int column) {
    ((QTreeWidget*)_obj)->setCurrentItem((QTreeWidgetItem*)item, column);
}

void qteQTreeWidget_setCurrentItem_pip(void* _obj, void* item, int column, int command) {
    ((QTreeWidget*)_obj)->setCurrentItem((QTreeWidgetItem*)item, column, (QItemSelectionModel::SelectionFlags)command);
}

void* qteQTreeWidget_itemAt_p(void* _obj, void* p) {
    return (void*)((QTreeWidget*)_obj)->itemAt(*(const QPoint*)p);
}

void* qteQTreeWidget_itemAt_ii(void* _obj, int x, int y) {
    return (void*)((QTreeWidget*)_obj)->itemAt(x, y);
}

void* qteQTreeWidget_visualItemRect(void* _obj, void* item) {
    return new QRect(((QTreeWidget*)_obj)->visualItemRect((const QTreeWidgetItem*)item));
}

int qteQTreeWidget_sortColumn(void* _obj) {
    return ((QTreeWidget*)_obj)->sortColumn();
}

void qteQTreeWidget_sortItems(void* _obj, int column, int order) {
    ((QTreeWidget*)_obj)->sortItems(column, (Qt::SortOrder)order);
}

void qteQTreeWidget_editItem(void* _obj, void* item, int column) {
    ((QTreeWidget*)_obj)->editItem((QTreeWidgetItem*)item, column);
}

void qteQTreeWidget_openPersistentEditor(void* _obj, void* item, int column) {
    ((QTreeWidget*)_obj)->openPersistentEditor((QTreeWidgetItem*)item, column);
}

void qteQTreeWidget_closePersistentEditor(void* _obj, void* item, int column) {
    ((QTreeWidget*)_obj)->closePersistentEditor((QTreeWidgetItem*)item, column);
}

int qteQTreeWidget_isPersistentEditorOpen(void* _obj, void* item, int column) {
    return ((QTreeWidget*)_obj)->isPersistentEditorOpen((QTreeWidgetItem*)item, column) ? 1 : 0;
}

void* qteQTreeWidget_itemWidget(void* _obj, void* item, int column) {
    return (void*)((QTreeWidget*)_obj)->itemWidget((QTreeWidgetItem*)item, column);
}

void qteQTreeWidget_setItemWidget(void* _obj, void* item, int column, void* widget) {
    ((QTreeWidget*)_obj)->setItemWidget((QTreeWidgetItem*)item, column, (QWidget*)widget);
}

void qteQTreeWidget_removeItemWidget(void* _obj, void* item, int column) {
    ((QTreeWidget*)_obj)->removeItemWidget((QTreeWidgetItem*)item, column);
}

int qteQTreeWidget_isItemSelected(void* _obj, void* item) {
    return ((QTreeWidget*)_obj)->isItemSelected((const QTreeWidgetItem*)item) ? 1 : 0;
}

void qteQTreeWidget_setItemSelected(void* _obj, void* item, int select) {
    ((QTreeWidget*)_obj)->setItemSelected((const QTreeWidgetItem*)item, (select != 0));
}

int qteQTreeWidget_isItemHidden(void* _obj, void* item) {
    return ((QTreeWidget*)_obj)->isItemHidden((const QTreeWidgetItem*)item) ? 1 : 0;
}

void qteQTreeWidget_setItemHidden(void* _obj, void* item, int hide) {
    ((QTreeWidget*)_obj)->setItemHidden((const QTreeWidgetItem*)item, (hide != 0));
}

int qteQTreeWidget_isItemExpanded(void* _obj, void* item) {
    return ((QTreeWidget*)_obj)->isItemExpanded((const QTreeWidgetItem*)item) ? 1 : 0;
}

void qteQTreeWidget_setItemExpanded(void* _obj, void* item, int expand) {
    ((QTreeWidget*)_obj)->setItemExpanded((const QTreeWidgetItem*)item, (expand != 0));
}

int qteQTreeWidget_isFirstItemColumnSpanned(void* _obj, void* item) {
    return ((QTreeWidget*)_obj)->isFirstItemColumnSpanned((const QTreeWidgetItem*)item) ? 1 : 0;
}

void qteQTreeWidget_setFirstItemColumnSpanned(void* _obj, void* item, int span) {
    ((QTreeWidget*)_obj)->setFirstItemColumnSpanned((const QTreeWidgetItem*)item, (span != 0));
}

void* qteQTreeWidget_itemAbove(void* _obj, void* item) {
    return (void*)((QTreeWidget*)_obj)->itemAbove((const QTreeWidgetItem*)item);
}

void* qteQTreeWidget_itemBelow(void* _obj, void* item) {
    return (void*)((QTreeWidget*)_obj)->itemBelow((const QTreeWidgetItem*)item);
}

void qteQTreeWidget_scrollToItem(void* _obj, void* item, int hint) {
    ((QTreeWidget*)_obj)->scrollToItem((const QTreeWidgetItem*)item, (QAbstractItemView::ScrollHint)hint);
}

void qteQTreeWidget_expandItem(void* _obj, void* item) {
    ((QTreeWidget*)_obj)->expandItem((const QTreeWidgetItem*)item);
}

void qteQTreeWidget_collapseItem(void* _obj, void* item) {
    ((QTreeWidget*)_obj)->collapseItem((const QTreeWidgetItem*)item);
}

void qteQTreeWidget_clear(void* _obj) {
    ((QTreeWidget*)_obj)->clear();
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQTreeWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQTreeWidget* obj = (eQTreeWidget*)w;
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

// ── Signal slots ─────────────────────────────────────────────────────────────
// All signals use direct C callbacks stored in a small helper object.

void qteQTreeWidget_connectItemClicked(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemClicked,
        [cb, dthis](QTreeWidgetItem* item, int col) {
            typedef void(*Fn)(void*, int, void*, int);
            ((Fn)cb)(dthis, 0, (void*)item, col);
        });
}
void qteQTreeWidget_connectItemDoubleClicked(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemDoubleClicked,
        [cb, dthis](QTreeWidgetItem* item, int col) {
            typedef void(*Fn)(void*, int, void*, int);
            ((Fn)cb)(dthis, 0, (void*)item, col);
        });
}
void qteQTreeWidget_connectItemChanged(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemChanged,
        [cb, dthis](QTreeWidgetItem* item, int col) {
            typedef void(*Fn)(void*, int, void*, int);
            ((Fn)cb)(dthis, 0, (void*)item, col);
        });
}
void qteQTreeWidget_connectItemActivated(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemActivated,
        [cb, dthis](QTreeWidgetItem* item, int col) {
            typedef void(*Fn)(void*, int, void*, int);
            ((Fn)cb)(dthis, 0, (void*)item, col);
        });
}
void qteQTreeWidget_connectItemExpanded(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemExpanded,
        [cb, dthis](QTreeWidgetItem* item) {
            typedef void(*Fn)(void*, int, void*);
            ((Fn)cb)(dthis, 0, (void*)item);
        });
}
void qteQTreeWidget_connectItemCollapsed(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemCollapsed,
        [cb, dthis](QTreeWidgetItem* item) {
            typedef void(*Fn)(void*, int, void*);
            ((Fn)cb)(dthis, 0, (void*)item);
        });
}
void qteQTreeWidget_connectCurrentItemChanged(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::currentItemChanged,
        [cb, dthis](QTreeWidgetItem* cur, QTreeWidgetItem* prev) {
            typedef void(*Fn)(void*, int, void*, void*);
            ((Fn)cb)(dthis, 0, (void*)cur, (void*)prev);
        });
}
void qteQTreeWidget_connectItemSelectionChanged(void* w, void* cb, void* dthis) {
    auto* tw = (QTreeWidget*)w;
    QObject::connect(tw, &QTreeWidget::itemSelectionChanged,
        [cb, dthis]() {
            typedef void(*Fn)(void*, int);
            ((Fn)cb)(dthis, 0);
        });
}

// ── QTreeWidgetItem helpers ───────────────────────────────────────────────────
void* qteQTreeWidgetItem_create() {
    return new QTreeWidgetItem();
}
void* qteQTreeWidgetItem_create_text(void* text) {
    return new QTreeWidgetItem(QStringList() << *(QString*)text);
}
void qteQTreeWidgetItem_delete(void* item) {
    delete (QTreeWidgetItem*)item;
}
void* qteQTreeWidgetItem_text(void* item, int column) {
    return new QString(((QTreeWidgetItem*)item)->text(column));
}
void qteQTreeWidgetItem_setText(void* item, int column, void* text) {
    ((QTreeWidgetItem*)item)->setText(column, *(QString*)text);
}
int qteQTreeWidgetItem_flags(void* item) {
    return (int)((QTreeWidgetItem*)item)->flags();
}
void qteQTreeWidgetItem_setFlags(void* item, int flags) {
    ((QTreeWidgetItem*)item)->setFlags((Qt::ItemFlags)flags);
}
int qteQTreeWidgetItem_isExpanded(void* item) {
    return ((QTreeWidgetItem*)item)->isExpanded() ? 1 : 0;
}
void qteQTreeWidgetItem_setExpanded(void* item, int expand) {
    ((QTreeWidgetItem*)item)->setExpanded(expand != 0);
}
int qteQTreeWidgetItem_isSelected(void* item) {
    return ((QTreeWidgetItem*)item)->isSelected() ? 1 : 0;
}
void qteQTreeWidgetItem_setSelected(void* item, int sel) {
    ((QTreeWidgetItem*)item)->setSelected(sel != 0);
}
int qteQTreeWidgetItem_isHidden(void* item) {
    return ((QTreeWidgetItem*)item)->isHidden() ? 1 : 0;
}
void qteQTreeWidgetItem_setHidden(void* item, int hide) {
    ((QTreeWidgetItem*)item)->setHidden(hide != 0);
}
void* qteQTreeWidgetItem_parent(void* item) {
    return (void*)((QTreeWidgetItem*)item)->parent();
}
int qteQTreeWidgetItem_childCount(void* item) {
    return ((QTreeWidgetItem*)item)->childCount();
}
void* qteQTreeWidgetItem_child(void* item, int index) {
    return (void*)((QTreeWidgetItem*)item)->child(index);
}
void qteQTreeWidgetItem_addChild(void* item, void* child) {
    ((QTreeWidgetItem*)item)->addChild((QTreeWidgetItem*)child);
}
void qteQTreeWidgetItem_insertChild(void* item, int index, void* child) {
    ((QTreeWidgetItem*)item)->insertChild(index, (QTreeWidgetItem*)child);
}
void* qteQTreeWidgetItem_takeChild(void* item, int index) {
    return (void*)((QTreeWidgetItem*)item)->takeChild(index);
}
void qteQTreeWidgetItem_removeChild(void* item, void* child) {
    ((QTreeWidgetItem*)item)->removeChild((QTreeWidgetItem*)child);
}
int qteQTreeWidgetItem_indexOfChild(void* item, void* child) {
    return ((QTreeWidgetItem*)item)->indexOfChild((QTreeWidgetItem*)child);
}
int qteQTreeWidgetItem_checkState(void* item, int column) {
    return (int)((QTreeWidgetItem*)item)->checkState(column);
}
void qteQTreeWidgetItem_setCheckState(void* item, int column, int state) {
    ((QTreeWidgetItem*)item)->setCheckState(column, (Qt::CheckState)state);
}

// ── QStringList helpers (sep=\x01) ───────────────────────────────────────────

static QStringList qsListFromSep1_tw(void* qs) {
    if (!qs) return QStringList();
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1));
}

void qteQTreeWidget_setHeaderLabels(void* _obj, void* items_sep1) {
    ((QTreeWidget*)_obj)->setHeaderLabels(qsListFromSep1_tw(items_sep1));
}

// ── List queries ──────────────────────────────────────────────────────────────
void* qteQTreeWidget_selectedItems(void* _obj) {
    QList<QTreeWidgetItem*> list = ((QTreeWidget*)_obj)->selectedItems();
    QString result;
    for (int i = 0; i < list.size(); i++) {
        if (i > 0) result += '|';
        result += QString::number((uintptr_t)list[i], 16);
    }
    return new QString(result);
}

} // extern "C"
