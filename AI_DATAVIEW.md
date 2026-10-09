# QTE56 — AI_DATAVIEW (QTableWidget, QTreeWidget, QListWidget)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_views.dll
> Все три виджета требуют трёх импортов!

---

## Импорты (критично — нужны все!)

```d
// QTableWidget:
import gen_qtablewidget;
import gen_qtableview;
import gen_qabstractitemview;
import gen_qheaderview;          // для stretch/sort/resize header

// QTreeWidget:
import gen_qtreewidget;
import gen_qtreeview;
import gen_qabstractitemview;

// QListWidget:
import gen_qlistwidget;
import gen_qabstractitemview;
```

---

## QListWidget

```d
auto list = new QListWidget(cast(void*)null);

// Добавить элементы:
list.addItem("Item 1");
list.addItem("Item 2");
list.addItems(["A", "B", "C"]);   // D string[] напрямую
list.insertItem(0, "First");       // вставить в позицию 0

// Именованный элемент (с данными):
auto item = new QListWidgetItem("My Item");
item.setToolTip("Hint");
item.setCheckState(2);   // 0=Unchecked 2=Checked (если setFlags включает checkable)
list.addItem(item);      // typed → auto-disown

// Читать элементы:
int    row = list.currentRow();           // -1 если нет выделения
string txt2= list.itemText(2);            // текст строки по индексу
int    cnt = list.count();

// Получить элемент (не удалять!):
auto it = list.item(row);                 // D-обёртка, НЕ удалять!
if (it !is null) string t = it.text();

// Изменить элемент:
list.item(row).setText("New text");

// Удалить строку:
list.deleteItem(row);             // удалить (элемент освобождается)
auto taken = list.takeItem(row);  // извлечь (D владеет объектом)

// Очистить:
list.clear();

// Выделение:
list.setCurrentRow(2);
list.setSelectionMode(2);         // 2=MultiSelection, 1=SingleSelection
void*[] sel = list.selectedItems();  // handle'ы выбранных QListWidgetItem
foreach (ptr; sel) {
    auto si = QListWidgetItem.wrap(ptr);
    // НЕ удалять si — Qt владеет!
}

// Внешний вид:
list.setSortingEnabled(true);
list.sortItems(0);               // 0=AscendingOrder, 1=DescendingOrder
list.setAlternatingRowColors(true);
list.scrollToBottom();

// Сигналы (прямые — не ESlot!):
extern(C) void onListClick(void* dt, int n, void* item) {
    auto i = QListWidgetItem.wrap(item);  // НЕ удалять!
    string t = i.text();
}
list.onItemClicked(cast(void*)&onListClick);
list.onItemDoubleClicked(cast(void*)&onListClick);

extern(C) void onListRow(void* dt, int n, int row) { }
list.onCurrentRowChanged(cast(void*)&onListRow);

extern(C) void onListSel(void* dt, int n) { }  // при изменении выделения
list.onItemSelectionChanged(cast(void*)&onListSel);
```

---

## QTableWidget

