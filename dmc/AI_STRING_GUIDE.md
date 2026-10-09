# Руководство по работе со строкам в QTE5-DMC

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

> Для AI-агентов и разработчиков.  
> Проект: `H:/qte56/arch_new/dmc` — биндинг Qt-5 (32 бит) к C++ для компилятора DMC.

## 1. Общие принципы

В QTE5-DMC строки могут существовать в трёх представлениях:

1. **`const char*` / `std::string`** — UTF-8 байты. Основной формат для C/C++ кода, литералов, консоли и файлов.
2. **`const wchar_t*` / `std::wstring`** — UTF-16 кодовые единицы (Windows: `wchar_t` = 2 байта). Используется для обмена с `QString` внутри Qt DLL.
3. **`QString*` (скрыт за `void*`)** — внутреннее представление Qt. Создаётся и удаляется только через функции DLL (`pFunQt[20]`, `pFunQt[21]`, `pFunQt[22]`).

**Золотое правило:** весь пользовательский C++ код работает с UTF-8 (`const char*` / `std::string`). Конвертация UTF-8 ↔ UTF-16 ↔ `QString*` выполняется автоматически классом `QStringDMC` и хелперами в `qte5dmc_core.h`.

---

## 2. Базовые хелперы (`qte5dmc_core.h`)

Эти функции подходят для простых случаев и для передачи строк в функции Qt, которые требуют `void*` (`QString*`).

### 2.1 `toQString(const char* utf8)`

Создаёт `QString*` из C-строки UTF-8.

```cpp
#include "qte5dmc_core.h"

void* qs = toQString("Привет, Qt!");
if (!qs) { /* ошибка */ }
```

**Важно:** возвращённый указатель нужно освободить через `freeQString()`.

### 2.2 `fromQString(void* qs, char* buf, int bufLen)`

Копирует содержимое `QString*` в пользовательский буфер UTF-8.

```cpp
char buf[256];
int len = fromQString(qs, buf, sizeof(buf));
if (len > 0) {
    printf("QString content: %s\n", buf);
}
```

Возвращает количество записанных байт (без `\0`). Если `buf` слишком мал, данные усекаются.

### 2.3 `freeQString(void* qs)`

Удаляет `QString*`, созданный `toQString()` или полученный из DLL.

```cpp
freeQString(qs);
```

### 2.4 Пример roundtrip

```cpp
const char* original = "Русский текст";
void* qs = toQString(original);

char buf[256];
fromQString(qs, buf, sizeof(buf));

if (strcmp(buf, original) == 0) {
    printf("OK: roundtrip совпал\n");
}

freeQString(qs);
```

---

## 3. Класс `QStringDMC` (`qte5dmc_qstring.h`)

`QStringDMC` — это C++ обёртка над `QString*`, которая автоматически управляет памятью и предоставляет удобный API, похожий на Qt `QString`.

### 3.1 Подключение

```cpp
#include "qte5dmc_qstring.h"
```

Файл `qte5dmc_qstring.cpp` должен быть добавлен в сборку (уже есть в `makefile.basic`).

### 3.2 Создание

```cpp
// Из C-строки UTF-8
QStringDMC s1("Hello");

// Из std::string
QStringDMC s2(std::string("World"));

// Из UTF-16 wchar_t*
const wchar_t* w = L"Привет";
QStringDMC s3(w);

// Из std::wstring
QStringDMC s4(std::wstring(L"Мир"));

// ⚠️ Важно: DMC некорректно обрабатывает wchar_t-литералы с нелатинскими символами.
// Для русского текста используйте обычные UTF-8 строковые литералы:
QStringDMC s_ru("Русский текст");

// Пустая строка
QStringDMC s5;

// Из сырого QString*, полученного из DLL
void* rawQs = ...;
QStringDMC s6 = QStringDMC::fromRaw(rawQs, true); // true = взять во владение
```

### 3.3 Получение содержимого

```cpp
QStringDMC s("Тест");

// Как std::string UTF-8
std::string utf8 = s.toUtf8();
printf("%s\n", utf8.c_str());

// Как std::wstring UTF-16
std::wstring w16 = s.toWString();

// В пользовательский буфер
char buf[256];
int len = s.toUtf8(buf, sizeof(buf));
```

