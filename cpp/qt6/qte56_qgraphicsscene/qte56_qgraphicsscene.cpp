#define QTE56_QGRAPHICSSCENE_BUILD
#include "qte56_qgraphicsscene.h"
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsPixmapItem>
#include <QGraphicsTextItem>
#include <QGraphicsRectItem>
#include <QGraphicsEllipseItem>
#include <QPixmap>
#include <QFont>
#include <QColor>
#include <QBrush>
#include <QPen>
#include <QString>
#include <QCoreApplication>

extern "C" {

// ── QGraphicsScene ─────────────────────────────────────────────────────────
void* qteQGraphicsScene_create(void* parent) {
    return new QGraphicsScene((QObject*)parent);
}

void qteQGraphicsScene_delete(void* w) {
    delete (QGraphicsScene*)w;
}

void qteQGraphicsScene_setSceneRect(void* w, double x, double y, double w_, double h) {
    ((QGraphicsScene*)w)->setSceneRect(x, y, w_, h);
}

void qteQGraphicsScene_addItem(void* w, void* item) {
    ((QGraphicsScene*)w)->addItem((QGraphicsItem*)item);
}

void qteQGraphicsScene_addTextItem(void* w, void* item) {
    ((QGraphicsScene*)w)->addItem((QGraphicsTextItem*)item);
}

void qteQGraphicsScene_addRectItem(void* w, void* item) {
    ((QGraphicsScene*)w)->addItem((QGraphicsRectItem*)item);
}

void qteQGraphicsScene_addEllipseItem(void* w, void* item) {
    ((QGraphicsScene*)w)->addItem((QGraphicsEllipseItem*)item);
}

void qteQGraphicsScene_removeItem(void* w, void* item) {
    ((QGraphicsScene*)w)->removeItem((QGraphicsItem*)item);
}

void qteQGraphicsScene_removeTextItem(void* w, void* item) {
    ((QGraphicsScene*)w)->removeItem((QGraphicsTextItem*)item);
}

void qteQGraphicsScene_removeRectItem(void* w, void* item) {
    ((QGraphicsScene*)w)->removeItem((QGraphicsRectItem*)item);
}

void qteQGraphicsScene_removeEllipseItem(void* w, void* item) {
    ((QGraphicsScene*)w)->removeItem((QGraphicsEllipseItem*)item);
}

void qteQGraphicsScene_clear(void* w) {
    ((QGraphicsScene*)w)->clear();
}

void qteQGraphicsScene_update(void* w) {
    ((QGraphicsScene*)w)->update();
}

// ── QGraphicsView ──────────────────────────────────────────────────────────
void* qteQGraphicsView_create(void* parent) {
    return new QGraphicsView((QWidget*)parent);
}

void qteQGraphicsView_delete(void* w) {
    delete (QGraphicsView*)w;
}

void qteQGraphicsView_setScene(void* w, void* scene) {
    ((QGraphicsView*)w)->setScene((QGraphicsScene*)scene);
}

void qteQGraphicsView_setRenderHint(void* w, int hint, int on) {
    ((QGraphicsView*)w)->setRenderHint((QPainter::RenderHint)hint, on != 0);
}

void qteQGraphicsView_setViewportUpdateMode(void* w, int mode) {
    ((QGraphicsView*)w)->setViewportUpdateMode((QGraphicsView::ViewportUpdateMode)mode);
}

void qteQGraphicsView_setTransformationAnchor(void* w, int anchor) {
    ((QGraphicsView*)w)->setTransformationAnchor((QGraphicsView::ViewportAnchor)anchor);
}

void qteQGraphicsView_setResizeAnchor(void* w, int anchor) {
    ((QGraphicsView*)w)->setResizeAnchor((QGraphicsView::ViewportAnchor)anchor);
}

void qteQGraphicsView_setInteractive(void* w, int allowed) {
    ((QGraphicsView*)w)->setInteractive(allowed != 0);
}

void qteQGraphicsView_fitInView(void* w, double x, double y, double w_, double h, int aspectRatioMode) {
    ((QGraphicsView*)w)->fitInView(x, y, w_, h, (Qt::AspectRatioMode)aspectRatioMode);
}

void qteQGraphicsView_scale(void* w, double sx, double sy) {
    ((QGraphicsView*)w)->scale(sx, sy);
}

void qteQGraphicsView_rotate(void* w, double angle) {
    ((QGraphicsView*)w)->rotate(angle);
}

void qteQGraphicsView_resize(void* w, int width, int height) {
    ((QGraphicsView*)w)->resize(width, height);
}

void qteQGraphicsView_show(void* w) {
    ((QGraphicsView*)w)->show();
}

void qteQGraphicsView_hide(void* w) {
    ((QGraphicsView*)w)->hide();
}

// ── QGraphicsPixmapItem ────────────────────────────────────────────────────
void* qteQGraphicsPixmapItem_create(void* pixmap) {
    if (pixmap) {
        return new QGraphicsPixmapItem(*(QPixmap*)pixmap);
    } else {
        return new QGraphicsPixmapItem((QGraphicsItem*)nullptr);
    }
}

void qteQGraphicsPixmapItem_delete(void* w) {
    delete (QGraphicsPixmapItem*)w;
}

void qteQGraphicsPixmapItem_setPixmap(void* w, void* pixmap) {
    ((QGraphicsPixmapItem*)w)->setPixmap(*(QPixmap*)pixmap);
}

void qteQGraphicsPixmapItem_setPos(void* w, double x, double y) {
    ((QGraphicsPixmapItem*)w)->setPos(x, y);
}

void qteQGraphicsPixmapItem_setScale(void* w, double scale) {
    ((QGraphicsPixmapItem*)w)->setScale(scale);
}

void qteQGraphicsPixmapItem_setRotation(void* w, double angle) {
    ((QGraphicsPixmapItem*)w)->setRotation(angle);
}

void qteQGraphicsPixmapItem_setZValue(void* w, double z) {
    ((QGraphicsPixmapItem*)w)->setZValue(z);
}

void qteQGraphicsPixmapItem_setOffset(void* w, double x, double y) {
    ((QGraphicsPixmapItem*)w)->setOffset(x, y);
}

void qteQGraphicsPixmapItem_setTransformationMode(void* w, int mode) {
    ((QGraphicsPixmapItem*)w)->setTransformationMode((Qt::TransformationMode)mode);
}

void qteQGraphicsPixmapItem_setOpacity(void* w, double opacity) {
    ((QGraphicsPixmapItem*)w)->setOpacity(opacity);
}

void qteQGraphicsPixmapItem_show(void* w) {
    ((QGraphicsPixmapItem*)w)->show();
}

void qteQGraphicsPixmapItem_hide(void* w) {
    ((QGraphicsPixmapItem*)w)->hide();
}

// ── QGraphicsTextItem ──────────────────────────────────────────────────────
void* qteQGraphicsTextItem_create(void* parent) {
    return new QGraphicsTextItem((QGraphicsItem*)parent);
}

void qteQGraphicsTextItem_delete(void* w) {
    delete (QGraphicsTextItem*)w;
}

void qteQGraphicsTextItem_setPlainText(void* w, const char* text) {
    ((QGraphicsTextItem*)w)->setPlainText(QString::fromUtf8(text));
}

void qteQGraphicsTextItem_setHtml(void* w, const char* html) {
    ((QGraphicsTextItem*)w)->setHtml(QString::fromUtf8(html));
}

void qteQGraphicsTextItem_setPos(void* w, double x, double y) {
    ((QGraphicsTextItem*)w)->setPos(x, y);
}

void qteQGraphicsTextItem_setZValue(void* w, double z) {
    ((QGraphicsTextItem*)w)->setZValue(z);
}

void qteQGraphicsTextItem_setDefaultTextColor(void* w, int r, int g, int b, int a) {
    ((QGraphicsTextItem*)w)->setDefaultTextColor(QColor(r, g, b, a));
}

void qteQGraphicsTextItem_setFont(void* w, void* font) {
    ((QGraphicsTextItem*)w)->setFont(*(QFont*)font);
}

void qteQGraphicsTextItem_setScale(void* w, double scale) {
    ((QGraphicsTextItem*)w)->setScale(scale);
}

void qteQGraphicsTextItem_setRotation(void* w, double angle) {
    ((QGraphicsTextItem*)w)->setRotation(angle);
}

void qteQGraphicsTextItem_setOpacity(void* w, double opacity) {
    ((QGraphicsTextItem*)w)->setOpacity(opacity);
}

// ── QGraphicsRectItem ──────────────────────────────────────────────────────
void* qteQGraphicsRectItem_create(double x, double y, double w_, double h, void* parent) {
    return new QGraphicsRectItem(x, y, w_, h, (QGraphicsItem*)parent);
}

void qteQGraphicsRectItem_delete(void* w) {
    delete (QGraphicsRectItem*)w;
}

void qteQGraphicsRectItem_setRect(void* w, double x, double y, double w_, double h) {
    ((QGraphicsRectItem*)w)->setRect(x, y, w_, h);
}

void qteQGraphicsRectItem_setBrush(void* w, int r, int g, int b, int a) {
    ((QGraphicsRectItem*)w)->setBrush(QBrush(QColor(r, g, b, a)));
}

void qteQGraphicsRectItem_setPen(void* w, int r, int g, int b, int a, int width) {
    ((QGraphicsRectItem*)w)->setPen(QPen(QColor(r, g, b, a), width));
}

void qteQGraphicsRectItem_setPos(void* w, double x, double y) {
    ((QGraphicsRectItem*)w)->setPos(x, y);
}

void qteQGraphicsRectItem_setZValue(void* w, double z) {
    ((QGraphicsRectItem*)w)->setZValue(z);
}

void qteQGraphicsRectItem_setOpacity(void* w, double opacity) {
    ((QGraphicsRectItem*)w)->setOpacity(opacity);
}

// ── QGraphicsEllipseItem ───────────────────────────────────────────────────
void* qteQGraphicsEllipseItem_create(double x, double y, double w_, double h, void* parent) {
    return new QGraphicsEllipseItem(x, y, w_, h, (QGraphicsItem*)parent);
}

void qteQGraphicsEllipseItem_delete(void* w) {
    delete (QGraphicsEllipseItem*)w;
}

void qteQGraphicsEllipseItem_setRect(void* w, double x, double y, double w_, double h) {
    ((QGraphicsEllipseItem*)w)->setRect(x, y, w_, h);
}

void qteQGraphicsEllipseItem_setBrush(void* w, int r, int g, int b, int a) {
    ((QGraphicsEllipseItem*)w)->setBrush(QBrush(QColor(r, g, b, a)));
}

void qteQGraphicsEllipseItem_setPen(void* w, int r, int g, int b, int a, int width) {
    ((QGraphicsEllipseItem*)w)->setPen(QPen(QColor(r, g, b, a), width));
}

void qteQGraphicsEllipseItem_setPos(void* w, double x, double y) {
    ((QGraphicsEllipseItem*)w)->setPos(x, y);
}

void qteQGraphicsEllipseItem_setZValue(void* w, double z) {
    ((QGraphicsEllipseItem*)w)->setZValue(z);
}

void qteQGraphicsEllipseItem_setOpacity(void* w, double opacity) {
    ((QGraphicsEllipseItem*)w)->setOpacity(opacity);
}

} // extern "C"
