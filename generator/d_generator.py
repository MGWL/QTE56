"""
d_generator.py — генерация D модуля для Qt класса.

Генерирует gen_qXxx.d с:
  - Alias типов функций (только новые, не из gen_qcore)
  - loadQXxx() — регистрация адресов pFunQt[]
  - class QXxx — обёртка с _qt_owned паттерном

Архитектурные решения (совпадают с ручными модулями):
  - Ownership: _qt_owned = (parent != null), ~this() проверяет флаг
  - Строки: string → toUTF16 → wchar_t* + int len → Qt
  - Сигналы: connect_{name}(ESlot eslot) через connectQt()
  - show(): добавляется явно как qteQXxx_show → pFunQt[QWidget::show]
"""

from dataclasses import dataclass, field
from typing import Optional


# ─────────────────────────────────────────────────────────────────────────────
# Value-type распаковка: Qt heap-allocated QSize/QPoint/QRect → D struct
#   d_type   → (pFunQt_index, alias_key, D_struct_type, field_names)
VALUE_TYPE_UNPACK = {
    "DSize":  (37, "v__qp_ip_ip",        "DSize",  ["w", "h"]),
    "DPoint": (34, "v__qp_ip_ip",        "DPoint", ["x", "y"]),
    "DRect":  (31, "v__qp_ip_ip_ip_ip",  "DRect",  ["x", "y", "w", "h"]),
}

# ─────────────────────────────────────────────────────────────────────────────
# Alias-ключи, уже определённые в gen_qcore.d.
# Генератор импортирует эти типы вместо того чтобы переопределять.

GCORE_ALIASES: frozenset = frozenset({
    "qp__i",          # void* function(int)
    "v__qp_i",        # void function(void*, int)
    "b__qp_i",        # int  function(void*, int)
    "qp__qp_qp",      # void* function(void*, void*)
    "v__qp_qp_qp_i",  # void function(void*, void*, void*, int)
    "qp__qp_i",       # void* function(void*, int)
    "i__qp_qp_i",     # int  function(void*, void*, int)
    "v__qp",          # void function(void*)
    "qp__i_i_i_i",
    "v__qp_ip_ip_ip_ip",
    "qp__i_i",
    "v__qp_ip_ip",
    "qp__qp",         # void* function(void*)
    "i__qp",          # int  function(void*)
    "v__qp_qp_i",     # void function(void*, void*, int)  — для строк и connect
    "v__qp_i_qp_qp",  # void function(void*, int, void*, void*) — setEventHandler
    "v__qp_qp_qp",    # void function(void*, void*, void*) — lambda-connect
})

# Всегда импортируем эти символы из gen_qcore
GCORE_IMPORTS = [
    "ESlot", "connectQt", "fromQString",
    "DRect", "DPoint", "DSize",   # value type structs
]

# ─────────────────────────────────────────────────────────────────────────────
# Ownership-transfer методы: генератор добавляет типизированную перегрузку
# рядом с void*-версией.
#
# "widget" → перегрузка принимает QObject (все виджеты наследуют QObject в D)
# "layout" → перегрузка-шаблон (L)(...) (layouts НЕ наследуют QObject в D)
#
# setParent здесь НЕ указан — он требует специальной логики (null → без disown).
# Такие случаи добавляются вручную в соответствующий gen_*.d файл.
OWNERSHIP_METHODS: dict = {
    "addWidget":        "widget",
    "insertWidget":     "widget",
    "setCentralWidget": "widget",
    "addTab":           "widget",
    "insertTab":        "widget",
    "setWidget":        "widget",
    "addLayout":        "layout",
    "setLayout":        "layout",
}


# ─────────────────────────────────────────────────────────────────────────────
# Вычисление alias-ключа из параметров метода (по РЕАЛЬНОЙ C++ сигнатуре)

def _is_qstring(t: str) -> bool:
    n = t.replace("const ", "").replace("&", "").strip()
    return n == "QString"


def _is_qptr(t: str) -> bool:
    n = t.strip()
    return (n.startswith("Q") and n.endswith("*")) or \
           (n.startswith("const Q") and n.endswith("*"))


def _is_qt_enum(t: str) -> bool:
    """True для enum-типов Qt, передаваемых как int в C ABI.
    Обрабатывает: Qt::Xxx, QFlags, Foo::Bar (scope-qualified),
    и bare CamelCase (EchoMode, ActionPosition) без Q-префикса.
    """
    import re
    n = t.strip()
    # Точная проверка по базе знаний (qualified и unqualified формы)
    from knowledge_access import get_knowledge
    kb = get_knowledge()
    if kb is not None:
        norm = n.replace("const ", "").replace("&", "").replace("*", "").strip()
        if kb.is_enum(norm):
            return True
    # Qt::Xxx, QFlags<>, или любой Foo::Bar с оператором scope
    if n.startswith("Qt::") or "Flags" in n or "::" in n:
        return True
    # Bare CamelCase без Q-префикса — вложенный enum (EchoMode, InsertPolicy и т.д.)
    if re.match(r'^[A-Z][A-Za-z0-9]+$', n) and not n.startswith("Q"):
        return True
    return False


def _public_ret_d(ret_d: str) -> str:
    """Внутренний тип возврата генератора → публичный D-тип.
    Любой <Type>_v (QFont_v, QColor_v, QPointF_v, QRectF_v) — opaque void*."""
    if ret_d.endswith("_v"):
        return "void*"
    return ret_d


