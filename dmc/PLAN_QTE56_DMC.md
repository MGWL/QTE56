# План: Перенос архитектуры QTE56 на компилятор DMC

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

## 1. Общая цель

Создать в `H:/qte56/arch_new/dmc/` полноценный C++ аналог QTE56, использующий готовые 32-битные DLL из `H:/qte56/arch_new/dll/dll32/`. Проект должен максимально повторять архитектуру D-версии QTE56, но быть совместимым с компилятором Digital Mars C++ 8.42n (C++98, без STL, nullptr, wchar_t-массивов, snprintf).

## 2. Текущее состояние

### D-версия QTE56 (`H:/qte56/arch_new/d/`)
(числа обновлены на 2026-08-02)
- 136 D-файлов (22 в `d/` + 114 в `d/gen/`)
- 114 модулей `gen_*.d` с `generateFunQt(...)`
- Реестр функций: `H:/qte56/arch_new/registry/functions.csv` — 3783 функций
- Генератор: `H:/qte56/arch_new/generator/main.py`, `cpp_generator.py`, `d_generator.py`
- Ядро: `H:/qte56/arch_new/d/qte56_core.d` — `pFunQt[25000]`, `generateAlias()`, миксины
- Загрузчик: `H:/qte56/arch_new/d/qte56_loader.d` — `LoadQt()`, `registerModule()`, `loadFn()`

### DMC-версия (`H:/qte56/arch_new/dmc/`)
- Уже работает минимальный тест: `H:/qte56/arch_new/dmc/test/test_minimal.exe`
- Ядро: `H:/qte56/arch_new/dmc/qte5dmc_core.h`
- Загрузчик: `H:/qte56/arch_new/dmc/qte5dmc_loader.h` + `H:/qte56/arch_new/dmc/qte5dmc_loader.cpp`
- QCore: `H:/qte56/arch_new/dmc/gen/gen_qcore.h` + `H:/qte56/arch_new/dmc/gen/gen_qcore.cpp`
- QWidget (только заголовки): `H:/qte56/arch_new/dmc/gen/gen_qwidget.h`
- Сборка: `H:/qte56/arch_new/dmc/build.bat`
- Документация: `H:/qte56/arch_new/dmc/QTE5DMC_GUIDE.md`

### DLL (`H:/qte56/arch_new/dll/dll32/`)
- 35 файлов .dll (31 `qte56_*` + служебные), включая:
  - `H:/qte56/arch_new/dll/dll32/qte56_qcore.dll`
  - `H:/qte56/arch_new/dll/dll32/qte56_widgets.dll`
  - `H:/qte56/arch_new/dll/dll32/qte56_foundation.dll`
- Экспортируют функции с именами вида `qteQWidget_create`, `qteQPushButton_setText`
- Сигнатуры — C `extern "C"`, параметры маппятся через `H:/qte56/arch_new/registry/functions.csv`

### Компилятор
- Digital Mars C++ 8.42n: `C:/D/DMC/dm/bin/dmc.exe`

## 3. Выбранный подход

**Гибрид: ручной перенос ядра → автогенерация остальных модулей**

1. **Фаза 1 (ручная):** перенести value-типы и базовые модули, необходимые для любого GUI
2. **Фаза 2 (ручная):** QWidget + иерархия, QLabel, QPushButton, QLayout
3. **Фаза 3 (автоматизация):** написать генератор C++ заголовков по аналогии с D-генератором
4. **Фаза 4 (автоматизация):** сгенерировать оставшиеся ~90 модулей

Приоритет подтверждён: **начинаем с value-типов**.

## 4. Фаза 1 — Value-типы и базовые модули (ручной перенос)

### 4.1 Целевые модули

