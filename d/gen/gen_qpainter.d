/**
 * gen_qpainter.d — wrapper for QPainter (value type, like QFont/QColor).
 * Module: QPainter  |  DLL: qte56_qpainter.dll
 * Index block: 18000–18093 (94 functions)
 */
module gen_qpainter;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qpen;
import gen_qbrush;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_i_i_i_i_i, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_i, t_v__qp_qp_qp_qp, toQString;

// New aliases for this module:
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_i_i_i_i_i_qp_i"));
mixin(generateAlias("qp__qp_i_i_i_i_i_qp"));     // boundingRect_iiiiis (new, no len)
mixin(generateAlias("qp__qp_qp_i_qp"));           // boundingRect_pis    (new, no len)
// ── Алиасы augment 2026-07-26 ─────────────────────────────────────────
mixin(generateAlias("i__qp_qp_qp_qp_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_qp_i_i"));
mixin(generateAlias("v__qp_i_i_qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_qp_i_i_i_i_i"));
mixin(generateAlias("v__qp_qp_d_d"));
mixin(generateAlias("v__qp_qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp_qp_i_i_i"));
mixin(generateAlias("v__qp_qp_qp_qp_i"));
mixin(generateAlias("qp__qp_qp_i_qp_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_d_d_i"));
mixin(generateAlias("v__qp_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_qp_i_qp"));
mixin(generateAlias("v__qp_i_i_i_i_i_qp_qp"));   // drawText_iiiiisp (new, no len)
mixin(generateAlias("v__qp_i_i_i_i_qp"));
mixin(generateAlias("v__qp_i_i_qp_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_d_d_i"));
mixin(generateAlias("v__qp_qp_i_i"));
mixin(generateAlias("v__qp_qp_i_qp_i_qp"));
mixin(generateAlias("v__qp_qp_i_qp_qp"));        // drawText_pisp (new, no len)
mixin(generateAlias("v__qp_qp_qp_qp"));
mixin(generateAlias("v__qp_i_i_i_i_qp_i_i_i_i")); // drawImage/drawPixmap rect overload
mixin(generateAlias("v__qp_i_i_qp"));              // drawImage/drawPixmap point overload

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQPainter() {
    // Lifecycle
    mixin(generateFunQt(18000, "qteQPainter_create",        "QPainter"));
    mixin(generateFunQt(18001, "qteQPainter_delete",        "QPainter"));
    mixin(generateFunQt(18002, "qteQPainter_create_device", "QPainter"));
    // Methods
    mixin(generateFunQt(18003, "qteQPainter_device",               "QPainter"));
    mixin(generateFunQt(18004, "qteQPainter_begin",                "QPainter"));
    mixin(generateFunQt(18005, "qteQPainter_end",                  "QPainter"));
    mixin(generateFunQt(18006, "qteQPainter_isActive",             "QPainter"));
    mixin(generateFunQt(18007, "qteQPainter_initFrom",             "QPainter"));
    mixin(generateFunQt(18008, "qteQPainter_setCompositionMode",   "QPainter"));
    mixin(generateFunQt(18009, "qteQPainter_compositionMode",      "QPainter"));
    mixin(generateFunQt(18010, "qteQPainter_setFont",              "QPainter"));
    mixin(generateFunQt(18011, "qteQPainter_setPen_color",         "QPainter"));
    mixin(generateFunQt(18012, "qteQPainter_setPen_style",         "QPainter"));
    mixin(generateFunQt(18013, "qteQPainter_setBrush",             "QPainter"));
    mixin(generateFunQt(18014, "qteQPainter_setBackgroundMode",    "QPainter"));
    mixin(generateFunQt(18015, "qteQPainter_backgroundMode",       "QPainter"));
    mixin(generateFunQt(18016, "qteQPainter_brushOrigin",          "QPainter"));
    mixin(generateFunQt(18017, "qteQPainter_setBrushOrigin_ii",    "QPainter"));
    mixin(generateFunQt(18018, "qteQPainter_setBrushOrigin_p",     "QPainter"));
    mixin(generateFunQt(18019, "qteQPainter_opacity",              "QPainter"));
    mixin(generateFunQt(18020, "qteQPainter_setOpacity",           "QPainter"));
    mixin(generateFunQt(18021, "qteQPainter_setClipRect_pp",       "QPainter"));
    mixin(generateFunQt(18022, "qteQPainter_setClipRect_iiiip",    "QPainter"));
    mixin(generateFunQt(18023, "qteQPainter_setClipping",          "QPainter"));
    mixin(generateFunQt(18024, "qteQPainter_hasClipping",          "QPainter"));
    mixin(generateFunQt(18025, "qteQPainter_save",                 "QPainter"));
    mixin(generateFunQt(18026, "qteQPainter_restore",              "QPainter"));
    mixin(generateFunQt(18027, "qteQPainter_resetMatrix",          "QPainter"));
    mixin(generateFunQt(18028, "qteQPainter_resetTransform",       "QPainter"));
    mixin(generateFunQt(18029, "qteQPainter_setMatrixEnabled",     "QPainter"));
    mixin(generateFunQt(18030, "qteQPainter_matrixEnabled",        "QPainter"));
    mixin(generateFunQt(18031, "qteQPainter_setWorldMatrixEnabled","QPainter"));
    mixin(generateFunQt(18032, "qteQPainter_worldMatrixEnabled",   "QPainter"));
    mixin(generateFunQt(18033, "qteQPainter_scale",                "QPainter"));
    mixin(generateFunQt(18034, "qteQPainter_shear",                "QPainter"));
    mixin(generateFunQt(18035, "qteQPainter_rotate",               "QPainter"));
    mixin(generateFunQt(18036, "qteQPainter_translate_p",          "QPainter"));
    mixin(generateFunQt(18037, "qteQPainter_translate_dd",         "QPainter"));
    mixin(generateFunQt(18038, "qteQPainter_window",               "QPainter"));
    mixin(generateFunQt(18039, "qteQPainter_setWindow_p",          "QPainter"));
    mixin(generateFunQt(18040, "qteQPainter_setWindow_iiii",       "QPainter"));
    mixin(generateFunQt(18041, "qteQPainter_viewport",             "QPainter"));
    mixin(generateFunQt(18042, "qteQPainter_setViewport_p",        "QPainter"));
    mixin(generateFunQt(18043, "qteQPainter_setViewport_iiii",     "QPainter"));
    mixin(generateFunQt(18044, "qteQPainter_setViewTransformEnabled","QPainter"));
    mixin(generateFunQt(18045, "qteQPainter_viewTransformEnabled", "QPainter"));
    // Drawing primitives
    mixin(generateFunQt(18046, "qteQPainter_drawPoint_p",          "QPainter"));
    mixin(generateFunQt(18047, "qteQPainter_drawPoint_ii",         "QPainter"));
    mixin(generateFunQt(18048, "qteQPainter_drawPoints_pi",        "QPainter"));
    mixin(generateFunQt(18049, "qteQPainter_drawLine_iiii",        "QPainter"));
    mixin(generateFunQt(18050, "qteQPainter_drawLine_pp",          "QPainter"));
    mixin(generateFunQt(18051, "qteQPainter_drawLines_pi",         "QPainter"));
    mixin(generateFunQt(18052, "qteQPainter_drawRect_iiii",        "QPainter"));
    mixin(generateFunQt(18053, "qteQPainter_drawRect_p",           "QPainter"));
    mixin(generateFunQt(18054, "qteQPainter_drawRects_pi",         "QPainter"));
    mixin(generateFunQt(18055, "qteQPainter_drawEllipse_p",        "QPainter"));
    mixin(generateFunQt(18056, "qteQPainter_drawEllipse_iiii",     "QPainter"));
    mixin(generateFunQt(18057, "qteQPainter_drawEllipse_pii",      "QPainter"));
    mixin(generateFunQt(18058, "qteQPainter_drawPolyline_pi",      "QPainter"));
    mixin(generateFunQt(18059, "qteQPainter_drawPolygon_pip",      "QPainter"));
    mixin(generateFunQt(18060, "qteQPainter_drawConvexPolygon_pi", "QPainter"));
    // Arcs, pies, chords
    mixin(generateFunQt(18061, "qteQPainter_drawArc_pii",          "QPainter"));
    mixin(generateFunQt(18062, "qteQPainter_drawArc_iiiiii",       "QPainter"));
    mixin(generateFunQt(18063, "qteQPainter_drawPie_iiiiii",       "QPainter"));
    mixin(generateFunQt(18064, "qteQPainter_drawPie_pii",          "QPainter"));
    mixin(generateFunQt(18065, "qteQPainter_drawChord_iiiiii",     "QPainter"));
    mixin(generateFunQt(18066, "qteQPainter_drawChord_pii",        "QPainter"));
    mixin(generateFunQt(18067, "qteQPainter_drawRoundedRect_iiiiddp","QPainter"));
    mixin(generateFunQt(18068, "qteQPainter_drawRoundedRect_pddp", "QPainter"));
    mixin(generateFunQt(18069, "qteQPainter_drawRoundRect_iiiiii", "QPainter"));
    mixin(generateFunQt(18070, "qteQPainter_drawRoundRect_pii",    "QPainter"));
    // Layout direction
    mixin(generateFunQt(18071, "qteQPainter_setLayoutDirection",   "QPainter"));
    mixin(generateFunQt(18072, "qteQPainter_layoutDirection",      "QPainter"));
    // Text
    mixin(generateFunQt(18073, "qteQPainter_drawText_ps",          "QPainter"));
    mixin(generateFunQt(18074, "qteQPainter_drawText_iis",         "QPainter"));
    mixin(generateFunQt(18075, "qteQPainter_drawText_pisp",        "QPainter"));
    mixin(generateFunQt(18076, "qteQPainter_drawText_iiiiisp",     "QPainter"));
    mixin(generateFunQt(18077, "qteQPainter_boundingRect_pis",     "QPainter"));
    mixin(generateFunQt(18078, "qteQPainter_boundingRect_iiiiis",  "QPainter"));
    // Fill / erase
    mixin(generateFunQt(18079, "qteQPainter_fillRect_iiiip",       "QPainter"));
    mixin(generateFunQt(18080, "qteQPainter_fillRect_pp",          "QPainter"));
    mixin(generateFunQt(18081, "qteQPainter_fillRect_iiiii",       "QPainter"));
    mixin(generateFunQt(18082, "qteQPainter_fillRect_pi",          "QPainter"));
    mixin(generateFunQt(18083, "qteQPainter_eraseRect_iiii",       "QPainter"));
    mixin(generateFunQt(18084, "qteQPainter_eraseRect_p",          "QPainter"));
    // Render hints
    mixin(generateFunQt(18085, "qteQPainter_setRenderHint",        "QPainter"));
    mixin(generateFunQt(18086, "qteQPainter_setRenderHints",       "QPainter"));
    mixin(generateFunQt(18087, "qteQPainter_renderHints",          "QPainter"));
    // Misc
    mixin(generateFunQt(18088, "qteQPainter_paintEngine",          "QPainter"));
    mixin(generateFunQt(18089, "qteQPainter_setRedirected",        "QPainter"));
    mixin(generateFunQt(18090, "qteQPainter_redirected",           "QPainter"));
    mixin(generateFunQt(18091, "qteQPainter_restoreRedirected",    "QPainter"));
    mixin(generateFunQt(18092, "qteQPainter_beginNativePainting",  "QPainter"));
    mixin(generateFunQt(18093, "qteQPainter_endNativePainting",    "QPainter"));
    // Draw image / pixmap
    mixin(generateFunQt(18094, "qteQPainter_drawImage_rect",      "QPainter"));
    mixin(generateFunQt(18095, "qteQPainter_drawImage_point",     "QPainter"));
    mixin(generateFunQt(18096, "qteQPainter_drawPixmap_rect",     "QPainter"));
    mixin(generateFunQt(18097, "qteQPainter_drawPixmap_point",    "QPainter"));
    // ── Дополнено 2026-07-26 (augment) ─────────────────────────
    mixin(generateFunQt(18102, "qteQPainter_setBrushOrigin_qpointf", "QPainter"));
    mixin(generateFunQt(18103, "qteQPainter_setClipRect_qrectf_qt_clipoperation", "QPainter"));
    mixin(generateFunQt(18104, "qteQPainter_setClipRect_qrect_qt_clipoperation", "QPainter"));
    mixin(generateFunQt(18106, "qteQPainter_clipBoundingRect", "QPainter"));
    mixin(generateFunQt(18107, "qteQPainter_translate_qpointf", "QPainter"));
    mixin(generateFunQt(18114, "qteQPainter_drawPoint_qpointf", "QPainter"));
    mixin(generateFunQt(18117, "qteQPainter_drawPoints_qpointf_int", "QPainter"));
    mixin(generateFunQt(18121, "qteQPainter_drawLine_qpointf_qpointf", "QPainter"));
    mixin(generateFunQt(18122, "qteQPainter_drawLines_qlinef_int", "QPainter"));
    mixin(generateFunQt(18123, "qteQPainter_drawLines_qpointf_int", "QPainter"));
    mixin(generateFunQt(18125, "qteQPainter_drawLines_qpoint_int", "QPainter"));
    mixin(generateFunQt(18126, "qteQPainter_drawRect_qrectf", "QPainter"));
    mixin(generateFunQt(18127, "qteQPainter_drawRect_int_int_int_int", "QPainter"));
    mixin(generateFunQt(18129, "qteQPainter_drawRects_qrectf_int", "QPainter"));
    mixin(generateFunQt(18131, "qteQPainter_drawEllipse_qrectf", "QPainter"));
    mixin(generateFunQt(18134, "qteQPainter_drawEllipse_qpointf_qreal_qreal", "QPainter"));
    mixin(generateFunQt(18136, "qteQPainter_drawPolyline_qpointf_int", "QPainter"));
    mixin(generateFunQt(18138, "qteQPainter_drawPolygon_qpointf_int_qt_fillrule", "QPainter"));
    mixin(generateFunQt(18140, "qteQPainter_drawConvexPolygon_qpointf_int", "QPainter"));
    mixin(generateFunQt(18142, "qteQPainter_drawArc_qrectf_int_int", "QPainter"));
    mixin(generateFunQt(18143, "qteQPainter_drawArc_qrect_int_int", "QPainter"));
    mixin(generateFunQt(18145, "qteQPainter_drawPie_qrectf_int_int", "QPainter"));
    mixin(generateFunQt(18147, "qteQPainter_drawPie_qrect_int_int", "QPainter"));
    mixin(generateFunQt(18148, "qteQPainter_drawChord_qrectf_int_int", "QPainter"));
    mixin(generateFunQt(18150, "qteQPainter_drawChord_qrect_int_int", "QPainter"));
    mixin(generateFunQt(18151, "qteQPainter_drawRoundedRect_qrectf_qreal_qreal_qt_sizemode", "QPainter"));
    mixin(generateFunQt(18154, "qteQPainter_drawRoundRect_qrectf_int_int", "QPainter"));
    mixin(generateFunQt(18155, "qteQPainter_drawRoundRect_int_int_int_int_int_int", "QPainter"));
    mixin(generateFunQt(18157, "qteQPainter_drawTiledPixmap_qrectf_qpixmap_qpointf", "QPainter"));
    mixin(generateFunQt(18158, "qteQPainter_drawTiledPixmap_int_int_int_int_qpixmap_int_int", "QPainter"));
    mixin(generateFunQt(18159, "qteQPainter_drawTiledPixmap_qrect_qpixmap_qpoint", "QPainter"));
    mixin(generateFunQt(18160, "qteQPainter_drawPixmap_qrectf_qpixmap_qrectf", "QPainter"));
    mixin(generateFunQt(18161, "qteQPainter_drawPixmap_qrect_qpixmap_qrect", "QPainter"));
    mixin(generateFunQt(18162, "qteQPainter_drawPixmap_int_int_int_int_qpixmap_int_int_int_int", "QPainter"));
    mixin(generateFunQt(18163, "qteQPainter_drawPixmap_int_int_qpixmap_int_int_int_int", "QPainter"));
    mixin(generateFunQt(18164, "qteQPainter_drawPixmap_qpointf_qpixmap_qrectf", "QPainter"));
    mixin(generateFunQt(18165, "qteQPainter_drawPixmap_qpoint_qpixmap_qrect", "QPainter"));
    mixin(generateFunQt(18166, "qteQPainter_drawPixmap_qpointf_qpixmap", "QPainter"));
    mixin(generateFunQt(18167, "qteQPainter_drawPixmap_qpoint_qpixmap", "QPainter"));
    mixin(generateFunQt(18168, "qteQPainter_drawPixmap_int_int_qpixmap", "QPainter"));
    mixin(generateFunQt(18169, "qteQPainter_drawPixmap_qrect_qpixmap", "QPainter"));
    mixin(generateFunQt(18170, "qteQPainter_drawPixmap_int_int_int_int_qpixmap", "QPainter"));
    mixin(generateFunQt(18171, "qteQPainter_drawImage_qrectf_qimage_qrectf_qt_imageconversionflags", "QPainter"));
    mixin(generateFunQt(18172, "qteQPainter_drawImage_qrect_qimage_qrect_qt_imageconversionflags", "QPainter"));
    mixin(generateFunQt(18173, "qteQPainter_drawImage_qpointf_qimage_qrectf_qt_imageconversionflags", "QPainter"));
    mixin(generateFunQt(18174, "qteQPainter_drawImage_qpoint_qimage_qrect_qt_imageconversionflags", "QPainter"));
    mixin(generateFunQt(18175, "qteQPainter_drawImage_qrectf_qimage", "QPainter"));
    mixin(generateFunQt(18176, "qteQPainter_drawImage_qrect_qimage", "QPainter"));
    mixin(generateFunQt(18177, "qteQPainter_drawImage_qpointf_qimage", "QPainter"));
    mixin(generateFunQt(18178, "qteQPainter_drawImage_qpoint_qimage", "QPainter"));
    mixin(generateFunQt(18179, "qteQPainter_drawImage_int_int_qimage_int_int_int_int_qt_imageconversionflags", "QPainter"));
    mixin(generateFunQt(18180, "qteQPainter_drawText_qpointf_qstring", "QPainter"));
    mixin(generateFunQt(18181, "qteQPainter_drawText_qpoint_qstring", "QPainter"));
    mixin(generateFunQt(18182, "qteQPainter_drawText_int_int_qstring", "QPainter"));
    mixin(generateFunQt(18183, "qteQPainter_drawText_qpointf_qstring_int_int", "QPainter"));
    mixin(generateFunQt(18184, "qteQPainter_drawText_qrectf_int_qstring_qrectf", "QPainter"));
    mixin(generateFunQt(18185, "qteQPainter_drawText_qrect_int_qstring_qrect", "QPainter"));
    mixin(generateFunQt(18186, "qteQPainter_drawText_int_int_int_int_int_qstring_qrect", "QPainter"));
    mixin(generateFunQt(18187, "qteQPainter_drawText_qrectf_qstring", "QPainter"));
    mixin(generateFunQt(18188, "qteQPainter_boundingRect_qrectf_int_qstring", "QPainter"));
    mixin(generateFunQt(18189, "qteQPainter_boundingRect_qrect_int_qstring", "QPainter"));
    mixin(generateFunQt(18190, "qteQPainter_boundingRect_int_int_int_int_int_qstring", "QPainter"));
    mixin(generateFunQt(18191, "qteQPainter_boundingRect_qrectf_qstring", "QPainter"));
    mixin(generateFunQt(18192, "qteQPainter_fillRect_qrectf_qcolor", "QPainter"));
    mixin(generateFunQt(18194, "qteQPainter_fillRect_qrect_qcolor", "QPainter"));
    mixin(generateFunQt(18196, "qteQPainter_fillRect_qrect_qt_globalcolor", "QPainter"));
    mixin(generateFunQt(18197, "qteQPainter_fillRect_qrectf_qt_globalcolor", "QPainter"));
    mixin(generateFunQt(18198, "qteQPainter_fillRect_int_int_int_int_qt_brushstyle", "QPainter"));
    mixin(generateFunQt(18199, "qteQPainter_fillRect_qrect_qt_brushstyle", "QPainter"));
    mixin(generateFunQt(18239, "qteQPainter_fillRect_qrectf_qt_brushstyle", "QPainter"));
    mixin(generateFunQt(18240, "qteQPainter_fillRect_int_int_int_int_qgradient_preset", "QPainter"));
    mixin(generateFunQt(18241, "qteQPainter_fillRect_qrect_qgradient_preset", "QPainter"));
    mixin(generateFunQt(18242, "qteQPainter_fillRect_qrectf_qgradient_preset", "QPainter"));
    mixin(generateFunQt(18243, "qteQPainter_eraseRect_qrectf", "QPainter"));
    mixin(generateFunQt(18245, "qteQPainter_eraseRect_qrect", "QPainter"));
    // NOTE: indices 19786–19787 (painter_setPen, painter_setBrush) are loaded
    //       by loadQPen() from qte56_drawing.dll.
}

