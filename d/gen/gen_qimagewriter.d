/**
 * gen_qimagewriter.d — wrapper for QImageWriter (value type).
 * DLL: qte56_foundation.dll  |  Index block: 18350–18360
 */
module gen_qimagewriter;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qimage : QImage;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));          // int(void*, void*) — write(QImage*)
mixin(generateAlias("i__qp_qp_i"));        // int(void*, void*, int) — fileName/errorString(obj, buf, buf_len)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQImageWriter() {
    // Lifecycle
    mixin(generateFunQt(18350, "qteQImageWriter_create",       "QImageWriter"));
    mixin(generateFunQt(18351, "qteQImageWriter_create_file",  "QImageWriter"));
    mixin(generateFunQt(18352, "qteQImageWriter_delete",       "QImageWriter"));
    // File
    mixin(generateFunQt(18353, "qteQImageWriter_setFileName",  "QImageWriter"));
    mixin(generateFunQt(18354, "qteQImageWriter_fileName",     "QImageWriter"));
    // Write
    mixin(generateFunQt(18355, "qteQImageWriter_canWrite",     "QImageWriter"));
    mixin(generateFunQt(18356, "qteQImageWriter_write",        "QImageWriter"));
    // Format / quality
    mixin(generateFunQt(18357, "qteQImageWriter_setFormat",    "QImageWriter"));
    mixin(generateFunQt(18358, "qteQImageWriter_setQuality",   "QImageWriter"));
    // Error
    mixin(generateFunQt(18359, "qteQImageWriter_error",        "QImageWriter"));
    mixin(generateFunQt(18360, "qteQImageWriter_errorString",  "QImageWriter"));
}

static this() {
    registerModule("QImageWriter", "qte56_foundation.dll", &loadQImageWriter);
}

// ====================================================================
// Class wrapper — value type
// ====================================================================

/// D wrapper for Qt class QImageWriter.
@live class QImageWriter {
private:
    void* _wh;

public:
    /// Create default QImageWriter.
    this() {
        _wh = (cast(t_qp__)pFunQt[18350])();
    }

    /// Create QImageWriter for a file.
    this(string path) {
        auto _ws = toQString(path);
        _wh = (cast(t_qp__qp)pFunQt[18351])(_ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    ~this() {
        if (_wh !is null && pFunQt[18352] !is null) {
            (cast(t_v__qp)pFunQt[18352])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }

    // ── File ──────────────────────────────────────────────────────────────

    QImageWriter setFileName(string path) {
        auto _ws = toQString(path);
        (cast(t_v__qp_qp)pFunQt[18353])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    string fileName() {
        wchar[4096] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[18354])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        import std.utf : toUTF8;
        return buf[0 .. len].toUTF8;
    }

    // ── Write ─────────────────────────────────────────────────────────────

    bool canWrite() {
        return cast(bool)(cast(t_i__qp)pFunQt[18355])(_wh);
    }

    /// Write a QImage. Pass img.getWH(). Returns true on success.
    bool write(void* image) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[18356])(_wh, image);
    }

    // ── Format / quality ──────────────────────────────────────────────────

    /// Set format (e.g. "png", "jpg").
    QImageWriter setFormat(string fmt) {
        import std.string : toStringz;
        const(char)* fmtz = fmt.toStringz;
        alias t_v__qp_cp_i = extern(C) void function(void*, const(char)*, int) @nogc nothrow;
        (cast(t_v__qp_cp_i)pFunQt[18357])(_wh, fmtz, cast(int)fmt.length);
        return this;
    }

    /// Set quality (0–100, -1 = default).
    QImageWriter setQuality(int quality) {
        (cast(t_v__qp_i)pFunQt[18358])(_wh, quality);
        return this;
    }

    // ── Error ─────────────────────────────────────────────────────────────

    int error() {
        return cast(int)(cast(t_i__qp)pFunQt[18359])(_wh);
    }

    string errorString() {
        wchar[4096] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[18360])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        import std.utf : toUTF8;
        return buf[0 .. len].toUTF8;
    }
}
