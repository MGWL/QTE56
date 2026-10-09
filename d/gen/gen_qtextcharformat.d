/**
 * gen_qtextcharformat.d — GENERATED wrapper for QTextCharFormat.
 * Module: QTextCharFormat  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextcharformat;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for this module:
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("d__qp"));
mixin(generateAlias("ui__qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextCharFormat() {
    mixin(generateFunQt(19300, "qteQTextCharFormat_create", "QTextCharFormat"));
    mixin(generateFunQt(19301, "qteQTextCharFormat_delete", "QTextCharFormat"));
    mixin(generateFunQt(19302, "qteQTextCharFormat_isValid", "QTextCharFormat"));
    mixin(generateFunQt(19303, "qteQTextCharFormat_setFontFamily", "QTextCharFormat"));
    mixin(generateFunQt(19304, "qteQTextCharFormat_fontFamily", "QTextCharFormat"));
    mixin(generateFunQt(19305, "qteQTextCharFormat_setFontPointSize", "QTextCharFormat"));
    mixin(generateFunQt(19306, "qteQTextCharFormat_fontPointSize", "QTextCharFormat"));
    mixin(generateFunQt(19307, "qteQTextCharFormat_setFontWeight", "QTextCharFormat"));
    mixin(generateFunQt(19308, "qteQTextCharFormat_fontWeight", "QTextCharFormat"));
    mixin(generateFunQt(19309, "qteQTextCharFormat_setFontItalic", "QTextCharFormat"));
    mixin(generateFunQt(19310, "qteQTextCharFormat_fontItalic", "QTextCharFormat"));
    mixin(generateFunQt(19311, "qteQTextCharFormat_setFontUnderline", "QTextCharFormat"));
    mixin(generateFunQt(19312, "qteQTextCharFormat_fontUnderline", "QTextCharFormat"));
    mixin(generateFunQt(19313, "qteQTextCharFormat_setFontStrikeOut", "QTextCharFormat"));
    mixin(generateFunQt(19314, "qteQTextCharFormat_fontStrikeOut", "QTextCharFormat"));
    mixin(generateFunQt(19315, "qteQTextCharFormat_setFontOverline", "QTextCharFormat"));
    mixin(generateFunQt(19316, "qteQTextCharFormat_fontOverline", "QTextCharFormat"));
    mixin(generateFunQt(19317, "qteQTextCharFormat_setForeground", "QTextCharFormat"));
    mixin(generateFunQt(19318, "qteQTextCharFormat_setBackground", "QTextCharFormat"));
    mixin(generateFunQt(19319, "qteQTextCharFormat_foreground", "QTextCharFormat"));
    mixin(generateFunQt(19320, "qteQTextCharFormat_background", "QTextCharFormat"));
    mixin(generateFunQt(19321, "qteQTextCharFormat_setFont", "QTextCharFormat"));
    mixin(generateFunQt(19322, "qteQTextCharFormat_font", "QTextCharFormat"));
    mixin(generateFunQt(19323, "qteQTextCharFormat_setUnderlineColor", "QTextCharFormat"));
    mixin(generateFunQt(19324, "qteQTextCharFormat_setUnderlineStyle", "QTextCharFormat"));
}

static this() {
    registerModule("QTextCharFormat", "qte56_text.dll", &loadQTextCharFormat);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextCharFormat (value type).
@live class QTextCharFormat {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Default-constructed QTextCharFormat.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19300])(null);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19301] !is null) {
            (cast(t_v__qp)pFunQt[19301])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated C++ QTextCharFormat* — D takes ownership, deletes on ~this.
    static QTextCharFormat wrap(void* ptr) {
        if (ptr is null) return null;
        auto f = new QTextCharFormat(false);
        f._wh = ptr;
        return f;
    }

    // ── Validity ──────────────────────────────────────────────────────────

    /// isValid
    bool isValid() {
        return cast(bool)(cast(t_i__qp)pFunQt[19302])(_wh);
    }

    // ── Font family ──────────────────────────────────────────────────────

    /// setFontFamily
    QTextCharFormat setFontFamily(string family) {
        auto _ws = toQString(family);
        (cast(t_v__qp_qp)pFunQt[19303])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// fontFamily
    string fontFamily() {
        void* _qs = (cast(t_qp__qp)pFunQt[19304])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Font size ─────────────────────────────────────────────────────────

    /// setFontPointSize
    QTextCharFormat setFontPointSize(double size) {
        (cast(t_v__qp_d)pFunQt[19305])(_wh, size);
        return this;
    }

    /// fontPointSize
    double fontPointSize() {
        return cast(double)(cast(t_d__qp)pFunQt[19306])(_wh);
    }

    // ── Font weight ───────────────────────────────────────────────────────

    /// setFontWeight
    QTextCharFormat setFontWeight(int weight) {
        (cast(t_v__qp_i)pFunQt[19307])(_wh, weight);
        return this;
    }

    /// fontWeight
    int fontWeight() {
        return cast(int)(cast(t_i__qp)pFunQt[19308])(_wh);
    }

    // ── Font italic ───────────────────────────────────────────────────────

    /// setFontItalic
    QTextCharFormat setFontItalic(bool italic) {
        (cast(t_v__qp_i)pFunQt[19309])(_wh, italic ? 1 : 0);
        return this;
    }

    /// fontItalic
    bool fontItalic() {
        return cast(bool)(cast(t_i__qp)pFunQt[19310])(_wh);
    }

    // ── Font underline ────────────────────────────────────────────────────

    /// setFontUnderline
    QTextCharFormat setFontUnderline(bool underline) {
        (cast(t_v__qp_i)pFunQt[19311])(_wh, underline ? 1 : 0);
        return this;
    }

    /// fontUnderline
    bool fontUnderline() {
        return cast(bool)(cast(t_i__qp)pFunQt[19312])(_wh);
    }

    // ── Font strikeout ────────────────────────────────────────────────────

    /// setFontStrikeOut
    QTextCharFormat setFontStrikeOut(bool strikeOut) {
        (cast(t_v__qp_i)pFunQt[19313])(_wh, strikeOut ? 1 : 0);
        return this;
    }

    /// fontStrikeOut
    bool fontStrikeOut() {
        return cast(bool)(cast(t_i__qp)pFunQt[19314])(_wh);
    }

    // ── Font overline ─────────────────────────────────────────────────────

    /// setFontOverline
    QTextCharFormat setFontOverline(bool overline) {
        (cast(t_v__qp_i)pFunQt[19315])(_wh, overline ? 1 : 0);
        return this;
    }

    /// fontOverline
    bool fontOverline() {
        return cast(bool)(cast(t_i__qp)pFunQt[19316])(_wh);
    }

    // ── Foreground / Background ───────────────────────────────────────────

    /// setForeground — takes QColor* (getWH())
    QTextCharFormat setForeground(void* color) {
        (cast(t_v__qp_qp)pFunQt[19317])(_wh, color);
        return this;
    }

    /// setBackground — takes QColor* (getWH())
    QTextCharFormat setBackground(void* color) {
        (cast(t_v__qp_qp)pFunQt[19318])(_wh, color);
        return this;
    }

    /// foreground — returns packed RGBA uint
    uint foreground() {
        return cast(uint)(cast(t_ui__qp)pFunQt[19319])(_wh);
    }

    /// background — returns packed RGBA uint
    uint background() {
        return cast(uint)(cast(t_ui__qp)pFunQt[19320])(_wh);
    }

    // ── Font ──────────────────────────────────────────────────────────────

    /// setFont — takes QFont* (getWH())
    QTextCharFormat setFont(void* font) {
        (cast(t_v__qp_qp)pFunQt[19321])(_wh, font);
        return this;
    }

    /// font — returns new heap-allocated QFont*
    void* font() {
        return cast(void*)(cast(t_qp__qp)pFunQt[19322])(_wh);
    }

    // ── Underline style / color ───────────────────────────────────────────

    /// setUnderlineColor — takes QColor* (getWH())
    QTextCharFormat setUnderlineColor(void* color) {
        (cast(t_v__qp_qp)pFunQt[19323])(_wh, color);
        return this;
    }

    /// setUnderlineStyle — see UnderlineStyle enum
    QTextCharFormat setUnderlineStyle(int style) {
        (cast(t_v__qp_i)pFunQt[19324])(_wh, style);
        return this;
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTextCharFormat
