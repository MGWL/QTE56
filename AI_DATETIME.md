# QTE56 — AI_DATETIME (QDate, QTime, QDateTime, виджеты дат)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_foundation.dll (QDate/QTime/QDateTime)
> import: gen_qdate  — покрывает ВСЕ три типа

---

## QDate — дата

```d
// import: gen_qdate
// QDate — D-owned (деструктор освобождает), value type semantics

// Создать:
auto d1 = new QDate(2026, 4, 17);   // год, месяц, день
auto d2 = QDate.currentDate();      // сегодня
auto d3 = QDate.fromString("2026-04-17", "yyyy-MM-dd");
auto d4 = QDate.fromString("17.04.2026", "dd.MM.yyyy");

// Компоненты:
int y  = d1.year();     // 2026
int mo = d1.month();    // 4
int d  = d1.day();      // 17
int dow = d1.dayOfWeek(); // 1=Пн … 7=Вс
int dim = d1.daysInMonth(); // количество дней в месяце
bool leap = QDate.isLeapYear(2026); // false

// Форматирование:
string s1 = d1.toString("yyyy-MM-dd");   // "2026-04-17"
string s2 = d1.toString("dd.MM.yyyy");   // "17.04.2026"
string s3 = d1.toString("d MMMM yyyy");  // "17 April 2026"
string s4 = d1.toString();               // системный формат

// Арифметика (возвращает НОВЫЙ объект):
auto d5 = d1.addDays(7);       // +7 дней
auto d6 = d1.addMonths(3);     // +3 месяца
auto d7 = d1.addYears(-1);     // -1 год
int diff = d1.daysTo(d2);      // дней от d1 до d2

// Сравнение:
bool eq = (d1 == d2);
bool lt = (d1 < d2);    // opCmp
bool vl = d1.isValid(); // false если invalid
bool nl = d1.isNull();  // false если создан через конструктор

// Dup:
auto copy = d1.dup();
```

---

## QTime — время суток

```d
// import: gen_qdate
auto t1 = new QTime(14, 30, 0);      // часы, минуты, секунды
auto t1 = new QTime(14, 30, 15, 500);// + миллисекунды
auto t2 = QTime.currentTime();
auto t3 = QTime.fromString("14:30:00", "HH:mm:ss");
auto t3 = QTime.fromString("2:30 PM", "h:mm AP");

// Компоненты:
int h  = t1.hour();    // 14
int mi = t1.minute();  // 30
int s  = t1.second();  // 0
int ms = t1.msec();    // 0

// Миллисекунды от начала дня:
int msd = t1.msecsSinceStartOfDay();

// Форматирование:
string s1 = t1.toString("HH:mm:ss");    // "14:30:00"
string s2 = t1.toString("h:mm AP");     // "2:30 PM"
string s3 = t1.toString("mm:ss.zzz");   // "30:00.000"

// Арифметика:
auto t4 = t1.addSecs(3600);  // +1 час
auto t5 = t1.addMSecs(500);  // +500 мс
int  ds = t1.secsTo(t2);     // секунд от t1 до t2
int  dm = t1.msecsTo(t2);    // миллисекунд
```

---

## QDateTime — дата+время

```d
// import: gen_qdate
auto dt1 = new QDateTime(new QDate(2026, 4, 17), new QTime(14, 30, 0));
auto dt1 = new QDateTime(new QDate(2026, 4, 17), new QTime(14, 30, 0, 500)); // + ms
auto dt2 = QDateTime.currentDateTime();
auto dt3 = QDateTime.currentDateTimeUtc();
auto dt4 = QDateTime.fromString("2026-04-17T14:30:00", "yyyy-MM-ddTHH:mm:ss");
auto dt5 = QDateTime.fromSecsSinceEpoch(1713355800.0);
auto dt6 = QDateTime.fromMSecsSinceEpoch(1713355800000.0);

// Компоненты:
int y  = dt1.year(); int mo = dt1.month(); int d = dt1.day();
int h  = dt1.hour(); int mi = dt1.minute(); int s = dt1.second();
int ms = dt1.msec();

// Части:
auto date = dt1.date();  // QDate
auto time = dt1.time();  // QTime

// Unix epoch:
double secs  = dt1.toSecsSinceEpoch();
double msecs = dt1.toMSecsSinceEpoch();

// Форматирование:
string s1 = dt1.toString("yyyy-MM-dd HH:mm:ss");
string s2 = dt1.toString("dd.MM.yyyy HH:mm");
string s3 = dt1.toString();  // системный формат

// Арифметика:
auto dt7 = dt1.addDays(1);
auto dt8 = dt1.addMonths(1);
auto dt9 = dt1.addYears(1);
auto dt10= dt1.addSecs(3600);
auto dt11= dt1.addMSecs(1000);
double ds = dt1.daysTo(dt2);   // разница в днях
double ss = dt1.secsTo(dt2);   // разница в секундах (double, субсекундная точность)

// Сравнение:
bool eq = (dt1 == dt2);
bool lt = (dt1 < dt2);
bool vl = dt1.isValid();
```

