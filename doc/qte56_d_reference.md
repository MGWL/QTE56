# QTE56 — Полный справочник для написания D-программ

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [AI_CORE.md](../AI_CORE.md)

## Что это

QTE56 — привязки Qt 5.x к языку D через C++ shared-library обёртки.
Архитектура: D-класс → `pFunQt[index]` → `extern "C"` функция в DLL/SO → Qt C++ API.

| Платформа | Компилятор | Разрядность | Библиотеки |
|-----------|-----------|-------------|-----------|
| Windows   | `dmd -m32` | 32-бит | `dll/*.dll` (Qt MinGW 32-bit) |
| Linux     | `ldc2` (64-бит) | 64-бит | `lib/*.so` (Qt 5.15+) |

---

## 1. СТРУКТУРА ПРОГРАММЫ (обязательный шаблон)

```d
import std.stdio : writeln;

import qte56_core;          // pFunQt[], generateAlias, toQString, fromQString
import qte56_loader;        // LoadQt, UnloadQt, registerModule
import gen_qcore;           // ESlot, DRect/DPoint/DSize, QApplication
import gen_qwidget;         // QWidget
import gen_qlabel;          // QLabel
import gen_qpushbutton;     // QPushButton
// ... другие gen_*.d по необходимости

void main() {                          // ОБЯЗАТЕЛЬНО void main(), НЕ extern(C) int main()!
    LoadQt("./dll");                   // 1. Загрузить все .dll/.so и заполнить pFunQt[]
    auto app = new QApplication();     // 2. Создать QApplication (нужен для всего Qt)

    // ... создание виджетов и логика ...

    app.exec();                        // 3. Запуск Qt event loop (блокирует до quit)
    app.deleteApp();                   // 4. Снять GC.addRoot (разрешить GC финализировать)
    // UnloadQt() — НЕ вызывать: OS сама выгрузит DLL при выходе процесса
}
```

**КРИТИЧНО #1**: Использовать `void main()` (D main). С `extern(C) int main()` D runtime
не вызовет `static this()` модулей → `registerModule` не выполнится → `pFunQt[] = null` → краш.

**КРИТИЧНО #2**: `LoadQt()` ДОЛЖЕН быть вызван **до** `new QApplication()`.

**КРИТИЧНО #3**: `UnloadQt()` — **НЕ вызывать**. OS освобождает DLL при завершении процесса.
Если вызвать UnloadQt() до финализации GC → деструкторы D-объектов обращаются к pFunQt[N]==null.
`pFunQt[]` равны null до LoadQt — любое Qt-обращение сразу упадёт.

**Linux**: передать `"./lib"` или использовать фаллбек (loader.d автоматически переключается):
```d
LoadQt("./dll");  // Windows ИЛИ Linux — loader.d сам найдёт lib/ если dll/ нет
```

---

## 2. ИЕРАРХИЯ КЛАССОВ

```
QObject                          ← корень, содержит _wh и _qt_owned
  ├── QWidget                    ← базовый виджет
  │     ├── QFrame               ← рамка
  │     │     ├── QLabel
  │     │     ├── QSplitter
  │     │     ├── QStackedWidget
  │     │     ├── QScrollArea
  │     │     └── QAbstractScrollArea
  │     │           ├── QPlainTextEdit
  │     │           ├── QTextEdit → QTextBrowser
  │     │           ├── QMdiArea
  │     │           └── QAbstractItemView
  │     │                 ├── QListWidget
  │     │                 ├── QTableView → QTableWidget
  │     │                 └── QTreeView  → QTreeWidget
  │     ├── QAbstractButton
  │     │     ├── QPushButton → QCommandLinkButton
  │     │     ├── QCheckBox
  │     │     ├── QRadioButton
  │     │     └── QToolButton
  │     ├── QAbstractSlider
  │     │     ├── QSlider
  │     │     ├── QDial
  │     │     └── QScrollBar
  │     ├── QAbstractSpinBox
  │     │     ├── QSpinBox
  │     │     ├── QDoubleSpinBox
  │     │     └── QDateTimeEdit → QDateEdit, QTimeEdit
  │     ├── QProgressBar, QComboBox, QLineEdit, QGroupBox
  │     ├── QTabWidget, QMdiSubWindow, QHeaderView
  │     ├── QCalendarWidget, QLCDNumber, QDockWidget, QToolBox
  │     ├── QMainWindow, QDialog → QMessageBox, QFileDialog, QFontDialog,
  │     │                          QColorDialog, QInputDialog, QProgressDialog
  │     └── QMenuBar, QStatusBar, QToolBar
  └── QTimer, QAction, QMenu, QButtonGroup

Отдельные (НЕ наследуют QWidget/QObject):
  QColor, QFont, QPainter, QPixmap, QImage — value types (D всегда владеет)
  QSqlDatabase, QSqlQuery, QSettings, QFile — ресурсные обёртки
  QListWidgetItem, QTableWidgetItem, QTreeWidgetItem — item types
  QPen, QBrush, QPalette, QFontMetrics — drawing helpers (value types)
  QSplashScreen, QSystemTrayIcon — из qte56_systray.dll (владение: D)
```

---

## 3. ЖИЗНЕННЫЙ ЦИКЛ ОБЪЕКТА Qt

### 3.1 Поля в базовом классе QObject

```d
class QObject {
protected:
    void* _wh;        // Сырой указатель на C++ Qt-объект
    bool  _qt_owned;  // true = Qt владеет и удалит C++ объект; false = D удалит
}
```

### 3.2 Конструкторы: как создаётся C++ объект

У каждого класса **два** конструктора:

```d
class QLabel : QFrame {
    // (A) Основной — создаёт C++ объект:
    this(void* parent) {
        super();                                     // вызывает QFrame.protected this() — NOP
        _qt_owned = (parent !is null);              // Qt владеет если есть parent
        _wh = (cast(t_qp__qp)pFunQt[800])(parent); // qteQLabel_create(parent)
    }

    // (B) No-op — только для цепочки super() из подклассов:
    protected this(bool _noOp) { super(_noOp); }   // НЕ создаёт C++ объект!
}
```

**Почему protected this(bool _noOp)?**
В D при `new QLabel(parent)` вызывается конструктор A. Но если бы `QLabel` был
базовым для `QMyWidget`, то `QMyWidget.this(...)` должен вызвать `super()` без создания C++
объекта — это делает конструктор B (No-op). `_noOp` — фиктивный аргумент, лишь для
различения сигнатур.

**Полная цепочка** при `new QLabel("text", null)`:
```
QLabel.this("text", null)
  → super(true)        ← QFrame.this(bool _noOp)   — NOP
    → super(true)      ← QWidget.this(bool _noOp)   — NOP
      → super(true)    ← QObject.this(bool _noOp)   — NOP, _wh остаётся null
  → _qt_owned = false  ← parent is null → D владеет
  → _wh = qteQLabel_create_text(...)    ← единственное место создания C++ объекта
```

### 3.3 Правило _qt_owned

| Ситуация | _qt_owned | Кто удалит C++ объект |
|----------|-----------|----------------------|
| `new QLabel(null)` | `false` | **D деструктор** (~this) |
| `new QLabel(win.getWH())` | `true` | **Qt** (при удалении parent) |
| После `layout.disown()` | → `true` | **Qt** (widget взял владение layout) |
| После `item.disown()` | → `true` | **Qt** (tree/table взяли item) |
| `QTabBar.wrapOwned(ptr)` | `true` | **Qt** (это Qt-owned объект) |
| `QHeaderView.wrap(ptr)` | `true` (исключение!) | **Qt** |
| `QColor.wrap(ptr)` | `false` | **D деструктор** |

### 3.4 Деструктор: условное удаление C++ объекта

```d
// QWidget ~this() (наследуется QLabel, QPushButton, и т.д.):
~this() {
    if (!_qt_owned && _wh !is null && pFunQt[201] !is null) {
        (cast(t_v__qp)pFunQt[201])(_wh);   // C++: delete widget
        _wh = null;
    }
}
```

**Три защиты от проблем:**
1. `!_qt_owned` — не удалять Qt-owned объекты (parent удалит сам)
2. `_wh !is null` — предотвратить double-free
3. `pFunQt[201] !is null` — DLL может быть выгружена после `UnloadQt()`;
   в этом случае деструктор просто пропускает удаление (корректно)

**Цепочка деструкторов** при `destroy(myLabel)` или при GC-финализации:
```
~QLabel    — нет своего ~this → наследует QFrame
  → ~QFrame   — нет своего → наследует QWidget
    → ~QWidget: if (!_qt_owned) { delete(_wh); _wh = null; }
      → ~QObject: if (!_qt_owned && _wh !is null) { delete(_wh); }
                  // _wh уже null (QWidget его занулил) → NOP, double-free исключён
```

### 3.5 getWH(), getPtr() — получить сырой указатель

```d
void* getWH()  { return _wh; }    // используется везде (виджеты)
void* getPtr() { return _ptr; }   // в value types (QColor, QPixmap, QPen...)
```

`getWH()` / `getPtr()` передаются в:
- `new QLabel(win.getWH())` — parent при создании дочернего виджета
- `layout.addWidget(label.getWH())` — добавление в layout
- `win.setLayout(layout.getWH())` — установка layout
- `(cast(t_fn)pFunQt[N])(_wh, ...)` — прямые вызовы через pFunQt

### 3.6 disown() — передать владение Qt

```d
void disown()  { _qt_owned = true; }
```

#### 3.6.1 Typed API (рекомендуется, с 2026-04-09)

Следующие методы автоматически вызывают `disown()` — вручную вызывать не нужно:

| Метод | Файл | Тип параметра |
|-------|------|---------------|
| `addWidget(w, ...)` | gen_qlayout.d, gen_qsplitter.d, gen_qstackedwidget.d, gen_qtoolbar.d | `QObject` |
| `insertWidget(idx, w, ...)` | gen_qlayout.d, gen_qsplitter.d, gen_qstackedwidget.d | `QObject` |
| `addLayout(layout, ...)` | gen_qlayout.d (BoxLayout + GridLayout) | шаблон `(L)(...)` |
| `setLayout(layout)` | gen_qwidget.d | шаблон `(L)(...)` |
| `setParent(parent)` | gen_qwidget.d | `QObject` (null → не вызывает disown) |
| `setCentralWidget(w)` | gen_qmainwindow.d | `QObject` |
| `addTab(w, str)` | gen_qtabwidget.d | `QObject` |
| `insertTab(idx, w, str)` | gen_qtabwidget.d | `QObject` |
| `setWidget(w)` | gen_qscrollarea.d, gen_qdockwidget.d | `QObject` |
| `addTopLevelItem`, `addItem`, `addRow` | gen_qtreewidget.d и др. | типизированы |

Пример:

```d
// Typed API: disown() вызывается автоматически
vbox.addWidget(lbl);           // lbl._qt_owned = true
vbox.addLayout(inner);         // inner._qt_owned = true
win.setLayout(vbox);           // vbox._qt_owned = true
mw.setCentralWidget(widget);   // widget._qt_owned = true
tabs.addTab(page, "Name");     // page._qt_owned = true
```

#### 3.6.2 Void* API (обратная совместимость)