### 3.4 Присваивание и конкатенация

```cpp
QStringDMC s;
s = "Привет";
s += " ";
s += std::string("мир");

QStringDMC a("Hello");
QStringDMC b("World");
QStringDMC c = a + QStringDMC(" ") + b; // "Hello World"

s.append("!");
s.prepend("==> ");
```

### 3.5 Сравнение

```cpp
QStringDMC a("abc");
QStringDMC b("abc");

if (a == b) { /* равны */ }
if (a != b) { /* не равны */ }
if (a.isEmpty()) { /* пустая */ }
```

### 3.6 Поиск и подстроки

> ⚠️ Операции `mid`, `left`, `right`, `indexOf`, `contains`, `startsWith`, `endsWith` работают с **байтами UTF-8**, а не с Unicode code points. Для ASCII это полностью корректно; для многобайтовых символов (русские буквы, эмодзи) позиции и длины будут считаться в байтах.

```cpp
QStringDMC s("0123456789");

QStringDMC a = s.left(4);   // "0123"
QStringDMC b = s.right(3);  // "789"
QStringDMC c = s.mid(3, 4); // "3456"

int pos = s.indexOf("345"); // 3
bool ok = s.contains("345"); // true
bool sw = s.startsWith("012"); // true
bool ew = s.endsWith("789");   // true
```

### 3.7 Числа и форматирование

```cpp
QStringDMC n = QStringDMC::number(42);      // "42"
QStringDMC f = QStringDMC::number(3.14);    // "3.14"

QStringDMC msg = QStringDMC("Value: %1").arg(QStringDMC::number(7));
// msg.toUtf8() == "Value: 7"
```

### 3.8 Размер строки

```cpp
QStringDMC s("abc");
int len = s.size();     // 3 (для ASCII)
int len2 = s.length();  // синоним size()
```

> Для строки `"Привет"` (`size()` вернёт 12, так как каждая русская буква занимает 2 байта в UTF-8). Это **байтовый** размер UTF-8 представления.

### 3.9 Передача в Qt-функции

```cpp
QStringDMC title("Моё окно");
win->setWindowTitle(title.toUtf8().c_str());

// Или, если функция принимает void* (QString*):
void* raw = title.raw();
```

### 3.10 Управление памятью

`QStringDMC` автоматически удаляет внутренний `QString*` в деструкторе, если он "owned" (создан самим объектом).

```cpp
{
    QStringDMC s("test"); // _qs owned
} // freeQString(_qs) вызван автоматически

void* externalQs = ...;
QStringDMC s = QStringDMC::fromRaw(externalQs, false); // не owned
// s не удалит externalQs
```

---

### 3.11 Прямая передача `QStringDMC` в виджеты

Для основных виджетов добавлены перегруженные методы, принимающие `const QStringDMC&`. Это позволяет передавать строки напрямую, без вызова `toUtf8().c_str()`.

Поддерживаются:

- `QWidget`: `setWindowTitle`, `setStyleSheet`, `setWindowIconText`, `setWindowRole`, `setWindowFilePath`, `setToolTip`, `setStatusTip`, `setWhatsThis`, `setAccessibleName`, `setAccessibleDescription`
- `QLabel`: конструктор с текстом, `setText`
- `QLineEdit`: конструктор с текстом, `setPlaceholderText`, `setInputMask`, `setText`, `insert`
- `QAbstractButton` (и наследники `QPushButton`, `QCheckBox` и т.д.): `setText`
- `QPushButton`: конструктор с текстом
- `QTextEdit`: конструктор с текстом, `setPlaceholderText`, `setPlainText`, `setHtml`, `setText`, `insertPlainText`, `insertHtml`, `append`, `scrollToAnchor`

Пример:

