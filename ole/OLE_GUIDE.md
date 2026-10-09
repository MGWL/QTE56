# OLE Automation for D — Руководство

> ↑ Навигация: [AGENTS.md](../AGENTS.md)

## Что это

Подсистема OLE Automation позволяет из D-программ управлять любыми Windows COM/OLE-серверами:
Excel, Word, Access, PowerPoint, Outlook, Internet Explorer, Scripting.FileSystemObject,
Scripting.Dictionary, WScript.Shell, ADODB и любыми другими приложениями, поддерживающими
IDispatch (OLE Automation).

Архитектура: тонкая C-shim DLL (`ole_helper.dll`) оборачивает COM IDispatch API,
D получает высокоуровневые классы `OleObject` и `OleVariant` через `LoadLibraryA`/`GetProcAddress`.

**Полностью автономен** — не использует pFunQt, QTE56 loader, registerModule.

## Структура файлов

```
arch_new/ole/
├── c/
│   ├── ole_helper.h      — C header (29 экспортируемых функций)
│   ├── ole_helper.c       — реализация COM/IDispatch
│   └── build.bat          — MinGW gcc → ole_helper.dll
├── d/
│   ├── ole_automation.d   — OleVariant + OleObject + загрузка DLL
│   ├── ole_excel.d        — ExcelApp / ExcelWorkbook / ExcelSheet (convenience)
│   ├── ole_dao.d          — DAO 3.6 (Access .mdb, только 32-bit)
│   ├── ole_adox.d         — ADOX через OLE DB (MDB/ACCDB, рекомендуется)
│   ├── test_ole.d         — тест: FSO + Dictionary (без Office)
│   └── test_excel.d       — тест: Excel (требует Office)
├── build_test.bat         — сборка + запуск
└── OLE_GUIDE.md           — это руководство
```

## Сборка

### 1. Собрать DLL

```bat
cd arch_new\ole\c
build.bat
```

Или вручную:

```bat
gcc -shared -m32 -o ole_helper.dll ole_helper.c -lole32 -loleaut32 -luuid -Wl,--kill-at
```

### 2. Скопировать DLL рядом с exe

```bat
copy ole\c\ole_helper.dll .
```

### 3. Скомпилировать D-программу

```bat
dmd -m32 -of=myapp.exe myapp.d ole\d\ole_automation.d
```

Если используется `ole_excel.d`:

```bat
dmd -m32 -of=myapp.exe myapp.d ole\d\ole_automation.d ole\d\ole_excel.d
```

---

## Быстрый старт

### Минимальный пример: FileSystemObject

```d
import ole_automation;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto fso = new OleObject("Scripting.FileSystemObject");

    // Вызов метода с аргументом
    auto result = fso.call("GetExtensionName", OleVariant.fromString("report.xlsx"));
    assert(result.asString() == "xlsx");
    result.clear();  // освобождаем BSTR

    // Метод с boolean результатом
    auto exists = fso.call("FileExists", OleVariant.fromString(`C:\Windows\notepad.exe`));
    assert(exists.asBool() == true);

    fso.release();
    oleUninit();
    unloadOleHelper();
}
```

### Минимальный пример: Dictionary

```d
import ole_automation;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto dict = new OleObject("Scripting.Dictionary");

    dict.callVoid("Add", OleVariant.fromString("name"), OleVariant.fromString("Alice"));
    dict.callVoid("Add", OleVariant.fromString("age"),  OleVariant.fromInt(30));

    int count = dict.getInt("Count");    // → 2
    auto val  = dict.get("Item", OleVariant.fromString("name"));
    string name = val.asString();        // → "Alice"
    val.clear();

    dict.release();
    oleUninit();
    unloadOleHelper();
}
```

---

## API Reference

### Жизненный цикл

| Функция | Описание |
|---------|----------|
| `loadOleHelper(path)` | Загрузить `ole_helper.dll`. Идемпотентна — повторный вызов игнорируется. По умолчанию `path = "ole_helper.dll"` |
| `unloadOleHelper()` | Выгрузить DLL. Вызывать в самом конце, после `oleUninit()` |
| `oleInit()` | `CoInitializeEx(COINIT_APARTMENTTHREADED)`. Вызывать один раз в начале |
| `oleUninit()` | `CoUninitialize()`. Вызывать после `release()` всех объектов |

**Порядок вызовов:**

```
loadOleHelper()  →  oleInit()  →  ... работа ...  →  oleUninit()  →  unloadOleHelper()
```

### OleVariant

Структура 16 байт, совпадает по layout с Windows `VARIANT`. Передаётся между D и C по значению.

#### Создание

