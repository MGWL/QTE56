# QTE56 Wren Module — Документ передачи знаний

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [wren/WREN_GUIDE.md](WREN_GUIDE.md)

> Назначение: полное техническое описание Wren-подсистемы проекта QTE56 для загрузки в AI-ассистент. Содержит всю необходимую информацию для ответов на вопросы, написания кода и отладки. Технические термины и код — на английском, проза — на русском.

---

## 1. Контекст проекта

**QTE56** — биндинги Qt 5.13.2 для языка D через C++ DLL-обёртки.
- Директория: `H:\qte56\arch_new\`
- Сборка: 32-bit (`dmd -m32`, Qt MinGW 32-bit)
- Qt: `C:\Qt5_13_2\5.13.2\mingw73_32`

**Wren-модуль** — самостоятельная подсистема скриптинга внутри QTE56. Позволяет D-программам встраивать Wren VM, управлять Qt-виджетами из Wren-скриптов, вызывать COM/OLE Automation объекты из Wren. Бизнес-логика живёт в `.wren`-файлах и может быть горячей перезагрузкой без перекомпиляции D.

---

## 2. Архитектура

```
D application
  │
  ├── LoadWren("./dll/wren_bridge.dll")   ← однократная загрузка DLL
  ├── auto vm = new WrenVM(&writeCb, &errorCb)
  ├── vm.setWidget("btn", btn.getWH())    ← регистрация Qt-виджетов по имени
  ├── vm.addLibPath("./wren/lib")         ← директория для import "foo"
  ├── vm.loadFile("logic.wren")           ← загрузка+исполнение Wren-скрипта
  └── vm.call("main", "Handler", "onButtonClick()")  ← вызов статического метода Wren

wren_bridge.dll (C++ + Wren 0.4.0)
  ├── Built-in module "qt"   → Widget, Widgets, Logger
  ├── Built-in module "ole"  → OleObject (COM/IDispatch wrapper)
  ├── Built-in module "io"   → File (QFile-based)
  ├── Built-in module "sys"  → Sys (sleep, clock, env, msgBox)
  └── File import: import "foo" → ищет foo.wren в addLibPath-директориях

wren/lib/  (Wren-библиотеки, загружаются через import)
  ├── utils.wren    → StringUtil, MathUtil
  ├── excel.wren    → XlApp, XlBook, XlSheet, XlRange, XlUtil, XlColor/XlAlign/XlBorder/XlFmt
  ├── fso.wren      → FSO (Scripting.FileSystemObject)
  ├── shell.wren    → Shell (WScript.Shell)
  ├── word.wren     → Word
  ├── outlook.wren  → Outlook
  ├── regex.wren    → Regex, Match (VBScript.RegExp)
  └── adodb.wren    → Database, Recordset (ADODB)

wren/d/wren_vm.d   ← D-биндинги (импортировать в D-программу)
wren/c/            ← C++ исходники wren_bridge.dll
```

**Ключевой принцип проектирования:** D владеет event loop и Qt-виджетами; Wren хранит только строковые ключи виджетов. D-приложение регистрирует виджет по имени (`setWidget("btn", btn.getWH())`), Wren получает его через `Widget.new("btn")` или `Widgets.get("btn")`. Бизнес-логика в `.wren`-файлах, горячая перезагрузка без перекомпиляции D.

---

## 3. D API — wren_vm.d

### 3.1 LoadWren

```d
void LoadWren(string dllPath = null);
// dllPath = null → "./dll/wren_bridge.dll" (Windows)
// Windows fallback: если путь не существует → ./dll/dll32|dll64/wren_bridge.dll
//   по QTE56_ARCH (win64_qt6 → dll64, иначе dll32) — как у LoadQt
// Linux: автоконвертация dllPath → ./lib/libwren_bridge.so если dllPath не существует
// Вызывать один раз, до создания WrenVM
```

### 3.2 Класс WrenVM

```d
// Типы callback-функций:
alias WrenWriteCb = extern(C) void function(const(char)* text, int len, void* ud);
alias WrenErrorCb = extern(C) void function(const(char)* msg, int len, void* ud);

// Конструктор: null = вывод в stdout/stderr по умолчанию
this(WrenWriteCb writeCb = null, WrenErrorCb errorCb = null, void* ud = null)
void free()   // явное освобождение (вызывается и в ~this)
```

#### Исполнение Wren-кода

```d
int interpret(string module_, string source)
// module_ — имя модуля (обычно "main"), source — Wren-код
// Возвращает: 0=ok, 1=compile error, 2=runtime error

