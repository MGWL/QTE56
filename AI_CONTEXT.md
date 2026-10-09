# QTE56 — руководство по написанию D-приложений

> Этот файл — исчерпывающий контекст для ИИ. Вставь его в начало чата.
> Задача: писать D-программы с Qt 5.13.2 через готовые DLL/SO/DyLib проекта QTE56.
> НЕ нужны Qt, C++ компилятор, qmake. Нужны только: DLL из папки `dll/`, D компилятор.

---

## 1. Структура проекта (только нужное разработчику)

```
arch_new/
  d/                — qte56_core.d, qte56_loader.d, qte56_enums.d, net_utils.d, curl_utils.d, json.d ...
  d/gen/            — gen_qwidget.d, gen_qlabel.d, ... (80+ классов, по одному файлу)
  dll/              — qte56_*.dll + Qt5*.dll (Windows)
  lib/              — libqte56_*.so (Linux) / libqte56_*.dylib (macOS)
  snip/             — *.snip файлы примеров
```

Исходники приложения — **любое место**, главное указать `-Id -Id/gen` при компиляции.

---

## 2. Компиляция и запуск

```bat
rem Windows 32-bit (основной):
dmd -m32 -version=TreeQt -i myapp.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=myapp.exe

rem Переменные окружения перед запуском:
set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt5_13_2\5.13.2\mingw73_32\plugins\platforms
myapp.exe
```

```bash
# Linux:
dmd -m32 -i myapp.d -Id -Id/gen -of=myapp
LD_LIBRARY_PATH=./lib ./myapp

# macOS:
dmd -i myapp.d -Id -Id/gen -of=myapp
DYLD_LIBRARY_PATH=./lib ./myapp
```

Флаг `-i` автоматически включает все транзитивно импортированные модули — **отдельно перечислять `d/gen/*.d` не нужно**.

---

## 3. Обязательный шаблон любого приложения

```d
import qte56_core;        // pFunQt[], generateAlias
import qte56_loader;      // LoadQt()
import gen_qcore;         // QApplication, ESlot, toQString, fromQString

// + нужные виджеты:
import gen_qwidget;
import gen_qlabel;
import gen_qpushbutton;
import gen_qlayout;

void main() {                          // НЕ extern(C) int main!
    LoadQt("./dll");                   // ОБЯЗАТЕЛЬНО ДО new QApplication
    auto app = new QApplication(cast(void*)null);

    // ... создать виджеты, показать окно ...

    app.exec();
    app.deleteApp();                   // НЕ вызывать UnloadQt()!
}
```

---

## 4. Таблица импортов (класс → модуль)