---

## QDateTimeEdit / QDateEdit / QTimeEdit

```d
// import: gen_qdatetimeedit
// QDateTimeEdit — показывает и редактирует дату+время
// QDateEdit     — только дата (наследует QDateTimeEdit)
// QTimeEdit     — только время (наследует QDateTimeEdit)

auto dte = new QDateTimeEdit(cast(void*)null);
auto de  = new QDateEdit(cast(void*)null);      // наследует QDateTimeEdit
auto te  = new QTimeEdit(cast(void*)null);

// Формат отображения:
dte.setDisplayFormat("dd.MM.yyyy HH:mm:ss");
de.setDisplayFormat("dd.MM.yyyy");
te.setDisplayFormat("HH:mm:ss");

// Установить значение (через QDate/QTime/QDateTime):
dte.setDateTime(2026, 4, 17, 14, 30, 0);
de.setDate(2026, 4, 17);
te.setTime(14, 30, 0);

// Или через QDate/QTime объекты:
auto qd = new QDate(2026, 4, 17);
auto qt = new QTime(14, 30, 0);
dte.setDate(qd);    // QDate overload
dte.setTime(qt);    // QTime overload

// Читать значение:
auto d = dte.qdate();       // → QDate (D-owned)
auto t = dte.qtime();       // → QTime (D-owned)
auto dt = dte.qdateTime();  // → QDateTime (D-owned)

// Диапазон допустимых значений:
dte.setMinimumDate(2020, 1, 1);
dte.setMaximumDate(2030, 12, 31);
dte.setDateRange(2020, 1, 1, 2030, 12, 31);
dte.setMinimumTime(8, 0, 0);
dte.setMaximumTime(18, 0, 0);

// Кнопки up/down:
dte.setCalendarPopup(true);   // всплывающий календарь
dte.setButtonSymbols(0);      // 0=UpDownArrows, 1=PlusMinus, 2=NoButtons
dte.setWrapping(true);        // 23:59 → 00:00

// Сигналы (прямые):
// dateTimeChanged: void cb(void* dt, int n, int y, int mo, int d, int h, int mi, int s, int ms)
extern(C) void onDTChanged(void* dt, int n,
    int y, int mo, int d, int h, int mi, int s, int ms) {
    // Собрать QDateTime:
    auto qdt = new QDateTime(new QDate(y, mo, d), new QTime(h, mi, s, ms));
}
dte.connect_dateTimeChanged(cast(void*)&onDTChanged, null);

// dateChanged: void cb(void* dt, int n, int year, int month, int day)
extern(C) void onDateChanged(void* dt, int n, int y, int mo, int dd) { }
de.connect_dateChanged(cast(void*)&onDateChanged, null);

// timeChanged: void cb(void* dt, int n, int h, int min, int sec, int ms)
extern(C) void onTimeChanged(void* dt, int n, int h, int mi, int s, int ms) { }
te.connect_timeChanged(cast(void*)&onTimeChanged, null);
```

---

## QCalendarWidget