```d
// Layout → после setLayout:
auto layout = new QVBoxLayout();
win.setLayout(layout.getWH());
layout.disown();        // Qt теперь владеет layout; D не будет удалять

// Вложенный layout → после addLayout:
auto hbox = new QHBoxLayout();
layout.addLayout(hbox.getWH());
hbox.disown();          // Qt владеет вложенным layout тоже

// Item → после ручного addTopLevelItem / setItem:
auto item = new QTreeWidgetItem();
(cast(t_v__qp_qp)pFunQt[...])(tree.getWH(), item.getWH());
item.disown();
// Типизированные overload (addTopLevelItem, addItem, addRow) делают disown() автоматически
```

**Если не вызвать disown()**: D деструктор удалит C++ объект, Qt получит
dangling pointer → краш при перерисовке или закрытии окна.

### 3.7 Особые конструкторы

| Класс | Правило |
|-------|---------|
| `QWidget` | `new QWidget(null)` — **null обязателен**, не `new QWidget()` |
| `QAction` | `new QAction(cast(void*)null)` — `null` неоднозначен (два overload) |
| `QClipboard` | `QClipboard.get()` — синглтон, **НЕ создавать через new** |
| `QApplication` | `new QApplication("appname")` — один на программу |
| `QPainter` | `new QPainter(widget, true)` — `true` = auto-begin |
| Value types | `new QColor()`, `new QFont()`, `new QPixmap(w,h)` — **без parent** |
| `QHeaderView` | `new QHeaderView(orientation, parent)` — нестандартный ctor |

### 3.8 Особые деструкторы

| Класс / ситуация | Правило |
|-----------------|---------|
| `QApplication` | Вызвать `app.deleteApp()` после `app.exec()` — **не** оставлять GC; `UnloadQt()` не вызывать |
| `QClipboard` | **Никогда не удалять** — синглтон Qt |
| Layout после setLayout (void* API) | `layout.disown()` — иначе D удалит layout из-под Qt |
| Layout после setLayout (typed API) | `win.setLayout(layout)` — disown() вызывается автоматически |
| Item после addItem | `item.disown()` (типизированные overload делают сами) |
| `QTabBar` из `tabBar()` | `QTabBar.wrapOwned(ptr)` — Qt-owned |
| `QHeaderView` из `headerObj()` | `QHeaderView.wrap(ptr)` — Qt-owned |
| `QAction` из `addAction()` | `QAction.wrap(ptr)` — Qt-owned |
| `QMenu` из `addMenu()` | `QMenu.wrap(ptr)` — Qt-owned |
| `QMenuBar/QStatusBar/QToolBar` | `.wrap(ptr)` — Qt-owned |
| Value types | D всегда удаляет через ~this |

### 3.9 Порядок завершения (обязательный)

```d
app.exec();       // 1. Event loop завершился (после QApplication.quit())
app.deleteApp();  // 2. GC.removeRoot — разрешаем GC финализировать app объект
// НЕ вызывать UnloadQt() — OS освободит DLL при выходе процесса.
// Деструкторы D-виджетов, оставшихся в GC-куче, безопасно видят pFunQt[N]!=null
// и корректно удаляют C++-объекты (если !_qt_owned).
```

### 3.10 Расширенный API QObject

Начиная с обновления 2026-07, базовый класс `QObject` предоставляет полноценный набор методов для управления жизненным циклом, потоками, событиями и отладки дерева объектов.

#### Имя объекта

```d
auto obj = new QObject(null);
obj.setObjectName("loader");
writeln(obj.objectName());  // "loader"
```

Имя используется для отладки, поиска дочерних объектов (`findChild`) и сохранения настроек UI.

#### Блокировка сигналов

```d
auto slider = new QSlider(null);
slider.blockSignals(true);   // временно "заткнуть"
slider.setValue(50);         // valueChanged не выстрелит
slider.blockSignals(false);  // снова слушаем
```

#### Родительско-дочерние отношения

```d
auto parent = new QObject(null);
auto child  = new QObject(parent.getWH());
assert(child.parent() == parent.getWH());

auto newParent = new QObject(null);
child.setParent(newParent.getWH());
assert(child.parent() == newParent.getWH());
```

#### Безопасное удаление

```d
// Внутри слота нельзя удалить sender напрямую — используем deleteLater
someObj.deleteLater();
```

#### Проверка типа по имени класса

```d
auto w = new QWidget(null);
assert(w.inherits("QObject"));
assert(w.inherits("QWidget"));
assert(!w.inherits("QPushButton"));
```

#### Поточная принадлежность (thread affinity)

Каждый QObject "живёт" в одном потоке. Сигналы и события доставляются в этот поток.

```d
auto worker = new QObject(null);
auto thread = new QThread({ /* фоновая работа */ });

worker.moveToThread(thread.getWH());
assert(worker.thread() == thread.getWH());

thread.start();
thread.wait();
```

**Важно:** объект с родителем (`_qt_owned == true`) нельзя переносить в другой поток — `moveToThread` в этом случае не работает или падает.

#### Встроенные таймеры

```d
auto obj = new QObject(null);
int id = obj.startTimer(1000);  // событие TimerEvent каждую секунду
// ...
obj.killTimer(id);
```

Для обработки таймера в наследнике переопределяют `event()`:

```d
class MyObj : QObject {
    this() { super(null); }
    override bool event(void* e) {
        // здесь можно проверить тип события через QEvent
        return super.event(e);
    }
}
```

#### Проверки типа объекта

```d
auto w = new QWidget(null);
assert(w.isWidgetType());
assert(!w.isWindowType());   // top-level окно — только если show() или родитель null у некоторых классов
```

#### Отладка дерева объектов

```d
auto win = new QWidget(null);
win.setObjectName("mainWindow");
auto lbl = new QLabel(win.getWH());
lbl.setObjectName("statusLabel");

win.dumpObjectTree();  // печать иерархии
win.dumpObjectInfo();  // печать имён, классов, адресов
```

#### Обход дочерних объектов

```d
auto parent = new QWidget(null);
new QLabel(parent.getWH());
new QPushButton(parent.getWH());

writeln(parent.childrenCount());  // 2
void* first  = parent.childrenAt(0);
void* second = parent.childrenAt(1);
```

#### Перехват событий (eventFilter)

```d
class Spy : QObject {
    this() { super(null); }
    override bool eventFilter(void* watched, void* event) {
        // вернуть true — остановить дальнейшую обработку
        return false;
    }
}

auto spy   = new Spy();
auto label = new QLabel(null);
label.installEventFilter(spy.getWH());
// ...
label.removeEventFilter(spy.getWH());
```

#### Сигнал уничтожения

```d
extern(C) void onDestroyed(void* dthis) {
    writeln("object destroyed");
}

auto obj = new QObject(null);
obj.connect_destroyed(&onDestroyed, null);
```

---

## 4. ПЕРЕДАЧА СТРОК D ↔ Qt

### 4.1 Кодировки

| Сторона | Тип | Кодировка |
|---------|-----|-----------|
| D `string` | `immutable(char)[]` | UTF-8 |
| Qt `QString` | heap object, создаётся в C++ | UTF-16 внутри |
| Граница D→C++ | `void*` (указатель на heap `QString`) | — |

### 4.2 D string → Qt: один унифицированный протокол

Все `gen_*.d` методы используют **одну** схему: `toQString()` → `void*` → free.

```d
// Пример: как генератор генерирует setWindowTitle, setText, setToolTip и т.д.:
void setWindowTitle(string p0) {
    auto _ws_p0 = toQString(p0);              // 1. UTF-8 → heap Qt QString*
    (cast(t_v__qp_qp)pFunQt[203])(_wh, _ws_p0);  // 2. передать void* в C++
    (cast(t_v__qp)pFunQt[22])(_ws_p0);        // 3. удалить heap QString*
}
```

Соответствующая C++ функция принимает `void*` и разыменовывает:
```cpp
void qteQWidget_setWindowTitle(void* _obj, void* p0) {
    ((QWidget*)_obj)->setWindowTitle(*(QString*)p0);
}
```

**Внутри `toQString()`** используется `wchar_t*`+`len` как деталь реализации
(pFunQt[20] = `qteQString_fromWStr`), но этот уровень скрыт от пользователя.

### 4.3 Qt → D string: всегда через heap-allocated QString*

Когда C++ функция возвращает строку (text(), title(), и т.д.):

```d
// C++ сигнатура: void* qteQLabel_text(void* label) — возвращает new QString*

void* qs = (cast(t_qp__qp)pFunQt[IDX])(_wh);  // C++ создал new QString на куче
string result = fromQString(qs);                 // скопировать: Qt QString → D string
(cast(t_v__qp)pFunQt[22])(qs);                 // удалить heap QString*
return result;
```

**Почему нужно удалять**: C++ функция делает `new QString(...)` и возвращает указатель.
D не знает о C++ heap → GC его не освободит. `pFunQt[22]` = `qteQString_free` = `delete qs`.

### 4.4 fromQString() — детально

```d
// Реализация в gen_qcore.d: динамический буфер (удвоение при переполнении)
string fromQString(void* qs) {
    if (qs is null) return "";
    int cap = 4096;
    while (true) {
        auto buf = new wchar[cap];
        int len = (cast(t_i__qp_qp_i)pFunQt[21])(qs, cast(void*)buf.ptr, cap);
        if (len <= 0) return "";
        if (len < cap) {
            import std.utf : toUTF8;
            return buf[0 .. len].toUTF8;
        }
        cap *= 2;   // строка не поместилась — удвоить буфер
    }
}
```

Буфер динамически удваивается: первые 4096 wchar, затем 8192, 16384... Поддерживаются
строки произвольной длины (актуально для QTextEdit, чтения больших Wren-файлов и т.д.).

### 4.5 toQString() — детально

```d
// Реализация в gen_qcore.d:
void* toQString(string s) {
    import std.utf : toUTF16;
    wstring ws = s.toUTF16;  // D allocates wstring (UTF-8 → UTF-16)
    // pFunQt[20] = qteQString_fromWStr: C++ делает new QString(wchar_t*, len)
    return (cast(t_qp__qp_i)pFunQt[20])(cast(void*)ws.ptr, cast(int)ws.length);
}
// Вызывающий код ОБЯЗАН вызвать pFunQt[22](qs) чтобы освободить результат!
```

### 4.6 Строки в сигналах ESlot (invoke_s)

Когда Qt сигнал передаёт `QString` через ESlot (textChanged, textEdited и т.д.):

```d
extern(C) void on_text_changed(void* dthis, int n, void* qs) {
    // qs — ссылка на Qt QString, НЕ heap-allocated (не нужно удалять!)
    string s = fromQString(qs);   // Скопировать в D string
    // НЕ вызывать pFunQt[22](qs)! Это ссылка на const QString& из стека C++
    writefln("Text: %s", s);
}
```

**Правило**: если `void* qs` пришёл **в callback как аргумент** — это ссылка, не удалять.
Если `void* qs` получен как **возвращаемое значение** Qt-функции — heap-allocated, удалять.

### 4.7 Таблица: когда удалять QString

| Источник | Удалять? | Пример |
|----------|----------|--------|
| Возвращаемое значение getter-функции | **ДА** | `label.text()`, `win.windowTitle()` |
| Аргумент ESlot callback (invoke_s) | **НЕТ** | `on_textChanged(dthis, n, qs)` |
| Результат `toQString(s)` | **ДА** | `qs = toQString("...")` |

### 4.8 Пустая строка

