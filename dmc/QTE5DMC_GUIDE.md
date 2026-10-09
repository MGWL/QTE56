# QTE5-DMC — Руководство для разработчиков

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

> **QTE5-DMC** — C++ биндинги Qt5 для компилятора Digital Mars C++ (DMC 8.42n).
> Использует готовые 32-битные DLL из проекта QTE56.
> Расположение: `h:/qte56/arch_new/dmc/`

---

## 1. Быстрый старт

### Минимальное приложение

```cpp
#include <stdio.h>
#include "qte5dmc_core.h"
#include "qte5dmc_loader.h"
#include "gen/gen_qcore.h"
#include "gen/gen_qwidget.h"
#include "../qte5dmc_qstring.h"

int main() {
    // 1. Регистрируем модули (вызвать ДО LoadQt)
    registerQCoreModule();     // QApplication
    registerQObjectModule();   // QObject
    registerQWidgetModule();   // QWidget

    // 2. Загружаем DLL
    LoadQt("dll32");

    // 3. Создаём QApplication
    QApplication* app = new QApplication("MyApp");

    // 4. Создаём виджет
    QWidget* w = new QWidget(QVOID);   // QVOID — явный nullptr для top-level
    w->setWindowTitle(QStringDMC("Hello DMC"));
    w->resize(400, 200);
    w->show();

    // 5. Запускаем event loop
    int r = app->exec();

    // 6. Завершение
    app->deleteApp();
    delete w;
    delete app;
    return r;
}
```

### Сборка и запуск (Windows)

```batch
:: Перейти в папку проекта
cd h:\qte56\arch_new\dmc

:: Собрать и запустить через make
c:\D\DMC\dm\bin\make.exe -f makefile.gui gui
c:\D\DMC\dm\bin\make.exe -f makefile.gui run
```

`makefile.gui` автоматически устанавливает:
- `PATH` (DMC + Qt runtime)
- `QT_QPA_PLATFORM_PLUGIN_PATH`
- `QT_PLUGINS`

---

## 2. Архитектура проекта

### 2.1 Параллель с QTE56 (D-версия)

| D-файл | C++-аналог | Назначение |
|--------|-----------|------------|
| `d/qte56_core.d` | `dmc/qte5dmc_core.h` | `pFunQt[]`, typedef, структуры |
| `d/qte56_loader.d` | `dmc/qte5dmc_loader.h/cpp` | `LoadQt`, `registerModule`, `loadFn` |
| `d/gen/gen_qobject.d` | `dmc/gen/gen_qobject.h/cpp` | Базовый `QObject` |
| `d/gen/gen_qcore.d` | `dmc/gen/gen_qcore.h/cpp` | `QApplication`, `ESlot`, `QString` helpers |
| `d/gen/gen_qwidget.d` | `dmc/gen/gen_qwidget.h/cpp` | `QWidget` |
| `d/gen/gen_qlabel.d` | `dmc/gen/gen_qlabel.h/cpp` | `QLabel : QFrame` |
| `d/gen/gen_qpushbutton.d` | `dmc/gen/gen_qpushbutton.h/cpp` | `QPushButton : QAbstractButton` |

### 2.2 Ключевые файлы

| Файл | Назначение |
|------|-----------|
| `qte5dmc_core.h` | Базовые типы, `pFunQt[25000]`, все typedef функций, `DRect`/`DPoint`/`DSize` |
| `qte5dmc_loader.h/cpp` | Загрузчик DLL, `LoadQt`, `registerModule`, `loadFn` |
| `qte5dmc_qstring.h/cpp` | `QStringDMC` — C++ обёртка над `QString*` |
| `gen/gen_qobject.h` | Базовый класс `QObject` с `_wh` |
| `gen/gen_qwidget.h` | `QWidget : QObject` |
| `gen/gen_qabstractbutton.h` | `QAbstractButton : QWidget` |
| `gen/gen_qframe.h` | `QFrame : QWidget` |
| `gen/gen_qdialog.h` | `QDialog : QWidget` |
| `makefile.gui` | Полная сборка `test_gui.exe` через DMC `make` |

---

## 3. Наследование

### 3.1 Общая иерархия

Все Qt-классы-объекты наследуют `QObject`. Виджеты наследуют `QWidget`. Промежуточные абстрактные классы (`QAbstractButton`, `QAbstractSlider`, `QAbstractSpinBox`, `QAbstractScrollArea`, `QAbstractItemView`, `QFrame`, `QDialog`) уже реализованы.

