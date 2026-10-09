/**
 * gen_qdoublespinbox.d — GENERATED wrapper for QDoubleSpinBox.
 * Module: QDoubleSpinBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qdoublespinbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qabstractspinbox : QAbstractSpinBox;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("d__qp_qp"));
mixin(generateAlias("qp__qp_d"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQDoubleSpinBox() {
    mixin(generateFunQt(8600, "qteQDoubleSpinBox_create", "QDoubleSpinBox"));
    mixin(generateFunQt(8601, "qteQDoubleSpinBox_delete", "QDoubleSpinBox"));
    mixin(generateFunQt(8605, "qteQDoubleSpinBox_value", "QDoubleSpinBox"));
    mixin(generateFunQt(8606, "qteQDoubleSpinBox_prefix", "QDoubleSpinBox"));
    mixin(generateFunQt(8607, "qteQDoubleSpinBox_setPrefix", "QDoubleSpinBox"));
    mixin(generateFunQt(8608, "qteQDoubleSpinBox_suffix", "QDoubleSpinBox"));
    mixin(generateFunQt(8609, "qteQDoubleSpinBox_setSuffix", "QDoubleSpinBox"));
    mixin(generateFunQt(8610, "qteQDoubleSpinBox_cleanText", "QDoubleSpinBox"));
    mixin(generateFunQt(8611, "qteQDoubleSpinBox_singleStep", "QDoubleSpinBox"));
    mixin(generateFunQt(8612, "qteQDoubleSpinBox_setSingleStep", "QDoubleSpinBox"));
    mixin(generateFunQt(8613, "qteQDoubleSpinBox_minimum", "QDoubleSpinBox"));
    mixin(generateFunQt(8614, "qteQDoubleSpinBox_setMinimum", "QDoubleSpinBox"));
    mixin(generateFunQt(8615, "qteQDoubleSpinBox_maximum", "QDoubleSpinBox"));
    mixin(generateFunQt(8616, "qteQDoubleSpinBox_setMaximum", "QDoubleSpinBox"));
    mixin(generateFunQt(8617, "qteQDoubleSpinBox_setRange", "QDoubleSpinBox"));
    mixin(generateFunQt(8618, "qteQDoubleSpinBox_stepType", "QDoubleSpinBox"));
    mixin(generateFunQt(8619, "qteQDoubleSpinBox_setStepType", "QDoubleSpinBox"));
    mixin(generateFunQt(8620, "qteQDoubleSpinBox_decimals", "QDoubleSpinBox"));
    mixin(generateFunQt(8621, "qteQDoubleSpinBox_setDecimals", "QDoubleSpinBox"));
    mixin(generateFunQt(8622, "qteQDoubleSpinBox_valueFromText", "QDoubleSpinBox"));
    mixin(generateFunQt(8623, "qteQDoubleSpinBox_textFromValue", "QDoubleSpinBox"));
    mixin(generateFunQt(8625, "qteQDoubleSpinBox_setValue", "QDoubleSpinBox"));
    mixin(generateFunQt(8657, "qteQDoubleSpinBox_setEventHandler", "QDoubleSpinBox"));
}

static this() {
    registerModule("QDoubleSpinBox", "qte56_widgets.dll", &loadQDoubleSpinBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QDoubleSpinBox.
@live class QDoubleSpinBox : QAbstractSpinBox {
public:
    /// Create QDoubleSpinBox. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[8600])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QDoubleSpinBox* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QDoubleSpinBox wrap(void* wh) {
        auto w = new QDoubleSpinBox(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// value
    double value() {
        return cast(double)(cast(t_d__qp)pFunQt[8605])(_wh);
    }

    /// prefix
    string prefix() {
        void* _qs = (cast(t_qp__qp)pFunQt[8606])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setPrefix
    QDoubleSpinBox setPrefix(string prefix) {
        auto _ws_prefix = toQString(prefix);
        (cast(t_v__qp_qp)pFunQt[8607])(_wh, _ws_prefix);
        (cast(t_v__qp)pFunQt[22])(_ws_prefix);
        return this;
    }

    /// suffix
    string suffix() {
        void* _qs = (cast(t_qp__qp)pFunQt[8608])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setSuffix
    QDoubleSpinBox setSuffix(string suffix) {
        auto _ws_suffix = toQString(suffix);
        (cast(t_v__qp_qp)pFunQt[8609])(_wh, _ws_suffix);
        (cast(t_v__qp)pFunQt[22])(_ws_suffix);
        return this;
    }

    /// cleanText
    string cleanText() {
        void* _qs = (cast(t_qp__qp)pFunQt[8610])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// singleStep
    double singleStep() {
        return cast(double)(cast(t_d__qp)pFunQt[8611])(_wh);
    }

    /// setSingleStep
    QDoubleSpinBox setSingleStep(double val) {
        (cast(t_v__qp_d)pFunQt[8612])(_wh, val);
        return this;
    }

    /// minimum
    double minimum() {
        return cast(double)(cast(t_d__qp)pFunQt[8613])(_wh);
    }

    /// setMinimum
    QDoubleSpinBox setMinimum(double min) {
        (cast(t_v__qp_d)pFunQt[8614])(_wh, min);
        return this;
    }

    /// maximum
    double maximum() {
        return cast(double)(cast(t_d__qp)pFunQt[8615])(_wh);
    }

    /// setMaximum
    QDoubleSpinBox setMaximum(double max) {
        (cast(t_v__qp_d)pFunQt[8616])(_wh, max);
        return this;
    }

    /// setRange
    QDoubleSpinBox setRange(double min, double max) {
        (cast(t_v__qp_d_d)pFunQt[8617])(_wh, min, max);
        return this;
    }

    /// stepType
    int stepType() {
        return cast(int)(cast(t_i__qp)pFunQt[8618])(_wh);
    }

    /// setStepType
    QDoubleSpinBox setStepType(int stepType) {
        (cast(t_v__qp_i)pFunQt[8619])(_wh, stepType);
        return this;
    }

    /// decimals
    int decimals() {
        return cast(int)(cast(t_i__qp)pFunQt[8620])(_wh);
    }

    /// setDecimals
    QDoubleSpinBox setDecimals(int prec) {
        (cast(t_v__qp_i)pFunQt[8621])(_wh, prec);
        return this;
    }

    /// valueFromText
    double valueFromText(string text) {
        auto _ws_text = toQString(text);
        return cast(double)(cast(t_d__qp_qp)pFunQt[8622])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// textFromValue
    string textFromValue(double val) {
        void* _qs = (cast(t_qp__qp_d)pFunQt[8623])(_wh, val);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setValue
    QDoubleSpinBox setValue(double val) {
        (cast(t_v__qp_d)pFunQt[8625])(_wh, val);
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QDoubleSpinBox connect_valueChanged_d(ESlot eslot) {
        connectQt(_wh, "valueChanged(double)", eslot, "invoke_d(double)");
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QDoubleSpinBox connect_valueChanged_s(ESlot eslot) {
        connectQt(_wh, "valueChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QDoubleSpinBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8657])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDoubleSpinBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDoubleSpinBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDoubleSpinBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QDoubleSpinBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QDoubleSpinBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QDoubleSpinBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QDoubleSpinBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QDoubleSpinBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QDoubleSpinBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QDoubleSpinBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QDoubleSpinBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QDoubleSpinBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QDoubleSpinBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QDoubleSpinBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QDoubleSpinBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QDoubleSpinBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QDoubleSpinBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QDoubleSpinBox
