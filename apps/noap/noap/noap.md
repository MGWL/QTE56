# NOAP — база данных реестра специалистов неразрушающего контроля

> Документ для AI-моделей и разработчиков: структура, взаимосвязи и алгоритмы
> добавления записей в `DB/NOAP.mdb` (приложение `NOAP.exe`).
> Составлен 2026-09 по результатам анализа схемы (ODBC/DAO), данных и строк NOAP.exe.
> Алгоритмы вставки проверены тестовой записью на копии БД (см. §11).

## 1. Приложение и доступ к базе

- **NOAP.exe** — Delphi 10.3 Rio (Win32), работа с БД через ADO (`TADOConnection`/`TADOQuery`).
- Строка подключения (из exe, дословно):
  `Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DB\NOAP.mdb;Persist Security Info=False`
- База — классический Jet MDB (Access 2000-2003 формат). **Только 32-битный доступ**:
  на машине доступен ODBC-драйвер `Microsoft Access Driver (*.mdb)` (32-bit) и DAO 3.6 (COM `DAO.DBEngine.36`, 32-bit).
  Провайдер `Microsoft.ACE.OLEDB.12.0` зарегистрирован, но сломан (нет InprocServer32) — не использовать.
- Рабочий способ чтения/записи: 32-битный PowerShell
  (`C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe`) + `System.Data.Odbc`,
  connection string: `Driver={Microsoft Access Driver (*.mdb)};Dbq=<путь>;`
- Кодировка текстовых данных — Unicode внутри MDB; через ODBC кириллица читается корректно.
  Вывод консоли PowerShell — CP866 (перекодировать `iconv -f CP866 -t UTF-8`).
- Встроенные скрипты приложения (`scripts/*.script`) — zlib-сжатые PascalScript-фрагменты
  (TADOQuery через `NConnect`); расшифровка — `scripts/*.decoded.txt`.

## 2. Назначение базы

Реестр физлиц — специалистов неразрушающего контроля (НК), прошедших аттестацию
в НОАП (независимый орган по аттестации персонала). Конкретно эта копия — база
НОАП-0018 «Контроль и диагностика» (Settings: `NOAPNum=НОАП-0018`, `NOAPRegNum=18`,
`NOAPPercent=10`).

Три главные сущности:

| Таблица | Сущность | PK | Записей |
|---|---|---|---|
| `ANKETA` | Люди (анкеты специалистов) | `PERSID` (COUNTER) | 10894 |
| `ORGAN` | Организации-работодатели и заявители | `ORGID` (COUNTER) | 1135 |
| `ATTEST` | Аттестации / удостоверения | `ATTID` (COUNTER) | 27501 |

## 3. Схема данных

### 3.1. Ядро

**ANKETA** — анкета специалиста. Все поля кроме PK nullable:
`FAM/NAM/OT` — ФИО (именительный); `FAMR/NAMR/OTR` — родительный падеж;
`FAMD/NAMD/OTD` — дательный падеж (падежи хранятся отдельными полями, в текущих
данных почти всегда пустые строки); `DTR` — дата рождения; `SEX` — 'М'/'Ж';
`OBRID` → EDUCATION.ID (образование); `UCHSTEP/UCHZVAN` — учёная степень/звание
(текст); `PASSER/PASNO/PASVYD/PASDT` — паспорт; `INN`; `ORG_RAB` → ORGAN.ORGID
(место работы); `APPOINTMENT` → JOB_POSITION.ID (должность); `TLF/EMAIL/ADDR`;
`DOKUM` (вид документа), `GRAGD` (гражданство).
Индексы: PK `PERSID`; неуникальные по `OBRID`, `APPOINTMENT`, `ORG_RAB`.

