#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSOUND_BUILD
    #define QSOUND_API __declspec(dllexport)
  #else
    #define QSOUND_API __declspec(dllimport)
  #endif
#else
  #define QSOUND_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSOUND_API void* qteQSound_create(void* parent);
QSOUND_API void  qteQSound_delete(void* w);
QSOUND_API void* qteQSound_create_text(const wchar_t* text, int len, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QSOUND_API void qteQSound_play_s(void* _obj, const wchar_t* filename, int filename_len);
QSOUND_API int qteQSound_loops(void* _obj);
QSOUND_API int qteQSound_loopsRemaining(void* _obj);
QSOUND_API void qteQSound_setLoops(void* _obj, int p0);
QSOUND_API void* qteQSound_fileName(void* _obj);
QSOUND_API int qteQSound_isFinished(void* _obj);
QSOUND_API void qteQSound_play_v(void* _obj);
QSOUND_API void qteQSound_stop(void* _obj);

} // extern "C"
