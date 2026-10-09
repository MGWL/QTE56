# DES — Designer-driven Entry Shell

GUI-приложение на D + QTE56, которое полностью загружает внешний вид
из файла `dorm_des.ui`, созданного в **Qt Designer**.

Цель: менять интерфейс через дизайнер, не трогая код D.

---

## Быстрый старт

```bash
cd apps/des
build.bat
```

После сборки запускайте `des.exe` из папки `apps/des`.
DLL QTE56 берутся из `../../dll/dll32` (корневая папка проекта).

---

## Архитектура

```
Qt Designer → dorm_des.ui → QUiLoader → QForm → D-код
```

- Вся компоновка виджетов живёт в `dorm_des.ui`.
- Логика (обработчики кнопок, валидация, диалоги) живёт в `des.d`.
- Связь между UI и кодом происходит через `objectName` виджетов.

---

## Поиск элементов формы

В `des.d` форма загружается один раз:

```d
auto form = QForm.load("dorm_des.ui");
```

Далее виджеты ищутся по имени, которое задаётся в Qt Designer
в поле **objectName** (Property Editor → QObject → objectName).

### Типизированные find-методы

| Виджет в Designer | Метод в D | Тип |
|---|---|---|
| `QLabel` | `form.findLabel("objectName")` | `QLabel` |
| `QPushButton` | `form.findButton("objectName")` | `QPushButton` |
| `QLineEdit` | `form.findLineEdit("objectName")` | `QLineEdit` |
| `QCheckBox` | `form.findCheckBox("objectName")` | `QCheckBox` |
| `QRadioButton` | `form.findRadioButton("objectName")` | `QRadioButton` |
| `QComboBox` | `form.findComboBox("objectName")` | `QComboBox` |
| `QSpinBox` | `form.findSpinBox("objectName")` | `QSpinBox` |
| `QDoubleSpinBox` | `form.findDoubleSpinBox("objectName")` | `QDoubleSpinBox` |
| `QTextEdit` | `form.findTextEdit("objectName")` | `QTextEdit` |
| `QPlainTextEdit` | `form.findPlainTextEdit("objectName")` | `QPlainTextEdit` |
| `QGroupBox` | `form.findGroupBox("objectName")` | `QGroupBox` |
| `QTabWidget` | `form.findTabWidget("objectName")` | `QTabWidget` |
| `QSlider` | `form.findSlider("objectName")` | `QSlider` |
| `QProgressBar` | `form.findProgressBar("objectName")` | `QProgressBar` |
| `QDialog` | `form.findDialog("objectName")` | `QDialog` |

### Поиск QAction

Действия меню/тулбара (Action Editor) ищутся отдельно,
так как `QAction` наследуется от `QObject`, а не от `QWidget`:

```d
auto actOpen = form.findAction("actionOpen");
```

### Универсальный поиск

Если нужен сырой указатель `void*` или тип пока не обёрнут:

```d
void* w = form.findWidget("someWidget");
```

Поиск выполняется **рекурсивно** по всему дереву дочерних виджетов.

---

## Правила именования в Designer

1. Каждый виджет, к которому обращаетесь из D, должен иметь
   **уникальный** `objectName`.
2. Имена должны быть осмысленными: `lineEditInput`, `buttonSave`,
   `labelStatus`, а не `lineEdit`, `pushButton`.
3. Если виджет не найден, `find*()` возвращает `null` — проверяйте
   перед использованием, особенно на этапе отладки.

---

## Как добавить новый виджет

1. Откройте `dorm_des.ui` в Qt Designer.
2. Добавьте виджет на форму.
3. Задайте ему `objectName` в Property Editor.
4. В `des.d` получите ссылку:

   ```d
   auto myEdit = g_form.findLineEdit("myEditName");
   ```

5. Используйте объект как обычный QTE56-виджет.

Если добавляемый тип виджета ещё не импортирован в `des.d`,
добавьте соответствующий `import gen_q<widget>;` и включите
`../../d/gen/gen_q<widget>.d` в `build.bat`.

---

## Как подключить обработчик

Пример: кнопка `buttonAction` в форме.

```d
// Объявить слот в __gshared — иначе GC его соберёт
__gshared ESlot g_slotAction;

// Обработчик
extern(C) void onButtonAction(void* dt, int n, int checked) {
    // dt  — указатель на объект-источник сигнала
    // n   — пользовательский номер, переданный в set()
    // checked — для toggle-кнопок
}

// Подключение
auto btn = g_form.findButton("buttonAction");
g_slotAction = new ESlot(btn.getWH());
g_slotAction.set(cast(void*)&onButtonAction);
btn.connect_clicked(g_slotAction);
```

---

## Ограничения

- `QForm` и `QUiLoader` требуют DLL `qte56_uiloader.dll`.
- Типы виджетов, которые есть в `.ui`, должны быть представлены
  соответствующими `gen_q*.d` модулями (иначе программа не соберётся).
- Для сложных кастомных виджетов потребуется регистрация
  в `QUiLoader` — в базовом примере не поддерживается.

---

## Файлы

| Файл | Назначение |
|---|---|
| `dorm_des.ui` | Форма Qt Designer |
| `des.d` | D-приложение: загрузка формы и логика |
| `build.bat` | Сборка под Windows (32-bit, Qt 5.13.2) |
| `README.md` | Этот файл |
