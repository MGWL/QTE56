"""
qt_hierarchy.py — иерархия Qt классов, извлечённая из qte56.d (Gen1).

Источник: C:/gpt/qte56/qte56.d
Дата анализа: 2026-02-26

Используется генератором Gen2 для:
  - Автоматического определения D-родителя при генерации класса
  - Выбора промежуточных классов (QFrame, QAbstractButton, ...)
  - Дедупликации методов при D-наследовании

Не парсится каждый раз — хранится как статические данные.
"""

# ─────────────────────────────────────────────────────────────────────────────
# Полная иерархия из qte56.d: {ClassName: ParentClass}
# ROOT означает отсутствие родителя в D-смысле.
# ─────────────────────────────────────────────────────────────────────────────

QT_PARENTS = {
    # Корневые классы
    "QObject":                  None,
    "QtE":                      None,           # утилитарный enum-класс
    "QLagrangeInterpolator":    None,           # нет родителя
    "QMathGraphics":            None,
    "QTurtleState":             None,
    "QTurtle":                  None,
    "QLSystemParameters":       None,
    "QLSystem":                 None,

    # QObject → ...
    "QPalette":                 "QObject",
    "QFormBuilder":             "QObject",
    "QColor":                   "QObject",
    "QBrush":                   "QObject",
    "QByteArray":               "QObject",
    "QString":                  "QObject",
    "QStringList":              "QObject",
    "QSize":                    "QObject",
    "QPainter":                 "QObject",
    "QFont":                    "QObject",
    "QIcon":                    "QObject",
    "QPen":                     "QObject",
    "QDate":                    "QObject",
    "QTime":                    "QObject",
    "QAction":                  "QObject",
    "QTableWidgetItem":         "QObject",
    "QTextDocument":            "QObject",
    "QTextCursor":              "QObject",
    "QTextBlock":               "QObject",
    "QTextOption":              "QObject",
    "QFontMetrics":             "QObject",
    "QPoint":                   "QObject",
    "QRect":                    "QObject",
    "QTimer":                   "QObject",
    "QResource":                "QObject",
    "QUrl":                     "QObject",
    "QTranslator":              "QObject",
    "QTextCodec":               "QObject",
    "QEvent":                   "QObject",
    "QEndApplication":          "QObject",
    "Highlighter":              "QObject",       # пользовательский класс Gen1
    "HighlighterM":             "QObject",       # пользовательский класс Gen1

    # QEvent → ...
    "QResizeEvent":             "QEvent",
    "QKeyEvent":                "QEvent",
    "QWheelEvent":              "QEvent",
    "QMouseEvent":              "QEvent",

    # QObject → QLayout → ...
    "QLayout":                  "QObject",
    "QGridLayout":              "QObject",      # в Gen1 ошибочно, реально : QLayout
    "QBoxLayout":               "QLayout",
    "QVBoxLayout":              "QBoxLayout",
    "QHBoxLayout":              "QBoxLayout",

    # QObject → QCoreApplication → ...
    "QCoreApplication":         "QObject",
    "QGuiApplication":          "QCoreApplication",
    "QApplication":             "QGuiApplication",

    # QObject → JS/Script движки
    "QJSEngine":                "QObject",
    "QQmlEngine":               "QJSEngine",
    "QQmlApplicationEngine":    "QQmlEngine",
    "QScriptEngine":            "QObject",
    "QScriptValue":             "QObject",
    "QScriptContext":           "QObject",

    # QObject → QPaintDevice → ...
    "QPaintDevice":             "QObject",
    "QImage":                   "QPaintDevice",
    "QPixmap":                  "QPaintDevice",
    "QBitmap":                  "QPixmap",

    # QPaintDevice → QWidget → ...  (главная ветка виджетов)
    "QWidget":                  "QPaintDevice",

    # QWidget → прямые наследники
    "QAbstractButton":          "QWidget",
    "QFrame":                   "QWidget",
    "QTabWidget":               "QWidget",
    "QDockWidget":              "QWidget",
    "QLineEdit":                "QWidget",
    "QMainWindow":              "QWidget",
    "QStatusBar":               "QWidget",
    "QMenu":                    "QWidget",
    "QMenuBar":                 "QWidget",
    "QToolBar":                 "QWidget",
    "QDialog":                  "QWidget",
    "QProgressBar":             "QWidget",
    "QMdiSubWindow":            "QWidget",
    "QComboBox":                "QWidget",
    "QAbstractSlider":          "QWidget",
    "QGroupBox":                "QWidget",
    "QAbstractSpinBox":         "QWidget",
    "QCalendarWidget":          "QWidget",
    "QTabBar":                  "QWidget",      # Gen2: qte56_qtabbar.dll (16000–16057)
    "QScintilla":               "QWidget",
    "QWebView":                 "QWidget",
    "QWebEngView":              "QWidget",

    # QAbstractButton → ...
    "QPushButton":              "QAbstractButton",
    "QCheckBox":                "QAbstractButton",
    "QRadioButton":             "QAbstractButton",
    "QCommandLinkButton":       "QPushButton",

    # QFrame → ...
    "QSplitter":                "QFrame",
    "QLabel":                   "QFrame",
    "QLCDNumber":               "QFrame",
    "QStackedWidget":           "QFrame",
    "QToolBox":                 "QFrame",
    "QAbstractScrollArea":      "QFrame",

    # QAbstractScrollArea → ...
    "QPlainTextEdit":           "QAbstractScrollArea",
    "QTextEdit":                "QAbstractScrollArea",
    "QTextBrowser":             "QTextEdit",
    "QMdiArea":                 "QAbstractScrollArea",
    "QAbstractItemView":        "QAbstractScrollArea",

    # QAbstractItemView → ...
    "QHeaderView":              "QAbstractItemView",
    "QTableView":               "QAbstractItemView",
    "QTableWidget":             "QTableView",

    # QAbstractSlider → ...
    "QSlider":                  "QAbstractSlider",

    # QAbstractSpinBox → ...
    "QDateTimeEdit":            "QAbstractSpinBox",
    "QSpinBox":                 "QAbstractSpinBox",
    "QDateEdit":                "QDateTimeEdit",

    # QDialog → ...
    "QMessageBox":              "QDialog",
    "QFileDialog":              "QDialog",
}


# ─────────────────────────────────────────────────────────────────────────────
# Полная цепочка предков для каждого Qt класса (memoized)
# Пример: ancestors("QLabel") → ["QFrame", "QWidget", "QPaintDevice", "QObject"]
# ─────────────────────────────────────────────────────────────────────────────

def ancestors(cls: str) -> list[str]:
    """Возвращает список предков от ближайшего к корню."""
    result = []
    current = QT_PARENTS.get(cls)
    while current:
        result.append(current)
        current = QT_PARENTS.get(current)
    return result


def is_qwidget_subclass(cls: str) -> bool:
    """True если класс является подклассом QWidget."""
    return "QWidget" in ancestors(cls) or cls == "QWidget"


# ─────────────────────────────────────────────────────────────────────────────
# D-иерархия для Gen2 (полная, с промежуточными классами)
#
# Используется генератором как единственный источник D-родителей.
# Плоская иерархия (D_PARENT_FLAT) удалена как устаревшая.
#
# Требует генерации промежуточных DLL:
#   qte56_qframe.dll, qte56_qabstractbutton.dll,
#   qte56_qabstractslider.dll, qte56_qabstractspinbox.dll
# ─────────────────────────────────────────────────────────────────────────────

D_PARENT_FULL = {
    # Промежуточные (нужно сгенерировать новые DLL):
    "QFrame":               "QWidget",
    "QAbstractButton":      "QWidget",
    "QAbstractSlider":      "QWidget",
    "QAbstractSpinBox":     "QWidget",
    "QAbstractScrollArea":  "QFrame",
    "QMdiArea":             "QAbstractScrollArea",
    "QDateTimeEdit":        "QAbstractSpinBox",
    "QDateEdit":            "QDateTimeEdit",
    "QTimeEdit":            "QDateTimeEdit",
    "QCalendarWidget":      "QWidget",
    "QMdiSubWindow":        "QWidget",
    # Существующие в Gen2 — с правильными родителями:
    "QLabel":               "QFrame",
    "QSplitter":            "QFrame",           # Qt: QSplitter→QFrame→QWidget
    "QStackedWidget":       "QFrame",           # Qt: QStackedWidget→QFrame→QWidget
    "QPushButton":          "QAbstractButton",  # требует gen_qabstractbutton.d
    "QCheckBox":            "QAbstractButton",
    "QRadioButton":         "QAbstractButton",
    "QToolButton":          "QAbstractButton",  # Qt: QToolButton→QAbstractButton→QWidget
    "QCommandLinkButton":   "QPushButton",      # Qt: QCommandLinkButton→QPushButton→QAbstractButton
    "QDockWidget":          "QWidget",          # Qt: QDockWidget→QWidget
    "QToolBox":             "QFrame",           # Qt: QToolBox→QFrame→QWidget
    "QSpinBox":             "QAbstractSpinBox",
    "QDoubleSpinBox":       "QAbstractSpinBox", # Qt: QDoubleSpinBox→QAbstractSpinBox→QWidget
    "QSlider":              "QAbstractSlider",
    "QDial":                "QAbstractSlider",
    "QScrollBar":           "QAbstractSlider",
    "QLCDNumber":           "QFrame",
    "QPlainTextEdit":       "QAbstractScrollArea",
    "QTextEdit":            "QAbstractScrollArea",
    "QComboBox":            "QWidget",
    "QLineEdit":            "QWidget",
    "QProgressBar":         "QWidget",
    "QGroupBox":            "QWidget",
    "QTabWidget":           "QWidget",
    # Диалоги:
    "QDialog":              "QWidget",
    "QFileDialog":          "QDialog",
    # Списки (через QAbstractItemView):
    "QAbstractItemView":    "QAbstractScrollArea", # Qt: QAbstractItemView→QAbstractScrollArea→...
    "QListWidget":          "QAbstractItemView",   # Qt: QListWidget→QListView→QAbstractItemView→...
    "QTableView":           "QAbstractItemView",   # Qt: QTableView→QAbstractItemView→...
    "QTableWidget":         "QTableView",          # Qt: QTableWidget→QTableView→...
    "QTreeView":            "QAbstractItemView",   # Qt: QTreeView→QAbstractItemView→...
    "QTreeWidget":          "QTreeView",           # Qt: QTreeWidget→QTreeView→...
}


