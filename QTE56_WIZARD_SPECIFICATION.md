# QTE56 Wizard System — Полная спецификация

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [qte56_wizard_generator/README.md](qte56_wizard_generator/README.md)

## Обзор системы

Система визардов для генерации QTE56 приложений. Каждый визард — это дерево решений,
где выбор на одном шаге влияет на доступные опции следующих шагов.

---

# ЧАСТЬ 1: APPLICATION WIZARDS

## 1.1 Main Window Wizard (QMainWindow)

### Шаг 1: Архитектура документа
```
○ SDI (Single Document Interface)
    → Одно окно = один документ
    → Подходит для: просмотрщики, утилиты
    
○ MDI (Multiple Document Interface)  
    → QMdiArea с дочерними окнами
    → Подходит для: IDE, редакторы изображений
    Подопции:
      ☐ Tabbed mode (вкладки вместо окон)
      ☐ Cascade/Tile actions
      ☐ Window menu
      
○ TDI (Tabbed Document Interface)
    → QTabWidget как центральный виджет
    → Подходит для: браузеры, редакторы кода
    Подопции:
      ☐ Closable tabs
      ☐ Movable tabs  
      ☐ Tab context menu
      ☐ New tab button
      
○ Workspace (без документов)
    → Dashboard/панель управления
    → Подходит для: админ-панели, мониторинг
```

### Шаг 2: Меню — File
```
☐ Включить меню File
  │
  ├─☐ New
  │   ├─○ Simple (Ctrl+N)
  │   ├─○ New submenu (типы документов)
  │   └─○ New from template
  │
  ├─☐ Open
  │   ├─○ Single file (Ctrl+O)
  │   ├─○ Multiple files
  │   ├─○ Open folder
  │   └─☐ Open Recent submenu
  │       ├─ Количество: [5-20]
  │       └─☐ Clear recent action
  │
  ├─☐ Save / Save As
  │   ├─☐ Save (Ctrl+S)
  │   ├─☐ Save As (Ctrl+Shift+S)
  │   ├─☐ Save All
  │   └─☐ Auto-save
  │       ├─ Интервал: [1-30] мин
  │       └─ Путь: ○ Temp ○ Same dir ○ Custom
  │
  ├─☐ Export
  │   └─ Форматы: [список чекбоксов]
  │
  ├─☐ Print
  │   ├─☐ Print (Ctrl+P)
  │   ├─☐ Print Preview
  │   └─☐ Page Setup
  │
  ├─☐ Close
  │   ├─☐ Close (Ctrl+W)
  │   └─☐ Close All
  │
  └─☐ Exit (Alt+F4)
      └─☐ Confirm on unsaved changes
```

### Шаг 3: Меню — Edit
```
☐ Включить меню Edit
  │
  ├─☐ Undo/Redo
  │   ├─☐ Undo (Ctrl+Z)
  │   ├─☐ Redo (Ctrl+Y / Ctrl+Shift+Z)
  │   └─☐ Undo History dropdown
  │
  ├─☐ Clipboard
  │   ├─☐ Cut (Ctrl+X)
  │   ├─☐ Copy (Ctrl+C)
  │   ├─☐ Paste (Ctrl+V)
  │   ├─☐ Paste Special
  │   └─☐ Delete
  │
  ├─☐ Selection
  │   ├─☐ Select All (Ctrl+A)
  │   ├─☐ Deselect
  │   └─☐ Invert Selection
  │
  ├─☐ Find & Replace
  │   ├─☐ Find (Ctrl+F)
  │   ├─☐ Find Next (F3)
  │   ├─☐ Find Previous (Shift+F3)
  │   ├─☐ Replace (Ctrl+H)
  │   └─☐ Go to Line (Ctrl+G)
  │
  └─☐ Preferences (Settings dialog)
      └─ См. Dialog Wizard → Settings
```

### Шаг 4: Меню — View
```
☐ Включить меню View
  │
  ├─☐ Toolbars submenu
  │   └─ [Автогенерация из шага Toolbars]
  │
  ├─☐ Dock Panels submenu
  │   └─ [Автогенерация из шага Docks]
  │
  ├─☐ Status Bar toggle
  │
  ├─☐ Full Screen (F11)
  │
  ├─☐ Zoom
  │   ├─☐ Zoom In (Ctrl++)
  │   ├─☐ Zoom Out (Ctrl+-)
  │   ├─☐ Zoom Reset (Ctrl+0)
  │   └─☐ Zoom slider в статусбаре
  │
  └─☐ Layout
      ├─☐ Save Layout
      ├─☐ Restore Layout
      └─☐ Reset to Default
```

### Шаг 5: Меню — Tools
```
☐ Включить меню Tools
  │
  ├─☐ Options/Settings
  │
  ├─☐ Customize
  │   ├─☐ Customize Toolbars
  │   └─☐ Customize Shortcuts
  │
  ├─☐ Macros
  │   ├─☐ Record Macro
  │   ├─☐ Play Macro
  │   └─☐ Edit Macros
  │
  └─☐ External Tools submenu
      └─ [Конфигурируемый список]
```

### Шаг 6: Меню — Window (для MDI)
```
[Доступно только если архитектура = MDI]

☐ Включить меню Window
  │
  ├─☐ New Window
  ├─☐ Cascade
  ├─☐ Tile Horizontal
  ├─☐ Tile Vertical
  ├─☐ Close All Windows
  ├─☐ Separator
  └─☐ Window List (автоматический)
```

### Шаг 7: Меню — Help
```
☐ Включить меню Help
  │
  ├─☐ Help Contents (F1)
  │   ├─○ CHM файл
  │   ├─○ PDF документация
  │   ├─○ Online URL
  │   └─○ Встроенный QTextBrowser
  │
  ├─☐ What's This? (Shift+F1)
  │
  ├─☐ Check for Updates
  │   └─ URL: [______________]
  │
  ├─☐ Report Bug
  │   └─ URL/Email: [______________]
  │
  ├─☐ About
  │   ├─ Название: [______________]
  │   ├─ Версия: [______________]
  │   ├─ Copyright: [______________]
  │   └─☐ Лого (путь к изображению)
  │
  └─☐ About Qt
```

