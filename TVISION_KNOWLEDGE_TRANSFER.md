# Turbo Vision TUI Subsystem — Knowledge Transfer Document

> ↑ Навигация: [AGENTS.md](AGENTS.md)

Документ написан для AI-ассистента, который будет разрабатывать TUI-приложения на базе
подсистемы Turbo Vision в проекте QTE56. Плотное изложение: история, архитектура, API,
паттерны, примеры, ловушки.

---

## 1. Что такое Turbo Vision

Turbo Vision — TUI-фреймворк, созданный Borland (1990) для Turbo Pascal и C++.
Полноэкранный интерфейс с окнами, диалогами, меню, строкой статуса, поддержкой мыши,
двойной буферизацией и собственной событийной моделью. Не GUI: рисует в терминале
псевдографикой.

**magiblot/tvision** — современный C++17 порт (github.com/magiblot/tvision).
Поддерживает Windows (Win32 Console API) и Linux/macOS (ncurses).
Компилируется без CMake (достаточно `-std=c++14`), не зависит от Qt.

В QTE56 tvision интегрирован как отдельная DLL по образцу QScintilla:
статически слинкован в `qte56_tvision.dll`, D-сторона использует тот же
`pFunQt`/`registerModule`-паттерн.

---

## 2. Архитектура

### 2.1 Файловая структура

```
arch_new/
├── tvision/                          # magiblot/tvision исходники
│   ├── include/tvision/tv.h          # главный заголовок (define Uses_XXX перед include)
│   ├── source/tvision/*.cpp          # ~178 файлов
│   ├── source/platform/*.cpp         # ~29 файлов (win32con и др.)
│   ├── build32/libtvision.a          # pre-built статическая библиотека (1.4 MB; build64/ для 64-bit)
│   └── build_tvision.bat             # строит libtvision.a + qte56_tvision.dll
├── cpp/qt5/qte56_tvision/
│   ├── qte56_tvision.h               # C-обёртка: 37 extern "C" экспортов
│   └── qte56_tvision.cpp             # реализация: subclass TApplication + все виджеты
├── d/gen/gen_tvision.d               # D-binding: pFunQt[19850–19884] + tvMessageBox[20155]
├── dll/dll32/qte56_tvision.dll       # 531 KB, tvision статически слинкован
└── test/
    ├── gui_tv_hello.d                # Hello World: меню, диалог, строка статуса
    └── build_tv_hello.bat
```

### 2.2 Принцип работы

Turbo Vision требует subclass-ов для `TApplication` (переопределить `initMenuBar`,
`initStatusLine`, `handleEvent`). В DLL-обёртке определён класс `TvApp : TApplication`
с тремя глобальными callback-указателями:

```cpp
static TvMenuBarInitFn    g_menuBarInit;    // D → initMenuBar
static TvStatusLineInitFn g_statusLineInit; // D → initStatusLine
static TvEventHandlerFn   g_eventHandler;   // D → handleEvent
static TvIdleFn           g_idleFn;         // D → idle (опционально)
```

`tvApp_create` сохраняет указатели и создаёт `new TvApp()`. Tvision во время
`TvApp::TvApp()` сразу вызывает `initMenuBar` и `initStatusLine` через статические
методы, которые форвардят в callback. D-сторона через callback строит меню/статус с
помощью `TvMenuBuilder` / `tvBuildStatusLine`.

### 2.3 Index block (pFunQt)

Все 36 функций занимают слоты `pFunQt[19850]` … `pFunQt[19884]` (35 штук) плюс
расширение `pFunQt[20155]` (`tvMessageBox`).
`registerModule("Tvision", "qte56_tvision.dll", &loadTvision)` вызывается из
`static this()` в `gen_tvision.d`. `LoadQt("./dll/dll32")` в `main()` триггерит загрузку DLL и
`GetProcAddress` для каждой функции.

На Linux: `dll` → fallback `lib`, `qte56_tvision.dll` → `libqte56_tvision.so`.

---

## 3. Все 36 экспортированных функций

### 3.1 TApplication (19850–19853)

| Индекс | Имя C | D-обёртка | Сигнатура C |
|--------|-------|-----------|-------------|
| 19850 | `tvApp_create` | `TvApp(menuInit, statusInit, eventHandler)` | `void* (void*, void*, void*)` |
| 19851 | `tvApp_run` | `app.run()` | `void (void*)` |
| 19852 | `tvApp_delete` | `app.destroy()` | `void (void*)` |
| 19853 | `tvApp_setIdle` | `app.setIdle(fn)` | `void (void*, void*)` |

`tvApp_create` принимает три callback-указателя, сохраняет их в глобалах, создаёт
`TvApp`. Конструктор `TvApp` вызывает callbacks немедленно.

`tvApp_run` запускает event loop (блокирует до `cmQuit`).
`tvApp_delete` вызывает `delete (TvApp*)app`. **Не вызывать `UnloadQt()`.**
`tvApp_setIdle` регистрирует функцию, вызываемую в цикле простоя.

