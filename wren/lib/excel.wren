// excel.wren — Полноценный фасад для работы с Excel через OLE
//
// Использование:
//   import "excel" for XlApp, XlBook, XlSheet, XlRange
//   import "excel" for XlColor, XlAlign, XlBorder, XlFmt, XlUtil
//
// Классы:
//   XlApp        — приложение Excel (запуск, открытие файлов, runMacro)
//   XlBook       — рабочая книга   (листы, сохранение, vbaProject)
//   XlSheet      — рабочий лист    (чтение/запись ячеек, форматирование)
//   XlRange      — диапазон ячеек  (значения, формулы, форматирование, границы)
//   XlVbaProject — VBA проект книги (список модулей, создание, удаление)
//   XlVbaModule  — модуль VBA      (чтение/запись кода, addSub, addFunction)
//   XlColor      — константы цветов (передавать в fontColor=, bgColor=)
//   XlAlign      — константы выравнивания (передавать в hAlign=, vAlign=)
//   XlBorder     — константы границ (передавать в setBorder)
//   XlFmt        — строки формата чисел и дат (передавать в numberFormat=)
//   XlUtil       — вспомогательные функции (адрес ячейки, буква столбца)
//
// Важно: XlBook, XlSheet, XlRange, XlVbaProject, XlVbaModule содержат COM-объекты.
//   После использования вызывайте .release() или блок .use{|x| ... }
//
// Для VBA: требует "Доверять доступ к объектной модели проектов VBA" в настройках Excel.
//   Файлы с макросами сохранять через wb.saveAsXlsm("path.xlsm")

import "ole" for OleObject

// =============================================================================
// XlColor — цвета в формате OLE: R + G*256 + B*65536
// =============================================================================
class XlColor {
    // Произвольный цвет из компонент RGB (каждая 0..255)
    static rgb(r, g, b) { r + g * 256 + b * 65536 }

    static black      {       0 }  // Чёрный       RGB(0,0,0)
    static white      { 16777215 } // Белый         RGB(255,255,255)
    static red        {     255 }  // Красный       RGB(255,0,0)
    static darkRed    {     128 }  // Тёмно-красный RGB(128,0,0)
    static green      { 5287936 }  // Зелёный       RGB(0,128,0)
    static lime       {   65280 }  // Ярко-зелёный  RGB(0,255,0)
    static blue       { 16711680 } // Синий         RGB(0,0,255)
    static darkBlue   { 8388608 }  // Тёмно-синий   RGB(0,0,128)
    static yellow     {   65535 }  // Жёлтый        RGB(255,255,0)
    static orange     {   42495 }  // Оранжевый     RGB(255,165,0)
    static cyan       { 16776960 } // Голубой       RGB(0,255,255)
    static magenta    { 16711935 } // Пурпурный     RGB(255,0,255)
    static gray       { 8421504 }  // Серый 50%     RGB(128,128,128)
    static lightGray  { 13421772 } // Светло-серый  RGB(204,204,204)
    static lightBlue  { 16764057 } // Светло-голубой
    static lightYellow{ 10092543 } // Светло-жёлтый
    static lightGreen { 13434828 } // Светло-зелёный
    static none       {   -4142 }  // Нет цвета (xlNone — для bgColor)
}

// =============================================================================
// XlAlign — выравнивание текста
// =============================================================================
class XlAlign {
    // Горизонтальное (передавать в hAlign=)
    static general { 1 }      // По умолчанию  (xlGeneral)
    static left    { -4131 }  // По левому краю (xlLeft)
    static center  { -4108 }  // По центру      (xlCenter)
    static right   { -4152 }  // По правому краю(xlRight)
    static justify { -4130 }  // По ширине      (xlJustify)
    static fill    { 5 }      // Заполнение     (xlFill)

    // Вертикальное (передавать в vAlign=)
    // xlTop=-4160, xlCenter=-4108 (то же, что center), xlBottom=-4107
    static top     { -4160 }  // По верхнему краю
    static middle  { -4108 }  // По середине
    static bottom  { -4107 }  // По нижнему краю
}

// =============================================================================
// XlBorder — константы для оформления границ
// =============================================================================
class XlBorder {
    // Номера сторон (передавать первым аргументом в setBorder)
    static left    { 7 }   // Левая граница   (xlEdgeLeft)
    static top     { 8 }   // Верхняя граница (xlEdgeTop)
    static bottom  { 9 }   // Нижняя граница  (xlEdgeBottom)
    static right   { 10 }  // Правая граница  (xlEdgeRight)
    static insideV { 11 }  // Внутренние вертикальные   (xlInsideVertical)
    static insideH { 12 }  // Внутренние горизонтальные (xlInsideHorizontal)

    // Стиль линии (передавать вторым аргументом в setBorder)
    static styleSolid  { 1 }     // Сплошная   (xlContinuous)
    static styleDash   { 2 }     // Пунктирная (xlDash)
    static styleDot    { 4 }     // Точечная   (xlDot)
    static styleDashDot{ 5 }     // Штрих-точка(xlDashDot)
    static styleNone   { -4142 } // Без линии  (xlNone)

