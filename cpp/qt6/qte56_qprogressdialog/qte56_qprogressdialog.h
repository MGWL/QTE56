#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPROGRESSDIALOG_BUILD
    #define QPROGRESSDIALOG_API __declspec(dllexport)
  #else
    #define QPROGRESSDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QPROGRESSDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPROGRESSDIALOG_API void* qteQProgressDialog_create(void* parent);
QPROGRESSDIALOG_API void  qteQProgressDialog_delete(void* w);
QPROGRESSDIALOG_API void* qteQProgressDialog_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QPROGRESSDIALOG_API void qteQProgressDialog_setLabel(void* _obj, void* label);
QPROGRESSDIALOG_API void qteQProgressDialog_setCancelButton(void* _obj, void* button);
QPROGRESSDIALOG_API void qteQProgressDialog_setBar(void* _obj, void* bar);
QPROGRESSDIALOG_API int qteQProgressDialog_wasCanceled(void* _obj);
QPROGRESSDIALOG_API int qteQProgressDialog_minimum(void* _obj);
QPROGRESSDIALOG_API int qteQProgressDialog_maximum(void* _obj);
QPROGRESSDIALOG_API int qteQProgressDialog_value(void* _obj);
QPROGRESSDIALOG_API void* qteQProgressDialog_labelText(void* _obj);
QPROGRESSDIALOG_API int qteQProgressDialog_minimumDuration(void* _obj);
QPROGRESSDIALOG_API void qteQProgressDialog_setAutoReset(void* _obj, int reset);
QPROGRESSDIALOG_API int qteQProgressDialog_autoReset(void* _obj);
QPROGRESSDIALOG_API void qteQProgressDialog_setAutoClose(void* _obj, int close);
QPROGRESSDIALOG_API int qteQProgressDialog_autoClose(void* _obj);
QPROGRESSDIALOG_API void qteQProgressDialog_cancel(void* _obj);
QPROGRESSDIALOG_API void qteQProgressDialog_reset(void* _obj);
QPROGRESSDIALOG_API void qteQProgressDialog_setMaximum(void* _obj, int maximum);
QPROGRESSDIALOG_API void qteQProgressDialog_setMinimum(void* _obj, int minimum);
QPROGRESSDIALOG_API void qteQProgressDialog_setRange(void* _obj, int minimum, int maximum);
QPROGRESSDIALOG_API void qteQProgressDialog_setValue(void* _obj, int progress);
QPROGRESSDIALOG_API void qteQProgressDialog_setLabelText(void* _obj, void* text);
QPROGRESSDIALOG_API void qteQProgressDialog_setCancelButtonText(void* _obj, void* text);
QPROGRESSDIALOG_API void qteQProgressDialog_setMinimumDuration(void* _obj, int ms);

// ── Event handler ────────────────────────────────────────────────────────────
QPROGRESSDIALOG_API void qteQProgressDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
