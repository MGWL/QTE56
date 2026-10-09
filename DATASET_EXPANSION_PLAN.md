# 📚 План расширения датасета — 500+ новых примеров

## Текущее состояние
- Примеров в датасете: **939**
- Качество: **65-70%** на сложные примеры
- Основные проблемы: QTimer, QTableWidget, QMenu, путаница типов

---

## БЛОК 1: QTimer и многопоточность (60 примеров)

### Категория 1.1: Простой QTimer (20 примеров)

**1.1.1: Базовый таймер с текстом**
```
Q: Как создать таймер который обновляет текст каждые 500мс?
A: 
import qte56_core;
import qte56_loader;
import gen_qtimer;
import gen_qlabel;

__gshared QLabel lbl;
__gshared int counter = 0;

extern(C) void onTimeout(void* dthis, int n) {
    counter++;
    lbl.setText("Счётчик: " ~ to!string(counter));
}

void main() {
    LoadQt("./dll");
    auto app = new QApplication();
    auto w = new QWidget(cast(void*)null);
    
    lbl = new QLabel("Счётчик: 0", w.getWH());
    
    auto timer = new QTimer(w.getWH());  // ← КРИТИЧНО: создать объект!
    auto sl = new ESlot(w.getWH());
    sl.set(cast(void*)&onTimeout);
    timer.connect_timeout(sl);  // ← connect_timeout, НЕ connect_tick
    timer.start(500);  // мс
    
    w.show();
    app.exec();
    app.deleteApp();
}
```

**1.1.2: Таймер с остановкой**
```
Q: Как остановить таймер при клике на кнопку?
A:
__gshared QTimer timer;

extern(C) void onStop(void* dthis, int n, int c) {
    if (timer.isActive()) {
        timer.stop();
        btn.setText("Запущен был...");
    }
}
```

**1.1.3: Таймер с разной частотой**
```
Q: Как переключать таймер между 100мс и 1000мс?
A: timer.setInterval(100); или timer.setInterval(1000);
```

**1.1.4–1.1.20: Варианты** (16 примеров)
- Таймер + обновление часов (как в ТЕСТЕ 3, но правильно)
- Таймер + прогресс-бар
- Множество таймеров
- Таймер с разными сигналами
- Таймер и потокобезопасность
- И т.д.

---

### Категория 1.2: Неправильное использование QTimer (15 примеров)

**1.2.1: НЕПРАВИЛЬНО — забыли создать объект**
```
Q: Почему этот код не работает?
Q: __gshared timer;
Q: timer.start(1000);  // ← Ошибка!
A: timer не был создан через new QTimer(). 
   Исправление: auto timer = new QTimer(w.getWH());
   Статус: __gshared нужен для callback'ов, но сначала нужен new
```

**1.2.2: НЕПРАВИЛЬНО — connect_tick вместо connect_timeout**
```
Q: Почему используется connect_tick?
A: connect_tick не существует в QTE56. 
   Правильно: connect_timeout(slot)
   Альтернативы: timerEvent() если наследуешь QWidget
```

**1.2.3: НЕПРАВИЛЬНО — забыли ESlot**
```
Q: Работает ли timer.connect_timeout(&myFunction) напрямую?
A: Нет! ESlot обязателен. Правильно:
   auto sl = new ESlot(w.getWH());
   sl.set(cast(void*)&myFunction);
   timer.connect_timeout(sl);
```

**1.2.4–1.2.15: Варианты ошибок** (12 примеров)
- Неправильный интервал (отрицательный, слишком большой)
- Утечка памяти — забыл delete timer
- Timer который никогда не срабатывает
- Timer срабатывает слишком часто (100 раз в сек)
- И т.д.

---

### Категория 1.3: QTimer + многопоточность (25 примеров)

**1.3.1: QTimer в отдельном потоке**
```
Q: Как запустить QTimer в QThread?
A:
import gen_qthread;
import gen_qtimer;

__gshared QTimer timer;
__gshared QThread thread;

void timerFunc() {
    thread = new QThread();
    timer = new QTimer();  // Создать БЕЗ parent
    timer.moveToThread(thread.getWH());
    
    auto sl = new ESlot(thread.getWH());
    sl.set(cast(void*)&onTick);
    timer.connect_timeout(sl);
    
    thread.start();
    timer.start(1000);
}
```