| Фабричный метод | Тип | Пример |
|-----------------|-----|--------|
| `OleVariant.fromInt(42)` | VT_I4 (int) | Целые числа |
| `OleVariant.fromDouble(3.14)` | VT_R8 (double) | Дробные числа |
| `OleVariant.fromString("text")` | VT_BSTR | Строки (D `string` → UTF-8 → BSTR) |
| `OleVariant.fromBool(true)` | VT_BOOL | Логические значения |
| `OleVariant.fromDate(45658.0)` | VT_DATE | Даты OLE Automation (double, дни с 30.12.1899) |
| `OleVariant.fromDispatch(ptr)` | VT_DISPATCH | Обёртка IDispatch* |
| `OleVariant.empty()` | VT_EMPTY | Пустое значение |

#### Извлечение

| Метод | Возвращает | Когда использовать |
|-------|------------|-------------------|
| `.asInt()` | `int` | VT_I4, Count и т.д. |
| `.asDouble()` | `double` | VT_R8, числовые ячейки Excel |
| `.asString()` | `string` | VT_BSTR, строки |
| `.asBool()` | `bool` | VT_BOOL, логические свойства |
| `.asDate()` | `double` | VT_DATE, даты Excel |
| `.asDispatch()` | `void*` | VT_DISPATCH, дочерние объекты |
| `.type()` | `ushort` | Узнать VT-тип перед извлечением |

#### Очистка

```d
auto v = OleVariant.fromString("hello");
// ... использование ...
v.clear();   // освобождает BSTR через SysFreeString
```

**Правило:** вызывать `.clear()` для вариантов с `VT_BSTR`, полученных из `fromString()` или
из результатов вызовов (`.call()`, `.get()`). Для `VT_I4`, `VT_R8`, `VT_BOOL` — clear не нужен,
но не повредит.

#### Определение типа

```d
auto v = obj.get("Value");
switch (v.type()) {
    case OleVariant.VT_I4:       writeln("int: ", v.asInt()); break;
    case OleVariant.VT_R8:       writeln("double: ", v.asDouble()); break;
    case OleVariant.VT_BSTR:     writeln("string: ", v.asString()); v.clear(); break;
    case OleVariant.VT_BOOL:     writeln("bool: ", v.asBool()); break;
    case OleVariant.VT_DISPATCH: writeln("object"); break;
    case OleVariant.VT_EMPTY:    writeln("(empty)"); break;
    default:                     writeln("unknown VT=", v.type()); break;
}
```

### OleObject

Обёртка над `IDispatch*`. Создаётся из ProgID или из существующего указателя.

#### Создание

```d
// По ProgID — вызывает CLSIDFromProgID + CoCreateInstance
auto app = new OleObject("Excel.Application");
auto fso = new OleObject("Scripting.FileSystemObject");
auto dict = new OleObject("Scripting.Dictionary");
auto shell = new OleObject("WScript.Shell");

// Из указателя — для дочерних объектов (получены через getObject/callObject)
auto sheet = new OleObject(dispatchPtr);

// Привязка к уже запущенному экземпляру (GetActiveObject).
// Возвращает null, если экземпляр не запущен (детали — lastError()).
auto running = OleObject.attachActive("Excel.Application");

// Привязка к запущенному, иначе создание нового
// (эквивалент VBS: GetObject → fallback CreateObject)
auto app2 = OleObject.attachOrCreate("Excel.Application");
```

#### Чтение свойств (Property Get)

| Метод | Описание |
|-------|----------|
| `obj.get("Name")` | Возвращает `OleVariant` |
| `obj.get("Item", OleVariant.fromString("key"))` | Property get с аргументом (indexed property) |
| `obj.getInt("Count")` | Shortcut: `.get().asInt()` |
| `obj.getDouble("Value")` | Shortcut: `.get().asDouble()` |
| `obj.getString("Name")` | Shortcut: `.get().asString()` |
| `obj.getBool("Visible")` | Shortcut: `.get().asBool()` |
| `obj.getObject("Workbooks")` | Shortcut: `.get().asDispatch()` → `new OleObject(...)` |
| `obj.getObject("Range", OleVariant.fromString("A1"))` | То же для property с аргументами (Excel `Range`, `Item`) |

```d
// Простое свойство
string name = obj.getString("Name");
int count = obj.getInt("Count");

// Indexed property (свойство с аргументами)
auto val = dict.get("Item", OleVariant.fromString("key"));

// Дочерний объект
auto workbooks = app.getObject("Workbooks");
// ... работа с workbooks ...
workbooks.release();
```

#### Установка свойств (Property Put)

```d
obj.set("Visible", 1);           // int
obj.set("Visible", true);        // bool
obj.set("Value", 3.14);          // double
obj.set("Value", "Hello!");      // string
```

Перегрузки `set` для всех базовых типов: `int`, `double`, `string`, `bool`, а также
`set(prop, OleVariant)` — для любых VT-типов (например, VT_DATE).

