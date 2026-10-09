#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMDIAREA_BUILD
    #define QMDIAREA_API __declspec(dllexport)
  #else
    #define QMDIAREA_API __declspec(dllimport)
  #endif
#else
  #define QMDIAREA_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMDIAREA_API void* qteQMdiArea_create(void* parent);
QMDIAREA_API void  qteQMdiArea_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QMDIAREA_API void* qteQMdiArea_currentSubWindow(void* _obj);
QMDIAREA_API void* qteQMdiArea_activeSubWindow(void* _obj);
QMDIAREA_API void* qteQMdiArea_addSubWindow(void* _obj, void* widget, int flags);
QMDIAREA_API void qteQMdiArea_removeSubWindow(void* _obj, void* widget);
QMDIAREA_API int qteQMdiArea_activationOrder(void* _obj);
QMDIAREA_API void qteQMdiArea_setActivationOrder(void* _obj, int order);
QMDIAREA_API void qteQMdiArea_setOption(void* _obj, int option, int on);
QMDIAREA_API int qteQMdiArea_testOption(void* _obj, int opton);
QMDIAREA_API void qteQMdiArea_setViewMode(void* _obj, int mode);
QMDIAREA_API int qteQMdiArea_viewMode(void* _obj);
QMDIAREA_API int qteQMdiArea_documentMode(void* _obj);
QMDIAREA_API void qteQMdiArea_setDocumentMode(void* _obj, int enabled);
QMDIAREA_API void qteQMdiArea_setTabsClosable(void* _obj, int closable);
QMDIAREA_API int qteQMdiArea_tabsClosable(void* _obj);
QMDIAREA_API void qteQMdiArea_setTabsMovable(void* _obj, int movable);
QMDIAREA_API int qteQMdiArea_tabsMovable(void* _obj);
QMDIAREA_API void qteQMdiArea_setTabShape(void* _obj, int shape);
QMDIAREA_API int qteQMdiArea_tabShape(void* _obj);
QMDIAREA_API void qteQMdiArea_setTabPosition(void* _obj, int position);
QMDIAREA_API int qteQMdiArea_tabPosition(void* _obj);
QMDIAREA_API void qteQMdiArea_setActiveSubWindow(void* _obj, void* window);
QMDIAREA_API void qteQMdiArea_tileSubWindows(void* _obj);
QMDIAREA_API void qteQMdiArea_cascadeSubWindows(void* _obj);
QMDIAREA_API void qteQMdiArea_closeActiveSubWindow(void* _obj);
QMDIAREA_API void qteQMdiArea_closeAllSubWindows(void* _obj);
QMDIAREA_API void qteQMdiArea_activateNextSubWindow(void* _obj);
QMDIAREA_API void qteQMdiArea_activatePreviousSubWindow(void* _obj);

// ── List queries ─────────────────────────────────────────────────────────────
QMDIAREA_API void* qteQMdiArea_subWindowList(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QMDIAREA_API void qteQMdiArea_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
