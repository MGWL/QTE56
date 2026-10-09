# QTE56 — Техническая документация для AI-ассистента

Полное руководство по проекту QTE56: Qt 5.13.2 биндинги для языка D через C++ DLL обёртки. Документ самодостаточен — загрузив его, AI может отвечать на любые вопросы по разработке с QTE56.

---

## Общее описание проекта

QTE56 позволяет писать Qt5 GUI приложения на языке D без перекомпиляции C++ при каждом изменении кода. Вся Qt-логика упакована в DLL, D-код обращается к ней через таблицу указателей на функции `pFunQt[25000]`.

- Директория: `H:\qte56\arch_new\`
- Сборка: **32-bit** (`dmd -m32`, Qt MinGW 32-bit)
- Qt: `C:\Qt5_13_2\5.13.2\mingw73_32` / `C:\Qt5_13_2\Tools\mingw730_32`
- Linux: компилятор `ldc2`, библиотеки `./lib/libXXX.so`
- Оригинал: `qte56.d`. Директория `arch_new/` — новая архитектура с 7.8x больше функций

---

## Архитектура системы

```
D application code
  │
  ├── import gen_qlabel        ← статически подключает модуль QLabel
  │     └── static this() → registerModule("QLabel", "qte56_widgets.dll", &loadQLabel)
  │
  ├── LoadQt("./dll")          ← загружает все зарегистрированные DLL, заполняет pFunQt[]
  │
  ├── pFunQt[idx]              ← глобальная таблица: void*[25000], каждый индекс = адрес C++ функции
  │
  ├── new QLabel(cast(void*)null)  ← вызывает pFunQt[800] (qteQLabel_create)
  │
  └── app.exec()               ← Qt event loop

DLL layer (C++ / Qt) — DLL лежат в `dll/dll32/` (win32_qt5, 31 qte56-DLL) и
`dll/dll64/` (win64_qt6, 22 qte56-DLL); `LoadQt()` без аргумента выбирает
подкаталог по переменной окружения `QTE56_ARCH`
  ├── dll/dll32/qte56_qcore.dll      ← QApplication, QString, ESlot, QRect/Point/Size
  ├── dll/dll32/qte56_widgets.dll    ← merged: QWidget, QLabel, QPushButton, QFrame, ...
  ├── dll/dll32/qte56_foundation.dll ← QAbstractButton, QAbstractSlider, QObject, QAction, ...
  ├── dll/dll32/qte56_views.dll      ← QTableWidget, QTreeWidget, QListWidget, QSettings, ...
  ├── dll/dll32/qte56_text.dll       ← QTextEdit, QPlainTextEdit, QTextDocument, ...
  ├── dll/dll32/qte56_dialogs.dll    ← QDialog, QMessageBox, QFileDialog, ...
  ├── dll/dll32/qte56_mainwin.dll    ← QMainWindow, QStatusBar, QToolBar, QTimer, ...
  ├── dll/dll32/qte56_drawing.dll    ← QPen, QBrush, QPalette, QFontMetrics
  ├── dll/dll32/qte56_sql.dll        ← QSqlDatabase, QSqlQuery
  ├── dll/dll32/qte56_systray.dll    ← QSplashScreen, QSystemTrayIcon
  ├── dll/dll32/qte56_resource.dll   ← QResource, resource:// paths
  ├── dll/dll32/qte56_uiloader.dll   ← QUiLoader (Qt Designer .ui forms)
  ├── dll/dll32/qte56_qprocess.dll   ← QProcess
  ├── dll/dll32/qte56_qscintilla.dll ← QScintilla editor
  └── dll/dll32/qte56_tvision.dll    ← Turbo Vision TUI (standalone)

D source
  ├── d/qte56_core.d           ← pFunQt[], generateAlias(), generateFunQt(), EventId, DDate/DTime/DDateTime
  ├── d/qte56_loader.d         ← registerModule(), LoadQt(), UnloadQt(), loadFn()
  ├── d/qte56_enums.d          ← QtE class + all enums
  ├── d/gen/gen_qcore.d        ← ESlot, QApplication, DRect/DPoint/DSize, toQString/fromQString
  ├── d/gen/gen_qwidget.d      ← QWidget (base class)
  ├── d/gen/gen_*.d            ← 114 модулей (2026-08-02)
  ├── d/qte56_style.d          ← QSS helper (applyQss, appendQss, QssTheme)
  ├── d/qte56_forms.d          ← QForm (load .ui, findButton/findLabel/...)
  └── d/qte56_resource.d       ← QssThemeRes, registerRcc, readText/Bytes
```

Поток загрузки: `import gen_qlabel` → `static this()` → `registerModule()` → `LoadQt("./dll")` → `GetProcAddress` → `pFunQt[idx]`. На Linux: `dlopen(RTLD_NOW | RTLD_GLOBAL)` → `dlsym`. `soName()` автоматически конвертирует `foo.dll` → `libfoo.so`.

---

## Структура файловой системы

```
arch_new/
├── build_merged_dlls.bat       ← Windows: собрать все merged + special DLL
├── build_merged_dlls.sh        ← Linux: bash build_merged_dlls.sh → lib/*.so
├── cpp/qt5/                    ← C++ исходники DLL (~106 поклассовых проектов)
│   ├── qte56_qcore/            ← QApplication, QString, ESlot, QRect/Point/Size
│   ├── qte56_qlabel/           ← QLabel (входит в widgets)
│   ├── qte56_qpushbutton/      ← QPushButton
│   ├── merged/                 ← 6 объединённых .pro (widgets, foundation, views, text, dialogs, mainwin)
│   └── ...                     ← по одной папке на C++ класс (cpp/qt6/ — неполный порт на Qt 6)
├── d/                          ← D исходники
│   ├── qte56_core.d            ← pFunQt[], generateAlias/FunQt, EventId, DDate/Time
│   ├── qte56_loader.d          ← registerModule, LoadQt, UnloadQt, loadFn
│   ├── qte56_enums.d           ← QtE + FrameShape/Shadow, TabPosition, text/tray enums
│   ├── qte56_style.d           ← applyQss, appendQss, QssTheme, setQssEngine
│   ├── qte56_forms.d           ← QForm.load, findLabel/Button/LineEdit/...
│   ├── qte56_resource.d        ← registerRcc, readResourceText/Bytes, applyQssRes
│   └── gen/                    ← сгенерированные модули (114 файлов)
│       ├── gen_qcore.d         ← ESlot, QApplication, DRect/DPoint/DSize
│       ├── gen_qwidget.d       ← QWidget
│       ├── gen_qlabel.d        ← QLabel
│       └── gen_*.d             ← остальные классы
├── dll/                        ← скомпилированные DLL (Windows)
│   ├── dll32/                  ← 31 qte56-DLL (win32_qt5, основная архитектура)
│   │   ├── qte56_qcore.dll
│   │   └── qte56_widgets.dll
│   └── dll64/                  ← 22 qte56-DLL (win64_qt6, неполно)
├── lib/                        ← .so файлы (Linux)
├── test/                       ← тесты
│   ├── build_*.bat             ← скрипты сборки тестов (Windows)
│   ├── build_linux.sh          ← bash test/build_linux.sh all
│   └── test_*.d                ← D-файлы тестов
├── generator/                  ← генератор кода
│   ├── main.py                 ← py main.py <header.h> --module QFoo --index-start 21400
│   ├── qt_parser.py            ← разбор C++ заголовков Qt
│   ├── type_map.py             ← маппинг C++ типов → D alias коды
│   ├── planner.py / checks.py / registry.py / fileops.py / geninfo.py
│   ├── cpp_generator.py / cpp_texts.py / d_generator.py / events.py
│   ├── qt_knowledge.py / knowledge_access.py  ← база знаний Qt
│   ├── augment.py / scan_augment.py           ← режим --augment и скан покрытия
│   └── test_new_class.py / make_build.py / merge_dlls.py / reindex.py / scan_ldc2_bugs.py
├── registry/
│   └── functions.csv           ← источник истины для всех индексов функций (UTF-8!)
└── doc/
    └── qte56_d_reference.md   ← полный справочник API
```

---

## Ключевые файлы D

### qte56_core.d

- `__gshared void*[25000] pFunQt` — таблица адресов всех функций
- `PFUNQT_SIZE = 25000` — размер таблицы; таблица практически заполнена (макс. занятый индекс 24713 на 2026-08-02) — новые классы размещаются в дырах (`tools/qte/qte.exe index gaps`)
- `alias QtObjH = void*` — универсальный Qt-указатель
- `generateAlias(key)` — compile-time генерация alias для типа функции
- `generateFunQt(idx, func_name, module_name)` — compile-time строка `pFunQt[idx] = loadFn(...);`
- `EventId` enum — 17 типов событий (mousePress=1 .. contextMenu=17, paint=18)
- `struct DDate { int year, month, day; }`
- `struct DTime { int hour, minute, second, msec; }`
- `struct DDateTime` — объединяет DDate + DTime; методы `toDate()` / `toTime()`

### qte56_loader.d

- `registerModule(name, dllFile, loader)` — вызывается из `static this()` каждого gen_*.d
- `LoadQt(dllDir = "./dll")` — загружает DLL через `LoadLibraryA`, вызывает `loader()` каждого модуля для заполнения `pFunQt[]`
- `UnloadQt()` — `FreeLibrary` + `pFunQt[] = null`
- `loadFn(module_name, func_name)` → `GetProcAddress` по имени функции
- Linux: `dlopen(RTLD_NOW | RTLD_GLOBAL)`, fallback `./dll` → `./lib`
- `soName("qte56_widgets.dll")` → Windows: то же; Linux: `"libqte56_widgets.so"`

### gen_qcore.d

Содержит alias типов и ключевые утилиты.

**Паттерн именования alias**: `RET__P1_P2_P3`, где коды: `v`=void, `i`=int, `qp`=void*, `d`=double, `f`=float, `ui`=uint, `l`=long, `ul`=ulong, `sz`=size_t, `ip`=int*`, `bp`=bool*`, `cp`=const(char)*`; разделитель `__` между return и params, `_` между params.

Примеры alias: `t_v__qp_i`, `t_qp__qp`, `t_i__qp` — всего ~40 стандартных.

**Структуры**: `DRect`, `DPoint`, `DSize` с методами (right, bottom, intersected, united, translated, ...).

**Строки**:
- `toQString(string)` → `void*` (heap `QString*`, освободить через `pFunQt[22]`)
- `fromQString(void*)` → `string` (не освобождает аргумент)
- `toQStringList(string[])` → объединяет через `\x01`; C++ сплитует через `split(QChar(1))`
- `freeQStringList(void*)` = alias для `pFunQt[22]`

**QApplication**:
- Методы: `createApp`, `exec`, `quit`, `processEvents`, `setStyleSheet`, `setStyle`, `setWindowIcon`, `beep`, `closeAllWindows`, `activeWindow`, `setFont`
- `deleteApp()` — ОБЯЗАТЕЛЕН в конце; снимает `GC.removeRoot` и обнуляет `pFunQt[]`
- `GC.addRoot` / `GC.removeRoot` защищает объект от преждевременной финализации

**ESlot** — обёртка над `eSlot`:
- `this(void* parent)` → `pFunQt[1,11]`
- `set(cb, dthis, n)` → `pFunQt[12]`
- `raw()` → `eSlot*`

**connectQt(sender, signal, slot, invoke)** — вызывает `pFunQt[10]`; prefix `"2"` для сигнала, `"1"` для слота.

### D callback типы (DSlot_*)

```d
alias DSlot_v   = extern(C) void function(void* dthis, int n);
alias DSlot_i   = extern(C) void function(void* dthis, int n, int val);
alias DSlot_ii  = extern(C) void function(void* dthis, int n, int a, int b);
alias DSlot_d   = extern(C) void function(void* dthis, int n, double val);
alias DSlot_s   = extern(C) void function(void* dthis, int n, void* qs);   // qs = void* QString*
alias DSlot_p   = extern(C) void function(void* dthis, int n, int x, int y);
alias DSlot_ptr = extern(C) void function(void* dthis, int n, void* ptr);  // Qt-объект
```

---

## Структура gen_*.d модулей

Каждый файл содержит в строгом порядке:

1. `module gen_qfoo;`
2. `import qte56_core; import qte56_loader : loadFn, registerModule;`
3. Импорты типов из `gen_qcore` и базовых классов
4. `mixin(generateAlias("..."))` — новые alias для этого модуля
5. `static this() { registerModule("QFoo", "qte56_XXX.dll", &loadQFoo); }`
6. `void loadQFoo() { mixin(generateFunQt(IDX, "qteFuncName", "QFoo")); ... }` — загрузка адресов
7. Класс `QFoo : BaseClass { ... }` с методами

### Типичный класс-обёртка

```d
class QFoo : QBase {
public:
    this(void* parent) {
        super(true);  // no-op для базового
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[IDX_CREATE])(parent);
    }
    protected this(bool _noOp) { super(_noOp); }  // для подклассов

    static QFoo wrap(void* wh) {                   // для Qt-owned указателей
        auto w = new QFoo(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }
    ~this() {
        if (_wh !is null && !_qt_owned && pFunQt[IDX_DELETE] !is null) {
            (cast(t_v__qp)pFunQt[IDX_DELETE])(_wh);
            _wh = null;
        }
    }
    void* getWH() { return _wh; }
}
```

`_wh` (тип `void*`) объявлен в самом корневом базовом классе (`QObject` или `QWidget`). `_qt_owned` запрещает деструктору вызывать delete.

---

## Иерархия классов D

```
QObject (gen_qobject.d, idx 3600)
  └── QWidget (gen_qwidget.d, idx 200)
        ├── QFrame (gen_qframe.d, idx 2800)
        │     ├── QLabel (gen_qlabel.d, idx 800)
        │     ├── QAbstractScrollArea (gen_qabstractscrollarea.d, idx 7400)
        │     │     ├── QScrollArea (gen_qscrollarea.d, idx 10000)
        │     │     └── QAbstractItemView (gen_qabstractitemview.d, idx 8800)
        │     │           ├── QTableView (gen_qtableview.d, idx 9000)
        │     │           │     └── QTableWidget (gen_qtablewidget.d, idx 9200)
        │     │           ├── QTreeView (gen_qtreeview.d, idx 9400)
        │     │           │     └── QTreeWidget (gen_qtreewidget.d, idx 9600)
        │     │           └── QListWidget (gen_qlistwidget.d, idx 7000)
        │     ├── QSplitter (gen_qsplitter.d, idx 8200)
        │     ├── QTextEdit (gen_qtextedit.d, idx 8000)
        │     │     └── QTextBrowser (gen_qtextbrowser.d, idx 11200)
        │     ├── QPlainTextEdit (gen_qplaintextedit.d, idx 5000)
        │     ├── QMdiArea (gen_qmdiarea.d, idx 7600)
        │     └── QMdiSubWindow (gen_qmdisubwindow.d, idx 7800)
        ├── QAbstractButton (gen_qabstractbutton.d, idx 3000)
        │     ├── QPushButton (gen_qpushbutton.d, idx 400)
        │     │     └── QCommandLinkButton (gen_qcommandlinkbutton.d, idx 10600)
        │     ├── QCheckBox (gen_qcheckbox.d, idx 1200)
        │     ├── QRadioButton (gen_qradiobutton.d, idx 1600)
        │     └── QToolButton (gen_qtoolbutton.d, idx 10400)
        ├── QAbstractSlider (gen_qabstractslider.d, idx 3200)
        │     ├── QSlider (gen_qslider.d, idx 2000)
        │     ├── QDial (gen_qdial.d, idx 5400)
        │     └── QScrollBar (gen_qscrollbar.d, idx 5200)
        ├── QAbstractSpinBox (gen_qabstractspinbox.d, idx 3400)
        │     ├── QSpinBox (gen_qspinbox.d, idx 1800)
        │     ├── QDoubleSpinBox (gen_qdoublespinbox.d, idx 8600)
        │     └── QDateTimeEdit (gen_qdatetimeedit.d, idx 17000)
        │           ├── QDateEdit (gen_qdatetimeedit.d, idx 17100)
        │           └── QTimeEdit (gen_qdatetimeedit.d, idx 17200)
        ├── QComboBox (gen_qcombobox.d, idx 1400)
        ├── QLineEdit (gen_qlineedit.d, idx 1000)
        ├── QGroupBox (gen_qgroupbox.d, idx 2400)
        ├── QTabWidget (gen_qtabwidget.d, idx 2600)
        ├── QCalendarWidget (gen_qcalendarwidget.d, idx 17300)
        ├── QProgressBar (gen_qprogressbar.d, idx 2200)
        ├── QLCDNumber (gen_qlcdnumber.d, idx 5800)
        ├── QStackedWidget (gen_qstackedwidget.d, idx 8400)
        ├── QMainWindow (gen_qmainwindow.d, idx 6200)
        ├── QDialog (gen_qdialog.d, idx 4600)
        │     └── QProgressDialog (gen_qprogressdialog.d, idx 6000)
        ├── QStatusBar (gen_qstatusbar.d, idx 5600)
        ├── QDockWidget (gen_qdockwidget.d, idx 10800)
        ├── QToolBox (gen_qtoolbox.d, idx 11000)
        └── QSplashScreen (gen_qsplashscreen.d, idx 19788)

Non-widget Qt objects:
  QAction (gen_qaction.d, idx 3800)            : QObject
  QMenu (gen_qmenu.d, idx 4000)                : QWidget
  QMenuBar (gen_qmenubar.d, idx 4200)          : QWidget
  QToolBar (gen_qtoolbar.d, idx 6400)          : QWidget
  QTimer (gen_qtimer.d, idx 4400)              : QObject
  QTabBar (gen_qtabbar.d, idx 16000)           : QWidget
  QHeaderView (gen_qheaderview.d, idx 9800)    : QAbstractItemView
  QClipboard (gen_qclipboard.d, idx 17400)     : singleton
  QButtonGroup (gen_qbuttongroup.d, idx 17500)
  QSystemTrayIcon (gen_qsystemtrayicon.d, idx 19797)
  QProcess (gen_qprocess.d, idx 19816)

Value types (heap-allocated C++, wrapped in D):
  QColor (gen_qcolor.d, idx 14000)
  QFont (gen_qfont.d, idx 10200)
  QIcon (gen_qicon.d, idx 6600)
  QPixmap (gen_qpixmap.d, idx 17600)
  QImage (gen_qimage.d, idx 18200)
  QPainter (gen_qpainter.d, idx 18000)
  QPen (gen_qpen.d, idx 19748)
  QBrush (gen_qbrush.d, idx 19761)
  QPalette (gen_qpalette.d, idx 19768)
  QFontMetrics (gen_qfontmetrics.d, idx 19776)

Dialogs (static methods, null _wh):
  QMessageBox (gen_qmessagebox.d, idx 4800)
  QFileDialog (gen_qfiledialog.d, idx 6800)
  QFontDialog (gen_qfontdialog.d, idx 12000)
  QColorDialog (gen_qcolordialog.d, idx 13000)
  QInputDialog (gen_qinputdialog.d, idx 15000)
```

---

## Индексы функций pFunQt

Полная карта блоков (`PFUNQT_SIZE=25000`, заполнена; свободные места — только дыры, см. `tools/qte/qte.exe index gaps`):

```
QCore:1–76             QWidget:200–399       QPushButton:400        QLayout:600–642
QLabel:800             QLineEdit:1000        QCheckBox:1200         QComboBox:1400
QRadioButton:1600      QSpinBox:1800         QSlider:2000           QProgressBar:2200
QGroupBox:2400         QTabWidget:2600–2649  QFrame:2800            QAbstractButton:3000
QAbstractSlider:3200   QAbstractSpinBox:3400 QObject:3600           QAction:3800–3841
QMenu:4000             QMenuBar:4200         QTimer:4400            QDialog:4600
QMessageBox:4800       QPlainTextEdit:5000–5056  QScrollBar:5200    QDial:5400
QStatusBar:5600        QLCDNumber:5800       QProgressDialog:6000   QMainWindow:6200
QToolBar:6400          QIcon:6600            QFileDialog:6800       QListWidget:7000
QSettings:7200         QAbstractScrollArea:7400  QMdiArea:7600      QMdiSubWindow:7800
QTextEdit:8000–8072    QSplitter:8200        QStackedWidget:8400    QDoubleSpinBox:8600
QAbstractItemView:8800 QTableView:9000       QTableWidget:9200      QTreeView:9400
QTreeWidget:9600–9681  QHeaderView:9800      QScrollArea:10000      QFont:10200
QToolButton:10400      QCommandLinkButton:10600  QDockWidget:10800  QToolBox:11000
QTextBrowser:11200     QFontDialog:12000     QColorDialog:13000     QColor:14000
QInputDialog:15000     QTabBar:16000         QDateTimeEdit:17000    QDateEdit:17100
QTimeEdit:17200        QCalendarWidget:17300 QClipboard:17400       QButtonGroup:17500
QPixmap:17600          QPainter:18000        QImage:18200           QImageReader:18300
QImageWriter:18350     QPicture:18400        QFile:18500            QTextDocument:19000
QSql:19100–19132       QTextCursor:19200–19235  QTextCharFormat:19300–19324
QTextBlockFormat:19400–19419  QTextBlock:19500–19514  QSyntaxHighlighter:19600–19612
QScintilla:19700–19747 (48/48 full)
QPen:19748–19760       QBrush:19761–19767    QPalette:19768–19775
QFontMetrics:19776–19785  QPainter_ext:19786–19787  QSplashScreen:19788–19796
QSystemTrayIcon:19797–19809  QResource:19810–19811  QUiLoader:19812–19815
QProcess:19816–19836   QStringList_ext:19837–19841
Tvision:19850–19884    (qte56_tvision.dll, standalone TUI, без Qt)

QDate:19885–19911      QTime:19912–19933     QDateTime:19934–19968
  → gen_qdate.d, qte56_foundation.dll

QByteArray:19969–19998
  → gen_qbytearray.d, qte56_foundation.dll

QImage_memio:19999–20000   (loadFromData/saveToBuffer)
QPixmap_memio:20001–20002  (loadFromData/saveToBuffer)
  → gen_qimage.d / gen_qpixmap.d, qte56_foundation.dll

QScintilla_ext:20003–20004  (createLexerBash/Batch)
  → gen_qscintilla.d, qte56_qscintilla.dll

QNetwork:20005–20041        (QUrl/QNetworkRequest/QNetworkReply/QNetworkAccessManager)
QNetwork_ext:20042–20045    (ignoreSslErrors/connect_sslErrors/uploadProgress/rawHeaderList)
  → gen_qnetwork.d, qte56_network.dll

QCurl:20046–20072           (libcurl через LoadLibrary; HTTP/HTTPS/FTP/FTPS/SFTP/SCP)
  → gen_qcurl.d, qte56_curl.dll

QThread:20073–20089         QMutex:20090–20095
QWaitCondition:20096–20101  QSemaphore:20102–20108  QReadWriteLock:20109–20117
  → gen_qthread.d, qte56_thread.dll

QCompleter:20118–20131
  → gen_qcompleter.d, qte56_completer.dll

QShortcut:20132–20138 (+augment 20163–20168)
  → gen_qshortcut.d, qte56_shortcut.dll

QFileSystemWatcher:20139–20148
  → gen_qfilesystemwatcher.d, qte56_filewatcher.dll

QDesktopWidget:20149–20154
  → gen_qdesktopwidget.d, qte56_desktop.dll

QShortcut augment:20163–20168   (context, whatsThis, autoRepeat, id, ...)
QPainter augment:18102–18245    (перегрузки с QPoint/QPointF/QRect/QRectF)
QPointF:21800–21808             QRectF:21900–21948
  → gen_qpointf.d / gen_qrectf.d (value-классы, standalone DLL)

Расширения переполненных блоков (не в functions.csv):
  QWidget_geo:398–399           saveGeometry/restoreGeometry (gen_qwidget.d)
  QMainWindow_state:6253–6254   saveState/restoreState (gen_qmainwindow.d)
  QSettings_ba:7221–7222        setValue_ba/value_ba → setBytes/getBytes (gen_qsettings.d)
```

При добавлении нового модуля: выбрать свободный диапазон из дыр нумерации
(`tools/qte/qte.exe index gaps`), внести в `registry/functions.csv`.

> **Правило одного модуля**: если один .d файл загружает функции для нескольких классов (напр. gen_qdate.d — QDate/QTime/QDateTime), **все** `generateFunQt` должны использовать **одно** зарегистрированное имя модуля (напр. `"QDate"`), иначе `loadFn()` вернёт null → crash.

---

## Сигналы и события

### Паттерн ESlot (для большинства сигналов)

```d
// Создать слот с parent = кнопка → авто-удаление при destroy кнопки
auto sl = new ESlot(btn.getWH());
sl.set(cast(void*)&myCallback);
btn.connect_clicked(sl);

// КРИТИЧЕСКИ ВАЖНО: хранить ссылку, иначе GC соберёт ESlot → crash
__gshared ESlot[] g_slots;
g_slots ~= sl;

// Callback для clicked(bool):
extern(C) void myCallback(void* dthis, int n, bool checked) { ... }
// dthis и n передаются из sl.set(cb, dthis=null, n=0)
```

### Прямые сигналы (item-ориентированные)

Некоторые сигналы не используют ESlot — callback передаётся напрямую:

```d
// Пример: QListWidget.onItemClicked
void onItemClicked(void* cb, void* dthis = null);
// cb: extern(C) void function(void* dthis, void* itemPtr)
// itemPtr — QListWidgetItem*
```

### События (event handlers)

Устанавливаются через `setEventHandler(int eventId, void* cb, void* dthis)`. Удобные обёртки:

```d
widget.onMousePress(cb, dthis);
// cb: extern(C) void function(void* dthis, int x, int y, int button)

widget.onMouseRelease(cb, dthis);   // то же
widget.onMouseDoubleClick(cb, dthis); // то же

widget.onMouseMove(cb, dthis);
// cb: extern(C) void function(void* dthis, int x, int y)

widget.onKeyPress(cb, dthis);
// cb: extern(C) void function(void* dthis, int key, int modifiers)

widget.onKeyRelease(cb, dthis);     // то же

widget.onResize(cb, dthis);
// cb: extern(C) void function(void* dthis, int w, int h)

widget.onMove(cb, dthis);
// cb: extern(C) void function(void* dthis, int x, int y)

widget.onClose(cb, dthis);
// cb: extern(C) void function(void* dthis, int* accept) — *accept=1 чтобы закрыть

widget.onShow(cb, dthis);    // cb: extern(C) void function(void* dthis)
widget.onHide(cb, dthis);    // то же
widget.onEnter(cb, dthis);   // то же
widget.onLeave(cb, dthis);   // то же

widget.onWheel(cb, dthis);
// cb: extern(C) void function(void* dthis, int dx, int dy)

widget.onFocusIn(cb, dthis);
// cb: extern(C) void function(void* dthis, int reason)

widget.onFocusOut(cb, dthis); // то же

widget.onContextMenu(cb, dthis);
// cb: extern(C) void function(void* dthis, int x, int y, int reason)

// onPaint (eventId=18):
widget.onPaint(cb, dthis);
// cb: extern(C) void function(void* dthis, void* painterPtr)
// Внутри cb: auto p = new QPainter(widgetPtr, true); ... p.end();
```

---

## Работа со строками

Qt использует `QString` (C++ heap object). В D обёртках это автоматизировано:

```d
// D string → QString* (паттерн setText):
void setText(string text) {
    auto _ws = toQString(text);
    (cast(t_v__qp_qp)pFunQt[825])(_wh, _ws);
    (cast(t_v__qp)pFunQt[22])(_ws);  // освободить pFunQt[22] = qteQString_delete
}

// QString* → D string (паттерн getText):
string text() {
    void* _qs = (cast(t_qp__qp)pFunQt[806])(_wh);
    string _r = fromQString(_qs);
    (cast(t_v__qp)pFunQt[22])(_qs);  // освободить
    return _r;
}
```

Правило: любой `void*` возвращённый Qt как `QString*` — освобождать через `pFunQt[22]` после конвертации в D string.

**QStringList**: `toQStringList(string[])` объединяет через `\x01`. C++ делает `split(QChar(1))`. `freeQStringList(void*)` = `pFunQt[22]`.

---

## Лайауты (gen_qlayout.d, индексы 600–642)

```d
import gen_qlayout;

auto vbox = new QVBoxLayout();
auto hbox = new QHBoxLayout();
auto grid = new QGridLayout();
auto form = new QFormLayout();
```

### Typed API (рекомендуется, с 2026-04-09)

Типизированные перегрузки автоматически вызывают `disown()` — ручной вызов больше не нужен.
Принимают `QObject` (виджеты) или шаблон `(L)(...)` (layouts).

```d
// addWidget — принимает QObject (QLabel, QPushButton, QWidget, QFrame и все потомки)
vbox.addWidget(lbl);            // disown() вызывается автоматически
vbox.addWidget(btn, stretch);

// addLayout — шаблон, принимает QVBoxLayout / QHBoxLayout / QGridLayout / QFormLayout
vbox.addLayout(hbox);           // disown() вызывается автоматически
vbox.addLayout(inner, stretch);

// insertWidget
vbox.insertWidget(0, lbl);      // disown() автоматически

// setLayout на QWidget
win.setLayout(vbox);            // disown() вызывается автоматически — НЕ нужен vbox.disown()

// QGridLayout — typed addWidget
grid.addWidget(lbl, row, col);
grid.addWidget(lbl, row, col, rowSpan, colSpan);
grid.addLayout(hbox, row, col);

// QFormLayout — typed addRow / insertRow
form.addRow("Имя:", edit);      // второй аргумент QObject — disown() авто
form.insertRow(0, "Поле:", lbl);

// setCentralWidget (QMainWindow)
mw.setCentralWidget(centralWidget);   // disown() авто

// QTabWidget.addTab / insertTab
tabs.addTab(page, "Вкладка 1");
tabs.insertTab(0, page, "Первая");

// QStackedWidget / QToolBar / QScrollArea / QDockWidget / QSplitter
stacked.addWidget(page);        // все типизированы — disown() авто
toolbar.addWidget(customBtn);
scroll.setWidget(content);
dock.setWidget(panel);
splitter.addWidget(panel);
splitter.insertWidget(0, panel);
```

### Void* API (обратная совместимость, требует ручного disown)

```d
// Старый способ — по-прежнему работает:
vbox.addWidget(btn.getWH());
vbox.addWidget(btn.getWH(), stretch);
hbox.addStretch(1);
vbox.addLayout(hbox.getWH());

// QGridLayout
grid.addWidget(w.getWH(), row, col);
grid.addWidget(w.getWH(), row, col, rowSpan, colSpan);
grid.setRowStretch(0, 1);
grid.setColumnStretch(1, 2);

// QFormLayout
form.addRow("Имя:", edit.getWH());
form.addRow(label.getWH(), widget.getWH());
form.rowCount();

// ВАЖНО: disown() после setLayout (только void* API)
win.setLayout(vbox.getWH());
vbox.disown();  // Qt теперь владеет лайаутом

// Расширенные методы (индексы 629–642):
vbox.removeWidget(btn.getWH());          // 629
vbox.activate();                         // 630 → int (bool)
vbox.update();                           // 631
vbox.insertWidget(idx, w.getWH(), str);  // 632 — void* версия
vbox.addSpacing(10);                     // 633
vbox.insertSpacing(idx, size);           // 634
vbox.setStretch(idx, stretch);           // 635
vbox.stretchAt(idx);                     // 636
grid.rowStretch(row);                    // 637
grid.columnStretch(col);                 // 638
grid.setRowMinimumHeight(row, h);        // 639
grid.setColumnMinimumWidth(col, w);      // 640
form.removeRow(row);                     // 641
form.insertRow(row, "Label", w.getWH()); // 642 — void* версия
```

---

## Минимальный рабочий пример

```d
import qte56_core, qte56_loader, qte56_enums;
import gen_qcore, gen_qwidget, gen_qlayout;
import gen_qlabel, gen_qpushbutton, gen_qlineedit;
import gen_qabstractbutton, gen_qframe, gen_qobject;

// ВАЖНО: void main(), НЕ extern(C) int main()!
void main() {
    LoadQt("./dll");   // ПЕРЕД new QApplication

    auto app = new QApplication("myapp");

    auto win = new QWidget(cast(void*)null);
    win.setWindowTitle("Моё приложение");
    win.resize(400, 300);

    auto vbox = new QVBoxLayout();
    auto lbl  = new QLabel("Привет, мир!", cast(void*)null);
    auto btn  = new QPushButton(cast(void*)null);
    btn.setText("Нажми меня");

    // Typed API: disown() вызывается автоматически — ничего лишнего писать не нужно
    vbox.addWidget(lbl);
    vbox.addWidget(btn);
    win.setLayout(vbox);
    // vbox.disown() — НЕ нужен: setLayout(vbox) делает это сам

    // ESlot — хранить в __gshared!
    __gshared ESlot[] g_slots;
    auto sl = new ESlot(btn.getWH());
    extern(C) static void onBtnClick(void* dthis, int n, bool checked) {
        import std.stdio : writeln;
        writeln("Кнопка нажата!");
    }
    sl.set(cast(void*)&onBtnClick);
    btn.connect_clicked(sl);
    g_slots ~= sl;

    win.show();
    app.exec();
    app.deleteApp();  // ОБЯЗАТЕЛЕН
    // UnloadQt() НЕ вызывать — OS освобождает DLL
}
```

Сборка (Windows):

```bat
set MINGW=C:\Qt5_13_2\Tools\mingw730_32\bin
set QT=C:\Qt5_13_2\5.13.2\mingw73_32\bin
set PATH=%MINGW%;%QT%;%PATH%

dmd -m32 ^
    myapp.d ^
    d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qwidget.d d\gen\gen_qlayout.d ^
    d\gen\gen_qlabel.d d\gen\gen_qpushbutton.d d\gen\gen_qlineedit.d ^
    d\gen\gen_qabstractbutton.d d\gen\gen_qframe.d d\gen\gen_qobject.d ^
    -Id -Id\gen ^
    -of=myapp.exe
```

---

## Enums (qte56_enums.d)

Все `Qt::` enums завёрнуты в `class QtE`:

```d
import qte56_enums;

label.setAlignment(QtE.AlignmentFlag.AlignCenter);           // 0x0084
label.setAlignment(QtE.AlignmentFlag.AlignLeft | QtE.AlignmentFlag.AlignVCenter);
slider.setOrientation(QtE.Orientation.Horizontal);            // 1
checkbox.setCheckState(QtE.CheckState.Checked);               // 2
btn.setFocusPolicy(QtE.FocusPolicy.StrongFocus);
win.setWindowFlags(QtE.WindowType.FramelessWindowHint);
widget.setContextMenuPolicy(QtE.ContextMenuPolicy.CustomContextMenu);
treeItem.setFlags(QtE.ItemFlag.ItemIsSelectable | QtE.ItemFlag.ItemIsEnabled);
```

Отдельные enums (не внутри QtE):

```d
frame.setFrameStyle(FrameShape.HLine | FrameShadow.Sunken);
tabWidget.setTabPosition(TabPosition.North);  // 0=North, 1=South, 2=West, 3=East

// QPalette ColorGroup: Active=0, Disabled=1, Inactive=2
// QPalette ColorRole: WindowText=0, Button=1, Window=10, Highlight=12

// QSystemTrayIcon ActivationReason: Unknown=0, Context=1, DoubleClick=2, Trigger=3, MiddleClick=4
// QSystemTrayIcon MessageIcon: NoIcon=0, Information=1, Warning=2, Critical=3
```

---

## Value types: QColor, QFont, QPixmap, QIcon, QPainter

### QColor (индексы 14000+)

```d
import gen_qcolor;

auto c = new QColor(255, 0, 0);      // RGB
auto c = new QColor(255, 0, 0, 128); // RGBA
auto c = QColor.fromRgb(r, g, b);
auto c = QColor.fromHsv(h, s, v);
auto c = QColor.fromRgba(rgba);      // ARGB packed int
auto c = QColor.fromString("#FF0000");

c.red(); c.green(); c.blue(); c.alpha();
c.isValid();
c.name();  // "#rrggbb"
// QColor.wrap(ptr) — для heap-возвратов из Qt
```

### QFont (индексы 10200+)

```d
import gen_qfont;

auto f = new QFont("Arial", 12, 50, false); // family, pointSize, weight, italic
f.setBold(true); f.setItalic(true);
f.setPointSize(14); f.setFamily("Courier");
f.applyTo(widget.getWH());          // helper: применить к виджету
auto f2 = QFont.fromWidget(widget.getWH());
widget.setFont(f.getWH());          // через QWidget метод
// QFont.wrap(ptr)
```

### QPixmap (индексы 17600+)

```d
import gen_qpixmap;

auto px = new QPixmap(200, 100);    // w, h
auto px = new QPixmap("image.png"); // load file
px.fill(0xFF0000FF);                // ARGB
px.save("output.png");
auto px2 = px.scaled(100, 100, QtE.AspectRatioMode.KeepAspectRatio);
// scaled() возвращает НОВЫЙ owned QPixmap
label.setPixmap(px.getWH());
// ВАЖНО: qteQLabel_setPixmap живёт в qte56_qpixmap.dll — нужен import gen_qpixmap
// QPixmap.wrap(ptr)
```

### QIcon (индексы 6600+)

```d
import gen_qicon;

auto ico = new QIcon("icon.png");
auto ico = new QIcon(pixmap.getWH());
win.setWindowIcon(ico.getWH());
// QIcon.wrap(ptr)
```

### QPainter (индексы 18000+)

```d
import gen_qpainter;

// В onPaint callback:
extern(C) void onPaint(void* dthis, void* wh) {
    auto p = new QPainter(wh, true);  // wh = виджет, true = begin()
    p.drawLine(x1, y1, x2, y2);
    p.drawRect(x, y, w, h);
    p.drawEllipse(x, y, w, h);
    p.drawText(x, y, "text");
    p.setPen(colorPtr);
    p.setPen(QtE.PenStyle.DashLine);
    p.setBrush(brushPtr);
    p.fillRect(x, y, w, h, colorPtr);
    p.setFont(fontPtr);
    p.save(); p.restore();
    p.translate(dx, dy);
    p.rotate(angle);
    p.scale(sx, sy);
    p.setOpacity(0.5);
    p.setRenderHint(1, true);         // 1=Antialiasing
    p.drawPixmap(x, y, pixmapPtr);
    p.drawImage(x, y, imagePtr);
    p.end();  // ОБЯЗАТЕЛЕН
}
// QPainter.wrap(ptr)
```

---

## Диалоги

### QMessageBox (индексы 4800+)

```d
import gen_qmessagebox;

QMessageBox.information(win.getWH(), "Заголовок", "Сообщение");
QMessageBox.warning(win.getWH(), "Внимание", "Текст");
QMessageBox.critical(win.getWH(), "Ошибка", "Текст");
QMessageBox.question(win.getWH(), "Вопрос", "Да или нет?");

// С кнопками:
int result = QMessageBox.exec_question(parent, "?", "Сохранить?",
    QMessageBox.Yes | QMessageBox.No);
// Константы: NoButton=0, Ok=1024, Cancel=4194304, Yes=16384, No=65536

// Инстанс:
auto mb = new QMessageBox(cast(void*)null);
mb.setText("Заголовок");
mb.setInformativeText("Подробности");
mb.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel);
int r = mb.exec();
```

### QFileDialog

```d
import gen_qfiledialog;

string path = QFileDialog.getOpenFileName(parent, "Открыть", "", "*.txt;;All Files (*)");
string path = QFileDialog.getSaveFileName(parent, "Сохранить", "", "*.txt");
string dir  = QFileDialog.getExistingDirectory(parent, "Папка", ".");
```

### QInputDialog

```d
import gen_qinputdialog;

bool ok;
string text = QInputDialog.getText(parent, "Заголовок", "Подсказка:", &ok);
int n    = QInputDialog.getInt(parent, "Заголовок", "Число:", def, min, max, step, &ok);
double d = QInputDialog.getDouble(parent, "Заголовок", "Число:", def, min, max, dec, &ok);

// Инстанс:
auto dlg = new QInputDialog(cast(void*)null);
dlg.setComboBoxItems(["Alpha", "Beta", "Gamma"]);
dlg.exec();
```

### QFontDialog

```d
import gen_qfontdialog;
bool ok;
void* fontPtr = QFontDialog.getFont(&ok, parent);
if (ok) auto f = QFont.wrap(fontPtr);
```

### QColorDialog

```d
import gen_qcolordialog;
void* colorPtr = QColorDialog.getColor(null, parent);
auto c = QColor.wrap(colorPtr);
```

---

## QSS стили (qte56_style.d)

```d
import qte56_style;

applyQss(app, "themes/dark.qss");              // из файла, заменить
appendQss(app, "overrides.qss");               // дописать поверх
applyQssFiles(app, ["base.qss", "dark.qss"], skipMissing: true);
clearStyleSheet(app);
applyQssWidget(panel, "sidebar.qss");          // для конкретного виджета

setQssEngine(app, "Fusion");                   // стиль-движок до applyQss
applyQss(app, "dark.qss");

QssTheme theme = { style: "Fusion", files: ["themes/dark.qss"] };
theme.apply(app);

// Из Qt Resources:
import qte56_resource;
registerRcc("themes.rcc");
applyQssRes(app, ":/themes/dark.qss");
```

---

## Формы Qt Designer (qte56_forms.d)

```d
import qte56_forms;

auto form = QForm.load("dialog.ui");
if (form is null) { writeln("Ошибка"); return; }

auto lbl   = form.findLabel("labelTitle");
auto btn   = form.findButton("btnOk");
auto edit  = form.findLineEdit("editName");
auto cb    = form.findCheckBox("checkRemember");
auto combo = form.findComboBox("comboLang");
auto spin  = form.findSpinBox("spinCount");
auto dspin = form.findDoubleSpinBox("spinValue");
auto group = form.findGroupBox("groupOptions");

form.show();
form.widget();  // → QWidget (корневой)

// Прямое использование QUiLoader:
import gen_quiloader;
auto loader = new QUiLoader();
void* rootWH = loader.load("dialog.ui", parentWH);
auto widget = QWidget.wrap(rootWH);

// Найти любой дочерний виджет:
void* btnWH = findChildWidget(rootWH, "btnOk");
auto btn = QPushButton.wrap(btnWH);
```

---

## QResource (qte56_resource.d)

```d
import qte56_resource;

bool ok = registerRcc("assets.rcc");
bool ok = registerRcc(":/prefix", "assets.rcc");

bool exists  = resourceExists(":/images/logo.png");
string text  = readResourceText(":/css/dark.qss");
ubyte[] data = readResourceBytes(":/fonts/custom.ttf");
int size     = resourceSize(":/data/config.json");

applyQssRes(app, ":/themes/dark.qss");
appendQssRes(app, ":/themes/extra.qss");

QssThemeRes theme = {
    rccFile: "themes.rcc",
    styleName: "Fusion",
    qssPath: ":/themes/dark.qss",
};
theme.apply(app);
```

---

## QSql (qte56_sql.dll, индексы 19100–19132)

```d
import gen_qsql;

auto db = new QSqlDatabase();
db.openSqlite("path/to/db.sqlite");
db.openMemory();                          // SQLite в памяти

QSqlDatabase.addPluginPath("./plugins"); // если sqldrivers/ не рядом с .exe

auto q = new QSqlQuery(db);
q.exec("CREATE TABLE t (id INTEGER, name TEXT)");
q.exec("INSERT INTO t VALUES (1, 'Alice')");

// Параметризованный запрос:
q.prepare("INSERT INTO t VALUES (?, ?)");
q.bindInt(0, 42);
q.bindString(1, "Bob");
q.execPrepared();

// Чтение:
q.exec("SELECT id, name FROM t");
while (q.next()) {
    int    id   = q.valueInt(0);
    string name = q.valueString(1);
    bool   isNull = q.isNull(1);
}
// ВАЖНО: SQLite numRows() всегда = -1; итерировать через next()

db.transaction();
q.exec("UPDATE ...");
db.commit();  // или db.rollback()
```

Deploy: поместить `dll/sqldrivers/qsqlite.dll` рядом с exe.

---

## QProcess (индексы 19816–19836)

```d
import gen_qprocess;

auto proc = new QProcess(cast(void*)null);

proc.start("python", ["--version"]);
proc.startDetached("notepad.exe");

proc.waitForStarted(3000);
proc.waitForFinished(5000);

string out_ = proc.readAllStandardOutput();
string err  = proc.readAllStandardError();

int code   = proc.exitCode();
int status = proc.exitStatus();  // 0=Normal, 1=Crash
// ВАЖНО: QProcess::FailedToStart == 0 (не 1!)

auto sl = new ESlot(proc.getWH());
sl.set(cast(void*)&onFinished);
proc.connect_finished(sl);
// cb: extern(C) void function(void* dthis, int n, int exitCode, int exitStatus)

proc.connect_readyReadStdOut(sl);  // cb: function(void* dthis, int n)
proc.connect_errorOccurred(sl);    // cb: function(void* dthis, int n, int error)

proc.kill();
proc.terminate();
```

---

## QScintilla (индексы 19700–19747)

Требует два DLL: `dll/qte56_qscintilla.dll` + `dll/qscintilla2_qt5.dll` — оба должны быть в PATH.

```d
import gen_qscintilla;
import qte56_enums;  // SCI, SCLEX, SCE_B, SCFIND, SciFolding

auto sci = new QScintilla(parent);

// sendMsg — основной API:
sci.sendMsg(SCI.SCI_SETTEXT, 0, cast(size_t)"hello world".ptr);
sci.sendMsg(SCI.SCI_SETLEXER, SCLEX.SCLEX_CPP);
sci.sendMsg(SCI.SCI_SETKEYWORDS, 0, cast(size_t)"class void int".ptr);
sci.sendMsg(SCI.SCI_STYLESETFORE, STYLE_DEFAULT, 0x000000);
sci.sendMsg(SCI.SCI_STYLESETBOLD, SCE_B.SCE_B_KEYWORD, 1);

// Высокоуровневые методы:
sci.setText("code here");
sci.appendText("\nmore code");
sci.clearAll();
string text = sci.getText();
int pos = sci.getCurrentPos();
sci.gotoPos(pos);
sci.gotoLine(lineNum);
sci.selectAll();
string sel = sci.getSelText();
sci.replaceSel("new text");

// Поиск:
sci.setSearchFlags(SCFIND.SCFIND_MATCHCASE | SCFIND.SCFIND_WHOLEWORD);
sci.setTargetStart(0); sci.setTargetEnd(len);
int found = sci.searchInTarget("keyword");

bool found = sci.findFirst("pattern", false, true, false, true);
bool next  = sci.findNext();
sci.replaceTarget("replacement");

// Автодополнение:
sci.showAutoComplete(3, "word1 word2 word3");
sci.cancelAutoComplete();

// Фолдинг:
sci.sendMsg(SCI.SCI_SETFOLDFLAGS, SciFolding.BoxedFoldStyle);

// Сигналы:
sci.connect_textChanged(sl);           // cb: function(void* dthis, int n)
sci.connect_cursorPositionChanged(sl); // cb: function(void* dthis, int n, int line, int col)
```

---

## Критические ошибки (Gotchas)

### 1. void main(), НЕ extern(C) int main()

`extern(C) int main()` не выполняет `static this()` D-модулей → `_modules` пуст → `pFunQt[] = null` → crash при первом вызове виджета.

```d
void main() { ... }            // ПРАВИЛЬНО
extern(C) int main() { ... }   // НЕПРАВИЛЬНО
```

### 2. LoadQt() ПЕРЕД new QApplication()

```d
LoadQt("./dll");               // 1
auto app = new QApplication(); // 2
```

### 3. app.deleteApp() обязателен в конце

```d
app.exec();
app.deleteApp();   // снимает GC.removeRoot + обнуляет pFunQt[]
// UnloadQt() НЕ вызывать — DLL освобождает OS
```

### 4. ESlot должен жить в __gshared

```d
// ПЛОХО: GC соберёт sl → crash при следующем сигнале
void connectBtn() {
    auto sl = new ESlot(btn.getWH());
    sl.set(cast(void*)&cb);
    btn.connect_clicked(sl);
}  // sl выходит из области видимости!

// ХОРОШО:
__gshared ESlot[] g_slots;
void connectBtn() {
    auto sl = new ESlot(btn.getWH());
    sl.set(cast(void*)&cb);
    btn.connect_clicked(sl);
    g_slots ~= sl;
}
```

### 5. Конструкторы с неоднозначным null

```d
auto lbl = new QLabel(cast(void*)null);   // ПРАВИЛЬНО: явный cast
auto lbl = new QLabel(null);              // может не скомпилироваться
// Актуально для: QLabel, QAction, QMessageBox, QInputDialog — везде где есть
// this(void*) и this(string, void*=null)
```

### 6. disown() после setLayout / addWidget

**Типизированный API (рекомендуется)** — disown() вызывается автоматически:

```d
// setLayout с типом — disown() не нужен:
win.setLayout(vbox);

// addWidget с типом — disown() не нужен:
vbox.addWidget(lbl);
vbox.addLayout(inner);
mw.setCentralWidget(widget);
tabs.addTab(page, "Name");
```

**Void* API (обратная совместимость)** — disown() нужен вручную:

```d
win.setLayout(vbox.getWH());
vbox.disown();  // Qt владеет; без disown() → двойной delete при закрытии

vbox.addWidget(lbl.getWH());
lbl.disown();   // аналогично для виджетов с null-parent
```

### 7. QCheckBox: нет setChecked() — только setCheckState()

```d
cb.setCheckState(2);                       // 2 = Qt::Checked
cb.setCheckState(QtE.CheckState.Checked);  // через enum
// setChecked() отсутствует в D обёртке
```

### 8. Signal: установить значение ДО подключения

```d
slider.setValue(50);             // 1. Значение
slider.connect_valueChanged(sl); // 2. Подключить
```

### 9. QMenu/QAction: wrap() для Qt-owned указателей

```d
void* menuPtr = menuBar.addMenu("Файл");
auto menu = QMenu.wrap(menuPtr);   // wrap: Qt владеет, D не удаляет
// НЕ: new QMenu(menuPtr) — создаст НОВЫЙ объект
```

### 10. setPixmap требует import gen_qpixmap

```d
import gen_qpixmap;  // ОБЯЗАТЕЛЕН — иначе pFunQt[17613] = null → crash
label.setPixmap(px.getWH());
// Функция qteQLabel_setPixmap живёт в qte56_qpixmap.dll, не в qte56_qlabel.dll
```

### 11. QTreeWidgetItem / QTableWidgetItem: disown() после добавления

```d
auto item = new QTreeWidgetItem();
item.setText(0, "Root");
tree.addTopLevelItem(item.getWH());
item.disown();  // Qt владеет; без disown() → двойной delete
```

### 12. QClipboard — синглтон, не удалять

```d
auto clip = QClipboard.get();  // НЕ new QClipboard()
clip.setText("hello");
// Windows: processEvents() нужен после setText() для доставки сигнала dataChanged
```

### 13. QCalendarWidget: minimumDate может быть 4713 до н.э.

```d
auto cal = new QCalendarWidget(cast(void*)null);
// cal.minimumDate().year может быть -4713 (fromJulianDay(1))
// Используй selectedDate() для текущей выбранной даты
DDate selected = cal.selectedDate();
```

### 14. QDateTimeEdit / QDateEdit / QTimeEdit — один DLL, один D-файл

Все три класса в `qte56_qdatetimeedit.dll` и в `gen_qdatetimeedit.d`.

### 15. QPainter: begin()/end() обязательны

```d
auto p = new QPainter(widgetWH, true);  // true = begin() сразу
// ... рисование ...
p.end();  // ОБЯЗАТЕЛЕН — иначе Qt: "painter not ended"
```

### 16. QProcess::FailedToStart == 0 (не 1)

```d
if (proc.exitStatus() == 0) { /* FailedToStart, не Normal! */ }
// Normal=0 только для exitStatus(); для error() FailedToStart=0
```

### 17. Кириллица в .bat файлах

Избегать кириллицы и многострочных if-блоков в .bat — портит cmd.exe в UTF-8 режиме.

### 18. Linux / ldc2 — строгость

- `gen_qdatetimeedit.d`: нужен `this(bool _noOp) { super(_noOp); }` вместо `this() {}`
- `gen_qsplitter.d`: каст `t_qp__qp_i_qp` (был `t_qp__qp_qp`)
- `LoadQt()` / `LoadWren()`: автофаллбек `./dll` → `./lib`

### 19. Старые копии DLL в корне (Wren/OLE)

`LoadLibraryA` находит первый файл в PATH. Удалять старые копии `ole_helper.dll` из корня проекта.

### 20. QTabBar.wrap() — Qt-owned

```d
void* tbPtr = tabWidget.tabBar();
auto tb = QTabBar.wrapOwned(tbPtr);  // не удалять при destroy
```

### 21. QThread: connect_started/finished — QueuedConnection

`connect_started` и `connect_finished` используют `QCoreApplication::instance()` как context → `QueuedConnection` → callback выполняется в главном потоке. Требует:
```d
import core.memory : GC;
// Перед завершением приложения:
GC.collect();       // финализировать объекты до удаления QApplication
app.deleteApp();    // ПОСЛЕ GC.collect()
```

### 22. QCompleter: Qt-owned после attachTo()

```d
auto comp = new QCompleter();
comp.attachTo(edit.getWH());  // Qt берёт ownership → НЕ вызывать comp.delete_()
```

### 23. QShortcut: нет деструктора, использовать free()

```d
auto sc = new QShortcut(win.getWH(), "Ctrl+Q");
// ... позже ...
sc.free();  // для ранней очистки; после destroy parent-a sc удаляется автоматически
```

### 24. QFileSystemWatcher: после удаления файла переподписаться

```d
extern(C) void onFileChanged(void* dthis, string path) {
    // Watcher снимает наблюдение при удалении файла:
    watcher.addPath(path);  // переподписаться
    // ...
}
```

### 25. QMdiArea addSubWindow + onClose = crash

`addSubWindow()` возвращает plain `QMdiSubWindow`, у которого нет `eQMdiSubWindow.onClose`.
Решение: создать `new QMdiSubWindow(mdi.getWH())` + `msw.setWidget(container)` вместо `addSubWindow`.

### 26. Генератор: одно имя модуля на .d файл

Если один `.d` файл загружает функции для нескольких Qt-классов (например `gen_qdate.d` — QDate, QTime, QDateTime), **все** вызовы `generateFunQt` должны использовать **одно** зарегистрированное имя (`"QDate"`), иначе `loadFn()` вернёт null → crash.

---

## DLL группы

### Merged DLLs

| DLL | Классы |
|-----|--------|
| `qte56_qcore.dll` | QApplication, QString, ESlot, QRect/Point/Size |
| `qte56_widgets.dll` | QWidget, QLabel, QPushButton, QFrame, QLineEdit, QCheckBox, QRadioButton, QGroupBox, QComboBox, QSpinBox, QDoubleSpinBox, QProgressBar, QSlider, QScrollBar, QDial, QStackedWidget, QLCDNumber, QScrollArea, QSplitter, QTextBrowser, QCommandLinkButton, QDockWidget, QToolBox, QTabWidget, QTabBar, QHeaderView |
| `qte56_foundation.dll` | QAbstractButton, QAbstractSlider, QAbstractSpinBox, QAbstractScrollArea, QAbstractItemView, QFrame_base, QObject, QAction, QMenu, QMenuBar |
| `qte56_views.dll` | QTableView, QTableWidget, QTreeView, QTreeWidget, QListWidget, QMdiArea, QMdiSubWindow, QTableWidgetItem, QTreeWidgetItem, QListWidgetItem, QSettings |
| `qte56_text.dll` | QTextEdit, QPlainTextEdit, QTextDocument, QTextCursor, QTextCharFormat, QTextBlockFormat, QTextBlock, QSyntaxHighlighter |
| `qte56_dialogs.dll` | QDialog, QMessageBox, QFileDialog, QProgressDialog, QFontDialog, QColorDialog, QInputDialog |
| `qte56_mainwin.dll` | QMainWindow, QStatusBar, QToolBar, QToolButton, QTimer, QDockWidget, QDateTimeEdit, QDateEdit, QTimeEdit, QCalendarWidget |

### Special standalone DLLs

| DLL | Содержимое |
|-----|-----------|
| `qte56_drawing.dll` | QPen, QBrush, QPalette, QFontMetrics, QPainter ext |
| `qte56_sql.dll` | QSqlDatabase, QSqlQuery |
| `qte56_systray.dll` | QSplashScreen, QSystemTrayIcon |
| `qte56_resource.dll` | QResource, QFile |
| `qte56_uiloader.dll` | QUiLoader |
| `qte56_qprocess.dll` | QProcess |
| `qte56_qscintilla.dll` | QScintilla (+ qscintilla2_qt5.dll) |
| `qte56_tvision.dll` | Turbo Vision TUI (standalone, без Qt) |
| `qte56_network.dll` | QUrl, QNetworkRequest, QNetworkReply, QNetworkAccessManager |
| `qte56_curl.dll` | libcurl через LoadLibrary; HTTP/HTTPS/FTP/FTPS/SFTP/SCP (без Qt) |
| `qte56_thread.dll` | QThread, QMutex, QWaitCondition, QSemaphore, QReadWriteLock |
| `qte56_completer.dll` | QCompleter (popup/inline autocomplete для QLineEdit/QComboBox) |
| `qte56_shortcut.dll` | QShortcut (горячие клавиши, VoidClosure паттерн) |
| `qte56_filewatcher.dll` | QFileSystemWatcher (мониторинг файлов/директорий) |
| `qte56_desktop.dll` | QDesktopWidget — статические методы, screenGeometry/centeredPos |

---

## Генератор кода

```
generator/
├── main.py      ← py main.py <header.h> --module QFoo --index-start 21400
├── qt_parser.py ← разбор C++ заголовков Qt
├── type_map.py  ← маппинг C++ типов → D alias коды
├── planner.py / checks.py / registry.py / fileops.py / geninfo.py / cpp_texts.py
├── cpp_generator.py / d_generator.py / events.py / qt_hierarchy.py
├── qt_knowledge.py / knowledge_access.py  ← база знаний Qt
├── augment.py / scan_augment.py           ← режим --augment, скан покрытия
└── test_new_class.py / make_build.py / merge_dlls.py / reindex.py / scan_ldc2_bugs.py
```

```bat
py generator\main.py <qt_header.h> --module QFoo --dll qte56_qfoo.dll --index-start 21400
```

Результат: `d/gen/gen_qfoo.d` + C++ проект в `cpp/qt5/qte56_qfoo/`. Ручные правки не делать — перегенерировать (или дополнять режимом `--augment`). Ручные изменения документировать в `registry/functions.csv`.

Файл `registry/functions.csv` — источник истины для всех индексов (UTF-8!):
```
index,func_name,module,dll,category
800,qteQLabel_create,QLabel,qte56_widgets.dll,lifecycle
801,qteQLabel_delete,QLabel,qte56_widgets.dll,lifecycle
```

---

## Добавление нового класса Qt

### Шаг 1: C++ файлы

```cpp
// cpp/qt5/qte56_myfoo/qte56_myfoo.h
#pragma once
#include <QMyFoo>
#define EXPORT extern "C" __declspec(dllexport)

