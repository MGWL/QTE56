# План: расширение API QTableWidgetItem (plan_create_table_api)

> **СТАТУС (2026-08-02): план ВЫПОЛНЕН.** Все 23 функции зарегистрированы
> (индексы 9263–9287 заняты), реализованы в C++ и `d/gen/gen_qtablewidget.d`,
> тест `test/test_qtablewidget_item.d` существует. Документ оставлен как
> историческая запись; раздел «Текущее состояние» описывает проект на 2026-07-23.

> **Задача для исполнителя** (машина с Qt 5.13.2 + MinGW + dmd).
> Проект: QTE56 — биндинги Qt 5.13.2 для D через C++ DLL-обёртки.
> Корень проекта: `H:/qte56/arch_new` (на целевой машине путь может отличаться — дальше все пути относительно корня).
> Перед началом прочитать: `AGENTS.md` (правила проекта), `CPP_DLL_PATTERNS.md` (паттерны обёрток).

---

## 1. Цель

Поднять покрытие `QTableWidgetItem` с текущих ~27% (9 функций: create/delete, text, flags, textAlignment) до практически полного набора повседневного API: чекбоксы, цвета, иконки, шрифты, подсказки, пользовательские данные (`data/setData`), позиция ячейки, выделение, клонирование.

По завершении на D должен работать такой код:

```d
auto item = new QTableWidgetItem("OK");
item.setCheckState(QtE.Checked);          // чекбокс в ячейке
item.setBackground(brush);                // подсветка (QBrush)
item.setForeground(brush);                // цвет текста
item.setIcon(icon);                       // иконка (QIcon)
item.setFont(font);                       // шрифт (QFont)
item.setToolTip("Подсказка");
item.setData(QtE.UserRole, 12345);        // int-данные (ID записи)
item.setData(QtE.UserRole + 1, "abc");    // string-данные
int id = item.data_int(QtE.UserRole);
tw.setItem(0, 0, item);                   // auto-disown, уже работает
```

**Out of scope** (отдельные задачи, НЕ делать в рамках этого плана):
- Симметричное расширение `QTreeWidgetItem` / `QListWidgetItem`.
- Сигналы `QTableWidget` (`itemClicked`, `itemChanged`, ... — сейчас 7 из 15).
- Валидаторы `QIntValidator`/`QDoubleValidator`/`QRegExpValidator`.

---

## 2. Текущее состояние (проверено 2026-07-23)

- `QTableWidgetItem` обёрнут **внутри** модуля `qte56_qtablewidget` (отдельного проекта нет):
  - C++: `cpp/qt5/qte56_qtablewidget/qte56_qtablewidget.h` (строки 76–85, секция `── QTableWidgetItem helpers ──`) и `qte56_qtablewidget.cpp`.
  - D: `d/gen/gen_qtablewidget.d`, класс `QTableWidgetItem` (строки ~100–190) — с ownership-моделью (`disown()`, `wrap()`, `_qt_owned`).
  - Реестр: `registry/functions.csv`, индексы **9254–9262** (9 функций), модуль `QTableWidget`.
- Блок индексов QTableWidget: **9200–9299**. Занято: 9200–9253 (виджет), 9254–9262 (item), плюс 19837/19838/19841 (дополнения). **Свободно: 9263–9299** (37 слотов) — новые функции размещать здесь.
- Модуль входит в merged DLL **`qte56_views.dll`** (`cpp/qt5/merged/qte56_views/qte56_views.pro` → `SOURCES += ../../qte56_qtablewidget/qte56_qtablewidget.cpp`).
- DLL-колонка в CSV для этих индексов: `qte56_qtablewidget.dll` (историческое standalone-имя; фактически функции живут в `qte56_views.dll` — это задокументированное расхождение, сохранять как у соседних строк).

### Справочные факты для реализации

