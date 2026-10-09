/**
 * gen_tvision.d — D wrapper for Turbo Vision via qte56_tvision.dll
 * Module: Tvision | DLL: qte56_tvision.dll
 * MANUALLY WRITTEN
 *
 * Index block: 19850–19884 (35 functions)
 * Extension:   20155 (tvMessageBox)
 *
 * Turbo Vision is a standalone TUI framework (no Qt dependency).
 * Architecture: callback-based — D provides extern(C) function pointers
 * for menuBar/statusLine initialization and event handling.
 *
 * Usage:
 *   auto app = TvApp(&menuInit, &statusInit, &onEvent);
 *   app.run();
 *   app.destroy();
 */
module gen_tvision;

import qte56_core;
import qte56_loader : loadFn, registerModule;

// ====================================================================
// Type aliases
// ====================================================================

// Callback types
alias TvMenuBarInitFn    = extern(C) void* function(void* rect);
alias TvStatusLineInitFn = extern(C) void* function(void* rect);
alias TvEventHandlerFn   = extern(C) int   function(int what, int command);
alias TvIdleFn           = extern(C) void  function();

// Function pointer types for DLL calls
private {
    alias fn_vp_3vp     = extern(C) void* function(void*, void*, void*) @nogc;
    alias fn_v_vp       = extern(C) void  function(void*) @nogc;
    alias fn_vp_vp      = extern(C) void* function(void*) @nogc;
    alias fn_v_vp_vp    = extern(C) void  function(void*, void*) @nogc;
    alias fn_v_vp_cp_i  = extern(C) void  function(void*, const(char)*, int) @nogc;
    alias fn_v_vp_cp_i_i_cp = extern(C) void function(void*, const(char)*, int, int, const(char)*) @nogc;
    alias fn_vp_vp_cpp_ip_ip_i = extern(C) void* function(void*, const(char*)*, const(int)*, const(int)*, int) @nogc;
    alias fn_vp_4i_cp   = extern(C) void* function(int, int, int, int, const(char)*) @nogc;
    alias fn_i_vp_vp    = extern(C) int   function(void*, void*) @nogc;
    alias fn_vp_4i_cp_i_i = extern(C) void* function(int, int, int, int, const(char)*, int, int) @nogc;
    alias fn_vp_5i      = extern(C) void* function(int, int, int, int, int) @nogc;
    alias fn_v_vp_cp_i2 = extern(C) void  function(void*, char*, int) @nogc;
    alias fn_v_vp_cp    = extern(C) void  function(void*, const(char)*) @nogc;
    alias fn_i_vp       = extern(C) int   function(void*) @nogc;
    alias fn_v_vp_i     = extern(C) void  function(void*, int) @nogc;
    alias fn_vp_4i_cpp_i = extern(C) void* function(int, int, int, int, const(char*)*, int) @nogc;
    alias fn_vp_4i_cp_vp = extern(C) void* function(int, int, int, int, const(char)*, void*) @nogc;
    alias fn_vp_4i_cp_i = extern(C) void* function(int, int, int, int, const(char)*, int) @nogc;
    alias fn_i_noargs   = extern(C) int   function() @nogc;
    alias fn_i_cp_i     = extern(C) int   function(const(char)*, int) @nogc;
}

// ====================================================================
// Module registration & function loading
// ====================================================================

static this() {
    registerModule("Tvision", "qte56_tvision.dll", &loadTvision);
}

