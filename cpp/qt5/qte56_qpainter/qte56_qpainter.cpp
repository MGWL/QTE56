#ifndef QTE56_QPAINTER_BUILD
#define QTE56_QPAINTER_BUILD
#endif
#include "qte56_qpainter.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QPainter>
#include <QImage>
#include <QPixmap>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQPainter_create(void* /*unused*/) {
    return new QPainter();
}

void qteQPainter_delete(void* w) {
    delete (QPainter*)w;
}

void* qteQPainter_create_device(void* device) {
    return new QPainter((QPaintDevice*)device);
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQPainter_device(void* _obj) {
    return (void*)((QPainter*)_obj)->device();
}

int qteQPainter_begin(void* _obj, void* device) {
    return ((QPainter*)_obj)->begin((QPaintDevice*)device) ? 1 : 0;
}

int qteQPainter_end(void* _obj) {
    return ((QPainter*)_obj)->end() ? 1 : 0;
}

int qteQPainter_isActive(void* _obj) {
    return ((QPainter*)_obj)->isActive() ? 1 : 0;
}

void qteQPainter_initFrom(void* _obj, void* device) {
    ((QPainter*)_obj)->initFrom((const QPaintDevice*)device);
}

void qteQPainter_setCompositionMode(void* _obj, int mode) {
    ((QPainter*)_obj)->setCompositionMode((QPainter::CompositionMode)mode);
}

int qteQPainter_compositionMode(void* _obj) {
    return ((QPainter*)_obj)->compositionMode();
}

void qteQPainter_setFont(void* _obj, void* f) {
    ((QPainter*)_obj)->setFont(*(const QFont*)f);
}

void qteQPainter_setPen_color(void* _obj, void* color) {
    ((QPainter*)_obj)->setPen(*(const QColor*)color);
}

void qteQPainter_setPen_style(void* _obj, int style) {
    ((QPainter*)_obj)->setPen((Qt::PenStyle)style);
}

void qteQPainter_setBrush(void* _obj, int style) {
    ((QPainter*)_obj)->setBrush((Qt::BrushStyle)style);
}

void qteQPainter_setBackgroundMode(void* _obj, int mode) {
    ((QPainter*)_obj)->setBackgroundMode((Qt::BGMode)mode);
}

int qteQPainter_backgroundMode(void* _obj) {
    return ((QPainter*)_obj)->backgroundMode();
}

void* qteQPainter_brushOrigin(void* _obj) {
    return new QPoint(((QPainter*)_obj)->brushOrigin());
}

void qteQPainter_setBrushOrigin_ii(void* _obj, int x, int y) {
    ((QPainter*)_obj)->setBrushOrigin(x, y);
}

void qteQPainter_setBrushOrigin_p(void* _obj, void* p0) {
    ((QPainter*)_obj)->setBrushOrigin(*(const QPoint*)p0);
}

double qteQPainter_opacity(void* _obj) {
    return ((QPainter*)_obj)->opacity();
}

void qteQPainter_setOpacity(void* _obj, double opacity) {
    ((QPainter*)_obj)->setOpacity(opacity);
}

void qteQPainter_setClipRect_pp(void* _obj, void* rect, int op) {
    ((QPainter*)_obj)->setClipRect(*(const QRect*)rect, (Qt::ClipOperation)op);
}

void qteQPainter_setClipRect_iiiip(void* _obj, int x, int y, int w, int h, int op) {
    ((QPainter*)_obj)->setClipRect(x, y, w, h, (Qt::ClipOperation)op);
}

void qteQPainter_setClipping(void* _obj, int enable) {
    ((QPainter*)_obj)->setClipping((enable != 0));
}

int qteQPainter_hasClipping(void* _obj) {
    return ((QPainter*)_obj)->hasClipping() ? 1 : 0;
}

void qteQPainter_save(void* _obj) {
    ((QPainter*)_obj)->save();
}

void qteQPainter_restore(void* _obj) {
    ((QPainter*)_obj)->restore();
}

void qteQPainter_resetMatrix(void* _obj) {
    ((QPainter*)_obj)->resetMatrix();
}

void qteQPainter_resetTransform(void* _obj) {
    ((QPainter*)_obj)->resetTransform();
}

void qteQPainter_setMatrixEnabled(void* _obj, int enabled) {
    ((QPainter*)_obj)->setMatrixEnabled((enabled != 0));
}

int qteQPainter_matrixEnabled(void* _obj) {
    return ((QPainter*)_obj)->matrixEnabled() ? 1 : 0;
}

void qteQPainter_setWorldMatrixEnabled(void* _obj, int enabled) {
    ((QPainter*)_obj)->setWorldMatrixEnabled((enabled != 0));
}

int qteQPainter_worldMatrixEnabled(void* _obj) {
    return ((QPainter*)_obj)->worldMatrixEnabled() ? 1 : 0;
}

void qteQPainter_scale(void* _obj, double sx, double sy) {
    ((QPainter*)_obj)->scale(sx, sy);
}

void qteQPainter_shear(void* _obj, double sh, double sv) {
    ((QPainter*)_obj)->shear(sh, sv);
}

void qteQPainter_rotate(void* _obj, double a) {
    ((QPainter*)_obj)->rotate(a);
}

void qteQPainter_translate_p(void* _obj, void* offset) {
    ((QPainter*)_obj)->translate(*(const QPoint*)offset);
}

void qteQPainter_translate_dd(void* _obj, double dx, double dy) {
    ((QPainter*)_obj)->translate(dx, dy);
}

void* qteQPainter_window(void* _obj) {
    return new QRect(((QPainter*)_obj)->window());
}

void qteQPainter_setWindow_p(void* _obj, void* window) {
    ((QPainter*)_obj)->setWindow(*(const QRect*)window);
}

void qteQPainter_setWindow_iiii(void* _obj, int x, int y, int w, int h) {
    ((QPainter*)_obj)->setWindow(x, y, w, h);
}

void* qteQPainter_viewport(void* _obj) {
    return new QRect(((QPainter*)_obj)->viewport());
}

void qteQPainter_setViewport_p(void* _obj, void* viewport) {
    ((QPainter*)_obj)->setViewport(*(const QRect*)viewport);
}

void qteQPainter_setViewport_iiii(void* _obj, int x, int y, int w, int h) {
    ((QPainter*)_obj)->setViewport(x, y, w, h);
}

void qteQPainter_setViewTransformEnabled(void* _obj, int enable) {
    ((QPainter*)_obj)->setViewTransformEnabled((enable != 0));
}

int qteQPainter_viewTransformEnabled(void* _obj) {
    return ((QPainter*)_obj)->viewTransformEnabled() ? 1 : 0;
}

// ── Drawing primitives ───────────────────────────────────────────────────
void qteQPainter_drawPoint_p(void* _obj, void* p) {
    ((QPainter*)_obj)->drawPoint(*(const QPoint*)p);
}

void qteQPainter_drawPoint_ii(void* _obj, int x, int y) {
    ((QPainter*)_obj)->drawPoint(x, y);
}

void qteQPainter_drawPoints_pi(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawPoints((const QPoint*)points, pointCount);
}

void qteQPainter_drawLine_iiii(void* _obj, int x1, int y1, int x2, int y2) {
    ((QPainter*)_obj)->drawLine(x1, y1, x2, y2);
}

void qteQPainter_drawLine_pp(void* _obj, void* p1, void* p2) {
    ((QPainter*)_obj)->drawLine(*(const QPoint*)p1, *(const QPoint*)p2);
}

void qteQPainter_drawLines_pi(void* _obj, void* lines, int lineCount) {
    ((QPainter*)_obj)->drawLines((const QLine*)lines, lineCount);
}

void qteQPainter_drawRect_iiii(void* _obj, int x, int y, int w, int h) {
    ((QPainter*)_obj)->drawRect(x, y, w, h);
}

void qteQPainter_drawRect_p(void* _obj, void* rect) {
    ((QPainter*)_obj)->drawRect(*(const QRect*)rect);
}

void qteQPainter_drawRects_pi(void* _obj, void* rects, int rectCount) {
    ((QPainter*)_obj)->drawRects((const QRect*)rects, rectCount);
}

void qteQPainter_drawEllipse_p(void* _obj, void* r) {
    ((QPainter*)_obj)->drawEllipse(*(const QRect*)r);
}

void qteQPainter_drawEllipse_iiii(void* _obj, int x, int y, int w, int h) {
    ((QPainter*)_obj)->drawEllipse(x, y, w, h);
}

void qteQPainter_drawEllipse_pii(void* _obj, void* center, int rx, int ry) {
    ((QPainter*)_obj)->drawEllipse(*(const QPoint*)center, rx, ry);
}

void qteQPainter_drawPolyline_pi(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawPolyline((const QPoint*)points, pointCount);
}

void qteQPainter_drawPolygon_pip(void* _obj, void* points, int pointCount, int fillRule) {
    ((QPainter*)_obj)->drawPolygon((const QPoint*)points, pointCount, (Qt::FillRule)fillRule);
}

void qteQPainter_drawConvexPolygon_pi(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawConvexPolygon((const QPoint*)points, pointCount);
}

// ── Arcs, pies, chords ──────────────────────────────────────────────────
void qteQPainter_drawArc_pii(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawArc(*(const QRect*)rect, a, alen);
}

void qteQPainter_drawArc_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen) {
    ((QPainter*)_obj)->drawArc(x, y, w, h, a, alen);
}