```text
QObject
└── QWidget
    ├── QAbstractButton
    │   ├── QPushButton
    │   ├── QCheckBox
    │   └── QRadioButton
    ├── QAbstractSlider
    │   └── QSlider
    ├── QAbstractSpinBox
    │   └── QSpinBox / QDoubleSpinBox / QDateTimeEdit
    ├── QFrame
    │   ├── QLabel
    │   └── QAbstractScrollArea
    │       ├── QTextEdit
    │       │   └── QTextBrowser
    │       └── QPlainTextEdit
    └── QDialog
        ├── QFileDialog
        ├── QColorDialog
        └── QFontDialog
```

### 3.2 Почему это важно

Без наследования каждый класс должен был бы дублировать методы родителя (`show`, `hide`, `setEnabled`, `setWindowTitle` и т.д.). С наследованием:
- `QPushButton` получает `setText` от `QAbstractButton`.
- `QLabel` получает `show` от `QWidget`.
- `QTextBrowser` получает `setHtml` от `QTextEdit`.

### 3.3 No-op конструкторы базовых классов

Чтобы DMC не пытался создать промежуточный Qt-объект при конструировании `QPushButton`, базовые классы имеют защищённый no-op конструктор:

```cpp
class QAbstractButton : public QWidget {
protected:
    QAbstractButton(bool _noOp);  // не создаёт QWidget, _wh = QNULL
public:
    ...
};

class QPushButton : public QAbstractButton {
public:
    QPushButton(void* parent = QNULL) : QAbstractButton(true) {
        if (!pFunQt[400]) { _wh = QNULL; return; }
        _wh = ((t_qp__qp)pFunQt[400])(parent);
    }
};
```

### 3.4 Регистрация базовых модулей

При использовании `QPushButton` нужно зарегистрировать всю цепочку предков:

```cpp
registerQCoreModule();
registerQObjectModule();
registerQWidgetModule();
registerQAbstractButtonModule();
registerQPushButtonModule();
LoadQt("dll32");
```

---

## 4. Работа со строками (`QStringDMC`)

### 4.1 Создание и использование

```cpp
#include "../qte5dmc_qstring.h"

QStringDMC s1("UTF-8 строка");
QStringDMC s2 = QStringDMC::fromLocal8Bit("Другая строка");

// Передача в виджеты
w->setWindowTitle(QStringDMC("Заголовок"));
lbl->setText(QStringDMC("Текст"));
```

### 4.2 Получение строки из Qt

```cpp
char buf[256];
int len = lbl->text(buf, sizeof(buf));  // возвращает длину UTF-8
printf("text: %s\n", buf);
```

### 4.3 Конкатенация и сравнение

```cpp
QStringDMC a("Hello");
QStringDMC b("World");
QStringDMC c = a + " " + b;
if (c == QStringDMC("Hello World")) { ... }
```

Подробное руководство по строкам: [`AI_STRING_GUIDE.md`](AI_STRING_GUIDE.md).

---

## 5. Сигналы и слоты

### 5.1 ESlot

`ESlot` — C++ обёртка над Qt-соединением. Создаётся на стороне приёмника сигнала.

```cpp
ESlot slot(sender->getWH());
slot.set((void*)&myCallback, dthis, 0);
sender->connect_clicked(&slot);
```

### 5.2 Сигнатуры callback

| Сигнал Qt | Слот ESlot | C callback |
|-----------|-----------|------------|
| `clicked(bool)` | `invoke_b(bool)` | `void cb(void* dthis, int n, int checked)` |
| `triggered(bool)` | `invoke_b(bool)` | `void cb(void* dthis, int n, int checked)` |
| `stateChanged(int)` | `invoke_i(int)` | `void cb(void* dthis, int n, int state)` |
| `valueChanged(int)` | `invoke_i(int)` | `void cb(void* dthis, int n, int value)` |
| `valueChanged(double)` | `invoke_d(double)` | `void cb(void* dthis, int n, double value)` |
| `currentIndexChanged(int)` | `invoke_i(int)` | `void cb(void* dthis, int n, int index)` |
| `currentChanged(int)` | `invoke_i(int)` | `void cb(void* dthis, int n, int index)` |
| `dateTimeChanged()` | `invoke_b()` | `void cb(void* dthis, int n)` |
| `textChanged()` | `invoke_v()` | `void cb(void* dthis, int n)` |

### 5.3 Пример

