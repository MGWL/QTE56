# 📚 Руководство по CSV в языке D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CSV_FOR_AI.md](README_CSV_FOR_AI.md)

**Язык:** D (D Programming Language)  
**Назначение:** Помощь AI (DeepSeek, Claude и др.) в генерации правильного кода для работы с CSV  
**Версия:** std.csv (dlang.org)  

---

## 🎯 Основные концепции

### Что такое CSV

CSV (Comma-Separated Values) — простой текстовый формат для хранения табличных данных:

```
Name,Occupation,Salary
Joe,Carpenter,300000
Fred,Blacksmith,400000
```

**Плюсы:**
- ✅ Простой текстовый формат
- ✅ Поддерживается всеми программами
- ✅ Легко читать и писать

**Минусы:**
- ⚠️ Чувствителен к форматированию
- ⚠️ Нужно правильно обрабатывать кавычки и переносы строк
- ⚠️ Поддерживается не все символы

### RFC-4180 стандарт

D CSV парсер следует стандарту RFC-4180 с небольшими отличиями:

```
✅ Обязательно:
- Записи разделены новой строкой (CRLF, LF, CR)
- Последняя запись может заканчиваться новой строкой
- Поля разделены запятой (кастомизируется)
- Кавычки экранируются удвоением: "" → "

⚠️ Гибкое:
- Может быть заголовок (первая строка)
- Все записи должны иметь одинаковое число полей
- Поле с запятыми/кавычками должно быть в кавычках
```

---

## 📝 Основные функции

### Импорт

```d
import std.csv;
```

### 1. csvReader — основная функция чтения

```d
// Самый простой вариант
auto records = text.csvReader;

// Со стандартным типом
auto records = text.csvReader!int;

// Со структурой
struct Person { string name; int age; }
auto records = text.csvReader!Person;

// С заголовком (null = первая строка — заголовок)
auto records = text.csvReader!(string[string])(text, null);

// С кастомным разделителем
auto records = text.csvReader!string(';');  // вместо запятой
```

**Параметры:**

```d
// Contents — тип каждой записи
// - string (по умолчанию) = один field
// - int, double и т.д. = числовой field
// - Tuple!(type1, type2, ...) = несколько полей
// - struct/class = структурированная запись
// - string[string] = ассоциативный массив (с заголовком)

// ErrorLevel — обработка ошибок
// - Malformed.throwException (по умолчанию) = выбросить исключение
// - Malformed.ignore = игнорировать ошибки CSV

// delimiter = символ разделителя (по умолчанию ',')
// quote = символ кавычки (по умолчанию '"')
// allowInconsistentDelimiterCount = разное число полей (по умолчанию false)
```

### 2. csvNextToken — низкоуровневое разбор

```d
import std.array : appender;

auto ans = appender!string();
csvNextToken(input, ans, ',', '"');  // Извлечь один field
```

**Когда использовать:** Для полного контроля над разбором при обработке нестандартного CSV.

---

## 🔥 Типы исключений

### CSVException — базовое исключение

```d
// Всегда содержит row и col (от 1)
try {
    csvReader(text).count;
} catch(CSVException ex) {
    writefln("Ошибка в строке %d, столбец %d", ex.row, ex.col);
}
```

**Когда выбрасывается:**
- Несовпадающее число полей
- Неправильная кавычка в неquoted field
- Данные после closing quote
- Unclosed quoted field
- Ошибка конвертации типа

### IncompleteCellException — неполная ячейка

```d
// Когда кавычка не закрыта или неправильно расположена
string text = "a,\"b,c\nHello,65,2.5";
csvReader(text).count;  // Выбросит IncompleteCellException
```

**Поля:**
- `partialData` — данные до ошибки

### HeaderMismatchException — мисматч заголовка

```d
// Когда заголовок не совпадает со структурой
string text = "a,b,c\nHello,65,2.5";
csvReader!(string[string])(text, ["a", "b", "invalid"]);
// Выбросит HeaderMismatchException
```

---

## ⚙️ Обработка ошибок (Malformed)

### Режим throwException (по умолчанию)

