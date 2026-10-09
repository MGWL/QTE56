# Задание: Wren Inspector — встроенный отладчик для D+Qt приложений

## Контекст проекта

Проект: `C:\gpt\qte56\arch_new\`
Стек: D (dmd -m32) + Qt 5.13.2 (MinGW 32-bit) + Wren VM (wren_bridge.dll)
Qt: `C:\Qt5_13_2\5.13.2\mingw73_32`

Уже существует:
- `wren/c/wren_bridge.cpp` — Wren VM с встроенными модулями "ole", "io", "qt", "sys"
- `wren/c/wren_bridge.pro` — сборка wren_bridge.dll
- `dll/wren_bridge.dll` — готовая DLL
- `d/wren_vm.d` — D-обёртка над WrenVM
- `d/gen/gen_*.d` — Qt-биндинги (QDialog, QPlainTextEdit, QLineEdit, QPushButton, QComboBox, QTimer и др.)
- `wren/lib/` — Wren-библиотеки (excel.wren, utils.wren, ...)

Задача: реализовать **Wren Inspector** — встроенный отладчик Qt-приложения,
управляемый через Wren REPL/сценарии.

---

## Архитектура

### Новые файлы

```
cpp/wren_inspector/
    wren_inspector.h          — C++ объявления (Qt introspection + память)
    wren_inspector.cpp        — реализация
    wren_inspector.pro        — сборка → dll/wren_inspector.dll

wren/c/wren_bridge.cpp        — ИЗМЕНИТЬ: добавить модули "inspector","mem",
                                "log","out","check","perf","typereg","watch","session"
                                "log"  → пишет в панель Monitor (из D-кода)
                                "out"  → пишет в панель Console (из Wren-сценариев)

d/wren_console.d              — WrenConsole: QDialog с REPL и сценариями

wren/lib/inspector.wren       — высокоуровневые helpers поверх встроенного модуля
wren/lib/mem.wren             — helpers для работы с памятью

wren/scenarios/               — папка для сценариев пользователя
    example_widget_tree.wren
    example_memory_check.wren

wren/sessions/                — автосохранение сессий REPL (создаётся автоматически)
```

### DLL группы
`wren_inspector.dll` — отдельная DLL (как wren_bridge.dll, не входит в merged).
Загружается через `LoadLibraryA("wren_inspector.dll")` при инициализации WrenConsole.

### Две панели вывода — ключевая концепция

WrenConsole содержит **два независимых потока вывода**:

| Панель | Имя | Источник | Характер |
|--------|-----|----------|----------|
| Левая  | **Monitor** | D-код приложения, Watch | Пассивный, непрерывный |
| Правая | **Console** | REPL, сценарии | Активный, по запросу |

Смешивать потоки нельзя — дамп памяти из сценария перебьёт живой лог приложения.

- `Log.*` вызванные **из D-кода** → Monitor
- Watch-уведомления (таймер) → Monitor
- Signal trace → Monitor
- REPL ввод + результаты → Console
- Вывод сценариев (`Out.*`, `Mem.dump`, `Check.report`, `Perf.report`) → Console

В C++ два глобальных указателя: `g_monitorWidget` и `g_consoleWidget` (оба `void*` на QPlainTextEdit).
Устанавливаются через `winsp_setMonitorWidget(ptr)` и `winsp_setConsoleWidget(ptr)`.

---

## Часть 1: C++ модуль wren_inspector

### wren_inspector.pro

```qmake
QT       += core gui widgets
TARGET    = wren_inspector
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += WREN_INSPECTOR_BUILD
DESTDIR   = ../../dll
SOURCES   = wren_inspector.cpp
HEADERS   = wren_inspector.h
```

### wren_inspector.h — экспортируемые функции

```cpp
#ifdef WREN_INSPECTOR_BUILD
#define WINSP_API __declspec(dllexport)
#else
#define WINSP_API __declspec(dllimport)
#endif

