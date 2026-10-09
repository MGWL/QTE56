#pragma once

#ifdef _WIN32
  #ifdef QTE56_QIMAGE_BUILD
    #define QIMAGE_API __declspec(dllexport)
  #else
    #define QIMAGE_API __declspec(dllimport)
  #endif
#else
  #define QIMAGE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────
QIMAGE_API void* qteQImage_create();                                                   // 18200
QIMAGE_API void* qteQImage_create_wh(int w, int h, int format);                        // 18201
QIMAGE_API void* qteQImage_from_file(void* path);               // 18202
QIMAGE_API void  qteQImage_delete(void* w);                                            // 18203

// ── Properties ────────────────────────────────────────────────────────────
QIMAGE_API int   qteQImage_isNull(void* w);                                            // 18204
QIMAGE_API int   qteQImage_width(void* w);                                             // 18205
QIMAGE_API int   qteQImage_height(void* w);                                            // 18206
QIMAGE_API int   qteQImage_depth(void* w);                                             // 18207
QIMAGE_API int   qteQImage_format(void* w);                                            // 18208
QIMAGE_API int   qteQImage_bytesPerLine(void* w);                                      // 18209
QIMAGE_API int   qteQImage_sizeInBytes(void* w);                                       // 18210

// ── Raw data access ───────────────────────────────────────────────────────
QIMAGE_API void* qteQImage_bits(void* w);                                              // 18211
QIMAGE_API const void* qteQImage_constBits(void* w);                                   // 18212

// ── Fill ──────────────────────────────────────────────────────────────────
QIMAGE_API void  qteQImage_fill_rgb(void* w, int r, int g, int b, int a);              // 18213
QIMAGE_API void  qteQImage_fill_gc(void* w, int gc);                                   // 18214

// ── Pixel access ──────────────────────────────────────────────────────────
QIMAGE_API unsigned int qteQImage_pixel(void* w, int x, int y);                        // 18215
QIMAGE_API void  qteQImage_setPixel(void* w, int x, int y, unsigned int rgb);          // 18216
QIMAGE_API void* qteQImage_pixelColor(void* w, int x, int y);                          // 18217
QIMAGE_API void  qteQImage_setPixelColor(void* w, int x, int y, void* color);          // 18218
QIMAGE_API int   qteQImage_valid(void* w, int x, int y);                               // 18219

// ── Load / Save ───────────────────────────────────────────────────────────
QIMAGE_API int   qteQImage_load(void* w, void* path);           // 18220
QIMAGE_API int   qteQImage_save(void* w, void* path, int quality); // 18221

// ── Transforms ────────────────────────────────────────────────────────────
QIMAGE_API void* qteQImage_scaled(void* w, int width, int height, int aspectMode, int transformMode); // 18222
QIMAGE_API void* qteQImage_scaledToWidth(void* w, int width, int mode);                // 18223
QIMAGE_API void* qteQImage_scaledToHeight(void* w, int height, int mode);              // 18224
QIMAGE_API void* qteQImage_mirrored(void* w, int horiz, int vert);                     // 18225
QIMAGE_API void* qteQImage_copy_rect(void* w, int x, int y, int cw, int ch);          // 18226
QIMAGE_API void* qteQImage_convertToFormat(void* w, int fmt);                          // 18227
QIMAGE_API void  qteQImage_invertPixels(void* w, int mode);                            // 18228

// ── Alpha ─────────────────────────────────────────────────────────────────
QIMAGE_API int   qteQImage_hasAlphaChannel(void* w);                                   // 18229
QIMAGE_API void  qteQImage_setAlphaChannel(void* w, void* alphaChannel);               // 18230
QIMAGE_API void* qteQImage_createAlphaMask(void* w);                                   // 18231

// ── Misc ──────────────────────────────────────────────────────────────────
QIMAGE_API void* qteQImage_rgbSwapped(void* w);                                        // 18232
QIMAGE_API void* qteQImage_toPixmap(void* w);                                          // 18233
QIMAGE_API void* qteQImage_fromPixmap(void* pixmap);                                   // 18234

// ── DPI ───────────────────────────────────────────────────────────────────
QIMAGE_API void  qteQImage_setDotsPerMeterX(void* w, int dpm);                         // 18235
QIMAGE_API void  qteQImage_setDotsPerMeterY(void* w, int dpm);                         // 18236
QIMAGE_API int   qteQImage_dotsPerMeterX(void* w);                                     // 18237
QIMAGE_API int   qteQImage_dotsPerMeterY(void* w);                                     // 18238

// ── Memory I/O ────────────────────────────────────────────────────────────
QIMAGE_API int   qteQImage_loadFromData(void* img, const void* data, int len, const void* fmt, int fmtLen); // 19999
QIMAGE_API void* qteQImage_saveToBuffer(void* img, const void* fmt, int fmtLen, int quality);               // 20000

} // extern "C"
