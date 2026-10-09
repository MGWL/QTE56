#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTABWIDGET_BUILD
    #define QTABWIDGET_API __declspec(dllexport)
  #else
    #define QTABWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QTABWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTABWIDGET_API void* qteQTabWidget_create(void* parent);
QTABWIDGET_API void  qteQTabWidget_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTABWIDGET_API void qteQTabWidget_show(void* _obj);
QTABWIDGET_API void qteQTabWidget_hide(void* _obj);
QTABWIDGET_API void qteQTabWidget_update(void* _obj);
QTABWIDGET_API int qteQTabWidget_addTab(void* _obj, void* widget, void* p1);
QTABWIDGET_API int qteQTabWidget_insertTab(void* _obj, int index, void* widget, void* p2);
QTABWIDGET_API void qteQTabWidget_removeTab(void* _obj, int index);
QTABWIDGET_API int qteQTabWidget_isTabEnabled(void* _obj, int index);
QTABWIDGET_API void qteQTabWidget_setTabEnabled(void* _obj, int index, int p1);
QTABWIDGET_API void* qteQTabWidget_tabText(void* _obj, int index);
QTABWIDGET_API void qteQTabWidget_setTabText(void* _obj, int index, void* p1);
QTABWIDGET_API void* qteQTabWidget_tabToolTip(void* _obj, int index);
QTABWIDGET_API void qteQTabWidget_setTabToolTip(void* _obj, int index, void* tip);
QTABWIDGET_API void qteQTabWidget_setTabWhatsThis(void* _obj, int index, void* text);
QTABWIDGET_API void* qteQTabWidget_tabWhatsThis(void* _obj, int index);
QTABWIDGET_API int qteQTabWidget_currentIndex(void* _obj);
QTABWIDGET_API void* qteQTabWidget_currentWidget(void* _obj);
QTABWIDGET_API void* qteQTabWidget_widget(void* _obj, int index);
QTABWIDGET_API int qteQTabWidget_indexOf(void* _obj, void* widget);
QTABWIDGET_API int qteQTabWidget_count(void* _obj);
QTABWIDGET_API int qteQTabWidget_tabPosition(void* _obj);
QTABWIDGET_API void qteQTabWidget_setTabPosition(void* _obj, int p0);
QTABWIDGET_API int qteQTabWidget_tabsClosable(void* _obj);
QTABWIDGET_API void qteQTabWidget_setTabsClosable(void* _obj, int closeable);
QTABWIDGET_API int qteQTabWidget_isMovable(void* _obj);
QTABWIDGET_API void qteQTabWidget_setMovable(void* _obj, int movable);
QTABWIDGET_API int qteQTabWidget_tabShape(void* _obj);
QTABWIDGET_API void qteQTabWidget_setTabShape(void* _obj, int s);
QTABWIDGET_API void* qteQTabWidget_sizeHint(void* _obj);
QTABWIDGET_API void* qteQTabWidget_minimumSizeHint(void* _obj);
QTABWIDGET_API int qteQTabWidget_heightForWidth(void* _obj, int width);
QTABWIDGET_API int qteQTabWidget_hasHeightForWidth(void* _obj);
QTABWIDGET_API void qteQTabWidget_setCornerWidget(void* _obj, void* w, int corner);
QTABWIDGET_API void* qteQTabWidget_cornerWidget(void* _obj, int corner);
QTABWIDGET_API int qteQTabWidget_elideMode(void* _obj);
QTABWIDGET_API void qteQTabWidget_setElideMode(void* _obj, int p0);
QTABWIDGET_API void* qteQTabWidget_iconSize(void* _obj);
QTABWIDGET_API void qteQTabWidget_setIconSize(void* _obj, void* size);
QTABWIDGET_API int qteQTabWidget_usesScrollButtons(void* _obj);
QTABWIDGET_API void qteQTabWidget_setUsesScrollButtons(void* _obj, int useButtons);
QTABWIDGET_API int qteQTabWidget_documentMode(void* _obj);
QTABWIDGET_API void qteQTabWidget_setDocumentMode(void* _obj, int set);
QTABWIDGET_API int qteQTabWidget_tabBarAutoHide(void* _obj);
QTABWIDGET_API void qteQTabWidget_setTabBarAutoHide(void* _obj, int enabled);
QTABWIDGET_API void qteQTabWidget_clear(void* _obj);
QTABWIDGET_API void* qteQTabWidget_tabBar(void* _obj);
QTABWIDGET_API void qteQTabWidget_setCurrentIndex(void* _obj, int index);
QTABWIDGET_API void qteQTabWidget_setCurrentWidget(void* _obj, void* widget);

// ── Event handler ────────────────────────────────────────────────────────────
QTABWIDGET_API void qteQTabWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