int loadFile(string path, string module_ = "main")
// Загружает файл и исполняет его. Возвращает: 0=ok, 1=compile, 2=runtime
```

#### Реестр виджетов

```d
void setWidget(string name, void* wh)   // wh = widget.getWH()
void clearWidgets()                     // удалить все зарегистрированные виджеты
```

#### Пути библиотек

```d
void addLibPath(string path)
// Добавляет директорию для поиска при import "foo" → foo.wren
// Можно вызывать несколько раз — пути добавляются в список
```

#### Вызов Wren-метода

```d
int call(string module_, string className, string sig)
// module_   — имя модуля Wren (обычно "main")
// className — имя класса
// sig       — сигнатура метода: "methodName()" для 0 аргументов,
//             "methodName(_)" для 1, "methodName(_,_)" для 2 и т.д.
// Возвращает: 0=ok, 1=compile, 2=runtime
```

#### Удобные обёртки call (возвращают дефолт при ошибке)

```d
string callStr(string module_, string className, string sig)   // "" при ошибке
double callNum(string module_, string className, string sig)   // 0.0 при ошибке
bool   callBool(string module_, string className, string sig)  // false при ошибке
```

#### Передача аргументов в call

Устанавливаются ПЕРЕД вызовом `call()`. Слот 0 — receiver (класс), слоты 1..8 — аргументы.

```d
void argDouble(int slot, double val)   // slot начинается с 1
void argString(int slot, string val)
void argBool(int slot, bool val)
```

#### Чтение результата после call

```d
int    resultType()    // 0=num, 1=bool, 2=str, 3=null, 4=other (object/list)
double resultDouble()
bool   resultBool()
string resultString()
```

#### Прочее

```d
bool hasVariable(string module_, string name)  // проверить существование переменной/класса
void* handle()   // внутренний указатель WrenBridge* (для отладки)
```

---

## 4. Паттерны использования D API

### 4.1 Подключение сигнала к Wren (ESlot)

```d
__gshared WrenVM g_vm;
__gshared ESlot[] g_slots;  // ОБЯЗАТЕЛЬНО хранить — иначе GC соберёт ESlot → crash

// Сигнатура коллбэка: второй параметр — тег int n (см. DSlot_i в gen_qcore.d)
extern(C) static void cbClick(void* dthis, int n, int checked) {
    g_vm.call("main", "Handler", "onButtonClick()");
}

// С аргументами:
extern(C) static void cbWithArg(void* dthis, int n, int checked) {
    g_vm.argString(1, "someValue");
    g_vm.call("main", "Handler", "onEvent(_)");
}

// Инициализация:
auto sl = new ESlot(btn.getWH());
sl.set(cast(void*)&cbClick);
btn.connect_clicked(sl);
g_slots ~= sl;  // ← КРИТИЧНО: без этого GC соберёт ESlot → crash при следующем сигнале
```

### 4.2 Горячая перезагрузка скрипта

```d
void reloadScript() {
    auto newVm = new WrenVM(&writeCb, &errorCb);
    newVm.setWidget("edit", g_edit.getWH());
    // перерегистрировать все виджеты...
    int rc = newVm.loadFile("logic.wren");
    if (rc != 0) { newVm.free(); return; }  // при ошибке оставить старую VM
    if (g_vm) g_vm.free();
    g_vm = newVm;
}
```

### 4.3 Порядок инициализации

```d
LoadQt("./dll");                        // 1. Qt DLL-и
LoadWren("./dll/wren_bridge.dll");      // 2. Wren DLL
auto app = new QApplication("name");   // 3. QApplication
auto vm = new WrenVM();                 // 4. WrenVM
// НЕЛЬЗЯ создавать WrenVM до вызова LoadWren()
```

### 4.4 Чтение результата вызова

```d
vm.argDouble(1, 3.14);
vm.argString(2, "hello");
int rc = vm.call("main", "Calc", "compute(_,_)");
if (rc == 0) {
    if (vm.resultType() == 0) writeln(vm.resultDouble());
    if (vm.resultType() == 2) writeln(vm.resultString());
}
```

---

## 5. Язык Wren 0.4.0 — справочник

Wren — чистый объектно-ориентированный скриптовый язык с классами, встроенный в C++. Версия 0.4.0.

- **Нет точек с запятой** — операторы разделяются переносами строк
- **Все числа — `Num` (double)** — целого типа нет
- `var x = 10` — локальная переменная
- `_fieldName` — поле класса (приватное для экземпляра); имена МЕТОДОВ с `_` запрещены
- `methodName { expr }` — геттер (вызывается без скобок: `obj.value`, не `obj.value()`)
- `static foo() { ... }` — статический метод; вызов: `ClassName.foo()`
- `"Hello %(name)!"` — строковая интерполяция
- `[1, 2, 3]` — список; `.add(v)`, `.count`, `[i]`
- `{"key": value}` — словарь; `map["key"]`, `map["key"] = v`
- `Fiber.abort("message")` — выброс runtime-ошибки
- `import "moduleName" for ClassName` — сначала ищет built-in, затем addLibPath-директории
- `0...n` — диапазон (exclusive), `0..n` — inclusive
- `for (x in collection) { ... }` — цикл
- `construct new(args)` — синтаксис конструктора
- `foreign` — метод реализован в C++
- Перегрузки по количеству аргументов: `run(cmd)`, `run(cmd, style)`, `run(cmd, style, wait)`

---

## 6. Встроенный модуль "qt"

```wren
import "qt" for Widget, Widgets, Logger
```

### 6.1 Widget

Обёртка над Qt-виджетом, зарегистрированным через `vm.setWidget("name", wh)`.

```wren
var w = Widget.new("name")   // то же что Widgets.get("name")
// предпочтительно:
var w = Widgets.get("name")
```

Диспетчеризация методов происходит по реальному Qt-типу во время выполнения (`qobject_cast`). Если каст неудачен — метод игнорируется молча (без краша).

```wren
// Методы виджетов:
w.setText("hello")      // QLabel, QLineEdit, QAbstractButton, QGroupBox
w.text                  // геттер — без скобок
w.setValue(42)          // QSpinBox, QDoubleSpinBox, QAbstractSlider, QProgressBar, QLCDNumber
w.value                 // геттер
w.setChecked(true)      // QAbstractButton и подклассы
w.isChecked             // геттер
w.setEnabled(false)     // все QWidget
w.isEnabled             // геттер
w.setVisible(true)      // все QWidget
w.isVisible             // геттер
w.addItem("text")       // QComboBox, QListWidget
w.clearItems()          // QComboBox, QListWidget
w.count                 // геттер — количество элементов (QComboBox, QListWidget)
w.currentIndex          // геттер — QComboBox
w.setCurrentIndex(n)    // QComboBox
w.className             // геттер — Qt-имя класса как строка (для отладки)
```

Неизвестное имя виджета: Widget создаётся с null-указателем, все операции игнорируются молча.

### 6.2 Logger

```wren
Logger.print("text\n")   // → writeCb
Logger.warn("text")      // → writeCb с префиксом "[WARN] "
System.print(x)          // стандартный вывод Wren → writeCb
```

---

## 7. Встроенный модуль "ole"

Самый мощный модуль. Обёртка над Windows COM IDispatch-объектами.

```wren
import "ole" for OleObject
```

### 7.1 Создание объекта

```wren
var obj = OleObject.create("ProgID")    // CoCreateInstance по ProgID
var obj = OleObject.connect("ProgID")   // GetActiveObject (подключиться к работающему)
var isNull = obj.isNull                 // true если создание провалилось
var err = OleObject.lastError           // строка последней ошибки
```

### 7.2 Доступ к свойствам

```wren
obj.get("PropertyName")              // возвращает значение (num/bool/str/OleObject)
obj.get("PropertyName", arg)         // индексированное свойство
obj.set("PropertyName", value)       // установить свойство (любой тип: num/bool/str)
```

### 7.3 Вызов методов

```wren
// call(method) .. call(method, a, b, c, d, e, f, g, h) — до 8 аргументов
obj.call("MethodName")
obj.call("MethodName", arg1)
obj.call("MethodName", arg1, arg2)
// ... до 8 аргументов
```

### 7.4 Освобождение

```wren
obj.release()    // Release IDispatch — ОБЯЗАТЕЛЬНО вызывать после использования
obj.isNull       // true после release()
```

### 7.5 Итерация по COM-коллекции (ForEach)

```wren
// .each{|item|} — использует IEnumVARIANT (_NewEnum property)
collection.each {|item|
    // item — OleObject если VT_DISPATCH, иначе примитив
    // ВАЖНО: вызывать item.release() для dispatch-элементов
    item.release()
}
```

### 7.6 Счётчик и подстрочный доступ

```wren
obj.count       // эквивалент obj.get("Count")
obj[key]        // эквивалент obj.call("Item", key)
obj[0]          // числовой индекс
obj["keyName"]  // строковый ключ
```

### 7.7 Chaining — getR / callR

Эти методы GET/CALL результат И освобождают caller за один шаг. Используются для навигации по COM без ручного release промежуточных объектов.

```wren
// getR(prop) = get(prop) + release self → возвращает значение свойства
var cnt = obj.getR("Count")    // obj теперь освобождён (isNull = true)

