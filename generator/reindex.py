#!/usr/bin/env python3
"""
reindex.py — QTE56 Index Reindexer

Reassigns pFunQt[] indices with block_size=200, compressing gaps within
each module. QCore (module="QCore") stays fixed at indices 1–99.

Updates:
  registry/functions.csv      — new index layout
  d/gen/gen_*.d               — generateFunQt() calls + pFunQt[] references
  d/qte56_core.d              — PFUNQT_SIZE constant

DLLs are NOT touched — they export by name, not by index.

Usage:
  py reindex.py [--dry-run]
"""

import re
import sys
from pathlib import Path
from collections import OrderedDict

BLOCK_SIZE = 200
ROOT = Path(__file__).parent.parent   # arch_new/

CSV_PATH    = ROOT / "registry" / "functions.csv"
CORE_D_PATH = ROOT / "d" / "qte56_core.d"
GEN_D_DIR   = ROOT / "d" / "gen"

# ──────────────────────────────────────────────────────────────
# 1. Parse CSV
# ──────────────────────────────────────────────────────────────

def parse_csv():
    """Return list of (idx, func_name, module, dll, category), deduped by idx."""
    seen_idx = set()
    rows = []
    with open(CSV_PATH, encoding="utf-8") as f:
        for line in f:
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue
            parts = stripped.split(",")
            if len(parts) < 5:
                continue
            try:
                idx = int(parts[0])
            except ValueError:
                continue
            if idx in seen_idx:
                continue          # skip duplicates (same index)
            seen_idx.add(idx)
            rows.append((idx, parts[1], parts[2], parts[3], parts[4]))
    return rows

# ──────────────────────────────────────────────────────────────
# 2. Build remapping  old_idx → new_idx
# ──────────────────────────────────────────────────────────────

def build_remapping(rows):
    # Collect per-module, preserving first-appearance order
    module_entries = OrderedDict()   # module -> [(old_idx, func_name, dll, category)]
    for idx, func_name, module, dll, category in rows:
        module_entries.setdefault(module, []).append((idx, func_name, dll, category))

    remapping  = {}   # old_idx  -> new_idx
    new_table  = {}   # new_idx  -> (func_name, module, dll, category)
    mod_blocks = {}   # module   -> (new_base, count)

    # QCore stays fixed
    for old_idx, func_name, dll, category in module_entries.pop("QCore", []):
        remapping[old_idx] = old_idx
        new_table[old_idx] = (func_name, "QCore", dll, category)
    mod_blocks["QCore"] = (0, len(remapping))

    # All other modules: sequential 200-slot blocks starting at block 1
    block_num = 1
    for module, entries in module_entries.items():
        entries_sorted = sorted(entries, key=lambda e: e[0])
        if len(entries_sorted) > BLOCK_SIZE:
            print(f"ERROR: {module} has {len(entries_sorted)} entries > block_size {BLOCK_SIZE}")
            sys.exit(1)
        base = block_num * BLOCK_SIZE
        for offset, (old_idx, func_name, dll, category) in enumerate(entries_sorted):
            new_idx = base + offset
            remapping[old_idx]  = new_idx
            new_table[new_idx]  = (func_name, module, dll, category)
        mod_blocks[module] = (base, len(entries_sorted))
        block_num += 1

    return remapping, new_table, mod_blocks

# ──────────────────────────────────────────────────────────────
# 3. Rewrite functions.csv
# ──────────────────────────────────────────────────────────────

def rewrite_csv(new_table, mod_blocks):
    # Group new entries by module in block order
    from collections import defaultdict
    by_module = defaultdict(list)
    for new_idx, (func_name, module, dll, category) in new_table.items():
        by_module[module].append((new_idx, func_name, dll, category))

    # Sort modules by their base index
    modules_ordered = sorted(by_module.keys(),
                             key=lambda m: mod_blocks[m][0])

    lines = [
        "# QTE56 Function Registry",
        "# Format: index,func_name,module,dll,category",
        f"# Block size: {BLOCK_SIZE}. QCore=1-99 (fixed). Other modules: sequential blocks.",
        "#",
        "# DO NOT edit indices manually — use reindex.py to reassign.",
    ]

    for module in modules_ordered:
        entries = sorted(by_module[module])   # sort by new_idx
        base    = entries[0][0]
        end     = entries[-1][0]
        lines.append("")
        lines.append(f"# ── {module} ({base}–{end}) " + "─" * max(0, 50 - len(module) - len(str(base)) - len(str(end))))
        for new_idx, func_name, dll, category in entries:
            lines.append(f"{new_idx},{func_name},{module},{dll},{category}")

    with open(CSV_PATH, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")

# ──────────────────────────────────────────────────────────────
# 4. Update a single D source file
# ──────────────────────────────────────────────────────────────

def update_d_file(path, remapping):
    with open(path, encoding="utf-8") as f:
        content = f.read()
    original = content

    def replace_genfunqt(m):
        old = int(m.group(1))
        new = remapping.get(old, old)
        return f"generateFunQt({new},"

    def replace_pfunqt(m):
        old = int(m.group(1))
        new = remapping.get(old, old)
        if new == old:
            return m.group(0)              # unchanged (QCore or unknown)
        return f"pFunQt[{new}]"

    content = re.sub(r"generateFunQt\((\d+),", replace_genfunqt, content)
    content = re.sub(r"pFunQt\[(\d+)\]",       replace_pfunqt,   content)

    if content != original:
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        return True
    return False

# ──────────────────────────────────────────────────────────────
# 5. Update PFUNQT_SIZE in qte56_core.d
# ──────────────────────────────────────────────────────────────

def update_pfunqt_size(remapping):
    max_new = max(remapping.values())
    # Round up to next block boundary + 1 block headroom
    new_size = ((max_new // BLOCK_SIZE) + 2) * BLOCK_SIZE

    with open(CORE_D_PATH, encoding="utf-8") as f:
        content = f.read()

    new_content = re.sub(
        r"enum PFUNQT_SIZE\s*=\s*[\d_]+;[^\n]*",
        f"enum PFUNQT_SIZE = {new_size};  // reindexed: max_idx={max_new}, block={BLOCK_SIZE}",
        content,
    )

    if new_content != content:
        with open(CORE_D_PATH, "w", encoding="utf-8", newline="\n") as f:
            f.write(new_content)
        return new_size
    return None

# ──────────────────────────────────────────────────────────────
# 6. Main
# ──────────────────────────────────────────────────────────────

def main():
    dry_run = "--dry-run" in sys.argv

    print(f"QTE56 Reindexer  (block_size={BLOCK_SIZE})")
    print(f"Root: {ROOT}")
    if dry_run:
        print("*** DRY RUN — no files will be modified ***")
    print()

    # Parse
    rows = parse_csv()
    print(f"Parsed {len(rows)} unique entries from {CSV_PATH.name}")

    # Build remapping
    remapping, new_table, mod_blocks = build_remapping(rows)

    # Report
    print(f"\n{'Module':<24} {'Old block':<20} {'New block':<20} {'Count':>5}")
    print("-" * 72)
    old_by_module = {}
    for old_idx, (func_name, module, dll, category) in [(old, (new_table[remapping[old]], *("","",""))[:4]) for old, _ in remapping.items()]:
        pass
    # Simpler: rebuild from rows
    from collections import defaultdict
    old_ranges = defaultdict(list)
    for idx, func_name, module, dll, category in rows:
        old_ranges[module].append(idx)

    for module in mod_blocks:
        base, count = mod_blocks[module]
        olds = sorted(old_ranges.get(module, []))
        if olds:
            old_str = f"{olds[0]}–{olds[-1]}"
        else:
            old_str = "(none)"
        if module == "QCore":
            new_str = f"1–99 (fixed)"
        else:
            new_str = f"{base}–{base + count - 1}"
        print(f"  {module:<22} {old_str:<20} {new_str:<20} {count:>5}")

    changed = sum(1 for old, new in remapping.items() if old != new)
    print(f"\n  {changed} of {len(remapping)} indices will change.")

    if dry_run:
        print("\nDry run complete. Run without --dry-run to apply changes.")
        return

    print()

    # Rewrite CSV
    rewrite_csv(new_table, mod_blocks)
    print(f"[OK] {CSV_PATH.relative_to(ROOT)}")

    # Update all D source files that may reference non-QCore indices:
    #   d/gen/gen_*.d   — generated wrappers
    #   test/*.d        — test programs (may hardcode pFunQt[idx])
    #   example/*.d     — example programs
    d_scan_dirs = [
        (GEN_D_DIR,         "gen_*.d"),
        (ROOT / "test",     "*.d"),
        (ROOT / "example",  "*.d"),
    ]
    updated_d = []
    total_d   = 0
    for scan_dir, pattern in d_scan_dirs:
        if not scan_dir.exists():
            continue
        for d_file in sorted(scan_dir.glob(pattern)):
            total_d += 1
            rel = d_file.relative_to(ROOT)
            if update_d_file(d_file, remapping):
                updated_d.append(str(rel))

    for rel in updated_d:
        print(f"[OK] {rel}")
    skipped = total_d - len(updated_d)
    if skipped:
        print(f"     ({skipped} D files unchanged)")

    # Update PFUNQT_SIZE
    new_size = update_pfunqt_size(remapping)
    if new_size:
        old_size = 43_000   # approximate; not critical
        print(f"[OK] d/qte56_core.d  PFUNQT_SIZE -> {new_size:,}")
    else:
        print("     d/qte56_core.d — already up to date")

    print(f"\nDone! Array size reduced from ~43,000 to {new_size:,} slots.")

if __name__ == "__main__":
    main()