| Класс | import | DLL |
|-------|--------|-----|
| QWidget | `gen_qwidget` | qte56_widgets |
| QLabel | `gen_qlabel` | qte56_widgets |
| QPushButton | `gen_qpushbutton` | qte56_widgets |
| QLineEdit | `gen_qlineedit` | qte56_widgets |
| QCheckBox | `gen_qcheckbox` | qte56_widgets |
| QRadioButton | `gen_qradiobutton` | qte56_widgets |
| QComboBox | `gen_qcombobox` | qte56_widgets |
| QSpinBox | `gen_qspinbox` | qte56_widgets |
| QDoubleSpinBox | `gen_qdoublespinbox` | qte56_widgets |
| QSlider | `gen_qslider` | qte56_widgets |
| QDial | `gen_qdial` | qte56_widgets |
| QScrollBar | `gen_qscrollbar` | qte56_widgets |
| QProgressBar | `gen_qprogressbar` | qte56_widgets |
| QGroupBox | `gen_qgroupbox` | qte56_widgets |
| QTabWidget | `gen_qtabwidget` | qte56_widgets |
| QFrame | `gen_qframe` | qte56_widgets |
| QSplitter | `gen_qsplitter` | qte56_widgets |
| QStackedWidget | `gen_qstackedwidget` | qte56_widgets |
| QScrollArea | `gen_qscrollarea` | qte56_widgets |
| QLCDNumber | `gen_qlcdnumber` | qte56_widgets |
| QToolButton | `gen_qtoolbutton` | qte56_widgets |
| QVBoxLayout, QHBoxLayout, QGridLayout, QFormLayout | `gen_qlayout` | qte56_widgets |
| QMainWindow | `gen_qmainwindow` | qte56_mainwin |
| QMenuBar | `gen_qmenubar` | qte56_mainwin |
| QMenu | `gen_qmenu` | qte56_mainwin |
| QAction | `gen_qaction` | qte56_mainwin |
| QToolBar | `gen_qtoolbar` | qte56_mainwin |
| QStatusBar | `gen_qstatusbar` | qte56_mainwin |
| QDockWidget | `gen_qdockwidget` | qte56_mainwin |
| QDialog | `gen_qdialog` | qte56_dialogs |
| QMessageBox | `gen_qmessagebox` | qte56_dialogs |
| QFileDialog | `gen_qfiledialog` | qte56_dialogs |
| QInputDialog | `gen_qinputdialog` | qte56_dialogs |
| QFontDialog | `gen_qfontdialog` | qte56_dialogs |
| QColorDialog | `gen_qcolordialog` | qte56_dialogs |
| QProgressDialog | `gen_qprogressdialog` | qte56_dialogs |
| QTextEdit | `gen_qtextedit` | qte56_text |
| QTextBrowser | `gen_qtextbrowser` | qte56_text |
| QPlainTextEdit | `gen_qplaintextedit` | qte56_text |
| QTreeWidget | `gen_qtreewidget` + `gen_qtreeview` + `gen_qabstractitemview` | qte56_views |
| QTableWidget | `gen_qtablewidget` + `gen_qtableview` + `gen_qabstractitemview` | qte56_views |
| QListWidget | `gen_qlistwidget` + `gen_qabstractitemview` | qte56_views |
| QHeaderView | `gen_qheaderview` | qte56_views |
| QMdiArea | `gen_qmdiarea` | qte56_views |
| QMdiSubWindow | `gen_qmdisubwindow` | qte56_views |
| QTimer | `gen_qtimer` | qte56_foundation |
| QSettings | `gen_qsettings` | qte56_foundation |
| QFont | `gen_qfont` | qte56_foundation |
| QByteArray | `gen_qbytearray` | qte56_foundation |
| QDate/QTime/QDateTime | `gen_qdate` | qte56_foundation |
| QDateTimeEdit / QDateEdit / QTimeEdit | `gen_qdatetimeedit` | qte56_widgets |
| QCalendarWidget | `gen_qcalendarwidget` | qte56_widgets |
| QPainter | `gen_qpainter` | qte56_drawing |
| QPen / QBrush / QPalette | `gen_qpen` / `gen_qbrush` / `gen_qpalette` | qte56_drawing |
| QColor | `gen_qcolor` | qte56_drawing |
| QPixmap | `gen_qpixmap` | qte56_drawing |
| QImage | `gen_qimage` | qte56_drawing |
| QFontMetrics | `gen_qfontmetrics` | qte56_drawing |
| QProcess | `gen_qprocess` | qte56_qprocess |
| QThread / QMutex / QWaitCondition / QSemaphore / QReadWriteLock | `gen_qthread` | qte56_thread |
| QNetworkAccessManager | `gen_qnetwork` | qte56_network |
| QSystemTrayIcon | `gen_qsystemtrayicon` | qte56_systray |
| QCompleter | `gen_qcompleter` | qte56_completer |
| QShortcut | `gen_qshortcut` | qte56_shortcut |
| QFileSystemWatcher | `gen_qfilesystemwatcher` | qte56_filewatcher |
| QDesktopWidget | `gen_qdesktopwidget` | qte56_desktop |
| QButtonGroup | `gen_qbuttongroup` | qte56_foundation |
| QClipboard | `gen_qclipboard` | qte56_widgets |
| QScintilla | `gen_qscintilla` | qte56_qscintilla |
| QTabBar | `gen_qtabbar` | qte56_widgets |
| QGraphicsScene / QGraphicsView / QGraphicsPixmapItem | `gen_qgraphicsscene` | qte56_qgraphicsscene |

---

## 4a. QObject — базовые возможности

Базовый класс `QObject` предоставляет управление жизненным циклом, сигналами, родством, потоками и событиями.

