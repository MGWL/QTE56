# CPP_DLL_PATTERNS — Паттерны написания C++ DLL для QTE56

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [BUILD_KNOWLEDGE_TRANSFER.md](BUILD_KNOWLEDGE_TRANSFER.md)

Документ предназначен для AI-ассистентов. Содержит исчерпывающее описание всех паттернов, применяемых в C++ обёртках проекта QTE56. Достаточен для написания любого нового wrapper без обращения к существующему коду.

---

## 1. Макрос EXPORT и структура заголовка

Каждый модуль имеет **собственный** API-макрос. Имя макроса = `<CLASSNAME>_API` в верхнем регистре.

```cpp
// qte56_qfoo.h
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFOO_BUILD        // определяется только при сборке DLL
    #define QFOO_API __declspec(dllexport)
  #else
    #define QFOO_API __declspec(dllimport)
  #endif
#else
  #define QFOO_API __attribute__((visibility("default")))  // Linux/macOS
#endif

extern "C" {

QFOO_API void* qteQFoo_create(void* parent);
QFOO_API void  qteQFoo_delete(void* w);
QFOO_API void  qteQFoo_setText(void* w, void* text);  // text = QString*
QFOO_API void* qteQFoo_text(void* w);                 // returns new QString*

} // extern "C"
```

Правила:
- `#pragma once` — всегда, без include guards.
- `extern "C" { ... }` — весь публичный API внутри блока в заголовке.
- Макрос `QTE56_QFOO_BUILD` добавляется в `.pro` через `DEFINES += QTE56_QFOO_BUILD`.
- В `.cpp` файле либо `#ifndef QTE56_QFOO_BUILD / #define ... / #endif` перед include, либо это определение уже приходит из `.pro`. Оба варианта встречаются в проекте.

---

## 2. Структура .cpp файла

```cpp
// qte56_qfoo.cpp
#ifndef QTE56_QFOO_BUILD
#define QTE56_QFOO_BUILD
#endif
#include "qte56_qfoo.h"
#include <QFoo>
#include <QString>

extern "C" QFOO_API void* qteQFoo_create(void* parent) {
    return new QFoo((QWidget*)parent);
}

extern "C" QFOO_API void qteQFoo_delete(void* w) {
    delete (QFoo*)w;
}
```

Правила:
- Каждая функция снабжается `extern "C" QFOO_API` — дублирование по сравнению с заголовком допустимо и является стандартной практикой проекта.
- Никакого `namespace`. Все функции в глобальном пространстве имён.
- Порядок в .cpp соответствует порядку в .h (lifecycle → properties → methods → signals → events).

---

## 3. Соглашения об именовании функций

```
qte<ClassName>_<methodName>[_<signature>]
```

| Суффикс | Значение |
|---------|----------|
| _(нет)_ | единственная перегрузка |
| `_ii` | два int-аргумента |
| `_iiii` | четыре int |
| `_p` | аргумент — value-type через void* (QPoint, QSize, QRect) |
| `_pp` | два таких аргумента |
| `_s` | QString* аргумент |
| `_v` | void (нет значимых аргументов, но есть перегрузки) |
| `_w` | QWidget* |
| `_wp` | QWidget* + флаг |
| число в конце | кол-во аргументов (вариант от генератора) |

Примеры из реального кода:
```
qteQWidget_setMinimumSize_p(void* obj, void* qsize)
qteQWidget_setMinimumSize_ii(void* obj, int w, int h)
qteQWidget_resize_p / qteQWidget_resize_ii
qteQGridLayout_addWidget5(...)   // 5 аргументов
qteQBoxLayout_insertWidget(...)  // уникальное имя без суффикса
```

---

## 4. QString: передача между D и C++

### 4.1 Создание QString из D-строки

D хранит строки как `wstring` (UTF-16, 2 байта на символ). Функция в `qte56_qcore`:

```cpp
// D передаёт: void* = указатель на wchar_t данные, int len = длина в символах
extern "C" QCORE_API void* qteQString_fromWStr(void* s, int len) {
    return new QString(reinterpret_cast<const QChar*>(s), len);
}
```

D-сторона:
```d
void* qs = pFunQt[20](str.ptr, cast(int)str.length);  // qteQString_fromWStr
scope(exit) pFunQt[22](qs);  // qteQString_free — ВСЕГДА после использования
```

### 4.2 Передача QString в C++ функцию

Если C++ функция принимает `void* text` — это `QString*`:

```cpp
// В .cpp:
void qteQFoo_setText(void* w, void* text) {
    ((QFoo*)w)->setText(*(QString*)text);   // разыменование через *
}

// Если функция принимает const QString&:
((QFoo*)w)->setTitle(*(const QString*)text);

// Если функция принимает несколько строк:
void qteQBar_showMessage(void* w, void* title, void* msg) {
    ((QBar*)w)->showMessage(*(QString*)title, *(QString*)msg);
}
```

Ключевой момент: `*(QString*)ptr` — разыменование указателя до значения. Никогда не передавать `(QString*)ptr` туда, где нужен `QString` по значению/ссылке.

### 4.3 Возврат QString в D

Функции, возвращающие строку, возвращают `void*` — это `new QString(...)`. D должен освободить через `pFunQt[22]` (qteQString_free).

```cpp
void* qteQFoo_text(void* w) {
    return new QString(((QFoo*)w)->text());
}

void* qteQFoo_errorString(void* w) {
    return new QString(((QFoo*)w)->errorString());
}
```

D-сторона читает через `qteQString_toWStr`, затем вызывает `qteQString_free`. **Правило**: вызов `_free` обязателен после каждого вызова функции, возвращающей `QString*`. Утечка памяти — основная ошибка.

### 4.4 Передача void* QString* в принимающий аргумент (value type deref)

Когда Qt-функция принимает `QString` по значению — C++ делает копию. Это нормально:
```cpp
// QFormLayout::addRow(const QString& label, QWidget* field)
void qteQFormLayout_addRow(void* layout, void* label, void* widget) {
    ((QFormLayout*)layout)->addRow(
        *(QString*)label,           // копия делается Qt
        (QWidget*)widget);
}
```

---

## 5. Передача QObject* и QWidget*

Все Qt-объекты в публичном API — `void*`. Кастование:

| Что передано | Как кастовать |
|-------------|---------------|
| Любой виджет (QWidget и потомки) | `(QWidget*)ptr` |
| QObject и не-виджет наследники | `(QObject*)ptr` |
| Конкретный тип внутри реализации | `(QFoo*)ptr` |
| Layout | `(QLayout*)ptr` или `(QBoxLayout*)ptr` и т.д. |
| QAbstractButton* | `(QAbstractButton*)ptr` |

Правило: в публичном API всегда `void*`; внутри `.cpp` каст к нужному типу без проверок. Проект не использует `dynamic_cast` в DLL-функциях — производительность и простота приоритетнее.

Пример двойного каста (eQWidget — событийная обёртка над QWidget):
```cpp
void qteQWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQWidget* obj = (eQWidget*)w;   // знаем точный тип, т.к. сами создали
    // ...
}
```

---

## 6. Value types: QColor, QFont, QPixmap, QRect, QSize, QPoint

Value types Qt (не-QObject, копируются по значению) обрабатываются как **heap-allocated объекты**, передаются как `void*`.

### 6.1 Паттерн pack/unpack (QRect, QSize, QPoint)

Для простых структур с числовыми полями — явные pack/unpack функции:

```cpp
void* qteQRect_pack(int x, int y, int w, int h) {
    return new QRect(x, y, w, h);
}

void qteQRect_unpack(void* r, int* x, int* y, int* w, int* h) {
    QRect* rect = (QRect*)r;
    *x = rect->x(); *y = rect->y();
    *w = rect->width(); *h = rect->height();
    delete rect;   // unpack = read + free
}

void qteQRect_free(void* r) { delete (QRect*)r; }
```

D: либо `unpack` (читает и освобождает), либо хранит `void*` и позже вызывает `free`.

### 6.2 Передача value type как аргумент

Когда Qt-функция принимает QSize/QRect/QPoint/QPixmap/QIcon по значению или по ссылке:

```cpp
// Qt принимает const QPixmap& — разыменовываем
void qteQSplashScreen_setPixmap(void* ss, void* pixmap) {
    ((QSplashScreen*)ss)->setPixmap(*(const QPixmap*)pixmap);
}

// QIcon — аналогично
void qteQSystemTrayIcon_setIcon(void* tray, void* icon) {
    ((QSystemTrayIcon*)tray)->setIcon(*(const QIcon*)icon);
}

// QSize — аналогично
void qteQWidget_setMinimumSize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setMinimumSize(*(const QSize*)p0);
}
```

### 6.3 Возврат value type

Функции, возвращающие QRect/QSize/QPoint, возвращают `new SomeType(...)`:

```cpp
void* qteQWidget_size(void* _obj) {
    return new QSize(((QWidget*)_obj)->size());
}

void* qteQWidget_rect(void* _obj) {
    return new QRect(((QWidget*)_obj)->rect());
}
```

D освобождает через соответствующую `_free` функцию.

### 6.4 QColor: передача как RGBA uint

Для QColor вместо heap-объекта иногда используется упакованный `unsigned int rgba`:

```cpp
void qteQSplashScreen_showMessage(void* ss, void* msg,
        int alignment, unsigned int rgba) {
    ((QSplashScreen*)ss)->showMessage(
        *(QString*)msg,
        (Qt::Alignment)alignment,
        QColor::fromRgba((QRgb)rgba));
}
```

D передаёт `0xAARRGGBB` как `uint`. Нет выделения памяти, нет освобождения.

---

## 7. Булевы значения

Qt возвращает `bool`, C++ ABI не гарантирует размер bool в DLL-границах. Проект использует `int`:

```cpp
// Возврат bool → int
int qteQWidget_isVisible(void* _obj) {
    return ((QWidget*)_obj)->isVisible() ? 1 : 0;
}

int qteQSystemTrayIcon_isVisible(void* tray) {
    return ((QSystemTrayIcon*)tray)->isVisible() ? 1 : 0;
}

// Приём bool → int
void qteQWidget_setEnabled(void* _obj, int p0) {
    ((QWidget*)_obj)->setEnabled((p0 != 0));
}

void qteQTimer_setSingleShot(void* _obj, int singleShot) {
    ((QTimer*)_obj)->setSingleShot((singleShot != 0));
}
```

Исключение: `qteQPointer_isNull` возвращает `bool` — единственное место, где это сделано намеренно (вызывается только из qte56_qcore.dll той же среды выполнения).

---

## 8. Перечисления (enum)

Qt enum → int в параметрах и возвращаемых значениях:

```cpp
// Приём enum
void qteQWidget_setWindowModality(void* _obj, int windowModality) {
    ((QWidget*)_obj)->setWindowModality((Qt::WindowModality)windowModality);
}

// Возврат enum
int qteQWidget_windowModality(void* _obj) {
    return ((QWidget*)_obj)->windowModality();  // неявное преобразование enum→int
}

// Флаги (QFlags<>) — тоже int
void qteQWidget_setWindowFlags(void* _obj, int type) {
    ((QWidget*)_obj)->setWindowFlags((Qt::WindowFlags)type);
}
```