```cpp
extern "C" void onBtnClicked(void* dthis, int n, int checked) {
    QLabel* lbl = (QLabel*)dthis;
    if (lbl) lbl->setText(QStringDMC("Pressed!"));
    printf("clicked checked=%d\n", checked);
}

// в main():
QPushButton* btn = new QPushButton(QVOID);
btn->setText(QStringDMC("Click me"));

ESlot slot(btn->getWH());
slot.set((void*)&onBtnClicked, lbl, 0);
btn->connect_clicked(&slot);
```

---

## 6. Порядок инициализации

```cpp
// 1. Регистрация модулей — ВСЕХ предков, включая промежуточные
registerQCoreModule();
registerQObjectModule();
registerQWidgetModule();
registerQAbstractButtonModule();
registerQPushButtonModule();
// ... другие модули

// 2. Загрузка DLL
LoadQt("dll32");

// 3. Создание QApplication
QApplication* app = new QApplication("AppName");

// 4. Виджеты, сигналы, show(), exec()

// 5. Завершение
app->deleteApp();  // обнуляет pFunQt[]
delete app;
// НЕ вызывать UnloadQt()!
```

---

## 7. Таблица импортов (модуль → DLL)

| Класс | Заголовок | DLL | Родитель |
|-------|----------|-----|----------|
| `QApplication` | `gen_qcore.h` | `qte56_qcore.dll` | — |
| `QObject` | `gen_qobject.h` | `qte56_foundation.dll` | — |
| `QWidget` | `gen_qwidget.h` | `qte56_widgets.dll` | `QObject` |
| `QAbstractButton` | `gen_qabstractbutton.h` | `qte56_widgets.dll` | `QWidget` |
| `QPushButton` | `gen_qpushbutton.h` | `qte56_widgets.dll` | `QAbstractButton` |
| `QCheckBox` | `gen_qcheckbox.h` | `qte56_widgets.dll` | `QAbstractButton` |
| `QRadioButton` | `gen_qradiobutton.h` | `qte56_widgets.dll` | `QAbstractButton` |
| `QLabel` | `gen_qlabel.h` | `qte56_widgets.dll` | `QFrame` |
| `QLineEdit` | `gen_qlineedit.h` | `qte56_widgets.dll` | `QWidget` |
| `QFrame` | `gen_qframe.h` | `qte56_widgets.dll` | `QWidget` |
| `QAbstractScrollArea` | `gen_qabstractscrollarea.h` | `qte56_views.dll` | `QFrame` |
| `QScrollArea` | `gen_qscrollarea.h` | `qte56_views.dll` | `QAbstractScrollArea` |
| `QPlainTextEdit` | `gen_qplaintextedit.h` | `qte56_text.dll` | `QAbstractScrollArea` |
| `QTextEdit` | `gen_qtextedit.h` | `qte56_text.dll` | `QAbstractScrollArea` |
| `QTextBrowser` | `gen_qtextbrowser.h` | `qte56_text.dll` | `QTextEdit` |
| `QAbstractSlider` | `gen_qabstractslider.h` | `qte56_widgets.dll` | `QWidget` |
| `QSlider` | `gen_qslider.h` | `qte56_widgets.dll` | `QAbstractSlider` |
| `QAbstractSpinBox` | `gen_qabstractspinbox.h` | `qte56_widgets.dll` | `QWidget` |
| `QSpinBox` | `gen_qspinbox.h` | `qte56_widgets.dll` | `QAbstractSpinBox` |
| `QDoubleSpinBox` | `gen_qdoublespinbox.h` | `qte56_widgets.dll` | `QAbstractSpinBox` |
| `QDateTimeEdit` | `gen_qdatetimeedit.h` | `qte56_widgets.dll` | `QAbstractSpinBox` |
| `QDialog` | `gen_qdialog.h` | `qte56_dialogs.dll` | `QWidget` |
| `QMessageBox` | `gen_qmessagebox.h` | `qte56_dialogs.dll` | `QDialog` |
| `QFileDialog` | `gen_qfiledialog.h` | `qte56_dialogs.dll` | `QDialog` |
| `QInputDialog` | `gen_qinputdialog.h` | `qte56_dialogs.dll` | `QDialog` |
| `QFontDialog` | `gen_qfontdialog.h` | `qte56_dialogs.dll` | `QDialog` |
| `QColorDialog` | `gen_qcolordialog.h` | `qte56_dialogs.dll` | `QDialog` |
| `QMainWindow` | `gen_qmainwindow.h` | `qte56_mainwin.dll` | `QWidget` |
| `QMenuBar` / `QMenu` / `QToolBar` / `QStatusBar` | `gen_qmenubar.h` и др. | `qte56_mainwin.dll` | `QWidget` |
| `QAction` | `gen_qaction.h` | `qte56_mainwin.dll` | `QObject` |

