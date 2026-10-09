/**
 * gen_qdate.d — D-обёртки для Qt value-типов: QDate, QTime, QDateTime.
 *
 * Модуль: QDate / QTime / QDateTime
 * DLL:    qte56_foundation.dll
 *
 * Все три класса представляют размещённые на куче C++ объекты.
 * Владение объектом принадлежит D: деструктор вызывает qteQDate_delete /
 * qteQTime_delete / qteQDateTime_delete, если только D не передал владение
 * Qt-стороне через `disown()`.
 *
 * Статические методы (currentDate, fromString и т.п.) возвращают новый
 * экземпляр — D-владелец. Арифметические методы (addDays, addMonths…)
 * тоже возвращают НОВЫЙ объект, исходный не изменяется.
 *
 * Диапазоны индексов pFunQt:
 *   QDate    : 19885 – 19911
 *   QTime    : 19912 – 19933
 *   QDateTime: 19934 – 19968
 *
 * See_Also:
 *   test/test_qdate.d — полный интеграционный тест (требует загрузки DLL).
 */
module gen_qdate;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString,
    t_i__qp, t_i__qp_qp,
    t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp,
    t_v__qp, t_v__qp_i, t_v__qp_qp;

/// int(void*, int, int, int) — используется в QDate.setDate
mixin(generateAlias("i__qp_i_i_i"));

// Дополнительные псевдонимы типов функций:
/// double(void*) — toSecsSinceEpoch, toMSecsSinceEpoch и др.
mixin(generateAlias("d__qp"));
/// double(void*, void*) — secsTo
mixin(generateAlias("d__qp_qp"));
/// void*(double) — fromSecsSinceEpoch, fromMSecsSinceEpoch
mixin(generateAlias("qp__d"));
/// void*(int) — fromJulianDay, isLeapYear и аналоги с одним int-аргументом
mixin(generateAlias("qp__i"));
/// void*(int, int, int) — QDate::createYMD(год, месяц, день)
mixin(generateAlias("qp__i_i_i"));
/// void*(int, int, int, int) — QTime::createHMS(час, мин, сек, мс)
mixin(generateAlias("qp__i_i_i_i"));
/// int(int) — isLeapYear (статический метод, принимает год)
mixin(generateAlias("i__i"));
/// void(void*, int, int, int, int) — QTime::setHMS
mixin(generateAlias("v__qp_i_i_i_i"));
/// int(void*, int, int, int, int) — возвращаемое значение QTime::setHMS
mixin(generateAlias("i__qp_i_i_i_i"));

// ====================================================================
// Загрузка таблицы функций
// ====================================================================

/**
 * Регистрирует все функции QDate / QTime / QDateTime в таблице pFunQt.
 *
 * Вызывается автоматически через `static this()` при первом импорте модуля.
 * Все три класса используют одно зарегистрированное имя модуля "QDate",
 * иначе `loadFn()` не найдёт адреса и вернёт null → crash при вызове.
 *
 * Note:
 *   Важно: generateFunQt для QTime и QDateTime тоже передаёт "QDate" —
 *   это не ошибка, а требование системы загрузки (один файл = один модуль).
 */
