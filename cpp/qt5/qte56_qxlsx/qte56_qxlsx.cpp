#include "qte56_qxlsx.h"
#include "xlsxdocument.h"
#include "xlsxworksheet.h"
#include "xlsxcell.h"
#include "xlsxformat.h"
#include "xlsxchart.h"
#include "xlsxconditionalformatting.h"
#include "xlsxdatavalidation.h"
#include "xlsxrichstring.h"
#include <cstring>
#include <string>

using namespace QXlsx;

static std::string g_lastError;

// ── Helpers ─────────────────────────────────────────────────────────────────

static Document* castDoc(void* p) {
    return reinterpret_cast<Document*>(p);
}

static Format* castFmt(void* p) {
    return reinterpret_cast<Format*>(p);
}

static QString* castQStr(void* p) {
    return reinterpret_cast<QString*>(p);
}

// copyString: Qt QString* (UTF-16) → D string (UTF-8 через toUtf8)
static int copyString(const QString& qs, char* out, int outLen) {
    QByteArray ba = qs.toUtf8();
    int len = ba.length();
    if (len >= outLen) len = outLen - 1;
    if (len > 0 && out) {
        std::memcpy(out, ba.constData(), len);
        out[len] = '\0';
    }
    return len;
}

// ── QXlsxDocument ───────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteQXlsxDocument_new(void* filename) {
    try {
        // Create NEW empty document
        return new Document();
    } catch (...) {
        return nullptr;
    }
}

QTE56_QXLSX_API void* qteQXlsxDocument_open(void* filename) {
    try {
        if (!filename) return nullptr;
        // Open EXISTING file
        return new Document(*castQStr(filename));
    } catch (...) {
        return nullptr;
    }
}

QTE56_QXLSX_API void qteQXlsxDocument_delete(void* doc) {
    delete castDoc(doc);
}

QTE56_QXLSX_API int qteQXlsxDocument_read(void* doc, int row, int col,
                                            char* out, int outLen) {
    if (!doc || !out || outLen <= 0) return -1;
    Document* d = castDoc(doc);
    auto cell = d->cellAt(row, col);
    if (!cell) return 0;
    return copyString(cell->value().toString(), out, outLen);
}

QTE56_QXLSX_API void qteQXlsxDocument_write(void* doc, int row, int col,
                                               void* value) {
    if (!doc || !value) return;
    castDoc(doc)->write(row, col, *castQStr(value));
}

QTE56_QXLSX_API int qteQXlsxDocument_save(void* doc) {
    if (!doc) return 0;
    return castDoc(doc)->save() ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_saveAs(void* doc, void* name) {
    if (!doc || !name) return 0;
    return castDoc(doc)->saveAs(*castQStr(name)) ? 1 : 0;
}

// ── QXlsxWorksheet ──────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_sheetCount(void* doc) {
    if (!doc) return 0;
    return castDoc(doc)->sheetNames().size();
}

QTE56_QXLSX_API int qteQXlsxDocument_currentSheet(void* doc) {
    if (!doc) return 0;
    // currentSheet() returns QString name; return -1 (use sheetName instead)
    return -1;
}

