/**
 * signal.d — чистый D механизм сигнал/слот (без Qt, без DLL).
 *
 * Модуль реализует паттерн «издатель/подписчик» (publish/subscribe) целиком
 * на D, не требует загрузки Qt-библиотек и может использоваться в любом
 * D-проекте независимо от QTE56.
 *
 * $(H2 Три основных типа)
 *
 * $(DDOC_SECTIONS
 *   $(DDOC_SECTION_H Signal!Args)
 *   $(DDOC_SECTION
 *     Универсальный сигнал на D-делегатах. Хранит массив
 *     $(D void delegate(Args)) и вызывает их по порядку при emit.
 *     Подходит для связи D-объектов между собой.
 *   )
 *   $(DDOC_SECTION_H CSlot!Args)
 *   $(DDOC_SECTION
 *     Хранит пару (void* ctx, функция) — аналог QTE56 ESlot-соглашения.
 *     Используется как элемент списка в ESignal, либо напрямую.
 *   )
 *   $(DDOC_SECTION_H ESignal!Args)
 *   $(DDOC_SECTION
 *     Сигнал на C-style функциях с контекстом. Совместим с соглашением
 *     QTE56: $(D void function(void* dthis, Args)). Удобен когда
 *     обработчики нужно регистрировать/отменять по паре (ctx, fn).
 *   )
 * )
 *
 * $(H2 Быстрый старт)
 * ---
 * import signal;
 *
 * // ── D-делегаты ──────────────────────────────────────────────────
 * Signal!string onMessage;
 * onMessage.connect((string s) { writeln("получено: ", s); });
 * onMessage.emit("hello");           // → "получено: hello"
 * onMessage("world");                // опCall — то же самое
 *
 * // ── C-стиль (совместимо с QTE56) ───────────────────────────────
 * ESignal!int onChanged;
 * void myHandler(void* ctx, int n) { writeln(n); }
 * onChanged.connect(null, &myHandler);
 * onChanged.emit(42);
 *
 * // ── Мост: C-функция → Signal!T ──────────────────────────────────
 * Signal!int sig;
 * sig.connect(slot!int(myCtx, &myHandler));
 * sig.emit(7);
 * ---
 *
 * $(H2 Гарантии безопасности)
 *
 * $(UL
 *   $(LI $(B disconnect внутри emit) — безопасен: emit работает с копией
 *        массива (_.dup_), поэтому отключение слота внутри его же обработчика
 *        не нарушает текущий обход.)
 *   $(LI $(B connect внутри emit) — новый слот не вызывается в текущем emit,
 *        только в следующих. Это детерминированное поведение.)
 *   $(LI $(B null-обработчик) — проверяется через contract (in-condition);
 *        нарушение приводит к AssertError в debug-сборке.)
 * )
 *
 * See_Also:
 *   $(D test/test_signal.d) — 61 проверка всех операций,
 *   $(D d/signal_guide.html) — подробное HTML-руководство.
 */
module signal;

// Используем только стандартные алгоритмы D — внешних зависимостей нет.
import std.algorithm.mutation  : remove;       /// для удаления элемента из массива
import std.algorithm.searching : countUntil;   /// для поиска позиции элемента


// ══════════════════════════════════════════════════════════════════════════════
// Signal!Args — сигнал на D-делегатах
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Универсальный сигнал: хранит список D-делегатов и вызывает их при emit.
 *
 * Параметр шаблона $(D Args) — произвольный набор типов аргументов сигнала.
 * Примеры допустимых специализаций:
 * $(UL
 *   $(LI $(D Signal!())         — сигнал без параметров)
 *   $(LI $(D Signal!int)        — передаёт одно целое число)
 *   $(LI $(D Signal!string)     — передаёт строку)
 *   $(LI $(D Signal!(int, int)) — передаёт два целых числа)
 *   $(LI $(D Signal!(string, int, bool)) — три разнотипных аргумента)
 * )
 *
 * $(H3 Порядок вызова)
 *
 * Обработчики вызываются в порядке их подключения (FIFO).
 * Один делегат разрешено подключить несколько раз — каждый раз он вызывается
 * отдельным вхождением.
 *
 * $(H3 Сравнение делегатов при disconnect)
 *
 * Два делегата $(D a == b) если у них одинаковые указатель функции и
 * указатель контекста (_.ptr_ и _.funcptr_). Лямбды, созданные как
 * отдельные выражения $(D (int n) { ... }), имеют $(B разные) объекты,
 * даже если код идентичен. Поэтому для последующего disconnect необходимо
 * сохранить делегат в переменную.
 *
 * Examples:
 * ---
 * // Базовый пример
 * Signal!int onValueChanged;
 *
 * void delegate(int) mySlot = (int n) { writeln("новое значение: ", n); };
 * onValueChanged.connect(mySlot);
 * onValueChanged.emit(42);      // → "новое значение: 42"
 * onValueChanged.disconnect(mySlot);
 *
 * // Метод класса напрямую как слот
 * class View {
 *     void refresh(int v) { writeln("refresh: ", v); }
 * }
 * auto v = new View();
 * onValueChanged.connect(&v.refresh);   // &v.refresh — это делегат
 * onValueChanged(100);                  // опCall: вызывает emit(100)
 * onValueChanged.disconnect(&v.refresh);
 * ---
 */
