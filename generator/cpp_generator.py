"""
cpp_generator.py — генерация C++ wrapper файлов для Qt класса.

Генерирует:
  qte56_qXxx.h   — extern "C" объявления
  qte56_qXxx.cpp — реализации
  qte56_qXxx.pro — Qt project file

Стратегия маппинга типов:
  QString / const QString& param → const wchar_t* name, int name_len
  QString return                 → void* (heap allocated new QString)
  bool param                     → int (0 = false, else true)
  bool return                    → int (0/1)
  Q* param                       → void* (cast at call site)
  Qt::Xxx enum / QFlags          → int (cast at call site)
  int / double / float           → passthrough
"""

from dataclasses import dataclass
from typing import Optional
import os

from qt_parser import QtParam, QtMethod
from knowledge_access import get_knowledge


# ─────────────────────────────────────────────────────────────────────────────
# Вспомогательные функции маппинга типов

def _norm_type(t: str) -> str:
    """Нормализация типа для запросов к knowledge: без const/& и пробелов."""
    return t.replace("const ", "").replace("&", "").replace("*", "").strip()

def _is_qstring(t: str) -> bool:
    n = t.replace("const ", "").replace("&", "").strip()
    return n == "QString"


def _is_qptr(t: str) -> bool:
    """True для Q-объектов, передаваемых как указатели."""
    n = t.strip()
    # Любой Q...* (с const или без)
    if n.startswith("Q") and n.endswith("*"):
        return True
    if n.startswith("const Q") and n.endswith("*"):
        return True
    return False


def _is_qt_enum(t: str) -> bool:
    """True для Qt::Xxx, QFlags и вложенных enum-типов (EchoMode, InsertPolicy и т.д.)."""
    import re
    n = t.strip()
    # Точная проверка по базе знаний (qualified и unqualified формы)
    kb = get_knowledge()
    if kb is not None and kb.is_enum(_norm_type(n)):
        return True
    if n.startswith("Qt::") or "Flags" in n or "::" in n:
        return True
    # Одиночный CamelCase идентификатор без Q-префикса — вложенный enum (EchoMode и т.д.)
    # Типы с Q-префиксом — Qt value-типы, а не enum-ы → не является enum-ом
    if re.match(r'^[A-Z][A-Za-z0-9]+$', n) and not n.startswith("Q"):
        return True
    return False


def _is_value_by_ref(t: str) -> bool:
    """True для Qt value-типов, передаваемых по ссылке (const QPoint& и т.д.)."""
    n = t.replace("const ", "").replace("&", "").strip()
    # Точная проверка по базе знаний: все Qt value-типы (не QObject-наследники)
    kb = get_knowledge()
    if kb is not None and kb.is_value_type(n):
        return True
    return n in ("QPoint", "QSize", "QRect", "QFont", "QColor")


def _is_int_ptr(t: str) -> bool:
    """True для int*, const int* — out-параметры."""
    n = t.strip()
    return n in ("int*", "const int*", "int *")


def _cpp_param_list(params: list) -> list:
    """
    Возвращает список (cpp_decl_type, param_name) для C wrapper.
    void* w — первый параметр НЕ включается (добавляется отдельно).
    Для QString возвращает два элемента: wchar_t* и int.
    """
    result = []
    for p in params:
        t = p.cpp_type.strip()

        if _is_qstring(t):
            result.append(("const wchar_t*", p.name))
            result.append(("int", f"{p.name}_len"))
        elif t == "bool":
            result.append(("int", p.name))
        elif _is_qt_enum(t):
            result.append(("int", p.name))
        elif _is_qptr(t):
            result.append(("void*", p.name))
        elif _is_value_by_ref(t):
            # QPoint&, QSize&, QRect& — передаём как void* (caller передаёт указатель)
            result.append(("void*", p.name))
        elif _is_int_ptr(t):
            # int* out-параметр — передаём как void* (caller передаёт &int)
            result.append(("void*", p.name))
        elif t in ("int", "unsigned int", "uint", "short", "long", "unsigned long"):
            result.append(("int", p.name))
        elif t in ("size_t", "intptr_t", "WId"):
            result.append(("intptr_t", p.name))
        elif t in ("double", "qreal"):
            result.append(("double", p.name))
        elif t == "float":
            result.append(("float", p.name))
        elif t in ("qint64", "qlonglong"):
            result.append(("long long", p.name))
        elif t in ("quint64", "qulonglong"):
            result.append(("unsigned long long", p.name))
        elif t == "const char*":
            result.append(("const char*", p.name))
        else:
            # Неизвестный тип — передаём как void*
            result.append(("void*", p.name))
    return result


