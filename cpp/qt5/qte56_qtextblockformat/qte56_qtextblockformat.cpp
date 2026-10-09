#ifndef QTE56_QTEXTBLOCKFORMAT_BUILD
#define QTE56_QTEXTBLOCKFORMAT_BUILD
#endif
#include "qte56_qtextblockformat.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTextBlockFormat>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextBlockFormat_create(void* /*unused*/) {
    return new QTextBlockFormat();
}

void qteQTextBlockFormat_delete(void* fmt) {
    delete (QTextBlockFormat*)fmt;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQTextBlockFormat_isValid(void* fmt) {
    return ((QTextBlockFormat*)fmt)->isValid() ? 1 : 0;
}

void qteQTextBlockFormat_setAlignment(void* fmt, int alignment) {
    ((QTextBlockFormat*)fmt)->setAlignment((Qt::Alignment)alignment);
}

int qteQTextBlockFormat_alignment(void* fmt) {
    return (int)((QTextBlockFormat*)fmt)->alignment();
}

void qteQTextBlockFormat_setIndent(void* fmt, int indent) {
    ((QTextBlockFormat*)fmt)->setIndent(indent);
}

int qteQTextBlockFormat_indent(void* fmt) {
    return ((QTextBlockFormat*)fmt)->indent();
}

void qteQTextBlockFormat_setTextIndent(void* fmt, double indent) {
    ((QTextBlockFormat*)fmt)->setTextIndent(indent);
}

double qteQTextBlockFormat_textIndent(void* fmt) {
    return ((QTextBlockFormat*)fmt)->textIndent();
}

void qteQTextBlockFormat_setTopMargin(void* fmt, double margin) {
    ((QTextBlockFormat*)fmt)->setTopMargin(margin);
}

double qteQTextBlockFormat_topMargin(void* fmt) {
    return ((QTextBlockFormat*)fmt)->topMargin();
}

void qteQTextBlockFormat_setBottomMargin(void* fmt, double margin) {
    ((QTextBlockFormat*)fmt)->setBottomMargin(margin);
}

double qteQTextBlockFormat_bottomMargin(void* fmt) {
    return ((QTextBlockFormat*)fmt)->bottomMargin();
}

void qteQTextBlockFormat_setLeftMargin(void* fmt, double margin) {
    ((QTextBlockFormat*)fmt)->setLeftMargin(margin);
}

double qteQTextBlockFormat_leftMargin(void* fmt) {
    return ((QTextBlockFormat*)fmt)->leftMargin();
}

void qteQTextBlockFormat_setRightMargin(void* fmt, double margin) {
    ((QTextBlockFormat*)fmt)->setRightMargin(margin);
}

double qteQTextBlockFormat_rightMargin(void* fmt) {
    return ((QTextBlockFormat*)fmt)->rightMargin();
}

void qteQTextBlockFormat_setLineHeight(void* fmt, double height, int heightType) {
    ((QTextBlockFormat*)fmt)->setLineHeight(height, heightType);
}

double qteQTextBlockFormat_lineHeight(void* fmt) {
    return ((QTextBlockFormat*)fmt)->lineHeight();
}

int qteQTextBlockFormat_lineHeightType(void* fmt) {
    return ((QTextBlockFormat*)fmt)->lineHeightType();
}

} // extern "C"
