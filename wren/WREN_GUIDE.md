# Встроенный Wren в QTE56 — Руководство

> ↑ Навигация: [AGENTS.md](../AGENTS.md)

## Содержание

1. [Архитектура](#1-архитектура)
2. [Быстрый старт](#2-быстрый-старт)
3. [API со стороны D](#3-api-со-стороны-d)
4. [API со стороны Wren — модуль "qt"](#4-api-со-стороны-wren--модуль-qt)
5. [Передача данных D ↔ Wren](#5-передача-данных-d--wren)
6. [Подключение к Qt-сигналам (ESlot)](#6-подключение-к-qt-сигналам-eslot)
7. [Обработка ошибок](#7-обработка-ошибок)
8. [Неочевидные сложные места](#8-неочевидные-сложные-места)
9. [Полный пример](#9-полный-пример)
10. [Ограничения](#10-ограничения)

---

## 1. Архитектура

```
┌─────────────────────────────────────────────────────────────────┐
│  Ваш D-код                                                      │
│                                                                 │
│  LoadQt("./dll")      ← Qt DLL-модули (pFunQt)                  │
│  LoadWren("./dll/wren_bridge.dll")                              │
│                                                                 │
│  auto vm = new WrenVM(&writeCb, &errorCb)                       │
│  vm.setWidget("btn", btn.getWH())   ← регистрируем виджеты     │
│  vm.loadFile("logic.wren")          ← загружаем скрипт         │
│                                                                 │
│  // В ESlot-колбэке при нажатии кнопки:                        │
│  vm.call("main", "Handler", "onButtonClick()")                  │
└────────────────┬────────────────────────────────────────────────┘
                 │ C API (GetProcAddress)
┌────────────────▼────────────────────────────────────────────────┐
│  wren_bridge.dll  (C++ + Wren 0.4.0)                           │
│                                                                 │
│  ┌───────────────┐   ┌──────────────────────────────────────┐  │
│  │  Wren VM      │   │  Встроенный модуль "qt"              │  │
│  │  (wren 0.4.0) │   │                                      │  │
│  │  interpret()  │   │  foreign class Widget {              │  │
│  │  call()       │   │      construct new(name) {}          │  │
│  │  wrenGetSlot* │   │      foreign setText(text)           │  │
│  └───────────────┘   │      foreign text      // getter     │  │
│                      │      foreign setValue(n)             │  │
│  ┌───────────────┐   │      ...                             │  │
│  │ Widget        │   │  }                                   │  │
│  │ registry      │   │  class Widgets {                     │  │
│  │ name→void*    │   │      static get(name) { ... }        │  │
│  └───────────────┘   │  }                                   │  │
│                      └──────────────────────────────────────┘  │
│                                                                 │
│  Dispatch: qobject_cast<QLabel*>, <QLineEdit*>, <QSpinBox*>...  │
└─────────────────────────────────────────────────────────────────┘
```

**Ключевая идея Варианта C:** D владеет виджетами и event loop-ом, Wren знает только имена виджетов. Логика приложения живёт в `.wren`-файлах и может обновляться без перекомпиляции D.

---

## 2. Быстрый старт

### Зависимости

```
dll/wren_bridge.dll     ← собрать из wren/c/ (qmake + mingw32-make)
wren/d/wren_vm.d        ← импортировать в свой D-проект
```

### Минимальный пример (D)

```d
import wren_vm;
import gen_qlabel, gen_qpushbutton, /* ... */;

void main() {
    LoadQt("./dll");
    LoadWren("./dll/wren_bridge.dll");  // загрузить DLL один раз

    auto app = new QApplication("myapp");
    auto win = new QWidget(cast(void*)null);
    auto lbl = new QLabel(cast(void*)null);
    lbl.setText("...");
    // ... layout ...

    // Создать VM и зарегистрировать виджеты
    auto vm = new WrenVM();
    vm.setWidget("lbl", lbl.getWH());

    // Загрузить логику
    vm.loadFile("logic.wren");

    win.show();
    app.exec();

    vm.free();
    app.deleteApp();
}
```

### Минимальный пример (Wren)

```wren
// logic.wren
import "qt" for Widgets

class Handler {
    static onButtonClick() {
        Widgets.get("lbl").setText("Нажато!")
    }
}
```

---

## 3. API со стороны D

### Инициализация

```d
// Загрузить DLL (один раз на приложение, до создания WrenVM)
// dllPath = null → "./dll/wren_bridge.dll" (Windows) / "./lib/libwren_bridge.so" (Linux)
void LoadWren(string dllPath = null);
```

### Класс WrenVM

```d
// Конструктор: writeCb = обработчик вывода, errorCb = обработчик ошибок
// null → вывод в stdout/stderr по умолчанию
new WrenVM(WrenWriteCb writeCb = null, WrenErrorCb errorCb = null, void* ud = null)

// Явное освобождение (также вызывается в ~this)
void free()
```

### Загрузка кода

```d
// Интерпретировать строку кода
// module_ — имя модуля (обычно "main")
// Возвращает: 0=OK, 1=ошибка компиляции, 2=ошибка выполнения
int interpret(string module_, string source)

// Загрузить и выполнить .wren файл
// Путь относительно рабочей директории (.exe)
int loadFile(string path, string module_ = "main")
```

> **Важно:** `loadFile` выполняет код на верхнем уровне немедленно. Все `class Handler { ... }` и `var x = ...` на верхнем уровне выполняются при загрузке. Методы при этом не вызываются.

### Реестр виджетов

```d
// Зарегистрировать виджет — Wren увидит его через Widgets.get("name")
// wh = getWH() любого виджета Qt
void setWidget(string name, void* wh)

// Очистить весь реестр
void clearWidgets()
```

### Вызов Wren из D

```d
// Вызвать статический метод класса
// module_ — имя модуля (обычно "main")
// className — имя класса в Wren
// sig — сигнатура: "methodName()" или "methodName(_)" или "methodName(_,_)"
// Возвращает: 0=OK, 1=ошибка компиляции, 2=ошибка выполнения
int call(string module_, string className, string sig)

// Удобные обёртки: вызвать и сразу получить результат
string callStr(string module_, string className, string sig)   // "" при ошибке
double callNum(string module_, string className, string sig)   // 0 при ошибке
bool   callBool(string module_, string className, string sig)  // false при ошибке
```

### Передача аргументов в Wren

Аргументы устанавливаются **до** вызова `call()`. Нумерация слотов начинается с **1** (слот 0 = receiver, им управляет сама DLL).

```d
void argDouble(int slot, double val)  // slot=1, 2, 3...
void argString(int slot, string val)
void argBool(int slot, bool val)
```

Пример: метод с двумя аргументами

```d
// Wren: static compute(x, y) { return x * y + 1 }
vm.argDouble(1, 7.0);
vm.argDouble(2, 6.0);
double result = vm.callNum("main", "Math", "compute(_,_)");
// result == 43.0
```

### Чтение результата вручную

```d
int    resultType()    // 0=число, 1=bool, 2=строка, 3=null, 4=другое
double resultDouble()
bool   resultBool()
string resultString()
```

### Прочее

```d
// Проверить, определена ли переменная/класс в модуле
bool hasVariable(string module_, string name)

// Внутренний указатель WrenBridge* (для отладки)
void* handle()
```

### Типы колбэков

```d
// Вывод от System.print / Logger.print
alias WrenWriteCb = extern(C) void function(const(char)* text, int len, void* ud);

// Ошибки Wren (компиляция, рантайм, стек-трейс)
alias WrenErrorCb = extern(C) void function(const(char)* msg, int len, void* ud);
```

---

## 4. API со стороны Wren — модуль "qt"

Модуль `"qt"` встроен в `wren_bridge.dll` — никаких файлов не нужно.

```wren
import "qt" for Widget, Widgets, Logger
```

### class Widget

Обёртка вокруг Qt-виджета, зарегистрированного через `vm.setWidget("name", wh)`.

```wren
// Создать через реестр по имени
var lbl = Widget.new("lbl")          // эквивалентно Widgets.get("lbl")
```

| Метод / геттер | Поддерживаемые типы Qt | Описание |
|---|---|---|
| `setText(text)` | QLabel, QLineEdit, QAbstractButton, QGroupBox | Установить текст / заголовок |
| `text` | то же | Прочитать текст |
| `setValue(n)` | QSpinBox, QDoubleSpinBox, QAbstractSlider, QProgressBar, QLCDNumber | Установить числовое значение |
| `value` | то же | Прочитать числовое значение |
| `setChecked(b)` | QAbstractButton (QCheckBox, QRadioButton, QPushButton) | Установить состояние |
| `isChecked` | то же | Прочитать состояние |
| `setEnabled(b)` | Все QWidget | Включить/выключить |
| `isEnabled` | Все QWidget | Прочитать enabled |
| `setVisible(b)` | Все QWidget | Показать/скрыть |
| `isVisible` | Все QWidget | Прочитать видимость |
| `addItem(text)` | QComboBox, QListWidget | Добавить элемент |
| `clearItems()` | QComboBox, QListWidget | Очистить все элементы |
| `count` | QComboBox, QListWidget | Количество элементов |
| `currentIndex` | QComboBox | Текущий индекс |
| `setCurrentIndex(n)` | QComboBox | Установить индекс |
| `className` | Все QWidget | Имя Qt-класса (для отладки) |

> **Неизвестный тип:** если виджет не распознан (например, `setText` на QSpinBox), метод молча ничего не делает. Ошибки нет. Используйте `className` для диагностики.

### class Widgets

Вспомогательный класс для удобного доступа по имени.

```wren
var lbl = Widgets.get("lbl")         // возвращает Widget
```

Эквивалентно `Widget.new("lbl")`. Предпочтительный способ — читается как словарь.

> **Несуществующее имя:** если имя не зарегистрировано, Widget создаётся с нулевым указателем. Все операции над ним молча игнорируются. Программа не падает, но ничего не происходит.

### class Logger

Вывод в колбэк `WrenWriteCb`, установленный при создании VM.

```wren
Logger.print("Привет из Wren\n")    // → writeCb
Logger.warn("Что-то не так")        // → writeCb с префиксом "[WARN] "
```

`System.print(...)` встроен в Wren и тоже идёт через `writeCb`.

---

## 5. Передача данных D ↔ Wren

### D → Wren (аргументы)

Аргументы нужно установить **непосредственно перед** `call()`. Они потребляются при вызове и сбрасываются.

```d
// Wren: static process(name, count, flag)
vm.argString(1, "Иван");
vm.argDouble(2, 5.0);
vm.argBool(3, true);
int rc = vm.call("main", "Handler", "process(_,_,_)");
```

**Соответствие типов:**

| D | Wren | Метод |
|---|---|---|
| `double` / `int` / `float` | `Num` | `argDouble(slot, val)` |
| `string` | `String` | `argString(slot, val)` |
| `bool` | `Bool` | `argBool(slot, val)` |

> В Wren все числа — `Num` (double). Целые числа передаются как double и работают корректно до ±2^53.

### Wren → D (возвращаемые значения)

После успешного `call()` (`rc == 0`) читайте результат:

```d
int rc = vm.call("main", "Calc", "compute(_,_)");
if (rc == 0) {
    switch (vm.resultType()) {
        case 0: writeln("num: ", vm.resultDouble()); break;
        case 1: writeln("bool: ", vm.resultBool()); break;
        case 2: writeln("str: ", vm.resultString()); break;
        case 3: writeln("null"); break;
        default: writeln("other (object/list/etc)"); break;
    }
}
```

Или через удобные обёртки:

```d
double r = vm.callNum("main", "Calc", "sum(_,_)");    // 0 если ошибка
string s = vm.callStr("main", "Fmt", "format()");     // "" если ошибка
bool   b = vm.callBool("main", "Guard", "validate()");// false если ошибка
```

### Виджеты как разделяемое состояние

Самый удобный способ передавать данные — через сами виджеты. Wren читает и пишет виджеты напрямую:

```d
// D подготавливает данные
editName.setText("Иван Петров");

// D вызывает Wren
vm.call("main", "Handler", "processForm()");

// Wren внутри читает edit.text и обновляет lbl.setText(...)
// D после вызова может читать обновлённый виджет:
string result = lblResult.text();
```

---

## 6. Подключение к Qt-сигналам (ESlot)

Поскольку `extern(C)` функции не могут захватывать замыкания, состояние VM хранится в `__gshared` глобале.

Сигнатура коллбэка для `clicked` (invoke_b): `(void* dthis, int n, int checked)` — второй параметр всегда `int n` (тег из `sl.set(...)`), третий — значение сигнала.

### Базовый паттерн

```d
__gshared WrenVM g_vm;
__gshared ESlot[] g_slots;  // предотвратить GC-сборку слотов!

extern(C) static void cbButtonClick(void* dthis, int n, int checked) {
    g_vm.call("main", "Handler", "onButtonClick()");
}

// При инициализации:
g_vm = new WrenVM();
g_vm.loadFile("logic.wren");

auto sl = new ESlot(btn.getWH());
sl.set(cast(void*)&cbButtonClick);
btn.connect_clicked(sl);
g_slots ~= sl;  // ВАЖНО: без этого GC удалит слот
```

### Передача аргументов из сигнала

Если сигнал несёт данные (textChanged, valueChanged), их можно передать через аргументы или через глобал:

```d
__gshared string g_pendingText;

extern(C) static void cbTextChanged(void* dthis, int n, int checked) {
    // Текст уже доступен в виджете через "edit" — проще читать из Wren:
    g_vm.call("main", "Handler", "onTextChanged()");
    // Wren сам вызовет Widgets.get("edit").text
}
```

Или явно через `argString`:

```d
extern(C) static void cbTextChanged(void* dthis, int n, int checked) {
    string text = g_edit.text();  // читаем из D
    g_vm.argString(1, text);
    g_vm.call("main", "Handler", "onTextChanged(_)");
}
```

### Несколько обработчиков на разные методы

Создать отдельный `extern(C)` колбэк для каждой кнопки. Это многословно, но безопасно:

```d
extern(C) static void cbSave(void* dthis, int n, int checked)   { g_vm.call("main", "H", "onSave()"); }
extern(C) static void cbDelete(void* dthis, int n, int checked) { g_vm.call("main", "H", "onDelete()"); }
extern(C) static void cbLoad(void* dthis, int n, int checked)   { g_vm.call("main", "H", "onLoad()"); }
```

---

## 7. Обработка ошибок

### Проверять возвращаемые коды

```d
int rc = vm.loadFile("logic.wren");
if (rc == 1) { writeln("Ошибка компиляции Wren!"); }
if (rc == 2) { writeln("Ошибка выполнения Wren!"); }

rc = vm.call("main", "Handler", "onEvent()");
if (rc != 0) { writeln("Wren call failed: ", rc); }
```

### Кастомные колбэки ошибок

```d
extern(C) void myErrorCb(const(char)* msg, int len, void* ud) {
    import std.string : fromStringz;
    // Показать в Qt-диалоге или записать в лог-файл:
    writeln("[WREN ERR] ", fromStringz(msg));
}

auto vm = new WrenVM(null, &myErrorCb);
```

Формат сообщений ошибок:
- Компиляция: `[module line N] Compile: сообщение`
- Рантайм: `Runtime: сообщение`
- Стек-трейс: `  at [module line N]`

### Проверить наличие класса перед вызовом

```d
if (!vm.hasVariable("main", "Handler")) {
    writeln("Handler не определён в скрипте!");
    return;
}
vm.call("main", "Handler", "onEvent()");
```

### Hot-reload скрипта

```d
void reloadScript() {
    // Создаём новую VM, повторно регистрируем виджеты, загружаем скрипт
    auto newVm = new WrenVM(&writeCb, &errorCb);
    newVm.setWidget("edit", g_edit.getWH());
    newVm.setWidget("lbl",  g_lbl.getWH());
    // ...

    int rc = newVm.loadFile("logic.wren");
    if (rc != 0) {
        writeln("Ошибка загрузки — оставляем старый скрипт");
        newVm.free();
        return;
    }

    // Заменяем только после успешной загрузки
    if (g_vm) g_vm.free();
    g_vm = newVm;
    writeln("Скрипт перезагружен!");
}
```

---

## 8. Неочевидные сложные места

### 8.1. `wren.h` не имеет `extern "C"` guard

**Проблема:** `wren.h` не оборачивает объявления в `extern "C"`. Если C++ файл включает его напрямую — компилятор генерирует C++ mangled имена (`wrenGetSlotDouble(WrenVM*)`) вместо C-имён (`wrenGetSlotDouble`). Линкер не находит символы в `.o` файлах Wren.

**Решение в wren_bridge.cpp:**
```cpp
// ПРАВИЛЬНО:
extern "C" {
#include "wren.h"
}

// НЕПРАВИЛЬНО (линкер упадёт с undefined reference):
#include "wren.h"
```

Это касается только самого `wren_bridge.cpp`. D-код этого не видит.

### 8.2. Имя конструктора foreign class

**Проблема:** Wren не принимает имена с символом `_` в начале как имя конструктора (`construct _new(name) {}`). Ошибка: `Expect constructor name after 'construct'`.

**Правило:** Конструктор должен называться обычным идентификатором без ведущего `_`.

```wren
// ПРАВИЛЬНО:
foreign class Widget {
    construct new(name) {}
}
// вызов:
Widget.new("myWidget")

// НЕПРАВИЛЬНО (compile error):
foreign class Widget {
    construct _new(name) {}
}
```

### 8.3. Тело метода на одной строке с `{ return ... }`

**Проблема:** Wren в некоторых контекстах не парсит `{ return expr }` на одной строке корректно. Ошибка: `Error at 'return': Expected expression`.

**Решение:** Всегда писать тело метода на нескольких строках.

```wren
// ПРАВИЛЬНО:
class Widgets {
    static get(name) {
        return Widget.new(name)
    }
}

// МОЖЕТ НЕ РАБОТАТЬ в некоторых контекстах:
class Widgets {
    static get(name) { return Widget.new(name) }
}
```

Это особенно важно в строках, передаваемых из C++ как raw string literal в `wrenInterpret`.

### 8.4. Сигнатуры методов в `call()`

Wren различает методы с аргументами и без. Сигнатура должна точно совпадать.

```d
// Метод без аргументов:
vm.call("main", "Handler", "onEvent()")      // ✓

// Метод с N аргументами — N символов _:
vm.call("main", "Handler", "compute(_)")     // ✓ один аргумент
vm.call("main", "Handler", "compute(_,_)")   // ✓ два аргумента
vm.call("main", "Handler", "compute()")      // ✗ не найдёт двухарг. метод
vm.call("main", "Handler", "compute")        // ✗ нет скобок — не найдёт
```

### 8.5. Геттеры в Wren — без скобок

В Wren свойства (геттеры) определяются без аргументов и вызываются без скобок:

```wren
// В модуле "qt":
foreign class Widget {
    foreign text        // геттер — нет скобок
    foreign isChecked   // геттер — нет скобок
    foreign count       // геттер — нет скобок
}
```

```wren
// Использование в скрипте:
var t = widget.text        // ✓ без скобок
var n = widget.count       // ✓
// var t = widget.text()   // ✗ ошибка — text это геттер, а не метод
```

При добавлении своих методов: если не нужен аргумент — делайте геттер (без скобок).

### 8.6. GC D может собрать ESlot

Если `ESlot` создан локально и не сохранён — GC удалит его, и при следующем сигнале программа упадёт.

```d
// ОПАСНО: sl может быть собран GC
void connectBtn(QPushButton btn, void* cbPtr) {
    auto sl = new ESlot(btn.getWH());
    sl.set(cbPtr);
    btn.connect_clicked(sl);
    // sl выходит из области видимости!
}

// БЕЗОПАСНО: хранить в __gshared массиве
__gshared ESlot[] g_slots;

void connectBtn(QPushButton btn, void* cbPtr) {
    auto sl = new ESlot(btn.getWH());
    sl.set(cbPtr);
    btn.connect_clicked(sl);
    g_slots ~= sl;  // сохранить ссылку
}
```

### 8.7. Порядок инициализации: LoadWren до new WrenVM

```d
// ПРАВИЛЬНО:
LoadQt("./dll");          // 1. Qt DLL
LoadWren("./dll/wren_bridge.dll"); // 2. Wren DLL
auto app = new QApplication("app");
auto vm  = new WrenVM();

// НЕПРАВИЛЬНО:
auto vm = new WrenVM();   // ✗ _create ещё null → segfault
LoadWren(...);
```

### 8.8. Время жизни виджетов и реестра

Реестр виджетов хранит raw `void*` указатели. Если виджет уничтожен, а Wren-скрипт ещё держит `Widget.new("name")` — операции над ним вызовут падение.

**Правило:** очищайте реестр (`vm.clearWidgets()`) или пересоздавайте VM при уничтожении виджетов.

### 8.9. Модули и имена переменных

`loadFile("a.wren")` и `interpret("main", source)` кладут код в один и тот же модуль `"main"`. Если `Handler` определён дважды — второй перезаписывает первый. Используйте разные имена модулей для разных файлов:

```d
vm.loadFile("core_logic.wren",  "core");
vm.loadFile("ui_handlers.wren", "main");

// Вызывать:
vm.call("main", "UIHandler", "onButtonClick()");
vm.call("core", "CoreLogic", "compute()");
```

В Wren-файлах импортировать между модулями:

```wren
// ui_handlers.wren
import "core" for CoreLogic

class UIHandler {
    static onButtonClick() {
        var r = CoreLogic.compute()
        Widgets.get("lbl").setText(r.toString)
    }
}
```

### 8.10. UTF-8 / UTF-16

- Все строки между D и DLL — **UTF-8** (`const char*`)
- Путь к .wren-файлу в `loadFile` — **UTF-8** (экспортируется `wrenBridge_loadFileUtf8`, кроссплатформенно);
  отдельный UTF-16 вариант `wrenBridge_loadFile` (wchar_t) в `wren_vm.d` не используется
- Путь к самой DLL в `LoadWren` на Windows конвертируется в UTF-16 (`toUTF16z`) — кириллица в пути к DLL работает
- Wren-скрипты — UTF-8, кириллица работает в строковых литералах

---

## 9. Полный пример

**Сценарий:** форма с полем имени, выбором языка и кнопкой. Логика — на Wren.

### main.d

```d
import wren_vm;
import qte56_core, qte56_loader, qte56_enums;
import gen_qcore, gen_qwidget, gen_qlayout, gen_qlabel;
import gen_qpushbutton, gen_qlineedit, gen_qcombobox;
import gen_qabstractbutton;

__gshared WrenVM   g_vm;
__gshared ESlot[]  g_slots;
__gshared QLabel   g_lbl;
__gshared QLineEdit g_edit;

extern(C) static void wrenOut(const(char)* text, int len, void* ud) {
    import std.stdio : write;
    import std.string : fromStringz;
    write(fromStringz(text));
}
extern(C) static void wrenErr(const(char)* msg, int len, void* ud) {
    import std.stdio : writeln;
    import std.string : fromStringz;
    writeln("[!] ", fromStringz(msg));
}

extern(C) static void cbGreet(void* dthis, int n, int checked) {
    int rc = g_vm.call("main", "Handler", "onGreet()");
    if (rc != 0) writeln("Wren error: ", rc);
}

void main() {
    LoadQt("./dll");
    LoadWren("./dll/wren_bridge.dll");

    auto app  = new QApplication("example");
    auto win  = new QWidget(cast(void*)null);
    win.setWindowTitle("Wren Demo");
    win.resize(400, 150);

    auto vbox = new QVBoxLayout();

    g_edit = new QLineEdit(cast(void*)null);
    g_edit.setPlaceholderText("Введите имя...");

    auto combo = new QComboBox(cast(void*)null);
    combo.addItem("Привет");
    combo.addItem("Hello");
    combo.addItem("Hola");

    auto btn = new QPushButton(cast(void*)null);
    btn.setText("Поздороваться");

    g_lbl = new QLabel(cast(void*)null);
    g_lbl.setText("...");

    vbox.addWidget(g_edit.getWH());
    vbox.addWidget(combo.getWH());
    vbox.addWidget(btn.getWH());
    vbox.addWidget(g_lbl.getWH());
    win.setLayout(vbox.getWH());
    vbox.disown();

    // Wren VM
    g_vm = new WrenVM(&wrenOut, &wrenErr);
    g_vm.setWidget("edit",  g_edit.getWH());
    g_vm.setWidget("combo", combo.getWH());
    g_vm.setWidget("result", g_lbl.getWH());

    int rc = g_vm.loadFile("greet.wren");
    if (rc != 0) writeln("ERROR: greet.wren не загружен (rc=", rc, ")");

    // Подключить кнопку
    auto sl = new ESlot(btn.getWH());
    sl.set(cast(void*)&cbGreet);
    btn.connect_clicked(sl);
    g_slots ~= sl;

    win.show();
    app.exec();
    g_vm.free();
    app.deleteApp();
}
```

### greet.wren

```wren
import "qt" for Widgets

var greetings = ["Привет", "Hello", "Hola"]

class Handler {
    static onGreet() {
        var name = Widgets.get("edit").text
        var idx  = Widgets.get("combo").currentIndex
        var lbl  = Widgets.get("result")

        if (name == "") name = "незнакомец"
        var greet = greetings[idx]

        lbl.setText(greet + ", " + name + "!")
        System.print(greet + ", " + name + "!\n")
    }
}
```

### Сборка

```bat
dmd -m32 main.d wren\d\wren_vm.d d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qwidget.d d\gen\gen_qlayout.d d\gen\gen_qlabel.d ^
    d\gen\gen_qpushbutton.d d\gen\gen_qlineedit.d d\gen\gen_qcombobox.d ^
    d\gen\gen_qabstractbutton.d ^
    -Id -Id\gen -Iwren\d -of=myapp.exe
```

---

## 10. Ограничения

| Ограничение | Описание |
|---|---|
| Только статические методы | `call()` вызывает только `static` методы. Инстанс-методы через Wren не поддерживаются. |
| Только QWidget-подклассы | `Widget.new("name")` работает только с виджетами. Другие Qt-объекты (QTimer, QAction) не поддерживаются. |
| Однопоточность | Wren VM не thread-safe. Не вызывайте `call()` из разных потоков. |
| Объекты Wren ≠ результат | `resultType() == 4` (other) — получить объект Wren из D невозможно. Только примитивы: число, строка, bool. |
| Нет биндинга сигналов | Wren не может подключать обработчики к Qt-сигналам напрямую. Это всегда делается через D. |
| Windows / Linux | `wren_vm.d` работает на Windows (`LoadLibraryW`) и Linux/macOS (`dlopen`); на Linux путь по умолчанию — `./lib/libwren_bridge.so`. |

---

## Навигация

- ↑ [AGENTS.md](../AGENTS.md) — точка входа
- ↓ Подробнее:
  - [wren/WREN_KNOWLEDGE_TRANSFER.md](WREN_KNOWLEDGE_TRANSFER.md) — передача знаний Wren
  - [AI_WREN.md](../AI_WREN.md) — Wren + OLE/COM для AI
  - [wren/doc/inspector_guide.md](doc/inspector_guide.md) — Wren Inspector
  - [wren/doc/excel_wren_guide.md](doc/excel_wren_guide.md) — excel.wren
