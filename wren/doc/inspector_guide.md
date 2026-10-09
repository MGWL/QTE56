# Wren Inspector — Руководство

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [wren/WREN_GUIDE.md](../WREN_GUIDE.md)

Wren Inspector — встроенный отладчик D+Qt приложений.
Позволяет наблюдать за состоянием программы в реальном времени и выполнять
Wren-код прямо в работающем приложении, не останавливая его.

---

## Архитектура

```
D-приложение                     Wren Inspector (QDialog)
─────────────────────────        ──────────────────────────────────────────
vm.interpret("main",             ┌── Monitor ─[Clear]──┬── Console ─[Clear]──┐
  `Log.info("btn clicked")`)  ──▶│ [INFO ] btn clicked  │                     │
                                 │                      │                     │
                                 └──────────────────────┴─────────────────────┘
                                 [ многострочный ввод Wren            ] [Run]
```

**Monitor** (левая панель) — пассивный лог из D-кода через `Log.*`.
**Console** (правая панель) — REPL: вывод через `Out.*`, результаты выражений.

| Клавиша | Действие |
|---------|---------|
| **Ctrl+Enter** | Запустить код из поля ввода |
| **Ctrl+↑** | Предыдущий запрос из истории |
| **Ctrl+↓** | Следующий запрос / вернуться к черновику |
| **Enter** | Перенос строки (обычный) |

---

## Интеграция в приложение

### 1. Минимальный пример

```d
import wren_vm;
import wren_console;

// После LoadWren() и LoadQt():
auto vm = new WrenVM(&myWriteCb, &myErrorCb);
vm.addLibPath("./wren/lib");

auto inspector = createInspector(vm, mainWin.getWH(), "./wren/scenarios");
inspector.show();

// Импортировать Log один раз в модуль "main"
vm.interpret("main", `import "log" for Log`);

// Теперь логировать из любого места D-кода:
vm.interpret("main", `Log.info("App started")`);
```

### 2. Логирование из D-колбэков

```d
extern(C) void onButtonClick(void* unused) {
    g_vm.interpret("main", `Log.ok("Button clicked")`);
}
```

### 3. Именование виджетов для Inspector.find

```d
auto btn = new QPushButton("OK", win.getWH());
btn.setObjectName("myButton");   // ← важно: без этого find не найдёт
```

---

## Модули в REPL

В Console REPL все четыре модуля доступны **без явного import**:

| Модуль | Доступные имена |
|--------|-----------------|
| `log`  | `Log` |
| `out`  | `Out` |
| `check`| `Check` |
| `inspector` | `Inspector`, `QtObj` |

---

## Модуль `log` — Monitor панель

Весь вывод идёт в **левую** панель (Monitor).

```wren
Log.print("обычный текст")          // белый
Log.info("информация")              // синий  [INFO ]
Log.ok("успешно")                   // зелёный [OK   ]
Log.warn("предупреждение")          // жёлтый [WARN ]
Log.error("ошибка!")                // красный [ERROR]
Log.val("x", someValue)             // голубой [VAL  ] x = ...
Log.sep("── секция ──")             // серый разделитель
Log.clear()                         // очистить Monitor
```

**Рекомендация:** использовать из D-кода для логирования событий приложения.

---

## Модуль `out` — Console панель

Весь вывод идёт в **правую** панель (Console). Те же методы что у `Log`:

```wren
Out.print("результат")
Out.val("answer", 42)
Out.ok("тест прошёл")
Out.sep("────────────")
Out.clear()
```

**Рекомендация:** использовать для вывода результатов REPL-сессии.

---

## Модуль `inspector` — интроспекция Qt

### Inspector — поиск виджетов

```wren
// Все виджеты в приложении
var all = Inspector.allWidgets               // List<QtObj>
Out.val("count", all.count)

// Только top-level окна
var tops = Inspector.topWidgets
tops.each {|w| Out.print(w.toString) }

// Найти по objectName
var btn = Inspector.find("myButton")
Out.val("found", btn.isNull)                // false если нашёл

// Найти все виджеты одного класса
var btns = Inspector.findByClass("QPushButton")   // List<QtObj>
Out.val("buttons", btns.count)
btns.each {|b| Out.print("%(b.name)") }
```