extern "C" {

// ── Qt Object Introspection ──────────────────────────────────────────────────

// Найти виджет по objectName. Возвращает void* (QObject*) или null.
WINSP_API void*  winsp_findByName(const wchar_t* name, int len);

// Все виджеты: заполнить массив out[] размером maxCount. Вернуть реальное кол-во.
WINSP_API int    winsp_allWidgets(void** out, int maxCount);

// Только верхнеуровневые окна
WINSP_API int    winsp_topWidgets(void** out, int maxCount);

// objectName → запись в buf. Возвращает длину.
WINSP_API int    winsp_objectName(void* obj, wchar_t* buf, int bufLen);

// C-строка класса: "QPushButton", "QLabel" и т.п.
WINSP_API const char* winsp_className(void* obj);

// Адрес объекта как 32-bit integer (для 32-bit процесса)
WINSP_API unsigned int winsp_address(void* obj);

// Родитель (QObject*)
WINSP_API void*  winsp_parent(void* obj);

// Число дочерних объектов
WINSP_API int    winsp_childCount(void* obj);

// Дочерний по индексу (0-based)
WINSP_API void*  winsp_childAt(void* obj, int idx);

// Число Q_PROPERTY
WINSP_API int    winsp_propCount(void* obj);

// Имя свойства по индексу → buf
WINSP_API int    winsp_propName(void* obj, int idx, wchar_t* buf, int bufLen);

// Значение свойства по имени → wchar* (QVariant.toString()). Вернуть длину.
WINSP_API int    winsp_propGet(void* obj,
                               const wchar_t* name, int nameLen,
                               wchar_t* buf, int bufLen);

// Установить свойство (значение передаётся как строка, конвертируется через QVariant)
WINSP_API int    winsp_propSet(void* obj,
                               const wchar_t* name, int nameLen,
                               const wchar_t* val,  int valLen);

// Вызов слота по имени (без аргументов)
WINSP_API int    winsp_invoke(void* obj, const wchar_t* method, int len);

// Вызов слота с одним строковым аргументом
WINSP_API int    winsp_invokeStr(void* obj,
                                 const wchar_t* method, int mlen,
                                 const wchar_t* arg,    int alen);

// ── Signal/Connection Introspection ─────────────────────────────────────────

// Число сигналов в метаобъекте
WINSP_API int    winsp_signalCount(void* obj);

// Имя сигнала по индексу
WINSP_API int    winsp_signalName(void* obj, int idx, wchar_t* buf, int bufLen);

// Число соединений для сигнала с данным именем
WINSP_API int    winsp_connCount(void* obj, const wchar_t* signal, int slen);

// Информация о соединении: receiver ptr + slot name
WINSP_API void*  winsp_connReceiver(void* obj, const wchar_t* signal, int slen, int connIdx);
WINSP_API int    winsp_connSlotName(void* obj, const wchar_t* signal, int slen,
                                    int connIdx, wchar_t* buf, int bufLen);

// ── Snapshot / Diff ─────────────────────────────────────────────────────────

// Снимок всех Q_PROPERTY объекта. Возвращает handle (malloc'd структура).
WINSP_API void*  winsp_snapshotCreate(void* obj);
WINSP_API void   winsp_snapshotFree(void* snap);

// Diff двух снимков одного объекта → JSON-подобный wchar текст.
// caller освобождает через winsp_diffFree
WINSP_API wchar_t* winsp_diff(void* snap1, void* snap2);
WINSP_API void     winsp_diffFree(wchar_t* buf);

// ── Memory Operations ────────────────────────────────────────────────────────

// Проверка читаемости (VirtualQuery на Windows, /proc/maps на Linux)
WINSP_API int    winsp_memIsValid(unsigned int addr, int size);

// Безопасное чтение (SEH/__try на Windows). Возвращает 1 при успехе.
WINSP_API int    winsp_memRead(unsigned int addr, void* buf, int size);

// Запись (опасно — только в уже allocated память)
WINSP_API int    winsp_memWrite(unsigned int addr, const void* buf, int size);

// Поиск байтового паттерна. Возвращает найденный адрес или 0.
WINSP_API unsigned int winsp_memSearch(unsigned int fromAddr, unsigned int toAddr,
                                        const unsigned char* pattern, int patLen);

// Поиск UTF-8 строки
WINSP_API unsigned int winsp_memSearchStr(unsigned int fromAddr, unsigned int toAddr,
                                           const char* str);

// Поиск адреса-значения (кто держит ссылку на ptr)
WINSP_API unsigned int winsp_memSearchPtr(unsigned int fromAddr, unsigned int toAddr,
                                           unsigned int ptr);

// ── Log Widget Registration ───────────────────────────────────────────────────

// Установить QPlainTextEdit* для панели Monitor (D-код → сюда)
WINSP_API void   winsp_setMonitorWidget(void* plainTextEdit);

// Установить QPlainTextEdit* для панели Console (Wren REPL/сценарии → сюда)
WINSP_API void   winsp_setConsoleWidget(void* plainTextEdit);

// Пауза/возобновление Monitor (при паузе буферизует, при возобновлении сбрасывает)
WINSP_API void   winsp_monitorPause();
WINSP_API void   winsp_monitorResume();
WINSP_API int    winsp_monitorPaused();  // 1 если на паузе

// ── Performance ──────────────────────────────────────────────────────────────

WINSP_API void          winsp_perfStart(const wchar_t* name, int len);
WINSP_API long long     winsp_perfStop(const wchar_t* name, int len); // ms
WINSP_API void          winsp_perfReset();
WINSP_API int           winsp_perfCount();                            // число записей
WINSP_API int           winsp_perfName(int idx, wchar_t* buf, int bufLen);
WINSP_API long long     winsp_perfMs(int idx);

} // extern "C"
```

### Ключевые реализации wren_inspector.cpp

```cpp
#include <QApplication>
#include <QWidget>
#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include <QObjectList>
#include <QMetaMethod>
#include <QVariant>
#include <windows.h>    // VirtualQuery, QueryPerformanceCounter

// ── findByName ───────────────────────────────────────────────────────────────
void* winsp_findByName(const wchar_t* name, int len) {
    QString qname = QString::fromWCharArray(name, len);
    for (QWidget* w : QApplication::allWidgets()) {
        if (w->objectName() == qname) return w;
    }
    return nullptr;
}

// ── allWidgets ───────────────────────────────────────────────────────────────
int winsp_allWidgets(void** out, int maxCount) {
    auto list = QApplication::allWidgets();
    int n = qMin(list.size(), maxCount);
    for (int i = 0; i < n; i++) out[i] = list[i];
    return list.size();
}

// ── propGet ──────────────────────────────────────────────────────────────────
int winsp_propGet(void* obj, const wchar_t* name, int nameLen, wchar_t* buf, int bufLen) {
    QObject* o = (QObject*)obj;
    QString qname = QString::fromWCharArray(name, nameLen);
    QVariant v = o->property(qname.toUtf8().constData());
    QString s = v.toString();
    int n = qMin(s.size(), bufLen - 1);
    s.left(n).toWCharArray(buf);
    buf[n] = 0;
    return n;
}

// ── propSet ──────────────────────────────────────────────────────────────────
int winsp_propSet(void* obj, const wchar_t* name, int nameLen,
                  const wchar_t* val, int valLen) {
    QObject* o = (QObject*)obj;
    QString qname = QString::fromWCharArray(name, nameLen);
    QString qval  = QString::fromWCharArray(val, valLen);
    // Пытаемся угадать тип из метаобъекта:
    int pidx = o->metaObject()->indexOfProperty(qname.toUtf8().constData());
    if (pidx < 0) return 0;
    QMetaProperty mp = o->metaObject()->property(pidx);
    QVariant v;
    switch (mp.type()) {
        case QVariant::Bool:   v = (qval == "true" || qval == "1"); break;
        case QVariant::Int:    v = qval.toInt(); break;
        case QVariant::Double: v = qval.toDouble(); break;
        default:               v = qval;
    }
    return o->setProperty(qname.toUtf8().constData(), v) ? 1 : 0;
}

