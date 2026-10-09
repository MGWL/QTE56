#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFILEDIALOG_BUILD
    #define QFILEDIALOG_API __declspec(dllexport)
  #else
    #define QFILEDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QFILEDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QFILEDIALOG_API void* qteQFileDialog_create(void* parent);
QFILEDIALOG_API void  qteQFileDialog_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QFILEDIALOG_API void qteQFileDialog_setDirectory(void* _obj, void* directory);
QFILEDIALOG_API void qteQFileDialog_selectFile(void* _obj, void* filename);
QFILEDIALOG_API void qteQFileDialog_setNameFilterDetailsVisible(void* _obj, int enabled);
QFILEDIALOG_API int qteQFileDialog_isNameFilterDetailsVisible(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setNameFilter(void* _obj, void* filter);
// setNameFilters(items_sep1): фильтры "Images (*.png *.jpg)\x01Text (*.txt)\x01All (*)"
QFILEDIALOG_API void qteQFileDialog_setNameFilters(void* _obj, void* items_sep1);
QFILEDIALOG_API void qteQFileDialog_selectNameFilter(void* _obj, void* filter);
QFILEDIALOG_API void* qteQFileDialog_selectedMimeTypeFilter(void* _obj);
QFILEDIALOG_API void* qteQFileDialog_selectedNameFilter(void* _obj);
QFILEDIALOG_API void qteQFileDialog_selectMimeTypeFilter(void* _obj, void* filter);
QFILEDIALOG_API int qteQFileDialog_filter(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setFilter(void* _obj, int filters);
QFILEDIALOG_API void qteQFileDialog_setViewMode(void* _obj, int mode);
QFILEDIALOG_API int qteQFileDialog_viewMode(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setFileMode(void* _obj, int mode);
QFILEDIALOG_API int qteQFileDialog_fileMode(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setAcceptMode(void* _obj, int mode);
QFILEDIALOG_API int qteQFileDialog_acceptMode(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setReadOnly(void* _obj, int enabled);
QFILEDIALOG_API int qteQFileDialog_isReadOnly(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setResolveSymlinks(void* _obj, int enabled);
QFILEDIALOG_API int qteQFileDialog_resolveSymlinks(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setConfirmOverwrite(void* _obj, int enabled);
QFILEDIALOG_API int qteQFileDialog_confirmOverwrite(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setDefaultSuffix(void* _obj, void* suffix);
QFILEDIALOG_API void* qteQFileDialog_defaultSuffix(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setItemDelegate(void* _obj, void* delegate);
QFILEDIALOG_API void* qteQFileDialog_itemDelegate(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setIconProvider(void* _obj, void* provider);
QFILEDIALOG_API void* qteQFileDialog_iconProvider(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setLabelText(void* _obj, int label, void* text);
QFILEDIALOG_API void* qteQFileDialog_labelText(void* _obj, int label);
QFILEDIALOG_API void qteQFileDialog_setProxyModel(void* _obj, void* model);
QFILEDIALOG_API void* qteQFileDialog_proxyModel(void* _obj);
QFILEDIALOG_API void qteQFileDialog_setOption(void* _obj, int option, int on);
QFILEDIALOG_API int qteQFileDialog_testOption(void* _obj, int option);
QFILEDIALOG_API void qteQFileDialog_setOptions(void* _obj, int options);
QFILEDIALOG_API int qteQFileDialog_options(void* _obj);
QFILEDIALOG_API void* qteQFileDialog_getOpenFileName(void* _obj, void* parent, void* caption, void* dir, void* filter, void* selectedFilter, int options);
QFILEDIALOG_API void* qteQFileDialog_getSaveFileName(void* _obj, void* parent, void* caption, void* dir, void* filter, void* selectedFilter, int options);
QFILEDIALOG_API void* qteQFileDialog_getExistingDirectory(void* _obj, void* parent, void* caption, void* dir, int options);

// ── Event handler ────────────────────────────────────────────────────────────
QFILEDIALOG_API void qteQFileDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
