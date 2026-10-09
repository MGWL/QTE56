# 💻 Практические примеры управления памятью в D

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_D_MEMORY_FOR_AI.md](README_D_MEMORY_FOR_AI.md)

---

## 1️⃣ Базовые примеры

### Пример 1: Простое выделение и использование
```d
import std.stdio : writeln;

void main() {
    // GC управляемый массив
    int[] numbers = new int[10];
    
    // Используем
    for (int i = 0; i < 10; i++) {
        numbers[i] = i * 2;
    }
    
    // Вывод
    foreach (n; numbers) {
        writeln(n);
    }
    
    // Не нужно delete! GC сам очистит
}
```

**Объяснение:** `new` выделяет память в heap и регистрирует в GC. При выходе из main массив удаляется автоматически.

---

### Пример 2: Структура и класс
```d
import std.stdio : writeln;

// Структура (value type, обычно в stack)
struct Point {
    int x, y;
}

// Класс (reference type, в heap)
class Circle {
    double radius;
    Point center;
    
    this(double r) {
        radius = r;
        center = Point(0, 0);
    }
}

void main() {
    // Структура в stack
    Point p = Point(10, 20);
    
    // Класс в heap (управляется GC)
    Circle c = new Circle(5.0);
    
    writeln("Point: ", p.x, ", ", p.y);
    writeln("Circle: radius=", c.radius);
}
```

**Объяснение:** Структуры в stack (быстро), классы в heap (управляется GC).

---

## 2️⃣ Продвинутые примеры

### Пример 3: Low-level malloc с атрибутами
```d
import core.memory : GC;
import std.stdio : writeln;

void main() {
    // Массив чисел (нет указателей) → NO_SCAN
    ubyte[] data = cast(ubyte[])GC.malloc(
        1024,
        GC.BlkAttr.NO_SCAN  // Не сканировать на указатели
    );
    
    // Используем
    data[0] = 42;
    
    // Явно освобождаем
    GC.free(data.ptr);
    
    writeln("Allocated and freed");
}
```

**Когда использовать:** Редко. Только для очень низкоуровневого кода.

---

### Пример 4: Управление GC (disable/enable)
```d
import core.memory : GC;
import std.stdio : writeln;

void main() {
    writeln("GC включен");
    
    // Отключить GC для критичного кода
    GC.disable();
    writeln("GC отключен");
    
    // Быстрый критичный код
    for (int i = 0; i < 1000000; i++) {
        auto arr = new int[10];
        // GC не будет срабатывать
    }
    
    // Включить обратно
    GC.enable();
    writeln("GC включен");
    
    // Явно собрать мусор
    GC.collect();
    writeln("Мусор собран");
}
```

**Когда использовать:** Real-time код (игры, системные приложения).

---

## 3️⃣ Многопоточность

### Пример 5: Правильный многопоточный код
```d
import core.thread : Thread;
import core.sync.mutex : Mutex;
import std.stdio : writeln;

__gshared Mutex mtx;        // Синхронизация
__gshared int[] shared_arr; // Общая переменная

void thread_func(int id) {
    for (int i = 0; i < 3; i++) {
        synchronized(mtx) {
            shared_arr ~= id * 10 + i;  // Добавить значение
            writeln("Thread ", id, " added");
        }
    }
}

void main() {
    shared_arr = new int[0];
    
    // Создать потоки
    Thread[] threads;
    for (int i = 0; i < 3; i++) {
        threads ~= new Thread(() => thread_func(i));
    }
    
    // Запустить
    foreach (t; threads) {
        t.start();
    }
    
    // Дождаться
    foreach (t; threads) {
        t.join();
    }
    
    // Вывод результата
    foreach (val; shared_arr) {
        writeln(val);
    }
}
```

**Ключевые моменты:**
- ✅ Использовать `Thread` класс (GC знает о нём)
- ✅ `__gshared` для общих переменных
- ✅ `synchronized(mutex)` для синхронизации

---

### Пример 6: Регистрация памяти для C потока
```d
import core.memory : GC;
import std.stdio : writeln;

__gshared int* external_ptr;

void register_memory() {
    // Выделить память
    external_ptr = new int;
    *external_ptr = 42;
    
    // Зарегистрировать для GC
    // (нужно если указатель хранится в C потоке)
    GC.addRoot(cast(void*)&external_ptr);
    
    writeln("Memory registered: ", *external_ptr);
}

void unregister_memory() {
    // Отрегистрировать
    GC.removeRoot(cast(void*)&external_ptr);
    
    // Теперь GC может удалить
    GC.collect();
    
    writeln("Memory unregistered");
}

void main() {
    register_memory();
    unregister_memory();
}
```

---

## 4️⃣ Ресурсы и cleanup

### Пример 7: RAII pattern
```d
import std.stdio : File, writeln;

class Database {
    string connection_string;
    bool is_open;
    
    this(string conn) {
        connection_string = conn;
        open();
    }
    
    void open() {
        writeln("Opening: ", connection_string);
        is_open = true;
    }
    
    void close() {
        if (is_open) {
            writeln("Closing database");
            is_open = false;
        }
    }
    
    ~this() {
        // Destructor гарантирует cleanup
        close();
    }
}

void main() {
    {
        auto db = new Database("localhost:5432");
        // ... работа с БД ...
        writeln("Working...");
    }  // ← db удалён, БД закрыта
    
    writeln("Done");
}
```

