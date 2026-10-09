/**
 * gen_qabstractscrollarea.d — GENERATED wrapper for QAbstractScrollArea.
 * Module: QAbstractScrollArea  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qabstractscrollarea;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i;
import gen_qframe : QFrame;

// New aliases for this module:
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQAbstractScrollArea() {
    mixin(generateFunQt(7400, "qteQAbstractScrollArea_create", "QAbstractScrollArea"));
    mixin(generateFunQt(7401, "qteQAbstractScrollArea_delete", "QAbstractScrollArea"));
    mixin(generateFunQt(7405, "qteQAbstractScrollArea_verticalScrollBarPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7406, "qteQAbstractScrollArea_setVerticalScrollBarPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7407, "qteQAbstractScrollArea_verticalScrollBar", "QAbstractScrollArea"));
    mixin(generateFunQt(7408, "qteQAbstractScrollArea_setVerticalScrollBar", "QAbstractScrollArea"));
    mixin(generateFunQt(7409, "qteQAbstractScrollArea_horizontalScrollBarPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7410, "qteQAbstractScrollArea_setHorizontalScrollBarPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7411, "qteQAbstractScrollArea_horizontalScrollBar", "QAbstractScrollArea"));
    mixin(generateFunQt(7412, "qteQAbstractScrollArea_setHorizontalScrollBar", "QAbstractScrollArea"));
    mixin(generateFunQt(7413, "qteQAbstractScrollArea_cornerWidget", "QAbstractScrollArea"));
    mixin(generateFunQt(7414, "qteQAbstractScrollArea_setCornerWidget", "QAbstractScrollArea"));
    mixin(generateFunQt(7415, "qteQAbstractScrollArea_addScrollBarWidget", "QAbstractScrollArea"));
    mixin(generateFunQt(7416, "qteQAbstractScrollArea_viewport", "QAbstractScrollArea"));
    mixin(generateFunQt(7417, "qteQAbstractScrollArea_setViewport", "QAbstractScrollArea"));
    mixin(generateFunQt(7418, "qteQAbstractScrollArea_maximumViewportSize", "QAbstractScrollArea"));
    mixin(generateFunQt(7421, "qteQAbstractScrollArea_setupViewport", "QAbstractScrollArea"));
    mixin(generateFunQt(7422, "qteQAbstractScrollArea_sizeAdjustPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7423, "qteQAbstractScrollArea_setSizeAdjustPolicy", "QAbstractScrollArea"));
    mixin(generateFunQt(7424, "qteQAbstractScrollArea_setEventHandler", "QAbstractScrollArea"));
}

static this() {
    registerModule("QAbstractScrollArea", "qte56_views.dll", &loadQAbstractScrollArea);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAbstractScrollArea.
@live class QAbstractScrollArea : QFrame {
public:
    /// Create QAbstractScrollArea. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[7400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// verticalScrollBarPolicy
    int verticalScrollBarPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[7405])(_wh);
    }

    /// setVerticalScrollBarPolicy
    QAbstractScrollArea setVerticalScrollBarPolicy(int p0) {
        (cast(t_v__qp_i)pFunQt[7406])(_wh, p0);
        return this;
    }

    /// verticalScrollBar
    void* verticalScrollBar() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7407])(_wh);
    }

    /// setVerticalScrollBar
    QAbstractScrollArea setVerticalScrollBar(void* scrollbar) {
        (cast(t_v__qp_qp)pFunQt[7408])(_wh, scrollbar);
        return this;
    }

    /// horizontalScrollBarPolicy
    int horizontalScrollBarPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[7409])(_wh);
    }

    /// setHorizontalScrollBarPolicy
    QAbstractScrollArea setHorizontalScrollBarPolicy(int p0) {
        (cast(t_v__qp_i)pFunQt[7410])(_wh, p0);
        return this;
    }

    /// horizontalScrollBar
    void* horizontalScrollBar() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7411])(_wh);
    }

    /// setHorizontalScrollBar
    QAbstractScrollArea setHorizontalScrollBar(void* scrollbar) {
        (cast(t_v__qp_qp)pFunQt[7412])(_wh, scrollbar);
        return this;
    }

    /// cornerWidget
    void* cornerWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7413])(_wh);
    }

    /// setCornerWidget
    QAbstractScrollArea setCornerWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[7414])(_wh, widget);
        return this;
    }

    /// addScrollBarWidget
    QAbstractScrollArea addScrollBarWidget(void* widget, int alignment) {
        (cast(t_v__qp_qp_i)pFunQt[7415])(_wh, widget, alignment);
        return this;
    }

    /// viewport
    void* viewport() {
        return cast(void*)(cast(t_qp__qp)pFunQt[7416])(_wh);
    }

    /// setViewport
    QAbstractScrollArea setViewport(void* widget) {
        (cast(t_v__qp_qp)pFunQt[7417])(_wh, widget);
        return this;
    }

    /// maximumViewportSize
    DSize maximumViewportSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[7418])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setupViewport
    QAbstractScrollArea setupViewport(void* viewport) {
        (cast(t_v__qp_qp)pFunQt[7421])(_wh, viewport);
        return this;
    }

    /// sizeAdjustPolicy
    int sizeAdjustPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[7422])(_wh);
    }

    /// setSizeAdjustPolicy
    QAbstractScrollArea setSizeAdjustPolicy(int policy) {
        (cast(t_v__qp_i)pFunQt[7423])(_wh, policy);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QAbstractScrollArea setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[7424])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractScrollArea onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractScrollArea onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractScrollArea onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractScrollArea onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractScrollArea onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractScrollArea onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QAbstractScrollArea onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractScrollArea onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QAbstractScrollArea onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractScrollArea onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractScrollArea onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractScrollArea onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractScrollArea onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QAbstractScrollArea onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractScrollArea onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractScrollArea onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QAbstractScrollArea onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QAbstractScrollArea