---

## 8. Добавление нового класса

### Шаг 1: Создать `gen/gen_qnewclass.h`

```cpp
#ifndef GEN_QNEWCLASS_H
#define GEN_QNEWCLASS_H

#include "gen_<parent>.h"

class QNewClass : public QParent {
protected:
    QNewClass(bool _noOp);
public:
    QNewClass(void* parent = QNULL);
    // только собственные методы QNewClass
    void loadQNewClass();
    void registerQNewClassModule();
};

#endif
```

### Шаг 2: Создать `gen/gen_qnewclass.cpp`

```cpp
#include "gen_qnewclass.h"
#include "../qte5dmc_loader.h"

static bool _qnewclass_registered = false;

void registerQNewClassModule() {
    if (!_qnewclass_registered) {
        registerModule("QNewClass", "qte56_xxx.dll", loadQNewClass);
        _qnewclass_registered = true;
    }
}

QNewClass::QNewClass(void* parent) : QParent(true) {
    if (!pFunQt[INDEX]) { _wh = QNULL; return; }
    _wh = ((t_qp__qp)pFunQt[INDEX])(parent);
}

QNewClass::QNewClass(bool _noOp) : QParent(true) {
    _wh = QNULL;
}

void loadQNewClass() {
    pFunQt[INDEX] = loadFn("QNewClass", "qteQNewClass_create");
    // ... остальные функции
}
```

### Шаг 3: Зарегистрировать в `test/test_gui.cpp`

```cpp
#include "gen/gen_qnewclass.h"

// в main():
registerQNewClassModule();
```

### Шаг 4: Добавить в `makefile.gui`

```makefile
OBJS = ... gen\gen_qnewclass.obj
```

---

## 9. Критические ограничения DMC 8.42n

### 9.1 Нет STL (`std::vector`, `std::string`, `std::wstring`)

**Решение:** Использовать C-массивы и `char*`.

```cpp
// ❌ НЕ работает:
std::vector<ModuleReg> _modules;
std::string s = fromQString(qs);

// ✅ Работает:
ModuleReg _modules[256];  // фиксированный массив
char buf[256];
int len = fromQString(qs, buf, sizeof(buf));
```

### 9.2 Нет `nullptr`

**Решение:** Использовать `NULL` или макрос `QNULL`.

```cpp
void* p = QNULL;
```

### 9.3 Нет `snprintf`

**Решение:** Использовать `sprintf` (осторожно — нет проверки переполнения).

### 9.4 Нет `wchar_t` для объявления массивов

**Решение:** Использовать `char*` с кастом в `(WCHAR*)` при вызове Windows API.

```cpp
char* wide = (char*)malloc(len * 2);
MultiByteToWideChar(CP_UTF8, 0, utf8, -1, (WCHAR*)wide, len);
```

### 9.5 `void*` как тип локальной переменной — проблемы

```cpp
// ❌ Может не работать:
void* small = malloc(100);

// ✅ Работает:
char* small = (char*)malloc(100);
```

### 9.6 `windows.h` определяет `small` как макрос

Не использовать `small` как имя переменной.

### 9.7 Нет `<cstddef>`

**Решение:** Использовать `<stddef.h>`.

### 9.8 Нет inline-функций с `std::string`

Все строковые функции используют `char*` + `int bufLen`.

### 9.9 Нет глобальных объектов с конструкторами

**Решение:** Явная регистрация модулей через `registerQ*Module()`.

---

## 10. Отладка

### 10.1 Проверка загрузки DLL

```cpp
if (!pFunQt[50]) {
    printf("FAIL: qteQApplication_create не загружен\n");
    return 1;
}
```

### 10.2 Проверка GetLastError

```cpp
HMODULE h = LoadLibraryA(path);
if (!h) {
    DWORD err = GetLastError();
    printf("LoadLibrary failed: %lu\n", err);
    // 126 = ERROR_MOD_NOT_FOUND
    // 127 = ERROR_PROC_NOT_FOUND
}
```

---

## 11. История изменений

| Дата | Изменение |
|------|----------|
| 2026-07-05 | Создание проекта, минимальный тест QApplication + QString |
| 2026-07-11 | Реализовано полноценное C++ наследование (`QObject` → `QWidget` → абстрактные классы → конкретные виджеты) |
| 2026-07-11 | `test_gui.exe` собирается и работает с `QMainWindow`, меню, тулбаром, статусбаром, диалогами и сигналами |

---

*Документ обновлён после реализации наследования и успешного запуска `test_gui.exe`.*
