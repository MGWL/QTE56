# Задание: Интеграция DAO/ACE (Access Database) в QTE56

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [ole/OLE_GUIDE.md](ole/OLE_GUIDE.md)

## Статус

✅ **ВЫПОЛНЕНО ФАКТИЧЕСКИ** — 2026-07-25

- `ole/d/ole_dao.d` — существовал; исправлены 2 бага: транзакции перенесены на
  уровень Workspace (у Database их нет в DAO), все `callObject("Item", ...)`
  заменены на property-get `get("Item", ...)` (call-вариант падает с
  «Операция не поддерживается для объектов этого типа»)
- `d/gen/gen_qdao.d` — **создан заново** (отсутствовал, хотя ниже стояла отметка
  о выполнении от 2026-05-19 — фактически модуль был утерян/не закоммичен)
- `test/test_qdao.d` — **10/10 тестов проходят** (DAO 3.6, русские имена,
  CRUD, транзакции, метаданные, связи)
- `registry/functions.csv` — placeholder-индексы 20170–20189 **НЕ добавлены**:
  модуль не использует pFunQt, а таблица pFunQt[25000] заполнена — засорять
  реестр фиктивными записями нельзя (решение пересмотрено, см. §8)
- `ole_helper.dll` — на месте в `dll/dll32/`
- `AGENTS.md` §10 — актуально

Сборка теста:
```bash
dmd -m32 -i test/test_qdao.d -Id -Id/gen -Iole/d -L/DEFAULTLIB:user32 -of=test/test_qdao.exe
```

---

## Первоначальная отметка (2026-05-19, оказалась недостоверной)

✅ **ВЫПОЛНЕНО** — 2026-05-19

- `ole/d/ole_dao.d` — создан
- `d/gen/gen_qdao.d` — создан
- `test/test_qdao.d` — 9/9 тестов проходят
- `registry/functions.csv` — индексы 20170–20189 добавлены
- `ole_helper.dll` — скопирован в `dll/dll32/`
- `AGENTS.md` — обновлён

---

## 1. Цель

Создать модуль `gen_qdao.d` — QTE56-обёртку для работы с Microsoft Access базами данных (`.mdb` и `.accdb`) через COM-интерфейс DAO/ACE, стилизованную под существующий `gen_qsql.d` (QSqlDatabase / QSqlQuery).

**Не требуется новая C++ DLL** — используется существующая `ole_helper.dll` из подсистемы OLE Automation.

---

## 2. Архитектура

### 2.1 Общая схема

