# QTE56 — Руководство для AI-агентов

> **QTE56** — биндинги Qt 5.13.2 для языка D через C++ DLL-обёртки: GUI на D без перекомпиляции C++.

---

## 1. Утилита `qte` — обязательна перед работой с кодовой базой

`tools/qte/qte.exe` (пересборка — `tools/qte/build.bat`, зависимостей нет):

```bash
qte class QPushButton            # класс: где определён, методы, индексы
qte index find/gaps/check/module/list # индексы, дыры, коллизии, список
qte check all                    # все проверки (indexes, live, builds)
qte check dlls                   # DLL из registerModule vs dll/dll32,dll64
qte signals valueChanged         # справочник сигналов
qte trace 19134                  # индекс: CSV → C++ → D → callers
qte scan                         # JSON-выгрузка всех классов gen_*.d
qte dll [module] [--missing dll32|dll64]  # модуль → DLL → merged/standalone
qte deps QComboBox               # замыкание импортов gen_* + строка dmd
qte index gaps --plan 100        # дыры >= N (под новый класс)
qte --json <cmd>                 # машинный вывод
```

**Важно:** `registry/functions.csv` и `qte56.ini` строго UTF-8 — CP1251-байт роняет `qte`.

## 2. Структура проекта

```
d/               D-исходники (qte56_core.d, qte56_loader.d); d/gen/ — 116 gen-модулей
cpp/qt5/         ~107 поклассовых C++ проектов qte56_*; merged/ — 6 объединённых .pro
dll/dll32/       32 DLL (основная архитектура, Qt 5.13.2); dll/dll64/ — 22 (Qt 6, неполно)
generator/       Python-генератор (main.py, checks.py, augment.py, qt_knowledge.py, ...)
registry/functions.csv   # единственный источник истины об индексах (UTF-8!)
test/            163 тестовых .d
```

> Числа в этом блоке — ориентир и могут отставать. Датированный снимок — §17, актуальное состояние — `qte check all` / `qte index list`.

## 3. Минимальное приложение, компиляция, запуск

```d
import qte56_core, qte56_loader, gen_qcore, gen_qwidget, gen_qlayout;
import gen_qlabel, gen_qpushbutton, gen_qabstractbutton;

void main() {
    LoadQt("./dll");                              // 1. ВСЕГДА ПЕРВЫМ
    auto app = new QApplication(cast(void*)null); // 2.
    auto win = new QWidget(cast(void*)null);
    auto lbl = new QLabel(cast(void*)null);
    auto btn = new QPushButton(cast(void*)null);
    lbl.setText("Hello"); btn.setText("Click");
    auto vbox = new QVBoxLayout(cast(void*)null);
    vbox.addWidget(lbl); vbox.addWidget(btn);     // auto-disown
    win.setLayout(vbox);
    win.setWindowTitle("App"); win.resize(400, 300); win.show();
    app.exec();
    app.deleteApp();                              // ПОСЛЕДНИМ; UnloadQt() НЕ вызывать!
}
```

```bash
# Компиляция (32-bit, основная):
dmd -m32 -version=TreeQt -i myapp.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=myapp.exe
# GUI без консоли: добавить -L/SUBSYSTEM:WINDOWS -L/ENTRY:mainCRTStartup
# (в GUI-режиме нет stdout; лог — addStrInLog() при заданной QTE56LOG)
```

**Запуск:** с развёрнутым runtime (PATH: `C:\Users\Public\QTE56\bin513`, `C:\Users\Public\QTE56\dll`) — просто `./myapp.exe`. Надёжнее всего: путь к DLL от exe + `SetDllDirectoryW()` (см. `test/test_qpointf_qrectf.d`). Без развёрнутого runtime НЕ запускать — упадёт на первом `LoadQt()`.

## 4. Критические правила (нарушение = crash)

1. Порядок: `LoadQt()` → `new QApplication` → виджеты → `app.exec()` → `app.deleteApp()`.
2. `cast(void*)null` обязателен: `new QPushButton(cast(void*)null)`, не `new QPushButton(null)`.
3. ESlot — только в `__gshared` (иначе GC удалит → crash).
4. Коллбэки: второй параметр всегда `int n`:
   `extern(C) void onX(void* dt, int n, int value)` (invoke_b/i),
   `(void* dt, int n, void* qs)` (invoke_s), `(void* dt, int n)` (invoke_v).
