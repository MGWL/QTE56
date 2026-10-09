# Руководство по сетевым модулям QTE56 для D

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [AI_NETWORK_GUIDE.md](../AI_NETWORK_GUIDE.md)

**Версия:** 1.0
**Платформы:** Windows 32-bit (dmd -m32), Linux 64-bit (ldc2)
**Дата:** 2026-03-20

---

## Содержание

1. [Обзор архитектуры](#1-обзор-архитектуры)
2. [Модуль json.d — работа с JSON](#2-модуль-jsond)
3. [Модуль net_utils.d — синхронный HTTP через Qt](#3-модуль-net_utilsd)
4. [Модуль curl_utils.d — HTTP/FTP/SFTP через libcurl](#4-модуль-curl_utilsd)
5. [Модуль gen_qnetwork.d — низкоуровневый Qt Network API](#5-модуль-gen_qnetworkd)
6. [Выбор подхода: net_utils vs curl_utils](#6-выбор-подхода)
7. [Типичные задачи: рецепты](#7-типичные-задачи-рецепты)
8. [Обработка ошибок](#8-обработка-ошибок)
9. [Зависимости и установка](#9-зависимости-и-установка)
10. [Сборка проектов с сетевыми модулями](#10-сборка-проектов)
11. [Частые ошибки и их причины](#11-частые-ошибки-и-их-причины)

---

## 1. Обзор архитектуры

В проекте QTE56 есть **два независимых** способа работы с сетью:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Ваш D-код                                │
├──────────────────────────┬──────────────────────────────────────┤
│   ПОДХОД 1: Qt Network   │   ПОДХОД 2: libcurl                  │
│                          │                                      │
│  net_utils.d             │  curl_utils.d                        │
│  (httpGet/Post/Fetch)    │  (CurlSession)                       │
│        │                 │        │                             │
│  gen_qnetwork.d          │  gen_qcurl.d                         │
│  (QUrl, QNetReq...)      │  (pFunQt[20046..20072])              │
│        │                 │        │                             │
│  qte56_network.dll       │  qte56_curl.dll                      │
│  (Qt 5 Network)          │  (загружает libcurl.dll/so)          │
│        │                 │        │                             │
│  Qt5Network.dll          │  libcurl.dll / libcurl.so.4          │
│  (Qt сетевой стек)       │  libssl, libssh2 (если SFTP)        │
└──────────────────────────┴──────────────────────────────────────┘

Общий вспомогательный модуль:
  json.d  — чистый D, без DLL-зависимостей, парсинг/генерация JSON
```

### Что требуется для обоих подходов

- `d/qte56_core.d` — таблица функций `pFunQt[25000]`
- `d/qte56_loader.d` — `LoadQt()`, `registerModule()`
- `d/gen/gen_qcore.d` — `QApplication`, базовые типы
- Вызов `LoadQt("./dll")` **до** создания любых объектов

### Ключевые отличия

| Критерий              | net_utils (Qt)           | curl_utils (libcurl)      |
|-----------------------|--------------------------|---------------------------|
| Протоколы             | HTTP, HTTPS              | HTTP, HTTPS, FTP, FTPS, SFTP, SCP |
| Нужен QApplication    | **Да** (processEvents)   | **Нет** (но LoadQt нужен) |
| Синхронность          | Spin-loop processEvents  | Настоящая блокировка      |
| SFTP / FTP            | ✗                        | ✓                         |
| Скачивание в файл     | Только через тело ответа | Прямо в файл (эффективно) |
| Загрузка файла        | ✗                        | ✓ (FTP PUT, SFTP)         |
| SSL без сертификата   | Через ignoreSslErrors()  | Через skipSsl()           |
| Доп. DLL              | qte56_network.dll        | qte56_curl.dll + libcurl  |

---

## 2. Модуль json.d

**Файл:** `d/json.d`
**Зависимости:** только стандартная библиотека D, без DLL.
**Подключение:** `import json;`

### 2.1. Типы данных

```d
// Тип значения (метка)
enum JsonType : ubyte { Null, Bool, Number, String, Array, Object }

// Псевдонимы для удобства
alias JsonObject = JsonValue[string];   // D ассоциативный массив
alias JsonArray  = JsonValue[];         // D динамический массив

// Универсальное значение
struct JsonValue { ... }
```

`JsonValue` хранит любое JSON-значение. Внутри — tagged union из полей
`bool _b`, `double _n`, `string _s`, `JsonArray _arr`, `JsonObject _obj`.

### 2.2. Создание значений

#### Конструкторы — примитивы

```d
JsonValue n  = JsonValue(null);      // JSON null
JsonValue b  = JsonValue(true);      // JSON true
JsonValue i  = JsonValue(42);        // JSON 42  (int → double)
JsonValue f  = JsonValue(3.14);      // JSON 3.14
JsonValue s  = JsonValue("hello");   // JSON "hello"
```

#### Конструктор — массив через jarray()

`jarray()` принимает любое количество аргументов любых D-типов
(автоматически конвертирует в `JsonValue`):

```d
// Простой массив
auto arr = jarray(1, "два", true, 3.14, JsonValue(null));
// → [1, "два", true, 3.14, null]

// Вложенный массив
auto nested = jarray(1, jarray(2, 3), "конец");
// → [1, [2, 3], "конец"]
```

#### Конструктор — объект через jobject()

`jobject()` принимает чередующиеся пары `ключ (string), значение (любой тип)`:

```d
// Простой объект
auto obj = jobject("name", "Alice", "age", 30, "active", true);
// → {"name":"Alice","age":30,"active":true}

// Вложенный объект
auto user = jobject(
    "id",      1001,
    "name",    "Иван",
    "address", jobject("city", "Москва", "zip", "101000"),
    "scores",  jarray(85, 92, 78)
);
```

#### Прямое создание массива и объекта через D-типы

```d
// Массив через JsonArray (D dynamic array)
JsonArray arr;
arr ~= JsonValue(1);
arr ~= JsonValue("два");
JsonValue jArr = JsonValue(arr);

// Объект через JsonObject (D AA)
JsonObject obj;
obj["key"] = JsonValue("value");
obj["num"] = JsonValue(42);
JsonValue jObj = JsonValue(obj);
```

### 2.3. Сериализация (JsonValue → string)

```d
auto v = jobject("a", 1, "b", jarray(2, 3));

// Компактная (без пробелов) — для передачи по сети
string compact = toJsonCompact(v);
// → {"a":1,"b":[2,3]}

// С отступами — для вывода человеку (2 пробела по умолчанию)
string pretty = toJsonPretty(v);
// → {
//      "a": 1,
//      "b": [
//        2,
//        3
//      ]
//    }

// Настраиваемый отступ (4 пробела)
string pretty4 = toJsonPretty(v, 4);

// Через toString() (компактный)
string s = v.toString();
```

**Особенности сериализации:**
- Целые числа без дробной части выводятся как `42`, а не `42.0`
- `NaN` и `Infinity` сериализуются как `null` (JSON их не поддерживает)
- Спецсимволы в строках автоматически экранируются: `"`, `\`, `\n`, `\r`, `\t` и т.д.
- Управляющие символы `< 0x20` выводятся как `\uXXXX`

### 2.4. Парсинг (string → JsonValue)

```d
// Вариант 1: с исключением при ошибке
try {
    JsonValue v = parseJson(`{"name":"Alice","scores":[85,92]}`);
} catch (JsonParseException e) {
    writefln("Ошибка: %s (строка %d, столбец %d)", e.msg, e.line, e.col);
}

// Вариант 2: без исключения — безопаснее в продакшене
JsonValue v;
if (tryParseJson(responseBody, v)) {
    // парсинг успешен
} else {
    writeln("Не удалось разобрать JSON");
}
```

### 2.5. Чтение значений

#### Проверка типа

```d
if (v.isObject) { ... }
if (v.isArray)  { ... }
if (v.isString) { ... }
if (v.isNumber) { ... }
if (v.isBool)   { ... }
if (v.isNull)   { ... }

// Или через тип
if (v.type == JsonType.Object) { ... }
```

#### Доступ к значению — жёсткий (throws assert при несовпадении типа)

```d
bool   b = v.boolean;   // только если isBool()
double d = v.number;    // только если isNumber()
long   i = v.integer;   // только если isNumber() — округляет до long
string s = v.str;       // только если isString()
JsonArray  arr = v.array;   // только если isArray()
JsonObject obj = v.object;  // только если isObject()
```

#### Доступ к значению — мягкий (с fallback, без исключения)

```d
// Безопасное чтение: возвращает def если тип не совпадает
string name = v.get!string("неизвестно");
int    age  = v.get!int(0);
bool   flag = v.get!bool(false);
double val  = v.get!double(0.0);

// Чтение поля объекта с fallback (сочетание ["key"] и get!T)
// ТОЛЬКО для JsonValue.isObject — поле объекта + тип за один шаг:
string city = v.get!string("city", "Москва");
int    code = v.get!int("code", 0);
```

#### Доступ по ключу и индексу

```d
// Объект: jv["ключ"] возвращает ref JsonValue (throws RangeError если нет)
JsonValue nameVal = v["name"];
string name = v["name"].str;

// Массив: jv[index] возвращает ref JsonValue
JsonValue first = arr[0];
string s = arr[2].str;

// Безопасная проверка существования ключа
auto p = "name" in v;   // JsonValue* или null
if (p !is null) {
    writeln(p.str);
}
// Паттерн: проверка + доступ
if (auto p = "error" in v)
    writeln("Ошибка сервера: ", p.str);
```

### 2.6. Перебор элементов

```d
// ── Перебор массива (без индекса) ──
foreach (ref el; v) {           // v должен быть Array
    writeln(el.str);
}

// ── Перебор массива с индексом ──
// Нельзя использовать foreach (i, ref v; jv) напрямую на JsonValue!
// Использовать .array (возвращает D-срез):
foreach (i, ref el; v.array) {
    writefln("[%d] = %s", i, el);
}

// ── Перебор объекта (ключ + значение) ──
// Использовать .object (возвращает D AA):
foreach (key, ref val; v.object) {
    writefln("%s = %s", key, val);
}

// ── Обход вложенной структуры ──
JsonValue root;
tryParseJson(json, root);
foreach (key, ref section; root.object) {
    writefln("Раздел: %s", key);
    foreach (ref item; section) {      // section — Array
        writefln("  %s", item.get!string("?"));
    }
}
```

### 2.7. Модификация

```d
// Изменить поле объекта
v["name"] = JsonValue("Bob");

// Добавить поле в объект
v["newField"] = JsonValue(100);

// Добавить элемент в массив (~= только для isArray)
arr ~= JsonValue("новый элемент");
arr ~= JsonValue(42);

// Изменить элемент массива по индексу
arr[0] = JsonValue("изменённый");

// Длина массива или объекта
size_t n = v.length;
```

### 2.8. Полный пример: парсинг ответа API

```d
import json;

void processApiResponse(string responseBody) {
    JsonValue root;
    if (!tryParseJson(responseBody, root)) {
        writeln("Ответ — не JSON");
        return;
    }

    // Проверяем успешность
    bool ok = root.get!bool("ok", false);
    if (!ok) {
        writeln("API вернул ошибку: ", root.get!string("error", "неизвестно"));
        return;
    }

    // Читаем вложенный объект
    auto data = "data" in root;
    if (data is null) return;

    writeln("ID: ",    data.get!int("id", 0));
    writeln("Имя: ",   data.get!string("name", "?"));
    writeln("Баллы: ", data.get!double("score", 0.0));

    // Перебираем массив
    auto items = "items" in *data;
    if (items && items.isArray) {
        foreach (i, ref item; items.array) {
            writefln("  [%d] %s — %d руб.",
                i,
                item.get!string("title", "?"),
                item.get!int("price", 0));
        }
    }
}
```

---

## 3. Модуль net_utils.d

**Файл:** `d/net_utils.d`
**Зависимости:** `qte56_network.dll`, Qt 5 (`Qt5Network.dll`), `QApplication`.
**Подключение:** `import net_utils;`

### 3.1. Предварительные условия

```d
// ОБЯЗАТЕЛЬНО: LoadQt перед QApplication, QApplication перед сетью
LoadQt("./dll");
auto app = new QApplication("my_app");

// Теперь можно делать запросы
string body = httpGet("https://api.example.com/data");
```

**Почему нужен QApplication?**
`net_utils` использует `QNetworkAccessManager` — асинхронный Qt API.
Синхронность достигается через цикл `QApplication::processEvents()` —
он обрабатывает Qt-события пока запрос не завершится. Без `QApplication`
`processEvents()` не работает.

### 3.2. Структура HttpResponse

```d
struct HttpResponse {
    int    statusCode;  // HTTP-статус (200, 404, 500, 0 при ошибке/таймауте)
    string body;        // тело ответа в UTF-8
    string errorStr;    // описание ошибки Qt (пусто при успехе)
    int    errorCode;   // QNetworkReply::NetworkError (0 = NoError)
    bool   timedOut;    // true если запрос превысил timeoutMs
}
```

**Коды ошибок Qt (`errorCode`):**

| Значение | Константа Qt                  | Описание                           |
|----------|-------------------------------|------------------------------------|
| 0        | NoError                       | Успех                              |
| 1        | ConnectionRefusedError        | Соединение отклонено               |
| 2        | RemoteHostClosedError         | Сервер закрыл соединение           |
| 3        | HostNotFoundError             | Хост не найден (DNS)               |
| 4        | TimeoutError                  | Таймаут на уровне Qt               |
| 5        | OperationCanceledError        | Отменён (abort())                  |
| 6        | SslHandshakeFailedError       | Ошибка SSL-рукопожатия             |
| 99       | UnknownNetworkError           | Неизвестная сетевая ошибка         |
| 201      | ContentNotFoundError          | HTTP 404 через Qt                  |
| 203      | AuthenticationRequiredError   | HTTP 401                           |

### 3.3. Функции

#### httpGet — простой GET

```d
// Минимальный вызов
string body = httpGet("https://api.example.com/users");

// С явным таймаутом (15 секунд)
string body = httpGet("https://api.example.com/users", 15_000);

// Проверка результата
if (body.length == 0) {
    writeln("Ошибка или пустой ответ");
}
```

#### httpPost — POST-запрос

```d
// POST с JSON-телом (Content-Type: application/json по умолчанию)
string resp = httpPost(
    "https://api.example.com/login",
    `{"username":"alice","password":"secret"}`
);

// POST с form-encoded данными
string resp = httpPost(
    "https://api.example.com/form",
    "name=Alice&age=30",
    "application/x-www-form-urlencoded"
);

// С таймаутом
string resp = httpPost(url, jsonBody, "application/json", 20_000);
```

#### httpGetBytes — GET как бинарные данные

```d
// Скачать изображение или бинарный файл
ubyte[] imageData = httpGetBytes("https://example.com/photo.jpg");
if (imageData.length > 0) {
    import std.file : write;
    write("photo.jpg", imageData);
}
```

#### httpFetch — полный контроль

```d
// Все параметры явно
auto res = httpFetch(
    url:         "https://api.example.com/data",
    method:      "DELETE",
    body:        "",
    headers:     ["Authorization": "Bearer token123",
                  "X-Request-Id": "abc-123"],
    contentType: "",
    timeoutMs:   5_000
);

// Анализ результата
if (res.timedOut) {
    writeln("Запрос превысил таймаут");
} else if (res.errorCode != 0) {
    writefln("Сетевая ошибка %d: %s", res.errorCode, res.errorStr);
} else if (res.statusCode != 200) {
    writefln("HTTP %d", res.statusCode);
} else {
    writeln("Успех: ", res.body);
}
```

### 3.4. Пример: GET + разбор JSON

```d
import net_utils;
import json;

void fetchAndParse() {
    auto res = httpFetch("https://httpbin.org/get", "GET", "", null, "", 10_000);

    if (res.timedOut || res.errorCode != 0) {
        writefln("Ошибка: %s", res.timedOut ? "таймаут" : res.errorStr);
        return;
    }

    JsonValue j;
    if (!tryParseJson(res.body, j)) {
        writeln("Не JSON");
        return;
    }

    writeln("URL: ",    j.get!string("url", "?"));
    writeln("Статус: ", res.statusCode);

    // Заголовки запроса (httpbin эхо-сервис возвращает их)
    auto hdrs = "headers" in j;
    if (hdrs && hdrs.isObject) {
        foreach (name, ref val; hdrs.object)
            writefln("  %s: %s", name, val.get!string(""));
    }
}
```

### 3.5. Пример: POST + JSON-ответ

```d
import net_utils;
import json;

void sendOrder() {
    // Формируем тело запроса
    auto payload = jobject(
        "product_id", 42,
        "quantity",   3,
        "comment",    "Срочно"
    );

    string resp = httpPost(
        "https://api.example.com/orders",
        toJsonCompact(payload),   // сериализуем в compact JSON
        "application/json",
        15_000
    );

    if (resp.length == 0) {
        writeln("Нет ответа от сервера");
        return;
    }

    JsonValue j;
    if (!tryParseJson(resp, j)) return;

    int orderId = j.get!int("order_id", 0);
    writefln("Заказ создан, ID=%d", orderId);
}
```

### 3.6. Ограничения net_utils

- **Не потокобезопасен:** использует `__gshared` состояние — только один запрос одновременно.
- **Только HTTP/HTTPS:** для FTP, SFTP используйте `curl_utils.d`.
- **Нет скачивания в файл:** тело ответа всегда в памяти. Для больших файлов — `curl_utils.d`.
- **Нет загрузки файлов:** FTP PUT, SFTP upload — только в `curl_utils.d`.
- **QApplication обязателен:** без него processEvents() не работает.

---

## 4. Модуль curl_utils.d

**Файл:** `d/curl_utils.d`
**Зависимости:** `qte56_curl.dll` (который грузит `libcurl.dll` / `libcurl.so.4`).
**Подключение:** `import curl_utils; import gen_qcurl;`

### 4.1. Предварительные условия

```d
// LoadQt нужен для загрузки qte56_curl.dll
// QApplication НЕ обязателен (но не мешает)
LoadQt("./dll");
// НА WINDOWS: ./dll/libcurl.dll и ./dll/cacert.pem должны существовать
// НА LINUX: apt install libcurl4-openssl-dev (или libcurl4-gnutls-dev)

auto c = new CurlSession();
// Готово!
```

### 4.2. CurlResult — структура результата

```d
struct CurlResult {
    int    statusCode;  // HTTP/FTP статус: 200, 404, 226 (FTP OK) и т.д.
    string body;        // тело ответа UTF-8 (пусто если использовался downloadFile)
    string error;       // описание ошибки libcurl (пусто при успехе)
    int    curlCode;    // CURLcode: 0 = CURLE_OK
    long   bytes;       // байт передано

    bool ok       → curlCode == 0            // нет ошибки libcurl
    bool isHttp2xx → statusCode in [200..299] // HTTP-успех
}
```

**Важное различие `ok` vs `isHttp2xx`:**
- `ok == true` — libcurl выполнил запрос без ошибки соединения
- `isHttp2xx == true` — сервер вернул успешный HTTP-статус

```d
// Сервер вернул 404 — но соединение прошло нормально:
// res.ok == true (curlCode == 0)
// res.isHttp2xx == false (statusCode == 404)
```

**Частые CURLcode (curlCode):**

| Код | Константа            | Причина                                  |
|-----|----------------------|------------------------------------------|
| 0   | CURLE_OK             | Успех                                    |
| 6   | CURLE_COULDNT_RESOLVE_HOST | DNS не разрешил хост               |
| 7   | CURLE_COULDNT_CONNECT | Отказ в соединении (порт закрыт)        |
| 28  | CURLE_OPERATION_TIMEDOUT | Превышен таймаут                    |
| 35  | CURLE_SSL_CONNECT_ERROR | Ошибка SSL-рукопожатия              |
| 60  | CURLE_SSL_CACERT     | Неверный SSL-сертификат (нет в cacert)   |
| 67  | CURLE_LOGIN_DENIED   | Неверный логин/пароль (FTP/SFTP)         |
| 78  | CURLE_REMOTE_FILE_NOT_FOUND | Файл не найден (FTP/SFTP)      |

### 4.3. Fluent-цепочки: принцип работы

Все методы `CurlSession` возвращают `this`, что позволяет
выстраивать цепочки:

```d
auto res = c.reset()
             .url("https://api.example.com/data")
             .header("Authorization", "Bearer token")
             .header("Accept", "application/json")
             .timeout(30)
             .followRedirects(true)
             .execute();
```

**Важно:** `reset()` очищает все опции предыдущего запроса.
Всегда вызывайте `reset()` между разными запросами на одной сессии.

### 4.4. HTTP-запросы

#### GET

```d
auto c = new CurlSession();

// Вариант 1: однострочник (возвращает "" при ошибке)
string body = c.get("https://api.example.com/users");

// Вариант 2: через execute() — полный результат
auto res = c.url("https://api.example.com/users")
             .header("Accept", "application/json")
             .timeout(15)
             .execute();

if (res.ok && res.isHttp2xx) {
    writeln(res.body);
} else {
    writefln("Ошибка: код=%d HTTP=%d: %s",
             res.curlCode, res.statusCode, res.error);
}
```

#### POST с JSON

```d
import json;

auto payload = jobject("name", "Иван", "age", 30);

auto res = c.reset()
             .url("https://api.example.com/users")
             .header("Content-Type", "application/json")
             .header("Accept", "application/json")
             .postBody(toJsonCompact(payload))
             .method("POST")
             .execute();

// Или через однострочник post():
string resp = c.reset().post(
    "https://api.example.com/users",
    toJsonCompact(payload),
    "application/json"
);
```

#### POST с form-encoded

```d
string resp = c.reset().post(
    "https://example.com/login",
    "username=alice&password=secret123",
    "application/x-www-form-urlencoded"
);
```

#### PUT, DELETE, PATCH

```d
// PUT
auto res = c.reset()
             .url("https://api.example.com/users/42")
             .header("Content-Type", "application/json")
             .postBody(`{"name":"новое имя"}`)
             .method("PUT")
             .execute();

// DELETE
auto res = c.reset()
             .url("https://api.example.com/users/42")
             .method("DELETE")
             .execute();

// PATCH
auto res = c.reset()
             .url("https://api.example.com/users/42")
             .header("Content-Type", "application/json")
             .postBody(`{"status":"active"}`)
             .method("PATCH")
             .execute();
```

#### Basic Authentication для HTTP

```d
// HTTP Basic Auth — передаётся в заголовке Authorization
auto res = c.reset()
             .url("https://api.example.com/protected")
             .auth("username", "password")
             .execute();
```

### 4.5. SSL и HTTPS

#### Стандартная ситуация (сертификат в порядке)

По умолчанию `CurlSession` настроен на проверку SSL-сертификата через
`./dll/cacert.pem`. Ничего дополнительного не нужно.

```d
// Просто работает если сертификат сервера в порядке
auto res = c.url("https://example.com").execute();
```

#### Самоподписанный сертификат (тест-серверы)

```d
// ВНИМАНИЕ: только для тестирования! Небезопасно в продакшене.
auto res = c.reset()
             .url("https://self-signed.example.com")
             .skipSsl()       // отключает CURLOPT_SSL_VERIFYPEER и VERIFYHOST
             .execute();
```

#### Другой CA-файл

```d
// Для корпоративных CA или нестандартных хранилищ сертификатов
auto res = c.reset()
             .url("https://internal.corp.example.com")
             .caFile("/etc/ssl/certs/corp-ca.pem")
             .execute();
```

### 4.6. Скачивание файлов

#### HTTP скачивание

```d
// Скачать файл напрямую (без буферизации в памяти)
bool ok = c.reset().download("https://example.com/report.pdf", "./report.pdf");
if (!ok)
    writefln("Ошибка: %s", c.error);
else
    writefln("Скачано %d байт", c.bytes);

// Через fluent + execute() — для контроля таймаута и заголовков
auto res = c.reset()
             .url("https://example.com/big_file.zip")
             .downloadFile("./big_file.zip")
             .timeout(300)           // 5 минут для большого файла
             .execute();
writefln("Статус: %d, байт: %d", res.statusCode, res.bytes);
```

#### FTP скачивание

```d
// Анонимный FTP
bool ok = c.reset().download("ftp://ftp.example.com/pub/readme.txt", "./readme.txt");

// FTP с паролем
bool ok = c.reset()
            .auth("ftpuser", "ftppassword")
            .download("ftp://ftp.example.com/private/data.csv", "./data.csv");

// FTP с явным таймаутом
auto res = c.reset()
             .auth("user", "pass")
             .url("ftp://ftp.example.com/archive.tar.gz")
             .downloadFile("./archive.tar.gz")
             .timeout(120)
             .execute();
```

#### SFTP скачивание (пароль)

```d
bool ok = c.reset()
            .auth("sshuser", "sshpassword")
            .download("sftp://server.example.com/home/user/data.db", "./data.db");
if (!ok)
    writefln("SFTP ошибка: %s", c.error);
```

#### SFTP скачивание (SSH-ключ)

```d
// Приватный ключ — публичный ищется автоматически (ключ + ".pub")
bool ok = c.reset()
            .sshKey("/home/user/.ssh/id_rsa")
            .download("sftp://user@server.example.com/data/file.dat", "./file.dat");

// Явно указываем оба ключа
bool ok = c.reset()
            .sshKey("/home/user/.ssh/id_ed25519",
                    "/home/user/.ssh/id_ed25519.pub")
            .download("sftp://user@server/file.dat", "./file.dat");

// Добавляем проверку known_hosts (рекомендуется в продакшене)
bool ok = c.reset()
            .sshKey("/root/.ssh/id_rsa")
            .knownHosts("/root/.ssh/known_hosts")
            .download("sftp://backup@192.168.1.10/backups/db.sql.gz", "./db.sql.gz");
```

#### SCP скачивание

```d
// SCP требует SSH-ключа (или пароля)
bool ok = c.reset()
            .sshKey("/home/user/.ssh/id_rsa")
            .download("scp://user@server.example.com/path/to/file.tar", "./file.tar");
```

### 4.7. Загрузка файлов (upload)

```d
// FTP upload
bool ok = c.reset()
            .auth("ftpuser", "ftppass")
            .upload("./report.csv", "ftp://ftp.example.com/incoming/report.csv");

// SFTP upload с ключом
bool ok = c.reset()
            .sshKey("/home/user/.ssh/id_rsa")
            .upload("./backup.tar.gz", "sftp://backup@server/backups/backup.tar.gz");

// Через fluent для полного контроля
auto res = c.reset()
             .auth("user", "pass")
             .url("ftp://ftp.example.com/incoming/data.csv")
             .uploadFile("./data.csv")
             .timeout(60)
             .execute();
writefln("Загружено: %d байт, статус: %d", res.bytes, res.statusCode);
```

### 4.8. Управление таймаутом

```d
// Таймаут всего запроса (секунды)
c.timeout(60);   // 60 секунд
c.timeout(0);    // без таймаута (ждать вечно — осторожно!)

// Типичные значения:
// API-запросы: 10–30 секунд
// Большие файлы: 5–30 минут (300–1800 секунд)
// SFTP на медленном канале: 120–600 секунд
```

### 4.9. Отладка запросов

```d
// Включить подробный вывод libcurl в stderr
auto res = c.reset()
             .url("https://api.example.com/data")
             .verbose(true)        // выводит заголовки, SSL-инфо, прогресс
             .execute();

// Пример вывода в stderr:
// * Trying 93.184.216.34:443...
// * Connected to api.example.com
// * SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
// > GET /data HTTP/1.1
// > Host: api.example.com
// > User-Agent: curl/7.88.1
// < HTTP/1.1 200 OK
// < Content-Type: application/json
```

### 4.10. Переиспользование сессии

```d
auto c = new CurlSession();

// Запрос 1
auto r1 = c.url("https://api.example.com/users").execute();

// Запрос 2 — обязательно reset() между запросами!
auto r2 = c.reset()
            .url("https://api.example.com/products")
            .header("Accept", "application/json")
            .execute();

// Запрос 3 — FTP
bool ok = c.reset()
            .auth("user", "pass")
            .download("ftp://ftp.example.com/data.csv", "./data.csv");

// В конце — GC сам вызовет деструктор, но можно явно:
destroy(c);
```

---

## 5. Модуль gen_qnetwork.d

**Файл:** `d/gen/gen_qnetwork.d`
**Индексы:** 20005–20045
**Назначение:** Низкоуровневые обёртки над Qt классами для работы с сетью.

Обычно вы **не используете этот модуль напрямую** — используйте `net_utils.d`.
Однако он нужен для асинхронной работы, прогресс-индикаторов и SSL.

### 5.1. Классы модуля

| Класс                  | Назначение                                     |
|------------------------|------------------------------------------------|
| `QUrl`                 | Разбор и конструирование URL                   |
| `QNetworkRequest`      | Параметры запроса: URL, заголовки, настройки   |
| `QNetworkReply`        | Ответ сервера: статус, тело, сигналы           |
| `QNetworkAccessManager`| Выполняет запросы, управляет сессией           |

### 5.2. QUrl

```d
import gen_qnetwork;

// Создание
auto url = new QUrl("https://api.example.com/path?key=value");

// Разбор компонентов
writeln(url.scheme());   // "https"
writeln(url.host());     // "api.example.com"
writeln(url.path());     // "/path"
writeln(url.port());     // -1 (нет явного порта)
writeln(url.toString()); // полный URL обратно
writeln(url.isValid());  // 1 = валидный URL

url.destroy();
```

### 5.3. QNetworkRequest

```d
auto req = new QNetworkRequest("https://api.example.com/data");

// Установка заголовков
req.setRawHeader("Authorization", "Bearer mytoken123");
req.setRawHeader("Accept", "application/json");
req.setRawHeader("X-Custom-Header", "value");

// Следовать редиректам
req.setFollowRedirects(true);

// Получить URL обратно (→ QUrl*)
auto urlPtr = req.url();

req.destroy();
```

### 5.4. QNetworkReply

`QNetworkReply` создаётся методами менеджера (get/post/put/…) и управляется Qt.
**Никогда не удалять через delete!** Использовать `deleteLater()`.

```d
// Оборачивание указателя из callback
auto reply = QNetworkReply.wrap(replyPtr);

// Чтение результата
int    status = reply.statusCode();   // HTTP-статус
string body   = reply.readAllString(); // тело ответа UTF-8
int    err    = reply.error();         // 0 = нет ошибки
string errStr = reply.errorString();   // текст ошибки
long   bytes  = reply.bytesAvailable(); // байт в буфере
bool   done   = reply.isFinished() != 0;

// Заголовок ответа
string ct = reply.rawHeader("Content-Type"); // "" если нет

// Прервать запрос
reply.abort();

// ОБЯЗАТЕЛЬНО — уведомить Qt что объект можно удалить
reply.deleteLater();
```

### 5.5. QNetworkAccessManager — сигналы

```d
import gen_qnetwork;

auto mgr = new QNetworkAccessManager(null);

// ── Сигнал finished (QNetworkAccessManager) ──────────────────────────────
// Вызывается после КАЖДОГО завершённого запроса этого менеджера.
// Callback: extern(C) void function(void* dthis, int n, void* replyPtr)
extern(C) void onMgrFinished(void* dthis, int n, void* replyPtr) {
    auto reply = QNetworkReply.wrap(replyPtr);
    writefln("Запрос завершён: HTTP %d", reply.statusCode());
    reply.deleteLater();
}
mgr.connect_finished(null, 0, cast(void*)&onMgrFinished);

// ── Сигнал finished (QNetworkReply) ───────────────────────────────────────
// Вызывается один раз для конкретного reply.
// Callback: extern(C) void function(void* dthis, int n)
QNetworkReply reply = mgr.get(req);
extern(C) void onReplyDone(void* dthis, int n) {
    // Здесь нет доступа к reply напрямую — используйте mgr.connect_finished
}
reply.connect_finished(null, 0, cast(void*)&onReplyDone);

// ── Сигнал downloadProgress ───────────────────────────────────────────────
// Вызывается периодически во время скачивания.
// Callback: extern(C) void function(void* dthis, int n, long received, long total)
extern(C) void onProgress(void* dthis, int n, long recv, long total) {
    if (total > 0)
        writefln("Прогресс: %.1f%%", cast(double)recv / total * 100);
}
reply.connect_downloadProgress(null, 0, cast(void*)&onProgress);

// ── Сигнал sslErrors ──────────────────────────────────────────────────────
// Вызывается при проблемах SSL.
// Callback: extern(C) void function(void* dthis, int n, int errorCount)
extern(C) void onSslErr(void* dthis, int n, int count) {
    writefln("SSL ошибок: %d — игнорируем", count);
}
reply.connect_sslErrors(null, 0, cast(void*)&onSslErr);
// Игнорировать SSL-ошибки (после получения сигнала)
reply.ignoreSslErrors();

// ── Заголовки ответа ──────────────────────────────────────────────────────
string[] headers = reply.rawHeaderList();
foreach (h; headers)
    writefln("  %s: %s", h, reply.rawHeader(h));
```

### 5.6. Асинхронный GET с прогресс-баром

```d
import gen_qnetwork;
import gen_qcore : t_v__;

// Состояние
__gshared bool   _done;
__gshared long   _recvBytes;
__gshared long   _totalBytes;
__gshared string _resultBody;

extern(C) void onFinished(void* dthis, int n, void* rp) {
    auto reply = QNetworkReply.wrap(rp);
    _resultBody = reply.readAllString();
    _done = true;
    reply.deleteLater();
}

extern(C) void onProgress(void* dthis, int n, long recv, long total) {
    _recvBytes  = recv;
    _totalBytes = total;
    if (total > 0)
        writef("\rСкачано: %d / %d байт (%.0f%%)",
               recv, total, cast(double)recv/total*100);
}

void asyncDownload(string url) {
    _done = false;
    _recvBytes = _totalBytes = 0;
    _resultBody = "";

    auto mgr = new QNetworkAccessManager(null);
    mgr.connect_finished(null, 0, cast(void*)&onFinished);

    auto req = new QNetworkRequest(url);
    req.setFollowRedirects(true);
    auto reply = mgr.get(req);
    reply.connect_downloadProgress(null, 0, cast(void*)&onProgress);

    // Spin loop
    import std.datetime.stopwatch : StopWatch, AutoStart;
    auto sw = StopWatch(AutoStart.yes);
    while (!_done && sw.peek.total!"msecs" < 60_000) {
        (cast(extern(C) void function())pFunQt[53])();  // processEvents
    }

    writeln("\nГотово: ", _resultBody.length, " байт в теле");
    req.destroy();
    mgr.destroy();
}
```

---

## 6. Выбор подхода

### Когда использовать net_utils.d

- Нужны только **HTTP/HTTPS**-запросы
- **Приложение с QApplication** (GUI или консольное с Qt event loop)
- **Небольшие тела ответов** (умещаются в память)
- Нужна **интеграция с Qt event loop** (не блокировать GUI)
- Нужны **сигналы Qt** (прогресс, ошибки SSL, заголовки)

```d
// Идеально для: REST API, JSON, веб-сервисы
string body = httpGet("https://api.service.com/data");
```

### Когда использовать curl_utils.d

- Нужны **FTP, SFTP, SCP** (только в curl_utils)
- **Скачивание больших файлов** (прямо на диск, без RAM)
- **Загрузка файлов** на сервер
- **SFTP с SSH-ключом**
- Нет QApplication (консольный инструмент без GUI)
- Нужна настоящая **блокировка потока** (не spin loop)

```d
// Идеально для: резервное копирование, синхронизация файлов, FTP-роботы
bool ok = c.auth("user","pass").download("sftp://host/data.csv", "./data.csv");
```

### Сравнительная таблица

| Задача                          | net_utils | curl_utils |
|---------------------------------|:---------:|:----------:|
| HTTP GET                        | ✓         | ✓          |
| HTTP POST JSON                  | ✓         | ✓          |
| HTTP PUT/DELETE/PATCH           | ✓ (Fetch) | ✓          |
| HTTPS (с проверкой cert)        | ✓         | ✓          |
| Кастомные заголовки             | ✓         | ✓          |
| HTTP Basic Auth                 | ✓         | ✓          |
| FTP скачивание                  | ✗         | ✓          |
| FTP загрузка                    | ✗         | ✓          |
| SFTP (пароль)                   | ✗         | ✓          |
| SFTP (SSH-ключ)                 | ✗         | ✓          |
| SCP                             | ✗         | ✓          |
| Скачать файл напрямую на диск   | ✗         | ✓          |
| Загрузить файл с диска          | ✗         | ✓          |
| Прогресс скачивания             | ✓ (сигнал)| ✗ (пока)  |
| Без QApplication                | ✗         | ✓          |
| Одновременные запросы           | ✗ (1 шт.) | ✗ (1 шт.) |

---

## 7. Типичные задачи: рецепты

### 7.1. Получить и разобрать JSON с REST API

```d
import curl_utils, gen_qcurl, json;
import std.stdio;

void main() {
    LoadQt("./dll");
    auto app = new QApplication("example");

    auto c = new CurlSession();

    auto res = c.url("https://jsonplaceholder.typicode.com/posts/1")
                 .header("Accept", "application/json")
                 .timeout(15)
                 .execute();

    if (!res.ok) {
        writefln("Ошибка libcurl: %s", res.error);
        return;
    }
    if (!res.isHttp2xx) {
        writefln("HTTP ошибка: %d", res.statusCode);
        return;
    }

    JsonValue post;
    if (!tryParseJson(res.body, post)) {
        writeln("Не удалось разобрать JSON");
        return;
    }

    writeln("Заголовок: ", post.get!string("title", "?"));
    writeln("Тело: ",      post.get!string("body",  "?"));
    writeln("Автор ID: ",  post.get!int("userId",   0));

    destroy(c);
    app.deleteApp();
}
```

### 7.2. Авторизация + работа с API-токеном

```d
// Шаг 1: получить токен
auto loginPayload = jobject("username", "alice", "password", "secret");
string loginResp = c.reset().post(
    "https://api.example.com/auth/login",
    toJsonCompact(loginPayload),
    "application/json"
);

JsonValue loginJson;
tryParseJson(loginResp, loginJson);
string token = loginJson.get!string("access_token", "");

// Шаг 2: использовать токен в последующих запросах
auto res = c.reset()
             .url("https://api.example.com/profile")
             .header("Authorization", "Bearer " ~ token)
             .header("Accept", "application/json")
             .execute();
```

### 7.3. Отправить форму (form-encoded)

```d
import std.uri : encodeComponent;

string formData = "username=" ~ encodeComponent("Иван Иванов") ~
                  "&email=" ~ encodeComponent("ivan@example.com") ~
                  "&subscribe=1";

string resp = c.reset().post(
    "https://site.example.com/subscribe",
    formData,
    "application/x-www-form-urlencoded"
);
```

### 7.4. Резервное копирование по SFTP

```d
import std.format : format;
import std.datetime : Clock, SysTime;

void backupToSftp(string localFile, string remoteDir) {
    auto c = new CurlSession();
    SysTime now = Clock.currTime();
    string ts = format("%04d%02d%02d_%02d%02d%02d",
                       now.year, now.month, now.day,
                       now.hour, now.minute, now.second);
    string remoteUrl = format("sftp://backup@192.168.1.10%s/backup_%s.gz",
                              remoteDir, ts);

    bool ok = c.reset()
                .sshKey("/root/.ssh/id_rsa")
                .knownHosts("/root/.ssh/known_hosts")
                .timeout(300)
                .upload(localFile, remoteUrl);

    if (ok)
        writefln("Резервная копия отправлена: %s", remoteUrl);
    else
        writefln("Ошибка SFTP: %s", c.error);

    destroy(c);
}
```

### 7.5. Скачать несколько файлов

```d
// Один CurlSession — несколько запросов
auto c = new CurlSession();

string[] urls = [
    "https://example.com/file1.pdf",
    "https://example.com/file2.pdf",
    "https://example.com/file3.pdf",
];

foreach (i, url; urls) {
    import std.format : format;
    string dest = format("./downloads/file%d.pdf", i + 1);
    bool ok = c.reset().timeout(60).download(url, dest);
    writefln("%s → %s [%s, %d байт]",
             url, dest,
             ok ? "OK" : "ОШИБКА",
             c.bytes);
}
destroy(c);
```

### 7.6. Проверить доступность сервера (HEAD-запрос)

```d
auto res = c.reset()
             .url("https://api.example.com/health")
             .method("HEAD")   // Только заголовки, без тела
             .timeout(5)
             .execute();

bool online = res.ok && res.statusCode == 200;
writeln("Сервер: ", online ? "доступен" : "недоступен");
```

### 7.7. Скачать файл с FTP + разобрать как CSV

```d
import std.string : splitLines, split, strip;

bool ok = c.reset()
            .auth("ftpuser", "ftppass")
            .timeout(30)
            .download("ftp://ftp.example.com/data/report.csv", "./report.csv");

if (ok) {
    import std.file : readText;
    string csv = readText("./report.csv");
    foreach (line; csv.splitLines()) {
        string[] cols = line.split(",");
        if (cols.length >= 3)
            writefln("  %s | %s | %s", cols[0].strip, cols[1].strip, cols[2].strip);
    }
}
```

---

## 8. Обработка ошибок

### 8.1. Уровни ошибок в curl_utils

```d
auto res = c.url(url).execute();

// Уровень 1: ошибка libcurl (соединение, DNS, SSL)
if (!res.ok) {
    writefln("libcurl ошибка (код %d): %s", res.curlCode, res.error);
    // Примеры: "Could not resolve host", "Connection timed out"
    return;
}

// Уровень 2: HTTP-ошибка сервера
if (!res.isHttp2xx) {
    writefln("Сервер вернул HTTP %d", res.statusCode);
    // 400: Bad Request — неверные параметры
    // 401: Unauthorized — нужна авторизация
    // 403: Forbidden — доступ запрещён
    // 404: Not Found — ресурс не найден
    // 429: Too Many Requests — превышен лимит
    // 500: Internal Server Error — ошибка сервера
    if (res.body.length > 0) writeln("Тело ошибки: ", res.body);
    return;
}

// Уровень 3: бизнес-логика в JSON
JsonValue j;
if (!tryParseJson(res.body, j)) {
    writeln("Ответ не является JSON");
    return;
}
bool apiOk = j.get!bool("ok", false);
if (!apiOk) {
    writeln("API ошибка: ", j.get!string("error", "неизвестно"));
    return;
}
```

### 8.2. Уровни ошибок в net_utils

```d
auto res = httpFetch(url, "GET", "", null, "", 10_000);

// Уровень 1: таймаут
if (res.timedOut) {
    writeln("Запрос не завершился за отведённое время");
    return;
}

// Уровень 2: сетевая ошибка Qt
if (res.errorCode != 0) {
    writefln("Qt ошибка %d: %s", res.errorCode, res.errorStr);
    return;
}

// Уровень 3: HTTP-статус
if (res.statusCode != 200) {
    writefln("HTTP %d", res.statusCode);
    return;
}

// Уровень 4: разбор JSON
JsonValue j;
if (!tryParseJson(res.body, j)) {
    writeln("Ответ не JSON");
    return;
}
```

### 8.3. Повтор запроса при ошибке

```d
import std.datetime.stopwatch : StopWatch, AutoStart;

CurlResult fetchWithRetry(CurlSession c, string url, int retries = 3) {
    foreach (attempt; 0 .. retries) {
        auto res = c.reset().url(url).timeout(15).execute();
        if (res.ok && res.isHttp2xx)
            return res;
        writefln("Попытка %d/%d не удалась: %s",
                 attempt + 1, retries,
                 res.ok ? ("HTTP " ~ res.statusCode.to!string) : res.error);
        // Пауза перед повтором не нужна для curl (синхронный)
    }
    return CurlResult.init;  // все попытки провалились
}
```

---

## 9. Зависимости и установка

### 9.1. Windows 32-bit (dmd -m32)

```
./dll/
  qte56_curl.dll       — wrapper над libcurl (собирается из cpp/qt5/qte56_curl/)
  qte56_network.dll    — Qt network wrapper (собирается из cpp/qt5/qte56_network/)
  qte56_qcore.dll      — Qt core (собирается)
  libcurl.dll          — libcurl (скачать: https://curl.se/windows/)
  cacert.pem           — CA-бандл (скачать: https://curl.se/ca/cacert.pem)
  Qt5Core.dll          — Qt runtime
  Qt5Network.dll       — Qt network runtime
  libssl-1_1.dll       — OpenSSL (для HTTPS через Qt)
  libcrypto-1_1.dll    — OpenSSL crypto
```

**Откуда взять libcurl.dll:**
- Официально: https://curl.se/windows/ → выбрать Win32, MinGW
- Или из дистрибутива curl: `curl-*..-win32-mingw.zip` → `bin/libcurl.dll`
- libssh2 должен быть включён в libcurl для SFTP

**Откуда взять cacert.pem:**
- https://curl.se/ca/cacert.pem — официальный бандл Mozilla
- Или из дистрибутива curl (обычно включён)

### 9.2. Linux 64-bit (ldc2)

```bash
# Обязательно для curl_utils
sudo apt install libcurl4-openssl-dev    # Ubuntu/Debian
# или
sudo yum install libcurl-devel           # RHEL/CentOS/Fedora

# Проверить наличие SFTP поддержки
curl --version | grep -o 'libssh2/[0-9.]*'
# Должен вывести: libssh2/1.x.x

# Опционально: для net_utils (обычно уже есть если установлен Qt)
sudo apt install libssl-dev              # OpenSSL (HTTPS в Qt)
```

**На Linux `cacert.pem` не нужен** — libcurl использует системные сертификаты
(`/etc/ssl/certs/` или `/etc/pki/tls/`).

Однако если нужно явно указать CA (например в Docker без CA):
```d
c.caFile("/etc/ssl/certs/ca-certificates.crt");
```

### 9.3. Проверка установки

```d
// Проверить что libcurl загружается и HTTPS работает
LoadQt("./dll");
auto c = new CurlSession();
auto res = c.url("https://httpbin.org/get").timeout(10).execute();
if (res.ok)
    writeln("libcurl OK, HTTPS работает");
else
    writefln("Ошибка: %s", res.error);
destroy(c);
```

---

## 10. Сборка проектов

### 10.1. Минимальный build.bat для curl_utils

```bat
@echo off
cd /d "%~dp0.."

dmd -m32 ^
    myprog.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_qcurl.d ^
    d\curl_utils.d ^
    d\json.d ^
    -Id -Id\gen ^
    -of=myprog.exe

set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt5_13_2\5.13.2\mingw73_32\plugins\platforms
myprog.exe
```

### 10.2. Минимальный build.bat для net_utils

```bat
@echo off
cd /d "%~dp0.."

dmd -m32 ^
    myprog.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_qbytearray.d ^
    d\gen\gen_qnetwork.d ^
    d\net_utils.d ^
    d\json.d ^
    -Id -Id\gen ^
    -of=myprog.exe

set PATH=dll;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt5_13_2\5.13.2\mingw73_32\plugins\platforms
myprog.exe
```

### 10.3. Оба модуля вместе

```bat
dmd -m32 ^
    myprog.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_qbytearray.d ^
    d\gen\gen_qnetwork.d ^
    d\gen\gen_qcurl.d ^
    d\net_utils.d ^
    d\curl_utils.d ^
    d\json.d ^
    -Id -Id\gen ^
    -of=myprog.exe
```

### 10.4. Linux (ldc2)

```bash
#!/bin/bash
cd "$(dirname "$0")/.."
ldc2 \
    myprog.d \
    d/qte56_core.d \
    d/qte56_loader.d \
    d/gen/gen_qcore.d \
    d/gen/gen_qcurl.d \
    d/curl_utils.d \
    d/json.d \
    -I=d -I=d/gen \
    -of=myprog

export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH
./myprog
```

---

## 11. Частые ошибки и их причины

### 11.1. Access Violation при создании CurlSession

**Причина:** `LoadQt()` не был вызван перед созданием объекта.

```d
// НЕПРАВИЛЬНО:
auto c = new CurlSession();   // CRASH — DLL не загружена!

// ПРАВИЛЬНО:
LoadQt("./dll");
auto c = new CurlSession();   // OK
```

### 11.2. Пустое тело при download()

**Причина:** `download()` пишет данные в файл, а не в `body`.

```d
bool ok = c.download("https://example.com/file.zip", "./file.zip");
// c.body будет ПУСТЫМ — это нормально!
// Данные в файле: ./file.zip
writeln(c.bytes);   // количество байт — вот реальный размер
```

### 11.3. net_utils зависает

**Причина:** `QApplication` не создан или event loop не работает.

```d
// НЕПРАВИЛЬНО (без QApplication):
LoadQt("./dll");
string body = httpGet("https://...");  // зависнет! processEvents не работает

// ПРАВИЛЬНО:
LoadQt("./dll");
auto app = new QApplication("myapp");
string body = httpGet("https://...");  // OK
```

### 11.4. SSL-ошибка (сертификат)

**Ошибка:** `curlCode == 60`, `error == "SSL certificate problem: unable to get local issuer certificate"`

**Причина:** `cacert.pem` не найден или устарел.

```d
// Решение 1: указать путь явно
c.caFile("./dll/cacert.pem");

// Решение 2: обновить cacert.pem (скачать актуальный с curl.se)

// Решение 3 (только для тестов!): пропустить проверку
c.skipSsl();
```

### 11.5. SFTP — "Authentication failed"

**Возможные причины и решения:**

```d
// Причина 1: неверный пароль
c.auth("user", "ПРАВИЛЬНЫЙ_ПАРОЛЬ");

// Причина 2: неверный путь к ключу
c.sshKey("/home/user/.ssh/id_rsa");  // файл должен существовать

// Причина 3: неверные права на ключ (Linux)
// $ chmod 600 ~/.ssh/id_rsa

// Причина 4: сервер не в known_hosts — пропустить проверку хоста
// (не задавать knownHosts() — тогда проверка пропускается)

// Причина 5: отладка — включить verbose
c.verbose(true);  // stderr покажет детали SSH-рукопожатия
```

### 11.6. FTP — "Access denied"

```d
// Проверить URL: путь должен быть абсолютным
c.download("ftp://ftp.example.com/pub/file.txt", "./file.txt");  // OK
c.download("ftp://ftp.example.com/file.txt", "./file.txt");      // может не работать

// Анонимный FTP
c.auth("anonymous", "guest@example.com");  // стандартный анонимный доступ
```

### 11.7. reset() не восстанавливает cacert.pem

**Причина:** `_curl_reset()` внутри DLL очищает ВСЕ опции включая CA-файл.
`CurlSession.reset()` автоматически восстанавливает `./dll/cacert.pem`,
но если вы вызываете `_curl_reset()` напрямую — нужно переустановить вручную.

```d
// CurlSession.reset() делает это автоматически:
c.reset();  // CA-файл восстановлен в ./dll/cacert.pem — всё ОК

// Если используете gen_qcurl напрямую:
_curl_reset(h);
_curl_wset(20054, h, "./dll/cacert.pem");  // явно восстановить!
```

### 11.8. JSON — паника при доступе к несуществующему ключу

```d
// НЕПРАВИЛЬНО (throws RangeError если "key" нет в объекте):
string val = j["key"].str;

// ПРАВИЛЬНО — проверить перед доступом:
if (auto p = "key" in j)
    string val = p.str;

// ИЛИ через get! с fallback:
string val = j.get!string("key", "значение по умолчанию");
```

### 11.9. Кодировка строк в URL и теле

```d
import std.uri : encodeComponent;

// URL с кириллицей или спецсимволами
string name = "Иван Иванов";
string url = "https://api.example.com/search?name=" ~ encodeComponent(name);
// → https://api.example.com/search?name=%D0%98%D0%B2%D0%B0%D0%BD%20%D0%98%D0%B2...

// Тело JSON — UTF-8, кодировка не нужна
auto payload = jobject("name", "Иван Иванов");   // JsonValue корректно обрабатывает
string body = toJsonCompact(payload);             // → {"name":"Иван Иванов"}
// curl передаёт UTF-8 напрямую — всё корректно
```

---

*Конец руководства. Версия 1.0, QTE56 проект.*
