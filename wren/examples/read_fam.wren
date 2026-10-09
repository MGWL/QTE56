import "excel" for XlApp
import "utils" for ListUtil

var path = "c:\\mgw\\ndt\\moodle\\БАЗА_ОБУЧЕНИЯ_2025_MGW.xlsm"

var xl = XlApp.new()
var wb = xl.open(path)
var ws = wb.sheet("БД 2025")

// Последняя строка с данными во 2-м столбце
var last = ws.lastRow(2)
System.print("Последняя строка: %(last)")

// Читаем столбец 3 (Фамилия) со строки 2 до last включительно
var allFam = []
for (row in 2...last) {
    var fam = ws.getValue(row, 3)
    if (fam != null) allFam.add(fam.toString.trim())
}

ws.release()
wb.close()
xl.quit()

// Убрать дубли (сохраняет порядок первого вхождения)
var unique = ListUtil.dedup(allFam)

// Отсортировать по алфавиту
ListUtil.sort(unique)

var result = unique

System.print("Всего уникальных: %(result.count)")
for (fam in result) {
    System.print(fam)
}