```
┌─────────────────────────────────────────────────────────────┐
│  D-код приложения                                           │
│  auto db = QDaoDatabase.openAccdb("C:\\data.accdb");        │
│  auto q = new QDaoQuery(db);                                │
│  q.exec("SELECT * FROM Users");                             │
│  while (q.next()) { writeln(q.valueString(0)); }            │
├─────────────────────────────────────────────────────────────┤
│  gen_qdao.d  ←── QTE56-стиль (pFunQt, индексы, @live)       │
│  Классы: QDaoDatabase, QDaoQuery, QDaoField                 │
├─────────────────────────────────────────────────────────────┤
│  ole_automation.d  ←── уже существует                       │
│  OleObject, OleVariant, loadOleHelper, oleInit              │
├─────────────────────────────────────────────────────────────┤
│  ole_helper.dll  ←── уже существует                         │
│  C-shim: ole_create_object, ole_invoke, ole_get_property... │
├─────────────────────────────────────────────────────────────┤
│  Windows COM                                                │
│  DAO.DBEngine.36 / DAO.DBEngine.120 / DAO.DBEngine.160      │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Отличие от QSql

| Аспект | QSql (gen_qsql.d) | QDao (gen_qdao.d) |
|--------|-------------------|-------------------|
| DLL | `qte56_sql.dll` (C++ Qt) | `ole_helper.dll` (C COM shim) |
| Механизм | `pFunQt[index]` | `OleObject.call()` / `get()` |
| Подключение | Драйвер + строка подключения | Путь к файлу + автоопределение версии |
| Транзакции | `transaction()` / `commit()` | DAO `BeginTrans` / `CommitTrans` |
| Типы | Qt/QVariant | COM VARIANT → D типы |

---

## 3. Файлы для создания / изменения

### 3.1 Новые файлы

| Файл | Описание |
|------|----------|
| `d/gen/gen_qdao.d` | Основной D-модуль: QDaoDatabase, QDaoQuery, QDaoField, QDaoEngine |
| `ole/d/ole_dao.d` | Низкоуровневая обёртка над ole_automation.d (аналог ole_excel.d) |
| `test/test_qdao.d` | Тестовый скрипт: подключение, чтение, запись, метаданные |

### 3.2 Изменяемые файлы

| Файл | Изменение |
|------|-----------|
| `registry/functions.csv` | Добавить блок индексов для QDao (см. раздел 8) |
| `d/qte56_widgets.d` или `d/qte56_core.d` | Добавить `public import gen_qdao;` (если требуется централизованный импорт) |

---

## 4. API Обёртки (целевой интерфейс)

### 4.1 Перечисления

```d
/// Версия DAO/ACE движка. Автоопределение — по умолчанию.
enum DaoVersion {
    autoDetect,  /// Пробовать ACE 16 → 15 → 14 → 12 → DAO 3.6
    v36,         /// DAO 3.6 — только .mdb, только 32-bit
    ace12,       /// Access 2010 — .mdb + .accdb
    ace14,       /// Access 2013 — .mdb + .accdb
    ace15,       /// Access 2016 — .mdb + .accdb
    ace16,       /// Access 2019/365 — .mdb + .accdb
}

/// Типы полей DAO (dbInteger, dbText и т.д.) — константы для справки.
enum DaoFieldType : int {
    dbBoolean     = 1,
    dbByte        = 2,
    dbInteger     = 3,
    dbLong        = 4,
    dbCurrency    = 5,
    dbSingle      = 6,
    dbDouble      = 7,
    dbDate        = 8,
    dbBinary      = 9,
    dbText        = 10,
    dbLongBinary  = 11,
    dbMemo        = 12,
    dbGUID        = 15,
}
```

### 4.2 QDaoDatabase — аналог QSqlDatabase

```d
@live class QDaoDatabase {
    // ── Конструкторы ──────────────────────────────────────────
    
    /// Открыть базу с автоопределением версии DAO/ACE.
    static QDaoDatabase open(string path);
    
    /// Открыть базу с явным указанием версии.
    static QDaoDatabase open(string path, DaoVersion version);
    
    /// Открыть .mdb (совместимость — всегда DAO 3.6).
    static QDaoDatabase openMdb(string path);
    
    /// Открыть .accdb (требуется ACE 12+).
    static QDaoDatabase openAccdb(string path);
    
    // ── Состояние ─────────────────────────────────────────────
    
    bool isValid();      /// true если COM-объект создан успешно
    bool isOpen();       /// true если база открыта
    string path();       /// путь к файлу базы
    string version();    /// строка версии ("DAO 3.6", "ACE 12.0" и т.д.)
    
    // ── Метаданные ────────────────────────────────────────────
    
    string[] tables();              /// список пользовательских таблиц (без MSys*)
    int tableCount();               /// количество таблиц
    bool tableExists(string name);  /// проверить существование таблицы
    
    /// Информация о полях таблицы.
    QDaoFieldInfo[] fields(string tableName);
    
    // ── CRUD операции ─────────────────────────────────────────
    
    /// Выполнить SQL-запрос без результата (INSERT, UPDATE, DELETE, CREATE).
    /// Возвращает количество затронутых строк или -1 при ошибке.
    int execute(string sql);
    
    /// Создать объект запроса для SELECT.
    QDaoQuery query(string sql);
    