```cpp
#include "qte5dmc_qstring.h"
#include "gen/gen_qwidget.h"
#include "gen/gen_qlabel.h"
#include "gen/gen_qlineedit.h"
#include "gen/gen_qpushbutton.h"
#include "gen/gen_qtextedit.h"

QWidget* win = new QWidget(NULL);
win->setWindowTitle(QStringDMC("Моё окно"));

QLabel* label = new QLabel(QStringDMC("Привет, мир!"), win);
QLineEdit* edit = new QLineEdit(QStringDMC("Введите текст"), win);
QPushButton* btn = new QPushButton(QStringDMC("Нажми"), win);
QTextEdit* text = new QTextEdit(QStringDMC("Начальный текст"), win);

text->append(QStringDMC("Добавленная строка"));
```

> ⚠️ Перегрузки реализованы как inline-методы в заголовочных файлах `gen_*.h`. Они автоматически конвертируют `QStringDMC` в `const char*` UTF-8 и вызывают исходный метод виджета.

---

### 3.12 Работа с `QStringDMC*`

`QStringDMC` можно создавать динамически через `new` и передавать по указателю. Это полезно, когда строка создаётся в одном месте, а используется в другом, или когда нужно явно управлять временем жизни строки.

```cpp
QStringDMC* textPtr = new QStringDMC("Текст через QStringDMC*");

// Передача через разыменование
lbl->setText(*textPtr);

// Использование в нескольких местах
win->setWindowTitle(*textPtr);
statusBar->showMessage(*textPtr, 0);

// Освобождение памяти
 delete textPtr;
```

> **Важно:** Qt-функции принимают `const QStringDMC&`, поэтому передавайте разыменованный указатель (`*textPtr`), а не сам указатель. После использования строки в Qt-виджете память можно освобождать — виджет скопирует текст себе.

---

### 3.13 Дополнительные методы `QStringDMC`

Добавлены часто используемые операции, аналогичные Qt `QString`.

```cpp
QStringDMC s("  Hello   World  ");

// Очистка
s.clear();
bool null = s.isNull();   // true — внутренний QString* не создан

// Модификация
QStringDMC a("abcdef");
a.chop(3);            // "abc"
a.remove(1, 2);       // "a" (удалить 2 байта с позиции 1)
a.insert(1, "bc");    // "abc"

// Пробелы (ASCII)
QStringDMC t("  hello   world  ");
t.trimmed();          // "hello   world"
t.simplified();       // "hello world"

// Регистр (только ASCII)
QStringDMC u("Hello");
u.toUpper();          // "HELLO"
u.toLower();          // "hello"

// Разбивка и склейка
QStringDMC list("one,two,three");
std::vector<QStringDMC> parts = list.split(",");
QStringDMC joined = QStringDMC::join(parts, ";");  // "one;two;three"

// Секции
QStringDMC path("/usr/local/bin/app");
path.section("/", 2, 4);  // "local/bin/app"

// Цепочка arg()
QStringDMC fmt("A=%1 B=%2 C=%3");
QStringDMC result = fmt.arg("a").arg("b").arg("c");
// result == "A=a B=b C=c"
```

> ⚠️ `toUpper` / `toLower` работают **только для ASCII**. Для русских букв регистр не изменится, так как готовые DLL QTE56 не экспонируют Unicode-версии `QString::toUpper` / `QString::toLower`.

---

## 4. STLport: `std::string` и `std::wstring`

Проект использует STLport 4.5.3 (статическая библиотека без iostreams). Флаги компиляции:

```makefile
CFLAGS = -Ic:\D\DMC\dm\stlport\stlport -D_STLP_NO_NEW_IOSTREAMS
LIBS   = user32.lib+kernel32.lib+c:\D\DMC\dm\lib\stlp45dm_static.lib
```

### 4.1 `std::string`

```cpp
#include <string>

std::string s = "Hello";
s += " World";
s.append("!");
s.insert(5, ",");
s.replace(0, 5, "Hi");

size_t pos = s.find("World");
std::string sub = s.substr(0, 4);

if (s == "Hi, World!") { /* ... */ }
```

### 4.2 `std::wstring`

```cpp
#include <string>

std::wstring ws = L"Привет";
ws += L" мир";

size_t len = ws.length(); // количество wchar_t (UTF-16 кодовых единиц)
```

