/**
 * gen_qgraphicsscene.d — QGraphicsScene / QGraphicsView / QGraphicsPixmapItem
 * Module: QGraphicsScene  |  DLL: qte56_qgraphicsscene.dll
 */
module gen_qgraphicsscene;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_d, t_v__qp_d_d, t_v__qp_d_d_d_d, t_v__qp_qp, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qobject : QObject;
import gen_qwidget : QWidget;

// New aliases
mixin(generateAlias("v__qp_d_d_d_d"));
mixin(generateAlias("v__qp_d_d_d_d_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_d_d"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i"));
mixin(generateAlias("qp__d_d_d_d_qp"));

// ====================================================================
// Load function addresses
// ====================================================================

void loadQGraphicsScene() {
    // QGraphicsScene
    mixin(generateFunQt(24000, "qteQGraphicsScene_create", "QGraphicsScene"));
    mixin(generateFunQt(24001, "qteQGraphicsScene_delete", "QGraphicsScene"));
    mixin(generateFunQt(24002, "qteQGraphicsScene_setSceneRect", "QGraphicsScene"));
    mixin(generateFunQt(24003, "qteQGraphicsScene_addItem", "QGraphicsScene"));
    mixin(generateFunQt(24007, "qteQGraphicsScene_addTextItem", "QGraphicsScene"));
    mixin(generateFunQt(24008, "qteQGraphicsScene_addRectItem", "QGraphicsScene"));
    mixin(generateFunQt(24009, "qteQGraphicsScene_addEllipseItem", "QGraphicsScene"));
    mixin(generateFunQt(24004, "qteQGraphicsScene_removeItem", "QGraphicsScene"));
    mixin(generateFunQt(24035, "qteQGraphicsScene_removeTextItem", "QGraphicsScene"));
    mixin(generateFunQt(24036, "qteQGraphicsScene_removeRectItem", "QGraphicsScene"));
    mixin(generateFunQt(24037, "qteQGraphicsScene_removeEllipseItem", "QGraphicsScene"));
    mixin(generateFunQt(24005, "qteQGraphicsScene_clear", "QGraphicsScene"));
    mixin(generateFunQt(24006, "qteQGraphicsScene_update", "QGraphicsScene"));
    // QGraphicsView
    mixin(generateFunQt(24010, "qteQGraphicsView_create", "QGraphicsScene"));
    mixin(generateFunQt(24011, "qteQGraphicsView_delete", "QGraphicsScene"));
    mixin(generateFunQt(24012, "qteQGraphicsView_setScene", "QGraphicsScene"));
    mixin(generateFunQt(24013, "qteQGraphicsView_setRenderHint", "QGraphicsScene"));
    mixin(generateFunQt(24038, "qteQGraphicsView_setViewportUpdateMode", "QGraphicsScene"));
    mixin(generateFunQt(24014, "qteQGraphicsView_setTransformationAnchor", "QGraphicsScene"));
    mixin(generateFunQt(24015, "qteQGraphicsView_setResizeAnchor", "QGraphicsScene"));
    mixin(generateFunQt(24016, "qteQGraphicsView_setInteractive", "QGraphicsScene"));
    mixin(generateFunQt(24017, "qteQGraphicsView_fitInView", "QGraphicsScene"));
    mixin(generateFunQt(24018, "qteQGraphicsView_scale", "QGraphicsScene"));
    mixin(generateFunQt(24019, "qteQGraphicsView_rotate", "QGraphicsScene"));
    mixin(generateFunQt(24032, "qteQGraphicsView_resize", "QGraphicsScene"));
    mixin(generateFunQt(24033, "qteQGraphicsView_show", "QGraphicsScene"));
    mixin(generateFunQt(24034, "qteQGraphicsView_hide", "QGraphicsScene"));
    // QGraphicsPixmapItem
    mixin(generateFunQt(24020, "qteQGraphicsPixmapItem_create", "QGraphicsScene"));
    mixin(generateFunQt(24021, "qteQGraphicsPixmapItem_delete", "QGraphicsScene"));
    mixin(generateFunQt(24022, "qteQGraphicsPixmapItem_setPixmap", "QGraphicsScene"));
    mixin(generateFunQt(24023, "qteQGraphicsPixmapItem_setPos", "QGraphicsScene"));
    mixin(generateFunQt(24024, "qteQGraphicsPixmapItem_setScale", "QGraphicsScene"));
    mixin(generateFunQt(24025, "qteQGraphicsPixmapItem_setRotation", "QGraphicsScene"));
    mixin(generateFunQt(24026, "qteQGraphicsPixmapItem_setZValue", "QGraphicsScene"));
    mixin(generateFunQt(24027, "qteQGraphicsPixmapItem_setOffset", "QGraphicsScene"));
    mixin(generateFunQt(24028, "qteQGraphicsPixmapItem_setTransformationMode", "QGraphicsScene"));
    mixin(generateFunQt(24029, "qteQGraphicsPixmapItem_setOpacity", "QGraphicsScene"));
    mixin(generateFunQt(24030, "qteQGraphicsPixmapItem_show", "QGraphicsScene"));
    mixin(generateFunQt(24031, "qteQGraphicsPixmapItem_hide", "QGraphicsScene"));
    // QGraphicsTextItem
    mixin(generateFunQt(24040, "qteQGraphicsTextItem_create", "QGraphicsScene"));
    mixin(generateFunQt(24041, "qteQGraphicsTextItem_delete", "QGraphicsScene"));
    mixin(generateFunQt(24042, "qteQGraphicsTextItem_setPlainText", "QGraphicsScene"));
    mixin(generateFunQt(24043, "qteQGraphicsTextItem_setHtml", "QGraphicsScene"));
    mixin(generateFunQt(24044, "qteQGraphicsTextItem_setPos", "QGraphicsScene"));
    mixin(generateFunQt(24045, "qteQGraphicsTextItem_setZValue", "QGraphicsScene"));
    mixin(generateFunQt(24046, "qteQGraphicsTextItem_setDefaultTextColor", "QGraphicsScene"));
    mixin(generateFunQt(24047, "qteQGraphicsTextItem_setFont", "QGraphicsScene"));
    mixin(generateFunQt(24048, "qteQGraphicsTextItem_setScale", "QGraphicsScene"));
    mixin(generateFunQt(24049, "qteQGraphicsTextItem_setRotation", "QGraphicsScene"));
    mixin(generateFunQt(24050, "qteQGraphicsTextItem_setOpacity", "QGraphicsScene"));
    // QGraphicsRectItem
    mixin(generateFunQt(24060, "qteQGraphicsRectItem_create", "QGraphicsScene"));
    mixin(generateFunQt(24061, "qteQGraphicsRectItem_delete", "QGraphicsScene"));
    mixin(generateFunQt(24062, "qteQGraphicsRectItem_setRect", "QGraphicsScene"));
    mixin(generateFunQt(24063, "qteQGraphicsRectItem_setBrush", "QGraphicsScene"));
    mixin(generateFunQt(24064, "qteQGraphicsRectItem_setPen", "QGraphicsScene"));
    mixin(generateFunQt(24065, "qteQGraphicsRectItem_setPos", "QGraphicsScene"));
    mixin(generateFunQt(24066, "qteQGraphicsRectItem_setZValue", "QGraphicsScene"));
    mixin(generateFunQt(24067, "qteQGraphicsRectItem_setOpacity", "QGraphicsScene"));
    // QGraphicsEllipseItem
    mixin(generateFunQt(24070, "qteQGraphicsEllipseItem_create", "QGraphicsScene"));
    mixin(generateFunQt(24071, "qteQGraphicsEllipseItem_delete", "QGraphicsScene"));
    mixin(generateFunQt(24072, "qteQGraphicsEllipseItem_setRect", "QGraphicsScene"));
    mixin(generateFunQt(24073, "qteQGraphicsEllipseItem_setBrush", "QGraphicsScene"));
    mixin(generateFunQt(24074, "qteQGraphicsEllipseItem_setPen", "QGraphicsScene"));
    mixin(generateFunQt(24075, "qteQGraphicsEllipseItem_setPos", "QGraphicsScene"));
    mixin(generateFunQt(24076, "qteQGraphicsEllipseItem_setZValue", "QGraphicsScene"));
    mixin(generateFunQt(24077, "qteQGraphicsEllipseItem_setOpacity", "QGraphicsScene"));
}

static this() {
    registerModule("QGraphicsScene", "qte56_qgraphicsscene.dll", &loadQGraphicsScene);
}

// ====================================================================
// Class wrappers
// ====================================================================

/// QGraphicsScene — игровой мир (контейнер спрайтов)
/// NOTE: В Qt QGraphicsScene наследуется от QObject, не от QWidget!
@live class QGraphicsScene : QObject {
public:
    this(void* parent) {
        super();
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[24000])(parent);
    }
    protected this() {}

    QGraphicsScene setSceneRect(double x, double y, double w, double h) {
        (cast(t_v__qp_d_d_d_d)pFunQt[24002])(_wh, x, y, w, h);
        return this;
    }

    QGraphicsScene addItem(QGraphicsPixmapItem item) {
        (cast(t_v__qp_qp)pFunQt[24003])(_wh, item.getWH());
        item.disown(); // Сцена владеет спрайтом теперь
        return this;
    }

    QGraphicsScene addItem(QGraphicsTextItem item) {
        (cast(t_v__qp_qp)pFunQt[24007])(_wh, item.getWH());
        item.disown();
        return this;
    }

    QGraphicsScene addItem(QGraphicsRectItem item) {
        (cast(t_v__qp_qp)pFunQt[24008])(_wh, item.getWH());
        item.disown();
        return this;
    }

    QGraphicsScene addItem(QGraphicsEllipseItem item) {
        (cast(t_v__qp_qp)pFunQt[24009])(_wh, item.getWH());
        item.disown();
        return this;
    }

    QGraphicsScene removeItem(QGraphicsPixmapItem item) {
        (cast(t_v__qp_qp)pFunQt[24004])(_wh, item.getWH());
        return this;
    }

    QGraphicsScene removeItem(QGraphicsTextItem item) {
        (cast(t_v__qp_qp)pFunQt[24035])(_wh, item.getWH());
        return this;
    }

    QGraphicsScene removeItem(QGraphicsRectItem item) {
        (cast(t_v__qp_qp)pFunQt[24036])(_wh, item.getWH());
        return this;
    }

    QGraphicsScene removeItem(QGraphicsEllipseItem item) {
        (cast(t_v__qp_qp)pFunQt[24037])(_wh, item.getWH());
        return this;
    }

    QGraphicsScene clear() {
        (cast(t_v__qp)pFunQt[24005])(_wh);
        return this;
    }

    QGraphicsScene updateScene() {
        (cast(t_v__qp)pFunQt[24006])(_wh);
        return this;
    }

    QGraphicsScene update() {
        (cast(t_v__qp)pFunQt[24006])(_wh);
        return this;
    }
}

/// QGraphicsView — окно просмотра сцены
/// NOTE: В Qt QGraphicsView наследуется от QAbstractScrollArea.
/// В QTE56 делаем standalone класс для простоты.
@live class QGraphicsView {
private:
    void* _wh;
    bool _qt_owned;

public:
    this(void* parent) {
        _wh = null;
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[24010])(parent);
    }
    protected this() {}

    ~this() {
        if (_wh && !_qt_owned && pFunQt[24011] !is null) {
            (cast(t_v__qp)pFunQt[24011])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }
    void disown() { _qt_owned = true; }

    QGraphicsView setScene(QGraphicsScene scene) {
        (cast(t_v__qp_qp)pFunQt[24012])(_wh, scene.getWH());
        return this;
    }

    QGraphicsView setRenderHint(int hint, bool on = true) {
        (cast(t_v__qp_i_i)pFunQt[24013])(_wh, hint, on ? 1 : 0);
        return this;
    }

    QGraphicsView setViewportUpdateMode(int mode) {
        (cast(t_v__qp_i)pFunQt[24038])(_wh, mode);
        return this;
    }

    QGraphicsView setTransformationAnchor(int anchor) {
        (cast(t_v__qp_i)pFunQt[24014])(_wh, anchor);
        return this;
    }

    QGraphicsView setResizeAnchor(int anchor) {
        (cast(t_v__qp_i)pFunQt[24015])(_wh, anchor);
        return this;
    }

    QGraphicsView setInteractive(bool allowed) {
        (cast(t_v__qp_i)pFunQt[24016])(_wh, allowed ? 1 : 0);
        return this;
    }

    QGraphicsView fitInView(double x, double y, double w, double h, int aspectRatioMode = 0) {
        (cast(t_v__qp_d_d_d_d_i)pFunQt[24017])(_wh, x, y, w, h, aspectRatioMode);
        return this;
    }

    QGraphicsView scale(double sx, double sy) {
        (cast(t_v__qp_d_d)pFunQt[24018])(_wh, sx, sy);
        return this;
    }

    QGraphicsView rotate(double angle) {
        (cast(t_v__qp_d)pFunQt[24019])(_wh, angle);
        return this;
    }

    // QWidget-совместимые методы
    QGraphicsView resize(int w, int h) {
        (cast(t_v__qp_i_i)pFunQt[24032])(_wh, w, h);
        return this;
    }

    QGraphicsView show() {
        (cast(t_v__qp)pFunQt[24033])(_wh);
        return this;
    }

    QGraphicsView hide() {
        (cast(t_v__qp)pFunQt[24034])(_wh);
        return this;
    }
}

/// QGraphicsPixmapItem — спрайт (картинка на сцене)
/// NOTE: QGraphicsItem не наследуется от QObject, поэтому это standalone класс
@live class QGraphicsPixmapItem {
private:
    void* _wh;
    bool _qt_owned;

public:
    this(void* pixmap, void* parentItem = null) {
        _wh = null;
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[24020])(pixmap);
    }
    protected this() {}

    ~this() {
        if (_wh && !_qt_owned && pFunQt[24021] !is null) {
            (cast(t_v__qp)pFunQt[24021])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }
    void disown() { _qt_owned = true; }

    QGraphicsPixmapItem setPixmap(void* pixmap) {
        (cast(t_v__qp_qp)pFunQt[24022])(_wh, pixmap);
        return this;
    }

    QGraphicsPixmapItem setPos(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[24023])(_wh, x, y);
        return this;
    }

    QGraphicsPixmapItem setScale(double scale) {
        (cast(t_v__qp_d)pFunQt[24024])(_wh, scale);
        return this;
    }

    QGraphicsPixmapItem setRotation(double angle) {
        (cast(t_v__qp_d)pFunQt[24025])(_wh, angle);
        return this;
    }

    QGraphicsPixmapItem setZValue(double z) {
        (cast(t_v__qp_d)pFunQt[24026])(_wh, z);
        return this;
    }

    QGraphicsPixmapItem setOffset(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[24027])(_wh, x, y);
        return this;
    }

    QGraphicsPixmapItem setTransformationMode(int mode) {
        (cast(t_v__qp_i)pFunQt[24028])(_wh, mode);
        return this;
    }

    QGraphicsPixmapItem setOpacity(double opacity) {
        (cast(t_v__qp_d)pFunQt[24029])(_wh, opacity);
        return this;
    }

    QGraphicsPixmapItem showItem() {
        (cast(t_v__qp)pFunQt[24030])(_wh);
        return this;
    }

    QGraphicsPixmapItem hideItem() {
        (cast(t_v__qp)pFunQt[24031])(_wh);
        return this;
    }
}