```d
auto obj = new QObject(cast(void*)null);
obj.setObjectName("loader");
writeln(obj.objectName());   // "loader"

obj.blockSignals(true);      // временно отключить сигналы
obj.blockSignals(false);     // снова слушаем

// Проверка типа по имени класса
if (obj.inherits("QWidget")) { /* ... */ }

// Перенос в другой поток
auto thread = new QThread({ /* фоновая работа */ });
obj.moveToThread(thread.getWH());
thread.start();

// Безопасное удаление из слота
obj.deleteLater();
```

Ключевые методы:

- `objectName()` / `setObjectName()` — имя объекта
- `blockSignals()` / `signalsBlocked()` — блокировка сигналов
- `parent()` / `setParent()` — родитель
- `deleteLater()` — отложенное удаление
- `inherits(className)` — проверка типа
- `thread()` / `moveToThread()` — поточная принадлежность
- `startTimer()` / `killTimer()` — встроенные таймеры
- `isWidgetType()` / `isWindowType()` — проверки типа
- `dumpObjectTree()` / `dumpObjectInfo()` — отладка дерева
- `childrenCount()` / `childrenAt()` — обход детей
- `event()` / `eventFilter()` — обработка событий
- `connect_destroyed()` — сигнал уничтожения

---

## 5. Владение объектами (ownership)

**Правило 1 — typed addWidget/setLayout/setCentralWidget**: D-объект передаётся в Qt → `disown()` **вызывается автоматически**. Не вызывать вручную.

**Правило 2 — void*-версии (raw API)**: `disown()` вызывать вручную.

**Правило 3 — wrap()**: объект создан Qt (не нами) → D деструктор его **не удаляет**.

```d
auto lbl = new QLabel(cast(void*)null);
vbox.addWidget(lbl);         // ← typed: lbl.disown() автоматически. НЕ трогать lbl._ptr после этого.

auto mbar = QMenuBar.wrap(win.menuBar());  // ← Qt создал, D не удаляет
```

**Правило 4**: `new QWidget(parentWH)` — Qt берёт ownership через parent. `disown()` не нужен.

---

## 6. Строки D ↔ Qt

```d
import gen_qcore : toQString, fromQString;

// D string → Qt QString (new QString на C++ heap):
void* qs = toQString("Привет");
widget.setWindowTitle_qs(qs);   // если метод принимает void*
// QString удаляется автоматически внутри типизированных методов.

// Qt QString → D string:
string s = fromQString(widget.text());   // text() возвращает void* (new QString)
// fromQString сам удаляет переданный qs

// Все типизированные методы принимают D string напрямую:
lbl.setText("Hello");           // внутри вызывает toQString/fromQString сам
edit.setPlaceholderText("...");

// string[] → QStringList (через \x01):
import gen_qcore : toQStringList, freeQStringList;
void* qsl = toQStringList(["One", "Two", "Three"]);
combo.addItems(qsl);
freeQStringList(qsl);           // освободить после использования
```

---

## 7. Сигналы — ESlot паттерн

```d
import gen_qcore : ESlot;

// Колбэк — всегда extern(C), первый параметр void* (dthis, игнорируется)
extern(C) void onClicked(void* dt, int n, int checked) {
    import std.stdio : writeln;
    writeln("clicked");
}

__gshared ESlot g_sl;   // ОБЯЗАТЕЛЬНО __gshared, иначе GC удалит

auto btn = new QPushButton(cast(void*)null);
btn.setText("OK");
g_sl = new ESlot(btn.getWH());
g_sl.set(cast(void*)&onClicked);
btn.connect_clicked(g_sl);
```

**Важно**: `g_sl` должна жить пока жив сигнал. Хранить в `__gshared` переменной или в массиве.

---

## 8. Layouts

```d
// QVBoxLayout / QHBoxLayout
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(label);      // typed: auto-disown
vbox.addWidget(button);
vbox.addStretch(1);          // распорка
vbox.setSpacing(8);
vbox.setContentsMargins(10, 10, 10, 10);
container.setLayout(vbox);   // typed: auto-disown

// QHBoxLayout с вложением
auto hbox = new QHBoxLayout(cast(void*)null);
hbox.addStretch(1);
hbox.addWidget(btnOk);
hbox.addWidget(btnCancel);
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(edit);
vbox.addLayout(hbox);        // typed: auto-disown
dlg.setLayout(vbox);

// QGridLayout
auto grid = new QGridLayout(cast(void*)null);
grid.addWidget(lbl,  0, 0);            // row, col
grid.addWidget(edit, 0, 1);
grid.addWidget(btn,  1, 0, 1, 2);     // row, col, rowSpan, colSpan
win.setLayout(grid);

// QFormLayout
auto form = new QFormLayout(cast(void*)null);
form.addRow("Name:", nameEdit);        // typed
form.addRow("Age:",  spinBox);
dlg.setLayout(form);
```

