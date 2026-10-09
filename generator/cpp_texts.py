"""
cpp_texts.py — генерация текстов C++ wrapper-файлов (.h / .cpp / .pro).

Выделено из main.py (_generate_cpp_texts + _write_cpp_with_lifecycle).
Низкоуровневые примитивы (списки параметров, тела методов, event-proxy,
sethandler) берутся из cpp_generator.py.
"""

import os

from geninfo import _render_info_block


# ─────────────────────────────────────────────────────────────────────────────
# Примитивы для одной функции (используются и в _generate_cpp_texts,
# и в режиме --augment для сниппетов только новых методов)

def _method_h_line(cls_name, macro, s) -> str:
    """Строка объявления метода в .h."""
    from cpp_generator import _cpp_param_list, _cpp_ret_type
    cpp_params = _cpp_param_list(s.params)
    ret_cpp    = _cpp_ret_type(s.ret_d)
    param_str  = "void* _obj"   # _obj избегает конфликта с Qt-параметрами (например w в setGeometry)
    if cpp_params:
        param_str += ", " + ", ".join(f"{ct} {cn}" for ct, cn in cpp_params)
    return f"{macro} {ret_cpp} {s.func_name}({param_str});"


def _method_cpp_lines(cls_name, s) -> list:
    """Строки реализации метода в .cpp (с завершающей пустой строкой)."""
    from cpp_generator import _cpp_param_list, _cpp_ret_type, _cpp_method_body
    cpp_params = _cpp_param_list(s.params)
    ret_cpp    = _cpp_ret_type(s.ret_d)
    param_str  = "void* _obj"
    if cpp_params:
        param_str += ", " + ", ".join(f"{ct} {cn}" for ct, cn in cpp_params)
    body = _cpp_method_body(cls_name, s.qt_name, s.ret_d, s.params)
    return [
        f"{ret_cpp} {s.func_name}({param_str}) {{",
        body.rstrip("\n"),
        "}",
        "",
    ]


def _lambda_h_line(macro, lc) -> str:
    """Объявление lambda-connect функции в .h."""
    return f"{macro} void {lc['func_name']}(void* w, void* cb, void* dthis);"


def _lambda_cpp_lines(cls_name, lc) -> list:
    """Реализация lambda-connect функции в .cpp (с завершающей пустой строкой)."""
    invoke  = lc["invoke"]   # "lambda" или "lambda2"
    fn      = lc["func_name"]
    cpp_raw = lc["cpp_raw"]
    qt_sig  = lc["qt_sig"]   # для комментария

    lines = [f"// Signal: {qt_sig}"]
    lines.append(f"void {fn}(void* w, void* cb, void* dthis) {{")
    if invoke == "lambda2":
        # Два Qt-pointer параметра: p0 и p1
        t0, t1 = cpp_raw
        # Используем &cls::signal с двумя параметрами
        sig_name = lc["sig_name"]
        lines.append(
            f"    QObject::connect(({cls_name}*)w, &{cls_name}::{sig_name},"
        )
        lines.append(
            f"        [cb, dthis]({t0} p0, {t1} p1) {{"
        )
        lines.append(
            f"            if (cb) ((void(*)(void*,int,void*,void*))cb)(dthis, 0, (void*)p0, (void*)p1);"
        )
        lines.append(f"        }});")
    else:
        # Один Qt-pointer параметр (или value type ref)
        t0 = cpp_raw
        sig_name = lc["sig_name"]
        # Value-type references (QFont, QColor) need heap-allocated copy
        base_t0 = t0.replace("const ", "").replace("&", "").strip()
        _VALUE_TYPES = {"QFont", "QColor"}
        is_value_ref = (base_t0 in _VALUE_TYPES)

        lines.append(
            f"    QObject::connect(({cls_name}*)w, &{cls_name}::{sig_name},"
        )
        lines.append(
            f"        [cb, dthis]({t0} p) {{"
        )
        if is_value_ref:
            lines.append(
                f"            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, new {base_t0}(p));"
            )
        else:
            lines.append(
                f"            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)p);"
            )
        lines.append(f"        }});")
    lines.append(f"}}")
    lines.append(f"")
    return lines



