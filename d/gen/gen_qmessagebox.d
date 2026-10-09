/**
 * gen_qmessagebox.d — GENERATED wrapper for QMessageBox.
 * Module: QMessageBox  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qmessagebox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_i__qp_qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_qp__qp_qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_i, t_v__qp_qp_qp_qp, toQString;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("i__qp_qp_qp_qp_i_i"));
mixin(generateAlias("v__qp_qp_qp_qp"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_i_i"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_i_i_i"));
mixin(generateAlias("i__qp_qp_qp_i_qp_i_qp_i_qp_i_qp_i_i_i"));
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("qp__qp_qp_i_i"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp_i_qp_i"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQMessageBox() {
    mixin(generateFunQt(4800, "qteQMessageBox_create",             "QMessageBox"));
    mixin(generateFunQt(4801, "qteQMessageBox_delete",             "QMessageBox"));
    mixin(generateFunQt(4819, "qteQMessageBox_create_text",        "QMessageBox"));
    mixin(generateFunQt(4820, "qteQMessageBox_show",               "QMessageBox"));
    mixin(generateFunQt(4821, "qteQMessageBox_hide",               "QMessageBox"));
    mixin(generateFunQt(4822, "qteQMessageBox_update",             "QMessageBox"));
    mixin(generateFunQt(4823, "qteQMessageBox_addButton_pp",       "QMessageBox"));
    mixin(generateFunQt(4824, "qteQMessageBox_addButton_sp",       "QMessageBox"));
    mixin(generateFunQt(4825, "qteQMessageBox_addButton_p",        "QMessageBox"));
    mixin(generateFunQt(4826, "qteQMessageBox_removeButton",       "QMessageBox"));
    mixin(generateFunQt(4827, "qteQMessageBox_buttonRole",         "QMessageBox"));
    mixin(generateFunQt(4810, "qteQMessageBox_setStandardButtons", "QMessageBox"));
    mixin(generateFunQt(4811, "qteQMessageBox_standardButtons",    "QMessageBox"));
    mixin(generateFunQt(4828, "qteQMessageBox_standardButton",     "QMessageBox"));
    mixin(generateFunQt(4829, "qteQMessageBox_button",             "QMessageBox"));
    mixin(generateFunQt(4830, "qteQMessageBox_defaultButton",      "QMessageBox"));
    mixin(generateFunQt(4831, "qteQMessageBox_setDefaultButton",   "QMessageBox"));
    mixin(generateFunQt(4832, "qteQMessageBox_escapeButton",       "QMessageBox"));
    mixin(generateFunQt(4833, "qteQMessageBox_setEscapeButton",    "QMessageBox"));
    mixin(generateFunQt(4834, "qteQMessageBox_clickedButton",      "QMessageBox"));
    mixin(generateFunQt(4804, "qteQMessageBox_text",               "QMessageBox"));
    mixin(generateFunQt(4803, "qteQMessageBox_setText",            "QMessageBox"));
    mixin(generateFunQt(4814, "qteQMessageBox_icon",               "QMessageBox"));
    mixin(generateFunQt(4813, "qteQMessageBox_setIcon",            "QMessageBox"));
    mixin(generateFunQt(4835, "qteQMessageBox_textFormat",         "QMessageBox"));
    mixin(generateFunQt(4836, "qteQMessageBox_setTextFormat",      "QMessageBox"));
    mixin(generateFunQt(4837, "qteQMessageBox_setTextInteractionFlags", "QMessageBox"));
    mixin(generateFunQt(4838, "qteQMessageBox_textInteractionFlags",    "QMessageBox"));
    mixin(generateFunQt(4839, "qteQMessageBox_setCheckBox",        "QMessageBox"));
    mixin(generateFunQt(4840, "qteQMessageBox_checkBox",           "QMessageBox"));
    mixin(generateFunQt(4841, "qteQMessageBox_information_wsspp",  "QMessageBox"));
    mixin(generateFunQt(4842, "qteQMessageBox_warning_wsspp",      "QMessageBox"));
    mixin(generateFunQt(4843, "qteQMessageBox_critical_wsspp",     "QMessageBox"));
    mixin(generateFunQt(4844, "qteQMessageBox_about",              "QMessageBox"));
    mixin(generateFunQt(4845, "qteQMessageBox_aboutQt",            "QMessageBox"));
    mixin(generateFunQt(4846, "qteQMessageBox_information_wssiii", "QMessageBox"));
    mixin(generateFunQt(4847, "qteQMessageBox_information_wsssssii","QMessageBox"));
    mixin(generateFunQt(4848, "qteQMessageBox_question_wssiii",    "QMessageBox"));
    mixin(generateFunQt(4849, "qteQMessageBox_question_wsssssii",  "QMessageBox"));
    mixin(generateFunQt(4850, "qteQMessageBox_warning_wssiii",     "QMessageBox"));
    mixin(generateFunQt(4851, "qteQMessageBox_warning_wsssssii",   "QMessageBox"));
    mixin(generateFunQt(4852, "qteQMessageBox_critical_wssiii",    "QMessageBox"));
    mixin(generateFunQt(4853, "qteQMessageBox_critical_wsssssii",  "QMessageBox"));
    mixin(generateFunQt(4854, "qteQMessageBox_buttonText",         "QMessageBox"));
    mixin(generateFunQt(4855, "qteQMessageBox_setButtonText",      "QMessageBox"));
    mixin(generateFunQt(4806, "qteQMessageBox_informativeText",    "QMessageBox"));
    mixin(generateFunQt(4805, "qteQMessageBox_setInformativeText", "QMessageBox"));
    mixin(generateFunQt(4808, "qteQMessageBox_detailedText",       "QMessageBox"));
    mixin(generateFunQt(4807, "qteQMessageBox_setDetailedText",    "QMessageBox"));
    mixin(generateFunQt(4809, "qteQMessageBox_setWindowTitle",     "QMessageBox"));
    mixin(generateFunQt(4856, "qteQMessageBox_setWindowModality",  "QMessageBox"));
    mixin(generateFunQt(4802, "qteQMessageBox_exec",               "QMessageBox"));
    mixin(generateFunQt(4857, "qteQMessageBox_result",             "QMessageBox"));
    mixin(generateFunQt(4858, "qteQMessageBox_setVisible",         "QMessageBox"));
    mixin(generateFunQt(4859, "qteQMessageBox_sizeHint",           "QMessageBox"));
    mixin(generateFunQt(4860, "qteQMessageBox_minimumSizeHint",    "QMessageBox"));
    mixin(generateFunQt(4861, "qteQMessageBox_setSizeGripEnabled", "QMessageBox"));
    mixin(generateFunQt(4862, "qteQMessageBox_isSizeGripEnabled",  "QMessageBox"));
    mixin(generateFunQt(4863, "qteQMessageBox_setModal",           "QMessageBox"));
    mixin(generateFunQt(4864, "qteQMessageBox_setResult",          "QMessageBox"));
    mixin(generateFunQt(4865, "qteQMessageBox_open",               "QMessageBox"));
    mixin(generateFunQt(4866, "qteQMessageBox_done",               "QMessageBox"));
    mixin(generateFunQt(4867, "qteQMessageBox_accept",             "QMessageBox"));
    mixin(generateFunQt(4868, "qteQMessageBox_reject",             "QMessageBox"));
    mixin(generateFunQt(4869, "qteQMessageBox_setEventHandler",        "QMessageBox"));
    mixin(generateFunQt(4870, "qteQMessageBox_connect_buttonClicked",  "QMessageBox"));
    mixin(generateFunQt(4871, "qteQMessageBox_question_wsspp",         "QMessageBox"));
}

static this() {
    registerModule("QMessageBox", "qte56_dialogs.dll", &loadQMessageBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QMessageBox.
@live class QMessageBox {
private:
    void* _wh;
    bool  _qt_owned;

public:
    // ── StandardButton enum constants ────────────────────────────────────────
    enum {
        NoButton        = 0x00000000,
        Ok              = 0x00000400,
        Save            = 0x00000800,
        Open            = 0x00002000,
        Yes             = 0x00004000,
        YesToAll        = 0x00008000,
        No              = 0x00010000,
        NoToAll         = 0x00020000,
        Abort           = 0x00040000,
        Retry           = 0x00080000,
        Ignore          = 0x00100000,
        Close           = 0x00200000,
        Cancel          = 0x00400000,
        Discard         = 0x00800000,
        Help            = 0x01000000,
        Apply           = 0x02000000,
        Reset           = 0x04000000,
        RestoreDefaults = 0x08000000,
    }

    // ── Icon enum constants ───────────────────────────────────────────────────
    enum {
        NoIcon      = 0,
        Question    = 4,
        Information = 1,
        Warning     = 2,
        Critical    = 3,
    }

    /// Create QMessageBox. parent=null → top-level widget.
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[4800])(parent);
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[4801] !is null) {
            (cast(t_v__qp)pFunQt[4801])(_wh);
            _wh = null;
        }
    }

    /// show
    QMessageBox show() {
        (cast(t_v__qp)pFunQt[4820])(_wh);
        return this;
    }

    /// hide
    QMessageBox hide() {
        (cast(t_v__qp)pFunQt[4821])(_wh);
        return this;
    }

    /// update
    QMessageBox update() {
        (cast(t_v__qp)pFunQt[4822])(_wh);
        return this;
    }

    /// addButton(QAbstractButton*, role)
    QMessageBox addButton(void* button, int role) {
        (cast(t_v__qp_qp_i)pFunQt[4823])(_wh, button, role);
        return this;
    }

    /// addButton(text, role) — creates a button and returns its pointer
    void* addButton(string text, int role) {
        auto _ws_text = toQString(text);
        return cast(void*)(cast(t_qp__qp_qp_i)pFunQt[4824])(
            _wh, _ws_text, role);
    }

    /// addButton(StandardButton) — creates standard button, returns pointer
    void* addButton(int button) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[4825])(_wh, button);
    }

    /// removeButton
    QMessageBox removeButton(void* button) {
        (cast(t_v__qp_qp)pFunQt[4826])(_wh, button);
        return this;
    }

    /// buttonRole — returns ButtonRole int
    int buttonRole(void* button) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[4827])(_wh, button);
    }

    /// setStandardButtons
    QMessageBox setStandardButtons(int buttons) {
        (cast(t_v__qp_i)pFunQt[4810])(_wh, buttons);
        return this;
    }

    /// standardButtons
    int standardButtons() {
        return cast(int)(cast(t_i__qp)pFunQt[4811])(_wh);
    }

    /// standardButton — returns StandardButton for given QAbstractButton*
    int standardButton(void* button) {
        return cast(int)(cast(t_i__qp_qp)pFunQt[4828])(_wh, button);
    }

    /// button — returns QAbstractButton* for given StandardButton
    void* button(int which) {
        return cast(void*)(cast(t_qp__qp_i)pFunQt[4829])(_wh, which);
    }

    /// defaultButton — returns QPushButton*
    void* defaultButton() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4830])(_wh);
    }

    /// setDefaultButton(StandardButton)
    QMessageBox setDefaultButton(int button) {
        (cast(t_v__qp_i)pFunQt[4831])(_wh, button);
        return this;
    }

    /// escapeButton — returns QAbstractButton*
    void* escapeButton() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4832])(_wh);
    }

    /// setEscapeButton(StandardButton)
    QMessageBox setEscapeButton(int button) {
        (cast(t_v__qp_i)pFunQt[4833])(_wh, button);
        return this;
    }

    /// clickedButton — returns QAbstractButton* of the button that was clicked
    void* clickedButton() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4834])(_wh);
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[4804])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setText
    QMessageBox setText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[4803])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// icon — returns Icon int (NoIcon/Question/Information/Warning/Critical)
    int icon() {
        return cast(int)(cast(t_i__qp)pFunQt[4814])(_wh);
    }

    /// setIcon
    QMessageBox setIcon(int p0) {
        (cast(t_v__qp_i)pFunQt[4813])(_wh, p0);
        return this;
    }

    /// textFormat
    int textFormat() {
        return cast(int)(cast(t_i__qp)pFunQt[4835])(_wh);
    }

    /// setTextFormat
    QMessageBox setTextFormat(int format) {
        (cast(t_v__qp_i)pFunQt[4836])(_wh, format);
        return this;
    }

    /// setTextInteractionFlags
    QMessageBox setTextInteractionFlags(int flags) {
        (cast(t_v__qp_i)pFunQt[4837])(_wh, flags);
        return this;
    }

    /// textInteractionFlags
    int textInteractionFlags() {
        return cast(int)(cast(t_i__qp)pFunQt[4838])(_wh);
    }

    /// setCheckBox
    QMessageBox setCheckBox(void* cb) {
        (cast(t_v__qp_qp)pFunQt[4839])(_wh, cb);
        return this;
    }

    /// checkBox — returns QCheckBox*
    void* checkBox() {
        return cast(void*)(cast(t_qp__qp)pFunQt[4840])(_wh);
    }

    // ── Static convenience dialogs ───────────────────────────────────────────
    // These are static Qt methods; pass null as _obj.

    /// QMessageBox::information — show information dialog
    static int information(void* parent, string title, string text,
                           int buttons = Ok, int defaultButton = NoButton) {
        auto _ws_title = toQString(title);
        auto _ws_text = toQString(text);
        auto _r = cast(int)(cast(t_i__qp_qp_qp_qp_i_i)pFunQt[4841])(
            null, parent,
            _ws_title,
            _ws_text,
            buttons, defaultButton);

        (cast(t_v__qp)pFunQt[22])(_ws_title);

        (cast(t_v__qp)pFunQt[22])(_ws_text);

        return _r;
    }

    /// QMessageBox::warning — show warning dialog
    static int warning(void* parent, string title, string text,
                       int buttons = Ok, int defaultButton = NoButton) {
        auto _ws_title = toQString(title);
        auto _ws_text = toQString(text);
        auto _r = cast(int)(cast(t_i__qp_qp_qp_qp_i_i)pFunQt[4842])(
            null, parent,
            _ws_title,
            _ws_text,
            buttons, defaultButton);

        (cast(t_v__qp)pFunQt[22])(_ws_title);

        (cast(t_v__qp)pFunQt[22])(_ws_text);

        return _r;
    }

    /// QMessageBox::critical — show critical dialog
    static int critical(void* parent, string title, string text,
                        int buttons = Ok, int defaultButton = NoButton) {
        auto _ws_title = toQString(title);
        auto _ws_text = toQString(text);
        auto _r = cast(int)(cast(t_i__qp_qp_qp_qp_i_i)pFunQt[4843])(
            null, parent,
            _ws_title,
            _ws_text,
            buttons, defaultButton);

        (cast(t_v__qp)pFunQt[22])(_ws_title);

        (cast(t_v__qp)pFunQt[22])(_ws_text);

        return _r;
    }

    /// QMessageBox::question — show question dialog
    static int question(void* parent, string title, string text,
                        int buttons = Yes | No, int defaultButton = NoButton) {
        auto _ws_title = toQString(title);
        auto _ws_text = toQString(text);
        auto _r = cast(int)(cast(t_i__qp_qp_qp_qp_i_i)pFunQt[4871])(
            null, parent,
            _ws_title,
            _ws_text,
            buttons, defaultButton);

        (cast(t_v__qp)pFunQt[22])(_ws_title);

        (cast(t_v__qp)pFunQt[22])(_ws_text);

        return _r;
    }

    /// QMessageBox::about
    static void about(void* parent, string title, string text) {
        auto _ws_title = toQString(title);
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp_qp_qp)pFunQt[4844])(
            null, parent,
            _ws_title,
            _ws_text);
    }

    /// QMessageBox::aboutQt
    static void aboutQt(void* parent, string title = "") {
        auto _ws_title = toQString(title);
        (cast(t_v__qp_qp_qp)pFunQt[4845])(
            null, parent,
            _ws_title);
    }

    /// buttonText — deprecated Qt4 API; returns text of a button by its int id
    string buttonText(int button) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[4854])(_wh, button);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setButtonText — deprecated Qt4 API
    QMessageBox setButtonText(int button, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[4855])(_wh, button, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// informativeText
    string informativeText() {
        void* _qs = (cast(t_qp__qp)pFunQt[4806])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setInformativeText
    QMessageBox setInformativeText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[4805])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// detailedText
    string detailedText() {
        void* _qs = (cast(t_qp__qp)pFunQt[4808])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setDetailedText
    QMessageBox setDetailedText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[4807])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setWindowTitle
    QMessageBox setWindowTitle(string title) {
        auto _ws_title = toQString(title);
        (cast(t_v__qp_qp)pFunQt[4809])(_wh, _ws_title);
        (cast(t_v__qp)pFunQt[22])(_ws_title);
        return this;
    }

    /// setWindowModality (Qt::WindowModality: 0=NonModal, 1=WindowModal, 2=ApplicationModal)
    QMessageBox setWindowModality(int windowModality) {
        (cast(t_v__qp_i)pFunQt[4856])(_wh, windowModality);
        return this;
    }

    /// exec — show dialog modally and return result
    int exec() {
        return cast(int)(cast(t_i__qp)pFunQt[4802])(_wh);
    }

    /// result
    int result() {
        return cast(int)(cast(t_i__qp)pFunQt[4857])(_wh);
    }

    /// setVisible
    QMessageBox setVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[4858])(_wh, visible ? 1 : 0);
        return this;
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[4859])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// minimumSizeHint
    DSize minimumSizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[4860])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setSizeGripEnabled
    QMessageBox setSizeGripEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[4861])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// isSizeGripEnabled
    bool isSizeGripEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[4862])(_wh);
    }

    /// setModal
    QMessageBox setModal(bool modal) {
        (cast(t_v__qp_i)pFunQt[4863])(_wh, modal ? 1 : 0);
        return this;
    }

    /// setResult
    QMessageBox setResult(int r) {
        (cast(t_v__qp_i)pFunQt[4864])(_wh, r);
        return this;
    }

    /// open — show dialog non-modally
    QMessageBox open() {
        (cast(t_v__qp)pFunQt[4865])(_wh);
        return this;
    }

    /// done
    QMessageBox done(int p0) {
        (cast(t_v__qp_i)pFunQt[4866])(_wh, p0);
        return this;
    }

    /// accept
    QMessageBox accept() {
        (cast(t_v__qp)pFunQt[4867])(_wh);
        return this;
    }

    /// reject
    QMessageBox reject() {
        (cast(t_v__qp)pFunQt[4868])(_wh);
        return this;
    }

    // ── Signals ──────────────────────────────────────────────────────────────

    /// Connect signal buttonClicked(QAbstractButton*) → direct callback
    /// cb: extern(C) void function(void* dthis, int n, void* abstractButtonPtr)
    QMessageBox connect_buttonClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[4870])(_wh, cb, dthis);
        return this;
    }

    /// Connect signal finished(int) → ESlot
    QMessageBox connect_finished(ESlot eslot) {
        connectQt(_wh, "finished(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal accepted() → ESlot
    QMessageBox connect_accepted(ESlot eslot) {
        connectQt(_wh, "accepted()", eslot, "invoke_v()");
        return this;
    }

    /// Connect signal rejected() → ESlot
    QMessageBox connect_rejected(ESlot eslot) {
        connectQt(_wh, "rejected()", eslot, "invoke_v()");
        return this;
    }

    // ── Event handlers ───────────────────────────────────────────────────────
    /// Set callback for Qt event by EventId.
    QMessageBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[4869])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QMessageBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    QMessageBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QMessageBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    QMessageBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    QMessageBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Mark as Qt-owned.
    void disown()  { _qt_owned = true; }
    /// True when Qt owns the lifetime.
    bool qtOwned() { return _qt_owned; }
    /// Raw Qt object pointer.
    void* getWH()  { return _wh; }

} // class QMessageBox