```d
auto tbl = new QTableWidget(cast(void*)null);

// Размер:
tbl.setRowCount(0);       // начать пустой
tbl.setColumnCount(4);

// Заголовки:
tbl.setHorizontalHeaderLabels(["ID", "Name", "Value", "Comment"]);
// или по одному:
tbl.setHorizontalHeaderItem(0, new QTableWidgetItem("ID"));  // auto-disown (typed)

// Скрыть нумерацию строк слева:
QHeaderView.wrap(tbl.verticalHeader()).setVisible(false);
// Растянуть последний столбец:
QHeaderView.wrap(tbl.horizontalHeader()).setStretchLastSection(true);
// Равномерное растяжение всех столбцов:
QHeaderView.wrap(tbl.horizontalHeader()).setSectionResizeMode(1); // 1=Stretch

// Добавить строки и данные:
tbl.insertRow(tbl.rowCount());  // добавить строку в конец
int r = tbl.rowCount() - 1;
tbl.setItem(r, 0, new QTableWidgetItem("1"));    // typed → auto-disown
tbl.setItem(r, 1, new QTableWidgetItem("Alice"));
tbl.setItem(r, 2, new QTableWidgetItem("42"));
// Заблокировать редактирование ячейки:
auto readOnly = new QTableWidgetItem("fixed");
readOnly.setFlags(readOnly.flags() & ~2);  // убрать ItemIsEditable
tbl.setItem(r, 3, readOnly);  // auto-disown

// Читать ячейки:
auto cell = tbl.itemObj(1, 0);         // typed wrapper (не удалять)
if (cell !is null) string val = cell.text();
// Или через void*:
void* raw = tbl.item(0, 0);
if (raw !is null) {
    auto it = QTableWidgetItem.wrap(raw);
    string s = it.text();
    // НЕ вызывать destroy(it)!
}

// Bulk-заполнение:
tbl.setRowCount(0);  // очистить
foreach (i; 0..100) {
    tbl.insertRow(i);
    tbl.setItem(i, 0, new QTableWidgetItem(i.to!string));
    tbl.setItem(i, 1, new QTableWidgetItem("Name " ~ i.to!string));
    tbl.setItem(i, 2, new QTableWidgetItem((i * 10).to!string));
    tbl.setItem(i, 3, new QTableWidgetItem(""));
}

// Удалить строку:
tbl.removeRow(2);
// Удалить всё содержимое (строки остаются, ячейки пусты):
tbl.clearContents();
// Полная очистка:
tbl.clear();

// Выделение и навигация:
tbl.setCurrentCell(0, 0);
int cr = tbl.currentRow();
int cc = tbl.currentColumn();
tbl.setSelectionBehavior(1);    // 1=SelectRows, 0=SelectItems, 2=SelectColumns
tbl.setSelectionMode(1);        // 1=SingleSelection, 2=Multi, 3=Extended
// Получить выбранные строки:
void*[] sel = tbl.selectedItems();
// (возвращает все выбранные QTableWidgetItem — несколько на строку при SelectItems)

// Редактирование:
tbl.setEditTriggers(0);         // 0=NoEditTriggers — только чтение
tbl.setEditTriggers(2);         // 2=DoubleClicked
tbl.setEditTriggers(0x1f);      // все триггеры

// Виджет в ячейке:
auto btn = new QPushButton(cast(void*)null); btn.setText("...");
tbl.setCellWidget(0, 3, btn.getWH()); btn.disown();
// Удалить виджет из ячейки:
tbl.removeCellWidget(0, 3);

// Сортировка:
tbl.setSortingEnabled(true);    // клик по заголовку
tbl.sortItems(1, 0);            // sort by col 1, Ascending=0

// Внешний вид:
tbl.setAlternatingRowColors(true);
tbl.setShowGrid(true);
tbl.setGridStyle(1);            // 1=SolidLine 2=DashLine 3=DotLine
tbl.setWordWrap(false);
tbl.setTextElideMode(0);        // 0=ElideLeft 1=ElideRight 2=ElideMiddle 3=None
tbl.resizeColumnsToContents();
tbl.resizeRowsToContents();
tbl.setColumnWidth(0, 60);
tbl.setRowHeight(0, 30);
tbl.scrollToItem(tbl.item(0,0), 1); // 1=EnsureVisible

// Сигналы через ESlot (invoke_ii):
__gshared ESlot g_slCell;
extern(C) void onCell(void* dt, int n, int row, int col) { }
g_slCell = new ESlot(tbl.getWH()); g_slCell.set(cast(void*)&onCell);
tbl.connect_cellClicked(g_slCell);
tbl.connect_cellDoubleClicked(g_slCell);
tbl.connect_cellChanged(g_slCell);

// Прямые (без int n):
extern(C) void onCellDirect(void* dt, int row, int col) { }
tbl.onCellClicked(cast(void*)&onCellDirect);

// Изменение выделения (invoke_v):
extern(C) void onSel(void* dt, int n) { }
__gshared ESlot g_slSel;
g_slSel = new ESlot(tbl.getWH()); g_slSel.set(cast(void*)&onSel);
tbl.connect_itemSelectionChanged(g_slSel);
```

