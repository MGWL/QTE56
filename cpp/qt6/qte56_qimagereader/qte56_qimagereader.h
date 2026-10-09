#pragma once

#ifdef _WIN32
  #ifdef QTE56_QIMAGEREADER_BUILD
    #define QIMAGEREADER_API __declspec(dllexport)
  #else
    #define QIMAGEREADER_API __declspec(dllimport)
  #endif
#else
  #define QIMAGEREADER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────
QIMAGEREADER_API void* qteQImageReader_create();                                            // 18300
QIMAGEREADER_API void* qteQImageReader_create_file(void* path);      // 18301
QIMAGEREADER_API void  qteQImageReader_delete(void* w);                                     // 18302

// ── File ──────────────────────────────────────────────────────────────────
QIMAGEREADER_API void  qteQImageReader_setFileName(void* w, void* path); // 18303
QIMAGEREADER_API int   qteQImageReader_fileName(void* w, char16_t* buf, int buf_len);        // 18304

// ── Read ──────────────────────────────────────────────────────────────────
QIMAGEREADER_API int   qteQImageReader_canRead(void* w);                                    // 18305
QIMAGEREADER_API void* qteQImageReader_read(void* w);                                       // 18306

// ── Format ────────────────────────────────────────────────────────────────
QIMAGEREADER_API int   qteQImageReader_format(void* w, char* buf, int buf_len);              // 18307
QIMAGEREADER_API void  qteQImageReader_setFormat(void* w, const char* fmt, int fmt_len);     // 18308

// ── Size ──────────────────────────────────────────────────────────────────
QIMAGEREADER_API void  qteQImageReader_size(void* w, int* out_w, int* out_h);               // 18309

// ── Animation ─────────────────────────────────────────────────────────────
QIMAGEREADER_API int   qteQImageReader_imageCount(void* w);                                  // 18310
QIMAGEREADER_API int   qteQImageReader_currentImageNumber(void* w);                          // 18311
QIMAGEREADER_API int   qteQImageReader_jumpToImage(void* w, int n);                          // 18312
QIMAGEREADER_API int   qteQImageReader_jumpToNextImage(void* w);                             // 18313

// ── Options ───────────────────────────────────────────────────────────────
QIMAGEREADER_API void  qteQImageReader_setScaledSize(void* w, int sw, int sh);               // 18314
QIMAGEREADER_API void  qteQImageReader_setAutoDetectImageFormat(void* w, int enable);        // 18315

// ── Error ─────────────────────────────────────────────────────────────────
QIMAGEREADER_API int   qteQImageReader_error(void* w);                                       // 18316
QIMAGEREADER_API int   qteQImageReader_errorString(void* w, char16_t* buf, int buf_len);     // 18317

// ── Static ────────────────────────────────────────────────────────────────
QIMAGEREADER_API int   qteQImageReader_supportedImageFormats(char* buf, int buf_len);        // 18318

} // extern "C"
