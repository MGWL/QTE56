# AGENTS.md — Контекст проекта excel_import для ИИ-агента

Полное описание приложения: архитектура, форматы, бизнес-логика, правила разработки.

## 1. Что делает приложение

GUI для обработки данных экзаменов НК (неразрушающий контроль). Основной сценарий:

1. **ОткрытьНаправление** — диалог выбора Excel (`*.xls`, `*.xlsm`), открытие через OLE,
   путь запоминается в `g_directionFile` (из него формируется имя файла результатов).
2. Пользователь копирует диапазон в Excel (Ctrl+C) и вставляет в приложение (Ctrl+V).
3. **Parse** — TAB-текст → MainTable (16 колонок): ФИО раскладывается, валидируются
   дата рождения и возраст (16–80). Из заголовка — даты D1 (кол.5) и D2 (кол.6,
   **D2 — дата экзамена**).
4. **Parse2** — по каждой строке определяются системы сертификации, строится
   ExamTable (12 колонок + 13-я «РезультатБД»): строка = один экзамен одного
   человека в одной системе. Коды экзаменов — из `rules.csv`.
5. **ExcelДокумент** (`Ctrl+D`) — по выбранной строке ExamTable заполняет шаблон
   Excel через OLE. Только для практического экзамена (`КодЭкзамена == ">>>>>"`).
   Файл по системе: `sdank.xlsx` / `iso.xlsx` / `gostr.xlsx`; лист и адреса ячеек —
   по карте `excelmap.csv` (раздел 6).
6. **СохранитьКопию** — копия активного листа → книга `prk_<имя_направления>` рядом
   с направлением; лист переименовывается в `Фамилия_Метод_Уровень` (запрещённые
   символы → `_`, ≤31 символа). Если prk-книга уже открыта — лист добавляется в неё;
   лист-дубликат → предупреждение (`SheetExistsException`), ничего не меняется.
   После успеха ячейка «КодЭкзамена» текущей строки красится в Magenta.
   Работает только после ОткрытьНаправление.
7. **Сохранить (Ctrl+S) / Загрузить (Ctrl+O)** — обе таблицы + D1/D2 в текстовый
   файл UTF-8 (`savefile.d`). Источник истины: MainTable — ячейки, ExamTable —
   `g_examTableData` (массив в памяти).

Нижний тулбар «БД» (PostgreSQL, подключение ленивое):

- **ListGroup** — список групп (`cntrgrpabitr`) в консоль.
- **CheckMan** — проверка людей ExamTable по `cntrman` (ФИО+dtr через
  `to_date(...,'DD.MM.YYYY')`), вердикты в консоль.
- **GroupFill** — наполнение группы. **ПРАВИЛО «ВСЁ ИЛИ НИЧЕГО»**: сначала
  `validateGroupFill` (битые даты, нет преподавателей в examenators.csv) — любая
  ошибка → только HTML-отчёт в браузере, записи НЕТ. При чистой валидации —
  подтверждение и запись ОДНОЙ транзакцией (`executeGroupFill`, db.d): новые люди →
  `cntrman` (id из `cntrman_id_seq`, **nomser = id**, **`uno_man = ''` обязательно** —
  NULL делает запись невидимой в веб-приложении), экзамены → `ekaa2aa`
  (kodek char(5), dateek=D2, **obj=ОбСект** — колонки sektors там нет; popitka=0,
  procent=0, stat='0'; **prp1/prp2/prp3 = НомерSQL (id_ekprep) из examenators.csv**,
  0 = слот не задан). SQL-ошибка → полный rollback. Тестовая группа 396
  (`test_groupfill.d`). Работает только с подтверждённой группой на панели дат.
- **GroupResults** — `ekaa2aa.procent` группы → 13-я колонка «РезультатБД»
  (в save-файл НЕ пишется, перечитывается из БД) + словарь `g_procDict`:
  ключ `Код|Система|Метод` → лучшие проценты С1/С2/ПБ (читается при ExcelДокумент).

Панель дат: **IdГруппы** (spinBox `g_spinGroupExam`) → название группы в
`g_nameGroupExam` или «?????»; рядом D1/D2.

UI: верхний тулбар «Main» (QAction: ОткрытьНаправление, Вставить, Parse, Parse2,
X ввод, X верхТабл, ExcelДокумент, СохранитьКопию, Очистить), меню **Work**
дублирует те же QAction. Меню File/Help стандартные.

