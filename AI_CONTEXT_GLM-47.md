# QTE56 — AI Cheat-Sheet (D + Qt 5.13.2 через DLL)

> Вставь этот файл в системный контекст. Пиши D-программы с Qt через готовые DLL/SO.
> НЕ нужны Qt, C++ компилятор, qmake. Нужны только: DLL из `dll/`, D-компилятор.

---

## 📚 ДОПОЛНИТЕЛЬНЫЕ ФАЙЛЫ — ИНСТРУКЦИЯ ДЛЯ AI

> **AI:** Этот файл — сжатый обзор. Когда задача касается конкретной темы —
> **попроси пользователя показать соответствующий файл** для получения полной документации.
> Фраза: *"Для этой задачи покажи мне файл AI_XXX.md"*

| Файл | Попроси, когда задача касается... |
|------|----------------------------------|
| `AI_CORE.md` | Загрузка DLL, `LoadQt`, `toQString`/`fromQString`, `ESlot` базис, структура проекта |
| `AI_SIGNALS_REF.md` | Любые сигналы/слоты, сигнатуры коллбэков, `connect_*`, `onXxx` |
| `AI_WIDGETS.md` | QLabel, QPushButton, QCheckBox, QRadioButton, QLineEdit, QComboBox, QSpinBox, QSlider, QProgressBar, QGroupBox |
| `AI_MAINWINDOW.md` | QMainWindow, QMenuBar, QMenu, QAction, QToolBar, QStatusBar, QDockWidget, QMdiArea/QMdiSubWindow |
| `AI_DIALOGS.md` | QDialog (собственный), QMessageBox, QFileDialog, QInputDialog, QFontDialog, QColorDialog |
| `AI_CONTAINERS.md` | Layouts (VBox/HBox/Grid/Form), QTabWidget, QSplitter, QStackedWidget, QScrollArea, QToolBox |
| `AI_DATAVIEW.md` | QListWidget, QTreeWidget, QTableWidget, QHeaderView, выделение/сортировка строк |
| `AI_TEXTEDITOR.md` | QTextEdit, QPlainTextEdit, QTextBrowser, QScintilla (подсветка синтаксиса), QTextDocument |
| `AI_DRAWING.md` | QPainter, QPixmap, QImage, QColor, QPen, QBrush, QFont, QFontMetrics, onPaint |
| `AI_DATETIME.md` | QDate, QTime, QDateTime, QDateEdit, QTimeEdit, QDateTimeEdit, QCalendarWidget |
| `AI_TRAY_EXTRA.md` | QSystemTrayIcon, QCompleter, QShortcut, QClipboard, QDesktopWidget, QFileSystemWatcher |
| `AI_SQL.md` | QSqlDatabase, QSqlQuery, SQLite, ODBC |
| `AI_NETWORK_GUIDE.md` | HTTP/HTTPS: `httpGet`/`httpPost`, QNetwork, `CurlSession`, `json.d` |
| `AI_WREN.md` | Wren-скриптинг, OLE/COM, Excel/Word/Outlook автоматизация |
| `AI_FORMS.md` | .ui-файлы Qt Designer, `QForm.load`, `findButton`/`findAction`/..., `<connections>` builtin/custom slots |

---

## ⚠️ КРИТИЧЕСКИЕ ПРАВИЛА — НАРУШЕНИЕ ВЫЗЫВАЕТ ОШИБКУ КОМПИЛЯЦИИ

```d
// ✅ ПРАВИЛЬНО — ВСЕГДА используй cast(void*)null для виджетов без родителя:
auto btn  = new QPushButton(cast(void*)null);
auto lbl  = new QLabel(cast(void*)null);
auto vbox = new QVBoxLayout(cast(void*)null);

// ❌ НЕПРАВИЛЬНО — D выберет перегрузку this(string), не this(void*):
auto btn  = new QPushButton(null);       // ОШИБКА КОМПИЛЯЦИИ
auto lbl  = new QLabel(null);           // ОШИБКА КОМПИЛЯЦИИ
```

```d
// ✅ ПРАВИЛЬНЫЙ порядок инициализации:
LoadQt("./dll");              // 1. ПЕРВЫМ — до всего
auto app = new QApplication(); // 2. QApplication
// ... виджеты ...             // 3. Виджеты
w.show();                     // 4. show
app.exec();                   // 5. event loop
GC.collect();                 // 6. GC ДО deleteApp
app.deleteApp();              // 7. последним
// НЕ вызывать UnloadQt() — ОС сама освободит DLL
```

```d
// ✅ ПРАВИЛЬНЫЕ сигнатуры ESlot-колбэков — КАЖДЫЙ invoke добавляет int n:
extern(C) void onBtn(void* dt, int n, int checked) { }  // invoke_b → clicked/toggled
extern(C) void onInt(void* dt, int n, int value)   { }  // invoke_i → valueChanged/stateChanged/currentIndex
extern(C) void onStr(void* dt, int n, void* qs)    { }  // invoke_s → textChanged
extern(C) void onVoid(void* dt, int n)             { }  // invoke_v → returnPressed/timeout

// ❌ НЕПРАВИЛЬНО (забыли int n — колбэк получит n вместо value!):
extern(C) void onInt(void* dt, int value) { }  // ОШИБКА ЛОГИКИ: value = n, не реальное значение!
```

