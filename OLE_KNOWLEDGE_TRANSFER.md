# OLE/COM Automation Subsystem — Knowledge Transfer Document

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [ole/OLE_GUIDE.md](ole/OLE_GUIDE.md)

Полный справочник для AI-ассистента по подсистеме OLE/COM в проекте QTE56.
Документ самодостаточен — AI, загрузивший этот файл, может ответить на любой вопрос
об OLE Automation из D без обращения к исходным файлам.

---

## 1. Архитектура

### 1.1 Слои системы

```
D-программа
   │  import ole_automation;
   ▼
OleObject / OleVariant  (ole_automation.d)
   │  LoadLibraryA + GetProcAddress
   ▼
ole_helper.dll  (ole_helper.c — C shim, 29 функций)
   │  COM IDispatch API
   ▼
Windows COM Runtime (ole32.dll, oleaut32.dll)
   │  CoCreateInstance / IDispatch::Invoke
   ▼
COM-сервер: Excel, Word, FSO, Dictionary, WScript.Shell, ADODB ...
```

### 1.2 Ключевые файлы

| Файл | Назначение |
|------|-----------|
| `ole/c/ole_helper.h` | C header: 29 экспортируемых функций C-шима |
| `ole/c/ole_helper.c` | Реализация COM/IDispatch (компилируется в ole_helper.dll) |
| `ole/c/build.bat` | `gcc -shared -m32 -o ole_helper.dll ole_helper.c -lole32 -loleaut32 -luuid -Wl,--kill-at` |
| `ole/d/ole_automation.d` | D-биндинги: `OleVariant`, `OleObject`, загрузка DLL |
| `ole/d/ole_excel.d` | Convenience-обёртки: `ExcelApp`, `ExcelSheet` |
| `ole/d/test_ole.d` | 26 тестов: FSO + Dictionary, без Office |
| `ole/d/test_excel.d` | Тесты Excel (требует Office) |

### 1.3 Автономность

Подсистема **полностью независима** от QTE56:
- Не использует `pFunQt[]`, `registerModule()`, `LoadQt()`
- Не требует Qt DLL, только `ole_helper.dll` рядом с exe
- Работает в любом D-проекте (dmd -m32) без Qt

---

## 2. Жизненный цикл

### 2.1 Обязательный порядок вызовов

```
loadOleHelper()  →  oleInit()  →  ... работа с COM ...  →  oleUninit()  →  unloadOleHelper()
```

**Нарушение порядка приводит к утечкам COM или крашам.**

### 2.2 Функции жизненного цикла

| D-функция | C-функция | Описание |
|-----------|-----------|----------|
| `loadOleHelper(path="ole_helper.dll")` | — | `LoadLibraryA` + `GetProcAddress` × 29. Идемпотентна: повторный вызов — no-op |
| `oleInit()` | `ole_init()` | `CoInitializeEx(NULL, COINIT_APARTMENTTHREADED)`. Бросает `Exception` при `hr < 0` |
| `oleUninit()` | `ole_uninit()` | `CoUninitialize()`. Вызывать после `release()` всех объектов |
| `unloadOleHelper()` | — | `FreeLibrary`. Вызывать самым последним |

### 2.3 Флаг g_loaded

`g_loaded` (`__gshared bool`) выставляется в `true` после успешного `loadOleHelper()`.
Деструктор `OleObject.~this()` проверяет этот флаг — если DLL уже выгружена,
`pOleRelease` не вызывается (предотвращает краш, но означает утечку COM-объекта).

---

## 3. OleVariant

### 3.1 Структура (VARIANT layout, 16 байт)

```d
struct OleVariant {
    align(1):
    ushort    vt;          // тип (VT_*)
    ushort[3] _reserved;
    union {
        int    intVal;     // VT_I4   = 3
        double dblVal;     // VT_R8   = 5
        void*  ptrVal;     // VT_BSTR = 8, VT_DISPATCH = 9
        short  boolVal;    // VT_BOOL = 11
    }
}
static assert(OleVariant.sizeof == 16);
```

Совпадает с Windows `VARIANT` по layout — передаётся между D и C по значению без копирования.

### 3.2 VT-константы

| Константа | Значение | Тип данных |
|-----------|---------|-----------|
| `OleVariant.VT_EMPTY` | 0 | Пустое значение |
| `OleVariant.VT_I4` | 3 | `int` (32-bit signed) |
| `OleVariant.VT_R8` | 5 | `double` (IEEE 754) |
| `OleVariant.VT_BSTR` | 8 | COM-строка (BSTR, выделена через `SysAllocString`) |
| `OleVariant.VT_DISPATCH` | 9 | `IDispatch*` — COM-объект |
| `OleVariant.VT_BOOL` | 11 | `VARIANT_TRUE=-1`, `VARIANT_FALSE=0` |
| `OleVariant.VT_DATE` | 7 | `double` — OLE Automation date (в C header: `OLE_VT_DATE`) |

### 3.3 Создание OleVariant (фабричные методы)

| Метод | VT | Описание |
|-------|----|----------|
| `OleVariant.fromInt(int v)` | VT_I4 | Вызывает `ole_var_set_int` |
| `OleVariant.fromDouble(double v)` | VT_R8 | Вызывает `ole_var_set_double` |
| `OleVariant.fromString(string s)` | VT_BSTR | D `string` → UTF-8 → `ole_var_set_string` → `SysAllocStringLen` → BSTR |
| `OleVariant.fromBool(bool v)` | VT_BOOL | Вызывает `ole_var_set_bool(v ? 1 : 0)` |
| `OleVariant.fromDispatch(void* p)` | VT_DISPATCH | Вызывает `ole_var_set_dispatch` (без AddRef) |
| `OleVariant.empty()` | VT_EMPTY | Вызывает `ole_var_init` → `VariantInit` |

