/**
 * gen_qsplitter.d — GENERATED wrapper for QSplitter.
 * Module: QSplitter  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qsplitter;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, intListFromQStr, intListToQStr, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp;
import gen_qobject : QObject; // для типизированных перегрузок addWidget/insertWidget
import gen_qframe : QFrame;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSplitter() {
    mixin(generateFunQt(8200, "qteQSplitter_create", "QSplitter"));
    mixin(generateFunQt(8201, "qteQSplitter_delete", "QSplitter"));
    mixin(generateFunQt(8205, "qteQSplitter_addWidget", "QSplitter"));
    mixin(generateFunQt(8206, "qteQSplitter_insertWidget", "QSplitter"));
    mixin(generateFunQt(8207, "qteQSplitter_replaceWidget", "QSplitter"));
    mixin(generateFunQt(8208, "qteQSplitter_setOrientation", "QSplitter"));
    mixin(generateFunQt(8209, "qteQSplitter_orientation", "QSplitter"));
    mixin(generateFunQt(8210, "qteQSplitter_setChildrenCollapsible", "QSplitter"));
    mixin(generateFunQt(8211, "qteQSplitter_childrenCollapsible", "QSplitter"));
    mixin(generateFunQt(8212, "qteQSplitter_setCollapsible", "QSplitter"));
    mixin(generateFunQt(8213, "qteQSplitter_isCollapsible", "QSplitter"));
    mixin(generateFunQt(8214, "qteQSplitter_setOpaqueResize", "QSplitter"));
    mixin(generateFunQt(8215, "qteQSplitter_opaqueResize", "QSplitter"));
    mixin(generateFunQt(8216, "qteQSplitter_refresh", "QSplitter"));
    mixin(generateFunQt(8219, "qteQSplitter_handleWidth", "QSplitter"));
    mixin(generateFunQt(8220, "qteQSplitter_setHandleWidth", "QSplitter"));
    mixin(generateFunQt(8221, "qteQSplitter_indexOf", "QSplitter"));
    mixin(generateFunQt(8222, "qteQSplitter_widget", "QSplitter"));
    mixin(generateFunQt(8223, "qteQSplitter_count", "QSplitter"));
    mixin(generateFunQt(8224, "qteQSplitter_getRange", "QSplitter"));
    mixin(generateFunQt(8225, "qteQSplitter_handle", "QSplitter"));
    mixin(generateFunQt(8226, "qteQSplitter_setStretchFactor", "QSplitter"));
    mixin(generateFunQt(8241, "qteQSplitter_sizes",            "QSplitter"));
    mixin(generateFunQt(8242, "qteQSplitter_setSizes",         "QSplitter"));
    mixin(generateFunQt(8240, "qteQSplitter_setEventHandler",  "QSplitter"));
}

static this() {
    registerModule("QSplitter", "qte56_widgets.dll", &loadQSplitter);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSplitter.
@live class QSplitter : QFrame {
public:
    /// Create QSplitter. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[8200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// addWidget
    QSplitter addWidget(void* widget) {
        (cast(t_v__qp_qp)pFunQt[8205])(_wh, widget);
        return this;
    }

    /// Типизированная версия addWidget: автоматически передаёт ownership Qt.
    QSplitter addWidget(QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        (cast(t_v__qp_qp)pFunQt[8205])(_wh, wh);
        return this;
    }

    /// insertWidget
    QSplitter insertWidget(int index, void* widget) {
        (cast(t_v__qp_i_qp)pFunQt[8206])(_wh, index, widget);
        return this;
    }

    /// Типизированная версия insertWidget: автоматически передаёт ownership Qt.
    QSplitter insertWidget(int index, QObject w) {
        if (w is null) return null;
        auto wh = w.getWH();
        w.disown();
        (cast(t_v__qp_i_qp)pFunQt[8206])(_wh, index, wh);
        return this;
    }

    /// replaceWidget
    void* replaceWidget(int index, void* widget) {
        return cast(void*)(cast(t_qp__qp_i_qp)pFunQt[8207])(_wh, index, widget);
    }

    /// setOrientation
    QSplitter setOrientation(int p0) {
        (cast(t_v__qp_i)pFunQt[8208])(_wh, p0);
        return this;
    }

    /// orientation
    int orientation() {
        return cast(int)(cast(t_i__qp)pFunQt[8209])(_wh);
    }

    /// setChildrenCollapsible
    QSplitter setChildrenCollapsible(bool p0) {
        (cast(t_v__qp_i)pFunQt[8210])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// childrenCollapsible
    bool childrenCollapsible() {
        return cast(bool)(cast(t_i__qp)pFunQt[8211])(_wh);
    }

    /// setCollapsible
    QSplitter setCollapsible(int index, bool p1) {
        (cast(t_v__qp_i_i)pFunQt[8212])(_wh, index, p1 ? 1 : 0);
        return this;
    }

    /// isCollapsible
    bool isCollapsible(int index) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[8213])(_wh, index);
    }

    /// setOpaqueResize
    QSplitter setOpaqueResize(bool opaque) {
        (cast(t_v__qp_i)pFunQt[8214])(_wh, opaque ? 1 : 0);
        return this;
    }

    /// opaqueResize
    bool opaqueResize() {
        return cast(bool)(cast(t_i__qp)pFunQt[8215])(_wh);
    }

    /// refresh
    QSplitter refresh() {
        (cast(t_v__qp)pFunQt[8216])(_wh);
        return this;
    }

    /// handleWidth
    int handleWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[8219])(_wh);
    }

    /// setHandleWidth
    QSplitter setHandleWidth(int p0) {
        (cast(t_v__qp_i)pFunQt[8220])(_wh, p0);
        return this;
    }

    /// indexOf
    int indexOf(void* w) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[8221])(_wh, w);
    }

    /// widget
    void* widget(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[8222])(_wh, index);
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[8223])(_wh);
    }

    /// getRange
    QSplitter getRange(int index, void* p1, void* p2) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8224])(_wh, index, p1, p2);
        return this;
    }

    /// handle
    void* handle(int index) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[8225])(_wh, index);
    }

    /// setStretchFactor
    QSplitter setStretchFactor(int index, int stretch) {
        (cast(t_v__qp_i_i)pFunQt[8226])(_wh, index, stretch);
        return this;
    }

    /// sizes — список размеров секций сплиттера (пиксели)
    int[] sizes() {
        return intListFromQStr((cast(t_qp__qp)pFunQt[8241])(_wh));
    }

    /// setSizes — установить размеры секций сплиттера
    QSplitter setSizes(int[] arr) {
        void* qs = intListToQStr(arr);
        (cast(t_v__qp_qp)pFunQt[8242])(_wh, qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return this;
    }

    /// Connect signal splitterMoved → ESlot
    QSplitter connect_splitterMoved(ESlot eslot) {
        connectQt(_wh, "splitterMoved(int,int)", eslot, "invoke_ii(int,int)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QSplitter setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[8240])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSplitter onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSplitter onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QSplitter onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSplitter onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSplitter onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QSplitter onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QSplitter onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QSplitter onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QSplitter onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QSplitter onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QSplitter onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QSplitter onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QSplitter onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QSplitter onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSplitter onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QSplitter onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QSplitter onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QSplitter