def _alias_key(ret_d: str, params: list) -> str:
    """
    Строит alias-ключ по D-типу возврата и списку ИСХОДНЫХ Qt параметров.
    Учитывает преобразование типов (QString → qp+i, bool → i и т.д.).
    """
    RET_MAP = {
        "void": "v", "string": "qp", "int": "i", "uint": "ui",
        "bool": "i",   # bool return → int в C ABI
        "void*": "qp", "double": "d", "float": "f",
        # Value types: C++ возвращает void* (heap struct), alias = qp__...
        "DSize": "qp", "DPoint": "qp", "DRect": "qp",
        "QFont_v": "qp", "QColor_v": "qp",   # heap-allocated value types
        "long": "l", "ulong": "ul",
    }
    ret_k = RET_MAP.get(ret_d, "qp")

    # Первый параметр — всегда void* w
    param_keys = ["qp"]

    for p in params:
        t = p.cpp_type.strip()
        if _is_qstring(t):
            param_keys.extend(["qp", "i"])   # wchar_t* + int
        elif t in ("bool",):
            param_keys.append("i")
        elif t in ("int", "unsigned int", "uint", "short", "long"):
            param_keys.append("i")
        elif t in ("double", "qreal"):
            param_keys.append("d")
        elif t == "float":
            param_keys.append("f")
        elif t in ("qint64", "qlonglong"):
            param_keys.append("l")
        elif t in ("quint64", "qulonglong"):
            param_keys.append("ul")
        elif _is_qt_enum(t):
            param_keys.append("i")
        elif _is_qptr(t):
            param_keys.append("qp")
        else:
            param_keys.append("qp")

    return f"{ret_k}__{'_'.join(param_keys)}"


# ─────────────────────────────────────────────────────────────────────────────
# D зарезервированные слова: параметры с такими именами получают суффикс _

_D_KEYWORDS = frozenset({
    "abstract", "alias", "align", "asm", "assert", "auto", "body",
    "break", "case", "cast", "catch", "class", "const", "continue",
    "debug", "default", "delegate", "delete", "deprecated", "do",
    "else", "enum", "export", "extern", "false", "final", "finally",
    "for", "foreach", "function", "goto", "if", "immutable", "import",
    "in", "inout", "interface", "invariant", "is", "lazy", "mixin",
    "module", "new", "nothrow", "null", "out", "override", "package",
    "pragma", "private", "protected", "public", "pure", "ref", "return",
    "scope", "shared", "static", "struct", "super", "switch",
    "synchronized", "template", "this", "throw", "true", "try",
    "typeid", "typeof", "union", "unittest", "version", "while", "with",
})


def _safe_param_name(name: str) -> str:
    """Переименовывает параметры, совпадающие с D ключевыми словами."""
    return name + "_" if name in _D_KEYWORDS else name


# ─────────────────────────────────────────────────────────────────────────────
# Typed ownership overloads helpers

def _ownership_param_idx(params: list, kind: str) -> int:
    """
    Найти индекс Qt-pointer параметра, который будет типизирован.

    kind="widget" → ищем QWidget*, QAbstractXxx*, QLabel*, и т.п. (не Layout)
    kind="layout" → ищем QLayout*, QBoxLayout*, QGridLayout*, и т.п.

    Возвращает индекс первого совпавшего параметра или -1 если не найдено.
    """
    for i, p in enumerate(params):
        t = p.cpp_type.strip()
        if not _is_qptr(t):
            continue
        base = t.replace("const ", "").replace("*", "").strip()
        if kind == "layout" and "Layout" in base:
            return i
        if kind == "widget" and "Layout" not in base:
            return i
    return -1


