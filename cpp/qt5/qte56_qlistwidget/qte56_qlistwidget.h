#pragma once
#ifdef _WIN32
#  ifdef QTE56_QLISTWIDGET_BUILD
#    define QLISTWIDGET_API __declspec(dllexport)
#  else
#    define QLISTWIDGET_API __declspec(dllimport)
#  endif
#else
#  define QLISTWIDGET_API __attribute__((visibility("default")))
#endif
extern "C" {

// ── QListWidgetItem lifecycle ─────────────────────────────────────────────────
QLISTWIDGET_API void* qteQListWidgetItem_create(void* listwidget, int type);
QLISTWIDGET_API void* qteQListWidgetItem_create_text(void* text, void* listwidget, int type);
QLISTWIDGET_API void  qteQListWidgetItem_delete(void* item);

// ── QListWidgetItem methods ───────────────────────────────────────────────────
QLISTWIDGET_API void* qteQListWidgetItem_text(void* item);
QLISTWIDGET_API void  qteQListWidgetItem_setText(void* item, void* text);
QLISTWIDGET_API int   qteQListWidgetItem_isSelected(void* item);
QLISTWIDGET_API void  qteQListWidgetItem_setSelected(void* item, int sel);
QLISTWIDGET_API int   qteQListWidgetItem_checkState(void* item);
QLISTWIDGET_API void  qteQListWidgetItem_setCheckState(void* item, int state);
QLISTWIDGET_API int   qteQListWidgetItem_flags(void* item);
QLISTWIDGET_API void  qteQListWidgetItem_setFlags(void* item, int flags);
QLISTWIDGET_API void  qteQListWidgetItem_setIcon(void* item, void* icon);
QLISTWIDGET_API void* qteQListWidgetItem_toolTip(void* item);
QLISTWIDGET_API void  qteQListWidgetItem_setToolTip(void* item, void* text);
QLISTWIDGET_API int   qteQListWidgetItem_type(void* item);

// ── QListWidget lifecycle ─────────────────────────────────────────────────────
QLISTWIDGET_API void* qteQListWidget_create(void* parent);
QLISTWIDGET_API void  qteQListWidget_delete(void* w);

// ── QListWidget methods ───────────────────────────────────────────────────────
QLISTWIDGET_API void  qteQListWidget_addItem(void* w, void* text);
QLISTWIDGET_API void  qteQListWidget_insertItem(void* w, int row, void* text);
QLISTWIDGET_API void  qteQListWidget_addItemW(void* w, void* item);
QLISTWIDGET_API void  qteQListWidget_insertItemW(void* w, int row, void* item);
QLISTWIDGET_API int   qteQListWidget_count(void* w);
QLISTWIDGET_API void* qteQListWidget_item(void* w, int row);
QLISTWIDGET_API int   qteQListWidget_row(void* w, void* item);
QLISTWIDGET_API int   qteQListWidget_currentRow(void* w);
QLISTWIDGET_API void  qteQListWidget_setCurrentRow(void* w, int row);
QLISTWIDGET_API void* qteQListWidget_currentItem(void* w);
QLISTWIDGET_API void* qteQListWidget_takeItem(void* w, int row);
QLISTWIDGET_API void  qteQListWidget_clear(void* w);
QLISTWIDGET_API void  qteQListWidget_sortItems(void* w, int order);
QLISTWIDGET_API int   qteQListWidget_isSortingEnabled(void* w);
QLISTWIDGET_API void  qteQListWidget_setSortingEnabled(void* w, int enable);
QLISTWIDGET_API void* qteQListWidget_itemAt(void* w, int x, int y);
QLISTWIDGET_API void  qteQListWidget_scrollToItem(void* w, void* item);
QLISTWIDGET_API void  qteQListWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Signal connections (direct callback, no eSlot) ────────────────────────────
// cb signature: void cb(void* dthis, int n, void* item)  — for item-based signals
// cb signature: void cb(void* dthis, int n, int row)     — for currentRowChanged
// cb signature: void cb(void* dthis, int n, void* qs)   — for currentTextChanged
// cb signature: void cb(void* dthis, int n)              — for itemSelectionChanged
QLISTWIDGET_API void  qteQListWidget_connectItemClicked(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectItemDoubleClicked(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectItemChanged(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectCurrentRowChanged(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectCurrentTextChanged(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectItemSelectionChanged(void* w, void* cb, void* dthis);
QLISTWIDGET_API void  qteQListWidget_connectItemActivated(void* w, void* cb, void* dthis);
// ── List queries ─────────────────────────────────────────────────────────────
QLISTWIDGET_API void* qteQListWidget_selectedItems(void* _obj);

} // extern "C"
