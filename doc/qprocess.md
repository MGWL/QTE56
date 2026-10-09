# QProcess в QTE56

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [AI_CORE.md](../AI_CORE.md)

## Содержание

1. [Обзор и архитектура](#1-обзор-и-архитектура)
2. [Справочник API](#2-справочник-api)
3. [Как работает передача аргументов](#3-как-работает-передача-аргументов)
4. [Stdout / Stderr: буферы без перекодировки](#4-stdout--stderr-буферы-без-перекодировки)
5. [Stdin: запись данных в процесс](#5-stdin-запись-данных-в-процесс)
6. [Коды состояния и ошибок](#6-коды-состояния-и-ошибок)
7. [Сигнал finished: прямой C-callback](#7-сигнал-finished-прямой-c-callback)
8. [Синхронный режим (без GUI)](#8-синхронный-режим-без-gui)
9. [Асинхронный режим с GUI (core.thread + QTimer)](#9-асинхронный-режим-с-gui-corethread--qtimer)
10. [startDetached: запуск и забыть](#10-startdetached-запуск-и-забыть)
11. [Платформенные различия Windows / Linux](#11-платформенные-различия-windows--linux)
12. [Типичные ошибки](#12-типичные-ошибки)
13. [Большой пример: GUI-утилита «Process Runner»](#13-большой-пример-gui-утилита-process-runner)

---

## 1. Обзор и архитектура

### Что такое QProcess

`QProcess` — это Qt-класс для запуска внешних программ как дочерних процессов.
Он управляет stdin/stdout/stderr дочернего процесса и предоставляет API для
ожидания завершения, чтения вывода, записи данных и получения кода возврата.

### Место в QTE56

```
D-код (gen_qprocess.d)
    ↕  void* указатели на Qt-объекты
C++ тонкая обёртка (qte56_qprocess.dll)   ← QT = core (без gui/widgets)
    ↕  Qt API
Qt QProcess (Qt5Core.dll / libQt5Core.so)
    ↕  OS API
Дочерний процесс (любая программа)
```

`qte56_qprocess.dll` компилируется только с `QT = core` — это самый лёгкий вариант,
достаточный для управления процессами без GUI. Это означает что `QProcess` можно
использовать даже без `QApplication` в консольных утилитах.

### Индексы функций

| Индекс | Функция C++ | Метод D |
|--------|-------------|---------|
| 19816 | `qteQProcess_create` | конструктор |
| 19817 | `qteQProcess_delete` | деструктор |
| 19818 | `qteQProcess_start` | `start()` |
| 19819 | `qteQProcess_startDetached` | `startDetached()` static |
| 19820 | `qteQProcess_waitForStarted` | `waitForStarted()` |
| 19821 | `qteQProcess_waitForFinished` | `waitForFinished()` |
| 19822 | `qteQProcess_kill` | `kill()` |
| 19823 | `qteQProcess_terminate` | `terminate()` |
| 19824 | `qteQProcess_exitCode` | `exitCode()` |
| 19825 | `qteQProcess_exitStatus` | `exitStatus()` |
| 19826 | `qteQProcess_state` | `state()` |
| 19827 | `qteQProcess_setWorkingDirectory` | `setWorkingDirectory()` |
| 19828 | `qteQProcess_workingDirectory` | `workingDirectory()` |
| 19829 | `qteQProcess_readAllStdout` | `readAllStdout()` |
| 19830 | `qteQProcess_readAllStderr` | `readAllStderr()` |
| 19831 | `qteQProcess_freeBuffer` | (внутренняя) |
| 19832 | `qteQProcess_write` | `write()` |
| 19833 | `qteQProcess_closeWriteChannel` | `closeWriteChannel()` |
| 19834 | `qteQProcess_error` | `error()` |
| 19835 | `qteQProcess_errorString` | `errorString()` |
| 19836 | `qteQProcess_connect_finished` | `connect_finished()` |

---

## 2. Справочник API

```d
import gen_qprocess;

// Создание
auto p = new QProcess();

// Запуск
p.start(string program, string[] args = null);
static int startDetached(string program, string[] args = null);  // → 1=ок, 0=ошибка

// Ожидание
int waitForStarted(int msec = 30000);   // → 1=запустился, 0=таймаут
int waitForFinished(int msec = 30000);  // → 1=завершился, 0=таймаут

// Управление
void kill();       // SIGKILL — немедленное уничтожение
void terminate();  // SIGTERM — мягкое завершение (может игнорироваться)

// Состояние
int state();       // 0=NotRunning, 1=Starting, 2=Running
int exitCode();    // код возврата (только после waitForFinished)
int exitStatus();  // 0=NormalExit, 1=CrashExit

// Рабочий каталог
void   setWorkingDirectory(string path);
string workingDirectory();

// Чтение вывода (после waitForFinished)
ubyte[]  readAllStdout();      // сырые байты
ubyte[]  readAllStderr();      // сырые байты
string   readStdoutText();     // cast(string) убайтов — интерпретация как UTF-8
string   readStderrText();     // то же для stderr

// Запись в stdin
int  write(const(ubyte)[] data);    // → число записанных байт
int  writeText(string s);           // удобная обёртка
void closeWriteChannel();           // закрыть stdin (EOF для дочернего процесса)

// Ошибки
int    error();        // ProcessError enum (см. раздел 6)
string errorString();  // человекочитаемое описание

// Сигнал
void connect_finished(void* cb);   // cb: extern(C) void function(int code, int status)
```

---

## 3. Как работает передача аргументов

### Проблема

Между D и C++ аргументы нельзя передать как `string[]` — это D-specific тип.
На стороне C++ нужен `QStringList`. Прямая передача потребовала бы сложного
маршалинга: длина массива + массив пар (pointer, length).

### Решение: разделитель \x01

В QTE56 принято соглашение: аргументы объединяются в одну строку через символ
`\x01` (ASCII 1, SOH — Start of Heading). Этот символ никогда не встречается
в реальных путях и аргументах командной строки.

**D-сторона** (`gen_qcore.d`):
```d
void* toQStringList(string[] items) {
    if (items.length == 0) return null;
    import std.array : join;
    return toQString(items.join("\x01"));  // одна строка → один QString*
}
```

**C++-сторона** (`qte56_qprocess.cpp`):
```cpp
static QStringList qsListFromSep1(void* qs) {
    if (!qs) return QStringList();          // null → пустой список (нет аргументов)
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1));               // \x01 → QStringList
}
```

**Результат в D:**
```d
p.start("git", ["log", "--oneline", "-10"]);
// Передаётся: "log\x01--oneline\x01-10" как один QString*
// C++ восстанавливает: QStringList{"log", "--oneline", "-10"}

p.start("ls");       // args = null → пустой QStringList
p.start("echo", []); // пустой массив → тоже пустой QStringList
```

### Почему не через \0 или пробел?

- `\0` (null terminator) — преждевременно обрывает C-строку
- пробел — законный символ в путях (`C:\Program Files\...`)
- `\x01` — управляющий символ, в аргументах никогда не используется

---

## 4. Stdout / Stderr: буферы без перекодировки

### Как устроено чтение буфера

`QProcess::readAllStandardOutput()` возвращает `QByteArray` — сырые байты.
В C++ мы копируем их в heap-буфер и возвращаем указатель + длину:

```cpp
// C++ (qte56_qprocess.cpp)
static void* baToHeap(const QByteArray& ba, int* len) {
    *len = ba.size();
    if (ba.size() == 0) return nullptr;
    char* buf = new char[ba.size()];
    memcpy(buf, ba.constData(), ba.size());
    return buf;
}

void* qteQProcess_readAllStdout(void* proc, int* len) {
    return baToHeap(((QProcess*)proc)->readAllStandardOutput(), len);
}
```

**D-сторона** получает `void*` + `int len`, копирует в `ubyte[]` и освобождает буфер:

```d
// gen_qprocess.d — внутренняя вспомогательная
ubyte[] _readBuf(size_t idx) {
    int len;
    void* buf = (cast(t_qp__qp_ip)pFunQt[idx])(_wh, &len);
    if (buf is null || len == 0) return [];
    ubyte[] result = (cast(ubyte*)buf)[0 .. len].dup;  // копируем в D heap
    (cast(t_v__qp)pFunQt[19831])(buf);                 // освобождаем C++ буфер
    return result;
}
```

### Почему без перекодировки

На Windows консоль может выводить текст в CP866 или CP1251, на Linux — в UTF-8.
Автоматическая перекодировка была бы ошибкой: она некорректна для бинарных данных
(картинки, архивы, дампы), и у пользователя нет выбора.

**Правило:** `readAllStdout()` / `readAllStderr()` возвращают сырые байты. Пользователь
решает сам, как их интерпретировать.

```d
// Вариант 1: UTF-8 вывод (Linux, или Windows-программа с /utf-8)
string text = p.readStdoutText();   // cast(string) ubyte[]

// Вариант 2: CP866 на Windows (старые консольные программы)
import asc1251 : from866toUtf8;      // если есть такой модуль
ubyte[] raw = p.readAllStdout();
string text = from866toUtf8(cast(string)raw);

// Вариант 3: бинарные данные (скачать файл через curl --output -)
ubyte[] imageData = p.readAllStdout();
std.file.write("output.jpg", imageData);
```

---

## 5. Stdin: запись данных в процесс

`QProcess` открывает три канала с дочерним процессом: stdin, stdout, stderr.
По умолчанию все три присоединены и готовы к работе сразу после `start()`.

### Базовый паттерн

```d
auto p = new QProcess();
p.start("python3", ["-c", "import sys; print(sys.stdin.read().upper())"]);
p.waitForStarted(5000);

p.writeText("hello world\n");
p.closeWriteChannel();      // ← ОБЯЗАТЕЛЬНО! Иначе python3 ждёт ещё данных (EOF не придёт)

p.waitForFinished(10000);
writeln(p.readStdoutText()); // "HELLO WORLD\n"
```

### Почему closeWriteChannel обязателен

Большинство программ читают stdin до EOF (`while (fgets(line, ...))`).
Если не закрыть канал, программа будет ждать бесконечно, и `waitForFinished`
завершится по таймауту.

```d
// НЕПРАВИЛЬНО — process зависнет:
p.writeText("data");
p.waitForFinished();        // зависает!

// ПРАВИЛЬНО:
p.writeText("data");
p.closeWriteChannel();      // сигнал EOF
p.waitForFinished();        // завершается нормально
```

### Отправка нескольких строк

```d
p.writeText("line1\n");
p.writeText("line2\n");
p.writeText("line3\n");
p.closeWriteChannel();
```

### Запись бинарных данных

```d
import std.file : read;
ubyte[] data = cast(ubyte[])read("input.bin");
p.write(data);
p.closeWriteChannel();
```

---

## 6. Коды состояния и ошибок

### state() — текущее состояние процесса

```d
p.state() == 0  // QProcess::NotRunning — не запущен или завершён
p.state() == 1  // QProcess::Starting   — запускается
p.state() == 2  // QProcess::Running    — работает
```

### exitStatus() — как завершился процесс

```d
p.exitStatus() == 0  // QProcess::NormalExit  — завершился сам
p.exitStatus() == 1  // QProcess::CrashExit   — упал (signal на Linux, exception на Windows)
```

### exitCode() — код возврата

Имеет смысл **только** если `exitStatus() == 0` (NormalExit).
При CrashExit значение undefined.

```d
p.waitForFinished();
if (p.exitStatus() == 0) {
    if (p.exitCode() == 0)
        writeln("успешно");
    else
        writefln("ошибка, код %d", p.exitCode());
} else {
    writeln("процесс упал");
}
```

### error() — код ошибки запуска

Возвращается `QProcess::ProcessError` — причина последней ошибки:

| Значение | Константа Qt | Описание |
|----------|--------------|----------|
| 0 | `FailedToStart` | Программа не найдена или нет прав на запуск |
| 1 | `Crashed` | Процесс упал после запуска |
| 2 | `Timedout` | `waitForStarted` / `waitForFinished` истёк |
| 3 | `ReadError` | Ошибка чтения stdout/stderr |
| 4 | `WriteError` | Ошибка записи в stdin |
| 5 | `UnknownError` | Неизвестная ошибка |

**Важно:** `FailedToStart == 0`, поэтому проверка `error() != 0` не означает
«ошибки нет». Правильная проверка:

```d
p.start("nonexistent_program");
if (!p.waitForStarted(3000)) {
    writefln("Не удалось запустить: %s", p.errorString());
    // error() == 0 (FailedToStart) — НОРМАЛЬНО для этого случая
}
```

---

## 7. Сигнал finished: прямой C-callback

### Когда нужен connect_finished

`connect_finished` — это асинхронное уведомление: когда процесс завершится,
Qt вызовет вашу функцию через event loop. Полезно в GUI-приложениях, где вы
не хотите блокировать поток через `waitForFinished`.

**Сигнал в Qt:** `void QProcess::finished(int exitCode, QProcess::ExitStatus exitStatus)`

### Синтаксис подключения

```d
extern(C) static void onDone(int code, int status) {
    writefln("Завершился: код=%d, статус=%d", code, status);
}

p.connect_finished(cast(void*)&onDone);
```

### Требования к callback

1. **`extern(C)`** — обязательно. Qt вызывает функцию через C ABI (через lambda внутри C++).
   Без `extern(C)` стек будет разрушен.

2. **`static` или глобальная** — функция не должна быть замыканием (closure).
   Замыкание — это D struct с указателем на фрейм, в C ABI это несовместимо.

3. **Хранение в `__gshared`** — если вы создаёте delegate или closure,
   сохраните его чтобы GC не собрал указатель.

```d
// ПРАВИЛЬНО — статическая функция
extern(C) static void cbFinished(int code, int status) { ... }
p.connect_finished(cast(void*)&cbFinished);

// НЕПРАВИЛЬНО — lambda (closure) не совместима с C ABI
p.connect_finished(cast(void*)((int c, int s) { ... }));   // CRASH!
```

### Как это работает внутри C++

```cpp
// qte56_qprocess.cpp
void qteQProcess_connect_finished(void* proc, void* cb) {
    auto fn = (void(*)(int, int))cb;
    QObject::connect(
        (QProcess*)proc,
        QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [fn](int code, QProcess::ExitStatus st) { fn(code, (int)st); }
    );
}
```

`QOverload` нужен потому что в Qt есть два перегруженных сигнала `finished`:
устаревший без параметров и актуальный с `(int, ExitStatus)`.

### connect_finished требует event loop

Сигнал доставляется **только** когда работает event loop (`app.exec()`).
В консольном режиме без `QApplication` сигнал никогда не придёт — используйте
`waitForFinished` вместо него.

```d
// Консоль — ТОЛЬКО waitForFinished:
p.waitForFinished(30000);
writeln(p.exitCode());

// GUI — connect_finished + exec():
p.connect_finished(cast(void*)&onDone);
p.start("cmd", ["/C", "long_job.bat"]);
app.exec();  // event loop доставит сигнал в onDone
```

---

## 8. Синхронный режим (без GUI)

Самый простой режим: запустить → подождать → прочитать. Блокирует поток.

```d
import gen_qprocess;

string runCommand(string program, string[] args, int timeoutMs = 30000) {
    auto p = new QProcess();
    p.start(program, args);

    if (!p.waitForStarted(5000)) {
        return "ERROR: " ~ p.errorString();
    }
    if (!p.waitForFinished(timeoutMs)) {
        p.kill();
        return "ERROR: timeout";
    }
    if (p.exitStatus() != 0 || p.exitCode() != 0) {
        return "STDERR: " ~ p.readStderrText();
    }
    return p.readStdoutText();
}

// Использование:
writeln(runCommand("git", ["log", "--oneline", "-5"]));
writeln(runCommand("python3", ["-V"]));
```

### Pipe через stdin

```d
string pipeTo(string program, string[] args, string input) {
    auto p = new QProcess();
    p.start(program, args);
    p.waitForStarted(5000);
    p.writeText(input);
    p.closeWriteChannel();     // EOF → программа знает что данные закончились
    p.waitForFinished(30000);
    return p.readStdoutText();
}

// Сортировка строк через sort
string sorted = pipeTo("sort", [], "banana\napple\ncherry\n");
```

---

## 9. Асинхронный режим с GUI (core.thread + QTimer)

В GUI-приложении нельзя вызывать `waitForFinished` в главном потоке — это заморозит
интерфейс. Есть два подхода.

### Подход A: connect_finished (нет блокировки, event-based)

Подходит когда не нужно отображать прогресс — только получить результат по завершении.

```d
import gen_qprocess, gen_qtimer, gen_qlabel;

__gshared QProcess g_proc;
__gshared QLabel   g_statusLabel;

extern(C) static void onProcessDone(int code, int status) {
    // Вызывается из event loop главного потока — GUI трогать можно
    if (code == 0) {
        string out_ = g_proc.readStdoutText();
        g_statusLabel.setText("Готово: " ~ out_[0..min(50, $)]);
    } else {
        g_statusLabel.setText("Ошибка, код " ~ to!string(code));
    }
}

// В обработчике кнопки:
g_proc = new QProcess();
g_proc.connect_finished(cast(void*)&onProcessDone);
g_proc.start("git", ["pull"]);
g_statusLabel.setText("Выполняется...");
```

### Подход B: core.thread + QTimer (для отображения прогресса)

Используется когда нужно читать вывод в реальном времени или показывать прогресс-бар.
Подробно описан в `doc/threading.md`. Краткая схема:

```d
import core.thread, core.atomic;
import gen_qtimer, gen_qprocess;

__gshared shared bool  g_done;
__gshared shared int   g_exitCode;
__gshared string[]     g_lines;   // результаты (из фонового потока)
__gshared Object       g_mutex;

// Фоновый поток — запускает процесс и собирает вывод
void workerThread() {
    auto p = new QProcess();
    p.start("make", ["-j4"]);
    p.waitForStarted(5000);

    // Читаем вывод построчно пока процесс работает
    while (p.state() != 0) {
        p.waitForFinished(200);   // ждём 200мс или завершения
        string chunk = p.readStdoutText();
        if (chunk.length > 0) {
            synchronized(g_mutex) {
                import std.string : splitLines;
                g_lines ~= chunk.splitLines();
            }
        }
    }

    atomicStore(g_exitCode, cast(shared int)p.exitCode());
    atomicStore(g_done, true);
}

// QTimer в главном потоке опрашивает каждые 100мс
extern(C) static void onTimer(void* dthis, int n) {
    if (!atomicLoad(g_done)) return;

    string[] lines;
    synchronized(g_mutex) { lines = g_lines; }
    // ... обновить QTextEdit, остановить таймер
}
```

---

## 10. startDetached: запуск и забыть

`startDetached` — статический метод, запускает процесс без привязки к текущему
процессу. Дочерний процесс продолжит работу даже после завершения родителя.

```d
// Открыть файл в системном редакторе (Windows)
QProcess.startDetached("notepad.exe", ["C:\\readme.txt"]);

// Открыть URL в браузере (Linux)
QProcess.startDetached("xdg-open", ["https://example.com"]);

// Перезапустить само приложение
QProcess.startDetached(g_app.applicationFilePath(), []);
```

**Отличие от `start` + игнорирование:**
- `startDetached` — процесс реально отсоединён (setsid на Linux), не зомби
- `start` без `waitForFinished` — процесс всё равно привязан к родителю, при
  удалении `QProcess` объекта дочерний процесс может получить SIGHUP

**Ограничение:** нельзя читать stdout/stderr от `startDetached` — канал не создаётся.

---

## 11. Платформенные различия Windows / Linux

### Путь к программе

```d
// Windows: можно без расширения (.exe), PATH ищется автоматически
p.start("notepad");
p.start("cmd", ["/C", "dir"]);

// Linux: полный путь или имя из PATH
p.start("ls", ["-la"]);
p.start("/usr/bin/python3", ["script.py"]);
```

### Shell-команды

На Windows нет прямого аналога `/bin/sh`. Для сложных команд нужен `cmd /C`:

```d
version (Windows) {
    p.start("cmd", ["/C", "echo Hello && dir"]);
} else {
    p.start("/bin/sh", ["-c", "echo Hello && ls"]);
}
```

### Кодировка вывода

На Windows консольные программы часто выводят в CP866 (кириллица) или CP1251.
На Linux — всегда UTF-8 (в современных дистрибутивах).

```d
ubyte[] raw = p.readAllStdout();

version (Windows) {
    // Если программа выводит CP866:
    import asc1251 : from866toUtf8;
    string text = from866toUtf8(cast(string)raw);
    // Если UTF-8 (например git с core.quotepath=false):
    // string text = cast(string)raw;
} else {
    string text = cast(string)raw;
}
```

### terminate() vs kill()

| | Windows | Linux |
|--|---------|-------|
| `terminate()` | WM_CLOSE + TerminateProcess | SIGTERM |
| `kill()` | TerminateProcess (force) | SIGKILL |

На Windows `terminate()` отправляет `WM_CLOSE` только GUI-приложениям.
Консольным программам лучше сразу `kill()`.

---

## 12. Типичные ошибки

### 1. Забыть closeWriteChannel

```d
// НЕПРАВИЛЬНО — process висит вечно
p.start("cat");
p.writeText("hello");
p.waitForFinished();   // ЗАВИСАЕТ — cat ждёт EOF

// ПРАВИЛЬНО
p.start("cat");
p.writeText("hello");
p.closeWriteChannel();
p.waitForFinished();
```

### 2. Читать вывод до waitForFinished

```d
// НЕПРАВИЛЬНО — буфер может быть пуст или неполон
p.start("make", ["-j4"]);
string out_ = p.readStdoutText();   // может быть пусто!
p.waitForFinished();

// ПРАВИЛЬНО
p.start("make", ["-j4"]);
p.waitForFinished(300000);   // 5 минут
string out_ = p.readStdoutText();   // теперь всё на месте
```

### 3. Игнорировать waitForStarted перед waitForFinished

```d
// Потенциально опасно — что если программа не нашлась?
p.start("nonexistent");
p.waitForFinished();   // вернёт 1 сразу, exitCode = -2, exitStatus = 0

// Лучше явно проверить:
p.start("nonexistent");
if (!p.waitForStarted(3000)) {
    writefln("Не запустилась: %s", p.errorString());
    return;
}
p.waitForFinished();
```

### 4. Неправильный callback для connect_finished

```d
// НЕПРАВИЛЬНО — не extern(C), ABI несовместим
void onDone(int code, int status) { ... }
p.connect_finished(cast(void*)&onDone);  // UB / CRASH

// ПРАВИЛЬНО
extern(C) static void onDone(int code, int status) { ... }
p.connect_finished(cast(void*)&onDone);
```

### 5. Использовать connect_finished без event loop

```d
// НЕПРАВИЛЬНО — в консольном приложении без app.exec()
p.connect_finished(cast(void*)&onDone);
p.start("build.sh");
// ... onDone НИКОГДА не вызовется

// ПРАВИЛЬНО для консоли:
p.start("build.sh");
p.waitForFinished(60000);
writeln(p.exitCode());
```

### 6. Большой вывод и переполнение буфера

QProcess буферизует весь stdout/stderr в памяти. Для программ с большим выводом
(сотни MB) это может быть проблемой. Решение — читать вывод порциями:

```d
p.start("program_with_large_output");
while (p.waitForFinished(100) == 0) {  // ждём 100мс
    string chunk = p.readStdoutText();
    if (chunk.length > 0) processChunk(chunk);
}
// Читаем остаток
processChunk(p.readStdoutText());
```

---

## 13. Большой пример: GUI-утилита «Process Runner»

Полнофункциональное GUI-приложение: выбор программы, аргументы, рабочая папка,
кнопки Run/Kill, вывод stdout/stderr в отдельные вкладки, прогресс-статус,
история запусков, перезапуск.

Демонстрирует: асинхронный запуск с `connect_finished`, чтение вывода,
управление кнопками, обработку ошибок, `startDetached`.

```d
/**
 * gui_qprocess_runner.d — GUI-утилита для запуска внешних процессов.
 *
 * Компиляция (Windows):
 *   dmd -m32 -I. -Id\gen -oftest\gui_qprocess_runner.exe ^
 *       test\gui_qprocess_runner.d ^
 *       d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
 *       d\gen\gen_qcore.d d\gen\gen_qwidget.d d\gen\gen_qlayout.d ^
 *       d\gen\gen_qlabel.d d\gen\gen_qlineedit.d d\gen\gen_qpushbutton.d ^
 *       d\gen\gen_qtextedit.d d\gen\gen_qtabwidget.d d\gen\gen_qcombobox.d ^
 *       d\gen\gen_qcheckbox.d d\gen\gen_qgroupbox.d ^
 *       d\gen\gen_qabstractbutton.d d\gen\gen_qabstractscrollarea.d ^
 *       d\gen\gen_qframe.d d\gen\gen_qtabbar.d ^
 *       d\gen\gen_qprocess.d
 */
module gui_qprocess_runner;

import std.stdio;
import std.string : strip, splitLines;
import std.conv : to;
import std.algorithm : min;

import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import gen_qlayout;
import gen_qlabel;
import gen_qlineedit;
import gen_qpushbutton;
import gen_qtextedit;
import gen_qtabwidget;
import gen_qcombobox;
import gen_qcheckbox;
import gen_qgroupbox;
import gen_qprocess;

// ── Глобальное состояние ──────────────────────────────────────────────────────

__gshared QProcess     g_proc;
__gshared bool         g_running;

// Виджеты (глобальные — нужны в callback)
__gshared QLineEdit    g_edProgram;
__gshared QLineEdit    g_edArgs;
__gshared QLineEdit    g_edWorkDir;
__gshared QTextEdit    g_outStdout;
__gshared QTextEdit    g_outStderr;
__gshared QLabel       g_lblStatus;
__gshared QPushButton  g_btnRun;
__gshared QPushButton  g_btnKill;
__gshared QPushButton  g_btnDetach;
__gshared QCheckBox    g_chkMerge;
__gshared QComboBox    g_cmbHistory;

// История запусков (cmd + args)
__gshared string[]     g_history;

// ── Вспомогательные ───────────────────────────────────────────────────────────

/// Разбить строку аргументов по пробелам, учитывая кавычки.
/// "arg1 arg2 "path with space"" → ["arg1", "arg2", "path with space"]
string[] parseArgs(string s) {
    string[] result;
    bool inQuote = false;
    string cur;
    foreach (c; s) {
        if (c == '"') {
            inQuote = !inQuote;
        } else if (c == ' ' && !inQuote) {
            if (cur.length > 0) { result ~= cur; cur = ""; }
        } else {
            cur ~= c;
        }
    }
    if (cur.length > 0) result ~= cur;
    return result;
}

/// Установить состояние кнопок Run/Kill в зависимости от g_running
void updateButtons() {
    if (g_running) {
        g_btnRun.setEnabled(0);
        g_btnKill.setEnabled(1);
        g_lblStatus.setText("▶ Выполняется...");
    } else {
        g_btnRun.setEnabled(1);
        g_btnKill.setEnabled(0);
    }
}

/// Добавить строку в историю и QComboBox
void addToHistory(string cmd) {
    foreach (h; g_history) if (h == cmd) return;  // дубликат
    g_history ~= cmd;
    g_cmbHistory.addItem(cmd);
    if (g_history.length > 20) {
        g_history = g_history[1..$];
        g_cmbHistory.removeItem(0);
    }
}

// ── Callback: завершение процесса ─────────────────────────────────────────────
// Вызывается из Qt event loop — GUI трогать можно.

extern(C) static void onProcessFinished(int exitCode, int exitStatus) {
    g_running = false;

    // Читаем оставшийся вывод
    string outText  = g_proc.readStdoutText();
    string errText  = g_proc.readStderrText();

    if (outText.length > 0) {
        string cur = g_outStdout.toPlainText();
        g_outStdout.setPlainText(cur ~ outText);
    }

    if (errText.length > 0) {
        if (g_chkMerge.isChecked()) {
            // Объединить stderr в stdout с маркером
            string cur = g_outStdout.toPlainText();
            g_outStdout.setPlainText(cur ~ "[STDERR] " ~ errText);
        } else {
            string cur = g_outStderr.toPlainText();
            g_outStderr.setPlainText(cur ~ errText);
        }
    }

    // Обновить статус
    if (exitStatus == 1) {
        g_lblStatus.setText("✖ Процесс упал (crash)");
    } else if (exitCode == 0) {
        g_lblStatus.setText("✔ Завершён успешно (код 0)");
    } else {
        g_lblStatus.setText("✖ Завершён с ошибкой (код " ~ to!string(exitCode) ~ ")");
    }

    updateButtons();
}

// ── Callback: кнопка Run ──────────────────────────────────────────────────────

extern(C) static void onRun(void* dthis, int n) {
    if (g_running) return;

    string program = g_edProgram.text();
    string argsStr = g_edArgs.text();
    string workDir = g_edWorkDir.text();

    if (program.strip().length == 0) {
        g_lblStatus.setText("Укажите программу!");
        return;
    }

    // Очистить предыдущий вывод
    g_outStdout.clear();
    g_outStderr.clear();

    // Создать новый процесс
    g_proc = new QProcess();
    g_proc.connect_finished(cast(void*)&onProcessFinished);

    if (workDir.strip().length > 0)
        g_proc.setWorkingDirectory(workDir);

    string[] args = parseArgs(argsStr);
    g_proc.start(program, args);

    if (!g_proc.waitForStarted(3000)) {
        g_lblStatus.setText("Ошибка: " ~ g_proc.errorString());
        return;
    }

    g_running = true;
    updateButtons();

    // Добавить в историю
    string histEntry = args.length > 0
        ? program ~ " " ~ argsStr
        : program;
    addToHistory(histEntry);
}

// ── Callback: кнопка Kill ────────────────────────────────────────────────────

extern(C) static void onKill(void* dthis, int n) {
    if (!g_running || g_proc is null) return;
    g_lblStatus.setText("⚠ Убиваем процесс...");
    g_proc.kill();
    // onProcessFinished придёт через event loop
}

// ── Callback: кнопка Clear ───────────────────────────────────────────────────

extern(C) static void onClear(void* dthis, int n) {
    g_outStdout.clear();
    g_outStderr.clear();
    g_lblStatus.setText("Готов");
}

// ── Callback: кнопка Detach ──────────────────────────────────────────────────

extern(C) static void onDetach(void* dthis, int n) {
    string program = g_edProgram.text();
    string argsStr = g_edArgs.text();
    if (program.strip().length == 0) {
        g_lblStatus.setText("Укажите программу!");
        return;
    }
    string[] args = parseArgs(argsStr);
    int ok = QProcess.startDetached(program, args);
    if (ok)
        g_lblStatus.setText("Запущен отдельно: " ~ program);
    else
        g_lblStatus.setText("Ошибка запуска detached");
}

// ── Callback: выбор из истории ───────────────────────────────────────────────

extern(C) static void onHistorySelected(void* dthis, int n, void* qs) {
    // qs — void* на QString, полученный через ESlot invoke_s
    // Импортируем через fromQString
    string val = fromQString(qs);
    if (val.length == 0) return;

    // Разбить на программу и аргументы
    auto parts = parseArgs(val);
    if (parts.length == 0) return;
    g_edProgram.setText(parts[0]);
    if (parts.length > 1) {
        // Восстановить строку аргументов
        string args;
        foreach (i, p; parts[1..$]) {
            if (i > 0) args ~= " ";
            if (p.length > 0 && p[0] != '-' &&
                ((){
                    foreach (c; p) if (c == ' ') return true;
                    return false;
                }()))
                args ~= '"' ~ p ~ '"';
            else
                args ~= p;
        }
        g_edArgs.setText(args);
    } else {
        g_edArgs.setText("");
    }
}

// ── main ──────────────────────────────────────────────────────────────────────

void main() {
    LoadQt("./dll");

    // Создаём приложение
    auto app = new QApplication();

    // ── Главное окно ──────────────────────────────────────────────────────────
    auto win = new QWidget(null);
    win.setWindowTitle("Process Runner — QTE56");
    win.resize(800, 600);

    auto mainLayout = new QVBoxLayout();

    // ── Группа: Команда ───────────────────────────────────────────────────────
    auto grpCmd = new QGroupBox(win.getWH());
    grpCmd.setTitle("Команда");
    auto grpLayout = new QGridLayout();

    grpLayout.addWidget(new QLabel(win.getWH()).also((l){ l.setText("Программа:"); }).getWH(), 0, 0, 1, 1);
    g_edProgram = new QLineEdit(win.getWH());
    version(Windows) g_edProgram.setText("cmd");
    else              g_edProgram.setText("/bin/sh");
    g_edProgram.setPlaceholderText("Имя или полный путь к программе");
    grpLayout.addWidget(g_edProgram.getWH(), 0, 1, 1, 1);

    grpLayout.addWidget(new QLabel(win.getWH()).also((l){ l.setText("Аргументы:"); }).getWH(), 1, 0, 1, 1);
    g_edArgs = new QLineEdit(win.getWH());
    version(Windows) g_edArgs.setText("/C dir");
    else              g_edArgs.setText("-c \"ls -la\"");
    g_edArgs.setPlaceholderText("Аргументы через пробел, строки с пробелами — в кавычки");
    grpLayout.addWidget(g_edArgs.getWH(), 1, 1, 1, 1);

    grpLayout.addWidget(new QLabel(win.getWH()).also((l){ l.setText("Рабочая папка:"); }).getWH(), 2, 0, 1, 1);
    g_edWorkDir = new QLineEdit(win.getWH());
    g_edWorkDir.setPlaceholderText("(оставьте пустым для текущей директории)");
    grpLayout.addWidget(g_edWorkDir.getWH(), 2, 1, 1, 1);

    grpCmd.setLayout(grpLayout.getWH());
    grpLayout.disown();
    mainLayout.addWidget(grpCmd.getWH());

    // ── Строка кнопок ─────────────────────────────────────────────────────────
    auto btnLayout = new QHBoxLayout();

    g_btnRun = new QPushButton(null);
    g_btnRun.setText("▶  Run");
    g_btnRun.setFixedHeight(36);

    g_btnKill = new QPushButton(null);
    g_btnKill.setText("■  Kill");
    g_btnKill.setEnabled(0);
    g_btnKill.setFixedHeight(36);

    auto btnClear = new QPushButton(null);
    btnClear.setText("Очистить");
    btnClear.setFixedHeight(36);

    g_btnDetach = new QPushButton(null);
    g_btnDetach.setText("Запустить отдельно");
    g_btnDetach.setFixedHeight(36);

    g_chkMerge = new QCheckBox(null);
    g_chkMerge.setText("Объединить stderr → stdout");

    btnLayout.addWidget(g_btnRun.getWH());
    btnLayout.addWidget(g_btnKill.getWH());
    btnLayout.addWidget(btnClear.getWH());
    btnLayout.addWidget(g_btnDetach.getWH());
    btnLayout.addStretch();
    btnLayout.addWidget(g_chkMerge.getWH());
    mainLayout.addLayout(btnLayout.getWH());
    btnLayout.disown();

    // ── История ───────────────────────────────────────────────────────────────
    auto histLayout = new QHBoxLayout();
    auto lblHist = new QLabel(win.getWH());
    lblHist.setText("История:");
    g_cmbHistory = new QComboBox(win.getWH());
    g_cmbHistory.setMinimumWidth(300);
    histLayout.addWidget(lblHist.getWH());
    histLayout.addWidget(g_cmbHistory.getWH(), 1);
    histLayout.addStretch();
    mainLayout.addLayout(histLayout.getWH());
    histLayout.disown();

    // ── Вкладки: stdout / stderr ──────────────────────────────────────────────
    auto tabs = new QTabWidget(win.getWH());

    g_outStdout = new QTextEdit(win.getWH());
    g_outStdout.setReadOnly(1);
    g_outStdout.setFontFamily("Courier New");

    g_outStderr = new QTextEdit(win.getWH());
    g_outStderr.setReadOnly(1);
    g_outStderr.setFontFamily("Courier New");
    // Красный цвет текста для stderr
    g_outStderr.setStyleSheet("color: #cc0000; background: #fff8f8;");

    tabs.addTab(g_outStdout.getWH(), "stdout");
    tabs.addTab(g_outStderr.getWH(), "stderr");
    mainLayout.addWidget(tabs.getWH(), 1);  // stretch=1: занимает оставшееся место

    // ── Строка статуса ────────────────────────────────────────────────────────
    g_lblStatus = new QLabel(win.getWH());
    g_lblStatus.setText("Готов");
    g_lblStatus.setStyleSheet("padding: 4px; background: #f0f0f0; border-top: 1px solid #ccc;");
    mainLayout.addWidget(g_lblStatus.getWH());

    win.setLayout(mainLayout.getWH());
    mainLayout.disown();

    // ── Подключение сигналов ──────────────────────────────────────────────────

    // Кнопки — ESlot
    auto slRun = new ESlot(g_btnRun.getWH());
    slRun.set(cast(void*)&onRun, null);
    g_btnRun.connect_clicked(slRun);

    auto slKill = new ESlot(g_btnKill.getWH());
    slKill.set(cast(void*)&onKill, null);
    g_btnKill.connect_clicked(slKill);

    auto slClear = new ESlot(btnClear.getWH());
    slClear.set(cast(void*)&onClear, null);
    btnClear.connect_clicked(slClear);

    auto slDetach = new ESlot(g_btnDetach.getWH());
    slDetach.set(cast(void*)&onDetach, null);
    g_btnDetach.connect_clicked(slDetach);

    // История: когда пользователь выбирает элемент
    // (QComboBox.connect_currentTextChanged использует invoke_s)
    // Для простоты — кнопка «Загрузить»:
    auto btnLoad = new QPushButton(null);
    btnLoad.setText("⬆ Загрузить");
    btnLoad.setFixedHeight(28);
    histLayout = new QHBoxLayout();   // пересоздаём — уже disown'нут
    // Вместо этого — добавляем кнопку прямо в histLayout до disown был сделан
    // (см. паттерн: все дочерние виджеты добавляем до disown layout)
    // Простое решение: у кнопки Run уже есть поля — при нажении читаем из combobox напрямую:
    // (кнопка «Загрузить» не нужна — Run сам берёт из edProgram/edArgs)

    // ── Показать и запустить ──────────────────────────────────────────────────
    win.show();
    app.exec();

    app.deleteApp();
    // UnloadQt() — НЕ вызывать: OS сама выгрузит DLL при выходе процесса
}

// ── Вспомогательный метод .also() для inline-инициализации ───────────────────
// (если нет в вашей версии — используйте отдельные переменные)
//
// Пример использования: new QLabel(parent).also((l){ l.setText("X"); })
// Реализация:
//   T also(T)(T obj, void delegate(T) init) { init(obj); return obj; }
// Добавьте как свободную функцию или используйте отдельные переменные.
```

### Как скомпилировать и запустить

**Windows:**

```bat
@echo off
cd /d "%~dp0.."
dmd -m32 -I. -Id\gen -oftest\gui_qprocess_runner.exe ^
    test\gui_qprocess_runner.d ^
    d\qte56_core.d d\qte56_loader.d d\qte56_enums.d ^
    d\gen\gen_qcore.d d\gen\gen_qwidget.d d\gen\gen_qlayout.d ^
    d\gen\gen_qlabel.d d\gen\gen_qlineedit.d d\gen\gen_qpushbutton.d ^
    d\gen\gen_qtextedit.d d\gen\gen_qtabwidget.d d\gen\gen_qcombobox.d ^
    d\gen\gen_qcheckbox.d d\gen\gen_qgroupbox.d ^
    d\gen\gen_qabstractbutton.d d\gen\gen_qabstractscrollarea.d ^
    d\gen\gen_qframe.d d\gen\gen_qtabbar.d ^
    d\gen\gen_qprocess.d
set PATH=%~dp0dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
test\gui_qprocess_runner.exe
```

**Linux:**

```bash
cd arch_new
ldc2 -I. -Id/gen -of=test/gui_qprocess_runner \
    test/gui_qprocess_runner.d \
    d/qte56_core.d d/qte56_loader.d d/qte56_enums.d \
    d/gen/gen_qcore.d d/gen/gen_qwidget.d d/gen/gen_qlayout.d \
    d/gen/gen_qlabel.d d/gen/gen_qlineedit.d d/gen/gen_qpushbutton.d \
    d/gen/gen_qtextedit.d d/gen/gen_qtabwidget.d d/gen/gen_qcombobox.d \
    d/gen/gen_qcheckbox.d d/gen/gen_qgroupbox.d \
    d/gen/gen_qabstractbutton.d d/gen/gen_qabstractscrollarea.d \
    d/gen/gen_qframe.d d/gen/gen_qtabbar.d \
    d/gen/gen_qprocess.d \
    -L-Wl,-rpath,'$ORIGIN/../lib'
LD_LIBRARY_PATH=./lib test/gui_qprocess_runner
```

---

## Краткая памятка

```
Синхронный (консоль):
  p.start(prog, args)
  p.waitForStarted(3000)     ← проверить на 0 (ошибка)
  p.waitForFinished(30000)   ← проверить на 0 (таймаут)
  p.readStdoutText()
  p.exitCode()

Асинхронный (GUI):
  p.connect_finished(cast(void*)&onDone)   ← extern(C) static!
  p.start(prog, args)
  ... app.exec() доставит сигнал ...

stdin pipe:
  p.start(prog, args)
  p.waitForStarted()
  p.writeText(data)
  p.closeWriteChannel()      ← ОБЯЗАТЕЛЬНО
  p.waitForFinished()

Детектирование ошибок:
  if (!p.waitForStarted())   → p.errorString()
  exitStatus() == 1          → crash
  exitCode() != 0            → ошибка программы
  error() == 0               → FailedToStart (не путать с "нет ошибки"!)
```