struct Signal(Args...) {

    // ── Публичные типы ────────────────────────────────────────────────────────

    /**
     * Тип обработчика сигнала.
     *
     * Это $(D void delegate(Args)) — делегат, принимающий все аргументы
     * сигнала. Делегат несёт в себе два указателя: на функцию и на контекст
     * (объект класса или замыкание).
     *
     * Examples:
     * ---
     * Signal!int sig;
     * Signal!int.Handler h = (int n) { writeln(n); };
     * sig.connect(h);
     * ---
     */
    alias Handler = void delegate(Args);


    // ── Внутреннее состояние ──────────────────────────────────────────────────

    /**
     * Массив зарегистрированных обработчиков.
     *
     * Намеренно private — изменяется только через connect/disconnect/clear.
     * При emit копируется через .dup для защиты от изменений во время обхода.
     */
    private Handler[] _slots;


    // ── Подключение / отключение ──────────────────────────────────────────────

    /**
     * Подключить обработчик $(D h) к сигналу.
     *
     * Обработчик добавляется в конец списка и будет вызываться последним
     * среди уже подключённых. Один и тот же делегат можно добавить несколько
     * раз — каждый раз он вызывается как отдельная запись.
     *
     * Params:
     *   h = делегат типа $(D Handler); не должен быть null.
     *
     * Throws:
     *   $(D AssertError) в debug-сборке если $(D h is null).
     *
     * Examples:
     * ---
     * Signal!string onText;
     * onText.connect((string s) { writeln(s); });
     *
     * // Метод класса:
     * class Foo { void bar(string s) {} }
     * auto foo = new Foo();
     * onText.connect(&foo.bar);
     * ---
     */
    void connect(Handler h)
    in (h !is null, "Signal.connect: обработчик не может быть null")
    {
        _slots ~= h;   // O(1) амортизировано — GC расширяет массив по необходимости
    }

    /**
     * Отключить $(B первое) вхождение делегата $(D h).
     *
     * Поиск выполняется последовательно от начала массива. Если делегат
     * был добавлен несколько раз, удаляется только первое совпадение —
     * остальные остаются активными. Если $(D h) не найден, вызов является
     * нет-операцией (no-op).
     *
     * $(B Примечание о сравнении делегатов:)
     * Для успешного disconnect необходимо передать $(I тот же объект) делегата,
     * который был передан в connect. Лямбда $(D (int n) { ... }), написанная
     * повторно в другом месте кода, создаёт $(B новый) объект делегата и не
     * будет найдена.
     *
     * Params:
     *   h = делегат для удаления; null-значение просто не будет найдено.
     *
     * Examples:
     * ---
     * Signal!int sig;
     * void delegate(int) slot = (int n) { writeln(n); };
     *
     * sig.connect(slot);
     * sig.connect(slot);   // добавлен дважды
     * sig.disconnect(slot); // удалено только первое вхождение
     * assert(sig.length == 1);
     * ---
     */
    void disconnect(Handler h) {
        // countUntil возвращает -1 если не найдено, поэтому проверяем >= 0
        auto idx = _slots.countUntil(h);
        if (idx >= 0)
            _slots = _slots.remove(cast(size_t)idx);
            // std.algorithm.mutation.remove сдвигает элементы влево, уменьшая длину
    }

    /**
     * Отключить $(B все) вхождения делегата $(D h).
     *
     * Выполняет линейный обход и удаляет каждое совпадение. Полезно когда
     * один делегат был намеренно подключён несколько раз и нужно полностью
     * прекратить его участие.
     *
     * Сложность: O(n) по количеству слотов.
     *
     * Params:
     *   h = делегат для полного удаления.
     *
     * Examples:
     * ---
     * Signal!int sig;
     * void delegate(int) h = (int n) { writeln(n); };
     *
     * sig.connect(h);
     * sig.connect(h);
     * sig.connect(h);
     * sig.disconnectAll(h);
     * assert(sig.empty);
     * ---
     */
    void disconnectAll(Handler h) {
        size_t i = 0;
        while (i < _slots.length) {
            if (_slots[i] == h)
                // Удаляем текущую позицию — не увеличиваем i, чтобы проверить
                // следующий элемент, который сдвинулся на место удалённого
                _slots = _slots.remove(i);
            else
                i++;
        }
    }

