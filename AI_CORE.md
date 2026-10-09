# QTE56 — AI_CORE (D + Qt 5.13.2 via DLL)

> ↑ Навигация: [AGENTS.md](AGENTS.md)

> Загрузи этот файл в AI-чат. Пиши D + Qt без C++/qmake.
> Компиляция: `dmd -m32 -i myapp.d -Id -Id/gen -of=myapp.exe`
> Runtime:    `set PATH=dll;%PATH%` (Windows)

---

## КРИТИЧЕСКИЕ ПРАВИЛА

```d
// 1. ВСЕГДА cast(void*)null — иначе компилятор выберет this(string)
auto btn  = new QPushButton(cast(void*)null);  // ✓
auto btn  = new QPushButton(null);             // ✗ ОШИБКА КОМПИЛЯЦИИ

// 2. ПОРЯДОК инициализации — строго!
LoadQt("./dll");               // ← ПЕРВЫМ, до всего
auto app = new QApplication(); // ← ВТОРЫМ
// ... виджеты, show(), exec() ...
GC.collect();                  // ← перед deleteApp при использовании QThread
app.deleteApp();               // ← ПОСЛЕДНИМ (НЕ вызывать UnloadQt!)

// 3. СИГНАТУРЫ ESlot-коллбэков — int n обязателен вторым параметром:
extern(C) void onBtn  (void* dt, int n, int checked) { }  // invoke_b (clicked/toggled/triggered)
extern(C) void onInt  (void* dt, int n, int value)   { }  // invoke_i (valueChanged/stateChanged)
extern(C) void onStr  (void* dt, int n, void* qs)    { }  // invoke_s (textChanged со строкой)
extern(C) void onVoid (void* dt, int n)               { }  // invoke_v (returnPressed/timeout)
// ❌ void onInt(void* dt, int value) — value получит n, не реальное значение!

// 4. void main() — НЕ extern(C) int main()!
```

---

## Минимальный шаблон

```d
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qlayout;
import gen_qlabel;
import gen_qpushbutton;
import gen_qabstractbutton;  // обязателен с gen_qpushbutton
import core.memory : GC;

__gshared ESlot g_sl;

extern(C) void onBtn(void* dt, int n, int c) { /* ... */ }

void main() {
    LoadQt("./dll");
    auto app = new QApplication();

    auto w   = new QWidget(cast(void*)null);
    auto lbl = new QLabel(cast(void*)null);
    auto btn = new QPushButton(cast(void*)null);
    lbl.setText("Hello"); btn.setText("Click");

    g_sl = new ESlot(btn.getWH());
    g_sl.set(cast(void*)&onBtn);
    btn.connect_clicked(g_sl);

    auto vbox = new QVBoxLayout(cast(void*)null);
    vbox.addWidget(lbl);  // auto-disown
    vbox.addWidget(btn);  // auto-disown
    w.setLayout(vbox);    // auto-disown

    w.setWindowTitle("App"); w.resize(400, 300); w.show();
    app.exec();
    GC.collect();
    app.deleteApp();
}
```

---

## Таблица импортов

