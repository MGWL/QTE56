#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMODELVIEW_BUILD
    #define QMODELVIEW_API __declspec(dllexport)
  #else
    #define QMODELVIEW_API __declspec(dllimport)
  #endif
#else
  #define QMODELVIEW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QModelIndex (24200–24249) ────────────────────────────────────────────────
QMODELVIEW_API void* qteQModelIndex_create();
QMODELVIEW_API void  qteQModelIndex_delete(void* index);
QMODELVIEW_API int   qteQModelIndex_row(void* index);
QMODELVIEW_API int   qteQModelIndex_column(void* index);
QMODELVIEW_API void* qteQModelIndex_parent(void* index);
QMODELVIEW_API void* qteQModelIndex_sibling(void* index, int row, int col);
QMODELVIEW_API int   qteQModelIndex_flags(void* index);
QMODELVIEW_API long  qteQModelIndex_internalId(void* index);
QMODELVIEW_API void* qteQModelIndex_internalPointer(void* index);
QMODELVIEW_API void* qteQModelIndex_model(void* index);
QMODELVIEW_API int   qteQModelIndex_isValid(void* index);
QMODELVIEW_API int   qteQModelIndex_data_i(void* index, int role);
QMODELVIEW_API void* qteQModelIndex_data_s(void* index, int role);
QMODELVIEW_API int   qteQModelIndex_equals(void* index, void* other);
QMODELVIEW_API int   qteQModelIndex_notEquals(void* index, void* other);

// ── QStandardItem (24250–24399) ──────────────────────────────────────────────
QMODELVIEW_API void* qteQStandardItem_create();
QMODELVIEW_API void* qteQStandardItem_create_text(void* text);
QMODELVIEW_API void  qteQStandardItem_delete(void* item);
QMODELVIEW_API void* qteQStandardItem_text(void* item);
QMODELVIEW_API void  qteQStandardItem_setText(void* item, void* text);
QMODELVIEW_API void* qteQStandardItem_icon(void* item);
QMODELVIEW_API void  qteQStandardItem_setIcon(void* item, void* icon);
QMODELVIEW_API void* qteQStandardItem_toolTip(void* item);
QMODELVIEW_API void  qteQStandardItem_setToolTip(void* item, void* text);
QMODELVIEW_API void* qteQStandardItem_statusTip(void* item);
QMODELVIEW_API void  qteQStandardItem_setStatusTip(void* item, void* text);
QMODELVIEW_API void* qteQStandardItem_whatsThis(void* item);
QMODELVIEW_API void  qteQStandardItem_setWhatsThis(void* item, void* text);
QMODELVIEW_API void* qteQStandardItem_font(void* item);
QMODELVIEW_API void  qteQStandardItem_setFont(void* item, void* font);
QMODELVIEW_API void* qteQStandardItem_background(void* item);
QMODELVIEW_API void  qteQStandardItem_setBackground(void* item, void* brush);
QMODELVIEW_API void* qteQStandardItem_foreground(void* item);
QMODELVIEW_API void  qteQStandardItem_setForeground(void* item, void* brush);
QMODELVIEW_API int   qteQStandardItem_checkState(void* item);
QMODELVIEW_API void  qteQStandardItem_setCheckState(void* item, int state);
QMODELVIEW_API int   qteQStandardItem_isCheckable(void* item);
QMODELVIEW_API void  qteQStandardItem_setCheckable(void* item, int checkable);
QMODELVIEW_API int   qteQStandardItem_isEditable(void* item);
QMODELVIEW_API void  qteQStandardItem_setEditable(void* item, int editable);
QMODELVIEW_API int   qteQStandardItem_isSelectable(void* item);
QMODELVIEW_API void  qteQStandardItem_setSelectable(void* item, int selectable);
QMODELVIEW_API int   qteQStandardItem_isEnabled(void* item);
QMODELVIEW_API void  qteQStandardItem_setEnabled(void* item, int enabled);
QMODELVIEW_API int   qteQStandardItem_data_i(void* item, int role);
QMODELVIEW_API void* qteQStandardItem_data_s(void* item, int role);
QMODELVIEW_API void  qteQStandardItem_setData_i(void* item, int role, int value);
QMODELVIEW_API void  qteQStandardItem_setData_s(void* item, int role, void* qs);
QMODELVIEW_API int   qteQStandardItem_row(void* item);
QMODELVIEW_API int   qteQStandardItem_column(void* item);
QMODELVIEW_API void* qteQStandardItem_parent(void* item);
QMODELVIEW_API void* qteQStandardItem_child(void* item, int row, int col);
QMODELVIEW_API void  qteQStandardItem_setChild(void* item, int row, int col, void* child);
QMODELVIEW_API void  qteQStandardItem_removeRow(void* item, int row);
QMODELVIEW_API void  qteQStandardItem_removeRows(void* item, int row, int count);
QMODELVIEW_API void  qteQStandardItem_removeColumn(void* item, int col);
QMODELVIEW_API void  qteQStandardItem_removeColumns(void* item, int col, int count);
QMODELVIEW_API void  qteQStandardItem_appendRow(void* item, void* child);
QMODELVIEW_API void  qteQStandardItem_appendColumn(void* item, void* child);
QMODELVIEW_API void  qteQStandardItem_insertRow(void* item, int row, void* child);
QMODELVIEW_API void  qteQStandardItem_insertColumn(void* item, int col, void* child);
QMODELVIEW_API int   qteQStandardItem_rowCount(void* item);
QMODELVIEW_API int   qteQStandardItem_columnCount(void* item);
QMODELVIEW_API int   qteQStandardItem_hasChildren(void* item);
QMODELVIEW_API void* qteQStandardItem_index(void* item);
QMODELVIEW_API void* qteQStandardItem_model(void* item);
QMODELVIEW_API void* qteQStandardItem_clone(void* item);
QMODELVIEW_API int   qteQStandardItem_type(void* item);