### 4.3 `std::vector<T>`

```cpp
#include <vector>

std::vector<char> v(256);
std::vector<wchar_t> wbuf(1024);

// Доступ к данным
wchar_t* p = &wbuf[0];
```

> ⚠️ В STLport 4.5.3 лучше использовать `&v[0]` вместо `v.data()` (метод `data()` может отсутствовать).

---

## 5. Конвертация UTF-8 ↔ UTF-16 через WinAPI

Если нужно выполнить конвертацию в обход `QStringDMC`:

### 5.1 UTF-8 → UTF-16

```cpp
const char* utf8 = "Русский текст";

int wlen = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
std::vector<wchar_t> wbuf(wlen);
MultiByteToWideChar(CP_UTF8, 0, utf8, -1, &wbuf[0], wlen);

// wbuf содержит UTF-16 строку с завершающим \0
```

### 5.2 UTF-16 → UTF-8

```cpp
const wchar_t* wstr = L"Русский текст";
int wlen = (int)wcslen(wstr);

int ulen = WideCharToMultiByte(CP_UTF8, 0, wstr, wlen, NULL, 0, NULL, NULL);
std::vector<char> ubuf(ulen + 1);
WideCharToMultiByte(CP_UTF8, 0, wstr, wlen, &ubuf[0], ulen, NULL, NULL);
ubuf[ulen] = '\0';

// ubuf.data() содержит UTF-8 строку
```

> ⚠️ DMC требует явных приведений `NULL`/`0` к `wchar_t*`/`char*` при вызове `MultiByteToWideChar` / `WideCharToMultiByte`.

---

## 6. Рекомендации по написанию кода

### 6.1 Что использовать?

| Задача | Рекомендуемый инструмент |
|--------|--------------------------|
| Передать строку в Qt-функцию, принимающую `const char*` | `QStringDMC::toUtf8().c_str()` или `std::string::c_str()` |
| Передать строку в Qt-функцию, принимающую `void*` (`QString*`) | `QStringDMC::raw()` или `toQString()` |
| Получить строку из `QString*` | `fromQString()` или `QStringDMC::fromRaw()` |
| Локальные манипуляции со строками | `std::string` + `QStringDMC` |
| Работа с файлами / консолью | `std::string` UTF-8 |
| Русские подписи виджетов | `QStringDMC` |
| Разбить/склеить строки | `QStringDMC::split()` / `QStringDMC::join()` |
| Форматирование с несколькими аргументами | `QStringDMC("... %1 %2 ...").arg(a).arg(b)` |

### 6.2 Чего избегать

- Не передавайте `NULL` в `qteQString_toWStr` (`pFunQt[21]`) — это может привести к падению DLL.
- Не забывайте вызывать `freeQString()` для указателей, созданных `toQString()`.
- Не используйте `std::cout`, `printf` с `%S` (wide strings) — DMC + STLport без iostreams могут работать некорректно. Используйте `printf("%s", s.toUtf8().c_str())`.
- Не используйте `L"..."` для русского текста в DMC — wchar_t-литералы с нелатинскими символами компилируются некорректно, и QStringDMC создаётся с искажённым содержимым. Используйте обычные UTF-8 строковые литералы: `QStringDMC("Русский текст")`.
- Не полагайтесь на байтовые позиции для нелатинских символов в `mid`/`left`/`right`/`indexOf`.

### 6.3 Проверка на пустую строку

```cpp
QStringDMC s;
if (s.isEmpty()) { /* пустая */ }
if (s.raw() == NULL) { /* внутренний QString* не создан */ }
```

### 6.4 Безопасный вывод в консоль

```cpp
QStringDMC s("Русский текст");
printf("%s\n", s.toUtf8().c_str());
```

---

## 7. Примеры

### 7.1 Установить русский заголовок окна

```cpp
#include "qte5dmc_qstring.h"
#include "gen/gen_qwidget.h"

QWidget* win = new QWidget(NULL);

// Вариант 1: напрямую передать QStringDMC (рекомендуется)
win->setWindowTitle(QStringDMC("Моё первое окно"));

// Вариант 2: через toUtf8().c_str() (если нужен const char*)
QStringDMC title("Моё первое окно");
win->setWindowTitle(title.toUtf8().c_str());
```

