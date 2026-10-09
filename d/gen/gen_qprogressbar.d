/**
 * gen_qprogressbar.d — GENERATED wrapper for QProgressBar.
 * Module: QProgressBar  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qprogressbar;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("v__qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQProgressBar() {
    mixin(generateFunQt(2200, "qteQProgressBar_create", "QProgressBar"));
    mixin(generateFunQt(2201, "qteQProgressBar_delete", "QProgressBar"));
    mixin(generateFunQt(2205, "qteQProgressBar_minimum", "QProgressBar"));
    mixin(generateFunQt(2206, "qteQProgressBar_maximum", "QProgressBar"));
    mixin(generateFunQt(2207, "qteQProgressBar_value", "QProgressBar"));
    mixin(generateFunQt(2208, "qteQProgressBar_text", "QProgressBar"));
    mixin(generateFunQt(2209, "qteQProgressBar_setTextVisible", "QProgressBar"));
    mixin(generateFunQt(2210, "qteQProgressBar_isTextVisible", "QProgressBar"));
    mixin(generateFunQt(2211, "qteQProgressBar_alignment", "QProgressBar"));
    mixin(generateFunQt(2212, "qteQProgressBar_setAlignment", "QProgressBar"));
    mixin(generateFunQt(2215, "qteQProgressBar_orientation", "QProgressBar"));
    mixin(generateFunQt(2216, "qteQProgressBar_setInvertedAppearance", "QProgressBar"));
    mixin(generateFunQt(2217, "qteQProgressBar_invertedAppearance", "QProgressBar"));
    mixin(generateFunQt(2218, "qteQProgressBar_setTextDirection", "QProgressBar"));
    mixin(generateFunQt(2219, "qteQProgressBar_textDirection", "QProgressBar"));
    mixin(generateFunQt(2220, "qteQProgressBar_setFormat", "QProgressBar"));
    mixin(generateFunQt(2221, "qteQProgressBar_resetFormat", "QProgressBar"));
    mixin(generateFunQt(2222, "qteQProgressBar_format", "QProgressBar"));
    mixin(generateFunQt(2223, "qteQProgressBar_reset", "QProgressBar"));
    mixin(generateFunQt(2224, "qteQProgressBar_setRange", "QProgressBar"));
    mixin(generateFunQt(2225, "qteQProgressBar_setMinimum", "QProgressBar"));
    mixin(generateFunQt(2226, "qteQProgressBar_setMaximum", "QProgressBar"));
    mixin(generateFunQt(2227, "qteQProgressBar_setValue", "QProgressBar"));
    mixin(generateFunQt(2228, "qteQProgressBar_setOrientation", "QProgressBar"));
    mixin(generateFunQt(2229, "qteQProgressBar_setEventHandler", "QProgressBar"));
}

static this() {
    registerModule("QProgressBar", "qte56_widgets.dll", &loadQProgressBar);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QProgressBar.
@live class QProgressBar : QWidget {
public:
    /// Create QProgressBar. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[2200])(parent);
    }

    /// Create QProgressBar without parent (top-level widget).
    this() { this(cast(void*)null); }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QProgressBar* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QProgressBar wrap(void* wh) {
        auto w = new QProgressBar(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// minimum
    int minimum() {
        return cast(int)(cast(t_i__qp)pFunQt[2205])(_wh);
    }

    /// maximum
    int maximum() {
        return cast(int)(cast(t_i__qp)pFunQt[2206])(_wh);
    }

    /// value
    int value() {
        return cast(int)(cast(t_i__qp)pFunQt[2207])(_wh);
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[2208])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTextVisible
    QProgressBar setTextVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[2209])(_wh, visible ? 1 : 0);
        return this;
    }

    /// isTextVisible
    bool isTextVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[2210])(_wh);
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[2211])(_wh);
    }

    /// setAlignment
    QProgressBar setAlignment(int alignment) {
        (cast(t_v__qp_i)pFunQt[2212])(_wh, alignment);
        return this;
    }

    /// orientation
    int orientation() {
        return cast(int)(cast(t_i__qp)pFunQt[2215])(_wh);
    }

    /// setInvertedAppearance
    QProgressBar setInvertedAppearance(bool invert) {
        (cast(t_v__qp_i)pFunQt[2216])(_wh, invert ? 1 : 0);
        return this;
    }

    /// invertedAppearance
    bool invertedAppearance() {
        return cast(bool)(cast(t_i__qp)pFunQt[2217])(_wh);
    }

    /// setTextDirection
    QProgressBar setTextDirection(int textDirection) {
        (cast(t_v__qp_i)pFunQt[2218])(_wh, textDirection);
        return this;
    }

    /// textDirection
    int textDirection() {
        return cast(int)(cast(t_i__qp)pFunQt[2219])(_wh);
    }

    /// setFormat
    QProgressBar setFormat(string format) {
        auto _ws_format = toQString(format);
        (cast(t_v__qp_qp)pFunQt[2220])(_wh, _ws_format);
        (cast(t_v__qp)pFunQt[22])(_ws_format);
        return this;
    }

    /// resetFormat
    QProgressBar resetFormat() {
        (cast(t_v__qp)pFunQt[2221])(_wh);
        return this;
    }

    /// format
    string format() {
        void* _qs = (cast(t_qp__qp)pFunQt[2222])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// reset
    QProgressBar reset() {
        (cast(t_v__qp)pFunQt[2223])(_wh);
        return this;
    }

    /// setRange
    QProgressBar setRange(int minimum, int maximum) {
        (cast(t_v__qp_i_i)pFunQt[2224])(_wh, minimum, maximum);
        return this;
    }

    /// setMinimum
    QProgressBar setMinimum(int minimum) {
        (cast(t_v__qp_i)pFunQt[2225])(_wh, minimum);
        return this;
    }

    /// setMaximum
    QProgressBar setMaximum(int maximum) {
        (cast(t_v__qp_i)pFunQt[2226])(_wh, maximum);
        return this;
    }

    /// setValue
    QProgressBar setValue(int value) {
        (cast(t_v__qp_i)pFunQt[2227])(_wh, value);
        return this;
    }

    /// setOrientation
    QProgressBar setOrientation(int p0) {
        (cast(t_v__qp_i)pFunQt[2228])(_wh, p0);
        return this;
    }

    /// Connect signal valueChanged → ESlot
    QProgressBar connect_valueChanged(ESlot eslot) {
        connectQt(_wh, "valueChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QProgressBar setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[2229])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressBar onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressBar onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QProgressBar onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QProgressBar onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QProgressBar onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QProgressBar onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QProgressBar onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QProgressBar onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QProgressBar onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressBar onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressBar onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressBar onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QProgressBar onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QProgressBar onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QProgressBar onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QProgressBar onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QProgressBar onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QProgressBar
