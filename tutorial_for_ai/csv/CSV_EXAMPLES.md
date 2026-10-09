# 💻 Практические примеры работы с CSV в D

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CSV_FOR_AI.md](README_CSV_FOR_AI.md)

---

## 1️⃣ Базовые примеры

### Пример 1: Простое чтение CSV

```d
import std.csv : csvReader;
import std.stdio : writeln;

void main() {
    string text = "Joe,Carpenter,300000\nFred,Blacksmith,400000";
    
    // Читать каждую строку
    foreach (record; text.csvReader)
    {
        writeln(record);  // Каждое поле
    }
}
```

**Вывод:**
```
["Joe", "Carpenter", "300000"]
["Fred", "Blacksmith", "400000"]
```

---

### Пример 2: Чтение со структурой

```d
import std.csv : csvReader;
import std.stdio : writefln;

struct Person {
    string name;
    string job;
    int salary;
}

void main() {
    string text = "Joe,Carpenter,300000\nFred,Blacksmith,400000";
    
    foreach (record; text.csvReader!Person)
    {
        writefln("%s works as %s and earns $%d",
                 record.name, record.job, record.salary);
    }
}
```

**Вывод:**
```
Joe works as Carpenter and earns $300000
Fred works as Blacksmith and earns $400000
```

**Объяснение:** Структура должна иметь поля в том же порядке что в CSV.

---

### Пример 3: Чтение только чисел

```d
import std.csv : csvReader;
import std.stdio : writeln;

void main() {
    string text = "10,20,30\n40,50,60";
    
    foreach (record; text.csvReader!int)
    {
        writeln(record);  // [10,20,30], [40,50,60]
    }
}
```

**Объяснение:** `!int` автоматически конвертирует каждое поле в int.

---

## 2️⃣ Продвинутые примеры

### Пример 4: С кастомным разделителем (;)

```d
import std.csv : csvReader;
import std.stdio : writefln;
import std.typecons : Tuple;

void main() {
    string text = "Hello;65;2.5\nWorld;123;7.5";
    
    auto records = text.csvReader!(Tuple!(string, int, double))(';');
    
    foreach (record; records)
    {
        writefln("%s: %d items, weight %.1f", 
                 record[0], record[1], record[2]);
    }
}
```

**Вывод:**
```
Hello: 65 items, weight 2.5
World: 123 items, weight 7.5
```

**Ключевой момент:** Третий параметр `';'` меняет разделитель.

---

### Пример 5: Чтение файла строка за строкой

```d
import std.csv : csvReader;
import std.stdio : File, writefln;
import std.range : joiner;

struct Record {
    string name;
    int age;
    string city;
}

void main() {
    auto file = File("people.csv");
    
    // byLine.joiner — эффективное чтение больших файлов
    foreach (record; file.byLine.joiner("\n").csvReader!Record)
    {
        writefln("%s is %d years old from %s",
                 record.name, record.age, record.city);
    }
}
```

**CSV файл (people.csv):**
```
Alice,30,New York
Bob,25,London
Carol,28,Paris
```

**Объяснение:** 
- `byLine` — читает по строкам БЕЗ загрузки всего файла в память
- `joiner("\n")` — соединяет строки новыми линиями
- Подходит для больших CSV файлов

---

### Пример 6: Чтение с заголовком (ассоциативный массив)

```d
import std.csv : csvReader;
import std.stdio : writefln;

void main() {
    string text = "Name,Job,Salary\n" ~
        "Joe,Carpenter,300000\n" ~
        "Fred,Blacksmith,400000";
    
    // null = первая строка — заголовок
    foreach (record; text.csvReader!(string[string])(text, null))
    {
        writefln("%s: %s ($%s)",
                 record["Name"],
                 record["Job"],
                 record["Salary"]);
    }
}
```

**Вывод:**
```
Joe: Carpenter ($300000)
Fred: Blacksmith ($400000)
```

**Ключевой момент:** `null` указывает что заголовок в первой строке CSV.

---

### Пример 7: Выборочные столбцы

```d
import std.csv : csvReader;
import std.stdio : writeln;
import std.algorithm : equal;

void main() {
    string text = "a,b,c\nHello,65,63.63\nWorld,123,3673.562";
    
    // Читать только столбец "b"
    auto records = text.csvReader!int(["b"]);
    
    foreach (record; records)
    {
        writeln(record);  // [65], [123]
    }
}
```

**Объяснение:** Массив `["b"]` указывает только интересующие нас столбцы.

---

### Пример 8: Переупорядочивание столбцов

```d
import std.csv : csvReader;
import std.stdio : writefln;

struct Layout {
    int value;
    double other;
    string name;
}

void main() {
    string text = "a,b,c\nHello,65,2.5\nWorld,123,7.5";
    
    // Порядок в заголовке: b,c,a (не a,b,c!)
    auto records = text.csvReader!Layout(["b", "c", "a"]);
    
    foreach (record; records)
    {
        writefln("%s: value=%d, other=%.1f",
                 record.name, record.value, record.other);
    }
}
```

**Вывод:**
```
Hello: value=65, other=2.5
World: value=123, other=7.5
```

