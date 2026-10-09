/**
 * gen_qtableview.d — GENERATED wrapper for QTableView.
 * Module: QTableView  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtableview;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qabstractitemview : QAbstractItemView;
import gen_qheaderview : QHeaderView;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTableView() {
    mixin(generateFunQt(9000, "qteQTableView_create", "QTableView"));
    mixin(generateFunQt(9001, "qteQTableView_delete", "QTableView"));
    mixin(generateFunQt(9005, "qteQTableView_horizontalHeader", "QTableView"));
    mixin(generateFunQt(9006, "qteQTableView_verticalHeader", "QTableView"));
    mixin(generateFunQt(9007, "qteQTableView_setHorizontalHeader", "QTableView"));
    mixin(generateFunQt(9008, "qteQTableView_setVerticalHeader", "QTableView"));
    mixin(generateFunQt(9009, "qteQTableView_rowViewportPosition", "QTableView"));
    mixin(generateFunQt(9010, "qteQTableView_rowAt", "QTableView"));
    mixin(generateFunQt(9011, "qteQTableView_setRowHeight", "QTableView"));
    mixin(generateFunQt(9012, "qteQTableView_rowHeight", "QTableView"));
    mixin(generateFunQt(9013, "qteQTableView_columnViewportPosition", "QTableView"));
    mixin(generateFunQt(9014, "qteQTableView_columnAt", "QTableView"));
    mixin(generateFunQt(9015, "qteQTableView_setColumnWidth", "QTableView"));
    mixin(generateFunQt(9016, "qteQTableView_columnWidth", "QTableView"));
    mixin(generateFunQt(9017, "qteQTableView_isRowHidden", "QTableView"));
    mixin(generateFunQt(9018, "qteQTableView_setRowHidden", "QTableView"));
    mixin(generateFunQt(9019, "qteQTableView_isColumnHidden", "QTableView"));
    mixin(generateFunQt(9020, "qteQTableView_setColumnHidden", "QTableView"));
    mixin(generateFunQt(9021, "qteQTableView_setSortingEnabled", "QTableView"));
    mixin(generateFunQt(9022, "qteQTableView_isSortingEnabled", "QTableView"));
    mixin(generateFunQt(9023, "qteQTableView_showGrid", "QTableView"));
    mixin(generateFunQt(9024, "qteQTableView_gridStyle", "QTableView"));
    mixin(generateFunQt(9025, "qteQTableView_setGridStyle", "QTableView"));
    mixin(generateFunQt(9026, "qteQTableView_setWordWrap", "QTableView"));
    mixin(generateFunQt(9027, "qteQTableView_wordWrap", "QTableView"));
    mixin(generateFunQt(9028, "qteQTableView_setCornerButtonEnabled", "QTableView"));
    mixin(generateFunQt(9029, "qteQTableView_isCornerButtonEnabled", "QTableView"));
    mixin(generateFunQt(9030, "qteQTableView_setSpan", "QTableView"));
    mixin(generateFunQt(9031, "qteQTableView_rowSpan", "QTableView"));
    mixin(generateFunQt(9032, "qteQTableView_columnSpan", "QTableView"));
    mixin(generateFunQt(9033, "qteQTableView_clearSpans", "QTableView"));
    mixin(generateFunQt(9034, "qteQTableView_selectRow", "QTableView"));
    mixin(generateFunQt(9035, "qteQTableView_selectColumn", "QTableView"));
    mixin(generateFunQt(9036, "qteQTableView_hideRow", "QTableView"));
    mixin(generateFunQt(9037, "qteQTableView_hideColumn", "QTableView"));
    mixin(generateFunQt(9038, "qteQTableView_showRow", "QTableView"));
    mixin(generateFunQt(9039, "qteQTableView_showColumn", "QTableView"));
    mixin(generateFunQt(9040, "qteQTableView_resizeRowToContents", "QTableView"));
    mixin(generateFunQt(9041, "qteQTableView_resizeRowsToContents", "QTableView"));
    mixin(generateFunQt(9042, "qteQTableView_resizeColumnToContents", "QTableView"));
    mixin(generateFunQt(9043, "qteQTableView_resizeColumnsToContents", "QTableView"));
    mixin(generateFunQt(9044, "qteQTableView_sortByColumn_i", "QTableView"));
    mixin(generateFunQt(9045, "qteQTableView_sortByColumn_ip", "QTableView"));
    mixin(generateFunQt(9046, "qteQTableView_setShowGrid", "QTableView"));
}

static this() {
    registerModule("QTableView", "qte56_views.dll", &loadQTableView);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTableView.
@live class QTableView : QAbstractItemView {
public:
    /// Create QTableView. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[9000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// horizontalHeader
    void* horizontalHeader() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9005])(_wh);
    }

    /// verticalHeader
    void* verticalHeader() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9006])(_wh);
    }

    /// setHorizontalHeader
    QTableView setHorizontalHeader(void* header) {
        (cast(t_v__qp_qp)pFunQt[9007])(_wh, header);
        return this;
    }

    /// setVerticalHeader
    QTableView setVerticalHeader(void* header) {
        (cast(t_v__qp_qp)pFunQt[9008])(_wh, header);
        return this;
    }

    /// rowViewportPosition
    int rowViewportPosition(int row) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9009])(_wh, row);
    }

    /// rowAt
    int rowAt(int y) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9010])(_wh, y);
    }

    /// setRowHeight
    QTableView setRowHeight(int row, int height) {
        (cast(t_v__qp_i_i)pFunQt[9011])(_wh, row, height);
        return this;
    }

    /// rowHeight
    int rowHeight(int row) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9012])(_wh, row);
    }

    /// columnViewportPosition
    int columnViewportPosition(int column) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9013])(_wh, column);
    }

    /// columnAt
    int columnAt(int x) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9014])(_wh, x);
    }

    /// setColumnWidth
    QTableView setColumnWidth(int column, int width) {
        (cast(t_v__qp_i_i)pFunQt[9015])(_wh, column, width);
        return this;
    }

    /// columnWidth
    int columnWidth(int column) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9016])(_wh, column);
    }

    /// isRowHidden
    bool isRowHidden(int row) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[9017])(_wh, row);
    }

    /// setRowHidden
    QTableView setRowHidden(int row, bool hide) {
        (cast(t_v__qp_i_i)pFunQt[9018])(_wh, row, hide ? 1 : 0);
        return this;
    }

    /// isColumnHidden
    bool isColumnHidden(int column) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[9019])(_wh, column);
    }

    /// setColumnHidden
    QTableView setColumnHidden(int column, bool hide) {
        (cast(t_v__qp_i_i)pFunQt[9020])(_wh, column, hide ? 1 : 0);
        return this;
    }

    /// setSortingEnabled
    QTableView setSortingEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[9021])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isSortingEnabled
    bool isSortingEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[9022])(_wh);
    }

    /// showGrid
    bool showGrid() {
        return cast(bool)(cast(t_i__qp)pFunQt[9023])(_wh);
    }

    /// gridStyle
    int gridStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[9024])(_wh);
    }

    /// setGridStyle
    QTableView setGridStyle(int style) {
        (cast(t_v__qp_i)pFunQt[9025])(_wh, style);
        return this;
    }

    /// setWordWrap
    QTableView setWordWrap(bool on) {
        (cast(t_v__qp_i)pFunQt[9026])(_wh, on ? 1 : 0);
        return this;
    }

    /// wordWrap
    bool wordWrap() {
        return cast(bool)(cast(t_i__qp)pFunQt[9027])(_wh);
    }

    /// setCornerButtonEnabled
    QTableView setCornerButtonEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[9028])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isCornerButtonEnabled
    bool isCornerButtonEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[9029])(_wh);
    }

    /// setSpan
    QTableView setSpan(int row, int column, int rowSpan, int columnSpan) {
        (cast(t_v__qp_i_i_i_i)pFunQt[9030])(_wh, row, column, rowSpan, columnSpan);
        return this;
    }

    /// rowSpan
    int rowSpan(int row, int column) {
        return cast(int)(cast(t_i__qp_i_i)pFunQt[9031])(_wh, row, column);
    }

    /// columnSpan
    int columnSpan(int row, int column) {
        return cast(int)(cast(t_i__qp_i_i)pFunQt[9032])(_wh, row, column);
    }

    /// clearSpans
    QTableView clearSpans() {
        (cast(t_v__qp)pFunQt[9033])(_wh);
        return this;
    }

    /// selectRow
    QTableView selectRow(int row) {
        (cast(t_v__qp_i)pFunQt[9034])(_wh, row);
        return this;
    }

    /// selectColumn
    QTableView selectColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9035])(_wh, column);
        return this;
    }

    /// hideRow
    QTableView hideRow(int row) {
        (cast(t_v__qp_i)pFunQt[9036])(_wh, row);
        return this;
    }

    /// hideColumn
    QTableView hideColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9037])(_wh, column);
        return this;
    }

    /// showRow
    QTableView showRow(int row) {
        (cast(t_v__qp_i)pFunQt[9038])(_wh, row);
        return this;
    }

    /// showColumn
    QTableView showColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9039])(_wh, column);
        return this;
    }

    /// resizeRowToContents
    QTableView resizeRowToContents(int row) {
        (cast(t_v__qp_i)pFunQt[9040])(_wh, row);
        return this;
    }

    /// resizeRowsToContents
    QTableView resizeRowsToContents() {
        (cast(t_v__qp)pFunQt[9041])(_wh);
        return this;
    }

    /// resizeColumnToContents
    QTableView resizeColumnToContents(int column) {
        (cast(t_v__qp_i)pFunQt[9042])(_wh, column);
        return this;
    }

    /// resizeColumnsToContents
    QTableView resizeColumnsToContents() {
        (cast(t_v__qp)pFunQt[9043])(_wh);
        return this;
    }

    /// sortByColumn
    QTableView sortByColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9044])(_wh, column);
        return this;
    }

    /// sortByColumn
    QTableView sortByColumn(int column, int order) {
        (cast(t_v__qp_i_i)pFunQt[9045])(_wh, column, order);
        return this;
    }

    /// setShowGrid
    QTableView setShowGrid(bool show) {
        (cast(t_v__qp_i)pFunQt[9046])(_wh, show ? 1 : 0);
        return this;
    }

    // ── QHeaderView typed accessors ──────────────────────────────────────────

    /// Horizontal header — Qt-owned wrapper. Dtor does NOT delete.
    QHeaderView horizontalHeaderObj() {
        return QHeaderView.wrap((cast(t_qp__qp)pFunQt[9005])(_wh));
    }

    /// Vertical header — Qt-owned wrapper. Dtor does NOT delete.
    QHeaderView verticalHeaderObj() {
        return QHeaderView.wrap((cast(t_qp__qp)pFunQt[9006])(_wh));
    }

} // class QTableView
