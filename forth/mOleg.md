# SPF-Fork ( forth mOleg'а ) — полные результаты сканирования

Источник: `i:\d_proj\fork`. Дата сканирования: сентябрь 2025 (файлы системы 2006–2015).
Форк SP-Forth 4.x, автор ~mOleg (mOlegg@ya.ru, 2005–2013; отдельные файлы
унаследованы от A.Cherezov, 1992–2000). Версия сборки **4.10, билд 752**
(`version.f`). Результат сборки именуется `VM-N.exe` + копия `fork.exe`.

Кодировки: почти всё в **CP866** (часть комментариев — CP1251), читать через
`iconv -f CP866` (или CP1251). Расширение исходников — `.fts`.

---

## 1. Сборка и запуск

- `make.bat` (корень, вывод на экран) или `log.bat` (в `make.log`) → чистка
  `clear.bat` → **`target\util\spf.exe kernel\make.f`** → `test.bat`
  (тесты в `test.log`). `save.bat` — архив `src<версия>-mc<sub>@дата.zip`
  (нужен 7z).
- Запуск: `fork.exe <файл.fts> [BYE]`. При старте автоматически
  подключается `fork.ini` (пути `lib/ways.fts`, стеки, дамп, see, help;
  отключается `0 TO SPF-INIT?`).
- Инвентарь корня: `fork.exe`/`4.10-752.exe`/`noinit.exe` (~48 КБ),
  `image.bin` (метакомпилированный образ ~45 КБ), `names.xrf` (кросс-референс
  слов), `fork.ini`, `options.f`, `fd.txt` (~1 МБ, документация),
  `fork.udd`, `troubles` (не баг-лист, а идеи/долги), `objdump.exe`,
  `target\spf.err` (таблица кодов Win32-исключений: ACCESS_VIOLATION,
  STACK_OVERFLOW и т.д. — для текстов сообщений).

### Опции (options.f)

ALIGN-BYTES=1 (в СПФ 4.18 было 16 — контроль размера ядра), IMAGE-SIZE=2048 КБ,
стеки: RS=128 КБ, DS=64 КБ, LS=16 КБ, 20 словарей в контексте, threads#=32
(хеш-треды словарей), strcnt#=3 (счётчик строки переменной длины).
Оптимизатор в собранной системе временно отсутствует (в целевом компиляторе
— «частично подавлен»).

### troubles (долги/идеи, не баги)

Заменить CHARS; MARKER для отката словаря; CSTACK в ядро; StackGuard;
баг в `qcase.fts` (перенесён в samples); исключения в callback «роняют систему»;
binsearch в dll-словарях и т.п.

---

## 2. Метакомпиляция и выбор threading-модели (главная изюминка)

Система **метакомпилируемая**: кросс-компиляция запускается хостом
`target/util/spf.exe` на скрипте `kernel/make.f`. Цепочка:
`selection.f` → `options.f` → `tc_init.f` → `tc_spf.f` → `kernel/fork.f` →
`save-bin` → `kernel/save.win` → готовый exe.

**Целевой компилятор (ЦК)** — `target/tc_spf.f`. Использует три словаря:
- `TFORTH` — образ собираемой системы;
- `TC` — служебные слова ЦК (префикс `tc:`);
- `TC-IMM` — immediate-слова целевой компиляции.

Свой `(interpret)` (`target/new_interpret.f`) ищет слово сначала в TC-IMM
(исполнить), потом в целевом словаре (`tCOMPILE,` — скомпилировать в образ),
потом в хосте; иначе — число/строка. Флаг `in-image` отделяет фазу подготовки
ЦК от фазы целевой сборки (`trg{`/`img{` в `selection.f`).

**Выбор модели** — в `target/selection.f` слова `stc`/`dtc`/`itc`
устанавливают три пути: `kernel/vm/<M>/` (ассемблерные примитивы ФВМ),
`target/<M>/`, `kernel/compiler/<M>/` и константу `ThreadedCode` (1/2/3);
условные скобки `stc{ } dtc{ } itc{ }` компилируют код только для выбранной
модели. Подкаталоги `target/{STC,DTC,ITC}/` содержат:
- `compile.f` (DTC: `CALL,` компилирует `E8 xx xx xx xx`; выравнивание
  заголовков `CODE-ALIGN`; разрешение ссылок `cp\marks.f`),
- `to-forth.f`, `to-tc.f`, `to-tcimm.f` — перенос слов между словарями.

**ВНИМАНИЕ: реально собирается только STC** (подпрограммный шитый код,
«как в СПФ»); DTC («как в СМАЛ32») и ITC (классический) — заготовки,
в `kernel/compiler/{ITC,DTC}/` лишь `about`. Кросс-платформенность аналогично:
`WINDOWS`/`LINUX` выбирают `kernel/OS/{WIN,NIX}/`.

