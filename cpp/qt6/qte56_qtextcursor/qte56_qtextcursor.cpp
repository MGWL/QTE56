#ifndef QTE56_QTEXTCURSOR_BUILD
#define QTE56_QTEXTCURSOR_BUILD
#endif
#include "qte56_qtextcursor.h"
#include <QTextCursor>
#include <QTextDocument>
#include <QTextCharFormat>
#include <QTextBlockFormat>
#include <QTextBlock>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextCursor_create(void* document) {
    return new QTextCursor((QTextDocument*)document);
}

void qteQTextCursor_delete(void* c) {
    delete (QTextCursor*)c;
}

void* qteQTextCursor_copy(void* c) {
    return new QTextCursor(*(QTextCursor*)c);
}

// ── Position ─────────────────────────────────────────────────────────────
int qteQTextCursor_position(void* c) {
    return ((QTextCursor*)c)->position();
}

void qteQTextCursor_setPosition(void* c, int pos, int mode) {
    ((QTextCursor*)c)->setPosition(pos, (QTextCursor::MoveMode)mode);
}

int qteQTextCursor_movePosition(void* c, int op, int mode, int n) {
    return ((QTextCursor*)c)->movePosition((QTextCursor::MoveOperation)op, (QTextCursor::MoveMode)mode, n) ? 1 : 0;
}

int qteQTextCursor_anchor(void* c) {
    return ((QTextCursor*)c)->anchor();
}

// ── Selection ────────────────────────────────────────────────────────────
int qteQTextCursor_hasSelection(void* c) {
    return ((QTextCursor*)c)->hasSelection() ? 1 : 0;
}

void* qteQTextCursor_selectedText(void* c) {
    return new QString(((QTextCursor*)c)->selectedText());
}

void qteQTextCursor_removeSelectedText(void* c) {
    ((QTextCursor*)c)->removeSelectedText();
}

void qteQTextCursor_select(void* c, int selection) {
    ((QTextCursor*)c)->select((QTextCursor::SelectionType)selection);
}

int qteQTextCursor_selectionStart(void* c) {
    return ((QTextCursor*)c)->selectionStart();
}

int qteQTextCursor_selectionEnd(void* c) {
    return ((QTextCursor*)c)->selectionEnd();
}

void qteQTextCursor_clearSelection(void* c) {
    ((QTextCursor*)c)->clearSelection();
}

// ── Insert ───────────────────────────────────────────────────────────────
void qteQTextCursor_insertText(void* c, void* text) {
    ((QTextCursor*)c)->insertText(*(QString*)text);
}

void qteQTextCursor_insertHtml(void* c, void* html) {
    ((QTextCursor*)c)->insertHtml(*(QString*)html);
}

void qteQTextCursor_insertBlock(void* c) {
    ((QTextCursor*)c)->insertBlock();
}

// ── At-position queries ──────────────────────────────────────────────────
int qteQTextCursor_atStart(void* c) {
    return ((QTextCursor*)c)->atStart() ? 1 : 0;
}

int qteQTextCursor_atEnd(void* c) {
    return ((QTextCursor*)c)->atEnd() ? 1 : 0;
}

int qteQTextCursor_atBlockStart(void* c) {
    return ((QTextCursor*)c)->atBlockStart() ? 1 : 0;
}

int qteQTextCursor_atBlockEnd(void* c) {
    return ((QTextCursor*)c)->atBlockEnd() ? 1 : 0;
}

// ── Block info ───────────────────────────────────────────────────────────
int qteQTextCursor_blockNumber(void* c) {
    return ((QTextCursor*)c)->blockNumber();
}

int qteQTextCursor_columnNumber(void* c) {
    return ((QTextCursor*)c)->columnNumber();
}

int qteQTextCursor_positionInBlock(void* c) {
    return ((QTextCursor*)c)->positionInBlock();
}

// ── Formatting ───────────────────────────────────────────────────────────
void* qteQTextCursor_charFormat(void* c) {
    return new QTextCharFormat(((QTextCursor*)c)->charFormat());
}

void qteQTextCursor_setCharFormat(void* c, void* fmt) {
    ((QTextCursor*)c)->setCharFormat(*(QTextCharFormat*)fmt);
}

void qteQTextCursor_mergeCharFormat(void* c, void* fmt) {
    ((QTextCursor*)c)->mergeCharFormat(*(QTextCharFormat*)fmt);
}

void* qteQTextCursor_blockFormat(void* c) {
    return new QTextBlockFormat(((QTextCursor*)c)->blockFormat());
}

void qteQTextCursor_setBlockFormat(void* c, void* fmt) {
    ((QTextCursor*)c)->setBlockFormat(*(QTextBlockFormat*)fmt);
}

void qteQTextCursor_mergeBlockFormat(void* c, void* fmt) {
    ((QTextCursor*)c)->mergeBlockFormat(*(QTextBlockFormat*)fmt);
}

// ── Block ────────────────────────────────────────────────────────────────
void* qteQTextCursor_block(void* c) {
    return new QTextBlock(((QTextCursor*)c)->block());
}

// ── Edit blocks ──────────────────────────────────────────────────────────
void qteQTextCursor_beginEditBlock(void* c) {
    ((QTextCursor*)c)->beginEditBlock();
}

void qteQTextCursor_endEditBlock(void* c) {
    ((QTextCursor*)c)->endEditBlock();
}

// ── Misc ─────────────────────────────────────────────────────────────────
int qteQTextCursor_isNull(void* c) {
    return ((QTextCursor*)c)->isNull() ? 1 : 0;
}

void qteQTextCursor_insertText_fmt(void* c, void* text, void* fmt) {
    ((QTextCursor*)c)->insertText(*(QString*)text, *(QTextCharFormat*)fmt);
}

void qteQTextCursor_insertBlock_fmt(void* c, void* blockFmt) {
    ((QTextCursor*)c)->insertBlock(*(QTextBlockFormat*)blockFmt);
}

} // extern "C"
