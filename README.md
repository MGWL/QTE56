# QTE56 — новая архитектура (arch_new)

## 🤖 Для AI моделей: с чего начать?

**Читай первым:** [`AI_LOADING_ORDER.md`](AI_LOADING_ORDER.md) — порядок загрузки документации для эффективного создания QTE56 приложений.

**Критическое правило:** [`LIVE_QUICKSTART.md`](LIVE_QUICKSTART.md) — `@live` атрибут (Правило 5: только для локальных переменных, НЕ для полей класса).

## Структура

```
arch_new/
├── registry/
│   └── functions.csv          ← единственный источник истины об индексах
├── cpp/
│   └── qt5/
│       └── qte56_qcore/
│           ├── eslot.h            ← class eSlot : QObject
│           ├── qte56_qcore.h      ← экспортируемые extern "C" функции
│           ├── qte56_qcore.cpp    ← реализация
│           └── qte56_qcore.pro    ← Qt build файл
├── d/
│   ├── qte56_core.d           ← pFunQt[], generateAlias, generateFunQt
│   ├── qte56_loader.d         ← LoadQt(dir), UnloadQt(), loadFn()
│   └── gen/
│       └── gen_qcore.d        ← GENERATED: алиасы + loadQCore() + class QApplication
├── example/
│   └── console_app.d          ← минимальный пример
├── generator/
│   ├── registry.py            ← работа с functions.csv
│   ├── type_map.py            ← маппинг C++ → D типов
│   ├── qt_parser.py           ← парсер Qt .h заголовков
│   ├── d_generator.py         ← генерация .d файлов
│   └── main.py                ← точка входа генератора
└── qte56.ini                  ← конфигурация пользователя
```

## Ключевые принципы

### 1. functions.csv — реестр
- Индекс функции **никогда не меняется** после присвоения
- Блоки индексов разного размера, дыры допустимы
- Актуальную карту индексов: `tools/qte/qte.exe index list` / `index gaps`

### 2. Поток загрузки
```
import gen_qcore
  → static this() → registerModule("QCore", "qte56_qcore.dll", &loadQCore)

LoadQt("./dll")   // или LoadQt() — путь из переменной QTE56_ARCH
  → LoadLibrary(dll) для каждого зарегистрированного модуля
  → pFunQt[index] = GetProcAddress(dll, func_name)  для каждой строки CSV
```

### 3. Mixin-система
- `generateAlias("v__qp_i")` → compile-time alias тип функции
- `generateFunQt(50, "qteQApplication_create", "QCore")` → `pFunQt[50] = loadFn(...)`
- Если DLL не загружена — `pFunQt[N] = null` (crash при вызове — намеренно)

## Минимальное приложение

```d
import qte56_core, qte56_loader, gen_qcore;

void main() {
    LoadQt("./dll");   // загрузить DLL (ПЕРВЫМ)
    auto app = new QApplication();
    app.exec();
    app.deleteApp();   // ПОСЛЕДНИМ (UnloadQt() НЕ вызывать!)
}
```

## Добавление нового класса

1. Написать `cpp/qt5/qte56_qfoo/qte56_qfoo.cpp` (или сгенерировать)
2. Запустить генератор:
   ```
   python generator/main.py path/to/qfoo.h --module QFoo --dll qte56_qfoo.dll --index-start NNNNN
   ```
3. Генератор создаст `d/gen/gen_qfoo.d` и обновит `functions.csv`
