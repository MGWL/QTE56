#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSCROLLAREA_BUILD
    #define QSCROLLAREA_API __declspec(dllexport)
  #else
    #define QSCROLLAREA_API __declspec(dllimport)
  #endif
#else
  #define QSCROLLAREA_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSCROLLAREA_API void* qteQScrollArea_create(void* parent);
QSCROLLAREA_API void  qteQScrollArea_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSCROLLAREA_API void qteQScrollArea_show(void* _obj);
QSCROLLAREA_API void qteQScrollArea_hide(void* _obj);
QSCROLLAREA_API void qteQScrollArea_update(void* _obj);
QSCROLLAREA_API void* qteQScrollArea_widget(void* _obj);
QSCROLLAREA_API void qteQScrollArea_setWidget(void* _obj, void* widget);
QSCROLLAREA_API void* qteQScrollArea_takeWidget(void* _obj);
QSCROLLAREA_API int qteQScrollArea_widgetResizable(void* _obj);
QSCROLLAREA_API void qteQScrollArea_setWidgetResizable(void* _obj, int resizable);
QSCROLLAREA_API void* qteQScrollArea_sizeHint(void* _obj);
QSCROLLAREA_API int qteQScrollArea_focusNextPrevChild(void* _obj, int next);
QSCROLLAREA_API int qteQScrollArea_alignment(void* _obj);
QSCROLLAREA_API void qteQScrollArea_setAlignment(void* _obj, int p0);
QSCROLLAREA_API void qteQScrollArea_ensureVisible(void* _obj, int x, int y, int xmargin, int ymargin);
QSCROLLAREA_API void qteQScrollArea_ensureWidgetVisible(void* _obj, void* childWidget, int xmargin, int ymargin);

// ── Event handler ────────────────────────────────────────────────────────────
QSCROLLAREA_API void qteQScrollArea_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
