#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTOOLBAR_BUILD
    #define QTOOLBAR_API __declspec(dllexport)
  #else
    #define QTOOLBAR_API __declspec(dllimport)
  #endif
#else
  #define QTOOLBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTOOLBAR_API void* qteQToolBar_create(void* parent);
QTOOLBAR_API void  qteQToolBar_delete(void* w);
QTOOLBAR_API void* qteQToolBar_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QTOOLBAR_API void qteQToolBar_setMovable(void* _obj, int movable);
QTOOLBAR_API int qteQToolBar_isMovable(void* _obj);
QTOOLBAR_API void qteQToolBar_setAllowedAreas(void* _obj, int areas);
QTOOLBAR_API int qteQToolBar_allowedAreas(void* _obj);
QTOOLBAR_API void qteQToolBar_setOrientation(void* _obj, int orientation);
QTOOLBAR_API int qteQToolBar_orientation(void* _obj);
QTOOLBAR_API void qteQToolBar_clear(void* _obj);
QTOOLBAR_API void* qteQToolBar_addAction_s(void* _obj, void* text);
QTOOLBAR_API void* qteQToolBar_addAction_sp(void* _obj, void* text, int functor);
QTOOLBAR_API void* qteQToolBar_addAction_sop(void* _obj, void* text, void* context, int functor);
QTOOLBAR_API void* qteQToolBar_addSeparator(void* _obj);
QTOOLBAR_API void* qteQToolBar_insertSeparator(void* _obj, void* before);
QTOOLBAR_API void* qteQToolBar_addWidget(void* _obj, void* widget);
QTOOLBAR_API void* qteQToolBar_insertWidget(void* _obj, void* before, void* widget);
QTOOLBAR_API void* qteQToolBar_actionGeometry(void* _obj, void* action);
QTOOLBAR_API void* qteQToolBar_actionAt_p(void* _obj, void* p);
QTOOLBAR_API void* qteQToolBar_actionAt_ii(void* _obj, int x, int y);
QTOOLBAR_API void* qteQToolBar_toggleViewAction(void* _obj);
QTOOLBAR_API void* qteQToolBar_iconSize(void* _obj);
QTOOLBAR_API int qteQToolBar_toolButtonStyle(void* _obj);
QTOOLBAR_API void* qteQToolBar_widgetForAction(void* _obj, void* action);
QTOOLBAR_API int qteQToolBar_isFloatable(void* _obj);
QTOOLBAR_API void qteQToolBar_setFloatable(void* _obj, int floatable);
QTOOLBAR_API int qteQToolBar_isFloating(void* _obj);
QTOOLBAR_API void qteQToolBar_setIconSize(void* _obj, void* iconSize);
QTOOLBAR_API void qteQToolBar_setToolButtonStyle(void* _obj, int toolButtonStyle);

// ── Icon-based addAction ─────────────────────────────────────────────────────
QTOOLBAR_API void* qteQToolBar_addAction_is(void* _obj, void* icon, void* text);
QTOOLBAR_API void  qteQToolBar_addAction_p(void* _obj, void* action);

// ── Extra methods ─────────────────────────────────────────────────────────────
QTOOLBAR_API void qteQToolBar_iconSize_wh(void* obj, int* w, int* h);
QTOOLBAR_API int  qteQToolBar_isAreaAllowed(void* obj, int area);

// ── Signals ───────────────────────────────────────────────────────────────────
QTOOLBAR_API void qteQToolBar_connect_actionTriggered(void* obj, void (*cb)(void*, void*), void* ud);
QTOOLBAR_API void qteQToolBar_connect_iconSizeChanged(void* obj, void (*cb)(void*, int, int), void* ud);
QTOOLBAR_API void qteQToolBar_connect_orientationChanged(void* obj, void (*cb)(void*, int), void* ud);
QTOOLBAR_API void qteQToolBar_connect_visibilityChanged(void* obj, void (*cb)(void*, int), void* ud);
// ── List queries ─────────────────────────────────────────────────────────────
QTOOLBAR_API void* qteQToolBar_actions(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QTOOLBAR_API void qteQToolBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
