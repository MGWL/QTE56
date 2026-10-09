/**
 * gen_qtextcursor.d — GENERATED wrapper for QTextCursor.
 * Module: QTextCursor  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextcursor;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString;
import gen_qtextcharformat : QTextCharFormat;
import gen_qtextblockformat : QTextBlockFormat;
import gen_qtextblock : QTextBlock;

// New aliases for this module:
mixin(generateAlias("i__qp_i_i_i"));  // int(void*, int, int, int) — movePosition
mixin(generateAlias("v__qp_qp_i_qp")); // void(void*, void*, int, void*) — insertText_fmt

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextCursor() {
    mixin(generateFunQt(19200, "qteQTextCursor_create", "QTextCursor"));
    mixin(generateFunQt(19201, "qteQTextCursor_delete", "QTextCursor"));
    mixin(generateFunQt(19202, "qteQTextCursor_copy", "QTextCursor"));
    mixin(generateFunQt(19203, "qteQTextCursor_position", "QTextCursor"));
    mixin(generateFunQt(19204, "qteQTextCursor_setPosition", "QTextCursor"));
    mixin(generateFunQt(19205, "qteQTextCursor_movePosition", "QTextCursor"));
    mixin(generateFunQt(19206, "qteQTextCursor_anchor", "QTextCursor"));
    mixin(generateFunQt(19207, "qteQTextCursor_hasSelection", "QTextCursor"));
    mixin(generateFunQt(19208, "qteQTextCursor_selectedText", "QTextCursor"));
    mixin(generateFunQt(19209, "qteQTextCursor_removeSelectedText", "QTextCursor"));
    mixin(generateFunQt(19210, "qteQTextCursor_select", "QTextCursor"));
    mixin(generateFunQt(19211, "qteQTextCursor_selectionStart", "QTextCursor"));
    mixin(generateFunQt(19212, "qteQTextCursor_selectionEnd", "QTextCursor"));
    mixin(generateFunQt(19213, "qteQTextCursor_clearSelection", "QTextCursor"));
    mixin(generateFunQt(19214, "qteQTextCursor_insertText", "QTextCursor"));
    mixin(generateFunQt(19215, "qteQTextCursor_insertHtml", "QTextCursor"));
    mixin(generateFunQt(19216, "qteQTextCursor_insertBlock", "QTextCursor"));
    mixin(generateFunQt(19217, "qteQTextCursor_atStart", "QTextCursor"));
    mixin(generateFunQt(19218, "qteQTextCursor_atEnd", "QTextCursor"));
    mixin(generateFunQt(19219, "qteQTextCursor_atBlockStart", "QTextCursor"));
    mixin(generateFunQt(19220, "qteQTextCursor_atBlockEnd", "QTextCursor"));
    mixin(generateFunQt(19221, "qteQTextCursor_blockNumber", "QTextCursor"));
    mixin(generateFunQt(19222, "qteQTextCursor_columnNumber", "QTextCursor"));
    mixin(generateFunQt(19223, "qteQTextCursor_positionInBlock", "QTextCursor"));
    mixin(generateFunQt(19224, "qteQTextCursor_charFormat", "QTextCursor"));
    mixin(generateFunQt(19225, "qteQTextCursor_setCharFormat", "QTextCursor"));
    mixin(generateFunQt(19226, "qteQTextCursor_mergeCharFormat", "QTextCursor"));
    mixin(generateFunQt(19227, "qteQTextCursor_blockFormat", "QTextCursor"));
    mixin(generateFunQt(19228, "qteQTextCursor_setBlockFormat", "QTextCursor"));
    mixin(generateFunQt(19229, "qteQTextCursor_mergeBlockFormat", "QTextCursor"));
    mixin(generateFunQt(19230, "qteQTextCursor_block", "QTextCursor"));
    mixin(generateFunQt(19231, "qteQTextCursor_beginEditBlock", "QTextCursor"));
    mixin(generateFunQt(19232, "qteQTextCursor_endEditBlock", "QTextCursor"));
    mixin(generateFunQt(19233, "qteQTextCursor_isNull", "QTextCursor"));
    mixin(generateFunQt(19234, "qteQTextCursor_insertText_fmt", "QTextCursor"));
    mixin(generateFunQt(19235, "qteQTextCursor_insertBlock_fmt", "QTextCursor"));
}

static this() {
    registerModule("QTextCursor", "qte56_text.dll", &loadQTextCursor);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextCursor (value type).
@live class QTextCursor {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create QTextCursor from QTextDocument*.
    this(void* document) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19200])(document);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19201] !is null) {
            (cast(t_v__qp)pFunQt[19201])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated C++ QTextCursor* — D takes ownership, deletes on ~this.
    static QTextCursor wrap(void* ptr) {
        if (ptr is null) return null;
        auto c = new QTextCursor(false);
        c._wh = ptr;
        return c;
    }

    /// dup — create a copy (new heap-allocated QTextCursor)
    QTextCursor dup() {
        return QTextCursor.wrap((cast(t_qp__qp)pFunQt[19202])(_wh));
    }

    // ── Position ──────────────────────────────────────────────────────────

    /// position
    int position() {
        return cast(int)(cast(t_i__qp)pFunQt[19203])(_wh);
    }

    /// setPosition
    QTextCursor setPosition(int pos, int mode = 0) {
        (cast(t_v__qp_i_i)pFunQt[19204])(_wh, pos, mode);
        return this;
    }

    /// movePosition — returns true if cursor was moved
    bool movePosition(int op, int mode = 0, int n = 1) {
        return cast(bool)(cast(t_i__qp_i_i_i)pFunQt[19205])(_wh, op, mode, n);
    }

    /// anchor
    int anchor() {
        return cast(int)(cast(t_i__qp)pFunQt[19206])(_wh);
    }

    // ── Selection ─────────────────────────────────────────────────────────

    /// hasSelection
    bool hasSelection() {
        return cast(bool)(cast(t_i__qp)pFunQt[19207])(_wh);
    }

    /// selectedText
    string selectedText() {
        void* _qs = (cast(t_qp__qp)pFunQt[19208])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// removeSelectedText
    QTextCursor removeSelectedText() {
        (cast(t_v__qp)pFunQt[19209])(_wh);
        return this;
    }

    /// select — selects text using SelectionType enum
    QTextCursor select(int selType) {
        (cast(t_v__qp_i)pFunQt[19210])(_wh, selType);
        return this;
    }

    /// selectionStart
    int selectionStart() {
        return cast(int)(cast(t_i__qp)pFunQt[19211])(_wh);
    }

    /// selectionEnd
    int selectionEnd() {
        return cast(int)(cast(t_i__qp)pFunQt[19212])(_wh);
    }

    /// clearSelection
    QTextCursor clearSelection() {
        (cast(t_v__qp)pFunQt[19213])(_wh);
        return this;
    }

    // ── Insert ────────────────────────────────────────────────────────────

    /// insertText
    QTextCursor insertText(string text) {
        auto _ws = toQString(text);
        (cast(t_v__qp_qp)pFunQt[19214])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// insertHtml
    QTextCursor insertHtml(string html) {
        auto _ws = toQString(html);
        (cast(t_v__qp_qp)pFunQt[19215])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// insertBlock
    QTextCursor insertBlock() {
        (cast(t_v__qp)pFunQt[19216])(_wh);
        return this;
    }

    // ── At-position queries ───────────────────────────────────────────────

    /// atStart
    bool atStart() {
        return cast(bool)(cast(t_i__qp)pFunQt[19217])(_wh);
    }

    /// atEnd
    bool atEnd() {
        return cast(bool)(cast(t_i__qp)pFunQt[19218])(_wh);
    }

    /// atBlockStart
    bool atBlockStart() {
        return cast(bool)(cast(t_i__qp)pFunQt[19219])(_wh);
    }

    /// atBlockEnd
    bool atBlockEnd() {
        return cast(bool)(cast(t_i__qp)pFunQt[19220])(_wh);
    }

    // ── Block info ────────────────────────────────────────────────────────

    /// blockNumber
    int blockNumber() {
        return cast(int)(cast(t_i__qp)pFunQt[19221])(_wh);
    }

    /// columnNumber
    int columnNumber() {
        return cast(int)(cast(t_i__qp)pFunQt[19222])(_wh);
    }

    /// positionInBlock
    int positionInBlock() {
        return cast(int)(cast(t_i__qp)pFunQt[19223])(_wh);
    }

    // ── Formatting ────────────────────────────────────────────────────────

    /// charFormat — returns new heap-allocated QTextCharFormat
    QTextCharFormat charFormat() {
        return QTextCharFormat.wrap((cast(t_qp__qp)pFunQt[19224])(_wh));
    }

    /// setCharFormat
    QTextCursor setCharFormat(QTextCharFormat fmt) {
        (cast(t_v__qp_qp)pFunQt[19225])(_wh, fmt.getWH());
        return this;
    }

    /// mergeCharFormat
    QTextCursor mergeCharFormat(QTextCharFormat fmt) {
        (cast(t_v__qp_qp)pFunQt[19226])(_wh, fmt.getWH());
        return this;
    }

    /// blockFormat — returns new heap-allocated QTextBlockFormat
    QTextBlockFormat blockFormat() {
        return QTextBlockFormat.wrap((cast(t_qp__qp)pFunQt[19227])(_wh));
    }

    /// setBlockFormat
    QTextCursor setBlockFormat(QTextBlockFormat fmt) {
        (cast(t_v__qp_qp)pFunQt[19228])(_wh, fmt.getWH());
        return this;
    }

    /// mergeBlockFormat
    QTextCursor mergeBlockFormat(QTextBlockFormat fmt) {
        (cast(t_v__qp_qp)pFunQt[19229])(_wh, fmt.getWH());
        return this;
    }

    // ── Block ─────────────────────────────────────────────────────────────

    /// block — returns new heap-allocated QTextBlock
    QTextBlock block() {
        return QTextBlock.wrap((cast(t_qp__qp)pFunQt[19230])(_wh));
    }

    // ── Edit blocks ───────────────────────────────────────────────────────

    /// beginEditBlock
    QTextCursor beginEditBlock() {
        (cast(t_v__qp)pFunQt[19231])(_wh);
        return this;
    }

    /// endEditBlock
    QTextCursor endEditBlock() {
        (cast(t_v__qp)pFunQt[19232])(_wh);
        return this;
    }

    // ── Misc ──────────────────────────────────────────────────────────────

    /// isNull
    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[19233])(_wh);
    }

    /// insertText with format
    QTextCursor insertText(string text, QTextCharFormat fmt) {
        auto _ws = toQString(text);
        (cast(t_v__qp_qp_qp)pFunQt[19234])(_wh, _ws, fmt.getWH());
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// insertBlock with format
    QTextCursor insertBlock(QTextBlockFormat fmt) {
        (cast(t_v__qp_qp)pFunQt[19235])(_wh, fmt.getWH());
        return this;
    }

    /// Mark as Qt-owned (call after reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTextCursor
