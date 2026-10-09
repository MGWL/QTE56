/**
 * wren_console.d — Wren Inspector panel (Qt dialog)
 *
 * Layout:
 *   [Scenario: ▼  Load]
 *   ┌── Monitor ─[Clear]──┬── Console ─[Clear]──┐
 *   │  D-code log         │  REPL output         │
 *   └─────────────────────┴──────────────────────┘
 *   [multi-line input (QPlainTextEdit)   ] [Run]
 *
 * Input shortcuts:
 *   Ctrl+Enter  — Run
 *   Ctrl+Up     — Previous history entry
 *   Ctrl+Down   — Next history entry / back to current draft
 */
module wren_console;

import std.string : toStringz, fromStringz, strip;
import std.file   : dirEntries, SpanMode, exists;
import std.path   : baseName;

import wren_vm;
import qte56_loader : dumpModuleInfo, dumpPFunQtStats;

import gen_qcore;
import gen_qwidget;
import gen_qdialog;
import gen_qplaintextedit;
import gen_qlabel;
import gen_qpushbutton;
import gen_qcombobox;
import gen_qlayout;
import gen_qsplitter;
import gen_qfont;

// ── Qt key / modifier constants ───────────────────────────────────────────────

private enum int QKey_Return = 16777220;   // Qt::Key_Return
private enum int QKey_Enter  = 16777221;   // Qt::Key_Enter (numpad)
private enum int QKey_Up     = 16777235;   // Qt::Key_Up
private enum int QKey_Down   = 16777237;   // Qt::Key_Down
private enum int QMod_Ctrl   = 0x04000000; // Qt::ControlModifier

// ─────────────────────────────────────────────────────────────────────────────

class WrenConsole {
private:
    QDialog         _dlg;
    QPlainTextEdit  _monitor;       // left  — Monitor
    QPlainTextEdit  _console;       // right — Console
    QPlainTextEdit  _input;         // multi-line REPL input
    QPushButton     _btnRun;
    QPushButton     _btnClearMon;
    QPushButton     _btnClearCon;
    QComboBox       _scenarios;
    QPushButton     _btnLoad;
    QPushButton     _btnHelp;
    QPushButton     _btnSaveLog;
    QPushButton     _btnSystem;
    QSplitter       _splitter;

    ESlot _slRun, _slClearMon, _slClearCon, _slLoad, _slHelp, _slSaveLog, _slSystem;

    WrenVM  _vm;
    string  _scenarioDir;
    int     _runCount;

    // ── History ───────────────────────────────────────────────────────────────
    string[] _history;     // saved entries (oldest first)
    int      _histPos = -1;  // -1 = not browsing; 0..n-1 = browsing
    string   _draft;       // input text saved when browsing starts