    // Толщина линии (устанавливается отдельно через setBorderWeight)
    static thin   { 2 }     // Тонкая  (xlThin)
    static medium { -4138 } // Средняя (xlMedium)
    static thick  { 4 }     // Толстая (xlThick)
}

// =============================================================================
// XlFmt — форматные строки для свойства numberFormat=
// =============================================================================
class XlFmt {
    static general    { "General"          }  // Общий
    static text       { "@"                }  // Текст
    static integer    { "0"                }  // Целое
    static decimal1   { "0.0"              }  // 1 знак после запятой
    static decimal2   { "0.00"             }  // 2 знака
    static decimal3   { "0.000"            }  // 3 знака
    static thousands  { "#,##0"            }  // С разделителем тысяч
    static currency   { "#,##0.00"         }  // Денежный
    static currencyR  { "#,##0.00 [$₽-419]"}  // Рубли
    static percent0   { "0\%"               }  // Процент целый
    static percent2   { "0.00\%"           }  // Процент с 2 знаками
    static dateRu     { "DD.MM.YYYY"       }  // Дата ДД.ММ.ГГГГ
    static dateTime   { "DD.MM.YYYY HH:MM" }  // Дата и время
    static time_      { "HH:MM:SS"         }  // Время
    static scientific { "0.00E+00"         }  // Научный формат
}

// =============================================================================
// XlUtil — вспомогательные функции
// =============================================================================
class XlUtil {
    // Буква(ы) столбца из 1-based номера: 1→"A", 26→"Z", 27→"AA"
    static colLetter(n) {
        var s = ""
        while (n > 0) {
            n = n - 1
            s = String.fromCodePoint(65 + n % 26) + s
            n = (n / 26).floor
        }
        return s
    }

    // Адрес ячейки из строки и столбца (1-based): addr(1,1)→"A1", addr(3,4)→"D3"
    static addr(row, col) { colLetter(col) + "%(row)" }

    // Адрес диапазона из координат: addrRange(1,1,3,4)→"A1:D3"
    static addrRange(r1, c1, r2, c2) { addr(r1, c1) + ":" + addr(r2, c2) }
}

// =============================================================================
// XlRange — диапазон ячеек (обёртка над COM-объектом Range)
//
// После использования обязательно вызвать .release() или .use{|r| ... }
// =============================================================================
class XlRange {
    // Внутренний конструктор — вызывается из XlSheet
    construct new_(rng) { _rng = rng }

    // true если диапазон не найден (результат find() при отсутствии совпадения)
    isNull { _rng.isNull }

    // Доступ к сырому COM-объекту (нужен для copyTo и других передач)
    raw { _rng }

    // Освободить COM-объект вручную
    release() { _rng.release() }

    // Выполнить блок и автоматически освободить объект по завершении:
    //   ws.range("A1:C3").use {|r| r.bold = true }
    use(fn) {
        fn.call(this)
        release()
    }

    // ── Значения и формулы ───────────────────────────────────────────────────

    // Значение ячейки (число, строка, bool, null)
    value    { _rng.get("Value") }
    value=(v){ _rng.set("Value", v) }

    // Формула ячейки (строка, начинается с "="; "" если нет формулы)
    formula    { _rng.get("Formula") }
    formula=(v){ _rng.set("Formula", v) }

    // Форматированное значение — только чтение (то, что видно в ячейке)
    text { _rng.get("Text") }

    // Адрес диапазона в формате "$A$1:$C$3"
    address { _rng.get("Address") }

    // ── Размеры диапазона ────────────────────────────────────────────────────

    // Количество строк в диапазоне
    rowCount { _rng.get("Rows").getR("Count") }

    // Количество столбцов в диапазоне
    colCount { _rng.get("Columns").getR("Count") }

    // Ячейка внутри диапазона по смещению (row, col — 1-based)
    cell(row, col) { XlRange.new_(_rng.call("Cells", row, col)) }

    // ── Шрифт ───────────────────────────────────────────────────────────────

    // Жирный шрифт
    bold {
        return _rng.get("Font").getR("Bold")
    }
    bold=(v) {
        var f = _rng.get("Font")
        f.set("Bold", v)
        f.release()
    }

    // Курсив
    italic {
        return _rng.get("Font").getR("Italic")
    }
    italic=(v) {
        var f = _rng.get("Font")
        f.set("Italic", v)
        f.release()
    }

    // Подчёркивание (true = одинарное, false = без подчёркивания)
    underline=(v) {
        var f = _rng.get("Font")
        f.set("Underline", v ? 2 : -4142)  // 2=xlUnderlineStyleSingle
        f.release()
    }

    // Размер шрифта в пунктах
    fontSize {
        return _rng.get("Font").getR("Size")
    }
    fontSize=(v) {
        var f = _rng.get("Font")
        f.set("Size", v)
        f.release()
    }

    // Имя шрифта ("Calibri", "Arial", "Times New Roman", ...)
    fontName=(v) {
        var f = _rng.get("Font")
        f.set("Name", v)
        f.release()
    }