EXPORT void* qteQMyFoo_create(void* parent);
EXPORT void  qteQMyFoo_delete(void* obj);
EXPORT void* qteQMyFoo_text(void* obj);
EXPORT void  qteQMyFoo_setText(void* obj, void* qs);
```

```cpp
// cpp/qt5/qte56_myfoo/qte56_myfoo.cpp
#include "qte56_myfoo.h"

void* qteQMyFoo_create(void* parent) {
    return new QMyFoo(static_cast<QWidget*>(parent));
}
void qteQMyFoo_delete(void* obj) { delete static_cast<QMyFoo*>(obj); }
void* qteQMyFoo_text(void* obj) {
    return new QString(static_cast<QMyFoo*>(obj)->text());
}
void qteQMyFoo_setText(void* obj, void* qs) {
    static_cast<QMyFoo*>(obj)->setText(*static_cast<QString*>(qs));
}
```

### Шаг 2: Выбрать индексы

Таблица `pFunQt[25000]` практически заполнена (макс. занятый индекс 24713 на 2026-08-02). Свободный диапазон выбрать из дыр: `tools/qte/qte.exe index gaps`. В примере ниже используется 21400–21403 (дыра 21305–21799). Внести в `registry/functions.csv`.

### Шаг 3: D файл (gen_qmyfoo.d)

```d
module gen_qmyfoo;
import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__qp, t_v__qp, t_v__qp_qp, toQString, fromQString;
import gen_qwidget : QWidget;