    // Build one panel container: [Label  Clear] / [QPlainTextEdit]
    static QWidget makePanelBox(QPlainTextEdit edit, string title,
                                QPushButton btnClear) {
        auto box = new QWidget(cast(void*)null);
        auto lay = new QVBoxLayout();
        lay.setContentsMargins(0, 0, 0, 0);
        lay.setSpacing(2);

        auto hdr    = new QWidget(cast(void*)null);
        auto hdrRow = new QHBoxLayout();
        hdrRow.setContentsMargins(0, 0, 0, 0);
        auto lbl = new QLabel(title, cast(void*)null);
        hdrRow.addWidget(lbl.getWH(), 1);
        hdrRow.addWidget(btnClear.getWH());
        hdr.setLayout(hdrRow.getWH());
        hdrRow.disown();
        lbl.disown();
        hdr.disown();

        lay.addWidget(hdr.getWH());
        lay.addWidget(edit.getWH(), 1);
        box.setLayout(lay.getWH());
        lay.disown();
        edit.disown();
        btnClear.disown();
        return box;
    }

public:
    this(void* parent = null) {
        _dlg = new QDialog(parent);
        _dlg.setWindowTitle("Wren Inspector");
        _dlg.resize(1000, 620);

        // ── Text panels ───────────────────────────────────────────────────────
        _monitor = new QPlainTextEdit(cast(void*)null);
        _monitor.setReadOnly(true);
        _monitor.setPlaceholderText("Monitor — D-code log (Log.*)");

        _console = new QPlainTextEdit(cast(void*)null);
        _console.setReadOnly(true);
        _console.setPlaceholderText("Console — REPL output (Out.*)");

        auto fnt = new QFont("Courier New");
        fnt.setPointSize(9);
        _monitor.setFont(fnt);
        _console.setFont(fnt);
        fnt.disown();

        // ── Clear buttons ─────────────────────────────────────────────────────
        _btnClearMon = new QPushButton("Clear", cast(void*)null);
        _btnClearCon = new QPushButton("Clear", cast(void*)null);

        // ── Panel containers ──────────────────────────────────────────────────
        auto monBox = makePanelBox(_monitor, "Monitor", _btnClearMon);
        auto conBox = makePanelBox(_console, "Console", _btnClearCon);

        // ── Splitter ──────────────────────────────────────────────────────────
        _splitter = new QSplitter(cast(void*)null);
        _splitter.setOrientation(1 /*Qt::Horizontal*/);
        _splitter.addWidget(monBox.getWH());
        _splitter.addWidget(conBox.getWH());
        _splitter.setSizes([500, 500]);
        monBox.disown();
        conBox.disown();

        // ── Scenario bar ──────────────────────────────────────────────────────
        _scenarios = new QComboBox(cast(void*)null);
        _scenarios.addItem("(none)");
        _btnLoad    = new QPushButton("Load", cast(void*)null);
        _btnHelp    = new QPushButton("Help", cast(void*)null);
        _btnSaveLog = new QPushButton("Save log", cast(void*)null);
        _btnSystem  = new QPushButton("System info", cast(void*)null);
        auto lblScen = new QLabel("Scenario:", cast(void*)null);

        auto scenFrame = new QWidget(cast(void*)null);
        auto scenRow   = new QHBoxLayout();
        scenRow.addWidget(lblScen.getWH());
        scenRow.addWidget(_scenarios.getWH(), 1);
        scenRow.addWidget(_btnLoad.getWH());
        scenRow.addWidget(_btnHelp.getWH());
        scenRow.addWidget(_btnSaveLog.getWH());
        scenRow.addWidget(_btnSystem.getWH());
        scenFrame.setLayout(scenRow.getWH());
        scenRow.disown();
        lblScen.disown();

        // ── Input area (multi-line) ───────────────────────────────────────────
        _input = new QPlainTextEdit(cast(void*)null);
        _input.setPlaceholderText("Wren code... (Ctrl+Enter=Run, Ctrl+↑↓=History)");
        _input.setFont(fnt);
        _input.setFixedHeight(80);
        _btnRun = new QPushButton("Run", cast(void*)null);
        _btnRun.setFixedWidth(60);

        auto inputFrame = new QWidget(cast(void*)null);
        auto inputRow   = new QHBoxLayout();
        inputRow.setContentsMargins(0, 0, 0, 0);
        inputRow.addWidget(_input.getWH(), 1);
        inputRow.addWidget(_btnRun.getWH());
        inputFrame.setLayout(inputRow.getWH());
        inputRow.disown();

        // ── Main layout ───────────────────────────────────────────────────────
        auto mainLay = new QVBoxLayout();
        mainLay.addWidget(scenFrame.getWH());
        mainLay.addWidget(_splitter.getWH(), 1);
        mainLay.addWidget(inputFrame.getWH());
        _dlg.setLayout(mainLay.getWH());
        mainLay.disown();
        scenFrame.disown();
        inputFrame.disown();
        _splitter.disown();

        // ── Signal/event connections ──────────────────────────────────────────
        _slRun      = new ESlot(_btnRun.getWH());      _slRun.set(cast(void*)&_cbRun);
        _slClearMon = new ESlot(_btnClearMon.getWH()); _slClearMon.set(cast(void*)&_cbClearMon);
        _slClearCon = new ESlot(_btnClearCon.getWH()); _slClearCon.set(cast(void*)&_cbClearCon);
        _slLoad     = new ESlot(_btnLoad.getWH());      _slLoad.set(cast(void*)&_cbLoad);
        _slHelp     = new ESlot(_btnHelp.getWH());      _slHelp.set(cast(void*)&_cbHelp);
        _slSaveLog  = new ESlot(_btnSaveLog.getWH());   _slSaveLog.set(cast(void*)&_cbSaveLog);
        _slSystem   = new ESlot(_btnSystem.getWH());    _slSystem.set(cast(void*)&_cbSystem);
        _btnRun.connect_clicked(_slRun);
        _btnClearMon.connect_clicked(_slClearMon);
        _btnClearCon.connect_clicked(_slClearCon);
        _btnLoad.connect_clicked(_slLoad);
        _btnHelp.connect_clicked(_slHelp);
        _btnSaveLog.connect_clicked(_slSaveLog);
        _btnSystem.connect_clicked(_slSystem);
        _input.onKeyPress(cast(void*)&_cbKeyPress);
    }

