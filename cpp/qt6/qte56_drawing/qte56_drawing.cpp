#include "qte56_drawing.h"
#include <QPen>
#include <QBrush>
#include <QPalette>
#include <QFontMetrics>
#include <QPainter>
#include <QWidget>
#include <QFont>
#include <QColor>
#include <QString>

// ── QPen: 19748–19760 ─────────────────────────────────────────────────────────

void* qteQPen_create(void* /*unused*/) {
    return new QPen();
}

void qteQPen_delete(void* p) {
    delete (QPen*)p;
}

void* qteQPen_create_rgba(void* /*unused*/, unsigned int rgba, int w, int style) {
    return new QPen(QColor::fromRgba((QRgb)rgba), (qreal)w, (Qt::PenStyle)style);
}

void qteQPen_setColor(void* p, unsigned int rgba) {
    ((QPen*)p)->setColor(QColor::fromRgba((QRgb)rgba));
}

unsigned int qteQPen_color(void* p) {
    return (unsigned int)((QPen*)p)->color().rgba();
}

void qteQPen_setWidth(void* p, int w) {
    ((QPen*)p)->setWidth(w);
}

int qteQPen_width(void* p) {
    return ((QPen*)p)->width();
}

void qteQPen_setStyle(void* p, int s) {
    ((QPen*)p)->setStyle((Qt::PenStyle)s);
}

int qteQPen_style(void* p) {
    return (int)((QPen*)p)->style();
}

void qteQPen_setCapStyle(void* p, int s) {
    ((QPen*)p)->setCapStyle((Qt::PenCapStyle)s);
}

int qteQPen_capStyle(void* p) {
    return (int)((QPen*)p)->capStyle();
}

void qteQPen_setJoinStyle(void* p, int s) {
    ((QPen*)p)->setJoinStyle((Qt::PenJoinStyle)s);
}

int qteQPen_joinStyle(void* p) {
    return (int)((QPen*)p)->joinStyle();
}

// ── QBrush: 19761–19767 ───────────────────────────────────────────────────────

void* qteQBrush_create(void* /*unused*/) {
    return new QBrush();
}

void qteQBrush_delete(void* b) {
    delete (QBrush*)b;
}

void* qteQBrush_create_rgba(void* /*unused*/, unsigned int rgba, int style) {
    return new QBrush(QColor::fromRgba((QRgb)rgba), (Qt::BrushStyle)style);
}

void qteQBrush_setColor(void* b, unsigned int rgba) {
    ((QBrush*)b)->setColor(QColor::fromRgba((QRgb)rgba));
}

unsigned int qteQBrush_color(void* b) {
    return (unsigned int)((QBrush*)b)->color().rgba();
}

void qteQBrush_setStyle(void* b, int s) {
    ((QBrush*)b)->setStyle((Qt::BrushStyle)s);
}

int qteQBrush_style(void* b) {
    return (int)((QBrush*)b)->style();
}

// ── QPalette: 19768–19775 ─────────────────────────────────────────────────────

void* qteQPalette_create(void* /*unused*/) {
    return new QPalette();
}

void qteQPalette_delete(void* p) {
    delete (QPalette*)p;
}

unsigned int qteQPalette_color(void* p, int role) {
    return (unsigned int)((QPalette*)p)->color((QPalette::ColorRole)role).rgba();
}

void qteQPalette_setColor(void* p, int role, unsigned int rgba) {
    ((QPalette*)p)->setColor((QPalette::ColorRole)role, QColor::fromRgba((QRgb)rgba));
}

unsigned int qteQPalette_colorGroup(void* p, int grp, int role) {
    return (unsigned int)((QPalette*)p)->color(
        (QPalette::ColorGroup)grp, (QPalette::ColorRole)role).rgba();
}

void qteQPalette_setColorGroup(void* p, int grp, int role, unsigned int rgba) {
    ((QPalette*)p)->setColor(
        (QPalette::ColorGroup)grp, (QPalette::ColorRole)role,
        QColor::fromRgba((QRgb)rgba));
}

void qteQPalette_setWidgetPalette(void* widget, void* pal) {
    ((QWidget*)widget)->setPalette(*(const QPalette*)pal);
}

void* qteQPalette_getWidgetPalette(void* widget) {
    return new QPalette(((QWidget*)widget)->palette());
}

// ── QFontMetrics: 19776–19785 ─────────────────────────────────────────────────

void* qteQFontMetrics_create(void* font) {
    return new QFontMetrics(*(const QFont*)font);
}

void qteQFontMetrics_delete(void* fm) {
    delete (QFontMetrics*)fm;
}

int qteQFontMetrics_horizontalAdvance(void* fm, void* text) {
    return ((QFontMetrics*)fm)->horizontalAdvance(*(QString*)text);
}

int qteQFontMetrics_height(void* fm) {
    return ((QFontMetrics*)fm)->height();
}

int qteQFontMetrics_ascent(void* fm) {
    return ((QFontMetrics*)fm)->ascent();
}

int qteQFontMetrics_descent(void* fm) {
    return ((QFontMetrics*)fm)->descent();
}

int qteQFontMetrics_leading(void* fm) {
    return ((QFontMetrics*)fm)->leading();
}

int qteQFontMetrics_lineSpacing(void* fm) {
    return ((QFontMetrics*)fm)->lineSpacing();
}

int qteQFontMetrics_averageCharWidth(void* fm) {
    return ((QFontMetrics*)fm)->averageCharWidth();
}

int qteQFontMetrics_maxWidth(void* fm) {
    return ((QFontMetrics*)fm)->maxWidth();
}

// ── QPainter extensions: 19786–19787 ─────────────────────────────────────────

void qteQDrawing_painter_setPen(void* painter, void* pen) {
    ((QPainter*)painter)->setPen(*(const QPen*)pen);
}

void qteQDrawing_painter_setBrush(void* painter, void* brush) {
    ((QPainter*)painter)->setBrush(*(const QBrush*)brush);
}