### Шаг 8: Кастомные меню
```
[Добавить своё меню]

Меню 1: [______________]
  ├─ Action 1: [имя] [shortcut] [icon]
  ├─ Action 2: [имя] [shortcut] [icon]
  ├─ --- separator ---
  └─ Submenu: [имя]
      └─ ...

[+ Добавить ещё меню]
```

### Шаг 9: Тулбары
```
☐ Main Toolbar
  │ Позиция: ○ Top ○ Left ○ Right ○ Bottom ○ Floating
  │ Стиль: ○ Icons only ○ Text only ○ Text beside ○ Text under
  │ Размер иконок: ○ 16x16 ○ 24x24 ○ 32x32
  │
  └─ Actions:
     ☐ New    [icon: ___]
     ☐ Open   [icon: ___]
     ☐ Save   [icon: ___]
     ☐ --- separator ---
     ☐ Undo   [icon: ___]
     ☐ Redo   [icon: ___]
     ☐ --- separator ---
     ☐ Cut    [icon: ___]
     ☐ Copy   [icon: ___]
     ☐ Paste  [icon: ___]

☐ Format Toolbar (для редакторов)
  │ [аналогичные настройки]
  │
  └─ Actions:
     ☐ Bold
     ☐ Italic
     ☐ Underline
     ☐ Font selector (QFontComboBox)
     ☐ Font size (QSpinBox)
     ☐ Color picker

☐ Navigation Toolbar
  │ [аналогичные настройки]
  │
  └─ Actions:
     ☐ Back
     ☐ Forward
     ☐ Home
     ☐ Address bar (QLineEdit)

☐ Custom Toolbar
  │ Название: [______________]
  │ [настройки]
  │
  └─ Actions: [конфигуратор]

[+ Добавить ещё тулбар]
```

### Шаг 10: Dock Panels
```
☐ Project/Files Panel
  │ Позиция: ○ Left ○ Right ○ Top ○ Bottom
  │ Начальный размер: [___] x [___]
  │ ☐ Closable
  │ ☐ Movable
  │ ☐ Floatable
  │
  └─ Содержимое:
     ○ QTreeWidget (файловое дерево)
     ○ QListWidget (плоский список)
     ○ Custom widget

☐ Properties Panel
  │ [аналогичные настройки]
  │
  └─ Содержимое:
     ○ QTreeWidget (key-value)
     ○ QTableWidget (grid)
     ○ QFormLayout (форма)

☐ Output/Log Panel
  │ Позиция: ○ Bottom (рекомендуется)
  │
  └─ Содержимое:
     ○ QPlainTextEdit (read-only log)
     ○ QTabWidget (несколько логов)
        ├─ Output
        ├─ Errors
        └─ Debug

☐ Preview Panel
  │ [настройки]
  │
  └─ Содержимое:
     ○ QLabel (изображения)
     ○ QTextBrowser (HTML/Markdown)
     ○ Custom rendering

☐ Toolbox Panel
  │ [настройки]
  │
  └─ Содержимое:
     ○ QToolBox (collapsible sections)
     ○ QListWidget с иконками

☐ Custom Dock
  │ Название: [______________]
  │ [все настройки]
  │
  └─ Содержимое: [______________]

[+ Добавить ещё dock]

Dock Tabbing:
  ☐ Allow tabbed docks
  ☐ Default tabbed groups:
     [Left docks tabbed together]
     [Bottom docks tabbed together]
```

### Шаг 11: Status Bar
```
☐ Включить Status Bar
  │
  ├─☐ Секция сообщений (stretch)
  │   └─ Timeout сообщений: [___] мс (0 = permanent)
  │
  ├─☐ Секция прогресса
  │   ├─☐ QProgressBar
  │   └─☐ Cancel button
  │
  ├─☐ Кастомные секции:
  │   │
  │   ├─☐ Cursor position (Ln: X, Col: Y)
  │   │   └─ Ширина: [___] px
  │   │
  │   ├─☐ Selection info (X selected)
  │   │   └─ Ширина: [___] px
  │   │
  │   ├─☐ Encoding indicator (UTF-8)
  │   │   └─☐ Кликабельный (меню выбора)
  │   │
  │   ├─☐ Line ending indicator (CRLF/LF)
  │   │   └─☐ Кликабельный
  │   │
  │   ├─☐ Zoom indicator (100%)
  │   │   └─☐ Slider popup
  │   │
  │   ├─☐ Mode indicator (INS/OVR)
  │   │
  │   ├─☐ Date/Time
  │   │   └─ Format: [______________]
  │   │
  │   └─☐ Custom indicator
  │       ├─ Имя: [______________]
  │       └─ Ширина: [___] px
  │
  └─☐ Permanent widgets (не скрываются)
      └─ [список индикаторов]
```