```d
// Через wrapper-метод — просто передать "":
label.setText("");   // внутри вызовет toQString("") → free

// Напрямую через pFunQt (если пишете low-level код):
auto qs = toQString("");
(cast(t_v__qp_qp)pFunQt[825])(_wh, qs);
(cast(t_v__qp)pFunQt[22])(qs);
```

---

## 5. СИГНАЛЫ И СЛОТЫ

### 5.1 Четыре паттерна

| Паттерн | Когда | Примеры сигналов |
|---------|-------|-----------------|
| **ESlot** | Стандартные Qt сигналы | clicked, toggled, valueChanged, textChanged |
| **Direct callback** | Item-based сигналы | onItemClicked, onCurrentRowChanged |
| **Lambda-connect** | Сигналы с value-type параметрами | dateChanged, colorSelected |
| **Signal!T** (`d/signal.d`) | Чистый D pub/sub, без Qt | Внутренняя логика, Model/View, EventBus |

### 5.2 Паттерн ESlot

```d
// Шаг 1: определить callback (ОБЯЗАТЕЛЬНО extern(C)):
extern(C) void on_click(void* dthis, int n, int checked) {
    writefln("Button %d clicked, checked=%d", n, checked);
}

// Шаг 2: создать ESlot (parent — виджет, которому принадлежит слот):
auto slot = new ESlot(win.getWH());   // parent = win; Qt удалит slot вместе с win

// Шаг 3: установить callback (dthis и n — произвольный контекст):
slot.set(cast(void*)&on_click);               // dthis=null, n=0
slot.set(cast(void*)&on_click, myObj, 42);    // dthis=myObj, n=42

// Шаг 4: подключить к сигналу:
btn.connect_clicked(slot);
```

**Таблица callback-сигнатур:**

| Тип сигнала | Метод ESlot | Сигнатура D callback |
|-------------|------------|---------------------|
| `void signal()` | `invoke_v()` | `void(void* dthis, int n)` |
| `void signal(bool)` | `invoke_b(bool)` | `void(void* dthis, int n, int val)` |
| `void signal(int)` | `invoke_i(int)` | `void(void* dthis, int n, int val)` |
| `void signal(int,int)` | `invoke_ii(int,int)` | `void(void* dthis, int n, int a, int b)` |
| `void signal(double)` | `invoke_d(double)` | `void(void* dthis, int n, double val)` |
| `void signal(QString)` | `invoke_s(qs)` | `void(void* dthis, int n, void* qs)` |

**Важно про строковый сигнал**: `void* qs` — это ссылка на `const QString&` в стеке C++.
Вызов `fromQString(qs)` копирует её в D string. `pFunQt[22](qs)` вызывать **НЕ НУЖНО**.

### 5.3 Direct callback (Item-based виджеты)

```d
extern(C) void on_item(void* dthis, int n, void* item_ptr) {
    auto item = QListWidgetItem.wrap(item_ptr);  // wrap: Qt-owned, D не удаляет
    writefln("Clicked: %s", item.text());
}

list.onItemClicked(cast(void*)&on_item);
list.onCurrentRowChanged(cast(void*)&on_row);
```

### 5.4 Lambda-connect (QDateTimeEdit, QCalendarWidget, QColorDialog)

```d
// dateChanged — Qt QDate разложен на три int:
extern(C) void on_date(void* dthis, int n, int y, int mo, int d) {
    writefln("%04d-%02d-%02d", y, mo, d);
}
dte.connect_dateChanged(cast(void*)&on_date);
```

### 5.5 Signal!T — чистый D pub/sub (`d/signal.d`)

`d/signal.d` — сигналы/слоты **без Qt и DLL**, чистый D.
Используются для внутренней логики приложения: Model/View, EventBus, pub/sub.
Не требуют `LoadQt()`.

**Три типа из модуля:**

| Тип | Описание | Применение |
|-----|---------|-----------|
| `Signal!Args` | Многоадресный D-делегат | Основное — любые D-объекты |
| `ESignal!Args` | Многоадресный C-callback (`void*` + fn) | Интеграция с C-кодом / Qt-виджетами |
| `CSlot!Args` | Одиночный C-callback с контекстом | Хранение одного слота |

**Базовое использование:**

```d
import signal;

Signal!int             onValueChanged;
Signal!(string, int)   onError;
Signal!()              onShutdown;   // без параметров

// Подключение (D-делегат):
onValueChanged.connect((int n) { writeln("value: ", n); });

// Публикация:
onValueChanged.emit(42);   // или: onValueChanged(42)

// Отключение — сохраняйте делегат в переменную!
auto h = (int n) { ... };
onValueChanged.connect(h);
onValueChanged.disconnect(h);   // найдёт по funcptr + context
onValueChanged.clear();         // отключить всех

// Свойства:
writeln(onValueChanged.length);  // кол-во подписчиков
writeln(onValueChanged.empty);   // true если нет подписчиков
```

**ESignal и CSlot (C-совместимые callback):**

```d
// ESignal: несколько C-callback
ESignal!int onTick;
onTick.connect(myObj, &on_tick_fn);   // (void* ctx, int n)
onTick.emit(1);
onTick.disconnect(myObj, &on_tick_fn);

// CSlot: один C-callback
CSlot!int mySlot;
mySlot.fn  = &my_fn;            // void function(void*, int)
mySlot.ctx = cast(void*)myObj;
mySlot.call(42);
writeln(mySlot.empty);          // true если fn == null

// Мост: C-callback → D-делегат
auto dslot = slot(myObj, &my_fn);
onValueChanged.connect(dslot);
```

**Паттерн one-shot (самоотключение):**

```d
void delegate(string) h;
h = (string s) {
    process(s);
    onData.disconnect(h);  // отключается после первого вызова
};
onData.connect(h);
```

**Паттерн слабой подписки:**

```d
bool alive = true;
onData.connect(weakSlot(&alive, (string s) { process(s); }));
// ...
alive = false;   // обработчик перестаёт реагировать
```

**Паттерн EventBus:**

```d
class AppEvents {
    Signal!string        onUserLogin;
    Signal!string        onUserLogout;
    Signal!(string, int) onError;
    Signal!()            onShutdown;
}
__gshared AppEvents bus;

// В модуле A:
bus.onUserLogin.connect((string name) { log("LOGIN: " ~ name); });

// В модуле B:
bus.onUserLogin.emit("Alice");
```

**Важно**: inline-лямбда создаёт новый объект каждый раз — для `disconnect`
сохраняйте делегат в переменную. Несколько одинаковых `.connect(h)` добавят
один и тот же слот дважды; `.disconnectAll(h)` удалит все вхождения.

**Тест**: `test/test_signal.d` — 153 проверки, 17 блоков (pub/sub паттерны).
**Подробное руководство**: `doc/signal_guide.html`

---

## 6. СОБЫТИЯ (Event Handlers)

```d
// Мышь:
extern(C) void on_mouse(void* dthis, int x, int y, int button) {}
win.onMousePress(cast(void*)&on_mouse);
win.onMouseRelease(cast(void*)&on_mouse);
win.onMouseMove(cast(void*)&on_mouse);

// Клавиатура:
extern(C) void on_key(void* dthis, int key, int modifiers) {}
win.onKeyPress(cast(void*)&on_key);
win.onKeyRelease(cast(void*)&on_key);

// Геометрия:
extern(C) void on_resize(void* dthis, int w, int h) {}
win.onResize(cast(void*)&on_resize);

// Закрытие (можно отменить):
extern(C) void on_close(void* dthis, int* accept) {
    *accept = 1;  // 1=принять закрытие, 0=отменить
}
win.onClose(cast(void*)&on_close);

// Рисование (переопределение paintEvent):
extern(C) void on_paint(void* dthis, void* widget_ptr) {
    auto p = new QPainter(widget_ptr, true);  // true = auto-begin
    p.fillRect(0, 0, 100, 100, 7);            // GlobalColor: 7=red
    p.end();                                  // ОБЯЗАТЕЛЬНО end()!
}
win.onPaint(cast(void*)&on_paint);
// onPaint срабатывает только после processEvents():
g_app.processEvents();
```

---

## 7. LAYOUTS

### 7.1 Typed API (рекомендуется)

Типизированные перегрузки вызывают `disown()` автоматически.
Виджеты принимают `QObject`, layouts принимают шаблон `(L)(...)`.

```d
import gen_qlayout;

auto vbox = new QVBoxLayout();

// addWidget(QObject) — disown() автоматически
vbox.addWidget(label);
vbox.addWidget(button);
vbox.addStretch(1);

// addLayout(layout) — шаблон, работает с любым типом layout
auto hbox = new QHBoxLayout();
hbox.addWidget(btn1);
hbox.addWidget(btn2);
vbox.addLayout(hbox);   // hbox.disown() НЕ нужен

// setLayout(layout) — disown() автоматически
win.setLayout(vbox);    // vbox.disown() НЕ нужен

// Grid layout — typed addWidget:
auto grid = new QGridLayout();
grid.addWidget(lbl, 0, 0);
grid.addWidget(edit, 0, 1);
grid.addWidget(span_lbl, 1, 0, 1, 2);   // rowSpan=1, colSpan=2
win2.setLayout(grid);

// Form layout — typed addRow:
auto form = new QFormLayout();
form.addRow("Name:", edit);
form.insertRow(0, "First:", firstEdit);
form.removeRow(1);
win3.setLayout(form);
```

### 7.2 Void* API (обратная совместимость)

```d
auto vbox = new QVBoxLayout();
vbox.addWidget(label.getWH());
vbox.addWidget(button.getWH());
vbox.addStretch(1);

win.setLayout(vbox.getWH());
vbox.disown();              // ОБЯЗАТЕЛЬНО после setLayout!

// Вложенный:
auto hbox = new QHBoxLayout();
hbox.addWidget(btn1.getWH());
hbox.addWidget(btn2.getWH());
vbox.addLayout(hbox.getWH());
hbox.disown();              // ОБЯЗАТЕЛЬНО после addLayout!

// Grid layout:
auto grid = new QGridLayout();
grid.addWidget(lbl.getWH(), 0, 0);
grid.addWidget(edit.getWH(), 0, 1);
grid.setRowStretch(0, 1);
grid.setColumnStretch(1, 2);

// Form layout:
auto form = new QFormLayout();
form.addRow("Name:", edit.getWH());
form.insertRow(0, "First:", firstEdit.getWH());
form.removeRow(1);

win.setLayout(form.getWH());
form.disown();

// Layout extensions (индексы 629–642):
vbox.removeWidget(someWidget.getWH());      // убрать виджет из layout
vbox.insertWidget(0, newWidget.getWH(), 1); // вставить на позицию (void* версия)
vbox.addSpacing(10);                        // добавить отступ
vbox.setStretch(0, 2);                      // растяжение i-го элемента
int s = vbox.stretchAt(0);                 // получить растяжение
bool activated = vbox.activate();          // вернуть true если layout обновился
```

---

## 8. VALUE TYPES (QColor, QFont, QPixmap, QImage, QPainter)

Эти классы **не наследуют QWidget/QObject**, не имеют parent.
D всегда владеет и удаляет их через ~this().