static this() {
    registerModule("QPainter", "qte56_foundation.dll", &loadQPainter);
}

// ====================================================================
// Class wrapper — value type (like QFont, QColor)
// ====================================================================

/// D wrapper for Qt class QPainter.
@live class QPainter {
private:
    void* _wh;
    bool  _qt_owned;

protected:
    /// Internal: wrap existing heap pointer without allocating new C++ object.
    this(void* ptr) {
        _wh = ptr;
        _qt_owned = false;
    }

public:
    /// Create default QPainter (not bound to device).
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[18000])(null);
    }

    /// Create QPainter and begin() on device (e.g. QPixmap.getWH()).
    this(void* device, bool dummy) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[18002])(device);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[18001] !is null) {
            (cast(t_v__qp)pFunQt[18001])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated QPainter pointer. Dtor WILL delete.
    static QPainter wrap(void* ptr) {
        if (ptr is null) return null;
        return new QPainter(ptr);
    }

    /// Wrap a borrowed QPainter* (Qt-owned active painter, e.g. in delegate paint).
    /// Dtor will NOT delete; НЕ вызывать end() — painter управляется Qt.
    static QPainter wrapBorrowed(void* ptr) {
        if (ptr is null) return null;
        auto p = new QPainter(ptr);
        p._qt_owned = true;
        return p;
    }

    // ── Lifecycle ────────────────────────────────────────────────────

    /// device
    void* device() {
        return cast(void*)(cast(t_qp__qp)pFunQt[18003])(_wh);
    }

    /// begin painting on device
    bool begin(void* device) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18004])(_wh, device);
    }

    /// end painting
    bool end() {
        return cast(bool)(cast(t_i__qp)pFunQt[18005])(_wh);
    }

    /// isActive
    bool isActive() {
        return cast(bool)(cast(t_i__qp)pFunQt[18006])(_wh);
    }

    /// initFrom
    QPainter initFrom(void* device) {
        (cast(t_v__qp_qp)pFunQt[18007])(_wh, device);
        return this;
    }

    // ── Composition / pen / brush ────────────────────────────────────

    /// setCompositionMode
    QPainter setCompositionMode(int mode) {
        (cast(t_v__qp_i)pFunQt[18008])(_wh, mode);
        return this;
    }

    /// compositionMode
    int compositionMode() {
        return cast(int)(cast(t_i__qp)pFunQt[18009])(_wh);
    }

    /// setFont (pass QFont.getWH())
    QPainter setFont(void* f) {
        (cast(t_v__qp_qp)pFunQt[18010])(_wh, f);
        return this;
    }

    /// setPen by QColor (pass QColor.getWH())
    QPainter setPen(void* color) {
        (cast(t_v__qp_qp)pFunQt[18011])(_wh, color);
        return this;
    }

    /// setPen by Qt::PenStyle enum
    QPainter setPen(int style) {
        (cast(t_v__qp_i)pFunQt[18012])(_wh, style);
        return this;
    }

    /// setPen from a QPen object (full pen with colour, width, style).
    QPainter setPen(QPen pen) {
        (cast(t_v__qp_qp)pFunQt[19786])(_wh, pen.getWH());
        return this;
    }

    /// setBrush by Qt::BrushStyle enum
    QPainter setBrush(int style) {
        (cast(t_v__qp_i)pFunQt[18013])(_wh, style);
        return this;
    }

    /// setBrush from a QBrush object (full brush with colour and style).
    QPainter setBrush(QBrush brush) {
        (cast(t_v__qp_qp)pFunQt[19787])(_wh, brush.getWH());
        return this;
    }

    /// setBackgroundMode
    QPainter setBackgroundMode(int mode) {
        (cast(t_v__qp_i)pFunQt[18014])(_wh, mode);
        return this;
    }

    /// backgroundMode
    int backgroundMode() {
        return cast(int)(cast(t_i__qp)pFunQt[18015])(_wh);
    }

    /// brushOrigin → DPoint
    DPoint brushOrigin() {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[18016])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// setBrushOrigin(x, y)
    QPainter setBrushOrigin(int x, int y) {
        (cast(t_v__qp_i_i)pFunQt[18017])(_wh, x, y);
        return this;
    }

    /// setBrushOrigin(QPoint ptr)
    QPainter setBrushOrigin(void* p0) {
        (cast(t_v__qp_qp)pFunQt[18018])(_wh, p0);
        return this;
    }

    /// opacity
    double opacity() {
        return cast(double)(cast(t_d__qp)pFunQt[18019])(_wh);
    }

    /// setOpacity
    QPainter setOpacity(double opacity) {
        (cast(t_v__qp_d)pFunQt[18020])(_wh, opacity);
        return this;
    }

    // ── Clipping ─────────────────────────────────────────────────────

    /// setClipRect(QRect ptr, ClipOperation)
    QPainter setClipRect(void* rect, int op = 0) {
        (cast(t_v__qp_qp_i)pFunQt[18021])(_wh, rect, op);
        return this;
    }

    /// setClipRect(x, y, w, h, ClipOperation)
    QPainter setClipRect(int x, int y, int w, int h, int op = 0) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[18022])(_wh, x, y, w, h, op);
        return this;
    }

    /// setClipping
    QPainter setClipping(bool enable) {
        (cast(t_v__qp_i)pFunQt[18023])(_wh, enable ? 1 : 0);
        return this;
    }

    /// hasClipping
    bool hasClipping() {
        return cast(bool)(cast(t_i__qp)pFunQt[18024])(_wh);
    }

    // ── State save/restore ───────────────────────────────────────────

    /// save
    QPainter save() {
        (cast(t_v__qp)pFunQt[18025])(_wh);
        return this;
    }

    /// restore
    QPainter restore() {
        (cast(t_v__qp)pFunQt[18026])(_wh);
        return this;
    }

    // ── Transform ────────────────────────────────────────────────────

    /// resetMatrix (deprecated, use resetTransform)
    QPainter resetMatrix() {
        (cast(t_v__qp)pFunQt[18027])(_wh);
        return this;
    }

    /// resetTransform
    QPainter resetTransform() {
        (cast(t_v__qp)pFunQt[18028])(_wh);
        return this;
    }

    /// setMatrixEnabled
    QPainter setMatrixEnabled(bool enabled) {
        (cast(t_v__qp_i)pFunQt[18029])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// matrixEnabled
    bool matrixEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[18030])(_wh);
    }

    /// setWorldMatrixEnabled
    QPainter setWorldMatrixEnabled(bool enabled) {
        (cast(t_v__qp_i)pFunQt[18031])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// worldMatrixEnabled
    bool worldMatrixEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[18032])(_wh);
    }

    /// scale
    QPainter scale(double sx, double sy) {
        (cast(t_v__qp_d_d)pFunQt[18033])(_wh, sx, sy);
        return this;
    }

    /// shear
    QPainter shear(double sh, double sv) {
        (cast(t_v__qp_d_d)pFunQt[18034])(_wh, sh, sv);
        return this;
    }

    /// rotate
    QPainter rotate(double a) {
        (cast(t_v__qp_d)pFunQt[18035])(_wh, a);
        return this;
    }

    /// translate by QPoint
    QPainter translate(void* offset) {
        (cast(t_v__qp_qp)pFunQt[18036])(_wh, offset);
        return this;
    }

    /// translate by dx, dy
    QPainter translate(double dx, double dy) {
        (cast(t_v__qp_d_d)pFunQt[18037])(_wh, dx, dy);
        return this;
    }

    // ── Window / viewport ────────────────────────────────────────────

    /// window → DRect
    DRect window() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[18038])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setWindow(QRect ptr)
    QPainter setWindow(void* window) {
        (cast(t_v__qp_qp)pFunQt[18039])(_wh, window);
        return this;
    }

    /// setWindow(x, y, w, h)
    QPainter setWindow(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18040])(_wh, x, y, w, h);
        return this;
    }

    /// viewport → DRect
    DRect viewport() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[18041])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setViewport(QRect ptr)
    QPainter setViewport(void* viewport) {
        (cast(t_v__qp_qp)pFunQt[18042])(_wh, viewport);
        return this;
    }

    /// setViewport(x, y, w, h)
    QPainter setViewport(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18043])(_wh, x, y, w, h);
        return this;
    }

    /// setViewTransformEnabled
    QPainter setViewTransformEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[18044])(_wh, enable ? 1 : 0);
        return this;
    }

    /// viewTransformEnabled
    bool viewTransformEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[18045])(_wh);
    }

    // ── Drawing primitives ───────────────────────────────────────────

    /// drawPoint(QPoint ptr)
    QPainter drawPoint(void* p) {
        (cast(t_v__qp_qp)pFunQt[18046])(_wh, p);
        return this;
    }

    /// drawPoint(x, y)
    QPainter drawPoint(int x, int y) {
        (cast(t_v__qp_i_i)pFunQt[18047])(_wh, x, y);
        return this;
    }

    /// drawPoints(QPoint[] as void*, count)
    QPainter drawPoints(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18048])(_wh, points, pointCount);
        return this;
    }

    /// drawLine(x1, y1, x2, y2)
    QPainter drawLine(int x1, int y1, int x2, int y2) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18049])(_wh, x1, y1, x2, y2);
        return this;
    }

    /// drawLine(QPoint p1, QPoint p2)
    QPainter drawLine(void* p1, void* p2) {
        (cast(t_v__qp_qp_qp)pFunQt[18050])(_wh, p1, p2);
        return this;
    }

    /// drawLines(QLine[] as void*, count)
    QPainter drawLines(void* lines, int lineCount) {
        (cast(t_v__qp_qp_i)pFunQt[18051])(_wh, lines, lineCount);
        return this;
    }

    /// drawRect(x, y, w, h)
    QPainter drawRect(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18052])(_wh, x, y, w, h);
        return this;
    }

    /// drawRect(QRect ptr)
    QPainter drawRect(void* rect) {
        (cast(t_v__qp_qp)pFunQt[18053])(_wh, rect);
        return this;
    }

    /// drawRects(QRect[] as void*, count)
    QPainter drawRects(void* rects, int rectCount) {
        (cast(t_v__qp_qp_i)pFunQt[18054])(_wh, rects, rectCount);
        return this;
    }

    /// drawEllipse(QRect ptr)
    QPainter drawEllipse(void* r) {
        (cast(t_v__qp_qp)pFunQt[18055])(_wh, r);
        return this;
    }

    /// drawEllipse(x, y, w, h)
    QPainter drawEllipse(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18056])(_wh, x, y, w, h);
        return this;
    }

    /// drawEllipse(QPoint center, rx, ry)
    QPainter drawEllipse(void* center, int rx, int ry) {
        (cast(t_v__qp_qp_i_i)pFunQt[18057])(_wh, center, rx, ry);
        return this;
    }

    /// drawPolyline(QPoint[] as void*, count)
    QPainter drawPolyline(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18058])(_wh, points, pointCount);
        return this;
    }

    /// drawPolygon(QPoint[] as void*, count, Qt::FillRule)
    QPainter drawPolygon(void* points, int pointCount, int fillRule = 0) {
        (cast(t_v__qp_qp_i_i)pFunQt[18059])(_wh, points, pointCount, fillRule);
        return this;
    }

    /// drawConvexPolygon(QPoint[] as void*, count)
    QPainter drawConvexPolygon(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18060])(_wh, points, pointCount);
        return this;
    }

    // ── Arcs, pies, chords ──────────────────────────────────────────

    /// drawArc(QRect ptr, startAngle, spanAngle) — angles in 1/16th degree
    QPainter drawArc(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18061])(_wh, rect, a, alen);
        return this;
    }

    /// drawArc(x, y, w, h, startAngle, spanAngle)
    QPainter drawArc(int x, int y, int w, int h, int a, int alen) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[18062])(_wh, x, y, w, h, a, alen);
        return this;
    }

    /// drawPie(x, y, w, h, startAngle, spanAngle)
    QPainter drawPie(int x, int y, int w, int h, int a, int alen) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[18063])(_wh, x, y, w, h, a, alen);
        return this;
    }

    /// drawPie(QRect ptr, startAngle, spanAngle)
    QPainter drawPie(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18064])(_wh, rect, a, alen);
        return this;
    }

    /// drawChord(x, y, w, h, startAngle, spanAngle)
    QPainter drawChord(int x, int y, int w, int h, int a, int alen) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[18065])(_wh, x, y, w, h, a, alen);
        return this;
    }

    /// drawChord(QRect ptr, startAngle, spanAngle)
    QPainter drawChord(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18066])(_wh, rect, a, alen);
        return this;
    }

    /// drawRoundedRect(x, y, w, h, xRadius, yRadius, Qt::SizeMode)
    QPainter drawRoundedRect(int x, int y, int w, int h, double xRadius, double yRadius, int mode = 0) {
        (cast(t_v__qp_i_i_i_i_d_d_i)pFunQt[18067])(_wh, x, y, w, h, xRadius, yRadius, mode);
        return this;
    }

    /// drawRoundedRect(QRect ptr, xRadius, yRadius, Qt::SizeMode)
    QPainter drawRoundedRect(void* rect, double xRadius, double yRadius, int mode = 0) {
        (cast(t_v__qp_qp_d_d_i)pFunQt[18068])(_wh, rect, xRadius, yRadius, mode);
        return this;
    }

    /// drawRoundRect(x, y, w, h, xround, yround) — deprecated
    QPainter drawRoundRect(int x, int y, int w, int h, int xround = 25, int yround = 25) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[18069])(_wh, x, y, w, h, xround, yround);
        return this;
    }

    /// drawRoundRect(QRect ptr, xround, yround) — deprecated
    QPainter drawRoundRect(void* r, int xround = 25, int yround = 25) {
        (cast(t_v__qp_qp_i_i)pFunQt[18070])(_wh, r, xround, yround);
        return this;
    }

    // ── Layout direction ─────────────────────────────────────────────

    /// setLayoutDirection
    QPainter setLayoutDirection(int direction) {
        (cast(t_v__qp_i)pFunQt[18071])(_wh, direction);
        return this;
    }

    /// layoutDirection
    int layoutDirection() {
        return cast(int)(cast(t_i__qp)pFunQt[18072])(_wh);
    }

    // ── Text ─────────────────────────────────────────────────────────

    /// drawText at QPoint
    QPainter drawText(void* p, string s) {
        auto _ws_s = toQString(s);
        (cast(t_v__qp_qp_qp)pFunQt[18073])(_wh, p, _ws_s);
        (cast(t_v__qp)pFunQt[22])(_ws_s);
        return this;
    }

    /// drawText at (x, y)
    QPainter drawText(int x, int y, string s) {
        auto _ws_s = toQString(s);
        (cast(t_v__qp_i_i_qp)pFunQt[18074])(_wh, x, y, _ws_s);
        (cast(t_v__qp)pFunQt[22])(_ws_s);
        return this;
    }

    /// drawText in QRect with flags
    QPainter drawText(void* r, int flags, string text, void* br = null) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp_i_qp_qp)pFunQt[18075])(_wh, r, flags, _ws_text, br);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// drawText in rect (x, y, w, h) with flags
    QPainter drawText(int x, int y, int w, int h, int flags, string text, void* br = null) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_i_i_i_i_qp_qp)pFunQt[18076])(_wh, x, y, w, h, flags, _ws_text, br);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// boundingRect(QRect, flags, text) → DRect
    DRect boundingRect(void* rect, int flags, string text) {
        auto _ws_text = toQString(text);
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp_i_qp)pFunQt[18077])(_wh, rect, flags, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// boundingRect(x, y, w, h, flags, text) → DRect
    DRect boundingRect(int x, int y, int w, int h, int flags, string text) {
        auto _ws_text = toQString(text);
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_i_i_i_i_i_qp)pFunQt[18078])(_wh, x, y, w, h, flags, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    // ── Fill / erase ─────────────────────────────────────────────────

    /// fillRect(x, y, w, h, QColor ptr)
    QPainter fillRect(int x, int y, int w, int h, void* color) {
        (cast(t_v__qp_i_i_i_i_qp)pFunQt[18079])(_wh, x, y, w, h, color);
        return this;
    }

    /// fillRect(QRect ptr, QColor ptr)
    QPainter fillRect(void* rect, void* color) {
        (cast(t_v__qp_qp_qp)pFunQt[18080])(_wh, rect, color);
        return this;
    }

    /// fillRect(x, y, w, h, Qt::GlobalColor or Qt::BrushStyle)
    QPainter fillRect(int x, int y, int w, int h, int c) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[18081])(_wh, x, y, w, h, c);
        return this;
    }

    /// fillRect(QRect ptr, Qt::GlobalColor or Qt::BrushStyle)
    QPainter fillRect(void* rect, int c) {
        (cast(t_v__qp_qp_i)pFunQt[18082])(_wh, rect, c);
        return this;
    }

    /// eraseRect(x, y, w, h)
    QPainter eraseRect(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18083])(_wh, x, y, w, h);
        return this;
    }

    /// eraseRect(QRect ptr)
    QPainter eraseRect(void* rect) {
        (cast(t_v__qp_qp)pFunQt[18084])(_wh, rect);
        return this;
    }

    // ── Render hints ─────────────────────────────────────────────────

    /// setRenderHint(hint, on=true)
    QPainter setRenderHint(int hint, bool on = true) {
        (cast(t_v__qp_i_i)pFunQt[18085])(_wh, hint, on ? 1 : 0);
        return this;
    }

    /// setRenderHints(hints, on=true)
    QPainter setRenderHints(int hints, bool on = true) {
        (cast(t_v__qp_i_i)pFunQt[18086])(_wh, hints, on ? 1 : 0);
        return this;
    }

    /// renderHints
    int renderHints() {
        return cast(int)(cast(t_i__qp)pFunQt[18087])(_wh);
    }

    // ── Misc ─────────────────────────────────────────────────────────

    /// paintEngine
    void* paintEngine() {
        return cast(void*)(cast(t_qp__qp)pFunQt[18088])(_wh);
    }

    /// setRedirected (static in Qt, _obj unused)
    QPainter setRedirected(void* device, void* replacement, void* offset) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18089])(_wh, device, replacement, offset);
        return this;
    }

    /// redirected (static in Qt, _obj unused)
    void* redirected(void* device, void* offset) {
        return cast(void*)(cast(t_qp__qp_qp_qp)pFunQt[18090])(_wh, device, offset);
    }

    /// restoreRedirected (static in Qt, _obj unused)
    QPainter restoreRedirected(void* device) {
        (cast(t_v__qp_qp)pFunQt[18091])(_wh, device);
        return this;
    }

    /// beginNativePainting
    QPainter beginNativePainting() {
        (cast(t_v__qp)pFunQt[18092])(_wh);
        return this;
    }

    /// endNativePainting
    QPainter endNativePainting() {
        (cast(t_v__qp)pFunQt[18093])(_wh);
        return this;
    }

    // ── Draw image / pixmap ─────────────────────────────────────────

    /// drawImage(dstRect, QImage, srcRect) — scaled blit
    QPainter drawImage(int x, int y, int w, int h, void* image, int sx = 0, int sy = 0, int sw = -1, int sh = -1) {
        (cast(t_v__qp_i_i_i_i_qp_i_i_i_i)pFunQt[18094])(_wh, x, y, w, h, image, sx, sy, sw, sh);
        return this;
    }

    /// drawImage at (x, y) — no scaling
    QPainter drawImageAt(int x, int y, void* image) {
        (cast(t_v__qp_i_i_qp)pFunQt[18095])(_wh, x, y, image);
        return this;
    }

    /// drawPixmap(dstRect, QPixmap, srcRect) — scaled blit
    QPainter drawPixmap(int x, int y, int w, int h, void* pixmap, int sx = 0, int sy = 0, int sw = -1, int sh = -1) {
        (cast(t_v__qp_i_i_i_i_qp_i_i_i_i)pFunQt[18096])(_wh, x, y, w, h, pixmap, sx, sy, sw, sh);
        return this;
    }

    /// drawPixmap at (x, y) — no scaling
    QPainter drawPixmapAt(int x, int y, void* pixmap) {
        (cast(t_v__qp_i_i_qp)pFunQt[18097])(_wh, x, y, pixmap);
        return this;
    }


    // ── Дополнено 2026-07-26 (augment) ─────────────────────────

    /// setBrushOrigin
    QPainter setBrushOrigin_qpointf(void* p0) {
        (cast(t_v__qp_qp)pFunQt[18102])(_wh, p0);
        return this;
    }
    /// setClipRect
    QPainter setClipRect_qrectf_qt_clipoperation(void* p0, int op) {
        (cast(t_v__qp_qp_i)pFunQt[18103])(_wh, p0, op);
        return this;
    }
    /// setClipRect
    QPainter setClipRect_qrect_qt_clipoperation(void* p0, int op) {
        (cast(t_v__qp_qp_i)pFunQt[18104])(_wh, p0, op);
        return this;
    }
    /// clipBoundingRect
    void* clipBoundingRect() {
        return (cast(t_qp__qp)pFunQt[18106])(_wh);
    }
    /// translate
    QPainter translate_qpointf(void* offset) {
        (cast(t_v__qp_qp)pFunQt[18107])(_wh, offset);
        return this;
    }
    /// drawPoint
    QPainter drawPoint_qpointf(void* pt) {
        (cast(t_v__qp_qp)pFunQt[18114])(_wh, pt);
        return this;
    }
    /// drawPoints
    QPainter drawPoints_qpointf_int(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18117])(_wh, points, pointCount);
        return this;
    }
    /// drawLine
    QPainter drawLine_qpointf_qpointf(void* p1, void* p2) {
        (cast(t_v__qp_qp_qp)pFunQt[18121])(_wh, p1, p2);
        return this;
    }
    /// drawLines
    QPainter drawLines_qlinef_int(void* lines, int lineCount) {
        (cast(t_v__qp_qp_i)pFunQt[18122])(_wh, lines, lineCount);
        return this;
    }
    /// drawLines
    QPainter drawLines_qpointf_int(void* pointPairs, int lineCount) {
        (cast(t_v__qp_qp_i)pFunQt[18123])(_wh, pointPairs, lineCount);
        return this;
    }
    /// drawLines
    QPainter drawLines_qpoint_int(void* pointPairs, int lineCount) {
        (cast(t_v__qp_qp_i)pFunQt[18125])(_wh, pointPairs, lineCount);
        return this;
    }
    /// drawRect
    QPainter drawRect_qrectf(void* rect) {
        (cast(t_v__qp_qp)pFunQt[18126])(_wh, rect);
        return this;
    }
    /// drawRect
    QPainter drawRect_int_int_int_int(int x1, int y1, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18127])(_wh, x1, y1, w, h);
        return this;
    }
    /// drawRects
    QPainter drawRects_qrectf_int(void* rects, int rectCount) {
        (cast(t_v__qp_qp_i)pFunQt[18129])(_wh, rects, rectCount);
        return this;
    }
    /// drawEllipse
    QPainter drawEllipse_qrectf(void* r) {
        (cast(t_v__qp_qp)pFunQt[18131])(_wh, r);
        return this;
    }
    /// drawEllipse
    QPainter drawEllipse(void* center, double rx, double ry) {
        (cast(t_v__qp_qp_d_d)pFunQt[18134])(_wh, center, rx, ry);
        return this;
    }
    /// drawPolyline
    QPainter drawPolyline_qpointf_int(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18136])(_wh, points, pointCount);
        return this;
    }
    /// drawPolygon
    QPainter drawPolygon_qpointf_int_qt_fillrule(void* points, int pointCount, int fillRule) {
        (cast(t_v__qp_qp_i_i)pFunQt[18138])(_wh, points, pointCount, fillRule);
        return this;
    }
    /// drawConvexPolygon
    QPainter drawConvexPolygon_qpointf_int(void* points, int pointCount) {
        (cast(t_v__qp_qp_i)pFunQt[18140])(_wh, points, pointCount);
        return this;
    }
    /// drawArc
    QPainter drawArc_qrectf_int_int(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18142])(_wh, rect, a, alen);
        return this;
    }
    /// drawArc
    QPainter drawArc_qrect_int_int(void* p0, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18143])(_wh, p0, a, alen);
        return this;
    }
    /// drawPie
    QPainter drawPie_qrectf_int_int(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18145])(_wh, rect, a, alen);
        return this;
    }
    /// drawPie
    QPainter drawPie_qrect_int_int(void* p0, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18147])(_wh, p0, a, alen);
        return this;
    }
    /// drawChord
    QPainter drawChord_qrectf_int_int(void* rect, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18148])(_wh, rect, a, alen);
        return this;
    }
    /// drawChord
    QPainter drawChord_qrect_int_int(void* p0, int a, int alen) {
        (cast(t_v__qp_qp_i_i)pFunQt[18150])(_wh, p0, a, alen);
        return this;
    }
    /// drawRoundedRect
    QPainter drawRoundedRect_qrectf_qreal_qreal_qt_sizemode(void* rect, double xRadius, double yRadius, int mode) {
        (cast(t_v__qp_qp_d_d_i)pFunQt[18151])(_wh, rect, xRadius, yRadius, mode);
        return this;
    }
    /// drawRoundRect
    QPainter drawRoundRect_qrectf_int_int(void* r, int xround, int yround) {
        (cast(t_v__qp_qp_i_i)pFunQt[18154])(_wh, r, xround, yround);
        return this;
    }
    /// drawRoundRect
    QPainter drawRoundRect_int_int_int_int_int_int(int x, int y, int w, int h, int p4, int p5) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[18155])(_wh, x, y, w, h, p4, p5);
        return this;
    }
    /// drawTiledPixmap
    QPainter drawTiledPixmap_qrectf_qpixmap_qpointf(void* rect, void* pm, void* offset) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18157])(_wh, rect, pm, offset);
        return this;
    }
    /// drawTiledPixmap
    QPainter drawTiledPixmap(int x, int y, int w, int h, void* p4, int sx, int sy) {
        (cast(t_v__qp_i_i_i_i_qp_i_i)pFunQt[18158])(_wh, x, y, w, h, p4, sx, sy);
        return this;
    }
    /// drawTiledPixmap
    QPainter drawTiledPixmap_qrect_qpixmap_qpoint(void* p0, void* p1, void* p2) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18159])(_wh, p0, p1, p2);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qrectf_qpixmap_qrectf(void* targetRect, void* pixmap, void* sourceRect) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18160])(_wh, targetRect, pixmap, sourceRect);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qrect_qpixmap_qrect(void* targetRect, void* pixmap, void* sourceRect) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18161])(_wh, targetRect, pixmap, sourceRect);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_int_int_int_int_qpixmap_int_int_int_int(int x, int y, int w, int h, void* pm, int sx, int sy, int sw, int sh) {
        (cast(t_v__qp_i_i_i_i_qp_i_i_i_i)pFunQt[18162])(_wh, x, y, w, h, pm, sx, sy, sw, sh);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap(int x, int y, void* pm, int sx, int sy, int sw, int sh) {
        (cast(t_v__qp_i_i_qp_i_i_i_i)pFunQt[18163])(_wh, x, y, pm, sx, sy, sw, sh);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qpointf_qpixmap_qrectf(void* p, void* pm, void* sr) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18164])(_wh, p, pm, sr);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qpoint_qpixmap_qrect(void* p, void* pm, void* sr) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[18165])(_wh, p, pm, sr);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qpointf_qpixmap(void* p, void* pm) {
        (cast(t_v__qp_qp_qp)pFunQt[18166])(_wh, p, pm);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qpoint_qpixmap(void* p, void* pm) {
        (cast(t_v__qp_qp_qp)pFunQt[18167])(_wh, p, pm);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap(int x, int y, void* pm) {
        (cast(t_v__qp_i_i_qp)pFunQt[18168])(_wh, x, y, pm);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap_qrect_qpixmap(void* r, void* pm) {
        (cast(t_v__qp_qp_qp)pFunQt[18169])(_wh, r, pm);
        return this;
    }
    /// drawPixmap
    QPainter drawPixmap(int x, int y, int w, int h, void* pm) {
        (cast(t_v__qp_i_i_i_i_qp)pFunQt[18170])(_wh, x, y, w, h, pm);
        return this;
    }
    /// drawImage
    QPainter drawImage_qrectf_qimage_qrectf_qt_imageconversionflags(void* targetRect, void* image, void* sourceRect, int flags) {
        (cast(t_v__qp_qp_qp_qp_i)pFunQt[18171])(_wh, targetRect, image, sourceRect, flags);
        return this;
    }
    /// drawImage
    QPainter drawImage_qrect_qimage_qrect_qt_imageconversionflags(void* targetRect, void* image, void* sourceRect, int flags) {
        (cast(t_v__qp_qp_qp_qp_i)pFunQt[18172])(_wh, targetRect, image, sourceRect, flags);
        return this;
    }
    /// drawImage
    QPainter drawImage_qpointf_qimage_qrectf_qt_imageconversionflags(void* p, void* image, void* sr, int flags) {
        (cast(t_v__qp_qp_qp_qp_i)pFunQt[18173])(_wh, p, image, sr, flags);
        return this;
    }
    /// drawImage
    QPainter drawImage_qpoint_qimage_qrect_qt_imageconversionflags(void* p, void* image, void* sr, int flags) {
        (cast(t_v__qp_qp_qp_qp_i)pFunQt[18174])(_wh, p, image, sr, flags);
        return this;
    }
    /// drawImage
    QPainter drawImage_qrectf_qimage(void* r, void* image) {
        (cast(t_v__qp_qp_qp)pFunQt[18175])(_wh, r, image);
        return this;
    }
    /// drawImage
    QPainter drawImage_qrect_qimage(void* r, void* image) {
        (cast(t_v__qp_qp_qp)pFunQt[18176])(_wh, r, image);
        return this;
    }
    /// drawImage
    QPainter drawImage_qpointf_qimage(void* p, void* image) {
        (cast(t_v__qp_qp_qp)pFunQt[18177])(_wh, p, image);
        return this;
    }
    /// drawImage
    QPainter drawImage_qpoint_qimage(void* p, void* image) {
        (cast(t_v__qp_qp_qp)pFunQt[18178])(_wh, p, image);
        return this;
    }
    /// drawImage
    QPainter drawImage(int x, int y, void* image, int sx, int sy, int sw, int sh, int flags) {
        (cast(t_v__qp_i_i_qp_i_i_i_i_i)pFunQt[18179])(_wh, x, y, image, sx, sy, sw, sh, flags);
        return this;
    }
    /// drawText
    QPainter drawText_qpointf_qstring(void* p, string s) {
        import std.utf : toUTF16;
        wstring _ws_s = s.toUTF16;
        (cast(t_v__qp_qp_qp_i)pFunQt[18180])(_wh, p, cast(void*)_ws_s.ptr, cast(int)_ws_s.length);
        return this;
    }
    /// drawText
    QPainter drawText_qpoint_qstring(void* p, string s) {
        import std.utf : toUTF16;
        wstring _ws_s = s.toUTF16;
        (cast(t_v__qp_qp_qp_i)pFunQt[18181])(_wh, p, cast(void*)_ws_s.ptr, cast(int)_ws_s.length);
        return this;
    }
    /// drawText
    QPainter drawText_int_int_qstring(int x, int y, string s) {
        import std.utf : toUTF16;
        wstring _ws_s = s.toUTF16;
        (cast(t_v__qp_i_i_qp_i)pFunQt[18182])(_wh, x, y, cast(void*)_ws_s.ptr, cast(int)_ws_s.length);
        return this;
    }
    /// drawText
    QPainter drawText(void* p, string str, int tf, int justificationPadding) {
        import std.utf : toUTF16;
        wstring _ws_str = str.toUTF16;
        (cast(t_v__qp_qp_qp_i_i_i)pFunQt[18183])(_wh, p, cast(void*)_ws_str.ptr, cast(int)_ws_str.length, tf, justificationPadding);
        return this;
    }
    /// drawText
    QPainter drawText_qrectf_int_qstring_qrectf(void* r, int flags, string text, void* br) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        (cast(t_v__qp_qp_i_qp_i_qp)pFunQt[18184])(_wh, r, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length, br);
        return this;
    }
    /// drawText
    QPainter drawText_qrect_int_qstring_qrect(void* r, int flags, string text, void* br) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        (cast(t_v__qp_qp_i_qp_i_qp)pFunQt[18185])(_wh, r, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length, br);
        return this;
    }
    /// drawText
    QPainter drawText_int_int_int_int_int_qstring_qrect(int x, int y, int w, int h, int flags, string text, void* br) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        (cast(t_v__qp_i_i_i_i_i_qp_i_qp)pFunQt[18186])(_wh, x, y, w, h, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length, br);
        return this;
    }
    /// drawText
    QPainter drawText_qrectf_qstring(void* r, string text) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        (cast(t_v__qp_qp_qp_i)pFunQt[18187])(_wh, r, cast(void*)_ws_text.ptr, cast(int)_ws_text.length);
        return this;
    }
    /// boundingRect
    void* boundingRect_qrectf_int_qstring(void* rect, int flags, string text) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        return (cast(t_qp__qp_qp_i_qp_i)pFunQt[18188])(_wh, rect, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length);
    }
    /// boundingRect
    DRect boundingRect_qrect_int_qstring(void* rect, int flags, string text) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_qp_i_qp_i)pFunQt[18189])(_wh, rect, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }
    /// boundingRect
    DRect boundingRect_int_int_int_int_int_qstring(int x, int y, int w, int h, int flags, string text) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        DRect _vt;
        void* _vtp = (cast(t_qp__qp_i_i_i_i_i_qp_i)pFunQt[18190])(_wh, x, y, w, h, flags, cast(void*)_ws_text.ptr, cast(int)_ws_text.length);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }
    /// boundingRect
    void* boundingRect(void* rect, string text) {
        import std.utf : toUTF16;
        wstring _ws_text = text.toUTF16;
        return (cast(t_qp__qp_qp_qp_i)pFunQt[18191])(_wh, rect, cast(void*)_ws_text.ptr, cast(int)_ws_text.length);
    }
    /// fillRect
    QPainter fillRect_qrectf_qcolor(void* p0, void* color) {
        (cast(t_v__qp_qp_qp)pFunQt[18192])(_wh, p0, color);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrect_qcolor(void* p0, void* color) {
        (cast(t_v__qp_qp_qp)pFunQt[18194])(_wh, p0, color);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrect_qt_globalcolor(void* r, int c) {
        (cast(t_v__qp_qp_i)pFunQt[18196])(_wh, r, c);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrectf_qt_globalcolor(void* r, int c) {
        (cast(t_v__qp_qp_i)pFunQt[18197])(_wh, r, c);
        return this;
    }
    /// fillRect
    QPainter fillRect_int_int_int_int_qt_brushstyle(int x, int y, int w, int h, int style) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[18198])(_wh, x, y, w, h, style);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrect_qt_brushstyle(void* r, int style) {
        (cast(t_v__qp_qp_i)pFunQt[18199])(_wh, r, style);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrectf_qt_brushstyle(void* r, int style) {
        (cast(t_v__qp_qp_i)pFunQt[18239])(_wh, r, style);
        return this;
    }
    /// fillRect
    QPainter fillRect_int_int_int_int_qgradient_preset(int x, int y, int w, int h, int preset) {
        (cast(t_v__qp_i_i_i_i_i)pFunQt[18240])(_wh, x, y, w, h, preset);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrect_qgradient_preset(void* r, int preset) {
        (cast(t_v__qp_qp_i)pFunQt[18241])(_wh, r, preset);
        return this;
    }
    /// fillRect
    QPainter fillRect_qrectf_qgradient_preset(void* r, int preset) {
        (cast(t_v__qp_qp_i)pFunQt[18242])(_wh, r, preset);
        return this;
    }
    /// eraseRect
    QPainter eraseRect_qrectf(void* p0) {
        (cast(t_v__qp_qp)pFunQt[18243])(_wh, p0);
        return this;
    }
    /// eraseRect
    QPainter eraseRect_qrect(void* p0) {
        (cast(t_v__qp_qp)pFunQt[18245])(_wh, p0);
        return this;
    }

    // ── Helpers ──────────────────────────────────────────────────────

    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QPainter