    // Цвет шрифта (используйте XlColor.red и т.п. или XlColor.rgb(r,g,b))
    fontColor {
        return _rng.get("Font").getR("Color")
    }
    fontColor=(v) {
        var f = _rng.get("Font")
        f.set("Color", v)
        f.release()
    }

    // ── Заливка ─────────────────────────────────────────────────────────────

    // Цвет фона ячейки (используйте XlColor; XlColor.none — убрать заливку)
    bgColor {
        return _rng.get("Interior").getR("Color")
    }
    bgColor=(v) {
        var i = _rng.get("Interior")
        if (v == XlColor.none) {
            i.set("ColorIndex", -4142)  // xlNone — убрать заливку
        } else {
            i.set("Color", v)
        }
        i.release()
    }

    // ── Выравнивание ────────────────────────────────────────────────────────

    // Горизонтальное выравнивание (используйте XlAlign.left/center/right/justify)
    hAlign    { _rng.get("HorizontalAlignment") }
    hAlign=(v){ _rng.set("HorizontalAlignment", v) }

    // Вертикальное выравнивание (используйте XlAlign.top/middle/bottom)
    vAlign    { _rng.get("VerticalAlignment") }
    vAlign=(v){ _rng.set("VerticalAlignment", v) }

    // Перенос текста по словам
    wrapText    { _rng.get("WrapText") }
    wrapText=(v){ _rng.set("WrapText", v) }

    // ── Формат числа ────────────────────────────────────────────────────────

    // Формат числа (используйте XlFmt.decimal2, XlFmt.dateRu и т.п.)
    numberFormat    { _rng.get("NumberFormat") }
    numberFormat=(v){ _rng.set("NumberFormat", v) }

    // ── Размеры ячеек ───────────────────────────────────────────────────────

    // Ширина столбца(ов) в символах (стандартный символ)
    columnWidth    { _rng.get("ColumnWidth") }
    columnWidth=(v){ _rng.set("ColumnWidth", v) }

    // Высота строки(ок) в пунктах
    rowHeight    { _rng.get("RowHeight") }
    rowHeight=(v){ _rng.set("RowHeight", v) }

    // Автоподбор ширины по содержимому для всех столбцов диапазона
    autoFitColumns() { _rng.get("Columns").callR("AutoFit") }

    // Автоподбор высоты по содержимому для всех строк диапазона
    autoFitRows() { _rng.get("Rows").callR("AutoFit") }

    // ── Объединение ячеек ───────────────────────────────────────────────────

    // Объединить все ячейки диапазона в одну
    merge() { _rng.call("Merge") }

    // Снять объединение
    unmerge() { _rng.call("UnMerge") }

    // ── Границы ─────────────────────────────────────────────────────────────

    // Установить одну сторону границы
    //   side  — XlBorder.left / .top / .right / .bottom / .insideV / .insideH
    //   style — XlBorder.styleSolid / .styleDash / .styleNone / ...
    //   color — XlColor.black и т.п.
    setBorder(side, style, color) {
        var bs = _rng.get("Borders")
        var b  = bs.call("Item", side)
        b.set("LineStyle", style)
        if (style != XlBorder.styleNone) b.set("Color", color)
        b.release()
        bs.release()
    }

    // Установить толщину линии для одной стороны (после setBorder)
    //   weight — XlBorder.thin / .medium / .thick
    setBorderWeight(side, weight) {
        var bs = _rng.get("Borders")
        var b  = bs.call("Item", side)
        b.set("Weight", weight)
        b.release()
        bs.release()
    }

    // Установить все четыре внешние границы одним вызовом
    setBorderAll(style, color) {
        for (side in [XlBorder.left, XlBorder.top,
                      XlBorder.bottom, XlBorder.right]) {
            setBorder(side, style, color)
        }
    }

    // Установить все границы включая внутренние линии сетки
    setBorderFull(style, color) {
        for (side in [XlBorder.left,   XlBorder.top,
                      XlBorder.bottom, XlBorder.right,
                      XlBorder.insideV, XlBorder.insideH]) {
            setBorder(side, style, color)
        }
    }

    // ── Очистка и копирование ───────────────────────────────────────────────

    // Очистить значения и форматирование
    clear() { _rng.call("Clear") }

    // Очистить только значения и формулы (форматирование сохранить)
    clearContent() { _rng.call("ClearContents") }

    // Очистить только форматирование (значения сохранить)
    clearFormat() { _rng.call("ClearFormats") }

    // Скопировать диапазон в другое место (destRange — XlRange)
    copyTo(destRange) { _rng.call("Copy", destRange.raw) }

    // Вставить только значения (без форматирования) в destRange
    pasteValuesTo(destRange) {
        _rng.call("Copy")
        destRange.raw.call("PasteSpecial", -4163)  // -4163 = xlPasteValues
    }

    // ── Пакетное форматирование ─────────────────────────────────────────────