| Модуль | Источник D | DMC целевые файлы | DLL | Индексы | Зачем |
|--------|-----------|-------------------|-----|---------|-------|
| `QByteArray` | `H:/qte56/arch_new/d/gen/gen_qbytearray.d` | `H:/qte56/arch_new/dmc/gen/gen_qbytearray.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qbytearray.cpp` | `qte56_foundation.dll` | 19969–19998 | Строки/байты, взаимодействие с QString |
| `QDate` | `H:/qte56/arch_new/d/gen/gen_qdate.d` | `H:/qte56/arch_new/dmc/gen/gen_qdate.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qdate.cpp` | `qte56_foundation.dll` | 19901–19911 | Дата |
| `QTime` | `H:/qte56/arch_new/d/gen/gen_qdate.d` | `H:/qte56/arch_new/dmc/gen/gen_qdate.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qdate.cpp` | `qte56_foundation.dll` | 19912–19933 | Время |
| `QDateTime` | `H:/qte56/arch_new/d/gen/gen_qdate.d` | `H:/qte56/arch_new/dmc/gen/gen_qdate.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qdate.cpp` | `qte56_foundation.dll` | 19934–19968 | Дата+время |
| `QFont` | `H:/qte56/arch_new/d/gen/gen_qfont.d` | `H:/qte56/arch_new/dmc/gen/gen_qfont.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qfont.cpp` | `qte56_foundation.dll` | 5000–5199 | Шрифты |
| `QColor` | `H:/qte56/arch_new/d/gen/gen_qcolor.d` | `H:/qte56/arch_new/dmc/gen/gen_qcolor.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qcolor.cpp` | `qte56_foundation.dll` | 14000–14199 | Цвета |
| `QIcon` | `H:/qte56/arch_new/d/gen/gen_qicon.d` | `H:/qte56/arch_new/dmc/gen/gen_qicon.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qicon.cpp` | `qte56_foundation.dll` | 7400–7499 | Иконки |
| `QPixmap` | `H:/qte56/arch_new/d/gen/gen_qpixmap.d` | `H:/qte56/arch_new/dmc/gen/gen_qpixmap.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qpixmap.cpp` | `qte56_foundation.dll` | 17400–17599 | Изображения |
| `QRect/QPoint/QSize` | `H:/qte56/arch_new/d/gen/gen_qcore.d` | `H:/qte56/arch_new/dmc/qte5dmc_core.h` | `qte56_qcore.dll` | 30–38 | Геометрия |

### 4.2 Что нужно сделать

Для каждого value-модуля:
1. Создать `H:/qte56/arch_new/dmc/gen/gen_qxxx.h` — C++ class wrapper
2. Создать `H:/qte56/arch_new/dmc/gen/gen_qxxx.cpp` — реализация + `loadQxxx()` + `registerQxxxModule()`
3. Добавить typedef-ы в `H:/qte56/arch_new/dmc/qte5dmc_core.h`
4. Обновить `H:/qte56/arch_new/dmc/build.bat` — компиляция новых `.obj`
5. Написать тест в `H:/qte56/arch_new/dmc/test/test_qxxx.cpp`

### 4.3 Особенности value-типов

- `QByteArray`, `QFont`, `QColor`, `QPixmap` — объекты на куче, управляются через `create/delete/copy`
- `QRect/QPoint/QSize` — передаются по значению через `pack/unpack` (индексы 30–38)
- Все строковые операции через `fromQString`/`toQString` из `H:/qte56/arch_new/dmc/gen/gen_qcore.h`

## 5. Фаза 2 — QWidget-иерархия (ручной перенос)

### 5.1 Целевые модули

| Модуль | Источник D | DMC целевые файлы | DLL | Индексы | Родитель |
|--------|-----------|-------------------|-----|---------|----------|
| `QObject` | `H:/qte56/arch_new/d/gen/gen_qobject.d` | `H:/qte56/arch_new/dmc/gen/gen_qobject.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qobject.cpp` | `qte56_foundation.dll` | 100–199 | — |
| `QWidget` | `H:/qte56/arch_new/d/gen/gen_qwidget.d` | `H:/qte56/arch_new/dmc/gen/gen_qwidget.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qwidget.cpp` | `qte56_widgets.dll` | 200–399 | QObject |
| `QAbstractButton` | `H:/qte56/arch_new/d/gen/gen_qabstractbutton.d` | `H:/qte56/arch_new/dmc/gen/gen_qabstractbutton.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qabstractbutton.cpp` | `qte56_widgets.dll` | 3000–3029 | QWidget |
| `QPushButton` | `H:/qte56/arch_new/d/gen/gen_qpushbutton.d` | `H:/qte56/arch_new/dmc/gen/gen_qpushbutton.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qpushbutton.cpp` | `qte56_widgets.dll` | 400–419 | QAbstractButton |
| `QLabel` | `H:/qte56/arch_new/d/gen/gen_qlabel.d` | `H:/qte56/arch_new/dmc/gen/gen_qlabel.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qlabel.cpp` | `qte56_widgets.dll` | 500–599 | QWidget |
| `QFrame` | `H:/qte56/arch_new/d/gen/gen_qframe.d` | `H:/qte56/arch_new/dmc/gen/gen_qframe.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qframe.cpp` | `qte56_widgets.dll` | 600–699 | QWidget |
| `QLayout` | `H:/qte56/arch_new/d/gen/gen_qlayout.d` | `H:/qte56/arch_new/dmc/gen/gen_qlayout.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qlayout.cpp` | `qte56_widgets.dll` | 1300–1399 | — |
| `QLineEdit` | `H:/qte56/arch_new/d/gen/gen_qlineedit.d` | `H:/qte56/arch_new/dmc/gen/gen_qlineedit.h`<br>`H:/qte56/arch_new/dmc/gen/gen_qlineedit.cpp` | `qte56_widgets.dll` | 7000–7099 | QWidget |

