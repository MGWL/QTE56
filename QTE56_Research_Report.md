# QTE56 — Qt5/6 Bindings for the D Programming Language

> **A production-ready DLL-based bridge enabling D developers to build professional Qt GUI applications without a C++ toolchain.**

---

## Table of Contents

1. [What is QTE56](#what-is-qte56)
2. [Core Architecture](#core-architecture)
3. [Main Features](#main-features)
4. [Technology Stack](#technology-stack)
5. [Project Structure](#project-structure)
6. [How It Works](#how-it-works)
7. [Comparison with Alternatives](#comparison-with-alternatives)
8. [Getting Started](#getting-started)
9. [Conclusion](#conclusion)

---

## What is QTE56

**QTE56** is a Qt 5/6 binding system for the [D programming language](https://dlang.org/) that enables D programmers to build native GUI applications using the Qt framework **without recompiling C++ code** for every change.

The core innovation is a **DLL-based bridge architecture** where all Qt logic is packaged into precompiled shared libraries, and D code accesses them through a global function pointer table. This eliminates the need for D developers to install a C++ compiler, Qt headers, or deal with C++ name mangling.

### Target Audience

- D developers who need professional GUI capabilities
- Teams migrating from Qt/C++ to D
- Rapid application development with native performance
- Cross-platform desktop applications (Windows/Linux)

---

## Core Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                    D Application Code                                │
│  ┌───────────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ import gen_qlabel │  │ LoadQt()    │  │ new QLabel(cast(void*)null) │ │
│  │ static this()     │  │ LoadLibrary │  │ pFunQt[800] → create    │ │
│  │ registerModule()  │  │ GetProcAddr │  │ app.exec()              │ │
│  └───────────────────┘  └─────────────┘  └─────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              pFunQt[25000] — Global Function Table              │
│  Index 0..N → void* pointer to C extern function in DLL         │
│  Example: pFunQt[800] = &qteQLabel_create (from qte56_widgets)  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              C++ DLL Layer (Qt Wrappers)                        │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐ │
│  │ qte56_qcore  │ │ qte56_widgets│ │ qte56_mainwin, dialogs...│ │
│  │ QApplication │ │ QWidget,Label│ │ QMainWindow, QDialog...  │ │
│  │ QString,ESlot│ │ QPushButton  │ │ QFileDialog, QMessageBox │ │
│  └──────────────┘ └──────────────┘ └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Qt 5.13.2 Framework                         │
│              (C++ / MinGW 32-bit on Windows)                    │
└─────────────────────────────────────────────────────────────────┘
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **No C++ recompilation** | D developers only compile D code; Qt C++ wrappers are pre-built DLLs |
| **Function pointer table (`pFunQt`)** | Global `__gshared void*[25000]` array stores all exported C function addresses |
| **Index-based registry (`functions.csv`)** | Single source of truth mapping indices to function names, modules, and DLL files |
| **Mixin-based code generation** | Compile-time D mixins generate function type aliases and loading code |
| **Cross-platform** | Windows (32-bit primary, 64-bit prep), Linux (64-bit via LDC) |

---

## Main Features

### GUI Widgets (80+ Qt Classes)

| Category | Classes |
|----------|---------|
| **Basic Widgets** | QWidget, QLabel, QPushButton, QCheckBox, QRadioButton, QLineEdit, QComboBox, QSpinBox, QSlider, QProgressBar, QGroupBox, QTabWidget, QFrame, QSplitter, QStackedWidget, QScrollArea, QLCDNumber |
| **Main Window** | QMainWindow, QMenuBar, QMenu, QAction, QToolBar, QStatusBar, QDockWidget, QMdiArea, QMdiSubWindow |
| **Dialogs** | QDialog, QMessageBox, QFileDialog, QInputDialog, QFontDialog, QColorDialog, QProgressDialog |
| **Text Editing** | QTextEdit, QPlainTextEdit, QTextBrowser, QTextDocument, QTextCursor, QSyntaxHighlighter |
| **Data Views** | QTableWidget, QTreeWidget, QListWidget, QHeaderView |
| **Drawing** | QPainter, QPen, QBrush, QPalette, QFontMetrics, QPixmap, QImage, QColor, QIcon |
| **Threading** | QThread, QMutex, QWaitCondition, QSemaphore, QReadWriteLock |
| **Networking** | QNetworkAccessManager, QUrl, QNetworkRequest, QNetworkReply |
| **Database** | QSqlDatabase, QSqlQuery (SQLite, PostgreSQL via plugins) |
| **Other** | QTimer, QSettings, QProcess, QClipboard, QSystemTrayIcon, QCompleter, QShortcut, QFileSystemWatcher, QDesktopWidget |

### Signal/Slot System (ESlot)

Custom `eSlot` C++ class bridges Qt signals to D callbacks:

- `invoke_v()` — void
- `invoke_b(bool)`, `invoke_i(int)`, `invoke_d(double)`
- `invoke_s(QString)`, `invoke_p(QPoint)`, `invoke_ii(int,int)`
- Lambda-connect for Qt-pointer signals
- Direct event handlers: `onMousePress`, `onKeyPress`, `onResize`, `onPaint`, `onClose`

### Additional Libraries

| Library | Purpose |
|---------|---------|
| **QScintilla** | Code editor widget with syntax highlighting |
| **QXlsx** | Excel file reading/writing |
| **Wren scripting** | Embedded scripting VM bridge |
| **Turbo Vision** | Text-mode UI (standalone) |
| **OLE/DAO** | Microsoft Access database via COM |
| **libcurl wrapper** | HTTP/HTTPS/FTP/FTPS/SFTP/SCP |
| **JSON parser** | Pure D JSON without Qt dependencies |

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Application Language** | D (Digital Mars D / LDC) |
| **GUI Framework** | Qt 5.13.2 (MinGW 32-bit on Windows) |
| **C++ Wrappers** | C++11, `extern "C"`, `__declspec(dllexport/dllimport)` |
| **Build System** | qmake + mingw32-make (Windows), qmake-qt5 + make (Linux) |
| **Code Generator** | Python 3 (regex-based parser of Qt headers) |
| **Registry** | CSV file (`functions.csv`) |
| **Compilers** | DMD (`-m32`) on Windows, LDC2 on Linux |

### DLL Organization

| DLL | Contents |
|-----|----------|
| `qte56_qcore.dll` | QApplication, ESlot, QString |
| `qte56_foundation.dll` | QObject, QFont, QPixmap, QPainter, QTimer, QSettings, даты (17 модулей) |
| `qte56_widgets.dll` | QWidget, QLabel, QPushButton, QComboBox, QLayout, etc. (27 модулей) |
| `qte56_views.dll` | QTableWidget, QTreeWidget, QListWidget, QMdiArea, etc. (11 модулей) |
| `qte56_text.dll` | QTextEdit, QPlainTextEdit, QTextDocument, QTextCursor, etc. (8 модулей) |
| `qte56_dialogs.dll` | QDialog, QMessageBox, QFileDialog, QFontDialog, QColorDialog, QInputDialog, etc. (7 модулей) |
| `qte56_mainwin.dll` | QMainWindow, QMenuBar, QMenu, QAction, QToolBar, QStatusBar, etc. (10 модулей) |

---

## Project Structure

```
arch_new/
├── d/                          # D source files
│   ├── qte56_core.d            # pFunQt[], generateAlias(), generateFunQt()
│   ├── qte56_loader.d          # LoadQt(), UnloadQt(), registerModule()
│   ├── qte56_enums.d           # QtE class with all Qt enums
│   ├── qte56_style.d           # QSS helpers
│   ├── qte56_forms.d           # Qt Designer .ui loader helpers
│   ├── net_utils.d             # HTTP GET/POST
│   ├── curl_utils.d            # libcurl wrapper
│   ├── json.d                  # Pure D JSON parser
│   └── gen/                    # 114 generated modules
│
├── cpp/                        # C++ wrapper projects
│   ├── qt5/                    # ~106 per-class qte56_* projects
│   │   ├── qte56_qcore/        # Core: QApplication, QString, ESlot
│   │   ├── qte56_qwidget/      # QWidget wrapper
│   │   └── merged/             # Merged DLL .pro files
│   └── qt6/                    # Qt 6 variants (partial)
│
├── dll/                        # Pre-built Windows DLLs
├── generator/                  # Python code generator
│   ├── main.py                 # Entry point
│   ├── qt_parser.py            # Regex parser for Qt .h headers
│   ├── d_generator.py          # D module generator
│   └── cpp_generator.py        # C++ wrapper generator
│
├── registry/
│   └── functions.csv           # Master registry (3783 entries)
│
├── test/                       # Test suite (161 test .d files)
├── example/                    # Example applications
├── apps/                       # Real applications (MIDE, chat, etc.)
└── doc/                        # Documentation
```

---

## How It Works

### Runtime Flow

```d
// 1. Import registers the module
import gen_qlabel;  // static this() → registerModule("QLabel", "qte56_widgets.dll", &loadQLabel)

// 2. Load DLLs and resolve functions
LoadQt("./dll");
//    → import gen_* → static this() → registerModule(module, dll, loader)
//    → LoadLibrary("qte56_widgets.dll")
//    → pFunQt[idx] = GetProcAddress(dll, func_name)

// 3. Use Qt objects
auto lbl = new QLabel(cast(void*)null);
lbl.setText("Hello");

// 4. Event loop
app.exec();
```

### Code Generation Pipeline

```
Qt Header (.h)
    │
    ▼
[qt_parser.py] ──Regex parse──► QtClass
    │
    ▼
[main.py] ──Plan methods──► MethodSpecs
    │
    ▼
[registry.py] ──Assign indices──► Update functions.csv
    │
    ▼
[cpp_generator.py] ──Generate──► qte56_qXxx.h / .cpp / .pro
    │
    ▼
[d_generator.py] ──Generate──► gen_qXxx.d
    │
    ▼
Build with qmake + mingw32-make → DLL
```

---

## Comparison with Alternatives

### QtE5 (Predecessor)

| Aspect | QtE5 | QTE56 |
|--------|------|-------|
| Architecture | Monolithic single DLL | Modular grouped DLLs |
| Function indexing | Hardcoded in D source | Centralized `functions.csv` registry |
| Code generation | Manual | Automated Python generator |
| Class coverage | ~20 classes | 80+ classes |
| Qt version | Qt 5.x (older) | Qt 5.13.2 |
| Signal system | Basic | ESlot + lambda-connect + direct events |

### DlangUI

| Aspect | DlangUI | QTE56 |
|--------|---------|-------|
| Framework | Custom D UI (not Qt) | Qt 5/6 bindings |
| Native look | No (custom rendering) | Yes (native Qt widgets) |
| Dependencies | Pure D | Requires Qt DLLs + C++ wrappers |
| Use case | Lightweight apps | Full-featured professional GUIs |

### QtD (Official Qt Bindings)

| Aspect | QtD | QTE56 |
|--------|-----|-------|
| Approach | Direct C++ interop via extern(C++) | DLL bridge via extern(C) |
| C++ compiler required | Yes (for every build) | No (pre-built DLLs) |
| Build complexity | High | Low |
| Qt version support | Limited, often outdated | Qt 5.13.2, prep for Qt 6 |
| Maintenance | Stalled/unmaintained | Actively developed (2026) |

### PyQt / PySide

| Aspect | PyQt/PySide | QTE56 |
|--------|-------------|-------|
| Language | Python | D |
| Performance | Interpreted + C++ Qt | Compiled native D + C++ Qt |
| Memory management | Python GC + Qt parent | D GC + manual ownership |
| Ecosystem | Massive | Small but focused |

### GtkD

| Aspect | GtkD | QTE56 |
|--------|------|-------|
| Toolkit | GTK | Qt |
| Native platform | Linux primary | Cross-platform (Windows primary) |
| Widget richness | Good | Excellent |

---

## Key Differentiators

1. **No C++ toolchain required** — The biggest barrier to entry is eliminated
2. **Centralized registry (`functions.csv`)** — Binary compatibility, easy extension
3. **Automated code generation** — Add a new Qt class in minutes
4. **Typed ownership API** — Auto-disown prevents memory leaks
5. **Cross-platform unified API** — Same D code on Windows and Linux
6. **Rich ecosystem** — JSON, HTTP, curl, Wren, OLE/DAO, Turbo Vision, Excel

---

## Getting Started

### Windows (32-bit)

```batch
:: 1. Download QTE56 and Qt 5.13.2 DLLs
:: 2. Set up DMD 2.112+ with -m32

:: 3. Compile your app
dmd -m32 -version=TreeQt -i myapp.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=myapp.exe

:: 4. Run with DLLs in PATH or same directory
myapp.exe
```

### Linux (64-bit)

```bash
# 1. Install Qt5 dev packages and LDC2
sudo apt-get install qt5-default libqt5widgets5

# 2. Compile
dmd -m64 -version=TreeQt -i myapp.d -Id -Id/gen -L-lQt5Widgets -of=myapp

# 3. Run
LD_LIBRARY_PATH=./lib ./myapp
```

---

## Conclusion

QTE56 represents a **mature, production-ready approach** to Qt bindings for D. Its DLL-based architecture sacrifices minimal performance (one function pointer indirection) for massive gains in developer productivity. D programmers can build professional Qt GUI applications with nothing but a D compiler and pre-built DLLs.

The automated code generator, centralized function registry, and extensive documentation make it particularly well-suited for **rapid application development** and **long-term maintenance**.

---

## Links

- **Repository**: `H:\qte56\arch_new\` (local development)
- **Documentation**: `doc/qte56_d_reference.md`
- **Examples**: `example/`, `test/`
- **Applications**: `apps/mide/`, `apps/gui/`, `apps/chat/`

---

*Report generated: 2026-05-30; числа (модули/тесты/реестр/DLL) обновлены 2026-08-02*