**Результат сборки**: образ выравнивается на 64 КБ, резервируется место под
PE-заголовок (`pe-header# = 0x2000`), сохраняется в **`image.bin`**
(слово `save-bin` из `target/util/add/savebin.f`), затем `kernel/save.win`
упаковывает его в exe вида `4VM-N.exe` + копия `fork.exe` — **адреса
`LoadLibrary`/`GetProcAddress` патчатся в заголовке PE** (самопальный
PE-патчинг, без загрузчика импорта); генерируется `names.xrf`
(`util/xref.f`). Далее `save.win` «передаёт управление собранной системе»,
которая выполняет `kernel/done.f` (инициализация словарей собранной системы
и кодофайл `LIMIT`) и сохраняет себя как PE-файл.

`target/spf.err` — таблица кодов Win32-исключений для сообщений об ошибках.
`target/util/` — консольный spf.exe-хост, `add/` (msg, savebin, ifnot, stack),
`ext/` (tools, spf-asm), `spf_date.f`, `versions.f`, `xref.f`, `NIX/` —
утилиты самого ЦК.

---

## 3. Ядро (kernel/)

### Тип ядра и регистры (STC)

Определяется в `kernel/vm/STC/registers`:
- **EAX = tos** (вершина стека данных),
- **EBP = top** (указатель стека данных),
- **ESP = rtop** (стек возвратов; играет роль IP — адрес возврата
  используется примитивами вроде `(LIT)`, `(CREATE)` для чтения
  inline-данных из кода),
- **EDI = tls** (область USER-переменных потока),
- **ESI = ltop** (локальный стек).

EBX/EDX/ECX — временные. Код-слова — нативный x86, связь `CALL rel32`/`RET`
(`compiler/STC/compile.f`: `COMPILE, = 0xE8`; `LIT, = CALL (LIT)` +
inline-ячейка). Ветвления — примитивами `BRANCH/?BRANCH/*BRANCH/-BRANCH/
N?BRANCH` со смещениями (`vm/STC/BASE/defkern.f`): `pop EBX; add EBX,[EBX];
jmp EBX` — смещение относительно адреса ячейки смещения. Ассемблер —
псевдоасм с макросами регистров, `CODE...END-CODE`.

Классического **IP-регистра нет** — ESP выполняет его роль.

### Виртуальная машина

`vm/_vm.f` подключает `vm/BASE/{defkern,stacks,logic,arithmetic,dcda,
transform,memory,string,mutex}.f`. Псевдо-инструкции данных —
в `vm/STC/BASE/dtc.f`: `(CREATE) (CONST) (value) (store)` читают данные из
кода за собой. Мьютексы — spinlock через `XCHG` (`vm/STC/BASE/mutex.f`),
используются vtable словарей. Слова с флагом `unfeasible` нельзя исполнять
в интерпретации (`compiler/translate.f: ?EXECUTABLE`).

### Структура kernel/

- `fork.f` — мастер-сценарий (порядок подключения),
- `done.f` — инициализация словарей собранной системы и кодофайл (LIMIT),
- `make.f` — драйвер сборки,
- `sort.f` — утилита переноса слов между словарями,
- `2voc.f` — методы-слова `<: ... ;>` и перенос `>VOCAB`,
- `vm/` — примитивы ФВМ, `compiler/` — ОС-независимые определяющие слова
  и транслятор, `vocbase/` — движок словарей, `vocabs/` — конкретные
  словари, `os/win` — консоль, файлы, импорт DLL, исключения ОС.

### Модель словарей — объектно-подобная, плагинная

Формат статьи (`vocbase/header.wrd`): **lfa = link + vocid + thread + code**;
флаги 8 бит (`&IMM &VOC &SMG` — «недоступно для find», `&ALS` — nickname и
др.); имя — счётчик переменной длины (`strcnt#=3`). Словарь = запись
**WORDLIST** (`header.voc`) со ссылками на методы: `off_quest` (поиск),
mount/umount, linkvoc + **vtable** (разделяемая словарями одного типа:
allot/header/conclude, мьютекс доступа). `WORDLIST` наследует vtable
родителя (`wordlist.f`).

Поиск — `SFIND/SFINDLFA` (`search.f`) идёт по стеку контекста и вызывает
`off_quest PERFORM` каждого словаря — **поиск плагинный**. Хеширование:
32 треда, `HASH MOD` (`vocabs/static.f: FindThread`). Динамические словари
HEAP — каждый со своим Windows Heap (`vocabs/heap.f`), статические — в
кодофайле (`vocabs/static.f`). Контекст: `ROOT NUMBERS FORTH` (+HEAP);
словарь **NUMBERS сам распознаёт числа** (`vocabs/numbers.f`) — не жёсткий
NUMBER, есть HIDDEN. `VOC-LIST` — цепочка всех словарей.