### Шаг 12: Central Widget
```
Выбор главного виджета:

○ Splitter Layout
  │
  ├─ Ориентация: ○ Horizontal ○ Vertical
  │
  ├─ Панель 1:
  │   ├─ Виджет: [выбор из списка]
  │   ├─ Начальный размер: [___]
  │   └─ ☐ Collapsible
  │
  ├─ Панель 2:
  │   └─ [те же опции]
  │
  └─☐ Вложенный splitter
      └─ [рекурсивно]

○ Tab Widget
  │
  ├─ Позиция табов: ○ Top ○ Bottom ○ Left ○ Right
  ├─☐ Closable tabs
  ├─☐ Movable tabs
  ├─☐ Document mode
  │
  └─ Вкладки:
     ├─ Tab 1: [имя] [виджет]
     ├─ Tab 2: [имя] [виджет]
     └─ [+ Добавить]

○ Stacked Widget
  │
  ├─ Переключение: ○ Programmatic ○ ListWidget ○ TreeWidget
  │
  └─ Страницы:
     ├─ Page 1: [имя] [виджет]
     └─ [+ Добавить]

○ Scroll Area
  │
  └─ Содержимое: [виджет]

○ MDI Area [только если архитектура = MDI]
  │
  ├─ View mode: ○ SubWindow ○ Tabbed
  ├─ Background: [цвет/изображение]
  │
  └─ Subwindow template:
     └─ [рекурсивный вызов Central Widget]

○ Single Widget
  │
  └─ Виджет: 
     ○ QTextEdit
     ○ QPlainTextEdit
     ○ QScintilla
     ○ QTreeWidget
     ○ QTableWidget
     ○ QListWidget
     ○ QGraphicsView
     ○ QWebEngineView
     ○ Custom class: [______________]
```

### Шаг 13: Shortcut Configuration
```
Стандартные shortcuts:
  ☐ Use platform defaults (Ctrl+C / ⌘C)

Конфликты:
  [Автоматическая проверка и предупреждения]

Кастомные shortcuts:
  │
  ├─ [Action name] : [Shortcut input]
  ├─ [Action name] : [Shortcut input]
  └─ [+ Добавить]

Группы shortcuts:
  ☐ File operations
  ☐ Edit operations  
  ☐ View operations
  ☐ Navigation
  ☐ Custom group: [______________]
```

### Шаг 14: Persistence (QSettings)
```
☐ Включить сохранение состояния

Что сохранять:
  ☐ Window geometry (позиция, размер)
  ☐ Window state (maximized, fullscreen)
  ☐ Toolbar positions
  ☐ Dock positions and sizes
  ☐ Splitter sizes
  ☐ Recent files list
  ☐ Last opened directory
  ☐ View settings (zoom, etc.)
  ☐ Application settings

Формат:
  ○ INI file
     └─ Путь: ○ App directory ○ User config ○ Custom: [___]
  ○ Registry (Windows only)
     └─ Ключ: [______________]

Версионирование:
  ☐ Version key (для миграций)
     └─ Текущая версия: [___]

Профили:
  ☐ Multiple profiles support
     ├─ Default profile name: [______________]
     └─ Profile storage: [______________]
```

### Шаг 15: System Tray
```
☐ Включить System Tray

Иконка:
  ├─ Default icon: [путь]
  ├─☐ State-based icons:
  │   ├─ Normal: [путь]
  │   ├─ Warning: [путь]
  │   └─ Error: [путь]
  └─☐ Animated icon (QMovie)

Tooltip: [______________]

Меню:
  ├─☐ Show/Hide window
  ├─☐ --- separator ---
  ├─☐ [Custom actions...]
  ├─☐ --- separator ---
  └─☐ Exit

Click behavior:
  ├─ Single click: ○ Show menu ○ Toggle window ○ Nothing
  ├─ Double click: ○ Show window ○ Nothing
  └─ Middle click: ○ Custom action ○ Nothing

Notifications:
  ☐ Enable balloon/notification support
     ├─ Default timeout: [___] ms
     └─ Click action: ○ Show window ○ Custom ○ Nothing

Minimize to tray:
  ☐ Minimize to tray instead of taskbar
  ☐ Close to tray (with confirmation option)
```

### Шаг 16: Theming
```
☐ Включить поддержку тем

Встроенные темы:
  ☐ System default
  ☐ Light theme
  ☐ Dark theme
  ☐ High contrast

QSS Templates:
  ☐ Generate base QSS файл
  
Цветовая схема (для Light):
  ├─ Background:    [#______]
  ├─ Surface:       [#______]
  ├─ Primary:       [#______]
  ├─ Secondary:     [#______]
  ├─ Text:          [#______]
  ├─ Text Secondary:[#______]
  ├─ Border:        [#______]
  ├─ Accent:        [#______]
  ├─ Success:       [#______]
  ├─ Warning:       [#______]
  └─ Error:         [#______]

Цветовая схема (для Dark):
  └─ [аналогично]

Fonts:
  ├─ UI Font: [______________] [size]
  ├─ Monospace Font: [______________] [size]
  └─ Header Font: [______________] [size]

Spacing:
  ├─ Base unit: [___] px
  ├─ Border radius: [___] px
  └─ Icon size: ○ 16 ○ 24 ○ 32

Theme switching:
  ☐ Menu option
  ☐ Follow system theme
  ☐ Save theme preference
```

### Шаг 17: Single Instance
```
☐ Включить single instance mode

При повторном запуске:
  ○ Activate existing window
  ○ Pass arguments to existing instance
  ○ Show error and exit

IPC method:
  ○ Local socket (QLocalServer)
  ○ Shared memory
  ○ File lock

Timeout: [___] ms

Multi-instance override:
  ☐ Command-line flag: [--new-instance]
```

### Шаг 18: Splash Screen
```
☐ Включить Splash Screen

Изображение: [путь]
  ├─ Размер: [___] x [___]
  └─ ☐ Window flags: frameless, stay on top

Показывать:
  ├─ Время: [___] ms (минимум)
  └─ ☐ До завершения загрузки

Прогресс:
  ☐ Progress bar
     ├─ Позиция: ○ Bottom ○ Custom: x=[__] y=[__]
     └─ Стиль: [QSS]

Текст статуса:
  ☐ Status message
     ├─ Позиция: x=[__] y=[__]
     ├─ Шрифт: [______________]
     ├─ Цвет: [#______]
     └─ Alignment: ○ Left ○ Center ○ Right

Сообщения загрузки:
  ├─ "Loading configuration..."
  ├─ "Initializing plugins..."
  └─ [+ Добавить]
```

---

## 1.2 Dialog Wizard

