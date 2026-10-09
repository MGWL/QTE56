#pragma once

#ifdef _WIN32
  #ifdef QTE56_QLABEL_BUILD
    #define QQLABEL_API __declspec(dllexport)
  #else
    #define QQLABEL_API __declspec(dllimport)
  #endif
#else
  #define QQLABEL_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QQLABEL_API void* qteQLabel_create(void* parent);
QQLABEL_API void  qteQLabel_delete(void* w);
QQLABEL_API void* qteQLabel_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QQLABEL_API void qteQLabel_show(void* w);
QQLABEL_API void qteQLabel_hide(void* w);
QQLABEL_API void qteQLabel_update(void* w);
QQLABEL_API void* qteQLabel_text(void* w);
QQLABEL_API void qteQLabel_setWordWrap(void* w, int on);
QQLABEL_API int qteQLabel_wordWrap(void* w);
QQLABEL_API int qteQLabel_indent(void* w);
QQLABEL_API void qteQLabel_setIndent(void* w, int p0);
QQLABEL_API int qteQLabel_margin(void* w);
QQLABEL_API void qteQLabel_setMargin(void* w, int p0);
QQLABEL_API int qteQLabel_hasScaledContents(void* w);
QQLABEL_API void qteQLabel_setScaledContents(void* w, int p0);
QQLABEL_API void* qteQLabel_sizeHint(void* w);
QQLABEL_API void* qteQLabel_minimumSizeHint(void* w);
QQLABEL_API void qteQLabel_setBuddy(void* w, void* p0);
QQLABEL_API int qteQLabel_heightForWidth(void* w, int p0);
QQLABEL_API int qteQLabel_openExternalLinks(void* w);
QQLABEL_API void qteQLabel_setOpenExternalLinks(void* w, int open);
QQLABEL_API void qteQLabel_setSelection(void* w, int p0, int p1);
QQLABEL_API int qteQLabel_hasSelectedText(void* w);
QQLABEL_API void* qteQLabel_selectedText(void* w);
QQLABEL_API int qteQLabel_selectionStart(void* w);
QQLABEL_API void qteQLabel_setText(void* w, void* p0);
QQLABEL_API void qteQLabel_setMovie(void* w, void* movie);
QQLABEL_API void qteQLabel_setNum_i(void* w, int p0);
QQLABEL_API void qteQLabel_setNum_d(void* w, double p0);
QQLABEL_API void qteQLabel_clear(void* w);

} // extern "C"