#### Вызов методов

| Метод | Описание |
|-------|----------|
| `obj.call("Method", args...)` | Вызвать метод, получить `OleVariant` результат |
| `obj.callVoid("Method", args...)` | Вызвать метод без результата |
| `obj.callObject("Method", args...)` | Вызвать метод, результат — `OleObject` |
| `obj.callString("Method", args...)` | Вызвать метод, результат — `string` |
| `obj.callInt("Method", args...)` | Вызвать метод, результат — `int` |

```d
// Без аргументов
auto wb = wbs.callObject("Add");
auto tmpName = fso.callString("GetTempName");

// С одним аргументом
auto ext = fso.callString("GetExtensionName", OleVariant.fromString("file.txt"));

// С несколькими аргументами
auto path = fso.callString("BuildPath",
                            OleVariant.fromString(`C:\Users`),
                            OleVariant.fromString("file.txt"));

// Метод без возврата
dict.callVoid("Add", OleVariant.fromString("key"), OleVariant.fromString("value"));
dict.callVoid("RemoveAll");
app.callVoid("Quit");
```

#### Освобождение

```d
obj.release();   // явный Release IDispatch — рекомендуется
// или: destroy(obj);
// или: GC сделает Release в деструкторе (ненадёжно — см. Gotchas)
```

#### Перечисление коллекций (_NewEnum / For Each)

COM-коллекции можно перебирать через `OleEnum` (обёртка `IEnumVARIANT`):

```d
auto sheets = wb.getObject("Sheets");
auto en = sheets.beginEnum();       // бросает Exception если _NewEnum не поддержан
scope(exit) en.release();

OleVariant v;
while (en.next(v)) {                 // false — конец перечисления
    if (v.type == OleVariant.VT_DISPATCH) {
        auto sh = new OleObject(v.asDispatch());  // забирает владение ссылкой
        writeln(sh.getString("Name"));
        sh.release();
    } else {
        v.clear();
    }
}

// Короткая форма — только VT_DISPATCH элементы:
OleObject[] items = sheets.collectObjects();
// ... не забыть release() каждого элемента ...
```

#### Даты (VT_DATE)

OLE Automation date — `double`, число дней с 30.12.1899:

```d
auto v = OleVariant.fromDate(45658.0);   // VT_DATE
range.set("Value", v);                    // set(prop, OleVariant) — любой VT-тип

double d = range.get("Value").asDate();   // чтение VT_DATE
```

В `ole_excel.d` есть конвертеры `dateToOle(std.datetime.Date)` и `oleToDate(double)`,
а также `ExcelSheet.setCellDate()` / `getCellDate()`.

### Ошибки

Все методы `OleObject` кидают `Exception` при ошибке COM:

```d
try {
    auto obj = new OleObject("NonExistent.ProgID");
} catch (Exception e) {
    writeln("Error: ", e.msg);
    // "Cannot create COM object: NonExistent.ProgID — CLSIDFromProgID failed (HRESULT=0x...)"
}
```

Для низкоуровневой диагностики:

```d
string err = lastError();     // текст последней ошибки (UTF-8)
int hr = lastHresult();       // HRESULT последней ошибки
```

---

## Примеры

### Пример 1: FileSystemObject — работа с путями

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto fso = new OleObject("Scripting.FileSystemObject");

    // Разбор пути
    writeln("Drive: ",     fso.callString("GetDriveName",        OleVariant.fromString(`C:\Projects\app.exe`)));
    writeln("Parent: ",    fso.callString("GetParentFolderName", OleVariant.fromString(`C:\Projects\app.exe`)));
    writeln("FileName: ",  fso.callString("GetFileName",         OleVariant.fromString(`C:\Projects\app.exe`)));
    writeln("BaseName: ",  fso.callString("GetBaseName",         OleVariant.fromString(`C:\Projects\app.exe`)));
    writeln("Extension: ", fso.callString("GetExtensionName",    OleVariant.fromString(`C:\Projects\app.exe`)));
    // Drive: C:
    // Parent: C:\Projects
    // FileName: app.exe
    // BaseName: app
    // Extension: exe

    // Склейка пути
    string fullPath = fso.callString("BuildPath",
        OleVariant.fromString(`C:\Projects`),
        OleVariant.fromString("output.txt"));
    writeln("BuildPath: ", fullPath);
    // BuildPath: C:\Projects\output.txt

    // Проверка существования
    bool notepadExists = fso.call("FileExists",
        OleVariant.fromString(`C:\Windows\notepad.exe`)).asBool();
    writeln("notepad.exe exists: ", notepadExists);  // true

    bool folderExists = fso.call("FolderExists",
        OleVariant.fromString(`C:\Windows`)).asBool();
    writeln("C:\\Windows exists: ", folderExists);    // true

    // Временное имя
    string tmpName = fso.callString("GetTempName");
    writeln("Temp name: ", tmpName);  // radXXXXX.tmp

    fso.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 2: Dictionary — ассоциативный массив