---

## 9. Паттерн eSlot: Qt signals → D callbacks (для стандартных сигналов)

`eSlot` — QObject-подкласс (определён в `cpp/qte56_qcore/eslot.h`), служит мостом: Qt-сигнал → D-функция.

### 9.1 Структура eSlot

```cpp
class eSlot : public QObject {
    Q_OBJECT
public:
    void* cb    = nullptr;   // адрес D callback-функции
    void* dthis = nullptr;   // адрес D-объекта (передаётся первым аргументом)
    int   n     = 0;         // тег (номер сигнала в D-коде)

    explicit eSlot(QObject* parent = nullptr) : QObject(parent) {}

public slots:
    void invoke_v()
        { if (cb) ((void(*)(void*,int))cb)(dthis, n); }

    void invoke_b(bool v)
        { if (cb) ((void(*)(void*,int,int))cb)(dthis, n, (int)v); }

    void invoke_i(int v)
        { if (cb) ((void(*)(void*,int,int))cb)(dthis, n, v); }

    void invoke_ii(int a, int b)
        { if (cb) ((void(*)(void*,int,int,int))cb)(dthis, n, a, b); }

    void invoke_d(double v)
        { if (cb) ((void(*)(void*,int,double))cb)(dthis, n, v); }

    void invoke_s(const QString& s)
        { if (cb) ((void(*)(void*,int,void*))cb)(dthis, n, (void*)&s); }

    void invoke_p(const QPoint& p)
        { if (cb) ((void(*)(void*,int,int,int))cb)(dthis, n, p.x(), p.y()); }

    void invoke_qp(void* ptr)
        { if (cb) ((void(*)(void*,int,void*))cb)(dthis, n, ptr); }
};
```

**Важно**: строка `s` в `invoke_s` передаётся как `(void*)&s` — адрес временного объекта стека. D должен прочитать её до возврата из callback.

### 9.2 Жизненный цикл eSlot

1. D вызывает `qteQPointer_new(1)` → получает `QPointer<eSlot>*`
2. D вызывает `qteESlot_create(qptr, parent_widget)` → eSlot создаётся с Qt-parent; Qt удалит его при удалении parent
3. D вызывает `qteESlot_set(slot, cb, dthis, n)` → записывает callback
4. D вызывает `qteConnect(sender, "2signal()", slot, "1invoke_i(int)", 0)` — старый синтаксис SIGNAL/SLOT
5. При удалении parent QPointer автоматически обнуляется
6. D в деструкторе удаляет только QPointer-обёртку: `qteQPointer_delete(qptr, 1)`

### 9.3 Строковый синтаксис connect

```cpp
extern "C" QCORE_API void qteConnect(void* sender, const char* signal,
                                      void* receiver, const char* slot, int conn_type) {
    QObject::connect(
        (QObject*)sender, signal,
        (QObject*)receiver, slot,
        (Qt::ConnectionType)conn_type
    );
}
```

D передаёт строки вида `"2clicked()"`, `"1invoke_v()"` (префикс 2=signal, 1=slot).

---

## 10. Lambda-connect: для специализированных сигналов

Когда сигнал нельзя легко подключить через строковый синтаксис eSlot (перегрузки, нестандартные типы аргументов, QPointer-результаты) — используется lambda.

### 10.1 Простой сигнал без аргументов

```cpp
extern "C" SYSTRAY_API void qteQSystemTrayIcon_connect_messageClicked(
        void* tray, void (*cb)()) {
    QObject::connect((QSystemTrayIcon*)tray, &QSystemTrayIcon::messageClicked,
        [cb](){ cb(); });
}
```

### 10.2 Сигнал с enum-аргументом

```cpp
extern "C" SYSTRAY_API void qteQSystemTrayIcon_connect_activated(
        void* tray, void (*cb)(int)) {
    QObject::connect((QSystemTrayIcon*)tray, &QSystemTrayIcon::activated,
        [cb](QSystemTrayIcon::ActivationReason r){ cb((int)r); });
}
```

### 10.3 Перегруженный сигнал (QOverload)

```cpp
void qteQProcess_connect_finished(void* proc, void* cb) {
    auto fn = (void(*)(int, int))cb;
    QObject::connect(
        (QProcess*)proc,
        QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [fn](int code, QProcess::ExitStatus st) { fn(code, (int)st); });
}
```

`QOverload<...>::of(...)` — стандартный способ указать конкретную перегрузку сигнала в Qt5.

### 10.4 Сигнал с QAbstractButton* (pointer в D)

```cpp
void qteQMessageBox_connect_buttonClicked(void* w, void* cb, void* dthis) {
    QObject::connect((QMessageBox*)w, &QMessageBox::buttonClicked,
        [cb, dthis](QAbstractButton* p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)p);
        });
}
```

D получает `void*` — сырой указатель на QAbstractButton. D может использовать его только как идентификатор или передавать обратно в C++.

### 10.5 Сигнатура D-callback для lambda-connect

В отличие от eSlot (который всегда имеет `dthis` и `n`), lambda-connect функции сами определяют сигнатуру. Конвенции:
- Простой callback без контекста: `void (*cb)(int)`, `void (*cb)()`
- Callback с контекстом D-объекта: `void* cb, void* dthis` → lambda захватывает оба, вызывает как `((void(*)(void*,...))cb)(dthis, ...)`

---

## 11. EventProxy (eQWidget) — 18 типов событий

Для виджетов, которым нужна обработка событий Qt (mouse, keyboard, resize и т.д.), создаётся C++-подкласс с именем `eQ<ClassName>`. Это внутренний (не-публичный) класс, определённый в `.cpp` файле.

### 11.1 Структура eQWidget

```cpp
class eQWidget : public QWidget {
public:
    // По два поля на каждый тип события: callback + D-объект
    void* cb_01 = nullptr;  void* dt_01 = nullptr;  // 1: mousePressEvent
    void* cb_02 = nullptr;  void* dt_02 = nullptr;  // 2: mouseReleaseEvent
    void* cb_03 = nullptr;  void* dt_03 = nullptr;  // 3: mouseDoubleClickEvent
    void* cb_04 = nullptr;  void* dt_04 = nullptr;  // 4: mouseMoveEvent
    void* cb_05 = nullptr;  void* dt_05 = nullptr;  // 5: keyPressEvent
    void* cb_06 = nullptr;  void* dt_06 = nullptr;  // 6: keyReleaseEvent
    void* cb_07 = nullptr;  void* dt_07 = nullptr;  // 7: resizeEvent
    void* cb_08 = nullptr;  void* dt_08 = nullptr;  // 8: moveEvent
    void* cb_09 = nullptr;  void* dt_09 = nullptr;  // 9: closeEvent
    void* cb_10 = nullptr;  void* dt_10 = nullptr;  // 10: showEvent
    void* cb_11 = nullptr;  void* dt_11 = nullptr;  // 11: hideEvent
    void* cb_12 = nullptr;  void* dt_12 = nullptr;  // 12: enterEvent
    void* cb_13 = nullptr;  void* dt_13 = nullptr;  // 13: leaveEvent
    void* cb_14 = nullptr;  void* dt_14 = nullptr;  // 14: wheelEvent
    void* cb_15 = nullptr;  void* dt_15 = nullptr;  // 15: focusInEvent
    void* cb_16 = nullptr;  void* dt_16 = nullptr;  // 16: focusOutEvent
    void* cb_17 = nullptr;  void* dt_17 = nullptr;  // 17: contextMenuEvent
    void* cb_18 = nullptr;  void* dt_18 = nullptr;  // 18: paintEvent

    explicit eQWidget(QWidget* parent = nullptr) : QWidget(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QWidget::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QWidget::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QWidget::contextMenuEvent(e);
    }
    void paintEvent(QPaintEvent* e) override {
        if (cb_18) ((void(*)(void*, void*))cb_18)(dt_18, static_cast<QPaintDevice*>(this));
        else QWidget::paintEvent(e);
    }
};
```

### 11.2 Таблица сигнатур D-callback по ID события

| ID | Событие | C++ тип | Сигнатура D callback |
|----|---------|---------|---------------------|
| 1 | mousePressEvent | QMouseEvent | `void cb(void* dt, int x, int y, int button)` |
| 2 | mouseReleaseEvent | QMouseEvent | `void cb(void* dt, int x, int y, int button)` |
| 3 | mouseDoubleClickEvent | QMouseEvent | `void cb(void* dt, int x, int y, int button)` |
| 4 | mouseMoveEvent | QMouseEvent | `void cb(void* dt, int x, int y)` |
| 5 | keyPressEvent | QKeyEvent | `void cb(void* dt, int key, int modifiers)` |
| 6 | keyReleaseEvent | QKeyEvent | `void cb(void* dt, int key, int modifiers)` |
| 7 | resizeEvent | QResizeEvent | `void cb(void* dt, int w, int h)` |
| 8 | moveEvent | QMoveEvent | `void cb(void* dt, int x, int y)` |
| 9 | closeEvent | QCloseEvent | `void cb(void* dt, int* accept)` — `*accept=0` отменяет закрытие |
| 10 | showEvent | QShowEvent | `void cb(void* dt)` |
| 11 | hideEvent | QHideEvent | `void cb(void* dt)` |
| 12 | enterEvent | QEvent | `void cb(void* dt)` |
| 13 | leaveEvent | QEvent | `void cb(void* dt)` |
| 14 | wheelEvent | QWheelEvent | `void cb(void* dt, int dx, int dy)` — angleDelta |
| 15 | focusInEvent | QFocusEvent | `void cb(void* dt, int reason)` |
| 16 | focusOutEvent | QFocusEvent | `void cb(void* dt, int reason)` |
| 17 | contextMenuEvent | QContextMenuEvent | `void cb(void* dt, int x, int y, int reason)` |
| 18 | paintEvent | QPaintEvent | `void cb(void* dt, void* paintDevice)` |

**Важно для closeEvent (ID=9)**: C++ читает `*accept`. Если D установил `*accept = 0`, вызывается `e->ignore()`. Если callback не установлен — вызывается `QWidget::closeEvent(e)` (default: закрыть).

**Важно для paintEvent (ID=18)**: D получает `void*` — указатель на `QPaintDevice` (т.е. на сам виджет). D использует его для создания QPainter: `new QPainter((QPaintDevice*)ptr)`.

### 11.3 Функция setEventHandler

```cpp
extern "C" QFOO_API void qteQFoo_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQFoo* obj = (eQFoo*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;
        case 18: obj->cb_18 = cb; obj->dt_18 = dthis; break;  // только для виджетов с paintEvent
        default: break;
    }
}
```

Передача `cb=nullptr` отключает обработчик — нет специальной функции "remove handler".