### 3.4 Извлечение значений

| Метод | Возвращает | Вызывает C |
|-------|-----------|-----------|
| `.type()` | `ushort` (VT) | `ole_var_get_type` |
| `.asInt()` | `int` | `ole_var_get_int` (возвращает `intVal`) |
| `.asDouble()` | `double` | `ole_var_get_double` (возвращает `dblVal`) |
| `.asString()` | `string` | `ole_var_get_string` → BSTR → UTF-8 в `char[2048]`, `.idup` |
| `.asBool()` | `bool` | `ole_var_get_bool` → `!= 0` |
| `.asDispatch()` | `void*` | `ole_var_get_dispatch` (возвращает `ptrVal`) |

**Ограничение**: `asString()` использует буфер `char[2048]` — строки длиннее 2047 байт будут обрезаны молча.

### 3.5 Очистка

```d
var.clear();   // вызывает ole_var_clear → VariantClear → SysFreeString для VT_BSTR
```

**Правило очистки**: `clear()` обязателен для `VT_BSTR`. Для `VT_I4`, `VT_R8`, `VT_BOOL`, `VT_DISPATCH` — опционален (не вредит). Аргументы `fromString()`, переданные в `.call()` / `.callVoid()` как одноразовые временные значения — очищать не нужно. Если вариант хранится в переменной и переиспользуется — очищать после последнего использования.

### 3.6 Определение типа перед извлечением

```d
auto v = obj.get("Value");
switch (v.type()) {
    case OleVariant.VT_I4:       int n    = v.asInt();      break;
    case OleVariant.VT_R8:       double d = v.asDouble();   break;
    case OleVariant.VT_BSTR:     string s = v.asString();   v.clear(); break;
    case OleVariant.VT_BOOL:     bool b   = v.asBool();     break;
    case OleVariant.VT_DISPATCH: void* p  = v.asDispatch(); break;
    case OleVariant.VT_EMPTY:    /* null/nothing */          break;
    default: /* unknown type */                              break;
}
```

---

## 4. OleObject

### 4.1 Создание

```d
// По ProgID — вызывает CLSIDFromProgID + CoCreateInstance
auto fso   = new OleObject("Scripting.FileSystemObject");
auto dict  = new OleObject("Scripting.Dictionary");
auto app   = new OleObject("Excel.Application");
auto word  = new OleObject("Word.Application");
auto shell = new OleObject("WScript.Shell");

// Из существующего IDispatch* (результат getObject/callObject/asDispatch)
auto obj = new OleObject(existingDispatchPtr);
```

Конструктор `this(string progid)` вызывает `pOleCreate` → C-шим: `CLSIDFromProgID` + `CoCreateInstance`. При ошибке бросает `Exception` с текстом из `lastError()`.

Конструктор `this(void* pDisp)` просто сохраняет указатель без AddRef.

### 4.2 Чтение свойств (Property Get)

| Метод | Аргументы | Возвращает | Описание |
|-------|-----------|-----------|---------|
| `obj.get(prop)` | — | `OleVariant` | Simple property get |
| `obj.get(prop, args...)` | `OleVariant[]` | `OleVariant` | Indexed property get (с аргументами) |
| `obj.getInt(prop)` | — | `int` | Shortcut `.get().asInt()` |
| `obj.getDouble(prop)` | — | `double` | Shortcut `.get().asDouble()` |
| `obj.getString(prop)` | — | `string` | Shortcut `.get().asString()` |
| `obj.getBool(prop)` | — | `bool` | Shortcut `.get().asBool()` |
| `obj.getObject(prop)` | — | `OleObject` | `.get().asDispatch()` → `new OleObject(p)`. Бросает если null |

```d
string name  = obj.getString("Name");
int count    = obj.getInt("Count");
bool visible = obj.getBool("Visible");
double val   = obj.getDouble("Value");

// Indexed property (Dictionary.Item, Collection.Item):
auto item = dict.get("Item", OleVariant.fromString("key"));

// Дочерний объект:
auto workbooks = app.getObject("Workbooks");
workbooks.release();  // обязательно
```

### 4.3 Установка свойств (Property Put)

```d
obj.set(prop, int val)     // VT_I4
obj.set(prop, double val)  // VT_R8
obj.set(prop, string val)  // VT_BSTR — вызывает v.clear() внутри метода
obj.set(prop, bool val)    // VT_BOOL
```

```d
app.set("Visible", 0);          // int 0/1
app.set("Visible", false);      // bool
range.set("Value", 3.14);       // double
range.set("Value", "Hello!");   // string
```

### 4.4 Вызов методов

| Метод | Возвращает | Описание |
|-------|-----------|---------|
| `obj.call(method, args...)` | `OleVariant` | `DISPATCH_METHOD`, результат как Variant |
| `obj.callVoid(method, args...)` | `void` | `DISPATCH_METHOD`, результат игнорируется (передаётся `null`) |
| `obj.callObject(method, args...)` | `OleObject` | `.call().asDispatch()` → `new OleObject(p)`. Бросает если null |
| `obj.callString(method, args...)` | `string` | `.call().asString()` + `.clear()` |
| `obj.callInt(method, args...)` | `int` | `.call().asInt()` |

