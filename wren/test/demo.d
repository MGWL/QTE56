/**
 * demo.d — Qt UI на D + логика на Wren.
 *
 * D строит окно: поле имени, выбор приветствия, количество, чекбокс,
 *   кнопки "Сгенерировать" / "Очистить" / "Инфо о виджетах",
 *   лейбл вывода, список-лог, лог консоли.
 *
 * Все обработчики делегируются в demo.wren через WrenVM.
 *
 * Сборка: wren\test\build_demo.bat
 */

import std.stdio  : writeln, writefln;
import std.conv   : to;
import std.string : fromStringz;

import qte56_core;
import qte56_loader;
import qte56_enums;
import gen_qcore;
import gen_qobject;
import gen_qfont;
import gen_qwidget;
import gen_qframe;
import gen_qlayout;
import gen_qlabel;
import gen_qpushbutton;
import gen_qlineedit;
import gen_qcheckbox;
import gen_qcombobox;
import gen_qspinbox;
import gen_qgroupbox;
import gen_qabstractbutton;
import gen_qabstractspinbox;
import gen_qabstractscrollarea;
import gen_qlistwidget;
import gen_qabstractitemview;
import gen_qabstractslider;
import gen_qplaintextedit;

import wren_vm;

// ─── Глобальное состояние ─────────────────────────────────────────────────────

__gshared QApplication g_app;
__gshared WrenVM       g_vm;
__gshared ESlot[]      g_slots;

// ─── Wren output → Qt лог ────────────────────────────────────────────────────

__gshared QListWidget g_consoleList;

extern(C) static void wrenWrite(const(char)* text, int len, void* ud) {
    string s = fromStringz(text).idup;
    import std.stdio : write;
    write(s);
    // убрать trailing \n для listWidget
    while (s.length > 0 && (s[$-1] == '\n' || s[$-1] == '\r'))
        s = s[0..$-1];
    if (s.length > 0 && g_consoleList)
        g_consoleList.addItem(s);
}
extern(C) static void wrenError(const(char)* msg, int len, void* ud) {
    string s = fromStringz(msg).idup;
    writeln("[wren] ", s);
    if (g_consoleList) g_consoleList.addItem("[ERR] " ~ s);
}

// ─── Вспомогательные функции ─────────────────────────────────────────────────

void connectBtn(QPushButton btn, void* cbPtr) {
    auto sl = new ESlot(btn.getWH());
    sl.set(cbPtr);
    btn.connect_clicked(sl);
    g_slots ~= sl;
}

QPushButton mkBtn(string label) {
    auto b = new QPushButton(cast(void*)null);
    b.setText(label);
    return b;
}

// ─── Колбэки кнопок (вызывают Wren) ──────────────────────────────────────────

extern(C) static void cbGenerate(void* dthis, bool checked) {
    int r = g_vm.call("main", "Handler", "onGenerate()");
    if (r != 0) writeln("[demo] Handler.onGenerate() failed: ", r);
}

extern(C) static void cbClear(void* dthis, bool checked) {
    g_vm.call("main", "Handler", "onClear()");
}

extern(C) static void cbInfo(void* dthis, bool checked) {
    g_vm.call("main", "Handler", "onInfo()");
}

// Тест аргументов D→Wren: multiply(7, 6) должен вернуть 42
extern(C) static void cbTestArgs(void* dthis, bool checked) {
    g_vm.argDouble(1, 7);
    g_vm.argDouble(2, 6);
    double r = g_vm.callNum("main", "Handler", "multiply(_,_)");
    writefln("[demo] Handler.multiply(7, 6) = %s  (expect 42)", r);
    if (g_consoleList)
        g_consoleList.addItem("multiply(7,6) = " ~ r.to!string ~ (r == 42 ? " ✓" : " ✗"));
}

// ─── Главное окно ─────────────────────────────────────────────────────────────

