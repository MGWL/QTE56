#ifndef QTE56_QFONT_BUILD
#define QTE56_QFONT_BUILD
#endif
#include "qte56_qfont.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QFont>
#include <QString>
#include <QWidget>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
// QFont is a value type — no parent; heap-allocate via new for pointer-based API
void* qteQFont_create(void* /*parent_unused*/) {
    return new QFont();
}

void qteQFont_delete(void* w) {
    delete (QFont*)w;
}

// create_text: family name → QFont(family)
void* qteQFont_create_text(void* text, void* /*unused*/) {
    return new QFont(*(QString*)text);
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQFont_family(void* _obj) {
    return new QString(((QFont*)_obj)->family());
}

void qteQFont_setFamily(void* _obj, void* p0) {
    ((QFont*)_obj)->setFamily(*(QString*)p0);
}

void* qteQFont_styleName(void* _obj) {
    return new QString(((QFont*)_obj)->styleName());
}

void qteQFont_setStyleName(void* _obj, void* p0) {
    ((QFont*)_obj)->setStyleName(*(QString*)p0);
}

int qteQFont_pointSize(void* _obj) {
    return ((QFont*)_obj)->pointSize();
}

void qteQFont_setPointSize(void* _obj, int p0) {
    ((QFont*)_obj)->setPointSize(p0);
}

double qteQFont_pointSizeF(void* _obj) {
    return ((QFont*)_obj)->pointSizeF();
}

void qteQFont_setPointSizeF(void* _obj, double p0) {
    ((QFont*)_obj)->setPointSizeF(p0);
}

int qteQFont_pixelSize(void* _obj) {
    return ((QFont*)_obj)->pixelSize();
}

void qteQFont_setPixelSize(void* _obj, int p0) {
    ((QFont*)_obj)->setPixelSize(p0);
}

int qteQFont_weight(void* _obj) {
    return ((QFont*)_obj)->weight();
}

void qteQFont_setWeight(void* _obj, int p0) {
    ((QFont*)_obj)->setWeight(p0);
}

int qteQFont_bold(void* _obj) {
    return ((QFont*)_obj)->bold() ? 1 : 0;
}

void qteQFont_setBold(void* _obj, int p0) {
    ((QFont*)_obj)->setBold((p0 != 0));
}

void qteQFont_setStyle(void* _obj, int style) {
    ((QFont*)_obj)->setStyle((QFont::Style)style);
}

int qteQFont_style(void* _obj) {
    return ((QFont*)_obj)->style();
}

int qteQFont_italic(void* _obj) {
    return ((QFont*)_obj)->italic() ? 1 : 0;
}

void qteQFont_setItalic(void* _obj, int b) {
    ((QFont*)_obj)->setItalic((b != 0));
}

int qteQFont_underline(void* _obj) {
    return ((QFont*)_obj)->underline() ? 1 : 0;
}

void qteQFont_setUnderline(void* _obj, int p0) {
    ((QFont*)_obj)->setUnderline((p0 != 0));
}

int qteQFont_overline(void* _obj) {
    return ((QFont*)_obj)->overline() ? 1 : 0;
}

void qteQFont_setOverline(void* _obj, int p0) {
    ((QFont*)_obj)->setOverline((p0 != 0));
}

int qteQFont_strikeOut(void* _obj) {
    return ((QFont*)_obj)->strikeOut() ? 1 : 0;
}

void qteQFont_setStrikeOut(void* _obj, int p0) {
    ((QFont*)_obj)->setStrikeOut((p0 != 0));
}

int qteQFont_fixedPitch(void* _obj) {
    return ((QFont*)_obj)->fixedPitch() ? 1 : 0;
}

void qteQFont_setFixedPitch(void* _obj, int p0) {
    ((QFont*)_obj)->setFixedPitch((p0 != 0));
}

int qteQFont_kerning(void* _obj) {
    return ((QFont*)_obj)->kerning() ? 1 : 0;
}

void qteQFont_setKerning(void* _obj, int p0) {
    ((QFont*)_obj)->setKerning((p0 != 0));
}

int qteQFont_styleHint(void* _obj) {
    return ((QFont*)_obj)->styleHint();
}

int qteQFont_styleStrategy(void* _obj) {
    return ((QFont*)_obj)->styleStrategy();
}

void qteQFont_setStyleHint(void* _obj, int p0, int p1) {
    ((QFont*)_obj)->setStyleHint((QFont::StyleHint)p0, (QFont::StyleStrategy)p1);
}

void qteQFont_setStyleStrategy(void* _obj, int s) {
    ((QFont*)_obj)->setStyleStrategy((QFont::StyleStrategy)s);
}

int qteQFont_stretch(void* _obj) {
    return ((QFont*)_obj)->stretch();
}

void qteQFont_setStretch(void* _obj, int p0) {
    ((QFont*)_obj)->setStretch(p0);
}

double qteQFont_letterSpacing(void* _obj) {
    return ((QFont*)_obj)->letterSpacing();
}

int qteQFont_letterSpacingType(void* _obj) {
    return ((QFont*)_obj)->letterSpacingType();
}

void qteQFont_setLetterSpacing(void* _obj, int type, double spacing) {
    ((QFont*)_obj)->setLetterSpacing((QFont::SpacingType)type, spacing);
}

double qteQFont_wordSpacing(void* _obj) {
    return ((QFont*)_obj)->wordSpacing();
}

void qteQFont_setWordSpacing(void* _obj, double spacing) {
    ((QFont*)_obj)->setWordSpacing(spacing);
}

void qteQFont_setCapitalization(void* _obj, int p0) {
    ((QFont*)_obj)->setCapitalization((QFont::Capitalization)p0);
}

int qteQFont_capitalization(void* _obj) {
    return ((QFont*)_obj)->capitalization();
}

void qteQFont_setHintingPreference(void* _obj, int hintingPreference) {
    ((QFont*)_obj)->setHintingPreference((QFont::HintingPreference)hintingPreference);
}

int qteQFont_hintingPreference(void* _obj) {
    return ((QFont*)_obj)->hintingPreference();
}

int qteQFont_rawMode(void* _obj) {
    return ((QFont*)_obj)->rawMode() ? 1 : 0;
}

void qteQFont_setRawMode(void* _obj, int p0) {
    ((QFont*)_obj)->setRawMode((p0 != 0));
}

int qteQFont_exactMatch(void* _obj) {
    return ((QFont*)_obj)->exactMatch() ? 1 : 0;
}

void* qteQFont_key(void* _obj) {
    return new QString(((QFont*)_obj)->key());
}

void* qteQFont_toString(void* _obj) {
    return new QString(((QFont*)_obj)->toString());
}

int qteQFont_fromString(void* _obj, void* p0) {
    return ((QFont*)_obj)->fromString(*(QString*)p0) ? 1 : 0;
}

void* qteQFont_substitute(void* _obj, void* p0) {
    return new QString(((QFont*)_obj)->substitute(*(QString*)p0));
}

void qteQFont_removeSubstitutions(void* _obj, void* p0) {
    ((QFont*)_obj)->removeSubstitutions(*(QString*)p0);
}

void qteQFont_initialize(void* _obj) {
    ((QFont*)_obj)->initialize();
}

void qteQFont_cleanup(void* _obj) {
    ((QFont*)_obj)->cleanup();
}

void qteQFont_cacheStatistics(void* _obj) {
    ((QFont*)_obj)->cacheStatistics();
}

void* qteQFont_defaultFamily(void* _obj) {
    return new QString(((QFont*)_obj)->defaultFamily());
}

// ── Widget font helpers ───────────────────────────────────────────────────
// setWidgetFont: apply QFont to any QWidget
void qteQFont_setWidgetFont(void* widget, void* font) {
    ((QWidget*)widget)->setFont(*(QFont*)font);
}
// getWidgetFont: returns heap-allocated copy of widget's current font
void* qteQFont_getWidgetFont(void* widget) {
    return new QFont(((QWidget*)widget)->font());
}

} // extern "C"