## 2. Технологический стек

- **D (dmd), только 32 бита** (`-m32`). GUI: QTE56-биндинги Qt5 (`arch_new/d/`,
  `-version=TreeQt`, `-L/DEFAULTLIB:user32`).
- Excel: OLE Automation через C-шим `ole_helper.dll` (рядом с exe) +
  `arch_new/ole/d/ole_automation.d`, `ole_excel.d`.
- Исходники — в **`source\`** (в корне: данные, документы, makefile, exe).
- Сборка: `make.exe` (DMC make, в каталоге проекта) + `makefile`.

## 3. Сборка и тесты

```
make.exe          — excel_import.exe
make.exe test     — unittest'ы модулей (run_tests.exe), без Qt
make.exe schema   — структура БД в консоль (source\test_schema.d)
make.exe clean    — *.obj и тестовые exe
```

- Unittest'ы — блоки `unittest {}` в конце модулей. При изменении логики
  **обязательно** обновить unittest и прогнать `make.exe test`.
- GUI тестами не покрывается — проверяет пользователь.

## 4. Модули (все в `source\`)

Все, кроме `excel_import.d`, — без Qt, тестируются консольно. Зависимости — DAG,
модули логики НЕ импортируют `excel_import`.

| Модуль | Ответственность |
|--------|-----------------|
| `excel_import.d` | UI, `fillTable`/`fillExamTable`, тонкие колбэки, `main()` |
| `parsing.d` | TAB-парсинг: `parseTabData`, `splitFIO`, даты, возраст |
| `rules.d` | `rules.csv` → `g_rules`, `g_examCodes` |
| `exam_logic.d` | Бизнес-логика: `determineSystems()`, `processRow()`, колонки `COL_M_*`/`COL_E_*`; группа БД: `analyzeGroupFill()`, `validateGroupFill()`, `applyExamResults()`, `buildProcDict()` + `g_procDict` |
| `examenators.d` | `examenators.csv`: `findExaminators` (слоты 1..3 на дату), `g_examenators` |
| `excel_export.d` | `openTemplate(system)`, `writeExamDocument(...)`; лист — `pickSheet` по карте, фоллбэк `defaultCells()` |
| `excelmap.d` | `excelmap.csv` → `g_excelmap`, `sheetKeysFor(system, level, method)` |
| `savefile.d` | `serializeTables()`, `parseSaveFile()` |
| `report.d` | HTML-отчёт GroupFill (ошибки красным, добавляемое зелёным, существующее серым) |
| `db.d` | QPSQL: `dbEnsureOpen()` (лениво), `findGroupName`, `findPersonId`, `insertPerson/insertExam`, `executeGroupFill` |
| `app_log.d` | Лог `excel_import.log` (переписывается при каждом запуске) |

Связи БД: `ekaa2aa.kodek` = КодЭкзамена из rules.csv; `ekaa2aa.idman` = `cntrman.id`;
`idgrp` → `cntrgrpabitr.id`; результат = `procent`; попыток несколько → последняя
(`DISTINCT ON (idman,kodek) ... dateek DESC`). Тестовая группа веток A/B: **id=523**.

Внешние зависимости (НЕ трогать): `arch_new/ole/`, `arch_new/d/` (QTE56),
`LIBPQ.dll` (32-бит, обязан лежать рядом с exe).

**Куда добавлять код:** логика ExamTable → `exam_logic.d` (+unittest); ячейки Excel
→ `excel_export.d`; новый формат данных → новый модуль по образцу `examenators.d`;
кнопки/действия → колбэк в `excel_import.d`, логика в модуль.

## 5. Форматы данных

**Вставка из Excel:** строка 1 — заголовок (D1/D2 в колонках 5/6, `DD.MM.YYYY`),
строка 2 — имена полей, строки 3+ — 11 TAB-полей: Код, ФИО, ГодРождения,
Организация, Уровень, Метод, Сектор, СписокЭкзаменов, Объекты, СертТип,
КарточкаНомер. Разорванные строки склеиваются с пробелом. ФИО: 3 слова → Ф/И/О,
2 → без отчества, 4+ → отчество составное.

**rules.csv** (UTF-8, TAB): `№ | Тип | Метод | Уровень | Общий | Спец | ПБ | ТКарта | 1образ | 2образ | 3образ | Система`.
Ключи: `g_rules` = `Метод_Уровень_Тип`; `g_examCodes` = `Система_Метод_Уровень_Тип_Экзамен`
(С1=Общий, С2=Спец, ПБ=ПБ, С3=">>>>>").

**examenators.csv** (UTF-8, `|`): `D1 | D2 | Система | Метод | №слота (1..3) | НомерSQL | ФИО`.
Период `D1 <= дата < D2`; НомерSQL = id_ekprep → `ekaa2aa.prp1/2/3`;
при пересечении периодов побеждает более поздняя D1.

**Save-файл** (UTF-8, TAB): сигнатура `# excel_import save v1`, D1/D2,
`[ParseTable]` (16 кол.), `[ExamTable]` (12 кол., 13-я не пишется).
Поля: `\n`/`\r` → пробел + trim.

