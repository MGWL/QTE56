#ifndef QTE56_QLABEL_BUILD
#define QTE56_QLABEL_BUILD
#endif
#include "qte56_qqlabel.h"
#include <QLabel>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
    return new QLabel((QWidget*)parent);
    return new QLabel((QLabel*)parent);
}

void qteQLabel_delete(void* w) {
    delete (QLabel*)w;
}

void* qteQLabel_create_text(void* text, void* parent) {
    return new QLabel(*(QString*)text, (QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQLabel_show(void* w) {
    ((QLabel*)w)->show();
}

void qteQLabel_hide(void* w) {
    ((QLabel*)w)->hide();
}

void qteQLabel_update(void* w) {
    ((QLabel*)w)->update();
}

void* qteQLabel_text(void* w) {
    return new QString(((QLabel*)w)->text());
}

void qteQLabel_setWordWrap(void* w, int on) {
    ((QLabel*)w)->setWordWrap((on != 0));
}

int qteQLabel_wordWrap(void* w) {
    return ((QLabel*)w)->wordWrap() ? 1 : 0;
}

int qteQLabel_indent(void* w) {
    return ((QLabel*)w)->indent();
}

void qteQLabel_setIndent(void* w, int p0) {
    ((QLabel*)w)->setIndent(p0);
}

int qteQLabel_margin(void* w) {
    return ((QLabel*)w)->margin();
}

void qteQLabel_setMargin(void* w, int p0) {
    ((QLabel*)w)->setMargin(p0);
}

int qteQLabel_hasScaledContents(void* w) {
    return ((QLabel*)w)->hasScaledContents() ? 1 : 0;
}

void qteQLabel_setScaledContents(void* w, int p0) {
    ((QLabel*)w)->setScaledContents((p0 != 0));
}

void* qteQLabel_sizeHint(void* w) {
    return ((QLabel*)w)->sizeHint();
}

void* qteQLabel_minimumSizeHint(void* w) {
    return ((QLabel*)w)->minimumSizeHint();
}

void qteQLabel_setBuddy(void* w, void* p0) {
    ((QLabel*)w)->setBuddy((QWidget*)p0);
}

int qteQLabel_heightForWidth(void* w, int p0) {
    return ((QLabel*)w)->heightForWidth(p0);
}

int qteQLabel_openExternalLinks(void* w) {
    return ((QLabel*)w)->openExternalLinks() ? 1 : 0;
}

void qteQLabel_setOpenExternalLinks(void* w, int open) {
    ((QLabel*)w)->setOpenExternalLinks((open != 0));
}

void qteQLabel_setSelection(void* w, int p0, int p1) {
    ((QLabel*)w)->setSelection(p0, p1);
}

int qteQLabel_hasSelectedText(void* w) {
    return ((QLabel*)w)->hasSelectedText() ? 1 : 0;
}

void* qteQLabel_selectedText(void* w) {
    return new QString(((QLabel*)w)->selectedText());
}

int qteQLabel_selectionStart(void* w) {
    return ((QLabel*)w)->selectionStart();
}

void qteQLabel_setText(void* w, void* p0) {
    ((QLabel*)w)->setText(*(QString*)p0);
}

void qteQLabel_setMovie(void* w, void* movie) {
    ((QLabel*)w)->setMovie((QMovie*)movie);
}

void qteQLabel_setNum_i(void* w, int p0) {
    ((QLabel*)w)->setNum(p0);
}

void qteQLabel_setNum_d(void* w, double p0) {
    ((QLabel*)w)->setNum(p0);
}

void qteQLabel_clear(void* w) {
    ((QLabel*)w)->clear();
}

} // extern "C"
