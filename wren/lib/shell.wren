// shell.wren — WScript.Shell wrapper
// Usage: import "shell" for Shell

import "ole" for OleObject

class Shell {
    construct new() {
        _obj = OleObject.create("WScript.Shell")
        if (_obj.isNull) Fiber.abort("Cannot create WScript.Shell: %(OleObject.lastError)")
    }

    // Run a command. style: 0=hide,1=normal,10=default. wait: true/false
    run(cmd)              { _obj.call("Run", cmd) }
    run(cmd, style)       { _obj.call("Run", cmd, style) }
    run(cmd, style, wait) { _obj.call("Run", cmd, style, wait) }

    // Execute and capture output via Exec
    exec(cmd) {
        var proc = _obj.call("Exec", cmd)
        return proc
    }

    // Read stdout from Exec result
    static readStdOut(proc) {
        var stdout = proc.get("StdOut")
        var text = stdout.call("ReadAll")
        stdout.release()
        return text
    }

    // Read stderr from Exec result
    static readStdErr(proc) {
        var stderr = proc.get("StdErr")
        var text = stderr.call("ReadAll")
        stderr.release()
        return text
    }

    // Get exit code from Exec result
    static exitCode(proc) { proc.get("ExitCode") }

    // Environment variables
    expandEnvironment(str) { _obj.call("ExpandEnvironmentStrings", str) }

    // Special folders
    specialFolder(name) { _obj.call("SpecialFolders", name) }

    // Registry
    regRead(key)        { _obj.call("RegRead", key) }
    regWrite(key, val)  { _obj.call("RegWrite", key, val) }
    regWrite(key, val, type) { _obj.call("RegWrite", key, val, type) }
    regDelete(key)      { _obj.call("RegDelete", key) }

    // Create shortcut
    createShortcut(path) { _obj.call("CreateShortcut", path) }

    // Current directory
    currentDirectory     { _obj.get("CurrentDirectory") }
    currentDirectory=(v) { _obj.set("CurrentDirectory", v) }

    // Popup (msgbox-like)
    popup(text)                  { _obj.call("Popup", text) }
    popup(text, sec)             { _obj.call("Popup", text, sec) }
    popup(text, sec, title)      { _obj.call("Popup", text, sec, title) }
    popup(text, sec, title, typ) { _obj.call("Popup", text, sec, title, typ) }

    // Send keys to active window
    sendKeys(keys)       { _obj.call("SendKeys", keys) }
    sendKeys(keys, wait) { _obj.call("SendKeys", keys, wait) }

    // AppActivate
    appActivate(title) { _obj.call("AppActivate", title) }

    release() { _obj.release() }
}