```d
import ole_automation;
import std.stdio : writeln;
import std.conv : to;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto dict = new OleObject("Scripting.Dictionary");

    // Добавление элементов разных типов
    dict.callVoid("Add", OleVariant.fromString("name"),    OleVariant.fromString("Bob"));
    dict.callVoid("Add", OleVariant.fromString("age"),     OleVariant.fromInt(25));
    dict.callVoid("Add", OleVariant.fromString("score"),   OleVariant.fromDouble(92.5));
    dict.callVoid("Add", OleVariant.fromString("active"),  OleVariant.fromBool(true));

    writeln("Count: ", dict.getInt("Count"));  // 4

    // Чтение по ключу (indexed property)
    string name  = dict.get("Item", OleVariant.fromString("name")).asString();
    int    age   = dict.get("Item", OleVariant.fromString("age")).asInt();
    double score = dict.get("Item", OleVariant.fromString("score")).asDouble();
    writeln(name, ", age=", age, ", score=", score);
    // Bob, age=25, score=92.5

    // Проверка наличия ключа
    bool has = dict.call("Exists", OleVariant.fromString("name")).asBool();
    writeln("Has 'name': ", has);   // true
    bool hasX = dict.call("Exists", OleVariant.fromString("xxx")).asBool();
    writeln("Has 'xxx': ", hasX);   // false

    // Удаление
    dict.callVoid("Remove", OleVariant.fromString("age"));
    writeln("Count after Remove: ", dict.getInt("Count"));  // 3

    // Очистка всего
    dict.callVoid("RemoveAll");
    writeln("Count after RemoveAll: ", dict.getInt("Count"));  // 0

    dict.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 3: WScript.Shell — системные операции

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto shell = new OleObject("WScript.Shell");

    // Переменные окружения
    auto expanded = shell.call("ExpandEnvironmentStrings",
        OleVariant.fromString("%USERPROFILE%"));
    writeln("Home: ", expanded.asString());
    expanded.clear();

    // Текущая директория
    string curDir = shell.getString("CurrentDirectory");
    writeln("CWD: ", curDir);

    // Чтение реестра (осторожно — может потребовать прав)
    try {
        auto val = shell.call("RegRead",
            OleVariant.fromString(`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName`));
        writeln("Windows: ", val.asString());
        val.clear();
    } catch (Exception e) {
        writeln("RegRead failed: ", e.msg);
    }

    shell.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 4: Excel — чтение/запись ячеек

> Требует установленный Microsoft Excel.

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    // Создать Excel (невидимый)
    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    // Новая книга
    auto wbs = app.getObject("Workbooks");
    auto wb  = wbs.callObject("Add");
    auto ws  = wb.getObject("ActiveSheet");

    // Записать значения
    auto cellA1 = ws.getObject("Range", OleVariant.fromString("A1"));
    cellA1.set("Value", "Hello from D!");
    cellA1.release();

    auto cellB1 = ws.getObject("Range", OleVariant.fromString("B1"));
    cellB1.set("Value", 42.0);
    cellB1.release();

    auto cellC1 = ws.getObject("Range", OleVariant.fromString("C1"));
    cellC1.set("Value", 100);
    cellC1.release();

    // Прочитать обратно
    auto readA1 = ws.getObject("Range", OleVariant.fromString("A1"));
    writeln("A1 = ", readA1.getString("Value"));   // "Hello from D!"
    readA1.release();

    auto readB1 = ws.getObject("Range", OleVariant.fromString("B1"));
    writeln("B1 = ", readB1.getDouble("Value"));   // 42
    readB1.release();

    // Закрыть без сохранения
    wb.callVoid("Close", OleVariant.fromInt(0));

    ws.release();
    wb.release();
    wbs.release();

    app.callVoid("Quit");
    app.release();

    oleUninit();
    unloadOleHelper();
}
```

### Пример 5: Excel — convenience API через ole_excel.d

```d
import ole_automation;
import ole_excel;
import std.stdio : writeln;

void main() {
    auto excel = new ExcelApp(false, "ole_helper.dll");  // invisible
    auto wb = excel.addWorkbook();       // ExcelWorkbook
    auto sheet = wb.activeSheet();       // ExcelSheet

    sheet.setCellValue("A1", "Name");
    sheet.setCellValue("B1", "Score");
    sheet.setCellValue("A2", "Alice");
    sheet.setCellValue("B2", 95.5);
    sheet.setCellValue("A3", "Bob");
    sheet.setCellValue("B3", 87.0);

    writeln(sheet.getCellString("A2"), ": ", sheet.getCellDouble("B2"));
    // Alice: 95.5

    wb.close(false);   // Close без сохранения
    destroy(wb);
    excel.quit();
    destroy(excel);
}
```