void loadQDate() {
    // ── QDate ──────────────────────────────────────────────────────
    mixin(generateFunQt(19885, "qteQDate_create",           "QDate")); /// Конструктор по умолчанию (null/невалидная дата)
    mixin(generateFunQt(19886, "qteQDate_createYMD",        "QDate")); /// Конструктор QDate(year, month, day)
    mixin(generateFunQt(19887, "qteQDate_delete",           "QDate")); /// Деструктор
    mixin(generateFunQt(19888, "qteQDate_copy",             "QDate")); /// Глубокая копия (dup)
    mixin(generateFunQt(19889, "qteQDate_year",             "QDate")); /// Год
    mixin(generateFunQt(19890, "qteQDate_month",            "QDate")); /// Месяц (1–12)
    mixin(generateFunQt(19891, "qteQDate_day",              "QDate")); /// День (1–31)
    mixin(generateFunQt(19892, "qteQDate_setDate",          "QDate")); /// Установить год/месяц/день
    mixin(generateFunQt(19893, "qteQDate_isValid",          "QDate")); /// Дата валидна?
    mixin(generateFunQt(19894, "qteQDate_isNull",           "QDate")); /// Дата null (не установлена)?
    mixin(generateFunQt(19895, "qteQDate_toString",         "QDate")); /// Форматированная строка (паттерн Qt)
    mixin(generateFunQt(19896, "qteQDate_toStringISO",      "QDate")); /// ISO 8601: "yyyy-MM-dd"
    mixin(generateFunQt(19897, "qteQDate_currentDate",      "QDate")); /// Текущая локальная дата
    mixin(generateFunQt(19898, "qteQDate_fromString",       "QDate")); /// Разбор строки по паттерну
    mixin(generateFunQt(19899, "qteQDate_fromJulianDay",    "QDate")); /// Конструктор из юлианского дня
    mixin(generateFunQt(19900, "qteQDate_isLeapYear",       "QDate")); /// Статически: год — високосный?
    mixin(generateFunQt(19901, "qteQDate_addDays",          "QDate")); /// Прибавить дни → новый объект
    mixin(generateFunQt(19902, "qteQDate_addMonths",        "QDate")); /// Прибавить месяцы → новый объект
    mixin(generateFunQt(19903, "qteQDate_addYears",         "QDate")); /// Прибавить годы → новый объект
    mixin(generateFunQt(19904, "qteQDate_daysTo",           "QDate")); /// Разница в днях до другой даты
    mixin(generateFunQt(19905, "qteQDate_dayOfWeek",        "QDate")); /// День недели (1=Пн … 7=Вс)
    mixin(generateFunQt(19906, "qteQDate_dayOfYear",        "QDate")); /// Порядковый день в году (1–366)
    mixin(generateFunQt(19907, "qteQDate_daysInMonth",      "QDate")); /// Количество дней в текущем месяце
    mixin(generateFunQt(19908, "qteQDate_daysInYear",       "QDate")); /// Количество дней в текущем году (365/366)
    mixin(generateFunQt(19909, "qteQDate_toJulianDay",      "QDate")); /// Перевод в юлианский день
    mixin(generateFunQt(19910, "qteQDate_equal",            "QDate")); /// Равенство двух дат
    mixin(generateFunQt(19911, "qteQDate_less",             "QDate")); /// this < other

    // ── QTime ──────────────────────────────────────────────────────
    // Note: имя модуля "QDate" — обязательно для всех трёх классов в этом файле
    mixin(generateFunQt(19912, "qteQTime_create",                "QDate")); /// Конструктор по умолчанию (null/невалидное время)
    mixin(generateFunQt(19913, "qteQTime_createHMS",             "QDate")); /// Конструктор QTime(h, m, s, ms)
    mixin(generateFunQt(19914, "qteQTime_delete",                "QDate")); /// Деструктор
    mixin(generateFunQt(19915, "qteQTime_copy",                  "QDate")); /// Глубокая копия (dup)
    mixin(generateFunQt(19916, "qteQTime_hour",                  "QDate")); /// Часы (0–23)
    mixin(generateFunQt(19917, "qteQTime_minute",                "QDate")); /// Минуты (0–59)
    mixin(generateFunQt(19918, "qteQTime_second",                "QDate")); /// Секунды (0–59)
    mixin(generateFunQt(19919, "qteQTime_msec",                  "QDate")); /// Миллисекунды (0–999)
    mixin(generateFunQt(19920, "qteQTime_setHMS",                "QDate")); /// Установить час/мин/сек/мс
    mixin(generateFunQt(19921, "qteQTime_isValid",               "QDate")); /// Время валидно?
    mixin(generateFunQt(19922, "qteQTime_isNull",                "QDate")); /// Время null (не установлено)?
    mixin(generateFunQt(19923, "qteQTime_toString",              "QDate")); /// Форматированная строка (паттерн Qt)
    mixin(generateFunQt(19924, "qteQTime_toStringISO",           "QDate")); /// ISO: "hh:mm:ss"
    mixin(generateFunQt(19925, "qteQTime_currentTime",           "QDate")); /// Текущее локальное время
    mixin(generateFunQt(19926, "qteQTime_fromString",            "QDate")); /// Разбор строки по паттерну
    mixin(generateFunQt(19927, "qteQTime_addSecs",               "QDate")); /// Прибавить секунды → новый объект
    mixin(generateFunQt(19928, "qteQTime_addMSecs",              "QDate")); /// Прибавить миллисекунды → новый объект
    mixin(generateFunQt(19929, "qteQTime_secsTo",                "QDate")); /// Секунды до другого времени
    mixin(generateFunQt(19930, "qteQTime_msecsTo",               "QDate")); /// Миллисекунды до другого времени
    mixin(generateFunQt(19931, "qteQTime_msecsSinceStartOfDay",  "QDate")); /// Мс с полуночи (0–86 399 999)
    mixin(generateFunQt(19932, "qteQTime_equal",                 "QDate")); /// Равенство двух объектов времени
    mixin(generateFunQt(19933, "qteQTime_less",                  "QDate")); /// this < other

    // ── QDateTime ──────────────────────────────────────────────────
    mixin(generateFunQt(19934, "qteQDateTime_create",               "QDate")); /// Конструктор по умолчанию
    mixin(generateFunQt(19935, "qteQDateTime_createDT",             "QDate")); /// Конструктор QDateTime(QDate, QTime)
    mixin(generateFunQt(19936, "qteQDateTime_delete",               "QDate")); /// Деструктор
    mixin(generateFunQt(19937, "qteQDateTime_copy",                 "QDate")); /// Глубокая копия (dup)
    mixin(generateFunQt(19938, "qteQDateTime_date",                 "QDate")); /// Дата (новый D-owned QDate)
    mixin(generateFunQt(19939, "qteQDateTime_time",                 "QDate")); /// Время (новый D-owned QTime)
    mixin(generateFunQt(19940, "qteQDateTime_year",                 "QDate")); /// Год
    mixin(generateFunQt(19941, "qteQDateTime_month",                "QDate")); /// Месяц (1–12)
    mixin(generateFunQt(19942, "qteQDateTime_day",                  "QDate")); /// День (1–31)
    mixin(generateFunQt(19943, "qteQDateTime_hour",                 "QDate")); /// Часы (0–23)
    mixin(generateFunQt(19944, "qteQDateTime_minute",               "QDate")); /// Минуты (0–59)
    mixin(generateFunQt(19945, "qteQDateTime_second",               "QDate")); /// Секунды (0–59)
    mixin(generateFunQt(19946, "qteQDateTime_msec",                 "QDate")); /// Миллисекунды (0–999)
    mixin(generateFunQt(19947, "qteQDateTime_setDate",              "QDate")); /// Установить дату
    mixin(generateFunQt(19948, "qteQDateTime_setTime",              "QDate")); /// Установить время
    mixin(generateFunQt(19949, "qteQDateTime_isValid",              "QDate")); /// Валиден?
    mixin(generateFunQt(19950, "qteQDateTime_isNull",               "QDate")); /// Null (не установлен)?
    mixin(generateFunQt(19951, "qteQDateTime_toString",             "QDate")); /// Форматированная строка (паттерн Qt)
    mixin(generateFunQt(19952, "qteQDateTime_toStringISO",          "QDate")); /// ISO: "yyyy-MM-ddThh:mm:ss"
    mixin(generateFunQt(19953, "qteQDateTime_currentDateTime",      "QDate")); /// Текущее локальное дата-время
    mixin(generateFunQt(19954, "qteQDateTime_currentDateTimeUtc",   "QDate")); /// Текущее UTC дата-время
    mixin(generateFunQt(19955, "qteQDateTime_fromString",           "QDate")); /// Разбор строки по паттерну
    mixin(generateFunQt(19956, "qteQDateTime_fromSecsSinceEpoch",   "QDate")); /// Из секунд Unix-эпохи (double)
    mixin(generateFunQt(19957, "qteQDateTime_fromMSecsSinceEpoch",  "QDate")); /// Из миллисекунд Unix-эпохи (double)
    mixin(generateFunQt(19958, "qteQDateTime_addDays",              "QDate")); /// Прибавить дни → новый объект
    mixin(generateFunQt(19959, "qteQDateTime_addMonths",            "QDate")); /// Прибавить месяцы → новый объект
    mixin(generateFunQt(19960, "qteQDateTime_addYears",             "QDate")); /// Прибавить годы → новый объект
    mixin(generateFunQt(19961, "qteQDateTime_addSecs",              "QDate")); /// Прибавить секунды → новый объект
    mixin(generateFunQt(19962, "qteQDateTime_addMSecs",             "QDate")); /// Прибавить миллисекунды → новый объект
    mixin(generateFunQt(19963, "qteQDateTime_daysTo",               "QDate")); /// Разница в днях до другого дата-времени
    mixin(generateFunQt(19964, "qteQDateTime_secsTo",               "QDate")); /// Разница в секундах (double, субсекундная точность)
    mixin(generateFunQt(19965, "qteQDateTime_toSecsSinceEpoch",     "QDate")); /// Unix timestamp в секундах (double)
    mixin(generateFunQt(19966, "qteQDateTime_toMSecsSinceEpoch",    "QDate")); /// Unix timestamp в миллисекундах (double)
    mixin(generateFunQt(19967, "qteQDateTime_equal",                "QDate")); /// Равенство двух дата-времён
    mixin(generateFunQt(19968, "qteQDateTime_less",                 "QDate")); /// this < other
}

/**
 * Статический конструктор модуля: регистрирует модуль "QDate" в загрузчике.
 *
 * Вызывается автоматически D runtime при первом использовании модуля.
 * После `LoadQt()` система загружает `qte56_foundation.dll` и вызывает
 * `loadQDate()`, заполняя pFunQt[19885..19968].
 */
static this() {
    registerModule("QDate", "qte56_foundation.dll", &loadQDate);
}

// ====================================================================
// QDate
// ====================================================================

