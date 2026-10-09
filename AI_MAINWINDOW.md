# QTE56 — AI_MAINWINDOW (QMainWindow, меню, тулбар, доки, MDI)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_mainwin.dll
> import: gen_qmainwindow, gen_qmenubar, gen_qmenu, gen_qaction,
>         gen_qtoolbar, gen_qstatusbar, gen_qdockwidget

---

## Полный каркас QMainWindow

```d
import qte56_core; import qte56_loader; import gen_qcore;
import gen_qwidget; import gen_qlayout; import gen_qlabel;
import gen_qmainwindow; import gen_qmenubar; import gen_qmenu;
import gen_qaction;    import gen_qtoolbar; import gen_qstatusbar;
import gen_qdockwidget; import gen_qsettings;
import gen_qmessagebox; import gen_qdialog; import gen_qfiledialog;
import core.memory : GC;

__gshared QMainWindow g_win;
__gshared QSettings   g_cfg;
__gshared ESlot[64]   g_slots; __gshared int g_si = 0;

// Хелпер подключения QAction
ESlot connectAction(QAction act, void* cb) {
    auto sl = new ESlot(act.getWH()); sl.set(cb);
    act.connect_triggered(sl); g_slots[g_si++] = sl; return sl;
}
// Хелпер создания QAction
QAction makeAction(string text, string shortcut, void* cb) {
    auto act = new QAction(cast(void*)null);
    act.setText(text);
    if (shortcut.length > 0) act.setShortcutStr(shortcut);
    connectAction(act, cb);
    return act;
}

// Коллбэки File
extern(C) void onFileNew  (void* dt, int n, int c) { /* TODO */ }
extern(C) void onFileOpen (void* dt, int n, int c) {
    string path = QFileDialog.getOpenFileName(g_win.getWH(), "Open", "", "All (*)");
    if (path.length == 0) return;
    // ... open file ...
}
extern(C) void onFileSave (void* dt, int n, int c) { /* TODO */ }
extern(C) void onFileExit (void* dt, int n, int c) { g_win.close(); }
// Коллбэки Edit
extern(C) void onEditUndo (void* dt, int n, int c) { /* TODO */ }
extern(C) void onEditFind (void* dt, int n, int c) { /* TODO */ }
// Коллбэки Help
extern(C) void onAbout    (void* dt, int n, int c) {
    QMessageBox.information(g_win.getWH(), "About", "My App v1.0");
}

// Обработка закрытия
extern(C) void onClose(void* dt, int* accept) {
    int r = QMessageBox.question(g_win.getWH(), "Exit", "Quit?",
        QMessageBox.Yes | QMessageBox.No, QMessageBox.No);
    *accept = (r == QMessageBox.Yes) ? 1 : 0;
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication();

    g_cfg = new QSettings("app.ini", 0);
    g_win = new QMainWindow(cast(void*)null);
    g_win.setWindowTitle("My Application");
    g_win.resize(1024, 768);

    // Восстановить геометрию
    { auto geo = g_cfg.getBytes("geo"); if (geo.length > 0) g_win.restoreGeometry(geo); }

    // ── Меню ─────────────────────────────────────────────────────────────────
    auto mbar  = QMenuBar.wrap(g_win.menuBar());

    // File
    auto mFile = new QMenu("&File", cast(void*)null);
    mbar.addMenu(mFile.getWH()); mFile.disown();
    auto actNew  = makeAction("&New",     "Ctrl+N", cast(void*)&onFileNew);
    auto actOpen = makeAction("&Open...", "Ctrl+O", cast(void*)&onFileOpen);
    auto actSave = makeAction("&Save",    "Ctrl+S", cast(void*)&onFileSave);
    mFile.addAction(actNew.getWH());  actNew.disown();
    mFile.addAction(actOpen.getWH()); actOpen.disown();
    mFile.addAction(actSave.getWH()); actSave.disown();
    mFile.addSeparator();
    auto actExit = makeAction("E&xit", "Alt+F4", cast(void*)&onFileExit);
    mFile.addAction(actExit.getWH()); actExit.disown();

    // Edit
    auto mEdit = new QMenu("&Edit", cast(void*)null);
    mbar.addMenu(mEdit.getWH()); mEdit.disown();
    auto actUndo = makeAction("&Undo", "Ctrl+Z", cast(void*)&onEditUndo);
    auto actFind = makeAction("&Find...", "Ctrl+F", cast(void*)&onEditFind);
    mEdit.addAction(actUndo.getWH()); actUndo.disown();
    mEdit.addSeparator();
    mEdit.addAction(actFind.getWH()); actFind.disown();

    // Help
    auto mHelp = new QMenu("&Help", cast(void*)null);
    mbar.addMenu(mHelp.getWH()); mHelp.disown();
    auto actAbout = makeAction("&About", "", cast(void*)&onAbout);
    mHelp.addAction(actAbout.getWH()); actAbout.disown();

    // ── Тулбар ───────────────────────────────────────────────────────────────
    // wrap — Qt создал тулбар, не new!
    auto tb = QToolBar.wrap(g_win.addToolBar("Main"));
    tb.addAction(actNew.getWH());
    tb.addAction(actOpen.getWH());
    tb.addAction(actSave.getWH());
    tb.addSeparator();
    tb.addAction(actFind.getWH());
    tb.setMovable(false);

    // ── Статусбар ─────────────────────────────────────────────────────────────
    QStatusBar.wrap(g_win.statusBar()).showMessage("Ready", 0);

    // ── Центральный виджет ───────────────────────────────────────────────────
    auto central = new QWidget(cast(void*)null);
    auto vbox    = new QVBoxLayout(cast(void*)null);
    auto lbl     = new QLabel(cast(void*)null);
    lbl.setText("Main content area");
    lbl.setAlignment(0x84); // AlignCenter
    vbox.addWidget(lbl);
    central.setLayout(vbox);
    g_win.setCentralWidget(central); // auto-disown

    // ── Обработчик закрытия ──────────────────────────────────────────────────
    g_win.onClose(cast(void*)&onClose);

    g_win.show();
    app.exec();

    // Сохранить геометрию
    g_cfg.setBytes("geo", g_win.saveGeometry());
    g_cfg.sync();

    GC.collect();
    app.deleteApp();
}
```

