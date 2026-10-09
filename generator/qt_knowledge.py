# -*- coding: utf-8 -*-
"""
Сканер заголовков Qt: строит базу знаний о классах, enum'ах и типах,
кеширует её в JSON. База заменяет эвристики генератора точными таблицами.

Использование:
    python qt_knowledge.py [--qt-include PATH] [--out PATH] [--selftest]

По умолчанию:
    --qt-include  C:/Qt5_13_2/5.13.2/mingw73_32/include
    --out         <этот каталог>/knowledge/qt_knowledge.json

Формат JSON (UTF-8, ensure_ascii=False):
{
  "version": 1,
  "qt_include": "<сканированный include root>",
  "built_at": "<ISO-время>",
  "stats": {"files": int, "classes": int, "enums": int,
            "value_types": int, "errors": int, "seconds": float},

  // "ИмяКласса" -> список прямых родителей (без template-аргументов)
  "parents":          {"QLabel": ["QFrame"], ...},

  // "ИмяКласса" -> путь заголовка относительно include root
  "class_header":     {"QLabel": "QtWidgets/qlabel.h", ...},

  // "ИмяКласса" -> Qt-модуль (QtCore / QtGui / QtWidgets / ...)
  "class_module":     {"QLabel": "QtWidgets", ...},

  // "ИмяКласса" -> true, если класс шаблонный (QList<T> и т.п.)
  "class_template":   {"QList": true, ...},

  // Полные имена всех enum'ов: "Класс::Enum" и "Qt::Enum" (включая Q_FLAGS)
  "enums_qualified":  ["QLineEdit::EchoMode", "Qt::Alignment", ...],

  // Неквалифицированное имя -> список квалифицированных (при неоднозначности > 1)
  "enums_unqualified": {"EchoMode": ["QLineEdit::EchoMode"], ...},

  // Производные множества (транзитивные замыкания)
  "value_types":         ["QPoint", "QFont", ...],   // НЕ QObject-наследники
  "qobject_descendants": ["QWidget", ...],
  "widget_descendants":  ["QPushButton", ...],

  // Частота нормализованных типов в сигнатурах публичных методов
  // (нормализация: без 'const', пробелы вокруг */& схлопнуты: "QString &", "QWidget *")
  "type_freq": {"QString &": 1234, ...},

  // Непарсящиеся файлы: не роняют сканер
  "errors": [{"file": "...", "reason": "..."}, ...]
}

API для генератора:
    from qt_knowledge import load_knowledge
    kb = load_knowledge()                 # None -> knowledge/qt_knowledge.json рядом с модулем
    kb.parents["QLabel"]                  # ["QFrame"]
    kb.is_enum("EchoMode")                # True (unqualified резолвится)
    kb.is_enum("Qt::Alignment")           # True
    kb.is_value_type("QPoint")            # True
    kb.is_widget_subclass("QPushButton")  # True (транзитивно)
    kb.ancestors("QPushButton")           # ["QAbstractButton", "QWidget", "QObject"]
"""

import argparse
import json
import os
import re
import sys
import time
from multiprocessing import Pool, cpu_count

# Переиспользуем функции regex-парсера генератора (без дублирования)
from qt_parser import _strip_comments, _extract_class_body, RE_METHOD, _parse_params

DEFAULT_QT_INCLUDE = "C:/Qt5_13_2/5.13.2/mingw73_32/include"
DEFAULT_OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "knowledge", "qt_knowledge.json")

# ---------------------------------------------------------------------------
# Regex-ы для сканирования

# Объявление класса/структуры с телом (не forward-decl):
#   [template <...>] class [Q_XXX_EXPORT] Name [: public A, ...] {
# Покрывает и классы без export-макроса (value-типы QPoint, QStringList...).
_RE_CLASS_DECL = re.compile(
    r'(?:template\s*<[^;{}]*?>\s*)?'          # template-префикс (необязателен)
    r'\b(?:class|struct)\s+'
    r'(?:Q_\w+_EXPORT\s+)?'                   # export-макрос (необязателен)
    r'(\w+)'                                  # имя
    r'\s*(?:Q_DECL_FINAL\s*|final\s*)?'
    r'\s*(?::\s*([^{;]*?))?'                  # список родителей
    r'\s*\{',                                 # тело обязательно (отсекает forward-decl)
    re.MULTILINE
)
_RE_PARENT = re.compile(
    r'(?:public|protected|private)\s+(?:virtual\s+)?([\w:]+(?:\s*<[^>]*>)?)')

# enum внутри тела: enum [class] Name [: type] { ... }
_RE_ENUM = re.compile(r'\benum\s+(?:class\s+)?(\w+)\s*(?::\s*[\w:]+)?\s*\{')
# Q_DECLARE_FLAGS(Flags, Flag) / Q_FLAGS(...) — Qt-typedef множеств флагов
_RE_DECLARE_FLAGS = re.compile(r'\bQ_DECLARE_FLAGS\s*\(\s*(\w+)\s*,\s*(\w+)\s*\)')

# namespace Qt { ... } — для Qt::Alignment и т.п.
# Особенность qnamespace.h: объявлено как
#   #ifndef Q_MOC_RUN
#   namespace
#   #else
#   class Q_CORE_EXPORT
#   #endif
#   Qt {
# поэтому между "namespace" и "Qt {" допускаем препроцессорные строки.
_RE_NS_QT = re.compile(
    r'\bnamespace\b'
    r'(?:\s*(?:#(?:ifn?def|else|endif)[^\n]*|class\s+Q_\w+_EXPORT))*'
    r'\s*Qt\s*\{')

# Секции видимости (как в qt_parser, упрощённо — для частоты типов)
_RE_SECTION = re.compile(
    r'^[ \t]*(?:'
    r'(protected|private|public)\s*(Q_SLOTS:|slots:|Q_SIGNALS:|signals:)?'
    r'|'
    r'(Q_SIGNALS:|signals:|Q_SLOTS:|slots:)'
    r')',
    re.MULTILINE
)


def _safe_print(*args, **kwargs):
    """print, не роняющийся на консоли cp1251."""
    try:
        print(*args, **kwargs)
    except UnicodeEncodeError:
        text = " ".join(str(a) for a in args)
        enc = sys.stdout.encoding or "ascii"
        print(text.encode(enc, errors="replace").decode(enc), **kwargs)


def _normalize_type(t: str) -> str:
    """Нормализация строки C++ типа для частотной статистики."""
    t = t.strip()
    # убираем квалификаторы-макросы Qt и модификаторы объявления
    for kw in ("Q_REQUIRED_RESULT", "Q_DECL_CONSTEXPR", "Q_DECL_RELAXED_CONSTEXPR"):
        t = t.replace(kw, "")
    t = re.sub(r'\b(?:inline|virtual|static|explicit|friend)\b', '', t)
    t = re.sub(r'\bconst\s+', '', t)          # const QString -> QString
    t = re.sub(r'\s+const\b', '', t)          # QString const -> QString
    t = re.sub(r'\s*([*&])\s*', r' \1', t)    # "QWidget*" / "QWidget *" -> "QWidget *"
    t = re.sub(r'\s+', ' ', t).strip()
    return t


def _strip_for_methods(body: str) -> str:
    """Подготовка тела класса к regex-парсингу методов (как в qt_parser)."""
    # убираем строки Q_DECLARE_*, Q_OBJECT и т.п.
    body = re.sub(r'^\s*Q_(?!SIGNALS\b|SLOTS\b)\w+[^;(]*$', '', body,
                  flags=re.MULTILINE)
    # дефолтные значения с вызовами: = QVariant() / = Qt::X() / = nullptr -> = 0
    body = re.sub(r'=\s*\w[\w:]*\(\)', '= 0', body)
    body = re.sub(r'=\s*nullptr', '= 0', body)
    # "QWidget *name(" -> "QWidget * name("
    body = re.sub(r'([*&])(\w+)(\s*\()', lambda m: m.group(1) + ' ' + m.group(2) + m.group(3), body)
    return body