static this() { registerModule("QMyFoo", "qte56_widgets.dll", &loadQMyFoo); }

void loadQMyFoo() {
    mixin(generateFunQt(21400, "qteQMyFoo_create",  "QMyFoo"));
    mixin(generateFunQt(21401, "qteQMyFoo_delete",  "QMyFoo"));
    mixin(generateFunQt(21402, "qteQMyFoo_text",    "QMyFoo"));
    mixin(generateFunQt(21403, "qteQMyFoo_setText", "QMyFoo"));
}

class QMyFoo : QWidget {
public:
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[21400])(parent);
    }
    protected this(bool _noOp) { super(_noOp); }
    static QMyFoo wrap(void* wh) {
        auto w = new QMyFoo(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }
    ~this() {
        if (_wh !is null && !_qt_owned && pFunQt[21401] !is null) {
            (cast(t_v__qp)pFunQt[21401])(_wh);
            _wh = null;
        }
    }
    string text() {
        void* qs = (cast(t_qp__qp)pFunQt[21402])(_wh);
        string r = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return r;
    }
    void setText(string t) {
        auto ws = toQString(t);
        (cast(t_v__qp_qp)pFunQt[21403])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
    }
    void* getWH() { return _wh; }
}
```

### Шаг 4: Добавить в merged DLL или создать отдельный .pro/.sh

---

## Быстрые паттерны

### 1. Главное окно с меню и статусбаром

```d
import gen_qmainwindow, gen_qmenubar, gen_qmenu, gen_qaction, gen_qstatusbar;

