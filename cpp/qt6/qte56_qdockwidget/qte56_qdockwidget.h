#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDOCKWIDGET_BUILD
    #define QDOCKWIDGET_API __declspec(dllexport)
  #else
    #define QDOCKWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QDOCKWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QDOCKWIDGET_API void* qteQDockWidget_create(void* parent);
QDOCKWIDGET_API void  qteQDockWidget_delete(void* w);
QDOCKWIDGET_API void* qteQDockWidget_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QDOCKWIDGET_API void* qteQDockWidget_widget(void* _obj);
QDOCKWIDGET_API void qteQDockWidget_setWidget(void* _obj, void* widget);
QDOCKWIDGET_API void qteQDockWidget_setFeatures(void* _obj, int features);
QDOCKWIDGET_API int qteQDockWidget_features(void* _obj);
QDOCKWIDGET_API void qteQDockWidget_setFloating(void* _obj, int floating);
QDOCKWIDGET_API void qteQDockWidget_setAllowedAreas(void* _obj, int areas);
QDOCKWIDGET_API int qteQDockWidget_allowedAreas(void* _obj);
QDOCKWIDGET_API void qteQDockWidget_setTitleBarWidget(void* _obj, void* widget);
QDOCKWIDGET_API void* qteQDockWidget_titleBarWidget(void* _obj);
QDOCKWIDGET_API void* qteQDockWidget_toggleViewAction(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QDOCKWIDGET_API void qteQDockWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