void qteQPainter_drawPie_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen) {
    ((QPainter*)_obj)->drawPie(x, y, w, h, a, alen);
}

void qteQPainter_drawPie_pii(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawPie(*(const QRect*)rect, a, alen);
}

void qteQPainter_drawChord_iiiiii(void* _obj, int x, int y, int w, int h, int a, int alen) {
    ((QPainter*)_obj)->drawChord(x, y, w, h, a, alen);
}

void qteQPainter_drawChord_pii(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawChord(*(const QRect*)rect, a, alen);
}

void qteQPainter_drawRoundedRect_iiiiddp(void* _obj, int x, int y, int w, int h, double xRadius, double yRadius, int mode) {
    ((QPainter*)_obj)->drawRoundedRect(x, y, w, h, xRadius, yRadius, (Qt::SizeMode)mode);
}

void qteQPainter_drawRoundedRect_pddp(void* _obj, void* rect, double xRadius, double yRadius, int mode) {
    ((QPainter*)_obj)->drawRoundedRect(*(const QRect*)rect, xRadius, yRadius, (Qt::SizeMode)mode);
}

void qteQPainter_drawRoundRect_iiiiii(void* _obj, int x, int y, int w, int h, int xr, int yr) {
    ((QPainter*)_obj)->drawRoundRect(x, y, w, h, xr, yr);
}

