# QTE56 — Руководство по работе с сетью для AI

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Назначение: справочник для ChatGPT, DeepSeek и других AI-систем по написанию
> D-кода с использованием сетевых возможностей QTE56 (Qt 5.13.2 bindings for D).
>
> Компиляция: `dmd -m32 -i myapp.d -Id -Id/gen -of=myapp.exe`  
> Runtime: `set PATH=./dll;%PATH%`

---

## Содержание

1. [Два уровня API](#два-уровня-api)
2. [Уровень 1 — net_utils (рекомендуется)](#уровень-1--net_utils)
3. [Уровень 2 — QNetworkAccessManager (низкий уровень)](#уровень-2--qnetworkaccessmanager)
4. [QNetworkReply — сигналы и методы](#qnetworkreply)
5. [QUrl и QNetworkRequest](#qurl-и-qnetworkrequest)
6. [SSL и заголовки ответа](#ssl-и-заголовки-ответа)
7. [Типовые паттерны](#типовые-паттерны)
8. [Правильные сигнатуры коллбэков](#правильные-сигнатуры-коллбэков)
9. [Критические Gotchas](#критические-gotchas)
10. [DLL и импорты](#dll-и-импорты)

---

## Два уровня API

| Уровень | Модуль | Когда использовать |
|---------|--------|--------------------|
| Высокий | `net_utils.d` | Простые GET/POST в `void main()` или GUI-коде вне ESlot |
| Низкий  | `gen_qnetwork.d` | Async, несколько запросов, нужны заголовки ответа, прогресс |

---

## Уровень 1 — net_utils

### Импорт

```d
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qnetwork;    // нужен net_utils
import gen_qbytearray;  // нужен net_utils
import net_utils;       // httpGet / httpPost / httpFetch / httpGetBytes
```

### httpGet — простейший GET

```d
// Возвращает тело ответа как строку UTF-8.
// При ошибке или таймауте возвращает "".
string body = httpGet("https://api.example.com/data");

// С явным таймаутом (мс)
string body = httpGet("https://api.example.com/data", 15_000);
```

### httpPost — POST с JSON

```d
// Отправить JSON, получить ответ
string resp = httpPost(
    "https://api.example.com/items",
    `{"name":"test","value":42}`,
    "application/json"   // Content-Type (по умолчанию "application/json")
);

// POST form-data
string resp = httpPost(
    "https://example.com/form",
    "username=test&password=secret",
    "application/x-www-form-urlencoded"
);
```

### httpGetBytes — скачать бинарные данные

```d
ubyte[] png = httpGetBytes("https://example.com/logo.png");
import std.file : write;
write("logo.png", png);
```

### httpFetch — полный контроль

```d
// Сигнатура:
// HttpResponse httpFetch(url, method, body, headers, contentType, timeoutMs)

// GET с Bearer-токеном
string[string] hdrs;
hdrs["Authorization"] = "Bearer my-secret-token";
hdrs["Accept"]        = "application/json";
auto res = httpFetch("https://api.example.com/data",
    "GET", "", hdrs, "", 15_000);

// Проверка результата
if (res.timedOut) {
    writeln("Timeout!");
} else if (res.errorCode != 0) {
    writeln("Network error: ", res.errorStr);
} else if (res.statusCode != 200) {
    writeln("HTTP error: ", res.statusCode);
} else {
    writeln("OK: ", res.body);
}

// PUT-запрос
auto putRes = httpFetch("https://api.example.com/item/1",
    "PUT", `{"name":"updated"}`, null, "application/json");

// DELETE
auto delRes = httpFetch("https://api.example.com/item/1", "DELETE");
```

### Структура HttpResponse

```d
struct HttpResponse {
    int    statusCode;  // 200, 404, 500 и т.д.; 0 при ошибке/таймауте
    string body;        // тело ответа UTF-8
    string errorStr;    // описание сетевой ошибки Qt (пустое при успехе)
    int    errorCode;   // код ошибки QNetworkReply::NetworkError (0 = OK)
    bool   timedOut;    // true если истёк таймаут
}
```

### Полный пример с net_utils

```d
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qnetwork;
import gen_qbytearray;
import net_utils;
import std.stdio : writeln, writefln;
import core.memory : GC;

void main() {
    LoadQt("./dll");
    auto app = new QApplication();

    // Простой GET
    string json = httpGet("https://httpbin.org/get");
    writefln("Status: 200 (no error check), body: %d bytes", json.length);

    // POST с проверкой ошибок
    auto res = httpFetch("https://httpbin.org/post",
        "POST", `{"test":1}`, null, "application/json");

    if (!res.timedOut && res.errorCode == 0 && res.statusCode == 200)
        writeln("POST OK: ", res.body.length, " bytes");
    else
        writeln("POST failed: ", res.errorStr);

    GC.collect();
    app.deleteApp();
}
```

---

## Уровень 2 — QNetworkAccessManager

Используется для:
- Асинхронных запросов (не блокирует UI)
- Нескольких параллельных запросов
- Потокового чтения (`readyRead`)
- Прогресса загрузки

### Минимальный async-запрос

```d
import gen_qnetwork;
import gen_qbytearray;

__gshared QApplication g_app;
__gshared bool g_done;
__gshared string g_body;

// ВАЖНО: сигнатура connect_finished менеджера — три параметра
extern(C) void onFinished(void* dthis, int n, void* replyPtr) {
    auto reply = QNetworkReply.wrap(replyPtr);
    g_body = reply.readAllString();
    g_done = true;
    reply.deleteLater();
    g_app.quit();   // выйти из event loop
}

void main() {
    LoadQt("./dll");
    g_app = new QApplication();

    auto mgr = new QNetworkAccessManager(null);
    mgr.connect_finished(null, 0, cast(void*)&onFinished);

    auto req = new QNetworkRequest("https://httpbin.org/get");
    req.setRawHeader("Accept", "application/json");
    req.setFollowRedirects(true);

    auto reply = mgr.get(req);   // запуск, НЕ блокирует

    g_app.exec();   // event loop — ждём onFinished

    import std.stdio : writeln;
    writeln(g_body.length, " bytes received");

    GC.collect();
    g_app.deleteApp();
}
```

### POST через QNetworkAccessManager

```d
// Вариант A: через QByteArray (ручное управление)
auto req = new QNetworkRequest("https://httpbin.org/post");
req.setRawHeader("Content-Type", "application/json");
req.setFollowRedirects(true);

auto body = new QByteArray(`{"key":"value"}`);
auto reply = mgr.post(req, body);
body.destroy();   // Qt скопировал данные — можно удалять

// Вариант B: через postString (удобная обёртка)
auto reply = mgr.postString(req, `{"key":"value"}`);
```

### PUT и DELETE

```d
// PUT
auto ba = new QByteArray(`{"updated":true}`);
auto reply = mgr.put(req, ba);
ba.destroy();

// DELETE
auto reply = mgr.deleteResource(req);

// HEAD (только заголовки, без тела)
auto reply = mgr.head(req);
```

---

## QNetworkReply

`QNetworkReply` всегда принадлежит Qt (создаётся `mgr.get/post/...`).  
**Обязательно вызывать `deleteLater()` после окончания работы с reply.**

### Методы

```d
auto reply = QNetworkReply.wrap(ptr);   // оборачиваем из коллбэка

// Чтение данных (только после isFinished() == true)
string  text  = reply.readAllString(); // всё тело как UTF-8 строка
QByteArray ba = reply.readAll();       // всё тело как QByteArray
                                       // ba нужно destroy() после использования

// Мета-информация
int  code  = reply.statusCode();    // HTTP статус (200, 404, ...)
int  err   = reply.error();         // сетевая ошибка (0 = OK)
string msg = reply.errorString();   // текст ошибки (пустой при error()==0)
string url = reply.url();           // финальный URL (после редиректов)
bool done  = reply.isFinished();    // завершён ли запрос
int  avail = reply.bytesAvailable();// байт в буфере прямо сейчас

// Заголовки ответа
string ct = reply.rawHeader("Content-Type");    // "application/json"
string cl = reply.rawHeader("Content-Length");  // "1234"
string[] all = reply.rawHeaderList();           // все имена заголовков

// Управление жизнью
reply.deleteLater();  // ОБЯЗАТЕЛЬНО после использования
reply.abort();        // прервать незавершённый запрос
```

### Сигналы QNetworkReply

```d
// Каждый сигнал: connect_*(dthis, n, cb)
// dthis — произвольный указатель, передаётся первым в коллбэк
// n     — произвольный int-тег, передаётся вторым в коллбэк

// Запрос завершён (успех ИЛИ ошибка)
reply.connect_finished(null, 0, cast(void*)&onReplyDone);
// extern(C) void onReplyDone(void* dthis, int n)

// Новые данные доступны (может срабатывать много раз)
reply.connect_readyRead(null, 0, cast(void*)&onData);
// extern(C) void onData(void* dthis, int n)

// Ошибка сети или протокола
reply.connect_errorOccurred(null, 0, cast(void*)&onError);
// extern(C) void onError(void* dthis, int n, int errorCode)

// Прогресс загрузки
reply.connect_downloadProgress(null, 0, cast(void*)&onProgress);
// extern(C) void onProgress(void* dthis, int n, long received, long total)
// total == -1 если сервер не указал Content-Length

// Прогресс отправки (для POST/PUT с большим телом)
reply.connect_uploadProgress(null, 0, cast(void*)&onUpload);
// extern(C) void onUpload(void* dthis, int n, long sent, long total)

// SSL-ошибки (вызывается ДО отправки — можно вызвать ignoreSslErrors)
reply.connect_sslErrors(null, 0, cast(void*)&onSsl);
// extern(C) void onSsl(void* dthis, int n, int errorCount)
```

### Сигнал QNetworkAccessManager.connect_finished

```d
// Срабатывает на ЛЮБОЙ завершённый reply этого менеджера
// Коллбэк получает указатель на reply — можно идентифицировать запрос
mgr.connect_finished(null, 0, cast(void*)&onMgrDone);
// extern(C) void onMgrDone(void* dthis, int n, void* replyPtr)
// ВНУТРИ: auto reply = QNetworkReply.wrap(replyPtr);
```

---

## QUrl и QNetworkRequest

### QUrl

```d
auto url = new QUrl("https://api.example.com:8080/path?q=test");
// url принадлежит D — будет удалён при выходе из scope

bool valid = url.isValid();    // синтаксическая проверка
string s   = url.scheme();     // "https"
string h   = url.host();       // "api.example.com"
string p   = url.path();       // "/path"
int    port= url.port();       // 8080 (-1 если не задан)
string str = url.toString();   // полный URL

// Уничтожить явно (если не scope)
destroy(url);
```

### QNetworkRequest

```d
auto req = new QNetworkRequest("https://api.example.com/data");
// req принадлежит D — Qt копирует при вызове get/post

// Заголовки (строка = ASCII, Qt обрабатывает в ISO-8859-1)
req.setRawHeader("Authorization", "Bearer my-token");
req.setRawHeader("Accept",        "application/json");
req.setRawHeader("User-Agent",    "MyApp/1.0");
req.setRawHeader("X-Custom",      "value");

// Автоматически следовать редиректам
req.setFollowRedirects(true);  // рекомендуется всегда

// Получить текущий URL запроса
string url = req.url();

// Уничтожить явно
destroy(req);
```

---

## SSL и заголовки ответа

### Настройка SSL

```d
// QTE56 использует SSL из Qt — отдельного OpenSSL устанавливать не нужно
// Windows: libssl-1_1.dll + libcrypto-1_1.dll должны быть рядом с exe
// Linux: системный libssl подключается автоматически

// Игнорировать ошибки SSL-сертификата (только для отладки!)
reply.ignoreSslErrors();

// Обработать SSL-ошибки программно
reply.connect_sslErrors(null, 0, cast(void*)&onSslErr);
extern(C) void onSslErr(void* dthis, int n, int errCount) {
    // Вызвать ignoreSslErrors() ЗДЕСЬ чтобы продолжить запрос
    // reply.ignoreSslErrors();   // нужно иметь ссылку на reply
}
```

### Список всех заголовков ответа

```d
extern(C) void onFinished(void* dthis, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);

    // Конкретный заголовок
    string ct = reply.rawHeader("Content-Type");
    string cl = reply.rawHeader("Content-Length");
    string srv= reply.rawHeader("Server");

    // Все заголовки
    string[] headers = reply.rawHeaderList();
    foreach (name; headers)
        writefln("%s: %s", name, reply.rawHeader(name));

    reply.deleteLater();
}
```

### Системный прокси

```d
mgr.setUseSystemProxy();
// Linux:   читает http_proxy / https_proxy
// Windows: использует настройки IE / WinINET
```

---

## Типовые паттерны

### Паттерн 1: Синхронный HTTP в GUI-приложении

```d
// Правильно: вызывать httpGet из обработчика кнопки
// НО не из ESlot-коллбэка! (см. Gotchas)

// Способ: через QTimer на 0 мс (single shot) — отложенный вызов из event loop
__gshared QTimer g_deferTimer;
__gshared ESlot  g_deferSlot;

extern(C) void onBtnFetch(void* dt, int n, int c) {
    // НЕЛЬЗЯ вызывать httpGet здесь — это ESlot!
    // Решение: запустить одноразовый таймер на 0 мс
    if (g_deferTimer is null) {
        g_deferTimer = new QTimer(cast(void*)null);
        g_deferTimer.setSingleShot(true);
        g_deferSlot = new ESlot(g_deferTimer.getWH());
        g_deferSlot.set(cast(void*)&doFetch);
        g_deferTimer.connect_timeout(g_deferSlot);
    }
    g_deferTimer.start(0);
}

extern(C) void doFetch(void* dt, int n) {
    // Здесь вызывается из event loop — httpGet безопасен
    string data = httpGet("https://api.example.com/data");
    g_textEdit.setText(data);
}
```

### Паттерн 2: Async в GUI с progress-баром

```d
__gshared QProgressBar g_progress;
__gshared QNetworkAccessManager g_mgr;
__gshared ESlot[4] g_slots;
__gshared int g_slotIdx = 0;

// Прогресс (сигнал reply)
extern(C) void onProgress(void* dthis, int n, long rx, long total) {
    if (total > 0)
        g_progress.setValue(cast(int)(rx * 100 / total));
}

// Завершение (сигнал менеджера)
extern(C) void onDone(void* dthis, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);
    if (reply.error() == 0)
        g_textEdit.setText(reply.readAllString());
    else
        QMessageBox.critical(g_win.getWH(), "Error", reply.errorString());
    reply.deleteLater();
    g_progress.setValue(0);
}

void startDownload(string url) {
    if (g_mgr is null) {
        g_mgr = new QNetworkAccessManager(null);
        g_mgr.connect_finished(null, 0, cast(void*)&onDone);
    }
    auto req = new QNetworkRequest(url);
    req.setFollowRedirects(true);
    auto reply = g_mgr.get(req);
    reply.connect_downloadProgress(null, 0, cast(void*)&onProgress);
    g_progress.setValue(0);
}
```

### Паттерн 3: Несколько запросов с идентификацией

```d
// Используем int n в connect_finished как ID запроса
__gshared QNetworkReply[int] g_pending;  // n -> reply
__gshared int g_nextId = 0;

extern(C) void onAnyDone(void* dthis, int n, void* ptr) {
    // n — это ID переданный при подключении сигнала
    auto reply = QNetworkReply.wrap(ptr);
    switch (n) {
        case 1: handleUserData(reply.readAllString()); break;
        case 2: handlePosts(reply.readAllString()); break;
        default: break;
    }
    reply.deleteLater();
}

void fetchBoth() {
    // Один менеджер на все запросы
    auto mgr = new QNetworkAccessManager(null);
    mgr.connect_finished(null, 1, cast(void*)&onAnyDone);  // n=1 для первого
    mgr.connect_finished(null, 2, cast(void*)&onAnyDone);  // n=2 для второго
    // ВНИМАНИЕ: connect_finished регистрирует КАЖДЫЙ вызов
    // Лучше: отдельный менеджер или проверка URL внутри коллбэка
}
```

### Паттерн 4: Потоковое чтение (chunked)

```d
__gshared string g_buffer;

extern(C) void onReadyRead(void* dthis, int n) {
    // Вызывается при каждом новом порции данных
    // Но QNetworkReply в QTE56 буферизует всё — проще читать в finished
    // Этот сигнал полезен для очень больших файлов
}

extern(C) void onStreamDone(void* dthis, int n) {
    // Читать ВСЁ в finished — проще и надёжнее
    // dthis = указатель на reply переданный при connect_finished reply
}
```

### Паттерн 5: Запрос с таймаутом через QTimer

```d
__gshared QNetworkReply g_currentReply;
__gshared QTimer g_timeoutTimer;

extern(C) void onTimeout(void* dt, int n) {
    if (g_currentReply !is null && !g_currentReply.isFinished()) {
        g_currentReply.abort();
    }
}

void fetchWithTimeout(string url, int ms) {
    auto req = new QNetworkRequest(url);
    g_currentReply = g_mgr.get(req);

    // Запустить таймер
    if (g_timeoutTimer is null) {
        g_timeoutTimer = new QTimer(cast(void*)null);
        g_timeoutTimer.setSingleShot(true);
        auto sl = new ESlot(g_timeoutTimer.getWH());
        sl.set(cast(void*)&onTimeout);
        g_timeoutTimer.connect_timeout(sl);
    }
    g_timeoutTimer.start(ms);
}
```

---

## Правильные сигнатуры коллбэков

> **КРИТИЧНО**: неправильная сигнатура = crash без объяснений.

```d
// ── QNetworkAccessManager.connect_finished ───────────────────────────────
// Получает указатель на reply — оборачивать через wrap()
extern(C) void onMgrFinished(void* dthis, int n, void* replyPtr) { }
// вызов: mgr.connect_finished(myObj, 42, cast(void*)&onMgrFinished);

// ── QNetworkReply.connect_finished ───────────────────────────────────────
// Запрос завершён — данные уже доступны
extern(C) void onReplyDone(void* dthis, int n) { }
// вызов: reply.connect_finished(myObj, 0, cast(void*)&onReplyDone);

// ── QNetworkReply.connect_readyRead ──────────────────────────────────────
// Новые данные доступны для чтения (может быть много раз)
extern(C) void onReadyRead(void* dthis, int n) { }

// ── QNetworkReply.connect_errorOccurred ──────────────────────────────────
// Ошибка сети или протокола
extern(C) void onError(void* dthis, int n, int errorCode) { }
// errorCode: 1=ConnectionRefused, 2=RemoteHostClosed, 3=HostNotFound, и т.д.

// ── QNetworkReply.connect_downloadProgress ───────────────────────────────
// Прогресс загрузки — long (64-бит на Win32 и Linux64)
extern(C) void onDownload(void* dthis, int n, long received, long total) { }
// total == -1 если сервер не прислал Content-Length

// ── QNetworkReply.connect_uploadProgress ─────────────────────────────────
// Прогресс отправки тела запроса
extern(C) void onUpload(void* dthis, int n, long sent, long total) { }

// ── QNetworkReply.connect_sslErrors ──────────────────────────────────────
extern(C) void onSslErrors(void* dthis, int n, int errorCount) { }
```

### Сводная таблица сигнатур

| Метод подключения | Сигнатура коллбэка |
|-------------------|--------------------|
| `mgr.connect_finished` | `(void* dt, int n, void* replyPtr)` |
| `reply.connect_finished` | `(void* dt, int n)` |
| `reply.connect_readyRead` | `(void* dt, int n)` |
| `reply.connect_errorOccurred` | `(void* dt, int n, int code)` |
| `reply.connect_downloadProgress` | `(void* dt, int n, long rx, long total)` |
| `reply.connect_uploadProgress` | `(void* dt, int n, long sent, long total)` |
| `reply.connect_sslErrors` | `(void* dt, int n, int count)` |

---

## Критические Gotchas

### ❌ GOTCHA 1: httpGet / httpPost НЕЛЬЗЯ вызывать из ESlot-коллбэка

`net_utils.httpGet` внутри крутит `processEvents` в цикле.  
Если вызвать из ESlot-коллбэка — Qt снова войдёт в этот же ESlot → **deadlock / crash**.

```d
// НЕПРАВИЛЬНО:
extern(C) void onBtnClick(void* dt, int n, int c) {
    string data = httpGet("https://api.example.com");  // CRASH!
}

// ПРАВИЛЬНО — отложить через QTimer на 0 мс (single shot):
__gshared QTimer g_deferTimer;
__gshared ESlot  g_deferSlot;

extern(C) void onBtnClick(void* dt, int n, int c) {
    if (g_deferTimer is null) {
        g_deferTimer = new QTimer(cast(void*)null);
        g_deferTimer.setSingleShot(true);
        g_deferSlot = new ESlot(g_deferTimer.getWH());
        g_deferSlot.set(cast(void*)&doFetch);
        g_deferTimer.connect_timeout(g_deferSlot);
    }
    g_deferTimer.start(0);
}
extern(C) void doFetch(void* dt, int n) {
    string data = httpGet("https://api.example.com");  // OK
    g_result.setText(data);
}

// ИЛИ использовать async QNetworkAccessManager
```

### ❌ GOTCHA 2: net_utils не потокобезопасен

```d
// НЕПРАВИЛЬНО: два httpGet одновременно из разных потоков
// Используют одни глобальные переменные _done, _body, _status

// ПРАВИЛЬНО: только один вызов за раз, либо async через QNAM
```

### ❌ GOTCHA 3: забыть deleteLater() → утечка памяти

```d
// НЕПРАВИЛЬНО:
extern(C) void onDone(void* dt, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);
    string body = reply.readAllString();
    // НЕ ВЫЗВАЛИ deleteLater — утечка!
}

// ПРАВИЛЬНО:
extern(C) void onDone(void* dt, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);
    string body = reply.readAllString();
    reply.deleteLater();  // ОБЯЗАТЕЛЬНО
}
```

### ❌ GOTCHA 4: читать данные ДО завершения запроса

```d
// НЕПРАВИЛЬНО:
auto reply = mgr.get(req);
string data = reply.readAllString();  // ПУСТО — запрос ещё не завершён!

// ПРАВИЛЬНО: читать только в коллбэке finished
extern(C) void onDone(void* dt, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);
    string data = reply.readAllString();  // теперь данные готовы
    reply.deleteLater();
}
```

### ❌ GOTCHA 5: неправильные параметры connect_finished

```d
// У менеджера и reply разные сигнатуры коллбэков!

// mgr.connect_finished — получает replyPtr (void*)
extern(C) void onMgr(void* dt, int n, void* replyPtr) { ... }  // ✓

// reply.connect_finished — не получает replyPtr
extern(C) void onReply(void* dt, int n) { ... }  // ✓
extern(C) void onReply(void* dt, int n, void* x) { ... }  // ✗ crash
```

### ❌ GOTCHA 6: errorOccurred стреляет ДО finished

```d
// После errorOccurred сигнал finished ТОЖЕ сработает.
// НЕ вызывайте deleteLater() дважды!

__gshared bool g_deleted = false;

extern(C) void onError(void* dt, int n, int code) {
    // Не вызываем deleteLater здесь — ждём finished
}

extern(C) void onFinished(void* dt, int n, void* ptr) {
    auto reply = QNetworkReply.wrap(ptr);
    if (reply.error() != 0)
        writeln("Error: ", reply.errorString());
    else
        writeln("OK: ", reply.readAllString());
    reply.deleteLater();  // один раз, в finished
}
```

### ⚠️ Цикл событий обязателен для async

```d
// QNetworkAccessManager ТРЕБУЕТ запущенного event loop
// Либо app.exec(), либо QCoreApplication.processEvents() в цикле

// Для консольных программ:
while (!g_done) {
    (cast(extern(C) void function())pFunQt[53])();  // processEvents
}
```

---

## DLL и импорты

### Обязательная структура импортов

```d
// Минимум для net_utils:
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qnetwork;    // QUrl, QNetworkRequest, QNetworkReply, QNetworkAccessManager
import gen_qbytearray;  // QByteArray (нужен для POST-тела)
import net_utils;       // httpGet, httpPost, httpFetch, httpGetBytes

// Для прямой работы с QNAM (без net_utils):
// те же, без net_utils
```

### DLL (Windows)

```
./dll/qte56_network.dll          — основная DLL с Qt-биндингами
./dll/Qt5Network.dll             — Qt Network (из Qt 5.13.2 MinGW)
./dll/libssl-1_1.dll             — OpenSSL (для HTTPS)
./dll/libcrypto-1_1.dll          — OpenSSL (для HTTPS)
```

Путь к DLL:
```bat
set PATH=./dll;%PATH%
```

### Инициализация (обязательный порядок)

```d
void main() {
    LoadQt("./dll");          // 1. Загрузить все QTE56 DLL
    auto app = new QApplication();  // 2. Создать Qt-приложение
    // ... теперь можно работать с сетью ...
    GC.collect();
    app.deleteApp();
}
```

### Компиляция

```bat
dmd -m32 -i myapp.d -Id -Id/gen -of=myapp.exe
```

---

## Коды ошибок QNetworkReply::NetworkError

| Код | Константа Qt | Описание |
|-----|-------------|----------|
| 0 | NoError | Успех |
| 1 | ConnectionRefusedError | Сервер отверг соединение |
| 2 | RemoteHostClosedError | Сервер закрыл соединение |
| 3 | HostNotFoundError | Хост не найден (DNS) |
| 4 | TimeoutError | Таймаут соединения |
| 5 | OperationCanceledError | Запрос отменён через abort() |
| 6 | SslHandshakeFailedError | Ошибка SSL-рукопожатия |
| 99 | UnknownNetworkError | Неизвестная сетевая ошибка |
| 101 | ContentNotFoundError | HTTP 404 |
| 201 | AuthenticationRequiredError | HTTP 401/407 |
| 299 | UnknownContentError | Неизвестная ошибка контента |
| 301 | ProtocolInvalidOperationError | Неподдерживаемая операция |

---

## Быстрая шпаргалка

```d
// ── Самый простой GET ─────────────────────────────────────────────────────
string body = httpGet("https://example.com/api");

// ── GET с токеном ─────────────────────────────────────────────────────────
string[string] h; h["Authorization"] = "Bearer TOKEN";
auto res = httpFetch("https://example.com/api", "GET", "", h);
if (res.errorCode == 0 && res.statusCode == 200) use(res.body);

// ── POST JSON ─────────────────────────────────────────────────────────────
string resp = httpPost("https://example.com/api", `{"key":"val"}`);

// ── Async GET (не блокирует UI) ───────────────────────────────────────────
auto mgr = new QNetworkAccessManager(null);
mgr.connect_finished(null, 0, cast(void*)&onDone);
mgr.get(new QNetworkRequest("https://example.com"));
// extern(C) void onDone(void* dt, int n, void* ptr) { auto r=wrap(ptr); ... r.deleteLater(); }

// ── Бинарные данные ───────────────────────────────────────────────────────
ubyte[] data = httpGetBytes("https://example.com/file.bin");
```
