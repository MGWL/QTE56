# Анализ иерархии наследования QTE5-DMC

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

> **Актуальный отчёт о состоянии наследования в C++ биндингах QTE5-DMC.**
>
> Дата: 2026-07-11
>
> Статус: **наследование реализовано для всех основных классов и работает в `test_gui.exe`.**

---

## 1. Резюме

| Показатель | Значение |
|-----------|----------|
| Всего `gen/gen_q*.h` файлов | 106 |
| С наследованием (`: public Parent`) | **74** |
| Базовый класс `QObject` | **реализован** (`gen/gen_qobject.h`) |
| Промежуточные абстрактные классы | **реализованы** (`QAbstractButton`, `QAbstractSlider`, `QAbstractSpinBox`, `QAbstractScrollArea`, `QAbstractItemView`, `QFrame`, `QDialog`) |
| Рабочий интеграционный тест | **`test/test_gui.exe`** |

**Критический вывод:** Первоначальный подход «независимые классы с дублированием методов» отвергнут. В проекте внедрено полноценное C++ наследование, повторяющее иерархию QTE56.

---

## 2. Базовая иерархия

```text
QObject
├── QWidget
│   ├── QAbstractButton
│   │   ├── QPushButton
│   │   ├── QCheckBox
│   │   ├── QRadioButton
│   │   └── QToolButton
│   ├── QAbstractSlider
│   │   ├── QSlider
│   │   └── QScrollBar
│   ├── QAbstractSpinBox
│   │   ├── QSpinBox
│   │   ├── QDoubleSpinBox
│   │   └── QDateTimeEdit
│   │       ├── QDateEdit
│   │       └── QTimeEdit
│   ├── QFrame
│   │   ├── QLabel
│   │   ├── QLCDNumber
│   │   ├── QSplitter
│   │   ├── QStackedWidget
│   │   ├── QToolBox
│   │   └── QAbstractScrollArea
│   │       ├── QTextEdit
│   │       │   └── QTextBrowser
│   │       ├── QPlainTextEdit
│   │       ├── QsciScintilla
│   │       └── QAbstractItemView
│   │           ├── QTableView
│   │           │   └── QTableWidget
│   │           ├── QTreeView
│   │           │   └── QTreeWidget
│   │           └── QHeaderView
│   ├── QDialog
│   │   ├── QColorDialog
│   │   ├── QFileDialog
│   │   ├── QFontDialog
│   │   ├── QInputDialog
│   │   ├── QMessageBox
│   │   └── QProgressDialog
│   ├── QMainWindow
│   ├── QMenuBar / QMenu / QToolBar / QStatusBar
│   ├── QComboBox / QLineEdit / QGroupBox / QProgressBar
│   ├── QTabWidget / QDockWidget / QMdiSubWindow
│   └── QCalendarWidget / QDesktopWidget
├── QAction / QGraphicsScene / QMediaPlayer / QSound / QSoundEffect
└── ...
```

---

## 3. Ключевые архитектурные решения

### 3.1 `_wh` — единый защищённый член в `QObject`

```cpp
// gen/gen_qobject.h
class QObject {
protected:
    void* _wh;

    /// No-op constructor for subclasses (they set _wh themselves).
    QObject(bool _noOp);

public:
    /// Create a standalone QObject. parent=null for root objects.
    QObject(void* parent = QNULL);
    ~QObject();

    void* getWH() const;
    // ... common QObject methods ...
};
```

Все виджеты наследуют `_wh`, поэтому `getWH()` работает полиморфно. Конструктор `QObject(bool _noOp)` нужен для наследников, которые создают `_wh` через собственный `pFunQt[index]`.

### 3.2 No-op конструкторы для промежуточных баз

```cpp
// gen/gen_qwidget.h
class QWidget : public QObject {
protected:
    QWidget(bool _noOp);   // не создаёт QWidget, только инициализирует _wh = QNULL
public:
    QWidget(void* parent = QNULL);
    ...
};

// gen/gen_qabstractbutton.h
class QAbstractButton : public QWidget {
protected:
    QAbstractButton(bool _noOp);
public:
    ...
};
```

