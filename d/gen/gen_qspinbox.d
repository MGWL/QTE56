/**
 * gen_qspinbox.d — GENERATED wrapper for QSpinBox.
 * Module: QSpinBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qspinbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qabstractspinbox : QAbstractSpinBox;

// New aliases for this module:
mixin(generateAlias("v__qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSpinBox() {
    mixin(generateFunQt(1800, "qteQSpinBox_create", "QSpinBox"));
    mixin(generateFunQt(1801, "qteQSpinBox_delete", "QSpinBox"));
    mixin(generateFunQt(1805, "qteQSpinBox_value", "QSpinBox"));
    mixin(generateFunQt(1806, "qteQSpinBox_prefix", "QSpinBox"));
    mixin(generateFunQt(1807, "qteQSpinBox_setPrefix", "QSpinBox"));
    mixin(generateFunQt(1808, "qteQSpinBox_suffix", "QSpinBox"));
    mixin(generateFunQt(1809, "qteQSpinBox_setSuffix", "QSpinBox"));
    mixin(generateFunQt(1810, "qteQSpinBox_cleanText", "QSpinBox"));
    mixin(generateFunQt(1811, "qteQSpinBox_singleStep", "QSpinBox"));
    mixin(generateFunQt(1812, "qteQSpinBox_setSingleStep", "QSpinBox"));
    mixin(generateFunQt(1813, "qteQSpinBox_minimum", "QSpinBox"));
    mixin(generateFunQt(1814, "qteQSpinBox_setMinimum", "QSpinBox"));
    mixin(generateFunQt(1815, "qteQSpinBox_maximum", "QSpinBox"));
    mixin(generateFunQt(1816, "qteQSpinBox_setMaximum", "QSpinBox"));
    mixin(generateFunQt(1817, "qteQSpinBox_setRange", "QSpinBox"));
    mixin(generateFunQt(1818, "qteQSpinBox_stepType", "QSpinBox"));
    mixin(generateFunQt(1819, "qteQSpinBox_setStepType", "QSpinBox"));
    mixin(generateFunQt(1820, "qteQSpinBox_displayIntegerBase", "QSpinBox"));
    mixin(generateFunQt(1821, "qteQSpinBox_setDisplayIntegerBase", "QSpinBox"));
    mixin(generateFunQt(1822, "qteQSpinBox_setValue", "QSpinBox"));
    mixin(generateFunQt(1855, "qteQSpinBox_setEventHandler", "QSpinBox"));
}

static this() {
    registerModule("QSpinBox", "qte56_widgets.dll", &loadQSpinBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSpinBox.
@live class QSpinBox : QAbstractSpinBox {
public:
    /// Create QSpinBox. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[1800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QSpinBox* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QSpinBox wrap(void* wh) {
        auto w = new QSpinBox(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// value
    int value() {
        return cast(int)(cast(t_i__qp)pFunQt[1805])(_wh);
    }

    /// prefix
    string prefix() {
        void* _qs = (cast(t_qp__qp)pFunQt[1806])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setPrefix
    QSpinBox setPrefix(string prefix) {
        auto _ws_prefix = toQString(prefix);
        (cast(t_v__qp_qp)pFunQt[1807])(_wh, _ws_prefix);
        (cast(t_v__qp)pFunQt[22])(_ws_prefix);
        return this;
    }

    /// suffix
    string suffix() {
        void* _qs = (cast(t_qp__qp)pFunQt[1808])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setSuffix
    QSpinBox setSuffix(string suffix) {
        auto _ws_suffix = toQString(suffix);
        (cast(t_v__qp_qp)pFunQt[1809])(_wh, _ws_suffix);
        (cast(t_v__qp)pFunQt[22])(_ws_suffix);
        return this;
    }

    /// cleanText
    string cleanText() {
        void* _qs = (cast(t_qp__qp)pFunQt[1810])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// singleStep
    int singleStep() {
        return cast(int)(cast(t_i__qp)pFunQt[1811])(_wh);
    }

    /// setSingleStep
    QSpinBox setSingleStep(int val) {
        (cast(t_v__qp_i)pFunQt[1812])(_wh, val);
        return this;
    }

    /// minimum
    int minimum() {
        return cast(int)(cast(t_i__qp)pFunQt[1813])(_wh);
    }

    /// setMinimum
    QSpinBox setMinimum(int min) {
        (cast(t_v__qp_i)pFunQt[1814])(_wh, min);
        return this;
    }

    /// maximum
    int maximum() {
        return cast(int)(cast(t_i__qp)pFunQt[1815])(_wh);
    }

    /// setMaximum
    QSpinBox setMaximum(int max) {
        (cast(t_v__qp_i)pFunQt[1816])(_wh, max);
        return this;
    }

    /// setRange
    QSpinBox setRange(int min, int max) {
        (cast(t_v__qp_i_i)pFunQt[1817])(_wh, min, max);
        return this;
    }

    /// stepType
    int stepType() {
        return cast(int)(cast(t_i__qp)pFunQt[1818])(_wh);
    }

    /// setStepType
    QSpinBox setStepType(int stepType) {
        (cast(t_v__qp_i)pFunQt[1819])(_wh, stepType);
        return this;
    }

    /// displayIntegerBase
    int displayIntegerBase() {
        return cast(int)(cast(t_i__qp)pFunQt[1820])(_wh);
    }

    /// setDisplayIntegerBase
    QSpinBox setDisplayIntegerBase(int base) {
        (cast(t_v__qp_i)pFunQt[1821])(_wh, base);
        return this;
    }

    /// setValue
    QSpinBox setValue(int val) {
        (cast(t_v__qp_i)pFunQt[1822])(_wh, val);
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QSpinBox connect_valueChanged_i(ESlot eslot) {
        connectQt(_wh, "valueChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QSpinBox connect_valueChanged_s(ESlot eslot) {
        connectQt(_wh, "valueChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QSpinBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[1855])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSpinBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSpinBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSpinBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSpinBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSpinBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSpinBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QSpinBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSpinBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QSpinBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QSpinBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QSpinBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QSpinBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QSpinBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QSpinBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSpinBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSpinBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QSpinBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QSpinBox