---

## QAction — все методы

```d
auto act = new QAction(cast(void*)null);
act.setText("&Open...");           // & = Alt-shortcut
act.setShortcutStr("Ctrl+O");      // НЕ setShortcut(string)!
act.setToolTip("Open file");
act.setStatusTip("Open a file");   // в статусбаре при hover
act.setWhatsThis("Click to open");
act.setEnabled(false);
act.setVisible(false);
act.setCheckable(true);
act.setChecked(true);
act.setSeparator(true);            // превратить в разделитель
act.setIcon(icon.getWH());         // установить иконку
act.trigger();                     // программный вызов
bool e = act.isEnabled();
bool c = act.isChecked();
// Сабменю:
auto sub = new QMenu(cast(void*)null);
// ... заполнить ...
act.setMenu(sub.getWH()); sub.disown();
```

---

## QMenu — дополнительно

```d
auto menu = new QMenu("&File", cast(void*)null);
// Добавить подменю:
auto submenu = new QMenu("Recent Files", cast(void*)null);
menu.addMenu(submenu.getWH()); submenu.disown();

menu.addSeparator();
menu.clear();                       // удалить все действия
menu.setTitle("New Title");
menu.setEnabled(false);             // деактивировать пункт меню
menu.isEmpty();

// Контекстное меню из виджета:
extern(C) void onContext(void* dt, int x, int y, int reason) {
    auto ctx = new QMenu(cast(void*)null);
    auto a1  = new QAction(cast(void*)null); a1.setText("Copy");
    ctx.addAction(a1.getWH()); a1.disown();
    ctx.exec();  // показать в позиции курсора (блокирующе)
}
w.onContextMenu(cast(void*)&onContext);
```

---

## QToolBar — подробно

```d
// QToolBar всегда создавать через win.addToolBar (возвращает void*, wrap нужен):
auto tb = QToolBar.wrap(g_win.addToolBar("File"));

// Добавить действия:
tb.addAction(act.getWH());
tb.addSeparator();
// Добавить произвольный виджет (кнопку, edit):
auto combo = new QComboBox(cast(void*)null); combo.addItem("Option");
tb.addWidget(combo.getWH()); combo.disown();  // void* API → disown вручную

tb.setMovable(true);          // можно перетаскивать
tb.setFloatable(true);        // может открепиться от окна
tb.setOrientation(1);         // 1=Horizontal, 2=Vertical
tb.setToolButtonStyle(2);     // 0=IconOnly 1=TextOnly 2=TextBesideIcon 3=TextUnderIcon
tb.setAllowedAreas(0xf);      // 1=Top 2=Left 4=Right 8=Bottom 0xf=All
tb.clear();
bool vis = tb.isVisible();
tb.hide(); tb.show();

// Вторая тулбарная строка:
g_win.addToolBarBreak(0x1);   // 1=TopArea — разрыв под первой строкой
auto tb2 = QToolBar.wrap(g_win.addToolBar("Edit"));
```

---

## QStatusBar

```d
// QStatusBar: wrap от win.statusBar()
auto sb = QStatusBar.wrap(g_win.statusBar());

// Временное сообщение (исчезает через N мс, 0=постоянно):
sb.showMessage("Loading...", 3000);
sb.showMessage("Ready", 0);
sb.clearMessage();

// Постоянные виджеты (справа):
auto lbl = new QLabel(cast(void*)null); lbl.setText("Line: 1");
sb.addPermanentWidget(lbl.getWH()); lbl.disown();

auto prog = new QProgressBar(cast(void*)null);
prog.setFixedWidth(120); prog.setRange(0, 100);
sb.addWidget(prog.getWH()); prog.disown();  // слева

sb.setSizeGripEnabled(false);  // убрать треугольник в углу
```

---

## QDockWidget (панели)