```d
// Без аргументов
auto wb  = wbs.callObject("Add");
string tmp = fso.callString("GetTempName");

// Один аргумент
string ext = fso.callString("GetExtensionName", OleVariant.fromString("file.xlsx"));

// Несколько аргументов
string path = fso.callString("BuildPath",
    OleVariant.fromString(`C:\Projects`),
    OleVariant.fromString("out.txt"));

// Void — без возврата
dict.callVoid("Add", OleVariant.fromString("key"), OleVariant.fromString("val"));
dict.callVoid("RemoveAll");
app.callVoid("Quit");
wb.callVoid("Close", OleVariant.fromInt(0));
```

### 4.5 Освобождение

```d
obj.release();    // явный IDispatch::Release — рекомендуется всегда
// или: destroy(obj);   // вызывает ~this()
// НЕ НАДЕЯТЬСЯ на GC — деструктор может сработать после unloadOleHelper()
```

`obj.handle()` — возвращает `_pDisp` (void*), для проверки `!is null`.

---

## 5. Обработка ошибок

Все методы `OleObject` бросают `Exception` при `hr < 0`:

```d
try {
    auto obj = new OleObject("Bad.ProgID");
} catch (Exception e) {
    writeln(e.msg);
    // "Cannot create COM object: Bad.ProgID — CLSIDFromProgID failed (HRESULT=0x80040154)"
}

try {
    fso.getInt("NoSuchProp");
} catch (Exception e) {
    writeln(e.msg);
    // "get('NoSuchProp') failed: GetIDsOfNames failed (HRESULT=0x80020006)"
}
```

Низкоуровневая диагностика (без исключений):

```d
string msg = lastError();    // последнее сообщение об ошибке (UTF-8, из C-шима)
int hr     = lastHresult();  // последний HRESULT
```

`lastError()` и `lastHresult()` читают thread-local переменные C-шима — всегда актуальны после любой COM-операции.

---

## 6. C Shim — 29 функций

### 6.1 Полный список по группам

**Lifecycle (5):**

| Функция C | Сигнатура | Что делает |
|-----------|-----------|-----------|
| `ole_init` | `int ole_init(void)` | `CoInitializeEx(NULL, COINIT_APARTMENTTHREADED)`, возвращает HRESULT |
| `ole_uninit` | `void ole_uninit(void)` | `CoUninitialize()` |
| `ole_create_object` | `void* ole_create_object(const char* progid)` | UTF-8 ProgID → `CLSIDFromProgID` + `CoCreateInstance`, возвращает `IDispatch*` или NULL |
| `ole_get_active_object` | `void* ole_get_active_object(const char* progid)` | `GetActiveObject` — присоединиться к уже запущенному COM-серверу |
| `ole_release` | `void ole_release(void* pDisp)` | `IDispatch::Release()` |

**Core Invoke (3):**

| Функция C | Описание |
|-----------|---------|
| `ole_invoke(pDisp, name, wFlags, args, nArgs, result)` | Универсальный вызов `IDispatch::Invoke`. `wFlags=1`=METHOD, `2`=PROPERTYGET, `4`=PROPERTYPUT |
| `ole_get_property(pDisp, name, args, nArgs, result)` | Property Get: `DISPATCH_PROPERTYGET=2` |
| `ole_set_property(pDisp, name, args, nArgs)` | Property Put: `DISPATCH_PROPERTYPUT=4` + именованный аргумент `DISPID_PROPERTYPUT=-3` |

**Variant Helpers (14):**

| Функция C | Описание |
|-----------|---------|
| `ole_var_init(v)` | `VariantInit` — обнулить до VT_EMPTY |
| `ole_var_clear(v)` | `VariantClear` — освободить ресурсы (BSTR, IDispatch и т.д.) |
| `ole_var_set_int(v, val)` | `v->vt=VT_I4; v->intVal=val` |
| `ole_var_set_double(v, val)` | `v->vt=VT_R8; v->dblVal=val` |
| `ole_var_set_string(v, utf8)` | `MultiByteToWideChar` → `SysAllocStringLen` → `v->vt=VT_BSTR` |
| `ole_var_set_dispatch(v, pDisp)` | `v->vt=VT_DISPATCH; v->ptrVal=pDisp` (без AddRef) |
| `ole_var_set_bool(v, val)` | `v->vt=VT_BOOL; v->boolVal=(val ? -1 : 0)` |
| `ole_var_set_empty(v)` | `v->vt=VT_EMPTY` |
| `ole_var_get_type(v)` | `return v->vt` |
| `ole_var_get_int(v)` | `return v->intVal` |
| `ole_var_get_double(v)` | `return v->dblVal` |
| `ole_var_get_string(v, buf, bufSize)` | BSTR → `WideCharToMultiByte` → UTF-8 в buf. Возвращает длину в байтах |
| `ole_var_get_dispatch(v)` | `return v->ptrVal` |
| `ole_var_get_bool(v)` | `return v->boolVal != 0 ? 1 : 0` |

**Enumeration / ForEach (3):**

| Функция C | Описание |
|-----------|---------|
| `ole_enum_begin(pDisp)` | Получить `IEnumVARIANT*` из коллекции. Сначала пробует `DISPID_NEWENUM (-4)`, если нет — fallback через `GetIDsOfNames("_NewEnum")` |
| `ole_enum_next(pEnum, result)` | `IEnumVARIANT::Next` — следующий элемент. Возвращает `1` если успех, `0` если конец |
| `ole_enum_release(pEnum)` | `IEnumVARIANT::Release()` |

**Date (2):**

| Функция C | Описание |
|-----------|---------|
| `ole_var_set_date(v, val)` | `v->vt=VT_DATE(7); v->dblVal=val` — OLE Automation date как double |
| `ole_var_get_date(v)` | `return v->dblVal` |

**Error (2):**

