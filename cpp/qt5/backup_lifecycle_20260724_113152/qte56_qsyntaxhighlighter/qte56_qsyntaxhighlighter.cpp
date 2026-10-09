#ifndef QTE56_QSYNTAXHIGHLIGHTER_BUILD
#define QTE56_QSYNTAXHIGHLIGHTER_BUILD
#endif
#include "qte56_qsyntaxhighlighter.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTextCharFormat>
#include <QTextBlock>
#include <QColor>
#include <QFont>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQSyntaxHighlighter_create(void* document) {
    return new eSyntaxHighlighter((QTextDocument*)document);
}

void qteQSyntaxHighlighter_delete(void* hl) {
    delete (eSyntaxHighlighter*)hl;
}

// ── Callback ─────────────────────────────────────────────────────────────
void qteQSyntaxHighlighter_setCallback(void* hl, void* cb, void* dthis) {
    eSyntaxHighlighter* obj = (eSyntaxHighlighter*)hl;
    obj->d_cb = (HighlightCallback)cb;
    obj->d_this = dthis;
}

// ── Protected helpers ────────────────────────────────────────────────────
void qteQSyntaxHighlighter_setFormat(void* hl, int start, int count, void* charFmt) {
    ((eSyntaxHighlighter*)hl)->pub_setFormat(start, count, *(QTextCharFormat*)charFmt);
}

void qteQSyntaxHighlighter_setFormatColor(void* hl, int start, int count, unsigned int rgba) {
    ((eSyntaxHighlighter*)hl)->pub_setFormatColor(start, count, QColor::fromRgba((QRgb)rgba));
}

void qteQSyntaxHighlighter_setFormatWeight(void* hl, int start, int count, int weight) {
    QTextCharFormat fmt;
    fmt.setFontWeight(weight);
    ((eSyntaxHighlighter*)hl)->pub_setFormat(start, count, fmt);
}

// ── Block state ──────────────────────────────────────────────────────────
int qteQSyntaxHighlighter_currentBlockState(void* hl) {
    return ((eSyntaxHighlighter*)hl)->pub_currentBlockState();
}

void qteQSyntaxHighlighter_setCurrentBlockState(void* hl, int state) {
    ((eSyntaxHighlighter*)hl)->pub_setCurrentBlockState(state);
}

int qteQSyntaxHighlighter_previousBlockState(void* hl) {
    return ((eSyntaxHighlighter*)hl)->pub_previousBlockState();
}

// ── Current block ────────────────────────────────────────────────────────
void* qteQSyntaxHighlighter_currentBlock(void* hl) {
    return new QTextBlock(((eSyntaxHighlighter*)hl)->pub_currentBlock());
}

void* qteQSyntaxHighlighter_currentBlockText(void* hl) {
    return new QString(((eSyntaxHighlighter*)hl)->pub_currentBlock().text());
}

// ── Rehighlight ──────────────────────────────────────────────────────────
void qteQSyntaxHighlighter_rehighlight(void* hl) {
    ((eSyntaxHighlighter*)hl)->rehighlight();
}

void qteQSyntaxHighlighter_rehighlightBlock(void* hl, void* block) {
    ((eSyntaxHighlighter*)hl)->rehighlightBlock(*(QTextBlock*)block);
}

} // extern "C"