```d
// QColor:
auto c1 = new QColor();               // invalid color
auto c2 = QColor.fromRgb(255, 0, 0); // static factory → RGB(255,0,0)
auto c3 = QColor.fromRgba(0xFF0000FF); // from packed RGBA
auto c4 = QColor.wrap(returned_ptr);  // D берёт ownership над C++ объектом

// QFont:
auto f = new QFont("Arial");
f.setPointSize(12);
auto f2 = new QFont("Courier New");
f2.setPointSize(10); f2.setBold(true);   // bold
f.setPointSize(14);
f.setBold(true);

// QPixmap:
auto px = new QPixmap(100, 100);
px.fill(255, 0, 0);  // красный (r, g, b, a=255)
label.setPixmap(px.getWH());  // передать QLabel

// QImage:
auto img = new QImage(200, 200, 5);   // Format_ARGB32=5

// QPainter — только внутри onPaint callback:
extern(C) void on_paint(void* dthis, void* widget_ptr) {
    auto p = new QPainter(widget_ptr, true);  // true = begin() автоматически
    p.setPen(7);                               // QPen по GlobalColor
    p.setBrush(4);                             // QBrush по GlobalColor
    p.drawRect(10, 10, 80, 80);
    p.drawEllipse(20, 20, 60, 60);
    p.drawText(30, 55, "Hello");
    p.end();                                   // ОБЯЗАТЕЛЬНО перед выходом!
}
```

---

## 9. QPen, QBrush, QPalette, QFontMetrics (qte56_drawing.dll)

```d
import gen_qpen;        // QPen
import gen_qbrush;      // QBrush
import gen_qpalette;    // QPalette
import gen_qfontmetrics; // QFontMetrics

// QPen:
auto pen = new QPen();
pen.setColor(QColor.fromRgb(0,0,255).getPtr());  // синий
pen.setWidth(2);
pen.setStyle(cast(int)PenStyle.DashLine);
pen.setCapStyle(cast(int)PenCapStyle.RoundCap);
// Передать в QPainter:
painter.setPen(pen.getPtr());           // overload для QPen*

// QBrush:
auto brush = new QBrush();
brush.setColor(QColor.fromRgb(255,255,0).getPtr());
brush.setStyle(1);   // SolidPattern
painter.setBrush(brush.getPtr());

// QPalette:
auto pal = new QPalette();
pal.setColor(cast(int)ColorGroup.Active, cast(int)ColorRole.Window,
             QColor.fromRgb(30,30,30).getPtr());
widget.setPalette(pal.getPtr());

// QFontMetrics:
auto fm = new QFontMetrics(font.getPtr());
int w = fm.horizontalAdvance("Hello");
int h = fm.height();
int asc = fm.ascent();
```

---

## 10. QSplashScreen и QSystemTrayIcon (qte56_systray.dll)

```d
import gen_qsplashscreen;
import gen_qsystemtrayicon;
import qte56_enums;  // TrayActivationReason, TrayMessageIcon

// QSplashScreen:
auto px = new QPixmap(400, 200);
px.fill(0x00, 0x33, 0x66);
auto splash = new QSplashScreen(px.getWH());
splash.show();
splash.showMessage("Loading...", 0x44, 0xFFFFFFFF); // align=AlignHCenter|AlignBottom, white
g_app.processEvents();
// ... инициализация ...
splash.finish(mainWin.getWH());  // скрыть splash когда mainWin готово

// QSystemTrayIcon:
auto tray = new QSystemTrayIcon();
auto icon = new QIcon("icon.png");
tray.setIcon(icon.getPtr());  // NB: getPtr(), не getWH()!
tray.setToolTip("My Application");
tray.show();

// Показать balloon message:
tray.showMessage("Title", "Body", cast(int)TrayMessageIcon.Information, 3000);

// Контекстное меню:
auto menu = new QMenu(null);
auto actQuit = menu.addAction("Quit");
tray.setContextMenu(menu.getWH());
// menu и tray — D владеет, уничтожить вручную или через parent

// Сигнал activated:
extern(C) void on_tray_activated(int reason) {
    if (reason == cast(int)TrayActivationReason.DoubleClick)
        writeln("Double clicked!");
}
tray.connect_activated(cast(void*)&on_tray_activated);

// Геометрия иконки на экране:
int tx, ty, tw, th;
tray.geometry(tx, ty, tw, th);

// Проверить поддержку сообщений:
bool supported = QSystemTrayIcon.supportsMessages() != 0;
```

---

## 11. Qt Resource System (qte56_resource.dll)

```d
import qte56_resource;  // registerRcc, readResourceText, applyQssRes, ...

// Зарегистрировать .rcc файл (собранный через: rcc --binary -o app.rcc app.qrc):
registerRcc("app.rcc");

// Теперь работают ресурсные пути:
bool exists = resourceExists(":/images/logo.png");
string text = readResourceText(":/styles/dark.qss");
auto bytes  = readResourceBytes(":/data/config.json");

// Применить QSS стиль из ресурса (app — QApplication):
applyQssRes(app, ":/styles/dark.qss");
// или к одному виджету: applyQssResWidget(win, ":/styles/dark.qss");

// QPixmap из ресурса (автоматически если зарегистрировано):
auto px = new QPixmap(0, 0);
// ... px.load(":/images/logo.png") ...
```

---

## 12. Qt Designer Forms (qte56_uiloader.dll)

```d
import qte56_forms;  // QForm, findLabel, findButton, findWidget, ...

// Загрузить .ui файл (load — статический, возвращает QForm):
auto form = QForm.load("test/ui/my_dialog.ui", null);  // parent=null → top-level
form.show();
form.resize(400, 300);
form.setWindowTitle("My Dialog");

// Найти виджеты по objectName:
auto lbl  = form.findLabel("labelStatus");
auto btn  = form.findButton("btnOK");
auto edit = form.findLineEdit("editName");
auto combo = form.findComboBox("comboMode");

// Подключить сигнал:
auto sl = new ESlot(form.asWidget().getWH());
sl.set(cast(void*)&on_ok_click);
btn.connect_clicked(sl);
```

---

## 13. QSql (база данных, qte56_sql.dll)

```d
import gen_qsql;

// Открытие:
auto db = QSqlDatabase.openSqlite("mydb.sqlite");  // файл SQLite
auto db = QSqlDatabase.openMemory();               // в памяти
// Полный ctor: new QSqlDatabase(driver, dbName, host, port, user, pass)

// DDL / DML:
auto q = new QSqlQuery(db);
q.exec("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, score REAL)");

// Prepared statement:
q.prepare("INSERT INTO users (name, score) VALUES (?, ?)");
q.bindString(0, "Alice");
q.bindDouble(1, 95.5);
q.execPrepared();
long id = q.lastInsertId();

// SELECT:
q.exec("SELECT id, name, score FROM users ORDER BY score DESC");
while (q.next()) {
    int    uid   = q.valueInt(0);
    string name  = q.valueString(1);
    double score = q.valueDouble(2);
    bool   isNul = q.isNull(2);
}

// Транзакции:
db.transaction();
q.exec("DELETE FROM users WHERE score < 50");
db.commit();  // или db.rollback();

// Deploy: поместить dll/sqldrivers/qsqlite.dll рядом с exe (Windows)
//         ldd убедится что sqlite3 найден (Linux)
```

---

## 14. QStyle и QSS (qte56_style.d)

```d
import qte56_style;

// Применить QSS ко всему приложению (app — QApplication):
applyQss(app, "test/qss/dark.qss");

// Применить к одному виджету:
applyQssWidget(win, "test/qss/custom.qss");

// Применить несколько файлов (объединяются):
applyQssFiles(app, ["test/qss/base.qss", "test/qss/dark.qss"]);

// Тема (движок + файлы + инлайн-CSS):
QssTheme theme = { style: "Fusion", files: ["base.qss", "dark.qss"] };
theme.apply(app);

// Из ресурса (требует registerRcc):
applyQssRes(app, ":/styles/dark.qss");
```

---

## 15. QProcess (qte56_qprocess.dll, индексы 19816–19836)

```d
import gen_qprocess;

// Синхронный запуск:
auto proc = new QProcess();              // ctor без аргументов!
proc.start("git", ["log", "--oneline", "-10"]);
bool ok = proc.waitForFinished(5000) != 0;   // таймаут мс, -1 = бесконечно
int code = proc.exitCode();
string out_ = proc.readStdoutText();     // ubyte[] → readAllStdout()/readAllStderr()
string err_ = proc.readStderrText();

// Асинхронный запуск (прямой C-callback, нужен event loop):
auto proc2 = new QProcess();
extern(C) static void on_proc_finish(int exitCode, int exitStatus) {
    writefln("exit: %d status: %d", exitCode, exitStatus);
}
proc2.connect_finished(cast(void*)&on_proc_finish);
proc2.start("python", ["script.py"]);

// Передача stdin:
proc.writeText("input data\n");
proc.closeWriteChannel();

// Ошибки запуска: QProcess.FailedToStart == 0!
if (proc.error() == 0 && !ok)
    writeln("Не удалось запустить процесс");

// Переменные окружения:
proc.setWorkingDirectory("C:/work");
// proc.setEnv через QProcessEnvironment — см. gen_qprocess.d
```

**Gotcha**: `QProcess::FailedToStart == 0` (не 1!). При `error()==0` процесс не запустился.

---

## 15a. QDate, QTime, QDateTime (qte56_foundation.dll, индексы 19885–19968)

```d
import gen_qdate;       // QDate (19885–19911), QTime (19912–19933), QDateTime (19934–19968)
// Все три класса в одном файле; registerModule использует имя "QDate" для всех трёх —
// это важно! generateFunQt вызовы для QTime/QDateTime тоже регистрируются под "QDate".

// QDate:
auto d = new QDate(2026, 3, 20);          // год, месяц, день
auto d2 = QDate.currentDate();            // сегодня
int y = d.year(); int m = d.month(); int day = d.day();
auto d3 = d.addDays(7);                   // +7 дней
auto d4 = d.addMonths(1);
auto d5 = d.addYears(1);
int diff = d.daysTo(d2);                  // кол-во дней между датами
string s = d.toString("yyyy-MM-dd");      // форматирование
auto d6 = QDate.fromString("2026-01-01", "yyyy-MM-dd");
bool valid = d.isValid();

// QTime:
auto t = new QTime(14, 30, 0);            // час, мин, сек
auto t2 = QTime.currentTime();
int h = t.hour(); int min = t.minute(); int sec = t.second();
auto t3 = t.addSecs(3600);               // +1 час
int diff2 = t.secsTo(t2);
string ts = t.toString("HH:mm:ss");

// QDateTime:
auto dt = new QDateTime(d, t);            // из QDate + QTime
auto dt2 = QDateTime.currentDateTime();
auto dt3 = dt.addDays(1);
auto dt4 = dt.addSecs(3600);
long epoch = dt.toMSecsSinceEpoch();      // Unix timestamp × 1000
auto dt5 = QDateTime.fromMSecsSinceEpoch(epoch);
string dts = dt.toString("yyyy-MM-dd HH:mm:ss");
auto dt6 = QDateTime.fromString("2026-01-01 12:00:00", "yyyy-MM-dd HH:mm:ss");
bool ok = dt6.isValid();

// Передача в QDateTimeEdit:
dte.setDate(d.year(), d.month(), d.day());     // или через setDateTime
```

**Gotcha**: все три класса (QDate, QTime, QDateTime) — value types, D владеет, удаляет через ~this().

---

## 15b. QByteArray (qte56_foundation.dll, индексы 19969–19998)

