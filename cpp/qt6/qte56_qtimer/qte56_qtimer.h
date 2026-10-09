#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTIMER_BUILD
    #define QTIMER_API __declspec(dllexport)
  #else
    #define QTIMER_API __declspec(dllimport)
  #endif
#else
  #define QTIMER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTIMER_API void* qteQTimer_create(void* parent);
QTIMER_API void  qteQTimer_delete(void* w);

// ── Properties ───────────────────────────────────────────────────────────
QTIMER_API int  qteQTimer_interval(void* _obj);
QTIMER_API int  qteQTimer_isSingleShot(void* _obj);
QTIMER_API void qteQTimer_setInterval(void* _obj, int msec);
QTIMER_API void qteQTimer_setSingleShot(void* _obj, int singleShot);
QTIMER_API int  qteQTimer_remainingTime(void* _obj);
QTIMER_API int  qteQTimer_isActive(void* _obj);
QTIMER_API int  qteQTimer_timerId(void* _obj);

// ── Slots ────────────────────────────────────────────────────────────────
QTIMER_API void qteQTimer_start_i(void* _obj, int msec);
QTIMER_API void qteQTimer_start_v(void* _obj);
QTIMER_API void qteQTimer_stop(void* _obj);

} // extern "C"
