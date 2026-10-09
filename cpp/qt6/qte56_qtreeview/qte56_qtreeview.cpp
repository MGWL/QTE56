#ifndef QTE56_QTREEVIEW_BUILD
#define QTE56_QTREEVIEW_BUILD
#endif
#include "qte56_qtreeview.h"
#include <QTreeView>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTreeView_create(void* parent) {
    return new QTreeView((QWidget*)parent);
}

void qteQTreeView_delete(void* w) {
    delete (QTreeView*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQTreeView_header(void* _obj) {
    return (void*)((QTreeView*)_obj)->header();
}

void qteQTreeView_setHeader(void* _obj, void* header) {
    ((QTreeView*)_obj)->setHeader((QHeaderView*)header);
}

int qteQTreeView_autoExpandDelay(void* _obj) {
    return ((QTreeView*)_obj)->autoExpandDelay();
}

void qteQTreeView_setAutoExpandDelay(void* _obj, int delay) {
    ((QTreeView*)_obj)->setAutoExpandDelay(delay);
}

int qteQTreeView_indentation(void* _obj) {
    return ((QTreeView*)_obj)->indentation();
}

void qteQTreeView_setIndentation(void* _obj, int i) {
    ((QTreeView*)_obj)->setIndentation(i);
}

void qteQTreeView_resetIndentation(void* _obj) {
    ((QTreeView*)_obj)->resetIndentation();
}

int qteQTreeView_rootIsDecorated(void* _obj) {
    return ((QTreeView*)_obj)->rootIsDecorated() ? 1 : 0;
}

void qteQTreeView_setRootIsDecorated(void* _obj, int show) {
    ((QTreeView*)_obj)->setRootIsDecorated((show != 0));
}

int qteQTreeView_uniformRowHeights(void* _obj) {
    return ((QTreeView*)_obj)->uniformRowHeights() ? 1 : 0;
}

void qteQTreeView_setUniformRowHeights(void* _obj, int uniform) {
    ((QTreeView*)_obj)->setUniformRowHeights((uniform != 0));
}

int qteQTreeView_itemsExpandable(void* _obj) {
    return ((QTreeView*)_obj)->itemsExpandable() ? 1 : 0;
}

void qteQTreeView_setItemsExpandable(void* _obj, int enable) {
    ((QTreeView*)_obj)->setItemsExpandable((enable != 0));
}

int qteQTreeView_expandsOnDoubleClick(void* _obj) {
    return ((QTreeView*)_obj)->expandsOnDoubleClick() ? 1 : 0;
}

void qteQTreeView_setExpandsOnDoubleClick(void* _obj, int enable) {
    ((QTreeView*)_obj)->setExpandsOnDoubleClick((enable != 0));
}

int qteQTreeView_columnViewportPosition(void* _obj, int column) {
    return ((QTreeView*)_obj)->columnViewportPosition(column);
}

int qteQTreeView_columnWidth(void* _obj, int column) {
    return ((QTreeView*)_obj)->columnWidth(column);
}

void qteQTreeView_setColumnWidth(void* _obj, int column, int width) {
    ((QTreeView*)_obj)->setColumnWidth(column, width);
}

int qteQTreeView_columnAt(void* _obj, int x) {
    return ((QTreeView*)_obj)->columnAt(x);
}

int qteQTreeView_isColumnHidden(void* _obj, int column) {
    return ((QTreeView*)_obj)->isColumnHidden(column) ? 1 : 0;
}

void qteQTreeView_setColumnHidden(void* _obj, int column, int hide) {
    ((QTreeView*)_obj)->setColumnHidden(column, (hide != 0));
}

int qteQTreeView_isHeaderHidden(void* _obj) {
    return ((QTreeView*)_obj)->isHeaderHidden() ? 1 : 0;
}

void qteQTreeView_setHeaderHidden(void* _obj, int hide) {
    ((QTreeView*)_obj)->setHeaderHidden((hide != 0));
}

void qteQTreeView_setSortingEnabled(void* _obj, int enable) {
    ((QTreeView*)_obj)->setSortingEnabled((enable != 0));
}

int qteQTreeView_isSortingEnabled(void* _obj) {
    return ((QTreeView*)_obj)->isSortingEnabled() ? 1 : 0;
}

void qteQTreeView_setAnimated(void* _obj, int enable) {
    ((QTreeView*)_obj)->setAnimated((enable != 0));
}

int qteQTreeView_isAnimated(void* _obj) {
    return ((QTreeView*)_obj)->isAnimated() ? 1 : 0;
}

void qteQTreeView_setAllColumnsShowFocus(void* _obj, int enable) {
    ((QTreeView*)_obj)->setAllColumnsShowFocus((enable != 0));
}

int qteQTreeView_allColumnsShowFocus(void* _obj) {
    return ((QTreeView*)_obj)->allColumnsShowFocus() ? 1 : 0;
}

void qteQTreeView_setWordWrap(void* _obj, int on) {
    ((QTreeView*)_obj)->setWordWrap((on != 0));
}

int qteQTreeView_wordWrap(void* _obj) {
    return ((QTreeView*)_obj)->wordWrap() ? 1 : 0;
}

void qteQTreeView_setTreePosition(void* _obj, int logicalIndex) {
    ((QTreeView*)_obj)->setTreePosition(logicalIndex);
}

int qteQTreeView_treePosition(void* _obj) {
    return ((QTreeView*)_obj)->treePosition();
}

void qteQTreeView_hideColumn(void* _obj, int column) {
    ((QTreeView*)_obj)->hideColumn(column);
}

void qteQTreeView_showColumn(void* _obj, int column) {
    ((QTreeView*)_obj)->showColumn(column);
}

void qteQTreeView_resizeColumnToContents(void* _obj, int column) {
    ((QTreeView*)_obj)->resizeColumnToContents(column);
}

void qteQTreeView_sortByColumn_i(void* _obj, int column) {
    // Qt6: sortByColumn(int) removed, use sortByColumn(int, Qt::SortOrder) with AscendingOrder
    ((QTreeView*)_obj)->sortByColumn(column, Qt::AscendingOrder);
}

void qteQTreeView_sortByColumn_ip(void* _obj, int column, int order) {
    ((QTreeView*)_obj)->sortByColumn(column, (Qt::SortOrder)order);
}

void qteQTreeView_expandAll(void* _obj) {
    ((QTreeView*)_obj)->expandAll();
}

void qteQTreeView_collapseAll(void* _obj) {
    ((QTreeView*)_obj)->collapseAll();
}

void qteQTreeView_expandToDepth(void* _obj, int depth) {
    ((QTreeView*)_obj)->expandToDepth(depth);
}

} // extern "C"
