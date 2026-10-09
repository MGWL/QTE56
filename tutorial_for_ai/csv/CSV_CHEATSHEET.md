# 🚀 Шпаргалка по CSV в D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CSV_FOR_AI.md](README_CSV_FOR_AI.md)

**Для быстрого копирования в контекст/промпт**

---

## 📌 Золотые правила CSV в D

```
1. csvReader — основная функция для всех операций
2. Структуры для типизированных данных
3. null в заголовке = первая строка это заголовок
4. Обрабатывай CSVException для обработки ошибок
5. Используй Malformed.ignore для слабого CSV
```

---

## ⚡ Самые частые конструкции

### Чтение CSV

```d
// Строки (по умолчанию)
auto records = text.csvReader;

// Со структурой
struct Person { string name; int age; }
auto records = text.csvReader!Person;

// Со скобками
auto records = text.csvReader!(string[string])(text, null);

// С кастомным разделителем
auto records = text.csvReader(text, ';');
```

### Структуры и Tuples

```d
// Структура
struct Person {
    string name;
    string job;
    int salary;
}

// Tuple (несколько типов)
import std.typecons : Tuple;
auto records = text.csvReader!(Tuple!(string, int, double));

// Класс
class Employee {
    string name;
    int id;
}
```

### Итерирование

```d
// Простой foreach
foreach (record; csvReader(text)) {
    writeln(record);
}

// С файлом
import std.stdio : File;
auto file = File("data.csv");
foreach (record; file.byLine.joiner("\n").csvReader!Person) {
    // обработка
}
```

---

## 🔥 Самые частые ошибки → исправления

### Ошибка 1: Забыть импорт

```d
// ❌
void main() {
    auto records = text.csvReader;  // Ошибка!
}

// ✅
import std.csv;
void main() {
    auto records = text.csvReader;
}
```

### Ошибка 2: Неправильный тип

```d
// ❌ Строка "Hello" не число
string text = "Hello,65";
auto records = text.csvReader!int;  // ConvException!

// ✅
string text = "10,20";
auto records = text.csvReader!int;
```

### Ошибка 3: Несовпадающее число полей

```d
// ❌
string text = "76,26,22\n1,2";  // Второе число разное!
auto records = text.csvReader!int;  // CSVException!

// ✅ Разрешить разное число
auto records = text.csvReader!int(',', '"', true);
```

### Ошибка 4: Неправильная кавычка

```d
// ❌ Unclosed quote
string text = "Joe,\"Carpenter,300000";

// ✅ Закрыть или использовать Malformed.ignore
string text = "Joe,\"Carpenter\",300000";
// или
auto records = text.csvReader!(string, Malformed.ignore);
```

### Ошибка 5: Забыть null для заголовка

```d
// ❌ Не указан заголовок
string text = "Name,Age\nAlice,30";
auto records = text.csvReader!(string[string])(text);  // Ошибка!

// ✅ null = первая строка заголовок
auto records = text.csvReader!(string[string])(text, null);
```

---

## 🎯 Выбери правильный вариант

### Для чтения

```d
// ✅ Обычно (9 из 10 раз)
auto records = csvReader(text);
auto records = csvReader!Person(text);

// ⚠️ Редко (специальные случаи)
auto records = csvReader!(string, Malformed.ignore)(text);
```

### Для разделителей

```d
// ✅ Запятая (по умолчанию)
auto records = csvReader(text);

// ✅ Точка с запятой
auto records = csvReader(text, ';');

// ✅ Tab
auto records = csvReader(text, '\t');
```

### Для заголовков

```d
// ✅ Из CSV (null = первая строка)
auto records = csvReader!(string[string])(text, null);

// ✅ Выборочные столбцы
auto records = csvReader!int(text, ["col1", "col2"]);

// ✅ Переупорядочить
auto records = csvReader!Person(text, ["b", "c", "a"]);
```

### Для ошибок

```d
// ✅ Выбросить исключение (по умолчанию)
auto records = csvReader(text);  // throwException

// ✅ Игнорировать ошибки
auto records = csvReader!(string, Malformed.ignore)(text);
```

---

## 🔧 Необходимые импорты

```d
// Основное
import std.csv;

// Для структур
import std.typecons : Tuple;

// Для файлов
import std.stdio : File, writeln;

// Для операций с диапазонами
import std.algorithm : filter, map;
import std.range : joiner;
```

---

## 📊 Контрольный список

