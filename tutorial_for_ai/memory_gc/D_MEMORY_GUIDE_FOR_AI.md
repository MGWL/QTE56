# 📚 Руководство по управлению памятью в языке D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_D_MEMORY_FOR_AI.md](README_D_MEMORY_FOR_AI.md)

**Язык:** D (D Programming Language)  
**Назначение:** Помощь AI (DeepSeek, Claude и др.) в генерации правильного кода с управлением памятью  
**Версия:** core.memory (dlang.org)  

---

## 🎯 Основные концепции

### Сборщик мусора (Garbage Collector - GC)

D использует **conservative mark-and-sweep garbage collector**:

```
✅ Плюсы:
- Автоматическое управление памятью (как Python, Java)
- Не нужно вручную delete большинство объектов
- Меньше segfaults от dangling pointers

⚠️ Минусы:
- Может быть pause time (GC стопает программу)
- Требует контроль в многопоточных приложениях
- Нельзя полагаться на точный момент удаления
```

### Два вида памяти в D

```d
// 1. GC-управляемая память (heap)
int[] arr = new int[100];        // ← Управляется GC
auto obj = new MyClass();        // ← Управляется GC

// 2. Stack память (автоматическая)
int x = 5;                       // ← В stack, удаляется при выходе из scope
int[10] arr_stack;               // ← Массив в stack

// 3. Статическая память
static int counter = 0;          // ← Существует всю программу
__gshared int shared_var;        // ← Общая между потоками
```

---

## 📝 Основные функции GC (core.memory)

### Импорт
```d
import core.memory : GC;
```

### 1. GC.malloc() — выделение памяти
```d
// Низкоуровневое выделение памяти
void* ptr = GC.malloc(1024);     // ← 1024 байта, управляется GC

// С атрибутами
void* ptr = GC.malloc(
    1024, 
    GC.BlkAttr.NO_SCAN           // ← Не сканировать на указатели
);
```

**Когда использовать:** Редко. Обычно лучше `new`.

---

### 2. GC.free() — явное освобождение
```d
void* ptr = GC.malloc(1024);
// ... использование ...
GC.free(ptr);                    // ← Явное удаление (опционально)
```

**Когда использовать:** При работе с low-level API, когда нужен контроль.

---

### 3. GC.collect() — запуск сборки мусора
```d
import core.memory : GC;

// ... много allocations ...

GC.collect();                    // ← Принудительно собрать мусор
```

**Когда использовать:**
- ✅ Перед критичной операцией (не хотим pause)
- ✅ При выходе из программы (очистить утечки)
- ❌ НЕ в цикле! Очень медленно

---

### 4. GC.disable() / GC.enable() — управление GC
```d
GC.disable();                    // ← GC НЕ будет работать
// ... критичный по времени код ...
GC.enable();                     // ← GC включен снова

// Проверка статуса
bool is_enabled = !GC.stats.usedSize;  // ← Примерная проверка
```

**Когда использовать:**
- ✅ Real-time код (игры, системное ПО)
- ✅ Многопоточные операции (избежать pause)
- ❌ Не забыть enable() после!

---

### 5. GC.minimize() — вернуть память ОС
```d
GC.collect();                    // Сначала собрать
GC.minimize();                   // Потом минимизировать
```

**Результат:** Освобожденная память возвращается операционной системе.

---

## ⚙️ Атрибуты памяти (GC.BlkAttr)

```d
enum BlkAttr : uint {
    NONE         = 0,           // Нет атрибутов
    FINALIZE     = 1,           // Вызвать destructor при удалении
    NO_SCAN      = 2,           // НЕ сканировать на указатели
    NO_MOVE      = 4,           // НЕ перемещать при compaction
    APPENDABLE   = 8,           // Можно append'ить к массиву
    NO_INTERIOR  = 16,          // Только base pointer (не interior)
}
```

### Примеры использования

#### NO_SCAN — быстрее для данных без указателей
```d
// Массив чисел — не содержит указателей
ubyte[] data = cast(ubyte[])GC.malloc(
    1000,
    GC.BlkAttr.NO_SCAN  // ← GC не будет сканировать
);
```

