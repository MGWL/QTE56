#!/usr/bin/env python3
"""
scan_ldc2_bugs.py — сканирует d/gen/gen_*.d на баги совместимости DMD/ldc2.

Баг 1: класс вызывает super(true) / super(false) / super(_noOp),
        но родительский класс не имеет this(bool _noOp).

Баг 2: функциональный указатель (cast(t_XXX)pFunQt[N])(args...)
        — количество аргументов в alias не совпадает с количеством в вызове.
"""

import re, sys
from pathlib import Path

# ── Найти корень проекта ───────────────────────────────────────────────────────
def find_root():
    p = Path(__file__).resolve().parent.parent
    if (p / 'd' / 'gen').is_dir():
        return p
    p = Path.cwd()
    while p != p.parent:
        if (p / 'd' / 'gen').is_dir():
            return p
        p = p.parent
    sys.exit("ERROR: не найден корень проекта")

root    = find_root()
gen_dir = root / 'd' / 'gen'

# ── Читаем все gen_*.d ────────────────────────────────────────────────────────
files = sorted(gen_dir.glob('gen_*.d'))
print(f"Сканирование {len(files)} файлов в {gen_dir}\n")

# ── Структуры для Бага 1 ───────────────────────────────────────────────────────
# class_info[ClassName] = {file, parent, has_bool_ctor}
class_info = {}

for f in files:
    text = f.read_text(encoding='utf-8', errors='replace')
    lines = text.splitlines()
    current_class = None
    for i, line in enumerate(lines, 1):
        # class QFoo : QBar
        m = re.match(r'\s*class\s+(Q\w+)\s*(?::\s*(Q\w+))?', line)
        if m:
            current_class = m.group(1)
            parent = m.group(2)
            class_info[current_class] = {
                'file': f.name,
                'parent': parent,
                'has_bool_ctor':  False,
                'has_noarg_ctor': False,
            }
        # protected this(bool _noOp)
        if current_class and re.search(r'this\s*\(\s*bool\s+\w+\s*\)', line):
            class_info[current_class]['has_bool_ctor'] = True
        # this() { ... }
        if current_class and re.search(r'this\s*\(\s*\)', line):
            class_info[current_class]['has_noarg_ctor'] = True

# ── Баг 1: super(true/false/_noOp) без bool-ктора у родителя ─────────────────
print("=" * 60)
print("БАГ 1: super(true/false) без this(bool _noOp) у родителя")
print("=" * 60)

bug1_count = 0
for f in files:
    text = f.read_text(encoding='utf-8', errors='replace')
    lines = text.splitlines()
    current_class = None
    for i, line in enumerate(lines, 1):
        m = re.match(r'\s*class\s+(Q\w+)', line)
        if m:
            current_class = m.group(1)

        if not current_class:
            continue
        info = class_info.get(current_class, {})
        parent = info.get('parent')
        if not parent:
            continue
        parent_info = class_info.get(parent, {})

        # super(true) / super(false) / super(_noOp) — у родителя нет this(bool)
        if re.search(r'super\s*\(\s*(true|false|_noOp)\s*\)', line):
            if not parent_info.get('has_bool_ctor', False):
                print(f"  {f.name}:{i}")
                print(f"    {current_class} -> super(bool) -> {parent} не имеет this(bool _noOp)")
                print(f"    Строка: {line.strip()}")
                bug1_count += 1

        # this() {} без аргументов — у родителя нет this() (только this(void*) или this(bool))
        if re.search(r'this\s*\(\s*\)\s*\{?\s*\}', line):
            has_noarg = parent_info.get('has_noarg_ctor', False)
            has_bool  = parent_info.get('has_bool_ctor', False)
            if not has_noarg and not has_bool:
                print(f"  {f.name}:{i}")
                print(f"    {current_class}.this() -> implicit super() -> {parent} не имеет this()")
                print(f"    Строка: {line.strip()}")
                bug1_count += 1

if bug1_count == 0:
    print("  Ошибок не найдено.")
print()

# ── Баг 2: несовпадение числа аргументов в cast функции ───────────────────────
print("=" * 60)
print("БАГ 2: несовпадение числа аргументов (alias vs вызов)")
print("=" * 60)

def count_alias_args(alias: str) -> int:
    """t_ret__arg1_arg2_arg3 -> 3 (число аргументов по имени alias)."""
    # Разбиваем на return и args части
    if '__' not in alias:
        return -1
    args_part = alias.split('__', 1)[1]
    if not args_part:
        return 0
    # Токены: qp, i, b, d, ip, s и т.п. — разделены '_'
    # Но нужно учесть что 'ip' — двухбуквенный токен, не два токена
    # Просто считаем '_'-разделённые части
    tokens = args_part.split('_')
    # Убираем пустые (на случай trailing _)
    return len([t for t in tokens if t])

def count_call_args(call_args: str) -> int:
    """Считаем аргументы в строке вызова (разделены запятыми на уровне 0)."""
    if not call_args.strip():
        return 0
    depth = 0
    count = 1
    for ch in call_args:
        if ch in '([{':
            depth += 1
        elif ch in ')]}':
            depth -= 1
        elif ch == ',' and depth == 0:
            count += 1
    return count

# Паттерн: (cast(t_ALIAS)pFunQt[N])(ARGS)
# Ищем по одной строке (большинство вызовов однострочные)
CAST_RE = re.compile(
    r'\(cast\((t_[a-z_]+)\)pFunQt\[\d+\]\)'   # cast и индекс
    r'\(([^;{}\n]*)\)'                           # аргументы вызова
)

bug2_count = 0
for f in files:
    text = f.read_text(encoding='utf-8', errors='replace')
    for i, line in enumerate(text.splitlines(), 1):
        for m in CAST_RE.finditer(line):
            alias    = m.group(1)
            call_str = m.group(2)
            n_alias  = count_alias_args(alias)
            n_call   = count_call_args(call_str)
            if n_alias < 0:
                continue
            if n_alias != n_call:
                print(f"  {f.name}:{i}")
                print(f"    alias={alias} -> ожидает {n_alias} арг., передано {n_call}")
                print(f"    {line.strip()}")
                bug2_count += 1

if bug2_count == 0:
    print("  Ошибок не найдено.")
print()

# ── Итог ──────────────────────────────────────────────────────────────────────
print("=" * 60)
total = bug1_count + bug2_count
print(f"Итого: {total} проблем (баг1={bug1_count}, баг2={bug2_count})")
print("=" * 60)