| Класс | import | DLL |
|-------|--------|-----|
| QWidget | `gen_qwidget` | qte56_widgets |
| QLabel | `gen_qlabel` | qte56_widgets |
| QPushButton | `gen_qpushbutton` **+** `gen_qabstractbutton` | qte56_widgets |
| QCheckBox | `gen_qcheckbox` **+** `gen_qabstractbutton` | qte56_widgets |
| QRadioButton | `gen_qradiobutton` **+** `gen_qabstractbutton` | qte56_widgets |
| QLineEdit | `gen_qlineedit` | qte56_widgets |
| QComboBox | `gen_qcombobox` | qte56_widgets |
| QSpinBox | `gen_qspinbox` **+** `gen_qabstractspinbox` | qte56_widgets |
| QDoubleSpinBox | `gen_qdoublespinbox` **+** `gen_qabstractspinbox` | qte56_widgets |
| QSlider | `gen_qslider` **+** `gen_qabstractslider` | qte56_widgets |
| QDial | `gen_qdial` **+** `gen_qabstractslider` | qte56_widgets |
| QProgressBar | `gen_qprogressbar` | qte56_widgets |
| QLCDNumber | `gen_qlcdnumber` | qte56_widgets |
| QGroupBox | `gen_qgroupbox` | qte56_widgets |
| QTabWidget | `gen_qtabwidget` | qte56_widgets |
| QSplitter | `gen_qsplitter` | qte56_widgets |
| QStackedWidget | `gen_qstackedwidget` | qte56_widgets |
| QScrollArea | `gen_qscrollarea` | qte56_widgets |
| QFrame | `gen_qframe` | qte56_widgets |
| QVBox/HBox/Grid/FormLayout | `gen_qlayout` | qte56_widgets |
| QMainWindow | `gen_qmainwindow` | qte56_mainwin |
| QMenuBar / QMenu / QAction | `gen_qmenubar` / `gen_qmenu` / `gen_qaction` | qte56_mainwin |
| QToolBar / QStatusBar | `gen_qtoolbar` / `gen_qstatusbar` | qte56_mainwin |
| QDockWidget | `gen_qdockwidget` | qte56_mainwin |
| QDialog | `gen_qdialog` | qte56_dialogs |
| QMessageBox | `gen_qmessagebox` **+** `gen_qdialog` | qte56_dialogs |
| QFileDialog | `gen_qfiledialog` **+** `gen_qdialog` | qte56_dialogs |
| QInputDialog | `gen_qinputdialog` **+** `gen_qdialog` | qte56_dialogs |
| QColorDialog | `gen_qcolordialog` **+** `gen_qdialog` | qte56_dialogs |
| QFontDialog | `gen_qfontdialog` **+** `gen_qdialog` | qte56_dialogs |
| QTextEdit | `gen_qtextedit` | qte56_text |
| QPlainTextEdit | `gen_qplaintextedit` | qte56_text |
| QTextBrowser | `gen_qtextbrowser` | qte56_text |
| QListWidget | `gen_qlistwidget` **+** `gen_qabstractitemview` | qte56_views |
| QTreeWidget | `gen_qtreewidget` **+** `gen_qtreeview` **+** `gen_qabstractitemview` | qte56_views |
| QTableWidget | `gen_qtablewidget` **+** `gen_qtableview` **+** `gen_qabstractitemview` | qte56_views |
| QHeaderView | `gen_qheaderview` | qte56_views |
| QTimer | `gen_qtimer` | qte56_foundation |
| QSettings | `gen_qsettings` | qte56_foundation |
| QFont | `gen_qfont` | qte56_foundation |
| QByteArray | `gen_qbytearray` | qte56_foundation |
| QDate/QTime/QDateTime | `gen_qdate` | qte56_foundation |
| QDateEdit/QTimeEdit/QDateTimeEdit | `gen_qdatetimeedit` | qte56_widgets |
| QCalendarWidget | `gen_qcalendarwidget` | qte56_widgets |
| QPainter / QPen / QBrush | `gen_qpainter` / `gen_qpen` / `gen_qbrush` | qte56_drawing |
| QColor / QPalette | `gen_qcolor` / `gen_qpalette` | qte56_drawing |
| QPixmap / QImage | `gen_qpixmap` / `gen_qimage` | qte56_drawing |
| QProcess | `gen_qprocess` | qte56_qprocess |
| QThread / QMutex | `gen_qthread` | qte56_thread |
| QNetworkAccessManager и др. | `gen_qnetwork` | qte56_network |
| QShortcut | `gen_qshortcut` | qte56_shortcut |
| QFileSystemWatcher | `gen_qfilesystemwatcher` | qte56_filewatcher |
| QCompleter | `gen_qcompleter` | qte56_completer |
| QSystemTrayIcon | `gen_qsystemtrayicon` | qte56_systray |
| QButtonGroup | `gen_qbuttongroup` | qte56_foundation |
| QMdiArea / QMdiSubWindow | `gen_qmdiarea` / `gen_qmdisubwindow` | qte56_views |
| QScintilla | `gen_qscintilla` | qte56_qscintilla |

---

## Владение объектами (Ownership)

```d
// typed методы → auto-disown (Qt берёт ownership автоматически):
vbox.addWidget(lbl);          // lbl.disown() вызван автоматически
vbox.addLayout(hbox);         // hbox.disown() — автоматически
w.setLayout(vbox);            // vbox.disown() — автоматически
win.setCentralWidget(central);// central.disown() — автоматически
tabs.addTab(page, "Title");   // page.disown() — автоматически
splitter.addWidget(panel);    // panel.disown() — автоматически

// void*-версии → disown() вручную:
vbox.addWidget(lbl.getWH());  // ← нужен lbl.disown() вручную!

// Qt-created objects → wrap(), не new, не удалять:
auto mbar = QMenuBar.wrap(win.menuBar());     // Qt owner
auto tb   = QToolBar.wrap(win.addToolBar("Main")); // Qt owner
auto sb   = QStatusBar.wrap(win.statusBar()); // Qt owner

// С родителем → Qt управляет временем жизни (disown не нужен):
auto child = new QWidget(parentWH);  // Qt owner через parent
```

