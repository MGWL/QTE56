// word.wren — Word automation helper
// Usage: import "word" for Word

import "ole" for OleObject

class Word {
    construct open(visible) {
        _app = OleObject.create("Word.Application")
        if (_app.isNull) Fiber.abort("Cannot create Word.Application: %(OleObject.lastError)")
        _app.set("Visible", visible)
        _app.set("DisplayAlerts", 0)
    }

    app { _app }

    addDocument() {
        var docs = _app.get("Documents")
        var doc = docs.call("Add")
        docs.release()
        return doc
    }

    openFile(path) {
        var docs = _app.get("Documents")
        var doc = docs.call("Open", path)
        docs.release()
        return doc
    }

    // Type text at current cursor position
    typeText(text) {
        var sel = _app.get("Selection")
        sel.call("TypeText", text)
        sel.release()
    }

    typeParagraph() {
        var sel = _app.get("Selection")
        sel.call("TypeParagraph")
        sel.release()
    }

    // Save as docx (wdFormatXMLDocument = 12)
    static saveAs(doc, path) { doc.call("SaveAs2", path, 12) }

    // Save as PDF (wdFormatPDF = 17)
    static saveAsPDF(doc, path) { doc.call("SaveAs2", path, 17) }

    // Close without saving
    static close(doc) { doc.call("Close", 0) }

    quit() {
        _app.call("Quit")
        _app.release()
    }
}