// ── invoke ───────────────────────────────────────────────────────────────────
int winsp_invoke(void* obj, const wchar_t* method, int len) {
    QObject* o = (QObject*)obj;
    QByteArray m = QString::fromWCharArray(method, len).toUtf8();
    return QMetaObject::invokeMethod(o, m.constData(), Qt::DirectConnection) ? 1 : 0;
}

// ── signalCount / connCount ──────────────────────────────────────────────────
int winsp_signalCount(void* obj) {
    const QMetaObject* mo = ((QObject*)obj)->metaObject();
    int count = 0;
    for (int i = 0; i < mo->methodCount(); i++)
        if (mo->method(i).methodType() == QMetaMethod::Signal) count++;
    return count;
}

// ── Snapshot ─────────────────────────────────────────────────────────────────
struct Snapshot {
    void*    objPtr;
    QString  objName;
    QString  className;
    QVariantMap props;
};

void* winsp_snapshotCreate(void* obj) {
    QObject* o = (QObject*)obj;
    auto* s = new Snapshot;
    s->objPtr   = obj;
    s->objName  = o->objectName();
    s->className = o->metaObject()->className();
    const QMetaObject* mo = o->metaObject();
    for (int i = 0; i < mo->propertyCount(); i++) {
        QMetaProperty mp = mo->property(i);
        s->props[mp.name()] = mp.read(o);
    }
    return s;
}

wchar_t* winsp_diff(void* snap1, void* snap2) {
    auto* s1 = (Snapshot*)snap1;
    auto* s2 = (Snapshot*)snap2;
    QString result;
    QSet<QString> keys = s1->props.keys().toSet() + s2->props.keys().toSet();
    for (const QString& k : keys) {
        QString v1 = s1->props.value(k).toString();
        QString v2 = s2->props.value(k).toString();
        if (v1 != v2)
            result += QString("CHANGED|%1|%2|%3\n").arg(k).arg(v1).arg(v2);
        else
            result += QString("SAME|%1|%2\n").arg(k).arg(v1);
    }
    wchar_t* buf = new wchar_t[result.size() + 1];
    result.toWCharArray(buf);
    buf[result.size()] = 0;
    return buf;
}

// ── Memory ───────────────────────────────────────────────────────────────────
int winsp_memIsValid(unsigned int addr, int size) {
    MEMORY_BASIC_INFORMATION mbi;
    if (!VirtualQuery((void*)addr, &mbi, sizeof(mbi))) return 0;
    if (mbi.State != MEM_COMMIT) return 0;
    DWORD prot = mbi.Protect & ~(PAGE_GUARD | PAGE_NOCACHE);
    return (prot == PAGE_READONLY || prot == PAGE_READWRITE ||
            prot == PAGE_EXECUTE_READ || prot == PAGE_EXECUTE_READWRITE) ? 1 : 0;
}

int winsp_memRead(unsigned int addr, void* buf, int size) {
    __try {
        memcpy(buf, (void*)addr, size);
        return 1;
    } __except(EXCEPTION_EXECUTE_HANDLER) {
        return 0;
    }
}

unsigned int winsp_memSearch(unsigned int from, unsigned int to,
                              const unsigned char* pat, int patLen) {
    for (unsigned int a = from; a <= to - patLen; a++) {
        if (!winsp_memIsValid(a, patLen)) { a += 4095; continue; }
        unsigned char buf[4096];
        int chunk = qMin(patLen + 16, 4096);
        if (!winsp_memRead(a, buf, chunk)) continue;
        if (memcmp(buf, pat, patLen) == 0) return a;
    }
    return 0;
}

// ── Performance ──────────────────────────────────────────────────────────────
struct PerfEntry { QString name; LARGE_INTEGER start; long long ms; bool running; };
static QVector<PerfEntry> g_perf;

void winsp_perfStart(const wchar_t* name, int len) {
    QString qname = QString::fromWCharArray(name, len);
    for (auto& e : g_perf) if (e.name == qname) {
        QueryPerformanceCounter(&e.start);
        e.running = true; return;
    }
    PerfEntry e; e.name = qname; e.ms = 0; e.running = true;
    QueryPerformanceCounter(&e.start);
    g_perf.append(e);
}

long long winsp_perfStop(const wchar_t* name, int len) {
    QString qname = QString::fromWCharArray(name, len);
    LARGE_INTEGER now, freq;
    QueryPerformanceCounter(&now);
    QueryPerformanceFrequency(&freq);
    for (auto& e : g_perf) if (e.name == qname && e.running) {
        e.ms = (now.QuadPart - e.start.QuadPart) * 1000 / freq.QuadPart;
        e.running = false;
        return e.ms;
    }
    return -1;
}
```

---

## Часть 2: Wren-модули в wren_bridge.cpp

Загрузить `wren_inspector.dll` при инициализации (аналогично ole_helper.dll).
Добавить 8 новых встроенных модулей.

### Структура g_winsp (аналог g_ole)

```cpp
struct WInspector {
    HMODULE hlib = nullptr;
    bool loaded = false;
    // указатели на все winsp_* функции
    void* (*findByName)(const wchar_t*, int) = nullptr;
    int   (*allWidgets)(void**, int) = nullptr;
    // ... все остальные функции ...
};
static WInspector g_winsp;

