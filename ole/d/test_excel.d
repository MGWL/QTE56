/**
 * test_excel.d — Integration test for OLE Automation via ole_helper.dll.
 * Requires: Excel installed, ole_helper.dll in working directory.
 *
 * Build: dmd -m32 ole/d/test_excel.d ole/d/ole_automation.d ole/d/ole_excel.d
 * Run:   test_excel.exe
 */
import ole_automation;
import ole_excel;
import std.stdio : writeln, writefln;
import std.math : abs;
import std.conv : to;

void main() {
    writeln("=== OLE Automation Test (Excel) ===");
    writeln();

    int passed = 0;
    int failed = 0;

    void check(bool cond, string msg) {
        if (cond) {
            writeln("  PASS: ", msg);
            passed++;
        } else {
            writeln("  FAIL: ", msg);
            failed++;
        }
    }

    // ── Step 1: Load DLL & Init COM ──
    writeln("[1] Loading ole_helper.dll ...");
    try {
        loadOleHelper("ole_helper.dll");
        check(true, "loadOleHelper()");
    } catch (Exception e) {
        writeln("FATAL: ", e.msg);
        return;
    }

    writeln("[2] Initializing COM (STA) ...");
    try {
        oleInit();
        check(true, "oleInit()");
    } catch (Exception e) {
        writeln("FATAL: ", e.msg);
        return;
    }

    // ── Step 2: Create Excel Application ──
    OleObject app;
    writeln("[3] Creating Excel.Application ...");
    try {
        app = new OleObject("Excel.Application");
        check(app.handle() !is null, "Excel.Application created");
    } catch (Exception e) {
        writeln("FATAL: ", e.msg);
        writeln("  (Is Microsoft Excel installed?)");
        oleUninit();
        unloadOleHelper();
        return;
    }

    try {
        // ── Step 3: Configure ──
        writeln("[4] Setting Visible=0, DisplayAlerts=0 ...");
        app.set("Visible", 0);
        app.set("DisplayAlerts", 0);
        check(true, "Visible=0, DisplayAlerts=0");

        // ── Step 4: Add Workbook ──
        writeln("[5] Adding workbook ...");
        auto wbs = app.getObject("Workbooks");
        auto wb = wbs.callObject("Add");
        check(wb.handle() !is null, "Workbook.Add");

        // ── Step 5: Get ActiveSheet ──
        writeln("[6] Getting ActiveSheet ...");
        auto ws = wb.getObject("ActiveSheet");
        check(ws.handle() !is null, "ActiveSheet");

        // ── Step 6: Write string to A1 ──
        writeln("[7] Writing 'Hello from D!' to A1 ...");
        auto rangeA1 = ws.getObject("Range", OleVariant.fromString("A1"));
        rangeA1.set("Value", "Hello from D!");
        check(true, "Range('A1').Value = 'Hello from D!'");

        // ── Step 7: Read string back ──
        writeln("[8] Reading A1 back ...");
        string val1 = rangeA1.getString("Value");
        check(val1 == "Hello from D!", "A1 == 'Hello from D!' (got: '" ~ val1 ~ "')");
        destroy(rangeA1);

        // ── Step 8: Write number to B1 ──
        writeln("[9] Writing 42.0 to B1 ...");
        auto rangeB1 = ws.getObject("Range", OleVariant.fromString("B1"));
        rangeB1.set("Value", 42.0);
        check(true, "Range('B1').Value = 42.0");

        // ── Step 9: Read number back ──
        writeln("[10] Reading B1 back ...");
        double val2 = rangeB1.getDouble("Value");
        check(abs(val2 - 42.0) < 0.001, "B1 == 42.0 (got: " ~ to!string(val2) ~ ")");
        destroy(rangeB1);

        // ── Step 10: Write int to C1 ──
        writeln("[11] Writing 123 to C1 ...");
        auto rangeC1 = ws.getObject("Range", OleVariant.fromString("C1"));
        rangeC1.set("Value", 123);
        check(true, "Range('C1').Value = 123");

        // ── Step 11: Read int back ──
        writeln("[12] Reading C1 back ...");
        double val3 = rangeC1.getDouble("Value");
        check(abs(val3 - 123.0) < 0.001, "C1 == 123 (got: " ~ to!string(val3) ~ ")");
        destroy(rangeC1);

        // ── Step 12: Test ExcelSheet convenience ──
        writeln("[13] Testing ExcelSheet convenience ...");
        auto sheet = new ExcelSheet(ws);
        sheet.setCellValue("D1", "Convenience!");
        string val4 = sheet.getCellString("D1");
        check(val4 == "Convenience!", "ExcelSheet.getCellString('D1') == 'Convenience!'");

        sheet.setCellValue("E1", 3.14);
        double val5 = sheet.getCellDouble("E1");
        check(abs(val5 - 3.14) < 0.001, "ExcelSheet.getCellDouble('E1') == 3.14");

        // Don't destroy sheet — it doesn't own ws, we clean up below

        // ── Step 13: Close workbook (no save) ──
        writeln("[14] Closing workbook (no save) ...");
        wb.callVoid("Close", OleVariant.fromInt(0));
        check(true, "Workbook.Close(0)");

        // ── Cleanup ──
        destroy(ws);
        destroy(wb);
        destroy(wbs);

    } catch (Exception e) {
        writeln("  ERROR: ", e.msg);
        failed++;
    }

    // ── Step 14: Quit Excel ──
    writeln("[15] Quitting Excel ...");
    try {
        app.callVoid("Quit");
        check(true, "Excel.Quit");
    } catch (Exception e) {
        writeln("  WARN: Quit failed: ", e.msg);
    }

    destroy(app);

    writeln("[16] COM cleanup ...");
    oleUninit();
    unloadOleHelper();
    check(true, "oleUninit + unloadOleHelper");

    // ── Summary ──
    writeln();
    writefln("=== Results: %d passed, %d failed ===", passed, failed);
    if (failed > 0) {
        writeln("SOME TESTS FAILED!");
    } else {
        writeln("ALL TESTS PASSED!");
    }
}

