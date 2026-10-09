#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSLIDER_BUILD
    #define QSLIDER_API __declspec(dllexport)
  #else
    #define QSLIDER_API __declspec(dllimport)
  #endif
#else
  #define QSLIDER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSLIDER_API void* qteQSlider_create(void* parent);
QSLIDER_API void  qteQSlider_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSLIDER_API void qteQSlider_show(void* _obj);
QSLIDER_API void qteQSlider_hide(void* _obj);
QSLIDER_API void qteQSlider_update(void* _obj);
QSLIDER_API void* qteQSlider_sizeHint(void* _obj);
QSLIDER_API void* qteQSlider_minimumSizeHint(void* _obj);
QSLIDER_API void qteQSlider_setTickPosition(void* _obj, int position);
QSLIDER_API int qteQSlider_tickPosition(void* _obj);
QSLIDER_API void qteQSlider_setTickInterval(void* _obj, int ti);
QSLIDER_API int qteQSlider_tickInterval(void* _obj);
QSLIDER_API int qteQSlider_event(void* _obj, void* event);
QSLIDER_API int qteQSlider_orientation(void* _obj);
QSLIDER_API void qteQSlider_setMinimum(void* _obj, int p0);
QSLIDER_API int qteQSlider_minimum(void* _obj);
QSLIDER_API void qteQSlider_setMaximum(void* _obj, int p0);
QSLIDER_API int qteQSlider_maximum(void* _obj);
QSLIDER_API void qteQSlider_setSingleStep(void* _obj, int p0);
QSLIDER_API int qteQSlider_singleStep(void* _obj);
QSLIDER_API void qteQSlider_setPageStep(void* _obj, int p0);
QSLIDER_API int qteQSlider_pageStep(void* _obj);
QSLIDER_API void qteQSlider_setTracking(void* _obj, int enable);
QSLIDER_API int qteQSlider_hasTracking(void* _obj);
QSLIDER_API void qteQSlider_setSliderDown(void* _obj, int p0);
QSLIDER_API int qteQSlider_isSliderDown(void* _obj);
QSLIDER_API void qteQSlider_setSliderPosition(void* _obj, int p0);
QSLIDER_API int qteQSlider_sliderPosition(void* _obj);
QSLIDER_API void qteQSlider_setInvertedAppearance(void* _obj, int p0);
QSLIDER_API int qteQSlider_invertedAppearance(void* _obj);
QSLIDER_API void qteQSlider_setInvertedControls(void* _obj, int p0);
QSLIDER_API int qteQSlider_invertedControls(void* _obj);
QSLIDER_API int qteQSlider_value(void* _obj);
QSLIDER_API void qteQSlider_triggerAction(void* _obj, int action);
QSLIDER_API void qteQSlider_setValue(void* _obj, int p0);
QSLIDER_API void qteQSlider_setOrientation(void* _obj, int p0);
QSLIDER_API void qteQSlider_setRange(void* _obj, int min, int max);

// ── Event handler ────────────────────────────────────────────────────────────
QSLIDER_API void qteQSlider_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