### Шаг 1: Тип диалога
```
○ Modal Dialog
    → Блокирует родителя
    → exec() → result code
    
○ Modeless Dialog
    → Не блокирует
    → show() → signals
    
○ Wizard Dialog (multi-page)
    → Back/Next/Finish
    → Validation per page
    
○ Settings Dialog
    → Tree/List + Stack
    → Apply/OK/Cancel
```

### Шаг 2: Buttons
```
Standard buttons:
  ☐ OK
  ☐ Cancel
  ☐ Apply
  ☐ Yes
  ☐ No
  ☐ Close
  ☐ Help
  ☐ Reset
  ☐ Discard
  ☐ Save

Button order:
  ○ Platform default
  ○ Custom: [drag to reorder]

Custom buttons:
  ├─ [имя] [role: accept/reject/action]
  └─ [+ Добавить]

Default button: [выбор из списка]
Escape button: [выбор из списка]
```

### Шаг 3: Layout
```
○ Simple Form
  │
  └─ Fields:
     ├─ [Label] [Widget type] [☐ Required]
     └─ [+ Добавить]

○ Form with Groups
  │
  └─ Groups:
     ├─ Group 1: [название]
     │   └─ Fields: [...]
     └─ [+ Добавить группу]

○ Tabbed Layout
  │
  └─ Tabs:
     ├─ Tab 1: [название] [layout: form/grid]
     └─ [+ Добавить]

○ Tree + Stack (Settings style)
  │
  ├─ Tree depth: ○ 1 level ○ 2 levels ○ 3 levels
  │
  └─ Categories:
     ├─ General
     │   ├─ Appearance [page]
     │   └─ Behavior [page]
     └─ [+ Добавить]

○ Wizard Pages
  │
  └─ Pages:
     ├─ Welcome page
     │   └─ ☐ Show only once
     ├─ Page 1: [название] [layout]
     ├─ Page N: [...]
     └─ Finish page
         └─ ☐ Summary of selections
```

### Шаг 4: Input Fields (библиотека)
```
Доступные типы полей:

□ Text Input
  ├─ QLineEdit
  │   ├─ Placeholder: [______________]
  │   ├─ Max length: [___]
  │   ├─ Echo mode: ○ Normal ○ Password ○ NoEcho
  │   ├─☐ Clear button
  │   └─☐ Input mask: [______________]
  │
  └─ QTextEdit / QPlainTextEdit
      ├─ Placeholder: [______________]
      └─ Max height: [___] lines

□ Numeric Input
  ├─ QSpinBox
  │   ├─ Range: [___] - [___]
  │   ├─ Step: [___]
  │   ├─ Prefix: [______________]
  │   └─ Suffix: [______________]
  │
  └─ QDoubleSpinBox
      ├─ Range: [___] - [___]
      ├─ Decimals: [___]
      └─ Step: [___]

□ Selection
  ├─ QComboBox
  │   ├─ Items: [list]
  │   ├─☐ Editable
  │   └─☐ Autocomplete
  │
  ├─ QRadioButton group
  │   ├─ Options: [list]
  │   └─ Layout: ○ Vertical ○ Horizontal
  │
  └─ QCheckBox
      └─☐ Tri-state

□ Date/Time
  ├─ QDateEdit
  │   └─ Format: [______________]
  ├─ QTimeEdit
  │   └─ Format: [______________]
  ├─ QDateTimeEdit
  │   └─ Format: [______________]
  └─ QCalendarWidget (popup или inline)

□ Slider
  ├─ QSlider
  │   ├─ Orientation: ○ Horizontal ○ Vertical
  │   ├─ Range: [___] - [___]
  │   ├─☐ Tick marks
  │   └─☐ Value label
  │
  └─ QDial
      └─ [аналогично]

□ File/Directory
  ├─ Path input + Browse button
  │   ├─ Mode: ○ Open file ○ Save file ○ Directory
  │   ├─ Filter: [______________]
  │   └─☐ Must exist

□ Color
  └─ Color button + QColorDialog

□ Font
  └─ Font preview + QFontDialog

□ Custom Widget
  └─ Class name: [______________]
```

### Шаг 5: Validation
```
Validation mode:
  ○ On submit (all at once)
  ○ On field leave
  ○ Real-time (as you type)

Per-field validators:
  ├─ Required: ☐
  ├─ Regex: [______________]
  ├─ Range: [___] - [___]
  ├─ Length: [___] - [___]
  ├─ Custom function: [______________]
  └─ Error message: [______________]

Cross-field validation:
  ├─ [field1] must equal [field2]
  ├─ [field1] must be less than [field2]
  └─ Custom: [______________]

Error display:
  ○ Inline (red border + message below)
  ○ Tooltip
  ○ Summary at top
  ○ Message box on submit
```

### Шаг 6: Data Flow
```
Input:
  ○ No initial data
  ○ From struct/class
     └─ Fields mapping: [field → widget]
  ○ From QSettings
     └─ Keys mapping: [key → widget]

Output:
  ○ Accepted/Rejected only
  ○ Populate struct/class
  ○ Save to QSettings
  ○ Emit signal with data

Apply button behavior:
  ☐ Enabled only when dirty
  ☐ Validate before apply
  ☐ Save immediately
```

### Шаг 7: Window Properties
```
Size:
  ○ Fixed: [___] x [___]
  ○ Resizable
     ├─ Min: [___] x [___]
     ├─ Max: [___] x [___]
     └─☐ Remember size

Position:
  ○ Center on parent
  ○ Center on screen
  ○ Custom: x=[___] y=[___]
  ○ Remember position

Modality:
  ○ Application modal
  ○ Window modal
  ○ Non-modal

Window flags:
  ☐ Title bar
  ☐ System menu
  ☐ Minimize button
  ☐ Maximize button
  ☐ Close button
  ☐ Help button (?)
  ☐ Stay on top
```