def _cpp_ret_type(ret_d: str) -> str:
    """Маппинг D-типа возврата → C++ тип возврата."""
    MAP = {
        "void":   "void",
        "int":    "int",
        "uint":   "unsigned int",
        "bool":   "int",
        "double": "double",
        "float":  "float",
        "long":   "long long",
        "ulong":  "unsigned long long",
        "size_t": "intptr_t",  # pointer-sized (WId etc.)
        "string": "void*",     # QString → heap allocated
        "void*":  "void*",
        # Qt value types: heap-allocated pointer
        "DSize":   "void*",
        "DPoint":  "void*",
        "DRect":   "void*",
        "QFont_v": "void*",    # new QFont(...)
        "QColor_v":"void*",    # new QColor(...)
    }
    result = MAP.get(ret_d)
    if result is not None:
        return result
    # Любой <Type>_v — heap-allocated value type (QPointF_v, QRectF_v, ...)
    if ret_d.endswith("_v"):
        return "void*"
    return "void*"


def _cpp_call_args(params: list, cls_name: str = "") -> str:
    """Строит аргументы для вызова Qt-метода (из C wrapper параметров).
    cls_name — имя Qt класса (QLineEdit, QWidget и т.д.) для квалификации
    вложенных enum-типов: ActionPosition → QLineEdit::ActionPosition.
    """
    args = []
    for p in params:
        t = p.cpp_type.strip()

        if _is_qstring(t):
            args.append(f"QString::fromWCharArray({p.name}, {p.name}_len)")
        elif t == "bool":
            args.append(f"({p.name} != 0)")
        elif _is_value_by_ref(t):
            # void* → разыменовываем как value-type по ссылке
            base = t.replace("const ", "").replace("&", "").strip()
            args.append(f"*(const {base}*){p.name}")
        elif _is_int_ptr(t):
            # void* → кастуем в int*
            args.append(f"(int*){p.name}")
        elif _is_qt_enum(t):
            # Если тип не квалифицирован (нет ::) и передан cls_name —
            # добавляем квалификатор: ActionPosition → QLineEdit::ActionPosition
            if "::" not in t and cls_name:
                # Точное разрешение через knowledge: enum может принадлежать
                # ДРУГОМУ классу (тогда {cls_name}::{t} не скомпилируется).
                kb = get_knowledge()
                resolved = kb.resolve_enum(_norm_type(t)) if kb is not None else []
                if len(resolved) == 1:
                    args.append(f"({resolved[0]}){p.name}")
                else:
                    # Неоднозначно или нет knowledge — прежнее поведение
                    args.append(f"({cls_name}::{t}){p.name}")
            else:
                args.append(f"({t}){p.name}")
        elif _is_qptr(t):
            args.append(f"({t}){p.name}")
        else:
            args.append(p.name)
    return ", ".join(args)


def _cpp_method_body(cpp_class: str, method_name: str, ret_d: str, params: list) -> str:
    """Генерирует тело C++ wrapper функции."""
    args = _cpp_call_args(params, cpp_class)
    call = f"(({cpp_class}*)_obj)->{method_name}({args})"

    if ret_d == "void":
        return f"    {call};\n"
    elif ret_d == "bool":
        return f"    return {call} ? 1 : 0;\n"
    elif ret_d == "string":
        return f"    return new QString({call});\n"
    elif ret_d == "void*":
        return f"    return (void*){call};\n"
    elif ret_d == "DSize":
        return f"    return new QSize({call});\n"
    elif ret_d == "DPoint":
        return f"    return new QPoint({call});\n"
    elif ret_d == "DRect":
        return f"    return new QRect({call});\n"
    elif ret_d == "QFont_v":
        return f"    return new QFont({call});\n"
    elif ret_d == "QColor_v":
        return f"    return new QColor({call});\n"
    elif ret_d.endswith("_v"):
        # Обобщённый heap-allocated value type: QPointF_v, QRectF_v, ...
        base = ret_d[:-2]
        return f"    return new {base}({call});\n"
    else:
        return f"    return {call};\n"


# ─────────────────────────────────────────────────────────────────────────────
# Генерация .h файла

