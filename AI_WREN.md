# QTE56 — AI_WREN (Wren скриптовый движок + OLE/COM)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [wren/WREN_GUIDE.md](wren/WREN_GUIDE.md)

> Используй вместе с AI_CORE.md.
> DLL: dll/wren_bridge.dll (собрать из wren/c/)
> import: wren_vm (путь: wren/d/wren_vm.d)
> Wren 0.4.0 — динамический язык, похожий на JavaScript/Smalltalk

---

## Архитектура

```
D-приложение (виджеты, event loop)
    ↓ LoadWren() / new WrenVM()
wren_bridge.dll  ← Wren VM 0.4.0
    ├── встроенный модуль "qt" → Widget, Widgets, Logger
    └── встроенный модуль "ole" → OleObject (только Windows)

.wren файлы — логика приложения (без перекомпиляции D)
```

**Идея:** D владеет виджетами. Wren знает их имена. Логика — в `.wren`.

---

## Быстрый старт (D)

```d
import wren_vm;    // wren/d/wren_vm.d
import gen_qlabel; import gen_qpushbutton; import gen_qabstractbutton;
// ... другие виджеты ...

void main() {
    LoadQt("./dll");
    LoadWren("./dll/wren_bridge.dll");  // загрузить ОДИН раз до new WrenVM

    auto app = new QApplication();
    auto win = new QWidget(cast(void*)null);
    auto lbl = new QLabel(cast(void*)null);
    auto btn = new QPushButton(cast(void*)null);
    lbl.setText("...");
    btn.setText("Click");
    // ... layout ...

    // Создать VM:
    auto vm = new WrenVM();

    // Зарегистрировать виджеты:
    vm.setWidget("lbl", lbl.getWH());
    vm.setWidget("btn", btn.getWH());

    // Загрузить логику из файла:
    vm.loadFile("logic.wren");

    // Подключить кнопку — вызывать Wren из ESlot:
    __gshared ESlot g_sl;
    extern(C) void onBtn(void* dt, int n, int c) {
        vm.call("main", "Handler", "onBtnClick()");
    }
    g_sl = new ESlot(btn.getWH()); g_sl.set(cast(void*)&onBtn);
    btn.connect_clicked(g_sl);

    win.show(); app.exec();
    vm.free();
    GC.collect(); app.deleteApp();
}
```

---

## WrenVM — API D

```d
// Инициализация:
auto vm = new WrenVM();                   // stdout/stderr по умолчанию
auto vm = new WrenVM(&writeCb, &errorCb); // с кастомными callback
auto vm = new WrenVM(&writeCb, &errorCb, cast(void*)myCtx); // + userdata

// Callback типы:
alias WrenWriteCb = extern(C) void function(const(char)* text, int len, void* ud);
alias WrenErrorCb = extern(C) void function(const(char)* msg,  int len, void* ud);

// Реестр виджетов:
vm.setWidget("name", widget.getWH()); // зарегистрировать
vm.clearWidgets();                     // очистить все

// Загрузка кода:
int rc = vm.loadFile("logic.wren");         // 0=OK 1=compile err 2=runtime err
int rc = vm.interpret("main", "System.print(\"Hello\")");

// Вызов Wren из D:
int rc = vm.call("main", "ClassName", "methodName()");
int rc = vm.call("main", "ClassName", "method(_)");      // 1 аргумент
int rc = vm.call("main", "ClassName", "method(_,_)");    // 2 аргумента

// Аргументы (установить ДО call):
vm.argDouble(1, 42.0);
vm.argString(1, "hello");
vm.argBool  (1, true);

// Результат (после call, rc==0):
string s = vm.callStr ("main", "Math", "compute()");
double d = vm.callNum ("main", "Math", "compute()");
bool   b = vm.callBool("main", "Math", "check()");
// Или через resultXxx() после call():
int    t = vm.resultType();    // 0=num 1=bool 2=string 3=null 4=other
double v = vm.resultDouble();
string s = vm.resultString();

// Проверить наличие класса/переменной:
bool has = vm.hasVariable("main", "Handler");

// Освободить:
vm.free();  // также вызывается в ~this
```

---

## Wren код — основы

