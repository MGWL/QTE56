# -*- coding: utf-8 -*-
"""
test_new_class.py — harness проверки генерации НОВОГО Qt-класса.

Полный цикл для одного класса:
  1. генерация (main.py) во временный каталог на КОПИИ registry/functions.csv
     (настоящий реестр не изменяется);
  2. g++ -fsyntax-only для сгенерированного qte56_<cls>.cpp;
  3. dmd -c для сгенерированного gen_<cls>.d (импорты резолвятся через -Id -Id/gen
     реального проекта — проверяется совместимость с существующими модулями);
  4. отчёт PASS/FAIL по каждому шагу.

Использование:
  python test_new_class.py <путь_к_заголовку.h> [--module NAME] [--d-parent NAME]
                           [--qt-mod "core widgets"] [--keep]

Пример:
  python test_new_class.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qkeysequenceedit.h

Опции:
  --keep   не удалять временный каталог (путь печатается в отчёте).

Замечание: если реестр не может выдать индексы (pFunQt заполнен,
PFUNQT_SIZE=25000), шаг генерации падает с понятной ошибкой — это
ожидаемое поведение защиты registry.py.
"""

import argparse
import os
import shutil
import subprocess
import sys
import tempfile

# Консоль Windows (cp1251): не падаем на печати unicode-диагностики
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# ── Конфигурация путей (можно переопределить переменными окружения) ──────────

QT_INCLUDE = os.environ.get(
    "QTE56_QT_INCLUDE", r"C:/Qt5_13_2/5.13.2/mingw73_32/include")
GEN_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(GEN_DIR)
REAL_REGISTRY = os.path.join(PROJECT_ROOT, "registry", "functions.csv")
D_SRC = os.path.join(PROJECT_ROOT, "d")
D_GEN = os.path.join(D_SRC, "gen")
LIFECYCLE_H = os.path.join(
    PROJECT_ROOT, "cpp", "qt5", "qte56_qobject", "qte56_lifecycle.h")


def _find_tool(name: str, fallback_dir: str) -> str:
    """Ищет утилиту в PATH, затем в fallback_dir."""
    found = shutil.which(name)
    if found:
        return found
    candidate = os.path.join(fallback_dir, name + ".exe")
    return candidate if os.path.exists(candidate) else name


def _run(cmd: list, **kw) -> subprocess.CompletedProcess:
    return subprocess.run(
        cmd, capture_output=True, text=True, encoding="utf-8",
        errors="replace", **kw)


