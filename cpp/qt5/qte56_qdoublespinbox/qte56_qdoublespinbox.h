#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDOUBLESPINBOX_BUILD
    #define QDOUBLESPINBOX_API __declspec(dllexport)
  #else
    #define QDOUBLESPINBOX_API __declspec(dllimport)
  #endif
#else
  #define QDOUBLESPINBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QDOUBLESPINBOX_API void* qteQDoubleSpinBox_create(void* parent);
QDOUBLESPINBOX_API void  qteQDoubleSpinBox_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QDOUBLESPINBOX_API double qteQDoubleSpinBox_value(void* _obj);
QDOUBLESPINBOX_API void* qteQDoubleSpinBox_prefix(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setPrefix(void* _obj, void* prefix);
QDOUBLESPINBOX_API void* qteQDoubleSpinBox_suffix(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setSuffix(void* _obj, void* suffix);
QDOUBLESPINBOX_API void* qteQDoubleSpinBox_cleanText(void* _obj);
QDOUBLESPINBOX_API double qteQDoubleSpinBox_singleStep(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setSingleStep(void* _obj, double val);
QDOUBLESPINBOX_API double qteQDoubleSpinBox_minimum(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setMinimum(void* _obj, double min);
QDOUBLESPINBOX_API double qteQDoubleSpinBox_maximum(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setMaximum(void* _obj, double max);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setRange(void* _obj, double min, double max);
QDOUBLESPINBOX_API int qteQDoubleSpinBox_stepType(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setStepType(void* _obj, int stepType);
QDOUBLESPINBOX_API int qteQDoubleSpinBox_decimals(void* _obj);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setDecimals(void* _obj, int prec);
QDOUBLESPINBOX_API double qteQDoubleSpinBox_valueFromText(void* _obj, void* text);
QDOUBLESPINBOX_API void* qteQDoubleSpinBox_textFromValue(void* _obj, double val);
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setValue(void* _obj, double val);

// ── Event handler ────────────────────────────────────────────────────────────
QDOUBLESPINBOX_API void qteQDoubleSpinBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
