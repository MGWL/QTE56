#!/usr/bin/env python3
"""
merge_dlls.py — Merge 67 individual DLLs into 7 groups.

Generates:
  1. Merged .pro files     (cpp/qt5/merged/<group>/<group>.pro)
  2. Updates gen_*.d        (registerModule DLL name)
  3. Umbrella D imports     (d/<group>.d)
  4. build_merged_dlls.bat

Usage:
  cd arch_new/generator
  python merge_dlls.py [--dry-run]
  python merge_dlls.py --revert      (restore original per-module DLL names)
"""

import os
import re
import sys
from pathlib import Path

# ── Paths ─────────────────────────────────────────────────────────────
BASE = Path(__file__).resolve().parent.parent        # arch_new/
CPP_DIR = BASE / "cpp" / "qt5"
GEN_DIR = BASE / "d" / "gen"
D_DIR = BASE / "d"
MERGED_DIR = BASE / "cpp" / "qt5" / "merged"

DRY_RUN = "--dry-run" in sys.argv
REVERT = "--revert" in sys.argv

# ── Group definitions ─────────────────────────────────────────────────
# Key = merged DLL name (without .dll)
# Value = list of module suffixes (e.g. "qwidget" → dir qte56_qwidget, gen_qwidget.d)
# qte56_qcore is NOT here — it stays as a standalone DLL (has MOC/ESlot).
GROUPS = {
    "qte56_foundation": [
        "qobject", "qfont", "qicon", "qcolor", "qpixmap",
        "qtimer", "qsettings", "qclipboard", "qbuttongroup",
        "qfile", "qpainter", "qimage", "qimagereader", "qimagewriter",
        "qpicture", "qdatetime", "qbytearray",
    ],
    "qte56_widgets": [
        "qwidget", "qframe", "qlabel", "qpushbutton", "qcheckbox",
        "qradiobutton", "qcombobox", "qlineedit", "qspinbox",
        "qdoublespinbox", "qslider", "qdial", "qscrollbar",
        "qprogressbar", "qgroupbox", "qtabwidget", "qtabbar",
        "qlcdnumber", "qcalendarwidget", "qlayout",
        "qabstractbutton", "qabstractslider", "qabstractspinbox",
        "qsplitter", "qstackedwidget", "qdatetimeedit",
        "qtextdocument",
    ],
    "qte56_views": [
        "qabstractscrollarea", "qabstractitemview", "qscrollarea",
        "qlistwidget", "qtableview", "qtablewidget",
        "qtreeview", "qtreewidget", "qheaderview",
        "qmdiarea", "qmdisubwindow",
    ],
    "qte56_text": [
        "qplaintextedit", "qtextedit", "qtextbrowser",
        "qtextcursor", "qtextcharformat", "qtextblockformat",
        "qtextblock", "qsyntaxhighlighter",
    ],
    "qte56_dialogs": [
        "qdialog", "qmessagebox", "qfiledialog",
        "qinputdialog", "qfontdialog", "qcolordialog",
        "qprogressdialog",
    ],
    "qte56_mainwin": [
        "qmainwindow", "qmenubar", "qmenu", "qaction",
        "qtoolbar", "qtoolbutton", "qcommandlinkbutton",
        "qstatusbar", "qdockwidget", "qtoolbox",
    ],
}

# Reverse map: module → group name
MODULE_TO_GROUP = {}
for _group, _modules in GROUPS.items():
    for _mod in _modules:
        MODULE_TO_GROUP[_mod] = _group


# ── .pro parser ───────────────────────────────────────────────────────

def _parse_pro_field(text, field):
    """Parse a multi-line field (SOURCES, HEADERS, etc.) from .pro text.
    Returns list of values with backslash continuations resolved."""
    values = []
    capturing = False
    pattern = re.compile(rf'^\s*{field}\s*[+=]+\s*(.*)', re.IGNORECASE)
    for line in text.splitlines():
        if not capturing:
            m = pattern.match(line)
            if m:
                rest = m.group(1).strip()
                if rest.endswith('\\'):
                    values.extend(rest[:-1].split())
                    capturing = True
                else:
                    values.extend(rest.split())
        else:
            stripped = line.strip()
            if stripped.endswith('\\'):
                values.extend(stripped[:-1].split())
            else:
                values.extend(stripped.split())
                capturing = False
    return values


def parse_pro(module):
    """Parse a module's .pro file.
    Returns (qt_modules: set, defines: list, sources: list, headers: list).

    Если отдельного .pro нет (модуль существует только как часть merged DLL),
    SOURCES/HEADERS синтезируются по фактическим файлам qte56_<mod>.cpp/.h.
    """
    pro_path = CPP_DIR / f"qte56_{module}" / f"qte56_{module}.pro"
    if not pro_path.exists():
        mod_dir = CPP_DIR / f"qte56_{module}"
        cpp = mod_dir / f"qte56_{module}.cpp"
        hdr = mod_dir / f"qte56_{module}.h"
        if cpp.exists() and hdr.exists():
            return set(), [], [cpp.name], [hdr.name]
        print(f"  WARNING: neither {pro_path} nor {cpp} found")
        return set(), [], [], []

    text = pro_path.read_text(encoding="utf-8")

    qt_mods = set(_parse_pro_field(text, "QT"))
    defines = _parse_pro_field(text, "DEFINES")
    sources = _parse_pro_field(text, "SOURCES")
    headers = _parse_pro_field(text, "HEADERS")

    return qt_mods, defines, sources, headers


# ── Step 1: Generate merged .pro files ────────────────────────────────

def generate_merged_pro(group_name, modules):
    """Create cpp/qt5/merged/<group>/<group>.pro with multi-SOURCES approach."""
    group_dir = MERGED_DIR / group_name
    pro_path = group_dir / f"{group_name}.pro"

    all_qt = set()
    all_defines = []
    all_includes = []
    all_sources = []
    all_headers = []

    for mod in modules:
        mod_dir = f"qte56_{mod}"
        qt_mods, _defines, sources, headers = parse_pro(mod)

        all_qt |= qt_mods

        # DEFINES — always use canonical QTE56_<MOD>_BUILD
        # (some .pro files lack this or have irrelevant defines like QT_NO_DEBUG)
        canonical_def = f"QTE56_{mod.upper()}_BUILD"
        if canonical_def not in all_defines:
            all_defines.append(canonical_def)

        # INCLUDEPATH — so each .cpp finds its own .h
        all_includes.append(f"../../{mod_dir}")

        # SOURCES — relative path from merged dir to original source
        for s in sources:
            all_sources.append(f"../../{mod_dir}/{s}")

        # HEADERS
        for h in headers:
            all_headers.append(f"../../{mod_dir}/{h}")

    # Ensure at least core widgets
    if not all_qt:
        all_qt = {"core", "widgets"}

    # Stable ordering
    qt_sorted = sorted(all_qt)

    # Build .pro content
    lines = []
    lines.append(f"# {group_name}.pro — merged DLL (auto-generated by merge_dlls.py)")
    lines.append(f"# Modules: {', '.join(modules)}")
    lines.append(f"#")
    lines.append(f"")
    lines.append(f"QT       += {' '.join(qt_sorted)}")
    lines.append(f"TARGET    = {group_name}")
    lines.append(f"TEMPLATE  = lib")
    lines.append(f"CONFIG   += shared c++11")
    lines.append(f"CONFIG   -= debug_and_release")
    lines.append(f"")

    # DEFINES
    if all_defines:
        lines.append(f"DEFINES  += \\")
        for i, d in enumerate(all_defines):
            suffix = " \\" if i < len(all_defines) - 1 else ""
            lines.append(f"    {d}{suffix}")
        lines.append(f"")

    # INCLUDEPATH
    lines.append(f"INCLUDEPATH += \\")
    for i, inc in enumerate(all_includes):
        suffix = " \\" if i < len(all_includes) - 1 else ""
        lines.append(f"    {inc}{suffix}")
    lines.append(f"")

    # SOURCES
    lines.append(f"SOURCES  += \\")
    for i, src in enumerate(all_sources):
        suffix = " \\" if i < len(all_sources) - 1 else ""
        lines.append(f"    {src}{suffix}")
    lines.append(f"")

    # HEADERS
    if all_headers:
        lines.append(f"HEADERS  += \\")
        for i, hdr in enumerate(all_headers):
            suffix = " \\" if i < len(all_headers) - 1 else ""
            lines.append(f"    {hdr}{suffix}")
        lines.append(f"")

    # DESTDIR — выбор папки назначения по QTE56_ARCH (32/64, unix, macx)
    lines.append(f"# Выбор папки назначения по QTE56_ARCH (32 или 64)")
    lines.append(f"# Настройка компилятора через PATH (a.cmd)")
    lines.append(f"QTE56_ARCH = $$(QTE56_ARCH)")
    lines.append(f"isEmpty(QTE56_ARCH) {{")
    lines.append(f"    QTE56_ARCH = 32")
    lines.append(f"}}")
    lines.append(f"")
    lines.append(f"equals(QTE56_ARCH, 64) {{")
    lines.append(f"    DESTDIR = ../../../../dll/dll64")
    lines.append(f"}} else {{")
    lines.append(f"    DESTDIR = ../../../../dll/dll32")
    lines.append(f"}}")
    lines.append(f"")
    lines.append(f"unix: DESTDIR = ../../../../lib")
    lines.append(f"")
    lines.append(f"macx {{")
    lines.append(f"    # macx-clang mkspec включает -fvisibility=hidden глобально —")
    lines.append(f"    # переопределяем чтобы extern \"C\" функции были видны в dylib")
    lines.append(f"    QMAKE_CXXFLAGS += -fvisibility=default")
    lines.append(f"    QMAKE_CFLAGS   += -fvisibility=default")
    lines.append(f"}}")

    pro_content = "\n".join(lines) + "\n"

    if DRY_RUN:
        print(f"  [DRY-RUN] Would create: {pro_path}")
        print(f"    QT: {' '.join(qt_sorted)}, SOURCES: {len(all_sources)}, "
              f"HEADERS: {len(all_headers)}, DEFINES: {len(all_defines)}")
    else:
        group_dir.mkdir(parents=True, exist_ok=True)
        # newline="\n" — иначе на Windows text-mode запись превратит LF в CRLF
        pro_path.write_text(pro_content, encoding="utf-8", newline="\n")
        print(f"  Created: {pro_path.relative_to(BASE)}")
        print(f"    QT: {' '.join(qt_sorted)}, SOURCES: {len(all_sources)}, "
              f"HEADERS: {len(all_headers)}")


# ── Step 2: Update gen_*.d files ──────────────────────────────────────

def update_gen_d_file(module, group_name):
    """Replace DLL filename in registerModule() and header comment."""
    gen_file = GEN_DIR / f"gen_{module}.d"
    if not gen_file.exists():
        print(f"  WARNING: {gen_file.name} not found, skipping")
        return

    text = gen_file.read_text(encoding="utf-8")

    old_dll = f"qte56_{module}.dll"
    new_dll = f"{group_name}.dll"

    if old_dll == new_dll:
        return

    if f'"{old_dll}"' in text:
        new_text = text.replace(f'"{old_dll}"', f'"{new_dll}"')
        # Also update header comment
        new_text = new_text.replace(f"DLL: {old_dll}", f"DLL: {new_dll}")
    elif f'"{new_dll}"' in text:
        print(f"  Already updated: {gen_file.name}")
        return
    else:
        print(f"  WARNING: neither '{old_dll}' nor '{new_dll}' found in {gen_file.name}")
        return

    if DRY_RUN:
        print(f"  [DRY-RUN] {gen_file.name}: {old_dll} -> {new_dll}")
    else:
        gen_file.write_text(new_text, encoding="utf-8")
        print(f"  {gen_file.name}: {old_dll} -> {new_dll}")


def revert_gen_d_file(module, group_name):
    """Revert merged DLL name back to original per-module DLL name."""
    gen_file = GEN_DIR / f"gen_{module}.d"
    if not gen_file.exists():
        return

    text = gen_file.read_text(encoding="utf-8")

    old_dll = f"{group_name}.dll"
    new_dll = f"qte56_{module}.dll"

    if f'"{old_dll}"' in text:
        new_text = text.replace(f'"{old_dll}"', f'"{new_dll}"')
        new_text = new_text.replace(f"DLL: {old_dll}", f"DLL: {new_dll}")
        gen_file.write_text(new_text, encoding="utf-8")
        print(f"  {gen_file.name}: {old_dll} -> {new_dll}")
    elif f'"{new_dll}"' in text:
        print(f"  Already reverted: {gen_file.name}")
    else:
        print(f"  WARNING: DLL name not found in {gen_file.name}")


# ── Step 3: Generate umbrella D imports ───────────────────────────────

