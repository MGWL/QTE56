# qte — CLI-утилита для анализа QTE56

> ↑ Навигация: [AGENTS.md](../../AGENTS.md)

Единая утилита с подкомандами для статического анализа кодовой базы QTE56:
индексы pFunQt, реестр функций, gen_*.d модули, кросс-проверки.

Цель: дать AI-агенту и разработчику быстрый структурированный доступ к метаданным
проекта вместо grep-комбинаций по 4 разным файлам.

## Сборка

```cmd
tools\qte\build.bat              :: обычная сборка
tools\qte\build.bat --unittest   :: с прогоном тестов
tools\qte\build.bat --release    :: -O -release -inline
```

```bash
tools/qte/build.sh
tools/qte/build.sh --unittest
tools/qte/build.sh --release
```

Зависит только от DMD/Phobos. Никакой Qt, никаких сторонних библиотек.

## Подкоманды

### `qte index ...` — анализ pFunQt

```
qte index list                  сводка по модулям
qte index find <substring>      поиск функций по имени
qte index next [from]           следующий свободный индекс
qte index gaps [--min N]        дыры в нумерации
qte index gaps --plan N         дыры >= N по убыванию ширины (под новый класс)
qte index check                 коллизии + name mismatches
qte index module <Name>         все индексы модуля
qte index orphans               расхождения CSV vs gen_*.d
```

### `qte class <Name>` — справочник по Qt-классу

Где определён, какие методы (имя/return/args/static/visibility),
сколько индексов pFunQt связано с модулем класса, где используется
(test/, snip/).

```
qte class QPushButton           полный отчёт
qte class QSqlQuery --no-usages только определение
qte class QTextCodec --json     машинный вывод
```

### `qte check ...` — кросс-проверки

```
qte check all          все проверки подряд
qte check indexes      коллизии + name mismatches (то же что qte index check)
qte check live         @live перед полем класса (запрещено в QTE56)
qte check builds       .pro покрыты сборкой (bat/sh/py напрямую или через merged .pro)
qte check dlls         DLL из registerModule есть в dll/dll32 и dll/dll64
qte check globals      статистика __gshared (info-уровень)
```

Возвращает exit=0 если ошибок/warning'ов нет, иначе 1.

### `qte signals ...` — справочник Qt-сигналов

Парсит реальные `connect_*` методы во всех `gen_*.d` (а не статичный markdown).
Распознаёт два паттерна: ESlot (`invoke_X`) и direct-cb (через pFunQt).
Для классов без своих сигналов автоматически идёт по цепочке наследования.

```
qte signals                       статистика по invoke-типам и виджетам
qte signals QPushButton           сигналы класса (наследует от QAbstractButton)
qte signals invoke_b              сигналы с (bool)
qte signals valueChanged          виджеты с этим Qt-сигналом
qte signals --used connect_clicked  где используется в test/snip
```

> **Примечание (2026-08-02):** после введения method chaining `connect_*` методы
> в gen_*.d возвращают класс (`QAbstractButton connect_clicked(...)`), а не `void` —
> парсер в `findSignals` (`tools/lib/qte_meta.d`) принимает любой возвращаемый тип.

### `qte trace <index>` — обратная трассировка pFunQt-слота

Полная картина одного индекса: registry / C++ declaration+impl / D-loader / D-callers.
Обнаруживает коллизии (несколько записей в CSV на один индекс).

```
qte trace 19134                qteQSql_qBindBytes — все 4 секции
qte trace 20157 --json         JSON-вывод
qte trace 5055                 qteQPlainTextEdit_textCursor
```

### `qte dll [module]` — таблица модуль → DLL → группа

Актуальный маппинг из `registerModule()` в `d/gen/gen_*.d` (колонка dll
в registry/functions.csv устарела ~на 65% и используется только как fallback).
Merged DLL (6): qte56_widgets, qte56_foundation, qte56_views, qte56_text,
qte56_dialogs, qte56_mainwin — остальные standalone.

