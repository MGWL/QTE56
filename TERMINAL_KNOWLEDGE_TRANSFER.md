# Terminal Module — Knowledge Transfer (qte56_term.d)

> ↑ Навигация: [AGENTS.md](AGENTS.md)

Документ для AI-ассистента. Описывает TUI-слой проекта QTE56 полностью и самодостаточно.

---

## 1. Архитектура

### Слои

```
Приложение на D
    └── qte56_term.d          ← публичный API (Term, TermTable, BoxChars, enums)
            └── arsd.terminal ← backend (d/arsd/terminal.d, один файл, 0 зависимостей)
                    └── Win32 Console API / ANSI ESC sequences (платформо-зависимо)
```

### Ключевые свойства

- **Никаких DLL**: компилируется напрямую (`dmd file.d d\qte56_term.d d\arsd\terminal.d`).
- **Никакого Qt**: модуль полностью независим от Qt, Wren, OLE, LoadQt().
- **Кросс-платформенный**: Win7/8/10/11 и Linux/Mac из одного кода.
- `Term` — `struct` со `static:` методами, то есть работает как namespace (не инстанцируется).
- `TermTable` — обычный value struct, создаётся локально.
- Глобальное состояние: `_term` (pointer), `_inited` (bool), `_curFg/_curBg` (Color) — все `private`.

### Файлы

| Файл | Роль |
|------|------|
| `d/qte56_term.d` | Весь публичный API |
| `d/arsd/terminal.d` | Backend (сторонний, не трогать) |
| `test/test_term.d` | Unit + визуальные тесты (30/30) |
| `test/test_term_readat.d` | Тесты readAt, требует реальный терминал (22/22) |
| `test/gui_term_form.d` | Demo: TUI-форма с вводом, цветами, рамкой Double |
| `test/build_term.bat` | Сборка + запуск test_term |
| `test/build_term_readat.bat` | Сборка + запуск test_term_readat |
| `test/build_term_form.bat` | Сборка + запуск gui_term_form |

---

## 2. Жизненный цикл (КРИТИЧНО)

```d
Term.setup();          // ОБЯЗАТЕЛЬНО первым. Инициализирует backend.
                       // Если нет TTY (pipe, redirect) — Term.isAvailable() == false,
                       // все методы просто ничего не делают (не падают).

// ... работа с терминалом ...

Term.cleanup();        // ОБЯЗАТЕЛЬНО последним.
                       // Сбрасывает стиль, показывает курсор, flush().
                       // Без него терминал останется в raw-режиме после выхода.
```

**Паттерн защиты от нет-TTY:**

```d
Term.setup();
if (!Term.isAvailable()) {
    import std.stdio : writeln;
    writeln("No interactive terminal.");
    return;
}
// ... рисуем ...
Term.cleanup();
```

`setup()` идемпотентен: повторный вызов ничего не делает.
`cleanup()` безопасен при `!isAvailable()`.

---

## 3. Enums

### Color (16 цветов + Default)

```d
enum Color : int {
    Black        = 0,   Red        = 1,   Green      = 2,   Yellow  = 3,
    Blue         = 4,   Magenta    = 5,   Cyan       = 6,   White   = 7,
    BrightBlack  = 8,   BrightRed  = 9,   BrightGreen = 10, BrightYellow = 11,
    BrightBlue   = 12,  BrightMagenta = 13, BrightCyan = 14, BrightWhite = 15,
    Default      = -1,  // системный цвет терминала
}
```

Важно: `Color` — это ANSI-порядок (0–15). Внутри модуль делает ремаппинг в arsd BGR-порядок через `_colorMap[16]`. Снаружи всегда использовать `Color.X`, не сырые числа.

### Attr (битовые флаги, комбинируются через `|`)