def generate_h(cls_name: str, specs: list, macro: str) -> str:
    """
    specs — список MethodSpec объектов (из main.py).
    macro — имя макроса видимости, напр. "QLABEL_API".
    """
    lines = [
        f"#pragma once",
        f"#include <cstdint>",
        f"",
        f"// ─── Export macro ─────────────────────────────────────────────────────────────",
        f"#ifdef _WIN32",
        f"  #ifdef QTE56_{cls_name.upper()}_BUILD",
        f"    #define {macro} __declspec(dllexport)",
        f"  #else",
        f"    #define {macro} __declspec(dllimport)",
        f"  #endif",
        f"#else",
        f"  #define {macro} __attribute__((visibility(\"default\")))",
        f"#endif",
        f"",
        f"extern \"C\" {{",
        f"",
    ]

    for s in specs:
        # Полная сигнатура параметров: void* _obj + специфичные
        # Используем _obj вместо w, чтобы избежать конфликта с Qt-параметрами
        # (например, setGeometry(int x, int y, int w, int h) имеет параметр w)
        cpp_params = _cpp_param_list(s.params)
        ret_cpp = _cpp_ret_type(s.ret_d)

        param_str = "void* _obj"
        if cpp_params:
            param_str += ", " + ", ".join(f"{ct} {cn}" for ct, cn in cpp_params)

        lines.append(f"{macro} {ret_cpp} {s.func_name}({param_str});")

    lines += [
        f"",
        f"}} // extern \"C\"",
        f"",
    ]
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Генерация .cpp файла

def generate_cpp(cls_name: str, specs: list, qt_includes: list = None) -> str:
    """
    qt_includes — список Qt-заголовков без <>, напр. ["QLabel", "QString"]
    """
    if qt_includes is None:
        qt_includes = [cls_name, "QString"]
    elif "QString" not in qt_includes:
        qt_includes = list(qt_includes) + ["QString"]

    macro = f"QTE56_{cls_name.upper()}_BUILD"
    h_file = f"qte56_{cls_name.lower()}.h"

    lines = [
        f"#define {macro}",
        f"#include \"{h_file}\"",
        f"#include <cstdint>",
    ]
    for inc in qt_includes:
        lines.append(f"#include <{inc}>")

    lines += [
        f"",
        f"extern \"C\" {{",
        f"",
    ]

    for s in specs:
        cpp_params = _cpp_param_list(s.params)
        ret_cpp = _cpp_ret_type(s.ret_d)

        param_str = "void* _obj"
        if cpp_params:
            param_str += ", " + ", ".join(f"{ct} {cn}" for ct, cn in cpp_params)

        lines.append(f"{ret_cpp} {s.func_name}({param_str}) {{")
        lines.append(_cpp_method_body(cls_name, s.qt_name, s.ret_d, s.params).rstrip("\n"))
        lines.append("}")
        lines.append("")

    lines += [
        f"}} // extern \"C\"",
        f"",
    ]
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Генерация .pro файла

def generate_pro(cls_name: str, qt_modules: str = "core widgets") -> str:
    name_lower = cls_name.lower()
    macro = f"QTE56_{cls_name.upper()}_BUILD"
    lines = [
        f"QT       += {qt_modules}",
        f"TARGET    = qte56_{name_lower}",
        f"TEMPLATE  = lib",
        f"CONFIG   += shared c++11",
        f"CONFIG   -= debug_and_release",
        f"DEFINES  += {macro}",
        f"DESTDIR   = ../../dll",
        f"SOURCES   = qte56_{name_lower}.cpp",
        f"HEADERS   = qte56_{name_lower}.h",
        f"",
    ]
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Генерация event proxy-класса (eQFoo) и setEventHandler

