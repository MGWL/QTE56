#ifndef QTE56_QTEXTCHARFORMAT_BUILD
#define QTE56_QTEXTCHARFORMAT_BUILD
#endif
#include "qte56_qtextcharformat.h"
#include <QTextCharFormat>
#include <QString>
#include <QColor>
#include <QFont>
#include <QBrush>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextCharFormat_create(void* /*unused*/) {
    return new QTextCharFormat();
}

void qteQTextCharFormat_delete(void* fmt) {
    delete (QTextCharFormat*)fmt;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQTextCharFormat_isValid(void* fmt) {
    return ((QTextCharFormat*)fmt)->isValid() ? 1 : 0;
}

void qteQTextCharFormat_setFontFamily(void* fmt, void* family) {
    ((QTextCharFormat*)fmt)->setFontFamily(*(QString*)family);
}

void* qteQTextCharFormat_fontFamily(void* fmt) {
    return new QString(((QTextCharFormat*)fmt)->fontFamily());
}

void qteQTextCharFormat_setFontPointSize(void* fmt, double size) {
    ((QTextCharFormat*)fmt)->setFontPointSize(size);
}

double qteQTextCharFormat_fontPointSize(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontPointSize();
}

void qteQTextCharFormat_setFontWeight(void* fmt, int weight) {
    ((QTextCharFormat*)fmt)->setFontWeight(weight);
}

int qteQTextCharFormat_fontWeight(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontWeight();
}

void qteQTextCharFormat_setFontItalic(void* fmt, int italic) {
    ((QTextCharFormat*)fmt)->setFontItalic((italic != 0));
}

int qteQTextCharFormat_fontItalic(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontItalic() ? 1 : 0;
}

void qteQTextCharFormat_setFontUnderline(void* fmt, int underline) {
    ((QTextCharFormat*)fmt)->setFontUnderline((underline != 0));
}

int qteQTextCharFormat_fontUnderline(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontUnderline() ? 1 : 0;
}

void qteQTextCharFormat_setFontStrikeOut(void* fmt, int strikeOut) {
    ((QTextCharFormat*)fmt)->setFontStrikeOut((strikeOut != 0));
}

int qteQTextCharFormat_fontStrikeOut(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontStrikeOut() ? 1 : 0;
}

void qteQTextCharFormat_setFontOverline(void* fmt, int overline) {
    ((QTextCharFormat*)fmt)->setFontOverline((overline != 0));
}

int qteQTextCharFormat_fontOverline(void* fmt) {
    return ((QTextCharFormat*)fmt)->fontOverline() ? 1 : 0;
}

void qteQTextCharFormat_setForeground(void* fmt, void* color) {
    ((QTextCharFormat*)fmt)->setForeground(QBrush(*(QColor*)color));
}

void qteQTextCharFormat_setBackground(void* fmt, void* color) {
    ((QTextCharFormat*)fmt)->setBackground(QBrush(*(QColor*)color));
}

unsigned int qteQTextCharFormat_foreground(void* fmt) {
    return ((QTextCharFormat*)fmt)->foreground().color().rgba();
}

unsigned int qteQTextCharFormat_background(void* fmt) {
    return ((QTextCharFormat*)fmt)->background().color().rgba();
}

void qteQTextCharFormat_setFont(void* fmt, void* font) {
    ((QTextCharFormat*)fmt)->setFont(*(QFont*)font);
}

void* qteQTextCharFormat_font(void* fmt) {
    return new QFont(((QTextCharFormat*)fmt)->font());
}

void qteQTextCharFormat_setUnderlineColor(void* fmt, void* color) {
    ((QTextCharFormat*)fmt)->setUnderlineColor(*(QColor*)color);
}

void qteQTextCharFormat_setUnderlineStyle(void* fmt, int style) {
    ((QTextCharFormat*)fmt)->setUnderlineStyle((QTextCharFormat::UnderlineStyle)style);
}

} // extern "C"
