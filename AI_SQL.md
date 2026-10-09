# QTE56 — AI_SQL (QSqlDatabase, QSqlQuery — SQLite, ODBC)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_sql.dll + Qt5Sql.dll + Qt5SQLite plugin (для SQLite)
> import: gen_qsql

---

## Подключение и создание БД

```d
// import: gen_qsql
// Поддерживаемые драйверы: QSQLITE, QODBC, QMYSQL

// SQLite — файловая БД:
auto db = QSqlDatabase.openSqlite("mydata.sqlite");
// SQLite — в памяти:
auto db = QSqlDatabase.openMemory();

// ODBC (MS Access, SQL Server через DSN):
auto db = new QSqlDatabase("QODBC",
    "DSN=MyDSN",          // source
    "",                   // host (не нужен для ODBC)
    0,                    // port
    "username",
    "password");

// Проверить подключение:
if (!db.isValid() || !db.isOpen()) {
    writeln("DB error: ", db.lastError());
}
// Если открыта успешно:
writeln("DB open: ", db.driverName()); // "QSQLITE"

// Список таблиц:
string[] tables = db.tables();
foreach (t; tables) writeln(t);

// Транзакции:
db.transaction();
// ... execute queries ...
db.commit();    // подтвердить
// db.rollback(); // откатить
```

---

## QSqlQuery — выполнение запросов

```d
auto q = new QSqlQuery(db);

// ── CREATE TABLE ───────────────────────────────────────────────────────────
bool ok = q.exec(
    "CREATE TABLE IF NOT EXISTS users (" ~
    "  id      INTEGER PRIMARY KEY AUTOINCREMENT," ~
    "  name    TEXT    NOT NULL," ~
    "  email   TEXT    UNIQUE," ~
    "  age     INTEGER DEFAULT 0," ~
    "  salary  REAL    DEFAULT 0.0" ~
    ")");
if (!ok) writeln("Error: ", q.lastError());

// ── INSERT ─────────────────────────────────────────────────────────────────
// Простой:
q.exec("INSERT INTO users (name, email, age) VALUES ('Alice', 'a@b.com', 30)");

// Параметризованный (защита от SQL-инъекций!):
q.prepare("INSERT INTO users (name, email, age, salary) VALUES (?,?,?,?)");
q.bindString(1, "Bob");
q.bindString(2, "bob@example.com");
q.bindInt   (3, 25);
q.bindDouble(4, 50000.0);
ok = q.execPrepared();

// Проверить количество затронутых строк:
int affected = q.numRowsAffected();

// ── SELECT ─────────────────────────────────────────────────────────────────
ok = q.exec("SELECT id, name, email, age, salary FROM users ORDER BY name");
if (!ok) { writeln("Error: ", q.lastError()); return; }

// Итерация по результатам:
while (q.next()) {
    int    id     = q.valueInt(0);
    string name   = q.valueString(1);
    string email  = q.valueString(2);
    int    age    = q.valueInt(3);
    double salary = q.valueDouble(4);
    bool   noEmail= q.isNull(2);       // NULL в поле?
    writefln("id=%d name=%s age=%d", id, name, age);
}

// Метаинформация о результате:
int cols   = q.numCols();
int rows   = q.numRows();              // -1 для SELECT в SQLite (не поддерживает)
string col0name = q.fieldName(0);      // "id"

// Параметризованный SELECT:
q.prepare("SELECT * FROM users WHERE age > ? AND name LIKE ?");
q.bindInt   (1, 20);
q.bindString(2, "A%");
q.execPrepared();
while (q.next()) {
    writeln(q.valueString(1));
}

// ── UPDATE ────────────────────────────────────────────────────────────────
q.prepare("UPDATE users SET salary=?, email=? WHERE id=?");
q.bindDouble(1, 75000.0);
q.bindString(2, "new@email.com");
q.bindInt   (3, 1);
q.execPrepared();
writeln("Updated: ", q.numRowsAffected(), " rows");

// ── DELETE ────────────────────────────────────────────────────────────────
q.prepare("DELETE FROM users WHERE id=?");
q.bindInt(1, 5);
q.execPrepared();

// ── NULL значения ─────────────────────────────────────────────────────────
q.prepare("INSERT INTO users (name, email) VALUES (?, NULL)");
q.bindString(1, "NoEmail");
// Или явно:
q.bindNull(2);
q.execPrepared();

// ── Очистить запрос (освободить ресурсы): ─────────────────────────────────
q.clear();
```

---

## Паттерн: CRUD с QTableWidget

