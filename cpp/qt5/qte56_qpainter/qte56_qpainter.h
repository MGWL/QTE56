#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPAINTER_BUILD
    #define QPAINTER_API __declspec(dllexport)
  #else
    #define QPAINTER_API __declspec(dllimport)
  #endif
#else
  #define QPAINTER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPAINTER_API void* qteQPainter_create(void* unused);               // 18000  QPainter()
QPAINTER_API void  qteQPainter_delete(void* w);                    // 18001
QPAINTER_API void* qteQPainter_create_device(void* device);        // 18002  QPainter(QPaintDevice*)

// ── Methods ──────────────────────────────────────────────────────────────
QPAINTER_API void* qteQPainter_device(void* _obj);                                         // 18003
QPAINTER_API int   qteQPainter_begin(void* _obj, void* device);                            // 18004
QPAINTER_API int   qteQPainter_end(void* _obj);                                            // 18005
QPAINTER_API int   qteQPainter_isActive(void* _obj);                                       // 18006
QPAINTER_API void  qteQPainter_initFrom(void* _obj, void* device);                         // 18007
QPAINTER_API void  qteQPainter_setCompositionMode(void* _obj, int mode);                   // 18008
QPAINTER_API int   qteQPainter_compositionMode(void* _obj);                                // 18009
QPAINTER_API void  qteQPainter_setFont(void* _obj, void* f);                               // 18010
QPAINTER_API void  qteQPainter_setPen_color(void* _obj, void* color);                      // 18011
QPAINTER_API void  qteQPainter_setPen_style(void* _obj, int style);                        // 18012
QPAINTER_API void  qteQPainter_setBrush(void* _obj, int style);                            // 18013
QPAINTER_API void  qteQPainter_setBackgroundMode(void* _obj, int mode);                    // 18014
QPAINTER_API int   qteQPainter_backgroundMode(void* _obj);                                 // 18015
QPAINTER_API void* qteQPainter_brushOrigin(void* _obj);                                    // 18016
QPAINTER_API void  qteQPainter_setBrushOrigin_ii(void* _obj, int x, int y);                // 18017
QPAINTER_API void  qteQPainter_setBrushOrigin_p(void* _obj, void* p0);                     // 18018
QPAINTER_API double qteQPainter_opacity(void* _obj);                                       // 18019
QPAINTER_API void  qteQPainter_setOpacity(void* _obj, double opacity);                     // 18020
QPAINTER_API void  qteQPainter_setClipRect_pp(void* _obj, void* rect, int op);             // 18021
QPAINTER_API void  qteQPainter_setClipRect_iiiip(void* _obj, int x, int y, int w, int h, int op); // 18022
QPAINTER_API void  qteQPainter_setClipping(void* _obj, int enable);                        // 18023
QPAINTER_API int   qteQPainter_hasClipping(void* _obj);                                    // 18024
QPAINTER_API void  qteQPainter_save(void* _obj);                                           // 18025
QPAINTER_API void  qteQPainter_restore(void* _obj);                                        // 18026
QPAINTER_API void  qteQPainter_resetMatrix(void* _obj);                                    // 18027
QPAINTER_API void  qteQPainter_resetTransform(void* _obj);                                 // 18028
QPAINTER_API void  qteQPainter_setMatrixEnabled(void* _obj, int enabled);                  // 18029
QPAINTER_API int   qteQPainter_matrixEnabled(void* _obj);                                  // 18030
QPAINTER_API void  qteQPainter_setWorldMatrixEnabled(void* _obj, int enabled);             // 18031
QPAINTER_API int   qteQPainter_worldMatrixEnabled(void* _obj);                             // 18032
QPAINTER_API void  qteQPainter_scale(void* _obj, double sx, double sy);                    // 18033
QPAINTER_API void  qteQPainter_shear(void* _obj, double sh, double sv);                    // 18034
QPAINTER_API void  qteQPainter_rotate(void* _obj, double a);                               // 18035
QPAINTER_API void  qteQPainter_translate_p(void* _obj, void* offset);                      // 18036
QPAINTER_API void  qteQPainter_translate_dd(void* _obj, double dx, double dy);             // 18037
QPAINTER_API void* qteQPainter_window(void* _obj);                                         // 18038
QPAINTER_API void  qteQPainter_setWindow_p(void* _obj, void* window);                      // 18039
QPAINTER_API void  qteQPainter_setWindow_iiii(void* _obj, int x, int y, int w, int h);     // 18040
QPAINTER_API void* qteQPainter_viewport(void* _obj);                                       // 18041
QPAINTER_API void  qteQPainter_setViewport_p(void* _obj, void* viewport);                  // 18042
QPAINTER_API void  qteQPainter_setViewport_iiii(void* _obj, int x, int y, int w, int h);   // 18043
QPAINTER_API void  qteQPainter_setViewTransformEnabled(void* _obj, int enable);            // 18044
QPAINTER_API int   qteQPainter_viewTransformEnabled(void* _obj);                           // 18045