- `QIcon` передаётся как `void*` (`QIcon*`) — паттерн: `qteQAction_setIcon(void* _obj, void* icon)` в `cpp/qt5/qte56_qaction/qte56_qaction.h:69`.
- `QVariant` в проекте уже используется точечно, паттерн в `cpp/qt5/qte56_qsettings/qte56_qsettings.cpp` (строки 38–74): `QVariant(qs(str))`, `.toInt()`, `.toBool()`. Для `data/setData` делаем **два типизированных варианта** (int и string) вместо голого QVariant — как `QSettings.value_i/value_s`.
- Возврат value-типов по значению — heap-копия, паттерн `qteQPushButton_sizeHint`: `return new QSize(...)`. Для геттеров `font()/icon()/background()` — `new QFont(...)` / `new QIcon(...)` / `new QBrush(...)`, на D-стороне `wrap()` + владение как у аналогичных `*Obj()` методов.
- Возврат строк — `void*` на новый `QString`, D забирает через `fromQString(qs)` (она же освобождает).
- `bool` → `int` (`? 1 : 0` / `(p0 != 0)`).
- Все функции в `extern "C"` блоке, макрос `QTABLEWIDGET_API`.
- `d/gen/gen_qtablewidget.d` имеет шапку «DO NOT EDIT MANUALLY», но item-хелперы в нём исторически **написаны вручную** (генератор их не производит) — правим вручную, строго в стиле существующего класса `QTableWidgetItem`.
- CSV строго **UTF-8** (один CP1251-байт роняет `tools/qte/qte.exe`).

---

## 3. Что добавить — полный список (23 функции)

Индексы назначать подряд с **9263**. Имена по конвенции `qteQTableWidgetItem_<method>`.

| Индекс | C++ функция | Сигнатура (C ABI) | Qt-метод |
|---|---|---|---|
| 9263 | `qteQTableWidgetItem_setCheckState` | `void f(void* item, int state)` | `setCheckState(Qt::CheckState)` |
| 9264 | `qteQTableWidgetItem_checkState` | `int f(void* item)` | `checkState()` |
| 9265 | `qteQTableWidgetItem_setToolTip` | `void f(void* item, void* qs)` | `setToolTip(QString)` |
| 9266 | `qteQTableWidgetItem_toolTip` | `void* f(void* item)` → new QString | `toolTip()` |
| 9267 | `qteQTableWidgetItem_setStatusTip` | `void f(void* item, void* qs)` | `setStatusTip(QString)` |
| 9268 | `qteQTableWidgetItem_statusTip` | `void* f(void* item)` → new QString | `statusTip()` |
| 9269 | `qteQTableWidgetItem_setWhatsThis` | `void f(void* item, void* qs)` | `setWhatsThis(QString)` |
| 9270 | `qteQTableWidgetItem_whatsThis` | `void* f(void* item)` → new QString | `whatsThis()` |
| 9271 | `qteQTableWidgetItem_setFont` | `void f(void* item, void* font)` | `setFont(QFont)` |
| 9272 | `qteQTableWidgetItem_font` | `void* f(void* item)` → new QFont | `font()` |
| 9273 | `qteQTableWidgetItem_setIcon` | `void f(void* item, void* icon)` | `setIcon(QIcon)` |
| 9274 | `qteQTableWidgetItem_icon` | `void* f(void* item)` → new QIcon | `icon()` |
| 9275 | `qteQTableWidgetItem_setBackground` | `void f(void* item, void* brush)` | `setBackground(QBrush)` |
| 9276 | `qteQTableWidgetItem_background` | `void* f(void* item)` → new QBrush | `background()` |
| 9277 | `qteQTableWidgetItem_setForeground` | `void f(void* item, void* brush)` | `setForeground(QBrush)` |
| 9278 | `qteQTableWidgetItem_foreground` | `void* f(void* item)` → new QBrush | `foreground()` |
| 9279 | `qteQTableWidgetItem_setSelected` | `void f(void* item, int sel)` | `setSelected(bool)` |
| 9280 | `qteQTableWidgetItem_isSelected` | `int f(void* item)` | `isSelected()` |
| 9281 | `qteQTableWidgetItem_row` | `int f(void* item)` | `row()` |
| 9282 | `qteQTableWidgetItem_column` | `int f(void* item)` | `column()` |
| 9283 | `qteQTableWidgetItem_setData_i` | `void f(void* item, int role, int value)` | `setData(role, QVariant(int))` |
| 9284 | `qteQTableWidgetItem_data_i` | `int f(void* item, int role)` | `data(role).toInt()` |
| 9285 | `qteQTableWidgetItem_setData_s` | `void f(void* item, int role, void* qs)` | `setData(role, QVariant(QString))` |
| 9286 | `qteQTableWidgetItem_data_s` | `void* f(void* item, int role)` → new QString | `data(role).toString()` |
| 9287 | `qteQTableWidgetItem_clone` | `void* f(void* item)` → caller-owned | `clone()` |