### Inspector — навигация по адресам

```wren
// Получить QtObj по числовому адресу
var w = Inspector.atAddress(0x1a2b3c00)

// Прочитать значение в памяти по адресу
Inspector.readU8(addr)                  // Num: байт (0–255)
Inspector.readU32(addr)                 // Num: 32-битное слово
Inspector.readPtr(addr)                 // Num: указатель (sizeof(void*))

// Разыменовать: прочитать указатель и завернуть в QtObj
Inspector.deref(addr)                   // → QtObj

// Hex dump памяти
Inspector.hexDump(addr, 64)             // дамп 64 байт в Console
Inspector.hexDump(addr)                 // дамп 128 байт
```

### QtObj — базовые свойства

```wren
var w = Inspector.find("myWidget")

w.isNull          // true если не найден
w.className       // "QPushButton", "QLabel", ...
w.name            // objectName виджета
w.address         // числовой адрес объекта (Num)
w.toString        // "QPushButton(myButton)"

w.property("visible")          // строковое значение Qt-свойства
w.setProperty("enabled", "false")
w.invoke("show")               // вызвать слот без аргументов
```

### QtObj — методы, сигналы, слоты

```wren
var w = Inspector.find("myWidget")

// Все методы объекта (сигналы + слоты + прочие)
w.methods                       // List<String> сигнатур
Out.print(w.methods.join("\n"))

// Только сигналы
w.signals                       // List<String>
Out.print(w.signalList_)        // сырая строка через \n

// Только слоты
w.slots                         // List<String>
Out.print(w.slotList_)
```

### QtObj — дамп и список свойств

```wren
var w = Inspector.find("myWidget")

// Дамп всех Qt meta-properties в Console
w.dump

// Список имён всех свойств (List<String>)
w.propertyNames                 // → ["objectName", "enabled", "visible", ...]
Out.print(w.propertyNames.join(", "))

// Перебрать имена и значения вручную
w.propertyNames.each {|n|
    Out.print("  %(n) = %(w.property(n))")
}
```

### QtObj — hex dump памяти

```wren
var w = Inspector.find("myWidget")

w.hexDump                       // дамп 128 байт в Console
w.hexDump(64)                   // дамп 64 байт

// Получить дамп как строку (для анализа в коде)
var s = w.hexDumpStr            // 128 байт → String
var s = w.hexDumpStr(32)        // 32 байта → String

// Строки дампа: split и анализ
var rows = w.hexDumpStr(32).split("\n")
Out.val("строк", rows.count)           // 2 (по 16 байт каждая)
Out.print(rows[0])                      // "0000  f4 cb 2c ..."
```

Формат строки дампа:
```
0000  f4 cb 2c 6c b8 2d 60 02  e0 cc 2c 6c 00 00 00 00  |..,l.-`...,l....|
0010  00 00 00 00 64 2e 60 02  00 00 00 00 00 00 00 00  |....d.`.........|
```

### QtObj — разыменование указателей

```wren
var w = Inspector.find("myWidget")

// Прочитать указатель по адресу объекта (vtable)
w.derefPtr                      // Num: значение *(void**)w.address
w.deref                         // QtObj: atAddress(*(void**)w.address)

// Цепочка разыменований вручную
var vtable = Inspector.readPtr(w.address)      // vtable ptr
Inspector.hexDump(vtable, 32)                  // дамп vtable
var slot0 = Inspector.readPtr(vtable)          // первый виртуальный метод
Out.val("vtable[0]", slot0)
```

### QtObj — дерево виджетов

```wren
var win = Inspector.find("mainWindow")

win.childCount              // количество дочерних объектов
win.children                // List<QtObj> дочерних

// Обход дерева
win.children.each {|child|
    Out.print("  %(child.className)(%(child.name))")
}

// Родительский объект
var p = win.parent
Out.val("parent isNull", p.isNull)   // true для top-level
```