| Функция C | Описание |
|-----------|---------|
| `ole_last_error()` | `const char*` — thread-local UTF-8 строка последней ошибки |
| `ole_last_hresult()` | `int` — thread-local последний HRESULT |

**Итого: 5 + 3 + 14 + 3 + 2 + 2 = 29 в заголовке.**
В D-биндинге (`ole_automation.d`) загружаются все 29, включая `ole_get_active_object`,
enum-функции и date-функции (см. §13).

### 6.2 Внутренние механизмы C-шима

#### DISPPARAMS reverse order (критически важно)

COM `IDispatch::Invoke` требует аргументы в **обратном порядке** относительно их объявления в методе. C-шим автоматически реверсирует массив `args` перед передачей. D-программист передаёт аргументы в естественном порядке.

```d
// D: аргументы в обычном порядке
fso.call("BuildPath", OleVariant.fromString(`C:\foo`), OleVariant.fromString("bar.txt"));
// C-шим реверсирует: DISPPARAMS.rgvarg = [bar.txt, C:\foo]  ← обратный порядок для COM
```

#### PROPERTYPUT named argument

`IDispatch::Invoke` с `DISPATCH_PROPERTYPUT` требует специальный именованный аргумент:
- `DISPPARAMS.cNamedArgs = 1`
- `DISPPARAMS.rgdispidNamedArgs = { DISPID_PROPERTYPUT }` где `DISPID_PROPERTYPUT = -3`

C-шим добавляет это автоматически в `ole_set_property`. D-программист просто вызывает `obj.set(...)`.

#### UTF-8 → wchar_t конвертация

Все строковые параметры (`const char*`) принимаются как UTF-8. Конвертация в `wchar_t*` через `MultiByteToWideChar` происходит **в C-шиме на стеке**, а не в D. Это критично: если конвертацию делать в D через `std.utf.toUTF16`, GC может собрать `wchar[]` до завершения COM-вызова — баг был воспроизведён на практике и исправлен переносом конвертации в C.

#### BSTR lifecycle

- `ole_var_set_string` → `SysAllocStringLen(wstr, len)` → COM-выделение памяти
- `ole_var_clear` → `VariantClear` → `SysFreeString` → COM-освобождение
- Нельзя смешивать с `malloc/free` или GC-памятью D

#### Thread-local error storage

Ошибки хранятся в `__thread char g_last_error[]` и `__thread int g_last_hr` — безопасно для многопоточности. Каждый поток видит свою последнюю ошибку.

### 6.3 Сборка C DLL

```bat
gcc -shared -m32 -o ole_helper.dll ole_helper.c -lole32 -loleaut32 -luuid -Wl,--kill-at
```

- `-m32` — обязательно (проект 32-bit)
- `-lole32` — `CoInitializeEx`, `CoCreateInstance`, `CLSIDFromProgID`
- `-loleaut32` — `SysAllocStringLen`, `SysFreeString`, `VariantClear`
- `-luuid` — `IID_IDispatch`, `CLSID_*`
- `-Wl,--kill-at` — убирает `@N` суффиксы из имён экспортов (важно для `GetProcAddress`)

---

## 7. Сборка D-программ

```bat
# Только FSO/Dictionary (нет Office):
dmd -m32 -of=myapp.exe myapp.d ole\d\ole_automation.d

# С Excel (нужен ole_excel.d):
dmd -m32 -of=myapp.exe myapp.d ole\d\ole_automation.d ole\d\ole_excel.d

# Запускать из директории, где лежит ole_helper.dll:
copy ole\c\ole_helper.dll .
myapp.exe
```

---

## 8. ExcelApp / ExcelWorkbook / ExcelSheet (ole_excel.d)

### 8.1 ExcelApp

```d
class ExcelApp {
    OleObject app;

    this(bool visible = true, string dllPath = "ole_helper.dll")
    // Делает: loadOleHelper(dllPath) + oleInit() + new OleObject("Excel.Application")
    // + oleDelay(500) + Visible/DisplayAlerts (ошибки Visible не фатальны)

    static ExcelApp attach(bool makeVisible = true, string dllPath = "ole_helper.dll")
    // Привязка к запущенному Excel (GetActiveObject); null, если Excel не запущен
    static ExcelApp attachOrCreate(bool visible = true, string dllPath = "ole_helper.dll")
    // attach, иначе создание нового (аналог VBS GetObject → CreateObject)

    int           workbookCount()                 // число открытых книг
    ExcelWorkbook workbook(int index)             // книга по индексу (с 1!)
    ExcelWorkbook workbookByName(string name)     // по имени файла; null если не открыта
    ExcelWorkbook activeWorkbook()                // активная книга; null если нет
    ExcelWorkbook addWorkbook()                   // Workbooks.Add
    ExcelWorkbook openWorkbook(string path)       // Workbooks.Open(path)
    ExcelSheet    activeSheet()                   // app.getObject("ActiveSheet")
    void activate()  // Visible=true + WindowState=xlNormal + ShowWindow/SetForegroundWindow по HWND
    void quit()      // app.callVoid("Quit")
    ~this()          // app.release()
}
```

Книги и листы возвращаются как типизированные обёртки (`ExcelWorkbook`,
`ExcelSheet`), ручной развёртки `OleObject` не требуется.

### 8.2 ExcelWorkbook

```d
class ExcelWorkbook {
    OleObject wb;

    string      name() / fullName()
    int         sheetCount()
    ExcelSheet  sheet(int index) / sheet(string name)
    string[]    sheetNames()
    ExcelSheet  activeSheet()
    void activate()
    void save()
    void saveAs(string path, int format = 51)  // 51=xlsx, 52=xlsm, -4143=xls, 6=csv
    void close(bool save = false)
    ~this()    // wb.release()
}
```