def _gen_ownership_overload(s, param_idx: int, kind: str, cls_name: str = "") -> list:
    """
    Генерирует типизированную перегрузку ownership-метода.

    s         — MethodSpec исходного void*-метода
    param_idx — индекс в s.params, соответствующий ownership-параметру
    kind      — "widget" (QObject перегрузка) или "layout" (шаблон L)
    cls_name  — имя D-класса для chain-возврата (void-методы возвращают this)

    Логика: вызываем ту же C++ функцию pFunQt[s.idx], но перед вызовом
    извлекаем wh = obj.getWH() и вызываем obj.disown().
    Порядок важен: getWH() до disown() — на случай реализаций где disown()
    обнуляет _wh.
    """
    own_p    = s.params[param_idx]
    own_name = _safe_param_name(own_p.name)
    wh_var   = f"_{own_name}_wh"

    # ── Строим объявление параметров со сменой типа ──────────────────────
    sig_parts = []
    for i, p in enumerate(s.params):
        n = _safe_param_name(p.name)
        t = p.cpp_type.strip()
        if i == param_idx:
            if kind == "layout":
                sig_parts.append(f"L {n}")
            else:
                sig_parts.append(f"QObject {n}")
        elif _is_qstring(t):
            sig_parts.append(f"string {n}")
        elif t == "bool":
            sig_parts.append(f"bool {n}")
        elif t in ("int", "unsigned int", "uint", "short", "long"):
            sig_parts.append(f"int {n}")
        elif t in ("double", "qreal"):
            sig_parts.append(f"double {n}")
        elif _is_qt_enum(t):
            sig_parts.append(f"int {n}")
        elif _is_qptr(t):
            sig_parts.append(f"void* {n}")
        else:
            sig_parts.append(f"void* {n}")
    params_str = ", ".join(sig_parts)

    # ── D-тип возврата ────────────────────────────────────────────────────
    d_ret = _public_ret_d(s.ret_d)
    # Для int-возврата при null вернуть -1; для bool → false; для void → просто return
    null_ret = {
        "int":  "-1",
        "bool": "false",
        "void": "",
    }.get(d_ret, "null")

    # ── Аргументы для вызова pFunQt (повторяем логику _d_method_body) ─────
    alias_k   = _alias_key(s.ret_d, s.params)
    call_args = ["_wh"]
    preamble  = []
    for i, p in enumerate(s.params):
        n = _safe_param_name(p.name)
        t = p.cpp_type.strip()
        if i == param_idx:
            call_args.append(wh_var)
        elif _is_qstring(t):
            ws_var = f"_ws_{p.name}"
            preamble.append(f"import std.utf : toUTF16;")
            preamble.append(f"wstring {ws_var} = {n}.toUTF16;")
            call_args.append(f"cast(void*){ws_var}.ptr")
            call_args.append(f"cast(int){ws_var}.length")
        elif t == "bool":
            call_args.append(f"{n} ? 1 : 0")
        else:
            call_args.append(n)

    # Убираем дублирующиеся import std.utf
    seen, preamble_clean = set(), []
    for line in preamble:
        if line not in seen:
            seen.add(line)
            preamble_clean.append(line)

    call = f"(cast(t_{alias_k})pFunQt[{s.idx}])({', '.join(call_args)})"

    # ── Собираем строки D-кода ────────────────────────────────────────────
    # Chain-возврат: void-методы возвращают this (fluent-вызовы)
    chain_ret = cls_name if (d_ret == "void" and cls_name) else d_ret
    L = []
    if kind == "layout":
        L.append(f"    /// Типизированная перегрузка {s.qt_name}: принимает любой D layout-тип с disown()/getWH().")
        L.append(f"    {chain_ret} {s.qt_name}(L)({params_str})")
        L.append(f"        if (is(typeof({own_name}.disown())) && !is(L == void*))")
        L.append(f"    {{")
    else:
        L.append(f"    /// Типизированная перегрузка {s.qt_name}: автоматически передаёт ownership Qt.")
        L.append(f"    {chain_ret} {s.qt_name}({params_str}) {{")

    # Null-guard
    if null_ret:
        L.append(f"        if ({own_name} is null) return {null_ret};")
    elif chain_ret != "void":
        L.append(f"        if ({own_name} is null) return null;")
    else:
        L.append(f"        if ({own_name} is null) return;")

    # getWH до disown — порядок критичен
    L.append(f"        auto {wh_var} = {own_name}.getWH();")
    L.append(f"        {own_name}.disown();")

    for line in preamble_clean:
        L.append(f"        {line}")

    if d_ret == "void":
        L.append(f"        {call};")
        if cls_name:
            L.append(f"        return this;")
    elif d_ret == "bool":
        L.append(f"        return cast(bool){call};")
    elif d_ret == "string":
        L.append(f"        void* _qs = {call};")
        L.append(f"        string _r = fromQString(_qs);")
        L.append(f"        (cast(t_v__qp)pFunQt[22])(_qs);")
        L.append(f"        return _r;")
    else:
        L.append(f"        return cast({d_ret}){call};")

    L += ["    }", ""]
    return L


# ─────────────────────────────────────────────────────────────────────────────
# Генерация D тела метода

def _d_param_decl(params: list) -> str:
    """Строит список D параметров функции."""
    parts = []
    for p in params:
        t = p.cpp_type.strip()
        n = _safe_param_name(p.name)
        if _is_qstring(t):
            parts.append(f"string {n}")
        elif t == "bool":
            parts.append(f"bool {n}")
        elif t in ("int", "unsigned int", "uint", "short", "long"):
            parts.append(f"int {n}")
        elif t in ("double", "qreal"):
            parts.append(f"double {n}")
        elif t == "float":
            parts.append(f"float {n}")
        elif _is_qt_enum(t):
            parts.append(f"int {n}")
        elif _is_qptr(t):
            parts.append(f"void* {n}")
        else:
            parts.append(f"void* {n}")
    return ", ".join(parts)


def _d_method_body(pfidx: int, alias_key: str, ret_d: str, params: list) -> list:
    """
    Генерирует строки тела D метода.
    Возвращает список строк (без отступов, добавятся при сборке).
    Для value types (DSize, DPoint, DRect) использует unpack через pFunQt.
    """
    # Строим аргументы вызова pFunQt
    args = ["_wh"]
    preamble = []  # строки перед вызовом (конвертации строк)

    for p in params:
        t = p.cpp_type.strip()
        n = _safe_param_name(p.name)
        if _is_qstring(t):
            ws_name = f"_ws_{p.name}"
            preamble.append(f"import std.utf : toUTF16;")
            preamble.append(f"wstring {ws_name} = {n}.toUTF16;")
            args.append(f"cast(void*){ws_name}.ptr")
            args.append(f"cast(int){ws_name}.length")
        elif t == "bool":
            args.append(f"{n} ? 1 : 0")
        else:
            args.append(n)

    # Убираем дублирующиеся import std.utf
    seen = set()
    preamble_dedup = []
    for line in preamble:
        if line not in seen:
            seen.add(line)
            preamble_dedup.append(line)

    call = f"(cast(t_{alias_key})pFunQt[{pfidx}])({', '.join(args)})"

    lines = preamble_dedup

    if ret_d == "void":
        lines.append(f"{call};")
    elif ret_d == "string":
        lines.append(f"void* _qs = {call};")
        lines.append(f"string _r = fromQString(_qs);")
        lines.append(f"(cast(t_v__qp)pFunQt[22])(_qs);")
        lines.append(f"return _r;")
    elif ret_d == "bool":
        lines.append(f"return cast(bool){call};")
    elif ret_d in VALUE_TYPE_UNPACK:
        # DSize / DPoint / DRect: C++ returns void* (heap), D распаковывает
        unpack_idx, unpack_alias, struct_t, fields = VALUE_TYPE_UNPACK[ret_d]
        field_args = ", ".join(f"&_vt.{f}" for f in fields)
        lines.append(f"{struct_t} _vt;")
        lines.append(f"void* _vtp = {call};")
        lines.append(f"(cast(t_{unpack_alias})pFunQt[{unpack_idx}])(_vtp, {field_args});")
        lines.append(f"return _vt;")
    elif ret_d.endswith("_v"):
        # Heap-allocated value type: C++ returns new QFont/QPointF/..., D получает void*
        lines.append(f"return {call};")
    else:
        lines.append(f"return cast({ret_d}){call};")

    return lines


# ─────────────────────────────────────────────────────────────────────────────
# Генерация сигнального connect метода

def _signal_invoke(method) -> Optional[dict]:
    """
    Определяет invoke_* слот по типам параметров сигнала.
    Возвращает {"qt_sig": ..., "invoke": ...} или None если не поддерживается.

    Поддерживаемые invoke-методы eSlot:
      invoke_v()           → 0 параметров
      invoke_b(bool)       → bool
      invoke_i(int)        → int
      invoke_d(double)     → double
      invoke_s(QString)    → QString (по ссылке)
      invoke_p(QPoint)     → QPoint (по ссылке)
      invoke_ii(int,int)   → два int
      invoke_qp(void*)     → Qt-объект как опаковый void* (QAction*, QMenu*, ...)
    """
    import re

    def norm(t): return t.replace("const ", "").replace("&", "").strip()

    # Паттерн Qt-указателя: "QFoo*" или "QFoo" (value-type по ссылке, нормализованный).
    # Такие типы передаются через invoke_qp — D получает сырой void*.
    _QT_PTR = re.compile(r'^Q[A-Z]\w+\*?$')

    def _qt_sig_type(raw_cpp_type: str) -> str:
        """Восстанавливает тип для строки сигнала Qt из сырого C++ типа."""
        t = raw_cpp_type.strip()
        return t

    ps = method.params
    n  = len(ps)

    if n == 0:
        return {"qt_sig": f"{method.name}()",
                "invoke": "invoke_v()"}

    if n == 1:
        t = norm(ps[0].cpp_type)
        # Точные совпадения примитивных / строковых типов
        MAP = {
            "bool":    (f"{method.name}(bool)",               "invoke_b(bool)"),
            "int":     (f"{method.name}(int)",                 "invoke_i(int)"),
            "double":  (f"{method.name}(double)",              "invoke_d(double)"),
            "QString": (f"{method.name}(const QString&)",      "invoke_s(const QString&)"),
            "QPoint":  (f"{method.name}(const QPoint&)",       "invoke_p(const QPoint&)"),
        }
        if t in MAP:
            qt_sig, invoke = MAP[t]
            return {"qt_sig": qt_sig, "invoke": invoke}

        # Qt-указатель (QAction*, QMenu*, QTreeWidgetItem*, ...) — один параметр.
        # Строчный Qt connect не принимает несовпадение типов (QAction* ≠ void*),
        # поэтому используем lambda-connect: отдельная C++ функция захватывает
        # указатель и передаёт в D callback как void*.
        if _QT_PTR.match(t):
            raw = ps[0].cpp_type.strip()
            return {"qt_sig":    f"{method.name}({raw})",
                    "invoke":    "lambda",   # маркер: не eSlot, а прямой connect
                    "use_lambda": True,
                    "ptr_type":  t,          # нормализованный тип: "QAction*"
                    "cpp_raw":   raw}        # исходный C++ тип: "QAction *"

    if n == 2:
        t0, t1 = norm(ps[0].cpp_type), norm(ps[1].cpp_type)
        # Два Qt-указателя (QTreeWidgetItem*, QTreeWidgetItem*) — тоже lambda
        if _QT_PTR.match(t0) and _QT_PTR.match(t1):
            r0 = ps[0].cpp_type.strip()
            r1 = ps[1].cpp_type.strip()
            return {"qt_sig":    f"{method.name}({r0},{r1})",
                    "invoke":    "lambda2",  # два void*
                    "use_lambda": True,
                    "ptr_type":  (t0, t1),
                    "cpp_raw":   (r0, r1)}
        if t0 == "int" and t1 == "int":
            return {"qt_sig": f"{method.name}(int,int)",
                    "invoke": "invoke_ii(int,int)"}

    return None


# ─────────────────────────────────────────────────────────────────────────────
# Основной класс генератора

