/**
 * ole_excel.d — Convenience wrappers for Excel OLE Automation.
 * Depends on: ole_automation.d (standalone, no QTE56).
 */
module ole_excel;

import ole_automation;
import std.datetime : Date, dur;
import core.memory : GC;
import core.sys.windows.winuser : ShowWindow, SetForegroundWindow, SW_SHOWNORMAL;

/// Convert std.datetime.Date to OLE Automation date (days since 1899-12-30).
double dateToOle(Date d) {
    return cast(double)(d - Date(1899, 12, 30)).total!"days";
}

/// Convert OLE Automation date (double) to std.datetime.Date (date part only).
Date oleToDate(double oleDate) {
    return Date(1899, 12, 30) + dur!"days"(cast(long)oleDate);
}

/// High-level Excel Application wrapper.
class ExcelApp {
    OleObject app;

    /**
     * Create Excel.Application COM object.
     * Params:
     *   visible = show Excel window (default: true)
     *   dllPath = path to ole_helper.dll
     */
    this(bool visible = true, string dllPath = "ole_helper.dll") {
        loadOleHelper(dllPath);
        oleInit();
        app = new OleObject("Excel.Application");
        // «Слепая» задержка после создания больше не нужна: занятость Excel
        // пережидает встроенный busy-retry в ole_automation.d.
        // Некоторые состояния Excel не позволяют менять Visible через COM (0x80020009);
        // ошибки здесь не фатальны — activate() доделает видимость через HWND.
        try { app.set("Visible", visible); } catch (Exception e) { }
        try { app.set("DisplayAlerts", false); } catch (Exception e) { }  // suppress save dialogs
    }

    private this(int tag) {}  // internal: for attach

    /**
     * Attach to a running Excel instance (GetActiveObject).
     * Returns null if Excel is not running.
     */
    static ExcelApp attach(bool makeVisible = true, string dllPath = "ole_helper.dll") {
        loadOleHelper(dllPath);
        oleInit();
        auto obj = OleObject.attachActive("Excel.Application");
        if (obj is null) return null;
        auto xa = new ExcelApp(0);
        xa.app = obj;
        // Запущенный Excel может быть занят — busy-retry в OleObject переждёт это.
        if (makeVisible) {
            try { xa.app.set("Visible", true); } catch (Exception e) { }
        }
        try { xa.app.set("DisplayAlerts", false); } catch (Exception e) { }
        return xa;
    }

    /**
     * Attach to a running Excel; create a new instance if not running.
     * (Equivalent of VBS: GetObject → fallback CreateObject)
     */
    static ExcelApp attachOrCreate(bool visible = true, string dllPath = "ole_helper.dll") {
        auto xa = attach(visible, dllPath);
        if (xa !is null) return xa;
        return new ExcelApp(visible, dllPath);
    }

    /// Number of open workbooks.
    int workbookCount() {
        auto wbs = app.getObject("Workbooks");
        scope(exit) destroy(wbs);
        return wbs.getInt("Count");
    }

    /// Get workbook by 1-based index.
    ExcelWorkbook workbook(int index) {
        auto wbs = app.getObject("Workbooks");
        scope(exit) destroy(wbs);
        return new ExcelWorkbook(wbs.getObject("Item", OleVariant.fromInt(index)));
    }

    /// Get workbook by file name (e.g. "ExTest.xlsm"). null if not open.
    ExcelWorkbook workbookByName(string name) {
        auto wbs = app.getObject("Workbooks");
        scope(exit) destroy(wbs);
        try {
            return new ExcelWorkbook(wbs.getObject("Item", OleVariant.fromString(name)));
        } catch (Exception e) {
            return null;
        }
    }

    /// Currently active workbook. null if none.
    ExcelWorkbook activeWorkbook() {
        try {
            return new ExcelWorkbook(app.getObject("ActiveWorkbook"));
        } catch (Exception e) {
            return null;
        }
    }

    /// Add a new empty workbook.
    ExcelWorkbook addWorkbook() {
        auto wbs = app.getObject("Workbooks");
        scope(exit) destroy(wbs);
        return new ExcelWorkbook(wbs.callObject("Add"));
    }

    /// Open existing workbook by path.
    ExcelWorkbook openWorkbook(string path) {
        auto wbs = app.getObject("Workbooks");
        scope(exit) destroy(wbs);
        // Занятость Excel пережидает busy-retry — пауза перед Open не нужна.
        return new ExcelWorkbook(wbs.callObject("Open", OleVariant.fromString(path)));
    }

    /// Get ActiveSheet as ExcelSheet.
    ExcelSheet activeSheet() {
        return new ExcelSheet(app.getObject("ActiveSheet"));
    }

    /// Bring Excel window to normal state (xlNormal = -4137) and ensure visible.
    void activate() {
        // Пробуем через COM. Если Excel занят/модален, COM может вернуть 0x80020009;
        // тогда используем Win32 HWND. RPC_E_CALL_REJECTED пережидает busy-retry.
        try {
            app.set("Visible", true);
        } catch (Exception e) {
            // COM-видимость недоступна — попробуем HWND ниже
        }
        try {
            app.set("WindowState", -4137);
        } catch (Exception e) {
            // игнорируем, делаем через Win32
        }

        try {
            int hwnd = app.getInt("Hwnd");
            if (hwnd != 0) {
                ShowWindow(cast(void*)hwnd, SW_SHOWNORMAL);
                SetForegroundWindow(cast(void*)hwnd);
            }
        } catch (Exception e) {
            // HWND тоже недоступен — оставляем как есть
        }
    }