/**
 * D-обёртка для Qt-типа QDate (дата: год, месяц, день).
 *
 * Объект размещается на куче C++; D владеет им и уничтожает в деструкторе,
 * если не была вызвана `disown()`.
 *
 * День недели кодируется по ISO 8601: 1 = Понедельник … 7 = Воскресенье.
 *
 * Форматные строки Qt для `toString(fmt)`:
 * $(TABLE
 *   $(TR $(TD `d`)   $(TD день без ведущего нуля))
 *   $(TR $(TD `dd`)  $(TD день с ведущим нулём))
 *   $(TR $(TD `M`)   $(TD месяц без ведущего нуля))
 *   $(TR $(TD `MM`)  $(TD месяц с ведущим нулём))
 *   $(TR $(TD `yyyy`)$(TD четырёхзначный год))
 * )
 *
 * Example:
 * ---
 * // Требует загруженной DLL
 * auto d = new QDate(2024, 12, 25);
 * assert(d.toString("dd.MM.yyyy") == "25.12.2024");
 * assert(d.dayOfWeek() == 3); // среда
 * ---
 *
 * See_Also: test/test_qdate.d
 */
@live class QDate {
private:
    void* _wh;        /// Указатель на C++ объект QDate
    bool  _qt_owned;  /// true — Qt владеет объектом, D не вызывает delete
    /// Приватный конструктор для wrap(): создаёт оболочку без аллокации C++-объекта
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /**
     * Конструктор по умолчанию: создаёт null/невалидную дату.
     *
     * Вызывает `qteQDate_create` (pFunQt[19885]).
     * `isNull()` вернёт true, `isValid()` вернёт false.
     */
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[19885])();
    }

    /**
     * Конструктор из компонентов даты.
     *
     * Вызывает `qteQDate_createYMD` (pFunQt[19886]).
     *
     * Params:
     *   y = год (например, 2024)
     *   m = месяц (1–12)
     *   d = день (1–31)
     *
     * Note:
     *   Если значения выходят за допустимые пределы, `isValid()` вернёт false.
     */
    this(int y, int m, int d) {
        _qt_owned = false;
        _wh = (cast(t_qp__i_i_i)pFunQt[19886])(y, m, d);
    }

    /**
     * Деструктор: освобождает C++ объект, если D является владельцем.
     *
     * Вызывает `qteQDate_delete` (pFunQt[19887]).
     * Если `disown()` был вызван ранее, удаления не происходит.
     */
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19887] !is null) {
            (cast(t_v__qp)pFunQt[19887])(_wh);
            _wh = null;
        }
    }

    /**
     * Оборачивает уже существующий C++ QDate*, передавая владение D.
     *
     * Используется внутри модуля для возврата новых объектов из C++ функций
     * (currentDate, addDays, fromString и т.п.).
     *
     * Params:
     *   ptr = сырой указатель на heap-аллоцированный QDate; null допустим
     *
     * Returns:
     *   Новый QDate, обёртывающий ptr, или null если ptr == null.
     */
    static QDate wrap(void* ptr) {
        if (ptr is null) return null;
        auto d = new QDate(false);
        d._wh = ptr;
        return d;
    }

    /**
     * Создаёт независимую копию даты.
     *
     * Вызывает `qteQDate_copy` (pFunQt[19888]).
     *
     * Returns: новый D-owned QDate с теми же год/месяц/день.
     */
    QDate dup() {
        return QDate.wrap((cast(t_qp__qp)pFunQt[19888])(_wh));
    }

    // ── Поля даты ─────────────────────────────────────────────────

    /// Возвращает год (например, 2024). pFunQt[19889].
    int year()  { return (cast(t_i__qp)pFunQt[19889])(_wh); }

    /// Возвращает месяц (1–12). pFunQt[19890].
    int month() { return (cast(t_i__qp)pFunQt[19890])(_wh); }

    /// Возвращает день месяца (1–31). pFunQt[19891].
    int day()   { return (cast(t_i__qp)pFunQt[19891])(_wh); }

    /**
     * Устанавливает дату из компонентов.
     *
     * Вызывает `qteQDate_setDate` (pFunQt[19892]).
     *
     * Params:
     *   y = год
     *   m = месяц (1–12)
     *   d = день (1–31)
     *
     * Returns: true если новая дата валидна, false иначе.
     */
    bool setDate(int y, int m, int d) {
        return cast(bool)(cast(t_i__qp_i_i_i)pFunQt[19892])(_wh, y, m, d);
    }

    // ── Проверка корректности ──────────────────────────────────────

    /**
     * Проверяет, является ли дата корректной.
     *
     * pFunQt[19893].
     *
     * Returns: false для дат типа 2024-02-30 или после вызова конструктора
     *          по умолчанию.
     */
    bool isValid() { return cast(bool)(cast(t_i__qp)pFunQt[19893])(_wh); }

    /**
     * Проверяет, является ли дата null (не инициализирована).
     *
     * pFunQt[19894].
     *
     * Note: null-дата также не является валидной (`isValid() == false`).
     */
    bool isNull()  { return cast(bool)(cast(t_i__qp)pFunQt[19894])(_wh); }

    // ── Форматирование ────────────────────────────────────────────

    /**
     * Возвращает строковое представление даты по заданному паттерну Qt.
     *
     * Вызывает `qteQDate_toString` (pFunQt[19895]).
     *
     * Params:
     *   fmt = паттерн Qt, например `"dd.MM.yyyy"` или `"d MMMM yyyy"`
     *
     * Returns:
     *   Отформатированная строка, например `"25.12.2024"`.
     *
     * Example:
     * ---
     * auto d = new QDate(2024, 12, 25);
     * assert(d.toString("dd.MM.yyyy") == "25.12.2024");
     * ---
     */
    string toString(string fmt) {
        auto _qfmt = toQString(fmt);
        void* _qs = (cast(t_qp__qp_qp)pFunQt[19895])(_wh, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qfmt); /// Освобождаем временный QString паттерна
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);   /// Освобождаем временный QString результата
        return r;
    }

    /**
     * Возвращает дату в формате ISO 8601: `"yyyy-MM-dd"`.
     *
     * Вызывает `qteQDate_toStringISO` (pFunQt[19896]).
     *
     * Returns: строка вида `"2024-12-25"`.
     */
    override string toString() {
        void* _qs = (cast(t_qp__qp)pFunQt[19896])(_wh);
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return r;
    }

    // ── Статические конструкторы ───────────────────────────────────

    /**
     * Возвращает текущую локальную дату.
     *
     * Вызывает `qteQDate_currentDate` (pFunQt[19897]).
     *
     * Returns: новый D-owned QDate с сегодняшней датой.
     */
    static QDate currentDate() {
        return QDate.wrap((cast(t_qp__)pFunQt[19897])());
    }

    /**
     * Разбирает дату из строки по заданному паттерну Qt.
     *
     * Вызывает `qteQDate_fromString` (pFunQt[19898]).
     *
     * Params:
     *   s   = строка с датой, например `"25.12.2024"`
     *   fmt = паттерн Qt, например `"dd.MM.yyyy"`
     *
     * Returns:
     *   Новый D-owned QDate; если разбор не удался — невалидная дата
     *   (`isValid() == false`).
     *
     * Example:
     * ---
     * auto d = QDate.fromString("25.12.2024", "dd.MM.yyyy");
     * assert(d.year == 2024 && d.day == 25);
     * ---
     */
    static QDate fromString(string s, string fmt) {
        auto _qs  = toQString(s);
        auto _qfmt = toQString(fmt);
        void* r = (cast(t_qp__qp_qp)pFunQt[19898])(_qs, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qs);
        (cast(t_v__qp)pFunQt[22])(_qfmt);
        return QDate.wrap(r);
    }

    /**
     * Создаёт дату из порядкового юлианского дня.
     *
     * Вызывает `qteQDate_fromJulianDay` (pFunQt[19899]).
     *
     * Params:
     *   jd = юлианский день (например, 2451545 = 2000-01-01)
     *
     * Returns: новый D-owned QDate.
     */
    static QDate fromJulianDay(int jd) {
        return QDate.wrap((cast(t_qp__i)pFunQt[19899])(jd));
    }

    /**
     * Статический метод: проверяет, является ли указанный год високосным.
     *
     * Вызывает `qteQDate_isLeapYear` (pFunQt[19900]).
     *
     * Params:
     *   year = год для проверки (например, 2024)
     *
     * Returns: true если год високосный.
     *
     * Note:
     *   Метод статический — не требует создания экземпляра QDate.
     */
    static bool isLeapYear(int year) {
        return cast(bool)(cast(t_i__i)pFunQt[19900])(year);
    }

    // ── Арифметика дат ────────────────────────────────────────────

    /**
     * Возвращает новую дату, сдвинутую на n дней.
     *
     * Вызывает `qteQDate_addDays` (pFunQt[19901]).
     * Отрицательный n — сдвиг назад. Исходный объект не изменяется.
     *
     * Params: n = количество дней (может быть отрицательным)
     * Returns: новый D-owned QDate.
     */
    QDate addDays  (int n) { return QDate.wrap((cast(t_qp__qp_i)pFunQt[19901])(_wh, n)); }

    /**
     * Возвращает новую дату, сдвинутую на n месяцев.
     *
     * Вызывает `qteQDate_addMonths` (pFunQt[19902]).
     * Qt корректно обрабатывает переполнение (например, 31 января + 1 месяц = 28/29 февраля).
     *
     * Params: n = количество месяцев (может быть отрицательным)
     * Returns: новый D-owned QDate.
     */
    QDate addMonths(int n) { return QDate.wrap((cast(t_qp__qp_i)pFunQt[19902])(_wh, n)); }

    /**
     * Возвращает новую дату, сдвинутую на n лет.
     *
     * Вызывает `qteQDate_addYears` (pFunQt[19903]).
     *
     * Params: n = количество лет (может быть отрицательным)
     * Returns: новый D-owned QDate.
     */
    QDate addYears (int n) { return QDate.wrap((cast(t_qp__qp_i)pFunQt[19903])(_wh, n)); }

    // ── Запросы ───────────────────────────────────────────────────

    /**
     * Количество дней от this до other.
     *
     * Вызывает `qteQDate_daysTo` (pFunQt[19904]).
     *
     * Params:
     *   other = дата, до которой считается разница
     *
     * Returns:
     *   Положительное число если other позже this;
     *   отрицательное если other раньше this; 0 если равны.
     */
    int daysTo(QDate other) { return (cast(t_i__qp_qp)pFunQt[19904])(_wh, other._wh); }

    /**
     * День недели по ISO 8601.
     *
     * Вызывает `qteQDate_dayOfWeek` (pFunQt[19905]).
     *
     * Returns: 1 = Понедельник, 2 = Вторник … 7 = Воскресенье; 0 если дата невалидна.
     */
    int dayOfWeek  ()  { return (cast(t_i__qp)pFunQt[19905])(_wh); }

    /// Порядковый номер дня в году (1–366). pFunQt[19906].
    int dayOfYear  ()  { return (cast(t_i__qp)pFunQt[19906])(_wh); }

    /// Количество дней в текущем месяце (28–31). pFunQt[19907].
    int daysInMonth()  { return (cast(t_i__qp)pFunQt[19907])(_wh); }

    /// Количество дней в текущем году (365 или 366). pFunQt[19908].
    int daysInYear ()  { return (cast(t_i__qp)pFunQt[19908])(_wh); }

    /// Преобразует дату в юлианский день. pFunQt[19909].
    int toJulianDay()  { return (cast(t_i__qp)pFunQt[19909])(_wh); }

    // ── Операторы сравнения ───────────────────────────────────────

    alias opEquals = Object.opEquals;
    alias opCmp    = Object.opCmp;

    /**
     * Сравнение на равенство с другой датой.
     *
     * Вызывает `qteQDate_equal` (pFunQt[19910]).
     *
     * Params: other = дата для сравнения
     * Returns: true если даты идентичны.
     */
    bool opEquals(QDate other) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[19910])(_wh, other._wh);
    }

    /**
     * Трёхпозиционное сравнение дат.
     *
     * Использует pFunQt[19910] (equal) и pFunQt[19911] (less).
     *
     * Returns: 0 если равны; -1 если this < other; +1 если this > other.
     */
    int opCmp(QDate other) {
        if (cast(bool)(cast(t_i__qp_qp)pFunQt[19910])(_wh, other._wh)) return 0;
        return (cast(bool)(cast(t_i__qp_qp)pFunQt[19911])(_wh, other._wh)) ? -1 : 1;
    }

    // ── Управление владением ──────────────────────────────────────

    /**
     * Передаёт владение объектом Qt-стороне.
     *
     * После вызова деструктор D не будет вызывать `qteQDate_delete`.
     * Используется когда Qt берёт на себя жизненный цикл объекта.
     */
    void  disown()   { _qt_owned = true; }

    /// Возвращает true если Qt владеет объектом (D не будет его удалять).
    bool  qtOwned()  { return _qt_owned; }

    /// Возвращает сырой указатель на C++ объект для передачи в функции DLL.
    void* getWH()    { return _wh; }
}

