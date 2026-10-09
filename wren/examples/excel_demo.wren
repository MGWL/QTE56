// excel_demo.wren — Демонстрация библиотеки excel.wren
//
// Запуск: wren_ide или wren_test с путём до этого файла
// Нужно: Microsoft Excel установлен на компьютере
//
// Демонстрирует:
//   1. Создание книги и заполнение данными
//   2. Форматирование заголовков (жирный, цвет фона, выравнивание)
//   3. Форматирование числовых колонок
//   4. Рамки таблицы
//   5. Итоговая строка с формулой SUM
//   6. Второй лист — итоги по кварталам
//   7. Сохранение файла
//   8. Чтение данных из файла
//   9. Использование блоков .use{} для авто-release
//  10. XlUtil — генерация адресов ячеек

import "excel" for XlApp, XlBook, XlSheet, XlRange
import "excel" for XlColor, XlAlign, XlBorder, XlFmt, XlUtil
import "sys"   for Sys

// ─── Вспомогательная функция для вывода результата ───────────────────────────
var pass = 0
var fail = 0

var check = Fn.new {|name, ok|
    if (ok) {
        System.print("[OK] %(name)")
        pass = pass + 1
    } else {
        System.print("[!!] %(name)")
        fail = fail + 1
    }
}

// =============================================================================
// РАЗДЕЛ 1 — XlUtil: вспомогательные функции адресации
// =============================================================================

System.print("\n--- XlUtil ---")

check.call("colLetter(1)  = A",  XlUtil.colLetter(1)  == "A")
check.call("colLetter(26) = Z",  XlUtil.colLetter(26) == "Z")
check.call("colLetter(27) = AA", XlUtil.colLetter(27) == "AA")
check.call("colLetter(52) = AZ", XlUtil.colLetter(52) == "AZ")
check.call("addr(1,1)     = A1", XlUtil.addr(1, 1)    == "A1")
check.call("addr(3,4)     = D3", XlUtil.addr(3, 4)    == "D3")
check.call("addrRange(1,1,3,4) = A1:D3",
    XlUtil.addrRange(1, 1, 3, 4) == "A1:D3")

// =============================================================================
// РАЗДЕЛ 2 — Создание книги и заполнение данными
// =============================================================================

System.print("\n--- Создание Excel ---")

// Запускаем Excel невидимо для быстрой работы
var xl = XlApp.new()
check.call("Excel запущен", !xl.raw.isNull)
System.print("Версия Excel: %(xl.version)")

// Создаём новую книгу
var wb = xl.newBook()
check.call("Книга создана", !wb.raw.isNull)

// Получаем первый лист и переименовываем
var ws = wb.sheet(1)
ws.name = "Продажи"
check.call("Имя листа", ws.name == "Продажи")

// ─── Данные: ежемесячные продажи ─────────────────────────────────────────────
var headers = ["Месяц", "Товар А", "Товар Б", "Товар В", "Итого"]

var data = [
    ["Январь",   12500, 8300,  6100],
    ["Февраль",  14200, 9100,  7200],
    ["Март",     16800, 10500, 8900],
    ["Апрель",   13600, 8700,  6800],
    ["Май",      15900, 11200, 9400],
    ["Июнь",     18200, 12300, 10100],
    ["Июль",     17100, 11800, 9700],
    ["Август",   16500, 10900, 8600],
    ["Сентябрь", 19300, 13100, 10800],
    ["Октябрь",  20100, 14200, 11500],
    ["Ноябрь",   18700, 12900, 10300],
    ["Декабрь",  22500, 15600, 12800]
]

// =============================================================================
// РАЗДЕЛ 3 — Запись заголовков и форматирование
// =============================================================================

System.print("\n--- Заголовки ---")

// Записать строку заголовков начиная с A1
ws.writeRow(1, 1, headers)

// Форматировать заголовки A1:E1
ws.range("A1:E1").use {|hdr|
    hdr.format({
        "bold":      true,
        "bgColor":   XlColor.darkBlue,
        "fontColor": XlColor.white,
        "hAlign":    XlAlign.center,
        "vAlign":    XlAlign.middle,
        "fontSize":  11
    })
    hdr.setBorderAll(XlBorder.styleSolid, XlColor.black)
}
System.print("Заголовки записаны и отформатированы")