void qteQPainter_drawRoundRect_pii(void* _obj, void* r, int xround, int yround) {
    ((QPainter*)_obj)->drawRoundRect(*(const QRect*)r, xround, yround);
}

// ── Layout direction ─────────────────────────────────────────────────────
void qteQPainter_setLayoutDirection(void* _obj, int direction) {
    ((QPainter*)_obj)->setLayoutDirection((Qt::LayoutDirection)direction);
}

int qteQPainter_layoutDirection(void* _obj) {
    return ((QPainter*)_obj)->layoutDirection();
}

// ── Text ─────────────────────────────────────────────────────────────────
void qteQPainter_drawText_ps(void* _obj, void* p, void* s) {
    ((QPainter*)_obj)->drawText(*(const QPoint*)p, *(QString*)s);
}

void qteQPainter_drawText_iis(void* _obj, int x, int y, void* s) {
    ((QPainter*)_obj)->drawText(x, y, *(QString*)s);
}

void qteQPainter_drawText_pisp(void* _obj, void* r, int flags, void* text, void* br) {
    ((QPainter*)_obj)->drawText(*(const QRect*)r, flags, *(QString*)text, (QRect*)br);
}

void qteQPainter_drawText_iiiiisp(void* _obj, int x, int y, int w, int h, int flags, void* text, void* br) {
    ((QPainter*)_obj)->drawText(x, y, w, h, flags, *(QString*)text, (QRect*)br);
}

void* qteQPainter_boundingRect_pis(void* _obj, void* rect, int flags, void* text) {
    return new QRect(((QPainter*)_obj)->boundingRect(*(const QRect*)rect, flags, *(QString*)text));
}

void* qteQPainter_boundingRect_iiiiis(void* _obj, int x, int y, int w, int h, int flags, void* text) {
    return new QRect(((QPainter*)_obj)->boundingRect(x, y, w, h, flags, *(QString*)text));
}

// ── Fill / erase ─────────────────────────────────────────────────────────
void qteQPainter_fillRect_iiiip(void* _obj, int x, int y, int w, int h, void* color) {
    ((QPainter*)_obj)->fillRect(x, y, w, h, *(const QColor*)color);
}

void qteQPainter_fillRect_pp(void* _obj, void* rect, void* color) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)rect, *(const QColor*)color);
}