**Зачем:** GC не потратит время на поиск указателей в этом блоке.

#### NO_MOVE — для C interop
```d
// Передать указатель в C функцию
int* ptr = cast(int*)GC.malloc(
    sizeof(int),
    GC.BlkAttr.NO_MOVE  // ← Гарантирует что не переместится
);
c_function_expecting_fixed_pointer(ptr);
```

#### APPENDABLE — для динамических массивов
```d
int* pToArray = cast(int*)GC.malloc(
    10 * int.sizeof,
    GC.BlkAttr.APPENDABLE  // ← Можно расширять
);
int[] slice = pToArray[0 .. 0];
slice ~= 1;  // ← Append работает
```

---

## 🧵 Многопоточность и GC

### Проблема: GC не знает о пользовательских потоках
```d
import core.thread.osthread;

// Если создал поток напрямую через OS API:
// pthread_create(), CreateThread(), etc

// ❌ ОПАСНО: GC может не видеть ссылки!
// Решение: 1. Регистрировать поток
//          2. Или использовать GC.addRange()
```

### Правильный способ создания потока
```d
import core.thread : Thread;

void worker() {
    // Этот поток известен GC
    auto arr = new int[100];  // ✅ Безопасно
}

auto t = new Thread(&worker);
t.start();
```

### Если используешь C threads
```d
import core.memory : GC;

// Регистрировать свою переменную как root
__gshared int* shared_data;

void c_thread_main() {
    shared_data = new int;
    
    // Зарегистрировать для GC
    GC.addRoot(cast(void*)&shared_data);
    
    // ... работа ...
    
    GC.removeRoot(cast(void*)&shared_data);
}
```

---

## 🚨 Частые ошибки и как их избежать

### Ошибка 1: Забыть что GC асинхронный
```d
// ❌ НЕПРАВИЛЬНО:
class Resource {
    ~this() {  // destructor
        // GC вызовет это в неопределённый момент!
        close_file();  // ← Может быть после выхода из main
    }
}

// ✅ ПРАВИЛЬНО:
class Resource {
    bool is_closed = false;
    
    void close() {
        if (!is_closed) {
            close_file();
            is_closed = true;
        }
    }
    
    ~this() {
        close();  // Будет вызвано, но может быть поздно
    }
}

// Или используй RAII pattern:
void foo() {
    auto res = new Resource();
    try {
        // ... работа ...
    } finally {
        res.close();  // Гарантированный вызов
    }
}
```

### Ошибка 2: Хранить указатели как int/size_t
```d
// ❌ НЕПРАВИЛЬНО:
int ptr_as_int = cast(int)my_pointer;
// GC не видит что ты держишь указатель!

// ✅ ПРАВИЛЬНО:
void* ptr = my_pointer;
// или
int* ptr = my_pointer;
```

**Почему:** GC сканирует память и ищет значения которые выглядят как указатели. Если спрячешь указатель в int, GC не узнает.

### Ошибка 3: Обращение к памяти после GC.free()
```d
// ❌ ОПАСНО:
int* ptr = cast(int*)GC.malloc(sizeof(int));
*ptr = 42;
GC.free(ptr);
*ptr = 99;  // ← dangling pointer! UB

// ✅ ПРАВИЛЬНО:
int* ptr = cast(int*)GC.malloc(sizeof(int));
*ptr = 42;
GC.free(ptr);
ptr = null;  // Зануль указатель
```

### Ошибка 4: GC.collect() в цикле
```d
// ❌ ОЧЕНЬ МЕДЛЕННО:
for (int i = 0; i < 1000000; i++) {
    auto arr = new int[100];
    GC.collect();  // ← Каждый раз собирает мусор!
}

// ✅ ПРАВИЛЬНО:
for (int i = 0; i < 1000000; i++) {
    auto arr = new int[100];
    // GC сам решит когда собирать
}
if (should_cleanup) {
    GC.collect();  // Один раз в конце
}
```

