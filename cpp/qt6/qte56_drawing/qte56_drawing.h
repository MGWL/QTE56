#ifndef QTE56_DRAWING_H
#define QTE56_DRAWING_H

#ifdef _WIN32
#  ifdef QTE56_DRAWING_BUILD
#    define QTE56_DRAWING_API __declspec(dllexport)
#  else
#    define QTE56_DRAWING_API __declspec(dllimport)
#  endif
#else
#  define QTE56_DRAWING_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QPen: 19748–19760 ─────────────────────────────────────────────────────────
QTE56_DRAWING_API void*        qteQPen_create(void*);
QTE56_DRAWING_API void         qteQPen_delete(void*);
QTE56_DRAWING_API void*        qteQPen_create_rgba(void*, unsigned int, int, int);
QTE56_DRAWING_API void         qteQPen_setColor(void*, unsigned int);
QTE56_DRAWING_API unsigned int qteQPen_color(void*);
QTE56_DRAWING_API void         qteQPen_setWidth(void*, int);
QTE56_DRAWING_API int          qteQPen_width(void*);
QTE56_DRAWING_API void         qteQPen_setStyle(void*, int);
QTE56_DRAWING_API int          qteQPen_style(void*);
QTE56_DRAWING_API void         qteQPen_setCapStyle(void*, int);
QTE56_DRAWING_API int          qteQPen_capStyle(void*);
QTE56_DRAWING_API void         qteQPen_setJoinStyle(void*, int);
QTE56_DRAWING_API int          qteQPen_joinStyle(void*);

// ── QBrush: 19761–19767 ───────────────────────────────────────────────────────
QTE56_DRAWING_API void*        qteQBrush_create(void*);
QTE56_DRAWING_API void         qteQBrush_delete(void*);
QTE56_DRAWING_API void*        qteQBrush_create_rgba(void*, unsigned int, int);
QTE56_DRAWING_API void         qteQBrush_setColor(void*, unsigned int);
QTE56_DRAWING_API unsigned int qteQBrush_color(void*);
QTE56_DRAWING_API void         qteQBrush_setStyle(void*, int);
QTE56_DRAWING_API int          qteQBrush_style(void*);

// ── QPalette: 19768–19775 ─────────────────────────────────────────────────────
QTE56_DRAWING_API void*        qteQPalette_create(void*);
QTE56_DRAWING_API void         qteQPalette_delete(void*);
QTE56_DRAWING_API unsigned int qteQPalette_color(void*, int);
QTE56_DRAWING_API void         qteQPalette_setColor(void*, int, unsigned int);
QTE56_DRAWING_API unsigned int qteQPalette_colorGroup(void*, int, int);
QTE56_DRAWING_API void         qteQPalette_setColorGroup(void*, int, int, unsigned int);
QTE56_DRAWING_API void         qteQPalette_setWidgetPalette(void*, void*);
QTE56_DRAWING_API void*        qteQPalette_getWidgetPalette(void*);

// ── QFontMetrics: 19776–19785 ─────────────────────────────────────────────────
QTE56_DRAWING_API void* qteQFontMetrics_create(void*);
QTE56_DRAWING_API void  qteQFontMetrics_delete(void*);
QTE56_DRAWING_API int   qteQFontMetrics_horizontalAdvance(void*, void*);
QTE56_DRAWING_API int   qteQFontMetrics_height(void*);
QTE56_DRAWING_API int   qteQFontMetrics_ascent(void*);
QTE56_DRAWING_API int   qteQFontMetrics_descent(void*);
QTE56_DRAWING_API int   qteQFontMetrics_leading(void*);
QTE56_DRAWING_API int   qteQFontMetrics_lineSpacing(void*);
QTE56_DRAWING_API int   qteQFontMetrics_averageCharWidth(void*);
QTE56_DRAWING_API int   qteQFontMetrics_maxWidth(void*);

// ── QPainter extensions: 19786–19787 ─────────────────────────────────────────
QTE56_DRAWING_API void  qteQDrawing_painter_setPen(void*, void*);
QTE56_DRAWING_API void  qteQDrawing_painter_setBrush(void*, void*);

} // extern "C"

#endif // QTE56_DRAWING_H