QTE56_QXLSX_API int qteQXlsxDocument_setCurrentSheet(void* doc, int idx) {
    if (!doc) return 0;
    // No setCurrentSheetIndex() in this QXlsx version
    return 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_addSheet(void* doc, void* name) {
    if (!doc || !name) return 0;
    return castDoc(doc)->addSheet(*castQStr(name)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_renameSheet(void* doc, int idx,
                                                    void* name) {
    if (!doc || !name) return 0;
    QStringList names = castDoc(doc)->sheetNames();
    if (idx < 0 || idx >= names.size()) return 0;
    return castDoc(doc)->renameSheet(names.at(idx), *castQStr(name)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_deleteSheet(void* doc, int idx) {
    if (!doc) return 0;
    QStringList names = castDoc(doc)->sheetNames();
    if (idx < 0 || idx >= names.size()) return 0;
    return castDoc(doc)->deleteSheet(names.at(idx)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_sheetName(void* doc, int idx,
                                                  char* out, int outLen) {
    if (!doc || !out || outLen <= 0) return -1;
    QStringList names = castDoc(doc)->sheetNames();
    if (idx < 0 || idx >= names.size()) return 0;
    return copyString(names.at(idx), out, outLen);
}

// ── QXlsxCell ───────────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_cellType(void* doc, int row, int col) {
    if (!doc) return -1;
    auto cell = castDoc(doc)->cellAt(row, col);
    if (!cell) return 0;
    return static_cast<int>(cell->cellType());
}

QTE56_QXLSX_API int qteQXlsxDocument_isFormula(void* doc, int row, int col) {
    if (!doc) return 0;
    auto cell = castDoc(doc)->cellAt(row, col);
    return (cell && cell->hasFormula()) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_readFormula(void* doc, int row, int col,
                                                    char* out, int outLen) {
    if (!doc || !out || outLen <= 0) return -1;
    auto cell = castDoc(doc)->cellAt(row, col);
    if (!cell || !cell->hasFormula()) return 0;
    // formula() returns CellFormula (incomplete type), use value().toString()
    return copyString(cell->value().toString(), out, outLen);
}

// ── QXlsxFormat ─────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteQXlsxFormat_new() {
    return new Format();
}

QTE56_QXLSX_API void qteQXlsxFormat_delete(void* fmt) {
    delete castFmt(fmt);
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontBold(void* fmt, int bold) {
    if (!fmt) return;
    castFmt(fmt)->setFontBold(bold != 0);
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontSize(void* fmt, int size) {
    if (!fmt) return;
    castFmt(fmt)->setFontSize(size);
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setFontColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setBackgroundColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setPatternBackgroundColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setHorizontalAlignment(void* fmt, int align) {
    if (!fmt) return;
    castFmt(fmt)->setHorizontalAlignment(static_cast<Format::HorizontalAlignment>(align));
}

QTE56_QXLSX_API void qteQXlsxFormat_setBorderStyle(void* fmt, int border) {
    if (!fmt) return;
    castFmt(fmt)->setBorderStyle(static_cast<Format::BorderStyle>(border));
}

QTE56_QXLSX_API void qteQXlsxDocument_writeWithFormat(void* doc, int row, int col,
                                                         void* value,
                                                         void* fmt) {
    if (!doc || !value || !fmt) return;
    castDoc(doc)->write(row, col, *castQStr(value), *castFmt(fmt));
}

// ── QXlsxDimensions ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_rowCount(void* doc) {
    if (!doc) return 0;
    return castDoc(doc)->dimension().lastRow();
}

QTE56_QXLSX_API int qteQXlsxDocument_columnCount(void* doc) {
    if (!doc) return 0;
    return castDoc(doc)->dimension().lastColumn();
}

QTE56_QXLSX_API void qteQXlsxDocument_dimension(void* doc, int* firstRow,
                                                   int* firstCol, int* lastRow,
                                                   int* lastCol) {
    if (!doc) return;
    CellRange range = castDoc(doc)->dimension();
    if (firstRow) *firstRow = range.firstRow();
    if (firstCol) *firstCol = range.firstColumn();
    if (lastRow)  *lastRow  = range.lastRow();
    if (lastCol)  *lastCol  = range.lastColumn();
}

// ── CellReference ───────────────────────────────────────────────────────────

static CellReference* castRef(void* p) {
    return reinterpret_cast<CellReference*>(p);
}

static CellRange* castRange(void* p) {
    return reinterpret_cast<CellRange*>(p);
}

QTE56_QXLSX_API void* qteCellReference_new(int row, int col) {
    return new CellReference(row, col);
}

QTE56_QXLSX_API void qteCellReference_delete(void* ref) {
    delete castRef(ref);
}

QTE56_QXLSX_API int qteCellReference_row(void* ref) {
    if (!ref) return -1;
    return castRef(ref)->row();
}

QTE56_QXLSX_API int qteCellReference_column(void* ref) {
    if (!ref) return -1;
    return castRef(ref)->column();
}

QTE56_QXLSX_API void qteCellReference_setRow(void* ref, int row) {
    if (!ref) return;
    castRef(ref)->setRow(row);
}

QTE56_QXLSX_API void qteCellReference_setColumn(void* ref, int col) {
    if (!ref) return;
    castRef(ref)->setColumn(col);
}

QTE56_QXLSX_API int qteCellReference_toString(void* ref, char* out, int outLen) {
    if (!ref || !out || outLen <= 0) return -1;
    return copyString(castRef(ref)->toString(), out, outLen);
}

QTE56_QXLSX_API int qteCellReference_isValid(void* ref) {
    if (!ref) return 0;
    return castRef(ref)->isValid() ? 1 : 0;
}

// ── CellRange ─────────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteCellRange_new(int firstRow, int firstCol, int lastRow, int lastCol) {
    return new CellRange(firstRow, firstCol, lastRow, lastCol);
}

QTE56_QXLSX_API void qteCellRange_delete(void* range) {
    delete castRange(range);
}

QTE56_QXLSX_API int qteCellRange_firstRow(void* range) {
    if (!range) return -1;
    return castRange(range)->firstRow();
}

QTE56_QXLSX_API int qteCellRange_firstColumn(void* range) {
    if (!range) return -1;
    return castRange(range)->firstColumn();
}

QTE56_QXLSX_API int qteCellRange_lastRow(void* range) {
    if (!range) return -1;
    return castRange(range)->lastRow();
}

QTE56_QXLSX_API int qteCellRange_lastColumn(void* range) {
    if (!range) return -1;
    return castRange(range)->lastColumn();
}

QTE56_QXLSX_API int qteCellRange_rowCount(void* range) {
    if (!range) return 0;
    return castRange(range)->rowCount();
}

QTE56_QXLSX_API int qteCellRange_columnCount(void* range) {
    if (!range) return 0;
    return castRange(range)->columnCount();
}

QTE56_QXLSX_API int qteCellRange_toString(void* range, char* out, int outLen) {
    if (!range || !out || outLen <= 0) return -1;
    return copyString(castRange(range)->toString(), out, outLen);
}

QTE56_QXLSX_API int qteCellRange_isValid(void* range) {
    if (!range) return 0;
    return castRange(range)->isValid() ? 1 : 0;
}

// ── Write typed values ──────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_writeNumeric(void* doc, int row, int col,
                                                     double value) {
    if (!doc) return 0;
    return castDoc(doc)->write(row, col, value) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_writeFormula(void* doc, int row, int col,
                                                     void* formula) {
    if (!doc || !formula) return 0;
    // QXlsx Worksheet::write() auto-detects formula ONLY if string starts with '='
    // We prepend '=' automatically so user can pass formula without it
    QString f = *castQStr(formula);
    if (!f.startsWith(QLatin1String("="))) {
        f.prepend(QLatin1String("="));
    }
    return castDoc(doc)->write(row, col, f) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_writeBool(void* doc, int row, int col,
                                                  int value) {
    if (!doc) return 0;
    return castDoc(doc)->write(row, col, value != 0) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_writeDateTime(void* doc, int row, int col,
                                                      int year, int month, int day,
                                                      int hour, int minute, int second) {
    if (!doc) return 0;
    QDateTime dt(QDate(year, month, day), QTime(hour, minute, second));
    return castDoc(doc)->write(row, col, dt) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_writeBlank(void* doc, int row, int col) {
    if (!doc) return 0;
    return castDoc(doc)->write(row, col, QVariant()) ? 1 : 0;
}

// ── Row/Column sizing ───────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_setColumnWidth(void* doc, int col, double width) {
    if (!doc) return 0;
    return castDoc(doc)->setColumnWidth(col, width) ? 1 : 0;
}

QTE56_QXLSX_API double qteQXlsxDocument_columnWidth(void* doc, int col) {
    if (!doc) return 0.0;
    return castDoc(doc)->columnWidth(col);
}

QTE56_QXLSX_API int qteQXlsxDocument_setColumnHidden(void* doc, int col, int hidden) {
    if (!doc) return 0;
    return castDoc(doc)->setColumnHidden(col, hidden != 0) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_isColumnHidden(void* doc, int col) {
    if (!doc) return 0;
    return castDoc(doc)->isColumnHidden(col) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_setRowHeight(void* doc, int row, double height) {
    if (!doc) return 0;
    return castDoc(doc)->setRowHeight(row, height) ? 1 : 0;
}

QTE56_QXLSX_API double qteQXlsxDocument_rowHeight(void* doc, int row) {
    if (!doc) return 0.0;
    return castDoc(doc)->rowHeight(row);
}

QTE56_QXLSX_API int qteQXlsxDocument_setRowHidden(void* doc, int row, int hidden) {
    if (!doc) return 0;
    return castDoc(doc)->setRowHidden(row, hidden != 0) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_isRowHidden(void* doc, int row) {
    if (!doc) return 0;
    return castDoc(doc)->isRowHidden(row) ? 1 : 0;
}

// ── Merge/Unmerge cells ─────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_mergeCells(void* doc, int firstRow, int firstCol,
                                                  int lastRow, int lastCol) {
    if (!doc) return 0;
    return castDoc(doc)->mergeCells(CellRange(firstRow, firstCol, lastRow, lastCol)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_unmergeCells(void* doc, int firstRow, int firstCol,
                                                    int lastRow, int lastCol) {
    if (!doc) return 0;
    return castDoc(doc)->unmergeCells(CellRange(firstRow, firstCol, lastRow, lastCol)) ? 1 : 0;
}

// ── Extended Format properties ──────────────────────────────────────────────

QTE56_QXLSX_API void qteQXlsxFormat_setFontItalic(void* fmt, int italic) {
    if (!fmt) return;
    castFmt(fmt)->setFontItalic(italic != 0);
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontStrikeOut(void* fmt, int strike) {
    if (!fmt) return;
    castFmt(fmt)->setFontStrikeOut(strike != 0);
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontUnderline(void* fmt, int underline) {
    if (!fmt) return;
    castFmt(fmt)->setFontUnderline(static_cast<Format::FontUnderline>(underline));
}

QTE56_QXLSX_API void qteQXlsxFormat_setFontName(void* fmt, void* name) {
    if (!fmt || !name) return;
    castFmt(fmt)->setFontName(*castQStr(name));
}

QTE56_QXLSX_API void qteQXlsxFormat_setNumberFormat(void* fmt, void* format) {
    if (!fmt || !format) return;
    castFmt(fmt)->setNumberFormat(*castQStr(format));
}

QTE56_QXLSX_API void qteQXlsxFormat_setTextWrap(void* fmt, int wrap) {
    if (!fmt) return;
    castFmt(fmt)->setTextWrap(wrap != 0);
}

QTE56_QXLSX_API void qteQXlsxFormat_setVerticalAlignment(void* fmt, int align) {
    if (!fmt) return;
    castFmt(fmt)->setVerticalAlignment(static_cast<Format::VerticalAlignment>(align));
}

QTE56_QXLSX_API void qteQXlsxFormat_setRotation(void* fmt, int angle) {
    if (!fmt) return;
    castFmt(fmt)->setRotation(angle);
}

// ── Images ──────────────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_insertImage(void* doc, int row, int col,
                                                  const char* data, int dataLen) {
    if (!doc || !data || dataLen <= 0) return 0;
    QImage image;
    if (!image.loadFromData(reinterpret_cast<const uchar*>(data), dataLen))
        return 0;
    return castDoc(doc)->insertImage(row, col, image);
}

QTE56_QXLSX_API int qteQXlsxDocument_getImageCount(void* doc) {
    if (!doc) return 0;
    return static_cast<int>(castDoc(doc)->getImageCount());
}

// ── Hyperlinks ──────────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_writeHyperlink(void* doc, int row, int col,
                                                      void* url, void* display,
                                                      void* tip) {
    if (!doc || !url) return 0;
    // Document doesn't have writeHyperlink; use write with URL text
    QString link = *castQStr(url);
    QString disp = display ? *castQStr(display) : link;
    QString text = disp;
    return castDoc(doc)->write(row, col, text) ? 1 : 0;
}

// ── Charts ───────────────────────────────────────────────────────────────────

static Chart* castChart(void* p) {
    return reinterpret_cast<Chart*>(p);
}

QTE56_QXLSX_API void* qteQXlsxDocument_insertChart(void* doc, int row, int col,
                                                      int width, int height) {
    if (!doc) return nullptr;
    return castDoc(doc)->insertChart(row, col, QSize(width, height));
}

QTE56_QXLSX_API void qteChart_setChartType(void* chart, int type) {
    if (!chart) return;
    castChart(chart)->setChartType(static_cast<Chart::ChartType>(type));
}

QTE56_QXLSX_API void qteChart_addSeries(void* chart, int firstRow, int firstCol,
                                         int lastRow, int lastCol) {
    if (!chart) return;
    castChart(chart)->addSeries(CellRange(firstRow, firstCol, lastRow, lastCol));
}

QTE56_QXLSX_API void qteChart_setChartTitle(void* chart, void* title) {
    if (!chart || !title) return;
    castChart(chart)->setChartTitle(*castQStr(title));
}

QTE56_QXLSX_API void qteChart_setAxisTitle(void* chart, int pos, void* title) {
    if (!chart || !title) return;
    castChart(chart)->setAxisTitle(static_cast<Chart::ChartAxisPos>(pos), *castQStr(title));
}

// ── Conditional Formatting ──────────────────────────────────────────────────

static ConditionalFormatting* castCF(void* p) {
    return reinterpret_cast<ConditionalFormatting*>(p);
}

QTE56_QXLSX_API void* qteConditionalFormatting_new() {
    return new ConditionalFormatting();
}

QTE56_QXLSX_API void qteConditionalFormatting_delete(void* cf) {
    delete castCF(cf);
}

QTE56_QXLSX_API int qteConditionalFormatting_addHighlightCellsRule(void* cf,
                                                                      int type, void* formula1,
                                                                      void* formula2, void* fmt,
                                                                      int stopIfTrue) {
    if (!cf || !fmt) return 0;
    auto ruleType = static_cast<ConditionalFormatting::HighlightRuleType>(type);
    if (formula1 && formula2) {
        return castCF(cf)->addHighlightCellsRule(ruleType, *castQStr(formula1),
                                                   *castQStr(formula2), *castFmt(fmt),
                                                   stopIfTrue != 0) ? 1 : 0;
    } else if (formula1) {
        return castCF(cf)->addHighlightCellsRule(ruleType, *castQStr(formula1),
                                                   *castFmt(fmt), stopIfTrue != 0) ? 1 : 0;
    } else {
        return castCF(cf)->addHighlightCellsRule(ruleType, *castFmt(fmt),
                                                   stopIfTrue != 0) ? 1 : 0;
    }
}

QTE56_QXLSX_API int qteConditionalFormatting_addDataBarRule(void* cf, int r, int g, int b,
                                                              int showData, int stopIfTrue) {
    if (!cf) return 0;
    return castCF(cf)->addDataBarRule(QColor(r, g, b), showData != 0, stopIfTrue != 0) ? 1 : 0;
}

QTE56_QXLSX_API int qteConditionalFormatting_add2ColorScaleRule(void* cf, int minR, int minG,
                                                                  int minB, int maxR, int maxG,
                                                                  int maxB, int stopIfTrue) {
    if (!cf) return 0;
    return castCF(cf)->add2ColorScaleRule(QColor(minR, minG, minB), QColor(maxR, maxG, maxB),
                                          stopIfTrue != 0) ? 1 : 0;
}

QTE56_QXLSX_API void qteConditionalFormatting_addRange(void* cf, int firstRow, int firstCol,
                                                        int lastRow, int lastCol) {
    if (!cf) return;
    castCF(cf)->addRange(firstRow, firstCol, lastRow, lastCol);
}

QTE56_QXLSX_API int qteQXlsxDocument_addConditionalFormatting(void* doc, void* cf) {
    if (!doc || !cf) return 0;
    return castDoc(doc)->addConditionalFormatting(*castCF(cf)) ? 1 : 0;
}

// ── Data Validation ─────────────────────────────────────────────────────────

static DataValidation* castDV(void* p) {
    return reinterpret_cast<DataValidation*>(p);
}

QTE56_QXLSX_API void* qteDataValidation_new(int type, int op, void* formula1,
                                             void* formula2, int allowBlank) {
    QString f1 = formula1 ? *castQStr(formula1) : QString();
    QString f2 = formula2 ? *castQStr(formula2) : QString();
    return new DataValidation(static_cast<DataValidation::ValidationType>(type),
                              static_cast<DataValidation::ValidationOperator>(op),
                              f1, f2, allowBlank != 0);
}

QTE56_QXLSX_API void qteDataValidation_delete(void* dv) {
    delete castDV(dv);
}

QTE56_QXLSX_API void qteDataValidation_setErrorMessage(void* dv, void* error,
                                                        void* title) {
    if (!dv || !error) return;
    QString t = title ? *castQStr(title) : QString();
    castDV(dv)->setErrorMessage(*castQStr(error), t);
}

QTE56_QXLSX_API void qteDataValidation_setPromptMessage(void* dv, void* prompt,
                                                         void* title) {
    if (!dv || !prompt) return;
    QString t = title ? *castQStr(title) : QString();
    castDV(dv)->setPromptMessage(*castQStr(prompt), t);
}

QTE56_QXLSX_API void qteDataValidation_addRange(void* dv, int firstRow, int firstCol,
                                                 int lastRow, int lastCol) {
    if (!dv) return;
    castDV(dv)->addRange(firstRow, firstCol, lastRow, lastCol);
}

QTE56_QXLSX_API int qteQXlsxDocument_addDataValidation(void* doc, void* dv) {
    if (!doc || !dv) return 0;
    return castDoc(doc)->addDataValidation(*castDV(dv)) ? 1 : 0;
}

// ── RichString ──────────────────────────────────────────────────────────────

static RichString* castRS(void* p) {
    return reinterpret_cast<RichString*>(p);
}

QTE56_QXLSX_API void* qteRichString_new(void* text) {
    if (text)
        return new RichString(*castQStr(text));
    return new RichString();
}

QTE56_QXLSX_API void qteRichString_delete(void* rs) {
    delete castRS(rs);
}

QTE56_QXLSX_API void qteRichString_addFragment(void* rs, void* text, void* fmt) {
    if (!rs || !text || !fmt) return;
    castRS(rs)->addFragment(*castQStr(text), *castFmt(fmt));
}

QTE56_QXLSX_API int qteRichString_fragmentCount(void* rs) {
    if (!rs) return 0;
    return castRS(rs)->fragmentCount();
}

QTE56_QXLSX_API int qteQXlsxDocument_writeRichString(void* doc, int row, int col,
                                                       void* rs) {
    if (!doc || !rs) return 0;
    // Document::write() with RichString via QVariant
    return castDoc(doc)->write(row, col, QVariant::fromValue(*castRS(rs))) ? 1 : 0;
}

// ── Individual Border Sides ─────────────────────────────────────────────────

QTE56_QXLSX_API void qteQXlsxFormat_setLeftBorderStyle(void* fmt, int style) {
    if (!fmt) return;
    castFmt(fmt)->setLeftBorderStyle(static_cast<Format::BorderStyle>(style));
}

QTE56_QXLSX_API void qteQXlsxFormat_setLeftBorderColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setLeftBorderColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setRightBorderStyle(void* fmt, int style) {
    if (!fmt) return;
    castFmt(fmt)->setRightBorderStyle(static_cast<Format::BorderStyle>(style));
}

QTE56_QXLSX_API void qteQXlsxFormat_setRightBorderColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setRightBorderColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setTopBorderStyle(void* fmt, int style) {
    if (!fmt) return;
    castFmt(fmt)->setTopBorderStyle(static_cast<Format::BorderStyle>(style));
}

QTE56_QXLSX_API void qteQXlsxFormat_setTopBorderColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setTopBorderColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setBottomBorderStyle(void* fmt, int style) {
    if (!fmt) return;
    castFmt(fmt)->setBottomBorderStyle(static_cast<Format::BorderStyle>(style));
}

QTE56_QXLSX_API void qteQXlsxFormat_setBottomBorderColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setBottomBorderColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setDiagonalBorderStyle(void* fmt, int style) {
    if (!fmt) return;
    castFmt(fmt)->setDiagonalBorderStyle(static_cast<Format::BorderStyle>(style));
}

QTE56_QXLSX_API void qteQXlsxFormat_setDiagonalBorderColor(void* fmt, int r, int g, int b) {
    if (!fmt) return;
    castFmt(fmt)->setDiagonalBorderColor(QColor(r, g, b));
}

QTE56_QXLSX_API void qteQXlsxFormat_setDiagonalBorderType(void* fmt, int type) {
    if (!fmt) return;
    castFmt(fmt)->setDiagonalBorderType(static_cast<Format::DiagonalBorderType>(type));
}

// ── Auto-size + CSV ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_autosizeColumnWidth(void* doc, int col) {
    if (!doc) return 0;
    return castDoc(doc)->autosizeColumnWidth(col) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_saveAsCsv(void* doc, void* filename) {
    if (!doc || !filename) return 0;
    return castDoc(doc)->saveAsCsv(*castQStr(filename)) ? 1 : 0;
}

// ── Sheet access by name ────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_selectSheet(void* doc, void* name) {
    if (!doc || !name) return 0;
    return castDoc(doc)->selectSheet(*castQStr(name)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_insertSheet(void* doc, int idx, void* name) {
    if (!doc || !name) return 0;
    return castDoc(doc)->insertSheet(idx, *castQStr(name)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_copySheet(void* doc, void* srcName, void* distName) {
    if (!doc || !srcName || !distName) return 0;
    return castDoc(doc)->copySheet(*castQStr(srcName), *castQStr(distName)) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_moveSheet(void* doc, void* srcName, int distIdx) {
    if (!doc || !srcName) return 0;
    return castDoc(doc)->moveSheet(*castQStr(srcName), distIdx) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_deleteSheetByName(void* doc, void* name) {
    if (!doc || !name) return 0;
    return castDoc(doc)->deleteSheet(*castQStr(name)) ? 1 : 0;
}

// ── Cell inspection ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int qteQXlsxDocument_cellTypeAt(void* doc, int row, int col) {
    if (!doc) return -1;
    auto cell = castDoc(doc)->cellAt(row, col);
    if (!cell) return -1;
    return static_cast<int>(cell->cellType());
}

QTE56_QXLSX_API int qteQXlsxDocument_isDateTimeAt(void* doc, int row, int col) {
    if (!doc) return 0;
    auto cell = castDoc(doc)->cellAt(row, col);
    return (cell && cell->isDateTime()) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_isRichStringAt(void* doc, int row, int col) {
    if (!doc) return 0;
    auto cell = castDoc(doc)->cellAt(row, col);
    return (cell && cell->isRichString()) ? 1 : 0;
}

QTE56_QXLSX_API int qteQXlsxDocument_cellFormat(void* doc, int row, int col,
                                                   void* fmt) {
    if (!doc || !fmt) return 0;
    auto cell = castDoc(doc)->cellAt(row, col);
    if (!cell) return 0;
    // Copy format to provided Format object
    *castFmt(fmt) = cell->format();
    return 1;
}

QTE56_QXLSX_API int qteQXlsxDocument_readDateTime(void* doc, int row, int col,
                                                    int* year, int* month, int* day,
                                                    int* hour, int* minute, int* second) {
    if (!doc) return 0;
    auto cell = castDoc(doc)->cellAt(row, col);
    if (!cell || !cell->isDateTime()) return 0;
    QVariant dt = cell->dateTime();
    if (dt.type() == QVariant::DateTime) {
        QDateTime d = dt.toDateTime();
        if (year) *year = d.date().year();
        if (month) *month = d.date().month();
        if (day) *day = d.date().day();
        if (hour) *hour = d.time().hour();
        if (minute) *minute = d.time().minute();
        if (second) *second = d.time().second();
        return 1;
    } else if (dt.type() == QVariant::Date) {
        QDate d = dt.toDate();
        if (year) *year = d.year();
        if (month) *month = d.month();
        if (day) *day = d.day();
        if (hour) *hour = 0;
        if (minute) *minute = 0;
        if (second) *second = 0;
        return 1;
    } else if (dt.type() == QVariant::Time) {
        QTime t = dt.toTime();
        if (year) *year = 0;
        if (month) *month = 0;
        if (day) *day = 0;
        if (hour) *hour = t.hour();
        if (minute) *minute = t.minute();
        if (second) *second = t.second();
        return 1;
    }
    return 0;
}
