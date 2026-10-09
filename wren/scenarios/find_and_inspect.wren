import "out" for Out
import "inspector" for Inspector, QtObj

// Найти виджет по имени и показать его свойства.
// Замените "myWidget" на реальный objectName вашего виджета.

var name = "myWidget"

var w = Inspector.find(name)

if (w.isNull) {
    Out.warn("Виджет '%(name)' не найден")
    Out.sep("")
    Out.print("Доступные виджеты:")
    Inspector.allWidgets.each {|x|
        if (x.name.count > 0) Out.print("  %(x.className)(%(x.name))")
    }
} else {
    Out.sep("=== %(w.toString) ===")
    Out.val("className",  w.className)
    Out.val("name",       w.name)
    Out.val("address",    w.address)
    Out.val("childCount", w.childCount)
    Out.val("visible",    w.property("visible"))
    Out.val("enabled",    w.property("enabled"))
    Out.val("geometry",   w.property("geometry"))
    Out.sep("--- children ---")
    w.children.each {|c|
        Out.print("  %(c.className)(%(c.name))")
    }
}