```wren
// logic.wren
import "qt" for Widget, Widgets, Logger

class Handler {
    // Статический метод — вызывается из D через vm.call("main","Handler","onBtnClick()")
    static onBtnClick() {
        // Получить виджет по имени:
        var lbl = Widgets.get("lbl")
        lbl.setText("Кнопка нажата!")
    }

    // Метод с аргументами:
    static setText(text) {
        Widgets.get("lbl").setText(text)
    }

    // Метод с возвратом:
    static getValue() {
        return Widgets.get("spin").value
    }
}
```

---

## Wren модуль "qt" — Widget API

```wren
import "qt" for Widget, Widgets, Logger

// Создать виджет по имени из реестра:
var lbl  = Widget.new("lbl")         // эквивалентно Widgets.get("lbl")
var btn  = Widgets.get("btn")        // предпочтительный синтаксис

// ── Текст ──────────────────────────────────────────────────────────────
lbl.setText("Hello World")           // QLabel, QLineEdit, кнопки, GroupBox
var t = lbl.text                     // прочитать текст

// ── Числовое значение ──────────────────────────────────────────────────
var spin = Widgets.get("spin")
spin.setValue(42)                    // QSpinBox, QSlider, QProgressBar, LCD
var v = spin.value                   // прочитать значение

// ── Состояние checkbox/radiobutton ────────────────────────────────────
var cb = Widgets.get("cb")
cb.setChecked(true)
var on = cb.isChecked                // true/false

// ── Видимость и активность ────────────────────────────────────────────
btn.setEnabled(false)
var e = btn.isEnabled
btn.setVisible(false)
var v2 = btn.isVisible

// ── QComboBox / QListWidget ───────────────────────────────────────────
var combo = Widgets.get("combo")
combo.addItem("Option 1")
combo.addItem("Option 2")
combo.clearItems()
var idx = combo.currentIndex
combo.setCurrentIndex(1)
var cnt = combo.count

// ── Отладка ───────────────────────────────────────────────────────────
var cls = lbl.className              // "QLabel", "QPushButton" и т.д.
Logger.print("Widget class: " + cls + "\n")
Logger.warn("Warning message")       // с префиксом [WARN]
System.print("Wren output")          // → writeCb
```

---

## Передача данных D ↔ Wren

```d
// D → Wren: аргументы (слоты начинаются с 1!)
vm.argString(1, "Hello");
vm.argDouble(2, 3.14);
vm.argBool  (3, true);
vm.call("main", "Calc", "process(_,_,_)");  // 3 аргумента

// Wren → D: возвращаемое значение
double result = vm.callNum("main", "Calc", "add(_,_)");
// ↑ аргументы устанавливаются argXxx ДО вызова!
vm.argDouble(1, 10.0);
vm.argDouble(2, 32.0);
double sum = vm.callNum("main", "Calc", "add(_,_)");  // = 42.0
```

```wren
// Wren сторона:
class Calc {
    static add(a, b) { return a + b }
    static process(text, num, flag) {
        if (flag) Logger.print(text + ": " + num.toString + "\n")
        return num * 2
    }
}
```

---

## Wren модуль "ole" — OLE/COM автоматизация (Windows)

```wren
import "ole" for OleObject

// Создать COM объект:
var excel = OleObject.create("Excel.Application")
excel.set("Visible", true)

// Открыть книгу:
var books = excel.get("Workbooks")
var book  = books.call("Open", "C:\\data.xlsx")
var sheet = book.call("Worksheets", 1)

// Читать/писать ячейку:
var cell = sheet.call("Range", "A1")
cell.set("Value", "Hello from Wren!")
var val  = cell.get("Value")
Logger.print("A1 = " + val.toString + "\n")

// Chaining (промежуточные объекты авто-освобождаются):
var v = excel.get("Workbooks").callR("Item", 1).callR("Sheets", "Sheet1").callR("Range","B2").getR("Value")

// Закрыть и освободить:
book.call("Save")
excel.call("Quit")
excel.release()

// Проверить на null:
if (excel.isNull) { Logger.warn("Excel not found\n") }
```

---

## Wren — синтаксические особенности