---

## QObject — базовые возможности

Расширенный биндинг `QObject` даёт управление именем, сигналами, родством, потоками и событиями.

```d
auto obj = new QObject(cast(void*)null);

// Имя для отладки и поиска
obj.setObjectName("myObject");
writeln(obj.objectName());

// Временно отключить "шум" сигналов
obj.blockSignals(true);
// ... программные изменения без сигналов ...
obj.blockSignals(false);

// Перенести объект в фоновый поток
auto thread = new QThread({ /* работа */ });
obj.moveToThread(thread.getWH());
thread.start();

// Проверить тип по строке
if (obj.inherits("QWidget")) { /* это виджет */ }

// Безопасно удалить из слота
obj.deleteLater();
```

### Полный список новых методов

| Метод | Назначение |
|-------|------------|
| `objectName()` / `setObjectName()` | Имя объекта |
| `blockSignals()` / `signalsBlocked()` | Временно отключить сигналы |
| `parent()` / `setParent()` | Родительско-дочерние связи |
| `deleteLater()` | Безопасное отложенное удаление |
| `inherits(className)` | Проверка типа по имени |
| `thread()` / `moveToThread()` | Поточная принадлежность |
| `startTimer()` / `killTimer()` | Встроенные таймеры |
| `isWidgetType()` / `isWindowType()` | Проверки типа |
| `dumpObjectTree()` / `dumpObjectInfo()` | Отладка иерархии |
| `childrenCount()` / `childrenAt()` | Обход детей |
| `event()` / `eventFilter()` | Обработка и перехват событий |
| `connect_destroyed()` | Сигнал об уничтожении |

---

## ESlot — подключение сигналов

```d
// ESlot ОБЯЗАН быть в __gshared (GC не должен удалять его!)
__gshared ESlot g_sl;
__gshared QPushButton g_btn;

extern(C) void onClicked(void* dt, int n, int checked) { }

g_btn = new QPushButton(cast(void*)null);
g_sl  = new ESlot(g_btn.getWH());   // привязать к виджету-владельцу
g_sl.set(cast(void*)&onClicked);
g_btn.connect_clicked(g_sl);

// Несколько сигналов — отдельный ESlot для каждого:
__gshared ESlot[16] g_slots;
__gshared int g_si = 0;

ESlot makeSlot(void* wh, void* cb) {
    auto sl = new ESlot(wh);
    sl.set(cb);
    g_slots[g_si++] = sl;  // сохранить в __gshared массиве!
    return sl;
}
// Использование:
btn.connect_clicked(makeSlot(btn.getWH(), cast(void*)&onClicked));
```

---

## Строки D ↔ Qt

```d
// Типизированные методы берут D string напрямую:
lbl.setText("Hello");
edit.setText("value");

// fromQString — конвертирует и ОСВОБОЖДАЕТ qs (не использовать qs после!):
extern(C) void onText(void* dt, int n, void* qs) {
    string s = fromQString(qs);  // qs недействителен после этого вызова!
}

// toQString / freeQString — явная конвертация (редко нужна):
void* qs = toQString("Привет");
// ... передать в void*-API ...
// освободить: (cast(t_v__qp)pFunQt[22])(qs);

// string[] → QStringList (для addItems, setHeaderLabels и т.п.):
void* qsl = toQStringList(["A", "B", "C"]);
combo.addItems(qsl);
freeQStringList(qsl);  // обязательно!
```

---

## QMainWindow (каркас)

```d
// import: gen_qmainwindow, gen_qmenubar, gen_qmenu, gen_qaction,
//         gen_qtoolbar, gen_qstatusbar
__gshared QMainWindow g_win;
__gshared ESlot[32] g_slots; __gshared int g_si = 0;

ESlot connectAction(QAction act, void* cb) {
    auto sl = new ESlot(act.getWH()); sl.set(cb);
    act.connect_triggered(sl); g_slots[g_si++] = sl; return sl;
}

g_win = new QMainWindow(cast(void*)null);
auto mbar = QMenuBar.wrap(g_win.menuBar());

auto mFile = new QMenu("&File", cast(void*)null);
mbar.addMenu(mFile.getWH()); mFile.disown();  // void* API → disown вручную

auto actOpen = new QAction(cast(void*)null);
actOpen.setText("&Open..."); actOpen.setShortcutStr("Ctrl+O");
connectAction(actOpen, cast(void*)&onOpen);
mFile.addAction(actOpen.getWH()); actOpen.disown();

auto tb = QToolBar.wrap(g_win.addToolBar("Main"));
tb.addAction(actOpen.getWH());

QStatusBar.wrap(g_win.statusBar()).showMessage("Ready", 0);

auto central = new QWidget(cast(void*)null);
g_win.setCentralWidget(central);  // auto-disown
g_win.resize(900, 600); g_win.show();
```