def _scan_file(args):
    """Worker Pool: сканирует один .h файл. Возвращает частичный результат.

    args: (abs_path, rel_path, module)
    """
    abs_path, rel_path, module = args
    res = {
        "classes": [],      # {name, parents, header, module, template}
        "ns_enums": [],     # enum'ы из namespace Qt (без класса)
        "type_freq": {},    # нормализованный тип -> count
        "error": None,
    }
    try:
        with open(abs_path, encoding="utf-8", errors="ignore") as f:
            text = f.read()
    except OSError as e:
        res["error"] = f"чтение: {e}"
        return res

    try:
        text = _strip_comments(text)

        # --- enum'ы и Q_DECLARE_FLAGS уровня namespace Qt (qnamespace.h) ---
        for nm in _RE_NS_QT.finditer(text):
            ns_body = _extract_class_body(text, nm.end() - 1)
            for em in _RE_ENUM.finditer(ns_body):
                res["ns_enums"].append(em.group(1))
            for fm in _RE_DECLARE_FLAGS.finditer(ns_body):
                res["ns_enums"].append(fm.group(1))  # Flags-typedef (Qt::Alignment)

        # --- классы ---
        for cm in _RE_CLASS_DECL.finditer(text):
            name = cm.group(1)
            parents_raw = cm.group(2) or ""
            # template-префикс съеден _RE_CLASS_DECL в начало совпадения:
            # если совпадение начинается с "template <" — класс шаблонный
            is_template = bool(re.match(r'template\s*<', text[cm.start():]))

            parents = []
            for p in _RE_PARENT.findall(parents_raw):
                p = p.split("::")[-1]                     # без namespace
                p = re.sub(r'\s*<.*>', '', p)             # без template-аргументов
                if p and p != name:
                    parents.append(p)

            body = _extract_class_body(text, cm.end() - 1)

            # enum'ы внутри класса + Q_DECLARE_FLAGS
            enums = [em.group(1) for em in _RE_ENUM.finditer(body)]
            enums += [fm.group(1) for fm in _RE_DECLARE_FLAGS.finditer(body)]

            res["classes"].append({
                "name": name,
                "parents": parents,
                "header": rel_path,
                "module": module,
                "template": is_template,
                "enums": enums,
            })

            # --- частота типов по публичным методам ---
            body_m = _strip_for_methods(body)

            # позиции private-секций (struct по умолчанию public, class — private до
            # первой секции: для частотной статистики пренебрежимо, берём всё,
            # кроме явного private:)
            sections = [(sm.start(), sm.group(1) == "private")
                        for sm in _RE_SECTION.finditer(body_m)]

            def _is_private(pos):
                cur = False
                for spos, spriv in sections:
                    if spos > pos:
                        break
                    cur = spriv
                return cur

            for mm in RE_METHOD.finditer(body_m):
                mname = mm.group(3).strip()
                if mname == name or mname.startswith("~") or mname.startswith("operator"):
                    continue
                if _is_private(mm.start()):
                    continue
                ret = _normalize_type(mm.group(2))
                if ret:
                    res["type_freq"][ret] = res["type_freq"].get(ret, 0) + 1
                for p in _parse_params(mm.group(4).strip()):
                    pt = _normalize_type(p.cpp_type)
                    if pt:
                        res["type_freq"][pt] = res["type_freq"].get(pt, 0) + 1
    except Exception as e:  # непарсящийся файл не роняет сканер
        res["error"] = f"{type(e).__name__}: {e}"

    return res


def _collect_files(qt_include: str):
    """Собирает список (abs_path, rel_path, module) для всех *.h в Qt*-директориях.

    Файлы-алиасы без расширения (QLabel -> #include "qlabel.h") пропускаются.
    Приватные заголовки версии (5.13.2/...) пропускаются.
    """
    files = []
    for entry in sorted(os.listdir(qt_include)):
        mod_dir = os.path.join(qt_include, entry)
        if not entry.startswith("Qt") or not os.path.isdir(mod_dir):
            continue
        if entry.endswith("Support") or entry in ("QtANGLE", "QtPlatformHeaders",
                                                   "QtOpenGLExtensions"):
            continue  # внутренние support-модули, не публичный API
        for fname in sorted(os.listdir(mod_dir)):
            if not fname.endswith(".h"):
                continue  # алиасы без расширения пропускаем
            abs_path = os.path.join(mod_dir, fname)
            rel_path = f"{entry}/{fname}"
            files.append((abs_path, rel_path, entry))
    return files


