# QXlsx .xlsm Write Bug — Investigation Log

> **Пометка (2026-08-02):** баг исправлен. В `QXlsx/source/xlsxdocument.cpp`
> (`DocumentPrivate::savePackage`) добавлена логика `Worksheet::isModified()`:
> для изменённых листов XML генерируется заново через `saveToXmlData()`,
> исходный XML из `unknownFiles` используется только для нетронутых листов.
> Ниже — исторический журнал расследования от 2026-05-25.

## Date: 2026-05-25
## Status: RESOLVED (см. пометку выше) — на момент журнала: Root cause identified, fix pending

---

## Problem Summary

When opening an existing `.xlsm` file, calling `Document::write()` to modify a cell, and then `Document::saveAs()` — the changes are NOT persisted. The saved file contains the original cell values, not the updated ones.

**Key finding:** `write()` and `read()` work with the same in-memory data (verified), but `saveToXmlData()` generates XML from DIFFERENT data.

---

## Reproduction

### Test File: `test/test_write_check.d`

```d
import qte56_core, qte56_loader, gen_qxlsx;
import std.stdio;
import std.string;

void main() {
    LoadQt("c:/gpt/qte56/arch_new/dll/dll32");
    
    auto doc = new QXlsxDocument("c:/gpt/qte56/arch_new/test/БАЗА_ОБУЧЕНИЯ_2025.xlsm", true);
    doc.selectSheet("БД 2025");
    
    string before = doc.read(2, 3).strip();     // "Гусинская"
    doc.write(2, 3, "[TEST_VALUE]");
    string after = doc.read(2, 3).strip();      // "[TEST_VALUE]" — OK!
    
    doc.saveAs("c:/gpt/qte56/arch_new/test/test_write_check.xlsm");
    
    auto doc2 = new QXlsxDocument("c:/gpt/qte56/arch_new/test/test_write_check.xlsm", true);
    doc2.selectSheet("БД 2025");
    string reopened = doc2.read(2, 3).strip();  // "Гусинская" — BUG! Should be "[TEST_VALUE]"
}
```

### Output:
```
Before write: Гусинская
Written: [TEST_VALUE]
After write: [TEST_VALUE]      ← write() works
After reopen: Гусинская        ← saveAs() does NOT persist changes
```

---

## Root Cause Analysis

### Hypothesis 1: `write()` and `saveToXmlData()` use different data sources

**Evidence:**
- `Document::write()` calls `currentWorksheet()->write()` which modifies `WorksheetPrivate::cellTable`
- `Document::read()` calls `currentWorksheet()->read()` which reads from the SAME `cellTable`
- `Worksheet::saveToXmlData()` → `WorksheetPrivate::saveXmlSheetData()` iterates over `cellTable.cells`
- BUT the generated XML contains OLD values

**Conclusion:** There are likely TWO instances of worksheet data or `cellTable` is being copied/cloned somewhere between `loadPackage()` and `savePackage()`.

### Hypothesis 2: Pass-through logic in `savePackage()` uses original XML

In `savePackage()`, we generate worksheet XML via `sheet->saveToXmlData()` and store in `filesToWrite`. This looks correct. However, the issue may be in how `loadPackage()` handles `.xlsm` files.

### Hypothesis 3: `loadPackage()` creates duplicate worksheet objects

When loading `.xlsm`, `loadPackage()` may:
1. Parse workbook.xml and create worksheet stubs
2. Parse worksheet XML and populate `cellTable`
3. Store original worksheet XML in `unknownFiles` for pass-through

If step 2 populates one `cellTable` and `write()` modifies another, that would explain the bug.

---

## Code Changes Made (2026-05-25)

### QXlsx Modifications for .xlsm Support

Files modified:
- `QXlsx/source/xlsxdocument.cpp` — `loadPackage()` and `savePackage()`
- `QXlsx/source/xlsxworksheet.cpp` — namespace additions for Excel 2010+
- `QXlsx/source/xlsxcontenttypes.cpp` — `addWorkbookMacroEnabled()`
- `QXlsx/header/xlsxdocument_p.h` — added `unknownFiles`, `hasVbaProject`, `workbookCodeName`

### Key `loadPackage()` change (pass-through):
```cpp
// Original worksheet XML is now saved for pass-through
// (previously was skipped with "continue")
if (fp.startsWith(QLatin1String("xl/worksheets/sheet")) && fp.endsWith(QLatin1String(".xml"))) {
    unknownFiles[fp] = zipReader.fileData(fp);
    continue;
}
```

### Key `savePackage()` change:
```cpp
for (int i = 0; i < worksheets.size(); ++i) {
    std::shared_ptr<AbstractSheet> sheet = worksheets[i];
    QByteArray sheetData = sheet->saveToXmlData();  // Generates XML from cellTable
    filesToWrite[sheetPath] = sheetData;
}
```

---

## Debug Attempts (Removed)

Added `qDebug()` statements to trace the issue, but they caused **ABI incompatibility** between MinGW-compiled DLL and DMD (MSVC COFF) executables, resulting in `Access Violation` at startup.

**Lesson:** Do NOT add `qDebug()` to QXlsx C++ code when the DLL is consumed by DMD. Use file-based logging or debug via C++ test programs instead.

All debug output has been removed from:
- `QXlsx/source/xlsxdocument.cpp`
- `QXlsx/source/xlsxworksheet.cpp`

---

## What Works

1. ✅ Reading `.xlsm` files — all 1115 surnames extracted correctly
2. ✅ Saving `.xlsm` without modifications — 130/140 files identical to original
3. ✅ Excel opens saved files without errors
4. ✅ VBA macros preserved
5. ✅ Formula writing (with auto `=` prefix)

## What Does NOT Work

1. ❌ **Cell modification via `write()` is not persisted** — CRITICAL BUG

---

## Next Steps / TODO

### Step 1: Verify pointer identity
Create a C++ test program (not D) to:
- Open `.xlsm` file
- Print pointer of `Worksheet` object returned by `currentWorksheet()`
- Call `write()` and verify the same pointer is used
- Call `saveToXmlData()` and check if the same `cellTable` is iterated

### Step 2: Check for duplicate cellTable
In `WorksheetPrivate`, add a unique ID or counter to verify if `saveXmlSheetData()` iterates the same `cellTable` instance that `write()` modified.

### Step 3: Check loadPackage() worksheet creation
Trace how `loadPackage()` creates worksheet objects when loading `.xlsm`. Check if:
- `workbook->loadFromXmlData()` creates worksheets
- `worksheet->loadFromXmlData()` populates cellTable
- Any cloning/copying happens

### Step 4: Compare with .xlsx behavior
Test if the same bug occurs with `.xlsx` files (non-macro). If `.xlsx` works but `.xlsm` doesn't, the issue is in the `.xlsm` pass-through logic.

---

## Build Commands

### Build QXlsx static library:
```bash
cd QXlsx
set PATH=C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%
mingw32-make -j4 -f Makefile.Release
```

### Build qte56_qxlsx DLL:
```bash
cd cpp/qt5/qte56_qxlsx
set PATH=C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%
mingw32-make -j4
```

### Build D test program:
```bash
cd test
dmd -m32 -g -I"..\d" -I"..\d\gen" test_write_check.d "..\d\gen\gen_qxlsx.d" "..\d\gen\gen_qcore.d" "..\d\qte56_core.d" "..\d\qte56_loader.d" -L"..\dll\dll32\libqte56_qxlsx.a" -oftest_write_check
```

### Run test:
```bash
set PATH=C:\gpt\qte56\arch_new\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
test_write_check
```

---

## Files to Check Tomorrow

1. `QXlsx/source/xlsxdocument.cpp` — `loadPackage()` worksheet loading logic
2. `QXlsx/source/xlsxworksheet.cpp` — `loadFromXmlData()` and `saveXmlSheetData()`
3. `QXlsx/source/xlsxworkbook.cpp` — `getSheetsByTypes()` and sheet management
4. `QXlsx/header/xlsxworksheet_p.h` — `WorksheetPrivate::cellTable` structure

---

## Related Files

- `test/test_write_check.d` — reproduction test
- `test/test_xlsm_save.d` — working save test (no modifications)
- `test/modify_training_base.d` — original use case
- `d/gen/gen_qxlsx.d` — D bindings for QXlsx
- `cpp/qt5/qte56_qxlsx/` — C++ wrapper DLL
