# QTE56 — AI_CONTAINERS (layouts, контейнеры, навигация)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> Covers: QVBoxLayout, QHBoxLayout, QGridLayout, QFormLayout,
>         QTabWidget, QStackedWidget, QSplitter, QScrollArea, QToolBox

---

## Layouts — основы

```d
// import: gen_qlayout
// ВСЕ addWidget/addLayout → typed API → auto-disown (void*-версии не вызывают disown!)

// QVBoxLayout / QHBoxLayout
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.setSpacing(8);                     // расстояние между виджетами
vbox.setContentsMargins(10, 10, 10, 10);// left, top, right, bottom
vbox.addWidget(label);                  // auto-disown, stretch=0
vbox.addWidget(button, 1);             // stretch=1 (занимает доп. место)
vbox.addLayout(hbox);                  // вложенный layout, auto-disown
vbox.addStretch(1);                    // пружина (толкает виджеты вверх)
vbox.addSpacing(20);                   // фиксированный отступ
vbox.insertWidget(0, topWidget);       // вставить в позицию 0
vbox.removeWidget(someWidget.getWH()); // убрать виджет
container.setLayout(vbox);             // auto-disown

// QHBoxLayout — горизонтальный
auto hbox = new QHBoxLayout(cast(void*)null);
hbox.addStretch(1);           // толкает кнопки вправо
hbox.addWidget(btnOk);
hbox.addWidget(btnCancel);
vbox.addLayout(hbox);         // auto-disown

// Вложенные layouts:
auto main_vbox = new QVBoxLayout(cast(void*)null);
auto row1 = new QHBoxLayout(cast(void*)null);
row1.addWidget(labelName); row1.addWidget(editName);
auto row2 = new QHBoxLayout(cast(void*)null);
row2.addWidget(labelAge);  row2.addWidget(spinAge);
main_vbox.addLayout(row1);   // auto-disown
main_vbox.addLayout(row2);   // auto-disown
main_vbox.addStretch(1);
w.setLayout(main_vbox);      // auto-disown
```

---

## QGridLayout

```d
// import: gen_qlayout
auto grid = new QGridLayout(cast(void*)null);
grid.setSpacing(6);

// addWidget(widget, row, col)
grid.addWidget(lbl1,  0, 0);
grid.addWidget(edit1, 0, 1);

// addWidget(widget, row, col, rowSpan, colSpan)
grid.addWidget(lbl2,  1, 0);
grid.addWidget(edit2, 1, 1, 1, 2);   // занять 2 колонки
grid.addWidget(btn,   2, 0, 1, 3);   // занять всю строку (3 колонки)

// Растяжение колонок и строк:
grid.setColumnStretch(1, 1);  // col 1 растягивается
grid.setRowStretch(3, 1);     // row 3 — пружина
grid.setColumnMinimumWidth(0, 80);
grid.setRowMinimumHeight(0, 30);

w.setLayout(grid); // auto-disown
```

---

## QFormLayout

```d
// import: gen_qlayout
auto form = new QFormLayout(cast(void*)null);
form.setSpacing(8);
form.setContentsMargins(10, 10, 10, 10);

// addRow с D string + typed widget → auto-disown:
form.addRow("Name:",  editName);   // label + widget
form.addRow("Age:",   spinAge);
form.addRow("Email:", editEmail);

// addRow с QLabel + widget (оба auto-disown):
auto lbl = new QLabel(cast(void*)null); lbl.setText("Password:");
form.addRow(lbl, editPass);   // typed pair

// Убрать строку (по индексу):
form.removeRow(1);

dlg.setLayout(form); // auto-disown
```

---

## QTabWidget

