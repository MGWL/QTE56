/**
 * qte56_forms.d — Загрузка форм Qt Designer (.ui) и удобный доступ к виджетам.
 *
 * Workflow:
 *   auto form = QForm.load("dialog.ui");       // загрузить форму
 *   auto btn  = form.findButton("btnOk");       // получить кнопку по objectName
 *   auto edit = form.findLineEdit("editName");  // получить поле ввода
 *   btn.connect_clicked(mySlot);               // подключить сигнал
 *   form.show();                               // показать форму
 *
 * Все find*-методы возвращают null если виджет с таким именем не найден.
 * Возвращаемые объекты НЕ владеют Qt-указателем — форма является родителем.
 */
module qte56_forms;

import gen_quiloader   : QUiLoader, findChildWidget, findChildAction;
import gen_qwidget     : QWidget;
import gen_qlabel      : QLabel;
import gen_qpushbutton : QPushButton;
import gen_qlineedit   : QLineEdit;
import gen_qcheckbox   : QCheckBox;
import gen_qradiobutton: QRadioButton;
import gen_qcombobox   : QComboBox;
import gen_qspinbox    : QSpinBox;
import gen_qdoublespinbox : QDoubleSpinBox;
import gen_qtextedit   : QTextEdit;
import gen_qplaintextedit : QPlainTextEdit;
import gen_qgroupbox   : QGroupBox;
import gen_qtabwidget  : QTabWidget;
import gen_qslider     : QSlider;
import gen_qprogressbar: QProgressBar;
import gen_qdialog     : QDialog;
import gen_qaction     : QAction;

// ── QForm — обёртка над загруженной формой ────────────────────────────────────

/**
 * Загруженная форма Qt Designer.
 *
 * Содержит корневой виджет и предоставляет typed find*-методы.
 * Форма является родителем всех дочерних виджетов; их удаление
 * происходит автоматически при уничтожении корневого виджета.
 *
 * Уничтожение: wrap()-объекты (_qt_owned=true) не удаляют Qt-объект.
 * Корневой виджет удаляется при destroy(form) или GC.
 */
class QForm {
private:
    void* _rootWH;    // корневой QWidget* загруженной формы
    bool  _owned;     // true → удалять при ~this

    this() {}

public:
    // ── Фабрика ────────────────────────────────────────────────────────────────

    /**
     * Загрузить .ui файл и создать QForm.
     *
     * Params:
     *   path   = путь к .ui файлу (файловая система или ":/..." ресурс)
     *   parent = родительский виджет (null → top-level)
     *
     * Returns: QForm или null при ошибке (файл не найден, ошибка парсинга).
     */
    static QForm load(string path, void* parent = null) {
        auto loader = new QUiLoader();
        void* rootWH = loader.load(path, parent);
        if (rootWH is null) return null;
        auto form = new QForm();
        form._rootWH = rootWH;
        form._owned  = (parent is null);   // владеем если нет родителя
        return form;
    }

    /**
     * Обернуть уже загруженный Qt-виджет как QForm.
     * Полезно если вы загружаете форму другим способом.
     */
    static QForm fromWidget(void* widgetWH, bool takeOwnership = false) {
        if (widgetWH is null) return null;
        auto form = new QForm();
        form._rootWH = widgetWH;
        form._owned  = takeOwnership;
        return form;
    }

    ~this() {
        // Если форма не имеет Qt-родителя, удаляем корневой виджет.
        // Это удалит все дочерние виджеты через Qt parent-child механизм.
        if (_owned && _rootWH !is null) {
            import qte56_core : pFunQt;
            import gen_qcore : t_v__qp;
            if (pFunQt[201] !is null)
                (cast(t_v__qp)pFunQt[201])(_rootWH);
            _rootWH = null;
        }
    }

    // ── Доступ к корневому виджету ─────────────────────────────────────────────

    /// Сырой указатель на корневой QWidget*.
    void* getWH() { return _rootWH; }

    // ── Показать / скрыть ──────────────────────────────────────────────────────

    void show() {
        import qte56_core : pFunQt;
        import gen_qcore : t_v__qp;
        (cast(t_v__qp)pFunQt[202])(_rootWH);  // qteQWidget_show
    }

    void hide() {
        import qte56_core : pFunQt;
        import gen_qcore : t_v__qp;
        (cast(t_v__qp)pFunQt[337])(_rootWH);  // qteQWidget_hide
    }

    void resize(int w, int h) {
        import qte56_core : pFunQt;
        import gen_qcore : t_v__qp_i_i;
        (cast(t_v__qp_i_i)pFunQt[348])(_rootWH, w, h);  // qteQWidget_resize_ii
    }

