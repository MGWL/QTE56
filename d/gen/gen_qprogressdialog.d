/**
 * gen_qprogressdialog.d — GENERATED wrapper for QProgressDialog.
 * Module: QProgressDialog  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qprogressdialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qdialog : QDialog;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQProgressDialog() {
    mixin(generateFunQt(6000, "qteQProgressDialog_create", "QProgressDialog"));
    mixin(generateFunQt(6001, "qteQProgressDialog_delete", "QProgressDialog"));
    mixin(generateFunQt(6002, "qteQProgressDialog_create_text", "QProgressDialog"));
    mixin(generateFunQt(6006, "qteQProgressDialog_setLabel", "QProgressDialog"));
    mixin(generateFunQt(6007, "qteQProgressDialog_setCancelButton", "QProgressDialog"));
    mixin(generateFunQt(6008, "qteQProgressDialog_setBar", "QProgressDialog"));
    mixin(generateFunQt(6009, "qteQProgressDialog_wasCanceled", "QProgressDialog"));
    mixin(generateFunQt(6010, "qteQProgressDialog_minimum", "QProgressDialog"));
    mixin(generateFunQt(6011, "qteQProgressDialog_maximum", "QProgressDialog"));
    mixin(generateFunQt(6012, "qteQProgressDialog_value", "QProgressDialog"));
    mixin(generateFunQt(6014, "qteQProgressDialog_labelText", "QProgressDialog"));
    mixin(generateFunQt(6015, "qteQProgressDialog_minimumDuration", "QProgressDialog"));
    mixin(generateFunQt(6016, "qteQProgressDialog_setAutoReset", "QProgressDialog"));
    mixin(generateFunQt(6017, "qteQProgressDialog_autoReset", "QProgressDialog"));
    mixin(generateFunQt(6018, "qteQProgressDialog_setAutoClose", "QProgressDialog"));
    mixin(generateFunQt(6019, "qteQProgressDialog_autoClose", "QProgressDialog"));
    mixin(generateFunQt(6020, "qteQProgressDialog_cancel", "QProgressDialog"));
    mixin(generateFunQt(6021, "qteQProgressDialog_reset", "QProgressDialog"));
    mixin(generateFunQt(6022, "qteQProgressDialog_setMaximum", "QProgressDialog"));
    mixin(generateFunQt(6023, "qteQProgressDialog_setMinimum", "QProgressDialog"));
    mixin(generateFunQt(6024, "qteQProgressDialog_setRange", "QProgressDialog"));
    mixin(generateFunQt(6025, "qteQProgressDialog_setValue", "QProgressDialog"));
    mixin(generateFunQt(6026, "qteQProgressDialog_setLabelText", "QProgressDialog"));
    mixin(generateFunQt(6027, "qteQProgressDialog_setCancelButtonText", "QProgressDialog"));
    mixin(generateFunQt(6028, "qteQProgressDialog_setMinimumDuration", "QProgressDialog"));
    mixin(generateFunQt(6029, "qteQProgressDialog_setEventHandler", "QProgressDialog"));
}

static this() {
    registerModule("QProgressDialog", "qte56_dialogs.dll", &loadQProgressDialog);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QProgressDialog.
@live class QProgressDialog : QDialog {
public:
    /// Create QProgressDialog. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[6000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Create QProgressDialog with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[6002])(
            _ws, parent);
    }

    /// setLabel
    QProgressDialog setLabel(void* label) {
        (cast(t_v__qp_qp)pFunQt[6006])(_wh, label);
        return this;
    }

    /// setCancelButton
    QProgressDialog setCancelButton(void* button) {
        (cast(t_v__qp_qp)pFunQt[6007])(_wh, button);
        return this;
    }

    /// setBar
    QProgressDialog setBar(void* bar) {
        (cast(t_v__qp_qp)pFunQt[6008])(_wh, bar);
        return this;
    }

    /// wasCanceled
    bool wasCanceled() {
        return cast(bool)(cast(t_i__qp)pFunQt[6009])(_wh);
    }

    /// minimum
    int minimum() {
        return cast(int)(cast(t_i__qp)pFunQt[6010])(_wh);
    }

    /// maximum
    int maximum() {
        return cast(int)(cast(t_i__qp)pFunQt[6011])(_wh);
    }

    /// value
    int value() {
        return cast(int)(cast(t_i__qp)pFunQt[6012])(_wh);
    }

    /// labelText
    string labelText() {
        void* _qs = (cast(t_qp__qp)pFunQt[6014])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// minimumDuration
    int minimumDuration() {
        return cast(int)(cast(t_i__qp)pFunQt[6015])(_wh);
    }

    /// setAutoReset
    QProgressDialog setAutoReset(bool reset) {
        (cast(t_v__qp_i)pFunQt[6016])(_wh, reset ? 1 : 0);
        return this;
    }

    /// autoReset
    bool autoReset() {
        return cast(bool)(cast(t_i__qp)pFunQt[6017])(_wh);
    }

    /// setAutoClose
    QProgressDialog setAutoClose(bool close) {
        (cast(t_v__qp_i)pFunQt[6018])(_wh, close ? 1 : 0);
        return this;
    }

    /// autoClose
    bool autoClose() {
        return cast(bool)(cast(t_i__qp)pFunQt[6019])(_wh);
    }

    /// cancel
    QProgressDialog cancel() {
        (cast(t_v__qp)pFunQt[6020])(_wh);
        return this;
    }

    /// reset
    QProgressDialog reset() {
        (cast(t_v__qp)pFunQt[6021])(_wh);
        return this;
    }

    /// setMaximum
    QProgressDialog setMaximum(int maximum) {
        (cast(t_v__qp_i)pFunQt[6022])(_wh, maximum);
        return this;
    }

    /// setMinimum
    QProgressDialog setMinimum(int minimum) {
        (cast(t_v__qp_i)pFunQt[6023])(_wh, minimum);
        return this;
    }

    /// setRange
    QProgressDialog setRange(int minimum, int maximum) {
        (cast(t_v__qp_i_i)pFunQt[6024])(_wh, minimum, maximum);
        return this;
    }

    /// setValue
    QProgressDialog setValue(int progress) {
        (cast(t_v__qp_i)pFunQt[6025])(_wh, progress);
        return this;
    }

    /// setLabelText
    QProgressDialog setLabelText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[6026])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setCancelButtonText
    QProgressDialog setCancelButtonText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[6027])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setMinimumDuration
    QProgressDialog setMinimumDuration(int ms) {
        (cast(t_v__qp_i)pFunQt[6028])(_wh, ms);
        return this;
    }

    /// Connect signal canceled → ESlot
    QProgressDialog connect_canceled(ESlot eslot) {
        connectQt(_wh, "canceled()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QProgressDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[6029])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressDialog onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressDialog onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressDialog onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QProgressDialog onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QProgressDialog onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QProgressDialog onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QProgressDialog onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QProgressDialog onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QProgressDialog onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressDialog onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressDialog onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressDialog onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressDialog onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QProgressDialog onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QProgressDialog onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QProgressDialog onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QProgressDialog onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QProgressDialog