// =============================================================================
// РАЗДЕЛ 4 — Запись данных и формул
// =============================================================================

System.print("\n--- Данные ---")

// Записать данные начиная со строки 2
for (i in 0...data.count) {
    var rowNum = i + 2
    var row = data[i]
    ws.writeRow(rowNum, 1, row)
    // Формула суммы по строке в колонке E
    var formula = "=SUM(B%(rowNum):D%(rowNum))"
    ws.setFormula(XlUtil.addr(rowNum, 5), formula)
}

System.print("Данные записаны (%(data.count) строк)")

// Проверяем одно значение
check.call("Январь, Товар А = 12500",
    ws.getValue("B2") == 12500)

// =============================================================================
// РАЗДЕЛ 5 — Итоговая строка
// =============================================================================

System.print("\n--- Итоги ---")

var totalRow = data.count + 2  // строка 14

ws.setValue("A%(totalRow)", "ИТОГО")

// Формулы суммы по каждому столбцу
for (col in 2..5) {
    var letter = XlUtil.colLetter(col)
    ws.setFormula(
        "%(letter)%(totalRow)",
        "=SUM(%(letter)2:%(letter)%(totalRow - 1))"
    )
}

// Форматировать строку итогов
ws.range("A%(totalRow):E%(totalRow)").use {|tot|
    tot.format({
        "bold":    true,
        "bgColor": XlColor.lightGray
    })
    tot.setBorderAll(XlBorder.styleSolid, XlColor.black)
}

System.print("Итоговая строка добавлена в строке %(totalRow)")

// =============================================================================
// РАЗДЕЛ 6 — Числовой формат для колонок B:E
// =============================================================================

System.print("\n--- Форматирование чисел ---")

// Денежный формат без знака валюты
ws.range("B2:E%(totalRow)").use {|nums|
    nums.numberFormat = XlFmt.thousands
    nums.hAlign = XlAlign.right
}

// =============================================================================
// РАЗДЕЛ 7 — Ширина колонок
// =============================================================================

ws.setColumnWidth(1, 14)   // Месяц
for (col in 2..5) {
    ws.setColumnWidth(col, 13)
}

// Высота строки заголовка
ws.setRowHeight(1, 22)

System.print("Ширина столбцов установлена")

// =============================================================================
// РАЗДЕЛ 8 — Границы таблицы данных
// =============================================================================

System.print("\n--- Границы таблицы ---")

// Внутренняя сетка для области данных
ws.range("A2:E%(totalRow - 1)").use {|body|
    body.setBorderFull(XlBorder.styleSolid, XlColor.lightGray)
}

// Жирная внешняя рамка всей таблицы
var tableRange = "A1:E%(totalRow)"
ws.range(tableRange).use {|tbl|
    for (side in [XlBorder.left, XlBorder.top,
                  XlBorder.right, XlBorder.bottom]) {
        tbl.setBorder(side, XlBorder.styleSolid, XlColor.black)
        tbl.setBorderWeight(side, XlBorder.medium)
    }
}

System.print("Границы установлены")

// =============================================================================
// РАЗДЕЛ 9 — Второй лист: ежеквартальные итоги
// =============================================================================

System.print("\n--- Второй лист ---")

var wsQ = wb.addSheetAfter(1, "Кварталы")
check.call("Лист 'Кварталы' создан", wsQ.name == "Кварталы")

// Заголовки
wsQ.writeRow(1, 1, ["Квартал", "Товар А", "Товар Б", "Товар В", "Итого"])
wsQ.range("A1:E1").use {|h|
    h.format({
        "bold":      true,
        "bgColor":   XlColor.darkRed,
        "fontColor": XlColor.white,
        "hAlign":    XlAlign.center
    })
}

// Квартальные данные — ссылки на лист "Продажи" через формулы
var quarters = ["Q1 (Янв-Мар)", "Q2 (Апр-Июн)", "Q3 (Июл-Сен)", "Q4 (Окт-Дек)"]
var qRanges  = [["B2:B4",  "C2:C4",  "D2:D4"],
                ["B5:B7",  "C5:C7",  "D5:D7"],
                ["B8:B10", "C8:C10", "D8:D10"],
                ["B11:B13","C11:C13","D11:D13"]]

for (q in 0...4) {
    var r = q + 2
    wsQ.setValue("A%(r)", quarters[q])
    for (c in 0...3) {
        var colLetter = XlUtil.colLetter(c + 2)
        wsQ.setFormula(
            "%(colLetter)%(r)",
            "=SUM(Продажи!%(qRanges[q][c]))"
        )
    }
    wsQ.setFormula("E%(r)", "=SUM(B%(r):D%(r))")
}

// Ширина и формат чисел на втором листе
wsQ.setColumnWidth(1, 18)
for (col in 2..5) { wsQ.setColumnWidth(col, 13) }
wsQ.range("B2:E5").use {|n| n.numberFormat = XlFmt.thousands }

System.print("Квартальный лист заполнен")
wsQ.release()

// =============================================================================
// РАЗДЕЛ 10 — Сохранение
// =============================================================================

System.print("\n--- Сохранение ---")

var savePath = "C:\\Temp\\excel_demo_output.xlsx"
wb.saveAs(savePath)
System.print("Файл сохранён: %(savePath)")

// Закрываем лист и книгу
ws.release()
wb.release()

// =============================================================================
// РАЗДЕЛ 11 — Чтение сохранённого файла
// =============================================================================

System.print("\n--- Чтение файла ---")

// Открываем файл только для чтения
var wb2 = xl.openReadOnly(savePath)
check.call("Файл открыт", !wb2.raw.isNull)
check.call("Количество листов = 2", wb2.sheetCount == 2)

// Читаем данные через блок use{}
wb2.sheet(1).use {|s|
    check.call("Название листа = Продажи", s.name == "Продажи")
    check.call("Январь A2 = Январь",       s.getValue("A2") == "Январь")
    check.call("Товар А B2 = 12500",        s.getValue("B2") == 12500)
    check.call("Строк = %(s.rowCount)",     s.rowCount == 14)  // 1 загол + 12 данных + 1 итог

    // readRow — прочитать заголовки
    var hdrs = s.readRow(1, 1, 5)
    check.call("Заголовок col1 = Месяц",  hdrs[0] == "Месяц")
    check.call("Заголовок col5 = Итого",  hdrs[4] == "Итого")

    // readCol — прочитать все месяцы
    var months = s.readCol(1, 2, 12)
    check.call("Первый месяц = Январь",   months[0]  == "Январь")
    check.call("Последний месяц = Декабрь", months[11] == "Декабрь")

    // find — поиск ячейки
    var found = s.find("Май")
    check.call("find('Май') не null", !found.isNull)
    if (!found.isNull) {
        System.print("  'Май' найдено в: %(found.address)")
        found.release()
    }
}

// Читаем второй лист
wb2.sheet("Кварталы").use {|s|
    check.call("Название листа 2 = Кварталы", s.name == "Кварталы")
    check.call("Q1 в A2", s.getValue("A2") == "Q1 (Янв-Мар)")
}

wb2.close()
wb2.release()

// =============================================================================
// РАЗДЕЛ 12 — Демонстрация toList / fromList
// =============================================================================

System.print("\n--- toList / fromList ---")

var wb3 = xl.newBook()
wb3.sheet(1).use {|s|
    // Заполняем через fromList
    var matrix = [
        ["A", "B", "C"],
        [1,   2,   3  ],
        [4,   5,   6  ]
    ]
    s.range("A1:C3").use {|r| r.fromList(matrix) }

    // Читаем обратно через toList
    var back = s.range("A1:C3")
    var rows = back.toList()
    back.release()

    check.call("toList rows = 3",   rows.count == 3)
    check.call("toList [0][0] = A", rows[0][0] == "A")
    check.call("toList [1][1] = 2", rows[1][1] == 2)
    check.call("toList [2][2] = 6", rows[2][2] == 6)

    // each — итерация с выводом
    System.write("  Значения: ")
    s.range("A1:C1").use {|r|
        r.each {|cell|
            System.write("%(cell.value) ")
        }
    }
    System.print("")
}

wb3.close()
wb3.release()

// =============================================================================
// РАЗДЕЛ 13 — VBA макросы
// =============================================================================
// ВНИМАНИЕ: этот раздел требует настройки Excel:
//   File → Options → Trust Center → Macro Settings →
//   "Trust access to the VBA project object model" = включён
//   Без этой настройки vbaProject() вызовет Fiber.abort().
//
// Раздел пропускается если настройка не включена.
// =============================================================================

