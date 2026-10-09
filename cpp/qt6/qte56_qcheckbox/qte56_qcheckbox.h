#pragma once

#ifdef _WIN32
  #ifdef QTE56_QCHECKBOX_BUILD
    #define QCHECKBOX_API __declspec(dllexport)
  #else
    #define QCHECKBOX_API __declspec(dllimport)
  #endif
#else
  #define QCHECKBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QCHECKBOX_API void* qteQCheckBox_create(void* parent);
QCHECKBOX_API void  qteQCheckBox_delete(void* w);
QCHECKBOX_API void* qteQCheckBox_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QCHECKBOX_API void qteQCheckBox_show(void* _obj);
QCHECKBOX_API void qteQCheckBox_hide(void* _obj);
QCHECKBOX_API void qteQCheckBox_update(void* _obj);
QCHECKBOX_API void* qteQCheckBox_sizeHint(void* _obj);
QCHECKBOX_API void* qteQCheckBox_minimumSizeHint(void* _obj);
QCHECKBOX_API void qteQCheckBox_setTristate(void* _obj, int y);
QCHECKBOX_API int qteQCheckBox_isTristate(void* _obj);
QCHECKBOX_API int qteQCheckBox_checkState(void* _obj);
QCHECKBOX_API void qteQCheckBox_setCheckState(void* _obj, int state);

// ── Event handler ────────────────────────────────────────────────────────────
QCHECKBOX_API void qteQCheckBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