Конкретный класс (например, `QPushButton`) вызывает `QAbstractButton(true)`, чтобы базовые классы не пытались создать промежуточные Qt-объекты, а только выделили/обнулили `_wh`. Сам `QPushButton` затем вызывает `qteQPushButton_create` и записывает результат в `_wh`.

### 3.3 Include-цепочки

Каждый заголовок включает родительский заголовок:

```cpp
// gen/gen_qpushbutton.h
#include "gen_qabstractbutton.h"

class QPushButton : public QAbstractButton { ... };
```

Это обеспечивает видимость унаследованных методов (`setText`, `setEnabled`, `show` и т.д.).

### 3.4 Регистрация базовых модулей

Перед `LoadQt()` нужно зарегистрировать не только конечный класс, но и все его базовые:

```cpp
registerQCoreModule();            // QApplication
registerQObjectModule();          // QObject
registerQWidgetModule();          // QWidget
registerQAbstractButtonModule();  // QAbstractButton
registerQPushButtonModule();      // QPushButton
LoadQt("dll32");
```

`registerQ*Module()` гарантирует, что `pFunQt[]` будет заполнен для всех DLL, необходимых объекту.

---

## 4. Примеры наследования в проекте

| Класс | Родитель | Файл |
|-------|----------|------|
| `QWidget` | `QObject` | `gen/gen_qwidget.h` |
| `QAbstractButton` | `QWidget` | `gen/gen_qabstractbutton.h` |
| `QPushButton` | `QAbstractButton` | `gen/gen_qpushbutton.h` |
| `QCheckBox` | `QAbstractButton` | `gen/gen_qcheckbox.h` |
| `QFrame` | `QWidget` | `gen/gen_qframe.h` |
| `QLabel` | `QFrame` | `gen/gen_qlabel.h` |
| `QAbstractScrollArea` | `QFrame` | `gen/gen_qabstractscrollarea.h` |
| `QPlainTextEdit` | `QAbstractScrollArea` | `gen/gen_qplaintextedit.h` |
| `QTextEdit` | `QAbstractScrollArea` | `gen/gen_qtextedit.h` |
| `QTextBrowser` | `QTextEdit` | `gen/gen_qtextbrowser.h` |
| `QDialog` | `QWidget` | `gen/gen_qdialog.h` |
| `QFileDialog` | `QDialog` | `gen/gen_qfiledialog.h` |
| `QAbstractSpinBox` | `QWidget` | `gen/gen_qabstractspinbox.h` |
| `QSpinBox` / `QDoubleSpinBox` / `QDateTimeEdit` | `QAbstractSpinBox` | `gen/gen_qspinbox.h`, `gen/gen_qdoublespinbox.h`, `gen/gen_qdatetimeedit.h` |
| `QDateEdit` / `QTimeEdit` | `QDateTimeEdit` | `gen/gen_qdatetimeedit.h` |
| `QAbstractSlider` | `QWidget` | `gen/gen_qabstractslider.h` |
| `QSlider` / `QScrollBar` / `QDial` | `QAbstractSlider` | `gen/gen_qslider.h`, `gen/gen_qscrollbar.h`, `gen/gen_qdial.h` |
| `QAbstractItemView` | `QAbstractScrollArea` | `gen/gen_qabstractitemview.h` |
| `QTableView` / `QTreeView` | `QAbstractItemView` | `gen/gen_qtableview.h`, `gen/gen_qtreeview.h` |
| `QScrollArea` | `QAbstractScrollArea` | `gen/gen_qscrollarea.h` |
| `QMessageBox` | `QDialog` | `gen/gen_qmessagebox.h` |
| `QInputDialog` | `QDialog` | `gen/gen_qinputdialog.h` |
| `QSplashScreen` | `QWidget` | `gen/gen_qsplashscreen.h` |
| `QTabBar` | `QWidget` | `gen/gen_qtabbar.h` |
| `QShortcut` | `QObject` | `gen/gen_qshortcut.h` |
| `QTimer` | `QObject` | `gen/gen_qtimer.h` |
| `QSettings` | `QObject` | `gen/gen_qsettings.h` |
| `QSystemTrayIcon` | `QObject` | `gen/gen_qsystemtrayicon.h` |
| `QClipboard` | `QObject` | `gen/gen_qclipboard.h` |
| `QDesktopWidget` | `QWidget` | `gen/gen_qdesktopwidget.h` |
| `QCompleter` | `QObject` | `gen/gen_qcompleter.h` |
| `QSyntaxHighlighter` | `QObject` | `gen/gen_qsyntaxhighlighter.h` |
| `QProcess` | `QObject` | `gen/gen_qprocess.h` |
| `QTextDocument` | `QObject` | `gen/gen_qtextdocument.h` |

