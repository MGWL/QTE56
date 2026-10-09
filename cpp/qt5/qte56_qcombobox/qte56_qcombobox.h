#pragma once

#ifdef _WIN32
  #ifdef QTE56_QCOMBOBOX_BUILD
    #define QCOMBOBOX_API __declspec(dllexport)
  #else
    #define QCOMBOBOX_API __declspec(dllimport)
  #endif
#else
  #define QCOMBOBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QCOMBOBOX_API void* qteQComboBox_create(void* parent);
QCOMBOBOX_API void  qteQComboBox_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QCOMBOBOX_API void qteQComboBox_show(void* _obj);
QCOMBOBOX_API void qteQComboBox_hide(void* _obj);
QCOMBOBOX_API void qteQComboBox_update(void* _obj);
QCOMBOBOX_API int qteQComboBox_maxVisibleItems(void* _obj);
QCOMBOBOX_API void qteQComboBox_setMaxVisibleItems(void* _obj, int maxItems);
QCOMBOBOX_API int qteQComboBox_count(void* _obj);
QCOMBOBOX_API void qteQComboBox_setMaxCount(void* _obj, int max);
QCOMBOBOX_API int qteQComboBox_maxCount(void* _obj);
QCOMBOBOX_API int qteQComboBox_autoCompletion(void* _obj);
QCOMBOBOX_API void qteQComboBox_setAutoCompletion(void* _obj, int enable);
QCOMBOBOX_API int qteQComboBox_autoCompletionCaseSensitivity(void* _obj);
QCOMBOBOX_API void qteQComboBox_setAutoCompletionCaseSensitivity(void* _obj, int sensitivity);
QCOMBOBOX_API int qteQComboBox_duplicatesEnabled(void* _obj);
QCOMBOBOX_API void qteQComboBox_setDuplicatesEnabled(void* _obj, int enable);
QCOMBOBOX_API void qteQComboBox_setFrame(void* _obj, int p0);
QCOMBOBOX_API int qteQComboBox_hasFrame(void* _obj);
QCOMBOBOX_API int qteQComboBox_insertPolicy(void* _obj);
QCOMBOBOX_API void qteQComboBox_setInsertPolicy(void* _obj, int policy);
QCOMBOBOX_API int qteQComboBox_sizeAdjustPolicy(void* _obj);
QCOMBOBOX_API void qteQComboBox_setSizeAdjustPolicy(void* _obj, int policy);
QCOMBOBOX_API int qteQComboBox_minimumContentsLength(void* _obj);
QCOMBOBOX_API void qteQComboBox_setMinimumContentsLength(void* _obj, int characters);
QCOMBOBOX_API void* qteQComboBox_iconSize(void* _obj);
QCOMBOBOX_API void qteQComboBox_setIconSize(void* _obj, void* size);
QCOMBOBOX_API int qteQComboBox_isEditable(void* _obj);
QCOMBOBOX_API void qteQComboBox_setEditable(void* _obj, int editable);
QCOMBOBOX_API void qteQComboBox_setLineEdit(void* _obj, void* edit);
QCOMBOBOX_API void qteQComboBox_setValidator(void* _obj, void* v);
QCOMBOBOX_API void qteQComboBox_setCompleter(void* _obj, void* c);
QCOMBOBOX_API void qteQComboBox_setItemDelegate(void* _obj, void* delegate);
QCOMBOBOX_API void qteQComboBox_setModel(void* _obj, void* model);
QCOMBOBOX_API int qteQComboBox_modelColumn(void* _obj);
QCOMBOBOX_API void qteQComboBox_setModelColumn(void* _obj, int visibleColumn);
QCOMBOBOX_API int qteQComboBox_currentIndex(void* _obj);
QCOMBOBOX_API void* qteQComboBox_currentText(void* _obj);
QCOMBOBOX_API void* qteQComboBox_itemText(void* _obj, int index);
QCOMBOBOX_API void qteQComboBox_addItem(void* _obj, void* text);
QCOMBOBOX_API void qteQComboBox_insertItem(void* _obj, int index, void* text);
QCOMBOBOX_API void qteQComboBox_insertSeparator(void* _obj, int index);
QCOMBOBOX_API void qteQComboBox_removeItem(void* _obj, int index);
QCOMBOBOX_API void qteQComboBox_setItemText(void* _obj, int index, void* text);
QCOMBOBOX_API void qteQComboBox_setView(void* _obj, void* itemView);
QCOMBOBOX_API void* qteQComboBox_sizeHint(void* _obj);
QCOMBOBOX_API void* qteQComboBox_minimumSizeHint(void* _obj);
QCOMBOBOX_API void qteQComboBox_showPopup(void* _obj);
QCOMBOBOX_API void qteQComboBox_hidePopup(void* _obj);
QCOMBOBOX_API int qteQComboBox_event(void* _obj, void* event);
QCOMBOBOX_API void qteQComboBox_clear(void* _obj);
QCOMBOBOX_API void qteQComboBox_clearEditText(void* _obj);
QCOMBOBOX_API void qteQComboBox_setEditText(void* _obj, void* text);
QCOMBOBOX_API void qteQComboBox_setCurrentIndex(void* _obj, int index);
QCOMBOBOX_API void qteQComboBox_setCurrentText(void* _obj, void* text);

// ── Event handler ────────────────────────────────────────────────────────────
QCOMBOBOX_API void qteQComboBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