Не добавлять сознательно: `sizeHint/setSizeHint` (редко нужно, можно позже), `tableWidget()` (возврат владельца — есть обход через `item(row,col)`), `type()`, `read/write(QDataStream)`, операторы `<`.

---

## 4. Пошаговое исполнение

### Шаг 1. C++ заголовок — `cpp/qt5/qte56_qtablewidget/qte56_qtablewidget.h`

Дописать в секцию `── QTableWidgetItem helpers ──` (после строки 85), внутри `extern "C"`, строго в существующем стиле:

```cpp
QTABLEWIDGET_API void  qteQTableWidgetItem_setCheckState(void* item, int state);
QTABLEWIDGET_API int   qteQTableWidgetItem_checkState(void* item);
QTABLEWIDGET_API void  qteQTableWidgetItem_setToolTip(void* item, void* text);
QTABLEWIDGET_API void* qteQTableWidgetItem_toolTip(void* item);
// ... и далее все 23 по таблице из §3
```

### Шаг 2. C++ реализация — `cpp/qt5/qte56_qtablewidget/qte56_qtablewidget.cpp`

Тонкие trampoline по образцу существующих item-функций. Ключевые приёмы:

```cpp
// Чекбокс — enum как голый int (паттерн qteQLabel_setAlignment):
void qteQTableWidgetItem_setCheckState(void* item, int state) {
    ((QTableWidgetItem*)item)->setCheckState((Qt::CheckState)state);
}

// Строки — QString* наружу (паттерн qteQTableWidgetItem_text):
void* qteQTableWidgetItem_toolTip(void* item) {
    return new QString(((QTableWidgetItem*)item)->toolTip());
}

// Объекты — разыменование указателей:
void qteQTableWidgetItem_setFont(void* item, void* font) {
    ((QTableWidgetItem*)item)->setFont(*((QFont*)font));
}
void qteQTableWidgetItem_setBackground(void* item, void* brush) {
    ((QTableWidgetItem*)item)->setBackground(*((QBrush*)brush));
}

// Геттеры объектов — heap-копия (паттерн qteQPushButton_sizeHint):
void* qteQTableWidgetItem_font(void* item) {
    return new QFont(((QTableWidgetItem*)item)->font());
}

// QVariant — типизированные варианты (паттерн qte56_qsettings.cpp):
void qteQTableWidgetItem_setData_i(void* item, int role, int value) {
    ((QTableWidgetItem*)item)->setData(role, QVariant(value));
}
void* qteQTableWidgetItem_data_s(void* item, int role) {
    return new QString(((QTableWidgetItem*)item)->data(role).toString());
}

// clone — caller-owned:
void* qteQTableWidgetItem_clone(void* item) {
    return ((QTableWidgetItem*)item)->clone();
}
```

Добавить `#include <QFont>`, `<QIcon>`, `<QBrush>`, `<QVariant>` если их ещё нет в файле.

### Шаг 3. Реестр — `registry/functions.csv`

Добавить 23 строки сразу после строки индекса 9262 (`qteQTableWidgetItem_setTextAlignment`), формат как у соседей:

```
9263,qteQTableWidgetItem_setCheckState,QTableWidget,qte56_qtablewidget.dll,method
...
```

- Только **UTF-8**, без BOM-изменений и пересохранения в другой кодировке.
- Проверка: `tools/qte/qte.exe index check` из корня — коллизий быть не должно.

### Шаг 4. D-обёртка — `d/gen/gen_qtablewidget.d`