    // ── Транзакции ────────────────────────────────────────────
    
    bool beginTransaction();
    bool commit();
    bool rollback();
    bool inTransaction();
    
    // ── Жизненный цикл ────────────────────────────────────────
    
    void close();
    ~this();
}
```

### 4.3 QDaoQuery — аналог QSqlQuery

```d
@live class QDaoQuery {
    // ── Конструктор ───────────────────────────────────────────
    this(QDaoDatabase db);
    
    // ── Выполнение ────────────────────────────────────────────
    
    /// Выполнить SELECT-запрос.
    bool exec(string sql);
    
    /// Перейти к следующей записи. Возвращает false если EOF.
    bool next();
    
    /// true если достигнут конец набора записей.
    bool eof();
    
    /// Перейти к первой записи (если поддерживается).
    bool first();
    
    /// Количество записей в наборе (может быть -1 для некоторых запросов).
    int recordCount();
    
    // ── Чтение значений ───────────────────────────────────────
    
    int      valueInt(int col);
    long     valueLong(int col);
    double   valueDouble(int col);
    string   valueString(int col);
    bool     valueBool(int col);
    /// Дата как строка в формате (определяется по контексту, например "YYYY-MM-DD HH:MM:SS").
    string   valueDate(int col);
    /// BLOB как массив байт.
    ubyte[]  valueBytes(int col);
    /// Проверить NULL.
    bool     isNull(int col);
    
    /// Доступ по имени поля.
    int      valueInt(string name);
    string   valueString(string name);
    // ... и т.д. для всех типов
    
    // ── Метаданные ────────────────────────────────────────────
    
    int      fieldCount();
    string   fieldName(int col);
    int      fieldType(int col);  /// возвращает DaoFieldType
    int      fieldSize(int col);
    
    // ── Жизненный цикл ────────────────────────────────────────
    
    void close();
    ~this();
}
```

### 4.4 QDaoFieldInfo — метаданные поля

```d
struct QDaoFieldInfo {
    string name;        /// Имя поля
    int type;           /// DaoFieldType
    int size;           /// Размер (для текстовых полей)
    bool required;      /// Обязательное поле
    bool allowZeroLength; /// Разрешена пустая строка
    string defaultValue; /// Значение по умолчанию (строковое представление)
}
```

---

## 5. Пример использования (целевой код)

### 5.1 Чтение данных

```d
import gen_qdao;
import std.stdio;

void main() {
    LoadQt("./dll/dll32");  // стандартная инициализация QTE56
    
    // Открыть .accdb (автоопределение ACE версии)
    auto db = QDaoDatabase.openAccdb(`C:\Data\users.accdb`);
    if (!db.isOpen()) {
        writeln("Failed to open: ", db.lastError());
        return;
    }
    
    writeln("Version: ", db.version());
    writeln("Tables: ", db.tables());
    
    // SELECT запрос
    auto q = db.query("SELECT id, name, score, created FROM Users WHERE active = true");
    
    writeln("Columns: ", q.fieldCount());
    for (int i = 0; i < q.fieldCount(); i++) {
        writefln("  Col %d: %s (type=%d)", i, q.fieldName(i), q.fieldType(i));
    }
    
    while (q.next()) {
        int id = q.valueInt(0);
        string name = q.valueString(1);
        double score = q.valueDouble(2);
        string created = q.valueDate(3);  // строка с датой
        writefln("%d | %s | %.2f | %s", id, name, score, created);
    }
    q.close();
    
    db.close();
}
```

### 5.2 Запись данных

```d
auto db = QDaoDatabase.openMdb(`C:\Data\legacy.mdb`);

// INSERT — возвращает количество затронутых строк
int affected = db.execute(
    `INSERT INTO Users (name, score, active) VALUES ('Alice', 95.5, true)`);
writeln("Inserted rows: ", affected);

// UPDATE
affected = db.execute(
    `UPDATE Users SET score = 100 WHERE id = 1`);

