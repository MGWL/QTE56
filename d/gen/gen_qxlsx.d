/**
 * gen_qxlsx.d - D-bindings dlja QXlsx (Excel .xlsx)
 *
 * Modul':    QXlsx
 * DLL:       qte56_qxlsx.dll
 * Zavisimosti: QCore (tranzitivno cherez qte56_core)
 */
module gen_qxlsx;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : toQString;

// Alias dlja QXlsx
mixin(generateAlias("i__qp_i_i_qp_i"));   // read: int func(void*, int, int, char*, int)
mixin(generateAlias("i__qp_i_qp_i"));     // sheetName: int func(void*, int, char*, int)
mixin(generateAlias("v__qp_i_i_qp_qp"));  // writeWithFormat: void func(void*, int, int, void*, void*)
mixin(generateAlias("i__qp_i_i_d"));      // writeNumeric: int func(void*, int, int, double)
mixin(generateAlias("i__qp_i_i_i_i_i_i_i_i")); // writeDateTime: int func(void*, int, int, int, int, int, int, int, int)
mixin(generateAlias("i__qp_i_d"));        // setColumnWidth/setRowHeight: int func(void*, int, double)
mixin(generateAlias("d__qp_i"));          // columnWidth/rowHeight: double func(void*, int)
mixin(generateAlias("i__qp_i_i_i_i"));    // mergeCells/unmergeCells: int func(void*, int, int, int, int)
mixin(generateAlias("i__qp_i_i_qp"));     // writeFormula/writeBool/writeBlank: int func(void*, int, int, void*)
mixin(generateAlias("i__qp_i_i_qp_qp_qp")); // writeHyperlink: int func(void*, int, int, void*, void*, void*)
mixin(generateAlias("i__qp_i_i_ip_ip_ip_ip_ip_ip")); // readDateTime: int func(void*, int, int, int*, int*, int*, int*, int*, int*)
mixin(generateAlias("i__qp_i_i_i_i_i"));  // addDataBarRule: int func(void*, int, int, int, int, int)
mixin(generateAlias("i__qp_i_i_i_i_i_i_i")); // add2ColorScaleRule: int func(void*, int, int, int, int, int, int, int)
mixin(generateAlias("qp__i_i_qp_qp_i"));  // DataValidation_new: void* func(int, int, void*, void*, int)
mixin(generateAlias("qp__i_i_i_i"));      // CellRange_new: void* func(int, int, int, int)
mixin(generateAlias("qp__i_i"));          // CellReference_new: void* func(int, int)
mixin(generateAlias("i__qp_i_qp"));       // insertSheet: int func(void*, int, void*)
mixin(generateAlias("i__qp_qp_qp"));      // copySheet: int func(void*, void*, void*)
mixin(generateAlias("i__qp_i_qp_qp"));    // CF_addHighlightCellsRule: int func(void*, int, void*, void*, void*, int)
mixin(generateAlias("v__qp_i_qp"));       // Chart_setAxisTitle: void func(void*, int, void*)

// ═══════════════════════════════════════════════════════════════════════════════
// Constants
// ═══════════════════════════════════════════════════════════════════════════════

/// Horizontal alignment
enum QXlsxAlignH {
    AlignLeft      = 1,
    AlignRight     = 2,
    AlignHCenter   = 3,
    AlignJustify   = 4
}

/// Border style
enum QXlsxBorder {
    BorderNone     = 0,
    BorderThin     = 1,
    BorderMedium   = 2,
    BorderDashed   = 3,
    BorderDotted   = 4,
    BorderThick    = 5,
    BorderDouble   = 6,
    BorderHair     = 7
}

/// Font underline
enum QXlsxFontUnderline {
    FontUnderlineNone           = 0,
    FontUnderlineSingle         = 1,
    FontUnderlineDouble         = 2,
    FontUnderlineSingleAccounting = 3,
    FontUnderlineDoubleAccounting = 4
}

/// Vertical alignment
enum QXlsxAlignV {
    AlignTop        = 0,
    AlignVCenter    = 1,
    AlignBottom     = 2,
    AlignVJustify   = 3,
    AlignVDistributed = 4
}

/// Cell type
enum QXlsxCellType {
    CellTypeNull       = 0,
    CellTypeBoolean    = 1,
    CellTypeNumeric    = 2,
    CellTypeError      = 3,
    CellTypeString     = 4,
    CellTypeFormula    = 5
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxDocument
// ═══════════════════════════════════════════════════════════════════════════════
//
// NOTE: QXlsx supports ONLY .xlsx format (Excel 2007+).
//       .xlsm files (with VBA macros) can be OPENED for reading, but
//       saving them will STRIP all macros (vbaProject.bin), making
//       the file unreadable by Excel. Always save modified files as .xlsx.
//
class QXlsxDocument {
    private void* _wh;