### 3.2 Menu builder (19854–19858)

| Индекс | Имя C | D-обёртка | Описание |
|--------|-------|-----------|----------|
| 19854 | `tvMenu_beginBar` | `TvMenuBuilder.begin(rect)` | Начать построение, сохранить rect |
| 19855 | `tvMenu_addSubmenu` | `TvMenuBuilder.addSubmenu(title, hotkey)` | Добавить `TSubMenu` |
| 19856 | `tvMenu_addItem` | `TvMenuBuilder.addItem(title, cmd, hotkey, shortcut)` | Добавить `TMenuItem` в текущее подменю |
| 19857 | `tvMenu_addSeparator` | `TvMenuBuilder.addSeparator()` | Добавить `newLine()` разделитель |
| 19858 | `tvMenu_endBar` | `TvMenuBuilder.end()` → `void*` | Создать и вернуть `TMenuBar*` |

Построитель хранит состояние в глобальном `g_mb` (не потокобезопасен, но TUI
однопоточный). Submenus цепляются через `operator+`. Вызывается только из
`menuBarInit` callback во время `TvApp` конструктора — это единственный момент, когда
rect корректен.

### 3.3 StatusLine (19859)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19859 | `tvStatusLine_create` | `tvBuildStatusLine(rect, labels[], hotkeys[], commands[])` |

C-сигнатура: `void* (void* rect, const char** labels, const int* hotkeys, const int* commands, int count)`.

Автоматически добавляет `F10 → cmMenu` после переданных элементов.
rect обрезается до нижней строки: `r.a.y = r.b.y - 1`.

### 3.4 Dialog (19860–19862)

| Индекс | Имя C | D-обёртка | Описание |
|--------|-------|-----------|----------|
| 19860 | `tvDialog_create` | `tvDialog(x1,y1,x2,y2,title)` → `void*` | `new TDialog(TRect(…), title)` |
| 19861 | `tvDialog_delete` | `tvDialogDelete(dlg)` | `TObject::destroy(dlg)` |
| 19862 | `tvDialog_exec` | `app.execDialog(dlg)` → `int` | `deskTop->execView(dlg)` |

`tvDialog_exec` принимает указатель на `TvApp` (не на диалог) и возвращает команду
(`cmOK`, `cmCancel` или кастомную). Диалог модальный, блокирует event loop до нажатия
кнопки. После `execDialog` объект диалога уничтожен tvision'ом — не вызывать
`tvDialogDelete`.

### 3.5 View insertion (19863)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19863 | `tvView_insert` | `tvInsert(group, view)` |

Вставляет `TView*` в `TGroup*` (диалог, окно). После `insert` владение передаётся
группе. Не удалять `view` самостоятельно.

### 3.6 StaticText (19864)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19864 | `tvStaticText_create` | `tvStaticText(x1,y1,x2,y2,text)` → `void*` |

Нередактируемый текст. Координаты — в символах (col, row) внутри диалога. (0,0) = левый
верхний угол внутренней части диалога (сразу за рамкой).

### 3.7 Button (19865)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19865 | `tvButton_create` | `tvButton(x1,y1,x2,y2,title,command,flags)` → `void*` |

`flags`: `bfNormal()` или `bfDefault()` (кнопка по Enter). `~O~K` — тильды задают
горячую клавишу, подчёркивая букву между ними. Кнопка при нажатии отправляет `command`
в event queue, что завершает `execView`.

### 3.8 InputLine (19866–19868)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19866 | `tvInputLine_create` | `tvInputLine(x1,y1,x2,y2,maxLen)` → `void*` |
| 19867 | `tvInputLine_getText` | `tvGetText(input)` → `string` |
| 19868 | `tvInputLine_setText` | `tvSetText(input, text)` |

`tvGetText` использует буфер `char[512]`, читает `TInputLine::data`. `tvSetText`
устанавливает `data`, `curPos = len`, `selStart = selEnd = 0`, вызывает `drawView()`.
`maxLen` по умолчанию 128 в D-обёртке.

### 3.9 CheckBox (19869–19871)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19869 | `tvCheckBox_create` | `tvCheckBox(x1,y1,x2,y2,label)` → `void*` |
| 19870 | `tvCheckBox_getValue` | `tvCheckBoxValue(cb)` → `int` |
| 19871 | `tvCheckBox_setValue` | `tvCheckBoxSet(cb, val)` |

Реализован через `TCheckBoxes` с одним `TSItem`. `getValue` → 0 или 1. `setValue(1)`
проставляет флаг.

### 3.10 RadioButtons (19872–19874)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19872 | `tvRadioButtons_create` | `tvRadioButtons(x1,y1,x2,y2,labels[])` → `void*` |
| 19873 | `tvRadioButtons_getValue` | `tvRadioValue(rb)` → `int` |
| 19874 | `tvRadioButtons_setValue` | `tvRadioSet(rb, val)` |