---

## 1. Структура и компиляция

```
arch_new/
  d/          — qte56_core.d, qte56_loader.d, qte56_enums.d + утилиты
  d/gen/      — gen_qwidget.d, gen_qlabel.d, ... (80+ классов)
  dll/        — *.dll (Windows)  |  lib/ — *.so (Linux) / *.dylib (macOS)
```

**Windows 32-bit (основная платформа):**
```bat
dmd -m32 -i myapp.d -Id -Id/gen -of=myapp.exe
set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
myapp.exe
```

> Linux/macOS: `dmd -i myapp.d -Id -Id/gen -of=myapp` → `LD_LIBRARY_PATH=./lib ./myapp`

---

## 2. Обязательный шаблон приложения

```d
import qte56_core;        // pFunQt[], generateAlias, ESlot, toQString, fromQString
import qte56_loader;      // LoadQt()
import gen_qcore;         // QApplication
import gen_qwidget;
import gen_qlabel;
import gen_qpushbutton;
import gen_qabstractbutton;  // ОБЯЗАТЕЛЕН вместе с gen_qpushbutton!
import gen_qlayout;
import core.memory : GC;

void main() {                           // НЕ extern(C) int main!
    LoadQt("./dll");
    auto app = new QApplication();

    auto w = new QWidget(cast(void*)null);
    w.setWindowTitle("My App");
    w.resize(640, 480);

    auto lbl = new QLabel(cast(void*)null);
    lbl.setText("Hello World");

    auto vbox = new QVBoxLayout(cast(void*)null);
    vbox.addWidget(lbl);    // Qt takes ownership (auto-disown)
    w.setLayout(vbox);      // Qt takes ownership (auto-disown)

    w.show();
    app.exec();
    GC.collect();
    app.deleteApp();
}
```

---

## 3. Таблица импортов

| Класс | import | Примечание |
|-------|--------|-----------|
| QWidget | `gen_qwidget` | базовый |
| QLabel | `gen_qlabel` | |
| QPushButton | `gen_qpushbutton` + `gen_qabstractbutton` | оба! |
| QCheckBox | `gen_qcheckbox` + `gen_qabstractbutton` | оба! |
| QRadioButton | `gen_qradiobutton` + `gen_qabstractbutton` | оба! |
| QLineEdit | `gen_qlineedit` | |
| QComboBox | `gen_qcombobox` | |
| QSpinBox | `gen_qspinbox` + `gen_qabstractspinbox` | оба! |
| QDoubleSpinBox | `gen_qdoublespinbox` + `gen_qabstractspinbox` | оба! |
| QSlider | `gen_qslider` + `gen_qabstractslider` | оба! |
| QDial | `gen_qdial` + `gen_qabstractslider` | оба! |
| QProgressBar | `gen_qprogressbar` | |
| QGroupBox | `gen_qgroupbox` | |
| QTabWidget | `gen_qtabwidget` | |
| QSplitter | `gen_qsplitter` | |
| QStackedWidget | `gen_qstackedwidget` | |
| QScrollArea | `gen_qscrollarea` | |
| QLCDNumber | `gen_qlcdnumber` | |
| QVBoxLayout / QHBoxLayout / QGridLayout / QFormLayout | `gen_qlayout` | |
| QMainWindow | `gen_qmainwindow` | qte56_mainwin.dll |
| QMenuBar / QMenu / QAction / QToolBar / QStatusBar | `gen_qmenubar` / `gen_qmenu` / `gen_qaction` / `gen_qtoolbar` / `gen_qstatusbar` | qte56_mainwin.dll |
| QDialog | `gen_qdialog` | qte56_dialogs.dll |
| QMessageBox | `gen_qmessagebox` + `gen_qdialog` | оба! |
| QFileDialog | `gen_qfiledialog` + `gen_qdialog` | оба! |
| QInputDialog | `gen_qinputdialog` + `gen_qdialog` | оба! |
| QTextEdit / QPlainTextEdit / QTextBrowser | `gen_qtextedit` / `gen_qplaintextedit` / `gen_qtextbrowser` | qte56_text.dll |
| QListWidget | `gen_qlistwidget` + `gen_qabstractitemview` | qte56_views.dll |
| QTreeWidget | `gen_qtreewidget` + `gen_qtreeview` + `gen_qabstractitemview` | qte56_views.dll |
| QTableWidget | `gen_qtablewidget` + `gen_qtableview` + `gen_qabstractitemview` | qte56_views.dll |
| QHeaderView | `gen_qheaderview` | qte56_views.dll |
| QTimer | `gen_qtimer` | |
| QSettings | `gen_qsettings` | qte56_foundation.dll |
| QFont | `gen_qfont` | qte56_foundation.dll |
| QByteArray | `gen_qbytearray` | qte56_foundation.dll |
| QDate/QTime/QDateTime | `gen_qdate` | qte56_foundation.dll |
| QCalendarWidget / QDateTimeEdit | `gen_qcalendarwidget` / `gen_qdatetimeedit` | |
| QPainter / QColor / QPixmap / QImage | `gen_qpainter` / `gen_qcolor` / `gen_qpixmap` / `gen_qimage` | qte56_drawing.dll |
| QProcess | `gen_qprocess` | qte56_qprocess.dll |
| QThread / QMutex | `gen_qthread` | qte56_thread.dll |
| QShortcut | `gen_qshortcut` | qte56_shortcut.dll |
| QFileSystemWatcher | `gen_qfilesystemwatcher` | qte56_filewatcher.dll |
| QCompleter | `gen_qcompleter` | qte56_completer.dll |
| QUiLoader / QForm | `gen_quiloader` / `qte56_forms` | qte56_uiloader.dll — .ui-формы из Qt Designer |