    /**
     * Отключить все обработчики одновременно.
     *
     * После вызова $(D length == 0) и $(D empty == true).
     * Не освобождает внутренний буфер массива — повторное connect работает
     * без дополнительных аллокаций если количество слотов не превысит
     * предыдущий максимум.
     *
     * Examples:
     * ---
     * Signal!int sig;
     * sig.connect((int n) { });
     * sig.connect((int n) { });
     * sig.clear();
     * assert(sig.empty);
     * sig.emit(0);  // нет-операция, не падает
     * ---
     */
    void clear() {
        _slots.length = 0;   // сбрасываем длину, не трогая capacity
    }


    // ── Состояние ─────────────────────────────────────────────────────────────

    /**
     * Количество подключённых обработчиков (включая дубликаты).
     *
     * Returns:
     *   Число элементов в списке слотов. Если один делегат подключён
     *   N раз, возвращается N.
     */
    @property size_t length() const { return _slots.length; }

    /**
     * $(D true) если ни одного обработчика не подключено.
     *
     * Эквивалентно $(D length == 0). Удобен в условиях:
     * ---
     * if (!sig.empty) sig.emit(value);
     * ---
     */
    @property bool empty() const { return _slots.length == 0; }


    // ── Генерация сигнала ─────────────────────────────────────────────────────

    /**
     * Вызвать все подключённые обработчики с аргументами $(D args).
     *
     * $(H4 Порядок)
     * Обработчики вызываются в порядке добавления (порядке вызовов connect).
     *
     * $(H4 Безопасность итерации)
     * Перед началом обхода массив копируется: $(D _slots.dup). Это означает:
     * $(UL
     *   $(LI disconnect внутри обработчика — безопасен; текущий обход
     *        проходит по копии и не нарушается.)
     *   $(LI connect внутри обработчика — новый слот попадёт в оригинальный
     *        $(D _slots), но не в копию; он не будет вызван в текущем emit.)
     *   $(LI Стоимость копирования: O(n) аллокация при каждом emit. Если
     *        производительность критична и гарантируется что обработчики
     *        не изменяют список — можно убрать .dup и итерировать _slots напрямую.)
     * )
     *
     * $(H4 Вызов с пустым списком)
     * Если слотов нет, emit является нет-операцией и не вызывает аллокаций
     * ($(D [].dup) не аллоцирует).
     *
     * Params:
     *   args = аргументы, которые будут переданы каждому обработчику.
     *          Тип и количество аргументов определяются параметром шаблона Args.
     *
     * Examples:
     * ---
     * Signal!(string, int) onEvent;
     * onEvent.connect((string name, int code) {
     *     writefln("событие %s, код %d", name, code);
     * });
     * onEvent.emit("login", 200);
     * ---
     */
    void emit(Args args) {
        // .dup создаёт копию массива слотов — защита от изменения _slots
        // внутри обработчика (disconnect/connect во время emit)
        foreach (h; _slots.dup)
            h(args);
    }

    /**
     * Синтаксический сахар: $(D sig(args)) эквивалентно $(D sig.emit(args)).
     *
     * Позволяет использовать сигнал как функциональный объект или функцию:
     * удобно при передаче в алгоритмы или вызове в сокращённой форме.
     *
     * Params:
     *   args = те же аргументы, что и у emit.
     *
     * Examples:
     * ---
     * Signal!int onClick;
     * onClick.connect((int n) { writeln(n); });
     *
     * onClick(5);        // то же что onClick.emit(5)
     * onClick.emit(5);   // эквивалентно
     * ---
     */
    void opCall(Args args) { emit(args); }
}


