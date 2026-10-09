/**
 * gen_qbytearray.d — D-обёртка для QByteArray (тип-значение, размещаемый на куче).
 *
 * DLL: qte56_foundation.dll  |  Индексы pFunQt: 19969–19998
 *
 * $(B Владение памятью:) по умолчанию D владеет указателем QByteArray*
 * (_qt_owned = false). Деструктор D-класса вызывает qteQByteArray_delete,
 * если объект не передан в Qt (disown не вызван).
 * Все методы-трансформации (mid/left/right/toUpper/…) возвращают новые
 * D-владеющие объекты — освобождаются автоматически GC.
 *
 * $(B Прямой доступ к байтам:) constDataPtr() возвращает указатель
 * непосредственно в Qt-буфер — действителен только пока объект жив
 * и не модифицирован. Для безопасного копирования в D GC-память
 * используйте toSlice() / toString().
 *
 * $(B Полное тестирование:) test/test_qbytearray.d (требует загрузки DLL).
 */
module gen_qbytearray;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : toQString, t_i__qp, t_i__qp_qp,
    t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_qp;
import gen_qcore;  // для квалифицированного вызова gen_qcore.fromQString

// Дополнительные псевдонимы типов функций (void* используется вместо const void* — ABI совместим)
mixin(generateAlias("qp__qp_i"));      // void*(void*, int)           — left/right
mixin(generateAlias("qp__qp_i_i"));    // void*(void*, int, int)      — mid
mixin(generateAlias("i__qp_qp_i"));    // int(void*, void*, int)      — contains/startsWith/endsWith
mixin(generateAlias("i__qp_qp_i_i"));  // int(void*, void*, int, int) — indexOf
mixin(generateAlias("v__qp_qp_i"));    // void(void*, void*, int)     — append/prepend
mixin(generateAlias("v__qp_i_i"));     // void(void*, int, int)       — set/resize
mixin(generateAlias("i__qp_i"));       // int(void*, int)             — at/opIndex

// ====================================================================
// Загрузка таблицы функций
// ====================================================================

/**
 * Загружает адреса всех C++-функций QByteArray из DLL в таблицу pFunQt.
 * Вызывается автоматически через registerModule при первом обращении к модулю.
 *
 * Note:
 *   Все 30 функций (индексы 19969–19998) принадлежат одному DLL-модулю
 *   qte56_foundation.dll и регистрируются под именем "QByteArray".
 */