### Сохранить адрес и вернуться к объекту

```wren
// Запомнить адрес
var addr = Inspector.find("statusLabel").address
Out.val("addr", addr)

// В другом REPL-запросе восстановить объект
var w = Inspector.atAddress(addr)
w.dump
```

---

## Справочник API

### Inspector (статические методы)

| Метод | Возврат | Описание |
|-------|---------|---------|
| `Inspector.find(name)` | `QtObj` | Найти виджет по objectName |
| `Inspector.findByClass(cls)` | `List<QtObj>` | Все виджеты класса cls |
| `Inspector.atAddress(n)` | `QtObj` | Завернуть адрес в QtObj |
| `Inspector.allWidgets` | `List<QtObj>` | Все виджеты приложения |
| `Inspector.topWidgets` | `List<QtObj>` | Только top-level окна |
| `Inspector.readU8(addr)` | `Num` | Прочитать байт по адресу |
| `Inspector.readU32(addr)` | `Num` | Прочитать 32-битное слово |
| `Inspector.readPtr(addr)` | `Num` | Прочитать указатель |
| `Inspector.deref(addr)` | `QtObj` | readPtr + atAddress |
| `Inspector.hexDump(addr, n)` | — | Дамп n байт в Console |
| `Inspector.hexDump(addr)` | — | Дамп 128 байт в Console |

### QtObj (методы экземпляра)

| Метод / свойство | Тип | Описание |
|-----------------|-----|---------|
| `w.isNull` | `Bool` | true если объект не найден |
| `w.className` | `String` | Имя Qt-класса |
| `w.name` | `String` | objectName |
| `w.address` | `Num` | Адрес в памяти |
| `w.toString` | `String` | `"ClassName(name)"` |
| `w.property(key)` | `String` | Значение Qt-свойства |
| `w.setProperty(key, val)` | `Bool` | Установить Qt-свойство |
| `w.invoke(method)` | `Bool` | Вызвать слот без аргументов |
| `w.dump` | — | Дамп meta-properties в Console |
| `w.propertyNames` | `List<String>` | Имена всех Qt-свойств |
| `w.propertyNames_` | `String` | То же, через `\n` |
| `w.methods` | `List<String>` | Все методы (сигналы+слоты) |
| `w.signals` | `List<String>` | Только сигналы |
| `w.slots` | `List<String>` | Только слоты |
| `w.hexDump` | — | Hex dump 128 байт в Console |
| `w.hexDump(n)` | — | Hex dump n байт в Console |
| `w.hexDumpStr` | `String` | Hex dump 128 байт → строка |
| `w.hexDumpStr(n)` | `String` | Hex dump n байт → строка |
| `w.derefPtr` | `Num` | `readPtr(w.address)` |
| `w.deref` | `QtObj` | `atAddress(readPtr(w.address))` |
| `w.parent` | `QtObj` | Родительский объект |
| `w.childCount` | `Num` | Количество дочерних объектов |
| `w.children` | `List<QtObj>` | Список дочерних объектов |
| `w.childAt(n)` | `QtObj` | Дочерний объект по индексу |

---

## Модуль `check` — мини-тесты прямо в REPL

```wren
Check.reset()
Check.that("два плюс два", 2 + 2 == 4)
Check.equal(Inspector.find("btn").className, "QPushButton", "btn class")
Check.notNull(Inspector.find("btn"), "btn exists")
Check.report()      // выводит "N passed, M failed"
```

| Метод | Описание |
|-------|---------|
| `Check.reset()` | Обнулить счётчики |
| `Check.that(msg, cond)` | Проверить булево условие |
| `Check.equal(a, b, msg)` | Сравнить как строки |
| `Check.notNull(v, msg)` | Проверить что не ноль/null |
| `Check.range(v, lo, hi, msg)` | Проверить диапазон |
| `Check.contains(s, sub, msg)` | Проверить подстроку |
| `Check.report()` | Вывести итог в Console |
| `Check.passed` | Num: кол-во успешных |
| `Check.failed` | Num: кол-во упавших |