// callR(method) .. callR(method, a..h) = call(method, ...) + release self
var ext = obj.callR("GetExtensionName", "file.xlsx")  // obj освобождён

// Пример chaining:
var val = OleObject.create("VBScript.RegExp")
    .call("Execute", "abc 99 def 42").callR("Item", 0).getR("Value")
// Промежуточные объекты (Execute result, Item result) авто-освобождаются
// val — примитивная строка
```

Реализация `getR/callR` в Wren (внутри OLE module source):

```wren
getR(prop) {
    var r = get(prop)
    release()
    return r
}
callR(method) {
    var r = call(method)
    release()
    return r
}
// ... аналогично для callR с 1..8 аргументами
```

### 7.8 VT_DATE

OLE Automation date (type 7) возвращается как `double` (OLE date serial number — тот же формат, что Excel date). День 0 = 30 декабря 1899 (OLE convention). Дробная часть = время суток.

---

## 8. Встроенный модуль "io"

```wren
import "io" for File
```

Реализован на базе QFile.

```wren
File.read("path/to/file")          // возвращает String (UTF-8 содержимое)
File.write("path/to/file", "text") // записывает строку в файл (перезаписывает)
File.exists("path")                // возвращает Bool
File.delete("path")                // удаляет файл
File.size("path")                  // возвращает размер в байтах (Num)
```

---

## 9. Встроенный модуль "sys"

```wren
import "sys" for Sys
```

```wren
Sys.sleep(50)          // спать N миллисекунд
Sys.clock              // прошедшее время в миллисекундах (Num), высокое разрешение
Sys.env("VAR_NAME")    // получить переменную окружения → String или null
Sys.msgBox("text", "title", flags)  // Windows MessageBox, возвращает код кнопки
```

---

## 10. Библиотечные файлы (wren/lib/)

Загружаются через `vm.addLibPath("./wren/lib")` + `import "name"` в Wren-скрипте.

### 10.1 utils.wren

```wren
import "utils" for StringUtil, ListUtil, MathUtil

// StringUtil
StringUtil.repeat(s, n)           // повторить строку n раз
StringUtil.padLeft(s, width, ch)  // дополнить слева символом ch до ширины width
StringUtil.padRight(s, width, ch)
StringUtil.startsWith(s, prefix)
StringUtil.endsWith(s, suffix)
StringUtil.contains(s, sub)
StringUtil.split(s, sep)          // возвращает List строк
StringUtil.join(list, sep)        // возвращает String
StringUtil.less(a, b)             // побайтовое сравнение строк (UTF-8), ≡ D string <
                                  // ВАЖНО: Wren String не реализует < → используй less для sort

