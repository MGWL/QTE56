// outlook.wren — Outlook automation helper
// Usage: import "outlook" for Outlook
// Requires Outlook to be installed.

import "ole" for OleObject

class Outlook {
    // Create new Outlook instance
    construct open() {
        _app = OleObject.create("Outlook.Application")
        if (_app.isNull) Fiber.abort("Cannot create Outlook.Application: %(OleObject.lastError)")
    }

    // Connect to running Outlook
    construct connect() {
        _app = OleObject.connect("Outlook.Application")
        if (_app == null || _app.isNull) Fiber.abort("Cannot connect to Outlook: %(OleObject.lastError)")
    }

    app { _app }

    // Get MAPI namespace
    namespace() {
        return _app.call("GetNamespace", "MAPI")
    }

    // Get default folder by type
    // olFolderInbox=6, olFolderSentMail=5, olFolderOutbox=4,
    // olFolderDrafts=16, olFolderCalendar=9, olFolderContacts=10
    getDefaultFolder(folderType) {
        var ns = namespace()
        var folder = ns.call("GetDefaultFolder", folderType)
        ns.release()
        return folder
    }

    // Create a new mail item (olMailItem = 0)
    createMail() {
        return _app.call("CreateItem", 0)
    }

    // Send a simple email
    sendMail(to, subject, body) {
        var mail = createMail()
        mail.set("To", to)
        mail.set("Subject", subject)
        mail.set("Body", body)
        mail.call("Send")
        mail.release()
    }

    // Send email with HTML body
    sendHtmlMail(to, subject, htmlBody) {
        var mail = createMail()
        mail.set("To", to)
        mail.set("Subject", subject)
        mail.set("HTMLBody", htmlBody)
        mail.call("Send")
        mail.release()
    }

    // Get inbox items count
    inboxCount() {
        var inbox = getDefaultFolder(6)
        var items = inbox.get("Items")
        var count = items.get("Count")
        items.release()
        inbox.release()
        return count
    }

    // Get mail item from folder
    static getItem(folder, index) {
        var items = folder.get("Items")
        var item = items.call("Item", index)
        items.release()
        return item
    }

    // Read mail properties
    static subject(mail) { mail.get("Subject") }
    static body(mail)    { mail.get("Body") }
    static from(mail)    { mail.get("SenderName") }
    static to(mail)      { mail.get("To") }
    static cc(mail)      { mail.get("CC") }
    static receivedTime(mail) { mail.get("ReceivedTime") }

    // Create appointment (olAppointmentItem = 1)
    createAppointment() {
        return _app.call("CreateItem", 1)
    }

    quit() {
        _app.call("Quit")
        _app.release()
    }

    release() {
        _app.release()
    }
}
