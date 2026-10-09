#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPROGRESSBAR_BUILD
    #define QPROGRESSBAR_API __declspec(dllexport)
  #else
    #define QPROGRESSBAR_API __declspec(dllimport)
  #endif
#else
  #define QPROGRESSBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPROGRESSBAR_API void* qteQProgressBar_create(void* parent);
QPROGRESSBAR_API void  qteQProgressBar_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QPROGRESSBAR_API int qteQProgressBar_minimum(void* _obj);
QPROGRESSBAR_API int qteQProgressBar_maximum(void* _obj);
QPROGRESSBAR_API int qteQProgressBar_value(void* _obj);
QPROGRESSBAR_API void* qteQProgressBar_text(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setTextVisible(void* _obj, int visible);
QPROGRESSBAR_API int qteQProgressBar_isTextVisible(void* _obj);
QPROGRESSBAR_API int qteQProgressBar_alignment(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setAlignment(void* _obj, int alignment);
QPROGRESSBAR_API int qteQProgressBar_orientation(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setInvertedAppearance(void* _obj, int invert);
QPROGRESSBAR_API int qteQProgressBar_invertedAppearance(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setTextDirection(void* _obj, int textDirection);
QPROGRESSBAR_API int qteQProgressBar_textDirection(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setFormat(void* _obj, void* format);
QPROGRESSBAR_API void qteQProgressBar_resetFormat(void* _obj);
QPROGRESSBAR_API void* qteQProgressBar_format(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_reset(void* _obj);
QPROGRESSBAR_API void qteQProgressBar_setRange(void* _obj, int minimum, int maximum);
QPROGRESSBAR_API void qteQProgressBar_setMinimum(void* _obj, int minimum);
QPROGRESSBAR_API void qteQProgressBar_setMaximum(void* _obj, int maximum);
QPROGRESSBAR_API void qteQProgressBar_setValue(void* _obj, int value);
QPROGRESSBAR_API void qteQProgressBar_setOrientation(void* _obj, int p0);

// ── Event handler ────────────────────────────────────────────────────────────
QPROGRESSBAR_API void qteQProgressBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
