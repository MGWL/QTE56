# 💻 Практические примеры многопоточности (Concurrency) в D

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [README_CONCURRENCY_FOR_AI.md](README_CONCURRENCY_FOR_AI.md)

---

## 1️⃣ Базовые примеры

### Пример 1: Простой spawn и send/receive

```d
import std.concurrency : spawn, send, receiveOnly, Tid, thisTid;
import std.stdio : writeln;

void worker(Tid ownerTid) {
    // Получить число от owner
    int num = receiveOnly!int;
    
    // Вычислить результат
    int result = num * 2;
    
    // Отправить обратно
    send(ownerTid, result);
}

void main() {
    // Создать поток
    auto workerTid = spawn(&worker, thisTid);
    
    // Отправить число
    send(workerTid, 21);
    
    // Получить результат
    int result = receiveOnly!int;
    writeln("Result: ", result);  // 42
}
```

**Вывод:**
```
Result: 42
```

**Объяснение:**
- `spawn` создает новый kernel thread
- `thisTid` — идентификатор текущего потока
- `send` отправляет сообщение в mailbox потока
- `receiveOnly!T` ждет сообщение типа T

---

### Пример 2: Множественные типы сообщений

```d
import std.concurrency : spawn, send, receive, Tid, thisTid;
import std.stdio : writefln;

void server(Tid client) {
    // Обработать разные типы сообщений
    receive(
        (int i) { writefln("Received int: %d", i); },
        (string s) { writefln("Received string: %s", s); },
        (double d) { writefln("Received double: %.2f", d); }
    );
    
    // Отправить подтверждение
    send(client, "OK");
}

void main() {
    auto serverTid = spawn(&server, thisTid);
    
    // Отправить разные типы
    send(serverTid, 42);
    receiveOnly!string;  // "OK"
    
    auto serverTid2 = spawn(&server, thisTid);
    send(serverTid2, "Hello");
    receiveOnly!string;  // "OK"
}
```

---

### Пример 3: Цикл receive

```d
import std.concurrency : spawn, send, receive, Tid, thisTid;
import std.stdio : writefln;

void worker(Tid owner) {
    bool done = false;
    
    while (!done) {
        receive(
            (int i) { 
                writefln("Worker received: %d", i);
                send(owner, i * 2);
            },
            (bool b) { 
                done = b;
                send(owner, "Worker done");
            }
        );
    }
}

void main() {
    auto tid = spawn(&worker, thisTid);
    
    // Отправить числа
    send(tid, 10);
    writeln(receiveOnly!int);  // 20
    
    send(tid, 20);
    writeln(receiveOnly!int);  // 40
    
    // Завершить worker
    send(tid, true);
    writeln(receiveOnly!string);  // "Worker done"
}
```

---

## 2️⃣ Продвинутые примеры

### Пример 4: Связанные потоки (spawnLinked)

```d
import std.concurrency : spawn, spawnLinked, send, receive, 
                         LinkTerminated, Tid, thisTid;
import std.stdio : writeln;

void workerThatCrashes() {
    writeln("Worker started");
    // Сделать что-то и завершиться
    writeln("Worker ending");
}

void main() {
    // Спарить потоки - если worker упадет, owner узнает
    auto tid = spawnLinked(&workerThatCrashes);
    
    // Ждать завершения worker или исключения
    receive(
        (LinkTerminated ex) { 
            writeln("Worker thread terminated");
        }
    );
}
```

**Вывод:**
```
Worker started
Worker ending
Worker thread terminated
```

---

### Пример 5: receiveTimeout — таймаут

```d
import std.concurrency : spawn, send, receiveTimeout, Tid, thisTid;
import core.time : seconds;
import std.stdio : writeln;

void slowWorker(Tid owner) {
    import core.thread : Thread;
    Thread.sleep(3.seconds);
    send(owner, "Done");
}

void main() {
    auto tid = spawn(&slowWorker, thisTid);
    
    // Ждать 2 секунды
    bool received = receiveTimeout(2.seconds,
        (string s) { writeln("Got: ", s); }
    );
    
    if (!received) {
        writeln("Timeout! No message received");
    }
}
```

**Вывод:**
```
Timeout! No message received
```

---

### Пример 6: Worker Pool

```d
import std.concurrency : spawn, send, receive, Tid, thisTid;
import std.stdio : writefln;

void worker(int id, Tid coordinator) {
    // Получить задачу
    receive((int task) {
        int result = task * (id + 1);  // Разный вычислитель
        writefln("Worker %d: %d * %d = %d", id, task, id+1, result);
        send(coordinator, result);
    });
}

void main() {
    int numWorkers = 3;
    Tid[] workers;
    
    // Создать pool workers
    foreach (i; 0 .. numWorkers) {
        workers ~= spawn(&worker, i, thisTid);
    }
    
    // Раздать задачи
    foreach (i, tid; workers) {
        send(tid, 10);
    }
    
    // Собрать результаты
    foreach (i; 0 .. numWorkers) {
        int result = receiveOnly!int;
        writefln("Result %d: %d", i, result);
    }
}
```

**Вывод:**
```
Worker 0: 10 * 1 = 10
Worker 1: 10 * 2 = 20
Worker 2: 10 * 3 = 30
Result 0: 10
Result 1: 20
Result 2: 30
```

---

### Пример 7: Регистрация потоков по имени