# ─────────────────────────────────────────────────────────────────────────────
# Статус реализации в Gen2 (arch_new)
# ─────────────────────────────────────────────────────────────────────────────

GEN2_STATUS = {
    #  Класс                  DLL-файл                           Индексы (из CSV)  Тест
    # ─── Core ────────────────────────────────────────────────────────────────────
    "QApplication":        ("qte56_qcore.dll",              "1–55",        None),
    "QObject":             ("qte56_qobject.dll",            "3600–3608",   None),
    # ─── QWidget и прямые наследники ─────────────────────────────────────────────
    "QWidget":             ("qte56_qwidget.dll",            "200–398",     "test_qwidget.d"),
    "QPushButton":         ("qte56_qpushbutton.dll",        "400–419",     "test_qpushbutton.d"),
    "QLayout":             ("qte56_qlayout.dll",            "600–618",     "test_qlayout.d"),
    "QLabel":              ("qte56_qlabel.dll",             "800–840",     "test_qlabel.d"),
    "QLineEdit":           ("qte56_qlineedit.dll",          "1000–1072",   "test_qlineedit.d"),
    "QCheckBox":           ("qte56_qcheckbox.dll",          "1200–1212",   "test_qcheckbox.d"),
    "QComboBox":           ("qte56_qcombobox.dll",          "1400–1460",   "test_qcombobox.d"),
    "QRadioButton":        ("qte56_qradiobutton.dll",       "1600–1630",   "test_qradiobutton.d"),
    "QSpinBox":            ("qte56_qspinbox.dll",           "1800–1855",   "test_qspinbox.d"),
    "QSlider":             ("qte56_qslider.dll",            "2000–2036",   "test_qslider.d"),
    "QProgressBar":        ("qte56_qprogressbar.dll",       "2200–2229",   "test_qprogressbar.d"),
    "QGroupBox":           ("qte56_qgroupbox.dll",          "2400–2417",   "test_qgroupbox.d"),
    "QTabWidget":          ("qte56_qtabwidget.dll",         "2600–2649",   "test_qtabwidget.d"),
    # ─── Промежуточные классы (Вариант 3) ────────────────────────────────────────
    "QFrame":              ("qte56_qframe.dll",             "2800–2819",   None),
    "QAbstractButton":     ("qte56_qabstractbutton.dll",    "3000–3029",   None),
    "QAbstractSlider":     ("qte56_qabstractslider.dll",    "3200–3229",   None),
    "QAbstractSpinBox":    ("qte56_qabstractspinbox.dll",   "3400–3437",   None),
    # ─── Прочие виджеты ──────────────────────────────────────────────────────────
    "QAction":             ("qte56_qaction.dll",            "3800–3831",   None),
    "QMenu":               ("qte56_qmenu.dll",              "4000–4049",   None),
    "QMenuBar":            ("qte56_qmenubar.dll",           "4200–4228",   None),
    "QTimer":              ("qte56_qtimer.dll",             "4400–4411",   None),
    "QDialog":             ("qte56_qdialog.dll",            "4600–4612",   None),
    "QMessageBox":         ("qte56_qmessagebox.dll",        "4800–4818",   None),
    "QPlainTextEdit":      ("qte56_qplaintextedit.dll",     "5000–5073",   None),
    "QScrollBar":          ("qte56_qscrollbar.dll",         "5200–5207",   None),
    "QDial":               ("qte56_qdial.dll",              "5400–5410",   None),
    "QStatusBar":          ("qte56_qstatusbar.dll",         "5600–5615",   None),
    "QLCDNumber":          ("qte56_qlcdnumber.dll",         "5800–5825",   None),
    "QProgressDialog":     ("qte56_qprogressdialog.dll",    "6000–6029",   None),
    "QMainWindow":         ("qte56_qmainwindow.dll",        "6200–6252",   None),
    "QToolBar":            ("qte56_qtoolbar.dll",           "6400–6433",   None),
    "QIcon":               ("qte56_qicon.dll",              "6600–6611",   None),
    "QFileDialog":         ("qte56_qfiledialog.dll",        "6800–6846",   "test_filedialog_listwidget_settings.d"),
    "QListWidget":         ("qte56_qlistwidget.dll",        "7000–7041",   None),
    "QSettings":           ("qte56_qsettings.dll",          "7200–7220",   None),
    # ─── Компактный блок (после reindex 2026-02-28) ──────────────────────────────
    "QAbstractScrollArea": ("qte56_qabstractscrollarea.dll","7400–7424",   None),
    "QMdiArea":            ("qte56_qmdiarea.dll",           "7600–7650",   None),
    "QMdiSubWindow":       ("qte56_qmdisubwindow.dll",      "7800–7823",   None),
    "QTextEdit":           ("qte56_qtextedit.dll",          "8000–8090",   None),
    "QSplitter":           ("qte56_qsplitter.dll",          "8200–8240",   None),
    "QStackedWidget":      ("qte56_qstackedwidget.dll",     "8400–8429",   None),
    "QDoubleSpinBox":      ("qte56_qdoublespinbox.dll",     "8600–8657",   None),
    "QAbstractItemView":   ("qte56_qabstractitemview.dll",  "8800–8877",   None),
    "QTableView":          ("qte56_qtableview.dll",         "9000–9046",   None),
    "QTableWidget":        ("qte56_qtablewidget.dll",       "9200–9262",   None),
    "QTreeView":           ("qte56_qtreeview.dll",          "9400–9448",   None),
    "QTreeWidget":         ("qte56_qtreewidget.dll",        "9600–9680",   None),
    "QHeaderView":         ("qte56_qheaderview.dll",        "9800–9868",   None),
    "QScrollArea":         ("qte56_qscrollarea.dll",        "10000–10016", None),
    "QFont":               ("qte56_qfont.dll",              "10200–10259", None),
    "QToolButton":         ("qte56_qtoolbutton.dll",        "10400–10445", None),
    "QCommandLinkButton":  ("qte56_qcommandlinkbutton.dll", "10600–10611", None),
    "QDockWidget":         ("qte56_qdockwidget.dll",        "10800–10816", None),
    "QToolBox":            ("qte56_qtoolbox.dll",           "11000–11025", None),
    "QTextBrowser":        ("qte56_qtextbrowser.dll",       "11200–11250", None),
    "QFontDialog":         ("qte56_qfontdialog.dll",        "12000–12017", None),
    "QColorDialog":        ("qte56_qcolordialog.dll",       "13000–13021", None),
    "QColor":              ("qte56_qcolor.dll",             "14000–14081", None),
    "QInputDialog":        ("qte56_qinputdialog.dll",       "15000–15062", None),
    "QTabBar":             ("qte56_qtabbar.dll",            "16000–16057", "test_qtabbar.d"),
    # ─── QDateTimeEdit / QDateEdit / QTimeEdit (одна DLL, три класса) ────────────
    "QDateTimeEdit":       ("qte56_qdatetimeedit.dll",      "17000–17046", "test_qdatetimeedit.d"),
    "QDateEdit":           ("qte56_qdatetimeedit.dll",      "17100–17106", "test_qdatetimeedit.d"),
    "QTimeEdit":           ("qte56_qdatetimeedit.dll",      "17200–17206", "test_qdatetimeedit.d"),
    "QCalendarWidget":     ("qte56_qcalendarwidget.dll",    "17300–17338", "test_qcalendarwidget.d"),
    "QClipboard":          ("qte56_qclipboard.dll",         "17400–17408", "test_clipboard_btngroup.d"),
    "QButtonGroup":        ("qte56_qbuttongroup.dll",       "17500–17510", "test_clipboard_btngroup.d"),
    # ─── Layout (single shared DLL) ───────────────────────────────────────────────
    "QLayout":             ("qte56_qlayout.dll",            "600–628",     None),
    # ─── Value types ────────────────────────────────────────────────────────────────
    "QPixmap":             ("qte56_qpixmap.dll",            "17600–17613", None),
    "QPainter":            ("qte56_qpainter.dll",           "18000–18199", None),
    # ─── Следующий свободный блок: 18200 ─────────────────────────────────────────
}

