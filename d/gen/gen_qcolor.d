/**
 * gen_qcolor.d — GENERATED wrapper for QColor.
 * Module: QColor  |  DLL: qte56_foundation.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qcolor;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_qp, toQString;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("qp__qp_d_d_d_d"));
mixin(generateAlias("qp__qp_d_d_d_d_d"));
mixin(generateAlias("qp__qp_i_i_i_i"));
mixin(generateAlias("qp__qp_i_i_i_i_i"));
mixin(generateAlias("qp__qp_ui"));
mixin(generateAlias("ui__qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d_d_d"));
mixin(generateAlias("v__qp_d_d_d_d_d"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp_qp"));
mixin(generateAlias("v__qp_ui"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQColor() {
    mixin(generateFunQt(14000, "qteQColor_create", "QColor"));
    mixin(generateFunQt(14001, "qteQColor_delete", "QColor"));
    mixin(generateFunQt(14002, "qteQColor_isValid", "QColor"));
    mixin(generateFunQt(14003, "qteQColor_name_v", "QColor"));
    mixin(generateFunQt(14004, "qteQColor_name_p", "QColor"));
    mixin(generateFunQt(14005, "qteQColor_setNamedColor", "QColor"));
    mixin(generateFunQt(14006, "qteQColor_alpha", "QColor"));
    mixin(generateFunQt(14007, "qteQColor_setAlpha", "QColor"));
    mixin(generateFunQt(14008, "qteQColor_alphaF", "QColor"));
    mixin(generateFunQt(14009, "qteQColor_setAlphaF", "QColor"));
    mixin(generateFunQt(14010, "qteQColor_red", "QColor"));
    mixin(generateFunQt(14011, "qteQColor_green", "QColor"));
    mixin(generateFunQt(14012, "qteQColor_blue", "QColor"));
    mixin(generateFunQt(14013, "qteQColor_setRed", "QColor"));
    mixin(generateFunQt(14014, "qteQColor_setGreen", "QColor"));
    mixin(generateFunQt(14015, "qteQColor_setBlue", "QColor"));
    mixin(generateFunQt(14016, "qteQColor_redF", "QColor"));
    mixin(generateFunQt(14017, "qteQColor_greenF", "QColor"));
    mixin(generateFunQt(14018, "qteQColor_blueF", "QColor"));
    mixin(generateFunQt(14019, "qteQColor_setRedF", "QColor"));
    mixin(generateFunQt(14020, "qteQColor_setGreenF", "QColor"));
    mixin(generateFunQt(14021, "qteQColor_setBlueF", "QColor"));
    mixin(generateFunQt(14022, "qteQColor_getRgb", "QColor"));
    mixin(generateFunQt(14023, "qteQColor_setRgb_iiii", "QColor"));
    mixin(generateFunQt(14024, "qteQColor_setRgbF", "QColor"));
    mixin(generateFunQt(14025, "qteQColor_rgba", "QColor"));
    mixin(generateFunQt(14026, "qteQColor_setRgba", "QColor"));
    mixin(generateFunQt(14027, "qteQColor_rgb", "QColor"));
    mixin(generateFunQt(14028, "qteQColor_setRgb_p", "QColor"));
    mixin(generateFunQt(14029, "qteQColor_hue", "QColor"));
    mixin(generateFunQt(14030, "qteQColor_saturation", "QColor"));
    mixin(generateFunQt(14031, "qteQColor_hsvHue", "QColor"));
    mixin(generateFunQt(14032, "qteQColor_hsvSaturation", "QColor"));
    mixin(generateFunQt(14033, "qteQColor_value", "QColor"));
    mixin(generateFunQt(14034, "qteQColor_hueF", "QColor"));
    mixin(generateFunQt(14035, "qteQColor_saturationF", "QColor"));
    mixin(generateFunQt(14036, "qteQColor_hsvHueF", "QColor"));
    mixin(generateFunQt(14037, "qteQColor_hsvSaturationF", "QColor"));
    mixin(generateFunQt(14038, "qteQColor_valueF", "QColor"));
    mixin(generateFunQt(14039, "qteQColor_getHsv", "QColor"));
    mixin(generateFunQt(14040, "qteQColor_setHsv", "QColor"));
    mixin(generateFunQt(14041, "qteQColor_setHsvF", "QColor"));
    mixin(generateFunQt(14042, "qteQColor_cyan", "QColor"));
    mixin(generateFunQt(14043, "qteQColor_magenta", "QColor"));
    mixin(generateFunQt(14044, "qteQColor_yellow", "QColor"));
    mixin(generateFunQt(14045, "qteQColor_black", "QColor"));
    mixin(generateFunQt(14046, "qteQColor_cyanF", "QColor"));
    mixin(generateFunQt(14047, "qteQColor_magentaF", "QColor"));
    mixin(generateFunQt(14048, "qteQColor_yellowF", "QColor"));
    mixin(generateFunQt(14049, "qteQColor_blackF", "QColor"));
    mixin(generateFunQt(14050, "qteQColor_getCmyk_ppppp", "QColor"));
    mixin(generateFunQt(14051, "qteQColor_setCmyk", "QColor"));
    mixin(generateFunQt(14052, "qteQColor_setCmykF", "QColor"));
    mixin(generateFunQt(14053, "qteQColor_hslHue", "QColor"));
    mixin(generateFunQt(14054, "qteQColor_hslSaturation", "QColor"));
    mixin(generateFunQt(14055, "qteQColor_lightness", "QColor"));
    mixin(generateFunQt(14056, "qteQColor_hslHueF", "QColor"));
    mixin(generateFunQt(14057, "qteQColor_hslSaturationF", "QColor"));
    mixin(generateFunQt(14058, "qteQColor_lightnessF", "QColor"));
    mixin(generateFunQt(14059, "qteQColor_getHsl", "QColor"));
    mixin(generateFunQt(14060, "qteQColor_setHsl", "QColor"));
    mixin(generateFunQt(14061, "qteQColor_setHslF", "QColor"));
    mixin(generateFunQt(14062, "qteQColor_toRgb", "QColor"));
    mixin(generateFunQt(14063, "qteQColor_toHsv", "QColor"));
    mixin(generateFunQt(14064, "qteQColor_toCmyk", "QColor"));
    mixin(generateFunQt(14065, "qteQColor_toHsl", "QColor"));
    mixin(generateFunQt(14066, "qteQColor_convertTo", "QColor"));
    mixin(generateFunQt(14067, "qteQColor_fromRgb_p", "QColor"));
    mixin(generateFunQt(14068, "qteQColor_fromRgba", "QColor"));
    mixin(generateFunQt(14069, "qteQColor_fromRgb_iiii", "QColor"));
    mixin(generateFunQt(14070, "qteQColor_fromRgbF", "QColor"));
    mixin(generateFunQt(14071, "qteQColor_fromHsv", "QColor"));
    mixin(generateFunQt(14072, "qteQColor_fromHsvF", "QColor"));
    mixin(generateFunQt(14073, "qteQColor_fromCmyk", "QColor"));
    mixin(generateFunQt(14074, "qteQColor_fromCmykF", "QColor"));
    mixin(generateFunQt(14075, "qteQColor_fromHsl", "QColor"));
    mixin(generateFunQt(14076, "qteQColor_fromHslF", "QColor"));
    mixin(generateFunQt(14077, "qteQColor_light", "QColor"));
    mixin(generateFunQt(14078, "qteQColor_dark", "QColor"));
    mixin(generateFunQt(14079, "qteQColor_lighter", "QColor"));
    mixin(generateFunQt(14080, "qteQColor_darker", "QColor"));
    mixin(generateFunQt(14081, "qteQColor_isValidColor", "QColor"));
}

static this() {
    registerModule("QColor", "qte56_foundation.dll", &loadQColor);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QColor (value type).
@live class QColor {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Default-constructed QColor (invalid color).
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[14000])(null);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[14001] !is null) {
            (cast(t_v__qp)pFunQt[14001])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated C++ QColor* — D takes ownership, deletes on ~this.
    static QColor wrap(void* ptr) {
        if (ptr is null) return null;
        auto c = new QColor(false);
        c._wh = ptr;
        return c;
    }

    // ── Validity / name ──────────────────────────────────────────────

    /// isValid
    bool isValid() {
        return cast(bool)(cast(t_i__qp)pFunQt[14002])(_wh);
    }

    /// name — hex string like "#rrggbb"
    string name() {
        void* _qs = (cast(t_qp__qp)pFunQt[14003])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// name — with format (QColor::HexRgb=0, QColor::HexArgb=1)
    string name(int format) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[14004])(_wh, format);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setNamedColor — e.g. "#rrggbb", "red", "transparent"
    QColor setNamedColor(string name) {
        auto _ws_name = toQString(name);
        (cast(t_v__qp_qp)pFunQt[14005])(_wh, _ws_name);
        (cast(t_v__qp)pFunQt[22])(_ws_name);
        return this;
    }

    // ── Alpha ────────────────────────────────────────────────────────

    /// alpha (0–255)
    int alpha() { return cast(int)(cast(t_i__qp)pFunQt[14006])(_wh); }

    /// setAlpha
    QColor setAlpha(int alpha) { (cast(t_v__qp_i)pFunQt[14007])(_wh, alpha); return this; }

    /// alphaF (0.0–1.0)
    double alphaF() { return cast(double)(cast(t_d__qp)pFunQt[14008])(_wh); }

    /// setAlphaF
    QColor setAlphaF(double alpha) { (cast(t_v__qp_d)pFunQt[14009])(_wh, alpha); return this; }

    // ── RGB integer components ────────────────────────────────────────

    /// red (0–255)
    int red()   { return cast(int)(cast(t_i__qp)pFunQt[14010])(_wh); }

    /// green (0–255)
    int green() { return cast(int)(cast(t_i__qp)pFunQt[14011])(_wh); }

    /// blue (0–255)
    int blue()  { return cast(int)(cast(t_i__qp)pFunQt[14012])(_wh); }

    /// setRed
    QColor setRed(int red)     { (cast(t_v__qp_i)pFunQt[14013])(_wh, red); return this; }

    /// setGreen
    QColor setGreen(int green) { (cast(t_v__qp_i)pFunQt[14014])(_wh, green); return this; }

    /// setBlue
    QColor setBlue(int blue)   { (cast(t_v__qp_i)pFunQt[14015])(_wh, blue); return this; }

    // ── RGB float components ──────────────────────────────────────────

    /// redF (0.0–1.0)
    double redF()   { return cast(double)(cast(t_d__qp)pFunQt[14016])(_wh); }

    /// greenF
    double greenF() { return cast(double)(cast(t_d__qp)pFunQt[14017])(_wh); }

    /// blueF
    double blueF()  { return cast(double)(cast(t_d__qp)pFunQt[14018])(_wh); }

    /// setRedF
    QColor setRedF(double red)     { (cast(t_v__qp_d)pFunQt[14019])(_wh, red); return this; }

    /// setGreenF
    QColor setGreenF(double green) { (cast(t_v__qp_d)pFunQt[14020])(_wh, green); return this; }

    /// setBlueF
    QColor setBlueF(double blue)   { (cast(t_v__qp_d)pFunQt[14021])(_wh, blue); return this; }

    // ── RGB packed ────────────────────────────────────────────────────

    /// getRgb — fills r,g,b,a via int* pointers
    QColor getRgb(void* r, void* g, void* b, void* a) {
        (cast(t_v__qp_qp_qp_qp_qp)pFunQt[14022])(_wh, r, g, b, a);
        return this;
    }

    /// setRgb — RGBA integer components (0–255)
    QColor setRgb(int r, int g, int b, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[14023])(_wh, r, g, b, a);
        return this;
    }

    /// setRgbF — RGBA float components (0.0–1.0)
    QColor setRgbF(double r, double g, double b, double a = 1.0) {
        (cast(t_v__qp_d_d_d_d)pFunQt[14024])(_wh, r, g, b, a);
        return this;
    }

    /// rgba — packed 0xAARRGGBB
    uint rgba() { return cast(uint)(cast(t_ui__qp)pFunQt[14025])(_wh); }

    /// setRgba — packed 0xAARRGGBB
    QColor setRgba(uint rgba) { (cast(t_v__qp_ui)pFunQt[14026])(_wh, rgba); return this; }

    /// rgb — packed 0xffRRGGBB (alpha forced to 0xff)
    uint rgb() { return cast(uint)(cast(t_ui__qp)pFunQt[14027])(_wh); }

    /// setRgb — packed 0xffRRGGBB
    QColor setRgb(uint rgb) { (cast(t_v__qp_ui)pFunQt[14028])(_wh, rgb); return this; }

    // ── HSV ───────────────────────────────────────────────────────────

    /// hue (HSV, -1 for achromatic)
    int hue()           { return cast(int)(cast(t_i__qp)pFunQt[14029])(_wh); }

    /// saturation (HSV, 0–255)
    int saturation()    { return cast(int)(cast(t_i__qp)pFunQt[14030])(_wh); }

    /// hsvHue
    int hsvHue()        { return cast(int)(cast(t_i__qp)pFunQt[14031])(_wh); }

    /// hsvSaturation
    int hsvSaturation() { return cast(int)(cast(t_i__qp)pFunQt[14032])(_wh); }

    /// value (HSV, 0–255)
    int value()         { return cast(int)(cast(t_i__qp)pFunQt[14033])(_wh); }

    /// hueF (HSV)
    double hueF()           { return cast(double)(cast(t_d__qp)pFunQt[14034])(_wh); }

    /// saturationF (HSV)
    double saturationF()    { return cast(double)(cast(t_d__qp)pFunQt[14035])(_wh); }

    /// hsvHueF
    double hsvHueF()        { return cast(double)(cast(t_d__qp)pFunQt[14036])(_wh); }

    /// hsvSaturationF
    double hsvSaturationF() { return cast(double)(cast(t_d__qp)pFunQt[14037])(_wh); }

    /// valueF (HSV)
    double valueF()         { return cast(double)(cast(t_d__qp)pFunQt[14038])(_wh); }

    /// getHsv — fills h,s,v,a via int* pointers
    QColor getHsv(void* h, void* s, void* v, void* a) {
        (cast(t_v__qp_qp_qp_qp_qp)pFunQt[14039])(_wh, h, s, v, a);
        return this;
    }

    /// setHsv
    QColor setHsv(int h, int s, int v, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[14040])(_wh, h, s, v, a);
        return this;
    }

    /// setHsvF
    QColor setHsvF(double h, double s, double v, double a = 1.0) {
        (cast(t_v__qp_d_d_d_d)pFunQt[14041])(_wh, h, s, v, a);
        return this;
    }

    // ── CMYK ──────────────────────────────────────────────────────────

    /// cyan (CMYK, 0–255)
    int cyan()    { return cast(int)(cast(t_i__qp)pFunQt[14042])(_wh); }

    /// magenta (CMYK)
    int magenta() { return cast(int)(cast(t_i__qp)pFunQt[14043])(_wh); }

    /// yellow (CMYK)
    int yellow()  { return cast(int)(cast(t_i__qp)pFunQt[14044])(_wh); }

    /// black (CMYK)
    int black()   { return cast(int)(cast(t_i__qp)pFunQt[14045])(_wh); }

    /// cyanF (CMYK, 0.0–1.0)
    double cyanF()    { return cast(double)(cast(t_d__qp)pFunQt[14046])(_wh); }

    /// magentaF
    double magentaF() { return cast(double)(cast(t_d__qp)pFunQt[14047])(_wh); }

    /// yellowF
    double yellowF()  { return cast(double)(cast(t_d__qp)pFunQt[14048])(_wh); }

    /// blackF
    double blackF()   { return cast(double)(cast(t_d__qp)pFunQt[14049])(_wh); }

    /// getCmyk — fills c,m,y,k,a via int* pointers
    QColor getCmyk(void* c, void* m, void* y, void* k, void* a) {
        (cast(t_v__qp_qp_qp_qp_qp_qp)pFunQt[14050])(_wh, c, m, y, k, a);
        return this;
    }

    /// setCmyk
    QColor setCmyk(int c, int m, int y, int k, int a = 255) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[14051])(_wh, c, m, y, k, a);
        return this;
    }

    /// setCmykF
    QColor setCmykF(double c, double m, double y, double k, double a = 1.0) {
        (cast(t_v__qp_d_d_d_d_d)pFunQt[14052])(_wh, c, m, y, k, a);
        return this;
    }

    // ── HSL ───────────────────────────────────────────────────────────

    /// hslHue (HSL)
    int hslHue()        { return cast(int)(cast(t_i__qp)pFunQt[14053])(_wh); }

    /// hslSaturation (HSL)
    int hslSaturation() { return cast(int)(cast(t_i__qp)pFunQt[14054])(_wh); }

    /// lightness (HSL, 0–255)
    int lightness()     { return cast(int)(cast(t_i__qp)pFunQt[14055])(_wh); }

    /// hslHueF (HSL)
    double hslHueF()        { return cast(double)(cast(t_d__qp)pFunQt[14056])(_wh); }

    /// hslSaturationF
    double hslSaturationF() { return cast(double)(cast(t_d__qp)pFunQt[14057])(_wh); }

    /// lightnessF (HSL, 0.0–1.0)
    double lightnessF()     { return cast(double)(cast(t_d__qp)pFunQt[14058])(_wh); }

    /// getHsl — fills h,s,l,a via int* pointers
    QColor getHsl(void* h, void* s, void* l, void* a) {
        (cast(t_v__qp_qp_qp_qp_qp)pFunQt[14059])(_wh, h, s, l, a);
        return this;
    }

    /// setHsl
    QColor setHsl(int h, int s, int l, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[14060])(_wh, h, s, l, a);
        return this;
    }

    /// setHslF
    QColor setHslF(double h, double s, double l, double a = 1.0) {
        (cast(t_v__qp_d_d_d_d)pFunQt[14061])(_wh, h, s, l, a);
        return this;
    }

    // ── Color model conversion ────────────────────────────────────────

    /// toRgb — caller-owned QColor copy in RGB model
    QColor toRgb()  { return QColor.wrap((cast(t_qp__qp)pFunQt[14062])(_wh)); }

    /// toHsv — caller-owned QColor copy in HSV model
    QColor toHsv()  { return QColor.wrap((cast(t_qp__qp)pFunQt[14063])(_wh)); }

    /// toCmyk — caller-owned QColor copy in CMYK model
    QColor toCmyk() { return QColor.wrap((cast(t_qp__qp)pFunQt[14064])(_wh)); }

    /// toHsl — caller-owned QColor copy in HSL model
    QColor toHsl()  { return QColor.wrap((cast(t_qp__qp)pFunQt[14065])(_wh)); }

    /// convertTo — convert to given QColor::Spec (1=Rgb, 2=Hsv, 3=Cmyk, 4=Hsl)
    QColor convertTo(int colorSpec) {
        return QColor.wrap((cast(t_qp__qp_i)pFunQt[14066])(_wh, colorSpec));
    }

    // ── Static factory methods ────────────────────────────────────────

    /// fromRgb (static) — from packed 0xffRRGGBB
    static QColor fromRgb(uint rgb) {
        return QColor.wrap((cast(t_qp__qp_ui)pFunQt[14067])(null, rgb));
    }

    /// fromRgba (static) — from packed 0xAARRGGBB
    static QColor fromRgba(uint rgba) {
        return QColor.wrap((cast(t_qp__qp_ui)pFunQt[14068])(null, rgba));
    }

    /// fromRgb (static) — from integer RGBA components
    static QColor fromRgb(int r, int g, int b, int a = 255) {
        return QColor.wrap((cast(t_qp__qp_i_i_i_i)pFunQt[14069])(null, r, g, b, a));
    }

    /// fromRgbF (static) — from float RGBA components (0.0–1.0)
    static QColor fromRgbF(double r, double g, double b, double a = 1.0) {
        return QColor.wrap((cast(t_qp__qp_d_d_d_d)pFunQt[14070])(null, r, g, b, a));
    }

    /// fromHsv (static) — from integer HSV components
    static QColor fromHsv(int h, int s, int v, int a = 255) {
        return QColor.wrap((cast(t_qp__qp_i_i_i_i)pFunQt[14071])(null, h, s, v, a));
    }

    /// fromHsvF (static) — from float HSV components (0.0–1.0)
    static QColor fromHsvF(double h, double s, double v, double a = 1.0) {
        return QColor.wrap((cast(t_qp__qp_d_d_d_d)pFunQt[14072])(null, h, s, v, a));
    }

    /// fromCmyk (static) — from integer CMYK components (0–255)
    static QColor fromCmyk(int c, int m, int y, int k, int a = 255) {
        return QColor.wrap((cast(t_qp__qp_i_i_i_i_i)pFunQt[14073])(null, c, m, y, k, a));
    }

    /// fromCmykF (static) — from float CMYK components (0.0–1.0)
    static QColor fromCmykF(double c, double m, double y, double k, double a = 1.0) {
        return QColor.wrap((cast(t_qp__qp_d_d_d_d_d)pFunQt[14074])(null, c, m, y, k, a));
    }

    /// fromHsl (static) — from integer HSL components
    static QColor fromHsl(int h, int s, int l, int a = 255) {
        return QColor.wrap((cast(t_qp__qp_i_i_i_i)pFunQt[14075])(null, h, s, l, a));
    }

    /// fromHslF (static) — from float HSL components (0.0–1.0)
    static QColor fromHslF(double h, double s, double l, double a = 1.0) {
        return QColor.wrap((cast(t_qp__qp_d_d_d_d)pFunQt[14076])(null, h, s, l, a));
    }

    // ── Lighter / darker ──────────────────────────────────────────────

    /// light — deprecated, use lighter()
    QColor light(int f = 150)   { return QColor.wrap((cast(t_qp__qp_i)pFunQt[14077])(_wh, f)); }

    /// dark — deprecated, use darker()
    QColor dark(int f = 200)    { return QColor.wrap((cast(t_qp__qp_i)pFunQt[14078])(_wh, f)); }

    /// lighter — returns a lighter version of this color
    QColor lighter(int f = 150) { return QColor.wrap((cast(t_qp__qp_i)pFunQt[14079])(_wh, f)); }

    /// darker — returns a darker version of this color
    QColor darker(int f = 200)  { return QColor.wrap((cast(t_qp__qp_i)pFunQt[14080])(_wh, f)); }

    // ── Static helpers ────────────────────────────────────────────────

    /// isValidColor (static) — true if name is a recognized color name or hex
    static bool isValidColor(string name) {
        auto _ws_name = toQString(name);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[14081])(null, _ws_name);
        (cast(t_v__qp)pFunQt[22])(_ws_name);
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QColor