// ListUtil
ListUtil.sort(list)               // строки → через StringUtil.less; числа → через <
ListUtil.sortBy(list, fn)         // fn(a,b) → Bool (a < b)
ListUtil.dedup(list)              // убрать дубликаты (список должен быть отсортирован)
ListUtil.sortedUniq(list)         // sort + dedup

// MathUtil
MathUtil.clamp(val, lo, hi)
MathUtil.lerp(a, b, t)
MathUtil.map(val, inLo, inHi, outLo, outHi)
```

> **Примечание**: `String.trim()` — встроен в Wren (не нужен import). В utils.wren `StringUtil.trim` удалён как дубликат.

### 10.2 fso.wren

Обёртка над `Scripting.FileSystemObject` (COM).

```wren
import "fso" for FSO

var fso = FSO.new()
fso.getExtension(path)     // "xlsx"
fso.getBaseName(path)      // "file" (без расширения)
fso.getFileName(path)      // "file.xlsx"
fso.getParent(path)        // путь к родительской папке
fso.getDrive(path)         // буква диска
fso.buildPath(a, b)        // объединить пути
fso.getTempName()          // случайное временное имя файла
fso.fileExists(path)       // Bool
fso.folderExists(path)     // Bool
fso.driveExists(drive)     // Bool
fso.copyFile(src, dst)
fso.moveFile(src, dst)
fso.deleteFile(path)
fso.createFolder(path)
fso.deleteFolder(path)
fso.getFileSize(path)      // Num байт
fso.readText(path)         // String содержимое
fso.writeText(path, text)  // записать строку
fso.release()
```

### 10.3 excel.wren

Объектная обёртка над Excel COM. Классы: `XlApp` (приложение), `XlBook` (книга),
`XlSheet` (лист), `XlRange` (диапазон), `XlUtil` (адресация),
`XlColor`/`XlAlign`/`XlBorder`/`XlFmt` (константы форматирования).

```wren
import "excel" for XlApp, XlBook, XlSheet, XlRange, XlUtil

var xl = XlApp.new()           // невидимый (Visible=false); XlApp.visible() — видимый
                               // XlApp.connect() — подключиться к запущенному
var wb = xl.newBook()          // новая книга → XlBook
var wb = xl.open(path)         // открыть существующую → XlBook
xl.raw                         // базовый OleObject (Excel.Application)
xl.version                     // строка версии
xl.quit()

// XlBook:
wb.activeSheet()               // → XlSheet
wb.sheet(nameOrIndex)          // → XlSheet
wb.saveAs(path)                // xlsx (51); также saveAsXlsm/saveAsXlsb/saveAsCsv
wb.close()                     // закрыть без сохранения
wb.release()

// XlSheet:
sheet.getValue("A1")           // значение ячейки
sheet.setValue("A1", value)    // установить значение
sheet.cell(row, col)           // → XlRange
sheet.range("A1", "C5")        // → XlRange

// XlUtil (статические хелперы):
XlUtil.colLetter(n)            // 1→"A", 26→"Z", 27→"AA"
XlUtil.addr(row, col)          // "B3" из (3, 2)
XlUtil.addrRange(r1, c1, r2, c2)  // "A1:D3"
```

### 10.4 shell.wren

Обёртка над `WScript.Shell` (COM).

```wren
import "shell" for Shell

var sh = Shell.new()
sh.run(cmd)                    // запустить команду, не ждать
sh.run(cmd, style)             // style: 0=скрыть, 1=нормальное окно
sh.run(cmd, style, wait)       // wait=true — ждать завершения
var proc = sh.exec(cmd)        // возвращает WScript.Exec OleObject
Shell.readStdOut(proc)         // прочитать stdout
Shell.readStdErr(proc)         // прочитать stderr
Shell.exitCode(proc)           // код завершения (после выхода процесса)
sh.expandEnvironment(str)      // раскрыть %VAR% → значение
sh.specialFolder(name)         // "Desktop", "MyDocuments" и т.д.
sh.regRead(key)                // прочитать ключ реестра
sh.regWrite(key, val)
sh.regWrite(key, val, type)    // type: "REG_SZ", "REG_DWORD" и т.д.
sh.regDelete(key)
sh.createShortcut(path)        // возвращает shortcut OleObject
sh.currentDirectory            // геттер
sh.currentDirectory=(v)        // сеттер
sh.popup(text)
sh.popup(text, sec)
sh.popup(text, sec, title)
sh.popup(text, sec, title, typ)
sh.sendKeys(keys)
sh.sendKeys(keys, wait)
sh.appActivate(title)          // вывести окно на передний план
sh.release()
```

### 10.5 word.wren

```wren
import "word" for Word

var w = Word.open(false)       // false = невидимый
var doc = w.addDocument()      // возвращает OleObject
var doc = w.openFile(path)     // возвращает OleObject
w.app                          // базовый OleObject
w.typeText("hello")            // напечатать в текущей позиции курсора
w.typeParagraph()              // вставить разрыв абзаца
Word.saveAs(doc, path)         // сохранить как .docx (формат 12)
Word.saveAsPDF(doc, path)      // сохранить как .pdf (формат 17)
Word.close(doc)                // закрыть без сохранения
w.quit()
```

### 10.6 outlook.wren

```wren
import "outlook" for Outlook