# Классы, которых нет в Gen2 (кандидаты на добавление)
GEN2_MISSING_WIDGETS = [
    # Все виджеты из приоритетного списка реализованы.
]


# ─────────────────────────────────────────────────────────────────────────────
# Что добавляет каждый промежуточный класс своим потомкам
# (методы, которые НЕ входят в QWidget)
# ─────────────────────────────────────────────────────────────────────────────

INTERMEDIATE_METHODS = {
    "QFrame": [
        "frameStyle", "setFrameStyle",
        "frameShape", "setFrameShape",
        "frameShadow", "setFrameShadow",
        "lineWidth", "setLineWidth",
        "midLineWidth", "setMidLineWidth",
        "frameWidth",
        "frameRect", "setFrameRect",
        "contentsRect",
    ],
    "QPushButton": [
        "autoDefault", "setAutoDefault",
        "isDefault", "setDefault",
        "setMenu", "menu",
        "setFlat", "isFlat",
        "showMenu",
    ],
    "QAbstractButton": [
        "text", "setText",
        "icon", "setIcon",
        "iconSize", "setIconSize",
        "shortcut", "setShortcut",
        "isCheckable", "setCheckable",
        "isChecked", "setChecked",
        "isDown", "setDown",
        "autoRepeat", "setAutoRepeat",
        "autoRepeatDelay", "setAutoRepeatDelay",
        "autoRepeatInterval", "setAutoRepeatInterval",
        "autoExclusive", "setAutoExclusive",
        "group",
        "click", "toggle",
        "animateClick",
    ],
    "QAbstractSlider": [
        "value", "setValue",
        "minimum", "setMinimum",
        "maximum", "setMaximum",
        "setRange",
        "singleStep", "setSingleStep",
        "pageStep", "setPageStep",
        "orientation", "setOrientation",
        "sliderPosition", "setSliderPosition",
        "hasTracking", "setTracking",
        "invertedAppearance", "setInvertedAppearance",
        "invertedControls", "setInvertedControls",
        "isSliderDown",
        "triggerAction",
    ],
    "QDateTimeEdit": [
        "date", "setDate", "time", "setTime", "dateTime", "setDateTime",
        "minimumDate", "setMinimumDate", "clearMinimumDate",
        "maximumDate", "setMaximumDate", "clearMaximumDate", "setDateRange",
        "minimumTime", "setMinimumTime", "clearMinimumTime",
        "maximumTime", "setMaximumTime", "clearMaximumTime",
        "minimumDateTime", "setMinimumDateTime", "clearMinimumDateTime",
        "maximumDateTime", "setMaximumDateTime", "clearMaximumDateTime",
        "displayFormat", "setDisplayFormat",
        "calendarPopup", "setCalendarPopup",
        "currentSection", "setCurrentSection",
        "currentSectionIndex", "setCurrentSectionIndex",
        "sectionCount", "sectionText", "sectionAt",
        "timeSpec", "setTimeSpec",
        "connect_dateTimeChanged", "connect_timeChanged", "connect_dateChanged",
    ],
    "QAbstractSpinBox": [
        "buttonSymbols", "setButtonSymbols",
        "correctionMode", "setCorrectionMode",
        "hasAcceptableInput",
        "cleanText",
        "text",
        "specialValueText", "setSpecialValueText",
        "wrapping", "setWrapping",
        "isReadOnly", "setReadOnly",
        "keyboardTracking", "setKeyboardTracking",
        "alignment", "setAlignment",
        "setFrame", "hasFrame",
        "setAccelerated", "isAccelerated",
        "setGroupSeparatorShown", "isGroupSeparatorShown",
        "interpretText",
        "event", "fixup", "stepBy",
        "stepUp", "stepDown",
        "selectAll", "clear",
    ],
    "QAbstractItemView": [
        "setModel", "model",
        "setSelectionModel", "selectionModel",
        "setItemDelegate", "itemDelegate",
        "setSelectionMode", "selectionMode",
        "setSelectionBehavior", "selectionBehavior",
        "setEditTriggers", "editTriggers",
        "setVerticalScrollMode", "verticalScrollMode", "resetVerticalScrollMode",
        "setHorizontalScrollMode", "horizontalScrollMode", "resetHorizontalScrollMode",
        "setAutoScroll", "hasAutoScroll",
        "setAutoScrollMargin", "autoScrollMargin",
        "setTabKeyNavigation", "tabKeyNavigation",
        "setDropIndicatorShown",
        "setDragEnabled", "dragEnabled",
        "setDragDropOverwriteMode", "dragDropOverwriteMode",
        "setDragDropMode", "dragDropMode",
        "setDefaultDropAction", "defaultDropAction",
        "setAlternatingRowColors", "alternatingRowColors",
        "setIconSize", "iconSize",
        "setTextElideMode", "textElideMode",
        "keyboardSearch",
        "sizeHintForRow", "sizeHintForColumn",
        "setItemDelegateForRow", "itemDelegateForRow",
        "setItemDelegateForColumn", "itemDelegateForColumn",
        "reset", "doItemsLayout", "selectAll", "clearSelection",
        "scrollToTop", "scrollToBottom",
    ],
    "QTableView": [
        "showGrid", "setShowGrid",
        "gridStyle", "setGridStyle",
        "isSortingEnabled", "setSortingEnabled",
        "wordWrap", "setWordWrap",
        "isCornerButtonEnabled", "setCornerButtonEnabled",
        "rowHeight", "setRowHeight",
        "columnWidth", "setColumnWidth",
        "rowViewportPosition", "columnViewportPosition",
        "rowAt", "columnAt",
        "isRowHidden", "setRowHidden",
        "isColumnHidden", "setColumnHidden",
        "setSpan", "clearSpans",
        "selectRow", "selectColumn",
        "hideRow", "hideColumn", "showRow", "showColumn",
        "resizeRowToContents", "resizeRowsToContents",
        "resizeColumnToContents", "resizeColumnsToContents",
        "sortByColumn",
    ],
    "QTreeView": [
        "autoExpandDelay", "setAutoExpandDelay",
        "indentation", "setIndentation", "resetIndentation",
        "rootIsDecorated", "setRootIsDecorated",
        "uniformRowHeights", "setUniformRowHeights",
        "itemsExpandable", "setItemsExpandable",
        "expandsOnDoubleClick", "setExpandsOnDoubleClick",
        "columnViewportPosition", "columnWidth", "setColumnWidth", "columnAt",
        "isColumnHidden", "setColumnHidden",
        "isHeaderHidden", "setHeaderHidden",
        "setSortingEnabled", "isSortingEnabled",
        "setAnimated", "isAnimated",
        "setAllColumnsShowFocus", "allColumnsShowFocus",
        "setWordWrap", "wordWrap",
        "setTreePosition", "treePosition",
        "hideColumn", "showColumn",
        "resizeColumnToContents",
        "sortByColumn",
        "expandAll", "collapseAll", "expandToDepth",
        "expandRecursively",
        "selectAll",
    ],
    "QAbstractScrollArea": [
        "verticalScrollBarPolicy", "setVerticalScrollBarPolicy",
        "verticalScrollBar", "setVerticalScrollBar",
        "horizontalScrollBarPolicy", "setHorizontalScrollBarPolicy",
        "horizontalScrollBar", "setHorizontalScrollBar",
        "cornerWidget", "setCornerWidget",
        "addScrollBarWidget",
        "viewport", "setViewport",
        "maximumViewportSize",
        "setupViewport",
        "sizeAdjustPolicy", "setSizeAdjustPolicy",
    ],
}