```d
import gen_qbytearray;

// Создание:
auto ba = new QByteArray();
auto ba2 = new QByteArray("hello");           // из ASCII строки
auto ba3 = new QByteArray(100);               // 100 байт, заполнен \0

// Основные операции:
int sz = ba.size();
ba.append("world");
ba.prepend("!!");
ba.clear();

// Байтовый доступ:
ubyte b = ba.at(0);
ba.setByte(0, 65);   // 'A'

// Конвертация:
string s = ba.toHex();             // "48656c6c6f"
string b64 = ba.toBase64();
auto ba4 = QByteArray.fromBase64(b64);
auto ba5 = QByteArray.fromHex("deadbeef");

// Сравнение:
bool eq = ba.equals(ba2);
bool isNull = ba.isNull();
bool isEmpty = ba.isEmpty();

// Slicing:
auto sub = ba.mid(2, 5);          // 5 байт с позиции 2
auto left3 = ba.left(3);
auto right3 = ba.right(3);

// Работа с QSettings (getBytes/setBytes — уже в gen_qsettings.d):
settings.setBytes("key", myByteArray);   // setBytes(key, QByteArray*)
auto data = settings.getBytes("key");    // возвращает D string с байтами
```

---

## 15c. QScintilla (qte56_qscintilla.dll, индексы 19700–19747, 20003–20004)

```d
import gen_qscintilla;

// Создание (QsciScintilla наследует QAbstractScrollArea):
auto sci = new QsciScintilla(parent.getWH());

// Лексеры для подсветки синтаксиса:
// Встроенный (указывается числом): D(0), C++(1), Python(2), и т.д.
sci.setLexerByType(0);     // D-код (встроенный)

// Объектные лексеры (создаются один раз, устанавливаются через setLexer):
void* lexD    = QsciScintilla.createLexerD();      // встроенный alias: D лексер
void* lexBash = QsciScintilla.createLexerBash();   // индекс 20003
void* lexBat  = QsciScintilla.createLexerBatch();  // индекс 20004
sci.setLexer(lexD);         // установить объектный лексер
sci.deleteLexer(lexD);      // удалить когда больше не нужен

// Редактирование:
sci.setText("void main() {}");
string txt = sci.text();
sci.append("\n// comment");
sci.clear();
sci.setReadOnly(true);

// Позиция и выделение:
sci.setCursorPosition(0, 0);
sci.selectAll();
string sel = sci.selectedText();
sci.copy(); sci.cut(); sci.paste();

// Шрифт:
sci.setFont("Courier New", 10);

// Поля и разметка:
sci.setMarginWidth(0, 40);    // номера строк
sci.setMarginsFont("Courier New", 9);

// Автодополнение:
sci.setAutoCompletionSource(1);    // AcsAPIs
sci.setAutoCompletionThreshold(2);
// ... см. полный API в gen_qscintilla.d

// QsciAPIs для подсказок:
auto api = new QsciAPIs(sci.getWH());
api.add("QWidget");
api.add("QLabel");
api.prepare();

// Два DLL нужны в PATH: qte56_qscintilla.dll + qscintilla2_qt5.dll
```

---

## 15d. Wren Scripting (wren/d/wren_vm.d)

```d
import wren_vm;   // файл: wren/d/wren_vm.d (НЕ d/wren_vm.d!)

LoadWren();  // загрузить libwren_bridge.so / wren_bridge.dll
auto vm = new WrenVM();

// Выполнить Wren код:
vm.exec("main", `System.print("Hello from Wren!")`);

// Загрузить файл:
vm.loadFile("scripts/game.wren");

// Вызов метода Wren из D:
vm.callBegin("main", "MyClass", "myMethod(_)");
vm.callSetString(0, "hello");
vm.callEnd();
string result = vm.getResultString();

UnloadWren();
```

---

## 15e. Чистые D-модули (без Qt, без DLL)

Эти файлы не требуют `LoadQt()`, Qt DLL и Qt-зависимостей.
Компилируются вместе с исходником обычным образом.

| Файл | Что даёт | Тест |
|------|---------|------|
| `d/signal.d` | `Signal!T`, `ESignal!T`, `CSlot!T`, `slot()` — pub/sub без Qt | `test/test_signal.d` (153 check) |
| `d/json.d` | `JsonValue`, `parseJson`, `toJsonPretty`, `get!T`, `opIndex` | `test/test_json.d` (85 check) |
| `d/net_utils.d` | `httpGet`, `httpPost`, `httpGetBytes` (sync, Qt events) | `test/test_net_utils.d` |
| `d/curl_utils.d` | `CurlSession` fluent API — HTTP/HTTPS/FTP через libcurl | `test/test_curl.d` (43 check) |

### d/signal.d — быстрый старт

```d
import signal;           // d/signal.d — без Qt, без DLL

// Компиляция:
// dmd -m32 myapp.d d/signal.d -I. -Id -of=myapp.exe
// ldc2        myapp.d d/signal.d -I. -Id -of=myapp

Signal!string onMessage;

onMessage.connect((string s) { writeln("Got: ", s); });
onMessage.emit("Hello");   // → "Got: Hello"
```

Подробнее — в разделе **5.5** и в `doc/signal_guide.html`.

### d/json.d — быстрый старт

```d
import json;   // d/json.d — чистый D JSON, без Qt

auto v = parseJson(`{"name":"Alice","age":30}`);
writeln(v["name"].get!string);     // Alice
writeln(v["age"].get!int);         // 30

// Создание:
auto obj = jobject(["x": jvalue(1), "y": jvalue(2)]);
writeln(toJsonCompact(obj));       // {"x":1,"y":2}
```

---

## 15f. QThread и QMutex (qte56_thread.dll, индексы 20073–20095)

DLL: `qte56_thread.dll` | Модуль: `d/gen/gen_qthread.d`

### Быстрый старт

```d
import gen_qthread;
import core.atomic;

__gshared int g_result = 0;

auto t = new QThread({
    // Любой D-код в отдельном потоке. GUI не трогать!
    atomicStore(g_result, heavyComputation());
});

t.connect_finished({
    // Вызывается в главном потоке через Qt event queue
    writeln("Готово: ", atomicLoad(g_result));
    app.quit();
});

t.start();
app.exec();   // ждём сигнала finished → quit
```

### API QThread

| Метод | Описание |
|-------|----------|
| `new QThread(void delegate())` | Создать поток с рабочей функцией |
| `start()` | Запустить поток |
| `wait()` | Ждать завершения (без таймаута) |
| `wait(msec)` | Ждать с таймаутом; 1=завершился, 0=таймаут |
| `isRunning()` | 1 если поток выполняется |
| `isFinished()` | 1 если поток завершён |
| `requestInterruption()` | Установить флаг отмены |
| `isInterruptionRequested()` | Проверить флаг отмены (из рабочего потока) |
| `setPriority(int)` | 0=Idle..6=TimeCritical |
| `connect_started(cb)` | Сигнал: поток начал выполнение |
| `connect_finished(cb)` | Сигнал: поток завершился |
| `QThread.msleep(ms)` | Приостановить текущий поток (static) |
| `QThread.usleep(us)` | То же в микросекундах (static) |
| `QThread.idealThreadCount()` | Число логических CPU (static) |
| `moveToThread(objWH)` | Переместить QObject в поток |

### API QMutex

```d
auto m = new QMutex();

m.lock();
scope(exit) m.unlock();   // паттерн: автоснятие
sharedData ~= "item";
```

| Метод | Описание |
|-------|----------|
| `lock()` | Захватить (блокирует до получения) |
| `unlock()` | Освободить |
| `tryLock()` | Попытка без блокировки; 1=успех |
| `tryLock(msec)` | С таймаутом; 1=захвачен |

### Паттерн: кооперативная отмена

```d
__gshared bool g_stop = false;

auto t = new QThread({
    for (int i = 0; i < 100_000; i++) {
        if (atomicLoad(g_stop)) return;
        doStep(i);
    }
});
t.start();
// Из главного потока:
atomicStore(g_stop, true);
t.wait(5000);
```

### Паттерн: несколько потоков с фабрикой

```d
// ПРАВИЛЬНО: idx передаётся как параметр (не захват по ссылке)
QThread makeWorker(int idx) {
    return new QThread({
        g_vals[idx] = idx * idx;
    });
}

foreach (i; 0 .. N) {
    threads[i] = makeWorker(i);
    threads[i].start();
}
```

### Важно

- Сигналы `connect_started/finished` — QueuedConnection. Требуют `processEvents()` или `exec()`.
- Перед `app.deleteApp()` вызвать `import core.memory : GC; GC.collect()`.
- Не обращаться к GUI-виджетам из рабочего потока.
- Захват переменной цикла в замыкании — всегда через фабричную функцию.

Тест: `test/test_qthread.d` (35/35). Руководство: `doc/qthread_guide.html`.

---

## 15g. Примитивы синхронизации (qte56_thread.dll, индексы 20096–20117)

Все три класса в `d/gen/gen_qthread.d` и `qte56_thread.dll`.

### QWaitCondition (20096–20101)

Условная переменная. Поток блокируется до сигнала от другого потока.
**Всегда** используется совместно с QMutex. Spurious wakeup возможен — проверяйте условие в `while`.

```d
__gshared QMutex         g_m  = new QMutex();
__gshared QWaitCondition g_cv = new QWaitCondition();
__gshared int[]          g_queue;

// Producer:
auto producer = new QThread({
    foreach (v; 1 .. 11) {
        g_m.lock();
        g_queue ~= v;
        g_cv.wakeOne();
        g_m.unlock();
        QThread.msleep(10);
    }
    g_m.lock(); g_queue ~= -1; g_cv.wakeOne(); g_m.unlock();
});

// Consumer:
auto consumer = new QThread({
    while (true) {
        g_m.lock();
        while (g_queue.length == 0)
            g_cv.wait(g_m);        // unlock + block → при пробуждении: lock
        int v = g_queue[0];
        g_queue = g_queue[1..$];
        g_m.unlock();
        if (v < 0) break;
        process(v);
    }
});
```

| Метод | Описание |
|-------|----------|
| `wait(mutex)` | Ждать пробуждения (без таймаута) |
| `wait(mutex, msec)` | С таймаутом; 1=пробуждён, 0=таймаут |
| `wakeOne()` | Разбудить один ожидающий поток |
| `wakeAll()` | Разбудить все ожидающие |

### QSemaphore (20102–20108)

Счётчик ресурсов. `acquire(n)` уменьшает (блокирует если < n). `release(n)` увеличивает.

```d
// Не более 3 одновременных потоков:
auto sem = new QSemaphore(3);

auto t = new QThread({
    sem.acquire(1);
    scope(exit) sem.release(1);
    heavyWork();
});
```

| Метод | Описание |
|-------|----------|
| `new QSemaphore(n)` | Создать с начальным счётчиком n |
| `acquire(n=1)` | Захватить n (блокирует если < n) |
| `tryAcquire(n=1)` | Без блокировки; 1=успех |
| `tryAcquire(n, msec)` | С таймаутом; 1=успех |
| `release(n=1)` | Освободить n единиц |
| `available()` | Текущий счётчик |

### QReadWriteLock (20109–20117)

Множество читателей ИЛИ один писатель. Оптимален при частом чтении и редкой записи.