def _generate_cpp_texts(cls_name, specs, ctor_idx, dtor_idx,
                         has_text_ctor, text_ctor_idx,
                         qt_modules,
                         has_events: bool = False,
                         lambda_connect_specs: list = None,
                         tracked: bool | None = None,
                         gen_info: dict | None = None) -> dict[str, str]:
    """
    Генерирует тексты .h, .cpp, .pro, включая create/delete и create_text.
    Возвращает dict {"h": ..., "cpp": ..., "pro": ...}.
    tracked — QObject-наследник (lifecycle qte_createTracked); None → вычислить.
    gen_info — блок GENERATOR-INFO (см. geninfo._build_gen_info).
    """
    from cpp_generator import _cpp_param_list, _cpp_ret_type, _cpp_method_body

    # cls_name = "QLabel" → name_lower = "qlabel", macro = "QLABEL_API"
    name_lower = cls_name.lower()
    macro      = f"{cls_name.upper()}_API"     # QLABEL_API (не QQLABEL_API)
    build_def  = f"QTE56_{cls_name.upper()}_BUILD"

    # ─── .h ─────────────────────────────────────────────────────────────
    h_lines = [
        f"#pragma once",
        f"",
        f"#ifdef _WIN32",
        f"  #ifdef {build_def}",
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
        f"// ── Lifecycle ────────────────────────────────────────────────────────────",
        f"{macro} void* qte{cls_name}_create(void* parent);",
        f"{macro} void  qte{cls_name}_delete(void* w);",
    ]
    if has_text_ctor:
        h_lines.append(
            f"{macro} void* qte{cls_name}_create_text(const wchar_t* text, int len, void* parent);"
        )
    h_lines.append("")

    if specs:
        h_lines.append("// ── Methods ──────────────────────────────────────────────────────────────")

    for s in specs:
        h_lines.append(_method_h_line(cls_name, macro, s))

    # Добавляем объявление setEventHandler в .h если есть события
    if has_events:
        from cpp_generator import generate_sethandler_h_line
        h_lines.append("")
        h_lines.append("// ── Event handler ────────────────────────────────────────────────────────────")
        h_lines.append(generate_sethandler_h_line(cls_name, macro))

    # Lambda-connect объявления: qteQFoo_connect_bar(void* w, void* cb, void* dthis)
    if lambda_connect_specs:
        h_lines.append("")
        h_lines.append("// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────")
        for lc in lambda_connect_specs:
            h_lines.append(_lambda_h_line(macro, lc))

    h_lines += [f"", f"}} // extern \"C\"", f""]

    h_text = "\n".join(h_lines)
    if gen_info:
        h_text = _render_info_block(gen_info) + "\n" + h_text

    # ─── .cpp ────────────────────────────────────────────────────────────
    # Определяем тип создаваемого объекта (proxy или оригинал)
    create_type = f"e{cls_name}" if has_events else cls_name

    # Lifecycle-tracking для QObject-наследников: create оборачивается в
    # qte_createTracked() (см. cpp/qt5/qte56_qobject/qte56_lifecycle.h).
    # Точная проверка по базе знаний; fallback — has_events (виджет => QObject).
    if tracked is None:
        from knowledge_access import get_knowledge as _get_kb
        _kb = _get_kb()
        tracked = _kb.is_qobject_subclass(cls_name) if _kb is not None else has_events

    # Определяем дополнительные #include для lambda-connect Qt-pointer типов.
    # Извлекаем имена классов из cpp_raw (например "QAction *" → "QAction").
    lc_includes = set()
    if lambda_connect_specs:
        import re as _re
        for lc in lambda_connect_specs:
            raw = lc["cpp_raw"]
            if isinstance(raw, tuple):
                raws = list(raw)
            else:
                raws = [raw]
            for r in raws:
                m = _re.match(r'^(Q[A-Za-z]+)', r.strip())
                if m:
                    lc_includes.add(m.group(1))

    # Базовые includes
    cpp_lines = [
        f"#define {build_def}",
        f"#include \"qte56_{name_lower}.h\"",
        f"#include <{cls_name}>",
        f"#include <QString>",
    ]
    # Добавляем заголовки Qt-типов из lambda-connect
    for inc in sorted(lc_includes):
        cpp_lines.append(f"#include <{inc}>")

    # Заголовки событий (если есть proxy)
    if has_events:
        from events import ALL_EVENT_HEADERS
        for h in ALL_EVENT_HEADERS:
            cpp_lines.append(f"#include <{h}>")

    # Lifecycle-трекер (QObject-наследники)
    if tracked:
        cpp_lines.append(f'#include "../qte56_qobject/qte56_lifecycle.h"')

    cpp_lines.append(f"")

    # Proxy-класс (перед extern "C")
    if has_events:
        from cpp_generator import generate_event_proxy
        cpp_lines.append(generate_event_proxy(cls_name, has_text_ctor))

    # Value-класс (QPointF, QRectF, ...): не QObject, конструктор без parent.
    # Сигнатуру create(void*) сохраняем для единообразия ABI — parent игнорируется.
    from knowledge_access import get_knowledge as _get_kb2
    _kb2 = _get_kb2()
    is_value_class = (_kb2 is not None and _kb2.is_value_type(cls_name)
                      and not _kb2.is_qobject_subclass(cls_name))

    if is_value_class:
        create_ret  = f"new {create_type}()"
        create_text_ret = (f"new {create_type}("
                           f"QString::fromWCharArray(text, len))")
    elif tracked:
        create_ret  = f"qte_createTracked(new {create_type}((QWidget*)parent))"
        create_text_ret = (f"qte_createTracked(new {create_type}("
                           f"QString::fromWCharArray(text, len), (QWidget*)parent))")
    else:
        create_ret  = f"new {create_type}((QWidget*)parent)"
        create_text_ret = (f"new {create_type}("
                           f"QString::fromWCharArray(text, len), (QWidget*)parent)")

    cpp_lines += [
        f"extern \"C\" {{",
        f"",
        f"// ── Lifecycle ────────────────────────────────────────────────────────────",
        f"void* qte{cls_name}_create(void* parent) {{",
        f"    return {create_ret};",
        f"}}",
        f"",
        f"void qte{cls_name}_delete(void* w) {{",
        f"    delete ({create_type}*)w;",
        f"}}",
    ]

    if has_text_ctor:
        cpp_lines += [
            f"",
            f"void* qte{cls_name}_create_text(const wchar_t* text, int len, void* parent) {{",
            f"    return {create_text_ret};",
            f"}}",
        ]

    cpp_lines.append("")

    if specs:
        cpp_lines.append("// ── Methods ──────────────────────────────────────────────────────────────")

    for s in specs:
        cpp_lines.extend(_method_cpp_lines(cls_name, s))

    # setEventHandler (если есть события)
    if has_events:
        from cpp_generator import generate_sethandler_cpp
        cpp_lines.append("// ── Event handler ────────────────────────────────────────────────────────────")
        cpp_lines.append(generate_sethandler_cpp(cls_name))

    # Lambda-connect функции для Qt-pointer сигналов.
    # Использует Qt5 функтор-connect, чтобы обойти ограничение метасистемы
    # (строчный connect не принимает несовпадение QFoo* и void*).
    if lambda_connect_specs:
        cpp_lines.append("// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────")
        for lc in lambda_connect_specs:
            cpp_lines.extend(_lambda_cpp_lines(cls_name, lc))

    cpp_lines += [f"}} // extern \"C\"", f""]

    cpp_text = "\n".join(cpp_lines)
    if gen_info:
        cpp_text = _render_info_block(gen_info) + "\n" + cpp_text

    # ─── .pro ────────────────────────────────────────────────────────────
    # Шаблон как у существующих проектов (cpp/qt5/qte56_qslider/qte56_qslider.pro):
    # выбор dll32/dll64 по QTE56_ARCH. Для tracked-классов — линковка с
    # qte56_foundation (там qte_lifecycle_track).
    pro_lines = [
        f"QT       += {qt_modules}",
        f"TARGET    = qte56_{name_lower}",
        f"TEMPLATE  = lib",
        f"CONFIG   += shared c++11",
        f"CONFIG   -= debug_and_release",
        f"DEFINES  += {build_def}",
        f"# Выбор папки назначения по QTE56_ARCH (32 или 64)",
        f"QTE56_ARCH = $$(QTE56_ARCH)",
        f"isEmpty(QTE56_ARCH) {{",
        f"    QTE56_ARCH = 32",
        f"}}",
        f"",
        f"equals(QTE56_ARCH, 64) {{",
        f"    DESTDIR = ../../../dll/dll64",
        f"unix: DESTDIR = ../../../lib",
        f"}} else {{",
        f"    DESTDIR = ../../../dll/dll32",
        f"unix: DESTDIR = ../../../lib",
        f"}}",
        f"",
        f"SOURCES   = qte56_{name_lower}.cpp",
        f"HEADERS   = qte56_{name_lower}.h",
    ]
    if tracked:
        pro_lines += [
            f"",
            f"# Lifecycle-трекер (qte_lifecycle_track) живёт в qte56_foundation",
            f"LIBS += -L$$DESTDIR -lqte56_foundation",
        ]
    pro_lines.append(f"")
    pro_text = "\n".join(pro_lines)
    if gen_info:
        pro_text = _render_info_block(gen_info, comment="#") + "\n" + pro_text

    return {
        "h": h_text,
        "cpp": cpp_text,
        "pro": pro_text,
        "name_lower": name_lower,
    }