/// QGraphicsTextItem — текст на сцене
@live class QGraphicsTextItem {
private:
    void* _wh;
    bool _qt_owned;

public:
    this(void* parent = null) {
        _wh = null;
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[24040])(parent);
    }
    protected this() {}

    ~this() {
        if (_wh && !_qt_owned && pFunQt[24041] !is null) {
            (cast(t_v__qp)pFunQt[24041])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }
    void disown() { _qt_owned = true; }

    QGraphicsTextItem setPlainText(string text) {
        import std.string : toStringz;
        (cast(t_v__qp_qp)pFunQt[24042])(_wh, cast(void*)text.toStringz);
        return this;
    }

    QGraphicsTextItem setHtml(string html) {
        import std.string : toStringz;
        (cast(t_v__qp_qp)pFunQt[24043])(_wh, cast(void*)html.toStringz);
        return this;
    }

    QGraphicsTextItem setPos(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[24044])(_wh, x, y);
        return this;
    }

    QGraphicsTextItem setZValue(double z) {
        (cast(t_v__qp_d)pFunQt[24045])(_wh, z);
        return this;
    }

    QGraphicsTextItem setDefaultTextColor(int r, int g, int b, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[24046])(_wh, r, g, b, a);
        return this;
    }

    QGraphicsTextItem setFont(void* font) {
        (cast(t_v__qp_qp)pFunQt[24047])(_wh, font);
        return this;
    }

    QGraphicsTextItem setScale(double scale) {
        (cast(t_v__qp_d)pFunQt[24048])(_wh, scale);
        return this;
    }

    QGraphicsTextItem setRotation(double angle) {
        (cast(t_v__qp_d)pFunQt[24049])(_wh, angle);
        return this;
    }

    QGraphicsTextItem setOpacity(double opacity) {
        (cast(t_v__qp_d)pFunQt[24050])(_wh, opacity);
        return this;
    }
}