---

## 1.3 Tray Application Wizard

### Шаг 1: Window Behavior
```
При запуске:
  ○ Show window
  ○ Start minimized to tray
  ○ Start hidden (tray only)

При закрытии окна:
  ○ Close to tray
  ○ Minimize to tray
  ○ Exit application
  ○ Ask user (remember choice)

При сворачивании:
  ○ Minimize to taskbar
  ○ Minimize to tray
```

### Шаг 2: Tray Icon
```
Icons:
  ├─ Default: [путь] 
  ├─☐ State icons:
  │   ├─ Idle: [путь]
  │   ├─ Working: [путь]
  │   ├─ Success: [путь]
  │   ├─ Warning: [путь]
  │   └─ Error: [путь]
  │
  └─☐ Animated states:
      ├─ Working: [путь к GIF/frames]
      └─ Notification: [путь]

Tooltip:
  ├─ Static: [______________]
  └─☐ Dynamic (update from code)
```

### Шаг 3: Tray Menu
```
Menu items:
  ├─☐ Application name (disabled, bold)
  ├─☐ --- separator ---
  ├─☐ Show/Hide Window
  ├─☐ --- separator ---
  ├─☐ Status submenu
  │   ├─ Online
  │   ├─ Away
  │   └─ Busy
  ├─☐ Settings...
  ├─☐ --- separator ---
  └─☐ Exit

Custom actions:
  └─ [+ Добавить]
```

### Шаг 4: Click Behavior
```
Single click:
  ○ Show context menu
  ○ Toggle window visibility
  ○ Show window
  ○ Nothing
  ○ Custom action: [______________]

Double click:
  ○ Show window
  ○ Open settings
  ○ Nothing
  ○ Custom action: [______________]

Middle click:
  ○ Nothing
  ○ Toggle status
  ○ Custom action: [______________]
```

### Шаг 5: Notifications
```
☐ Enable notifications

Notification system:
  ○ System tray balloon (QSystemTrayIcon)
  ○ Native notifications (platform API)

Types:
  ├─ Information
  ├─ Warning
  ├─ Error
  └─ Custom

Default timeout: [___] ms

Click behavior:
  ○ Dismiss
  ○ Show window
  ○ Custom action

Sound:
  ☐ Play sound on notification
     └─ Sound file: [путь]
```

### Шаг 6: Autostart
```
☐ Enable autostart option

Implementation:
  ○ Registry (Windows)
  ○ Startup folder shortcut
  ○ XDG autostart (Linux)
  ○ LaunchAgent (macOS)

Options:
  ☐ Start minimized when autostarted
  ☐ Show notification on autostart
  ☐ User can toggle in settings
```

---

# ЧАСТЬ 2: WIDGET WIZARDS

## 2.1 Data View Wizard (Tree/Table/List)

### Шаг 1: View Type
```
○ QTreeWidget
  │
  ├─ Иерархия: ○ Single level ○ Multi-level
  └─ Root visible: ○ Yes ○ No (forest)

○ QTableWidget
  │
  └─ Spanning cells: ☐ Enable

○ QListWidget
  │
  ├─ View mode: ○ List ○ Icon grid
  └─ Flow: ○ TopToBottom ○ LeftToRight
```

### Шаг 2: Columns/Fields
```
[Column editor]

Column 1:
  ├─ Header text: [______________]
  ├─ Width: [___] px / stretch
  ├─ Alignment: ○ Left ○ Center ○ Right
  ├─ Data type: ○ Text ○ Number ○ Date ○ Bool ○ Custom
  ├─☐ Sortable
  ├─☐ Resizable
  └─☐ Hidden by default

[+ Добавить колонку]

Header:
  ├─☐ Visible
  ├─☐ Clickable (для сортировки)
  ├─☐ Movable columns
  └─☐ Context menu (show/hide columns)
```

### Шаг 3: Selection
```
Mode:
  ○ No selection
  ○ Single selection
  ○ Multi selection
  ○ Extended selection (Ctrl+click, Shift+click)
  ○ Contiguous selection

Behavior:
  ○ Select items
  ○ Select rows
  ○ Select columns

Visual:
  ☐ Focus rectangle
  ☐ Selection follows focus
```

### Шаг 4: Sorting
```
☐ Enable sorting

Default sort:
  ├─ Column: [выбор]
  └─ Order: ○ Ascending ○ Descending

Multi-column sort:
  ☐ Enable (Shift+click)
     └─ Max columns: [___]

Sort indicators:
  ☐ Show in header

Custom sort:
  ☐ Custom comparator function
```

### Шаг 5: Filtering
```
☐ Enable filtering

Filter UI:
  ○ Global search box
  ○ Per-column filters
  ○ Both

Search behavior:
  ├─ Match: ○ Contains ○ Starts with ○ Exact ○ Regex
  ├─ Case: ○ Sensitive ○ Insensitive
  └─ Columns: ○ All ○ Selected: [список]

Real-time:
  ☐ Filter as you type
     └─ Debounce: [___] ms

Clear:
  ☐ Clear button
  ☐ Show "X items filtered" status
```

### Шаг 6: Editing
```
Mode:
  ○ Read-only
  ○ Edit on double-click
  ○ Edit on F2
  ○ Edit on single click
  ○ Always editing

Editable columns: [checkbox list]

Editors per type:
  ├─ Text: QLineEdit
  ├─ Number: QSpinBox
  ├─ Bool: QCheckBox / QComboBox
  ├─ Date: QDateEdit
  ├─ Enum: QComboBox
  └─ Custom: [delegate class]

Validation:
  ☐ Validate on commit
  ☐ Reject invalid input

Signals:
  ☐ itemChanged
  ☐ cellChanged
```