### 11.4 Какие виджеты имеют eQ-класс

Все классы, которые D-код может создавать через `new QFoo(parent)`, имеют `eQFoo`. Это включает QWidget, QDialog, QMessageBox, QMainWindow, все стандартные виджеты. QMessageBox имеет 17 событий (без paintEvent — он не переопределяет отрисовку).

Классы без виджетных событий (QTimer, QProcess, QSystemTrayIcon) не имеют eQ-обёртки.

---

## 12. Структура .pro файла: отдельный DLL

Стандартный `.pro` для самостоятельного DLL-модуля:

```pro
QT       += core gui widgets
TARGET    = qte56_qfoo
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QFOO_BUILD
# Выбор папки назначения по QTE56_ARCH (по умолчанию 32)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) { QTE56_ARCH = 32 }
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib
SOURCES   = qte56_qfoo.cpp
HEADERS   = qte56_qfoo.h
```

Точный набор `QT +=` зависит от используемых Qt-классов:

| Модули | Когда |
|--------|-------|
| `core` | всегда |
| `gui` | QPixmap, QPainter, QImage, QIcon, QColor, QFont |
| `widgets` | любой QWidget и потомки |
| `sql` | QSqlDatabase, QSqlQuery и т.д. |
| `network` | QNetworkAccessManager и т.д. |

`CONFIG -= debug_and_release` — критично для MinGW: без этого qmake пытается собрать два конфига одновременно.

`DESTDIR` выбирается по `QTE56_ARCH`: `dll/dll32` (win32_qt5, по умолчанию) или
`dll/dll64` (win64_qt6); для Linux — `../../../lib` (через `unix:`). Относительный
путь зависит от расположения `.pro` файла. Для `cpp/qt5/qte56_qfoo/qte56_qfoo.pro` →
`../../../dll/dll32` = `arch_new/dll/dll32/`.

---

## 13. Структура .pro файла: Merged DLL

Merged DLL объединяет несколько классов в один бинарный файл. Используется для уменьшения числа DLL, загружаемых при старте.

```pro
# qte56_widgets.pro — merged DLL
QT       += core widgets
TARGET    = qte56_widgets
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release

DEFINES  += \
    QTE56_QWIDGET_BUILD \
    QTE56_QFRAME_BUILD \
    QTE56_QLABEL_BUILD \
    QTE56_QPUSHBUTTON_BUILD \
    QTE56_QLAYOUT_BUILD
    # ... все включённые модули

QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) { QTE56_ARCH = 32 }
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib

INCLUDEPATH += \
    ../../qte56_qwidget \
    ../../qte56_qframe \
    ../../qte56_qlabel
    # ... все модули

SOURCES  += \
    ../../qte56_qwidget/qte56_qwidget.cpp \
    ../../qte56_qframe/qte56_qframe.cpp \
    ../../qte56_qlabel/qte56_qlabel.cpp
    # ...

HEADERS  += \
    ../../qte56_qwidget/qte56_qwidget.h \
    ../../qte56_qframe/qte56_qframe.h \
    ../../qte56_qlabel/qte56_qlabel.h
    # ...
```

Ключевые отличия от одиночного DLL:
- `DEFINES` перечисляет все `QTE56_QFOO_BUILD` для всех включённых модулей.
- `INCLUDEPATH` нужен, т.к. .cpp файлы включают заголовки из своих папок.
- `DESTDIR` имеет на один уровень `../` больше (merged .pro лежит в `cpp/qt5/merged/qte56_widgets/`).
- Исходные файлы — пути относительно merged .pro к оригинальным .cpp.

---

## 14. Структура .pro файла: Standalone DLL без widgets

Для модулей, не использующих Qt Widgets (SQL, network, non-GUI):

```pro
# qte56_qsql.pro
QT       += core sql
QT       -= gui widgets        # явное исключение
TARGET    = qte56_sql
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QSQL_BUILD
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) { QTE56_ARCH = 32 }
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib
SOURCES   = qte56_qsql.cpp
HEADERS   = qte56_qsql.h
```

`QT -= gui widgets` — обязательно, иначе qmake добавит лишние зависимости.

---

## 15. Управление памятью

### 15.1 Qt parent-child (виджеты)

Если виджет создан с `parent != nullptr`, Qt удалит его при удалении parent. D не должен вызывать `_delete` для таких объектов. В D-коде управляется через `disown()` — D передаёт владение Qt и сбрасывает флаг `_qt_owned`.

```cpp
// C++ всегда принимает parent как void* и кастует
void* qteQLabel_create(void* parent) {
    return new eQLabel((QWidget*)parent);  // parent может быть nullptr
}
```

### 15.2 Объекты без parent (независимые)

Если создан без parent (или с null), D отвечает за вызов `_delete`.

### 15.3 Value types (QString*, QRect*, QSize*, QPoint*)

Всегда возвращаются как `new T(...)`, всегда освобождаются D через соответствующую `_free` функцию или `qteQString_free`. C++ никогда не кэширует и не переиспользует эти объекты.

### 15.4 Сырые буферы (QByteArray содержимое)

Для бинарных данных (stdout/stderr QProcess) C++ копирует в `new char[n]`, возвращает `void* + int* len`. D освобождает через специальную `_freeBuffer`:

```cpp
static void* baToHeap(const QByteArray& ba, int* len) {
    *len = ba.size();
    if (ba.size() == 0) return nullptr;
    char* buf = new char[ba.size()];
    memcpy(buf, ba.constData(), ba.size());
    return buf;
}

void qteQProcess_freeBuffer(void* buf) {
    delete[] (char*)buf;
}
```

