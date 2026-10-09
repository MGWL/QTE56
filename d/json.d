/**
 * json.d — библиотека JSON на чистом D (без Qt, без DLL).
 *
 * Типы:
 *   $(D JsonType)   — перечисление: Null, Bool, Number, String, Array, Object
 *   $(D JsonObject) = JsonValue[string]  (ассоциативный массив D, неупорядоченный)
 *   $(D JsonArray)  = JsonValue[]        (динамический массив D, упорядоченный)
 *   $(D JsonValue)  — tagged-union структура, хранящая любое JSON-значение
 *
 * Разбор:
 *   $(D parseJson)(string)                   → JsonValue  (бросает JsonParseException)
 *   $(D tryParseJson)(string, out JsonValue) → bool        (без исключений)
 *
 * Сериализация:
 *   $(D toJsonCompact)(v)          → string  (без пробелов)
 *   $(D toJsonPretty)(v, spaces=2) → string  (с отступами)
 *   $(D JsonValue.toString)()      → компактная строка (то же что toJsonCompact)
 *
 * Создание значений:
 *   $(D JsonValue)(null/bool/int/long/double/string/JsonArray/JsonObject)
 *   $(D jarray)(v1, v2, ...)        → JsonValue-массив (автоконвертация D-типов)
 *   $(D jobject)("k1",v1,"k2",v2)  → JsonValue-объект (чередующиеся ключ/значение)
 *
 * Чтение:
 *   jv.boolean / .number / .integer / .str / .array / .object
 *   jv.get!T(default)          — безопасный доступ с запасным значением
 *   jv.get!T("key", default)   — поле объекта с запасным значением
 *   jv["key"] / jv[index]      — доступ по ключу или индексу (чтение и запись)
 *   "key" in jv                → JsonValue* (null если ключ отсутствует)
 *   foreach (ref val; jv)      — итерация массива
 *   jv ~= JsonValue(x)         — добавить элемент в массив
 *   jv.length                  — количество элементов (массив/объект/строка)
 *
 * Тесты: $(D test/test_json.d) — 85 проверок; встроенные unittest в этом файле.
 */
module json;

import std.array  : appender, Appender;
import std.conv   : to;
import std.format : format;


// ══════════════════════════════════════════════════════════════════════════════
// Псевдонимы публичных типов
// ══════════════════════════════════════════════════════════════════════════════

/// JSON-объект: отображение ключ→значение (ассоциативный массив D, неупорядоченный).
alias JsonObject = JsonValue[string];

/// JSON-массив: упорядоченный список значений (динамический массив D).
alias JsonArray  = JsonValue[];


// ══════════════════════════════════════════════════════════════════════════════
// JsonType — перечисление типов JSON
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Тег типа JSON-значения.
 *
 * Используется в $(D JsonValue.type) чтобы определить реальный тип
 * хранимых данных до обращения к ним через свойства доступа.
 *
 * Example:
 * ---
 * auto v = parseJson("42");
 * assert(v.type == JsonType.Number);
 * ---
 */
enum JsonType : ubyte {
    Null   = 0,  /// JSON null
    Bool   = 1,  /// JSON true / false
    Number = 2,  /// JSON-число (хранится как double)
    String = 3,  /// JSON-строка (UTF-8)
    Array  = 4,  /// JSON-массив  → JsonArray
    Object = 5   /// JSON-объект  → JsonObject
}


// ══════════════════════════════════════════════════════════════════════════════
// JsonValue — универсальное JSON-значение
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Универсальное JSON-значение: tagged union, способный хранить любой
 * из 6 типов JSON (null, bool, number, string, array, object).
 *
 * Внутренние поля приватные; доступ через предикаты $(D isNull)/$(D isBool)/...
 * и свойства $(D boolean)/$(D number)/$(D str)/$(D array)/$(D object).
 *
 * Типичный цикл работы:
 * ---
 * auto v = parseJson(`{"name":"Alice","scores":[10,20,30]}`);
 * string name   = v.get!string("name", "");
 * int    first  = v["scores"][0].integer;
 * ---
 */
struct JsonValue {
private:
    JsonType   _t   = JsonType.Null;   // тег текущего типа
    bool       _b;                     // значение для Bool
    double     _n;                     // значение для Number
    string     _s;                     // значение для String
    JsonArray  _arr;                   // значение для Array
    JsonObject _obj;                   // значение для Object

public:

    // ── Конструкторы ──────────────────────────────────────────────────────