### 5.2 Особенности иерархии в C++

- В D используется наследование классов: `QPushButton : QAbstractButton : QWidget : QObject`
- В C++ DMC наследование работает, но нужно внимательно следить за:
  - Порядком инициализации `_wh`
  - Виртуальными деструкторами
  - Отсутствием RTTI (можно включить `-Ar`, но лучше избегать)
- Альтернатива: композиция вместо наследования (каждый класс содержит `_wh`, а общие методы дублируются). Проще для DMC, но больше кода.

## 6. Фаза 3 — Автогенерация C++ заголовков

### 6.1 Задача генератора

Создать скрипт `H:/qte56/arch_new/dmc/generator/dmc_generator.py`, который:
1. Читает `H:/qte56/arch_new/registry/functions.csv`
2. Читает соответствующий `H:/qte56/arch_new/d/gen/gen_qxxx.d`
3. Извлекает:
   - Индексы `generateFunQt(idx, name, module)`
   - Alias-типы `generateAlias("...")`
   - Классы и методы D-обёртки
4. Генерирует:
   - `H:/qte56/arch_new/dmc/gen/gen_qxxx.h`
   - `H:/qte56/arch_new/dmc/gen/gen_qxxx.cpp`
   - Обновляет `H:/qte56/arch_new/dmc/qte5dmc_core.h` новыми typedef

Запуск генератора: `py H:/qte56/arch_new/dmc/generator/dmc_generator.py [аргументы]`

### 6.2 Проблемы автогенерации

- D-типы (`string`, `bool`) vs C++ (`char*`, `int`)
- Перегрузки методов (`setText(QString)` vs `setText(const char*)`)
- Сигналы и слоты — нужна ESlot-инфраструктура
- События (`onMousePress`, `onKeyPress`) — callback-функции
- Некоторые модули могут использовать специфичные для D конструкции

### 6.3 Прагматичный подход к автогенерации

- Не пытаться автоматически сгенерировать 100% модулей
- Генератор создаёт "скелет" 80% модулей, остальное дорабатывается вручную
- Для каждого сгенерированного модуля — тест компиляции

## 7. Фаза 4 — Масштабирование и покрытие

### 7.1 Приоритеты после базового GUI

1. **MainWindow-стек:** `H:/qte56/arch_new/dmc/gen/gen_qmainwindow.h/cpp`, `gen_qmenubar.h/cpp`, `gen_qmenu.h/cpp`, `gen_qaction.h/cpp`, `gen_qstatusbar.h/cpp`, `gen_qtoolbar.h/cpp`
2. **Диалоги:** `H:/qte56/arch_new/dmc/gen/gen_qdialog.h/cpp`, `gen_qfiledialog.h/cpp`, `gen_qmessagebox.h/cpp`, `gen_qinputdialog.h/cpp`
3. **Текст:** `H:/qte56/arch_new/dmc/gen/gen_qtextedit.h/cpp`, `gen_qplaintextedit.h/cpp`, `gen_qtextcursor.h/cpp`, `gen_qtextdocument.h/cpp`
4. **Таблицы/деревья:** `H:/qte56/arch_new/dmc/gen/gen_qtablewidget.h/cpp`, `gen_qtreewidget.h/cpp`, `gen_qlistwidget.h/cpp`
5. **Рисование:** `H:/qte56/arch_new/dmc/gen/gen_qpainter.h/cpp`, `gen_qpen.h/cpp`, `gen_qbrush.h/cpp`, `gen_qpixmap.h/cpp`
6. **Сеть/другое:** `H:/qte56/arch_new/dmc/gen/gen_qnetwork.h/cpp`, `gen_qprocess.h/cpp`, `gen_qthread.h/cpp`, `gen_qtimer.h/cpp`
7. **Специфичные:** QScintilla, QXlsx, Wren и т.д.

### 7.2 Покрытие DLL

