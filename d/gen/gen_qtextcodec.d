/**
 * gen_qtextcodec.d — D-обёртка для QTextCodec
 *                    (перекодировка байт ↔ строка для legacy-кодировок).
 *
 * DLL: qte56_textcodec.dll  |  Блок индексов: 20157–20162 (6 функций)
 *
 * $(H3 Назначение)
 *
 * Решает классическую проблему: Qt по умолчанию декодирует байты, пришедшие
 * из ODBC/QSql/файлов/QProcess/сети, как UTF-8. Если данные на самом деле
 * в cp1251 (Windows ANSI Cyrillic), cp866 (DOS Cyrillic), KOI8-R и т.п. —
 * Qt молча превращает их в "кракозябры" или знаки вопроса, и информация
 * теряется ещё до того, как D-сторона их получит.
 *
 * Решение: получить $(B сырые байты) (через QByteArray, BLOB-каст в SQL,
 * `readAll()` файла и т.п.) и явно декодировать их через `QTextCodec`.
 *
 * $(H3 Минимальный пример: чтение поля cp1251 из ODBC)
 *
 * ---
 * import gen_qtextcodec, gen_qsql;
 *
 * auto q = new QSqlQuery();
 * q.exec("SELECT CAST(name AS BINARY) FROM clients");  // получаем сырые байты
 * while (q.next()) {
 *     ubyte[] raw = q.valueBytes(0);                   // QByteArray → ubyte[]
 *     string  name = QTextCodec.fromCp1251(raw);       // правильная D-строка
 *     writeln(name);
 * }
 * ---
 *
 * $(H3 Минимальный пример: вывод консольной утилиты в cp866)
 *
 * ---
 * import gen_qtextcodec, gen_qprocess;
 *
 * auto p = new QProcess();
 * p.start("dir.exe", null);
 * p.waitForFinished();
 * ubyte[] raw  = p.readAllStdout();                    // сырые байты cmd.exe
 * string  text = QTextCodec.fromCp866(raw);            // читаемый русский
 * writeln(text);
 * ---
 *
 * $(H3 Поддерживаемые русские кодировки)
 *
 * Гарантированы в Qt 5 core (без ICU):
 * $(UL
 *   $(LI `"Windows-1251"` — cp1251, ANSI Cyrillic, 1С/MS Office/SQL Server)
 *   $(LI `"IBM866"`       — cp866, DOS Cyrillic, FoxPro/dBase/cmd.exe)
 *   $(LI `"KOI8-R"`       — Russian Internet/email до 2000-х)
 *   $(LI `"KOI8-U"`       — украинский вариант KOI8)
 *   $(LI `"ISO 8859-5"`   — стандартизованный, редко на практике)
 *   $(LI `"Macintosh"`    — MacRoman; MacCyrillic при ICU-сборке Qt)
 * )
 *
 * Полный список — `QTextCodec.availableCodecs()`.
 *
 * $(H3 Удобные алиасы)
 *
 * Чтобы не печатать имя кодировки каждый раз — статические методы:
 * `fromCp1251 / fromCp866 / fromKoi8r / fromKoi8u / fromIso5` и зеркальные
 * `toCp1251 / toCp866 / toKoi8r / toKoi8u / toIso5`.
 *
 * $(H3 Qt 6 миграция)
 *
 * `QTextCodec` удалён из Qt 6 → заменён на `QStringConverter` в QtCore
 * (поддерживает только UTF/Latin-1) или `Qt5Compat::QTextCodec` (compat-модуль).
 * При миграции gen_qtextcodec можно либо переписать на QStringConverter
 * + встроенные таблицы для cp1251/cp866 (~5 КБ данных), либо линковать
 * `Qt5Compat`.
 *
 * See_Also: AI_TEXTCODEC.md, AI_SQL.md (раздел legacy-БД)
 */
module gen_qtextcodec;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : toQString, fromQString,
                   t_qp__, t_v__qp, t_v__qp_i;

// ── Дополнительные псевдонимы типов функций ──────────────────────────────────

/// int function(void* name, int len) — для qteQTextCodec_codecAvailable (20157).
/// Локальный псевдоним: в gen_qcore аналог называется t_b__qp_i (b и i дают int).
mixin(generateAlias("i__qp_i"));

