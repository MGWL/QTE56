/**
 * gen_qsystemtrayicon.d — wrapper for QSystemTrayIcon.
 * DLL: qte56_systray.dll  |  Index block: 19797–19809
 *
 * QSystemTrayIcon provides an icon in the system notification area.
 * Requires a running QApplication. Icon is optional (set via setIcon).
 *
 * Signal callbacks use plain extern(C) function pointers:
 *   connect_activated:     extern(C) void function(int reason)
 *   connect_messageClicked: extern(C) void function()
 */
module gen_qsystemtrayicon;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_i, toQString;

// showMessage (old): void function(void*, void*, int, void*, int, int, int)
mixin(generateAlias("v__qp_qp_i_qp_i_i_i"));
// showMessage (new simplified): void function(void*, void*, void*, int, int)
mixin(generateAlias("v__qp_qp_qp_i_i"));
// supportsMessages: int function() — static call, no pointer
mixin(generateAlias("i__"));

// ── Load ──────────────────────────────────────────────────────────────────────

void loadQSystemTrayIcon() {
    mixin(generateFunQt(19797, "qteQSystemTrayIcon_create",               "QSystemTrayIcon"));
    mixin(generateFunQt(19798, "qteQSystemTrayIcon_delete",               "QSystemTrayIcon"));
    mixin(generateFunQt(19799, "qteQSystemTrayIcon_setIcon",              "QSystemTrayIcon"));
    mixin(generateFunQt(19800, "qteQSystemTrayIcon_setToolTip",           "QSystemTrayIcon"));
    mixin(generateFunQt(19801, "qteQSystemTrayIcon_show",                 "QSystemTrayIcon"));
    mixin(generateFunQt(19802, "qteQSystemTrayIcon_hide",                 "QSystemTrayIcon"));
    mixin(generateFunQt(19803, "qteQSystemTrayIcon_isVisible",            "QSystemTrayIcon"));
    mixin(generateFunQt(19804, "qteQSystemTrayIcon_showMessage",          "QSystemTrayIcon"));
    mixin(generateFunQt(19805, "qteQSystemTrayIcon_setContextMenu",       "QSystemTrayIcon"));
    mixin(generateFunQt(19806, "qteQSystemTrayIcon_connect_activated",    "QSystemTrayIcon"));
    mixin(generateFunQt(19807, "qteQSystemTrayIcon_connect_messageClicked","QSystemTrayIcon"));
    mixin(generateFunQt(19808, "qteQSystemTrayIcon_geometry",             "QSystemTrayIcon"));
    mixin(generateFunQt(19809, "qteQSystemTrayIcon_supportsMessages",     "QSystemTrayIcon"));
}

static this() {
    registerModule("QSystemTrayIcon", "qte56_systray.dll", &loadQSystemTrayIcon);
}

// ── QSystemTrayIcon class ─────────────────────────────────────────────────────

@live class QSystemTrayIcon {
private:
    void* _wh;

public:
    this() {
        _wh = (cast(t_qp__)pFunQt[19797])();
    }

    ~this() {
        if (_wh !is null && pFunQt[19798] !is null) {
            (cast(t_v__qp)pFunQt[19798])(_wh);
            _wh = null;
        }
    }

    /// Set icon (pass QIcon.getWH()).
    QSystemTrayIcon setIcon(void* iconPtr) {
        (cast(t_v__qp_qp)pFunQt[19799])(_wh, iconPtr);
        return this;
    }

    /// Set tooltip text shown on hover.
    QSystemTrayIcon setToolTip(string tip) {
        auto ws = toQString(tip);
        (cast(t_v__qp_qp)pFunQt[19800])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    QSystemTrayIcon show() { (cast(t_v__qp)pFunQt[19801])(_wh); return this; }
    QSystemTrayIcon hide() { (cast(t_v__qp)pFunQt[19802])(_wh); return this; }

    int isVisible() {
        return cast(int)(cast(t_i__qp)pFunQt[19803])(_wh);
    }

    /// Show a balloon message.
    /// icon: TrayMessageIcon enum value (0=NoIcon,1=Info,2=Warning,3=Critical)
    /// msec: duration in milliseconds (0 = platform default)
    QSystemTrayIcon showMessage(string title, string msg, int icon = 1, int msec = 5000) {
        auto wt = toQString(title);
        auto wm = toQString(msg);
        (cast(t_v__qp_qp_qp_i_i)pFunQt[19804])(
            _wh,
            wt,
            wm,
            icon, msec);
        return this;
    }

    /// Set right-click context menu (pass QMenu.getWH()).
    QSystemTrayIcon setContextMenu(void* menuPtr) {
        (cast(t_v__qp_qp)pFunQt[19805])(_wh, menuPtr);
        return this;
    }

    /// Connect activated signal. cb: extern(C) void function(int reason)
    QSystemTrayIcon connect_activated(void* cb) {
        (cast(t_v__qp_qp)pFunQt[19806])(_wh, cb);
        return this;
    }

    /// Connect messageClicked signal. cb: extern(C) void function()
    QSystemTrayIcon connect_messageClicked(void* cb) {
        (cast(t_v__qp_qp)pFunQt[19807])(_wh, cb);
        return this;
    }

    /// Get icon geometry on screen. All output params receive pixel values.
    QSystemTrayIcon geometry(out int x, out int y, out int w, out int h) {
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[19808])(_wh, &x, &y, &w, &h);
        return this;
    }

    /// Static: returns non-zero if the platform supports balloon messages.
    static int supportsMessages() {
        return cast(int)(cast(t_i__)pFunQt[19809])();
    }

    void* getWH() { return _wh; }
}