**1.3.2–1.3.25: Варианты** (24 примеры)
- Race condition и QTimer
- Синхронизация между таймерами в разных потоках
- QMutex + QTimer
- Deadlock при QTimer в потоке
- И т.д.

---

## БЛОК 2: QTableWidget (60 примеров)

### Категория 2.1: Базовая работа (20 примеров)

**2.1.1: Создание пустой таблицы 3x3**
```
Q: Как создать пустую QTableWidget 3x3?
A:
auto tbl = new QTableWidget(w.getWH());
tbl.setRowCount(3);
tbl.setColumnCount(3);
tbl.setHorizontalHeaderLabels(["ID", "Name", "Age"]);
```

**2.1.2: Заполнение таблицы данными**
```
Q: Как правильно добавить данные в QTableWidget?
A:
import gen_qtablewidget;
import gen_qtablewidgetitem;

for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        auto item = new QTableWidgetItem();
        item.setText("Data " ~ to!string(i*3+j));
        tbl.setItem(i, j, item);  // ← Правильно!
    }
}
```

**2.1.3: Получить значение из ячейки**
```
Q: Как прочитать значение ячейки (1, 2)?
A:
auto item = tbl.item(1, 2);
string text = item.text();
```

**2.1.4–2.1.20: Варианты** (17 примеров)
- Стилизация таблицы
- Избранные ячейки
- Сортировка
- Слияние ячеек
- И т.д.

---

### Категория 2.2: Неправильное использование (20 примеров)

**2.2.1: НЕПРАВИЛЬНО — setItem с ESlot**
```
Q: Почему не работает?
A: tbl.setItem(0, 0, new ESlot());
   ← ESlot это callback, не item!
   Правильно: auto item = new QTableWidgetItem();
```

**2.2.2: НЕПРАВИЛЬНО — .widget.getWH().setStr()**
```
Q: Это правильный API?
A: Нет! tbl.widget.getWH().setStr() не существует.
   Правильно: item.setText(text);
```

**2.2.3–2.2.20: Варианты ошибок** (18 примеров)
- Индекс out of bounds
- Забыли setRowCount/setColumnCount
- Неправильный тип данных
- Память не освобождена
- И т.д.

---

### Категория 2.3: Сигналы и события (20 примеров)

**2.3.1: Обработка клика на ячейку**
```
Q: Как обработать клик на ячейку?
A:
extern(C) void onCellClicked(void* dthis, int row, int col) {
    auto item = tbl.item(row, col);
    string text = item.text();
    // обработка
}

auto sl = new ESlot(tbl.getWH());
sl.set(cast(void*)&onCellClicked);
tbl.connect_cellClicked(sl);
```

**2.3.2–2.3.20: Варианты** (19 примеров)
- Двойной клик
- Правый клик (контекстное меню)
- Выделение строк
- Фильтрация
- Поиск
- И т.д.

---

## БЛОК 3: QMenu и QMenuBar (50 примеров)

### Категория 3.1: Простое меню (20 примеров)

**3.1.1: QMenuBar с одним меню File**
```
Q: Как создать меню File с пункт Open?
A:
import gen_qmainwindow;
import gen_qmenu;
import gen_qaction;

auto mw = new QMainWindow(cast(void*)null);
auto mb = mw.menuBar();  // ← Не new QMenuBar!
auto fileMenu = new QMenu("&File", mw.getWH());

auto openAction = new QAction("&Open", fileMenu.getWH());
auto sl = new ESlot(fileMenu.getWH());
sl.set(cast(void*)&onOpen);
openAction.connect_triggered(sl);  // ← connect_triggered!

fileMenu.addAction(openAction.getWH());
mb.addMenu(fileMenu.getWH());

mw.show();
```

**3.1.2–3.1.20: Варианты** (19 примеров)
- Меню Edit, View, Help
- Разделители (addSeparator)
- Горячие клавиши (setShortcut)
- Иконки в меню
- Вложенные меню
- И т.д.

---

### Категория 3.2: Неправильное использование (15 примеров)

**3.2.1: НЕПРАВИЛЬНО — new EMenuBar**
```
Q: Почему не работает?
A: auto mb = new EMenuBar(mw.getWH());
   ← EMenuBar не существует! Нет такого типа в QTE56
   Правильно: auto mb = mw.menuBar();
```

**3.2.2: НЕПРАВИЛЬНО — connect_about**
```
Q: Это существует?
A: Нет! connect_about в памяти нет.
   Правильно для меню:
   - connect_triggered() для QAction
   - connect_activate() для пунктов меню
```

