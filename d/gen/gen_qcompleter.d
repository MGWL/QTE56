/**
 * gen_qcompleter.d — D-обёртка для QCompleter.
 *
 * DLL: qte56_completer.dll  |  Блок индексов: 20118–20131 (14 функций)
 *
 * $(H3 Назначение)
 *
 * QCompleter добавляет автодополнение к QLineEdit и QComboBox.
 * Источник данных — строковый список, обновляемый динамически.
 *
 * $(H3 Пример: быстрый старт)
 *
 * ---
 * import gen_qcompleter;
 *
 * // Создать комплитер со списком
 * auto c = new QCompleter(["Alice", "Bob", "Charlie", "Dave"]);
 *
 * // Настроить: режим inline, регистронезависимо
 * c.setCompletionMode(CompletionMode.Inline);
 * c.setCaseSensitivity(0);   // 0 = CaseInsensitive
 *
 * // Прикрепить к полю ввода
 * c.attachTo(myLineEdit.getWH());
 *
 * // Обработать выбор
 * c.connect_activated((string s) {
 *     writeln("Выбрано: ", s);
 * });
 * ---
 *
 * $(H3 Режимы дополнения)
 *
 * $(TABLE
 *   $(TR $(TH Константа) $(TH Значение) $(TH Описание))
 *   $(TR $(TD PopupCompletion)           $(TD 0) $(TD Всплывающий список (по умолчанию)))
 *   $(TR $(TD UnfilteredPopupCompletion) $(TD 1) $(TD Всплывающий без фильтрации))
 *   $(TR $(TD InlineCompletion)          $(TD 2) $(TD Дополнение прямо в поле ввода))
 * )
 *
 * $(H3 Динамическое обновление)
 *
 * Список можно менять в любой момент без пересоздания объекта:
 * ---
 * c.setModel(["new", "list", "of", "items"]);
 * ---
 *
 * See_Also: doc/qte56_d_reference.md §QCompleter
 */
module gen_qcompleter;

import std.string : join;
import std.utf    : toUTF16z, toUTF8;
import std.conv   : to;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__, t_v__qp, t_i__qp, t_v__qp_qp, t_qp__qp, fromQString;

// ── Alias типов ───────────────────────────────────────────────────────────────

/// void function(void*, int) — setCompletionMode / setCaseSensitivity / setMaxVisibleItems
mixin(generateAlias("v__qp_i"));

/// void function(void*, wchar_t*, int) — setPrefix, setModelFromList, createList
mixin(generateAlias("v__qp_qp_i"));

/// void* function(wchar_t*, int) — createList
mixin(generateAlias("qp__qp_i"));

/// void function(void*, void(*)(wchar_t*,int,void*), void*) — connect_activated
private alias t_connect_act = extern(C) @nogc void function(void*,
    void function(const(wchar)*, int, void*), void*);

// ── Загрузка функций ──────────────────────────────────────────────────────────

/**
 * Загружает все функции QCompleter из qte56_completer.dll.
 * Вызывается автоматически через registerModule при первом import.
 */
void loadQCompleter() {
    mixin(generateFunQt(20118, "qteQCompleter_create",              "QCompleter"));
    mixin(generateFunQt(20119, "qteQCompleter_createList",          "QCompleter"));
    mixin(generateFunQt(20120, "qteQCompleter_delete",              "QCompleter"));
    mixin(generateFunQt(20121, "qteQCompleter_setCompletionMode",   "QCompleter"));
    mixin(generateFunQt(20122, "qteQCompleter_setCaseSensitivity",  "QCompleter"));
    mixin(generateFunQt(20123, "qteQCompleter_setMaxVisibleItems",  "QCompleter"));
    mixin(generateFunQt(20124, "qteQCompleter_setPrefix",           "QCompleter"));
    mixin(generateFunQt(20125, "qteQCompleter_completionCount",     "QCompleter"));
    mixin(generateFunQt(20126, "qteQCompleter_currentCompletion",   "QCompleter"));
    mixin(generateFunQt(20127, "qteQCompleter_complete",            "QCompleter"));
    mixin(generateFunQt(20128, "qteQCompleter_setModelFromList",    "QCompleter"));
    mixin(generateFunQt(20129, "qteQCompleter_connect_activated",   "QCompleter"));
    mixin(generateFunQt(20130, "qteQLineEdit_setCompleter",         "QCompleter"));
    mixin(generateFunQt(20131, "qteQComboBox_setCompleter",         "QCompleter"));
}