---

## 9. QMainWindow

```d
import gen_qmainwindow, gen_qmenubar, gen_qmenu, gen_qaction,
       gen_qtoolbar, gen_qstatusbar;

auto win  = new QMainWindow(cast(void*)null);

// Меню
auto mbar = QMenuBar.wrap(win.menuBar());
auto menu = QMenu.wrap(mbar.addMenu("&File"));
auto act  = new QAction(cast(void*)null);
act.setText("&Open...");
// подключить сигнал:
__gshared ESlot g_slOpen;
extern(C) void onOpen(void* dt, int n, int c) { /* ... */ }
g_slOpen = new ESlot(act.getWH());
g_slOpen.set(cast(void*)&onOpen);
act.connect_triggered(g_slOpen);
menu.addAction(act.getWH()); act.disown();

// Сепаратор + Exit
menu.addSeparator();
auto actExit = new QAction(cast(void*)null);
actExit.setText("E&xit");
// ... аналогично ...

// Тулбар
auto tb = QToolBar.wrap(win.addToolBar("Main"));
tb.addAction(act.getWH());   // void* вариант

// Статусбар
auto sb = QStatusBar.wrap(win.statusBar());
sb.showMessage("Ready");

// Центральный виджет
auto central = new QWidget(cast(void*)null);
auto vbox    = new QVBoxLayout(cast(void*)null);
// ... добавить виджеты в vbox ...
central.setLayout(vbox);
win.setCentralWidget(central);  // typed: auto-disown

win.setWindowTitle("My App");
win.resize(800, 600);
win.show();
```

---

## 10. QDialog (модальный)

```d
import gen_qdialog, gen_qlayout, gen_qpushbutton;

__gshared QDialog g_dlg;
__gshared ESlot   g_slClose;

extern(C) void onDlgClose(void* dt, int n, int c) {
    if (g_dlg) g_dlg.reject();
}

void showDialog(void* parentWH) {
    g_dlg = new QDialog(parentWH);
    g_dlg.setWindowTitle("Dialog");
    g_dlg.resize(400, 300);

    auto btn = new QPushButton(cast(void*)null);
    btn.setText("Close");
    g_slClose = new ESlot(btn.getWH());
    g_slClose.set(cast(void*)&onDlgClose);
    btn.connect_clicked(g_slClose);

    auto hbox = new QHBoxLayout(cast(void*)null);
    hbox.addStretch(1); hbox.addWidget(btn);

    auto vbox = new QVBoxLayout(cast(void*)null);
    // ... addWidget(content) ...
    vbox.addLayout(hbox);
    g_dlg.setLayout(vbox);

    g_dlg.exec();   // блокирует до закрытия
    // или g_dlg.show() для немодального
}
```

---

## 11. Стандартные диалоги

```d
import gen_qmessagebox, gen_qfiledialog, gen_qinputdialog;

// Информация / вопрос
QMessageBox.information(win.getWH(), "Title", "Text");
QMessageBox.warning(win.getWH(), "Title", "Text");
int r = QMessageBox.question(win.getWH(), "Q?", "Continue?",
        QMessageBox.Yes | QMessageBox.No, QMessageBox.No);
if (r == QMessageBox.Yes) { /* ... */ }

// Открыть файл
string path = QFileDialog.getOpenFileName(
    win.getWH(), "Open", "", "D Files (*.d);;All (*)");

// Сохранить файл
string savePath = QFileDialog.getSaveFileName(
    win.getWH(), "Save", "", "Text (*.txt)");

// Выбор директории
string dir = QFileDialog.getExistingDirectory(win.getWH(), "Choose Dir", "");

// Ввод строки
bool ok;
string s = QInputDialog.getText(win.getWH(), "Input", "Name:", "", &ok);
if (ok) { /* использовать s */ }

// Ввод числа
int n = QInputDialog.getInt(win.getWH(), "Input", "Count:", 1, 0, 100, 1, &ok);
```

---

