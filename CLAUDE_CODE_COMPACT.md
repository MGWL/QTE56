# QTE56 Wizard Generator — Компактное задание

## Запуск

```bash
claude "Создай QTE56 Wizard Generator по этому заданию. Начни с main.d и mainwindow.d"
```

---

## Что делаем

D-приложение с GUI (QTE56), которое генерирует код других QTE56-приложений через визарды.

**Аналог:** MFC Application Wizard из Visual Studio.

---

## Структура (минимум для MVP)

```
wizard_generator/
├── main.d              # Entry point
├── mainwindow.d        # Главное окно  
├── wizard_state.d      # Состояние визарда
├── code_generator.d    # Генерация кода
├── templates.d         # Шаблоны кода
└── build.bat           # Сборка
```

---

## QTE56 быстрый справочник

### Компиляция
```bat
dmd -m32 -i main.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=wizard.exe
set PATH=dll;%PATH%
wizard.exe
```

### Базовый шаблон
```d
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qlayout;
import gen_qlabel;
import gen_qpushbutton;
// + нужные виджеты

__gshared ESlot g_slot;  // ОБЯЗАТЕЛЬНО __gshared

extern(C) void onClick(void* dt, int n, int checked) {
    // callback
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    
    // создать виджеты...
    
    app.exec();
    app.deleteApp();
}
```

### Ключевые импорты
```
QMainWindow     → gen_qmainwindow
QMenuBar/Menu   → gen_qmenubar, gen_qmenu, gen_qaction
QToolBar        → gen_qtoolbar
QStatusBar      → gen_qstatusbar
QDockWidget     → gen_qdockwidget
QSplitter       → gen_qsplitter
QTabWidget      → gen_qtabwidget
QStackedWidget  → gen_qstackedwidget
QTreeWidget     → gen_qtreewidget
QListWidget     → gen_qlistwidget
QTableWidget    → gen_qtablewidget
QTextEdit       → gen_qtextedit
QPlainTextEdit  → gen_qplaintextedit
QScintilla      → gen_qscintilla (+ qscintilla2_qt5.dll)
QLineEdit       → gen_qlineedit
QCheckBox       → gen_qcheckbox
QRadioButton    → gen_qradiobutton
QComboBox       → gen_qcombobox
QSpinBox        → gen_qspinbox
QGroupBox       → gen_qgroupbox
QScrollArea     → gen_qscrollarea
QFileDialog     → gen_qfiledialog
QSettings       → gen_qsettings
QTimer          → gen_qtimer
QClipboard      → gen_qclipboard
```

### Сигналы (ESlot)
```d
__gshared ESlot g_sl;
extern(C) void onClicked(void* dt, int n, int checked) { }

auto btn = new QPushButton(cast(void*)null);
g_sl = new ESlot(btn.getWH());
g_sl.set(cast(void*)&onClicked);
btn.connect_clicked(g_sl);
```

### Ownership
```d
// typed addWidget — auto disown
vbox.addWidget(label);  // НЕ трогать label после

// wrap для Qt-созданных объектов
auto mbar = QMenuBar.wrap(win.menuBar());
```

---

## UI приложения

```
┌────────────────────────────────────────────────────┐
│ QTE56 Wizard Generator                    [_][□][X]│
├────────────────────────────────────────────────────┤
│ File  Help                                         │
├────────────────────────────────────────────────────┤
│ ┌──────────┐ ┌───────────────────────────────────┐ │
│ │ Steps    │ │                                   │ │
│ │          │ │  [Step content area]              │ │
│ │ ● Step 1 │ │                                   │ │
│ │ ○ Step 2 │ │  Radio buttons, checkboxes,       │ │
│ │ ○ Step 3 │ │  text inputs для опций            │ │
│ │ ○ Step 4 │ │                                   │ │
│ │          │ │                                   │ │
│ └──────────┘ └───────────────────────────────────┘ │
│              ┌───────────────────────────────────┐ │
│              │ // Generated code preview         │ │
│              │ import qte56_core;                │ │
│              │ ...                               │ │
│              └───────────────────────────────────┘ │
├────────────────────────────────────────────────────┤
│ [< Back]                    [Next >]   [Generate]  │
└────────────────────────────────────────────────────┘
```

**Layout:**
- QMainWindow
- QSplitter (horizontal): левая панель (QListWidget) + правая (QSplitter vertical)
- Правая: QStackedWidget (шаги) + QPlainTextEdit (превью кода)
- Внизу: кнопки навигации

