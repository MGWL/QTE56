/**
 * gen_qcombobox.d — GENERATED wrapper for QComboBox.
 * Module: QComboBox  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qcombobox;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qwidget : QWidget;

// New aliases for this module:
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("v__qp_i_qp_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQComboBox() {
    mixin(generateFunQt(1400, "qteQComboBox_create", "QComboBox"));
    mixin(generateFunQt(1401, "qteQComboBox_delete", "QComboBox"));
    mixin(generateFunQt(1405, "qteQComboBox_maxVisibleItems", "QComboBox"));
    mixin(generateFunQt(1406, "qteQComboBox_setMaxVisibleItems", "QComboBox"));
    mixin(generateFunQt(1407, "qteQComboBox_count", "QComboBox"));
    mixin(generateFunQt(1408, "qteQComboBox_setMaxCount", "QComboBox"));
    mixin(generateFunQt(1409, "qteQComboBox_maxCount", "QComboBox"));
    mixin(generateFunQt(1410, "qteQComboBox_autoCompletion", "QComboBox"));
    mixin(generateFunQt(1411, "qteQComboBox_setAutoCompletion", "QComboBox"));
    mixin(generateFunQt(1412, "qteQComboBox_autoCompletionCaseSensitivity", "QComboBox"));
    mixin(generateFunQt(1413, "qteQComboBox_setAutoCompletionCaseSensitivity", "QComboBox"));
    mixin(generateFunQt(1414, "qteQComboBox_duplicatesEnabled", "QComboBox"));
    mixin(generateFunQt(1415, "qteQComboBox_setDuplicatesEnabled", "QComboBox"));
    mixin(generateFunQt(1416, "qteQComboBox_setFrame", "QComboBox"));
    mixin(generateFunQt(1417, "qteQComboBox_hasFrame", "QComboBox"));
    mixin(generateFunQt(1418, "qteQComboBox_insertPolicy", "QComboBox"));
    mixin(generateFunQt(1419, "qteQComboBox_setInsertPolicy", "QComboBox"));
    mixin(generateFunQt(1420, "qteQComboBox_sizeAdjustPolicy", "QComboBox"));
    mixin(generateFunQt(1421, "qteQComboBox_setSizeAdjustPolicy", "QComboBox"));
    mixin(generateFunQt(1422, "qteQComboBox_minimumContentsLength", "QComboBox"));
    mixin(generateFunQt(1423, "qteQComboBox_setMinimumContentsLength", "QComboBox"));
    mixin(generateFunQt(1424, "qteQComboBox_iconSize", "QComboBox"));
    mixin(generateFunQt(1425, "qteQComboBox_setIconSize", "QComboBox"));
    mixin(generateFunQt(1426, "qteQComboBox_isEditable", "QComboBox"));
    mixin(generateFunQt(1427, "qteQComboBox_setEditable", "QComboBox"));
    mixin(generateFunQt(1428, "qteQComboBox_setLineEdit", "QComboBox"));
    // === НЕТ В DLL (2026-07) ===
    // Геттеры lineEdit/validator/completer/itemDelegate/model/view НЕ реализованы в C++
    // (в cpp/qt5 есть только сеттеры). Привязка дала бы null в pFunQt → crash при вызове.
    // Закомментировано намеренно: DLL не меняем, на ней написано много приложений.
    // mixin(generateFunQt(1455, "qteQComboBox_lineEdit", "QComboBox"));      // НЕТ В DLL
    mixin(generateFunQt(1429, "qteQComboBox_setValidator", "QComboBox"));
    // mixin(generateFunQt(1456, "qteQComboBox_validator", "QComboBox"));     // НЕТ В DLL
    mixin(generateFunQt(1430, "qteQComboBox_setCompleter", "QComboBox"));
    // mixin(generateFunQt(1457, "qteQComboBox_completer", "QComboBox"));     // НЕТ В DLL
    // mixin(generateFunQt(1458, "qteQComboBox_itemDelegate", "QComboBox"));  // НЕТ В DLL
    mixin(generateFunQt(1431, "qteQComboBox_setItemDelegate", "QComboBox"));
    // mixin(generateFunQt(1459, "qteQComboBox_model", "QComboBox"));         // НЕТ В DLL
    mixin(generateFunQt(1432, "qteQComboBox_setModel", "QComboBox"));
    mixin(generateFunQt(1433, "qteQComboBox_modelColumn", "QComboBox"));
    mixin(generateFunQt(1434, "qteQComboBox_setModelColumn", "QComboBox"));
    mixin(generateFunQt(1435, "qteQComboBox_currentIndex", "QComboBox"));
    mixin(generateFunQt(1436, "qteQComboBox_currentText", "QComboBox"));
    mixin(generateFunQt(1437, "qteQComboBox_itemText", "QComboBox"));
    mixin(generateFunQt(1453, "qteQComboBox_addItem", "QComboBox"));
    mixin(generateFunQt(1454, "qteQComboBox_insertItem", "QComboBox"));
    mixin(generateFunQt(1438, "qteQComboBox_insertSeparator", "QComboBox"));
    mixin(generateFunQt(1439, "qteQComboBox_removeItem", "QComboBox"));
    mixin(generateFunQt(1440, "qteQComboBox_setItemText", "QComboBox"));
    // mixin(generateFunQt(1460, "qteQComboBox_view", "QComboBox"));          // НЕТ В DLL (2026-07): см. комментарий выше про геттеры
    mixin(generateFunQt(1441, "qteQComboBox_setView", "QComboBox"));
    mixin(generateFunQt(1444, "qteQComboBox_showPopup", "QComboBox"));
    mixin(generateFunQt(1445, "qteQComboBox_hidePopup", "QComboBox"));
    mixin(generateFunQt(1446, "qteQComboBox_event", "QComboBox"));
    mixin(generateFunQt(1447, "qteQComboBox_clear", "QComboBox"));
    mixin(generateFunQt(1448, "qteQComboBox_clearEditText", "QComboBox"));
    mixin(generateFunQt(1449, "qteQComboBox_setEditText", "QComboBox"));
    mixin(generateFunQt(1450, "qteQComboBox_setCurrentIndex", "QComboBox"));
    mixin(generateFunQt(1451, "qteQComboBox_setCurrentText", "QComboBox"));
    mixin(generateFunQt(1452, "qteQComboBox_setEventHandler", "QComboBox"));
}

static this() {
    registerModule("QComboBox", "qte56_widgets.dll", &loadQComboBox);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QComboBox.
@live class QComboBox : QWidget {
public:
    /// Create QComboBox. parent=null → top-level widget.
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[1400])(parent);
    }

    /// No-op constructor for super() calls and wrap().
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QComboBox* (e.g. from QUiLoader or findChild).
    static QComboBox wrap(void* wh) {
        auto w = new QComboBox(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// maxVisibleItems
    int maxVisibleItems() {
        return cast(int)(cast(t_i__qp)pFunQt[1405])(_wh);
    }

    /// setMaxVisibleItems
    QComboBox setMaxVisibleItems(int maxItems) {
        (cast(t_v__qp_i)pFunQt[1406])(_wh, maxItems);
        return this;
    }

    /// count
    int count() {
        return cast(int)(cast(t_i__qp)pFunQt[1407])(_wh);
    }

    /// setMaxCount
    QComboBox setMaxCount(int max) {
        (cast(t_v__qp_i)pFunQt[1408])(_wh, max);
        return this;
    }

    /// maxCount
    int maxCount() {
        return cast(int)(cast(t_i__qp)pFunQt[1409])(_wh);
    }

    /// autoCompletion
    bool autoCompletion() {
        return cast(bool)(cast(t_i__qp)pFunQt[1410])(_wh);
    }

    /// setAutoCompletion
    QComboBox setAutoCompletion(bool enable) {
        (cast(t_v__qp_i)pFunQt[1411])(_wh, enable ? 1 : 0);
        return this;
    }

    /// autoCompletionCaseSensitivity
    int autoCompletionCaseSensitivity() {
        return cast(int)(cast(t_i__qp)pFunQt[1412])(_wh);
    }

    /// setAutoCompletionCaseSensitivity
    QComboBox setAutoCompletionCaseSensitivity(int sensitivity) {
        (cast(t_v__qp_i)pFunQt[1413])(_wh, sensitivity);
        return this;
    }

    /// duplicatesEnabled
    bool duplicatesEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[1414])(_wh);
    }

    /// setDuplicatesEnabled
    QComboBox setDuplicatesEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[1415])(_wh, enable ? 1 : 0);
        return this;
    }

    /// setFrame
    QComboBox setFrame(bool p0) {
        (cast(t_v__qp_i)pFunQt[1416])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// hasFrame
    bool hasFrame() {
        return cast(bool)(cast(t_i__qp)pFunQt[1417])(_wh);
    }

    /// insertPolicy
    int insertPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[1418])(_wh);
    }

    /// setInsertPolicy
    QComboBox setInsertPolicy(int policy) {
        (cast(t_v__qp_i)pFunQt[1419])(_wh, policy);
        return this;
    }

    /// sizeAdjustPolicy
    int sizeAdjustPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[1420])(_wh);
    }

    /// setSizeAdjustPolicy
    QComboBox setSizeAdjustPolicy(int policy) {
        (cast(t_v__qp_i)pFunQt[1421])(_wh, policy);
        return this;
    }

    /// minimumContentsLength
    int minimumContentsLength() {
        return cast(int)(cast(t_i__qp)pFunQt[1422])(_wh);
    }

    /// setMinimumContentsLength
    QComboBox setMinimumContentsLength(int characters) {
        (cast(t_v__qp_i)pFunQt[1423])(_wh, characters);
        return this;
    }

    /// iconSize
    DSize iconSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[1424])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setIconSize
    QComboBox setIconSize(void* size) {
        (cast(t_v__qp_qp)pFunQt[1425])(_wh, size);
        return this;
    }

    /// isEditable
    bool isEditable() {
        return cast(bool)(cast(t_i__qp)pFunQt[1426])(_wh);
    }

    /// setEditable
    QComboBox setEditable(bool editable) {
        (cast(t_v__qp_i)pFunQt[1427])(_wh, editable ? 1 : 0);
        return this;
    }

    /// setLineEdit
    QComboBox setLineEdit(void* edit) {
        (cast(t_v__qp_qp)pFunQt[1428])(_wh, edit);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQComboBox_lineEdit не реализован в C++ (есть только setLineEdit).
    // Привязка в loadQComboBox() закомментирована; метод отключён — pFunQt[1455] == null → crash.
    // /// lineEdit
    // void* lineEdit() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1455])(_wh);
    // }

    /// setValidator
    QComboBox setValidator(void* v) {
        (cast(t_v__qp_qp)pFunQt[1429])(_wh, v);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQComboBox_validator не реализован в C++ (есть только setValidator).
    // /// validator
    // void* validator() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1456])(_wh);
    // }

    /// setCompleter
    QComboBox setCompleter(void* c) {
        (cast(t_v__qp_qp)pFunQt[1430])(_wh, c);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQComboBox_completer не реализован в C++ (есть только setCompleter).
    // /// completer
    // void* completer() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1457])(_wh);
    // }

    // НЕТ В DLL (2026-07): qteQComboBox_itemDelegate не реализован в C++ (есть только setItemDelegate).
    // /// itemDelegate
    // void* itemDelegate() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1458])(_wh);
    // }

    /// setItemDelegate
    QComboBox setItemDelegate(void* delegate_) {
        (cast(t_v__qp_qp)pFunQt[1431])(_wh, delegate_);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQComboBox_model не реализован в C++ (есть только setModel).
    // /// model
    // void* model() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1459])(_wh);
    // }

    /// setModel
    QComboBox setModel(void* model) {
        (cast(t_v__qp_qp)pFunQt[1432])(_wh, model);
        return this;
    }

    /// modelColumn
    int modelColumn() {
        return cast(int)(cast(t_i__qp)pFunQt[1433])(_wh);
    }

    /// setModelColumn
    QComboBox setModelColumn(int visibleColumn) {
        (cast(t_v__qp_i)pFunQt[1434])(_wh, visibleColumn);
        return this;
    }

    /// currentIndex
    int currentIndex() {
        return cast(int)(cast(t_i__qp)pFunQt[1435])(_wh);
    }

    /// currentText
    string currentText() {
        void* _qs = (cast(t_qp__qp)pFunQt[1436])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// itemText
    string itemText(int index) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[1437])(_wh, index);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// addItem
    QComboBox addItem(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[1453])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// Добавить несколько элементов сразу.
    QComboBox addItems(string[] items) {
        foreach (s; items) addItem(s);
        return this;
    }

    /// insertItem
    QComboBox insertItem(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[1454])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// insertSeparator
    QComboBox insertSeparator(int index) {
        (cast(t_v__qp_i)pFunQt[1438])(_wh, index);
        return this;
    }

    /// removeItem
    QComboBox removeItem(int index) {
        (cast(t_v__qp_i)pFunQt[1439])(_wh, index);
        return this;
    }

    /// setItemText
    QComboBox setItemText(int index, string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_i_qp)pFunQt[1440])(_wh, index, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    // НЕТ В DLL (2026-07): qteQComboBox_view не реализован в C++ (есть только setView).
    // /// view
    // void* view() {
    //     return cast(void*)(cast(t_qp__qp)pFunQt[1460])(_wh);
    // }

    /// setView
    QComboBox setView(void* itemView) {
        (cast(t_v__qp_qp)pFunQt[1441])(_wh, itemView);
        return this;
    }

    /// showPopup
    QComboBox showPopup() {
        (cast(t_v__qp)pFunQt[1444])(_wh);
        return this;
    }

    /// hidePopup
    QComboBox hidePopup() {
        (cast(t_v__qp)pFunQt[1445])(_wh);
        return this;
    }

    /// event
    override bool event(void* event) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[1446])(_wh, event);
    }

    /// clear
    QComboBox clear() {
        (cast(t_v__qp)pFunQt[1447])(_wh);
        return this;
    }

    /// clearEditText
    QComboBox clearEditText() {
        (cast(t_v__qp)pFunQt[1448])(_wh);
        return this;
    }

    /// setEditText
    QComboBox setEditText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[1449])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// setCurrentIndex
    QComboBox setCurrentIndex(int index) {
        (cast(t_v__qp_i)pFunQt[1450])(_wh, index);
        return this;
    }

    /// setCurrentText
    QComboBox setCurrentText(string text) {
        auto _ws_text = toQString(text);
        (cast(t_v__qp_qp)pFunQt[1451])(_wh, _ws_text);
        (cast(t_v__qp)pFunQt[22])(_ws_text);
        return this;
    }

    /// Connect signal editTextChanged → ESlot
    QComboBox connect_editTextChanged(ESlot eslot) {
        connectQt(_wh, "editTextChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal activated → ESlot
    QComboBox connect_activated_i(ESlot eslot) {
        connectQt(_wh, "activated(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal activated → ESlot
    QComboBox connect_activated_s(ESlot eslot) {
        connectQt(_wh, "activated(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal highlighted → ESlot
    QComboBox connect_highlighted_i(ESlot eslot) {
        connectQt(_wh, "highlighted(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal highlighted → ESlot
    QComboBox connect_highlighted_s(ESlot eslot) {
        connectQt(_wh, "highlighted(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal currentIndexChanged → ESlot
    QComboBox connect_currentIndexChanged_i(ESlot eslot) {
        connectQt(_wh, "currentIndexChanged(int)", eslot, "invoke_i(int)");
        return this;
    }

    /// Connect signal currentIndexChanged → ESlot
    QComboBox connect_currentIndexChanged_s(ESlot eslot) {
        connectQt(_wh, "currentIndexChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal currentTextChanged → ESlot
    QComboBox connect_currentTextChanged(ESlot eslot) {
        connectQt(_wh, "currentTextChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QComboBox setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[1452])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QComboBox onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QComboBox onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QComboBox onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QComboBox onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QComboBox onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QComboBox onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QComboBox onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QComboBox onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QComboBox onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QComboBox onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QComboBox onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QComboBox onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QComboBox onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QComboBox onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QComboBox onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QComboBox onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QComboBox onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QComboBox
