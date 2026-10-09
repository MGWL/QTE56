/**
 * gen_qimagereader.d — wrapper for QImageReader (value type).
 * DLL: qte56_foundation.dll  |  Index block: 18300–18318
 */
module gen_qimagereader;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));           // int(void*, int) — jumpToImage
mixin(generateAlias("i__qp_qp_i"));        // int(void*, void*, int) — fileName/errorString(obj, buf, buf_len)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQImageReader() {
    // Lifecycle
    mixin(generateFunQt(18300, "qteQImageReader_create",                  "QImageReader"));
    mixin(generateFunQt(18301, "qteQImageReader_create_file",             "QImageReader"));
    mixin(generateFunQt(18302, "qteQImageReader_delete",                  "QImageReader"));
    // File
    mixin(generateFunQt(18303, "qteQImageReader_setFileName",             "QImageReader"));
    mixin(generateFunQt(18304, "qteQImageReader_fileName",                "QImageReader"));
    // Read
    mixin(generateFunQt(18305, "qteQImageReader_canRead",                 "QImageReader"));
    mixin(generateFunQt(18306, "qteQImageReader_read",                    "QImageReader"));
    // Format
    mixin(generateFunQt(18307, "qteQImageReader_format",                  "QImageReader"));
    mixin(generateFunQt(18308, "qteQImageReader_setFormat",               "QImageReader"));
    // Size
    mixin(generateFunQt(18309, "qteQImageReader_size",                    "QImageReader"));
    // Animation
    mixin(generateFunQt(18310, "qteQImageReader_imageCount",              "QImageReader"));
    mixin(generateFunQt(18311, "qteQImageReader_currentImageNumber",      "QImageReader"));
    mixin(generateFunQt(18312, "qteQImageReader_jumpToImage",             "QImageReader"));
    mixin(generateFunQt(18313, "qteQImageReader_jumpToNextImage",         "QImageReader"));
    // Options
    mixin(generateFunQt(18314, "qteQImageReader_setScaledSize",           "QImageReader"));
    mixin(generateFunQt(18315, "qteQImageReader_setAutoDetectImageFormat","QImageReader"));
    // Error
    mixin(generateFunQt(18316, "qteQImageReader_error",                   "QImageReader"));
    mixin(generateFunQt(18317, "qteQImageReader_errorString",             "QImageReader"));
    // Static
    mixin(generateFunQt(18318, "qteQImageReader_supportedImageFormats",   "QImageReader"));
}

static this() {
    registerModule("QImageReader", "qte56_foundation.dll", &loadQImageReader);
}

// ====================================================================
// Class wrapper — value type
// ====================================================================

/// D wrapper for Qt class QImageReader.
@live class QImageReader {
private:
    void* _wh;

public:
    /// Create default QImageReader.
    this() {
        _wh = (cast(t_qp__)pFunQt[18300])();
    }

    /// Create QImageReader for a file.
    this(string path) {
        auto _ws = toQString(path);
        _wh = (cast(t_qp__qp)pFunQt[18301])(_ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    ~this() {
        if (_wh !is null && pFunQt[18302] !is null) {
            (cast(t_v__qp)pFunQt[18302])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }

    // ── File ──────────────────────────────────────────────────────────────

    QImageReader setFileName(string path) {
        auto _ws = toQString(path);
        (cast(t_v__qp_qp)pFunQt[18303])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    string fileName() {
        wchar[4096] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[18304])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        import std.utf : toUTF8;
        return buf[0 .. len].toUTF8;
    }

    // ── Read ──────────────────────────────────────────────────────────────

    bool canRead() {
        return cast(bool)(cast(t_i__qp)pFunQt[18305])(_wh);
    }

    /// Read image. Returns heap-allocated QImage or null on failure.
    import gen_qimage : QImage;
    QImage read() {
        void* ptr = (cast(t_qp__qp)pFunQt[18306])(_wh);
        return QImage.wrap(ptr);
    }

    // ── Format ────────────────────────────────────────────────────────────

    /// Get image format name (e.g. "png", "jpg").
    string format() {
        char[256] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[18307])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string)buf[0 .. len].idup;
    }

    /// Set expected format (e.g. "png").
    QImageReader setFormat(string fmt) {
        import std.string : toStringz;
        const(char)* fmtz = fmt.toStringz;
        // C++ takes (void*, const char*, int fmt_len)
        alias t_v__qp_cp_i = extern(C) void function(void*, const(char)*, int) @nogc nothrow;
        (cast(t_v__qp_cp_i)pFunQt[18308])(_wh, fmtz, cast(int)fmt.length);
        return this;
    }

    // ── Size ──────────────────────────────────────────────────────────────

    /// Get image size without fully reading the image.
    QImageReader size(int* w, int* h) {
        (cast(t_v__qp_ip_ip)pFunQt[18309])(_wh, w, h);
        return this;
    }

    // ── Animation ─────────────────────────────────────────────────────────

    int imageCount() {
        return cast(int)(cast(t_i__qp)pFunQt[18310])(_wh);
    }

    int currentImageNumber() {
        return cast(int)(cast(t_i__qp)pFunQt[18311])(_wh);
    }

    bool jumpToImage(int n) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[18312])(_wh, n);
    }

    bool jumpToNextImage() {
        return cast(bool)(cast(t_i__qp)pFunQt[18313])(_wh);
    }

    // ── Options ───────────────────────────────────────────────────────────

    QImageReader setScaledSize(int w, int h) {
        (cast(t_v__qp_i_i)pFunQt[18314])(_wh, w, h);
        return this;
    }

    QImageReader setAutoDetectImageFormat(bool enable) {
        (cast(t_v__qp_i)pFunQt[18315])(_wh, enable ? 1 : 0);
        return this;
    }

    // ── Error ─────────────────────────────────────────────────────────────

    int error() {
        return cast(int)(cast(t_i__qp)pFunQt[18316])(_wh);
    }

    string errorString() {
        wchar[4096] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[18317])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        import std.utf : toUTF8;
        return buf[0 .. len].toUTF8;
    }

    // ── Static ────────────────────────────────────────────────────────────

    /// Get semicolon-separated list of supported image formats.
    static string supportedImageFormats() {
        char[4096] buf;
        alias t_i__cp_i = extern(C) int function(char*, int) @nogc nothrow;
        int len = (cast(t_i__cp_i)pFunQt[18318])(buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string)buf[0 .. len].idup;
    }
}
