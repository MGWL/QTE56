/**
 * gen_qmediaplayer.d — GENERATED wrapper for QMediaPlayer.
 * Module: QMediaPlayer  |  DLL: qte56_qmediaplayer.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmediaplayer;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_i__qp_qp_i, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp_i, t_v__qp_qp_qp, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qobject : QObject;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("l__qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_l"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMediaPlayer() {
    mixin(generateFunQt(23000, "qteQMediaPlayer_create", "QMediaPlayer"));
    mixin(generateFunQt(23001, "qteQMediaPlayer_delete", "QMediaPlayer"));
    mixin(generateFunQt(23002, "qteQMediaPlayer_hasSupport", "QMediaPlayer"));
    mixin(generateFunQt(23041, "qteQMediaPlayer_setVideoOutput_vw", "QMediaPlayer"));
    mixin(generateFunQt(23042, "qteQMediaPlayer_setVideoOutput_gi", "QMediaPlayer"));
    mixin(generateFunQt(23003, "qteQMediaPlayer_setVideoOutput_vs", "QMediaPlayer"));
    mixin(generateFunQt(23004, "qteQMediaPlayer_media", "QMediaPlayer"));
    mixin(generateFunQt(23005, "qteQMediaPlayer_mediaStream", "QMediaPlayer"));
    mixin(generateFunQt(23006, "qteQMediaPlayer_playlist", "QMediaPlayer"));
    mixin(generateFunQt(23007, "qteQMediaPlayer_currentMedia", "QMediaPlayer"));
    mixin(generateFunQt(23008, "qteQMediaPlayer_state", "QMediaPlayer"));
    mixin(generateFunQt(23009, "qteQMediaPlayer_mediaStatus", "QMediaPlayer"));
    mixin(generateFunQt(23010, "qteQMediaPlayer_duration", "QMediaPlayer"));
    mixin(generateFunQt(23011, "qteQMediaPlayer_position", "QMediaPlayer"));
    mixin(generateFunQt(23012, "qteQMediaPlayer_volume", "QMediaPlayer"));
    mixin(generateFunQt(23013, "qteQMediaPlayer_isMuted", "QMediaPlayer"));
    mixin(generateFunQt(23014, "qteQMediaPlayer_isAudioAvailable", "QMediaPlayer"));
    mixin(generateFunQt(23015, "qteQMediaPlayer_isVideoAvailable", "QMediaPlayer"));
    mixin(generateFunQt(23016, "qteQMediaPlayer_bufferStatus", "QMediaPlayer"));
    mixin(generateFunQt(23017, "qteQMediaPlayer_isSeekable", "QMediaPlayer"));
    mixin(generateFunQt(23018, "qteQMediaPlayer_playbackRate", "QMediaPlayer"));
    mixin(generateFunQt(23019, "qteQMediaPlayer_error", "QMediaPlayer"));
    mixin(generateFunQt(23020, "qteQMediaPlayer_errorString", "QMediaPlayer"));
    mixin(generateFunQt(23021, "qteQMediaPlayer_currentNetworkConfiguration", "QMediaPlayer"));
    mixin(generateFunQt(23022, "qteQMediaPlayer_availability", "QMediaPlayer"));
    mixin(generateFunQt(23023, "qteQMediaPlayer_audioRole", "QMediaPlayer"));
    mixin(generateFunQt(23024, "qteQMediaPlayer_setAudioRole", "QMediaPlayer"));
    mixin(generateFunQt(23025, "qteQMediaPlayer_customAudioRole", "QMediaPlayer"));
    mixin(generateFunQt(23026, "qteQMediaPlayer_setCustomAudioRole", "QMediaPlayer"));
    mixin(generateFunQt(23027, "qteQMediaPlayer_play", "QMediaPlayer"));
    mixin(generateFunQt(23028, "qteQMediaPlayer_pause", "QMediaPlayer"));
    mixin(generateFunQt(23029, "qteQMediaPlayer_stop", "QMediaPlayer"));
    mixin(generateFunQt(23030, "qteQMediaPlayer_setPosition", "QMediaPlayer"));
    mixin(generateFunQt(23031, "qteQMediaPlayer_setVolume", "QMediaPlayer"));
    mixin(generateFunQt(23032, "qteQMediaPlayer_setMuted", "QMediaPlayer"));
    mixin(generateFunQt(23033, "qteQMediaPlayer_setPlaybackRate", "QMediaPlayer"));
    mixin(generateFunQt(23034, "qteQMediaPlayer_setMedia", "QMediaPlayer"));
    mixin(generateFunQt(23043, "qteQMediaPlayer_setMediaFromFile", "QMediaPlayer"));
    mixin(generateFunQt(23035, "qteQMediaPlayer_setPlaylist", "QMediaPlayer"));
    mixin(generateFunQt(23036, "qteQMediaPlayer_bind", "QMediaPlayer"));
    mixin(generateFunQt(23037, "qteQMediaPlayer_unbind", "QMediaPlayer"));
    mixin(generateFunQt(23038, "qteQMediaPlayer_connect_mediaChanged", "QMediaPlayer"));
    mixin(generateFunQt(23039, "qteQMediaPlayer_connect_currentMediaChanged", "QMediaPlayer"));
    mixin(generateFunQt(23040, "qteQMediaPlayer_connect_networkConfigurationChanged", "QMediaPlayer"));
}

static this() {
    registerModule("QMediaPlayer", "qte56_qmediaplayer.dll", &loadQMediaPlayer);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMediaPlayer.
class QMediaPlayer : QObject {
public:
    /// Create QMediaPlayer. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super();
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[23000])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this() {}

    /// hasSupport
    int hasSupport(string mimeType) {
        import std.utf : toUTF16;
        wstring _ws_mimeType = mimeType.toUTF16;
        return cast(int)(cast(t_i__qp_qp_i)pFunQt[23002])(_wh, cast(void*)_ws_mimeType.ptr, cast(int)_ws_mimeType.length);
    }

    /// setVideoOutput (QVideoWidget)
    QMediaPlayer setVideoOutput(void* p0) {
        (cast(t_v__qp_qp)pFunQt[23041])(_wh, p0);
        return this;
    }

    /// setVideoOutput (QGraphicsVideoItem)
    QMediaPlayer setVideoOutput_gi(void* p0) {
        (cast(t_v__qp_qp)pFunQt[23042])(_wh, p0);
        return this;
    }

    /// setVideoOutput (QAbstractVideoSurface)
    QMediaPlayer setVideoOutput_vs(void* surface) {
        (cast(t_v__qp_qp)pFunQt[23003])(_wh, surface);
        return this;
    }

    /// media
    void* media() {
        return cast(void*)(cast(t_qp__qp)pFunQt[23004])(_wh);
    }

    /// mediaStream
    void* mediaStream() {
        return cast(void*)(cast(t_qp__qp)pFunQt[23005])(_wh);
    }

    /// playlist
    void* playlist() {
        return cast(void*)(cast(t_qp__qp)pFunQt[23006])(_wh);
    }

    /// currentMedia
    void* currentMedia() {
        return cast(void*)(cast(t_qp__qp)pFunQt[23007])(_wh);
    }

    /// state
    int state() {
        return cast(int)(cast(t_i__qp)pFunQt[23008])(_wh);
    }

    /// mediaStatus
    int mediaStatus() {
        return cast(int)(cast(t_i__qp)pFunQt[23009])(_wh);
    }

    /// duration
    long duration() {
        return cast(long)(cast(t_l__qp)pFunQt[23010])(_wh);
    }

    /// position
    long position() {
        return cast(long)(cast(t_l__qp)pFunQt[23011])(_wh);
    }

    /// volume
    int volume() {
        return cast(int)(cast(t_i__qp)pFunQt[23012])(_wh);
    }

    /// isMuted
    bool isMuted() {
        return cast(bool)(cast(t_i__qp)pFunQt[23013])(_wh);
    }

    /// isAudioAvailable
    bool isAudioAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[23014])(_wh);
    }

    /// isVideoAvailable
    bool isVideoAvailable() {
        return cast(bool)(cast(t_i__qp)pFunQt[23015])(_wh);
    }

    /// bufferStatus
    int bufferStatus() {
        return cast(int)(cast(t_i__qp)pFunQt[23016])(_wh);
    }

    /// isSeekable
    bool isSeekable() {
        return cast(bool)(cast(t_i__qp)pFunQt[23017])(_wh);
    }

    /// playbackRate
    double playbackRate() {
        return cast(double)(cast(t_d__qp)pFunQt[23018])(_wh);
    }

    /// error
    int error() {
        return cast(int)(cast(t_i__qp)pFunQt[23019])(_wh);
    }

    /// errorString
    string errorString() {
        void* _qs = (cast(t_qp__qp)pFunQt[23020])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// currentNetworkConfiguration
    void* currentNetworkConfiguration() {
        return cast(void*)(cast(t_qp__qp)pFunQt[23021])(_wh);
    }

    /// availability
    int availability() {
        return cast(int)(cast(t_i__qp)pFunQt[23022])(_wh);
    }

    /// audioRole
    int audioRole() {
        return cast(int)(cast(t_i__qp)pFunQt[23023])(_wh);
    }

    /// setAudioRole
    QMediaPlayer setAudioRole(int audioRole) {
        (cast(t_v__qp_i)pFunQt[23024])(_wh, audioRole);
        return this;
    }

    /// customAudioRole
    string customAudioRole() {
        void* _qs = (cast(t_qp__qp)pFunQt[23025])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setCustomAudioRole
    QMediaPlayer setCustomAudioRole(string audioRole) {
        import std.utf : toUTF16;
        wstring _ws_audioRole = audioRole.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[23026])(_wh, cast(void*)_ws_audioRole.ptr, cast(int)_ws_audioRole.length);
        return this;
    }

    /// play
    QMediaPlayer play() {
        (cast(t_v__qp)pFunQt[23027])(_wh);
        return this;
    }

    /// pause
    QMediaPlayer pause() {
        (cast(t_v__qp)pFunQt[23028])(_wh);
        return this;
    }

    /// stop
    QMediaPlayer stop() {
        (cast(t_v__qp)pFunQt[23029])(_wh);
        return this;
    }

    /// setPosition
    QMediaPlayer setPosition(long position) {
        (cast(t_v__qp_l)pFunQt[23030])(_wh, position);
        return this;
    }

    /// setVolume
    QMediaPlayer setVolume(int volume) {
        (cast(t_v__qp_i)pFunQt[23031])(_wh, volume);
        return this;
    }

    /// setMuted
    QMediaPlayer setMuted(bool muted) {
        (cast(t_v__qp_i)pFunQt[23032])(_wh, muted ? 1 : 0);
        return this;
    }

    /// setPlaybackRate
    QMediaPlayer setPlaybackRate(double rate) {
        (cast(t_v__qp_d)pFunQt[23033])(_wh, rate);
        return this;
    }

    /// setMedia
    QMediaPlayer setMedia(void* media, void* stream) {
        (cast(t_v__qp_qp_qp)pFunQt[23034])(_wh, media, stream);
        return this;
    }

    /// setMediaFromFile — удобный метод для загрузки файла по пути
    QMediaPlayer setMediaFromFile(string filename) {
        import std.utf : toUTF16;
        wstring _ws_filename = filename.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[23043])(_wh, cast(void*)_ws_filename.ptr, cast(int)_ws_filename.length);
        return this;
    }

    /// setPlaylist
    QMediaPlayer setPlaylist(void* playlist) {
        (cast(t_v__qp_qp)pFunQt[23035])(_wh, playlist);
        return this;
    }

    /// bind
    bool bind(void* p0) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[23036])(_wh, p0);
    }

    /// unbind
    QMediaPlayer unbind(void* p0) {
        (cast(t_v__qp_qp)pFunQt[23037])(_wh, p0);
        return this;
    }

    /// Connect signal mediaChanged → прямой callback (DSlot_ptr)
    /// cb: extern(C) void function(void* dthis, int n, void* ptr)
    QMediaPlayer connect_mediaChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[23038])(_wh, cb, dthis);
        return this;
    }

    /// Connect signal currentMediaChanged → прямой callback (DSlot_ptr)
    /// cb: extern(C) void function(void* dthis, int n, void* ptr)
    QMediaPlayer connect_currentMediaChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[23039])(_wh, cb, dthis);
        return this;
    }

    // Signal stateChanged — unsupported parameter types
    // Signal mediaStatusChanged — unsupported parameter types
    // Signal durationChanged — unsupported parameter types
    // Signal positionChanged — unsupported parameter types
    /// Connect signal volumeChanged → ESlot
    QMediaPlayer connect_volumeChanged(ESlot eslot) {
        connectQt(_wh, "volumeChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal mutedChanged → ESlot
    QMediaPlayer connect_mutedChanged(ESlot eslot) {
        connectQt(_wh, "mutedChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal audioAvailableChanged → ESlot
    QMediaPlayer connect_audioAvailableChanged(ESlot eslot) {
        connectQt(_wh, "audioAvailableChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal videoAvailableChanged → ESlot
    QMediaPlayer connect_videoAvailableChanged(ESlot eslot) {
        connectQt(_wh, "videoAvailableChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// Connect signal bufferStatusChanged → ESlot
    QMediaPlayer connect_bufferStatusChanged(ESlot eslot) {
        connectQt(_wh, "bufferStatusChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal seekableChanged → ESlot
    QMediaPlayer connect_seekableChanged(ESlot eslot) {
        connectQt(_wh, "seekableChanged(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    // Signal playbackRateChanged — unsupported parameter types
    // Signal audioRoleChanged — unsupported parameter types
    /// Connect signal customAudioRoleChanged → ESlot
    QMediaPlayer connect_customAudioRoleChanged(ESlot eslot) {
        connectQt(_wh, "customAudioRoleChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // Signal error — unsupported parameter types
    /// Connect signal networkConfigurationChanged → прямой callback (DSlot_ptr)
    /// cb: extern(C) void function(void* dthis, int n, void* ptr)
    QMediaPlayer connect_networkConfigurationChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[23040])(_wh, cb, dthis);
        return this;
    }

} // class QMediaPlayer
