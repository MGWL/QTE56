# QTE56 — AI_TEXTCODEC (перекодировка cp1251/cp866/KOI8-R через QTextCodec)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md и AI_SQL.md.
> DLL: `qte56_textcodec.dll` | модуль: `gen_qtextcodec` | индексы: 20157–20162

Этот файл — про работу с **legacy-кодировками** (cp1251, cp866, KOI8-R и т.п.)
на стыке D ↔ Qt. Решает классическую проблему: ODBC/файлы/QProcess отдают
байты в национальной кодировке, Qt декодирует их как UTF-8 → данные теряются
ещё до попадания в D.

---

## TL;DR

```d
import gen_qtextcodec;

ubyte[] raw  = ...;                                 // сырые байты cp1251
string  text = QTextCodec.fromCp1251(raw);          // → читаемая UTF-8 D-строка

ubyte[] out  = QTextCodec.toCp866("Привет");        // → байты cp866 для cmd.exe
```

---

## Корень проблемы

Qt 5 внутри использует UTF-16 (`QString`). Когда драйвер отдаёт байты:

```
Драйвер ODBC (cp1251 байты)
    ↓ (использует свой кодек — часто неверный!)
QVariant (QString — уже UTF-16, но возможно с потерями)
    ↓
toString() / fromQString()
    ↓
D string — кракозябры или знаки '?'
```

**К моменту, когда D получает данные, информация уже потеряна.** Re-decode
на D-стороне не поможет.

**Решение**: получить *сырые байты до декодирования* через `QByteArray`
и явно вызвать `QTextCodec.decode(codec, bytes)`.

---

## Минимальный пример

```d
import qte56_core, qte56_loader;
import gen_qtextcodec;

void main() {
    LoadQt("./dll");                                  // grузит qte56_textcodec.dll

    ubyte[] cp1251 = [0xCF, 0xF0, 0xE8, 0xE2, 0xE5, 0xF2];  // "Привет"
    string  text   = QTextCodec.fromCp1251(cp1251);
    assert(text == "Привет");
}
```

---

## API

### Базовое

| Метод | Назначение |
|---|---|
| `QTextCodec.codecAvailable(name)` | проверить наличие кодека (`true/false`) |
| `QTextCodec.decode(name, bytes)` | байты → D-string |
| `QTextCodec.encode(name, text)` | D-string → байты |
| `QTextCodec.availableCodecs()` | `string[]` всех зарегистрированных кодеков |
| `QTextCodec.setCodecForLocale(name)` | глобальный locale-кодек |
| `QTextCodec.codecForLocaleName()` | имя текущего locale-кодека |

### Удобные алиасы для русских кодировок

| Кодек | Алиас декодирования | Алиас кодирования | Где встретишь |
|---|---|---|---|
| `Windows-1251` | `fromCp1251` | `toCp1251` | 1С, MS SQL, MS Office, MyODBC |
| `IBM866` | `fromCp866` | `toCp866` | cmd.exe, FoxPro/dBase, .DBF |
| `KOI8-R` | `fromKoi8r` | `toKoi8r` | Russian email/Internet 90-х |
| `KOI8-U` | `fromKoi8u` | `toKoi8u` | украинский KOI8 |
| `ISO 8859-5` | `fromIso5` | `toIso5` | ISO-стандарт, редко |

Дополнительно (не алиасами — через `decode/encode` по имени):
- `Macintosh` (MacRoman; MacCyrillic — только при ICU-сборке Qt)
- `windows-1252`–`windows-1258` (другие национальные)
- `GB18030`, `Shift_JIS`, `EUC-KR` (азиатские)

Проверить, доступно ли — `availableCodecs()` или `codecAvailable("name")`.

---

## Сценарии использования

### 1. Чтение файла в cp1251

```d
@live auto f = new QFile("export_1c.txt");
f.open(1 /*ReadOnly*/);
ubyte[] raw  = cast(ubyte[])f.readAll();
string  text = QTextCodec.fromCp1251(raw);
f.close();
```

### 2. Вывод консольной утилиты Windows (cmd.exe → cp866)

```d
@live auto p = new QProcess();
p.start("cmd.exe", ["/c", "dir"]);
p.waitForFinished();
ubyte[] raw  = p.readAllStdout();
string  text = QTextCodec.fromCp866(raw);     // или fromCp1251 — зависит от chcp
```

### 3. ⚠ КЛЮЧЕВОЕ — чтение поля cp1251 из ODBC/QSql

**Главная проблема**: ODBC-драйвер сам конвертирует `VARCHAR` (cp1251)
в `QString`, применяя свой (часто неверный) кодек. Чтобы получить
**оригинальные байты**, нужно в `SELECT` принудительно превратить
поле в `BINARY/VARBINARY`:

```sql
-- MS SQL (через QODBC):
SELECT CAST(name AS VARBINARY(MAX)) FROM clients

-- MySQL/MariaDB (QMYSQL):
SELECT CAST(name AS BINARY) FROM clients

-- PostgreSQL (QPSQL):
SELECT name::bytea FROM clients
```

Затем в D — `q.valueBytes(0)` (новый метод, добавлен в Phase TextCodec)
вместо `q.valueString(0)`:

```d
import gen_qsql, gen_qtextcodec;

auto q = new QSqlQuery(db);
q.exec("SELECT CAST(name AS VARBINARY(MAX)) FROM clients");
while (q.next()) {
    ubyte[] raw  = q.valueBytes(0);              // СЫРЫЕ байты cp1251
    string  name = QTextCodec.fromCp1251(raw);   // читаемая русская строка
    writeln(name);
}
```

