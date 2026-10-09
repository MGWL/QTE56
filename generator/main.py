"""
main.py — точка входа генератора QTE56 (тонкий оркестратор).

Использование:
  python main.py <путь_к_заголовку.h> [опции]

Примеры:
  # Генерировать QLabel
  python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qlabel.h \
      --module QLabel --dll qte56_qlabel.dll

  # Только показать информацию (без записи файлов)
  python main.py qlabel.h --info

  # Указать папки вывода
  python main.py qlabel.h --cpp-out ../cpp/qt5/qte56_qlabel --d-out ../d/gen

Пайплайн (каждая фаза печатает результат; FAIL на фазах 1–3 прерывает
генерацию до записи чего-либо):
  [1/5] parse header      — qt_parser → QtClass
  [2/5] preflight checks  — checks.py (header, registry, dll-name, index-start)
  [3/5] plan methods      — planner.py (имена, перегрузки, индексы реестра)
  [4/5] generate texts    — cpp_texts.py + d_generator.py
  [5/5] write + registry  — fileops.py; при --dry-run ничего не пишется

Модули:
  geninfo.py    — блок GENERATOR-INFO
  planner.py    — планирование методов и регистрация функций
  cpp_texts.py  — тексты .h/.cpp/.pro
  checks.py     — preflight-проверки
  fileops.py    — запись, diff, --patch
"""

import sys
import os
import argparse

sys.path.insert(0, os.path.dirname(__file__))

from registry import Registry
from qt_parser import parse_qt_header, print_class_summary
from d_generator import DGenerator, _signal_invoke
from geninfo import _build_gen_info
from planner import _plan_methods, _collect_parent_methods, _compute_skip_methods
from cpp_texts import _generate_cpp_texts
from fileops import _diff_text, _write_text, _patch_d_file
import checks