Метки передаются в D как `string[]`, конвертируются в `const(char*)*`. C++ строит
`TSItem` linked list в обратном порядке. `getValue` возвращает 0-based индекс выбранной
кнопки.

### 3.11 Label (19875)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19875 | `tvLabel_create` | `tvLabel(x1,y1,x2,y2,text,link)` → `void*` |

`link` — указатель на связанный виджет (напр. InputLine); клик по Label фокусирует `link`.
Передать `null` если не нужен.

### 3.12 Window + Desktop (19876–19877)

| Индекс | Имя C | D-обёртка |
|--------|-------|-----------|
| 19876 | `tvWindow_create` | `tvWindow(x1,y1,x2,y2,title,num)` → `void*` |
| 19877 | `tvDesktop_insert` | `app.insertWindow(win)` |

`tvWindow` создаёт `TWindow`. `num` — номер окна (для горячей клавиши `Alt-N`), 0 = без
номера. `insertWindow` вставляет в `deskTop` (не модально).

### 3.13 Constants (19878–19884)

| Индекс | D-функция | Описание |
|--------|-----------|---------|
| 19878 | `cmQuit()` | `cmQuit` из tvision (обычно 1) |
| 19879 | `cmCancel()` | `cmCancel` (обычно 2) |
| 19880 | `cmOK()` | `cmOK` (обычно 10) |
| 19881 | `bfDefault()` | `bfDefault` (кнопка по Enter) |
| 19882 | `bfNormal()` | `bfNormal` (обычная кнопка) |
| 19883 | `evCommand()` | тип события: команда |
| 19884 | `evBroadcast()` | тип события: broadcast |

Все константы — runtime-вызовы в DLL, не compile-time. Значения определены внутри
tvision и читаются через `GetProcAddress`. Не кешировать до `LoadQt()`.

### 3.14 MessageBox (20155)

| Индекс | Имя C | D-обёртка | Описание |
|--------|-------|-----------|----------|
| 20155 | `tvMessageBox` | `tvMessageBox(msg, options)` → `int` | Встроенный messageBox tvision |

`options` = класс диалога | кнопки (константы `mfXxx` из `gen_tvision.d`:
`mfWarning/mfError/mfInformation/mfConfirmation` + `mfYesButton/mfNoButton/mfOKButton/mfCancelButton`,
комбинации `mfYesNoCancel`, `mfOKCancel`). Возвращает `cmOK()`/`cmCancel()`/`cmYes`/`cmNo`
(`cmYes`/`cmNo` — compile-time enum 12/13). Пример:
`int r = tvMessageBox("Delete file?", mfConfirmation | mfYesNoCancel);`

---

## 4. D-типы и структуры из gen_tvision.d

### 4.1 Callback-типы

```d
alias TvMenuBarInitFn    = extern(C) void* function(void* rect);
alias TvStatusLineInitFn = extern(C) void* function(void* rect);
alias TvEventHandlerFn   = extern(C) int   function(int what, int command);
alias TvIdleFn           = extern(C) void  function();
```

Все callbacks должны быть `extern(C)`. `@nogc` НЕ требуется для callbacks (в отличие
от внутренних function pointer типов для DLL-вызовов). GC D доступен внутри callbacks.

### 4.2 Struct TvApp

```d
struct TvApp {
    private void* _h;

    this(TvMenuBarInitFn menuInit,
         TvStatusLineInitFn statusInit,
         TvEventHandlerFn eventHandler);  // создаёт DLL-объект

    void run();                     // блокирующий event loop
    void destroy();                 // delete DLL-объекта
    void setIdle(TvIdleFn fn);
    int  execDialog(void* dlg);     // модальный диалог
    void insertWindow(void* win);   // не-модальное окно в desktop
    void* handle();                 // сырой указатель для редких случаев
}
```

`TvApp` — value type (struct). Хранить как `__gshared TvApp app` если callbacks
обращаются к нему.

### 4.3 Struct TvMenuBuilder

```d
struct TvMenuBuilder {
    static void begin(void* rect);
    static void addSubmenu(string title, int hotkey = 0);
    static void addItem(string title, int command, int hotkey = 0, string shortcut = "");
    static void addSeparator();
    static void* end();   // возвращает TMenuBar*
}
```

Все методы статические. Порядок: `begin` → N×(`addSubmenu` + items) → `end`.
`addItem` принадлежит последнему `addSubmenu`. Нельзя добавлять items без submenu.

### 4.4 Keyboard constants (enum в gen_tvision.d)