---

## QTreeWidget

```d
auto tree = new QTreeWidget(cast(void*)null);

// Столбцы и заголовки:
tree.setColumnCount(3);
tree.setHeaderLabels(["Name", "Type", "Value"]);
tree.setHeaderHidden(false);
QHeaderView.wrap(tree.header()).setStretchLastSection(true);

// Добавить корневые элементы:
auto top1 = new QTreeWidgetItem("Root Item 1");
top1.setText(1, "folder");
top1.setText(2, "—");
tree.addTopLevelItem(top1);   // typed → auto-disown

// Добавить дочерние:
auto child1 = new QTreeWidgetItem("Child 1");
child1.setText(1, "file");
child1.setText(2, "42");
top1.addChild(child1);        // typed → auto-disown

auto child2 = new QTreeWidgetItem("Child 2");
child2.setCheckState(0, 2);   // checkable с флажком
top1.addChild(child2);

// Изменить элемент:
top1.setText(0, "New Name");
top1.setExpanded(true);

// Развернуть/свернуть:
tree.expandAll();
tree.collapseAll();
tree.expandItem(top1);         // typed
tree.collapseItem(top1);

// Найти элемент (QTreeWidgetItem.text()):
int cnt = tree.topLevelItemCount();
auto item = tree.topLevelItemObj(0);   // первый корневой элемент (typed wrapper)
int  ccnt = item.childCount();
auto child = item.child(0);

// Удалить:
tree.clear();                  // удалить всё
// Удалить конкретный элемент:
auto parent = top1.parent();
if (parent !is null)
    parent.removeChild(top1);
else
    tree.invisibleRootItemObj().removeChild(top1);

// Выделение:
tree.setCurrentItem(child1.getWH(), 0);
tree.setSelectionMode(1);      // 1=SingleSelection, 2=Multi
void*[] sel = tree.selectedItems(); // handle'ы QTreeWidgetItem

// Сортировка:
tree.setSortingEnabled(true);
tree.sortItems(0, 0);          // col 0, Ascending

// Виджет в ячейке дерева:
auto cb = new QCheckBox(cast(void*)null);
tree.setItemWidget(child1.getWH(), 2, cb.getWH()); cb.disown();

// Сигналы (прямые — item + col):
extern(C) void onTreeClick(void* dt, int n, void* item, int col) {
    auto i = QTreeWidgetItem.wrap(item);  // НЕ удалять!
    string s = i.text(col);
}
tree.onItemClicked(cast(void*)&onTreeClick);
tree.onItemDoubleClicked(cast(void*)&onTreeClick);
tree.onItemChanged(cast(void*)&onTreeClick);  // при редактировании

extern(C) void onExpand(void* dt, int n, void* item) {
    auto i = QTreeWidgetItem.wrap(item);
}
tree.onItemExpanded(cast(void*)&onExpand);
tree.onItemCollapsed(cast(void*)&onExpand);

extern(C) void onTreeSel(void* dt, int n) { }
tree.onItemSelectionChanged(cast(void*)&onTreeSel);

extern(C) void onCurItem(void* dt, int n, void* cur, void* prev) {
    if (cur is null) return;
    auto i = QTreeWidgetItem.wrap(cur);
}
tree.onCurrentItemChanged(cast(void*)&onCurItem);
```

---

## QHeaderView — управление заголовками

