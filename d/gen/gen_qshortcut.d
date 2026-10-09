/**
 * gen_qshortcut.d — D-обёртка для QShortcut.
 *
 * DLL: qte56_shortcut.dll  |  Блок индексов: 20132–20138, 20163–20168 (13 функций)
 *
 * $(H3 Назначение)
 *
 * QShortcut связывает комбинацию клавиш с произвольным D-делегатом.
 * Работает пока жив родительский виджет (owner).
 *
 * $(H3 Пример: быстрый старт)
 *
 * ---
 * import gen_qshortcut;
 *
 * // Ctrl+S — сохранить
 * auto sc = new QShortcut(win.getWH(), "Ctrl+S");
 * sc.connect_activated({ save(); });
 *
 * // F5 — обновить, только в окне
 * auto scF5 = new QShortcut(win.getWH(), "F5");
 * scF5.setContext(ShortcutContext.Window);
 * scF5.connect_activated({ refresh(); });
 * ---
 *
 * $(H3 Контекст срабатывания)
 *
 * $(TABLE
 *   $(TR $(TH Константа)           $(TH Значение) $(TH Описание))
 *   $(TR $(TD Widget)              $(TD 0) $(TD Только когда фокус на родительском виджете))
 *   $(TR $(TD Window)              $(TD 1) $(TD Любой виджет в том же окне (по умолчанию)))
 *   $(TR $(TD Application)         $(TD 2) $(TD Глобально в приложении))
 *   $(TR $(TD WidgetWithChildren)  $(TD 3) $(TD Виджет или его потомки))
 * )
 *
 * $(H3 Жизненный цикл)
 *
 * QShortcut привязан к родительскому виджету — при уничтожении виджета
 * шорткат удаляется автоматически. Явный вызов `destroy()` не обязателен.
 *
 * See_Also: doc/qte56_d_reference.md §QShortcut
 */
module gen_qshortcut;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_v__qp, t_i__qp, t_qp__qp, t_v__qp_i, t_qp__qp_qp_i, t_v__qp_qp_i, t_v__qp_qp_qp, fromQString;

// ── Загрузка функций ──────────────────────────────────────────────────────────

/**
 * Загружает все функции QShortcut из qte56_shortcut.dll.
 * Вызывается автоматически через registerModule при первом import.
 */
void loadQShortcut() {
    mixin(generateFunQt(20132, "qteQShortcut_create",            "QShortcut"));
    mixin(generateFunQt(20133, "qteQShortcut_delete",            "QShortcut"));
    mixin(generateFunQt(20134, "qteQShortcut_setEnabled",        "QShortcut"));
    mixin(generateFunQt(20135, "qteQShortcut_isEnabled",         "QShortcut"));
    mixin(generateFunQt(20136, "qteQShortcut_setContext",        "QShortcut"));
    mixin(generateFunQt(20137, "qteQShortcut_connect_activated", "QShortcut"));
    mixin(generateFunQt(20138, "qteQShortcut_setAutoRepeat",     "QShortcut"));
    // ── Дополнено 2026-07-26 (augment, генератор v2) ─────────────────────
    mixin(generateFunQt(20163, "qteQShortcut_context",           "QShortcut"));
    mixin(generateFunQt(20164, "qteQShortcut_setWhatsThis",      "QShortcut"));
    mixin(generateFunQt(20165, "qteQShortcut_whatsThis",         "QShortcut"));
    mixin(generateFunQt(20166, "qteQShortcut_autoRepeat",        "QShortcut"));
    mixin(generateFunQt(20167, "qteQShortcut_id",                "QShortcut"));
    mixin(generateFunQt(20168, "qteQShortcut_connect_activatedAmbiguously", "QShortcut"));
}

/// Авто-регистрация: вызывается при загрузке модуля.
static this() {
    registerModule("QShortcut", "qte56_shortcut.dll", &loadQShortcut);
}

// ══════════════════════════════════════════════════════════════════════════════
// Enum: контекст срабатывания шортката
// ══════════════════════════════════════════════════════════════════════════════