**3.2.3–3.2.15: Варианты ошибок** (13 примеров)
- QMenu без parent
- Забыли addMenu
- Неправильный сигнал
- Меню не отображается
- И т.д.

---

### Категория 3.3: Сложные меню (15 примеров)

**3.3.1: Динамическое создание пунктов меню**
```
Q: Как добавлять пункты меню динамически?
A:
for (int i = 1; i <= 5; i++) {
    auto action = new QAction("Файл #" ~ to!string(i), fileMenu.getWH());
    auto sl = new ESlot(fileMenu.getWH());
    sl.set(cast(void*)&onFileClicked);
    action.connect_triggered(sl);
    fileMenu.addAction(action.getWH());
}
```

**3.3.2–3.3.15: Варианты** (14 примеров)
- Контекстное меню (правый клик)
- Меню с флажками (checkable)
- Меню с радиокнопками (exclusive)
- Меню для QListWidget
- И т.д.

---

## БЛОК 4: QApplication vs ESlot (40 примеров)

### Категория 4.1: Правильная инициализация (20 примеров)

**4.1.1: Правильный шаблон QTE56 приложения**
```
Q: Какой правильный минимальный код QTE56 приложения?
A:
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;

void main()
{
    LoadQt("./dll");  // ← ПЕРВОЕ!
    auto app = new QApplication();  // ← Базовое окно
    
    auto w = new QWidget(cast(void*)null);
    w.setWindowTitle("Привет QTE56");
    w.show();
    
    app.exec();  // ← Главный loop
    app.deleteApp();
}
```

**4.1.2: QMainWindow шаблон**
```
Q: А для QMainWindow?
A:
void main() {
    LoadQt("./dll");
    auto app = new QApplication();
    
    auto mw = new QMainWindow(cast(void*)null);
    mw.setWindowTitle("Main Window");
    // ... setup меню, toolbar, etc
    mw.show();
    
    app.exec();
    app.deleteApp();
}
```

**4.1.3–4.1.20: Варианты** (18 примеров)
- С виджетами
- С layout'ами
- С сигналами
- С потоками
- И т.д.

---

### Категория 4.2: Неправильная инициализация (20 примеров)

**4.2.1: НЕПРАВИЛЬНО — app = new ESlot()**
```
Q: Почему не работает?
A: auto app = new ESlot();
   ← ESlot это callback handler, а НЕ приложение!
   Правильно: auto app = new QApplication();
```

**4.2.2: НЕПРАВИЛЬНО — порядок вызовов**
```
Q: Какой будет результат?
A: auto w = new QWidget(cast(void*)null);
   LoadQt("./dll");  // ← НЕПРАВИЛЬНЫЙ ПОРЯДОК!
   
   Правильно:
   LoadQt("./dll");  // ← СНАЧАЛА!
   auto w = new QWidget(cast(void*)null);
```

**4.2.3: НЕПРАВИЛЬНО — забыли deleteApp()**
```
Q: Что если не вызвать app.deleteApp()?
A: GC может завершить приложение раньше завершения.
   Может быть segfault при выходе.
   Правильно: всегда вызывать deleteApp() перед выходом.
```

**4.2.4–4.2.20: Варианты ошибок** (17 примеров)
- Забыли LoadQt
- Забыли exec()
- Двойной deleteApp()
- Ошибки с parent'ами
- И т.д.

---

## БЛОК 5: Ownership и disown() (40 примеров)

### Категория 5.1: Правильное использование (20 примеров)

**5.1.1: Когда нужен disown()?**
```
Q: Почему нужно вызывать disown() после addWidget?
A:
auto btn = new QPushButton("...", cast(void*)null);  // ← parent = null!
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(btn);  // ← Qt берёт ownership!
btn.disown();  // ← Говорим D: "забудь об этом объекте"
w.setLayout(vbox);
// Теперь Qt отвечает за удаление btn

Почему: Если не вызвать disown(), D будет думать что владеет btn.
Когда D закончится → GC удалит btn → Qt тоже удалит → crash!
```

**5.1.2: Автоматический disown (новое!)**
```
Q: А если использовать typed API?
A: В 2026-04-09 добавлен auto-disown:
   auto btn = new QPushButton(vbox.getWH());  // ← parent = vbox!
   vbox.addWidget(btn);  // ← Автоматический disown!
   // Не нужно вызывать disown() вручную
```

