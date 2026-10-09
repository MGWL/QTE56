# 🚀 Шпаргалка по памяти в D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_D_MEMORY_FOR_AI.md](README_D_MEMORY_FOR_AI.md)

**Для быстрого копирования в контекст/промпт**

---

## 📌 Золотые правила D памяти

```
1. GC управляет большинством памяти автоматически
2. new → выделить в heap (управляется GC)
3. int x = 5 → в stack (удаляется автоматически)
4. GC.free() → редко нужно (обычно GC сам)
5. Многопоточность → используй Thread класс
```

---

## ⚡ Самые частые конструкции

### Выделение памяти
```d
// Массив
int[] arr = new int[100];

// Объект
auto obj = new MyClass();

// Динамический массив (может расти)
int[] dynamic;
dynamic ~= 42;  // Append

// Двумерный
int[][] matrix = new int[][](10, 10);
```

### Освобождение
```d
// Обычно не нужно
int[] arr = new int[100];
// ... использование ...
// GC сам очистит при выходе из scope

// Если нужен контроль
GC.free(arr.ptr);
```

---

## 🔥 Самые частые ошибки → исправления

### Ошибка 1: Забыть new
```d
// ❌
int[] arr;
arr[0] = 42;  // Crash!

// ✅
int[] arr = new int[10];
arr[0] = 42;
```

### Ошибка 2: Вернуть локальный указатель
```d
// ❌
int* get_ptr() {
    int x = 42;
    return &x;  // Dangling!
}

// ✅
int get_val() {
    int x = 42;
    return x;
}
```

### Ошибка 3: Многопоточность без синхронизации
```d
// ❌
int* shared_ptr;  // Обычная переменная

void thread1() { shared_ptr = new int; }
void thread2() { *shared_ptr = 42; }  // Race!

// ✅
__gshared int* shared_ptr;  // Явно shared
import core.sync.mutex : Mutex;
__gshared Mutex mtx;

synchronized(mtx) {
    shared_ptr = new int;
}
```

### Ошибка 4: GC.collect() в цикле
```d
// ❌ МЕДЛЕННО
for (int i = 0; i < 1000000; i++) {
    auto arr = new int[100];
    GC.collect();  // Каждый раз!
}

// ✅ БЫСТРО
for (int i = 0; i < 1000000; i++) {
    auto arr = new int[100];
}
GC.collect();  // Один раз в конце
```

### Ошибка 5: Скрыть указатель в int
```d
// ❌ GC не видит
void* ptr = new int;
int hidden = cast(int)ptr;
// GC может удалить, hidden может быть мусор

// ✅ GC видит
void* ptr = new int;
// Или
int* ptr2 = new int;
```

---

## 🎯 Выбери правильный вариант

### Для выделения памяти
```d
// ✅ ОБЫЧНО (9 из 10 раз)
auto arr = new int[100];
auto obj = new MyClass();

// ⚠️ РЕДКО (low-level)
void* ptr = GC.malloc(1024);
```

### Для освобождения
```d
// ✅ ОБЫЧНО (не нужно делать)
{
    auto arr = new int[100];
    // GC сам очистит при выходе из {}
}

// ✅ ЕСЛИ НУЖЕН КОНТРОЛЬ
auto arr = new int[100];
// ... работа ...
GC.free(arr.ptr);

// ✅ ИЛИ ИСПОЛЬЗУЙ FINALLY
auto res = new Resource();
try {
    // работа
} finally {
    res.cleanup();
}
```

### Для многопоточности
```d
// ✅ ВСЕГДА ИСПОЛЬЗУЙ Thread
import core.thread : Thread;

void worker() { /* ... */ }
auto t = new Thread(&worker);
t.start();

// ❌ НЕ ИСПОЛЬЗУЙ C threads напрямую
// pthread_create(...);  // ← GC не знает!
```

### Для общих переменных между потоками
```d
// ✅ Общая переменная
__gshared int shared_var;

// ✅ + синхронизация
import core.sync.mutex : Mutex;
__gshared Mutex mtx;

synchronized(mtx) {
    shared_var = 42;
}

// ❌ НЕ ИСПОЛЬЗУЙ обычные переменные
// int x;  // ← Race condition!
```

---

## 🔧 Необходимые импорты