В `loadQTableWidget()` дописать `mixin(generateFunQt(9263, "qteQTableWidgetItem_setCheckState", "QTableWidget"));` и т.д. для всех 23.

В класс `QTableWidgetItem` (после `setTextAlignment`, перед закрывающей скобкой) — методы в существующем стиле, включая **typed-перегрузки** (они снимают void* и делают API «как в Qt»):

```d
void setCheckState(int state) { (cast(t_v__qp_i)pFunQt[9263])(_wh, state); }
int  checkState()             { return cast(int)(cast(t_i__qp)pFunQt[9264])(_wh); }

void setToolTip(string s) {
    auto ws = toQString(s);
    (cast(t_v__qp_qp)pFunQt[9265])(_wh, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}
string toolTip() {
    void* qs = (cast(t_qp__qp)pFunQt[9266])(_wh);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}
// ... statusTip/whatsThis аналогично ...

// typed-варианты для объектов (QFont/QIcon/QBrush — у них есть getWH()):
void setFont(QFont f)         { (cast(t_v__qp_qp)pFunQt[9271])(_wh, f.getWH()); }
void setIcon(QIcon i)         { (cast(t_v__qp_qp)pFunQt[9273])(_wh, i.getWH()); }
void setBackground(QBrush b)  { (cast(t_v__qp_qp)pFunQt[9275])(_wh, b.getWH()); }
void setForeground(QBrush b)  { (cast(t_v__qp_qp)pFunQt[9277])(_wh, b.getWH()); }

// геттеры объектов — wrap по паттерну *Obj() из этого же файла /
// gen_qtableview.d (horizontalHeaderObj) — сверить владение:
// heap-копия из C++ — caller-owned, D-деструктор должен удалять.

void setSelected(int sel)     { (cast(t_v__qp_i)pFunQt[9279])(_wh, sel); }
bool isSelected()             { return (cast(t_i__qp)pFunQt[9280])(_wh) != 0; }
int  row()                    { return cast(int)(cast(t_i__qp)pFunQt[9281])(_wh); }
int  column()                 { return cast(int)(cast(t_i__qp)pFunQt[9282])(_wh); }

// data/setData — перегрузки как в Qt:
void setData(int role, int value)    { (cast(t_v__qp_i_i)pFunQt[9283])(_wh, role, value); }
int  data_int(int role)              { return cast(int)(cast(t_i__qp_i)pFunQt[9284])(_wh, role); }
void setData(int role, string value) {
    auto ws = toQString(value);
    (cast(t_v__qp_i_qp)pFunQt[9285])(_wh, role, ws);
    (cast(t_v__qp)pFunQt[22])(ws);
}
string data_str(int role) {
    void* qs = (cast(t_qp__qp_i)pFunQt[9286])(_wh, role);
    string r = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return r;
}

// clone — caller-owned (НЕ wrap!):
QTableWidgetItem clone() {
    void* p = (cast(t_qp__qp)pFunQt[9287])(_wh);
    if (p is null) return null;
    return new QTableWidgetItem(p, false);  // D владеет, dtor удалит
}
```

Технические заметки:
- Нужные alias-типы (`t_v__qp_i_qp`, `t_qp__qp_i`, ...) — проверить наличие в импортах из `gen_qcore` в шапке файла; недостающие добавить через `mixin(generateAlias("..."))` в секцию «New aliases for this module» и в import-список.
- Импорты `gen_qfont`, `gen_qicon`, `gen_qbrush` добавить в шапку модуля (проверить, что циклических импортов не возникает — эти модули foundation-уровня, проблем быть не должно).
- Для геттеров `font()/icon()/background()/foreground()` (heap-копии из C++): сверить, как существующие `*Obj()`-методы в проекте оформляют владение (например `QTableWidgetItem.wrap` vs caller-owned конструктор `this(ptr, false)`), и повторить тот же паттерн. Heap-копия = caller-owned, т.е. НЕ `wrap()`.

### Шаг 5. Сборка DLL

На машине с развёрнутым окружением (см. `local.env.bat` / AGENTS.md §15):