### Исключения

`compiler/catch.f`: классический `HANDLER` в USER-области; `CATCH`
сохраняет SP/LP/RP, `THROW` восстанавливает. Расширения: `ON-ERROR/
EXIT-ERROR` (вложенные, `on-error.f`), `?PAIRS"`. `compiler/catch.f` —
образец для переноса в собственные системы.

### Числа и синтаксис

Числа (`vocabs/numbers.f`): префикс `0x`, признак двойной длины — суффикс
`:`, предупреждения через `WARNING`. Синтаксические расширения: `IFNOT *IF
-IF ;THEN`, `SWITCH: ... ;SWITCH` (таблица переходов, `(switch)` в
defkern.f), `*WHILE`, `<: ;>` (методы), `tc: ;tc`, условная трансляция
`img{ } trg{ } windows{ } [IF]`, сообщения `ERROR" NOTICE" STRING"`.

### 10 самых интересных особенностей ядра

1. Только STC реально собирается; ITC/DTC — пустые заготовки.
2. Регистровая модель без классического IP: ESP = стек возвратов = указатель
   инструкции.
3. USER-переменные в TLS (EDI), локальный стек (ESI) — трёхстековая модель
   (данные/возвраты/локальный).
4. Словари — объекты с vtable и наследованием; поиск и распознавание чисел —
   плагины-методы словаря.
5. Числа распознаёт отдельный словарь NUMBERS в контексте.
6. Флаг `&SMG` — аналог HEADERLESS («недоступно для find») без вырезания
   заголовка; ALIAS-слова (`&ALS`).
7. Ассемблерный псевдокод через MACRO-регистры; кодофайл с
   `ALIGN-BYTES = 1` для контроля размера ядра.
8. Импорт WinAPI — самопальный PE-патчинг (LoadLibrary/GetProcAddress
   фиксируются в заголовке при сохранении, `save.win`).
9. Спинлок-мьютексы на XCHG защищают vtable — задел под многопоточность.
10. Строки со счётчиком переменной длины (1/2/4 байта, UTF-8-ready:
    `chars.f` — абстракция символьного потока; консоль — ANSI→OEM,
    CP1251↔CP866).

### Отличия от «канонического» Forth

Вместо связного списка слов — хеш-треды + цепочка LAST; вместо FIND по CFA —
SFIND по LFA с флагом imm (−1/1); NOTFOUND-хук вместо жёсткой ошибки;
`IFNOT/*IF/-IF/SWITCH:` вместо чистого ANS; трёхстековая модель; USER в TLS;
сборка через мета-компиляцию (ЦК поверх старого spf.exe), а не кросс-ассемблер.

---

## 4. Стандартная библиотека (lib/)

Все файлы в CP866, расширение `.fts`, в каждом подкаталоге файл `about` с
описанием. Сборка подключается через пути-зависимости строкой вида
` vocs/ unit.fts` (вместо REQUIRE).

### Карта подкаталогов

- **algorithm** — бинарный поиск (bsearch), CRC Dallas (crcdow)
- **branch** — варианты управления потоком: case, switch, for-next,
  dssp-подобные aif, троичная логика (triple), постскрипт-подобные
  конструкции (ps, round), mdoes (множественный DOES>)
- **compat** — совместимость с ANS/другими системами; файл about
  отговаривает её использовать («желательно вообще не использовать!!!»)
- **compiler/labels** — метки для пишущих компиляторы
- **exceptions** — пары/исключения (см. ниже)
- **hardware, linux** — железо; linux почти пуст
- **list** — списки: sList/dList (одно-/двусвязные), bTree, hList (хэш)
- **math, memory, string, stack, synch, translation, util, vocs, windows,
  debug** — см. ниже

### Ключевые механизмы

