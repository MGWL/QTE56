# QTE56 — AI_WIDGETS (стандартные виджеты управления)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> Все виджеты: `new Widget(cast(void*)null)` — обязателен cast!
> ESlot в __gshared. Сигнатуры коллбэков — см. AI_SIGNALS_REF.md.

---

## QPushButton / QCheckBox / QRadioButton

```d
// import: gen_qpushbutton + gen_qabstractbutton (оба!)
auto btn = new QPushButton(cast(void*)null);
btn.setText("&Click Me");    // & = Alt-shortcut
btn.setEnabled(false);
btn.setCheckable(true);
btn.setChecked(true);
btn.setFlat(true);           // без рамки
btn.setDefault(true);        // Enter срабатывает
bool v = btn.isChecked();
btn.click();                 // программный клик

// Сигнал: connect_clicked — invoke_b
extern(C) void onBtn(void* dt, int n, int checked) { }
__gshared ESlot g_sl;
g_sl = new ESlot(btn.getWH()); g_sl.set(cast(void*)&onBtn);
btn.connect_clicked(g_sl);

// import: gen_qcheckbox + gen_qabstractbutton
auto cb = new QCheckBox(cast(void*)null);
cb.setText("Enable"); cb.setChecked(true);
// Сигнал: connect_stateChanged — invoke_i, state: 0=Off 2=On
extern(C) void onCheck(void* dt, int n, int state) { }
g_sl = new ESlot(cb.getWH()); g_sl.set(cast(void*)&onCheck);
cb.connect_stateChanged(g_sl);

// import: gen_qradiobutton + gen_qabstractbutton
// QRadioButton в QGroupBox — взаимоисключающие автоматически
auto grp = new QGroupBox(cast(void*)null);
grp.setTitle("Mode");
auto rb1 = new QRadioButton(cast(void*)null); rb1.setText("Fast");
auto rb2 = new QRadioButton(cast(void*)null); rb2.setText("Slow");
rb1.setChecked(true);
// Сигнал: connect_toggled — invoke_b
extern(C) void onRb(void* dt, int n, int checked) {
    if (!checked) return; // срабатывает и при снятии — игнорировать
}
auto vg = new QVBoxLayout(cast(void*)null);
vg.addWidget(rb1); vg.addWidget(rb2);
grp.setLayout(vg);
```

---

## QLineEdit

```d
// import: gen_qlineedit
auto edit = new QLineEdit(cast(void*)null);
edit.setText("default");
edit.setPlaceholderText("Enter value...");
edit.setReadOnly(true);
edit.setEchoMode(2);         // 2=Password, 0=Normal, 3=PasswordEchoOnEdit
edit.setMaxLength(100);
edit.setAlignment(0x1);      // Qt::AlignLeft=1, AlignRight=2, AlignCenter=4
edit.setInputMask("000-000-0000");  // маска ввода
edit.setClearButtonEnabled(true);   // кнопка очистки справа
string val = edit.text();
edit.clear();
edit.selectAll();
// Текущая позиция/выделение:
int  pos   = edit.cursorPosition();
int  start = edit.selectionStart();
string sel = edit.selectedText();

// Сигналы:
// textChanged (invoke_s) — каждый символ
extern(C) void onChanged(void* dt, int n, void* qs) { string s = fromQString(qs); }
// returnPressed (invoke_v) — Enter
extern(C) void onReturn(void* dt, int n) { }
// editingFinished (invoke_v) — Enter или потеря фокуса
extern(C) void onDone(void* dt, int n) { }
g_sl = new ESlot(edit.getWH()); g_sl.set(cast(void*)&onReturn);
edit.connect_returnPressed(g_sl);
```

---

## QComboBox