5. `UnloadQt()` — НИКОГДА; ОС сама освободит DLL.
6. `void main()`, не `extern(C) int main()`.

## 5. Владение объектами (Ownership)

- **Typed API → auto-disown:** `vbox.addWidget(lbl)`, `win.setLayout(vbox)`, `mw.setCentralWidget(c)`, `tabs.addTab(p, "T")`.
- **Void* API → `disown()` вручную:** `vbox.addWidget(lbl.getWH()); ... vbox.disown();`
- **Qt-created → `wrap()`, не new, не удалять:** `QMenuBar.wrap(win.menuBar())`.
- **С parent → Qt владеет**, disown не нужен.
- **Lifecycle-защита:** QObject через `qte_createTracked()` трекается (`qte56_foundation.dll`); dtor удаляет C++ объект только если он жив и без Qt parent. `btn.isValid()` — проверка перед использованием. Value-типы (`QTableWidgetItem`, `QBrush`, `QFont`, `QIcon`) НЕ трекаются — для них `disown()`/`wrap()` обязательны.

## 6. Импорты (класс → модуль → DLL)

Фактический маппинг модуль→DLL — в `registerModule()` в начале каждого `d/gen/gen_*.d` (`grep -h registerModule d/gen/*.d`). Колонка `dll` в functions.csv устарела (~65% не совпадает).

| Класс | import | DLL |
|-------|--------|-----|
| QApplication, ESlot | `gen_qcore` | qte56_qcore |
| QObject, QTimer, QSettings, QFont, QPixmap, QImage | `gen_qobject` и др. | qte56_foundation |
| QWidget, QLabel, кнопки, QLineEdit, QComboBox, layouts | `gen_qwidget`, `gen_qlabel`, ... | qte56_widgets |
| QMainWindow, QMenuBar/QMenu/QAction, QToolBar, QStatusBar | `gen_qmainwindow` ... | qte56_mainwin |
| QDialog, QMessageBox, QFileDialog, QInputDialog | `gen_qdialog` ... | qte56_dialogs |
| QTextEdit, QPlainTextEdit | `gen_qtextedit`, `gen_qplaintextedit` | qte56_text |
| QTree/QTable/ListWidget | `gen_q*widget` + view + `gen_qabstractitemview` | qte56_views |
| QModelIndex, QStandardItem(Model), QSortFilterProxyModel | `gen_qmodelindex` ... | qte56_qmodelview |
| QAbstractItemDelegate, QStyledItemDelegate | `gen_qabstractitemdelegate`, `gen_qstyleditemdelegate` | qte56_qstyleditemdelegate |
| QPen/QBrush/QPalette | `gen_qpen` ... | qte56_drawing |
| QProcess / QThread / QNetwork / QScintilla | `gen_qprocess` / `gen_qthread` / `gen_qnetwork` / `gen_qscintilla` | standalone |
| QPointF / QRectF (value) | `gen_qpointf` / `gen_qrectf` | qte56_qpointf / qte56_qrectf |

Классы с промежуточными родителями требуют импорта всей цепочки:
`QPushButton` + `gen_qabstractbutton`; `QSpinBox` + `gen_qabstractspinbox`;
`QSlider` + `gen_qabstractslider`; `QTreeWidget` + `gen_qtreeview` + `gen_qabstractitemview`.

## 7. Строки D ↔ Qt

```d
lbl.setText("Hello");                       // типизированные методы берут D string
string s = fromQString(qs);                 // конвертирует И ОСВОБОЖДАЕТ qs!
void* qsl = toQStringList(["A", "B"]);      // QStringList
combo.addItems(qsl); freeQStringList(qsl);  // free обязателен
```

## 8. События виджетов

