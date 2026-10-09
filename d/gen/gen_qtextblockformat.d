/**
 * gen_qtextblockformat.d — GENERATED wrapper for QTextBlockFormat.
 * Module: QTextBlockFormat  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextblockformat;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i;

// New aliases for this module:
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("d__qp"));
mixin(generateAlias("v__qp_d_i"));   // void(void*, double, int) — setLineHeight

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextBlockFormat() {
    mixin(generateFunQt(19400, "qteQTextBlockFormat_create", "QTextBlockFormat"));
    mixin(generateFunQt(19401, "qteQTextBlockFormat_delete", "QTextBlockFormat"));
    mixin(generateFunQt(19402, "qteQTextBlockFormat_isValid", "QTextBlockFormat"));
    mixin(generateFunQt(19403, "qteQTextBlockFormat_setAlignment", "QTextBlockFormat"));
    mixin(generateFunQt(19404, "qteQTextBlockFormat_alignment", "QTextBlockFormat"));
    mixin(generateFunQt(19405, "qteQTextBlockFormat_setIndent", "QTextBlockFormat"));
    mixin(generateFunQt(19406, "qteQTextBlockFormat_indent", "QTextBlockFormat"));
    mixin(generateFunQt(19407, "qteQTextBlockFormat_setTextIndent", "QTextBlockFormat"));
    mixin(generateFunQt(19408, "qteQTextBlockFormat_textIndent", "QTextBlockFormat"));
    mixin(generateFunQt(19409, "qteQTextBlockFormat_setTopMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19410, "qteQTextBlockFormat_topMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19411, "qteQTextBlockFormat_setBottomMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19412, "qteQTextBlockFormat_bottomMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19413, "qteQTextBlockFormat_setLeftMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19414, "qteQTextBlockFormat_leftMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19415, "qteQTextBlockFormat_setRightMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19416, "qteQTextBlockFormat_rightMargin", "QTextBlockFormat"));
    mixin(generateFunQt(19417, "qteQTextBlockFormat_setLineHeight", "QTextBlockFormat"));
    mixin(generateFunQt(19418, "qteQTextBlockFormat_lineHeight", "QTextBlockFormat"));
    mixin(generateFunQt(19419, "qteQTextBlockFormat_lineHeightType", "QTextBlockFormat"));
}

static this() {
    registerModule("QTextBlockFormat", "qte56_text.dll", &loadQTextBlockFormat);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextBlockFormat (value type).
@live class QTextBlockFormat {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Default-constructed QTextBlockFormat.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19400])(null);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19401] !is null) {
            (cast(t_v__qp)pFunQt[19401])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated C++ QTextBlockFormat* — D takes ownership, deletes on ~this.
    static QTextBlockFormat wrap(void* ptr) {
        if (ptr is null) return null;
        auto f = new QTextBlockFormat(false);
        f._wh = ptr;
        return f;
    }

    // ── Validity ──────────────────────────────────────────────────────────

    /// isValid
    bool isValid() {
        return cast(bool)(cast(t_i__qp)pFunQt[19402])(_wh);
    }

    // ── Alignment ─────────────────────────────────────────────────────────

    /// setAlignment
    QTextBlockFormat setAlignment(int alignment) {
        (cast(t_v__qp_i)pFunQt[19403])(_wh, alignment);
        return this;
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[19404])(_wh);
    }

    // ── Indent ────────────────────────────────────────────────────────────

    /// setIndent
    QTextBlockFormat setIndent(int indent) {
        (cast(t_v__qp_i)pFunQt[19405])(_wh, indent);
        return this;
    }

    /// indent
    int indent() {
        return cast(int)(cast(t_i__qp)pFunQt[19406])(_wh);
    }

    // ── Text indent ───────────────────────────────────────────────────────

    /// setTextIndent
    QTextBlockFormat setTextIndent(double indent) {
        (cast(t_v__qp_d)pFunQt[19407])(_wh, indent);
        return this;
    }

    /// textIndent
    double textIndent() {
        return cast(double)(cast(t_d__qp)pFunQt[19408])(_wh);
    }

    // ── Margins ───────────────────────────────────────────────────────────

    /// setTopMargin
    QTextBlockFormat setTopMargin(double margin) {
        (cast(t_v__qp_d)pFunQt[19409])(_wh, margin);
        return this;
    }

    /// topMargin
    double topMargin() {
        return cast(double)(cast(t_d__qp)pFunQt[19410])(_wh);
    }

    /// setBottomMargin
    QTextBlockFormat setBottomMargin(double margin) {
        (cast(t_v__qp_d)pFunQt[19411])(_wh, margin);
        return this;
    }

    /// bottomMargin
    double bottomMargin() {
        return cast(double)(cast(t_d__qp)pFunQt[19412])(_wh);
    }

    /// setLeftMargin
    QTextBlockFormat setLeftMargin(double margin) {
        (cast(t_v__qp_d)pFunQt[19413])(_wh, margin);
        return this;
    }

    /// leftMargin
    double leftMargin() {
        return cast(double)(cast(t_d__qp)pFunQt[19414])(_wh);
    }

    /// setRightMargin
    QTextBlockFormat setRightMargin(double margin) {
        (cast(t_v__qp_d)pFunQt[19415])(_wh, margin);
        return this;
    }

    /// rightMargin
    double rightMargin() {
        return cast(double)(cast(t_d__qp)pFunQt[19416])(_wh);
    }

    // ── Line height ───────────────────────────────────────────────────────

    /// setLineHeight
    QTextBlockFormat setLineHeight(double height, int heightType) {
        (cast(t_v__qp_d_i)pFunQt[19417])(_wh, height, heightType);
        return this;
    }

    /// lineHeight
    double lineHeight() {
        return cast(double)(cast(t_d__qp)pFunQt[19418])(_wh);
    }

    /// lineHeightType
    int lineHeightType() {
        return cast(int)(cast(t_i__qp)pFunQt[19419])(_wh);
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTextBlockFormat
