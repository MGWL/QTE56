#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPIXMAP_BUILD
    #define QPIXMAP_API __declspec(dllexport)
  #else
    #define QPIXMAP_API __declspec(dllimport)
  #endif
#else
  #define QPIXMAP_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────
QPIXMAP_API void* qteQPixmap_create();
QPIXMAP_API void* qteQPixmap_from_file(void* path);
QPIXMAP_API void* qteQPixmap_from_wh(int w, int h);
QPIXMAP_API void  qteQPixmap_delete(void* w);

// ── Properties ────────────────────────────────────────────────────────────
QPIXMAP_API int qteQPixmap_isNull(void* w);
QPIXMAP_API int qteQPixmap_width(void* w);
QPIXMAP_API int qteQPixmap_height(void* w);

// ── Load / Save ───────────────────────────────────────────────────────────
QPIXMAP_API int qteQPixmap_load(void* w, void* path);
QPIXMAP_API int qteQPixmap_save(void* w, void* path);

// ── Transforms ────────────────────────────────────────────────────────────
QPIXMAP_API void* qteQPixmap_scaled(void* w, int width, int height, int aspectMode);
QPIXMAP_API void* qteQPixmap_scaledToWidth(void* w, int width);
QPIXMAP_API void* qteQPixmap_scaledToHeight(void* w, int height);

// ── Fill ──────────────────────────────────────────────────────────────────
QPIXMAP_API void qteQPixmap_fill(void* w, int r, int g, int b, int a);

// ── QLabel helper ─────────────────────────────────────────────────────────
QPIXMAP_API void qteQLabel_setPixmap(void* label, void* pixmap);

// ── Memory I/O ────────────────────────────────────────────────────────────
QPIXMAP_API int   qteQPixmap_loadFromData(void* pxm, const void* data, int len, const void* fmt, int fmtLen); // 20001
QPIXMAP_API void* qteQPixmap_saveToBuffer (void* pxm, const void* fmt, int fmtLen, int quality);              // 20002

} // extern "C"
