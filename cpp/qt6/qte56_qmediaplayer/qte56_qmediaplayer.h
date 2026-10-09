#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMEDIAPLAYER_BUILD
    #define QMEDIAPLAYER_API __declspec(dllexport)
  #else
    #define QMEDIAPLAYER_API __declspec(dllimport)
  #endif
#else
  #define QMEDIAPLAYER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMEDIAPLAYER_API void* qteQMediaPlayer_create(void* parent);
QMEDIAPLAYER_API void  qteQMediaPlayer_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QMEDIAPLAYER_API int qteQMediaPlayer_hasSupport(void* _obj, const wchar_t* mimeType, int mimeType_len);
QMEDIAPLAYER_API void qteQMediaPlayer_setVideoOutput_vw(void* _obj, void* p0);
QMEDIAPLAYER_API void qteQMediaPlayer_setVideoOutput_gi(void* _obj, void* p0);
QMEDIAPLAYER_API void qteQMediaPlayer_setVideoOutput_vs(void* _obj, void* surface);
QMEDIAPLAYER_API void* qteQMediaPlayer_media(void* _obj);
QMEDIAPLAYER_API void* qteQMediaPlayer_mediaStream(void* _obj);
QMEDIAPLAYER_API void* qteQMediaPlayer_playlist(void* _obj);
QMEDIAPLAYER_API void* qteQMediaPlayer_currentMedia(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_state(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_mediaStatus(void* _obj);
QMEDIAPLAYER_API long long qteQMediaPlayer_duration(void* _obj);
QMEDIAPLAYER_API long long qteQMediaPlayer_position(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_volume(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_isMuted(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_isAudioAvailable(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_isVideoAvailable(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_bufferStatus(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_isSeekable(void* _obj);
QMEDIAPLAYER_API double qteQMediaPlayer_playbackRate(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_error(void* _obj);
QMEDIAPLAYER_API void* qteQMediaPlayer_errorString(void* _obj);
QMEDIAPLAYER_API void* qteQMediaPlayer_currentNetworkConfiguration(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_availability(void* _obj);
QMEDIAPLAYER_API int qteQMediaPlayer_audioRole(void* _obj);
QMEDIAPLAYER_API void qteQMediaPlayer_setAudioRole(void* _obj, int audioRole);
QMEDIAPLAYER_API void* qteQMediaPlayer_customAudioRole(void* _obj);
QMEDIAPLAYER_API void qteQMediaPlayer_setCustomAudioRole(void* _obj, const wchar_t* audioRole, int audioRole_len);
QMEDIAPLAYER_API void qteQMediaPlayer_play(void* _obj);
QMEDIAPLAYER_API void qteQMediaPlayer_pause(void* _obj);
QMEDIAPLAYER_API void qteQMediaPlayer_stop(void* _obj);
QMEDIAPLAYER_API void qteQMediaPlayer_setPosition(void* _obj, long long position);
QMEDIAPLAYER_API void qteQMediaPlayer_setVolume(void* _obj, int volume);
QMEDIAPLAYER_API void qteQMediaPlayer_setMuted(void* _obj, int muted);
QMEDIAPLAYER_API void qteQMediaPlayer_setPlaybackRate(void* _obj, double rate);
QMEDIAPLAYER_API void qteQMediaPlayer_setMedia(void* _obj, void* media, void* stream);
QMEDIAPLAYER_API void qteQMediaPlayer_setMediaFromFile(void* _obj, const wchar_t* filename, int filename_len);
QMEDIAPLAYER_API void qteQMediaPlayer_setPlaylist(void* _obj, void* playlist);
QMEDIAPLAYER_API int qteQMediaPlayer_bind(void* _obj, void* p0);
QMEDIAPLAYER_API void qteQMediaPlayer_unbind(void* _obj, void* p0);

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QMEDIAPLAYER_API void qteQMediaPlayer_connect_mediaChanged(void* w, void* cb, void* dthis);
QMEDIAPLAYER_API void qteQMediaPlayer_connect_currentMediaChanged(void* w, void* cb, void* dthis);
QMEDIAPLAYER_API void qteQMediaPlayer_connect_networkConfigurationChanged(void* w, void* cb, void* dthis);

} // extern "C"