```bash
# Вариант А — всё сразу:
build_merged_dlls.bat

# Вариант Б — только views:
cd cpp/qt5/merged/qte56_views
qmake qte56_views.pro && mingw32-make
```

Проверить, что `qte56_views.dll` обновилась в `dll/dll32/` (DESTDIR прописан в .pro по QTE56_ARCH).

### Шаг 6. Тест — `test/test_qtablewidget_item.d`

Новый файл по образцу соседних тестов (структура main: `LoadQt` → `QApplication` → виджеты → `exec` → `deleteApp`; импорты `gen_qtablewidget` + `gen_qtableview` + `gen_qabstractitemview` + `gen_qbrush` + `gen_qfont` + `gen_qicon`). Сценарий:

1. Таблица 3×3, заполнить `QTableWidgetItem`.
2. Ячейке (0,0): `setCheckState(QtE.Checked)` → прочитать `checkState()`, вывести в caption/лог.
3. Ячейке (0,1): `setBackground` (QBrush из QColor) + `setForeground` + `setFont` (жирный).
4. Ячейке (1,0): `setToolTip` + `setStatusTip` → прочитать обратно, сравнить строки.
5. Ячейке (1,1): `setData(QtE.UserRole, 42)`, `setData(QtE.UserRole+1, "key")` → `data_int`/`data_str`, проверить значения.
6. `clone()` ячейки, положить клон в (2,0), проверить текст.
7. `row()`/`column()` для ячейки из `item(1,1)` → должно быть 1/1.
8. `setSelected(1)` / `isSelected()`.

Сборка и запуск (консольная версия для writeln):

```bash
dmd -m32 -version=TreeQt -i test/test_qtablewidget_item.d -Id -Id/gen -L/DEFAULTLIB:user32 -of=test_qtablewidget_item.exe
./test_qtablewidget_item.exe
```

Критерий: компиляция без ошибок, запуск без AV, все проверки печатают ожидаемые значения, окно с таблицей показывает чекбокс и раскраску.

### Шаг 7. Финальные проверки и документация

1. `tools/qte/qte.exe index check` — 0 коллизий, 0 name mismatches.
2. `tools/qte/qte.exe index module QTableWidget` — новые индексы 9263–9287 на месте.
3. Обновить `AGENTS.md` §17: «Функций в реестре» 3467 → 3490.
4. Прогнать 1–2 существующих теста таблиц (например `test/test_clipboard_btngroup.d` или ближайший с QTableWidget) — убедиться, что пересборка `qte56_views.dll` ничего не сломала.

---

## 5. Критерии приёмки

- [ ] 23 новые функции в C++ (.h + .cpp), собирается `qte56_views.dll` без предупреждений о неразрешённых символах.
- [ ] 23 строки в `registry/functions.csv` (9263–9287), UTF-8, `qte index check` чист.
- [ ] `QTableWidgetItem` в `gen_qtablewidget.d`: все методы + typed-перегрузки (setFont/setIcon/setBackground/setForeground объектами, setData int/string).
- [ ] `test/test_qtablewidget_item.d` компилируется `dmd -m32`, запускается, визуально видны чекбокс и раскраска ячеек, проверки data/checkState/toolTip/row/column/clone проходят.
- [ ] Существующие тесты с QTableWidget не сломаны.
- [ ] `AGENTS.md` §17 обновлён.

## 6. Частые грабли (напоминание из AGENTS.md)

- `cast(void*)null` в конструкторах; `void main()`; `LoadQt` первым; `app.deleteApp()` последним, **не** `UnloadQt()`.
- ESlot только в `__gshared`; `@live` только для локальных `auto`, НЕ для полей класса.
- `fromQString(qs)` освобождает qs — не использовать после.
- Индексы в CSV никогда не перенумеровывать; новые — только в свободные слоты.
- CSV — строго UTF-8.
- После пересборки DLL убедиться, что тест запускается против **новой** `dll/dll32/qte56_views.dll` (на машине с развёрнутым runtime в системном PATH может лежать старая копия из `C:\Users\Public\QTE56\dll` — обновить и её, либо запускать с локальным PATH).