/**
 * ShortcutContext — Qt::ShortcutContext, определяет область действия шортката.
 *
 * $(TABLE
 *   $(TR $(TH Значение)             $(TH Описание))
 *   $(TR $(TD Widget = 0)           $(TD Только когда фокус на родительском виджете))
 *   $(TR $(TD Window = 1)           $(TD Любой виджет в том же окне (по умолчанию)))
 *   $(TR $(TD Application = 2)      $(TD Глобально в приложении))
 *   $(TR $(TD WidgetWithChildren=3) $(TD Виджет или его дочерние виджеты))
 * )
 */
enum ShortcutContext : int {
    Widget             = 0, /// Только когда фокус на родительском виджете
    Window             = 1, /// Любой виджет в том же окне (по умолчанию)
    Application        = 2, /// Глобально в приложении
    WidgetWithChildren = 3, /// Виджет или его дочерние виджеты
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательные типы для коллбэков
// ══════════════════════════════════════════════════════════════════════════════

/**
 * VoidClosure — GC-выделенная обёртка вокруг D-делегата `void delegate()`.
 *
 * Нужна, чтобы GC не собрал делегат пока шорткат жив.
 * Список замыканий хранится в объекте QShortcut.
 */
private final class VoidClosure {
    void delegate() dg; /// Захваченный D-делегат
    this(void delegate() d) { dg = d; }
}

/**
 * _voidTrampoline — extern(C) мост: вызов из Qt → D-делегат.
 *
 * Вызывается из Qt при срабатывании сигнала activated().
 * Единственный аргумент — указатель на VoidClosure.
 *
 * Params:
 *   ctx = указатель на VoidClosure (передан как userdata при connect).
 */
extern(C) private static void _voidTrampoline(void* ctx) {
    // Конвертируем void* → VoidClosure и вызываем делегат.
    // Исключения в коллбэках не должны пробрасываться в Qt — ловим Throwable
    // (включая Error: RangeError/ConvException и т.п.) — утечка в C++ = crash.
    try {
        (cast(VoidClosure)ctx).dg();
    } catch (Throwable t) {
        debug {
            import std.file : append;
            try append(`qte_shortcut_cb_error.log`,
                "QShortcut callback: " ~ t.msg ~ "\n"); catch (Exception) {}
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════════
// Основной класс
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QShortcut — клавиатурный шорткат, привязанный к виджету.
 *
 * $(H3 Создание)
 *
 * ---
 * auto sc = new QShortcut(parentWidget.getWH(), "Ctrl+S");
 * ---
 *
 * Строка ключа — формат QKeySequence:
 * `"Ctrl+S"`, `"F5"`, `"Shift+F3"`, `"Alt+Return"` и т.д.
 *
 * $(H3 Контекст срабатывания)
 *
 * По умолчанию — `Window` (срабатывает при фокусе на любом виджете окна).
 * Изменить: `sc.setContext(ShortcutContext.Application)`.
 *
 * $(H3 Жизненный цикл)
 *
 * QShortcut владеет родительский виджет — при его уничтожении шорткат
 * удаляется автоматически. Явный `destroy(sc)` безопасен, но не обязателен.
 */
@live class QShortcut {
private:
    void*          _wh;        /// Указатель на C++ QShortcut
    VoidClosure[]  _closures;  /// GC-якорь: список всех замыканий сигнала

public:

    /**
     * Создаёт шорткат с заданной комбинацией клавиш.
     *
     * Params:
     *   parent = WH родительского QWidget (обязателен).
     *   key    = строка QKeySequence, например `"Ctrl+S"` или `"F5"`.
     */
    this(void* parent, string key) {
        import std.utf : toUTF16;
        wstring wk = key.toUTF16;
        _wh = (cast(t_qp__qp_qp_i)pFunQt[20132])(parent, cast(void*)wk.ptr, cast(int)wk.length);
    }

    /**
     * Явно удаляет шорткат до уничтожения родительского виджета.
     *
     * Используйте только если нужно убрать шорткат при живом родителе.
     * В обычном сценарии удаление происходит автоматически при
     * уничтожении родительского QWidget.
     *
     * После вызова `_wh` обнуляется — повторный вызов безопасен.
     *
     * Важно: не вызывать если родительский виджет уже уничтожен
     * (Qt уже удалил шорткат автоматически).
     */
    QShortcut free() {
        if (_wh) {
            (cast(t_v__qp)pFunQt[20133])(_wh);
            _wh = null;
        }
        return this;
    }

    /**
     * Включает или выключает шорткат.
     *
     * Params:
     *   v = `true` — включён (по умолчанию), `false` — отключён.
     */
    QShortcut setEnabled(bool v) {
        (cast(t_v__qp_i)pFunQt[20134])(_wh, v ? 1 : 0);
        return this;
    }

    /**
     * Возвращает: `true`, если шорткат включён.
     */
    bool isEnabled() {
        return (cast(t_i__qp)pFunQt[20135])(_wh) != 0;
    }

    /**
     * Устанавливает контекст срабатывания шортката.
     *
     * Params:
     *   ctx = одно из значений `ShortcutContext`.
     *
     * See_Also: ShortcutContext
     */
    QShortcut setContext(ShortcutContext ctx) {
        (cast(t_v__qp_i)pFunQt[20136])(_wh, cast(int)ctx);
        return this;
    }

    /**
     * Подключает D-делегат к сигналу `activated()`.
     *
     * Делегат вызывается каждый раз при нажатии комбинации клавиш.
     * Можно подключить несколько делегатов — все будут вызваны.
     *
     * Params:
     *   dg = вызываемый D-делегат (захватывает переменные окружения).
     *
     * Examples:
     * ---
     * sc.connect_activated({ writeln("Ctrl+S нажат!"); });
     * ---
     */
    QShortcut connect_activated(void delegate() dg) {
        auto cl = new VoidClosure(dg);
        _closures ~= cl;  // удерживаем от GC
        (cast(t_v__qp_qp_qp)pFunQt[20137])(
            _wh,
            cast(void*)&_voidTrampoline,
            cast(void*)cl
        );
        return this;
    }

    /**
     * Разрешает или запрещает авто-повтор при удержании клавиши.
     *
     * Params:
     *   v = `true` — повторять (по умолчанию), `false` — только первое нажатие.
     */
    QShortcut setAutoRepeat(bool v) {
        (cast(t_v__qp_i)pFunQt[20138])(_wh, v ? 1 : 0);
        return this;
    }

    // ── Дополнено 2026-07-26 (augment, генератор v2) ──────────────────────

    /**
     * Возвращает: текущий контекст срабатывания шортката.
     *
     * See_Also: ShortcutContext, setContext
     */
    ShortcutContext context() {
        return cast(ShortcutContext)(cast(t_i__qp)pFunQt[20163])(_wh);
    }

    /**
     * Устанавливает текст What's This для шортката.
     *
     * Текст показывается в режиме "Что это?" (Shift+F1) при нажатии
     * комбинации клавиш.
     *
     * Params:
     *   text = строка справки.
     */
    QShortcut setWhatsThis(string text) {
        import std.utf : toUTF16;
        wstring wt = text.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[20164])(_wh, cast(void*)wt.ptr, cast(int)wt.length);
        return this;
    }

    /**
     * Возвращает: текст What's This (пустая строка, если не задан).
     *
     * See_Also: setWhatsThis
     */
    string whatsThis() {
        void* qs = (cast(t_qp__qp)pFunQt[20165])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);  // освобождаем QString
        return s;
    }

    /**
     * Возвращает: `true`, если разрешён авто-повтор при удержании клавиши.
     */
    bool autoRepeat() {
        return (cast(t_i__qp)pFunQt[20166])(_wh) != 0;
    }

    /**
     * Возвращает: внутренний id шортката (Qt-идентификатор).
     */
    int id() {
        return (cast(t_i__qp)pFunQt[20167])(_wh);
    }

    /**
     * Подключает D-делегат к сигналу `activatedAmbiguously()`.
     *
     * Сигнал срабатывает, когда нажатая комбинация неоднозначна
     * (та же клавиша назначена нескольким шорткатам в одном контексте).
     *
     * Params:
     *   dg = вызываемый D-делегат.
     */
    QShortcut connect_activatedAmbiguously(void delegate() dg) {
        auto cl = new VoidClosure(dg);
        _closures ~= cl;  // удерживаем от GC
        (cast(t_v__qp_qp_qp)pFunQt[20168])(
            _wh,
            cast(void*)&_voidTrampoline,
            cast(void*)cl
        );
        return this;
    }

    /**
     * Возвращает: внутренний указатель C++ объекта.
     * Используется при передаче в другие Qt-функции.
     */
    void* getWH() { return _wh; }
}
