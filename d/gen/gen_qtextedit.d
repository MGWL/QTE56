/**
 * gen_qtextedit.d — GENERATED wrapper for QTextEdit.
 * Module: QTextEdit  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextedit;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_i__qp_qp_i, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qabstractscrollarea : QAbstractScrollArea;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_qp_i_i"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextEdit() {
    mixin(generateFunQt(8000, "qteQTextEdit_create", "QTextEdit"));
    mixin(generateFunQt(8001, "qteQTextEdit_delete", "QTextEdit"));
    mixin(generateFunQt(8002, "qteQTextEdit_create_text", "QTextEdit"));
    mixin(generateFunQt(8006, "qteQTextEdit_setDocument", "QTextEdit"));
    mixin(generateFunQt(8007, "qteQTextEdit_document", "QTextEdit"));
    mixin(generateFunQt(8008, "qteQTextEdit_setPlaceholderText", "QTextEdit"));
    mixin(generateFunQt(8009, "qteQTextEdit_placeholderText", "QTextEdit"));
    mixin(generateFunQt(8010, "qteQTextEdit_isReadOnly", "QTextEdit"));
    mixin(generateFunQt(8011, "qteQTextEdit_setReadOnly", "QTextEdit"));
    mixin(generateFunQt(8012, "qteQTextEdit_setTextInteractionFlags", "QTextEdit"));
    mixin(generateFunQt(8013, "qteQTextEdit_textInteractionFlags", "QTextEdit"));
    mixin(generateFunQt(8014, "qteQTextEdit_fontPointSize", "QTextEdit"));
    mixin(generateFunQt(8015, "qteQTextEdit_fontFamily", "QTextEdit"));
    mixin(generateFunQt(8016, "qteQTextEdit_fontWeight", "QTextEdit"));
    mixin(generateFunQt(8017, "qteQTextEdit_fontUnderline", "QTextEdit"));
    mixin(generateFunQt(8018, "qteQTextEdit_fontItalic", "QTextEdit"));
    mixin(generateFunQt(8019, "qteQTextEdit_alignment", "QTextEdit"));
    mixin(generateFunQt(8020, "qteQTextEdit_autoFormatting", "QTextEdit"));
    mixin(generateFunQt(8021, "qteQTextEdit_setAutoFormatting", "QTextEdit"));
    mixin(generateFunQt(8022, "qteQTextEdit_tabChangesFocus", "QTextEdit"));
    mixin(generateFunQt(8023, "qteQTextEdit_setTabChangesFocus", "QTextEdit"));
    mixin(generateFunQt(8024, "qteQTextEdit_lineWrapMode", "QTextEdit"));
    mixin(generateFunQt(8025, "qteQTextEdit_setLineWrapMode", "QTextEdit"));
    mixin(generateFunQt(8026, "qteQTextEdit_lineWrapColumnOrWidth", "QTextEdit"));
    mixin(generateFunQt(8027, "qteQTextEdit_setLineWrapColumnOrWidth", "QTextEdit"));
    mixin(generateFunQt(8028, "qteQTextEdit_wordWrapMode", "QTextEdit"));
    mixin(generateFunQt(8029, "qteQTextEdit_setWordWrapMode", "QTextEdit"));
    mixin(generateFunQt(8030, "qteQTextEdit_find", "QTextEdit"));
    mixin(generateFunQt(8031, "qteQTextEdit_toPlainText", "QTextEdit"));
    mixin(generateFunQt(8032, "qteQTextEdit_toHtml", "QTextEdit"));
    mixin(generateFunQt(8033, "qteQTextEdit_ensureCursorVisible", "QTextEdit"));
    mixin(generateFunQt(8034, "qteQTextEdit_createStandardContextMenu_v", "QTextEdit"));
    mixin(generateFunQt(8035, "qteQTextEdit_createStandardContextMenu_p", "QTextEdit"));
    mixin(generateFunQt(8036, "qteQTextEdit_cursorRect", "QTextEdit"));
    mixin(generateFunQt(8037, "qteQTextEdit_anchorAt", "QTextEdit"));
    mixin(generateFunQt(8038, "qteQTextEdit_overwriteMode", "QTextEdit"));
    mixin(generateFunQt(8039, "qteQTextEdit_setOverwriteMode", "QTextEdit"));
    mixin(generateFunQt(8040, "qteQTextEdit_tabStopDistance", "QTextEdit"));
    mixin(generateFunQt(8041, "qteQTextEdit_setTabStopDistance", "QTextEdit"));
    mixin(generateFunQt(8042, "qteQTextEdit_cursorWidth", "QTextEdit"));
    mixin(generateFunQt(8043, "qteQTextEdit_setCursorWidth", "QTextEdit"));
    mixin(generateFunQt(8044, "qteQTextEdit_acceptRichText", "QTextEdit"));
    mixin(generateFunQt(8045, "qteQTextEdit_setAcceptRichText", "QTextEdit"));
    mixin(generateFunQt(8046, "qteQTextEdit_moveCursor", "QTextEdit"));
    mixin(generateFunQt(8047, "qteQTextEdit_canPaste", "QTextEdit"));
    mixin(generateFunQt(8048, "qteQTextEdit_print", "QTextEdit"));
    mixin(generateFunQt(8049, "qteQTextEdit_setFontPointSize", "QTextEdit"));
    mixin(generateFunQt(8050, "qteQTextEdit_setFontFamily", "QTextEdit"));
    mixin(generateFunQt(8051, "qteQTextEdit_setFontWeight", "QTextEdit"));
    mixin(generateFunQt(8052, "qteQTextEdit_setFontUnderline", "QTextEdit"));
    mixin(generateFunQt(8053, "qteQTextEdit_setFontItalic", "QTextEdit"));
    mixin(generateFunQt(8054, "qteQTextEdit_setAlignment", "QTextEdit"));
    mixin(generateFunQt(8055, "qteQTextEdit_setPlainText", "QTextEdit"));
    mixin(generateFunQt(8056, "qteQTextEdit_setHtml", "QTextEdit"));
    mixin(generateFunQt(8057, "qteQTextEdit_setText", "QTextEdit"));
    mixin(generateFunQt(8058, "qteQTextEdit_cut", "QTextEdit"));
    mixin(generateFunQt(8059, "qteQTextEdit_copy", "QTextEdit"));
    mixin(generateFunQt(8060, "qteQTextEdit_paste", "QTextEdit"));
    mixin(generateFunQt(8061, "qteQTextEdit_undo", "QTextEdit"));
    mixin(generateFunQt(8062, "qteQTextEdit_redo", "QTextEdit"));
    mixin(generateFunQt(8063, "qteQTextEdit_clear", "QTextEdit"));
    mixin(generateFunQt(8064, "qteQTextEdit_selectAll", "QTextEdit"));
    mixin(generateFunQt(8065, "qteQTextEdit_insertPlainText", "QTextEdit"));
    mixin(generateFunQt(8066, "qteQTextEdit_insertHtml", "QTextEdit"));
    mixin(generateFunQt(8067, "qteQTextEdit_append", "QTextEdit"));
    mixin(generateFunQt(8068, "qteQTextEdit_scrollToAnchor", "QTextEdit"));
    mixin(generateFunQt(8069, "qteQTextEdit_zoomIn", "QTextEdit"));
    mixin(generateFunQt(8070, "qteQTextEdit_zoomOut", "QTextEdit"));
    mixin(generateFunQt(8071, "qteQTextEdit_textCursor", "QTextEdit"));
    mixin(generateFunQt(8072, "qteQTextEdit_setTextCursor", "QTextEdit"));
    mixin(generateFunQt(8090, "qteQTextEdit_setEventHandler", "QTextEdit"));
}

static this() {
    registerModule("QTextEdit", "qte56_text.dll", &loadQTextEdit);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextEdit.
@live class QTextEdit : QAbstractScrollArea {
public:
    /// Create QTextEdit. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[8000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QTextEdit* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QTextEdit wrap(void* wh) {
        auto w = new QTextEdit(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// Create QTextEdit with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[8002])(
            _ws, parent);
    }

    /// setDocument
    QTextEdit setDocument(void* document) {
        (cast(t_v__qp_qp)pFunQt[8006])(_wh, document);
        return this;
    }

    /// document
    void* document() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8007])(_wh);
    }

    /// setPlaceholderText
    QTextEdit setPlaceholderText(string placeholderText) {
        auto _ws_placeholderText = toQString(placeholderText);
        (cast(t_v__qp_qp)pFunQt[8008])(_wh, _ws_placeholderText);
        (cast(t_v__qp)pFunQt[22])(_ws_placeholderText);
        return this;
    }

    /// placeholderText
    string placeholderText() {
        void* _qs = (cast(t_qp__qp)pFunQt[8009])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// isReadOnly
    bool isReadOnly() {
        return cast(bool)(cast(t_i__qp)pFunQt[8010])(_wh);
    }

    /// setReadOnly
    QTextEdit setReadOnly(bool ro) {
        (cast(t_v__qp_i)pFunQt[8011])(_wh, ro ? 1 : 0);
        return this;
    }

    /// setTextInteractionFlags
    QTextEdit setTextInteractionFlags(int flags) {
        (cast(t_v__qp_i)pFunQt[8012])(_wh, flags);
        return this;
    }

    /// textInteractionFlags
    int textInteractionFlags() {
        return cast(int)(cast(t_i__qp)pFunQt[8013])(_wh);
    }

    /// fontPointSize
    double fontPointSize() {
        return cast(double)(cast(t_d__qp)pFunQt[8014])(_wh);
    }

    /// fontFamily
    string fontFamily() {
        void* _qs = (cast(t_qp__qp)pFunQt[8015])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// fontWeight
    int fontWeight() {
        return cast(int)(cast(t_i__qp)pFunQt[8016])(_wh);
    }

    /// fontUnderline
    bool fontUnderline() {
        return cast(bool)(cast(t_i__qp)pFunQt[8017])(_wh);
    }

    /// fontItalic
    bool fontItalic() {
        return cast(bool)(cast(t_i__qp)pFunQt[8018])(_wh);
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[8019])(_wh);
    }

    /// autoFormatting
    int autoFormatting() {
        return cast(int)(cast(t_i__qp)pFunQt[8020])(_wh);
    }

    /// setAutoFormatting
    QTextEdit setAutoFormatting(int features) {
        (cast(t_v__qp_i)pFunQt[8021])(_wh, features);
        return this;
    }

    /// tabChangesFocus
    bool tabChangesFocus() {
        return cast(bool)(cast(t_i__qp)pFunQt[8022])(_wh);
    }

    /// setTabChangesFocus
    QTextEdit setTabChangesFocus(bool b) {
        (cast(t_v__qp_i)pFunQt[8023])(_wh, b ? 1 : 0);
        return this;
    }

    /// lineWrapMode
    int lineWrapMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8024])(_wh);
    }

    /// setLineWrapMode
    QTextEdit setLineWrapMode(int mode) {
        (cast(t_v__qp_i)pFunQt[8025])(_wh, mode);
        return this;
    }

    /// lineWrapColumnOrWidth
    int lineWrapColumnOrWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[8026])(_wh);
    }

    /// setLineWrapColumnOrWidth
    QTextEdit setLineWrapColumnOrWidth(int w) {
        (cast(t_v__qp_i)pFunQt[8027])(_wh, w);
        return this;
    }

    /// wordWrapMode
    int wordWrapMode() {
        return cast(int)(cast(t_i__qp)pFunQt[8028])(_wh);
    }

    /// setWordWrapMode
    QTextEdit setWordWrapMode(int policy) {
        (cast(t_v__qp_i)pFunQt[8029])(_wh, policy);
        return this;
    }

    /// find
    bool find(string exp, int options) {
        auto _ws_exp = toQString(exp);
        return cast(bool)(cast(t_i__qp_qp_i)pFunQt[8030])(_wh, _ws_exp, options);
        (cast(t_v__qp)pFunQt[22])(_ws_exp);
    }

    /// toPlainText
    string toPlainText() {
        void* _qs = (cast(t_qp__qp)pFunQt[8031])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// toLines — разбить содержимое на строки (удаляет \r\n суффиксы).
    string[] toLines() {
        import std.string : splitLines;
        return toPlainText().splitLines();
    }

    /// toHtml
    string toHtml() {
        void* _qs = (cast(t_qp__qp)pFunQt[8032])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// ensureCursorVisible
    QTextEdit ensureCursorVisible() {
        (cast(t_v__qp)pFunQt[8033])(_wh);
        return this;
    }

    /// createStandardContextMenu
    void* createStandardContextMenu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8034])(_wh);
    }

    /// createStandardContextMenu
    void* createStandardContextMenu(void* position) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[8035])(_wh, position);
    }

    /// cursorRect
    DRect cursorRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[8036])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// anchorAt
    string anchorAt(void* pos) {
        void* _qs = (cast(t_qp__qp_qp)pFunQt[8037])(_wh, pos);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// overwriteMode
    bool overwriteMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[8038])(_wh);
    }

    /// setOverwriteMode
    QTextEdit setOverwriteMode(bool overwrite) {
        (cast(t_v__qp_i)pFunQt[8039])(_wh, overwrite ? 1 : 0);
        return this;
    }

    /// tabStopDistance
    double tabStopDistance() {
        return cast(double)(cast(t_d__qp)pFunQt[8040])(_wh);
    }

    /// setTabStopDistance
    QTextEdit setTabStopDistance(double distance) {
        (cast(t_v__qp_d)pFunQt[8041])(_wh, distance);
        return this;
    }

    /// cursorWidth
    int cursorWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[8042])(_wh);
    }

    /// setCursorWidth
    QTextEdit setCursorWidth(int width) {
        (cast(t_v__qp_i)pFunQt[8043])(_wh, width);
        return this;
    }

    /// acceptRichText
    bool acceptRichText() {
        return cast(bool)(cast(t_i__qp)pFunQt[8044])(_wh);
    }

    /// setAcceptRichText
    QTextEdit setAcceptRichText(bool accept) {
        (cast(t_v__qp_i)pFunQt[8045])(_wh, accept ? 1 : 0);
        return this;
    }

    /// moveCursor
    QTextEdit moveCursor(int operation, int mode) {
        (cast(t_v__qp_i_i)pFunQt[8046])(_wh, operation, mode);
        return this;
    }

    /// canPaste
    bool canPaste() {
        return cast(bool)(cast(t_i__qp)pFunQt[8047])(_wh);
    }

    /// print
    QTextEdit print(void* printer) {
        (cast(t_v__qp_qp)pFunQt[8048])(_wh, printer);
        return this;
    }

    /// setFontPointSize
    QTextEdit setFontPointSize(double s) {
        (cast(t_v__qp_d)pFunQt[8049])(_wh, s);
        return this;
    }

    /// setFontFamily
    QTextEdit setFontFamily(string fontFamily) {
        auto _ws_fontFamily = toQString(fontFamily);
        (cast(t_v__qp_qp)pFunQt[8050])(_wh, _ws_fontFamily);
        (cast(t_v__qp)pFunQt[22])(_ws_fontFamily);
        return this;
    }

    /// setFontWeight
    QTextEdit setFontWeight(int w) {
        (cast(t_v__qp_i)pFunQt[8051])(_wh, w);
        return this;
    }

    /// setFontUnderline
    QTextEdit setFontUnderline(bool b) {
        (cast(t_v__qp_i)pFunQt[8052])(_wh, b ? 1 : 0);
        return this;
    }

    /// setFontItalic
    QTextEdit setFontItalic(bool b) {
        (cast(t_v__qp_i)pFunQt[8053])(_wh, b ? 1 : 0);
        return this;
    }

    /// setAlignment
    QTextEdit setAlignment(int a) {
        (cast(t_v__qp_i)pFunQt[8054])(_wh, a);
        return this;
    }

    /// setPlainText
    QTextEdit setPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8055])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setLines — установить содержимое из массива строк.
    QTextEdit setLines(string[] lines) {
        import std.array : join;
        setPlainText(lines.join("\n"));
        return this;
    }

    /// setHtml
    QTextEdit setHtml(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8056])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setText
    QTextEdit setText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8057])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// cut
    QTextEdit cut() {
        (cast(t_v__qp)pFunQt[8058])(_wh);
        return this;
    }

    /// copy
    QTextEdit copy() {
        (cast(t_v__qp)pFunQt[8059])(_wh);
        return this;
    }

    /// paste
    QTextEdit paste() {
        (cast(t_v__qp)pFunQt[8060])(_wh);
        return this;
    }

    /// undo
    QTextEdit undo() {
        (cast(t_v__qp)pFunQt[8061])(_wh);
        return this;
    }

    /// redo
    QTextEdit redo() {
        (cast(t_v__qp)pFunQt[8062])(_wh);
        return this;
    }

    /// clear
    QTextEdit clear() {
        (cast(t_v__qp)pFunQt[8063])(_wh);
        return this;
    }

    /// selectAll
    QTextEdit selectAll() {
        (cast(t_v__qp)pFunQt[8064])(_wh);
        return this;
    }

    /// insertPlainText
    QTextEdit insertPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8065])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// insertHtml
    QTextEdit insertHtml(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8066])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// append
    QTextEdit append(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[8067])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// appendLines — добавить строки в конец (каждая через append → новый абзац).
    QTextEdit appendLines(string[] lines) {
        foreach (line; lines) append(line);
        return this;
    }

    /// insertLines — вставить строки в позицию курсора.
    QTextEdit insertLines(string[] lines) {
        import std.array : join;
        insertPlainText(lines.join("\n"));
        return this;
    }

    /// scrollToAnchor
    QTextEdit scrollToAnchor(string name) {
        auto _ws_name = toQString(name);
        (cast(t_v__qp_qp)pFunQt[8068])(_wh, _ws_name);
        (cast(t_v__qp)pFunQt[22])(_ws_name);
        return this;
    }

    /// zoomIn
    QTextEdit zoomIn(int range) {
        (cast(t_v__qp_i)pFunQt[8069])(_wh, range);
        return this;
    }

    /// zoomOut
    QTextEdit zoomOut(int range) {
        (cast(t_v__qp_i)pFunQt[8070])(_wh, range);
        return this;
    }

    /// textCursor — returns a copy of the current QTextCursor
    void* textCursor() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8071])(_wh);
    }

    /// setTextCursor — sets the visible cursor
    QTextEdit setTextCursor(void* cursor) {
        (cast(t_v__qp_qp)pFunQt[8072])(_wh, cursor);
        return this;
    }

    /// Connect signal textChanged → ESlot
    QTextEdit connect_textChanged(ESlot eslot) {
        connectQt(_wh, "textChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal undoAvailable → ESlot
    QTextEdit connect_undoAvailable(ESlot eslot) {
        connectQt(_wh, "undoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal redoAvailable → ESlot
    QTextEdit connect_redoAvailable(ESlot eslot) {
        connectQt(_wh, "redoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal copyAvailable → ESlot
    QTextEdit connect_copyAvailable(ESlot eslot) {
        connectQt(_wh, "copyAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal selectionChanged → ESlot
    QTextEdit connect_selectionChanged(ESlot eslot) {
        connectQt(_wh, "selectionChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal cursorPositionChanged → ESlot
    QTextEdit connect_cursorPositionChanged(ESlot eslot) {
        connectQt(_wh, "cursorPositionChanged()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QTextEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8090])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextEdit onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextEdit onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextEdit onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTextEdit onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTextEdit onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTextEdit onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QTextEdit onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTextEdit onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QTextEdit onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextEdit onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextEdit onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextEdit onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextEdit onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QTextEdit onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTextEdit onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTextEdit onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QTextEdit onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    // ── Full event handlers (id 19..25) ──────────────────────────────────────
    // См. описание в QWidget. Callback получает указатель на EventInfo-структуру
    // и возвращает int consumed (1 = обработано, 0 = passthrough к Qt-default).

    /// Qt event: wheelEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, WheelEventInfo* info)
    override QTextEdit onWheelFull(void* cb, void* dthis = null) {
        setEventHandler(19, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QTextEdit onMousePressFull(void* cb, void* dthis = null) {
        setEventHandler(20, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QTextEdit onMouseReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(21, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QTextEdit onMouseMoveFull(void* cb, void* dthis = null) {
        setEventHandler(22, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QTextEdit onMouseDoubleClickFull(void* cb, void* dthis = null) {
        setEventHandler(23, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    override QTextEdit onKeyPressFull(void* cb, void* dthis = null) {
        setEventHandler(24, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    override QTextEdit onKeyReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(25, cb, dthis);
        return this;
    }

} // class QTextEdit