void loadTvision() {
    // App (19850–19853)
    mixin(generateFunQt(19850, "tvApp_create",   "Tvision"));
    mixin(generateFunQt(19851, "tvApp_run",      "Tvision"));
    mixin(generateFunQt(19852, "tvApp_delete",   "Tvision"));
    mixin(generateFunQt(19853, "tvApp_setIdle",  "Tvision"));

    // Menu builder (19854–19858)
    mixin(generateFunQt(19854, "tvMenu_beginBar",     "Tvision"));
    mixin(generateFunQt(19855, "tvMenu_addSubmenu",   "Tvision"));
    mixin(generateFunQt(19856, "tvMenu_addItem",      "Tvision"));
    mixin(generateFunQt(19857, "tvMenu_addSeparator", "Tvision"));
    mixin(generateFunQt(19858, "tvMenu_endBar",       "Tvision"));

    // StatusLine (19859)
    mixin(generateFunQt(19859, "tvStatusLine_create", "Tvision"));

    // Dialog (19860–19862)
    mixin(generateFunQt(19860, "tvDialog_create",  "Tvision"));
    mixin(generateFunQt(19861, "tvDialog_delete",  "Tvision"));
    mixin(generateFunQt(19862, "tvDialog_exec",    "Tvision"));

    // View insert (19863)
    mixin(generateFunQt(19863, "tvView_insert",    "Tvision"));

    // StaticText (19864)
    mixin(generateFunQt(19864, "tvStaticText_create", "Tvision"));

    // Button (19865)
    mixin(generateFunQt(19865, "tvButton_create",  "Tvision"));

    // InputLine (19866–19868)
    mixin(generateFunQt(19866, "tvInputLine_create",  "Tvision"));
    mixin(generateFunQt(19867, "tvInputLine_getText", "Tvision"));
    mixin(generateFunQt(19868, "tvInputLine_setText", "Tvision"));

    // CheckBox (19869–19871)
    mixin(generateFunQt(19869, "tvCheckBox_create",    "Tvision"));
    mixin(generateFunQt(19870, "tvCheckBox_getValue",  "Tvision"));
    mixin(generateFunQt(19871, "tvCheckBox_setValue",   "Tvision"));

    // RadioButtons (19872–19874)
    mixin(generateFunQt(19872, "tvRadioButtons_create",   "Tvision"));
    mixin(generateFunQt(19873, "tvRadioButtons_getValue", "Tvision"));
    mixin(generateFunQt(19874, "tvRadioButtons_setValue", "Tvision"));

    // Label (19875)
    mixin(generateFunQt(19875, "tvLabel_create",   "Tvision"));

    // Window + Desktop (19876–19877)
    mixin(generateFunQt(19876, "tvWindow_create",    "Tvision"));
    mixin(generateFunQt(19877, "tvDesktop_insert",   "Tvision"));

    // Constants (19878–19884)
    mixin(generateFunQt(19878, "tvConst_cmQuit",       "Tvision"));
    mixin(generateFunQt(19879, "tvConst_cmCancel",     "Tvision"));
    mixin(generateFunQt(19880, "tvConst_cmOK",         "Tvision"));
    mixin(generateFunQt(19881, "tvConst_bfDefault",    "Tvision"));
    mixin(generateFunQt(19882, "tvConst_bfNormal",     "Tvision"));
    mixin(generateFunQt(19883, "tvConst_evCommand",    "Tvision"));
    mixin(generateFunQt(19884, "tvConst_evBroadcast",  "Tvision"));

    // MessageBox extension (20155)
    mixin(generateFunQt(20155, "tvMessageBox", "Tvision"));

    // TermView — VT-100 terminal (20169–20175)
    mixin(generateFunQt(20169, "tvTerm_create",           "Tvision"));
    mixin(generateFunQt(20170, "tvTerm_write",            "Tvision"));
    mixin(generateFunQt(20171, "tvTerm_clear",            "Tvision"));
    mixin(generateFunQt(20172, "tvTerm_setKeyHandler",    "Tvision"));
    mixin(generateFunQt(20173, "tvTerm_setCursorVisible", "Tvision"));
    mixin(generateFunQt(20174, "tvTerm_size",             "Tvision"));
    mixin(generateFunQt(20175, "tvTerm_flush",            "Tvision"));
}

// ====================================================================
// Constants (via DLL getters)
// ====================================================================

int cmQuit()      { return (cast(fn_i_noargs)pFunQt[19878])(); }
int cmCancel()    { return (cast(fn_i_noargs)pFunQt[19879])(); }
int cmOK()        { return (cast(fn_i_noargs)pFunQt[19880])(); }
int bfDefault()   { return (cast(fn_i_noargs)pFunQt[19881])(); }
int bfNormal()    { return (cast(fn_i_noargs)pFunQt[19882])(); }
int evCommand()   { return (cast(fn_i_noargs)pFunQt[19883])(); }
int evBroadcast() { return (cast(fn_i_noargs)pFunQt[19884])(); }