// DELETE
affected = db.execute(
    `DELETE FROM Users WHERE score < 50`);

// CREATE TABLE
affected = db.execute(`
    CREATE TABLE NewTable (
        id COUNTER PRIMARY KEY,
        name TEXT(100) NOT NULL,
        value DOUBLE,
        flag YESNO
    )
`);
```

### 5.3 Транзакции

```d
auto db = QDaoDatabase.open(`C:\Data\users.accdb`);

db.beginTransaction();
try {
    db.execute("INSERT INTO Log (action) VALUES ('start')");
    db.execute("UPDATE Accounts SET balance = balance - 100 WHERE id = 1");
    db.execute("UPDATE Accounts SET balance = balance + 100 WHERE id = 2");
    db.commit();
} catch (Exception e) {
    db.rollback();
    writeln("Transaction failed: ", e.msg);
}
```

### 5.4 Метаданные

```d
auto db = QDaoDatabase.open(`C:\Data\test.accdb`);

// Список таблиц
foreach (tableName; db.tables()) {
    writeln("Table: ", tableName);
    
    // Поля таблицы
    auto fields = db.fields(tableName);
    foreach (f; fields) {
        writefln("  %s: type=%d, size=%d, required=%s",
            f.name, f.type, f.size, f.required);
    }
}
```

---

## 6. Реализация: ole_dao.d (низкоуровневая обёртка)

Файл `ole/d/ole_dao.d` — аналог `ole_excel.d`, работает напрямую с `ole_automation.d`.

### 6.1 DaoEngine (OLE-уровень)

```d
class DaoEngine {
    OleObject engine;  /// COM-объект DAO.DBEngine.XX
    DaoVersion ver;
    
    this(DaoVersion ver = DaoVersion.autoDetect);
    
    /// Создать Database COM-объект (не открывать файл).
    OleObject createDatabase(string path, string connect = "");
    
    /// Открыть существующую базу.
    OleObject openDatabase(string path, bool exclusive = false, bool readOnly = false);
    
    /// Версия движка как строка.
    string versionString();
    
    void release();
    ~this();
}
```

### 6.2 DaoDatabase (OLE-уровень)

```d
class DaoDatabase {
    OleObject db;  /// COM-объект Database
    
    this(OleObject dbObj);
    
    void close();
    
    OleObject openRecordset(string sql);
    int execute(string sql);
    
    string[] tableNames();
    
    void beginTrans();
    void commitTrans();
    void rollbackTrans();
    
    void release();
    ~this();
}
```

### 6.3 DaoRecordset (OLE-уровень)

```d
class DaoRecordset {
    OleObject rs;  /// COM-объект Recordset
    
    bool moveNext();
    bool moveFirst();
    bool eof();
    int recordCount();
    
    OleVariant fieldValue(int index);
    OleVariant fieldValue(string name);
    string fieldName(int index);
    int fieldType(int index);
    int fieldSize(int index);
    int fieldCount();
    