```
qte dll                      вся таблица модуль → DLL → merged/standalone
qte dll QComboBox            только этот модуль
qte dll --missing dll32      модули без DLL в dll/dll32
qte dll --missing dll64      модули без DLL в dll/dll64
qte dll --json               машинный вывод
```

### `qte deps <ClassName|path.d>` — замыкание импортов gen_*

Транзитивное замыкание импортов `gen_*` (граф из `^import\s+(gen_\w+)`).
Для класса берётся его gen-модуль, для .d-файла — его импорты.
Вывод: модули в порядке сборки + готовая строка компиляции dmd.

```
qte deps QComboBox                  замыкание для класса
qte deps test/test_qtablewidget.d   замыкание для теста
qte deps QComboBox --json           машинный вывод
```

### `qte scan` — JSON-выгрузка всех классов gen_*.d

Единый источник мета-информации о gen_*.d для внешних потребителей
(tools/qte_guide/scanner.d получает все данные только через `qte scan`;
собственный регэксп-парсер там удалён). Вывод — всегда JSON в stdout:

```
qte scan            {"classes":[{"name","module","dll","parent","live",
                     "indices","deps","signals","signalsDetail",
                     "events","eventsDetail","methods"}, ...]}
```

`signalsDetail`/`eventsDetail` несут params/qtSig для коллбэков;
`signals`/`events` — плоские списки имён.

### Запланированы

- `qte callers <name>` — кто использует функцию (расширение findUsages)
- `qte gen method <Class> <sig>` — генератор boilerplate'а для нового метода

## Глобальные опции

- `-h`, `--help` — справка
- `--json`       — машинный вывод (для агентов)
- `-q`, `--quiet`— минимальный вывод
- `--root PATH`  — путь к корню проекта (по умолч. auto-detect)
- `--version`    — версия

## Примеры

```
# Найти все индексы QTextCodec
qte index module QTextCodec

# Следующий свободный (от 20163)
qte index next 20163

# Проверить коллизии и mismatches с gen_*.d
qte index check

# JSON для парсинга агентом
qte --json index module QSql
```

## Архитектура

```
tools/
├── lib/
│   ├── qte_meta.d       — парсеры CSV + gen_*.d, кросс-валидация
│   └── qte_cli.d        — argparse, JSON-helpers, find project root
└── qte/
    ├── main.d           — диспетчер подкоманд
    ├── cmd_index.d      — `qte index ...`
    ├── cmd_dll.d        — `qte dll ...`
    ├── cmd_deps.d       — `qte deps ...`
    ├── build.bat / .sh  — сборка
    └── qte.exe          — собранная утилита
```

Новая подкоманда = `cmd_xxx.d` + ветка в `main.d`. Общий код переиспользуется
из `tools/lib/`.

## Тестирование

Каждый модуль покрыт unittest-блоками. Запуск:
```
tools\qte\build.bat --unittest
```

`qte_meta.d` тестирует парсеры CSV/gen_*.d на синтетических фикстурах
(временные файлы в `%TEMP%`). `qte_cli.d` тестирует argparse и JSON-escape.
`cmd_index.d` тестирует логику команд на маленьких реестрах.

## Состояние реестра (на 2026-08-02)

`qte check indexes` чистый: коллизий индексов нет, name mismatches нет.
Известный исторический долг (не баг утилиты):
- 11 CSV orphans — записи QPushButton (402–407) и QLabel (803–818) есть
  в реестре и C++, но намеренно не забиндены в gen_*.d (`qte index orphans`).
- Колонка dll в functions.csv устарела (~65% расходится); `qte index list/module`,
  `qte class`, `qte dll` используют актуальный маппинг из registerModule()
  (moduleDllMap в qte_meta.d), CSV — только fallback.

Ранее (на 2026-05-01) утилита находила 9 коллизий индексов — они устранены
при миграции методов в merged DLL.

---

## Навигация

- ↑ [AGENTS.md](../../AGENTS.md) — точка входа