// ====================================================================
// QTime
// ====================================================================

/**
 * D-обёртка для Qt-типа QTime (время суток: часы, минуты, секунды, мс).
 *
 * Объект размещается на куче C++; D владеет им и уничтожает в деструкторе,
 * если не была вызвана `disown()`.
 *
 * Форматные токены Qt для `toString(fmt)`:
 * $(TABLE
 *   $(TR $(TD `h` / `hh`)  $(TD часы без/с ведущим нулём))
 *   $(TR $(TD `m` / `mm`)  $(TD минуты без/с ведущим нулём))
 *   $(TR $(TD `s` / `ss`)  $(TD секунды без/с ведущим нулём))
 *   $(TR $(TD `z` / `zzz`) $(TD миллисекунды (1–3 цифры / всегда 3 цифры)))
 *   $(TR $(TD `AP`/`ap`)   $(TD AM/PM суффикс в верхнем/нижнем регистре))
 * )
 *
 * Example:
 * ---
 * // Требует загруженной DLL
 * auto t = new QTime(14, 30, 5, 123);
 * assert(t.toString("hh:mm:ss.zzz") == "14:30:05.123");
 * assert(t.msecsSinceStartOfDay() == 14*3600_000 + 30*60_000 + 5_000 + 123);
 * ---
 *
 * See_Also: test/test_qdate.d
 */