**ORGAN** — организация: `ORGNAME` (полное), `SNAME` (краткое), `IND/ADRES`
(юр. адрес), `INDP/ADRP` (почтовый), `PHONE/FAX/EMAIL`, `INN/KPP/OKPO/OKONH/OGRN`,
`Staff` (численность), `IsNOAP` (BIT — «это НОАП»; в данных True только у 1 записи),
`GR_CODE/ORG_GR/Comment`. PK `ORGID`.

**ATTEST** — аттестация (одна запись = одно решение/документ):
- `PERSID` → ANKETA.PERSID (кто аттестован) — обязательно по факту (0 сирот).
- `AttTyp` → ATTTYP.ID — тип аттестации; в этой базе всегда 5 (СНК, «Специалисты НК»).
- `Result` → ATTRES.ID: 1=НЕЯВКА, 2=СДАЛ/Аттестован, 3=ЗАЯВ (заявка на тестирование), 4=НЕ СДАЛ.
- `AttVid` → ATTVID.ID — вид: 1=ПЕРВ (первичная), 2=ПОВТ (повторная), 3=РАСШ (расширение),
  4=АННУ (отмена), 5=СРОК (приостановка), 6=ПРОД (продление).
- `SvNo` — номер удостоверения (строка, формат см. §5).
- `SvDateVyd` / `SvDateFin` — дата выдачи / окончания действия.
- `LEV` → ATTLEVEL.ID — присвоенный уровень; `LEVZ` → ATTLEVEL.ID — заявленный уровень.
  Значения ATTLEVEL: 1=Э (Эксперт), 2=ВК (Эксперт высшей квалификации) — APP='NOA';
  3=I, 4=II, 5=III уровень — APP='NOAP'. В данных в основном 4 (II уровень, 25975 записей).
- `Prot_ID` → PROTOCOL.PROT_ID; `ProtNum`/`ProtDate` — денормализованный дубль
  номера/даты протокола (в новых записях `ProtNum='000'`, `ProtDate`=NULL или нулевая дата).
- `OrgZajav` → ORGAN.ORGID — организация-заявитель.
- `NOA` — INTEGER, в данных почти всегда 2 (значение по умолчанию для этого НОАП;
  единичные 1 и 80). `Opers` — в текущих данных всегда NULL (использовался при импорте).
- `DataZajav` — дата заявки (может быть позже даты выдачи — пакетный ввод).
- `SUMMA` (CURRENCY) — стоимость работ; `WithVAT` (BIT) — если True, SUMMA **включает НДС**
  (чистая = `SUMMA/(1+VAT.Value/100)`, ставка из таблицы VAT по дате выдачи).
- `hologram` (VARCHAR 10) — номер голограммы; '0' = фиктивный (миграция
  `cSetFakeData.script` заполнила NULL → '0'), уникальность контролируется приложением.

**Связи M:N от ATTEST** (у всех unique-индекс `(ATT_ID, <справочник_ID>)`, PK нет):
- `ATT_METHODK(ATT_ID, METHODK_ID, COMMENT)` → Method_K.ID — методы НК аттестации
  (27895 строк; обычно 1 метод на аттестацию, редко 2–6). COMMENT почти всегда пуст/пробелы.
- `ATT_OBJECTK(ATT_ID, OBJECTK_ID)` → Objects_K.ID — объекты контроля (195272 строки).
- Остальные таблицы связей в этой базе **пусты** (схема общая для разных типов органов):
  `ATT_AKKR` (→AKKR_CODE, с флагом RES_RES), `ATT_KVALIF`, `ATT_NADZOR` (→OTR_SPEC/Nadzor),
  `ATT_OBLATTPB` (→OBLATT_PB), `ATT_ORGST` (→ORG_S_TYP), `ATT_RULES_PB` (→PB_RULES).