void loadQByteArray() {
    // Жизненный цикл объекта
    mixin(generateFunQt(19969, "qteQByteArray_create",     "QByteArray")); /// создать пустой QByteArray
    mixin(generateFunQt(19970, "qteQByteArray_fromPtr",    "QByteArray")); /// создать из указателя на байты + длина
    mixin(generateFunQt(19971, "qteQByteArray_delete",     "QByteArray")); /// освободить QByteArray*
    mixin(generateFunQt(19972, "qteQByteArray_copy",       "QByteArray")); /// глубокая копия (Qt QByteArray::QByteArray(const QByteArray&))
    // Размер и доступ к данным
    mixin(generateFunQt(19973, "qteQByteArray_size",       "QByteArray")); /// количество байт
    mixin(generateFunQt(19974, "qteQByteArray_isEmpty",    "QByteArray")); /// проверка на пустоту
    mixin(generateFunQt(19975, "qteQByteArray_constData",  "QByteArray")); /// сырой указатель на внутренний буфер Qt
    mixin(generateFunQt(19976, "qteQByteArray_at",         "QByteArray")); /// чтение байта по индексу
    mixin(generateFunQt(19977, "qteQByteArray_set",        "QByteArray")); /// запись байта по индексу
    // Мутирующие операции
    mixin(generateFunQt(19978, "qteQByteArray_append",     "QByteArray")); /// добавить байты в конец
    mixin(generateFunQt(19979, "qteQByteArray_prepend",    "QByteArray")); /// добавить байты в начало
    mixin(generateFunQt(19980, "qteQByteArray_resize",     "QByteArray")); /// изменить размер буфера
    mixin(generateFunQt(19981, "qteQByteArray_clear",      "QByteArray")); /// очистить (size → 0)
    mixin(generateFunQt(19982, "qteQByteArray_chop",       "QByteArray")); /// отрезать n байт с конца
    // Срезы и преобразования (возвращают новый объект)
    mixin(generateFunQt(19983, "qteQByteArray_mid",        "QByteArray")); /// подмассив с позиции pos, длина len
    mixin(generateFunQt(19984, "qteQByteArray_left",       "QByteArray")); /// первые n байт
    mixin(generateFunQt(19985, "qteQByteArray_right",      "QByteArray")); /// последние n байт
    mixin(generateFunQt(19986, "qteQByteArray_toUpper",    "QByteArray")); /// ASCII-перевод в верхний регистр
    mixin(generateFunQt(19987, "qteQByteArray_toLower",    "QByteArray")); /// ASCII-перевод в нижний регистр
    mixin(generateFunQt(19988, "qteQByteArray_trimmed",    "QByteArray")); /// удалить пробелы/\r\n по краям
    // Поиск
    mixin(generateFunQt(19989, "qteQByteArray_indexOf",    "QByteArray")); /// индекс первого вхождения, -1 если нет
    mixin(generateFunQt(19990, "qteQByteArray_contains",   "QByteArray")); /// содержит ли подпоследовательность
    mixin(generateFunQt(19991, "qteQByteArray_startsWith", "QByteArray")); /// начинается ли с префикса
    mixin(generateFunQt(19992, "qteQByteArray_endsWith",   "QByteArray")); /// заканчивается ли суффиксом
    // Кодирование
    mixin(generateFunQt(19993, "qteQByteArray_toHex",      "QByteArray")); /// hex-кодирование → новый QByteArray
    mixin(generateFunQt(19994, "qteQByteArray_toBase64",   "QByteArray")); /// Base64-кодирование → новый QByteArray
    mixin(generateFunQt(19995, "qteQByteArray_fromBase64", "QByteArray")); /// Base64-декодирование → новый QByteArray
    // Взаимодействие с QString
    mixin(generateFunQt(19996, "qteQByteArray_toQString",  "QByteArray")); /// UTF-8 байты → new QString*
    mixin(generateFunQt(19997, "qteQByteArray_fromQString","QByteArray")); /// QString → UTF-8 QByteArray
    // Сравнение
    mixin(generateFunQt(19998, "qteQByteArray_equal",      "QByteArray")); /// побайтовое равенство двух QByteArray
}

/**
 * Статический конструктор модуля: регистрирует QByteArray в системе загрузки.
 *
 * Note:
 *   Вызывается D runtime при запуске программы до main().
 *   Фактическая загрузка функций из DLL происходит лениво —
 *   при первом вызове LoadQt().
 */
static this() {
    registerModule("QByteArray", "qte56_foundation.dll", &loadQByteArray);
}

// ====================================================================
// D-класс QByteArray
// ====================================================================

/**
 * D-обёртка для Qt QByteArray — произвольный набор байт, размещаемый на куче.
 *
 * Класс предоставляет полный набор операций Qt QByteArray через таблицу
 * указателей pFunQt (индексы 19969–19998, DLL qte56_foundation.dll).
 *
 * $(B Модель владения:)
 * $(UL
 *   $(LI По умолчанию D владеет объектом: деструктор вызывает qteQByteArray_delete.)
 *   $(LI После вызова disown() или передачи Qt-виджету — Qt управляет памятью.)
 *   $(LI wrap(ptr) создаёт D-владеющую обёртку над уже существующим QByteArray*.)
 * )
 *
 * $(B Типичное использование:)
 * ---
 * // Создание из байт
 * auto ba = new QByteArray(cast(ubyte[])[0xDE, 0xAD, 0xBE, 0xEF]);
 * assert(ba.size() == 4);
 *
 * // Строковые данные
 * auto ba2 = new QByteArray("Hello");
 * assert(ba2.toString() == "Hello");
 *
 * // Кодирование
 * string b64 = ba.toBase64String();   // "3q2+7w=="
 * string hex = ba.toHexString();      // "deadbeef"
 * ---
 *
 * Note:
 *   Полное тестирование — test/test_qbytearray.d (требует DLL).
 */
