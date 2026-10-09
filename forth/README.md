# forthD — Forth-интерпретатор на D для консоли, Windows API и QtE56

> Порт реализации **SPF-Fork (2005–2013, mOleg)** на язык D (Мохов Г.В., 2015).
> Ядро — 32-разрядный D с naked-asm: шитый код компилируется в x86
> (`CALL=0xE8`, `JMP=0xE9`). Собирается **только** `dmd -m32`.

---

## 1. Архитектура ядра (`forth.d`)

| Компонент | Реализация |
|---|---|
| Вершина стека данных (TOS) | регистр `EAX` |
| Стек данных | `EBP` (растёт вниз) |
| Стек возвратов | нативный `ESP` |
| Локальный стек | `ESI` |
| Кодофайл | `VirtualAlloc(PAGE_EXECUTE_READWRITE)`, 40960 ячеек (160 Кбайт) |
| Стеки данных/возвратов | 1000 ячеек каждый |
| Вход с хоста | `initForth()`, `evalForth(string)`, `executeForth(адр, nпар, ...)` |
| Мост D ↔ Форт | общая таблица `getCommonAdr(n)` / `setCommonAdr(n, adr)` (256 ячеек) |

Бутстрап ядра уже включает: `CONST`, `VAR`, `CREATE`, `DOES>`,
`IF/ELSE/THEN`, `DO/LOOP`, `BEGIN/UNTIL`, `S"`, `[CHAR]`, `WORD`,
`DDUP`, `BMOVE`, полноценные `CATCH/THROW` (с размоткой нативных вызовов).

Два варианта сборки ядра:
- **консольный** (по умолчанию) — вывод в консоль работает;
- **GUI**: `-version=ForthNoConsole` — консольные слова получают заглушки,
  ядро не тянет консольный CRT (нужно для встраивания в Qt-приложения).

## 2. Хосты (варианты исполнения)

| Файл | Назначение | Сборка |
|---|---|---|
| `console_forth.d` | Консольный REPL (cmd.exe): читает строку → `evalForth()` → показывает стек и время выполнения в мкс | `dmd -m32 forth.d console_forth.d -Luser32.lib -ofconsole_forth.exe` |
| `console5_forthd.d` | GUI-вариант консоли на QtE56 | см. заголовок файла |
| `qtforth.d` | Демо: GUI на QtE56, логика на Форте. Клик → D-слот → `evalForth` → Форт меняет QLabel через общую таблицу | см. заголовок файла |
| `forthdll.d` | Ядро как DLL для встраивания | — |

Файлы Форта грузятся **аргументами командной строки** (хост читает файл и
скармливает строки в `evalForth`; слово `INCLUDED` из ядра убрано):

```bash
console_forth.exe heap.f strings.f console.f wincon.f repl.f myfile.f
```

## 3. Стандартное окружение (файлы `.f`)

| Файл | Возможности |
|---|---|
| `stdlib.f` | Автозагрузка. Вызов произвольных DLL: `Lib"`, `Library@`, `LibraryLoad`, `_-Call"`, `GADR-Call"`, `CDECL-Call"`, `WINAPI-Call"` (cdecl/stdcall/pascal, 0..20 параметров) |
| `heap.f` | CRT-куча msvcrt: `HALLOC/HFREE/HFREEALL`, heap-строки |
| `strings.f` | Строки на heap-куше: конкатенация `S+`, `N>S` (число → строка), освобождение `$` |
| `console.f` | Консольные слова по мотивам Forth-83: `EMIT`, `."`, работа с crt |
| `wincon.f` | Windows-консоль: цвета, курсор, клавиатура (нужен `chcp 1251`) |
| `repl.f` | REPL целиком на Форте (вместо D-цикла хоста) |
| `win.f` | Обширный набор слов поверх Windows API |
| `vb.f` | BSTR-механика, OLE-куча, `CoInitialize`, `VB-CREATEOBJ`, user32/shell32/ole32 |
| `com.f` | COM-автоматизация уровня C: vtbl-вызовы + `IDispatch` |

## 4. Двусторонняя интеграция с внешним миром

### Форт → DLL (прямой вызов)

Любая функция любой DLL вызывается словами `_-Call"` / `CDECL-Call"` /
`WINAPI-Call"` из stdlib.f. Детали и тесты: `call.md`, тестовая DLL `test/cbtest.dll`.

### Внешний код → Форт (callback'и)

Слова-фабрики `stdlib.f` изготавливают **thunk** — точку входа в Форт-слово,
которую можно отдать Windows (`WndProc`, `EnumWindowsProc`, таймеры),
C-библиотекам (компаратор `qsort`) или любой DLL:

```forth
: ON-COMPARE ( a b -- res ) 2DUP = IF 2DROP 0 ELSE < IF -1 ELSE 1 THEN THEN ;
' ON-COMPARE 2 MK-CDECL-CB CONST CMP-CB   \ CMP-CB = адрес cdecl-функции
```

| Слово | Соглашение | Аргументы thunk'а |
|---|---|---|
| `MK-WINAPI-CB ( xt n -- addr )` | stdcall | 0..63 |
| `MK-CDECL-CB ( xt n -- addr )` | cdecl | 0..63 |

Из callback'а можно вызывать DLL обычными словами (вложенные вызовы работают).
Подробности: `callback.md`.

### QtE56

- `qtforth.d` + `qt_app.f` — сквозной цикл **Qt → D → Форт → Qt** без
  моста: коллбэки живут в D, Форт исполняется через `evalForth`,
  обратно ходит через ячейки общей таблицы (`fw_setText`, ячейка 30).
- `testQtE5.f` — загрузка QtE5-библиотек непосредственно из Форта.

## 5. Тесты и примеры

- `test.f`, `t_call.f`, `t_qi.f` — проверки вызовов и интерфейса;
- `test/` — тест callback'ов: генератор `gen_cbtest.py`, DLL `cbtest.dll`
  (cdecl/stdcall/pascal), раннер `run_cb.bat`;
- `bench.f` — бенчмарк;
- `com.f` + `vb.f` — примеры COM-автоматизации;
- `qt_app.f`, `testQtE5.f` — Qt-интеграция.

Smoke-тест REPL: `2 3 +` → `[1]-> 5`; `: SQ DUP * ;` затем `5 SQ .` → `25`.

## 6. Прочие файлы

- `asc1251.d` — перекодировка CP1251 (1542 строки);
- `fio.f` — файловый ввод/вывод;
- `ICONS/` — иконки GUI-приложений;
- `stdlib_old.f` — предыдущая версия stdlib.

## 7. Документация по подсистемам

- `support_forth.md` — состояние ядра и план исправлений (для AI-агентов);
- `call.md` — план и эталон тестирования `_-Call"` (соглашения cdecl/stdcall/pascal, 0..20 параметров);
- `callback.md` — полное описание callback-механизма (thunk'и, соглашения, ограничения);
- `arPanic.md`, `mOleg.md` — рабочие заметки.

## 8. Ограничения

1. Только **32-бит** (`dmd -m32`) — naked asm в ядре; 64-бит нет.
2. THROW внутри недостроенного определения оставляет его в словаре.
3. Кодофайл фиксирован (160 Кбайт) — словарь исчерпываем, следите за `HERE`.
4. Часть `.f`-файлов (`repl.f`, `wincon.f`, `heap.f`, `strings.f`) — в
   кодировке CP1251; перед правками проверяйте кодировку.