### 8.3 ExcelSheet

```d
class ExcelSheet {
    OleObject sheet;

    this(OleObject sh)    // сохраняет sh, не копирует

    string name()
    void   activate()
    void   setName(string name)
    void   copyToNewWorkbook()                 // копия листа в новую книгу
    void   copyToWorkbook(ExcelWorkbook target) // копия в другую открытую книгу

    // Запись — все вызывают sheet.getObject("Range", addr) + range.set("Value", val)
    void setCellValue(string addr, string val)
    void setCellValue(string addr, double val)
    void setCellValue(string addr, int val)
    void setCellDate(string addr, double oleDate)   // VT_DATE; dateToOle() — конвертер
    void setCellFormula(string addr, string formula) // "=SUM(A1:A10)"
    void setNumberFormat(string addr, string format) // "DD.MM.YYYY", "#,##0.00"

    // Чтение
    string     getCellString(string addr)  // range.getString("Value")
    double     getCellDouble(string addr)  // range.getDouble("Value")
    double     getCellDate(string addr)    // VT_DATE как double; oleToDate() — конвертер
    OleVariant getCellValue(string addr)   // range.get("Value") — для type inspection

    ~this()    // sheet.release()
}
```

`ExcelSheet`/`ExcelWorkbook` не вызывают `loadOleHelper()`/`oleInit()` — это делает
`ExcelApp`. При использовании без `ExcelApp` нужно вызвать lifecycle-функции вручную.

Конвертеры дат: `dateToOle(std.datetime.Date)` → double (дни с 30.12.1899),
`oleToDate(double)` → `Date`.

---

## 9. Совместимые COM-серверы

| ProgID | Что это | Требует | Протестировано |
|--------|---------|---------|---------------|
| `Scripting.FileSystemObject` | Файлы, пути, папки | Встроен в Windows | test_ole.d 10 тестов |
| `Scripting.Dictionary` | Ассоциативный массив key→value | Встроен в Windows | test_ole.d 11 тестов |
| `WScript.Shell` | Env vars, реестр, запуск процессов | Встроен в Windows | пример 3 |
| `WScript.Network` | Сетевые ресурсы, принтеры | Встроен в Windows | — |
| `Shell.Application` | Windows Shell (Explorer) | Встроен в Windows | — |
| `Excel.Application` | Microsoft Excel | Office | test_excel.d |
| `Word.Application` | Microsoft Word | Office | пример 10 |
| `PowerPoint.Application` | Microsoft PowerPoint | Office | — |
| `Outlook.Application` | Microsoft Outlook | Office | — |
| `Access.Application` | Microsoft Access | Office | — |
| `ADODB.Connection` | ADO DB соединение | MDAC (встроен) | wren/lib/adodb.wren |
| `ADODB.Recordset` | ADO набор записей | MDAC (встроен) | — |
| `InternetExplorer.Application` | IE (deprecated) | Windows | — |

---

## 10. Полные примеры кода

### Пример 1: FileSystemObject — работа с путями

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto fso = new OleObject("Scripting.FileSystemObject");

    // Разбор пути
    writeln(fso.callString("GetDriveName",        OleVariant.fromString(`C:\Projects\app.exe`)));  // "C:"
    writeln(fso.callString("GetParentFolderName", OleVariant.fromString(`C:\Projects\app.exe`)));  // "C:\Projects"
    writeln(fso.callString("GetFileName",         OleVariant.fromString(`C:\Projects\app.exe`)));  // "app.exe"
    writeln(fso.callString("GetBaseName",         OleVariant.fromString(`C:\Projects\app.exe`)));  // "app"
    writeln(fso.callString("GetExtensionName",    OleVariant.fromString(`C:\Projects\app.exe`)));  // "exe"

    // Склейка пути
    string full = fso.callString("BuildPath",
        OleVariant.fromString(`C:\Projects`), OleVariant.fromString("out.txt"));
    writeln(full);  // "C:\Projects\out.txt"

    // Проверка существования
    bool exists = fso.call("FileExists",   OleVariant.fromString(`C:\Windows\notepad.exe`)).asBool();
    bool dirOk  = fso.call("FolderExists", OleVariant.fromString(`C:\Windows`)).asBool();

    // Временное имя файла
    string tmp = fso.callString("GetTempName");  // "radXXXXX.tmp"

    fso.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 2: Scripting.Dictionary

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto dict = new OleObject("Scripting.Dictionary");

    // Добавить разные типы
    dict.callVoid("Add", OleVariant.fromString("name"),  OleVariant.fromString("Alice"));
    dict.callVoid("Add", OleVariant.fromString("age"),   OleVariant.fromInt(30));
    dict.callVoid("Add", OleVariant.fromString("score"), OleVariant.fromDouble(92.5));

    writeln(dict.getInt("Count"));  // 3

    // Чтение по ключу — INDEXED PROPERTY, не метод!
    auto v = dict.get("Item", OleVariant.fromString("name"));
    string name = v.asString();
    v.clear();

    // Проверка ключа
    bool has = dict.call("Exists", OleVariant.fromString("age")).asBool();  // true

    // Удаление
    dict.callVoid("Remove", OleVariant.fromString("age"));
    dict.callVoid("RemoveAll");

    dict.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 3: WScript.Shell

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto shell = new OleObject("WScript.Shell");

    // Expand environment variables
    auto v = shell.call("ExpandEnvironmentStrings", OleVariant.fromString("%USERPROFILE%"));
    writeln("Home: ", v.asString());
    v.clear();

    // Current directory
    writeln("CWD: ", shell.getString("CurrentDirectory"));

    // Registry read (может требовать прав)
    try {
        auto reg = shell.call("RegRead",
            OleVariant.fromString(`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName`));
        writeln("Windows: ", reg.asString());
        reg.clear();
    } catch (Exception e) { writeln("RegRead failed: ", e.msg); }

    shell.release();
    oleUninit();
    unloadOleHelper();
}
```

### Пример 4: Excel — чтение и запись ячеек

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

    // Запись
    auto c1 = ws.callObject("Range", OleVariant.fromString("A1"));
    c1.set("Value", "Hello from D!");
    c1.release();

    auto c2 = ws.callObject("Range", OleVariant.fromString("B1"));
    c2.set("Value", 42.0);
    c2.release();

    // Чтение
    auto r1 = ws.callObject("Range", OleVariant.fromString("A1"));
    writeln("A1 = ", r1.getString("Value"));   // "Hello from D!"
    r1.release();

    auto r2 = ws.callObject("Range", OleVariant.fromString("B1"));
    // Excel хранит числа как double, даже если писали int!
    writeln("B1 = ", r2.getDouble("Value"));   // 42.0
    r2.release();

    wb.callVoid("Close", OleVariant.fromInt(0));  // 0 = не сохранять
    ws.release();
    wb.release();
    wbs.release();
    app.callVoid("Quit");
    app.release();

    oleUninit();
    unloadOleHelper();
}
```

