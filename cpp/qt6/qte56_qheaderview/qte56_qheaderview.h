#pragma once

#ifdef _WIN32
  #ifdef QTE56_QHEADERVIEW_BUILD
    #define QHEADERVIEW_API __declspec(dllexport)
  #else
    #define QHEADERVIEW_API __declspec(dllimport)
  #endif
#else
  #define QHEADERVIEW_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QHEADERVIEW_API void* qteQHeaderView_create(void* parent);    // Horizontal
QHEADERVIEW_API void* qteQHeaderView_create_v(void* parent);  // Vertical
QHEADERVIEW_API void  qteQHeaderView_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QHEADERVIEW_API void qteQHeaderView_setModel(void* _obj, void* model);
QHEADERVIEW_API int qteQHeaderView_orientation(void* _obj);
QHEADERVIEW_API int qteQHeaderView_offset(void* _obj);
QHEADERVIEW_API int qteQHeaderView_length(void* _obj);
QHEADERVIEW_API void* qteQHeaderView_sizeHint(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setVisible(void* _obj, int v);
QHEADERVIEW_API int qteQHeaderView_sectionSizeHint(void* _obj, int logicalIndex);
QHEADERVIEW_API int qteQHeaderView_visualIndexAt(void* _obj, int position);
QHEADERVIEW_API int qteQHeaderView_logicalIndexAt_i(void* _obj, int position);
QHEADERVIEW_API int qteQHeaderView_logicalIndexAt_ii(void* _obj, int x, int y);
QHEADERVIEW_API int qteQHeaderView_logicalIndexAt_p(void* _obj, void* pos);
QHEADERVIEW_API int qteQHeaderView_sectionSize(void* _obj, int logicalIndex);
QHEADERVIEW_API int qteQHeaderView_sectionPosition(void* _obj, int logicalIndex);
QHEADERVIEW_API int qteQHeaderView_sectionViewportPosition(void* _obj, int logicalIndex);
QHEADERVIEW_API void qteQHeaderView_moveSection(void* _obj, int from, int to);
QHEADERVIEW_API void qteQHeaderView_swapSections(void* _obj, int first, int second);
QHEADERVIEW_API void qteQHeaderView_resizeSection(void* _obj, int logicalIndex, int size);
QHEADERVIEW_API void qteQHeaderView_resizeSections(void* _obj, int mode);
QHEADERVIEW_API int qteQHeaderView_isSectionHidden(void* _obj, int logicalIndex);
QHEADERVIEW_API void qteQHeaderView_setSectionHidden(void* _obj, int logicalIndex, int hide);
QHEADERVIEW_API int qteQHeaderView_hiddenSectionCount(void* _obj);
QHEADERVIEW_API void qteQHeaderView_hideSection(void* _obj, int logicalIndex);
QHEADERVIEW_API void qteQHeaderView_showSection(void* _obj, int logicalIndex);
QHEADERVIEW_API int qteQHeaderView_count(void* _obj);
QHEADERVIEW_API int qteQHeaderView_visualIndex(void* _obj, int logicalIndex);
QHEADERVIEW_API int qteQHeaderView_logicalIndex(void* _obj, int visualIndex);
QHEADERVIEW_API void qteQHeaderView_setSectionsMovable(void* _obj, int movable);
QHEADERVIEW_API int qteQHeaderView_sectionsMovable(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setFirstSectionMovable(void* _obj, int movable);
QHEADERVIEW_API int qteQHeaderView_isFirstSectionMovable(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setSectionsClickable(void* _obj, int clickable);
QHEADERVIEW_API int qteQHeaderView_sectionsClickable(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setHighlightSections(void* _obj, int highlight);
QHEADERVIEW_API int qteQHeaderView_highlightSections(void* _obj);
QHEADERVIEW_API int qteQHeaderView_sectionResizeMode(void* _obj, int logicalIndex);
QHEADERVIEW_API void qteQHeaderView_setSectionResizeMode_p(void* _obj, int mode);
QHEADERVIEW_API void qteQHeaderView_setSectionResizeMode_ip(void* _obj, int logicalIndex, int mode);
QHEADERVIEW_API void qteQHeaderView_setResizeContentsPrecision(void* _obj, int precision);
QHEADERVIEW_API int qteQHeaderView_resizeContentsPrecision(void* _obj);
QHEADERVIEW_API int qteQHeaderView_stretchSectionCount(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setSortIndicatorShown(void* _obj, int show);
QHEADERVIEW_API int qteQHeaderView_isSortIndicatorShown(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setSortIndicator(void* _obj, int logicalIndex, int order);
QHEADERVIEW_API int qteQHeaderView_sortIndicatorSection(void* _obj);
QHEADERVIEW_API int qteQHeaderView_sortIndicatorOrder(void* _obj);
QHEADERVIEW_API int qteQHeaderView_stretchLastSection(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setStretchLastSection(void* _obj, int stretch);
QHEADERVIEW_API int qteQHeaderView_cascadingSectionResizes(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setCascadingSectionResizes(void* _obj, int enable);
QHEADERVIEW_API int qteQHeaderView_defaultSectionSize(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setDefaultSectionSize(void* _obj, int size);
QHEADERVIEW_API void qteQHeaderView_resetDefaultSectionSize(void* _obj);
QHEADERVIEW_API int qteQHeaderView_minimumSectionSize(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setMinimumSectionSize(void* _obj, int size);
QHEADERVIEW_API int qteQHeaderView_maximumSectionSize(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setMaximumSectionSize(void* _obj, int size);
QHEADERVIEW_API int qteQHeaderView_defaultAlignment(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setDefaultAlignment(void* _obj, int alignment);
QHEADERVIEW_API void qteQHeaderView_doItemsLayout(void* _obj);
QHEADERVIEW_API int qteQHeaderView_sectionsMoved(void* _obj);
QHEADERVIEW_API int qteQHeaderView_sectionsHidden(void* _obj);
QHEADERVIEW_API void qteQHeaderView_reset(void* _obj);
QHEADERVIEW_API void qteQHeaderView_setOffset(void* _obj, int offset);
QHEADERVIEW_API void qteQHeaderView_setOffsetToSectionPosition(void* _obj, int visualIndex);
QHEADERVIEW_API void qteQHeaderView_setOffsetToLastSection(void* _obj);
QHEADERVIEW_API void qteQHeaderView_headerDataChanged(void* _obj, int orientation, int logicalFirst, int logicalLast);

} // extern "C"