void qteQPainter_fillRect_iiiii(void* _obj, int x, int y, int w, int h, int c) {
    ((QPainter*)_obj)->fillRect(x, y, w, h, (Qt::GlobalColor)c);
}

void qteQPainter_fillRect_pi(void* _obj, void* rect, int c) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)rect, (Qt::GlobalColor)c);
}

void qteQPainter_eraseRect_iiii(void* _obj, int x, int y, int w, int h) {
    ((QPainter*)_obj)->eraseRect(x, y, w, h);
}

void qteQPainter_eraseRect_p(void* _obj, void* rect) {
    ((QPainter*)_obj)->eraseRect(*(const QRect*)rect);
}

// ── Render hints ─────────────────────────────────────────────────────────
void qteQPainter_setRenderHint(void* _obj, int hint, int on) {
    ((QPainter*)_obj)->setRenderHint((QPainter::RenderHint)hint, (on != 0));
}

void qteQPainter_setRenderHints(void* _obj, int hints, int on) {
    ((QPainter*)_obj)->setRenderHints((QPainter::RenderHints)hints, (on != 0));
}

int qteQPainter_renderHints(void* _obj) {
    return ((QPainter*)_obj)->renderHints();
}

// ── Misc ─────────────────────────────────────────────────────────────────
void* qteQPainter_paintEngine(void* _obj) {
    return (void*)((QPainter*)_obj)->paintEngine();
}

void qteQPainter_setRedirected(void* _obj, void* device, void* replacement, void* offset) {
    // Static method in Qt, _obj unused but kept for API consistency
    QPainter::setRedirected((const QPaintDevice*)device, (QPaintDevice*)replacement, *(const QPoint*)offset);
}

void* qteQPainter_redirected(void* _obj, void* device, void* offset) {
    return (void*)QPainter::redirected((const QPaintDevice*)device, (QPoint*)offset);
}

void qteQPainter_restoreRedirected(void* _obj, void* device) {
    QPainter::restoreRedirected((const QPaintDevice*)device);
}

void qteQPainter_beginNativePainting(void* _obj) {
    ((QPainter*)_obj)->beginNativePainting();
}

void qteQPainter_endNativePainting(void* _obj) {
    ((QPainter*)_obj)->endNativePainting();
}

// ── Draw image / pixmap ────────────────────────────────────────────────

void qteQPainter_drawImage_rect(void* _obj, int x, int y, int w, int h,
    void* image, int sx, int sy, int sw, int sh) {
    ((QPainter*)_obj)->drawImage(QRect(x,y,w,h), *(QImage*)image, QRect(sx,sy,sw,sh));
}

void qteQPainter_drawImage_point(void* _obj, int x, int y, void* image) {
    ((QPainter*)_obj)->drawImage(x, y, *(QImage*)image);
}

void qteQPainter_drawPixmap_rect(void* _obj, int x, int y, int w, int h,
    void* pixmap, int sx, int sy, int sw, int sh) {
    ((QPainter*)_obj)->drawPixmap(QRect(x,y,w,h), *(QPixmap*)pixmap, QRect(sx,sy,sw,sh));
}

void qteQPainter_drawPixmap_point(void* _obj, int x, int y, void* pixmap) {
    ((QPainter*)_obj)->drawPixmap(x, y, *(QPixmap*)pixmap);
}


// ── Дополнено 2026-07-26 (augment, длинные суффиксы) ────────────────────
// 18102
void qteQPainter_setBrushOrigin_qpointf(void* _obj, void* p0) {
    ((QPainter*)_obj)->setBrushOrigin(*(const QPointF*)p0);
}

// 18103
void qteQPainter_setClipRect_qrectf_qt_clipoperation(void* _obj, void* p0, int op) {
    ((QPainter*)_obj)->setClipRect(*(const QRectF*)p0, (Qt::ClipOperation)op);
}

// 18104
void qteQPainter_setClipRect_qrect_qt_clipoperation(void* _obj, void* p0, int op) {
    ((QPainter*)_obj)->setClipRect(*(const QRect*)p0, (Qt::ClipOperation)op);
}

// 18106
void* qteQPainter_clipBoundingRect(void* _obj) {
    return new QRectF(((QPainter*)_obj)->clipBoundingRect());
}

// 18107
void qteQPainter_translate_qpointf(void* _obj, void* offset) {
    ((QPainter*)_obj)->translate(*(const QPointF*)offset);
}