### 15.5 eSlot

eSlot создаётся с Qt-parent → Qt удалит при удалении parent. D удаляет только QPointer-обёртку (`qteQPointer_delete`), не сам eSlot.

### 15.6 Layout ownership

После `widget->setLayout(layout)` Qt берёт владение layout. В D это управляется двумя способами:

**Typed API (рекомендуется)** — `disown()` вызывается автоматически:
```d
win.setLayout(vbox);        // vbox.disown() не нужен
vbox.addWidget(lbl);        // lbl.disown() не нужен
vbox.addLayout(inner);      // inner.disown() не нужен
mw.setCentralWidget(w);     // w.disown() не нужен
tabs.addTab(page, "Name");  // page.disown() не нужен
```

**Void* API (обратная совместимость)** — `disown()` нужен вручную:
```d
win.setLayout(layout.getWH());
layout.disown();  // без этого D попытается удалить уже удалённый layout
```

Типизированные перегрузки реализованы (с 2026-04-09) в: gen_qlayout.d, gen_qwidget.d, gen_qmainwindow.d, gen_qtabwidget.d, gen_qstackedwidget.d, gen_qtoolbar.d, gen_qscrollarea.d, gen_qdockwidget.d, gen_qsplitter.d.

---

## 16. Экспорт статических методов Qt

Некоторые Qt-методы статические (вызываются на null-объекте или на классе). В DLL они оборачиваются так:

### 16.1 Статический метод без объекта

```cpp
// QProcess::startDetached(program, args)
int qteQProcess_startDetached(void* program, void* args) {
    return QProcess::startDetached(*(QString*)program, qsListFromSep1(args)) ? 1 : 0;
}

// QSystemTrayIcon::supportsMessages()
int qteQSystemTrayIcon_supportsMessages() {
    return QSystemTrayIcon::supportsMessages() ? 1 : 0;  // нет аргументов
}
```

### 16.2 Статический метод через фиктивный объект

Генератор иногда создаёт функции с первым аргументом `void* _obj`, но вызывает статический метод, игнорируя его:

```cpp
void qteQApplication_setStyle(void* app, void* name) {
    (void)app;  // намеренно игнорируем, это статический метод
    QApplication::setStyle(*(QString*)name);
}

void* qteQApplication_appName(void* app) {
    (void)app;
    return new QString(QApplication::applicationName());
}
```

`(void)app;` подавляет предупреждение компилятора о неиспользуемом параметре.

### 16.3 QMessageBox static dialogs

```cpp
// QMessageBox::question (статический метод)
int qteQMessageBox_question_wsspp(void* /*_obj*/, void* parent,
        void* title, void* text, int buttons, int defaultButton) {
    return QMessageBox::question(
        (QWidget*)parent, *(QString*)title, *(QString*)text,
        (QMessageBox::StandardButtons)buttons,
        (QMessageBox::StandardButton)defaultButton);
}
```

Первый аргумент `_obj` закомментирован в имени — он не используется.

---

## 17. QStringList через \x01-разделитель

Там, где Qt принимает QStringList, D передаёт одну void* QString* со строками, разделёнными символом `\x01` (ASCII 1). C++ сплитует обратно:

```cpp
static QStringList qsListFromSep1(void* qs) {
    if (!qs) return QStringList();
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1));  // KeepEmptyParts по умолчанию в Qt5
}

void qteQProcess_start(void* proc, void* program, void* args) {
    ((QProcess*)proc)->start(*(QString*)program, qsListFromSep1(args));
}
```

D использует `toQStringList(string[])` — объединяет через `\x01` — создаёт QString через `qteQString_fromWStr`.

---

## 18. Возврат геометрии через out-параметры

Для функций, возвращающих несколько связанных числовых значений, используются `int*` параметры вместо heap-объектов:

```cpp
void qteQSystemTrayIcon_geometry(void* tray,
        int* x, int* y, int* w, int* h) {
    QRect r = ((QSystemTrayIcon*)tray)->geometry();
    *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
}
```

D-сторона объявляет локальные int-переменные и передаёт их адреса.

---

## 19. Необходимость Q_OBJECT в eSlot vs eQWidget

- `eSlot` объявлен в отдельном заголовке `eslot.h`, содержит `Q_OBJECT` и `public slots:` — moc обрабатывает его.
- `eQWidget` и аналогичные event-proxy классы в `.cpp` файлах **не имеют Q_OBJECT** — они переопределяют виртуальные методы, а не используют signal/slot систему. moc не нужен.
- `eSlot` включён в `.pro` через `HEADERS += eslot.h` — только для модуля `qte56_qcore`. Другие DLL включают `eslot.h` только для типа, но у них нет собственных слотов.

---

## 20. Полный пример: добавление нового класса QFoo с нуля

Предполагается: `QFoo` — виджет с методами `text()`, `setText(QString)`, сигналом `textChanged(QString)`, событием мыши. Индексный блок выделен: 20000–20020.

### Шаг 1: Создать директорию и заголовок

```
mkdir H:\qte56\arch_new\cpp\qt5\qte56_qfoo
```

