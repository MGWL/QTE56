# QTE56 Wizard Generator — Задание для Claude Code

## Команда запуска

```bash
claude code "Создай D-приложение QTE56 Wizard Generator согласно этому заданию. Читай файлы AI_CONTEXT.md для API QTE56 и QTE56_WIZARD_SPECIFICATION.md для спецификации визардов. Генерируй код итеративно, начиная с ядра."
```

---

## 1. Обзор проекта

### Цель
Создать desktop-приложение на D + QTE56, которое через систему визардов генерирует готовый исходный код QTE56-приложений.

### Аналоги
- MFC Application Wizard (Visual Studio)
- Qt Creator New Project Wizard
- JetBrains Project Wizards

### Результат работы приложения
Пользователь проходит визард → получает готовый `.d` файл (или набор файлов), который компилируется и запускается.

---

## 2. Архитектура приложения

### 2.1 Структура файлов

```
qte56_wizard_generator/
├── src/
│   ├── main.d                 # Entry point
│   ├── app.d                  # WizardApp class
│   │
│   ├── ui/
│   │   ├── mainwindow.d       # Главное окно
│   │   ├── wizard_panel.d     # Панель визарда (шаги)
│   │   ├── preview_panel.d    # Превью кода
│   │   ├── welcome_page.d     # Стартовая страница
│   │   └── widgets/
│   │       ├── option_widgets.d   # Виджеты для опций
│   │       ├── field_editor.d     # Редактор полей форм
│   │       └── tree_selector.d    # Выбор в дереве
│   │
│   ├── wizards/
│   │   ├── wizard_base.d      # Базовый класс визарда
│   │   ├── wizard_registry.d  # Реестр всех визардов
│   │   │
│   │   ├── app/
│   │   │   ├── mainwindow_wizard.d
│   │   │   ├── dialog_wizard.d
│   │   │   ├── tray_wizard.d
│   │   │   ├── console_gui_wizard.d
│   │   │   └── multiwindow_wizard.d
│   │   │
│   │   ├── widget/
│   │   │   ├── dataview_wizard.d
│   │   │   ├── texteditor_wizard.d
│   │   │   └── form_wizard.d
│   │   │
│   │   └── feature/
│   │       ├── network_wizard.d
│   │       ├── threading_wizard.d
│   │       ├── fileops_wizard.d
│   │       ├── process_wizard.d
│   │       └── timer_wizard.d
│   │
│   ├── codegen/
│   │   ├── generator.d        # Главный генератор
│   │   ├── templates.d        # Шаблоны кода
│   │   ├── imports_resolver.d # Вычисление импортов
│   │   ├── code_formatter.d   # Форматирование
│   │   └── snippets/
│   │       ├── app_snippets.d
│   │       ├── menu_snippets.d
│   │       ├── widget_snippets.d
│   │       └── signal_snippets.d
│   │
│   ├── model/
│   │   ├── project_config.d   # Конфигурация проекта
│   │   ├── wizard_state.d     # Состояние визарда
│   │   ├── step_definition.d  # Определение шага
│   │   └── option_types.d     # Типы опций
│   │
│   └── core/
│       ├── settings.d         # QSettings обёртка
│       ├── recent_projects.d  # Недавние проекты
│       └── utils.d            # Утилиты
│
├── resources/
│   ├── icons/                 # Иконки приложения
│   ├── templates/             # Внешние шаблоны (опционально)
│   └── presets/               # JSON-файлы пресетов
│
├── build.bat                  # Скрипт сборки Windows
├── build.sh                   # Скрипт сборки Linux
└── README.md
```

### 2.2 Главное окно (QMainWindow)