var ol = Outlook.open()        // создать новый экземпляр Outlook
var ol = Outlook.connect()     // подключиться к работающему Outlook
ol.app                         // базовый OleObject
var ns = ol.namespace()        // MAPI namespace OleObject
// Типы папок: 4=Outbox, 5=SentMail, 6=Inbox, 9=Calendar, 10=Contacts, 16=Drafts
var folder = ol.getDefaultFolder(6)   // возвращает OleObject
var mail = ol.createMail()            // возвращает OleObject (olMailItem)
ol.sendMail(to, subject, body)         // отправить plain text
ol.sendHtmlMail(to, subject, htmlBody) // отправить HTML
ol.inboxCount()                        // количество сообщений в inbox
Outlook.getItem(folder, index)  // получить элемент по 1-based индексу
Outlook.subject(mail)           // тема письма
Outlook.body(mail)              // тело письма
Outlook.from(mail)              // имя отправителя
Outlook.to(mail)                // поле To
Outlook.cc(mail)                // поле CC
Outlook.receivedTime(mail)      // OLE date (VT_DATE как double)
var appt = ol.createAppointment()     // olAppointmentItem
ol.quit()
ol.release()
```

### 10.7 regex.wren

Обёртка над `VBScript.RegExp` (COM).

```wren
import "regex" for Regex, Match

// Экземплярный API:
var re = Regex.new("\\d+")            // только паттерн
var re = Regex.new("[a-z]+", "i")     // с опциями: "i"=ignoreCase, "g"=global, "m"=multiline
re.test(str)                          // Bool
re.execute(str)                       // List объектов Match
re.findAll(str)                       // List строк (удобный метод)
re.replace(str, replacement)          // String с заменами
re.release()

// Объект Match:
match.value   // совпавшая строка
match.index   // начальная позиция
match.length  // длина совпадения
match.toString  // то же что match.value

// Статические методы (создают/освобождают Regex внутри):
Regex.test(pattern, str)              // Bool
Regex.findAll(pattern, str)           // List строк
Regex.replace(pattern, str, repl)     // String
```

### 10.8 adodb.wren

```wren
import "adodb" for Database, Recordset

// Database:
var db = Database.open(connStr)               // открыть со строкой подключения
var db = Database.openAccess(path)            // ACE.OLEDB.12.0 (Access .accdb/.mdb)
var db = Database.openSqlServer(server, dbName) // SQLOLEDB, SSPI auth
var rs = db.query(sql)                        // возвращает Recordset
db.execute(sql)                               // INSERT/UPDATE/DELETE без результата
var val = db.scalar(sql)                      // первое поле первой строки
db.state                                      // 0=закрыто, 1=открыто
db.close()
db.release()

// Recordset:
rs.eof                                        // Bool — конец данных
rs.moveNext()
rs.moveFirst()
rs.moveLast()
rs.movePrevious()
rs.field(name)                                // поле по имени или индексу
rs[name]                                      // подстрочный синтаксис для field(name)
rs.recordCount                                // может быть -1 для forward-only курсоров
rs.fieldCount                                 // количество колонок
rs.fieldName(index)                           // имя колонки по 0-based индексу
rs.each(fn)                                   // итерация строк: fn получает Recordset
rs.toList()                                   // возвращает List of Maps (все строки)
rs.close()
rs.release()
```

**Паттерн итерации по строкам:**

```wren
var rs = db.query("SELECT Name, Age FROM Users")
while (!rs.eof) {
    System.print(rs.field("Name") + " " + rs.field("Age"))
    rs.moveNext()
}
rs.close()
rs.release()
```

**Паттерн toList:**

```wren
var rows = db.query("SELECT * FROM Items").toList()
for (row in rows) {
    System.print(row["Name"])
}
```

---

## 11. Критические ошибки и подводные камни

### 11.1 Старые копии ole_helper.dll затеняют новую

`LoadLibraryA` находит ПЕРВЫЙ совпадающий DLL в PATH. Если в рабочей директории или директории exe есть устаревшие копии, они затеняют обновлённую версию.

```bat
del ole_helper.dll
del ole\c\ole_helper.dll
```

**Симптом:** ole-функции равны null (0x00000000) после загрузки.

### 11.2 Имена методов Wren не могут начинаться с `_`

```wren
// ОШИБКА: "Expect method definition"
foreign _enumBegin()

// ПРАВИЛЬНО: trailing underscore допустим
foreign enumBegin_()

// ПРАВИЛЬНО: другое имя
foreign oleEnumBegin()
```

### 11.3 Однострочный `{ return expr }` ломается в некоторых embedded-контекстах

Wren не использует точку с запятой. Проблема — парсинг однострочных тел в C++ raw string литералах.

```wren
// Может сломаться в C++ R"(...)":
getR(prop) { var r = get(prop); release(); return r }

// Правильно — многострочно с переносами:
getR(prop) {
    var r = get(prop)
    release()
    return r
}
```

### 11.4 Утечка VT_DISPATCH (двойное освобождение)

При извлечении IDispatch из VARIANT необходимо очистить тип VARIANT ДО вызова VariantClear, иначе VariantClear освободит тот же указатель, который теперь принадлежит Wren.

```cpp
// НЕПРАВИЛЬНО: VariantClear освободит pDisp, затем Wren освободит снова → crash
IDispatch* pDisp = v->pdispVal;
var_clear(v);  // BUG: releases pDisp

