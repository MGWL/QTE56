/**
 * qte56_core.d — базовые типы, таблица функций pFunQt[], mixin-система.
 *
 * Подключить в программе: import qte56_core;
 * Затем вызвать: LoadQt("qte56.ini")  (из qte56_loader.d)
 */
module qte56_core;

// ─────────────────────────────────────────────────────────────────────────────
// Базовые типы
// ─────────────────────────────────────────────────────────────────────────────

/// Универсальный указатель на Qt C++ объект
alias QtObjH = void*;

/// Размер указателя (64-bit безопасно, нет усечения)
alias PTRINT = size_t;

// ─────────────────────────────────────────────────────────────────────────────
// Таблица адресов функций DLL
//
// pFunQt[index] хранит адрес функции, загруженной из DLL.
// index соответствует колонке index в functions.csv.
// Незагруженные функции остаются null.
// Максимум: 10000 функций (при необходимости увеличить).
// ─────────────────────────────────────────────────────────────────────────────

enum PFUNQT_SIZE = 25000;  // +QFontDialog(12000)+QColorDialog(13000)+QColor(14000)+QInputDialog(15000)+QTabBar(16000)+QDateTimeEdit(17000)+QPixmap(17400)+QClipboard(18000)+QButtonGroup(18200)
__gshared void*[PFUNQT_SIZE] pFunQt;

// ─────────────────────────────────────────────────────────────────────────────
// loadFn — runtime загрузка одной функции из DLL
//
// Вызывается внутри LoadQt() при обработке каждой записи CSV.
// Если модуль не загружен (нет в INI) — возвращает null.
// Реализация в qte56_loader.d.
// ─────────────────────────────────────────────────────────────────────────────

/// Загружает адрес функции func_name из DLL модуля module_name.
/// Возвращает null если модуль не загружен или функция не найдена.
extern void* loadFn(string module_name, string func_name);

// ─────────────────────────────────────────────────────────────────────────────
// generateAlias — compile-time генерация alias типа функции
//
// Ключ кодирует сигнатуру: "RET__P1_P2_P3"
// Коды типов:
//   v   → void
//   b   → int    (C ABI: bool передаётся как int)
//   i   → int
//   ui  → uint
//   l   → long
//   ul  → ulong
//   d   → double
//   f   → float
//   qp  → void*  (Qt object pointer / любой указатель)
//   ip  → int*
//   bp  → bool*
//   cp  → const(char)*
//
// Примеры:
//   generateAlias("v__qp_i")   → alias t_v__qp_i   = extern(C) @nogc void function(void*, int);
//   generateAlias("qp__i")     → alias t_qp__i      = extern(C) @nogc void* function(int);
//   generateAlias("i__qp")     → alias t_i__qp       = extern(C) @nogc int  function(void*);
// ─────────────────────────────────────────────────────────────────────────────

private string _codeToType(string code) pure nothrow @safe {
    switch (code) {
        case "v":  return "void";
        case "b":  return "int";
        case "i":  return "int";
        case "ui": return "uint";
        case "l":  return "long";
        case "ul": return "ulong";
        case "d":  return "double";
        case "f":  return "float";
        case "sz": return "size_t";
        case "qp": return "void*";
        case "ip": return "int*";
        case "bp": return "bool*";
        case "cp": return "const(char)*";
        default:   return "void*";
    }
}

/// Разбивает строку параметров по '_' с учётом двухбуквенных кодов.
/// Например: "qp_ip_i" → ["qp", "ip", "i"]
private string[] _splitParams(string s) pure nothrow @safe {
    string[] result;
    string cur;
    foreach (char c; s) {
        if (c == '_') {
            if (cur.length > 0) { result ~= cur; cur = ""; }
        } else {
            cur ~= c;
        }
    }
    if (cur.length > 0) result ~= cur;
    return result;
}

/// Генерирует D alias для типа функции по ключу.
/// key — без префикса "t_", например: "v__qp_i"
string generateAlias(string key) pure nothrow @safe {
    // Ищем разделитель "__"
    size_t sep = key.length;
    for (size_t i = 0; i + 1 < key.length; i++) {
        if (key[i] == '_' && key[i+1] == '_') { sep = i; break; }
    }

    string ret_code   = key[0 .. sep];
    string params_str = (sep + 2 < key.length) ? key[sep + 2 .. $] : "";

    string ret_type = _codeToType(ret_code);

    string params_d;
    if (params_str.length > 0) {
        string[] codes = _splitParams(params_str);
        foreach (i, c; codes) {
            if (i > 0) params_d ~= ", ";
            params_d ~= _codeToType(c);
        }
    }

    string alias_name = "t_" ~ key;
    return "alias " ~ alias_name
         ~ " = extern(C) @nogc " ~ ret_type
         ~ " function(" ~ params_d ~ ");";
}

// === Centralized aliases (auto-generated from all gen_*.d) ===
// Run: python tools/extract_aliases.py
// Total: 144 unique aliases from 105 files

