/**
 * gen_qtextblock.d — GENERATED wrapper for QTextBlock.
 * Module: QTextBlock  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextblock;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp;
import gen_qtextcharformat : QTextCharFormat;
import gen_qtextblockformat : QTextBlockFormat;

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextBlock() {
    mixin(generateFunQt(19500, "qteQTextBlock_copy", "QTextBlock"));
    mixin(generateFunQt(19501, "qteQTextBlock_delete", "QTextBlock"));
    mixin(generateFunQt(19502, "qteQTextBlock_text", "QTextBlock"));
    mixin(generateFunQt(19503, "qteQTextBlock_length", "QTextBlock"));
    mixin(generateFunQt(19504, "qteQTextBlock_blockNumber", "QTextBlock"));
    mixin(generateFunQt(19505, "qteQTextBlock_position", "QTextBlock"));
    mixin(generateFunQt(19506, "qteQTextBlock_isValid", "QTextBlock"));
    mixin(generateFunQt(19507, "qteQTextBlock_isVisible", "QTextBlock"));
    mixin(generateFunQt(19508, "qteQTextBlock_revision", "QTextBlock"));
    mixin(generateFunQt(19509, "qteQTextBlock_next", "QTextBlock"));
    mixin(generateFunQt(19510, "qteQTextBlock_previous", "QTextBlock"));
    mixin(generateFunQt(19511, "qteQTextBlock_charFormat", "QTextBlock"));
    mixin(generateFunQt(19512, "qteQTextBlock_blockFormat", "QTextBlock"));
    mixin(generateFunQt(19513, "qteQTextBlock_lineCount", "QTextBlock"));
    mixin(generateFunQt(19514, "qteQTextBlock_firstLineNumber", "QTextBlock"));
}

static this() {
    registerModule("QTextBlock", "qte56_text.dll", &loadQTextBlock);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextBlock (value type).
@live class QTextBlock {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19501] !is null) {
            (cast(t_v__qp)pFunQt[19501])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated C++ QTextBlock* — D takes ownership, deletes on ~this.
    static QTextBlock wrap(void* ptr) {
        if (ptr is null) return null;
        auto b = new QTextBlock(false);
        b._wh = ptr;
        return b;
    }

    /// dup — create a copy (new heap-allocated QTextBlock)
    QTextBlock dup() {
        return QTextBlock.wrap((cast(t_qp__qp)pFunQt[19500])(_wh));
    }

    // ── Text ──────────────────────────────────────────────────────────────

    /// text — block text content
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[19502])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// length — length including trailing newline
    int length() {
        return cast(int)(cast(t_i__qp)pFunQt[19503])(_wh);
    }

    // ── Position / number ─────────────────────────────────────────────────

    /// blockNumber
    int blockNumber() {
        return cast(int)(cast(t_i__qp)pFunQt[19504])(_wh);
    }

    /// position — character position in document
    int position() {
        return cast(int)(cast(t_i__qp)pFunQt[19505])(_wh);
    }

    // ── State queries ─────────────────────────────────────────────────────

    /// isValid
    bool isValid() {
        return cast(bool)(cast(t_i__qp)pFunQt[19506])(_wh);
    }

    /// isVisible
    bool isVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[19507])(_wh);
    }

    /// revision
    int revision() {
        return cast(int)(cast(t_i__qp)pFunQt[19508])(_wh);
    }

    // ── Navigation ────────────────────────────────────────────────────────

    /// next — returns next block or null if invalid
    QTextBlock next() {
        return QTextBlock.wrap((cast(t_qp__qp)pFunQt[19509])(_wh));
    }

    /// previous — returns previous block or null if invalid
    QTextBlock previous() {
        return QTextBlock.wrap((cast(t_qp__qp)pFunQt[19510])(_wh));
    }

    // ── Formatting ────────────────────────────────────────────────────────

    /// charFormat — returns new heap-allocated QTextCharFormat
    QTextCharFormat charFormat() {
        return QTextCharFormat.wrap((cast(t_qp__qp)pFunQt[19511])(_wh));
    }

    /// blockFormat — returns new heap-allocated QTextBlockFormat
    QTextBlockFormat blockFormat() {
        return QTextBlockFormat.wrap((cast(t_qp__qp)pFunQt[19512])(_wh));
    }

    // ── Lines ─────────────────────────────────────────────────────────────

    /// lineCount
    int lineCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19513])(_wh);
    }

    /// firstLineNumber
    int firstLineNumber() {
        return cast(int)(cast(t_i__qp)pFunQt[19514])(_wh);
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTextBlock
