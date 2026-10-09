/**
 * gen_qheaderview.d — GENERATED wrapper for QHeaderView.
 * Module: QHeaderView  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qheaderview;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQHeaderView() {
    mixin(generateFunQt(9800, "qteQHeaderView_create", "QHeaderView"));
    mixin(generateFunQt(9801, "qteQHeaderView_delete", "QHeaderView"));
    mixin(generateFunQt(9802, "qteQHeaderView_setModel", "QHeaderView"));
    mixin(generateFunQt(9803, "qteQHeaderView_orientation", "QHeaderView"));
    mixin(generateFunQt(9804, "qteQHeaderView_offset", "QHeaderView"));
    mixin(generateFunQt(9805, "qteQHeaderView_length", "QHeaderView"));
    mixin(generateFunQt(9806, "qteQHeaderView_sizeHint", "QHeaderView"));
    mixin(generateFunQt(9807, "qteQHeaderView_setVisible", "QHeaderView"));
    mixin(generateFunQt(9808, "qteQHeaderView_sectionSizeHint", "QHeaderView"));
    mixin(generateFunQt(9809, "qteQHeaderView_visualIndexAt", "QHeaderView"));
    mixin(generateFunQt(9810, "qteQHeaderView_logicalIndexAt_i", "QHeaderView"));
    mixin(generateFunQt(9811, "qteQHeaderView_logicalIndexAt_ii", "QHeaderView"));
    mixin(generateFunQt(9812, "qteQHeaderView_logicalIndexAt_p", "QHeaderView"));
    mixin(generateFunQt(9813, "qteQHeaderView_sectionSize", "QHeaderView"));
    mixin(generateFunQt(9814, "qteQHeaderView_sectionPosition", "QHeaderView"));
    mixin(generateFunQt(9815, "qteQHeaderView_sectionViewportPosition", "QHeaderView"));
    mixin(generateFunQt(9816, "qteQHeaderView_moveSection", "QHeaderView"));
    mixin(generateFunQt(9817, "qteQHeaderView_swapSections", "QHeaderView"));
    mixin(generateFunQt(9818, "qteQHeaderView_resizeSection", "QHeaderView"));
    mixin(generateFunQt(9819, "qteQHeaderView_resizeSections", "QHeaderView"));
    mixin(generateFunQt(9820, "qteQHeaderView_isSectionHidden", "QHeaderView"));
    mixin(generateFunQt(9821, "qteQHeaderView_setSectionHidden", "QHeaderView"));
    mixin(generateFunQt(9822, "qteQHeaderView_hiddenSectionCount", "QHeaderView"));
    mixin(generateFunQt(9823, "qteQHeaderView_hideSection", "QHeaderView"));
    mixin(generateFunQt(9824, "qteQHeaderView_showSection", "QHeaderView"));
    mixin(generateFunQt(9825, "qteQHeaderView_count", "QHeaderView"));
    mixin(generateFunQt(9826, "qteQHeaderView_visualIndex", "QHeaderView"));
    mixin(generateFunQt(9827, "qteQHeaderView_logicalIndex", "QHeaderView"));
    mixin(generateFunQt(9828, "qteQHeaderView_setSectionsMovable", "QHeaderView"));
    mixin(generateFunQt(9829, "qteQHeaderView_sectionsMovable", "QHeaderView"));
    mixin(generateFunQt(9830, "qteQHeaderView_setFirstSectionMovable", "QHeaderView"));
    mixin(generateFunQt(9831, "qteQHeaderView_isFirstSectionMovable", "QHeaderView"));
    mixin(generateFunQt(9832, "qteQHeaderView_setSectionsClickable", "QHeaderView"));
    mixin(generateFunQt(9833, "qteQHeaderView_sectionsClickable", "QHeaderView"));
    mixin(generateFunQt(9834, "qteQHeaderView_setHighlightSections", "QHeaderView"));
    mixin(generateFunQt(9835, "qteQHeaderView_highlightSections", "QHeaderView"));
    mixin(generateFunQt(9836, "qteQHeaderView_sectionResizeMode", "QHeaderView"));
    mixin(generateFunQt(9837, "qteQHeaderView_setSectionResizeMode_p", "QHeaderView"));
    mixin(generateFunQt(9838, "qteQHeaderView_setSectionResizeMode_ip", "QHeaderView"));
    mixin(generateFunQt(9839, "qteQHeaderView_setResizeContentsPrecision", "QHeaderView"));
    mixin(generateFunQt(9840, "qteQHeaderView_resizeContentsPrecision", "QHeaderView"));
    mixin(generateFunQt(9841, "qteQHeaderView_stretchSectionCount", "QHeaderView"));
    mixin(generateFunQt(9842, "qteQHeaderView_setSortIndicatorShown", "QHeaderView"));
    mixin(generateFunQt(9843, "qteQHeaderView_isSortIndicatorShown", "QHeaderView"));
    mixin(generateFunQt(9844, "qteQHeaderView_setSortIndicator", "QHeaderView"));
    mixin(generateFunQt(9845, "qteQHeaderView_sortIndicatorSection", "QHeaderView"));
    mixin(generateFunQt(9846, "qteQHeaderView_sortIndicatorOrder", "QHeaderView"));
    mixin(generateFunQt(9847, "qteQHeaderView_stretchLastSection", "QHeaderView"));
    mixin(generateFunQt(9848, "qteQHeaderView_setStretchLastSection", "QHeaderView"));
    mixin(generateFunQt(9849, "qteQHeaderView_cascadingSectionResizes", "QHeaderView"));
    mixin(generateFunQt(9850, "qteQHeaderView_setCascadingSectionResizes", "QHeaderView"));
    mixin(generateFunQt(9851, "qteQHeaderView_defaultSectionSize", "QHeaderView"));
    mixin(generateFunQt(9852, "qteQHeaderView_setDefaultSectionSize", "QHeaderView"));
    mixin(generateFunQt(9853, "qteQHeaderView_resetDefaultSectionSize", "QHeaderView"));
    mixin(generateFunQt(9854, "qteQHeaderView_minimumSectionSize", "QHeaderView"));
    mixin(generateFunQt(9855, "qteQHeaderView_setMinimumSectionSize", "QHeaderView"));
    mixin(generateFunQt(9856, "qteQHeaderView_maximumSectionSize", "QHeaderView"));
    mixin(generateFunQt(9857, "qteQHeaderView_setMaximumSectionSize", "QHeaderView"));
    mixin(generateFunQt(9858, "qteQHeaderView_defaultAlignment", "QHeaderView"));
    mixin(generateFunQt(9859, "qteQHeaderView_setDefaultAlignment", "QHeaderView"));
    mixin(generateFunQt(9860, "qteQHeaderView_doItemsLayout", "QHeaderView"));
    mixin(generateFunQt(9861, "qteQHeaderView_sectionsMoved", "QHeaderView"));
    mixin(generateFunQt(9862, "qteQHeaderView_sectionsHidden", "QHeaderView"));
    mixin(generateFunQt(9863, "qteQHeaderView_reset", "QHeaderView"));
    mixin(generateFunQt(9864, "qteQHeaderView_setOffset", "QHeaderView"));
    mixin(generateFunQt(9865, "qteQHeaderView_setOffsetToSectionPosition", "QHeaderView"));
    mixin(generateFunQt(9866, "qteQHeaderView_setOffsetToLastSection", "QHeaderView"));
    mixin(generateFunQt(9867, "qteQHeaderView_headerDataChanged", "QHeaderView"));
    mixin(generateFunQt(9868, "qteQHeaderView_create_v", "QHeaderView")); // Vertical ctor
}

static this() {
    registerModule("QHeaderView", "qte56_views.dll", &loadQHeaderView);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QHeaderView.
@live class QHeaderView {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    this(void* ptr, bool qtOwned) { _wh = ptr; _qt_owned = qtOwned; }

public:
    /// Wrap a Qt-owned header pointer (e.g. from horizontalHeader()). Dtor does NOT delete.
    static QHeaderView wrap(void* ptr) {
        if (ptr is null) return null;
        return new QHeaderView(ptr, true);
    }

    /// Create QHeaderView. orientation: 1=Horizontal (default), 2=Vertical.
    this(int orientation = 1, void* parent = null) {
        _qt_owned = (parent !is null);
        if (orientation == 2)
            _wh = (cast(t_qp__qp)pFunQt[9868])(parent);
        else
            _wh = (cast(t_qp__qp)pFunQt[9800])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[9801] !is null) {
            (cast(t_v__qp)pFunQt[9801])(_wh);
            _wh = null;
        }
    }

    /// setModel
    QHeaderView setModel(void* model) {
        (cast(t_v__qp_qp)pFunQt[9802])(_wh, model);
        return this;
    }

    /// orientation
    int orientation() {
        return cast(int)(cast(t_i__qp)pFunQt[9803])(_wh);
    }

    /// offset
    int offset() {
        return cast(int)(cast(t_i__qp)pFunQt[9804])(_wh);
    }

    /// length
    int length() {
        return cast(int)(cast(t_i__qp)pFunQt[9805])(_wh);
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[9806])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setVisible
    QHeaderView setVisible(bool v) {
        (cast(t_v__qp_i)pFunQt[9807])(_wh, v ? 1 : 0);
        return this;
    }

    /// sectionSizeHint
    int sectionSizeHint(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9808])(_wh, logicalIndex);
    }

    /// visualIndexAt
    int visualIndexAt(int position) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9809])(_wh, position);
    }

    /// logicalIndexAt
    int logicalIndexAt(int position) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9810])(_wh, position);
    }

    /// logicalIndexAt
    int logicalIndexAt(int x, int y) {
        return cast(int)(cast(t_i__qp_i_i)pFunQt[9811])(_wh, x, y);
    }

    /// logicalIndexAt
    int logicalIndexAt(void* pos) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[9812])(_wh, pos);
    }

    /// sectionSize
    int sectionSize(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9813])(_wh, logicalIndex);
    }

    /// sectionPosition
    int sectionPosition(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9814])(_wh, logicalIndex);
    }

    /// sectionViewportPosition
    int sectionViewportPosition(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9815])(_wh, logicalIndex);
    }

    /// moveSection
    QHeaderView moveSection(int from, int to) {
        (cast(t_v__qp_i_i)pFunQt[9816])(_wh, from, to);
        return this;
    }

    /// swapSections
    QHeaderView swapSections(int first, int second) {
        (cast(t_v__qp_i_i)pFunQt[9817])(_wh, first, second);
        return this;
    }

    /// resizeSection
    QHeaderView resizeSection(int logicalIndex, int size) {
        (cast(t_v__qp_i_i)pFunQt[9818])(_wh, logicalIndex, size);
        return this;
    }

    /// resizeSections
    QHeaderView resizeSections(int mode) {
        (cast(t_v__qp_i)pFunQt[9819])(_wh, mode);
        return this;
    }

    /// isSectionHidden
    bool isSectionHidden(int logicalIndex) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[9820])(_wh, logicalIndex);
    }

    /// setSectionHidden
    QHeaderView setSectionHidden(int logicalIndex, bool hide) {
        (cast(t_v__qp_i_i)pFunQt[9821])(_wh, logicalIndex, hide ? 1 : 0);
        return this;
    }

    /// hiddenSectionCount
    int hiddenSectionCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9822])(_wh);
    }

    /// hideSection
    QHeaderView hideSection(int logicalIndex) {
        (cast(t_v__qp_i)pFunQt[9823])(_wh, logicalIndex);
        return this;
    }

    /// showSection
    QHeaderView showSection(int logicalIndex) {
        (cast(t_v__qp_i)pFunQt[9824])(_wh, logicalIndex);
        return this;
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[9825])(_wh);
    }

    /// visualIndex
    int visualIndex(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9826])(_wh, logicalIndex);
    }

    /// logicalIndex
    int logicalIndex(int visualIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9827])(_wh, visualIndex);
    }

    /// setSectionsMovable
    QHeaderView setSectionsMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[9828])(_wh, movable ? 1 : 0);
        return this;
    }

    /// sectionsMovable
    bool sectionsMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[9829])(_wh);
    }

    /// setFirstSectionMovable
    QHeaderView setFirstSectionMovable(bool movable) {
        (cast(t_v__qp_i)pFunQt[9830])(_wh, movable ? 1 : 0);
        return this;
    }

    /// isFirstSectionMovable
    bool isFirstSectionMovable() {
        return cast(bool)(cast(t_i__qp)pFunQt[9831])(_wh);
    }

    /// setSectionsClickable
    QHeaderView setSectionsClickable(bool clickable) {
        (cast(t_v__qp_i)pFunQt[9832])(_wh, clickable ? 1 : 0);
        return this;
    }

    /// sectionsClickable
    bool sectionsClickable() {
        return cast(bool)(cast(t_i__qp)pFunQt[9833])(_wh);
    }

    /// setHighlightSections
    QHeaderView setHighlightSections(bool highlight) {
        (cast(t_v__qp_i)pFunQt[9834])(_wh, highlight ? 1 : 0);
        return this;
    }

    /// highlightSections
    bool highlightSections() {
        return cast(bool)(cast(t_i__qp)pFunQt[9835])(_wh);
    }

    /// sectionResizeMode
    int sectionResizeMode(int logicalIndex) {
        return cast(int)(cast(t_i__qp_i)pFunQt[9836])(_wh, logicalIndex);
    }

    /// setSectionResizeMode
    QHeaderView setSectionResizeMode(int mode) {
        (cast(t_v__qp_i)pFunQt[9837])(_wh, mode);
        return this;
    }

    /// setSectionResizeMode
    QHeaderView setSectionResizeMode(int logicalIndex, int mode) {
        (cast(t_v__qp_i_i)pFunQt[9838])(_wh, logicalIndex, mode);
        return this;
    }

    /// setResizeContentsPrecision
    QHeaderView setResizeContentsPrecision(int precision) {
        (cast(t_v__qp_i)pFunQt[9839])(_wh, precision);
        return this;
    }

    /// resizeContentsPrecision
    int resizeContentsPrecision() {
        return cast(int)(cast(t_i__qp)pFunQt[9840])(_wh);
    }

    /// stretchSectionCount
    int stretchSectionCount() {
        return cast(int)(cast(t_i__qp)pFunQt[9841])(_wh);
    }

    /// setSortIndicatorShown
    QHeaderView setSortIndicatorShown(bool show) {
        (cast(t_v__qp_i)pFunQt[9842])(_wh, show ? 1 : 0);
        return this;
    }

    /// isSortIndicatorShown
    bool isSortIndicatorShown() {
        return cast(bool)(cast(t_i__qp)pFunQt[9843])(_wh);
    }

    /// setSortIndicator
    QHeaderView setSortIndicator(int logicalIndex, int order) {
        (cast(t_v__qp_i_i)pFunQt[9844])(_wh, logicalIndex, order);
        return this;
    }

    /// sortIndicatorSection
    int sortIndicatorSection() {
        return cast(int)(cast(t_i__qp)pFunQt[9845])(_wh);
    }

    /// sortIndicatorOrder
    int sortIndicatorOrder() {
        return cast(int)(cast(t_i__qp)pFunQt[9846])(_wh);
    }

    /// stretchLastSection
    bool stretchLastSection() {
        return cast(bool)(cast(t_i__qp)pFunQt[9847])(_wh);
    }

    /// setStretchLastSection
    QHeaderView setStretchLastSection(bool stretch) {
        (cast(t_v__qp_i)pFunQt[9848])(_wh, stretch ? 1 : 0);
        return this;
    }

    /// cascadingSectionResizes
    bool cascadingSectionResizes() {
        return cast(bool)(cast(t_i__qp)pFunQt[9849])(_wh);
    }

    /// setCascadingSectionResizes
    QHeaderView setCascadingSectionResizes(bool enable) {
        (cast(t_v__qp_i)pFunQt[9850])(_wh, enable ? 1 : 0);
        return this;
    }

    /// defaultSectionSize
    int defaultSectionSize() {
        return cast(int)(cast(t_i__qp)pFunQt[9851])(_wh);
    }

    /// setDefaultSectionSize
    QHeaderView setDefaultSectionSize(int size) {
        (cast(t_v__qp_i)pFunQt[9852])(_wh, size);
        return this;
    }

    /// resetDefaultSectionSize
    QHeaderView resetDefaultSectionSize() {
        (cast(t_v__qp)pFunQt[9853])(_wh);
        return this;
    }

    /// minimumSectionSize
    int minimumSectionSize() {
        return cast(int)(cast(t_i__qp)pFunQt[9854])(_wh);
    }

    /// setMinimumSectionSize
    QHeaderView setMinimumSectionSize(int size) {
        (cast(t_v__qp_i)pFunQt[9855])(_wh, size);
        return this;
    }

    /// maximumSectionSize
    int maximumSectionSize() {
        return cast(int)(cast(t_i__qp)pFunQt[9856])(_wh);
    }

    /// setMaximumSectionSize
    QHeaderView setMaximumSectionSize(int size) {
        (cast(t_v__qp_i)pFunQt[9857])(_wh, size);
        return this;
    }

    /// defaultAlignment
    int defaultAlignment() {
        return cast(int)(cast(t_i__qp)pFunQt[9858])(_wh);
    }

    /// setDefaultAlignment
    QHeaderView setDefaultAlignment(int alignment) {
        (cast(t_v__qp_i)pFunQt[9859])(_wh, alignment);
        return this;
    }

    /// doItemsLayout
    QHeaderView doItemsLayout() {
        (cast(t_v__qp)pFunQt[9860])(_wh);
        return this;
    }

    /// sectionsMoved
    bool sectionsMoved() {
        return cast(bool)(cast(t_i__qp)pFunQt[9861])(_wh);
    }

    /// sectionsHidden
    bool sectionsHidden() {
        return cast(bool)(cast(t_i__qp)pFunQt[9862])(_wh);
    }

    /// reset
    QHeaderView reset() {
        (cast(t_v__qp)pFunQt[9863])(_wh);
        return this;
    }

    /// setOffset
    QHeaderView setOffset(int offset) {
        (cast(t_v__qp_i)pFunQt[9864])(_wh, offset);
        return this;
    }

    /// setOffsetToSectionPosition
    QHeaderView setOffsetToSectionPosition(int visualIndex) {
        (cast(t_v__qp_i)pFunQt[9865])(_wh, visualIndex);
        return this;
    }

    /// setOffsetToLastSection
    QHeaderView setOffsetToLastSection() {
        (cast(t_v__qp)pFunQt[9866])(_wh);
        return this;
    }

    /// headerDataChanged
    QHeaderView headerDataChanged(int orientation, int logicalFirst, int logicalLast) {
        (cast(t_v__qp_i_i_i)pFunQt[9867])(_wh, orientation, logicalFirst, logicalLast);
        return this;
    }

    // Signal sectionMoved — unsupported parameter types
    // Signal sectionResized — unsupported parameter types
    /// Connect signal sectionPressed → ESlot
    QHeaderView connect_sectionPressed(ESlot eslot) {
        connectQt(_wh, "sectionPressed(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sectionClicked → ESlot
    QHeaderView connect_sectionClicked(ESlot eslot) {
        connectQt(_wh, "sectionClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sectionEntered → ESlot
    QHeaderView connect_sectionEntered(ESlot eslot) {
        connectQt(_wh, "sectionEntered(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sectionDoubleClicked → ESlot
    QHeaderView connect_sectionDoubleClicked(ESlot eslot) {
        connectQt(_wh, "sectionDoubleClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sectionCountChanged → ESlot
    QHeaderView connect_sectionCountChanged(ESlot eslot) {
        connectQt(_wh, "sectionCountChanged(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal sectionHandleDoubleClicked → ESlot
    QHeaderView connect_sectionHandleDoubleClicked(ESlot eslot) {
        connectQt(_wh, "sectionHandleDoubleClicked(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal geometriesChanged → ESlot
    QHeaderView connect_geometriesChanged(ESlot eslot) {
        connectQt(_wh, "geometriesChanged()", eslot, "invoke_v()");
        return this;
    }

    // Signal sortIndicatorChanged — unsupported parameter types
    /// Mark as Qt-owned (call after setLayout / reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QHeaderView