### 7.2 Собрать сообщение из частей

```cpp
QStringDMC name("QTE5-DMC");
QStringDMC version = QStringDMC::number(1);
QStringDMC msg = QStringDMC("Приложение: %1, версия: %2")
                    .arg(name)
                    .arg(version);
printf("%s\n", msg.toUtf8().c_str());
```

> Примечание: текущая реализация `arg` заменяет только `%1`. Для нескольких аргументов вызывайте `.arg()` цепочкой:

```cpp
QStringDMC msg = QStringDMC("A=%1 B=%2").arg(QStringDMC("1")).arg(QStringDMC("2"));
```

### 7.3 Получить текст из QLabel

```cpp
#include "gen/gen_qlabel.h"
#include "qte5dmc_qstring.h"

QLabel* label = ...;
char buf[256];
label->text(buf, sizeof(buf));
printf("Label text: %s\n", buf);
```

### 7.4 Работа с `std::string` и `QStringDMC` вместе

```cpp
std::string path = "C:/Users/gena/Documents";
QStringDMC qs(path.c_str());

qs.append("/file.txt");
std::string fullPath = qs.toUtf8();
```

---

## 8. Тестирование

Для проверки строковых операций используйте `test/test_basic.cpp`. Там уже есть разделы:

- `--- QString tests ---` — базовые хелперы `toQString` / `fromQString` / `freeQString`.
- `--- QStringDMC class tests ---` — конструкторы, присваивание, конкатенация, подстроки, поиск, числа, `arg`, дополнительные методы (`chop`, `remove`, `insert`, `trimmed`, `simplified`, `toUpper`/`toLower`, `split`/`join`, `section`).

Запуск:

```cmd
c:\D\DMC\dm\bin\make.exe -f makefile.basic run
```

---

## 9. Ограничения

- `QStringDMC` не поддерживает прямой доступ к `QChar` и итераторы Qt.
- Локальные строковые операции (`mid`, `left`, `right`, `indexOf` и т.д.) работают на уровне UTF-8 байт, что ограничивает их корректность для нелатинских символов.
- `toUpper` / `toLower` / `trimmed` не реализованы в `QStringDMC` напрямую; при необходимости их можно сделать через `QByteArray` DLL (только ASCII) или локально через `std::string`.
- Суррогатные пары UTF-16 (эмодзи, редкие иероглифы) сохраняются корректно при конвертации, но байтовые операции над ними некорректны.

---

## 10. Краткая шпаргалка

```cpp
// Создать
QStringDMC s("text");

// Очистить / проверить
s.clear();
bool empty = s.isEmpty();
bool null  = s.isNull();

// Получить UTF-8
const char* cp = s.toUtf8().c_str();

// Добавить / удалить
s += "!";
s.append(" world");
s.chop(3);
s.remove(2, 4);
s.insert(2, "XX");

// Пробелы и регистр (ASCII)
s.trimmed();
s.simplified();
s.toUpper();
s.toLower();

// Подстрока
QStringDMC sub = s.mid(0, 4);

// Найти
int pos = s.indexOf("wo");

// Разбить / склеить
std::vector<QStringDMC> parts = s.split(",");
QStringDMC joined = QStringDMC::join(parts, ";");

// Секция
QStringDMC sec = s.section("/", 1, 3);

// Число в строку
QStringDMC n = QStringDMC::number(123);

// Форматирование
QStringDMC m = QStringDMC("v=%1").arg(n);
QStringDMC m2 = QStringDMC("A=%1 B=%2").arg("a").arg("b");

// В Qt-функцию (если есть перегрузка)
win->setWindowTitle(s);

// Или через toUtf8().c_str()
win->setWindowTitle(s.toUtf8().c_str());
```

---

*Файл создан: AI_STRING_GUIDE.md*  
*Актуален для: qte5dmc_qstring.h / qte5dmc_qstring.cpp / qte5dmc_core.h*
