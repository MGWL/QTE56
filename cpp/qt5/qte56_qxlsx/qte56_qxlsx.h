#ifndef QTE56_QXLSX_H
#define QTE56_QXLSX_H

#include <QtGlobal>

#if defined(QTE56_QXLSX_EXPORTS)
#  define QTE56_QXLSX_API Q_DECL_EXPORT
#else
#  define QTE56_QXLSX_API Q_DECL_IMPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

// ── QXlsxDocument ───────────────────────────────────────────────────────────
//
// NOTE: QXlsx supports ONLY .xlsx format (Excel 2007+).
//       .xlsm files (with VBA macros) can be OPENED for reading, but
//       saving them will STRIP all macros (vbaProject.bin), making
//       the file unreadable by Excel. Always save modified files as .xlsx.
//

QTE56_QXLSX_API void* qteQXlsxDocument_new(void* filename);                 // 21100
QTE56_QXLSX_API void* qteQXlsxDocument_open(void* filename);                  // 21106
QTE56_QXLSX_API void  qteQXlsxDocument_delete(void* doc);                   // 21101
QTE56_QXLSX_API int   qteQXlsxDocument_read(void* doc, int row, int col,
                                               char* out, int outLen);      // 21102
QTE56_QXLSX_API void  qteQXlsxDocument_write(void* doc, int row, int col,
                                                void* value);               // 21103
QTE56_QXLSX_API int   qteQXlsxDocument_save(void* doc);                     // 21104
QTE56_QXLSX_API int   qteQXlsxDocument_saveAs(void* doc, void* name);       // 21105
// WARNING: saveAs only supports .xlsx format. Saving .xlsm strips VBA macros.

// ── QXlsxWorksheet ──────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_sheetCount(void* doc);               // 21110
QTE56_QXLSX_API int   qteQXlsxDocument_currentSheet(void* doc);             // 21111
QTE56_QXLSX_API int   qteQXlsxDocument_setCurrentSheet(void* doc, int idx); // 21112
QTE56_QXLSX_API int   qteQXlsxDocument_addSheet(void* doc, void* name);     // 21113
QTE56_QXLSX_API int   qteQXlsxDocument_renameSheet(void* doc, int idx,
                                                      void* name);           // 21114
QTE56_QXLSX_API int   qteQXlsxDocument_deleteSheet(void* doc, int idx);     // 21115
QTE56_QXLSX_API int   qteQXlsxDocument_sheetName(void* doc, int idx,
                                                    char* out, int outLen);  // 21116

// ── QXlsxCell ───────────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_cellType(void* doc, int row, int col); // 21120
QTE56_QXLSX_API int   qteQXlsxDocument_isFormula(void* doc, int row, int col); // 21121
QTE56_QXLSX_API int   qteQXlsxDocument_readFormula(void* doc, int row, int col,
                                                      char* out, int outLen); // 21122

// ── QXlsxFormat ─────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteQXlsxFormat_new();                                 // 21130
QTE56_QXLSX_API void  qteQXlsxFormat_delete(void* fmt);                     // 21131
QTE56_QXLSX_API void  qteQXlsxFormat_setFontBold(void* fmt, int bold);      // 21132
QTE56_QXLSX_API void  qteQXlsxFormat_setFontSize(void* fmt, int size);      // 21133
QTE56_QXLSX_API void  qteQXlsxFormat_setFontColor(void* fmt, int r, int g, int b); // 21134
QTE56_QXLSX_API void  qteQXlsxFormat_setBackgroundColor(void* fmt, int r, int g, int b); // 21135
QTE56_QXLSX_API void  qteQXlsxFormat_setHorizontalAlignment(void* fmt, int align); // 21136
QTE56_QXLSX_API void  qteQXlsxFormat_setBorderStyle(void* fmt, int border); // 21137
QTE56_QXLSX_API void  qteQXlsxDocument_writeWithFormat(void* doc, int row, int col,
                                                          void* value,
                                                          void* fmt);       // 21138

