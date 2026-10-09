#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSTACKEDWIDGET_BUILD
    #define QSTACKEDWIDGET_API __declspec(dllexport)
  #else
    #define QSTACKEDWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QSTACKEDWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSTACKEDWIDGET_API void* qteQStackedWidget_create(void* parent);
QSTACKEDWIDGET_API void  qteQStackedWidget_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSTACKEDWIDGET_API int qteQStackedWidget_addWidget(void* _obj, void* w);
QSTACKEDWIDGET_API int qteQStackedWidget_insertWidget(void* _obj, int index, void* w);
QSTACKEDWIDGET_API void qteQStackedWidget_removeWidget(void* _obj, void* w);
QSTACKEDWIDGET_API void* qteQStackedWidget_currentWidget(void* _obj);
QSTACKEDWIDGET_API int qteQStackedWidget_currentIndex(void* _obj);
QSTACKEDWIDGET_API int qteQStackedWidget_indexOf(void* _obj, void* p0);
QSTACKEDWIDGET_API void* qteQStackedWidget_widget(void* _obj, int p0);
QSTACKEDWIDGET_API int qteQStackedWidget_count(void* _obj);
QSTACKEDWIDGET_API void qteQStackedWidget_setCurrentIndex(void* _obj, int index);
QSTACKEDWIDGET_API void qteQStackedWidget_setCurrentWidget(void* _obj, void* w);

// ── Event handler ────────────────────────────────────────────────────────────
QSTACKEDWIDGET_API void qteQStackedWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
