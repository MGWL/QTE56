# QTE56 Build System — Knowledge Transfer

> ↑ Навигация: [AGENTS.md](AGENTS.md)

Документ для AI-ассистента. Содержит исчерпывающее описание системы сборки проекта QTE56: C++ DLL обёртки над Qt 5.13.2, D-биндинги, тесты. Написан плотно, без воды. Все команды проверены из исходников.

---

## 1. Окружение (Environment Setup)

### Корневая директория проекта
```
H:\qte56\arch_new\
```
Все пути в bat-скриптах строятся относительно неё (`cd /d "%~dp0"` или `cd /d "%~dp0.."`).

### Qt и MinGW (Windows, 32-bit)

| Переменная | Значение |
|---|---|
| `QT_BIN` | `C:\Qt5_13_2\5.13.2\mingw73_32\bin` |
| `MINGW_BIN` | `C:\Qt5_13_2\Tools\mingw730_32\bin` |
| `QTDIR` | `C:\Qt5_13_2\5.13.2\mingw73_32` |

Установка PATH (начало каждого bat-скрипта):
```bat
set "QT_BIN=C:\Qt5_13_2\5.13.2\mingw73_32\bin"
set "MINGW_BIN=C:\Qt5_13_2\Tools\mingw730_32\bin"
set "PATH=!QT_BIN!;!MINGW_BIN!;!PATH!"
```

Более короткий вариант (в test-скриптах):
```bat
set QTDIR=C:\Qt5_13_2\5.13.2\mingw73_32
set MINGW=C:\Qt5_13_2\Tools\mingw730_32\bin
set PATH=%QTDIR%\bin;%MINGW%;%PATH%
```

Команды, доступные после установки PATH: `qmake`, `mingw32-make`, `g++`.

### D-компилятор
- Windows: `dmd` (должен быть в системном PATH, флаг `-m32` обязателен).
- Linux: `ldc2` (предпочтительнее; `dmd` — запасной вариант).

### Linux-зависимости (Fedora)
```bash
sudo dnf install qt5-qtbase-devel qt5-qttools-devel qt5-qtsql qt5-qtsql-devel gcc-c++ make ldc
```

---

## 2. Сборка C++ DLL: qmake → mingw32-make

### Стандартный workflow (Windows)

```bat
cd cpp\qt5\<dirname>
qmake <name>.pro -spec win32-g++
mingw32-make --no-print-directory
```

После сборки DLL появляется в `arch_new\dll\dll32\<name>.dll` (для win32_qt5; задаётся в `.pro` через выбор `DESTDIR` по `QTE56_ARCH`: `dll/dll32` или `dll/dll64`).

### Стандартный workflow (Linux)

```bash
cd cpp/qt5/<dirname>
rm -f *.o Makefile Makefile.Debug Makefile.Release
qmake-qt5 <name>.pro -spec linux-g++ CONFIG+=release
make -j$(nproc)
```

После сборки `.so` появляется в `arch_new/lib/lib<name>.so` (задаётся в `.pro` через `unix: DESTDIR = ../../../lib`).

### Структура .pro файла (пример: qte56_widgets.pro)

```qmake
QT       += core widgets
TARGET    = qte56_widgets
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release

DEFINES  += QTE56_QWIDGET_BUILD QTE56_QFRAME_BUILD ...   # по одному на каждый модуль
# Выбор папки назначения по QTE56_ARCH (по умолчанию 32):
QTE56_ARCH = $$(QTE56_ARCH)
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib

INCLUDEPATH += ../../qte56_qwidget ../../qte56_qframe ...
SOURCES  += ../../qte56_qwidget/qte56_qwidget.cpp ...
HEADERS  += ../../qte56_qwidget/qte56_qwidget.h ...
```

Каждый исходный C++ модуль живёт в `cpp/qt5/qte56_<name>/qte56_<name>.{cpp,h}`. Merged DLL объединяет несколько таких модулей в один .pro без дублирования исходников (каждый .cpp и .h включается из своей исходной директории через `INCLUDEPATH` + `SOURCES`).

---

## 3. build_merged_dlls.bat — Windows: полная сборка всех DLL

**Файл:** `H:\qte56\arch_new\build_merged_dlls.bat`

Скрипт — тонкая обёртка над `build_merged_dlls.py` (требует `python` в PATH):

```bat
build_merged_dlls.bat
```

Вся логика — в `build_merged_dlls.py`. Целевая архитектура задаётся
переменной окружения `QTE56_ARCH` (обычно выставляется через `a.cmd` →
`local.env.bat`):

| QTE56_ARCH | Платформа | Результат |
|---|---|---|
| `win32_qt5` | Windows 32-bit, Qt5 | `dll/dll32/` |
| `win64_qt6` | Windows 64-bit, Qt6 | `dll/dll64/` |
| `linux64_qt5` / `linux64_qt6` | Linux 64-bit | `lib/` |

Для каждого проекта: `qmake <name>.pro` → `mingw32-make` (Windows) /
`make` (Linux). Исходники — `cpp/qt5/qte56_*` (или `cpp/qt6/` для Qt6).

### Порядок сборки (build_merged_dlls.py)

1. **Core**: `qte56_qcore`
2. **Merged groups** (× 6): `qte56_foundation`, `qte56_widgets`, `qte56_views`,
   `qte56_text`, `qte56_dialogs`, `qte56_mainwin`