```d
enum Attr : uint {
    None      = 0,
    Bold      = 1 << 0,   // жирный
    Dim       = 1 << 1,   // тусклый
    Italic    = 1 << 2,   // курсив
    Underline = 1 << 3,   // подчёркнутый
    Blink     = 1 << 4,   // мигающий
    Reverse   = 1 << 5,   // инверсия fg/bg
    Strike    = 1 << 6,   // зачёркнутый
}
```

Пример: `Attr.Bold | Attr.Underline` == 9.

### BoxStyle

```d
enum BoxStyle : int { Single = 0, Double = 1, Rounded = 2, Heavy = 3 }
```

### Align

```d
enum Align : int { Left = 0, Center = 1, Right = 2 }
```

Используется в TermTable для выравнивания ячеек. Заголовки всегда Center.

---

## 4. BoxChars — символы разграфки

```d
struct BoxChars {
    dchar hLine, vLine;
    dchar topLeft, topRight, bottomLeft, bottomRight;
    dchar teeLeft, teeRight, teeDown, teeUp;
    dchar cross;
}
```

Получение набора: `auto b = boxChars(BoxStyle.Single);`

### Таблица символов по стилям

| Поле | Single | Double | Rounded | Heavy |
|------|--------|--------|---------|-------|
| hLine | `─` | `═` | `─` | `━` |
| vLine | `│` | `║` | `│` | `┃` |
| topLeft | `┌` | `╔` | `╭` | `┏` |
| topRight | `┐` | `╗` | `╮` | `┓` |
| bottomLeft | `└` | `╚` | `╰` | `┗` |
| bottomRight | `┘` | `╝` | `╯` | `┛` |
| teeLeft | `├` | `╠` | `├` | `┣` |
| teeRight | `┤` | `╣` | `┤` | `┫` |
| teeDown | `┬` | `╦` | `┬` | `┳` |
| teeUp | `┴` | `╩` | `┴` | `┻` |
| cross | `┼` | `╬` | `┼` | `╋` |

Rounded отличается от Single только углами (скруглённые `╭╮╰╯`), остальные символы те же.

---

## 5. Term API — полный справочник

### Инициализация

```d
Term.setup()                     // инициализация, идемпотентна
Term.cleanup()                   // завершение, сбрасывает стиль+курсор
bool Term.isAvailable()          // false если нет TTY (stdout перенаправлен)
arsd.terminal.Terminal* Term.backend()  // прямой доступ к backend (advanced)
```

### Размер терминала

```d
int Term.width()     // ширина в символах (0 если нет TTY)
int Term.height()    // высота в строках (0 если нет TTY)
```

### Курсор

```d
Term.moveTo(int col, int row)      // НУМЕРАЦИЯ С НУЛЯ. col=X, row=Y.
Term.moveBy(int dcol, int drow)    // относительное перемещение (через ESC CSI)
Term.saveCursor()                  // сохранить позицию (ESC 7)
Term.restoreCursor()               // восстановить позицию (ESC 8)
Term.hideCursor()                  // скрыть курсор
Term.showCursor()                  // показать курсор
```

**ВАЖНО**: `moveTo(col, row)` — **col первый, row второй**. Это col=X, row=Y. Нумерация с нуля. Это не стандартный порядок (обычно row,col), не перепутать.

### Цвета (16-цветные)

```d
Term.setFg(Color c)              // установить цвет текста
Term.setBg(Color c)              // установить цвет фона
Term.style(Color fg, Color bg = Color.Default, Attr attr = Attr.None)
                                 // setAttr + setFg + setBg одним вызовом
Term.resetStyle()                // сброс fg/bg на Default
```

Текущие fg/bg кэшируются в `_curFg/_curBg`. `setFg`/`setBg` вызывают `_applyColor()` который передаёт оба в arsd.

### Цвета (256-цветные и TrueColor)

```d
Term.setFg256(int c)             // 0–255; для c<16 делегирует в setFg(Color)
Term.setBg256(int c)             // аналогично
Term.setFgRGB(ubyte r, ubyte g, ubyte b)  // TrueColor (Win10+/Linux)
Term.setBgRGB(ubyte r, ubyte g, ubyte b)  // TrueColor
```