```
┌─────────────────────────────────────────────────────────────────────┐
│  QTE56 Wizard Generator                                    [_][□][X]│
├─────────────────────────────────────────────────────────────────────┤
│  File   Edit   View   Tools   Help                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────┐  ┌─────────────────────────────────────────┐  │
│  │ WIZARD STEPS    │  │                                         │  │
│  │                 │  │     [Welcome / Step Content /           │  │
│  │ ● Step 1       │  │      Preview depending on mode]         │  │
│  │ ○ Step 2       │  │                                         │  │
│  │ ○ Step 3       │  │                                         │  │
│  │ ○ ...          │  │                                         │  │
│  │ ○ Summary      │  │                                         │  │
│  │                 │  │                                         │  │
│  │─────────────────│  │                                         │  │
│  │ WIZARDS        │  │                                         │  │
│  │                 │  │                                         │  │
│  │ ▼ Applications │  │                                         │  │
│  │   Main Window  │  │                                         │  │
│  │   Dialog       │  │                                         │  │
│  │   Tray App     │  │                                         │  │
│  │ ▼ Widgets      │  │                                         │  │
│  │   Data View    │  │                                         │  │
│  │   Text Editor  │  │                                         │  │
│  │ ▼ Features     │  │                                         │  │
│  │   Network      │  │                                         │  │
│  │   Threading    │  │                                         │  │
│  │                 │  │                                         │  │
│  └─────────────────┘  └─────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ CODE PREVIEW (QScintilla)                            [Copy] │   │
│  │                                                             │   │
│  │ import qte56_core;                                          │   │
│  │ import qte56_loader;                                        │   │
│  │ ...                                                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  [< Back]                              [Next >]  [Generate]         │
├─────────────────────────────────────────────────────────────────────┤
│  Step 3 of 12: Menu Configuration                    Ready          │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.3 Layout структура

```d
// Главный layout
QSplitter (Horizontal)
├── QSplitter (Vertical) [Left panel, 250px]
│   ├── QWidget [Steps panel]
│   │   └── QVBoxLayout
│   │       ├── QLabel "WIZARD STEPS"
│   │       └── QListWidget [step list]
│   │
│   └── QWidget [Wizards tree]
│       └── QVBoxLayout
│           ├── QLabel "WIZARDS"
│           └── QTreeWidget [wizard categories]
│
└── QSplitter (Vertical) [Right panel, stretch]
    ├── QStackedWidget [Main content]
    │   ├── WelcomePage
    │   ├── StepPage (dynamic)
    │   └── SummaryPage
    │
    └── QWidget [Code preview]
        └── QVBoxLayout
            ├── QHBoxLayout [header]
            │   ├── QLabel "CODE PREVIEW"
            │   └── QPushButton "Copy"
            └── QScintilla [code editor, read-only]
```

---

## 3. Модель данных

### 3.1 Типы опций

```d
// option_types.d

enum OptionType {
    SingleChoice,    // Radio buttons (один из многих)
    MultiChoice,     // Checkboxes (несколько из многих)
    Toggle,          // Один checkbox (вкл/выкл)
    Text,            // QLineEdit
    Number,          // QSpinBox
    Path,            // QLineEdit + Browse button
    Color,           // Color picker
    KeySequence,     // Shortcut input
    Custom           // Custom widget
}

struct OptionDefinition {
    string id;              // "menu_file_new"
    string label;           // "New (Ctrl+N)"
    string description;     // Tooltip/help text
    OptionType type;
    Variant defaultValue;
    Variant[] choices;      // Для Single/MultiChoice
    string[] dependsOn;     // ID опций от которых зависит
    string condition;       // "parent.type == 'MDI'"
}

struct StepDefinition {
    string id;              // "step_menu_file"
    string title;           // "File Menu"
    string description;     // Описание шага
    OptionDefinition[] options;
    string[] requiredOptions;  // Обязательные опции
}

struct WizardDefinition {
    string id;              // "mainwindow_wizard"
    string name;            // "Main Window Application"
    string description;
    string category;        // "Applications"
    string icon;            // Путь к иконке
    StepDefinition[] steps;
    string[] features;      // Совместимые feature wizards
}
```

### 3.2 Состояние визарда

```d
// wizard_state.d

class WizardState {
    string wizardId;
    int currentStep;
    Variant[string] values;      // option_id → value
    bool[string] enabledSteps;   // step_id → enabled
    
    // Методы
    void setValue(string optionId, Variant value);
    Variant getValue(string optionId);
    bool isStepEnabled(string stepId);
    void recalculateDependencies();
    ProjectConfig toProjectConfig();
}

