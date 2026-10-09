/**
 * gen_qstatusbar.d — GENERATED wrapper for QStatusBar.
 * Module: QStatusBar  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qstatusbar;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_i_qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("i__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQStatusBar() {
    mixin(generateFunQt(5600, "qteQStatusBar_create", "QStatusBar"));
    mixin(generateFunQt(5601, "qteQStatusBar_delete", "QStatusBar"));
    mixin(generateFunQt(5605, "qteQStatusBar_addWidget", "QStatusBar"));
    mixin(generateFunQt(5606, "qteQStatusBar_insertWidget", "QStatusBar"));
    mixin(generateFunQt(5607, "qteQStatusBar_addPermanentWidget", "QStatusBar"));
    mixin(generateFunQt(5608, "qteQStatusBar_insertPermanentWidget", "QStatusBar"));
    mixin(generateFunQt(5609, "qteQStatusBar_removeWidget", "QStatusBar"));
    mixin(generateFunQt(5610, "qteQStatusBar_setSizeGripEnabled", "QStatusBar"));
    mixin(generateFunQt(5611, "qteQStatusBar_isSizeGripEnabled", "QStatusBar"));
    mixin(generateFunQt(5612, "qteQStatusBar_currentMessage", "QStatusBar"));
    mixin(generateFunQt(5613, "qteQStatusBar_showMessage", "QStatusBar"));
    mixin(generateFunQt(5614, "qteQStatusBar_clearMessage", "QStatusBar"));
    mixin(generateFunQt(5615, "qteQStatusBar_setEventHandler", "QStatusBar"));
}

static this() {
    registerModule("QStatusBar", "qte56_mainwin.dll", &loadQStatusBar);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QStatusBar.
@live class QStatusBar : QWidget {
public:
    /// Create QStatusBar. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[5600])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap a Qt-owned QStatusBar* returned by QMainWindow::statusBar() etc.
    static QStatusBar wrap(void* wh) {
        auto obj = new QStatusBar(true);
        obj._wh = wh;
        obj._qt_owned = true;
        return obj;
    }

    /// addWidget
    QStatusBar addWidget(void* widget, int stretch) {
        (cast(t_v__qp_qp_i)pFunQt[5605])(_wh, widget, stretch);
        return this;
    }

    /// insertWidget
    int insertWidget(int index, void* widget, int stretch) {
        return cast(int)(cast(t_i__qp_i_qp_i)pFunQt[5606])(_wh, index, widget, stretch);
    }

    /// addPermanentWidget
    QStatusBar addPermanentWidget(void* widget, int stretch) {
        (cast(t_v__qp_qp_i)pFunQt[5607])(_wh, widget, stretch);
        return this;
    }

    /// insertPermanentWidget
    int insertPermanentWidget(int index, void* widget, int stretch) {
        return cast(int)(cast(t_i__qp_i_qp_i)pFunQt[5608])(_wh, index, widget, stretch);
    }

    /// removeWidget
    QStatusBar removeWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[5609])(_wh, widget);
        return this;
    }

    /// setSizeGripEnabled
    QStatusBar setSizeGripEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[5610])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isSizeGripEnabled
    bool isSizeGripEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[5611])(_wh);
    }

    /// currentMessage
    string currentMessage() {
        void* _qs = (cast(t_qp__qp)pFunQt[5612])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// showMessage
    QStatusBar showMessage(string text, int timeout) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp_i)pFunQt[5613])(_wh, _ws_text, timeout);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// clearMessage
    QStatusBar clearMessage() {
        (cast(t_v__qp)pFunQt[5614])(_wh);
        return this;
    }

    /// Connect signal messageChanged → ESlot
    QStatusBar connect_messageChanged(ESlot eslot) {
        connectQt(_wh, "messageChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QStatusBar setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[5615])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStatusBar onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStatusBar onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStatusBar onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QStatusBar onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QStatusBar onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QStatusBar onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QStatusBar onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QStatusBar onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QStatusBar onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QStatusBar onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QStatusBar onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QStatusBar onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QStatusBar onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QStatusBar onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QStatusBar onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QStatusBar onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QStatusBar onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QStatusBar