### Атрибуты

```d
Term.setAttr(Attr a)             // применить атрибуты (через raw ESC sequences)
Term.resetStyle()                // сброс всего (цвет + атрибуты)
```

`setAttr` отправляет ESC-коды напрямую через `writeStringRaw` (arsd не имеет API атрибутов).
После `setAttr` нужно вызывать `resetStyle()` явно.

### Вывод текста

```d
Term.put(dchar ch)               // вывод одного Unicode-символа
Term.put(string text)            // вывод строки UTF-8
Term.putAt(int col, int row, string text)    // moveTo + put
Term.putStyled(string text, Color fg, Color bg = Color.Default, Attr attr = Attr.None)
                                 // style + put + resetStyle
Term.putStyledAt(int col, int row, string text, Color fg,
                 Color bg = Color.Default, Attr attr = Attr.None)
                                 // moveTo + putStyled
Term.flush()                     // сбросить буфер вывода
```

`flush()` нужно вызывать после серии операций рисования. Без `flush()` вывод может не появиться на экране немедленно.

### Очистка

```d
Term.clear()                     // очистить весь экран
Term.clearLine()                 // очистить текущую строку (ESC[2K])
Term.clearToEOL()                // очистить от курсора до конца строки (ESC[K])
Term.clearToEOS()                // очистить от курсора до конца экрана (ESC[J])
Term.clearRegion(int x, int y, int w, int h)
                                 // очистить прямоугольную область пробелами
```

`clearRegion` реализован через `moveTo` + `put(spaces)` построчно. После — `flush()`.

### Прокрутка

```d
Term.setScrollRegion(int top, int bottom)   // установить регион прокрутки (0-based строки)
Term.resetScrollRegion()                    // сбросить регион
Term.scrollUp(int n = 1)                    // прокрутить вверх на n строк (ESC[nS)
Term.scrollDown(int n = 1)                  // прокрутить вниз (ESC[nT)
```

Внутри `setScrollRegion`: строки конвертируются в 1-based для ESC-кода.

### Alternate screen buffer

```d
Term.enterAltScreen()    // переключиться на alternate screen (ESC[?1049h), Win10+/Linux
Term.leaveAltScreen()    // вернуться (ESC[?1049l)
```

На Win7/8 не работает. Используется для "fullscreen TUI" без порчи истории консоли.

### Рисование рамок и линий

```d
Term.drawBox(int x, int y, int w, int h, BoxStyle bs = BoxStyle.Single)
                         // прямоугольник: x,y — верхний левый угол (0-based), w/h включают рамку
                         // минимум: w>=2, h>=2

Term.drawHLine(int x, int y, int len, BoxStyle bs = BoxStyle.Single)
                         // горизонтальная линия

Term.drawVLine(int x, int y, int len, BoxStyle bs = BoxStyle.Single)
                         // вертикальная линия

Term.drawHSep(int x, int y, int[] colWidths, BoxStyle bs = BoxStyle.Single)
                         // горизонтальный разделитель с T-образными стыками
                         // используется для внутренних разделителей в таблицах
```

`drawBox(0, 0, 10, 5)` рисует рамку 10x5 символов с углом в (0,0). Внутреннее пространство: (1,1)..(8,3).

### readAt — чтение с экрана

```d
string Term.readAt(int col, int row, int len)
```

- Читает `len` символов с экрана начиная с позиции `(col, row)` (0-based).
- **Только Windows**: использует `ReadConsoleOutputCharacterW` (Win32 Console API).
- На Linux всегда возвращает `""`.
- Возвращает UTF-8 строку (wchar[] из API конвертируется через `toUTF8`).
- Автоматически вызывает `flush()` перед чтением.
- Edge cases: `len <= 0` → `""`, ошибка API → `""`.
- Корректно читает кириллицу и box-drawing символы (один `wchar` = одна колонка).