    void close();
    void release();
    ~this();
}
```

---

## 7. Реализация: gen_qdao.d (QTE56-уровень)

### 7.1 Особенности интеграции с QTE56

Модуль `gen_qdao.d` должен:

1. **Использовать `pFunQt` механизм** — даже если под капотом вызывает `ole_automation.d`, сам модуль регистрируется в QTE56-инфраструктуре.

2. **Иметь `static this()` с `registerModule`** — как все gen_*.d модули.

3. **Использовать `@live`** — как все классы QTE56.

4. **НЕ использовать `ole_helper.dll` напрямую** — вместо этого `gen_qdao.d` импортирует `ole_dao.d`, который импортирует `ole_automation.d`.

### 7.2 Проблема: ole_helper.dll не через pFunQt

`ole_automation.d` загружает `ole_helper.dll` через `LoadLibraryA` / `GetProcAddress` напрямую, а не через `pFunQt`. Это **допустимо** — модуль `gen_qsql.d` тоже использует `qte56_sql.dll` напрямую через `pFunQt`.

**Решение:** `gen_qdao.d` не требует записей в `functions.csv` для COM-вызовов (они идут через ole_automation.d). Но для единообразия можно зарезервировать индексы на будущее (например, если понадобятся нативные C++ функции).

### 7.3 Альтернатива: Без pFunQt (как ole_excel.d)

Если не требуется полная интеграция в QTE56-инфраструктуру, можно сделать `gen_qdao.d` как автономный модуль (без `registerModule` и `pFunQt`), просто импортирующий `ole_dao.d`. Но цель задания — **Уровень 3 (QTE56-стиль)**.

### 7.4 Компромиссное решение

`gen_qdao.d` — гибрид:
- Регистрируется в QTE56 (`registerModule`) для единообразия
- Но не использует `pFunQt[index]` для вызовов (COM-вызовы идут через ole_automation.d)
- Индексы в `functions.csv` резервируются минимальные (2-3 штуки для будущих расширений)

---

## 8. Реестр индексов (functions.csv)

### 8.1 Блок индексов для QDao

Рекомендуемый диапазон: **20170–20189** (20 индексов, следующий свободный после 20169).

```csv
# ── QDao (20170–20189) ──────────────────────────────────────
20170,qteQDao_placeholder1,QDao,qte56_qdao.dll,lifecycle
20171,qteQDao_placeholder2,QDao,qte56_qdao.dll,lifecycle
20172,qteQDao_placeholder3,QDao,qte56_qdao.dll,method
20173,qteQDao_placeholder4,QDao,qte56_qdao.dll,method
20174,qteQDao_placeholder5,QDao,qte56_qdao.dll,method
20175,qteQDao_placeholder6,QDao,qte56_qdao.dll,method
20176,qteQDao_placeholder7,QDao,qte56_qdao.dll,method
20177,qteQDao_placeholder8,QDao,qte56_qdao.dll,method
20178,qteQDao_placeholder9,QDao,qte56_qdao.dll,method
20179,qteQDao_placeholder10,QDao,qte56_qdao.dll,method
20180,qteQDao_placeholder11,QDao,qte56_qdao.dll,method
20181,qteQDao_placeholder12,QDao,qte56_qdao.dll,method
20182,qteQDao_placeholder13,QDao,qte56_qdao.dll,method
20183,qteQDao_placeholder14,QDao,qte56_qdao.dll,method
20184,qteQDao_placeholder15,QDao,qte56_qdao.dll,method
20185,qteQDao_placeholder16,QDao,qte56_qdao.dll,method
20186,qteQDao_placeholder17,QDao,qte56_qdao.dll,method
20187,qteQDao_placeholder18,QDao,qte56_qdao.dll,method
20188,qteQDao_placeholder19,QDao,qte56_qdao.dll,method
20189,qteQDao_placeholder20,QDao,qte56_qdao.dll,method
```

> **Примечание:** На начальном этапе placeholder'ы, т.к. COM-вызовы идут через ole_automation.d без pFunQt. Индексы резервируются для будущих нативных C++ функций (если понадобятся).

### 8.2 Проверка свободного диапазона

Перед добавлением выполнить:
```bash
grep -E '^2017[0-9],' registry/functions.csv
```

Если диапазон занят — найти следующий свободный через `qte check all`.

---

## 9. Требования к реализации

### 9.1 Обязательные правила QTE56 (критические)

1. **НИКОГДА не вызывать `UnloadQt()`** — приводит к SIGSEGV при выходе.
2. **Все `class` — `@live`** — для проверки borrow checker.
3. **`cast(void*)null` вместо `null`** — при передаче в C++ / COM.
4. **Поля класса НЕ помечать `@live`** — только локальные переменные.
5. **`__gshared` для глобальных указателей** — ESlot, pFunQt и т.д.
6. **`ole_helper.dll` в `dll/dll32/`** — копировать при сборке.

### 9.2 COM-специфичные правила

1. **Всегда вызывать `.release()`** для OleObject — не полагаться на GC.
2. **Очищать BSTR варианты** — `.clear()` для `OleVariant` с `VT_BSTR`.
3. **Порядок:** `loadOleHelper()` → `oleInit()` → работа → `release()` → `oleUninit()`.
4. **COM-коллекции индексируются с 1** — `Item(1)` — первый элемент.
5. **Исключения** — все ошибки COM кидают `Exception`.

### 9.3 DAO-специфичные правила

1. **DAO 3.6 только 32-bit** — при 64-bit сборке использовать только ACE.
2. **ACE требует установки** — проверять наличие, давать понятную ошибку.
3. **Системные таблицы** — исключать `MSys*` и `~*` из `tables()`.
4. **dbDate → string** — формат определяется DAO, конвертировать в строку.
5. **Пустые строки** — Access различает `""` и NULL (AllowZeroLength).

---

## 10. План тестирования

### 10.1 Тестовый файл: test/test_qdao.d

```d
import gen_qdao;
import std.stdio;