---

## Визард: Main Window Application (5 шагов)

### Step 1: Базовые настройки
```
Module name:     [________] (QLineEdit)
Window title:    [________] (QLineEdit)  
Window size:     [___] x [___] (QSpinBox x2)
```

### Step 2: Меню
```
☐ File menu
   ☐ New (Ctrl+N)
   ☐ Open (Ctrl+O)
   ☐ Save (Ctrl+S)
   ☐ Exit (Alt+F4)
   
☐ Edit menu
   ☐ Undo (Ctrl+Z)
   ☐ Cut/Copy/Paste
   
☐ Help menu
   ☐ About
```

### Step 3: Компоненты
```
☐ Toolbar
☐ Status bar
☐ Dock panel (left)
```

### Step 4: Центральный виджет
```
○ QTextEdit
○ QPlainTextEdit
○ QTreeWidget
○ QTableWidget
○ QTabWidget
```

### Step 5: Дополнительно
```
☐ QSettings (сохранение геометрии)
☐ QTimer
☐ QFileDialog support
```

---

## Модель данных (wizard_state.d)

```d
module wizard_state;

struct WizardState {
    // Step 1
    string moduleName = "myapp";
    string windowTitle = "My Application";
    int width = 800;
    int height = 600;
    
    // Step 2 - Menus
    bool menuFile = true;
    bool menuFileNew = true;
    bool menuFileOpen = true;
    bool menuFileSave = true;
    bool menuFileExit = true;
    
    bool menuEdit = false;
    bool menuEditUndo = false;
    bool menuEditClipboard = false;
    
    bool menuHelp = true;
    bool menuHelpAbout = true;
    
    // Step 3 - Components
    bool toolbar = false;
    bool statusbar = true;
    bool dockPanel = false;
    
    // Step 4 - Central widget
    int centralWidget = 0;  // 0=TextEdit, 1=PlainText, 2=Tree, 3=Table, 4=Tabs
    
    // Step 5 - Features
    bool useSettings = true;
    bool useTimer = false;
    bool useFileDialog = false;
}
```

---

## Генератор (code_generator.d)

```d
module code_generator;

import wizard_state;
import std.array : join;
import std.format : format;

string generateCode(WizardState s) {
    string[] imports;
    string[] globals;
    string[] init;
    string[] callbacks;
    
    // Базовые импорты
    imports ~= "import qte56_core;";
    imports ~= "import qte56_loader;";
    imports ~= "import gen_qcore;";
    imports ~= "import gen_qmainwindow;";
    imports ~= "import gen_qlayout;";
    
    // Меню
    if (s.menuFile || s.menuEdit || s.menuHelp) {
        imports ~= "import gen_qmenubar;";
        imports ~= "import gen_qmenu;";
        imports ~= "import gen_qaction;";
    }
    
    // Центральный виджет
    final switch (s.centralWidget) {
        case 0: imports ~= "import gen_qtextedit;"; break;
        case 1: imports ~= "import gen_qplaintextedit;"; break;
        case 2: imports ~= "import gen_qtreewidget;"; break;
        case 3: imports ~= "import gen_qtablewidget;"; break;
        case 4: imports ~= "import gen_qtabwidget;"; break;
    }
    
    if (s.toolbar) imports ~= "import gen_qtoolbar;";
    if (s.statusbar) imports ~= "import gen_qstatusbar;";
    if (s.dockPanel) imports ~= "import gen_qdockwidget;";
    if (s.useSettings) imports ~= "import gen_qsettings;";
    if (s.useTimer) imports ~= "import gen_qtimer;";
    if (s.useFileDialog) imports ~= "import gen_qfiledialog;";
    
    // Globals для slots
    if (s.menuFileNew) {
        globals ~= "__gshared ESlot g_slNew;";
        callbacks ~= generateCallback("onNew", "New clicked");
    }
    // ... аналогично для других actions
    
    // Main функция
    string mainBody = generateMainBody(s);
    
    return format(q{
/**
 * %s
 * Generated by QTE56 Wizard Generator
 */
module %s;

%s

%s

%s

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    
%s
    
    app.exec();
    app.deleteApp();
}
}, s.windowTitle, s.moduleName, 
   imports.join("\n"), 
   globals.join("\n"),
   callbacks.join("\n\n"),
   mainBody);
}

string generateCallback(string name, string msg) {
    return format(q{
extern(C) void %s(void* dt, int n, int checked) {
    import std.stdio : writeln;
    writeln("%s");
}}, name, msg);
}

string generateMainBody(WizardState s) {
    string[] lines;
    
    lines ~= format(`    auto win = new QMainWindow(cast(void*)null);`);
    lines ~= format(`    win.setWindowTitle("%s");`, s.windowTitle);
    lines ~= format(`    win.resize(%d, %d);`, s.width, s.height);
    lines ~= "";
    
    // Меню
    if (s.menuFile || s.menuEdit || s.menuHelp) {
        lines ~= `    auto menuBar = QMenuBar.wrap(win.menuBar());`;
        
        if (s.menuFile) {
            lines ~= `    auto menuFile = new QMenu(cast(void*)null);`;
            lines ~= `    menuFile.setTitle("File");`;
            // actions...
            lines ~= `    menuBar.addMenu(menuFile);`;
        }
    }
    
    // Central widget
    string cwVar = "central";
    final switch (s.centralWidget) {
        case 0: lines ~= `    auto central = new QTextEdit(cast(void*)null);`; break;
        case 1: lines ~= `    auto central = new QPlainTextEdit(cast(void*)null);`; break;
        case 2: lines ~= `    auto central = new QTreeWidget(cast(void*)null);`; break;
        case 3: lines ~= `    auto central = new QTableWidget(cast(void*)null);`; break;
        case 4: lines ~= `    auto central = new QTabWidget(cast(void*)null);`; break;
    }
    lines ~= `    win.setCentralWidget(central);`;
    
    // Status bar
    if (s.statusbar) {
        lines ~= `    win.statusBar().showMessage("Ready");`;
    }
    
    // Settings load
    if (s.useSettings) {
        lines ~= "";
        lines ~= `    auto settings = new QSettings("app.ini", 0);`;
        lines ~= `    int w = settings.value_i("width", 800);`;
        lines ~= `    int h = settings.value_i("height", 600);`;
        lines ~= `    win.resize(w, h);`;
    }
    
    lines ~= "";
    lines ~= `    win.show();`;
    
    return lines.join("\n");
}
```

