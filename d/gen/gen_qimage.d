/**
 * gen_qimage.d — wrapper for QImage (value type).
 * DLL: qte56_foundation.dll  |  Index block: 18200–18238, 19999–20000
 */
module gen_qimage;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_i__qp_qp, t_i__qp_qp_i, t_qp__, t_qp__i, t_qp__i_i, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_qp, toQString;
import gen_qbytearray : QByteArray;

// New aliases for this module:
mixin(generateAlias("qp__i_i_i"));         // void*(int, int, int) — create_wh
mixin(generateAlias("v__qp_i_i_i_i"));     // void(void*, int, int, int, int) — fill_rgb
mixin(generateAlias("ui__qp_i_i"));        // uint(void*, int, int) — pixel
mixin(generateAlias("v__qp_i_i_ui"));      // void(void*, int, int, uint) — setPixel
mixin(generateAlias("qp__qp_i_i"));        // void*(void*, int, int) — scaledToWidth/Height, mirrored, pixelColor
mixin(generateAlias("v__qp_i_i_qp"));      // void(void*, int, int, void*) — setPixelColor
mixin(generateAlias("i__qp_i_i"));         // int(void*, int, int) — valid
mixin(generateAlias("i__qp_qp_i_i"));      // int(void*, void*, int, int) — save(path, len, quality)
mixin(generateAlias("qp__qp_i_i_i_i"));    // void*(void*, int, int, int, int) — scaled, copy_rect
mixin(generateAlias("i__qp_qp_i_qp_i"));  // int(void*, void*, int, void*, int) — loadFromData
mixin(generateAlias("qp__qp_qp_i_i"));    // void*(void*, void*, int, int) — saveToBuffer

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQImage() {
    // Lifecycle
    mixin(generateFunQt(18200, "qteQImage_create",           "QImage"));
    mixin(generateFunQt(18201, "qteQImage_create_wh",        "QImage"));
    mixin(generateFunQt(18202, "qteQImage_from_file",        "QImage"));
    mixin(generateFunQt(18203, "qteQImage_delete",           "QImage"));
    // Properties
    mixin(generateFunQt(18204, "qteQImage_isNull",           "QImage"));
    mixin(generateFunQt(18205, "qteQImage_width",            "QImage"));
    mixin(generateFunQt(18206, "qteQImage_height",           "QImage"));
    mixin(generateFunQt(18207, "qteQImage_depth",            "QImage"));
    mixin(generateFunQt(18208, "qteQImage_format",           "QImage"));
    mixin(generateFunQt(18209, "qteQImage_bytesPerLine",     "QImage"));
    mixin(generateFunQt(18210, "qteQImage_sizeInBytes",      "QImage"));
    // Raw data
    mixin(generateFunQt(18211, "qteQImage_bits",             "QImage"));
    mixin(generateFunQt(18212, "qteQImage_constBits",        "QImage"));
    // Fill
    mixin(generateFunQt(18213, "qteQImage_fill_rgb",         "QImage"));
    mixin(generateFunQt(18214, "qteQImage_fill_gc",          "QImage"));
    // Pixel access
    mixin(generateFunQt(18215, "qteQImage_pixel",            "QImage"));
    mixin(generateFunQt(18216, "qteQImage_setPixel",         "QImage"));
    mixin(generateFunQt(18217, "qteQImage_pixelColor",       "QImage"));
    mixin(generateFunQt(18218, "qteQImage_setPixelColor",    "QImage"));
    mixin(generateFunQt(18219, "qteQImage_valid",            "QImage"));
    // Load / Save
    mixin(generateFunQt(18220, "qteQImage_load",             "QImage"));
    mixin(generateFunQt(18221, "qteQImage_save",             "QImage"));
    // Transforms
    mixin(generateFunQt(18222, "qteQImage_scaled",           "QImage"));
    mixin(generateFunQt(18223, "qteQImage_scaledToWidth",    "QImage"));
    mixin(generateFunQt(18224, "qteQImage_scaledToHeight",   "QImage"));
    mixin(generateFunQt(18225, "qteQImage_mirrored",         "QImage"));
    mixin(generateFunQt(18226, "qteQImage_copy_rect",        "QImage"));
    mixin(generateFunQt(18227, "qteQImage_convertToFormat",  "QImage"));
    mixin(generateFunQt(18228, "qteQImage_invertPixels",     "QImage"));
    // Alpha
    mixin(generateFunQt(18229, "qteQImage_hasAlphaChannel",  "QImage"));
    mixin(generateFunQt(18230, "qteQImage_setAlphaChannel",  "QImage"));
    mixin(generateFunQt(18231, "qteQImage_createAlphaMask",  "QImage"));
    // Misc
    mixin(generateFunQt(18232, "qteQImage_rgbSwapped",       "QImage"));
    mixin(generateFunQt(18233, "qteQImage_toPixmap",         "QImage"));
    mixin(generateFunQt(18234, "qteQImage_fromPixmap",       "QImage"));
    // DPI
    mixin(generateFunQt(18235, "qteQImage_setDotsPerMeterX", "QImage"));
    mixin(generateFunQt(18236, "qteQImage_setDotsPerMeterY", "QImage"));
    mixin(generateFunQt(18237, "qteQImage_dotsPerMeterX",    "QImage"));
    mixin(generateFunQt(18238, "qteQImage_dotsPerMeterY",    "QImage"));
    // Memory I/O
    mixin(generateFunQt(19999, "qteQImage_loadFromData",     "QImage"));
    mixin(generateFunQt(20000, "qteQImage_saveToBuffer",     "QImage"));
}

