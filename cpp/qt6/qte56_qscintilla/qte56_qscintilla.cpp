#include "qte56_qscintilla.h"

#include <Qsci/qsciscintilla.h>
#include <Qsci/qscilexercpp.h>
#include <Qsci/qscilexerpython.h>
#include <Qsci/qscilexerd.h>
#include <Qsci/qscilexersql.h>
#include <Qsci/qscilexerjson.h>
#include <Qsci/qscilexerbash.h>
#include <Qsci/qscilexerbatch.h>
#include <Qsci/qsciapis.h>

#include <QWidget>
#include <QFont>
#include <QColor>
#include <QString>

// Helper: QColor from packed RGBA (0xRRGGBBAA)
static inline QColor colorFromRgba(unsigned int rgba) {
    return QColor::fromRgba(rgba);
}

// ── Core lifecycle ──────────────────────────────────────────────────────────

void* qteQsci_create(void* parent) {
    return new QsciScintilla((QWidget*)parent);
}

void qteQsci_delete(void* sci) {
    delete (QsciScintilla*)sci;
}

// ── SendScintilla ───────────────────────────────────────────────────────────

long qteQsci_sendMsg(void* sci, unsigned int msg,
                      unsigned long wParam, long lParam) {
    return ((QsciScintilla*)sci)->SendScintilla(msg, wParam, lParam);
}

long qteQsci_sendMsgStr(void* sci, unsigned int msg,
                          unsigned long wParam, const char* s) {
    return ((QsciScintilla*)sci)->SendScintilla(msg, (uintptr_t)wParam, s);
}

long qteQsci_sendMsgPtr(void* sci, unsigned int msg,
                          unsigned long wParam, void* lParam) {
    return ((QsciScintilla*)sci)->SendScintilla(msg, wParam, lParam);
}

// ── Text ────────────────────────────────────────────────────────────────────

void qteQsci_setText(void* sci, void* text) {
    ((QsciScintilla*)sci)->setText(*(QString*)text);
}

void* qteQsci_text(void* sci) {
    return new QString(((QsciScintilla*)sci)->text());
}

void qteQsci_append(void* sci, void* text) {
    ((QsciScintilla*)sci)->append(*(QString*)text);
}

int qteQsci_length(void* sci) {
    return ((QsciScintilla*)sci)->length();
}

int qteQsci_lines(void* sci) {
    return ((QsciScintilla*)sci)->lines();
}

// ── Widget settings ─────────────────────────────────────────────────────────

void qteQsci_setFont(void* sci, void* font) {
    ((QsciScintilla*)sci)->setFont(*(QFont*)font);
}

void qteQsci_setReadOnly(void* sci, int ro) {
    ((QsciScintilla*)sci)->setReadOnly(ro != 0);
}

void qteQsci_setMarginWidth(void* sci, int margin, int pixels) {
    ((QsciScintilla*)sci)->setMarginWidth(margin, pixels);
}

void qteQsci_setFolding(void* sci, int style) {
    ((QsciScintilla*)sci)->setFolding((QsciScintilla::FoldStyle)style);
}

void qteQsci_setBraceMatching(void* sci, int mode) {
    ((QsciScintilla*)sci)->setBraceMatching((QsciScintilla::BraceMatch)mode);
}

void qteQsci_setIndentationsUseTabs(void* sci, int use) {
    ((QsciScintilla*)sci)->setIndentationsUseTabs(use != 0);
}

void qteQsci_setIndentationWidth(void* sci, int width) {
    ((QsciScintilla*)sci)->setIndentationWidth(width);
}

void qteQsci_setTabWidth(void* sci, int width) {
    ((QsciScintilla*)sci)->setTabWidth(width);
}

void qteQsci_setAutoIndent(void* sci, int enable) {
    ((QsciScintilla*)sci)->setAutoIndent(enable != 0);
}

void qteQsci_setUtf8(void* sci, int enable) {
    ((QsciScintilla*)sci)->setUtf8(enable != 0);
}

void qteQsci_setEolMode(void* sci, int mode) {
    ((QsciScintilla*)sci)->setEolMode((QsciScintilla::EolMode)mode);
}