**PROTOCOL** — протокол заседания комиссии (10677): `PROT_ID` PK, `ProtNum`, `ProtDate`,
`ProtNumEx/ProtDateEx` (протокол экспертный), `ProtTyp`, `PROT_COMM` (комментарий),
`KOMATTID`/`KOMEXID` → Commission.KomID (комиссии аттестационная/экзаменационная).
В новых данных ProtDate часто = `1899-12-30` (нулевая дата Access, используется как «пусто»).
**SOSTAVKOM(PROTID, PERSID, DOLGN, STATUS→COM_STATUS.ID, ORD)** — состав комиссии по протоколу.

### 3.2. Справочники

| Таблица | Содержимое | Особенности |
|---|---|---|
| `ATTLEVEL` | Уровни квалификации (5) | поле APP: 'NOA'/'NOAP' — для каких типов органов |
| `ATTRES` | Результаты (4) | |
| `ATTTYP` | Типы аттестаций (14) | эта база использует только ID=5 |
| `ATTVID` | Виды (6) | ID=6 ПРОД добавлен самим приложением при инициализации |
| `EDUCATION` | Образование (6) | |
| `JOB_POSITION` | Должности (3589) | свободно пополняется из формы |
| `Method_K` | Методы НК (46) | иерархия по PARENT; ID вручную назначаемые (4000=до 2021, 5000=с янв.2021; коды: 5101 РК, 5200 УК, 5400 МК, 5500 ВК, 5601 ПВК, 6100 ВИК, 6200 НДС, 6300 УФ НК...) |
| `Objects_K` | Объекты контроля (222) | иерархия по PARENT; 10000=«до янв 2021», 20000=«с янв. 2021», 30000=«с фев. 2021»; CODE = номер пункта ('1', '1.1', ...) |
| `Commission` | Комиссии (2) | `ABBR`, `CODE` — коды; данные выродились ('1','1') |
| `COM_STATUS` | Роли в комиссии (5) | ПРЕДС/ЗАМЕСТИТЕЛЬ/ЧЛЕН/СОПРЕДСЕДАТЕЛЬ/СЕКРЕТАРЬ |
| `VAT` | Ставки НДС по периодам (4) | dateFrom..dateTo, Value (20/18/20/22) |
| `Settings` | Параметры (Param/Value) | NOAPNum, NOAPRegNum, NOAPPercent, BaseVersion |
| `Nadzor`, `OTR_SPEC`, `OBLATT`, `OBLATT_PB`, `PB_RULES`, `SKILL_PB`, `AKKR_CODE`, `ORG_S_TYP` | Справочники для других типов органов (ПБ, аккредитация, надзор) | в этой базе справочники заполнены, но связи ATT_* пусты — не используются |

### 3.3. Служебные/исторические

- `*_OLD` (ANKETA_OLD, ATTEST_OLD, ORGAN_OLD, ATT_METHODK_OLD, PROTOCOL_OLD) — архивы
  миграций; пусты, кроме ORGAN_OLD (44 записи). Новые данные туда не пишутся.
- `Ошибки вставки` — технологическая таблица ошибок импорта (1 запись).
- Сохранённые запросы (views): `PERSONA`, `PERSONA0`, `Person_report`, `ex*` (выгрузки
  с CODE вместо ID для обмена между базами), `Проверка_*` (контроль качества данных),
  перекрёстные отчёты по методам. Полный SQL — в `scripts/_dao_dump.txt`.

### 3.4. Декларированные связи (DAO Relations)

Формально объявлено мало и почти всё **без enforce** (attr=0 или 2=DontEnforce):

```
EDUCATION.ID       -> ANKETA.OBRID
JOB_POSITION.ID    -> ANKETA.APPOINTMENT
ORGAN.ORGID        -> ANKETA.ORG_RAB
OTR_SPEC.ID        -> ATT_NADZOR.NADZOR_ID
PROTOCOL_OLD       -> ATTEST_OLD.Prot_ID, SOSTAVKOM.PROTID   (исторические)
```

Реальная связность поддерживается приложением, а не БД. Фактические FK
(по индексам `Rel_*` на ATTEST и данным):