**Когда использовать**: тестирование (проверить что нарисовано на экране), scraping TUI-вывода другого процесса. В продакшн-коде обычно не нужен.

---

## 6. TermTable

### Конструктор и настройка

```d
auto tbl = TermTable(int[] colWidths, BoxStyle style = BoxStyle.Single);
```

- `colWidths` — ширина каждой колонки в символах (без padding и рамки).
- Реальная ширина колонки на экране: `colWidths[i] + 2` (padding по 1 с каждой стороны).

```d
tbl.setHeader(string[] titles);    // заголовки (всегда Center)
tbl.setAligns(Align[] aligns);     // выравнивание для данных, по умолчанию Left
tbl.addRow(string[] cells);        // добавить строку данных
```

### Вывод

```d
string s = tbl.toString();         // получить таблицу как строку (для writeln)
tbl.render(int x, int y);         // нарисовать на экране через Term.putAt
```

`render(x, y)` разбивает `toString()` по `\n` и вызывает `Term.putAt(x, row, line)` для каждой строки.

### Структура вывода

Для таблицы с заголовком и N строками данных: N + 3 строки:
```
┌─────────────┬─────────┐   <- top border
│   Header1   │  Header2│   <- header row (Center)
├─────────────┼─────────┤   <- separator
│ data1       │    data2│   <- data rows (Left/Right/Center per column)
│ ...         │     ... │
└─────────────┴─────────┘   <- bottom border
```

Без заголовка — N + 2 строки (только top/bottom border, без separator).

### Обрезка длинных ячеек

Если текст длиннее `colWidths[i]`, он обрезается с добавлением `…` (`_fitWidth`).
Вычисление ширины через `_displayWidth` которая считает `dchar`-ы (не байты) — корректно для Unicode.

### Пример с выравниванием

```d
auto tbl = TermTable([14, 8, 8, 10], BoxStyle.Single);
tbl.setHeader(["Process", "PID", "CPU%", "Status"]);
tbl.setAligns([Align.Left, Align.Right, Align.Right, Align.Center]);
tbl.addRow(["firefox", "1234", "12.3", "running"]);
tbl.addRow(["dmd",     "5678",  "8.1", "running"]);
writeln(tbl.toString());
```

---

## 7. Кириллица и Unicode

### Проблема

Кириллический символ занимает 2 байта в UTF-8. Срез `s[0..N]` режет по байтам, что ломает строку.

```d
// НЕПРАВИЛЬНО — режет по байтам, портит кириллицу:
string s = "Привет";
write(s[0..3]);  // выведет мусор, не "При"

// ПРАВИЛЬНО — итерация по dchar:
foreach (dchar dc; "Привет") {
    Term.put(dc);
}
```

### Term.put vs putDchar (backend)

- `Term.put(dchar ch)` — публичный API, внутри кодирует `dchar` в UTF-8 через `encode`.
- `Term.put(string text)` — передаёт UTF-8 строку как есть в arsd.
- В `gui_term_form.d` есть локальная `putDchar(arsd.terminal.Terminal* t, dchar ch)` — helper для прямой работы с backend (делает то же самое, что `Term.put(dchar)`).

### Правильная итерация

```d
// Вывод Unicode строки целиком — корректно:
Term.put("Привет мир");

// Подсчёт экранных символов (не байт):
int charCount = 0;
foreach (dchar _; someString) charCount++;

// Обрезка до N экранных символов:
import std.array : appender;
import std.utf : encode;
auto app = appender!string;
int w = 0;
foreach (dchar c; s) {
    if (w >= maxWidth) break;
    char[4] buf;
    auto n = encode(buf, c);
    app ~= buf[0..n];
    w++;
}
```

### readAt и Unicode