---

## 4. Владение объектами (Ownership)

| Способ | Поведение |
|--------|-----------|
| `vbox.addWidget(lbl)` — typed | Qt берёт ownership, `lbl.disown()` вызван **автоматически** |
| `w.setLayout(vbox)` — typed | Qt берёт ownership, `vbox.disown()` **автоматически** |
| `win.setCentralWidget(w)` — typed | Qt берёт ownership **автоматически** |
| `vbox.addWidget(lbl.getWH())` — void* | disown() **НЕ вызывается** — нужен `lbl.disown()` вручную |
| `QMenuBar.wrap(win.menuBar())` | Qt создал объект — D его **не удаляет** |
| `new QWidget(parentWH)` | Qt владеет через parent — `disown()` не нужен |

```d
// Пример auto-disown:
auto lbl  = new QLabel(cast(void*)null);
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(lbl);     // ← auto-disown: lbl._ptr теперь принадлежит Qt
w.setLayout(vbox);       // ← auto-disown: vbox._ptr принадлежит Qt
// НЕ использовать lbl и vbox для обращения к указателю после этого!
```

---

## 5. ESlot — подключение сигналов

```d
// Паттерн: хранить ESlot в __gshared (иначе GC удалит!)
__gshared ESlot g_sl;

// Колбэк — всегда extern(C), всегда __gshared для Qt-объектов
__gshared QPushButton g_btn;

extern(C) void onClicked(void* dt, int n, int checked) {
    // dt   = указатель из ESlot (обычно игнорируется)
    // n    = внутренний счётчик ESlot (всегда 2-й, игнорируется)
    // checked = 0/1 (для кнопок = всегда 0 если не toggle)
}

// Подключение:
g_btn = new QPushButton(cast(void*)null);
g_sl  = new ESlot(g_btn.getWH());   // привязать к виджету
g_sl.set(cast(void*)&onClicked);    // установить функцию
g_btn.connect_clicked(g_sl);         // подключить сигнал
```

### Полная таблица сигнатур колбэков

| connect_* | Внутренний invoke | Сигнатура колбэка |
|-----------|-------------------|-------------------|
| `connect_clicked(sl)` | invoke_b | `void cb(void* dt, int n, int checked)` |
| `connect_toggled(sl)` | invoke_b | `void cb(void* dt, int n, int checked)` |
| `connect_triggered(sl)` (QAction) | invoke_b | `void cb(void* dt, int n, int checked)` |
| `connect_stateChanged(sl)` (QCheckBox) | invoke_i | `void cb(void* dt, int n, int state)` — 0=Off, 2=On |
| `connect_valueChanged(sl)` (QSlider/QDial) | invoke_i | `void cb(void* dt, int n, int value)` |
| `connect_valueChanged_i(sl)` (QSpinBox) | invoke_i | `void cb(void* dt, int n, int value)` |
| `connect_valueChanged_d(sl)` (QDoubleSpinBox) | invoke_d | `void cb(void* dt, int n, double value)` |
| `connect_currentIndexChanged_i(sl)` (QComboBox) | invoke_i | `void cb(void* dt, int n, int idx)` |
| `connect_currentChanged(sl)` (QTabWidget) | invoke_i | `void cb(void* dt, int n, int idx)` |
| `connect_textChanged(sl)` (QLineEdit) | invoke_s | `void cb(void* dt, int n, void* qs)` → `fromQString(qs)` |
| `connect_currentTextChanged(sl)` | invoke_s | `void cb(void* dt, int n, void* qs)` |
| `connect_returnPressed(sl)` | invoke_v | `void cb(void* dt, int n)` |
| `connect_editingFinished(sl)` | invoke_v | `void cb(void* dt, int n)` |
| `connect_timeout(sl)` (QTimer) | invoke_v | `void cb(void* dt, int n)` |
| `connect_textChanged(sl)` (QTextEdit) | invoke_v | `void cb(void* dt, int n)` |
| **Прямые (не ESlot):** | | |
| `onItemClicked(cb)` (QListWidget) | прямой | `void cb(void* dt, int n, void* item)` |
| `onItemClicked(cb)` (QTreeWidget) | прямой | `void cb(void* dt, int n, void* item, int col)` |
| `onCellClicked(cb)` (QTableWidget) | прямой | `void cb(void* dt, int row, int col)` |
| `onCurrentRowChanged(cb)` (QListWidget) | прямой | `void cb(void* dt, int n, int row)` |
| `connect_finished(cb)` (QProcess) | прямой | `void cb(int exitCode, int exitStatus)` |

