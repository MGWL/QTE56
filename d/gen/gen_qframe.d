/**
 * gen_qframe.d — GENERATED wrapper for QFrame.
 * Module: QFrame  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qframe;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQFrame() {
    mixin(generateFunQt(2800, "qteQFrame_create", "QFrame"));
    mixin(generateFunQt(2801, "qteQFrame_delete", "QFrame"));
    mixin(generateFunQt(2805, "qteQFrame_frameStyle", "QFrame"));
    mixin(generateFunQt(2806, "qteQFrame_setFrameStyle", "QFrame"));
    mixin(generateFunQt(2807, "qteQFrame_frameWidth", "QFrame"));
    mixin(generateFunQt(2809, "qteQFrame_frameShape", "QFrame"));
    mixin(generateFunQt(2810, "qteQFrame_setFrameShape", "QFrame"));
    mixin(generateFunQt(2811, "qteQFrame_frameShadow", "QFrame"));
    mixin(generateFunQt(2812, "qteQFrame_setFrameShadow", "QFrame"));
    mixin(generateFunQt(2813, "qteQFrame_lineWidth", "QFrame"));
    mixin(generateFunQt(2814, "qteQFrame_setLineWidth", "QFrame"));
    mixin(generateFunQt(2815, "qteQFrame_midLineWidth", "QFrame"));
    mixin(generateFunQt(2816, "qteQFrame_setMidLineWidth", "QFrame"));
    mixin(generateFunQt(2817, "qteQFrame_frameRect", "QFrame"));
    mixin(generateFunQt(2818, "qteQFrame_setFrameRect", "QFrame"));
    mixin(generateFunQt(2819, "qteQFrame_setEventHandler", "QFrame"));
}

static this() {
    registerModule("QFrame", "qte56_widgets.dll", &loadQFrame);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QFrame.
@live class QFrame : QWidget {
public:
    /// Create QFrame. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[2800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// frameStyle
    int frameStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[2805])(_wh);
    }

    /// setFrameStyle
    QFrame setFrameStyle(int p0) {
        (cast(t_v__qp_i)pFunQt[2806])(_wh, p0);
        return this;
    }

    /// frameWidth
    int frameWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[2807])(_wh);
    }

    /// frameShape
    int frameShape() {
        return cast(int)(cast(t_i__qp)pFunQt[2809])(_wh);
    }

    /// setFrameShape
    QFrame setFrameShape(int p0) {
        (cast(t_v__qp_i)pFunQt[2810])(_wh, p0);
        return this;
    }

    /// frameShadow
    int frameShadow() {
        return cast(int)(cast(t_i__qp)pFunQt[2811])(_wh);
    }

    /// setFrameShadow
    QFrame setFrameShadow(int p0) {
        (cast(t_v__qp_i)pFunQt[2812])(_wh, p0);
        return this;
    }

    /// lineWidth
    int lineWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[2813])(_wh);
    }

    /// setLineWidth
    QFrame setLineWidth(int p0) {
        (cast(t_v__qp_i)pFunQt[2814])(_wh, p0);
        return this;
    }

    /// midLineWidth
    int midLineWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[2815])(_wh);
    }

    /// setMidLineWidth
    QFrame setMidLineWidth(int p0) {
        (cast(t_v__qp_i)pFunQt[2816])(_wh, p0);
        return this;
    }

    /// frameRect
    DRect frameRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[2817])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setFrameRect
    QFrame setFrameRect(void* p0) {
        (cast(t_v__qp_qp)pFunQt[2818])(_wh, p0);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QFrame setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[2819])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFrame onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFrame onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFrame onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFrame onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFrame onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFrame onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QFrame onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFrame onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QFrame onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QFrame onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QFrame onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QFrame onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QFrame onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QFrame onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFrame onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFrame onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QFrame onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QFrame