3. **Special DLLs** (× 20): `qte56_drawing`, `qte56_qsql` (out: `qte56_sql` —
   заметить разницу имён dir vs dll), `qte56_systray`, `qte56_resource`,
   `qte56_uiloader`, `qte56_qprocess`, `qte56_thread`, `qte56_qscintilla`,
   `qte56_network`, `qte56_curl`, `qte56_qcompleter` (out: `qte56_completer`),
   `qte56_shortcut`, `qte56_filewatcher`, `qte56_desktop`, `qte56_textcodec`,
   `qte56_qsound`, `qte56_qsoundeffect`, `qte56_qmediaplayer`,
   `qte56_qgraphicsscene`, `qte56_qxlsx`
4. **Turbo Vision**: `tvision/build_tvision.bat` (отдельный скрипт, не-Qt)
5. **Wren bridge**: `wren/c/wren_bridge.pro` (если файл существует)

### Итоговый check

Скрипт выводит счётчик успешных сборок:
```
Results: N / N succeeded
```

### Gotchas для bat-файлов

- **Нельзя использовать кириллицу** в bat-файлах — `cmd.exe` в UTF-8 режиме её ломает.
- **Нельзя использовать многострочные `if`-блоки** (`if ... ( многострочно )`) — cmd.exe их некорректно разбирает при `enabledelayedexpansion`. Всё на одной строке через `&`.
- Переменные со `!..!` работают только внутри блоков с `setlocal enabledelayedexpansion`.

---

## 4. build_merged_dlls.sh — Linux: полная сборка всех .so

**Файл:** `H:\qte56\arch_new\build_merged_dlls.sh`

Запуск из `arch_new/`:
```bash
bash build_merged_dlls.sh
bash build_merged_dlls.sh --verbose
bash build_merged_dlls.sh --no-wren
bash build_merged_dlls.sh --no-scintilla
bash build_merged_dlls.sh --system-scintilla
```

### Ключевые отличия от bat

| Аспект | Windows (bat) | Linux (sh) |
|---|---|---|
| Spec | `win32-g++` | `linux-g++` |
| CONFIG | (не задаётся) | `CONFIG+=release` |
| DESTDIR | `dll/dll32` (win32_qt5) / `dll/dll64` (win64_qt6) | `lib/` |
| Параллелизм | `mingw32-make` (одиночный) | `make -j$(nproc)` |
| qmake | `qmake` (фиксированный) | `qmake-qt5` или `qmake` (autodetect) |
| Очистка | — | `rm -f *.o Makefile Makefile.{Debug,Release}` перед каждой сборкой |

### Автодетект qmake

```bash
QMAKE=$(which qmake-qt5 2>/dev/null || which qmake 2>/dev/null || echo "")
# Проверка версии Qt:
QT_VER=$("$QMAKE" --version 2>&1 | grep -o 'Qt version [0-9]*' | grep -o '[0-9]*')
# Должно быть "5"
```

### QScintilla на Linux

Три режима (определяется автоматически через `pkg-config`):

1. **Системная QScintilla** (`pkg-config --exists qscintilla2_qt5`): флаг `SCINTILLA_SYSTEM=1`, собирается только `qte56_qscintilla.pro`.
2. **Из исходников** (есть `QScintilla_gpl-2.11.2/Qt4Qt5/qscintilla.pro`): сначала собирается сама QScintilla, потом `qte56_qscintilla.pro`.
3. **Отключена** (`--no-scintilla`): пропускается.

### Порядок сборки (Linux)

0. QScintilla из исходников (если нужна)
1. `cpp/qt5/qte56_qcore` → `qte56_qcore` (путь `cpp/$QTE56_QTDIR/...`: qt5 или qt6)
2. Merged groups × 6 из `cpp/qt5/merged/` (те же, что на Windows)
3. Special DLLs × 19 (drawing, sql, systray, resource, uiloader, qprocess, thread,
   network, curl, completer, shortcut, filewatcher, desktop, textcodec, qsound,
   qsoundeffect, qmediaplayer + `qte56_qscintilla` если QScintilla доступна)
4. Turbo Vision: `bash tvision/build_tvision.sh`
5. Wren bridge: `wren/c/wren_bridge.pro`

---

## 5. Состав DLL-групп

### Merged groups — состав модулей

| DLL | Количество модулей | Основные Qt-классы |
|---|---|---|
| `qte56_foundation` | 10 | QAction, QMenu, QMenuBar, QTimer, QIcon, QDialog, QMessageBox, QScrollArea, QDockWidget, QToolBox |
| `qte56_widgets` | 26 | QWidget, QFrame, QLabel, QPushButton, QCheckBox, QRadioButton, QComboBox, QLineEdit, QSpinBox, QDoubleSpinBox, QSlider, QDial, QScrollBar, QProgressBar, QGroupBox, QTabWidget, QTabBar, QLCDNumber, QCalendarWidget, QLayout, QAbstractButton, QAbstractSlider, QAbstractSpinBox, QSplitter, QStackedWidget, QDateTimeEdit |
| `qte56_views` | 11 | QAbstractItemView, QTableView, QTableWidget, QTreeView, QTreeWidget, QHeaderView, QListWidget, QMdiArea, QMdiSubWindow, QAbstractScrollArea, QSettings |
| `qte56_text` | 8 | QTextEdit, QPlainTextEdit, QTextBrowser, QTextDocument, QTextCursor, QTextCharFormat, QTextBlockFormat, QTextBlock + QSyntaxHighlighter |
| `qte56_dialogs` | 7 | QFileDialog, QFontDialog, QColorDialog, QInputDialog, QProgressDialog, QColor, QFont |
| `qte56_mainwin` | 10 | QMainWindow, QToolBar, QStatusBar, QToolButton, QCommandLinkButton, QPainter, QImage, QImageReader, QImageWriter, QPicture |