### Ошибка 5: Забыть __gshared в многопоточности
```d
// ❌ ОПАСНО в многопоточности:
int* ptr;  // Обычная переменная

void thread1() { ptr = new int; }
void thread2() { *ptr = 42; }  // Race condition!

// ✅ ПРАВИЛЬНО:
__gshared int* ptr;  // Явно shared

// Но нужна синхронизация!
import core.sync.mutex;
__gshared Mutex mtx;

void thread1() { 
    synchronized(mtx) { 
        ptr = new int; 
    }
}
```

---

## 💡 Лучшие практики

### Правило 1: Предпочитай new вместо GC.malloc()
```d
// ❌ Low-level
void* ptr = GC.malloc(sizeof(MyClass));

// ✅ High-level (безопаснее)
auto obj = new MyClass();
```

### Правило 2: Используй scope для автоматического cleanup
```d
void process_file(string filename) {
    // Файл автоматически закроется при выходе
    auto file = File(filename);
    // ... работа с файлом ...
}  // ← file закрыт гарантированно
```

### Правило 3: Minimize при выходе
```d
void main() {
    try {
        // ... программа ...
    } finally {
        GC.collect();      // Собрать остаток
        GC.minimize();     // Вернуть ОС
    }
}
```

### Правило 4: Отключай GC если нужен контроль
```d
// Real-time код (игра, система)
void game_tick() {
    GC.disable();
    
    // ... критичный к времени код ...
    
    GC.enable();
}
```

### Правило 5: Явно управляй ресурсами
```d
class File {
    bool is_open;
    
    this(string name) { open(name); }
    
    void close() {
        if (is_open) {
            // ... закрыть файл ...
            is_open = false;
        }
    }
    
    ~this() { close(); }
}

// Использование
{
    auto f = new File("test.txt");
    // ... работа ...
} // ← f удален, файл закрыт
```

---

## 📊 Статистика GC (для отладки)

```d
import core.memory : GC;

void print_gc_stats() {
    GC.Stats stats = GC.stats();
    
    import std.stdio : writefln;
    writefln("GC Used: %d bytes", stats.usedSize);
    writefln("GC Free: %d bytes", stats.freeSize);
    writefln("Allocated in thread: %d bytes", 
             stats.allocatedInCurrentThread);
}
```

---

## 🔗 Инструкции для AI моделей

### Когда генерировать GC код:

1. **Выделение памяти:**
   - ✅ Обычно: `new Type()` или `new Type[size]`
   - ⚠️ Редко: `GC.malloc()` (только для low-level)

2. **Освобождение:**
   - ✅ Обычно: не нужно (GC сам)
   - ⚠️ Иногда: явный `GC.free()` если нужен контроль
   - ✅ Лучше: `scope` или try-finally

3. **Синхронизация:**
   - ✅ Потоки D: используй `Thread` класс
   - ⚠️ C потоки: регистрируй через `addRoot()`
   - ✅ Отключай GC если нужен real-time код

4. **Атрибуты памяти:**
   - ✅ NO_SCAN: для данных без указателей
   - ✅ NO_MOVE: для C interop
   - ✅ APPENDABLE: для динамических массивов

---

## 📚 Краткая шпаргалка

```d
import core.memory : GC;
import core.thread : Thread;

// Выделение
auto arr = new int[100];           // ← Стандартно
void* ptr = GC.malloc(1024);       // ← Low-level

// Управление GC
GC.collect();                       // Собрать
GC.minimize();                      // Минимизировать
GC.disable(); /* код */ GC.enable(); // Отключить

// Многопоточность
auto t = new Thread(&func);        // ✅ Правильно
t.start();

__gshared int* shared;             // Для общей переменной

// Атрибуты
GC.malloc(1024, GC.BlkAttr.NO_SCAN);

// Статистика
auto stats = GC.stats();
```

---

## ⚠️ Золотые правила

1. **Доверяй GC** — не нужно delete для большинства кода
2. **Будь осторожен с указателями** — кэширование опасно
3. **Многопоточность требует внимания** — используй Thread или регистрируй
4. **Real-time код** — отключай GC если нужен контроль
5. **Ресурсы** — используй scope/finally для гарантированного cleanup

---

**Дата:** 2026-04-25  
**Источник:** dlang.org/phobos/core/memory.html  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