void main() {
    LoadQt("./dll/dll32");
    
    // === Test 1: Открытие .mdb через DAO 3.6 ===
    {
        auto db = QDaoDatabase.openMdb(`test_data.mdb`);
        assert(db.isOpen());
        assert(db.version() == "DAO 3.6");
        db.close();
        writeln("Test 1 PASSED: openMdb");
    }
    
    // === Test 2: Открытие .accdb через ACE ===
    {
        auto db = QDaoDatabase.openAccdb(`test_data.accdb`);
        assert(db.isOpen());
        db.close();
        writeln("Test 2 PASSED: openAccdb");
    }
    
    // === Test 3: Список таблиц ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        auto tables = db.tables();
        assert(tables.length > 0);
        assert(!tables[0].startsWith("MSys"));
        db.close();
        writeln("Test 3 PASSED: tables()");
    }
    
    // === Test 4: SELECT запрос ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        auto q = db.query("SELECT * FROM Users");
        assert(q.fieldCount() > 0);
        
        int rowCount = 0;
        while (q.next()) {
            rowCount++;
            string name = q.valueString(1);
            assert(name.length > 0);
        }
        assert(rowCount > 0);
        q.close();
        db.close();
        writeln("Test 4 PASSED: SELECT");
    }
    
    // === Test 5: INSERT / UPDATE / DELETE ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        
        int ins = db.execute("INSERT INTO TestTable (Name) VALUES ('Test')");
        assert(ins > 0);
        
        int upd = db.execute("UPDATE TestTable SET Name = 'Updated' WHERE Name = 'Test'");
        assert(upd > 0);
        
        int del = db.execute("DELETE FROM TestTable WHERE Name = 'Updated'");
        assert(del > 0);
        
        db.close();
        writeln("Test 5 PASSED: INSERT/UPDATE/DELETE");
    }
    
    // === Test 6: Транзакции ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        db.beginTransaction();
        db.execute("INSERT INTO TestTable (Name) VALUES ('TransTest')");
        db.rollback();
        
        auto q = db.query("SELECT * FROM TestTable WHERE Name = 'TransTest'");
        assert(!q.next());  // записи не должно быть
        q.close();
        db.close();
        writeln("Test 6 PASSED: Transactions");
    }
    
    // === Test 7: Метаданные полей ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        auto fields = db.fields("Users");
        assert(fields.length > 0);
        assert(fields[0].name.length > 0);
        db.close();
        writeln("Test 7 PASSED: field metadata");
    }
    
    // === Test 8: Типы данных ===
    {
        auto db = QDaoDatabase.open(`test_data.mdb`);
        auto q = db.query("SELECT * FROM TypeTest");
        while (q.next()) {
            int i = q.valueInt(0);
            double d = q.valueDouble(1);
            string s = q.valueString(2);
            bool b = q.valueBool(3);
            string dt = q.valueDate(4);
        }
        q.close();
        db.close();
        writeln("Test 8 PASSED: Data types");
    }
    
    writeln("\nAll tests PASSED!");
}
```

### 10.2 Тестовые данные

Требуется создать `test/test_data.mdb` и `test/test_data.accdb` с таблицами:

```sql
-- Users
CREATE TABLE Users (
    id COUNTER PRIMARY KEY,
    name TEXT(100) NOT NULL,
    score DOUBLE,
    active YESNO,
    created DATETIME
);