API обёрток `ole_excel.d`:

| Класс | Методы |
|-------|--------|
| `ExcelApp` | `attach()` / `attachOrCreate()` (привязка к запущенному Excel), `addWorkbook()`, `openWorkbook(path)`, `workbook(i)`, `workbookByName(name)`, `workbookCount()`, `activeWorkbook()`, `activeSheet()`, `activate()` (xlNormal), `quit()` |
| `ExcelWorkbook` | `name()`, `fullName()`, `sheetCount()`, `sheet(i)` / `sheet(name)`, `sheetNames()`, `activeSheet()`, `save()`, `saveAs(path, format=51)`, `close(save=false)` |
| `ExcelSheet` | `name()`, `activate()`, `setCellValue(addr, string/double/int)`, `setCellDate(addr, oleDate)`, `setCellFormula(addr, "=...")`, `setNumberFormat(addr, fmt)`, `getCellString/Double/Date/Value(addr)` |

### Пример 6: Excel — сохранение файла

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    auto wbs = app.getObject("Workbooks");
    auto wb  = wbs.callObject("Add");
    auto ws  = wb.getObject("ActiveSheet");

    // Заполнить данные
    for (int i = 1; i <= 10; i++) {
        import std.conv : to;
        string cell = "A" ~ to!string(i);
        auto range = ws.getObject("Range", OleVariant.fromString(cell));
        range.set("Value", i * 10);
        range.release();
    }

    // Сохранить как .xlsx
    // xlOpenXMLWorkbook = 51
    wb.callVoid("SaveAs",
        OleVariant.fromString(`C:\temp\test_from_d.xlsx`),
        OleVariant.fromInt(51));

    wb.callVoid("Close", OleVariant.fromInt(0));
    ws.release();
    wb.release();
    wbs.release();
    app.callVoid("Quit");
    app.release();

    oleUninit();
    unloadOleHelper();
    writeln("Saved to C:\\temp\\test_from_d.xlsx");
}
```

### Пример 7: Перебор коллекции (Sheets)

COM-коллекции доступны через индексированные свойства `.get("Item", index)`:

```d
import ole_automation;
import std.stdio : writeln;
import std.conv : to;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    auto wbs = app.getObject("Workbooks");
    auto wb  = wbs.callObject("Add");

    auto sheets = wb.getObject("Sheets");
    int count = sheets.getInt("Count");
    writeln("Sheet count: ", count);

    // COM-коллекции индексируются с 1
    for (int i = 1; i <= count; i++) {
        auto sheet = sheets.getObject("Item", OleVariant.fromInt(i));
        writeln("  Sheet ", i, ": ", sheet.getString("Name"));
        sheet.release();
    }

    sheets.release();
    wb.callVoid("Close", OleVariant.fromInt(0));
    wb.release();
    wbs.release();
    app.callVoid("Quit");
    app.release();

    oleUninit();
    unloadOleHelper();
}
```

### Пример 8: Навигация по цепочке объектов

Типичный паттерн COM — цепочка `Application → Workbooks → Workbook → Sheet → Range → Value`:

```d
// Длинная форма (с ручным release)
auto app = new OleObject("Excel.Application");
auto wbs = app.getObject("Workbooks");
auto wb  = wbs.callObject("Add");
auto ws  = wb.getObject("ActiveSheet");
auto rng = ws.getObject("Range", OleVariant.fromString("A1"));
rng.set("Value", "test");
string val = rng.getString("Value");

// Cleanup в обратном порядке
rng.release();
ws.release();
wb.release();
wbs.release();
app.callVoid("Quit");
app.release();
```

### Пример 9: Обработка ошибок

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    // 1. Несуществующий ProgID
    try {
        auto obj = new OleObject("This.Does.Not.Exist");
    } catch (Exception e) {
        writeln("Expected error: ", e.msg);
        // "Cannot create COM object: This.Does.Not.Exist — CLSIDFromProgID failed (...)"
    }

    // 2. Несуществующее свойство
    auto fso = new OleObject("Scripting.FileSystemObject");
    try {
        fso.getInt("NonExistentProperty");
    } catch (Exception e) {
        writeln("Expected error: ", e.msg);
        // "get('NonExistentProperty') failed: GetIDsOfNames failed (...)"
    }

    // 3. Проверить HRESULT вручную
    writeln("Last HRESULT: 0x", lastHresult());

    fso.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 10: Word Automation

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto word = new OleObject("Word.Application");
    word.set("Visible", 0);

    auto docs = word.getObject("Documents");
    auto doc  = docs.callObject("Add");

    // Вставить текст в текущую позицию
    auto selection = word.getObject("Selection");
    selection.callVoid("TypeText", OleVariant.fromString("Hello from D!"));
    selection.callVoid("TypeParagraph");
    selection.callVoid("TypeText", OleVariant.fromString("This document was created via OLE Automation."));

    // Сохранить как docx (wdFormatXMLDocument = 12)
    doc.callVoid("SaveAs2",
        OleVariant.fromString(`C:\temp\test_from_d.docx`),
        OleVariant.fromInt(12));

    selection.release();
    doc.callVoid("Close", OleVariant.fromInt(0));
    doc.release();
    docs.release();

    word.callVoid("Quit");
    word.release();

    oleUninit();
    unloadOleHelper();
    writeln("Word document saved.");
}
```

---

## Gotchas и важные особенности

### 1. Порядок инициализации и очистки

Строго соблюдать порядок:

```
loadOleHelper() → oleInit() → ... → release() всех объектов → oleUninit() → unloadOleHelper()
```

Нарушение порядка приведёт к утечкам COM или крашам.

### 2. Всегда вызывать release()

**Не полагаться на GC для Release COM-объектов.** GC деструкторы в D вызываются
в непредсказуемом порядке и могут сработать после `unloadOleHelper()`, когда DLL уже выгружена.

```d
// ХОРОШО — явный release
auto obj = new OleObject("...");
// ... работа ...
obj.release();

// ПЛОХО — надежда на GC
auto obj = new OleObject("...");
// ... obj утекает в никуда ...
```

Деструктор `~this()` проверяет `g_loaded` и безопасно пропускает Release если DLL выгружена,
но это означает утечку COM-объекта до конца процесса.

### 3. Очистка BSTR вариантов

`OleVariant` с `VT_BSTR` содержит BSTR (COM-строку, выделенную через `SysAllocString`).
Вызывать `.clear()` для освобождения:

```d
auto v = obj.call("GetName");
string s = v.asString();  // копирует данные в D string
v.clear();                 // освобождает BSTR
```

Для `fromString()` аргументов, переданных в `.call()` / `.set()` — BSTR аргументов
не нужно очищать, если они одноразовые (temporary). Но при повторном использовании:

```d
auto arg = OleVariant.fromString("reusable");
obj.call("Method1", arg);
obj.call("Method2", arg);
arg.clear();  // очистить когда больше не нужен
```

### 4. COM-коллекции индексируются с 1

В отличие от D/C, COM-коллекции начинаются с 1:

```d
// ПРАВИЛЬНО
for (int i = 1; i <= count; i++) {
    auto item = collection.getObject("Item", OleVariant.fromInt(i));
    // ...
}

// НЕПРАВИЛЬНО — Item(0) может бросить исключение
auto first = collection.getObject("Item", OleVariant.fromInt(0));
```

### 5. Property Get с аргументами vs Method Call

Многие COM-объекты реализуют «методы» как indexed properties (Property Get с аргументами).
Для них `.call()` (флаг `DISPATCH_METHOD`) завершается ошибкой
`DISP_E_MEMBERNOTFOUND (0x80020003)` — используйте `.get()` / `.getObject()`:

```d
// Dictionary: Item — это property, не method
auto val = dict.get("Item", OleVariant.fromString("key"));   // OK — PROPERTYGET
// auto val = dict.call("Item", OleVariant.fromString("key"));  // НЕ работает

// Excel: Range и Item — тоже properties
auto rng = ws.getObject("Range", OleVariant.fromString("A1"));       // OK
// auto rng = ws.callObject("Range", OleVariant.fromString("A1"));   // НЕ работает
```

Правило: если член объекта описан в документации как *Property* (Excel: `Range`, `Item`,
`Cells`, `Rows`, `Columns`) — только `get`/`getObject`. Настоящие методы
(`Open`, `Add`, `SaveAs`, `Close`, `Quit`) вызываются через `call`/`callObject`.

### 6. Числа в Excel всегда double

Excel хранит все числа как `double`. Даже если записать `int`:

```d
range.set("Value", 42);           // записывает int
double v = range.getDouble("Value");  // читать как double (42.0)
// range.getInt("Value");           // может не работать — COM вернёт VT_R8
```

Если нужен int, конвертируйте: `cast(int) range.getDouble("Value")`.

### 7. void main() — не extern(C)

Использовать D-main (`void main()`), не `extern(C) int main()`.
Иначе `static this()` не выполнится (это общее правило D, не специфика OLE):

```d
void main() { ... }           // ПРАВИЛЬНО
// extern(C) int main() { ... }  // НЕПРАВИЛЬНО
```

### 8. Только STA (Single-Threaded Apartment)

OLE Automation требует `COINIT_APARTMENTTHREADED` (STA). `oleInit()` использует STA.
Не вызывать COM-методы из других потоков без собственного `CoInitializeEx`.