```d
__gshared QSqlDatabase  g_db;
__gshared QSqlQuery*    g_q;       // переиспользуемый запрос
__gshared QTableWidget  g_tbl;

void loadTable() {
    auto q = new QSqlQuery(g_db);
    q.exec("SELECT id, name, age, salary FROM users ORDER BY name");

    g_tbl.setRowCount(0);
    int row = 0;
    while (q.next()) {
        g_tbl.insertRow(row);
        g_tbl.setItem(row, 0, new QTableWidgetItem(q.valueInt(0).to!string));
        g_tbl.setItem(row, 1, new QTableWidgetItem(q.valueString(1)));
        g_tbl.setItem(row, 2, new QTableWidgetItem(q.valueInt(2).to!string));
        g_tbl.setItem(row, 3, new QTableWidgetItem(q.valueDouble(3).to!string));
        row++;
    }
}

void insertRow(string name, int age, double salary) {
    auto q = new QSqlQuery(g_db);
    q.prepare("INSERT INTO users (name, age, salary) VALUES (?,?,?)");
    q.bindString(1, name);
    q.bindInt   (2, age);
    q.bindDouble(3, salary);
    if (!q.execPrepared())
        QMessageBox.critical(null, "Error", q.lastError());
    else
        loadTable();  // обновить виджет
}

void deleteRow(int id) {
    auto q = new QSqlQuery(g_db);
    q.prepare("DELETE FROM users WHERE id=?");
    q.bindInt(1, id);
    q.execPrepared();
    loadTable();
}
```

---

## Паттерн: транзакция для bulk insert

```d
void bulkInsert(string[][] rows) {
    g_db.transaction();
    auto q = new QSqlQuery(g_db);
    q.prepare("INSERT INTO data (col1, col2, col3) VALUES (?,?,?)");

    foreach (row; rows) {
        q.bindString(1, row[0]);
        q.bindString(2, row[1]);
        q.bindString(3, row[2]);
        if (!q.execPrepared()) {
            writeln("Insert error: ", q.lastError());
            g_db.rollback();
            return;
        }
    }

    if (!g_db.commit()) {
        writeln("Commit error: ", g_db.lastError());
        g_db.rollback();
    }
}
```

---

## Паттерн: проверить / создать схему БД при старте

```d
void initDatabase(string path) {
    g_db = QSqlDatabase.openSqlite(path);
    if (!g_db.isOpen()) {
        writeln("Cannot open DB: ", g_db.lastError());
        return;
    }

    auto q = new QSqlQuery(g_db);
    // Включить WAL для лучшей производительности SQLite:
    q.exec("PRAGMA journal_mode=WAL");
    // Включить foreign keys:
    q.exec("PRAGMA foreign_keys=ON");

    // Создать таблицы если нет:
    q.exec("CREATE TABLE IF NOT EXISTS settings (" ~
           "  key   TEXT PRIMARY KEY," ~
           "  value TEXT" ~
           ")");

    q.exec("CREATE TABLE IF NOT EXISTS items (" ~
           "  id       INTEGER PRIMARY KEY AUTOINCREMENT," ~
           "  title    TEXT    NOT NULL," ~
           "  created  TEXT    DEFAULT (datetime('now'))," ~
           "  done     INTEGER DEFAULT 0" ~
           ")");

    // Создать индекс:
    q.exec("CREATE INDEX IF NOT EXISTS idx_items_done ON items(done)");
}
```

---

## QSqlQuery — полный справочник методов

```d
// Выполнение:
bool exec(string sql)                  // прямой SQL
bool prepare(string sql)               // подготовить с ?-плейсхолдерами
bool execPrepared()                    // выполнить подготовленный
void clear()                           // освободить ресурсы

// Параметры (индексы с 1):
void bindInt   (int idx, int val)
void bindLong  (int idx, long val)
void bindDouble(int idx, double val)
void bindString(int idx, string val)
void bindNull  (int idx)

// Навигация:
bool next()                            // перейти к следующей строке

// Чтение данных (индексы с 0):
int    valueInt   (int col)
long   valueLong  (int col)
double valueDouble(int col)
string valueString(int col)
bool   isNull     (int col)            // поле содержит NULL?

// Метаинформация:
int    numRows        ()               // строк (-1 если не поддерживается)
int    numCols        ()               // столбцов в результате
int    numRowsAffected()               // затронутых строк (INSERT/UPDATE/DELETE)
string fieldName      (int col)        // имя столбца по индексу
string lastError      ()               // текст последней ошибки
```

---

## Gotchas

```
1. import gen_qsql — один модуль для QSqlDatabase и QSqlQuery.
2. bindXxx() — индексы начинаются с 1 (НЕ с 0)!
3. valueXxx() — индексы начинаются с 0 (НЕ с 1)!
4. q.next() должен быть вызван ПЕРЕД первым чтением valueXxx.
5. SQLite: numRows() всегда -1 для SELECT (драйвер не поддерживает).
6. Параметризованные запросы обязательны для пользовательского ввода — SQL-инъекции!
7. Транзакции обязательны для bulk insert — иначе в 1000 раз медленнее.
8. q.clear() перед повторным prepare() для того же объекта.
9. QSqlDatabase.openSqlite создаёт файл если нет. Папка должна существовать.
10. DLL: qte56_sql.dll + Qt5Sql.dll + plugins/sqldrivers/qsqlite.dll (в PATH).
    Все три должны быть доступны при запуске.
11. ODBC требует установленного драйвера в системе (ODBC Data Source Administrator).
12. fieldName(col) работает только после exec() с SELECT.
13. Закрывайте соединение ЯВНО: db.close() ДО app.deleteApp() и до конца main().
    Иначе закрытие произойдёт в GC-финализаторе на выходе процесса — уже после
    разрушения QApplication и частичной разгрузки ODBC/Winsock, и QODBC выдаёт
    каскад ошибок "Unable to disconnect datasource / free connection handle /
    free environment handle". close() идемпотентен, деструктор вызывает его сам.
```
