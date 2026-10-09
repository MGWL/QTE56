#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFRAME_BUILD
    #define QFRAME_API __declspec(dllexport)
  #else
    #define QFRAME_API __declspec(dllimport)
  #endif
#else
  #define QFRAME_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QFRAME_API void* qteQFrame_create(void* parent);
QFRAME_API void  qteQFrame_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QFRAME_API int qteQFrame_frameStyle(void* _obj);
QFRAME_API void qteQFrame_setFrameStyle(void* _obj, int p0);
QFRAME_API int qteQFrame_frameWidth(void* _obj);
QFRAME_API int qteQFrame_frameShape(void* _obj);
QFRAME_API void qteQFrame_setFrameShape(void* _obj, int p0);
QFRAME_API int qteQFrame_frameShadow(void* _obj);
QFRAME_API void qteQFrame_setFrameShadow(void* _obj, int p0);
QFRAME_API int qteQFrame_lineWidth(void* _obj);
QFRAME_API void qteQFrame_setLineWidth(void* _obj, int p0);
QFRAME_API int qteQFrame_midLineWidth(void* _obj);
QFRAME_API void qteQFrame_setMidLineWidth(void* _obj, int p0);
QFRAME_API void* qteQFrame_frameRect(void* _obj);
QFRAME_API void qteQFrame_setFrameRect(void* _obj, void* p0);

// ── Event handler ────────────────────────────────────────────────────────────
QFRAME_API void qteQFrame_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
