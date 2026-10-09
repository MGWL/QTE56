#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTREEWIDGET_BUILD
    #define QTREEWIDGET_API __declspec(dllexport)
  #else
    #define QTREEWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QTREEWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTREEWIDGET_API void* qteQTreeWidget_create(void* parent);
QTREEWIDGET_API void  qteQTreeWidget_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTREEWIDGET_API int qteQTreeWidget_columnCount(void* _obj);
QTREEWIDGET_API void qteQTreeWidget_setColumnCount(void* _obj, int columns);
QTREEWIDGET_API void* qteQTreeWidget_invisibleRootItem(void* _obj);
QTREEWIDGET_API void* qteQTreeWidget_topLevelItem(void* _obj, int index);
QTREEWIDGET_API int qteQTreeWidget_topLevelItemCount(void* _obj);
QTREEWIDGET_API void qteQTreeWidget_insertTopLevelItem(void* _obj, int index, void* item);
QTREEWIDGET_API void qteQTreeWidget_addTopLevelItem(void* _obj, void* item);
QTREEWIDGET_API void* qteQTreeWidget_takeTopLevelItem(void* _obj, int index);
QTREEWIDGET_API int qteQTreeWidget_indexOfTopLevelItem(void* _obj, void* item);
QTREEWIDGET_API void* qteQTreeWidget_headerItem(void* _obj);
QTREEWIDGET_API void qteQTreeWidget_setHeaderItem(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setHeaderLabel(void* _obj, void* label);
// setHeaderLabels(items_sep1): items — строки, объединённые \x01
QTREEWIDGET_API void qteQTreeWidget_setHeaderLabels(void* _obj, void* items_sep1);
QTREEWIDGET_API void* qteQTreeWidget_currentItem(void* _obj);
QTREEWIDGET_API int qteQTreeWidget_currentColumn(void* _obj);
QTREEWIDGET_API void qteQTreeWidget_setCurrentItem_p(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setCurrentItem_pi(void* _obj, void* item, int column);
QTREEWIDGET_API void qteQTreeWidget_setCurrentItem_pip(void* _obj, void* item, int column, int command);
QTREEWIDGET_API void* qteQTreeWidget_itemAt_p(void* _obj, void* p);
QTREEWIDGET_API void* qteQTreeWidget_itemAt_ii(void* _obj, int x, int y);
QTREEWIDGET_API void* qteQTreeWidget_visualItemRect(void* _obj, void* item);
QTREEWIDGET_API int qteQTreeWidget_sortColumn(void* _obj);
QTREEWIDGET_API void qteQTreeWidget_sortItems(void* _obj, int column, int order);
QTREEWIDGET_API void qteQTreeWidget_editItem(void* _obj, void* item, int column);
QTREEWIDGET_API void qteQTreeWidget_openPersistentEditor(void* _obj, void* item, int column);
QTREEWIDGET_API void qteQTreeWidget_closePersistentEditor(void* _obj, void* item, int column);
QTREEWIDGET_API int qteQTreeWidget_isPersistentEditorOpen(void* _obj, void* item, int column);
QTREEWIDGET_API void* qteQTreeWidget_itemWidget(void* _obj, void* item, int column);
QTREEWIDGET_API void qteQTreeWidget_setItemWidget(void* _obj, void* item, int column, void* widget);
QTREEWIDGET_API void qteQTreeWidget_removeItemWidget(void* _obj, void* item, int column);
QTREEWIDGET_API int qteQTreeWidget_isItemSelected(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setItemSelected(void* _obj, void* item, int select);
QTREEWIDGET_API int qteQTreeWidget_isItemHidden(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setItemHidden(void* _obj, void* item, int hide);
QTREEWIDGET_API int qteQTreeWidget_isItemExpanded(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setItemExpanded(void* _obj, void* item, int expand);
QTREEWIDGET_API int qteQTreeWidget_isFirstItemColumnSpanned(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_setFirstItemColumnSpanned(void* _obj, void* item, int span);
QTREEWIDGET_API void* qteQTreeWidget_itemAbove(void* _obj, void* item);
QTREEWIDGET_API void* qteQTreeWidget_itemBelow(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_scrollToItem(void* _obj, void* item, int hint);
QTREEWIDGET_API void qteQTreeWidget_expandItem(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_collapseItem(void* _obj, void* item);
QTREEWIDGET_API void qteQTreeWidget_clear(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QTREEWIDGET_API void qteQTreeWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Signal connections (direct callback) ─────────────────────────────────────
// itemClicked/itemDoubleClicked/itemChanged/itemActivated(item, col):
//   cb: void(void* dthis, int n, void* item, int col)
// itemExpanded/itemCollapsed/itemEntered(item):
//   cb: void(void* dthis, int n, void* item)
// currentItemChanged(current, previous):
//   cb: void(void* dthis, int n, void* current, void* previous)
// itemSelectionChanged():
//   cb: void(void* dthis, int n)
QTREEWIDGET_API void qteQTreeWidget_connectItemClicked(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemDoubleClicked(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemChanged(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemActivated(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemExpanded(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemCollapsed(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectCurrentItemChanged(void* w, void* cb, void* dthis);
QTREEWIDGET_API void qteQTreeWidget_connectItemSelectionChanged(void* w, void* cb, void* dthis);

// ── QTreeWidgetItem helpers ───────────────────────────────────────────────────
QTREEWIDGET_API void* qteQTreeWidgetItem_create();
QTREEWIDGET_API void* qteQTreeWidgetItem_create_text(void* text);
QTREEWIDGET_API void  qteQTreeWidgetItem_delete(void* item);
QTREEWIDGET_API void* qteQTreeWidgetItem_text(void* item, int column);
QTREEWIDGET_API void  qteQTreeWidgetItem_setText(void* item, int column, void* text);
QTREEWIDGET_API int   qteQTreeWidgetItem_flags(void* item);
QTREEWIDGET_API void  qteQTreeWidgetItem_setFlags(void* item, int flags);
QTREEWIDGET_API int   qteQTreeWidgetItem_isExpanded(void* item);
QTREEWIDGET_API void  qteQTreeWidgetItem_setExpanded(void* item, int expand);
QTREEWIDGET_API int   qteQTreeWidgetItem_isSelected(void* item);
QTREEWIDGET_API void  qteQTreeWidgetItem_setSelected(void* item, int sel);
QTREEWIDGET_API int   qteQTreeWidgetItem_isHidden(void* item);
QTREEWIDGET_API void  qteQTreeWidgetItem_setHidden(void* item, int hide);
QTREEWIDGET_API void* qteQTreeWidgetItem_parent(void* item);
QTREEWIDGET_API int   qteQTreeWidgetItem_childCount(void* item);
QTREEWIDGET_API void* qteQTreeWidgetItem_child(void* item, int index);
QTREEWIDGET_API void  qteQTreeWidgetItem_addChild(void* item, void* child);
QTREEWIDGET_API void  qteQTreeWidgetItem_insertChild(void* item, int index, void* child);
QTREEWIDGET_API void* qteQTreeWidgetItem_takeChild(void* item, int index);
QTREEWIDGET_API void  qteQTreeWidgetItem_removeChild(void* item, void* child);
QTREEWIDGET_API int   qteQTreeWidgetItem_indexOfChild(void* item, void* child);
QTREEWIDGET_API int   qteQTreeWidgetItem_checkState(void* item, int column);
QTREEWIDGET_API void  qteQTreeWidgetItem_setCheckState(void* item, int column, int state);
// ── List queries ─────────────────────────────────────────────────────────────
QTREEWIDGET_API void* qteQTreeWidget_selectedItems(void* _obj);

} // extern "C"