```
ATTEST.PERSID  -> ANKETA.PERSID      (сирот: 0)
ATTEST.OrgZajav -> ORGAN.ORGID       (сирот: 2)
ATTEST.Prot_ID -> PROTOCOL.PROT_ID
ATTEST.AttTyp -> ATTTYP.ID,  Result -> ATTRES.ID,  AttVid -> ATTVID.ID
ATTEST.LEV / LEVZ -> ATTLEVEL.ID
ANKETA.ORG_RAB -> ORGAN.ORGID        (сирот: 0)
ATT_METHODK.ATT_ID -> ATTEST.ATTID   (сирот: 78 — исторический мусор)
ATT_METHODK.METHODK_ID -> Method_K.ID (битых: 42 — методы удалены из справочника)
ATT_OBJECTK.ATT_ID -> ATTEST.ATTID   (сирот: 1438)
ATT_OBJECTK.OBJECTK_ID -> Objects_K.ID (битых: 13271 — старые объекты удалены
                                        при реформе справочника 2021 г.)
```

## 4. Диаграмма связей (упрощённо)

```
ORGAN ──< ANKETA ──< ATTEST >── ATTLEVEL (LEV, LEVZ)
  │                    │  ├──> ATTTYP (AttTyp), ATTRES (Result), ATTVID (AttVid)
  │                    │  ├──> PROTOCOL (Prot_ID) ──< SOSTAVKOM >── ANKETA (состав комиссии)
  └──── OrgZajav ──────┘  ├──< ATT_METHODK >── Method_K  (методы НК, M:N)
                          ├──< ATT_OBJECTK >── Objects_K (объекты, M:N)
                          └──< ATT_AKKR / ATT_KVALIF / ATT_NADZOR /
                               ATT_OBLATTPB / ATT_ORGST / ATT_RULES_PB (M:N, в этой базе пустые)
```

## 5. Номер удостоверения (ATTEST.SvNo)

- **SvNo целиком вводится оператором** при добавлении свидетельства (поле `edtCertif`
  на TAttestForm); автогенерации нет. Все части номера — входные параметры,
  в базе никогда не изменяются (приложение их не пересчитывает).
- Формат (новый): `0018-YY-XXXXX`, где
  - `0018` — код центра аттестации (Settings.NOAPNum = 'НОАП-0018', NOAPRegNum=18);
  - `YY` — номер филиала нашей организации; справочника филиалов в базе НЕТ,
    вводится оператором; в данных встречаются значения 00–99;
  - `XXXXX` — номер свидетельства, **назначается специальной комиссией** при первичной
    аттестации; для нас — входной неизменяемый параметр (в данных 10514–22560).
- Старые форматы (2009–2011): `0018-5573`, `18-00-4630`, `18-05-0343` (длины 9–10).
- **Номер НЕ уникален**: при повторной аттестации/продлении (AttVid=2 ПОВТ, 6 ПРОД)
  человек сохраняет прежний номер — один SvNo встречается до 18 раз
  (9163 уникальных из 27501). Связка «человек ↔ XXXXX» постоянна: у одного PERSID
  все записи ATTEST имеют один и тот же хвост XXXXX.
- При сохранении приложение проверяет `SELECT ATTID FROM ATTEST WHERE SvNo=:SvNo`.
- Бизнес-правила контроля номера при вводе — см. §9.

## 6. Алгоритм добавления нового человека

Проверен на копии БД (§11). Дословный SQL из формы персоны (qPersonAdd):

```sql
INSERT INTO ANKETA
  (FAM, NAM, OT, FAMR, NAMR, OTR, FAMD, NAMD, OTD, DTR, SEX, ADDR, TLF,
   PASSER, PASNO, PASVYD, PASDT, EMAIL, INN, APPOINTMENT, ORG_RAB)
VALUES (...);
SELECT @@IDENTITY;   -- новый PERSID
```

