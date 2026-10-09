/**
 * gen_qfiledialog.d — GENERATED wrapper for QFileDialog.
 * Module: QFileDialog  |  DLL: qte56_dialogs.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qfiledialog;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, freeQStringList, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString, toQStringList;
import gen_qdialog : QDialog;

// New aliases for this module:
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("qp__qp_qp_qp_i_qp_i_i"));
mixin(generateAlias("qp__qp_qp_qp_i_qp_i_qp_i_qp_i"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));
// Correct types for new QString* API:
mixin(generateAlias("qp__qp_qp_qp_qp_qp_qp_i")); // getOpenFileName/getSaveFileName (7 args: null,parent,caption,dir,filter,selectedFilter,options)
mixin(generateAlias("qp__qp_qp_qp_qp_i"));        // getExistingDirectory (5 args: null,parent,caption,dir,options)

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQFileDialog() {
    mixin(generateFunQt(6800, "qteQFileDialog_create", "QFileDialog"));
    mixin(generateFunQt(6801, "qteQFileDialog_delete", "QFileDialog"));
    mixin(generateFunQt(6805, "qteQFileDialog_setDirectory", "QFileDialog"));
    mixin(generateFunQt(6806, "qteQFileDialog_selectFile", "QFileDialog"));
    mixin(generateFunQt(6807, "qteQFileDialog_setNameFilterDetailsVisible", "QFileDialog"));
    mixin(generateFunQt(6808, "qteQFileDialog_isNameFilterDetailsVisible", "QFileDialog"));
    mixin(generateFunQt(6809, "qteQFileDialog_setNameFilter", "QFileDialog"));
    mixin(generateFunQt(6810, "qteQFileDialog_selectNameFilter", "QFileDialog"));
    mixin(generateFunQt(6811, "qteQFileDialog_selectedMimeTypeFilter", "QFileDialog"));
    mixin(generateFunQt(6812, "qteQFileDialog_selectedNameFilter", "QFileDialog"));
    mixin(generateFunQt(6813, "qteQFileDialog_selectMimeTypeFilter", "QFileDialog"));
    mixin(generateFunQt(6814, "qteQFileDialog_filter", "QFileDialog"));
    mixin(generateFunQt(6815, "qteQFileDialog_setFilter", "QFileDialog"));
    mixin(generateFunQt(6816, "qteQFileDialog_setViewMode", "QFileDialog"));
    mixin(generateFunQt(6817, "qteQFileDialog_viewMode", "QFileDialog"));
    mixin(generateFunQt(6818, "qteQFileDialog_setFileMode", "QFileDialog"));
    mixin(generateFunQt(6819, "qteQFileDialog_fileMode", "QFileDialog"));
    mixin(generateFunQt(6820, "qteQFileDialog_setAcceptMode", "QFileDialog"));
    mixin(generateFunQt(6821, "qteQFileDialog_acceptMode", "QFileDialog"));
    mixin(generateFunQt(6822, "qteQFileDialog_setReadOnly", "QFileDialog"));
    mixin(generateFunQt(6823, "qteQFileDialog_isReadOnly", "QFileDialog"));
    mixin(generateFunQt(6824, "qteQFileDialog_setResolveSymlinks", "QFileDialog"));
    mixin(generateFunQt(6825, "qteQFileDialog_resolveSymlinks", "QFileDialog"));
    mixin(generateFunQt(6826, "qteQFileDialog_setConfirmOverwrite", "QFileDialog"));
    mixin(generateFunQt(6827, "qteQFileDialog_confirmOverwrite", "QFileDialog"));
    mixin(generateFunQt(6828, "qteQFileDialog_setDefaultSuffix", "QFileDialog"));
    mixin(generateFunQt(6829, "qteQFileDialog_defaultSuffix", "QFileDialog"));
    mixin(generateFunQt(6830, "qteQFileDialog_setItemDelegate", "QFileDialog"));
    mixin(generateFunQt(6831, "qteQFileDialog_itemDelegate", "QFileDialog"));
    mixin(generateFunQt(6832, "qteQFileDialog_setIconProvider", "QFileDialog"));
    mixin(generateFunQt(6833, "qteQFileDialog_iconProvider", "QFileDialog"));
    mixin(generateFunQt(6834, "qteQFileDialog_setLabelText", "QFileDialog"));
    mixin(generateFunQt(6835, "qteQFileDialog_labelText", "QFileDialog"));
    mixin(generateFunQt(6836, "qteQFileDialog_setProxyModel", "QFileDialog"));
    mixin(generateFunQt(6837, "qteQFileDialog_proxyModel", "QFileDialog"));
    mixin(generateFunQt(6838, "qteQFileDialog_setOption", "QFileDialog"));
    mixin(generateFunQt(6839, "qteQFileDialog_testOption", "QFileDialog"));
    mixin(generateFunQt(6840, "qteQFileDialog_setOptions", "QFileDialog"));
    mixin(generateFunQt(6841, "qteQFileDialog_options", "QFileDialog"));
    mixin(generateFunQt(6843, "qteQFileDialog_getOpenFileName", "QFileDialog"));
    mixin(generateFunQt(6844, "qteQFileDialog_getSaveFileName", "QFileDialog"));
    mixin(generateFunQt(6845, "qteQFileDialog_getExistingDirectory", "QFileDialog"));
    mixin(generateFunQt(6846, "qteQFileDialog_setEventHandler", "QFileDialog"));
    mixin(generateFunQt(6847, "qteQFileDialog_setNameFilters", "QFileDialog"));
}

static this() {
    registerModule("QFileDialog", "qte56_dialogs.dll", &loadQFileDialog);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QFileDialog.
@live class QFileDialog : QDialog {
public:
    /// Create QFileDialog. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[6800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// setDirectory
    QFileDialog setDirectory(string directory) {
        auto _ws_directory = toQString(directory);
        (cast(t_v__qp_qp)pFunQt[6805])(_wh, _ws_directory);
        (cast(t_v__qp)pFunQt[22])(_ws_directory);
        return this;
    }

    /// selectFile
    QFileDialog selectFile(string filename) {
        auto _ws_filename = toQString(filename);
        (cast(t_v__qp_qp)pFunQt[6806])(_wh, _ws_filename);
        (cast(t_v__qp)pFunQt[22])(_ws_filename);
        return this;
    }

    /// setNameFilterDetailsVisible
    QFileDialog setNameFilterDetailsVisible(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6807])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// isNameFilterDetailsVisible
    bool isNameFilterDetailsVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[6808])(_wh);
    }

    /// setNameFilter — один фильтр, например "Images (*.png *.jpg)".
    QFileDialog setNameFilter(string filter) {
        auto _ws_filter = toQString(filter);
        (cast(t_v__qp_qp)pFunQt[6809])(_wh, _ws_filter);
        (cast(t_v__qp)pFunQt[22])(_ws_filter);
        return this;
    }

    /// setNameFilters — список фильтров, например:
    ///   ["Images (*.png *.jpg)", "Text files (*.txt)", "All files (*)"]
    QFileDialog setNameFilters(string[] filters) {
        void* wa = toQStringList(filters);
        (cast(t_v__qp_qp)pFunQt[6847])(_wh, wa);
        freeQStringList(wa);
        return this;
    }

    /// selectNameFilter
    QFileDialog selectNameFilter(string filter) {
        auto _ws_filter = toQString(filter);
        (cast(t_v__qp_qp)pFunQt[6810])(_wh, _ws_filter);
        (cast(t_v__qp)pFunQt[22])(_ws_filter);
        return this;
    }

    /// selectedMimeTypeFilter
    string selectedMimeTypeFilter() {
        void* _qs = (cast(t_qp__qp)pFunQt[6811])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// selectedNameFilter
    string selectedNameFilter() {
        void* _qs = (cast(t_qp__qp)pFunQt[6812])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// selectMimeTypeFilter
    QFileDialog selectMimeTypeFilter(string filter) {
        auto _ws_filter = toQString(filter);
        (cast(t_v__qp_qp)pFunQt[6813])(_wh, _ws_filter);
        (cast(t_v__qp)pFunQt[22])(_ws_filter);
        return this;
    }

    /// filter
    int filter() {
        return cast(int)(cast(t_i__qp)pFunQt[6814])(_wh);
    }

    /// setFilter
    QFileDialog setFilter(int filters) {
        (cast(t_v__qp_i)pFunQt[6815])(_wh, filters);
        return this;
    }

    /// setViewMode
    QFileDialog setViewMode(int mode) {
        (cast(t_v__qp_i)pFunQt[6816])(_wh, mode);
        return this;
    }

    /// viewMode
    int viewMode() {
        return cast(int)(cast(t_i__qp)pFunQt[6817])(_wh);
    }

    /// setFileMode
    QFileDialog setFileMode(int mode) {
        (cast(t_v__qp_i)pFunQt[6818])(_wh, mode);
        return this;
    }

    /// fileMode
    int fileMode() {
        return cast(int)(cast(t_i__qp)pFunQt[6819])(_wh);
    }

    /// setAcceptMode
    QFileDialog setAcceptMode(int mode) {
        (cast(t_v__qp_i)pFunQt[6820])(_wh, mode);
        return this;
    }

    /// acceptMode
    int acceptMode() {
        return cast(int)(cast(t_i__qp)pFunQt[6821])(_wh);
    }

    /// setReadOnly
    QFileDialog setReadOnly(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6822])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// isReadOnly
    bool isReadOnly() {
        return cast(bool)(cast(t_i__qp)pFunQt[6823])(_wh);
    }

    /// setResolveSymlinks
    QFileDialog setResolveSymlinks(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6824])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// resolveSymlinks
    bool resolveSymlinks() {
        return cast(bool)(cast(t_i__qp)pFunQt[6825])(_wh);
    }

    /// setConfirmOverwrite
    QFileDialog setConfirmOverwrite(bool enabled) {
        (cast(t_v__qp_i)pFunQt[6826])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// confirmOverwrite
    bool confirmOverwrite() {
        return cast(bool)(cast(t_i__qp)pFunQt[6827])(_wh);
    }

    /// setDefaultSuffix
    QFileDialog setDefaultSuffix(string suffix) {
        auto _ws_suffix = toQString(suffix);
        (cast(t_v__qp_qp)pFunQt[6828])(_wh, _ws_suffix);
        (cast(t_v__qp)pFunQt[22])(_ws_suffix);
        return this;
    }

    /// defaultSuffix
    string defaultSuffix() {
        void* _qs = (cast(t_qp__qp)pFunQt[6829])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setItemDelegate
    QFileDialog setItemDelegate(void* delegate_) {
        (cast(t_v__qp_qp)pFunQt[6830])(_wh, delegate_);
        return this;
    }

    /// itemDelegate
    void* itemDelegate() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6831])(_wh);
    }

    /// setIconProvider
    QFileDialog setIconProvider(void* provider) {
        (cast(t_v__qp_qp)pFunQt[6832])(_wh, provider);
        return this;
    }

    /// iconProvider
    void* iconProvider() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6833])(_wh);
    }

    /// setLabelText
    QFileDialog setLabelText(int label, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[6834])(_wh, label, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// labelText
    string labelText(int label) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[6835])(_wh, label);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setProxyModel
    QFileDialog setProxyModel(void* model) {
        (cast(t_v__qp_qp)pFunQt[6836])(_wh, model);
        return this;
    }

    /// proxyModel
    void* proxyModel() {
        return cast(void*)(cast(t_qp__qp)pFunQt[6837])(_wh);
    }

    /// setOption
    QFileDialog setOption(int option, bool on) {
        (cast(t_v__qp_i_i)pFunQt[6838])(_wh, option, on ? 1 : 0);
        return this;
    }

    /// testOption
    bool testOption(int option) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[6839])(_wh, option);
    }

    /// setOptions
    QFileDialog setOptions(int options) {
        (cast(t_v__qp_i)pFunQt[6840])(_wh, options);
        return this;
    }

    /// options
    int options() {
        return cast(int)(cast(t_i__qp)pFunQt[6841])(_wh);
    }

    /// getOpenFileName (static — create file open dialog, returns selected path or "")
    static string getOpenFileName(void* parent = null, string caption = "", string dir = "", string filter = "", void* selectedFilter = null, int options = 0) {
        auto _ws_caption = toQString(caption);
        auto _ws_dir = toQString(dir);
        auto _ws_filter = toQString(filter);
        void* _qs = (cast(t_qp__qp_qp_qp_qp_qp_qp_i)pFunQt[6843])(null, parent, _ws_caption, _ws_dir, _ws_filter, selectedFilter, options);
        (cast(t_v__qp)pFunQt[22])(_ws_caption);
        (cast(t_v__qp)pFunQt[22])(_ws_dir);
        (cast(t_v__qp)pFunQt[22])(_ws_filter);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// getSaveFileName (static — create file save dialog, returns selected path or "")
    static string getSaveFileName(void* parent = null, string caption = "", string dir = "", string filter = "", void* selectedFilter = null, int options = 0) {
        auto _ws_caption = toQString(caption);
        auto _ws_dir = toQString(dir);
        auto _ws_filter = toQString(filter);
        void* _qs = (cast(t_qp__qp_qp_qp_qp_qp_qp_i)pFunQt[6844])(null, parent, _ws_caption, _ws_dir, _ws_filter, selectedFilter, options);
        (cast(t_v__qp)pFunQt[22])(_ws_caption);
        (cast(t_v__qp)pFunQt[22])(_ws_dir);
        (cast(t_v__qp)pFunQt[22])(_ws_filter);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// getExistingDirectory (static — create directory picker dialog)
    static string getExistingDirectory(void* parent = null, string caption = "", string dir = "", int options = 1 /*ShowDirsOnly*/) {
        auto _ws_caption = toQString(caption);
        auto _ws_dir = toQString(dir);
        void* _qs = (cast(t_qp__qp_qp_qp_qp_i)pFunQt[6845])(null, parent, _ws_caption, _ws_dir, options);
        (cast(t_v__qp)pFunQt[22])(_ws_caption);
        (cast(t_v__qp)pFunQt[22])(_ws_dir);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Connect signal fileSelected → ESlot
    QFileDialog connect_fileSelected(ESlot eslot) {
        connectQt(_wh, "fileSelected(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal currentChanged → ESlot
    QFileDialog connect_currentChanged(ESlot eslot) {
        connectQt(_wh, "currentChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal directoryEntered → ESlot
    QFileDialog connect_directoryEntered(ESlot eslot) {
        connectQt(_wh, "directoryEntered(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal filterSelected → ESlot
    QFileDialog connect_filterSelected(ESlot eslot) {
        connectQt(_wh, "filterSelected(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QFileDialog setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[6846])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFileDialog onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFileDialog onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QFileDialog onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFileDialog onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFileDialog onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QFileDialog onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QFileDialog onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QFileDialog onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QFileDialog onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QFileDialog onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QFileDialog onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QFileDialog onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QFileDialog onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QFileDialog onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFileDialog onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QFileDialog onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QFileDialog onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QFileDialog