> Примечание (2026-08-02): список ниже составлен до объединения DLL в merged-архитектуру и устарел — отдельных `qte56_qpushbutton.dll`, `qte56_qwidget.dll`, `qte56_qcolor.dll`, `qte56_qlineedit.dll`, `qte56_qmessagebox.dll` больше нет; их функции вошли в merged DLL (`qte56_widgets.dll`, `qte56_foundation.dll`, `qte56_dialogs.dll` и др., см. AGENTS.md §9). Актуальное распределение функций по DLL — `qte index list`.

Сначала модули, которые используют DLL с наибольшим количеством функций:
- `H:/qte56/arch_new/dll/dll32/qte56_foundation.dll` (444 функции)
- `H:/qte56/arch_new/dll/dll32/qte56_qpushbutton.dll` (231)
- `H:/qte56/arch_new/dll/dll32/qte56_qwidget.dll` (188)
- `H:/qte56/arch_new/dll/dll32/qte56_text.dll` (109)
- `H:/qte56/arch_new/dll/dll32/qte56_qcolor.dll` (82)
- `H:/qte56/arch_new/dll/dll32/qte56_qlineedit.dll` (67)
- `H:/qte56/arch_new/dll/dll32/qte56_qmessagebox.dll` (67)

## 8. Инфраструктура и инструменты

### 8.1 Необходимые скрипты

1. **`H:/qte56/arch_new/dmc/tools/compare_dmc_qte56.py`** — сравнивает `H:/qte56/arch_new/dmc/gen/` с `H:/qte56/arch_new/d/gen/`, показывает покрытие
2. **`H:/qte56/arch_new/dmc/tools/extract_aliases_dmc.py`** — извлекает все typedef из `H:/qte56/arch_new/dmc/qte5dmc_core.h`
3. **`H:/qte56/arch_new/dmc/generator/dmc_generator.py`** — генератор C++ заголовков (вызывать через `py H:/qte56/arch_new/dmc/generator/dmc_generator.py ...`)
4. **`H:/qte56/arch_new/dmc/tools/validate_dll_exports.py`** — проверяет, что все функции из `H:/qte56/arch_new/registry/functions.csv` есть в DLL

### 8.2 Система сборки

- Текущий: `H:/qte56/arch_new/dmc/build.bat`
- В перспективе — генерация `H:/qte56/arch_new/dmc/build.bat` через `H:/qte56/arch_new/generator/make_build.py` по аналогии с D-версией
- Для каждого нового модуля добавлять строку в `H:/qte56/arch_new/dmc/build.bat`

### 8.3 Тестирование

- `H:/qte56/arch_new/dmc/test/test_minimal.cpp` — базовый тест (уже есть)
- `H:/qte56/arch_new/dmc/test/test_qcore.cpp` — тест QString/QApplication
- `H:/qte56/arch_new/dmc/test/test_qbytearray.cpp` — тест QByteArray
- `H:/qte56/arch_new/dmc/test/test_qdate.cpp` — тест QDate/QTime/QDateTime
- `H:/qte56/arch_new/dmc/test/test_gui.cpp` — тест QWidget + QLabel + QPushButton (уже есть, расширить)
- `H:/qte56/arch_new/dmc/test/test_layout.cpp` — тест QLayout
- `H:/qte56/arch_new/dmc/test/test_mainwindow.cpp` — тест QMainWindow

## 9. Критические риски

### 9.1 Технические риски

| Риск | Влияние | Митигация |
|------|---------|-----------|
| DMC не поддерживает сложные C++ конструкции | Высокое | Использовать только C++98, избегать STL, шаблонов, RTTI |
| Несовпадение calling convention | Высокое | Все DLL используют `extern "C"` Cdecl — проверить |
| Размер `pFunQt[25000]` превышает лимит DMC | Среднее | Если нужно — уменьшить до 10000 или выделить динамически |
| Наследование классов в DMC работает нестабильно | Среднее | Использовать композицию как fallback |
| Автогенерация не покрывает 100% модулей | Среднее | Ручная доработка сложных модулей |

### 9.2 Организационные риски

- Огромный объём работы (3783 функций)
- Необходимость постоянной синхронизации с D-версией
- Риск отклонения от архитектуры D-версии

## 10. План работ поэтапно

### Этап 0 — Подготовка (1–2 дня)

- [ ] Улучшить `H:/qte56/arch_new/dmc/qte5dmc_core.h`: систематизировать typedef, добавить недостающие базовые типы
- [ ] Улучшить `H:/qte56/arch_new/dmc/build.bat`: поддержка произвольного числа `.obj`
- [ ] Создать `H:/qte56/arch_new/dmc/tools/compare_dmc_qte56.py` для отслеживания прогресса
- [ ] Создать `H:/qte56/arch_new/dmc/tools/validate_dll_exports.py` для проверки экспортов
- [ ] Написать `H:/qte56/arch_new/dmc/test/test_qcore.cpp` для проверки QString/QApplication

