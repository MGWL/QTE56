"""
fileops.py — файловые операции генератора: unified diff, запись текста,
инкрементальный --patch существующего D-файла по маркерам AUTO-GENERATED-*.

Выделено из main.py без изменения логики.
"""

import os


def _diff_text(path: str, new_text: str) -> None:
    """Печатает unified diff между файлом path и new_text."""
    import difflib
    import sys
    if not os.path.exists(path):
        print(f"  [diff] {path}: NEW FILE")
        return
    with open(path, encoding="utf-8") as f:
        old_lines = f.readlines()
    new_lines = new_text.splitlines(keepends=True)
    # Добавляем \n последней строке если нужно для корректного diff
    if new_lines and not new_lines[-1].endswith("\n"):
        new_lines[-1] += "\n"
    if old_lines and not old_lines[-1].endswith("\n"):
        old_lines[-1] += "\n"
    rel = os.path.relpath(path)
    diff = difflib.unified_diff(
        old_lines, new_lines,
        fromfile=f"a/{rel}", tofile=f"b/{rel}",
    )
    diff_str = "".join(diff)
    if not diff_str:
        print(f"  [diff] {path}: no changes")
        return
    # Windows-консоль может не поддерживать Unicode → выводим как UTF-8
    try:
        print(diff_str, end="")
    except UnicodeEncodeError:
        encoded = diff_str.encode("utf-8", errors="replace")
        sys.stdout.buffer.write(encoded)
        sys.stdout.buffer.flush()


def _patch_d_file(path: str, new_text: str, cls_name: str) -> bool:
    """
    Инкрементально обновляет существующий D-файл, заменяя только блоки
    между маркерами AUTO-GENERATED-*. Ручные правки вне маркеров сохраняются.
    Блок между MANUAL-METHODS-START/END внутри класса также сохраняется.
    Возвращает True если файл был записан.
    """
    if not os.path.exists(path):
        return False  # Нет файла — обычная запись

    with open(path, encoding="utf-8") as f:
        old_text = f.read()

    marker_load_start = "// ===AUTO-GENERATED-LOAD-FUNC-START==="
    marker_load_end   = "// ===AUTO-GENERATED-LOAD-FUNC-END==="
    marker_class_start = "// ===AUTO-GENERATED-CLASS-START==="
    marker_class_end   = "// ===AUTO-GENERATED-CLASS-END==="
    manual_start = "// ===MANUAL-METHODS-START==="
    manual_end   = "// ===MANUAL-METHODS-END==="

    def _replace_block(old: str, start_marker: str, end_marker: str,
                       new_block: str) -> tuple[str, bool]:
        start = old.find(start_marker)
        end = old.find(end_marker)
        if start == -1 or end == -1 or end <= start:
            return old, False
        # Захватываем перенос строки после end_marker
        after = end + len(end_marker)
        if after < len(old) and old[after] == "\n":
            after += 1
        return old[:start] + start_marker + "\n" + new_block + end_marker + "\n" + old[after:], True

    # Извлекаем новые блоки из new_text
    def _extract_block(text: str, start_marker: str, end_marker: str) -> str:
        start = text.find(start_marker)
        end = text.find(end_marker)
        if start == -1 or end == -1 or end <= start:
            return ""
        inner_start = start + len(start_marker)
        if inner_start < len(text) and text[inner_start] == "\n":
            inner_start += 1
        return text[inner_start:end]

    new_load_block = _extract_block(new_text, marker_load_start, marker_load_end)
    new_class_block = _extract_block(new_text, marker_class_start, marker_class_end)

    if not new_load_block or not new_class_block:
        print(f"WARNING: Could not extract generated blocks from new code for {cls_name}")
        return False

    # Сохраняем ручные методы из старого класса
    old_manual = _extract_block(old_text, manual_start, manual_end)
    if old_manual and old_manual.strip():
        # Заменяем пустой manual-блок в новом классе на старый
        new_class_block, _ = _replace_block(
            new_class_block, manual_start, manual_end, old_manual
        )

    patched, ok1 = _replace_block(old_text, marker_load_start, marker_load_end, new_load_block)
    patched, ok2 = _replace_block(patched, marker_class_start, marker_class_end, new_class_block)

    if not (ok1 and ok2):
        print(f"WARNING: Markers not found in {path}; --patch requires markers from generated code.")
        print(f"         Run without --patch to overwrite, or ensure markers are present.")
        return False

    if patched == old_text:
        print(f"  [patch] {path}: no changes")
        return True

    with open(path, "w", encoding="utf-8") as f:
        f.write(patched)
    print(f"  [patch] {path}: updated generated sections")
    return True


def _write_text(path: str, text: str) -> None:
    """Записывает текст в файл, создавая директории при необходимости."""
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)