    // Применить несколько настроек через Map — удобно для заголовков таблиц.
    // Поддерживаемые ключи:
    //   "bold", "italic", "underline", "fontSize", "fontName",
    //   "fontColor", "bgColor", "hAlign", "vAlign",
    //   "numberFormat", "wrapText"
    // Возвращает this — можно строить цепочку .format(...).setBorderAll(...)
    format(s) {
        if (s.containsKey("bold"))         bold         = s["bold"]
        if (s.containsKey("italic"))       italic       = s["italic"]
        if (s.containsKey("underline"))    underline    = s["underline"]
        if (s.containsKey("fontSize"))     fontSize     = s["fontSize"]
        if (s.containsKey("fontName"))     fontName     = s["fontName"]
        if (s.containsKey("fontColor"))    fontColor    = s["fontColor"]
        if (s.containsKey("bgColor"))      bgColor      = s["bgColor"]
        if (s.containsKey("hAlign"))       hAlign       = s["hAlign"]
        if (s.containsKey("vAlign"))       vAlign       = s["vAlign"]
        if (s.containsKey("numberFormat")) numberFormat = s["numberFormat"]
        if (s.containsKey("wrapText"))     wrapText     = s["wrapText"]
        return this
    }

    // ── Массовое чтение и запись ────────────────────────────────────────────

    // Прочитать все значения диапазона в список списков: [[строка1], [строка2], ...]
    toList() {
        var rows = rowCount
        var cols = colCount
        var result = []
        for (r in 1..rows) {
            var row = []
            for (c in 1..cols) {
                row.add(_rng.call("Cells", r, c).getR("Value"))
            }
            result.add(row)
        }
        return result
    }

    // Записать список списков [[строка1], [строка2], ...] в диапазон
    // Начало — левый верхний угол данного диапазона
    fromList(data) {
        var r = 1
        for (row in data) {
            var c = 1
            for (val in row) {
                var cell = _rng.call("Cells", r, c)
                cell.set("Value", val)
                cell.release()
                c = c + 1
            }
            r = r + 1
        }
    }

    // Перебрать все ячейки диапазона (fn получает XlRange каждой ячейки)
    //   range.each {|cell| System.print(cell.value) }
    each(fn) {
        var rows = rowCount
        var cols = colCount
        for (r in 1..rows) {
            for (c in 1..cols) {
                var cell = XlRange.new_(_rng.call("Cells", r, c))
                fn.call(cell)
                cell.release()
            }
        }
    }
}

// =============================================================================
// XlSheet — рабочий лист
//
// После использования вызвать .release() или .use{|ws| ... }
// =============================================================================
class XlSheet {
    // Внутренний конструктор — вызывается из XlBook
    construct new_(ws) { _ws = ws }

    // Доступ к сырому COM-объекту
    raw { _ws }

    // Освободить COM-объект
    release() { _ws.release() }

    // Выполнить блок и автоматически освободить:
    //   wb.sheet(1).use {|ws| ws.setValue("A1", "hello") }
    use(fn) {
        fn.call(this)
        release()
    }

    // ── Свойства листа ───────────────────────────────────────────────────────

    // Имя листа
    name    { _ws.get("Name") }
    name=(v){ _ws.set("Name", v) }

    // Сделать лист активным
    activate() { _ws.call("Activate") }

    // Удалить лист (необратимо, работает при DisplayAlerts=false)
    delete() { _ws.call("Delete") }

    // Количество строк в используемой области
    rowCount {
        var ur = _ws.get("UsedRange")
        var cnt = ur.get("Rows").getR("Count")
        ur.release()
        return cnt
    }

    // Последняя строка с непустым значением в столбце col (1-based).
    // Аналог VBA: ws.Cells(Rows.Count, col).End(xlUp).Row
    // xlUp = -4162
    lastRow(col) {
        return _ws.call("Cells", 1048576, col).callR("End", -4162).getR("Row")
    }

    // Количество столбцов в используемой области
    colCount {
        var ur = _ws.get("UsedRange")
        var cnt = ur.get("Columns").getR("Count")
        ur.release()
        return cnt
    }

    // ── Получение диапазонов ─────────────────────────────────────────────────

    // Диапазон по адресу: range("A1") или range("A1:C5")
    range(addr) { XlRange.new_(_ws.call("Range", addr)) }

    // Диапазон по двум адресам: range("A1", "C5")
    range(a1, a2) { XlRange.new_(_ws.call("Range", a1, a2)) }

    // Ячейка по строке и столбцу (оба 1-based): cell(1, 1) → ячейка A1
    cell(row, col) { XlRange.new_(_ws.call("Cells", row, col)) }

    // Ячейка по адресу: cell("B3")
    cell(addr) { XlRange.new_(_ws.call("Range", addr)) }

    // Весь используемый диапазон листа
    usedRange() { XlRange.new_(_ws.get("UsedRange")) }

    // ── Быстрые методы — без ручного release Range ───────────────────────────

    // Прочитать значение ячейки по адресу: getValue("B3")
    getValue(addr) { _ws.call("Range", addr).getR("Value") }

    // Прочитать значение ячейки по строке и столбцу (1-based): getValue(3, 2)
    getValue(row, col) { _ws.call("Cells", row, col).getR("Value") }

