#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTABLEWIDGET_BUILD
    #define QTABLEWIDGET_API __declspec(dllexport)
  #else
    #define QTABLEWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QTABLEWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTABLEWIDGET_API void* qteQTableWidget_create(void* parent);
QTABLEWIDGET_API void  qteQTableWidget_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTABLEWIDGET_API void qteQTableWidget_setRowCount(void* _obj, int rows);
QTABLEWIDGET_API int qteQTableWidget_rowCount(void* _obj);
QTABLEWIDGET_API void qteQTableWidget_setColumnCount(void* _obj, int columns);
QTABLEWIDGET_API int qteQTableWidget_columnCount(void* _obj);
QTABLEWIDGET_API int qteQTableWidget_row(void* _obj, void* item);
QTABLEWIDGET_API int qteQTableWidget_column(void* _obj, void* item);
QTABLEWIDGET_API void* qteQTableWidget_item(void* _obj, int row, int column);
QTABLEWIDGET_API void qteQTableWidget_setItem(void* _obj, int row, int column, void* item);
QTABLEWIDGET_API void* qteQTableWidget_takeItem(void* _obj, int row, int column);
QTABLEWIDGET_API void* qteQTableWidget_verticalHeaderItem(void* _obj, int row);
QTABLEWIDGET_API void qteQTableWidget_setVerticalHeaderItem(void* _obj, int row, void* item);
QTABLEWIDGET_API void* qteQTableWidget_takeVerticalHeaderItem(void* _obj, int row);
QTABLEWIDGET_API void* qteQTableWidget_horizontalHeaderItem(void* _obj, int column);
QTABLEWIDGET_API void qteQTableWidget_setHorizontalHeaderItem(void* _obj, int column, void* item);
QTABLEWIDGET_API void* qteQTableWidget_takeHorizontalHeaderItem(void* _obj, int column);
QTABLEWIDGET_API int qteQTableWidget_currentRow(void* _obj);
QTABLEWIDGET_API int qteQTableWidget_currentColumn(void* _obj);
QTABLEWIDGET_API void* qteQTableWidget_currentItem(void* _obj);
QTABLEWIDGET_API void qteQTableWidget_setCurrentItem_p(void* _obj, void* item);
QTABLEWIDGET_API void qteQTableWidget_setCurrentItem_pp(void* _obj, void* item, int command);
QTABLEWIDGET_API void qteQTableWidget_setCurrentCell_ii(void* _obj, int row, int column);
QTABLEWIDGET_API void qteQTableWidget_setCurrentCell_iip(void* _obj, int row, int column, int command);
QTABLEWIDGET_API void qteQTableWidget_sortItems(void* _obj, int column, int order);
QTABLEWIDGET_API void qteQTableWidget_editItem(void* _obj, void* item);
QTABLEWIDGET_API void qteQTableWidget_openPersistentEditor(void* _obj, void* item);
QTABLEWIDGET_API void qteQTableWidget_closePersistentEditor(void* _obj, void* item);
QTABLEWIDGET_API int qteQTableWidget_isPersistentEditorOpen(void* _obj, void* item);
QTABLEWIDGET_API void* qteQTableWidget_cellWidget(void* _obj, int row, int column);
QTABLEWIDGET_API void qteQTableWidget_setCellWidget(void* _obj, int row, int column, void* widget);
QTABLEWIDGET_API void qteQTableWidget_removeCellWidget(void* _obj, int row, int column);
QTABLEWIDGET_API int qteQTableWidget_isItemSelected(void* _obj, void* item);
QTABLEWIDGET_API void qteQTableWidget_setItemSelected(void* _obj, void* item, int select);
QTABLEWIDGET_API int qteQTableWidget_visualRow(void* _obj, int logicalRow);
QTABLEWIDGET_API int qteQTableWidget_visualColumn(void* _obj, int logicalColumn);
QTABLEWIDGET_API void* qteQTableWidget_itemAt_p(void* _obj, void* p);
QTABLEWIDGET_API void* qteQTableWidget_itemAt_ii(void* _obj, int x, int y);
QTABLEWIDGET_API void* qteQTableWidget_visualItemRect(void* _obj, void* item);
QTABLEWIDGET_API void* qteQTableWidget_itemPrototype(void* _obj);
QTABLEWIDGET_API void qteQTableWidget_setItemPrototype(void* _obj, void* item);
QTABLEWIDGET_API void qteQTableWidget_scrollToItem(void* _obj, void* item, int hint);
QTABLEWIDGET_API void qteQTableWidget_insertRow(void* _obj, int row);
QTABLEWIDGET_API void qteQTableWidget_insertColumn(void* _obj, int column);
QTABLEWIDGET_API void qteQTableWidget_removeRow(void* _obj, int row);
QTABLEWIDGET_API void qteQTableWidget_removeColumn(void* _obj, int column);
QTABLEWIDGET_API void qteQTableWidget_clear(void* _obj);
QTABLEWIDGET_API void qteQTableWidget_clearContents(void* _obj);

// ── QStringList helpers (sep=\x01) ──────────────────────────────────────────
// setHorizontalHeaderLabels(items_sep1): items — строки, объединённые \x01
QTABLEWIDGET_API void qteQTableWidget_setHorizontalHeaderLabels(void* _obj, void* items_sep1);
// setVerticalHeaderLabels(items_sep1): items — строки, объединённые \x01
QTABLEWIDGET_API void qteQTableWidget_setVerticalHeaderLabels(void* _obj, void* items_sep1);

// ── Event handler ────────────────────────────────────────────────────────────
QTABLEWIDGET_API void qteQTableWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── QTableWidgetItem helpers ──────────────────────────────────────────────────
QTABLEWIDGET_API void* qteQTableWidgetItem_create(void* text);
QTABLEWIDGET_API void* qteQTableWidgetItem_create_empty(void* unused);
QTABLEWIDGET_API void  qteQTableWidgetItem_delete(void* item);
QTABLEWIDGET_API void* qteQTableWidgetItem_text(void* item);
QTABLEWIDGET_API void  qteQTableWidgetItem_setText(void* item, void* text);
QTABLEWIDGET_API int   qteQTableWidgetItem_flags(void* item);
QTABLEWIDGET_API void  qteQTableWidgetItem_setFlags(void* item, int flags);
QTABLEWIDGET_API int   qteQTableWidgetItem_textAlignment(void* item);
QTABLEWIDGET_API void  qteQTableWidgetItem_setTextAlignment(void* item, int alignment);
// ── List queries ─────────────────────────────────────────────────────────────
QTABLEWIDGET_API void* qteQTableWidget_selectedItems(void* _obj);

} // extern "C"