### Этап 1 — Value-типы (3–5 дней)

- [ ] `H:/qte56/arch_new/dmc/gen/gen_qbytearray.h` + `.cpp` + тест
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qdate.h` + `.cpp` (QDate + QTime + QDateTime) + тест
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qfont.h` + `.cpp` + тест
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qcolor.h` + `.cpp` + тест
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qicon.h` + `.cpp` + тест
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qpixmap.h` + `.cpp` + тест
- [ ] Обновить `H:/qte56/arch_new/dmc/qte5dmc_core.h` typedef

### Этап 2 — QWidget-иерархия (5–7 дней)

- [ ] `H:/qte56/arch_new/dmc/gen/gen_qobject.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qwidget.h` + `.cpp` (полная реализация)
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qabstractbutton.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qpushbutton.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qlabel.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qframe.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qlayout.h` + `.cpp` + QVBoxLayout/QHBoxLayout
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qlineedit.h` + `.cpp`
- [ ] Обновить `H:/qte56/arch_new/dmc/test/test_gui.cpp`

### Этап 3 — MainWindow и диалоги (3–5 дней)

- [ ] `H:/qte56/arch_new/dmc/gen/gen_qmainwindow.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qmenubar.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qmenu.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qaction.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qstatusbar.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qtoolbar.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qdialog.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qmessagebox.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qfiledialog.h` + `.cpp`
- [ ] `H:/qte56/arch_new/dmc/gen/gen_qinputdialog.h` + `.cpp`

### Этап 4 — Автогенератор (5–7 дней)

- [ ] Написать `H:/qte56/arch_new/dmc/generator/dmc_generator.py`
- [ ] Протестировать на 5–10 простых модулях (`py H:/qte56/arch_new/dmc/generator/dmc_generator.py ...`)
- [ ] Доработать маппинг D-типов → C++
- [ ] Поддержка сигналов/событий
- [ ] Сгенерировать 30–50 модулей в `H:/qte56/arch_new/dmc/gen/`

### Этап 5 — Масштабирование (10–15 дней)

- [ ] Сгенерировать оставшиеся модули в `H:/qte56/arch_new/dmc/gen/`
- [ ] Ручная доработка сложных модулей (QPainter, QTextEdit, QThread)
- [ ] Покрытие специфичных DLL (QScintilla, QXlsx)
- [ ] Написание тестов для каждого модуля

### Этап 6 — Интеграция и документация (3–5 дней)

- [ ] Обновить `H:/qte56/arch_new/dmc/QTE5DMC_GUIDE.md`
- [ ] Создать `H:/qte56/arch_new/dmc/README_DMC.md`
- [ ] Автоматическая генерация `H:/qte56/arch_new/dmc/build.bat`
- [ ] Финальное тестирование с реальными приложениями

## 11. Ожидаемый результат

- Полноценный C++ аналог QTE56, компилируемый `C:/D/DMC/dm/bin/dmc.exe`
- Поддержка всех основных Qt-классов: QWidget, QPushButton, QLabel, QLineEdit, QLayout, QMainWindow, диалоги, текст, таблицы, рисование
- Возможность собирать GUI-приложения без D-компилятора
- Использование готовых DLL из `H:/qte56/arch_new/dll/dll32/` без их перекомпиляции
- Генератор для автоматического создания новых C++ модулей

## 12. Критерии завершения

1. `H:/qte56/arch_new/dmc/build.bat` успешно собирает все тесты
2. `H:/qte56/arch_new/dmc/test/test_gui.exe` запускается и показывает окно с виджетами
3. `H:/qte56/arch_new/dmc/test/test_mainwindow.exe` показывает главное окно с меню
4. `H:/qte56/arch_new/dmc/test/test_qbytearray.exe`, `H:/qte56/arch_new/dmc/test/test_qdate.exe` проходят
5. Покрытие функций из `H:/qte56/arch_new/registry/functions.csv` — не менее 80% для ключевых DLL
6. Документация `H:/qte56/arch_new/dmc/QTE5DMC_GUIDE.md` актуальна

## 13. Первый шаг после утверждения

Начать с **Этапа 0 — Подготовка**, конкретно:
1. Систематизировать `H:/qte56/arch_new/dmc/qte5dmc_core.h`
2. Создать `H:/qte56/arch_new/dmc/tools/compare_dmc_qte56.py`
3. Написать `H:/qte56/arch_new/dmc/test/test_qcore.cpp` для базовой проверки