---

## 5. Практический пример использования

```cpp
#include <stdio.h>
#include "gen/gen_qcore.h"
#include "gen/gen_qwidget.h"
#include "gen/gen_qlabel.h"
#include "gen/gen_qpushbutton.h"
#include "gen/gen_qlayout.h"
#include "../qte5dmc_loader.h"
#include "../qte5dmc_qstring.h"

extern "C" void onClick(void* dthis, int n, int checked) {
    QLabel* lbl = (QLabel*)dthis;
    if (lbl) lbl->setText(QStringDMC("Clicked!"));
    printf("clicked checked=%d\n", checked);
}

int main() {
    registerQCoreModule();
    registerQObjectModule();
    registerQWidgetModule();
    registerQLabelModule();
    registerQPushButtonModule();
    registerQLayoutModule();

    if (!LoadQt("dll32")) return 1;

    QApplication* app = new QApplication("Demo");

    QWidget* w = new QWidget(QVOID);
    w->setWindowTitle(QStringDMC("Inheritance Demo"));

    QVBoxLayout* vbox = new QVBoxLayout(QVOID);
    QLabel* lbl = new QLabel(QVOID);
    lbl->setText(QStringDMC("Hello"));
    vbox->addWidget(lbl->getWH());

    QPushButton* btn = new QPushButton(QVOID);
    btn->setText(QStringDMC("Press me"));
    vbox->addWidget(btn->getWH());

    ESlot slot(btn->getWH());
    slot.set((void*)&onClick, lbl, 0);
    btn->connect_clicked(&slot);

    w->setLayout(vbox->getWH());
    w->show();

    int r = app->exec();
    app->deleteApp();
    delete w;
    delete app;
    return r;
}
```

---

## 6. Ограничения и особенности

### 6.1 Наследование приведено в соответствие с QTE56

| Класс | Бывший родитель | Текущий родитель | Примечание |
|-------|-----------------|------------------|------------|
| `QHeaderView` | `(no parent)` | `QAbstractItemView` | Исправлено |
| `QGraphicsView` | `(no parent)` | `QAbstractScrollArea` | Исправлено (`gen_qgraphicsscene.h`) |
| `QVBoxLayout` / `QHBoxLayout` / `QGridLayout` / `QFormLayout` | `(no parent)` | `QObject` | Исправлено (`gen_qlayout.h`) |
| `QThread` | `(no parent)` | `QObject` | Исправлено |

Все перечисленные классы теперь находятся в правильной иерархии и собираются в `test_gui.exe`.

### 6.2 `QApplication` не наследует `QObject`

`QApplication` в `gen_qcore.h` остаётся отдельным классом, управляющим `pFunQt[]` и `app->exec()`. Это сделано осознанно: он единственный, не требует полиморфного `getWH()` и имеет специфичное завершение через `deleteApp()`.

### 6.3 Value-type классы без наследования

Классы-значения (`QSize`, `QPoint`, `QRect`, `QDate`, `QTime`, `QDateTime`, `QColor`, `QFont`, `QIcon`, `QPixmap`, `QByteArray` и др.) не наследуют `QObject` и работают как обёртки над Qt value-types. Это корректно.

