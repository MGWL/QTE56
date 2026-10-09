#pragma once

#ifdef _WIN32
  #ifdef QTE56_QRADIOBUTTON_BUILD
    #define QRADIOBUTTON_API __declspec(dllexport)
  #else
    #define QRADIOBUTTON_API __declspec(dllimport)
  #endif
#else
  #define QRADIOBUTTON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QRADIOBUTTON_API void* qteQRadioButton_create(void* parent);
QRADIOBUTTON_API void  qteQRadioButton_delete(void* w);
QRADIOBUTTON_API void* qteQRadioButton_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QRADIOBUTTON_API void qteQRadioButton_show(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_hide(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_update(void* _obj);
QRADIOBUTTON_API void* qteQRadioButton_sizeHint(void* _obj);
QRADIOBUTTON_API void* qteQRadioButton_minimumSizeHint(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setText(void* _obj, void* text);
QRADIOBUTTON_API void* qteQRadioButton_text(void* _obj);
QRADIOBUTTON_API void* qteQRadioButton_iconSize(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setCheckable(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_isCheckable(void* _obj);
QRADIOBUTTON_API int qteQRadioButton_isChecked(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setDown(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_isDown(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setAutoRepeat(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_autoRepeat(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setAutoRepeatDelay(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_autoRepeatDelay(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setAutoRepeatInterval(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_autoRepeatInterval(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setAutoExclusive(void* _obj, int p0);
QRADIOBUTTON_API int qteQRadioButton_autoExclusive(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setIconSize(void* _obj, void* size);
QRADIOBUTTON_API void qteQRadioButton_animateClick(void* _obj, int msec);
QRADIOBUTTON_API void qteQRadioButton_click(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_toggle(void* _obj);
QRADIOBUTTON_API void qteQRadioButton_setChecked(void* _obj, int p0);

// ── Event handler ────────────────────────────────────────────────────────────
QRADIOBUTTON_API void qteQRadioButton_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