void qteQsci_setCaretLineVisible(void* sci, int enable) {
    ((QsciScintilla*)sci)->setCaretLineVisible(enable != 0);
}

void qteQsci_setCaretLineBackgroundColor(void* sci, unsigned int rgba) {
    ((QsciScintilla*)sci)->setCaretLineBackgroundColor(colorFromRgba(rgba));
}

void qteQsci_setMarginsBackgroundColor(void* sci, unsigned int rgba) {
    ((QsciScintilla*)sci)->setMarginsBackgroundColor(colorFromRgba(rgba));
}

void qteQsci_setMarginsForegroundColor(void* sci, unsigned int rgba) {
    ((QsciScintilla*)sci)->setMarginsForegroundColor(colorFromRgba(rgba));
}

// ── Lexer management ────────────────────────────────────────────────────────

void qteQsci_setLexer(void* sci, void* lexer) {
    ((QsciScintilla*)sci)->setLexer((QsciLexer*)lexer);
}

void* qteQsci_createLexerCPP()    { return new QsciLexerCPP(); }
void* qteQsci_createLexerPython() { return new QsciLexerPython(); }
void* qteQsci_createLexerD()      { return new QsciLexerD(); }
void* qteQsci_createLexerSQL()    { return new QsciLexerSQL(); }
void* qteQsci_createLexerJSON()   { return new QsciLexerJSON(); }
void* qteQsci_createLexerBash()   { return new QsciLexerBash(); }
void* qteQsci_createLexerBatch()  { return new QsciLexerBatch(); }

void qteQsci_deleteLexer(void* lexer) {
    delete (QsciLexer*)lexer;
}

// ── Lexer styling ───────────────────────────────────────────────────────────

void qteQsci_lexerSetDefaultFont(void* lexer, void* font) {
    ((QsciLexer*)lexer)->setDefaultFont(*(QFont*)font);
}

void qteQsci_lexerSetDefaultColor(void* lexer, unsigned int rgba) {
    ((QsciLexer*)lexer)->setDefaultColor(colorFromRgba(rgba));
}

void qteQsci_lexerSetDefaultPaper(void* lexer, unsigned int rgba) {
    ((QsciLexer*)lexer)->setDefaultPaper(colorFromRgba(rgba));
}

void qteQsci_lexerSetColor(void* lexer, int style, unsigned int rgba) {
    ((QsciLexer*)lexer)->setColor(colorFromRgba(rgba), style);
}

void qteQsci_lexerSetPaper(void* lexer, int style, unsigned int rgba) {
    ((QsciLexer*)lexer)->setPaper(colorFromRgba(rgba), style);
}

void qteQsci_lexerSetFont(void* lexer, int style, void* font) {
    ((QsciLexer*)lexer)->setFont(*(QFont*)font, style);
}

// ── Find / Replace ───────────────────────────────────────────────────────────

// Find state (cross-platform, avoids QsciScintilla::findState corruption on 64-bit)
static QByteArray  g_lastFindText;
static int         g_lastFindFlags   = 0;
static bool        g_lastFindWrap    = true;
static bool        g_lastFindForward = true;

static int sciFindInRange(QsciScintillaBase* s, int start, int end,
                          const char* txt, int len) {
    s->SendScintilla(QsciScintillaBase::SCI_SETTARGETSTART, (unsigned long)start);
    s->SendScintilla(QsciScintillaBase::SCI_SETTARGETEND,   (unsigned long)end);
    return (int)s->SendScintilla(QsciScintillaBase::SCI_SEARCHINTARGET,
                                 (unsigned long)len, txt);
}

