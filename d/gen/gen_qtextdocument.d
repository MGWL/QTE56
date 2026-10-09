/**
 * gen_qtextdocument.d — GENERATED wrapper for QTextDocument.
 * Module: QTextDocument  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextdocument;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextDocument() {
    mixin(generateFunQt(19000, "qteQTextDocument_create", "QTextDocument"));
    mixin(generateFunQt(19001, "qteQTextDocument_delete", "QTextDocument"));
    mixin(generateFunQt(19002, "qteQTextDocument_create_text", "QTextDocument"));
    mixin(generateFunQt(19003, "qteQTextDocument_clone", "QTextDocument"));
    mixin(generateFunQt(19004, "qteQTextDocument_isEmpty", "QTextDocument"));
    mixin(generateFunQt(19005, "qteQTextDocument_clear", "QTextDocument"));
    mixin(generateFunQt(19006, "qteQTextDocument_setUndoRedoEnabled", "QTextDocument"));
    mixin(generateFunQt(19007, "qteQTextDocument_isUndoRedoEnabled", "QTextDocument"));
    mixin(generateFunQt(19008, "qteQTextDocument_isUndoAvailable", "QTextDocument"));
    mixin(generateFunQt(19009, "qteQTextDocument_isRedoAvailable", "QTextDocument"));
    mixin(generateFunQt(19010, "qteQTextDocument_availableUndoSteps", "QTextDocument"));
    mixin(generateFunQt(19011, "qteQTextDocument_availableRedoSteps", "QTextDocument"));
    mixin(generateFunQt(19012, "qteQTextDocument_revision", "QTextDocument"));
    mixin(generateFunQt(19013, "qteQTextDocument_setDocumentLayout", "QTextDocument"));
    mixin(generateFunQt(19014, "qteQTextDocument_documentLayout", "QTextDocument"));
    mixin(generateFunQt(19015, "qteQTextDocument_setMetaInformation", "QTextDocument"));
    mixin(generateFunQt(19016, "qteQTextDocument_metaInformation", "QTextDocument"));
    mixin(generateFunQt(19017, "qteQTextDocument_toHtml", "QTextDocument"));
    mixin(generateFunQt(19018, "qteQTextDocument_setHtml", "QTextDocument"));
    mixin(generateFunQt(19019, "qteQTextDocument_toRawText", "QTextDocument"));
    mixin(generateFunQt(19020, "qteQTextDocument_toPlainText", "QTextDocument"));
    mixin(generateFunQt(19021, "qteQTextDocument_setPlainText", "QTextDocument"));
    mixin(generateFunQt(19022, "qteQTextDocument_frameAt", "QTextDocument"));
    mixin(generateFunQt(19023, "qteQTextDocument_rootFrame", "QTextDocument"));
    mixin(generateFunQt(19024, "qteQTextDocument_object", "QTextDocument"));
    mixin(generateFunQt(19025, "qteQTextDocument_setDefaultFont", "QTextDocument"));
    mixin(generateFunQt(19026, "qteQTextDocument_defaultFont", "QTextDocument"));
    mixin(generateFunQt(19027, "qteQTextDocument_pageCount", "QTextDocument"));
    mixin(generateFunQt(19028, "qteQTextDocument_isModified", "QTextDocument"));
    // 19029 (print) removed — requires QPrintSupport
    mixin(generateFunQt(19030, "qteQTextDocument_markContentsDirty", "QTextDocument"));
    mixin(generateFunQt(19031, "qteQTextDocument_setUseDesignMetrics", "QTextDocument"));
    mixin(generateFunQt(19032, "qteQTextDocument_useDesignMetrics", "QTextDocument"));
    mixin(generateFunQt(19033, "qteQTextDocument_setTextWidth", "QTextDocument"));
    mixin(generateFunQt(19034, "qteQTextDocument_textWidth", "QTextDocument"));
    mixin(generateFunQt(19035, "qteQTextDocument_idealWidth", "QTextDocument"));
    mixin(generateFunQt(19036, "qteQTextDocument_indentWidth", "QTextDocument"));
    mixin(generateFunQt(19037, "qteQTextDocument_setIndentWidth", "QTextDocument"));
    mixin(generateFunQt(19038, "qteQTextDocument_documentMargin", "QTextDocument"));
    mixin(generateFunQt(19039, "qteQTextDocument_setDocumentMargin", "QTextDocument"));
    mixin(generateFunQt(19040, "qteQTextDocument_adjustSize", "QTextDocument"));
    mixin(generateFunQt(19041, "qteQTextDocument_blockCount", "QTextDocument"));
    mixin(generateFunQt(19042, "qteQTextDocument_lineCount", "QTextDocument"));
    mixin(generateFunQt(19043, "qteQTextDocument_characterCount", "QTextDocument"));
    mixin(generateFunQt(19044, "qteQTextDocument_setDefaultStyleSheet", "QTextDocument"));
    mixin(generateFunQt(19045, "qteQTextDocument_defaultStyleSheet", "QTextDocument"));
    mixin(generateFunQt(19046, "qteQTextDocument_undo_p", "QTextDocument"));
    mixin(generateFunQt(19047, "qteQTextDocument_redo_p", "QTextDocument"));
    mixin(generateFunQt(19048, "qteQTextDocument_clearUndoRedoStacks", "QTextDocument"));
    mixin(generateFunQt(19049, "qteQTextDocument_maximumBlockCount", "QTextDocument"));
    mixin(generateFunQt(19050, "qteQTextDocument_setMaximumBlockCount", "QTextDocument"));
    mixin(generateFunQt(19051, "qteQTextDocument_defaultCursorMoveStyle", "QTextDocument"));
    mixin(generateFunQt(19052, "qteQTextDocument_setDefaultCursorMoveStyle", "QTextDocument"));
    mixin(generateFunQt(19053, "qteQTextDocument_undo_v", "QTextDocument"));
    mixin(generateFunQt(19054, "qteQTextDocument_redo_v", "QTextDocument"));
    mixin(generateFunQt(19055, "qteQTextDocument_appendUndoItem", "QTextDocument"));
    mixin(generateFunQt(19056, "qteQTextDocument_setModified", "QTextDocument"));
    // 19057 (docHandle) removed — internal Qt type
}

static this() {
    registerModule("QTextDocument", "qte56_widgets.dll", &loadQTextDocument);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextDocument.
@live class QTextDocument {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op ctor for wrap (D-side only, no C++ allocation).
    protected this(bool) { _qt_owned = true; }

public:
    /// Wrap a Qt-owned QTextDocument* (e.g. from QTextEdit.document()).
    /// Does NOT delete on destruction.
    static QTextDocument wrap(void* ptr) {
        auto d = new QTextDocument(false);
        d._wh = ptr;
        return d;
    }

    /// Create QTextDocument. parent=null → standalone document.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[19000])(parent);
    }

    /// Create QTextDocument with initial text.
    this(string text, void* parent = null) {
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[19002])(
            _ws, parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19001] !is null) {
            (cast(t_v__qp)pFunQt[19001])(_wh);
            _wh = null;
        }
    }

    /// clone
    void* clone(void* parent) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[19003])(_wh, parent);
    }

    /// isEmpty
    bool isEmpty() {
        return cast(bool)(cast(t_i__qp)pFunQt[19004])(_wh);
    }

    /// clear
    QTextDocument clear() {
        (cast(t_v__qp)pFunQt[19005])(_wh);
        return this;
    }

    /// setUndoRedoEnabled
    QTextDocument setUndoRedoEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[19006])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isUndoRedoEnabled
    bool isUndoRedoEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[19007])(_wh);
    }

    /// isUndoAvailable
    bool isUndoAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[19008])(_wh);
    }

    /// isRedoAvailable
    bool isRedoAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[19009])(_wh);
    }

    /// availableUndoSteps
    int availableUndoSteps() {
        return cast(int)(cast(t_i__qp)pFunQt[19010])(_wh);
    }

    /// availableRedoSteps
    int availableRedoSteps() {
        return cast(int)(cast(t_i__qp)pFunQt[19011])(_wh);
    }

    /// revision
    int revision() {
        return cast(int)(cast(t_i__qp)pFunQt[19012])(_wh);
    }

    /// setDocumentLayout
    QTextDocument setDocumentLayout(void* layout) {
        (cast(t_v__qp_qp)pFunQt[19013])(_wh, layout);
        return this;
    }

    /// documentLayout
    void* documentLayout() {
        return cast(void*)(cast(t_qp__qp)pFunQt[19014])(_wh);
    }

    /// setMetaInformation
    QTextDocument setMetaInformation(int info, string p1) {
        auto _ws_p1 = toQString(p1);
        (cast(t_v__qp_i_qp)pFunQt[19015])(_wh, info, _ws_p1);
        (cast(t_v__qp)pFunQt[22])(_ws_p1);
        return this;
    }

    /// metaInformation
    string metaInformation(int info) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[19016])(_wh, info);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// toHtml
    string toHtml() {
        void* _qs = (cast(t_qp__qp)pFunQt[19017])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setHtml
    QTextDocument setHtml(string html) {
        auto _ws_html = toQString(html);
        (cast(t_v__qp_qp)pFunQt[19018])(_wh, _ws_html);
        (cast(t_v__qp)pFunQt[22])(_ws_html);
        return this;
    }

    /// toRawText
    string toRawText() {
        void* _qs = (cast(t_qp__qp)pFunQt[19019])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// toPlainText
    string toPlainText() {
        void* _qs = (cast(t_qp__qp)pFunQt[19020])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setPlainText
    QTextDocument setPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[19021])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// frameAt
    void* frameAt(int pos) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[19022])(_wh, pos);
    }

    /// rootFrame
    void* rootFrame() {
        return cast(void*)(cast(t_qp__qp)pFunQt[19023])(_wh);
    }

    /// object
    void* object(int objectIndex) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[19024])(_wh, objectIndex);
    }

    /// setDefaultFont
    QTextDocument setDefaultFont(void* font) {
        (cast(t_v__qp_qp)pFunQt[19025])(_wh, font);
        return this;
    }

    /// defaultFont
    void* defaultFont() {
        return (cast(t_qp__qp)pFunQt[19026])(_wh);
    }

    /// pageCount
    int pageCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19027])(_wh);
    }

    /// isModified
    bool isModified() {
        return cast(bool)(cast(t_i__qp)pFunQt[19028])(_wh);
    }

    // print() removed — requires QPrintSupport

    /// markContentsDirty
    QTextDocument markContentsDirty(int from, int length) {
        (cast(t_v__qp_i_i)pFunQt[19030])(_wh, from, length);
        return this;
    }

    /// setUseDesignMetrics
    QTextDocument setUseDesignMetrics(bool b) {
        (cast(t_v__qp_i)pFunQt[19031])(_wh, b ? 1 : 0);
        return this;
    }

    /// useDesignMetrics
    bool useDesignMetrics() {
        return cast(bool)(cast(t_i__qp)pFunQt[19032])(_wh);
    }

    /// setTextWidth
    QTextDocument setTextWidth(double width) {
        (cast(t_v__qp_d)pFunQt[19033])(_wh, width);
        return this;
    }

    /// textWidth
    double textWidth() {
        return cast(double)(cast(t_d__qp)pFunQt[19034])(_wh);
    }

    /// idealWidth
    double idealWidth() {
        return cast(double)(cast(t_d__qp)pFunQt[19035])(_wh);
    }

    /// indentWidth
    double indentWidth() {
        return cast(double)(cast(t_d__qp)pFunQt[19036])(_wh);
    }

    /// setIndentWidth
    QTextDocument setIndentWidth(double width) {
        (cast(t_v__qp_d)pFunQt[19037])(_wh, width);
        return this;
    }

    /// documentMargin
    double documentMargin() {
        return cast(double)(cast(t_d__qp)pFunQt[19038])(_wh);
    }

    /// setDocumentMargin
    QTextDocument setDocumentMargin(double margin) {
        (cast(t_v__qp_d)pFunQt[19039])(_wh, margin);
        return this;
    }

    /// adjustSize
    QTextDocument adjustSize() {
        (cast(t_v__qp)pFunQt[19040])(_wh);
        return this;
    }

    /// blockCount
    int blockCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19041])(_wh);
    }

    /// lineCount
    int lineCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19042])(_wh);
    }

    /// characterCount
    int characterCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19043])(_wh);
    }

    /// setDefaultStyleSheet
    QTextDocument setDefaultStyleSheet(string sheet) {
        auto _ws_sheet = toQString(sheet);
        (cast(t_v__qp_qp)pFunQt[19044])(_wh, _ws_sheet);
        (cast(t_v__qp)pFunQt[22])(_ws_sheet);
        return this;
    }

    /// defaultStyleSheet
    string defaultStyleSheet() {
        void* _qs = (cast(t_qp__qp)pFunQt[19045])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// undo
    QTextDocument undo(void* cursor) {
        (cast(t_v__qp_qp)pFunQt[19046])(_wh, cursor);
        return this;
    }

    /// redo
    QTextDocument redo(void* cursor) {
        (cast(t_v__qp_qp)pFunQt[19047])(_wh, cursor);
        return this;
    }

    /// clearUndoRedoStacks
    QTextDocument clearUndoRedoStacks(int historyToClear) {
        (cast(t_v__qp_i)pFunQt[19048])(_wh, historyToClear);
        return this;
    }

    /// maximumBlockCount
    int maximumBlockCount() {
        return cast(int)(cast(t_i__qp)pFunQt[19049])(_wh);
    }

    /// setMaximumBlockCount
    QTextDocument setMaximumBlockCount(int maximum) {
        (cast(t_v__qp_i)pFunQt[19050])(_wh, maximum);
        return this;
    }

    /// defaultCursorMoveStyle
    int defaultCursorMoveStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[19051])(_wh);
    }

    /// setDefaultCursorMoveStyle
    QTextDocument setDefaultCursorMoveStyle(int style) {
        (cast(t_v__qp_i)pFunQt[19052])(_wh, style);
        return this;
    }

    /// undo
    QTextDocument undo() {
        (cast(t_v__qp)pFunQt[19053])(_wh);
        return this;
    }

    /// redo
    QTextDocument redo() {
        (cast(t_v__qp)pFunQt[19054])(_wh);
        return this;
    }

    /// appendUndoItem
    QTextDocument appendUndoItem(void* p0) {
        (cast(t_v__qp_qp)pFunQt[19055])(_wh, p0);
        return this;
    }

    /// setModified
    QTextDocument setModified(bool m) {
        (cast(t_v__qp_i)pFunQt[19056])(_wh, m ? 1 : 0);
        return this;
    }

    // docHandle() removed — internal Qt type

    // Signal contentsChange — unsupported parameter types
    /// Connect signal contentsChanged → ESlot
    QTextDocument connect_contentsChanged(ESlot eslot) {
        connectQt(_wh, "contentsChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal undoAvailable → ESlot
    QTextDocument connect_undoAvailable(ESlot eslot) {
        connectQt(_wh, "undoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal redoAvailable → ESlot
    QTextDocument connect_redoAvailable(ESlot eslot) {
        connectQt(_wh, "redoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal undoCommandAdded → ESlot
    QTextDocument connect_undoCommandAdded(ESlot eslot) {
        connectQt(_wh, "undoCommandAdded()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal modificationChanged → ESlot
    QTextDocument connect_modificationChanged(ESlot eslot) {
        connectQt(_wh, "modificationChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal blockCountChanged → ESlot
    QTextDocument connect_blockCountChanged(ESlot eslot) {
        connectQt(_wh, "blockCountChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal documentLayoutChanged → ESlot
    QTextDocument connect_documentLayoutChanged(ESlot eslot) {
        connectQt(_wh, "documentLayoutChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Mark as Qt-owned (call after setLayout / reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QTextDocument
