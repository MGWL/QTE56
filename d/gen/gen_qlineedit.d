/**
 * gen_qlineedit.d — GENERATED wrapper for QLineEdit.
 * Module: QLineEdit  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qlineedit;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_qp, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQLineEdit() {
    mixin(generateFunQt(1000, "qteQLineEdit_create", "QLineEdit"));
    mixin(generateFunQt(1001, "qteQLineEdit_delete", "QLineEdit"));
    mixin(generateFunQt(1002, "qteQLineEdit_create_text", "QLineEdit"));
    mixin(generateFunQt(1006, "qteQLineEdit_text", "QLineEdit"));
    mixin(generateFunQt(1007, "qteQLineEdit_displayText", "QLineEdit"));
    mixin(generateFunQt(1008, "qteQLineEdit_placeholderText", "QLineEdit"));
    mixin(generateFunQt(1009, "qteQLineEdit_setPlaceholderText", "QLineEdit"));
    mixin(generateFunQt(1010, "qteQLineEdit_maxLength", "QLineEdit"));
    mixin(generateFunQt(1011, "qteQLineEdit_setMaxLength", "QLineEdit"));
    mixin(generateFunQt(1012, "qteQLineEdit_setFrame", "QLineEdit"));
    mixin(generateFunQt(1013, "qteQLineEdit_hasFrame", "QLineEdit"));
    mixin(generateFunQt(1014, "qteQLineEdit_setClearButtonEnabled", "QLineEdit"));
    mixin(generateFunQt(1015, "qteQLineEdit_isClearButtonEnabled", "QLineEdit"));
    mixin(generateFunQt(1062, "qteQLineEdit_echoMode", "QLineEdit"));
    mixin(generateFunQt(1063, "qteQLineEdit_setEchoMode", "QLineEdit"));
    mixin(generateFunQt(1016, "qteQLineEdit_isReadOnly", "QLineEdit"));
    mixin(generateFunQt(1017, "qteQLineEdit_setReadOnly", "QLineEdit"));
    mixin(generateFunQt(1018, "qteQLineEdit_setValidator", "QLineEdit"));
    mixin(generateFunQt(1019, "qteQLineEdit_validator", "QLineEdit"));
    mixin(generateFunQt(1020, "qteQLineEdit_setCompleter", "QLineEdit"));
    // mixin(generateFunQt(1071, "qteQLineEdit_completer", "QLineEdit"));     // НЕТ В DLL (2026-07): в C++ есть только setCompleter, pFunQt[1071] был бы null → crash. DLL не меняем.
    mixin(generateFunQt(1023, "qteQLineEdit_cursorPosition", "QLineEdit"));
    mixin(generateFunQt(1024, "qteQLineEdit_setCursorPosition", "QLineEdit"));
    mixin(generateFunQt(1025, "qteQLineEdit_cursorPositionAt", "QLineEdit"));
    mixin(generateFunQt(1067, "qteQLineEdit_setAlignment", "QLineEdit"));
    mixin(generateFunQt(1068, "qteQLineEdit_alignment", "QLineEdit"));
    mixin(generateFunQt(1026, "qteQLineEdit_cursorForward", "QLineEdit"));
    mixin(generateFunQt(1027, "qteQLineEdit_cursorBackward", "QLineEdit"));
    mixin(generateFunQt(1028, "qteQLineEdit_cursorWordForward", "QLineEdit"));
    mixin(generateFunQt(1029, "qteQLineEdit_cursorWordBackward", "QLineEdit"));
    mixin(generateFunQt(1030, "qteQLineEdit_backspace", "QLineEdit"));
    mixin(generateFunQt(1031, "qteQLineEdit_del", "QLineEdit"));
    mixin(generateFunQt(1032, "qteQLineEdit_home", "QLineEdit"));
    mixin(generateFunQt(1033, "qteQLineEdit_end", "QLineEdit"));
    mixin(generateFunQt(1034, "qteQLineEdit_isModified", "QLineEdit"));
    mixin(generateFunQt(1035, "qteQLineEdit_setModified", "QLineEdit"));
    mixin(generateFunQt(1036, "qteQLineEdit_setSelection", "QLineEdit"));
    mixin(generateFunQt(1037, "qteQLineEdit_hasSelectedText", "QLineEdit"));
    mixin(generateFunQt(1038, "qteQLineEdit_selectedText", "QLineEdit"));
    mixin(generateFunQt(1039, "qteQLineEdit_selectionStart", "QLineEdit"));
    mixin(generateFunQt(1040, "qteQLineEdit_selectionEnd", "QLineEdit"));
    mixin(generateFunQt(1041, "qteQLineEdit_selectionLength", "QLineEdit"));
    mixin(generateFunQt(1042, "qteQLineEdit_isUndoAvailable", "QLineEdit"));
    mixin(generateFunQt(1043, "qteQLineEdit_isRedoAvailable", "QLineEdit"));
    mixin(generateFunQt(1044, "qteQLineEdit_setDragEnabled", "QLineEdit"));
    mixin(generateFunQt(1045, "qteQLineEdit_dragEnabled", "QLineEdit"));
    mixin(generateFunQt(1069, "qteQLineEdit_setCursorMoveStyle", "QLineEdit"));
    mixin(generateFunQt(1070, "qteQLineEdit_cursorMoveStyle", "QLineEdit"));
    mixin(generateFunQt(1046, "qteQLineEdit_inputMask", "QLineEdit"));
    mixin(generateFunQt(1047, "qteQLineEdit_setInputMask", "QLineEdit"));
    mixin(generateFunQt(1048, "qteQLineEdit_hasAcceptableInput", "QLineEdit"));
    mixin(generateFunQt(1049, "qteQLineEdit_setTextMargins", "QLineEdit"));
    mixin(generateFunQt(1050, "qteQLineEdit_getTextMargins", "QLineEdit"));
    mixin(generateFunQt(1065, "qteQLineEdit_addAction", "QLineEdit"));
    mixin(generateFunQt(1051, "qteQLineEdit_setText", "QLineEdit"));
    mixin(generateFunQt(1052, "qteQLineEdit_clear", "QLineEdit"));
    mixin(generateFunQt(1053, "qteQLineEdit_selectAll", "QLineEdit"));
    mixin(generateFunQt(1054, "qteQLineEdit_undo", "QLineEdit"));
    mixin(generateFunQt(1055, "qteQLineEdit_redo", "QLineEdit"));
    mixin(generateFunQt(1056, "qteQLineEdit_cut", "QLineEdit"));
    mixin(generateFunQt(1057, "qteQLineEdit_copy", "QLineEdit"));
    mixin(generateFunQt(1058, "qteQLineEdit_paste", "QLineEdit"));
    mixin(generateFunQt(1059, "qteQLineEdit_deselect", "QLineEdit"));
    mixin(generateFunQt(1060, "qteQLineEdit_insert", "QLineEdit"));
    // mixin(generateFunQt(1072, "qteQLineEdit_createStandardContextMenu", "QLineEdit"));  // НЕТ В DLL (2026-07): нет реализации в C++, pFunQt[1072] был бы null → crash. DLL не меняем.
    mixin(generateFunQt(1061, "qteQLineEdit_event", "QLineEdit"));
    mixin(generateFunQt(1066, "qteQLineEdit_setEventHandler", "QLineEdit"));
}

static this() {
    registerModule("QLineEdit", "qte56_widgets.dll", &loadQLineEdit);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QLineEdit.
@live class QLineEdit : QWidget {
public:
    /// Create QLineEdit. parent=null → top-level widget.
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[1000])(parent);
    }

    /// Create QLineEdit with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[1002])(
            _ws, parent);
    }

    /// No-op constructor for super() calls and wrap().
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QLineEdit* (e.g. from QUiLoader or findChild).
    static QLineEdit wrap(void* wh) {
        auto w = new QLineEdit(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[1006])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// displayText
    string displayText() {
        void* _qs = (cast(t_qp__qp)pFunQt[1007])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// placeholderText
    string placeholderText() {
        void* _qs = (cast(t_qp__qp)pFunQt[1008])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setPlaceholderText
    QLineEdit setPlaceholderText(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[1009])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// maxLength
    int maxLength() {
        return cast(int)(cast(t_i__qp)pFunQt[1010])(_wh);
    }

    /// setMaxLength
    QLineEdit setMaxLength(int p0) {
        (cast(t_v__qp_i)pFunQt[1011])(_wh, p0);
        return this;
    }

    /// setFrame
    QLineEdit setFrame(bool p0) {
        (cast(t_v__qp_i)pFunQt[1012])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// hasFrame
    bool hasFrame() {
        return cast(bool)(cast(t_i__qp)pFunQt[1013])(_wh);
    }

    /// setClearButtonEnabled
    QLineEdit setClearButtonEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[1014])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isClearButtonEnabled
    bool isClearButtonEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[1015])(_wh);
    }

    /// echoMode
    int echoMode() {
        return cast(int)(cast(t_i__qp)pFunQt[1062])(_wh);
    }

    /// setEchoMode
    QLineEdit setEchoMode(int p0) {
        (cast(t_v__qp_i)pFunQt[1063])(_wh, p0);
        return this;
    }

    /// isReadOnly
    bool isReadOnly() {
        return cast(bool)(cast(t_i__qp)pFunQt[1016])(_wh);
    }

    /// setReadOnly
    QLineEdit setReadOnly(bool p0) {
        (cast(t_v__qp_i)pFunQt[1017])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setValidator
    QLineEdit setValidator(void* p0) {
        (cast(t_v__qp_qp)pFunQt[1018])(_wh, p0);
        return this;
    }

    /// validator
    void* validator() {
        return cast(void*)(cast(t_qp__qp)pFunQt[1019])(_wh);
    }

    /// setCompleter
    QLineEdit setCompleter(void* completer) {
        (cast(t_v__qp_qp)pFunQt[1020])(_wh, completer);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQLineEdit_completer не реализован в C++ (есть только setCompleter).
    // Привязка в loadQLineEdit() закомментирована; метод отключён — pFunQt[1071] == null → crash.
    // /// completer
    // void* completer() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1071])(_wh);
    // }

    /// cursorPosition
    int cursorPosition() {
        return cast(int)(cast(t_i__qp)pFunQt[1023])(_wh);
    }

    /// setCursorPosition
    QLineEdit setCursorPosition(int p0) {
        (cast(t_v__qp_i)pFunQt[1024])(_wh, p0);
        return this;
    }

    /// cursorPositionAt
    int cursorPositionAt(void* pos) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[1025])(_wh, pos);
    }

    /// setAlignment
    QLineEdit setAlignment(int flag) {
        (cast(t_v__qp_i)pFunQt[1067])(_wh, flag);
        return this;
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[1068])(_wh);
    }

    /// cursorForward
    QLineEdit cursorForward(bool mark, int steps) {
        (cast(t_v__qp_i_i)pFunQt[1026])(_wh, mark ? 1 : 0, steps);
        return this;
    }

    /// cursorBackward
    QLineEdit cursorBackward(bool mark, int steps) {
        (cast(t_v__qp_i_i)pFunQt[1027])(_wh, mark ? 1 : 0, steps);
        return this;
    }

    /// cursorWordForward
    QLineEdit cursorWordForward(bool mark) {
        (cast(t_v__qp_i)pFunQt[1028])(_wh, mark ? 1 : 0);
        return this;
    }

    /// cursorWordBackward
    QLineEdit cursorWordBackward(bool mark) {
        (cast(t_v__qp_i)pFunQt[1029])(_wh, mark ? 1 : 0);
        return this;
    }

    /// backspace
    QLineEdit backspace() {
        (cast(t_v__qp)pFunQt[1030])(_wh);
        return this;
    }

    /// del
    QLineEdit del() {
        (cast(t_v__qp)pFunQt[1031])(_wh);
        return this;
    }

    /// home
    QLineEdit home(bool mark) {
        (cast(t_v__qp_i)pFunQt[1032])(_wh, mark ? 1 : 0);
        return this;
    }

    /// end
    QLineEdit end(bool mark) {
        (cast(t_v__qp_i)pFunQt[1033])(_wh, mark ? 1 : 0);
        return this;
    }

    /// isModified
    bool isModified() {
        return cast(bool)(cast(t_i__qp)pFunQt[1034])(_wh);
    }

    /// setModified
    QLineEdit setModified(bool p0) {
        (cast(t_v__qp_i)pFunQt[1035])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setSelection
    QLineEdit setSelection(int p0, int p1) {
        (cast(t_v__qp_i_i)pFunQt[1036])(_wh, p0, p1);
        return this;
    }

    /// hasSelectedText
    bool hasSelectedText() {
        return cast(bool)(cast(t_i__qp)pFunQt[1037])(_wh);
    }

    /// selectedText
    string selectedText() {
        void* _qs = (cast(t_qp__qp)pFunQt[1038])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// selectionStart
    int selectionStart() {
        return cast(int)(cast(t_i__qp)pFunQt[1039])(_wh);
    }

    /// selectionEnd
    int selectionEnd() {
        return cast(int)(cast(t_i__qp)pFunQt[1040])(_wh);
    }

    /// selectionLength
    int selectionLength() {
        return cast(int)(cast(t_i__qp)pFunQt[1041])(_wh);
    }

    /// isUndoAvailable
    bool isUndoAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[1042])(_wh);
    }

    /// isRedoAvailable
    bool isRedoAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[1043])(_wh);
    }

    /// setDragEnabled
    QLineEdit setDragEnabled(bool b) {
        (cast(t_v__qp_i)pFunQt[1044])(_wh, b ? 1 : 0);
        return this;
    }

    /// dragEnabled
    bool dragEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[1045])(_wh);
    }

    /// setCursorMoveStyle
    QLineEdit setCursorMoveStyle(int style) {
        (cast(t_v__qp_i)pFunQt[1069])(_wh, style);
        return this;
    }

    /// cursorMoveStyle
    int cursorMoveStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[1070])(_wh);
    }

    /// inputMask
    string inputMask() {
        void* _qs = (cast(t_qp__qp)pFunQt[1046])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setInputMask
    QLineEdit setInputMask(string inputMask) {
        auto _ws_inputMask = toQString(inputMask);
        (cast(t_v__qp_qp)pFunQt[1047])(_wh, _ws_inputMask);
        (cast(t_v__qp)pFunQt[22])(_ws_inputMask);
        return this;
    }

    /// hasAcceptableInput
    bool hasAcceptableInput() {
        return cast(bool)(cast(t_i__qp)pFunQt[1048])(_wh);
    }

    /// setTextMargins
    QLineEdit setTextMargins(int left, int top, int right, int bottom) {
        (cast(t_v__qp_i_i_i_i)pFunQt[1049])(_wh, left, top, right, bottom);
        return this;
    }

    /// getTextMargins
    QLineEdit getTextMargins(void* left, void* top, void* right, void* bottom) {
        (cast(t_v__qp_qp_qp_qp_qp)pFunQt[1050])(_wh, left, top, right, bottom);
        return this;
    }

    /// addAction
    QLineEdit addAction(void* action, int position) {
        (cast(t_v__qp_qp_i)pFunQt[1065])(_wh, action, position);
        return this;
    }

    /// setText
    QLineEdit setText(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[1051])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// clear
    QLineEdit clear() {
        (cast(t_v__qp)pFunQt[1052])(_wh);
        return this;
    }

    /// selectAll
    QLineEdit selectAll() {
        (cast(t_v__qp)pFunQt[1053])(_wh);
        return this;
    }

    /// undo
    QLineEdit undo() {
        (cast(t_v__qp)pFunQt[1054])(_wh);
        return this;
    }

    /// redo
    QLineEdit redo() {
        (cast(t_v__qp)pFunQt[1055])(_wh);
        return this;
    }

    /// cut
    QLineEdit cut() {
        (cast(t_v__qp)pFunQt[1056])(_wh);
        return this;
    }

    /// copy
    QLineEdit copy() {
        (cast(t_v__qp)pFunQt[1057])(_wh);
        return this;
    }

    /// paste
    QLineEdit paste() {
        (cast(t_v__qp)pFunQt[1058])(_wh);
        return this;
    }

    /// deselect
    QLineEdit deselect() {
        (cast(t_v__qp)pFunQt[1059])(_wh);
        return this;
    }

    /// insert
    QLineEdit insert(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[1060])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQLineEdit_createStandardContextMenu не реализован в C++.
    // Привязка в loadQLineEdit() закомментирована; метод отключён — pFunQt[1072] == null → crash.
    // /// createStandardContextMenu
    // void* createStandardContextMenu() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1072])(_wh);
    // }

    /// event
    override bool event(void* p0) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[1061])(_wh, p0);
    }

    /// Connect signal textChanged → ESlot
    QLineEdit connect_textChanged(ESlot eslot) {
        connectQt(_wh, "textChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal textEdited → ESlot
    QLineEdit connect_textEdited(ESlot eslot) {
        connectQt(_wh, "textEdited(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal cursorPositionChanged → ESlot
    QLineEdit connect_cursorPositionChanged(ESlot eslot) {
        connectQt(_wh, "cursorPositionChanged(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal returnPressed → ESlot
    QLineEdit connect_returnPressed(ESlot eslot) {
        connectQt(_wh, "returnPressed()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal editingFinished → ESlot
    QLineEdit connect_editingFinished(ESlot eslot) {
        connectQt(_wh, "editingFinished()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal selectionChanged → ESlot
    QLineEdit connect_selectionChanged(ESlot eslot) {
        connectQt(_wh, "selectionChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal inputRejected → ESlot
    QLineEdit connect_inputRejected(ESlot eslot) {
        connectQt(_wh, "inputRejected()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QLineEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[1066])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLineEdit onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLineEdit onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLineEdit onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLineEdit onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLineEdit onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLineEdit onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QLineEdit onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLineEdit onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QLineEdit onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QLineEdit onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QLineEdit onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QLineEdit onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QLineEdit onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QLineEdit onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLineEdit onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLineEdit onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QLineEdit onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QLineEdit
