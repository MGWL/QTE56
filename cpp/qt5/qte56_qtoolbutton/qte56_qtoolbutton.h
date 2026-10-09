#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTOOLBUTTON_BUILD
    #define QTOOLBUTTON_API __declspec(dllexport)
  #else
    #define QTOOLBUTTON_API __declspec(dllimport)
  #endif
#else
  #define QTOOLBUTTON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTOOLBUTTON_API void* qteQToolButton_create(void* parent);
QTOOLBUTTON_API void  qteQToolButton_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTOOLBUTTON_API int qteQToolButton_toolButtonStyle(void* _obj);
QTOOLBUTTON_API int qteQToolButton_arrowType(void* _obj);
QTOOLBUTTON_API void qteQToolButton_setArrowType(void* _obj, int type);
QTOOLBUTTON_API void qteQToolButton_setMenu(void* _obj, void* menu);
QTOOLBUTTON_API void* qteQToolButton_menu(void* _obj);
QTOOLBUTTON_API void qteQToolButton_setPopupMode(void* _obj, int mode);
QTOOLBUTTON_API int qteQToolButton_popupMode(void* _obj);
QTOOLBUTTON_API void* qteQToolButton_defaultAction(void* _obj);
QTOOLBUTTON_API void qteQToolButton_setAutoRaise(void* _obj, int enable);
QTOOLBUTTON_API int qteQToolButton_autoRaise(void* _obj);
QTOOLBUTTON_API void qteQToolButton_showMenu(void* _obj);
QTOOLBUTTON_API void qteQToolButton_setToolButtonStyle(void* _obj, int style);
QTOOLBUTTON_API void qteQToolButton_setDefaultAction(void* _obj, void* p0);

// ── Event handler ────────────────────────────────────────────────────────────
QTOOLBUTTON_API void qteQToolButton_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QTOOLBUTTON_API void qteQToolButton_connect_triggered(void* w, void* cb, void* dthis);

} // extern "C"