class ProjectConfig {
    // Мета
    string projectName;
    string moduleName;
    string outputPath;
    
    // Структура
    bool singleFile;
    string[] additionalFiles;
    
    // Все значения визардов
    Variant[string] allValues;
    
    // Вычисленные зависимости
    string[] requiredImports;
    string[] requiredDlls;
    string compileCommand;
}
```

---

## 4. Система генерации кода

### 4.1 Шаблоны (templates.d)

```d
// Использовать string interpolation или простую замену

enum CodeTemplate {
    // Базовые структуры
    AppMain = q{
// {HEADER_COMMENT}
module {MODULE_NAME};

{IMPORTS}

{GLOBAL_SLOTS}

{CALLBACKS}

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    
{INIT_CODE}
    
    app.exec();
    app.deleteApp();
}
},

    // QMainWindow
    MainWindowClass = q{
class {CLASS_NAME} {
    QMainWindow win;
    {MEMBER_WIDGETS}
    
    this() {
        win = new QMainWindow(cast(void*)null);
        win.setWindowTitle("{WINDOW_TITLE}");
        win.resize({WIDTH}, {HEIGHT});
        
        {INIT_MENUS}
        {INIT_TOOLBARS}
        {INIT_DOCKS}
        {INIT_CENTRAL}
        {INIT_STATUSBAR}
        
        win.show();
    }
    
    {METHODS}
}
},

    // Menu
    MenuBar = q{
auto menuBar = QMenuBar.wrap(win.menuBar());
{MENUS}
},

    MenuItem = q{
auto {VAR_NAME} = new QAction(cast(void*)null);
{VAR_NAME}.setText("{TEXT}");
{SHORTCUT_LINE}
{ICON_LINE}
{MENU_VAR}.addAction({VAR_NAME});
{SIGNAL_CONNECTION}
},

    // И т.д. для всех компонентов
}
```

### 4.2 Генератор (generator.d)

```d
class CodeGenerator {
    ProjectConfig config;
    string[] codeLines;
    string[string] generatedSnippets;
    
    string generate() {
        // 1. Собрать все части
        generateImports();
        generateGlobalSlots();
        generateCallbacks();
        generateMainFunction();
        
        // 2. Собрать в один файл
        return assembleCode();
    }
    
    void generateImports() {
        // Анализ config → список импортов
        // Автоматическое разрешение зависимостей
    }
    
    void generateMainFunction() {
        // Вставка инициализации в правильном порядке
    }
    
    // Helpers
    string resolveTemplate(CodeTemplate tpl, string[string] vars);
    string generateMenu(MenuConfig menu);
    string generateToolbar(ToolbarConfig toolbar);
    string generateDock(DockConfig dock);
    // ...
}
```

### 4.3 Resolver импортов (imports_resolver.d)

```d
// Таблица зависимостей компонент → импорты
immutable string[][string] componentImports = [
    "QMainWindow": ["gen_qmainwindow"],
    "QMenuBar": ["gen_qmenubar"],
    "QMenu": ["gen_qmenu"],
    "QAction": ["gen_qaction"],
    "QToolBar": ["gen_qtoolbar"],
    "QStatusBar": ["gen_qstatusbar"],
    "QDockWidget": ["gen_qdockwidget"],
    "QTreeWidget": ["gen_qtreewidget", "gen_qtreeview", "gen_qabstractitemview"],
    "QTableWidget": ["gen_qtablewidget", "gen_qtableview", "gen_qabstractitemview"],
    "QScintilla": ["gen_qscintilla"],
    "QTimer": ["gen_qtimer"],
    "QThread": ["gen_qthread"],
    "QSettings": ["gen_qsettings"],
    "QFileDialog": ["gen_qfiledialog"],
    "QSystemTrayIcon": ["gen_qsystemtrayicon"],
    // ... все компоненты из AI_CONTEXT.md
];

// DLL зависимости
immutable string[][string] componentDlls = [
    "QMainWindow": ["qte56_mainwin"],
    "QDialog": ["qte56_dialogs"],
    "QScintilla": ["qte56_qscintilla", "qscintilla2_qt5"],
    "QThread": ["qte56_thread"],
    // ...
];

