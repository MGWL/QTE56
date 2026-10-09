/**
 * gen_qscintilla.d — D wrapper for QScintilla (Variant C: thin wrapper + sendMsg).
 * Module: QScintilla | DLL: qte56_qscintilla.dll
 * MANUALLY WRITTEN
 *
 * Index block: 19700–19747 (48 functions)
 *
 * QsciScintilla : QAbstractScrollArea — inherits all QWidget methods.
 * Core design: sendMsg() for universal SCI_* access, plus convenience methods
 * for text, settings, and lexer management.
 *
 * Lexers with Qt wrappers: C++, D, Python, SQL, JSON.
 * VBA: via sendMsg(SCI_SETLEXER, SCLEX_VB) — see setupVBA().
 *
 * Usage:
 *   auto sci = new QsciScintilla(win.getWH());
 *   sci.setUtf8(true);
 *   sci.setMarginWidth(0, 40);
 *   sci.setFolding(SciFolding.BoxedTreeFoldStyle);
 *   auto lex = sci.createLexerD();
 *   sci.setLexer(lex);
 *   sci.setText("void main() {}");
 */
module gen_qscintilla;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qabstractscrollarea : QAbstractScrollArea;

// New type aliases for QScintilla
mixin(generateAlias("i__qp_i_i_i"));    // sendMsg: int(void*, int, int, int)
mixin(generateAlias("i__qp_i_i_cp"));   // sendMsgStr: int(void*, int, int, const(char)*)
mixin(generateAlias("i__qp_i_i_qp"));   // sendMsgPtr: int(void*, int, int, void*)
mixin(generateAlias("v__qp_qp"));       // setFont/setLexer: void(void*, void*)
mixin(generateAlias("v__qp_i_qp"));     // lexerSetFont: void(void*, int, void*)

// Local alias for no-arg factory functions returning void*
private alias fn_qp_noargs = extern(C) @nogc void* function();

// findFirst: int(void* sci, void* text(QString*), int regexp, int caseSens, int wholeWord, int wrap, int forward, int line, int col)
private alias fn_findFirst = extern(C) @nogc int function(
    void* sci, void* text,
    int regexp, int caseSens, int wholeWord,
    int wrap, int forward, int line, int col);

// ====================================================================
// Module registration & function loading
// ====================================================================

static this() {
    registerModule("QScintilla", "qte56_qscintilla.dll", &loadQScintilla);
}