auto win = new QMainWindow(cast(void*)null);
win.setWindowTitle("App");

auto mb   = win.menuBar();
void* fm  = mb.addMenu("Файл");
auto menu = QMenu.wrap(fm);

void* acqit = menu.addAction("Выход");
auto actQuit = QAction.wrap(acqit);

auto sl = new ESlot(actQuit.getWH());
sl.set(cast(void*)&onQuit);
actQuit.connect_triggered(sl);
g_slots ~= sl;

auto sb = win.statusBar();
sb.showMessage("Готово");

win.resize(800, 600);
win.show();

// cb:
extern(C) static void onQuit(void* dthis, int n, bool checked) {
    import gen_qcore : qapp;
    qapp.quit();
}
```

### 2. QTableWidget с заголовками и данными

```d
import gen_qtablewidget;

auto tbl = new QTableWidget(cast(void*)null);
tbl.setRowCount(3);
tbl.setColumnCount(2);
tbl.setHorizontalHeaderLabels(["Имя", "Возраст"]);

// Заполнить ячейки:
auto item = new QTableWidgetItem("Alice");
tbl.setItem(0, 0, item.getWH());
item.disown();

auto item2 = new QTableWidgetItem("30");
tbl.setItem(0, 1, item2.getWH());
item2.disown();