### Шаг 7: Context Menu
```
☐ Enable context menu

On item:
  ├─☐ Edit
  ├─☐ Delete
  ├─☐ --- separator ---
  ├─☐ Copy
  ├─☐ Cut
  ├─☐ Paste
  ├─☐ --- separator ---
  ├─☐ Move Up
  ├─☐ Move Down
  └─☐ Custom: [имя] [action]

On empty space:
  ├─☐ Add new item
  ├─☐ Paste
  └─☐ Custom: [имя] [action]

On header:
  ├─☐ Sort ascending
  ├─☐ Sort descending
  ├─☐ --- separator ---
  └─☐ Show/hide columns
```

### Шаг 8: Drag & Drop
```
☐ Enable Drag & Drop

Drag:
  ├─ Source: ○ Internal only ○ External also
  ├─ Start: ○ Left button ○ After 3px move
  └─ Visual: ○ Pixmap ○ Rubber band

Drop:
  ├─ Target: ○ Internal only ○ External also
  ├─ Position: ○ On items ○ Between items ○ Both
  └─ Action: ○ Copy ○ Move ○ Ask

External formats:
  ☐ text/plain
  ☐ text/uri-list
  ☐ Custom: [______________]
```

### Шаг 9: Checkboxes
```
☐ Enable checkboxes

Mode:
  ○ First column only
  ○ All columns
  ○ Specific columns: [список]

State:
  ○ Two-state (checked/unchecked)
  ○ Tri-state (partial for parents)

Behavior:
  ☐ Check on click
  ☐ Check on Space
  ☐ Select checked only
```

### Шаг 10: Styling
```
Alternating rows:
  ☐ Enable
     ├─ Color 1: [#______]
     └─ Color 2: [#______]

Hover:
  ☐ Highlight row on hover
     └─ Color: [#______]

Selection colors:
  ├─ Background: [#______]
  └─ Text: [#______]

Grid lines:
  ☐ Show grid
     └─ Style: ○ Solid ○ Dotted ○ Dashed

Row height:
  ○ Automatic
  ○ Fixed: [___] px

Icons:
  ☐ Enable item icons
     └─ Size: [___] x [___]

Indentation (Tree):
  └─ Indent: [___] px
```

---

## 2.2 Text Editor Wizard

### Шаг 1: Editor Type
```
○ QTextEdit (Rich text)
  │
  ├─ Formats: ☐ Bold ☐ Italic ☐ Underline ☐ Strikethrough
  ├─ Alignment: ☐ Left ☐ Center ☐ Right ☐ Justify
  ├─ Lists: ☐ Bullet ☐ Numbered
  └─ Tables: ☐ Insert table support

○ QPlainTextEdit (Plain text)
  │
  └─ Optimized for: ○ General ○ Log viewer ○ Large files

○ QScintilla (Code editor)
  │
  ├─ Требует: qte56_qscintilla.dll + qscintilla2_qt5.dll
  └─ [Дополнительные шаги для QScintilla]
```

### Шаг 2: Line Numbers (Plain/Scintilla)
```
☐ Show line numbers

Position: ○ Left ○ Right

Style:
  ├─ Background: [#______]
  ├─ Text color: [#______]
  └─ Current line highlight: [#______]

Click behavior:
  ☐ Select line on click
  ☐ Set breakpoint on click
```

### Шаг 3: Syntax Highlighting (Scintilla)
```
[Только для QScintilla]

Language:
  ○ None
  ○ C/C++
  ○ D
  ○ Python
  ○ JavaScript
  ○ HTML
  ○ CSS
  ○ JSON
  ○ XML
  ○ SQL
  ○ Markdown
  ○ Custom lexer: [______________]

Theme:
  ○ Default
  ○ Monokai
  ○ Solarized Light
  ○ Solarized Dark
  ○ Visual Studio
  ○ Custom: [конфигуратор цветов]

Token colors (Custom):
  ├─ Default: [#______]
  ├─ Keyword: [#______]
  ├─ String: [#______]
  ├─ Number: [#______]
  ├─ Comment: [#______]
  ├─ Operator: [#______]
  ├─ Identifier: [#______]
  ├─ Preprocessor: [#______]
  └─ Error: [#______]
```

### Шаг 4: Code Folding (Scintilla)
```
☐ Enable code folding

Fold markers:
  ○ Arrows
  ○ Plus/Minus
  ○ Circles
  ○ Squares

Fold style:
  ○ By braces { }
  ○ By indentation
  ○ By keywords
  ○ Custom markers

Appearance:
  ├─ Margin width: [___] px
  ├─ Line color: [#______]
  └─ ☐ Highlight fold header
```

### Шаг 5: Auto-completion
```
☐ Enable auto-completion

Trigger:
  ○ Manual (Ctrl+Space)
  ○ Automatic after [___] characters
  ○ Both

Source:
  ☐ Document words
  ☐ API keywords (language-specific)
  ☐ Custom word list: [путь к файлу]

Appearance:
  ├─ Max visible items: [___]
  ├─ ☐ Show icons
  └─ ☐ Case insensitive matching
```

### Шаг 6: Find & Replace
```
☐ Enable Find & Replace

UI:
  ○ Dialog (Ctrl+F)
  ○ Inline bar (like VS Code)
  ○ Both

Features:
  ☐ Find (Ctrl+F)
  ☐ Find Next (F3)
  ☐ Find Previous (Shift+F3)
  ☐ Replace (Ctrl+H)
  ☐ Replace All
  ☐ Find in Selection

Options:
  ☐ Case sensitive
  ☐ Whole words
  ☐ Regular expressions
  ☐ Wrap around

Highlight:
  ☐ Highlight all matches
     └─ Color: [#______]
```

### Шаг 7: Margins (Scintilla)
```
Margins configuration:

Margin 0 (Line numbers):
  ├─ Width: [___] px (0 = hidden)
  ├─☐ Sensitive (click)
  └─ Style: [QSS]

Margin 1 (Symbols/Breakpoints):
  ├─ Width: [___] px
  ├─☐ Sensitive
  └─ Markers: [список символов]

Margin 2 (Folding):
  ├─ Width: [___] px
  └─ Style: ○ None ○ Arrows ○ +/-

Margin 3 (Custom):
  └─ [конфигуратор]
```