    // Записать значение в ячейку по адресу
    setValue(addr, val) {
        var r = _ws.call("Range", addr)
        r.set("Value", val)
        r.release()
    }

    // Прочитать формулу ячейки
    getFormula(addr) { _ws.call("Range", addr).getR("Formula") }

    // Записать формулу в ячейку ("=SUM(A1:A10)" и т.п.)
    setFormula(addr, formula) {
        var r = _ws.call("Range", addr)
        r.set("Formula", formula)
        r.release()
    }

    // Записать список значений в строку горизонтально (startCol — 1-based)
    //   ws.writeRow(1, 1, ["Имя", "Возраст", "Город"])
    writeRow(row, startCol, list) {
        var col = startCol
        for (val in list) {
            var r = _ws.call("Cells", row, col)
            r.set("Value", val)
            r.release()
            col = col + 1
        }
    }

    // Записать список значений в столбец вертикально (startRow — 1-based)
    //   ws.writeCol(1, 1, ["Январь", "Февраль", "Март"])
    writeCol(startRow, col, list) {
        var row = startRow
        for (val in list) {
            var r = _ws.call("Cells", row, col)
            r.set("Value", val)
            r.release()
            row = row + 1
        }
    }

    // Прочитать count значений из строки row начиная со столбца startCol
    //   var headers = ws.readRow(1, 1, 5)
    readRow(row, startCol, count) {
        var result = []
        for (i in 0...count) {
            result.add(_ws.call("Cells", row, startCol + i).getR("Value"))
        }
        return result
    }

    // Прочитать count значений из столбца col начиная со строки startRow
    //   var names = ws.readCol(2, 1, 10)
    readCol(col, startRow, count) {
        var result = []
        for (i in 0...count) {
            result.add(_ws.call("Cells", startRow + i, col).getR("Value"))
        }
        return result
    }

    // Записать двумерный список [[строка1], [строка2], ...] начиная с адреса
    //   ws.writeTable("A2", [["Иван", 30], ["Мария", 25]])
    writeTable(startAddr, data) {
        var r = _ws.call("Range", startAddr)
        XlRange.new_(r).use {|xr| xr.fromList(data) }
    }

    // ── Форматирование строк и столбцов ──────────────────────────────────────

    // Установить ширину столбца (col — число 1-based или буква "A", "B", ...)
    setColumnWidth(col, width) {
        var c = _ws.call("Columns", col)
        c.set("ColumnWidth", width)
        c.release()
    }

    // Автоподбор ширины столбца по содержимому
    autoFitColumn(col) { _ws.call("Columns", col).callR("AutoFit") }

    // Установить высоту строки в пунктах
    setRowHeight(row, height) {
        var r = _ws.call("Rows", row)
        r.set("RowHeight", height)
        r.release()
    }

    // Автоподбор высоты строки по содержимому
    autoFitRow(row) { _ws.call("Rows", row).callR("AutoFit") }

    // ── Поиск ───────────────────────────────────────────────────────────────

    // Найти первую ячейку с указанным значением.
    // Возвращает XlRange; проверяйте .isNull если не найдено.
    find(value) {
        var cells = _ws.get("Cells")
        var r = cells.call("Find", value)
        cells.release()
        return XlRange.new_(r)
    }
}

// =============================================================================
// XlVbaModule — модуль VBA (обёртка над VBComponent + CodeModule)
//
// Требование: File → Options → Trust Center → Macro Settings →
//   "Trust access to the VBA project object model" должен быть включён.
// После использования вызвать .release()
// =============================================================================
class XlVbaModule {
    // Внутренний конструктор — вызывается из XlVbaProject
    construct new_(mod) { _mod = mod }

    // true если модуль не найден (результат XlVbaProject.module("NonExistent"))
    isNull { _mod.isNull }

    // Доступ к сырому COM-объекту VBComponent
    raw { _mod }

    // Освободить COM-объект
    release() { _mod.release() }

    // Выполнить блок и автоматически освободить
    use(fn) {
        fn.call(this)
        release()
    }

    // ── Свойства модуля ──────────────────────────────────────────────────────

    // Имя модуля (например "Module1", "MyHelper")
    name    { _mod.get("Name") }
    name=(v){ _mod.set("Name", v) }

    // Тип модуля: 1=StdModule, 2=ClassModule, 100=Document (Sheet/Workbook)
    type { _mod.get("Type") }

    // ── Работа с кодом ───────────────────────────────────────────────────────

    // Количество строк кода в модуле
    lineCount {
        var cm = _mod.get("CodeModule")
        var cnt = cm.get("CountOfLines")
        cm.release()
        return cnt
    }

    // Прочитать строки кода: lines(1, 5) → первые 5 строк
    lines(from, count) {
        var cm = _mod.get("CodeModule")
        var text = cm.call("Lines", from, count)
        cm.release()
        return text
    }

    // Весь код модуля как одна строка (строки разделены \n)
    code {
        var cm = _mod.get("CodeModule")
        var cnt = cm.get("CountOfLines")
        if (cnt == 0) {
            cm.release()
            return ""
        }
        var text = cm.call("Lines", 1, cnt)
        cm.release()
        return text
    }