def _transitive_closure(parents: dict, root: str) -> set:
    """Все потомки root по таблице прямых родителей."""
    result = set()
    stack = [root]
    children = {}
    for child, plist in parents.items():
        for p in plist:
            children.setdefault(p, []).append(child)
    while stack:
        node = stack.pop()
        for c in children.get(node, []):
            if c not in result:
                result.add(c)
                stack.append(c)
    return result


def build_knowledge(qt_include: str) -> dict:
    """Полное построение базы знаний: параллельный скан + агрегация."""
    t0 = time.time()
    files = _collect_files(qt_include)
    if not files:
        raise RuntimeError(f"Не найдено *.h в {qt_include} — проверьте --qt-include")

    with Pool(cpu_count()) as pool:
        results = pool.map(_scan_file, files)

    # --- агрегация ---
    parents = {}
    class_header = {}
    class_module = {}
    class_template = {}
    enums_qualified = set()
    type_freq = {}
    errors = []

    for (abs_path, rel_path, module), res in zip(files, results):
        if res["error"]:
            errors.append({"file": rel_path, "reason": res["error"]})
        for e in res["ns_enums"]:
            enums_qualified.add(f"Qt::{e}")
        for c in res["classes"]:
            name = c["name"]
            # При коллизиях имён (разные модули) оставляем первую запись
            if name not in parents:
                parents[name] = c["parents"]
                class_header[name] = c["header"]
                class_module[name] = c["module"]
                class_template[name] = c["template"]
            else:
                # дополняем родителей, если в первой записи их не было
                if not parents[name] and c["parents"]:
                    parents[name] = c["parents"]
            for e in c["enums"]:
                enums_qualified.add(f"{name}::{e}")
        for t, cnt in res["type_freq"].items():
            type_freq[t] = type_freq.get(t, 0) + cnt

    # unqualified -> список qualified
    enums_unq = {}
    for q in sorted(enums_qualified):
        unq = q.split("::")[-1]
        enums_unq.setdefault(unq, []).append(q)

    # --- производные множества ---
    qobject_desc = _transitive_closure(parents, "QObject")
    widget_desc = _transitive_closure(parents, "QWidget")
    if "QObject" in parents:
        qobject_desc.add("QObject")
    if "QWidget" in parents:
        widget_desc.add("QWidget")

    value_types = sorted(
        name for name in parents
        if name not in qobject_desc
    )

    seconds = time.time() - t0
    return {
        "version": 1,
        "qt_include": qt_include,
        "built_at": time.strftime("%Y-%m-%dT%H:%M:%S"),
        "stats": {
            "files": len(files),
            "classes": len(parents),
            "enums": len(enums_qualified),
            "value_types": len(value_types),
            "errors": len(errors),
            "seconds": round(seconds, 2),
        },
        "parents": parents,
        "class_header": class_header,
        "class_module": class_module,
        "class_template": class_template,
        "enums_qualified": sorted(enums_qualified),
        "enums_unqualified": enums_unq,
        "value_types": value_types,
        "qobject_descendants": sorted(qobject_desc),
        "widget_descendants": sorted(widget_desc),
        "type_freq": dict(sorted(type_freq.items(), key=lambda kv: -kv[1])),
        "errors": errors,
    }


# ---------------------------------------------------------------------------
# API для генератора

class QtKnowledge:
    """Обёртка над загруженной базой знаний."""

    def __init__(self, data: dict):
        self.parents = data["parents"]
        self.class_header = data["class_header"]
        self.class_module = data["class_module"]
        self.class_template = data.get("class_template", {})
        self.enums_qualified = set(data["enums_qualified"])
        self.enums_unqualified = data["enums_unqualified"]
        self.value_types = set(data["value_types"])
        self.qobject_descendants = set(data["qobject_descendants"])
        self.widget_descendants = set(data["widget_descendants"])
        self.type_freq = data["type_freq"]
        self.errors = data.get("errors", [])

    def ancestors(self, name: str) -> list:
        """Цепочка предков name (без самого name), до корня. Циклы защищены."""
        result = []
        seen = {name}
        stack = list(self.parents.get(name, []))
        while stack:
            p = stack.pop(0)
            if p in seen:
                continue
            seen.add(p)
            result.append(p)
            stack.extend(self.parents.get(p, []))
        return result

    def is_qobject_subclass(self, name: str) -> bool:
        return name in self.qobject_descendants

    def is_widget_subclass(self, name: str) -> bool:
        return name in self.widget_descendants

    def is_value_type(self, name: str) -> bool:
        return name in self.value_types

    def is_enum(self, name: str) -> bool:
        """Принимает и qualified (QLineEdit::EchoMode), и unqualified (EchoMode)."""
        if "::" in name:
            return name in self.enums_qualified
        return name in self.enums_unqualified

    def resolve_enum(self, name: str) -> list:
        """unqualified -> список qualified (пустой, если не enum)."""
        if "::" in name:
            return [name] if name in self.enums_qualified else []
        return list(self.enums_unqualified.get(name, []))