    /**
     * Конструкторы для каждого поддерживаемого типа JSON.
     *
     * Целые числа ($(D int)/$(D long)/$(D uint)/$(D ulong)) и вещественные
     * ($(D float)/$(D double)) хранятся единообразно как double (тип Number).
     */
    this(typeof(null))  { _t = JsonType.Null; }
    this(bool v)        { _t = JsonType.Bool;   _b = v; }
    this(double v)      { _t = JsonType.Number; _n = v; }
    this(float v)       { _t = JsonType.Number; _n = cast(double)v; }
    this(long v)        { _t = JsonType.Number; _n = cast(double)v; }
    this(ulong v)       { _t = JsonType.Number; _n = cast(double)v; }
    this(int v)         { _t = JsonType.Number; _n = cast(double)v; }
    this(uint v)        { _t = JsonType.Number; _n = cast(double)v; }
    this(string v)      { _t = JsonType.String; _s = v; }
    this(JsonArray v)   { _t = JsonType.Array;  _arr = v; }
    this(JsonObject v)  { _t = JsonType.Object; _obj = v; }

    /**
     * Явное создание null-значения без неоднозначности в шаблонах.
     *
     * Returns: JsonValue с типом $(D JsonType.Null).
     */
    static JsonValue null_() { return JsonValue(null); }


    // ── Предикаты типа ────────────────────────────────────────────────────

    /// Текущий тип значения ($(D JsonType.Null) по умолчанию).
    @property JsonType type()   const pure nothrow { return _t; }
    /// $(D true) если значение равно JSON null.
    @property bool isNull()     const pure nothrow { return _t == JsonType.Null;   }
    /// $(D true) если значение является булевым (true или false).
    @property bool isBool()     const pure nothrow { return _t == JsonType.Bool;   }
    /// $(D true) если значение является числом.
    @property bool isNumber()   const pure nothrow { return _t == JsonType.Number; }
    /// $(D true) если значение является строкой.
    @property bool isString()   const pure nothrow { return _t == JsonType.String; }
    /// $(D true) если значение является массивом.
    @property bool isArray()    const pure nothrow { return _t == JsonType.Array;  }
    /// $(D true) если значение является объектом (ключ→значение).
    @property bool isObject()   const pure nothrow { return _t == JsonType.Object; }


    // ── Прямой доступ к значению (с assert при несовпадении типа) ─────────

    /// Булево значение. Бросает assert если тип не $(D Bool).
    @property bool   boolean()  const { assert(_t==JsonType.Bool,   "not a bool");   return _b; }
    /// Числовое значение как $(D double). Бросает assert если тип не $(D Number).
    @property double number()   const { assert(_t==JsonType.Number, "not a number"); return _n; }
    /// Числовое значение как $(D long) (усечение к целому). Бросает assert если тип не $(D Number).
    @property long   integer()  const { assert(_t==JsonType.Number, "not a number"); return cast(long)_n; }
    /// Строковое значение. Бросает assert если тип не $(D String).
    @property string str()      const { assert(_t==JsonType.String, "not a string"); return _s; }

    /// Массив элементов. Бросает assert если тип не $(D Array).
    @property inout(JsonValue)[]          array()  inout { assert(_t==JsonType.Array,  "not an array");  return _arr; }
    /// Ассоциативный массив полей. Бросает assert если тип не $(D Object).
    @property inout(JsonValue[string])    object() inout { assert(_t==JsonType.Object, "not an object"); return _obj; }


    // ── Безопасный доступ с запасным значением ────────────────────────────

    /**
     * Возвращает значение как тип $(D T), или $(D def) если тип не совпадает.
     *
     * Поддерживаемые типы T: $(D bool), $(D int), $(D long), $(D uint),
     * $(D float), $(D double), $(D string), $(D JsonArray), $(D JsonObject).
     *
     * Params:
     *   def = запасное значение (по умолчанию T.init).
     * Returns: хранимое значение если тип совпадает, иначе def.
     *
     * Example:
     * ---
     * auto v = JsonValue(42);
     * assert(v.get!int(0)      == 42);
     * assert(v.get!bool(false) == false);  // тип не совпадает → def
     * ---
     */
    T get(T)(lazy T def = T.init) const {
        static if      (is(T == bool))       { return isBool()   ? _b            : def; }
        else static if (is(T == double))     { return isNumber() ? _n            : def; }
        else static if (is(T == float))      { return isNumber() ? cast(float)_n : def; }
        else static if (is(T == long))       { return isNumber() ? cast(long)_n  : def; }
        else static if (is(T == int))        { return isNumber() ? cast(int)_n   : def; }
        else static if (is(T == uint))       { return isNumber() ? cast(uint)_n  : def; }
        else static if (is(T : string))      { return isString() ? _s            : def; }
        else static if (is(T == JsonArray))  { return isArray()  ? _arr          : def; }
        else static if (is(T == JsonObject)) { return isObject() ? _obj          : def; }
        else return def;
    }