### 9. DisplayAlerts

Для автоматических операций с Office отключать диалоги:

```d
app.set("DisplayAlerts", 0);  // Excel, Word
```

Иначе при Close/Quit могут всплыть диалоги «Сохранить изменения?», и программа зависнет.

### 10. Константы Office

Распространённые константы для SaveAs:

| Формат | Константа | Значение |
|--------|-----------|----------|
| Excel .xlsx | xlOpenXMLWorkbook | 51 |
| Excel .xls | xlWorkbookNormal | -4143 |
| Excel .csv | xlCSV | 6 |
| Word .docx | wdFormatXMLDocument | 12 |
| Word .pdf | wdFormatPDF | 17 |

```d
wb.callVoid("SaveAs", OleVariant.fromString(path), OleVariant.fromInt(51));
```

### 11. Таймауты и зависания

COM-серверы (особенно Office) могут зависнуть, если:
- Открыт модальный диалог (Print, Save As вручную)
- Другой процесс блокирует файл
- COM-сервер упал

D-программа будет ждать бесконечно. Решение: `app.set("DisplayAlerts", 0)` +
`app.set("Visible", 0)` для фоновой работы.

### 12. Занятый сервер: RPC_E_CALL_REJECTED и busy-retry

COM-вызов синхронен, но сервер Excel имеет право **отклонить** вызов, когда занят:
режим редактирования ячейки (пользователь печатает), модальный диалог, пересчёт,
старт процесса. При этом возвращается HRESULT:

| HRESULT | Имя | Значение |
|---------|-----|----------|
| `0x80010001` | RPC_E_CALL_REJECTED | сервер отклонил вызов |
| `0x8001010A` | RPC_E_SERVERCALL_RETRYLATER | сервер просит повторить позже |
| `0x800AC472` | VBA_E_IGNORE | Excel/VBA игнорирует вызов |

Отказ **временный** — через десятки-сотни миллисекунд сервер принимает вызовы.
`ole_automation.d` автоматически повторяет такие вызовы (busy-retry):
по умолчанию до 50 повторов с паузой 100 мс (≈5 с ожидания). Повторяются
`new OleObject(progid)`, все `get`/`set`, `call`/`callVoid`, `beginEnum()`.

Настройка (глобальная, на процесс):

```d
oleSetBusyRetry(100, 50);   // 100 повторов × 50 мс
oleSetBusyRetry(0);         // отключить повторы (старое поведение)
int mr, d; oleGetBusyRetry(mr, d);   // прочитать настройки

// Логгер для диагностики гонок:
oleSetRetryLogger((int attempt, int hr) {
    writefln("retry #%d, HR=0x%08X", attempt, hr);
});
oleSetRetryLogger(null);    // отключить
```

Если повторы исчерпаны, бросается Exception с пояснением
«сервер занят (RPC_E_CALL_REJECTED), повторы исчерпаны».

Busy-HRESULT классифицирует функция `isBusyHresult(hr)` — полезна при работе
через `lastHresult()` напрямую.

Тест-репродьюсер: `apps/ole_test/test_visible_race.d` — сценарий F переводит
Excel в edit-mode (SendKeys F2) и проверяет, что команда проходит после retry.

---

## C Shim API (для разработчиков)

29 экспортируемых функций, все `extern "C"`, все имена — UTF-8 (`const char*`):

### Lifecycle

| Функция | Сигнатура |
|---------|-----------|
| `ole_init` | `int ole_init(void)` |
| `ole_uninit` | `void ole_uninit(void)` |
| `ole_create_object` | `void* ole_create_object(const char* progid)` |
| `ole_get_active_object` | `void* ole_get_active_object(const char* progid)` — привязка к запущенному экземпляру (NULL, если не запущен) |
| `ole_release` | `void ole_release(void* pDisp)` |

### Invoke

| Функция | Сигнатура |
|---------|-----------|
| `ole_invoke` | `int ole_invoke(void* pDisp, const char* name, int wFlags, ole_variant_t* args, int nArgs, ole_variant_t* result)` |
| `ole_get_property` | `int ole_get_property(void* pDisp, const char* name, ole_variant_t* args, int nArgs, ole_variant_t* result)` |
| `ole_set_property` | `int ole_set_property(void* pDisp, const char* name, ole_variant_t* args, int nArgs)` |

**wFlags**: `DISPATCH_METHOD=1`, `DISPATCH_PROPERTYGET=2`, `DISPATCH_PROPERTYPUT=4`.

### Variant