static bool winspEnsureLoaded() {
    if (g_winsp.loaded) return true;
    HMODULE h = LoadLibraryA("wren_inspector.dll");
    if (!h) return false;
    g_winsp.hlib = h;
    #define LOAD(fn) g_winsp.fn = (decltype(g_winsp.fn))GetProcAddress(h, "winsp_" #fn)
    LOAD(findByName); LOAD(allWidgets); LOAD(topWidgets);
    LOAD(objectName); LOAD(className); LOAD(address);
    LOAD(parent); LOAD(childCount); LOAD(childAt);
    LOAD(propCount); LOAD(propName); LOAD(propGet); LOAD(propSet);
    LOAD(invoke); LOAD(invokeStr);
    LOAD(signalCount); LOAD(signalName);
    LOAD(connCount); LOAD(connReceiver); LOAD(connSlotName);
    LOAD(snapshotCreate); LOAD(snapshotFree); LOAD(diff); LOAD(diffFree);
    LOAD(memIsValid); LOAD(memRead); LOAD(memWrite);
    LOAD(memSearch); LOAD(memSearchStr); LOAD(memSearchPtr);
    LOAD(setMonitorWidget); LOAD(setConsoleWidget);
    LOAD(monitorPause); LOAD(monitorResume); LOAD(monitorPaused);
    LOAD(perfStart); LOAD(perfStop); LOAD(perfReset);
    LOAD(perfCount); LOAD(perfName); LOAD(perfMs);
    #undef LOAD
    g_winsp.loaded = true;
    return true;
}
```

### Модуль "inspector" — класс Inspector

```wren
// Wren API:
Inspector.find("name")       → QtObj или QtObj с isNull=true
Inspector.allWidgets         → List<QtObj>
Inspector.topWidgets         → List<QtObj>
Inspector.connections(qtobj) → вывод в Log (соединения сигналов)
Inspector.snapshot("name")   → SnapHandle (непрозрачный объект)
Inspector.diff(s1, s2)       → строка с результатом diff (выводит в Log)
Inspector.watchProp(name, prop, fn(old,new))  → установить watch
```

### Модуль "inspector" — класс QtObj (Foreign class)

```wren
// QtObj хранит void* внутри (Foreign)
obj.name          → objectName (строка)
obj.className     → "QPushButton" и т.п.
obj.address       → целое число (адрес в памяти)
obj.isNull        → bool
obj.parent        → QtObj
obj.children      → List<QtObj>
obj.childAt(n)    → QtObj (0-based)
obj.propNames     → List<string>  (все Q_PROPERTY)
obj.property(key) → строка (через QVariant.toString)
obj.setProperty(key, val) → bool
obj.invoke(method)         → bool
obj.invoke(method, arg)    → bool (строковый аргумент)
```

### Модуль "mem" — класс Mem (статический)

```wren
Mem.at(addr)         → MemView (текущая позиция)
Mem.goto_(addr)      // установить текущую позицию (goto зарезервировано в Wren)
Mem.next(n)          // pos += n
Mem.back(n)          // pos -= n
Mem.pos              → текущий адрес
Mem.follow()         // читаем ptr по pos, переходим туда
Mem.follow(offset)   // читаем ptr по pos+offset

Mem.read8(addr)     → int
Mem.read16(addr)    → int
Mem.read32(addr)    → int
Mem.read64(addr)    → int (осторожно с Wren int на 32-bit!)
Mem.readFloat(addr) → num
Mem.readDbl(addr)   → num
Mem.readPtr(addr)   → int (адрес)
Mem.readStr(addr, maxLen)  → строка UTF-8
Mem.readWStr(addr, maxLen) → строка из wchar_t

Mem.isValid(addr)         → bool
Mem.isValid(addr, size)   → bool
Mem.write32(addr, val)    → bool  (осторожно!)

Mem.search(byteList)        → найденный адрес или 0
Mem.searchStr(str)          → адрес или 0
Mem.searchPtr(targetAddr)   → адрес или 0

Mem.watch(addr, size, fn(old, new))  → установить watch
```

### Модуль "mem" — класс MemView

```wren
// Возвращается из Mem.at(addr)
view.dump(n)         // hex + ASCII в Log
view.asBytes(n)      // байты в Log
view.asInt8(n)       // знаковые байты
view.asInt16(n)      // int16[]
view.asInt32(n)      // int32[]
view.asInt64(n)      // int64[]
view.asFloat(n)      // float32[]
view.asDouble(n)     // float64[]
view.asPtr(n)        // адреса (void*[])
view.asStr(maxLen)   // строка
view.asWStr(maxLen)  // wide строка
view.asBits(n)       // двоичное представление n байт
```

### Модуль "log" — класс Log (→ Monitor)

Используется **из D-кода** приложения. Пишет в левую панель Monitor.

```wren
// Все методы Log пишут в панель Monitor
Log.print(msg)         // белый
Log.info(msg)          // синий   [INFO ]
Log.ok(msg)            // зелёный [OK   ]
Log.warn(msg)          // жёлтый  [WARN ]
Log.error(msg)         // красный [ERROR]
Log.val(label, value)  // cyan    [VAL  ] label = value
Log.hex(label, addr)   // маджент [HEX  ] label = 0xADDR
Log.sep(text)          // серый разделитель ────── text ──────
Log.breadcrumb(text)   // серый   [....] text (трассировка пути)
Log.clear()            // очистить Monitor
Log.timestamp = true   // временны́е метки (по умолчанию true)