> **AI:** Нужен полный справочник всех сигналов? → попроси показать **AI_SIGNALS_REF.md**

---

## 6. Виджеты — ключевые методы и сигналы

### QLabel
```d
// import: gen_qlabel
auto lbl = new QLabel(cast(void*)null);
lbl.setText("Hello <b>World</b>");   // поддерживает HTML
lbl.setAlignment(0x84);              // Qt::AlignCenter
lbl.setWordWrap(true);
lbl.setStyleSheet("color: red; font-size: 14px;");
```

### QPushButton / QCheckBox / QRadioButton
```d
// import: gen_qpushbutton, gen_qabstractbutton (оба!)
auto btn = new QPushButton(cast(void*)null);
btn.setText("&Click Me");  // & = Alt-shortcut
btn.setEnabled(false);
btn.setCheckable(true);
bool v = btn.isChecked();

// Сигнал clicked(bool):
extern(C) void onBtn(void* dt, int n, int checked) { /* ... */ }
__gshared ESlot g_sl;
g_sl = new ESlot(btn.getWH());
g_sl.set(cast(void*)&onBtn);
btn.connect_clicked(g_sl);

// QCheckBox — сигнал stateChanged(int):
// import: gen_qcheckbox, gen_qabstractbutton
auto cb = new QCheckBox(cast(void*)null);
cb.setText("Enable");
cb.setChecked(true);
// state: 0=Unchecked, 2=Checked
extern(C) void onCheck(void* dt, int n, int state) { /* state==2 → включён */ }
g_sl = new ESlot(cb.getWH());
g_sl.set(cast(void*)&onCheck);
cb.connect_stateChanged(g_sl);
```

### QLineEdit
```d
// import: gen_qlineedit
auto edit = new QLineEdit(cast(void*)null);
edit.setText("default");
edit.setPlaceholderText("Enter value...");
edit.setReadOnly(true);
edit.setEchoMode(2);      // 2=Password
edit.setMaxLength(100);
string val = edit.text();

// Сигнал textChanged(str) — invoke_s → 3 аргумента:
extern(C) void onChanged(void* dt, int n, void* qs) {
    string s = fromQString(qs);  // fromQString освобождает qs!
}
// Сигнал returnPressed():
extern(C) void onReturn(void* dt, int n) { /* Enter нажат */ }
g_sl = new ESlot(edit.getWH());
g_sl.set(cast(void*)&onReturn);
edit.connect_returnPressed(g_sl);
```

### QComboBox
```d
// import: gen_qcombobox
auto combo = new QComboBox(cast(void*)null);
combo.addItem("One");
combo.addItem("Two");
// Массово через QStringList:
void* qsl = toQStringList(["A", "B", "C"]);
combo.addItems(qsl); freeQStringList(qsl);
int    idx = combo.currentIndex();
string txt = combo.currentText();
combo.setCurrentIndex(1);
combo.clear();

// Сигнал currentIndexChanged(int) — invoke_i → 3 аргумента:
extern(C) void onCombo(void* dt, int n, int idx) { /* idx изменился */ }
g_sl = new ESlot(combo.getWH());
g_sl.set(cast(void*)&onCombo);
combo.connect_currentIndexChanged_i(g_sl);   // суффикс _i !
```

### QSpinBox / QDoubleSpinBox
```d
// import: gen_qspinbox, gen_qabstractspinbox (оба!)
auto spin = new QSpinBox(cast(void*)null);
spin.setRange(0, 100);
spin.setValue(42);
spin.setSingleStep(5);
spin.setSuffix(" px");
int v = spin.value();

// Сигнал valueChanged(int) — invoke_i → 3 аргумента:
extern(C) void onSpin(void* dt, int n, int value) { /* value = реальное значение */ }
g_sl = new ESlot(spin.getWH());
g_sl.set(cast(void*)&onSpin);
spin.connect_valueChanged_i(g_sl);   // суффикс _i !

// QDoubleSpinBox: import gen_qdoublespinbox, gen_qabstractspinbox
auto dspin = new QDoubleSpinBox(cast(void*)null);
dspin.setRange(0.0, 1.0);
dspin.setSingleStep(0.01);
dspin.setDecimals(2);
double dv = dspin.value();
```