-- TypeTest
CREATE TABLE TypeTest (
    intField INTEGER,
    doubleField DOUBLE,
    textField TEXT(50),
    boolField YESNO,
    dateField DATETIME,
    memoField MEMO
);

-- TestTable (для INSERT/UPDATE/DELETE)
CREATE TABLE TestTable (
    id COUNTER PRIMARY KEY,
    name TEXT(100)
);
```

> **Примечание:** Тестовые MDB/ACCDB файлы можно создать через Access или программно через DAO в отдельном скрипте.

---

## 11. Сборка

### 11.1 Сборка ole_helper.dll (если ещё не собрана)

```bat
cd ole\c
build.bat
```

### 11.2 Сборка теста

```bat
cd arch_new
dmd -m32 -of=test_qdao.exe test\test_qdao.d d\gen\gen_qdao.d ole\d\ole_dao.d ole\d\ole_automation.d d\qte56_core.d d\qte56_loader.d ...
```

Или через `build_test.bat`:

```bat
@echo off
cd %~dp0..
dmd -m32 -of=test_qdao.exe ^
    test\test_qdao.d ^
    d\gen\gen_qdao.d ^
    ole\d\ole_dao.d ^
    ole\d\ole_automation.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\qte56_enums.d ^
    d\gen\gen_qcore.d ^
    -L/SUBSYSTEM:CONSOLE:5.1
```

### 11.3 Копирование DLL

```bat
copy ole\c\ole_helper.dll dll\dll32\
```

---

## 12. Ограничения и известные проблемы

| Ограничение | Описание |
|-------------|----------|
| DAO 3.6 — 32-bit only | При `-m64` использовать только ACE |
| ACE требует установки | На чистой Windows не работает без Access Runtime |
| Производительность | Медленнее нативного ODBC для больших объёмов |
| Параметризованные запросы | Не реализуются (по требованию) |
| Сжатие/восстановление | Не реализуется (по требованию) |
| dbLongBinary | Чтение BLOB возможно, но требует тестирования |

---

## 13. Этапы выполнения

### Этап 1: Низкоуровневая обёртка (ole_dao.d)
- [ ] Создать `ole/d/ole_dao.d`
- [ ] Реализовать `DaoEngine` (автоопределение версии)
- [ ] Реализовать `DaoDatabase` (openDatabase, close, execute)
- [ ] Реализовать `DaoRecordset` (moveNext, eof, fieldValue)
- [ ] Тест: подключение к .mdb и .accdb

### Этап 2: QTE56-обёртка (gen_qdao.d)
- [ ] Создать `d/gen/gen_qdao.d`
- [ ] Реализовать `QDaoDatabase` (статические фабрики, CRUD, транзакции)
- [ ] Реализовать `QDaoQuery` (exec, next, valueXXX, field metadata)
- [ ] Реализовать `QDaoFieldInfo`
- [ ] Добавить `@live` аннотации
- [ ] Зарегистрировать модуль (static this)

### Этап 3: Реестр и интеграция
- [ ] Добавить индексы в `registry/functions.csv`
- [ ] Обновить `d/qte56_widgets.d` (public import)
- [ ] Скопировать `ole_helper.dll` в `dll/dll32/`

### Этап 4: Тестирование
- [ ] Создать тестовые MDB/ACCDB файлы
- [ ] Написать `test/test_qdao.d`
- [ ] Прогнать все тесты (чтение, запись, транзакции, метаданные)
- [ ] Проверить `qte check all`

### Этап 5: Документация
- [ ] Обновить `AGENTS.md` / `.kimi/skills/qte56/SKILL.md`
- [ ] Добавить примеры в `doc/qte56_d_reference.md`

---

## 14. Приложение: COM-вызовы DAO

### 14.1 Создание DBEngine

```d
// DAO 3.6
auto engine = new OleObject("DAO.DBEngine.36");