### Пример 5: Excel — сохранение файла

```d
import ole_automation;
import std.conv : to;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    auto wbs = app.getObject("Workbooks");
    auto wb  = wbs.callObject("Add");
    auto ws  = wb.getObject("ActiveSheet");

    for (int i = 1; i <= 10; i++) {
        auto range = ws.callObject("Range", OleVariant.fromString("A" ~ to!string(i)));
        range.set("Value", i * 10);
        range.release();
    }

    // xlOpenXMLWorkbook=51, xlWorkbookNormal=-4143, xlCSV=6
    wb.callVoid("SaveAs",
        OleVariant.fromString(`C:\temp\out.xlsx`),
        OleVariant.fromInt(51));

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

### Пример 6: Итерация коллекции (Sheets)

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    auto wbs    = app.getObject("Workbooks");
    auto wb     = wbs.callObject("Add");
    auto sheets = wb.getObject("Sheets");
    int count   = sheets.getInt("Count");

    // COM-коллекции ИНДЕКСИРУЮТСЯ С 1, не с 0
    for (int i = 1; i <= count; i++) {
        auto sheet = sheets.callObject("Item", OleVariant.fromInt(i));
        writeln("Sheet ", i, ": ", sheet.getString("Name"));
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

### Пример 7: ExcelApp + ExcelSheet convenience API

```d
import ole_automation;
import ole_excel;
import std.stdio : writeln;

void main() {
    // ExcelApp сам вызывает loadOleHelper + oleInit
    auto excel = new ExcelApp(false, "ole_helper.dll");  // visible=false

    auto wb    = excel.addWorkbook();
    auto ws    = wb.getObject("ActiveSheet");
    auto sheet = new ExcelSheet(ws);

    sheet.setCellValue("A1", "Name");
    sheet.setCellValue("B1", "Score");
    sheet.setCellValue("A2", "Alice");
    sheet.setCellValue("B2", 95.5);
    sheet.setCellValue("A3", "Bob");
    sheet.setCellValue("B3", 87);     // int overload

    writeln(sheet.getCellString("A2"), ": ", sheet.getCellDouble("B2"));
    // Alice: 95.5

    // Type inspection
    auto v = sheet.getCellValue("B2");
    // v.type() == OleVariant.VT_R8 (double)
    v.clear();

    destroy(sheet);  // sheet.release()
    wb.callVoid("Close", OleVariant.fromInt(0));
    wb.release();
    excel.quit();
    destroy(excel);  // app.release()

    oleUninit();
    unloadOleHelper();
}
```

### Пример 8: Цепочка навигации по COM-объектам

```d
import ole_automation;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    // Паттерн: каждый getObject/callObject → новый OleObject → нужен release()
    // Release в ОБРАТНОМ порядке создания
    auto app = new OleObject("Excel.Application");
    app.set("Visible", 0);
    app.set("DisplayAlerts", 0);

    auto wbs = app.getObject("Workbooks");
    auto wb  = wbs.callObject("Add");
    auto ws  = wb.getObject("ActiveSheet");
    auto rng = ws.callObject("Range", OleVariant.fromString("A1"));

    rng.set("Value", "chain test");
    string val = rng.getString("Value");  // "chain test"

    // Release в обратном порядке создания
    rng.release();
    ws.release();
    wb.release();
    wbs.release();
    app.callVoid("Quit");
    app.release();

    oleUninit();
    unloadOleHelper();
}
```

### Пример 9: Word Automation

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

    auto sel = word.getObject("Selection");
    sel.callVoid("TypeText", OleVariant.fromString("Hello from D!\n"));
    sel.callVoid("TypeParagraph");
    sel.callVoid("TypeText", OleVariant.fromString("Automated via OLE."));

    // wdFormatXMLDocument=12, wdFormatPDF=17
    doc.callVoid("SaveAs2",
        OleVariant.fromString(`C:\temp\test.docx`),
        OleVariant.fromInt(12));

    sel.release();
    doc.callVoid("Close", OleVariant.fromInt(0));
    doc.release();
    docs.release();
    word.callVoid("Quit");
    word.release();

    oleUninit();
    unloadOleHelper();
    writeln("Done.");
}
```

### Пример 10: Обработка ошибок

