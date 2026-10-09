# QTE56 — AI_TRAY_EXTRA (SystemTray, Completer, Shortcut, Clipboard, Desktop)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> Каждый компонент — отдельная DLL.

---

## QSystemTrayIcon — системный трей

```d
// import: gen_qsystemtrayicon
// DLL: qte56_systray.dll
// ВАЖНО: конструктор БЕЗ аргументов! НЕ new QSystemTrayIcon(cast(void*)null)
// ВАЖНО: connect_activated — прямой C-callback, НЕ ESlot!
// ВАЖНО: app.setQuitOnLastWindowClosed(false) — нет в QTE56
//        Используй: держи хотя бы одно невидимое окно alive

__gshared QSystemTrayIcon g_tray;
__gshared QMenu           g_menu;
__gshared QApplication    g_app;  // глобал для quit() из callback

// Callback activated: extern(C) void cb(int reason) — без dt и n!
// reason: 1=Context 2=DoubleClick 3=Trigger 4=MiddleClick
extern(C) void onTrayActivated(int reason) {
    if (reason == 2) {  // двойной клик
        if (g_win.isVisible()) g_win.hide();
        else g_win.show();
    }
}

extern(C) void onTrayShow(void* dt, int n, int c) {
    if (g_win.isVisible()) g_win.hide();
    else { g_win.show(); g_win.activateWindow(); }
}

extern(C) void onTrayExit(void* dt, int n, int c) {
    g_tray.hide();
    g_app.quit();   // глобал g_app нужен для quit из callback
}

// Callback messageClicked: extern(C) void cb() — без параметров!
extern(C) void onBalloonClick() {
    g_win.show();
}

void initTray() {
    // Меню трея:
    g_menu = new QMenu(cast(void*)null);

    __gshared ESlot[8] g_slots; __gshared int g_si = 0;
    ESlot mkSlot(void* wh, void* cb) {
        auto sl = new ESlot(wh); sl.set(cb);
        g_slots[g_si++] = sl; return sl;
    }

    auto actShow = new QAction(cast(void*)null); actShow.setText("Show/Hide");
    mkSlot(actShow.getWH(), cast(void*)&onTrayShow); actShow.connect_triggered(g_slots[g_si-1]);
    g_menu.addAction(actShow.getWH()); actShow.disown();

    g_menu.addSeparator();

    auto actExit = new QAction(cast(void*)null); actExit.setText("Exit");
    mkSlot(actExit.getWH(), cast(void*)&onTrayExit); actExit.connect_triggered(g_slots[g_si-1]);
    g_menu.addAction(actExit.getWH()); actExit.disown();

    // Иконка трея:
    g_tray = new QSystemTrayIcon();           // БЕЗ аргументов!
    g_tray.setContextMenu(g_menu.getWH());
    g_tray.setToolTip("My Application");
    // g_tray.setIcon(QIcon.fromTheme("app-icon")); // если есть иконка

    // Подключить activated (прямой callback, не ESlot):
    g_tray.connect_activated(cast(void*)&onTrayActivated);

    // Подключить messageClicked:
    g_tray.connect_messageClicked(cast(void*)&onBalloonClick);

    g_tray.show();

    // Balloon уведомление:
    // showMessage(title, message, icon=1, msec=5000)
    // icon: 0=NoIcon 1=Information 2=Warning 3=Critical
    g_tray.showMessage("My App", "Application started", 1, 3000);
}

// Геометрия иконки трея (позиция на экране):
int x, y, w, h;
g_tray.geometry(x, y, w, h);
```

---

## QCompleter — автодополнение для QLineEdit / QComboBox

```d
// import: gen_qcompleter
// DLL: qte56_completer.dll
// КРИТИЧНО: после attachTo() Qt берёт ownership — НЕ вызывать destroy()!

auto comp = new QCompleter();  // БЕЗ аргументов

// Задать список слов:
comp.setModel(["Apple", "Banana", "Cherry", "Date", "Elderberry"]);

// Режим дополнения:
// CompletionMode: 0=Popup 1=UnfilteredPopup 2=Inline
comp.setCompletionMode(0);             // Popup — выпадающий список

// Регистр:
comp.setCaseSensitivity(0);            // 0=CaseInsensitive 1=CaseSensitive 2=FixedString

// Видимых элементов в popup:
comp.setMaxVisibleItems(8);

// Привязать к QLineEdit (Qt берёт ownership!):
comp.attachTo(edit.getWH());           // НЕ вызывать destroy(comp) после!

// Привязать к QComboBox:
comp.attachToCombo(combo.getWH());

// Сигнал activated (пользователь выбрал элемент):
comp.connect_activated((string s) {   // void delegate(string)
    edit.setText(s);
});

// Читать состояние (после установки prefix):
comp.setPrefix("app");                 // установить текущий prefix
int cnt = comp.completionCount();      // сколько совпадений
string cur = comp.currentCompletion(); // первое совпадение

// Обновить список:
comp.setModel(["новый", "список", "слов"]);

// ПАТТЕРН: completer для поиска по файловой системе
// comp.setModel перечислит файлы — нет встроенного QFileSystemModel
// Для файлового автодополнения: заполнить список через std.file.dirEntries
import std.file : dirEntries, SpanMode;
import std.path : baseName;
string[] files;
foreach (e; dirEntries(".", "*.d", SpanMode.shallow))
    files ~= baseName(e.name);
comp.setModel(files);
comp.attachTo(edit.getWH());
```

