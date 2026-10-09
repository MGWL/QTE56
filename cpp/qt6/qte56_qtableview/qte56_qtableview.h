#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTABLEVIEW_BUILD
    #define QTABLEVIEW_API __declspec(dllexport)
  #else
    #define QTABLEVIEW_API __declspec(dllimport)
  #endif
#else
  #define QTABLEVIEW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTABLEVIEW_API void* qteQTableView_create(void* parent);
QTABLEVIEW_API void  qteQTableView_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTABLEVIEW_API void* qteQTableView_horizontalHeader(void* _obj);
QTABLEVIEW_API void* qteQTableView_verticalHeader(void* _obj);
QTABLEVIEW_API void qteQTableView_setHorizontalHeader(void* _obj, void* header);
QTABLEVIEW_API void qteQTableView_setVerticalHeader(void* _obj, void* header);
QTABLEVIEW_API int qteQTableView_rowViewportPosition(void* _obj, int row);
QTABLEVIEW_API int qteQTableView_rowAt(void* _obj, int y);
QTABLEVIEW_API void qteQTableView_setRowHeight(void* _obj, int row, int height);
QTABLEVIEW_API int qteQTableView_rowHeight(void* _obj, int row);
QTABLEVIEW_API int qteQTableView_columnViewportPosition(void* _obj, int column);
QTABLEVIEW_API int qteQTableView_columnAt(void* _obj, int x);
QTABLEVIEW_API void qteQTableView_setColumnWidth(void* _obj, int column, int width);
QTABLEVIEW_API int qteQTableView_columnWidth(void* _obj, int column);
QTABLEVIEW_API int qteQTableView_isRowHidden(void* _obj, int row);
QTABLEVIEW_API void qteQTableView_setRowHidden(void* _obj, int row, int hide);
QTABLEVIEW_API int qteQTableView_isColumnHidden(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_setColumnHidden(void* _obj, int column, int hide);
QTABLEVIEW_API void qteQTableView_setSortingEnabled(void* _obj, int enable);
QTABLEVIEW_API int qteQTableView_isSortingEnabled(void* _obj);
QTABLEVIEW_API int qteQTableView_showGrid(void* _obj);
QTABLEVIEW_API int qteQTableView_gridStyle(void* _obj);
QTABLEVIEW_API void qteQTableView_setGridStyle(void* _obj, int style);
QTABLEVIEW_API void qteQTableView_setWordWrap(void* _obj, int on);
QTABLEVIEW_API int qteQTableView_wordWrap(void* _obj);
QTABLEVIEW_API void qteQTableView_setCornerButtonEnabled(void* _obj, int enable);
QTABLEVIEW_API int qteQTableView_isCornerButtonEnabled(void* _obj);
QTABLEVIEW_API void qteQTableView_setSpan(void* _obj, int row, int column, int rowSpan, int columnSpan);
QTABLEVIEW_API int qteQTableView_rowSpan(void* _obj, int row, int column);
QTABLEVIEW_API int qteQTableView_columnSpan(void* _obj, int row, int column);
QTABLEVIEW_API void qteQTableView_clearSpans(void* _obj);
QTABLEVIEW_API void qteQTableView_selectRow(void* _obj, int row);
QTABLEVIEW_API void qteQTableView_selectColumn(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_hideRow(void* _obj, int row);
QTABLEVIEW_API void qteQTableView_hideColumn(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_showRow(void* _obj, int row);
QTABLEVIEW_API void qteQTableView_showColumn(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_resizeRowToContents(void* _obj, int row);
QTABLEVIEW_API void qteQTableView_resizeRowsToContents(void* _obj);
QTABLEVIEW_API void qteQTableView_resizeColumnToContents(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_resizeColumnsToContents(void* _obj);
QTABLEVIEW_API void qteQTableView_sortByColumn_i(void* _obj, int column);
QTABLEVIEW_API void qteQTableView_sortByColumn_ip(void* _obj, int column, int order);
QTABLEVIEW_API void qteQTableView_setShowGrid(void* _obj, int show);

} // extern "C"
