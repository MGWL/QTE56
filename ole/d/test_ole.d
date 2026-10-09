/**
 * test_ole.d — OLE Automation test using built-in Windows COM servers.
 * Uses: Scripting.FileSystemObject, Scripting.Dictionary
 * No Excel/Office required.
 *
 * Build: dmd -m32 ole/d/test_ole.d ole/d/ole_automation.d
 * Run:   test_ole.exe
 */
import ole_automation;
import std.stdio : writeln, writefln;
import std.conv : to;

void main() {
    writeln("=== OLE Automation Test (built-in COM servers) ===");
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

    // ── Load DLL & Init COM ──
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
        unloadOleHelper();
        return;
    }

    // ══════════════════════════════════════════
    // Part A: Scripting.FileSystemObject
    // ══════════════════════════════════════════
    writeln();
    writeln("--- Part A: Scripting.FileSystemObject ---");

    OleObject fso;
    writeln("[3] Creating Scripting.FileSystemObject ...");
    try {
        fso = new OleObject("Scripting.FileSystemObject");
        check(fso.handle() !is null, "FSO created");
    } catch (Exception e) {
        writeln("FATAL: ", e.msg);
        oleUninit();
        unloadOleHelper();
        return;
    }

    try {
        // GetDriveName
        writeln("[4] GetDriveName('C:\\Windows\\System32') ...");
        auto drv = fso.call("GetDriveName", OleVariant.fromString(`C:\Windows\System32`));
        string drvStr = drv.asString();
        check(drvStr == "C:", "GetDriveName == 'C:' (got: '" ~ drvStr ~ "')");
        drv.clear();

        // GetFileName
        writeln("[5] GetFileName('C:\\Windows\\notepad.exe') ...");
        auto fn = fso.call("GetFileName", OleVariant.fromString(`C:\Windows\notepad.exe`));
        string fnStr = fn.asString();
        check(fnStr == "notepad.exe", "GetFileName == 'notepad.exe' (got: '" ~ fnStr ~ "')");
        fn.clear();

        // GetParentFolderName
        writeln("[6] GetParentFolderName('C:\\Windows\\System32') ...");
        auto pf = fso.call("GetParentFolderName", OleVariant.fromString(`C:\Windows\System32`));
        string pfStr = pf.asString();
        check(pfStr == `C:\Windows`, "GetParentFolderName == 'C:\\Windows' (got: '" ~ pfStr ~ "')");
        pf.clear();

        // GetExtensionName
        writeln("[7] GetExtensionName('report.xlsx') ...");
        auto ext = fso.call("GetExtensionName", OleVariant.fromString("report.xlsx"));
        string extStr = ext.asString();
        check(extStr == "xlsx", "GetExtensionName == 'xlsx' (got: '" ~ extStr ~ "')");
        ext.clear();

        // GetBaseName
        writeln("[8] GetBaseName('report.xlsx') ...");
        auto bn = fso.call("GetBaseName", OleVariant.fromString("report.xlsx"));
        string bnStr = bn.asString();
        check(bnStr == "report", "GetBaseName == 'report' (got: '" ~ bnStr ~ "')");
        bn.clear();

        // BuildPath
        writeln("[9] BuildPath('C:\\Users', 'test.txt') ...");
        auto bp = fso.call("BuildPath",
                           OleVariant.fromString(`C:\Users`),
                           OleVariant.fromString("test.txt"));
        string bpStr = bp.asString();
        check(bpStr == `C:\Users\test.txt`,
              "BuildPath == 'C:\\Users\\test.txt' (got: '" ~ bpStr ~ "')");
        bp.clear();

        // FileExists
        writeln("[10] FileExists('C:\\Windows\\notepad.exe') ...");
        auto fe = fso.call("FileExists", OleVariant.fromString(`C:\Windows\notepad.exe`));
        bool feVal = fe.asBool();
        check(feVal == true, "FileExists('notepad.exe') == true");

        // FileExists — non-existent
        writeln("[11] FileExists('C:\\no_such_file_12345.txt') ...");
        auto fe2 = fso.call("FileExists", OleVariant.fromString(`C:\no_such_file_12345.txt`));
        bool fe2Val = fe2.asBool();
        check(fe2Val == false, "FileExists('no_such_file') == false");

        // FolderExists
        writeln("[12] FolderExists('C:\\Windows') ...");
        auto de = fso.call("FolderExists", OleVariant.fromString(`C:\Windows`));
        bool deVal = de.asBool();
        check(deVal == true, "FolderExists('C:\\Windows') == true");

        // GetTempName — returns random filename
        writeln("[13] GetTempName() ...");
        auto tn = fso.call("GetTempName");
        string tnStr = tn.asString();
        check(tnStr.length > 0, "GetTempName returned: '" ~ tnStr ~ "'");
        tn.clear();

    } catch (Exception e) {
        writeln("  ERROR: ", e.msg);
        failed++;
    }

    fso.release();

    // ══════════════════════════════════════════
    // Part B: Scripting.Dictionary
    // ══════════════════════════════════════════
    writeln();
    writeln("--- Part B: Scripting.Dictionary ---");

    OleObject dict;
    writeln("[14] Creating Scripting.Dictionary ...");
    try {
        dict = new OleObject("Scripting.Dictionary");
        check(dict.handle() !is null, "Dictionary created");
    } catch (Exception e) {
        writeln("FATAL: ", e.msg);
        oleUninit();
        unloadOleHelper();
        return;
    }

    try {
        // Add items
        writeln("[15] Add('name', 'Alice') ...");
        dict.callVoid("Add", OleVariant.fromString("name"), OleVariant.fromString("Alice"));
        check(true, "Add('name', 'Alice')");

        writeln("[16] Add('age', 30) ...");
        dict.callVoid("Add", OleVariant.fromString("age"), OleVariant.fromInt(30));
        check(true, "Add('age', 30)");

        writeln("[17] Add('score', 95.5) ...");
        dict.callVoid("Add", OleVariant.fromString("score"), OleVariant.fromDouble(95.5));
        check(true, "Add('score', 95.5)");

        // Count
        writeln("[18] Count ...");
        int cnt = dict.getInt("Count");
        check(cnt == 3, "Count == 3 (got: " ~ to!string(cnt) ~ ")");

        // Exists
        writeln("[19] Exists('name') ...");
        auto ex = dict.call("Exists", OleVariant.fromString("name"));
        check(ex.asBool() == true, "Exists('name') == true");

        writeln("[20] Exists('missing') ...");
        auto ex2 = dict.call("Exists", OleVariant.fromString("missing"));
        check(ex2.asBool() == false, "Exists('missing') == false");

        // Item (property get with index arg)
        writeln("[21] Item('name') ...");
        auto nameVal = dict.get("Item", OleVariant.fromString("name"));
        string nameStr = nameVal.asString();
        check(nameStr == "Alice", "Item('name') == 'Alice' (got: '" ~ nameStr ~ "')");
        nameVal.clear();

        writeln("[22] Item('age') ...");
        auto ageVal = dict.get("Item", OleVariant.fromString("age"));
        int ageInt = ageVal.asInt();
        check(ageInt == 30, "Item('age') == 30 (got: " ~ to!string(ageInt) ~ ")");

        writeln("[23] Item('score') ...");
        auto scoreVal = dict.get("Item", OleVariant.fromString("score"));
        double scoreDbl = scoreVal.asDouble();
        check(scoreDbl > 95.4 && scoreDbl < 95.6,
              "Item('score') == 95.5 (got: " ~ to!string(scoreDbl) ~ ")");

        // Remove
        writeln("[24] Remove('age') ...");
        dict.callVoid("Remove", OleVariant.fromString("age"));
        cnt = dict.getInt("Count");
        check(cnt == 2, "Count after Remove == 2 (got: " ~ to!string(cnt) ~ ")");

        // RemoveAll
        writeln("[25] RemoveAll() ...");
        dict.callVoid("RemoveAll");
        cnt = dict.getInt("Count");
        check(cnt == 0, "Count after RemoveAll == 0 (got: " ~ to!string(cnt) ~ ")");

    } catch (Exception e) {
        writeln("  ERROR: ", e.msg);
        failed++;
    }

    dict.release();

    // ── Cleanup ──
    writeln();
    writeln("[26] COM cleanup ...");
    oleUninit();
    unloadOleHelper();
    check(true, "oleUninit + unloadOleHelper");

    // ── Summary ──
    writeln();
    writefln("=== Results: %d passed, %d failed ===", passed, failed);
    if (failed > 0)
        writeln("SOME TESTS FAILED!");
    else
        writeln("ALL TESTS PASSED!");
}