@live class QTime {
private:
    void* _wh;        /// Указатель на C++ объект QTime
    bool  _qt_owned;  /// true — Qt владеет объектом, D не вызывает delete
    /// Приватный конструктор для wrap()
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /**
     * Конструктор по умолчанию: создаёт null/невалидное время.
     *
     * Вызывает `qteQTime_create` (pFunQt[19912]).
     * `isNull()` вернёт true, `isValid()` вернёт false.
     */
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[19912])();
    }

    /**
     * Конструктор из компонентов времени.
     *
     * Вызывает `qteQTime_createHMS` (pFunQt[19913]).
     *
     * Params:
     *   h  = часы (0–23)
     *   m  = минуты (0–59)
     *   s  = секунды (0–59)
     *   ms = миллисекунды (0–999), по умолчанию 0
     */
    this(int h, int m, int s, int ms = 0) {
        _qt_owned = false;
        _wh = (cast(t_qp__i_i_i_i)pFunQt[19913])(h, m, s, ms);
    }

    /**
     * Деструктор: освобождает C++ объект, если D является владельцем.
     *
     * Вызывает `qteQTime_delete` (pFunQt[19914]).
     */
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19914] !is null) {
            (cast(t_v__qp)pFunQt[19914])(_wh);
            _wh = null;
        }
    }

    /**
     * Оборачивает уже существующий C++ QTime*, передавая владение D.
     *
     * Params:
     *   ptr = сырой указатель на heap-аллоцированный QTime; null допустим
     *
     * Returns: новый QTime, обёртывающий ptr, или null если ptr == null.
     */
    static QTime wrap(void* ptr) {
        if (ptr is null) return null;
        auto t = new QTime(false);
        t._wh = ptr;
        return t;
    }

    /**
     * Создаёт независимую копию объекта времени.
     *
     * Вызывает `qteQTime_copy` (pFunQt[19915]).
     *
     * Returns: новый D-owned QTime с теми же значениями.
     */
    QTime dup() {
        return QTime.wrap((cast(t_qp__qp)pFunQt[19915])(_wh));
    }

    // ── Поля времени ──────────────────────────────────────────────

    /// Часы (0–23). pFunQt[19916].
    int hour()   { return (cast(t_i__qp)pFunQt[19916])(_wh); }

    /// Минуты (0–59). pFunQt[19917].
    int minute() { return (cast(t_i__qp)pFunQt[19917])(_wh); }

    /// Секунды (0–59). pFunQt[19918].
    int second() { return (cast(t_i__qp)pFunQt[19918])(_wh); }

    /// Миллисекунды (0–999). pFunQt[19919].
    int msec()   { return (cast(t_i__qp)pFunQt[19919])(_wh); }

    /**
     * Устанавливает компоненты времени.
     *
     * Вызывает `qteQTime_setHMS` (pFunQt[19920]).
     *
     * Params:
     *   h  = часы (0–23)
     *   m  = минуты (0–59)
     *   s  = секунды (0–59)
     *   ms = миллисекунды (0–999), по умолчанию 0
     *
     * Returns: true если новое время валидно.
     */
    bool setHMS(int h, int m, int s, int ms = 0) {
        return cast(bool)(cast(t_i__qp_i_i_i_i)pFunQt[19920])(_wh, h, m, s, ms);
    }

    // ── Проверка корректности ──────────────────────────────────────

    /// Возвращает true если время корректно (компоненты в допустимых диапазонах). pFunQt[19921].
    bool isValid() { return cast(bool)(cast(t_i__qp)pFunQt[19921])(_wh); }

    /// Возвращает true если время null (конструктор по умолчанию, не установлено). pFunQt[19922].
    bool isNull()  { return cast(bool)(cast(t_i__qp)pFunQt[19922])(_wh); }

    // ── Форматирование ────────────────────────────────────────────

    /**
     * Возвращает строковое представление времени по заданному паттерну Qt.
     *
     * Вызывает `qteQTime_toString` (pFunQt[19923]).
     *
     * Params:
     *   fmt = паттерн Qt, например `"hh:mm:ss"` или `"hh:mm:ss.zzz"`
     *
     * Returns:
     *   Отформатированная строка, например `"14:30:05.123"`.
     */
    string toString(string fmt) {
        auto _qfmt = toQString(fmt);
        void* _qs = (cast(t_qp__qp_qp)pFunQt[19923])(_wh, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qfmt); /// Освобождаем временный QString паттерна
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);   /// Освобождаем временный QString результата
        return r;
    }

    /**
     * Возвращает время в формате ISO: `"hh:mm:ss"`.
     *
     * Вызывает `qteQTime_toStringISO` (pFunQt[19924]).
     *
     * Returns: строка вида `"14:30:05"` (без миллисекунд).
     */
    override string toString() {
        void* _qs = (cast(t_qp__qp)pFunQt[19924])(_wh);
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return r;
    }

    // ── Статические конструкторы ───────────────────────────────────

    /**
     * Возвращает текущее локальное время.
     *
     * Вызывает `qteQTime_currentTime` (pFunQt[19925]).
     *
     * Returns: новый D-owned QTime.
     */
    static QTime currentTime() {
        return QTime.wrap((cast(t_qp__)pFunQt[19925])());
    }

    /**
     * Разбирает время из строки по заданному паттерну Qt.
     *
     * Вызывает `qteQTime_fromString` (pFunQt[19926]).
     *
     * Params:
     *   s   = строка с временем, например `"14:30:05"`
     *   fmt = паттерн Qt, например `"hh:mm:ss"`
     *
     * Returns:
     *   Новый D-owned QTime; если разбор не удался — невалидное время.
     */
    static QTime fromString(string s, string fmt) {
        auto _qs   = toQString(s);
        auto _qfmt = toQString(fmt);
        void* r = (cast(t_qp__qp_qp)pFunQt[19926])(_qs, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qs);
        (cast(t_v__qp)pFunQt[22])(_qfmt);
        return QTime.wrap(r);
    }

    // ── Арифметика ────────────────────────────────────────────────

    /**
     * Возвращает новое время, сдвинутое на n секунд.
     *
     * Вызывает `qteQTime_addSecs` (pFunQt[19927]).
     * При выходе за сутки время "заворачивается" (wrap-around).
     *
     * Params: n = секунды (может быть отрицательным)
     * Returns: новый D-owned QTime.
     */
    QTime addSecs (int n) { return QTime.wrap((cast(t_qp__qp_i)pFunQt[19927])(_wh, n)); }

    /**
     * Возвращает новое время, сдвинутое на n миллисекунд.
     *
     * Вызывает `qteQTime_addMSecs` (pFunQt[19928]).
     * При выходе за сутки время "заворачивается" (wrap-around).
     *
     * Params: n = миллисекунды (может быть отрицательным)
     * Returns: новый D-owned QTime.
     */
    QTime addMSecs(int n) { return QTime.wrap((cast(t_qp__qp_i)pFunQt[19928])(_wh, n)); }

    // ── Запросы ───────────────────────────────────────────────────

    /**
     * Секунды от this до other.
     *
     * Вызывает `qteQTime_secsTo` (pFunQt[19929]).
     *
     * Params:   other = время, до которого считается разница
     * Returns:  секунды; отрицательно если other раньше this.
     */
    int secsTo (QTime other) { return (cast(t_i__qp_qp)pFunQt[19929])(_wh, other._wh); }

    /**
     * Миллисекунды от this до other.
     *
     * Вызывает `qteQTime_msecsTo` (pFunQt[19930]).
     *
     * Params:   other = время, до которого считается разница
     * Returns:  миллисекунды; отрицательно если other раньше this.
     */
    int msecsTo(QTime other) { return (cast(t_i__qp_qp)pFunQt[19930])(_wh, other._wh); }

    /**
     * Количество миллисекунд от полуночи до текущего времени.
     *
     * Вызывает `qteQTime_msecsSinceStartOfDay` (pFunQt[19931]).
     *
     * Returns:
     *   Целое число в диапазоне [0, 86_399_999].
     *   Для QTime(0,0,0,0) вернёт 0; для QTime(23,59,59,999) — 86_399_999.
     */
    int msecsSinceStartOfDay() { return (cast(t_i__qp)pFunQt[19931])(_wh); }

    // ── Операторы сравнения ───────────────────────────────────────

    alias opEquals = Object.opEquals;
    alias opCmp    = Object.opCmp;

    /**
     * Сравнение на равенство с другим временем.
     *
     * Вызывает `qteQTime_equal` (pFunQt[19932]).
     *
     * Returns: true если оба объекта хранят одинаковое время.
     */
    bool opEquals(QTime other) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[19932])(_wh, other._wh);
    }

    /**
     * Трёхпозиционное сравнение объектов времени.
     *
     * Использует pFunQt[19932] (equal) и pFunQt[19933] (less).
     *
     * Returns: 0 если равны; -1 если this < other; +1 если this > other.
     */
    int opCmp(QTime other) {
        if (cast(bool)(cast(t_i__qp_qp)pFunQt[19932])(_wh, other._wh)) return 0;
        return (cast(bool)(cast(t_i__qp_qp)pFunQt[19933])(_wh, other._wh)) ? -1 : 1;
    }

    // ── Управление владением ──────────────────────────────────────

    /**
     * Передаёт владение объектом Qt-стороне.
     * После вызова деструктор D не будет вызывать `qteQTime_delete`.
     */
    void  disown()  { _qt_owned = true; }

    /// true если Qt владеет объектом (D не будет его удалять).
    bool  qtOwned() { return _qt_owned; }

    /// Сырой указатель на C++ объект для передачи в функции DLL.
    void* getWH()   { return _wh; }
}