    /**
     * Возвращает поле объекта по ключу как тип $(D T), или $(D def) если
     * ключ отсутствует или тип значения не совпадает.
     *
     * Params:
     *   key = имя поля объекта.
     *   def = запасное значение.
     * Returns: значение поля или def.
     *
     * Example:
     * ---
     * auto obj = parseJson(`{"name":"Bob","age":25}`);
     * assert(obj.get!string("name",  "")    == "Bob");
     * assert(obj.get!string("email", "n/a") == "n/a");  // поле отсутствует → def
     * ---
     */
    T get(T)(string key, lazy T def = T.init) const {
        assert(_t == JsonType.Object, "not an object");
        auto p = key in _obj;
        if (p is null) return def;
        return p.get!T(def);
    }


    // ── opIndex — доступ по ключу и индексу ───────────────────────────────

    /**
     * Доступ к полю объекта по ключу (чтение и запись).
     *
     * Бросает $(D RangeError) если ключ отсутствует.
     * Для безопасного доступа используйте $(D "key" in jv) или $(D get!T).
     *
     * Params:
     *   key = имя поля.
     * Returns: ссылка на JsonValue поля.
     */
    ref JsonValue opIndex(string key) {
        assert(_t == JsonType.Object, "not an object");
        return _obj[key];
    }

    /**
     * Доступ к элементу массива по индексу (чтение и запись).
     *
     * Params:
     *   i = индекс элемента (0-based).
     * Returns: ссылка на JsonValue элемента.
     */
    ref JsonValue opIndex(size_t i) {
        assert(_t == JsonType.Array, "not an array");
        return _arr[i];
    }

    /// Перегрузка для удобства: принимает $(D int) вместо $(D size_t).
    ref JsonValue opIndex(int i) { return opIndex(cast(size_t)i); }


    // ── opIndexAssign ─────────────────────────────────────────────────────

    /// Присваивание поля объекта: $(D jv["key"] = value).
    void opIndexAssign(JsonValue val, string key) {
        assert(_t == JsonType.Object, "not an object");
        _obj[key] = val;
    }

    /// Присваивание элемента массива: $(D jv[i] = value).
    void opIndexAssign(JsonValue val, size_t i) {
        assert(_t == JsonType.Array, "not an array");
        _arr[i] = val;
    }


    // ── Оператор "key" in jv ──────────────────────────────────────────────

    /**
     * Проверяет наличие ключа в объекте.
     *
     * Returns: указатель на $(D JsonValue) если ключ присутствует,
     *          $(D null) если ключ отсутствует или значение не объект.
     *
     * Example:
     * ---
     * auto obj = parseJson(`{"x":1}`);
     * if (auto p = "x" in obj) assert(p.integer == 1);
     * assert(("y" in obj) is null);
     * ---
     */
    inout(JsonValue)* opBinaryRight(string op : "in")(string key) inout {
        if (_t != JsonType.Object) return null;
        return key in _obj;
    }


    // ── foreach ───────────────────────────────────────────────────────────
    //
    // D не может различить перегрузки делегатов (string,T) и (size_t,T) без
    // явной аннотации типа. Поэтому только 1-аргументная форма реализована
    // непосредственно на структуре. Для итерации с ключами или индексом
    // используйте .array или .object напрямую:
    //
    //   foreach (ref v; jv)              — элементы массива (без индекса)
    //   foreach (i, ref v; jv.array)     — элементы массива с индексом
    //   foreach (key, ref v; jv.object)  — поля объекта (ключ + значение)

    /**
     * Итерация по элементам массива: $(D foreach (ref val; jv)).
     *
     * Бросает assert если значение не является массивом.
     */
    int opApply(scope int delegate(ref JsonValue) dg) {
        assert(_t == JsonType.Array, "not an array");
        foreach (ref v; _arr) { int r = dg(v); if (r) return r; }
        return 0;
    }


    // ── Оператор ~= ───────────────────────────────────────────────────────

    /**
     * Добавляет элемент в конец массива: $(D jv ~= JsonValue(x)).
     *
     * Бросает assert если значение не является массивом.
     */
    void opOpAssign(string op : "~")(JsonValue val) {
        assert(_t == JsonType.Array, "not an array");
        _arr ~= val;
    }


    // ── length ────────────────────────────────────────────────────────────

    /**
     * Количество элементов контейнера.
     *
     * Returns:
     *   Array  → число элементов; Object → число полей;
     *   String → длина в байтах; остальные → 0.
     */
    @property size_t length() const pure nothrow {
        if (_t == JsonType.Array)  return _arr.length;
        if (_t == JsonType.Object) return _obj.length;
        if (_t == JsonType.String) return _s.length;
        return 0;
    }


    // ── toString ──────────────────────────────────────────────────────────

    /**
     * Сериализует значение в компактный JSON (псевдоним $(D toJsonCompact)).
     *
     * Returns: строка JSON без лишних пробелов.
     */
    string toString() const {
        auto app = appender!string();
        _serVal(app, this, -1, 0);
        return app.data;
    }
}