/// Авто-регистрация: вызывается при загрузке модуля.
static this() {
    registerModule("QCompleter", "qte56_completer.dll", &loadQCompleter);
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательные типы
// ══════════════════════════════════════════════════════════════════════════════

/**
 * StrClosure — GC-выделенная обёртка вокруг D-делегата для строковых сигналов.
 *
 * Хранится в поле QCompleter, чтобы GC не собрал раньше времени.
 */
private final class StrClosure {
    void delegate(string) dg; /// Захваченный D-делегат
    this(void delegate(string) d) { dg = d; }
}

/**
 * _strTrampoline — extern(C) мост: C++ строка → D-делегат.
 *
 * Вызывается из Qt при сигнале activated(QString).
 * Конвертирует wchar_t* в D string (UTF-8) и вызывает делегат.
 *
 * Params:
 *   str = указатель на wchar_t данные строки.
 *   len = длина в символах wchar_t.
 *   ctx = указатель на StrClosure.
 */
extern(C) private static void _strTrampoline(const(wchar)* str, int len, void* ctx) {
    // Конвертируем wchar[] → D string (UTF-8) и вызываем делегат.
    string s = str[0 .. len].to!string;
    (cast(StrClosure)cast(Object)ctx).dg(s);
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательная функция: D string[] → wstring с разделителем \x01
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Преобразует массив строк в wstring с разделителем \x01 для передачи в C++.
 * C++ сторона расщепляет через QChar(1).
 */
private wstring toJoinedW(string[] items) {
    import std.array : join;
    return items.join("\x01").to!wstring;
}

// ══════════════════════════════════════════════════════════════════════════════
// Enum: режимы дополнения
// ══════════════════════════════════════════════════════════════════════════════

/**
 * CompletionMode — режим отображения вариантов автодополнения.
 */
enum CompletionMode : int {
    PopupCompletion           = 0, /// Всплывающий список (по умолчанию)
    UnfilteredPopupCompletion = 1, /// Всплывающий без фильтрации по префиксу
    InlineCompletion          = 2, /// Дополнение прямо в строке ввода
}

// ══════════════════════════════════════════════════════════════════════════════
// QCompleter
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QCompleter — автодополнение для QLineEdit и QComboBox.
 *
 * $(H3 Быстрый старт)
 *
 * ---
 * auto c = new QCompleter(["Alice", "Bob", "Charlie"]);
 * c.attachTo(searchEdit.getWH());
 * ---
 *
 * $(H3 Настройка поведения)
 *
 * ---
 * c.setCompletionMode(CompletionMode.Inline);   // дополнять в строке
 * c.setCaseSensitivity(0);                      // регистронезависимо
 * c.setMaxVisibleItems(8);                      // не более 8 строк в списке
 * ---
 *
 * $(H3 Динамическое обновление списка)
 *
 * ---
 * // Можно вызывать в любой момент — без пересоздания объекта
 * c.setModel(["new", "items", "from", "server"]);
 * ---
 *
 * $(H3 Сигнал выбора)
 *
 * ---
 * c.connect_activated((string chosen) {
 *     myLabel.setText(chosen);
 * });
 * ---
 *
 * $(H3 Важно)
 * $(UL
 *   $(LI attachTo() вызывать ПОСЛЕ настройки режима и модели.)
 *   $(LI Один объект QCompleter — один виджет. Для нескольких полей — создать
 *        отдельные объекты.)
 *   $(LI QCompleter становится дочерним объектом виджета после attachTo() —
 *        Qt удалит его при уничтожении виджета. Не вызывать destroy() вручную.)
 * )
 */
@live class QCompleter {
private:
    void*       _wh;              /// Указатель на C++ QCompleter
    StrClosure  _activatedClosure; /// Замыкание сигнала activated
    bool        _attached;        /// true → Qt взял ownership; деструктор не удаляет

public:

    /**
     * Создать пустой комплитер.
     * Список дополнений задать через setModel().
     */
    this() {
        _wh = (cast(t_qp__)pFunQt[20118])();
    }

    /**
     * Создать комплитер с начальным списком строк.
     *
     * Params:
     *   items = массив строк для дополнения.
     *
     * Examples:
     * ---
     * auto c = new QCompleter(["Apple", "Banana", "Cherry"]);
     * ---
     */
    this(string[] items) {
        wstring ws = toJoinedW(items);
        _wh = (cast(t_qp__qp_i)pFunQt[20119])(
            cast(void*)ws.ptr, cast(int)ws.length);
    }

    /**
     * Деструктор: удаляет C++ объект только если комплитер не прикреплён к виджету.
     *
     * После attachTo() / attachToCombo() Qt владеет объектом и удалит его сам
     * при уничтожении родительского виджета. Повторное удаление вызовет крэш.
     */
    ~this() {
        // Если Qt взял ownership — не трогать: виджет уже мог удалить объект.
        if (_wh !is null && !_attached) {
            (cast(t_v__qp)pFunQt[20120])(_wh);
            _wh = null;
        }
    }

    // ── Настройка ─────────────────────────────────────────────────────────────

    /**
     * Установить режим отображения дополнений.
     *
     * Params:
     *   mode = CompletionMode: Popup=0, UnfilteredPopup=1, Inline=2.
     *
     * Examples:
     * ---
     * c.setCompletionMode(CompletionMode.Inline);
     * ---
     */
    QCompleter setCompletionMode(int mode) {
        (cast(t_v__qp_i)pFunQt[20121])(_wh, mode);
        return this;
    }

    /// ditto
    QCompleter setCompletionMode(CompletionMode mode) {
        setCompletionMode(cast(int)mode);
        return this;
    }

    /**
     * Установить чувствительность к регистру.
     *
     * Params:
     *   cs = 0 — без учёта регистра (по умолчанию), 1 — с учётом регистра.
     */
    QCompleter setCaseSensitivity(int cs) {
        (cast(t_v__qp_i)pFunQt[20122])(_wh, cs);
        return this;
    }

    /**
     * Максимальное число строк в выпадающем списке.
     *
     * Params:
     *   n = число строк (по умолчанию 7).
     */
    QCompleter setMaxVisibleItems(int n) {
        (cast(t_v__qp_i)pFunQt[20123])(_wh, n);
        return this;
    }

    /**
     * Задать префикс фильтрации вручную.
     *
     * Обычно виджет устанавливает префикс автоматически при вводе.
     * Используйте этот метод для программного показа списка.
     *
     * Params:
     *   prefix = строка-префикс для фильтрации.
     */
    QCompleter setPrefix(string prefix) {
        wstring ws = prefix.to!wstring;
        (cast(t_v__qp_qp_i)pFunQt[20124])(_wh, cast(void*)ws.ptr, cast(int)ws.length);
        return this;
    }

    // ── Запросы ───────────────────────────────────────────────────────────────

    /**
     * Число вариантов дополнения для текущего префикса.
     *
     * Returns:
     *   Количество строк, совпадающих с текущим префиксом.
     */
    int completionCount() {
        return (cast(t_i__qp)pFunQt[20125])(_wh);
    }

    /**
     * Текущий выбранный вариант дополнения.
     *
     * Returns:
     *   Строка текущего варианта (пустая, если нет вариантов).
     */
    string currentCompletion() {
        void* qs = (cast(t_qp__qp)pFunQt[20126])(_wh);
        if (qs is null) return "";
        return fromQString(qs);
    }

    /**
     * Показать всплывающий список принудительно.
     * Полезно при программном открытии (например, по кнопке).
     */
    QCompleter complete() {
        (cast(t_v__qp)pFunQt[20127])(_wh);
        return this;
    }

    // ── Динамическое обновление ───────────────────────────────────────────────

    /**
     * Заменить список дополнений новым.
     *
     * Эффективно обновляет внутреннюю QStringListModel без пересоздания
     * объекта комплитера и без отрыва от виджета.
     *
     * Params:
     *   items = новый массив строк.
     *
     * Examples:
     * ---
     * // Обновить после загрузки данных с сервера
     * c.setModel(serverResponse.split(","));
     * ---
     */
    QCompleter setModel(string[] items) {
        wstring ws = toJoinedW(items);
        (cast(t_v__qp_qp_i)pFunQt[20128])(_wh, cast(void*)ws.ptr, cast(int)ws.length);
        return this;
    }

    // ── Сигналы ───────────────────────────────────────────────────────────────

    /**
     * Подключить обработчик выбора варианта дополнения.
     *
     * Сигнал `activated(QString)` испускается когда пользователь кликает
     * на вариант в списке или нажимает Enter при InlineCompletion.
     *
     * Params:
     *   cb = D-делегат, принимающий выбранную строку.
     *
     * Examples:
     * ---
     * c.connect_activated((string chosen) {
     *     writeln("Пользователь выбрал: ", chosen);
     *     performSearch(chosen);
     * });
     * ---
     */
    QCompleter connect_activated(void delegate(string) cb) {
        _activatedClosure = new StrClosure(cb);
        (cast(t_connect_act)pFunQt[20129])(
            _wh,
            &_strTrampoline,
            cast(void*)cast(Object)_activatedClosure
        );
        return this;
    }

    // ── Привязка к виджету ────────────────────────────────────────────────────

    /**
     * Прикрепить комплитер к виджету ввода.
     *
     * Работает с QLineEdit и QComboBox. После прикрепления Qt перехватывает
     * ввод и автоматически фильтрует варианты.
     *
     * После вызова attachTo() Qt берёт ownership над комплитером — не нужно
     * вызывать destroy() вручную.
     *
     * Params:
     *   widgetWH = нативный указатель виджета (getWH()).
     *
     * Examples:
     * ---
     * auto c = new QCompleter(["one", "two", "three"]);
     * c.attachTo(myLineEdit.getWH());
     * ---
     */
    QCompleter attachTo(void* widgetWH) {
        // Используем функцию QLineEdit (она принимает QWidget* через Qt RTTI).
        // Для QComboBox Qt автоматически распознаёт тип по vtable.
        (cast(t_v__qp_qp)pFunQt[20130])(widgetWH, _wh);
        _attached = true; // Qt взял ownership → деструктор не должен вызывать delete
        return this;
    }

    /**
     * Прикрепить комплитер к QComboBox явно.
     *
     * QComboBox имеет собственный встроенный комплитер. Этот метод заменяет его.
     *
     * Params:
     *   comboWH = нативный указатель QComboBox (getWH()).
     */
    QCompleter attachToCombo(void* comboWH) {
        (cast(t_v__qp_qp)pFunQt[20131])(comboWH, _wh);
        _attached = true; // Qt взял ownership → деструктор не должен вызывать delete
        return this;
    }

    /// Получить нативный указатель на C++ QCompleter.
    void* getWH() { return _wh; }
}