/// QGraphicsRectItem — прямоугольник на сцене
@live class QGraphicsRectItem {
private:
    void* _wh;
    bool _qt_owned;

public:
    this(double x, double y, double w, double h, void* parent = null) {
        _wh = null;
        _qt_owned = false;
        _wh = (cast(t_qp__d_d_d_d_qp)pFunQt[24060])(x, y, w, h, parent);
    }
    protected this() {}

    ~this() {
        if (_wh && !_qt_owned && pFunQt[24061] !is null) {
            (cast(t_v__qp)pFunQt[24061])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }
    void disown() { _qt_owned = true; }

    QGraphicsRectItem setRect(double x, double y, double w, double h) {
        (cast(t_v__qp_d_d_d_d)pFunQt[24062])(_wh, x, y, w, h);
        return this;
    }

    QGraphicsRectItem setBrush(int r, int g, int b, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[24063])(_wh, r, g, b, a);
        return this;
    }

    QGraphicsRectItem setPen(int r, int g, int b, int a = 255, int width = 1) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[24064])(_wh, r, g, b, a, width);
        return this;
    }

    QGraphicsRectItem setPos(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[24065])(_wh, x, y);
        return this;
    }

    QGraphicsRectItem setZValue(double z) {
        (cast(t_v__qp_d)pFunQt[24066])(_wh, z);
        return this;
    }

    QGraphicsRectItem setOpacity(double opacity) {
        (cast(t_v__qp_d)pFunQt[24067])(_wh, opacity);
        return this;
    }
}

