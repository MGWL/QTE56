#ifndef QTE56_QHEADERVIEW_BUILD
#define QTE56_QHEADERVIEW_BUILD
#endif
#include "qte56_qheaderview.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QHeaderView>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
// orientation: 1=Horizontal, 2=Vertical
void* qteQHeaderView_create(void* parent) {
    return qte_createTracked(new QHeaderView(Qt::Horizontal, (QWidget*)parent);
}
void* qteQHeaderView_create_v(void* parent) {
    return qte_createTracked(new QHeaderView(Qt::Vertical, (QWidget*)parent);
}

void qteQHeaderView_delete(void* w) {
    delete (QHeaderView*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQHeaderView_setModel(void* _obj, void* model) {
    ((QHeaderView*)_obj)->setModel((QAbstractItemModel*)model);
}

int qteQHeaderView_orientation(void* _obj) {
    return ((QHeaderView*)_obj)->orientation();
}

int qteQHeaderView_offset(void* _obj) {
    return ((QHeaderView*)_obj)->offset();
}

int qteQHeaderView_length(void* _obj) {
    return ((QHeaderView*)_obj)->length();
}

void* qteQHeaderView_sizeHint(void* _obj) {
    return new QSize(((QHeaderView*)_obj)->sizeHint());
}

void qteQHeaderView_setVisible(void* _obj, int v) {
    ((QHeaderView*)_obj)->setVisible((v != 0));
}

int qteQHeaderView_sectionSizeHint(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->sectionSizeHint(logicalIndex);
}

int qteQHeaderView_visualIndexAt(void* _obj, int position) {
    return ((QHeaderView*)_obj)->visualIndexAt(position);
}

int qteQHeaderView_logicalIndexAt_i(void* _obj, int position) {
    return ((QHeaderView*)_obj)->logicalIndexAt(position);
}

int qteQHeaderView_logicalIndexAt_ii(void* _obj, int x, int y) {
    return ((QHeaderView*)_obj)->logicalIndexAt(x, y);
}

int qteQHeaderView_logicalIndexAt_p(void* _obj, void* pos) {
    return ((QHeaderView*)_obj)->logicalIndexAt(*(const QPoint*)pos);
}

int qteQHeaderView_sectionSize(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->sectionSize(logicalIndex);
}

int qteQHeaderView_sectionPosition(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->sectionPosition(logicalIndex);
}

int qteQHeaderView_sectionViewportPosition(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->sectionViewportPosition(logicalIndex);
}

void qteQHeaderView_moveSection(void* _obj, int from, int to) {
    ((QHeaderView*)_obj)->moveSection(from, to);
}

void qteQHeaderView_swapSections(void* _obj, int first, int second) {
    ((QHeaderView*)_obj)->swapSections(first, second);
}

void qteQHeaderView_resizeSection(void* _obj, int logicalIndex, int size) {
    ((QHeaderView*)_obj)->resizeSection(logicalIndex, size);
}

void qteQHeaderView_resizeSections(void* _obj, int mode) {
    ((QHeaderView*)_obj)->resizeSections((QHeaderView::ResizeMode)mode);
}

int qteQHeaderView_isSectionHidden(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->isSectionHidden(logicalIndex) ? 1 : 0;
}

void qteQHeaderView_setSectionHidden(void* _obj, int logicalIndex, int hide) {
    ((QHeaderView*)_obj)->setSectionHidden(logicalIndex, (hide != 0));
}

int qteQHeaderView_hiddenSectionCount(void* _obj) {
    return ((QHeaderView*)_obj)->hiddenSectionCount();
}

void qteQHeaderView_hideSection(void* _obj, int logicalIndex) {
    ((QHeaderView*)_obj)->hideSection(logicalIndex);
}

void qteQHeaderView_showSection(void* _obj, int logicalIndex) {
    ((QHeaderView*)_obj)->showSection(logicalIndex);
}

int qteQHeaderView_count(void* _obj) {
    return ((QHeaderView*)_obj)->count();
}

int qteQHeaderView_visualIndex(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->visualIndex(logicalIndex);
}

int qteQHeaderView_logicalIndex(void* _obj, int visualIndex) {
    return ((QHeaderView*)_obj)->logicalIndex(visualIndex);
}

void qteQHeaderView_setSectionsMovable(void* _obj, int movable) {
    ((QHeaderView*)_obj)->setSectionsMovable((movable != 0));
}

int qteQHeaderView_sectionsMovable(void* _obj) {
    return ((QHeaderView*)_obj)->sectionsMovable() ? 1 : 0;
}

void qteQHeaderView_setFirstSectionMovable(void* _obj, int movable) {
    ((QHeaderView*)_obj)->setFirstSectionMovable((movable != 0));
}

int qteQHeaderView_isFirstSectionMovable(void* _obj) {
    return ((QHeaderView*)_obj)->isFirstSectionMovable() ? 1 : 0;
}

void qteQHeaderView_setSectionsClickable(void* _obj, int clickable) {
    ((QHeaderView*)_obj)->setSectionsClickable((clickable != 0));
}

int qteQHeaderView_sectionsClickable(void* _obj) {
    return ((QHeaderView*)_obj)->sectionsClickable() ? 1 : 0;
}

void qteQHeaderView_setHighlightSections(void* _obj, int highlight) {
    ((QHeaderView*)_obj)->setHighlightSections((highlight != 0));
}

int qteQHeaderView_highlightSections(void* _obj) {
    return ((QHeaderView*)_obj)->highlightSections() ? 1 : 0;
}

int qteQHeaderView_sectionResizeMode(void* _obj, int logicalIndex) {
    return ((QHeaderView*)_obj)->sectionResizeMode(logicalIndex);
}

void qteQHeaderView_setSectionResizeMode_p(void* _obj, int mode) {
    ((QHeaderView*)_obj)->setSectionResizeMode((QHeaderView::ResizeMode)mode);
}

void qteQHeaderView_setSectionResizeMode_ip(void* _obj, int logicalIndex, int mode) {
    ((QHeaderView*)_obj)->setSectionResizeMode(logicalIndex, (QHeaderView::ResizeMode)mode);
}

void qteQHeaderView_setResizeContentsPrecision(void* _obj, int precision) {
    ((QHeaderView*)_obj)->setResizeContentsPrecision(precision);
}

int qteQHeaderView_resizeContentsPrecision(void* _obj) {
    return ((QHeaderView*)_obj)->resizeContentsPrecision();
}

int qteQHeaderView_stretchSectionCount(void* _obj) {
    return ((QHeaderView*)_obj)->stretchSectionCount();
}

void qteQHeaderView_setSortIndicatorShown(void* _obj, int show) {
    ((QHeaderView*)_obj)->setSortIndicatorShown((show != 0));
}

int qteQHeaderView_isSortIndicatorShown(void* _obj) {
    return ((QHeaderView*)_obj)->isSortIndicatorShown() ? 1 : 0;
}

void qteQHeaderView_setSortIndicator(void* _obj, int logicalIndex, int order) {
    ((QHeaderView*)_obj)->setSortIndicator(logicalIndex, (Qt::SortOrder)order);
}

int qteQHeaderView_sortIndicatorSection(void* _obj) {
    return ((QHeaderView*)_obj)->sortIndicatorSection();
}

int qteQHeaderView_sortIndicatorOrder(void* _obj) {
    return ((QHeaderView*)_obj)->sortIndicatorOrder();
}

int qteQHeaderView_stretchLastSection(void* _obj) {
    return ((QHeaderView*)_obj)->stretchLastSection() ? 1 : 0;
}

void qteQHeaderView_setStretchLastSection(void* _obj, int stretch) {
    ((QHeaderView*)_obj)->setStretchLastSection((stretch != 0));
}

int qteQHeaderView_cascadingSectionResizes(void* _obj) {
    return ((QHeaderView*)_obj)->cascadingSectionResizes() ? 1 : 0;
}

void qteQHeaderView_setCascadingSectionResizes(void* _obj, int enable) {
    ((QHeaderView*)_obj)->setCascadingSectionResizes((enable != 0));
}

int qteQHeaderView_defaultSectionSize(void* _obj) {
    return ((QHeaderView*)_obj)->defaultSectionSize();
}

void qteQHeaderView_setDefaultSectionSize(void* _obj, int size) {
    ((QHeaderView*)_obj)->setDefaultSectionSize(size);
}

void qteQHeaderView_resetDefaultSectionSize(void* _obj) {
    ((QHeaderView*)_obj)->resetDefaultSectionSize();
}

int qteQHeaderView_minimumSectionSize(void* _obj) {
    return ((QHeaderView*)_obj)->minimumSectionSize();
}

void qteQHeaderView_setMinimumSectionSize(void* _obj, int size) {
    ((QHeaderView*)_obj)->setMinimumSectionSize(size);
}

int qteQHeaderView_maximumSectionSize(void* _obj) {
    return ((QHeaderView*)_obj)->maximumSectionSize();
}

void qteQHeaderView_setMaximumSectionSize(void* _obj, int size) {
    ((QHeaderView*)_obj)->setMaximumSectionSize(size);
}

int qteQHeaderView_defaultAlignment(void* _obj) {
    return ((QHeaderView*)_obj)->defaultAlignment();
}

void qteQHeaderView_setDefaultAlignment(void* _obj, int alignment) {
    ((QHeaderView*)_obj)->setDefaultAlignment((Qt::Alignment)alignment);
}

void qteQHeaderView_doItemsLayout(void* _obj) {
    ((QHeaderView*)_obj)->doItemsLayout();
}

int qteQHeaderView_sectionsMoved(void* _obj) {
    return ((QHeaderView*)_obj)->sectionsMoved() ? 1 : 0;
}

int qteQHeaderView_sectionsHidden(void* _obj) {
    return ((QHeaderView*)_obj)->sectionsHidden() ? 1 : 0;
}

void qteQHeaderView_reset(void* _obj) {
    ((QHeaderView*)_obj)->reset();
}

void qteQHeaderView_setOffset(void* _obj, int offset) {
    ((QHeaderView*)_obj)->setOffset(offset);
}

void qteQHeaderView_setOffsetToSectionPosition(void* _obj, int visualIndex) {
    ((QHeaderView*)_obj)->setOffsetToSectionPosition(visualIndex);
}

void qteQHeaderView_setOffsetToLastSection(void* _obj) {
    ((QHeaderView*)_obj)->setOffsetToLastSection();
}

void qteQHeaderView_headerDataChanged(void* _obj, int orientation, int logicalFirst, int logicalLast) {
    ((QHeaderView*)_obj)->headerDataChanged((Qt::Orientation)orientation, logicalFirst, logicalLast);
}

} // extern "C"
