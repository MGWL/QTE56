"""
registry.py — работа с functions.csv реестром.

Реестр — единственный источник истины об индексах функций.
Индексы никогда не меняются после первого назначения.
"""

import csv
import os
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class FuncEntry:
    index:       int
    func_name:   str
    module_name: str
    dll_file:    str
    category:    str = ""


class Registry:
    """Загружает, изменяет и сохраняет functions.csv."""

    COMMENT_MARKER = "#"
    BLOCK_SIZE = 1000  # индексов на один класс

    # Верхняя граница индексов: размер pFunQt в d/qte56_core.d (PFUNQT_SIZE).
    # Назначение индекса >= PFUNQT_SIZE даёт D-код, который не компилируется
    # ("array index N is out of bounds pFunQt[0 .. 25000]").
    PFUNQT_SIZE = 25000

    # Зарезервированные блоки (не менять):
    RESERVED_BLOCKS = {
        "QCore": (1, 99),
        # QWidget: (1000, 1999)  — назначается при первой генерации QWidget
        # QFrame:  (2000, 2999)  — и т.д.
    }

    def __init__(self, csv_path: str):
        self.csv_path = csv_path
        self.entries: list[FuncEntry] = []
        self._raw_lines: list[str] = []  # сохраняем для вывода с комментариями
        if os.path.exists(csv_path):
            self._load()

    # ──────────────────────────────────────────────────────────────────────
    # Загрузка

    def _load(self):
        with open(self.csv_path, encoding="utf-8") as f:
            self._raw_lines = f.readlines()

        for line in self._raw_lines:
            stripped = line.strip()
            if not stripped or stripped.startswith(self.COMMENT_MARKER):
                continue
            parts = [p.strip() for p in stripped.split(",")]
            if len(parts) < 4:
                continue
            try:
                e = FuncEntry(
                    index=int(parts[0]),
                    func_name=parts[1],
                    module_name=parts[2],
                    dll_file=parts[3],
                    category=parts[4] if len(parts) > 4 else "",
                )
                self.entries.append(e)
            except ValueError:
                pass  # строка с нечисловым индексом — пропускаем

    # ──────────────────────────────────────────────────────────────────────
    # Запросы

    def get_by_name(self, func_name: str) -> Optional[FuncEntry]:
        for e in self.entries:
            if e.func_name == func_name:
                return e
        return None

    def get_by_module(self, module_name: str) -> list[FuncEntry]:
        return [e for e in self.entries if e.module_name == module_name]

    def get_max_index(self) -> int:
        return max((e.index for e in self.entries), default=0)

    def module_block_start(self, module_name: str) -> Optional[int]:
        """Возвращает начальный индекс блока модуля, или None если модуль не зарегистрирован."""
        entries = self.get_by_module(module_name)
        if not entries:
            return None
        return min(e.index for e in entries)

    # ──────────────────────────────────────────────────────────────────────
    # Выделение нового блока для класса

    def assign_block(self, module_name: str, dll_file: str,
                     force_start: int | None = None) -> int:
        """
        Выделяет блок индексов для нового модуля.
        Возвращает начальный индекс блока.
        Если модуль уже существует — возвращает его текущий начальный индекс.
        force_start — явное начало блока (размещение в дыре нумерации,
        см. `qte index gaps`); коллизии ловятся в add_entry.
        """
        existing = self.module_block_start(module_name)
        if existing is not None:
            return existing

        if force_start is not None:
            if force_start <= 0 or force_start >= self.PFUNQT_SIZE:
                raise ValueError(
                    f"--index-start {force_start} вне диапазона 1..{self.PFUNQT_SIZE - 1}"
                )
            return force_start

        # Ищем следующий свободный блок кратный BLOCK_SIZE
        max_idx = self.get_max_index()
        # Округляем вверх до следующего кратного BLOCK_SIZE
        if max_idx < self.BLOCK_SIZE:
            next_block = self.BLOCK_SIZE  # первый блок после QCore (1-99)
        else:
            next_block = ((max_idx // self.BLOCK_SIZE) + 1) * self.BLOCK_SIZE

        return next_block

    # ──────────────────────────────────────────────────────────────────────
    # Добавление записей

    def add_entry(self, entry: FuncEntry) -> bool:
        """Добавляет запись. Возвращает False если функция уже существует."""
        if self.get_by_name(entry.func_name) is not None:
            return False
        # Проверяем коллизию индекса
        for e in self.entries:
            if e.index == entry.index:
                raise ValueError(
                    f"Index {entry.index} already used by '{e.func_name}'"
                )
        # Проверяем переполнение pFunQt
        if entry.index >= self.PFUNQT_SIZE:
            raise ValueError(
                f"Index {entry.index} for '{entry.func_name}' exceeds "
                f"PFUNQT_SIZE ({self.PFUNQT_SIZE}). Таблица pFunQt заполнена: "
                f"либо увеличьте PFUNQT_SIZE в d/qte56_core.d (и PFUNQT_SIZE здесь), "
                f"либо используйте свободные дыры в нумерации (`qte index gaps`)."
            )
        self.entries.append(entry)
        return True

    def add_class_functions(
        self,
        module_name: str,
        dll_file: str,
        func_names: list[str],
        categories: list[str] | None = None,
        force_block_start: int | None = None,
    ) -> dict[str, int]:
        """
        Добавляет список функций для нового класса.
        Автоматически выделяет блок индексов.
        Возвращает dict: func_name → index.
        """
        block_start = self.assign_block(module_name, dll_file, force_block_start)
        # Используем следующий свободный индекс внутри блока
        used = {e.index for e in self.entries}
        idx = block_start
        result = {}

        for i, fname in enumerate(func_names):
            # Пропускаем уже существующие
            existing = self.get_by_name(fname)
            if existing is not None:
                result[fname] = existing.index
                continue
            # Ищем свободный индекс в блоке
            while idx in used or idx == 0:
                idx += 1
            if categories:
                cat = categories[i] if i < len(categories) else ""
            else:
                cat = ""
            entry = FuncEntry(
                index=idx,
                func_name=fname,
                module_name=module_name,
                dll_file=dll_file,
                category=cat,
            )
            self.add_entry(entry)
            result[fname] = idx
            used.add(idx)
            idx += 1

        return result

    # ──────────────────────────────────────────────────────────────────────
    # Сохранение (сохраняем комментарии из оригинального файла)

    def save(self):
        os.makedirs(os.path.dirname(self.csv_path), exist_ok=True)

        # Собираем все индексы из исходного файла
        existing_indices = set()
        for line in self._raw_lines:
            stripped = line.strip()
            if stripped and not stripped.startswith(self.COMMENT_MARKER):
                parts = [p.strip() for p in stripped.split(",")]
                try:
                    existing_indices.add(int(parts[0]))
                except (ValueError, IndexError):
                    pass

        # Новые записи (которых не было в исходном файле)
        new_entries = [e for e in self.entries if e.index not in existing_indices]

        with open(self.csv_path, "w", encoding="utf-8", newline="") as f:
            # Пишем исходные строки (с комментариями)
            for line in self._raw_lines:
                f.write(line)

            # Дописываем новые записи
            if new_entries:
                f.write("\n")
                # Группируем по модулю
                modules = {}
                for e in new_entries:
                    modules.setdefault(e.module_name, []).append(e)

                for mod, entries in modules.items():
                    f.write(f"# ── {mod} ({'─' * (40 - len(mod))})\n")
                    for e in sorted(entries, key=lambda x: x.index):
                        f.write(
                            f"{e.index},{e.func_name},{e.module_name},{e.dll_file},{e.category}\n"
                        )


# ──────────────────────────────────────────────────────────────────────────────
# CLI: показать содержимое реестра

if __name__ == "__main__":
    import sys

    path = sys.argv[1] if len(sys.argv) > 1 else "../registry/functions.csv"
    reg = Registry(path)

    print(f"Registry: {path}  ({len(reg.entries)} entries)")
    print(f"{'Index':>6}  {'Module':<12}  {'Function':<40}  {'DLL'}")
    print("-" * 90)
    for e in sorted(reg.entries, key=lambda x: x.index):
        print(f"{e.index:>6}  {e.module_name:<12}  {e.func_name:<40}  {e.dll_file}")