/// void* function(void* codecName, int codecLen, void* data, int dataLen)
/// Используется для qteQTextCodec_decodeBytes (20158).
mixin(generateAlias("qp__qp_i_qp_i"));

/// void* function(void* codecName, int codecLen, void* qstring)
/// Используется для qteQTextCodec_encodeText (20159).
mixin(generateAlias("qp__qp_i_qp"));

// ── Загрузка функций ─────────────────────────────────────────────────────────

/**
 * Загружает все 6 функций QTextCodec из qte56_textcodec.dll.
 * Вызывается автоматически через registerModule() при первом импорте.
 */
void loadQTextCodec() {
    mixin(generateFunQt(20157, "qteQTextCodec_codecAvailable",     "QTextCodec"));
    mixin(generateFunQt(20158, "qteQTextCodec_decodeBytes",        "QTextCodec"));
    mixin(generateFunQt(20159, "qteQTextCodec_encodeText",         "QTextCodec"));
    mixin(generateFunQt(20160, "qteQTextCodec_availableCodecs",    "QTextCodec"));
    mixin(generateFunQt(20161, "qteQTextCodec_setCodecForLocale",  "QTextCodec"));
    mixin(generateFunQt(20162, "qteQTextCodec_codecForLocaleName", "QTextCodec"));
}

/// Авто-регистрация модуля в системе загрузки.
static this() {
    registerModule("QTextCodec", "qte56_textcodec.dll", &loadQTextCodec);
}

// ═════════════════════════════════════════════════════════════════════════════
// Класс QTextCodec — все методы статические (объект не создаётся)
// ═════════════════════════════════════════════════════════════════════════════

/**
 * QTextCodec — перекодировка байт ↔ string через Qt.
 *
 * Все методы статические; объект не создаётся. Использование:
 * ---
 * auto names = QTextCodec.availableCodecs();
 * string s   = QTextCodec.fromCp1251(rawBytes);
 * auto data  = QTextCodec.toKoi8r("Привет");
 * ---
 *
 * $(H4 Имена кодеков)
 *
 * Имя — это ASCII-строка, как её знает Qt: `"Windows-1251"`, `"IBM866"`,
 * `"KOI8-R"`. Регистр некритичен для поиска. Псевдонимы: `"CP1251"` ≡
 * `"Windows-1251"`, `"CP866"` ≡ `"IBM866"`. Полный список — через
 * `availableCodecs()`.
 *
 * $(H4 Поведение при ошибках)
 *
 * $(UL
 *   $(LI Если кодек не зарегистрирован — `decode/encode` возвращают пустой
 *        результат, без exception. Проверяй заранее через `codecAvailable()`.)
 *   $(LI Символы D-строки, не представимые в целевой кодировке, заменяются
 *        на `?` (поведение Qt).)
 *   $(LI Невалидные байты при декодировании заменяются на U+FFFD.)
 * )
 */
@live class QTextCodec {
    // Объект не создаётся — конструктор приватный.
    private this() {}

    // ── Базовые методы ───────────────────────────────────────────────────────

    /**
     * Проверяет, зарегистрирован ли в Qt кодек с указанным именем.
     *
     * Params:
     *   codecName = имя кодека ("Windows-1251", "IBM866", "KOI8-R", ...).
     *
     * Returns: `true` если кодек найден, иначе `false`.
     *
     * Example:
     * ---
     * if (!QTextCodec.codecAvailable("Windows-1251")) {
     *     writeln("Qt собран без поддержки cp1251?!");
     * }
     * ---
     */
    static bool codecAvailable(string codecName) {
        if (codecName.length == 0) return false;
        return (cast(t_i__qp_i)pFunQt[20157])(
            cast(void*)codecName.ptr, cast(int)codecName.length) != 0;
    }

