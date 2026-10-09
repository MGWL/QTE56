/**
 * gen_qtreeview.d — GENERATED wrapper for QTreeView.
 * Module: QTreeView  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtreeview;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qabstractitemview : QAbstractItemView;
import gen_qheaderview : QHeaderView;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTreeView() {
    mixin(generateFunQt(9400, "qteQTreeView_create", "QTreeView"));
    mixin(generateFunQt(9401, "qteQTreeView_delete", "QTreeView"));
    mixin(generateFunQt(9404, "qteQTreeView_header", "QTreeView"));
    mixin(generateFunQt(9405, "qteQTreeView_setHeader", "QTreeView"));
    mixin(generateFunQt(9406, "qteQTreeView_autoExpandDelay", "QTreeView"));
    mixin(generateFunQt(9407, "qteQTreeView_setAutoExpandDelay", "QTreeView"));
    mixin(generateFunQt(9408, "qteQTreeView_indentation", "QTreeView"));
    mixin(generateFunQt(9409, "qteQTreeView_setIndentation", "QTreeView"));
    mixin(generateFunQt(9410, "qteQTreeView_resetIndentation", "QTreeView"));
    mixin(generateFunQt(9411, "qteQTreeView_rootIsDecorated", "QTreeView"));
    mixin(generateFunQt(9412, "qteQTreeView_setRootIsDecorated", "QTreeView"));
    mixin(generateFunQt(9413, "qteQTreeView_uniformRowHeights", "QTreeView"));
    mixin(generateFunQt(9414, "qteQTreeView_setUniformRowHeights", "QTreeView"));
    mixin(generateFunQt(9415, "qteQTreeView_itemsExpandable", "QTreeView"));
    mixin(generateFunQt(9416, "qteQTreeView_setItemsExpandable", "QTreeView"));
    mixin(generateFunQt(9417, "qteQTreeView_expandsOnDoubleClick", "QTreeView"));
    mixin(generateFunQt(9418, "qteQTreeView_setExpandsOnDoubleClick", "QTreeView"));
    mixin(generateFunQt(9419, "qteQTreeView_columnViewportPosition", "QTreeView"));
    mixin(generateFunQt(9420, "qteQTreeView_columnWidth", "QTreeView"));
    mixin(generateFunQt(9421, "qteQTreeView_setColumnWidth", "QTreeView"));
    mixin(generateFunQt(9422, "qteQTreeView_columnAt", "QTreeView"));
    mixin(generateFunQt(9423, "qteQTreeView_isColumnHidden", "QTreeView"));
    mixin(generateFunQt(9424, "qteQTreeView_setColumnHidden", "QTreeView"));
    mixin(generateFunQt(9425, "qteQTreeView_isHeaderHidden", "QTreeView"));
    mixin(generateFunQt(9426, "qteQTreeView_setHeaderHidden", "QTreeView"));
    mixin(generateFunQt(9427, "qteQTreeView_setSortingEnabled", "QTreeView"));
    mixin(generateFunQt(9428, "qteQTreeView_isSortingEnabled", "QTreeView"));
    mixin(generateFunQt(9429, "qteQTreeView_setAnimated", "QTreeView"));
    mixin(generateFunQt(9430, "qteQTreeView_isAnimated", "QTreeView"));
    mixin(generateFunQt(9431, "qteQTreeView_setAllColumnsShowFocus", "QTreeView"));
    mixin(generateFunQt(9432, "qteQTreeView_allColumnsShowFocus", "QTreeView"));
    mixin(generateFunQt(9433, "qteQTreeView_setWordWrap", "QTreeView"));
    mixin(generateFunQt(9434, "qteQTreeView_wordWrap", "QTreeView"));
    mixin(generateFunQt(9435, "qteQTreeView_setTreePosition", "QTreeView"));
    mixin(generateFunQt(9436, "qteQTreeView_treePosition", "QTreeView"));
    mixin(generateFunQt(9441, "qteQTreeView_hideColumn", "QTreeView"));
    mixin(generateFunQt(9442, "qteQTreeView_showColumn", "QTreeView"));
    mixin(generateFunQt(9443, "qteQTreeView_resizeColumnToContents", "QTreeView"));
    mixin(generateFunQt(9444, "qteQTreeView_sortByColumn_i", "QTreeView"));
    mixin(generateFunQt(9445, "qteQTreeView_sortByColumn_ip", "QTreeView"));
    mixin(generateFunQt(9446, "qteQTreeView_expandAll", "QTreeView"));
    mixin(generateFunQt(9447, "qteQTreeView_collapseAll", "QTreeView"));
    mixin(generateFunQt(9448, "qteQTreeView_expandToDepth", "QTreeView"));
}

static this() {
    registerModule("QTreeView", "qte56_views.dll", &loadQTreeView);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTreeView.
@live class QTreeView : QAbstractItemView {
public:
    /// Create QTreeView. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[9400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// header
    void* header() {
        return cast(void*)(cast(t_qp__qp)pFunQt[9404])(_wh);
    }

    /// setHeader
    QTreeView setHeader(void* header) {
        (cast(t_v__qp_qp)pFunQt[9405])(_wh, header);
        return this;
    }

    /// autoExpandDelay
    int autoExpandDelay() {
        return cast(int)(cast(t_i__qp)pFunQt[9406])(_wh);
    }

    /// setAutoExpandDelay
    QTreeView setAutoExpandDelay(int delay) {
        (cast(t_v__qp_i)pFunQt[9407])(_wh, delay);
        return this;
    }

    /// indentation
    int indentation() {
        return cast(int)(cast(t_i__qp)pFunQt[9408])(_wh);
    }

    /// setIndentation
    QTreeView setIndentation(int i) {
        (cast(t_v__qp_i)pFunQt[9409])(_wh, i);
        return this;
    }

    /// resetIndentation
    QTreeView resetIndentation() {
        (cast(t_v__qp)pFunQt[9410])(_wh);
        return this;
    }

    /// rootIsDecorated
    bool rootIsDecorated() {
        return cast(bool)(cast(t_i__qp)pFunQt[9411])(_wh);
    }

    /// setRootIsDecorated
    QTreeView setRootIsDecorated(bool show) {
        (cast(t_v__qp_i)pFunQt[9412])(_wh, show ? 1 : 0);
        return this;
    }

    /// uniformRowHeights
    bool uniformRowHeights() {
        return cast(bool)(cast(t_i__qp)pFunQt[9413])(_wh);
    }

    /// setUniformRowHeights
    QTreeView setUniformRowHeights(bool uniform) {
        (cast(t_v__qp_i)pFunQt[9414])(_wh, uniform ? 1 : 0);
        return this;
    }

    /// itemsExpandable
    bool itemsExpandable() {
        return cast(bool)(cast(t_i__qp)pFunQt[9415])(_wh);
    }

    /// setItemsExpandable
    QTreeView setItemsExpandable(bool enable) {
        (cast(t_v__qp_i)pFunQt[9416])(_wh, enable ? 1 : 0);
        return this;
    }

    /// expandsOnDoubleClick
    bool expandsOnDoubleClick() {
        return cast(bool)(cast(t_i__qp)pFunQt[9417])(_wh);
    }

    /// setExpandsOnDoubleClick
    QTreeView setExpandsOnDoubleClick(bool enable) {
        (cast(t_v__qp_i)pFunQt[9418])(_wh, enable ? 1 : 0);
        return this;
    }

    /// columnViewportPosition
    int columnViewportPosition(int column) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9419])(_wh, column);
    }

    /// columnWidth
    int columnWidth(int column) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9420])(_wh, column);
    }

    /// setColumnWidth
    QTreeView setColumnWidth(int column, int width) {
        (cast(t_v__qp_i_i)pFunQt[9421])(_wh, column, width);
        return this;
    }

    /// columnAt
    int columnAt(int x) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9422])(_wh, x);
    }

    /// isColumnHidden
    bool isColumnHidden(int column) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[9423])(_wh, column);
    }

    /// setColumnHidden
    QTreeView setColumnHidden(int column, bool hide) {
        (cast(t_v__qp_i_i)pFunQt[9424])(_wh, column, hide ? 1 : 0);
        return this;
    }

    /// isHeaderHidden
    bool isHeaderHidden() {
        return cast(bool)(cast(t_i__qp)pFunQt[9425])(_wh);
    }

    /// setHeaderHidden
    QTreeView setHeaderHidden(bool hide) {
        (cast(t_v__qp_i)pFunQt[9426])(_wh, hide ? 1 : 0);
        return this;
    }

    /// setSortingEnabled
    QTreeView setSortingEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[9427])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isSortingEnabled
    bool isSortingEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[9428])(_wh);
    }

    /// setAnimated
    QTreeView setAnimated(bool enable) {
        (cast(t_v__qp_i)pFunQt[9429])(_wh, enable ? 1 : 0);
        return this;
    }

    /// isAnimated
    bool isAnimated() {
        return cast(bool)(cast(t_i__qp)pFunQt[9430])(_wh);
    }

    /// setAllColumnsShowFocus
    QTreeView setAllColumnsShowFocus(bool enable) {
        (cast(t_v__qp_i)pFunQt[9431])(_wh, enable ? 1 : 0);
        return this;
    }

    /// allColumnsShowFocus
    bool allColumnsShowFocus() {
        return cast(bool)(cast(t_i__qp)pFunQt[9432])(_wh);
    }

    /// setWordWrap
    QTreeView setWordWrap(bool on) {
        (cast(t_v__qp_i)pFunQt[9433])(_wh, on ? 1 : 0);
        return this;
    }

    /// wordWrap
    bool wordWrap() {
        return cast(bool)(cast(t_i__qp)pFunQt[9434])(_wh);
    }

    /// setTreePosition
    QTreeView setTreePosition(int logicalIndex) {
        (cast(t_v__qp_i)pFunQt[9435])(_wh, logicalIndex);
        return this;
    }

    /// treePosition
    int treePosition() {
        return cast(int)(cast(t_i__qp)pFunQt[9436])(_wh);
    }

    /// hideColumn
    QTreeView hideColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9441])(_wh, column);
        return this;
    }

    /// showColumn
    QTreeView showColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9442])(_wh, column);
        return this;
    }

    /// resizeColumnToContents
    QTreeView resizeColumnToContents(int column) {
        (cast(t_v__qp_i)pFunQt[9443])(_wh, column);
        return this;
    }

    /// sortByColumn
    QTreeView sortByColumn(int column) {
        (cast(t_v__qp_i)pFunQt[9444])(_wh, column);
        return this;
    }

    /// sortByColumn
    QTreeView sortByColumn(int column, int order) {
        (cast(t_v__qp_i_i)pFunQt[9445])(_wh, column, order);
        return this;
    }

    /// expandAll
    QTreeView expandAll() {
        (cast(t_v__qp)pFunQt[9446])(_wh);
        return this;
    }

    /// collapseAll
    QTreeView collapseAll() {
        (cast(t_v__qp)pFunQt[9447])(_wh);
        return this;
    }

    /// expandToDepth
    QTreeView expandToDepth(int depth) {
        (cast(t_v__qp_i)pFunQt[9448])(_wh, depth);
        return this;
    }

    // ── QHeaderView typed accessor ───────────────────────────────────────────

    /// Tree header — Qt-owned wrapper. Dtor does NOT delete.
    QHeaderView headerObj() {
        return QHeaderView.wrap((cast(t_qp__qp)pFunQt[9404])(_wh));
    }

} // class QTreeView
