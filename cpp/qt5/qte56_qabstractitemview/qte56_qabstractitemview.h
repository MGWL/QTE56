#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTITEMVIEW_BUILD
    #define QABSTRACTITEMVIEW_API __declspec(dllexport)
  #else
    #define QABSTRACTITEMVIEW_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTITEMVIEW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_create(void* parent);
QABSTRACTITEMVIEW_API void  qteQAbstractItemView_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setModel(void* _obj, void* model);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_model(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setSelectionModel(void* _obj, void* selectionModel);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_selectionModel(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setItemDelegate(void* _obj, void* delegate);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_itemDelegate(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setSelectionMode(void* _obj, int mode);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_selectionMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setSelectionBehavior(void* _obj, int behavior);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_selectionBehavior(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setEditTriggers(void* _obj, int triggers);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_editTriggers(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setVerticalScrollMode(void* _obj, int mode);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_verticalScrollMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_resetVerticalScrollMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setHorizontalScrollMode(void* _obj, int mode);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_horizontalScrollMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_resetHorizontalScrollMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setAutoScroll(void* _obj, int enable);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_hasAutoScroll(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setAutoScrollMargin(void* _obj, int margin);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_autoScrollMargin(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setTabKeyNavigation(void* _obj, int enable);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_tabKeyNavigation(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setDropIndicatorShown(void* _obj, int enable);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_showDropIndicator(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setDragEnabled(void* _obj, int enable);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_dragEnabled(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setDragDropOverwriteMode(void* _obj, int overwrite);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_dragDropOverwriteMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setDragDropMode(void* _obj, int behavior);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_dragDropMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setDefaultDropAction(void* _obj, int dropAction);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_defaultDropAction(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setAlternatingRowColors(void* _obj, int enable);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_alternatingRowColors(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setIconSize(void* _obj, void* size);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_iconSize(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setTextElideMode(void* _obj, int mode);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_textElideMode(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_keyboardSearch(void* _obj, void* search);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_sizeHintForRow(void* _obj, int row);
QABSTRACTITEMVIEW_API int qteQAbstractItemView_sizeHintForColumn(void* _obj, int column);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setItemDelegateForRow(void* _obj, int row, void* delegate);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_itemDelegateForRow(void* _obj, int row);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setItemDelegateForColumn(void* _obj, int column, void* delegate);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_itemDelegateForColumn(void* _obj, int column);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_reset(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_doItemsLayout(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_selectAll(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_clearSelection(void* _obj);
QABSTRACTITEMVIEW_API void* qteQAbstractItemView_currentIndex(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_scrollToTop(void* _obj);
QABSTRACTITEMVIEW_API void qteQAbstractItemView_scrollToBottom(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QABSTRACTITEMVIEW_API void qteQAbstractItemView_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
