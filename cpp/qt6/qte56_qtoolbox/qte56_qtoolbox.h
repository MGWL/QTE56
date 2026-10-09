#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTOOLBOX_BUILD
    #define QTOOLBOX_API __declspec(dllexport)
  #else
    #define QTOOLBOX_API __declspec(dllimport)
  #endif
#else
  #define QTOOLBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTOOLBOX_API void* qteQToolBox_create(void* parent);
QTOOLBOX_API void  qteQToolBox_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTOOLBOX_API int qteQToolBox_addItem_ws(void* _obj, void* widget, void* text);
QTOOLBOX_API int qteQToolBox_addItem_wps(void* _obj, void* widget, void* icon, void* text);
QTOOLBOX_API int qteQToolBox_insertItem_iws(void* _obj, int index, void* widget, void* text);
QTOOLBOX_API int qteQToolBox_insertItem_iwps(void* _obj, int index, void* widget, void* icon, void* text);
QTOOLBOX_API void qteQToolBox_removeItem(void* _obj, int index);
QTOOLBOX_API void qteQToolBox_setItemEnabled(void* _obj, int index, int enabled);
QTOOLBOX_API int qteQToolBox_isItemEnabled(void* _obj, int index);
QTOOLBOX_API void qteQToolBox_setItemText(void* _obj, int index, void* text);
QTOOLBOX_API void* qteQToolBox_itemText(void* _obj, int index);
QTOOLBOX_API void qteQToolBox_setItemIcon(void* _obj, int index, void* icon);
QTOOLBOX_API void* qteQToolBox_itemIcon(void* _obj, int index);
QTOOLBOX_API void qteQToolBox_setItemToolTip(void* _obj, int index, void* toolTip);
QTOOLBOX_API void* qteQToolBox_itemToolTip(void* _obj, int index);
QTOOLBOX_API int qteQToolBox_currentIndex(void* _obj);
QTOOLBOX_API void* qteQToolBox_currentWidget(void* _obj);
QTOOLBOX_API void* qteQToolBox_widget(void* _obj, int index);
QTOOLBOX_API int qteQToolBox_indexOf(void* _obj, void* widget);
QTOOLBOX_API int qteQToolBox_count(void* _obj);
QTOOLBOX_API void qteQToolBox_setCurrentIndex(void* _obj, int index);
QTOOLBOX_API void qteQToolBox_setCurrentWidget(void* _obj, void* widget);

// ── Event handler ────────────────────────────────────────────────────────────
QTOOLBOX_API void qteQToolBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