`ReadConsoleOutputCharacterW` возвращает `wchar[]` — один `wchar` на одну экранную колонку. Кириллица и box-drawing символы занимают одну колонку (не две, как CJK wide chars). `toUTF8` корректно конвертирует `wchar[]` в UTF-8.

---

## 8. Команды сборки

### Windows (из корня arch_new)

```bat
rem test_term (unit + визуальные тесты):
dmd -m32 test\test_term.d d\qte56_term.d d\arsd\terminal.d -Id -of=test\test_term.exe
test\test_term.exe

rem test_term_readat (требует реальный терминал, НЕ redirect):
dmd -m32 test\test_term_readat.d d\qte56_term.d d\arsd\terminal.d -Id -of=test\test_term_readat.exe
test\test_term_readat.exe

rem gui_term_form (интерактивное demo):
dmd -m32 test\gui_term_form.d d\qte56_term.d d\arsd\terminal.d -Id -of=test\gui_term_form.exe
test\gui_term_form.exe
```

Или через .bat файлы (cd в корень не нужен, bat сам делает `cd /d "%~dp0.."`):
```bat
test\build_term.bat
test\build_term_readat.bat
test\build_term_form.bat
```

### Linux (из корня arch_new)

```bash
# DMD:
dmd -m32 test/test_term.d d/qte56_term.d d/arsd/terminal.d -Id -of=test/test_term

# LDC2:
ldc2 -m32 test/test_term.d d/qte56_term.d d/arsd/terminal.d -Id -of=test/test_term

./test/test_term
```

На Linux `readAt` всегда возвращает `""` — `test_term_readat` пропустит проверки через `version(Windows)`.

### Важные флаги компилятора

- `-m32` — 32-бит (требование проекта QTE56).
- `-Id` — путь поиска модулей: `d/` (для `import arsd.terminal` из `d/arsd/terminal.d`).
- Никаких `-L`, `-version`, `-lib` флагов не нужно — всё чистый D.

---

## 9. Полный рабочий пример

TUI-приложение: таблица с цветами + рамка + ввод строки.

```d
module my_tui_app;

import qte56_term;
import arsd.terminal;   // нужен для RealTimeConsoleInput

void main() {
    Term.setup();
    if (!Term.isAvailable()) {
        import std.stdio : writeln;
        writeln("No terminal.");
        return;
    }

    Term.hideCursor();
    Term.clear();

    // Заголовок с цветом
    Term.putStyledAt(2, 0, " System Monitor ", Color.BrightWhite, Color.Blue, Attr.Bold);
    Term.flush();

    // Таблица процессов
    auto tbl = TermTable([16, 6, 6, 10], BoxStyle.Double);
    tbl.setHeader(["Process", "PID", "CPU%", "Status"]);
    tbl.setAligns([Align.Left, Align.Right, Align.Right, Align.Center]);
    tbl.addRow(["firefox",  "1234", "12.3", "running"]);
    tbl.addRow(["dmd",      "5678",  "8.1", "running"]);
    tbl.addRow(["code",     "9012",  "5.4", "idle"]);
    tbl.render(2, 2);
    Term.flush();

    // Рамка вокруг статуса (Heavy style)
    Term.setFg(Color.BrightCyan);
    Term.drawBox(2, 10, 30, 3, BoxStyle.Heavy);
    Term.putAt(4, 11, "Status: OK");
    Term.resetStyle();
    Term.flush();

    // Статус-бар внизу
    int h = Term.height();
    Term.putStyledAt(0, h - 1, " Q=quit ", Color.Black, Color.Cyan);
    Term.flush();

    // Ввод (посимвольный через arsd backend)
    auto term = Term.backend();
    auto input = RealTimeConsoleInput(term, ConsoleInputFlags.raw);

    bool running = true;
    while (running) {
        auto ev = input.nextEvent();
        if (ev.type == InputEvent.Type.KeyboardEvent) {
            auto ke = ev.get!(InputEvent.Type.KeyboardEvent);
            if (!ke.pressed) continue;
            if (ke.which == 'q' || ke.which == 'Q' ||
                ke.which == KeyboardEvent.Key.escape) {
                running = false;
            }
        }
    }

    Term.showCursor();
    Term.resetStyle();
    Term.clear();
    Term.flush();
    Term.cleanup();
}
```