### QSlider / QDial
```d
// import: gen_qslider, gen_qabstractslider (оба!)
auto sl = new QSlider(cast(void*)null);
sl.setOrientation(1);   // 1=Horizontal, 2=Vertical
sl.setRange(0, 100);
sl.setValue(50);
sl.setTickInterval(10);
sl.setTickPosition(2);  // 2=TicksBelow
int v = sl.value();

// Сигнал valueChanged(int) — invoke_i → 3 аргумента:
extern(C) void onSlider(void* dt, int n, int value) { /* ПРАВИЛЬНО: 3 аргумента! */ }
g_sl = new ESlot(sl.getWH());
g_sl.set(cast(void*)&onSlider);
sl.connect_valueChanged(g_sl);   // без суффикса _i для слайдера
```

### QTextEdit / QPlainTextEdit
```d
// import: gen_qtextedit (для QTextEdit)
auto te = new QTextEdit(cast(void*)null);
te.setPlainText("Line 1\nLine 2");
te.setHtml("<h1>Title</h1><p>Body</p>");
string txt  = te.toPlainText();
string html = te.toHtml();
te.setReadOnly(true);
te.append("New line");
te.clear();

// Сигнал textChanged() — invoke_v → 2 аргумента:
extern(C) void onTextEdit(void* dt, int n) { /* текст изменился */ }
g_sl = new ESlot(te.getWH());
g_sl.set(cast(void*)&onTextEdit);
te.connect_textChanged(g_sl);
```

> **AI:** QTextEdit/QPlainTextEdit/QScintilla с подсветкой синтаксиса? → попроси показать **AI_TEXTEDITOR.md**

### QTimer
```d
// import: gen_qtimer
__gshared ESlot g_slTimer;
extern(C) void onTick(void* dt, int n) { /* раз в N мс */ }

auto timer = new QTimer(cast(void*)null);
g_slTimer = new ESlot(timer.getWH());
g_slTimer.set(cast(void*)&onTick);
timer.connect_timeout(g_slTimer);
timer.setInterval(500);
timer.start();
// timer.stop();
// timer.setSingleShot(true);
```

> **AI:** Детальная документация по стандартным виджетам (QLabel, QPushButton, QLineEdit…)? → попроси показать **AI_WIDGETS.md**

### QListWidget
```d
// import: gen_qlistwidget, gen_qabstractitemview (оба!)
auto list = new QListWidget(cast(void*)null);
list.addItem("Item 1");
list.addItem("Item 2");
int    row = list.currentRow();
string s   = list.currentText();
list.takeItem(row);  // удалить строку
list.clear();
list.scrollToBottom();

// Сигнал (прямой, не ESlot):
extern(C) void onListClick(void* dt, int n, void* item) {
    auto i = QListWidgetItem.wrap(item);  // wrap не освобождает!
    string text = i.text();
}
list.onItemClicked(cast(void*)&onListClick);

// Или через onCurrentRowChanged:
extern(C) void onRowChanged(void* dt, int n, int row) { /* row = новая строка */ }
list.onCurrentRowChanged(cast(void*)&onRowChanged);
```

### QTreeWidget
```d
// import: gen_qtreewidget, gen_qtreeview, gen_qabstractitemview (все три!)
auto tree = new QTreeWidget(cast(void*)null);
tree.setColumnCount(2);
tree.setHeaderLabels(["Name", "Value"]);

auto top = new QTreeWidgetItem("Parent");
top.setText(1, "value");
tree.addTopLevelItem(top);   // auto-disown

auto child = new QTreeWidgetItem("Child");
top.addChild(child);         // auto-disown

tree.expandAll();

extern(C) void onTreeClick(void* dt, int n, void* item, int col) {
    auto i = QTreeWidgetItem.wrap(item);
    string s = i.text(col);
}
tree.onItemClicked(cast(void*)&onTreeClick);
```

### QTableWidget
```d
// import: gen_qtablewidget, gen_qtableview, gen_qabstractitemview (все три!)
auto tbl = new QTableWidget(cast(void*)null);
tbl.setRowCount(10);
tbl.setColumnCount(3);
tbl.setHorizontalHeaderLabels(["Col1", "Col2", "Col3"]);
tbl.setItem(0, 0, new QTableWidgetItem("text"));  // auto-disown
tbl.setAlternatingRowColors(true);
tbl.setSelectionBehavior(1);   // 1=SelectRows

// Растянуть последний столбец:
QHeaderView.wrap(tbl.horizontalHeader()).setStretchLastSection(true);

auto cell = QTableWidgetItem.wrap(tbl.item(0, 0));
if (cell) string s = cell.text();

extern(C) void onCell(void* dt, int row, int col) { }
tbl.onCellClicked(cast(void*)&onCell);
```

> **AI:** Работа с QListWidget/QTreeWidget/QTableWidget (сортировка, делегаты, выделение)? → попроси показать **AI_DATAVIEW.md**

### QTabWidget
```d
// import: gen_qtabwidget
auto tabs = new QTabWidget(cast(void*)null);
auto page1 = new QWidget(cast(void*)null);
tabs.addTab(page1, "Tab 1");   // auto-disown
tabs.setCurrentIndex(0);
int cur = tabs.currentIndex();

extern(C) void onTabChanged(void* dt, int n, int idx) { }
g_sl = new ESlot(tabs.getWH());
g_sl.set(cast(void*)&onTabChanged);
tabs.connect_currentChanged(g_sl);
```