// ── QXlsxDimensions ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_rowCount(void* doc);                 // 21140
QTE56_QXLSX_API int   qteQXlsxDocument_columnCount(void* doc);              // 21141
QTE56_QXLSX_API void  qteQXlsxDocument_dimension(void* doc, int* firstRow,
                                                    int* firstCol, int* lastRow,
                                                    int* lastCol);           // 21142

// ── CellReference ───────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteCellReference_new(int row, int col);               // 21150
QTE56_QXLSX_API void  qteCellReference_delete(void* ref);                   // 21151
QTE56_QXLSX_API int   qteCellReference_row(void* ref);                      // 21152
QTE56_QXLSX_API int   qteCellReference_column(void* ref);                   // 21153
QTE56_QXLSX_API void  qteCellReference_setRow(void* ref, int row);          // 21154
QTE56_QXLSX_API void  qteCellReference_setColumn(void* ref, int col);       // 21155
QTE56_QXLSX_API int   qteCellReference_toString(void* ref, char* out, int outLen); // 21156
QTE56_QXLSX_API int   qteCellReference_isValid(void* ref);                  // 21157

// ── CellRange ─────────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteCellRange_new(int firstRow, int firstCol, int lastRow, int lastCol); // 21160
QTE56_QXLSX_API void  qteCellRange_delete(void* range);                     // 21161
QTE56_QXLSX_API int   qteCellRange_firstRow(void* range);                   // 21162
QTE56_QXLSX_API int   qteCellRange_firstColumn(void* range);                // 21163
QTE56_QXLSX_API int   qteCellRange_lastRow(void* range);                    // 21164
QTE56_QXLSX_API int   qteCellRange_lastColumn(void* range);                 // 21165
QTE56_QXLSX_API int   qteCellRange_rowCount(void* range);                   // 21166
QTE56_QXLSX_API int   qteCellRange_columnCount(void* range);                // 21167
QTE56_QXLSX_API int   qteCellRange_toString(void* range, char* out, int outLen); // 21168
QTE56_QXLSX_API int   qteCellRange_isValid(void* range);                    // 21169

// ── Write typed values ──────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_writeNumeric(void* doc, int row, int col,
                                                       double value);          // 21170
QTE56_QXLSX_API int   qteQXlsxDocument_writeFormula(void* doc, int row, int col,
                                                       void* formula);         // 21171
QTE56_QXLSX_API int   qteQXlsxDocument_writeBool(void* doc, int row, int col,
                                                    int value);                // 21172
QTE56_QXLSX_API int   qteQXlsxDocument_writeDateTime(void* doc, int row, int col,
                                                        int year, int month, int day,
                                                        int hour, int minute, int second); // 21173
QTE56_QXLSX_API int   qteQXlsxDocument_writeBlank(void* doc, int row, int col); // 21174

// ── Row/Column sizing ───────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_setColumnWidth(void* doc, int col, double width); // 21180
QTE56_QXLSX_API double qteQXlsxDocument_columnWidth(void* doc, int col);      // 21181
QTE56_QXLSX_API int   qteQXlsxDocument_setColumnHidden(void* doc, int col, int hidden); // 21182
QTE56_QXLSX_API int   qteQXlsxDocument_isColumnHidden(void* doc, int col);    // 21183
QTE56_QXLSX_API int   qteQXlsxDocument_setRowHeight(void* doc, int row, double height); // 21184
QTE56_QXLSX_API double qteQXlsxDocument_rowHeight(void* doc, int row);        // 21185
QTE56_QXLSX_API int   qteQXlsxDocument_setRowHidden(void* doc, int row, int hidden); // 21186
QTE56_QXLSX_API int   qteQXlsxDocument_isRowHidden(void* doc, int row);       // 21187

// ── Merge/Unmerge cells ─────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_mergeCells(void* doc, int firstRow, int firstCol,
                                                    int lastRow, int lastCol); // 21190