    /**
     * Декодирует массив байт в D-строку через указанный кодек.
     *
     * Params:
     *   codecName = имя кодека ("Windows-1251", "IBM866", ...).
     *   bytes     = сырые байты (например, из QByteArray.toSlice() или
     *               QFile.readAll()).
     *
     * Returns: декодированная UTF-8 D-строка. Пустая строка если кодек
     *          не найден или массив байт пуст.
     *
     * Example:
     * ---
     * ubyte[] raw  = [0xCF, 0xF0, 0xE8, 0xE2, 0xE5, 0xF2];   // "Привет" в cp1251
     * string  text = QTextCodec.decode("Windows-1251", raw);
     * assert(text == "Привет");
     * ---
     */
    static string decode(string codecName, scope const(ubyte)[] bytes) {
        if (codecName.length == 0) return "";
        void* qs = (cast(t_qp__qp_i_qp_i)pFunQt[20158])(
            cast(void*)codecName.ptr, cast(int)codecName.length,
            cast(void*)bytes.ptr,     cast(int)bytes.length);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    /**
     * Перегрузка decode для случая, когда байты приходят как D-string
     * (например, результат `cast(string)readAllStdout()` или
     *  `q.valueString()`, в котором байты были интерпретированы Qt как
     *  Latin-1 / UTF-8 с потерями).
     *
     * Внимание: D-string по соглашению UTF-8. Здесь её содержимое трактуется
     * как сырые байты целевой кодировки. Использовать только если знаешь,
     * что строка реально хранит cp1251/cp866/...
     */
    static string decode(string codecName, scope const(char)[] bytes) {
        return decode(codecName, cast(const(ubyte)[])bytes);
    }

    /**
     * Кодирует D-строку в байты целевой кодировки.
     *
     * Params:
     *   codecName = имя целевого кодека.
     *   text      = исходная UTF-8 D-строка.
     *
     * Returns: массив байт в указанной кодировке. Пустой массив если кодек
     *          не найден. Символы, не представимые в целевой кодировке,
     *          заменяются на `?`.
     *
     * Example:
     * ---
     * auto bytes = QTextCodec.encode("Windows-1251", "Привет");
     * // → [0xCF, 0xF0, 0xE8, 0xE2, 0xE5, 0xF2]
     * ---
     */
    static ubyte[] encode(string codecName, string text) {
        if (codecName.length == 0) return null;
        void* qs = toQString(text);
        scope(exit) (cast(t_v__qp)pFunQt[22])(qs);

        void* baPtr = (cast(t_qp__qp_i_qp)pFunQt[20159])(
            cast(void*)codecName.ptr, cast(int)codecName.length, qs);
        if (baPtr is null) return null;

        // QByteArray* лежит в C++ heap. Используем gen_qbytearray для чтения
        // и автоматического delete. Импорт локальный чтобы избежать циклов.
        import gen_qbytearray : QByteArray;
        auto ba = QByteArray.wrap(baPtr);
        return ba.toSlice();   // dup в GC, ba.~this() освободит C++ объект
    }

    /**
     * Список всех имён доступных кодеков (как их знает Qt).
     *
     * Returns: массив имён ("Windows-1251", "IBM866", ...), пригодных для
     *          передачи в `decode/encode/setCodecForLocale`.
     *
     * Note: список зависит от того, как собран Qt. Без ICU кодировок ~30,
     *       с ICU — ~250.
     */
    static string[] availableCodecs() {
        void* qs = (cast(t_qp__)pFunQt[20160])();
        if (qs is null) return null;
        string joined = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        if (joined.length == 0) return null;
        import std.string : split;
        return joined.split('\x01');
    }

    /**
     * Устанавливает кодек по умолчанию для системной локали Qt.
     *
     * Влияет на: `QString::fromLocal8Bit`, `QString::toLocal8Bit`,
     * интерпретацию `argv` и переменных окружения, ряд legacy-API.
     * Глобальная настройка — менять обычно один раз при старте.
     *
     * Params:
     *   codecName = имя кодека. Если не зарегистрирован — вызов игнорируется.
     *
     * Example:
     * ---
     * void main() {
     *     LoadQt("./dll");
     *     QTextCodec.setCodecForLocale("Windows-1251");  // теперь locale = cp1251
     *     // ...
     * }
     * ---
     */
    static void setCodecForLocale(string codecName) {
        if (codecName.length == 0) return;
        (cast(t_v__qp_i)pFunQt[20161])(
            cast(void*)codecName.ptr, cast(int)codecName.length);
    }

    /**
     * Возвращает имя кодека, установленного для локали.
     *
     * Returns: имя кодека (например, "System" / "UTF-8" / "Windows-1251").
     *
     * Note: используется в основном для диагностики.
     */
    static string codecForLocaleName() {
        void* qs = (cast(t_qp__)pFunQt[20162])();
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }

    // ── Удобные алиасы для русских кодировок ─────────────────────────────────
    //
    // Гарантированно работают в стандартной сборке Qt 5 (без ICU):
    //   Windows-1251, IBM866, KOI8-R, KOI8-U, ISO 8859-5
    //
    // Использование:
    //   string  name = QTextCodec.fromCp1251(rawBytes);
    //   ubyte[] data = QTextCodec.toKoi8r("Привет");

    /// cp1251 (ANSI Cyrillic, Windows) → UTF-8 D-string.
    static string fromCp1251(scope const(ubyte)[] bytes) {
        return decode("Windows-1251", bytes);
    }
    /// ditto
    static string fromCp1251(scope const(char)[] bytes) {
        return decode("Windows-1251", bytes);
    }

    /// cp866 (OEM/DOS Cyrillic) → UTF-8 D-string.
    /// Типичные источники: cmd.exe, FoxPro/dBase, .DBF файлы.
    static string fromCp866(scope const(ubyte)[] bytes) {
        return decode("IBM866", bytes);
    }
    /// ditto
    static string fromCp866(scope const(char)[] bytes) {
        return decode("IBM866", bytes);
    }

    /// KOI8-R (Russian Internet/email до начала 2000-х) → UTF-8 D-string.
    static string fromKoi8r(scope const(ubyte)[] bytes) {
        return decode("KOI8-R", bytes);
    }
    /// ditto
    static string fromKoi8r(scope const(char)[] bytes) {
        return decode("KOI8-R", bytes);
    }

    /// KOI8-U (украинский вариант) → UTF-8 D-string.
    static string fromKoi8u(scope const(ubyte)[] bytes) {
        return decode("KOI8-U", bytes);
    }
    /// ditto
    static string fromKoi8u(scope const(char)[] bytes) {
        return decode("KOI8-U", bytes);
    }

    /// ISO 8859-5 (стандарт ISO для кириллицы) → UTF-8 D-string.
    static string fromIso5(scope const(ubyte)[] bytes) {
        return decode("ISO 8859-5", bytes);
    }
    /// ditto
    static string fromIso5(scope const(char)[] bytes) {
        return decode("ISO 8859-5", bytes);
    }

    // ── Обратные направления (UTF-8 → байты в кодировке) ────────────────────

    /// UTF-8 D-string → байты cp1251 (Windows ANSI Cyrillic).
    static ubyte[] toCp1251(string text) { return encode("Windows-1251", text); }

    /// UTF-8 D-string → байты cp866 (OEM/DOS Cyrillic).
    static ubyte[] toCp866 (string text) { return encode("IBM866",       text); }

    /// UTF-8 D-string → байты KOI8-R.
    static ubyte[] toKoi8r (string text) { return encode("KOI8-R",       text); }

    /// UTF-8 D-string → байты KOI8-U.
    static ubyte[] toKoi8u (string text) { return encode("KOI8-U",       text); }

    /// UTF-8 D-string → байты ISO 8859-5.
    static ubyte[] toIso5  (string text) { return encode("ISO 8859-5",   text); }
}

// ═════════════════════════════════════════════════════════════════════════════
// Юнит-тесты (только статическая верификация — без обращения к pFunQt)
// ═════════════════════════════════════════════════════════════════════════════

/**
 * Юнит-тесты модуля.
 *
 * Note: реальная проверка кодирования/декодирования — в test/test_qtextcodec.d
 *       (требует загруженной qte56_textcodec.dll и инициализированного Qt).
 *
 * Здесь — только статическая проверка целостности типов и индексов.
 */
unittest
{
    // Псевдонимы типов должны быть объявлены mixin'ами выше.
    static assert(is(t_qp__qp_i_qp_i), "t_qp__qp_i_qp_i не объявлен");
    static assert(is(t_qp__qp_i_qp),   "t_qp__qp_i_qp не объявлен");

    // Индексы блока 20157–20162 (6 функций).
    enum uint TC_FIRST = 20157;
    enum uint TC_LAST  = 20162;
    enum uint TC_COUNT = TC_LAST - TC_FIRST + 1;

    static assert(TC_COUNT == 6,
        "QTextCodec должен занимать 6 слотов в pFunQt (20157..20162)");
    static assert(TC_LAST < pFunQt.length,
        "Последний индекс QTextCodec выходит за pFunQt.length");
}