// ПРАВИЛЬНО: передать ownership
IDispatch* pDisp = v->pdispVal;
v->vt = VT_EMPTY;      // запретить VariantClear освобождать pDisp
v->ptrVal = nullptr;
var_clear(v);           // безопасно — нечего освобождать
// теперь передать pDisp в Wren
```

### 11.5 Fallback DISPID_NEWENUM для ForEach

Прямой invoke с `DISPID_NEWENUM (-4)` падает для `Scripting.Dictionary` с `HRESULT=0x80020003 (DISP_E_MEMBERNOTFOUND)`. Решение — fallback через `GetIDsOfNames("_NewEnum")`:

```cpp
// Сначала попытка: прямой DISPID_NEWENUM
DISPID dispid = DISPID_NEWENUM;
HRESULT hr = IDispatch_Invoke(pDisp, dispid, DISPATCH_PROPERTYGET|DISPATCH_METHOD, ...);
if (FAILED(hr)) {
    // Fallback: разрешить по имени
    wchar_t enumName[] = L"_NewEnum";
    IDispatch_GetIDsOfNames(pDisp, &IID_NULL, &pwszName, 1, LOCALE_USER_DEFAULT, &dispid);
    hr = IDispatch_Invoke(pDisp, dispid, DISPATCH_PROPERTYGET|DISPATCH_METHOD, ...);
}
// Затем QI для IEnumVARIANT
```

### 11.6 GC собирает ESlot

ESlot ОБЯЗАТЕЛЬНО хранить в `__gshared`-массиве — иначе GC соберёт объект при выходе из scope, что приведёт к crash при следующей эмиссии сигнала.

```d
__gshared ESlot[] g_slots;  // хранилище всех слотов

auto sl = new ESlot(btn.getWH());
sl.set(cast(void*)&cbClick);
btn.connect_clicked(sl);
g_slots ~= sl;  // ОБЯЗАТЕЛЬНО
```

### 11.7 Сигнатура call() должна точно совпадать

```d
// 0-аргументный метод:
vm.call("main", "Handler", "onEvent()")     // правильно
vm.call("main", "Handler", "onEvent")       // неправильно — нет ()

// N-аргументный метод:
vm.call("main", "Handler", "process(_,_)") // 2 аргумента — правильно
vm.call("main", "Handler", "process()")    // неправильно — найдёт только 0-arg overload
```

### 11.8 COM-коллекции индексируются с 1

```wren
// Sheets, Items и т.д.: индекс начинается с 1
var sheet = wb.call("Worksheets", 1)   // первый лист
// НЕ: wb.call("Worksheets", 0) — вызовет OLE-ошибку
```

### 11.9 Обязательный release() для каждого OleObject

```wren
// Каждый OleObject из .get()/.call()/.create() обязательно освободить
var wbs = app.get("Workbooks")   // создаёт OleObject
var wb = wbs.call("Add")         // создаёт OleObject
// ... работа ...
wb.release()
wbs.release()
// ИЛИ использовать getR/callR для авто-освобождения промежуточных объектов
```

### 11.10 each{} — освобождать dispatch-элементы

```wren
collection.each {|item|
    // если item — OleObject (VT_DISPATCH), освобождать
    item.release()
}
// Если элементы — примитивы (строки, числа), release() не нужен
// Вызов release() на null OleObject безопасен (isNull-проверка внутри)
```

### 11.11 wren.h в C++ требует extern "C"

```cpp
// ПРАВИЛЬНО:
extern "C" {
#include "wren.h"
}

// НЕПРАВИЛЬНО (ошибка линковщика: undefined reference to wrenGetSlotDouble):
#include "wren.h"
```

### 11.12 Wren String не реализует `<`

Wren не поддерживает `<` для строк — runtime error "does not implement '<(_)'".

```wren
// ОШИБКА: Runtime error
if (a < b) { ... }

// ПРАВИЛЬНО:
import "utils" for StringUtil
if (StringUtil.less(a, b)) { ... }

// При сортировке списка строк:
ListUtil.sort(myStringList)   // автоматически использует StringUtil.less
```

### 11.13 `%` внутри строки = интерполяция

```wren
// BUG: %(value) — начало string interpolation
var msg = "100%"               // ОШИБКА: синтаксическая ошибка