System.print("\n--- VBA макросы ---")

var wb4 = xl.newBook()
var vbaOk = false

// Проверяем доступность VBAProject через xl.raw напрямую
var testVbp = wb4.raw.get("VBProject")
if (testVbp.isNull) {
    System.print("  VBA недоступен (включите 'Trust access to VBA project object model')")
    System.print("  Раздел пропущен")
} else {
    testVbp.release()
    vbaOk = true
}

if (vbaOk) {
    var vba = wb4.vbaProject()

    // Список стандартных модулей (Sheet1, Sheet2, Sheet3, ThisWorkbook)
    var names = vba.moduleNames()
    check.call("Модули существуют (>0)", names.count > 0)
    System.print("  Модули по умолчанию: %(names)")

    // Создать новый стандартный модуль
    var mod = vba.addModule("WrenGenerated")
    check.call("Модуль создан", mod.name == "WrenGenerated")

    // Добавить процедуру через addSub
    mod.addSub("FillCell", "ws As Object, addr As String, val As String",
        "    ws.Range(addr).Value = val")

    // Добавить функцию через addFunction
    mod.addFunction("Square", "x As Double",
        "    Square = x * x")

    // Добавить утилиту через addFromString (многострочный блок)
    mod.addFromString(
        "Sub ColorHeader(ws As Object)\n" +
        "    ws.Range(\"A1\").Interior.Color = 13434828\n" +
        "    ws.Range(\"A1\").Font.Bold = True\n" +
        "End Sub\n\n"
    )

    // Прочитать код модуля
    var code = mod.code
    check.call("Код записан (содержит Sub)", code.contains("Sub FillCell"))
    check.call("Код содержит Function", code.contains("Function Square"))
    var cnt = mod.lineCount
    System.print("  Строк кода в модуле: %(cnt)")

    // Проверить существование модуля
    check.call("hasModule('WrenGenerated')", vba.hasModule("WrenGenerated"))
    check.call("hasModule('NoSuch') = false", !vba.hasModule("NoSuch"))

    mod.release()

    // Получить модуль по имени
    var mod2 = vba.module("WrenGenerated")
    check.call("module() вернул модуль", !mod2.isNull)
    if (!mod2.isNull) {
        check.call("Имя модуля через module()", mod2.name == "WrenGenerated")
        mod2.release()
    }

    // Добавить модуль с Option Explicit
    var modOpts = vba.addModule("Utils")
    modOpts.insertLines(1, "Option Explicit\n\n")
    modOpts.addSub("ClearSheet", "ws As Object",
        "    ws.UsedRange.Clear")
    check.call("Utils создан", vba.hasModule("Utils"))
    modOpts.release()

    // Запустить макрос через xl.runMacro
    // (макросы работают с активной книгой — активируем нужный лист)
    wb4.sheet(1).use {|ws|
        ws.setValue("A1", "До макроса")
    }

    // Запустить макрос с аргументами
    // xl.runMacro("WrenGenerated.FillCell", sheet_obj, "A1", "После макроса")
    // Запуск без аргументов — тест что runMacro не падает на синтаксически корректном имени
    System.print("  Макросы записаны, запуск через xl.runMacro()")

    // Перебрать все модули
    System.write("  Все модули: ")
    vba.each {|m|
        System.write("%(m.name) ")
    }
    System.print("")

    // Удалить стандартный модуль
    vba.removeModule("WrenGenerated")
    check.call("removeModule: модуль удалён", !vba.hasModule("WrenGenerated"))

    vba.release()

    // Сохранить как .xlsm (обязательно для сохранения VBA кода)
    var xlsmPath = "C:\\Temp\\excel_demo_macro.xlsm"
    wb4.saveAsXlsm(xlsmPath)
    System.print("  Сохранено: %(xlsmPath)")
}

wb4.close()
wb4.release()

// =============================================================================
// РАЗДЕЛ 14 — Завершение
// =============================================================================

xl.quit()
System.print("\nExcel завершён")

System.print("\n=== Итог: %(pass) OK, %(fail) FAIL ===")