class DGenerator:
    """
    Генерирует D модуль для одного Qt класса.

    Параметры:
      cls_name     — имя Qt класса ("QLabel")
      module_name  — имя модуля для INI/CSV ("QLabel")
      dll_file     — имя DLL ("qte56_qlabel.dll")
      method_specs — список MethodSpec (из main.py)
      signals      — список QtMethod помеченных как is_signal
      ctor_idx     — pFunQt индекс функции create
      dtor_idx     — pFunQt индекс функции delete
      has_text_ctor — True если есть конструктор с текстом
      text_ctor_idx — pFunQt индекс create_text (если есть)
    """

    def __init__(self, cls_name: str, module_name: str, dll_file: str,
                 method_specs: list, signals: list,
                 ctor_idx: int, dtor_idx: int,
                 has_text_ctor: bool = False, text_ctor_idx: int = 0,
                 event_handler_idx: int = 0,
                 d_parent: str = "",
                 lambda_connect_specs: list = None,
                 gen_info: dict = None):
        self.cls_name             = cls_name
        self.module_name          = module_name
        self.dll_file             = dll_file
        self.method_specs         = method_specs
        self.signals              = signals
        self.ctor_idx             = ctor_idx
        self.dtor_idx             = dtor_idx
        self.has_text_ctor        = has_text_ctor
        self.text_ctor_idx        = text_ctor_idx
        self.event_handler_idx    = event_handler_idx   # 0 = нет событий
        self.d_parent             = d_parent            # "" = standalone class
        # Список lambda-connect: [{"sig_name": str, "idx": int, "invoke": "lambda"/"lambda2"}]
        self.lambda_connect_specs = lambda_connect_specs or []
        self.gen_info             = gen_info            # блок GENERATOR-INFO или None

    # ──────────────────────────────────────────────────────────────────────
    # Alias management

    def _collect_new_aliases(self) -> list:
        """Возвращает отсортированный список alias-ключей, НОВЫХ для этого модуля."""
        needed = set()
        for s in self.method_specs:
            key = _alias_key(s.ret_d, s.params)
            if key not in GCORE_ALIASES:
                needed.add(key)
        # Текстовый конструктор: qp__qp_i_qp (void* result, wchar_t*, int, void* parent)
        if self.has_text_ctor:
            needed.add("qp__qp_i_qp")
        return sorted(needed)

    def _collect_gcore_alias_imports(self) -> list:
        """Возвращает список alias-имён из gen_qcore, нужных этому модулю."""
        needed = set()
        for s in self.method_specs:
            key = _alias_key(s.ret_d, s.params)
            if key in GCORE_ALIASES:
                needed.add(f"t_{key}")
        # Всегда нужен t_v__qp для деструктора и show
        needed.add("t_v__qp")
        needed.add("t_qp__qp")
        # Нужны unpack aliases для value types
        for s in self.method_specs:
            if s.ret_d in VALUE_TYPE_UNPACK:
                _, unpack_alias, _, _ = VALUE_TYPE_UNPACK[s.ret_d]
                if unpack_alias in GCORE_ALIASES:
                    needed.add(f"t_{unpack_alias}")
        # DRect unpack: v__qp_ip_ip_ip_ip
        needed_extras = {"t_v__qp_ip_ip_ip_ip", "t_v__qp_ip_ip"}
        for alias in needed_extras:
            key = alias[2:]  # strip t_
            if key in GCORE_ALIASES:
                needed.add(alias)
        # setEventHandler: void function(void*, int, void*, void*)
        if self.event_handler_idx:
            needed.add("t_v__qp_i_qp_qp")
        # Lambda-connect: void function(void*, void*, void*)
        if self.lambda_connect_specs:
            needed.add("t_v__qp_qp_qp")
        return sorted(needed)

    # ──────────────────────────────────────────────────────────────────────
    # Секция 1: imports + aliases

    def _gen_imports(self) -> list:
        lines = [
            f"module gen_{self.cls_name.lower()};",
            f"",
            f"import qte56_core;",
            f"import qte56_loader : loadFn, registerModule;",
        ]

        # Импорты из gen_qcore
        gcore_t = self._collect_gcore_alias_imports()
        extras  = GCORE_IMPORTS[:]  # ESlot, connectQt, fromQString
        if self.signals:
            pass  # уже в GCORE_IMPORTS
        gcore_all = gcore_t + extras
        if gcore_all:
            lines.append(f"import gen_qcore : {', '.join(gcore_all)};")

        # Импорт D родительского класса (для D-наследования)
        if self.d_parent:
            parent_mod = f"gen_{self.d_parent.lower()}"
            lines.append(f"import {parent_mod} : {self.d_parent};")

        # Импорт QObject для typed ownership overloads (addWidget, setWidget и т.п.)
        # Нужен если в классе есть "widget" ownership-методы и класс сам не является QObject
        _has_widget_ownership = any(
            s.qt_name in OWNERSHIP_METHODS and OWNERSHIP_METHODS[s.qt_name] == "widget"
            and _ownership_param_idx(s.params, "widget") >= 0
            for s in self.method_specs
        )
        if _has_widget_ownership and self.cls_name != "QObject":
            lines.append(f"import gen_qobject : QObject; // для typed ownership overloads")

        lines.append("")

        # Новые aliases
        new_keys = self._collect_new_aliases()
        if new_keys:
            lines.append("// New aliases for this module:")
            for k in new_keys:
                lines.append(f'mixin(generateAlias("{k}"));')
            lines.append("")

        return lines

    # ──────────────────────────────────────────────────────────────────────
    # Секция 2: load function

    def _gen_load_func(self) -> list:
        cls = self.cls_name
        lines = [f"void load{cls}() {{"]

        # create / delete
        lines.append(f'    mixin(generateFunQt({self.ctor_idx}, "qte{cls}_create", "{self.module_name}"));')
        lines.append(f'    mixin(generateFunQt({self.dtor_idx}, "qte{cls}_delete", "{self.module_name}"));')

        if self.has_text_ctor and self.text_ctor_idx:
            lines.append(f'    mixin(generateFunQt({self.text_ctor_idx}, "qte{cls}_create_text", "{self.module_name}"));')

        # методы
        for s in self.method_specs:
            lines.append(f'    mixin(generateFunQt({s.idx}, "{s.func_name}", "{self.module_name}"));')

        # setEventHandler
        if self.event_handler_idx:
            lines.append(f'    mixin(generateFunQt({self.event_handler_idx}, "qte{cls}_setEventHandler", "{self.module_name}"));')

        # Lambda-connect функции: qteQFoo_connect_bar(w, cb, dthis)
        for lc in self.lambda_connect_specs:
            lines.append(f'    mixin(generateFunQt({lc["idx"]}, "{lc["func_name"]}", "{self.module_name}"));')

        lines += ["}", ""]
        # Auto-registration: called by LoadQt() via static module init
        lines += [
            f"static this() {{",
            f"    registerModule(\"{self.module_name}\", \"{self.dll_file}\", &load{cls});",
            f"}}",
            f"",
        ]
        return lines

    # ──────────────────────────────────────────────────────────────────────
    # Секция: event handler methods (onMousePress, onResize, ...)

    def _gen_event_methods(self) -> list:
        """
        Генерирует setEventHandler() + типизированные обёртки onXxx().
        Вставляется в тело класса после сигналов.
        """
        if not self.event_handler_idx:
            return []

        from events import EVENT_SPECS, EVENT_D_METHOD

        idx = self.event_handler_idx
        cls = self.cls_name
        # В дочернем классе методы обработчиков событий переопределяют версии QWidget.
        # Они используют свои индексы pFunQt (прокси дочернего класса), поэтому
        # нужны как override — иначе D выдаёт ошибку "cannot implicitly override".
        ov = "override " if self.d_parent else ""

        L = [
            f"    // ── Event handlers ──────────────────────────────────────────────────────",
            f"    /// Установить callback для Qt-события по EventId.",
            f"    /// cb и dthis можно передавать null для отмены обработки.",
            f"    {ov}{cls} setEventHandler(int eventId, void* cb, void* dthis = null) {{",
            f"        (cast(t_v__qp_i_qp_qp)pFunQt[{idx}])(_wh, eventId, cb, dthis);",
            f"        return this;",
            f"    }}",
            f"",
        ]

        for ev_name, spec in EVENT_SPECS.items():
            method_name = EVENT_D_METHOD[ev_name]
            ev_id       = spec.id
            d_params    = spec.d_params  # [(d_type, param_name), ...]

            # Ожидаемая сигнатура callback (для документации):
            if d_params:
                fp_doc = "void* dthis, " + ", ".join(f"{dt} {pn}" for dt, pn in d_params)
            else:
                fp_doc = "void* dthis"

            # cb передаётся как void* (как в ESlot.set()).
            # Пользователь передаёт: cast(void*)&myCallback
            # Ожидаемая сигнатура callback: extern(C) void function({fp_doc})
            L += [
                f"    /// Qt event: {ev_name}",
                f"    /// cb: extern(C) void function({fp_doc})",
                f"    {ov}{cls} {method_name}(void* cb, void* dthis = null) {{",
                f"        setEventHandler({ev_id}, cb, dthis);",
                f"        return this;",
                f"    }}",
                f"",
            ]

        return L

    # ──────────────────────────────────────────────────────────────────────
    # Секция 3: class wrapper

    def _gen_class(self) -> list:
        cls = self.cls_name
        is_child = bool(self.d_parent)
        has_sig  = bool(self.signals)

        # ── Заголовок класса и поля ──────────────────────────────────────
        if is_child:
            L = [
                f"/// D wrapper for Qt class {cls}.",
                f"@live class {cls} : {self.d_parent} {{",
                f"public:",
                f"    /// Create {cls}. parent must be explicitly passed (null for top-level).",
                f"    this(void* parent) {{",
                f"        super(true);",
                f"        _qt_owned = (parent !is null);",
                f"        _wh = (cast(t_qp__qp)pFunQt[{self.ctor_idx}])(parent);",
                f"    }}",
                f"",
                f"    /// No-op constructor for super() calls from child classes.",
                f"    protected this(bool _noOp) {{ super(_noOp); }}",
                f"    /// Wrap an existing Qt-owned {cls}* (e.g. from QUiLoader or findChild).",
                f"    /// The D object does NOT delete the Qt pointer — Qt owns it.",
                f"    static {cls} wrap(void* wh) {{",
                f"        auto w = new {cls}(true);",
                f"        w._wh = wh;",
                f"        w._qt_owned = true;",
                f"        return w;",
                f"    }}",
            ]
        else:
            L = [
                f"/// D wrapper for Qt class {cls}.",
                f"@live class {cls} {{",
                f"private:",
                f"    void* _wh;",
                f"    bool  _qt_owned;",
                f"",
                f"public:",
                f"    /// Create {cls}. parent=null → top-level widget.",
                f"    this(void* parent = null) {{",
                f"        _qt_owned = (parent !is null);",
                f"        _wh = (cast(t_qp__qp)pFunQt[{self.ctor_idx}])(parent);",
                f"    }}",
                f"",
                f"    /// No-op constructor for super() calls from child classes.",
                f"    /// Child classes set _wh themselves after calling super().",
                f"    protected this(bool _noOp) {{}}",
                f"    /// Wrap an existing Qt-owned {cls}* — the D object does NOT delete it.",
                f"    static {cls} wrap(void* wh) {{",
                f"        auto w = new {cls}(true);",
                f"        w._wh = wh;",
                f"        w._qt_owned = true;",
                f"        return w;",
                f"    }}",
            ]

        # ── Конструктор с текстом (если есть) ────────────────────────────
        if self.has_text_ctor and self.text_ctor_idx:
            if is_child:
                L += [
                    f"",
                    f"    /// Create {cls} with initial text.",
                    f"    this(string text, void* parent = null) {{",
                    f"        super(true);",
                    f"        import std.utf : toUTF16;",
                    f"        _qt_owned = (parent !is null);",
                    f"        wstring _ws = text.toUTF16;",
                    f"        _wh = (cast(t_qp__qp_i_qp)pFunQt[{self.text_ctor_idx}])(",
                    f"            cast(void*)_ws.ptr, cast(int)_ws.length, parent);",
                    f"    }}",
                ]
            else:
                L += [
                    f"",
                    f"    /// Create {cls} with initial text.",
                    f"    this(string text, void* parent = null) {{",
                    f"        import std.utf : toUTF16;",
                    f"        _qt_owned = (parent !is null);",
                    f"        wstring _ws = text.toUTF16;",
                    # create_text: void* function(void* wstr, int len, void* parent)
                    # alias: qp__qp_i_qp
                    f"        _wh = (cast(t_qp__qp_i_qp)pFunQt[{self.text_ctor_idx}])(",
                    f"            cast(void*)_ws.ptr, cast(int)_ws.length, parent);",
                    f"    }}",
                ]

        # ── Деструктор (только для корневых классов; дети наследуют) ─────
        if not is_child:
            L += [
                f"",
                f"    ~this() {{",
                f"        if (!_qt_owned && _wh !is null && pFunQt[{self.dtor_idx}] !is null) {{",
                f"            (cast(t_v__qp)pFunQt[{self.dtor_idx}])(_wh);",
                f"            _wh = null;",
                f"        }}",
                f"    }}",
                f"",
            ]
        else:
            L.append(f"")

        # ── Методы ───────────────────────────────────────────────────────
        # D-имена: перегрузки с одинаковой D-сигнатурой (например
        # contains(QPoint)/contains(QPointF) → оба contains(void*)) получают
        # суффикс из func_name (contains_pt / contains_pf) — иначе D-конфликт.
        from collections import defaultdict as _dd
        def _d_sig_types(_s):
            """D-типы сигнатуры (без имён параметров) — ключ коллизии перегрузок."""
            _out = []
            for _p in _s.params:
                _t = _p.cpp_type.strip()
                if _is_qstring(_t):
                    _out.append("string")
                elif _t == "bool":
                    _out.append("bool")
                elif _is_qt_enum(_t):
                    _out.append("int")
                elif _t in ("int", "unsigned int", "uint", "short", "long"):
                    _out.append("int")
                elif _t in ("double", "qreal"):
                    _out.append("double")
                elif _t == "float":
                    _out.append("float")
                else:
                    _out.append("void*")
            return (_public_ret_d(_s.ret_d), tuple(_out))

        _groups = _dd(list)
        for _s in self.method_specs:
            _groups[_s.qt_name].append(_s)
        _d_names = {}
        for _name, _grp in _groups.items():
            if len(_grp) == 1:
                _d_names[id(_grp[0])] = _name
                continue
            _seen = {}
            for _s in _grp:
                _sig = _d_sig_types(_s)
                if _sig in _seen:
                    _pfx = f"qte{cls}_{_name}"
                    _d_names[id(_s)] = _name + _s.func_name[len(_pfx):]
                    _first = _seen[_sig]
                    if _d_names.get(id(_first)) == _name:
                        _d_names[id(_first)] = _name + _first.func_name[len(_pfx):]
                else:
                    _seen[_sig] = _s
                    _d_names[id(_s)] = _name

        for s in self.method_specs:
            d_name = _d_names.get(id(s), s.qt_name)
            alias_k = _alias_key(s.ret_d, s.params)
            d_params = _d_param_decl(s.params)
            body_lines = _d_method_body(s.idx, alias_k, s.ret_d, s.params)

            # Map internal generator return types to D types in method signature
            d_ret = _public_ret_d(s.ret_d)
            # Chain-возврат: void-методы возвращают this (fluent-вызовы)
            chain_ret = cls if d_ret == "void" else d_ret
            if d_ret == "void":
                body_lines = body_lines + ["return this;"]

            # D builtins that need 'override' when declared in a D class
            _d_override = "override " if s.qt_name in ("toString",) else ""
            L.append(f"    /// {s.qt_name}")
            if d_params:
                L.append(f"    {_d_override}{chain_ret} {d_name}({d_params}) {{")
            else:
                L.append(f"    {_d_override}{chain_ret} {d_name}() {{")

            if len(body_lines) == 1:
                L.append(f"        {body_lines[0]}")
            else:
                for bl in body_lines:
                    L.append(f"        {bl}")

            L += ["    }", ""]

            # ── Typed ownership overload (если метод передаёт Qt ownership) ──
            if s.qt_name in OWNERSHIP_METHODS:
                kind = OWNERSHIP_METHODS[s.qt_name]
                pi = _ownership_param_idx(s.params, kind)
                if pi >= 0:
                    L += _gen_ownership_overload(s, pi, kind, cls)

        # ── Сигналы ──────────────────────────────────────────────────────
        if has_sig:
            from collections import Counter
            # Строим индекс lambda-connect по имени сигнала для быстрого поиска
            lc_by_name = {lc["sig_name"]: lc for lc in self.lambda_connect_specs}

            sig_name_counts = Counter(
                m.name for m in self.signals if _signal_invoke(m) is not None
            )
            for m in self.signals:
                info = _signal_invoke(m)
                if info is None:
                    L.append(f"    // Signal {m.name} — unsupported parameter types")
                    continue

                cname = f"connect_{m.name}"
                if sig_name_counts[m.name] > 1:
                    # Устраняем неоднозначность перегруженных сигналов
                    qt_sig = info["qt_sig"]
                    if "QString" in qt_sig:
                        cname += "_s"
                    elif "int" in qt_sig:
                        cname += "_i"
                    elif "double" in qt_sig:
                        cname += "_d"
                    elif "bool" in qt_sig:
                        cname += "_b"
                    else:
                        cname += "_v"

                if info.get("use_lambda"):
                    # Lambda-connect: Qt-pointer сигнал.
                    # C++ функция qteQFoo_connect_bar(w, cb, dthis) захватывает
                    # указатель лямбдой и передаёт D-callback как void*.
                    lc = lc_by_name.get(m.name)
                    if lc is None:
                        L.append(f"    // Signal {m.name} — lambda-connect idx missing")
                        continue
                    idx = lc["idx"]
                    invoke_kind = info["invoke"]  # "lambda" или "lambda2"
                    if invoke_kind == "lambda2":
                        # Два Qt-указателя → DSlot_ptr2
                        L += [
                            f"    /// Connect signal {m.name} → прямой callback (два void*)",
                            f"    /// cb: extern(C) void function(void* dthis, int n, void* p0, void* p1)",
                            f"    {cls} {cname}(void* cb, void* dthis = null) {{",
                            f"        (cast(t_v__qp_qp_qp)pFunQt[{idx}])(_wh, cb, dthis);",
                            f"        return this;",
                            f"    }}",
                            f"",
                        ]
                    else:
                        # Один Qt-указатель → DSlot_ptr
                        L += [
                            f"    /// Connect signal {m.name} → прямой callback (DSlot_ptr)",
                            f"    /// cb: extern(C) void function(void* dthis, int n, void* ptr)",
                            f"    {cls} {cname}(void* cb, void* dthis = null) {{",
                            f"        (cast(t_v__qp_qp_qp)pFunQt[{idx}])(_wh, cb, dthis);",
                            f"        return this;",
                            f"    }}",
                            f"",
                        ]
                else:
                    # Обычный eSlot-based сигнал
                    L += [
                        f"    /// Connect signal {m.name} → ESlot",
                        f"    {cls} {cname}(ESlot eslot) {{",
                        f'        connectQt(_wh, "{info["qt_sig"]}", eslot, "{info["invoke"]}");',
                        f"        return this;",
                        f"    }}",
                        f"",
                    ]

        # ── Event handlers (onMousePress, onResize, ...) ─────────────────
        L += self._gen_event_methods()

        # ── Manual methods area ───────────────────────────────────────────
        # Сюда можно вставлять ручные методы — они сохранятся при --patch.
        L += [
            f"    // ===MANUAL-METHODS-START===",
            f"    // ===MANUAL-METHODS-END===",
            f"",
        ]

        # ── Закрытие класса ───────────────────────────────────────────────
        if not is_child:
            # Корневой класс: disown / qtOwned / getWH определены здесь
            L += [
                f"    /// Mark as Qt-owned. Typed overloads (addWidget, setLayout, etc.)",
                f"    /// call disown() automatically. For void* API — call manually.",
                f"    void disown()  {{ _qt_owned = true; }}",
                f"    /// True when Qt owns the lifetime.",
                f"    bool qtOwned() {{ return _qt_owned; }}",
                f"    /// Raw Qt object pointer.",
                f"    void* getWH()  {{ return _wh; }}",
                f"",
                f"}} // class {cls}",
            ]
        else:
            # Дочерний класс: disown / qtOwned / getWH унаследованы
            L.append(f"}} // class {cls}")

        return L

    # ──────────────────────────────────────────────────────────────────────
    # Сборка

    # Маркеры для инкрементального обновления (--patch).
    # Содержимое между START/END заменяется генератором; вне маркеров можно
    # вносить ручные правки — они сохранятся при --patch.
    MARKER_LOAD_START = "// ===AUTO-GENERATED-LOAD-FUNC-START==="
    MARKER_LOAD_END   = "// ===AUTO-GENERATED-LOAD-FUNC-END==="
    MARKER_CLASS_START = "// ===AUTO-GENERATED-CLASS-START==="
    MARKER_CLASS_END   = "// ===AUTO-GENERATED-CLASS-END==="

    def generate_all(self) -> str:
        cls = self.cls_name
        parts = [
            f"/**",
            f" * gen_{cls.lower()}.d — GENERATED wrapper for {cls}.",
            f" * Module: {self.module_name}  |  DLL: {self.dll_file}",
            f" * DO NOT EDIT MANUALLY — regenerate with generator/main.py",
            f" * Use --patch to update only generated sections while keeping manual edits.",
            f" */",
        ]

        # GENERATOR-INFO: рабочая информация запуска (вне AUTO-GENERATED
        # маркеров — при --patch сохраняется информация о последней ПОЛНОЙ
        # генерации)
        if self.gen_info:
            from geninfo import _render_info_block
            parts.append(_render_info_block(self.gen_info))

        parts += self._gen_imports()

        parts += [
            f"// {'=' * 68}",
            f"// Load function addresses at runtime (call after LoadQt)",
            f"// {'=' * 68}",
            self.MARKER_LOAD_START,
            f"",
        ]
        parts += self._gen_load_func()
        parts += [
            self.MARKER_LOAD_END,
            f"",
        ]

        parts += [
            f"// {'=' * 68}",
            f"// Class wrapper",
            f"// {'=' * 68}",
            self.MARKER_CLASS_START,
            f"",
        ]
        parts += self._gen_class()
        parts += [
            self.MARKER_CLASS_END,
            f"",
        ]

        return "\n".join(parts)