### Special standalone DLLs

| DLL | Исходник (.pro) | Описание |
|---|---|---|
| `qte56_qcore` | `cpp/qt5/qte56_qcore/qte56_qcore.pro` | QApplication, QObject, QCoreApplication |
| `qte56_drawing` | `cpp/qt5/qte56_drawing/qte56_drawing.pro` | QPen, QBrush, QPalette, QFontMetrics, QSplashScreen |
| `qte56_sql` | `cpp/qt5/qte56_qsql/qte56_qsql.pro` | QSqlDatabase, QSqlQuery, QSqlTableModel (dir=qte56_qsql, dll=qte56_sql) |
| `qte56_systray` | `cpp/qt5/qte56_systray/qte56_systray.pro` | QSystemTrayIcon |
| `qte56_resource` | `cpp/qt5/qte56_resource/qte56_resource.pro` | QResource, QUiLoader |
| `qte56_uiloader` | `cpp/qt5/qte56_uiloader/qte56_uiloader.pro` | QUiLoader |
| `qte56_qprocess` | `cpp/qt5/qte56_qprocess/qte56_qprocess.pro` | QProcess |
| `qte56_qscintilla` | `cpp/qt5/qte56_qscintilla/qte56_qscintilla.pro` | QScintilla editor widget |
| `qte56_tvision` | `tvision/build_tvision.{bat,sh}` | Turbo Vision TUI (не-Qt, C++17) |
| `qte56_network` | `cpp/qt5/qte56_network/qte56_network.pro` | QUrl, QNetworkRequest, QNetworkReply, QNetworkAccessManager |
| `qte56_curl` | `cpp/qt5/qte56_curl/qte56_curl.pro` | libcurl через LoadLibrary (без Qt-зависимостей) |
| `qte56_thread` | `cpp/qt5/qte56_thread/qte56_thread.pro` | QThread, QMutex, QWaitCondition, QSemaphore, QReadWriteLock |
| `qte56_completer` | `cpp/qt5/qte56_completer/qte56_completer.pro` | QCompleter |
| `qte56_shortcut` | `cpp/qt5/qte56_shortcut/qte56_shortcut.pro` | QShortcut |
| `qte56_filewatcher` | `cpp/qt5/qte56_filewatcher/qte56_filewatcher.pro` | QFileSystemWatcher |
| `qte56_desktop` | `cpp/qt5/qte56_desktop/qte56_desktop.pro` | QDesktopWidget (screenGeometry, centeredPos) |
| `wren_bridge` | `wren/c/wren_bridge.pro` | Wren VM bridge для D |

---

## 6. Сборка D-тестов: структура dmd-команды

### Минимальный шаблон (Windows)

```bat
@echo off
cd /d "%~dp0.."

dmd -m32 ^
    test\<test_name>.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\qte56_enums.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_<module1>.d ^
    d\gen\gen_<module2>.d ^
    -Id -Id\gen ^
    -of=test\<test_name>.exe

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: D compilation failed!
    pause & exit /b 1
)

set PATH=%~dp0..\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
test\<test_name>.exe
pause
```

### Include paths для D

| Флаг | Что включает |
|---|---|
| `-Id` | `d/qte56_core.d`, `d/qte56_loader.d`, `d/qte56_enums.d` и вспомогательные модули |
| `-Id\gen` | Все `d/gen/gen_*.d` файлы |
| `-I.` | Корень проекта (используется в build_qprocess.bat: `-I. -Id\gen`) |

В `build_linux.sh` используется: `DFLAGS="-I. -Id/gen"`.

### Обязательные D-модули (почти всегда)

```
d/qte56_core.d        — pFunQt[], generateAlias(), generateFunQt()
d/qte56_loader.d      — LoadQt(), UnloadQt(), registerModule()
d/qte56_enums.d       — QtE enum, FrameShape, TabPosition и др.
d/gen/gen_qcore.d     — QApplication, базовые функции Qt
```

Дополнительные модули подключаются по необходимости. Порядок: сначала базовые классы, потом производные.

### Примеры с конкретными модулями

**Тест с раскладками (test_layouts_ext):**
```bat
dmd -m32 ^
    test\test_layouts_ext.d ^
    d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qobject.d d\gen\gen_qwidget.d ^
    d\gen\gen_qframe.d d\gen\gen_qlayout.d d\gen\gen_qfont.d ^
    d\gen\gen_qabstractbutton.d d\gen\gen_qpushbutton.d d\gen\gen_qlineedit.d ^
    -Id -Id\gen ^
    -of=test\test_layouts_ext.exe
```

**Тест QProcess:**
```bat
dmd -m32 -I. -Id\gen -oftest\test_qprocess.exe ^
    test\test_qprocess.d ^
    d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qprocess.d
```

**Тест SQL:**
```bat
dmd -m32 ^
    test/test_qsql.d ^
    d/qte56_core.d d/qte56_loader.d ^
    d/gen/gen_qcore.d d/gen/gen_qsql.d ^
    -Id ^
    -of=test/test_qsql.exe
```

