/**
 * gen_qdialog.d — D wrapper for QDialog.
 * Module: QDialog  |  DLL: qte56_dialogs.dll
 *
 * Index block: 29000–29012
 *
 * QDialog::exec() return values:
 *   Accepted = 1   (accept() was called)
 *   Rejected = 0   (reject() / X button)
 *
 * Signals:
 *   accepted()  → cb: extern(C) void function(void* dthis, int n)
 *   rejected()  → cb: extern(C) void function(void* dthis, int n)
 *
 * Usage:
 *   auto dlg = new QDialog(win.getWH());
 *   dlg.setWindowTitle("Settings");
 *   dlg.resize(300, 200);
 *   // add child widgets + layout...
 *   int r = dlg.exec();   // blocks until accept()/reject()
 *   if (r == QDialog.Accepted) { ... }
 */
module gen_qdialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip;
import gen_qwidget : QWidget;

// create(parent, flags) → void* func(void*, int)
mixin(generateAlias("qp__qp_i"));

// ====================================================================
// Load function addresses
// ====================================================================

static this() { registerModule("QDialog", "qte56_dialogs.dll", &loadQDialog); }

void loadQDialog() {
    mixin(generateFunQt(4600, "qteQDialog_create",             "QDialog"));
    mixin(generateFunQt(4601, "qteQDialog_delete",             "QDialog"));
    mixin(generateFunQt(4602, "qteQDialog_exec",               "QDialog"));
    mixin(generateFunQt(4603, "qteQDialog_accept",             "QDialog"));
    mixin(generateFunQt(4604, "qteQDialog_reject",             "QDialog"));
    mixin(generateFunQt(4605, "qteQDialog_done",               "QDialog"));
    mixin(generateFunQt(4606, "qteQDialog_result",             "QDialog"));
    mixin(generateFunQt(4607, "qteQDialog_setModal",           "QDialog"));
    mixin(generateFunQt(4608, "qteQDialog_isModal",            "QDialog"));
    mixin(generateFunQt(4609, "qteQDialog_open",               "QDialog"));
    mixin(generateFunQt(4610, "qteQDialog_setSizeGripEnabled", "QDialog"));
    mixin(generateFunQt(4611, "qteQDialog_isSizeGripEnabled",  "QDialog"));
    mixin(generateFunQt(4612, "qteQDialog_setEventHandler",    "QDialog"));
}

// ====================================================================
// Class
// ====================================================================

/// D wrapper for QDialog.
@live class QDialog : QWidget {
public:
    /// exec() return values
    enum Accepted = 1;
    enum Rejected = 0;

    /// Create QDialog. parent — owning widget; flags — Qt::WindowFlags (0 = default).
    this(void* parent, int flags = 0) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp_i)pFunQt[4600])(parent, flags);
    }

    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QDialog*.
    static QDialog wrap(void* wh) {
        auto d = new QDialog(true);
        d._wh = wh;
        d._qt_owned = true;
        return d;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[4601] !is null) {
            (cast(t_v__qp)pFunQt[4601])(_wh);
            _wh = null;
        }
    }

    // ── Modal execution ───────────────────────────────────────────────

    /// Show dialog as application-modal. Blocks until accept() or reject().
    /// Returns Accepted (1) or Rejected (0).
    int exec() {
        return (cast(t_i__qp)pFunQt[4602])(_wh);
    }

    /// Close dialog with Accepted result. Emits accepted() signal.
    QDialog accept() {
        (cast(t_v__qp)pFunQt[4603])(_wh);
        return this;
    }

    /// Close dialog with Rejected result. Emits rejected() signal.
    QDialog reject() {
        (cast(t_v__qp)pFunQt[4604])(_wh);
        return this;
    }

    /// Close dialog with given result code. Emits finished(result).
    QDialog done(int result) {
        (cast(t_v__qp_i)pFunQt[4605])(_wh, result);
        return this;
    }

    /// Returns the result code set by done() / accept() / reject().
    int getResult() {
        return (cast(t_i__qp)pFunQt[4606])(_wh);
    }

    // ── Modal mode ────────────────────────────────────────────────────

    /// Set window modality. true = application-modal (blocks all windows).
    QDialog setModal(bool modal) {
        (cast(t_v__qp_i)pFunQt[4607])(_wh, modal ? 1 : 0);
        return this;
    }

    override bool isModal() {
        return cast(bool)(cast(t_i__qp)pFunQt[4608])(_wh);
    }

    /// Show dialog without blocking (non-modal / window-modal).
    QDialog open() {
        (cast(t_v__qp)pFunQt[4609])(_wh);
        return this;
    }

    // ── Grip ──────────────────────────────────────────────────────────

    QDialog setSizeGripEnabled(bool enabled) {
        (cast(t_v__qp_i)pFunQt[4610])(_wh, enabled ? 1 : 0);
        return this;
    }

    bool isSizeGripEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[4611])(_wh);
    }

    // ── Signals ───────────────────────────────────────────────────────

    /// Emitted when accept() is called.
    /// cb: extern(C) void function(void* dthis, int n)
    QDialog connect_accepted(ESlot eslot) {
        connectQt(_wh, "accepted()", eslot, "invoke_v()");
        return this;
    }

    /// Emitted when reject() is called or X button pressed.
    /// cb: extern(C) void function(void* dthis, int n)
    QDialog connect_rejected(ESlot eslot) {
        connectQt(_wh, "rejected()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ────────────────────────────────────────────────

    override QDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[4612])(_wh, eventId, cb, dthis);
        return this;
    }
    override QDialog onMousePress(void* cb, void* dthis = null)       { setEventHandler(1,  cb, dthis); return this; }
    override QDialog onMouseRelease(void* cb, void* dthis = null)     { setEventHandler(2,  cb, dthis); return this; }
    override QDialog onMouseDoubleClick(void* cb, void* dthis = null) { setEventHandler(3,  cb, dthis); return this; }
    override QDialog onMouseMove(void* cb, void* dthis = null)        { setEventHandler(4,  cb, dthis); return this; }
    override QDialog onKeyPress(void* cb, void* dthis = null)         { setEventHandler(5,  cb, dthis); return this; }
    override QDialog onKeyRelease(void* cb, void* dthis = null)       { setEventHandler(6,  cb, dthis); return this; }
    override QDialog onResize(void* cb, void* dthis = null)           { setEventHandler(7,  cb, dthis); return this; }
    override QDialog onMove(void* cb, void* dthis = null)             { setEventHandler(8,  cb, dthis); return this; }
    override QDialog onClose(void* cb, void* dthis = null)            { setEventHandler(9,  cb, dthis); return this; }
    override QDialog onShow(void* cb, void* dthis = null)             { setEventHandler(10, cb, dthis); return this; }
    override QDialog onHide(void* cb, void* dthis = null)             { setEventHandler(11, cb, dthis); return this; }
    override QDialog onEnter(void* cb, void* dthis = null)            { setEventHandler(12, cb, dthis); return this; }
    override QDialog onLeave(void* cb, void* dthis = null)            { setEventHandler(13, cb, dthis); return this; }
    override QDialog onWheel(void* cb, void* dthis = null)            { setEventHandler(14, cb, dthis); return this; }
    override QDialog onFocusIn(void* cb, void* dthis = null)          { setEventHandler(15, cb, dthis); return this; }
    override QDialog onFocusOut(void* cb, void* dthis = null)         { setEventHandler(16, cb, dthis); return this; }
    override QDialog onContextMenu(void* cb, void* dthis = null)      { setEventHandler(17, cb, dthis); return this; }

} // class QDialog