```d
string text = "a,b,c\nHello,65,\"2.5";  // Unclosed quote!

// Выбросит исключение
try {
    csvReader(text).count;
} catch(Exception ex) {
    writeln("Ошибка: ", ex.msg);
}
```

### Режим ignore

```d
string text = "a,b,c\nHello,65,\"2.5";  // Unclosed quote!

// Не выбросит исключение, попробует обработать
auto records = csvReader!(string, Malformed.ignore)(text);

// Поведение при ошибке:
// - Кавычка в unquoted field → считается частью данных
// - Кавычка в quoted field не в конце → конец field
// - Unclosed field → конец при нехватке данных
// - Заголовок не совпадает → возвращает как есть
```

---

## 📊 Типы содержимого (Contents)

### 1. Строки (string)

```d
string text = "Joe,Carpenter,300000";

// Каждое поле — отдельный field
foreach (field; text.csvReader)
{
    writeln(field);  // "Joe", "Carpenter", "300000"
}
```

### 2. Числа (int, double и т.д.)

```d
string text = "10,20,30\n40,50,60";

foreach (record; text.csvReader!int)
{
    writeln(record);  // [10,20,30], [40,50,60]
}
```

### 3. Tuple (несколько типов)

```d
import std.typecons : Tuple;

string text = "Joe,Carpenter,300000\nFred,Blacksmith,400000";

foreach (record; text.csvReader!(Tuple!(string, string, int)))
{
    writefln("%s works as a %s and earns $%d",
             record[0], record[1], record[2]);
}
```

### 4. Struct

```d
struct Person {
    string name;
    string job;
    int salary;
}

string text = "Joe,Carpenter,300000\nFred,Blacksmith,400000";

foreach (record; text.csvReader!Person)
{
    writefln("%s works as %s", record.name, record.job);
}
```

### 5. Class

```d
class Employee {
    string name;
    int id;
}

foreach (record; text.csvReader!Employee)
{
    writeln(record.name);
}
```

### 6. Ассоциативный массив (с заголовком)

```d
string text = "Name,Job,Salary\n" ~
    "Joe,Carpenter,300000\n" ~
    "Fred,Blacksmith,400000";

// null = первая строка — заголовок
foreach (record; text.csvReader!(string[string])(text, null))
{
    writefln("%s works as %s",
             record["Name"],
             record["Job"]);
}
```

---

## 🗂️ Работа с заголовками

### Случай 1: Автоматический заголовок (null)

```d
string text = "a,b,c\nHello,65,2.5";

auto records = text.csvReader(null);  // null = читай первую строку как заголовок

// Получить заголовок
writeln(records.header);  // ["a", "b", "c"]

// Читать данные
foreach (record; records)
{
    // record — это fields
}
```

### Случай 2: Выборочные столбцы

```d
string text = "a,b,c\nHello,65,63.63\nWorld,123,3673.562";

// Читать только столбец "b"
auto records = text.csvReader!int(["b"]);

foreach (record; records)
{
    writeln(record);  // [65], [123]
}
```

### Случай 3: Переупорядочивание столбцов

```d
struct Layout {
    int value;
    double other;
    string name;
}

string text = "a,b,c\nHello,65,2.5\nWorld,123,7.5";

// Порядок столбцов: b,c,a (не a,b,c!)
auto records = text.csvReader!Layout(["b", "c", "a"]);

// value=65, other=2.5, name="Hello"
```

### Случай 4: Ассоциативный массив

```d
string text = "Name,Job,Salary\nJoe,Carpenter,300000";

foreach (record; text.csvReader!(string[string])(text, null))
{
    foreach (key, value; record)
    {
        writefln("%s: %s", key, value);
    }
}
```

---

## 🔧 Кастомные разделители

### Запятая (по умолчанию)

```d
string text = "Joe,Carpenter,300000";
auto records = text.csvReader;  // Разделитель: ','
```

### Точка с запятой

```d
string text = "Joe;Carpenter;300000";
auto records = text.csvReader(';');  // Разделитель: ';'
```

### Tab

```d
string text = "Joe\tCarpenter\t300000";
auto records = text.csvReader('\t');  // Разделитель: tab
```

### Кастомная кавычка