@live class QByteArray {
private:
    void*  _wh;        /// указатель на нативный QByteArray* в памяти Qt
    bool   _qt_owned;  /// true — Qt владеет объектом, деструктор D не удаляет

    /**
     * Внутренний конструктор-заглушка для wrap() и dup().
     * Создаёт объект-оболочку без вызова Qt — _wh устанавливается снаружи.
     *
     * Params:
     *   _dummy = фиктивный параметр, нужен для разрешения перегрузки.
     */
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    // ── Конструкторы ──────────────────────────────────────────────────────

    /**
     * Создаёт пустой QByteArray (size == 0).
     *
     * Example:
     * ---
     * auto ba = new QByteArray();
     * assert(ba.isEmpty());
     * ---
     */
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[19969])();
    }

    /**
     * Создаёт QByteArray из D-среза ubyte[] — данные копируются в Qt.
     *
     * Params:
     *   data = источник байт; допускается пустой срез.
     *
     * Note:
     *   Байты копируются, срез можно освободить после конструктора.
     *
     * Example:
     * ---
     * auto ba = new QByteArray(cast(ubyte[])[1, 2, 3]);
     * assert(ba.size() == 3);
     * ---
     */
    this(scope const(ubyte)[] data) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp_i)pFunQt[19970])(cast(void*)data.ptr, cast(int)data.length);
    }

    /**
     * Создаёт QByteArray из D-строки (байты копируются как есть, без перекодировки).
     *
     * Params:
     *   s = строка-источник (интерпретируется как сырые байты, не UTF-8).
     *
     * Note:
     *   Для корректного UTF-8 round-trip (D string → QByteArray → D string)
     *   используйте fromQString() / toStringQt().
     *
     * Example:
     * ---
     * auto ba = new QByteArray("hello");
     * assert(ba.size() == 5);
     * ---
     */
    this(scope const(char)[] s) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp_i)pFunQt[19970])(cast(void*)s.ptr, cast(int)s.length);
    }

    /**
     * Деструктор: освобождает нативный QByteArray*, если D им владеет.
     *
     * Note:
     *   Не вызывается если _qt_owned == true (disown() был вызван)
     *   или если pFunQt ещё не загружен (DLL не загружена).
     */
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19971] !is null) {
            (cast(t_v__qp)pFunQt[19971])(_wh);
            _wh = null;
        }
    }

    // ── Фабричные методы ──────────────────────────────────────────────────

    /**
     * Оборачивает уже существующий QByteArray* — D берёт владение.
     *
     * Params:
     *   ptr = указатель на нативный QByteArray*, созданный Qt C++.
     *         Если null — возвращает null.
     *
     * Returns:
     *   Новый D-объект QByteArray, владеющий ptr, или null.
     *
     * Note:
     *   Используется внутри методов-трансформаций (mid, left, toHex и др.)
     *   для упаковки возвращаемых Qt указателей.
     */
    static QByteArray wrap(void* ptr) {
        if (ptr is null) return null;
        auto b = new QByteArray(false);
        b._wh = ptr;
        return b;
    }

    /**
     * Глубокая копия: возвращает новый независимый D-владеющий QByteArray
     * с тем же содержимым (Qt QByteArray copy constructor).
     *
     * Returns:
     *   Новый объект QByteArray с скопированными данными.
     *
     * Example:
     * ---
     * auto ba  = new QByteArray("abc");
     * auto ba2 = ba.dup();
     * assert(ba == ba2);
     * ---
     */
    QByteArray dup() {
        return QByteArray.wrap((cast(t_qp__qp)pFunQt[19972])(_wh));
    }

    // ── Размер и доступ к данным ──────────────────────────────────────────

    /**
     * Возвращает число байт в массиве.
     *
     * Returns: количество байт (≥ 0).
     */
    int  size()    { return (cast(t_i__qp)pFunQt[19973])(_wh); }

    /**
     * Псевдоним size() для совместимости с D-идиомами (arr.length).
     *
     * Returns: количество байт (≥ 0).
     */
    int  length()  { return size(); }

    /**
     * Проверяет, пуст ли массив (size == 0).
     *
     * Returns: true если байт нет.
     */
    bool isEmpty() { return (cast(t_i__qp)pFunQt[19974])(_wh) != 0; }

    /**
     * Возвращает сырой указатель на внутренний буфер Qt без копирования.
     *
     * Returns:
     *   const(void)* — указатель на первый байт Qt-буфера.
     *
     * Note:
     *   Указатель действителен только пока данный QByteArray существует
     *   и не модифицирован. Не сохраняйте указатель дольше жизни объекта.
     *   Для безопасной работы используйте toSlice() или toString().
     */
    const(void)* constDataPtr() {
        return cast(const(void)*)(cast(t_qp__qp)pFunQt[19975])(_wh);
    }

    /**
     * Копирует все байты в D GC-память и возвращает ubyte[].
     *
     * Returns:
     *   ubyte[] — срез в GC-памяти D, или null если массив пуст.
     *
     * Note:
     *   Результат независим от жизни QByteArray — безопасно хранить.
     */
    ubyte[] toSlice() {
        int n = size();
        if (n == 0) return null;
        auto ptr = cast(const(ubyte)*)constDataPtr();
        return ptr[0 .. n].dup;
    }

    /**
     * Интерпретирует содержимое как байты UTF-8 и возвращает D string.
     * Байты копируются в GC-память.
     *
     * Returns:
     *   Строка D (иммутабельные байты); "" если массив пуст.
     *
     * Note:
     *   Корректность UTF-8 не проверяется — байты копируются as-is.
     *   Для декодирования через Qt используйте toStringQt().
     */
    override string toString() {
        int n = size();
        if (n == 0) return "";
        auto ptr = cast(const(char)*)constDataPtr();
        return ptr[0 .. n].idup;
    }

    /**
     * Читает один байт по индексу.
     *
     * Params:
     *   i = индекс (0 .. size-1).
     *
     * Returns: ubyte — значение байта.
     *
     * Note:
     *   Qt не проверяет границы в release-сборке — выход за пределы UB.
     */
    ubyte opIndex(int i) {
        return cast(ubyte)(cast(t_i__qp_i)pFunQt[19976])(_wh, i);
    }

    /**
     * Записывает один байт по индексу.
     *
     * Params:
     *   b = значение байта для записи.
     *   i = индекс (0 .. size-1).
     *
     * Note:
     *   Qt не проверяет границы в release-сборке — выход за пределы UB.
     */
    QByteArray opIndexAssign(ubyte b, int i) {
        (cast(t_v__qp_i_i)pFunQt[19977])(_wh, i, cast(int)b);
        return this;
    }

    // ── Мутирующие операции ───────────────────────────────────────────────

    /**
     * Добавляет байты из D-среза в конец массива.
     *
     * Params:
     *   data = добавляемые байты.
     */
    QByteArray append(scope const(ubyte)[] data) {
        (cast(t_v__qp_qp_i)pFunQt[19978])(_wh, cast(void*)data.ptr, cast(int)data.length);
        return this;
    }

    /**
     * Добавляет байты из D-строки в конец массива (без перекодировки).
     *
     * Params:
     *   s = добавляемая строка (байты копируются как есть).
     */
    QByteArray append(scope const(char)[] s) {
        (cast(t_v__qp_qp_i)pFunQt[19978])(_wh, cast(void*)s.ptr, cast(int)s.length);
        return this;
    }

    /**
     * Добавляет содержимое другого QByteArray в конец.
     *
     * Params:
     *   other = источник байт; должен быть не null.
     *
     * Note:
     *   Реализовано через toSlice() + append(ubyte[]).
     */
    QByteArray append(QByteArray other) {
        auto sl = other.toSlice();
        if (sl.length) append(sl);
        return this;
    }

    /**
     * Оператор ~= для конкатенации: ba ~= bytes / ba ~= str / ba ~= other.
     *
     * Example:
     * ---
     * auto ba = new QByteArray("He");
     * ba ~= cast(ubyte[])"llo";
     * assert(ba.toString() == "Hello");
     * ---
     */
    QByteArray opOpAssign(string op : "~")(scope const(ubyte)[] data) { append(data); return this; }
    /// ditto
    QByteArray opOpAssign(string op : "~")(scope const(char)[] s)     { append(s); return this; }
    /// ditto
    QByteArray opOpAssign(string op : "~")(QByteArray other)           { append(other); return this; }

    /**
     * Вставляет байты из D-среза перед началом массива.
     *
     * Params:
     *   data = байты для вставки в начало.
     */
    QByteArray prepend(scope const(ubyte)[] data) {
        (cast(t_v__qp_qp_i)pFunQt[19979])(_wh, cast(void*)data.ptr, cast(int)data.length);
        return this;
    }

    /**
     * Вставляет байты из D-строки перед началом массива.
     *
     * Params:
     *   s = строка для вставки (байты копируются как есть).
     */
    QByteArray prepend(scope const(char)[] s) {
        (cast(t_v__qp_qp_i)pFunQt[19979])(_wh, cast(void*)s.ptr, cast(int)s.length);
        return this;
    }

    /**
     * Устанавливает новый размер буфера.
     * Если n > size(), новые байты заполняются нулями.
     * Если n < size(), данные усекаются.
     *
     * Params:
     *   n = новый размер в байтах (≥ 0).
     */
    QByteArray resize(int n)  { (cast(t_v__qp_i)pFunQt[19980])(_wh, n); return this; }

    /**
     * Очищает массив — устанавливает size в 0 и освобождает буфер.
     *
     * Note:
     *   После clear() isEmpty() == true.
     */
    QByteArray clear()        { (cast(t_v__qp)pFunQt[19981])(_wh); return this; }

    /**
     * Удаляет последние n байт с конца массива.
     *
     * Params:
     *   n = число байт для удаления. Если n >= size(), результат пустой массив.
     */
    QByteArray chop(int n)    { (cast(t_v__qp_i)pFunQt[19982])(_wh, n); return this; }

    // ── Срезы и преобразования ────────────────────────────────────────────

    /**
     * Возвращает подмассив, начиная с позиции pos длиной len.
     *
     * Params:
     *   pos = начальная позиция (0-based).
     *   len = длина подмассива; -1 означает "до конца".
     *
     * Returns:
     *   Новый D-владеющий QByteArray с копией данных.
     *
     * Example:
     * ---
     * auto ba  = new QByteArray("Hello, World");
     * auto sub = ba.mid(7, 5);  // "World"
     * ---
     */
    QByteArray mid(int pos, int len = -1) {
        return QByteArray.wrap((cast(t_qp__qp_i_i)pFunQt[19983])(_wh, pos, len));
    }

    /**
     * Возвращает первые n байт.
     *
     * Params:
     *   n = число байт от начала.
     *
     * Returns: новый D-владеющий QByteArray.
     */
    QByteArray left (int n) { return QByteArray.wrap((cast(t_qp__qp_i)pFunQt[19984])(_wh, n)); }

    /**
     * Возвращает последние n байт.
     *
     * Params:
     *   n = число байт от конца.
     *
     * Returns: новый D-владеющий QByteArray.
     */
    QByteArray right(int n) { return QByteArray.wrap((cast(t_qp__qp_i)pFunQt[19985])(_wh, n)); }

    /**
     * Возвращает копию с ASCII-символами, переведёнными в верхний регистр.
     * Байты не из диапазона a–z остаются без изменений.
     *
     * Returns: новый D-владеющий QByteArray.
     */
    QByteArray toUpper()    { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19986])(_wh)); }

    /**
     * Возвращает копию с ASCII-символами, переведёнными в нижний регистр.
     * Байты не из диапазона A–Z остаются без изменений.
     *
     * Returns: новый D-владеющий QByteArray.
     */
    QByteArray toLower()    { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19987])(_wh)); }

    /**
     * Возвращает копию без ведущих и хвостовых пробельных байт
     * (0x09–0x0D, 0x20).
     *
     * Returns: новый D-владеющий QByteArray.
     */
    QByteArray trimmed()    { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19988])(_wh)); }

    // ── Поиск ─────────────────────────────────────────────────────────────

    /**
     * Ищет первое вхождение последовательности байт начиная с позиции from.
     *
     * Params:
     *   data = искомая последовательность байт.
     *   from = позиция, с которой начинать поиск (по умолчанию 0).
     *
     * Returns:
     *   Индекс первого совпадения, или -1 если не найдено.
     */
    int indexOf(scope const(ubyte)[] data, int from = 0) {
        return (cast(t_i__qp_qp_i_i)pFunQt[19989])(_wh, cast(void*)data.ptr, cast(int)data.length, from);
    }

    /**
     * Ищет первое вхождение строки-байт начиная с позиции from.
     *
     * Params:
     *   s    = искомая подстрока (байты).
     *   from = позиция начала поиска.
     *
     * Returns:
     *   Индекс первого совпадения, или -1.
     */
    int indexOf(scope const(char)[] s, int from = 0) {
        return (cast(t_i__qp_qp_i_i)pFunQt[19989])(_wh, cast(void*)s.ptr, cast(int)s.length, from);
    }

    /**
     * Проверяет, содержит ли массив заданную последовательность байт.
     *
     * Params:
     *   data = искомая последовательность.
     *
     * Returns: true если вхождение найдено.
     */
    bool contains(scope const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[19990])(_wh, cast(void*)data.ptr, cast(int)data.length) != 0;
    }

    /**
     * Проверяет, содержит ли массив заданные байты строки.
     *
     * Params:
     *   s = искомая подстрока (байты).
     *
     * Returns: true если вхождение найдено.
     */
    bool contains(scope const(char)[] s) {
        return (cast(t_i__qp_qp_i)pFunQt[19990])(_wh, cast(void*)s.ptr, cast(int)s.length) != 0;
    }

    /**
     * Проверяет, начинается ли массив с заданного префикса байт.
     *
     * Params:
     *   data = проверяемый префикс.
     *
     * Returns: true если массив начинается с data.
     */
    bool startsWith(scope const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[19991])(_wh, cast(void*)data.ptr, cast(int)data.length) != 0;
    }

    /**
     * Проверяет, начинается ли массив с заданной строки-байт.
     *
     * Params:
     *   s = проверяемый префикс (байты).
     *
     * Returns: true если массив начинается с s.
     */
    bool startsWith(scope const(char)[] s) {
        return (cast(t_i__qp_qp_i)pFunQt[19991])(_wh, cast(void*)s.ptr, cast(int)s.length) != 0;
    }

    /**
     * Проверяет, заканчивается ли массив заданным суффиксом байт.
     *
     * Params:
     *   data = проверяемый суффикс.
     *
     * Returns: true если массив заканчивается на data.
     */
    bool endsWith(scope const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[19992])(_wh, cast(void*)data.ptr, cast(int)data.length) != 0;
    }

    /**
     * Проверяет, заканчивается ли массив заданной строкой-байт.
     *
     * Params:
     *   s = проверяемый суффикс (байты).
     *
     * Returns: true если массив заканчивается на s.
     */
    bool endsWith(scope const(char)[] s) {
        return (cast(t_i__qp_qp_i)pFunQt[19992])(_wh, cast(void*)s.ptr, cast(int)s.length) != 0;
    }

    // ── Кодирование ───────────────────────────────────────────────────────

    /**
     * Возвращает hex-кодированную копию массива.
     * Каждый байт представляется двумя символами нижнего регистра.
     *
     * Returns:
     *   Новый D-владеющий QByteArray с hex-текстом.
     *
     * Example:
     * ---
     * // [0xDE, 0xAD] → "dead"
     * auto hex = ba.toHex();
     * ---
     */
    QByteArray toHex()    { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19993])(_wh)); }

    /**
     * Возвращает Base64-кодированную копию массива (RFC 4648, с padding '=').
     *
     * Returns:
     *   Новый D-владеющий QByteArray с Base64-текстом.
     */
    QByteArray toBase64() { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19994])(_wh)); }

    /**
     * Декодирует Base64-текст из this и возвращает сырые байты.
     * Предполагается, что текущий массив содержит корректный Base64.
     *
     * Returns:
     *   Новый D-владеющий QByteArray с декодированными байтами.
     *
     * Note:
     *   Метод называется fromBase64(), так как он "из Base64" производит байты.
     *   Это соответствует Qt QByteArray::fromBase64(this).
     */
    QByteArray fromBase64() { return QByteArray.wrap((cast(t_qp__qp)pFunQt[19995])(_wh)); }

    /**
     * Удобный метод: Base64-кодирование с возвратом D string.
     *
     * Returns: строка с Base64-представлением.
     *
     * Example:
     * ---
     * string s = ba.toBase64String(); // например "3q2+7w=="
     * ---
     */
    string toBase64String() { return toBase64().toString(); }

    /**
     * Удобный метод: hex-кодирование с возвратом D string.
     *
     * Returns: строка с hex-представлением в нижнем регистре.
     *
     * Example:
     * ---
     * string s = ba.toHexString(); // например "deadbeef"
     * ---
     */
    string toHexString()    { return toHex().toString(); }

    // ── Взаимодействие с QString ──────────────────────────────────────────

    /**
     * Интерпретирует байты как UTF-8 и возвращает новый Qt QString*.
     * Вызывающая сторона обязана освободить возвращённый указатель
     * через qteDeleteQString (pFunQt[22]).
     *
     * Returns:
     *   void* — сырой указатель на новый Qt QString (heap).
     *
     * Note:
     *   Низкоуровневый метод. Для получения D string используйте toStringQt().
     */
    void* toQStringPtr() {
        return (cast(t_qp__qp)pFunQt[19996])(_wh);
    }

    /**
     * Конвертирует байты в D string через Qt UTF-8 декодирование.
     * Создаёт временный QString, декодирует, освобождает его.
     *
     * Returns:
     *   Строка D с корректно декодированными символами.
     *
     * Note:
     *   Используйте этот метод вместо toString() когда важна корректность UTF-8.
     *   toString() копирует байты as-is, без Qt-декодирования.
     */
    string toStringQt() {
        void* qs = toQStringPtr();
        string r = gen_qcore.fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);  // освобождаем временный QString (pFunQt[22] = qteDeleteQString)
        return r;
    }

    /**
     * Статический фабричный метод: создаёт QByteArray из D string
     * через Qt QString::toUtf8().
     *
     * Params:
     *   s = D string в UTF-8.
     *
     * Returns:
     *   Новый D-владеющий QByteArray с UTF-8 байтами.
     *
     * Note:
     *   Временный QString создаётся и немедленно освобождается.
     *   Для простого копирования байт без Qt используйте конструктор new QByteArray(s).
     */
    static QByteArray fromQString(string s) {
        void* qs = toQString(s);                                  // создаём временный Qt QString*
        void* ba = (cast(t_qp__qp)pFunQt[19997])(qs);            // QByteArray = qs.toUtf8()
        (cast(t_v__qp)pFunQt[22])(qs);                           // освобождаем временный QString
        return QByteArray.wrap(ba);
    }

    // ── Сравнение ─────────────────────────────────────────────────────────

    alias opEquals = Object.opEquals;  /// стандартное Object.opEquals (идентичность)
    alias opCmp    = Object.opCmp;     /// стандартное Object.opCmp

    /**
     * Побайтовое сравнение двух QByteArray.
     *
     * Params:
     *   other = объект для сравнения; не должен быть null.
     *
     * Returns:
     *   true если содержимое идентично (size и байты).
     *
     * Note:
     *   Использует Qt QByteArray::operator==.
     */
    bool opEquals(QByteArray other) {
        return (cast(t_i__qp_qp)pFunQt[19998])(_wh, other._wh) != 0;
    }

    // ── Управление владением ──────────────────────────────────────────────

    /**
     * Передаёт владение объектом Qt: деструктор D не будет вызывать delete.
     *
     * Note:
     *   Вызывайте после передачи объекта Qt-виджету, который берёт
     *   ответственность за удаление.
     */
    void  disown()  { _qt_owned = true; }

    /**
     * Возвращает флаг владения: true — Qt владеет объектом.
     *
     * Returns: значение _qt_owned.
     */
    bool  qtOwned() { return _qt_owned; }

    /**
     * Возвращает сырой указатель на нативный QByteArray*.
     * Используется при передаче объекта в C++ функции напрямую.
     *
     * Returns: void* (_wh).
     */
    void* getWH()   { return _wh; }
}