class ImportsResolver {
    string[] resolveImports(string[] usedComponents);
    string[] resolveDlls(string[] usedComponents);
    string generateCompileCommand(string moduleName, string[] dlls);
}
```

---

## 5. UI компоненты

### 5.1 Виджеты для опций (option_widgets.d)

```d
// Фабрика виджетов для разных типов опций

interface IOptionWidget {
    void setValue(Variant value);
    Variant getValue();
    void setEnabled(bool enabled);
    QWidget getWidget();
    void connectChanged(void delegate() callback);
}

class SingleChoiceWidget : IOptionWidget {
    // QGroupBox с QRadioButton
}

class MultiChoiceWidget : IOptionWidget {
    // Список QCheckBox или QListWidget с checkboxes
}

class ToggleWidget : IOptionWidget {
    // Один QCheckBox
}

class TextWidget : IOptionWidget {
    // QLineEdit с опциональным placeholder
}

class PathWidget : IOptionWidget {
    // QLineEdit + QPushButton "Browse"
}

class ColorWidget : IOptionWidget {
    // QPushButton с цветным фоном → QColorDialog
}

class ShortcutWidget : IOptionWidget {
    // QKeySequenceEdit или кастомный input
}

// Фабрика
IOptionWidget createOptionWidget(OptionDefinition def) {
    final switch (def.type) {
        case OptionType.SingleChoice: return new SingleChoiceWidget(def);
        case OptionType.MultiChoice: return new MultiChoiceWidget(def);
        // ...
    }
}
```

### 5.2 Step Page (wizard_panel.d)

```d
class StepPage {
    QWidget container;
    QScrollArea scrollArea;
    QVBoxLayout layout;
    IOptionWidget[] optionWidgets;
    
    void loadStep(StepDefinition step, WizardState state) {
        // Очистить текущие виджеты
        clearWidgets();
        
        // Создать виджеты для каждой опции
        foreach (opt; step.options) {
            auto widget = createOptionWidget(opt);
            widget.setValue(state.getValue(opt.id));
            widget.connectChanged(&onOptionChanged);
            
            // Добавить label + widget
            addOptionRow(opt.label, widget, opt.description);
            
            optionWidgets ~= widget;
        }
        
        // Применить зависимости (enable/disable)
        updateDependencies(state);
    }
    
    void onOptionChanged() {
        // Обновить state
        // Пересчитать зависимости
        // Обновить превью кода
    }
}
```

### 5.3 Code Preview (preview_panel.d)

```d
class CodePreviewPanel {
    QScintilla editor;
    QPushButton copyButton;
    CodeGenerator generator;
    
    this() {
        editor = new QScintilla(cast(void*)null);
        editor.setReadOnly(true);
        
        // Настройка подсветки D
        setupDLexer();
        
        // Кнопка копирования
        copyButton = new QPushButton(cast(void*)null);
        copyButton.setText("Copy");
        // connect clicked → copyToClipboard
    }
    
    void updatePreview(ProjectConfig config) {
        string code = generator.generate(config);
        editor.setText(code);
    }
    
    void copyToClipboard() {
        auto clipboard = QClipboard.instance();
        clipboard.setText(editor.text());
    }
    
    void setupDLexer() {
        // QScintilla lexer для D
        // Подсветка ключевых слов, строк, комментариев
    }
}
```

---

## 6. Определения визардов

### 6.1 Main Window Wizard (пример)

```d
// mainwindow_wizard.d