// ПРАВИЛЬНО: экранировать \%
var msg = "100\%"
```

### 11.14 `call()`/`get()` возвращают не Wren null при ошибке

При ошибке COM-вызова `call()`, `get()`, `connect()` **всегда** возвращают `OleObject` с нулевым указателем, а **не** Wren `null`:

```wren
var result = obj.call("MayFail")
// Проверять через .isNull, а не через == null:
if (result.isNull) {
    // ошибка
}
```

### 11.15 Повторный `interpret()` в тот же модуль падает на повторных import

Переменные модуля живут в VM после завершения `interpret()`. Если два сниппета
подряд исполнить в одном модуле (например, `"main"`) и оба делают
`import "utils" for StringUtil`, второй падает с compile-ошибкой
`Module variable is already defined` — import повторно определяет переменную
`StringUtil` в том же модуле.

Следствия:
- В тестах/сценариях с несколькими сниппетами — каждый сниппет в свой модуль
  (`"m0"`, `"m1"`, ...) либо новый VM.
- Положительная сторона: ранее импортированные имена **доступны** в следующих
  сниппетах того же модуля без повторного import (так устроен test_wren_import.d).
- «Горячая перезагрузка» одного и того же файла через `loadFile(path)` в тот же
  модуль сломается на втором вызове, если файл импортирует модули `for X` —
  вызывать с новым именем модуля или пересоздавать VM.

---

## 12. C++ внутренности wren_bridge.dll

Файл: `wren/c/wren_bridge.cpp`

### 12.1 Ключевые структуры

```cpp
struct WrenBridge {
    WrenVM* vm;
    WrenWriteCb writeCb;
    WrenErrorCb errorCb;
    void* ud;
    std::map<std::string, void*> widgets;      // name → QWidget*
    std::vector<std::string> libPaths;          // для file import
    void* currentEnum;  // IEnumVARIANT* во время .each{} итерации
    // result storage (заполняется после wrenBridge_call)
    int         resultType;    // 0=num,1=bool,2=str,3=null,4=other
    double      resultDouble;
    int         resultBool;
    std::string resultString;
    // аргументы из D (argDouble/argString/argBool перед call)
    std::vector<PendingArg> pendingArgs;
};
```

### 12.2 Экспортируемый C API

```cpp
void* wrenBridge_create(WrenWriteCb, WrenErrorCb, void* ud);
void  wrenBridge_free(void*);
int   wrenBridge_interpret(void*, const char* module, const char* source);
int   wrenBridge_loadFileUtf8(void*, const char* module, const char* path);
void  wrenBridge_setWidget(void*, const char* name, void* wh);
void  wrenBridge_clearWidgets(void*);
void  wrenBridge_addLibPath(void*, const char* path);
void  wrenBridge_argDouble(void*, int slot, double val);
void  wrenBridge_argString(void*, int slot, const char* val);
void  wrenBridge_argBool(void*, int slot, int val);
int   wrenBridge_call(void*, const char* module, const char* className, const char* sig);
int   wrenBridge_resultType(void*);
double wrenBridge_resultDouble(void*);
int   wrenBridge_resultBool(void*);
const char* wrenBridge_resultString(void*);
int   wrenBridge_hasVariable(void*, const char* module, const char* name);
```

### 12.3 Встроенные исходники модулей

Исходники модулей встроены как C string-литералы (raw strings) в `wren_bridge.cpp`:
- `QT_MODULE_SRC` — модуль "qt" (Widget, Widgets, Logger)
- `OLE_MODULE_SRC` — модуль "ole" (OleObject)
- `IO_MODULE_SRC` — модуль "io" (File)
- `SYS_MODULE_SRC` — модуль "sys" (Sys)

### 12.4 OLE-функции из ole_helper.dll

OLE-функции загружаются из `ole_helper.dll` (отдельный DLL, не wren_bridge.dll):

```cpp
// Ключевые typedef в структуре OleFuncs:
void* (*enum_begin)(void* pDisp);                         // ole_enum_begin
int   (*enum_next)(void* pEnum, ole_variant_t* result);  // ole_enum_next
void  (*enum_release)(void* pEnum);                       // ole_enum_release
```

### 12.5 OLE variant types

```c
#define OLE_VT_EMPTY    0
#define OLE_VT_BOOL     11
#define OLE_VT_I4       3
#define OLE_VT_R8       5
#define OLE_VT_BSTR     8
#define OLE_VT_DISPATCH 9
#define OLE_VT_DATE     7   // OLE дата как double
```

---

## 13. Команды сборки

### 13.1 Компиляция теста с Wren

```bat
dmd -m32 ^
    test\test_wren_vba.d ^
    wren\d\wren_vm.d ^
    -Iwren\d ^
    -of=test\test_wren_vba.exe

set PATH=%CD%\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%
test\test_wren_vba.exe
:: ВНИМАНИЕ: тест вызывает LoadWren("./dll/wren_bridge.dll") — путь относительно cwd.
:: Из корня репозитория ./dll/wren_bridge.dll нет (DLL лежит в dll/dll32/) —
:: запускать из директории, где ./dll/wren_bridge.dll существует (напр. развёрнутый runtime),
:: либо скопировать wren_bridge.dll (+ ole_helper.dll) в ./dll.
```

### 13.2 Сборка wren_bridge.dll

```bat
cd wren\c
qmake wren_bridge.pro
mingw32-make -j4
```

Вывод: `../../dll/dll32/wren_bridge.dll` (DESTDIR из `wren_bridge.pro`; 64-bit → `dll/dll64`, Linux → `lib/`).

`wren_bridge.pro` линкует `ole_helper.dll` через import lib или загружает через `LoadLibraryA` в runtime.

---

## 14. Тесты

Скрипты сборки: `test/build_wren_*.bat`. Исходники тестов: `test/test_wren_*.d`.

Состояние на 2026-08-31 (прогон из директории с `./dll/wren_bridge.dll`):

| Файл | Тестов | Покрытие |
|---|---|---|
| `test_wren_loader.d` | 13/13 | LoadWren, interpret, loadFile (UTF-8 путь), call/callNum/callStr, setWidget, hasVariable, LoadQt. Починен 2026-08-31 (был незакрытый строковый литерал в check()) |
| `test_wren_ole.d` | 25/25 | OLE module, Dictionary CRUD, lastError, FSO multi-arg, release. Починен 2026-08-31: проверка `r.isNull` вместо `r == null` (см. §13/контракт «всегда OleObject») |
| `test_wren_import.d` | 23/23 | File import, utils, multiple lib paths. Починен 2026-08-31: `Excel` → `XlUtil` (colLetter/addr), `StringUtil.trim` → встроенный `String.trim()` |
| `test_wren_libs.d` | 25/25 | File I/O, FSO, Shell, Word/Outlook import, OleObject.connect. Починен 2026-08-31: `obj.isNull` вместо `obj == null` |
| `test_wren_sort.d` | 23/23 | StringUtil.less, ListUtil.sort/sortBy/dedup/sortedUniq. Починен 2026-08-31: каждый сниппет — в своём модуле (повторный interpret в тот же модуль падает с "Module variable is already defined") |
| `test_wren_vba.d` | 32/32 | ForEach (Dictionary/FSO), count/subscript, Sys (sleep/clock/env), Regex (test/findAll/replace), ADODB import, getR/callR chaining |
| **Итого** | **141/141** | |

---

## 15. Решения по дизайну

**Почему Wren, а не Lua/Python?** Wren выбран за малый размер, чистый embedding API и читаемый синтаксис, близкий к JavaScript. Для вычислений он не быстрее VBA.

**Почему нет нативного VBA-style dot chaining?** Wren статически диспетчеризирован — нет `method_missing`. Все имена методов должны быть объявлены на этапе компиляции. `getR/callR` chaining — практическое решение. Истинный VBA-стиль потребовал бы модификации Wren VM (значительные трудозатраты) или переключения на Lua/Python.

**COM events (IConnectionPoint)?** Не реализованы — низкий приоритет. 90% задач автоматизации — пакетные (открыть, обработать, сохранить, закрыть). Polling через QTimer — workaround для event-driven сценариев.

**VT_DATE?** OLE Automation date (type 7) возвращается как double. День 0 = 30 декабря 1899 (OLE convention). Дробная часть = время суток.

**ole_helper.dll отдельно от wren_bridge.dll** — позволяет использовать OLE из чистого D без Wren, и позволяет wren_bridge.dll загружать ole_helper.dll лениво (только при первом импорте модуля "ole").

**Диспетчеризация Widget** — использует `qobject_cast<QLabel*>` и т.д. в момент вызова для определения типа виджета. Если каст не удался — метод игнорируется молча, без краша. Это защищает от ошибок несоответствия типов.

---

## 16. Быстрый справочник — типичные паттерны

### 16.1 Минимальный D-программа с Wren

```d
import qte56_loader;
import gen_qcore, gen_qpushbutton;
import wren_vm;