    /// Quit Excel (no save).
    void quit() {
        app.callVoid("Quit");
    }

    ~this() {
        // В финализаторе GC нельзя трогать другие GC-объекты (app может быть уже
        // финализирован/освобождён) — COM-ссылку безопасно отпустит ~this самого OleObject.
        if (GC.inFinalizer) return;
        if (app !is null) {
            app.release();
        }
    }
}

/// High-level Excel Workbook wrapper.
class ExcelWorkbook {
    OleObject wb;

    this(OleObject w) {
        wb = w;
    }

    /// Workbook file name (e.g. "ExTest.xlsm").
    string name() {
        return wb.getString("Name");
    }

    /// Full path on disk.
    string fullName() {
        return wb.getString("FullName");
    }

    /// Number of worksheets.
    int sheetCount() {
        auto sheets = wb.getObject("Sheets");
        scope(exit) destroy(sheets);
        return sheets.getInt("Count");
    }

    /// Get sheet by 1-based index.
    ExcelSheet sheet(int index) {
        auto sheets = wb.getObject("Sheets");
        scope(exit) destroy(sheets);
        return new ExcelSheet(sheets.getObject("Item", OleVariant.fromInt(index)));
    }

    /// Get sheet by name.
    ExcelSheet sheet(string name) {
        auto sheets = wb.getObject("Sheets");
        scope(exit) destroy(sheets);
        return new ExcelSheet(sheets.getObject("Item", OleVariant.fromString(name)));
    }

    /// Names of all sheets.
    string[] sheetNames() {
        string[] result;
        auto sheets = wb.getObject("Sheets");
        scope(exit) destroy(sheets);
        int count = sheets.getInt("Count");
        for (int i = 1; i <= count; i++) {
            auto sh = sheets.getObject("Item", OleVariant.fromInt(i));
            result ~= sh.getString("Name");
            destroy(sh);
        }
        return result;
    }

    /// Active sheet of this workbook.
    ExcelSheet activeSheet() {
        return new ExcelSheet(wb.getObject("ActiveSheet"));
    }

    /// Activate this workbook window.
    void activate() {
        wb.callVoid("Activate");
    }

    /// Save in place.
    void save() {
        wb.callVoid("Save");
    }

    /// Save As. format: 51 = xlsx, 52 = xlsm, -4143 = xls, 6 = csv.
    void saveAs(string path, int format = 51) {
        wb.callVoid("SaveAs", OleVariant.fromString(path), OleVariant.fromInt(format));
    }

    /// Close workbook. save = true saves changes first.
    void close(bool save = false) {
        wb.callVoid("Close", OleVariant.fromBool(save));
    }

    ~this() {
        if (GC.inFinalizer) return;  // см. ~this() в ExcelApp
        if (wb !is null) {
            wb.release();
        }
    }
}

/// High-level Excel Worksheet wrapper.
class ExcelSheet {
    OleObject sheet;

    this(OleObject sh) {
        sheet = sh;
    }

    /// Sheet name.
    string name() {
        return sheet.getString("Name");
    }

    /// Make this sheet active.
    void activate() {
        sheet.callVoid("Activate");
    }

    /// Rename this sheet.
    void setName(string name) {
        sheet.set("Name", name);
    }

    /// Copy this sheet to a new workbook (becomes the active sheet of the new book).
    void copyToNewWorkbook() {
        sheet.callVoid("Copy");
    }

    /// Copy this sheet into another open workbook (inserted before its first sheet).
    /// The copied sheet becomes the active sheet of the target workbook.
    void copyToWorkbook(ExcelWorkbook target) {
        auto first = target.sheet(1);
        scope(exit) destroy(first);
        sheet.callVoid("Copy", OleVariant.fromDispatch(first.sheet.handle()));
    }

    /// Set cell value (string) by address like "A1".
    void setCellValue(string addr, string val) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        range.set("Value", val);
        destroy(range);
    }

    /// Set cell value (double) by address.
    void setCellValue(string addr, double val) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        range.set("Value", val);
        destroy(range);
    }

    /// Set cell value (int) by address.
    void setCellValue(string addr, int val) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        range.set("Value", val);
        destroy(range);
    }

    /// Set cell value as OLE Automation date (double, days since 1899-12-30).
    void setCellDate(string addr, double oleDate) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        range.set("Value", OleVariant.fromDate(oleDate));
    }

    /// Set cell formula (e.g. "=SUM(A1:A10)").
    void setCellFormula(string addr, string formula) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        range.set("Formula", formula);
    }

    /// Set cell number format (e.g. "DD.MM.YYYY", "#,##0.00").
    void setNumberFormat(string addr, string format) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        range.set("NumberFormat", format);
    }

    /// Get cell value as string.
    string getCellString(string addr) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        return range.getString("Value");
    }

    /// Get cell value as double.
    double getCellDouble(string addr) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        return range.getDouble("Value");
    }

    /// Get cell value as OLE Automation date (double). Check type() first if unsure.
    double getCellDate(string addr) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        return range.get("Value").asDate();
    }

    /// Get cell value as OleVariant (for type inspection).
    OleVariant getCellValue(string addr) {
        auto range = sheet.getObject("Range", OleVariant.fromString(addr));
        scope(exit) destroy(range);
        return range.get("Value");
    }

    ~this() {
        if (GC.inFinalizer) return;  // см. ~this() в ExcelApp
        if (sheet !is null) {
            sheet.release();
        }
    }
}