def generate_event_proxy(cls_name: str, has_text_ctor: bool = False) -> str:
    """
    Генерирует C++ proxy-класс eQFoo и функцию qteQFoo_setEventHandler.
    Вставляется в .cpp ПЕРЕД блоком extern "C".

    Proxy переопределяет все 17 Qt-событий. Если callback не установлен —
    вызывается базовая реализация (Qt-поведение по умолчанию).
    """
    from events import EVENT_SPECS

    proxy = f"e{cls_name}"
    lines = [
        f"// ─── Event proxy ──────────────────────────────────────────────────────────────",
        f"class {proxy} : public {cls_name} {{",
        f"public:",
    ]

    # Поля: (cb, dthis) на каждое событие
    for ev_name, spec in EVENT_SPECS.items():
        lines.append(
            f"    void* cb_{spec.id:02d} = nullptr;  "
            f"void* dt_{spec.id:02d} = nullptr;  "
            f"// {spec.id}: {ev_name}"
        )

    lines.append(f"")

    # Конструкторы
    lines.append(f"    explicit {proxy}(QWidget* parent = nullptr) : {cls_name}(parent) {{}}")
    if has_text_ctor:
        lines.append(
            f"    explicit {proxy}(const QString& text, QWidget* parent = nullptr)"
            f" : {cls_name}(text, parent) {{}}"
        )

    lines += [f"", f"protected:"]

    # Override метода для каждого события
    for ev_name, spec in EVENT_SPECS.items():
        ev_id = spec.id
        qt_t  = spec.qt_type
        ext   = spec.cpp_extract
        cast  = spec.cb_cast

        if ext == "CLOSE_SPECIAL":
            # closeEvent: D может отменить закрытие через int* accept
            lines += [
                f"    void {ev_name}({qt_t}* e) override {{",
                f"        if (cb_{ev_id:02d}) {{",
                f"            int accept = 1;",
                f"            (({cast})cb_{ev_id:02d})(dt_{ev_id:02d}, &accept);",
                f"            if (!accept) e->ignore();",
                f"        }} else {{",
                f"            {cls_name}::{ev_name}(e);",
                f"        }}",
                f"    }}",
            ]
        elif not ext:
            # Нет параметров кроме dthis
            lines += [
                f"    void {ev_name}({qt_t}* e) override {{",
                f"        if (cb_{ev_id:02d}) (({cast})cb_{ev_id:02d})(dt_{ev_id:02d});",
                f"        else {cls_name}::{ev_name}(e);",
                f"    }}",
            ]
        else:
            # Обычное событие с параметрами
            lines += [
                f"    void {ev_name}({qt_t}* e) override {{",
                f"        if (cb_{ev_id:02d}) (({cast})cb_{ev_id:02d})(dt_{ev_id:02d}, {ext});",
                f"        else {cls_name}::{ev_name}(e);",
                f"    }}",
            ]

    lines += [f"}};", f""]
    return "\n".join(lines)


def generate_sethandler_h_line(cls_name: str, macro: str) -> str:
    """Строка объявления setEventHandler для .h файла."""
    return (
        f"{macro} void qte{cls_name}_setEventHandler"
        f"(void* w, int id, void* cb, void* dthis);"
    )


def generate_sethandler_cpp(cls_name: str) -> str:
    """Реализация setEventHandler для .cpp файла."""
    from events import EVENT_SPECS

    proxy = f"e{cls_name}"
    lines = [
        f"void qte{cls_name}_setEventHandler(void* w, int id, void* cb, void* dthis) {{",
        f"    {proxy}* obj = ({proxy}*)w;",
        f"    switch (id) {{",
    ]
    for ev_name, spec in EVENT_SPECS.items():
        ev_id = spec.id
        lines.append(
            f"        case {ev_id:2d}: obj->cb_{ev_id:02d} = cb; obj->dt_{ev_id:02d} = dthis; break;"
            f"  // {ev_name}"
        )
    lines += [
        f"        default: break;",
        f"    }}",
        f"}}",
        f"",
    ]
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Запись файлов

def write_cpp_files(cls_name: str, specs: list, out_dir: str,
                    qt_includes: list = None, qt_modules: str = "core widgets"):
    """Записывает .h, .cpp, .pro в out_dir."""
    os.makedirs(out_dir, exist_ok=True)
    macro = f"Q{cls_name.upper()}_API"
    name_lower = cls_name.lower()

    h_path   = os.path.join(out_dir, f"qte56_{name_lower}.h")
    cpp_path = os.path.join(out_dir, f"qte56_{name_lower}.cpp")
    pro_path = os.path.join(out_dir, f"qte56_{name_lower}.pro")

    with open(h_path,   "w", encoding="utf-8") as f:
        f.write(generate_h(cls_name, specs, macro))
    with open(cpp_path, "w", encoding="utf-8") as f:
        f.write(generate_cpp(cls_name, specs, qt_includes))
    with open(pro_path, "w", encoding="utf-8") as f:
        f.write(generate_pro(cls_name, qt_modules))

    return h_path, cpp_path, pro_path
