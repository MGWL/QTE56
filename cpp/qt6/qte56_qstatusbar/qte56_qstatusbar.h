#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSTATUSBAR_BUILD
    #define QSTATUSBAR_API __declspec(dllexport)
  #else
    #define QSTATUSBAR_API __declspec(dllimport)
  #endif
#else
  #define QSTATUSBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSTATUSBAR_API void* qteQStatusBar_create(void* parent);
QSTATUSBAR_API void  qteQStatusBar_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSTATUSBAR_API void qteQStatusBar_addWidget(void* _obj, void* widget, int stretch);
QSTATUSBAR_API int qteQStatusBar_insertWidget(void* _obj, int index, void* widget, int stretch);
QSTATUSBAR_API void qteQStatusBar_addPermanentWidget(void* _obj, void* widget, int stretch);
QSTATUSBAR_API int qteQStatusBar_insertPermanentWidget(void* _obj, int index, void* widget, int stretch);
QSTATUSBAR_API void qteQStatusBar_removeWidget(void* _obj, void* widget);
QSTATUSBAR_API void qteQStatusBar_setSizeGripEnabled(void* _obj, int p0);
QSTATUSBAR_API int qteQStatusBar_isSizeGripEnabled(void* _obj);
QSTATUSBAR_API void* qteQStatusBar_currentMessage(void* _obj);
QSTATUSBAR_API void qteQStatusBar_showMessage(void* _obj, void* text, int timeout);
QSTATUSBAR_API void qteQStatusBar_clearMessage(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QSTATUSBAR_API void qteQStatusBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
