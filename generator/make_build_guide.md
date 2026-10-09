# make_build.py — руководство пользователя

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [GENERATOR_KNOWLEDGE_TRANSFER.md](../GENERATOR_KNOWLEDGE_TRANSFER.md)

Утилита для работы с D/Qt проектом qte56:
- генерирует скрипты компиляции (`build_*.bat` / `build_*.sh`) по исходному `.d` файлу
- показывает справку по Q-классам
- генерирует готовые блоки кода (сниппеты)
- создаёт скелеты новых приложений

---

## Содержание

1. [Быстрый старт](#быстрый-старт)
2. [Генерация build-скриптов](#генерация-build-скриптов)
3. [--update-all](#update-all)
4. [--scanqt](#scanqt)
5. [--info](#info)
6. [--snippet](#snippet)
7. [--new-app](#new-app)
8. [Справочник аргументов](#справочник-аргументов)

---

## Быстрый старт

```
cd arch_new
py generator/make_build.py test/test_qwidget.d
py generator/make_build.py --info QComboBox
py generator/make_build.py --snippet signal-slot QComboBox
py generator/make_build.py --new-app MyEditor --use QMainWindow,QTextEdit
py generator/make_build.py --update-all
```

---

## Генерация build-скриптов

Базовый режим: передать `.d` файл — получить `.bat` и `.sh` на stdout.

```
py generator/make_build.py test/test_qwidget.d
```

Скрипт автоматически:
1. Находит корень проекта (`arch_new/`) по наличию `d/qte56_core.d`
2. Сканирует все `d/gen/gen_*.d` — строит карту классов и граф зависимостей
3. Находит все `QClassName` в исходнике
4. Раскрывает транзитивные зависимости (например, `QWidget` → `gen_qbytearray`)
5. Генерирует команду с флагом `-i` (DMD компилирует импорты автоматически)
6. Добавляет `set PATH=...` и `QT_QPA_PLATFORM_PLUGIN_PATH` в `.bat`

### Записать в файл

```
py generator/make_build.py test/test_qwidget.d --bat test/build_qwidget.bat --sh test/build_qwidget.sh
```

### Изменить имя выходного exe

```
py generator/make_build.py myapp.d --out bin/myapp
```

### Пути Qt

Аргументов `--qt-path` / `--qt-mingw` в текущей версии нет. Пути по умолчанию —
константы `DEFAULT_QT_BIN` / `DEFAULT_QT_MINGW` в начале `make_build.py`
(`C:\Qt5_13_2\...`); автоматическое определение — через `--scanqt`.

### Пример сгенерированного .bat

```bat
@echo off
cd /d "%~dp0.."

echo === Compiling test_qwidget.d ===
dmd -m32 -i ^
    test\test_qwidget.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_qobject.d ^
    d\gen\gen_qfont.d ^
    d\gen\gen_qbytearray.d ^
    d\gen\gen_qwidget.d ^
    -Id -Id/gen ^
    -of=test\test_qwidget.exe

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: compilation failed!
    pause & exit /b 1
)

echo === Running ===
set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt5_13_2\5.13.2\mingw73_32\plugins\platforms
test\test_qwidget.exe

pause
```

---

## --update-all

Перегенерировать `test/build_*.bat` и `test/build_*.sh` для **всех** `test/test_*.d`:

```
py generator/make_build.py --update-all
```

Имена файлов: `test_qwidget.d` → `test/build_qwidget.bat` + `test/build_qwidget.sh`.

Комбинировать с `--scanqt` для автоматического определения путей Qt:

```
py generator/make_build.py --update-all --scanqt
```

---

## --scanqt

Сканирует дочерние папки рабочего каталога (CWD) в поисках Qt-файлов.

```
py generator/make_build.py --scanqt
```

Вывод:
```
Сканирование Qt в: C:\gpt\qte56\arch_new
  Qt bin (DLL)  : C:\gpt\qte56\arch_new\dist\WrenIDE  [найден]
  MinGW bin     : C:\gpt\qte56\arch_new\dist\WrenIDE  [найден]
  platforms     : C:\gpt\qte56\arch_new\dist\WrenIDE\platforms  [найден]
```

Что ищет:

| Категория | Windows | Linux |
|-----------|---------|-------|
| Qt bin    | `Qt5Core.dll`, `Qt5Widgets.dll` | `libQt5Core.so.5` |
| MinGW bin | `libgcc_s_dw2-1.dll` | — |
| platforms | `qwindows.dll` | `libqxcb.so` |

Найденные пути автоматически попадают в `set PATH=` и `QT_QPA_PLATFORM_PLUGIN_PATH`.
Если два пути совпадают (qt_bin == qt_mingw) — дубль убирается.

Варианты использования:

```
# Только показать, без генерации
py generator/make_build.py --scanqt

# Сгенерировать один файл с автопутями
py generator/make_build.py myapp.d --scanqt

# Перегенерировать все скрипты с автопутями
py generator/make_build.py --update-all --scanqt
```

---

## --info

Полная справка по Q-классу: модуль, файл, диапазон индексов, иерархия,
сигналы с сигнатурами коллбэков, события, список методов.

```
py generator/make_build.py --info QMediaPlayer
```

```
================================================================
  Класс    : QMediaPlayer
  Модуль   : gen_qmediaplayer
  Файл     : d/gen/gen_qmediaplayer.d
  Индексы  : 23000-23043  (44 функций)
  Иерархия : QMediaPlayer -> QObject

  Методы:
    hasSupport    media     mediaStream
    playlist      volume    isMuted
    ...
================================================================
```

> **Примечание (2026-08-02):** парсер классов понимает аннотацию `@live`
> (`@live class QComboBox`) и method chaining (методы возвращают класс,
> а не `void`) — `--info` работает для всех 139 классов.
> Сгенерированные signal-slot сниппеты следуют ABI биндингов:
> коллбэк `(void* dthis, int n, ...)`, string-параметр — `void* qs`
> (через `fromQString`), ESlot — `__gshared`.

---

## --snippet

Генерирует готовый D-код для вставки в проект. Выводится на stdout — можно
перенаправить в файл или скопировать.

```
py generator/make_build.py --snippet <ТИП> [АРГУМЕНТ]
```

> **Примечание (2026-08-02):** сниппеты по классу (`signal-slot`, `event`)
> работают для всех классов (парсер понимает `@live` и chaining).
> `check-funcs` берёт индексы напрямую из `registry/functions.csv`.

### Каталог сниппетов

---

#### `signal-slot CLASS`

Полный ESlot-блок для всех сигналов указанного класса.

```
py generator/make_build.py --snippet signal-slot QComboBox
```

```d
auto comboBox = new QComboBox(parent.getWH());

extern(C) void currentIndexChanged_i(int index) {
    writefln("currentIndexChanged_i: %s", index);
}
auto sl_currentIndexChanged_i = new ESlot(comboBox.getWH());
sl_currentIndexChanged_i.set(cast(void*)&currentIndexChanged_i);
comboBox.connect_currentIndexChanged_i(sl_currentIndexChanged_i);
// ... (все сигналы класса)
```

---

#### `event CLASS`

Блок `extern(C)` обработчиков событий (onMousePress, onKeyPress, onClose и др.)

```
py generator/make_build.py --snippet event QPushButton
```

```d
extern(C) void mousepress_handler(void* dthis, int x, int y, int button) {
    writeln("onMousePress");
}
pushButton.onMousePress(cast(void*)&mousepress_handler);
```

---

#### `app-min [TITLE]`

Минимальный скелет приложения: LoadQt + QApplication + QWidget + show + exec.

```
py generator/make_build.py --snippet app-min "My App"
```

```d
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import std.stdio : writeln;

void main() {
    LoadQt("./dll");
    auto app = new QApplication("My App");
    auto win = new QWidget(cast(void*)null);
    win.setWindowTitle("My App");
    win.resize(640, 480);
    win.show();
    app.exec();
    app.deleteApp();
}
```

---

#### `layout [CLASS]`

Виджет + layout (QVBoxLayout/QHBoxLayout/QGridLayout) + Label, LineEdit, Button.
Включает правильный вызов `disown()`.

```
py generator/make_build.py --snippet layout QVBoxLayout
```

---

#### `dialog`

QDialog с кнопками OK/Cancel, вложенными layout-ами, `exec()` и возвратом результата.

```
py generator/make_build.py --snippet dialog
```

```d
auto dlg = new QDialog(parent.getWH());
// ... layout, кнопки, сигналы
int result = dlg.exec();   // Accepted=1 / Rejected=0
```

---

#### `mdi`

QMdiArea + QMdiSubWindow по правильному паттерну проекта.

```
py generator/make_build.py --snippet mdi
```

> **Gotcha** из кода: `addSubWindow()` возвращает plain `void*` — не использовать
> `eQMdiSubWindow`. Создавать `QMdiSubWindow` вручную и вызывать `setWidget()`.
> В `onClose` сделать `editor.setParent(null)` до закрытия.

---

#### `model-view [table|tree]`

QTableWidget или QTreeWidget с заполнением данными и обработчиком выбора.

```
py generator/make_build.py --snippet model-view table
py generator/make_build.py --snippet model-view tree
```

Для `table` — заголовки колонок, цикл заполнения, `connect_cellClicked`.
Для `tree` — root/child items, `disown()` после `addTopLevelItem`, `expandAll`, `onItemClicked`.

---

#### `settings`

Полный цикл сохранения и восстановления геометрии окна через QSettings.

```
py generator/make_build.py --snippet settings
```

```d
// Save
auto s = new QSettings("./myapp.ini", 1);
s.setBytes("geometry", win.saveGeometry());
s.setBytes("state",    win.saveState());   // QMainWindow
s.sync();

// Restore
win.restoreGeometry(s.getBytes("geometry"));
win.restoreState(s.getBytes("state"));

// Other types
s.setValue("fontSize", 12);
int fontSize = s.getInt("fontSize", 12);
```

---

#### `file-io`

Чтение и запись файла через QFile: текст, бинарные данные, exists/size/remove.

```
py generator/make_build.py --snippet file-io
```

```d
auto f = new QFile("output.txt");
f.open(0x2);          // WriteOnly
f.writeText("Hello\n");
f.close();

f.open(0x1);          // ReadOnly
string text = f.readAllText();
f.close();

if (QFile.exists("output.txt"))
    QFile.remove("output.txt");
```

OpenMode константы: `0x1` ReadOnly, `0x2` WriteOnly, `0x3` ReadWrite, `0x4` Append, `0x20` Text.

---

#### `timer`

QTimer + connect_timeout, с комментарием про one-shot режим.

```
py generator/make_build.py --snippet timer
```

```d
auto timer = new QTimer();
auto slTick = new ESlot(timer.getWH());
slTick.set(cast(void*)&onTick);
timer.connect_timeout(slTick);
timer.start(500);   // каждые 500 мс

// One-shot:
// timer.setSingleShot(true); timer.start(2000);
```

---

#### `painter`

Скелет `onPaint` с QPainter: fillRect, setPen, drawText, drawRect, drawLine, end().

```
py generator/make_build.py --snippet painter
```

```d
extern(C) void paintHandler(void* dthis, void* painterPtr) {
    auto p = new QPainter(painterPtr, true);  // begin уже вызван Qt
    p.fillRect(0, 0, 400, 300, 0xFF1E1E2E);
    p.setPen(color.getWH());
    p.drawText(20, 40, "Hello from QPainter");
    p.drawRect(20, 60, 200, 100);
    p.end();   // обязательно перед return
}
widget.onPaint(cast(void*)&paintHandler);
widget.update();   // вызвать перерисовку
```

---

#### `tray`

QSystemTrayIcon: иконка, tooltip, контекстное меню, сигналы activated/messageClicked,
balloon notification.

```
py generator/make_build.py --snippet tray
```

---

#### `splash`

QSplashScreen: создание до `exec()`, showMessage, `processEvents()`, `finish(mainWin)`.

```
py generator/make_build.py --snippet splash
```

```d
auto splash = new QSplashScreen(pxm.getWH());
splash.show();
splash.showMessage("Loading...", 0x44, 0xFFFFFFFF);
app.processEvents();   // обязательно для отрисовки
// ... инициализация ...
splash.finish(win.getWH());
```

`0x44` = `Qt::AlignHCenter | Qt::AlignBottom`.

---

#### `check-funcs CLASS`

Генерирует диагностический блок: берёт реальные индексы из `registry/functions.csv`
и проверяет что `pFunQt[N] != null` для каждого.
Вставлять после `LoadQt()` при отладке портирования на новый компьютер.

```
py generator/make_build.py --snippet check-funcs QComboBox
```

```d
{
    static immutable int[] QComboBox_indices = [
        1400, 1401, 1402, ... 1460
    ];
    int nullCount = 0;
    foreach (i; QComboBox_indices) {
        if (pFunQt[i] is null) {
            writefln("  pFunQt[%d] = null  (QComboBox)", i);
            nullCount++;
        }
    }
    if (nullCount == 0)
        writeln("  QComboBox: all 56 functions OK");
    else
        writefln("  QComboBox: %d / 56 functions MISSING", nullCount);
}
```

---

#### `wren-bridge`

Скелет WrenVM: LoadWren, create, addLibPath, setWidget, interpret, call, resultString.
Включает кастомные write/error коллбэки.

```
py generator/make_build.py --snippet wren-bridge
```

---

### Таблица всех сниппетов

| Команда | Аргумент | Описание |
|---------|----------|----------|
| `signal-slot` | CLASS | ESlot-блок для всех сигналов |
| `event` | CLASS | `extern(C)` обработчики событий |
| `app-min` | [TITLE] | Минимальный скелет приложения |
| `layout` | [CLASS] | Виджет + layout + дочерние |
| `dialog` | — | QDialog OK/Cancel |
| `mdi` | — | QMdiArea + QMdiSubWindow |
| `model-view` | [table\|tree] | Таблица или дерево с данными |
| `settings` | — | save/restore геометрии + QSettings |
| `file-io` | — | QFile read/write/exists/remove |
| `timer` | — | QTimer + connect_timeout |
| `painter` | — | onPaint + QPainter draw-блок |
| `tray` | — | QSystemTrayIcon полный блок |
| `splash` | — | QSplashScreen загрузочный экран |
| `check-funcs` | CLASS | Диагностика pFunQt индексов |
| `wren-bridge` | — | WrenVM скелет |

---

## --new-app

Создаёт готовый к компиляции `APPNAME.d` + `build_APPNAME.bat` + `build_APPNAME.sh`
с правильными импортами и шаблонным кодом для каждого класса.

```
py generator/make_build.py --new-app MyEditor --use QMainWindow,QTextEdit,QMenuBar,QStatusBar
```

Созданные файлы:
```
MyEditor.d
build_MyEditor.bat
build_MyEditor.sh
```

Сгенерированный `MyEditor.d`:
```d
/**
 * MyEditor.d — generated by make_build.py
 */
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qframe;
import gen_qabstractscrollarea;
import gen_qmainwindow;
import gen_qmenubar;
import gen_qstatusbar;
import gen_qtextedit;
import std.stdio : writeln, writefln;

void main() {
    LoadQt("./dll");
    auto app = new QApplication("MyEditor");

    auto win = new QMainWindow(cast(void*)null);
    win.setWindowTitle("MyEditor");
    win.resize(800, 600);
    auto editor = new QTextEdit(win.getWH());
    editor.setPlainText("Hello from MyEditor");
    auto menuBar = win.menuBar();
    auto menuFile = menuBar.addMenu("File");
    menuFile.addAction("Exit");
    auto statusBar = win.statusBar();
    statusBar.showMessage("Ready");

    win.show();
    app.exec();
    app.deleteApp();
}
```

### Поддерживаемые классы для --use

| Класс | Шаблонный код |
|-------|---------------|
| `QMainWindow` | create + setWindowTitle + resize |
| `QWidget` | create + setWindowTitle + resize |
| `QDialog` | create + setWindowTitle |
| `QTextEdit` | create(win) + setPlainText |
| `QPlainTextEdit` | create(win) |
| `QPushButton` | create("Click me", win) |
| `QLabel` | create("Label", win) |
| `QLineEdit` | create(win) |
| `QListWidget` | create(win) |
| `QTreeWidget` | create(win) + setColumnCount + setHeaderLabels |
| `QTableWidget` | create(win) + setRowCount + setColumnCount |
| `QVBoxLayout` | create + setLayout + disown |
| `QHBoxLayout` | create + setLayout + disown |
| `QMenuBar` | win.menuBar() + addMenu + addAction |
| `QStatusBar` | win.statusBar() + showMessage |
| `QToolBar` | addToolBar + addAction |
| `QSplitter` | create(Horizontal, win) |
| `QTabWidget` | create(win) + addTab |
| `QComboBox` | create(win) + addItem ×2 |

Если главный класс (`QMainWindow`, `QWidget`, `QDialog`) не указан — автоматически
добавляется `QWidget`.

Комбинировать с `--scanqt` для записи найденных Qt-путей в build-скрипты:

```
py generator/make_build.py --new-app MyApp --use QMainWindow,QTextEdit --scanqt
```

---

## Справочник аргументов

| Аргумент | Описание |
|----------|----------|
| `source` | Путь к `.d` файлу для анализа |
| `--out PATH` | Имя выходного исполняемого файла (без расширения) |
| `--bat FILE` | Записать `.bat` в файл вместо stdout |
| `--sh FILE` | Записать `.sh` в файл вместо stdout |
| `--update-all` | Перегенерировать все `test/build_*.bat` и `.sh` |
| `--scanqt` | Автопоиск Qt-файлов в дочерних папках CWD |
| `--info CLASS` | Справка по Q-классу: модуль, индексы, сигналы, методы |
| `--snippet TYPE [ARG]` | Генерация блока кода (см. таблицу сниппетов) |
| `--new-app NAME` | Создать скелет приложения `NAME.d` + build-скрипты |
| `--use Q1,Q2,...` | Список классов для `--new-app` |

---

## Алгоритм работы (техническое)

```
make_build.py source.d
    │
    ├── find_arch_root()          найти arch_new/ по d/qte56_core.d
    ├── scan_gen_modules()        сканировать d/gen/gen_*.d:
    │     class_map {QFoo → gen_qfoo}
    │     dep_map   {gen_qfoo → [gen_qwidget, gen_qbytearray, ...]}
    ├── scan_source()             найти Q-классы в исходнике (regex Q[A-Z][a-z]\w+)
    │     исключить: QCLASS_BLACKLIST (QString, QVariant, ...)
    │     исключить: QCORE_BUILTINS (QApplication, ESlot, ...)
    ├── resolve_deps()            транзитивное замыкание зависимостей
    ├── order_modules()           BASE_ORDER + sorted остальные
    ├── gen_bat()                 Windows: обратные слэши, дедупликация PATH
    └── gen_sh()                  Linux: ldc2/dmd, rpath, LD_LIBRARY_PATH
```

### Детектирование специальных модулей

Помимо Q-классов, скрипт ищет идентификаторы:

| Идентификаторы | Добавляемый файл |
|----------------|-----------------|
| `QForm`, `findLabel`, `findWidget` | `d/qte56_forms.d` |
| `applyQss`, `QssTheme` | `d/qte56_style.d` |
| `WrenVM`, `LoadWren` | `d/wren/wren_vm.d` |
| `Term`, `TermTable` | `d/qte56_term.d` |
| `QtE`, `FrameShape`, `TabPosition` | `d/qte56_enums.d` |