Файл `qte56_qfoo.h`:
```cpp
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QFOO_BUILD
    #define QFOO_API __declspec(dllexport)
  #else
    #define QFOO_API __declspec(dllimport)
  #endif
#else
  #define QFOO_API __attribute__((visibility("default")))
#endif

extern "C" {

// Lifecycle (20000-20001)
QFOO_API void* qteQFoo_create(void* parent);
QFOO_API void  qteQFoo_delete(void* w);

// Methods (20002-20003)
QFOO_API void* qteQFoo_text(void* w);             // returns new QString* (caller frees)
QFOO_API void  qteQFoo_setText(void* w, void* s); // s = QString*

// Signals (20004)
QFOO_API void  qteQFoo_connect_textChanged(void* w, void* cb, void* dthis);

// Events (20005)
QFOO_API void  qteQFoo_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
```

### Шаг 2: Создать .cpp

Файл `qte56_qfoo.cpp`:
```cpp
#ifndef QTE56_QFOO_BUILD
#define QTE56_QFOO_BUILD
#endif
#include "qte56_qfoo.h"
#include <QFoo>
#include <QString>
#include <QMouseEvent>
#include <QResizeEvent>
#include <QCloseEvent>
#include <QShowEvent>
#include <QHideEvent>
#include <QKeyEvent>
#include <QWheelEvent>
#include <QFocusEvent>
#include <QContextMenuEvent>
#include <QMoveEvent>

class eQFoo : public QFoo {
public:
    void* cb_01 = nullptr; void* dt_01 = nullptr;  // 1: mousePressEvent
    void* cb_02 = nullptr; void* dt_02 = nullptr;  // 2: mouseReleaseEvent
    void* cb_03 = nullptr; void* dt_03 = nullptr;  // 3: mouseDoubleClickEvent
    void* cb_04 = nullptr; void* dt_04 = nullptr;  // 4: mouseMoveEvent
    void* cb_05 = nullptr; void* dt_05 = nullptr;  // 5: keyPressEvent
    void* cb_06 = nullptr; void* dt_06 = nullptr;  // 6: keyReleaseEvent
    void* cb_07 = nullptr; void* dt_07 = nullptr;  // 7: resizeEvent
    void* cb_08 = nullptr; void* dt_08 = nullptr;  // 8: moveEvent
    void* cb_09 = nullptr; void* dt_09 = nullptr;  // 9: closeEvent
    void* cb_10 = nullptr; void* dt_10 = nullptr;  // 10: showEvent
    void* cb_11 = nullptr; void* dt_11 = nullptr;  // 11: hideEvent
    void* cb_12 = nullptr; void* dt_12 = nullptr;  // 12: enterEvent
    void* cb_13 = nullptr; void* dt_13 = nullptr;  // 13: leaveEvent
    void* cb_14 = nullptr; void* dt_14 = nullptr;  // 14: wheelEvent
    void* cb_15 = nullptr; void* dt_15 = nullptr;  // 15: focusInEvent
    void* cb_16 = nullptr; void* dt_16 = nullptr;  // 16: focusOutEvent
    void* cb_17 = nullptr; void* dt_17 = nullptr;  // 17: contextMenuEvent

    explicit eQFoo(QWidget* parent = nullptr) : QFoo(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QFoo::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QFoo::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QFoo::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QFoo::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QFoo::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QFoo::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QFoo::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QFoo::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QFoo::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QFoo::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QFoo::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QFoo::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QFoo::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QFoo::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QFoo::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QFoo::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QFoo::contextMenuEvent(e);
    }
};

extern "C" {

void* qteQFoo_create(void* parent) {
    return new eQFoo((QWidget*)parent);
}

void qteQFoo_delete(void* w) {
    delete (eQFoo*)w;
}

void* qteQFoo_text(void* w) {
    return new QString(((QFoo*)w)->text());
}

void qteQFoo_setText(void* w, void* s) {
    ((QFoo*)w)->setText(*(QString*)s);
}

void qteQFoo_connect_textChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QFoo*)w, &QFoo::textChanged,
        [cb, dthis](const QString& s) {
            if (cb) ((void(*)(void*,void*))cb)(dthis, (void*)&s);
        });
}

void qteQFoo_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQFoo* obj = (eQFoo*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;
        default: break;
    }
}

} // extern "C"
```

### Шаг 3: Создать .pro

Файл `qte56_qfoo.pro`:
```pro
QT       += core gui widgets
TARGET    = qte56_qfoo
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QFOO_BUILD
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) { QTE56_ARCH = 32 }
equals(QTE56_ARCH, 64): DESTDIR = ../../../dll/dll64
else:                   DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib
SOURCES   = qte56_qfoo.cpp
HEADERS   = qte56_qfoo.h
```

### Шаг 4: Собрать

```bat
cd H:\qte56\arch_new\cpp\qt5\qte56_qfoo
C:\Qt5_13_2\5.13.2\mingw73_32\bin\qmake qte56_qfoo.pro -spec win32-g++ "CONFIG+=release"
mingw32-make -j4
```

Результат: `H:\qte56\arch_new\dll\dll32\qte56_qfoo.dll`.

Для добавления в merged DLL: добавить в `.pro` merged-а `DEFINES += QTE56_QFOO_BUILD`, `INCLUDEPATH += ../../qte56_qfoo`, `SOURCES += ../../qte56_qfoo/qte56_qfoo.cpp`, `HEADERS += ../../qte56_qfoo/qte56_qfoo.h`.

### Шаг 5: Зарегистрировать в D

Добавить индексы в `d/gen/gen_qfoo.d`, добавить `registerModule("qte56_qfoo", ...)` (или включить в существующий merged модуль).

---

## 21. Частые ошибки и как их избежать

### 21.1 Забыть разыменовать QString*

```cpp
// ОШИБКА: передаём указатель туда, где ждут ссылку/значение
((QFoo*)w)->setText((QString*)s);     // не скомпилируется или UB

// ПРАВИЛЬНО:
((QFoo*)w)->setText(*(QString*)s);    // разыменование
```