WizardDefinition mainWindowWizard = {
    id: "mainwindow",
    name: "Main Window Application",
    description: "Full-featured application with menus, toolbars, and dock panels",
    category: "Applications",
    icon: ":/icons/mainwindow.png",
    
    steps: [
        // Step 1: Document Architecture
        {
            id: "architecture",
            title: "Document Architecture",
            description: "Choose how your application handles documents",
            options: [
                {
                    id: "doc_type",
                    label: "Application Type",
                    type: OptionType.SingleChoice,
                    defaultValue: "sdi",
                    choices: [
                        Choice("sdi", "SDI (Single Document)", "One window, one document"),
                        Choice("mdi", "MDI (Multiple Documents)", "Multiple documents in child windows"),
                        Choice("tdi", "TDI (Tabbed Documents)", "Documents in tabs"),
                        Choice("workspace", "Workspace", "Dashboard without documents"),
                    ]
                }
            ]
        },
        
        // Step 2: File Menu
        {
            id: "menu_file",
            title: "File Menu",
            description: "Configure File menu actions",
            options: [
                {
                    id: "menu_file_enabled",
                    label: "Include File menu",
                    type: OptionType.Toggle,
                    defaultValue: true
                },
                {
                    id: "menu_file_new",
                    label: "New",
                    type: OptionType.Toggle,
                    defaultValue: true,
                    dependsOn: ["menu_file_enabled"]
                },
                {
                    id: "menu_file_new_type",
                    label: "New action type",
                    type: OptionType.SingleChoice,
                    defaultValue: "simple",
                    choices: [
                        Choice("simple", "Simple (Ctrl+N)"),
                        Choice("submenu", "Submenu (document types)"),
                        Choice("template", "From template"),
                    ],
                    dependsOn: ["menu_file_new"]
                },
                // ... остальные опции File меню
            ]
        },
        
        // ... остальные шаги (см. QTE56_WIZARD_SPECIFICATION.md)
    ],
    
    features: ["network", "threading", "fileops", "timer"]
};
```

### 6.2 Реестр визардов (wizard_registry.d)

```d
class WizardRegistry {
    WizardDefinition[string] wizards;
    
    this() {
        // Регистрация всех визардов
        register(mainWindowWizard);
        register(dialogWizard);
        register(trayWizard);
        register(dataViewWizard);
        register(textEditorWizard);
        register(formWizard);
        register(networkWizard);
        register(threadingWizard);
        // ...
    }
    
    void register(WizardDefinition def) {
        wizards[def.id] = def;
    }
    
    WizardDefinition get(string id) {
        return wizards[id];
    }
    
    WizardDefinition[] getByCategory(string category) {
        return wizards.values.filter!(w => w.category == category).array;
    }
    
    string[] getCategories() {
        return wizards.values.map!(w => w.category).uniq.array;
    }
}
```

---

## 7. Пресеты

### 7.1 Формат пресета (JSON)

```json
{
    "name": "Text Editor",
    "description": "Simple text editor with syntax highlighting",
    "wizards": ["mainwindow", "texteditor", "fileops"],
    "values": {
        "doc_type": "sdi",
        "menu_file_enabled": true,
        "menu_file_new": true,
        "menu_file_open": true,
        "menu_file_save": true,
        "menu_file_recent": true,
        "menu_file_recent_count": 10,
        "menu_edit_enabled": true,
        "menu_edit_undo": true,
        "menu_edit_clipboard": true,
        "menu_edit_find": true,
        "central_widget": "scintilla",
        "scintilla_line_numbers": true,
        "scintilla_folding": true,
        "statusbar_enabled": true,
        "statusbar_cursor_pos": true,
        "statusbar_encoding": true,
        "settings_enabled": true,
        "settings_geometry": true,
        "settings_recent": true
    }
}
```

### 7.2 Загрузка пресетов

```d
class PresetManager {
    Preset[] presets;
    
    void loadPresets(string presetsDir) {
        foreach (file; dirEntries(presetsDir, "*.json", SpanMode.shallow)) {
            auto json = parseJSON(readText(file));
            presets ~= Preset.fromJson(json);
        }
    }
    