Правила:
1. `PERSID` — автоинкремент, не задавать. Новый id читать через `SELECT @@IDENTITY`
   на том же соединении (Jet 4.0 поддерживает).
2. Если организации-работодателя нет — сначала вставить в ORGAN (§7) и взять ORGID.
3. `ORG_RAB` — ORGID организации (nullable, но в данных заполнен у всех).
4. `APPOINTMENT` — ID из JOB_POSITION; если должности нет, приложение добавляет
   её в справочник (`insert into JOB_POSITION (NAME) values (...)`).
5. Падежные формы (FAMR..., FAMD...) можно оставить пустыми строками —
   в текущих данных они почти везде пустые; приложение использует их для печати документов.
6. Проверка дубля персоны в приложении: `SELECT PERSID FROM ANKETA WHERE (FAM+NAM+OT+Str(DTR))=:D`.
7. `OBRID` (образование) форма не заполняет (в данных NULL у всех; справочник EDUCATION есть).
8. «Пустая» дата в этой БД — `1899-12-30` (ноль Access), встречается в данных
   (например PASDT); при вставке можно передавать NULL — БД позволяет.

## 7. Алгоритм добавления организации

```sql
INSERT INTO ORGAN (ORGNAME, SNAME, IND, ADRES, INDP, ADRP, PHONE, INN, KPP,
                   OKPO, OKONH, EMAIL, OGRN, Staff, IsNOAP)
VALUES (..., False);
SELECT @@IDENTITY;   -- новый ORGID
```

- `ORGID` — автоинкремент. `IsNOAP`=False для обычных организаций.
- Обязательных полей на уровне БД нет (всё nullable, кроме BIT IsNOAP — имеет NOT NULL);
  приложение требует минимум название.

## 8. Алгоритм добавления аттестации (удостоверения)

Дословный SQL формы аттестации (qAttestAdd) — порядок действий:

```sql
-- 0. Предусловия: PERSID существует (или создан по §6), ORGID заявителя существует.
-- 1. Проверки дублей (как в приложении):
SELECT ATTID FROM ATTEST WHERE SvNo=:SvNo;          -- дубль номера -> предупреждение
SELECT SvNo, SvDateVyd, ATTID FROM ATTEST WHERE hologram=:hologram;  -- дубль голограммы

-- 2. Вставка аттестации:
INSERT INTO ATTEST
  (AttVid, PERSID, DataZajav, OrgZajav, NOA, Prot_ID, ProtNum, ProtDate,
   SvNo, SvDateVyd, SvDateFin, AttTyp, LEVZ, LEV, Result, SUMMA, WithVAT, hologram)
VALUES
  (:AttVid, :PERSID, :DataZajav, :OrgZajav, :NOA, :Prot_ID, :ProtNum, :ProtDate,
   :SvNo, :SvDateVyd, :SvDateFin, :AttTyp, :LEVZ, :LEV, :Result, :SUMMA, :WithVAT, :hologram);
SELECT @@IDENTITY;   -- новый ATTID

-- 3. Методы и объекты (M:N), минимум по одному — иначе «Сохранение невозможно»:
INSERT INTO ATT_METHODK (ATT_ID, METHODK_ID, COMMENT) VALUES (:ATTID, :MethodK_ID, '');
INSERT INTO ATT_OBJECTK (ATT_ID, OBJECTK_ID)          VALUES (:ATTID, :ObjectsK_ID);
-- по одной строке на каждый выбранный метод/объект
```

Правила и значения:
- Валидация приложения (строки из exe): обязательны номер свидетельства, заявленный
  и присвоенный уровни, результат, стоимость, организация-заявитель, «НОАП»,
  хотя бы один метод и один объект; голограмма — если включён чекбокс учёта.