// ══════════════════════════════════════════════════════════════════════════════
// CSlot!Args — пара (контекст, функция), QTE56-стиль
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Единица подписки в стиле QTE56 ESlot: пара (void* ctx, функция).
 *
 * $(H3 Назначение)
 *
 * В QTE56 все C++-коллбеки имеют сигнатуру:
 * ---
 * extern(C) void callback(void* dthis, Args...);
 * //                      ^^^^^^^^^^ контекст (D-объект)
 * ---
 * $(D CSlot!Args) моделирует одну такую запись: контекст плюс указатель
 * на функцию. Используется как элемент массива внутри $(D ESignal!Args),
 * а также напрямую когда нужен только один обработчик.
 *
 * $(H3 Соглашение о вызовах)
 *
 * Тип $(D Fn) определён как $(D void function(void*, Args)) — D calling
 * convention. На x86-32 (cdecl) и x86-64 (System V AMD64) соглашение D
 * совпадает с C, поэтому $(D extern(C))-функции совместимы через явный cast:
 * ---
 * extern(C) void myCb(void* ctx, int n) { *cast(int*)ctx = n; }
 * auto sl = CSlot!int(myObj, cast(CSlot!int.Fn)&myCb);
 * sl.call(42);
 * ---
 * В чисто-D коде $(D extern(C)) cast не нужен — тип функции совпадает.
 *
 * $(H3 Сравнение)
 *
 * Два $(D CSlot) считаются равными если у них совпадают $(B оба) поля:
 * $(D ctx) и $(D fn). Это позволяет использовать $(D disconnect(ctx, fn))
 * в $(D ESignal).
 *
 * Examples:
 * ---
 * int value = 0;
 *
 * void handler(void* ctx, int n) { *cast(int*)ctx = n; }
 *
 * auto sl = CSlot!int(&value, &handler);
 * sl.call(99);
 * assert(value == 99);
 * assert(!sl.empty);
 *
 * CSlot!int nil;
 * assert(nil.empty);
 * nil.call(0);    // нет-операция, не падает
 * ---
 */
struct CSlot(Args...) {

    // ── Публичные типы ────────────────────────────────────────────────────────

    /**
     * Тип функции-обработчика — D calling convention.
     *
     * Разворачивается в $(D void function(void*, T1, T2, ...)) где T1,T2,...
     * — типы из $(D Args). Никаких variadic ($(D ...)) здесь нет — это
     * фиксированный набор параметров из шаблонного аргумента.
     *
     * $(B Почему не extern(C)):
     * D не позволяет указать $(D extern(C)) inline в сигнатуре параметра
     * шаблонной функции. Поэтому используется D calling convention, которое
     * на целевых платформах (x86-32 cdecl, x86-64 System V) совпадает с C.
     */
    alias Fn = void function(void*, Args);


    // ── Поля ──────────────────────────────────────────────────────────────────

    /**
     * Указатель контекста — передаётся первым аргументом функции $(D fn).
     *
     * Обычно это $(D cast(void*)this) — указатель на D-объект, из которого
     * восстанавливается тип: $(D auto self = cast(MyClass)ctx;).
     * Может быть $(D null) если обработчик не требует контекста.
     */
    void* ctx;

    /**
     * Указатель на функцию-обработчик.
     *
     * Если $(D null) — слот считается пустым, вызов $(D call()) является
     * нет-операцией. Проверяется через свойство $(D empty).
     */
    Fn fn;


    // ── Методы ────────────────────────────────────────────────────────────────

    /**
     * Вызвать функцию $(D fn) с контекстом $(D ctx) и аргументами $(D args).
     *
     * Если $(D fn is null) — нет-операция, исключение не бросается.
     * Это позволяет безопасно хранить «пустые» слоты без дополнительных проверок.
     *
     * Params:
     *   args = аргументы, передаваемые в $(D fn) после $(D ctx).
     *
     * Examples:
     * ---
     * int store = 0;
     * void setter(void* ctx, int n) { *cast(int*)ctx = n; }
     *
     * CSlot!int sl = CSlot!int(&store, &setter);
     * sl.call(7);
     * assert(store == 7);
     * ---
     */
    void call(Args args) {
        if (fn) fn(ctx, args);   // проверка fn перед разыменованием
    }

    /**
     * $(D true) если функция $(D fn) не установлена (равна $(D null)).
     *
     * Пустой слот создаётся инициализацией по умолчанию:
     * $(D CSlot!int nil; assert(nil.empty);)
     */
    @property bool empty() const { return fn is null; }

    /**
     * Сравнение двух слотов по значению.
     *
     * Слоты считаются равными если у них совпадают $(B оба) поля:
     * $(D ctx) и $(D fn). Используется в $(D ESignal.disconnect) для
     * поиска конкретной пары (контекст, функция).
     *
     * Params:
     *   other = другой слот для сравнения.
     *
     * Returns:
     *   $(D true) если ctx и fn идентичны.
     */
    bool opEquals(const CSlot!Args other) const {
        return ctx == other.ctx && fn == other.fn;
    }
}


