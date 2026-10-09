#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTSPINBOX_BUILD
    #define QABSTRACTSPINBOX_API __declspec(dllexport)
  #else
    #define QABSTRACTSPINBOX_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTSPINBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTSPINBOX_API void* qteQAbstractSpinBox_create(void* parent);
QABSTRACTSPINBOX_API void  qteQAbstractSpinBox_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_buttonSymbols(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setButtonSymbols(void* _obj, int bs);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setCorrectionMode(void* _obj, int cm);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_correctionMode(void* _obj);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_hasAcceptableInput(void* _obj);
QABSTRACTSPINBOX_API void* qteQAbstractSpinBox_text(void* _obj);
QABSTRACTSPINBOX_API void* qteQAbstractSpinBox_specialValueText(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setSpecialValueText(void* _obj, void* txt);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_wrapping(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setWrapping(void* _obj, int w);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setReadOnly(void* _obj, int r);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_isReadOnly(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setKeyboardTracking(void* _obj, int kt);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_keyboardTracking(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setAlignment(void* _obj, int flag);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_alignment(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setFrame(void* _obj, int p0);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_hasFrame(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setAccelerated(void* _obj, int on);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_isAccelerated(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setGroupSeparatorShown(void* _obj, int shown);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_isGroupSeparatorShown(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_interpretText(void* _obj);
QABSTRACTSPINBOX_API int qteQAbstractSpinBox_event(void* _obj, void* event);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_fixup(void* _obj, void* input);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_stepBy(void* _obj, int steps);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_stepUp(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_stepDown(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_selectAll(void* _obj);
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_clear(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QABSTRACTSPINBOX_API void qteQAbstractSpinBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
