"""
scan_augment.py — сканирование всех модулей реестра на полноту покрытия.

Для каждого модуля из registry/functions.csv запускает `main.py --augment`
(без --apply, на копии CSV — реестр не изменяется) и собирает количество
недостающих методов/сигналов. Печатает отчёт по убыванию «дырявости».

Запуск:  py scan_augment.py [топN]
"""

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

GEN_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(GEN_DIR)
CSV_REAL = os.path.join(ROOT, "registry", "functions.csv")


def main():
    top_n = int(sys.argv[1]) if len(sys.argv) > 1 else 30

    kb = json.load(open(os.path.join(GEN_DIR, "knowledge", "qt_knowledge.json"),
                        encoding="utf-8"))
    class_header = kb["class_header"]

    # Уникальные модули из реестра
    modules = []
    seen = set()
    with open(CSV_REAL, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = [p.strip() for p in line.split(",")]
            if len(parts) >= 3 and parts[2] not in seen:
                seen.add(parts[2])
                modules.append(parts[2])

    tmpdir = tempfile.mkdtemp(prefix="qte56_scan_")
    csv_copy = os.path.join(tmpdir, "functions.csv")
    results = []
    errors = []

    for i, mod in enumerate(modules, 1):
        header_rel = class_header.get(mod)
        if not header_rel:
            errors.append((mod, "нет заголовка в knowledge"))
            continue
        header = os.path.join(kb["qt_include"], header_rel.replace("/", os.sep))
        if not os.path.exists(header):
            errors.append((mod, f"заголовок не найден: {header_rel}"))
            continue
        shutil.copy(CSV_REAL, csv_copy)  # свежая копия на каждый модуль
        cmd = [sys.executable, os.path.join(GEN_DIR, "main.py"), header,
               "--module", mod, "--augment",
               "--augment-out", os.path.join(tmpdir, "patch.txt"),
               "--csv", csv_copy]
        try:
            out = subprocess.run(cmd, capture_output=True, text=True,
                                 encoding="utf-8", errors="replace",
                                 cwd=GEN_DIR, timeout=120)
        except subprocess.TimeoutExpired:
            errors.append((mod, "timeout"))
            continue
        text = out.stdout + out.stderr
        m = re.search(r"\[augment-count\] \S+ methods=(\d+) signals=(\d+)", text)
        if m:
            n_m, n_s = int(m.group(1)), int(m.group(2))
            results.append((mod, n_m, n_s, n_m + n_s))
        elif "[augment]" in text and "0" in text:
            results.append((mod, 0, 0, 0))
        else:
            tail = " | ".join(text.strip().splitlines()[-2:])
            errors.append((mod, f"нет результата augment: {tail[:120]}"))
        print(f"\r[{i}/{len(modules)}] {mod}...", end="", flush=True)
    print()

    results.sort(key=lambda r: -r[3])
    print(f"\n{'Модуль':<28} {'+методов':>8} {'+сигналов':>9} {'всего':>6}")
    print("-" * 56)
    for mod, n_m, n_s, total in results[:top_n]:
        if total == 0:
            break
        print(f"{mod:<28} {n_m:>8} {n_s:>9} {total:>6}")

    zeros = sum(1 for r in results if r[3] == 0)
    print(f"\nПолных модулей (0 недостающих): {zeros} из {len(results)}")
    if errors:
        print(f"\nНе удалось проверить ({len(errors)}):")
        for mod, why in errors:
            # консоль cp1251: выкидываем символы вроде '─' из захваченного вывода
            safe = why.encode("cp1251", "replace").decode("cp1251")
            print(f"  {mod:<28} {safe}")

    shutil.rmtree(tmpdir, ignore_errors=True)


if __name__ == "__main__":
    main()