def main() -> int:
    ap = argparse.ArgumentParser(description="Harness генерации нового Qt-класса")
    ap.add_argument("header", help="путь к Qt .h файлу")
    ap.add_argument("--module", default=None)
    ap.add_argument("--d-parent", default=None, dest="d_parent")
    ap.add_argument("--qt-mod", default="core widgets")
    ap.add_argument("--index-start", type=int, default=None, dest="index_start",
                    help="Явное начало блока индексов (дыры: `qte index gaps`). "
                         "Передаётся в main.py --index-start.")
    ap.add_argument("--keep", action="store_true")
    args = ap.parse_args()

    header = os.path.abspath(args.header)
    if not os.path.exists(header):
        print(f"FAIL: заголовок не найден: {header}")
        return 1

    gxx = _find_tool("g++", r"C:/Qt5_13_2/Tools/mingw730_32/bin")
    dmd = _find_tool("dmd", r"C:/d/dmd2/windows/bin")

    tmp = tempfile.mkdtemp(prefix="qte56_harness_")
    steps = []  # (name, ok, details)

    try:
        # ── Шаг 1: генерация на копии реестра ─────────────────────────────
        reg_copy = os.path.join(tmp, "functions.csv")
        shutil.copyfile(REAL_REGISTRY, reg_copy)
        cpp_out = os.path.join(tmp, "cpp")
        d_out = os.path.join(tmp, "d")

        gen_cmd = [
            sys.executable, os.path.join(GEN_DIR, "main.py"), header,
            "--csv", reg_copy,
            "--cpp-out", cpp_out,
            "--d-out", d_out,
            "--qt-mod", args.qt_mod,
        ]
        if args.module:
            gen_cmd += ["--module", args.module]
        if args.d_parent:
            gen_cmd += ["--d-parent", args.d_parent]
        if args.index_start is not None:
            gen_cmd += ["--index-start", str(args.index_start)]

        r = _run(gen_cmd, cwd=GEN_DIR)
        gen_log = (r.stdout + r.stderr).strip()
        if r.returncode != 0:
            steps.append(("generate", False, gen_log))
            _report(steps, tmp, args.keep)
            return 1
        steps.append(("generate", True, gen_log))

        # Находим сгенерированные файлы (имя класса из вывода "Found: X")
        cls_name = None
        for line in gen_log.splitlines():
            if line.startswith("Found:"):
                cls_name = line.split(":", 1)[1].split(":")[0].strip()
                break
        if not cls_name:
            cls_name = "unknown"
            cpp_file = None
        else:
            # main.py пишет qte56_<cls>.{h,cpp,pro} прямо в --cpp-out
            cpp_file = os.path.join(
                cpp_out, f"qte56_{cls_name.lower()}.cpp")
        d_file = os.path.join(d_out, f"gen_{cls_name.lower()}.d")

        # ── Шаг 2: g++ -fsyntax-only ──────────────────────────────────────
        if not cpp_file or not os.path.exists(cpp_file):
            steps.append(("g++ syntax", False, f"cpp не найден: {cpp_file}"))
        else:
            # lifecycle header подключается как ../qte56_qobject/qte56_lifecycle.h
            lc_dir = os.path.join(os.path.dirname(os.path.dirname(cpp_file)),
                                  "qte56_qobject")
            os.makedirs(lc_dir, exist_ok=True)
            shutil.copyfile(LIFECYCLE_H,
                            os.path.join(lc_dir, "qte56_lifecycle.h"))
            qt_sub = os.path.basename(os.path.dirname(header))  # QtWidgets и т.д.
            incs = [QT_INCLUDE,
                    os.path.join(QT_INCLUDE, qt_sub),
                    os.path.join(QT_INCLUDE, "QtCore"),
                    os.path.join(QT_INCLUDE, "QtGui"),
                    os.path.join(QT_INCLUDE, "QtWidgets")]
            cmd = [gxx, "-m32", "-fsyntax-only"]
            for i in incs:
                cmd += ["-I", i]
            cmd.append(cpp_file)
            r = _run(cmd)
            ok = (r.returncode == 0)
            steps.append(("g++ syntax", ok,
                          (r.stdout + r.stderr).strip() or "OK"))

        # ── Шаг 3: dmd -c ─────────────────────────────────────────────────
        if not os.path.exists(d_file):
            steps.append(("dmd compile", False, f"d не найден: {d_file}"))
        else:
            obj = os.path.join(tmp, "check.obj")
            cmd = [dmd, "-m32", "-i", "-c", d_file,
                   f"-I{D_SRC}", f"-I{D_GEN}", f"-of={obj}"]
            r = _run(cmd)
            ok = (r.returncode == 0)
            steps.append(("dmd compile", ok,
                          (r.stdout + r.stderr).strip() or "OK"))

        all_ok = all(ok for _, ok, _ in steps)
        _report(steps, tmp, args.keep or not all_ok)
        return 0 if all_ok else 1
    finally:
        if not args.keep and os.path.exists(tmp):
            # Удаляем temp только при полном успехе без --keep
            if all(ok for _, ok, _ in steps):
                shutil.rmtree(tmp, ignore_errors=True)


def _report(steps: list, tmp: str, keep: bool) -> None:
    print()
    print("=" * 60)
    for name, ok, details in steps:
        mark = "PASS" if ok else "FAIL"
        print(f"[{mark}] {name}")
        if not ok and details:
            for line in details.splitlines()[:30]:
                print(f"      {line}")
    print("=" * 60)
    if keep:
        print(f"Временный каталог сохранён: {tmp}")
    total = "PASS" if all(ok for _, ok, _ in steps) else "FAIL"
    print(f"HARNESS: {total}")


if __name__ == "__main__":
    sys.exit(main())