    // Заменить весь код модуля новым текстом
    code=(text) {
        var cm = _mod.get("CodeModule")
        var cnt = cm.get("CountOfLines")
        if (cnt > 0) cm.call("DeleteLines", 1, cnt)
        if (text != "") cm.call("AddFromString", text)
        cm.release()
    }

    // Добавить текст в конец модуля (VBA код одной или нескольких процедур)
    //   mod.addFromString("Sub Hello()\n    MsgBox \"Hi\"\nEnd Sub\n")
    addFromString(text) {
        var cm = _mod.get("CodeModule")
        cm.call("AddFromString", text)
        cm.release()
    }

    // Вставить строки начиная с указанной позиции (1-based)
    //   mod.insertLines(1, "Option Explicit\n")
    insertLines(atLine, text) {
        var cm = _mod.get("CodeModule")
        cm.call("InsertLines", atLine, text)
        cm.release()
    }

    // Удалить строки: deleteLines(3, 2) — удалить 2 строки начиная с 3-й
    deleteLines(from, count) {
        var cm = _mod.get("CodeModule")
        cm.call("DeleteLines", from, count)
        cm.release()
    }

    // Очистить весь код модуля
    clear() {
        var cm = _mod.get("CodeModule")
        var cnt = cm.get("CountOfLines")
        if (cnt > 0) cm.call("DeleteLines", 1, cnt)
        cm.release()
    }

    // ── Вспомогательные методы ───────────────────────────────────────────────

    // Добавить процедуру Sub.
    //   name   — имя процедуры ("FillReport")
    //   params — строка параметров ("ws As Object, title As String") или ""
    //   body   — тело процедуры (строки через \n, с отступами)
    // Пример:
    //   mod.addSub("Hello", "", "    MsgBox \"Hello from Wren!\"")
    addSub(name, params, body) {
        var sig = params == "" ? "Sub %(name)()" : "Sub %(name)(%(params))"
        addFromString(sig + "\n" + body + "\nEnd Sub\n\n")
    }

    // Добавить функцию Function.
    //   Тело должно содержать строку вида "    %(name) = результат"
    // Пример:
    //   mod.addFunction("Square", "x As Double", "    Square = x * x")
    addFunction(name, params, body) {
        var sig = params == "" ? "Function %(name)()" : "Function %(name)(%(params))"
        addFromString(sig + "\n" + body + "\nEnd Function\n\n")
    }

    // Добавить Property Get (геттер свойства)
    addPropertyGet(name, params, body) {
        var sig = params == "" ? "Property Get %(name)()" : "Property Get %(name)(%(params))"
        addFromString(sig + "\n" + body + "\nEnd Property\n\n")
    }

    // Поиск текста в коде: найти номер первой строки с вхождением.
    // Возвращает номер строки (1-based) или -1 если не найдено.
    findLine(text) {
        var cm = _mod.get("CodeModule")
        var cnt = cm.get("CountOfLines")
        if (cnt == 0) {
            cm.release()
            return -1
        }
        var result = cm.call("Find", text, 1, 1, cnt, 1, false, false, false)
        cm.release()
        // Find возвращает true/false; для получения номера строки
        // используется Lines после Find — упрощённая версия возвращает -1 при неудаче
        if (result == false) return -1
        return 1  // упрощённо: если нашёл — где-то есть
    }
}

// =============================================================================
// XlVbaProject — VBA проект книги (доступ к модулям)
//
// Требование: "Trust access to the VBA project object model" в Excel Trust Center.
// Получить через wb.vbaProject()
// =============================================================================
class XlVbaProject {
    // Внутренний конструктор — вызывается из XlBook
    construct new_(vbp) { _vbp = vbp }

    // Доступ к сырому COM-объекту VBProject
    raw { _vbp }

    // Освободить COM-объект
    release() { _vbp.release() }

    // Выполнить блок и автоматически освободить
    use(fn) {
        fn.call(this)
        release()
    }

    // ── Свойства проекта ─────────────────────────────────────────────────────

    // Имя VBA проекта (по умолчанию "VBAProject")
    name    { _vbp.get("Name") }
    name=(v){ _vbp.set("Name", v) }

    // Количество компонентов (листы + ThisWorkbook + стандартные модули)
    moduleCount {
        var comps = _vbp.get("VBComponents")
        var cnt = comps.count
        comps.release()
        return cnt
    }

    // ── Получение модулей ────────────────────────────────────────────────────