### Шаг 8: Additional Features
```
☐ Word wrap
   └─ Mode: ○ None ○ Word ○ Character

☐ Show whitespace
   └─ Style: ○ Dots ○ Arrows ○ Custom

☐ Show line endings
   └─ Style: ○ CR ○ LF ○ CRLF symbols

☐ Current line highlight
   └─ Color: [#______]

☐ Matching brace highlight
   └─ Colors: match [#______] / mismatch [#______]

☐ Auto-indent
   └─ Style: ○ None ○ Copy previous ○ Smart

☐ Tab settings
   ├─ Tab width: [___] spaces
   └─ ☐ Insert spaces instead of tabs

☐ Zoom support
   ├─ Ctrl+Scroll
   └─ Range: [___] - [___] %

☐ Bookmark support
   ├─ Toggle: Ctrl+B
   ├─ Next: F2
   └─ Previous: Shift+F2
```

---

## 2.3 Form Wizard (Input Forms)

### Шаг 1: Form Layout
```
○ QFormLayout (Label: Field)
  │
  └─ Label position: ○ Left ○ Top

○ QGridLayout (Custom positioning)
  │
  ├─ Columns: [___]
  └─ Row spacing: [___]

○ QVBoxLayout (Vertical stack)

○ Two-column (Label | Field | Label | Field)
```

### Шаг 2: Field Configuration
```
[Field editor с визуальным превью]

Field 1:
  ├─ Label: [______________]
  ├─ Name (для кода): [______________]
  ├─ Type: [dropdown из библиотеки]
  ├─ Default value: [______________]
  ├─☐ Required
  ├─☐ Read-only
  ├─ Tooltip: [______________]
  ├─ Placeholder: [______________]
  │
  └─ Validation:
     ├─ Type: ○ None ○ Regex ○ Range ○ Custom
     └─ Error message: [______________]

[+ Добавить поле]
[+ Добавить группу]
[+ Добавить separator]
[+ Добавить spacer]
```

### Шаг 3: Field Groups
```
☐ Use field groups

Group 1:
  ├─ Title: [______________]
  ├─ Style: ○ QGroupBox ○ Section header ○ Collapsible
  ├─☐ Checkable (enable/disable group)
  │
  └─ Fields: [drag from field list]

[+ Добавить группу]
```

### Шаг 4: Conditional Logic
```
☐ Enable conditional logic

Rules:
  ├─ When [field] equals [value]:
  │   ├─ Show: [field list]
  │   ├─ Hide: [field list]
  │   ├─ Enable: [field list]
  │   └─ Disable: [field list]
  │
  └─ [+ Добавить правило]

Complex conditions:
  ☐ AND/OR logic
  ☐ Comparison operators (=, !=, <, >, contains)
```

### Шаг 5: Data Binding
```
Source:
  ○ No binding (manual get/set)
  ○ Struct/Class
     ├─ Type name: [______________]
     └─ Field mapping: [автоматически по именам]
  ○ QSettings
     └─ Key prefix: [______________]
  ○ JSON object
  ○ Database record

Auto-sync:
  ○ Manual (explicit save/load)
  ○ On field change
  ○ On focus lost
```

### Шаг 6: Form Actions
```
Buttons:
  ☐ Submit / Save
     └─ Text: [______________]
  ☐ Reset / Clear
     └─ Text: [______________]
  ☐ Cancel
     └─ Text: [______________]

Position:
  ○ Bottom right
  ○ Bottom center
  ○ Top right
  ○ Custom

Spacing:
  └─ Margin from form: [___] px
```

---

# ЧАСТЬ 3: FEATURE WIZARDS

## 3.1 Network Wizard

### Шаг 1: HTTP Client
```
☐ Include HTTP client

Library:
  ○ net_utils (sync, simple)
  ○ curl_utils (CurlSession, advanced)
  ○ QNetworkAccessManager (async, Qt-native)

Methods:
  ☐ GET
  ☐ POST
  ☐ PUT
  ☐ DELETE
  ☐ PATCH
  ☐ HEAD

Features:
  ☐ JSON support (json.d)
  ☐ Form data encoding
  ☐ File upload
  ☐ Download to file
  ☐ Progress callbacks
  ☐ Timeout configuration
  ☐ Retry logic
  ☐ Custom headers
  ☐ Cookie handling
  ☐ Authentication (Basic, Bearer)
```

### Шаг 2: Async Operations
```
☐ Async network calls

Pattern:
  ○ Callbacks (ESlot)
  ○ QThread + signal
  ○ Worker thread pool

UI Integration:
  ☐ Progress bar
  ☐ Cancel button
  ☐ Status messages
  ☐ Error dialogs
```

### Шаг 3: Offline Support
```
☐ Offline capability

Cache:
  ☐ Response caching
     ├─ Location: [______________]
     └─ Max size: [___] MB

Queue:
  ☐ Queue failed requests
  ☐ Auto-retry on reconnect

Detection:
  ☐ Network status monitoring
  ☐ Online/Offline indicator
```

---

## 3.2 Threading Wizard

### Шаг 1: Thread Model
```
○ Simple worker thread
  │
  └─ One-off background task

○ Long-running thread
  │
  └─ Continuous background service

○ Thread pool
  │
  ├─ Pool size: [___] (0 = auto)
  └─ Queue type: ○ FIFO ○ Priority
```

### Шаг 2: Communication
```
Thread → UI:
  ○ Signals (recommended)
  ○ Shared memory + polling
  ○ Message queue

UI → Thread:
  ○ Atomic flags
  ○ Condition variables
  ○ Message queue

Data sharing:
  ☐ QMutex for shared data
  ☐ QReadWriteLock for read-heavy
  ☐ Lock-free queues
```