// 18114
void qteQPainter_drawPoint_qpointf(void* _obj, void* pt) {
    ((QPainter*)_obj)->drawPoint(*(const QPointF*)pt);
}

// 18117
void qteQPainter_drawPoints_qpointf_int(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawPoints((const QPointF*)points, pointCount);
}

// 18121
void qteQPainter_drawLine_qpointf_qpointf(void* _obj, void* p1, void* p2) {
    ((QPainter*)_obj)->drawLine(*(const QPointF*)p1, *(const QPointF*)p2);
}

// 18122
void qteQPainter_drawLines_qlinef_int(void* _obj, void* lines, int lineCount) {
    ((QPainter*)_obj)->drawLines((const QLineF*)lines, lineCount);
}

// 18123
void qteQPainter_drawLines_qpointf_int(void* _obj, void* pointPairs, int lineCount) {
    ((QPainter*)_obj)->drawLines((const QPointF*)pointPairs, lineCount);
}

// 18125
void qteQPainter_drawLines_qpoint_int(void* _obj, void* pointPairs, int lineCount) {
    ((QPainter*)_obj)->drawLines((const QPoint*)pointPairs, lineCount);
}

// 18126
void qteQPainter_drawRect_qrectf(void* _obj, void* rect) {
    ((QPainter*)_obj)->drawRect(*(const QRectF*)rect);
}

// 18127
void qteQPainter_drawRect_int_int_int_int(void* _obj, int x1, int y1, int w, int h) {
    ((QPainter*)_obj)->drawRect(x1, y1, w, h);
}

// 18129
void qteQPainter_drawRects_qrectf_int(void* _obj, void* rects, int rectCount) {
    ((QPainter*)_obj)->drawRects((const QRectF*)rects, rectCount);
}

// 18131
void qteQPainter_drawEllipse_qrectf(void* _obj, void* r) {
    ((QPainter*)_obj)->drawEllipse(*(const QRectF*)r);
}

// 18134
void qteQPainter_drawEllipse_qpointf_qreal_qreal(void* _obj, void* center, double rx, double ry) {
    ((QPainter*)_obj)->drawEllipse(*(const QPointF*)center, rx, ry);
}

// 18136
void qteQPainter_drawPolyline_qpointf_int(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawPolyline((const QPointF*)points, pointCount);
}

// 18138
void qteQPainter_drawPolygon_qpointf_int_qt_fillrule(void* _obj, void* points, int pointCount, int fillRule) {
    ((QPainter*)_obj)->drawPolygon((const QPointF*)points, pointCount, (Qt::FillRule)fillRule);
}

// 18140
void qteQPainter_drawConvexPolygon_qpointf_int(void* _obj, void* points, int pointCount) {
    ((QPainter*)_obj)->drawConvexPolygon((const QPointF*)points, pointCount);
}

// 18142
void qteQPainter_drawArc_qrectf_int_int(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawArc(*(const QRectF*)rect, a, alen);
}

// 18143
void qteQPainter_drawArc_qrect_int_int(void* _obj, void* p0, int a, int alen) {
    ((QPainter*)_obj)->drawArc(*(const QRect*)p0, a, alen);
}

// 18145
void qteQPainter_drawPie_qrectf_int_int(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawPie(*(const QRectF*)rect, a, alen);
}

// 18147
void qteQPainter_drawPie_qrect_int_int(void* _obj, void* p0, int a, int alen) {
    ((QPainter*)_obj)->drawPie(*(const QRect*)p0, a, alen);
}

// 18148
void qteQPainter_drawChord_qrectf_int_int(void* _obj, void* rect, int a, int alen) {
    ((QPainter*)_obj)->drawChord(*(const QRectF*)rect, a, alen);
}

// 18150
void qteQPainter_drawChord_qrect_int_int(void* _obj, void* p0, int a, int alen) {
    ((QPainter*)_obj)->drawChord(*(const QRect*)p0, a, alen);
}

// 18151
void qteQPainter_drawRoundedRect_qrectf_qreal_qreal_qt_sizemode(void* _obj, void* rect, double xRadius, double yRadius, int mode) {
    ((QPainter*)_obj)->drawRoundedRect(*(const QRectF*)rect, xRadius, yRadius, (Qt::SizeMode)mode);
}

// 18154
void qteQPainter_drawRoundRect_qrectf_int_int(void* _obj, void* r, int xround, int yround) {
    ((QPainter*)_obj)->drawRoundRect(*(const QRectF*)r, xround, yround);
}