### QSplitter
```d
// import: gen_qsplitter
auto sp = new QSplitter(cast(void*)null);
sp.setOrientation(1);       // 1=Horizontal, 2=Vertical
sp.addWidget(leftPanel);    // auto-disown
sp.addWidget(rightPanel);   // auto-disown
sp.setSizes([300, 500]);
```

> **AI:** QSplitter/QTabWidget/QStackedWidget/QScrollArea/QToolBox подробно? → попроси показать **AI_CONTAINERS.md**

---

## 7. Layouts

```d
// QVBoxLayout / QHBoxLayout
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(label);          // Qt takes ownership (auto-disown)
vbox.addWidget(button);         // Qt takes ownership (auto-disown)
vbox.addStretch(1);
vbox.setSpacing(8);
vbox.setContentsMargins(10, 10, 10, 10);
container.setLayout(vbox);      // Qt takes ownership (auto-disown)

// Вложение layout:
auto hbox = new QHBoxLayout(cast(void*)null);
hbox.addStretch(1);
hbox.addWidget(btnOk);
hbox.addWidget(btnCancel);
vbox.addLayout(hbox);           // Qt takes ownership (auto-disown)

// QGridLayout
auto grid = new QGridLayout(cast(void*)null);
grid.addWidget(lbl,  0, 0);            // row, col
grid.addWidget(edit, 0, 1);
grid.addWidget(btn,  1, 0, 1, 2);     // row, col, rowSpan, colSpan
win.setLayout(grid);

// QFormLayout
auto form = new QFormLayout(cast(void*)null);
form.addRow("Name:", nameEdit);
form.addRow("Age:",  spinBox);
dlg.setLayout(form);
```

> **AI:** Полная документация по layouts и контейнерам? → попроси показать **AI_CONTAINERS.md**

---

## 8. QMainWindow

```d
// import: gen_qmainwindow, gen_qmenubar, gen_qmenu, gen_qaction,
//         gen_qtoolbar, gen_qstatusbar
auto win = new QMainWindow(cast(void*)null);

// Меню — wrap() для объектов созданных Qt (не нами):
auto mbar = QMenuBar.wrap(win.menuBar());        // wrap, не new
auto menu = new QMenu("&File", cast(void*)null);
mbar.addMenu(menu.getWH()); menu.disown();       // void* API → disown вручную

// QAction
auto act = new QAction(cast(void*)null);
act.setText("&Open...");
act.setShortcutStr("Ctrl+O");                    // setShortcutStr, НЕ setShortcut!

// Сигнал triggered(bool) — invoke_b:
extern(C) void onOpen(void* dt, int n, int checked) { /* ... */ }
__gshared ESlot g_slOpen;
g_slOpen = new ESlot(act.getWH());
g_slOpen.set(cast(void*)&onOpen);
act.connect_triggered(g_slOpen);
menu.addAction(act.getWH()); act.disown();

// Тулбар (wrap — Qt создал):
auto tb = QToolBar.wrap(win.addToolBar("Main"));
tb.addAction(act.getWH());

// Статусбар (wrap):
QStatusBar.wrap(win.statusBar()).showMessage("Ready", 0);

// Центральный виджет:
auto central = new QWidget(cast(void*)null);
// ... заполнить виджеты ...
win.setCentralWidget(central);   // typed → auto-disown

win.setWindowTitle("My App");
win.resize(800, 600);
win.show();
```

> **AI:** Меню, тулбары, доки, MDI (QMdiArea/QMdiSubWindow), saveState/restoreState? → попроси показать **AI_MAINWINDOW.md**

---

## 9. Диалоги

### QMessageBox
```d
// import: gen_qmessagebox, gen_qdialog (оба!)
QMessageBox.information(win.getWH(), "Title", "Text");
QMessageBox.warning(win.getWH(), "Title", "Text");
QMessageBox.critical(win.getWH(), "Error", "Text");
int r = QMessageBox.question(win.getWH(), "Q?", "Continue?",
        QMessageBox.Yes | QMessageBox.No, QMessageBox.No);
if (r == QMessageBox.Yes) { /* ... */ }
```

### QFileDialog / QInputDialog
```d
// import: gen_qfiledialog, gen_qdialog
string path = QFileDialog.getOpenFileName(
    win.getWH(), "Open", "", "D Files (*.d);;All (*)");
string save = QFileDialog.getSaveFileName(win.getWH(), "Save", "", "Text (*.txt)");
string dir  = QFileDialog.getExistingDirectory(win.getWH(), "Dir", "");

// import: gen_qinputdialog, gen_qdialog
bool ok;
string s = QInputDialog.getText(win.getWH(), "Input", "Name:", "", &ok);
int    n = QInputDialog.getInt(win.getWH(), "Input", "Count:", 1, 0, 100, 1, &ok);
```

