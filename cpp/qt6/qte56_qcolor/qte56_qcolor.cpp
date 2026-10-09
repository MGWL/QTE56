#ifndef QTE56_QCOLOR_BUILD
#define QTE56_QCOLOR_BUILD
#endif
#include "qte56_qcolor.h"
#include <QColor>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQColor_create(void* /*unused*/) {
    return new QColor();  // value type, no parent
}

void qteQColor_delete(void* w) {
    delete (QColor*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQColor_isValid(void* _obj) {
    return ((QColor*)_obj)->isValid() ? 1 : 0;
}

void* qteQColor_name_v(void* _obj) {
    return new QString(((QColor*)_obj)->name());
}

void* qteQColor_name_p(void* _obj, int format) {
    return new QString(((QColor*)_obj)->name((QColor::NameFormat)format));
}

void qteQColor_setNamedColor(void* _obj, void* name) {
    ((QColor*)_obj)->setNamedColor(*(QString*)name);
}

int qteQColor_alpha(void* _obj) {
    return ((QColor*)_obj)->alpha();
}

void qteQColor_setAlpha(void* _obj, int alpha) {
    ((QColor*)_obj)->setAlpha(alpha);
}

double qteQColor_alphaF(void* _obj) {
    return ((QColor*)_obj)->alphaF();
}

void qteQColor_setAlphaF(void* _obj, double alpha) {
    ((QColor*)_obj)->setAlphaF(alpha);
}

int qteQColor_red(void* _obj) {
    return ((QColor*)_obj)->red();
}

int qteQColor_green(void* _obj) {
    return ((QColor*)_obj)->green();
}

int qteQColor_blue(void* _obj) {
    return ((QColor*)_obj)->blue();
}

void qteQColor_setRed(void* _obj, int red) {
    ((QColor*)_obj)->setRed(red);
}

void qteQColor_setGreen(void* _obj, int green) {
    ((QColor*)_obj)->setGreen(green);
}

void qteQColor_setBlue(void* _obj, int blue) {
    ((QColor*)_obj)->setBlue(blue);
}

double qteQColor_redF(void* _obj) {
    return ((QColor*)_obj)->redF();
}

double qteQColor_greenF(void* _obj) {
    return ((QColor*)_obj)->greenF();
}

double qteQColor_blueF(void* _obj) {
    return ((QColor*)_obj)->blueF();
}

void qteQColor_setRedF(void* _obj, double red) {
    ((QColor*)_obj)->setRedF(red);
}

void qteQColor_setGreenF(void* _obj, double green) {
    ((QColor*)_obj)->setGreenF(green);
}

void qteQColor_setBlueF(void* _obj, double blue) {
    ((QColor*)_obj)->setBlueF(blue);
}

void qteQColor_getRgb(void* _obj, void* r, void* g, void* b, void* a) {
    ((QColor*)_obj)->getRgb((int*)r, (int*)g, (int*)b, (int*)a);
}

void qteQColor_setRgb_iiii(void* _obj, int r, int g, int b, int a) {
    ((QColor*)_obj)->setRgb(r, g, b, a);
}

void qteQColor_setRgbF(void* _obj, double r, double g, double b, double a) {
    ((QColor*)_obj)->setRgbF(r, g, b, a);
}

unsigned int qteQColor_rgba(void* _obj) {
    return ((QColor*)_obj)->rgba();
}

void qteQColor_setRgba(void* _obj, unsigned int rgba) {
    ((QColor*)_obj)->setRgba((QRgb)rgba);
}

unsigned int qteQColor_rgb(void* _obj) {
    return ((QColor*)_obj)->rgb();
}

void qteQColor_setRgb_p(void* _obj, unsigned int rgb) {
    ((QColor*)_obj)->setRgb((QRgb)rgb);
}

int qteQColor_hue(void* _obj) {
    return ((QColor*)_obj)->hue();
}

int qteQColor_saturation(void* _obj) {
    return ((QColor*)_obj)->saturation();
}

int qteQColor_hsvHue(void* _obj) {
    return ((QColor*)_obj)->hsvHue();
}

int qteQColor_hsvSaturation(void* _obj) {
    return ((QColor*)_obj)->hsvSaturation();
}

int qteQColor_value(void* _obj) {
    return ((QColor*)_obj)->value();
}

double qteQColor_hueF(void* _obj) {
    return ((QColor*)_obj)->hueF();
}

double qteQColor_saturationF(void* _obj) {
    return ((QColor*)_obj)->saturationF();
}

double qteQColor_hsvHueF(void* _obj) {
    return ((QColor*)_obj)->hsvHueF();
}

double qteQColor_hsvSaturationF(void* _obj) {
    return ((QColor*)_obj)->hsvSaturationF();
}

double qteQColor_valueF(void* _obj) {
    return ((QColor*)_obj)->valueF();
}

void qteQColor_getHsv(void* _obj, void* h, void* s, void* v, void* a) {
    ((QColor*)_obj)->getHsv((int*)h, (int*)s, (int*)v, (int*)a);
}

void qteQColor_setHsv(void* _obj, int h, int s, int v, int a) {
    ((QColor*)_obj)->setHsv(h, s, v, a);
}

void qteQColor_setHsvF(void* _obj, double h, double s, double v, double a) {
    ((QColor*)_obj)->setHsvF(h, s, v, a);
}

int qteQColor_cyan(void* _obj) {
    return ((QColor*)_obj)->cyan();
}

int qteQColor_magenta(void* _obj) {
    return ((QColor*)_obj)->magenta();
}

int qteQColor_yellow(void* _obj) {
    return ((QColor*)_obj)->yellow();
}

int qteQColor_black(void* _obj) {
    return ((QColor*)_obj)->black();
}

double qteQColor_cyanF(void* _obj) {
    return ((QColor*)_obj)->cyanF();
}

double qteQColor_magentaF(void* _obj) {
    return ((QColor*)_obj)->magentaF();
}

double qteQColor_yellowF(void* _obj) {
    return ((QColor*)_obj)->yellowF();
}

double qteQColor_blackF(void* _obj) {
    return ((QColor*)_obj)->blackF();
}

void qteQColor_getCmyk_ppppp(void* _obj, void* c, void* m, void* y, void* k, void* a) {
    ((QColor*)_obj)->getCmyk((int*)c, (int*)m, (int*)y, (int*)k, (int*)a);
}

void qteQColor_setCmyk(void* _obj, int c, int m, int y, int k, int a) {
    ((QColor*)_obj)->setCmyk(c, m, y, k, a);
}

void qteQColor_setCmykF(void* _obj, double c, double m, double y, double k, double a) {
    ((QColor*)_obj)->setCmykF(c, m, y, k, a);
}

int qteQColor_hslHue(void* _obj) {
    return ((QColor*)_obj)->hslHue();
}

int qteQColor_hslSaturation(void* _obj) {
    return ((QColor*)_obj)->hslSaturation();
}

int qteQColor_lightness(void* _obj) {
    return ((QColor*)_obj)->lightness();
}

double qteQColor_hslHueF(void* _obj) {
    return ((QColor*)_obj)->hslHueF();
}

double qteQColor_hslSaturationF(void* _obj) {
    return ((QColor*)_obj)->hslSaturationF();
}

double qteQColor_lightnessF(void* _obj) {
    return ((QColor*)_obj)->lightnessF();
}

void qteQColor_getHsl(void* _obj, void* h, void* s, void* l, void* a) {
    ((QColor*)_obj)->getHsl((int*)h, (int*)s, (int*)l, (int*)a);
}

void qteQColor_setHsl(void* _obj, int h, int s, int l, int a) {
    ((QColor*)_obj)->setHsl(h, s, l, a);
}

void qteQColor_setHslF(void* _obj, double h, double s, double l, double a) {
    ((QColor*)_obj)->setHslF(h, s, l, a);
}

void* qteQColor_toRgb(void* _obj) {
    return new QColor(((QColor*)_obj)->toRgb());
}

void* qteQColor_toHsv(void* _obj) {
    return new QColor(((QColor*)_obj)->toHsv());
}

void* qteQColor_toCmyk(void* _obj) {
    return new QColor(((QColor*)_obj)->toCmyk());
}

void* qteQColor_toHsl(void* _obj) {
    return new QColor(((QColor*)_obj)->toHsl());
}

void* qteQColor_convertTo(void* _obj, int colorSpec) {
    return new QColor(((QColor*)_obj)->convertTo((QColor::Spec)colorSpec));
}

void* qteQColor_fromRgb_p(void* _obj, unsigned int rgb) {
    return new QColor(QColor::fromRgb((QRgb)rgb));
}

void* qteQColor_fromRgba(void* _obj, unsigned int rgba) {
    return new QColor(QColor::fromRgba((QRgb)rgba));
}

void* qteQColor_fromRgb_iiii(void* /*_obj*/, int r, int g, int b, int a) {
    return new QColor(QColor::fromRgb(r, g, b, a));
}

void* qteQColor_fromRgbF(void* /*_obj*/, double r, double g, double b, double a) {
    return new QColor(QColor::fromRgbF(r, g, b, a));
}

void* qteQColor_fromHsv(void* /*_obj*/, int h, int s, int v, int a) {
    return new QColor(QColor::fromHsv(h, s, v, a));
}

void* qteQColor_fromHsvF(void* /*_obj*/, double h, double s, double v, double a) {
    return new QColor(QColor::fromHsvF(h, s, v, a));
}

void* qteQColor_fromCmyk(void* /*_obj*/, int c, int m, int y, int k, int a) {
    return new QColor(QColor::fromCmyk(c, m, y, k, a));
}

void* qteQColor_fromCmykF(void* /*_obj*/, double c, double m, double y, double k, double a) {
    return new QColor(QColor::fromCmykF(c, m, y, k, a));
}

void* qteQColor_fromHsl(void* /*_obj*/, int h, int s, int l, int a) {
    return new QColor(QColor::fromHsl(h, s, l, a));
}

void* qteQColor_fromHslF(void* /*_obj*/, double h, double s, double l, double a) {
    return new QColor(QColor::fromHslF(h, s, l, a));
}

void* qteQColor_light(void* _obj, int f) {
    return new QColor(((QColor*)_obj)->lighter(f));
}

void* qteQColor_dark(void* _obj, int f) {
    return new QColor(((QColor*)_obj)->darker(f));
}

void* qteQColor_lighter(void* _obj, int f) {
    return new QColor(((QColor*)_obj)->lighter(f));
}

void* qteQColor_darker(void* _obj, int f) {
    return new QColor(((QColor*)_obj)->darker(f));
}

int qteQColor_isValidColor(void* _obj, void* name) {
    return ((QColor*)_obj)->isValidColor(*(QString*)name) ? 1 : 0;
}

} // extern "C"
