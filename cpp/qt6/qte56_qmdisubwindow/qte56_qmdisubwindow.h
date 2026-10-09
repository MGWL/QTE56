#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMDISUBWINDOW_BUILD
    #define QMDISUBWINDOW_API __declspec(dllexport)
  #else
    #define QMDISUBWINDOW_API __declspec(dllimport)
  #endif
#else
  #define QMDISUBWINDOW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMDISUBWINDOW_API void* qteQMdiSubWindow_create(void* parent);
QMDISUBWINDOW_API void  qteQMdiSubWindow_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QMDISUBWINDOW_API void qteQMdiSubWindow_setWidget(void* _obj, void* widget);
QMDISUBWINDOW_API void* qteQMdiSubWindow_widget(void* _obj);
QMDISUBWINDOW_API void* qteQMdiSubWindow_maximizedButtonsWidget(void* _obj);
QMDISUBWINDOW_API void* qteQMdiSubWindow_maximizedSystemMenuIconWidget(void* _obj);
QMDISUBWINDOW_API int qteQMdiSubWindow_isShaded(void* _obj);
QMDISUBWINDOW_API void qteQMdiSubWindow_setOption(void* _obj, int option, int on);
QMDISUBWINDOW_API int qteQMdiSubWindow_testOption(void* _obj, int p0);
QMDISUBWINDOW_API void qteQMdiSubWindow_setKeyboardSingleStep(void* _obj, int step);
QMDISUBWINDOW_API int qteQMdiSubWindow_keyboardSingleStep(void* _obj);
QMDISUBWINDOW_API void qteQMdiSubWindow_setKeyboardPageStep(void* _obj, int step);
QMDISUBWINDOW_API int qteQMdiSubWindow_keyboardPageStep(void* _obj);
QMDISUBWINDOW_API void qteQMdiSubWindow_setSystemMenu(void* _obj, void* systemMenu);
QMDISUBWINDOW_API void* qteQMdiSubWindow_systemMenu(void* _obj);
QMDISUBWINDOW_API void* qteQMdiSubWindow_mdiArea(void* _obj);
QMDISUBWINDOW_API void qteQMdiSubWindow_showSystemMenu(void* _obj);
QMDISUBWINDOW_API void qteQMdiSubWindow_showShaded(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QMDISUBWINDOW_API void qteQMdiSubWindow_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