void loadQScintilla() {
    // Core lifecycle (19700–19701)
    mixin(generateFunQt(19700, "qteQsci_create",  "QScintilla"));
    mixin(generateFunQt(19701, "qteQsci_delete",  "QScintilla"));

    // SendScintilla (19702–19704)
    mixin(generateFunQt(19702, "qteQsci_sendMsg",    "QScintilla"));
    mixin(generateFunQt(19703, "qteQsci_sendMsgStr", "QScintilla"));
    mixin(generateFunQt(19704, "qteQsci_sendMsgPtr", "QScintilla"));

    // Text (19705–19709)
    mixin(generateFunQt(19705, "qteQsci_setText",  "QScintilla"));
    mixin(generateFunQt(19706, "qteQsci_text",     "QScintilla"));
    mixin(generateFunQt(19707, "qteQsci_append",   "QScintilla"));
    mixin(generateFunQt(19708, "qteQsci_length",   "QScintilla"));
    mixin(generateFunQt(19709, "qteQsci_lines",    "QScintilla"));

    // Widget settings (19710–19724)
    mixin(generateFunQt(19710, "qteQsci_setFont",                    "QScintilla"));
    mixin(generateFunQt(19711, "qteQsci_setReadOnly",                "QScintilla"));
    mixin(generateFunQt(19712, "qteQsci_setMarginWidth",             "QScintilla"));
    mixin(generateFunQt(19713, "qteQsci_setFolding",                 "QScintilla"));
    mixin(generateFunQt(19714, "qteQsci_setBraceMatching",           "QScintilla"));
    mixin(generateFunQt(19715, "qteQsci_setIndentationsUseTabs",     "QScintilla"));
    mixin(generateFunQt(19716, "qteQsci_setIndentationWidth",        "QScintilla"));
    mixin(generateFunQt(19717, "qteQsci_setTabWidth",                "QScintilla"));
    mixin(generateFunQt(19718, "qteQsci_setAutoIndent",              "QScintilla"));
    mixin(generateFunQt(19719, "qteQsci_setUtf8",                    "QScintilla"));
    mixin(generateFunQt(19720, "qteQsci_setEolMode",                 "QScintilla"));
    mixin(generateFunQt(19721, "qteQsci_setCaretLineVisible",        "QScintilla"));
    mixin(generateFunQt(19722, "qteQsci_setCaretLineBackgroundColor","QScintilla"));
    mixin(generateFunQt(19723, "qteQsci_setMarginsBackgroundColor",  "QScintilla"));
    mixin(generateFunQt(19724, "qteQsci_setMarginsForegroundColor",  "QScintilla"));

    // Lexer management (19725–19731)
    mixin(generateFunQt(19725, "qteQsci_setLexer",         "QScintilla"));
    mixin(generateFunQt(19726, "qteQsci_createLexerCPP",   "QScintilla"));
    mixin(generateFunQt(19727, "qteQsci_createLexerPython", "QScintilla"));
    mixin(generateFunQt(19728, "qteQsci_createLexerD",     "QScintilla"));
    mixin(generateFunQt(19729, "qteQsci_createLexerSQL",   "QScintilla"));
    mixin(generateFunQt(19730, "qteQsci_createLexerJSON",  "QScintilla"));
    mixin(generateFunQt(19731, "qteQsci_deleteLexer",      "QScintilla"));

    // Lexer styling (19732–19737)
    mixin(generateFunQt(19732, "qteQsci_lexerSetDefaultFont",  "QScintilla"));
    mixin(generateFunQt(19733, "qteQsci_lexerSetDefaultColor", "QScintilla"));
    mixin(generateFunQt(19734, "qteQsci_lexerSetDefaultPaper", "QScintilla"));
    mixin(generateFunQt(19735, "qteQsci_lexerSetColor",        "QScintilla"));
    mixin(generateFunQt(19736, "qteQsci_lexerSetPaper",        "QScintilla"));
    mixin(generateFunQt(19737, "qteQsci_lexerSetFont",         "QScintilla"));

    // Find / Replace (19738–19740)
    mixin(generateFunQt(19738, "qteQsci_findFirst",  "QScintilla"));
    mixin(generateFunQt(19739, "qteQsci_findNext",   "QScintilla"));
    mixin(generateFunQt(19740, "qteQsci_replace",    "QScintilla"));

    // QsciAPIs — autocomplete (19741–19747)
    mixin(generateFunQt(19741, "qteQsci_apisCreate",                 "QScintilla"));
    mixin(generateFunQt(19742, "qteQsci_apisDelete",                 "QScintilla"));
    mixin(generateFunQt(19743, "qteQsci_apisAdd",                    "QScintilla"));
    mixin(generateFunQt(19744, "qteQsci_apisPrepare",                "QScintilla"));
    mixin(generateFunQt(19745, "qteQsci_lexerSetAPIs",               "QScintilla"));
    mixin(generateFunQt(19746, "qteQsci_setAutoCompletionSource",    "QScintilla"));
    mixin(generateFunQt(19747, "qteQsci_setAutoCompletionThreshold", "QScintilla"));

    // Extra lexers: Bash, Batch (20003–20004)
    mixin(generateFunQt(20003, "qteQsci_createLexerBash",  "QScintilla"));
    mixin(generateFunQt(20004, "qteQsci_createLexerBatch", "QScintilla"));
}

// ====================================================================
// QsciScintilla — code editor widget
// ====================================================================