def _write_cpp_with_lifecycle(cls_name, specs, ctor_idx, dtor_idx,
                               has_text_ctor, text_ctor_idx,
                               out_dir, qt_modules,
                               has_events: bool = False,
                               lambda_connect_specs: list = None):
    """
    Записывает .h, .cpp, .pro в out_dir.
    Тонкая обёртка вокруг _generate_cpp_texts для обратной совместимости.
    """
    texts = _generate_cpp_texts(
        cls_name, specs, ctor_idx, dtor_idx,
        has_text_ctor, text_ctor_idx, qt_modules,
        has_events=has_events,
        lambda_connect_specs=lambda_connect_specs,
    )
    name_lower = texts["name_lower"]
    os.makedirs(out_dir, exist_ok=True)

    h_path   = os.path.join(out_dir, f"qte56_{name_lower}.h")
    cpp_path = os.path.join(out_dir, f"qte56_{name_lower}.cpp")
    pro_path = os.path.join(out_dir, f"qte56_{name_lower}.pro")

    with open(h_path, "w", encoding="utf-8") as f:
        f.write(texts["h"])
    with open(cpp_path, "w", encoding="utf-8") as f:
        f.write(texts["cpp"])
    with open(pro_path, "w", encoding="utf-8") as f:
        f.write(texts["pro"])

    return h_path, cpp_path, pro_path
