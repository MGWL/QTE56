/**
 * gen_qdockwidget.d — GENERATED wrapper for QDockWidget.
 * Module: QDockWidget  |  DLL: qte56_mainwin.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qdockwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, toQString;
import gen_qwidget : QWidget;
import gen_qobject : QObject; // для типизированной перегрузки setWidget

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQDockWidget() {
    mixin(generateFunQt(10800, "qteQDockWidget_create", "QDockWidget"));
    mixin(generateFunQt(10801, "qteQDockWidget_delete", "QDockWidget"));
    mixin(generateFunQt(10802, "qteQDockWidget_create_text", "QDockWidget"));
    mixin(generateFunQt(10806, "qteQDockWidget_widget", "QDockWidget"));
    mixin(generateFunQt(10807, "qteQDockWidget_setWidget", "QDockWidget"));
    mixin(generateFunQt(10808, "qteQDockWidget_setFeatures", "QDockWidget"));
    mixin(generateFunQt(10809, "qteQDockWidget_features", "QDockWidget"));
    mixin(generateFunQt(10810, "qteQDockWidget_setFloating", "QDockWidget"));
    mixin(generateFunQt(10811, "qteQDockWidget_setAllowedAreas", "QDockWidget"));
    mixin(generateFunQt(10812, "qteQDockWidget_allowedAreas", "QDockWidget"));
    mixin(generateFunQt(10813, "qteQDockWidget_setTitleBarWidget", "QDockWidget"));
    mixin(generateFunQt(10814, "qteQDockWidget_titleBarWidget", "QDockWidget"));
    mixin(generateFunQt(10815, "qteQDockWidget_toggleViewAction", "QDockWidget"));
    mixin(generateFunQt(10816, "qteQDockWidget_setEventHandler", "QDockWidget"));
}

static this() {
    registerModule("QDockWidget", "qte56_mainwin.dll", &loadQDockWidget);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QDockWidget.
@live class QDockWidget : QWidget {
public:
    /// Create QDockWidget. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[10800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Create QDockWidget with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[10802])(
            _ws, parent);
    }

    /// widget
    void* widget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10806])(_wh);
    }

    /// setWidget
    QDockWidget setWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[10807])(_wh, widget);
        return this;
    }

    /// Типизированная версия setWidget: автоматически передаёт ownership Qt.
    QDockWidget setWidget(QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        (cast(t_v__qp_qp)pFunQt[10807])(_wh, wh);
        return this;
    }

    /// setFeatures
    QDockWidget setFeatures(int features) {
        (cast(t_v__qp_i)pFunQt[10808])(_wh, features);
        return this;
    }

    /// features
    int features() {
        return cast(int)(cast(t_i__qp)pFunQt[10809])(_wh);
    }

    /// setFloating
    QDockWidget setFloating(bool floating) {
        (cast(t_v__qp_i)pFunQt[10810])(_wh, floating ? 1 : 0);
        return this;
    }

    /// setAllowedAreas
    QDockWidget setAllowedAreas(int areas) {
        (cast(t_v__qp_i)pFunQt[10811])(_wh, areas);
        return this;
    }

    /// allowedAreas
    int allowedAreas() {
        return cast(int)(cast(t_i__qp)pFunQt[10812])(_wh);
    }

    /// setTitleBarWidget
    QDockWidget setTitleBarWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[10813])(_wh, widget);
        return this;
    }

    /// titleBarWidget
    void* titleBarWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10814])(_wh);
    }

    /// toggleViewAction
    void* toggleViewAction() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10815])(_wh);
    }

    // Signal featuresChanged — unsupported parameter types
    /// Connect signal topLevelChanged → ESlot
    QDockWidget connect_topLevelChanged(ESlot eslot) {
        connectQt(_wh, "topLevelChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // Signal allowedAreasChanged — unsupported parameter types
    /// Connect signal visibilityChanged → ESlot
    QDockWidget connect_visibilityChanged(ESlot eslot) {
        connectQt(_wh, "visibilityChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // Signal dockLocationChanged — unsupported parameter types
    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QDockWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[10816])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDockWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDockWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QDockWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QDockWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QDockWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QDockWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QDockWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QDockWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QDockWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QDockWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QDockWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QDockWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QDockWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QDockWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QDockWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QDockWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QDockWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QDockWidget
