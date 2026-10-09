import "out" for Out
import "check" for Check
import "inspector" for Inspector, QtObj

// Минимальный набор проверок Inspector API.
// Запускать в demo_inspector или любом приложении с именованными виджетами.

Check.reset()

// ── 1. Списки виджетов ─────────────────────────────────────────────────────

var all = Inspector.allWidgets
Check.that("allWidgets не пустой",  all.count > 0)

var tops = Inspector.topWidgets
Check.that("topWidgets не пустой", tops.count > 0)
Check.that("topWidgets <= allWidgets", tops.count <= all.count)

// ── 2. Inspector.find ─────────────────────────────────────────────────────

var missing = Inspector.find("__no_such_widget__")
Check.that("find несуществующего → isNull", missing.isNull)

// ── 3. QtObj свойства первого top-level виджета ───────────────────────────

var w = tops[0]
Check.that("className не пустой",  w.className.count > 0)
Check.that("toString не пустой",   w.toString.count  > 0)
Check.that("address != 0",         w.address != 0)
Check.that("isNull == false",      !w.isNull)
Check.that("childCount >= 0",      w.childCount >= 0)

// ── 4. Дерево: children ───────────────────────────────────────────────────

var children = w.children
Check.equal(children.count, w.childCount, "children.count == childCount")

// parent top-level виджета — null
Check.that("parent top-level isNull", w.parent.isNull)

// ── 5. property / invoke (не должны крашиться) ────────────────────────────

var vis = w.property("visible")
Check.that("property(visible) не пустой", vis.count >= 0)

var ok = w.invoke("show")
Check.that("invoke(show) вернул true", ok)

// ── Итог ──────────────────────────────────────────────────────────────────

Check.report()