### 4. Альтернатива №1 — connection-string (если драйвер поддерживает)

Самый правильный путь — **заставить драйвер отдавать UTF-8/UTF-16**:

| База | Как |
|---|---|
| MySQL/MariaDB | `;CHARSET=utf8` в connect-строке + `SET NAMES utf8` |
| MS SQL | использовать поля `NVARCHAR/NCHAR` (UTF-16), а не `VARCHAR` |
| PostgreSQL | `client_encoding=UTF8` |
| Access | Unicode-версия ODBC-драйвера |

Если работает — `QTextCodec` не нужен, потому что данные приходят в Unicode.
Но для FoxPro / dBase / DBF / Paradox / старых проприетарных БД
это часто не работает → `valueBytes()` + `QTextCodec` неизбежны.

### 5. Запись текста в legacy-формат

Обратный сценарий: положить в .txt или БД строку в cp1251:

```d
ubyte[] bytes = QTextCodec.toCp1251("Привет");
@live auto f  = new QFile("out_cp1251.txt");
f.open(2 /*WriteOnly*/);
f.write(bytes);
f.close();
```

### 6. Глобальная подстраховка через locale-кодек

Если очень старый код полагается на `QString::fromLocal8Bit`:

```d
void main() {
    LoadQt("./dll");
    QTextCodec.setCodecForLocale("Windows-1251");  // меняем default
    // ...
}
```

Влияет на интерпретацию `argv`, `QTextStream`, `QString::toLocal8Bit`.
Менять обычно один раз при старте.

---

## Что делать когда не работает

```
1. ODBC-драйвер всё равно отдаёт "?" / кракозябры даже с CAST AS BINARY
   → Проверь, не использует ли драйвер connection charset (см. секцию 4).
     Некоторые ODBC-драйверы конвертируют ДО Qt и игнорируют CAST.
   → Альтернатива: pyodbc / другой драйвер для одноразового экспорта.

2. QTextCodec.decode возвращает строку с U+FFFD (replacement)
   → Байты не валидны для указанного кодека. Проверь: возможно реально cp866,
     а не cp1251 (типичная путаница для DOS-времён файлов).
   → ui_tree эквивалент для байтов: distill через
     `availableCodecs()` + сравнение результатов decode для разных кодеков.

3. Файл начинается с BOM, но в нём cp1251
   → BOM = UTF-8/UTF-16 маркер; присутствие BOM в cp1251-файле редко.
     Снять первые 3 байта (если EF BB BF) или 2 байта (если FF FE / FE FF)
     перед decode, ИЛИ сначала проверить через
     std.file.read и встроенный std.encoding (он умеет UTF-8/16/32).

4. После QTextCodec.setCodecForLocale("Windows-1251") locale.name() = "windows-1251"
   → Это нормально: Qt возвращает каноническое имя в lowercase.
     Сравнивай через .toLower либо ищи через canFind ignore-case.

5. В Qt 6 этого не существует
   → QTextCodec удалён в Qt 6 → заменить на QStringConverter (только UTF/Latin-1)
     либо линковать Qt5Compat. Для cp1251/cp866 в Qt 6 прийдётся встраивать
     свои таблицы (~5 КБ на кодек).
```

---

## Подводные камни

```
1. valueBytes() для VARCHAR-поля БЕЗ CAST AS BINARY вернёт байты UTF-8
   (потому что Qt уже сконвертировал в QString и отдаёт через .toUtf8()).
   Это корректно ТОЛЬКО для современных БД с unicode-полями.
   Для legacy cp1251 — обязателен CAST в SELECT.

2. encode() символов, не представимых в кодировке, заменяет на '?':
     QTextCodec.toCp1251("Hello 中文")  // → "Hello ??"
   Не ошибка — поведение Qt (для cp1251 нет китайских иероглифов).

3. decode() невалидных байт возвращает U+FFFD (replacement character),
   не падает с exception. Проверка: ищи '�' в результате.

4. availableCodecs() возвращает имена в каноническом виде Qt
   (часто lowercase). Сравнение надо делать case-insensitive.
   Lookup через codecAvailable / decode регистр НЕ важен.

5. KOI8-U это НЕ KOI8-R. У них разный набор букв (украинские є/ї/і + ґ).
   Использовать правильную версию для украинского текста.

6. setCodecForLocale("...") влияет НА ВЕСЬ ПРОЦЕСС. Не вызывать в библиотеках
   и плагинах — может сломать другой код в том же приложении.
```

---

## Где смотреть детали

| Задача | Файл |
|---|---|
| Гайд (этот файл) | `AI_TEXTCODEC.md` |
| Пример с комментариями | `tools/qte_guide/snip/20_TextCodec.d` |
| D API | `d/gen/gen_qtextcodec.d` (ddoc-комментарии) |
| Тесты | `test/test_qtextcodec.d` (41/41 PASS) |
| C++ обвязка | `cpp/qt5/qte56_textcodec/qte56_textcodec.cpp` |
| QByteArray API | `d/gen/gen_qbytearray.d` |
| QSql.valueBytes | `d/gen/gen_qsql.d` (метод `valueBytes(int col)`) |

---

*QTE56 AI_TEXTCODEC — Phase 1 cp1251/cp866 support, апрель 2026*
