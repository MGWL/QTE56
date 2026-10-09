# QTE56 — AI_SIGNALS_REF (полный справочник сигналов)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Формат: `widget.connect_*(sl или cb)` → сигнатура коллбэка
> ESlot = `__gshared ESlot g_sl; g_sl=new ESlot(w.getWH()); g_sl.set(cast(void*)&cb); w.connect_*(g_sl);`
> Прямой = `w.onXxx(cast(void*)&cb);`
> ОБЯЗАТЕЛЬНО: ESlot должен жить в __gshared!

---

## ESlot-сигналы (invoke_b — bool/checked)

| Виджет | connect_* | Сигнатура коллбэка |
|--------|----------|-------------------|
| QPushButton | `connect_clicked(sl)` | `void cb(void* dt, int n, int checked)` — checked=0 для обычных кнопок |
| QPushButton | `connect_toggled(sl)` | `void cb(void* dt, int n, int checked)` — только если setCheckable(true) |
| QPushButton | `connect_released(sl)` | `void cb(void* dt, int n, int checked)` |
| QCheckBox | `connect_clicked(sl)` | `void cb(void* dt, int n, int checked)` — 0/1 |
| QCheckBox | `connect_toggled(sl)` | `void cb(void* dt, int n, int checked)` |
| QRadioButton | `connect_clicked(sl)` | `void cb(void* dt, int n, int checked)` |
| QRadioButton | `connect_toggled(sl)` | `void cb(void* dt, int n, int checked)` |
| QToolButton | `connect_clicked(sl)` | `void cb(void* dt, int n, int checked)` |
| QAction | `connect_triggered(sl)` | `void cb(void* dt, int n, int checked)` — checked только если setCheckable |
| QDockWidget | `connect_visibilityChanged(sl)` | `void cb(void* dt, int n, int visible)` |
| QToolBar | `connect_visibilityChanged(sl)` | `void cb(void* dt, int n, int visible)` |
| QTextEdit | `connect_undoAvailable(sl)` | `void cb(void* dt, int n, int available)` |
| QTextEdit | `connect_redoAvailable(sl)` | `void cb(void* dt, int n, int available)` |
| QTextEdit | `connect_copyAvailable(sl)` | `void cb(void* dt, int n, int available)` |
| QPlainTextEdit | `connect_undoAvailable(sl)` | `void cb(void* dt, int n, int available)` |
| QPlainTextEdit | `connect_redoAvailable(sl)` | `void cb(void* dt, int n, int available)` |
| QPlainTextEdit | `connect_copyAvailable(sl)` | `void cb(void* dt, int n, int available)` |

---

## ESlot-сигналы (invoke_i — int value)

| Виджет | connect_* | Сигнатура коллбэка | Примечание |
|--------|----------|--------------------|-----------|
| QCheckBox | `connect_stateChanged(sl)` | `void cb(void* dt, int n, int state)` | 0=Off 1=Partial 2=On |
| QSlider | `connect_valueChanged(sl)` | `void cb(void* dt, int n, int value)` | |
| QSlider | `connect_sliderMoved(sl)` | `void cb(void* dt, int n, int value)` | только при drag |
| QDial | `connect_valueChanged(sl)` | `void cb(void* dt, int n, int value)` | |
| QScrollBar | `connect_valueChanged(sl)` | `void cb(void* dt, int n, int value)` | |
| QScrollBar | `connect_actionTriggered(sl)` | `void cb(void* dt, int n, int action)` | |
| QSpinBox | `connect_valueChanged_i(sl)` | `void cb(void* dt, int n, int value)` | суффикс _i! |
| QComboBox | `connect_currentIndexChanged_i(sl)` | `void cb(void* dt, int n, int idx)` | суффикс _i! |
| QComboBox | `connect_highlighted_i(sl)` | `void cb(void* dt, int n, int idx)` | |
| QTabWidget | `connect_currentChanged(sl)` | `void cb(void* dt, int n, int idx)` | |
| QTabWidget | `connect_tabCloseRequested(sl)` | `void cb(void* dt, int n, int idx)` | нужен setTabsClosable(true) |
| QTabWidget | `connect_tabBarClicked(sl)` | `void cb(void* dt, int n, int idx)` | |
| QTabWidget | `connect_tabBarDoubleClicked(sl)` | `void cb(void* dt, int n, int idx)` | |
| QProgressBar | `connect_valueChanged(sl)` | `void cb(void* dt, int n, int value)` | |
| QStackedWidget | `connect_currentChanged(sl)` | `void cb(void* dt, int n, int idx)` | |
| QHeaderView | `connect_sectionClicked(sl)` | `void cb(void* dt, int n, int idx)` | |
| QHeaderView | `connect_sectionDoubleClicked(sl)` | `void cb(void* dt, int n, int idx)` | |
| QHeaderView | `connect_sectionPressed(sl)` | `void cb(void* dt, int n, int idx)` | |
| QPlainTextEdit | `connect_blockCountChanged(sl)` | `void cb(void* dt, int n, int count)` | |
| QToolBox | `connect_currentChanged(sl)` | `void cb(void* dt, int n, int idx)` | |
| QTabBar | `connect_tabCloseRequested(sl)` | `void cb(void* dt, int n, int idx)` | |