    // ── Public API ────────────────────────────────────────────────────────────

    void attachVM(WrenVM vm) {
        _vm = vm;
        WrenVM.setMonitorWidget(_monitor.getWH());
        WrenVM.setConsoleWidget(_console.getWH());
    }

    void show() { _dlg.show(); }
    void hide() { _dlg.hide(); }
    void* dialogWH() { return _dlg.getWH(); }

    /// Добавить строку в панель Monitor (используется D-кодом для crash-логов).
    void appendMonitor(string text) {
        _monitor.appendPlainText(text);
    }

    /// Очистить панель Monitor.
    void clearMonitor() {
        _monitor.setPlainText("");
    }

    /// Сохранить содержимое Monitor в файл.
    bool saveMonitorToFile(string path) {
        import std.stdio : File;
        try {
            auto f = File(path, "w");
            f.write(_monitor.toPlainText());
            return true;
        } catch (Exception) {
            return false;
        }
    }

    void loadScenariosFrom(string dir) {
        _scenarioDir = dir;
        _scenarios.clear();
        _scenarios.addItem("(none)");
        if (!exists(dir)) return;
        foreach (e; dirEntries(dir, "*.wren", SpanMode.shallow))
            _scenarios.addItem(baseName(e.name));
    }

    // ── History navigation ────────────────────────────────────────────────────

    private void historyPrev() {
        if (_history.length == 0) return;
        if (_histPos == -1) {
            _draft   = strip(_input.toPlainText());
            _histPos = cast(int)_history.length - 1;
        } else if (_histPos > 0) {
            _histPos--;
        }
        _input.setPlainText(_history[_histPos]);
    }

    private void historyNext() {
        if (_histPos == -1) return;
        if (_histPos < cast(int)_history.length - 1) {
            _histPos++;
            _input.setPlainText(_history[_histPos]);
        } else {
            _histPos = -1;
            _input.setPlainText(_draft);
        }
    }

    private void historySave(string code) {
        if (code.length == 0) return;
        // Avoid consecutive duplicates
        if (_history.length > 0 && _history[$-1] == code) return;
        _history ~= code;
        _histPos  = -1;
    }

    // ── Code execution ────────────────────────────────────────────────────────

    private void runCode(string code) {
        if (_vm is null || code.length == 0) return;
        import std.conv : to;

        string mod = "console_" ~ to!string(++_runCount);

        enum PREAMBLE =
            "import \"log\" for Log\n" ~
            "import \"out\" for Out\n" ~
            "import \"check\" for Check\n" ~
            "import \"inspector\" for Inspector, QtObj\n";

        static immutable string[] stmtPfx = [
            "var ", "if ", "while ", "for ", "return ", "import ",
            "class ", "foreign ", "//", "{", "}"
        ];
        bool isStmt = false;
        foreach (kw; stmtPfx)
            if (code.length >= kw.length && code[0 .. kw.length] == kw) {
                isStmt = true; break;
            }

        bool multiLine = false;
        foreach (c; code) if (c == '\n') { multiLine = true; break; }

        string src;
        if (!isStmt && !multiLine && code.length < 200)
            src = PREAMBLE ~ "Out.val(\">> \", " ~ code ~ ")";
        else
            src = PREAMBLE ~ code;

        _vm.interpret(mod, src);
    }

