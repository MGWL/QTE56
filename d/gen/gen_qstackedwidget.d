/**
 * gen_qstackedwidget.d — GENERATED wrapper for QStackedWidget.
 * Module: QStackedWidget  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qstackedwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_i_qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qframe : QFrame;
import gen_qobject : QObject; // для типизированных перегрузок addWidget/insertWidget

// New aliases for this module:
mixin(generateAlias("i__qp_i_qp"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQStackedWidget() {
    mixin(generateFunQt(8400, "qteQStackedWidget_create", "QStackedWidget"));
    mixin(generateFunQt(8401, "qteQStackedWidget_delete", "QStackedWidget"));
    mixin(generateFunQt(8405, "qteQStackedWidget_addWidget", "QStackedWidget"));
    mixin(generateFunQt(8406, "qteQStackedWidget_insertWidget", "QStackedWidget"));
    mixin(generateFunQt(8407, "qteQStackedWidget_removeWidget", "QStackedWidget"));
    mixin(generateFunQt(8408, "qteQStackedWidget_currentWidget", "QStackedWidget"));
    mixin(generateFunQt(8409, "qteQStackedWidget_currentIndex", "QStackedWidget"));
    mixin(generateFunQt(8410, "qteQStackedWidget_indexOf", "QStackedWidget"));
    mixin(generateFunQt(8411, "qteQStackedWidget_widget", "QStackedWidget"));
    mixin(generateFunQt(8412, "qteQStackedWidget_count", "QStackedWidget"));
    mixin(generateFunQt(8413, "qteQStackedWidget_setCurrentIndex", "QStackedWidget"));
    mixin(generateFunQt(8414, "qteQStackedWidget_setCurrentWidget", "QStackedWidget"));
    mixin(generateFunQt(8429, "qteQStackedWidget_setEventHandler", "QStackedWidget"));
}

static this() {
    registerModule("QStackedWidget", "qte56_widgets.dll", &loadQStackedWidget);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QStackedWidget.
@live class QStackedWidget : QFrame {
public:
    /// Create QStackedWidget. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[8400])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// addWidget
    int addWidget(void* w) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[8405])(_wh, w);
    }

    /// Типизированная версия addWidget: автоматически передаёт ownership Qt.
    int addWidget(QObject w) {
        if (w is null) return -1;
        auto wh = w.getWH();
        w.disown();
        return cast(int)(cast(t_i__qp_qp)pFunQt[8405])(_wh, wh);
    }

    /// insertWidget
    int insertWidget(int index, void* w) {
        return cast(int)(cast(t_i__qp_i_qp)pFunQt[8406])(_wh, index, w);
    }

    /// Типизированная версия insertWidget: автоматически передаёт ownership Qt.
    int insertWidget(int index, QObject w) {
        if (w is null) return -1;
        auto wh = w.getWH();
        w.disown();
        return cast(int)(cast(t_i__qp_i_qp)pFunQt[8406])(_wh, index, wh);
    }

    /// removeWidget
    QStackedWidget removeWidget(void* w) {
        (cast(t_v__qp_qp)pFunQt[8407])(_wh, w);
        return this;
    }

    /// currentWidget
    void* currentWidget() {
        return cast(void*)(cast(t_qp__qp)pFunQt[8408])(_wh);
    }

    /// currentIndex
    int currentIndex() {
        return cast(int)(cast(t_i__qp)pFunQt[8409])(_wh);
    }

    /// indexOf
    int indexOf(void* p0) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[8410])(_wh, p0);
    }

    /// widget
    void* widget(int p0) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[8411])(_wh, p0);
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[8412])(_wh);
    }

    /// setCurrentIndex
    QStackedWidget setCurrentIndex(int index) {
        (cast(t_v__qp_i)pFunQt[8413])(_wh, index);
        return this;
    }

    /// setCurrentWidget
    QStackedWidget setCurrentWidget(void* w) {
        (cast(t_v__qp_qp)pFunQt[8414])(_wh, w);
        return this;
    }

    /// Connect signal currentChanged → ESlot
    QStackedWidget connect_currentChanged(ESlot eslot) {
        connectQt(_wh, "currentChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal widgetRemoved → ESlot
    QStackedWidget connect_widgetRemoved(ESlot eslot) {
        connectQt(_wh, "widgetRemoved(int)", eslot, "invoke_i(int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QStackedWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8429])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStackedWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStackedWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QStackedWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QStackedWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QStackedWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QStackedWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QStackedWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QStackedWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QStackedWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QStackedWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QStackedWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QStackedWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QStackedWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QStackedWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QStackedWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QStackedWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QStackedWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QStackedWidget
