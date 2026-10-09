"""
augment.py — режим --augment: патч только с недостающими методами
существующего модуля.

Сценарий: модуль уже существует (старый генератор или ручной), генератор
нашёл в заголовке Qt больше поддерживаемых методов. --augment НЕ переписывает
существующие файлы, а формирует единый patch-файл для ревью:

  1. CSV-строки для registry/functions.csv (только новые индексы);
  2. C++ объявления (.h) и реализации (.cpp) только новых функций;
  3. D mixin-строки для load-функции и D-методы только новых функций.

Определение «новых»:
  - методы: func_name отсутствовал в реестре до планирования;
  - сигналы: connect_<name> отсутствует в существующем d/gen/gen_<cls>.d.

С --apply CSV-строки дописываются в реестр (reg.save());
без --apply реестр не изменяется — индексы в патче лишь зарезервированы
в in-memory копии.
"""

import os
import sys

from d_generator import DGenerator
from cpp_texts import (_method_h_line, _method_cpp_lines,
                       _lambda_h_line, _lambda_cpp_lines)


def _extract_block(text: str, start_marker: str, end_marker: str) -> str:
    """Содержимое между маркерами (без самих маркеров)."""
    i = text.find(start_marker)
    j = text.find(end_marker)
    if i == -1 or j == -1 or j <= i:
        return ""
    i += len(start_marker)
    if i < len(text) and text[i] == "\n":
        i += 1
    return text[i:j]


def _split_d_chunks(class_block: str) -> list:
    """Разбивает тело класса на куски по строкам-заголовкам '    /// '.

    Возвращает список (header_line, chunk_text). Кусок — от строки
    заголовка до следующего заголовка (или конца блока).
    """
    lines = class_block.splitlines(keepends=True)
    chunks = []
    cur_header = None
    cur = []
    for ln in lines:
        # MANUAL-маркеры и закрывающая скобка класса — не часть кусков
        if ln.startswith("    // ===MANUAL-METHODS") or ln.startswith("} // class"):
            break
        if ln.startswith("    /// ") or ln.startswith("    // Signal"):
            if cur_header is not None:
                chunks.append((cur_header, "".join(cur)))
            cur_header = ln
            cur = [ln]
        else:
            if cur_header is not None:
                cur.append(ln)
    if cur_header is not None:
        chunks.append((cur_header, "".join(cur)))
    return chunks


def _norm_ws(text: str) -> str:
    """Схлопывает пробельные символы — для сравнения тел функций."""
    return " ".join(text.split())


def _existing_cpp_body_cores(cls: str) -> set:
    """Множество нормализованных тел функций существующего .cpp модуля.

    Дубликат метода под другим именем (старые суффиксы _p/_rect и т.п.)
    имеет побайтово то же тело (та же Qt-вызов с теми же аргументами).
    """
    import glob
    import re as _re
    cores = set()
    cpp_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "..", "cpp", "qt5", f"qte56_{cls.lower()}")
    for path in glob.glob(os.path.join(cpp_dir, "*.cpp")):
        with open(path, encoding="utf-8", errors="replace") as f:
            text = f.read()
        for m in _re.finditer(r"\)\s*\{(.*?)\n\}", text, _re.S):
            cores.add(_norm_ws(m.group(1)))
    return cores


def _d_sig_key(sig_line: str) -> tuple:
    """Ключ D-сигнатуры: (имя, типы параметров) — без имён параметров."""
    import re as _re
    m = _re.match(r"\s*(?:override\s+)?\w+(?:\[\])?\s+(\w+)\(([^)]*)\)", sig_line)
    if not m:
        return ("", ())
    name, params = m.groups()
    types = tuple(p.strip().split()[0] for p in params.split(",") if p.strip())
    return (name, types)


def _existing_d_sigs(old_d: str) -> set:
    """(имя, типы) всех методов существующего gen-файла."""
    import re as _re
    sigs = set()
    for ln in old_d.splitlines():
        if _re.match(r"\s{4}(?:override\s+)?\w", ln) and "(" in ln:
            name, types = _d_sig_key(ln)
            if name:
                sigs.add((name, types))
    return sigs


def _rename_chunk_method(chunk: str, old_name: str, new_name: str) -> str:
    """Переименовывает метод в сигнатурной строке куска (первое вхождение)."""
    import re as _re
    return _re.sub(r"\b" + _re.escape(old_name) + r"\(",
                   new_name + "(", chunk, count=1)


