#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSPINBOX_BUILD
    #define QSPINBOX_API __declspec(dllexport)
  #else
    #define QSPINBOX_API __declspec(dllimport)
  #endif
#else
  #define QSPINBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSPINBOX_API void* qteQSpinBox_create(void* parent);
QSPINBOX_API void  qteQSpinBox_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSPINBOX_API int qteQSpinBox_value(void* _obj);
QSPINBOX_API void* qteQSpinBox_prefix(void* _obj);
QSPINBOX_API void qteQSpinBox_setPrefix(void* _obj, void* prefix);
QSPINBOX_API void* qteQSpinBox_suffix(void* _obj);
QSPINBOX_API void qteQSpinBox_setSuffix(void* _obj, void* suffix);
QSPINBOX_API void* qteQSpinBox_cleanText(void* _obj);
QSPINBOX_API int qteQSpinBox_singleStep(void* _obj);
QSPINBOX_API void qteQSpinBox_setSingleStep(void* _obj, int val);
QSPINBOX_API int qteQSpinBox_minimum(void* _obj);
QSPINBOX_API void qteQSpinBox_setMinimum(void* _obj, int min);
QSPINBOX_API int qteQSpinBox_maximum(void* _obj);
QSPINBOX_API void qteQSpinBox_setMaximum(void* _obj, int max);
QSPINBOX_API void qteQSpinBox_setRange(void* _obj, int min, int max);
QSPINBOX_API int qteQSpinBox_stepType(void* _obj);
QSPINBOX_API void qteQSpinBox_setStepType(void* _obj, int stepType);
QSPINBOX_API int qteQSpinBox_displayIntegerBase(void* _obj);
QSPINBOX_API void qteQSpinBox_setDisplayIntegerBase(void* _obj, int base);
QSPINBOX_API void qteQSpinBox_setValue(void* _obj, int val);
QSPINBOX_API void* qteQSpinBox_text(void* _obj);
QSPINBOX_API int qteQSpinBox_wrapping(void* _obj);
QSPINBOX_API void qteQSpinBox_setFrame(void* _obj, int p0);
QSPINBOX_API int qteQSpinBox_hasFrame(void* _obj);
QSPINBOX_API void qteQSpinBox_setAccelerated(void* _obj, int on);
QSPINBOX_API int qteQSpinBox_isAccelerated(void* _obj);
QSPINBOX_API void qteQSpinBox_setGroupSeparatorShown(void* _obj, int shown);
QSPINBOX_API int qteQSpinBox_isGroupSeparatorShown(void* _obj);
QSPINBOX_API void qteQSpinBox_interpretText(void* _obj);
QSPINBOX_API void qteQSpinBox_stepBy(void* _obj, int steps);

// ── Event handler ────────────────────────────────────────────────────────────
QSPINBOX_API void qteQSpinBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
