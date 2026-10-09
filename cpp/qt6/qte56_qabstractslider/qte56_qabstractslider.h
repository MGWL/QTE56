#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTSLIDER_BUILD
    #define QABSTRACTSLIDER_API __declspec(dllexport)
  #else
    #define QABSTRACTSLIDER_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTSLIDER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTSLIDER_API void* qteQAbstractSlider_create(void* parent);
QABSTRACTSLIDER_API void  qteQAbstractSlider_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QABSTRACTSLIDER_API int qteQAbstractSlider_orientation(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setMinimum(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_minimum(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setMaximum(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_maximum(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setSingleStep(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_singleStep(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setPageStep(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_pageStep(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setTracking(void* _obj, int enable);
QABSTRACTSLIDER_API int qteQAbstractSlider_hasTracking(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setSliderDown(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_isSliderDown(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setSliderPosition(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_sliderPosition(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setInvertedAppearance(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_invertedAppearance(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_setInvertedControls(void* _obj, int p0);
QABSTRACTSLIDER_API int qteQAbstractSlider_invertedControls(void* _obj);
QABSTRACTSLIDER_API int qteQAbstractSlider_value(void* _obj);
QABSTRACTSLIDER_API void qteQAbstractSlider_triggerAction(void* _obj, int action);
QABSTRACTSLIDER_API void qteQAbstractSlider_setValue(void* _obj, int p0);
QABSTRACTSLIDER_API void qteQAbstractSlider_setOrientation(void* _obj, int p0);
QABSTRACTSLIDER_API void qteQAbstractSlider_setRange(void* _obj, int min, int max);

// ── Event handler ────────────────────────────────────────────────────────────
QABSTRACTSLIDER_API void qteQAbstractSlider_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