def load_knowledge(path: str = None) -> QtKnowledge:
    """Загружает базу знаний из JSON. path=None -> knowledge/qt_knowledge.json."""
    if path is None:
        path = DEFAULT_OUT
    if not os.path.exists(path):
        raise FileNotFoundError(
            f"База знаний не найдена: {path}\n"
            f"Сначала запустите: python qt_knowledge.py "
            f"(в каталоге generator/)"
        )
    with open(path, encoding="utf-8") as f:
        return QtKnowledge(json.load(f))


# ---------------------------------------------------------------------------
# Selftest

def run_selftest(kb: QtKnowledge) -> bool:
    checks = []

    def check(desc, ok):
        checks.append((desc, ok))

    check("QLabel: родитель QFrame", kb.parents.get("QLabel") == ["QFrame"])
    check("QLabel: заголовок QtWidgets/qlabel.h",
          kb.class_header.get("QLabel") == "QtWidgets/qlabel.h")
    check("QLineEdit::EchoMode — enum", kb.is_enum("QLineEdit::EchoMode"))
    check('unqualified "EchoMode" резолвится', kb.is_enum("EchoMode"))
    check("Qt::Alignment — enum", kb.is_enum("Qt::Alignment"))
    for vt in ("QPoint", "QFont", "QColor", "QDate", "QStringList"):
        check(f"{vt} — value-тип", kb.is_value_type(vt))
    check("QWidget — QObject-наследник", kb.is_qobject_subclass("QWidget"))
    check("QPushButton — widget-наследник (транзитивно)",
          kb.is_widget_subclass("QPushButton"))
    check("QStringList — НЕ QObject-наследник",
          not kb.is_qobject_subclass("QStringList"))

    all_ok = True
    for desc, ok in checks:
        _safe_print(f"  [{'PASS' if ok else 'FAIL'}] {desc}")
        if not ok:
            all_ok = False
    return all_ok


# ---------------------------------------------------------------------------
# CLI

def main(argv=None):
    try:
        sys.stdout.reconfigure(errors="replace")
    except (AttributeError, ValueError):
        pass

    ap = argparse.ArgumentParser(description="Сканер заголовков Qt -> база знаний JSON")
    ap.add_argument("--qt-include", default=DEFAULT_QT_INCLUDE,
                    help="корень Qt include (по умолчанию %(default)s)")
    ap.add_argument("--out", default=DEFAULT_OUT,
                    help="путь выходного JSON (по умолчанию %(default)s)")
    ap.add_argument("--selftest", action="store_true",
                    help="проверить базу знаний по контрольным фактам")
    args = ap.parse_args(argv)

    if args.selftest:
        kb = load_knowledge(args.out)
        _safe_print(f"Selftest по базе: {args.out}")
        ok = run_selftest(kb)
        _safe_print("SELFTEST:", "OK" if ok else "FAILED")
        return 0 if ok else 1

    if not os.path.isdir(args.qt_include):
        _safe_print(f"ОШИБКА: Qt include не найден: {args.qt_include}")
        return 1

    _safe_print(f"Сканирование: {args.qt_include}")
    data = build_knowledge(args.qt_include)

    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=1)

    st = data["stats"]
    _safe_print(f"Готово: {args.out}")
    _safe_print(
        f"  файлов: {st['files']}  классов: {st['classes']}  "
        f"enum'ов: {st['enums']}  value-типов: {st['value_types']}  "
        f"ошибок: {st['errors']}  время: {st['seconds']}с"
    )
    if data["errors"]:
        _safe_print("  Файлы с ошибками:")
        for e in data["errors"][:10]:
            _safe_print(f"    {e['file']}: {e['reason']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