**Тест QScintilla (нужны два DLL в PATH):**
```bat
dmd -m32 ^
    test/test_qscintilla.d ^
    d/qte56_core.d d/qte56_loader.d d/qte56_enums.d ^
    d/gen/gen_qcore.d d/gen/gen_qobject.d d/gen/gen_qfont.d ^
    d/gen/gen_qwidget.d d/gen/gen_qframe.d ^
    d/gen/gen_qabstractscrollarea.d d/gen/gen_qscintilla.d ^
    -Id -Id/gen ^
    -of=test/test_qscintilla.exe
```

**Тест Wren (без Qt, без gen_* модулей):**
```bat
dmd -m32 ^
    test\test_wren_vba.d ^
    wren\d\wren_vm.d ^
    -Iwren\d ^
    -of=test\test_wren_vba.exe
```

---

## 7. Запуск тестов (Windows)

### Отдельный тест через bat-скрипт

```bat
:: Рекомендуемый способ:
test\build_<name>.bat

:: Или вручную после сборки:
set PATH=%~dp0dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
test\<name>.exe
```

Все bat-скрипты тестов живут в `arch_new\test\build_*.bat` и сами устанавливают PATH.

### Полный список тестовых bat-скриптов (выборка)

`build_layouts_ext.bat`, `build_layouts_inputdialog.bat`, `build_qsql.bat`, `build_qprocess.bat`, `build_systray.bat`, `build_qscintilla.bat`, `build_drawing.bat`, `build_hierarchy_nogui.bat`, `build_variant3.bat`, `build_qpixmap.bat`, `build_qtextdocument.bat`, `build_qfile.bat`, `build_enums.bat`, `build_rect.bat`, `build_strings.bat`, `build_qstringlist.bat`, `build_wren_vba.bat`, `build_wren_libs.bat`, `build_wren_loader.bat`, `build_wren_ole.bat`, `build_term.bat`, `build_tv_hello.bat`, `build_clipboard_btngroup.bat`, `build_datetime_calendar.bat`, `build_qpixmap.bat`, `build_forms.bat`, `build_gui_qwidget.bat` и др.

---

## 8. Linux: сборка и запуск тестов

**Файл:** `H:\qte56\arch_new\test\build_linux.sh`

### Использование

```bash
# Один конкретный тест (default: test_layouts_ext):
bash test/build_linux.sh

# Конкретный тест:
bash test/build_linux.sh test_qsql

# Все тесты:
bash test/build_linux.sh all

# Только сборка, без запуска:
bash test/build_linux.sh all --no-run
```

### D-компилятор на Linux

```bash
DMD=$(which ldc2 2>/dev/null || which dmd 2>/dev/null || echo "")
```

`ldc2` предпочтительнее — он строже и ловит больше ошибок на этапе компиляции.

### Флаги компиляции (Linux)

```bash
DFLAGS="-I. -Id/gen"
RPATH="-L-Wl,-rpath,\$ORIGIN/../lib"
```

Флаг `RPATH` прописывает путь к `.so` относительно исполняемого файла. Без него нужно задавать `LD_LIBRARY_PATH` при каждом запуске.

### Общие D-модули (COMMON_D — всегда включаются на Linux)

```bash
COMMON_D=(
    d/qte56_core.d
    d/qte56_loader.d
    d/qte56_enums.d
    d/gen/*.d          # ВСЕ gen-модули через glob
    d/qte56_style.d
    d/qte56_resource.d
    d/qte56_forms.d
)
```

На Linux через glob включаются все `gen/*.d` сразу — в отличие от Windows, где каждый модуль указывается явно.

### Запуск теста на Linux

```bash
LD_LIBRARY_PATH=./lib test/<name>
```

`./lib` содержит все `.so` файлы, собранные `build_merged_dlls.sh`.

### Специальные тесты на Linux

Тест `test_wren_loader` требует дополнительного модуля:
```bash
case "$name" in
    test_wren_loader) EXTRA_D=(wren/d/wren_vm.d) ;;
esac
```

### Список всех консольных тестов (ALL_TESTS — 37 штук)

```
test_clipboard_btngroup   test_datetime_calendar    test_drawing
test_enums                test_fls                  test_font_header
test_forms                test_hierarchy_nogui      test_layouts_ext
test_layouts_inputdialog  test_load                 test_qaction
test_qapp_methods         test_qcalendarwidget      test_qcolor_dialogs
test_qdatetimeedit        test_qfile                test_qmessagebox
test_qobject_hier         test_qpixmap              test_qresource
test_qscintilla           test_qsql                 test_qss_style
test_qtabbar              test_qtabwidget            test_qtextbrowser
test_qtextdocument        test_qtoolbutton           test_strings
test_systray              test_variant3              test_variant3_full
test_wren_loader          test_rect                  test_qprocess
test_qstringlist          test_textedit_lines
```

---

## 9. Отличия Linux от Windows (критические)

### ldc2 строже dmd

Известные проблемы, которые компилируются dmd но не ldc2:

1. **`gen_qdatetimeedit.d`**: требует явного конструктора `this(bool _noOp) { super(_noOp); }` вместо пустого `this() {}`.
2. **`gen_qsplitter.d`**: неверный каст типа — должен быть `t_qp__qp_i_qp` (не `t_qp__qp_qp`).

### RTLD_GLOBAL при dlopen

На Linux `dlopen` должен использовать флаг `RTLD_GLOBAL` чтобы символы из одной `.so` были видны другим. Это уже учтено в `qte56_loader.d`.

### Fallback-пути для LoadQt / LoadWren

```d
// Автоматический fallback: сначала ./dll, потом ./lib
LoadQt("./dll")   // Windows-первый вариант
// при неудаче — пробует ./lib автоматически
```