```d
string text = "'Joe','Carpenter','300000'";

// Разделитель: ',', Кавычка: '\''
auto records = text.csvReader(',', '\'');
```

---

## 🚨 Частые ошибки и исправления

### Ошибка 1: Забыть импорт

```d
// ❌
void main() {
    auto records = text.csvReader;  // Ошибка компиляции!
}

// ✅
import std.csv;

void main() {
    auto records = text.csvReader;  // ОК
}
```

### Ошибка 2: Неправильная кавычка в CSV

```d
// ❌ Unclosed quote
string text = "Joe,\"Carpenter,300000";

// ✅ Правильно закрыть или использовать Malformed.ignore
string text = "Joe,\"Carpenter\",300000";
```

### Ошибка 3: Неправильно указан заголовок

```d
// ❌ Заголовок не совпадает с данными
string text = "a,b,c\nHello,65,2.5";
auto records = text.csvReader!(string[string])(text, ["x", "y", "z"]);
// HeaderMismatchException!

// ✅
auto records = text.csvReader!(string[string])(text, ["a", "b", "c"]);
```

### Ошибка 4: Несовпадающее число полей

```d
// ❌
string text = "76,26,22\n1,2\n3,4,5,6";
auto records = text.csvReader!int;  // CSVException!

// ✅ Разрешить разное число полей
auto records = text.csvReader!int(',', '"', true);  // true = allow inconsistent
```

### Ошибка 5: Конвертация типа

```d
// ❌
string text = "a,b,c";
auto records = text.csvReader!int;  // ConvException!

// ✅
string text = "10,20,30";
auto records = text.csvReader!int;
```

---

## 💡 Лучшие практики

### Правило 1: Проверяй тип данных перед читкой

```d
// ❌ Может crashнуть
auto records = text.csvReader!int;

// ✅ Проверь формат
if (is_valid_csv_format(text)) {
    auto records = text.csvReader!int;
}
```

### Правило 2: Используй try-catch для CSVException

```d
try {
    foreach (record; csvReader(text))
    {
        // обработка
    }
} catch(CSVException ex) {
    writefln("Ошибка CSV в строке %d: %s", ex.row, ex.msg);
}
```

### Правило 3: Используй структуры для типизированных данных

```d
// ❌ Нет типизации
auto records = text.csvReader!(string[string]);

// ✅ Есть типизация
struct Person {
    string name;
    string job;
    int salary;
}
auto records = text.csvReader!Person;
```

### Правило 4: Для слабо типизированного CSV используй Malformed.ignore

```d
// Если CSV не соответствует RFC-4180
auto records = text.csvReader!(string, Malformed.ignore);
```

### Правило 5: Используй File.byLine для больших файлов

```d
import std.stdio : File;

auto file = File("data.csv");

foreach (record; file.byLine.joiner("\n").csvReader!Person)
{
    // обработка без загрузки весь файл в память
}
```

---

## 📊 Совместимость типов

```
✅ Работает:
- string, int, double, long, bool и др.
- Tuple!(type1, type2, ...)
- struct с полями основных типов
- class с полями основных типов
- string[string] (ассоциативный массив)

⚠️ Осторожно:
- Custom types требуют std.conv поддержки
- вложенные структуры — не работают
```

---

## 🎓 Инструкции для AI моделей

### При генерации кода для CSV:

1. **Чтение простого CSV:**
   ```d
   auto records = csvReader(text);  // string по умолчанию
   ```

2. **Чтение типизированного CSV:**
   ```d
   auto records = csvReader!int(text);  // Числа
   // или
   auto records = csvReader!Person(text);  // Структура
   ```

3. **С заголовком:**
   ```d
   auto records = csvReader!(string[string])(text, null);  // null = из текста
   ```

4. **С кастомным разделителем:**
   ```d
   auto records = csvReader(text, ';');  // Точка с запятой
   ```

5. **Обработка ошибок:**
   ```d
   try {
       csvReader(text).count;
   } catch(CSVException ex) {
       // обработка
   }
   ```

---

**Дата:** 2026-04-27  
**Источник:** dlang.org/phobos/std/csv.html  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