    void applyPreset(Preset preset, WizardState[] states) {
        foreach (key, value; preset.values) {
            // Найти нужный state и применить значение
        }
    }
}
```

---

## 8. Меню приложения

### File
- New Project (Ctrl+N) — сбросить всё, начать заново
- Open Project (Ctrl+O) — загрузить .qwiz файл
- Save Project (Ctrl+S) — сохранить текущее состояние
- Save Project As (Ctrl+Shift+S)
- ---
- Export Code (Ctrl+E) — сохранить сгенерированный .d файл
- Export Project (ZIP со всеми файлами)
- ---
- Recent Projects →
- ---
- Exit (Alt+F4)

### Edit
- Copy Code (Ctrl+C) — копировать код из превью
- Reset Current Step
- Reset All

### View
- Show/Hide Code Preview
- Show/Hide Wizard Tree
- ---
- Zoom In (Ctrl++)
- Zoom Out (Ctrl+-)

### Tools
- Preferences
- Manage Presets
- Validate Configuration

### Help
- Documentation (F1)
- QTE56 API Reference
- ---
- About

---

## 9. Сохранение проекта (.qwiz)

### Формат файла

```json
{
    "version": "1.0",
    "created": "2026-04-16T12:00:00Z",
    "modified": "2026-04-16T14:30:00Z",
    
    "project": {
        "name": "MyApp",
        "moduleName": "myapp",
        "outputPath": "./output"
    },
    
    "activeWizards": ["mainwindow", "fileops"],
    
    "states": {
        "mainwindow": {
            "doc_type": "sdi",
            "menu_file_enabled": true,
            // ...
        },
        "fileops": {
            // ...
        }
    }
}
```

---

## 10. Этапы разработки

### Фаза 1: Ядро (MVP)
1. ✓ Базовая структура проекта
2. ✓ Модель данных (WizardState, ProjectConfig)
3. ✓ Главное окно (layout без функционала)
4. ✓ Один визард (Main Window, 3-4 шага)
5. ✓ Базовая генерация кода
6. ✓ Превью кода

### Фаза 2: Расширение визардов
1. Все шаги Main Window Wizard
2. Dialog Wizard
3. Tray Application Wizard
4. Data View Wizard
5. Text Editor Wizard

### Фаза 3: Feature Wizards
1. Network Wizard
2. Threading Wizard
3. File Operations Wizard
4. Timer Wizard
5. Process Wizard

### Фаза 4: Полировка
1. Пресеты
2. Сохранение/загрузка проектов
3. Undo/Redo
4. Валидация конфигурации
5. Документация и подсказки

### Фаза 5: Расширенные возможности
1. Множественные файлы
2. Custom templates
3. Plugin система для новых визардов
4. Export в разные форматы

---

## 11. Важные замечания по QTE56

### Ownership
```d
// Typed методы (addWidget, setLayout) вызывают disown() автоматически
vbox.addWidget(label);  // НЕ трогать label._ptr после этого

// wrap() для объектов созданных Qt
auto menuBar = QMenuBar.wrap(win.menuBar());
```

### ESlot паттерн
```d
// ОБЯЗАТЕЛЬНО __gshared для ESlot
__gshared ESlot g_slotClicked;

extern(C) void onClicked(void* dthis, int n, int checked) {
    // callback
}

g_slotClicked = new ESlot(button.getWH());
g_slotClicked.set(cast(void*)&onClicked);
button.connect_clicked(g_slotClicked);
```

### Строки
```d
// Типизированные методы принимают D string напрямую
label.setText("Hello");

// void* методы требуют toQString/fromQString
void* qs = toQString("text");
// ...
string s = fromQString(widget.text());  // fromQString удаляет qs!
```

### QScintilla
```d
// Требует два DLL:
// - qte56_qscintilla.dll
// - qscintilla2_qt5.dll
```

---

## 12. Тестирование

### Тест-кейсы генерации

1. **Минимальное приложение**
   - Только QWidget с одной кнопкой
   - Проверка: компилируется, запускается

2. **QMainWindow с меню**
   - File + Edit меню
   - Проверка: меню работает, shortcuts

3. **MDI приложение**
   - QMdiArea с child windows
   - Проверка: создание/закрытие окон

4. **Tray приложение**
   - Иконка в трее, меню
   - Проверка: minimize to tray, notifications

5. **Комплексное приложение**
   - Все фичи включены
   - Проверка: всё работает вместе

---

## 13. Ссылки на файлы

- **AI_CONTEXT.md** — API QTE56, таблица импортов, примеры кода
- **QTE56_WIZARD_SPECIFICATION.md** — полная спецификация всех визардов и опций

---

*Конец задания*
