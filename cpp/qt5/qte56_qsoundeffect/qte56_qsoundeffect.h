#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSOUNDEFFECT_BUILD
    #define QSOUNDEFFECT_API __declspec(dllexport)
  #else
    #define QSOUNDEFFECT_API __declspec(dllimport)
  #endif
#else
  #define QSOUNDEFFECT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSOUNDEFFECT_API void* qteQSoundEffect_create(void* parent);
QSOUNDEFFECT_API void  qteQSoundEffect_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSOUNDEFFECT_API void* qteQSoundEffect_source(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_setSource(void* _obj, void* url);
QSOUNDEFFECT_API void qteQSoundEffect_setSourceFromLocalFile(void* _obj, const char* path);
QSOUNDEFFECT_API int qteQSoundEffect_loopCount(void* _obj);
QSOUNDEFFECT_API int qteQSoundEffect_loopsRemaining(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_setLoopCount(void* _obj, int loopCount);
QSOUNDEFFECT_API double qteQSoundEffect_volume(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_setVolume(void* _obj, double volume);
QSOUNDEFFECT_API int qteQSoundEffect_isMuted(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_setMuted(void* _obj, int muted);
QSOUNDEFFECT_API int qteQSoundEffect_isLoaded(void* _obj);
QSOUNDEFFECT_API int qteQSoundEffect_isPlaying(void* _obj);
QSOUNDEFFECT_API int qteQSoundEffect_status(void* _obj);
QSOUNDEFFECT_API void* qteQSoundEffect_category(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_setCategory(void* _obj, const wchar_t* category, int category_len);
QSOUNDEFFECT_API void qteQSoundEffect_play(void* _obj);
QSOUNDEFFECT_API void qteQSoundEffect_stop(void* _obj);

} // extern "C"
