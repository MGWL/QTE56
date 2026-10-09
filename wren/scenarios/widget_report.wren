import "out" for Out
import "inspector" for Inspector, QtObj

Out.sep("=== Widget Report ===")
Out.val("All widgets",     Inspector.allWidgets.count)
Out.val("Top-level windows", Inspector.topWidgets.count)
Out.sep("")

Inspector.topWidgets.each {|win|
    Out.print("%(win.className)(%(win.name))")
    win.children.each {|c|
        Out.print("  └─ %(c.className)(%(c.name))")
    }
}

Out.sep("=== Done ===")