```d
// import: gen_qdockwidget
// Dock areas: 1=Left 2=Right 4=Top 8=Bottom

auto dock = new QDockWidget("Panel Title", cast(void*)null);
dock.setWidget(new QWidget(cast(void*)null)); // typed → auto-disown
dock.setAllowedAreas(3);    // 1=Left|2=Right
dock.setFeatures(
    1 |  // DockWidgetClosable
    2 |  // DockWidgetMovable
    4    // DockWidgetFloatable
);
dock.setFloating(false);    // встроенный (не плавающий)
g_win.addDockWidget(1, dock.getWH()); dock.disown(); // 1=LeftDockWidgetArea

// Два дока рядом (с разделителем):
g_win.addDockWidget(1, dock1.getWH()); dock1.disown();
g_win.addDockWidget(1, dock2.getWH()); dock2.disown();
// Сделать вкладками:
g_win.tabifyDockWidget(dock1.getWH(), dock2.getWH());

// Сигнал видимости:
dock.connect_visibilityChanged(sl);  // invoke_b
dock.connect_topLevelChanged(sl);    // invoke_b — при откреплении

// Сохранить/восстановить расположение доков:
cfg.setBytes("state", g_win.saveState());
ubyte[] state = cfg.getBytes("state");
if (state.length > 0) g_win.restoreState(state);
```

---

## MDI (Multiple Document Interface)

```d
// import: gen_qmdiarea, gen_qmdisubwindow
__gshared QMdiArea g_mdi;

g_mdi = new QMdiArea(cast(void*)null);
g_win.setCentralWidget(g_mdi); // auto-disown

// Создать субокно:
auto sub = new QMdiSubWindow(g_mdi.getWH()); // родитель = mdi!
auto content = new QWidget(cast(void*)null);
// ... заполнить content ...
sub.setWidget(content.getWH()); content.disown(); // void* API → disown вручную
sub.resize(400, 300);
sub.setWindowTitle("Document 1");

// Режим отображения:
g_mdi.setViewMode(0);    // 0=SubWindowView (плавающие), 1=TabbedView

// Управление:
g_mdi.cascadeSubWindows();
g_mdi.tileSubWindows();
void* activeWH = g_mdi.activeSubWindow();  // handle активного субокна
void*[] list   = g_mdi.subWindowList();    // все субокна

// Закрыть обработчик субокна:
extern(C) void onSubClose(void* dt, int* accept) { *accept = 1; }
sub.onClose(cast(void*)&onSubClose);

// ВАЖНО: при добавлении QScintilla в MdiSubWindow:
// НЕ использовать g_mdi.addSubWindow() → crash при закрытии!
// Использовать: new QMdiSubWindow(g_mdi.getWH()) + sub.setWidget(content)
```

---

## TDI (Tabbed Documents via QTabWidget)

```d
// import: gen_qtabwidget
auto tabs = new QTabWidget(cast(void*)null);
g_win.setCentralWidget(tabs); // auto-disown

tabs.setTabsClosable(true);   // крестик на вкладке
tabs.setMovable(true);        // перетаскивание вкладок
tabs.setDocumentMode(true);   // стиль macOS/Chrome

// Добавить документ:
auto page = new QWidget(cast(void*)null);
// ... заполнить page ...
int idx = tabs.addTab(page, "Document 1"); // typed → auto-disown

// Управление:
tabs.setCurrentIndex(0);
tabs.setTabText(0, "New name");
tabs.setTabEnabled(0, false);
tabs.setTabToolTip(0, "Hint");
int cur = tabs.currentIndex();
int cnt = tabs.count();
tabs.removeTab(0);           // удалить вкладку

// Закрытие по крестику:
extern(C) void onTabClose(void* dt, int n, int idx) {
    tabs.removeTab(idx);
}
g_sl = new ESlot(tabs.getWH()); g_sl.set(cast(void*)&onTabClose);
tabs.connect_tabCloseRequested(g_sl);

// Смена вкладки:
extern(C) void onTabChanged(void* dt, int n, int idx) { }
g_sl = new ESlot(tabs.getWH()); g_sl.set(cast(void*)&onTabChanged);
tabs.connect_currentChanged(g_sl);
```

---

## QMainWindow — дополнительные методы

```d
// Сохранение/восстановление геометрии и расположения тулбаров/доков:
g_cfg.setBytes("geo",   g_win.saveGeometry());
g_cfg.setBytes("state", g_win.saveState());
auto geo   = g_cfg.getBytes("geo");   if (geo.length > 0)   g_win.restoreGeometry(geo);
auto state = g_cfg.getBytes("state"); if (state.length > 0) g_win.restoreState(state);

// Вид:
g_win.setAnimated(false);          // без анимации при движении доков
g_win.setDockNestingEnabled(true); // можно вкладывать доки в строки/столбцы
g_win.setUnifiedTitleAndToolBarOnMac(true); // macOS только

// Угол между двумя dok-area:
g_win.setCorner(0, 1);  // TopLeftCorner=0, LeftDockWidgetArea=1

// Добавить тулбар в другую область:
auto tbBottom = QToolBar.wrap(g_win.addToolBar("Bottom"));
g_win.addToolBar(8, tbBottom.getWH()); // 8=BottomToolBarArea
```
