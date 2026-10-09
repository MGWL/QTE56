/**
 * gen_qcolordialog.d — GENERATED wrapper for QColorDialog.
 * Module: QColorDialog  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qcolordialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp, toQString;
import gen_qdialog : QDialog;
import gen_qcolor  : QColor;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_i_i"));  // old — kept for compat
mixin(generateAlias("qp__qp_qp_qp_qp_i"));    // new — getColor(null,initial,parent,title,options)
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQColorDialog() {
    mixin(generateFunQt(13000, "qteQColorDialog_create", "QColorDialog"));
    mixin(generateFunQt(13001, "qteQColorDialog_delete", "QColorDialog"));
    mixin(generateFunQt(13012, "qteQColorDialog_setCurrentColor", "QColorDialog"));
    mixin(generateFunQt(13013, "qteQColorDialog_currentColor", "QColorDialog"));
    mixin(generateFunQt(13014, "qteQColorDialog_selectedColor", "QColorDialog"));
    mixin(generateFunQt(13005, "qteQColorDialog_setOption", "QColorDialog"));
    mixin(generateFunQt(13006, "qteQColorDialog_testOption", "QColorDialog"));
    mixin(generateFunQt(13007, "qteQColorDialog_setOptions", "QColorDialog"));
    mixin(generateFunQt(13008, "qteQColorDialog_options", "QColorDialog"));
    mixin(generateFunQt(13015, "qteQColorDialog_getColor", "QColorDialog"));
    mixin(generateFunQt(13010, "qteQColorDialog_customCount", "QColorDialog"));
    mixin(generateFunQt(13016, "qteQColorDialog_customColor", "QColorDialog"));
    mixin(generateFunQt(13017, "qteQColorDialog_setCustomColor", "QColorDialog"));
    mixin(generateFunQt(13018, "qteQColorDialog_standardColor", "QColorDialog"));
    mixin(generateFunQt(13019, "qteQColorDialog_setStandardColor", "QColorDialog"));
    mixin(generateFunQt(13011, "qteQColorDialog_setEventHandler", "QColorDialog"));
    mixin(generateFunQt(13020, "qteQColorDialog_connect_currentColorChanged", "QColorDialog"));
    mixin(generateFunQt(13021, "qteQColorDialog_connect_colorSelected", "QColorDialog"));
}

static this() {
    registerModule("QColorDialog", "qte56_dialogs.dll", &loadQColorDialog);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QColorDialog.
@live class QColorDialog : QDialog {
public:
    /// Create QColorDialog. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[13000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setCurrentColor (pass color.getWH())
    QColorDialog setCurrentColor(void* color) {
        (cast(t_v__qp_qp)pFunQt[13012])(_wh, color);
        return this;
    }

    /// currentColor — returns caller-owned QColor copy
    QColor currentColor() {
        return QColor.wrap((cast(t_qp__qp)pFunQt[13013])(_wh));
    }

    /// selectedColor — returns caller-owned QColor copy
    QColor selectedColor() {
        return QColor.wrap((cast(t_qp__qp)pFunQt[13014])(_wh));
    }

    /// setOption
    QColorDialog setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[13005])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int option) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[13006])(_wh, option);
    }

    /// setOptions
    QColorDialog setOptions(int options) {
        (cast(t_v__qp_i)pFunQt[13007])(_wh, options);
        return this;
    }

    /// options
    int options() {
        return cast(int)(cast(t_i__qp)pFunQt[13008])(_wh);
    }

    /// getColor (static) — shows dialog, returns selected color (invalid if cancelled)
    /// title="" uses default, options=0 for default options
    static QColor getColor(void* initial = null, void* parent = null, string title = "", int options = 0) {
        auto _ws_title = toQString(title);
        return QColor.wrap((cast(t_qp__qp_qp_qp_qp_i)pFunQt[13015])(null, initial, parent, _ws_title, options));
        (cast(t_v__qp)pFunQt[22])(_ws_title);
    }

    /// customCount (static)
    static int customCount() {
        return cast(int)(cast(t_i__qp)pFunQt[13010])(null);
    }

    /// customColor (static) — returns caller-owned QColor
    static QColor customColor(int index) {
        return QColor.wrap((cast(t_qp__qp_i)pFunQt[13016])(null, index));
    }

    /// setCustomColor (static, pass color.getWH())
    static void setCustomColor(int index, void* color) {
        (cast(t_v__qp_i_qp)pFunQt[13017])(null, index, color);
    }

    /// standardColor (static) — returns caller-owned QColor
    static QColor standardColor(int index) {
        return QColor.wrap((cast(t_qp__qp_i)pFunQt[13018])(null, index));
    }

    /// setStandardColor (static, pass color.getWH())
    static void setStandardColor(int index, void* color) {
        (cast(t_v__qp_i_qp)pFunQt[13019])(null, index, color);
    }

    /// Connect signal currentColorChanged → прямой callback
    /// cb: extern(C) void function(void* dthis, int n, void* colorPtr)
    /// colorPtr — heap-allocated QColor; wrap: QColor.wrap(colorPtr)
    QColorDialog connect_currentColorChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[13020])(_wh, cb, dthis);
        return this;
    }

    /// Connect signal colorSelected → прямой callback
    /// cb: extern(C) void function(void* dthis, int n, void* colorPtr)
    /// colorPtr — heap-allocated QColor; wrap: QColor.wrap(colorPtr)
    QColorDialog connect_colorSelected(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[13021])(_wh, cb, dthis);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QColorDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[13011])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QColorDialog onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QColorDialog onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QColorDialog onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QColorDialog onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QColorDialog onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QColorDialog onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QColorDialog onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QColorDialog onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QColorDialog onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QColorDialog onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QColorDialog onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QColorDialog onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QColorDialog onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QColorDialog onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QColorDialog onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QColorDialog onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QColorDialog onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QColorDialog
