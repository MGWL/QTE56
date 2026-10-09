/**
 * gen_qfont.d — GENERATED wrapper for QFont.
 * Module: QFont  |  DLL: qte56_foundation.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qfont;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_i_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp")); // void(void*, void*) — setWidgetFont

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQFont() {
    mixin(generateFunQt(10200, "qteQFont_create", "QFont"));
    mixin(generateFunQt(10201, "qteQFont_delete", "QFont"));
    mixin(generateFunQt(10202, "qteQFont_create_text", "QFont"));
    mixin(generateFunQt(10203, "qteQFont_family", "QFont"));
    mixin(generateFunQt(10204, "qteQFont_setFamily", "QFont"));
    mixin(generateFunQt(10205, "qteQFont_styleName", "QFont"));
    mixin(generateFunQt(10206, "qteQFont_setStyleName", "QFont"));
    mixin(generateFunQt(10207, "qteQFont_pointSize", "QFont"));
    mixin(generateFunQt(10208, "qteQFont_setPointSize", "QFont"));
    mixin(generateFunQt(10209, "qteQFont_pointSizeF", "QFont"));
    mixin(generateFunQt(10210, "qteQFont_setPointSizeF", "QFont"));
    mixin(generateFunQt(10211, "qteQFont_pixelSize", "QFont"));
    mixin(generateFunQt(10212, "qteQFont_setPixelSize", "QFont"));
    mixin(generateFunQt(10213, "qteQFont_weight", "QFont"));
    mixin(generateFunQt(10214, "qteQFont_setWeight", "QFont"));
    mixin(generateFunQt(10215, "qteQFont_bold", "QFont"));
    mixin(generateFunQt(10216, "qteQFont_setBold", "QFont"));
    mixin(generateFunQt(10217, "qteQFont_setStyle", "QFont"));
    mixin(generateFunQt(10218, "qteQFont_style", "QFont"));
    mixin(generateFunQt(10219, "qteQFont_italic", "QFont"));
    mixin(generateFunQt(10220, "qteQFont_setItalic", "QFont"));
    mixin(generateFunQt(10221, "qteQFont_underline", "QFont"));
    mixin(generateFunQt(10222, "qteQFont_setUnderline", "QFont"));
    mixin(generateFunQt(10223, "qteQFont_overline", "QFont"));
    mixin(generateFunQt(10224, "qteQFont_setOverline", "QFont"));
    mixin(generateFunQt(10225, "qteQFont_strikeOut", "QFont"));
    mixin(generateFunQt(10226, "qteQFont_setStrikeOut", "QFont"));
    mixin(generateFunQt(10227, "qteQFont_fixedPitch", "QFont"));
    mixin(generateFunQt(10228, "qteQFont_setFixedPitch", "QFont"));
    mixin(generateFunQt(10229, "qteQFont_kerning", "QFont"));
    mixin(generateFunQt(10230, "qteQFont_setKerning", "QFont"));
    mixin(generateFunQt(10231, "qteQFont_styleHint", "QFont"));
    mixin(generateFunQt(10232, "qteQFont_styleStrategy", "QFont"));
    mixin(generateFunQt(10233, "qteQFont_setStyleHint", "QFont"));
    mixin(generateFunQt(10234, "qteQFont_setStyleStrategy", "QFont"));
    mixin(generateFunQt(10235, "qteQFont_stretch", "QFont"));
    mixin(generateFunQt(10236, "qteQFont_setStretch", "QFont"));
    mixin(generateFunQt(10237, "qteQFont_letterSpacing", "QFont"));
    mixin(generateFunQt(10238, "qteQFont_letterSpacingType", "QFont"));
    mixin(generateFunQt(10239, "qteQFont_setLetterSpacing", "QFont"));
    mixin(generateFunQt(10240, "qteQFont_wordSpacing", "QFont"));
    mixin(generateFunQt(10241, "qteQFont_setWordSpacing", "QFont"));
    mixin(generateFunQt(10242, "qteQFont_setCapitalization", "QFont"));
    mixin(generateFunQt(10243, "qteQFont_capitalization", "QFont"));
    mixin(generateFunQt(10244, "qteQFont_setHintingPreference", "QFont"));
    mixin(generateFunQt(10245, "qteQFont_hintingPreference", "QFont"));
    mixin(generateFunQt(10246, "qteQFont_rawMode", "QFont"));
    mixin(generateFunQt(10247, "qteQFont_setRawMode", "QFont"));
    mixin(generateFunQt(10248, "qteQFont_exactMatch", "QFont"));
    mixin(generateFunQt(10249, "qteQFont_key", "QFont"));
    mixin(generateFunQt(10250, "qteQFont_toString", "QFont"));
    mixin(generateFunQt(10251, "qteQFont_fromString", "QFont"));
    mixin(generateFunQt(10252, "qteQFont_substitute", "QFont"));
    mixin(generateFunQt(10253, "qteQFont_removeSubstitutions", "QFont"));
    mixin(generateFunQt(10254, "qteQFont_initialize", "QFont"));
    mixin(generateFunQt(10255, "qteQFont_cleanup", "QFont"));
    mixin(generateFunQt(10256, "qteQFont_cacheStatistics", "QFont"));
    mixin(generateFunQt(10257, "qteQFont_defaultFamily", "QFont"));
    mixin(generateFunQt(10258, "qteQFont_setWidgetFont",  "QFont"));
    mixin(generateFunQt(10259, "qteQFont_getWidgetFont",  "QFont"));
}

static this() {
    registerModule("QFont", "qte56_foundation.dll", &loadQFont);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QFont.
@live class QFont {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    /// Internal: wrap existing heap pointer without allocating new C++ object.
    this(void* ptr) {
        _wh = ptr;
        _qt_owned = false; // caller-owned heap copy; dtor will delete
    }

public:
    /// Create default QFont (D-owned value type).
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[10200])(null);
    }

    /// Create QFont with family name.
    this(string family) {
        _qt_owned = false;
        auto _ws = toQString(family);
        _wh = (cast(t_qp__qp_qp)pFunQt[10202])(
            _ws, null);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[10201] !is null) {
            (cast(t_v__qp)pFunQt[10201])(_wh);
            _wh = null;
        }
    }

    /// family
    string family() {
        void* _qs = (cast(t_qp__qp)pFunQt[10203])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setFamily
    QFont setFamily(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[10204])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// styleName
    string styleName() {
        void* _qs = (cast(t_qp__qp)pFunQt[10205])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setStyleName
    QFont setStyleName(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[10206])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// pointSize
    int pointSize() {
        return cast(int)(cast(t_i__qp)pFunQt[10207])(_wh);
    }

    /// setPointSize
    QFont setPointSize(int p0) {
        (cast(t_v__qp_i)pFunQt[10208])(_wh, p0);
        return this;
    }

    /// pointSizeF
    double pointSizeF() {
        return cast(double)(cast(t_d__qp)pFunQt[10209])(_wh);
    }

    /// setPointSizeF
    QFont setPointSizeF(double p0) {
        (cast(t_v__qp_d)pFunQt[10210])(_wh, p0);
        return this;
    }

    /// pixelSize
    int pixelSize() {
        return cast(int)(cast(t_i__qp)pFunQt[10211])(_wh);
    }

    /// setPixelSize
    QFont setPixelSize(int p0) {
        (cast(t_v__qp_i)pFunQt[10212])(_wh, p0);
        return this;
    }

    /// weight
    int weight() {
        return cast(int)(cast(t_i__qp)pFunQt[10213])(_wh);
    }

    /// setWeight
    QFont setWeight(int p0) {
        (cast(t_v__qp_i)pFunQt[10214])(_wh, p0);
        return this;
    }

    /// bold
    bool bold() {
        return cast(bool)(cast(t_i__qp)pFunQt[10215])(_wh);
    }

    /// setBold
    QFont setBold(bool p0) {
        (cast(t_v__qp_i)pFunQt[10216])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setStyle
    QFont setStyle(int style) {
        (cast(t_v__qp_i)pFunQt[10217])(_wh, style);
        return this;
    }

    /// style
    int style() {
        return cast(int)(cast(t_i__qp)pFunQt[10218])(_wh);
    }

    /// italic
    bool italic() {
        return cast(bool)(cast(t_i__qp)pFunQt[10219])(_wh);
    }

    /// setItalic
    QFont setItalic(bool b) {
        (cast(t_v__qp_i)pFunQt[10220])(_wh, b ? 1 : 0);
        return this;
    }

    /// underline
    bool underline() {
        return cast(bool)(cast(t_i__qp)pFunQt[10221])(_wh);
    }

    /// setUnderline
    QFont setUnderline(bool p0) {
        (cast(t_v__qp_i)pFunQt[10222])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// overline
    bool overline() {
        return cast(bool)(cast(t_i__qp)pFunQt[10223])(_wh);
    }

    /// setOverline
    QFont setOverline(bool p0) {
        (cast(t_v__qp_i)pFunQt[10224])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// strikeOut
    bool strikeOut() {
        return cast(bool)(cast(t_i__qp)pFunQt[10225])(_wh);
    }

    /// setStrikeOut
    QFont setStrikeOut(bool p0) {
        (cast(t_v__qp_i)pFunQt[10226])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// fixedPitch
    bool fixedPitch() {
        return cast(bool)(cast(t_i__qp)pFunQt[10227])(_wh);
    }

    /// setFixedPitch
    QFont setFixedPitch(bool p0) {
        (cast(t_v__qp_i)pFunQt[10228])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// kerning
    bool kerning() {
        return cast(bool)(cast(t_i__qp)pFunQt[10229])(_wh);
    }

    /// setKerning
    QFont setKerning(bool p0) {
        (cast(t_v__qp_i)pFunQt[10230])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// styleHint
    int styleHint() {
        return cast(int)(cast(t_i__qp)pFunQt[10231])(_wh);
    }

    /// styleStrategy
    int styleStrategy() {
        return cast(int)(cast(t_i__qp)pFunQt[10232])(_wh);
    }

    /// setStyleHint
    QFont setStyleHint(int p0, int p1) {
        (cast(t_v__qp_i_i)pFunQt[10233])(_wh, p0, p1);
        return this;
    }

    /// setStyleStrategy
    QFont setStyleStrategy(int s) {
        (cast(t_v__qp_i)pFunQt[10234])(_wh, s);
        return this;
    }

    /// stretch
    int stretch() {
        return cast(int)(cast(t_i__qp)pFunQt[10235])(_wh);
    }

    /// setStretch
    QFont setStretch(int p0) {
        (cast(t_v__qp_i)pFunQt[10236])(_wh, p0);
        return this;
    }

    /// letterSpacing
    double letterSpacing() {
        return cast(double)(cast(t_d__qp)pFunQt[10237])(_wh);
    }

    /// letterSpacingType
    int letterSpacingType() {
        return cast(int)(cast(t_i__qp)pFunQt[10238])(_wh);
    }

    /// setLetterSpacing
    QFont setLetterSpacing(int type, double spacing) {
        (cast(t_v__qp_i_d)pFunQt[10239])(_wh, type, spacing);
        return this;
    }

    /// wordSpacing
    double wordSpacing() {
        return cast(double)(cast(t_d__qp)pFunQt[10240])(_wh);
    }

    /// setWordSpacing
    QFont setWordSpacing(double spacing) {
        (cast(t_v__qp_d)pFunQt[10241])(_wh, spacing);
        return this;
    }

    /// setCapitalization
    QFont setCapitalization(int p0) {
        (cast(t_v__qp_i)pFunQt[10242])(_wh, p0);
        return this;
    }

    /// capitalization
    int capitalization() {
        return cast(int)(cast(t_i__qp)pFunQt[10243])(_wh);
    }

    /// setHintingPreference
    QFont setHintingPreference(int hintingPreference) {
        (cast(t_v__qp_i)pFunQt[10244])(_wh, hintingPreference);
        return this;
    }

    /// hintingPreference
    int hintingPreference() {
        return cast(int)(cast(t_i__qp)pFunQt[10245])(_wh);
    }

    /// rawMode
    bool rawMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[10246])(_wh);
    }

    /// setRawMode
    QFont setRawMode(bool p0) {
        (cast(t_v__qp_i)pFunQt[10247])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// exactMatch
    bool exactMatch() {
        return cast(bool)(cast(t_i__qp)pFunQt[10248])(_wh);
    }

    /// key
    string key() {
        void* _qs = (cast(t_qp__qp)pFunQt[10249])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// toString
    override string toString() {
        void* _qs = (cast(t_qp__qp)pFunQt[10250])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// fromString
    bool fromString(string p0) {
        auto _ws_p0 = toQString(p0);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[10251])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
    }

    /// substitute
    string substitute(string p0) {
        auto _ws_p0 = toQString(p0);
        void* _qs = (cast(t_qp__qp_qp)pFunQt[10252])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// removeSubstitutions
    QFont removeSubstitutions(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[10253])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// initialize
    QFont initialize() {
        (cast(t_v__qp)pFunQt[10254])(_wh);
        return this;
    }

    /// cleanup
    QFont cleanup() {
        (cast(t_v__qp)pFunQt[10255])(_wh);
        return this;
    }

    /// cacheStatistics
    QFont cacheStatistics() {
        (cast(t_v__qp)pFunQt[10256])(_wh);
        return this;
    }

    /// defaultFamily
    string defaultFamily() {
        void* _qs = (cast(t_qp__qp)pFunQt[10257])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

    /// Wrap a heap-allocated QFont pointer (e.g. from fromWidget). Dtor WILL delete.
    static QFont wrap(void* ptr) {
        if (ptr is null) return null;
        return new QFont(ptr);
    }

    // ── Widget helpers ───────────────────────────────────────────────────────

    /// Apply this font to a widget (pass widget.getWH()).
    QFont applyTo(void* widget) {
        (cast(t_v__qp_qp)pFunQt[10258])(widget, _wh);
        return this;
    }

    /// Get the current font of a widget — returns caller-owned QFont copy.
    static QFont fromWidget(void* widget) {
        void* p = (cast(t_qp__qp)pFunQt[10259])(widget);
        return QFont.wrap(p);
    }

} // class QFont