```d
auto rw = new QReadWriteLock();
__gshared string[] g_data;

// Читатель (несколько параллельно):
rw.lockForRead();
scope(exit) rw.unlock();
auto snapshot = g_data.dup;

// Писатель (эксклюзивно):
rw.lockForWrite();
scope(exit) rw.unlock();
g_data ~= "new item";
```

| Метод | Описание |
|-------|----------|
| `lockForRead()` | Захватить для чтения (совместно с другими читателями) |
| `lockForWrite()` | Захватить для записи (эксклюзивно) |
| `tryLockForRead()` / `tryLockForRead(ms)` | Без блокировки / с таймаутом |
| `tryLockForWrite()` / `tryLockForWrite(ms)` | Без блокировки / с таймаутом |
| `unlock()` | Освободить (после read или write) |

Тест: `test/test_sync.d` (35/35).

---

## 15h. QCompleter (qte56_completer.dll, индексы 20118–20131)

Автодополнение для `QLineEdit` и `QComboBox`.

DLL: `qte56_completer.dll` | Модуль: `d/gen/gen_qcompleter.d`

### Быстрый старт

```d
import gen_qcompleter;

auto c = new QCompleter(["Alice", "Bob", "Charlie", "Dave"]);
c.setCaseSensitivity(0);                        // 0 = без учёта регистра
c.setCompletionMode(CompletionMode.PopupCompletion);
c.setMaxVisibleItems(8);
c.attachTo(myLineEdit.getWH());

c.connect_activated((string chosen) {
    writeln("Выбрано: ", chosen);
});
```

### API

| Метод | Описание |
|-------|----------|
| `new QCompleter()` | Пустой комплитер |
| `new QCompleter(string[])` | Со списком строк |
| `attachTo(widgetWH)` | Прикрепить к QLineEdit |
| `attachToCombo(comboWH)` | Прикрепить к QComboBox |
| `setCompletionMode(mode)` | 0=Popup, 1=UnfilteredPopup, 2=Inline |
| `setCaseSensitivity(cs)` | 0=CaseInsensitive, 1=CaseSensitive |
| `setMaxVisibleItems(n)` | Макс. строк в popup |
| `setPrefix(str)` | Задать фильтр вручную |
| `completionCount()` | Число совпадений для текущего префикса |
| `currentCompletion()` | Первый совпадающий вариант (string) |
| `complete()` | Показать popup принудительно |
| `setModel(string[])` | Обновить список без пересоздания объекта |
| `connect_activated(cb)` | Сигнал выбора: `void delegate(string)` |

### Enum CompletionMode

```d
enum CompletionMode : int {
    PopupCompletion           = 0,  // всплывающий список (по умолчанию)
    UnfilteredPopupCompletion = 1,  // всплывающий без фильтрации
    InlineCompletion          = 2,  // дополнение в строке ввода
}
```

### Важно

- После `attachTo()` Qt берёт ownership. Не вызывать `destroy()` вручную.
- Один объект QCompleter — один виджет. Для нескольких полей — отдельные объекты.
- `connect_activated` срабатывает при явном выборе (клик или Enter).

Тест: `test/test_qcompleter.d` (35/35). GUI-демо: `test/gui_qcompleter.d`.

---

## 15i. QShortcut (qte56_shortcut.dll, индексы 20132–20168)

Клавиатурный шорткат, привязанный к виджету. Не требует QAction или QMenu.

### Быстрый старт

```d
import gen_qshortcut;

// Ctrl+S — сохранить
auto scSave = new QShortcut(win.getWH(), "Ctrl+S");
scSave.connect_activated({ save(); });

// F5 — обновить, только в пределах окна
auto scRefresh = new QShortcut(win.getWH(), "F5");
scRefresh.setContext(ShortcutContext.Window);
scRefresh.connect_activated({ refresh(); });

// Временно отключить
scSave.setEnabled(false);
// ...
scSave.setEnabled(true);

// Ранняя очистка (если нужно до уничтожения родителя)
scSave.free();
```

### API

| Метод | Описание |
|-------|----------|
| `new QShortcut(parentWH, key)` | Создать шорткат. `key` — строка QKeySequence: `"Ctrl+S"`, `"F5"`, `"Shift+F3"` |
| `setEnabled(bool)` | Включить / выключить шорткат |
| `isEnabled()` | Проверить: включён? |
| `setContext(ShortcutContext)` | Задать область срабатывания |
| `context()` | Текущая область срабатывания |
| `setAutoRepeat(bool)` / `autoRepeat()` | Разрешить / проверить повтор при удержании клавиши |
| `setWhatsThis(string)` / `whatsThis()` | Текст справки "What's This" |
| `id()` | Внутренний идентификатор шортката |
| `connect_activated(void delegate())` | Подключить коллбэк без аргументов |
| `connect_activatedAmbiguously(void delegate())` | Коллбэк при неоднозначном шорткате |
| `free()` | Явно удалить Qt-объект до уничтожения родителя |
| `getWH()` | Внутренний указатель C++ |

### Enum ShortcutContext

| Константа | Значение | Описание |
|-----------|----------|----------|
| `Widget` | 0 | Только когда фокус на родительском виджете |
| `Window` | 1 | Любой виджет в том же окне **(по умолчанию)** |
| `Application` | 2 | Глобально в приложении |
| `WidgetWithChildren` | 3 | Виджет или его дочерние виджеты |

### Важно

- **QShortcut принадлежит родительскому виджету через Qt** — нет D-деструктора.
  При уничтожении родителя шорткат удаляется автоматически.
- **Для ранней очистки** (до уничтожения родителя) — вызывать `sc.free()`, не `destroy(sc)`.
- Можно подключить несколько коллбэков к одному шорткату — все будут вызваны.
- Поддерживаемые форматы ключа: `"Ctrl+S"`, `"F5"`, `"Shift+F3"`, `"Alt+Return"`,
  `"Ctrl+Shift+Z"` — любой формат QKeySequence.

Тест: `test/test_qshortcut.d` (25/25).

---

## 15j. QFileSystemWatcher (qte56_filewatcher.dll, индексы 20139–20148)

Наблюдение за изменениями файлов и директорий через механизм уведомлений ОС
(inotify на Linux, ReadDirectoryChangesW на Windows). Нулевая нагрузка на CPU
пока файлы не меняются — без polling.

### Быстрый старт

```d
import gen_qfilesystemwatcher;

auto watcher = new QFileSystemWatcher();

// Следить за файлом
watcher.addPath("config.ini");

// Следить за директорией (список файлов в ней)
watcher.addPath("./scripts/");

// Коллбэк при изменении файла
watcher.connect_fileChanged((string path) {
    import std.file : exists;
    if (exists(path)) {
        watcher.addPath(path);  // переподписаться (vim/emacs создают новый файл)
        reloadConfig(path);
    }
});

// Коллбэк при изменении состава директории
watcher.connect_directoryChanged((string dir) {
    rescanDir(dir);
});
```

### API

| Метод | Описание |
|-------|----------|
| `new QFileSystemWatcher()` | Создать пустой watcher |
| `addPath(string)` | Добавить файл или директорию. Возвращает `true` если ОС взяла под наблюдение |
| `addPaths(string[])` | Добавить несколько путей сразу |
| `removePath(string)` | Убрать из наблюдения |
| `removePaths(string[])` | Убрать несколько путей |
| `files()` | `string[]` — список наблюдаемых файлов |
| `directories()` | `string[]` — список наблюдаемых директорий |
| `connect_fileChanged(void delegate(string))` | Сигнал: файл изменён, переименован или удалён |
| `connect_directoryChanged(void delegate(string))` | Сигнал: в директории появился/исчез файл |
| `getWH()` | Внутренний указатель C++ |

### Паттерн: hot reload скрипта

```d
// wren_ide: открыл файл → сохранил в редакторе → IDE перезапустила скрипт
auto watcher = new QFileSystemWatcher();
watcher.addPath(currentFile);

watcher.connect_fileChanged((string path) {
    import std.file : exists;
    // Переподписка обязательна — редакторы часто удаляют и пересоздают файл
    if (exists(path)) watcher.addPath(path);
    runScript(path);
});
```

### Паттерн: слежение за папкой плагинов

```d
watcher.addPath("./plugins/");
watcher.connect_directoryChanged((_) {
    auto newList = dirEntries("./plugins/", "*.wren", SpanMode.shallow);
    reloadPlugins(newList);
});
```

### Важно

- **`fileChanged` после удаления** — watcher автоматически снимает наблюдение.
  Переподписаться: `watcher.addPath(path)` в коллбэке, если файл существует.
- **vim/emacs** при сохранении удаляют и пересоздают файл — переподписка обязательна.
- **Событие приходит через Qt event loop** — нужен `app.exec()` или `app.processEvents()`.
- **Явный `destroy(watcher)` перед `app.deleteApp()`** — иначе GC финализирует
  watcher после уничтожения QApplication → `InvalidMemoryOperationError`.
- `addPath` на несуществующий путь возвращает `false` — ошибки нет, просто не наблюдает.

Тест: `test/test_qfilesystemwatcher.d` (20/20).

---

## 16. ПОЛНЫЙ ПРИМЕР: Окно с кнопкой и счётчиком

```d
import std.stdio : writeln, writefln;
import std.conv  : to;

import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qlabel;
import gen_qpushbutton;
import gen_qlayout;

int g_count = 0;

// ОБЯЗАТЕЛЬНО extern(C) для всех callback-ов
extern(C) void on_click(void* dthis, int n, int checked) {
    g_count++;
    string txt = "Clicked: " ~ to!string(g_count);
    // dthis — указатель на QLabel (передан через slot.set)
    void* lbl_wh = dthis;
    auto qs = toQString(txt);
    (cast(t_v__qp_qp)pFunQt[825])(lbl_wh, qs);  // qteQLabel_setText(label, QString*)
    (cast(t_v__qp)pFunQt[22])(qs);               // qteQString_free
}

void main() {
    LoadQt("./dll");                         // 1. Загрузить DLL
    auto app = new QApplication("Demo");     // 2. QApplication

    auto win   = new QWidget(null);          // top-level: parent = null
    auto label = new QLabel("Click me!", win.getWH());
    auto btn   = new QPushButton("Click", win.getWH());

    auto layout = new QVBoxLayout();
    layout.addWidget(label.getWH());
    layout.addWidget(btn.getWH());
    win.setLayout(layout.getWH());
    layout.disown();                         // Qt владеет layout

    auto slot = new ESlot(win.getWH());      // parent = win
    slot.set(cast(void*)&on_click, label.getWH(), 0);  // dthis = label ptr
    btn.connect_clicked(slot);

    win.setWindowTitle("Demo");
    win.resize(300, 150);
    win.show();

    app.exec();          // 3. Event loop
    app.deleteApp();     // 4. Разрешить GC
    // UnloadQt() — НЕ вызывать!
}
```

---

## 17. КОМПИЛЯЦИЯ

### Windows (dmd -m32)

```bat
dmd -m32 ^
    myapp.d ^
    d/qte56_core.d ^
    d/qte56_loader.d ^
    d/qte56_enums.d ^
    d/gen/gen_qcore.d ^
    d/gen/gen_qwidget.d ^
    d/gen/gen_qlabel.d ^
    d/gen/gen_qpushbutton.d ^
    d/gen/gen_qlayout.d ^
    d/gen/gen_qframe.d ^
    d/gen/gen_qobject.d ^
    d/gen/gen_qabstractbutton.d ^
    -I. -Id -Id/gen ^
    -of=myapp.exe

set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
myapp.exe
```