def generate_umbrella_d(group_name, modules):
    """Create d/<group_name>.d with public imports of all gen_* modules."""
    imports = [f"gen_{mod}" for mod in modules]

    lines = []
    lines.append(f"/**")
    lines.append(f" * {group_name}.d — umbrella import (auto-generated by merge_dlls.py).")
    lines.append(f" * DLL: {group_name}.dll")
    lines.append(f" */")
    lines.append(f"module {group_name};")
    lines.append(f"")
    lines.append(f"public import")
    for i, imp in enumerate(imports):
        suffix = "," if i < len(imports) - 1 else ";"
        lines.append(f"    {imp}{suffix}")
    lines.append(f"")

    content = "\n".join(lines) + "\n"
    out_path = D_DIR / f"{group_name}.d"

    if DRY_RUN:
        print(f"  [DRY-RUN] Would create: {out_path.relative_to(BASE)}")
    else:
        out_path.write_text(content, encoding="utf-8")
        print(f"  Created: {out_path.relative_to(BASE)}")


# ── Step 4: Generate build script ─────────────────────────────────────

def generate_build_bat():
    """Create build_merged_dlls.bat in arch_new/."""
    bat_path = BASE / "build_merged_dlls.bat"

    group_names = list(GROUPS.keys())
    total = 1 + len(group_names)  # core + groups

    lines = []
    lines.append(f"@echo off")
    lines.append(f"setlocal enabledelayedexpansion")
    lines.append(f"cd /d \"%~dp0\"")
    lines.append(f"")
    lines.append(f":: ── Qt / MinGW paths из local.env.bat (QT_BIN, MINGW_BIN) ──")
    lines.append(f"if exist \"%~dp0local.env.bat\" call \"%~dp0local.env.bat\"")
    lines.append(f"set PATH=!QT_BIN!;!MINGW_BIN!;!PATH!")
    lines.append(f"")
    lines.append(f"if not exist \"dll\" mkdir \"dll\"")
    lines.append(f"")
    lines.append(f"set OK=0")
    lines.append(f"set TOTAL=0")
    lines.append(f"set FAILED_LIST=")
    lines.append(f"")
    lines.append(f":: ══════════════════════════════════════════════════════════")
    lines.append(f":: 1. Core (standalone DLL, has MOC/ESlot)")
    lines.append(f":: ══════════════════════════════════════════════════════════")
    lines.append(f"call :build_single qte56_qcore")
    lines.append(f"")
    lines.append(f":: ══════════════════════════════════════════════════════════")
    lines.append(f":: 2. Merged groups")
    lines.append(f":: ══════════════════════════════════════════════════════════")
    for g in group_names:
        lines.append(f"call :build_merged {g}")
    lines.append(f"")
    lines.append(f":: ── Summary ──")
    lines.append(f"echo.")
    lines.append(f"echo ════════════════════════════════════════════════════")
    lines.append(f"echo   Results: !OK! / !TOTAL! succeeded")
    lines.append(f"if defined FAILED_LIST echo   FAILED:!FAILED_LIST!")
    lines.append(f"echo ════════════════════════════════════════════════════")
    lines.append(f"goto :eof")
    lines.append(f"")
    lines.append(f":: ── Build a single (non-merged) module ──")
    lines.append(f":build_single")
    lines.append(f"    set /a TOTAL+=1")
    lines.append(f"    set DLL=%1")
    lines.append(f"    echo [!TOTAL!/{total}] Building !DLL! ...")
    lines.append(f"    pushd \"cpp\\qt5\\!DLL!\"")
    lines.append(f"    qmake \"!DLL!.pro\" -spec win32-g++ >nul 2>&1")
    lines.append(f"    if errorlevel 1 (")
    lines.append(f"        echo   FAIL: qmake")
    lines.append(f"        set FAILED_LIST=!FAILED_LIST! !DLL!")
    lines.append(f"        popd")
    lines.append(f"        goto :eof")
    lines.append(f"    )")
    lines.append(f"    mingw32-make --no-print-directory >nul 2>&1")
    lines.append(f"    if errorlevel 1 (")
    lines.append(f"        echo   FAIL: make")
    lines.append(f"        set FAILED_LIST=!FAILED_LIST! !DLL!")
    lines.append(f"        popd")
    lines.append(f"        goto :eof")
    lines.append(f"    )")
    lines.append(f"    popd")
    lines.append(f"    for %%F in (\"dll\\!DLL!.dll\") do echo   OK  (%%~zF bytes)")
    lines.append(f"    set /a OK+=1")
    lines.append(f"    goto :eof")
    lines.append(f"")
    lines.append(f":: ── Build a merged group ──")
    lines.append(f":build_merged")
    lines.append(f"    set /a TOTAL+=1")
    lines.append(f"    set GRP=%1")
    lines.append(f"    echo [!TOTAL!/{total}] Building !GRP! (merged) ...")
    lines.append(f"    pushd \"cpp\\qt5\\merged\\!GRP!\"")
    lines.append(f"    qmake \"!GRP!.pro\" -spec win32-g++ >nul 2>&1")
    lines.append(f"    if errorlevel 1 (")
    lines.append(f"        echo   FAIL: qmake")
    lines.append(f"        set FAILED_LIST=!FAILED_LIST! !GRP!")
    lines.append(f"        popd")
    lines.append(f"        goto :eof")
    lines.append(f"    )")
    lines.append(f"    mingw32-make --no-print-directory >nul 2>&1")
    lines.append(f"    if errorlevel 1 (")
    lines.append(f"        echo   FAIL: make")
    lines.append(f"        set FAILED_LIST=!FAILED_LIST! !GRP!")
    lines.append(f"        popd")
    lines.append(f"        goto :eof")
    lines.append(f"    )")
    lines.append(f"    popd")
    lines.append(f"    for %%F in (\"dll\\!GRP!.dll\") do echo   OK  (%%~zF bytes)")
    lines.append(f"    set /a OK+=1")
    lines.append(f"    goto :eof")
    lines.append(f"")

    content = "\r\n".join(lines) + "\r\n"

    if DRY_RUN:
        print(f"  [DRY-RUN] Would create: {bat_path.relative_to(BASE)}")
    else:
        bat_path.write_text(content, encoding="utf-8")
        print(f"  Created: {bat_path.relative_to(BASE)}")


