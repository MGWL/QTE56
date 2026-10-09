/**
 * gen_qsplashscreen.d — wrapper for QSplashScreen.
 * DLL: qte56_systray.dll  |  Index block: 19788–19796
 *
 * QSplashScreen is a top-level window displayed during application startup.
 * Call finish(mainWindow.getWH()) when the main window is ready to close it.
 */
module gen_qsplashscreen;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_qp, t_v__qp_qp_i, toQString;

// showMessage(ss, wchar*, len, alignment, rgba) → void function(void*, void*, int, int, uint)
mixin(generateAlias("v__qp_qp_i_ui"));

// ── Load ──────────────────────────────────────────────────────────────────────

void loadQSplashScreen() {
    mixin(generateFunQt(19788, "qteQSplashScreen_create",       "QSplashScreen"));
    mixin(generateFunQt(19789, "qteQSplashScreen_delete",       "QSplashScreen"));
    mixin(generateFunQt(19790, "qteQSplashScreen_show",         "QSplashScreen"));
    mixin(generateFunQt(19791, "qteQSplashScreen_close",        "QSplashScreen"));
    mixin(generateFunQt(19792, "qteQSplashScreen_showMessage",  "QSplashScreen"));
    mixin(generateFunQt(19793, "qteQSplashScreen_clearMessage", "QSplashScreen"));
    mixin(generateFunQt(19794, "qteQSplashScreen_finish",       "QSplashScreen"));
    mixin(generateFunQt(19795, "qteQSplashScreen_repaint",      "QSplashScreen"));
    mixin(generateFunQt(19796, "qteQSplashScreen_setPixmap",    "QSplashScreen"));
}

static this() { registerModule("QSplashScreen", "qte56_systray.dll", &loadQSplashScreen); }

// ── QSplashScreen class ───────────────────────────────────────────────────────

@live class QSplashScreen {
private:
    void* _wh;

public:
    /// Create a splash screen with the given QPixmap pointer.
    this(void* pixmapPtr) {
        _wh = (cast(t_qp__qp)pFunQt[19788])(pixmapPtr);
    }

    ~this() {
        if (_wh !is null && pFunQt[19789] !is null) {
            (cast(t_v__qp)pFunQt[19789])(_wh);
            _wh = null;
        }
    }

    QSplashScreen show()  { (cast(t_v__qp)pFunQt[19790])(_wh); return this; }
    QSplashScreen close() { (cast(t_v__qp)pFunQt[19791])(_wh); return this; }

    /// Show a message on the splash screen.
    /// alignment: Qt::Alignment flags (e.g. 0x44 = AlignHCenter|AlignBottom)
    /// color: 0xAARRGGBB (e.g. 0xFFFFFFFF = opaque white)
    QSplashScreen showMessage(string msg, int alignment = 0x44, uint color = 0xFFFFFFFF) {
        auto ws = toQString(msg);
        (cast(t_v__qp_qp_i_ui)pFunQt[19792])(_wh, ws, alignment, color);
        return this;
    }

    QSplashScreen clearMessage() { (cast(t_v__qp)pFunQt[19793])(_wh); return this; }

    /// Call when the main window is shown to close the splash.
    QSplashScreen finish(void* mainWindow) {
        (cast(t_v__qp_qp)pFunQt[19794])(_wh, mainWindow);
        return this;
    }

    QSplashScreen repaint() { (cast(t_v__qp)pFunQt[19795])(_wh); return this; }

    QSplashScreen setPixmap(void* pixmapPtr) {
        (cast(t_v__qp_qp)pFunQt[19796])(_wh, pixmapPtr);
        return this;
    }

    void* getWH() { return _wh; }
}
