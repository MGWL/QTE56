/**
 * gen_qtextbrowser.d — GENERATED wrapper for QTextBrowser.
 * Module: QTextBrowser  |  DLL: qte56_text.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qtextbrowser;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString;
import gen_qtextedit : QTextEdit;

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQTextBrowser() {
    mixin(generateFunQt(11200, "qteQTextBrowser_create", "QTextBrowser"));
    mixin(generateFunQt(11201, "qteQTextBrowser_delete", "QTextBrowser"));
    mixin(generateFunQt(11204, "qteQTextBrowser_isBackwardAvailable", "QTextBrowser"));
    mixin(generateFunQt(11205, "qteQTextBrowser_isForwardAvailable", "QTextBrowser"));
    mixin(generateFunQt(11206, "qteQTextBrowser_clearHistory", "QTextBrowser"));
    mixin(generateFunQt(11207, "qteQTextBrowser_historyTitle", "QTextBrowser"));
    mixin(generateFunQt(11209, "qteQTextBrowser_backwardHistoryCount", "QTextBrowser"));
    mixin(generateFunQt(11210, "qteQTextBrowser_forwardHistoryCount", "QTextBrowser"));
    mixin(generateFunQt(11211, "qteQTextBrowser_openExternalLinks", "QTextBrowser"));
    mixin(generateFunQt(11212, "qteQTextBrowser_setOpenExternalLinks", "QTextBrowser"));
    mixin(generateFunQt(11213, "qteQTextBrowser_openLinks", "QTextBrowser"));
    mixin(generateFunQt(11214, "qteQTextBrowser_setOpenLinks", "QTextBrowser"));
    mixin(generateFunQt(11215, "qteQTextBrowser_backward", "QTextBrowser"));
    mixin(generateFunQt(11216, "qteQTextBrowser_forward", "QTextBrowser"));
    mixin(generateFunQt(11217, "qteQTextBrowser_home", "QTextBrowser"));
    mixin(generateFunQt(11218, "qteQTextBrowser_reload", "QTextBrowser"));
    mixin(generateFunQt(11202, "qteQTextBrowser_setSource",             "QTextBrowser"));
    mixin(generateFunQt(11203, "qteQTextBrowser_source",               "QTextBrowser"));
    mixin(generateFunQt(11208, "qteQTextBrowser_historyUrl",            "QTextBrowser"));
    mixin(generateFunQt(11219, "qteQTextBrowser_connect_sourceChanged", "QTextBrowser"));
    mixin(generateFunQt(11220, "qteQTextBrowser_connect_anchorClicked", "QTextBrowser"));
    mixin(generateFunQt(11250, "qteQTextBrowser_setEventHandler",       "QTextBrowser"));
}

static this() {
    registerModule("QTextBrowser", "qte56_text.dll", &loadQTextBrowser);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QTextBrowser.
@live class QTextBrowser : QTextEdit {
public:
    /// Create QTextBrowser. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[11200])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// isBackwardAvailable
    bool isBackwardAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[11204])(_wh);
    }

    /// isForwardAvailable
    bool isForwardAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[11205])(_wh);
    }

    /// clearHistory
    QTextBrowser clearHistory() {
        (cast(t_v__qp)pFunQt[11206])(_wh);
        return this;
    }

    /// historyTitle
    string historyTitle(int p0) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[11207])(_wh, p0);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// backwardHistoryCount
    int backwardHistoryCount() {
        return cast(int)(cast(t_i__qp)pFunQt[11209])(_wh);
    }

    /// forwardHistoryCount
    int forwardHistoryCount() {
        return cast(int)(cast(t_i__qp)pFunQt[11210])(_wh);
    }

    /// openExternalLinks
    bool openExternalLinks() {
        return cast(bool)(cast(t_i__qp)pFunQt[11211])(_wh);
    }

    /// setOpenExternalLinks
    QTextBrowser setOpenExternalLinks(bool open) {
        (cast(t_v__qp_i)pFunQt[11212])(_wh, open ? 1 : 0);
        return this;
    }

    /// openLinks
    bool openLinks() {
        return cast(bool)(cast(t_i__qp)pFunQt[11213])(_wh);
    }

    /// setOpenLinks
    QTextBrowser setOpenLinks(bool open) {
        (cast(t_v__qp_i)pFunQt[11214])(_wh, open ? 1 : 0);
        return this;
    }

    /// backward
    QTextBrowser backward() {
        (cast(t_v__qp)pFunQt[11215])(_wh);
        return this;
    }

    /// forward
    QTextBrowser forward() {
        (cast(t_v__qp)pFunQt[11216])(_wh);
        return this;
    }

    /// home
    QTextBrowser home() {
        (cast(t_v__qp)pFunQt[11217])(_wh);
        return this;
    }

    /// reload
    QTextBrowser reload() {
        (cast(t_v__qp)pFunQt[11218])(_wh);
        return this;
    }

    /// Connect signal backwardAvailable → ESlot
    QTextBrowser connect_backwardAvailable(ESlot eslot) {
        connectQt(_wh, "backwardAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal forwardAvailable → ESlot
    QTextBrowser connect_forwardAvailable(ESlot eslot) {
        connectQt(_wh, "forwardAvailable(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal historyChanged → ESlot
    QTextBrowser connect_historyChanged(ESlot eslot) {
        connectQt(_wh, "historyChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal highlighted → ESlot (passes URL as string to invoke_s callback)
    QTextBrowser connect_highlighted(ESlot eslot) {
        connectQt(_wh, "highlighted(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── QUrl methods (manual) ─────────────────────────────────────────────

    /// Set document source URL. Triggers load + sourceChanged signal.
    QTextBrowser setSource(string url) {
        auto _ws = toQString(url);
        (cast(t_v__qp_qp)pFunQt[11202])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    /// Get current source URL as string.
    string source() {
        void* _qs = (cast(t_qp__qp)pFunQt[11203])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// URL of history entry i as string (negative=backward, positive=forward, 0=current).
    string historyUrl(int i) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[11208])(_wh, i);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// sourceChanged(QUrl) — lambda-connect.
    /// cb: extern(C) void function(void* dthis, int n, void* qs)
    ///   call fromQString(qs) then pFunQt[22](qs) to free.
    QTextBrowser connect_sourceChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[11219])(_wh, cb, dthis);
        return this;
    }

    /// anchorClicked(QUrl) — fires when user clicks a link.
    /// Same callback convention as connect_sourceChanged.
    QTextBrowser connect_anchorClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[11220])(_wh, cb, dthis);
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QTextBrowser setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[11250])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextBrowser onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextBrowser onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QTextBrowser onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTextBrowser onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTextBrowser onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QTextBrowser onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QTextBrowser onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QTextBrowser onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QTextBrowser onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextBrowser onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextBrowser onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextBrowser onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QTextBrowser onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QTextBrowser onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTextBrowser onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QTextBrowser onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QTextBrowser onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QTextBrowser