int qteQsci_findFirst(void* sci, void* text,
                       int regexp, int caseSens, int wholeWord,
                       int wrap, int forward, int /*line*/, int /*col*/) {
    QsciScintillaBase* s = (QsciScintillaBase*)sci;

    QByteArray ba = ((QString*)text)->toUtf8();
    const char* txt = ba.constData();
    int len = ba.length();

    int flags = 0;
    if (regexp)    flags |= QsciScintillaBase::SCFIND_REGEXP;
    if (caseSens)  flags |= QsciScintillaBase::SCFIND_MATCHCASE;
    if (wholeWord) flags |= QsciScintillaBase::SCFIND_WHOLEWORD;
    s->SendScintilla(QsciScintillaBase::SCI_SETSEARCHFLAGS, (unsigned long)flags);

    int curPos = (int)s->SendScintilla(QsciScintillaBase::SCI_GETCURRENTPOS);
    int docLen = (int)s->SendScintilla(QsciScintillaBase::SCI_GETLENGTH);
    int start  = forward ? curPos : (curPos > 0 ? curPos - 1 : 0);
    int end    = forward ? docLen : 0;

    int pos = sciFindInRange(s, start, end, txt, len);
    if (pos == -1 && wrap)
        pos = sciFindInRange(s, forward ? 0 : docLen,
                                forward ? docLen : 0, txt, len);
    if (pos == -1) return 0;

    g_lastFindText    = ba;
    g_lastFindFlags   = flags;
    g_lastFindWrap    = wrap != 0;
    g_lastFindForward = forward != 0;

    int targStart = (int)s->SendScintilla(QsciScintillaBase::SCI_GETTARGETSTART);
    int targEnd   = (int)s->SendScintilla(QsciScintillaBase::SCI_GETTARGETEND);
    s->SendScintilla(QsciScintillaBase::SCI_SETSEL,
                     (unsigned long)targStart, (long)targEnd);
    s->SendScintilla(QsciScintillaBase::SCI_SCROLLCARET);
    return 1;
}

int qteQsci_findNext(void* sci) {
    if (g_lastFindText.isEmpty()) return 0;
    QsciScintillaBase* s = (QsciScintillaBase*)sci;

    s->SendScintilla(QsciScintillaBase::SCI_SETSEARCHFLAGS,
                     (unsigned long)g_lastFindFlags);
    int curPos = g_lastFindForward
        ? (int)s->SendScintilla(QsciScintillaBase::SCI_GETSELECTIONEND)
        : (int)s->SendScintilla(QsciScintillaBase::SCI_GETSELECTIONSTART) - 1;
    if (curPos < 0) curPos = 0;
    int docLen = (int)s->SendScintilla(QsciScintillaBase::SCI_GETLENGTH);

    int pos = sciFindInRange(s, curPos, g_lastFindForward ? docLen : 0,
                             g_lastFindText.constData(), g_lastFindText.length());
    if (pos == -1 && g_lastFindWrap)
        pos = sciFindInRange(s, g_lastFindForward ? 0 : docLen,
                                g_lastFindForward ? docLen : 0,
                             g_lastFindText.constData(), g_lastFindText.length());
    if (pos == -1) return 0;

    int targStart = (int)s->SendScintilla(QsciScintillaBase::SCI_GETTARGETSTART);
    int targEnd   = (int)s->SendScintilla(QsciScintillaBase::SCI_GETTARGETEND);
    s->SendScintilla(QsciScintillaBase::SCI_SETSEL,
                     (unsigned long)targStart, (long)targEnd);
    s->SendScintilla(QsciScintillaBase::SCI_SCROLLCARET);
    return 1;
}

void qteQsci_replace(void* sci, void* text) {
    ((QsciScintilla*)sci)->replace(*(QString*)text);
}

// ── QsciAPIs — autocomplete word lists ───────────────────────────────────────

void* qteQsci_apisCreate(void* lexer) {
    return new QsciAPIs((QsciLexer*)lexer);
}

void qteQsci_apisDelete(void* apis) {
    delete (QsciAPIs*)apis;
}

void qteQsci_apisAdd(void* apis, void* text) {
    ((QsciAPIs*)apis)->add(*(QString*)text);
}

void qteQsci_apisPrepare(void* apis) {
    ((QsciAPIs*)apis)->prepare();
}

void qteQsci_lexerSetAPIs(void* lexer, void* apis) {
    ((QsciLexer*)lexer)->setAPIs((QsciAPIs*)apis);
}

void qteQsci_setAutoCompletionSource(void* sci, int src) {
    ((QsciScintilla*)sci)->setAutoCompletionSource(
        (QsciScintilla::AutoCompletionSource)src);
}

void qteQsci_setAutoCompletionThreshold(void* sci, int thresh) {
    ((QsciScintilla*)sci)->setAutoCompletionThreshold(thresh);
}