### QDialog (собственный)
```d
// import: gen_qdialog
__gshared QDialog g_dlg;
__gshared ESlot   g_slOk, g_slCancel;

extern(C) void onDlgOk(void* dt, int n, int c)     { g_dlg.accept(); }
extern(C) void onDlgCancel(void* dt, int n, int c) { g_dlg.reject(); }

g_dlg = new QDialog(parentWH);
g_dlg.resize(400, 300);
auto btnOk = new QPushButton(cast(void*)null); btnOk.setText("OK");
g_slOk = new ESlot(btnOk.getWH()); g_slOk.set(cast(void*)&onDlgOk);
btnOk.connect_clicked(g_slOk);

// ... layout ...
int result = g_dlg.exec();  // Accepted=1, Rejected=0
if (result == QDialog.Accepted) { /* OK нажато */ }
```

> **AI:** QFontDialog, QColorDialog, собственные диалоги подробно? → попроси показать **AI_DIALOGS.md**

---

## 10. События виджетов

```d
// Типизированные методы (предпочтительно):
extern(C) void onClose(void* dt, int* accept) {
    *accept = 0;   // 0=запретить закрытие, 1=разрешить
}
extern(C) void onKeyPress(void* dt, int key, int modifiers) { }
extern(C) void onMousePress(void* dt, int x, int y, int button) { }
extern(C) void onMouseMove(void* dt, int x, int y)  { }
extern(C) void onWheel(void* dt, int dx, int dy)    { }
extern(C) void onResize(void* dt, int w, int h)     { }
extern(C) void onFocusIn(void* dt, int reason)      { }
extern(C) void onPaint(void* dt, void* widget) {
    auto p = new QPainter(widget, true);  // import: gen_qpainter
    // ... рисовать ...
    p.end();
    widget.update();  // НЕ вызывать, если уже в paintEvent!
}

win.onClose(cast(void*)&onClose);
win.onKeyPress(cast(void*)&onKeyPress);
win.onMousePress(cast(void*)&onMousePress);
win.onMouseMove(cast(void*)&onMouseMove);
win.onWheel(cast(void*)&onWheel);
win.onResize(cast(void*)&onResize);
win.onFocusIn(cast(void*)&onFocusIn);
win.onPaint(cast(void*)&onPaint);
win.setMouseTracking(true);  // для onMouseMove без нажатия кнопки
```

> **AI:** QPainter, QPixmap, QImage, рисование на виджете? → попроси показать **AI_DRAWING.md**

---

## 11. Строки D ↔ Qt

```d
// Типизированные методы принимают D string напрямую (рекомендуется):
lbl.setText("Hello");
edit.setPlaceholderText("...");

// Явная конвертация (редко нужна):
void* qs = toQString("Привет");
// ... использовать ...
(cast(t_v__qp)pFunQt[22])(qs);   // освободить: pFunQt[22] = qteQString_free

// Qt → D (автоматически освобождает qs!):
string s = fromQString(someVoidPtr);  // НЕ использовать someVoidPtr после!

// Сигналы с текстом (invoke_s) — fromQString освобождает qs:
extern(C) void onText(void* dt, int n, void* qs) {
    string s = fromQString(qs);  // qs удаляется внутри fromQString
    // НЕ использовать qs после этой строки!
}

// string[] → QStringList:
void* qsl = toQStringList(["A", "B", "C"]);
combo.addItems(qsl);
freeQStringList(qsl);   // обязательно освободить!
```

---

## 12. QSettings

```d
// import: gen_qsettings
auto cfg = new QSettings("myapp.ini", 0);  // 0=IniFormat
cfg.setValue("width",  800);
cfg.setValue("height", 600);
cfg.setValue("name",   "World");

int    w    = cfg.value_i("width",   800);
string name = cfg.value_s("name",    "default");
bool   vis  = cfg.value_b("visible", true);
double d    = cfg.value_d("scale",   1.0);

// Двоичные данные:
cfg.setBytes("blob", cast(ubyte[])[1, 2, 3, 4]);
ubyte[] loaded = cfg.getBytes("blob");

cfg.sync();  // сохранить
```

> **AI:** QDate, QTime, QDateTime, виджеты дат/времени? → попроси показать **AI_DATETIME.md**

---

## 13. QProcess

```d
// import: gen_qprocess
auto proc = new QProcess();   // БЕЗ аргументов!
proc.start("cmd.exe", ["/C", "dir"]);

// Ожидать завершения (блокирующий):
bool ok = proc.waitForFinished(5000);  // мс, -1=бесконечно

// Читать stdout/stderr:
string out_ = proc.readStdoutText();   // НЕ readAllStandardOutput!
string err_ = proc.readStderrText();
int code    = proc.exitCode();

// Асинхронный вариант через QTimer polling:
__gshared QProcess g_proc;
extern(C) void onTick(void* dt, int n) {
    if (g_proc is null) return;
    string chunk = g_proc.readStdoutText();
    if (chunk.length > 0) output.append(chunk);
    if (g_proc.state() == 0) {  // 0=NotRunning
        timer.stop();
        g_proc = null;
    }
}

// Сигнал finished (прямой, не ESlot!):
extern(C) void onFinished(int exitCode, int exitStatus) { }
proc.connect_finished(cast(void*)&onFinished);

// Запись в stdin:
proc.writeText("input\n");
proc.closeWriteChannel();  // сигнал EOF
```

