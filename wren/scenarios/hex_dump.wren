import "out" for Out
import "inspector" for Inspector, QtObj

// Hex dump памяти объекта.
// Замените "myWidget" на реальный objectName.

var name = "myWidget"
var w = Inspector.find(name)
if (w.isNull) {
    Out.warn("'%(name)' не найден, дамп первого top-level виджета")
    w = Inspector.topWidgets[0]
}

// Дамп первых 128 байт объекта
w.hexDump

// Дамп 64 байт начиная с произвольного адреса
Out.sep("--- Inspector.hexDump(addr, 64) ---")
Inspector.hexDump(w.address, 64)

// Дамп parent-объекта (если есть)
var p = w.parent
if (!p.isNull) {
    Out.sep("--- parent: %(p.toString) ---")
    p.hexDump(64)
}