**Ключевой момент:** Порядок в заголовке определяет маппинг на поля структуры.

---

## 3️⃣ Обработка ошибок

### Пример 9: Перехват CSV исключений

```d
import std.csv : csvReader, CSVException;
import std.stdio : writefln;

void main() {
    string text = "a,b,c\nHello,65";  // Мало полей!
    
    try {
        foreach (record; text.csvReader)
        {
            // обработка
        }
    } catch(CSVException ex) {
        writefln("Ошибка CSV: строка %d, столбец %d",
                 ex.row, ex.col);
        writefln("Сообщение: %s", ex.msg);
    }
}
```

**Вывод:**
```
Ошибка CSV: строка 2, столбец 0
Сообщение: Row 2's length 2 does not match previous length of 3.
```

**Объяснение:**
- `ex.row` и `ex.col` — позиция ошибки
- Нумерация начинается с 1

---

### Пример 10: Игнорирование ошибок (Malformed.ignore)

```d
import std.csv : csvReader, Malformed;
import std.stdio : writeln;

void main() {
    // Некорректный CSV (unclosed quote)
    string text = "a,\"b,c\nHello,65,2.5";
    
    // Обычно выбросит исключение
    // try {
    //     csvReader(text).front;  // IncompleteCellException!
    // }
    
    // С Malformed.ignore — игнорирует ошибки
    auto records = csvReader!(string, Malformed.ignore)(text);
    
    foreach (record; records)
    {
        writeln(record);
    }
}
```

**Ключевой момент:** Используй `Malformed.ignore` для слабо типизированного CSV.

---

## 4️⃣ Сложные сценарии

### Пример 11: Чтение переменного числа полей

```d
import std.csv : csvReader;
import std.stdio : writeln;

void main() {
    // Разное число полей в каждой строке
    string text = "76,26,22\n1,2\n3,4,5,6";
    
    // allowInconsistentDelimiterCount = true
    auto records = text.csvReader!int(',', '"', true);
    
    foreach (record; records)
    {
        write("Record: ");
        foreach (val; record) write(val, " ");
        writeln();
    }
}
```

**Вывод:**
```
Record: 76 26 22
Record: 1 2
Record: 3 4 5 6
```

**Ключевой момент:** Четвёртый параметр `true` разрешает разное число полей.

---

### Пример 12: Низкоуровневое разбор (csvNextToken)

```d
import std.csv : csvNextToken;
import std.array : appender;
import std.range : popFront;
import std.stdio : writeln;

void main() {
    string str = "65,63\n123,3673";
    
    auto a = appender!string();
    
    // Первый field
    csvNextToken(str, a, ',', '"');
    writeln("Field 1: ", a.data);  // "65"
    writeln("Остаток: ", str);      // ",63\n123,3673"
    
    str.popFront();  // Удалить запятую
    a.shrinkTo(0);   // Очистить buffer
    
    // Второй field
    csvNextToken(str, a, ',', '"');
    writeln("Field 2: ", a.data);  // "63"
    writeln("Остаток: ", str);      // "\n123,3673"
}
```

**Объяснение:** csvNextToken — для полного контроля над разбором.

---

### Пример 13: Чтение с фильтрацией

```d
import std.csv : csvReader;
import std.stdio : writefln;
import std.algorithm : filter;

struct Person {
    string name;
    int salary;
}

void main() {
    string text = "Alice,50000\nBob,30000\nCarol,60000";
    
    auto records = text.csvReader!Person;
    
    // Только людей с зарплатой > 40000
    foreach (person; records.filter!(p => p.salary > 40000))
    {
        writefln("%s earns $%d", person.name, person.salary);
    }
}
```

**Вывод:**
```
Alice earns $50000
Carol earns $60000
```

---

### Пример 14: Дополнительные преобразования

```d
import std.csv : csvReader;
import std.stdio : writefln;
import std.algorithm : map;
import std.typecons : Tuple;

void main() {
    string text = "100,200\n300,400";
    
    auto records = text.csvReader!(Tuple!(int, int));
    
    // Умножить каждое число на 10
    foreach (record; records.map!(r => Tuple!(int,int)(r[0]*10, r[1]*10)))
    {
        writefln("Values: %d, %d", record[0], record[1]);
    }
}
```

---

## 📋 Шпаргалка для быстрого поиска

| Задача | Код |
|--------|-----|
| Простое чтение | `csvReader(text)` |
| Со структурой | `csvReader!Person(text)` |
| Числа | `csvReader!int(text)` |
| Точка с запятой | `csvReader(text, ';')` |
| С заголовком | `csvReader!(string[string])(text, null)` |
| Выборочные столбцы | `csvReader!int(text, ["col1"])` |
| Игнорировать ошибки | `csvReader!(string, Malformed.ignore)(text)` |
| Разное число полей | `csvReader!int(text, ',', '"', true)` |
| Из файла | `file.byLine.joiner("\n").csvReader!Person` |
| Низкоуровневое | `csvNextToken(input, output, ',', '"')` |

---

**Дата:** 2026-04-27  
**Уровень сложности:** Beginner → Advanced  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
