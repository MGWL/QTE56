#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTBLOCKFORMAT_BUILD
    #define QTEXTBLOCKFORMAT_API __declspec(dllexport)
  #else
    #define QTEXTBLOCKFORMAT_API __declspec(dllimport)
  #endif
#else
  #define QTEXTBLOCKFORMAT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTBLOCKFORMAT_API void* qteQTextBlockFormat_create(void* /*unused*/);
QTEXTBLOCKFORMAT_API void  qteQTextBlockFormat_delete(void* fmt);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTBLOCKFORMAT_API int    qteQTextBlockFormat_isValid(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setAlignment(void* fmt, int alignment);
QTEXTBLOCKFORMAT_API int    qteQTextBlockFormat_alignment(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setIndent(void* fmt, int indent);
QTEXTBLOCKFORMAT_API int    qteQTextBlockFormat_indent(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setTextIndent(void* fmt, double indent);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_textIndent(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setTopMargin(void* fmt, double margin);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_topMargin(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setBottomMargin(void* fmt, double margin);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_bottomMargin(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setLeftMargin(void* fmt, double margin);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_leftMargin(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setRightMargin(void* fmt, double margin);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_rightMargin(void* fmt);
QTEXTBLOCKFORMAT_API void   qteQTextBlockFormat_setLineHeight(void* fmt, double height, int heightType);
QTEXTBLOCKFORMAT_API double qteQTextBlockFormat_lineHeight(void* fmt);
QTEXTBLOCKFORMAT_API int    qteQTextBlockFormat_lineHeightType(void* fmt);

} // extern "C"