// ── Тесты JsonValue (конструкторы, предикаты, доступ, итерация) ───────────

unittest {
    // ── Конструкторы и предикаты типа ─────────────────────────────────────
    assert(JsonValue(null).isNull);
    assert(JsonValue(true).isBool    && JsonValue(true).boolean  == true);
    assert(JsonValue(false).isBool   && JsonValue(false).boolean == false);
    assert(JsonValue(42).isNumber    && JsonValue(42).integer    == 42);
    assert(JsonValue(3.14).isNumber);
    assert(JsonValue("hi").isString  && JsonValue("hi").str      == "hi");
    assert(JsonValue(JsonArray.init).isArray);
    assert(JsonValue(JsonObject.init).isObject);
    assert(JsonValue.null_().isNull);

    // ── integer и number — разные представления одного хранилища ──────────
    auto nv = JsonValue(7);
    assert(nv.integer == 7);
    assert(nv.number  == 7.0);

    // ── get!T — безопасный доступ с дефолтом ──────────────────────────────
    auto v42 = JsonValue(42);
    assert(v42.get!int(0)      == 42);
    assert(v42.get!long(0)     == 42L);
    assert(v42.get!bool(false) == false);    // тип не совпадает → дефолт
    assert(v42.get!string("")  == "");       // тип не совпадает → дефолт

    auto vs = JsonValue("hello");
    assert(vs.get!string("?") == "hello");
    assert(vs.get!int(99)     == 99);        // тип не совпадает → дефолт

    // ── opIndex, opIndexAssign, "in" для Object ────────────────────────────
    JsonObject m; m["a"] = JsonValue(1); m["b"] = JsonValue("x");
    auto obj = JsonValue(m);
    assert(obj["a"].integer == 1);
    assert(obj["b"].str     == "x");
    assert(("a" in obj) !is null);
    assert(("z" in obj) is  null);
    obj["c"] = JsonValue(true);
    assert(obj["c"].boolean == true);
    assert(obj.length == 3);

    // get!T(key, def) для объекта
    assert(obj.get!int("a", 0)        == 1);
    assert(obj.get!string("b", "?")   == "x");
    assert(obj.get!string("miss", "!") == "!");  // ключ отсутствует → дефолт

    // ── opIndex, ~= для Array ─────────────────────────────────────────────
    auto arr = JsonValue(JsonArray.init);
    arr ~= JsonValue(10);
    arr ~= JsonValue(20);
    arr ~= JsonValue(30);
    assert(arr.length   == 3);
    assert(arr[0].integer == 10);
    assert(arr[2].integer == 30);
    arr[1] = JsonValue(99);
    assert(arr[1].integer == 99);

    // ── foreach по массиву ────────────────────────────────────────────────
    long sum = 0;
    foreach (ref v; arr) sum += v.integer;
    assert(sum == 10 + 99 + 30);

    // ── length для String ─────────────────────────────────────────────────
    assert(JsonValue("abc").length == 3);
    assert(JsonValue(null).length  == 0);

    // ── toString ──────────────────────────────────────────────────────────
    assert(JsonValue(1).toString()      == "1");
    assert(JsonValue("ok").toString()   == `"ok"`);
    assert(JsonValue(null).toString()   == "null");
    assert(JsonValue(true).toString()   == "true");
}


// ══════════════════════════════════════════════════════════════════════════════
// Хелперы построения JSON-значений
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Создаёт JsonValue-массив из произвольного набора D-значений.
 *
 * Каждый аргумент автоматически конвертируется в $(D JsonValue) через
 * внутренний хелпер $(D _toJv). Поддерживаются: null, bool, числа,
 * строки, JsonArray, JsonObject, JsonValue.
 *
 * Params:
 *   args = любое количество значений D-типов.
 * Returns: JsonValue с типом Array.
 *
 * Example:
 * ---
 * auto arr = jarray(1, "two", true, JsonValue.null_());
 * assert(arr.length == 4);
 * assert(arr[0].integer == 1);
 * ---
 */
JsonValue jarray(Args...)(Args args) {
    JsonArray arr;
    static foreach (i; 0 .. Args.length)
        arr ~= _toJv(args[i]);
    return JsonValue(arr);
}

/**
 * Создаёт JsonValue-объект из чередующихся пар ключ/значение.
 *
 * Количество аргументов должно быть чётным: нечётные — строковые ключи,
 * чётные — значения D-типов (автоматически конвертируются в JsonValue).
 *
 * Params:
 *   args = пары (string key, value), ...
 * Returns: JsonValue с типом Object.
 *
 * Example:
 * ---
 * auto obj = jobject("name", "Alice", "age", 30, "active", true);
 * assert(obj["name"].str     == "Alice");
 * assert(obj["age"].integer  == 30);
 * assert(obj["active"].boolean == true);
 * ---
 */