def main():
    parser = argparse.ArgumentParser(description="QTE56 D binding generator")
    parser.add_argument("header",
                        help="Path to Qt .h file")
    parser.add_argument("--module",   default=None,
                        help="Module name, e.g. QWidget")
    parser.add_argument("--dll",      default=None,
                        help="DLL filename, e.g. qte56_qwidget.dll")
    parser.add_argument("--csv",      default="../registry/functions.csv",
                        help="Path to functions.csv")
    parser.add_argument("--d-out",    default="../d/gen",
                        help="Output directory for .d file")
    parser.add_argument("--cpp-out",  default=None,
                        help="Output directory for C++ files (default: ../cpp/qte56_qXxx)")
    parser.add_argument("--qt-mod",   default="core widgets",
                        help="Qt modules for .pro (default: 'core widgets')")
    parser.add_argument("--parent-header", action="append", default=[],
                        metavar="PATH",
                        help="Path to parent class .h file; repeatable. "
                             "Adds inherited public methods/signals to the generated DLL.")
    parser.add_argument("--d-parent",  default=None,
                        help="D parent class for D inheritance (e.g. QWidget). "
                             "Auto-detected from qt_hierarchy.D_PARENT_FULL if not given.")
    parser.add_argument("--index-start", type=int, default=None, dest="index_start",
                        help="Явное начало блока индексов для нового класса "
                             "(размещение в дыре нумерации, см. `qte index gaps`). "
                             "Без флага — следующий блок после максимального индекса.")
    parser.add_argument("--info",     action="store_true",
                        help="Print class info and exit (no file generation)")
    parser.add_argument("--no-cpp",   action="store_true",
                        help="Skip C++ file generation")
    parser.add_argument("--no-d",     action="store_true",
                        help="Skip D file generation")
    parser.add_argument("--dry-run",  action="store_true",
                        help="Generate everything but do not write files or update registry")
    parser.add_argument("--diff",     action="store_true",
                        help="Show unified diff between generated and existing files")
    parser.add_argument("--patch",    action="store_true",
                        help="Update only auto-generated sections in existing D file, "
                             "preserving manual edits outside markers")
    parser.add_argument("--force",    action="store_true",
                        help="Продолжить несмотря на FAIL preflight-проверок "
                             "(кроме невозможности распарсить заголовок)")
    parser.add_argument("--augment",  action="store_true",
                        help="Режим дополнения существующего модуля: сформировать "
                             "патч только с недостающими методами (C++/D/CSV-сниппеты), "
                             "не переписывая существующие файлы")
    parser.add_argument("--augment-out", default=None, metavar="PATH",
                        help="Путь для augment-патча (default: augment_<cls>.patch.txt)")
    parser.add_argument("--apply",    action="store_true",
                        help="В режиме --augment: дописать новые CSV-строки в реестр")
    args = parser.parse_args()

    # ── [1/5] Парсим заголовок ────────────────────────────────────────────
    print("[1/5] parse header")
    header = args.header
    if not os.path.isabs(header):
        header = os.path.abspath(header)

    print(f"Parsing: {header}")
    if not os.path.exists(header):
        print(f"ERROR [FAIL] header: файл не найден: {header}")
        sys.exit(1)
    # If --module is given, try to find that specific class in the header
    # (useful for headers with multiple classes, e.g. qspinbox.h has QSpinBox+QDoubleSpinBox)
    target = args.module
    qt_class = parse_qt_header(header, target_class=target)
    if qt_class is None and target:
        # fallback: parse first class found
        qt_class = parse_qt_header(header)
    if qt_class is None:
        print("ERROR: Qt class not found in header")
        sys.exit(1)

    cls = qt_class.name
    print(f"Found: {cls} : {', '.join(qt_class.parents)}")

    if args.info:
        print_class_summary(qt_class)
        return

    module_name = args.module or cls
    cpp_out     = args.cpp_out or f"../cpp/qt5/qte56_{cls.lower()}"

    # ── 1b. Определяем D-родителя: явный --d-parent → D_PARENT_FULL → knowledge ─
    d_parent = args.d_parent
    d_parent_source = "cli" if d_parent else ""
    if d_parent is None:
        from qt_hierarchy import D_PARENT_FULL
        d_parent = D_PARENT_FULL.get(cls, "") or ""
        if d_parent:
            d_parent_source = "qt_hierarchy.D_PARENT_FULL"
        if not d_parent:
            # Fallback: первый Qt-родитель из базы знаний
            # (пропускаем шаблонные и не-Q имена)
            from knowledge_access import get_knowledge
            kb = get_knowledge()
            if kb is not None:
                for p in kb.parents.get(cls, []):
                    if p.startswith("Q") and "<" not in p and "::" not in p:
                        d_parent = p
                        d_parent_source = "knowledge"
                        print(f"D parent from knowledge: {p}")
                        break
    else:
        # Проверяем, что указанный родитель известен в полной иерархии
        from qt_hierarchy import D_PARENT_FULL
        known_parents = set(D_PARENT_FULL.keys()) | {"QWidget", "QObject", ""}
        if d_parent not in known_parents:
            print(f"WARNING: D parent '{d_parent}' is not known in qt_hierarchy. "
                  f"Generated code may not compile.")
    if d_parent:
        print(f"D parent: {d_parent}  (class {cls} : {d_parent})")

    # ── [2/5] Preflight-проверки ──────────────────────────────────────────
    print("[2/5] preflight checks")
    csv_path = args.csv
    if not os.path.isabs(csv_path):
        csv_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), csv_path)
        )
    reg = Registry(csv_path)

    preflight = []
    preflight += checks.check_header(header, qt_class)
    preflight += checks.check_registry(reg)
    dll_file, dll_results = checks.resolve_dll_name(reg, module_name, cls, args.dll)
    preflight += dll_results
    preflight += checks.check_index_start(reg, module_name, args.index_start)
    if args.augment and reg.module_block_start(module_name) is None:
        preflight.append(checks.CheckResult(
            "FAIL", "augment",
            f"модуль {module_name} отсутствует в реестре — augment неприменим; "
            f"для нового класса используйте обычную генерацию (без --augment)"))
    checks.print_results(preflight)

    if checks.has_fail(preflight) and not args.force:
        print("ERROR: preflight FAILED — ничего не записано, реестр не изменён.")
        print("       Исправьте проблему или повторите с --force.")
        sys.exit(1)

    # Дальше везде используем разрешённое имя DLL (реестр > --dll > шаблон)
    args.dll = dll_file

    # ── [3/5] Планируем методы ────────────────────────────────────────────
    print("[3/5] plan methods")
    # Снимок имён реестра ДО планирования — нужен режиму --augment,
    # чтобы отличить новые функции от переиспользованных.
    existing_names = {e.func_name for e in reg.entries}
    parent_methods, parent_signals = [], []
    if args.parent_header:
        parent_header_paths = [
            p if os.path.isabs(p) else os.path.abspath(p)
            for p in args.parent_header
        ]
        parent_methods, parent_signals = _collect_parent_methods(parent_header_paths)

    specs, signals, ctor_idx, dtor_idx, has_text_ctor, text_ctor_idx, event_handler_idx = \
        _plan_methods(cls, qt_class, reg, module_name, dll_file,
                      parent_methods=parent_methods,
                      parent_signals=parent_signals,
                      index_start=args.index_start)
    # Фильтруем методы, унаследованные от d_parent (уже доступны через D-наследование)
    if d_parent:
        skip_methods = _compute_skip_methods(d_parent)
        before = len(specs)
        specs = [s for s in specs if s.qt_name not in skip_methods]
        skipped = before - len(specs)
        if skipped:
            print(f"Skipped {skipped} method(s) inherited from ancestors ({len(skip_methods)} in skip list)")

        # Фильтруем сигналы из parent_header — они уже доступны через D-наследование
        # (генерация connect_xxx в дочернем классе вызвала бы "cannot implicitly override")
        if parent_signals:
            parent_sig_names = {ps.name for ps in parent_signals}
            signals = [s for s in signals if s.name not in parent_sig_names]

    print(f"Methods: {len(specs)} wrapper(s), {len(signals)} signal(s)")
    print(f"Registry: create={ctor_idx}, delete={dtor_idx}")
    if has_text_ctor:
        print(f"          create_text={text_ctor_idx}")
    for s in specs[:5]:
        print(f"  [{s.idx}] {s.func_name}")
    if len(specs) > 5:
        print(f"  ... +{len(specs)-5} more")

    # ── 3b. Lambda-connect: сигналы с Qt-pointer параметрами ─────────────
    # Для таких сигналов строчный Qt connect не работает (QAction* ≠ void*).
    # Генерируем отдельную C++ функцию qteQFoo_connect_bar(w, cb, dthis)
    # с лямбдой, которая захватывает cb/dthis и передаёт Qt-pointer как void*.
    lambda_connect_specs = []
    for sig in signals:
        info = _signal_invoke(sig)
        if info and info.get("use_lambda"):
            # Регистрируем отдельную C++ функцию в реестре
            lc_func = f"qte{cls}_connect_{sig.name}"
            lc_map = reg.add_class_functions(module_name, dll_file, [lc_func], ["lambda_connect"],
                                             force_block_start=args.index_start)
            lc_idx = lc_map[lc_func]
            lambda_connect_specs.append({
                "sig_name":  sig.name,       # имя сигнала ("triggered")
                "func_name": lc_func,        # имя C++ функции
                "idx":       lc_idx,         # pFunQt индекс
                "invoke":    info["invoke"],  # "lambda" или "lambda2"
                "cpp_raw":   info["cpp_raw"], # C++ тип(ы) параметра(ов)
                "qt_sig":    info["qt_sig"],  # строка сигнала Qt
            })
            print(f"  [{lc_idx}] {lc_func}  (lambda-connect)")

    # Пост-план проверка: переиспользованные имена/индексы реестра
    post_plan = checks.check_reused_names(
        reg, [s.func_name for s in specs], module_name, dll_file)
    checks.print_results(post_plan)
    if checks.has_fail(post_plan) and not args.force:
        print("ERROR: post-plan checks FAILED — ничего не записано, реестр не изменён.")
        sys.exit(1)

    # ── Режим --augment: патч только с недостающими методами ─────────────
    if args.augment:
        from augment import run_augment
        rc = run_augment(args, cls, qt_class, reg, module_name, dll_file,
                         specs, signals, ctor_idx, dtor_idx, has_text_ctor,
                         text_ctor_idx, d_parent, lambda_connect_specs,
                         existing_names)
        sys.exit(rc)

    # ── 3c. GENERATOR-INFO: рабочая информация запуска для встраивания ────
    has_events = (event_handler_idx > 0)
    from knowledge_access import get_knowledge as _gk
    _kb = _gk()
    tracked = _kb.is_qobject_subclass(cls) if _kb is not None else has_events
    indices = ([ctor_idx, dtor_idx, text_ctor_idx, event_handler_idx]
               + [s.idx for s in specs]
               + [lc["idx"] for lc in lambda_connect_specs])
    indices = [i for i in indices if i]
    gen_info = _build_gen_info(
        cls, header, args, d_parent, d_parent_source, qt_class,
        specs, signals, indices, tracked)

    # ── [4/5] Генерируем тексты C++ и D ───────────────────────────────────
    print("[4/5] generate texts")
    cpp_texts = None
    if not args.no_cpp:
        cpp_texts = _generate_cpp_texts(
            cls, specs, ctor_idx, dtor_idx,
            has_text_ctor, text_ctor_idx,
            args.qt_mod,
            has_events=has_events,
            lambda_connect_specs=lambda_connect_specs,
            tracked=tracked,
            gen_info=gen_info,
        )

    d_code = None
    d_path = None
    if not args.no_d:
        gen = DGenerator(
            cls_name=cls,
            module_name=module_name,
            dll_file=dll_file,
            method_specs=specs,
            signals=signals,
            ctor_idx=ctor_idx,
            dtor_idx=dtor_idx,
            has_text_ctor=has_text_ctor,
            text_ctor_idx=text_ctor_idx,
            event_handler_idx=event_handler_idx,
            d_parent=d_parent,
            lambda_connect_specs=lambda_connect_specs,
            gen_info=gen_info,
        )
        d_code = gen.generate_all()

        d_out = args.d_out
        if not os.path.isabs(d_out):
            d_out = os.path.abspath(
                os.path.join(os.path.dirname(__file__), d_out)
            )
        d_path = os.path.join(d_out, f"gen_{cls.lower()}.d")

    # ── [5/5] Запись файлов и сохранение реестра ──────────────────────────
    if args.dry_run:
        print("[5/5] write + registry  [dry-run — пропущено]")
        if cpp_texts is not None:
            name_lower = cpp_texts["name_lower"]
            print(f"[dry-run] C++ would write:")
            print(f"            {os.path.join(cpp_out, f'qte56_{name_lower}.h')}")
            print(f"            {os.path.join(cpp_out, f'qte56_{name_lower}.cpp')}")
            print(f"            {os.path.join(cpp_out, f'qte56_{name_lower}.pro')}")
        if d_path is not None:
            print(f"[dry-run] D would write: {d_path}")
        print("[dry-run] Registry NOT saved (in-memory изменения отброшены).")
        print("Done.")
        return

    print("[5/5] write + registry")
    if cpp_texts is not None:
        name_lower = cpp_texts["name_lower"]
        h_path   = os.path.join(cpp_out, f"qte56_{name_lower}.h")
        cpp_path = os.path.join(cpp_out, f"qte56_{name_lower}.cpp")
        pro_path = os.path.join(cpp_out, f"qte56_{name_lower}.pro")

        if args.diff:
            print(f"[diff] C++ files:")
            _diff_text(h_path, cpp_texts["h"])
            _diff_text(cpp_path, cpp_texts["cpp"])
            _diff_text(pro_path, cpp_texts["pro"])
        else:
            os.makedirs(cpp_out, exist_ok=True)
            with open(h_path, "w", encoding="utf-8") as f:
                f.write(cpp_texts["h"])
            with open(cpp_path, "w", encoding="utf-8") as f:
                f.write(cpp_texts["cpp"])
            with open(pro_path, "w", encoding="utf-8") as f:
                f.write(cpp_texts["pro"])
            print(f"C++ written: {h_path}")
            print(f"             {cpp_path}")
            print(f"             {pro_path}")

    if d_code is not None:
        os.makedirs(os.path.dirname(d_path), exist_ok=True)
        if args.diff:
            print(f"[diff] D file:")
            _diff_text(d_path, d_code)
        elif args.patch:
            if not _patch_d_file(d_path, d_code, cls):
                # Файла нет или маркеры не найдены — обычная запись
                _write_text(d_path, d_code)
                print(f"D written:   {d_path} (no existing markers, full write)")
            else:
                print(f"D patched:   {d_path}")
        else:
            _write_text(d_path, d_code)
            print(f"D written:   {d_path}")

    reg.save()
    print("Registry saved.")

    print("Done.")


if __name__ == "__main__":
    try:
        main()
    except ValueError as e:
        # Коллизия/переполнение индексов реестра — понятное сообщение без traceback
        print(f"ERROR: {e}")
        sys.exit(1)