## 12. Основные виджеты — ключевые методы

### QLabel
```d
auto lbl = new QLabel(cast(void*)null);
lbl.setText("Hello <b>World</b>");  // поддерживает HTML
lbl.setAlignment(0x84);             // Qt::AlignCenter = 0x84
lbl.setWordWrap(true);
lbl.setOpenExternalLinks(true);
```

### QLineEdit
```d
auto edit = new QLineEdit(cast(void*)null);
edit.setText("default");
edit.setPlaceholderText("Enter value...");
edit.setReadOnly(true);
edit.setEchoMode(2);              // 2 = Password
edit.setMaxLength(100);
string val = edit.text();

// Сигналы:
extern(C) void onChanged(void* dt, int n, void* qs) {
    string s = fromQString(qs);   // qs — временный, fromQString его удалит
}
extern(C) void onReturn(void* dt, int n) { /* Enter нажат */ }
g_sl = new ESlot(edit.getWH());
g_sl.set(cast(void*)&onReturn);
edit.connect_returnPressed(g_sl);
```

### QPushButton / QCheckBox / QRadioButton
```d
auto btn = new QPushButton(cast(void*)null);
btn.setText("&Click");      // & = shortcut key
btn.setEnabled(false);
btn.setCheckable(true);     // toggle button
bool checked = btn.isChecked();

auto cb = new QCheckBox(cast(void*)null);
cb.setText("Enable feature");
cb.setChecked(true);
int state = cb.checkState();  // 0=Unchecked, 2=Checked
```

### QComboBox
```d
auto combo = new QComboBox(cast(void*)null);
combo.addItem("One");
combo.addItem("Two");
// Массово:
void* qsl = toQStringList(["A", "B", "C"]);
combo.addItems(qsl); freeQStringList(qsl);
int idx    = combo.currentIndex();
string txt = combo.currentText();
combo.setCurrentIndex(1);
combo.clear();

extern(C) void onCombo(void* dt, int n, int idx) { /* idx изменился */ }
g_sl = new ESlot(combo.getWH());
g_sl.set(cast(void*)&onCombo);
combo.connect_currentIndexChanged_i(g_sl);
```

### QSpinBox / QDoubleSpinBox
```d
auto spin = new QSpinBox(cast(void*)null);
spin.setRange(0, 100);
spin.setValue(42);
spin.setSingleStep(5);
spin.setSuffix(" px");
int v = spin.value();

extern(C) void onSpin(void* dt, int n, int v) { /* значение изменилось */ }
g_sl = new ESlot(spin.getWH());
g_sl.set(cast(void*)&onSpin);
spin.connect_valueChanged_i(g_sl);
```

### QSlider
```d
auto sl = new QSlider(cast(void*)null);
sl.setOrientation(1);       // 1=Horizontal, 2=Vertical
sl.setRange(0, 100);
sl.setValue(50);
int v = sl.value();

extern(C) void onSlider(void* dt, int n, int v) { }
g_sl = new ESlot(sl.getWH());
g_sl.set(cast(void*)&onSlider);
sl.connect_valueChanged(g_sl);
```

### QTextEdit / QPlainTextEdit
```d
auto te = new QTextEdit(cast(void*)null);
te.setPlainText("Line 1\nLine 2");
te.setHtml("<h1>Title</h1><p>Body</p>");
string txt = te.toPlainText();
string html = te.toHtml();
te.setReadOnly(true);
te.append("New line");          // добавить в конец

auto pte = new QPlainTextEdit(cast(void*)null);
pte.setPlainText("code here");
pte.setFont(/* QFont */);
```

### QTextBrowser (HTML viewer, только чтение)
```d
import gen_qtextbrowser, gen_qtextedit;
auto br = new QTextBrowser(cast(void*)null);
br.setHtml("<h2>Hello</h2><pre>code block</pre>");
br.setOpenExternalLinks(true);
```

### QListWidget
```d
import gen_qlistwidget, gen_qabstractitemview;

auto list = new QListWidget(cast(void*)null);
list.addItem("Item 1");
list.addItem("Item 2");
void* item = list.createItem("Item 3");  // D-owned до addItem
list.addItemW(item);   // Qt takes ownership → не вызывать item delete
int row   = list.currentRow();
string s  = list.currentText();
list.clear();
list.setSelectionMode(2);   // 2=ExtendedSelection

extern(C) void onListClick(void* dt, int n, void* item) {
    import gen_qlistwidget : QListWidgetItem;
    auto i = QListWidgetItem.wrap(item);
    writeln(i.text());
}
list.onItemClicked(cast(void*)&onListClick);
```