| Функция | Описание |
|---------|----------|
| `ole_var_init` | VariantInit (VT_EMPTY) |
| `ole_var_clear` | VariantClear (free BSTR и т.д.) |
| `ole_var_set_int` | Установить VT_I4 |
| `ole_var_set_double` | Установить VT_R8 |
| `ole_var_set_string` | UTF-8 → SysAllocStringLen → VT_BSTR |
| `ole_var_set_dispatch` | Установить VT_DISPATCH (без AddRef) |
| `ole_var_set_bool` | Установить VT_BOOL |
| `ole_var_set_empty` | Установить VT_EMPTY |
| `ole_var_get_type` | Вернуть vt |
| `ole_var_get_int` | Вернуть intVal |
| `ole_var_get_double` | Вернуть dblVal |
| `ole_var_get_string` | BSTR → UTF-8 в буфер, вернуть длину |
| `ole_var_get_dispatch` | Вернуть ptrVal |
| `ole_var_get_bool` | Вернуть 0 или 1 |

### Enumeration (_NewEnum / For Each)

| Функция | Описание |
|---------|----------|
| `ole_enum_begin` | `void* ole_enum_begin(void* pDisp)` → `IEnumVARIANT*` (NULL при ошибке) |
| `ole_enum_next` | `int ole_enum_next(void* pEnum, ole_variant_t* result)` — 1 = элемент получен, 0 = конец |
| `ole_enum_release` | `void ole_enum_release(void* pEnum)` |

### VT_DATE (даты OLE Automation, double)

| Функция | Описание |
|---------|----------|
| `ole_var_set_date` | Установить VT_DATE |
| `ole_var_get_date` | Вернуть dblVal |

### Error

| Функция | Описание |
|---------|----------|
| `ole_last_error` | `const char*` — thread-local UTF-8 строка ошибки |
| `ole_last_hresult` | `int` — последний HRESULT |

### Внутренние решения C-шима

- **DISPPARAMS reverse**: COM требует аргументы в обратном порядке. C-шим автоматически
  реверсирует массив `args` перед передачей в `IDispatch::Invoke`.
- **PROPERTYPUT named arg**: Для `DISPATCH_PROPERTYPUT` C-шим добавляет
  `DISPID_PROPERTYPUT = -3` в `rgdispidNamedArgs`.
- **BSTR lifecycle**: `ole_var_set_string` вызывает `SysAllocStringLen`,
  `ole_var_clear` вызывает `SysFreeString`. Не смешивать с `malloc/free`.
- **UTF-8 → wchar_t**: Все строковые параметры принимаются как `const char*` UTF-8.
  Конвертация в `wchar_t*` через `MultiByteToWideChar` на стеке C-шима.
  Это исключает GC-проблемы D (GC может собрать `wchar[]` от `toUTF16` до
  завершения вызова COM — проверено на практике, баг был найден и исправлен).
- **Thread-local error**: Ошибки хранятся в `__thread` переменных — безопасно для многопоточности.

---

## Совместимые COM-серверы

Любой сервер с IDispatch (OLE Automation). Проверенные:

| ProgID | Что это | Требует |
|--------|---------|---------|
| `Scripting.FileSystemObject` | Работа с файлами/путями | Встроен в Windows |
| `Scripting.Dictionary` | Ассоциативный массив | Встроен в Windows |
| `WScript.Shell` | Среда, реестр, запуск процессов | Встроен в Windows |
| `WScript.Network` | Сетевые ресурсы, принтеры | Встроен в Windows |
| `Excel.Application` | Microsoft Excel | Office |
| `Word.Application` | Microsoft Word | Office |
| `PowerPoint.Application` | Microsoft PowerPoint | Office |
| `Outlook.Application` | Microsoft Outlook | Office |
| `Access.Application` | Microsoft Access | Office |
| `ADODB.Connection` | ADO Database | Встроен (MDAC) |
| `ADODB.Recordset` | ADO Recordset | Встроен (MDAC) |
| `Shell.Application` | Windows Shell | Встроен в Windows |
| `InternetExplorer.Application` | IE (deprecated) | Windows |

---

## Тесты

### Без Office (всегда работает)

```bat
cd arch_new
dmd -m32 -of=test_ole.exe ole\d\test_ole.d ole\d\ole_automation.d
test_ole.exe
```

26 проверок: FSO (11) + Dictionary (12) + инфраструктура (3).

### С Excel

```bat
cd arch_new
dmd -m32 -of=test_excel.exe ole\d\test_excel.d ole\d\ole_automation.d ole\d\ole_excel.d
test_excel.exe
```

Требует установленный Microsoft Excel.

---

## Навигация

- ↑ [AGENTS.md](../AGENTS.md) — точка входа
- ↓ Подробнее:
  - [OLE_KNOWLEDGE_TRANSFER.md](../OLE_KNOWLEDGE_TRANSFER.md) — полный справочник OLE
  - [TASK_DAO_ACE_INTEGRATION.md](../TASK_DAO_ACE_INTEGRATION.md) — интеграция DAO/ACE