```d
// import: gen_qtabwidget
auto tabs = new QTabWidget(cast(void*)null);
tabs.setTabsClosable(true);    // крестик на вкладке
tabs.setMovable(true);         // перетаскивание
tabs.setDocumentMode(true);    // современный стиль

// Добавить страницу (typed → auto-disown):
auto page1 = new QWidget(cast(void*)null);
auto vb1   = new QVBoxLayout(cast(void*)null);
vb1.addWidget(new QLabel(cast(void*)null));
page1.setLayout(vb1);
int idx = tabs.addTab(page1, "General");   // auto-disown

auto page2 = new QWidget(cast(void*)null);
tabs.addTab(page2, "Advanced");

// Вставить в позицию:
auto page3 = new QWidget(cast(void*)null);
tabs.insertTab(1, page3, "Network");       // auto-disown

// Управление:
tabs.setCurrentIndex(0);
tabs.setTabText(0, "General ✓");
tabs.setTabEnabled(1, false);
tabs.setTabToolTip(0, "General settings");
int cur = tabs.currentIndex();
int cnt = tabs.count();
tabs.removeTab(2);

// Позиция вкладок:
tabs.setTabPosition(0); // 0=North 1=South 2=West 3=East

// Сигналы:
__gshared ESlot g_slTab;
extern(C) void onTabClose  (void* dt, int n, int idx) { tabs.removeTab(idx); }
extern(C) void onTabChanged(void* dt, int n, int idx) { /* переключение */ }
g_slTab = new ESlot(tabs.getWH()); g_slTab.set(cast(void*)&onTabClose);
tabs.connect_tabCloseRequested(g_slTab);
```

---

## QStackedWidget

```d
// import: gen_qstackedwidget
// Стопка страниц — показывает только одну (как QTabWidget без вкладок)

auto stack = new QStackedWidget(cast(void*)null);

auto page1 = new QWidget(cast(void*)null);
auto page2 = new QWidget(cast(void*)null);
auto page3 = new QWidget(cast(void*)null);
stack.addWidget(page1);  // typed → auto-disown, возвращает int idx
stack.addWidget(page2);
stack.insertWidget(1, page3);

stack.setCurrentIndex(0);        // показать страницу 0
stack.setCurrentWidget(page2.getWH()); // показать конкретный виджет

int cur = stack.currentIndex();
int cnt = stack.count();
int i   = stack.indexOf(page2.getWH());
stack.removeWidget(page3.getWH());

// Сигнал переключения:
extern(C) void onPageChanged(void* dt, int n, int idx) { }
__gshared ESlot g_slStack;
g_slStack = new ESlot(stack.getWH()); g_slStack.set(cast(void*)&onPageChanged);
stack.connect_currentChanged(g_slStack);

// Типичный паттерн — список + стек:
// QListWidget слева выбирает страницу в стеке справа
extern(C) void onNavRow(void* dt, int n, int row) {
    stack.setCurrentIndex(row);
}
listNav.onCurrentRowChanged(cast(void*)&onNavRow);
```

---

## QSplitter

```d
// import: gen_qsplitter
auto sp = new QSplitter(cast(void*)null);
sp.setOrientation(1);           // 1=Horizontal, 2=Vertical
sp.setChildrenCollapsible(false); // нельзя сворачивать до 0

// Добавить панели (typed → auto-disown):
sp.addWidget(leftPanel);
sp.addWidget(rightPanel);

// Начальные размеры (пиксели):
sp.setSizes([300, 500]);
int[] sizes = sp.sizes();       // текущие размеры

// Настройка конкретного элемента:
sp.setStretchFactor(1, 1);      // правая панель растягивается
sp.setCollapsible(0, false);    // левую нельзя свернуть
sp.setHandleWidth(6);

// Вложенный сплиттер:
auto vsp  = new QSplitter(cast(void*)null);
vsp.setOrientation(2);          // Vertical
auto top  = new QWidget(cast(void*)null);
auto bot  = new QWidget(cast(void*)null);
vsp.addWidget(top); vsp.addWidget(bot);
sp.addWidget(vsp);              // вложить вертикальный в горизонтальный

// Сигнал:
extern(C) void onSplitterMoved(void* dt, int n, int pos, int idx) { }
__gshared ESlot g_slSp;
g_slSp = new ESlot(sp.getWH()); g_slSp.set(cast(void*)&onSplitterMoved);
sp.connect_splitterMoved(g_slSp);
```

---

## QScrollArea

```d
// import: gen_qscrollarea
auto scroll = new QScrollArea(cast(void*)null);

// Добавить контент (один виджет):
auto content = new QWidget(cast(void*)null);
auto vbox    = new QVBoxLayout(cast(void*)null);
// ... добавить много виджетов ...
content.setLayout(vbox);  // auto-disown

scroll.setWidget(content);        // typed → auto-disown (Qt берёт ownership)
scroll.setWidgetResizable(true);  // контент растягивается

// Выравнивание контента:
scroll.setAlignment(0x84);  // AlignCenter

// Прокрутка к виджету или позиции:
scroll.ensureVisible(100, 200, 20, 20);
scroll.ensureWidgetVisible(someWidget.getWH(), 10, 10);

// Минимальный размер контента:
content.setMinimumSize(600, 400);

// Стандартный паттерн — скроллируемая форма с настройками:
auto scrollForm = new QScrollArea(cast(void*)null);
auto formWidget = new QWidget(cast(void*)null);
auto form       = new QFormLayout(cast(void*)null);
// ... много полей ...
formWidget.setLayout(form);
scrollForm.setWidget(formWidget);
scrollForm.setWidgetResizable(true);
mainLayout.addWidget(scrollForm);  // auto-disown
```