- Для этой базы: `AttTyp=5` (СНК), `NOA=2`, `Result=2` (СДАЛ) / 3 (ЗАЯВ) / 4 (НЕ СДАЛ),
  `AttVid=1` (ПЕРВ) для нового специалиста; `LEV`/`LEVZ` ∈ {3,4,5} (I/II/III уровень).
- **Протокол сейчас не используется** (не несёт полезной информации, не заполнять):
  `Prot_ID=NULL, ProtNum='000', ProtDate=NULL` — так выглядит большинство новых записей.
- `SvDateFin` — обычно SvDateVyd + срок действия (в данных: 3 года для I ур., 5 лет для II).
- Повторная аттестация (AttVid=2): SvNo сохраняется прежний (см. §5) — XXXXX обязан
  совпадать с прежним номером этого человека (контроль — §9).
- `WithVAT`: если True — `SUMMA` включает НДС (ставка из VAT по SvDateVyd).
- `hologram`: '0' = допустимый фиктивный номер (после миграции), уникальность контролирует код.
- При редактировании методов/объектов существующей аттестации приложение делает
  `DELETE FROM ATT_METHODK WHERE ATT_ID=...; INSERT ...` (и аналогично для ATT_OBJECTK) —
  паттерн «удалить все и вставить заново».

## 9. Правила контроля при добавлении свидетельства (логика оператора)

Оператор при вводе имеет: номер сертификата (SvNo), ФИО, дату рождения, тип аттестации.
Перед вставкой ОБЯЗАТЕЛЬНЫ следующие проверки (подтверждено владельцем системы).

### 9.1. Первичная аттестация (AttVid=1, ПЕРВ)

Человек получает совершенно новый XXXXX (назначенный комиссией). Порядок:

1. **Проверка хвоста XXXXX по всем сертификатам** — поиск по ATTEST по хвостовой части
   номера (ошибки комиссии при назначении возможны):
   ```sql
   SELECT A.ATTID, A.PERSID, A.SvNo, AN.FAM, AN.NAM, AN.OT, AN.DTR
   FROM ATTEST A INNER JOIN ANKETA AN ON A.PERSID=AN.PERSID
   WHERE A.SvNo LIKE '%-:XXXXX';
   ```
   Если тот же XXXXX уже назначен ДРУГОМУ человеку — это **ошибка**, сообщить о ней,
   вставку не выполнять.
2. **Поиск человека в ANKETA по ФИО + дате рождения:**
   ```sql
   SELECT PERSID FROM ANKETA WHERE FAM=:FAM AND NAM=:NAM AND OT=:OT AND DTR=:DTR;
   ```
   Если человек найден, а аттестация первичная — это **ошибка** (первичная аттестация
   для уже существующего человека), сообщить, вставку не выполнять.
3. Только после прохождения проверок: вставка человека (§6) + аттестации (§8).

### 9.2. Непервичная аттестация (AttVid ≠ 1: ПОВТ/РАСШ/ПРОД/...)

1. Человек **обязан** существовать в ANKETA (поиск по ФИО + дате рождения).
   Не найден — **ошибка**.
2. У человека должна быть прежняя запись ATTEST с **тем же XXXXX**, что у новой записи:
   ```sql
   SELECT ATTID, SvNo FROM ATTEST WHERE PERSID=:PERSID;
   ```
   Несовпадение XXXXX (или отсутствие прежних записей) — **ошибка**, сообщить.
3. После проверок: вставка новой записи ATTEST с тем же XXXXX (§8), новые методы/объекты.

### 9.3. Прочее

- Протокол (PROTOCOL/SOSTAVKOM) не используется и не заполняется (§10).
- При создании приложения для вставки в базу: короткие и маленькие справочники
  (ATTLEVEL, ATTRES, ATTTYP, ATTVID, EDUCATION, COM_STATUS, Method_K, Objects_K, VAT,
  Settings и т.п.) читать в память при старте приложения — для оптимизации обращений к базе.

## 10. Протокол и комиссия (в базе сейчас не используется)

