/**
 * gen_qabstractslider.d — GENERATED wrapper for QAbstractSlider.
 * Module: QAbstractSlider  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qabstractslider;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("v__qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQAbstractSlider() {
    mixin(generateFunQt(3200, "qteQAbstractSlider_create", "QAbstractSlider"));
    mixin(generateFunQt(3201, "qteQAbstractSlider_delete", "QAbstractSlider"));
    mixin(generateFunQt(3205, "qteQAbstractSlider_orientation", "QAbstractSlider"));
    mixin(generateFunQt(3206, "qteQAbstractSlider_setMinimum", "QAbstractSlider"));
    mixin(generateFunQt(3207, "qteQAbstractSlider_minimum", "QAbstractSlider"));
    mixin(generateFunQt(3208, "qteQAbstractSlider_setMaximum", "QAbstractSlider"));
    mixin(generateFunQt(3209, "qteQAbstractSlider_maximum", "QAbstractSlider"));
    mixin(generateFunQt(3210, "qteQAbstractSlider_setSingleStep", "QAbstractSlider"));
    mixin(generateFunQt(3211, "qteQAbstractSlider_singleStep", "QAbstractSlider"));
    mixin(generateFunQt(3212, "qteQAbstractSlider_setPageStep", "QAbstractSlider"));
    mixin(generateFunQt(3213, "qteQAbstractSlider_pageStep", "QAbstractSlider"));
    mixin(generateFunQt(3214, "qteQAbstractSlider_setTracking", "QAbstractSlider"));
    mixin(generateFunQt(3215, "qteQAbstractSlider_hasTracking", "QAbstractSlider"));
    mixin(generateFunQt(3216, "qteQAbstractSlider_setSliderDown", "QAbstractSlider"));
    mixin(generateFunQt(3217, "qteQAbstractSlider_isSliderDown", "QAbstractSlider"));
    mixin(generateFunQt(3218, "qteQAbstractSlider_setSliderPosition", "QAbstractSlider"));
    mixin(generateFunQt(3219, "qteQAbstractSlider_sliderPosition", "QAbstractSlider"));
    mixin(generateFunQt(3220, "qteQAbstractSlider_setInvertedAppearance", "QAbstractSlider"));
    mixin(generateFunQt(3221, "qteQAbstractSlider_invertedAppearance", "QAbstractSlider"));
    mixin(generateFunQt(3222, "qteQAbstractSlider_setInvertedControls", "QAbstractSlider"));
    mixin(generateFunQt(3223, "qteQAbstractSlider_invertedControls", "QAbstractSlider"));
    mixin(generateFunQt(3224, "qteQAbstractSlider_value", "QAbstractSlider"));
    mixin(generateFunQt(3225, "qteQAbstractSlider_triggerAction", "QAbstractSlider"));
    mixin(generateFunQt(3226, "qteQAbstractSlider_setValue", "QAbstractSlider"));
    mixin(generateFunQt(3227, "qteQAbstractSlider_setOrientation", "QAbstractSlider"));
    mixin(generateFunQt(3228, "qteQAbstractSlider_setRange", "QAbstractSlider"));
    mixin(generateFunQt(3229, "qteQAbstractSlider_setEventHandler", "QAbstractSlider"));
}

static this() {
    registerModule("QAbstractSlider", "qte56_widgets.dll", &loadQAbstractSlider);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAbstractSlider.
@live class QAbstractSlider : QWidget {
public:
    /// Create QAbstractSlider. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[3200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// orientation
    int orientation() {
        return cast(int)(cast(t_i__qp)pFunQt[3205])(_wh);
    }

    /// setMinimum
    QAbstractSlider setMinimum(int p0) {
        (cast(t_v__qp_i)pFunQt[3206])(_wh, p0);
        return this;
    }

    /// minimum
    int minimum() {
        return cast(int)(cast(t_i__qp)pFunQt[3207])(_wh);
    }

    /// setMaximum
    QAbstractSlider setMaximum(int p0) {
        (cast(t_v__qp_i)pFunQt[3208])(_wh, p0);
        return this;
    }

    /// maximum
    int maximum() {
        return cast(int)(cast(t_i__qp)pFunQt[3209])(_wh);
    }

    /// setSingleStep
    QAbstractSlider setSingleStep(int p0) {
        (cast(t_v__qp_i)pFunQt[3210])(_wh, p0);
        return this;
    }

    /// singleStep
    int singleStep() {
        return cast(int)(cast(t_i__qp)pFunQt[3211])(_wh);
    }

    /// setPageStep
    QAbstractSlider setPageStep(int p0) {
        (cast(t_v__qp_i)pFunQt[3212])(_wh, p0);
        return this;
    }

    /// pageStep
    int pageStep() {
        return cast(int)(cast(t_i__qp)pFunQt[3213])(_wh);
    }

    /// setTracking
    QAbstractSlider setTracking(bool enable) {
        (cast(t_v__qp_i)pFunQt[3214])(_wh, enable ? 1 : 0);
        return this;
    }

    /// hasTracking
    bool hasTracking() {
        return cast(bool)(cast(t_i__qp)pFunQt[3215])(_wh);
    }

    /// setSliderDown
    QAbstractSlider setSliderDown(bool p0) {
        (cast(t_v__qp_i)pFunQt[3216])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isSliderDown
    bool isSliderDown() {
        return cast(bool)(cast(t_i__qp)pFunQt[3217])(_wh);
    }

    /// setSliderPosition
    QAbstractSlider setSliderPosition(int p0) {
        (cast(t_v__qp_i)pFunQt[3218])(_wh, p0);
        return this;
    }

    /// sliderPosition
    int sliderPosition() {
        return cast(int)(cast(t_i__qp)pFunQt[3219])(_wh);
    }

    /// setInvertedAppearance
    QAbstractSlider setInvertedAppearance(bool p0) {
        (cast(t_v__qp_i)pFunQt[3220])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// invertedAppearance
    bool invertedAppearance() {
        return cast(bool)(cast(t_i__qp)pFunQt[3221])(_wh);
    }

    /// setInvertedControls
    QAbstractSlider setInvertedControls(bool p0) {
        (cast(t_v__qp_i)pFunQt[3222])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// invertedControls
    bool invertedControls() {
        return cast(bool)(cast(t_i__qp)pFunQt[3223])(_wh);
    }

    /// value
    int value() {
        return cast(int)(cast(t_i__qp)pFunQt[3224])(_wh);
    }

    /// triggerAction
    QAbstractSlider triggerAction(int action) {
        (cast(t_v__qp_i)pFunQt[3225])(_wh, action);
        return this;
    }

    /// setValue
    QAbstractSlider setValue(int p0) {
        (cast(t_v__qp_i)pFunQt[3226])(_wh, p0);
        return this;
    }

    /// setOrientation
    QAbstractSlider setOrientation(int p0) {
        (cast(t_v__qp_i)pFunQt[3227])(_wh, p0);
        return this;
    }

    /// setRange
    QAbstractSlider setRange(int min, int max) {
        (cast(t_v__qp_i_i)pFunQt[3228])(_wh, min, max);
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QAbstractSlider connect_valueChanged(ESlot eslot) {
        connectQt(_wh, "valueChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sliderPressed → ESlot
    QAbstractSlider connect_sliderPressed(ESlot eslot) {
        connectQt(_wh, "sliderPressed()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal sliderMoved → ESlot
    QAbstractSlider connect_sliderMoved(ESlot eslot) {
        connectQt(_wh, "sliderMoved(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal sliderReleased → ESlot
    QAbstractSlider connect_sliderReleased(ESlot eslot) {
        connectQt(_wh, "sliderReleased()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal rangeChanged → ESlot
    QAbstractSlider connect_rangeChanged(ESlot eslot) {
        connectQt(_wh, "rangeChanged(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    /// Connect signal actionTriggered → ESlot
    QAbstractSlider connect_actionTriggered(ESlot eslot) {
        connectQt(_wh, "actionTriggered(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QAbstractSlider setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[3229])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSlider onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSlider onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSlider onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractSlider onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractSlider onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractSlider onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QAbstractSlider onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractSlider onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QAbstractSlider onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSlider onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSlider onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSlider onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSlider onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QAbstractSlider onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractSlider onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractSlider onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QAbstractSlider onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QAbstractSlider