// ── QStandardItemModel (24400–24599) ─────────────────────────────────────────
QMODELVIEW_API void* qteQStandardItemModel_create(void* parent);
QMODELVIEW_API void* qteQStandardItemModel_create_rc(int rows, int cols, void* parent);
QMODELVIEW_API void  qteQStandardItemModel_delete(void* model);
QMODELVIEW_API int   qteQStandardItemModel_rowCount(void* model, void* parent);
QMODELVIEW_API int   qteQStandardItemModel_columnCount(void* model, void* parent);
QMODELVIEW_API void* qteQStandardItemModel_index(void* model, int row, int col, void* parent);
QMODELVIEW_API void* qteQStandardItemModel_parent(void* model, void* index);
QMODELVIEW_API int   qteQStandardItemModel_data_i(void* model, void* index, int role);
QMODELVIEW_API void* qteQStandardItemModel_data_s(void* model, void* index, int role);
QMODELVIEW_API int   qteQStandardItemModel_setData_i(void* model, void* index, int value, int role);
QMODELVIEW_API int   qteQStandardItemModel_setData_s(void* model, void* index, void* qs, int role);
QMODELVIEW_API int   qteQStandardItemModel_flags(void* model, void* index);
QMODELVIEW_API void* qteQStandardItemModel_item(void* model, int row, int col);
QMODELVIEW_API void  qteQStandardItemModel_setItem(void* model, int row, int col, void* item);
QMODELVIEW_API void* qteQStandardItemModel_itemFromIndex(void* model, void* index);
QMODELVIEW_API void* qteQStandardItemModel_indexFromItem(void* model, void* item);
QMODELVIEW_API void* qteQStandardItemModel_invisibleRootItem(void* model);
QMODELVIEW_API void  qteQStandardItemModel_appendRow(void* model, void* item);
QMODELVIEW_API void  qteQStandardItemModel_appendColumn(void* model, void* item);
QMODELVIEW_API void  qteQStandardItemModel_insertRow(void* model, int row, void* item);
QMODELVIEW_API void  qteQStandardItemModel_insertColumn(void* model, int col, void* item);
QMODELVIEW_API int   qteQStandardItemModel_removeRow(void* model, int row, void* parent);
QMODELVIEW_API int   qteQStandardItemModel_removeRows(void* model, int row, int count, void* parent);
QMODELVIEW_API int   qteQStandardItemModel_removeColumn(void* model, int col, void* parent);
QMODELVIEW_API int   qteQStandardItemModel_removeColumns(void* model, int col, int count, void* parent);
QMODELVIEW_API void  qteQStandardItemModel_clear(void* model);
QMODELVIEW_API void  qteQStandardItemModel_setHorizontalHeaderLabels(void* model, void* labels_sep1);
QMODELVIEW_API void  qteQStandardItemModel_setVerticalHeaderLabels(void* model, void* labels_sep1);
QMODELVIEW_API void* qteQStandardItemModel_horizontalHeaderItem(void* model, int col);
QMODELVIEW_API void  qteQStandardItemModel_setHorizontalHeaderItem(void* model, int col, void* item);
QMODELVIEW_API void* qteQStandardItemModel_verticalHeaderItem(void* model, int row);
QMODELVIEW_API void  qteQStandardItemModel_setVerticalHeaderItem(void* model, int row, void* item);
QMODELVIEW_API void  qteQStandardItemModel_sort(void* model, int col, int order);
QMODELVIEW_API void* qteQStandardItemModel_itemPrototype(void* model);
QMODELVIEW_API void  qteQStandardItemModel_setItemPrototype(void* model, void* item);