// ── Drawing primitives ───────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_drawPoint_p(void* _obj, void* p);                           // 18046
QPAINTER_API void  qteQPainter_drawPoint_ii(void* _obj, int x, int y);                     // 18047
QPAINTER_API void  qteQPainter_drawPoints_pi(void* _obj, void* points, int pointCount);    // 18048  QPoint*
QPAINTER_API void  qteQPainter_drawLine_iiii(void* _obj, int x1, int y1, int x2, int y2);  // 18049
QPAINTER_API void  qteQPainter_drawLine_pp(void* _obj, void* p1, void* p2);                // 18050
QPAINTER_API void  qteQPainter_drawLines_pi(void* _obj, void* lines, int lineCount);       // 18051  QLine*
QPAINTER_API void  qteQPainter_drawRect_iiii(void* _obj, int x, int y, int w, int h);      // 18052
QPAINTER_API void  qteQPainter_drawRect_p(void* _obj, void* rect);                         // 18053
QPAINTER_API void  qteQPainter_drawRects_pi(void* _obj, void* rects, int rectCount);       // 18054  QRect*
QPAINTER_API void  qteQPainter_drawEllipse_p(void* _obj, void* r);                         // 18055
QPAINTER_API void  qteQPainter_drawEllipse_iiii(void* _obj, int x, int y, int w, int h);   // 18056
QPAINTER_API void  qteQPainter_drawEllipse_pii(void* _obj, void* center, int rx, int ry);  // 18057
QPAINTER_API void  qteQPainter_drawPolyline_pi(void* _obj, void* points, int pointCount);  // 18058  QPoint*
QPAINTER_API void  qteQPainter_drawPolygon_pip(void* _obj, void* points, int pointCount, int fillRule); // 18059
QPAINTER_API void  qteQPainter_drawConvexPolygon_pi(void* _obj, void* points, int pointCount); // 18060

// ── Arcs, pies, chords ──────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_drawArc_pii(void* _obj, void* rect, int a, int alen);                   // 18061
QPAINTER_API void  qteQPainter_drawArc_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen);// 18062
QPAINTER_API void  qteQPainter_drawPie_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen);// 18063
QPAINTER_API void  qteQPainter_drawPie_pii(void* _obj, void* rect, int a, int alen);                   // 18064
QPAINTER_API void  qteQPainter_drawChord_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen); // 18065
QPAINTER_API void  qteQPainter_drawChord_pii(void* _obj, void* rect, int a, int alen);                 // 18066
QPAINTER_API void  qteQPainter_drawRoundedRect_iiiiddp(void* _obj, int x, int y, int w, int h, double xRadius, double yRadius, int mode); // 18067
QPAINTER_API void  qteQPainter_drawRoundedRect_pddp(void* _obj, void* rect, double xRadius, double yRadius, int mode); // 18068
QPAINTER_API void  qteQPainter_drawRoundRect_iiiiii(void* _obj, int x, int y, int w, int h, int xr, int yr); // 18069
QPAINTER_API void  qteQPainter_drawRoundRect_pii(void* _obj, void* r, int xround, int yround);         // 18070

// ── Layout direction ─────────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_setLayoutDirection(void* _obj, int direction);               // 18071
QPAINTER_API int   qteQPainter_layoutDirection(void* _obj);                                 // 18072

// ── Text ─────────────────────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_drawText_ps(void* _obj, void* p, void* s);      // 18073
QPAINTER_API void  qteQPainter_drawText_iis(void* _obj, int x, int y, void* s);// 18074
QPAINTER_API void  qteQPainter_drawText_pisp(void* _obj, void* r, int flags, void* text, void* br); // 18075
QPAINTER_API void  qteQPainter_drawText_iiiiisp(void* _obj, int x, int y, int w, int h, int flags, void* text, void* br); // 18076
QPAINTER_API void* qteQPainter_boundingRect_pis(void* _obj, void* rect, int flags, void* text);     // 18077
QPAINTER_API void* qteQPainter_boundingRect_iiiiis(void* _obj, int x, int y, int w, int h, int flags, void* text); // 18078