### Шаг 3: Progress & Cancellation
```
☐ Progress reporting
  │
  ├─ Type: ○ Percentage ○ Steps ○ Indeterminate
  ├─ Update frequency: [___] ms
  └─ UI: ○ Progress bar ○ Status text ○ Both

☐ Cancellation support
  │
  ├─ Cancel button
  ├─ Timeout: [___] seconds (0 = none)
  └─ Cleanup on cancel
```

---

## 3.3 File Operations Wizard

### Шаг 1: File Dialogs
```
☐ Open file dialog
  │
  ├─ Filters: [______________]
  ├─ Default directory: [______________]
  ├─☐ Multiple selection
  └─☐ Remember last directory

☐ Save file dialog
  │
  ├─ Filters: [______________]
  ├─ Default extension: [______________]
  └─☐ Confirm overwrite

☐ Directory dialog
  │
  └─☐ Show files (read-only)
```

### Шаг 2: File I/O
```
Text files:
  ☐ Read text file
  ☐ Write text file
  ☐ Append to file
  
  Encoding:
    ○ UTF-8 (default)
    ○ Auto-detect
    ○ User-specified

Binary files:
  ☐ Read binary
  ☐ Write binary
  ☐ Memory-mapped files

Large files:
  ☐ Streaming read
  ☐ Chunked write
  ☐ Progress for large operations
```

### Шаг 3: File Watching
```
☐ QFileSystemWatcher

Watch:
  ☐ Single file
  ☐ Directory
  ☐ Recursive directory

Events:
  ☐ File modified
  ☐ File created
  ☐ File deleted
  ☐ Directory changed

Debounce: [___] ms
```

---

## 3.4 Process Wizard

### Шаг 1: Process Execution
```
☐ QProcess support

Start mode:
  ○ Start and wait (blocking)
  ○ Start and forget
  ○ Start with monitoring

Output handling:
  ☐ Capture stdout
  ☐ Capture stderr
  ☐ Redirect to log widget
  ☐ Merge stdout+stderr

Input:
  ☐ Write to stdin
  ☐ Interactive mode
```

### Шаг 2: Process Management
```
☐ Process list/manager

Features:
  ☐ List running processes
  ☐ Kill process
  ☐ Wait for process
  ☐ Process priority

Environment:
  ☐ Custom environment variables
  ☐ Working directory
  ☐ PATH modifications
```

---

## 3.5 Timer Wizard

### Шаг 1: Timer Types
```
☐ Single-shot timer
  │
  └─ Delay: [___] ms

☐ Repeating timer
  │
  ├─ Interval: [___] ms
  └─ ☐ Precise timing

☐ Scheduled tasks
  │
  └─ Schedule: [cron-like syntax]
```

### Шаг 2: Timer Actions
```
On timeout:
  ○ Call function
  ○ Emit signal
  ○ Update UI element

Pause/Resume:
  ☐ Support pause
  ☐ Show remaining time
```

---

# ЧАСТЬ 4: CODE GENERATION

## 4.1 Output Options

### File Structure
```
○ Single file (all in one .d)

○ Multiple files:
  ├─ main.d (entry point)
  ├─ app.d (application class)
  ├─ ui/
  │   ├─ mainwindow.d
  │   ├─ dialogs.d
  │   └─ widgets.d
  ├─ core/
  │   ├─ settings.d
  │   └─ utils.d
  └─ resources/
      ├─ icons/
      └─ styles/
```

### Code Style
```
Naming:
  ○ camelCase
  ○ snake_case
  ○ PascalCase for types

Comments:
  ☐ Generate documentation comments
  ☐ Section separators
  ☐ TODO markers

Formatting:
  ├─ Indent: ○ Tabs ○ 2 spaces ○ 4 spaces
  ├─ Brace style: ○ Allman ○ K&R
  └─ Max line length: [___]
```

### Build Configuration
```
☐ Generate build script

Type:
  ○ Batch file (.bat)
  ○ Shell script (.sh)
  ○ Makefile
  ○ dub.json

Options:
  ☐ Debug build
  ☐ Release build
  ☐ Platform detection
```

---

## 4.2 Dependencies

Визард автоматически вычисляет зависимости:

```
Выбранные компоненты → Необходимые импорты → DLL зависимости

Например:
  QMainWindow → gen_qmainwindow → qte56_mainwin.dll
  QScintilla  → gen_qscintilla → qte56_qscintilla.dll + qscintilla2_qt5.dll
  QThread     → gen_qthread → qte56_thread.dll
```

Генерируется:
- Список импортов
- Инструкции по DLL
- Команды компиляции

---

# ЧАСТЬ 5: PRESETS

## Готовые пресеты (шаблоны)

### Text Editor
```
- QMainWindow + SDI
- File menu (New, Open, Save, Recent)
- Edit menu (Undo, Copy, Find)
- QPlainTextEdit или QScintilla
- Status bar (Ln/Col, Encoding)
- QSettings persistence
```

### Image Viewer
```
- QMainWindow + SDI
- File menu (Open, Export)
- View menu (Zoom, Fit)
- QScrollArea + QLabel (pixmap)
- Drag & drop support
```

### Database Browser
```
- QMainWindow + Splitter
- QTreeWidget (tables/views)
- QTableWidget (data grid)
- Context menus
- SQL editor (QScintilla)
```

### System Monitor
```
- Tray application
- Timer-based updates
- QTableWidget (processes)
- QProgressBar (CPU/RAM)
- Notifications
```

### Settings Manager
```
- Dialog-based
- Tree + Stack layout
- QSettings integration
- Import/Export
```

### Log Viewer
```
- QMainWindow
- QPlainTextEdit (append-only)
- QFileSystemWatcher
- Filter & Search
- Color-coded levels
```

---

*Конец спецификации*
