#pragma once

#ifdef _WIN32
  #ifdef QTE56_QGRAPHICSSCENE_BUILD
    #define QGRAPHICSSCENE_API __declspec(dllexport)
  #else
    #define QGRAPHICSSCENE_API __declspec(dllimport)
  #endif
#else
  #define QGRAPHICSSCENE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QGraphicsScene ─────────────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsScene_create(void* parent);
QGRAPHICSSCENE_API void  qteQGraphicsScene_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsScene_setSceneRect(void* w, double x, double y, double w_, double h);
QGRAPHICSSCENE_API void  qteQGraphicsScene_addItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_addTextItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_addRectItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_addEllipseItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_removeItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_removeTextItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_removeRectItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_removeEllipseItem(void* w, void* item);
QGRAPHICSSCENE_API void  qteQGraphicsScene_clear(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsScene_update(void* w);

// ── QGraphicsView ──────────────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsView_create(void* parent);
QGRAPHICSSCENE_API void  qteQGraphicsView_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsView_setScene(void* w, void* scene);
QGRAPHICSSCENE_API void  qteQGraphicsView_setRenderHint(void* w, int hint, int on);
QGRAPHICSSCENE_API void  qteQGraphicsView_setViewportUpdateMode(void* w, int mode);
QGRAPHICSSCENE_API void  qteQGraphicsView_setTransformationAnchor(void* w, int anchor);
QGRAPHICSSCENE_API void  qteQGraphicsView_setResizeAnchor(void* w, int anchor);
QGRAPHICSSCENE_API void  qteQGraphicsView_setInteractive(void* w, int allowed);
QGRAPHICSSCENE_API void  qteQGraphicsView_fitInView(void* w, double x, double y, double w_, double h, int aspectRatioMode);
QGRAPHICSSCENE_API void  qteQGraphicsView_scale(void* w, double sx, double sy);
QGRAPHICSSCENE_API void  qteQGraphicsView_rotate(void* w, double angle);
QGRAPHICSSCENE_API void  qteQGraphicsView_resize(void* w, int width, int height);
QGRAPHICSSCENE_API void  qteQGraphicsView_show(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsView_hide(void* w);

// ── QGraphicsPixmapItem ────────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsPixmapItem_create(void* pixmap);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setPixmap(void* w, void* pixmap);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setPos(void* w, double x, double y);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setScale(void* w, double scale);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setRotation(void* w, double angle);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setZValue(void* w, double z);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setOffset(void* w, double x, double y);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setTransformationMode(void* w, int mode);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_setOpacity(void* w, double opacity);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_show(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsPixmapItem_hide(void* w);

// ── QGraphicsTextItem ──────────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsTextItem_create(void* parent);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setPlainText(void* w, const char* text);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setHtml(void* w, const char* html);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setPos(void* w, double x, double y);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setZValue(void* w, double z);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setDefaultTextColor(void* w, int r, int g, int b, int a);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setFont(void* w, void* font);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setScale(void* w, double scale);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setRotation(void* w, double angle);
QGRAPHICSSCENE_API void  qteQGraphicsTextItem_setOpacity(void* w, double opacity);

// ── QGraphicsRectItem ──────────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsRectItem_create(double x, double y, double w_, double h, void* parent);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setRect(void* w, double x, double y, double w_, double h);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setBrush(void* w, int r, int g, int b, int a);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setPen(void* w, int r, int g, int b, int a, int width);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setPos(void* w, double x, double y);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setZValue(void* w, double z);
QGRAPHICSSCENE_API void  qteQGraphicsRectItem_setOpacity(void* w, double opacity);

// ── QGraphicsEllipseItem ───────────────────────────────────────────────────
QGRAPHICSSCENE_API void* qteQGraphicsEllipseItem_create(double x, double y, double w_, double h, void* parent);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_delete(void* w);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setRect(void* w, double x, double y, double w_, double h);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setBrush(void* w, int r, int g, int b, int a);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setPen(void* w, int r, int g, int b, int a, int width);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setPos(void* w, double x, double y);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setZValue(void* w, double z);
QGRAPHICSSCENE_API void  qteQGraphicsEllipseItem_setOpacity(void* w, double opacity);

} // extern "C"