// Условный вывод — только при изменении значения
Log.ifChanged(key, value)      // Log.val если изменилось
Log.ifChangedWarn(key, value)  // Log.warn если изменилось
```

**Реализация**: `g_monitorWidget` — `void*` (QPlainTextEdit*),
устанавливается через `winsp_setMonitorWidget(ptr)`. HTML → `appendHtml` через `pFunQt[]`.

### Модуль "out" — класс Out (→ Console)

Используется **из Wren-сценариев и REPL**. Пишет в правую панель Console.
API идентичен Log, но целевая панель другая.

```wren
// Все методы Out пишут в панель Console
Out.print(msg)         // белый
Out.info(msg)          // синий   [INFO ]
Out.ok(msg)            // зелёный [OK   ]
Out.warn(msg)          // жёлтый  [WARN ]
Out.error(msg)         // красный [ERROR]
Out.val(label, value)  // cyan    [VAL  ] label = value
Out.hex(label, addr)   // маджент [HEX  ] label = 0xADDR
Out.sep(text)          // серый разделитель
Out.clear()            // очистить Console
Out.timestamp = true   // временны́е метки
```

**Все** методы дампа памяти (`MemView.dump`, `MemView.asInt32` и др.),
`Check.report()`, `Perf.report()`, `Inspector.dumpProps()`, `Inspector.printTree()`
— тоже пишут в Console через `Out`.

**Реализация**: `g_consoleWidget` — `void*` (QPlainTextEdit*),
устанавливается через `winsp_setConsoleWidget(ptr)`.

### Модуль "watch" (дополнение)

Watch-уведомления пишут в **Monitor** (это пассивный поток):

```wren
// callback получает доступ к Log (Monitor), не Out:
Inspector.watchProp("statusLabel", "text") {|old, new_|
    Log.warn("text: '%(old)' → '%(new_)'")   // → Monitor
}
Mem.watch(0x00A1B2C3, 4) {|old, new_|
    Log.warn("int32: %(old) → %(new_)")        // → Monitor
}
```

### Модуль "check" — класс Check

```wren
Check.that(cond, msg)              // проверка условия
Check.equal(a, b, msg)             // a == b
Check.notNull(val, msg)            // val != 0 (адрес или объект)
Check.range(val, min, max, msg)    // min <= val <= max
Check.contains(str, sub, msg)      // строка содержит подстроку
Check.report()                     // вывести итог: N/M прошло
Check.reset()                      // обнулить счётчики
Check.passed                       → int
Check.failed                       → int
```

Реализация: хранить счётчики в C++ через `g_check_passed` / `g_check_failed`.
`Check.that(false, msg)` → `Log.error("[FAIL] msg")`, иначе `Log.ok("[OK] msg")`.

### Модуль "perf" — класс Perf

```wren
Perf.start("section")    // начать замер (QueryPerformanceCounter)
Perf.stop("section")     // остановить, вернуть ms
Perf.report()            // вывести все замеры в Log
Perf.reset()             // сбросить все замеры
```

### Модуль "typereg" — класс TypeReg

```wren
// Описать структуру:
TypeReg.define("MyNode", [
    ["ptr",    "vtable"],
    ["ptr",    "next"],
    ["int32",  "id"],
    ["int32",  "flags"],
    ["float",  "x"],
    ["float",  "y"],
    ["wstr",   "name", 64],   // wstr требует размер в байтах
    ["str",    "tag",  32],   // str = UTF-8
])

TypeReg.names             → List<string>  (все зарегистрированные типы)
TypeReg.sizeOf("MyNode")  → int (байт)

var s = TypeReg.read("MyNode", addr)  → Map (fieldName → value)
Log.val("id",   s["id"])
Log.hex("next", s["next"])

// Вычислить смещение поля:
TypeReg.offsetOf("MyNode", "name")  → int
```

Реализация: TypeReg хранит описания в C++ (`std::map<string, vector<FieldDef>>`).
`read()` читает память через `winsp_memRead`, интерпретирует по типу.

### Модуль "session" — класс Session

```wren
Session.start("sessions/my_session.wren")  // начать запись REPL-команд в файл
Session.stop()                              // остановить запись
Session.replay("sessions/my_session.wren") // воспроизвести (построчный interpret)
Session.autoSave = true  // автосохранение каждой REPL-сессии (по умолчанию true)
                         // файл: sessions/YYYY-MM-DD_HH-MM-SS.wren
```

Реализация: `g_session_file` — открытый FILE* для записи.
Каждая строка из REPL дублируется в файл. `replay()` читает файл построчно
и вызывает `wrenInterpret(vm, "session", line)`.

### Модуль "watch" — Watch система

Watch реализуется через `QTimer` (100ms) в WrenConsole на D-стороне.
В C++/Wren: хранить список watches `{type, addr/name, size, prevValue, callbackFn}`.

```wren
// Установить через Inspector или Mem:
Inspector.watchProp("statusLabel", "text") {|old, new_|
    Log.warn("text: '%(old)' → '%(new_)'")
}

Mem.watch(0x00A1B2C3, 4) {|old, new_|
    Log.warn("int32 изменился: %(old) → %(new_)")
}

Watch.list    → все активные watches
Watch.clear() // снять все watches
```

---

## Часть 3: D-сторона — WrenConsole

### Файл: d/wren_console.d

```d
module wren_console;
// WrenConsole — QDialog с двумя панелями вывода и Wren REPL

import gen_qdialog, gen_qplaintextedit, gen_qlineedit, gen_qsplitter;
import gen_qpushbutton, gen_qcombobox, gen_qlabel, gen_qtimer;
import gen_qvboxlayout, gen_qhboxlayout, gen_qframe;
import gen_qfiledialog;
import wren_vm;

class WrenConsole {
private:
    // Основные виджеты
    void* _dialog;
    void* _splitter;      // QSplitter(Horizontal) — делит Monitor | Console

    // Левая панель — Monitor (D-код, Watch)
    void* _monitorEdit;   // QPlainTextEdit — readonly, monospace
    void* _monPauseBtn;   // QPushButton "⏸" / "▶" (Pause/Resume)
    void* _monClearBtn;   // QPushButton "Очист."
    void* _monLabel;      // QLabel "Monitor"

    // Правая панель — Console (REPL, сценарии)
    void* _consoleEdit;   // QPlainTextEdit — readonly, monospace
    void* _conClearBtn;   // QPushButton "Очист."
    void* _conLabel;      // QLabel "Console"

    // Сценарии
    void* _scenarioCombo; // QComboBox — список *.wren из scenarios/
    void* _runScenBtn;    // QPushButton "▶Run"
    void* _saveBtn;       // QPushButton "Save"

    // REPL
    void* _inputEdit;     // QLineEdit — ввод команды
    void* _runBtn;        // QPushButton "Run ↵"