```d
extern(C) void onClose(void* dt, int* accept) { *accept = 1; }
extern(C) void onKeyPress(void* dt, int key, int mods) {}
extern(C) void onMousePress(void* dt, int x, int y, int btn) {}
extern(C) void onResize(void* dt, int w, int h) {}
extern(C) void onPaint(void* dt, void* widget) {
    auto p = new QPainter(widget, true); /*...*/ p.end();
}
w.onClose(cast(void*)&onClose);  w.onPaint(cast(void*)&onPaint);
w.setMouseTracking(true);  // для onMouseMove без нажатой кнопки
```

## 9. Архитектура

```
import gen_X → static this() → registerModule("X", "qte56_YYY.dll", &loadX)
LoadQt(dir) → LoadLibrary/GetProcAddress → pFunQt[25000]
  (fallback: LoadLibrary(имя) по PATH → C:\Users\Public\QTE56\dll\dll32|dll64)
new X(...) → pFunQt[idx]; app.exec() → Qt event loop
```

- **Merged DLL (6):** widgets (27 модулей), foundation (17), views (11), text (8), dialogs (7), mainwin (10).
- **Standalone DLL (26):** qcore, drawing, qgraphicsscene, qprocess, thread, network, curl, sql, mediaplayer, qmodelview, sound, soundeffect, qstyleditemdelegate, qscintilla, qxlsx, systray, textcodec, filewatcher, desktop, completer, resource, shortcut, uiloader, tvision, qpointf, qrectf.
- Ключевые файлы: `d/qte56_core.d` (`pFunQt`, `generateAlias/FunQt`), `d/qte56_loader.d` (`registerModule/LoadQt`, авто-путь из `QTE56_ARCH`), `d/gen/gen_qcore.d` (`ESlot`, `QApplication`, `toQString/fromQString`, `DRect/DPoint/DSize`).
- `QTE56_ARCH`: `win32_qt5`→`dll/dll32`, `win64_qt6`→`dll/dll64`, `linux64_*`→`lib`. Явный путь в `LoadQt(dir)` имеет приоритет.

## 10. DAO/ACE (Microsoft Access)

`ole/d/ole_dao.d` (DAO 3.6, только 32-bit .mdb), `d/gen/gen_qdao.d`, `ole_adox` (ADOX — рекомендуется, любые MDB/ACCDB). Русские имена — в квадратных скобках. Всегда `.close()` перед выходом. Подробности: `ole/OLE_GUIDE.md`.

## 11. Генератор кода (v2, 2026-07)

```bash
cd generator/
py test_new_class.py <qt_header.h> --index-start 21400   # harness: генерация+g++ +dmd, реестр НЕ меняется
py main.py <qt_header.h> --module QFoo --dll qte56_qfoo.dll --index-start 21400  # реальная генерация
```

