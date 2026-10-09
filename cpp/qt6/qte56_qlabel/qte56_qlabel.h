#pragma once

#ifdef _WIN32
  #ifdef QTE56_QLABEL_BUILD
    #define QLABEL_API __declspec(dllexport)
  #else
    #define QLABEL_API __declspec(dllimport)
  #endif
#else
  #define QLABEL_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QLABEL_API void* qteQLabel_create(void* parent);
QLABEL_API void  qteQLabel_delete(void* w);
QLABEL_API void* qteQLabel_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QLABEL_API void* qteQLabel_text(void* _obj);
QLABEL_API void* qteQLabel_pixmap(void* _obj);
QLABEL_API void* qteQLabel_picture(void* _obj);
QLABEL_API void* qteQLabel_movie(void* _obj);
QLABEL_API int qteQLabel_textFormat(void* _obj);
QLABEL_API void qteQLabel_setTextFormat(void* _obj, int p0);
QLABEL_API int qteQLabel_alignment(void* _obj);
QLABEL_API void qteQLabel_setAlignment(void* _obj, int p0);
QLABEL_API void qteQLabel_setWordWrap(void* _obj, int on);
QLABEL_API int qteQLabel_wordWrap(void* _obj);
QLABEL_API int qteQLabel_indent(void* _obj);
QLABEL_API void qteQLabel_setIndent(void* _obj, int p0);
QLABEL_API int qteQLabel_margin(void* _obj);
QLABEL_API void qteQLabel_setMargin(void* _obj, int p0);
QLABEL_API int qteQLabel_hasScaledContents(void* _obj);
QLABEL_API void qteQLabel_setScaledContents(void* _obj, int p0);
QLABEL_API void qteQLabel_setBuddy(void* _obj, void* p0);
QLABEL_API void* qteQLabel_buddy(void* _obj);
QLABEL_API int qteQLabel_openExternalLinks(void* _obj);
QLABEL_API void qteQLabel_setOpenExternalLinks(void* _obj, int open);
QLABEL_API void qteQLabel_setTextInteractionFlags(void* _obj, int flags);
QLABEL_API int qteQLabel_textInteractionFlags(void* _obj);
QLABEL_API void qteQLabel_setSelection(void* _obj, int p0, int p1);
QLABEL_API int qteQLabel_hasSelectedText(void* _obj);
QLABEL_API void* qteQLabel_selectedText(void* _obj);
QLABEL_API int qteQLabel_selectionStart(void* _obj);
QLABEL_API void qteQLabel_setText(void* _obj, void* p0);
QLABEL_API void qteQLabel_setMovie(void* _obj, void* movie);
QLABEL_API void qteQLabel_setNum_i(void* _obj, int p0);
QLABEL_API void qteQLabel_setNum_d(void* _obj, double p0);
QLABEL_API void qteQLabel_clear(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QLABEL_API void qteQLabel_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
