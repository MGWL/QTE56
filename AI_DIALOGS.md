# QTE56 — AI_DIALOGS (все диалоги)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> КРИТИЧНО: QMessageBox/QFileDialog/QInputDialog требуют import gen_qdialog тоже!
> DLL: qte56_dialogs.dll

---

## QMessageBox — статические методы

```d
// import: gen_qmessagebox + gen_qdialog (оба!)
// Простые уведомления:
QMessageBox.information(win.getWH(), "Info",  "Operation completed.");
QMessageBox.warning   (win.getWH(), "Warn",  "File not found.");
QMessageBox.critical  (win.getWH(), "Error", "Fatal error occurred!");
QMessageBox.about     (win.getWH(), "About", "My App v1.0\n© 2026");

// Вопрос с кнопками:
int r = QMessageBox.question(win.getWH(), "Exit",
    "Save changes before exit?",
    QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel,
    QMessageBox.Cancel);  // кнопка по умолчанию
if      (r == QMessageBox.Yes)    save();
else if (r == QMessageBox.No)     close();
else /* Cancel */                 return;

// Стандартные кнопки:
// QMessageBox.Ok=1024  Yes=16384  No=65536  Cancel=4194304
// Save=2048  Discard=8388608  Retry=524288  Ignore=1048576
// All=65535  StandardButton mask
```

---

## QFileDialog — статические методы

```d
// import: gen_qfiledialog + gen_qdialog (оба!)

// Открыть один файл:
string path = QFileDialog.getOpenFileName(
    win.getWH(),                           // родитель
    "Open File",                           // заголовок
    "",                                    // стартовая папка ("" = текущая)
    "D Source (*.d);;Text (*.txt);;All (*)"); // фильтр
if (path.length > 0) { /* открыть path */ }

// Сохранить файл:
string save = QFileDialog.getSaveFileName(
    win.getWH(), "Save As", "untitled.d", "D Source (*.d);;All (*)");

// Открыть папку:
string dir = QFileDialog.getExistingDirectory(
    win.getWH(), "Select Directory", "");

// Несколько файлов:
// (не реализовано статически — используй QFileDialog объект)

// Типичный паттерн File → Open:
extern(C) void onFileOpen(void* dt, int n, int c) {
    string path = QFileDialog.getOpenFileName(
        g_win.getWH(), "Open", g_lastDir, "All Files (*)");
    if (path.length == 0) return;
    // запомнить директорию:
    import std.path : dirName;
    g_lastDir = dirName(path);
    loadFile(path);
}
```

---

## QInputDialog — статические методы

```d
// import: gen_qinputdialog + gen_qdialog (оба!)

// Строку:
bool ok;
string name = QInputDialog.getText(
    win.getWH(),  // родитель
    "Enter Name", // заголовок
    "Name:",      // метка
    "default",    // начальный текст
    &ok);
if (ok && name.length > 0) use(name);

// Целое число:
int n = QInputDialog.getInt(
    win.getWH(), "Count", "Enter count:", 1, 0, 1000, 1, &ok);
// args: parent, title, label, value, min, max, step, ok*

// Дробное число:
double d = QInputDialog.getDouble(
    win.getWH(), "Scale", "Enter scale:", 1.0, 0.0, 10.0, 2, &ok);
// args: parent, title, label, value, min, max, decimals, ok*

// Выбор из списка (QInputDialog объект нужен для getItem):
// Статического getItem нет — используй QComboBox в QDialog.
```

---

## QDialog — собственный диалог