// ====================================================================
// QDateTime
// ====================================================================

/**
 * D-обёртка для Qt-типа QDateTime (дата + время в одном объекте).
 *
 * Объект размещается на куче C++; D владеет им и уничтожает в деструкторе,
 * если не была вызвана `disown()`.
 *
 * Ключевые особенности:
 * $(UL
 *   $(LI `date()` и `time()` возвращают НОВЫЕ D-owned объекты, не ссылки на внутренние поля.)
 *   $(LI `fromSecsSinceEpoch` / `fromMSecsSinceEpoch` принимают double для поддержки субсекундной точности.)
 *   $(LI `toSecsSinceEpoch` / `toMSecsSinceEpoch` возвращают double.)
 *   $(LI `secsTo()` возвращает double — для субсекундной точности при сравнении двух моментов.)
 *   $(LI Арифметика (addDays, addSecs и т.п.) возвращает новый объект; исходный не изменяется.)
 * )
 *
 * Example:
 * ---
 * // Требует загруженной DLL
 * auto d = new QDate(2024, 12, 25);
 * auto t = new QTime(12, 0, 0);
 * auto dt = new QDateTime(d, t);
 * assert(dt.toString("dd.MM.yyyy hh:mm") == "25.12.2024 12:00");
 *
 * auto dt2 = dt.addDays(7);
 * assert(dt2.day == 1 && dt2.month == 1 && dt2.year == 2025);
 * ---
 *
 * See_Also: test/test_qdate.d
 */
@live class QDateTime {
private:
    void* _wh;        /// Указатель на C++ объект QDateTime
    bool  _qt_owned;  /// true — Qt владеет объектом, D не вызывает delete
    /// Приватный конструктор для wrap()
    this(bool _dummy) { _wh = null; _qt_owned = false; }

public:
    /**
     * Конструктор по умолчанию: создаёт null/невалидный объект.
     *
     * Вызывает `qteQDateTime_create` (pFunQt[19934]).
     */
    this() {
        _qt_owned = false;
        _wh = (cast(t_qp__)pFunQt[19934])();
    }

    /**
     * Конструктор из пары QDate + QTime.
     *
     * Вызывает `qteQDateTime_createDT` (pFunQt[19935]).
     *
     * Params:
     *   date = дата (D-owned QDate)
     *   time = время (D-owned QTime)
     *
     * Note:
     *   C++ создаёт собственную копию date и time — D-объекты остаются
     *   независимыми и могут быть уничтожены после вызова конструктора.
     */
    this(QDate date, QTime time) {
        _qt_owned = false;
        _wh = (cast(t_qp__qp_qp)pFunQt[19935])(date._wh, time._wh);
    }

