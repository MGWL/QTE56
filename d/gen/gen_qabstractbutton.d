/**
 * gen_qabstractbutton.d — GENERATED wrapper for QAbstractButton.
 * Module: QAbstractButton  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qabstractbutton;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQAbstractButton() {
    mixin(generateFunQt(3000, "qteQAbstractButton_create", "QAbstractButton"));
    mixin(generateFunQt(3001, "qteQAbstractButton_delete", "QAbstractButton"));
    mixin(generateFunQt(3005, "qteQAbstractButton_setText", "QAbstractButton"));
    mixin(generateFunQt(3006, "qteQAbstractButton_text", "QAbstractButton"));
    mixin(generateFunQt(3007, "qteQAbstractButton_iconSize", "QAbstractButton"));
    mixin(generateFunQt(3008, "qteQAbstractButton_setCheckable", "QAbstractButton"));
    mixin(generateFunQt(3009, "qteQAbstractButton_isCheckable", "QAbstractButton"));
    mixin(generateFunQt(3010, "qteQAbstractButton_isChecked", "QAbstractButton"));
    mixin(generateFunQt(3011, "qteQAbstractButton_setDown", "QAbstractButton"));
    mixin(generateFunQt(3012, "qteQAbstractButton_isDown", "QAbstractButton"));
    mixin(generateFunQt(3013, "qteQAbstractButton_setAutoRepeat", "QAbstractButton"));
    mixin(generateFunQt(3014, "qteQAbstractButton_autoRepeat", "QAbstractButton"));
    mixin(generateFunQt(3015, "qteQAbstractButton_setAutoRepeatDelay", "QAbstractButton"));
    mixin(generateFunQt(3016, "qteQAbstractButton_autoRepeatDelay", "QAbstractButton"));
    mixin(generateFunQt(3017, "qteQAbstractButton_setAutoRepeatInterval", "QAbstractButton"));
    mixin(generateFunQt(3018, "qteQAbstractButton_autoRepeatInterval", "QAbstractButton"));
    mixin(generateFunQt(3019, "qteQAbstractButton_setAutoExclusive", "QAbstractButton"));
    mixin(generateFunQt(3020, "qteQAbstractButton_autoExclusive", "QAbstractButton"));
    mixin(generateFunQt(3021, "qteQAbstractButton_group", "QAbstractButton"));
    mixin(generateFunQt(3022, "qteQAbstractButton_setIconSize", "QAbstractButton"));
    mixin(generateFunQt(3023, "qteQAbstractButton_animateClick", "QAbstractButton"));
    mixin(generateFunQt(3024, "qteQAbstractButton_click", "QAbstractButton"));
    mixin(generateFunQt(3025, "qteQAbstractButton_toggle", "QAbstractButton"));
    mixin(generateFunQt(3026, "qteQAbstractButton_setChecked", "QAbstractButton"));
    mixin(generateFunQt(3027, "qteQAbstractButton_setEventHandler", "QAbstractButton"));
    // Icon
    mixin(generateFunQt(3028, "qteQAbstractButton_setIcon", "QAbstractButton"));
    mixin(generateFunQt(3029, "qteQAbstractButton_icon",    "QAbstractButton"));
}

static this() {
    registerModule("QAbstractButton", "qte56_widgets.dll", &loadQAbstractButton);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAbstractButton.
@live class QAbstractButton : QWidget {
public:
    /// Create QAbstractButton. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[3000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setText
    QAbstractButton setText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[3005])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[3006])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Set button's icon. Pass QIcon.getPtr() as void*.
    QAbstractButton setIcon(void* icon) {
        (cast(t_v__qp_qp)pFunQt[3028])(_wh, icon);
        return this;
    }

    /// Get button's icon. Returns a new heap-allocated QIcon* (caller takes ownership).
    void* icon() {
        return (cast(t_qp__qp)pFunQt[3029])(_wh);
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[3007])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setCheckable
    QAbstractButton setCheckable(bool p0) {
        (cast(t_v__qp_i)pFunQt[3008])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isCheckable
    bool isCheckable() {
        return cast(bool)(cast(t_i__qp)pFunQt[3009])(_wh);
    }

    /// isChecked
    bool isChecked() {
        return cast(bool)(cast(t_i__qp)pFunQt[3010])(_wh);
    }

    /// setDown
    QAbstractButton setDown(bool p0) {
        (cast(t_v__qp_i)pFunQt[3011])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isDown
    bool isDown() {
        return cast(bool)(cast(t_i__qp)pFunQt[3012])(_wh);
    }

    /// setAutoRepeat
    QAbstractButton setAutoRepeat(bool p0) {
        (cast(t_v__qp_i)pFunQt[3013])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// autoRepeat
    bool autoRepeat() {
        return cast(bool)(cast(t_i__qp)pFunQt[3014])(_wh);
    }

    /// setAutoRepeatDelay
    QAbstractButton setAutoRepeatDelay(int p0) {
        (cast(t_v__qp_i)pFunQt[3015])(_wh, p0);
        return this;
    }

    /// autoRepeatDelay
    int autoRepeatDelay() {
        return cast(int)(cast(t_i__qp)pFunQt[3016])(_wh);
    }

    /// setAutoRepeatInterval
    QAbstractButton setAutoRepeatInterval(int p0) {
        (cast(t_v__qp_i)pFunQt[3017])(_wh, p0);
        return this;
    }

    /// autoRepeatInterval
    int autoRepeatInterval() {
        return cast(int)(cast(t_i__qp)pFunQt[3018])(_wh);
    }

    /// setAutoExclusive
    QAbstractButton setAutoExclusive(bool p0) {
        (cast(t_v__qp_i)pFunQt[3019])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// autoExclusive
    bool autoExclusive() {
        return cast(bool)(cast(t_i__qp)pFunQt[3020])(_wh);
    }

    /// group
    void* group() {
        return cast(void*)(cast(t_qp__qp)pFunQt[3021])(_wh);
    }

    /// setIconSize
    QAbstractButton setIconSize(void* size) {
        (cast(t_v__qp_qp)pFunQt[3022])(_wh, size);
        return this;
    }

    /// animateClick
    QAbstractButton animateClick(int msec) {
        (cast(t_v__qp_i)pFunQt[3023])(_wh, msec);
        return this;
    }

    /// click
    QAbstractButton click() {
        (cast(t_v__qp)pFunQt[3024])(_wh);
        return this;
    }

    /// toggle
    QAbstractButton toggle() {
        (cast(t_v__qp)pFunQt[3025])(_wh);
        return this;
    }

    /// setChecked
    QAbstractButton setChecked(bool p0) {
        (cast(t_v__qp_i)pFunQt[3026])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// Connect signal pressed → ESlot
    QAbstractButton connect_pressed(ESlot eslot) {
        connectQt(_wh, "pressed()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal released → ESlot
    QAbstractButton connect_released(ESlot eslot) {
        connectQt(_wh, "released()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal clicked → ESlot
    QAbstractButton connect_clicked(ESlot eslot) {
        connectQt(_wh, "clicked(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal toggled → ESlot
    QAbstractButton connect_toggled(ESlot eslot) {
        connectQt(_wh, "toggled(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QAbstractButton setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[3027])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractButton onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractButton onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractButton onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractButton onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractButton onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractButton onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QAbstractButton onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractButton onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QAbstractButton onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractButton onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractButton onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractButton onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractButton onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QAbstractButton onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractButton onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractButton onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QAbstractButton onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QAbstractButton
