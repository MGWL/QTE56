/**
 * gen_qaction.d — D wrapper for QAction.
 * Module: QAction  |  DLL: qte56_mainwin.dll
 * MANUALLY WRITTEN — QAction inherits QObject (not QWidget).
 *
 * Index block: 25100–25127
 *
 * Signals:
 *   triggered(bool checked)  → cb(void* dthis, int n, int val)
 *   toggled(bool checked)    → cb(void* dthis, int n, int val)
 *   changed()                → cb(void* dthis, int n)
 *   hovered()                → cb(void* dthis, int n)
 *
 * Shortcut key encoding (int bitmask):
 *   Qt::Key values:  Key_A=0x41 .. Key_Z=0x5A, Key_F1=0x01000030 ..
 *   Modifiers:       Shift=0x02000000, Ctrl=0x04000000, Alt=0x08000000
 *   Example: Ctrl+S = 0x04000000 | 0x53 = 0x04000053
 *   Example: Ctrl+Q = 0x04000000 | 0x51 = 0x04000051
 */
module gen_qaction;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qobject : QObject;
import gen_qfont   : QFont;

// void* func(void*, int, void*)  — for create_text(text, len, parent)
mixin(generateAlias("qp__qp_i_qp"));
// void function(void*, void*) — for setIcon / setFont / setMenu
mixin(generateAlias("v__qp_qp"));
// void* func(void*, void*, void*) — for create_icon(icon, text, parent)
mixin(generateAlias("qp__qp_qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

static this() { registerModule("QAction", "qte56_mainwin.dll", &loadQAction); }

void loadQAction() {
    // Lifecycle
    mixin(generateFunQt(3800, "qteQAction_create",       "QAction"));
    mixin(generateFunQt(3801, "qteQAction_delete",       "QAction"));
    mixin(generateFunQt(3802, "qteQAction_create_text",  "QAction"));
    // Text
    mixin(generateFunQt(3803, "qteQAction_text",         "QAction"));
    mixin(generateFunQt(3804, "qteQAction_setText",      "QAction"));
    // Enable / visibility
    mixin(generateFunQt(3805, "qteQAction_isEnabled",    "QAction"));
    mixin(generateFunQt(3806, "qteQAction_setEnabled",   "QAction"));
    mixin(generateFunQt(3807, "qteQAction_isVisible",    "QAction"));
    mixin(generateFunQt(3808, "qteQAction_setVisible",   "QAction"));
    // Check state
    mixin(generateFunQt(3809, "qteQAction_isChecked",    "QAction"));
    mixin(generateFunQt(3810, "qteQAction_setChecked",   "QAction"));
    mixin(generateFunQt(3811, "qteQAction_isCheckable",  "QAction"));
    mixin(generateFunQt(3812, "qteQAction_setCheckable", "QAction"));
    // Separator
    mixin(generateFunQt(3813, "qteQAction_isSeparator",  "QAction"));
    mixin(generateFunQt(3814, "qteQAction_setSeparator", "QAction"));
    // Actions
    mixin(generateFunQt(3815, "qteQAction_trigger",      "QAction"));
    mixin(generateFunQt(3816, "qteQAction_toggle",       "QAction"));
    mixin(generateFunQt(3817, "qteQAction_hover",        "QAction"));
    // Tooltip / StatusTip / WhatsThis
    mixin(generateFunQt(3818, "qteQAction_toolTip",      "QAction"));
    mixin(generateFunQt(3819, "qteQAction_setToolTip",   "QAction"));
    mixin(generateFunQt(3820, "qteQAction_statusTip",    "QAction"));
    mixin(generateFunQt(3821, "qteQAction_setStatusTip", "QAction"));
    mixin(generateFunQt(3822, "qteQAction_whatsThis",    "QAction"));
    mixin(generateFunQt(3823, "qteQAction_setWhatsThis", "QAction"));
    // Shortcut (int bitmask)
    mixin(generateFunQt(3824, "qteQAction_shortcut",     "QAction"));
    mixin(generateFunQt(3825, "qteQAction_setShortcut",  "QAction"));
    // Icon text / menu role
    mixin(generateFunQt(3826, "qteQAction_iconText",     "QAction"));
    mixin(generateFunQt(3827, "qteQAction_setIconText",  "QAction"));
    mixin(generateFunQt(3828, "qteQAction_menuRole",     "QAction"));
    mixin(generateFunQt(3829, "qteQAction_setMenuRole",  "QAction"));
    // Icon
    mixin(generateFunQt(3830, "qteQAction_setIcon",      "QAction"));
    mixin(generateFunQt(3831, "qteQAction_icon",         "QAction"));
    // Shortcut via portable text string (e.g. "Shift+F3")
    mixin(generateFunQt(3832, "qteQAction_setShortcutStr", "QAction"));
    // Constructor with icon
    mixin(generateFunQt(3833, "qteQAction_create_icon",    "QAction"));
    // Font
    mixin(generateFunQt(3834, "qteQAction_font",           "QAction"));
    mixin(generateFunQt(3835, "qteQAction_setFont",        "QAction"));
    // Icon visible in menu
    mixin(generateFunQt(3836, "qteQAction_iconVisibleInMenu",    "QAction"));
    mixin(generateFunQt(3837, "qteQAction_setIconVisibleInMenu", "QAction"));
    // Shortcut context
    mixin(generateFunQt(3838, "qteQAction_shortcutContext",    "QAction"));
    mixin(generateFunQt(3839, "qteQAction_setShortcutContext", "QAction"));
    // Sub-menu
    mixin(generateFunQt(3840, "qteQAction_menu",    "QAction"));
    mixin(generateFunQt(3841, "qteQAction_setMenu", "QAction"));
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QAction.
/// QAction : QObject — not a widget, has no visual events.
/// Used in menus, toolbars, keyboard shortcuts.
@live class QAction : QObject {
public:
    /// Create QAction with no text. parent is a QObject subclass (e.g. QMenu, QMenuBar).
    /// NOTE: pass cast(void*)null explicitly to avoid ambiguity with string constructor.
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[3800])(parent);
    }

    /// Create QAction with icon + text. icon: QIcon.getPtr(), parent: QObject subclass.
    this(void* icon, string text, void* parent = null) {
        super(true);
        auto _ws = toQString(text);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp_qp_qp)pFunQt[3833])(icon, _ws, parent);
        (cast(t_v__qp)pFunQt[22])(_ws);
    }

    /// Create QAction with display text. parent is a QObject subclass.
    this(string text, void* parent = null) {
        super(true);
        auto _ws = toQString(text);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp_qp)pFunQt[3802])(
            _ws, parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }

    /// Wrap an existing Qt-owned QAction* (e.g. returned by addAction / addMenu).
    /// The returned D object does NOT own the Qt object — Qt will delete it.
    static QAction wrap(void* wh) {
        auto a = new QAction(true);
        a._wh = wh;
        a._qt_owned = true;
        return a;
    }

    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[3801] !is null) {
            (cast(t_v__qp)pFunQt[3801])(_wh);
            _wh = null;
        }
    }

    // ── Text ─────────────────────────────────────────────────────────

    /// Display text (shown in menu and tooltip).
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[3803])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// Set display text.
    QAction setText(string p0) {
        auto _ws = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[3804])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── Enable / visibility ──────────────────────────────────────────

    bool isEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[3805])(_wh);
    }

    QAction setEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[3806])(_wh, p0 ? 1 : 0);
        return this;
    }

    bool isVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[3807])(_wh);
    }

    QAction setVisible(bool p0) {
        (cast(t_v__qp_i)pFunQt[3808])(_wh, p0 ? 1 : 0);
        return this;
    }

    // ── Check state ──────────────────────────────────────────────────

    bool isChecked() {
        return cast(bool)(cast(t_i__qp)pFunQt[3809])(_wh);
    }

    QAction setChecked(bool p0) {
        (cast(t_v__qp_i)pFunQt[3810])(_wh, p0 ? 1 : 0);
        return this;
    }

    bool isCheckable() {
        return cast(bool)(cast(t_i__qp)pFunQt[3811])(_wh);
    }

    QAction setCheckable(bool p0) {
        (cast(t_v__qp_i)pFunQt[3812])(_wh, p0 ? 1 : 0);
        return this;
    }

    // ── Separator ────────────────────────────────────────────────────

    bool isSeparator() {
        return cast(bool)(cast(t_i__qp)pFunQt[3813])(_wh);
    }

    QAction setSeparator(bool p0) {
        (cast(t_v__qp_i)pFunQt[3814])(_wh, p0 ? 1 : 0);
        return this;
    }

    // ── Actions ──────────────────────────────────────────────────────

    /// Programmatically trigger the action (emits triggered signal).
    QAction trigger() {
        (cast(t_v__qp)pFunQt[3815])(_wh);
        return this;
    }

    /// Toggle checked state (emits toggled signal).
    QAction toggle() {
        (cast(t_v__qp)pFunQt[3816])(_wh);
        return this;
    }

    /// Hover over the action (emits hovered signal).
    QAction hover() {
        (cast(t_v__qp)pFunQt[3817])(_wh);
        return this;
    }

    // ── Tooltip / StatusTip / WhatsThis ──────────────────────────────

    string toolTip() {
        void* _qs = (cast(t_qp__qp)pFunQt[3818])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    QAction setToolTip(string p0) {
        auto _ws = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[3819])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    string statusTip() {
        void* _qs = (cast(t_qp__qp)pFunQt[3820])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    QAction setStatusTip(string p0) {
        auto _ws = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[3821])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    string whatsThis() {
        void* _qs = (cast(t_qp__qp)pFunQt[3822])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    QAction setWhatsThis(string p0) {
        auto _ws = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[3823])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── Shortcut ─────────────────────────────────────────────────────
    // Key encoded as int bitmask: Qt::Modifier | Qt::Key
    //   Ctrl  = 0x04000000,  Shift = 0x02000000,  Alt = 0x08000000
    //   Key_A = 0x41 .. Key_Z = 0x5A
    //   Key_F1 = 0x01000030 .. Key_F12 = 0x0100003B
    //   Examples: Ctrl+S = 0x04000053, Ctrl+Q = 0x04000051

    /// Returns current shortcut as int bitmask (0 if none).
    int shortcut() {
        return cast(int)(cast(t_i__qp)pFunQt[3824])(_wh);
    }

    /// Set shortcut from int bitmask (Qt::Modifier | Qt::Key).
    QAction setShortcut(int key) {
        (cast(t_v__qp_i)pFunQt[3825])(_wh, key);
        return this;
    }

    /// Set shortcut via portable text string, e.g. "Ctrl+S", "Shift+F3".
    QAction setShortcutStr(string key) {
        import std.utf : toUTF16;
        wstring ws = key.toUTF16;
        alias Fn = extern(C) void function(void*, const(wchar)*, int);
        (cast(Fn)pFunQt[3832])(_wh, ws.ptr, cast(int)ws.length);
        return this;
    }

    // ── Font ─────────────────────────────────────────────────────────

    /// Возвращает шрифт действия. Владелец — вызывающий (delete через QFont).
    QFont font() {
        void* _qf = (cast(t_qp__qp)pFunQt[3834])(_wh);
        return QFont.wrap(_qf);
    }

    /// Задать шрифт действия (влияет на отображение в меню).
    QAction setFont(QFont f) {
        (cast(t_v__qp_qp)pFunQt[3835])(_wh, f.getWH());
        return this;
    }

    // ── Icon visible in menu ──────────────────────────────────────────

    /// Видна ли иконка в меню (по умолчанию — да).
    bool iconVisibleInMenu() {
        return cast(bool)(cast(t_i__qp)pFunQt[3836])(_wh);
    }

    /// Скрыть/показать иконку в меню (не влияет на тулбар).
    QAction setIconVisibleInMenu(bool v) {
        (cast(t_v__qp_i)pFunQt[3837])(_wh, v ? 1 : 0);
        return this;
    }

    // ── Shortcut context ──────────────────────────────────────────────
    // Qt::ShortcutContext: WidgetShortcut=0, WindowShortcut=1,
    //                      ApplicationShortcut=2, WidgetWithChildrenShortcut=3

    /// Область действия шортката (WindowShortcut по умолчанию).
    int shortcutContext() {
        return (cast(t_i__qp)pFunQt[3838])(_wh);
    }

    /// Задать область действия шортката.
    QAction setShortcutContext(int ctx) {
        (cast(t_v__qp_i)pFunQt[3839])(_wh, ctx);
        return this;
    }

    // ── Sub-menu ──────────────────────────────────────────────────────

    /// Вернуть указатель на подменю (null если нет).
    void* menu() {
        return (cast(t_qp__qp)pFunQt[3840])(_wh);
    }

    /// Привязать QMenu как подменю этого действия.
    QAction setMenu(void* menuWH) {
        (cast(t_v__qp_qp)pFunQt[3841])(_wh, menuWH);
        return this;
    }

    // ── Icon text ────────────────────────────────────────────────────

    string iconText() {
        void* _qs = (cast(t_qp__qp)pFunQt[3826])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    QAction setIconText(string p0) {
        auto _ws = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[3827])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── Menu role ────────────────────────────────────────────────────
    // QAction::MenuRole: NoRole=0, TextHeuristicRole=1, ApplicationSpecificRole=2,
    //   AboutQtRole=3, AboutRole=4, PreferencesRole=5, QuitRole=6

    int menuRole() {
        return cast(int)(cast(t_i__qp)pFunQt[3828])(_wh);
    }

    QAction setMenuRole(int p0) {
        (cast(t_v__qp_i)pFunQt[3829])(_wh, p0);
        return this;
    }

    // ── Icon ──────────────────────────────────────────────────────────

    /// Set action's icon. Pass QIcon.getPtr() as void*.
    QAction setIcon(void* icon) {
        (cast(t_v__qp_qp)pFunQt[3830])(_wh, icon);
        return this;
    }

    /// Get action's icon. Returns a new heap-allocated QIcon* (caller takes ownership).
    void* icon() {
        return (cast(t_qp__qp)pFunQt[3831])(_wh);
    }

    // ── Signals ──────────────────────────────────────────────────────

    /// triggered(bool checked) — emitted when action is activated.
    /// cb: extern(C) void function(void* dthis, int n, int checked)
    QAction connect_triggered(ESlot eslot) {
        connectQt(_wh, "triggered(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// toggled(bool checked) — emitted when checkable action changes state.
    /// cb: extern(C) void function(void* dthis, int n, int checked)
    QAction connect_toggled(ESlot eslot) {
        connectQt(_wh, "toggled(bool)", eslot, "invoke_b(bool)");
        return this;
    }

    /// changed() — emitted when any property of the action changes.
    /// cb: extern(C) void function(void* dthis, int n)
    QAction connect_changed(ESlot eslot) {
        connectQt(_wh, "changed()", eslot, "invoke_v()");
        return this;
    }

    /// hovered() — emitted when action is highlighted in a menu.
    /// cb: extern(C) void function(void* dthis, int n)
    QAction connect_hovered(ESlot eslot) {
        connectQt(_wh, "hovered()", eslot, "invoke_v()");
        return this;
    }

} // class QAction
