/**
 * gen_qsound.d — GENERATED wrapper for QSound.
 * Module: QSound  |  DLL: qte56_qsound.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qsound;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp_i, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qobject : QObject;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSound() {
    mixin(generateFunQt(21000, "qteQSound_create", "QSound"));
    mixin(generateFunQt(21001, "qteQSound_delete", "QSound"));
    mixin(generateFunQt(21002, "qteQSound_create_text", "QSound"));
    mixin(generateFunQt(21003, "qteQSound_play_s", "QSound"));
    mixin(generateFunQt(21004, "qteQSound_loops", "QSound"));
    mixin(generateFunQt(21005, "qteQSound_loopsRemaining", "QSound"));
    mixin(generateFunQt(21006, "qteQSound_setLoops", "QSound"));
    mixin(generateFunQt(21007, "qteQSound_fileName", "QSound"));
    mixin(generateFunQt(21008, "qteQSound_isFinished", "QSound"));
    mixin(generateFunQt(21009, "qteQSound_play_v", "QSound"));
    mixin(generateFunQt(21010, "qteQSound_stop", "QSound"));
}

static this() {
    registerModule("QSound", "qte56_qsound.dll", &loadQSound);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSound.
class QSound : QObject {
public:
    /// Create QSound. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super();
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[21000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this() {}

    /// Create QSound with initial text.
    this(string text, void* parent) {
        super();
        import std.utf : toUTF16;
        _qt_owned = (parent !is null);
        wstring _ws = text.toUTF16;
        _wh = (cast(t_qp__qp_i_qp)pFunQt[21002])(
            cast(void*)_ws.ptr, cast(int)_ws.length, parent);
    }

    /// play (instance method)
    QSound play(string filename) {
        import std.utf : toUTF16;
        wstring _ws_filename = filename.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[21003])(_wh, cast(void*)_ws_filename.ptr, cast(int)_ws_filename.length);
        return this;
    }

    /// play (static method) — plays sound file, blocks until finished
    static void playStatic(string filename) {
        auto tmp = new QSound(filename, null);
        tmp.play();
        // Wait until finished playing
        import core.thread;
        while (!tmp.isFinished()) {
            Thread.sleep(50.msecs);
        }
    }

    /// loops
    int loops() {
        return cast(int)(cast(t_i__qp)pFunQt[21004])(_wh);
    }

    /// loopsRemaining
    int loopsRemaining() {
        return cast(int)(cast(t_i__qp)pFunQt[21005])(_wh);
    }

    /// setLoops
    QSound setLoops(int p0) {
        (cast(t_v__qp_i)pFunQt[21006])(_wh, p0);
        return this;
    }

    /// fileName
    string fileName() {
        void* _qs = (cast(t_qp__qp)pFunQt[21007])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// isFinished
    bool isFinished() {
        return cast(bool)(cast(t_i__qp)pFunQt[21008])(_wh);
    }

    /// play
    QSound play() {
        (cast(t_v__qp)pFunQt[21009])(_wh);
        return this;
    }

    /// stop
    QSound stop() {
        (cast(t_v__qp)pFunQt[21010])(_wh);
        return this;
    }

} // class QSound