**5.1.3–5.1.20: Варианты** (18 примеров)
- disown() в разных контекстах
- setCentralWidget и disown
- setLayout и disown
- addTab и disown
- И т.д.

---

### Категория 5.2: Когда нужен disown (20 примеров)

**5.2.1: Структура памяти**
```
Q: Как разобраться когда нужен disown?
A:
Правило:
- Если parent = null → НУЖЕН disown() после addWidget
- Если parent = w.getWH() → Автоматический disown
- Если parent = null и передаёшь в layout → ОБЯЗАТЕЛЕН disown()

Пример:
auto btn1 = new QPushButton("A", cast(void*)null);  // parent=null
auto btn2 = new QPushButton("B", vbox.getWH());  // parent=vbox

vbox.addWidget(btn1);  // ← Нужен btn1.disown()!
vbox.addWidget(btn2);  // ← Автоматический disown
```

**5.2.2–5.2.20: Варианты** (19 примеров)
- Сравнение void* vs typed API
- Миграция старого кода
- Ошибки с ownership
- Утечки памяти
- И т.д.

---

## БЛОК 6: Многооборотные диалоги (150 примеров)

### Категория 6.1: QTimer в глубину (30 примеров)

**6.1.1: Полный диалог про QTimer**
```
Q1: Как создать таймер в QTE56?
A1: Используй QTimer из модуля gen_qtimer...

Q2: Почему мой таймер не запускается?
A2: Возможные причины:
    - Забыл вызвать timer.start(ms)
    - Забыл подключить сигнал connect_timeout
    - Забыл создать ESlot для callback'а
    - Забыл передать __gshared для doomed переменных
    
Q3: Как остановить таймер?
A3: timer.stop()
    или если нужно удалить: delete timer;

Q4: Может ли быть несколько таймеров одновременно?
A4: Да! Каждый таймер это отдельный объект.
    auto t1 = new QTimer(w.getWH()); t1.start(100);
    auto t2 = new QTimer(w.getWH()); t2.start(500);
    // Оба работают параллельно
    
Q5: Как синхронизировать два таймера?
A5: Можно использовать счётчик или QWaitCondition...
```

**6.1.2–6.1.30: Другие диалоги** (29 примеров)
- QTimer + сигналы
- QTimer + потоки
- QTimer + производительность
- QTimer + тестирование
- И т.д.

---

### Категория 6.2: QTableWidget в глубину (30 примеров)

**6.2.1: Полный диалог про QTableWidget**
```
Q1: Как создать таблицу с данными?
A1: QTableWidget требует трёх шагов...

Q2: Почему мой код с setItem не работает?
A2: Возможно используешь неправильный API.
    Неправильно: tbl.setItem(0, 0, new ESlot());
    Правильно: auto item = new QTableWidgetItem();
               tbl.setItem(0, 0, item);
               
Q3: Как обработать клик на ячейку?
A3: Используй connect_cellClicked сигнал...

Q4: Как получить данные из выделённых ячеек?
A4: int row = tbl.currentRow();
    int col = tbl.currentColumn();
    auto item = tbl.item(row, col);
    string text = item.text();

Q5: Как сделать таблицу отсортированной по колонке?
A5: tbl.setSortingEnabled(true);
    или мануально через custom delegate...
```

**6.2.2–6.2.30: Другие диалоги** (29 примеров)

---

### Категория 6.3: QMenu в глубину (30 примеров)

**6.3.1: Полный диалог про QMenu**
```
Q1: Как создать меню с несколькими пунктами?
A1: Нужна QMainWindow с menuBar()...

Q2: Почему EMenuBar не работает?
A2: Потому что EMenuBar не существует в QTE56!
    ESlot это callback, а не UI элемент.
    Правильно: auto mb = mw.menuBar();

Q3: Как добавить горячие клавиши к пункту меню?
A3: action.setShortcut("Ctrl+O");

Q4: Как создать контекстное меню при правом клике?
A4: Создай QMenu и вызови exec() при contextMenuEvent...

Q5: Как сделать пункт меню неактивным (disabled)?
A5: action.setEnabled(false);
```

**6.3.2–6.3.30: Другие диалоги** (29 примеров)

---

### Категория 6.4: Ownership и disown в глубину (30 примеров)