// ====================================================================
// Unittest
// ====================================================================

/**
 * Юнит-тесты модуля gen_qbytearray.
 *
 * Note:
 *   Все методы класса QByteArray требуют загруженной DLL qte56_foundation.dll
 *   и инициализированного Qt (LoadQt + QApplication).
 *   Полное функциональное тестирование — в test/test_qbytearray.d.
 *
 *   Данный блок проверяет только чистую логику D, не зависящую от DLL:
 *   корректность псевдонимов типов, факт регистрации символов модуля
 *   и статические свойства класса.
 */
unittest
{
    // -----------------------------------------------------------------
    // Проверяем, что псевдонимы сигнатур функций объявлены корректно.
    // Компилятор верифицирует совместимость типов на этапе компиляции.
    // Если mixin(generateAlias(...)) сработал — тест проходит автоматически.
    // -----------------------------------------------------------------

    // Псевдонимы объявлены через mixin(generateAlias(...)).
    // Проверяем, что они существуют как типы-указатели на функции.
    // extern(C) внутри is() не поддерживается — проверяем факт наличия.
    static assert(is(t_qp__qp_i),    "t_qp__qp_i не объявлен");
    static assert(is(t_qp__qp_i_i),  "t_qp__qp_i_i не объявлен");
    static assert(is(t_i__qp_qp_i_i),"t_i__qp_qp_i_i не объявлен");
    static assert(is(t_i__qp_i),      "t_i__qp_i не объявлен");

    // -----------------------------------------------------------------
    // Проверяем константы индексов pFunQt (документальная верификация).
    // Индексы 19969–19998 зарезервированы за QByteArray.
    // -----------------------------------------------------------------
    enum uint QBA_IDX_FIRST = 19969;
    enum uint QBA_IDX_LAST  = 19998;
    enum uint QBA_IDX_COUNT = QBA_IDX_LAST - QBA_IDX_FIRST + 1;

    static assert(QBA_IDX_COUNT == 30,
        "QByteArray должен занимать ровно 30 слотов в pFunQt (19969..19998)");
    static assert(QBA_IDX_FIRST >= 1 && QBA_IDX_LAST < 22000,
        "Индексы QByteArray должны быть в допустимом диапазоне PFUNQT_SIZE");

    // -----------------------------------------------------------------
    // Размер массива pFunQt определён в qte56_core (PFUNQT_SIZE == 22000).
    // Убеждаемся, что последний индекс не выходит за пределы.
    // -----------------------------------------------------------------
    static assert(QBA_IDX_LAST < pFunQt.length,
        "Последний индекс QByteArray выходит за pFunQt.length");

    // -----------------------------------------------------------------
    // Полное тестирование с реальными объектами — test/test_qbytearray.d:
    //   - конструкторы (пустой, из ubyte[], из string)
    //   - size/length/isEmpty
    //   - opIndex/opIndexAssign
    //   - append/prepend/~=, resize, clear, chop
    //   - mid/left/right/toUpper/toLower/trimmed
    //   - indexOf/contains/startsWith/endsWith
    //   - toHex/toBase64/fromBase64
    //   - toString/toStringQt/fromQString
    //   - opEquals/dup
    //   - disown/qtOwned/getWH
    // -----------------------------------------------------------------
}