- **pFunQt заполнен** (макс. индекс 24713): новые классы — в дыры через `--index-start` (`qte index gaps --plan 100`) или увеличить `PFUNQT_SIZE` в `d/qte56_core.d` + `generator/registry.py`.
- **База знаний:** `qt_knowledge.py` → `knowledge/qt_knowledge.json` (иерархия, enum'ы, value-типы); без неё — эвристики. `--selftest` — проверка.
- **Автоматически в выходе:** lifecycle (`qte_createTracked`), `@live`, `wrap()`, chaining, маркеры `--patch`, value-классы (`<Type>_v`), `.pro` с `QTE56_ARCH`, блок `GENERATOR-INFO`.
- **Preflight (`checks.py`, фаза `[2/5]`):** проверки до записи файлов/реестра; FAIL → выход без побочек (`--force` обходит).
- **`--augment` (augment.py):** дополнение модуля только недостающими методами — единый patch-файл для ревью; `--apply` — дописать CSV. Пример: `py main.py qshortcut.h --module QShortcut --augment [--apply]`.
- Подробности: `GENERATOR_KNOWLEDGE_TRANSFER.md` §15, `generator/work_geterator.md`.

### functions.csv — реестр

Индекс функции **никогда не меняется**. Дыры допустимы. Актуальную картину — `qte index list` / `qte index gaps`.

## 12. Сборка DLL

```bash
build_merged_dlls.bat          # Windows, все DLL (обёртка над build_merged_dlls.py)
bash build_merged_dlls.sh      # Linux
cd cpp/qt5/qte56_qfoo && qmake qte56_qfoo.pro && mingw32-make   # отдельный модуль
```

Тулчейн сборки — w64devkit 2.9.1 (GCC 16.2.0): `G:\C++_86` (32-bit), `G:\C++_64` (64-bit), оба без multilib. `a.cmd` в корне G:\ — выбор окружения (выставляет QTE56_ARCH). make всегда с `-j<N>`. Не смешивать .o/.a от GCC 7.3 и GCC 16 — при смене тулчейна полная очистка каталогов сборки.
Для `dmd -m32` (mscoff) нужны LIBPATH к VS2010:
`-L/LIBPATH:"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\lib" -L/LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Lib"`.

## 13. Частые ошибки (GOTCHAS)

| Ошибка | Решение |
|--------|---------|
| `null` без `cast(void*)` | Всегда `cast(void*)null` |
| ESlot собирает GC | Хранить в `__gshared` |
| AV при `new ESlot(&cb)` | ctor ESlot принимает **Qt-parent**, не callback: `new ESlot(w.getWH()).set(cast(void*)&cb, null, n)` |
| Сигнатура коллбэка | `int n` обязателен вторым параметром |
| Double-free layout | Typed API → auto-disown; void* → `disown()` |
| Crash после exec() | Нет `deleteApp()` или вызван `UnloadQt()` |
| QAction shortcut | `setShortcutStr("Ctrl+X")`, НЕ `setShortcut(string)` |
| QProcess | `new QProcess()`, БЕЗ аргументов |
| QThread | `new QThread({ delegate })`, НЕ `QThread.create(fn)` |
| httpGet из ESlot | НЕЛЬЗЯ — deadlock; только из главного потока |
| QScintilla | Нужны ОБА: `qte56_qscintilla.dll` + `qscintilla2_qt5.dll` |
| Crash: pFunQt[idx]=null | Устаревшие DLL-копии рядом с exe; путь от exe + `SetDllDirectoryW` |
| InvalidMemoryOperationError под нагрузкой | GC внутри Qt-коллбэка опасен; для утилит — `GC.disable()` в main (см. `moodle_api/moodle_api.d`). `processEvents()` в коллбэке — избегать |
| curl 77 (CA file) | `cacert.pem` ищется: `<exe>/dll` → `./dll` → `C:\Users\Public\QTE56\bin513` (curl_utils.d) |
| curl (1) Protocol "sftp" not supported | Загружена `libcurl.dll` БЕЗ libssh2 (часто урезанная копия из `C:\D\dmd2\windows\bin`). Положить полную из `bin513` рядом с exe или выше в PATH |
| ODBC при выходе: "Unable to disconnect..." | Вызывать `QSqlDatabase.close()` ДО `app.deleteApp()` (AI_SQL.md Gotcha 13) |
| AV по адресу 0 при выходе | dtor обёртки вызвал `pFunQt[idx]` после `deleteApp()`. Освобождать дескрипторы ДО `deleteApp()`; в dtor проверять `pFunQt[idx] !is null` |
| Excel/COM 0x80010001 RPC_E_CALL_REJECTED | Сервер занят. В `ole_automation.d` встроен busy-retry (50 × 100 мс); настройка `oleSetBusyRetry`, диагностика `oleSetRetryLogger`. «Слепые» `oleDelay()` не обязательны |

## 14. Соглашения по коду

- D: `dmd -m32` (Win), `ldc2` (Linux); флаг `-i` для транзитивных импортов; русские комментарии ок. `@live` — только локальные `auto`, **НИКОГДА** для полей класса.
- **Method chaining:** бывшие `void`-методы возвращают `this` (кроме `disown()` и static). Цепочка сужает тип — специфичные методы вызывать раньше базовых.
- C++: `<CLASSNAME>_API` + `extern "C"`; имена `qte<Class>_<method>[_suffix]`; `bool`→`int`; QString — `void*`.

## 15. Рабочий процесс AI-агента

1. **Сначала документация:** прочитай `AI_LOADING_ORDER.md`, затем релевантный `AI_*.md` — ПЕРЕД любым изменением кода.
2. `qte class/index/check` — анализ контекста.
3. Ближайший пример в `test/` — скопировать структуру.
4. Изменения → компиляция → тест → `qte check all`.
5. Показывай процесс рассуждения очень кратко, на русском языке.

### Цикл верификации (по типу изменения)

| Что менялось | Обязательные проверки |
|---|---|
| Только D-код (`d/`, `test/`) | `dmd` (строка из §3) → `qte check all` |
| C++-обёртки (`cpp/qt5/*`) | сборка DLL (`build_merged_dlls.bat` или per-module qmake) → `qte check dlls` → `qte check all` |
| Генератор (`generator/*`) | harness `py test_new_class.py` (реестр НЕ меняется) → затем, если apply: `qte index check` |
| Реестр (`functions.csv`) | `qte index check` + `qte check all` |

**Не сообщать о готовности задачи, пока все применимые проверки не прошли без ошибок.**

## 16. Карта документации

Точка входа — этот файл. Полный справочник D API: `doc/qte56_d_reference.md`. Общее описание проекта: `README.md`, `QTE56_Research_Report.md`, `QT_KNOWLEDGE_TRANSFER.md`.

**Основы:** `AI_LOADING_ORDER.md` (порядок чтения), `AI_CORE.md`, `LIVE_QUICKSTART.md` (@live), `AI_SIGNALS_REF.md`, `doc/qprocess.md`, `doc/threading.md`.

**Тематические (AI_*.md):** WIDGETS, MAINWINDOW, DIALOGS, FORMS (.ui через QUiLoader), CONTAINERS, DATAVIEW, TEXTEDITOR (+QScintilla), DRAWING (+`doc/qgraphicsscene_guide.md`), DATETIME, SQL, NETWORK_GUIDE (+`doc/network_guide.md`), TEXTCODEC, TRAY_EXTRA.

**Генератор:** `GENERATOR_KNOWLEDGE_TRANSFER.md` (§15 — v2), `generator/work_geterator.md`, `DYNAMIC_SKIP_METHODS_ARCHITECTURE.md`, `generator/make_build_guide.md`.

**Сборка:** `BUILD_KNOWLEDGE_TRANSFER.md`, `CPP_DLL_PATTERNS.md`, `LINUX_PORT.md`.

**Подсистемы:**

| Направление | Ключевые файлы | Документация |
|---|---|---|
| OLE/COM (Excel, ADOX) | `ole/d/ole_automation.d`, `ole_excel.d`, `ole_adox.d` | `ole/OLE_GUIDE.md`, `OLE_KNOWLEDGE_TRANSFER.md` |
| Access (DAO/ACE) | `ole/d/ole_dao.d`, `d/gen/gen_qdao.d` | `TASK_DAO_ACE_INTEGRATION.md` |
| Файловый Excel (.xlsx/.xlsm) | `QXlsx/`, `excel-dll-d/`, `libxl-5.2.0.1/` | `QXLSX_XLSM_WRITE_BUG.md`, `apps/excel_import/AGENTS.md`, `apps/excel_import/add_colors.md`, анализы `apps/debug/*.md` (libxl, openpyxl, XML-структура xlsx) |
| Wren (скрипты) | `wren/` | `wren/WREN_GUIDE.md`, `AI_WREN.md`, `wren/WREN_KNOWLEDGE_TRANSFER.md`, `wren/doc/*.md` |
| Turbo Vision (TUI) | `tvision/` | `TVISION_KNOWLEDGE_TRANSFER.md`, `TASK_TVISION_FULL_WRAP.md` |
| Терминальный вывод | `d/` (qte56_term) | `TERMINAL_KNOWLEDGE_TRANSFER.md` |
| Порт на DMC | `dmc/` | `dmc/AGENTS.md`, `dmc/PLAN_QTE56_DMC.md`, `dmc/QTE5DMC_GUIDE.md`, `dmc/GENERATOR_GUIDE.md`, `dmc/AI_STRING_GUIDE.md`, `dmc/QTE56_CLASS_HIERARCHY.md`, `dmc/DMC_HIERARCHY_ANALYSIS.md`, `dmc/Plat_QString.md` |
| ML/fine-tuning | датасеты, train-скрипты | `FINETUNING_GUIDE.md`, `DATASET_*.md`, `OLLAMA_SETUP.md`, `MULTITURN_STRATEGY.md`, `SCRIPT_REVIEW.md`, `TRAINING_SCRIPT_SUMMARY.md` |
| MUMPS / M-IDE | `apps/mide/`, `d/mumps.d` | `apps/mide/README.md`, `apps/mide/MINIMONO.md` |
| QR-коды | `apps/qrcd/qrlib/` | `apps/qrcd/qrlib/README.md` |
| Сеть вне Qt (libcurl) | `d/curl_utils.d` | `doc/network_guide.md` |
| Сканирование Kyocera через WSD/SOAP | `apps/wsd_scan/` (`wsd_scan.d`, `scan.exe`), `apps/scan_gui/` (GUI: Access-файл → папка человека → WSD-скан → Sumatra → архив) | `WSD_SCAN.md` |
| Forth-интерпретатор (встраивание) | `forth/` (ядро forth.d, хосты console_forth.d/qtforth.d) | `forth/support_forth.md`, `forth/call.md`, `forth/callback.md`, `forth/arPanic.md`, `forth/mOleg.md` |
| Wizard-генератор | `qte56_wizard_generator/` | `QTE56_WIZARD_SPECIFICATION.md`, `qte56_wizard_generator/README.md`, `qte56_wizard_generator/templates/README.md` |
| Утилиты | `tools/qte/`, `apps/finddll/`, `apps/des/`, `apps/vba/` | `tools/qte/README.md`, `apps/vba/README.md`, `apps/finddll/README.md`, `apps/des/README.md` |
| Реестр НОАП | `apps/reestr/`, `apps/noap/` | `apps/reestr/selNtc.md`, `apps/reestr/srcNoap/README.md`, `apps/reestr/srcNoap/CSV_FORMAT.md`, `apps/reestr/noap/noap.md`, `apps/noap/noap/noap.md` |
| Формирование приказов | `apps/outputPrik/` | `apps/outputPrik/outputPrik_алгоритм.md` |
| Moodle (LMS API, SMTP) | `moodle_api/`, `moodle_util/` | нет md |

**Туториалы по чистому D:** `tutorial_for_ai/{concurent,csv,memory_gc}/` — у каждого README + GUIDE + CHEATSHEET + EXAMPLES.

**Рабочие заметки и контексты AI-сессий:** `AI_CONTEXT.md`, `AI_CONTEXT_GLM-47.md`, `CLAUDE_CODE_TASK.md`, `CLAUDE_CODE_COMPACT.md`, `plan_create_table_api.md`, `test/VARIANT3_BUILD_REPORT.md`. Сторонние исходники с собственными README: `wren/c/wren-src/`, `libxl-5.2.0.1/` — в карту не включены.

## 17. Снимок состояния (2026-09)

> **Примечание:** снимок может отставать от кода. Актуальное состояние — `qte check all` и `qte index list`.

- Реестр: 3802 функции, индексы 1–24713, коллизий 0; модулей 125 / gen-модулей 116; `PFUNQT_SIZE` 25000 (заполнен).
- DLL: dll32 — 32 qte56_*, dll64 — 22 (нет: qgraphicsscene, qmediaplayer, qmodelview, qpointf, qrectf, qsound, qsoundeffect, qstyleditemdelegate, qxlsx, tvision).
- Известные расхождения (не мешают): 2 дубликата имён (`qteQLineEdit_setCompleter`, `qteQComboBox_setCompleter`); 8 геттеров закомментированы в `gen_qcombobox.d`/`gen_qlineedit.d` (1455–1460, 1071–1072, индексы не переиспользовать); 11 orphans (QPushButton 402–407, QLabel 803–818 — есть в C++, намеренно не забиндены).

## 18. Запрещено

- **Редактировать `d/gen/gen_*.d` вручную** — они генерируются. Новые методы — только через `generator/` (`--augment` или `main.py`), изменения приходят патчем на ревью.
- **Править `registry/functions.csv` вручную** (кроме восстановления кодировки UTF-8): индексы назначает только генератор через `--index-start`.
- Добавлять зависимости в `dub.sdl`/сборку без явного согласования с пользователем.
- Хардкодить пути, секреты и учётные данные.
- Обходить ошибки компилятора «наугад» (`cast` без причины, ослабление `@safe`, отключение проверок).
- Ослаблять/удалять существующие проверки в `checks.py`, чтобы «прошёл preflight».


## 19. Анти-галлюцинации (API)

- Вызывай только методы, которые реально есть в gen-модулях и `qte56_core.d`. Перед вызовом незнакомого метода — `qte class <Класс>`.
- Метода нет? **Не выдумывай сигнатуру.** Это кандидат на `--augment` — предложи пользователю генерацию.
- Сигнатуры, параметры и поведение проверяй по исходникам: `d/gen/*.d`, `d/qte56_core.d`, а для C++ — `cpp/qt5/qte56_*`. Документация (`doc/`, `AI_*.md`) может отставать — в расхождении истина: код + `qte`, расхождение доложи.
- Не переиспользовай индексы из закомментированных методов (см. §17) — это уже сделано за тебя в генераторе, но не предполагай, что «свободные» индексы безопасны без `qte index gaps`.

## 20. Когда останавливаться и спрашивать

- Нужно добавить новый класс или метод (изменение реестра индексов, `PFUNQT_SIZE`).
- Задача затрагивает генератор, `registerModule` или `pFunQt`.
- Документация противоречит коду — доложи расхождение, не «чинись» молча.
- Изменение затрагивает DLL-обёртки на C++ (`cpp/qt5/*`) или порядок индексов.
- Тесты падают, но причина не в твоих правках.
- Требования задачи противоречат структуре проекта или правилам из §4/§18.
- Требуется длительное исследование или поиск ошибки, требующие повышенный расход токенов.

### Журнал изменений

- **2026-07-25** — новый генератор: QPointF (21800–21808), QRectF (21900–21948), первые value-классы. Тест: `test/test_qpointf_qrectf.d`.
- **2026-07-26** — `--augment`: QShortcut +6 (20163–20168), тест 25/25; QPainter +75 (18102–18245, merged foundation, перегрузки с value-типами), тесты 12/12 и регресс 33/33.
- **2026-08-02** — полный аудит ~100 *.md против кода/реестра (пути, сигнатуры, маппинги); исправлены регрессии `qte signals` и `make_build.py`.
- **2026-08-28** — QScintilla 2.13.3 → 2.14.1 (Scintilla 5), исходники `QScintilla_src-2.14.1/`; `qteQsci_replace` использует `replaceSelectedText()` (в 2.14 `replace()` — no-op). Тест 59/59. Сборка DLL переведена на w64devkit (GCC 16.2.0).
- **2026-08-29** — QAbstractItemDelegate (12018–12020) + QStyledItemDelegate (12100–12108) — первый класс с virtual-коллбэками в D: trampoline `eQStyledItemDelegate` (onPaint, onSizeHint, onCreateEditor, onSetEditorData, onSetModelData) + `wrapBorrowed` для QModelIndex/QPainter. Standalone `qte56_qstyleditemdelegate.dll`. Тест 12/12.
- **2026-10-05** — добавлены разделы 18–20 (запреты, анти-галлюцинации, стоп-условия), цикл верификации в §15, примечание к снимку состояния (§17). GOTCHAS (§13) сохранены полностью.
- **2026-10-05** — аудит непротиворечивости: §2 (114→116 gen-модулей, ~106→~107 C++ проектов), §9 (standalone 24→26: +qmodelview, +qstyleditemdelegate), §1 (+`qte index list`), исправлена предыдущая запись журнала (18–21→18–20, git-политика не добавлялась).
- **2026-10-06** — §16: в карту документации добавлены все неучтённые *.md проекта (121 файл проаудирован): корневые `README.md`/`QTE56_Research_Report.md`/`QT_KNOWLEDGE_TRANSFER.md`, строки таблицы Excel/Wren/TVision/DMC/ML/Forth/Wizard/Утилиты дополнены, новые строки «Реестр НОАП» и «Формирование приказов», блок «Рабочие заметки и контексты AI-сессий». Сторонние `wren/c/wren-src/` и `libxl-5.2.0.1/` сознательно не включены.

---

*AGENTS.md — обновлять при добавлении критических правил или изменении архитектуры.*