QTE56_QXLSX_API int   qteQXlsxDocument_unmergeCells(void* doc, int firstRow, int firstCol,
                                                      int lastRow, int lastCol); // 21191

// ── Extended Format properties ──────────────────────────────────────────────

QTE56_QXLSX_API void  qteQXlsxFormat_setFontItalic(void* fmt, int italic);    // 21200
QTE56_QXLSX_API void  qteQXlsxFormat_setFontStrikeOut(void* fmt, int strike); // 21201
QTE56_QXLSX_API void  qteQXlsxFormat_setFontUnderline(void* fmt, int underline); // 21202
QTE56_QXLSX_API void  qteQXlsxFormat_setFontName(void* fmt, void* name);      // 21203
QTE56_QXLSX_API void  qteQXlsxFormat_setNumberFormat(void* fmt, void* format); // 21204
QTE56_QXLSX_API void  qteQXlsxFormat_setTextWrap(void* fmt, int wrap);        // 21205
QTE56_QXLSX_API void  qteQXlsxFormat_setVerticalAlignment(void* fmt, int align); // 21206
QTE56_QXLSX_API void  qteQXlsxFormat_setRotation(void* fmt, int angle);       // 21207

// ── Images ──────────────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_insertImage(void* doc, int row, int col,
                                                      const char* data, int dataLen); // 21210
QTE56_QXLSX_API int   qteQXlsxDocument_getImageCount(void* doc);                // 21211

// ── Hyperlinks ──────────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_writeHyperlink(void* doc, int row, int col,
                                                        void* url, void* display,
                                                        void* tip);             // 21215

// ── Charts ───────────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteQXlsxDocument_insertChart(void* doc, int row, int col,
                                                      int width, int height);   // 21220
QTE56_QXLSX_API void  qteChart_setChartType(void* chart, int type);           // 21221
QTE56_QXLSX_API void  qteChart_addSeries(void* chart, int firstRow, int firstCol,
                                           int lastRow, int lastCol);          // 21222
QTE56_QXLSX_API void  qteChart_setChartTitle(void* chart, void* title);       // 21223
QTE56_QXLSX_API void  qteChart_setAxisTitle(void* chart, int pos, void* title); // 21224

// ── Conditional Formatting ──────────────────────────────────────────────────

QTE56_QXLSX_API void* qteConditionalFormatting_new();                       // 21230
QTE56_QXLSX_API void  qteConditionalFormatting_delete(void* cf);            // 21231
QTE56_QXLSX_API int   qteConditionalFormatting_addHighlightCellsRule(void* cf,
                                                                        int type, void* formula1,
                                                                        void* formula2, void* fmt,
                                                                        int stopIfTrue); // 21232
QTE56_QXLSX_API int   qteConditionalFormatting_addDataBarRule(void* cf, int r, int g, int b,
                                                                int showData, int stopIfTrue); // 21233
QTE56_QXLSX_API int   qteConditionalFormatting_add2ColorScaleRule(void* cf, int minR, int minG,
                                                                    int minB, int maxR, int maxG,
                                                                    int maxB, int stopIfTrue); // 21234
QTE56_QXLSX_API void  qteConditionalFormatting_addRange(void* cf, int firstRow, int firstCol,
                                                          int lastRow, int lastCol); // 21235
QTE56_QXLSX_API int   qteQXlsxDocument_addConditionalFormatting(void* doc, void* cf); // 21236

// ── Data Validation ─────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteDataValidation_new(int type, int op, void* formula1,
                                             void* formula2, int allowBlank); // 21240
QTE56_QXLSX_API void  qteDataValidation_delete(void* dv);                   // 21241
QTE56_QXLSX_API void  qteDataValidation_setErrorMessage(void* dv, void* error,
                                                          void* title);      // 21242
QTE56_QXLSX_API void  qteDataValidation_setPromptMessage(void* dv, void* prompt,
                                                           void* title);     // 21243
QTE56_QXLSX_API void  qteDataValidation_addRange(void* dv, int firstRow, int firstCol,
                                                   int lastRow, int lastCol); // 21244
