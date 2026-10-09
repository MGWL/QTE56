# QTE56 Иерархия наследования классов

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

> **Определяющий документ для генерации DMC C++ классов.**
> 
> Этот документ описывает полную иерархию наследования всех классов QTE56.
> Генератор DMC должен строго следовать этой иерархии при создании C++ классов.

---

## 1. Корневые классы (без родителя)

Классы, не наследующие ни от кого. В DMC генерируются как `class X {`.

| Класс | D-модуль | DLL | Описание |
|-------|----------|-----|----------|
| `QObject` | `gen_qobject.d` | `qte56_foundation.dll` | Базовый класс всех Qt-объектов |
| `QApplication` | `gen_qcore.d` | `qte56_qcore.dll` | Приложение Qt |
| `QCoreApplication` | `gen_qcore.d` | `qte56_qcore.dll` | Консольное приложение |
| `ESlot` | `gen_qcore.d` | `qte56_qcore.dll` | Слот для сигналов |
| `QBrush` | `gen_qbrush.d` | `qte56_drawing.dll` | Кисть для рисования |
| `QButtonGroup` | `gen_qbuttongroup.d` | `qte56_widgets.dll` | Группа кнопок |
| `QByteArray` | `gen_qbytearray.d` | `qte56_foundation.dll` | Массив байт |
| `QCalendarWidget` | `gen_qcalendarwidget.d` | `qte56_widgets.dll` | Календарь |
| `QClipboard` | `gen_qclipboard.d` | `qte56_foundation.dll` | Буфер обмена |
| `QColor` | `gen_qcolor.d` | `qte56_foundation.dll` | Цвет |
| `QCompleter` | `gen_qcompleter.d` | `qte56_completer.dll` | Автодополнение |
| `QDate` | `gen_qdate.d` | `qte56_foundation.dll` | Дата |
| `QTime` | `gen_qdate.d` | `qte56_foundation.dll` | Время |
| `QDateTime` | `gen_qdate.d` | `qte56_foundation.dll` | Дата/время |
| `QDesktopWidget` | `gen_qdesktopwidget.d` | `qte56_widgets.dll` | Рабочий стол |
| `QFile` | `gen_qfile.d` | `qte56_foundation.dll` | Файл |
| `QFileSystemWatcher` | `gen_qfilesystemwatcher.d` | `qte56_filewatcher.dll` | Наблюдатель файлов |
| `QFont` | `gen_qfont.d` | `qte56_foundation.dll` | Шрифт |
| `QFontMetrics` | `gen_qfontmetrics.d` | `qte56_drawing.dll` | Метрики шрифта |
| `QIcon` | `gen_qicon.d` | `qte56_foundation.dll` | Иконка |
| `QImage` | `gen_qimage.d` | `qte56_foundation.dll` | Изображение |
| `QImageReader` | `gen_qimagereader.d` | `qte56_foundation.dll` | Чтение изображений |
| `QImageWriter` | `gen_qimagereader.d` | `qte56_foundation.dll` | Запись изображений |
| `QInputDialog` | `gen_qinputdialog.d` | `qte56_dialogs.dll` | Диалог ввода |
| `QLCDNumber` | `gen_qlcdnumber.d` | `qte56_widgets.dll` | LCD число |
| `QMessageBox` | `gen_qmessagebox.d` | `qte56_dialogs.dll` | Сообщение |
| `QPalette` | `gen_qpalette.d` | `qte56_drawing.dll` | Палитра |
| `QPen` | `gen_qpen.d` | `qte56_drawing.dll` | Перо |
| `QPicture` | `gen_qpicture.d` | `qte56_foundation.dll` | Картинка |
| `QPixmap` | `gen_qpixmap.d` | `qte56_foundation.dll` | Пиксмап |
| `QProcess` | `gen_qprocess.d` | `qte56_qprocess.dll` | Процесс |
| `QSettings` | `gen_qsettings.d` | `qte56_foundation.dll` | Настройки |
| `QShortcut` | `gen_qshortcut.d` | `qte56_shortcut.dll` | Горячая клавиша |
| `QSound` | `gen_qsound.d` | `qte56_qsound.dll` | Звук |
| `QSoundEffect` | `gen_qsoundeffect.d` | `qte56_qsoundeffect.dll` | Эффект звука |
| `QSplashScreen` | `gen_qsplashscreen.d` | `qte56_systray.dll` | Заставка |
| `QSqlDatabase` | `gen_qsql.d` | `qte56_sql.dll` | База данных SQL |
| `QSqlQuery` | `gen_qsql.d` | `qte56_sql.dll` | SQL запрос |
| `QSyntaxHighlighter` | `gen_qsyntaxhighlighter.d` | `qte56_text.dll` | Подсветка синтаксиса |
| `QSystemTrayIcon` | `gen_qsystemtrayicon.d` | `qte56_systray.dll` | Иконка трея |
| `QTabBar` | `gen_qtabbar.d` | `qte56_widgets.dll` | Бар вкладок |
| `QTextBlock` | `gen_qtextblock.d` | `qte56_text.dll` | Блок текста |
| `QTextBlockFormat` | `gen_qtextblockformat.d` | `qte56_text.dll` | Формат блока |
| `QTextCharFormat` | `gen_qtextcharformat.d` | `qte56_text.dll` | Формат символа |
| `QTextCodec` | `gen_qtextcodec.d` | `qte56_textcodec.dll` | Кодек текста |
| `QTextCursor` | `gen_qtextcursor.d` | `qte56_text.dll` | Курсор текста |
| `QTextDocument` | `gen_qtextdocument.d` | `qte56_text.dll` | Документ текста |
| `QThread` | `gen_qthread.d` | `qte56_thread.dll` | Поток |
| `QMutex` | `gen_qthread.d` | `qte56_thread.dll` | Мьютекс |
| `QWaitCondition` | `gen_qthread.d` | `qte56_thread.dll` | Условие ожидания |
| `QSemaphore` | `gen_qthread.d` | `qte56_thread.dll` | Семафор |
| `QReadWriteLock` | `gen_qthread.d` | `qte56_thread.dll` | Блокировка чтения/записи |
| `QTimer` | `gen_qtimer.d` | `qte56_foundation.dll` | Таймер |
| `QUiLoader` | `gen_quiloader.d` | `qte56_uiloader.dll` | Загрузчик UI |
| `QXlsxDocument` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Excel документ |
| `QXlsxFormat` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Формат Excel |
| `QXlsxCellReference` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Ссылка на ячейку |
| `QXlsxCellRange` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Диапазон ячеек |
| `QXlsxChart` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | График |
| `QXlsxConditionalFormatting` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Условное форматирование |
| `QXlsxRichString` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Rich текст |
| `QXlsxDataValidation` | `gen_qxlsx.d` | `qte56_qxlsx.dll` | Валидация данных |

---

## 2. Иерархия наследования

### 2.1 QObject → QWidget

```
QObject
├── QWidget
│   ├── QAbstractButton
│   │   ├── QCheckBox
│   │   ├── QPushButton
│   │   │   └── QCommandLinkButton
│   │   ├── QRadioButton
│   │   └── QToolButton
│   ├── QAbstractSlider
│   │   ├── QDial
│   │   ├── QScrollBar
│   │   └── QSlider
│   ├── QAbstractSpinBox
│   │   ├── QDateTimeEdit
│   │   │   ├── QDateEdit
│   │   │   └── QTimeEdit
│   │   ├── QDoubleSpinBox
│   │   └── QSpinBox
│   ├── QComboBox
│   ├── QDialog
│   │   ├── QColorDialog
│   │   ├── QFileDialog
│   │   ├── QFontDialog
│   │   └── QProgressDialog
│   ├── QDockWidget
│   ├── QFrame
│   │   ├── QAbstractScrollArea
│   │   │   ├── QAbstractItemView
│   │   │   │   ├── QListWidget
│   │   │   │   ├── QTableView
│   │   │   │   │   └── QTableWidget
│   │   │   │   └── QTreeView
│   │   │   │       └── QTreeWidget
│   │   │   ├── QMdiArea
│   │   │   ├── QPlainTextEdit
│   │   │   ├── QsciScintilla
│   │   │   └── QTextEdit
│   │   │       └── QTextBrowser
│   │   ├── QLabel
│   │   ├── QLCDNumber
│   │   ├── QSplitter
│   │   ├── QStackedWidget
│   │   └── QToolBox
│   ├── QGroupBox
│   ├── QLineEdit
│   ├── QMainWindow
│   ├── QMenu
│   ├── QMenuBar
│   ├── QProgressBar
│   ├── QScrollArea
│   ├── QStatusBar
│   ├── QTabWidget
│   ├── QToolBar
│   └── QWidget (base)
├── QAction
├── QGraphicsScene
├── QMediaPlayer
├── QSound
├── QSoundEffect
└── QObject (base)
```

