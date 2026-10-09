#pragma once

#include <QSyntaxHighlighter>
#include <QTextDocument>
#include <QString>

#ifdef _WIN32
  #ifdef QTE56_QSYNTAXHIGHLIGHTER_BUILD
    #define QSYNTAXHIGHLIGHTER_API __declspec(dllexport)
  #else
    #define QSYNTAXHIGHLIGHTER_API __declspec(dllimport)
  #endif
#else
  #define QSYNTAXHIGHLIGHTER_API __attribute__((visibility("default")))
#endif

// ─── Callback type: void(dthis, hl_ptr, char16_t*, len) ──────────────────────
typedef void (*HighlightCallback)(void* dthis, void* hl, const char16_t* text, int len);

// ─── Subclass with Q_OBJECT (must be in .h for MOC) ────────────────────────
class eSyntaxHighlighter : public QSyntaxHighlighter {
    Q_OBJECT
public:
    HighlightCallback d_cb = nullptr;
    void* d_this = nullptr;

    explicit eSyntaxHighlighter(QTextDocument* parent)
        : QSyntaxHighlighter(parent) {}

protected:
    void highlightBlock(const QString& text) override {
        if (d_cb) {
            d_cb(d_this, (void*)this,
                 reinterpret_cast<const char16_t*>(text.utf16()),
                 text.length());
        }
    }

public:
    // Expose protected methods
    void pub_setFormat(int start, int count, const QTextCharFormat& fmt) {
        setFormat(start, count, fmt);
    }
    void pub_setFormatColor(int start, int count, const QColor& color) {
        setFormat(start, count, color);
    }
    int pub_currentBlockState() const { return currentBlockState(); }
    void pub_setCurrentBlockState(int state) { setCurrentBlockState(state); }
    int pub_previousBlockState() const { return previousBlockState(); }
    QTextBlock pub_currentBlock() const { return currentBlock(); }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSYNTAXHIGHLIGHTER_API void* qteQSyntaxHighlighter_create(void* document);
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_delete(void* hl);

// ── Callback ─────────────────────────────────────────────────────────────
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_setCallback(void* hl, void* cb, void* dthis);

// ── Protected helpers (accessible from subclass) ─────────────────────────
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_setFormat(void* hl, int start, int count, void* charFmt);
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_setFormatColor(void* hl, int start, int count, unsigned int rgba);
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_setFormatWeight(void* hl, int start, int count, int weight);

// ── Block state ──────────────────────────────────────────────────────────
QSYNTAXHIGHLIGHTER_API int   qteQSyntaxHighlighter_currentBlockState(void* hl);
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_setCurrentBlockState(void* hl, int state);
QSYNTAXHIGHLIGHTER_API int   qteQSyntaxHighlighter_previousBlockState(void* hl);

// ── Current block ────────────────────────────────────────────────────────
QSYNTAXHIGHLIGHTER_API void* qteQSyntaxHighlighter_currentBlock(void* hl);
QSYNTAXHIGHLIGHTER_API void* qteQSyntaxHighlighter_currentBlockText(void* hl);

// ── Rehighlight ──────────────────────────────────────────────────────────
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_rehighlight(void* hl);
QSYNTAXHIGHLIGHTER_API void  qteQSyntaxHighlighter_rehighlightBlock(void* hl, void* block);

} // extern "C"