// 18155
void qteQPainter_drawRoundRect_int_int_int_int_int_int(void* _obj, int x, int y, int w, int h, int p4, int p5) {
    ((QPainter*)_obj)->drawRoundRect(x, y, w, h, p4, p5);
}

// 18157
void qteQPainter_drawTiledPixmap_qrectf_qpixmap_qpointf(void* _obj, void* rect, void* pm, void* offset) {
    ((QPainter*)_obj)->drawTiledPixmap(*(const QRectF*)rect, *(const QPixmap*)pm, *(const QPointF*)offset);
}

// 18158
void qteQPainter_drawTiledPixmap_int_int_int_int_qpixmap_int_int(void* _obj, int x, int y, int w, int h, void* p4, int sx, int sy) {
    ((QPainter*)_obj)->drawTiledPixmap(x, y, w, h, *(const QPixmap*)p4, sx, sy);
}

// 18159
void qteQPainter_drawTiledPixmap_qrect_qpixmap_qpoint(void* _obj, void* p0, void* p1, void* p2) {
    ((QPainter*)_obj)->drawTiledPixmap(*(const QRect*)p0, *(const QPixmap*)p1, *(const QPoint*)p2);
}

// 18160
void qteQPainter_drawPixmap_qrectf_qpixmap_qrectf(void* _obj, void* targetRect, void* pixmap, void* sourceRect) {
    ((QPainter*)_obj)->drawPixmap(*(const QRectF*)targetRect, *(const QPixmap*)pixmap, *(const QRectF*)sourceRect);
}

// 18161
void qteQPainter_drawPixmap_qrect_qpixmap_qrect(void* _obj, void* targetRect, void* pixmap, void* sourceRect) {
    ((QPainter*)_obj)->drawPixmap(*(const QRect*)targetRect, *(const QPixmap*)pixmap, *(const QRect*)sourceRect);
}

// 18162
void qteQPainter_drawPixmap_int_int_int_int_qpixmap_int_int_int_int(void* _obj, int x, int y, int w, int h, void* pm, int sx, int sy, int sw, int sh) {
    ((QPainter*)_obj)->drawPixmap(x, y, w, h, *(const QPixmap*)pm, sx, sy, sw, sh);
}

// 18163
void qteQPainter_drawPixmap_int_int_qpixmap_int_int_int_int(void* _obj, int x, int y, void* pm, int sx, int sy, int sw, int sh) {
    ((QPainter*)_obj)->drawPixmap(x, y, *(const QPixmap*)pm, sx, sy, sw, sh);
}

// 18164
void qteQPainter_drawPixmap_qpointf_qpixmap_qrectf(void* _obj, void* p, void* pm, void* sr) {
    ((QPainter*)_obj)->drawPixmap(*(const QPointF*)p, *(const QPixmap*)pm, *(const QRectF*)sr);
}

// 18165
void qteQPainter_drawPixmap_qpoint_qpixmap_qrect(void* _obj, void* p, void* pm, void* sr) {
    ((QPainter*)_obj)->drawPixmap(*(const QPoint*)p, *(const QPixmap*)pm, *(const QRect*)sr);
}

// 18166
void qteQPainter_drawPixmap_qpointf_qpixmap(void* _obj, void* p, void* pm) {
    ((QPainter*)_obj)->drawPixmap(*(const QPointF*)p, *(const QPixmap*)pm);
}

// 18167
void qteQPainter_drawPixmap_qpoint_qpixmap(void* _obj, void* p, void* pm) {
    ((QPainter*)_obj)->drawPixmap(*(const QPoint*)p, *(const QPixmap*)pm);
}

// 18168
void qteQPainter_drawPixmap_int_int_qpixmap(void* _obj, int x, int y, void* pm) {
    ((QPainter*)_obj)->drawPixmap(x, y, *(const QPixmap*)pm);
}

// 18169
void qteQPainter_drawPixmap_qrect_qpixmap(void* _obj, void* r, void* pm) {
    ((QPainter*)_obj)->drawPixmap(*(const QRect*)r, *(const QPixmap*)pm);
}

// 18170
void qteQPainter_drawPixmap_int_int_int_int_qpixmap(void* _obj, int x, int y, int w, int h, void* pm) {
    ((QPainter*)_obj)->drawPixmap(x, y, w, h, *(const QPixmap*)pm);
}

