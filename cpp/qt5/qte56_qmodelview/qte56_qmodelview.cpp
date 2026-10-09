#ifndef QTE56_QMODELVIEW_BUILD
#define QTE56_QMODELVIEW_BUILD
#endif
#include "qte56_qmodelview.h"
#include "../qte56_qobject/qte56_lifecycle.h"

#include <QModelIndex>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QSortFilterProxyModel>
#include <QStringListModel>
#include <QString>
#include <QStringList>
#include <QFont>
#include <QIcon>
#include <QBrush>
#include <QVariant>

// ─── QModelIndex ─────────────────────────────────────────────────────────────

extern "C" QMODELVIEW_API void* qteQModelIndex_create() {
    return new QModelIndex();
}

extern "C" QMODELVIEW_API void qteQModelIndex_delete(void* index) {
    delete (QModelIndex*)index;
}

extern "C" QMODELVIEW_API int qteQModelIndex_row(void* index) {
    return ((QModelIndex*)index)->row();
}

extern "C" QMODELVIEW_API int qteQModelIndex_column(void* index) {
    return ((QModelIndex*)index)->column();
}

extern "C" QMODELVIEW_API void* qteQModelIndex_parent(void* index) {
    return new QModelIndex(((QModelIndex*)index)->parent());
}

extern "C" QMODELVIEW_API void* qteQModelIndex_sibling(void* index, int row, int col) {
    return new QModelIndex(((QModelIndex*)index)->sibling(row, col));
}

extern "C" QMODELVIEW_API int qteQModelIndex_flags(void* index) {
    return (int)((QModelIndex*)index)->flags();
}

extern "C" QMODELVIEW_API long qteQModelIndex_internalId(void* index) {
    return (long)((QModelIndex*)index)->internalId();
}

extern "C" QMODELVIEW_API void* qteQModelIndex_internalPointer(void* index) {
    return ((QModelIndex*)index)->internalPointer();
}

extern "C" QMODELVIEW_API void* qteQModelIndex_model(void* index) {
    return (void*)((QModelIndex*)index)->model();
}