```wren
// Wren НЕ использует ; в конце строк!
var x = 42
var s = "hello"

// Строковая интерполяция — % вместо $:
var name = "World"
Logger.print("Hello %(name)!\n")
// ОСТОРОЖНО: % внутри строки начинает интерполяцию → экранировать как \%

// Условие:
if (x > 10) {
    Logger.print("big\n")
} else {
    Logger.print("small\n")
}

// Цикл:
for (i in 0...10) {
    System.print(i)
}

// Список:
var items = ["apple", "banana", "cherry"]
for (item in items) {
    Logger.print(item + "\n")
}

// Сравнение строк:
// Wren String НЕ реализует < → использовать StringUtil.less из utils.wren
// Не использовать "a" < "b" — Runtime error!

// Приватные методы: суффикс _, не префикс:
class MyClass {
    static publicMethod() { privateHelper_() }
    static privateHelper_() { }  // OK
    // static _privateHelper() { }  // ОШИБКА в статическом методе!
}

// Trim встроен: "  hello  ".trim
// toString встроен: 42.toString  true.toString
// Строка не реализует < → ошибка при сортировке. Используй StringUtil.less

// Импорт файла:
import "utils" for StringUtil, ListUtil
// ListUtil.sort(list) — сортировка
// StringUtil.less(a, b) — сравнение строк

// Загрузить с пути:
vm.addLibPath("wren/lib");   // добавить путь поиска (D-side)
// Тогда: import "utils" найдёт wren/lib/utils.wren
```

---

## Паттерн: обновление UI при обработке данных

```d
// D: обработка данных + обновление UI через Wren
void processData(string[] items) {
    foreach (i, item; items) {
        // Прогресс:
        vm.argDouble(1, cast(double)i);
        vm.argDouble(2, cast(double)items.length);
        vm.call("main", "UI", "setProgress(_,_)");

        // Статус:
        vm.argString(1, "Processing: " ~ item);
        vm.call("main", "UI", "setStatus(_)");

        QCoreApplication.processEvents();  // обновить UI
    }
    vm.call("main", "UI", "done()");
}
```

```wren
class UI {
    static setProgress(current, total) {
        var pct = (current / total * 100).floor
        Widgets.get("progress").setValue(pct)
    }
    static setStatus(text) {
        Widgets.get("status").setText(text)
    }
    static done() {
        Widgets.get("status").setText("Done!")
        Widgets.get("progress").setValue(100)
    }
}
```

---

## Паттерн: горячая перезагрузка логики

```d
// Перезагрузить .wren при изменении файла:
extern(C) void onFileChanged(void* dt, string path) {
    vm.clearWidgets();
    // Перерегистрировать виджеты:
    vm.setWidget("lbl", g_lbl.getWH());
    vm.setWidget("btn", g_btn.getWH());
    // Перезагрузить скрипт:
    int rc = vm.loadFile("logic.wren");
    if (rc != 0)
        writeln("Wren reload failed");
    else
        writeln("Wren reloaded OK");
}
// Подключить к QFileSystemWatcher:
watcher.connect_fileChanged((string path) {
    onFileChanged(null, path);
});
watcher.addPath("logic.wren");
```

---

## Gotchas

```
1. LoadWren() вызывать ДО new WrenVM() — как LoadQt() перед new QApplication().
2. vm.free() обязателен (или ~this вызовет автоматически при GC).
3. argXxx слоты с 1, НЕ с 0 (0 = receiver, управляет DLL).
4. Wren: нет ";" в конце строк!
5. Wren: % в строке — начало интерполяции. Экранируй как \%.
6. Wren: String не реализует < → использовать StringUtil.less(a,b).
7. Wren String.trim() — встроен, НЕ определять в utils.wren.
8. Приватные статические методы Wren: суффикс name_, НЕ префикс _name.
9. OLE get("prop") — только без параметров. С параметрами → call().
10. OleObject.isNull проверять перед использованием.
11. vm.call() возвращает 0=OK, 1=compile, 2=runtime. Всегда проверять!
12. Wren НЕ поддерживает ';' — многострочные выражения через '\n'.
13. Незарегистрированный Widgets.get("x") → Widget с null ptr, молча игнорирует вызовы.
14. connect_activated в QSystemTrayIcon — прямой cb, не через Wren!
    Используй ESlot в D → vm.call("main","Handler","onTray()") из callback.
```
