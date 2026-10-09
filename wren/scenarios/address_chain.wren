import "out" for Out
import "inspector" for Inspector, QtObj

// Обход цепочки виджетов по адресам.
// Показывает: получить виджет → взять адрес → восстановить через atAddress.

var tops = Inspector.topWidgets
if (tops.count == 0) {
    Out.warn("Нет top-level виджетов")
    return
}

var win = tops[0]
Out.sep("=== %(win.toString) ===")
Out.val("address", "0x%(win.address)")

// Перечисляем детей с адресами
Out.sep("--- children ---")
var i = 0
while (i < win.childCount) {
    var c = win.childAt(i)
    Out.print("  [%(i)]  %(c.toString)  @0x%(c.address)")
    i = i + 1
}

// Берём первого ребёнка по адресу и дампим
if (win.childCount > 0) {
    var addr = win.childAt(0).address
    Out.sep("--- Inspector.atAddress(child[0].address) ---")
    var w = Inspector.atAddress(addr)
    w.dump

    // Поднимаемся к parent
    Out.sep("--- w.parent ---")
    var p = w.parent
    if (p.isNull) {
        Out.print("(top-level)")
    } else {
        Out.print("%(p.toString)  @0x%(p.address)")
    }
}
