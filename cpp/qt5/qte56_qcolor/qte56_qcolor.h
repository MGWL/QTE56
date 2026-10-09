#pragma once

#ifdef _WIN32
  #ifdef QTE56_QCOLOR_BUILD
    #define QCOLOR_API __declspec(dllexport)
  #else
    #define QCOLOR_API __declspec(dllimport)
  #endif
#else
  #define QCOLOR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QCOLOR_API void* qteQColor_create(void* parent);
QCOLOR_API void  qteQColor_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QCOLOR_API int qteQColor_isValid(void* _obj);
QCOLOR_API void* qteQColor_name_v(void* _obj);
QCOLOR_API void* qteQColor_name_p(void* _obj, int format);
QCOLOR_API void qteQColor_setNamedColor(void* _obj, void* name);
QCOLOR_API int qteQColor_alpha(void* _obj);
QCOLOR_API void qteQColor_setAlpha(void* _obj, int alpha);
QCOLOR_API double qteQColor_alphaF(void* _obj);
QCOLOR_API void qteQColor_setAlphaF(void* _obj, double alpha);
QCOLOR_API int qteQColor_red(void* _obj);
QCOLOR_API int qteQColor_green(void* _obj);
QCOLOR_API int qteQColor_blue(void* _obj);
QCOLOR_API void qteQColor_setRed(void* _obj, int red);
QCOLOR_API void qteQColor_setGreen(void* _obj, int green);
QCOLOR_API void qteQColor_setBlue(void* _obj, int blue);
QCOLOR_API double qteQColor_redF(void* _obj);
QCOLOR_API double qteQColor_greenF(void* _obj);
QCOLOR_API double qteQColor_blueF(void* _obj);
QCOLOR_API void qteQColor_setRedF(void* _obj, double red);
QCOLOR_API void qteQColor_setGreenF(void* _obj, double green);
QCOLOR_API void qteQColor_setBlueF(void* _obj, double blue);
QCOLOR_API void qteQColor_getRgb(void* _obj, void* r, void* g, void* b, void* a);
QCOLOR_API void qteQColor_setRgb_iiii(void* _obj, int r, int g, int b, int a);
QCOLOR_API void qteQColor_setRgbF(void* _obj, double r, double g, double b, double a);
QCOLOR_API unsigned int qteQColor_rgba(void* _obj);
QCOLOR_API void qteQColor_setRgba(void* _obj, unsigned int rgba);
QCOLOR_API unsigned int qteQColor_rgb(void* _obj);
QCOLOR_API void qteQColor_setRgb_p(void* _obj, unsigned int rgb);
QCOLOR_API int qteQColor_hue(void* _obj);
QCOLOR_API int qteQColor_saturation(void* _obj);
QCOLOR_API int qteQColor_hsvHue(void* _obj);
QCOLOR_API int qteQColor_hsvSaturation(void* _obj);
QCOLOR_API int qteQColor_value(void* _obj);
QCOLOR_API double qteQColor_hueF(void* _obj);
QCOLOR_API double qteQColor_saturationF(void* _obj);
QCOLOR_API double qteQColor_hsvHueF(void* _obj);
QCOLOR_API double qteQColor_hsvSaturationF(void* _obj);
QCOLOR_API double qteQColor_valueF(void* _obj);
QCOLOR_API void qteQColor_getHsv(void* _obj, void* h, void* s, void* v, void* a);
QCOLOR_API void qteQColor_setHsv(void* _obj, int h, int s, int v, int a);
QCOLOR_API void qteQColor_setHsvF(void* _obj, double h, double s, double v, double a);
QCOLOR_API int qteQColor_cyan(void* _obj);
QCOLOR_API int qteQColor_magenta(void* _obj);
QCOLOR_API int qteQColor_yellow(void* _obj);
QCOLOR_API int qteQColor_black(void* _obj);
QCOLOR_API double qteQColor_cyanF(void* _obj);
QCOLOR_API double qteQColor_magentaF(void* _obj);
QCOLOR_API double qteQColor_yellowF(void* _obj);
QCOLOR_API double qteQColor_blackF(void* _obj);
QCOLOR_API void qteQColor_getCmyk_ppppp(void* _obj, void* c, void* m, void* y, void* k, void* a);
QCOLOR_API void qteQColor_setCmyk(void* _obj, int c, int m, int y, int k, int a);
QCOLOR_API void qteQColor_setCmykF(void* _obj, double c, double m, double y, double k, double a);
QCOLOR_API int qteQColor_hslHue(void* _obj);
QCOLOR_API int qteQColor_hslSaturation(void* _obj);
QCOLOR_API int qteQColor_lightness(void* _obj);
QCOLOR_API double qteQColor_hslHueF(void* _obj);
QCOLOR_API double qteQColor_hslSaturationF(void* _obj);
QCOLOR_API double qteQColor_lightnessF(void* _obj);
QCOLOR_API void qteQColor_getHsl(void* _obj, void* h, void* s, void* l, void* a);
QCOLOR_API void qteQColor_setHsl(void* _obj, int h, int s, int l, int a);
QCOLOR_API void qteQColor_setHslF(void* _obj, double h, double s, double l, double a);
QCOLOR_API void* qteQColor_toRgb(void* _obj);
QCOLOR_API void* qteQColor_toHsv(void* _obj);
QCOLOR_API void* qteQColor_toCmyk(void* _obj);
QCOLOR_API void* qteQColor_toHsl(void* _obj);
QCOLOR_API void* qteQColor_convertTo(void* _obj, int colorSpec);
QCOLOR_API void* qteQColor_fromRgb_p(void* _obj, unsigned int rgb);
QCOLOR_API void* qteQColor_fromRgba(void* _obj, unsigned int rgba);
QCOLOR_API void* qteQColor_fromRgb_iiii(void* _obj, int r, int g, int b, int a);
QCOLOR_API void* qteQColor_fromRgbF(void* _obj, double r, double g, double b, double a);
QCOLOR_API void* qteQColor_fromHsv(void* _obj, int h, int s, int v, int a);
QCOLOR_API void* qteQColor_fromHsvF(void* _obj, double h, double s, double v, double a);
QCOLOR_API void* qteQColor_fromCmyk(void* _obj, int c, int m, int y, int k, int a);
QCOLOR_API void* qteQColor_fromCmykF(void* _obj, double c, double m, double y, double k, double a);
QCOLOR_API void* qteQColor_fromHsl(void* _obj, int h, int s, int l, int a);
QCOLOR_API void* qteQColor_fromHslF(void* _obj, double h, double s, double l, double a);
QCOLOR_API void* qteQColor_light(void* _obj, int f);
QCOLOR_API void* qteQColor_dark(void* _obj, int f);
QCOLOR_API void* qteQColor_lighter(void* _obj, int f);
QCOLOR_API void* qteQColor_darker(void* _obj, int f);
QCOLOR_API int qteQColor_isValidColor(void* _obj, void* name);

} // extern "C"