// ══════════════════════════════════════════════════════════════════════════════
// ESignal!Args — сигнал на C-функциях (QTE56-стиль)
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Сигнал на C-style функциях с контекстом — совместим с QTE56 ESlot.
 *
 * $(H3 Отличие от Signal!Args)
 *
 * $(UL
 *   $(LI $(D Signal!Args) хранит $(D void delegate(Args)) — D-делегаты с
 *        неявным замыканием. Нельзя разделить «контекст» и «функцию» после
 *        создания.)
 *   $(LI $(D ESignal!Args) хранит пары $(D (void* ctx, Fn fn)) явно. Это
 *        позволяет точно идентифицировать слот для disconnect по паре
 *        значений, а не по объекту делегата.)
 * )
 *
 * $(H3 Когда использовать ESignal)
 *
 * $(UL
 *   $(LI Обработчики — $(D extern(C)) или plain-функции уровня модуля.)
 *   $(LI Один объект подключает один слот и потом его отключает
 *        (идентификация по паре ctx+fn надёжнее чем по делегату).)
 *   $(LI Интеграция с C++ DLL через QTE56 ESlot-соглашение.)
 * )
 *
 * $(H3 Безопасность итерации)
 *
 * Аналогично $(D Signal.emit): перед обходом массив копируется через .dup.
 *
 * Examples:
 * ---
 * ESignal!int onProgress;
 *
 * // Обработчик — обычная функция с контекстом
 * void progressHandler(void* ctx, int pct) {
 *     auto bar = cast(ProgressBar)ctx;
 *     bar.setValue(pct);
 * }
 *
 * auto bar = new ProgressBar();
 * onProgress.connect(cast(void*)bar, &progressHandler);
 * onProgress.emit(50);   // bar.setValue(50)
 *
 * onProgress.disconnect(cast(void*)bar, &progressHandler);
 * ---
 */
struct ESignal(Args...) {

    // ── Внутренние типы ───────────────────────────────────────────────────────

    /**
     * Тип одного слота — пара (ctx, fn).
     * Раскрывается в $(D CSlot!Args).
     */
    alias SlotT = CSlot!Args;


    // ── Внутреннее состояние ──────────────────────────────────────────────────

    /**
     * Список зарегистрированных C-слотов.
     * Намеренно private — доступ только через публичные методы.
     */
    private SlotT[] _slots;


    // ── Подключение / отключение ──────────────────────────────────────────────

    /**
     * Подключить C-обработчик с контекстом.
     *
     * Создаёт $(D CSlot!Args(ctx, fn)) и добавляет его в конец списка.
     * Один и тот же сочетание (ctx, fn) можно добавить несколько раз —
     * каждый раз оно вызывается как отдельная запись.
     *
     * Params:
     *   ctx = контекст, передаётся первым аргументом $(D fn).
     *         Может быть $(D null) для stateless-функций.
     *   fn  = указатель на функцию типа $(D SlotT.Fn); не должен быть null.
     *
     * Throws:
     *   $(D AssertError) в debug-сборке если $(D fn is null).
     *
     * Examples:
     * ---
     * ESignal!string onLog;
     * void logHandler(void* ctx, string msg) { writeln(msg); }
     * onLog.connect(null, &logHandler);
     * onLog.emit("тест");
     * ---
     */
    void connect(void* ctx, SlotT.Fn fn)
    in (fn !is null, "ESignal.connect: функция не может быть null")
    {
        _slots ~= SlotT(ctx, fn);   // создаём пару и добавляем в список
    }

    /**
     * Отключить $(B первое) вхождение пары $(D (ctx, fn)).
     *
     * Поиск использует $(D CSlot.opEquals) — сравнение по обоим полям.
     * Если пара не найдена — нет-операция.
     *
     * Params:
     *   ctx = тот же указатель контекста, что был передан в connect.
     *   fn  = тот же указатель функции, что был передан в connect.
     *
     * Examples:
     * ---
     * ESignal!int sig;
     * int store = 0;
     * void h(void* ctx, int n) { *cast(int*)ctx += n; }
     *
     * sig.connect(&store, &h);
     * sig.emit(5);              // store == 5
     * sig.disconnect(&store, &h);
     * sig.emit(5);              // store всё ещё 5
     * ---
     */
    void disconnect(void* ctx, SlotT.Fn fn) {
        // Строим временный SlotT для поиска через opEquals
        auto needle = SlotT(ctx, fn);
        auto idx = _slots.countUntil(needle);
        if (idx >= 0)
            _slots = _slots.remove(cast(size_t)idx);
    }

    /**
     * Отключить все обработчики.
     *
     * После вызова $(D length == 0) и $(D empty == true).
     */
    void clear() { _slots.length = 0; }


    // ── Состояние ─────────────────────────────────────────────────────────────

    /**
     * Количество подключённых C-слотов.
     */
    @property size_t length() const { return _slots.length; }

    /**
     * $(D true) если список слотов пуст.
     */
    @property bool empty() const { return _slots.length == 0; }


    // ── Генерация сигнала ─────────────────────────────────────────────────────