JsonValue jobject(Args...)(Args args) if (Args.length % 2 == 0) {
    JsonObject obj;
    static foreach (i; 0 .. Args.length / 2)
        obj[args[i * 2]] = _toJv(args[i * 2 + 1]);
    return JsonValue(obj);
}

/**
 * Конвертирует D-значение в JsonValue.
 *
 * Используется внутри $(D jarray) и $(D jobject).
 * Поддерживает: JsonValue, null, bool, числа, строки, JsonArray, JsonObject.
 */
private JsonValue _toJv(T)(T v) {
    static if (is(T == JsonValue))         return v;
    else static if (is(T == typeof(null))) return JsonValue(null);
    else static if (is(T == bool))         return JsonValue(v);
    else static if (is(T : double))        return JsonValue(cast(double)v);
    else static if (is(T : string))        return JsonValue(cast(string)v);
    else static if (is(T == JsonArray))    return JsonValue(v);
    else static if (is(T == JsonObject))   return JsonValue(v);
    else static assert(false, "Cannot convert " ~ T.stringof ~ " to JsonValue");
}


// ── Тесты построителей jarray / jobject ──────────────────────────────────

unittest {
    // jarray
    auto a = jarray(1, "two", true, JsonValue.null_());
    assert(a.length       == 4);
    assert(a[0].integer   == 1);
    assert(a[1].str       == "two");
    assert(a[2].boolean   == true);
    assert(a[3].isNull);

    // jobject
    auto o = jobject("x", 10, "y", 2.5, "s", "hi", "flag", false);
    assert(o["x"].integer  == 10);
    assert(o["y"].number   == 2.5);
    assert(o["s"].str      == "hi");
    assert(o["flag"].boolean == false);
    assert(o.length        == 4);

    // вложенные структуры
    auto nested = jobject("arr", jarray(1, 2), "obj", jobject("k", "v"));
    assert(nested["arr"][0].integer == 1);
    assert(nested["obj"]["k"].str   == "v");
}


// ══════════════════════════════════════════════════════════════════════════════
// Сериализация
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Сериализует JSON-значение в компактную строку (без пробелов и переносов).
 *
 * Params:
 *   v = значение для сериализации.
 * Returns: строка JSON.
 *
 * Example:
 * ---
 * auto obj = jobject("n", 42, "s", "hi");
 * string s = toJsonCompact(obj);  // {"n":42,"s":"hi"} (порядок ключей не гарантирован)
 * ---
 */
string toJsonCompact(JsonValue v) {
    auto app = appender!string();
    _serVal(app, v, -1, 0);
    return app.data;
}

/**
 * Сериализует JSON-значение в строку с отступами (человекочитаемый формат).
 *
 * Params:
 *   v      = значение для сериализации.
 *   spaces = количество пробелов на уровень отступа (по умолчанию 2).
 * Returns: строка JSON с переносами строк и отступами.
 *
 * Example:
 * ---
 * string pretty = toJsonPretty(parseJson(`{"a":1}`));
 * // {
 * //   "a": 1
 * // }
 * ---
 */
string toJsonPretty(JsonValue v, int spaces = 2) {
    auto app = appender!string();
    _serVal(app, v, spaces, 0);
    return app.data;
}

/**
 * Внутренняя рекурсивная процедура сериализации.
 *
 * Params:
 *   app   = буфер накопления строки.
 *   v     = текущее значение.
 *   sp    = отступ в пробелах (-1 = компактный режим без отступов).
 *   depth = текущая глубина вложенности.
 */
private void _serVal(ref Appender!string app, const ref JsonValue v, int sp, int depth) {
    final switch (v.type) {
    case JsonType.Null:
        app.put("null");
        break;
    case JsonType.Bool:
        app.put(v.boolean ? "true" : "false");
        break;
    case JsonType.Number:
        double n = v.number;
        import std.math : isNaN, isInfinity;
        // JSON не поддерживает NaN/Infinity — заменяем на null (стандартная практика)
        if (isNaN(n) || isInfinity(n)) { app.put("null"); break; }
        // Целые числа без дробной части — выводим без ".0"
        long li = cast(long)n;
        if (cast(double)li == n && li > -1_000_000_000_000_000L && li < 1_000_000_000_000_000L)
            app.put(li.to!string);
        else
            app.put(n.to!string);
        break;
    case JsonType.String:
        _serStr(app, v.str);
        break;
    case JsonType.Array:
        auto arr = v.array;
        if (arr.length == 0) { app.put("[]"); break; }
        app.put('[');
        foreach (i, ref el; arr) {
            if (i > 0) app.put(',');
            if (sp >= 0) { app.put('\n'); foreach (_; 0 .. (depth+1)*sp) app.put(' '); }
            _serVal(app, el, sp, depth + 1);
        }
        if (sp >= 0) { app.put('\n'); foreach (_; 0 .. depth*sp) app.put(' '); }
        app.put(']');
        break;
    case JsonType.Object:
        auto obj = v.object;
        if (obj.length == 0) { app.put("{}"); break; }
        app.put('{');
        bool first = true;
        foreach (key, ref val; obj) {
            if (!first) app.put(',');
            first = false;
            if (sp >= 0) { app.put('\n'); foreach (_; 0 .. (depth+1)*sp) app.put(' '); }
            _serStr(app, key);
            app.put(':');
            if (sp >= 0) app.put(' ');
            _serVal(app, val, sp, depth + 1);
        }
        if (sp >= 0) { app.put('\n'); foreach (_; 0 .. depth*sp) app.put(' '); }
        app.put('}');
        break;
    }
}