/// QGraphicsEllipseItem — эллипс/круг на сцене
@live class QGraphicsEllipseItem {
private:
    void* _wh;
    bool _qt_owned;

public:
    this(double x, double y, double w, double h, void* parent = null) {
        _wh = null;
        _qt_owned = false;
        _wh = (cast(t_qp__d_d_d_d_qp)pFunQt[24070])(x, y, w, h, parent);
    }
    protected this() {}

    ~this() {
        if (_wh && !_qt_owned && pFunQt[24071] !is null) {
            (cast(t_v__qp)pFunQt[24071])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }
    void disown() { _qt_owned = true; }

    QGraphicsEllipseItem setRect(double x, double y, double w, double h) {
        (cast(t_v__qp_d_d_d_d)pFunQt[24072])(_wh, x, y, w, h);
        return this;
    }

    QGraphicsEllipseItem setBrush(int r, int g, int b, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[24073])(_wh, r, g, b, a);
        return this;
    }

    QGraphicsEllipseItem setPen(int r, int g, int b, int a = 255, int width = 1) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[24074])(_wh, r, g, b, a, width);
        return this;
    }

    QGraphicsEllipseItem setPos(double x, double y) {
        (cast(t_v__qp_d_d)pFunQt[24075])(_wh, x, y);
        return this;
    }

    QGraphicsEllipseItem setZValue(double z) {
        (cast(t_v__qp_d)pFunQt[24076])(_wh, z);
        return this;
    }

    QGraphicsEllipseItem setOpacity(double opacity) {
        (cast(t_v__qp_d)pFunQt[24077])(_wh, opacity);
        return this;
    }
}