```d
enum : int {
    kbAltA = 0x1E00, kbAltB = 0x3000, kbAltC = 0x2E00, kbAltD = 0x2000,
    kbAltE = 0x1200, kbAltF = 0x2100, kbAltG = 0x2200, kbAltH = 0x2300,
    kbAltI = 0x1700, kbAltJ = 0x2400, kbAltK = 0x2500, kbAltL = 0x2600,
    kbAltM = 0x3200, kbAltN = 0x3100, kbAltO = 0x1800, kbAltP = 0x1900,
    kbAltQ = 0x1000, kbAltR = 0x1300, kbAltS = 0x1F00, kbAltT = 0x1400,
    kbAltU = 0x1600, kbAltV = 0x2F00, kbAltW = 0x1100, kbAltX = 0x2D00,
    kbAltY = 0x1500, kbAltZ = 0x2C00,
    kbF1 = 0x3B00, kbF2 = 0x3C00, kbF3 = 0x3D00, kbF4 = 0x3E00,
    kbF5 = 0x3F00, kbF6 = 0x4000, kbF7 = 0x4100, kbF8 = 0x4200,
    kbF9 = 0x4300, kbF10 = 0x4400,
}
```

Используются как `hotkey` в `addSubmenu`, `addItem`, `tvBuildStatusLine`.

---

## 5. Жизненный цикл приложения

```
1. LoadQt("./dll/dll32") — загружает qte56_tvision.dll, регистрирует 36 функций
2. TvApp(&m, &s, &e)    — сохраняет callbacks; НЕМЕДЛЕННО вызывает:
                            menuBarInit(rect)   → строит TMenuBar
                            statusLineInit(rect) → строит TStatusLine
                          создаёт TvApp C++
3. app.run()            — запускает event loop; блокирует до cmQuit
4. app.destroy()        — delete TvApp; OS освобождает DLL-память
```

**Критично**: `menuBarInit` и `statusLineInit` вызываются ВНУТРИ конструктора `TvApp`.
К моменту возврата из `TvApp(...)` меню и строка статуса уже созданы.
Если `app` — `__gshared`, его можно использовать в `eventHandler` безопасно (event loop
не стартует до `app.run()`).

---

## 6. menuBarInit callback

Определяет структуру меню верхнего уровня. Вызывается один раз при старте.

```d
extern(C) void* menuBarInit(void* rect) {
    TvMenuBuilder.begin(rect);

    // Первое подменю
    TvMenuBuilder.addSubmenu("~F~ile", kbAltF);
    TvMenuBuilder.addItem("~N~ew",  cmNew,  kbAltN);
    TvMenuBuilder.addItem("~O~pen", cmOpen, kbAltO);
    TvMenuBuilder.addSeparator();
    TvMenuBuilder.addItem("E~x~it", cmQuit(), kbAltX, "Alt-X");

    // Второе подменю
    TvMenuBuilder.addSubmenu("~H~elp", kbAltH);
    TvMenuBuilder.addItem("~A~bout", cmAbout, 0);

    return TvMenuBuilder.end();
}
```

Синтаксис горячих клавиш в заголовках: `~X~` выделяет букву X (подчёркивание в TUI).
`addItem` параметры: `(title, command, hotkey, shortcut_string)`.
- `command` — число, посылаемое как `evCommand` при выборе пункта.
- `hotkey` — скан-код клавиши (например `kbAltG`) для прямого вызова без меню.
- `shortcut` — строка-подсказка (напр. `"Alt-X"`), отображается справа в пункте.

Пользовательские команды: любой `int > 100` (tvision резервирует < 100 для системных).
Рекомендуется `enum : int { cmMyCmd = 100, cmOther = 101, ... }`.

---

## 7. statusLineInit callback

Строка статуса — нижняя строка экрана с горячими клавишами.

```d
extern(C) void* statusLineInit(void* rect) {
    return tvBuildStatusLine(rect,
        ["~Alt-X~ Exit", "~F1~ Help", "~F5~ Run"],
        [kbAltX,         kbF1,        kbF5       ],
        [cmQuit(),       cmHelp,      cmRun       ]);
}
```

`tvBuildStatusLine` автоматически добавляет `F10 → cmMenu` в конец.
Массивы `labels`, `hotkeys`, `commands` должны иметь одинаковую длину.
Строки меток: `~key~` для выделения.

---

## 8. eventHandler callback

Вызывается из `TvApp::handleEvent` для каждого события ПОСЛЕ стандартной обработки.

```d
extern(C) int eventHandler(int what, int command) {
    if (what == evCommand()) {
        switch (command) {
            case 100: myDialog(); return 1;   // обработан
            case 101: doSomething(); return 1;
            default: break;
        }
    }
    if (what == evBroadcast()) {
        // broadcast события (напр. cmScrollBarChanged)
    }
    return 0;  // не обработан — tvision продолжит обработку
}
```

Возврат `1` вызывает `clearEvent(event)` — событие не дойдёт до других обработчиков.
Возврат `0` — стандартная обработка продолжается (важно для `cmQuit` — НЕ перехватывать).
`cmQuit` (Alt-X, Exit из меню) обрабатывается tvision'ом самостоятельно.

В `what` приходят только `evCommand` и `evBroadcast` со значимым `command`.
Для других типов событий `command == 0`.

---

