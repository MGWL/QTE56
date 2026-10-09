/**
 * gen_qabstractspinbox.d — GENERATED wrapper for QAbstractSpinBox.
 * Module: QAbstractSpinBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qabstractspinbox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQAbstractSpinBox() {
    mixin(generateFunQt(3400, "qteQAbstractSpinBox_create", "QAbstractSpinBox"));
    mixin(generateFunQt(3401, "qteQAbstractSpinBox_delete", "QAbstractSpinBox"));
    mixin(generateFunQt(3405, "qteQAbstractSpinBox_buttonSymbols", "QAbstractSpinBox"));
    mixin(generateFunQt(3406, "qteQAbstractSpinBox_setButtonSymbols", "QAbstractSpinBox"));
    mixin(generateFunQt(3407, "qteQAbstractSpinBox_setCorrectionMode", "QAbstractSpinBox"));
    mixin(generateFunQt(3408, "qteQAbstractSpinBox_correctionMode", "QAbstractSpinBox"));
    mixin(generateFunQt(3409, "qteQAbstractSpinBox_hasAcceptableInput", "QAbstractSpinBox"));
    mixin(generateFunQt(3410, "qteQAbstractSpinBox_text", "QAbstractSpinBox"));
    mixin(generateFunQt(3411, "qteQAbstractSpinBox_specialValueText", "QAbstractSpinBox"));
    mixin(generateFunQt(3412, "qteQAbstractSpinBox_setSpecialValueText", "QAbstractSpinBox"));
    mixin(generateFunQt(3413, "qteQAbstractSpinBox_wrapping", "QAbstractSpinBox"));
    mixin(generateFunQt(3414, "qteQAbstractSpinBox_setWrapping", "QAbstractSpinBox"));
    mixin(generateFunQt(3415, "qteQAbstractSpinBox_setReadOnly", "QAbstractSpinBox"));
    mixin(generateFunQt(3416, "qteQAbstractSpinBox_isReadOnly", "QAbstractSpinBox"));
    mixin(generateFunQt(3417, "qteQAbstractSpinBox_setKeyboardTracking", "QAbstractSpinBox"));
    mixin(generateFunQt(3418, "qteQAbstractSpinBox_keyboardTracking", "QAbstractSpinBox"));
    mixin(generateFunQt(3419, "qteQAbstractSpinBox_setAlignment", "QAbstractSpinBox"));
    mixin(generateFunQt(3420, "qteQAbstractSpinBox_alignment", "QAbstractSpinBox"));
    mixin(generateFunQt(3421, "qteQAbstractSpinBox_setFrame", "QAbstractSpinBox"));
    mixin(generateFunQt(3422, "qteQAbstractSpinBox_hasFrame", "QAbstractSpinBox"));
    mixin(generateFunQt(3423, "qteQAbstractSpinBox_setAccelerated", "QAbstractSpinBox"));
    mixin(generateFunQt(3424, "qteQAbstractSpinBox_isAccelerated", "QAbstractSpinBox"));
    mixin(generateFunQt(3425, "qteQAbstractSpinBox_setGroupSeparatorShown", "QAbstractSpinBox"));
    mixin(generateFunQt(3426, "qteQAbstractSpinBox_isGroupSeparatorShown", "QAbstractSpinBox"));
    mixin(generateFunQt(3429, "qteQAbstractSpinBox_interpretText", "QAbstractSpinBox"));
    mixin(generateFunQt(3430, "qteQAbstractSpinBox_event", "QAbstractSpinBox"));
    mixin(generateFunQt(3431, "qteQAbstractSpinBox_fixup", "QAbstractSpinBox"));
    mixin(generateFunQt(3432, "qteQAbstractSpinBox_stepBy", "QAbstractSpinBox"));
    mixin(generateFunQt(3433, "qteQAbstractSpinBox_stepUp", "QAbstractSpinBox"));
    mixin(generateFunQt(3434, "qteQAbstractSpinBox_stepDown", "QAbstractSpinBox"));
    mixin(generateFunQt(3435, "qteQAbstractSpinBox_selectAll", "QAbstractSpinBox"));
    mixin(generateFunQt(3436, "qteQAbstractSpinBox_clear", "QAbstractSpinBox"));
    mixin(generateFunQt(3437, "qteQAbstractSpinBox_setEventHandler", "QAbstractSpinBox"));
}

static this() {
    registerModule("QAbstractSpinBox", "qte56_widgets.dll", &loadQAbstractSpinBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAbstractSpinBox.
@live class QAbstractSpinBox : QWidget {
public:
    /// Create QAbstractSpinBox. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[3400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// buttonSymbols
    int buttonSymbols() {
        return cast(int)(cast(t_i__qp)pFunQt[3405])(_wh);
    }

    /// setButtonSymbols
    QAbstractSpinBox setButtonSymbols(int bs) {
        (cast(t_v__qp_i)pFunQt[3406])(_wh, bs);
        return this;
    }

    /// setCorrectionMode
    QAbstractSpinBox setCorrectionMode(int cm) {
        (cast(t_v__qp_i)pFunQt[3407])(_wh, cm);
        return this;
    }

    /// correctionMode
    int correctionMode() {
        return cast(int)(cast(t_i__qp)pFunQt[3408])(_wh);
    }

    /// hasAcceptableInput
    bool hasAcceptableInput() {
        return cast(bool)(cast(t_i__qp)pFunQt[3409])(_wh);
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[3410])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// specialValueText
    string specialValueText() {
        void* _qs = (cast(t_qp__qp)pFunQt[3411])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setSpecialValueText
    QAbstractSpinBox setSpecialValueText(string txt) {
        auto _ws_txt = toQString(txt);
        (cast(t_v__qp_qp)pFunQt[3412])(_wh, _ws_txt);
        (cast(t_v__qp)pFunQt[22])(_ws_txt);
        return this;
    }

    /// wrapping
    bool wrapping() {
        return cast(bool)(cast(t_i__qp)pFunQt[3413])(_wh);
    }

    /// setWrapping
    QAbstractSpinBox setWrapping(bool w) {
        (cast(t_v__qp_i)pFunQt[3414])(_wh, w ? 1 : 0);
        return this;
    }

    /// setReadOnly
    QAbstractSpinBox setReadOnly(bool r) {
        (cast(t_v__qp_i)pFunQt[3415])(_wh, r ? 1 : 0);
        return this;
    }

    /// isReadOnly
    bool isReadOnly() {
        return cast(bool)(cast(t_i__qp)pFunQt[3416])(_wh);
    }

    /// setKeyboardTracking
    QAbstractSpinBox setKeyboardTracking(bool kt) {
        (cast(t_v__qp_i)pFunQt[3417])(_wh, kt ? 1 : 0);
        return this;
    }

    /// keyboardTracking
    bool keyboardTracking() {
        return cast(bool)(cast(t_i__qp)pFunQt[3418])(_wh);
    }

    /// setAlignment
    QAbstractSpinBox setAlignment(int flag) {
        (cast(t_v__qp_i)pFunQt[3419])(_wh, flag);
        return this;
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[3420])(_wh);
    }

    /// setFrame
    QAbstractSpinBox setFrame(bool p0) {
        (cast(t_v__qp_i)pFunQt[3421])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// hasFrame
    bool hasFrame() {
        return cast(bool)(cast(t_i__qp)pFunQt[3422])(_wh);
    }

    /// setAccelerated
    QAbstractSpinBox setAccelerated(bool on) {
        (cast(t_v__qp_i)pFunQt[3423])(_wh, on ? 1 : 0);
        return this;
    }

    /// isAccelerated
    bool isAccelerated() {
        return cast(bool)(cast(t_i__qp)pFunQt[3424])(_wh);
    }

    /// setGroupSeparatorShown
    QAbstractSpinBox setGroupSeparatorShown(bool shown) {
        (cast(t_v__qp_i)pFunQt[3425])(_wh, shown ? 1 : 0);
        return this;
    }

    /// isGroupSeparatorShown
    bool isGroupSeparatorShown() {
        return cast(bool)(cast(t_i__qp)pFunQt[3426])(_wh);
    }

    /// interpretText
    QAbstractSpinBox interpretText() {
        (cast(t_v__qp)pFunQt[3429])(_wh);
        return this;
    }

    /// event
    override bool event(void* event) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[3430])(_wh, event);
    }

    /// fixup
    QAbstractSpinBox fixup(string input) {
        auto _ws_input = toQString(input);
        (cast(t_v__qp_qp)pFunQt[3431])(_wh, _ws_input);
        (cast(t_v__qp)pFunQt[22])(_ws_input);
        return this;
    }

    /// stepBy
    QAbstractSpinBox stepBy(int steps) {
        (cast(t_v__qp_i)pFunQt[3432])(_wh, steps);
        return this;
    }

    /// stepUp
    QAbstractSpinBox stepUp() {
        (cast(t_v__qp)pFunQt[3433])(_wh);
        return this;
    }

    /// stepDown
    QAbstractSpinBox stepDown() {
        (cast(t_v__qp)pFunQt[3434])(_wh);
        return this;
    }

    /// selectAll
    QAbstractSpinBox selectAll() {
        (cast(t_v__qp)pFunQt[3435])(_wh);
        return this;
    }

    /// clear
    QAbstractSpinBox clear() {
        (cast(t_v__qp)pFunQt[3436])(_wh);
        return this;
    }

    /// Connect signal editingFinished → ESlot
    QAbstractSpinBox connect_editingFinished(ESlot eslot) {
        connectQt(_wh, "editingFinished()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QAbstractSpinBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[3437])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSpinBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSpinBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QAbstractSpinBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractSpinBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractSpinBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QAbstractSpinBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QAbstractSpinBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QAbstractSpinBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QAbstractSpinBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSpinBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSpinBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSpinBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QAbstractSpinBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QAbstractSpinBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractSpinBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QAbstractSpinBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QAbstractSpinBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QAbstractSpinBox