    // Получить модуль по имени ("Module1", "Sheet1", "ThisWorkbook").
    // Возвращает XlVbaModule; проверяйте .isNull если не найден.
    module(name) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Item", name)
        comps.release()
        return XlVbaModule.new_(mod)
    }

    // Получить модуль по индексу (1-based)
    // Возвращает XlVbaModule; проверяйте .isNull если не найден.
    moduleAt(index) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Item", index)
        comps.release()
        return XlVbaModule.new_(mod)
    }

    // Проверить, существует ли модуль с данным именем
    hasModule(name) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Item", name)
        comps.release()
        var found = !mod.isNull
        mod.release()
        return found
    }

    // Список имён всех компонентов (включая листы и ThisWorkbook)
    moduleNames() {
        var comps = _vbp.get("VBComponents")
        var cnt = comps.count
        var names = []
        var i = 1
        while (i <= cnt) {
            var mod = comps.call("Item", i)
            names.add(mod.get("Name"))
            mod.release()
            i = i + 1
        }
        comps.release()
        return names
    }

    // ── Создание и удаление модулей ──────────────────────────────────────────

    // Создать новый стандартный модуль (тип 1 = vbext_ct_StdModule).
    // Возвращает XlVbaModule.
    addModule(name) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Add", 1)
        comps.release()
        mod.set("Name", name)
        return XlVbaModule.new_(mod)
    }

    // Создать новый модуль класса (тип 2 = vbext_ct_ClassModule).
    addClassModule(name) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Add", 2)
        comps.release()
        mod.set("Name", name)
        return XlVbaModule.new_(mod)
    }

    // Удалить модуль по имени. Нельзя удалять Document-модули (Sheet1, ThisWorkbook).
    removeModule(name) {
        var comps = _vbp.get("VBComponents")
        var mod = comps.call("Item", name)
        if (mod != null) {
            comps.call("Remove", mod)
            // mod уже освобождён внутри call() через var_clear — не вызывать release()
        }
        comps.release()
    }

    // Удалить модуль если существует (безопасная версия removeModule)
    removeModuleIfExists(name) {
        if (hasModule(name)) removeModule(name)
    }

    // Перебрать все модули (fn получает XlVbaModule каждого компонента)
    each(fn) {
        var comps = _vbp.get("VBComponents")
        var cnt = comps.count
        var i = 1
        while (i <= cnt) {
            var mod = XlVbaModule.new_(comps.call("Item", i))
            fn.call(mod)
            mod.release()
            i = i + 1
        }
        comps.release()
    }
}

// =============================================================================
// XlBook — рабочая книга
//
// После использования вызвать .release() или .use{|wb| ... }
// =============================================================================
class XlBook {
    // Внутренний конструктор — вызывается из XlApp
    construct new_(wb) { _wb = wb }

    // Доступ к сырому COM-объекту
    raw { _wb }

    // Освободить COM-объект
    release() { _wb.release() }

    // Выполнить блок и автоматически освободить:
    //   app.open("file.xlsx").use {|wb| wb.sheet(1).use {|ws| ... } }
    use(fn) {
        fn.call(this)
        release()
    }

    // ── Свойства книги ───────────────────────────────────────────────────────

    // Имя файла без пути ("report.xlsx")
    name { _wb.get("Name") }

    // Полный путь к файлу ("C:\reports\report.xlsx")
    fullPath { _wb.get("FullName") }

    // Количество листов в книге
    sheetCount {
        var sheets = _wb.get("Sheets")
        var cnt = sheets.count
        sheets.release()
        return cnt
    }

    // ── Работа с листами ─────────────────────────────────────────────────────

    // Получить лист по индексу (1-based) или по имени ("Лист1")
    sheet(nameOrIndex) {
        return XlSheet.new_(_wb.get("Sheets").callR("Item", nameOrIndex))
    }

    // Получить активный (текущий) лист книги
    activeSheet() { XlSheet.new_(_wb.get("ActiveSheet")) }

    // Добавить новый лист (по умолчанию вставляется перед активным)
    addSheet(name) {
        var ws = _wb.get("Sheets").callR("Add")
        ws.set("Name", name)
        return XlSheet.new_(ws)
    }

    // Добавить лист после листа с указанным индексом.
    // Реализация: Add(Before:=sheets.Item(afterIndex+1)) — вставляет между
    // afterIndex и afterIndex+1. Если afterIndex — последний лист, добавляет
    // без позиции (Excel сам выберет место).
    addSheetAfter(afterIndex, name) {
        var sheets = _wb.get("Sheets")
        var cnt = sheets.count
        var ws
        if (afterIndex < cnt) {
            // Вставить перед следующим листом = после afterIndex
            var before = sheets.call("Item", afterIndex + 1)
            ws = sheets.call("Add", before)
            before.release()
        } else {
            // afterIndex — последний лист: добавить без параметров
            ws = sheets.call("Add")
        }
        sheets.release()
        ws.set("Name", name)
        return XlSheet.new_(ws)
    }

    // ── Сохранение и закрытие ────────────────────────────────────────────────

    // Сохранить в текущий файл
    save() { _wb.call("Save") }

    // Сохранить под новым именем в формате .xlsx (формат 51 = xlOpenXMLWorkbook)
    saveAs(path) { _wb.call("SaveAs", path, 51) }

    // Сохранить как .xlsm — книга с поддержкой макросов (формат 52)
    // ОБЯЗАТЕЛЬНО для сохранения VBA-кода!
    saveAsXlsm(path) { _wb.call("SaveAs", path, 52) }

