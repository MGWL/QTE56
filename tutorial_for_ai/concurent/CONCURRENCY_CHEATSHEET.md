# 🚀 Шпаргалка по многопоточности (Concurrency) в D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CONCURRENCY_FOR_AI.md](README_CONCURRENCY_FOR_AI.md)

**Для быстрого копирования в контекст/промпт**

---

## 📌 Золотые правила D многопоточности

```
1. spawn создает новый логический поток
2. send отправляет сообщение в mailbox потока
3. receive получает сообщение (блокирует на ждет)
4. thisTid — ID текущего потока
5. Всегда передавай ownerTid в worker функцию
```

---

## ⚡ Самые частые конструкции

### Создание потоков

```d
// Простой spawn
auto tid = spawn(&workerFunc);

// С параметрами
auto tid = spawn(&workerFunc, param1, param2);

// С передачей ownerTid
auto tid = spawn(&workerFunc, thisTid);

// Связанные потоки
auto tid = spawnLinked(&workerFunc);
```

### Отправка сообщений

```d
// Обычная отправка
send(tid, 42);
send(tid, "Hello");
send(tid, 3.14);

// Несколько значений за раз
send(tid, "msg", 100, true);

// Приоритетная отправка
prioritySend(tid, "URGENT");
```

### Получение сообщений

```d
// Одного типа
int value = receiveOnly!int;
string text = receiveOnly!string;

// Несколько типов
receive(
    (int i) { /* обработка int */ },
    (string s) { /* обработка string */ }
);

// С таймаутом
bool ok = receiveTimeout(5.seconds, 
    (int i) { /* обработка */ }
);
```

### Работа с именами

```d
// Зарегистрировать поток
register("my_service", thisTid);

// Найти по имени
auto tid = locate("my_service");

// Отменить регистрацию
unregister("my_service");
```

---

## 🔥 Самые частые ошибки → исправления

### Ошибка 1: Забыть ownerTid

```d
// ❌
void worker() {
    send(???, result);  // Кому отправить?
}

// ✅
void worker(Tid owner) {
    send(owner, result);
}

auto tid = spawn(&worker, thisTid);
```

### Ошибка 2: receiveOnly с неправильным типом

```d
// ❌ Ждем int, получим string
receiveOnly!int;  // MessageMismatch!

// ✅ Обработай разные типы
receive(
    (int i) { writeln(i); },
    (string s) { writeln(s); }
);
```

### Ошибка 3: Использовать общие переменные

```d
// ❌ ОЧЕНЬ ПЛОХО: Race condition
__gshared int[] results;

void worker() {
    results ~= value;  // Race!
}

// ✅ Message passing
void worker(Tid owner) {
    send(owner, value);
}
```

### Ошибка 4: Забыть обработать LinkTerminated

```d
// ❌ Неправильно
auto tid = spawnLinked(&workerFunc);

// ✅ Правильно: обработай исключение
receive(
    (int result) { /* работа */ },
    (LinkTerminated ex) { /* worker упал */ }
);
```

### Ошибка 5: Бесконечный receive без условия выхода

```d
// ❌ Может зависнуть
void worker() {
    while (true) {
        receive((int i) { /* обработка */ });
    }
    // Как выйти?
}

// ✅ С условием выхода
void worker() {
    bool done = false;
    while (!done) {
        receive(
            (int i) { /* работа */ },
            (bool stop) { done = stop; }
        );
    }
}
```

---

## 🎯 Выбери правильный вариант

### Для создания потоков

```d
// ✅ Обычный spawn
auto tid = spawn(&func, param);

// ✅ Для связанных потоков
auto tid = spawnLinked(&func);

// ⚠️ Редко: с FiberScheduler
auto scheduler = new FiberScheduler();
auto tid = spawn(&func);
```

### Для отправки

```d
// ✅ Обычно
send(tid, value);

// ⚠️ Срочное сообщение
prioritySend(tid, urgent);

// ✅ С контролем очереди
setMaxMailboxSize(thisTid, 1000, OnCrowding.block);
```

### Для получения

```d
// ✅ Одного типа
auto value = receiveOnly!int;

// ✅ Разных типов
receive((int i){...}, (string s){...});

// ✅ С таймаутом
receiveTimeout(5.seconds, (int i){...});
```

### Для обработки потоков

```d
// ✅ Обычные потоки
spawn(&func);

// ✅ Связанные потоки
spawnLinked(&func);

// ⚠️ Fibers для легких операций
FiberScheduler scheduler;
```

---

## 🔧 Необходимые импорты

