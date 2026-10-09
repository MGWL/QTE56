# @live Quick Start Guide

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

**Для разработчиков QTE56 (включая AI модели)**

> 📖 **См. также:** [`AI_LOADING_ORDER.md`](AI_LOADING_ORDER.md) — порядок загрузки всех файлов SDK для AI моделей.

---

## ⚠️ КРИТИЧЕСКИ ВАЖНО — прочти ПЕРВЫМ!

**`@live` применяется ТОЛЬКО к локальным переменным с `auto` или явным типом.**

**НИКОГДА не используй `@live` перед именем поля класса или глобальной переменной без `auto`!**

```d
// ✅ ПРАВИЛЬНО — локальная переменная
@live auto btn = new QPushButton("OK");

// ❌ НЕПРАВИЛЬНО — поле класса!
class MyWin {
    QPushButton _btn;
    this() {
        @live _btn = new QPushButton("OK");  // ❌ CRASH ПОЗЖЕ!
    }
}

// ✅ ПРАВИЛЬНО — присваивание полю без @live
class MyWin {
    QPushButton _btn;
    this() {
        _btn = new QPushButton("OK");  // ✅ Поле инициализируется
    }
}
```

**Почему?** D-компилятор интерпретирует `@live имя = ...` КАК ОБЪЯВЛЕНИЕ НОВОЙ ЛОКАЛЬНОЙ переменной (как `auto`). Если имя совпадает с полем класса, поле остаётся **null**, а локальная переменная исчезает в конце функции. При последующем обращении к полю → **Access Violation**.

Подробнее см. раздел **«Правило 5: @live и поля класса»** ниже.

---

## Что такое @live?

Атрибут D, который защищает переменные от GC (garbage collector).

```d
// ❌ ОПАСНО (без @live)
auto btn = new QPushButton("OK");
// GC может удалить → CRASH

// ✅ БЕЗОПАСНО (с @live)
@live auto btn = new QPushButton("OK");
// GC НЕ трогает @live переменные
```

---

## Правило 1: Локальные Qt объекты должны быть @live auto

```d
@live auto win = new QMainWindow(null);
@live auto btn = new QPushButton("OK", win.getWH());
@live auto label = new QLabel("Hello", win.getWH());
```

⚠️ Обратите внимание: **только локальные переменные с `auto`**.

---

## Правило 2: GC.collect() теперь безопасен

```d
void someFunction() {
    @live auto obj = new QObject(null);
    // ... использование obj ...
    GC.collect();  // ✅ OK - @live защищает obj
    obj.delete();  // явное удаление
}
```

---

## Правило 3: Parent-owned объекты защищены

```d
@live auto parent = new QWidget(null);
@live auto child = new QPushButton("Click", parent.getWH());
// parent владеет child через Qt иерархию
parent.delete();  // удалит и child
```

---

## Правило 4: Scope-based cleanup (опционально)

```d
@live void setupUI(QMainWindow mw) {
    @live auto btn = new QPushButton("OK", mw.getWH());
    scope(exit) btn.delete();  // гарантированный delete при выходе
    
    mw.setCentralWidget(btn);
}
```

---

## ⚠️ Правило 5: @live и поля класса — КРИТИЧНО!

**Поля класса инициализируются БЕЗ @live!**

В D-языке синтаксис `@live имя = ...` всегда создаёт **новую локальную переменную**, даже если имя совпадает с полем класса. Это приводит к **маскировке (shadowing)** поля.

### ❌ НЕПРАВИЛЬНО

```d
class MainWindow {
    QTabWidget _tabs;       // поле класса
    QPushButton _btnSave;   // поле класса

    this() {
        @live _tabs = new QTabWidget(null);          // ❌ создаёт ЛОКАЛЬНУЮ _tabs
        @live _btnSave = new QPushButton("Save");    // ❌ создаёт ЛОКАЛЬНУЮ _btnSave
        // Поля класса this._tabs и this._btnSave остаются null!
    }

    void show() {
        _tabs.show();  // 💥 Access Violation — поле _tabs == null!
    }
}
```

### ✅ ПРАВИЛЬНО

```d
class MainWindow {
    QTabWidget _tabs;       // поле класса
    QPushButton _btnSave;   // поле класса

    this() {
        // Присваивание полям БЕЗ @live
        _tabs = new QTabWidget(null);            // ✅ инициализирует поле
        _btnSave = new QPushButton("Save");      // ✅ инициализирует поле

        // @live применяется только к ЛОКАЛЬНЫМ переменным с auto
        @live auto tempFont = new QFont("Arial");  // ✅ локальная защищена @live
        _tabs.setFont(tempFont.getWH());
    }

    void show() {
        _tabs.show();  // ✅ работает — поле инициализировано
    }
}
```

### Почему так?

`@live имя = ...` для D-компилятора **эквивалентно объявлению локальной переменной** с авто-выводом типа:

```d
@live _tabs = new QTabWidget(null);
// эквивалентно:
@live QTabWidget _tabs = new QTabWidget(null);  // ЛОКАЛЬНАЯ переменная
```

Локальная переменная `_tabs` существует только до конца конструктора и **затеняет (shadows)** поле класса с тем же именем. После выхода из конструктора локальная исчезает, а поле остаётся `null`.

### Памятка для AI моделей

| Контекст | Правильно | Неправильно |
|----------|-----------|-------------|
| Локальная переменная | `@live auto x = new Q...` | `@live x = new Q...` (без auto) |
| Поле класса (присваивание) | `_field = new Q...` | `@live _field = new Q...` |
| Глобальная переменная | `_global = new Q...` | `@live _global = new Q...` |
| Объявление поля класса | `QPushButton _btn;` | `@live QPushButton _btn;` |

**Запомни:** Если в коде есть `class { ... QType _name; ...}`, то в конструкторе пиши `_name = new QType(...)` БЕЗ `@live`.

### Симптомы ошибки

Если вы видите такие симптомы — у вас неправильный `@live`:
- ✅ Конструктор завершается успешно
- ✅ Все диагностические `writeln` в конструкторе срабатывают
- 💥 `object.Error@(0): Access Violation` при обращении к полю класса позже
- 💥 Crash в методах класса, использующих поля

### Как чинить (sed скрипт)

Если уже добавлен @live к полям класса по ошибке:

```bash
# Удалить @live перед присваиваниями полям класса
sed -i 's/^@live \([a-zA-Z_][a-zA-Z0-9_]* = new Q\)/        \1/g' file.d
sed -i 's/^[[:space:]]*@live \([a-zA-Z_][a-zA-Z0-9_]* = new Q\)/        \1/g' file.d
```

Регулярка ловит `@live имя = new Q...` без `auto` — это поле класса.
Локальные `@live auto имя = new Q...` остаются нетронутыми.

---

## Часто используемые паттерны

### Создание окна с кнопкой

```d
void main() {
    LoadQt("./dll");
    @live auto app = new QApplication("MyApp");
    
    @live auto win = new QMainWindow(null);
    @live auto btn = new QPushButton("Click", win.getWH());
    
    win.setCentralWidget(btn);
    win.show();
    
    app.exec();
    app.deleteApp();
}
```

### Работа с layout

```d
@live auto win = new QWidget(null);
@live auto layout = new QVBoxLayout(win.getWH());

@live auto btn1 = new QPushButton("Button 1", null);
@live auto btn2 = new QPushButton("Button 2", null);

layout.addWidget(btn1, 0);
layout.addWidget(btn2, 0);
// btn1/btn2 теперь Qt-owned через layout
```

### Работа с dialog

```d
@live auto dlg = new QFileDialog(null);
if (dlg.exec() == 1) {
    string fileName = dlg.selectedFiles()[0];
    // ...
}
dlg.delete();
```

---

## Что изменилось в коде

### Локальные переменные

**Было:**
```d
auto widget = new QWidget(null);
// нужно помнить про disown() и delete()
```

**Стало:**
```d
@live auto widget = new QWidget(null);
// @live явно показывает, что это Qt объект
// GC его не удалит, приложение безопаснее
```

### Поля класса — НЕ МЕНЯЛИСЬ!

```d
class MyWindow {
    QPushButton _btn;  // поле объявляется как раньше

    this() {
        _btn = new QPushButton("OK");  // ✅ присваивание БЕЗ @live
        // НЕ ПИШИ: @live _btn = new QPushButton("OK"); — это создаст локальную!
    }
}
```

Поля класса защищены **самим объектом**: пока живёт MainWindow, живут и его поля. GC не трогает их, потому что они достижимы через `this`.

---

## Файлы с поддержкой @live

✅ Все 114 gen_q*.d файлов уже аннотированы
✅ Можешь использовать @live в своем коде без изменений библиотеки

---

## Если забыл @live?

```d
// Компилятор выдаст ошибку (примерно):
// Error: @live variable obj must be initialized

// Решение: добавь @live
@live auto obj = new QObject(null);
```

---

## Итог

| Раньше | Теперь |
|--------|--------|
| Надеяться что не забудешь disown() | @live явно говорит: это Qt объект |
| GC может удалить в любой момент | GC гарантированно НЕ трогает @live |
| Double-free crash возможен | Double-free исключен |
| Утечки при забывчивости | Утечка только если вообще не удалить |

---

## Ссылки

- Полный отчет: `LIVE_MIGRATION_REPORT.txt`
- Примеры: `test/test_auto_disown.d`
- Память: `.claude/memory/live_migration_completed.md`

---

**Созданы 2026-04-27 | DMD 32-bit, LDC2 1.40, DMD 2.109.1 поддерживают @live**
