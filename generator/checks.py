"""
checks.py — preflight-проверки генератора.

Запускаются ДО планирования методов и записи файлов (и повторно перед
сохранением реестра). Каждая проверка возвращает CheckResult со статусом
OK / WARN / FAIL. Любой FAIL — генерация прерывается до записи чего-либо
(кроме явного --force).

Проверки закрывают баги, найденные экспериментом с QShortcut (2026-07-26):
  - имя DLL молча генерировалось по шаблону и расходилось с реестром;
  - --index-start молча игнорировался для уже существующего класса;
  - переиспользование имён функций из реестра проходило без предупреждения.
"""

import os
from dataclasses import dataclass

from registry import Registry


@dataclass
class CheckResult:
    status:  str   # "OK" | "WARN" | "FAIL"
    name:    str   # короткое имя проверки
    message: str = ""

    def __str__(self):
        s = f"  [{self.status}] {self.name}"
        if self.message:
            s += f": {self.message}"
        return s


def has_fail(results: list) -> bool:
    return any(r.status == "FAIL" for r in results)


def print_results(results: list) -> None:
    for r in results:
        print(str(r))


# ─────────────────────────────────────────────────────────────────────────────
# 1. Заголовок и распарсенный класс

def check_header(header: str, qt_class) -> list:
    """Файл существует, класс распарсен, есть хотя бы 1 поддерживаемый метод."""
    results = []
    if not os.path.exists(header):
        results.append(CheckResult("FAIL", "header", f"файл не найден: {header}"))
        return results
    if qt_class is None:
        results.append(CheckResult("FAIL", "header", "Qt класс не найден в заголовке"))
        return results
    supported = sum(1 for m in qt_class.methods
                    if m.is_supported and not m.is_signal and not m.is_protected)
    if supported == 0:
        results.append(CheckResult(
            "WARN", "header",
            f"класс {qt_class.name}: 0 поддерживаемых методов "
            f"(все {len(qt_class.methods)} unsupported/protected) — "
            f"будет сгенерирован почти пустой модуль"))
    else:
        results.append(CheckResult("OK", "header",
                                   f"{qt_class.name}: {supported} поддерживаемых методов"))
    return results


# ─────────────────────────────────────────────────────────────────────────────
# 2. Целостность реестра (эквивалент `qte index check` до старта)

def check_registry(reg: Registry) -> list:
    """Коллизии индексов и дубликаты имён в уже загруженном реестре."""
    results = []
    seen_idx: dict[int, str] = {}
    idx_dupes = []
    for e in reg.entries:
        if e.index in seen_idx:
            idx_dupes.append(f"{e.index}: '{seen_idx[e.index]}' vs '{e.func_name}'")
        else:
            seen_idx[e.index] = e.func_name
    if idx_dupes:
        results.append(CheckResult(
            "FAIL", "registry",
            f"коллизии индексов в {reg.csv_path}: " + "; ".join(idx_dupes[:5])))
    else:
        results.append(CheckResult("OK", "registry",
                                   f"{len(reg.entries)} записей, коллизий нет"))

    seen_names: dict[str, int] = {}
    name_dupes = []
    for e in reg.entries:
        if e.func_name in seen_names:
            name_dupes.append(f"'{e.func_name}' ({seen_names[e.func_name]}, {e.index})")
        else:
            seen_names[e.func_name] = e.index
    if name_dupes:
        # Дубликаты имён известны в проекте (2 шт., см. AGENTS.md §18) — WARN, не FAIL
        results.append(CheckResult(
            "WARN", "registry",
            f"дубликаты имён функций: " + "; ".join(name_dupes[:5])))
    return results


# ─────────────────────────────────────────────────────────────────────────────
# 3. Имя DLL: шаблон vs реестр (баг №2 эксперимента QShortcut)