```d
// import: gen_qheaderview
// Получить через wrap (Qt-owned!):
auto hh = QHeaderView.wrap(tbl.horizontalHeader());
auto vh = QHeaderView.wrap(tbl.verticalHeader());
auto th = QHeaderView.wrap(tree.header());

// Resize modes:
// 0=Interactive 1=Stretch 2=Fixed 3=ResizeToContents
hh.setSectionResizeMode(1);        // все столбцы растягиваются
hh.setSectionResizeMode(0, 2);     // столбец 0 — Fixed
hh.setSectionResizeMode(1, 1);     // столбец 1 — Stretch

hh.setStretchLastSection(true);    // последний растягивается
hh.setDefaultSectionSize(80);      // ширина по умолчанию
hh.setMinimumSectionSize(40);

// Скрыть/показать столбец:
hh.hideSection(2);
hh.showSection(2);
bool hidden = hh.isSectionHidden(2);

// Переставить столбцы (visual index ≠ logical index):
hh.moveSection(2, 0);              // переместить visual col 2 → позицию 0
int logical = hh.logicalIndex(0);  // логический индекс visual col 0
int visual  = hh.visualIndex(1);   // visual индекс logical col 1

// Сортировка:
hh.setSortIndicator(0, 0);         // сортировать по col 0, Ascending
hh.setSortIndicatorShown(true);

// Высота заголовка:
vh.setDefaultSectionSize(24);

// Сигнал клика:
extern(C) void onHeaderClick(void* dt, int n, int idx) { }
__gshared ESlot g_slHdr;
g_slHdr = new ESlot(hh.getWH()); g_slHdr.set(cast(void*)&onHeaderClick);
hh.connect_sectionClicked(g_slHdr);
```

---

## Паттерн: таблица с поиском и контекстным меню

```d
__gshared QTableWidget g_tbl;
__gshared QLineEdit    g_search;
__gshared ESlot[4]     g_slots; __gshared int g_si = 0;

// Поиск — скрыть несовпадающие строки:
extern(C) void onSearch(void* dt, int n, void* qs) {
    string q = fromQString(qs).toLower();
    for (int r = 0; r < g_tbl.rowCount(); r++) {
        bool match = false;
        for (int c = 0; c < g_tbl.columnCount(); c++) {
            void* cell = g_tbl.item(r, c);
            if (cell !is null) {
                auto it = QTableWidgetItem.wrap(cell);
                if (it.text().toLower().indexOf(q) >= 0) { match = true; break; }
            }
        }
        g_tbl.setRowHidden(r, q.length > 0 && !match);
    }
}

// Контекстное меню:
extern(C) void onContext(void* dt, int x, int y, int reason) {
    int row = g_tbl.currentRow();
    if (row < 0) return;
    import gen_qmenu; import gen_qaction;
    auto ctx  = new QMenu(cast(void*)null);
    auto aDel = new QAction(cast(void*)null); aDel.setText("Delete row");
    // Подключить через ESlot или прямой коллбэк...
    ctx.addAction(aDel.getWH()); aDel.disown();
    ctx.exec();
}
g_tbl.onContextMenu(cast(void*)&onContext);

// Подключить поиск:
g_search = new QLineEdit(cast(void*)null);
g_search.setPlaceholderText("Search...");
auto sl = new ESlot(g_search.getWH());
sl.set(cast(void*)&onSearch);
g_search.connect_textChanged(sl);
g_slots[g_si++] = sl;
```

---

## Gotchas

```
1. Все три виджета требуют ВСЕ три import (widget + view + abstractitemview)!
2. QHeaderView получать только через wrap() — Qt-owned, не new.
3. QTableWidgetItem.wrap(ptr) — НЕ удалять! Qt владеет через таблицу.
4. QTreeWidgetItem.wrap(ptr) — НЕ удалять!
5. tbl.setItem(r, c, item) typed → auto-disown. void*-версия → disown вручную.
6. tree.addTopLevelItem(item) typed → auto-disown.
7. top.addChild(child) typed → auto-disown.
8. QTableWidgetItem.flags() → 0x1f по умолчанию. Убрать редактирование: flags & ~2.
9. onCellClicked (прямой) — сигнатура (void* dt, int row, int col) без int n!
   connect_cellClicked (ESlot) — сигнатура (void* dt, int n, int row, int col) с int n!
10. setSortingEnabled(true) может нарушить позиции строк — setItem после insertRow!
11. QHeaderView.setSectionResizeMode(int col, int mode) — перегрузка с col,
    setSectionResizeMode(int mode) — для всех столбцов сразу.
```