def run_augment(args, cls, qt_class, reg, module_name, dll_file,
                specs, signals, ctor_idx, dtor_idx, has_text_ctor,
                text_ctor_idx, d_parent, lambda_connect_specs,
                existing_names) -> int:
    """Строит augment-патч. Возвращает exit code."""

    # ── 0. augment применим только к существующему модулю ─────────────────
    if reg.module_block_start(module_name) is None:
        print(f"ERROR [FAIL] augment: модуль {module_name} отсутствует в реестре.")
        print("       Для нового класса используйте обычную генерацию (без --augment).")
        return 1

    # ── 1. Новые методы и lambda-connect (не было в реестре до планирования) ─
    new_specs  = [s for s in specs if s.func_name not in existing_names]
    new_lambda = [lc for lc in lambda_connect_specs
                  if lc["func_name"] not in existing_names]

    # ── 1b. Фильтр семантических дублей: тело уже есть в существующем .cpp ──
    # (старые суффиксные конвенции: метод есть под другим именем функции).
    from cpp_texts import _method_cpp_lines
    existing_bodies = _existing_cpp_body_cores(cls)
    dup_specs = []
    if existing_bodies:
        kept = []
        for s in new_specs:
            body = _norm_ws(_method_cpp_lines(cls, s)[1])
            if body in existing_bodies:
                dup_specs.append(s)
            else:
                kept.append(s)
        new_specs = kept
        if dup_specs:
            print(f"[augment] дублей существующих тел отфильтровано: {len(dup_specs)}")

    # ── 2. Новые сигналы (connect_<name> отсутствует в существующем gen-файле) ─
    d_out = args.d_out
    if not os.path.isabs(d_out):
        d_out = os.path.abspath(os.path.join(os.path.dirname(__file__), d_out))
    gen_path = os.path.join(d_out, f"gen_{cls.lower()}.d")
    old_d = ""
    if os.path.exists(gen_path):
        with open(gen_path, encoding="utf-8") as f:
            old_d = f.read()
    else:
        print(f"WARNING [augment]: существующий gen-файл не найден: {gen_path}")
        print("         Сигналы отфильтровать не удастся — все попадут в патч.")
    new_signals = [s for s in signals if f"connect_{s.name}" not in old_d]

    total_new = len(new_specs) + len(new_lambda) + len(new_signals)
    if total_new == 0:
        print(f"[augment] {cls}: модуль полон — недостающих методов нет.")
        print(f"[augment-count] {cls} methods=0 signals=0 lambda=0")
        return 0

    print(f"[augment] {cls}: +{len(new_specs)} методов, "
          f"+{len(new_signals)} сигналов "
          f"(из них lambda-connect: {len(new_lambda)})")
    # ASCII-дубль для машинного разбора (scan_augment.py): консоль cp1251
    # портит русский текст при захвате stdout.
    print(f"[augment-count] {cls} methods={len(new_specs)} "
          f"signals={len(new_signals)} lambda={len(new_lambda)}")

    # ── 3. D-сниппеты через DGenerator (specs/signals = только новые) ──────
    gen = DGenerator(
        cls_name=cls,
        module_name=module_name,
        dll_file=dll_file,
        method_specs=new_specs,
        signals=new_signals,
        ctor_idx=ctor_idx,
        dtor_idx=dtor_idx,
        has_text_ctor=False,       # create_text у существующего класса уже есть
        text_ctor_idx=0,
        event_handler_idx=0,
        d_parent=d_parent,
        lambda_connect_specs=new_lambda,
        gen_info=None,
    )
    d_text = gen.generate_all()

    # mixin-строки только для новых функций
    new_func_names = {s.func_name for s in new_specs} | {lc["func_name"] for lc in new_lambda}
    load_block = _extract_block(d_text,
                                "// ===AUTO-GENERATED-LOAD-FUNC-START===",
                                "// ===AUTO-GENERATED-LOAD-FUNC-END===")
    mixin_lines = [ln for ln in load_block.splitlines()
                   if "generateFunQt(" in ln
                   and any(f'"{fn}"' in ln for fn in new_func_names)]

    # куски методов/сигналов из тела класса
    class_block = _extract_block(d_text,
                                 "// ===AUTO-GENERATED-CLASS-START===",
                                 "// ===AUTO-GENERATED-CLASS-END===")
    keep_headers = []
    for s in new_specs:
        keep_headers.append(f"    /// {s.qt_name}\n")
    for s in new_signals:
        keep_headers.append(f"    /// Connect signal {s.name}")
    d_chunks = []
    prev_kept = False
    for header, chunk in _split_d_chunks(class_block):
        keep = any(header.startswith(h.rstrip("\n")) or header == h
                   for h in keep_headers)
        # продолжение lambda-signal ('    /// cb: ...') относится к предыдущему куску
        if not keep and prev_kept and header.startswith("    /// cb:"):
            keep = True
        if keep:
            d_chunks.append(chunk.rstrip("\n"))
        prev_kept = keep

    # ── 3b. Переименование D-методов, конфликтующих со старым gen-файлом ──
    # augment добавляет перегрузки: новый drawLine_qpointf_qpointf попадает
    # в D как drawLine(void*,void*) и сталкивается со старым drawLine(void*,void*).
    # Конфликт → суффикс из func_name: drawLine_qpointf_qpointf.
    old_sigs = _existing_d_sigs(old_d)
    renamed = 0
    if old_sigs:
        # куски методов (не сигналов) идут в порядке new_specs
        m_idx = [i for i, c in enumerate(d_chunks)
                 if not c.startswith("    /// Connect signal")]
        if len(m_idx) == len(new_specs):
            for ci, s in zip(m_idx, new_specs):
                chunk = d_chunks[ci]
                sig_line = next((ln for ln in chunk.splitlines()
                                 if "(" in ln and not ln.strip().startswith("///")), "")
                name, types = _d_sig_key(sig_line)
                if not name or (name, types) not in old_sigs:
                    continue
                prefix = f"qte{cls}_{s.qt_name}"
                suffix = s.func_name[len(prefix):] if s.func_name.startswith(prefix) else ""
                if not suffix:
                    print(f"WARNING [augment]: D-конфликт '{name}{types}', "
                          f"но суффикс пуст ({s.func_name}) — переименуйте вручную")
                    continue
                d_chunks[ci] = _rename_chunk_method(chunk, name, name + suffix)
                renamed += 1
        else:
            print(f"WARNING [augment]: кусков методов {len(m_idx)} != "
                  f"спецификаций {len(new_specs)} — D-переименование пропущено")
    if renamed:
        print(f"[augment] D-методов переименовано (конфликт со старым gen): {renamed}")

    # строка импортов gen_qcore (алиасы могут понадобиться новые)
    import_lines = [ln for ln in d_text.splitlines()
                    if ln.startswith("import gen_qcore")]

    # ── 4. C++ сниппеты ───────────────────────────────────────────────────
    macro = f"{cls.upper()}_API"
    h_snippet = ([_method_h_line(cls, macro, s) for s in new_specs]
                 + [_lambda_h_line(macro, lc) for lc in new_lambda])
    cpp_snippet = []
    for s in new_specs:
        cpp_snippet.extend(_method_cpp_lines(cls, s))
    for lc in new_lambda:
        cpp_snippet.extend(_lambda_cpp_lines(cls, lc))

    # ── 5. CSV-строки новых записей ───────────────────────────────────────
    new_entries = sorted(
        (e for e in reg.entries if e.func_name in new_func_names),
        key=lambda e: e.index)
    csv_lines = [f"{e.index},{e.func_name},{e.module_name},{e.dll_file},{e.category}"
                 for e in new_entries]

    # ── 6. Сборка patch-файла ─────────────────────────────────────────────
    import datetime
    P = []
    P.append("=" * 76)
    P.append(f"AUGMENT PATCH: {cls} — только недостающие методы")
    P.append(f"Сгенерировано: {datetime.datetime.now().isoformat(timespec='seconds')}")
    P.append(f"Команда: python {' '.join(sys.argv)}")
    P.append("")
    P.append("Как применять (вручную, после ревью):")
    P.append(f"  1. CSV:   дописать строки из секции [1] в registry/functions.csv")
    P.append(f"            (или перезапустить с --apply — генератор допишет сам)")
    P.append(f"  2. C++:   вставить объявления [2] в секцию Methods .h,")
    P.append(f"            реализации [3] — в .cpp; пересобрать {dll_file}")
    P.append(f"  3. D:     добавить mixin-строки [4] в load-функцию и методы [5]")
    P.append(f"            в класс (перед MANUAL-METHODS); проверить импорты [6]")
    P.append(f"  4. Прогнать тесты модуля и `qte check all`")
    P.append("")

    P.append("─" * 76)
    P.append("[1] registry/functions.csv — новые строки:")
    P.append("─" * 76)
    P.extend(csv_lines or ["(нет)"])
    P.append("")

    P.append("─" * 76)
    P.append(f"[2] C++ .h — объявления (макрос {macro}, проверьте по существующему .h):")
    P.append("─" * 76)
    P.extend(h_snippet or ["(нет)"])
    P.append("")

    P.append("─" * 76)
    P.append("[3] C++ .cpp — реализации:")
    P.append("─" * 76)
    P.extend(cpp_snippet or ["(нет)"])

    P.append("─" * 76)
    P.append("[4] D — mixin-строки в load-функцию:")
    P.append("─" * 76)
    P.extend(mixin_lines or ["(нет)"])
    P.append("")

    P.append("─" * 76)
    P.append("[5] D — новые методы класса:")
    P.append("─" * 76)
    P.extend(d_chunks or ["(нет)"])
    P.append("")

    P.append("─" * 76)
    P.append("[6] D — импорты из генерированного файла (сверьте с вашими):")
    P.append("─" * 76)
    P.extend(import_lines or ["(нет)"])
    P.append("")

    if dup_specs:
        P.append("─" * 76)
        P.append("[7] Отфильтровано как дубли существующих (C++ тело совпадает):")
        P.append("─" * 76)
        for s in dup_specs:
            P.append(f"    {s.func_name}")
        P.append("")

    patch_text = "\n".join(P) + "\n"

    out_path = args.augment_out or f"augment_{cls.lower()}.patch.txt"
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(patch_text)
    print(f"[augment] патч записан: {out_path}")

    # ── 7. Реестр ─────────────────────────────────────────────────────────
    if args.apply:
        reg.save()
        print(f"[augment] --apply: {len(csv_lines)} строк дописаны в {reg.csv_path}")
    else:
        print(f"[augment] реестр НЕ изменён (для записи CSV — повторите с --apply)")

    return 0
