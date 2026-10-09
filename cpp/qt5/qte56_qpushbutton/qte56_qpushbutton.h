#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPUSHBUTTON_BUILD
    #define QPUSHBUTTON_API __declspec(dllexport)
  #else
    #define QPUSHBUTTON_API __declspec(dllimport)
  #endif
#else
  #define QPUSHBUTTON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPUSHBUTTON_API void* qteQPushButton_create(void* parent);
QPUSHBUTTON_API void  qteQPushButton_delete(void* w);
QPUSHBUTTON_API void* qteQPushButton_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QPUSHBUTTON_API void qteQPushButton_show(void* _obj);
QPUSHBUTTON_API void qteQPushButton_hide(void* _obj);
QPUSHBUTTON_API void qteQPushButton_update(void* _obj);
QPUSHBUTTON_API void* qteQPushButton_sizeHint(void* _obj);
QPUSHBUTTON_API void* qteQPushButton_minimumSizeHint(void* _obj);
QPUSHBUTTON_API int qteQPushButton_autoDefault(void* _obj);
QPUSHBUTTON_API void qteQPushButton_setAutoDefault(void* _obj, int p0);
QPUSHBUTTON_API int qteQPushButton_isDefault(void* _obj);
QPUSHBUTTON_API void qteQPushButton_setDefault(void* _obj, int p0);
QPUSHBUTTON_API void qteQPushButton_setMenu(void* _obj, void* menu);
QPUSHBUTTON_API void* qteQPushButton_menu(void* _obj);
QPUSHBUTTON_API void qteQPushButton_setFlat(void* _obj, int p0);
QPUSHBUTTON_API int qteQPushButton_isFlat(void* _obj);
QPUSHBUTTON_API void qteQPushButton_showMenu(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QPUSHBUTTON_API void qteQPushButton_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