---

## QShortcut — горячие клавиши

```d
// import: gen_qshortcut
// DLL: qte56_shortcut.dll
// Qt-owned через parent → НЕ вызывать destroy()! Использовать free() для ранней очистки.

// Создать (привязан к виджету-родителю):
auto sc = new QShortcut(win.getWH(), "Ctrl+Q");
// Context: 0=Widget 1=WidgetWithChildren 2=Window 3=Application
sc.setContext(ShortcutContext.Window);   // работает когда окно активно

// Подключить (void delegate()):
sc.connect_activated(() {
    win.close();
});

// Или extern(C) через VoidClosure (сложнее, нужен паттерн):
// -- обычно проще использовать delegate

// Управление:
sc.setEnabled(false);
bool enabled = sc.isEnabled();
sc.setAutoRepeat(false);         // не повторять при удержании клавиши
sc.free();                       // досрочно освободить (иначе при destroy родителя)

// Примеры горячих клавиш:
auto scSave  = new QShortcut(win.getWH(), "Ctrl+S");
scSave.connect_activated(() { saveFile(); });

auto scFind  = new QShortcut(win.getWH(), "Ctrl+F");
scFind.connect_activated(() { showFindDialog(); });

auto scClose = new QShortcut(win.getWH(), "Ctrl+W");
scClose.setContext(ShortcutContext.Window);
scClose.connect_activated(() { win.close(); });

auto scF5    = new QShortcut(win.getWH(), "F5");
scF5.connect_activated(() { refreshData(); });

// Выключить все шорткаты временно:
sc.setEnabled(false);
// ... потом вернуть:
sc.setEnabled(true);
```

---

## QClipboard — буфер обмена

```d
// import: gen_qclipboard (gen_qclipboard регистрируется автоматически)
// Синглтон — только через QClipboard.get()

// Получить доступ:
auto clip = QClipboard.get();

// Работа с текстом:
clip.setText("Hello World");
string txt = clip.text();
clip.clear();

// Режимы буфера:
// 0=Clipboard (стандартный Ctrl+C/V)
// 1=Selection (Linux — выделение мышью)
// 2=FindBuffer (macOS — поиск)
clip.setText("text", 0);
string sel = clip.text(1);          // X11 selection

// Сигнал изменения:
extern(C) void onClipChanged(void* dthis) { }
clip.connect_dataChanged(cast(void*)&onClipChanged, null);
// или connect_changed — с mode параметром

// Типичный паттерн — Copy в контекстном меню:
extern(C) void onCopy(void* dt, int n, int c) {
    auto clip2 = QClipboard.get();
    clip2.setText(g_textEdit.toPlainText());
    QStatusBar.wrap(g_win.statusBar()).showMessage("Copied", 2000);
}

// Вставить из буфера:
extern(C) void onPaste(void* dt, int n, int c) {
    auto clip3 = QClipboard.get();
    string text = clip3.text();
    if (text.length > 0)
        g_textEdit.setPlainText(text);
}
```

---

## QDesktopWidget — информация о мониторах

```d
// import: gen_qdesktopwidget
// DLL: qte56_desktop.dll
// Все методы статические — объект не создаётся!

// Количество мониторов:
int count   = QDesktopWidget.screenCount();
int primary = QDesktopWidget.primaryScreen();  // индекс основного

// Геометрия монитора (включая taskbar):
ScreenRect geom = QDesktopWidget.screenGeometry();          // основной
ScreenRect geom = QDesktopWidget.screenGeometry(1);         // второй

// Рабочая область (без taskbar):
ScreenRect avail = QDesktopWidget.availableGeometry();      // основной
ScreenRect avail = QDesktopWidget.availableGeometry(0);     // явно основной

// ScreenRect поля: x, y, w, h
int cx = avail.centerX();           // центр по X
int cy = avail.centerY();           // центр по Y
int rx = avail.centeredX(800);      // X для окна шириной 800
int ry = avail.centeredY(600);      // Y для окна высотой 600

// Найти монитор по позиции курсора:
// int screenAt = QDesktopWidget.screenNumberAt(x, y);  // курсор

// Центрировать окно на основном мониторе:
auto pos = QDesktopWidget.centeredPos(800, 600);  // [x, y]
win.move(pos[0], pos[1]);
win.resize(800, 600);

// Центрировать на конкретном мониторе:
auto pos2 = QDesktopWidget.centeredPos(1024, 768, 1);  // второй монитор
win.move(pos2[0], pos2[1]);

// Типичный паттерн — запустить по центру:
void centerWindow(QWidget w, int wd, int ht) {
    auto p = QDesktopWidget.centeredPos(wd, ht);
    w.resize(wd, ht);
    w.move(p[0], p[1]);
}
```

