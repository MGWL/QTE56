import "out" for Out
import "inspector" for Inspector, QtObj

// Подсчёт виджетов по типу класса.

var all = Inspector.allWidgets

// Собираем уникальные className и их количество.
// Wren не имеет Map, используем два параллельных списка.
var keys   = []
var counts = []

all.each {|w|
    var cls = w.className
    var found = false
    var i = 0
    while (i < keys.count) {
        if (keys[i] == cls) {
            counts[i] = counts[i] + 1
            found = true
        }
        i = i + 1
    }
    if (!found) {
        keys.add(cls)
        counts.add(1)
    }
}

Out.sep("=== Widgets by class (%(all.count) total) ===")
var i = 0
while (i < keys.count) {
    Out.print("  %(counts[i])  %(keys[i])")
    i = i + 1
}
Out.sep("")