// Сигнал выбора ячейки:
auto sl = new ESlot(tbl.getWH());
sl.set(cast(void*)&onCellClicked);
tbl.connect_cellClicked(sl);
g_slots ~= sl;
// cb: extern(C) void function(void* dthis, int n, int row, int col)
```

### 3. QTimer для периодических задач

```d
import gen_qtimer;

auto timer = new QTimer(cast(void*)null);
timer.setInterval(1000);  // мс

auto sl = new ESlot(timer.getWH());
sl.set(cast(void*)&onTick);
timer.connect_timeout(sl);
g_slots ~= sl;

timer.start();
// cb: extern(C) void function(void* dthis, int n)

// Одноразовый таймер:
QTimer.singleShot(500, cast(void*)&onOnce, null);
```

### 4. QTreeWidget с иерархией

```d
import gen_qtreewidget;

auto tree = new QTreeWidget(cast(void*)null);
tree.setColumnCount(2);
tree.setHeaderLabels(["Ключ", "Значение"]);

// Корневой элемент:
auto root = new QTreeWidgetItem();
root.setText(0, "Корень");
root.setText(1, "данные");
tree.addTopLevelItem(root.getWH());
root.disown();

// Дочерний элемент:
auto child = new QTreeWidgetItem();
child.setText(0, "Дочерний");
root.addChild(child.getWH());
child.disown();

tree.expandAll();

// Сигнал:
auto sl = new ESlot(tree.getWH());
sl.set(cast(void*)&onItemClicked);
tree.connect_itemClicked(sl);
g_slots ~= sl;
// cb: extern(C) void function(void* dthis, int n, void* itemPtr, int col)
```

### 5. QSplitter с двумя панелями

```d
import gen_qsplitter;

auto splitter = new QSplitter(cast(void*)null);
splitter.setOrientation(QtE.Orientation.Horizontal);
splitter.addWidget(leftPanel.getWH());
splitter.addWidget(rightPanel.getWH());
splitter.setSizes([200, 400]);

// Получить текущие размеры:
int[] sizes = splitter.sizes();
```

### 6. Рисование в виджете (onPaint)

```d
import gen_qwidget, gen_qpainter, gen_qcolor;

auto canvas = new QWidget(cast(void*)null);
canvas.resize(400, 300);

extern(C) static void onPaint(void* dthis, void* wh) {
    auto p = new QPainter(wh, true);

    auto red   = new QColor(255, 0, 0);
    auto blue  = new QColor(0, 0, 255);

    p.setPen(red.getWH());
    p.drawRect(10, 10, 100, 80);

    p.setPen(blue.getWH());
    p.drawEllipse(120, 10, 80, 80);

    p.drawText(10, 130, "QTE56 Drawing");
    p.end();
}
canvas.onPaint(cast(void*)&onPaint, null);
canvas.show();
// ВАЖНО: вызвать canvas.update() для перерисовки после изменений
```

### 7. QSettings — сохранение настроек

```d
import gen_qsettings;

auto settings = new QSettings("MyCompany", "MyApp");
settings.setValue("window/width", 800);
settings.setValue("window/height", 600);
settings.setValue("theme", "dark");

// Чтение:
int w = settings.valueInt("window/width", 640);     // 640 = default
string theme = settings.valueString("theme", "light");
bool exists = settings.contains("window/width");

// Группы:
settings.beginGroup("database");
settings.setValue("host", "localhost");
settings.endGroup();
```

### 8. QSystemTrayIcon с контекстным меню

```d
import gen_qsystemtrayicon, gen_qmenu, gen_qaction, gen_qicon;

auto ico  = new QIcon("app.ico");
auto tray = new QSystemTrayIcon(ico.getWH(), cast(void*)null);

// Контекстное меню трея:
auto menu = new QMenu(cast(void*)null);
void* acPtr = menu.addAction("Выход");
auto ac = QAction.wrap(acPtr);

auto sl = new ESlot(ac.getWH());
sl.set(cast(void*)&onExit);
ac.connect_triggered(sl);
g_slots ~= sl;

tray.setContextMenu(menu.getWH());
tray.setToolTip("Моё приложение");
tray.show();

// Всплывающее сообщение:
tray.showMessage("Заголовок", "Текст сообщения", 1 /*Information*/, 3000 /*мс*/);