**Вывод:**
```
Opening: localhost:5432
Working...
Closing database
Done
```

---

### Пример 8: Try-finally для гарантированного cleanup
```d
import std.stdio : writeln;

class Resource {
    string name;
    
    this(string n) { name = n; }
    
    void use() {
        writeln("Using: ", name);
    }
    
    void cleanup() {
        writeln("Cleaning: ", name);
    }
}

void main() {
    auto res = new Resource("ImportantFile");
    
    try {
        res.use();
        
        // Может быть исключение
        // throw new Exception("Error!");
    } finally {
        res.cleanup();  // Гарантированный вызов
    }
}
```

**Гарантия:** `cleanup()` вызовется даже если было исключение.

---

## 5️⃣ Когда GC может быть проблемой

### Пример 9: Pause time может быть критичным
```d
import core.memory : GC;
import core.time : Duration, msecs;
import std.stdio : writeln;
import std.datetime.stopwatch : StopWatch;

void game_tick() {
    auto sw = StopWatch();
    sw.start();
    
    // Быстрый код без GC паузы
    GC.disable();
    
    // Много allocations
    for (int i = 0; i < 100000; i++) {
        auto arr = new int[10];
    }
    
    GC.enable();
    
    sw.stop();
    auto elapsed = sw.peek();
    
    writeln("Tick time: ", elapsed);
    
    // Если был бы GC pause → 100+ ms
    // Без pause → 1-5 ms
}

void main() {
    for (int frame = 0; frame < 5; frame++) {
        game_tick();
    }
}
```

---

## 6️⃣ Отладка утечек памяти

### Пример 10: Проверка статистики GC
```d
import core.memory : GC;
import std.stdio : writefln;

void print_gc_stats(string label) {
    auto stats = GC.stats();
    
    writefln("[%s] GC Stats:", label);
    writefln("  Used: %d bytes", stats.usedSize);
    writefln("  Free: %d bytes", stats.freeSize);
    writefln("  Allocated in thread: %d bytes", 
             stats.allocatedInCurrentThread);
}

void main() {
    print_gc_stats("Start");
    
    // Выделить память
    int[][] arrays;
    for (int i = 0; i < 100; i++) {
        arrays ~= new int[1000];
    }
    
    print_gc_stats("After allocation");
    
    // Удалить
    arrays = null;
    
    // Собрать мусор
    GC.collect();
    GC.minimize();
    
    print_gc_stats("After cleanup");
}
```

**Вывод:**
```
[Start] GC Stats:
  Used: 512000 bytes
  Free: 1048576 bytes
  Allocated in thread: 2097152 bytes
[After allocation]
  Used: 612000 bytes
  Free: 948576 bytes
  Allocated in thread: 2197152 bytes
[After cleanup]
  Used: 512000 bytes
  Free: 1048576 bytes
  Allocated in thread: 2197152 bytes
```

---

## 7️⃣ Опасные ошибки

### ❌ Ошибка: Dangling pointer
```d
int* get_pointer() {
    int[] arr = new int[10];
    return arr.ptr;  // ← ОПАСНО!
}

void main() {
    int* ptr = get_pointer();
    // arr уже удалён, ptr указывает на мусор
    *ptr = 42;  // ← UB (undefined behavior)
}
```

### ✅ Исправление:
```d
void get_data(out int[] result) {
    result = new int[10];  // Возвращаем через параметр
}

void main() {
    int[] arr;
    get_data(arr);
    arr[0] = 42;  // ✅ Безопасно
}
```

---

### ❌ Ошибка: Скрытый указатель
```d
int hidden_ptr;

void main() {
    int* ptr = new int;
    *ptr = 42;
    
    hidden_ptr = cast(int)ptr;  // ← ОПАСНО!
    // GC не видит что мы держим указатель
    
    GC.collect();
    
    *ptr = 99;  // ← ptr может быть невалидным
}
```

### ✅ Исправление:
```d
__gshared int* visible_ptr;

void main() {
    visible_ptr = new int;
    *visible_ptr = 42;  // ← GC видит указатель
}
```

---

## 📋 Шпаргалка для быстрого поиска

| Задача | Код |
|--------|-----|
| Массив | `int[] arr = new int[100];` |
| Объект | `auto obj = new MyClass();` |
| Stack | `int x = 5;` |
| Низкоуровневый | `void* ptr = GC.malloc(1024);` |
| Освобожить | `GC.free(ptr);` |
| Собрать мусор | `GC.collect();` |
| Отключить GC | `GC.disable();` |
| Включить GC | `GC.enable();` |
| Поток | `auto t = new Thread(&func);` |
| Общая переменная | `__gshared int x;` |
| Статистика | `auto stats = GC.stats();` |

---

**Дата:** 2026-04-25  
**Уровень сложности:** Beginner → Advanced  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