// 18171
void qteQPainter_drawImage_qrectf_qimage_qrectf_qt_imageconversionflags(void* _obj, void* targetRect, void* image, void* sourceRect, int flags) {
    ((QPainter*)_obj)->drawImage(*(const QRectF*)targetRect, *(const QImage*)image, *(const QRectF*)sourceRect, (Qt::ImageConversionFlags)flags);
}

// 18172
void qteQPainter_drawImage_qrect_qimage_qrect_qt_imageconversionflags(void* _obj, void* targetRect, void* image, void* sourceRect, int flags) {
    ((QPainter*)_obj)->drawImage(*(const QRect*)targetRect, *(const QImage*)image, *(const QRect*)sourceRect, (Qt::ImageConversionFlags)flags);
}

// 18173
void qteQPainter_drawImage_qpointf_qimage_qrectf_qt_imageconversionflags(void* _obj, void* p, void* image, void* sr, int flags) {
    ((QPainter*)_obj)->drawImage(*(const QPointF*)p, *(const QImage*)image, *(const QRectF*)sr, (Qt::ImageConversionFlags)flags);
}

// 18174
void qteQPainter_drawImage_qpoint_qimage_qrect_qt_imageconversionflags(void* _obj, void* p, void* image, void* sr, int flags) {
    ((QPainter*)_obj)->drawImage(*(const QPoint*)p, *(const QImage*)image, *(const QRect*)sr, (Qt::ImageConversionFlags)flags);
}

// 18175
void qteQPainter_drawImage_qrectf_qimage(void* _obj, void* r, void* image) {
    ((QPainter*)_obj)->drawImage(*(const QRectF*)r, *(const QImage*)image);
}

// 18176
void qteQPainter_drawImage_qrect_qimage(void* _obj, void* r, void* image) {
    ((QPainter*)_obj)->drawImage(*(const QRect*)r, *(const QImage*)image);
}

// 18177
void qteQPainter_drawImage_qpointf_qimage(void* _obj, void* p, void* image) {
    ((QPainter*)_obj)->drawImage(*(const QPointF*)p, *(const QImage*)image);
}

// 18178
void qteQPainter_drawImage_qpoint_qimage(void* _obj, void* p, void* image) {
    ((QPainter*)_obj)->drawImage(*(const QPoint*)p, *(const QImage*)image);
}

// 18179
void qteQPainter_drawImage_int_int_qimage_int_int_int_int_qt_imageconversionflags(void* _obj, int x, int y, void* image, int sx, int sy, int sw, int sh, int flags) {
    ((QPainter*)_obj)->drawImage(x, y, *(const QImage*)image, sx, sy, sw, sh, (Qt::ImageConversionFlags)flags);
}

// 18180
void qteQPainter_drawText_qpointf_qstring(void* _obj, void* p, const wchar_t* s, int s_len) {
    ((QPainter*)_obj)->drawText(*(const QPointF*)p, QString::fromWCharArray(s, s_len));
}

// 18181
void qteQPainter_drawText_qpoint_qstring(void* _obj, void* p, const wchar_t* s, int s_len) {
    ((QPainter*)_obj)->drawText(*(const QPoint*)p, QString::fromWCharArray(s, s_len));
}

// 18182
void qteQPainter_drawText_int_int_qstring(void* _obj, int x, int y, const wchar_t* s, int s_len) {
    ((QPainter*)_obj)->drawText(x, y, QString::fromWCharArray(s, s_len));
}

// 18183
void qteQPainter_drawText_qpointf_qstring_int_int(void* _obj, void* p, const wchar_t* str, int str_len, int tf, int justificationPadding) {
    ((QPainter*)_obj)->drawText(*(const QPointF*)p, QString::fromWCharArray(str, str_len), tf, justificationPadding);
}

// 18184
void qteQPainter_drawText_qrectf_int_qstring_qrectf(void* _obj, void* r, int flags, const wchar_t* text, int text_len, void* br) {
    ((QPainter*)_obj)->drawText(*(const QRectF*)r, flags, QString::fromWCharArray(text, text_len), (QRectF*)br);
}

// 18185
void qteQPainter_drawText_qrect_int_qstring_qrect(void* _obj, void* r, int flags, const wchar_t* text, int text_len, void* br) {
    ((QPainter*)_obj)->drawText(*(const QRect*)r, flags, QString::fromWCharArray(text, text_len), (QRect*)br);
}