// Сигнал активации:
auto sl2 = new ESlot(tray.getWH());
sl2.set(cast(void*)&onTrayActivated);
tray.connect_activated(sl2);
g_slots ~= sl2;
// cb: extern(C) void function(void* dthis, int n, int reason)
// reason: DoubleClick=2, Trigger=3
```

### 9. QSplashScreen при запуске

```d
import gen_qsplashscreen, gen_qpixmap;

auto px = new QPixmap("splash.png");
auto splash = new QSplashScreen(px.getWH(), cast(void*)null);
splash.show();
app.processEvents();

// ... инициализация ...
splash.showMessage("Загрузка модулей...");
app.processEvents();

// ... ещё инициализация ...
splash.finish(mainWin.getWH());  // закрыть когда показано главное окно
```

### 10. QTextEdit с синтаксическим подсветчиком

```d
import gen_qtextedit, gen_qsyntaxhighlighter, gen_qtextcharformat, gen_qcolor;

auto editor = new QTextEdit(cast(void*)null);
auto doc = editor.document();  // → void* QTextDocument*

// Подключить подсветчик (наследник QSyntaxHighlighter):
// В C++ DLL создать класс-наследник, в D — вызвать через ESlot callback
// highlightBlock вызывается для каждого блока текста при изменении

// Применить форматирование вручную:
auto cursor = editor.textCursor();
auto fmt = new QTextCharFormat();
auto color = new QColor(255, 0, 0);
fmt.setForeground(color.getWH());
fmt.setBold(true);
cursor.mergeCharFormat(fmt.getWH());
```

---

## Подсистема Turbo Vision (qte56_tvision.dll)

Standalone TUI без Qt. Индексы 19850–19884.

```d
import gen_tvision;

// Запуск TUI приложения:
extern(C) void menuBarInit(void* app) { ... }
extern(C) void statusLineInit(void* app) { ... }
extern(C) void eventHandler(void* app, void* event) { ... }

tvInit(&menuBarInit, &statusLineInit, &eventHandler);
tvRun();
tvDone();
```

Тест: `gui_tv_hello.d` — меню, диалоги, мышь, Alt-X.

---

## Wren VM (подпроект wren/)

Встроенный скриптовый язык. Тест: 13+25+23+25+32=118 тестов.

```d
import wren.wren_vm;

auto vm = new WrenVM();
vm.addLibPath("wren/lib");   // для import "foo" → <path>/foo.wren

vm.interpret("main", "System.print(\"Hello from Wren!\")");
```

Встроенные модули: `"ole"` (OleObject), `"io"` (File), `"qt"` (Widget/Logger), `"sys"` (Sys).

**OleObject** (COM-автоматизация):
```wren
import "ole" for OleObject

var xl = OleObject.create("Excel.Application")
xl.set("Visible", true)
var wb = xl.call("Workbooks.Open", "test.xlsx")
var val = wb.get("Sheets").callR("Item", 1).callR("Range", "A1").getR("Value")
xl.release()
```

Chaining: `.getR` / `.callR` автоматически освобождают промежуточные объекты.

**File** (QFile обёртка):
```wren
import "io" for File
var text = File.read("config.txt")
File.write("out.txt", "data")
```

**Sys**:
```wren
import "sys" for Sys
Sys.sleep(500)
var msg = Sys.msgBox("Текст", "Заголовок", 1)
var t = Sys.clock
var val = Sys.env("PATH")
```

Wren gotchas: не использует `;` — многострочные методы через `\n`; имена с `_` prefix запрещены (field access).

---

## OLE подпроект (ole/)

28 C-функций COM/IDispatch (23 base + 3 enum + 2 date). Тест: 26/26.

```d
import ole.ole_helper;

OleInit();
auto obj = oleCreate("Excel.Application");
oleSetProp(obj, "Visible", trueVariant());
auto result = oleCall(obj, "Workbooks.Open", [toVariant("test.xlsx")]);
oleRelease(obj);
OleUninit();
```

Перечисление (For-Each): `ole_enum_begin` использует fallback `GetIDsOfNames("_NewEnum")` если `DISPID_NEWENUM(-4)` не работает.

VT_DATE (7) → double (OLE Automation date: дни от 30.12.1899).

---

## Терминальный модуль (qte56_term.d)

Backend: `arsd.terminal` (`d/arsd/terminal.d`, один файл, 0 зависимостей).

```d
import qte56_term;

Term.setup();
Term.clear();
Term.moveTo(5, 3);
Term.setFg(196);   // red
Term.setBg(0);     // black
Term.put("Привет!");
Term.flush();

// Рамки:
Term.drawBox(1, 1, 40, 10, BoxChars.Double);

// Таблицы:
auto tt = new TermTable(headers, data);
tt.draw(row, col);