### 2.2 Layout-ы (не наследуют QWidget)

```
QLayout (базовый, не класс QTE56)
├── QVBoxLayout
├── QHBoxLayout
├── QGridLayout
└── QFormLayout
```

### 2.3 Item-классы (не наследуют QObject)

```
QListWidgetItem
QTableWidgetItem
QTreeWidgetItem
QGraphicsPixmapItem
QGraphicsTextItem
QGraphicsRectItem
QGraphicsEllipseItem
```

### 2.4 Сетевые классы

```
QUrl
QNetworkRequest
QNetworkReply
QNetworkAccessManager
```

### 2.5 QsciScintilla дополнительные

```
QsciScintilla : QAbstractScrollArea
QsciAPIs
```

---

## 3. Таблица наследования (Class → Parent → D-модуль → DLL)

| Класс | Родитель | D-модуль | DLL |
|-------|----------|----------|-----|
| `QObject` | — | `gen_qobject.d` | `qte56_foundation.dll` |
| `QWidget` | `QObject` | `gen_qwidget.d` | `qte56_widgets.dll` |
| `QAbstractButton` | `QWidget` | `gen_qabstractbutton.d` | `qte56_widgets.dll` |
| `QCheckBox` | `QAbstractButton` | `gen_qcheckbox.d` | `qte56_widgets.dll` |
| `QPushButton` | `QAbstractButton` | `gen_qpushbutton.d` | `qte56_widgets.dll` |
| `QCommandLinkButton` | `QPushButton` | `gen_qcommandlinkbutton.d` | `qte56_widgets.dll` |
| `QRadioButton` | `QAbstractButton` | `gen_qradiobutton.d` | `qte56_widgets.dll` |
| `QToolButton` | `QAbstractButton` | `gen_qtoolbutton.d` | `qte56_widgets.dll` |
| `QAbstractSlider` | `QWidget` | `gen_qabstractslider.d` | `qte56_widgets.dll` |
| `QDial` | `QAbstractSlider` | `gen_qdial.d` | `qte56_widgets.dll` |
| `QScrollBar` | `QAbstractSlider` | `gen_qscrollbar.d` | `qte56_widgets.dll` |
| `QSlider` | `QAbstractSlider` | `gen_qslider.d` | `qte56_widgets.dll` |
| `QAbstractSpinBox` | `QWidget` | `gen_qabstractspinbox.d` | `qte56_widgets.dll` |
| `QDateTimeEdit` | `QAbstractSpinBox` | `gen_qdatetimeedit.d` | `qte56_widgets.dll` |
| `QDateEdit` | `QDateTimeEdit` | `gen_qdatetimeedit.d` | `qte56_widgets.dll` |
| `QTimeEdit` | `QDateTimeEdit` | `gen_qdatetimeedit.d` | `qte56_widgets.dll` |
| `QDoubleSpinBox` | `QAbstractSpinBox` | `gen_qdoublespinbox.d` | `qte56_widgets.dll` |
| `QSpinBox` | `QAbstractSpinBox` | `gen_qspinbox.d` | `qte56_widgets.dll` |
| `QComboBox` | `QWidget` | `gen_qcombobox.d` | `qte56_widgets.dll` |
| `QDialog` | `QWidget` | `gen_qdialog.d` | `qte56_dialogs.dll` |
| `QColorDialog` | `QDialog` | `gen_qcolordialog.d` | `qte56_dialogs.dll` |
| `QFileDialog` | `QDialog` | `gen_qfiledialog.d` | `qte56_dialogs.dll` |
| `QFontDialog` | `QDialog` | `gen_qfontdialog.d` | `qte56_dialogs.dll` |
| `QProgressDialog` | `QDialog` | `gen_qprogressdialog.d` | `qte56_dialogs.dll` |
| `QDockWidget` | `QWidget` | `gen_qdockwidget.d` | `qte56_widgets.dll` |
| `QFrame` | `QWidget` | `gen_qframe.d` | `qte56_widgets.dll` |
| `QAbstractScrollArea` | `QFrame` | `gen_qabstractscrollarea.d` | `qte56_views.dll` |
| `QAbstractItemView` | `QAbstractScrollArea` | `gen_qabstractitemview.d` | `qte56_views.dll` |
| `QListWidget` | `QAbstractItemView` | `gen_qlistwidget.d` | `qte56_views.dll` |
| `QTableView` | `QAbstractItemView` | `gen_qtableview.d` | `qte56_views.dll` |
| `QTableWidget` | `QTableView` | `gen_qtablewidget.d` | `qte56_views.dll` |
| `QTreeView` | `QAbstractItemView` | `gen_qtreeview.d` | `qte56_views.dll` |
| `QTreeWidget` | `QTreeView` | `gen_qtreewidget.d` | `qte56_views.dll` |
| `QMdiArea` | `QAbstractScrollArea` | `gen_qmdiarea.d` | `qte56_views.dll` |
| `QPlainTextEdit` | `QAbstractScrollArea` | `gen_qplaintextedit.d` | `qte56_text.dll` |
| `QsciScintilla` | `QAbstractScrollArea` | `gen_qscintilla.d` | `qte56_qscintilla.dll` |
| `QTextEdit` | `QAbstractScrollArea` | `gen_qtextedit.d` | `qte56_text.dll` |
| `QTextBrowser` | `QTextEdit` | `gen_qtextbrowser.d` | `qte56_text.dll` |
| `QLabel` | `QFrame` | `gen_qlabel.d` | `qte56_widgets.dll` |
| `QLCDNumber` | `QFrame` | `gen_qlcdnumber.d` | `qte56_widgets.dll` |
| `QSplitter` | `QFrame` | `gen_qsplitter.d` | `qte56_widgets.dll` |
| `QStackedWidget` | `QFrame` | `gen_qstackedwidget.d` | `qte56_widgets.dll` |
| `QToolBox` | `QFrame` | `gen_qtoolbox.d` | `qte56_widgets.dll` |
| `QGroupBox` | `QWidget` | `gen_qgroupbox.d` | `qte56_widgets.dll` |
| `QLineEdit` | `QWidget` | `gen_qlineedit.d` | `qte56_widgets.dll` |
| `QMainWindow` | `QWidget` | `gen_qmainwindow.d` | `qte56_mainwin.dll` |
| `QMenu` | `QWidget` | `gen_qmenu.d` | `qte56_mainwin.dll` |
| `QMenuBar` | `QWidget` | `gen_qmenubar.d` | `qte56_mainwin.dll` |
| `QProgressBar` | `QWidget` | `gen_qprogressbar.d` | `qte56_widgets.dll` |
| `QScrollArea` | `QAbstractScrollArea` | `gen_qscrollarea.d` | `qte56_views.dll` |
| `QStatusBar` | `QWidget` | `gen_qstatusbar.d` | `qte56_mainwin.dll` |
| `QTabWidget` | `QWidget` | `gen_qtabwidget.d` | `qte56_widgets.dll` |
| `QToolBar` | `QWidget` | `gen_qtoolbar.d` | `qte56_mainwin.dll` |
| `QAction` | `QObject` | `gen_qaction.d` | `qte56_mainwin.dll` |
| `QGraphicsScene` | `QObject` | `gen_qgraphicsscene.d` | `qte56_qgraphicsscene.dll` |
| `QMediaPlayer` | `QObject` | `gen_qmediaplayer.d` | `qte56_qmediaplayer.dll` |
| `QSound` | `QObject` | `gen_qsound.d` | `qte56_qsound.dll` |
| `QSoundEffect` | `QObject` | `gen_qsoundeffect.d` | `qte56_qsoundeffect.dll` |

---

## 4. Правила генерации DMC C++

### 4.1 Наследование

```cpp
// Базовый класс (QObject или без родителя)
class QObject {
protected:
    void* _wh;
public:
    void* getWH() const { return _wh; }
};

// Производный класс
class QWidget : public QObject {
    // _wh наследуется от QObject
};

class QPushButton : public QAbstractButton {
    // _wh наследуется от QAbstractButton → QWidget → QObject
};
```

### 4.2 Include-цепочка

```cpp
// gen_qpushbutton.h
#include "gen_qabstractbutton.h"  // прямой родитель
// gen_qabstractbutton.h включает gen_qwidget.h
// gen_qwidget.h включает gen_qobject.h
// gen_qobject.h включает qte5dmc_core.h
```

### 4.3 Порядок генерации

Классы должны генерироваться в порядке от корня к листьям:

1. `QObject` → `QWidget` → `QFrame` → `QAbstractScrollArea` → `QAbstractItemView` → `QListWidget`
2. `QObject` → `QWidget` → `QAbstractButton` → `QPushButton` → `QCommandLinkButton`

### 4.4 Загрузка DLL

Каждый класс регистрирует свои pFunQt индексы через `loadFn()`:

```cpp
void loadQPushButton() {
    pFunQt[400] = loadFn("QPushButton", "qteQPushButton_create");
    // ... остальные индексы
}
```

