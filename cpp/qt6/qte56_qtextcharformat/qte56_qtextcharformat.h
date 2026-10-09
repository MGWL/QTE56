#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTCHARFORMAT_BUILD
    #define QTEXTCHARFORMAT_API __declspec(dllexport)
  #else
    #define QTEXTCHARFORMAT_API __declspec(dllimport)
  #endif
#else
  #define QTEXTCHARFORMAT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTCHARFORMAT_API void* qteQTextCharFormat_create(void* /*unused*/);
QTEXTCHARFORMAT_API void  qteQTextCharFormat_delete(void* fmt);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTCHARFORMAT_API int    qteQTextCharFormat_isValid(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontFamily(void* fmt, void* family);
QTEXTCHARFORMAT_API void*  qteQTextCharFormat_fontFamily(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontPointSize(void* fmt, double size);
QTEXTCHARFORMAT_API double qteQTextCharFormat_fontPointSize(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontWeight(void* fmt, int weight);
QTEXTCHARFORMAT_API int    qteQTextCharFormat_fontWeight(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontItalic(void* fmt, int italic);
QTEXTCHARFORMAT_API int    qteQTextCharFormat_fontItalic(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontUnderline(void* fmt, int underline);
QTEXTCHARFORMAT_API int    qteQTextCharFormat_fontUnderline(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontStrikeOut(void* fmt, int strikeOut);
QTEXTCHARFORMAT_API int    qteQTextCharFormat_fontStrikeOut(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFontOverline(void* fmt, int overline);
QTEXTCHARFORMAT_API int    qteQTextCharFormat_fontOverline(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setForeground(void* fmt, void* color);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setBackground(void* fmt, void* color);
QTEXTCHARFORMAT_API unsigned int qteQTextCharFormat_foreground(void* fmt);
QTEXTCHARFORMAT_API unsigned int qteQTextCharFormat_background(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setFont(void* fmt, void* font);
QTEXTCHARFORMAT_API void*  qteQTextCharFormat_font(void* fmt);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setUnderlineColor(void* fmt, void* color);
QTEXTCHARFORMAT_API void   qteQTextCharFormat_setUnderlineStyle(void* fmt, int style);

} // extern "C"
