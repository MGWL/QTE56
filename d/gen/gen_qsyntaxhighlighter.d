/**
 * gen_qsyntaxhighlighter.d — GENERATED wrapper for QSyntaxHighlighter.
 * Module: QSyntaxHighlighter  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qsyntaxhighlighter;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_qp, t_v__qp_qp_qp;
import gen_qtextblock : QTextBlock;

// New aliases for this module:
mixin(generateAlias("v__qp_i_i_qp"));  // void(void*, int, int, void*) — setFormat
mixin(generateAlias("v__qp_i_i_ui"));  // void(void*, int, int, uint) — setFormatColor
mixin(generateAlias("v__qp_i_i_i"));   // void(void*, int, int, int) — setFormatWeight

/// D callback type for highlightBlock:
/// extern(C) void function(void* dthis, void* hl, const(wchar)* text, int len)
alias HighlightCb = extern(C) void function(void* dthis, void* hl, const(wchar)* text, int len);

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSyntaxHighlighter() {
    mixin(generateFunQt(19600, "qteQSyntaxHighlighter_create", "QSyntaxHighlighter"));
    mixin(generateFunQt(19601, "qteQSyntaxHighlighter_delete", "QSyntaxHighlighter"));
    mixin(generateFunQt(19602, "qteQSyntaxHighlighter_setCallback", "QSyntaxHighlighter"));
    mixin(generateFunQt(19603, "qteQSyntaxHighlighter_setFormat", "QSyntaxHighlighter"));
    mixin(generateFunQt(19604, "qteQSyntaxHighlighter_setFormatColor", "QSyntaxHighlighter"));
    mixin(generateFunQt(19605, "qteQSyntaxHighlighter_setFormatWeight", "QSyntaxHighlighter"));
    mixin(generateFunQt(19606, "qteQSyntaxHighlighter_currentBlockState", "QSyntaxHighlighter"));
    mixin(generateFunQt(19607, "qteQSyntaxHighlighter_setCurrentBlockState", "QSyntaxHighlighter"));
    mixin(generateFunQt(19608, "qteQSyntaxHighlighter_previousBlockState", "QSyntaxHighlighter"));
    mixin(generateFunQt(19609, "qteQSyntaxHighlighter_currentBlock", "QSyntaxHighlighter"));
    mixin(generateFunQt(19610, "qteQSyntaxHighlighter_currentBlockText", "QSyntaxHighlighter"));
    mixin(generateFunQt(19611, "qteQSyntaxHighlighter_rehighlight", "QSyntaxHighlighter"));
    mixin(generateFunQt(19612, "qteQSyntaxHighlighter_rehighlightBlock", "QSyntaxHighlighter"));
}

static this() {
    registerModule("QSyntaxHighlighter", "qte56_text.dll", &loadQSyntaxHighlighter);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSyntaxHighlighter (QObject subclass).
@live class QSyntaxHighlighter {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QSyntaxHighlighter attached to QTextDocument*.
    this(void* document) {
        _qt_owned = true;  // owned by QTextDocument
        _wh = (cast(t_qp__qp)pFunQt[19600])(document);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19601] !is null) {
            (cast(t_v__qp)pFunQt[19601])(_wh);
            _wh = null;
        }
    }

    // ── Callback ──────────────────────────────────────────────────────────

    /// setCallback — D callback called for each block during highlighting.
    /// cb: extern(C) void function(void* dthis, void* hl, const(wchar)* text, int len)
    QSyntaxHighlighter setCallback(HighlightCb cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[19602])(_wh, cast(void*)cb, dthis);
        return this;
    }

    // ── Format helpers (use inside callback) ──────────────────────────────

    /// setFormat — apply QTextCharFormat to range [start, start+count)
    static void setFormat(void* hl, int start, int count, void* charFmt) {
        (cast(t_v__qp_i_i_qp)pFunQt[19603])(hl, start, count, charFmt);
    }

    /// setFormatColor — apply color (packed RGBA uint) to range
    static void setFormatColor(void* hl, int start, int count, uint rgba) {
        (cast(t_v__qp_i_i_ui)pFunQt[19604])(hl, start, count, rgba);
    }

    /// setFormatWeight — apply font weight to range
    static void setFormatWeight(void* hl, int start, int count, int weight) {
        (cast(t_v__qp_i_i_i)pFunQt[19605])(hl, start, count, weight);
    }

    // ── Block state ───────────────────────────────────────────────────────

    /// currentBlockState — returns -1 if not set
    static int currentBlockState(void* hl) {
        return cast(int)(cast(t_i__qp)pFunQt[19606])(hl);
    }

    /// setCurrentBlockState
    static void setCurrentBlockState(void* hl, int state) {
        (cast(t_v__qp_i)pFunQt[19607])(hl, state);
    }

    /// previousBlockState — returns -1 if not set
    static int previousBlockState(void* hl) {
        return cast(int)(cast(t_i__qp)pFunQt[19608])(hl);
    }

    // ── Current block ─────────────────────────────────────────────────────

    /// currentBlock — returns new heap-allocated QTextBlock (use inside callback)
    static QTextBlock currentBlock(void* hl) {
        return QTextBlock.wrap((cast(t_qp__qp)pFunQt[19609])(hl));
    }

    /// currentBlockText — returns block text as string (use inside callback)
    static string currentBlockText(void* hl) {
        void* _qs = (cast(t_qp__qp)pFunQt[19610])(hl);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    // ── Rehighlight ───────────────────────────────────────────────────────

    /// rehighlight — re-highlights entire document
    QSyntaxHighlighter rehighlight() {
        (cast(t_v__qp)pFunQt[19611])(_wh);
        return this;
    }

    /// rehighlightBlock — re-highlights a single block
    QSyntaxHighlighter rehighlightBlock(QTextBlock block) {
        (cast(t_v__qp_qp)pFunQt[19612])(_wh, block.getWH());
        return this;
    }

    /// Mark as not Qt-owned (rare — highlighter is normally Qt-owned).
    void disown()  { _qt_owned = false; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QSyntaxHighlighter