static this() {
    registerModule("QImage", "qte56_foundation.dll", &loadQImage);
}

// ====================================================================
// Class wrapper — value type (like QPixmap, QColor)
// ====================================================================

/// D wrapper for Qt class QImage (value type — no parent widget).
@live class QImage {
    /// QImage::Format enum constants
    enum Format : int {
        Invalid                = 0,
        Mono                   = 1,
        MonoLSB                = 2,
        Indexed8               = 3,
        RGB32                  = 4,
        ARGB32                 = 5,
        ARGB32_Premultiplied   = 6,
        RGB16                  = 7,
        ARGB8565_Premultiplied = 8,
        RGB666                 = 9,
        ARGB6666_Premultiplied = 10,
        RGB555                 = 11,
        ARGB8555_Premultiplied = 12,
        RGB888                 = 13,
        RGB444                 = 14,
        ARGB4444_Premultiplied = 15,
        RGBX8888               = 16,
        RGBA8888               = 17,
        RGBA8888_Premultiplied = 18,
        Grayscale8             = 24,
        Alpha8                 = 23,
    }

private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap()
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create an empty (null) image.
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[18200])();
    }

    /// Create image with given size and format.
    /// Default format: ARGB32 (5).
    this(int w, int h, int format = Format.ARGB32) {
        _qt_owned = false;
        _wh = (cast(t_qp__i_i_i)pFunQt[18201])(w, h, format);
    }

    /// Load image from file path.
    this(string path) {
        _qt_owned = false;
        auto _ws = toQString(path);
        _wh = (cast(t_qp__qp)pFunQt[18202])(_ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[18203] !is null) {
            (cast(t_v__qp)pFunQt[18203])(_wh);
            _wh = null;
        }
    }

    /// Raw Qt object handle.
    void* getWH() { return _wh; }

    /// Wrap a heap-allocated C++ QImage* — D takes ownership.
    static QImage wrap(void* ptr) {
        if (ptr is null) return null;
        auto img = new QImage(false);
        img._wh = ptr;
        return img;
    }

    // ── Properties ────────────────────────────────────────────────────────

    bool isNull() {
        return cast(bool)(cast(t_i__qp)pFunQt[18204])(_wh);
    }

    int width() {
        return cast(int)(cast(t_i__qp)pFunQt[18205])(_wh);
    }

    int height() {
        return cast(int)(cast(t_i__qp)pFunQt[18206])(_wh);
    }

    int depth() {
        return cast(int)(cast(t_i__qp)pFunQt[18207])(_wh);
    }

    int format() {
        return cast(int)(cast(t_i__qp)pFunQt[18208])(_wh);
    }

    int bytesPerLine() {
        return cast(int)(cast(t_i__qp)pFunQt[18209])(_wh);
    }

    int sizeInBytes() {
        return cast(int)(cast(t_i__qp)pFunQt[18210])(_wh);
    }

    // ── Raw data access ───────────────────────────────────────────────────

    /// Mutable pointer to pixel data.
    void* bits() {
        return cast(void*)(cast(t_qp__qp)pFunQt[18211])(_wh);
    }

    /// Const pointer to pixel data.
    void* constBits() {
        return cast(void*)(cast(t_qp__qp)pFunQt[18212])(_wh);
    }

    // ── Fill ──────────────────────────────────────────────────────────────

    /// Fill with RGBA color.
    QImage fill(int r, int g, int b, int a = 255) {
        (cast(t_v__qp_i_i_i_i)pFunQt[18213])(_wh, r, g, b, a);
        return this;
    }

    /// Fill with Qt::GlobalColor.
    QImage fillGlobal(int gc) {
        (cast(t_v__qp_i)pFunQt[18214])(_wh, gc);
        return this;
    }

    // ── Pixel access ──────────────────────────────────────────────────────

    /// pixel(x, y) → QRgb (uint).
    uint pixel(int x, int y) {
        return cast(uint)(cast(t_ui__qp_i_i)pFunQt[18215])(_wh, x, y);
    }

    /// setPixel(x, y, QRgb).
    QImage setPixel(int x, int y, uint rgb) {
        (cast(t_v__qp_i_i_ui)pFunQt[18216])(_wh, x, y, rgb);
        return this;
    }

    /// pixelColor(x, y) → new QColor (heap). Caller owns result.
    void* pixelColor(int x, int y) {
        return cast(void*)(cast(t_qp__qp_i_i)pFunQt[18217])(_wh, x, y);
    }

    /// setPixelColor(x, y, QColor ptr).
    QImage setPixelColor(int x, int y, void* color) {
        (cast(t_v__qp_i_i_qp)pFunQt[18218])(_wh, x, y, color);
        return this;
    }

    /// valid(x, y) — check if coordinates are within image bounds.
    bool valid(int x, int y) {
        return cast(bool)(cast(t_i__qp_i_i)pFunQt[18219])(_wh, x, y);
    }

    // ── Load / Save ───────────────────────────────────────────────────────

    /// Load image from file. Returns true on success.
    bool load(string path) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18220])(
            _wh, _ws);
    }

    /// Save image to file. quality: 0–100 (-1 = default). Returns true on success.
    bool save(string path, int quality = -1) {
        auto _ws = toQString(path);
        return cast(bool)(cast(t_i__qp_qp_i)pFunQt[18221])(
            _wh, _ws, quality);
    }

    /// Load image from memory buffer. fmt: "PNG", "JPEG", "" = auto-detect.
    bool loadFromData(const(ubyte)[] data, string fmt = "") {
        return (cast(t_i__qp_qp_i_qp_i)pFunQt[19999])(
            _wh, cast(void*)data.ptr, cast(int)data.length,
            cast(void*)fmt.ptr, cast(int)fmt.length) != 0;
    }

    /// Save image to a QByteArray in memory. fmt: "PNG", "JPEG", etc. (default "PNG").
    /// Returns null QByteArray if save failed.
    QByteArray saveToBuffer(string fmt = "PNG", int quality = -1) {
        void* ba = (cast(t_qp__qp_qp_i_i)pFunQt[20000])(
            _wh, cast(void*)fmt.ptr, cast(int)fmt.length, quality);
        return QByteArray.wrap(ba);
    }

    // ── Transforms ────────────────────────────────────────────────────────

    /// Return a scaled copy.
    /// aspectMode: 0=Ignore, 1=KeepAspectRatio, 2=KeepByExpanding.
    /// transformMode: 0=FastTransformation, 1=SmoothTransformation.
    QImage scaled(int w, int h, int aspectMode = 1, int transformMode = 0) {
        void* ptr = (cast(t_qp__qp_i_i_i_i)pFunQt[18222])(_wh, w, h, aspectMode, transformMode);
        return QImage.wrap(ptr);
    }

    /// Scaled to width (preserving aspect ratio).
    QImage scaledToWidth(int w, int mode = 0) {
        void* ptr = (cast(t_qp__qp_i_i)pFunQt[18223])(_wh, w, mode);
        return QImage.wrap(ptr);
    }

    /// Scaled to height (preserving aspect ratio).
    QImage scaledToHeight(int h, int mode = 0) {
        void* ptr = (cast(t_qp__qp_i_i)pFunQt[18224])(_wh, h, mode);
        return QImage.wrap(ptr);
    }

    /// Return a mirrored copy.
    QImage mirrored(bool horiz = false, bool vert = true) {
        void* ptr = (cast(t_qp__qp_i_i)pFunQt[18225])(_wh, horiz ? 1 : 0, vert ? 1 : 0);
        return QImage.wrap(ptr);
    }

    /// Return a copy of sub-region.
    QImage copy(int x, int y, int w, int h) {
        void* ptr = (cast(t_qp__qp_i_i_i_i)pFunQt[18226])(_wh, x, y, w, h);
        return QImage.wrap(ptr);
    }

    /// Convert to another pixel format.
    QImage convertToFormat(int fmt) {
        void* ptr = (cast(t_qp__qp_i)pFunQt[18227])(_wh, fmt);
        return QImage.wrap(ptr);
    }

    /// Invert pixels. mode: 0=InvertRgb, 1=InvertRgba.
    QImage invertPixels(int mode = 0) {
        (cast(t_v__qp_i)pFunQt[18228])(_wh, mode);
        return this;
    }

    // ── Alpha ─────────────────────────────────────────────────────────────

    bool hasAlphaChannel() {
        return cast(bool)(cast(t_i__qp)pFunQt[18229])(_wh);
    }

    QImage setAlphaChannel(void* alphaImage) {
        (cast(t_v__qp_qp)pFunQt[18230])(_wh, alphaImage);
        return this;
    }

    QImage createAlphaMask() {
        void* ptr = (cast(t_qp__qp)pFunQt[18231])(_wh);
        return QImage.wrap(ptr);
    }

    // ── Misc ──────────────────────────────────────────────────────────────

    QImage rgbSwapped() {
        void* ptr = (cast(t_qp__qp)pFunQt[18232])(_wh);
        return QImage.wrap(ptr);
    }

    /// Convert this QImage to QPixmap. Returns heap-allocated QPixmap*.
    /// Use: auto px = QPixmap.wrap(img.toPixmap());
    void* toPixmap() {
        return cast(void*)(cast(t_qp__qp)pFunQt[18233])(_wh);
    }

    /// Convert QPixmap to QImage (static). Pass pixmap.getWH().
    /// Returns heap-allocated QImage.
    static QImage fromPixmap(void* pixmap) {
        void* ptr = (cast(t_qp__qp)pFunQt[18234])(pixmap);
        return QImage.wrap(ptr);
    }

    // ── DPI ───────────────────────────────────────────────────────────────

    QImage setDotsPerMeterX(int dpm) {
        (cast(t_v__qp_i)pFunQt[18235])(_wh, dpm);
        return this;
    }

    QImage setDotsPerMeterY(int dpm) {
        (cast(t_v__qp_i)pFunQt[18236])(_wh, dpm);
        return this;
    }

    int dotsPerMeterX() {
        return cast(int)(cast(t_i__qp)pFunQt[18237])(_wh);
    }

    int dotsPerMeterY() {
        return cast(int)(cast(t_i__qp)pFunQt[18238])(_wh);
    }
}