---

## QToolBox

```d
// import: gen_qtoolbox (секции с заголовком, как аккордеон)
auto toolbox = new QToolBox(cast(void*)null);

auto sec1 = new QWidget(cast(void*)null);
auto vb   = new QVBoxLayout(cast(void*)null);
vb.addWidget(new QLabel(cast(void*)null));
sec1.setLayout(vb);

toolbox.addItem(sec1.getWH(), "Section 1");  // void* API → disown вручную
sec1.disown();
toolbox.addItem(sec2.getWH(), "Section 2");
sec2.disown();

toolbox.setCurrentIndex(0);
toolbox.setItemText(0, "New Title");
toolbox.setItemEnabled(1, false);
int cnt = toolbox.count();
int cur = toolbox.currentIndex();

// Сигнал:
extern(C) void onSection(void* dt, int n, int idx) { }
__gshared ESlot g_slTb;
g_slTb = new ESlot(toolbox.getWH()); g_slTb.set(cast(void*)&onSection);
toolbox.connect_currentChanged(g_slTb);
```

---

## Типовые компоновки UI

### Трёхпанельный Layout (навигация + контент + статус)
```d
auto mainSplitter = new QSplitter(cast(void*)null);
mainSplitter.setOrientation(1); // Horizontal

// Левая панель (навигация):
auto leftPanel  = new QWidget(cast(void*)null);
auto leftLayout = new QVBoxLayout(cast(void*)null);
auto tree       = new QTreeWidget(cast(void*)null);
leftLayout.addWidget(tree);
leftPanel.setLayout(leftLayout);
leftPanel.setFixedWidth(220);

// Правая панель (контент):
auto rightPanel  = new QWidget(cast(void*)null);
auto rightLayout = new QVBoxLayout(cast(void*)null);
auto tabs        = new QTabWidget(cast(void*)null);
rightLayout.addWidget(tabs);
rightPanel.setLayout(rightLayout);

mainSplitter.addWidget(leftPanel);   // auto-disown
mainSplitter.addWidget(rightPanel);  // auto-disown
mainSplitter.setStretchFactor(1, 1); // правая растягивается

win.setCentralWidget(mainSplitter);  // auto-disown
```

### Dialog с кнопками внизу (стандартный)
```d
auto dlg  = new QDialog(parentWH);
auto vbox = new QVBoxLayout(cast(void*)null);

// Контент:
auto form = new QFormLayout(cast(void*)null);
// ... поля ...
vbox.addLayout(form); // auto-disown

vbox.addStretch(1);  // пружина перед кнопками

// Кнопки:
auto hbox = new QHBoxLayout(cast(void*)null);
hbox.addStretch(1);
auto btnOk  = new QPushButton(cast(void*)null); btnOk.setText("OK");
auto btnCan = new QPushButton(cast(void*)null); btnCan.setText("Cancel");
hbox.addWidget(btnOk);  btnOk.disown();
hbox.addWidget(btnCan); btnCan.disown();
vbox.addLayout(hbox);   // auto-disown

dlg.setLayout(vbox);    // auto-disown
dlg.exec();
```

### Scroll-форма с поиском сверху
```d
auto vbox   = new QVBoxLayout(cast(void*)null);
// Поиск сверху:
auto hSearch = new QHBoxLayout(cast(void*)null);
auto editSrc = new QLineEdit(cast(void*)null);
editSrc.setPlaceholderText("Filter...");
hSearch.addWidget(editSrc); // auto-disown
vbox.addLayout(hSearch);    // auto-disown

// Прокручиваемый список:
auto scroll = new QScrollArea(cast(void*)null);
auto content= new QWidget(cast(void*)null);
auto listVbox= new QVBoxLayout(cast(void*)null);
// ... добавить элементы ...
listVbox.addStretch(1);
content.setLayout(listVbox);
scroll.setWidget(content);
scroll.setWidgetResizable(true);
vbox.addWidget(scroll); // auto-disown
w.setLayout(vbox);      // auto-disown
```