**6.4.1: Полный диалог про ownership**
```
Q1: Что такое ownership в Qt?
A1: Ownership = "кто удалит объект"
    - Если parent известен → parent удалит
    - Если parent = null → D удалит (если не disown)
    
Q2: Почему мой код крашится при выходе?
A2: Возможно двойное удаление:
    - D удаляет объект
    - Qt тоже удаляет объект
    - CRASH!
    Решение: вызови disown() когда даёшь объект Qt

Q3: Какая разница между void* parent и typed parent?
A3: void* требует ручного disown()
    Typed (2026-04-09+) автоматически вызывает disown()
    Рекомендуется: использовать typed API
    
Q4: Когда нужен disown() при setLayout?
A4: auto layout = new QVBoxLayout(cast(void*)null);
    auto btn = new QPushButton("A", cast(void*)null);
    layout.addWidget(btn);  // ← Нужен disown()!
    btn.disown();
    w.setLayout(layout);

Q5: А если я не вызову disown() и не будет краша?
A5: Может быть:
    - Утечка памяти
    - Или краш в непредсказуемый момент
    - Undefined behavior → никогда не полагайся на "это работало"
```

**6.4.2–6.4.30: Другие диалоги** (29 примеров)

---

### Категория 6.5: Ошибки и как их избежать (30 примеров)

**6.5.1: Диалог про типичные ошибки**
```
Q1: Какие самые частые ошибки в QTE56?
A1: 
    1. Забыли LoadQt() в начале
    2. Забыли disown() при addWidget
    3. Неправильный тип в сигналах (ESlot вместо callback)
    4. Забыли create объект (timer не создан)
    5. Неправильный порядок вызовов
    
Q2: Как избежать краша с ownership?
A2: Правило: если даёшь объект в layout/tree → disown()
    
Q3: Как отладить ошибку с таймером?
A3: Проверь:
    1. timer.isActive() → должен быть true
    2. Вызвался ли connect_timeout()?
    3. Правильный ли интервал в ms?
    4. Callback вообще вызывается?
    
Q4: Как найти утечку памяти?
A4: Используй valgrind или ASAN:
    $ valgrind ./my_app
    или $ export ASAN_OPTIONS=halt_on_error=1
    
Q5: Как отпустить ошибку в production?
A5: 
    - Используй try-catch для критических операций
    - Добавь логирование
    - Используй assert() в debug режиме
    - Тестируй граничные случаи
```

**6.5.2–6.5.30: Другие диалоги** (29 примеров)

---

## ИТОГОВАЯ СТАТИСТИКА

```
Текущий датасет:        939 примеров
Новых примеров:        +500 примеров
Итого:                 1439 примеров

Распределение по типам:
- БЛОК 1 (QTimer):              60 примеров
- БЛОК 2 (QTableWidget):        60 примеров
- БЛОК 3 (QMenu):               50 примеров
- БЛОК 4 (QApplication/ESlot):  40 примеров
- БЛОК 5 (Ownership):           40 примеров
- БЛОК 6 (Многооборотные):     150 примеров
---
ВСЕГО:                         400 примеров

+ оставшиеся 100 примеров для других улучшений

Ожидаемое улучшение:
- Текущее качество: 65-70%
- Новое качество: 85-90%
```

---

## 🎯 Как создавать эти примеры?

### Вариант 1: Вручную (медленно, но высокое качество)
```python
# Добавить в dataset_generation.py
examples = [
    {
        "messages": [
            {"role": "user", "content": "Как создать таймер...?"},
            {"role": "assistant", "content": "import gen_qtimer;\nauto timer = new QTimer(w.getWH());\n..."}
        ]
    },
    # ... ещё 499 примеров
]
```

### Вариант 2: Генерировать автоматически
```python
# create_timer_examples.py — генерирует 60 примеров про QTimer
# create_table_examples.py — генерирует 60 примеров про QTableWidget
# create_menu_examples.py — генерирует 50 примеров про QMenu
# И т.д.
```

---

## 📋 Приоритет реализации

**ВСЕ БЛОКИ ОДИНАКОВО ВАЖНЫ**, но если выбирать:

1. **БЛОК 1 (QTimer)** — часто используется, модель не понимает
2. **БЛОК 2 (QTableWidget)** — сложный API, нужны примеры
3. **БЛОК 4 (QApplication)** — базовые ошибки, критично
4. **БЛОК 5 (Ownership)** — крахи при выходе, критично
5. **БЛОК 3 (QMenu)** — менее критично, но важно
6. **БЛОК 6 (Диалоги)** — рассуждение модели улучшится

---

**Готов создавать примеры?** 🚀

Какой блок начать первым?