// ── Fill / erase ─────────────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_fillRect_iiiip(void* _obj, int x, int y, int w, int h, void* color); // 18079 QColor*
QPAINTER_API void  qteQPainter_fillRect_pp(void* _obj, void* rect, void* color);                    // 18080 QRect*+QColor*
QPAINTER_API void  qteQPainter_fillRect_iiiii(void* _obj, int x, int y, int w, int h, int c);       // 18081 GlobalColor/BrushStyle
QPAINTER_API void  qteQPainter_fillRect_pi(void* _obj, void* rect, int c);                          // 18082 QRect*+GlobalColor
QPAINTER_API void  qteQPainter_eraseRect_iiii(void* _obj, int x, int y, int w, int h);              // 18083
QPAINTER_API void  qteQPainter_eraseRect_p(void* _obj, void* rect);                                 // 18084

// ── Render hints ─────────────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_setRenderHint(void* _obj, int hint, int on);                // 18085
QPAINTER_API void  qteQPainter_setRenderHints(void* _obj, int hints, int on);              // 18086
QPAINTER_API int   qteQPainter_renderHints(void* _obj);                                    // 18087

// ── Misc ─────────────────────────────────────────────────────────────────
QPAINTER_API void* qteQPainter_paintEngine(void* _obj);                                    // 18088
QPAINTER_API void  qteQPainter_setRedirected(void* _obj, void* device, void* replacement, void* offset); // 18089
QPAINTER_API void* qteQPainter_redirected(void* _obj, void* device, void* offset);         // 18090
QPAINTER_API void  qteQPainter_restoreRedirected(void* _obj, void* device);                // 18091
QPAINTER_API void  qteQPainter_beginNativePainting(void* _obj);                            // 18092
QPAINTER_API void  qteQPainter_endNativePainting(void* _obj);                              // 18093

// ── Draw image / pixmap ────────────────────────────────────────────────
QPAINTER_API void  qteQPainter_drawImage_rect(void* _obj, int x, int y, int w, int h, void* image, int sx, int sy, int sw, int sh); // 18094
QPAINTER_API void  qteQPainter_drawImage_point(void* _obj, int x, int y, void* image);    // 18095
QPAINTER_API void  qteQPainter_drawPixmap_rect(void* _obj, int x, int y, int w, int h, void* pixmap, int sx, int sy, int sw, int sh); // 18096
QPAINTER_API void  qteQPainter_drawPixmap_point(void* _obj, int x, int y, void* pixmap);  // 18097