    /**
     * Вызвать все подключённые C-обработчики с аргументами $(D args).
     *
     * Каждый слот вызывается через $(D CSlot.call(args)), который
     * передаёт $(D ctx) первым аргументом функции.
     *
     * Массив слотов копируется перед обходом ($(D .dup)) — те же гарантии
     * безопасности, что у $(D Signal.emit).
     *
     * Params:
     *   args = аргументы, передаваемые в каждый обработчик (после ctx).
     */
    void emit(Args args) {
        // ref — избегаем копирования SlotT при обходе (ctx и fn — указатели,
        // но ref явно говорит о намерении не копировать)
        foreach (ref s; _slots.dup)
            s.call(args);
    }

    /**
     * Синтаксический сахар: $(D sig(args)) == $(D sig.emit(args)).
     *
     * Params:
     *   args = аргументы сигнала.
     */
    void opCall(Args args) { emit(args); }
}


// ══════════════════════════════════════════════════════════════════════════════
// slot() — мост C-функция → D-делегат
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Создать D-делегат из пары (ctx, функция) типа $(D CSlot!Args.Fn).
 *
 * $(H3 Зачем это нужно)
 *
 * $(D Signal!Args) хранит D-делегаты, а у вас есть plain-функция с сигнатурой
 * $(D void function(void* ctx, Args)). Напрямую передать её в $(D Signal.connect)
 * нельзя — тип не совпадает. Функция $(D slot()) создаёт замыкание, которое
 * захватывает пару (ctx, fn) и предоставляет нужный интерфейс делегата.
 *
 * $(H3 Альтернатива)
 *
 * Если нужно управлять списком C-слотов с возможностью disconnect —
 * используйте $(D ESignal!Args) напрямую. $(D slot()) удобен когда нужно
 * смешать D-делегаты и C-функции в одном $(D Signal).
 *
 * $(H3 Тип fn)
 *
 * Параметр $(D fn) имеет тип $(D CSlot!Args.Fn), то есть
 * $(D void function(void*, Args)) — D calling convention. На x86-32/64
 * это совпадает с C ABI. Для $(D extern(C))-функций при необходимости
 * выполните явный cast: $(D cast(CSlot!int.Fn)&myExternCFn).
 *
 * $(H3 Захват по значению)
 *
 * Замыкание захватывает $(D ctx) и $(D fn) $(B по значению) в момент вызова
 * $(D slot()). Последующее изменение переменных, хранящих эти значения,
 * не влияет на созданный делегат.
 *
 * Params:
 *   ctx = контекст, передаётся функции $(D fn) первым аргументом.
 *         Может быть $(D null) для stateless-функций.
 *   fn  = указатель на функцию; не должен быть $(D null).
 *
 * Returns:
 *   Делегат $(D void delegate(Args)), пригодный для $(D Signal!Args.connect).
 *   Делегат владеет замыканием (GC-аллоцированным объектом), которое хранит
 *   (ctx, fn).
 *
 * Throws:
 *   $(D AssertError) в debug-сборке если $(D fn is null).
 *
 * Examples:
 * ---
 * Signal!int onClick;
 *
 * int counter = 0;
 * void incrementBy(void* ctx, int n) { *cast(int*)ctx += n; }
 *
 * // Подключаем plain-функцию через slot()
 * onClick.connect(slot!int(&counter, &incrementBy));
 * onClick.emit(10);   // counter == 10
 * onClick.emit(5);    // counter == 15
 *
 * // Смешиваем с D-делегатом в одном сигнале
 * onClick.connect((int n) { writeln("параллельный слот: ", n); });
 * onClick.emit(1);   // вызовет оба обработчика
 * ---
 */
void delegate(Args) slot(Args...)(void* ctx, CSlot!Args.Fn fn)
in (fn !is null, "slot: функция не может быть null")
{
    // Создаём замыкание: лямбда захватывает ctx и fn по значению.
    // При вызове делегата — пробрасываем args в fn, предваряя их ctx.
    return (Args args) { fn(ctx, args); };
}


// ══════════════════════════════════════════════════════════════════════════════
// Внутренние unit-тесты (запуск: dmd -unittest / ldc2 -unittest)
// ══════════════════════════════════════════════════════════════════════════════

version (unittest) {
    /**
     * Вспомогательные счётчики для unit-тестов.
     * Используются функцией check() — аналог assert с накоплением результата.
     */
    private int _tPassed, _tFailed;

    /**
     * Проверить условие и обновить счётчики pass/fail.
     *
     * Params:
     *   name = человекочитаемое имя проверки (для вывода при ошибке).
     *   cond = проверяемое условие.
     *   file = файл источника (подставляется автоматически).
     *   line = номер строки (подставляется автоматически).
     */
    private void check(string name, bool cond,
                       string file = __FILE__, int line = __LINE__)
    {
        import std.stdio : writefln;
        if (cond) {
            _tPassed++;
        } else {
            _tFailed++;
            writefln("  FAIL  %s  (%s:%d)", name, file, line);
        }
    }
}