---

## Диалоги

```d
// QMessageBox (import gen_qmessagebox + gen_qdialog):
QMessageBox.information(win.getWH(), "Title", "Message");
QMessageBox.warning(win.getWH(), "Warn", "Text");
QMessageBox.critical(win.getWH(), "Error", "Text");
int r = QMessageBox.question(win.getWH(), "Q", "Continue?",
    QMessageBox.Yes | QMessageBox.No, QMessageBox.No);
if (r == QMessageBox.Yes) { }

// QFileDialog (import gen_qfiledialog + gen_qdialog):
string path = QFileDialog.getOpenFileName(
    win.getWH(), "Open", "", "D Files (*.d);;All (*)");
string save = QFileDialog.getSaveFileName(win.getWH(), "Save", "", "*.txt");
string dir  = QFileDialog.getExistingDirectory(win.getWH(), "Dir", "");

// QInputDialog (import gen_qinputdialog + gen_qdialog):
bool ok;
string s = QInputDialog.getText(win.getWH(), "Input", "Name:", "", &ok);
int    n = QInputDialog.getInt(win.getWH(), "Input", "Value:", 0, 0, 100, 1, &ok);
```

---

## QTimer

```d
// import: gen_qtimer
__gshared QTimer g_timer;
__gshared ESlot  g_slTimer;

extern(C) void onTick(void* dt, int n) { /* каждые N мс */ }

g_timer  = new QTimer(cast(void*)null);
g_slTimer = new ESlot(g_timer.getWH());
g_slTimer.set(cast(void*)&onTick);
g_timer.connect_timeout(g_slTimer);
g_timer.start(1000);           // запустить (мс)
// g_timer.stop();
// g_timer.setSingleShot(true);
// QTimer.singleShot(500, cast(void*)&myFn);  // статический однократный
```

---

## QSettings

```d
// import: gen_qsettings
auto cfg = new QSettings("app.ini", 0);  // 0=IniFormat
cfg.setValue("w", 800); cfg.setValue("name", "World");
int    w = cfg.value_i("w",    800);  // int
string s = cfg.value_s("name", "");   // string
bool   b = cfg.value_b("vis",  true); // bool
double d = cfg.value_d("zoom", 1.0);  // double
// Двоичные (geometry):
cfg.setBytes("geo", win.saveGeometry());
ubyte[] geo = cfg.getBytes("geo");
if (geo.length > 0) win.restoreGeometry(geo);
cfg.sync();
```

---

## QThread

```d
// import: gen_qthread
// Конструктор принимает void delegate() — не C-функцию!
import core.atomic;
__gshared bool g_running = false;

auto t = new QThread({
    atomicStore(g_running, true);
    while (!t.isInterruptionRequested()) {
        QThread.msleep(100);
        // работа...
    }
    atomicStore(g_running, false);
});
t.connect_started({  // void delegate()
    // вызывается в главном потоке
});
t.connect_finished({ // void delegate()
    // вызывается в главном потоке
});
t.start();
// Остановить:
t.requestInterruption(); t.wait();
```

---

## События виджетов

```d
// Все on* — прямые коллбэки (не ESlot)
extern(C) void onClose   (void* dt, int* accept)              { *accept = 1; }
extern(C) void onKeyPress(void* dt, int key, int mods)        { }
extern(C) void onMousePress(void* dt, int x, int y, int btn)  { }
extern(C) void onMouseMove(void* dt, int x, int y)            { }
extern(C) void onWheel   (void* dt, int dx, int dy)           { }
extern(C) void onResize  (void* dt, int w, int h)             { }
extern(C) void onPaint   (void* dt, void* widget)             {
    auto p = new QPainter(widget, true);
    // ... рисовать ...
    p.end();
}

w.onClose(cast(void*)&onClose);
w.onKeyPress(cast(void*)&onKeyPress);
w.onMousePress(cast(void*)&onMousePress);
w.onMouseMove(cast(void*)&onMouseMove);
w.setMouseTracking(true);  // для onMouseMove без нажатой кнопки
w.onResize(cast(void*)&onResize);
w.onPaint(cast(void*)&onPaint);
```