```d
// import: gen_qcalendarwidget
auto cal = new QCalendarWidget(cast(void*)null);

// Установить дату:
cal.setSelectedDate(2026, 4, 17);
// Или через QDate:
auto qd = new QDate(2026, 4, 17);
cal.setSelectedDate(qd);

// Читать выбранную дату:
auto selected = cal.selectedQDate();  // → QDate (D-owned)
int y = selected.year(); int mo = selected.month(); int d = selected.day();

// Диапазон:
cal.setMinimumDate(2020, 1, 1);
cal.setMaximumDate(2030, 12, 31);
cal.setDateRange(2020, 1, 1, 2030, 12, 31);

// Стиль:
cal.setGridVisible(true);             // показать сетку
cal.setNavigationBarVisible(true);    // показать навигацию
cal.setFirstDayOfWeek(1);             // 1=Понедельник, 7=Воскресенье
cal.setSelectionMode(1);              // 1=SingleSelection, 0=NoSelection
cal.setHorizontalHeaderFormat(3);     // 3=ShortDayNames 2=SingleLetterDayNames
cal.setVerticalHeaderFormat(1);       // 1=ISOWeekNumbers 0=NoVerticalHeader

// Перейти на страницу:
cal.setCurrentPage(2026, 3);          // март 2026

// Сигналы (прямые):
// selectionChanged: void cb(void* dthis)
extern(C) void onCalSel(void* dthis) {
    auto d = cal.selectedQDate();
    // использовать d
}
cal.connect_selectionChanged(cast(void*)&onCalSel, null);

// currentPageChanged: void cb(void* dthis, int year, int month)
extern(C) void onCalPage(void* dthis, int year, int month) { }
cal.connect_currentPageChanged(cast(void*)&onCalPage, null);
```

---

## Типичные паттерны

### Строка → дата и обратно
```d
// Разобрать строку:
auto d = QDate.fromString("2026-04-17", "yyyy-MM-dd");
if (d.isValid()) {
    // использовать d
}

// Форматировать для отображения:
string display = QDate.currentDate().toString("d MMMM yyyy");
// → "17 April 2026"

// Строковые токены:
// yyyy = 4-цифровой год   yy = 2-цифровой
// MM = месяц 01-12        M = месяц 1-12
// dd = день 01-31         d = день 1-31
// MMM = Jan...Dec         MMMM = January...December
// ddd = Mon...Sun         dddd = Monday...Sunday
// HH = часы 00-23         H = часы 0-23
// hh = часы 01-12         h = часы 1-12
// mm = минуты 00-59       ss = секунды 00-59
// zzz = миллисекунды      AP/ap = AM/PM
```

### Возраст / разница дат
```d
auto birth = new QDate(1990, 6, 15);
auto today = QDate.currentDate();
int  days  = birth.daysTo(today);
int  years = today.year() - birth.year();
if (today.month() < birth.month() ||
    (today.month() == birth.month() && today.day() < birth.day()))
    years--;
```

### Текущее время в QLabel (через QTimer)
```d
__gshared QLabel  g_lblTime;
__gshared ESlot   g_slTimer;
extern(C) void onTick(void* dt, int n) {
    g_lblTime.setText(QTime.currentTime().toString("HH:mm:ss"));
}
auto timer = new QTimer(cast(void*)null);
g_slTimer  = new ESlot(timer.getWH());
g_slTimer.set(cast(void*)&onTick);
timer.connect_timeout(g_slTimer);
timer.start(1000);
```

---

## Gotchas

```
1. import gen_qdate — покрывает QDate, QTime и QDateTime (все три!).
2. QDate/QTime/QDateTime — D-owned. destroy() вызывается автоматически.
3. Арифметические методы (addDays/addSecs) возвращают НОВЫЙ объект.
4. QDateTimeEdit сигнал dateTimeChanged: ДЕВЯТЬ параметров (dt,n,y,mo,d,h,mi,s,ms)!
5. QDateEdit/QTimeEdit — наследуют QDateTimeEdit, import тот же.
6. QCalendarWidget сигнал selectionChanged: только void* dthis (без n!)
7. QDate.fromString возвращает null-дату при ошибке — всегда проверять isValid().
8. daysTo, secsTo — возвращают int/double. Если d1 > d2, результат отрицательный.
9. dayOfWeek(): 1=Monday, 7=Sunday (ISO 8601, НЕ 0=Sunday как в других системах).
10. DLL: qte56_foundation.dll (не qte56_widgets.dll).
```