---

## mainwindow.d (UI)

```d
module mainwindow;

import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qmainwindow;
import gen_qwidget;
import gen_qlayout;
import gen_qlabel;
import gen_qpushbutton;
import gen_qlistwidget;
import gen_qsplitter;
import gen_qstackedwidget;
import gen_qplaintextedit;
import gen_qlineedit;
import gen_qcheckbox;
import gen_qspinbox;
import gen_qradiobutton;
import gen_qgroupbox;
import gen_qmenubar;
import gen_qmenu;
import gen_qaction;
import gen_qfiledialog;
import gen_qclipboard;

import wizard_state;
import code_generator;

import std.conv : to;

// Глобальные slots
__gshared ESlot g_slStepChanged;
__gshared ESlot g_slBack;
__gshared ESlot g_slNext;
__gshared ESlot g_slGenerate;
__gshared ESlot[20] g_slOptions;  // для чекбоксов

// Глобальное состояние
__gshared WizardState g_state;
__gshared int g_currentStep = 0;
__gshared QStackedWidget g_stack;
__gshared QPlainTextEdit g_preview;
__gshared QListWidget g_stepList;
__gshared QPushButton g_btnBack;
__gshared QPushButton g_btnNext;

// Виджеты для биндинга
__gshared QLineEdit g_editModuleName;
__gshared QLineEdit g_editWindowTitle;
__gshared QSpinBox g_spinWidth;
__gshared QSpinBox g_spinHeight;
__gshared QCheckBox[20] g_checks;
__gshared QRadioButton[5] g_radios;

void createMainWindow() {
    auto win = new QMainWindow(cast(void*)null);
    win.setWindowTitle("QTE56 Wizard Generator");
    win.resize(900, 700);
    
    // Menu
    auto menuBar = QMenuBar.wrap(win.menuBar());
    auto menuFile = new QMenu(cast(void*)null);
    menuFile.setTitle("File");
    // ... add actions
    menuBar.addMenu(menuFile);
    
    // Central widget - main splitter
    auto mainSplitter = new QSplitter(cast(void*)null);
    mainSplitter.setOrientation(1);  // Horizontal
    
    // Left panel - step list
    g_stepList = new QListWidget(cast(void*)null);
    g_stepList.addItem("1. Basic Settings");
    g_stepList.addItem("2. Menus");
    g_stepList.addItem("3. Components");
    g_stepList.addItem("4. Central Widget");
    g_stepList.addItem("5. Features");
    g_stepList.setCurrentRow(0);
    mainSplitter.addWidget(g_stepList);
    
    // Right panel - vertical splitter
    auto rightSplitter = new QSplitter(cast(void*)null);
    rightSplitter.setOrientation(2);  // Vertical
    
    // Stacked widget for steps
    g_stack = new QStackedWidget(cast(void*)null);
    g_stack.addWidget(createStep1());
    g_stack.addWidget(createStep2());
    g_stack.addWidget(createStep3());
    g_stack.addWidget(createStep4());
    g_stack.addWidget(createStep5());
    rightSplitter.addWidget(g_stack);
    
    // Code preview
    g_preview = new QPlainTextEdit(cast(void*)null);
    g_preview.setReadOnly(true);
    g_preview.setPlaceholderText("Generated code will appear here...");
    rightSplitter.addWidget(g_preview);
    
    mainSplitter.addWidget(rightSplitter);
    mainSplitter.setSizes([200, 700]);
    
    win.setCentralWidget(mainSplitter);
    
    // Bottom buttons (через status bar или отдельный виджет)
    auto statusBar = win.statusBar();
    
    g_btnBack = new QPushButton(cast(void*)null);
    g_btnBack.setText("< Back");
    g_btnBack.setEnabled(false);
    
    g_btnNext = new QPushButton(cast(void*)null);
    g_btnNext.setText("Next >");
    
    auto btnGenerate = new QPushButton(cast(void*)null);
    btnGenerate.setText("Generate");
    
    statusBar.addPermanentWidget(g_btnBack);
    statusBar.addPermanentWidget(g_btnNext);
    statusBar.addPermanentWidget(btnGenerate);
    
    // Connect signals
    connectSignals();
    
    // Initial preview
    updatePreview();
    
    win.show();
}

QWidget createStep1() {
    auto page = new QWidget(cast(void*)null);
    auto layout = new QVBoxLayout(cast(void*)null);
    
    auto lbl1 = new QLabel(cast(void*)null);
    lbl1.setText("Module name:");
    layout.addWidget(lbl1);
    
    g_editModuleName = new QLineEdit(cast(void*)null);
    g_editModuleName.setText("myapp");
    layout.addWidget(g_editModuleName);
    
    auto lbl2 = new QLabel(cast(void*)null);
    lbl2.setText("Window title:");
    layout.addWidget(lbl2);
    
    g_editWindowTitle = new QLineEdit(cast(void*)null);
    g_editWindowTitle.setText("My Application");
    layout.addWidget(g_editWindowTitle);
    
    auto lbl3 = new QLabel(cast(void*)null);
    lbl3.setText("Window size:");
    layout.addWidget(lbl3);
    
    auto sizeLayout = new QHBoxLayout(cast(void*)null);
    g_spinWidth = new QSpinBox(cast(void*)null);
    g_spinWidth.setRange(200, 2000);
    g_spinWidth.setValue(800);
    sizeLayout.addWidget(g_spinWidth);
    
    auto lblX = new QLabel(cast(void*)null);
    lblX.setText(" x ");
    sizeLayout.addWidget(lblX);
    
    g_spinHeight = new QSpinBox(cast(void*)null);
    g_spinHeight.setRange(200, 2000);
    g_spinHeight.setValue(600);
    sizeLayout.addWidget(g_spinHeight);
    sizeLayout.addStretch(1);
    
    layout.addLayout(sizeLayout);
    layout.addStretch(1);
    
    page.setLayout(layout);
    return page;
}

QWidget createStep2() {
    auto page = new QWidget(cast(void*)null);
    auto layout = new QVBoxLayout(cast(void*)null);
    
    // File menu group
    auto grpFile = new QGroupBox(cast(void*)null);
    grpFile.setTitle("File Menu");
    grpFile.setCheckable(true);
    grpFile.setChecked(true);
    auto fileLayout = new QVBoxLayout(cast(void*)null);
    
    g_checks[0] = new QCheckBox(cast(void*)null); g_checks[0].setText("New (Ctrl+N)"); g_checks[0].setChecked(true);
    g_checks[1] = new QCheckBox(cast(void*)null); g_checks[1].setText("Open (Ctrl+O)"); g_checks[1].setChecked(true);
    g_checks[2] = new QCheckBox(cast(void*)null); g_checks[2].setText("Save (Ctrl+S)"); g_checks[2].setChecked(true);
    g_checks[3] = new QCheckBox(cast(void*)null); g_checks[3].setText("Exit (Alt+F4)"); g_checks[3].setChecked(true);
    
    fileLayout.addWidget(g_checks[0]);
    fileLayout.addWidget(g_checks[1]);
    fileLayout.addWidget(g_checks[2]);
    fileLayout.addWidget(g_checks[3]);
    grpFile.setLayout(fileLayout);
    layout.addWidget(grpFile);
    
    // Edit menu group
    auto grpEdit = new QGroupBox(cast(void*)null);
    grpEdit.setTitle("Edit Menu");
    grpEdit.setCheckable(true);
    grpEdit.setChecked(false);
    auto editLayout = new QVBoxLayout(cast(void*)null);
    
    g_checks[4] = new QCheckBox(cast(void*)null); g_checks[4].setText("Undo (Ctrl+Z)");
    g_checks[5] = new QCheckBox(cast(void*)null); g_checks[5].setText("Cut/Copy/Paste");
    
    editLayout.addWidget(g_checks[4]);
    editLayout.addWidget(g_checks[5]);
    grpEdit.setLayout(editLayout);
    layout.addWidget(grpEdit);
    
    // Help menu group
    auto grpHelp = new QGroupBox(cast(void*)null);
    grpHelp.setTitle("Help Menu");
    grpHelp.setCheckable(true);
    grpHelp.setChecked(true);
    auto helpLayout = new QVBoxLayout(cast(void*)null);
    
    g_checks[6] = new QCheckBox(cast(void*)null); g_checks[6].setText("About"); g_checks[6].setChecked(true);
    
    helpLayout.addWidget(g_checks[6]);
    grpHelp.setLayout(helpLayout);
    layout.addWidget(grpHelp);
    
    layout.addStretch(1);
    page.setLayout(layout);
    return page;
}

QWidget createStep3() {
    auto page = new QWidget(cast(void*)null);
    auto layout = new QVBoxLayout(cast(void*)null);
    
    auto lbl = new QLabel(cast(void*)null);
    lbl.setText("Additional components:");
    layout.addWidget(lbl);
    
    g_checks[10] = new QCheckBox(cast(void*)null); g_checks[10].setText("Toolbar");
    g_checks[11] = new QCheckBox(cast(void*)null); g_checks[11].setText("Status bar"); g_checks[11].setChecked(true);
    g_checks[12] = new QCheckBox(cast(void*)null); g_checks[12].setText("Dock panel (left)");
    
    layout.addWidget(g_checks[10]);
    layout.addWidget(g_checks[11]);
    layout.addWidget(g_checks[12]);
    layout.addStretch(1);
    
    page.setLayout(layout);
    return page;
}

QWidget createStep4() {
    auto page = new QWidget(cast(void*)null);
    auto layout = new QVBoxLayout(cast(void*)null);
    
    auto lbl = new QLabel(cast(void*)null);
    lbl.setText("Central widget type:");
    layout.addWidget(lbl);
    
    g_radios[0] = new QRadioButton(cast(void*)null); g_radios[0].setText("QTextEdit (rich text)"); g_radios[0].setChecked(true);
    g_radios[1] = new QRadioButton(cast(void*)null); g_radios[1].setText("QPlainTextEdit (plain text)");
    g_radios[2] = new QRadioButton(cast(void*)null); g_radios[2].setText("QTreeWidget");
    g_radios[3] = new QRadioButton(cast(void*)null); g_radios[3].setText("QTableWidget");
    g_radios[4] = new QRadioButton(cast(void*)null); g_radios[4].setText("QTabWidget");
    
    layout.addWidget(g_radios[0]);
    layout.addWidget(g_radios[1]);
    layout.addWidget(g_radios[2]);
    layout.addWidget(g_radios[3]);
    layout.addWidget(g_radios[4]);
    layout.addStretch(1);
    
    page.setLayout(layout);
    return page;
}

QWidget createStep5() {
    auto page = new QWidget(cast(void*)null);
    auto layout = new QVBoxLayout(cast(void*)null);
    
    auto lbl = new QLabel(cast(void*)null);
    lbl.setText("Additional features:");
    layout.addWidget(lbl);
    
    g_checks[15] = new QCheckBox(cast(void*)null); g_checks[15].setText("QSettings (save window geometry)"); g_checks[15].setChecked(true);
    g_checks[16] = new QCheckBox(cast(void*)null); g_checks[16].setText("QTimer support");
    g_checks[17] = new QCheckBox(cast(void*)null); g_checks[17].setText("QFileDialog support");
    
    layout.addWidget(g_checks[15]);
    layout.addWidget(g_checks[16]);
    layout.addWidget(g_checks[17]);
    layout.addStretch(1);
    
    page.setLayout(layout);
    return page;
}

void connectSignals() {
    // Step list selection
    g_slStepChanged = new ESlot(g_stepList.getWH());
    g_slStepChanged.set(cast(void*)&onStepChanged);
    g_stepList.onCurrentRowChanged(cast(void*)&onStepChanged);
    
    // Back button
    g_slBack = new ESlot(g_btnBack.getWH());
    g_slBack.set(cast(void*)&onBack);
    g_btnBack.connect_clicked(g_slBack);
    
    // Next button
    g_slNext = new ESlot(g_btnNext.getWH());
    g_slNext.set(cast(void*)&onNext);
    g_btnNext.connect_clicked(g_slNext);
}

extern(C) void onStepChanged(void* dt, int row) {
    g_currentStep = row;
    g_stack.setCurrentIndex(row);
    g_btnBack.setEnabled(row > 0);
    g_btnNext.setEnabled(row < 4);
    updatePreview();
}

extern(C) void onBack(void* dt, int n, int c) {
    if (g_currentStep > 0) {
        g_currentStep--;
        g_stepList.setCurrentRow(g_currentStep);
        g_stack.setCurrentIndex(g_currentStep);
        g_btnBack.setEnabled(g_currentStep > 0);
        g_btnNext.setEnabled(true);
    }
}

extern(C) void onNext(void* dt, int n, int c) {
    if (g_currentStep < 4) {
        g_currentStep++;
        g_stepList.setCurrentRow(g_currentStep);
        g_stack.setCurrentIndex(g_currentStep);
        g_btnBack.setEnabled(true);
        g_btnNext.setEnabled(g_currentStep < 4);
    }
}

void collectState() {
    // Step 1
    g_state.moduleName = g_editModuleName.text();
    g_state.windowTitle = g_editWindowTitle.text();
    g_state.width = g_spinWidth.value();
    g_state.height = g_spinHeight.value();
    
    // Step 2
    g_state.menuFileNew = g_checks[0].isChecked();
    g_state.menuFileOpen = g_checks[1].isChecked();
    g_state.menuFileSave = g_checks[2].isChecked();
    g_state.menuFileExit = g_checks[3].isChecked();
    g_state.menuEditUndo = g_checks[4].isChecked();
    g_state.menuEditClipboard = g_checks[5].isChecked();
    g_state.menuHelpAbout = g_checks[6].isChecked();
    
    // Step 3
    g_state.toolbar = g_checks[10].isChecked();
    g_state.statusbar = g_checks[11].isChecked();
    g_state.dockPanel = g_checks[12].isChecked();
    
    // Step 4
    for (int i = 0; i < 5; i++) {
        if (g_radios[i].isChecked()) {
            g_state.centralWidget = i;
            break;
        }
    }
    
    // Step 5
    g_state.useSettings = g_checks[15].isChecked();
    g_state.useTimer = g_checks[16].isChecked();
    g_state.useFileDialog = g_checks[17].isChecked();
}

void updatePreview() {
    collectState();
    string code = generateCode(g_state);
    g_preview.setPlainText(code);
}
```

---

## main.d

```d
module main;

import qte56_core;
import qte56_loader;
import gen_qcore;

import mainwindow;

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    
    createMainWindow();
    
    app.exec();
    app.deleteApp();
}
```

---

## build.bat

```bat
@echo off
set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt5_13_2\5.13.2\mingw73_32\plugins\platforms

dmd -m32 -i main.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=wizard.exe

if %ERRORLEVEL% == 0 (
    echo Build successful!
    wizard.exe
) else (
    echo Build failed!
    pause
)
```

---

## Задачи для Claude Code

1. **Создай файлы** по структуре выше
2. **Допиши code_generator.d** — полная генерация меню, toolbar, dock
3. **Добавь сигналы** для всех чекбоксов чтобы preview обновлялся
4. **Добавь кнопку Generate** — сохранение в файл через QFileDialog
5. **Добавь Copy** — копирование кода в буфер обмена

---

## Критерии готовности

- [ ] Приложение компилируется и запускается
- [ ] 5 шагов визарда с переключением
- [ ] Все опции влияют на генерируемый код
- [ ] Превью кода обновляется при изменениях
- [ ] Кнопка Generate сохраняет .d файл
- [ ] Сгенерированный код компилируется
