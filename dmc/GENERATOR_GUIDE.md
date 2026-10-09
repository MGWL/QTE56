# DMC C++ Generator для QTE56

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

## Назначение

Генератор автоматически создаёт C++ обёртки для DMC (Digital Mars C++) компилятора из D-модулей QTE56. Это позволяет использовать Qt 5.13.2 в проектах на C++ через DMC, минуя необходимость ручного написания ~106 модулей обёрток.

## Зачем нужен

- **QTE56** — биндинги Qt для языка D (через C++ DLL-обёртки)
- **DMC** — старый C++ компилятор (Digital Mars C++ 8.42n), не поддерживающий современный C++11/14/17
- **Проблема**: DMC не может напрямую компилировать Qt headers (современный C++), нужны обёртки
- **Решение**: Автогенерация C++ обёрток из уже существующих D-модулей QTE56

## Архитектура генератора

```
D module (gen_q*.d) → Parser → ModuleInfo → HeaderGenerator → .h file
                                          → CppGenerator   → .cpp file
```

### Компоненты

| Файл | Назначение |
|------|-----------|
| `main.py` | Точка входа, обработка аргументов |
| `dmodule_parser.py` | Парсинг D-модулей (классы, методы, конструкторы, pFunQt индексы) |
| `type_mapper.py` | Маппинг D-типов → C++ типы (string→const char*, bool→int, etc.) |
| `header_generator.py` | Генерация .h файлов (declarations) |
| `cpp_generator.py` | Генерация .cpp файлов (implementations) |
| `registry_loader.py` | Загрузка registry/functions.csv (индексы pFunQt) |

## Использование

### Генерация одного модуля

```bash
cd H:/qte56/arch_new/dmc/generator
python main.py H:/qte56/arch_new/d/gen/gen_qpushbutton.d --output-dir H:/qte56/arch_new/dmc/gen
```

### Генерация всех модулей

```bash
cd H:/qte56/arch_new/dmc/generator
python main.py --all --output-dir H:/qte56/arch_new/dmc/gen --registry H:/qte56/arch_new/registry/functions.csv --d-gen-dir H:/qte56/arch_new/d/gen
```

## Основные проблемы и решения

### 1. Парсинг D-специфичных конструкций

D-модули содержат конструкции, неподдерживаемые в C++:

| D-конструкция | Проблема | Решение |
|--------------|----------|---------|
| `opOpAssign`, `opIndexAssign` | D-операторы | Пропуск в парсере |
| `static assert(...)` | Парсится как метод | Фильтр `method_name == 'assert'` |
| `ubyte`, `auto`, `dchar` | Неподдерживаемые типы | Фильтр в `_parse_params` |
| `delegate`, `out`, `scope` | D-специфичные модификаторы | Пропуск в `_parse_params` |
| `const(ubyte)` | Сложный синтаксис | Пропуск в `_parse_params` |
| `string[]`, `int[]` | D-массивы | Пропуск (символ `[` в параметре) |
| `private this(...)` | Приватные конструкторы | Пропуск в парсере |
| `this(bool _dummy)` | Фиктивные конструкторы | Пропуск в парсере |

### 2. Маппинг типов

| D-тип | C++ тип | Примечание |
|-------|---------|-----------|
| `string` | `const char*` | Конвертация через `toQString()`/`freeQString()` |
| `bool` | `bool` | В параметрах передаётся как `int` (1/0) |
| `uint` | `unsigned int` | |
| `void*` | `void*` | Qt object handle |
| `ShortcutContext` | `int` | D enum → int |
| `HighlightCb` | `void*` | Function pointer alias |
| `DSize`/`DPoint`/`DRect` | `DSize`/`DPoint`/`DRect` | Struct (value types) |

### 3. String-методы

**String getters** (без параметров, возвращают `string`):
```cpp
int text(char* buf, int bufLen) const;  // Возвращает длину строки
```

**String setters** (с `string` параметром, возвращают `void`):
```cpp
void setText(const char* text);  // Конвертирует в QString, вызывает DLL, освобождает
```