/**
 * Проверка базовых операций $(D Signal!int): connect, emit, disconnect, clear.
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: Signal!int ===");

    Signal!int sig;

    int sum = 0;
    // Сохраняем делегаты в переменные — нужно для disconnect
    void delegate(int) h1 = (int n) { sum += n; };
    void delegate(int) h2 = (int n) { sum += n * 2; };

    // ── Начальное состояние ─────────────────────────────────────────
    sig.emit(1);   // не должен падать на пустом списке
    check("emit empty — no crash",  true);
    check("empty.length == 0",      sig.length == 0);
    check("empty.empty == true",    sig.empty);

    // ── connect ──────────────────────────────────────────────────────
    sig.connect(h1);
    check("after connect length == 1", sig.length == 1);
    sig.connect(h2);
    check("after 2 connects length == 2", sig.length == 2);

    // ── emit — оба обработчика вызваны ──────────────────────────────
    sum = 0;
    sig.emit(10);
    // h1: sum += 10 → 10; h2: sum += 20 → 30
    check("emit calls both handlers", sum == 30);

    // ── opCall — синтаксический сахар ───────────────────────────────
    sum = 0;
    sig(5);
    // h1: sum += 5 → 5; h2: sum += 10 → 15
    check("opCall sugar", sum == 15);

    // ── disconnect — удаляет только первое вхождение ────────────────
    sig.disconnect(h1);
    check("after disconnect length == 1", sig.length == 1);
    sum = 0;
    sig.emit(3);
    // только h2: sum += 6 → 6
    check("only h2 remains", sum == 6);

    // ── disconnect несуществующего — нет-операция ───────────────────
    sig.disconnect(h1);   // h1 уже отключён
    check("disconnect non-existent is noop", sig.length == 1);

    // ── clear ────────────────────────────────────────────────────────
    sig.clear();
    check("clear() sets length to 0", sig.length == 0);
    check("empty after clear",        sig.empty);
    sig.emit(99);   // не должен падать
    check("emit after clear: no crash", true);

    writeln("  passed: ", _tPassed, "  failed: ", _tFailed);
}

/**
 * Проверка $(D Signal!(string, int)) — несколько разнотипных параметров.
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: Signal!(string, int) ===");

    Signal!(string, int) sig;

    string gotKey;
    int    gotVal;

    // Обработчик принимает оба параметра
    sig.connect((string k, int v) { gotKey = k; gotVal = v; });

    sig.emit("hello", 42);
    check("multi-param emit key", gotKey == "hello");
    check("multi-param emit val", gotVal == 42);

    // Два обработчика — каждый видит оба аргумента
    string lastKey = "";
    sig.connect((string k, int v) { lastKey = k ~ "!"; });
    sig.emit("foo", 7);
    check("two handlers — first receives key",  gotKey  == "foo");
    check("two handlers — second appends bang", lastKey == "foo!");
}

/**
 * Проверка $(D Signal!()) — сигнал вообще без параметров.
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: Signal!() (no args) ===");

    Signal!() onFired;
    int cnt = 0;

    onFired.connect(() { cnt++; });
    onFired.emit();
    onFired.emit();
    check("no-args signal emit x2", cnt == 2);

    onFired();   // opCall без аргументов
    check("no-args opCall", cnt == 3);
}

/**
 * Проверка дублирующихся подключений и $(D disconnectAll).
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: duplicate connect / disconnectAll ===");

    Signal!int sig;
    int cnt = 0;
    void delegate(int) h = (int n) { cnt++; };

    // Подключаем один и тот же делегат трижды
    sig.connect(h);
    sig.connect(h);
    sig.connect(h);
    check("triple connect: length == 3", sig.length == 3);

    sig.emit(0);
    check("triple connect: emit calls 3 times", cnt == 3);

    // disconnect — удаляет только первое из трёх вхождений
    sig.disconnect(h);
    check("disconnect once: length == 2", sig.length == 2);

    // disconnectAll — удаляет оставшиеся два
    sig.disconnectAll(h);
    check("disconnectAll: length == 0", sig.length == 0);
    cnt = 0;
    sig.emit(0);
    check("emit after disconnectAll: 0 calls", cnt == 0);
}

/**
 * Проверка безопасности итерации: $(D disconnect) и $(D connect) внутри $(D emit).
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: disconnect inside emit ===");

    Signal!int sig;
    int cnt = 0;

    // h1 при вызове отключает h2.
    // Благодаря .dup, h2 всё равно вызывается в текущем emit.
    void delegate(int) h2;
    void delegate(int) h1 = (int n) {
        cnt++;
        sig.disconnect(h2);   // изменяет _slots, но emit работает с копией
    };
    h2 = (int n) { cnt++; };

    sig.connect(h1);
    sig.connect(h2);

    cnt = 0;
    sig.emit(0);
    // Оба вызваны: h1 отключил h2, но в этом emit h2 уже был в копии
    check("both called in same emit (dup protection)", cnt == 2);

    // Следующий emit — h2 уже отключён, только h1
    cnt = 0;
    sig.emit(0);
    check("h2 absent in next emit", cnt == 1);

    // connect внутри emit — новый слот не попадает в текущий обход
    int newCnt = 0;
    void delegate(int) hNew   = (int n) { newCnt++; };
    void delegate(int) hAdder = (int n) { sig.connect(hNew); };

    sig.clear();
    sig.connect(hAdder);
    sig.emit(0);
    check("new connect inside emit: not called this time", newCnt == 0);
    sig.emit(0);   // теперь hNew тоже в _slots
    check("new connect inside emit: called next time",    newCnt == 1);
}

/**
 * Проверка $(D ESignal!int) — C-функции с контекстом.
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: ESignal!int ===");

    ESignal!int sig;

    check("initial empty",      sig.empty);
    check("initial length == 0", sig.length == 0);

    // Используем адреса int-переменных как контексты
    int storeA = 0, storeB = 0;

    // static — функция уровня модуля внутри unittest; не замыкание
    static void cbA(void* ctx, int n) { *cast(int*)ctx += n;     }
    static void cbB(void* ctx, int n) { *cast(int*)ctx += n * 2; }

    sig.connect(&storeA, &cbA);
    sig.connect(&storeB, &cbB);
    check("two slots: length == 2", sig.length == 2);

    sig.emit(10);
    // cbA: storeA += 10 → 10; cbB: storeB += 20 → 20
    check("ESignal cbA: 0+10 == 10",  storeA == 10);
    check("ESignal cbB: 0+20 == 20",  storeB == 20);

    // opCall — синтаксический сахар
    sig(5);
    check("ESignal opCall cbA: 10+5 == 15",  storeA == 15);
    check("ESignal opCall cbB: 20+10 == 30", storeB == 30);

    // disconnect cbA по паре (&storeA, &cbA)
    sig.disconnect(&storeA, &cbA);
    check("after disconnect: length == 1", sig.length == 1);

    sig.emit(3);
    // cbA отключён — storeA не меняется; cbB: storeB += 6 → 36
    check("cbA unchanged after disconnect", storeA == 15);
    check("cbB updated after disconnect",   storeB == 36);

    sig.clear();
    check("ESignal clear: empty", sig.empty);
    sig.emit(99);   // нет-операция
    check("ESignal emit after clear: no crash", true);
}

/**
 * Проверка функции $(D slot()) — создание делегата из пары (ctx, fn).
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: slot() bridge ===");

    Signal!int sig;

    int myCtx = 0;

    // plain-функция (не extern(C) — нет нужды в D-D коде)
    static void myCb(void* ctx, int n) {
        *cast(int*)ctx = n;
    }

    // slot() создаёт замыкание: при вызове делегата → myCb(&myCtx, n)
    sig.connect(slot!int(&myCtx, &myCb));
    check("slot bridge: length == 1", sig.length == 1);

    sig.emit(77);
    check("slot bridge emit: myCtx == 77", myCtx == 77);

    sig.emit(3);
    check("slot bridge emit x2: myCtx == 3", myCtx == 3);
}

/**
 * Проверка $(D CSlot!int) — прямое использование структуры.
 */
unittest {
    import std.stdio : writeln;
    writeln("=== unittest: CSlot!int ===");

    int store = 0;

    static void cb(void* ctx, int n) { *cast(int*)ctx = n; }

    // Создаём слот — пара (&store, &cb)
    auto sl = CSlot!int(&store, &cb);
    check("CSlot not empty", !sl.empty);

    sl.call(42);
    check("CSlot call: store == 42", store == 42);

    sl.call(-1);
    check("CSlot call: store == -1", store == -1);

    // Пустой CSlot (инициализация по умолчанию: ctx=null, fn=null)
    CSlot!int nil;
    check("null CSlot empty", nil.empty);
    nil.call(99);   // не должен падать — fn is null → нет-операция
    check("null CSlot call noop: store unchanged", store == -1);

    // Сравнение: одинаковые ctx и fn → равны
    auto sl2 = CSlot!int(&store, &cb);
    check("same ctx+fn: equal",    sl == sl2);

    // Разный ctx → не равны
    int store2 = 0;
    auto sl3 = CSlot!int(&store2, &cb);
    check("different ctx: not equal", sl != sl3);
}
