#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTBUTTON_BUILD
    #define QABSTRACTBUTTON_API __declspec(dllexport)
  #else
    #define QABSTRACTBUTTON_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTBUTTON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTBUTTON_API void* qteQAbstractButton_create(void* parent);
QABSTRACTBUTTON_API void  qteQAbstractButton_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QABSTRACTBUTTON_API void qteQAbstractButton_setText(void* _obj, void* text);
QABSTRACTBUTTON_API void* qteQAbstractButton_text(void* _obj);
QABSTRACTBUTTON_API void* qteQAbstractButton_iconSize(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setCheckable(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_isCheckable(void* _obj);
QABSTRACTBUTTON_API int qteQAbstractButton_isChecked(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setDown(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_isDown(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setAutoRepeat(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_autoRepeat(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setAutoRepeatDelay(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_autoRepeatDelay(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setAutoRepeatInterval(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_autoRepeatInterval(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setAutoExclusive(void* _obj, int p0);
QABSTRACTBUTTON_API int qteQAbstractButton_autoExclusive(void* _obj);
QABSTRACTBUTTON_API void* qteQAbstractButton_group(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setIconSize(void* _obj, void* size);
QABSTRACTBUTTON_API void qteQAbstractButton_animateClick(void* _obj, int msec);
QABSTRACTBUTTON_API void qteQAbstractButton_click(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_toggle(void* _obj);
QABSTRACTBUTTON_API void qteQAbstractButton_setChecked(void* _obj, int p0);

// ── Icon ─────────────────────────────────────────────────────────────────────
QABSTRACTBUTTON_API void  qteQAbstractButton_setIcon(void* _obj, void* icon);
QABSTRACTBUTTON_API void* qteQAbstractButton_icon(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QABSTRACTBUTTON_API void qteQAbstractButton_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