---

## Работа в REPL — рецепты

### Посмотреть все виджеты

```wren
Inspector.allWidgets.each {|w| Out.print("%(w.className)(%(w.name))") }
```

### Найти виджет и проверить свойство

```wren
var w = Inspector.find("statusLabel")
Out.val("text", w.property("text"))
Out.val("visible", w.property("visible"))
```

### Переименовать / скрыть виджет

```wren
var w = Inspector.find("myButton")
w.setProperty("text", "New Label")
w.invoke("hide")
```

### Дерево top-level окон

```wren
Inspector.topWidgets.each {|win|
    Out.print("%(win.className)(%(win.name)) — %(win.childCount) children")
}
```

### Полный дамп первого окна

```wren
var w = Inspector.topWidgets[0]
w.dump
```

### Обход памяти: vtable → первый слот

```wren
var w = Inspector.find("myWidget")
var vtable = Inspector.readPtr(w.address)
Out.val("vtable", vtable)
Inspector.hexDump(vtable, 32)
var slot0 = Inspector.readPtr(vtable)
Out.val("vtable[0]", slot0)
```

### Статистика виджетов по классу

```wren
var counts = []
var keys = []
Inspector.allWidgets.each {|w|
    var cls = w.className
    var found = false
    var i = 0
    while (i < keys.count) {
        if (keys[i] == cls) { counts[i] = counts[i] + 1  found = true }
        i = i + 1
    }
    if (!found) { keys.add(cls)  counts.add(1) }
}
var i = 0
while (i < keys.count) {
    Out.print("  %(counts[i])  %(keys[i])")
    i = i + 1
}
```

> Поле ввода — многострочный редактор. Вставляйте код напрямую, нажимайте **Run**.
> Для повторного использования — сохраните код как сценарий (`.wren` в папке scenarios).

---

## Сценарии

Положить `.wren` файл в `./wren/scenarios/`, выбрать в списке **Scenario** → **Load**.

| Файл | Описание |
|------|---------|
| `widget_report.wren` | Дерево всех top-level окон с дочерними виджетами |
| `check_inspector.wren` | Тест Inspector API через `Check.*` |
| `find_and_inspect.wren` | Дамп виджета по имени, список доступных если не найден |
| `count_by_class.wren` | Статистика: сколько виджетов каждого класса |
| `dump_widget.wren` | `w.dump` + propertyNames + parent chain |
| `address_chain.wren` | Адреса детей, `atAddress`, обход через parent |
| `hex_dump.wren` | `w.hexDump`, `Inspector.hexDump(addr, n)` |

---

## Интеграция в D — удобные хелперы

```d
// В своём приложении
void logInfo(string msg) {
    import std.string : replace;
    string safe = msg.replace("\\", "\\\\").replace("\"", "\\\"");
    g_vm.interpret("main", `Log.info("` ~ safe ~ `")`);
}

void logVal(string label, string val) {
    g_vm.interpret("main", `Log.val("` ~ label ~ `", "` ~ val ~ `")`);
}
```

Использование:
```d
logInfo("Файл открыт: " ~ filename);
logVal("Строк", to!string(lineCount));
```

---

## Ограничения текущей версии

| Ограничение | Причина |
|-------------|---------|
| Каждый REPL-запуск — отдельный модуль | Переменные не сохраняются между запросами |
| `setProperty` принимает только строки | Ограничение QObject::setProperty через QString |
| `invoke` только без аргументов | Ограничение QMetaObject::invokeMethod |
| `Inspector.find` ищет только по objectName | Не поддерживает CSS-селекторы |
| `readPtr` / `readU8` — без проверки границ | Адрес должен быть валидным |
| Enter в поле ввода — перенос строки | Для запуска используйте кнопку **Run** |
| Нет автодополнения в поле ввода | Планируется в следующей итерации |