---

## QSS — стили

```d
btn.setStyleSheet(
    "QPushButton { background:#3498db; color:white; border-radius:4px; padding:4px 12px; }" ~
    "QPushButton:hover   { background:#2980b9; }" ~
    "QPushButton:disabled{ background:#bdc3c7; color:#888; }");

app.setStyleSheet(
    "QWidget    { font-family:'Segoe UI'; font-size:10pt; }" ~
    "QLineEdit  { border:1px solid #bdc3c7; border-radius:3px; padding:2px 6px; }" ~
    "QLineEdit:focus { border:2px solid #3498db; }");
```

---

## GOTCHAS

```
1.  new Widget(cast(void*)null) — обязательно! null без каста = ошибка.
2.  LoadQt() до new QApplication() — всегда.
3.  ESlot в __gshared — иначе GC удалит → crash при сигнале.
4.  invoke_i/invoke_b: (void* dt, int n, int value) — НЕ (void* dt, int value)!
5.  fromQString(qs) удаляет qs — не использовать qs после.
6.  typed addWidget/setLayout → auto-disown. void*-API → disown() вручную.
7.  GC.collect() перед app.deleteApp() при использовании QThread.
8.  НЕ вызывать UnloadQt() — ОС сама освободит DLL.
9.  QAction.setShortcutStr("Ctrl+X") — НЕ setShortcut(string).
10. QMessageBox/QFileDialog/QInputDialog требуют gen_qdialog тоже.
11. QProcess.readStdoutText() — НЕ readAllStandardOutput().
12. QProcess.connect_finished — прямой cb(int exitCode, int exitStatus), не ESlot.
13. QProcess() без аргументов — НЕ new QProcess(cast(void*)null).
14. QSystemTrayIcon() без аргументов — НЕ new QSystemTrayIcon(cast(void*)null).
15. QThread: new QThread({ delegate }) — НЕ QThread.create(fn).
16. connect_started/connect_finished у QThread: принимают void delegate(), не ESlot.
17. QScintilla требует оба DLL: qte56_qscintilla.dll + qscintilla2_qt5.dll.
18. httpGet/httpPost из net_utils НЕЛЬЗЯ вызывать из ESlot — deadlock.
19. QTableWidget/QTreeWidget/QListWidget: нужны ВСЕ три import (widget + view + abstractitemview).
20. QFormLayout.addRow("label", widget) — типизированная версия работает,
    widget.disown() вызывается автоматически.
```

---

*QTE56 AI_CORE — апрель 2026 | Дополнительные файлы: AI_SIGNALS_REF.md, AI_NETWORK_GUIDE.md*

---

## Навигация

- ↑ [AGENTS.md](AGENTS.md) — точка входа
- ↓ Подробнее:
  - [LIVE_QUICKSTART.md](LIVE_QUICKSTART.md) — атрибут @live
  - [AI_SIGNALS_REF.md](AI_SIGNALS_REF.md) — справочник сигналов
  - [doc/qte56_d_reference.md](doc/qte56_d_reference.md) — полный справочник D API
  - [AI_WIDGETS.md](AI_WIDGETS.md) — стандартные виджеты
  - [AI_MAINWINDOW.md](AI_MAINWINDOW.md) — QMainWindow, меню, MDI
  - [AI_DIALOGS.md](AI_DIALOGS.md) — все диалоги
  - [AI_FORMS.md](AI_FORMS.md) — .ui-формы через QUiLoader
  - [AI_CONTAINERS.md](AI_CONTAINERS.md) — layouts и контейнеры
  - [AI_DATAVIEW.md](AI_DATAVIEW.md) — таблицы, деревья, списки
  - [AI_TEXTEDITOR.md](AI_TEXTEDITOR.md) — редакторы текста, QScintilla
  - [AI_DRAWING.md](AI_DRAWING.md) — QPainter, QPixmap, QImage
  - [AI_DATETIME.md](AI_DATETIME.md) — даты и время
  - [AI_SQL.md](AI_SQL.md) — QSqlDatabase, SQLite, ODBC
  - [AI_NETWORK_GUIDE.md](AI_NETWORK_GUIDE.md) — сеть (http, QNetwork)
  - [AI_TEXTCODEC.md](AI_TEXTCODEC.md) — кодировки cp1251/cp866
  - [AI_TRAY_EXTRA.md](AI_TRAY_EXTRA.md) — трей, completer, shortcut