    // Сохранить как .xlsb — двоичный формат с макросами (формат 50, быстрее)
    saveAsXlsb(path) { _wb.call("SaveAs", path, 50) }

    // Сохранить активный лист как .csv (формат 6 = xlCSV)
    saveAsCsv(path) { _wb.call("SaveAs", path, 6) }

    // Закрыть без сохранения
    close() { _wb.call("Close", false) }

    // Закрыть с сохранением изменений
    closeSave() { _wb.call("Close", true) }

    // ── VBA макросы ───────────────────────────────────────────────────────────

    // Получить VBA проект книги → XlVbaProject.
    // Требует: File → Options → Trust Center → Macro Settings →
    //   "Trust access to the VBA project object model" = включён.
    // Для сохранения кода использовать saveAsXlsm().
    vbaProject() {
        var vbp = _wb.get("VBProject")
        if (vbp.isNull) Fiber.abort("VBA недоступен. Включите: Excel -> Параметры -> Центр безопасности -> Параметры макросов -> Доверять доступ к объектной модели VBA")
        return XlVbaProject.new_(vbp)
    }
}

// =============================================================================
// XlApp — приложение Excel
// =============================================================================
class XlApp {
    // Запустить Excel невидимо (для фоновой автоматизации — быстрее)
    construct new() {
        _app = OleObject.create("Excel.Application")
        if (_app.isNull) Fiber.abort("Excel не найден: %(OleObject.lastError)")
        _app.set("Visible",        false)
        _app.set("DisplayAlerts",  false)
        _app.set("ScreenUpdating", false)
    }

    // Запустить Excel видимо (для интерактивной работы / отладки)
    construct visible() {
        _app = OleObject.create("Excel.Application")
        if (_app.isNull) Fiber.abort("Excel не найден: %(OleObject.lastError)")
        _app.set("Visible",       true)
        _app.set("DisplayAlerts", false)
    }

    // Подключиться к уже запущенному Excel (GetActiveObject)
    construct connect() {
        _app = OleObject.connect("Excel.Application")
        if (_app.isNull) Fiber.abort("Excel не запущен или не доступен")
    }

    // Доступ к сырому COM-объекту приложения
    raw { _app }

    // ── Настройки приложения ─────────────────────────────────────────────────

    // Показать или скрыть окно Excel
    visible    { _app.get("Visible") }
    visible=(v){ _app.set("Visible", v) }

    // Обновление экрана (false = быстрее, включить обратно после работы)
    screenUpdating=(v) { _app.set("ScreenUpdating", v) }

    // Системные диалоги ("Сохранить?", предупреждения и т.п.)
    displayAlerts=(v) { _app.set("DisplayAlerts", v) }

    // Версия Excel ("16.0" и т.п.)
    version { _app.get("Version") }

    // ── Управление книгами ───────────────────────────────────────────────────

    // Создать новую пустую книгу
    newBook() {
        return XlBook.new_(_app.get("Workbooks").callR("Add"))
    }

    // Открыть файл (.xlsx, .xls, .csv, ...)
    open(path) {
        return XlBook.new_(_app.get("Workbooks").callR("Open", path))
    }

    // Открыть файл только для чтения
    openReadOnly(path) {
        var wbs = _app.get("Workbooks")
        var wb  = wbs.call("Open", path, 0, true)  // 3-й аргумент ReadOnly=true
        wbs.release()
        return XlBook.new_(wb)
    }

    // Получить активную книгу (ту, что сейчас в фокусе)
    activeBook() {
        var wb = _app.get("ActiveWorkbook")
        if (wb.isNull) Fiber.abort("Нет активной книги Excel")
        return XlBook.new_(wb)
    }

    // Количество открытых книг
    bookCount {
        var wbs = _app.get("Workbooks")
        var cnt = wbs.count
        wbs.release()
        return cnt
    }

    // ── Запуск макросов ───────────────────────────────────────────────────────

    // Запустить макрос по имени. Имя может включать имя модуля:
    //   "MyMacro", "Module1.MyMacro", "Sheet1.MyMacro"
    // Не требует специальных настроек безопасности.
    runMacro(name) { _app.call("Run", name) }

    // Запустить макрос с аргументами (до 8 аргументов)
    runMacro(name, a) { _app.call("Run", name, a) }
    runMacro(name, a, b) { _app.call("Run", name, a, b) }
    runMacro(name, a, b, c) { _app.call("Run", name, a, b, c) }
    runMacro(name, a, b, c, d) { _app.call("Run", name, a, b, c, d) }
    runMacro(name, a, b, c, d, e) { _app.call("Run", name, a, b, c, d, e) }
    runMacro(name, a, b, c, d, e, f) { _app.call("Run", name, a, b, c, d, e, f) }
    runMacro(name, a, b, c, d, e, f, g) { _app.call("Run", name, a, b, c, d, e, f, g) }

    // ── Завершение работы ────────────────────────────────────────────────────

    // Закрыть приложение Excel
    quit() {
        _app.call("Quit")
        _app.release()
    }

    // Освободить COM-объект без закрытия Excel
    release() { _app.release() }
}