---

## ESlot-сигналы (invoke_ii — два int)

| Виджет | connect_* | Сигнатура коллбэка |
|--------|----------|--------------------|
| QTableWidget | `connect_cellClicked(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QTableWidget | `connect_cellDoubleClicked(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QTableWidget | `connect_cellChanged(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QTableWidget | `connect_cellPressed(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QTableWidget | `connect_cellActivated(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QTableWidget | `connect_cellEntered(sl)` | `void cb(void* dt, int n, int row, int col)` |
| QSplitter | `connect_splitterMoved(sl)` | `void cb(void* dt, int n, int pos, int idx)` |
| QLineEdit | `connect_cursorPositionChanged(sl)` | `void cb(void* dt, int n, int old, int new_)` |

---

## ESlot-сигналы (invoke_d — double)

| Виджет | connect_* | Сигнатура коллбэка |
|--------|----------|--------------------|
| QDoubleSpinBox | `connect_valueChanged_d(sl)` | `void cb(void* dt, int n, double value)` |

---

## ESlot-сигналы (invoke_s — void* QString)

| Виджет | connect_* | Сигнатура коллбэка | Примечание |
|--------|----------|--------------------|-----------|
| QLineEdit | `connect_textChanged(sl)` | `void cb(void* dt, int n, void* qs)` | `fromQString(qs)` |
| QLineEdit | `connect_textEdited(sl)` | `void cb(void* dt, int n, void* qs)` | |
| QComboBox | `connect_currentTextChanged(sl)` | `void cb(void* dt, int n, void* qs)` | |
| QComboBox | `connect_currentIndexChanged_s(sl)` | `void cb(void* dt, int n, void* qs)` | |
| QComboBox | `connect_editTextChanged(sl)` | `void cb(void* dt, int n, void* qs)` | только editable |
| QComboBox | `connect_highlighted_s(sl)` | `void cb(void* dt, int n, void* qs)` | |
| QSpinBox | `connect_valueChanged_s(sl)` | `void cb(void* dt, int n, void* qs)` | с префиксом/суффиксом |
| QInputDialog | `connect_textValueChanged(sl)` | `void cb(void* dt, int n, void* qs)` | |
| QInputDialog | `connect_textValueSelected(sl)` | `void cb(void* dt, int n, void* qs)` | |

> `fromQString(qs)` — конвертирует и **освобождает** qs. Не использовать qs после!

---

## ESlot-сигналы (invoke_v — void, без параметров)

| Виджет | connect_* | Сигнатура коллбэка |
|--------|----------|--------------------|
| QLineEdit | `connect_returnPressed(sl)` | `void cb(void* dt, int n)` |
| QLineEdit | `connect_editingFinished(sl)` | `void cb(void* dt, int n)` |
| QLineEdit | `connect_selectionChanged(sl)` | `void cb(void* dt, int n)` |
| QTimer | `connect_timeout(sl)` | `void cb(void* dt, int n)` |
| QTextEdit | `connect_textChanged(sl)` | `void cb(void* dt, int n)` |
| QTextEdit | `connect_selectionChanged(sl)` | `void cb(void* dt, int n)` |
| QTextEdit | `connect_cursorPositionChanged(sl)` | `void cb(void* dt, int n)` |
| QPlainTextEdit | `connect_textChanged(sl)` | `void cb(void* dt, int n)` |
| QPlainTextEdit | `connect_selectionChanged(sl)` | `void cb(void* dt, int n)` |
| QPlainTextEdit | `connect_cursorPositionChanged(sl)` | `void cb(void* dt, int n)` |
| QDialog | `connect_accepted(sl)` | `void cb(void* dt, int n)` |
| QDialog | `connect_rejected(sl)` | `void cb(void* dt, int n)` |
| QMenu | `connect_aboutToShow(sl)` | `void cb(void* dt, int n)` |
| QMenu | `connect_aboutToHide(sl)` | `void cb(void* dt, int n)` |
| QTableWidget | `connect_itemSelectionChanged(sl)` | `void cb(void* dt, int n)` |
| QDockWidget | `connect_topLevelChanged(sl)` | `void cb(void* dt, int n)` |
| QTextBrowser | `connect_backwardAvailable(sl)` | `void cb(void* dt, int n)` |
| QTextBrowser | `connect_forwardAvailable(sl)` | `void cb(void* dt, int n)` |
| QTextDocument | `connect_contentsChanged(sl)` | `void cb(void* dt, int n)` |

---

## Прямые коллбэки (не ESlot) — onXxx / connect_* с void*

### QListWidget
```
onItemClicked(cb)          → void cb(void* dt, int n, void* item)
onItemDoubleClicked(cb)    → void cb(void* dt, int n, void* item)
onItemChanged(cb)          → void cb(void* dt, int n, void* item)
onItemActivated(cb)        → void cb(void* dt, int n, void* item)
onItemSelectionChanged(cb) → void cb(void* dt, int n)
onCurrentRowChanged(cb)    → void cb(void* dt, int n, int row)
onCurrentTextChanged(cb)   → void cb(void* dt, int n, void* qs)   // fromQString(qs)
onCurrentItemChanged(cb)   → void cb(void* dt, int n, void* cur, void* prev)
// item: QListWidgetItem.wrap(item) — НЕ освобождать!
```

### QTreeWidget
```
onItemClicked(cb)          → void cb(void* dt, int n, void* item, int col)
onItemDoubleClicked(cb)    → void cb(void* dt, int n, void* item, int col)
onItemChanged(cb)          → void cb(void* dt, int n, void* item, int col)
onItemActivated(cb)        → void cb(void* dt, int n, void* item, int col)
onItemExpanded(cb)         → void cb(void* dt, int n, void* item)
onItemCollapsed(cb)        → void cb(void* dt, int n, void* item)
onItemSelectionChanged(cb) → void cb(void* dt, int n)
onCurrentItemChanged(cb)   → void cb(void* dt, int n, void* cur, void* prev)
// item: QTreeWidgetItem.wrap(item) — НЕ удалять!
```

### QButtonGroup
```
connect_buttonClicked(cb, dthis)  → void cb(void* dthis, int id)         // id кнопки
connect_buttonToggled(cb, dthis)  → void cb(void* dthis, int id, int on) // id + состояние
```

### QMenu (прямой)
```
connect_triggered(cb, ud) → void cb(void* ud, void* actionPtr)
connect_hovered(cb, ud)   → void cb(void* ud, void* actionPtr)
// actionPtr: QAction.wrap(actionPtr)
```

### QMessageBox
```
connect_buttonClicked(cb, dthis) → void cb(void* dthis, int n, void* abstractButtonPtr)
```

### QTextBrowser
```
connect_anchorClicked(cb, dthis) → void cb(void* dthis, int n, void* urlPtr)
// urlPtr — QUrl heap-allocated; wrap через QUrl: авто-освобождение не гарантировано
```

### QCalendarWidget
```
connect_selectionChanged(cb, dthis) → void cb(void* dthis)
connect_currentPageChanged(cb, dthis) → void cb(void* dthis, int year, int month)
```

### QDateTimeEdit / QDateEdit / QTimeEdit
```
connect_dateTimeChanged(cb, dthis) → void cb(void* dthis, int n, int y, int mo, int d, int h, int mi, int s, int ms)
connect_dateChanged(cb, dthis)     → void cb(void* dthis, int n, int year, int month, int day)
connect_timeChanged(cb, dthis)     → void cb(void* dthis, int n, int h, int min, int sec, int ms)
```

### QColorDialog
```
connect_colorSelected(cb, dthis)      → void cb(void* dthis, int n, void* colorPtr)
connect_currentColorChanged(cb, dthis)→ void cb(void* dthis, int n, void* colorPtr)
// colorPtr: QColor.wrap(colorPtr) — wrap, не new!
```

### QFontDialog
```
connect_fontSelected(cb, dthis)       → void cb(void* dthis, int n, void* fontPtr)
connect_currentFontChanged(cb, dthis) → void cb(void* dthis, int n, void* fontPtr)
// fontPtr: QFont.wrap(fontPtr) — wrap, не new!
```

### QCompleter
```
connect_activated(void delegate(string) cb) → вызывается с выбранной строкой
// Пример:
completer.connect_activated((string s) {
    edit.setText(s);
});
```

### QFileSystemWatcher
```
connect_fileChanged(void delegate(string) cb)      → cb(path)
connect_directoryChanged(void delegate(string) cb) → cb(path)
// Пример:
watcher.connect_fileChanged((string path) {
    writeln("Changed: ", path);
});
```

### QShortcut
```
sc.connect_activated(() { /* void delegate */ });
// Пример:
auto sc = new QShortcut(win.getWH(), "Ctrl+Q");
sc.connect_activated(() { win.close(); });
```

### QThread
```
t.connect_started(void delegate() cb)   // вызывается в главном потоке
t.connect_finished(void delegate() cb)  // вызывается в главном потоке
// НЕ ESlot! Принимают void delegate(), а не extern(C) функцию.
```

### QProcess
```
connect_finished(cb)  → extern(C) void cb(int exitCode, int exitStatus)
// НЕ ESlot! Прямой C-коллбэк без dt и n.
proc.connect_finished(cast(void*)&onDone);
```

### QSystemTrayIcon
```
connect_activated(cb)  → extern(C) void cb(int reason)
// НЕ ESlot! reason: 1=Context, 2=DblClick, 3=Trigger, 4=MiddleClick
tray.connect_activated(cast(void*)&onTray);
```

### QNetworkAccessManager
```
connect_finished(dthis, n, cb) → extern(C) void cb(void* dthis, int n, void* replyPtr)
// replyPtr: QNetworkReply.wrap(replyPtr); обязательно reply.deleteLater()!
```

### QNetworkReply
```
connect_finished(dthis, n, cb)           → void cb(void* dt, int n)
connect_readyRead(dthis, n, cb)          → void cb(void* dt, int n)
connect_errorOccurred(dthis, n, cb)      → void cb(void* dt, int n, int errorCode)
connect_downloadProgress(dthis, n, cb)   → void cb(void* dt, int n, long received, long total)
connect_uploadProgress(dthis, n, cb)     → void cb(void* dt, int n, long sent, long total)
connect_sslErrors(dthis, n, cb)          → void cb(void* dt, int n, int errorCount)
```

---

## События виджетов (onXxx — все виджеты)

```d
// Подключение: w.onXxx(cast(void*)&cb);  — без int n!
extern(C) void onClose       (void* dt, int* accept)             { *accept=1; } // 0=блокировать
extern(C) void onKeyPress    (void* dt, int key, int mods)       { }
extern(C) void onKeyRelease  (void* dt, int key, int mods)       { }
extern(C) void onMousePress  (void* dt, int x, int y, int btn)   { }
extern(C) void onMouseRelease(void* dt, int x, int y, int btn)   { }
extern(C) void onMouseMove   (void* dt, int x, int y)            { }
extern(C) void onMouseDoubleClick(void* dt, int x, int y, int btn) { }
extern(C) void onWheel       (void* dt, int dx, int dy)          { }
extern(C) void onResize      (void* dt, int w, int h)            { }
extern(C) void onMove        (void* dt, int x, int y)            { }
extern(C) void onShow        (void* dt)                          { }
extern(C) void onHide        (void* dt)                          { }
extern(C) void onFocusIn     (void* dt, int reason)              { }
extern(C) void onFocusOut    (void* dt, int reason)              { }
extern(C) void onEnter       (void* dt)                          { } // мышь вошла
extern(C) void onLeave       (void* dt)                          { } // мышь ушла
extern(C) void onContextMenu (void* dt, int x, int y)            { }
extern(C) void onPaint       (void* dt, void* widget)            {
    auto p = new QPainter(widget, true);
    // ... рисовать ...
    p.end();
}
```

**Коды кнопок мыши:** 1=Left, 2=Right, 4=Middle

**Коды клавиш (key):** совпадают с Qt::Key. Примеры:
- 16777216=Esc, 16777220=Enter, 16777223=Delete
- 65=A ... 90=Z (Latin uppercase)
- 48=0 ... 57=9

**Модификаторы (mods):** 0=None, 33554432=Shift, 67108864=Ctrl, 134217728=Alt

---

## Полный пример подключения ESlot

```d
import qte56_core; import qte56_loader; import gen_qcore;
import gen_qwidget; import gen_qlayout; import gen_qspinbox;
import gen_qabstractspinbox; import gen_qlabel;
import core.memory : GC;

__gshared QSpinBox g_spin;
__gshared QLabel   g_lbl;
__gshared ESlot    g_sl;

// invoke_i → три параметра: dt, n, value
extern(C) void onSpinChanged(void* dt, int n, int value) {
    import std.conv : to;
    g_lbl.setText("Value: " ~ value.to!string);
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication();

    auto w = new QWidget(cast(void*)null);
    g_spin = new QSpinBox(cast(void*)null);
    g_lbl  = new QLabel(cast(void*)null);

    g_spin.setRange(0, 100); g_spin.setValue(42);
    g_lbl.setText("Value: 42");

    // Подключение сигнала:
    g_sl = new ESlot(g_spin.getWH());
    g_sl.set(cast(void*)&onSpinChanged);
    g_spin.connect_valueChanged_i(g_sl);  // ← суффикс _i обязателен!

    auto vbox = new QVBoxLayout(cast(void*)null);
    vbox.addWidget(g_spin); vbox.addWidget(g_lbl);
    w.setLayout(vbox); w.resize(300, 150); w.show();

    app.exec(); GC.collect(); app.deleteApp();
}
```

---

## Краткая шпаргалка — тип invoke по connect_*

| connect_* | invoke | 3-й параметр коллбэка |
|-----------|--------|-----------------------|
| clicked, toggled, triggered | invoke_b | `int checked` |
| stateChanged, valueChanged(slider/scroll), currentChanged, tabCloseRequested | invoke_i | `int value/idx` |
| valueChanged_i (spinbox) | invoke_i | `int value` |
| currentIndexChanged_i (combo) | invoke_i | `int idx` |
| cellClicked, cellChanged, splitterMoved | invoke_ii | `int a, int b` |
| valueChanged_d (doublespinbox) | invoke_d | `double value` |
| textChanged (lineedit), currentTextChanged | invoke_s | `void* qs` → `fromQString(qs)` |
| returnPressed, editingFinished, timeout, textChanged(textedit), selectionChanged | invoke_v | *(нет)* |

---

## OO-стиль: `dthis` как `this` для инкапсуляции в классе

Первый параметр любого коллбэка — `void* dthis`. Это **универсальный context-указатель**,
который ESlot хранит и передаёт обратно при срабатывании сигнала. По умолчанию там `null`,
и в большинстве примеров QTE56 использован глобальный (`__gshared`) стиль.

Но `dthis` можно использовать для передачи **адреса экземпляра класса** — тогда
обработчики становятся методами этого класса, а состояние (db, log, виджеты) хранится
в полях. Это устраняет глобалки и позволяет иметь несколько независимых экземпляров
одного окна.

### Базовый паттерн

```d
class CWin {
    QSqlDatabase db;
    QPlainTextEdit log;
    __gshared CWin[] _alive;   // защита от GC, см. ниже

    this() {
        _alive ~= this;        // удерживаем класс пока живо приложение

        auto sl = new ESlot(knOpen.getWH());
        sl.set(cast(void*)&onFind, cast(void*)this);   // ← this в dthis
        knOpen.connect_clicked(sl);
    }

    void runFind() {
        log.appendPlainText("Поиск...");
        // db, log — поля класса, никаких глобалок
    }
}

extern(C) void onFind(void* dthis, int n, int checked) {
    auto win = cast(CWin)dthis;
    win.runFind();
}
```

### Что и где хранить

| Поле | Назначение | Что класть |
|---|---|---|
| `new ESlot(parent)` | parent для Qt — кто удалит slot | виджет, который удалится одновременно с обработчиком (обычно сам sender) |
| `sl.set(cb, dthis, n)` | dthis — контекст для коллбэка | `cast(void*)this` экземпляра класса, или `null`, или указатель на структуру |
| `n` | tag для дифференциации сигналов | int-индекс (например, номер кнопки в массиве) |

⚠ Не путать `parent` ESlot и `dthis`. Это **разные** вещи:
- parent отвечает за время жизни slot'а на стороне Qt
- dthis передаётся первым аргументом в твою D-функцию

### Плюсы

- **Нет `__gshared`-глобалок** — состояние в полях класса.
- **Несколько окон одного класса** — каждое держит своё состояние независимо.
- **Тестируемость** — класс можно создать в unit-тесте без UI и вызвать метод напрямую.
- **Читается как обычный OO-код** — extern(C) функция вырождается в тонкий thunk.

### Минусы и ловушки

1. **Время жизни.** ESlot держит сырой `void*` на класс. Если GC соберёт класс
   до того, как сработает сигнал — креш. Решения:
   - `__gshared T[] _alive ~= this;` в конструкторе (как в примере выше);
   - `static this()` + singleton, если экземпляр один;
   - Привязать parent ESlot к виджету, который удаляется одновременно с классом,
     и в деструкторе D-класса явно занулить виджет.
2. **Каст через void* — небезопасно.** `cast(CWin)dthis` компилятор не проверит.
   Если положить туда не CWin — креш в рантайме без понятного сообщения.
   Дисциплина: **один и тот же класс для одного и того же набора thunk-функций**.
3. **Один thunk на каждый метод.** D-метод нельзя напрямую передать в C-callback
   (неявный this в нестандартном ABI). Нужна тонкая `extern(C)`-функция, которая
   делает `cast + вызов метода`. Это boilerplate, но он одинаковый и читаемый.
4. **Сигнатура thunk-а должна совпадать с invoke-типом сигнала.** Если кнопка
   `clicked()` → invoke_b → `(void*, int, int)`, а ты написал thunk `(void*, int)` —
   мусор в аргументах. Сверяться с таблицей сигналов выше.

### Когда использовать какой стиль

- **Глобалки `__gshared`** — для маленьких утилит, одиночных окон, прототипов.
  Простой путь, всё в `mgw.d` сейчас сделано так.
- **OO-стиль с `dthis = this`** — для приложений с несколькими окнами, MDI,
  когда состояние сложное и хочется инкапсуляции.

Выбор стиля — на усмотрение разработчика. ESlot поддерживает оба без изменений.

См. рабочий пример: `tools/qte_guide/snip/21_OoSignals.d`.

---

*QTE56 AI_SIGNALS_REF — апрель 2026*