### Linux (ldc2, 64-бит)

```bash
ldc2 \
    myapp.d \
    d/qte56_core.d \
    d/qte56_loader.d \
    d/qte56_enums.d \
    d/gen/gen_qcore.d \
    d/gen/gen_qwidget.d \
    d/gen/gen_qlabel.d \
    d/gen/gen_qpushbutton.d \
    d/gen/gen_qlayout.d \
    d/gen/gen_qframe.d \
    d/gen/gen_qobject.d \
    d/gen/gen_qabstractbutton.d \
    -I. -Id -Id/gen \
    -L-Wl,-rpath,'$ORIGIN/../lib' \
    -of=myapp

LD_LIBRARY_PATH=./lib ./myapp
```

### Авто-генерация скрипта компиляции

```bash
# Автоматически найти нужные gen_*.d по импортам и Q-классам в .d файле:
py generator/make_build.py test/myapp.d
py generator/make_build.py test/myapp.d --bat test/build_myapp.bat --sh test/build_myapp.sh
py generator/make_build.py test/myapp.d --bat build.bat --sh build.sh --out test/myapp
```

`make_build.py` также:
- Проверяет существование gen_*.d и extra d/ файлов на диске (предупреждения о пропущенных)
- Авто-определяет wren/d/wren_vm.d если в файле импортируется wren_vm
- `levels_up=0` для скриптов в корне arch_new, `levels_up=1` для test/ (cd к корню)
- Флаги: `-I. -Id -Id/gen` (все три нужны на обеих платформах)

### Зависимости по иерархии

| Класс | Нужные gen_*.d |
|-------|---------------|
| QLabel | gen_qlabel + gen_qframe + gen_qwidget + gen_qobject + gen_qcore |
| QPushButton | gen_qpushbutton + gen_qabstractbutton + gen_qwidget + gen_qobject + gen_qcore |
| QListWidget | gen_qlistwidget + gen_qabstractitemview + gen_qabstractscrollarea + gen_qframe + gen_qwidget + gen_qobject + gen_qcore |
| QTreeWidget | gen_qtreewidget + gen_qtreeview + gen_qabstractitemview + gen_qabstractscrollarea + gen_qframe + gen_qwidget + gen_qobject + gen_qcore |

---

## 18. DLL/SO структура

| Библиотека | Содержит | Индексы |
|-----------|---------|---------|
| `qte56_qcore.dll` | QApplication, ESlot, QString utils, QRect/Point/Size | 1–76 |
| `qte56_foundation.dll` | QObject, QWidget, QFrame, QAbstractButton, QAbstractScrollArea, +~10; QDate/QTime/QDateTime; QByteArray | 200–…; 19885–19998 |
| `qte56_widgets.dll` | QLabel, QPushButton, QLineEdit, QCheckBox, QComboBox, QLayout (600–642), +~22 | 200–642 |
| `qte56_views.dll` | QListWidget, QTreeWidget, QTableWidget, QHeaderView, QAbstractItemView, +~7 | 7000–9800 |
| `qte56_text.dll` | QTextEdit, QPlainTextEdit, QTextBrowser, QTextDocument, QSyntaxHighlighter, +~4 | 5000–19612 |
| `qte56_dialogs.dll` | QDialog, QMessageBox, QFileDialog, QColorDialog, QFontDialog, QInputDialog, QProgressDialog | 4600–15000 |
| `qte56_mainwin.dll` | QMainWindow, QMenuBar, QMenu, QAction, QToolBar, QStatusBar, QDockWidget, +~4 | 3800–6400 |
| `qte56_sql.dll` | QSqlDatabase, QSqlQuery | 19100–19132 |
| `qte56_drawing.dll` | QPen, QBrush, QPalette, QFontMetrics, QPainter extensions | 19748–19787 |
| `qte56_systray.dll` | QSplashScreen, QSystemTrayIcon | 19788–19809 |
| `qte56_resource.dll` | QResource (registerRcc, readResourceText, readResourceBytes) | 19810–19811 |
| `qte56_uiloader.dll` | QUiLoader (Qt Designer .ui files) | 19812–19815 |
| `qte56_qprocess.dll` | QProcess (запуск внешних процессов) | 19816–19836 |
| `qte56_qscintilla.dll` | QsciScintilla, QsciLexer*, QsciAPIs; LexerBash(20003), LexerBatch(20004) | 19700–19747; 20003–20004 |
| `qte56_tvision.dll` | Turbo Vision TUI (standalone, Qt не нужен) | 19850–19884 |
| `wren_bridge.dll` | Wren scripting VM | — |

**next free index: 24714** (24100–24102 заняты lifecycle-функциями QObject; макс. индекс 24713)

Linux: все `.dll` имена автоматически конвертируются в `lib*.so` через `soName()` в loader.
Windows: QImage_memio(19999–20000), QPixmap_memio(20001–20002) живут в qte56_widgets.dll
(расширения существующих классов, не отдельные DLL).

---

## 19. ИНСТРУМЕНТЫ РАЗРАБОТКИ

### make_build.py — генератор команд компиляции

```bash
# Анализирует .d файл, находит все Q-классы, строит команды компиляции:
py generator/make_build.py test/myapp.d

# Записать .bat и .sh:
py generator/make_build.py test/myapp.d --bat test/build_myapp.bat --sh test/build_myapp.sh --out test/myapp
```

### scan_ldc2_bugs.py — сканер совместимости DMD/ldc2

```bash
# Сканирует d/gen/gen_*.d на баги, которые ldc2 видит но DMD пропускает:
py generator/scan_ldc2_bugs.py
# Баг 1: super(true/false) без this(bool _noOp) у родителя
# Баг 2: несовпадение числа аргументов в cast функции
```

### build_merged_dlls.sh — сборка всех .so (Linux)

```bash
bash build_merged_dlls.sh           # собрать всё
bash build_merged_dlls.sh --verbose # с подробным выводом
bash build_merged_dlls.sh --no-wren # без Wren
```

### build_linux.sh — запуск консольных тестов

```bash
bash test/build_linux.sh                    # один тест (test_layouts_ext)
bash test/build_linux.sh test_qsql          # конкретный тест
bash test/build_linux.sh all                # все 34 теста
bash test/build_linux.sh all --no-run       # только сборка
```

---

## 20. LINUX: ОСОБЕННОСТИ

### Путь к библиотекам

`LoadQt("./dll")` автоматически переключается на `"./lib"` если `./dll` не существует.
Можно явно указать путь: `LoadQt("/usr/local/lib/qte56")`.

### ldc2 строже DMD

ldc2 запрещает:
- `this() {}` в классе, родитель которого не имеет no-arg ctor
- Неверное количество аргументов в function pointer cast

Исправление: использовать `protected this(bool _noOp) { super(_noOp); }` вместо `this() {}`.

### Компиляция одного теста

```bash
# Через make_build.py (рекомендуется):
py generator/make_build.py test/myapp.d --sh /tmp/build.sh && bash /tmp/build.sh

# Вручную:
ldc2 test/myapp.d d/qte56_core.d d/qte56_loader.d d/qte56_enums.d d/gen/*.d \
    -I. -Id -Id/gen -L-Wl,-rpath,'$ORIGIN/../lib' -of=test/myapp
LD_LIBRARY_PATH=./lib ./test/myapp
```

### Зависимости Fedora

```bash
sudo dnf install qt5-qtbase-devel qt5-qttools-devel gcc-c++ make ldc
sudo dnf install qt5-qtsql qt5-qtsql-devel    # для QSql
sudo dnf install qscintilla-qt5-devel          # для QScintilla
sudo dnf install qt5-designer                  # для QUiLoader
```

---

## 21. ЧЕКЛИСТ ПРИ НАПИСАНИИ ПРОГРАММЫ

**Старт:**
- [ ] `void main()`, не `extern(C) int main()` — иначе `static this()` не вызовутся
- [ ] `LoadQt("./dll")` — **до** `new QApplication()`
- [ ] `new QApplication()` — **сразу после** LoadQt

**Создание виджетов:**
- [ ] Top-level: `new QWidget(null)`, не `new QWidget()`
- [ ] Child: `new QLabel(parent.getWH())` — всегда передавать getWH()
- [ ] `new QAction(cast(void*)null)` — для QAction без parent

**Layout (typed API — рекомендуется):**
- [ ] Использовать `win.setLayout(layout)` — disown() вызывается автоматически
- [ ] Использовать `vbox.addWidget(w)` вместо `vbox.addWidget(w.getWH()); w.disown()`
- [ ] Использовать `vbox.addLayout(inner)` вместо `vbox.addLayout(inner.getWH()); inner.disown()`

**Layout (void* API — только если необходимо):**
- [ ] `layout.disown()` после каждого `win.setLayout(layout.getWH())`
- [ ] `hbox.disown()` после каждого `vbox.addLayout(hbox.getWH())`
- [ ] `w.disown()` после `vbox.addWidget(w.getWH())` если w создан с null-parent

**Items (Tree/Table/List):**
- [ ] `item.disown()` после ручного addTopLevelItem (типизированные overload — сами)

**Сигналы Qt (ESlot):**
- [ ] Все callback — `extern(C)`, иначе ABI несовместимость
- [ ] `new ESlot(widget.getWH())`, не `new ESlot(null)` — иначе утечка
- [ ] `cast(void*)&callback` при передаче в slot.set или connect_*

**Сигналы D (Signal!T):**
- [ ] Сохранить делегат в переменную перед `disconnect` (inline-лямбды не disconnectable)
- [ ] `one-shot`: в теле обработчика вызвать `signal.disconnect(h)` для одноразового срабатывания
- [ ] При захвате переменной цикла в замыкании — использовать фабричную функцию (D захватывает по ссылке)

**Строки:**
- [ ] D string → Qt: использовать `toQString(s)` → pass `void*` → free `pFunQt[22](qs)`
- [ ] Qt → D: вызвать `fromQString(qs)`, затем `pFunQt[22](qs)` для освобождения
- [ ] В ESlot callback с `void* qs`: **не** вызывать `pFunQt[22](qs)` — это ссылка

**Многопоточность (QThread):**
- [ ] Не трогать GUI-виджеты из рабочего потока — только из главного
- [ ] Переменные цикла в замыканиях — через фабричную функцию, не прямой захват
- [ ] `GC.collect()` перед `app.deleteApp()` при использовании QThread
- [ ] `scope(exit) mutex.unlock()` — всегда парный unlock после lock
- [ ] `while (!condition) cv.wait(m)` — not `if` — защита от spurious wakeup
- [ ] QCompleter: не вызывать `destroy()` после `attachTo()` — Qt берёт ownership

**QShortcut / QFileSystemWatcher:**
- [ ] QShortcut: не `destroy()` — использовать `sc.free()` для ранней очистки
- [ ] QFileSystemWatcher: явный `destroy(watcher)` перед `GC.collect()` / `app.deleteApp()`
- [ ] QFileSystemWatcher: переподписаться в `connect_fileChanged` если `exists(path)`

**Завершение:**
- [ ] `app.exec()` → `app.deleteApp()` — **НЕ вызывать UnloadQt()**
- [ ] Не удалять QClipboard.get()
- [ ] QPainter: всегда `p.end()` перед выходом из onPaint