### .so именование

Функция `soName()` в `qte56_loader.d` автоматически конвертирует `foo.dll` → `libfoo.so`. Пользовательский код указывает dll-имя — загрузчик сам выбирает нужный формат.

---

## 10. Добавление нового DLL в систему сборки

### Шаг 1: Создать C++ исходники

Если standalone DLL:
```
cpp/qt5/qte56_<name>/
    qte56_<name>.h
    qte56_<name>.cpp
    qte56_<name>.pro
```

Если добавление в существующую merged группу — добавить `.cpp`/`.h` в соответствующий `cpp/qt5/merged/<group>/<group>.pro`.

### Шаг 2: Создать .pro файл

Минимальный шаблон (для standalone из `cpp/qt5/qte56_<name>/`):
```qmake
QT       += core widgets
TARGET    = qte56_<name>
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release

DEFINES  += QTE56_<NAME>_BUILD

# Выбор папки назначения по QTE56_ARCH (по умолчанию 32)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) { QTE56_ARCH = 32 }
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib

INCLUDEPATH += .
SOURCES  += qte56_<name>.cpp
HEADERS  += qte56_<name>.h
```

(Пути `DESTDIR` зависят от глубины расположения: `cpp/qt5/<name>/` → `../../../`, `cpp/qt5/merged/<name>/` → `../../../../`.)

### Шаг 3: Добавить в build_merged_dlls.py

`build_merged_dlls.bat` — обёртка над `build_merged_dlls.py`; новый DLL
добавляется в список specials в `build_merged_dlls.py`:

```python
("qte56_<name>", "qte56_<name>"),
```

### Шаг 4: Добавить в build_merged_dlls.sh

```bash
build_one "cpp/$QTE56_QTDIR/qte56_<name>" "qte56_<name>" "qte56_<name>.pro"
```

### Шаг 5: Создать D-биндинг

```
d/gen/gen_<name>.d
```

Шаблон модуля (обязательные части):
```d
module gen_<name>;
import qte56_core, qte56_loader;

// Индексный диапазон: взять свободную дыру из `tools/qte/qte.exe index gaps`
// (pFunQt[25000] заполнен, макс. занятый индекс 24713 на 2026-08-02)

static this() {
    registerModule("Q<Name>", "qte56_<name>.dll", &loadQ<Name>);
}

void loadQ<Name>() {
    mixin(generateFunQt(<idx>, "qteQ<Name>_create", "Q<Name>"));
    // ...
}

// Функции-обёртки через pFunQt[idx]
```

### Шаг 6: Обновить registry/functions.csv

Добавить строки с новыми функциями — это источник истины для генератора (`generator/main.py`).

---

## 11. Добавление нового теста

### Windows: создать bat-скрипт

Создать `arch_new\test\build_<testname>.bat`:

```bat
@echo off
cd /d "%~dp0.."

echo === Compiling <testname>.d ===
dmd -m32 ^
    test\<testname>.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\qte56_enums.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_<needed_module>.d ^
    -Id -Id\gen ^
    -of=test\<testname>.exe

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: D compilation failed!
    pause & exit /b 1
)

echo.
echo === Running ===
set PATH=%~dp0..\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
test\<testname>.exe

pause
```

### Linux: добавить в build_linux.sh

В массив `ALL_TESTS`:
```bash
ALL_TESTS=(
    ...
    <testname>
)
```

Если тест требует дополнительных D-модулей (кроме `COMMON_D`), добавить в `case`:
```bash
case "$name" in
    test_wren_loader) EXTRA_D=(wren/d/wren_vm.d) ;;
    <testname>)       EXTRA_D=(some/extra/module.d) ;;
esac
```

---

## 12. Deploy checklist: что должно быть в PATH / рядом с .exe

### Обязательно для всех Qt-программ (Windows)

Должны быть доступны через PATH или рядом с .exe:
```
C:\Qt5_13_2\5.13.2\mingw73_32\bin\Qt5Core.dll
C:\Qt5_13_2\5.13.2\mingw73_32\bin\Qt5Gui.dll
C:\Qt5_13_2\5.13.2\mingw73_32\bin\Qt5Widgets.dll
C:\Qt5_13_2\Tools\mingw730_32\bin\libgcc_s_dw2-1.dll
C:\Qt5_13_2\Tools\mingw730_32\bin\libstdc++-6.dll
C:\Qt5_13_2\Tools\mingw730_32\bin\libwinpthread-1.dll
```

Стандартная установка PATH для тестов:
```bat
set PATH=%~dp0..\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
```

### QTE56 DLL (из arch_new\dll\dll32\)

Подключать только то, что использует программа. Минимум:
```
dll\dll32\qte56_qcore.dll
dll\dll32\qte56_widgets.dll   (или другие merged-группы по необходимости)
```

Таблица по функциональности:

| Функциональность | Требуемый DLL |
|---|---|
| Базовые виджеты | `qte56_widgets.dll` |
| Действия, меню, диалоги | `qte56_foundation.dll` |
| Таблицы, деревья | `qte56_views.dll` |
| Текстовые редакторы | `qte56_text.dll` |
| Файловые/цвет/шрифт диалоги | `qte56_dialogs.dll` |
| Главное окно, тулбары | `qte56_mainwin.dll` |
| Рисование (QPen, QBrush) | `qte56_drawing.dll` |
| SQL | `qte56_sql.dll` + `dll\sqldrivers\qsqlite.dll` |
| Системный трей | `qte56_systray.dll` |
| QResource, QUiLoader | `qte56_resource.dll` / `qte56_uiloader.dll` |
| QProcess | `qte56_qprocess.dll` |
| QScintilla | `qte56_qscintilla.dll` + `qscintilla2_qt5.dll` |
| Turbo Vision | `qte56_tvision.dll` |
| HTTP/HTTPS (Qt) | `qte56_network.dll` |
| HTTP/HTTPS (curl) | `qte56_curl.dll` (+ `libcurl.dll` / `libcurl-x32.dll`) |
| Потоки, мьютексы | `qte56_thread.dll` |
| Autocomplete | `qte56_completer.dll` |
| Горячие клавиши | `qte56_shortcut.dll` |
| Мониторинг файлов | `qte56_filewatcher.dll` |
| Геометрия экрана | `qte56_desktop.dll` |
| Wren скриптинг | `wren_bridge.dll` |

---

## 13. QScintilla: два DLL обязательны

QScintilla требует **два** DLL в PATH одновременно:

```
dll\dll32\qte56_qscintilla.dll    — обёртка QTE56
dll\dll32\qscintilla2_qt5.dll     — сама библиотека QScintilla (не входит в Qt)
```

Комментарий прямо в `build_qscintilla.bat`:
```bat
rem dll/ must be in PATH so qscintilla2_qt5.dll is found as dependency
set PATH=%~dp0..\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
```

`qscintilla2_qt5.dll` должна лежать в `arch_new\dll\dll32\`. При отсутствии — ошибка загрузки DLL при старте программы, не ошибка компиляции.

На Linux: `libqscintilla2_qt5.so` должна быть в `arch_new/lib/` или установлена системно (`sudo dnf install qscintilla-qt5-devel`).

---

## 14. SQL: подкаталог sqldrivers/

Qt SQL-драйверы загружаются как плагины. SQLite требует:

```
<каталог с exe>\sqldrivers\qsqlite.dll
```

или

```
dll\sqldrivers\qsqlite.dll   (если dll\ в PATH)
```

`qsqlite.dll` находится в:
```
C:\Qt5_13_2\5.13.2\mingw73_32\plugins\sqldrivers\qsqlite.dll
```

Нужно скопировать вручную перед тестом. В `build_qsql.bat` это не автоматизировано — PATH установлен на `C:\Qt5_13_2\5.13.2\mingw73_32\bin`, что позволяет Qt найти плагин через стандартный механизм поиска плагинов Qt (Qt ищет `plugins/sqldrivers/` относительно своего `bin/`).

---

## 15. Типичные ошибки сборки и решения

### C++ / qmake

| Ошибка | Причина | Решение |
|---|---|---|
| `qmake: command not found` | PATH не установлен | Добавить `C:\Qt5_13_2\5.13.2\mingw73_32\bin` в PATH |
| `mingw32-make: command not found` | MinGW не в PATH | Добавить `C:\Qt5_13_2\Tools\mingw730_32\bin` |
| `FAIL (qmake)` в bat | Ошибка в `.pro` файле или неверный spec | Запустить qmake вручную без `>nul` для вывода ошибок |
| `FAIL (make)` в bat | C++ ошибка компиляции | Запустить `mingw32-make` без `>nul` |
| `CHECK FAIL: built N, but found M` | Добавлен новый `.pro` файл, не указан в списке счётчика | Добавить DLL в bat/sh секцию подсчёта |
| `.so не появился в lib/` | Нет `unix: DESTDIR` в `.pro` | Проверить `.pro` — нужно `unix: DESTDIR = ../../../lib` |

### D-компиляция

| Ошибка | Причина | Решение |
|---|---|---|
| `Error: module not found` | Не указан `-Id` или `-Id\gen` | Добавить нужные `-I` флаги |
| `undefined identifier gen_*` | Не подключён нужный gen-модуль | Добавить `d\gen\gen_<name>.d` в команду dmd |
| Конфликт `this()` с `this(void*)` | Двойной конструктор | Использовать `cast(void*)null` при вызове нужной перегрузки |
| ldc2: `constructor ... is not callable` | ldc2 строже dmd по конструкторам | Добавить явный `this(bool _noOp) { super(_noOp); }` |
| ldc2: неверный каст | ldc2 строже по типам | Проверить типы функциональных указателей `t_qp__*` |
| `PFUNQT_SIZE` недостаточен | Новый индекс вышел за 25000 | Увеличить `PFUNQT_SIZE` в `qte56_core.d` |

### Runtime

| Ошибка | Причина | Решение |
|---|---|---|
| `GetProcAddress failed` | DLL не загружена или функция не экспортирована | Проверить что DLL в PATH, пересобрать |
| `LoadLibrary failed: qte56_*.dll` | DLL не найдена | Добавить `dll\` в PATH перед запуском |
| `qscintilla2_qt5.dll not found` | Вторая DLL QScintilla отсутствует | Скопировать в `dll\` |
| `qsqlite.dll not found` | SQL-плагин не там | Создать `dll\sqldrivers\` и скопировать `qsqlite.dll` |
| Старая `ole_helper.dll` в корне | `LoadLibraryA` находит первый файл в PATH | Удалить старые копии DLL из корня проекта |
| Сигнал не срабатывает | Значение установлено после `connect` | Устанавливать значение ДО подключения сигнала |

---

## 16. Полная сборка с нуля на чистом Windows

### Предварительные условия

1. Установить Qt 5.13.2 MinGW 32-bit в `C:\Qt5_13_2\`
2. Установить DMD (D compiler): https://dlang.org/download.html — добавит `dmd` в системный PATH
3. Убедиться что проект находится в `H:\qte56\arch_new\`

### Шаг 1: Перейти в директорию проекта

```bat
cd /d H:\qte56\arch_new
```

### Шаг 2: Собрать все C++ DLL

```bat
build_merged_dlls.bat
```

Ожидаемый итог:
```
Results: N / N succeeded
```

Все DLL появятся в `H:\qte56\arch_new\dll\dll32\` (для win32_qt5; win64_qt6 → `dll\dll64\`).

### Шаг 3: Скопировать SQL-плагин (для SQL-тестов)

```bat
mkdir dll\sqldrivers
copy C:\Qt5_13_2\5.13.2\mingw73_32\plugins\sqldrivers\qsqlite.dll dll\sqldrivers\
```

### Шаг 4: Скопировать QScintilla DLL (для QScintilla-тестов)

```bat
:: Если qscintilla2_qt5.dll собран отдельно или взят из пакета:
copy path\to\qscintilla2_qt5.dll dll\
```

### Шаг 5: Запустить конкретный тест

```bat
test\build_layouts_ext.bat
```

Или вручную:
```bat
set "QT_BIN=C:\Qt5_13_2\5.13.2\mingw73_32\bin"
set "MINGW_BIN=C:\Qt5_13_2\Tools\mingw730_32\bin"
set "PATH=H:\qte56\arch_new\dll\dll32;%QT_BIN%;%MINGW_BIN%;%PATH%"