    // Служебное
    void* _watchTimer;    // QTimer 100ms — опрос Watch
    void* _statusBar;     // QLabel "Виджетов: N | Watch: N"

    WrenVM* _vm;
    string _scenariosDir = "wren/scenarios/";
    string _sessionsDir  = "wren/sessions/";
    string[] _history;
    int    _histIdx = 0;

public:
    this(void* parent);
    void show();

    // Регистрирует _monitorEdit и _consoleEdit в C++ глобалах
    void injectWidgets();

    void refreshScenarios();
    void execute(string code);      // REPL → Console
    void runScenario(string path);  // сценарий → Console
}
```

### Layout консоли

```
┌────────────────────────────────────────────────────────────┐
│ Wren Inspector                                         [X] │
├────────────────────────────────────────────────────────────┤
│ Monitor                    ║ Console                        │
│ [⏸ Pause] [Очист.]         ║ [Очист.]                      │
│ ┌────────────────────────┐ ║ ┌─────────────────────────┐   │
│ │14:22:01 [WARN ]        │ ║ │> Inspector.find("okBtn")│   │
│ │  counter = 42          │ ║ │QtObj: QPushButton "ok"  │   │
│ │14:22:03 [VAL  ]        │ ║ │> obj.children.count     │   │
│ │  name = "Иванов"       │ ║ │3                        │   │
│ │14:22:05 [WATCH]        │ ║ │> Mem.at(0xA1B2C3).dump()│   │
│ │  text:"" → "Готово"    │ ║ │+00 48 65 6C 6C 6F ...   │   │
│ └────────────────────────┘ ║ └─────────────────────────┘   │
│  ←──── QSplitter ────────────────────────────────────→     │
├────────────────────────────────────────────────────────────┤
│ Сценарий: [check_layout.wren ▼]  [▶Run]  [Save]           │
├────────────────────────────────────────────────────────────┤
│ ┌──────────────────────────────────────────┐ [Run ↵]       │
│ │ >                                        │               │
│ └──────────────────────────────────────────┘               │
│ Виджетов: 87 | Watch: 2 | Ошибок: 1                        │
└────────────────────────────────────────────────────────────┘
```

**QSplitter(Horizontal)** — пользователь перетаскивает разделитель.
По умолчанию 40% Monitor / 60% Console.

### Поведение

- **Enter в QLineEdit** → выполнить → результат в Console → добавить в историю
- **↑/↓ в QLineEdit** → навигация по истории команд
- **Незакрытые `{`** → накапливать строки пока не закроются все скобки
- **QTimer 100ms** → опрос активных Watch → уведомления в Monitor
- **⏸ Pause** → Monitor перестаёт принимать новые сообщения (буферизует внутри);
  кнопка меняется на **▶ Resume**; по нажатию Resume сбрасывает буфер разом
- **Автосохранение сессии** → при первом вводе создать `sessions/YYYY-MM-DD_HH-MM.wren`
- **Цвет фона обеих панелей** → тёмная тема: `#1E1E1E`, шрифт `#D4D4D4`, `Courier New` 9pt

### Вызов injectWidgets()

В конструкторе WrenConsole **после создания** обоих QPlainTextEdit:

```d
// D-сторона: передать оба указателя в C++
void injectWidgets() {
    // winsp_setMonitorWidget / winsp_setConsoleWidget — загружены из wren_inspector.dll
    winsp_setMonitorWidget(_monitorEdit);
    winsp_setConsoleWidget(_consoleEdit);
}
```

Это должно произойти ДО первого `wrenInterpret` и ДО любого `Log.*` из D-кода.

### Открытие из приложения

```d
// Вариант 1 — горячая клавиша F12:
mainWin.onKeyPress = (key, mods) {
    if (key == 0x7B) {  // Qt::Key_F12
        WrenConsole.instance(mainWin.getWH()).show();
    }
};

// Вариант 2 — пункт меню Debug:
version(Debug) {
    auto debugMenu = menuBar.addMenu("Debug");
    auto act = debugMenu.addAction("Wren Console");
    act.connect_triggered(() {
        WrenConsole.instance(mainWin.getWH()).show();
    });
}

// Singleton через статическое поле:
// WrenConsole.instance(parent) — создаёт при первом вызове, возвращает тот же при повторных
```

---

## Часть 4: Wren библиотека (wren/lib/)

### inspector.wren — высокоуровневые helpers

```wren
// Печатает дерево виджетов рекурсивно
static printTree(obj, indent) {
    var pad = ""
    var i = 0
    while (i < indent) { pad = pad + "  "  i = i + 1 }
    var name = obj.name == "" ? "<noname>" : obj.name
    Log.print("%(pad)%(name) : %(obj.className)  [0x%(obj.address)]")
    for (child in obj.children) { printTree(child, indent + 1) }
}

// Найти все виджеты данного класса
static findAll(className) {
    var result = []
    for (w in Inspector.allWidgets) {
        if (w.className == className) result.add(w)
    }
    return result
}

// Найти все виджеты без objectName (потенциальные проблемы)
static orphans() {
    var result = []
    for (w in Inspector.allWidgets) {
        if (w.name == "") result.add(w)
    }
    return result
}

// Полный дамп всех свойств объекта
static dumpProps(obj) {
    Log.sep("%(obj.className) '%(obj.name)' [0x%(obj.address)]")
    for (prop in obj.propNames) {
        Log.val(prop, obj.property(prop))
    }
}
```

### mem.wren — форматированный дамп

```wren
// Форматировать дамп hex + ASCII (вызывается из MemView.dump)
static formatHex(addr, bytes) {
    // bytes — List<int>
    // Формирует и выводит в Log построчно по 16 байт
}
```

---

## Часть 5: Примеры сценариев

### wren/scenarios/example_widget_tree.wren

```wren
// Сценарий пишет в Console (Out.*), не в Monitor (Log.*)
import "inspector" for Inspector
import "out" for Out
import "check" for Check

Out.sep("=== Widget Tree Check ===")
Check.reset()

var win = Inspector.find("mainWindow")
Check.notNull(win.address, "mainWindow существует")

if (!win.isNull) {
    Inspector.printTree(win, 0)   // printTree использует Out внутри

    var noName = Inspector.orphans()
    Check.equal(noName.count, 0, "все виджеты именованы")
    if (noName.count > 0) {
        for (w in noName) {
            Out.warn("  безымянный: %(w.className) @ 0x%(w.address)")
        }
    }
}

Check.report()   // → Console
```

### wren/scenarios/example_memory_check.wren

```wren
import "mem" for Mem
import "out" for Out
import "inspector" for Inspector

Out.sep("=== Memory Check ===")

var btn = Inspector.find("saveButton")
if (btn.isNull) {
    Out.error("saveButton не найден")
} else {
    Out.hex("saveButton address", btn.address)
    Out.val("className", btn.className)

    // Дамп первых 32 байт объекта → Console
    Mem.at(btn.address).dump(32)

    // Прочитать vtable ptr и d_ptr
    var vtable = Mem.readPtr(btn.address)
    var dptr   = Mem.readPtr(btn.address + 4)
    Out.hex("vtable", vtable)
    Out.hex("d_ptr",  dptr)

    // Перейти в d_ptr и посмотреть
    if (Mem.isValid(dptr, 64)) {
        Out.sep("QObjectPrivate @ 0x%(dptr)")
        Mem.at(dptr).dump(32)
    }
}
```

### wren/scenarios/example_snapshot_diff.wren

```wren
import "inspector" for Inspector
import "out" for Out

var lbl = Inspector.find("statusLabel")
var snap1 = Inspector.snapshot("statusLabel")

Out.info("Снимок 1 сделан. Нажмите кнопку в приложении, затем запустите сценарий снова.")

Out.sep("Текущее состояние statusLabel")
Inspector.dumpProps(lbl)   // dumpProps использует Out внутри
```

### D-код приложения — пример использования Log (→ Monitor)

```d
// В D-коде приложения Log.* пишет в Monitor — независимо от REPL
import wren_console;

// При загрузке данных:
WrenConsole.log.info("Загрузка файла: " ~ path);
WrenConsole.log.val("записей", count);

// При ошибке:
WrenConsole.log.error("Файл не найден: " ~ path);

// Через Watch (автоматически):
// Watch.list → Monitor при каждом изменении
```

Для удобства `WrenConsole` экспортирует статический объект `log` с методами
`info/warn/error/val/hex/sep` — прокси на `winsp_appendMonitor(...)` из D-кода.

---

## Цветовая схема

Одна схема применяется к **обеим** панелям (Monitor и Console).
Фон обеих: `#1E1E1E`. Шрифт: `Courier New` 9pt.

| Метод | Панель | Цвет HTML | Prefix |
|-------|--------|-----------|--------|
| `Log.print` / `Out.print` | обе | `#D4D4D4` | — |
| `Log.info` / `Out.info` | обе | `#5599FF` | `[INFO ]` |
| `Log.ok` / `Out.ok` | обе | `#55CC55` | `[OK   ]` |
| `Log.warn` / `Out.warn` | обе | `#FFCC00` | `[WARN ]` |
| `Log.error` / `Out.error` | обе | `#FF5555` | `[ERROR]` |
| `Log.val` / `Out.val` | обе | `#00CCCC` | `[VAL  ]` |
| `Log.hex` / `Out.hex` | обе | `#CC88FF` | `[HEX  ]` |
| `Log.sep` / `Out.sep` | обе | `#666666` | `──────` |
| `Log.breadcrumb` | Monitor | `#888888` | `[....]` |
| Watch-уведомление | Monitor | `#FFCC00` | `[WATCH]` |
| Signal trace | Monitor | `#FF8800` | `[SIG  ]` |
| REPL ввод (`> cmd`) | Console | `#888888` | `>` |
| Check OK | Console | `#55CC55` | `[OK   ]` |
| Check FAIL | Console | `#FF5555` | `[FAIL ]` |
| Perf | Console | `#FF8800` | `[PERF ]` |
| Diff CHANGED | Console | `#FFCC00` | `[DIFF▲]` |
| Diff SAME | Console | `#444444` | `[DIFF=]` |
| Mem dump (hex) | Console | `#D4D4D4` | смещение |
| Пауза Monitor | Monitor | `#555555` курсив | `[PAUSED — N буферизовано]` |

---

## Порядок реализации

### Шаг 1: C++ wren_inspector.dll
1. Создать `cpp/wren_inspector/` (.h, .cpp, .pro)
2. Реализовать все `winsp_*` функции
3. Собрать: `cd cpp/wren_inspector && qmake && mingw32-make -j4`
4. Проверить: `dll/wren_inspector.dll` создан

### Шаг 2: Wren-модули в wren_bridge.cpp
1. Добавить `winspEnsureLoaded()` и структуру `g_winsp`
2. Реализовать функции `wfn_insp_*`, `wfn_mem_*`, `wfn_log_*`, `wfn_check_*`,
   `wfn_perf_*`, `wfn_typereg_*`, `wfn_session_*`
3. Зарегистрировать модули в `wrenLoadModule` и `wrenBindForeignMethod`
4. Пересобрать `wren_bridge.dll`

### Шаг 3: D — WrenConsole
1. Создать `d/wren_console.d`
2. Реализовать layout, REPL, сценарии, историю
3. Реализовать Watch-таймер
4. Добавить `WrenConsole.instance()` singleton

### Шаг 4: Wren-библиотеки
1. `wren/lib/inspector.wren` — printTree, findAll, orphans, dumpProps
2. `wren/lib/mem.wren` — formatHex helper

### Шаг 5: Примеры и тест
1. Создать `wren/scenarios/example_*.wren` (3-4 примера)
2. Написать тестовое D-приложение `test/test_wren_inspector.d`:
   - Создаёт несколько виджетов с objectName
   - Открывает WrenConsole
   - Прогоняет example_widget_tree.wren → проверяет что Check.passed > 0

---

## Верификация

### Минимальный набор проверок

```
// ── Два потока вывода ────────────────────────────────────────────────────────
✓ Log.warn("test") из D-кода       → текст появляется в Monitor, НЕ в Console
✓ Out.warn("test") из Wren-сценария→ текст появляется в Console, НЕ в Monitor
✓ Mem.at(addr).dump(16)            → вывод в Console (не в Monitor)
✓ Check.report()                   → вывод в Console
✓ Watch-уведомление                → вывод в Monitor
✓ monitorPause() / monitorResume() → буферизация и сброс работают корректно
✓ Обе панели независимы: Log.* не мешает Out.* и наоборот

// ── Qt Introspection ─────────────────────────────────────────────────────────
✓ Inspector.find("existingWidget") → QtObj с isNull = false
✓ Inspector.find("noSuch")         → QtObj с isNull = true
✓ QtObj.className                  → корректный класс ("QPushButton" и т.п.)
✓ QtObj.children.count             → совпадает с реальным числом дочерних
✓ QtObj.property("text")           → возвращает текст кнопки/метки
✓ QtObj.setProperty("enabled",false) → виджет отключается

// ── Память ───────────────────────────────────────────────────────────────────
✓ Mem.isValid(validAddr, 4)        → true
✓ Mem.isValid(0x00000001, 4)       → false
✓ Mem.read32(validAddr)            → значение без краша
✓ Mem.at(addr).dump(16)            → в Console без краша
✓ Mem.searchPtr(addr)              → находит адрес в памяти процесса

// ── Модули ───────────────────────────────────────────────────────────────────
✓ Check.that(true/false, msg)      → passed++/failed++, в Console
✓ Perf.start + Perf.stop           → ms >= 0
✓ TypeReg.define + TypeReg.read    → правильные значения полей
✓ Session.autoSave                 → файл создаётся в sessions/
✓ Log.ifChanged                    → нет дублей при одинаковом значении
✓ Inspector.snapshot + diff        → [DIFF▲] для изменённых свойств
```

---

## Важные замечания для реализации

1. **Поток**: WrenConsole и WrenVM работают в **главном потоке Qt**.
   Wren-код выполняется синхронно при нажатии Run — не создавать отдельный поток.

2. **Два виджета — два глобала**: `g_monitorWidget` и `g_consoleWidget` — оба
   `void*` на QPlainTextEdit. Устанавливаются через `winsp_setMonitorWidget(ptr)` и
   `winsp_setConsoleWidget(ptr)` в `WrenConsole::injectWidgets()` ДО первого
   wrenInterpret и ДО любого `Log.*` из D-кода.
   `Log.*` использует `g_monitorWidget`, `Out.*` использует `g_consoleWidget`.

3. **Роутинг вывода в Wren-модулях**:
   - Все `wfn_log_*` → `appendHtmlTo(g_monitorWidget, ...)`
   - Все `wfn_out_*` → `appendHtmlTo(g_consoleWidget, ...)`
   - `wfn_mem_dump`, `wfn_check_report`, `wfn_perf_report` → `g_consoleWidget`
   - Watch callbacks → `g_monitorWidget` (вызываются из таймера)

4. **Pause/Resume Monitor**: `winsp_monitorPause()` устанавливает флаг
   `g_monitorPaused = true`. Пока флаг активен — сообщения накапливаются в
   `g_monitorBuffer` (QStringList). `winsp_monitorResume()` сбрасывает буфер
   в `g_monitorWidget` разом и очищает буфер.

5. **appendHtml vs appendPlainText**: для цветного вывода использовать
   `QPlainTextEdit::appendHtml`. Экранировать `<`, `>`, `&` в пользовательских
   данных перед вставкой в HTML. Вспомогательная функция:
   ```cpp
   static QString esc(const QString& s) {
       return s.toHtmlEscaped();  // Qt встроенный escape
   }
   static void appendTo(void* widget, const QString& html) {
       if (!widget) return;
       // через pFunQt[] или напрямую:
       ((QPlainTextEdit*)widget)->appendHtml(html);
   }
   ```

6. **winsp_memRead на Windows**: использовать `__try / __except` (SEH),
   НЕ `try/catch` C++. SEH перехватывает ACCESS_VIOLATION.

7. **32-bit адреса**: процесс 32-bit (`dmd -m32`), адреса помещаются в int.
   В Wren использовать обычные числа (Wren number = double, точность 53 бита —
   достаточно для 32-bit адресов).

8. **TypeReg.read для wstr**: читать `size` байт через `winsp_memRead`,
   интерпретировать как `wchar_t[]` → конвертировать в UTF-8 для Wren.

9. **Watch таймер**: QTimer с 100ms interval в WrenConsole.
   При срабатывании — итерировать список watches, сравнивать с предыдущими
   значениями, при изменении вызывать Wren-callback через `wrenCall`,
   результат выводить в Monitor.

10. **Session autoSave**: записывает только REPL-ввод (строки из `_inputEdit`),
    НЕ вывод Console. Файл — готовый Wren-сценарий для повторного запуска.
    Заголовок:
    ```
    // Session: 2026-03-12 14:22:05
    // App: myapp.exe
    ```

11. **QSplitter**: использовать `gen_qsplitter.d` (уже есть в проекте).
    Начальные размеры: `splitter.setSizes([400, 600])` — 40/60.

12. **WrenConsole.log (D-прокси)**: статический объект в D для удобного вызова
    из D-кода без импорта Wren:
    ```d
    WrenConsole.log.warn("значение вне диапазона: " ~ v.to!string);
    // вызывает winsp_appendMonitor(L"[WARN ] ...", color) напрямую
    ```
    Это позволяет логировать из любого D-модуля без инициализации Wren VM.