/**
 * Записывает строку в буфер с JSON-экранированием специальных символов.
 *
 * Экранируются: $(D "), $(D \), $(D \n), $(D \r), $(D \t), $(D \b), $(D \f)
 * и управляющие символы (код < 0x20) через $(D \uXXXX).
 */
private void _serStr(ref Appender!string app, string s) {
    app.put('"');
    foreach (char c; s) {
        switch (c) {
        case '"':  app.put("\\\""); break;
        case '\\': app.put("\\\\"); break;
        case '\n': app.put("\\n");  break;
        case '\r': app.put("\\r");  break;
        case '\t': app.put("\\t");  break;
        case '\b': app.put("\\b");  break;
        case '\f': app.put("\\f");  break;
        default:
            if (cast(ubyte)c < 0x20)
                app.put(format("\\u%04x", cast(uint)c));
            else
                app.put(c);
        }
    }
    app.put('"');
}


// ── Тесты сериализации ────────────────────────────────────────────────────

unittest {
    // Скалярные типы
    assert(toJsonCompact(JsonValue(null))  == "null");
    assert(toJsonCompact(JsonValue(true))  == "true");
    assert(toJsonCompact(JsonValue(false)) == "false");
    assert(toJsonCompact(JsonValue(42))    == "42");
    assert(toJsonCompact(JsonValue(1.5))   == "1.5");
    assert(toJsonCompact(JsonValue("hi"))  == `"hi"`);

    // Целое — без дробной части
    assert(toJsonCompact(JsonValue(100L))  == "100");
    assert(toJsonCompact(JsonValue(0))     == "0");

    // NaN и Infinity → null (JSON их не поддерживает)
    import std.math : sqrt;
    assert(toJsonCompact(JsonValue(double.nan))      == "null");
    assert(toJsonCompact(JsonValue(double.infinity)) == "null");

    // Пустые контейнеры
    assert(toJsonCompact(JsonValue(JsonArray.init))  == "[]");
    assert(toJsonCompact(JsonValue(JsonObject.init)) == "{}");

    // Экранирование спецсимволов
    auto esc = toJsonCompact(JsonValue("a\nb\tc"));
    assert(esc == `"a\nb\tc"`);
    auto dq = toJsonCompact(JsonValue(`say "hi"`));
    assert(dq == `"say \"hi\""`);

    // pretty длиннее compact
    auto obj = jobject("x", 1, "y", 2);
    assert(toJsonPretty(obj).length > toJsonCompact(obj).length);

    // round-trip: сериализация → парсинг
    auto orig = jobject("n", 7, "s", "test", "arr", jarray(1, 2));
    auto rt   = parseJson(toJsonCompact(orig));
    assert(rt["n"].integer   == 7);
    assert(rt["s"].str       == "test");
    assert(rt["arr"][1].integer == 2);
}


// ══════════════════════════════════════════════════════════════════════════════
// Разбор (парсинг)
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Исключение, бросаемое $(D parseJson) при синтаксической ошибке.
 *
 * Содержит позицию ошибки (строка и столбец) для диагностики.
 */
class JsonParseException : Exception {
    int line;  /// Номер строки (1-based) в исходном тексте.
    int col;   /// Номер столбца (1-based) в исходном тексте.

    /**
     * Params:
     *   msg  = описание ошибки.
     *   line = строка в исходном JSON.
     *   col  = столбец в исходном JSON.
     */
    this(string msg, int line = 0, int col = 0) {
        super(format("JSON parse error (line %d, col %d): %s", line, col, msg));
        this.line = line; this.col = col;
    }
}

/**
 * Разбирает строку JSON и возвращает корневое $(D JsonValue).
 *
 * Поддерживаются все типы JSON: null, bool, number (целые и дробные,
 * экспоненциальная запись), string (с escape-последовательностями включая
 * $(D \uXXXX)), array, object. Пробелы между токенами игнорируются.
 *
 * Params:
 *   text = строка JSON в кодировке UTF-8.
 * Returns: корневое JSON-значение.
 * Throws: $(D JsonParseException) при синтаксической ошибке или наличии
 *         непустых символов после корневого значения.
 *
 * Example:
 * ---
 * auto v = parseJson(`{"x":1,"arr":[true,null]}`);
 * assert(v["x"].integer      == 1);
 * assert(v["arr"][0].boolean == true);
 * assert(v["arr"][1].isNull);
 * ---
 */
