/**
 * gen_qscrollarea.d — GENERATED wrapper for QScrollArea.
 * Module: QScrollArea  |  DLL: qte56_views.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qscrollarea;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i;
import gen_qobject : QObject; // для типизированной перегрузки setWidget

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQScrollArea() {
    mixin(generateFunQt(10000, "qteQScrollArea_create", "QScrollArea"));
    mixin(generateFunQt(10001, "qteQScrollArea_delete", "QScrollArea"));
    mixin(generateFunQt(10002, "qteQScrollArea_show", "QScrollArea"));
    mixin(generateFunQt(10003, "qteQScrollArea_hide", "QScrollArea"));
    mixin(generateFunQt(10004, "qteQScrollArea_update", "QScrollArea"));
    mixin(generateFunQt(10005, "qteQScrollArea_widget", "QScrollArea"));
    mixin(generateFunQt(10006, "qteQScrollArea_setWidget", "QScrollArea"));
    mixin(generateFunQt(10007, "qteQScrollArea_takeWidget", "QScrollArea"));
    mixin(generateFunQt(10008, "qteQScrollArea_widgetResizable", "QScrollArea"));
    mixin(generateFunQt(10009, "qteQScrollArea_setWidgetResizable", "QScrollArea"));
    mixin(generateFunQt(10010, "qteQScrollArea_sizeHint", "QScrollArea"));
    mixin(generateFunQt(10011, "qteQScrollArea_focusNextPrevChild", "QScrollArea"));
    mixin(generateFunQt(10012, "qteQScrollArea_alignment", "QScrollArea"));
    mixin(generateFunQt(10013, "qteQScrollArea_setAlignment", "QScrollArea"));
    mixin(generateFunQt(10014, "qteQScrollArea_ensureVisible", "QScrollArea"));
    mixin(generateFunQt(10015, "qteQScrollArea_ensureWidgetVisible", "QScrollArea"));
    mixin(generateFunQt(10016, "qteQScrollArea_setEventHandler", "QScrollArea"));
}

static this() {
    registerModule("QScrollArea", "qte56_views.dll", &loadQScrollArea);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QScrollArea.
@live class QScrollArea {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QScrollArea. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[10000])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[10001] !is null) {
            (cast(t_v__qp)pFunQt[10001])(_wh);
            _wh = null;
        }
    }

    /// show
    QScrollArea show() {
        (cast(t_v__qp)pFunQt[10002])(_wh);
        return this;
    }

    /// hide
    QScrollArea hide() {
        (cast(t_v__qp)pFunQt[10003])(_wh);
        return this;
    }

    /// update
    QScrollArea update() {
        (cast(t_v__qp)pFunQt[10004])(_wh);
        return this;
    }

    /// widget
    void* widget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10005])(_wh);
    }

    /// setWidget
    QScrollArea setWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[10006])(_wh, widget);
        return this;
    }

    /// Типизированная версия setWidget: автоматически передаёт ownership Qt.
    QScrollArea setWidget(QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        (cast(t_v__qp_qp)pFunQt[10006])(_wh, wh);
        return this;
    }

    /// takeWidget
    void* takeWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[10007])(_wh);
    }

    /// widgetResizable
    bool widgetResizable() {
        return cast(bool)(cast(t_i__qp)pFunQt[10008])(_wh);
    }

    /// setWidgetResizable
    QScrollArea setWidgetResizable(bool resizable) {
        (cast(t_v__qp_i)pFunQt[10009])(_wh, resizable ? 1 : 0);
        return this;
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[10010])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// focusNextPrevChild
    bool focusNextPrevChild(bool next) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[10011])(_wh, next ? 1 : 0);
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[10012])(_wh);
    }

    /// setAlignment
    QScrollArea setAlignment(int p0) {
        (cast(t_v__qp_i)pFunQt[10013])(_wh, p0);
        return this;
    }

    /// ensureVisible
    QScrollArea ensureVisible(int x, int y, int xmargin, int ymargin) {
        (cast(t_v__qp_i_i_i_i)pFunQt[10014])(_wh, x, y, xmargin, ymargin);
        return this;
    }

    /// ensureWidgetVisible
    QScrollArea ensureWidgetVisible(void* childWidget, int xmargin, int ymargin) {
        (cast(t_v__qp_qp_i_i)pFunQt[10015])(_wh, childWidget, xmargin, ymargin);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    QScrollArea setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[10016])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QScrollArea onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QScrollArea onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QScrollArea onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QScrollArea onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QScrollArea onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QScrollArea onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    QScrollArea onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QScrollArea onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    QScrollArea onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    QScrollArea onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    QScrollArea onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    QScrollArea onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    QScrollArea onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    QScrollArea onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QScrollArea onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QScrollArea onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    QScrollArea onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    /// Mark as Qt-owned (call after setLayout / reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QScrollArea