---

## 14. QShortcut

```d
// import: gen_qshortcut
auto sc = new QShortcut(w.getWH(), "Ctrl+Q");
sc.connect_activated(() {
    w.close();
});
// Или через extern(C) void delegate:
// sc.connect_activated(/* VoidClosure паттерн */);
```

> **AI:** QSystemTrayIcon, QCompleter, QClipboard, QDesktopWidget, QFileSystemWatcher подробно? → попроси показать **AI_TRAY_EXTRA.md**

---

## 15. QSS — стили

```d
// На виджете:
btn.setStyleSheet(
    "QPushButton { background:#3498db; color:white; border-radius:4px; padding:4px 12px; }"
    "QPushButton:hover    { background:#2980b9; }"
    "QPushButton:pressed  { background:#1a5276; }"
    "QPushButton:disabled { background:#bdc3c7; }"
);

// Глобально:
app.setStyleSheet(
    "QWidget     { font-family: Segoe UI; font-size: 10pt; }"
    "QPushButton { background:#2ecc71; color:white; border:none; padding:4px 10px; }"
    "QLineEdit   { border:1px solid #bdc3c7; border-radius:3px; padding:2px 6px; }"
    "QLineEdit:focus { border:2px solid #3498db; }"
);
```

---

## 16. Подводные камни

```
✅ ПРАВИЛА:
1. LoadQt() ПЕРЕД new QApplication() — всегда.
2. new Widget(cast(void*)null) — обязательный каст!
3. ESlot в __gshared — иначе GC удалит → crash при срабатывании сигнала.
4. invoke_i/invoke_b колбэки имеют int n вторым параметром:
     void cb(void* dt, int n, int value) — НЕ (void* dt, int value)!
5. Typed addWidget/setLayout/setCentralWidget → auto-disown.
   Void*-версии → disown() вручную.
6. fromQString(qs) удаляет qs. НЕ использовать qs после.
7. GC.collect() перед app.deleteApp() при использовании QThread.
8. НЕ вызывать UnloadQt() — ОС сама.
9. QAction.setShortcutStr("Ctrl+X") — НЕ setShortcut(string)!
10. QMessageBox/QFileDialog/QInputDialog: нужен import gen_qdialog тоже.
11. QProcess: readStdoutText() — НЕ readAllStandardOutput().
12. QProcess.connect_finished — прямой void* cb(int, int), не ESlot.
13. QFileSystemWatcher: после удаления файла снимает наблюдение.
     Переподписываться в connect_fileChanged.
14. QCompleter: после attachTo() Qt берёт ownership — НЕ delete вручную.
15. QScintilla требует два DLL: qte56_qscintilla.dll + qscintilla2_qt5.dll.
16. setWindowOpacity() работает ТОЛЬКО на top-level окнах, не на child.
17. .ui-формы Qt Designer: QForm.load(path) + findButton/findAction/...
    Builtin Qt-слоты из <connections> работают САМИ через QUiLoader
    (close, clear, setText, accept, reject, ...). Custom slots требуют
    ESlot (MOC в D не работает). См. AI_FORMS.md.

📦 ДОСТУПНЫЕ УТИЛИТЫ И РАСШИРЕНИЯ (попроси нужный AI_*.md для деталей):
- net_utils.d  — httpGet/httpPost (синхронный HTTP)          → AI_NETWORK_GUIDE.md
- curl_utils.d — CurlSession (fluent HTTP/HTTPS через libcurl) → AI_NETWORK_GUIDE.md
- json.d       — pure D JSON без Qt (parseJson, toJsonPretty) → AI_NETWORK_GUIDE.md
- QThread/QMutex/QWaitCondition/QSemaphore — gen_qthread      → AI_CORE.md
- QSqlDatabase/QSqlQuery (SQLite, ODBC)    — gen_qsql         → AI_SQL.md
- Wren-скриптинг, OLE/COM, Excel/Word      — wren_vm.d        → AI_WREN.md
- QPainter/QPixmap/QImage/QColor           — gen_qpainter     → AI_DRAWING.md
- QDate/QTime/QDateTime                    — gen_qdate        → AI_DATETIME.md
- QSystemTrayIcon/QCompleter/QClipboard    — отдельные DLL    → AI_TRAY_EXTRA.md
- QForm (.ui Qt Designer)                  — qte56_forms.d   → AI_FORMS.md
- tools/ui_tree/ui_tree.exe form.ui        — псевдограф просмотр .ui (виджеты+actions+connections)
```

---

*QTE56 AI_CONTEXT_GLM-47 — апрель 2026*