dmd -m32 ^
    test\test_layouts_ext.d ^
    d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qobject.d d\gen\gen_qwidget.d ^
    d\gen\gen_qframe.d d\gen\gen_qlayout.d d\gen\gen_qfont.d ^
    d\gen\gen_qabstractbutton.d d\gen\gen_qpushbutton.d d\gen\gen_qlineedit.d ^
    -Id -Id\gen ^
    -of=test\test_layouts_ext.exe

test\test_layouts_ext.exe
```

### Шаг 6 (Linux): Полная сборка

```bash
cd /path/to/arch_new

# Собрать все .so
bash build_merged_dlls.sh

# Запустить все тесты
bash test/build_linux.sh all
```

---

## 17. Директория cpp/qt5/: полный список одиночных модулей

Каждый из этих каталогов содержит отдельный C++ модуль (`qte56_<name>.{cpp,h}`). Merged DLL включают их исходники напрямую через `INCLUDEPATH` + `SOURCES`.

```
cpp/qt5/merged/                    — merged .pro проекты (6 групп)
cpp/qt5/qte56_qcore/               — единственный standalone core

cpp/qt5/qte56_qabstractbutton/     cpp/qt5/qte56_qabstractitemview/
cpp/qt5/qte56_qabstractscrollarea/ cpp/qt5/qte56_qabstractslider/
cpp/qt5/qte56_qabstractspinbox/    cpp/qt5/qte56_qaction/
cpp/qt5/qte56_qbuttongroup/        cpp/qt5/qte56_qcalendarwidget/
cpp/qt5/qte56_qcheckbox/           cpp/qt5/qte56_qclipboard/
cpp/qt5/qte56_qcolor/              cpp/qt5/qte56_qcolordialog/
cpp/qt5/qte56_qcombobox/           cpp/qt5/qte56_qcommandlinkbutton/
cpp/qt5/qte56_qdatetimeedit/       cpp/qt5/qte56_qdial/
cpp/qt5/qte56_qdialog/             cpp/qt5/qte56_qdockwidget/
cpp/qt5/qte56_qdoublespinbox/      cpp/qt5/qte56_qfile/
cpp/qt5/qte56_qfiledialog/         cpp/qt5/qte56_qfont/
cpp/qt5/qte56_qfontdialog/         cpp/qt5/qte56_qframe/
cpp/qt5/qte56_qgroupbox/           cpp/qt5/qte56_qheaderview/
cpp/qt5/qte56_qicon/               cpp/qt5/qte56_qimage/
cpp/qt5/qte56_qimagereader/        cpp/qt5/qte56_qimagewriter/
cpp/qt5/qte56_qinputdialog/        cpp/qt5/qte56_qlabel/
cpp/qt5/qte56_qlayout/             cpp/qt5/qte56_qlcdnumber/
cpp/qt5/qte56_qlineedit/           cpp/qt5/qte56_qlistwidget/
cpp/qt5/qte56_qmainwindow/         cpp/qt5/qte56_qmdiarea/
cpp/qt5/qte56_qmdisubwindow/       cpp/qt5/qte56_qmenu/
cpp/qt5/qte56_qmenubar/            cpp/qt5/qte56_qmessagebox/
cpp/qt5/qte56_qobject/             cpp/qt5/qte56_qpainter/
cpp/qt5/qte56_qpicture/            cpp/qt5/qte56_qpixmap/
cpp/qt5/qte56_qplaintextedit/      cpp/qt5/qte56_qprocess/
cpp/qt5/qte56_qprogressbar/        cpp/qt5/qte56_qprogressdialog/
cpp/qt5/qte56_qpushbutton/         cpp/qt5/qte56_qradiobutton/
cpp/qt5/qte56_qscintilla/          cpp/qt5/qte56_qscrollarea/
cpp/qt5/qte56_qscrollbar/          cpp/qt5/qte56_qsettings/
cpp/qt5/qte56_qslider/             cpp/qt5/qte56_qspinbox/
cpp/qt5/qte56_qsplitter/           cpp/qt5/qte56_qsql/
cpp/qt5/qte56_qstackedwidget/      cpp/qt5/qte56_qstatusbar/
cpp/qt5/qte56_qsyntaxhighlighter/  cpp/qt5/qte56_qtabbar/
cpp/qt5/qte56_qtableview/          cpp/qt5/qte56_qtablewidget/
cpp/qt5/qte56_qtabwidget/          cpp/qt5/qte56_qtextblock/
cpp/qt5/qte56_qtextblockformat/    cpp/qt5/qte56_qtextbrowser/
cpp/qt5/qte56_qtextcharformat/     cpp/qt5/qte56_qtextcursor/
cpp/qt5/qte56_qtextdocument/       cpp/qt5/qte56_qtextedit/
cpp/qt5/qte56_qtimer/              cpp/qt5/qte56_qtoolbar/
cpp/qt5/qte56_qtoolbox/            cpp/qt5/qte56_qtoolbutton/
cpp/qt5/qte56_qtreeview/           cpp/qt5/qte56_qtreewidget/
cpp/qt5/qte56_qwidget/             cpp/qt5/qte56_resource/
cpp/qt5/qte56_systray/             cpp/qt5/qte56_tvision/
cpp/qt5/qte56_uiloader/            cpp/qt5/qte56_drawing/
```

---

## 18. Схема load flow (итог)

```
D-программа
  import gen_qlabel          -> static this() -> registerModule("QLabel", "qte56_widgets.dll", &loadQLabel)
  LoadQt()                   -> путь из QTE56_ARCH (win32_qt5 → dll/dll32)
                                Windows: LoadLibraryA("dll/dll32/qte56_widgets.dll")
                                Linux:   dlopen("./lib/libqte56_widgets.so", RTLD_GLOBAL)
  new QLabel("text", parent) -> pFunQt[800](args...)  -> GetProcAddress / dlsym
  app.exec()
  app.deleteApp()            <- НЕ вызывать UnloadQt() — OS сама освобождает DLL