```d
// Основное управление памятью
import core.memory : GC;

// Многопоточность
import core.thread : Thread;
import core.sync.mutex : Mutex;

// Для проверки
import std.stdio : writeln;
```

---

## 📊 Контрольный список

### При написании кода
- [ ] Использовал `new` для выделения?
- [ ] Для многопоточности используется `Thread`?
- [ ] Общие переменные помечены `__gshared`?
- [ ] Используется синхронизация (`Mutex`, `synchronized`)?
- [ ] Не скрыл указатели в int/size_t?
- [ ] Не вызываю GC.collect() в цикле?

### При работе с памятью
- [ ] Проверил локальный scope переменных?
- [ ] Использовал try-finally для cleanup?
- [ ] Destructor правильно вызовет cleanup?
- [ ] Не обращаюсь к памяти после GC.free()?

### При многопоточности
- [ ] Создаю потоки через `new Thread`?
- [ ] Синхронизирую доступ к общим данным?
- [ ] Нет race conditions?
- [ ] Нет deadlock'ов?

---

## 🎓 Когда какие функции использовать

| Функция | Когда | Пример |
|---------|-------|--------|
| `new` | Выделить и управлять GC | `auto obj = new Class();` |
| `GC.malloc()` | Low-level, редко | `void* ptr = GC.malloc(1024);` |
| `GC.free()` | Если нужен контроль | `GC.free(ptr);` |
| `GC.collect()` | Перед критичным кодом | `GC.collect(); app.exec();` |
| `GC.disable()` | Real-time код | `GC.disable(); /*fast code*/ GC.enable();` |
| `GC.minimize()` | При выходе | `GC.collect(); GC.minimize();` |
| `GC.stats()` | Отладка | `auto s = GC.stats(); writeln(s.usedSize);` |

---

## 🛡️ Защита от проблем

### Если GC pause критична
```d
void main() {
    GC.disable();
    
    // Real-time код
    for (int i = 0; i < 1000000; i++) {
        process_frame();
    }
    
    GC.enable();
}
```

### Если нужен точный контроль памяти
```d
void main() {
    // Выделить
    int* ptr = cast(int*)GC.malloc(sizeof(int));
    *ptr = 42;
    
    // Использовать
    
    // Освободить явно
    GC.free(ptr);
    ptr = null;  // Обнулить для безопасности
}
```

### Если проблемы в многопоточности
```d
import core.sync.mutex : Mutex;

__gshared int* data;
__gshared Mutex mtx = new Mutex();

void modify_data(int value) {
    synchronized(mtx) {
        if (data is null) {
            data = new int;
        }
        *data = value;
    }
}
```

---

## 🚀 Быстрый старт

```d
import core.memory : GC;
import core.thread : Thread;
import std.stdio : writeln;

void main() {
    // Базовое выделение
    int[] arr = new int[10];
    
    // Использование
    for (int i = 0; i < 10; i++) {
        arr[i] = i * 2;
    }
    
    // Вывод
    foreach (x; arr) {
        writeln(x);
    }
    
    // Очистка (опционально, GC сам)
    GC.collect();
    
    // Готово!
}
```

---

## ❓ FAQ для AI

**Q: Нужно ли вызывать delete?**  
A: Нет. Используй `new`, GC сам управляет.

**Q: Когда использовать GC.malloc()?**  
A: Редко. Обычно `new` достаточно.

**Q: Как отладить утечку памяти?**  
A: `GC.stats()` для проверки. Используй try-finally для cleanup.

**Q: Многопоточность опасна?**  
A: Нужна синхронизация. Используй `__gshared` + `Mutex`.

**Q: GC может вызвать pause?**  
A: Да. `GC.disable()` для real-time, потом `enable()`.

**Q: Что такое interior pointer?**  
A: Указатель в середину блока памяти. GC поддерживает по умолчанию.

---

## 🔗 Ссылки на полные гайды

- `D_MEMORY_GUIDE_FOR_AI.md` — полное описание
- `D_MEMORY_EXAMPLES.md` — примеры кода
- `core_memory.html` — официальная документация dlang.org

---

**Версия:** 2026-04-25  
**Для использования:** DeepSeek, Claude, GPT, Qwen и др. генеративные модели  
**Язык:** D Programming Language

**Скопируй эту шпаргалку в контекст промпта перед просьбой писать код на D!**