```sql
INSERT INTO PROTOCOL (ProtNum, ProtDate, ProtNumEx, ProtDateEx, ProtTyp, PROT_COMM, KOMATTID, KOMEXID)
VALUES (...);
SELECT @@IDENTITY;   -- PROT_ID, затем ссылаться из ATTEST.Prot_ID
INSERT INTO SOSTAVKOM (PROTID, PERSID, DOLGN, STATUS, ORD) VALUES (...);  -- члены комиссии
```

- Дубль протокола: `SELECT PROT_ID FROM PROTOCOL WHERE ProtNum=:ProtNum`.
- При удалении протокола приложение отвязывает аттестации:
  `UPDATE ATTEST SET Prot_ID=NULL, ProtNum=NULL, ProtDate=NULL WHERE Prot_ID=:ProtID`.
- В exe есть также INSERT в `PROTOCOL_EXAM` — таблицы в этой БД нет (функция не используется).

## 11. Проверка алгоритмов (тест на копии)

На копии `DB/NOAP_test.mdb` выполнен полный цикл (скрипт `scripts/_test_insert.ps1`):
вставка ORGAN (ORGID=1152) → ANKETA (PERSID=15090) → ATTEST (ATTID=27679) →
ATT_METHODK (ВИК) + ATT_OBJECTK (1.1) → чтение карточки тем же SELECT, что и форма
приложения (qAttest) → чтение джойном ФИО+организация+метод+объект → удаление тестовых
записей. Все вставки и чтения успешны, счётчики строк после очистки совпали с исходными
(ANKETA=10894, ORGAN=1135, ATTEST=27501, ATT_METHODK=27895, ATT_OBJECTK=195272).
Оригинальная база не изменялась.

## 12. Практические замечания для интеграции

- Доступ только 32-битный (Jet). Строка подключения приложения — Jet.OLEDB.4.0;
  для скриптов удобнее ODBC `Microsoft Access Driver (*.mdb)` через 32-bit PowerShell
  (`SysWOW64\...\powershell.exe`). Файлы .ps1 с кириллицей сохранять в UTF-8 **с BOM**.
- При массовых операциях избегать `NOT IN (SELECT ...)` по ATT_OBJECTK (195k строк,
  нет индекса по одному ATT_ID) — запрос может работать минутами; использовать LEFT JOIN.
- Даты в Jet SQL — `#yyyy-MM-dd#`; булево — True/False; десятичный разделитель в
  литералах — точка.
- NULL vs пустая строка: приложение различает (падежи и COMMENT хранятся пустыми строками).
- `1899-12-30` = нулевая дата Access («пусто»), не интерпретировать как реальную дату.
- Блокировки: пока NOAP.exe открыт, рядом лежит `DB/NOAP.ldb` — писать в базу
  в это время не стоит.

## 13. Артефакты анализа (scripts/)

| Файл | Содержимое |
|---|---|
| `_schema_dump.txt` | Таблицы, колонки, счётчики строк (ODBC GetSchema) |
| `_dao_dump.txt` | Связи, индексы, полный SQL сохранённых запросов (DAO 3.6) |
| `_data_dump.txt`, `_data_dump2.txt`, `_data_dump3.txt`, `_data_dump4.txt` | Справочники и статистика данных |
| `_exe_strings_report.txt` | SQL из NOAP.exe (INSERT/UPDATE/DELETE/SELECT дословно), формы, валидации |
| `_strings_all.txt` | Полный дамп 218K строк exe (оффсет + тип + текст) |
| `extract_strings.py` | Извлекатель строк из exe |
| `_dump_schema_odbc.ps1`, `_dump_dao.ps1`, `_dump_data*.ps1` | Скрипты снятия дампов |
| `_test_insert.ps1` | Проверенный сценарий вставки/чтения/удаления |
| `*.script` → `*.decoded.txt` | Расшифрованные PascalScript-миграции приложения |
