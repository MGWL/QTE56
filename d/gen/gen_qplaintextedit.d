/**
 * gen_qplaintextedit.d — GENERATED wrapper for QPlainTextEdit.
 * Module: QPlainTextEdit  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qplaintextedit;

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
mixin(generateAlias("v__qp_i_i_i_i"));   // setViewportMargins
mixin(generateAlias("v__qp_i_ip_ip"));   // blockBoundingGeometry(blockNum, *y, *h)
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQPlainTextEdit() {
    mixin(generateFunQt(5000, "qteQPlainTextEdit_create", "QPlainTextEdit"));
    mixin(generateFunQt(5001, "qteQPlainTextEdit_delete", "QPlainTextEdit"));
    mixin(generateFunQt(5002, "qteQPlainTextEdit_create_text", "QPlainTextEdit"));
    mixin(generateFunQt(5006, "qteQPlainTextEdit_setDocument", "QPlainTextEdit"));
    mixin(generateFunQt(5007, "qteQPlainTextEdit_document", "QPlainTextEdit"));
    mixin(generateFunQt(5008, "qteQPlainTextEdit_setPlaceholderText", "QPlainTextEdit"));
    mixin(generateFunQt(5009, "qteQPlainTextEdit_placeholderText", "QPlainTextEdit"));
    mixin(generateFunQt(5010, "qteQPlainTextEdit_isReadOnly", "QPlainTextEdit"));
    mixin(generateFunQt(5011, "qteQPlainTextEdit_setReadOnly", "QPlainTextEdit"));
    mixin(generateFunQt(5012, "qteQPlainTextEdit_setTextInteractionFlags", "QPlainTextEdit"));
    mixin(generateFunQt(5013, "qteQPlainTextEdit_textInteractionFlags", "QPlainTextEdit"));
    mixin(generateFunQt(5014, "qteQPlainTextEdit_tabChangesFocus", "QPlainTextEdit"));
    mixin(generateFunQt(5015, "qteQPlainTextEdit_setTabChangesFocus", "QPlainTextEdit"));
    mixin(generateFunQt(5016, "qteQPlainTextEdit_lineWrapMode", "QPlainTextEdit"));
    mixin(generateFunQt(5017, "qteQPlainTextEdit_setLineWrapMode", "QPlainTextEdit"));
    mixin(generateFunQt(5018, "qteQPlainTextEdit_wordWrapMode", "QPlainTextEdit"));
    mixin(generateFunQt(5019, "qteQPlainTextEdit_setWordWrapMode", "QPlainTextEdit"));
    mixin(generateFunQt(5020, "qteQPlainTextEdit_setBackgroundVisible", "QPlainTextEdit"));
    mixin(generateFunQt(5021, "qteQPlainTextEdit_backgroundVisible", "QPlainTextEdit"));
    mixin(generateFunQt(5022, "qteQPlainTextEdit_setCenterOnScroll", "QPlainTextEdit"));
    mixin(generateFunQt(5023, "qteQPlainTextEdit_centerOnScroll", "QPlainTextEdit"));
    mixin(generateFunQt(5024, "qteQPlainTextEdit_find", "QPlainTextEdit"));
    mixin(generateFunQt(5025, "qteQPlainTextEdit_ensureCursorVisible", "QPlainTextEdit"));
    mixin(generateFunQt(5026, "qteQPlainTextEdit_createStandardContextMenu_v", "QPlainTextEdit"));
    mixin(generateFunQt(5027, "qteQPlainTextEdit_createStandardContextMenu_p", "QPlainTextEdit"));
    mixin(generateFunQt(5028, "qteQPlainTextEdit_cursorRect", "QPlainTextEdit"));
    mixin(generateFunQt(5029, "qteQPlainTextEdit_anchorAt", "QPlainTextEdit"));
    mixin(generateFunQt(5030, "qteQPlainTextEdit_overwriteMode", "QPlainTextEdit"));
    mixin(generateFunQt(5031, "qteQPlainTextEdit_setOverwriteMode", "QPlainTextEdit"));
    mixin(generateFunQt(5032, "qteQPlainTextEdit_tabStopDistance", "QPlainTextEdit"));
    mixin(generateFunQt(5033, "qteQPlainTextEdit_setTabStopDistance", "QPlainTextEdit"));
    mixin(generateFunQt(5034, "qteQPlainTextEdit_cursorWidth", "QPlainTextEdit"));
    mixin(generateFunQt(5035, "qteQPlainTextEdit_setCursorWidth", "QPlainTextEdit"));
    mixin(generateFunQt(5036, "qteQPlainTextEdit_moveCursor", "QPlainTextEdit"));
    mixin(generateFunQt(5037, "qteQPlainTextEdit_canPaste", "QPlainTextEdit"));
    mixin(generateFunQt(5038, "qteQPlainTextEdit_print", "QPlainTextEdit"));
    mixin(generateFunQt(5039, "qteQPlainTextEdit_blockCount", "QPlainTextEdit"));
    mixin(generateFunQt(5040, "qteQPlainTextEdit_setPlainText", "QPlainTextEdit"));
    mixin(generateFunQt(5041, "qteQPlainTextEdit_cut", "QPlainTextEdit"));
    mixin(generateFunQt(5042, "qteQPlainTextEdit_copy", "QPlainTextEdit"));
    mixin(generateFunQt(5043, "qteQPlainTextEdit_paste", "QPlainTextEdit"));
    mixin(generateFunQt(5044, "qteQPlainTextEdit_undo", "QPlainTextEdit"));
    mixin(generateFunQt(5045, "qteQPlainTextEdit_redo", "QPlainTextEdit"));
    mixin(generateFunQt(5046, "qteQPlainTextEdit_clear", "QPlainTextEdit"));
    mixin(generateFunQt(5047, "qteQPlainTextEdit_selectAll", "QPlainTextEdit"));
    mixin(generateFunQt(5048, "qteQPlainTextEdit_insertPlainText", "QPlainTextEdit"));
    mixin(generateFunQt(5049, "qteQPlainTextEdit_appendPlainText", "QPlainTextEdit"));
    mixin(generateFunQt(5050, "qteQPlainTextEdit_appendHtml", "QPlainTextEdit"));
    mixin(generateFunQt(5051, "qteQPlainTextEdit_centerCursor", "QPlainTextEdit"));
    mixin(generateFunQt(5052, "qteQPlainTextEdit_zoomIn", "QPlainTextEdit"));
    mixin(generateFunQt(5053, "qteQPlainTextEdit_zoomOut", "QPlainTextEdit"));
    mixin(generateFunQt(5055, "qteQPlainTextEdit_textCursor", "QPlainTextEdit"));
    mixin(generateFunQt(5056, "qteQPlainTextEdit_setTextCursor", "QPlainTextEdit"));
    mixin(generateFunQt(5054, "qteQPlainTextEdit_setEventHandler",     "QPlainTextEdit"));
    // Protected viewport / scroll API (доступ через subclass eQPlainTextEdit)
    mixin(generateFunQt(5074, "qteQPlainTextEdit_setViewportMargins",  "QPlainTextEdit"));
    mixin(generateFunQt(5075, "qteQPlainTextEdit_getViewportMargins",  "QPlainTextEdit"));
    mixin(generateFunQt(5076, "qteQPlainTextEdit_scrollContentsBy",    "QPlainTextEdit"));
    // Public-API (через protected, доступ через subclass eQPlainTextEdit) для line-number area
    mixin(generateFunQt(5077, "qteQPlainTextEdit_firstVisibleBlock",      "QPlainTextEdit"));
    mixin(generateFunQt(5078, "qteQPlainTextEdit_blockBoundingGeometry",  "QPlainTextEdit"));
    mixin(generateFunQt(5079, "qteQPlainTextEdit_contentOffset",          "QPlainTextEdit"));
    mixin(generateFunQt(5080, "qteQPlainTextEdit_connect_updateRequest",  "QPlainTextEdit"));
}

static this() {
    registerModule("QPlainTextEdit", "qte56_text.dll", &loadQPlainTextEdit);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QPlainTextEdit.
@live class QPlainTextEdit : QAbstractScrollArea {
public:
    /// Create QPlainTextEdit. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[5000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QPlainTextEdit* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QPlainTextEdit wrap(void* wh) {
        auto w = new QPlainTextEdit(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// Create QPlainTextEdit with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[5002])(
            _ws, parent);
    }

    /// setDocument
    QPlainTextEdit setDocument(void* document) {
        (cast(t_v__qp_qp)pFunQt[5006])(_wh, document);
        return this;
    }

    /// document
    void* document() {
        return cast(void*)(cast(t_qp__qp)pFunQt[5007])(_wh);
    }

    /// setPlaceholderText
    QPlainTextEdit setPlaceholderText(string placeholderText) {
        auto _ws_placeholderText = toQString(placeholderText);
        (cast(t_v__qp_qp)pFunQt[5008])(_wh, _ws_placeholderText);
        (cast(t_v__qp)pFunQt[22])(_ws_placeholderText);
        return this;
    }

    /// placeholderText
    string placeholderText() {
        void* _qs = (cast(t_qp__qp)pFunQt[5009])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// isReadOnly
    bool isReadOnly() {
        return cast(bool)(cast(t_i__qp)pFunQt[5010])(_wh);
    }

    /// setReadOnly
    QPlainTextEdit setReadOnly(bool ro) {
        (cast(t_v__qp_i)pFunQt[5011])(_wh, ro ? 1 : 0);
        return this;
    }

    /// setTextInteractionFlags
    QPlainTextEdit setTextInteractionFlags(int flags) {
        (cast(t_v__qp_i)pFunQt[5012])(_wh, flags);
        return this;
    }

    /// textInteractionFlags
    int textInteractionFlags() {
        return cast(int)(cast(t_i__qp)pFunQt[5013])(_wh);
    }

    /// tabChangesFocus
    bool tabChangesFocus() {
        return cast(bool)(cast(t_i__qp)pFunQt[5014])(_wh);
    }

    /// setTabChangesFocus
    QPlainTextEdit setTabChangesFocus(bool b) {
        (cast(t_v__qp_i)pFunQt[5015])(_wh, b ? 1 : 0);
        return this;
    }

    /// lineWrapMode
    int lineWrapMode() {
        return cast(int)(cast(t_i__qp)pFunQt[5016])(_wh);
    }

    /// setLineWrapMode
    QPlainTextEdit setLineWrapMode(int mode) {
        (cast(t_v__qp_i)pFunQt[5017])(_wh, mode);
        return this;
    }

    // ─── Protected viewport / scroll API ──────────────────────────────────────
    //
    // setViewportMargins / viewportMargins / scrollContentsBy в Qt 5 объявлены
    // как protected. В QTE56 доступ открыт через subclass eQPlainTextEdit
    // (using-trick) и публикован через C-API.
    //
    // Типичное применение — line-number area:
    //   pteEdit.setViewportMargins(50, 0, 0, 0);  // 50 px слева под нумерацию
    //   // CLineNumberArea.setParent(pteEdit) — нумератор положить в ту область

    /// Зарезервировать область внутри scroll-area рядом с viewport.
    /// Все четыре аргумента — отступы в пикселях; 0 = без отступа.
    QPlainTextEdit setViewportMargins(int left, int top, int right, int bottom) {
        (cast(t_v__qp_i_i_i_i)pFunQt[5074])(_wh, left, top, right, bottom);
        return this;
    }

    /// Получить текущие viewport-отступы (left, top, right, bottom).
    /// Возвращает int[4]; индексы соответствуют сторонам.
    int[4] getViewportMargins() {
        int l, t, r, b;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[5075])(_wh, &l, &t, &r, &b);
        return [l, t, r, b];
    }

    /// Программно прокрутить содержимое на (dx, dy) пикселей.
    /// Используется для синхронизации с другим редактором или
    /// custom-навигации. Обычная прокрутка делается через scrollbar.
    QPlainTextEdit scrollContentsBy(int dx, int dy) {
        (cast(t_v__qp_i_i)pFunQt[5076])(_wh, dx, dy);
        return this;
    }

    // ─── Line-number area helpers ─────────────────────────────────────────────
    //
    // Стандартный паттерн (Qt docs / Code Editor example):
    //   1. Создать QWidget рядом с viewport (в области setViewportMargins)
    //   2. В paintEvent QWidget'а:
    //        - получить firstVisibleBlock
    //        - идти по блокам пока y <= viewport bottom
    //        - рисовать номер строки (block.blockNumber + 1) в нужной позиции
    //   3. Подписаться на updateRequest сигнал → lineNumberArea.update()

    /// Возвращает QTextBlock первого видимого блока (на самом верху viewport).
    /// Класс QTextBlock владеет указателем — освобождается через GC.
    auto firstVisibleBlock()() {
        import gen_qtextblock : QTextBlock;
        void* ptr = (cast(t_qp__qp)pFunQt[5077])(_wh);
        return QTextBlock.wrap(ptr);
    }

    /// Получить y-координату и высоту блока в координатах viewport.
    /// (Удобный комбинированный API blockBoundingGeometry+contentOffset.)
    int[2] blockBoundingGeometry(int blockNumber) {
        int y, h;
        (cast(t_v__qp_i_ip_ip)pFunQt[5078])(_wh, blockNumber, &y, &h);
        return [y, h];
    }

    /// Смещение содержимого относительно viewport (для precise paint).
    int[2] contentOffset() {
        int x, y;
        (cast(t_v__qp_ip_ip)pFunQt[5079])(_wh, &x, &y);
        return [x, y];
    }

    /// Подключить ESlot к сигналу updateRequest (триггер перерисовки viewport).
    /// Сигнатура коллбэка: invoke_v — `void cb(void* dthis, int n)`.
    /// Используется line-number area: при срабатывании вызывает `update()`.
    QPlainTextEdit connect_updateRequest(ESlot eslot) {
        (cast(t_v__qp_qp)pFunQt[5080])(_wh, eslot.raw());
        return this;
    }

    /// wordWrapMode
    int wordWrapMode() {
        return cast(int)(cast(t_i__qp)pFunQt[5018])(_wh);
    }

    /// setWordWrapMode
    QPlainTextEdit setWordWrapMode(int policy) {
        (cast(t_v__qp_i)pFunQt[5019])(_wh, policy);
        return this;
    }

    /// setBackgroundVisible
    QPlainTextEdit setBackgroundVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[5020])(_wh, visible ? 1 : 0);
        return this;
    }

    /// backgroundVisible
    bool backgroundVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[5021])(_wh);
    }

    /// setCenterOnScroll
    QPlainTextEdit setCenterOnScroll(bool enabled) {
        (cast(t_v__qp_i)pFunQt[5022])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// centerOnScroll
    bool centerOnScroll() {
        return cast(bool)(cast(t_i__qp)pFunQt[5023])(_wh);
    }

    /// find
    bool find(string exp, int options) {
        auto _ws_exp = toQString(exp);
        return cast(bool)(cast(t_i__qp_qp_i)pFunQt[5024])(_wh, _ws_exp, options);
        (cast(t_v__qp)pFunQt[22])(_ws_exp);
    }

    /// ensureCursorVisible
    QPlainTextEdit ensureCursorVisible() {
        (cast(t_v__qp)pFunQt[5025])(_wh);
        return this;
    }

    /// createStandardContextMenu
    void* createStandardContextMenu() {
        return cast(void*)(cast(t_qp__qp)pFunQt[5026])(_wh);
    }

    /// createStandardContextMenu
    void* createStandardContextMenu(void* position) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[5027])(_wh, position);
    }

    /// cursorRect
    DRect cursorRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[5028])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// anchorAt
    string anchorAt(void* pos) {
        void* _qs = (cast(t_qp__qp_qp)pFunQt[5029])(_wh, pos);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// overwriteMode
    bool overwriteMode() {
        return cast(bool)(cast(t_i__qp)pFunQt[5030])(_wh);
    }

    /// setOverwriteMode
    QPlainTextEdit setOverwriteMode(bool overwrite) {
        (cast(t_v__qp_i)pFunQt[5031])(_wh, overwrite ? 1 : 0);
        return this;
    }

    /// tabStopDistance
    double tabStopDistance() {
        return cast(double)(cast(t_d__qp)pFunQt[5032])(_wh);
    }

    /// setTabStopDistance
    QPlainTextEdit setTabStopDistance(double distance) {
        (cast(t_v__qp_d)pFunQt[5033])(_wh, distance);
        return this;
    }

    /// cursorWidth
    int cursorWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[5034])(_wh);
    }

    /// setCursorWidth
    QPlainTextEdit setCursorWidth(int width) {
        (cast(t_v__qp_i)pFunQt[5035])(_wh, width);
        return this;
    }

    /// moveCursor
    QPlainTextEdit moveCursor(int operation, int mode) {
        (cast(t_v__qp_i_i)pFunQt[5036])(_wh, operation, mode);
        return this;
    }

    /// canPaste
    bool canPaste() {
        return cast(bool)(cast(t_i__qp)pFunQt[5037])(_wh);
    }

    /// print
    QPlainTextEdit print(void* printer) {
        (cast(t_v__qp_qp)pFunQt[5038])(_wh, printer);
        return this;
    }

    /// blockCount
    int blockCount() {
        return cast(int)(cast(t_i__qp)pFunQt[5039])(_wh);
    }

    /// setPlainText
    QPlainTextEdit setPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[5040])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// toPlainText — получить весь текст через QTextDocument.
    string toPlainText() {
        import gen_qtextdocument : QTextDocument;
        return QTextDocument.wrap(document()).toPlainText();
    }

    /// toLines — разбить содержимое на строки (удаляет \r\n суффиксы).
    string[] toLines() {
        import std.string : splitLines;
        return toPlainText().splitLines();
    }

    /// setLines — установить содержимое из массива строк.
    QPlainTextEdit setLines(string[] lines) {
        import std.array : join;
        setPlainText(lines.join("\n"));
        return this;
    }

    /// appendLines — добавить строки в конец документа (каждая — новый абзац).
    QPlainTextEdit appendLines(string[] lines) {
        foreach (line; lines) appendPlainText(line);
        return this;
    }

    /// insertLines — вставить строки в позицию курсора.
    QPlainTextEdit insertLines(string[] lines) {
        import std.array : join;
        insertPlainText(lines.join("\n"));
        return this;
    }

    /// cut
    QPlainTextEdit cut() {
        (cast(t_v__qp)pFunQt[5041])(_wh);
        return this;
    }

    /// copy
    QPlainTextEdit copy() {
        (cast(t_v__qp)pFunQt[5042])(_wh);
        return this;
    }

    /// paste
    QPlainTextEdit paste() {
        (cast(t_v__qp)pFunQt[5043])(_wh);
        return this;
    }

    /// undo
    QPlainTextEdit undo() {
        (cast(t_v__qp)pFunQt[5044])(_wh);
        return this;
    }

    /// redo
    QPlainTextEdit redo() {
        (cast(t_v__qp)pFunQt[5045])(_wh);
        return this;
    }

    /// clear
    QPlainTextEdit clear() {
        (cast(t_v__qp)pFunQt[5046])(_wh);
        return this;
    }

    /// selectAll
    QPlainTextEdit selectAll() {
        (cast(t_v__qp)pFunQt[5047])(_wh);
        return this;
    }

    /// insertPlainText
    QPlainTextEdit insertPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[5048])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// appendPlainText
    QPlainTextEdit appendPlainText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[5049])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// appendHtml
    QPlainTextEdit appendHtml(string html) {
        auto _ws_html = toQString(html);
        (cast(t_v__qp_qp)pFunQt[5050])(_wh, _ws_html);
        (cast(t_v__qp)pFunQt[22])(_ws_html);
        return this;
    }

    /// centerCursor
    QPlainTextEdit centerCursor() {
        (cast(t_v__qp)pFunQt[5051])(_wh);
        return this;
    }

    /// zoomIn
    QPlainTextEdit zoomIn(int range) {
        (cast(t_v__qp_i)pFunQt[5052])(_wh, range);
        return this;
    }

    /// zoomOut
    QPlainTextEdit zoomOut(int range) {
        (cast(t_v__qp_i)pFunQt[5053])(_wh, range);
        return this;
    }

    /// textCursor — returns a copy of the current QTextCursor
    void* textCursor() {
        return cast(void*)(cast(t_qp__qp)pFunQt[5055])(_wh);
    }

    /// setTextCursor — sets the visible cursor
    QPlainTextEdit setTextCursor(void* cursor) {
        (cast(t_v__qp_qp)pFunQt[5056])(_wh, cursor);
        return this;
    }

    /// Connect signal textChanged → ESlot
    QPlainTextEdit connect_textChanged(ESlot eslot) {
        connectQt(_wh, "textChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal undoAvailable → ESlot
    QPlainTextEdit connect_undoAvailable(ESlot eslot) {
        connectQt(_wh, "undoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal redoAvailable → ESlot
    QPlainTextEdit connect_redoAvailable(ESlot eslot) {
        connectQt(_wh, "redoAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal copyAvailable → ESlot
    QPlainTextEdit connect_copyAvailable(ESlot eslot) {
        connectQt(_wh, "copyAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal selectionChanged → ESlot
    QPlainTextEdit connect_selectionChanged(ESlot eslot) {
        connectQt(_wh, "selectionChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal cursorPositionChanged → ESlot
    QPlainTextEdit connect_cursorPositionChanged(ESlot eslot) {
        connectQt(_wh, "cursorPositionChanged()", eslot, "invoke_v()");
        return this;
    }

    // Signal updateRequest — unsupported parameter types
    /// Connect signal blockCountChanged → ESlot
    QPlainTextEdit connect_blockCountChanged(ESlot eslot) {
        connectQt(_wh, "blockCountChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal modificationChanged → ESlot
    QPlainTextEdit connect_modificationChanged(ESlot eslot) {
        connectQt(_wh, "modificationChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QPlainTextEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[5054])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPlainTextEdit onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPlainTextEdit onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QPlainTextEdit onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QPlainTextEdit onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QPlainTextEdit onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QPlainTextEdit onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QPlainTextEdit onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QPlainTextEdit onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QPlainTextEdit onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QPlainTextEdit onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QPlainTextEdit onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QPlainTextEdit onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QPlainTextEdit onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QPlainTextEdit onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QPlainTextEdit onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QPlainTextEdit onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QPlainTextEdit onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    // ── Full event handlers (id 19..25) ──────────────────────────────────────
    // См. описание в QWidget. Callback получает указатель на EventInfo-структуру
    // и возвращает int consumed (1 = обработано, 0 = passthrough к Qt-default).

    /// Qt event: wheelEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, WheelEventInfo* info)
    override QPlainTextEdit onWheelFull(void* cb, void* dthis = null) {
        setEventHandler(19, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QPlainTextEdit onMousePressFull(void* cb, void* dthis = null) {
        setEventHandler(20, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QPlainTextEdit onMouseReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(21, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QPlainTextEdit onMouseMoveFull(void* cb, void* dthis = null) {
        setEventHandler(22, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    override QPlainTextEdit onMouseDoubleClickFull(void* cb, void* dthis = null) {
        setEventHandler(23, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    override QPlainTextEdit onKeyPressFull(void* cb, void* dthis = null) {
        setEventHandler(24, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    override QPlainTextEdit onKeyReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(25, cb, dthis);
        return this;
    }

} // class QPlainTextEdit