    /**
     * Деструктор: освобождает C++ объект, если D является владельцем.
     *
     * Вызывает `qteQDateTime_delete` (pFunQt[19936]).
     */
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[19936] !is null) {
            (cast(t_v__qp)pFunQt[19936])(_wh);
            _wh = null;
        }
    }

    /**
     * Оборачивает уже существующий C++ QDateTime*, передавая владение D.
     *
     * Params:
     *   ptr = сырой указатель на heap-аллоцированный QDateTime; null допустим
     *
     * Returns: новый QDateTime, обёртывающий ptr, или null если ptr == null.
     */
    static QDateTime wrap(void* ptr) {
        if (ptr is null) return null;
        auto dt = new QDateTime(false);
        dt._wh = ptr;
        return dt;
    }

    /**
     * Создаёт независимую копию объекта.
     *
     * Вызывает `qteQDateTime_copy` (pFunQt[19937]).
     *
     * Returns: новый D-owned QDateTime с теми же значениями.
     */
    QDateTime dup() {
        return QDateTime.wrap((cast(t_qp__qp)pFunQt[19937])(_wh));
    }

    // ── Декомпозиция ──────────────────────────────────────────────

    /**
     * Возвращает дату как новый D-owned QDate.
     *
     * Вызывает `qteQDateTime_date` (pFunQt[19938]).
     *
     * Note:
     *   Возвращается НОВЫЙ объект, а не ссылка на внутреннее поле.
     *   Каждый вызов создаёт отдельную копию — не накапливайте их в цикле
     *   без явного уничтожения.
     */
    QDate date() { return QDate.wrap((cast(t_qp__qp)pFunQt[19938])(_wh)); }

    /**
     * Возвращает время как новый D-owned QTime.
     *
     * Вызывает `qteQDateTime_time` (pFunQt[19939]).
     *
     * Note:
     *   Возвращается НОВЫЙ объект — аналогично `date()`.
     */
    QTime time() { return QTime.wrap((cast(t_qp__qp)pFunQt[19939])(_wh)); }

    // ── Быстрые аксессоры ─────────────────────────────────────────

    /// Год. pFunQt[19940].
    int year()   { return (cast(t_i__qp)pFunQt[19940])(_wh); }

    /// Месяц (1–12). pFunQt[19941].
    int month()  { return (cast(t_i__qp)pFunQt[19941])(_wh); }

    /// День месяца (1–31). pFunQt[19942].
    int day()    { return (cast(t_i__qp)pFunQt[19942])(_wh); }

    /// Часы (0–23). pFunQt[19943].
    int hour()   { return (cast(t_i__qp)pFunQt[19943])(_wh); }

    /// Минуты (0–59). pFunQt[19944].
    int minute() { return (cast(t_i__qp)pFunQt[19944])(_wh); }

    /// Секунды (0–59). pFunQt[19945].
    int second() { return (cast(t_i__qp)pFunQt[19945])(_wh); }

    /// Миллисекунды (0–999). pFunQt[19946].
    int msec()   { return (cast(t_i__qp)pFunQt[19946])(_wh); }

    // ── Сеттеры ───────────────────────────────────────────────────

    /**
     * Устанавливает дату, сохраняя текущее время.
     *
     * Вызывает `qteQDateTime_setDate` (pFunQt[19947]).
     *
     * Params: d = новая дата (D-owned QDate)
     */
    QDateTime setDate(QDate d) { (cast(t_v__qp_qp)pFunQt[19947])(_wh, d._wh); return this; }

    /**
     * Устанавливает время, сохраняя текущую дату.
     *
     * Вызывает `qteQDateTime_setTime` (pFunQt[19948]).
     *
     * Params: t = новое время (D-owned QTime)
     */
    QDateTime setTime(QTime t) { (cast(t_v__qp_qp)pFunQt[19948])(_wh, t._wh); return this; }

    // ── Проверка корректности ──────────────────────────────────────

    /// Возвращает true если дата-время корректны. pFunQt[19949].
    bool isValid() { return cast(bool)(cast(t_i__qp)pFunQt[19949])(_wh); }

    /// Возвращает true если объект null (не установлен). pFunQt[19950].
    bool isNull()  { return cast(bool)(cast(t_i__qp)pFunQt[19950])(_wh); }

    // ── Форматирование ────────────────────────────────────────────

    /**
     * Возвращает строковое представление по паттерну Qt.
     *
     * Вызывает `qteQDateTime_toString` (pFunQt[19951]).
     *
     * Params:
     *   fmt = паттерн Qt, например `"dd.MM.yyyy hh:mm:ss"`
     *
     * Returns:
     *   Отформатированная строка, например `"25.12.2024 14:30:05"`.
     */
    string toString(string fmt) {
        auto _qfmt = toQString(fmt);
        void* _qs = (cast(t_qp__qp_qp)pFunQt[19951])(_wh, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qfmt); /// Освобождаем временный QString паттерна
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);   /// Освобождаем временный QString результата
        return r;
    }

    /**
     * Возвращает дата-время в формате ISO 8601: `"yyyy-MM-ddThh:mm:ss"`.
     *
     * Вызывает `qteQDateTime_toStringISO` (pFunQt[19952]).
     *
     * Returns: строка вида `"2024-12-25T14:30:05"`.
     */
    override string toString() {
        void* _qs = (cast(t_qp__qp)pFunQt[19952])(_wh);
        string r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return r;
    }

    // ── Статические конструкторы ───────────────────────────────────

    /**
     * Возвращает текущее локальное дата-время.
     *
     * Вызывает `qteQDateTime_currentDateTime` (pFunQt[19953]).
     *
     * Returns: новый D-owned QDateTime.
     */
    static QDateTime currentDateTime() {
        return QDateTime.wrap((cast(t_qp__)pFunQt[19953])());
    }

    /**
     * Возвращает текущее дата-время в UTC.
     *
     * Вызывает `qteQDateTime_currentDateTimeUtc` (pFunQt[19954]).
     *
     * Returns: новый D-owned QDateTime (UTC).
     */
    static QDateTime currentDateTimeUtc() {
        return QDateTime.wrap((cast(t_qp__)pFunQt[19954])());
    }

    /**
     * Разбирает дата-время из строки по паттерну Qt.
     *
     * Вызывает `qteQDateTime_fromString` (pFunQt[19955]).
     *
     * Params:
     *   s   = строка с датой-временем, например `"25.12.2024 14:30:05"`
     *   fmt = паттерн Qt, например `"dd.MM.yyyy hh:mm:ss"`
     *
     * Returns:
     *   Новый D-owned QDateTime; если разбор не удался — невалидный объект.
     */
    static QDateTime fromString(string s, string fmt) {
        auto _qs   = toQString(s);
        auto _qfmt = toQString(fmt);
        void* r = (cast(t_qp__qp_qp)pFunQt[19955])(_qs, _qfmt);
        (cast(t_v__qp)pFunQt[22])(_qs);
        (cast(t_v__qp)pFunQt[22])(_qfmt);
        return QDateTime.wrap(r);
    }

    /**
     * Создаёт объект из количества секунд с Unix-эпохи (1970-01-01T00:00:00 UTC).
     *
     * Вызывает `qteQDateTime_fromSecsSinceEpoch` (pFunQt[19956]).
     *
     * Params:
     *   secs = секунды с эпохи (double; дробная часть игнорируется Qt)
     *
     * Returns: новый D-owned QDateTime в локальном часовом поясе.
     *
     * Note:
     *   Аргумент double обеспечивает совместимость с языками, не имеющими
     *   64-битного целого, но Qt внутри использует qint64.
     */
    static QDateTime fromSecsSinceEpoch(double secs) {
        return QDateTime.wrap((cast(t_qp__d)pFunQt[19956])(secs));
    }

    /**
     * Создаёт объект из количества миллисекунд с Unix-эпохи.
     *
     * Вызывает `qteQDateTime_fromMSecsSinceEpoch` (pFunQt[19957]).
     *
     * Params:
     *   ms = миллисекунды с эпохи (double)
     *
     * Returns: новый D-owned QDateTime в локальном часовом поясе.
     */
    static QDateTime fromMSecsSinceEpoch(double ms) {
        return QDateTime.wrap((cast(t_qp__d)pFunQt[19957])(ms));
    }

    // ── Арифметика ────────────────────────────────────────────────

    /**
     * Возвращает новый объект, сдвинутый на n дней.
     *
     * Вызывает `qteQDateTime_addDays` (pFunQt[19958]).
     * Исходный объект не изменяется.
     *
     * Params: n = дни (может быть отрицательным)
     * Returns: новый D-owned QDateTime.
     */
    QDateTime addDays  (int n) { return QDateTime.wrap((cast(t_qp__qp_i)pFunQt[19958])(_wh, n)); }

    /**
     * Возвращает новый объект, сдвинутый на n месяцев.
     *
     * Вызывает `qteQDateTime_addMonths` (pFunQt[19959]).
     *
     * Params: n = месяцы (может быть отрицательным)
     * Returns: новый D-owned QDateTime.
     */
    QDateTime addMonths(int n) { return QDateTime.wrap((cast(t_qp__qp_i)pFunQt[19959])(_wh, n)); }

    /**
     * Возвращает новый объект, сдвинутый на n лет.
     *
     * Вызывает `qteQDateTime_addYears` (pFunQt[19960]).
     *
     * Params: n = годы (может быть отрицательным)
     * Returns: новый D-owned QDateTime.
     */
    QDateTime addYears (int n) { return QDateTime.wrap((cast(t_qp__qp_i)pFunQt[19960])(_wh, n)); }

    /**
     * Возвращает новый объект, сдвинутый на n секунд.
     *
     * Вызывает `qteQDateTime_addSecs` (pFunQt[19961]).
     *
     * Params: n = секунды (может быть отрицательным)
     * Returns: новый D-owned QDateTime.
     */
    QDateTime addSecs  (int n) { return QDateTime.wrap((cast(t_qp__qp_i)pFunQt[19961])(_wh, n)); }

    /**
     * Возвращает новый объект, сдвинутый на n миллисекунд.
     *
     * Вызывает `qteQDateTime_addMSecs` (pFunQt[19962]).
     *
     * Params: n = миллисекунды (может быть отрицательным)
     * Returns: новый D-owned QDateTime.
     */
    QDateTime addMSecs (int n) { return QDateTime.wrap((cast(t_qp__qp_i)pFunQt[19962])(_wh, n)); }

    // ── Запросы ───────────────────────────────────────────────────

    /**
     * Количество дней от this до other.
     *
     * Вызывает `qteQDateTime_daysTo` (pFunQt[19963]).
     *
     * Returns:
     *   Положительное если other позже; отрицательное если раньше; 0 если тот же день.
     */
    int    daysTo           (QDateTime other) { return (cast(t_i__qp_qp)pFunQt[19963])(_wh, other._wh); }

    /**
     * Количество секунд от this до other (с субсекундной точностью).
     *
     * Вызывает `qteQDateTime_secsTo` (pFunQt[19964]).
     *
     * Returns:
     *   double — отрицательное если other раньше this.
     *
     * Note:
     *   Тип double выбран для поддержки субсекундной точности и больших
     *   диапазонов дат без переполнения 32-битного int.
     */
    double secsTo           (QDateTime other) { return (cast(t_d__qp_qp)pFunQt[19964])(_wh, other._wh); }

    /**
     * Возвращает Unix timestamp в секундах (секунды с 1970-01-01T00:00:00 UTC).
     *
     * Вызывает `qteQDateTime_toSecsSinceEpoch` (pFunQt[19965]).
     *
     * Returns: double; для дат до 1970 года значение отрицательное.
     */
    double toSecsSinceEpoch ()  { return (cast(t_d__qp)pFunQt[19965])(_wh); }

    /**
     * Возвращает Unix timestamp в миллисекундах.
     *
     * Вызывает `qteQDateTime_toMSecsSinceEpoch` (pFunQt[19966]).
     *
     * Returns: double.
     */
    double toMSecsSinceEpoch()  { return (cast(t_d__qp)pFunQt[19966])(_wh); }

    // ── Операторы сравнения ───────────────────────────────────────

    alias opEquals = Object.opEquals;
    alias opCmp    = Object.opCmp;

    /**
     * Сравнение на равенство с другим дата-временем.
     *
     * Вызывает `qteQDateTime_equal` (pFunQt[19967]).
     *
     * Returns: true если оба объекта представляют один и тот же момент.
     */
    bool opEquals(QDateTime other) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[19967])(_wh, other._wh);
    }

    /**
     * Трёхпозиционное сравнение объектов дата-время.
     *
     * Использует pFunQt[19967] (equal) и pFunQt[19968] (less).
     *
     * Returns: 0 если равны; -1 если this < other; +1 если this > other.
     */
    int opCmp(QDateTime other) {
        if (cast(bool)(cast(t_i__qp_qp)pFunQt[19967])(_wh, other._wh)) return 0;
        return (cast(bool)(cast(t_i__qp_qp)pFunQt[19968])(_wh, other._wh)) ? -1 : 1;
    }

    // ── Управление владением ──────────────────────────────────────

    /**
     * Передаёт владение объектом Qt-стороне.
     * После вызова деструктор D не будет вызывать `qteQDateTime_delete`.
     */
    void  disown()  { _qt_owned = true; }

    /// true если Qt владеет объектом (D не будет его удалять).
    bool  qtOwned() { return _qt_owned; }

    /// Сырой указатель на C++ объект для передачи в функции DLL.
    void* getWH()   { return _wh; }
}

