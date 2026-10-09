/**
 * gen_qmenubar.d — GENERATED wrapper for QMenuBar.
 * Module: QMenuBar  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmenubar;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, ptrListFromQStr, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("qp__qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMenuBar() {
    mixin(generateFunQt(4200, "qteQMenuBar_create", "QMenuBar"));
    mixin(generateFunQt(4201, "qteQMenuBar_delete", "QMenuBar"));
    mixin(generateFunQt(4205, "qteQMenuBar_addAction_s", "QMenuBar"));
    mixin(generateFunQt(4206, "qteQMenuBar_addAction_sp", "QMenuBar"));
    mixin(generateFunQt(4207, "qteQMenuBar_addMenu_p", "QMenuBar"));
    mixin(generateFunQt(4208, "qteQMenuBar_addMenu_s", "QMenuBar"));
    mixin(generateFunQt(4209, "qteQMenuBar_addSeparator", "QMenuBar"));
    mixin(generateFunQt(4210, "qteQMenuBar_insertSeparator", "QMenuBar"));
    mixin(generateFunQt(4211, "qteQMenuBar_insertMenu", "QMenuBar"));
    mixin(generateFunQt(4212, "qteQMenuBar_clear", "QMenuBar"));
    mixin(generateFunQt(4213, "qteQMenuBar_activeAction", "QMenuBar"));
    mixin(generateFunQt(4214, "qteQMenuBar_setActiveAction", "QMenuBar"));
    mixin(generateFunQt(4215, "qteQMenuBar_setDefaultUp", "QMenuBar"));
    mixin(generateFunQt(4216, "qteQMenuBar_isDefaultUp", "QMenuBar"));
    mixin(generateFunQt(4220, "qteQMenuBar_actionGeometry", "QMenuBar"));
    mixin(generateFunQt(4221, "qteQMenuBar_actionAt", "QMenuBar"));
    mixin(generateFunQt(4222, "qteQMenuBar_setCornerWidget", "QMenuBar"));
    mixin(generateFunQt(4223, "qteQMenuBar_cornerWidget", "QMenuBar"));
    mixin(generateFunQt(4224, "qteQMenuBar_isNativeMenuBar", "QMenuBar"));
    mixin(generateFunQt(4225, "qteQMenuBar_setNativeMenuBar", "QMenuBar"));
    mixin(generateFunQt(4226, "qteQMenuBar_platformMenuBar", "QMenuBar"));
    mixin(generateFunQt(4229, "qteQMenuBar_actions",         "QMenuBar"));
    mixin(generateFunQt(4228, "qteQMenuBar_setEventHandler", "QMenuBar"));
}

static this() {
    registerModule("QMenuBar", "qte56_mainwin.dll", &loadQMenuBar);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMenuBar.
@live class QMenuBar : QWidget {
public:
    /// Create QMenuBar. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[4200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QMenuBar* pointer.
    static QMenuBar wrap(void* wh) {
        auto m = new QMenuBar(true);
        m._wh = wh;
        m._qt_owned = true;
        return m;
    }

    /// addAction
    void* addAction(string text) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4205])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addAction
    void* addAction(string text, int functor) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[4206])(_wh, _ws_text, functor);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
    }

    /// addMenu
    void* addMenu(void* menu) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4207])(_wh, menu);
    }

    /// addMenu
    void* addMenu(string title) {
        auto _ws_title = toQString(title);
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4208])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
    }

    /// addSeparator
    void* addSeparator() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4209])(_wh);
    }

    /// insertSeparator
    void* insertSeparator(void* before) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4210])(_wh, before);
    }

    /// insertMenu
    void* insertMenu(void* before, void* menu) {
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[4211])(_wh, before, menu);
    }

    /// clear
    QMenuBar clear() {
        (cast(t_v__qp)pFunQt[4212])(_wh);
        return this;
    }

    /// activeAction
    void* activeAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4213])(_wh);
    }

    /// setActiveAction
    QMenuBar setActiveAction(void* action) {
        (cast(t_v__qp_qp)pFunQt[4214])(_wh, action);
        return this;
    }

    /// setDefaultUp
    QMenuBar setDefaultUp(bool p0) {
        (cast(t_v__qp_i)pFunQt[4215])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isDefaultUp
    bool isDefaultUp() {
        return cast(bool)(cast(t_i__qp)pFunQt[4216])(_wh);
    }

    /// actionGeometry
    DRect actionGeometry(void* p0) {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[4220])(_wh, p0);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// actionAt
    void* actionAt(void* p0) {
        return cast(void*)(cast(t_qp__qp_qp)pFunQt[4221])(_wh, p0);
    }

    /// setCornerWidget
    QMenuBar setCornerWidget(void* w, int corner) {
        (cast(t_v__qp_qp_i)pFunQt[4222])(_wh, w, corner);
        return this;
    }

    /// cornerWidget
    void* cornerWidget(int corner) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[4223])(_wh, corner);
    }

    /// isNativeMenuBar
    bool isNativeMenuBar() {
        return cast(bool)(cast(t_i__qp)pFunQt[4224])(_wh);
    }

    /// setNativeMenuBar
    QMenuBar setNativeMenuBar(bool nativeMenuBar) {
        (cast(t_v__qp_i)pFunQt[4225])(_wh, nativeMenuBar ? 1 : 0);
        return this;
    }

    /// platformMenuBar
    void* platformMenuBar() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4226])(_wh);
    }

    /// actions — список QAction* в меню-баре
    void*[] actions() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[4229])(_wh));
    }

    // Signal triggered — unsupported parameter types
    // Signal hovered — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QMenuBar setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[4228])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenuBar onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenuBar onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QMenuBar onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMenuBar onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMenuBar onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QMenuBar onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QMenuBar onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QMenuBar onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QMenuBar onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenuBar onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenuBar onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenuBar onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QMenuBar onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QMenuBar onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMenuBar onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QMenuBar onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QMenuBar onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QMenuBar