// Compile-time constants: cmYes/cmNo (из tvision/include/tvision/views.h)
enum cmYes = 12;
enum cmNo  = 13;

// ====================================================================
// MessageBox constants (из tvision/include/tvision/msgbox.h)
// options = class | buttons
// ====================================================================

/// Классы диалога (тип заголовка и иконки)
enum mfWarning      = 0x0000;  /// Warning
enum mfError        = 0x0001;  /// Error
enum mfInformation  = 0x0002;  /// Information
enum mfConfirmation = 0x0003;  /// Confirmation

/// Флаги кнопок
enum mfYesButton    = 0x0100;
enum mfNoButton     = 0x0200;
enum mfOKButton     = 0x0400;
enum mfCancelButton = 0x0800;

/// Комбинации кнопок
enum mfYesNoCancel  = mfYesButton | mfNoButton | mfCancelButton;  /// Yes / No / Cancel
enum mfOKCancel     = mfOKButton  | mfCancelButton;               /// OK / Cancel

// ====================================================================
// MessageBox helper (index 20155)
// ====================================================================

/**
 * Показать встроенный TV-диалог с сообщением.
 *
 * Params:
 *   msg     = текст сообщения
 *   options = mfXxx класс | mfXxx кнопки (напр. mfConfirmation | mfYesNoCancel)
 *
 * Returns:
 *   cmOK(10), cmCancel(11), cmYes(12), cmNo(13) — в зависимости от кнопки
 *
 * Example:
 * ---
 * int r = tvMessageBox("Delete file?", mfConfirmation | mfYesNoCancel);
 * if (r == cmYes) { ... }
 * ---
 */
int tvMessageBox(string msg, int options) {
    import std.string : toStringz;
    return (cast(fn_i_cp_i)pFunQt[20155])(toStringz(msg), options);
}

// ====================================================================
// Keyboard constants (Turbo Vision scan codes)
// ====================================================================

enum : int {
    kbAltA = 0x1E00, kbAltB = 0x3000, kbAltC = 0x2E00, kbAltD = 0x2000,
    kbAltE = 0x1200, kbAltF = 0x2100, kbAltG = 0x2200, kbAltH = 0x2300,
    kbAltI = 0x1700, kbAltJ = 0x2400, kbAltK = 0x2500, kbAltL = 0x2600,
    kbAltM = 0x3200, kbAltN = 0x3100, kbAltO = 0x1800, kbAltP = 0x1900,
    kbAltQ = 0x1000, kbAltR = 0x1300, kbAltS = 0x1F00, kbAltT = 0x1400,
    kbAltU = 0x1600, kbAltV = 0x2F00, kbAltW = 0x1100, kbAltX = 0x2D00,
    kbAltY = 0x1500, kbAltZ = 0x2C00,
    kbF1  = 0x3B00, kbF2  = 0x3C00, kbF3  = 0x3D00, kbF4  = 0x3E00,
    kbF5  = 0x3F00, kbF6  = 0x4000, kbF7  = 0x4100, kbF8  = 0x4200,
    kbF9  = 0x4300, kbF10 = 0x4400,
}

// ====================================================================
// TvApp — application wrapper
// ====================================================================

struct TvApp {
    private void* _h;

    this(TvMenuBarInitFn menuInit,
         TvStatusLineInitFn statusInit,
         TvEventHandlerFn eventHandler)
    {
        _h = (cast(fn_vp_3vp)pFunQt[19850])(
            cast(void*)menuInit, cast(void*)statusInit, cast(void*)eventHandler);
    }

    void run()     { (cast(fn_v_vp)pFunQt[19851])(_h); }
    void destroy() { (cast(fn_v_vp)pFunQt[19852])(_h); _h = null; }

    void setIdle(TvIdleFn fn) {
        (cast(fn_v_vp_vp)pFunQt[19853])(_h, cast(void*)fn);
    }

    void* handle() { return _h; }

