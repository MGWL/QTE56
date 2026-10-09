#pragma once

#ifdef _WIN32
  #ifdef QTE56_QINPUTDIALOG_BUILD
    #define QINPUTDIALOG_API __declspec(dllexport)
  #else
    #define QINPUTDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QINPUTDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QINPUTDIALOG_API void* qteQInputDialog_create(void* parent);
QINPUTDIALOG_API void  qteQInputDialog_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QINPUTDIALOG_API void qteQInputDialog_show(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_hide(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_update(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setInputMode(void* _obj, int mode);
QINPUTDIALOG_API int qteQInputDialog_inputMode(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setLabelText(void* _obj, void* text);
QINPUTDIALOG_API void* qteQInputDialog_labelText(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setOption(void* _obj, int option, int on);
QINPUTDIALOG_API int qteQInputDialog_testOption(void* _obj, int option);
QINPUTDIALOG_API void qteQInputDialog_setOptions(void* _obj, int options);
QINPUTDIALOG_API int qteQInputDialog_options(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setTextValue(void* _obj, void* text);
QINPUTDIALOG_API void* qteQInputDialog_textValue(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setTextEchoMode(void* _obj, int mode);
QINPUTDIALOG_API int qteQInputDialog_textEchoMode(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setComboBoxEditable(void* _obj, int editable);
QINPUTDIALOG_API int qteQInputDialog_isComboBoxEditable(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setIntValue(void* _obj, int value);
QINPUTDIALOG_API int qteQInputDialog_intValue(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setIntMinimum(void* _obj, int min);
QINPUTDIALOG_API int qteQInputDialog_intMinimum(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setIntMaximum(void* _obj, int max);
QINPUTDIALOG_API int qteQInputDialog_intMaximum(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setIntRange(void* _obj, int min, int max);
QINPUTDIALOG_API void qteQInputDialog_setIntStep(void* _obj, int step);
QINPUTDIALOG_API int qteQInputDialog_intStep(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setDoubleValue(void* _obj, double value);
QINPUTDIALOG_API double qteQInputDialog_doubleValue(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setDoubleMinimum(void* _obj, double min);
QINPUTDIALOG_API double qteQInputDialog_doubleMinimum(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setDoubleMaximum(void* _obj, double max);
QINPUTDIALOG_API double qteQInputDialog_doubleMaximum(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setDoubleRange(void* _obj, double min, double max);
QINPUTDIALOG_API void qteQInputDialog_setDoubleDecimals(void* _obj, int decimals);
QINPUTDIALOG_API int qteQInputDialog_doubleDecimals(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setOkButtonText(void* _obj, void* text);
QINPUTDIALOG_API void* qteQInputDialog_okButtonText(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setCancelButtonText(void* _obj, void* text);
QINPUTDIALOG_API void* qteQInputDialog_cancelButtonText(void* _obj);
QINPUTDIALOG_API void* qteQInputDialog_minimumSizeHint(void* _obj);
QINPUTDIALOG_API void* qteQInputDialog_sizeHint(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setVisible(void* _obj, int visible);
QINPUTDIALOG_API void* qteQInputDialog_getText(void* _obj, void* parent, void* title, void* label, int echo, void* text, void* ok, int flags, int inputMethodHints);
QINPUTDIALOG_API void* qteQInputDialog_getMultiLineText(void* _obj, void* parent, void* title, void* label, void* text, void* ok, int flags, int inputMethodHints);
QINPUTDIALOG_API int qteQInputDialog_getInt(void* _obj, void* parent, void* title, void* label, int value, int minValue, int maxValue, int step, void* ok, int flags);
QINPUTDIALOG_API double qteQInputDialog_getDouble_wssdddipp(void* _obj, void* parent, void* title, void* label, double value, double minValue, double maxValue, int decimals, void* ok, int flags);
QINPUTDIALOG_API double qteQInputDialog_getDouble_wssdddippd(void* _obj, void* parent, void* title, void* label, double value, double minValue, double maxValue, int decimals, void* ok, int flags, double step);
QINPUTDIALOG_API void qteQInputDialog_setDoubleStep(void* _obj, double step);
QINPUTDIALOG_API double qteQInputDialog_doubleStep(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_done(void* _obj, int result);
QINPUTDIALOG_API int qteQInputDialog_result(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setSizeGripEnabled(void* _obj, int p0);
QINPUTDIALOG_API int qteQInputDialog_isSizeGripEnabled(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_setModal(void* _obj, int modal);
QINPUTDIALOG_API void qteQInputDialog_setResult(void* _obj, int r);
QINPUTDIALOG_API void qteQInputDialog_open(void* _obj);
QINPUTDIALOG_API int qteQInputDialog_exec(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_accept(void* _obj);
QINPUTDIALOG_API void qteQInputDialog_reject(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QINPUTDIALOG_API void qteQInputDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Extra ─────────────────────────────────────────────────────────────────────
// setComboBoxItems(items_sep1): items — строки, объединённые \x01
QINPUTDIALOG_API void qteQInputDialog_setComboBoxItems(void* _obj, void* items_sep1);

} // extern "C"