```d
// import: gen_qcombobox
auto combo = new QComboBox(cast(void*)null);
combo.addItem("Option 1");
combo.addItem("Option 2");
combo.addItems(["A", "B", "C"]);  // D string[] напрямую
combo.insertItem(0, "First");
combo.insertSeparator(2);
combo.removeItem(1);
combo.setItemText(0, "New text");
combo.clear();
int    idx = combo.currentIndex();
string txt = combo.currentText();
combo.setCurrentIndex(2);
combo.setCurrentText("Option 1");  // по тексту (если есть)
int    cnt = combo.count();
combo.setMaxVisibleItems(10);
combo.setEditable(true);           // редактируемый комбобокс
combo.setPlaceholderText("Choose...");

// Сигналы:
// currentIndexChanged (invoke_i): connect_currentIndexChanged_i — суффикс _i!
extern(C) void onCombo(void* dt, int n, int idx) { }
g_sl = new ESlot(combo.getWH()); g_sl.set(cast(void*)&onCombo);
combo.connect_currentIndexChanged_i(g_sl);
// currentTextChanged (invoke_s): connect_currentTextChanged
```

---

## QSpinBox / QDoubleSpinBox

```d
// import: gen_qspinbox + gen_qabstractspinbox (оба!)
auto spin = new QSpinBox(cast(void*)null);
spin.setRange(0, 1000);
spin.setValue(42);
spin.setSingleStep(5);
spin.setPrefix("$ ");
spin.setSuffix(" px");
spin.setWrapping(true);         // 999→0 и 0→999
spin.setReadOnly(true);
int v = spin.value();
// Сигнал valueChanged (invoke_i): connect_valueChanged_i — суффикс _i!
extern(C) void onSpin(void* dt, int n, int value) { }
g_sl = new ESlot(spin.getWH()); g_sl.set(cast(void*)&onSpin);
spin.connect_valueChanged_i(g_sl);

// import: gen_qdoublespinbox + gen_qabstractspinbox (оба!)
auto dspin = new QDoubleSpinBox(cast(void*)null);
dspin.setRange(0.0, 1.0); dspin.setSingleStep(0.01); dspin.setDecimals(2);
double dv = dspin.value();
// Сигнал valueChanged (invoke_d): connect_valueChanged_d — суффикс _d!
extern(C) void onDSpin(void* dt, int n, double value) { }
g_sl = new ESlot(dspin.getWH()); g_sl.set(cast(void*)&onDSpin);
dspin.connect_valueChanged_d(g_sl);
```

---

## QSlider / QDial / QScrollBar

```d
// import: gen_qslider + gen_qabstractslider (оба!)
auto sl = new QSlider(cast(void*)null);
sl.setOrientation(1);    // 1=Horizontal, 2=Vertical
sl.setRange(0, 100);
sl.setValue(50);
sl.setSingleStep(1);
sl.setPageStep(10);
sl.setTickInterval(10);
sl.setTickPosition(2);   // 0=NoTicks 1=Above/Left 2=Below/Right 3=BothSides
sl.setInvertedAppearance(false);
int v = sl.value();
// Сигнал valueChanged (invoke_i): connect_valueChanged (без суффикса!)
extern(C) void onSlider(void* dt, int n, int value) { }
g_sl = new ESlot(sl.getWH()); g_sl.set(cast(void*)&onSlider);
sl.connect_valueChanged(g_sl);
// connect_sliderMoved — только при drag мышью

// import: gen_qdial + gen_qabstractslider (оба!)
auto dial = new QDial(cast(void*)null);
dial.setRange(0, 360); dial.setValue(90);
dial.setNotchesVisible(true);
dial.setNotchTarget(15.0);
// connect_valueChanged — аналогично слайдеру
```

---

## QProgressBar