JsonValue parseJson(string text) {
    auto p = _Parser(text);
    auto v = p.parseValue();
    p.skipWs();
    if (p.pos < p.s.length)
        throw new JsonParseException(
            format("unexpected trailing content '%s'", p.s[p.pos .. $].length > 20
                   ? p.s[p.pos .. p.pos+20] ~ "..." : p.s[p.pos .. $]),
            p.line, p.col);
    return v;
}

/**
 * Пробует разобрать строку JSON без бросания исключений.
 *
 * Params:
 *   text   = строка JSON в кодировке UTF-8.
 *   result = (out) результат разбора при успехе.
 * Returns: $(D true) если разбор прошёл успешно, $(D false) при ошибке.
 *
 * Example:
 * ---
 * JsonValue v;
 * if (tryParseJson(responseBody, v))
 *     writeln(v["status"].str);
 * else
 *     writeln("не валидный JSON");
 * ---
 */
bool tryParseJson(string text, out JsonValue result) {
    try { result = parseJson(text); return true; }
    catch (JsonParseException) { return false; }
}


// ── Тесты парсинга ────────────────────────────────────────────────────────

unittest {
    // Скалярные значения
    assert(parseJson("null").isNull);
    assert(parseJson("true").boolean  == true);
    assert(parseJson("false").boolean == false);
    assert(parseJson("42").integer    == 42);
    assert(parseJson("-7").integer    == -7);
    assert(parseJson("0").integer     == 0);
    {
        import std.math : abs;
        assert(abs(parseJson("3.14").number - 3.14) < 1e-9);
        assert(abs(parseJson("1e2").number  - 100.0) < 1e-6);
    }

    // Строки и escape-последовательности
    assert(parseJson(`"hello"`).str == "hello");
    assert(parseJson(`"a\nb"`).str  == "a\nb");
    assert(parseJson(`"a\tb"`).str  == "a\tb");
    assert(parseJson(`"a\"b"`).str  == "a\"b");
    assert(parseJson(`"a\\b"`).str  == "a\\b");
    assert(parseJson(`"\u0041BC"`).str == "ABC");   // \u0041 = 'A'

    // Массивы
    auto arr = parseJson("[1,2,3]");
    assert(arr.isArray      && arr.length == 3);
    assert(arr[1].integer   == 2);

    auto empty = parseJson("[]");
    assert(empty.isArray    && empty.length == 0);

    // Объекты
    auto obj = parseJson(`{"a":1,"b":true,"c":null}`);
    assert(obj.isObject);
    assert(obj["a"].integer  == 1);
    assert(obj["b"].boolean  == true);
    assert(obj["c"].isNull);

    // Вложенные структуры
    auto deep = parseJson(`{"u":{"n":"Eve","v":[10,20]}}`);
    assert(deep["u"]["n"].str        == "Eve");
    assert(deep["u"]["v"][1].integer == 20);

    // Пробелы между токенами
    assert(parseJson("  {  \"x\"  :  1  }  ")["x"].integer == 1);

    // tryParseJson
    JsonValue v;
    assert( tryParseJson(`{"ok":1}`, v)  && v["ok"].integer == 1);
    assert(!tryParseJson(`{bad}`,    v));
    assert(!tryParseJson(``,         v));
    assert(!tryParseJson(`1 2`,      v));   // хвостовой мусор

    // JsonParseException содержит позицию
    bool threw = false;
    try { parseJson("{broken"); }
    catch (JsonParseException e) { threw = true; assert(e.line >= 1); }
    assert(threw);
}


// ══════════════════════════════════════════════════════════════════════════════
// Внутренний парсер (приватный)
// ══════════════════════════════════════════════════════════════════════════════

/**
 * Рекурсивный нисходящий парсер JSON.
 *
 * Отслеживает позицию (pos) и номер строки/столбца (line/col) для
 * формирования информативных сообщений об ошибках.
 */
private struct _Parser {
    string s;           // исходный текст
    size_t pos;         // текущая позиция байта
    int    line = 1;    // текущая строка (1-based)
    int    col  = 1;    // текущий столбец (1-based)

    /// Продвигает позицию на один символ, обновляя счётчики строки/столбца.
    void adv() {
        if (pos >= s.length) return;
        if (s[pos] == '\n') { line++; col = 1; } else col++;
        pos++;
    }

    /// Возвращает текущий символ без продвижения; '\0' в конце строки.
    char peek() const { return pos < s.length ? s[pos] : '\0'; }

