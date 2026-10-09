/**
 * gen_qfontmetrics.d — wrapper for QFontMetrics (value type).
 * Module: QFontMetrics  |  DLL: qte56_drawing.dll
 * Index block: 19776–19785 (10 functions)
 */
module gen_qfontmetrics;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_v__qp, toQString;

// New aliases for this module:
mixin(generateAlias("i__qp_qp_i")); // int(void*, void*, int) — horizontalAdvance(wchar*, len)

// ====================================================================
// Load function addresses at runtime
// ====================================================================

void loadQFontMetrics() {
    mixin(generateFunQt(19776, "qteQFontMetrics_create",             "QFontMetrics"));
    mixin(generateFunQt(19777, "qteQFontMetrics_delete",             "QFontMetrics"));
    mixin(generateFunQt(19778, "qteQFontMetrics_horizontalAdvance",  "QFontMetrics"));
    mixin(generateFunQt(19779, "qteQFontMetrics_height",             "QFontMetrics"));
    mixin(generateFunQt(19780, "qteQFontMetrics_ascent",             "QFontMetrics"));
    mixin(generateFunQt(19781, "qteQFontMetrics_descent",            "QFontMetrics"));
    mixin(generateFunQt(19782, "qteQFontMetrics_leading",            "QFontMetrics"));
    mixin(generateFunQt(19783, "qteQFontMetrics_lineSpacing",        "QFontMetrics"));
    mixin(generateFunQt(19784, "qteQFontMetrics_averageCharWidth",   "QFontMetrics"));
    mixin(generateFunQt(19785, "qteQFontMetrics_maxWidth",           "QFontMetrics"));
}

static this() {
    registerModule("QFontMetrics", "qte56_drawing.dll", &loadQFontMetrics);
}

// ====================================================================
// Class wrapper — value type (non-owning QFont reference)
// ====================================================================

/// D wrapper for Qt class QFontMetrics (value type).
/// Constructed from an existing QFont — measures that font's metrics.
@live class QFontMetrics {
private:
    void* _wh;
    bool  _qt_owned;

    /// No-op constructor for wrap() — does NOT call create().
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /// Create QFontMetrics for the given QFont (pass font.getWH()).
    this(void* fontPtr) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp)pFunQt[19776])(fontPtr);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19777] !is null) {
            (cast(t_v__qp)pFunQt[19777])(_wh);
            _wh = null;
        }
    }

    /// Wrap a heap-allocated QFontMetrics pointer. Dtor WILL delete.
    static QFontMetrics wrap(void* ptr) {
        if (ptr is null) return null;
        auto fm = new QFontMetrics(false);
        fm._wh = ptr;
        return fm;
    }

    // ── Measurement ──────────────────────────────────────────────────

    /// Horizontal advance (width in pixels) of the given string.
    int horizontalAdvance(string s) {
        auto ws = toQString(s);
        return cast(int)(cast(t_i__qp_qp)pFunQt[19778])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }

    /// Height of the font (ascent + descent).
    int height() {
        return cast(int)(cast(t_i__qp)pFunQt[19779])(_wh);
    }

    /// Ascent — pixels above the baseline.
    int ascent() {
        return cast(int)(cast(t_i__qp)pFunQt[19780])(_wh);
    }

    /// Descent — pixels below the baseline.
    int descent() {
        return cast(int)(cast(t_i__qp)pFunQt[19781])(_wh);
    }

    /// Leading — inter-line spacing.
    int leading() {
        return cast(int)(cast(t_i__qp)pFunQt[19782])(_wh);
    }

    /// Line spacing = ascent + descent + leading.
    int lineSpacing() {
        return cast(int)(cast(t_i__qp)pFunQt[19783])(_wh);
    }

    /// Average character width.
    int averageCharWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[19784])(_wh);
    }

    /// Maximum character width (widest glyph).
    int maxWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[19785])(_wh);
    }

    // ── Helpers ──────────────────────────────────────────────────────

    /// Mark as Qt-owned — dtor will NOT delete.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QFontMetrics