Родительские индексы загружаются отдельно через `loadQAbstractButton()`.

---

## 5. Примечания для генератора

1. **Корневые классы** (QObject, QBrush, QColor и т.д.) — не имеют `public <Parent>`, `_wh` объявляется внутри класса.

2. **Производные классы** — имеют `public <Parent>`, `_wh` наследуется (protected).

3. **Конструкторы** — инициализируют `_wh` напрямую через свой `pFunQt[create_idx]`.

4. **Деструкторы** — пустые (как в ручном коде DMC).

5. **Методы** — генерируются все для каждого класса (включая унаследованные), чтобы избежать сложного разделения.

6. **Event handlers** (`onMousePress`, `onKeyPress` и т.д.) — override методы, вызывают `setEventHandler()`.

7. **Connect-методы** (`connect_clicked` и т.д.) — используют `connectQt()`, не pFunQt.

8. **String getters** (`text()`, `windowTitle()` и т.д.) — возвращают `int` (буферный паттерн).

9. **String setters** (`setText()`, `setWindowTitle()` и т.д.) — принимают `const char*`, конвертируют в QString.

10. **Bool параметры** — передаются как `p0 ? 1 : 0` (int для C ABI).

11. **Структуры** (`DSize`, `DPoint`, `DRect`) — возвращаются через unpack-функции (pFunQt[37], [34], [31]).

---

*Документ сгенерирован автоматически на основе анализа d/gen/gen_q*.d файлов.*
*Дата: 2026-06-23*