QTE56_QXLSX_API int   qteQXlsxDocument_addDataValidation(void* doc, void* dv); // 21245

// ── RichString ──────────────────────────────────────────────────────────────

QTE56_QXLSX_API void* qteRichString_new(void* text);                        // 21250
QTE56_QXLSX_API void  qteRichString_delete(void* rs);                       // 21251
QTE56_QXLSX_API void  qteRichString_addFragment(void* rs, void* text, void* fmt); // 21252
QTE56_QXLSX_API int   qteRichString_fragmentCount(void* rs);                // 21253
QTE56_QXLSX_API int   qteQXlsxDocument_writeRichString(void* doc, int row, int col,
                                                         void* rs);          // 21254

// ── Individual Border Sides ─────────────────────────────────────────────────

QTE56_QXLSX_API void  qteQXlsxFormat_setLeftBorderStyle(void* fmt, int style);   // 21260
QTE56_QXLSX_API void  qteQXlsxFormat_setLeftBorderColor(void* fmt, int r, int g, int b); // 21261
QTE56_QXLSX_API void  qteQXlsxFormat_setRightBorderStyle(void* fmt, int style);  // 21262
QTE56_QXLSX_API void  qteQXlsxFormat_setRightBorderColor(void* fmt, int r, int g, int b); // 21263
QTE56_QXLSX_API void  qteQXlsxFormat_setTopBorderStyle(void* fmt, int style);    // 21264
QTE56_QXLSX_API void  qteQXlsxFormat_setTopBorderColor(void* fmt, int r, int g, int b); // 21265
QTE56_QXLSX_API void  qteQXlsxFormat_setBottomBorderStyle(void* fmt, int style); // 21266
QTE56_QXLSX_API void  qteQXlsxFormat_setBottomBorderColor(void* fmt, int r, int g, int b); // 21267
QTE56_QXLSX_API void  qteQXlsxFormat_setDiagonalBorderStyle(void* fmt, int style); // 21268
QTE56_QXLSX_API void  qteQXlsxFormat_setDiagonalBorderColor(void* fmt, int r, int g, int b); // 21269
QTE56_QXLSX_API void  qteQXlsxFormat_setDiagonalBorderType(void* fmt, int type); // 21270

// ── Auto-size + CSV ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_autosizeColumnWidth(void* doc, int col); // 21280
QTE56_QXLSX_API int   qteQXlsxDocument_saveAsCsv(void* doc, void* filename);    // 21281

// ── Sheet access by name ────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_selectSheet(void* doc, void* name);    // 21290
QTE56_QXLSX_API int   qteQXlsxDocument_insertSheet(void* doc, int idx, void* name); // 21291
QTE56_QXLSX_API int   qteQXlsxDocument_copySheet(void* doc, void* srcName, void* distName); // 21292
QTE56_QXLSX_API int   qteQXlsxDocument_moveSheet(void* doc, void* srcName, int distIdx); // 21293
QTE56_QXLSX_API int   qteQXlsxDocument_deleteSheetByName(void* doc, void* name); // 21294

// ── Cell inspection ─────────────────────────────────────────────────────────

QTE56_QXLSX_API int   qteQXlsxDocument_cellTypeAt(void* doc, int row, int col); // 21300
QTE56_QXLSX_API int   qteQXlsxDocument_isDateTimeAt(void* doc, int row, int col); // 21301
QTE56_QXLSX_API int   qteQXlsxDocument_isRichStringAt(void* doc, int row, int col); // 21302
QTE56_QXLSX_API int   qteQXlsxDocument_cellFormat(void* doc, int row, int col,
                                                     void* fmt);                  // 21303
QTE56_QXLSX_API int   qteQXlsxDocument_readDateTime(void* doc, int row, int col,
                                                      int* year, int* month, int* day,
                                                      int* hour, int* minute, int* second); // 21304

#ifdef __cplusplus
}
#endif

#endif // QTE56_QXLSX_H