def resolve_dll_name(reg: Registry, module_name: str, cls_name: str,
                     dll_arg: str | None) -> tuple:
    """
    Возвращает (dll_file, results).
    Если класс уже есть в реестре и --dll не задан — берём имя DLL из реестра,
    а не шаблон qte56_<cls>.dll. Если --dll задан и расходится — WARN.
    """
    results = []
    template = f"qte56_{cls_name.lower()}.dll"
    existing = reg.get_by_module(module_name)
    existing_dlls = {e.dll_file for e in existing}

    if existing_dlls:
        reg_dll = sorted(existing_dlls)[0]
        if len(existing_dlls) > 1:
            results.append(CheckResult(
                "WARN", "dll-name",
                f"модуль {module_name} размазан по нескольким DLL в реестре: "
                + ", ".join(sorted(existing_dlls))))
        if dll_arg is None:
            if reg_dll != template:
                results.append(CheckResult(
                    "OK", "dll-name",
                    f"класс уже в реестре — берём DLL из реестра: {reg_dll} "
                    f"(шаблон дал бы {template})"))
            else:
                results.append(CheckResult("OK", "dll-name", reg_dll))
            return reg_dll, results
        elif dll_arg not in existing_dlls:
            results.append(CheckResult(
                "WARN", "dll-name",
                f"--dll {dll_arg} расходится с реестром ({reg_dll}); "
                f"registerModule в gen-файле будет грузить {dll_arg}"))
            return dll_arg, results
        return dll_arg, results

    # Новый класс
    dll_file = dll_arg or template
    results.append(CheckResult("OK", "dll-name",
                               f"новый класс, DLL: {dll_file}"))
    return dll_file, results


# ─────────────────────────────────────────────────────────────────────────────
# 4. --index-start

def check_index_start(reg: Registry, module_name: str,
                      index_start: int | None) -> list:
    """index-start на существующем классе → WARN (игнорируется);
    вне диапазона → FAIL; стартовый индекс занят → FAIL."""
    results = []
    if index_start is None:
        return results
    if index_start <= 0 or index_start >= Registry.PFUNQT_SIZE:
        results.append(CheckResult(
            "FAIL", "index-start",
            f"{index_start} вне диапазона 1..{Registry.PFUNQT_SIZE - 1}"))
        return results
    if reg.module_block_start(module_name) is not None:
        results.append(CheckResult(
            "WARN", "index-start",
            f"--index-start {index_start} не использован: модуль {module_name} "
            f"уже в реестре (блок с {reg.module_block_start(module_name)}); "
            f"новые методы получат индексы после существующего блока"))
        return results
    used = {e.index for e in reg.entries}
    if index_start in used:
        results.append(CheckResult(
            "FAIL", "index-start",
            f"индекс {index_start} уже занят "
            f"({reg.get_by_name(next(e.func_name for e in reg.entries if e.index == index_start))})"))
    else:
        results.append(CheckResult("OK", "index-start", str(index_start)))
    return results


# ─────────────────────────────────────────────────────────────────────────────
# 5. Переиспользование имён функций (пост-план, перед записью/сохранением)

def check_reused_names(reg: Registry, planned_func_names: list,
                       module_name: str, dll_file: str) -> list:
    """
    Для каждого планируемого имени, уже существующего в реестре:
    индекс будет переиспользован. Если запись принадлежит другому модулю
    или другой DLL — WARN (потенциальный signature-drift: одно имя/индекс,
    а сигнатуры в старой DLL и новом коде могут различаться — баг №1
    эксперимента QShortcut, полностью в CSV не проверить).
    """
    results = []
    reused = []
    mismatched = []
    for fname in planned_func_names:
        e = reg.get_by_name(fname)
        if e is None:
            continue
        reused.append(f"{fname} → {e.index}")
        if e.module_name != module_name or e.dll_file != dll_file:
            mismatched.append(
                f"{fname} [{e.index}]: реестр ({e.module_name}, {e.dll_file}) "
                f"vs план ({module_name}, {dll_file})")
    if mismatched:
        results.append(CheckResult(
            "WARN", "reused-names",
            f"{len(mismatched)} имён переиспользуются с другим модулем/DLL: "
            + "; ".join(mismatched[:5])))
    elif reused:
        results.append(CheckResult(
            "OK", "reused-names",
            f"{len(reused)} существующих имён переиспользованы (индексы сохранены)"))
    return results
