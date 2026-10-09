#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDIAL_BUILD
    #define QDIAL_API __declspec(dllexport)
  #else
    #define QDIAL_API __declspec(dllimport)
  #endif
#else
  #define QDIAL_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QDIAL_API void* qteQDial_create(void* parent);
QDIAL_API void  qteQDial_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QDIAL_API int qteQDial_wrapping(void* _obj);
QDIAL_API int qteQDial_notchSize(void* _obj);
QDIAL_API void qteQDial_setNotchTarget(void* _obj, double target);
QDIAL_API double qteQDial_notchTarget(void* _obj);
QDIAL_API int qteQDial_notchesVisible(void* _obj);
QDIAL_API void qteQDial_setNotchesVisible(void* _obj, int visible);
QDIAL_API void qteQDial_setWrapping(void* _obj, int on);

} // extern "C"
