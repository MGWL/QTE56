#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFONTDIALOG_BUILD
    #define QFONTDIALOG_API __declspec(dllexport)
  #else
    #define QFONTDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QFONTDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QFONTDIALOG_API void* qteQFontDialog_create(void* parent);
QFONTDIALOG_API void  qteQFontDialog_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QFONTDIALOG_API void qteQFontDialog_setCurrentFont(void* _obj, void* font);
QFONTDIALOG_API void* qteQFontDialog_currentFont(void* _obj);
QFONTDIALOG_API void* qteQFontDialog_selectedFont(void* _obj);
QFONTDIALOG_API void qteQFontDialog_setOption(void* _obj, int option, int on);
QFONTDIALOG_API int qteQFontDialog_testOption(void* _obj, int option);
QFONTDIALOG_API void qteQFontDialog_setOptions(void* _obj, int options);
QFONTDIALOG_API int qteQFontDialog_options(void* _obj);
QFONTDIALOG_API void* qteQFontDialog_getFont_pw(void* _obj, void* ok, void* parent);
QFONTDIALOG_API void* qteQFontDialog_getFont_ppwsp(void* _obj, void* ok, void* initial, void* parent, void* title, int options);

// ── Event handler ────────────────────────────────────────────────────────────
QFONTDIALOG_API void qteQFontDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QFONTDIALOG_API void qteQFontDialog_connect_currentFontChanged(void* w, void* cb, void* dthis);
QFONTDIALOG_API void qteQFontDialog_connect_fontSelected(void* w, void* cb, void* dthis);

} // extern "C"
