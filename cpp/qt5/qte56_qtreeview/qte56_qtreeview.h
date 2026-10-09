#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTREEVIEW_BUILD
    #define QTREEVIEW_API __declspec(dllexport)
  #else
    #define QTREEVIEW_API __declspec(dllimport)
  #endif
#else
  #define QTREEVIEW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTREEVIEW_API void* qteQTreeView_create(void* parent);
QTREEVIEW_API void  qteQTreeView_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTREEVIEW_API void* qteQTreeView_header(void* _obj);
QTREEVIEW_API void qteQTreeView_setHeader(void* _obj, void* header);
QTREEVIEW_API int qteQTreeView_autoExpandDelay(void* _obj);
QTREEVIEW_API void qteQTreeView_setAutoExpandDelay(void* _obj, int delay);
QTREEVIEW_API int qteQTreeView_indentation(void* _obj);
QTREEVIEW_API void qteQTreeView_setIndentation(void* _obj, int i);
QTREEVIEW_API void qteQTreeView_resetIndentation(void* _obj);
QTREEVIEW_API int qteQTreeView_rootIsDecorated(void* _obj);
QTREEVIEW_API void qteQTreeView_setRootIsDecorated(void* _obj, int show);
QTREEVIEW_API int qteQTreeView_uniformRowHeights(void* _obj);
QTREEVIEW_API void qteQTreeView_setUniformRowHeights(void* _obj, int uniform);
QTREEVIEW_API int qteQTreeView_itemsExpandable(void* _obj);
QTREEVIEW_API void qteQTreeView_setItemsExpandable(void* _obj, int enable);
QTREEVIEW_API int qteQTreeView_expandsOnDoubleClick(void* _obj);
QTREEVIEW_API void qteQTreeView_setExpandsOnDoubleClick(void* _obj, int enable);
QTREEVIEW_API int qteQTreeView_columnViewportPosition(void* _obj, int column);
QTREEVIEW_API int qteQTreeView_columnWidth(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_setColumnWidth(void* _obj, int column, int width);
QTREEVIEW_API int qteQTreeView_columnAt(void* _obj, int x);
QTREEVIEW_API int qteQTreeView_isColumnHidden(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_setColumnHidden(void* _obj, int column, int hide);
QTREEVIEW_API int qteQTreeView_isHeaderHidden(void* _obj);
QTREEVIEW_API void qteQTreeView_setHeaderHidden(void* _obj, int hide);
QTREEVIEW_API void qteQTreeView_setSortingEnabled(void* _obj, int enable);
QTREEVIEW_API int qteQTreeView_isSortingEnabled(void* _obj);
QTREEVIEW_API void qteQTreeView_setAnimated(void* _obj, int enable);
QTREEVIEW_API int qteQTreeView_isAnimated(void* _obj);
QTREEVIEW_API void qteQTreeView_setAllColumnsShowFocus(void* _obj, int enable);
QTREEVIEW_API int qteQTreeView_allColumnsShowFocus(void* _obj);
QTREEVIEW_API void qteQTreeView_setWordWrap(void* _obj, int on);
QTREEVIEW_API int qteQTreeView_wordWrap(void* _obj);
QTREEVIEW_API void qteQTreeView_setTreePosition(void* _obj, int logicalIndex);
QTREEVIEW_API int qteQTreeView_treePosition(void* _obj);
QTREEVIEW_API void qteQTreeView_hideColumn(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_showColumn(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_resizeColumnToContents(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_sortByColumn_i(void* _obj, int column);
QTREEVIEW_API void qteQTreeView_sortByColumn_ip(void* _obj, int column, int order);
QTREEVIEW_API void qteQTreeView_expandAll(void* _obj);
QTREEVIEW_API void qteQTreeView_collapseAll(void* _obj);
QTREEVIEW_API void qteQTreeView_expandToDepth(void* _obj, int depth);

} // extern "C"