---

## QButtonGroup — группа кнопок (с ID)

```d
// import: gen_qbuttongroup
// Используется для управления группой QRadioButton или QCheckBox
// НЕ является виджетом — только логическая группа

auto grp = new QButtonGroup(cast(void*)null);
grp.setExclusive(true);   // только одна активна (для RadioButton)

// Добавить кнопки с ID:
grp.addButton(rb1.getWH(), 1);
grp.addButton(rb2.getWH(), 2);
grp.addButton(rb3.getWH(), 3);

// Убрать кнопку:
grp.removeButton(rb2.getWH());

// Читать состояние:
int    checkedId = grp.checkedId();       // ID активной кнопки (-1 если нет)

// Сигнал (прямой, без ESlot):
// buttonClicked: extern(C) void cb(void* dthis, int id)
extern(C) void onGrp(void* dthis, int id) {
    switch (id) {
        case 1: /* режим Fast */ break;
        case 2: /* режим Normal */ break;
        case 3: /* режим Slow */ break;
        default: break;
    }
}
grp.connect_buttonClicked(cast(void*)&onGrp, null);

// buttonToggled: extern(C) void cb(void* dthis, int id, int checked)
extern(C) void onGrpToggle(void* dthis, int id, int checked) {
    if (!checked) return;  // игнорировать снятие
}
grp.connect_buttonToggled(cast(void*)&onGrpToggle, null);
```

---

## Полный пример: трей-приложение

```d
import qte56_core; import qte56_loader; import gen_qcore;
import gen_qwidget; import gen_qlayout; import gen_qlabel;
import gen_qmenu; import gen_qaction;
import gen_qsystemtrayicon;
import core.memory : GC;

__gshared QApplication    g_app;
__gshared QWidget         g_win;
__gshared QSystemTrayIcon g_tray;
__gshared QMenu           g_trayMenu;
__gshared ESlot[4]        g_slots; __gshared int g_si = 0;

ESlot mkSl(void* wh, void* cb) {
    auto sl = new ESlot(wh); sl.set(cb);
    g_slots[g_si++] = sl; return sl;
}

extern(C) void onTrayActivated(int reason) {  // БЕЗ dt и n!
    if (reason == 2) {
        if (g_win.isVisible()) g_win.hide(); else g_win.show();
    }
}
extern(C) void onShow  (void* dt, int n, int c) { g_win.show(); g_win.activateWindow(); }
extern(C) void onExit  (void* dt, int n, int c) { g_tray.hide(); g_app.quit(); }

void main() {
    LoadQt("./dll");
    g_app = new QApplication();

    // Главное окно (скрытое при старте):
    g_win = new QWidget(cast(void*)null);
    g_win.setWindowTitle("My App"); g_win.resize(400, 300);

    // Меню трея:
    g_trayMenu = new QMenu(cast(void*)null);
    auto aShow = new QAction(cast(void*)null); aShow.setText("Show");
    mkSl(aShow.getWH(), cast(void*)&onShow); aShow.connect_triggered(g_slots[g_si-1]);
    g_trayMenu.addAction(aShow.getWH()); aShow.disown();
    g_trayMenu.addSeparator();
    auto aExit = new QAction(cast(void*)null); aExit.setText("Exit");
    mkSl(aExit.getWH(), cast(void*)&onExit); aExit.connect_triggered(g_slots[g_si-1]);
    g_trayMenu.addAction(aExit.getWH()); aExit.disown();

    g_tray = new QSystemTrayIcon();   // БЕЗ аргументов!
    g_tray.setContextMenu(g_trayMenu.getWH());
    g_tray.setToolTip("My App");
    g_tray.connect_activated(cast(void*)&onTrayActivated);  // прямой cb!
    g_tray.show();
    g_tray.showMessage("My App", "Running in background", 1, 2000);

    g_app.exec();  // не app.setQuitOnLastWindowClosed(false) — нет в QTE56
                   // просто не показывать g_win при старте
    GC.collect();
    g_app.deleteApp();
}
```

---

## Gotchas

```
1. QSystemTrayIcon(): БЕЗ аргументов! new QSystemTrayIcon(null) = ошибка компиляции.
2. connect_activated: прямой cb(int reason) — без dt и n!
3. connect_messageClicked: прямой cb() — без параметров!
4. app.setQuitOnLastWindowClosed(false) — нет в QTE56. Обходной путь: держи виджет.
5. QCompleter: после attachTo() Qt берёт ownership → НЕ вызывать destroy()!
6. QShortcut: Qt-owned через parent. Используй free() для ранней очистки.
7. QShortcut context: Window — работает при активном окне. Application — всегда.
8. QClipboard.get() — синглтон, всегда один объект. Не хранить в переменной долго.
9. QDesktopWidget — все методы static. Объект не создаётся.
10. QButtonGroup: addButton(wh, id) — void* handle, не typed widget.
```
