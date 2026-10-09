# Многопоточность в QTE56: core.thread + QTimer

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [AI_CORE.md](../AI_CORE.md)

## Содержание

1. [Главное правило](#1-главное-правило)
2. [Архитектура паттерна](#2-архитектура-паттерна)
3. [QTimer: точная механика подключения](#3-qtimer-точная-механика-подключения)
4. [core.thread: запуск фоновой задачи](#4-corethread-запуск-фоновой-задачи)
5. [Передача данных между потоками](#5-передача-данных-между-потоками)
6. [Полный пример: прогресс-бар](#6-полный-пример-прогресс-бар)
7. [Паттерн отмены задачи](#7-паттерн-отмены-задачи)
8. [Несколько задач параллельно](#8-несколько-задач-параллельно)
9. [Работа с GC](#9-работа-с-gc)
10. [Типичные ошибки](#10-типичные-ошибки)

---

## 1. Главное правило

**Qt GUI можно трогать только из главного потока.**

Это жёсткое ограничение Qt, не QTE56. Нарушение — крэш, артефакты, зависание.

```
  ┌─────────────────────────┐      ┌────────────────────────┐
  │   Главный поток (Qt)    │      │   Фоновый поток (D)    │
  │                         │      │                         │
  │  QApplication.exec()    │      │  Вычисления             │
  │  QTimer.timeout         │      │  Файлы, БД, сеть        │
  │  Обновление виджетов    │      │  Любой D-код            │
  │  Обработка событий      │      │                         │
  │                         │◄─────│  atomicStore(result)    │
  │  (только здесь!)        │      │  atomicStore(done,true) │
  └─────────────────────────┘      └────────────────────────┘
         ▲
    QTimer каждые N мс
    проверяет done-флаг
    и обновляет GUI
```

---

## 2. Архитектура паттерна

Три компонента:

| Компонент | Роль | Поток |
|-----------|------|-------|
| `core.thread.Thread` | выполняет алгоритм | фоновый |
| `shared` переменные + атомики | передают данные | оба |
| `QTimer` + ESlot | опрашивает готовность, обновляет GUI | главный |

Никакого прямого взаимодействия потоков с виджетами нет.

---

## 3. QTimer: точная механика подключения

QTimer в QTE56 использует паттерн **ESlot** (не lambda). Важно знать точную
сигнатуру и правила хранения объектов.

### 3.1 Сигнатура callback

```d
// ОБЯЗАТЕЛЬНО: extern(C) + void* dthis как первый параметр
extern(C) static void onTick(void* dthis) {
    // вызывается в главном потоке каждые N мс
    // dthis == null если не передавался при set()
}
```

### 3.2 Подключение

```d
// 1. Создать таймер (parent = окно или null)
auto timer = new QTimer(win.getWH());
timer.setInterval(100);           // интервал в миллисекундах

// 2. Создать ESlot — Qt-объект-посредник
//    parent=timer.getWH() → таймер удалит ESlot вместе с собой
auto sl = new ESlot(timer.getWH());
sl.set(cast(void*)&onTick);       // зарегистрировать callback

// 3. Соединить сигнал timeout() со слотом
timer.connect_timeout(sl);

// 4. Запустить
timer.start();
// или: timer.start(200); — задать интервал и сразу стартовать
```

### 3.3 Хранение объектов — критичный момент

**ESlot, QTimer и данные, к которым обращается callback, должны жить всё
время работы таймера.** GC не знает о Qt-ссылках и может собрать объект.

```d
// НЕПРАВИЛЬНО — GC может удалить sl после выхода из main()
void setupTimer() {
    auto sl = new ESlot(timer.getWH());  // локальная переменная!
    sl.set(cast(void*)&onTick);
    timer.connect_timeout(sl);
}  // ← sl может быть собран GC

// ПРАВИЛЬНО — хранить в __gshared или в long-lived объекте
__gshared ESlot[] g_slots;   // массив для предотвращения GC

void setupTimer() {
    auto sl = new ESlot(timer.getWH());
    sl.set(cast(void*)&onTick);
    timer.connect_timeout(sl);
    g_slots ~= sl;           // ← GC теперь видит ссылку
}
```

### 3.4 Остановка таймера

```d
timer.stop();           // пауза (можно снова start())
// или при закрытии окна таймер удалится автоматически
// если создан с parent=win.getWH()
```

---

## 4. core.thread: запуск фоновой задачи

### 4.1 Минимальный пример

```d
import core.thread : Thread;

auto t = new Thread({
    // Здесь — фоновая работа.
    // GUI НЕ трогать.
    import core.thread : Thread;
    Thread.sleep(dur!"seconds"(2));   // имитация работы
});
t.isDaemon = true;   // поток не блокирует завершение программы
t.start();
```

### 4.2 Использование делегата с захватом переменных

```d
string filePath = "big_file.dat";
auto t = new Thread({
    // filePath захвачена замыканием
    ubyte[] data = readFile(filePath);   // D std.file
    // ... обработка
});
t.start();
```

**Внимание:** захваченные переменные должны оставаться живыми до конца
потока. Лучше передавать через `__gshared` или struct-параметр.

### 4.3 Ожидание завершения (блокирующее)

```d
t.start();
t.join();    // главный поток ждёт — GUI заморожен!
// Использовать ТОЛЬКО если нет event loop (консольное приложение)
```

Для GUI никогда не вызывайте `join()` в главном потоке — это заморозит
интерфейс. Вместо этого используйте QTimer для опроса готовности.

---

## 5. Передача данных между потоками

### 5.1 Простые значения — core.atomic

```d
import core.atomic : atomicStore, atomicLoad, cas;

// Объявление в модульном уровне (не в функции)
__gshared bool   g_done     = false;
__gshared int    g_progress = 0;     // 0..100
__gshared string g_result   = "";
__gshared string g_error    = "";

// В фоновом потоке:
atomicStore(g_progress, 42);
atomicStore(g_result, computedValue);
atomicStore(g_done, true);           // ← последним!

// В главном потоке (callback QTimer):
if (atomicLoad(g_done)) {
    int pct = atomicLoad(g_progress);
    string res = atomicLoad(g_result);
    progressBar.setValue(pct);
    label.setText(res);
}
```

**Правило «последним — флаг готовности»:** всегда записывайте `g_done=true`
после того, как записаны все данные. Иначе main thread прочитает
незаполненный результат.

### 5.2 Сложные структуры — synchronized

```d
import core.sync.mutex : Mutex;

struct WorkResult {
    int    count;
    string[] lines;
    bool   ok;
}

__gshared Mutex      g_mutex;
__gshared WorkResult g_workResult;
__gshared bool       g_ready = false;

// Инициализация (один раз):
g_mutex = new Mutex();

// В фоновом потоке:
auto res = WorkResult(100, ["line1","line2"], true);
synchronized(g_mutex) {
    g_workResult = res;
    g_ready = true;
}

// В главном потоке (QTimer callback):
bool ready;
WorkResult r;
synchronized(g_mutex) {
    ready = g_ready;
    if (ready) { r = g_workResult; g_ready = false; }
}
if (ready) {
    label.setText(r.lines[0]);
}
```

### 5.3 Очередь результатов (несколько сообщений)

```d
import core.sync.mutex : Mutex;

__gshared Mutex    g_qMutex;
__gshared string[] g_logQueue;   // фон пишет, main читает

// В фоновом потоке:
void postLog(string msg) {
    synchronized(g_qMutex) { g_logQueue ~= msg; }
}

// В QTimer callback (главный поток):
string[] msgs;
synchronized(g_qMutex) {
    msgs = g_logQueue.dup;
    g_logQueue.length = 0;
}
foreach (m; msgs) logWidget.addItem(m);
```

---

## 6. Полный пример: прогресс-бар

Реальный паттерн: кнопка запускает задачу, прогресс-бар обновляется,
кнопка блокируется на время работы, результат показывается в метке.

```d
module example_progress;

import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qlabel;
import gen_qpushbutton;
import gen_qprogressbar;
import gen_qtimer;
import gen_qlayout;

import core.thread : Thread;
import core.atomic : atomicStore, atomicLoad;
import std.conv    : to;

// ── Разделяемое состояние ────────────────────────────────────────────────────

__gshared bool   g_running  = false;  // задача активна
__gshared bool   g_done     = false;  // задача завершена
__gshared int    g_progress = 0;      // 0..100
__gshared string g_result   = "";
__gshared string g_error    = "";

// ── Ссылки на виджеты (для callback) ────────────────────────────────────────

__gshared QProgressBar g_bar;
__gshared QLabel       g_label;
__gshared QPushButton  g_btnStart;
__gshared QTimer       g_timer;
__gshared ESlot[]      g_slots;

// ── Фоновая задача ───────────────────────────────────────────────────────────

void heavyTask() {
    import core.thread : Thread, dur;
    try {
        for (int i = 0; i <= 100; i += 5) {
            if (!atomicLoad(g_running)) return;  // проверка отмены

            // ... реальная работа ...
            Thread.sleep(dur!"msecs"(80));

            atomicStore(g_progress, i);
        }
        atomicStore(g_result, "Готово: обработано 100 записей");
    } catch (Exception e) {
        atomicStore(g_error, e.msg);
    }
    atomicStore(g_done, true);  // ← последним!
}

// ── QTimer callback (главный поток, каждые 50 мс) ────────────────────────────

extern(C) static void onPollTimer(void* dthis) {
    if (!atomicLoad(g_running)) return;

    // Обновить прогресс
    int pct = atomicLoad(g_progress);
    g_bar.setValue(pct);

    // Проверить завершение
    if (atomicLoad(g_done)) {
        atomicStore(g_running, false);
        atomicStore(g_done,    false);
        g_timer.stop();

        string err = atomicLoad(g_error);
        if (err.length > 0) {
            g_label.setText("Ошибка: " ~ err);
            atomicStore(g_error, "");
        } else {
            g_label.setText(atomicLoad(g_result));
        }
        g_btnStart.setEnabled(true);
    }
}

// ── Кнопка "Старт" ───────────────────────────────────────────────────────────

extern(C) static void onStart(void* dthis) {
    if (atomicLoad(g_running)) return;  // уже запущено

    // Сбросить состояние
    atomicStore(g_progress, 0);
    atomicStore(g_done,     false);
    atomicStore(g_result,   "");
    atomicStore(g_error,    "");
    atomicStore(g_running,  true);

    g_bar.setValue(0);
    g_label.setText("Выполняется...");
    g_btnStart.setEnabled(false);

    // Запустить фоновый поток
    auto t = new Thread(&heavyTask);
    t.isDaemon = true;
    t.start();

    // Запустить опрос
    g_timer.start();
}

// ── main ─────────────────────────────────────────────────────────────────────

void main() {
    LoadQt("./dll");
    auto app = new QApplication("progress_example");

    auto win  = new QWidget(null);
    win.setWindowTitle("Прогресс-бар");
    win.resize(400, 150);

    auto layout = new QVBoxLayout();

    g_bar      = new QProgressBar(win.getWH());
    g_bar.setRange(0, 100);
    layout.addWidget(g_bar.getWH());

    g_label    = new QLabel("Нажмите Старт", win.getWH());
    layout.addWidget(g_label.getWH());

    g_btnStart = new QPushButton(win.getWH());
    g_btnStart.setText("Старт");
    layout.addWidget(g_btnStart.getWH());

    win.setLayout(layout.getWH());
    layout.disown();

    // Кнопка → onStart
    auto slStart = new ESlot(g_btnStart.getWH());
    slStart.set(cast(void*)&onStart);
    g_btnStart.connect_clicked(slStart);
    g_slots ~= slStart;

    // Таймер (50 мс, не запущен — запускается при старте задачи)
    g_timer = new QTimer(win.getWH());
    g_timer.setInterval(50);
    auto slTimer = new ESlot(g_timer.getWH());
    slTimer.set(cast(void*)&onPollTimer);
    g_timer.connect_timeout(slTimer);
    g_slots ~= slTimer;

    win.show();
    app.exec();
    app.deleteApp();
    // UnloadQt() — НЕ вызывать: OS сама выгрузит DLL при выходе процесса
}
```

---

## 7. Паттерн отмены задачи

Добавьте кнопку «Отмена»: фоновый поток периодически проверяет флаг.

```d
__gshared bool g_cancel = false;

// В фоновом потоке — проверка в цикле:
for (int i = 0; i < total; i++) {
    if (atomicLoad(g_cancel)) {
        atomicStore(g_result, "Отменено");
        atomicStore(g_done, true);
        return;
    }
    // ... шаг алгоритма ...
    atomicStore(g_progress, i * 100 / total);
}

// Callback кнопки "Отмена":
extern(C) static void onCancel(void* dthis) {
    atomicStore(g_cancel, true);
    // GUI обновится сам в следующем тике таймера
}
```

**Частота проверки:** раз в итерацию цикла нормально. Не нужно проверять
каждую инструкцию — `atomicLoad` быстрая операция, но лишняя нагрузка
в очень тесных циклах нежелательна.

---

## 8. Несколько задач параллельно

```d
import std.parallelism : taskPool, task;
import core.sync.mutex : Mutex;
import core.atomic      : atomicStore, atomicLoad;

__gshared Mutex    g_resMutex;
__gshared string[] g_results;
__gshared int      g_doneCount = 0;
__gshared int      g_totalJobs = 0;

void runParallel(string[] items) {
    g_resMutex  = new Mutex();
    g_results   = new string[items.length];
    g_doneCount = 0;
    g_totalJobs = cast(int)items.length;
    atomicStore(g_running, true);
    g_timer.start();

    // Запустить все задачи в пуле потоков
    foreach (i, item; items) {
        auto idx   = i;
        auto input = item;
        taskPool.put(task({
            string res = processItem(input);   // D-алгоритм
            synchronized(g_resMutex) {
                g_results[idx] = res;
                g_doneCount++;                 // атомарно через synchronized
            }
        }));
    }
}

// В QTimer callback:
extern(C) static void onPollParallel(void* dthis) {
    int done, total;
    synchronized(g_resMutex) {
        done  = g_doneCount;
        total = g_totalJobs;
    }
    g_bar.setValue(done * 100 / (total > 0 ? total : 1));
    if (done == total && total > 0) {
        g_timer.stop();
        atomicStore(g_running, false);
        g_label.setText("Завершено: " ~ done.to!string ~ " задач");
        // g_results[] готов к использованию
    }
}
```

---

## 9. Работа с GC

### 9.1 Потоки, созданные через `new Thread()`, видны GC

```d
// Нормально: GC знает об этом потоке, D-объекты безопасны
auto t = new Thread({ /* D-код */ });
t.start();
```

### 9.2 Если поток создан не D (например, Qt-internal)

Если по какой-то причине Qt создаёт поток и вызывает D-callback:

```d
import core.thread : thread_attachThis, thread_detachThis;

extern(C) void qtCallback(void* data) {
    thread_attachThis();        // зарегистрировать в GC
    scope(exit) thread_detachThis();

    // теперь D-объекты безопасны
}
```

### 9.3 Не запускать GC из фонового потока явно

```d
// В фоновом потоке избегайте:
import core.memory : GC;
GC.collect();   // может конфликтовать с главным потоком
```

### 9.4 Длинные вычисления и паузы GC

Если фоновый поток выделяет много памяти, GC может делать stop-the-world
паузы, которые заметны в GUI. Решение:

```d
// Вариант 1: аллоцировать буферы заранее, вне цикла
auto buf = new ubyte[1024 * 1024];   // один раз
for (...) {
    // работать с buf[], не создавать новые объекты
}

// Вариант 2: отключить GC на критическом участке
import core.memory : GC;
GC.disable();
scope(exit) GC.enable();
// ... плотный вычислительный цикл ...
```

---

## 10. Типичные ошибки

### ❌ Вызов GUI из фонового потока

```d
auto t = new Thread({
    label.setText("готово");   // КРЭШ — нельзя!
});
```

**Правильно:** записать в `g_result`, QTimer обновит метку.

### ❌ ESlot без сохранения ссылки

```d
void setup() {
    auto sl = new ESlot(timer.getWH());
    sl.set(cast(void*)&cb);
    timer.connect_timeout(sl);
}   // sl собирается GC — таймер перестаёт работать
```

**Правильно:** `g_slots ~= sl;`

### ❌ join() в главном потоке

```d
t.start();
t.join();   // GUI заморожен на всё время задачи
```

**Правильно:** QTimer + флаг `g_done`.

### ❌ Запись данных ПОСЛЕ установки флага done

```d
// Фоновый поток:
atomicStore(g_done, true);    // ← РАНО!
atomicStore(g_result, data);  // main thread уже читает пустую строку
```

**Правильно:** сначала данные, потом `g_done = true`.

### ❌ Слишком короткий интервал таймера

```d
timer.setInterval(1);   // 1 мс — перегружает GUI thread
```

**Нормально:** 50–200 мс для прогресс-бара, 16 мс только для анимации.

### ❌ Callback не является extern(C)

```d
static void onTick(void* dthis) { ... }           // D calling convention!
extern(C) static void onTick(void* dthis) { ... } // ПРАВИЛЬНО
```

Qt вызывает callback через C ABI. Без `extern(C)` — неопределённое поведение.

---

## Краткий чеклист

```
□ GUI — только в главном потоке
□ extern(C) у всех ESlot callback-ов
□ Сначала записываем данные, потом g_done = true
□ ESlot и QTimer хранятся в __gshared (не локальные переменные)
□ t.isDaemon = true для фоновых потоков
□ Никогда не вызывать join() в главном потоке при активном event loop
□ QTimer.setInterval(50..200) — нормальный диапазон для опроса
```