**exceptions/** — вместо голых кодов ошибок используются *сообщения с
уникальным кодом*: `NOTICE" текст"` компилирует код сообщения, `?PAIRS"
текст"` проверяет парность и кидает THROW при несовпадении (pairs.fts).
`DEMAND ... REJECT` (demand.fts) — фортовый аналог try/finally через
`R@ CELL + CATCH`.

**string/** — строки вида `asc #` (адрес+длина), asciiz через `S",`,
`SCONST`, `S?"` (компиляция сравнения), парсеры (parser, c-parser, xWord),
**utf8.fts и utf16.fts** — полноценная работа с Unicode: `CHAR# CHAR+
CHAR@ CHAR!` (таблицы длин через `B,` и `;CREATE`). windows/ansi-oem.fts —
ANSI↔OEM перекодировка.

**memory/** — типизированные массивы: `ARRAY`, `BARRAY` (битовый), `HARR`
(саморасширяющиеся, память в TLS-потоке), карманы pocket/gocket; структуры
через `0 struct ... /struct` с полями `off_*`; locals.fts — локальные
переменные.

**windows/** — WinAPI-обвязка: `__WIN:` создаёт запись импорта (winrec:
winproc/libname/funname), `ALSO IMPORT KERNEL32.DLL`, import.fts собирается
и в ядро, и в систему (`?DEFINED img{ ... trg{ ... }` — ветвление по этапу
сборки). Есть heap.fts (heap потока: BLOCK/RELEASE/CUT/EXTEND), dll.fts,
clipboard, messagebox, mtask, save.

**vocs/** — самое необычное: **Units** (unit.fts) — вложенные
словари-контейнеры: `Unit: name ... EndUnit`, методы `F: ... ;F`, стек USER
`chain`, `Sub` для логической вложенности. Плюс ENUM, struct со спрятанными
полями, dllvoc (DLL как словари), shadow/heir — управление контекстом.

**translation/** — управление потоком трансляции: qif.fts даёт
`[IF] [IFNOT] [ELSE] [THEN]`, c-style.fts — многострочные `/**/`-комментарии,
evaluate, numbers.

**synch/** — mutex, pmutex, watchdog. **stack/** — порождение
неименованных/кольцевых стеков, hstack (строки в хипе), marks
(постскрипт-маркеры). **util/** — see (декомпилятор), timer, test.fts,
words.

### Стиль кода SPF-Fork (в основном автор ~mOleg)

- Шапка файла: дата, `Copyright [C] ..., ~mOleg`, описание; тело обёрнуто в
  `ALSO HIDDEN DEFINITIONS ... PREVIOUS RECENT`.
- Стековые эффекты — со стрелкой `-->`: `: CHAR# ( 'char --> # )`.
- Имена: префикс `D` для двойных вариантов (`DDUP DDROP DR> D>R`), `?` для
  предикатов/проверок (`?PAIRS" ?DEFINED ?LibName`), звёздочка = инверсия
  флага (`*IF`, `*WHILE`, `IFNOT`), суффикс `#` для счётчиков.
- Нестандартный синтаксис: `?DEFINED name \EOF ...` — условное подключение
  до конца файла; секции `img{ trg{ test{ ... }test`; `B, A, LIT, SLIT,
  EXIT,` — компиляция примитивов внутри `: ... ;`; `;CREATE` (конец CREATE +
  DOES>), `ERROR"`, `NEXT-WORD`.
- Везде тесты рядом с кодом: `?DEFINED test{ ... test{ ... }test`.

---

## 5. Примеры (samples/)

- `colorer.fts` — раскраска исходников в HTML для форума
- `hash.fts` — хеш-списки (256 тредов, `list/hlist.fts`)
- `queens.fts` — 8 ферзей (Al.Chepyzhenko)
- `lexfreq.fts` — подсчёт частот лексем файла через словарь
- также `clear/clear2.fts`, `equalize.fts`, `m2s/s2m.fts`, `pp2.fts`,
  `replyes.fts`, `rndtest.fts`, `tab.fts`
- `win/` — WinAPI: окна, callback'и, `ctrl+c`, TEB, сообщения
- `test/` — тесты системы: `basetest.fts`, `testcase.fts`, `catch.fts`,
  locals, typedef, valtest, `libraries.fts` (проверка библиотек через
  `noinit.exe` — `ltest.bat`)
- `itest/` — тесты запуска перетаскиванием файла на exe (пути с пробелами)
- `sketches/` — наброски: структуры, typedef, `qcase`,
  `vocmark/voccolon` (слова по файлам в словари), `see.fts` и пр.

---

## 6. Сводка отличий и того, что стоит заимствовать

Заимствовано в forthD (наш проект):
- регистровая модель EAX=TOS / ESP=роль IP / чтение inline-данных по адресу
  возврата — совпадает по духу;
- **CATCH/THROW с сохранением SP/LP/RP** (`kernel/compiler/catch.f`) —
  перенесено как «настоящий CATCH/THROW» (фрейм на ESP, цепочка HANDLER);
- словарь **NUMBERS как плагин** — идея NOTFOUND-хука;
- стиль `?PAIRS"`, `ON-ERROR/EXIT-ERROR`, `ABORT` — частично перенесено;
- модель «слова-калькулятор в D-хосте», общая таблица адресов —
  наш мост D↔Форт похож на EXECUTEFROMD/COMMONADR SPF.

Не переносимо напрямую (другая архитектура): объектные словари с vtable,
метакомпиляция (у нас embedded-мост forthdll.d вместо неё), TLS/спинлоки,
UTF-слои.