## 9. TvDialog: создание и наполнение

```d
void showMyDialog() {
    // Координаты: (col, row) левого верхнего + правого нижнего угла диалога
    // Отсчёт от левого верхнего угла экрана (0,0)
    auto dlg = tvDialog(10, 5, 70, 20, "Настройки");

    // StaticText: координаты внутри диалога
    tvInsert(dlg, tvStaticText(2, 2, 20, 3, "Имя пользователя:"));

    // InputLine: (x1,y1,x2,y2, maxLen)
    auto inp = tvInputLine(22, 2, 56, 3, 64);
    tvSetText(inp, "default");
    tvInsert(dlg, inp);

    // Label связан с InputLine (клик → фокус на inp)
    tvInsert(dlg, tvLabel(2, 2, 21, 3, "~И~мя:", inp));

    // CheckBox
    auto cb = tvCheckBox(2, 4, 30, 5, "~А~втозапуск");
    tvCheckBoxSet(cb, 1);   // отмечен по умолчанию
    tvInsert(dlg, cb);

    // RadioButtons
    auto rb = tvRadioButtons(2, 6, 30, 10,
        ["~О~птимальный", "~М~аксимальный", "~М~инимальный"]);
    tvRadioSet(rb, 1);      // выбрать второй
    tvInsert(dlg, rb);

    // Кнопки
    tvInsert(dlg, tvButton(36, 12, 48, 14, "~O~K",     cmOK(),     bfDefault()));
    tvInsert(dlg, tvButton(50, 12, 62, 14, "~C~ancel", cmCancel(), bfNormal()));

    int result = app.execDialog(dlg);

    if (result == cmOK()) {
        string name   = tvGetText(inp);
        int autorun   = tvCheckBoxValue(cb);
        int mode      = tvRadioValue(rb);
        // использовать значения
    }
    // dlg уничтожен tvision'ом после execDialog — не вызывать tvDialogDelete
}
```

**Система координат диалога**: (0,0) — левый верхний угол внутренней области (за рамкой).
Рамка занимает 1 символ. Ширина диалога = `x2-x1`, высота = `y2-y1`.

**Типичные размеры**: кнопки `y2 = y1 + 2` (двустрочные), InputLine `y2 = y1 + 1`
(однострочная), CheckBox/RadioButton — по высоте = кол-во элементов.

**Порядок insert**: tvision рисует views в порядке вставки. Вставлять фоновые элементы
первыми, интерактивные — последними. Последний inserted view получает фокус первым.

---

## 10. TvMessageBox (встроенные диалоги)

Нативный `messageBox` tvision экспортирован как `tvMessageBox` (индекс 20155, см. §3.14):

```d
int r = tvMessageBox("Файл будет удалён. Продолжить?", mfConfirmation | mfYesNoCancel);
if (r == cmYes) { /* ... */ }
```

Для произвольного содержимого (несколько строк, нестандартная компоновка) по-прежнему
используйте самодельный диалог с `tvStaticText` + кнопкой:

```d
void showMessage(string msg) {
    int w = cast(int)msg.length + 6;
    if (w < 30) w = 30;
    int cx = 40;
    auto dlg = tvDialog(cx - w/2, 10, cx + w/2, 16, "Сообщение");
    tvInsert(dlg, tvStaticText(2, 2, w-2, 3, msg));
    tvInsert(dlg, tvButton(w/2-5, 4, w/2+5, 6, "~O~K", cmCancel(), bfDefault()));
    app.execDialog(dlg);
}
```

---

## 11. TInputLine: текстовый ввод

```d
// Создание с позицией и максимальной длиной
auto inp = tvInputLine(x1, y1, x2, y2, maxLen);

// Установить начальный текст (до вставки в диалог или после — оба варианта работают)
tvSetText(inp, "initial value");

// Вставить в диалог
tvInsert(dlg, inp);

// Читать после execDialog (если result == cmOK())
string text = tvGetText(inp);   // возвращает idup строку
```

`tvGetText` читает `TInputLine::data` напрямую через буфер `char[512]` — безопасно до
511 символов. `tvSetText` вызывает `drawView()` — работает только если view вставлен в
отображаемый диалог; установка до вставки тоже корректна (drawView игнорируется если
view не на экране).

---

## 12. Поддержка мыши

Turbo Vision обрабатывает мышь автоматически: клик по пунктам меню, кнопкам, InputLine,
CheckBox, RadioButtons работает без дополнительного кода. `TvApp::handleEvent` в C++
вызывает базовый `TApplication::handleEvent` первым, поэтому стандартные mouse events
обрабатываются до вызова D-callback'а.

Кастомная обработка мыши в `eventHandler`: в текущей реализации callback получает только
`what` и `command` — координаты мыши не передаются. Для кастомной мышиной логики
потребуется расширить C-обёртку (передавать `event.mouse.where.x/y`).

---

## 13. Паттерн Alt-X для выхода