Сборка:
```bat
dmd -m32 my_tui_app.d d\qte56_term.d d\arsd\terminal.d -Id -of=my_tui_app.exe
my_tui_app.exe
```

---

## 10. Продвинутые паттерны

### Использование backend напрямую

Для возможностей, не обёрнутых в Term API, используется `Term.backend()`:

```d
auto t = Term.backend();

// Цвет через arsd (если нужен arsd-синтаксис):
t.color(arsd.terminal.Color.white | arsd.terminal.Bright, arsd.terminal.Color.blue);

// Запись строки без буферизации:
t.writeStringRaw("\033[?25l");  // hide cursor напрямую

// RealTimeConsoleInput (для посимвольного ввода):
import arsd.terminal;
auto input = RealTimeConsoleInput(t, ConsoleInputFlags.raw);
auto ev = input.nextEvent();
```

### Сохранение/восстановление состояния курсора

```d
Term.saveCursor();
// ... рисуем в произвольном месте ...
Term.restoreCursor();
Term.flush();
```

Используется в `test_term_readat.d` перед записью в фиксированные позиции (строки 5, 7...).

### clearRegion для "стирания" старого контента

```d
Term.clearRegion(0, 20, 40, 1);  // очистить строку 20 от колонки 0, ширина 40
Term.flush();
string s = Term.readAt(0, 20, 4);
// s == "    " (4 пробела)
```

### Alternate screen для fullscreen TUI

```d
Term.enterAltScreen();
Term.hideCursor();
// ... рисуем fullscreen UI ...
Term.leaveAltScreen();   // возвращает оригинальное содержимое консоли
Term.showCursor();
```

### Таблица без заголовка

```d
auto tbl = TermTable([12, 8], BoxStyle.Rounded);
// setHeader НЕ вызывается
tbl.addRow(["key1", "value1"]);
tbl.addRow(["key2", "value2"]);
writeln(tbl.toString());
// 4 строки: top + 2 data + bottom (без separator)
```

---

## 11. Gotchas из тестов

### moveTo: col первый, row второй

```d
Term.moveTo(col, row);   // НЕ (row, col)! col=X=горизонталь, row=Y=вертикаль
Term.putAt(col, row, text);  // аналогично
tbl.render(col, row);        // аналогично
```

### readAt: только Windows + только после flush

```d
Term.putAt(0, 5, "Hello");
Term.flush();               // ОБЯЗАТЕЛЬНО перед readAt
string s = Term.readAt(0, 5, 5);
// s == "Hello"
```

### readAt: не работает с перенаправлением

`test_term_readat.d` проверяет `Term.isAvailable()` и выходит с SKIP если нет TTY. В CI/CD без консоли — только `test_term.d` (без readAt).

### TermTable: colWidths без padding

`TermTable([8, 6])` — колонки 8 и 6 символов. На экране каждая колонка занимает `colWidth + 2` (padding по 1 с каждой стороны). Полная ширина таблицы: `sum(colWidths) + 3 * numCols + 1` символов.

Для таблицы `[8, 6]`: `(8+2+1) + (6+2+1) = 11 + 9 = 20` символов.

### TermTable: toString проверяется по символам рамки (bytes, не dchar)

```d
// Верхняя граница — первые 3 байта == "┌" (3-байтный UTF-8 символ):
assert(lines[0][0..3] == "┌");
// Не lines[0][0] == '┌' — это dchar-сравнение через byDchar.
// byte-slice работает только если символ ровно 3 байта (все box-drawing — ровно 3).
```

### setAttr + resetStyle

