#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMAINWINDOW_BUILD
    #define QMAINWINDOW_API __declspec(dllexport)
  #else
    #define QMAINWINDOW_API __declspec(dllimport)
  #endif
#else
  #define QMAINWINDOW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMAINWINDOW_API void* qteQMainWindow_create(void* parent);
QMAINWINDOW_API void  qteQMainWindow_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QMAINWINDOW_API void* qteQMainWindow_iconSize(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setIconSize(void* _obj, void* iconSize);
QMAINWINDOW_API int qteQMainWindow_toolButtonStyle(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setToolButtonStyle(void* _obj, int toolButtonStyle);
QMAINWINDOW_API int qteQMainWindow_isAnimated(void* _obj);
QMAINWINDOW_API int qteQMainWindow_isDockNestingEnabled(void* _obj);
QMAINWINDOW_API int qteQMainWindow_documentMode(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setDocumentMode(void* _obj, int enabled);
QMAINWINDOW_API int qteQMainWindow_tabShape(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setTabShape(void* _obj, int tabShape);
QMAINWINDOW_API int qteQMainWindow_tabPosition(void* _obj, int area);
QMAINWINDOW_API void qteQMainWindow_setTabPosition(void* _obj, int areas, int tabPosition);
QMAINWINDOW_API void qteQMainWindow_setDockOptions(void* _obj, int options);
QMAINWINDOW_API int qteQMainWindow_dockOptions(void* _obj);
QMAINWINDOW_API int qteQMainWindow_isSeparator(void* _obj, void* pos);
QMAINWINDOW_API void* qteQMainWindow_menuBar(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setMenuBar(void* _obj, void* menubar);
QMAINWINDOW_API void* qteQMainWindow_menuWidget(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setMenuWidget(void* _obj, void* menubar);
QMAINWINDOW_API void* qteQMainWindow_statusBar(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setStatusBar(void* _obj, void* statusbar);
QMAINWINDOW_API void* qteQMainWindow_centralWidget(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setCentralWidget(void* _obj, void* widget);
QMAINWINDOW_API void* qteQMainWindow_takeCentralWidget(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setCorner(void* _obj, int corner, int area);
QMAINWINDOW_API int qteQMainWindow_corner(void* _obj, int corner);
QMAINWINDOW_API void qteQMainWindow_addToolBarBreak(void* _obj, int area);
QMAINWINDOW_API void qteQMainWindow_insertToolBarBreak(void* _obj, void* before);
QMAINWINDOW_API void qteQMainWindow_addToolBar_pp(void* _obj, int area, void* toolbar);
QMAINWINDOW_API void qteQMainWindow_addToolBar_p(void* _obj, void* toolbar);
QMAINWINDOW_API void* qteQMainWindow_addToolBar_s(void* _obj, void* title);
QMAINWINDOW_API void qteQMainWindow_insertToolBar(void* _obj, void* before, void* toolbar);
QMAINWINDOW_API void qteQMainWindow_removeToolBar(void* _obj, void* toolbar);
QMAINWINDOW_API void qteQMainWindow_removeToolBarBreak(void* _obj, void* before);
QMAINWINDOW_API int qteQMainWindow_unifiedTitleAndToolBarOnMac(void* _obj);
QMAINWINDOW_API int qteQMainWindow_toolBarBreak(void* _obj, void* toolbar);
QMAINWINDOW_API void qteQMainWindow_addDockWidget_pp(void* _obj, int area, void* dockwidget);
QMAINWINDOW_API void qteQMainWindow_addDockWidget_ppp(void* _obj, int area, void* dockwidget, int orientation);
QMAINWINDOW_API void qteQMainWindow_splitDockWidget(void* _obj, void* after, void* dockwidget, int orientation);
QMAINWINDOW_API void qteQMainWindow_tabifyDockWidget(void* _obj, void* first, void* second);
QMAINWINDOW_API void qteQMainWindow_removeDockWidget(void* _obj, void* dockwidget);
QMAINWINDOW_API int qteQMainWindow_restoreDockWidget(void* _obj, void* dockwidget);
QMAINWINDOW_API int qteQMainWindow_dockWidgetArea(void* _obj, void* dockwidget);
QMAINWINDOW_API void* qteQMainWindow_createPopupMenu(void* _obj);
QMAINWINDOW_API void qteQMainWindow_setAnimated(void* _obj, int enabled);
QMAINWINDOW_API void qteQMainWindow_setDockNestingEnabled(void* _obj, int enabled);
QMAINWINDOW_API void qteQMainWindow_setUnifiedTitleAndToolBarOnMac(void* _obj, int set);

// ── Event handler ────────────────────────────────────────────────────────────
QMAINWINDOW_API void qteQMainWindow_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── State persistence (QByteArray*) ──────────────────────────────────────────
QMAINWINDOW_API void* qteQMainWindow_saveState(void* w);                              // 6253
QMAINWINDOW_API int   qteQMainWindow_restoreState(void* w, const void* data, int len); // 6254

} // extern "C"
