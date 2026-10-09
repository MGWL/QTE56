# Добавление форматирования ячеек для QTableWidgetItem в QTE56

> **СТАТУС (2026-08-02): задача решена иначе (см. `plan_create_table_api.md`).**
> `setFont`/`setBackground`/`setForeground` добавлены в `QTableWidgetItem`
> как объектные варианты (`QFont`/`QBrush`, индексы 9271–9278), а не RGB-варианты.
> Предложенные здесь индексы 9263–9265 **заняты** другими функциями
> (9263 = setCheckState, 9264 = checkState, 9265 = setToolTip) — использовать их нельзя.
> Документ оставлен как историческая запись.

## Проблема

Нужно подсвечивать ошибочные ячейки в QTableWidget красным цветом, а также управлять шрифтом (жирный, курсив, подчёркивание, размер). Сейчас используется HTML-обёртка `<span style='color:red;'>`, но `QTableWidgetItem` в QTE56 не рендерит HTML — текст отображается как есть.

Попытка использовать `setCellWidget()` с `QLabel` (который рендерит HTML) приводит к наложению: виден и красный QLabel, и чёрный QTableWidgetItem одновременно.

## Решение — добавить API форматирования для QTableWidgetItem

### Qt API (C++)

```cpp
// QTableWidgetItem — установка цвета текста
void QTableWidgetItem::setForeground(const QBrush& brush);
QBrush QTableWidgetItem::foreground() const;

// QTableWidgetItem — установка цвета фона
void QTableWidgetItem::setBackground(const QBrush& brush);
QBrush QTableWidgetItem::background() const;

// QTableWidgetItem — установка шрифта
void QTableWidgetItem::setFont(const QFont& font);
QFont QTableWidgetItem::font() const;

// QFont — конструктор и методы
QFont::QFont(const QString& family, int pointSize = -1, int weight = -1, bool italic = false);
void QFont::setBold(bool bold);           // Жирный
void QFont::setItalic(bool italic);       // Курсив
void QFont::setUnderline(bool underline); // Подчёркивание
void QFont::setPointSize(int size);       // Размер в пунктах
void QFont::setPixelSize(int size);       // Размер в пикселях
void QFont::setStrikeOut(bool strikeOut); // Зачёркивание
```

### Что нужно добавить в QTE56

#### 1. C++ DLL (`cpp/qte56_views/` или `cpp/merged/`)

```cpp
// ═══════════════════════════════════════════════════════════════════════════════
// Цвет текста и фона
// ═══════════════════════════════════════════════════════════════════════════════

// qteQTableWidgetItem_setForeground — установить цвет текста ячейки (RGB)
// Параметры: void* item, int r, int g, int b
// Возвращает: void
extern "C" VIEWS_API void qteQTableWidgetItem_setForeground(void* item, int r, int g, int b) {
    ((QTableWidgetItem*)item)->setForeground(QBrush(QColor(r, g, b)));
}

// qteQTableWidgetItem_setBackground — установить цвет фона ячейки (RGB)
// Параметры: void* item, int r, int g, int b
// Возвращает: void
extern "C" VIEWS_API void qteQTableWidgetItem_setBackground(void* item, int r, int g, int b) {
    ((QTableWidgetItem*)item)->setBackground(QBrush(QColor(r, g, b)));
}

// ═══════════════════════════════════════════════════════════════════════════════
// Шрифт — создание и настройка QFont
// ═══════════════════════════════════════════════════════════════════════════════

// qteQFont_create — создать QFont
// Параметры: const char* family, int pointSize, int weight, bool italic
// Возвращает: void* (QFont*)
extern "C" VIEWS_API void* qteQFont_create(const char* family, int pointSize, int weight, bool italic) {
    return new QFont(QString::fromUtf8(family), pointSize, weight, italic);
}

// qteQFont_delete — удалить QFont
// Параметры: void* font
extern "C" VIEWS_API void qteQFont_delete(void* font) {
    delete (QFont*)font;
}

// qteQFont_setBold — жирный шрифт
// Параметры: void* font, bool bold
extern "C" VIEWS_API void qteQFont_setBold(void* font, bool bold) {
    ((QFont*)font)->setBold(bold);
}

// qteQFont_setItalic — курсив
// Параметры: void* font, bool italic
extern "C" VIEWS_API void qteQFont_setItalic(void* font, bool italic) {
    ((QFont*)font)->setItalic(italic);
}

// qteQFont_setUnderline — подчёркивание
// Параметры: void* font, bool underline
extern "C" VIEWS_API void qteQFont_setUnderline(void* font, bool underline) {
    ((QFont*)font)->setUnderline(underline);
}

// qteQFont_setStrikeOut — зачёркивание
// Параметры: void* font, bool strikeOut
extern "C" VIEWS_API void qteQFont_setStrikeOut(void* font, bool strikeOut) {
    ((QFont*)font)->setStrikeOut(strikeOut);
}

// qteQFont_setPointSize — размер в пунктах
// Параметры: void* font, int size
extern "C" VIEWS_API void qteQFont_setPointSize(void* font, int size) {
    ((QFont*)font)->setPointSize(size);
}

// qteQFont_setPixelSize — размер в пикселях
// Параметры: void* font, int size
extern "C" VIEWS_API void qteQFont_setPixelSize(void* font, int size) {
    ((QFont*)font)->setPixelSize(size);
}

// qteQFont_setFamily — семейство шрифтов
// Параметры: void* font, const char* family
extern "C" VIEWS_API void qteQFont_setFamily(void* font, const char* family) {
    ((QFont*)font)->setFamily(QString::fromUtf8(family));
}

// ═══════════════════════════════════════════════════════════════════════════════
// Применение шрифта к ячейке
// ═══════════════════════════════════════════════════════════════════════════════

// qteQTableWidgetItem_setFont — установить шрифт ячейки
// Параметры: void* item, void* font (QFont*)
// Возвращает: void
extern "C" VIEWS_API void qteQTableWidgetItem_setFont(void* item, void* font) {
    ((QTableWidgetItem*)item)->setFont(*(QFont*)font);
}
```