Alt-X → `cmQuit` — стандартный tvision-паттерн. Реализуется в трёх местах:

**В меню** (пункт Exit):
```d
TvMenuBuilder.addItem("E~x~it", cmQuit(), kbAltX, "Alt-X");
// kbAltX = 0x2D00 — правильный скан-код для прямого хоткея вне меню
```

**В строке статуса**:
```d
return tvBuildStatusLine(rect,
    ["~Alt-X~ Exit"],
    [kbAltX],
    [cmQuit()]);
```

**В eventHandler**: НЕ перехватывать `cmQuit`. tvision обрабатывает его сам — завершает
event loop и возвращает управление из `app.run()`.

**Примечание о gui_tv_hello.d**: demo передаёт `cmQuit()` вместо `kbAltX` как третий
аргумент `addItem`. Это работает для пункта меню (command всё равно `cmQuit`), но
отключает прямой горячий клавишный вызов вне меню. Правильно: `kbAltX`.

---

## 14. Полный рабочий пример

Приложение с меню (File + Help), диалогом ввода, строкой статуса.

```d
// myapp.d
module myapp;

import gen_tvision;

enum : int {
    cmShowDialog = 100,
    cmAbout      = 101,
}

__gshared TvApp app;

extern(C) void* menuBarInit(void* rect) {
    TvMenuBuilder.begin(rect);

    TvMenuBuilder.addSubmenu("~F~ile", kbAltF);
    TvMenuBuilder.addItem("~D~ialog", cmShowDialog, kbAltD, "Alt-D");
    TvMenuBuilder.addSeparator();
    TvMenuBuilder.addItem("E~x~it", cmQuit(), kbAltX, "Alt-X");

    TvMenuBuilder.addSubmenu("~H~elp", kbAltH);
    TvMenuBuilder.addItem("~A~bout", cmAbout, 0);

    return TvMenuBuilder.end();
}

extern(C) void* statusLineInit(void* rect) {
    return tvBuildStatusLine(rect,
        ["~Alt-D~ Dialog", "~Alt-X~ Exit"],
        [kbAltD,           kbAltX         ],
        [cmShowDialog,     cmQuit()        ]);
}

void showDialog() {
    auto dlg = tvDialog(15, 5, 65, 18, "Ввод данных");

    tvInsert(dlg, tvStaticText(2, 2, 22, 3, "Введите имя:"));
    auto inp = tvInputLine(22, 2, 48, 3, 64);
    tvInsert(dlg, inp);
    tvInsert(dlg, tvLabel(2, 2, 21, 3, "~И~мя:", inp));

    auto cb = tvCheckBox(2, 4, 30, 5, "~З~апомнить");
    tvInsert(dlg, cb);

    auto rb = tvRadioButtons(2, 6, 30, 10,
        ["~О~бычный", "~А~дмин", "~Г~ость"]);
    tvInsert(dlg, rb);

    tvInsert(dlg, tvButton(34, 11, 46, 13, "~O~K",     cmOK(),     bfDefault()));
    tvInsert(dlg, tvButton(48, 11, 60, 13, "~C~ancel", cmCancel(), bfNormal()));

    int r = app.execDialog(dlg);
    if (r == cmOK()) {
        string name  = tvGetText(inp);
        int remember = tvCheckBoxValue(cb);
        int role     = tvRadioValue(rb);
        // обработать: name / remember / role
    }
}

void showAbout() {
    auto dlg = tvDialog(25, 8, 55, 15, "О программе");
    tvInsert(dlg, tvStaticText(3, 2, 27, 3, "MyApp v1.0"));
    tvInsert(dlg, tvStaticText(3, 3, 27, 4, "QTE56 + Turbo Vision"));
    tvInsert(dlg, tvButton(12, 5, 24, 7, "~O~K", cmCancel(), bfDefault()));
    app.execDialog(dlg);
}

extern(C) int eventHandler(int what, int command) {
    if (what == evCommand()) {
        if (command == cmShowDialog) { showDialog(); return 1; }
        if (command == cmAbout)      { showAbout();  return 1; }
    }
    return 0;
}

void main() {
    import qte56_loader : LoadQt;
version(X86) {
    LoadQt("./dll/dll32");
} else {
    LoadQt("./dll/dll64");
}   // qte56_tvision.dll должен быть там или в PATH

    app = TvApp(&menuBarInit, &statusLineInit, &eventHandler);
    app.run();       // блокирует до Alt-X / Exit
    app.destroy();
}
```

---

## 15. Сборка

### 15.1 Сборка D-программы

```bat
dmd -m32 ^
    myapp.d ^
    d\gen\gen_tvision.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    -Id -Id\gen ^
    -of=myapp.exe
```

Запуск из `arch_new/` — `dll/dll32/qte56_tvision.dll` должен быть в `PATH` или найден
через `LoadQt("./dll/dll32")` (для 64-bit — `dll/dll64`, см. паттерн `version(X86)`
в `test/gui_tv_hello.d`).

