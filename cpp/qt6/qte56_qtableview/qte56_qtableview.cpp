#ifndef QTE56_QTABLEVIEW_BUILD
#define QTE56_QTABLEVIEW_BUILD
#endif
#include "qte56_qtableview.h"
#include <QTableView>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTableView_create(void* parent) {
    return new QTableView((QWidget*)parent);
}

void qteQTableView_delete(void* w) {
    delete (QTableView*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQTableView_horizontalHeader(void* _obj) {
    return (void*)((QTableView*)_obj)->horizontalHeader();
}

void* qteQTableView_verticalHeader(void* _obj) {
    return (void*)((QTableView*)_obj)->verticalHeader();
}

void qteQTableView_setHorizontalHeader(void* _obj, void* header) {
    ((QTableView*)_obj)->setHorizontalHeader((QHeaderView*)header);
}

void qteQTableView_setVerticalHeader(void* _obj, void* header) {
    ((QTableView*)_obj)->setVerticalHeader((QHeaderView*)header);
}

int qteQTableView_rowViewportPosition(void* _obj, int row) {
    return ((QTableView*)_obj)->rowViewportPosition(row);
}

int qteQTableView_rowAt(void* _obj, int y) {
    return ((QTableView*)_obj)->rowAt(y);
}

void qteQTableView_setRowHeight(void* _obj, int row, int height) {
    ((QTableView*)_obj)->setRowHeight(row, height);
}

int qteQTableView_rowHeight(void* _obj, int row) {
    return ((QTableView*)_obj)->rowHeight(row);
}

int qteQTableView_columnViewportPosition(void* _obj, int column) {
    return ((QTableView*)_obj)->columnViewportPosition(column);
}

int qteQTableView_columnAt(void* _obj, int x) {
    return ((QTableView*)_obj)->columnAt(x);
}

void qteQTableView_setColumnWidth(void* _obj, int column, int width) {
    ((QTableView*)_obj)->setColumnWidth(column, width);
}

int qteQTableView_columnWidth(void* _obj, int column) {
    return ((QTableView*)_obj)->columnWidth(column);
}

int qteQTableView_isRowHidden(void* _obj, int row) {
    return ((QTableView*)_obj)->isRowHidden(row) ? 1 : 0;
}

void qteQTableView_setRowHidden(void* _obj, int row, int hide) {
    ((QTableView*)_obj)->setRowHidden(row, (hide != 0));
}

int qteQTableView_isColumnHidden(void* _obj, int column) {
    return ((QTableView*)_obj)->isColumnHidden(column) ? 1 : 0;
}

void qteQTableView_setColumnHidden(void* _obj, int column, int hide) {
    ((QTableView*)_obj)->setColumnHidden(column, (hide != 0));
}

void qteQTableView_setSortingEnabled(void* _obj, int enable) {
    ((QTableView*)_obj)->setSortingEnabled((enable != 0));
}

int qteQTableView_isSortingEnabled(void* _obj) {
    return ((QTableView*)_obj)->isSortingEnabled() ? 1 : 0;
}

int qteQTableView_showGrid(void* _obj) {
    return ((QTableView*)_obj)->showGrid() ? 1 : 0;
}

int qteQTableView_gridStyle(void* _obj) {
    return ((QTableView*)_obj)->gridStyle();
}

void qteQTableView_setGridStyle(void* _obj, int style) {
    ((QTableView*)_obj)->setGridStyle((Qt::PenStyle)style);
}

void qteQTableView_setWordWrap(void* _obj, int on) {
    ((QTableView*)_obj)->setWordWrap((on != 0));
}

int qteQTableView_wordWrap(void* _obj) {
    return ((QTableView*)_obj)->wordWrap() ? 1 : 0;
}

void qteQTableView_setCornerButtonEnabled(void* _obj, int enable) {
    ((QTableView*)_obj)->setCornerButtonEnabled((enable != 0));
}

int qteQTableView_isCornerButtonEnabled(void* _obj) {
    return ((QTableView*)_obj)->isCornerButtonEnabled() ? 1 : 0;
}

void qteQTableView_setSpan(void* _obj, int row, int column, int rowSpan, int columnSpan) {
    ((QTableView*)_obj)->setSpan(row, column, rowSpan, columnSpan);
}

int qteQTableView_rowSpan(void* _obj, int row, int column) {
    return ((QTableView*)_obj)->rowSpan(row, column);
}

int qteQTableView_columnSpan(void* _obj, int row, int column) {
    return ((QTableView*)_obj)->columnSpan(row, column);
}

void qteQTableView_clearSpans(void* _obj) {
    ((QTableView*)_obj)->clearSpans();
}

void qteQTableView_selectRow(void* _obj, int row) {
    ((QTableView*)_obj)->selectRow(row);
}

void qteQTableView_selectColumn(void* _obj, int column) {
    ((QTableView*)_obj)->selectColumn(column);
}

void qteQTableView_hideRow(void* _obj, int row) {
    ((QTableView*)_obj)->hideRow(row);
}

void qteQTableView_hideColumn(void* _obj, int column) {
    ((QTableView*)_obj)->hideColumn(column);
}

void qteQTableView_showRow(void* _obj, int row) {
    ((QTableView*)_obj)->showRow(row);
}

void qteQTableView_showColumn(void* _obj, int column) {
    ((QTableView*)_obj)->showColumn(column);
}

void qteQTableView_resizeRowToContents(void* _obj, int row) {
    ((QTableView*)_obj)->resizeRowToContents(row);
}

void qteQTableView_resizeRowsToContents(void* _obj) {
    ((QTableView*)_obj)->resizeRowsToContents();
}

void qteQTableView_resizeColumnToContents(void* _obj, int column) {
    ((QTableView*)_obj)->resizeColumnToContents(column);
}

void qteQTableView_resizeColumnsToContents(void* _obj) {
    ((QTableView*)_obj)->resizeColumnsToContents();
}

void qteQTableView_sortByColumn_i(void* _obj, int column) {
    // Qt6: sortByColumn(int) removed, use sortByColumn(int, Qt::SortOrder) with AscendingOrder
    ((QTableView*)_obj)->sortByColumn(column, Qt::AscendingOrder);
}

void qteQTableView_sortByColumn_ip(void* _obj, int column, int order) {
    ((QTableView*)_obj)->sortByColumn(column, (Qt::SortOrder)order);
}

void qteQTableView_setShowGrid(void* _obj, int show) {
    ((QTableView*)_obj)->setShowGrid((show != 0));
}

} // extern "C"
