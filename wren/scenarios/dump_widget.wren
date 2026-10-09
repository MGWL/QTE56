import "out" for Out
import "inspector" for Inspector, QtObj

// Дамп виджета по имени.
// Замените "myWidget" на реальный objectName.

var name = "myWidget"
var w = Inspector.find(name)

if (w.isNull) {
    Out.warn("Виджет '%(name)' не найден. Дамп первого top-level виджета:")
    w = Inspector.topWidgets[0]
}

w.dump

Out.sep("--- propertyNames ---")
Out.print(w.propertyNames_.split("\n").join(", "))

Out.sep("--- chain: parent ---")
var p = w.parent
if (!p.isNull) {
    Out.print("parent: %(p.toString)")
    p.dump
} else {
    Out.print("(top-level, нет parent)")
}