    this(string filename, bool openExisting = false) {
        if (openExisting)
            _wh = (cast(t_qp__qp)pFunQt[21106])(toQString(filename));
        else
            _wh = (cast(t_qp__qp)pFunQt[21100])(toQString(filename));
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21101])(_wh);
    }

    string read(int row, int col) {
        char[1024] buf;
        int len = (cast(t_i__qp_i_i_qp_i)pFunQt[21102])(_wh, row, col, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string) buf[0..len].dup;
    }

    QXlsxDocument write(int row, int col, string value) {
        (cast(t_v__qp_i_i_qp)pFunQt[21103])(_wh, row, col, toQString(value));
        return this;
    }

    bool save() {
        return (cast(t_i__qp)pFunQt[21104])(_wh) != 0;
    }

    /// Save document to file.
    /// WARNING: Only .xlsx format is fully supported.
    /// Saving .xlsm will strip VBA macros and corrupt the file.
    bool saveAs(string name) {
        return (cast(t_i__qp_qp)pFunQt[21105])(_wh, toQString(name)) != 0;
    }

    // Worksheet operations
    int sheetCount() {
        return (cast(t_i__qp)pFunQt[21110])(_wh);
    }

    int currentSheet() {
        return (cast(t_i__qp)pFunQt[21111])(_wh);
    }

    bool setCurrentSheet(int idx) {
        return (cast(t_i__qp_i)pFunQt[21112])(_wh, idx) != 0;
    }

    bool addSheet(string name) {
        return (cast(t_i__qp_qp)pFunQt[21113])(_wh, toQString(name)) != 0;
    }

    bool renameSheet(int idx, string name) {
        return (cast(t_i__qp_i_qp)pFunQt[21114])(_wh, idx, toQString(name)) != 0;
    }

    bool deleteSheet(int idx) {
        return (cast(t_i__qp_i)pFunQt[21115])(_wh, idx) != 0;
    }

    string sheetName(int idx) {
        char[256] buf;
        int len = (cast(t_i__qp_i_qp_i)pFunQt[21116])(_wh, idx, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string) buf[0..len].dup;
    }

    // Cell info
    QXlsxCellType cellType(int row, int col) {
        return cast(QXlsxCellType) (cast(t_i__qp_i_i)pFunQt[21120])(_wh, row, col);
    }

    bool isFormula(int row, int col) {
        return (cast(t_i__qp_i_i)pFunQt[21121])(_wh, row, col) != 0;
    }

    string readFormula(int row, int col) {
        char[1024] buf;
        int len = (cast(t_i__qp_i_i_qp_i)pFunQt[21122])(_wh, row, col, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string) buf[0..len].dup;
    }

    // Dimensions
    int rowCount() {
        return (cast(t_i__qp)pFunQt[21140])(_wh);
    }

    int columnCount() {
        return (cast(t_i__qp)pFunQt[21141])(_wh);
    }

    QXlsxDocument dimension(out int firstRow, out int firstCol, out int lastRow, out int lastCol) {
        firstRow = firstCol = lastRow = lastCol = 0;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[21142])(_wh, &firstRow, &firstCol, &lastRow, &lastCol);
        return this;
    }

    // Write with format
    QXlsxDocument write(int row, int col, string value, QXlsxFormat fmt) {
        (cast(t_v__qp_i_i_qp_qp)pFunQt[21138])(_wh, row, col, toQString(value), fmt._wh);
        return this;
    }

    // Typed writes
    bool writeNumeric(int row, int col, double value) {
        return (cast(t_i__qp_i_i_d)pFunQt[21170])(_wh, row, col, value) != 0;
    }

    bool writeFormula(int row, int col, string formula) {
        return (cast(t_i__qp_i_i_qp)pFunQt[21171])(_wh, row, col, toQString(formula)) != 0;
    }

    bool writeBool(int row, int col, bool value) {
        return (cast(t_i__qp_i_i_i)pFunQt[21172])(_wh, row, col, value ? 1 : 0) != 0;
    }

    bool writeDateTime(int row, int col, int year, int month, int day,
                       int hour = 0, int minute = 0, int second = 0) {
        return (cast(t_i__qp_i_i_i_i_i_i_i_i)pFunQt[21173])
            (_wh, row, col, year, month, day, hour, minute, second) != 0;
    }

    bool writeBlank(int row, int col) {
        return (cast(t_i__qp_i_i)pFunQt[21174])(_wh, row, col) != 0;
    }

    // Row/Column sizing
    bool setColumnWidth(int col, double width) {
        return (cast(t_i__qp_i_d)pFunQt[21180])(_wh, col, width) != 0;
    }

    double columnWidth(int col) {
        return (cast(t_d__qp_i)pFunQt[21181])(_wh, col);
    }

    bool setColumnHidden(int col, bool hidden) {
        return (cast(t_i__qp_i_i)pFunQt[21182])(_wh, col, hidden ? 1 : 0) != 0;
    }

    bool isColumnHidden(int col) {
        return (cast(t_i__qp_i)pFunQt[21183])(_wh, col) != 0;
    }

    bool setRowHeight(int row, double height) {
        return (cast(t_i__qp_i_d)pFunQt[21184])(_wh, row, height) != 0;
    }

    double rowHeight(int row) {
        return (cast(t_d__qp_i)pFunQt[21185])(_wh, row);
    }

    bool setRowHidden(int row, bool hidden) {
        return (cast(t_i__qp_i_i)pFunQt[21186])(_wh, row, hidden ? 1 : 0) != 0;
    }

    bool isRowHidden(int row) {
        return (cast(t_i__qp_i)pFunQt[21187])(_wh, row) != 0;
    }

    // Merge/Unmerge cells
    bool mergeCells(int firstRow, int firstCol, int lastRow, int lastCol) {
        return (cast(t_i__qp_i_i_i_i)pFunQt[21190])(_wh, firstRow, firstCol, lastRow, lastCol) != 0;
    }

    bool unmergeCells(int firstRow, int firstCol, int lastRow, int lastCol) {
        return (cast(t_i__qp_i_i_i_i)pFunQt[21191])(_wh, firstRow, firstCol, lastRow, lastCol) != 0;
    }

    void* getWH() { return _wh; }

    // Images
    int insertImage(int row, int col, ubyte[] data) {
        return (cast(t_i__qp_i_i_qp_i)pFunQt[21210])(_wh, row, col, cast(void*)data.ptr, cast(int)data.length);
    }

    int imageCount() {
        return (cast(t_i__qp)pFunQt[21211])(_wh);
    }

    // Hyperlinks
    bool writeHyperlink(int row, int col, string url, string display = "", string tip = "") {
        return (cast(t_i__qp_i_i_qp_qp_qp)pFunQt[21215])
            (_wh, row, col, toQString(url), toQString(display), toQString(tip)) != 0;
    }

    // Charts
    void* insertChart(int row, int col, int width, int height) {
        return (cast(t_qp__qp_i_i_i_i)pFunQt[21220])(_wh, row, col, width, height);
    }

    // RichString
    bool writeRichString(int row, int col, QXlsxRichString rs) {
        return (cast(t_i__qp_i_i_qp)pFunQt[21254])(_wh, row, col, rs._wh) != 0;
    }

    // Auto-size + CSV
    bool autosizeColumnWidth(int col) {
        return (cast(t_i__qp_i)pFunQt[21280])(_wh, col) != 0;
    }

    bool saveAsCsv(string filename) {
        return (cast(t_i__qp_qp)pFunQt[21281])(_wh, toQString(filename)) != 0;
    }

    // Sheet access by name
    bool selectSheet(string name) {
        return (cast(t_i__qp_qp)pFunQt[21290])(_wh, toQString(name)) != 0;
    }

    bool insertSheet(int idx, string name) {
        return (cast(t_i__qp_i_qp)pFunQt[21291])(_wh, idx, toQString(name)) != 0;
    }

    bool copySheet(string srcName, string distName) {
        return (cast(t_i__qp_qp_qp)pFunQt[21292])(_wh, toQString(srcName), toQString(distName)) != 0;
    }

    bool moveSheet(string srcName, int distIdx) {
        return (cast(t_i__qp_qp_i)pFunQt[21293])(_wh, toQString(srcName), distIdx) != 0;
    }

    bool deleteSheetByName(string name) {
        return (cast(t_i__qp_qp)pFunQt[21294])(_wh, toQString(name)) != 0;
    }

    // Cell inspection
    QXlsxCellType cellTypeAt(int row, int col) {
        return cast(QXlsxCellType)(cast(t_i__qp_i_i)pFunQt[21300])(_wh, row, col);
    }

    bool isDateTimeAt(int row, int col) {
        return (cast(t_i__qp_i_i)pFunQt[21301])(_wh, row, col) != 0;
    }

    bool isRichStringAt(int row, int col) {
        return (cast(t_i__qp_i_i)pFunQt[21302])(_wh, row, col) != 0;
    }

    bool cellFormat(int row, int col, QXlsxFormat fmt) {
        return (cast(t_i__qp_i_i_qp)pFunQt[21303])(_wh, row, col, fmt._wh) != 0;
    }

    bool readDateTime(int row, int col, out int year, out int month, out int day,
                      out int hour, out int minute, out int second) {
        year = month = day = hour = minute = second = 0;
        return (cast(t_i__qp_i_i_ip_ip_ip_ip_ip_ip)pFunQt[21304])
            (_wh, row, col, &year, &month, &day, &hour, &minute, &second) != 0;
    }

    // Conditional Formatting
    bool addConditionalFormatting(QXlsxConditionalFormatting cf) {
        return (cast(t_i__qp_qp)pFunQt[21236])(_wh, cf._wh) != 0;
    }

    // Data Validation
    bool addDataValidation(QXlsxDataValidation dv) {
        return (cast(t_i__qp_qp)pFunQt[21245])(_wh, dv._wh) != 0;
    }
}