    /// Execute dialog (modal). Returns result command.
    int execDialog(void* dlg) {
        return (cast(fn_i_vp_vp)pFunQt[19862])(_h, dlg);
    }

    /// Insert window into desktop.
    void insertWindow(void* win) {
        (cast(fn_v_vp_vp)pFunQt[19877])(_h, win);
    }
}

// ====================================================================
// Menu builder
// ====================================================================

struct TvMenuBuilder {
    static void begin(void* rect) {
        (cast(fn_vp_vp)pFunQt[19854])(rect);
    }

    static void addSubmenu(string title, int hotkey = 0) {
        import std.string : toStringz;
        (cast(fn_v_vp_cp_i)pFunQt[19855])(null, toStringz(title), hotkey);
    }

    static void addItem(string title, int command, int hotkey = 0, string shortcut = "") {
        import std.string : toStringz;
        (cast(fn_v_vp_cp_i_i_cp)pFunQt[19856])(null, toStringz(title),
            command, hotkey,
            shortcut.length > 0 ? toStringz(shortcut) : null);
    }

    static void addSeparator() {
        (cast(fn_v_vp)pFunQt[19857])(null);
    }

    static void* end() {
        return (cast(fn_vp_vp)pFunQt[19858])(null);
    }
}

// ====================================================================
// StatusLine builder
// ====================================================================

void* tvBuildStatusLine(void* rect, string[] labels, int[] hotkeys, int[] commands) {
    import std.string : toStringz;
    auto count = cast(int)labels.length;
    auto clabels = new const(char)*[count];
    foreach (i; 0 .. count)
        clabels[i] = toStringz(labels[i]);
    return (cast(fn_vp_vp_cpp_ip_ip_i)pFunQt[19859])(
        rect, clabels.ptr, hotkeys.ptr, commands.ptr, count);
}

// ====================================================================
// Widget creation helpers
// ====================================================================

void tvInsert(void* group, void* view) {
    (cast(fn_v_vp_vp)pFunQt[19863])(group, view);
}

void* tvStaticText(int x1, int y1, int x2, int y2, string text) {
    import std.string : toStringz;
    return (cast(fn_vp_4i_cp)pFunQt[19864])(x1, y1, x2, y2, toStringz(text));
}

void* tvButton(int x1, int y1, int x2, int y2, string title, int command, int flags = 0) {
    import std.string : toStringz;
    if (flags == 0) flags = bfNormal();
    return (cast(fn_vp_4i_cp_i_i)pFunQt[19865])(x1, y1, x2, y2, toStringz(title), command, flags);
}

void* tvInputLine(int x1, int y1, int x2, int y2, int maxLen = 128) {
    return (cast(fn_vp_5i)pFunQt[19866])(x1, y1, x2, y2, maxLen);
}

string tvGetText(void* input) {
    char[512] buf;
    (cast(fn_v_vp_cp_i2)pFunQt[19867])(input, buf.ptr, 512);
    import std.string : fromStringz;
    return fromStringz(buf.ptr).idup;
}

void tvSetText(void* input, string text) {
    import std.string : toStringz;
    (cast(fn_v_vp_cp)pFunQt[19868])(input, toStringz(text));
}

void* tvDialog(int x1, int y1, int x2, int y2, string title) {
    import std.string : toStringz;
    return (cast(fn_vp_4i_cp)pFunQt[19860])(x1, y1, x2, y2, toStringz(title));
}

void tvDialogDelete(void* dlg) {
    (cast(fn_v_vp)pFunQt[19861])(dlg);
}

void* tvCheckBox(int x1, int y1, int x2, int y2, string label) {
    import std.string : toStringz;
    return (cast(fn_vp_4i_cp)pFunQt[19869])(x1, y1, x2, y2, toStringz(label));
}

int tvCheckBoxValue(void* cb) { return (cast(fn_i_vp)pFunQt[19870])(cb); }
void tvCheckBoxSet(void* cb, int val) { (cast(fn_v_vp_i)pFunQt[19871])(cb, val); }