// ── Дополнено 2026-07-26 (augment, длинные суффиксы) ────────────────────
QPAINTER_API void qteQPainter_setBrushOrigin_qpointf(void* _obj, void* p0);                // 18102
QPAINTER_API void qteQPainter_setClipRect_qrectf_qt_clipoperation(void* _obj, void* p0, int op); // 18103
QPAINTER_API void qteQPainter_setClipRect_qrect_qt_clipoperation(void* _obj, void* p0, int op); // 18104
QPAINTER_API void* qteQPainter_clipBoundingRect(void* _obj);                               // 18106
QPAINTER_API void qteQPainter_translate_qpointf(void* _obj, void* offset);                 // 18107
QPAINTER_API void qteQPainter_drawPoint_qpointf(void* _obj, void* pt);                     // 18114
QPAINTER_API void qteQPainter_drawPoints_qpointf_int(void* _obj, void* points, int pointCount); // 18117
QPAINTER_API void qteQPainter_drawLine_qpointf_qpointf(void* _obj, void* p1, void* p2);    // 18121
QPAINTER_API void qteQPainter_drawLines_qlinef_int(void* _obj, void* lines, int lineCount); // 18122
QPAINTER_API void qteQPainter_drawLines_qpointf_int(void* _obj, void* pointPairs, int lineCount); // 18123
QPAINTER_API void qteQPainter_drawLines_qpoint_int(void* _obj, void* pointPairs, int lineCount); // 18125
QPAINTER_API void qteQPainter_drawRect_qrectf(void* _obj, void* rect);                     // 18126
QPAINTER_API void qteQPainter_drawRect_int_int_int_int(void* _obj, int x1, int y1, int w, int h); // 18127
QPAINTER_API void qteQPainter_drawRects_qrectf_int(void* _obj, void* rects, int rectCount); // 18129
QPAINTER_API void qteQPainter_drawEllipse_qrectf(void* _obj, void* r);                     // 18131
QPAINTER_API void qteQPainter_drawEllipse_qpointf_qreal_qreal(void* _obj, void* center, double rx, double ry); // 18134
QPAINTER_API void qteQPainter_drawPolyline_qpointf_int(void* _obj, void* points, int pointCount); // 18136
QPAINTER_API void qteQPainter_drawPolygon_qpointf_int_qt_fillrule(void* _obj, void* points, int pointCount, int fillRule); // 18138
QPAINTER_API void qteQPainter_drawConvexPolygon_qpointf_int(void* _obj, void* points, int pointCount); // 18140
QPAINTER_API void qteQPainter_drawArc_qrectf_int_int(void* _obj, void* rect, int a, int alen); // 18142
QPAINTER_API void qteQPainter_drawArc_qrect_int_int(void* _obj, void* p0, int a, int alen); // 18143
QPAINTER_API void qteQPainter_drawPie_qrectf_int_int(void* _obj, void* rect, int a, int alen); // 18145
QPAINTER_API void qteQPainter_drawPie_qrect_int_int(void* _obj, void* p0, int a, int alen); // 18147
QPAINTER_API void qteQPainter_drawChord_qrectf_int_int(void* _obj, void* rect, int a, int alen); // 18148
QPAINTER_API void qteQPainter_drawChord_qrect_int_int(void* _obj, void* p0, int a, int alen); // 18150
QPAINTER_API void qteQPainter_drawRoundedRect_qrectf_qreal_qreal_qt_sizemode(void* _obj, void* rect, double xRadius, double yRadius, int mode); // 18151
QPAINTER_API void qteQPainter_drawRoundRect_qrectf_int_int(void* _obj, void* r, int xround, int yround); // 18154
QPAINTER_API void qteQPainter_drawRoundRect_int_int_int_int_int_int(void* _obj, int x, int y, int w, int h, int p4, int p5); // 18155
QPAINTER_API void qteQPainter_drawTiledPixmap_qrectf_qpixmap_qpointf(void* _obj, void* rect, void* pm, void* offset); // 18157
QPAINTER_API void qteQPainter_drawTiledPixmap_int_int_int_int_qpixmap_int_int(void* _obj, int x, int y, int w, int h, void* p4, int sx, int sy); // 18158
QPAINTER_API void qteQPainter_drawTiledPixmap_qrect_qpixmap_qpoint(void* _obj, void* p0, void* p1, void* p2); // 18159
QPAINTER_API void qteQPainter_drawPixmap_qrectf_qpixmap_qrectf(void* _obj, void* targetRect, void* pixmap, void* sourceRect); // 18160
QPAINTER_API void qteQPainter_drawPixmap_qrect_qpixmap_qrect(void* _obj, void* targetRect, void* pixmap, void* sourceRect); // 18161
QPAINTER_API void qteQPainter_drawPixmap_int_int_int_int_qpixmap_int_int_int_int(void* _obj, int x, int y, int w, int h, void* pm, int sx, int sy, int sw, int sh); // 18162
QPAINTER_API void qteQPainter_drawPixmap_int_int_qpixmap_int_int_int_int(void* _obj, int x, int y, void* pm, int sx, int sy, int sw, int sh); // 18163
QPAINTER_API void qteQPainter_drawPixmap_qpointf_qpixmap_qrectf(void* _obj, void* p, void* pm, void* sr); // 18164
QPAINTER_API void qteQPainter_drawPixmap_qpoint_qpixmap_qrect(void* _obj, void* p, void* pm, void* sr); // 18165
QPAINTER_API void qteQPainter_drawPixmap_qpointf_qpixmap(void* _obj, void* p, void* pm);   // 18166
QPAINTER_API void qteQPainter_drawPixmap_qpoint_qpixmap(void* _obj, void* p, void* pm);    // 18167
QPAINTER_API void qteQPainter_drawPixmap_int_int_qpixmap(void* _obj, int x, int y, void* pm); // 18168
QPAINTER_API void qteQPainter_drawPixmap_qrect_qpixmap(void* _obj, void* r, void* pm);     // 18169
QPAINTER_API void qteQPainter_drawPixmap_int_int_int_int_qpixmap(void* _obj, int x, int y, int w, int h, void* pm); // 18170
QPAINTER_API void qteQPainter_drawImage_qrectf_qimage_qrectf_qt_imageconversionflags(void* _obj, void* targetRect, void* image, void* sourceRect, int flags); // 18171
QPAINTER_API void qteQPainter_drawImage_qrect_qimage_qrect_qt_imageconversionflags(void* _obj, void* targetRect, void* image, void* sourceRect, int flags); // 18172
QPAINTER_API void qteQPainter_drawImage_qpointf_qimage_qrectf_qt_imageconversionflags(void* _obj, void* p, void* image, void* sr, int flags); // 18173
QPAINTER_API void qteQPainter_drawImage_qpoint_qimage_qrect_qt_imageconversionflags(void* _obj, void* p, void* image, void* sr, int flags); // 18174
QPAINTER_API void qteQPainter_drawImage_qrectf_qimage(void* _obj, void* r, void* image);   // 18175
QPAINTER_API void qteQPainter_drawImage_qrect_qimage(void* _obj, void* r, void* image);    // 18176
QPAINTER_API void qteQPainter_drawImage_qpointf_qimage(void* _obj, void* p, void* image);  // 18177
QPAINTER_API void qteQPainter_drawImage_qpoint_qimage(void* _obj, void* p, void* image);   // 18178
QPAINTER_API void qteQPainter_drawImage_int_int_qimage_int_int_int_int_qt_imageconversionflags(void* _obj, int x, int y, void* image, int sx, int sy, int sw, int sh, int flags); // 18179
QPAINTER_API void qteQPainter_drawText_qpointf_qstring(void* _obj, void* p, const wchar_t* s, int s_len); // 18180
QPAINTER_API void qteQPainter_drawText_qpoint_qstring(void* _obj, void* p, const wchar_t* s, int s_len); // 18181
QPAINTER_API void qteQPainter_drawText_int_int_qstring(void* _obj, int x, int y, const wchar_t* s, int s_len); // 18182
QPAINTER_API void qteQPainter_drawText_qpointf_qstring_int_int(void* _obj, void* p, const wchar_t* str, int str_len, int tf, int justificationPadding); // 18183
QPAINTER_API void qteQPainter_drawText_qrectf_int_qstring_qrectf(void* _obj, void* r, int flags, const wchar_t* text, int text_len, void* br); // 18184
QPAINTER_API void qteQPainter_drawText_qrect_int_qstring_qrect(void* _obj, void* r, int flags, const wchar_t* text, int text_len, void* br); // 18185
QPAINTER_API void qteQPainter_drawText_int_int_int_int_int_qstring_qrect(void* _obj, int x, int y, int w, int h, int flags, const wchar_t* text, int text_len, void* br); // 18186
QPAINTER_API void qteQPainter_drawText_qrectf_qstring(void* _obj, void* r, const wchar_t* text, int text_len); // 18187
QPAINTER_API void* qteQPainter_boundingRect_qrectf_int_qstring(void* _obj, void* rect, int flags, const wchar_t* text, int text_len); // 18188
QPAINTER_API void* qteQPainter_boundingRect_qrect_int_qstring(void* _obj, void* rect, int flags, const wchar_t* text, int text_len); // 18189
QPAINTER_API void* qteQPainter_boundingRect_int_int_int_int_int_qstring(void* _obj, int x, int y, int w, int h, int flags, const wchar_t* text, int text_len); // 18190
QPAINTER_API void* qteQPainter_boundingRect_qrectf_qstring(void* _obj, void* rect, const wchar_t* text, int text_len); // 18191
QPAINTER_API void qteQPainter_fillRect_qrectf_qcolor(void* _obj, void* p0, void* color);   // 18192
QPAINTER_API void qteQPainter_fillRect_qrect_qcolor(void* _obj, void* p0, void* color);    // 18194
QPAINTER_API void qteQPainter_fillRect_qrect_qt_globalcolor(void* _obj, void* r, int c);   // 18196
QPAINTER_API void qteQPainter_fillRect_qrectf_qt_globalcolor(void* _obj, void* r, int c);  // 18197
QPAINTER_API void qteQPainter_fillRect_int_int_int_int_qt_brushstyle(void* _obj, int x, int y, int w, int h, int style); // 18198
QPAINTER_API void qteQPainter_fillRect_qrect_qt_brushstyle(void* _obj, void* r, int style); // 18199
QPAINTER_API void qteQPainter_fillRect_qrectf_qt_brushstyle(void* _obj, void* r, int style); // 18239
QPAINTER_API void qteQPainter_fillRect_int_int_int_int_qgradient_preset(void* _obj, int x, int y, int w, int h, int preset); // 18240
QPAINTER_API void qteQPainter_fillRect_qrect_qgradient_preset(void* _obj, void* r, int preset); // 18241
QPAINTER_API void qteQPainter_fillRect_qrectf_qgradient_preset(void* _obj, void* r, int preset); // 18242
QPAINTER_API void qteQPainter_eraseRect_qrectf(void* _obj, void* p0);                      // 18243
QPAINTER_API void qteQPainter_eraseRect_qrect(void* _obj, void* p0);                       // 18245

} // extern "C"
