# 📚 Руководство по многопоточности (Concurrency) в D для генеративных моделей

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CONCURRENCY_FOR_AI.md](README_CONCURRENCY_FOR_AI.md)

**Язык:** D (D Programming Language)  
**Назначение:** Помощь AI (DeepSeek, Claude и др.) в генерации правильного кода для многопоточности  
**Версия:** std.concurrency (dlang.org)  

---

## 🎯 Основные концепции

### Что такое многопоточность в D

D предоставляет **message-passing** архитектуру для многопоточности:

```
✅ Плюсы:
- Потокобезопасное общение через сообщения (не race conditions)
- Логические потоки (могут быть kernel threads или fibers)
- Простой API для создания и управления потоками

⚠️ Особенности:
- Различные типы планировщиков (Scheduler)
- Асинхронное выполнение
- Требует понимания Message Passing
```

### Два вида потоков

```d
// 1. Kernel threads (по умолчанию)
auto tid = spawn(&workerFunc);  // Новый kernel thread

// 2. Fibers (cooperative, требует FiberScheduler)
spawn(&workerFunc);  // С настроенным планировщиком
```

### Модель Message-Passing

```
Основная идея:
1. Создай поток через spawn()
2. Отправляй сообщения через send()
3. Получай сообщения через receive()
4. НЕ используй общие переменные (исключи race conditions)
```

---

## 📝 Основные типы

### Tid — идентификатор потока

```d
// Получить текущий поток
Tid myId = thisTid;

// Получить Tid владельца (кто создал этот поток)
Tid owner = ownerTid;

// Создать новый поток
Tid child = spawn(&workerFunc, param1, param2);

// Спарить потоки (при смерти одного уведомить другого)
Tid linked = spawnLinked(&workerFunc);

// Найти поток по имени
Tid found = locate("worker_name");

// Зарегистрировать этот поток
register("worker_name", thisTid);

// Отменить регистрацию
unregister("worker_name");
```

---

## 📬 Отправка сообщений (send)

### Обычная отправка

```d
// Отправить одно значение
send(otherTid, 42);

// Отправить несколько значений
send(otherTid, "Hello", 3.14, true);

// Отправить объект
struct Message {
    string text;
    int count;
}
send(otherTid, Message("data", 10));
```

### Приоритетная отправка

```d
// Сообщение будет в начале очереди (prioritySend)
prioritySend(otherTid, "URGENT");  // Обработается первым
```

### Настройка очереди (Mailbox)

```d
// Установить максимум сообщений в очереди
setMaxMailboxSize(thisTid, 1000, OnCrowding.block);

// OnCrowding.block — жди освобождение очереди
// OnCrowding.ignore — игнорировать новые сообщения
// OnCrowding.throwException — выбросить исключение
```

---

## 📨 Получение сообщений (receive)

### receiveOnly — ожидание одного типа

```d
// Ждать int
int value = receiveOnly!int;

// Ждать struct
struct Msg { string text; }
Msg msg = receiveOnly!Msg;

// Ждать несколько типов (выберет первый)
auto result = receiveOnly!(int, string);

// С timeout
receive(
    (int i) { writeln("int: ", i); },
    (string s) { writeln("string: ", s); },
);
```

### receive — с обработчиками

```d
// Обработать разные типы сообщений
receive(
    (int i) { writeln("Получил число: ", i); },
    (string s) { writeln("Получил текст: ", s); },
    (double d) { writeln("Получил дробь: ", d); }
);
```

### receiveTimeout — с таймаутом

```d
import core.time : seconds;

// Ждать до 5 секунд
bool received = receiveTimeout(
    5.seconds,
    (int i) { writeln("Число: ", i); },
    (string s) { writeln("Текст: ", s); }
);

if (!received) {
    writeln("Timeout! Сообщений не пришло");
}
```

---

## 🔗 Связанные потоки (Linked threads)

### spawnLinked — потоки знают друг о друге

```d
// Создать связанный поток
auto child = spawnLinked(&childFunc);

// Если child умирает, owner получит LinkTerminated
receive(
    (LinkTerminated ex) { writeln("Child died"); }
);
```

### Типы исключений при связи

```d
// LinkTerminated — связанный поток завершился
// OwnerTerminated — владелец потока завершился
// MessageMismatch — неправильный тип сообщения
// MailboxFull — очередь переполнена
```

---

## ⚙️ Планировщики (Schedulers)

### ThreadScheduler (по умолчанию)

```d
// Каждый spawn создает новый kernel thread
auto tid = spawn(&func);  // Новый kernel thread
```

**Плюсы:** Простой, истинный параллелизм  
**Минусы:** Дорого по памяти (каждый thread — OS ресурс)

### FiberScheduler — cooperative потоки

```d
import std.concurrency : FiberScheduler;

void main() {
    // Переключить на FiberScheduler
    auto scheduler = new FiberScheduler();
    
    // Теперь spawn создает fibers вместо threads
    auto tid = spawn(&workerFunc);
}
```

**Плюсы:** Легкий, можно 100000+ fibers  
**Минусы:** Cooperative (один block блокирует все)

### Generator — для специальных случаев

```d
// Редко используется, для advanced сценариев
```

---

## 💡 Лучшие практики

