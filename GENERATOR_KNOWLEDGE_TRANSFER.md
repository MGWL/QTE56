# QTE56 Generator: Knowledge Transfer Document

> ↑ Навигация: [AGENTS.md](AGENTS.md)

> Целевая аудитория: AI-ассистент, работающий с кодовой базой QTE56.
> Язык: русская проза, английский код.
> Версия: 2026-03-10.

---

## Содержание

1. [Архитектура генератора](#1-архитектура-генератора)
2. [type_map.py — маппинг C++ → D](#2-type_mapy--маппинг-c--d)
3. [functions.csv — реестр индексов](#3-functionscsv--реестр-индексов)
4. [Система generateAlias](#4-система-generatealias)
5. [Система generateFunQt](#5-система-generatefunqt)
6. [Командная строка](#6-командная-строка)
7. [Что генератор делает правильно, что требует ручных правок](#7-что-генератор-делает-правильно-что-требует-ручных-правок)
8. [Паттерны ручных правок](#8-паттерны-ручных-правок)
9. [Полный воркфлоу: добавить новый Qt-класс](#9-полный-воркфлоу-добавить-новый-qt-класс)
10. [Добавить функцию вручную без генератора](#10-добавить-функцию-вручную-без-генератора)
11. [Специальные случаи сигналов](#11-специальные-случаи-сигналов)
12. [Обновление существующего класса: добавить методы](#12-обновление-существующего-класса-добавить-методы)
13. [Стратегия выделения индексных блоков](#13-стратегия-выделения-индексных-блоков)
14. [Полный пример: добавить QCalendarWidget с нуля](#14-полный-пример-добавить-qcalendarwidget-с-нуля)

---

## 1. Архитектура генератора

Файлы генератора расположены в `arch_new/generator/`. Точка входа — `main.py`.

### Модули

| Файл | Роль |
|---|---|
| `main.py` | Оркестратор: parse → plan → register → generate |
| `qt_parser.py` | Regex-парсер `.h`-файла Qt → `QtClass` |
| `type_map.py` | Маппинг C++ типов в D-типы и alias-ключи |
| `registry.py` | Чтение/запись `functions.csv` |
| `d_generator.py` | Генерация `gen_qXxx.d` |
| `cpp_generator.py` | Генерация C++ `.h`, `.cpp`, `.pro` |
| `qt_hierarchy.py` | Статическая иерархия Qt-классов, D-родители |
| `events.py` | Спецификации Qt-событий (mouse, key, resize...) |

Актуальный полный список (2026-08-02): augment.py, checks.py, cpp_generator.py,
cpp_texts.py, d_generator.py, events.py, fileops.py, geninfo.py,
knowledge_access.py, main.py, make_build.py, merge_dlls.py, planner.py,
qt_hierarchy.py, qt_knowledge.py, qt_parser.py, registry.py, reindex.py,
scan_augment.py, scan_ldc2_bugs.py, test_new_class.py, type_map.py.
Ключевые добавки к таблице выше: `planner.py` (планирование методов),
`checks.py` (preflight-проверки), `cpp_texts.py`, `geninfo.py` (блок
GENERATOR-INFO), `fileops.py`, `qt_knowledge.py` + `knowledge_access.py`
(база знаний Qt, см. §15), `augment.py` (режим `--augment`),
`scan_augment.py` (скан покрытия всех модулей: `py scan_augment.py [топN]`),
`scan_ldc2_bugs.py` (поиск ldc2-несовместимостей в gen_*.d),
`reindex.py` (переиндексация), `test_new_class.py` (harness, см. §15.5),
`make_build.py`, `merge_dlls.py`.

### Полный пайплайн `main.py`

```
parse_qt_header(header.h, target_class=...)
    ↓ QtClass (name, parents, constructors, methods, signals)
_plan_methods(cls, qt_class, reg, module_name, dll_file)
    ↓ (method_specs, signals, ctor_idx, dtor_idx, ...)
    │   ├─ собирает методы из заголовка (+ методы из --parent-header)
    │   ├─ добавляет стандартные QWidget методы (show/hide/update)
    │   ├─ фильтрует методы, унаследованные от d_parent
    │   ├─ присваивает func_names: qte{Cls}_create, _delete, _create_text, методы
    │   └─ вызывает reg.add_class_functions() → индексы; сохраняет CSV
_write_cpp_with_lifecycle(...)
    ↓ qte56_qXxx.h, qte56_qXxx.cpp, qte56_qXxx.pro
DGenerator(...).generate_all()
    ↓ gen_qXxx.d
```

### Структура сгенерированного `gen_qXxx.d`

1. **Docstring** с предупреждением `DO NOT EDIT MANUALLY`.
2. **Импорты**: `qte56_core`, `qte56_loader`, нужные символы из `gen_qcore`, D-родительский класс.
   - Если файл использует typed ownership overloads — дополнительно: `import gen_qobject : QObject;`
3. **Новые alias-миксины**: `mixin(generateAlias("key"))` для типов, которых нет в `gen_qcore`.
4. **`void loadQXxx()`**: серия `mixin(generateFunQt(idx, "func_name", "Module"))`.
5. **`static this()`**: `registerModule("QXxx", "qte56_xxx.dll", &loadQXxx)`.
6. **`class QXxx : DParent`**: конструкторы, методы, сигналы, обработчики событий.

### Typed ownership overloads (паттерн для контейнеров)

Для методов, которые принимают Qt ownership (addWidget, setLayout, setCentralWidget и др.),
**вручную** добавляются типизированные перегрузки рядом с void*-версиями.
Генератор их НЕ создаёт — это ручное дополнение.

**Паттерн для виджетов (QObject параметр):**
```d
void addWidget(QObject w, int stretch = 0) {
    if (w is null) return;
    auto wh = w.getWH();   // сначала взять handle
    w.disown();             // потом передать ownership
    (cast(t_v__qp_qp_i)pFunQt[IDX])(_wh, wh, stretch);
}
```

**Паттерн для layouts (шаблонная перегрузка):**
```d
void addLayout(L)(L layout, int stretch = 0)
    if (is(typeof(layout.disown())) && !is(L == void*))
{
    if (layout is null) return;
    auto lh = layout.getWH();
    layout.disown();
    (cast(t_v__qp_qp_i)pFunQt[IDX])(_wh, lh, stretch);
}
```

Шаблон `(L)(...)` с ограничением `is(typeof(layout.disown()))` работает со всеми
layout-типами (QVBoxLayout, QHBoxLayout, QGridLayout, QFormLayout), которые не наследуют QObject.

**Файлы с typed overloads** (обновлено 2026-04-09):
gen_qlayout.d, gen_qwidget.d, gen_qmainwindow.d, gen_qtabwidget.d,
gen_qstackedwidget.d, gen_qtoolbar.d, gen_qscrollarea.d, gen_qdockwidget.d, gen_qsplitter.d.

### Внутренние dataclass-ы `main.py`

**`MethodSpec`** — описание одного метода:
- `qt_name` — имя в D/Qt (`"setText"`)
- `func_name` — имя C++ функции (`"qteQLabel_setText"`)
- `idx` — индекс pFunQt
- `params` — список `QtParam`
- `ret_d` — D тип возврата (`"void"`, `"string"`, `"int"`, ...)
- `category` — `"method"` (по умолчанию)

**`QtClass`** (из qt_parser.py):
- `name`, `parents`, `constructors`, `methods`, `properties`

**`QtMethod`** (из qt_parser.py):
- `name`, `ret_type`, `params`, `is_virtual`, `is_const`, `is_slot`, `is_signal`, `is_static`, `is_protected`, `is_supported`, `d_ret_type`

### Логика фильтрации методов `_compute_skip_methods`

Когда задан `d_parent`, генератор обходит цепочку предков от `d_parent` до `QWidget` и собирает `INTERMEDIATE_METHODS` каждого промежуточного класса плюс `_QWIDGET_VIRTUAL_SKIP` (show, hide, update, sizeHint, minimumSizeHint, heightForWidth, hasHeightForWidth, setVisible). Эти методы исключаются из генерации в дочернем классе — они доступны через D-наследование.

### Логика перегрузок `_overload_suffix`

Если несколько методов с одним именем: суффикс строится из кодов первого параметра:

```python
_TYPE_SUFFIX = {
    "const QString&": "s", "QString": "s",
    "int": "i",  "unsigned int": "u", "bool": "b",
    "double": "d", "qreal": "d", "float": "f",
    "QWidget*": "w", "const QWidget*": "w",
    "QObject*": "o",
}
# Если нет в таблице → "p"; нет параметров → "_v"
```

---

## 2. type_map.py — маппинг C++ → D

### Основная таблица `_TYPE_MAP`

Каждая запись: `cpp_type → (d_type, pass_as, needs_conv)`.

| C++ тип | D тип | pass_as | Примечание |
|---|---|---|---|
| `void` | `void` | value | |
| `bool` | `bool` | value | в ABI передаётся как int |
| `int` | `int` | value | |
| `unsigned int` / `uint` | `uint` | value | |
| `long` | `int` | value | Windows LLP64: 4 байта |
| `unsigned long` | `uint` | value | |
| `qint64` | `long` | value | |
| `quint64` | `ulong` | value | |
| `short` | `int` | value | |
| `qreal` | `double` | value | |
| `size_t` / `intptr_t` / `WId` | `size_t` | value | pointer-sized |
| `double` | `double` | value | |
| `float` | `float` | value | |
| `int*` / `const int*` / `bool*` / `double*` | `void*` | out | out-параметры |
| `QString` / `const QString&` / `QString&` | `string` | value | needs_conv=True |
| `QWidget*` / `const QWidget*` | `void*` | ptr | |
| `QObject*` / `const QObject*` | `void*` | ptr | |
| `QFrame*` | `void*` | ptr | |
| `QLabel*` | `void*` | ptr | |
| `QPushButton*` | `void*` | ptr | |
| `QLayout*` / `QBoxLayout*` / `QVBoxLayout*` / `QHBoxLayout*` | `void*` | ptr | |
| `QStyle*` / `QAction*` / `const QAction*` | `void*` | ptr | |
| `QMenu*` / `QMenuBar*` / `QStatusBar*` | `void*` | ptr | |
| `QGraphicsEffect*` / `QPaintDevice*` / `const QPaintDevice*` | `void*` | ptr | |
| `const QIcon&` / `QIcon` | `void*` | ptr | heap-allocated QIcon* |
| `const QFont&` / `QFont&` | `void*` | ptr | передаётся как void* |
| `QFont` (возврат) | `QFont_v` | value | heap-allocated copy |
| `const QColor&` / `QColor&` | `void*` | ptr | |
| `QColor` (возврат) | `QColor_v` | value | heap-allocated copy |
| `QRgb` | `uint` | value | typedef для unsigned int |
| `QRect` / `const QRect&` | `DRect` | value | pack/unpack через pFunQt |
| `QPoint` / `const QPoint&` | `DPoint` | value | |
| `QSize` / `const QSize&` | `DSize` | value | |
| Qt enum (`Qt::Xxx`, `QFrame::Shape`, ...) | `int` | value | |

### Фоллбэки `cpp_type_to_d()`

После промаха в таблице применяются правила:

1. Любой неизвестный указатель на Q-объект (`Q*` или `const Q*`) → `("void*", "ptr", False)`.
2. Любой qualified enum без `<`, `*`, `&` (паттерн `Qt::Xxx` или `QFoo::Bar`) → `("int", "value", False)`.
3. Bare CamelCase enum (например `EchoMode`, `InsertPolicy`) — без Q-префикса → `("int", "value", False)`.

### Неподдерживаемые типы `UNSUPPORTED_TYPES`

```
QVariant, QVariant&, const QVariant&
QModelIndex, const QModelIndex&
QPainter*
QRegion, const QRegion&
QBitmap, QPixmap, QImage
QByteArray, const QByteArray&
QStringList
QList, QVector, QMap, QHash
std::function
```

Метод с любым из этих типов в параметрах или возврате получает `is_supported=False` и не генерируется.

### D value-type структуры

| Qt тип | D структура | Поля |
|---|---|---|
| `QRect` | `DRect` | x, y, w, h |
| `QPoint` | `DPoint` | x, y |
| `QSize` | `DSize` | w, h |

Unpack происходит через специальные функции в `pFunQt`:
- `pFunQt[31]` — `qteQRect_unpack(void* rect, int* x, int* y, int* w, int* h)`
- `pFunQt[34]` — `qteQPoint_unpack(void* pt, int* x, int* y)`
- `pFunQt[37]` — `qteQSize_unpack(void* sz, int* w, int* h)`

### `_alias_key(ret_d, params)` — вычисление ключа alias

Функция в `d_generator.py` строит ключ по D-типу возврата и списку Qt-параметров:

```python
RET_MAP = {
    "void": "v", "string": "qp", "int": "i", "uint": "ui",
    "bool": "i",    # bool return → int в C ABI
    "void*": "qp", "double": "d", "float": "f",
    "DSize": "qp", "DPoint": "qp", "DRect": "qp",  # heap struct
    "QFont_v": "qp", "QColor_v": "qp",
    "long": "l", "ulong": "ul",
}
```

Первый параметр всегда `qp` (implicit `void* _obj`). Для каждого Qt-параметра:
- `QString` / `const QString&` → `qp` + `i` (wchar_t* + len)
- `bool` → `i`
- `int`, `unsigned int`, `short`, `long` → `i`
- `double`, `qreal` → `d`
- `float` → `f`
- `qint64` / `qlonglong` → `l`
- Qt enum (`Qt::Xxx`, `QFlags`, `Foo::Bar`, bare CamelCase) → `i`
- Qt-pointer (`Q...* `) → `qp`
- всё остальное → `qp`

---

## 3. functions.csv — реестр индексов

**Путь**: `arch_new/registry/functions.csv`

**Это единственный источник истины**. Индексы в CSV и в `gen_*.d` должны совпадать. Никогда не менять индексы в уже существующих записях — только через `reindex.py`.

### Формат

```
# comment line (начинается с #)
index,func_name,module,dll,category
```

**Колонки:**

| Колонка | Тип | Примеры |
|---|---|---|
| `index` | int | `800`, `17300` |
| `func_name` | string | `qteQLabel_create`, `qteQLabel_setText` |
| `module` | string | `QLabel`, `QCore`, `QPushButton` |
| `dll` | string | `qte56_widgets.dll`, `qte56_qcore.dll` |
| `category` | string | `lifecycle`, `method`, `signal`, `event`, `lambda_connect`, `value`, `string`, `style`, `geometry` |

### Пример записей

```csv
800,qteQLabel_create,QLabel,qte56_qlabel.dll,lifecycle
801,qteQLabel_delete,QLabel,qte56_qlabel.dll,lifecycle
802,qteQLabel_create_text,QLabel,qte56_qlabel.dll,lifecycle
806,qteQLabel_text,QLabel,qte56_qlabel.dll,method
825,qteQLabel_setText,QLabel,qte56_qlabel.dll,method
```

### Структура блоков

Комментарии в CSV обозначают блоки классов:

```csv
# -- QCore (1-71) --
# -- QWidget (200-398) --
```

Внутри блока индексы не обязательно непрерывны — дыры допустимы и встречаются повсеместно.

### Правила `registry.py`

- `add_class_functions()`: если модуль уже есть в CSV — возвращает существующие индексы, не создаёт дубликаты.
- `assign_block()`: для нового модуля берёт `((max_idx // BLOCK_SIZE) + 1) * BLOCK_SIZE`. `BLOCK_SIZE = 1000`.
- Коллизия индексов → `ValueError` с сообщением.
- `save()`: дописывает **только новые** записи в конец файла, не трогая существующие строки и комментарии.

### Следующий свободный индекс

По состоянию на 2026-08-02: максимальный занятый индекс **24713**, таблица
`pFunQt[25000]` практически заполнена. Новые классы размещаются в дырах
нумерации через `--index-start` (см. §15.4); актуальный список дыр —
`tools/qte/qte.exe index gaps`.

---

## 4. Система generateAlias

`generateAlias(key)` определена в `d/qte56_core.d`. Принимает строку-ключ и возвращает D-код объявления alias функционального типа.

### Формат ключа

```
RET__P1_P2_P3
```

- До `__` — код типа возврата.
- После `__` — коды параметров через `_`.
- Первый параметр **всегда** `qp` (это `void* _obj` / `void* w`).

### Таблица кодов типов

| Код | D тип (фактический) | C тип в ABI |
|---|---|---|
| `v` | void | void |
| `i` | int | int (bool тоже передаётся как int) |
| `ui` | uint | unsigned int |
| `l` | long | int64 |
| `ul` | ulong | uint64 |
| `d` | double | double |
| `f` | float | float |
| `b` | bool | int |
| `sz` | size_t | size_t |
| `qp` | void* | void* (объекты Qt, строки, value types) |
| `ip` | int* | int* (out-параметры) |
| `bp` | bool* | bool* |

### Примеры ключей

| Ключ | C-сигнатура | Что означает |
|---|---|---|
| `v__qp` | `void fn(void*)` | деструктор, `clear()`, `stop()` |
| `qp__qp` | `void* fn(void*)` | `text()`, `buddy()`, `menu()` |
| `i__qp` | `int fn(void*)` | `interval()`, `isChecked()`, `count()` |
| `v__qp_i` | `void fn(void*, int)` | `setInterval(int)`, `setChecked(bool)` |
| `v__qp_qp` | `void fn(void*, void*)` | `setMenu(QMenu*)`, `setMovie(QMovie*)` |
| `v__qp_i_i` | `void fn(void*, int, int)` | `setSelection(int, int)` |
| `v__qp_d` | `void fn(void*, double)` | `setNum(double)` |
| `qp__qp_i_qp` | `void* fn(void*, void*, int, void*)` | `create_text(wchar_t*, int, void* parent)` |
| `v__qp_i_qp_qp` | `void fn(void*, int, void*, void*)` | `setEventHandler(id, cb, dthis)` |
| `v__qp_qp_qp` | `void fn(void*, void*, void*)` | lambda-connect сигналы |
| `v__qp_ip_ip` | `void fn(void*, int*, int*)` | unpack QPoint/QSize |
| `v__qp_ip_ip_ip_ip` | `void fn(void*, int*, int*, int*, int*)` | unpack QRect |
| `v__qp_i_i_i` | `void fn(void*, int, int, int)` | setDate(y, mo, d) |
| `v__qp_i_i_i_i_i_i` | `void fn(void*, int, int, int, int, int, int)` | setDateRange(...) |
| `qp__i_i_i` | `void* fn(int, int, int)` | value type ctor (QColor(r,g,b)) |
| `qp__i_qp` | `void* fn(int, void*)` | нестандартный ctor (QHeaderView) |
| `t_qp__` | `void* fn()` | статическая функция без параметров |

### Alias-ключи уже определённые в `gen_qcore.d` (GCORE_ALIASES)

Генератор **не** добавляет эти через `mixin(generateAlias(...))` — они импортируются из `gen_qcore`:

```
qp__i, v__qp_i, b__qp_i, qp__qp_qp, v__qp_qp_qp_i, qp__qp_i, i__qp_qp_i,
v__qp, qp__i_i_i_i, v__qp_ip_ip_ip_ip, qp__i_i, v__qp_ip_ip, qp__qp, i__qp,
v__qp_qp_i, v__qp_i_qp_qp, v__qp_qp_qp
```

Все остальные ключи генератор объявляет через `mixin(generateAlias("..."))` в секции "New aliases for this module" перед `loadQXxx()`.

### Пример секции в `gen_qlabel.d`

```d
// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));  // create_text: void* fn(wchar_t*, int, void*)
mixin(generateAlias("v__qp_d"));      // setNum(double)
mixin(generateAlias("v__qp_i_i"));    // setSelection(int, int)
mixin(generateAlias("v__qp_qp"));     // setMovie(QMovie*), setBuddy(QWidget*)
```

---

## 5. Система generateFunQt

`generateFunQt(idx, func_name, module_name)` определена в `d/qte56_core.d`. Генерирует строку D-кода, которая при выполнении через `mixin()` записывает адрес функции из DLL в `pFunQt[idx]`.

### Механизм

```d
// В loadFoo():
mixin(generateFunQt(800, "qteQLabel_create", "QLabel"));
// раскрывается в:
pFunQt[800] = loadFn("qteQLabel_create", "QLabel");
```

`loadFn` вызывается после `LoadQt()`, который уже загрузил DLL через `LoadLibrary`/`dlopen`. `loadFn` делает `GetProcAddress` (Windows) или `dlsym` (Linux).

### Соглашение по именованию функций

| Вид | Паттерн | Пример |
|---|---|---|
| Конструктор | `qte{Cls}_create(void* parent) → void*` | `qteQLabel_create` |
| Деструктор | `qte{Cls}_delete(void* w) → void` | `qteQLabel_delete` |
| Текстовый ctor | `qte{Cls}_create_text(void* wstr, int len, void* parent) → void*` | `qteQLabel_create_text` |
| Обычный метод | `qte{Cls}_{name}(void* _obj, ...) → ret` | `qteQLabel_setText` |
| Перегруженный | `qte{Cls}_{name}{suffix}` | `qteQLabel_setNum_i`, `qteQLabel_setNum_d` |
| setEventHandler | `qte{Cls}_setEventHandler(void* w, int id, void* cb, void* dthis)` | |
| lambda-connect | `qte{Cls}_connect_{sigName}(void* w, void* cb, void* dthis)` | `qteQMenu_connect_triggered` |

Суффиксы для перегруженных методов: `_i` (int), `_d` (double), `_s` (QString), `_b` (bool), `_u` (uint), `_f` (float), `_w` (QWidget*), `_o` (QObject*), `_p` (другое ptr), `_v` (нет параметров).

### Порядок записей в loadQXxx()

1. `create` (ctor_idx)
2. `delete` (dtor_idx)
3. `create_text` (если есть text ctor)
4. Все методы (в порядке, совпадающем с порядком MethodSpec)
5. `setEventHandler` (если QWidget-подкласс)
6. lambda-connect функции (если есть Qt-pointer сигналы)

---

## 6. Командная строка

Генератор запускается из директории `arch_new/generator/`:

```
py main.py <header.h> [options]
```

### Аргументы

| Аргумент | По умолчанию | Описание |
|---|---|---|
| `header` | (обязателен) | Путь к Qt `.h` файлу |
| `--module NAME` | имя класса из `.h` | Имя Qt класса (нужно если в файле несколько классов) |
| `--dll FILENAME` | `qte56_{cls}.dll` | Имя DLL-файла |
| `--csv PATH` | `../registry/functions.csv` | Путь к реестру |
| `--d-out DIR` | `../d/gen` | Директория для `.d` файла |
| `--cpp-out DIR` | `../cpp/qt5/qte56_{cls}` | Директория для C++ файлов |
| `--qt-mod MODULES` | `core widgets` | Qt модули для `.pro` (например `core gui widgets sql`) |
| `--parent-header PATH` | [] | Заголовок родительского Qt-класса; можно повторить |
| `--d-parent CLASS` | из `D_PARENT_FULL` | D-родитель для наследования (например `QFrame`) |
| `--info` | False | Показать info и выйти без генерации файлов |
| `--no-cpp` | False | Пропустить генерацию C++ файлов |
| `--no-d` | False | Пропустить генерацию D файла |

### Примеры

```bash
# Базовый: сгенерировать QLabel
py main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qlabel.h \
    --module QLabel --dll qte56_qlabel.dll

# С наследованием QFrame (методы родителя включаются в DLL)
py main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qlabel.h \
    --module QLabel \
    --parent-header C:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qframe.h \
    --d-parent QFrame

# В файле несколько классов — выбрать конкретный
py main.py .../qspinbox.h --module QSpinBox --dll qte56_qspinbox.dll
py main.py .../qspinbox.h --module QDoubleSpinBox --dll qte56_qdoublespinbox.dll

# Только просмотр без записи файлов
py main.py .../qlabel.h --info

# Только D-файл (C++ уже написан вручную)
py main.py .../qlabel.h --module QLabel --no-cpp

# Указать целевые директории явно
py main.py .../qlabel.h --d-out ../../d/gen --cpp-out ../../cpp/qt5/qte56_qlabel

# Qt-модуль sql
py main.py .../qsqlquery.h --module QSqlQuery --qt-mod "core sql"
```

---

## 7. Что генератор делает правильно, что требует ручных правок

### Генерируется корректно автоматически

- Методы с примитивными типами (int, bool, double, float).
- Методы с `QString` параметрами и возвратом (конвертация через `toQString`/`fromQString`).
- Методы с Qt-указателями (`QMenu*`, `QWidget*` → `void*`).
- Qt enum параметры (`Qt::Alignment`, `Qt::WindowFlags` → `int`).
- Конструкторы `this(void* parent)` и `this(string text, void* parent)`.
- Перегруженные методы с суффиксами.
- Сигналы через `ESlot`/`connectQt` (bool, int, double, QString, QPoint, пара int).
- Lambda-connect для Qt-pointer сигналов (`QAction*`, `QMenu*`, `QTreeWidgetItem*`).
- Event handler инфраструктура (`setEventHandler`, `onMousePress`, ...).
- D-наследование с фильтрацией унаследованных методов.
- `static this() { registerModule(...); }` — авторегистрация.
- `static Cls wrap(void*)` фабрика для Qt-owned объектов.

### Требует ручных правок

| Проблема | Признак | Фикс |
|---|---|---|
| `QPrivateSignal` в сигнале | Последний параметр сигнала типа `QPrivateSignal` | Удалить `QPrivateSignal` из сигнатуры в `connectQt` |
| Дублирующиеся перегрузки | `QMessageBox::information` — static и instance | Удалить лишний вариант; оставить только нужный |
| Value type конструкторы | `QColor(r,g,b)`, `QRect(x,y,w,h)` — не `(void* parent)` | Написать C++ wrapper вручную |
| Нестандартный конструктор | `QHeaderView(Qt::Orientation, QWidget*)` | C++ wrapper принимает `int orientation`; D: `this(int orientation, void* parent)` |
| Статические методы | `QMessageBox::information(...)` | `static` D-метод без `_wh`; C++ без `void* _obj` |
| Методы с `QDate`/`QTime` | `QDate` не в type_map | Передавать компонентами `(int y, int mo, int d)`; C++ собирает `QDate(y,mo,d)` |
| Методы с `QStringList` | UNSUPPORTED_TYPE | `\x01`-паттерн: `toQStringList` / `freeQStringList` |
| QTimer: ctor без родителя | Не QWidget, parent = null по умолчанию | Генератор делает standalone класс; дополнительных правок нет |

---

## 8. Паттерны ручных правок

### 8.1 Удаление QPrivateSignal

`QTimer::timeout(QPrivateSignal)` — Qt-internal тип, не виден снаружи. Генератор видит `QPrivateSignal` как неподдерживаемый тип и может пропустить сигнал или сгенерировать неверную сигнатуру.

Убедиться, что в `gen_qtimer.d`:
```d
void connect_timeout(ESlot eslot) {
    connectQt(_wh, "timeout()", eslot, "invoke_v()");
}
```
Сигнатура `"timeout()"` — без `QPrivateSignal`.

### 8.2 Удаление дублирующихся перегрузок

`QMessageBox` содержит и статические, и instance-методы `information`/`warning`/`critical`. Генератор создаёт оба варианта; D не допускает одноимённых static и instance методов.

Решение — оставить только статическую версию:
```d
static int information(void* parent, string title, string text, int buttons = 0) {
    auto _ws_title = toQString(title);
    auto _ws_text  = toQString(text);
    int r = (cast(t_i__qp_qp_i_qp_i)pFunQt[4802])
        (parent, _ws_title, _ws_text, buttons);
    (cast(t_v__qp)pFunQt[22])(_ws_title);
    (cast(t_v__qp)pFunQt[22])(_ws_text);
    return r;
}
```

### 8.3 Ручной value type конструктор

Пример: `QColor(int r, int g, int b)`.

C++ wrapper (`qte56_qcolor.cpp`):
```cpp
void* qteQColor_create_rgb(int r, int g, int b) {
    return new QColor(r, g, b);
}
```

`functions.csv`:
```csv
14002,qteQColor_create_rgb,QColor,qte56_qcolor.dll,lifecycle
```

`gen_qcolor.d`:
```d
mixin(generateAlias("qp__i_i_i"));   // добавить в "New aliases" секцию
// ...
mixin(generateFunQt(14002, "qteQColor_create_rgb", "QColor"));
// ...
this(int r, int g, int b) {
    _wh = (cast(t_qp__i_i_i)pFunQt[14002])(r, g, b);
}
```

### 8.4 Нестандартный конструктор QHeaderView

`QHeaderView(Qt::Orientation orientation, QWidget* parent = nullptr)`.

C++:
```cpp
void* qteQHeaderView_create(int orientation, void* parent) {
    return new QHeaderView((Qt::Orientation)orientation, (QWidget*)parent);
}
```

D (alias `qp__i_qp` нужно добавить если нет в GCORE_ALIASES):
```d
mixin(generateAlias("qp__i_qp"));
// ...
this(int orientation, void* parent = null) {
    super(true);
    _qt_owned = (parent !is null);
    _wh = (cast(t_qp__i_qp)pFunQt[9800])(orientation, parent);
}
```

Обёртка `this(void* parent)` которую генератор создаёт по умолчанию — удалить, иначе конфликт.

### 8.5 Статический метод

Пример: `static QString QApplication::applicationName()`.

C++ (нет `void* _obj`):
```cpp
void* qteQApplication_appName() {
    QString s = QCoreApplication::applicationName();
    return new QString(s);  // или через qteQString_new
}
```

D (нет `_wh`):
```d
static string appName() {
    void* _qs = (cast(t_qp__)pFunQt[54])();
    string _r = fromQString(_qs);
    (cast(t_v__qp)pFunQt[22])(_qs);
    return _r;
}
```

Alias `qp__` (функция без параметров возвращающая void*) — добавить `mixin(generateAlias("qp__"))` если нет.

### 8.6 QDate/QTime как компоненты

Генератор не знает `QDate`. Стандартный паттерн — разложить на `(int y, int mo, int d)`.

C++:
```cpp
void qteQDateEdit_setDate(void* _obj, int y, int mo, int d) {
    ((QDateEdit*)_obj)->setDate(QDate(y, mo, d));
}
void qteQDateEdit_date(void* _obj, int* y, int* mo, int* d) {
    QDate dt = ((QDateEdit*)_obj)->date();
    *y = dt.year(); *mo = dt.month(); *d = dt.day();
}
```

D (`DDate` определён в `qte56_core.d` как `struct DDate { int year, month, day; }`):
```d
DDate date() {
    DDate r;
    (cast(t_v__qp_ip_ip_ip)pFunQt[idx])(_wh, &r.year, &r.month, &r.day);
    return r;
}
void setDate(int y, int mo, int d) {
    (cast(t_v__qp_i_i_i)pFunQt[idx])(_wh, y, mo, d);
}
```

### 8.7 Метод с QStringList (паттерн \x01)

C++ принимает широкую строку с разделителем `\x01`:
```cpp
void qteQComboBox_addItems(void* _obj, const wchar_t* items, int len) {
    QString s = QString::fromWCharArray(items, len);
    QStringList lst = s.split(QChar(1), QString::SkipEmptyParts);
    ((QComboBox*)_obj)->addItems(lst);
}
```

D (использует `toQStringList` из `gen_qcore`):
```d
void addItems(string[] items) {
    import gen_qcore : toQStringList, freeQStringList;
    void* _qs = toQStringList(items);
    // передать _qs как void*, len вычислен внутри toQStringList
    (cast(t_v__qp_qp)pFunQt[idx])(_wh, _qs);
    freeQStringList(_qs);
}
```

---

## 9. Полный воркфлоу: добавить новый Qt-класс

### Шаг 1: Определить блок индексов

Таблица `pFunQt[25000]` практически заполнена (макс. занятый индекс 24713 на
2026-08-02). Свободный диапазон для нового класса выбрать из дыр нумерации:
`tools/qte/qte.exe index gaps`. Зарезервировать диапазон, например
21400–21499, и передать его генератору через `--index-start 21400`.

### Шаг 2: Определить D-родителя

По `qt_hierarchy.py::D_PARENT_FULL` или просмотру заголовка:
- `QFoo : QWidget` → `--d-parent QWidget`
- `QFoo : QFrame` → `--d-parent QFrame` (нужен `--parent-header qframe.h`)
- `QFoo : QObject` (не виджет) → нет `--d-parent`

### Шаг 3: Запустить генератор

```bash
cd arch_new/generator
py main.py C:/Qt5_13_2/.../qfoo.h \
    --module QFoo \
    --dll qte56_qfoo.dll \
    --d-parent QWidget \
    --d-out ../d/gen \
    --cpp-out ../cpp/qt5/qte56_qfoo \
    --index-start 21400
```

Если нужны методы родительского класса в DLL:
```bash
py main.py .../qfoo.h \
    --module QFoo \
    --dll qte56_qfoo.dll \
    --parent-header .../qwidget.h \
    --d-parent QWidget
```

### Шаг 4: Проверить и исправить сгенерированные файлы

`d/gen/gen_qfoo.d`:
- Если у `QFoo` нестандартный ctor — исправить вручную (паттерн 8.4).
- Убрать конфликтующие или ненужные перегрузки.
- Проверить сигналы: убрать `QPrivateSignal` из строк `connectQt`.
- Добавить отсутствующие `mixin(generateAlias(...))` если использованы нестандартные типы.

`cpp/qt5/qte56_qfoo/qte56_qfoo.h` и `.cpp`:
- Проверить корректность C++ сигнатур.
- Если конструктор нестандартный — исправить `create()`.
- Если есть value type возвраты (`QRect`, `QSize`) — проверить heap-аллокацию.

### Шаг 5: Проверить `functions.csv`

Генератор сам добавляет записи. Проверить:
```bash
grep QFoo arch_new/registry/functions.csv
```

### Шаг 6: Добавить DLL в систему сборки

- Добавить в `build_merged_dlls.bat` / `build_merged_dlls.sh`.
- Если класс входит в существующую merged DLL — добавить `.pro` в список для merge.
- Обновить `qt_hierarchy.py::GEN2_STATUS` (для документации).

### Шаг 7: Собрать DLL

```bash
# Windows: из директории cpp/qt5/qte56_qfoo/
qmake qte56_qfoo.pro && mingw32-make

# Или через batch-скрипт (обёртка над build_merged_dlls.py)
build_merged_dlls.bat
```

### Шаг 8: Написать тест

```d
import gen_qfoo;

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    auto w = new QFoo(cast(void*)null);
    w.show();
    // проверить методы
    app.exec();
    app.deleteApp();
}
```

---

## 10. Добавить функцию вручную без генератора

Используется когда:
- Генератор не справился с конкретным методом (неподдерживаемый тип).
- Нужна специальная C++ реализация (value type, QStringList, static, нестандартный ctor).
- Нужно добавить один-два метода в уже сгенерированный класс (нельзя перезапустить генератор — потеряются правки).

### Шаг 1: Выбрать индекс

Найти свободный индекс в блоке класса:
```bash
grep "^80[0-9]," arch_new/registry/functions.csv  # проверить занятые в блоке QLabel
```

### Шаг 2: Добавить запись в `functions.csv`

```csv
841,qteQLabel_myNewMethod,QLabel,qte56_widgets.dll,method
```

Вставить по порядку индексов в нужную секцию файла.

### Шаг 3: Написать C++ реализацию

В `.h`:
```cpp
QLABEL_API int qteQLabel_myNewMethod(void* _obj, int param);
```

В `.cpp`:
```cpp
int qteQLabel_myNewMethod(void* _obj, int param) {
    return ((QLabel*)_obj)->myNewMethod(param);
}
```

### Шаг 4: Добавить в `gen_qlabel.d`

В `loadQLabel()`:
```d
mixin(generateFunQt(841, "qteQLabel_myNewMethod", "QLabel"));
```

В тело класса `QLabel`:
```d
/// myNewMethod
int myNewMethod(int param) {
    return cast(int)(cast(t_i__qp_i)pFunQt[841])(_wh, param);
}
```

Если alias `i__qp_i` отсутствует в GCORE_ALIASES — добавить в секцию "New aliases":
```d
mixin(generateAlias("i__qp_i"));
```
И добавить `t_i__qp_i` в строку импорта из `gen_qcore`.

### Шаг 5: Пересобрать DLL

---

## 11. Специальные случаи сигналов

### 11.1 Стандартные ESlot сигналы

Работают через `connectQt()` — строчный Qt-connect через мета-систему Qt. ESlot хранит `void* callback` и `void* dthis`.

```d
void connect_clicked(ESlot eslot) {
    connectQt(_wh, "clicked(bool)", eslot, "invoke_b(bool)");
}
void connect_valueChanged(ESlot eslot) {
    connectQt(_wh, "valueChanged(int)", eslot, "invoke_i(int)");
}
void connect_textChanged(ESlot eslot) {
    connectQt(_wh, "textChanged(const QString&)", eslot, "invoke_s(const QString&)");
}
```

Поддерживаемые `invoke_*` методы ESlot:

| Invoke | Параметры сигнала |
|---|---|
| `invoke_v()` | 0 параметров |
| `invoke_b(bool)` | bool |
| `invoke_i(int)` | int |
| `invoke_d(double)` | double |
| `invoke_s(const QString&)` | QString |
| `invoke_p(const QPoint&)` | QPoint |
| `invoke_ii(int,int)` | два int |
| `invoke_qp(void*)` | Qt-объект как void* |

Паттерн использования:
```d
auto sl = new ESlot(btn.getWH());
extern(C) void onClick(void* dthis, bool checked) { /* ... */ }
sl.set(cast(void*)&onClick);
btn.connect_clicked(sl);
```

### 11.2 Lambda-connect (Qt-pointer сигналы)

Когда сигнал передаёт `QAction*`, `QMenu*`, `QTreeWidgetItem*` — строчный connect не работает из-за несовпадения типов в Qt мета-системе.

**Генератор создаёт отдельную C++ функцию** с лямбдой:

```cpp
// Один Qt-pointer параметр:
void qteQMenu_connect_triggered(void* w, void* cb, void* dthis) {
    QObject::connect((QMenu*)w, &QMenu::triggered,
        [cb, dthis](QAction* p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)p);
        });
}
```

D-сторона:
```d
/// cb: extern(C) void function(void* dthis, int n, void* ptr)
void connect_triggered(void* cb, void* dthis = null) {
    (cast(t_v__qp_qp_qp)pFunQt[idx])(_wh, cb, dthis);
}
```

Использование:
```d
extern(C) void onTriggered(void* dthis, int n, void* ptr) {
    auto action = QAction.wrap(ptr);
    writeln(action.text());
}
menu.connect_triggered(cast(void*)&onTriggered, null);
```

### 11.3 Value type сигналы (QFont, QColor)

`QFontDialog::fontSelected(const QFont&)` — генератор определяет как value type reference и использует lambda с heap-копией:

```cpp
void qteQFontDialog_connect_fontSelected(void* w, void* cb, void* dthis) {
    QObject::connect((QFontDialog*)w, &QFontDialog::fontSelected,
        [cb, dthis](const QFont& p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, new QFont(p));
        });
}
```

D callback получает `void*` на heap-аллоцированный `QFont*`. После использования пользователь должен освободить его через `QFont` деструктор или просто не держать долго (объект будет собран GC если обёрнут в D-класс).

### 11.4 Два Qt-pointer параметра (invoke = "lambda2")

```cpp
void qteQTreeWidget_connect_itemChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QTreeWidget*)w, &QTreeWidget::itemChanged,
        [cb, dthis](QTreeWidgetItem* p0, int p1) {
            if (cb) ((void(*)(void*,int,void*,void*))cb)(
                dthis, 0, (void*)p0, (void*)(intptr_t)p1);
        });
}
```

D-callback: `extern(C) void function(void* dthis, int n, void* p0, void* p1)`.

### 11.5 Сигналы с двумя int (invoke_ii)

Стандартный ESlot через `connectQt`:
```d
void connect_currentPageChanged(ESlot eslot) {
    connectQt(_wh, "currentPageChanged(int,int)", eslot, "invoke_ii(int,int)");
}
```

ESlot callback: `extern(C) void function(void* dthis, int a, int b)`.

---

## 12. Обновление существующего класса: добавить методы

### Почему нельзя просто перезапустить генератор

Генератор перезапишет `gen_qXxx.d` и потеряет все ручные правки.

**Правильный подход**:
1. `--info` — посмотреть что генератор сделал бы.
2. Вручную добавить CSV-записи.
3. Вручную написать C++ функции в `.cpp`.
4. Вручную добавить `mixin(generateFunQt(...))` в `loadQXxx()` и метод в тело класса.

### Пример: добавить `QLabel::setNum(double)` если отсутствует

1. CSV:
   ```csv
   828,qteQLabel_setNum_d,QLabel,qte56_widgets.dll,method
   ```

2. `gen_qlabel.d`, в `loadQLabel()`:
   ```d
   mixin(generateFunQt(828, "qteQLabel_setNum_d", "QLabel"));
   ```

3. Тело класса `QLabel`:
   ```d
   /// setNum
   void setNum(double p0) {
       (cast(t_v__qp_d)pFunQt[828])(_wh, p0);
   }
   ```
   Alias `v__qp_d` — добавить `mixin(generateAlias("v__qp_d"))` если ещё нет.

4. C++ `.h` и `.cpp`:
   ```cpp
   QLABEL_API void qteQLabel_setNum_d(void* _obj, double p0);
   // ...
   void qteQLabel_setNum_d(void* _obj, double p0) {
       ((QLabel*)_obj)->setNum(p0);
   }
   ```

---

## 13. Стратегия выделения индексных блоков

### Текущие блоки

```
QCore:              1–71        (зарезервирован, не трогать)
QWidget:            200–398
QPushButton:        400–419
QLayout:            600–628
QLabel:             800–840
QLineEdit:          1000–1072
QCheckBox:          1200–1212
QComboBox:          1400–1460
QRadioButton:       1600–1630
QSpinBox:           1800–1855
QSlider:            2000–2036
QProgressBar:       2200–2229
QGroupBox:          2400–2417
QTabWidget:         2600–2649
QFrame:             2800–2819
QAbstractButton:    3000–3029
QAbstractSlider:    3200–3229
QAbstractSpinBox:   3400–3437
QObject:            3600–3608
QAction:            3800–3831
QMenu:              4000–4049
QMenuBar:           4200–4228
QTimer:             4400–4411
QDialog:            4600–4612
QMessageBox:        4800–4818
QPlainTextEdit:     5000–5073
QScrollBar:         5200–5207
QDial:              5400–5410
QStatusBar:         5600–5615
QLCDNumber:         5800–5825
QProgressDialog:    6000–6029
QMainWindow:        6200–6252
QToolBar:           6400–6433
QIcon:              6600–6611
QFileDialog:        6800–6846
QListWidget:        7000–7041
QSettings:          7200–7220
QAbstractScrollArea:7400–7424
QMdiArea:           7600–7650
QMdiSubWindow:      7800–7823
QTextEdit:          8000–8090
QSplitter:          8200–8240
QStackedWidget:     8400–8429
QDoubleSpinBox:     8600–8657
QAbstractItemView:  8800–8877
QTableView:         9000–9046
QTableWidget:       9200–9262
QTreeView:          9400–9448
QTreeWidget:        9600–9680
QHeaderView:        9800–9868
QScrollArea:        10000–10016
QFont:              10200–10259
QToolButton:        10400–10445
QCommandLinkButton: 10600–10611
QDockWidget:        10800–10816
QToolBox:           11000–11025
QTextBrowser:       11200–11250
QFontDialog:        12000–12017
QColorDialog:       13000–13021
QColor:             14000–14081
QInputDialog:       15000–15062
QTabBar:            16000–16057
QDateTimeEdit:      17000–17046
QDateEdit:          17100–17106
QTimeEdit:          17200–17206
QCalendarWidget:    17300–17338
QClipboard:         17400–17408
QButtonGroup:       17500–17510
QPixmap:            17600–17613
QPainter:           18000–18199
QImage:             18200+
QImageReader:       18300+
QImageWriter:       18350+
QPicture:           18400+
QFile:              18500+
QTextDocument:      19000+
QSql:               19100–19132
QTextCursor:        19200–19235
QTextCharFormat:    19300–19324
QTextBlockFormat:   19400–19419
QTextBlock:         19500–19514
QSyntaxHighlighter: 19600–19612
QScintilla:         19700–19747
QPen:               19748–19760
QBrush:             19761–19767
QPalette:           19768–19775
QFontMetrics:       19776–19785
QPainter_ext:       19786–19787
QSplashScreen:      19788–19796
QSystemTrayIcon:    19797–19809
QResource:          19810–19811
QUiLoader:          19812–19815
QProcess:           19816–19836
QStringList_ext:    19837–19841
Tvision:            19850–19884
QDate/QTime/QDateTime:  19885–19968
QByteArray:         19969–19998
QImage_memio:       19999–20000
QPixmap_memio:      20001–20002
QScintilla_ext:     20003–20004
QNetwork:           20005–20045
QCurl:              20046–20072
QThread/QMutex:     20073–20095
QWaitCond/Semaphore/RWLock: 20096–20117
QCompleter:         20118–20131
QShortcut:          20132–20138
QFileSystemWatcher: 20139–20148
QDesktopWidget:     20149–20154
QShortcut augment:  20163–20168   (context, whatsThis, autoRepeat, id, ...)
QPainter augment:   18102–18245   (перегрузки с QPoint/QPointF/QRect/QRectF)
QPointF:            21800–21808
QRectF:             21900–21948
СЛЕДУЮЩИЙ СВОБОДНЫЙ: нет (pFunQt[25000] заполнен, макс. индекс 24713 на
2026-08-02) — использовать дыры: `tools/qte/qte.exe index gaps`
```

### Правила выбора нового блока

1. Проверить реальный максимум: `grep -v "^#" functions.csv | sort -t, -k1 -n | tail -5`.
2. Для нового крупного класса (>20 методов): взять следующий кратный 100 от текущего максимума.
3. Для небольшого добавления к существующему классу: найти свободные индексы внутри его текущего блока — дыры есть в каждом блоке.
4. Для совершенно нового независимого класса: взять свободный диапазон из дыр
   (`tools/qte/qte.exe index gaps`) и передать через `--index-start`.
5. Внутри блока индексы НЕ обязательно последовательны — дыры исторически допустимы.
6. `registry.py::assign_block()` автоматически округляет вверх до `BLOCK_SIZE=1000`, но фактически лучше назначать вручную — реальные блоки гораздо меньше 1000.
7. `PFUNQT_SIZE = 25000` — абсолютный лимит, таблица практически заполнена
   (макс. занятый индекс 24713 на 2026-08-02); свободные места — только дыры.

---

## 14. Полный пример: добавить QCalendarWidget с нуля

Это ретроспективное описание реального процесса — `gen_qcalendarwidget.d` уже существует в `d/gen/`.

### 14.1 Исходные условия

- `QCalendarWidget : QWidget` (прямое наследование).
- Сигналы: `selectionChanged()`, `clicked(const QDate&)`, `activated(const QDate&)`, `currentPageChanged(int, int)`.
- `QDate` — неподдерживаемый тип генератором, нужно разложить на `(int year, int month, int day)`.
- `QTextCharFormat` в заголовке — тоже неподдерживаемый; методы с ним пропустить.
- Свободный блок: 17300.

### 14.2 Запуск генератора (начальная попытка)

```bash
py main.py C:/Qt5_13_2/.../qcalendarwidget.h \
    --module QCalendarWidget \
    --dll qte56_qcalendarwidget.dll \
    --d-parent QWidget \
    --d-out ../d/gen
```

Генератор создаёт скелет, но:
- Сигналы `clicked`/`activated` с `QDate` пропускаются или генерируются неверно.
- Методы с `QTextCharFormat` пропускаются.
- Методы c `QDate` параметрами (setSelectedDate, setMinimumDate...) пропускаются.

### 14.3 Выбор индексов

Назначить вручную 17300–17338:
- 17300: `create`, 17301: `destroy`
- 17302: `selectedDate` (out-параметры), 17303: `setSelectedDate` (3 int)
- 17304–17305: `yearShown`, `monthShown`
- 17306–17309: `minimumDate`, `setMinimumDate`, `maximumDate`, `setMaximumDate`
- 17310–17325: остальные методы
- 17326: `setDateRange` (6 int)
- 17327–17333: навигационные слоты
- 17334: `setEventHandler`
- 17335–17338: connect-функции сигналов

### 14.4 C++ wrapper: ключевые решения

```cpp
// QDate → out-параметры
void qteQCalendarWidget_selectedDate(void* _obj, int* y, int* mo, int* d) {
    QDate dt = ((QCalendarWidget*)_obj)->selectedDate();
    *y = dt.year(); *mo = dt.month(); *d = dt.day();
}

// setSelectedDate → принимает компоненты
void qteQCalendarWidget_setSelectedDate(void* _obj, int y, int mo, int d) {
    ((QCalendarWidget*)_obj)->setSelectedDate(QDate(y, mo, d));
}

// setDateRange → 6 int параметров
void qteQCalendarWidget_setDateRange(void* _obj,
    int y1, int mo1, int d1, int y2, int mo2, int d2) {
    ((QCalendarWidget*)_obj)->setDateRange(QDate(y1,mo1,d1), QDate(y2,mo2,d2));
}

// Signal clicked: QDate → (dthis, year, month, day, reserved)
// Сигнал передаёт QDate, но C++ раскладывает его в int-компоненты для D
void qteQCalendarWidget_connect_clicked(void* w, void* cb, void* dthis) {
    QObject::connect((QCalendarWidget*)w, &QCalendarWidget::clicked,
        [cb, dthis](const QDate& dt) {
            if (cb) ((void(*)(void*,int,int,int,int))cb)(
                dthis, dt.year(), dt.month(), dt.day(), 0);
        });
}

// Signal selectionChanged: нет параметров
void qteQCalendarWidget_connect_selectionChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QCalendarWidget*)w, &QCalendarWidget::selectionChanged,
        [cb, dthis]() {
            if (cb) ((void(*)(void*))cb)(dthis);
        });
}

// Signal currentPageChanged: int year, int month
void qteQCalendarWidget_connect_currentPageChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QCalendarWidget*)w, &QCalendarWidget::currentPageChanged,
        [cb, dthis](int year, int month) {
            if (cb) ((void(*)(void*,int,int))cb)(dthis, year, month);
        });
}
```

### 14.5 `gen_qcalendarwidget.d`: ключевые решения

Импорты — нужны нестандартные aliases:
```d
import gen_qcore : t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i,
    t_v__qp_i_i_i, t_v__qp_i_i_i_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp,
    t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp;
import gen_qwidget : QWidget;
```

Метод `selectedDate`:
```d
DDate selectedDate() {
    DDate r;
    (cast(t_v__qp_ip_ip_ip)pFunQt[17302])(_wh, &r.year, &r.month, &r.day);
    return r;
}
void setSelectedDate(int y, int mo, int d) {
    (cast(t_v__qp_i_i_i)pFunQt[17303])(_wh, y, mo, d);
}
void setSelectedDate(DDate dt) { setSelectedDate(dt.year, dt.month, dt.day); }
```

Метод `setDateRange` (нужен alias `v__qp_i_i_i_i_i_i` — добавить через generateAlias):
```d
void setDateRange(int y1, int mo1, int d1, int y2, int mo2, int d2) {
    (cast(t_v__qp_i_i_i_i_i_i)pFunQt[17326])(_wh, y1, mo1, d1, y2, mo2, d2);
}
```

Сигналы — все через `t_v__qp_qp_qp` (lambda-connect паттерн):
```d
/// selectionChanged — не несёт данных
/// extern(C) void cb(void* dthis)
void connect_selectionChanged(void* cb, void* dthis = null) {
    (cast(t_v__qp_qp_qp)pFunQt[17335])(_wh, cb, dthis);
}

/// clicked / activated — дата клика
/// extern(C) void cb(void* dthis, int year, int month, int day, int reserved)
void connect_clicked(void* cb, void* dthis = null) {
    (cast(t_v__qp_qp_qp)pFunQt[17336])(_wh, cb, dthis);
}
void connect_activated(void* cb, void* dthis = null) {
    (cast(t_v__qp_qp_qp)pFunQt[17337])(_wh, cb, dthis);
}

/// currentPageChanged — год и месяц текущей страницы
/// extern(C) void cb(void* dthis, int year, int month)
void connect_currentPageChanged(void* cb, void* dthis = null) {
    (cast(t_v__qp_qp_qp)pFunQt[17338])(_wh, cb, dthis);
}
```

Класс не использует ESlot для сигналов — они нестандартные (QDate, два int). Прямые callback-паттерны вместо ESlot.

### 14.6 Добавить в сборку и тест

```bash
# Добавить qte56_qcalendarwidget.pro в build_merged_dlls.bat (к группе widgets)
# Собрать:
build_merged_dlls.bat

# Тест:
dmd -m32 -i test_qcalendarwidget.d -I../d -of test_qcalendarwidget.exe
test_qcalendarwidget.exe
```

Тест:
```d
import gen_qcalendarwidget;
import std.stdio;

extern(C) void onClicked(void* dthis, int y, int mo, int d, int reserved) {
    writeln("clicked: ", y, "-", mo, "-", d);
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication(cast(void*)null);
    auto cal = new QCalendarWidget(cast(void*)null);
    cal.setWindowTitle("Test Calendar");
    cal.show();
    auto date = cal.selectedDate();
    writeln("initial date: ", date.year, "-", date.month, "-", date.day);
    cal.connect_clicked(cast(void*)&onClicked, null);
    app.exec();
    app.deleteApp();
}
```

---

## Приложение A: GCORE_ALIASES — полный список

Эти alias-типы уже определены в `gen_qcore.d` и импортируются — **не** нужно добавлять `generateAlias`:

```
qp__i              = void* function(int)
v__qp_i            = void function(void*, int)
b__qp_i            = int  function(void*, int)
qp__qp_qp          = void* function(void*, void*)
v__qp_qp_qp_i      = void function(void*, void*, void*, int)
qp__qp_i           = void* function(void*, int)
i__qp_qp_i         = int  function(void*, void*, int)
v__qp              = void function(void*)
qp__i_i_i_i        = void* function(int, int, int, int)
v__qp_ip_ip_ip_ip  = void function(void*, int*, int*, int*, int*)
qp__i_i            = void* function(int, int)
v__qp_ip_ip        = void function(void*, int*, int*)
qp__qp             = void* function(void*)
i__qp              = int  function(void*)
v__qp_qp_i         = void function(void*, void*, int)
v__qp_i_qp_qp      = void function(void*, int, void*, void*)  <- setEventHandler
v__qp_qp_qp        = void function(void*, void*, void*)        <- lambda-connect
```

Для генератора эти ключи хранятся в `d_generator.py::GCORE_ALIASES`.

---

## Приложение B: D-иерархия классов (Variant 3 — полная)

| Qt иерархия | D наследование |
|---|---|
| `QLabel : QFrame : QWidget` | `class QLabel : QFrame` |
| `QPushButton : QAbstractButton : QWidget` | `class QPushButton : QAbstractButton` |
| `QCheckBox : QAbstractButton : QWidget` | `class QCheckBox : QAbstractButton` |
| `QRadioButton : QAbstractButton : QWidget` | `class QRadioButton : QAbstractButton` |
| `QCommandLinkButton : QPushButton : QAbstractButton` | `class QCommandLinkButton : QPushButton` |
| `QSlider : QAbstractSlider : QWidget` | `class QSlider : QAbstractSlider` |
| `QDial : QAbstractSlider : QWidget` | `class QDial : QAbstractSlider` |
| `QScrollBar : QAbstractSlider : QWidget` | `class QScrollBar : QAbstractSlider` |
| `QSpinBox : QAbstractSpinBox : QWidget` | `class QSpinBox : QAbstractSpinBox` |
| `QDoubleSpinBox : QAbstractSpinBox : QWidget` | `class QDoubleSpinBox : QAbstractSpinBox` |
| `QDateTimeEdit : QAbstractSpinBox : QWidget` | `class QDateTimeEdit : QAbstractSpinBox` |
| `QDateEdit : QDateTimeEdit : QAbstractSpinBox` | `class QDateEdit : QDateTimeEdit` |
| `QTimeEdit : QDateTimeEdit : QAbstractSpinBox` | `class QTimeEdit : QDateTimeEdit` |
| `QTextEdit : QAbstractScrollArea : QFrame` | `class QTextEdit : QAbstractScrollArea` |
| `QPlainTextEdit : QAbstractScrollArea : QFrame` | `class QPlainTextEdit : QAbstractScrollArea` |
| `QTextBrowser : QTextEdit : QAbstractScrollArea` | `class QTextBrowser : QTextEdit` |
| `QListWidget : QAbstractItemView : QAbstractScrollArea : QFrame` | `class QListWidget : QAbstractItemView` |
| `QTableWidget : QTableView : QAbstractItemView` | `class QTableWidget : QTableView` |
| `QTreeWidget : QTreeView : QAbstractItemView` | `class QTreeWidget : QTreeView` |
| `QFileDialog : QDialog : QWidget` | `class QFileDialog : QDialog` |
| `QCalendarWidget : QWidget` | `class QCalendarWidget : QWidget` |
| `QTimer : QObject` | `class QTimer` (standalone, нет D-родителя) |
| `QColor` (value type) | `class QColor` (standalone) |
| `QFont` (value type) | `class QFont` (standalone) |

**Поля `_wh` и `_qt_owned`** объявлены только в корневых D-классах (где нет `d_parent`). Дочерние классы наследуют их автоматически.

**Конструкторы дочернего класса** (шаблон):
```d
// Основной ctor
this(void* parent) {
    super(true);                        // вызвать no-op ctor родителя
    _qt_owned = (parent !is null);
    _wh = (cast(t_qp__qp)pFunQt[ctor_idx])(parent);
}

// No-op ctor для вызовов super() из внуков
protected this(bool _noOp) { super(_noOp); }

// static wrap() для Qt-owned объектов
static QFoo wrap(void* wh) {
    auto w = new QFoo(true);
    w._wh = wh;
    w._qt_owned = true;
    return w;
}
```

**Конструкторы корневого класса** (шаблон):
```d
private:
    void* _wh;
    bool  _qt_owned;
public:
    this(void* parent = null) {
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[ctor_idx])(parent);
    }
    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[dtor_idx] !is null) {
            (cast(t_v__qp)pFunQt[dtor_idx])(_wh);
            _wh = null;
        }
    }
    void disown()  { _qt_owned = true; }
    bool qtOwned() { return _qt_owned; }
    void* getWH()  { return _wh; }
```

---

## Приложение C: Критические gotchas

1. **`static this()` vs `shared static this()`**: генератор использует `static this()`. Ручные файлы иногда используют `shared static this()`. Оба работают, но `static this()` предпочтителен — он не требует `shared` и работает в DMD/LDC одинаково.

2. **`super(true)` в дочерних классах**: при `d_parent != ""` генератор вызывает `super(true)` в конструкторе — это вызывает no-op ctor родителя, не создавая дублирующий Qt-объект.

3. **`_qt_owned` и `disown()`**: после `layout.addWidget(w)` или `setLayout(layout)` Qt берёт ownership. В типизированном API (`addWidget(QObject)`, `setLayout(L)(layout)`, `addLayout(L)(...)`, `setCentralWidget(QObject)`, `addTab(QObject,str)`, `setWidget(QObject)`) `disown()` вызывается **автоматически** — вручную вызывать не нужно. При использовании void* API (`addWidget(w.getWH())`) `disown()` всё ещё требуется вручную. Тест: `test/test_auto_disown.d`.

4. **`pFunQt[22]`**: индекс 22 — `qteQString_delete` (удаление временной QString). Вызывается после `fromQString` и после передачи `toQString` результата в Qt.

5. **`cast(void*)null` vs `null`**: при вызове конструктора с перегрузками `this(void*)` и `this(string, void* parent=null)` надо явно передавать `cast(void*)null` чтобы D выбрал правильную перегрузку.

6. **`LoadQt()` BEFORE `new QApplication()`**: порядок строго обязателен — сначала загрузить DLL, потом создавать объекты.

7. **Сигналы: set value BEFORE connect**: при использовании ESlot устанавливать значение/callback в слот до подключения сигнала.

8. **`app.exec(); app.deleteApp()`**: НЕ вызывать `UnloadQt()` — OS освободит DLL при завершении процесса.

9. **Имя модуля в `generateFunQt` — одно на файл**: если один `.d` файл загружает функции для нескольких классов (например, `gen_qdate.d` — QDate + QTime + QDateTime), **все** `generateFunQt` должны использовать **одно** зарегистрированное имя модуля (напр. `"QDate"`). Иначе `loadFn()` вернёт `null` → crash.
   ```d
   // ПРАВИЛЬНО: все три класса — одно имя "QDate"
   mixin(generateFunQt(19885, "qteQDate_create",    "QDate"));
   mixin(generateFunQt(19912, "qteQTime_create",    "QDate"));  // не "QTime"!
   mixin(generateFunQt(19934, "qteQDateTime_create","QDate"));  // не "QDateTime"!
   ```

10. **`__declspec(dllexport)` обязателен**: `extern "C"` одного без `XFOO_API` макроса недостаточно для MinGW DLL на Windows — символ не экспортируется. Используй `#define QTEFOO_API extern "C" __declspec(dllexport)`.

11. **fromQString — размер буфера**: `gen_qcore.d` использует динамически удваиваемый буфер (начиная с 4096). Не заменять на `wchar[4096]` — файлы > 4095 символов будут обрезаны → "Error at end of file" в Wren.

12. **GC.collect() перед deleteApp()**: если используются `QThread.connect_started/finished` (QueuedConnection), вызвать `GC.collect()` перед `app.deleteApp()` чтобы избежать GC-финализации после уничтожения QApplication.

---

## §15. Модернизация генератора (2026-07-25): база знаний Qt + harness

### 15.1 База знаний Qt

`generator/qt_knowledge.py` сканирует ВСЕ заголовки Qt (QtCore/QtGui/QtWidgets/QtNetwork/QtSql/QtMultimedia... — 1348 .h за ~2 с, multiprocessing) и строит `generator/knowledge/qt_knowledge.json`:

- 2074 класса: родители, заголовок, Qt-модуль, шаблонность;
- 1248 enum'ов (qualified + unqualified→qualified, включая Q_FLAGS);
- 1397 value-типов (не QObject-наследники, транзитивное замыкание);
- QObject/QWidget-наследники (транзитивно), частоты типов параметров.

Проверка: `python qt_knowledge.py --selftest` (13 проверок PASS).

Особенности Qt-заголовков, учтённые в сканере:
- `qnamespace.h`: `namespace Qt` разорван `#ifndef Q_MOC_RUN` — нужен спец-regex, иначе все `Qt::X` теряются;
- value-классы (QPoint, QStringList) объявлены БЕЗ export-макроса — ловить нельзя только по `Q_*_EXPORT`;
- template-классы определяются по `template <` в начале совпадения;
- 119 неоднозначных unqualified enum-имён (`Type` → 27 владельцев) — генератор берёт qualified-форму только при однозначном резолве, иначе старое поведение `({cls}::{type})`.

### 15.2 Подключение к генератору (knowledge_access.py)

`get_knowledge()` — ленивый singleton, None если JSON нет/битый (генератор падает обратно на эвристики, НЕ падает вообще). Подключено:

- `cpp_generator._is_qt_enum` / `_is_value_by_ref` — точные проверки вместо CamelCase-эвристики и белого списка из 5 типов;
- `cpp_generator._cpp_call_args` — enum чужого класса квалифицируется правильно (`kb.resolve_enum`, однозначный случай); раньше слепо `({cls_name}::{t})` — нерабочий C++;
- `d_generator._is_qt_enum`, `qt_parser._check_method_supported` — аналогично;
- `main._is_qwidget_subclass` — транзитивное замыкание вместо хардкод-множества;
- D-родитель: `--d-parent` → `D_PARENT_FULL` → knowledge.parents[cls][0].

### 15.3 Современный вывод для новых классов

Сгенерированный код теперь сразу включает (волны постобработки не нужны):
- C++: `qte_createTracked(new eQFoo(...))` + `#include "../qte56_qobject/qte56_lifecycle.h"` для QObject-наследников (точно по knowledge, fallback — has_events);
- `.pro`: выбор `dll32/dll64` по `QTE56_ARCH` (шаблон qte56_qslider.pro), `LIBS += -lqte56_foundation` при lifecycle;
- D: `@live class`, `super(true)`, `protected this(bool _noOp)`, `static wrap(void*)`, chaining, маркеры `AUTO-GENERATED-*`/`MANUAL-METHODS-*`.

### 15.4 Переполнение pFunQt и --index-start

Макс. индекс в реестре 24713 → следующий блок по округлению = 25000 = PFUNQT_SIZE → раньше генерировался некомпилируемый D-код. Теперь `Registry.add_entry` бросает ValueError с подсказкой. Размещение новых классов — в дыры нумерации:

```bash
tools/qte/qte.exe index gaps        # свободные диапазоны
py main.py qfoo.h --index-start 21400 ...
```

### 15.5 Harness: test_new_class.py

`python test_new_class.py <header.h> [--index-start N] [--keep]` — полный цикл на КОПИИ реестра (настоящий functions.csv не меняется): генерация → `g++ -fsyntax-only` (Qt include + копия qte56_lifecycle.h) → `dmd -m32 -i -c` с `-Id -Id/gen` реального проекта (проверка совместимости с существующими gen-модулями). PASS/FAIL по шагам. Проверено на QFontComboBox и QKeySequenceEdit: полный PASS.

### 15.6 type_map (2026-07)

Добавлены opaque void*: `QPixmap`, `QImage`, `QStringList` (+ toQStringList/freeQStringList на D-стороне), `QUrl`. QVariant/QModelIndex/QByteArray остаются UNSUPPORTED — нет простого ABI-паттерна (по type_freq это самые массовые пробелы: QModelIndex 393, QByteArray 293, QVariant 203 вхождения — кандидаты на ручные паттерны в будущем).

### 15.7 GENERATOR-INFO: рабочая информация в генерируемых файлах

Каждый запуск main.py встраивает во ВСЕ выходные файлы (.h, .cpp, .pro, .d) блок
`// ===GENERATOR-INFO-START===` / `END` (в .pro — `#`-комментарии):

- `command` — полная командная строка (точное воспроизведение запуска);
- `header`, `qt` — исходный заголовок и версия Qt;
- `module`, `dll`, `d-parent` (+ источник: cli / qt_hierarchy.D_PARENT_FULL / knowledge);
- `index-block` (auto или --index-start), `index-range`;
- `knowledge` — mtime qt_knowledge.json или "NONE (fallback heuristics)";
- `methods` — счётчики wrapper/signal/lifecycle;
- `skipped-unsupported` — пропущенные методы/сигналы С ПРИЧИНОЙ
  (`param type 'const QModelIndex&'` и т.п.) — готовая очередь задач для type_map.
  Причины заполняет `QtMethod.unsupported_reason` в qt_parser._check_method_supported.

В D-файле блок стоит ВНЕ маркеров AUTO-GENERATED — при `--patch` сохраняется
информация о последней полной генерации (осознанное решение).

---

## Навигация

- ↑ [AGENTS.md](AGENTS.md) — точка входа
- ↓ Подробнее:
  - [generator/work_geterator.md](generator/work_geterator.md) — пайплайн и сценарии генератора
  - [DYNAMIC_SKIP_METHODS_ARCHITECTURE.md](DYNAMIC_SKIP_METHODS_ARCHITECTURE.md) — архитектура skip-методов
  - [generator/make_build_guide.md](generator/make_build_guide.md) — утилита make_build.py