```d
// import: gen_qdialog + gen_qlayout + gen_qpushbutton + gen_qabstractbutton
__gshared QDialog     g_dlg;
__gshared QLineEdit   g_editName;
__gshared ESlot       g_slOk, g_slCancel;

extern(C) void onDlgOk    (void* dt, int n, int c) { g_dlg.accept(); }
extern(C) void onDlgCancel(void* dt, int n, int c) { g_dlg.reject(); }

QDialog createDialog(void* parentWH) {
    g_dlg = new QDialog(parentWH);
    g_dlg.setWindowTitle("Add Item");
    g_dlg.resize(380, 160);
    g_dlg.setModal(true);  // модальный

    auto vbox = new QVBoxLayout(cast(void*)null);

    // Поле ввода
    g_editName = new QLineEdit(cast(void*)null);
    g_editName.setPlaceholderText("Enter name...");
    vbox.addWidget(g_editName);  // auto-disown

    // Кнопки
    auto hbox = new QHBoxLayout(cast(void*)null);
    hbox.addStretch(1);
    auto btnOk = new QPushButton(cast(void*)null); btnOk.setText("OK");
    auto btnNo = new QPushButton(cast(void*)null); btnNo.setText("Cancel");
    btnOk.setDefault(true);       // Enter = OK

    g_slOk     = new ESlot(btnOk.getWH()); g_slOk.set(cast(void*)&onDlgOk);
    g_slCancel = new ESlot(btnNo.getWH()); g_slCancel.set(cast(void*)&onDlgCancel);
    btnOk.connect_clicked(g_slOk);
    btnNo.connect_clicked(g_slCancel);

    hbox.addWidget(btnOk); btnOk.disown();
    hbox.addWidget(btnNo); btnNo.disown();

    vbox.addLayout(hbox); // auto-disown
    g_dlg.setLayout(vbox); // auto-disown

    return g_dlg;
}

// Вызов:
createDialog(g_win.getWH());
int result = g_dlg.exec();  // блокирует до закрытия
// result: QDialog.Accepted=1, QDialog.Rejected=0
if (result == QDialog.Accepted) {
    string name = g_editName.text();
    // использовать name
}
```

---

## QDialog — модальный с FormLayout

```d
// Диалог настроек с полями
__gshared QDialog   g_settingsDlg;
__gshared QLineEdit g_editHost;
__gshared QSpinBox  g_spinPort;
__gshared ESlot     g_slSave;

extern(C) void onSave(void* dt, int n, int c) {
    string host = g_editHost.text();
    int    port = g_spinPort.value();
    if (host.length == 0) {
        QMessageBox.warning(g_settingsDlg.getWH(), "Error", "Host required!");
        return;
    }
    // Сохранить...
    g_settingsDlg.accept();
}

void showSettings(void* parentWH) {
    g_settingsDlg = new QDialog(parentWH);
    g_settingsDlg.setWindowTitle("Settings");
    g_settingsDlg.resize(320, 150);

    auto vbox = new QVBoxLayout(cast(void*)null);
    auto form = new QFormLayout(cast(void*)null);

    g_editHost = new QLineEdit(cast(void*)null);
    g_editHost.setPlaceholderText("localhost");
    form.addRow("Host:", g_editHost);  // typed → auto-disown

    g_spinPort = new QSpinBox(cast(void*)null);
    g_spinPort.setRange(1, 65535); g_spinPort.setValue(8080);
    form.addRow("Port:", g_spinPort); // typed → auto-disown

    vbox.addLayout(form); // auto-disown

    auto hbox = new QHBoxLayout(cast(void*)null);
    hbox.addStretch(1);
    auto btnSave   = new QPushButton(cast(void*)null); btnSave.setText("Save");
    auto btnCancel = new QPushButton(cast(void*)null); btnCancel.setText("Cancel");
    g_slSave = new ESlot(btnSave.getWH()); g_slSave.set(cast(void*)&onSave);
    btnSave.connect_clicked(g_slSave);
    auto slC = new ESlot(btnCancel.getWH());
    slC.set(cast(void*)((void* a, int b, int c_) => g_settingsDlg.reject()));
    // или проще:
    extern(C) void onCancel_(void* dt, int n, int c_) { g_settingsDlg.reject(); }
    // Чтобы использовать, нужен отдельный __gshared ESlot

    hbox.addWidget(btnSave);   btnSave.disown();
    hbox.addWidget(btnCancel); btnCancel.disown();
    vbox.addLayout(hbox);
    g_settingsDlg.setLayout(vbox);

    g_settingsDlg.exec();
}
```

---

## QColorDialog

```d
// import: gen_qcolordialog + gen_qcolor + gen_qdialog
// Статический — блокирующий:
auto color = QColorDialog.getColor(
    null,            // начальный цвет (null = белый)
    win.getWH(),     // родитель
    "Pick Color",    // заголовок
    0                // options (0=нет)
);
if (color !is null) {
    int r = color.red(); int g = color.green(); int b = color.blue();
    int a = color.alpha();
    // Применить цвет к виджету:
    string css = "background: rgb(%d,%d,%d);".format(r, g, b);
    widget.setStyleSheet(css);
}

// Нативный с сигналом (не блокирующий):
__gshared QColorDialog g_colorDlg;
extern(C) void onColorSelected(void* dthis, int n, void* colorPtr) {
    auto c = QColor.wrap(colorPtr);  // wrap, не new!
    // использовать c
}
g_colorDlg = new QColorDialog(cast(void*)null);
g_colorDlg.connect_colorSelected(cast(void*)&onColorSelected, null);
g_colorDlg.setOption(0, true); // 0=ShowAlphaChannel
g_colorDlg.show();  // или .exec() для блокирующего
```

---

## QFontDialog

```d
// import: gen_qfontdialog + gen_qfont + gen_qdialog
// Статический:
bool ok;
auto font = QFontDialog.getFont(&ok, win.getWH());
if (ok) {
    widget.setFont(font);  // typed API — font принадлежит Qt после вызова
}

// С начальным шрифтом:
auto initial = new QFont("Courier New");
initial.setPointSize(12);
auto chosen = QFontDialog.getFont(&ok, initial.getWH(), win.getWH(), "Choose Font");
if (ok) widget.setFont(chosen);

// Нативный с сигналом:
extern(C) void onFontSelected(void* dthis, int n, void* fontPtr) {
    auto f = QFont.wrap(fontPtr);  // wrap!
    widget.setFont(f);
}
auto dlg = new QFontDialog(cast(void*)null);
dlg.connect_fontSelected(cast(void*)&onFontSelected, null);
dlg.show();
```

---

## QProgressDialog

```d
// import: gen_qprogressdialog + gen_qdialog
auto pd = new QProgressDialog(cast(void*)null);
pd.setWindowTitle("Processing");
pd.setLabelText("Loading data...");
pd.setRange(0, 100);
pd.setValue(0);
pd.setMinimumDuration(500); // показать только если задача > N мс
pd.setCancelButtonText("Cancel");
pd.setModal(true);
pd.show();

// В цикле:
for (int i = 0; i <= 100; i++) {
    pd.setValue(i);
    QCoreApplication.processEvents();  // обновить UI
    if (pd.wasCanceled()) break;
    // ... work ...
}
pd.setValue(100);  // закрыть

// Сигнал отмены:
__gshared ESlot g_slCancel;
extern(C) void onCanceled(void* dt, int n) { /* прервать работу */ }
g_slCancel = new ESlot(pd.getWH()); g_slCancel.set(cast(void*)&onCanceled);
pd.connect_canceled(g_slCancel);
```

---

## Немодальный диалог (show, не exec)

```d
// exec() — блокирует event loop (модальный)
// show() — не блокирует (немодальный)

__gshared QDialog g_findDlg;  // живёт пока приложение работает

void showFindDialog() {
    if (g_findDlg is null) {
        g_findDlg = new QDialog(g_win.getWH());
        g_findDlg.setWindowTitle("Find");
        // ... построить UI ...
        // Не используем exec() — диалог не блокирует
    }
    g_findDlg.show();
    g_findDlg.activateWindow();  // на передний план
}
// ВАЖНО: raise_() отсутствует в QTE56 — используй activateWindow()
```

---

## Gotchas

```
1. QMessageBox/QFileDialog/QInputDialog: нужен import gen_qdialog!
2. QDialog.exec() возвращает 1=Accepted, 0=Rejected.
3. QFileDialog фильтр: "Text (*.txt);;D (*.d);;All (*)" — двойной ";;"
4. QInputDialog.getText: параметр ok — bool*, а не out bool!
5. QColorDialog.getColor возвращает QColor (не void*) — проверяй на null.
6. QFont.getFont возвращает QFont объект — типизированный, не getWH().
7. QProgressDialog.wasCanceled() — проверять в цикле, иначе UI не реагирует.
8. Немодальный диалог: не удалять после show() — он живёт в __gshared.
9. QFormLayout.addRow("label:", widget) — типизированная версия работает
   напрямую с D string и typed widget (auto-disown).
```