#### 2. D-обёртка (`d/gen/gen_qtablewidget.d`)

```d
// В loadQTableWidget() — добавить индексы (следующие свободные после 9262)
mixin(generateFunQt(9263, "qteQTableWidgetItem_setForeground", "QTableWidget"));
mixin(generateFunQt(9264, "qteQTableWidgetItem_setBackground", "QTableWidget"));
mixin(generateFunQt(9265, "qteQTableWidgetItem_setFont", "QTableWidget"));
```

#### 3. D-обёртка для QFont (`d/gen/gen_qfont.d` — уже существует, нужно добавить)

Проверить `d/gen/gen_qfont.d` — если есть, добавить недостающие методы. Если нет — создать.

```d
// В loadQFont() — добавить индексы
mixin(generateFunQt(XXXX, "qteQFont_create", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_delete", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setBold", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setItalic", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setUnderline", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setStrikeOut", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setPointSize", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setPixelSize", "QFont"));
mixin(generateFunQt(XXXX, "qteQFont_setFamily", "QFont"));

// В классе QFont — добавить методы
class QFont : QObject {
    this(string family, int pointSize = -1, int weight = -1, bool italic = false) {
        p_QObject = pFunQt[XXXX](toQString(family), pointSize, weight, italic ? 1 : 0);
    }
    
    void setBold(bool bold) { pFunQt[XXXX](p_QObject, bold ? 1 : 0); }
    void setItalic(bool italic) { pFunQt[XXXX](p_QObject, italic ? 1 : 0); }
    void setUnderline(bool underline) { pFunQt[XXXX](p_QObject, underline ? 1 : 0); }
    void setStrikeOut(bool strikeOut) { pFunQt[XXXX](p_QObject, strikeOut ? 1 : 0); }
    void setPointSize(int size) { pFunQt[XXXX](p_QObject, size); }
    void setPixelSize(int size) { pFunQt[XXXX](p_QObject, size); }
    void setFamily(string family) { pFunQt[XXXX](p_QObject, toQString(family)); }
}
```

#### 4. В классе QTableWidgetItem (`d/gen/gen_qtablewidget.d`)

```d
void setForeground(int r, int g, int b) {
    pFunQt[9263](p_QObject, r, g, b);
}

void setBackground(int r, int g, int b) {
    pFunQt[9264](p_QObject, r, g, b);
}

void setFont(QFont font) {
    pFunQt[9265](p_QObject, font.p_QObject);
}
```

#### 5. Реестр (`registry/functions.csv`)

```csv
9263,QTableWidgetItem,qteQTableWidgetItem_setForeground,qte56_views
9264,QTableWidgetItem,qteQTableWidgetItem_setBackground,qte56_views
9265,QTableWidgetItem,qteQTableWidgetItem_setFont,qte56_views
```

## Использование в excel_import.d

### Простой вариант — только цвет

```d
if (hasError) {
    auto item = new QTableWidgetItem(cellText);
    item.setForeground(255, 0, 0);        // Красный текст
    item.setBackground(255, 200, 200);      // Светло-красный фон (опционально)
    g_table.setItem(row, col, item);
}
```

### Расширенный вариант — цвет + шрифт

```d
if (hasError) {
    auto item = new QTableWidgetItem(cellText);
    item.setForeground(255, 0, 0);        // Красный текст
    item.setBackground(255, 240, 240);      // Светло-красный фон
    
    // Создаём шрифт: Arial, 10pt, жирный, подчёркнутый
    auto font = new QFont("Arial", 10, 75, false);  // 75 = QFont::Bold
    font.setUnderline(true);
    item.setFont(font);
    
    g_table.setItem(row, col, item);
}
```

### Варианты оформления ошибок

```d
// Только красный текст
item.setForeground(255, 0, 0);

// Красный текст + светло-красный фон
item.setForeground(200, 0, 0);
item.setBackground(255, 220, 220);

// Жирный красный текст
auto font = new QFont("Segoe UI", 9, 75, false);
item.setFont(font);
item.setForeground(255, 0, 0);

// Подчёркнутый (для акцента)
auto font = new QFont("Segoe UI", 9, 50, false);
font.setUnderline(true);
item.setFont(font);
item.setForeground(255, 0, 0);
```

## Свободные индексы

- `9263` — свободен (последний использованный: 9262 = qteQTableWidgetItem_setTextAlignment)
- `9264` — свободен
- `9265` — свободен

## Файлы для изменения

1. `cpp/qte56_views/` или `cpp/merged/` — добавить C++ функции
2. `d/gen/gen_qtablewidget.d` — добавить D-обёртки для QTableWidgetItem
3. `d/gen/gen_qfont.d` — добавить/расширить D-обёртки для QFont
4. `registry/functions.csv` — зарегистрировать индексы
5. `apps/excel_import/excel_import.d` — использовать новый API

## Примечания

- `QFont::Weight` в Qt: `Light = 25`, `Normal = 50`, `Medium = 57`, `Bold = 75`, `Black = 87`
- `QFont` в Qt 5.13: `setBold(true)` эквивалентно `setWeight(Bold)`
- `QFont` создаётся на C++ стороне, нужно удалять через `qteQFont_delete` или использовать RAII в D
- Альтернатива: `qteQFont_create` возвращает `void*`, D-обёртка `QFont` хранит указатель
