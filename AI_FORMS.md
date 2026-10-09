# QTE56 — AI_FORMS (Qt Designer .ui-формы через QUiLoader)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: `qte56_uiloader.dll` (+ DLL для виджетов формы)
> import: `qte56_forms`, `gen_quiloader`, `gen_qaction` (для actions)

Этот файл — про работу с **.ui-файлами Qt Designer** в рантайме через `QForm`.
Альтернатива программной вёрстке: рисуешь UI мышкой → грузишь одной строкой → подключаешь только обработчики.

---

## Минимальный пример

```d
import qte56_core, qte56_loader;
import qte56_forms;                 // QForm
import gen_qcore;                   // QApplication
import gen_qpushbutton, gen_qabstractbutton, gen_qlineedit, gen_qlabel;

__gshared QForm  g_form;
__gshared ESlot  g_slOk;

extern(C) void onOk(void* dt, int n, int checked) {
    auto edit = g_form.findLineEdit("editName");
    auto lbl  = g_form.findLabel("lblStatus");
    lbl.setText("Hello, " ~ edit.text());
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication("Demo");

    g_form = QForm.load("test/ui/test_dialog.ui");

    auto btnOk = g_form.findButton("btnOk");
    g_slOk = new ESlot(btnOk.getWH());
    g_slOk.set(cast(void*)&onOk);
    btnOk.connect_clicked(g_slOk);

    g_form.show();
    app.exec();
    app.deleteApp();
}
```

---

## QForm — типизированный поиск виджетов

`QForm.load(path)` загружает .ui-файл через `QUiLoader`, возвращает `QForm` или `null` при ошибке.

```d
auto form = QForm.load("main.ui");        // null если файл не найден / ошибка XML
form.show();                              // показать окно
form.hide();
form.resize(800, 600);
form.setWindowTitle("My App");
void* root = form.getWH();                // QWidget* корня (для parent в диалогах)
```

### Поиск по `objectName` (Designer Property Editor → objectName)

| Метод | Возвращает |
|---|---|
| `findButton(name)` | `QPushButton` |
| `findLabel(name)` | `QLabel` |
| `findLineEdit(name)` | `QLineEdit` |
| `findCheckBox(name)` | `QCheckBox` |
| `findRadioButton(name)` | `QRadioButton` |
| `findComboBox(name)` | `QComboBox` |
| `findSpinBox(name)` | `QSpinBox` |
| `findDoubleSpinBox(name)` | `QDoubleSpinBox` |
| `findTextEdit(name)` | `QTextEdit` |
| `findPlainTextEdit(name)` | `QPlainTextEdit` |
| `findGroupBox(name)` | `QGroupBox` |
| `findTabWidget(name)` | `QTabWidget` |
| `findSlider(name)` | `QSlider` |
| `findProgressBar(name)` | `QProgressBar` |
| `findDialog(name)` | `QDialog` |
| `findAction(name)` | `QAction` ← из Action Editor |
| `findWidget(name)` | `void*` (любой QWidget) |

**Все возвращают `null` если виджет с таким `objectName` не найден** — типичная причина опечатка в имени или забытая привязка через `<addaction>` в Designer.

---

## QAction — actions из Action Editor

В Designer создаёшь action через **Action Editor → New** (имя `actionOpen`, текст `&Open...`, шорткат `Ctrl+O`, иконка). Затем drag-drop в меню/тулбар.

В D-коде:

```d
import gen_qaction;

auto actOpen = form.findAction("actionOpen");
__gshared ESlot g_slOpen;
g_slOpen = new ESlot(actOpen.getWH());
g_slOpen.set(cast(void*)&onFileOpen);
actOpen.connect_triggered(g_slOpen);   // invoke_b: cb(dt, n, checked)

// Управление в рантайме:
actOpen.setEnabled(false);     // действие недоступно
actOpen.setText("Save *");     // изменить текст пункта меню
actOpen.setShortcutStr("Ctrl+S");
actOpen.setChecked(true);      // для checkable actions
actOpen.trigger();             // программный вызов (синхронно вызывает triggered)
```

```d
extern(C) void onFileOpen(void* dt, int n, int checked) {
    string path = QFileDialog.getOpenFileName(form.getWH(), "Open", "", "All (*)");
    // ...
}
```

**Важно:** QAction наследуется от QObject (не QWidget), поэтому используется отдельная функция `findAction` через C++ `findChild<QAction*>`. Метод появился в Phase 1 интеграции с Designer.

---

## Connections из Signal/Slot Editor

Designer сохраняет связи в блоке `<connections>` в .ui:

```xml
<connection>
  <sender>btnCancel</sender><signal>clicked()</signal>
  <receiver>MyDialog</receiver><slot>reject()</slot>
</connection>
```

### ⚠️ ВАЖНО: builtin Qt-слоты работают САМИ

`QUiLoader` автоматически подключает связи на встроенные Qt-слоты — **D-кода не нужно**.