**Linux:**
- [ ] Нет `-m32` (или убрать его из .sh)
- [ ] `ldc2` вместо `dmd` (или `dmd` без `-m32`)
- [ ] `LD_LIBRARY_PATH=./lib` при запуске (или rpath)
- [ ] Флаги: `-I. -Id -Id/gen` (все три, иначе d/*.d не найдены)

---

## 22. КРИТИЧЕСКИЕ GOTCHAS (собранные из практики)

| Ситуация | Проблема | Решение |
|----------|----------|---------|
| `UnloadQt()` вызван | Деструкторы GC-объектов обращаются к pFunQt[N]==null → segfault | Не вызывать UnloadQt(); OS сама выгрузит DLL |
| `void main()` заменён на `extern(C) int main()` | `static this()` модулей не выполнятся → registerModule не вызовется → pFunQt[N]==null | Только `void main()` |
| `LoadQt()` после `new QApplication()` | pFunQt[N]==null при вызовах Qt → краш | LoadQt всегда первый |
| `new QWidget()` без `null` | Двусмысленный overload → ошибка компиляции или неверный ctor | `new QWidget(null)` |
| `new QAction()` без `cast(void*)null` | D видит `null` как `string null` | `new QAction(cast(void*)null)` |
| `layout.disown()` не вызван (void* API) | D ~this удаляет C++ layout из-под Qt | disown() после setLayout/addLayout; или использовать typed API: `win.setLayout(layout)` |
| `w.disown()` не вызван после addWidget(w.getWH()) | D ~this удаляет виджет из-под layout | disown() вручную; или typed API: `vbox.addWidget(w)` |
| `item.disown()` не вызван (ручной addTopLevelItem) | D ~this удаляет item из-под tree | disown() (типизированные overload делают сами) |
| ESlot callback не `extern(C)` | ABI несовместимость (calling convention) → мусор в аргументах | Всегда `extern(C)` |
| `fromQString(qs)` в callback, затем `pFunQt[22](qs)` | free stack reference → heap corruption | В ESlot callback НЕ free-ить qs-аргументы |
| `QHeaderView` через `wrap` | QHeaderView.wrap устанавливает _qt_owned=true по умолчанию | Используйте `QHeaderView.wrap(ptr)` — D не удаляет |
| `QMdiSubWindow` через addSubWindow + onClose | onClose на eQMdiSubWindow crashit | `new QMdiSubWindow(mdi.getWH())` + `msw.setWidget(widget)` |
| `QScintilla` close crash (Linux) | Qt вызывает ~QsciScintilla через deleteChildren | В cbSubWinClose: `editor.setParent(null)` перед close |
| `QProcess.error() == 0` | FailedToStart == 0 (не 1!) | Проверять `!waitForStarted()` или error()==0 И статус |
| `gen_qdate.d` — registerModule для QTime/QDateTime | Надо использовать имя "QDate" для всех generateFunQt в файле | Одно registerModule имя на D-файл |
| `import scanner;` конфликт | `scanner.ClassInfo` vs `object.ClassInfo` из druntime | `import scanner;` + `alias SCI = scanner.ClassInfo` |
| `QsciScintilla` — два DLL | Нужны оба в PATH: qte56_qscintilla.dll + qscintilla2_qt5.dll | Оба DLL в ./dll/ |
| `wren_vm.d` путь | Файл в wren/d/, не в d/ | В build-скрипте: `wren/d/wren_vm.d` |
| Linux: `gen_qdatetimeedit.d` | ldc2: `this() {}` без no-arg ctor родителя | `this(bool _noOp) { super(_noOp); }` |
| `fromQString` и большие строки | Старый код: буфер 4096, обрезал большие QString | Новый код: динамическое удвоение (исправлено) |
| QStringList передача | Нет прямого маппинга QStringList→D | `toQStringList(arr)` / `freeQStringList(ptr)` через `\x01` разделитель |
| `QList<T*>` возврат | Сложно маппить void*[] | `ptrListFromQStr()` / `intListFromQStr()` через `|` разделитель (gen_qcore.d) |
| `__gshared` для глобалов | D GC не знает о статических ptr-ах → может collect | Все Qt-объекты-глобалы объявлять `__gshared` |
| Кириллица в .bat файлах | cmd.exe + UTF-8 рвёт многострочные if-блоки | ИЗБЕГАТЬ кириллицу и многострочные if в .bat |
| `dmd -m32` + user32.dll функции | Линкер не найдёт OpenClipboard и др. | Добавить `-L/DEFAULTLIB:user32` |
| QThread: `connect_finished` в рабочем потоке | Без context-объекта AutoConnection = DirectConnection → callback в worker thread, не в main | Использовать `QCoreApplication::instance()` как context (уже реализовано в DLL) |
| QThread: GC финализирует после deleteApp | D GC может финализировать QThread-объекты после уничтожения QApplication → Qt обращается к мёртвому qApp | `import core.memory : GC; GC.collect();` перед `app.deleteApp()` |
| QThread: захват переменной цикла | `foreach (i; 0..N) { new QThread({ use i }) }` — все потоки захватят последнее `i` | Фабричная функция: `QThread makeWorker(int idx) { return new QThread({ use idx }); }` |
| QWaitCondition: spurious wakeup | `wait()` может вернуть 1 без реального сигнала | Всегда проверять условие в `while`, не `if` |
| QCompleter: ownership после attachTo | Qt берёт ownership → двойное удаление | Не вызывать `destroy()` вручную после `attachTo()` |
| QCompleter: один объект — один виджет | Переиспользование объекта на разных виджетах не поддерживается | Создавать отдельный QCompleter для каждого поля ввода |
| QShortcut: `destroy(sc)` вместо `free()` | Qt-owned объект: D-деструктора нет, `destroy()` — no-op, Qt-сторона не освобождается | `sc.free()` для явной ранней очистки при живом родителе |
| QFileSystemWatcher: vim-паттерн | vim/emacs удаляют файл при сохранении → watcher снимает наблюдение | В `connect_fileChanged`: `if (exists(path)) watcher.addPath(path)` |
| QFileSystemWatcher: GC после deleteApp | watcher с деструктором финализируется GC после deleteApp → Qt crash | `destroy(watcher)` явно перед `GC.collect()` / `app.deleteApp()` |

---

## 23. ИНДЕКСЫ PФУНQT (краткий справочник)

```
pFunQt[PFUNQT_SIZE=25000] — глобальный массив указателей на C-функции DLL
next free index: 24714 (макс. занятый 24713)

Блоки:
  1–76    qte56_qcore.dll     — QApplication, ESlot, QString (create/free/from/to)
  200–399 qte56_foundation    — QWidget, QFrame, QObject
  400–599 qte56_widgets       — QPushButton, QAbstractButton
  600–642 qte56_widgets       — QLayout (QVBox/HBox/Grid/Form, расширения 629–642)
  800–999 qte56_widgets       — QLabel
  1000–   qte56_widgets       — QLineEdit, QCheckBox, QComboBox, QRadioButton...
  3800–3841 qte56_mainwin     — QAction
  4000–   qte56_mainwin       — QMenu, QMenuBar
  6200–   qte56_mainwin       — QMainWindow, QToolBar, QStatusBar, QDockWidget
  7000–   qte56_views         — QListWidget
  7200–   qte56_widgets       — QSettings (7221–7222 = setBytes/getBytes)
  9200–   qte56_views         — QTableWidget
  9600–9681 qte56_views       — QTreeWidget
  10200–  qte56_widgets       — QFont
  17600–  qte56_widgets       — QPixmap
  18000–  qte56_widgets       — QPainter
  18200–  qte56_widgets       — QImage
  19100–19132 qte56_sql       — QSqlDatabase, QSqlQuery
  19200–19235 qte56_text      — QTextCursor
  19300–19419 qte56_text      — QTextCharFormat, QTextBlockFormat
  19500–19514 qte56_text      — QTextBlock
  19600–19612 qte56_text      — QSyntaxHighlighter
  19700–19747 qte56_qscintilla — QsciScintilla (полный блок 48/48)
  19748–19760 qte56_drawing   — QPen
  19761–19767 qte56_drawing   — QBrush
  19768–19775 qte56_drawing   — QPalette
  19776–19785 qte56_drawing   — QFontMetrics
  19786–19787 qte56_drawing   — QPainter extensions
  19788–19796 qte56_systray   — QSplashScreen
  19797–19809 qte56_systray   — QSystemTrayIcon
  19810–19811 qte56_resource  — QResource
  19812–19815 qte56_uiloader  — QUiLoader
  19816–19836 qte56_qprocess  — QProcess
  19837–19841 qte56_qprocess  — QStringList extensions
  19850–19884 qte56_tvision   — Turbo Vision TUI
  19885–19911 qte56_foundation — QDate
  19912–19933 qte56_foundation — QTime
  19934–19968 qte56_foundation — QDateTime
  19969–19998 qte56_foundation — QByteArray
  19999–20000 qte56_widgets   — QImage_memio (loadFromData/saveToBuffer)
  20001–20002 qte56_widgets   — QPixmap_memio (loadFromData/saveToBuffer)
  20003       qte56_qscintilla — createLexerBash
  20004       qte56_qscintilla — createLexerBatch
  20005–20041 qte56_network    — QUrl, QNetworkRequest, QNetworkReply, QNetworkAccessManager
  20042–20045 qte56_network    — ignoreSslErrors, connect_sslErrors, uploadProgress, rawHeaderList
  20046–20072 qte56_curl       — QCurl (libcurl via LoadLibrary)
  20073–20089 qte56_thread     — QThread (create/delete/start/quit/wait/isRunning/isFinished/
                                  requestInterruption/isInterruptionRequested/setPriority/
                                  connect_started/connect_finished/msleep/usleep/
                                  idealThreadCount/moveToThread)
  20090–20095 qte56_thread     — QMutex (create/delete/lock/unlock/tryLock/tryLock_ms)
  20096–20101 qte56_thread     — QWaitCondition (create/delete/wait/wait_ms/wakeOne/wakeAll)
  20102–20108 qte56_thread     — QSemaphore (create/delete/acquire/tryAcquire/tryAcquire_ms/
                                  release/available)
  20109–20117 qte56_thread     — QReadWriteLock (create/delete/lockForRead/lockForWrite/
                                  tryLockForRead/tryLockForRead_ms/tryLockForWrite/
                                  tryLockForWrite_ms/unlock)
  20118–20131 qte56_completer  — QCompleter (create/createList/delete/setCompletionMode/
                                  setCaseSensitivity/setMaxVisibleItems/setPrefix/
                                  completionCount/currentCompletion/complete/
                                  setModelFromList/connect_activated/
                                  QLineEdit_setCompleter/QComboBox_setCompleter)
  20132–20138 qte56_shortcut   — QShortcut (create/delete/setEnabled/isEnabled/
                                  setContext/connect_activated/setAutoRepeat)
  20139–20148 qte56_filewatcher — QFileSystemWatcher (create/delete/addPath/addPaths/
                                  removePath/removePaths/files/directories/
                                  connect_fileChanged/connect_directoryChanged)
  20163–20168 qte56_shortcut   — QShortcut augment (context/whatsThis/autoRepeat/id/
                                  connect_activatedAmbiguously)
  24100–24102 qte56_foundation — lifecycle tracking (qte_lifecycle_*)
  24714+      — next free
```