class QXlsxFormat {
    package void* _wh;

    this() {
        _wh = (cast(t_qp__)pFunQt[21130])();
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21131])(_wh);
    }

    QXlsxFormat setFontBold(bool bold = true) {
        (cast(t_v__qp_i)pFunQt[21132])(_wh, bold ? 1 : 0);
        return this;
    }

    QXlsxFormat setFontSize(int size) {
        (cast(t_v__qp_i)pFunQt[21133])(_wh, size);
        return this;
    }

    QXlsxFormat setFontColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21134])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setBackgroundColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21135])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setHorizontalAlignment(QXlsxAlignH alignment) {
        (cast(t_v__qp_i)pFunQt[21136])(_wh, cast(int)alignment);
        return this;
    }

    QXlsxFormat setBorderStyle(QXlsxBorder border) {
        (cast(t_v__qp_i)pFunQt[21137])(_wh, cast(int)border);
        return this;
    }

    QXlsxFormat setFontItalic(bool italic = true) {
        (cast(t_v__qp_i)pFunQt[21200])(_wh, italic ? 1 : 0);
        return this;
    }

    QXlsxFormat setFontStrikeOut(bool strike = true) {
        (cast(t_v__qp_i)pFunQt[21201])(_wh, strike ? 1 : 0);
        return this;
    }

    QXlsxFormat setFontUnderline(QXlsxFontUnderline underline) {
        (cast(t_v__qp_i)pFunQt[21202])(_wh, cast(int)underline);
        return this;
    }

    QXlsxFormat setFontName(string name) {
        (cast(t_v__qp_qp)pFunQt[21203])(_wh, toQString(name));
        return this;
    }

    QXlsxFormat setNumberFormat(string format) {
        (cast(t_v__qp_qp)pFunQt[21204])(_wh, toQString(format));
        return this;
    }

    QXlsxFormat setTextWrap(bool wrap = true) {
        (cast(t_v__qp_i)pFunQt[21205])(_wh, wrap ? 1 : 0);
        return this;
    }

    QXlsxFormat setVerticalAlignment(QXlsxAlignV alignment) {
        (cast(t_v__qp_i)pFunQt[21206])(_wh, cast(int)alignment);
        return this;
    }

    QXlsxFormat setRotation(int angle) {
        (cast(t_v__qp_i)pFunQt[21207])(_wh, angle);
        return this;
    }

    QXlsxFormat setLeftBorderStyle(QXlsxBorder style) {
        (cast(t_v__qp_i)pFunQt[21260])(_wh, cast(int)style);
        return this;
    }

    QXlsxFormat setLeftBorderColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21261])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setRightBorderStyle(QXlsxBorder style) {
        (cast(t_v__qp_i)pFunQt[21262])(_wh, cast(int)style);
        return this;
    }

    QXlsxFormat setRightBorderColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21263])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setTopBorderStyle(QXlsxBorder style) {
        (cast(t_v__qp_i)pFunQt[21264])(_wh, cast(int)style);
        return this;
    }

    QXlsxFormat setTopBorderColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21265])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setBottomBorderStyle(QXlsxBorder style) {
        (cast(t_v__qp_i)pFunQt[21266])(_wh, cast(int)style);
        return this;
    }

    QXlsxFormat setBottomBorderColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21267])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setDiagonalBorderStyle(QXlsxBorder style) {
        (cast(t_v__qp_i)pFunQt[21268])(_wh, cast(int)style);
        return this;
    }

    QXlsxFormat setDiagonalBorderColor(int r, int g, int b) {
        (cast(t_v__qp_i_i_i)pFunQt[21269])(_wh, r, g, b);
        return this;
    }

    QXlsxFormat setDiagonalBorderType(int type) {
        (cast(t_v__qp_i)pFunQt[21270])(_wh, type);
        return this;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxCellReference
// ═══════════════════════════════════════════════════════════════════════════════

class QXlsxCellReference {
    package void* _wh;

    this(int row, int col) {
        _wh = (cast(t_qp__i_i)pFunQt[21150])(row, col);
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21151])(_wh);
    }

    int row() {
        return (cast(t_i__qp)pFunQt[21152])(_wh);
    }

    int column() {
        return (cast(t_i__qp)pFunQt[21153])(_wh);
    }

    QXlsxCellReference setRow(int row) {
        (cast(t_v__qp_i)pFunQt[21154])(_wh, row);
        return this;
    }

    QXlsxCellReference setColumn(int col) {
        (cast(t_v__qp_i)pFunQt[21155])(_wh, col);
        return this;
    }

    override string toString() {
        char[32] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[21156])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string) buf[0..len].dup;
    }

    bool isValid() {
        return (cast(t_i__qp)pFunQt[21157])(_wh) != 0;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxCellRange
// ═══════════════════════════════════════════════════════════════════════════════

class QXlsxCellRange {
    package void* _wh;

    this(int firstRow, int firstCol, int lastRow, int lastCol) {
        _wh = (cast(t_qp__i_i_i_i)pFunQt[21160])(firstRow, firstCol, lastRow, lastCol);
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21161])(_wh);
    }

    int firstRow() {
        return (cast(t_i__qp)pFunQt[21162])(_wh);
    }

    int firstColumn() {
        return (cast(t_i__qp)pFunQt[21163])(_wh);
    }

    int lastRow() {
        return (cast(t_i__qp)pFunQt[21164])(_wh);
    }

    int lastColumn() {
        return (cast(t_i__qp)pFunQt[21165])(_wh);
    }

    int rowCount() {
        return (cast(t_i__qp)pFunQt[21166])(_wh);
    }

    int columnCount() {
        return (cast(t_i__qp)pFunQt[21167])(_wh);
    }

    override string toString() {
        char[64] buf;
        int len = (cast(t_i__qp_qp_i)pFunQt[21168])(_wh, cast(void*)buf.ptr, cast(int)buf.length);
        if (len <= 0) return "";
        return cast(string) buf[0..len].dup;
    }

    bool isValid() {
        return (cast(t_i__qp)pFunQt[21169])(_wh) != 0;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxChart
// ═══════════════════════════════════════════════════════════════════════════════

enum QXlsxChartType {
    CT_NoStatementChart = 0,
    CT_AreaChart,
    CT_Area3DChart,
    CT_LineChart,
    CT_Line3DChart,
    CT_StockChart,
    CT_RadarChart,
    CT_ScatterChart,
    CT_PieChart,
    CT_Pie3DChart,
    CT_DoughnutChart,
    CT_BarChart,
    CT_Bar3DChart,
    CT_OfPieChart,
    CT_SurfaceChart,
    CT_Surface3DChart,
    CT_BubbleChart
}

enum QXlsxChartAxisPos {
    ChartAxisNone = -1,
    ChartAxisLeft = 0,
    ChartAxisRight,
    ChartAxisTop,
    ChartAxisBottom
}

class QXlsxChart {
    package void* _wh;

    this(void* wh) {
        _wh = wh;
    }

    QXlsxChart setChartType(QXlsxChartType type) {
        (cast(t_v__qp_i)pFunQt[21221])(_wh, cast(int)type);
        return this;
    }

    QXlsxChart addSeries(int firstRow, int firstCol, int lastRow, int lastCol) {
        (cast(t_v__qp_i_i_i_i)pFunQt[21222])(_wh, firstRow, firstCol, lastRow, lastCol);
        return this;
    }

    QXlsxChart setChartTitle(string title) {
        (cast(t_v__qp_qp)pFunQt[21223])(_wh, toQString(title));
        return this;
    }

    QXlsxChart setAxisTitle(QXlsxChartAxisPos pos, string title) {
        (cast(t_v__qp_i_qp)pFunQt[21224])(_wh, cast(int)pos, toQString(title));
        return this;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxConditionalFormatting
// ═══════════════════════════════════════════════════════════════════════════════

enum QXlsxHighlightRuleType {
    Highlight_LessThan,
    Highlight_LessThanOrEqual,
    Highlight_Equal,
    Highlight_NotEqual,
    Highlight_GreaterThanOrEqual,
    Highlight_GreaterThan,
    Highlight_Between,
    Highlight_NotBetween,
    Highlight_ContainsText,
    Highlight_NotContainsText,
    Highlight_BeginsWith,
    Highlight_EndsWith,
    Highlight_TimePeriod,
    Highlight_Duplicate,
    Highlight_Unique,
    Highlight_Blanks,
    Highlight_NoBlanks,
    Highlight_Errors,
    Highlight_NoErrors,
    Highlight_Top,
    Highlight_TopPercent,
    Highlight_Bottom,
    Highlight_BottomPercent,
    Highlight_AboveAverage,
    Highlight_AboveOrEqualAverage,
    Highlight_AboveStdDev1,
    Highlight_AboveStdDev2,
    Highlight_AboveStdDev3,
    Highlight_BelowAverage,
    Highlight_BelowOrEqualAverage,
    Highlight_BelowStdDev1,
    Highlight_BelowStdDev2,
    Highlight_BelowStdDev3,
    Highlight_Expression
}

class QXlsxConditionalFormatting {
    package void* _wh;

    this() {
        _wh = (cast(t_qp__)pFunQt[21230])();
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21231])(_wh);
    }

    bool addHighlightCellsRule(QXlsxHighlightRuleType type, QXlsxFormat fmt,
                               string formula1 = "", string formula2 = "",
                               bool stopIfTrue = false) {
        return (cast(t_i__qp_i_qp_qp_qp_i)pFunQt[21232])
            (_wh, cast(int)type, toQString(formula1), toQString(formula2), fmt._wh,
             stopIfTrue ? 1 : 0) != 0;
    }

    bool addDataBarRule(int r, int g, int b, bool showData = true, bool stopIfTrue = false) {
        return (cast(t_i__qp_i_i_i_i_i)pFunQt[21233])
            (_wh, r, g, b, showData ? 1 : 0, stopIfTrue ? 1 : 0) != 0;
    }

    bool add2ColorScaleRule(int minR, int minG, int minB, int maxR, int maxG, int maxB,
                            bool stopIfTrue = false) {
        return (cast(t_i__qp_i_i_i_i_i_i_i)pFunQt[21234])
            (_wh, minR, minG, minB, maxR, maxG, maxB, stopIfTrue ? 1 : 0) != 0;
    }

    QXlsxConditionalFormatting addRange(int firstRow, int firstCol, int lastRow, int lastCol) {
        (cast(t_v__qp_i_i_i_i)pFunQt[21235])(_wh, firstRow, firstCol, lastRow, lastCol);
        return this;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxRichString
// ═══════════════════════════════════════════════════════════════════════════════

class QXlsxRichString {
    package void* _wh;

    this(string text = "") {
        _wh = (cast(t_qp__qp)pFunQt[21250])(toQString(text));
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21251])(_wh);
    }

    QXlsxRichString addFragment(string text, QXlsxFormat fmt) {
        (cast(t_v__qp_qp_qp)pFunQt[21252])(_wh, toQString(text), fmt._wh);
        return this;
    }

    int fragmentCount() {
        return (cast(t_i__qp)pFunQt[21253])(_wh);
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QXlsxDataValidation
// ═══════════════════════════════════════════════════════════════════════════════

enum QXlsxValidationType {
    ValidationNone,
    ValidationWhole,
    ValidationDecimal,
    ValidationList,
    ValidationDate,
    ValidationTime,
    ValidationTextLength,
    ValidationCustom
}

enum QXlsxValidationOperator {
    ValidationOpBetween,
    ValidationOpNotBetween,
    ValidationOpEqual,
    ValidationOpNotEqual,
    ValidationOpLessThan,
    ValidationOpLessThanOrEqual,
    ValidationOpGreaterThan,
    ValidationOpGreaterThanOrEqual
}

enum QXlsxErrorStyle {
    ErrorStyleStop,
    ErrorStyleWarning,
    ErrorStyleInformation
}

class QXlsxDataValidation {
    package void* _wh;

    this(QXlsxValidationType type, QXlsxValidationOperator op = QXlsxValidationOperator.ValidationOpBetween,
         string formula1 = "", string formula2 = "", bool allowBlank = false) {
        _wh = (cast(t_qp__i_i_qp_qp_i)pFunQt[21240])
            (cast(int)type, cast(int)op, toQString(formula1), toQString(formula2), allowBlank ? 1 : 0);
    }

    ~this() {
        if (_wh) (cast(t_v__qp)pFunQt[21241])(_wh);
    }

    QXlsxDataValidation setErrorMessage(string error, string title = "") {
        (cast(t_v__qp_qp_qp)pFunQt[21242])(_wh, toQString(error), toQString(title));
        return this;
    }

    QXlsxDataValidation setPromptMessage(string prompt, string title = "") {
        (cast(t_v__qp_qp_qp)pFunQt[21243])(_wh, toQString(prompt), toQString(title));
        return this;
    }

    QXlsxDataValidation addRange(int firstRow, int firstCol, int lastRow, int lastCol) {
        (cast(t_v__qp_i_i_i_i)pFunQt[21244])(_wh, firstRow, firstCol, lastRow, lastCol);
        return this;
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Registration
// ═══════════════════════════════════════════════════════════════════════════════

static this() {
    registerModule("QXlsx", "qte56_qxlsx.dll", &loadQXlsx);
}

void loadQXlsx() {
    mixin(generateFunQt(21100, "qteQXlsxDocument_new",      "QXlsx"));
    mixin(generateFunQt(21101, "qteQXlsxDocument_delete",   "QXlsx"));
    mixin(generateFunQt(21102, "qteQXlsxDocument_read",     "QXlsx"));
    mixin(generateFunQt(21103, "qteQXlsxDocument_write",    "QXlsx"));
    mixin(generateFunQt(21104, "qteQXlsxDocument_save",     "QXlsx"));
    mixin(generateFunQt(21105, "qteQXlsxDocument_saveAs",   "QXlsx"));
    mixin(generateFunQt(21106, "qteQXlsxDocument_open",     "QXlsx"));

    mixin(generateFunQt(21110, "qteQXlsxDocument_sheetCount",       "QXlsx"));
    mixin(generateFunQt(21111, "qteQXlsxDocument_currentSheet",     "QXlsx"));
    mixin(generateFunQt(21112, "qteQXlsxDocument_setCurrentSheet",  "QXlsx"));
    mixin(generateFunQt(21113, "qteQXlsxDocument_addSheet",         "QXlsx"));
    mixin(generateFunQt(21114, "qteQXlsxDocument_renameSheet",      "QXlsx"));
    mixin(generateFunQt(21115, "qteQXlsxDocument_deleteSheet",      "QXlsx"));
    mixin(generateFunQt(21116, "qteQXlsxDocument_sheetName",        "QXlsx"));

    mixin(generateFunQt(21120, "qteQXlsxDocument_cellType",    "QXlsx"));
    mixin(generateFunQt(21121, "qteQXlsxDocument_isFormula",   "QXlsx"));
    mixin(generateFunQt(21122, "qteQXlsxDocument_readFormula", "QXlsx"));

    mixin(generateFunQt(21130, "qteQXlsxFormat_new",                    "QXlsx"));
    mixin(generateFunQt(21131, "qteQXlsxFormat_delete",                 "QXlsx"));
    mixin(generateFunQt(21132, "qteQXlsxFormat_setFontBold",            "QXlsx"));
    mixin(generateFunQt(21133, "qteQXlsxFormat_setFontSize",            "QXlsx"));
    mixin(generateFunQt(21134, "qteQXlsxFormat_setFontColor",           "QXlsx"));
    mixin(generateFunQt(21135, "qteQXlsxFormat_setBackgroundColor",     "QXlsx"));
    mixin(generateFunQt(21136, "qteQXlsxFormat_setHorizontalAlignment", "QXlsx"));
    mixin(generateFunQt(21137, "qteQXlsxFormat_setBorderStyle",         "QXlsx"));
    mixin(generateFunQt(21138, "qteQXlsxDocument_writeWithFormat",      "QXlsx"));

    mixin(generateFunQt(21140, "qteQXlsxDocument_rowCount",    "QXlsx"));
    mixin(generateFunQt(21141, "qteQXlsxDocument_columnCount", "QXlsx"));
    mixin(generateFunQt(21142, "qteQXlsxDocument_dimension",   "QXlsx"));

    // CellReference
    mixin(generateFunQt(21150, "qteCellReference_new",       "QXlsx"));
    mixin(generateFunQt(21151, "qteCellReference_delete",    "QXlsx"));
    mixin(generateFunQt(21152, "qteCellReference_row",       "QXlsx"));
    mixin(generateFunQt(21153, "qteCellReference_column",    "QXlsx"));
    mixin(generateFunQt(21154, "qteCellReference_setRow",    "QXlsx"));
    mixin(generateFunQt(21155, "qteCellReference_setColumn", "QXlsx"));
    mixin(generateFunQt(21156, "qteCellReference_toString",  "QXlsx"));
    mixin(generateFunQt(21157, "qteCellReference_isValid",   "QXlsx"));

    // CellRange
    mixin(generateFunQt(21160, "qteCellRange_new",          "QXlsx"));
    mixin(generateFunQt(21161, "qteCellRange_delete",       "QXlsx"));
    mixin(generateFunQt(21162, "qteCellRange_firstRow",     "QXlsx"));
    mixin(generateFunQt(21163, "qteCellRange_firstColumn",  "QXlsx"));
    mixin(generateFunQt(21164, "qteCellRange_lastRow",      "QXlsx"));
    mixin(generateFunQt(21165, "qteCellRange_lastColumn",   "QXlsx"));
    mixin(generateFunQt(21166, "qteCellRange_rowCount",     "QXlsx"));
    mixin(generateFunQt(21167, "qteCellRange_columnCount",  "QXlsx"));
    mixin(generateFunQt(21168, "qteCellRange_toString",     "QXlsx"));
    mixin(generateFunQt(21169, "qteCellRange_isValid",      "QXlsx"));

    // Write typed values
    mixin(generateFunQt(21170, "qteQXlsxDocument_writeNumeric", "QXlsx"));
    mixin(generateFunQt(21171, "qteQXlsxDocument_writeFormula", "QXlsx"));
    mixin(generateFunQt(21172, "qteQXlsxDocument_writeBool",    "QXlsx"));
    mixin(generateFunQt(21173, "qteQXlsxDocument_writeDateTime", "QXlsx"));
    mixin(generateFunQt(21174, "qteQXlsxDocument_writeBlank",   "QXlsx"));

    // Row/Column sizing
    mixin(generateFunQt(21180, "qteQXlsxDocument_setColumnWidth",  "QXlsx"));
    mixin(generateFunQt(21181, "qteQXlsxDocument_columnWidth",     "QXlsx"));
    mixin(generateFunQt(21182, "qteQXlsxDocument_setColumnHidden", "QXlsx"));
    mixin(generateFunQt(21183, "qteQXlsxDocument_isColumnHidden",  "QXlsx"));
    mixin(generateFunQt(21184, "qteQXlsxDocument_setRowHeight",    "QXlsx"));
    mixin(generateFunQt(21185, "qteQXlsxDocument_rowHeight",       "QXlsx"));
    mixin(generateFunQt(21186, "qteQXlsxDocument_setRowHidden",    "QXlsx"));
    mixin(generateFunQt(21187, "qteQXlsxDocument_isRowHidden",     "QXlsx"));

    // Merge/Unmerge cells
    mixin(generateFunQt(21190, "qteQXlsxDocument_mergeCells",   "QXlsx"));
    mixin(generateFunQt(21191, "qteQXlsxDocument_unmergeCells", "QXlsx"));

    // Extended Format properties
    mixin(generateFunQt(21200, "qteQXlsxFormat_setFontItalic",          "QXlsx"));
    mixin(generateFunQt(21201, "qteQXlsxFormat_setFontStrikeOut",       "QXlsx"));
    mixin(generateFunQt(21202, "qteQXlsxFormat_setFontUnderline",       "QXlsx"));
    mixin(generateFunQt(21203, "qteQXlsxFormat_setFontName",            "QXlsx"));
    mixin(generateFunQt(21204, "qteQXlsxFormat_setNumberFormat",        "QXlsx"));
    mixin(generateFunQt(21205, "qteQXlsxFormat_setTextWrap",            "QXlsx"));
    mixin(generateFunQt(21206, "qteQXlsxFormat_setVerticalAlignment",   "QXlsx"));
    mixin(generateFunQt(21207, "qteQXlsxFormat_setRotation",            "QXlsx"));

    // Images
    mixin(generateFunQt(21210, "qteQXlsxDocument_insertImage",   "QXlsx"));
    mixin(generateFunQt(21211, "qteQXlsxDocument_getImageCount", "QXlsx"));

    // Hyperlinks
    mixin(generateFunQt(21215, "qteQXlsxDocument_writeHyperlink", "QXlsx"));

    // Charts
    mixin(generateFunQt(21220, "qteQXlsxDocument_insertChart", "QXlsx"));
    mixin(generateFunQt(21221, "qteChart_setChartType",        "QXlsx"));
    mixin(generateFunQt(21222, "qteChart_addSeries",           "QXlsx"));
    mixin(generateFunQt(21223, "qteChart_setChartTitle",       "QXlsx"));
    mixin(generateFunQt(21224, "qteChart_setAxisTitle",        "QXlsx"));

    // Conditional Formatting
    mixin(generateFunQt(21230, "qteConditionalFormatting_new",                    "QXlsx"));
    mixin(generateFunQt(21231, "qteConditionalFormatting_delete",                 "QXlsx"));
    mixin(generateFunQt(21232, "qteConditionalFormatting_addHighlightCellsRule",  "QXlsx"));
    mixin(generateFunQt(21233, "qteConditionalFormatting_addDataBarRule",         "QXlsx"));
    mixin(generateFunQt(21234, "qteConditionalFormatting_add2ColorScaleRule",     "QXlsx"));
    mixin(generateFunQt(21235, "qteConditionalFormatting_addRange",               "QXlsx"));
    mixin(generateFunQt(21236, "qteQXlsxDocument_addConditionalFormatting",       "QXlsx"));

    // Data Validation
    mixin(generateFunQt(21240, "qteDataValidation_new",              "QXlsx"));
    mixin(generateFunQt(21241, "qteDataValidation_delete",           "QXlsx"));
    mixin(generateFunQt(21242, "qteDataValidation_setErrorMessage",  "QXlsx"));
    mixin(generateFunQt(21243, "qteDataValidation_setPromptMessage", "QXlsx"));
    mixin(generateFunQt(21244, "qteDataValidation_addRange",         "QXlsx"));
    mixin(generateFunQt(21245, "qteQXlsxDocument_addDataValidation", "QXlsx"));

    // RichString
    mixin(generateFunQt(21250, "qteRichString_new",              "QXlsx"));
    mixin(generateFunQt(21251, "qteRichString_delete",           "QXlsx"));
    mixin(generateFunQt(21252, "qteRichString_addFragment",      "QXlsx"));
    mixin(generateFunQt(21253, "qteRichString_fragmentCount",    "QXlsx"));
    mixin(generateFunQt(21254, "qteQXlsxDocument_writeRichString", "QXlsx"));

    // Individual Border Sides
    mixin(generateFunQt(21260, "qteQXlsxFormat_setLeftBorderStyle",    "QXlsx"));
    mixin(generateFunQt(21261, "qteQXlsxFormat_setLeftBorderColor",    "QXlsx"));
    mixin(generateFunQt(21262, "qteQXlsxFormat_setRightBorderStyle",   "QXlsx"));
    mixin(generateFunQt(21263, "qteQXlsxFormat_setRightBorderColor",   "QXlsx"));
    mixin(generateFunQt(21264, "qteQXlsxFormat_setTopBorderStyle",     "QXlsx"));
    mixin(generateFunQt(21265, "qteQXlsxFormat_setTopBorderColor",     "QXlsx"));
    mixin(generateFunQt(21266, "qteQXlsxFormat_setBottomBorderStyle",  "QXlsx"));
    mixin(generateFunQt(21267, "qteQXlsxFormat_setBottomBorderColor",  "QXlsx"));
    mixin(generateFunQt(21268, "qteQXlsxFormat_setDiagonalBorderStyle", "QXlsx"));
    mixin(generateFunQt(21269, "qteQXlsxFormat_setDiagonalBorderColor", "QXlsx"));
    mixin(generateFunQt(21270, "qteQXlsxFormat_setDiagonalBorderType", "QXlsx"));

    // Auto-size + CSV
    mixin(generateFunQt(21280, "qteQXlsxDocument_autosizeColumnWidth", "QXlsx"));
    mixin(generateFunQt(21281, "qteQXlsxDocument_saveAsCsv",           "QXlsx"));

    // Sheet access by name
    mixin(generateFunQt(21290, "qteQXlsxDocument_selectSheet",       "QXlsx"));
    mixin(generateFunQt(21291, "qteQXlsxDocument_insertSheet",       "QXlsx"));
    mixin(generateFunQt(21292, "qteQXlsxDocument_copySheet",         "QXlsx"));
    mixin(generateFunQt(21293, "qteQXlsxDocument_moveSheet",         "QXlsx"));
    mixin(generateFunQt(21294, "qteQXlsxDocument_deleteSheetByName", "QXlsx"));

    // Cell inspection
    mixin(generateFunQt(21300, "qteQXlsxDocument_cellTypeAt",    "QXlsx"));
    mixin(generateFunQt(21301, "qteQXlsxDocument_isDateTimeAt",  "QXlsx"));
    mixin(generateFunQt(21302, "qteQXlsxDocument_isRichStringAt", "QXlsx"));
    mixin(generateFunQt(21303, "qteQXlsxDocument_cellFormat",    "QXlsx"));
    mixin(generateFunQt(21304, "qteQXlsxDocument_readDateTime",  "QXlsx"));
}