**PostgreSQL** (db.d): тестовый стенд `192.168.8.67:5432` (продакшен закомментирован),
база `mgwdb`, QPSQL. **LIBPQ.dll — libpq 9.3 без SSL**: не поддерживает scram-sha-256
(пароль только md5, иначе «(null db)»). **Пароль `mgw_admin` на стенде свой
(`gjxnfathrf`)** — им же пользуется веб-приложение, менять только на то же значение.
Плагин `qsqlpsql.dll` — через `QSqlDatabase.addPluginPath()` (env + запасные пути).

## 6. Бизнес-логика и Excel

Определение систем: `Объекты` не пусто/не `"-"` → **СДАНК-02-2020**; иначе `Сектор`
→ **ISO-9712** (с подстрокой «ГОСТ» → **ГОСТ-Р-ИСО**); систем 0–2.
Колонка ОбСект: для СДАНК — Объекты, иначе Сектор.

**OLE — критично:** `Range/Item/Cells/Rows/Columns` — свойства с параметрами,
вызывать ТОЛЬКО через `getObject(...)` (иначе `0x80020003`); методы (`Open`,
`SaveAs`, `Close`...) — через `callObject`/`callVoid`. `ExcelApp.attachOrCreate()`
— к запущенному Excel. Коллекции с 1. Даты — VT_DATE (`dateToOle`/`oleToDate`).
OLE только из главного потока (STA). API — `arch_new/ole/OLE_GUIDE.md`.

**excelmap.csv** (UTF-8, TAB): строка на лист, имя + адреса A1 по кодовым полям;
строка `*` — умолчание. Лист СДАНК по `sheetKeysFor`: `sdank-u<L>-<Метод>` или
`sdank-u<L>` (ТК/ВД/РК — специфичные); ISO/ГОСТ — activeSheet.
Кодовые поля: `KodMan, FamMan, NamMan, OtcMan, FioMan, DtrMan, SysMan, MetMan,
UrMan, TypSertMan, ObjMan, TypEkzMan, KodEkz`, `ProcC1/ProcC2/ProcPB` (g_procDict),
`IdGroup, NameGroup, D1Group, D2Group`, `Экз1, Экз2` (преподаватели; нет — `???????`).
Пустые значения ячейку не затирают.

## 7. Соглашения по коду

- Комментарии — **на русском**; исходники и csv — **UTF-8**.
- Пути к данным — от `thisExePath()`, без абсолютных путей.
- Глобальные переменные — `__gshared`.
- QTE56: `new QWidget(cast(void*)null)`; `QMenuBar.wrap(...)`; после добавления
  в родителя — `.disown()`; колбэки `extern(C) void onX(void* dt, int n, int checked)`;
  слоты через `makeSlot` (массив `g_slots[64]` — следить за переполнением);
  `QTableWidgetItem.wrap(g_table.item(r, c))` с проверкой null.
- Колбэки — тонкие: UI → модуль → UI. Вся логика — в модулях.

## 8. Известные шероховатости

- Подсветка ошибок MainTable: QLabel перекрывается item'ом; текст ошибки — в tooltip.
- Данные дублируются: MainTable — источник истины ячейки, ExamTable — `g_examTableData`.
- Подсветка Magenta «лист сохранён» живёт до следующего `fillExamTable()`.
- Файлы в корне (`*.docx`, `152 (ВИК).xls`, `rules.xlsx`, `zd.txt`, `add_colors.md`)
  — справочные материалы, не код.
