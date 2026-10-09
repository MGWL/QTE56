#ifndef QTE56_QTEXTBLOCK_BUILD
#define QTE56_QTEXTBLOCK_BUILD
#endif
#include "qte56_qtextblock.h"
#include <QTextBlock>
#include <QTextCharFormat>
#include <QTextBlockFormat>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextBlock_copy(void* block) {
    return new QTextBlock(*(QTextBlock*)block);
}

void qteQTextBlock_delete(void* block) {
    delete (QTextBlock*)block;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQTextBlock_text(void* block) {
    return new QString(((QTextBlock*)block)->text());
}

int qteQTextBlock_length(void* block) {
    return ((QTextBlock*)block)->length();
}

int qteQTextBlock_blockNumber(void* block) {
    return ((QTextBlock*)block)->blockNumber();
}

int qteQTextBlock_position(void* block) {
    return ((QTextBlock*)block)->position();
}

int qteQTextBlock_isValid(void* block) {
    return ((QTextBlock*)block)->isValid() ? 1 : 0;
}

int qteQTextBlock_isVisible(void* block) {
    return ((QTextBlock*)block)->isVisible() ? 1 : 0;
}

int qteQTextBlock_revision(void* block) {
    return ((QTextBlock*)block)->revision();
}

void* qteQTextBlock_next(void* block) {
    QTextBlock nb = ((QTextBlock*)block)->next();
    if (!nb.isValid()) return nullptr;
    return new QTextBlock(nb);
}

void* qteQTextBlock_previous(void* block) {
    QTextBlock pb = ((QTextBlock*)block)->previous();
    if (!pb.isValid()) return nullptr;
    return new QTextBlock(pb);
}

void* qteQTextBlock_charFormat(void* block) {
    return new QTextCharFormat(((QTextBlock*)block)->charFormat());
}

void* qteQTextBlock_blockFormat(void* block) {
    return new QTextBlockFormat(((QTextBlock*)block)->blockFormat());
}

int qteQTextBlock_lineCount(void* block) {
    return ((QTextBlock*)block)->lineCount();
}

int qteQTextBlock_firstLineNumber(void* block) {
    return ((QTextBlock*)block)->firstLineNumber();
}

} // extern "C"
