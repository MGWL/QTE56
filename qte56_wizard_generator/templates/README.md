# QTE56 Шаблоны — Готовые мини-программы

Компактные (~70–100 строк) рабочие примеры QTE56 + D. Каждый файл — самостоятельная программа с подробными комментариями на русском.

## Шаблоны

| Файл | Что показывает | Требуемые DLL |
|------|---------------|---------------|
| `tpl_log_viewer.d` | QPlainTextEdit авто-скролл, QTimer, Пауза/Продолжить | widgets |
| `tpl_config_form.d` | QFormLayout, QSettings (string/int/bool), Load/Save/Reset | widgets, foundation |
| `tpl_progress_worker.d` | QThread(delegate), atomicStore/Load, QTimer-опрос прогресса | widgets, thread |
| `tpl_http_to_table.d` | httpGet, json.d разбор, QTableWidget заполнение | widgets, views, network |
| `tpl_file_watcher.d` | QFileSystemWatcher (delegate), QListWidget + scrollToBottom | widgets, views, filewatcher |
| `tpl_image_viewer.d` | QMainWindow + QScrollArea + QPixmap.load, File→Open | mainwin, widgets, foundation |
| `tpl_calculator.d` | QGridLayout span, ESlot.set(&label) для идентификации кнопок | widgets |

## Компиляция (Windows 32-bit)

```bat
cd templates
dmd -m32 -i tpl_log_viewer.d -I../../d -I../../d/gen -of=log_viewer.exe
```

Запуск (DLL должны быть в PATH или рядом с exe):

```bat
set PATH=../../dll;%PATH%
log_viewer.exe
```

## Ключевые паттерны QTE56

### Обязательный порядок инициализации
```d
LoadQt("./dll");               // 1. загрузить DLL
auto app = new QApplication(); // 2. создать приложение
// ... создавать виджеты ...   // 3. только после app
app.exec();                    // 4. цикл событий
GC.collect();                  // 5. перед выходом
app.deleteApp();               // 6. последнее
```

### ESlot — подключение сигналов
```d
__gshared ESlot[N] g_sl;  // пул: защита от GC
__gshared int      g_si;

// Коллбэк invoke_v: последний параметр всегда int (игнорируем)
extern(C) void onTimeout(void* dt, int n, int _) { ... }

auto sl = new ESlot(timer.getWH());
sl.set(cast(void*)&onTimeout);    // dt в коллбэке = этот указатель
timer.connect_timeout(g_sl[g_si++] = sl);
```

### Трюк ESlot.set(&label) (см. tpl_calculator.d)
```d
__gshared string[N] g_labels;  // хранить __gshared!

// Создать один коллбэк на все кнопки, метка передаётся через dt
auto sl = new ESlot(btn.getWH());
sl.set(cast(void*)&g_labels[i]);  // dt = адрес строки
btn.connect_clicked(sl);

extern(C) void onBtn(void* dt, int n, int _) {
    string label = *cast(string*)dt;  // разыменовать
}
```

### Typed API — auto-disown
```d
// addWidget/addLayout/setLayout/setCentralWidget/setWidget → auto-disown
auto vbox = new QVBoxLayout(cast(void*)null);
vbox.addWidget(someWidget);   // someWidget.disown() вызывается автоматически
vbox.addLayout(hbox);         // hbox.disown() автоматически
g_win.setLayout(vbox);        // vbox.disown() автоматически

// void* API → ручной disown
mb.addMenu(menu.getWH()); menu.disown();  // ОБЯЗАТЕЛЬНО
```

### QThread + атомарный прогресс (tpl_progress_worker.d)
```d
__gshared shared int g_progress = 0;

g_thread = new QThread({
    // НЕЛЬЗЯ трогать Qt-виджеты из рабочего потока!
    atomicStore(g_progress, i);
    QThread.msleep(50);
});
g_thread.start();

// Опросный таймер в главном потоке — безопасное обновление UI
extern(C) void onPoll(void* dt, int n, int _) {
    g_bar.setValue(atomicLoad(g_progress));
}
```

### QFileSystemWatcher — delegate (не ESlot!)
```d
g_watcher = new QFileSystemWatcher();  // без parent-аргумента!
g_watcher.connect_fileChanged((string path) {
    // вызывается в главном потоке
    g_watcher.addPath(path); // переподписаться после удаления файла
});
destroy(g_watcher); // перед GC.collect()
```