void main() {
    version(Windows) {
        LoadQt("./dll");
        LoadWren("./dll/wren_bridge.dll");
    } else {
        LoadQt("./lib");
        LoadWren("./lib/libwren_bridge.so");
    }

    g_app = new QApplication("wren_demo");

    // ── Создать виджеты ───────────────────────────────────────────────────────
    auto win = new QWidget(cast(void*)null);
    win.setWindowTitle("Wren + Qt — Вариант C Demo");
    win.resize(720, 500);

    // Левая колонка: ввод
    auto grpInput = new QGroupBox("Входные данные (D строит UI)", cast(void*)null);
    auto vbInput  = new QVBoxLayout();

    auto lblName = new QLabel(cast(void*)null);
    lblName.setText("Имя:");
    auto editName = new QLineEdit(cast(void*)null);
    editName.setPlaceholderText("Введите имя...");

    auto lblGreet = new QLabel(cast(void*)null);
    lblGreet.setText("Приветствие:");
    auto combo = new QComboBox(cast(void*)null);
    combo.addItem("Привет");
    combo.addItem("Hello");
    combo.addItem("Hola");
    combo.addItem("Bonjour");
    combo.addItem("Ciao");
    combo.addItem("こんにちは");

    auto lblCount = new QLabel(cast(void*)null);
    lblCount.setText("Повторений:");
    auto spin = new QSpinBox(cast(void*)null);
    spin.setMinimum(1);
    spin.setMaximum(10);
    spin.setValue(3);

    auto chk = new QCheckBox(cast(void*)null);
    chk.setText("Верхний регистр (заглушка)");

    vbInput.addWidget(lblName.getWH());
    vbInput.addWidget(editName.getWH());
    vbInput.addWidget(lblGreet.getWH());
    vbInput.addWidget(combo.getWH());
    vbInput.addWidget(lblCount.getWH());
    vbInput.addWidget(spin.getWH());
    vbInput.addWidget(chk.getWH());
    vbInput.addStretch(1);

    grpInput.setLayout(vbInput.getWH());
    vbInput.disown();

    // Правая колонка: кнопки + вывод
    auto grpAction = new QGroupBox("Кнопки (колбэки вызывают Wren)", cast(void*)null);
    auto vbAction  = new QVBoxLayout();

    auto btnGen  = mkBtn("Сгенерировать (Handler.onGenerate)");
    auto btnClear= mkBtn("Очистить (Handler.onClear)");
    auto btnInfo = mkBtn("Инфо о виджетах (Handler.onInfo)");
    auto btnArgs = mkBtn("Тест аргументов D→Wren: multiply(7,6)");

    connectBtn(btnGen,   cast(void*)&cbGenerate);
    connectBtn(btnClear, cast(void*)&cbClear);
    connectBtn(btnInfo,  cast(void*)&cbInfo);
    connectBtn(btnArgs,  cast(void*)&cbTestArgs);

    auto lblResult = new QLabel(cast(void*)null);
    lblResult.setText("<i>Результат появится здесь...</i>");
    lblResult.setAlignment(0x0001 | 0x0020); // Qt::AlignLeft | Qt::AlignTop

    vbAction.addWidget(btnGen.getWH());
    vbAction.addWidget(btnClear.getWH());
    vbAction.addWidget(btnInfo.getWH());
    vbAction.addWidget(btnArgs.getWH());
    vbAction.addWidget(lblResult.getWH());
    vbAction.addStretch(1);

    grpAction.setLayout(vbAction.getWH());
    vbAction.disown();

    // Нижняя панель: два лога
    auto grpLogs = new QGroupBox("Логи", cast(void*)null);
    auto hbLogs  = new QHBoxLayout();

    // Лог Wren (addItem из Wren-кода)
    auto grpWrenLog = new QGroupBox("Wren-лог (addItem из .wren)", cast(void*)null);
    auto vbWren     = new QVBoxLayout();
    auto wrenList   = new QListWidget(cast(void*)null);
    vbWren.addWidget(wrenList.getWH());
    grpWrenLog.setLayout(vbWren.getWH());
    vbWren.disown();

    // Лог консоли (System.print из Wren)
    auto grpConsole = new QGroupBox("Консоль (System.print из Wren)", cast(void*)null);
    auto vbConsole  = new QVBoxLayout();
    g_consoleList   = new QListWidget(cast(void*)null);
    vbConsole.addWidget(g_consoleList.getWH());
    grpConsole.setLayout(vbConsole.getWH());
    vbConsole.disown();

    hbLogs.addWidget(grpWrenLog.getWH());
    hbLogs.addWidget(grpConsole.getWH());
    grpLogs.setLayout(hbLogs.getWH());
    hbLogs.disown();

    // Корневой layout
    auto rootVBox = new QVBoxLayout();
    auto topHBox  = new QHBoxLayout();
    topHBox.addWidget(grpInput.getWH());
    topHBox.addWidget(grpAction.getWH());
    rootVBox.addLayout(topHBox.getWH());
    rootVBox.addWidget(grpLogs.getWH());
    topHBox.disown();
    win.setLayout(rootVBox.getWH());
    rootVBox.disown();

    // ── Создать Wren VM и зарегистрировать виджеты ───────────────────────────
    g_vm = new WrenVM(&wrenWrite, &wrenError);

    g_vm.setWidget("edit",  editName.getWH());
    g_vm.setWidget("combo", combo.getWH());
    g_vm.setWidget("spin",  spin.getWH());
    g_vm.setWidget("lbl",   lblResult.getWH());
    g_vm.setWidget("log",   wrenList.getWH());   // addItem → wrenList
    g_vm.setWidget("chk",   chk.getWH());

    // ── Загрузить Wren-скрипт ────────────────────────────────────────────────
    int rc = g_vm.loadFile("wren/test/demo.wren");
    if (rc != 0) {
        writeln("[demo] ERROR: demo.wren failed to load (rc=", rc, ")");
    } else {
        writeln("[demo] demo.wren loaded OK");
        writeln("[demo] Handler exists: ", g_vm.hasVariable("main", "Handler"));
    }

    win.show();

    g_app.exec();
    g_app.deleteApp();
    g_vm.free();
    // UnloadQt() не вызывать — ОС сама освободит DLL (AGENTS.md §4.5)
}