### 21.2 Вернуть ссылку на временный объект

```cpp
// ОШИБКА: возвращаем адрес временного
void* qteQFoo_text(void* w) {
    QString tmp = ((QFoo*)w)->text();
    return &tmp;  // tmp уничтожится — dangling pointer
}

// ПРАВИЛЬНО:
void* qteQFoo_text(void* w) {
    return new QString(((QFoo*)w)->text());
}
```

### 21.3 Не добавить DEFINES в .pro

Если `QTE56_QFOO_BUILD` не определён, макрос `QFOO_API` раскрывается в `__declspec(dllimport)` — DLL не будет экспортировать функции.

### 21.4 Забыть `CONFIG -= debug_and_release`

На MinGW без этого qmake создаёт Makefile, который пытается собрать debug и release одновременно в режиме "debug_and_release", что приводит к конфликтам.

### 21.5 Смешать eSlot с lambda в одном подключении

eSlot использует строковый синтаксис (`SIGNAL/SLOT` строки). Lambda — новый синтаксис (`&QFoo::signal`). Нельзя смешивать: либо `qteConnect` + строки, либо `QObject::connect` + lambda.

### 21.6 Передать неверный тип при касте

```cpp
// Если виджет создан как eQFoo, нельзя кастовать к eQBar
eQFoo* obj = (eQFoo*)w;  // OK только если w был создан как eQFoo
```

Всегда знайте, каким `new` был создан объект. В проекте все `_create` функции возвращают конкретный eQ-тип.

### 21.7 Вызов delete на виджете с parent

Если виджет имеет Qt-parent и D вызовет `_delete`, а потом parent-виджет будет удалён Qt — double free. D должен вызывать `disown()` для виджетов, переданных в parent-child владение.

### 21.8 bool в заголовке .h

`qteQPointer_isNull` возвращает `bool` — исключение. Для всех новых функций использовать `int` (1/0), не `bool`.

### 21.9 Кириллица в .bat файлах

В build-скриптах `.bat` не использовать кириллицу и многострочные `if`-блоки — cmd.exe портит UTF-8.

### 21.10 Не включить все #include в .cpp

eQ-класс с обработкой событий мыши требует `<QMouseEvent>`. eQ-класс с closeEvent требует `<QCloseEvent>`. Если не включить — будет ошибка компиляции "incomplete type QMouseEvent".

### 21.11 Не освободить временный QString* после вызова функции

```cpp
// D-код: ОШИБКА — нет scope(exit) для освобождения
void* qs = pFunQt[20](str.ptr, cast(int)str.length);
pFunQt[someFunc](obj, qs);
// qs утекает

// ПРАВИЛЬНО:
void* qs = pFunQt[20](str.ptr, cast(int)str.length);
scope(exit) pFunQt[22](qs);
pFunQt[someFunc](obj, qs);
```

---

## 22. Справочная таблица: тип параметра -> C++ код

| Что передаёт D | Тип в .h | Как использовать в .cpp |
|----------------|----------|------------------------|
| QString | `void*` | `*(QString*)arg` |
| QWidget* | `void*` | `(QWidget*)arg` |
| QObject* | `void*` | `(QObject*)arg` |
| QLayout* | `void*` | `(QLayout*)arg` |
| QAction* | `void*` | `(QAction*)arg` |
| QMenu* | `void*` | `(QMenu*)arg` |
| QIcon | `void*` | `*(const QIcon*)arg` |
| QPixmap | `void*` | `*(const QPixmap*)arg` |
| QFont | `void*` | `*(const QFont*)arg` |
| QColor (RGBA packed) | `unsigned int` | `QColor::fromRgba((QRgb)arg)` |
| QPoint | `void*` | `*(const QPoint*)arg` |
| QSize | `void*` | `*(const QSize*)arg` |
| QRect | `void*` | `*(const QRect*)arg` |
| bool | `int` | `(arg != 0)` |
| Qt enum | `int` | `(Qt::SomeEnum)arg` |
| Qt flags | `int` | `(Qt::SomeFlags)arg` |
| callback без контекста | `void (*cb)(int)` | прямой вызов `cb(val)` |
| callback с контекстом | `void* cb, void* dthis` | `((void(*)(void*,...))cb)(dthis, ...)` |
| QStringList | `void*` (QString* с \x01) | `s.split(QChar(1))` |
| binary data in | `void* data, int len` | `(const char*)data, len` |

---

## 23. Справочная таблица: тип возврата -> C++ код

| Что возвращает Qt | Тип в .h | C++ код возврата |
|-------------------|----------|-----------------|
| QString | `void*` | `return new QString(obj->method());` |
| bool | `int` | `return obj->method() ? 1 : 0;` |
| QWidget* | `void*` | `return (void*)obj->method();` |
| QObject* | `void*` | `return (void*)obj->method();` |
| QRect | `void*` | `return new QRect(obj->method());` |
| QSize | `void*` | `return new QSize(obj->method());` |
| QPoint | `void*` | `return new QPoint(obj->method());` |
| int/enum | `int` | `return (int)obj->method();` |
| double | `double` | `return obj->method();` |
| void | `void` | `obj->method();` |
| nullptr (ошибка/нет объекта) | `void*` | `return nullptr;` |
| binary data | `void*` + `int* len` | `return baToHeap(ba, len);` |
| multiple ints | `void` + out `int*` params | `*x = r.x(); *y = r.y(); ...` |