__gshared WrenVM g_vm;
__gshared ESlot[] g_slots;

extern(C) static void cbClick(void* dthis, int n, int checked) {
    g_vm.call("main", "App", "onButtonClick()");
}

void main() {
    LoadQt("./dll");
    LoadWren("./dll/wren_bridge.dll");
    auto app = new QApplication("Demo");
    auto btn = new QPushButton("Click me");

    g_vm = new WrenVM();
    g_vm.setWidget("btn", btn.getWH());
    g_vm.addLibPath("./wren/lib");
    g_vm.loadFile("app.wren");

    auto sl = new ESlot(btn.getWH());
    sl.set(cast(void*)&cbClick);
    btn.connect_clicked(sl);
    g_slots ~= sl;

    btn.show();
    app.exec();
    app.deleteApp();
}
```

```wren
// app.wren
import "qt" for Widgets, Logger

class App {
    static onButtonClick() {
        var btn = Widgets.get("btn")
        btn.setText("Clicked!")
        Logger.print("Button clicked\n")
    }
}
```

### 16.2 Excel автоматизация из Wren

```wren
import "ole" for OleObject
import "excel" for XlApp

class ExcelDemo {
    static run() {
        var xl = XlApp.new()            // невидимый
        var wb = xl.newBook()
        var sheet = wb.activeSheet()
        sheet.setValue("A1", "Hello")
        sheet.setValue("B1", 42)
        wb.saveAs("C:/temp/out.xlsx")
        wb.close()
        wb.release()
        sheet.release()
        xl.quit()
    }
}
```

### 16.3 ADODB запрос

```wren
import "adodb" for Database

class DbDemo {
    static query() {
        var db = Database.openAccess("C:/data/mydb.accdb")
        var rs = db.query("SELECT Name, Age FROM Users WHERE Age > 30")
        while (!rs.eof) {
            System.print("%(rs.field("Name")): %(rs.field("Age"))")
            rs.moveNext()
        }
        rs.close()
        rs.release()
        db.close()
        db.release()
    }
}
```

### 16.4 Regex поиск и замена

```wren
import "regex" for Regex

class RegexDemo {
    static run() {
        // Статический метод — создаёт/освобождает Regex внутри
        var found = Regex.findAll("\\d+", "abc 42 def 99")
        for (n in found) { System.print(n) }

        // Инстанс для переиспользования
        var re = Regex.new("\\b\\w+@\\w+\\.\\w+\\b", "i")
        if (re.test("user@example.com")) {
            System.print("Email found")
        }
        re.release()
    }
}
```

### 16.5 Shell команды и stdout

```wren
import "shell" for Shell

class ShellDemo {
    static run() {
        var sh = Shell.new()
        var proc = sh.exec("dir C:\\")
        var out = Shell.readStdOut(proc)
        System.print(out)
        proc.release()
        sh.release()
    }
}
```

### 16.6 Чтение результата из D

```d
// Передача аргументов перед вызовом:
g_vm.argDouble(1, 100.0);
g_vm.argString(2, "meters");
int rc = g_vm.call("main", "Converter", "convert(_,_)");
if (rc == 0 && g_vm.resultType() == 2) {
    string result = g_vm.resultString();
}

// Удобные обёртки:
double val = g_vm.callNum("main", "Calc", "getTotal()");
string name = g_vm.callStr("main", "Config", "appName()");
bool flag = g_vm.callBool("main", "State", "isReady()");
```

---

*Документ для проекта QTE56. Состояние тестов Wren-подсистемы на 2026-08-02 — см. §14 (test_wren_loader.d не компилируется; test_wren_import.d устарел относительно excel.wren/utils.wren).*