### QTreeWidget
```d
import gen_qtreewidget, gen_qtreeview, gen_qabstractitemview;

auto tree = new QTreeWidget(cast(void*)null);
tree.setColumnCount(2);
tree.setHeaderLabels(["Name", "Value"]);

// Добавить узел верхнего уровня
auto top = new QTreeWidgetItem("Parent");
top.setText(1, "val");
tree.addTopLevelItem(top);   // typed → top.disown() автоматически

// Дочерний узел
auto child = new QTreeWidgetItem("Child");
child.setText(1, "42");
top.addChild(child);         // typed → child.disown()

tree.expandAll();
tree.setColumnWidth(0, 200);
tree.sortItems(0, 0);        // col=0, order=Ascending

// Получить выбранное
void* cur = tree.currentItem();
if (cur) {
    auto item = QTreeWidgetItem.wrap(cur);
    writeln(item.text(0));
}

// Сигнал
extern(C) void onTreeClick(void* dt, int n, void* item, int col) {
    auto i = QTreeWidgetItem.wrap(item);
    writeln("col ", col, ": ", i.text(col));
}
tree.onItemClicked(cast(void*)&onTreeClick);
```

### QTableWidget
```d
import gen_qtablewidget, gen_qtableview, gen_qabstractitemview;

auto tbl = new QTableWidget(cast(void*)null);
tbl.setRowCount(10);
tbl.setColumnCount(3);
tbl.setHorizontalHeaderLabels(["Col1", "Col2", "Col3"]);

// Установить ячейку
auto item = new QTableWidgetItem("text");
tbl.setItem(0, 0, item);   // typed → item.disown()

// Получить значение
auto cell = QTableWidgetItem.wrap(tbl.item(0, 0));
if (cell) writeln(cell.text());

tbl.setAlternatingRowColors(true);
tbl.horizontalHeader().setStretchLastSection(true);
tbl.setSelectionBehavior(1);   // 1=SelectRows

extern(C) void onCell(void* dt, int row, int col) { }
tbl.onCellClicked(cast(void*)&onCell);
```

### QTabWidget
```d
import gen_qtabwidget;

auto tabs = new QTabWidget(cast(void*)null);
auto page1 = new QWidget(cast(void*)null);
auto page2 = new QWidget(cast(void*)null);
// ... заполнить страницы ...
tabs.addTab(page1, "Tab 1");   // typed: page1.disown()
tabs.addTab(page2, "Tab 2");
tabs.setCurrentIndex(0);
int cur = tabs.currentIndex();

extern(C) void onTabChanged(void* dt, int n, int idx) { }
g_sl = new ESlot(tabs.getWH());
g_sl.set(cast(void*)&onTabChanged);
tabs.connect_currentChanged(g_sl);
```

### QSplitter
```d
import gen_qsplitter;

auto sp = new QSplitter(cast(void*)null);
sp.setOrientation(1);       // 1=Horizontal, 2=Vertical
sp.addWidget(leftPanel);    // typed: auto-disown
sp.addWidget(rightPanel);
sp.setSizes([300, 500]);    // начальные размеры
```

### QSettings
```d
import gen_qsettings;

auto cfg = new QSettings("myapp.ini", 0);   // 0=IniFormat
cfg.setValue("width",  800);
cfg.setValue("height", 600);
cfg.setValue("name",   "World");
int    w = cfg.value_i("width", 800);
string s = cfg.value_s("name", "default");
bool   b = cfg.value_b("visible", true);

// Двоичные данные:
ubyte[] data = [1, 2, 3, 4];
cfg.setBytes("blob", data);
ubyte[] loaded = cfg.getBytes("blob");

cfg.sync();   // сохранить на диск
```

### QTimer
```d
import gen_qtimer;

__gshared ESlot g_slTimer;
extern(C) void onTick(void* dt, int n) { /* раз в N мс */ }

auto timer = new QTimer(cast(void*)null);
g_slTimer = new ESlot(timer.getWH());
g_slTimer.set(cast(void*)&onTick);
timer.connect_timeout(g_slTimer);
timer.start(500);     // мс
// timer.stop(); // остановить
// timer.setSingleShot(true); // однократный
```