```d
// import: gen_qprogressbar
auto bar = new QProgressBar(cast(void*)null);
bar.setRange(0, 100);
bar.setValue(75);
bar.setTextVisible(true);
bar.setFormat("%v / %m (%p%)"); // %v=value %m=max %p=percent
bar.setAlignment(0x4);          // AlignCenter
bar.setOrientation(1);          // 1=Horizontal, 2=Vertical
bar.setInvertedAppearance(true);

// Неопределённый режим (бесконечная анимация):
bar.setRange(0, 0);    // min==max==0 → анимация
bar.setRange(0, 100);  // вернуть в обычный режим
int v = bar.value();
// Сигнал: connect_valueChanged (invoke_i)
```

---

## QLCDNumber

```d
// import: gen_qlcdnumber
auto lcd = new QLCDNumber(cast(void*)null);
lcd.setDigitCount(6);
lcd.display(42);          // int
lcd.display(3.14);        // double
lcd.display("AbCdEF");    // string (hex символы)
lcd.setDecMode();         // десятичный (по умолчанию)
lcd.setHexMode();
lcd.setOctMode();
lcd.setBinMode();
lcd.setSegmentStyle(1);   // 0=Outline 1=Filled 2=Flat
lcd.setSmallDecimalPoint(true);
int iv = lcd.intValue();
double dv = lcd.value();
```

---

## QLabel

```d
// import: gen_qlabel
auto lbl = new QLabel(cast(void*)null);
lbl.setText("Plain text");
lbl.setText("<b>Bold</b> and <i>italic</i> <font color='red'>red</font>");
lbl.setAlignment(0x84);       // AlignHCenter|AlignVCenter
// Константы выравнивания: AlignLeft=1, AlignRight=2, AlignHCenter=4,
//   AlignTop=0x20, AlignBottom=0x40, AlignVCenter=0x80
lbl.setWordWrap(true);
lbl.setIndent(10);
lbl.setMargin(5);
lbl.setOpenExternalLinks(true);  // для HTML <a href>
// Изображение:
lbl.setPixmap(pixmap.getWH());   // см. gen_qpixmap
lbl.setScaledContents(true);     // масштабировать по размеру label
string txt = lbl.text();
lbl.clear();
```

---

## QGroupBox

```d
// import: gen_qgroupbox
auto grp = new QGroupBox(cast(void*)null);
grp.setTitle("Settings");
grp.setFlat(false);
grp.setCheckable(true);    // с чекбоксом в заголовке
grp.setChecked(true);      // только если setCheckable(true)
bool on = grp.isChecked();
grp.setAlignment(0x1);     // заголовок: AlignLeft=1, AlignHCenter=4

auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(/* ... */);
grp.setLayout(vbox);       // auto-disown

// Сигнал: connect_clicked (invoke_b) — если setCheckable(true)
extern(C) void onGrpToggle(void* dt, int n, int checked) { }
g_sl = new ESlot(grp.getWH()); g_sl.set(cast(void*)&onGrpToggle);
grp.connect_clicked(g_sl);
```

---

## QFrame

```d
// import: gen_qframe
auto frame = new QFrame(cast(void*)null);
frame.setFrameShape(4);    // QFrame::HLine=4, VLine=5, Box=1, Panel=2, StyledPanel=6
frame.setFrameShadow(16);  // Sunken=16, Raised=32, Plain=48
frame.setLineWidth(2);
frame.setMidLineWidth(1);
// HLine (разделитель):
auto sep = new QFrame(cast(void*)null);
sep.setFrameShape(4);  // HLine
sep.setFrameShadow(16); // Sunken
vbox.addWidget(sep);
```

---

## QToolButton

```d
// import: gen_qtoolbutton (наследует QAbstractButton)
auto tb = new QToolButton(cast(void*)null);
tb.setText("Action");
// tb.setIcon(icon.getWH());
tb.setToolButtonStyle(2);  // 0=IconOnly 1=TextOnly 2=TextBesideIcon 3=TextUnderIcon
tb.setAutoRaise(true);
tb.setCheckable(true);
tb.setMenu(menu.getWH());
tb.setPopupMode(2);        // 0=DelayedPopup 1=MenuButtonPopup 2=InstantPopup
// Сигнал: connect_clicked (ESlot, invoke_b)
```

