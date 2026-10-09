#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPICTURE_BUILD
    #define QPICTURE_API __declspec(dllexport)
  #else
    #define QPICTURE_API __declspec(dllimport)
  #endif
#else
  #define QPICTURE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────
QPICTURE_API void* qteQPicture_create();                                                    // 18400
QPICTURE_API void  qteQPicture_delete(void* w);                                             // 18401

// ── Properties ────────────────────────────────────────────────────────────
QPICTURE_API int   qteQPicture_isNull(void* w);                                             // 18402

// ── Play ──────────────────────────────────────────────────────────────────
QPICTURE_API int   qteQPicture_play(void* w, void* painter);                                // 18403

// ── Load / Save ───────────────────────────────────────────────────────────
QPICTURE_API int   qteQPicture_load(void* w, void* path);            // 18404
QPICTURE_API int   qteQPicture_save(void* w, void* path);            // 18405

// ── Size / Bounds ─────────────────────────────────────────────────────────
QPICTURE_API int   qteQPicture_size(void* w);                                               // 18406
QPICTURE_API void  qteQPicture_boundingRect(void* w, int* x, int* y, int* bw, int* bh);    // 18407
QPICTURE_API void  qteQPicture_setBoundingRect(void* w, int x, int y, int bw, int bh);     // 18408

} // extern "C"
