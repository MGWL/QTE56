/**
 * gen_qclipboard.d — обёртка для QClipboard.
 * DLL: qte56_foundation.dll  |  Индексы: 17400–17408
 *
 * QClipboard — синглтон, создаётся Qt. Доступ: QClipboard.get().
 * Не владеет объектом: деструктор D не удаляет C++ объект.
 *
 * Режимы (QClipboard::Mode):
 *   0 = Clipboard (основной)
 *   1 = Selection (первичный, X11)
 *   2 = FindBuffer (macOS)
 *
 * Сигнальные прототипы:
 *   dataChanged:  extern(C) void cb(void* dthis)
 *   changed(mode):extern(C) void cb(void* dthis, int mode)
 */
module gen_qclipboard;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_cp_i, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_qp;

// ── Загрузка адресов функций ──────────────────────────────────────────────────

void loadQClipboard() {
    mixin(generateFunQt(17400, "qteQClipboard_get",                "QClipboard"));
    mixin(generateFunQt(17401, "qteQClipboard_text",               "QClipboard"));
    mixin(generateFunQt(17402, "qteQClipboard_setText",            "QClipboard"));
    mixin(generateFunQt(17403, "qteQClipboard_clear",              "QClipboard"));
    mixin(generateFunQt(17404, "qteQClipboard_supportsSelection",  "QClipboard"));
    mixin(generateFunQt(17405, "qteQClipboard_ownsClipboard",      "QClipboard"));
    mixin(generateFunQt(17406, "qteQClipboard_ownsSelection",      "QClipboard"));
    mixin(generateFunQt(17407, "qteQClipboard_connect_dataChanged","QClipboard"));
    mixin(generateFunQt(17408, "qteQClipboard_connect_changed",    "QClipboard"));
}

static this() {
    registerModule("QClipboard", "qte56_foundation.dll", &loadQClipboard);
}

// ─────────────────────────────────────────────────────────────────────────────
// QClipboard
// ─────────────────────────────────────────────────────────────────────────────

@live class QClipboard {
private:
    void* _wh;

    // Не используется напрямую — только через get()
    this(void* h) { _wh = h; }

public:
    /// Возвращает системный буфер обмена (singleton Qt).
    /// Требует инициализированного QApplication.
    static QClipboard get() {
        void* h = (cast(t_qp__)pFunQt[17400])();
        if (h is null) return null;
        return new QClipboard(h);
    }

    void* getWH() { return _wh; }

    // ── text / setText ────────────────────────────────────────────────────────
    /// Возвращает текст буфера обмена (mode: 0=Clipboard, 1=Selection)
    string text(int mode = 0) {
        void* qs = (cast(t_qp__qp_i)pFunQt[17401])(_wh, mode);
        return fromQString(qs);
    }
    /// Устанавливает текст в буфер обмена
    QClipboard setText(string s, int mode = 0) {
        import std.string : toStringz;
        (cast(t_v__qp_cp_i)pFunQt[17402])(_wh, s.toStringz(), mode);
        return this;
    }

    // ── clear ─────────────────────────────────────────────────────────────────
    QClipboard clear(int mode = 0) {
        (cast(t_v__qp_i)pFunQt[17403])(_wh, mode);
        return this;
    }

    // ── queries ───────────────────────────────────────────────────────────────
    bool supportsSelection() { return (cast(t_i__qp)pFunQt[17404])(_wh) != 0; }
    bool ownsClipboard()     { return (cast(t_i__qp)pFunQt[17405])(_wh) != 0; }
    bool ownsSelection()     { return (cast(t_i__qp)pFunQt[17406])(_wh) != 0; }

    // ── signals ───────────────────────────────────────────────────────────────
    /// dataChanged: extern(C) void cb(void* dthis)
    QClipboard connect_dataChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17407])(_wh, cb, dthis);
        return this;
    }
    /// changed(mode): extern(C) void cb(void* dthis, int mode)
    QClipboard connect_changed(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17408])(_wh, cb, dthis);
        return this;
    }
}
