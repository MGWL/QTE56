/**
 * gen_qlcdnumber.d — GENERATED wrapper for QLCDNumber.
 * Module: QLCDNumber  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qlcdnumber;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qframe : QFrame;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_d"));
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("v__qp_d"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQLCDNumber() {
    mixin(generateFunQt(5800, "qteQLCDNumber_create", "QLCDNumber"));
    mixin(generateFunQt(5801, "qteQLCDNumber_delete", "QLCDNumber"));
    mixin(generateFunQt(5805, "qteQLCDNumber_smallDecimalPoint", "QLCDNumber"));
    mixin(generateFunQt(5806, "qteQLCDNumber_digitCount", "QLCDNumber"));
    mixin(generateFunQt(5807, "qteQLCDNumber_setDigitCount", "QLCDNumber"));
    mixin(generateFunQt(5808, "qteQLCDNumber_checkOverflow_d", "QLCDNumber"));
    mixin(generateFunQt(5809, "qteQLCDNumber_checkOverflow_i", "QLCDNumber"));
    mixin(generateFunQt(5810, "qteQLCDNumber_mode", "QLCDNumber"));
    mixin(generateFunQt(5811, "qteQLCDNumber_setMode", "QLCDNumber"));
    mixin(generateFunQt(5812, "qteQLCDNumber_segmentStyle", "QLCDNumber"));
    mixin(generateFunQt(5813, "qteQLCDNumber_setSegmentStyle", "QLCDNumber"));
    mixin(generateFunQt(5814, "qteQLCDNumber_value", "QLCDNumber"));
    mixin(generateFunQt(5815, "qteQLCDNumber_intValue", "QLCDNumber"));
    mixin(generateFunQt(5817, "qteQLCDNumber_display_s", "QLCDNumber"));
    mixin(generateFunQt(5818, "qteQLCDNumber_display_i", "QLCDNumber"));
    mixin(generateFunQt(5819, "qteQLCDNumber_display_d", "QLCDNumber"));
    mixin(generateFunQt(5820, "qteQLCDNumber_setHexMode", "QLCDNumber"));
    mixin(generateFunQt(5821, "qteQLCDNumber_setDecMode", "QLCDNumber"));
    mixin(generateFunQt(5822, "qteQLCDNumber_setOctMode", "QLCDNumber"));
    mixin(generateFunQt(5823, "qteQLCDNumber_setBinMode", "QLCDNumber"));
    mixin(generateFunQt(5824, "qteQLCDNumber_setSmallDecimalPoint", "QLCDNumber"));
    mixin(generateFunQt(5825, "qteQLCDNumber_setEventHandler", "QLCDNumber"));
}

static this() {
    registerModule("QLCDNumber", "qte56_widgets.dll", &loadQLCDNumber);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QLCDNumber.
@live class QLCDNumber : QFrame {
public:
    /// Create QLCDNumber. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[5800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// smallDecimalPoint
    bool smallDecimalPoint() {
        return cast(bool)(cast(t_i__qp)pFunQt[5805])(_wh);
    }

    /// digitCount
    int digitCount() {
        return cast(int)(cast(t_i__qp)pFunQt[5806])(_wh);
    }

    /// setDigitCount
    QLCDNumber setDigitCount(int nDigits) {
        (cast(t_v__qp_i)pFunQt[5807])(_wh, nDigits);
        return this;
    }

    /// checkOverflow
    bool checkOverflow(double num) {
        return cast(bool)(cast(t_i__qp_d)pFunQt[5808])(_wh, num);
    }

    /// checkOverflow
    bool checkOverflow(int num) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[5809])(_wh, num);
    }

    /// mode
    int mode() {
        return cast(int)(cast(t_i__qp)pFunQt[5810])(_wh);
    }

    /// setMode
    QLCDNumber setMode(int p0) {
        (cast(t_v__qp_i)pFunQt[5811])(_wh, p0);
        return this;
    }

    /// segmentStyle
    int segmentStyle() {
        return cast(int)(cast(t_i__qp)pFunQt[5812])(_wh);
    }

    /// setSegmentStyle
    QLCDNumber setSegmentStyle(int p0) {
        (cast(t_v__qp_i)pFunQt[5813])(_wh, p0);
        return this;
    }

    /// value
    double value() {
        return cast(double)(cast(t_d__qp)pFunQt[5814])(_wh);
    }

    /// intValue
    int intValue() {
        return cast(int)(cast(t_i__qp)pFunQt[5815])(_wh);
    }

    /// display
    QLCDNumber display(string str) {
        auto _ws_str = toQString(str);
        (cast(t_v__qp_qp)pFunQt[5817])(_wh, _ws_str);
        (cast(t_v__qp)pFunQt[22])(_ws_str);
        return this;
    }

    /// display
    QLCDNumber display(int num) {
        (cast(t_v__qp_i)pFunQt[5818])(_wh, num);
        return this;
    }

    /// display
    QLCDNumber display(double num) {
        (cast(t_v__qp_d)pFunQt[5819])(_wh, num);
        return this;
    }

    /// setHexMode
    QLCDNumber setHexMode() {
        (cast(t_v__qp)pFunQt[5820])(_wh);
        return this;
    }

    /// setDecMode
    QLCDNumber setDecMode() {
        (cast(t_v__qp)pFunQt[5821])(_wh);
        return this;
    }

    /// setOctMode
    QLCDNumber setOctMode() {
        (cast(t_v__qp)pFunQt[5822])(_wh);
        return this;
    }

    /// setBinMode
    QLCDNumber setBinMode() {
        (cast(t_v__qp)pFunQt[5823])(_wh);
        return this;
    }

    /// setSmallDecimalPoint
    QLCDNumber setSmallDecimalPoint(bool p0) {
        (cast(t_v__qp_i)pFunQt[5824])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// Connect signal overflow → ESlot
    QLCDNumber connect_overflow(ESlot eslot) {
        connectQt(_wh, "overflow()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QLCDNumber setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[5825])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLCDNumber onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLCDNumber onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLCDNumber onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLCDNumber onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLCDNumber onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLCDNumber onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QLCDNumber onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLCDNumber onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QLCDNumber onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QLCDNumber onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QLCDNumber onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QLCDNumber onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QLCDNumber onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QLCDNumber onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLCDNumber onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLCDNumber onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QLCDNumber onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QLCDNumber
