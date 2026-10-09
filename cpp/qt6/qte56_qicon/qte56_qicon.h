#pragma once

#ifdef _WIN32
  #ifdef QTE56_QICON_BUILD
    #define QICON_API __declspec(dllexport)
  #else
    #define QICON_API __declspec(dllimport)
  #endif
#else
  #define QICON_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────────
QICON_API void* qteQIcon_create(void* reserved);
QICON_API void* qteQIcon_create_file(void* path);
QICON_API void  qteQIcon_delete(void* icon);

// ── Methods ──────────────────────────────────────────────────────────────────
QICON_API int    qteQIcon_isNull(void* icon);
QICON_API void*  qteQIcon_name(void* icon);
QICON_API long long qteQIcon_cacheKey(void* icon);
QICON_API int    qteQIcon_isMask(void* icon);
QICON_API void   qteQIcon_setIsMask(void* icon, int mask);
QICON_API void   qteQIcon_addFile(void* icon, void* path,
                                   int w, int h, int mode, int state);
QICON_API void*  qteQIcon_actualSize(void* icon, int w, int h, int mode, int state);

// ── Static ───────────────────────────────────────────────────────────────────
QICON_API void*  qteQIcon_fromTheme(void* name);
QICON_API int    qteQIcon_hasThemeIcon(void* name);

} // extern "C"