### Правило 1: Используй message-passing вместо общих переменных

```d
// ❌ ПЛОХО: Race condition
__gshared int counter = 0;

void worker() {
    counter++;  // Race condition!
}

// ✅ ХОРОШО: Message passing
void worker(Tid owner) {
    send(owner, 1);  // Отправи результат
}

auto tid = spawn(&worker, thisTid);
int count = receiveOnly!int;
```

### Правило 2: Обрабатывай исключения при связанных потоках

```d
auto child = spawnLinked(&childFunc);

receive(
    (int result) { writeln("Success: ", result); },
    (LinkTerminated ex) { writeln("Child crashed!"); },
    (Throwable ex) { writeln("Error: ", ex.msg); }
);
```

### Правило 3: Используй receiveTimeout для таймаутов

```d
import core.time : seconds;

bool success = receiveTimeout(10.seconds,
    (int result) { writeln("Got: ", result); }
);

if (!success) {
    writeln("Timeout waiting for response");
}
```

### Правило 4: Регистрируй потоки если нужна динамическая адресация

```d
void namedWorker() {
    register("my_worker", thisTid);
    // Теперь можно найти: locate("my_worker")
}

auto tid = spawn(&namedWorker);
auto found = locate("my_worker");  // Найти по имени
```

### Правило 5: Выбери правильный планировщик

```d
// Для большого числа легких операций:
auto scheduler = new FiberScheduler();  // Fibers

// Для вычисления (CPU-bound):
spawn(&cpuBound);  // ThreadScheduler (по умолчанию)
```

---

## 🚨 Частые ошибки

### Ошибка 1: Забыть ownerTid при spawn

```d
// ❌ Неправильно: worker не знает кто его создал
void worker() {
    // Как ответить владельцу?
    send(???, result);
}

// ✅ Правильно: передай ownerTid
void worker(Tid owner) {
    send(owner, result);
}

auto tid = spawn(&worker, thisTid);
```

### Ошибка 2: receiveOnly с неправильным типом

```d
// ❌ Неправильно: ждем int, получим string
receiveOnly!int;  // MessageMismatch!

// ✅ Правильно: обработай разные типы
receive(
    (int i) { writeln(i); },
    (string s) { writeln(s); }
);
```

### Ошибка 3: Блокировать поток бесконечно

```d
// ❌ Неправильно: мертвая блокировка
void worker() {
    receive();  // Ждет бесконечно
}

// ✅ Правильно: используй receiveTimeout
auto success = receiveTimeout(5.seconds, (int i) { ... });
```

### Ошибка 4: Забыть обработать LinkTerminated

```d
// ❌ Неправильно: спарил потоки, но не обработал
auto child = spawnLinked(&childFunc);
// А что если child упадет?

// ✅ Правильно: обработай исключение
receive(
    (int result) { ... },
    (LinkTerminated ex) { writeln("Child died!"); }
);
```

### Ошибка 5: Использовать общие переменные

```d
// ❌ ОЧЕНЬ ПЛОХО: Race condition
__gshared int[] results;

void worker() {
    results ~= myResult;  // Race!
}

// ✅ Правильно: отправь сообщение
void worker(Tid owner) {
    send(owner, myResult);
}
```

---

## 📊 Шаблоны использования

### Паттерн 1: Worker Pool

```d
// Несколько worker потоков, один coordinator
foreach (i; 0 .. numWorkers) {
    spawn(&worker, thisTid, i);
}

// Отправить задачи workers
send(workerTid, task);

// Собрать результаты
foreach (i; 0 .. numTasks) {
    auto result = receiveOnly!TaskResult;
}
```

### Паттерн 2: Pipeline

```d
// Поток1 → Поток2 → Поток3
auto stage2 = spawn(&process2, thisTid);
auto stage3 = spawn(&process3, stage2);

send(stage1, initialData);
auto result = receiveOnly!Result;
```

### Паттерн 3: Broadcast

```d
// Отправить сообщение всем workers
foreach (tid; workerTids) {
    send(tid, broadcastMessage);
}
```

---

## 🔧 Необходимые импорты

```d
// Основное
import std.concurrency;

// Типы времени (для timeout)
import core.time : Duration, seconds, milliseconds;

// Потоки (если нужны fiber)
import core.thread : Fiber;

// Другое
import std.stdio : writeln;
```

---

## 📋 Контрольный список

### При написании многопоточного кода
- [ ] Используется `spawn` для создания потоков?
- [ ] Передается `thisTid` в worker функцию?
- [ ] Используется `send/receive` вместо общих переменных?
- [ ] Обработаны все типы сообщений?
- [ ] Есть timeout если это нужно?
- [ ] Связанные потоки обрабатывают `LinkTerminated`?

### При обработке сообщений
- [ ] Тип сообщения совпадает с send?
- [ ] Все возможные типы обработаны?
- [ ] Есть обработчик ошибок?
- [ ] receiveTimeout используется если нужен timeout?

### При использовании планировщиков
- [ ] Правильный планировщик выбран?
- [ ] FiberScheduler если много легких операций?
- [ ] ThreadScheduler если CPU-bound работа?

---

**Дата:** 2026-04-27  
**Источник:** dlang.org/phobos/std/concurrency.html  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