```
Работают сами:
  close, show, hide, setVisible, setEnabled, setFocus, raise, update
  accept, reject, done, open
  clear, copy, cut, paste, undo, redo, selectAll, setText, append
  click, animateClick, toggle, setChecked
  trigger, hover                                  (для QAction)
  setValue, stepUp, stepDown, setCurrentIndex
  reset, clearMessage, showMessage, quit
```

Типичные паттерны без D-кода:
```xml
btnCancel.clicked()         →  Dialog.reject()         (закрытие диалога)
btnClear.clicked()          →  edit.clear()            (очистка поля)
edit.textChanged(QString)   →  lblPreview.setText(QString)  (синхронизация)
actionExit.triggered()      →  MainWin.close()         (выход)
```

### Custom slots — НЕ работают (нужен D-код)

В Designer можно объявить свой слот через `Edit Signals/Slots` → Designer положит в `<slots>` блок. **В Qt C++ их подключает MOC, в D MOC не запускается** → придётся подключать вручную через `findXxx().connect_xxx(eslot)`.

### Проверка какие связи в .ui

```
tools/ui_tree/ui_tree.exe form.ui
```

Покажет секцию `Connections (N) — builtin: X, custom: Y`. Сразу видно где работает само, а где нужен D-код.

---

## Codegen: автогенерация D-каркаса из `<connections>`

Если в .ui есть **custom slots** (не builtin), `ui_tree` может сгенерировать готовый D-модуль с заглушками-обработчиками и кодом подключения:

```
ui_tree login.ui --gen-slots > slots_login.d
```

Опционально можно задать имя модуля:
```
ui_tree login.ui --gen-slots my_handlers > my_handlers.d
```

### Что генерируется

```d
/**
 * slots_login — Auto-generated by ui_tree --gen-slots from login.ui
 */
module slots_login;

import gen_qcore;            // ESlot
import gen_qpushbutton;       // нужно для btnOk
import gen_qabstractbutton;   // base для clicked
import gen_qlineedit;         // нужно для editName
import qte56_forms;           // QForm

__gshared ESlot[] _slots;     // защита от GC

// ── Builtin connections (auto-wired by QUiLoader, no D code) ──
//   btnCancel.clicked()  →  LoginDialog.reject()
//   btnClearForm.clicked()  →  editUser.clear()

// ── Custom slot stubs ──
/// invoke_b: clicked(bool checked)
/// (Designer: btnOk.clicked() → LoginDialog.onLogin())
extern(C) void on_btnOk_clicked(void* dt, int n, int checked) {
    // TODO: handle btnOk.clicked()
}

void wireSlots(QForm form) {
    {
        auto btnOk = form.findButton("btnOk");
        if (btnOk !is null) {
            auto sl = new ESlot(btnOk.getWH());
            sl.set(cast(void*)&on_btnOk_clicked);
            btnOk.connect_clicked(sl);
            _slots ~= sl;
        }
    }
    // ... одинаковый блок для каждой custom-связи
}
```

### Workflow

```d
import qte56_forms;
import slots_login;          // сгенерированный модуль

void main() {
    LoadQt("./dll");
    auto app = new QApplication("Login");

    auto form = QForm.load("login.ui");
    wireSlots(form);          // 1 строка — все custom-обработчики подключены
    form.show();

    app.exec();
    app.deleteApp();
}
```

Тебе остаётся только заполнить TODO-тела в `slots_login.d`. Builtin-связи (Cancel→reject, Clear→clear) работают уже без кода.

### Что покрывает резолвер сигналов

`--gen-slots` распознаёт ~12 типов сигналов и подбирает правильные `connect_xxx` + сигнатуры колбэков:

| Сигнал | Класс | connect | invoke |
|---|---|---|---|
| `clicked()`, `triggered()`, `toggled()` | QPushButton, QAction, QCheckBox, ... | `connect_clicked` / `_triggered` / `_toggled` | `(dt, n, checked)` |
| `stateChanged(int)` | QCheckBox | `connect_stateChanged` | `(dt, n, state)` |
| `valueChanged(int)` | QSlider/QDial | `connect_valueChanged` | `(dt, n, value)` |
| `valueChanged(int)` | QSpinBox | `connect_valueChanged_i` | `(dt, n, value)` |
| `valueChanged(double)` | QDoubleSpinBox | `connect_valueChanged_d` | `(dt, n, double value)` |
| `currentIndexChanged(int)` | QComboBox | `connect_currentIndexChanged_i` | `(dt, n, idx)` |
| `currentIndexChanged(QString)` | QComboBox | `connect_currentIndexChanged_s` | `(dt, n, qs)` |
| `currentTextChanged(QString)` | QComboBox | `connect_currentTextChanged` | `(dt, n, qs)` |
| `currentChanged(int)` | QTabWidget | `connect_currentChanged` | `(dt, n, idx)` |
| `textChanged(QString)` | QLineEdit | `connect_textChanged` | `(dt, n, qs)` invoke_s |
| `textChanged()` | QTextEdit/QPlainTextEdit | `connect_textChanged` | `(dt, n)` invoke_v |
| `returnPressed`, `editingFinished`, `timeout` | QLineEdit, QTimer | соотв. `connect_*` | `(dt, n)` |

Неизвестные сочетания → пометка `// TODO: manual` в сгенерированном коде, без сборочной поломки.

### Перегенерация при изменении .ui

При смене формы — заново:
```
ui_tree login.ui --gen-slots > slots_login.d
```

⚠ Перегенерация **перезаписывает TODO-тела**. Стратегии:
- **Git-friendly:** держать `slots_login.d` под git, после регенерации ручной merge через `git diff`
- **Разделить:** не править stubs из generated, а в отдельном файле определить функции с другими именами и подключать вручную
- **Постфактум:** перегенерировать `slots_login.d.new`, сравнить через diff-tool

Минусы codegen-подхода — необходимость регенерации. Плюсы — compile-time проверка типов сигналов и автодополнение в IDE.

---

## Структура .ui XML — что Designer записывает

```xml
<ui version="4.0">
  <widget class="QMainWindow" name="MainWin">      ← корень
    <property name="windowTitle"><string>App</string></property>

    <widget class="QWidget" name="centralwidget">  ← вложенные виджеты
      <layout class="QVBoxLayout" name="vbox">
        <item><widget class="QPushButton" name="btnOk">
          <property name="text"><string>OK</string></property>
        </widget></item>
      </layout>
    </widget>

    <widget class="QMenuBar" name="menubar">
      <widget class="QMenu" name="menuFile">
        <addaction name="actionOpen"/>             ← ссылка на action
      </widget>
      <addaction name="menuFile"/>
    </widget>
  </widget>

  <action name="actionOpen">                       ← определение
    <property name="text"><string>&amp;Open...</string></property>
    <property name="shortcut"><string>Ctrl+O</string></property>
  </action>

  <connections>
    <connection>...</connection>
  </connections>
</ui>
```

Ключи:
- **`<widget>` / `<layout>`** — иерархия UI (резолвится `findChildWidget`)
- **`<action>`** — определение QAction (резолвится `findChildAction`)
- **`<addaction>`** — ссылка на action ИЛИ подменю в меню/тулбаре
- **`name="..."`** — это `objectName`, видим в Designer Property Editor (F4)

---

## Подводные камни

```
1. objectName опечатка → findXxx() возвращает null → crash при .setText().
   ✅ Проверяй: if (btn !is null) ... ИЛИ запускай ui_tree.exe form.ui чтобы
   увидеть фактические objectName всех виджетов.

2. ESlot обязательно __gshared (как везде):
     __gshared ESlot g_sl;
     g_sl = new ESlot(btn.getWH());
   Без __gshared GC удалит slot → crash при первом сигнале.

3. QForm НЕ владеет ESlot — тебе хранить их самому.
   В Phase 2 интеграции планируется form.connectClicked(name, cb) с auto-storage.

4. findAction("foo") возвращает null если:
   - в Designer action не определён (нет <action name="foo">)
   - objectName опечатан
   ⚠ НЕ зависит от того, добавлен ли action через <addaction> в меню/тулбар.
   Action может существовать как orphan и работать (его шорткат виден если
   action добавлен в parent через addAction в коде, но это редко нужно).

5. <addaction name="separator"/> = разделитель в меню. Не имеет objectName,
   findAction("separator") вернёт null.

6. Custom slots из Designer НЕ работают в D — нет MOC. Все обработчики
   подключай вручную через findXxx + ESlot. Builtin Qt-слоты (close/clear/
   setText/...) работают сами через QUiLoader.

7. QForm — родитель всех виджетов. При destroy(form) удалятся все.
   wrap()-обёртки QPushButton/QAction/... НЕ удаляют Qt-объект.

8. show() работает только на top-level форме (root QWidget из .ui).
   Вложенные виджеты появляются с родителем сами.
```

---

## Где смотреть детали

| Задача | Файл |
|---|---|
| Что внутри .ui-файла (виджеты+actions+connections) | `tools/ui_tree/ui_tree.exe form.ui` |
| Сгенерировать D-каркас обработчиков | `tools/ui_tree/ui_tree.exe form.ui --gen-slots > slots.d` |
| QForm API | `d/qte56_forms.d` |
| QAction методы | `d/gen/gen_qaction.d` или AI_MAINWINDOW.md |
| Низкоуровневый QUiLoader | `d/gen/gen_quiloader.d` |
| Сигналы и сигнатуры | AI_SIGNALS_REF.md |
| Меню/тулбары вручную | AI_MAINWINDOW.md |

---

*QTE56 AI_FORMS — Phase 1 Designer Integration, апрель 2026*