@live class QsciScintilla : QAbstractScrollArea {
public:
    /// Create QsciScintilla. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[19700])(parent);
    }

    /// No-op constructor for potential subclassing.
    protected this(bool _noOp) { super(_noOp); }

    // ── SendScintilla — universal SCI_* access ──────────────────────────────

    /// Send a Scintilla message with integer params. Heart of Variant C.
    int sendMsg(uint msg, uint wParam = 0, int lParam = 0) {
        return (cast(t_i__qp_i_i_i)pFunQt[19702])(
            _wh, cast(int)msg, cast(int)wParam, lParam);
    }

    /// Send a Scintilla message with string lParam (auto null-terminated).
    int sendMsgStr(uint msg, uint wParam, string s) {
        import std.string : toStringz;
        return (cast(t_i__qp_i_i_cp)pFunQt[19703])(
            _wh, cast(int)msg, cast(int)wParam, s.toStringz);
    }

    /// Send a Scintilla message with pointer lParam.
    int sendMsgPtr(uint msg, uint wParam, void* lParam) {
        return (cast(t_i__qp_i_i_qp)pFunQt[19704])(
            _wh, cast(int)msg, cast(int)wParam, lParam);
    }

    // ── Text (convenience) ──────────────────────────────────────────────────

    /// Set entire text content. Accepts D string (auto wchar conversion).
    QsciScintilla setText(string s) {
        auto _w = toQString(s);
        (cast(t_v__qp_qp)pFunQt[19705])(_wh, _w);
        (cast(t_v__qp)pFunQt[22])(_w);
        return this;
    }

    /// Get entire text content as D string.
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[19706])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs); // qteQString_free
        return _r;
    }

    /// Append text.
    QsciScintilla append(string s) {
        auto _w = toQString(s);
        (cast(t_v__qp_qp)pFunQt[19707])(_wh, _w);
        (cast(t_v__qp)pFunQt[22])(_w);
        return this;
    }

    /// Text length in bytes (UTF-8).
    int length() {
        return (cast(t_i__qp)pFunQt[19708])(_wh);
    }

    /// Number of lines.
    int lines() {
        return (cast(t_i__qp)pFunQt[19709])(_wh);
    }

    // ── Widget settings ─────────────────────────────────────────────────────

    /// Set font for the editor. Pass font.getWH().
    QsciScintilla setEditorFont(void* font) {
        (cast(t_v__qp_qp)pFunQt[19710])(_wh, font);
        return this;
    }

    /// Set read-only mode.
    QsciScintilla setReadOnly(bool ro) {
        (cast(t_v__qp_i)pFunQt[19711])(_wh, ro ? 1 : 0);
        return this;
    }

    /// Set margin width in pixels. margin=0 is line numbers.
    QsciScintilla setMarginWidth(int margin, int pixels) {
        (cast(t_v__qp_i_i)pFunQt[19712])(_wh, margin, pixels);
        return this;
    }

    /// Set folding style. See SciFolding enum.
    QsciScintilla setFolding(int style) {
        (cast(t_v__qp_i)pFunQt[19713])(_wh, style);
        return this;
    }

    /// Set brace matching mode. See SciBraceMatch enum.
    QsciScintilla setBraceMatching(int mode) {
        (cast(t_v__qp_i)pFunQt[19714])(_wh, mode);
        return this;
    }

    /// Use tabs for indentation (true) or spaces (false).
    QsciScintilla setIndentationsUseTabs(bool use) {
        (cast(t_v__qp_i)pFunQt[19715])(_wh, use ? 1 : 0);
        return this;
    }

    /// Set indentation width in characters.
    QsciScintilla setIndentationWidth(int width) {
        (cast(t_v__qp_i)pFunQt[19716])(_wh, width);
        return this;
    }

    /// Set tab display width.
    QsciScintilla setTabWidth(int width) {
        (cast(t_v__qp_i)pFunQt[19717])(_wh, width);
        return this;
    }

    /// Enable/disable auto-indentation.
    QsciScintilla setAutoIndent(bool enable) {
        (cast(t_v__qp_i)pFunQt[19718])(_wh, enable ? 1 : 0);
        return this;
    }

    /// Enable/disable UTF-8 mode.
    QsciScintilla setUtf8(bool enable) {
        (cast(t_v__qp_i)pFunQt[19719])(_wh, enable ? 1 : 0);
        return this;
    }

    /// Set end-of-line mode (0=Windows CRLF, 1=Unix LF, 2=Mac CR).
    QsciScintilla setEolMode(int mode) {
        (cast(t_v__qp_i)pFunQt[19720])(_wh, mode);
        return this;
    }

    /// Show/hide caret (current) line highlight.
    QsciScintilla setCaretLineVisible(bool enable) {
        (cast(t_v__qp_i)pFunQt[19721])(_wh, enable ? 1 : 0);
        return this;
    }

    /// Set caret line background color (RGBA packed as 0xRRGGBBAA).
    QsciScintilla setCaretLineBackgroundColor(uint rgba) {
        (cast(t_v__qp_i)pFunQt[19722])(_wh, cast(int)rgba);
        return this;
    }

    /// Set margins background color (RGBA).
    QsciScintilla setMarginsBackgroundColor(uint rgba) {
        (cast(t_v__qp_i)pFunQt[19723])(_wh, cast(int)rgba);
        return this;
    }

    /// Set margins foreground (text) color (RGBA).
    QsciScintilla setMarginsForegroundColor(uint rgba) {
        (cast(t_v__qp_i)pFunQt[19724])(_wh, cast(int)rgba);
        return this;
    }

    // ── Lexer management ────────────────────────────────────────────────────

    /// Set lexer on this editor. Pass handle from createLexerXxx().
    /// The lexer must outlive the editor (not auto-deleted).
    QsciScintilla setLexer(void* lexer) {
        (cast(t_v__qp_qp)pFunQt[19725])(_wh, lexer);
        return this;
    }

    /// Create a C++ lexer. Returns opaque handle. Free with deleteLexer().
    static void* createLexerCPP() {
        return (cast(fn_qp_noargs)pFunQt[19726])();
    }

    /// Create a Python lexer.
    static void* createLexerPython() {
        return (cast(fn_qp_noargs)pFunQt[19727])();
    }

    /// Create a D lexer.
    static void* createLexerD() {
        return (cast(fn_qp_noargs)pFunQt[19728])();
    }

    /// Create a SQL lexer.
    static void* createLexerSQL() {
        return (cast(fn_qp_noargs)pFunQt[19729])();
    }

    /// Create a JSON lexer.
    static void* createLexerJSON() {
        return (cast(fn_qp_noargs)pFunQt[19730])();
    }

    /// Create a Bash/Shell lexer.
    static void* createLexerBash() {
        return (cast(fn_qp_noargs)pFunQt[20003])();
    }

    /// Create a Windows Batch lexer.
    static void* createLexerBatch() {
        return (cast(fn_qp_noargs)pFunQt[20004])();
    }

    /// Delete a lexer handle. Only call after removing from editor.
    static void deleteLexer(void* lexer) {
        (cast(t_v__qp)pFunQt[19731])(lexer);
    }

    // ── Lexer styling ───────────────────────────────────────────────────────

    /// Set default font for lexer. Pass font.getWH().
    static void lexerSetDefaultFont(void* lexer, void* font) {
        (cast(t_v__qp_qp)pFunQt[19732])(lexer, font);
    }

    /// Set default foreground color for lexer (RGBA).
    static void lexerSetDefaultColor(void* lexer, uint rgba) {
        (cast(t_v__qp_i)pFunQt[19733])(lexer, cast(int)rgba);
    }

    /// Set default background (paper) color for lexer (RGBA).
    static void lexerSetDefaultPaper(void* lexer, uint rgba) {
        (cast(t_v__qp_i)pFunQt[19734])(lexer, cast(int)rgba);
    }

    /// Set foreground color for a specific style (RGBA).
    static void lexerSetColor(void* lexer, int style, uint rgba) {
        (cast(t_v__qp_i_i)pFunQt[19735])(lexer, style, cast(int)rgba);
    }

    /// Set background (paper) color for a specific style (RGBA).
    static void lexerSetPaper(void* lexer, int style, uint rgba) {
        (cast(t_v__qp_i_i)pFunQt[19736])(lexer, style, cast(int)rgba);
    }

    /// Set font for a specific style. Pass font.getWH().
    static void lexerSetFont(void* lexer, int style, void* font) {
        (cast(t_v__qp_i_qp)pFunQt[19737])(lexer, style, font);
    }

    // ── Find / Replace ──────────────────────────────────────────────────────

    /// Find text. Returns true if found; selection is placed on match.
    /// regexp/caseSensitive/wholeWord: false by default.
    /// wrap: start over from beginning if not found. forward: search direction.
    /// line/col: starting position (-1 = current caret).
    final bool findFirst(string text,
                   bool regexp = false, bool caseSensitive = false,
                   bool wholeWord = false, bool wrap = true,
                   bool forward = true, int line = -1, int col = -1) {
        auto _w = toQString(text);
        int r = (cast(fn_findFirst)pFunQt[19738])(
            _wh, _w,
            regexp?1:0, caseSensitive?1:0, wholeWord?1:0,
            wrap?1:0, forward?1:0, line, col) != 0;
        (cast(t_v__qp)pFunQt[22])(_w);
        return r != 0;
    }

    /// Find next occurrence (after findFirst returned true).
    final bool findNext() {
        return (cast(t_i__qp)pFunQt[19739])(_wh) != 0;
    }

    /// Replace current selection (the match found by findFirst/findNext).
    final void replace(string text) {
        auto _w = toQString(text);
        (cast(t_v__qp_qp)pFunQt[19740])(_wh, _w);
        (cast(t_v__qp)pFunQt[22])(_w);
    }

    // ── Autocomplete ────────────────────────────────────────────────────────

    /// Set source for autocomplete popup.
    /// src: SciAutoComplete.AcsNone/AcsAll/AcsDocument/AcsAPIs.
    QsciScintilla setAutoCompletionSource(int src) {
        (cast(t_v__qp_i)pFunQt[19746])(_wh, src);
        return this;
    }

    /// Set number of characters to type before popup appears (default 2).
    QsciScintilla setAutoCompletionThreshold(int threshold) {
        (cast(t_v__qp_i)pFunQt[19747])(_wh, threshold);
        return this;
    }

    // ── VBA setup (D-only, no C++ lexer wrapper) ────────────────────────────

    /// Configure VBA/VBScript syntax highlighting via raw Scintilla messages.
    /// Uses SCLEX_VB lexer (LexVB.cpp is built into qscintilla2_qt5.dll).
    QsciScintilla setupVBA() {
        import qte56_enums : SCI, SCLEX, SCE_B;

        // Set VB lexer
        sendMsg(SCI.SCI_SETLEXER, SCLEX.SCLEX_VB, 0);

        // VBA keywords (set 0)
        sendMsgStr(SCI.SCI_SETKEYWORDS, 0,
            "and as boolean byref byval call case close const currency "
            ~ "date declare dim do double each else elseif empty end enum "
            ~ "erase error event exit explicit false for friend function "
            ~ "get global gosub goto if imp implements in input integer is "
            ~ "kill let lib like load lock long loop lset me mid mod "
            ~ "new next not nothing null object on open option optional or "
            ~ "paramarray preserve print private property public "
            ~ "raiseevent randomize redim rem resume return rset seek "
            ~ "select set single static step stop string sub then to true "
            ~ "type unload until variant wend while with withevents xor");

        // Style colors (Scintilla 0xBBGGRR format)
        enum : int {
            clrBlack    = 0x000000,
            clrGreen    = 0x008000, // dark green — comments
            clrNavy     = 0x800000, // dark blue  — keywords
            clrMaroon   = 0x000080, // dark red   — strings
            clrTeal     = 0x808000, // teal       — numbers
        }

        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_DEFAULT,    clrBlack);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_COMMENT,    clrGreen);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_NUMBER,     clrTeal);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_KEYWORD,    clrNavy);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_STRING,     clrMaroon);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_OPERATOR,   clrBlack);
        sendMsg(SCI.SCI_STYLESETFORE, SCE_B.SCE_B_IDENTIFIER, clrBlack);

        // Bold keywords
        sendMsg(SCI.SCI_STYLESETBOLD, SCE_B.SCE_B_KEYWORD, 1);
        return this;
    }

    /// Attach a QsciAPIs word list to a lexer.
    /// Call before sci.setLexer(). APIs object must outlive the lexer.
    static void lexerSetAPIs(void* lexer, void* apisHandle) {
        (cast(t_v__qp_qp)pFunQt[19745])(lexer, apisHandle);
    }

} // class QsciScintilla

