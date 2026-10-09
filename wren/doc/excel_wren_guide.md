# excel.wren — Руководство по использованию

> ↑ Навигация: [AGENTS.md](../../AGENTS.md) → [wren/WREN_GUIDE.md](../WREN_GUIDE.md)

Библиотека для автоматизации Microsoft Excel через OLE/COM из Wren-скриптов.

## Содержание

1. [Подключение и запуск](#1-подключение-и-запуск)
2. [XlApp — приложение Excel](#2-xlapp--приложение-excel)
3. [XlBook — рабочая книга](#3-xlbook--рабочая-книга)
4. [XlSheet — рабочий лист](#4-xlsheet--рабочий-лист)
5. [XlRange — диапазон ячеек](#5-xlrange--диапазон-ячеек)
6. [XlVbaProject и XlVbaModule — макросы VBA](#6-xlvbaproject-и-xlvbamodule--макросы-vba)
7. [Вспомогательные классы](#7-вспомогательные-классы)
8. [Управление памятью (release)](#8-управление-памятью-release)
9. [Типичные задачи](#9-типичные-задачи)
10. [Ограничения и важные замечания](#10-ограничения-и-важные-замечания)

---

## 1. Подключение и запуск

```wren
import "excel" for XlApp, XlBook, XlSheet, XlRange
import "excel" for XlColor, XlAlign, XlBorder, XlFmt, XlUtil
```

Скрипт запускается через `wren_ide` или `wren_runner`. Путь к библиотеке задаётся
через `vm.addLibPath("wren/lib")`.

---

## 2. XlApp — приложение Excel

### Создание объекта

| Конструктор | Описание |
|-------------|----------|
| `XlApp.new()` | Запустить Excel **невидимо** (быстрее, для автоматизации) |
| `XlApp.visible()` | Запустить Excel **видимо** (для отладки) |
| `XlApp.connect()` | Подключиться к **уже запущенному** Excel |

```wren
var xl = XlApp.new()          // невидимый Excel
var xl = XlApp.visible()      // видимый
var xl = XlApp.connect()      // подключение к открытому Excel
```

### Настройки

```wren
xl.visible = true             // показать/скрыть окно
xl.screenUpdating = false     // отключить перерисовку (быстрее)
xl.displayAlerts = false      // подавить диалоги "Сохранить?"
System.print(xl.version)      // "16.0" и т.п.
```

### Управление книгами

```wren
var wb = xl.newBook()               // создать новую книгу
var wb = xl.open("C:/data/rep.xlsx") // открыть файл
var wb = xl.openReadOnly("file.xlsx") // только для чтения
var wb = xl.activeBook()            // активная книга
System.print(xl.bookCount)          // количество открытых книг
```

### Запуск макросов

```wren
xl.runMacro("FillReport")           // без аргументов
xl.runMacro("SetTitle", "Отчёт")   // с 1 аргументом
xl.runMacro("CopyRange", "A1", "B5", 3) // с несколькими аргументами
// Поддерживается до 8 аргументов
```

> Запуск макросов через `runMacro` **не требует** специальных настроек безопасности
> (в отличие от VBAProject, см. раздел 6).

### Завершение

```wren
xl.quit()      // закрыть Excel (освобождает COM-объект)
xl.release()   // только освободить COM без закрытия Excel
```

---

## 3. XlBook — рабочая книга

### Свойства

```wren
System.print(wb.name)       // "report.xlsx"
System.print(wb.fullPath)   // "C:\reports\report.xlsx"
System.print(wb.sheetCount) // 3
```

### Работа с листами

```wren
var ws = wb.sheet(1)          // лист по индексу (1-based)
var ws = wb.sheet("Данные")   // лист по имени
var ws = wb.activeSheet()     // активный лист

var ws = wb.addSheet("Итоги")               // новый лист перед активным
var ws = wb.addSheetAfter(1, "Справочник")  // после листа №1
```

### Сохранение и закрытие

```wren
wb.save()                          // сохранить в текущий файл
wb.saveAs("C:/out/result.xlsx")    // .xlsx — без макросов
wb.saveAsXlsm("C:/out/result.xlsm") // .xlsm — с макросами VBA (!)
wb.saveAsXlsb("C:/out/result.xlsb") // .xlsb — двоичный с макросами
wb.saveAsCsv("C:/out/data.csv")    // .csv — активный лист

wb.close()       // закрыть без сохранения
wb.closeSave()   // закрыть с сохранением
wb.release()     // только освободить COM-объект
```

> **Важно:** VBA-код сохраняется **только** в `.xlsm` или `.xlsb`.
> `saveAs()` с расширением `.xlsx` удалит все макросы!

### Автоматическое освобождение

```wren
xl.open("file.xlsx").use {|wb|
    wb.sheet(1).use {|ws|
        System.print(ws.getValue("A1"))
    }
}
// wb и ws освобождены автоматически
```

### VBA проект

```wren
var vba = wb.vbaProject()   // → XlVbaProject (см. раздел 6)
```

---

## 4. XlSheet — рабочий лист

### Свойства листа

```wren
System.print(ws.name)   // имя листа
ws.name = "Продажи"     // переименовать лист
ws.activate()           // сделать активным
ws.delete()             // удалить лист (необратимо)

System.print(ws.rowCount) // строк в используемой области
System.print(ws.colCount) // столбцов
```

### Получение диапазонов

```wren
var r = ws.range("A1")        // одна ячейка
var r = ws.range("A1:D10")    // прямоугольный диапазон
var r = ws.range("A1", "D10") // то же через два адреса
var r = ws.cell(1, 1)         // ячейка A1 по строке и столбцу (1-based)
var r = ws.cell("B3")         // ячейка по адресу
var r = ws.usedRange()        // весь заполненный диапазон
// После работы: r.release()
```

### Быстрые методы (без ручного release)

```wren
// Чтение
var v = ws.getValue("B2")         // значение ячейки
var f = ws.getFormula("C5")       // формула ячейки

// Запись
ws.setValue("A1", "Заголовок")
ws.setFormula("D2", "=B2*C2")

// Строки и столбцы
ws.writeRow(1, 1, ["Имя", "Город", "Сумма"])  // горизонтально
ws.writeCol(2, 1, ["Иван", "Мария", "Пётр"])  // вертикально
var headers = ws.readRow(1, 1, 5)             // 5 значений из строки 1
var names   = ws.readCol(1, 2, 10)            // 10 значений из столбца A

// Таблица
ws.writeTable("A2", [
    ["Иван",  30, "Москва"],
    ["Мария", 25, "СПб"],
])
```

### Форматирование строк и столбцов

```wren
ws.setColumnWidth(1, 20)    // ширина столбца A = 20 символов
ws.setColumnWidth("B", 15)  // столбец B по букве
ws.autoFitColumn(1)         // автоподбор ширины по содержимому

ws.setRowHeight(1, 30)      // высота строки 1 = 30 pt
ws.autoFitRow(2)            // автоподбор высоты
```

### Поиск ячейки

```wren
var found = ws.find("Итого")
if (!found.isNull) {
    System.print("Найдено: %(found.address)")
    found.release()
} else {
    found.release()  // освободить даже при null-результате
}
```

---

## 5. XlRange — диапазон ячеек

### Получение объекта

```wren
var r = ws.range("A1:C10")  // через XlSheet
var r = ws.cell(3, 2)       // ячейка по координатам
```

### Значения

```wren
r.value            // прочитать значение (число, строка, bool)
r.value = 42       // записать значение
r.formula          // формула ("=SUM(A1:A10)" или "")
r.formula = "=B2*C2"
r.text             // форматированное значение — только чтение ("1 234,56 ₽")
r.address          // адрес в формате "$A$1:$C$10"
```

### Размеры

```wren
r.rowCount   // количество строк
r.colCount   // количество столбцов
var c = r.cell(2, 3)  // ячейка внутри диапазона (1-based смещение)
```

### Шрифт

```wren
r.bold = true
r.italic = true
r.underline = true
r.fontSize = 14
r.fontName = "Arial"
r.fontColor = XlColor.red
r.fontColor = XlColor.rgb(0, 80, 160)
```

### Заливка

```wren
r.bgColor = XlColor.yellow
r.bgColor = XlColor.rgb(220, 240, 255)
r.bgColor = XlColor.none    // убрать заливку
```

### Выравнивание

```wren
r.hAlign = XlAlign.center   // по горизонтали
r.hAlign = XlAlign.left
r.hAlign = XlAlign.right
r.vAlign = XlAlign.middle   // по вертикали
r.wrapText = true           // перенос по словам
```

### Формат чисел

```wren
r.numberFormat = XlFmt.integer      // "0"
r.numberFormat = XlFmt.decimal2     // "0.00"
r.numberFormat = XlFmt.currency     // "#,##0.00"
r.numberFormat = XlFmt.currencyR    // рубли
r.numberFormat = XlFmt.percent2     // процент с 2 знаками
r.numberFormat = XlFmt.dateRu       // "DD.MM.YYYY"
r.numberFormat = "# ##0.00"         // произвольная строка формата
```

### Размеры ячеек

```wren
r.columnWidth = 18   // ширина столбца в символах
r.rowHeight = 25     // высота строки в пунктах
r.autoFitColumns()   // подобрать ширину
r.autoFitRows()      // подобрать высоту
```

### Объединение

```wren
r.merge()    // объединить ячейки
r.unmerge()  // снять объединение
```

### Границы

```wren
// Одна сторона
r.setBorder(XlBorder.bottom, XlBorder.styleSolid, XlColor.black)
r.setBorderWeight(XlBorder.bottom, XlBorder.medium)

// Все четыре внешние стороны
r.setBorderAll(XlBorder.styleSolid, XlColor.black)

// Все стороны включая внутренние
r.setBorderFull(XlBorder.styleSolid, XlColor.gray)

// Снять границу
r.setBorder(XlBorder.top, XlBorder.styleNone, XlColor.black)
```

### Пакетное форматирование

```wren
ws.range("A1:D1").use {|r|
    r.format({
        "bold":        true,
        "fontSize":    12,
        "bgColor":     XlColor.darkBlue,
        "fontColor":   XlColor.white,
        "hAlign":      XlAlign.center,
    })
    r.setBorderAll(XlBorder.styleSolid, XlColor.black)
}
```

Поддерживаемые ключи `.format()`:
`"bold"`, `"italic"`, `"underline"`, `"fontSize"`, `"fontName"`,
`"fontColor"`, `"bgColor"`, `"hAlign"`, `"vAlign"`, `"numberFormat"`, `"wrapText"`

### Очистка и копирование

```wren
r.clear()              // очистить значения + форматирование
r.clearContent()       // только значения (форматирование сохраняется)
r.clearFormat()        // только форматирование (значения сохраняются)

var dest = ws.range("F1")
r.copyTo(dest)         // полное копирование (значения + форматирование)
r.pasteValuesTo(dest)  // только значения
dest.release()
```

### Массовое чтение/запись

```wren
// Записать список списков
ws.range("A1").use {|r|
    r.fromList([
        ["Январь", 100, 120],
        ["Февраль", 90,  115],
    ])
}

// Прочитать все значения в список списков
var data = ws.usedRange().use {|r| r.toList() }
for (row in data) {
    System.print(row)
}

// Перебрать ячейки
ws.range("A1:C3").use {|r|
    r.each {|cell|
        System.print(cell.value)
        // cell.release() НЕ нужен — each освобождает сам
    }
}
```

---

## 6. XlVbaProject и XlVbaModule — макросы VBA

### Предварительные требования

Для доступа к объектной модели VBA необходимо:
1. Открыть **Excel → Файл → Параметры → Центр безопасности → Параметры макросов**
2. Включить **«Доверять доступ к объектной модели проектов VBA»**

Файлы с макросами нужно сохранять как `.xlsm` или `.xlsb`.

### Проверка доступности VBA

```wren
var testVbp = wb.raw.get("VBProject")
if (testVbp.isNull) {
    System.print("VBA недоступен")
    testVbp.release()
} else {
    testVbp.release()
    // VBA доступен — продолжаем
}
```

### XlVbaProject — VBA проект

Получить проект через книгу:

```wren
var vba = wb.vbaProject()   // выбрасывает ошибку если VBA недоступен
```

**Свойства:**

```wren
System.print(vba.name)        // "VBAProject"
vba.name = "MyProject"
System.print(vba.moduleCount) // число компонентов
var names = vba.moduleNames() // ["Sheet1","Sheet2","ThisWorkbook","Module1"]
```

**Создание модулей:**

```wren
var mod = vba.addModule("MyHelper")        // стандартный модуль
var cls = vba.addClassModule("MyClass")    // модуль класса
```

**Получение модулей:**

```wren
var mod = vba.module("Module1")    // по имени
if (!mod.isNull) {
    // работа с модулем
    mod.release()
}

var mod = vba.moduleAt(1)          // по индексу (1-based)
if (vba.hasModule("Utils")) {      // проверить существование
    // ...
}
```

**Удаление:**

```wren
vba.removeModule("TempModule")           // удалить (ошибка если нет)
vba.removeModuleIfExists("TempModule")   // безопасно
```

**Перебор:**

```wren
vba.each {|mod|
    System.print("%(mod.name) тип=%(mod.type)")
    // mod.release() НЕ нужен — each освобождает сам
}
vba.release()
```

### XlVbaModule — модуль VBA

**Свойства:**

```wren
System.print(mod.name)       // "Module1"
mod.name = "MyHelper"        // переименовать
System.print(mod.type)       // 1=StdModule, 2=ClassModule, 100=Document
System.print(mod.lineCount)  // число строк кода
```

**Чтение кода:**

```wren
var allCode = mod.code               // весь код как строка
var first5  = mod.lines(1, 5)        // строки 1–5
```

**Запись кода:**

```wren
mod.code = "Option Explicit\n\nSub Hello()\n    MsgBox \"Hi\"\nEnd Sub"
mod.addFromString("Sub Another()\nEnd Sub\n")
mod.insertLines(1, "Option Explicit\n\n")  // вставить в начало
mod.deleteLines(3, 2)  // удалить 2 строки начиная с 3-й
mod.clear()            // очистить весь код
```

**Вспомогательные методы:**

```wren
// Добавить Sub
mod.addSub("FillReport", "ws As Object, title As String",
    "    ws.Range(\"A1\").Value = title")

// Добавить Function
mod.addFunction("Square", "x As Double",
    "    Square = x * x")

// Добавить Property Get
mod.addPropertyGet("Version", "",
    "    Version = \"1.0\"")
```

**Полный пример:**

```wren
var vba = wb.vbaProject()
vba.removeModuleIfExists("AutoGen")
var mod = vba.addModule("AutoGen")

mod.insertLines(1, "Option Explicit\n\n")
mod.addSub("FillCell", "addr As String, val As Variant",
    "    ActiveSheet.Range(addr).Value = val")
mod.addFunction("GetVersion", "",
    "    GetVersion = \"2.0\"")

vba.release()
wb.saveAsXlsm("C:/out/result.xlsm")

// Запустить сохранённый макрос
xl.runMacro("AutoGen.FillCell", "B2", "Готово")
```

---

## 7. Вспомогательные классы

### XlColor — цвета

```wren
XlColor.black        // чёрный
XlColor.white        // белый
XlColor.red          // красный
XlColor.green        // зелёный
XlColor.blue         // синий
XlColor.yellow       // жёлтый
XlColor.orange       // оранжевый
XlColor.gray         // серый 50%
XlColor.lightGray    // светло-серый
XlColor.lightBlue    // светло-голубой
XlColor.lightYellow  // светло-жёлтый
XlColor.lightGreen   // светло-зелёный
XlColor.darkRed      // тёмно-красный
XlColor.darkBlue     // тёмно-синий
XlColor.cyan         // голубой
XlColor.magenta      // пурпурный
XlColor.none         // нет цвета (для bgColor — убрать заливку)

XlColor.rgb(255, 128, 0)  // произвольный цвет по компонентам RGB
```

### XlAlign — выравнивание

```wren
// Горизонтальное (hAlign=)
XlAlign.general   // по умолчанию
XlAlign.left      // по левому краю
XlAlign.center    // по центру
XlAlign.right     // по правому краю
XlAlign.justify   // по ширине
XlAlign.fill      // заполнение

// Вертикальное (vAlign=)
XlAlign.top       // по верхнему краю
XlAlign.middle    // по середине
XlAlign.bottom    // по нижнему краю
```

### XlBorder — границы

```wren
// Стороны (setBorder, setBorderWeight)
XlBorder.left     // левая граница
XlBorder.top      // верхняя
XlBorder.bottom   // нижняя
XlBorder.right    // правая
XlBorder.insideV  // внутренние вертикальные
XlBorder.insideH  // внутренние горизонтальные

// Стиль линии (2-й аргумент setBorder)
XlBorder.styleSolid    // сплошная
XlBorder.styleDash     // пунктирная
XlBorder.styleDot      // точечная
XlBorder.styleDashDot  // штрих-точка
XlBorder.styleNone     // без линии

// Толщина (setBorderWeight)
XlBorder.thin    // тонкая
XlBorder.medium  // средняя
XlBorder.thick   // толстая
```

### XlFmt — форматы чисел

```wren
XlFmt.general     // Общий
XlFmt.text        // Текст (@)
XlFmt.integer     // Целое (0)
XlFmt.decimal1    // 1 знак (0.0)
XlFmt.decimal2    // 2 знака (0.00)
XlFmt.decimal3    // 3 знака (0.000)
XlFmt.thousands   // С разделителем тысяч (#,##0)
XlFmt.currency    // Денежный (#,##0.00)
XlFmt.currencyR   // Рубли (#,##0.00 [$₽-419])
XlFmt.percent0    // Процент целый (0%)
XlFmt.percent2    // Процент с 2 знаками (0.00%)
XlFmt.dateRu      // Дата ДД.ММ.ГГГГ
XlFmt.dateTime    // Дата и время ДД.ММ.ГГГГ ЧЧ:ММ
XlFmt.time_       // Время ЧЧ:ММ:СС
XlFmt.scientific  // Научный (0.00E+00)
```

### XlUtil — вспомогательные функции

```wren
XlUtil.colLetter(1)        // "A"
XlUtil.colLetter(26)       // "Z"
XlUtil.colLetter(27)       // "AA"
XlUtil.addr(1, 1)          // "A1"
XlUtil.addr(3, 4)          // "D3"
XlUtil.addrRange(1,1,3,4)  // "A1:D3"
```

---

## 8. Управление памятью (release)

Объекты `XlBook`, `XlSheet`, `XlRange`, `XlVbaProject`, `XlVbaModule` содержат
COM-указатели и **должны быть освобождены** после использования.

### Три способа:

**1. Явный вызов `release()`:**
```wren
var ws = wb.sheet(1)
ws.setValue("A1", "hello")
ws.release()
```

**2. Блок `use {|x| ... }`** — автоматический release по завершении блока:
```wren
wb.sheet(1).use {|ws|
    ws.setValue("A1", "hello")
}
```

**3. Цепочка через `getR` / `callR`** — промежуточные объекты освобождаются автоматически:
```wren
// Вместо:
var sheets = wb.raw.get("Sheets")
var cnt = sheets.count
sheets.release()

// Можно:
var cnt = wb.raw.get("Sheets").getR("count")
```

### Что освобождать **не нужно**:

- Значения, возвращённые быстрыми методами: `ws.getValue()`, `ws.readRow()`, `ws.writeTable()`
- Ячейки внутри `range.each {|cell| ... }` — освобождаются автоматически
- Модули внутри `vba.each {|mod| ... }` — освобождаются автоматически
- `XlColor`, `XlAlign`, `XlBorder`, `XlFmt`, `XlUtil` — статические классы, не содержат COM

### Проверка null-результатов:

```wren
// find() и module() возвращают объект с .isNull вместо Wren null
var found = ws.find("Итого")
if (!found.isNull) {
    System.print(found.address)
}
found.release()  // освобождать нужно в любом случае

var mod = vba.module("NonExistent")
if (!mod.isNull) {
    // ...
}
mod.release()
```

---

## 9. Типичные задачи

### Создать отчёт с нуля

```wren
import "excel" for XlApp, XlColor, XlAlign, XlBorder, XlFmt

var xl = XlApp.new()
var wb = xl.newBook()
var ws = wb.sheet(1)
ws.name = "Продажи"

// Заголовки
ws.writeRow(1, 1, ["Месяц", "Выручка", "Расходы", "Прибыль"])
ws.range("A1:D1").use {|r|
    r.format({"bold": true, "bgColor": XlColor.darkBlue, "fontColor": XlColor.white,
              "hAlign": XlAlign.center})
    r.setBorderAll(XlBorder.styleSolid, XlColor.black)
}

// Данные
var months = ["Январь","Февраль","Март"]
var revenue = [120000, 135000, 98000]
var costs   = [80000,  90000,  70000]
for (i in 0...months.count) {
    var row = i + 2
    ws.setValue(XlUtil.addr(row, 1), months[i])
    ws.setValue(XlUtil.addr(row, 2), revenue[i])
    ws.setValue(XlUtil.addr(row, 3), costs[i])
    ws.setFormula(XlUtil.addr(row, 4), "=B%(row)-C%(row)")
}

// Числовой формат
ws.range("B2:D4").use {|r| r.numberFormat = XlFmt.thousands }

// Автоподбор ширины
for (col in 1..4) { ws.autoFitColumn(col) }

ws.release()
wb.saveAs("C:/out/report.xlsx")
wb.release()
xl.quit()
```

### Читать существующий файл

```wren
var xl = XlApp.new()
xl.open("C:/data/sales.xlsx").use {|wb|
    wb.sheet("Данные").use {|ws|
        var rows = ws.rowCount
        System.print("Строк данных: %(rows)")
        for (row in 2..rows) {
            var name  = ws.getValue(XlUtil.addr(row, 1))
            var value = ws.getValue(XlUtil.addr(row, 2))
            System.print("%(name): %(value)")
        }
    }
}
xl.quit()
```

### Добавить формулы итогов

```wren
ws.use {|ws|
    var lastRow = ws.rowCount
    var sumRow  = lastRow + 2

    ws.setValue(XlUtil.addr(sumRow, 1), "ИТОГО:")
    ws.setFormula(XlUtil.addr(sumRow, 2), "=SUM(B2:B%(lastRow))")
    ws.setFormula(XlUtil.addr(sumRow, 3), "=SUM(C2:C%(lastRow))")
    ws.range(XlUtil.addr(sumRow, 1) + ":D%(sumRow)").use {|r|
        r.bold = true
        r.bgColor = XlColor.lightYellow
    }
}
```

### Создать и запустить макрос VBA

```wren
var vba = wb.vbaProject()

vba.removeModuleIfExists("AutoFill")
var mod = vba.addModule("AutoFill")
mod.addSub("HighlightNegative", "",
    "    Dim cell As Range\n" +
    "    For Each cell In ActiveSheet.UsedRange\n" +
    "        If IsNumeric(cell.Value) And cell.Value < 0 Then\n" +
    "            cell.Interior.Color = RGB(255, 200, 200)\n" +
    "        End If\n" +
    "    Next cell")
mod.release()
vba.release()

wb.saveAsXlsm("C:/out/result.xlsm")
xl.runMacro("HighlightNegative")
```

### Подключиться к открытому Excel и прочитать данные

```wren
var xl = XlApp.connect()
var wb = xl.activeBook()
System.print("Открыт файл: %(wb.name)")
wb.sheet(1).use {|ws|
    System.print("A1 = %(ws.getValue("A1"))")
}
wb.release()
xl.release()  // не quit! — закрывать чужой Excel не нужно
```

---

## 10. Ограничения и важные замечания

### Форматные строки с `%`
В Wren символ `%` внутри строки запускает интерполяцию. При передаче форматных
строк с `%` в Excel нужно экранировать: `"0\%"` вместо `"0%"`.
В `XlFmt` это уже учтено.

### Одна инструкция на строку
Wren требует каждую инструкцию на отдельной строке:
```wren
// Неправильно:
if (x) { a()  b() }

// Правильно:
if (x) {
    a()
    b()
}
```

### get() принимает только имя свойства
Параметризованные COM-свойства (`Cells(r,c)`, `Range(addr)`, `Item(n)`) нужно
вызывать через `call()`, а не `get()`.

### Порядок операций для скорости
```wren
var xl = XlApp.new()          // ScreenUpdating=false, DisplayAlerts=false по умолчанию
// ... работа ...
xl.screenUpdating = true      // включить перерисовку перед показом результата
xl.visible = true
```

### VBA и форматы файлов

| Формат | Метод | Макросы |
|--------|-------|---------|
| `.xlsx` | `saveAs()` | Нет (VBA удаляется!) |
| `.xlsm` | `saveAsXlsm()` | Да |
| `.xlsb` | `saveAsXlsb()` | Да (быстрее) |
| `.csv`  | `saveAsCsv()` | Нет |

### Типы значений ячеек
`getValue()` возвращает:
- числа → число Wren (Double)
- строки → строка Wren
- `true`/`false` → bool Wren
- пустая ячейка → пустая строка `""` или `0`
- ошибки Excel (`#N/A`, `#DIV/0!`) → могут прийти как число или строка