---

## QButtonGroup

```d
// import: gen_qbuttongroup
// Группирует радиокнопки — только один активен одновременно
auto grp = new QButtonGroup(cast(void*)null);
grp.addButton(rb1.getWH(), 1);  // кнопка + id
grp.addButton(rb2.getWH(), 2);
grp.addButton(rb3.getWH(), 3);
grp.setExclusive(true);          // взаимоисключающий (по умолчанию true)
int checkedId = grp.checkedId(); // id активной кнопки (-1 если нет)
void*[] all   = grp.buttons();   // handle'ы всех кнопок группы

// Сигнал (прямой): buttonClicked — без ESlot!
extern(C) void onBtnGrp(void* dthis, int id) { /* id кнопки */ }
grp.connect_buttonClicked(cast(void*)&onBtnGrp, null);
// buttonToggled: extern(C) void cb(void* dthis, int id, int checked)
```

---

## QWidget — базовые методы

```d
// import: gen_qwidget
w.setWindowTitle("Title");
w.resize(800, 600);
w.setFixedSize(400, 300);  // фиксированный размер
w.setMinimumSize(200, 100);
w.setMaximumSize(1920, 1080);
w.setFixedWidth(200); w.setFixedHeight(100);
w.move(100, 100);          // позиция на экране
w.show(); w.hide();
w.setVisible(true);
bool v = w.isVisible();
w.setEnabled(true); w.setEnabled(false);
bool e = w.isEnabled();
w.setToolTip("Hint text");
w.setWhatsThis("What's this text");
w.setStatusTip("Status bar text");
w.setStyleSheet("background: #fff;");
w.setObjectName("myWidget");  // для QSS селекторов: #myWidget { }
w.update();      // запросить перерисовку
w.repaint();     // немедленная перерисовка
w.setFocus();
w.clearFocus();
w.setTabOrder(edit1.getWH(), edit2.getWH()); // порядок Tab
w.setMouseTracking(true);  // onMouseMove без нажатия
w.setAcceptDrops(true);    // drag&drop
void* wh = w.getWH();      // handle для передачи в void*-API
w.activateWindow();        // поднять на передний план

// Геометрия:
int x = w.x(); int y = w.y();
int wd = w.width(); int ht = w.height();
// Сохранить/восстановить:
auto geo = w.saveGeometry();   // ubyte[]
w.restoreGeometry(geo);
// С QSettings:
cfg.setBytes("geo", w.saveGeometry());
ubyte[] loaded = cfg.getBytes("geo");
if (loaded.length > 0) w.restoreGeometry(loaded);
```

---

## QSS — типовые стили

```d
// Кнопки с hover и disabled:
btn.setStyleSheet(
    "QPushButton{background:#2980b9;color:white;border-radius:4px;padding:4px 12px;}" ~
    "QPushButton:hover{background:#1a6fa0;}" ~
    "QPushButton:pressed{background:#145880;}" ~
    "QPushButton:disabled{background:#bdc3c7;color:#888;}");

// Поле ввода с фокусом:
edit.setStyleSheet(
    "QLineEdit{border:1px solid #bdc3c7;border-radius:3px;padding:2px 6px;}" ~
    "QLineEdit:focus{border:2px solid #3498db;}");

// Прогресс-бар зелёный:
bar.setStyleSheet(
    "QProgressBar{border:1px solid #bdc3c7;border-radius:3px;text-align:center;}" ~
    "QProgressBar::chunk{background:#27ae60;border-radius:2px;}");

// Глобально на все виджеты в окне:
win.setStyleSheet(
    "QWidget{font-family:'Segoe UI';font-size:10pt;}" ~
    "QGroupBox{font-weight:bold;}" ~
    "QGroupBox::title{padding:0 4px;}");
```