// ====================================================================
// QsciAPIs — autocomplete word list
// ====================================================================

/// Autocomplete word list for a lexer.
/// Attach to a lexer via QsciScintilla.lexerSetAPIs(), then enable
/// autocomplete with sci.setAutoCompletionSource(SciAutoComplete.AcsAPIs).
///
/// Example:
///   auto lexD = QsciScintilla.createLexerD();
///   auto apis = new QsciAPIs(lexD);
///   apis.add("writeln"); apis.add("writefln");
///   apis.prepare();
///   QsciScintilla.lexerSetAPIs(lexD, apis.getHandle());
///   sci.setLexer(lexD);
///   sci.setAutoCompletionSource(SciAutoComplete.AcsAPIs);
///   sci.setAutoCompletionThreshold(2);
@live class QsciAPIs {
private:
    void* _handle;

public:
    /// Create word list attached to lexer. lexer handle must outlive this object.
    this(void* lexerHandle) {
        _handle = (cast(t_qp__qp)pFunQt[19741])(lexerHandle);
    }

    /// Return opaque C++ handle (for lexerSetAPIs).
    void* getHandle() { return _handle; }

    /// Add a word (or "word(args...)" with signature) to the list.
    QsciAPIs add(string word) {
        auto _w = toQString(word);
        (cast(t_v__qp_qp)pFunQt[19743])(_handle, _w);
        (cast(t_v__qp)pFunQt[22])(_w);
        return this;
    }

    /// Build the lookup index. Call once after all add() calls.
    /// Note: runs asynchronously in background thread; autocomplete
    /// becomes active a moment after prepare() returns.
    QsciAPIs prepare() {
        (cast(t_v__qp)pFunQt[19744])(_handle);
        return this;
    }

    /// Destroy the word list. Call after detaching from lexer (setLexer(null)).
    QsciAPIs deleteAPIs() {
        if (_handle) {
            (cast(t_v__qp)pFunQt[19742])(_handle);
            _handle = null;
        }
        return this;
    }
}