    /// Пропускает пробелы, табуляции и переносы строк.
    void skipWs() {
        while (pos < s.length && (s[pos]==' '||s[pos]=='\t'||s[pos]=='\r'||s[pos]=='\n'))
            adv();
    }

    /// Ожидает конкретный символ (с пропуском пробелов); бросает исключение если не совпадает.
    void expect(char c) {
        skipWs();
        if (peek() != c)
            throw new JsonParseException(
                format("expected '%c', got '%s'", c, pos < s.length ? s[pos..$][0..1] : "EOF"),
                line, col);
        adv();
    }

    /// Разбирает очередное JSON-значение по первому символу.
    JsonValue parseValue() {
        skipWs();
        switch (peek()) {
        case '"': return parseStr();
        case '{': return parseObj();
        case '[': return parseArr();
        case 't': case 'f': return parseBool();
        case 'n': return parseNull();
        case '-': case '0': .. case '9': return parseNum();
        default:
            throw new JsonParseException(
                format("unexpected character '%s'", pos < s.length ? s[pos..$][0..1] : "EOF"),
                line, col);
        }
    }

    /// Разбирает литерал null.
    JsonValue parseNull() {
        if (pos+4 <= s.length && s[pos..pos+4] == "null") {
            pos+=4; col+=4; return JsonValue(null);
        }
        throw new JsonParseException("expected 'null'", line, col);
    }

    /// Разбирает литералы true / false.
    JsonValue parseBool() {
        if (pos+4 <= s.length && s[pos..pos+4] == "true")  { pos+=4; col+=4; return JsonValue(true);  }
        if (pos+5 <= s.length && s[pos..pos+5] == "false") { pos+=5; col+=5; return JsonValue(false); }
        throw new JsonParseException("expected 'true' or 'false'", line, col);
    }

    /// Разбирает числовой литерал (целый, дробный, экспоненциальный).
    JsonValue parseNum() {
        size_t start = pos;
        if (peek() == '-') adv();
        while (pos < s.length && s[pos] >= '0' && s[pos] <= '9') adv();
        if (pos < s.length && s[pos] == '.') {
            adv();
            while (pos < s.length && s[pos] >= '0' && s[pos] <= '9') adv();
        }
        if (pos < s.length && (s[pos] == 'e' || s[pos] == 'E')) {
            adv();
            if (peek() == '+' || peek() == '-') adv();
            while (pos < s.length && s[pos] >= '0' && s[pos] <= '9') adv();
        }
        return JsonValue(s[start..pos].to!double);
    }

    /// Разбирает строковой литерал с поддержкой всех escape-последовательностей JSON.
    JsonValue parseStr() {
        expect('"');
        auto app = appender!string();
        while (pos < s.length && s[pos] != '"') {
            if (s[pos] == '\\') {
                adv();
                char esc = peek(); adv();
                switch (esc) {
                case '"':  app.put('"');  break;
                case '\\': app.put('\\'); break;
                case '/':  app.put('/');  break;
                case 'b':  app.put('\b'); break;
                case 'f':  app.put('\f'); break;
                case 'n':  app.put('\n'); break;
                case 'r':  app.put('\r'); break;
                case 't':  app.put('\t'); break;
                case 'u': {
                    // \uXXXX — 4 шестнадцатеричных цифры → кодовая точка Unicode
                    if (pos + 4 > s.length)
                        throw new JsonParseException("incomplete \\uXXXX escape", line, col);
                    wchar wc = cast(wchar)s[pos..pos+4].to!ushort(16);
                    pos += 4; col += 4;
                    import std.utf : encode;
                    char[4] buf;
                    size_t n = encode(buf, wc);
                    app.put(buf[0..n]);
                    break;
                }
                default:
                    throw new JsonParseException(format("unknown escape '\\%c'", esc), line, col);
                }
            } else {
                app.put(s[pos]); adv();
            }
        }
        expect('"');
        return JsonValue(app.data);
    }

    /// Разбирает ключ объекта (строка без пробелов).
    string parseKey() {
        skipWs();
        return parseStr().str;
    }

    /// Разбирает массив: [ value, value, ... ]
    JsonValue parseArr() {
        expect('[');
        skipWs();
        JsonArray arr;
        if (peek() == ']') { adv(); return JsonValue(arr); }
        while (true) {
            arr ~= parseValue();
            skipWs();
            if (peek() == ']') { adv(); break; }
            expect(',');
            skipWs();
        }
        return JsonValue(arr);
    }

    /// Разбирает объект: { "key": value, ... }
    JsonValue parseObj() {
        expect('{');
        skipWs();
        JsonObject obj;
        if (peek() == '}') { adv(); return JsonValue(obj); }
        while (true) {
            string key = parseKey();
            expect(':');
            obj[key] = parseValue();
            skipWs();
            if (peek() == '}') { adv(); break; }
            expect(',');
            skipWs();
        }
        return JsonValue(obj);
    }
}