// ── QSortFilterProxyModel (24600–24699) ──────────────────────────────────────
QMODELVIEW_API void* qteQSortFilterProxyModel_create(void* parent);
QMODELVIEW_API void  qteQSortFilterProxyModel_delete(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setSourceModel(void* model, void* source);
QMODELVIEW_API void* qteQSortFilterProxyModel_sourceModel(void* model);
QMODELVIEW_API void* qteQSortFilterProxyModel_mapToSource(void* model, void* index);
QMODELVIEW_API void* qteQSortFilterProxyModel_mapFromSource(void* model, void* index);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterFixedString(void* model, void* pattern);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterWildcard(void* model, void* pattern);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterRegExp(void* model, void* pattern);
QMODELVIEW_API void* qteQSortFilterProxyModel_filterRegExp(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterCaseSensitivity(void* model, int cs);
QMODELVIEW_API int   qteQSortFilterProxyModel_filterCaseSensitivity(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setSortCaseSensitivity(void* model, int cs);
QMODELVIEW_API int   qteQSortFilterProxyModel_sortCaseSensitivity(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterRole(void* model, int role);
QMODELVIEW_API int   qteQSortFilterProxyModel_filterRole(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setSortRole(void* model, int role);
QMODELVIEW_API int   qteQSortFilterProxyModel_sortRole(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setDynamicSortFilter(void* model, int enable);
QMODELVIEW_API int   qteQSortFilterProxyModel_dynamicSortFilter(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_setFilterKeyColumn(void* model, int col);
QMODELVIEW_API int   qteQSortFilterProxyModel_filterKeyColumn(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_invalidate(void* model);
QMODELVIEW_API void  qteQSortFilterProxyModel_sort(void* model, int col, int order);
QMODELVIEW_API int   qteQSortFilterProxyModel_rowCount(void* model, void* parent);
QMODELVIEW_API int   qteQSortFilterProxyModel_columnCount(void* model, void* parent);
QMODELVIEW_API void* qteQSortFilterProxyModel_index(void* model, int row, int col, void* parent);
QMODELVIEW_API void* qteQSortFilterProxyModel_parent(void* model, void* index);
QMODELVIEW_API void* qteQSortFilterProxyModel_data_s(void* model, void* index, int role);
QMODELVIEW_API int   qteQSortFilterProxyModel_data_i(void* model, void* index, int role);
QMODELVIEW_API int   qteQSortFilterProxyModel_flags(void* model, void* index);

// ── QStringListModel (24700–24749) ───────────────────────────────────────────
QMODELVIEW_API void* qteQStringListModel_create(void* parent);
QMODELVIEW_API void* qteQStringListModel_create_sl(void* strings_sep1, void* parent);
QMODELVIEW_API void  qteQStringListModel_delete(void* model);
QMODELVIEW_API int   qteQStringListModel_rowCount(void* model, void* parent);
QMODELVIEW_API void* qteQStringListModel_index(void* model, int row, int col, void* parent);
QMODELVIEW_API void* qteQStringListModel_data_s(void* model, void* index, int role);
QMODELVIEW_API int   qteQStringListModel_data_i(void* model, void* index, int role);
QMODELVIEW_API int   qteQStringListModel_setData_s(void* model, void* index, void* qs, int role);
QMODELVIEW_API int   qteQStringListModel_flags(void* model, void* index);
QMODELVIEW_API void  qteQStringListModel_setStringList(void* model, void* strings_sep1);
QMODELVIEW_API void* qteQStringListModel_stringList(void* model);
QMODELVIEW_API int   qteQStringListModel_removeRows(void* model, int row, int count, void* parent);
QMODELVIEW_API int   qteQStringListModel_insertRows(void* model, int row, int count, void* parent);
QMODELVIEW_API void  qteQStringListModel_sort(void* model, int col, int order);

} // extern "C"