    // ── Static callbacks ──────────────────────────────────────────────────────

    // Key press on _input: Ctrl+Enter=run, Ctrl+Up/Down=history
    // Returns 1 = consumed (don't pass to Qt), 0 = let Qt handle normally
    extern(C) static int _cbKeyPress(void* /*dthis*/, int key, int mods) {
        if (g_instance is null) return 0;
        bool ctrl = (mods & QMod_Ctrl) != 0;
        if (ctrl && (key == QKey_Return || key == QKey_Enter)) {
            _cbRun(null);
            return 1;  // consume — не вставлять перенос строки
        }
        if (ctrl && key == QKey_Up)   { g_instance.historyPrev(); return 1; }
        if (ctrl && key == QKey_Down) { g_instance.historyNext(); return 1; }
        return 0;  // все остальные клавиши — обрабатывает сам виджет
    }

    extern(C) static void _cbRun(void*) {
        if (g_instance is null) return;
        string code = strip(g_instance._input.toPlainText());
        if (code.length == 0) return;
        g_instance.historySave(code);
        g_instance.runCode(code);
        g_instance._input.setPlainText("");
    }

    extern(C) static void _cbClearMon(void*) {
        if (g_instance is null) return;
        g_instance._monitor.setPlainText("");
    }

    extern(C) static void _cbClearCon(void*) {
        if (g_instance is null) return;
        g_instance._console.setPlainText("");
    }

    extern(C) static void _cbLoad(void*) {
        if (g_instance is null) return;
        int idx = g_instance._scenarios.currentIndex();
        if (idx <= 0) return;
        string name = g_instance._scenarios.currentText();
        string path = g_instance._scenarioDir ~ "/" ~ name;
        if (!exists(path)) return;
        import std.conv : to;
        string mod = "scenario_" ~ to!string(++g_instance._runCount);
        g_instance._vm.loadFile(path, mod);
    }

    extern(C) static void _cbHelp(void*) {
        import std.process : executeShell;
        // Путь относительно рабочей директории приложения
        string path = "./wren/doc/inspector_help.html";
        version(Windows) executeShell("start \"\" \"" ~ path ~ "\"");
        else             executeShell("xdg-open \"" ~ path ~ "\"");
    }

    extern(C) static void _cbSaveLog(void*) {
        if (g_instance is null) return;
        import std.datetime : Clock;
        import std.format : format;
        import std.path : buildPath;
        import std.file : exists, mkdirRecurse;

        string dir = "./inspector_logs";
        if (!exists(dir)) mkdirRecurse(dir);
        auto now = Clock.currTime();
        string path = buildPath(dir, format("monitor_%04d-%02d-%02d_%02d-%02d-%02d.log",
            now.year, now.month, now.day, now.hour, now.minute, now.second));
        if (g_instance.saveMonitorToFile(path)) {
            g_instance.appendMonitor("[inspector] log saved to: " ~ path);
        } else {
            g_instance.appendMonitor("[inspector] ERROR: failed to save log to: " ~ path);
        }
    }

    extern(C) static void _cbSystem(void*) {
        if (g_instance is null) return;
        g_instance.appendMonitor("=== System info ===");
        g_instance.appendMonitor(dumpModuleInfo());
        g_instance.appendMonitor(dumpPFunQtStats());
        g_instance.appendMonitor("===================");
    }
}

__gshared WrenConsole g_instance;

WrenConsole createInspector(WrenVM vm, void* parent = null,
                             string scenarioDir = "") {
    g_instance = new WrenConsole(parent);
    g_instance.attachVM(vm);
    if (scenarioDir.length > 0)
        g_instance.loadScenariosFrom(scenarioDir);
    return g_instance;
}
