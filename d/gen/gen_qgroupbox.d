/**
 * gen_qgroupbox.d — GENERATED wrapper for QGroupBox.
 * Module: QGroupBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qgroupbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQGroupBox() {
    mixin(generateFunQt(2400, "qteQGroupBox_create", "QGroupBox"));
    mixin(generateFunQt(2401, "qteQGroupBox_delete", "QGroupBox"));
    mixin(generateFunQt(2402, "qteQGroupBox_create_text", "QGroupBox"));
    mixin(generateFunQt(2406, "qteQGroupBox_title", "QGroupBox"));
    mixin(generateFunQt(2407, "qteQGroupBox_setTitle", "QGroupBox"));
    mixin(generateFunQt(2408, "qteQGroupBox_alignment", "QGroupBox"));
    mixin(generateFunQt(2409, "qteQGroupBox_setAlignment", "QGroupBox"));
    mixin(generateFunQt(2411, "qteQGroupBox_isFlat", "QGroupBox"));
    mixin(generateFunQt(2412, "qteQGroupBox_setFlat", "QGroupBox"));
    mixin(generateFunQt(2413, "qteQGroupBox_isCheckable", "QGroupBox"));
    mixin(generateFunQt(2414, "qteQGroupBox_setCheckable", "QGroupBox"));
    mixin(generateFunQt(2415, "qteQGroupBox_isChecked", "QGroupBox"));
    mixin(generateFunQt(2416, "qteQGroupBox_setChecked", "QGroupBox"));
    mixin(generateFunQt(2417, "qteQGroupBox_setEventHandler", "QGroupBox"));
}

static this() {
    registerModule("QGroupBox", "qte56_widgets.dll", &loadQGroupBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QGroupBox.
@live class QGroupBox : QWidget {
public:
    /// Create QGroupBox. parent=null → top-level widget.
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[2400])(parent);
    }

    /// Create QGroupBox with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[2402])(
            _ws, parent);
    }

    /// No-op constructor for super() calls and wrap().
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QGroupBox* (e.g. from QUiLoader or findChild).
    static QGroupBox wrap(void* wh) {
        auto w = new QGroupBox(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// title
    string title() {
        void* _qs = (cast(t_qp__qp)pFunQt[2406])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTitle
    QGroupBox setTitle(string title) {
        auto _ws_title = toQString(title);
        (cast(t_v__qp_qp)pFunQt[2407])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        return this;
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[2408])(_wh);
    }

    /// setAlignment
    QGroupBox setAlignment(int alignment) {
        (cast(t_v__qp_i)pFunQt[2409])(_wh, alignment);
        return this;
    }

    /// isFlat
    bool isFlat() {
        return cast(bool)(cast(t_i__qp)pFunQt[2411])(_wh);
    }

    /// setFlat
    QGroupBox setFlat(bool flat) {
        (cast(t_v__qp_i)pFunQt[2412])(_wh, flat ? 1 : 0);
        return this;
    }

    /// isCheckable
    bool isCheckable() {
        return cast(bool)(cast(t_i__qp)pFunQt[2413])(_wh);
    }

    /// setCheckable
    QGroupBox setCheckable(bool checkable) {
        (cast(t_v__qp_i)pFunQt[2414])(_wh, checkable ? 1 : 0);
        return this;
    }

    /// isChecked
    bool isChecked() {
        return cast(bool)(cast(t_i__qp)pFunQt[2415])(_wh);
    }

    /// setChecked
    QGroupBox setChecked(bool checked) {
        (cast(t_v__qp_i)pFunQt[2416])(_wh, checked ? 1 : 0);
        return this;
    }

    /// Connect signal clicked → ESlot
    QGroupBox connect_clicked(ESlot eslot) {
        connectQt(_wh, "clicked(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal toggled → ESlot
    QGroupBox connect_toggled(ESlot eslot) {
        connectQt(_wh, "toggled(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QGroupBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[2417])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QGroupBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QGroupBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QGroupBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QGroupBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QGroupBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QGroupBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QGroupBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QGroupBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QGroupBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QGroupBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QGroupBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QGroupBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QGroupBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QGroupBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QGroupBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QGroupBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QGroupBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QGroupBox