    void setWindowTitle(string title) {
        import qte56_core : pFunQt;
        import gen_qcore : t_v__qp, t_v__qp_qp, toQString;
        auto wt = toQString(title);
        (cast(t_v__qp_qp)pFunQt[203])(_rootWH, wt);
        (cast(t_v__qp)pFunQt[22])(wt);
    }

    // ── Поиск дочерних виджетов ────────────────────────────────────────────────

    /**
     * Найти любой дочерний виджет по objectName. Возвращает void*.
     * Используй типизированные find*-методы для удобства.
     */
    void* findWidget(string name) {
        return findChildWidget(_rootWH, name);
    }

    // Вспомогательный шаблон — находит виджет и оборачивает его
    private void* _find(string name) {
        return findChildWidget(_rootWH, name);
    }

    /// Найти QLabel по objectName.
    QLabel findLabel(string name) {
        void* wh = _find(name);
        return wh ? QLabel.wrap(wh) : null;
    }

    /// Найти QPushButton по objectName.
    QPushButton findButton(string name) {
        void* wh = _find(name);
        return wh ? QPushButton.wrap(wh) : null;
    }

    /// Найти QLineEdit по objectName.
    QLineEdit findLineEdit(string name) {
        void* wh = _find(name);
        return wh ? QLineEdit.wrap(wh) : null;
    }

    /// Найти QCheckBox по objectName.
    QCheckBox findCheckBox(string name) {
        void* wh = _find(name);
        return wh ? QCheckBox.wrap(wh) : null;
    }

    /// Найти QRadioButton по objectName.
    QRadioButton findRadioButton(string name) {
        void* wh = _find(name);
        return wh ? QRadioButton.wrap(wh) : null;
    }

    /// Найти QComboBox по objectName.
    QComboBox findComboBox(string name) {
        void* wh = _find(name);
        return wh ? QComboBox.wrap(wh) : null;
    }

    /// Найти QSpinBox по objectName.
    QSpinBox findSpinBox(string name) {
        void* wh = _find(name);
        return wh ? QSpinBox.wrap(wh) : null;
    }

    /// Найти QDoubleSpinBox по objectName.
    QDoubleSpinBox findDoubleSpinBox(string name) {
        void* wh = _find(name);
        return wh ? QDoubleSpinBox.wrap(wh) : null;
    }

    /// Найти QTextEdit по objectName.
    QTextEdit findTextEdit(string name) {
        void* wh = _find(name);
        return wh ? QTextEdit.wrap(wh) : null;
    }

    /// Найти QPlainTextEdit по objectName.
    QPlainTextEdit findPlainTextEdit(string name) {
        void* wh = _find(name);
        return wh ? QPlainTextEdit.wrap(wh) : null;
    }

    /// Найти QGroupBox по objectName.
    QGroupBox findGroupBox(string name) {
        void* wh = _find(name);
        return wh ? QGroupBox.wrap(wh) : null;
    }

    /// Найти QTabWidget по objectName.
    QTabWidget findTabWidget(string name) {
        void* wh = _find(name);
        return wh ? QTabWidget.wrap(wh) : null;
    }

    /// Найти QSlider по objectName.
    QSlider findSlider(string name) {
        void* wh = _find(name);
        return wh ? QSlider.wrap(wh) : null;
    }

    /// Найти QProgressBar по objectName.
    QProgressBar findProgressBar(string name) {
        void* wh = _find(name);
        return wh ? QProgressBar.wrap(wh) : null;
    }

    /// Найти QDialog по objectName (если форма — QDialog).
    QDialog findDialog(string name) {
        void* wh = _find(name);
        return wh ? QDialog.wrap(wh) : null;
    }

    /**
     * Найти QAction по objectName.
     *
     * QAction обычно создаётся в Action Editor Qt Designer и привязывается
     * к меню/тулбару через `<addaction name="..."/>` в .ui-файле.
     * Используется для подключения сигнала `triggered()` к D-обработчику:
     *
     * Examples:
     * ---
     * auto form = QForm.load("main.ui");
     * auto act  = form.findAction("actionOpen");
     * __gshared ESlot g_sl;
     * g_sl = new ESlot(act.getWH());
     * g_sl.set(cast(void*)&onOpen);
     * act.connect_triggered(g_sl);
     * ---
     *
     * Returns: обёртка QAction или null если action не найден
     *          (типично — опечатка в objectName).
     *
     * Note: QAction наследуется от QObject (не QWidget) — поиск идёт через
     *       отдельную C++ функцию `qteQObject_findChildAction`, не через
     *       стандартный `findChildWidget`.
     */
    QAction findAction(string name) {
        void* wh = findChildAction(_rootWH, name);
        return wh ? QAction.wrap(wh) : null;
    }

    /// Обернуть корневой виджет формы как QWidget (для show/resize/etc.).
    QWidget asWidget() {
        return _rootWH ? QWidget.wrap(_rootWH) : null;
    }
}
