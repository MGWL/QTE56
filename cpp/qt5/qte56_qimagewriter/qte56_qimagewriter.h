#pragma once

#ifdef _WIN32
  #ifdef QTE56_QIMAGEWRITER_BUILD
    #define QIMAGEWRITER_API __declspec(dllexport)
  #else
    #define QIMAGEWRITER_API __declspec(dllimport)
  #endif
#else
  #define QIMAGEWRITER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────
QIMAGEWRITER_API void* qteQImageWriter_create();                                            // 18350
QIMAGEWRITER_API void* qteQImageWriter_create_file(void* path);      // 18351
QIMAGEWRITER_API void  qteQImageWriter_delete(void* w);                                     // 18352

// ── File ──────────────────────────────────────────────────────────────────
QIMAGEWRITER_API void  qteQImageWriter_setFileName(void* w, void* path); // 18353
QIMAGEWRITER_API int   qteQImageWriter_fileName(void* w, char16_t* buf, int buf_len);        // 18354

// ── Write ─────────────────────────────────────────────────────────────────
QIMAGEWRITER_API int   qteQImageWriter_canWrite(void* w);                                    // 18355
QIMAGEWRITER_API int   qteQImageWriter_write(void* w, void* image);                          // 18356

// ── Format / quality ──────────────────────────────────────────────────────
QIMAGEWRITER_API void  qteQImageWriter_setFormat(void* w, const char* fmt, int fmt_len);     // 18357
QIMAGEWRITER_API void  qteQImageWriter_setQuality(void* w, int quality);                     // 18358

// ── Error ─────────────────────────────────────────────────────────────────
QIMAGEWRITER_API int   qteQImageWriter_error(void* w);                                       // 18359
QIMAGEWRITER_API int   qteQImageWriter_errorString(void* w, char16_t* buf, int buf_len);     // 18360

} // extern "C"