Term.cleanup();
```

`putDchar` → UTF-8. Не резать `string[0..N]` по байтам для кириллицы — только по символам.

Тест: `test_term.d` (30/30), `test_term_readat.d` (22/22).

---

## Покрытие и статус

| Класс | Индексы | DLL | Тест | Статус |
|-------|---------|-----|------|--------|
| QApplication | 50–71 | qcore | test_qapp_methods | 18/18 |
| QWidget | 200–399 | widgets | (все виджеты) | OK |
| QPushButton | 400–599 | widgets | (минимальный) | OK |
| QLayout / QVBox/HBox/Grid/Form | 600–642 | widgets | test_layouts_ext | 28/28 |
| QLabel | 800–999 | widgets | (базовый) | OK |
| QLineEdit | 1000–1199 | widgets | (базовый) | OK |
| QCheckBox | 1200–1399 | widgets | (базовый) | OK |
| QComboBox | 1400–1599 | widgets | (базовый) | OK |
| QRadioButton | 1600–1799 | widgets | (базовый) | OK |
| QSpinBox | 1800–1999 | widgets | (базовый) | OK |
| QSlider | 2000–2199 | widgets | (базовый) | OK |
| QProgressBar | 2200–2399 | widgets | (базовый) | OK |
| QGroupBox | 2400–2599 | widgets | (базовый) | OK |
| QTabWidget | 2600–2649 | widgets | test_qtabwidget | 67/67 |
| QFrame | 2800–2999 | foundation | (базовый) | OK |
| QAbstractButton | 3000–3199 | foundation | (базовый) | OK |
| QAbstractSlider | 3200–3399 | foundation | (базовый) | OK |
| QAbstractSpinBox | 3400–3599 | foundation | (базовый) | OK |
| QObject | 3600–3799 | foundation | (базовый) | OK |
| QAction | 3800–3999 | foundation | test_mainwindow_toolbar | 49/49 |
| QMenu | 4000–4199 | foundation | test_mainwindow_toolbar | OK |
| QMenuBar | 4200–4399 | foundation | test_mainwindow_toolbar | OK |
| QTimer | 4400–4419 | mainwin | test_qtimer | OK |
| QDialog | 4600–4799 | dialogs | (базовый) | OK |
| QMessageBox | 4800–4871 | dialogs | test_qmessagebox | 31/31 |
| QPlainTextEdit | 5000–5056 | text | test_textedit_lines | 46/46 |
| QScrollBar | 5200–5399 | widgets | (базовый) | OK |
| QDial | 5400–5599 | widgets | (базовый) | OK |
| QStatusBar | 5600–5799 | mainwin | test_mainwindow_toolbar | OK |
| QLCDNumber | 5800–5999 | widgets | (базовый) | OK |
| QProgressDialog | 6000–6199 | dialogs | (базовый) | OK |
| QMainWindow | 6200–6399 | mainwin | test_mainwindow_toolbar | 49/49 |
| QToolBar | 6400–6599 | mainwin | test_mainwindow_toolbar | OK |
| QIcon | 6600–6799 | widgets | (через pixmap) | OK |
| QFileDialog | 6800–6999 | dialogs | (базовый) | OK |
| QListWidget | 7000–7199 | views | (базовый) | OK |
| QSettings | 7200–7399 | views | (базовый) | OK |
| QAbstractScrollArea | 7400–7599 | foundation | (базовый) | OK |
| QMdiArea | 7600–7799 | views | (базовый) | OK |
| QMdiSubWindow | 7800–7999 | views | (базовый) | OK |
| QTextEdit | 8000–8072 | text | test_textedit_lines | OK |
| QSplitter | 8200–8399 | widgets | (базовый) | OK |
| QStackedWidget | 8400–8599 | widgets | (базовый) | OK |
| QDoubleSpinBox | 8600–8799 | widgets | (базовый) | OK |
| QAbstractItemView | 8800–8999 | foundation | (базовый) | OK |
| QTableView | 9000–9199 | views | (базовый) | OK |
| QTableWidget | 9200–9399 | views | test_qtablewidget | 92/92 |
| QTreeView | 9400–9599 | views | (базовый) | OK |
| QTreeWidget | 9600–9680 | views | test_qtreewidget | 52/52 |
| QHeaderView | 9800–9999 | views | test_font_header | 35/35 |
| QScrollArea | 10000–10199 | widgets | (базовый) | OK |
| QFont | 10200–10399 | widgets | test_font_header | OK |
| QToolButton | 10400–10599 | mainwin | test_qtoolbutton | 41/41 |
| QCommandLinkButton | 10600–10799 | widgets | test_clb_dock_toolbox | 53/53 |
| QDockWidget | 10800–10999 | mainwin | test_clb_dock_toolbox | OK |
| QToolBox | 11000–11199 | widgets | test_clb_dock_toolbox | OK |
| QTextBrowser | 11200–11399 | widgets | test_qtextbrowser | 33/33 |
| QFontDialog | 12000–12999 | dialogs | test_qcolor_dialogs | 61/61 |
| QColorDialog | 13000–13999 | dialogs | test_qcolor_dialogs | OK |
| QColor | 14000–14999 | drawing | test_qcolor_dialogs | OK |
| QInputDialog | 15000–15999 | dialogs | test_layouts_inputdialog | 42/42 |
| QTabBar | 16000–16999 | widgets | test_qtabbar | 49/49 |
| QDateTimeEdit | 17000–17099 | mainwin | test_qdatetimeedit | 70/70 |
| QDateEdit | 17100–17199 | mainwin | test_qdatetimeedit | OK |
| QTimeEdit | 17200–17299 | mainwin | test_qdatetimeedit | OK |
| QCalendarWidget | 17300–17399 | mainwin | test_qcalendarwidget | 64/64 |
| QClipboard | 17400–17499 | widgets | test_clipboard_btngroup | 37/37 |
| QButtonGroup | 17500–17599 | widgets | test_clipboard_btngroup | OK |
| QPixmap | 17600–17999 | resource | test_qpixmap | 54/54 |
| QPainter | 18000–18199 | drawing | test_drawing | 33/33 |
| QImage | 18200–18299 | resource | (базовый) | OK |
| QFile | 18500–18999 | resource | test_qfile | 29/29 |
| QTextDocument | 19000–19099 | text | (через QTextEdit) | OK |
| QSql | 19100–19132 | sql | test_qsql | 41/41 |
| QTextCursor | 19200–19235 | text | (через QTextEdit) | OK |
| QTextCharFormat | 19300–19324 | text | (через QTextEdit) | OK |
| QTextBlockFormat | 19400–19419 | text | (через QTextEdit) | OK |
| QTextBlock | 19500–19514 | text | (через QTextEdit) | OK |
| QSyntaxHighlighter | 19600–19612 | text | (базовый) | OK |
| QScintilla | 19700–19747 | qscintilla | test_qscintilla | 57/57 |
| QPen | 19748–19760 | drawing | test_drawing | OK |
| QBrush | 19761–19767 | drawing | test_drawing | OK |
| QPalette | 19768–19775 | drawing | test_drawing | OK |
| QFontMetrics | 19776–19785 | drawing | test_drawing | OK |
| QSplashScreen | 19788–19796 | systray | test_systray | 22/22 |
| QSystemTrayIcon | 19797–19809 | systray | test_systray | OK |
| QResource | 19810–19811 | resource | test_qresource | 64/64 |
| QUiLoader | 19812–19815 | uiloader | test_forms | 71/71 |
| QProcess | 19816–19836 | qprocess | test_qprocess | 27/27 |
| QStringList ext | 19837–19841 | widgets | test_qstringlist | 49/49 |
| Turbo Vision | 19850–19884 | tvision | gui_tv_hello | OK |
| QDate / QTime / QDateTime | 19885–19968 | foundation | test_datetime_calendar | 198/198 |
| QByteArray | 19969–19998 | foundation | test_qbytearray | OK |
| QImage memio | 19999–20000 | foundation | (через QImage) | OK |
| QPixmap memio | 20001–20002 | foundation | (через QPixmap) | OK |
| QScintilla ext | 20003–20004 | qscintilla | (lexer creation) | OK |
| QNetwork | 20005–20045 | network | test_qnetwork | OK |
| QCurl | 20046–20072 | curl | test_curl | 18/18 |
| QThread / QMutex | 20073–20095 | thread | test_qthread | 35/35 |
| QWaitCondition / QSemaphore / QReadWriteLock | 20096–20117 | thread | test_qthread | OK |
| QCompleter | 20118–20131 | completer | test_qcompleter | 35/35 |
| QShortcut | 20132–20168 | shortcut | test_qshortcut | 25/25 |
| QFileSystemWatcher | 20139–20148 | filewatcher | test_qfilewatcher | 20/20 |
| QDesktopWidget | 20149–20154 | desktop | test_qdesktopwidget | 22/22 |

Общее покрытие: **~97%** от оригинального `qte56.d` (100+ Qt-классов).

---

## Полный список тестов

| Тест-файл | Кол-во | Что проверяет |
|-----------|--------|---------------|
| `test_qtablewidget.d` | 92/92 | QTableWidget + QTableWidgetItem |
| `test_qtreewidget.d` | 52/52 | QTreeWidget + QTreeWidgetItem |
| `test_font_header.d` | 35/35 | QFont + QWidget.setFont/fontObj + QHeaderView |
| `test_qtoolbutton.d` | 41/41 | QToolButton + triggered(QAction*) lambda-connect |
| `test_mainwindow_toolbar.d` | 49/49 | QMainWindow + QStatusBar + QMenu + QAction + QToolBar |
| `test_clb_dock_toolbox.d` | 53/53 | QCommandLinkButton + QDockWidget + QToolBox |
| `test_qtextbrowser.d` | 33/33 | QTextBrowser (rich-text, navigation, signals) |
| `test_qtimer.d` | OK | QTimer (4400–4419), timeout ESlot |
| `test_qmessagebox.d` | 31/31 | QMessageBox (4800–4871), static methods, enums |
| `test_qcolor_dialogs.d` | 61/61 | QColor + QFontDialog + QColorDialog |
| `test_qpixmap.d` | 54/54 | QPixmap (value type, fill, scaled, save/load, wrap) |
| `test_enums.d` | 68/68 | qte56_enums.d (QtE flags, FrameShape/Shadow, bitwise OR) |
| `test_layouts_inputdialog.d` | 42/42 | Layouts + QInputDialog (static + instance) |
| `test_qtabbar.d` | 49/49 | QTabBar (full API + signals) |
| `test_qtabwidget.d` | 67/67 | QTabWidget (full API + tabBar()→QTabBar) |
| `test_qdatetimeedit.d` | 70/70 | QDateTimeEdit/QDateEdit/QTimeEdit + signals |
| `test_qcalendarwidget.d` | 64/64 | QCalendarWidget (selection, navigation, signals) |
| `test_clipboard_btngroup.d` | 37/37 | QClipboard + QButtonGroup |
| `test_datetime_calendar.d` | 198/198 | DDate/DTime + all datetime widgets |
| `test_qfile.d` | 29/29 | QFile (read/write/copy/rename/remove/permissions) |
| `test_qsql.d` | 41/41 | QSqlDatabase + QSqlQuery (SQLite in-memory, CRUD) |
| `test_qapp_methods.d` | 18/18 | QApplication extended methods |
| `test_qss_style.d` | 50/50 | qte56_style.d (applyQss, appendQss, QssTheme) |
| `test_qresource.d` | 64/64 | qte56_resource.d (registerRcc, resourceExists, readText) |
| `test_forms.d` | 71/71 | qte56_forms.d (QForm.load, findLabel/Button/...) |
| `test_rect.d` | 73/73 | DRect/DPoint/DSize операции |
| `test_layouts_ext.d` | 28/28 | Layout extension methods (629–642) |
| `test_systray.d` | 22/22 | QSplashScreen + QSystemTrayIcon |
| `test_qprocess.d` | 27/27 | QProcess lifecycle + signals |
| `test_qstringlist.d` | 49/49 | QStringList ext methods |
| `test_textedit_lines.d` | 46/46 | QPlainTextEdit/QTextEdit lines API |
| `test_qscintilla.d` | 57/57 | QScintilla editor |
| `test_drawing.d` | 33/33 | QPen/QBrush/QPalette/QFontMetrics |
| `test_datetime_calendar.d` | 198/198 | QDate/QTime/QDateTime + DateTimeEdit/DateEdit/TimeEdit |
| `test_qbytearray.d` | OK | QByteArray + memio (loadFromData/saveToBuffer) |
| `test_qnetwork.d` | OK | QUrl, QNetworkRequest, QNetworkReply, QNetworkAccessManager |
| `test_curl.d` | 18/18 | CurlSession — HTTP/HTTPS/FTP/FTPS/SFTP/SCP |
| `test_qthread.d` | 35/35 | QThread, QMutex, QWaitCondition, QSemaphore, QReadWriteLock |
| `test_qcompleter.d` | 35/35 | QCompleter — popup/inline, attachTo/Combo |
| `test_qshortcut.d` | 25/25 | QShortcut — горячие клавиши, VoidClosure, augment |
| `test_qfilewatcher.d` | 20/20 | QFileSystemWatcher — мониторинг файлов/директорий |
| `test_qdesktopwidget.d` | 22/22 | QDesktopWidget — геометрия экранов, centeredPos |
| `test_json.d` | 85/85 | d/json.d — pure D JSON парсер |
| `test_sort.wren` | 21/21 | ListUtil.sort/sortBy/dedup/sortedUniq (Wren) |
| `test_term.d` | 30/30 | qte56_term.d — терминальные операции |
| `test_term_readat.d` | 22/22 | qte56_term.d — readAt / TermTable |

Запуск тестов:
- Windows: `test\build_XXX.bat`
- Linux: `bash test/build_linux.sh all`

---

## tools/qte_guide — Интерактивный справочник QTE56

Встроенное GUI-приложение, написанное на QTE56, содержит:
- Дерево тем с иерархическим навигатором
- Просмотрщик исходного кода D (с синтаксисом через QScintilla)
- Библиотеку 13 готовых сниппетов (AppMin, Layout, Dialog, MDI, Table/Tree, Settings, FileIO, Timer, Painter, Wren)
- Генератор `build.bat` / `build.sh` для любого выбранного сниппета
- Подсветка синтаксиса через QScintilla (если DLL доступна)

```
arch_new/tools/qte_guide/
├── main.d        — точка входа, меню, QSettings, Qt-пути
├── tree.d        — GuideTree (дерево тем, QTreeWidget)
├── viewer.d      — CodeViewer (редактор кода, QScintilla / QPlainTextEdit)
├── snippets.d    — 13 сниппетов (код + метаданные)
├── codegen.d     — генератор кода с подстановкой переменных
├── scanner.d     — сканер D-файлов проекта
├── buildgen.d    — генерация build.bat / build.sh
└── build_main.bat — сборка и запуск приложения
```

**Сборка и запуск:**
```bat
cd arch_new
tools\qte_guide\build_main.bat
```

**Qt-пути настраиваются через меню `File → Configure Qt Paths...`**
(3 диалога QInputDialog: qtBin, mingwBin, platformsDir) и сохраняются в QSettings:
```d
new QSettings("qte56", "qte_guide")
// ключи: qt_bin, qt_mingw, qt_platforms
```

**Portability — LoadQt с абсолютным путём:**
```d
import std.path : dirName, buildPath;
import std.file : thisExePath, exists;

void main() {
    string selfDir  = thisExePath.dirName;        // каталог .exe
    string archRoot = selfDir.dirName.dirName;     // arch_new/
    string dllDir   = buildPath(archRoot, "dll");  // arch_new/dll/
    if (!dllDir.exists) dllDir = "./dll";          // fallback
    LoadQt(dllDir);                                // абсолютный путь
    auto app = new QApplication("qte_guide");
    ...
}
```

Это позволяет запускать `.exe` из любого каталога без изменения PATH.

**Env vars для build_main.bat (override Qt-пути):**
```bat
set QTE56_QT_ROOT=C:\Qt5_13_2     rem root Qt-каталога
set QTE56_QT_VER=5.13.2
set QTE56_QT_COMP=mingw73_32
set QTE56_MINGW=mingw730_32
```
Если не заданы, используются дефолтные значения из `buildgen.d`:
`DEFAULT_QT_BIN`, `DEFAULT_QT_MINGW`, `DEFAULT_QT_PLATFORMS`.

---

## Справочник: что где живёт

| Задача | Файл | Метод |
|--------|------|-------|
| Загрузить DLL | `qte56_loader.d` | `LoadQt("./dll")` |
| Загрузить DLL (portable) | `qte56_loader.d` | `LoadQt(thisExePath.dirName.dirName.dirName ~ "/dll")` |
| Регистрировать модуль | каждый `gen_*.d` | `static this()` → `registerModule()` |
| Создать виджет | `gen_qXXX.d` | `new QXXX(cast(void*)null)` |
| Обернуть Qt-owned ptr | `gen_qXXX.d` | `QXXX.wrap(ptr)` |
| Получить raw handle | любой класс | `.getWH()` |
| Подключить сигнал | `gen_qXXX.d` | `new ESlot` → `connect_XXX()` |
| Применить CSS | `qte56_style.d` | `applyQss()` |
| Загрузить .ui форму | `qte56_forms.d` | `QForm.load()` |
| Зарегистрировать .rcc | `qte56_resource.d` | `registerRcc()` |
| QString → D string | `gen_qcore.d` | `fromQString()` |
| D string → QString | `gen_qcore.d` | `toQString()` |
| Освободить QString | `pFunQt[22]` | `(cast(t_v__qp)pFunQt[22])(qs)` |
| Все enums | `qte56_enums.d` | `QtE.XXX.YYY` |
| Завершить приложение | `gen_qcore.d` | `app.deleteApp()` |
| Сохранить настройки | `gen_qsettings.d` | `new QSettings(app, grp)` + `.setValue()` |
| HTTP-запрос (sync) | `d/net_utils.d` | `httpGet(url)` / `httpPost(url, body)` |
| HTTP-запрос (curl) | `d/curl_utils.d` | `new CurlSession().get(url).body()` |
| JSON парсинг | `d/json.d` | `parseJson(text)` / `toJsonCompact(v)` |
| Интерактивный справочник | `tools/qte_guide/` | `build_main.bat` |