// 18186
void qteQPainter_drawText_int_int_int_int_int_qstring_qrect(void* _obj, int x, int y, int w, int h, int flags, const wchar_t* text, int text_len, void* br) {
    ((QPainter*)_obj)->drawText(x, y, w, h, flags, QString::fromWCharArray(text, text_len), (QRect*)br);
}

// 18187
void qteQPainter_drawText_qrectf_qstring(void* _obj, void* r, const wchar_t* text, int text_len) {
    ((QPainter*)_obj)->drawText(*(const QRectF*)r, QString::fromWCharArray(text, text_len));
}

// 18188
void* qteQPainter_boundingRect_qrectf_int_qstring(void* _obj, void* rect, int flags, const wchar_t* text, int text_len) {
    return new QRectF(((QPainter*)_obj)->boundingRect(*(const QRectF*)rect, flags, QString::fromWCharArray(text, text_len)));
}

// 18189
void* qteQPainter_boundingRect_qrect_int_qstring(void* _obj, void* rect, int flags, const wchar_t* text, int text_len) {
    return new QRect(((QPainter*)_obj)->boundingRect(*(const QRect*)rect, flags, QString::fromWCharArray(text, text_len)));
}

// 18190
void* qteQPainter_boundingRect_int_int_int_int_int_qstring(void* _obj, int x, int y, int w, int h, int flags, const wchar_t* text, int text_len) {
    return new QRect(((QPainter*)_obj)->boundingRect(x, y, w, h, flags, QString::fromWCharArray(text, text_len)));
}

// 18191
void* qteQPainter_boundingRect_qrectf_qstring(void* _obj, void* rect, const wchar_t* text, int text_len) {
    return new QRectF(((QPainter*)_obj)->boundingRect(*(const QRectF*)rect, QString::fromWCharArray(text, text_len)));
}

// 18192
void qteQPainter_fillRect_qrectf_qcolor(void* _obj, void* p0, void* color) {
    ((QPainter*)_obj)->fillRect(*(const QRectF*)p0, *(const QColor*)color);
}

// 18194
void qteQPainter_fillRect_qrect_qcolor(void* _obj, void* p0, void* color) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)p0, *(const QColor*)color);
}

// 18196
void qteQPainter_fillRect_qrect_qt_globalcolor(void* _obj, void* r, int c) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)r, (Qt::GlobalColor)c);
}

// 18197
void qteQPainter_fillRect_qrectf_qt_globalcolor(void* _obj, void* r, int c) {
    ((QPainter*)_obj)->fillRect(*(const QRectF*)r, (Qt::GlobalColor)c);
}

// 18198
void qteQPainter_fillRect_int_int_int_int_qt_brushstyle(void* _obj, int x, int y, int w, int h, int style) {
    ((QPainter*)_obj)->fillRect(x, y, w, h, (Qt::BrushStyle)style);
}

// 18199
void qteQPainter_fillRect_qrect_qt_brushstyle(void* _obj, void* r, int style) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)r, (Qt::BrushStyle)style);
}

// 18239
void qteQPainter_fillRect_qrectf_qt_brushstyle(void* _obj, void* r, int style) {
    ((QPainter*)_obj)->fillRect(*(const QRectF*)r, (Qt::BrushStyle)style);
}

// 18240
void qteQPainter_fillRect_int_int_int_int_qgradient_preset(void* _obj, int x, int y, int w, int h, int preset) {
    ((QPainter*)_obj)->fillRect(x, y, w, h, (QGradient::Preset)preset);
}

// 18241
void qteQPainter_fillRect_qrect_qgradient_preset(void* _obj, void* r, int preset) {
    ((QPainter*)_obj)->fillRect(*(const QRect*)r, (QGradient::Preset)preset);
}

// 18242
void qteQPainter_fillRect_qrectf_qgradient_preset(void* _obj, void* r, int preset) {
    ((QPainter*)_obj)->fillRect(*(const QRectF*)r, (QGradient::Preset)preset);
}

// 18243
void qteQPainter_eraseRect_qrectf(void* _obj, void* p0) {
    ((QPainter*)_obj)->eraseRect(*(const QRectF*)p0);
}

// 18245
void qteQPainter_eraseRect_qrect(void* _obj, void* p0) {
    ((QPainter*)_obj)->eraseRect(*(const QRect*)p0);
}

} // extern "C"