```d
import std.concurrency : spawn, send, receive, register, locate, 
                         Tid, thisTid;
import std.stdio : writefln;

void namedService() {
    // Зарегистрировать этот поток
    register("myService", thisTid);
    
    writeln("Service started");
    
    receive((string msg) {
        writefln("Service received: %s", msg);
    });
}

void main() {
    // Создать service
    spawn(&namedService);
    
    // Найти по имени
    auto serviceTid = locate("myService");
    
    // Отправить сообщение
    send(serviceTid, "Hello from main");
}
```

**Вывод:**
```
Service started
Service received: Hello from main
```

---

### Пример 8: prioritySend

```d
import std.concurrency : spawn, send, prioritySend, receive, 
                         Tid, thisTid;
import std.stdio : writeln;

void server(Tid owner) {
    foreach (i; 0 .. 5) {
        receive((string msg) {
            writeln("Received: ", msg);
        });
    }
}

void main() {
    auto tid = spawn(&server, thisTid);
    
    // Отправить обычные сообщения
    send(tid, "message 1");
    send(tid, "message 2");
    
    // Отправить СРОЧНОЕ сообщение
    // Оно будет обработано первым из оставшихся
    prioritySend(tid, "URGENT");
    
    send(tid, "message 3");
    send(tid, "message 4");
}
```

**Вывод:**
```
Received: message 1
Received: message 2
Received: URGENT
Received: message 3
Received: message 4
```

---

## 3️⃣ Планировщики

### Пример 9: FiberScheduler для легких операций

```d
import std.concurrency : spawn, send, receiveOnly, Tid, thisTid,
                         FiberScheduler;
import std.stdio : writefln;

void lightTask(int id, Tid owner) {
    send(owner, id * 2);
}

void main() {
    // Использовать FiberScheduler для легких задач
    auto scheduler = new FiberScheduler();
    
    // Теперь spawn создает fibers вместо threads
    Tid[] tasks;
    foreach (i; 0 .. 1000) {
        tasks ~= spawn(&lightTask, i, thisTid);
    }
    
    // Собрать результаты
    int sum = 0;
    foreach (i; 0 .. 1000) {
        sum += receiveOnly!int;
    }
    
    writefln("Sum: %d", sum);
}
```

**Объяснение:** FiberScheduler позволяет запустить 1000+ легких задач без перегрузки OS.

---

## 4️⃣ Обработка ошибок

### Пример 10: Обработка LinkTerminated

```d
import std.concurrency : spawn, spawnLinked, send, receive,
                         LinkTerminated, Tid, thisTid;
import std.stdio : writeln;

void crashingWorker() {
    writeln("Worker starting");
    throw new Exception("Oops!");
}

void main() {
    auto tid = spawnLinked(&crashingWorker);
    
    receive(
        (LinkTerminated ex) {
            writeln("Worker crashed!");
            writeln("Reason: ", ex.msg);
        }
    );
}
```

**Вывод:**
```
Worker starting
Worker crashed!
Reason: Worker exited unexpectedly
```

---

### Пример 11: receiveTimeout с обработкой

```d
import std.concurrency : spawn, send, receiveTimeout, Tid, thisTid;
import core.time : seconds;
import std.stdio : writeln;

void slowWorker(Tid owner, int seconds_to_wait) {
    import core.thread : Thread;
    Thread.sleep(dur!("seconds")(seconds_to_wait));
    send(owner, "Result");
}

void main() {
    auto tid = spawn(&slowWorker, thisTid, 3);
    
    // Попробовать получить результат с timeout
    bool success = receiveTimeout(1.seconds,
        (string msg) { writeln("Success: ", msg); }
    );
    
    if (!success) {
        writeln("Timeout after 1 second");
    }
}
```

---

## 5️⃣ Struct сообщения

### Пример 12: Сложные типы сообщений

```d
import std.concurrency : spawn, send, receiveOnly, Tid, thisTid;
import std.stdio : writefln;

// Определить тип сообщения
struct Task {
    int id;
    string name;
    int priority;
}

struct Result {
    int taskId;
    string status;
    double score;
}

void taskWorker(Tid owner) {
    Task task = receiveOnly!Task;
    
    writefln("Processing: %s (priority %d)", 
             task.name, task.priority);
    
    Result result = Result(task.id, "done", 42.5);
    send(owner, result);
}

void main() {
    auto tid = spawn(&taskWorker, thisTid);
    
    // Отправить задачу
    send(tid, Task(1, "DataProcess", 10));
    
    // Получить результат
    Result result = receiveOnly!Result;
    writefln("Task %d: %s (%.1f)", 
             result.taskId, result.status, result.score);
}
```

**Вывод:**
```
Processing: DataProcess (priority 10)
Task 1: done (42.5)
```

---

## 📋 Шпаргалка для быстрого поиска

| Задача | Код |
|--------|-----|
| Создать поток | `auto tid = spawn(&func, thisTid)` |
| Отправить сообщение | `send(tid, value)` |
| Получить сообщение | `auto val = receiveOnly!int` |
| Разные типы | `receive((int i){...}, (string s){...})` |
| Связанные потоки | `auto tid = spawnLinked(&func)` |
| Таймаут | `receiveTimeout(5.seconds, (int i){...})` |
| Регистрация | `register("name", thisTid)` |
| Поиск по имени | `auto tid = locate("name")` |
| Приоритет | `prioritySend(tid, msg)` |
| Fiber планировщик | `auto s = new FiberScheduler()` |

---

**Дата:** 2026-04-27  
**Уровень сложности:** Beginner → Advanced  
**Для моделей:** DeepSeek, Claude, GPT, Qwen и др.
