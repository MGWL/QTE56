#ifndef QTE56_QPAINTER_BUILD
#define QTE56_QPAINTER_BUILD
#endif
#include "qte56_qpainter.h"
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
    // initFrom() removed in Qt6 — no-op
    (void)_obj; (void)device;
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
    ((QPainter*)_obj)->resetTransform();
}

void qteQPainter_resetTransform(void* _obj) {
    ((QPainter*)_obj)->resetTransform();
}

void qteQPainter_setMatrixEnabled(void* _obj, int enabled) {
    ((QPainter*)_obj)->setWorldMatrixEnabled((enabled != 0));
}

int qteQPainter_matrixEnabled(void* _obj) {
    return ((QPainter*)_obj)->worldMatrixEnabled() ? 1 : 0;
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
    ((QPainter*)_obj)->drawRoundedRect(x, y, w, h, xr, yr);
}

void qteQPainter_drawRoundRect_pii(void* _obj, void* r, int xround, int yround) {
    ((QPainter*)_obj)->drawRoundedRect(*(const QRect*)r, xround, yround);
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
    // setRedirected() removed in Qt6 — no-op
    (void)_obj; (void)device; (void)replacement; (void)offset;
}

void* qteQPainter_redirected(void* _obj, void* device, void* offset) {
    // redirected() removed in Qt6 — return nullptr
    (void)_obj; (void)device; (void)offset;
    return nullptr;
}

void qteQPainter_restoreRedirected(void* _obj, void* device) {
    // restoreRedirected() removed in Qt6 — no-op
    (void)_obj; (void)device;
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

} // extern "C"