### При написании кода с CSV
- [ ] Импортирован `std.csv`?
- [ ] Правильный разделитель (по умолчанию ',')?
- [ ] Структура совпадает с порядком в CSV?
- [ ] Использовала `null` для заголовка?
- [ ] Обработано `CSVException`?
- [ ] Разное число полей → `true` параметр?

### При работе с файлами
- [ ] Закрывается ли файл автоматически?
- [ ] Используется ли `byLine.joiner` для больших файлов?
- [ ] Правильная кодировка файла (UTF-8)?
- [ ] Есть ли проверка существования файла?

### При обработке данных
- [ ] Проверены ли типы конвертации?
- [ ] Обработаны ли пустые значения?
- [ ] Нет ли проблем с кавычками в данных?
- [ ] Логика фильтрования корректна?

---

## 🎓 Когда какие функции использовать

| Функция | Когда | Пример |
|---------|-------|--------|
| `csvReader` | Основное чтение | `csvReader(text)` |
| `csvReader!Type` | Типизированное | `csvReader!Person(text)` |
| `csvReader(..., null)` | С заголовком | `csvReader!T(text, null)` |
| `csvReader(..., ["col"])` | Выборочные | `csvReader!int(text, ["col1"])` |
| `csvReader(..., Malformed.ignore)` | Слабое CSV | `csvReader!(T, Malformed.ignore)` |
| `csvNextToken` | Низкоуровневое | `csvNextToken(input, output, ',', '"')` |
| `file.byLine.joiner` | Большие файлы | `file.byLine.joiner("\n").csvReader!T` |

---

## 🛡️ Защита от проблем

### Если ошибка конвертации типа

```d
string text = "Hello,65";  // First field не число!

// ❌ Выбросит исключение
auto records = text.csvReader!int;

// ✅ Игнорировать
auto records = text.csvReader!(string, Malformed.ignore);
```

### Если unclosed quote

```d
string text = "Joe,\"Carpenter,300000";  // Кавычка не закрыта!

// ✅ Использовать Malformed.ignore
auto records = text.csvReader!(string, Malformed.ignore);
```

### Если разное число полей

```d
string text = "76,26,22\n1,2\n3,4,5,6";  // Разное число!

// ✅ Разрешить
auto records = text.csvReader!int(',', '"', true);
```

### Если заголовок не совпадает

```d
string text = "a,b,c\nHello,65,2.5";
auto records = text.csvReader!Person(["a", "b", "invalid"]);
// ❌ HeaderMismatchException!

// ✅ Правильный порядок
auto records = text.csvReader!Person(["a", "b", "c"]);
```

---

## 🚀 Быстрый старт

```d
import std.csv;
import std.stdio : File, writeln;

struct Record {
    string name;
    int age;
}

void main() {
    // Из строки
    string text = "Alice,30\nBob,25";
    foreach (r; text.csvReader!Record) {
        writeln(r.name, " is ", r.age);
    }
    
    // Из файла
    auto file = File("data.csv");
    foreach (r; file.byLine.joiner("\n").csvReader!Record) {
        writeln(r.name);
    }
    
    // С обработкой ошибок
    try {
        foreach (r; text.csvReader!Record) {
            // обработка
        }
    } catch(CSVException ex) {
        writeln("Error at row ", ex.row);
    }
}
```

---

## ❓ FAQ для AI

**Q: Нужно ли вызывать close() на File?**  
A: Нет. File автоматически закрывается при выходе из scope.

**Q: Как читать большой CSV файл?**  
A: Используй `file.byLine.joiner("\n").csvReader` — не загружает все в память.

**Q: Что если CSV содержит пустые значения?**  
A: Пустые значения конвертируются в default значение типа (0 для int, "" для string).

**Q: Можно ли менять порядок столбцов?**  
A: Да, передай массив в нужном порядке: `csvReader!Person(text, ["col3", "col1", "col2"])`.

**Q: Как обработать CSV с ошибками?**  
A: Используй `Malformed.ignore` параметр.

**Q: Что если некоторые столбцы не нужны?**  
A: Передай массив с нужными столбцами: `csvReader!int(text, ["col1", "col3"])`.

---

## 🔗 Ссылки на полные гайды

- `CSV_GUIDE_FOR_AI.md` — полное описание всех функций
- `CSV_EXAMPLES.md` — 14 рабочих примеров
- dlang.org/phobos/std/csv.html — официальная документация

---

**Версия:** 2026-04-27  
**Для использования:** DeepSeek, Claude, GPT, Qwen и др. генеративные модели  
**Язык:** D Programming Language

**Скопируй эту шпаргалку в контекст промпта перед просьбой писать код с CSV на D!**
