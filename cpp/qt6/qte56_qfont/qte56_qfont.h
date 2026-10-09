#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFONT_BUILD
    #define QFONT_API __declspec(dllexport)
  #else
    #define QFONT_API __declspec(dllimport)
  #endif
#else
  #define QFONT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QFONT_API void* qteQFont_create(void* parent);
QFONT_API void  qteQFont_delete(void* w);
QFONT_API void* qteQFont_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QFONT_API void* qteQFont_family(void* _obj);
QFONT_API void qteQFont_setFamily(void* _obj, void* p0);
QFONT_API void* qteQFont_styleName(void* _obj);
QFONT_API void qteQFont_setStyleName(void* _obj, void* p0);
QFONT_API int qteQFont_pointSize(void* _obj);
QFONT_API void qteQFont_setPointSize(void* _obj, int p0);
QFONT_API double qteQFont_pointSizeF(void* _obj);
QFONT_API void qteQFont_setPointSizeF(void* _obj, double p0);
QFONT_API int qteQFont_pixelSize(void* _obj);
QFONT_API void qteQFont_setPixelSize(void* _obj, int p0);
QFONT_API int qteQFont_weight(void* _obj);
QFONT_API void qteQFont_setWeight(void* _obj, int p0);
QFONT_API int qteQFont_bold(void* _obj);
QFONT_API void qteQFont_setBold(void* _obj, int p0);
QFONT_API void qteQFont_setStyle(void* _obj, int style);
QFONT_API int qteQFont_style(void* _obj);
QFONT_API int qteQFont_italic(void* _obj);
QFONT_API void qteQFont_setItalic(void* _obj, int b);
QFONT_API int qteQFont_underline(void* _obj);
QFONT_API void qteQFont_setUnderline(void* _obj, int p0);
QFONT_API int qteQFont_overline(void* _obj);
QFONT_API void qteQFont_setOverline(void* _obj, int p0);
QFONT_API int qteQFont_strikeOut(void* _obj);
QFONT_API void qteQFont_setStrikeOut(void* _obj, int p0);
QFONT_API int qteQFont_fixedPitch(void* _obj);
QFONT_API void qteQFont_setFixedPitch(void* _obj, int p0);
QFONT_API int qteQFont_kerning(void* _obj);
QFONT_API void qteQFont_setKerning(void* _obj, int p0);
QFONT_API int qteQFont_styleHint(void* _obj);
QFONT_API int qteQFont_styleStrategy(void* _obj);
QFONT_API void qteQFont_setStyleHint(void* _obj, int p0, int p1);
QFONT_API void qteQFont_setStyleStrategy(void* _obj, int s);
QFONT_API int qteQFont_stretch(void* _obj);
QFONT_API void qteQFont_setStretch(void* _obj, int p0);
QFONT_API double qteQFont_letterSpacing(void* _obj);
QFONT_API int qteQFont_letterSpacingType(void* _obj);
QFONT_API void qteQFont_setLetterSpacing(void* _obj, int type, double spacing);
QFONT_API double qteQFont_wordSpacing(void* _obj);
QFONT_API void qteQFont_setWordSpacing(void* _obj, double spacing);
QFONT_API void qteQFont_setCapitalization(void* _obj, int p0);
QFONT_API int qteQFont_capitalization(void* _obj);
QFONT_API void qteQFont_setHintingPreference(void* _obj, int hintingPreference);
QFONT_API int qteQFont_hintingPreference(void* _obj);
QFONT_API int qteQFont_rawMode(void* _obj);
QFONT_API void qteQFont_setRawMode(void* _obj, int p0);
QFONT_API int qteQFont_exactMatch(void* _obj);
QFONT_API void* qteQFont_key(void* _obj);
QFONT_API void* qteQFont_toString(void* _obj);
QFONT_API int qteQFont_fromString(void* _obj, void* p0);
QFONT_API void* qteQFont_substitute(void* _obj, void* p0);
QFONT_API void qteQFont_removeSubstitutions(void* _obj, void* p0);
QFONT_API void qteQFont_initialize(void* _obj);
QFONT_API void qteQFont_cleanup(void* _obj);
QFONT_API void qteQFont_cacheStatistics(void* _obj);
QFONT_API void* qteQFont_defaultFamily(void* _obj);

// ── Widget font helpers ───────────────────────────────────────────────────
QFONT_API void  qteQFont_setWidgetFont(void* widget, void* font);
QFONT_API void* qteQFont_getWidgetFont(void* widget);

} // extern "C"