### QProcess
```d
import gen_qprocess;

auto proc = new QProcess();   // БЕЗ аргументов!
proc.start("notepad.exe", ["file.txt"]);
bool ok = proc.waitForFinished(5000);   // мс, -1 = бесконечно
string output = proc.readStdoutText();  // НЕ readAllStandardOutput()
int code = proc.exitCode();
```

---

## 13. События виджетов

```d
// ID событий (из qteQWidget_setEventHandler):
// 1=MousePress  2=MouseRelease 3=MouseDblClick 4=MouseMove
// 5=KeyPress    6=KeyRelease   7=Resize        8=Move
// 9=Close       10=Show        11=Hide         12=Enter  13=Leave
// 14=Wheel      15=FocusIn     16=FocusOut     17=ContextMenu 18=Paint

// Универсальный способ (сигнатура колбэка зависит от события, см. ниже):
extern(C) void myHandler(void* dthis, int* accept) { }
widget.setEventHandler(9, cast(void*)&myHandler, cast(void*)null);

// Типизированные хелперы (предпочтительно):
extern(C) void onClose(void* dt, int* accept)             { *accept = 0; /* 0=запретить */ }
extern(C) void onKey(void* dt, int key, int mods)         { /* клавиша */ }
extern(C) void onMouse(void* dt, int x, int y, int btn)   { /* мышь */ }
extern(C) void onPaint(void* dt, void* widget)            {
    auto p = new QPainter(widget, true);
    // ... рисовать ...
    p.end();
}
extern(C) void onResize(void* dt, int w, int h)           { /* resize */ }

win.onClose(cast(void*)&onClose);
win.onKeyPress(cast(void*)&onKey);
win.onMousePress(cast(void*)&onMouse);
win.onPaint(cast(void*)&onPaint);
win.onResize(cast(void*)&onResize);
```

---

## 14. QSS — стили

```d
// На одном виджете:
btn.setStyleSheet(
    "QPushButton { background:#3498db; color:white; border-radius:4px; padding:4px 12px; }"
    "QPushButton:hover { background:#2980b9; }"
    "QPushButton:disabled { background:#bdc3c7; }"
);

// Глобально на приложение:
app.setStyleSheet("
    QWidget      { font-family: Segoe UI; font-size: 10pt; }
    QPushButton  { background:#2ecc71; color:white; border:none; padding:4px 10px; }
    QLineEdit    { border:1px solid #bdc3c7; border-radius:3px; padding:2px 6px; }
    QTabWidget::pane { border:1px solid #ccc; }
    QTreeWidget  { alternate-background-color:#f5f5f5; }
");
```

---

## 15. Таблица колбэков сигналов

| Метод подключения | Сигнатура колбэка |
|-------------------|-------------------|
| `connect_clicked(sl)` | `void cb(void* dt, int n, int checked)` |
| `connect_pressed(sl)` / `connect_released(sl)` | `void cb(void* dt, int n, int v)` |
| `connect_toggled(sl)` | `void cb(void* dt, int n, int checked)` |
| `connect_stateChanged(sl)` | `void cb(void* dt, int n, int state)` — 0=Unchecked,2=Checked |
| `connect_valueChanged(sl)` (int) | `void cb(void* dt, int n, int v)` |
| `connect_valueChanged_d(sl)` (double) | `void cb(void* dt, int n, double v)` |
| `connect_currentIndexChanged_i(sl)` | `void cb(void* dt, int n, int idx)` |
| `connect_currentTextChanged(sl)` | `void cb(void* dt, int n, void* qs)` → `fromQString(qs)` |
| `connect_textChanged(sl)` (LineEdit) | `void cb(void* dt, int n, void* qs)` |
| `connect_returnPressed(sl)` | `void cb(void* dt, int n)` |
| `connect_editingFinished(sl)` | `void cb(void* dt, int n)` |
| `connect_timeout(sl)` | `void cb(void* dt, int n)` |
| `connect_triggered(sl)` (QAction) | `void cb(void* dt, int n, int checked)` |
| `connect_currentChanged(sl)` (QTabWidget) | `void cb(void* dt, int n, int idx)` |
| `onItemClicked(cb)` (QTreeWidget) | `void cb(void* dt, int n, void* item, int col)` |
| `onItemClicked(cb)` (QListWidget) | `void cb(void* dt, int n, void* item)` |
| `onCellClicked(cb)` (QTableWidget) | `void cb(void* dt, int row, int col)` |
| `connect_finished(cb)` (QProcess) | `void cb(int exitCode, int exitStatus)` — прямой, не ESlot |
| `connect_started(dg)` (QThread) | `void delegate()` — не ESlot |
| `connect_finished(dg)` (QThread) | `void delegate()` — не ESlot |

