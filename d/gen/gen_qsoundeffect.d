/**
 * gen_qsoundeffect.d — GENERATED wrapper for QSoundEffect.
 * Module: QSoundEffect  |  DLL: qte56_qsoundeffect.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qsoundeffect;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp_i, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qobject : QObject;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_cp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQSoundEffect() {
    mixin(generateFunQt(22000, "qteQSoundEffect_create", "QSoundEffect"));
    mixin(generateFunQt(22001, "qteQSoundEffect_delete", "QSoundEffect"));
    mixin(generateFunQt(22002, "qteQSoundEffect_source", "QSoundEffect"));
    mixin(generateFunQt(22003, "qteQSoundEffect_setSource", "QSoundEffect"));
    mixin(generateFunQt(22018, "qteQSoundEffect_setSourceFromLocalFile", "QSoundEffect"));
    mixin(generateFunQt(22004, "qteQSoundEffect_loopCount", "QSoundEffect"));
    mixin(generateFunQt(22005, "qteQSoundEffect_loopsRemaining", "QSoundEffect"));
    mixin(generateFunQt(22006, "qteQSoundEffect_setLoopCount", "QSoundEffect"));
    mixin(generateFunQt(22007, "qteQSoundEffect_volume", "QSoundEffect"));
    mixin(generateFunQt(22008, "qteQSoundEffect_setVolume", "QSoundEffect"));
    mixin(generateFunQt(22009, "qteQSoundEffect_isMuted", "QSoundEffect"));
    mixin(generateFunQt(22010, "qteQSoundEffect_setMuted", "QSoundEffect"));
    mixin(generateFunQt(22011, "qteQSoundEffect_isLoaded", "QSoundEffect"));
    mixin(generateFunQt(22012, "qteQSoundEffect_isPlaying", "QSoundEffect"));
    mixin(generateFunQt(22013, "qteQSoundEffect_status", "QSoundEffect"));
    mixin(generateFunQt(22014, "qteQSoundEffect_category", "QSoundEffect"));
    mixin(generateFunQt(22015, "qteQSoundEffect_setCategory", "QSoundEffect"));
    mixin(generateFunQt(22016, "qteQSoundEffect_play", "QSoundEffect"));
    mixin(generateFunQt(22017, "qteQSoundEffect_stop", "QSoundEffect"));
}

static this() {
    registerModule("QSoundEffect", "qte56_qsoundeffect.dll", &loadQSoundEffect);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QSoundEffect.
class QSoundEffect : QObject {
public:
    /// Create QSoundEffect. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super();
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[22000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this() {}

    /// source
    void* source() {
        return cast(void*)(cast(t_qp__qp)pFunQt[22002])(_wh);
    }

    /// setSource
    QSoundEffect setSource(void* url) {
        (cast(t_v__qp_qp)pFunQt[22003])(_wh, url);
        return this;
    }

    /// setSourceFromLocalFile — установить источник звука из локального файла
    QSoundEffect setSourceFromLocalFile(string path) {
        import std.string : toStringz;
        (cast(t_v__qp_cp)pFunQt[22018])(_wh, path.toStringz);
        return this;
    }

    /// loopCount
    int loopCount() {
        return cast(int)(cast(t_i__qp)pFunQt[22004])(_wh);
    }

    /// loopsRemaining
    int loopsRemaining() {
        return cast(int)(cast(t_i__qp)pFunQt[22005])(_wh);
    }

    /// setLoopCount
    QSoundEffect setLoopCount(int loopCount) {
        (cast(t_v__qp_i)pFunQt[22006])(_wh, loopCount);
        return this;
    }

    /// volume
    double volume() {
        return cast(double)(cast(t_d__qp)pFunQt[22007])(_wh);
    }

    /// setVolume
    QSoundEffect setVolume(double volume) {
        (cast(t_v__qp_d)pFunQt[22008])(_wh, volume);
        return this;
    }

    /// isMuted
    bool isMuted() {
        return cast(bool)(cast(t_i__qp)pFunQt[22009])(_wh);
    }

    /// setMuted
    QSoundEffect setMuted(bool muted) {
        (cast(t_v__qp_i)pFunQt[22010])(_wh, muted ? 1 : 0);
        return this;
    }

    /// isLoaded
    bool isLoaded() {
        return cast(bool)(cast(t_i__qp)pFunQt[22011])(_wh);
    }

    /// isPlaying
    bool isPlaying() {
        return cast(bool)(cast(t_i__qp)pFunQt[22012])(_wh);
    }

    /// status
    int status() {
        return cast(int)(cast(t_i__qp)pFunQt[22013])(_wh);
    }

    /// category
    string category() {
        void* _qs = (cast(t_qp__qp)pFunQt[22014])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setCategory
    QSoundEffect setCategory(string category) {
        import std.utf : toUTF16;
        wstring _ws_category = category.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[22015])(_wh, cast(void*)_ws_category.ptr, cast(int)_ws_category.length);
        return this;
    }

    /// play
    QSoundEffect play() {
        (cast(t_v__qp)pFunQt[22016])(_wh);
        return this;
    }

    /// stop
    QSoundEffect stop() {
        (cast(t_v__qp)pFunQt[22017])(_wh);
        return this;
    }

    /// Connect signal sourceChanged → ESlot
    QSoundEffect connect_sourceChanged(ESlot eslot) {
        connectQt(_wh, "sourceChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal loopCountChanged → ESlot
    QSoundEffect connect_loopCountChanged(ESlot eslot) {
        connectQt(_wh, "loopCountChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal loopsRemainingChanged → ESlot
    QSoundEffect connect_loopsRemainingChanged(ESlot eslot) {
        connectQt(_wh, "loopsRemainingChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal volumeChanged → ESlot
    QSoundEffect connect_volumeChanged(ESlot eslot) {
        connectQt(_wh, "volumeChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal mutedChanged → ESlot
    QSoundEffect connect_mutedChanged(ESlot eslot) {
        connectQt(_wh, "mutedChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal loadedChanged → ESlot
    QSoundEffect connect_loadedChanged(ESlot eslot) {
        connectQt(_wh, "loadedChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal playingChanged → ESlot
    QSoundEffect connect_playingChanged(ESlot eslot) {
        connectQt(_wh, "playingChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal statusChanged → ESlot
    QSoundEffect connect_statusChanged(ESlot eslot) {
        connectQt(_wh, "statusChanged()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal categoryChanged → ESlot
    QSoundEffect connect_categoryChanged(ESlot eslot) {
        connectQt(_wh, "categoryChanged()", eslot, "invoke_v()");
        return this;
    }

} // class QSoundEffect