Зависимости: только `qte56_tvision.dll` (tvision статически слинкован внутри).
Qt DLL не нужны.

### 15.2 Пересборка qte56_tvision.dll (только при изменении C++)

```bat
cd arch_new
tvision\build_tvision.bat
```

Скрипт требует заданной переменной окружения `QTE56_ARCH` (`32`/`64`; задаётся через
`a.cmd` в корне проекта) и работает так:
1. Если `tvision/build<ARCH>/libtvision.a` отсутствует — компилирует все `source/tvision/*.cpp`
   и `source/platform/*.cpp` (исключая `geninc.cpp`), создаёт статическую библиотеку.
2. Линкует DLL (для 32-bit):

```
g++ -std=c++14 -O2 -m32 -shared
    -DTVISION_NO_STL -D_CRT_NONSTDC_NO_WARNINGS -D_WIN32_WINNT=0x0600
    -Itvision/include -Itvision/include/tvision -Itvision/include/tvision/compat/borland
    cpp/qt5/qte56_tvision/qte56_tvision.cpp
    -Ltvision/build32 -ltvision
    -lgdi32 -luser32
    -o dll/dll32/qte56_tvision.dll
    -Wl,--out-implib,dll/dll32/libqte56_tvision.a
```

Компилятор: MinGW g++ 7.3.0, 32-bit. CMake не нужен. Qt не нужен.
`TVISION_NO_STL` — tvision использует собственные контейнеры.

---

## 16. Сравнение: Turbo Vision vs qte56_term.d vs Qt

| Критерий | Turbo Vision | qte56_term.d | Qt (QTE56) |
|----------|-------------|--------------|------------|
| Меню, диалоги, формы | Встроено | Ручная реализация | QDialog, QMenuBar |
| Зависимость от Qt | Нет | Нет | Да |
| Зависимость от DLL | `qte56_tvision.dll` | `arsd.terminal` (1 файл) | 15+ Qt DLL |
| Мышь | Автоматически | `readAt` (базово) | Полная поддержка |
| Кириллица | CP866 / ограничено | `putDchar` (UTF-8) | Полная Unicode |
| Сложность кода | Средняя | Низкая | Низкая (высокоуровневый API) |
| Целевой сценарий | TUI-приложения с UI | Таблицы, прогресс, лог | GUI-приложения |
| SSH / headless | Да (Win32 Console) | Да | Нет |
| Размер зависимостей | ~531 KB DLL | 0 KB (в exe) | 30+ MB DLL суммарно |

**Выбирать Turbo Vision** когда нужны: настоящие диалоги с Tab-навигацией, формы с
вводом, меню, мышь — но без Qt. Серверные утилиты, конфигураторы, инструменты.

**qte56_term.d** (`arsd.terminal`) — когда достаточно таблиц, прогресс-бара, простого
ввода. Нет зависимости от DLL вообще.

**Qt** — когда нужен полноценный GUI, изображения, веб, OpenGL.

---

## 17. Известные ограничения и ловушки

### 17.1 Глобальное состояние menu builder

`tvMenu_beginBar/addSubmenu/addItem/endBar` используют глобальный `g_mb` в C++.
Нельзя строить два menu bar одновременно. TUI однопоточный — на практике не проблема.

### 17.2 Владение памятью

После `tvView_insert(group, view)` владение view передаётся group. Не вызывать
`free`/`delete` на view вручную.

После `app.execDialog(dlg)` диалог уничтожается tvision'ом. Не вызывать `tvDialogDelete`.
`tvDialogDelete` — только для диалогов, которые НЕ были переданы в `execDialog`.

После `app.destroy()` все tvision-объекты уничтожены. Не обращаться к `void*` хендлам.

### 17.3 Порядок вызовов

`LoadQt("./dll/dll32")` — до `TvApp(...)`. Иначе `pFunQt[19850]` == `null` → segfault.

`TvApp` конструктор вызывает callbacks немедленно. Если `app` используется внутри
`menuBarInit` — он ещё не инициализирован. Не обращаться к `app.handle()` из
`menuBarInit`/`statusLineInit`.

### 17.4 Координаты диалога

Tvision использует абсолютные координаты экрана для диалога (`tvDialog`) и
относительные координаты (внутри диалога) для view. Координата (0,0) внутри диалога —
за рамкой. Рамка занимает 1 символ по каждому краю.

View, выходящий за границы диалога, не проверяется tvision и частично не отображается.
View с y=0 или y=height-1 перекрывается рамкой диалога.

### 17.5 Кириллица

Turbo Vision на Windows использует CP866 (DOS-кодировка). Если исходник D в UTF-8
(DMD default), строки с кириллицей в заголовках меню/диалогов могут отображаться
некорректно. Варианты: ASCII-заголовки, или конвертировать UTF-8 → CP866 перед передачей
в tvision. Тест `gui_tv_hello.d` использует только латиницу.

### 17.6 `__gshared app`