---

## 16. Утилиты

```d
// ── net_utils.d — синхронный HTTP (крутит event loop внутри) ─────────────────
import net_utils;
string html  = httpGet("http://example.com");
string resp  = httpPost("http://api/endpoint", "key=value&x=1");
ubyte[] data = httpGetBytes("http://example.com/file.bin");

// ── curl_utils.d — CurlSession (fluent, через libcurl) ──────────────────────
import curl_utils;
auto curl = new CurlSession();
string r = curl.url("https://api.example.com/data").get();
string p = curl.url("https://api.example.com/post")
               .header("Content-Type: application/json")
               .body_(`{"key":"val"}`)
               .post();

// ── json.d — pure D JSON (без Qt) ────────────────────────────────────────────
import json;
auto j = parseJson(`{"name":"Alice","age":30,"items":[1,2,3]}`);
string name = j["name"].get!string("");
int    age  = j["age"].get!int(0);
foreach (v; j["items"]) writeln(v.get!int(0));

auto obj = jobject();
obj["key"] = JsonValue("value");
string compact = toJsonCompact(obj);
string pretty  = toJsonPretty(obj);

// ── QThread ──────────────────────────────────────────────────────────────────
import gen_qthread;
// Конструктор принимает void delegate() — не C-функцию!
auto thr = new QThread({
    // рабочий поток
    QThread.msleep(200);
});
thr.start();
thr.wait();

// ── QMutex ───────────────────────────────────────────────────────────────────
auto mtx = new QMutex(cast(void*)null);
mtx.lock();
// ... критическая секция ...
mtx.unlock();
```

---

## 17. Подводные камни

```
1. LoadQt() ПЕРЕД new QApplication(). Всегда.

2. new QLabel(cast(void*)null) — нужен явный каст.
   Без cast: компилятор выбирает перегрузку this(string), а не this(void*).

3. ESlot должен жить пока активен сигнал.
   Хранить в __gshared переменной или массиве — иначе GC удалит.

4. Typed addWidget(obj)/setLayout(layout)/setCentralWidget(obj)
   вызывают obj.disown() автоматически. НЕ обращаться к obj._ptr после.

5. НЕ вызывать UnloadQt(). Только app.exec() → app.deleteApp().
   ОС сама освободит DLL.

6. fromQString(qs) удаляет qs (вызывает delete QString на C++ стороне).
   НЕ использовать qs после fromQString.

7. Текстовые сигналы (textChanged, currentTextChanged) передают void* qs.
   Сделать fromQString(qs) в теле колбэка — это освобождает qs.

8. QComboBox.addItems/QTreeWidget.setHeaderLabels принимают void* (QStringList).
   Использовать toQStringList(arr) → передать → freeQStringList(ptr).

9. GC + потоки: делать GC.collect() ПЕРЕД app.deleteApp()
   если используешь QThread.

10. QScintilla требует два DLL в PATH:
    qte56_qscintilla.dll + qscintilla2_qt5.dll.

11. QProcess::FailedToStart == 0 (не 1!).
    enum: 0=FailedToStart, 1=Crashed, 2=Timedout, 3=ReadError, 4=WriteError.

12. QMdiArea.addSubWindow() → plain void* (не типизированный).
    Правильно: new QMdiSubWindow(mdi.getWH()) + msw.setWidget(container).

13. Wren: % внутри строки начинает интерполяцию. Экранировать как \%.

14. QFileSystemWatcher: после удаления файла снимает наблюдение.
    Переподписываться в connect_fileChanged колбэке.

15. QCompleter: после attachTo() Qt берёт ownership — НЕ delete вручную.
```

---

*arch_new/AI_CONTEXT.md — апрель 2026*