```d
import ole_automation;
import std.stdio : writeln;

void main() {
    loadOleHelper("ole_helper.dll");
    oleInit();

    // Несуществующий ProgID
    try {
        auto obj = new OleObject("No.Such.Server");
    } catch (Exception e) {
        writeln(e.msg);
        // "Cannot create COM object: No.Such.Server — CLSIDFromProgID failed (HRESULT=0x80040154)"
    }

    // Несуществующее свойство
    auto fso = new OleObject("Scripting.FileSystemObject");
    try {
        fso.getInt("BadProp");
    } catch (Exception e) {
        writeln(e.msg);
        // "get('BadProp') failed: GetIDsOfNames failed (HRESULT=0x80020006)"
    }

    // Низкоуровневая диагностика
    string msg = lastError();
    int hr     = lastHresult();
    writeln("Error: ", msg, " HR=0x", hr);

    fso.release();
    oleUninit();
    unloadOleHelper();
}
```

---

## 11. Тесты

### test_ole.d — 26 проверок (без Office)

| Группа | Тесты |
|--------|-------|
| Инфраструктура | loadOleHelper (1), oleInit (1), FSO создан (1), Dictionary создан (1), cleanup (1) |
| FSO | GetDriveName, GetFileName, GetParentFolderName, GetExtensionName, GetBaseName (5) |
| FSO | BuildPath, FileExists=true, FileExists=false, FolderExists=true, GetTempName (5) |
| Dictionary | Add×3 (string/int/double), Count=3, Exists=true, Exists=false (6) |
| Dictionary | Item(string), Item(int), Item(double), Remove→Count=2, RemoveAll→Count=0 (5) |

**Сборка и запуск** (из `arch_new/`):
```bat
dmd -m32 -of=test_ole.exe ole\d\test_ole.d ole\d\ole_automation.d
test_ole.exe
```

Ожидаемый результат: `Results: 26 passed, 0 failed`.

---

## 12. Gotchas — полный список

### G1: Порядок инициализации и очистки

```
loadOleHelper() → oleInit() → [создать объекты] → [release() все] → oleUninit() → unloadOleHelper()
```
Нарушение → утечки COM или ACCESS VIOLATION.

### G2: Никогда не полагаться на GC для release()

D GC не вызывает деструкторы детерминированно. `~OleObject` может сработать после `unloadOleHelper()`. Деструктор проверяет `g_loaded` и пропустит `pOleRelease` — COM-объект утечёт до конца процесса. **Всегда вызывать `release()` явно.**

### G3: clear() для VT_BSTR

```d
auto v = obj.call("GetName");
string s = v.asString();  // копирует BSTR → D string (idup)
v.clear();                // SysFreeString — ОБЯЗАТЕЛЬНО
// Если не вызвать clear(): утечка COM-памяти
```

Для аргументов `fromString()` переданных напрямую в `call()` как одноразовые: очищать не надо. Если хранить в переменной и переиспользовать — очищать после последнего использования.

### G4: COM-коллекции начинаются с 1

```d
// ПРАВИЛЬНО
for (int i = 1; i <= count; i++) { ... }
// НЕПРАВИЛЬНО — Item(0) бросит Exception
for (int i = 0; i < count; i++) { ... }
```

### G5: Property Get vs Method Call для Dictionary.Item

```d
// ПРАВИЛЬНО — Item это Indexed Property
auto v = dict.get("Item", OleVariant.fromString("key"));

// МОЖЕТ НЕ РАБОТАТЬ — DISP_E_UNKNOWNNAME
auto v = dict.call("Item", OleVariant.fromString("key"));
```

Если `call()` не работает — попробовать `get()`. COM-серверы иногда реализуют "методы" как indexed property.

### G6: Excel хранит числа как double

```d
range.set("Value", 42);              // записали int
double v = range.getDouble("Value"); // читать как double (42.0)
int n = cast(int) range.getDouble("Value");  // конвертировать если нужен int
// range.getInt("Value") может бросить если COM вернёт VT_R8
```

### G7: DisplayAlerts = 0 для фоновой работы

```d
app.set("DisplayAlerts", 0);  // Excel, Word
app.set("Visible", 0);
// Иначе диалог "Сохранить?" зависнет программу навсегда
```

### G8: void main() — не extern(C)

```d
void main() { ... }             // ПРАВИЛЬНО
// extern(C) int main() { }    // НЕПРАВИЛЬНО — static this() не выполнится
```
(Общее правило D, не специфика OLE.)

### G9: STA — только один поток

`oleInit()` инициализирует STA (Single-Threaded Apartment). COM-объекты нельзя использовать из других потоков без отдельного `CoInitializeEx` в каждом потоке.

### G10: Старые копии ole_helper.dll

`LoadLibraryA` ищет DLL в текущей директории, потом в PATH. Если есть старая копия `ole_helper.dll` в корне проекта или раньше в PATH — загрузится старая версия. Удалять все лишние копии.

### G11: Присоединение к уже запущенному COM-серверу

`ole_get_active_object` загружается в D и доступна через обёртки
`OleObject.attachActive(progid)` (бросает, если сервер не запущен) и
`OleObject.attachOrCreate(progid)` (attach, иначе create). Ручной вызов
`GetProcAddress` больше не нужен.

### G12: Константы SaveAs для Office

| Приложение | Формат | Значение |
|-----------|--------|---------|
| Excel .xlsx | `xlOpenXMLWorkbook` | 51 |
| Excel .xls | `xlWorkbookNormal` | -4143 |
| Excel .csv | `xlCSV` | 6 |
| Word .docx | `wdFormatXMLDocument` | 12 |
| Word .pdf | `wdFormatPDF` | 17 |