void* tvRadioButtons(int x1, int y1, int x2, int y2, string[] labels) {
    import std.string : toStringz;
    auto count = cast(int)labels.length;
    auto clabels = new const(char)*[count];
    foreach (i; 0 .. count)
        clabels[i] = toStringz(labels[i]);
    return (cast(fn_vp_4i_cpp_i)pFunQt[19872])(x1, y1, x2, y2, clabels.ptr, count);
}

int tvRadioValue(void* rb) { return (cast(fn_i_vp)pFunQt[19873])(rb); }
void tvRadioSet(void* rb, int val) { (cast(fn_v_vp_i)pFunQt[19874])(rb, val); }

void* tvLabel(int x1, int y1, int x2, int y2, string text, void* link = null) {
    import std.string : toStringz;
    return (cast(fn_vp_4i_cp_vp)pFunQt[19875])(x1, y1, x2, y2, toStringz(text), link);
}

void* tvWindow(int x1, int y1, int x2, int y2, string title, int num = 0) {
    import std.string : toStringz;
    return (cast(fn_vp_4i_cp_i)pFunQt[19876])(x1, y1, x2, y2, toStringz(title), num);
}

// ====================================================================
// TermView — VT-100 terminal view (20169–20175)
// ====================================================================
//
// Потоковый терминал: байты UTF-8 → клеточный буфер (TDrawSurface)
// с минимальным VT-100/ANSI парсером в C++. Кириллица: D-сторона
// конвертирует cp1251 → UTF-8 перед tvTermWrite.
//
// Key handler: extern(C) void(void* userdata, int keyCode, int shiftState,
//   const(char)* text, int textLen) — сырые tvision-значения + UTF-8 текст клавиши.
//
// Потоки: tvTermWrite/tvTermClear можно звать из рабочего потока
// (внутри C++ critical section, только буфер + dirty-флаг). Перерисовку
// делает tvTermFlush из GUI-потока (например, из TvApp idle-callback).

/// Callback клавиатуры TermView: сырые keyCode/shiftState tvision + UTF-8 текст.
alias TvTermKeyFn = extern(C) void function(void* userdata, int keyCode,
    int shiftState, const(char)* text, int textLen);

private {
    alias fn_vp_4i        = extern(C) void* function(int, int, int, int) @nogc;
    alias fn_v_vp_vp_vp   = extern(C) void  function(void*, void*, void*) @nogc;
    alias fn_v_vp_ip_ip   = extern(C) void  function(void*, int*, int*) @nogc;
}

/// Создать TermView в координатах (col,row). Вставка: app.insertWindow(term)
/// — на весь desktop, или tvInsert(group, term) — внутрь окна/диалога.
void* tvTerm(int x1, int y1, int x2, int y2) {
    return (cast(fn_vp_4i)pFunQt[20169])(x1, y1, x2, y2);
}

/// Поток байт UTF-8 через VT-100 парсер. Потокобезопасно (C++ critsec).
void tvTermWrite(void* h, const(char)[] bytes) {
    if (bytes.length == 0) return;
    (cast(fn_v_vp_cp_i)pFunQt[20170])(h, bytes.ptr, cast(int)bytes.length);
}

/// Очистить экран, курсор в (0,0).
void tvTermClear(void* h) {
    (cast(fn_v_vp)pFunQt[20171])(h);
}

/// Установить обработчик клавиш (cb + userdata).
void tvTermSetKeyHandler(void* h, TvTermKeyFn cb, void* userdata) {
    (cast(fn_v_vp_vp_vp)pFunQt[20172])(h, cast(void*)cb, userdata);
}

/// Видимость курсора (0/1).
void tvTermSetCursorVisible(void* h, int vis) {
    (cast(fn_v_vp_i)pFunQt[20173])(h, vis);
}

/// Текущий размер терминала в символах.
void tvTermSize(void* h, out int w, out int hgt) {
    (cast(fn_v_vp_ip_ip)pFunQt[20174])(h, &w, &hgt);
}

/// Перерисовать, если были записи. ВЫЗЫВАТЬ ТОЛЬКО из GUI-потока.
void tvTermFlush(void* h) {
    (cast(fn_v_vp)pFunQt[20175])(h);
}