mixin(generateAlias("b__qp_i"));
mixin(generateAlias("d__qp"));
mixin(generateAlias("d__qp_i"));
mixin(generateAlias("d__qp_qp"));
mixin(generateAlias("d__qp_qp_d"));
mixin(generateAlias("d__qp_qp_qp_i_qp_i_d_d_d_i_qp_i_d"));
mixin(generateAlias("d__qp_qp_qp_qp_d_d_d_i_qp_i"));
mixin(generateAlias("i__"));
mixin(generateAlias("i__i"));
mixin(generateAlias("i__i_i"));
mixin(generateAlias("i__qp"));
mixin(generateAlias("i__qp_cp"));
mixin(generateAlias("i__qp_d"));
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_i_i"));
mixin(generateAlias("i__qp_i_i_cp"));
mixin(generateAlias("i__qp_i_i_i"));
mixin(generateAlias("i__qp_i_i_i_i"));
mixin(generateAlias("i__qp_i_i_qp"));
mixin(generateAlias("i__qp_i_qp"));
mixin(generateAlias("i__qp_i_qp_i"));
mixin(generateAlias("i__qp_i_qp_qp"));
mixin(generateAlias("i__qp_i_qp_qp_i"));
mixin(generateAlias("i__qp_i_qp_qp_qp"));
mixin(generateAlias("i__qp_i_qp_qp_qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("i__qp_qp_i"));
mixin(generateAlias("i__qp_qp_i_i"));
mixin(generateAlias("i__qp_qp_i_qp_i"));
mixin(generateAlias("i__qp_qp_qp"));
mixin(generateAlias("i__qp_qp_qp_i"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_i_i"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_i_i_i"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_qp_i_qp_i_qp_i_i_i"));
mixin(generateAlias("i__qp_qp_qp_qp"));
mixin(generateAlias("i__qp_qp_qp_qp_i"));
mixin(generateAlias("i__qp_qp_qp_qp_i_i"));
mixin(generateAlias("i__qp_qp_qp_qp_i_i_i_i_qp_i"));
mixin(generateAlias("l__qp"));
mixin(generateAlias("l__qp_i"));
mixin(generateAlias("qp__"));
mixin(generateAlias("qp__d"));
mixin(generateAlias("qp__d_d_d_d_qp"));
mixin(generateAlias("qp__i"));
mixin(generateAlias("qp__i_i"));
mixin(generateAlias("qp__i_i_i"));
mixin(generateAlias("qp__i_i_i_i"));
mixin(generateAlias("qp__qp"));
mixin(generateAlias("qp__qp_d"));
mixin(generateAlias("qp__qp_d_d_d_d"));
mixin(generateAlias("qp__qp_d_d_d_d_d"));
mixin(generateAlias("qp__qp_i"));
mixin(generateAlias("qp__qp_i_i"));
mixin(generateAlias("qp__qp_i_i_i"));
mixin(generateAlias("qp__qp_i_i_i_i"));
mixin(generateAlias("qp__qp_i_i_i_i_i"));
mixin(generateAlias("qp__qp_i_i_i_i_i_qp"));
mixin(generateAlias("qp__qp_i_i_i_i_i_qp_i"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("qp__qp_i_qp_i"));
mixin(generateAlias("qp__qp_ip"));
mixin(generateAlias("qp__qp_qp"));
mixin(generateAlias("qp__qp_qp_i"));
mixin(generateAlias("qp__qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_i_qp"));
mixin(generateAlias("qp__qp_qp_i_qp_i"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("qp__qp_qp_qp_i"));
mixin(generateAlias("qp__qp_qp_qp_i_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp_i_qp_i_qp_i_qp_i"));
mixin(generateAlias("qp__qp_qp_qp_i_qp_qp"));
mixin(generateAlias("qp__qp_qp_qp_qp_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_i_qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_qp_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_qp_qp_i"));
mixin(generateAlias("qp__qp_qp_qp_qp_qp_qp_i_i"));
mixin(generateAlias("qp__qp_ui"));
mixin(generateAlias("qp__qp_ui_i"));
mixin(generateAlias("qp__qp_ui_i_i"));
mixin(generateAlias("sz__qp"));
mixin(generateAlias("ui__qp"));
mixin(generateAlias("ui__qp_i"));
mixin(generateAlias("ui__qp_i_i"));
mixin(generateAlias("v__i"));
mixin(generateAlias("v__i_ip_ip_ip_ip"));
mixin(generateAlias("v__qp"));
mixin(generateAlias("v__qp_cp"));
mixin(generateAlias("v__qp_cp_i"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d"));
mixin(generateAlias("v__qp_d_d_d_d"));
mixin(generateAlias("v__qp_d_d_d_d_d"));
mixin(generateAlias("v__qp_d_d_d_d_i"));
mixin(generateAlias("v__qp_d_i"));
mixin(generateAlias("v__qp_i"));
mixin(generateAlias("v__qp_i_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_d_d_i"));
mixin(generateAlias("v__qp_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_i_i_i_qp_i_qp"));
mixin(generateAlias("v__qp_i_i_i_i_i_qp_qp"));
mixin(generateAlias("v__qp_i_i_i_i_qp"));
mixin(generateAlias("v__qp_i_i_i_i_qp_i_i_i_i"));
mixin(generateAlias("v__qp_i_i_qp"));
mixin(generateAlias("v__qp_i_i_qp_i"));
mixin(generateAlias("v__qp_i_i_ui"));
mixin(generateAlias("v__qp_i_ip_ip"));
mixin(generateAlias("v__qp_i_l"));
mixin(generateAlias("v__qp_i_qp"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_i_qp_i_qp"));
mixin(generateAlias("v__qp_i_qp_qp"));
mixin(generateAlias("v__qp_i_ui"));
mixin(generateAlias("v__qp_ip_ip"));
mixin(generateAlias("v__qp_ip_ip_ip"));
mixin(generateAlias("v__qp_ip_ip_ip_ip"));
mixin(generateAlias("v__qp_ip_ip_ip_ip_ip_ip_ip"));
mixin(generateAlias("v__qp_l"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_d"));
mixin(generateAlias("v__qp_qp_d_d_i"));
mixin(generateAlias("v__qp_qp_i"));
mixin(generateAlias("v__qp_qp_i_i"));
mixin(generateAlias("v__qp_qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp_i_qp"));
mixin(generateAlias("v__qp_qp_i_qp_i"));
mixin(generateAlias("v__qp_qp_i_qp_i_i_i"));
mixin(generateAlias("v__qp_qp_i_qp_i_qp"));
mixin(generateAlias("v__qp_qp_i_qp_qp"));
mixin(generateAlias("v__qp_qp_i_ui"));
mixin(generateAlias("v__qp_qp_qp"));
mixin(generateAlias("v__qp_qp_qp_i"));
mixin(generateAlias("v__qp_qp_qp_i_i"));
mixin(generateAlias("v__qp_qp_qp_i_qp_i"));
mixin(generateAlias("v__qp_qp_qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp_qp"));
mixin(generateAlias("v__qp_ui"));

// === End of centralized aliases ===

// ─────────────────────────────────────────────────────────────────────────────
// generateFunQt — compile-time генерация строки загрузки функции
//
// Генерирует код вида:
//   pFunQt[idx] = loadFn("ModuleName", "func_name");
//
// Вставляется внутрь тела LoadQt() через mixin.
// Если модуль не загружен, loadFn вернёт null → pFunQt[idx] = null.
// Вызов незагруженной функции приведёт к null pointer crash —
// это намеренно: пользователь должен указать все нужные модули в INI.
// ─────────────────────────────────────────────────────────────────────────────

string generateFunQt(int idx, string func_name, string module_name) pure nothrow @safe {
    import std.conv : to;
    return `pFunQt[` ~ idx.to!string
         ~ `] = loadFn("` ~ module_name
         ~ `", "` ~ func_name ~ `");`;
}

// ─────────────────────────────────────────────────────────────────────────────
// EventId — идентификаторы Qt-событий для setEventHandler()
//
// Используется в onMousePress(), onResize() и т.д. в gen_qXxx.d классах.
// Значения совпадают с id в events.py EVENT_SPECS.
// ─────────────────────────────────────────────────────────────────────────────

enum EventId : int {
    mousePress       =  1,
    mouseRelease     =  2,
    mouseDoubleClick =  3,
    mouseMove        =  4,
    keyPress         =  5,
    keyRelease       =  6,
    resize           =  7,
    move             =  8,
    close            =  9,
    show             = 10,
    hide             = 11,
    enter            = 12,
    leave            = 13,
    wheel            = 14,
    focusIn          = 15,
    focusOut         = 16,
    contextMenu      = 17,
}

// ─────────────────────────────────────────────────────────────────────────────
// Вспомогательные структуры для дат/времени
//
// QDate/QTime/QDateTime в Qt — value types. В binding'е они разложены
// на целочисленные компоненты во избежание heap-объектов.
// Используются: QDateTimeEdit, QCalendarWidget и др.
// ─────────────────────────────────────────────────────────────────────────────

/// Компоненты даты (год, месяц 1–12, день 1–31)
struct DDate {
    int year, month, day;
    this(int y, int m, int d) { year = y; month = m; day = d; }
}

/// Компоненты времени (часы 0–23, минуты, секунды, миллисекунды)
struct DTime {
    int hour, minute, second, msec;
    this(int h, int mi, int s, int ms = 0) { hour = h; minute = mi; second = s; msec = ms; }
}

/// Дата + время
struct DDateTime {
    int year, month, day, hour, minute, second, msec;
    DDate toDate() const { return DDate(year, month, day); }
    DTime toTime() const { return DTime(hour, minute, second, msec); }
}