# ─────────────────────────────────────────────────────────────────────────────
# Вспомогательные функции
# ─────────────────────────────────────────────────────────────────────────────

def get_gen2_dll(cls: str) -> str | None:
    """Возвращает имя DLL для класса Gen2, или None если не реализован."""
    info = GEN2_STATUS.get(cls)
    return info[0] if info else None


def get_gen2_indices(cls: str) -> str | None:
    """Возвращает диапазон индексов для класса Gen2."""
    info = GEN2_STATUS.get(cls)
    return info[1] if info else None


def next_free_block() -> int:
    """Возвращает следующий свободный блок индексов (кратный 1000)."""
    return 17000


def print_widget_tree(root: str = "QWidget", indent: int = 0,
                       show_gen2: bool = True) -> None:
    """Выводит дерево виджетов начиная с root."""
    gen2 = " [Gen2]" if root in GEN2_STATUS else ""
    prefix = "  " * indent + ("- " if indent else "")
    print(prefix + root + gen2)
    children = [c for c, p in QT_PARENTS.items() if p == root]
    for child in sorted(children):
        print_widget_tree(child, indent + 1, show_gen2)


# ─────────────────────────────────────────────────────────────────────────────
# Быстрая проверка при запуске напрямую
# ─────────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("=== Дерево виджетов QWidget ===")
    print_widget_tree("QWidget")

    print()
    print("=== Цепочки предков ключевых классов ===")
    for cls in ["QLabel", "QPushButton", "QSlider", "QSpinBox", "QTableWidget"]:
        chain = [cls] + ancestors(cls)
        print(f"  {cls}: {' -> '.join(chain)}")

    print()
    print("=== D-иерархия ===")
    for cls, parent in D_PARENT_FULL.items():
        new = " <- NEW DLL needed" if cls not in GEN2_STATUS else ""
        print(f"  class {cls:<25} : {parent}{new}")

    print()
    print(f"=== Следующий свободный индексный блок: {next_free_block()} ===")