---

## 7. Проверочный список (выполнено)

- [x] Создать `gen/gen_qobject.h` с `class QObject`
- [x] Создать `gen/gen_qwidget.h` с `class QWidget : public QObject`
- [x] Создать `gen/gen_qabstractbutton.h` с `class QAbstractButton : public QWidget`
- [x] Создать `gen/gen_qframe.h` с `class QFrame : public QWidget`
- [x] Создать `gen/gen_qdialog.h` с `class QDialog : public QWidget`
- [x] Создать `gen/gen_qabstractslider.h` с `class QAbstractSlider : public QWidget`
- [x] Создать `gen/gen_qabstractspinbox.h` с `class QAbstractSpinBox : public QWidget`
- [x] Создать `gen/gen_qabstractscrollarea.h` с `class QAbstractScrollArea : public QFrame`
- [x] Создать `gen/gen_qabstractitemview.h` с `class QAbstractItemView : public QAbstractScrollArea`
- [x] Переделать `QCheckBox` / `QPushButton` / `QRadioButton` / `QToolButton` на `QAbstractButton`
- [x] Переделать `QSlider` / `QScrollBar` / `QDial` на `QAbstractSlider`
- [x] Переделать `QSpinBox` / `QDoubleSpinBox` / `QDateTimeEdit` на `QAbstractSpinBox`
- [x] Переделать `QLabel` / `QLCDNumber` / `QSplitter` / `QStackedWidget` / `QToolBox` на `QFrame`
- [x] Переделать `QPlainTextEdit` / `QTextEdit` / `QsciScintilla` на `QAbstractScrollArea`
- [x] Переделать `QTextBrowser` на `QTextEdit`
- [x] Переделать `QTableView` / `QTreeView` на `QAbstractItemView`
- [x] Переделать `QColorDialog` / `QFileDialog` / `QFontDialog` / `QProgressDialog` на `QDialog`
- [x] Переделать `QMessageBox` / `QInputDialog` на `QDialog`
- [x] Переделать `QScrollArea` на `QAbstractScrollArea`
- [x] Переделать `QSplashScreen` / `QTabBar` / `QDesktopWidget` на `QWidget`
- [x] Переделать `QShortcut` / `QTimer` / `QSettings` / `QSystemTrayIcon` / `QClipboard` / `QCompleter` / `QSyntaxHighlighter` / `QProcess` / `QTextDocument` на `QObject`
- [x] Переделать `QMainWindow` / `QMenu` / `QMenuBar` / `QToolBar` / `QStatusBar` на `QWidget`
- [x] Переделать `QHeaderView` на `QAbstractItemView`
- [x] Переделать `QGraphicsView` на `QAbstractScrollArea`
- [x] Переделать `QVBoxLayout` / `QHBoxLayout` / `QGridLayout` / `QFormLayout` на `QObject`
- [x] Переделать `QThread` на `QObject`
- [x] Проверить компиляцию всех модулей
- [x] Запустить `test/test_gui.exe` с полным набором виджетов и сигналов

---

## 8. Как добавлять новый класс с наследованием

1. Определить родителя в QTE56.
2. Создать `gen/gen_qnewclass.h`:
   ```cpp
   #include "gen_<parent>.h"
   class QNewClass : public QParent {
   protected:
       QNewClass(bool _noOp);
   public:
       QNewClass(void* parent = QNULL);
       // только собственные методы QNewClass
   };
   ```
3. В `gen/gen_qnewclass.cpp` конструктор вызывает `QParent(true)` и затем создаёт `_wh` через `pFunQt[index]`.
4. Зарегистрировать модуль: `registerQNewClassModule()`.
5. В `main()` зарегистрировать всех предков перед `LoadQt()`.
6. Добавить `.obj` в `makefile`.

---

*Документ обновлён после реализации наследования и успешного запуска `test_gui.exe`.*
