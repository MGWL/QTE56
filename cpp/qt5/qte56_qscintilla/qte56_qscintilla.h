#pragma once
#ifdef _WIN32
#  ifdef QTE56_QSCINTILLA_BUILD
#    define QSCI_API __declspec(dllexport)
#  else
#    define QSCI_API __declspec(dllimport)
#  endif
#else
#  define QSCI_API __attribute__((visibility("default")))
#endif
extern "C" {

// ── Core lifecycle ──────────────────────────────────────────────────────────
QSCI_API void* qteQsci_create(void* parent);
QSCI_API void  qteQsci_delete(void* sci);

// ── SendScintilla — universal access to all SCI_* messages ──────────────────
QSCI_API long  qteQsci_sendMsg(void* sci, unsigned int msg,
                                unsigned long wParam, long lParam);
QSCI_API long  qteQsci_sendMsgStr(void* sci, unsigned int msg,
                                    unsigned long wParam, const char* s);
QSCI_API long  qteQsci_sendMsgPtr(void* sci, unsigned int msg,
                                    unsigned long wParam, void* lParam);

// ── Text (convenience — wchar <-> QString conversion) ───────────────────────
QSCI_API void  qteQsci_setText(void* sci, void* text);
QSCI_API void* qteQsci_text(void* sci);
QSCI_API void  qteQsci_append(void* sci, void* text);
QSCI_API int   qteQsci_length(void* sci);
QSCI_API int   qteQsci_lines(void* sci);

// ── Widget settings ─────────────────────────────────────────────────────────
QSCI_API void  qteQsci_setFont(void* sci, void* font);
QSCI_API void  qteQsci_setReadOnly(void* sci, int ro);
QSCI_API void  qteQsci_setMarginWidth(void* sci, int margin, int pixels);
QSCI_API void  qteQsci_setFolding(void* sci, int style);
QSCI_API void  qteQsci_setBraceMatching(void* sci, int mode);
QSCI_API void  qteQsci_setIndentationsUseTabs(void* sci, int use);
QSCI_API void  qteQsci_setIndentationWidth(void* sci, int width);
QSCI_API void  qteQsci_setTabWidth(void* sci, int width);
QSCI_API void  qteQsci_setAutoIndent(void* sci, int enable);
QSCI_API void  qteQsci_setUtf8(void* sci, int enable);
QSCI_API void  qteQsci_setEolMode(void* sci, int mode);
QSCI_API void  qteQsci_setCaretLineVisible(void* sci, int enable);
QSCI_API void  qteQsci_setCaretLineBackgroundColor(void* sci, unsigned int rgba);
QSCI_API void  qteQsci_setMarginsBackgroundColor(void* sci, unsigned int rgba);
QSCI_API void  qteQsci_setMarginsForegroundColor(void* sci, unsigned int rgba);

// ── Lexer management ────────────────────────────────────────────────────────
QSCI_API void  qteQsci_setLexer(void* sci, void* lexer);
QSCI_API void* qteQsci_createLexerCPP();
QSCI_API void* qteQsci_createLexerPython();
QSCI_API void* qteQsci_createLexerD();
QSCI_API void* qteQsci_createLexerSQL();
QSCI_API void* qteQsci_createLexerJSON();
QSCI_API void* qteQsci_createLexerBash();
QSCI_API void* qteQsci_createLexerBatch();
QSCI_API void  qteQsci_deleteLexer(void* lexer);

// ── Lexer styling ───────────────────────────────────────────────────────────
QSCI_API void  qteQsci_lexerSetDefaultFont(void* lexer, void* font);
QSCI_API void  qteQsci_lexerSetDefaultColor(void* lexer, unsigned int rgba);
QSCI_API void  qteQsci_lexerSetDefaultPaper(void* lexer, unsigned int rgba);
QSCI_API void  qteQsci_lexerSetColor(void* lexer, int style, unsigned int rgba);
QSCI_API void  qteQsci_lexerSetPaper(void* lexer, int style, unsigned int rgba);
QSCI_API void  qteQsci_lexerSetFont(void* lexer, int style, void* font);

// ── Find / Replace (19738–19740) ─────────────────────────────────────────────
QSCI_API int   qteQsci_findFirst(void* sci, void* text,
                                  int regexp, int caseSens, int wholeWord,
                                  int wrap, int forward, int line, int col);
QSCI_API int   qteQsci_findNext(void* sci);
QSCI_API void  qteQsci_replace(void* sci, void* text);

// ── QsciAPIs — autocomplete word lists (19741–19747) ─────────────────────────
QSCI_API void* qteQsci_apisCreate(void* lexer);
QSCI_API void  qteQsci_apisDelete(void* apis);
QSCI_API void  qteQsci_apisAdd(void* apis, void* text);
QSCI_API void  qteQsci_apisPrepare(void* apis);
QSCI_API void  qteQsci_lexerSetAPIs(void* lexer, void* apis);
QSCI_API void  qteQsci_setAutoCompletionSource(void* sci, int src);
QSCI_API void  qteQsci_setAutoCompletionThreshold(void* sci, int thresh);

} // extern "C"
