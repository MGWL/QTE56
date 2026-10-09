/**
 * gen_qinputdialog.d — GENERATED wrapper for QInputDialog.
 * Module: QInputDialog  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qinputdialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, freeQStringList, t_i__qp, t_i__qp_qp, t_i__qp_qp_qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, toQString, toQStringList;

// New aliases for this module:
mixin(generateAlias("v__qp_qp_qp_i"));
mixin(generateAlias("d__qp"));
mixin(generateAlias("d__qp_qp_qp_qp_d_d_d_i_qp_i"));  // getDouble
mixin(generateAlias("d__qp_qp_qp_i_qp_i_d_d_d_i_qp_i_d"));
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_qp_qp_qp_i_i_i_i_qp_i"));  // getInt
mixin(generateAlias("qp__qp_qp_qp_qp_i_qp_qp_i_i"));  // getText
mixin(generateAlias("qp__qp_qp_qp_qp_qp_qp_i_i"));  // getMultiLineText
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_d_d"));
mixin(generateAlias("v__qp_i_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQInputDialog() {
    mixin(generateFunQt(15000, "qteQInputDialog_create", "QInputDialog"));
    mixin(generateFunQt(15001, "qteQInputDialog_delete", "QInputDialog"));
    mixin(generateFunQt(15002, "qteQInputDialog_show", "QInputDialog"));
    mixin(generateFunQt(15003, "qteQInputDialog_hide", "QInputDialog"));
    mixin(generateFunQt(15004, "qteQInputDialog_update", "QInputDialog"));
    mixin(generateFunQt(15005, "qteQInputDialog_setInputMode", "QInputDialog"));
    mixin(generateFunQt(15006, "qteQInputDialog_inputMode", "QInputDialog"));
    mixin(generateFunQt(15007, "qteQInputDialog_setLabelText", "QInputDialog"));
    mixin(generateFunQt(15008, "qteQInputDialog_labelText", "QInputDialog"));
    mixin(generateFunQt(15009, "qteQInputDialog_setOption", "QInputDialog"));
    mixin(generateFunQt(15010, "qteQInputDialog_testOption", "QInputDialog"));
    mixin(generateFunQt(15011, "qteQInputDialog_setOptions", "QInputDialog"));
    mixin(generateFunQt(15012, "qteQInputDialog_options", "QInputDialog"));
    mixin(generateFunQt(15013, "qteQInputDialog_setTextValue", "QInputDialog"));
    mixin(generateFunQt(15014, "qteQInputDialog_textValue", "QInputDialog"));
    mixin(generateFunQt(15015, "qteQInputDialog_setTextEchoMode", "QInputDialog"));
    mixin(generateFunQt(15016, "qteQInputDialog_textEchoMode", "QInputDialog"));
    mixin(generateFunQt(15017, "qteQInputDialog_setComboBoxEditable", "QInputDialog"));
    mixin(generateFunQt(15018, "qteQInputDialog_isComboBoxEditable", "QInputDialog"));
    mixin(generateFunQt(15019, "qteQInputDialog_setIntValue", "QInputDialog"));
    mixin(generateFunQt(15020, "qteQInputDialog_intValue", "QInputDialog"));
    mixin(generateFunQt(15021, "qteQInputDialog_setIntMinimum", "QInputDialog"));
    mixin(generateFunQt(15022, "qteQInputDialog_intMinimum", "QInputDialog"));
    mixin(generateFunQt(15023, "qteQInputDialog_setIntMaximum", "QInputDialog"));
    mixin(generateFunQt(15024, "qteQInputDialog_intMaximum", "QInputDialog"));
    mixin(generateFunQt(15025, "qteQInputDialog_setIntRange", "QInputDialog"));
    mixin(generateFunQt(15026, "qteQInputDialog_setIntStep", "QInputDialog"));
    mixin(generateFunQt(15027, "qteQInputDialog_intStep", "QInputDialog"));
    mixin(generateFunQt(15028, "qteQInputDialog_setDoubleValue", "QInputDialog"));
    mixin(generateFunQt(15029, "qteQInputDialog_doubleValue", "QInputDialog"));
    mixin(generateFunQt(15030, "qteQInputDialog_setDoubleMinimum", "QInputDialog"));
    mixin(generateFunQt(15031, "qteQInputDialog_doubleMinimum", "QInputDialog"));
    mixin(generateFunQt(15032, "qteQInputDialog_setDoubleMaximum", "QInputDialog"));
    mixin(generateFunQt(15033, "qteQInputDialog_doubleMaximum", "QInputDialog"));
    mixin(generateFunQt(15034, "qteQInputDialog_setDoubleRange", "QInputDialog"));
    mixin(generateFunQt(15035, "qteQInputDialog_setDoubleDecimals", "QInputDialog"));
    mixin(generateFunQt(15036, "qteQInputDialog_doubleDecimals", "QInputDialog"));
    mixin(generateFunQt(15037, "qteQInputDialog_setOkButtonText", "QInputDialog"));
    mixin(generateFunQt(15038, "qteQInputDialog_okButtonText", "QInputDialog"));
    mixin(generateFunQt(15039, "qteQInputDialog_setCancelButtonText", "QInputDialog"));
    mixin(generateFunQt(15040, "qteQInputDialog_cancelButtonText", "QInputDialog"));
    mixin(generateFunQt(15041, "qteQInputDialog_minimumSizeHint", "QInputDialog"));
    mixin(generateFunQt(15042, "qteQInputDialog_sizeHint", "QInputDialog"));
    mixin(generateFunQt(15043, "qteQInputDialog_setVisible", "QInputDialog"));
    mixin(generateFunQt(15044, "qteQInputDialog_getText", "QInputDialog"));
    mixin(generateFunQt(15045, "qteQInputDialog_getMultiLineText", "QInputDialog"));
    mixin(generateFunQt(15046, "qteQInputDialog_getInt", "QInputDialog"));
    mixin(generateFunQt(15047, "qteQInputDialog_getDouble_wssdddipp", "QInputDialog"));
    mixin(generateFunQt(15048, "qteQInputDialog_getDouble_wssdddippd", "QInputDialog"));
    mixin(generateFunQt(15049, "qteQInputDialog_setDoubleStep", "QInputDialog"));
    mixin(generateFunQt(15050, "qteQInputDialog_doubleStep", "QInputDialog"));
    mixin(generateFunQt(15051, "qteQInputDialog_done", "QInputDialog"));
    mixin(generateFunQt(15052, "qteQInputDialog_result", "QInputDialog"));
    mixin(generateFunQt(15053, "qteQInputDialog_setSizeGripEnabled", "QInputDialog"));
    mixin(generateFunQt(15054, "qteQInputDialog_isSizeGripEnabled", "QInputDialog"));
    mixin(generateFunQt(15055, "qteQInputDialog_setModal", "QInputDialog"));
    mixin(generateFunQt(15056, "qteQInputDialog_setResult", "QInputDialog"));
    mixin(generateFunQt(15057, "qteQInputDialog_open", "QInputDialog"));
    mixin(generateFunQt(15058, "qteQInputDialog_exec", "QInputDialog"));
    mixin(generateFunQt(15059, "qteQInputDialog_accept", "QInputDialog"));
    mixin(generateFunQt(15060, "qteQInputDialog_reject", "QInputDialog"));
    mixin(generateFunQt(15061, "qteQInputDialog_setEventHandler", "QInputDialog"));
    mixin(generateFunQt(15062, "qteQInputDialog_setComboBoxItems", "QInputDialog"));
}

static this() {
    registerModule("QInputDialog", "qte56_dialogs.dll", &loadQInputDialog);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QInputDialog.
@live class QInputDialog {
private:
    void* _wh;
    bool  _qt_owned;

public:
    /// Create QInputDialog. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[15000])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[15001] !is null) {
            (cast(t_v__qp)pFunQt[15001])(_wh);
            _wh = null;
        }
    }

    /// show
    QInputDialog show() {
        (cast(t_v__qp)pFunQt[15002])(_wh);
        return this;
    }

    /// hide
    QInputDialog hide() {
        (cast(t_v__qp)pFunQt[15003])(_wh);
        return this;
    }

    /// update
    QInputDialog update() {
        (cast(t_v__qp)pFunQt[15004])(_wh);
        return this;
    }

    /// setInputMode
    QInputDialog setInputMode(int mode) {
        (cast(t_v__qp_i)pFunQt[15005])(_wh, mode);
        return this;
    }

    /// inputMode
    int inputMode() {
        return cast(int)(cast(t_i__qp)pFunQt[15006])(_wh);
    }

    /// setLabelText
    QInputDialog setLabelText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[15007])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// labelText
    string labelText() {
        void* _qs = (cast(t_qp__qp)pFunQt[15008])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setOption
    QInputDialog setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[15009])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int option) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[15010])(_wh, option);
    }

    /// setOptions
    QInputDialog setOptions(int options) {
        (cast(t_v__qp_i)pFunQt[15011])(_wh, options);
        return this;
    }

    /// options
    int options() {
        return cast(int)(cast(t_i__qp)pFunQt[15012])(_wh);
    }

    /// setTextValue
    QInputDialog setTextValue(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[15013])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// textValue
    string textValue() {
        void* _qs = (cast(t_qp__qp)pFunQt[15014])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setTextEchoMode
    QInputDialog setTextEchoMode(int mode) {
        (cast(t_v__qp_i)pFunQt[15015])(_wh, mode);
        return this;
    }

    /// textEchoMode
    int textEchoMode() {
        return cast(int)(cast(t_i__qp)pFunQt[15016])(_wh);
    }

    /// setComboBoxEditable
    QInputDialog setComboBoxEditable(bool editable) {
        (cast(t_v__qp_i)pFunQt[15017])(_wh, editable ? 1 : 0);
        return this;
    }

    /// isComboBoxEditable
    bool isComboBoxEditable() {
        return cast(bool)(cast(t_i__qp)pFunQt[15018])(_wh);
    }

    /// setIntValue
    QInputDialog setIntValue(int value) {
        (cast(t_v__qp_i)pFunQt[15019])(_wh, value);
        return this;
    }

    /// intValue
    int intValue() {
        return cast(int)(cast(t_i__qp)pFunQt[15020])(_wh);
    }

    /// setIntMinimum
    QInputDialog setIntMinimum(int min) {
        (cast(t_v__qp_i)pFunQt[15021])(_wh, min);
        return this;
    }

    /// intMinimum
    int intMinimum() {
        return cast(int)(cast(t_i__qp)pFunQt[15022])(_wh);
    }

    /// setIntMaximum
    QInputDialog setIntMaximum(int max) {
        (cast(t_v__qp_i)pFunQt[15023])(_wh, max);
        return this;
    }

    /// intMaximum
    int intMaximum() {
        return cast(int)(cast(t_i__qp)pFunQt[15024])(_wh);
    }

    /// setIntRange
    QInputDialog setIntRange(int min, int max) {
        (cast(t_v__qp_i_i)pFunQt[15025])(_wh, min, max);
        return this;
    }

    /// setIntStep
    QInputDialog setIntStep(int step) {
        (cast(t_v__qp_i)pFunQt[15026])(_wh, step);
        return this;
    }

    /// intStep
    int intStep() {
        return cast(int)(cast(t_i__qp)pFunQt[15027])(_wh);
    }

    /// setDoubleValue
    QInputDialog setDoubleValue(double value) {
        (cast(t_v__qp_d)pFunQt[15028])(_wh, value);
        return this;
    }

    /// doubleValue
    double doubleValue() {
        return cast(double)(cast(t_d__qp)pFunQt[15029])(_wh);
    }

    /// setDoubleMinimum
    QInputDialog setDoubleMinimum(double min) {
        (cast(t_v__qp_d)pFunQt[15030])(_wh, min);
        return this;
    }

    /// doubleMinimum
    double doubleMinimum() {
        return cast(double)(cast(t_d__qp)pFunQt[15031])(_wh);
    }

    /// setDoubleMaximum
    QInputDialog setDoubleMaximum(double max) {
        (cast(t_v__qp_d)pFunQt[15032])(_wh, max);
        return this;
    }

    /// doubleMaximum
    double doubleMaximum() {
        return cast(double)(cast(t_d__qp)pFunQt[15033])(_wh);
    }

    /// setDoubleRange
    QInputDialog setDoubleRange(double min, double max) {
        (cast(t_v__qp_d_d)pFunQt[15034])(_wh, min, max);
        return this;
    }

    /// setDoubleDecimals
    QInputDialog setDoubleDecimals(int decimals) {
        (cast(t_v__qp_i)pFunQt[15035])(_wh, decimals);
        return this;
    }

    /// doubleDecimals
    int doubleDecimals() {
        return cast(int)(cast(t_i__qp)pFunQt[15036])(_wh);
    }

    /// setOkButtonText
    QInputDialog setOkButtonText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[15037])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// okButtonText
    string okButtonText() {
        void* _qs = (cast(t_qp__qp)pFunQt[15038])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setCancelButtonText
    QInputDialog setCancelButtonText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[15039])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// cancelButtonText
    string cancelButtonText() {
        void* _qs = (cast(t_qp__qp)pFunQt[15040])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// minimumSizeHint
    DSize minimumSizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[15041])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[15042])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setVisible
    QInputDialog setVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[15043])(_wh, visible ? 1 : 0);
        return this;
    }

    /// getText (static) — show text-input dialog. Returns input string; sets *ok on accept/reject.
    static string getText(void* parent, string title, string label,
                          string text = "", bool* ok = null, int flags = 0) {
        auto _ws_title = toQString(title);
        auto _ws_label = toQString(label);
        auto _ws_text = toQString(text);
        void* _qs = (cast(t_qp__qp_qp_qp_qp_i_qp_qp_i_i)pFunQt[15044])(
            null, parent,
            _ws_title,
            _ws_label,
            0, // QLineEdit::Normal
            _ws_text,
            cast(void*)ok, flags, 0);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_label);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return _r;
    }

    /// getMultiLineText (static) — show multi-line text dialog.
    static string getMultiLineText(void* parent, string title, string label,
                                   string text = "", bool* ok = null, int flags = 0) {
        auto _ws_title = toQString(title);
        auto _ws_label = toQString(label);
        auto _ws_text = toQString(text);
        void* _qs = (cast(t_qp__qp_qp_qp_qp_qp_qp_i_i)pFunQt[15045])(
            null, parent,
            _ws_title,
            _ws_label,
            _ws_text,
            cast(void*)ok, flags, 0);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_label);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return _r;
    }

    /// getInt (static) — show integer-input dialog.
    static int getInt(void* parent, string title, string label,
                      int value = 0, int minValue = -2147483647, int maxValue = 2147483647,
                      int step = 1, bool* ok = null, int flags = 0) {
        auto _ws_title = toQString(title);
        auto _ws_label = toQString(label);
        auto _ri = cast(int)(cast(t_i__qp_qp_qp_qp_i_i_i_i_qp_i)pFunQt[15046])(
            null, parent,
            _ws_title,
            _ws_label,
            value, minValue, maxValue, step, cast(void*)ok, flags);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_label);
        return _ri;
    }

    /// getDouble (static) — show double-input dialog.
    static double getDouble(void* parent, string title, string label,
                            double value = 0.0, double minValue = -2147483647.0,
                            double maxValue = 2147483647.0, int decimals = 1,
                            bool* ok = null, int flags = 0) {
        auto _ws_title = toQString(title);
        auto _ws_label = toQString(label);
        auto _rd = cast(double)(cast(t_d__qp_qp_qp_qp_d_d_d_i_qp_i)pFunQt[15047])(
            null, parent,
            _ws_title,
            _ws_label,
            value, minValue, maxValue, decimals, cast(void*)ok, flags);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_label);
        return _rd;
    }

    /// setDoubleStep
    QInputDialog setDoubleStep(double step) {
        (cast(t_v__qp_d)pFunQt[15049])(_wh, step);
        return this;
    }

    /// doubleStep
    double doubleStep() {
        return cast(double)(cast(t_d__qp)pFunQt[15050])(_wh);
    }

    /// done
    QInputDialog done(int result) {
        (cast(t_v__qp_i)pFunQt[15051])(_wh, result);
        return this;
    }

    /// result
    int result() {
        return cast(int)(cast(t_i__qp)pFunQt[15052])(_wh);
    }

    /// setSizeGripEnabled
    QInputDialog setSizeGripEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[15053])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isSizeGripEnabled
    bool isSizeGripEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[15054])(_wh);
    }

    /// setModal
    QInputDialog setModal(bool modal) {
        (cast(t_v__qp_i)pFunQt[15055])(_wh, modal ? 1 : 0);
        return this;
    }

    /// setResult
    QInputDialog setResult(int r) {
        (cast(t_v__qp_i)pFunQt[15056])(_wh, r);
        return this;
    }

    /// open
    QInputDialog open() {
        (cast(t_v__qp)pFunQt[15057])(_wh);
        return this;
    }

    /// exec
    int exec() {
        return cast(int)(cast(t_i__qp)pFunQt[15058])(_wh);
    }

    /// accept
    QInputDialog accept() {
        (cast(t_v__qp)pFunQt[15059])(_wh);
        return this;
    }

    /// reject
    QInputDialog reject() {
        (cast(t_v__qp)pFunQt[15060])(_wh);
        return this;
    }

    /// setComboBoxItems — установить список вариантов в выпадающем комбо.
    QInputDialog setComboBoxItems(string[] items) {
        void* wa = toQStringList(items);
        (cast(t_v__qp_qp)pFunQt[15062])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    /// Connect signal textValueChanged → ESlot
    QInputDialog connect_textValueChanged(ESlot eslot) {
        connectQt(_wh, "textValueChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal textValueSelected → ESlot
    QInputDialog connect_textValueSelected(ESlot eslot) {
        connectQt(_wh, "textValueSelected(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal intValueChanged → ESlot
    QInputDialog connect_intValueChanged(ESlot eslot) {
        connectQt(_wh, "intValueChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal intValueSelected → ESlot
    QInputDialog connect_intValueSelected(ESlot eslot) {
        connectQt(_wh, "intValueSelected(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal doubleValueChanged → ESlot
    QInputDialog connect_doubleValueChanged(ESlot eslot) {
        connectQt(_wh, "doubleValueChanged(double)", eslot, "invoke_d(double)");
        return this;
    }

    /// Connect signal doubleValueSelected → ESlot
    QInputDialog connect_doubleValueSelected(ESlot eslot) {
        connectQt(_wh, "doubleValueSelected(double)", eslot, "invoke_d(double)");
        return this;
    }

    /// Connect signal finished → ESlot
    QInputDialog connect_finished(ESlot eslot) {
        connectQt(_wh, "finished(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal accepted → ESlot
    QInputDialog connect_accepted(ESlot eslot) {
        connectQt(_wh, "accepted()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal rejected → ESlot
    QInputDialog connect_rejected(ESlot eslot) {
        connectQt(_wh, "rejected()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    QInputDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[15061])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QInputDialog onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QInputDialog onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QInputDialog onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QInputDialog onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QInputDialog onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QInputDialog onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    QInputDialog onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QInputDialog onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    QInputDialog onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    QInputDialog onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    QInputDialog onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    QInputDialog onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    QInputDialog onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    QInputDialog onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QInputDialog onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QInputDialog onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    QInputDialog onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    /// Mark as Qt-owned (call after setLayout / reparenting).
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QInputDialog