extern "C" QMODELVIEW_API int qteQModelIndex_isValid(void* index) {
    return ((QModelIndex*)index)->isValid() ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQModelIndex_data_i(void* index, int role) {
    return ((QModelIndex*)index)->data(role).toInt();
}

extern "C" QMODELVIEW_API void* qteQModelIndex_data_s(void* index, int role) {
    return new QString(((QModelIndex*)index)->data(role).toString());
}

extern "C" QMODELVIEW_API int qteQModelIndex_equals(void* index, void* other) {
    return (*(QModelIndex*)index == *(QModelIndex*)other) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQModelIndex_notEquals(void* index, void* other) {
    return (*(QModelIndex*)index != *(QModelIndex*)other) ? 1 : 0;
}

// ─── QStandardItem ───────────────────────────────────────────────────────────

extern "C" QMODELVIEW_API void* qteQStandardItem_create() {
    return new QStandardItem();
}

extern "C" QMODELVIEW_API void* qteQStandardItem_create_text(void* text) {
    return new QStandardItem(*(QString*)text);
}

extern "C" QMODELVIEW_API void qteQStandardItem_delete(void* item) {
    delete (QStandardItem*)item;
}

extern "C" QMODELVIEW_API void* qteQStandardItem_text(void* item) {
    return new QString(((QStandardItem*)item)->text());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setText(void* item, void* text) {
    ((QStandardItem*)item)->setText(*(QString*)text);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_icon(void* item) {
    return new QIcon(((QStandardItem*)item)->icon());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setIcon(void* item, void* icon) {
    ((QStandardItem*)item)->setIcon(*(QIcon*)icon);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_toolTip(void* item) {
    return new QString(((QStandardItem*)item)->toolTip());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setToolTip(void* item, void* text) {
    ((QStandardItem*)item)->setToolTip(*(QString*)text);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_statusTip(void* item) {
    return new QString(((QStandardItem*)item)->statusTip());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setStatusTip(void* item, void* text) {
    ((QStandardItem*)item)->setStatusTip(*(QString*)text);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_whatsThis(void* item) {
    return new QString(((QStandardItem*)item)->whatsThis());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setWhatsThis(void* item, void* text) {
    ((QStandardItem*)item)->setWhatsThis(*(QString*)text);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_font(void* item) {
    return new QFont(((QStandardItem*)item)->font());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setFont(void* item, void* font) {
    ((QStandardItem*)item)->setFont(*(QFont*)font);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_background(void* item) {
    return new QBrush(((QStandardItem*)item)->background());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setBackground(void* item, void* brush) {
    ((QStandardItem*)item)->setBackground(*(QBrush*)brush);
}

extern "C" QMODELVIEW_API void* qteQStandardItem_foreground(void* item) {
    return new QBrush(((QStandardItem*)item)->foreground());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setForeground(void* item, void* brush) {
    ((QStandardItem*)item)->setForeground(*(QBrush*)brush);
}

extern "C" QMODELVIEW_API int qteQStandardItem_checkState(void* item) {
    return (int)((QStandardItem*)item)->checkState();
}

extern "C" QMODELVIEW_API void qteQStandardItem_setCheckState(void* item, int state) {
    ((QStandardItem*)item)->setCheckState((Qt::CheckState)state);
}

extern "C" QMODELVIEW_API int qteQStandardItem_isCheckable(void* item) {
    return ((QStandardItem*)item)->isCheckable() ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStandardItem_setCheckable(void* item, int checkable) {
    ((QStandardItem*)item)->setCheckable(checkable != 0);
}

extern "C" QMODELVIEW_API int qteQStandardItem_isEditable(void* item) {
    return ((QStandardItem*)item)->isEditable() ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStandardItem_setEditable(void* item, int editable) {
    ((QStandardItem*)item)->setEditable(editable != 0);
}

extern "C" QMODELVIEW_API int qteQStandardItem_isSelectable(void* item) {
    return ((QStandardItem*)item)->isSelectable() ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStandardItem_setSelectable(void* item, int selectable) {
    ((QStandardItem*)item)->setSelectable(selectable != 0);
}

extern "C" QMODELVIEW_API int qteQStandardItem_isEnabled(void* item) {
    return ((QStandardItem*)item)->isEnabled() ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStandardItem_setEnabled(void* item, int enabled) {
    ((QStandardItem*)item)->setEnabled(enabled != 0);
}

extern "C" QMODELVIEW_API int qteQStandardItem_data_i(void* item, int role) {
    return ((QStandardItem*)item)->data(role).toInt();
}

extern "C" QMODELVIEW_API void* qteQStandardItem_data_s(void* item, int role) {
    return new QString(((QStandardItem*)item)->data(role).toString());
}

extern "C" QMODELVIEW_API void qteQStandardItem_setData_i(void* item, int role, int value) {
    ((QStandardItem*)item)->setData(QVariant(value), role);
}

extern "C" QMODELVIEW_API void qteQStandardItem_setData_s(void* item, int role, void* qs) {
    ((QStandardItem*)item)->setData(QVariant(*(QString*)qs), role);
}

extern "C" QMODELVIEW_API int qteQStandardItem_row(void* item) {
    return ((QStandardItem*)item)->row();
}

extern "C" QMODELVIEW_API int qteQStandardItem_column(void* item) {
    return ((QStandardItem*)item)->column();
}

extern "C" QMODELVIEW_API void* qteQStandardItem_parent(void* item) {
    return (void*)((QStandardItem*)item)->parent();
}

extern "C" QMODELVIEW_API void* qteQStandardItem_child(void* item, int row, int col) {
    return (void*)((QStandardItem*)item)->child(row, col);
}

extern "C" QMODELVIEW_API void qteQStandardItem_setChild(void* item, int row, int col, void* child) {
    ((QStandardItem*)item)->setChild(row, col, (QStandardItem*)child);
}

extern "C" QMODELVIEW_API void qteQStandardItem_removeRow(void* item, int row) {
    ((QStandardItem*)item)->removeRow(row);
}

extern "C" QMODELVIEW_API void qteQStandardItem_removeRows(void* item, int row, int count) {
    ((QStandardItem*)item)->removeRows(row, count);
}

extern "C" QMODELVIEW_API void qteQStandardItem_removeColumn(void* item, int col) {
    ((QStandardItem*)item)->removeColumn(col);
}

extern "C" QMODELVIEW_API void qteQStandardItem_removeColumns(void* item, int col, int count) {
    ((QStandardItem*)item)->removeColumns(col, count);
}

extern "C" QMODELVIEW_API void qteQStandardItem_appendRow(void* item, void* child) {
    ((QStandardItem*)item)->appendRow((QStandardItem*)child);
}

extern "C" QMODELVIEW_API void qteQStandardItem_appendColumn(void* item, void* child) {
    QList<QStandardItem*> list; list << (QStandardItem*)child;
    ((QStandardItem*)item)->appendColumn(list);
}

extern "C" QMODELVIEW_API void qteQStandardItem_insertRow(void* item, int row, void* child) {
    ((QStandardItem*)item)->insertRow(row, (QStandardItem*)child);
}

extern "C" QMODELVIEW_API void qteQStandardItem_insertColumn(void* item, int col, void* child) {
    QList<QStandardItem*> list; list << (QStandardItem*)child;
    ((QStandardItem*)item)->insertColumn(col, list);
}

extern "C" QMODELVIEW_API int qteQStandardItem_rowCount(void* item) {
    return ((QStandardItem*)item)->rowCount();
}

extern "C" QMODELVIEW_API int qteQStandardItem_columnCount(void* item) {
    return ((QStandardItem*)item)->columnCount();
}

extern "C" QMODELVIEW_API int qteQStandardItem_hasChildren(void* item) {
    return ((QStandardItem*)item)->hasChildren() ? 1 : 0;
}

extern "C" QMODELVIEW_API void* qteQStandardItem_index(void* item) {
    return new QModelIndex(((QStandardItem*)item)->index());
}

extern "C" QMODELVIEW_API void* qteQStandardItem_model(void* item) {
    return (void*)((QStandardItem*)item)->model();
}

extern "C" QMODELVIEW_API void* qteQStandardItem_clone(void* item) {
    return ((QStandardItem*)item)->clone();
}

extern "C" QMODELVIEW_API int qteQStandardItem_type(void* item) {
    return ((QStandardItem*)item)->type();
}

// ─── QStandardItemModel ──────────────────────────────────────────────────────

extern "C" QMODELVIEW_API void* qteQStandardItemModel_create(void* parent) {
    return qte_createTracked(new QStandardItemModel((QObject*)parent));
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_create_rc(int rows, int cols, void* parent) {
    return qte_createTracked(new QStandardItemModel(rows, cols, (QObject*)parent));
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_delete(void* model) {
    delete (QStandardItemModel*)model;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_rowCount(void* model, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->rowCount(p);
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_columnCount(void* model, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->columnCount(p);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_index(void* model, int row, int col, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return new QModelIndex(((QStandardItemModel*)model)->index(row, col, p));
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_parent(void* model, void* index) {
    return new QModelIndex(((QStandardItemModel*)model)->parent(*(QModelIndex*)index));
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_data_i(void* model, void* index, int role) {
    return ((QStandardItemModel*)model)->data(*(QModelIndex*)index, role).toInt();
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_data_s(void* model, void* index, int role) {
    return new QString(((QStandardItemModel*)model)->data(*(QModelIndex*)index, role).toString());
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_setData_i(void* model, void* index, int value, int role) {
    return ((QStandardItemModel*)model)->setData(*(QModelIndex*)index, QVariant(value), role) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_setData_s(void* model, void* index, void* qs, int role) {
    return ((QStandardItemModel*)model)->setData(*(QModelIndex*)index, QVariant(*(QString*)qs), role) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_flags(void* model, void* index) {
    return (int)((QStandardItemModel*)model)->flags(*(QModelIndex*)index);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_item(void* model, int row, int col) {
    return (void*)((QStandardItemModel*)model)->item(row, col);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setItem(void* model, int row, int col, void* item) {
    ((QStandardItemModel*)model)->setItem(row, col, (QStandardItem*)item);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_itemFromIndex(void* model, void* index) {
    return (void*)((QStandardItemModel*)model)->itemFromIndex(*(QModelIndex*)index);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_indexFromItem(void* model, void* item) {
    return new QModelIndex(((QStandardItemModel*)model)->indexFromItem((QStandardItem*)item));
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_invisibleRootItem(void* model) {
    return (void*)((QStandardItemModel*)model)->invisibleRootItem();
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_appendRow(void* model, void* item) {
    ((QStandardItemModel*)model)->appendRow((QStandardItem*)item);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_appendColumn(void* model, void* item) {
    QList<QStandardItem*> list; list << (QStandardItem*)item;
    ((QStandardItemModel*)model)->appendColumn(list);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_insertRow(void* model, int row, void* item) {
    ((QStandardItemModel*)model)->insertRow(row, (QStandardItem*)item);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_insertColumn(void* model, int col, void* item) {
    QList<QStandardItem*> list; list << (QStandardItem*)item;
    ((QStandardItemModel*)model)->insertColumn(col, list);
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_removeRow(void* model, int row, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->removeRow(row, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_removeRows(void* model, int row, int count, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->removeRows(row, count, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_removeColumn(void* model, int col, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->removeColumn(col, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStandardItemModel_removeColumns(void* model, int col, int count, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStandardItemModel*)model)->removeColumns(col, count, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_clear(void* model) {
    ((QStandardItemModel*)model)->clear();
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setHorizontalHeaderLabels(void* model, void* labels_sep1) {
    QStringList list;
    if (labels_sep1) {
        const QString& s = *(const QString*)labels_sep1;
        if (!s.isEmpty()) list = s.split(QChar(1));
    }
    ((QStandardItemModel*)model)->setHorizontalHeaderLabels(list);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setVerticalHeaderLabels(void* model, void* labels_sep1) {
    QStringList list;
    if (labels_sep1) {
        const QString& s = *(const QString*)labels_sep1;
        if (!s.isEmpty()) list = s.split(QChar(1));
    }
    ((QStandardItemModel*)model)->setVerticalHeaderLabels(list);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_horizontalHeaderItem(void* model, int col) {
    return (void*)((QStandardItemModel*)model)->horizontalHeaderItem(col);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setHorizontalHeaderItem(void* model, int col, void* item) {
    ((QStandardItemModel*)model)->setHorizontalHeaderItem(col, (QStandardItem*)item);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_verticalHeaderItem(void* model, int row) {
    return (void*)((QStandardItemModel*)model)->verticalHeaderItem(row);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setVerticalHeaderItem(void* model, int row, void* item) {
    ((QStandardItemModel*)model)->setVerticalHeaderItem(row, (QStandardItem*)item);
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_sort(void* model, int col, int order) {
    ((QStandardItemModel*)model)->sort(col, (Qt::SortOrder)order);
}

extern "C" QMODELVIEW_API void* qteQStandardItemModel_itemPrototype(void* model) {
    return (void*)((QStandardItemModel*)model)->itemPrototype();
}

extern "C" QMODELVIEW_API void qteQStandardItemModel_setItemPrototype(void* model, void* item) {
    ((QStandardItemModel*)model)->setItemPrototype((const QStandardItem*)item);
}

// ─── QSortFilterProxyModel ───────────────────────────────────────────────────

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_create(void* parent) {
    return qte_createTracked(new QSortFilterProxyModel((QObject*)parent));
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_delete(void* model) {
    delete (QSortFilterProxyModel*)model;
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setSourceModel(void* model, void* source) {
    ((QSortFilterProxyModel*)model)->setSourceModel((QAbstractItemModel*)source);
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_sourceModel(void* model) {
    return (void*)((QSortFilterProxyModel*)model)->sourceModel();
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_mapToSource(void* model, void* index) {
    return new QModelIndex(((QSortFilterProxyModel*)model)->mapToSource(*(QModelIndex*)index));
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_mapFromSource(void* model, void* index) {
    return new QModelIndex(((QSortFilterProxyModel*)model)->mapFromSource(*(QModelIndex*)index));
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterFixedString(void* model, void* pattern) {
    ((QSortFilterProxyModel*)model)->setFilterFixedString(*(QString*)pattern);
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterWildcard(void* model, void* pattern) {
    ((QSortFilterProxyModel*)model)->setFilterWildcard(*(QString*)pattern);
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterRegExp(void* model, void* pattern) {
    ((QSortFilterProxyModel*)model)->setFilterRegExp(*(QString*)pattern);
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_filterRegExp(void* model) {
    return new QString(((QSortFilterProxyModel*)model)->filterRegExp().pattern());
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterCaseSensitivity(void* model, int cs) {
    ((QSortFilterProxyModel*)model)->setFilterCaseSensitivity((Qt::CaseSensitivity)cs);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_filterCaseSensitivity(void* model) {
    return (int)((QSortFilterProxyModel*)model)->filterCaseSensitivity();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setSortCaseSensitivity(void* model, int cs) {
    ((QSortFilterProxyModel*)model)->setSortCaseSensitivity((Qt::CaseSensitivity)cs);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_sortCaseSensitivity(void* model) {
    return (int)((QSortFilterProxyModel*)model)->sortCaseSensitivity();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterRole(void* model, int role) {
    ((QSortFilterProxyModel*)model)->setFilterRole(role);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_filterRole(void* model) {
    return ((QSortFilterProxyModel*)model)->filterRole();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setSortRole(void* model, int role) {
    ((QSortFilterProxyModel*)model)->setSortRole(role);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_sortRole(void* model) {
    return ((QSortFilterProxyModel*)model)->sortRole();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setDynamicSortFilter(void* model, int enable) {
    ((QSortFilterProxyModel*)model)->setDynamicSortFilter(enable != 0);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_dynamicSortFilter(void* model) {
    return ((QSortFilterProxyModel*)model)->dynamicSortFilter() ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_setFilterKeyColumn(void* model, int col) {
    ((QSortFilterProxyModel*)model)->setFilterKeyColumn(col);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_filterKeyColumn(void* model) {
    return ((QSortFilterProxyModel*)model)->filterKeyColumn();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_invalidate(void* model) {
    ((QSortFilterProxyModel*)model)->invalidate();
}

extern "C" QMODELVIEW_API void qteQSortFilterProxyModel_sort(void* model, int col, int order) {
    ((QSortFilterProxyModel*)model)->sort(col, (Qt::SortOrder)order);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_rowCount(void* model, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QSortFilterProxyModel*)model)->rowCount(p);
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_columnCount(void* model, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QSortFilterProxyModel*)model)->columnCount(p);
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_index(void* model, int row, int col, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return new QModelIndex(((QSortFilterProxyModel*)model)->index(row, col, p));
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_parent(void* model, void* index) {
    return new QModelIndex(((QSortFilterProxyModel*)model)->parent(*(QModelIndex*)index));
}

extern "C" QMODELVIEW_API void* qteQSortFilterProxyModel_data_s(void* model, void* index, int role) {
    return new QString(((QSortFilterProxyModel*)model)->data(*(QModelIndex*)index, role).toString());
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_data_i(void* model, void* index, int role) {
    return ((QSortFilterProxyModel*)model)->data(*(QModelIndex*)index, role).toInt();
}

extern "C" QMODELVIEW_API int qteQSortFilterProxyModel_flags(void* model, void* index) {
    return (int)((QSortFilterProxyModel*)model)->flags(*(QModelIndex*)index);
}

// ─── QStringListModel ────────────────────────────────────────────────────────

extern "C" QMODELVIEW_API void* qteQStringListModel_create(void* parent) {
    return qte_createTracked(new QStringListModel((QObject*)parent));
}

extern "C" QMODELVIEW_API void* qteQStringListModel_create_sl(void* strings_sep1, void* parent) {
    QStringList list;
    if (strings_sep1) {
        const QString& s = *(const QString*)strings_sep1;
        if (!s.isEmpty()) list = s.split(QChar(1));
    }
    return qte_createTracked(new QStringListModel(list, (QObject*)parent));
}

extern "C" QMODELVIEW_API void qteQStringListModel_delete(void* model) {
    delete (QStringListModel*)model;
}

extern "C" QMODELVIEW_API int qteQStringListModel_rowCount(void* model, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStringListModel*)model)->rowCount(p);
}

extern "C" QMODELVIEW_API void* qteQStringListModel_index(void* model, int row, int col, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return new QModelIndex(((QStringListModel*)model)->index(row, col, p));
}

extern "C" QMODELVIEW_API void* qteQStringListModel_data_s(void* model, void* index, int role) {
    return new QString(((QStringListModel*)model)->data(*(QModelIndex*)index, role).toString());
}

extern "C" QMODELVIEW_API int qteQStringListModel_data_i(void* model, void* index, int role) {
    return ((QStringListModel*)model)->data(*(QModelIndex*)index, role).toInt();
}

extern "C" QMODELVIEW_API int qteQStringListModel_setData_s(void* model, void* index, void* qs, int role) {
    return ((QStringListModel*)model)->setData(*(QModelIndex*)index, QVariant(*(QString*)qs), role) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStringListModel_flags(void* model, void* index) {
    return (int)((QStringListModel*)model)->flags(*(QModelIndex*)index);
}

extern "C" QMODELVIEW_API void qteQStringListModel_setStringList(void* model, void* strings_sep1) {
    QStringList list;
    if (strings_sep1) {
        const QString& s = *(const QString*)strings_sep1;
        if (!s.isEmpty()) list = s.split(QChar(1));
    }
    ((QStringListModel*)model)->setStringList(list);
}

extern "C" QMODELVIEW_API void* qteQStringListModel_stringList(void* model) {
    QStringList list = ((QStringListModel*)model)->stringList();
    return new QString(list.join(QChar(1)));
}

extern "C" QMODELVIEW_API int qteQStringListModel_removeRows(void* model, int row, int count, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStringListModel*)model)->removeRows(row, count, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API int qteQStringListModel_insertRows(void* model, int row, int count, void* parent) {
    QModelIndex p = parent ? *(QModelIndex*)parent : QModelIndex();
    return ((QStringListModel*)model)->insertRows(row, count, p) ? 1 : 0;
}

extern "C" QMODELVIEW_API void qteQStringListModel_sort(void* model, int col, int order) {
    ((QStringListModel*)model)->sort(col, (Qt::SortOrder)order);
}