### G13: asString() ограничен 2048 байтами

`OleVariant.asString()` использует `char[2048]` на стеке. Строки длиннее 2047 байт обрезаются молча. Для длинных строк нужна прямая работа с C-функцией `ole_var_get_string` с большим буфером.

### G14: Release в обратном порядке создания

```
Создание: app → wbs → wb → ws → range
Release:  range → ws → wb → wbs → app.Quit() → app
```
COM-серверы могут проверять refcount родительских объектов.

### G15: ole_var_set_dispatch без AddRef

`OleVariant.fromDispatch(ptr)` / `ole_var_set_dispatch` НЕ вызывает `AddRef`. Это означает, что если оригинальный объект будет освобождён раньше, чем вариант — получится dangling pointer. Использовать только для кратковременных аргументов.

### G16: Занятый сервер (RPC_E_CALL_REJECTED) и busy-retry

Excel отклоняет COM-вызовы, когда занят (edit-mode ячейки, модальный диалог,
пересчёт, старт): HRESULT `0x80010001` (RPC_E_CALL_REJECTED), `0x8001010A`
(RPC_E_SERVERCALL_RETRYLATER) или `0x800AC472` (VBA_E_IGNORE). Отказ временный.

`ole_automation.d` автоматически повторяет busy-вызовы: **50 × 100 мс** по умолчанию
(≈5 с). Покрыты: `new OleObject(progid)`, все `get`/`set`, `call`/`callVoid`,
`beginEnum()`. Управление:

```d
oleSetBusyRetry(maxRetries, delayMs);  // 0 — отключить
oleGetBusyRetry(mr, d);                // прочитать
oleSetRetryLogger((int attempt, int hr) { ... });  // диагностика
isBusyHresult(hr);                     // классификатор HRESULT
```

Если повторы исчерпаны — Exception с «сервер занят (RPC_E_CALL_REJECTED),
повторы исчерпаны». Тест: `apps/ole_test/test_visible_race.d` (сценарий F).

---

## 13. D DLL Loading — детали реализации

```d
private __gshared HMODULE g_dll;
__gshared bool g_loaded = false;
```

`loadOleHelper()` выполняет последовательно 29 вызовов `GetProcAddress`. При сбое любого — `Exception`. `g_loaded` выставляется только после **успешной** загрузки всех символов.

Список загружаемых символов в порядке из `ole_automation.d`:

```
ole_init, ole_uninit, ole_create_object, ole_get_active_object, ole_release,
ole_invoke, ole_get_property, ole_set_property, ole_var_init, ole_var_clear,
ole_var_set_int, ole_var_set_double, ole_var_set_string, ole_var_set_dispatch,
ole_var_set_bool, ole_var_set_date, ole_var_set_empty, ole_var_get_type,
ole_var_get_int, ole_var_get_double, ole_var_get_string, ole_var_get_dispatch,
ole_var_get_bool, ole_var_get_date, ole_enum_begin, ole_enum_next,
ole_enum_release, ole_last_error, ole_last_hresult
```

Загружаются все 29 символов заголовка. Поверх них в `ole_automation.d` есть
D-обёртки: `OleObject.attachActive(progid)` / `attachOrCreate(progid)`
(через `ole_get_active_object`), `OleVariant.fromDate()` / `.asDate()` и
класс `OleEnum` (`obj.beginEnum()` / `obj.collectObjects()`) для ForEach.

---

## 14. Wren-интеграция (контекст)

OleObject также используется внутри Wren-биндингов (`wren/`):
- Wren-модуль `"ole"` предоставляет OleObject как Wren-класс
- Chaining: `.getR/.callR(0-8)` — get/call + auto-release self (цепочки без ручного release)
- `enumBegin_/enumNext_/enumRelease_` — ForEach через C enum API
- VT_DATE (7) → double — OLE Automation дата передаётся как число
- `variantToWrenSlot` для VT_DISPATCH: ownership transfer (v->vt=EMPTY перед var_clear)

Это **отдельная подсистема** (`wren_bridge.dll`). Standalone D-программы используют только `ole_automation.d` напрямую.

---

## 15. Быстрая шпаргалка

```
LIFECYCLE:        loadOleHelper → oleInit → ... → [release all] → oleUninit → unloadOleHelper
CREATE OBJECT:    new OleObject("ProgID")
GET PROPERTY:     obj.getString/getInt/getDouble/getBool/getObject("Prop")
GET INDEXED:      obj.get("Item", OleVariant.fromInt(i))   ← с 1!
SET PROPERTY:     obj.set("Prop", value)   ← int/double/string/bool overloads
CALL METHOD:      obj.callVoid / callString / callInt / callObject("Method", args...)
CALL GENERIC:     auto v = obj.call("Method", OleVariant.fromString("x")); v.asString(); v.clear();
RELEASE:          obj.release()    ← явно, не через GC
VARIANT CREATE:   OleVariant.fromInt/fromDouble/fromString/fromBool/fromDispatch/empty()
VARIANT CLEAR:    v.clear()        ← обязательно для VT_BSTR результатов
TYPE CHECK:       v.type() — VT_I4=3, VT_R8=5, VT_BSTR=8, VT_DISPATCH=9, VT_BOOL=11
ERROR INFO:       lastError() / lastHresult()
EXCEL NUMBERS:    всегда double → getDouble(), cast(int) если нужен int
COLLECTIONS:      индексируются с 1, не с 0
DICT ITEM:        get("Item", key) — property, не call
SAVE XLSX:        callVoid("SaveAs", path, OleVariant.fromInt(51))
SAVE DOCX:        callVoid("SaveAs2", path, OleVariant.fromInt(12))
```
