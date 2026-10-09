/**
 * gen_qfontdialog.d — GENERATED wrapper for QFontDialog.
 * Module: QFontDialog  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qfontdialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp, toQString;
import gen_qdialog : QDialog;
import gen_qfont   : QFont;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("qp__qp_qp_qp_qp_qp_i_i"));  // old — kept for compat
mixin(generateAlias("qp__qp_qp_qp_qp_qp_i"));    // new — getFont with title (void*(null,ok,initial,parent,title,options))
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQFontDialog() {
    mixin(generateFunQt(12000, "qteQFontDialog_create", "QFontDialog"));
    mixin(generateFunQt(12001, "qteQFontDialog_delete", "QFontDialog"));
    mixin(generateFunQt(12011, "qteQFontDialog_setCurrentFont", "QFontDialog"));
    mixin(generateFunQt(12012, "qteQFontDialog_currentFont", "QFontDialog"));
    mixin(generateFunQt(12013, "qteQFontDialog_selectedFont", "QFontDialog"));
    mixin(generateFunQt(12005, "qteQFontDialog_setOption", "QFontDialog"));
    mixin(generateFunQt(12006, "qteQFontDialog_testOption", "QFontDialog"));
    mixin(generateFunQt(12007, "qteQFontDialog_setOptions", "QFontDialog"));
    mixin(generateFunQt(12008, "qteQFontDialog_options", "QFontDialog"));
    mixin(generateFunQt(12014, "qteQFontDialog_getFont_pw", "QFontDialog"));
    mixin(generateFunQt(12015, "qteQFontDialog_getFont_ppwsp", "QFontDialog"));
    mixin(generateFunQt(12010, "qteQFontDialog_setEventHandler", "QFontDialog"));
    mixin(generateFunQt(12016, "qteQFontDialog_connect_currentFontChanged", "QFontDialog"));
    mixin(generateFunQt(12017, "qteQFontDialog_connect_fontSelected", "QFontDialog"));
}

static this() {
    registerModule("QFontDialog", "qte56_dialogs.dll", &loadQFontDialog);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QFontDialog.
@live class QFontDialog : QDialog {
public:
    /// Create QFontDialog. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[12000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setCurrentFont (pass font.getWH())
    QFontDialog setCurrentFont(void* font) {
        (cast(t_v__qp_qp)pFunQt[12011])(_wh, font);
        return this;
    }

    /// currentFont — returns caller-owned QFont copy
    QFont currentFont() {
        return QFont.wrap((cast(t_qp__qp)pFunQt[12012])(_wh));
    }

    /// selectedFont — returns caller-owned QFont copy
    QFont selectedFont() {
        return QFont.wrap((cast(t_qp__qp)pFunQt[12013])(_wh));
    }

    /// setOption
    QFontDialog setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[12005])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int option) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[12006])(_wh, option);
    }

    /// setOptions
    QFontDialog setOptions(int options) {
        (cast(t_v__qp_i)pFunQt[12007])(_wh, options);
        return this;
    }

    /// options
    int options() {
        return cast(int)(cast(t_i__qp)pFunQt[12008])(_wh);
    }

    /// getFont (static) — shows dialog, returns selected font; ok=true if accepted
    static QFont getFont(bool* ok, void* parent = null) {
        return QFont.wrap((cast(t_qp__qp_qp_qp)pFunQt[12014])(null, cast(void*)ok, parent));
    }

    /// getFont (static) — with initial font, title and options
    static QFont getFont(bool* ok, void* initial, void* parent, string title, int options = 0) {
        auto _ws_title = toQString(title);
        return QFont.wrap((cast(t_qp__qp_qp_qp_qp_qp_i)pFunQt[12015])(null, cast(void*)ok, initial, parent, _ws_title, options));
        (cast(t_v__qp)pFunQt[22])(_ws_title);
    }

    /// Connect signal currentFontChanged → прямой callback
    /// cb: extern(C) void function(void* dthis, int n, void* fontPtr)
    /// fontPtr — heap-allocated QFont; wrap: QFont.wrap(fontPtr)
    QFontDialog connect_currentFontChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[12016])(_wh, cb, dthis);
        return this;
    }

    /// Connect signal fontSelected → прямой callback
    /// cb: extern(C) void function(void* dthis, int n, void* fontPtr)
    /// fontPtr — heap-allocated QFont; wrap: QFont.wrap(fontPtr)
    QFontDialog connect_fontSelected(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[12017])(_wh, cb, dthis);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QFontDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[12010])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFontDialog onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFontDialog onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFontDialog onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFontDialog onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFontDialog onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFontDialog onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QFontDialog onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFontDialog onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QFontDialog onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QFontDialog onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QFontDialog onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QFontDialog onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QFontDialog onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QFontDialog onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFontDialog onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFontDialog onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QFontDialog onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QFontDialog