**String getters с параметрами** (например, `toString(fmt)`):
```cpp
const char* toString(const char* fmt);  // Возвращает malloc-allocated буфер
```

### 4. Конструкторы и pFunQt индексы

Каждый класс имеет один или несколько конструкторов. Генератор должен выбрать правильный `pFunQt` индекс:

| Конструктор | Индекс | Функция DLL |
|------------|--------|------------|
| `QSettings(string org, string app, void* parent)` | 7200 | `qteQSettings_create_app` |
| `QSettings(string filename, int format, void* parent)` | 7201 | `qteQSettings_create_file` |

**Проблема**: `_find_create_index` должен выбирать индекс на основе параметров конструктора (наличие `string`, `int`, `filename`).

**Решение**: Анализ параметров конструктора → поиск функции с соответствующим суффиксом (`_app`, `_file`, `_text`).

### 5. Explicit cast (DMC специфика)

DMC требует явного приведения типов:

```cpp
// Ошибка: implicit cast from int to void*
void* p = some_int;  // ❌

// Правильно:
void* p = (void*)some_int;  // ✓
```

**Проблема**: `string`-возвращающие методы с `int`-параметрами (например, `QClipboard::text(int mode)`) — функция DLL возвращает `int` (длина буфера), но код ожидает `void*` (QString). Нужен `(void*)` cast.

**Решение**: В `_generate_string_param_getter_impl` добавлен `(void*)` перед вызовом функции.

### 6. Connect-методы

```cpp
void connect_clicked(ESlot* eslot);  // В .h файле
void connect_clicked(ESlot* eslot) {  // В .cpp файле
    connectQt(_wh, "clicked()", eslot, "invoke_b()");
}
```

**Проблема**: `connect_*` методы должны быть объявлены с `ESlot*` параметром, а не `void* cb, void* dthis`.

**Решение**: Специальная обработка в `_generate_method_decl` для `method.name.startswith('connect_')`.

### 7. Typedefs

Каждая функция DLL имеет свой typedef:

```cpp
typedef void  (*t_v__qp)(void*);           // void func(void* _wh)
typedef void  (*t_v__qp_i)(void*, int);  // void func(void* _wh, int)
typedef void* (*t_qp__qp)(void*);        // void* func(void* _wh)
```

**Проблема**: Новые комбинации параметров требуют новых typedefs.

**Решение**: Добавление typedefs в `qte5dmc_core.h` по мере необходимости. Генератор строит имя typedef автоматически из сигнатуры.

### 8. Кэширование Python

**Проблема**: После изменения генератора `.pyc` файлы могут быть устаревшими.

**Решение**: Всегда удалять `__pycache__` перед перегенерацией:
```bash
rm -rf __pycache__ && python main.py --all ...
```

## Проверка компиляции

```bash
cd H:/qte56/arch_new/dmc/gen
bash compile_all.sh
```

Скрипт `compile_all.sh` компилирует каждый `.cpp` файл с помощью DMC:
```bash
dmc -c -I.. gen_q*.cpp
```

## Результат

- **106 модулей** сгенерированы
- **0 ошибок** компиляции
- Все модули готовы к линковке с `qte5dmc_loader.cpp` и `qte5dmc_core.h`

## Файлы проекта

| Путь | Назначение |
|------|-----------|
| `H:/qte56/arch_new/dmc/generator/` | Исходники генератора (Python) |
| `H:/qte56/arch_new/dmc/gen/` | Сгенерированные .h и .cpp файлы |
| `H:/qte56/arch_new/dmc/qte5dmc_core.h` | Базовые типы и typedefs |
| `H:/qte56/arch_new/dmc/qte5dmc_loader.h` | Загрузчик DLL |
| `H:/qte56/arch_new/d/gen/gen_q*.d` | Исходные D-модули QTE56 |
| `H:/qte56/arch_new/registry/functions.csv` | Реестр pFunQt индексов |