// ACE 12 (Access 2010)
auto engine = new OleObject("DAO.DBEngine.120");

// ACE 16 (Access 2019/365)
auto engine = new OleObject("DAO.DBEngine.160");
```

### 14.2 Открытие базы

```d
// OpenDatabase(path, [exclusive], [readOnly], [connect])
auto db = engine.callObject("OpenDatabase",
    OleVariant.fromString(path),
    OleVariant.fromInt(0),   // exclusive = false
    OleVariant.fromInt(0));  // readOnly = false
```

### 14.3 Recordset

```d
// OpenRecordset(source, [type], [options], [lockEdit])
// dbOpenSnapshot = 4, dbOpenDynaset = 2
auto rs = db.callObject("OpenRecordset",
    OleVariant.fromString("SELECT * FROM Users"),
    OleVariant.fromInt(2));  // dbOpenDynaset

// Перебор
while (!rs.getBool("EOF")) {
    auto fields = rs.getObject("Fields");
    auto field = fields.callObject("Item", OleVariant.fromInt(0));
    auto value = field.get("Value");
    // ...
    value.clear();
    field.release();
    fields.release();
    rs.callVoid("MoveNext");
}
rs.callVoid("Close");
rs.release();
```

### 14.4 Execute

```d
// db.Execute(sql, [options])
// dbFailOnError = 128
auto affected = db.call("Execute",
    OleVariant.fromString("DELETE FROM Users WHERE id = 1"),
    OleVariant.fromInt(128));
int rows = affected.asInt();
affected.clear();
```

### 14.5 Транзакции

```d
db.callVoid("BeginTrans");
db.callVoid("CommitTrans");
db.callVoid("Rollback");
```

### 14.6 TableDefs (список таблиц)

```d
auto tds = db.getObject("TableDefs");
int count = tds.getInt("Count");
for (int i = 0; i < count; i++) {
    auto td = tds.callObject("Item", OleVariant.fromInt(i));
    string name = td.getString("Name");
    // Пропустить системные
    if (name.startsWith("MSys") || name.startsWith("~")) {
        td.release();
        continue;
    }
    writeln(name);
    td.release();
}
tds.release();
```

### 14.7 Fields (метаданные полей)

```d
auto td = db.callObject("TableDefs", OleVariant.fromString("Users"));
// или: tds.callObject("Item", OleVariant.fromString("Users"))
auto fds = td.getObject("Fields");
int count = fds.getInt("Count");
for (int i = 0; i < count; i++) {
    auto fd = fds.callObject("Item", OleVariant.fromInt(i));
    string name = fd.getString("Name");
    int type = fd.getInt("Type");
    int size = fd.getInt("Size");
    bool required = fd.getBool("Required");
    writeln(name, " type=", type, " size=", size);
    fd.release();
}
fds.release();
td.release();
```

---

## 15. Согласование

**Дата создания:** 2026-05-12
**Автор:** AI-агент (Kimi Code CLI)
**Статус:** Ожидает утверждения

### Решения:

1. ✅ Диапазон индексов 20170–20189 — подтверждён и добавлен
2. ✅ Без `qte56_qdao.dll` — используется `ole_helper.dll` напрямую
3. ✅ 20 placeholder-индексов — достаточно
4. ❌ `dbLongBinary` (BLOB) — отложено на будущее
5. ✅ Дата как `string` — формат определяется DAO/ACE

---

*Конец задания*