Если callbacks обращаются к глобальному `app` (напр. `app.execDialog(dlg)`), объявить
`__gshared TvApp app`. `TvApp` — value type (struct), поэтому нужен именно `__gshared`,
а не просто глобальная переменная (иначе TLS-копия в каждом потоке, хотя TUI
однопоточный).

### 17.7 Linux

На Linux `qte56_tvision.dll` → `libqte56_tvision.so`. `LoadQt` ищет fallback в
`lib/`. Сборка через `build_merged_dlls.sh`. tvision на Linux использует ncurses вместо
Win32 Console API.

### 17.8 evCommand в eventHandler

Callback вызывается для ВСЕХ событий, но `command` заполнен только для `evCommand` и
`evBroadcast`. Для других типов (`evKeyboard`, `evMouse`) `command == 0`. Всегда
проверять `what` перед `command`.

### 17.9 TvMessageBox в C-API

Нативный `messageBox()` tvision обёрнут: `tvMessageBox(msg, options)` (индекс 20155,
константы `mfXxx` в `gen_tvision.d`, см. §3.14 и §10). Самодельный диалог (раздел 10)
нужен только для нестандартной компоновки. Расширение C-обёртки новыми функциями —
через `qte56_tvision.cpp` и свободные индексы (`qte index gaps`; tvision-блок: 19850–19884,
расширения: 20155, TermView 20169–20175).

### 17.11 TermView — VT-100 терминал (2026-08-06, mterm)

`TermView : TSurfaceView` — полноэкранный терминал с клеточным буфером
`TDrawSurface` и минимальным VT-100/ANSI парсером (CR/LF/BS/TAB, CSI H/f/A-D/J/K/m,
SGR: reset/bold/underline/reverse/30-37/40-47/90-97/100-107, скролл, состояние
парсера между вызовами). Экспорты: `tvTerm_create`(20169), `tvTerm_write`(20170),
`tvTerm_clear`(20171), `tvTerm_setKeyHandler`(20172), `tvTerm_setCursorVisible`(20173),
`tvTerm_size`(20174), `tvTerm_flush`(20175); D-обёртки `tvTerm/tvTermWrite/...` в
`gen_tvision.d`.

- **Кодировка ввода: UTF-8** (TScreenCell хранит UTF-8 в `TCellChar::moveMultiByteChar`).
  cp1251 → UTF-8 — на стороне D (в mterm собственные таблицы, без QTextCodec).
- **Потоки:** `tvTermWrite/tvTermClear` потокобезопасны (C++ CRITICAL_SECTION,
  обновляют только буфер + dirty-флаг). Перерисовку делает `tvTermFlush` —
  ТОЛЬКО из GUI-потока (паттерн: `app.setIdle(&onIdle)`, в idle `tvTermFlush(term)`).
- **Key handler:** `extern(C) void cb(void* userdata, int keyCode, int shiftState,
  const(char)* text, int textLen)` — сырые `ev.keyDown.keyCode/controlKeyState`
  + UTF-8 текст клавиши. Все evKeyDown перехватываются (clearEvent).
- Курсор рисуется reverse-ячейкой поверх в `draw()` (временная инверсия атрибута).
- Вставка на весь desktop: `term = tvTerm(0, 1, W, H-1); app.insertWindow(term);`
  (W/H — из rect в `menuBarInit`: TRect = 4 int).
- Приложение-пример: `apps/mterm/mterm.d` (консоль MiniMono VM, MUMPS).

### 17.10 Кнопка bfDefault и Enter

Ровно одна кнопка в диалоге должна иметь `bfDefault()` — она активируется по Enter.
Если несколько кнопок с `bfDefault` — tvision берёт первую. Если ни одной — Enter не
закрывает диалог.

---

## 18. Быстрый справочник: минимальное приложение

```d
import gen_tvision;
import qte56_loader : LoadQt;

__gshared TvApp app;

extern(C) void* menuBarInit(void* rect) {
    TvMenuBuilder.begin(rect);
    TvMenuBuilder.addSubmenu("~F~ile", kbAltF);
    TvMenuBuilder.addItem("E~x~it", cmQuit(), kbAltX, "Alt-X");
    return TvMenuBuilder.end();
}

extern(C) void* statusLineInit(void* rect) {
    return tvBuildStatusLine(rect, ["~Alt-X~ Exit"], [kbAltX], [cmQuit()]);
}

extern(C) int eventHandler(int what, int command) { return 0; }

void main() {
    LoadQt("./dll/dll32");   // 64-bit: "./dll/dll64"
    app = TvApp(&menuBarInit, &statusLineInit, &eventHandler);
    app.run();
    app.destroy();
}
```

Сборка:
```bat
dmd -m32 myapp.d d\gen\gen_tvision.d d\qte56_core.d d\qte56_loader.d -Id -Id\gen -of=myapp.exe
```

---

## Навигация

- ↑ [AGENTS.md](AGENTS.md) — точка входа
