#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSCROLLBAR_BUILD
    #define QSCROLLBAR_API __declspec(dllexport)
  #else
    #define QSCROLLBAR_API __declspec(dllimport)
  #endif
#else
  #define QSCROLLBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSCROLLBAR_API void* qteQScrollBar_create(void* parent);
QSCROLLBAR_API void  qteQScrollBar_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSCROLLBAR_API int qteQScrollBar_event(void* _obj, void* event);

// ── Event handler ────────────────────────────────────────────────────────────
QSCROLLBAR_API void qteQScrollBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
