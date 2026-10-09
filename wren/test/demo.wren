import "qt" for Widget, Widgets, Logger

/**
 * demo.wren — логика приложения на Wren.
 *
 * D строит Qt-окно и регистрирует виджеты:
 *   edit   — QLineEdit (ввод имени)
 *   combo  — QComboBox (выбор приветствия)
 *   spin   — QSpinBox  (число повторений)
 *   lbl    — QLabel    (вывод результата)
 *   log    — QPlainTextEdit (лог)
 *   chk    — QCheckBox (верхний регистр)
 *
 * D вызывает статические методы Handler при событиях.
 */

class Handler {
    // Кнопка "Сгенерировать" — читает виджеты, формирует текст, обновляет UI
    static onGenerate() {
        var edit  = Widgets.get("edit")
        var combo = Widgets.get("combo")
        var spin  = Widgets.get("spin")
        var lbl   = Widgets.get("lbl")
        var log_  = Widgets.get("log")
        var chk   = Widgets.get("chk")

        var name    = edit.text
        var greet   = Greetings.get(combo.currentIndex)
        var count   = spin.value
        var upper   = chk.isChecked

        if (name == "") name = "мир"

        var line = greet + ", " + name + "!"
        if (upper) line = Handler.toUpper(line)

        var result = ""
        var i = 0
        while (i < count) {
            if (result != "") result = result + "\n"
            result = result + line
            i = i + 1
        }

        lbl.setText(result)
        log_.addItem("[generate] count=" + count.toString + " upper=" + upper.toString)
        Logger.print("Generated: " + line + " ×" + count.toString + "\n")
    }

    // Кнопка "Очистить"
    static onClear() {
        Widgets.get("edit").setText("")
        Widgets.get("lbl").setText("")
        Widgets.get("log").clearItems()
        Widgets.get("spin").setValue(1)
        Logger.print("Cleared\n")
    }

    // Кнопка "Информация о виджетах"
    static onInfo() {
        var log_ = Widgets.get("log")
        var widgets = ["edit", "combo", "spin", "lbl", "chk"]
        for (name in widgets) {
            var w = Widgets.get(name)
            log_.addItem(name + " → " + w.className)
        }
        Logger.print("Widget info logged\n")
    }

    // Вызывается при изменении текста в edit
    static onTextChanged() {
        var text = Widgets.get("edit").text
        var hint = Widgets.get("lbl")
        if (text.count > 0) {
            hint.setText("Нажмите «Сгенерировать» для «" + text + "»")
        } else {
            hint.setText("")
        }
    }

    // Проверка работы аргументов D→Wren
    static multiply(a, b) {
        return a * b
    }

    // Примитивный toUpper (ASCII-only)
    static toUpper(s) {
        return s   // Wren не имеет встроенного toUpper; заглушка
    }
}

// Список приветствий по индексу combo
class Greetings {
    static get(index) {
        var list = ["Привет", "Hello", "Hola", "Bonjour", "Ciao", "こんにちは"]
        if (index < 0 || index >= list.count) return "Привет"
        return list[index]
    }
    static count { 6 }
}