```d
// Основное
import std.concurrency;

// Для timeout
import core.time : seconds, milliseconds, Duration;

// Потоки (если нужны fibers)
import core.thread : Fiber, Thread;

// Другое
import std.stdio : writeln;
```

---

## 📊 Контрольный список

### При написании многопоточного кода
- [ ] Используется `spawn` для создания потоков?
- [ ] Передается `thisTid` в worker функцию?
- [ ] Используется `send/receive` вместо общих переменных?
- [ ] Все типы сообщений обработаны?
- [ ] Есть timeout если нужен?
- [ ] Связанные потоки обработают `LinkTerminated`?

### При send/receive
- [ ] Тип сообщения совпадает между send и receive?
- [ ] Все возможные типы обработаны в receive?
- [ ] Есть обработчик ошибок?
- [ ] Правильно передано ownerTid?

### При использовании планировщиков
- [ ] Выбран правильный планировщик?
- [ ] FiberScheduler для легких операций?
- [ ] ThreadScheduler (по умолчанию) для CPU-bound?

---

## 🎓 Когда какие функции использовать

| Функция | Когда | Пример |
|---------|-------|--------|
| `spawn` | Создать поток | `auto tid = spawn(&func, thisTid)` |
| `spawnLinked` | Следить за потоком | `auto tid = spawnLinked(&func)` |
| `send` | Отправить сообщение | `send(tid, 42)` |
| `prioritySend` | Срочное сообщение | `prioritySend(tid, urgent)` |
| `receiveOnly` | Ждать одного типа | `int x = receiveOnly!int` |
| `receive` | Разные типы | `receive((int i){...})` |
| `receiveTimeout` | С таймаутом | `receiveTimeout(5.sec, ...)` |
| `register` | Назвать поток | `register("name", thisTid)` |
| `locate` | Найти поток | `auto tid = locate("name")` |
| `thisTid` | Текущий поток | `auto my_id = thisTid` |
| `ownerTid` | Кто создал этот | `auto owner = ownerTid` |

---

## 🛡️ Защита от проблем

### Если забыл обработать тип

```d
// ❌ MessageMismatch если придет другой тип
receiveOnly!int;

// ✅ Обработай все типы
receive(
    (int i) { writeln(i); },
    (string s) { writeln(s); }
);
```

### Если потенциальный таймаут

```d
// ❌ Может зависнуть
receive((int i) { ... });

// ✅ С таймаутом
bool ok = receiveTimeout(10.seconds,
    (int i) { ... }
);
if (!ok) writeln("Timeout");
```

### Если связанные потоки

```d
// ❌ Не обработал крах worker
auto tid = spawnLinked(&workerFunc);

// ✅ Обработай LinkTerminated
receive(
    (int result) { ... },
    (LinkTerminated ex) { writeln("Worker dead"); }
);
```

### Если общие переменные нужны

```d
// ❌ Race condition
__gshared int[] data;
data ~= value;

// ✅ Message passing
send(coordinatorTid, value);
```

---

## 🚀 Быстрый старт

```d
import std.concurrency;
import std.stdio : writeln;

void worker(Tid owner) {
    int x = receiveOnly!int;
    send(owner, x * 2);
}

void main() {
    // Создать поток
    auto tid = spawn(&worker, thisTid);
    
    // Отправить число
    send(tid, 21);
    
    // Получить результат
    int result = receiveOnly!int;
    writeln(result);  // 42
}
```

---

## ❓ FAQ для AI

**Q: Нужно ли join() для потоков?**  
A: Нет. D потоки завершаются сами. Используй receive() для ждания.

**Q: Можно ли использовать __gshared?**  
A: Нет, используй send/receive вместо этого. Это избегает race conditions.

**Q: Сколько потоков я могу создать?**  
A: С ThreadScheduler (kernel threads) — обычно 100-1000. С FiberScheduler — 100000+.

**Q: Что если worker упадет?**  
A: С spawnLinked получишь LinkTerminated исключение. Обработай его в receive.

**Q: Как отправить разные типы?**  
A: send(tid, "text", 42, true); Потом обработай в receive.

**Q: Нужен ли ownerTid?**  
A: Да, если worker должен ответить. Передай thisTid в spawn.

---

## 🔗 Ссылки на полные гайды

- `CONCURRENCY_GUIDE_FOR_AI.md` — полное описание всех функций
- `CONCURRENCY_EXAMPLES.md` — 12 рабочих примеров
- dlang.org/phobos/std/concurrency.html — официальная документация

---

**Версия:** 2026-04-27  
**Для использования:** DeepSeek, Claude, GPT, Qwen и др. генеративные модели  
**Язык:** D Programming Language

**Скопируй эту шпаргалку в контекст промпта перед просьбой писать многопоточный код на D!**