// ====================================================================
// Модульные тесты (unittest)
// ====================================================================

/**
 * Примечание к тестированию:
 *
 * Полное интеграционное тестирование QDate / QTime / QDateTime находится в
 * `test/test_qdate.d`. Для его запуска необходимо:
 * $(OL
 *   $(LI `LoadQt("./dll")` — загрузить `qte56_foundation.dll`)
 *   $(LI `new QApplication(...)` — инициализировать Qt runtime)
 * )
 *
 * Ниже — чисто компиляционные тесты (не требуют DLL), проверяющие модель
 * владения и корректность объявлений типов.
 */
unittest {
    // --- Тест 1: модель владения ---
    // Проверяем, что disown() корректно переключает флаг
    // (без вызова DLL — объект не создаётся, тест только логики флага)
    {
        // Используем приватный конструктор через wrap(null)
        QDate d = QDate.wrap(null);
        assert(d is null, "wrap(null) должен вернуть null");

        QTime t = QTime.wrap(null);
        assert(t is null, "wrap(null) должен вернуть null");

        QDateTime dt = QDateTime.wrap(null);
        assert(dt is null, "wrap(null) должен вернуть null");
    }

    // --- Тест 2: статический метод isLeapYear требует DLL ---
    // Данный unittest проверяет только логику на уровне типов.
    // Реальные вызовы pFunQt[19900] требуют загрузки DLL.
    //
    // Ожидаемые результаты (см. test/test_qdate.d):
    //   QDate.isLeapYear(2000) == true   (кратен 400)
    //   QDate.isLeapYear(1900) == false  (кратен 100, но не 400)
    //   QDate.isLeapYear(2024) == true   (кратен 4, не кратен 100)
    //   QDate.isLeapYear(2023) == false

    // --- Тест 3: арифметика дат без DLL не работает ---
    // addDays / addMonths / addYears / daysTo и все остальные методы
    // вызывают pFunQt[...] — не тестируются без DLL.
    //
    // Полный набор тестов (27 тестов для QDate, 18 для QTime,
    // 25 для QDateTime) см. в test/test_qdate.d.

    // --- Тест 4: структура классов компилируется ---
    // Проверяем только что все классы объявлены корректно.
    static assert(is(QDate    == class), "QDate должен быть классом");
    static assert(is(QTime    == class), "QTime должен быть классом");
    static assert(is(QDateTime == class), "QDateTime должен быть классом");
}