# ── Main ──────────────────────────────────────────────────────────────

def main():
    # Verify we're in the right place
    if not CPP_DIR.exists() or not GEN_DIR.exists():
        print(f"ERROR: Expected project structure at {BASE}")
        print(f"  cpp/ exists: {CPP_DIR.exists()}")
        print(f"  d/gen/ exists: {GEN_DIR.exists()}")
        sys.exit(1)

    mode = "DRY-RUN" if DRY_RUN else ("REVERT" if REVERT else "APPLY")
    print(f"merge_dlls.py — mode: {mode}")
    print(f"Base: {BASE}")

    # Count modules
    total_mods = sum(len(v) for v in GROUPS.values())
    print(f"Groups: {len(GROUPS)}, modules: {total_mods} (+1 core = {total_mods + 1})")
    print()

    if REVERT:
        # ── Revert mode ──────────────────────────────────────────────
        print("=== Reverting gen_*.d to original per-module DLL names ===")
        for module, group in MODULE_TO_GROUP.items():
            revert_gen_d_file(module, group)
        print("\nDone (revert). Merged .pro files and umbrella .d files NOT deleted.")
        return

    # ── Step 1 ────────────────────────────────────────────────────────
    print("=== Step 1: Generating merged .pro files ===")
    for group_name, modules in GROUPS.items():
        print(f"\n  [{group_name}] ({len(modules)} modules)")
        generate_merged_pro(group_name, modules)

    # ── Step 2 ────────────────────────────────────────────────────────
    print("\n=== Step 2: Updating gen_*.d (registerModule DLL name) ===")
    for module, group in sorted(MODULE_TO_GROUP.items()):
        update_gen_d_file(module, group)

    # ── Step 3 ────────────────────────────────────────────────────────
    print("\n=== Step 3: Generating umbrella D import modules ===")
    for group_name, modules in GROUPS.items():
        generate_umbrella_d(group_name, modules)

    # ── Step 4 ────────────────────────────────────────────────────────
    print("\n=== Step 4: Generating build_merged_dlls.bat ===")
    generate_build_bat()

    print(f"\nDone! Next steps:")
    print(f"  1. cd {BASE}")
    print(f"  2. build_merged_dlls.bat")
    print(f"  3. Test with existing D test programs")


if __name__ == "__main__":
    main()
