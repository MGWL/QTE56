#pragma once

#ifdef _WIN32
  #ifdef QTE56_QCOLORDIALOG_BUILD
    #define QCOLORDIALOG_API __declspec(dllexport)
  #else
    #define QCOLORDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QCOLORDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QCOLORDIALOG_API void* qteQColorDialog_create(void* parent);
QCOLORDIALOG_API void  qteQColorDialog_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QCOLORDIALOG_API void qteQColorDialog_setCurrentColor(void* _obj, void* color);
QCOLORDIALOG_API void* qteQColorDialog_currentColor(void* _obj);
QCOLORDIALOG_API void* qteQColorDialog_selectedColor(void* _obj);
QCOLORDIALOG_API void qteQColorDialog_setOption(void* _obj, int option, int on);
QCOLORDIALOG_API int qteQColorDialog_testOption(void* _obj, int option);
QCOLORDIALOG_API void qteQColorDialog_setOptions(void* _obj, int options);
QCOLORDIALOG_API int qteQColorDialog_options(void* _obj);
QCOLORDIALOG_API void* qteQColorDialog_getColor(void* _obj, void* initial, void* parent, void* title, int options);
QCOLORDIALOG_API int qteQColorDialog_customCount(void* _obj);
QCOLORDIALOG_API void* qteQColorDialog_customColor(void* _obj, int index);
QCOLORDIALOG_API void qteQColorDialog_setCustomColor(void* _obj, int index, void* color);
QCOLORDIALOG_API void* qteQColorDialog_standardColor(void* _obj, int index);
QCOLORDIALOG_API void qteQColorDialog_setStandardColor(void* _obj, int index, void* color);

// ── Event handler ────────────────────────────────────────────────────────────
QCOLORDIALOG_API void qteQColorDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QCOLORDIALOG_API void qteQColorDialog_connect_currentColorChanged(void* w, void* cb, void* dthis);
QCOLORDIALOG_API void qteQColorDialog_connect_colorSelected(void* w, void* cb, void* dthis);

} // extern "C"