```

**Критично**: `LoadQt()` вызывать ДО `new QApplication()`. Точка входа: `void main()` (не `extern(C) int main()`).

---

## 19. Сборка tools/qte_guide

Интерактивный справочник QTE56 — GUI-приложение, собираемое из D-исходников.

### Быстрый запуск

```bat
cd arch_new
tools\qte_guide\build_main.bat
```

### Что делает build_main.bat

1. Переходит в `arch_new/` (через `cd /d "%~dp0..\\.."`)
2. Устанавливает Qt-пути из env vars (с дефолтами):
   ```bat
   if "%QTE56_QT_ROOT%"=="" set QTE56_QT_ROOT=C:\Qt5_13_2
   if "%QTE56_QT_VER%"==""  set QTE56_QT_VER=5.13.2
   if "%QTE56_QT_COMP%"=="" set QTE56_QT_COMP=mingw73_32
   if "%QTE56_MINGW%"==""   set QTE56_MINGW=mingw730_32
   ```
3. Compile check (dmd -c, без линковки)
4. Полная сборка (dmd -i, с линковкой `-L/DEFAULTLIB:user32`)
5. Запуск с PATH включающим dll/ + Qt bin + MinGW bin

### Переопределение Qt-путей

На другом компьютере установить в System Properties → Environment Variables:
```
QTE56_QT_ROOT=D:\Qt5.13.2
QTE56_QT_COMP=mingw73_32
```
Или передать через cmd перед запуском:
```bat
set QTE56_QT_ROOT=D:\MyQt && tools\qte_guide\build_main.bat
```

### D-модули, включаемые при сборке

Помимо `tools/qte_guide/*.d` компилируются следующие модули из `d/` и `d/gen/`:
```
d\qte56_core.d  d\qte56_loader.d  d\qte56_enums.d
d\gen\gen_qcore.d  gen_qobject.d  gen_qfont.d  gen_qbytearray.d
gen_qwidget.d  gen_qframe.d  gen_qabstractscrollarea.d
gen_qscintilla.d  gen_qmainwindow.d  gen_qsplitter.d
gen_qtoolbar.d  gen_qaction.d  gen_qstatusbar.d
gen_qtreewidget.d  gen_qtreeview.d  gen_qabstractitemview.d
gen_qmenu.d  gen_qmenubar.d  gen_qmessagebox.d
gen_qsettings.d  gen_qfiledialog.d  gen_qinputdialog.d
```

### Portability (запуск с любого места)

`main.d` вычисляет абсолютный путь к `dll/` через `thisExePath`:
```d
string selfDir  = thisExePath.dirName;       // .../tools/qte_guide/
string archRoot = selfDir.dirName.dirName;   // .../arch_new/
string dllDir   = buildPath(archRoot, "dll");
if (!dllDir.exists) dllDir = "./dll";        // fallback
LoadQt(dllDir);
```
Qt-пути (для генерации build.bat) сохраняются в QSettings и могут быть изменены через `File → Configure Qt Paths...`.

---

## Навигация

- ↑ [AGENTS.md](AGENTS.md) — точка входа
- ↓ Подробнее:
  - [CPP_DLL_PATTERNS.md](CPP_DLL_PATTERNS.md) — паттерны C++ обёрток
  - [LINUX_PORT.md](LINUX_PORT.md) — сборка и запуск на Linux