```d
Term.setAttr(Attr.Bold);
Term.put("Bold text");
Term.flush();
Term.resetStyle();   // НУЖНО после setAttr — иначе Bold продолжится
Term.flush();
```

### Кириллица в _displayWidth

`_displayWidth` считает `dchar`-ы через `foreach (dchar _; s) w++`. Это корректно для любого Unicode, включая кириллицу (один `dchar` = одна экранная ячейка для Basic Multilingual Plane). Не используйте `s.length` для ширины кириллических строк.

### gui_term_form: putDchar вместо put для dchar[]

В `gui_term_form.d` поле ввода хранится как `dchar[]`, вывод — через локальную функцию `putDchar(t, dc)`:

```d
void putDchar(arsd.terminal.Terminal* t, dchar ch) {
    char[4] tmp;
    import std.utf : encode;
    auto n = encode(tmp, ch);
    t.write(cast(string) tmp[0..n].idup);
}
```

`Term.put(dchar)` делает то же самое — используйте его в публичном API.

---

## 12. Turbo Vision vs qte56_term — когда что использовать

| Критерий | qte56_term (arsd.terminal) | Turbo Vision (qte56_tvision.dll) |
|----------|---------------------------|----------------------------------|
| Зависимости | 0 (чистый D) | qte56_tvision.dll, TUI C++ runtime |
| Размер | ~640 строк кода | ~35 C-функций + C++ backend |
| Сложность | Простой API | Event loop, Application, Views |
| Мышь | Через arsd backend (сложнее) | Встроенная поддержка |
| Готовые виджеты | Нет (рисование вручную) | Да (Dialog, MenuBar, Button...) |
| Когда использовать | Простые TUI, таблицы, прогресс-бары, логи | Полноценные TUI-приложения с меню/диалогами |
| Platform | Win+Linux из коробки | Win+Linux (через CMake build) |
| Индексы pFunQt | Не использует (standalone) | 19850–19884 |

**Правило выбора**: если нужен вывод таблиц, раскрашенного текста, простой прогресс-бар — `qte56_term`. Если нужно меню, диалоги, навигация клавиатурой/мышью — Turbo Vision.

---

## 13. Структура BoxChars (дополнительный справочник)

Визуальное расположение символов в рамке (Single):

```
topLeft  teeDown  topRight       ┌──┬──┐
hLine    hLine    hLine          │  │  │
teeLeft  cross    teeRight       ├──┼──┤
vLine    vLine    vLine          │  │  │
bottomLeft teeUp  bottomRight    └──┴──┘
```

`drawHSep(x, y, colWidths, bs)` рисует строку `├──┬──┤` — используется для внутренних горизонтальных разделителей, если строится кастомный layout без TermTable.

---

## 14. Быстрая шпаргалка

```d
import qte56_term;

// Минимальный шаблон:
Term.setup();
scope(exit) Term.cleanup();

// Позиционирование (0-based, col первый!):
Term.moveTo(col, row);

// Цвет + вывод:
Term.setFg(Color.BrightGreen);
Term.setBg(Color.Blue);
Term.put("text");
Term.resetStyle();
Term.flush();

// Комбо:
Term.putStyledAt(5, 3, "Hello", Color.Yellow, Color.Black, Attr.Bold);
Term.flush();

// Рамка:
Term.drawBox(0, 0, 40, 10, BoxStyle.Double);
Term.flush();

// Таблица:
auto t = TermTable([10, 8, 6]);
t.setHeader(["Name", "Value", "ID"]);
t.setAligns([Align.Left, Align.Right, Align.Center]);
t.addRow(["foo", "123", "1"]);
t.render(0, 12);
Term.flush();

// Размер экрана:
int w = Term.width();
int h = Term.height();

// Чтение с экрана (только Windows):
string s = Term.readAt(col, row, len);
```

---

## Навигация

- ↑ [AGENTS.md](AGENTS.md) — точка входа
