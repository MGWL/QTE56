// fso.wren — Scripting.FileSystemObject wrapper
// Usage: import "fso" for FSO

import "ole" for OleObject

class FSO {
    construct new() {
        _obj = OleObject.create("Scripting.FileSystemObject")
        if (_obj.isNull) Fiber.abort("Cannot create FSO: %(OleObject.lastError)")
    }

    // Path operations
    getExtension(path)  { _obj.call("GetExtensionName", path) }
    getBaseName(path)   { _obj.call("GetBaseName", path) }
    getFileName(path)   { _obj.call("GetFileName", path) }
    getParent(path)     { _obj.call("GetParentFolderName", path) }
    getDrive(path)      { _obj.call("GetDriveName", path) }
    buildPath(a, b)     { _obj.call("BuildPath", a, b) }
    getTempName()       { _obj.call("GetTempName") }

    // Existence checks
    fileExists(path)    { _obj.call("FileExists", path) }
    folderExists(path)  { _obj.call("FolderExists", path) }
    driveExists(drive)  { _obj.call("DriveExists", drive) }

    // File operations
    copyFile(src, dst)    { _obj.call("CopyFile", src, dst) }
    moveFile(src, dst)    { _obj.call("MoveFile", src, dst) }
    deleteFile(path)      { _obj.call("DeleteFile", path) }

    // Folder operations
    createFolder(path)    { _obj.call("CreateFolder", path) }
    deleteFolder(path)    { _obj.call("DeleteFolder", path) }

    // File info
    getFileSize(path) {
        var f = _obj.call("GetFile", path)
        var sz = f.get("Size")
        f.release()
        return sz
    }

    // Read/write text
    readText(path) {
        var stream = _obj.call("OpenTextFile", path, 1)
        var text = stream.call("ReadAll")
        stream.call("Close")
        stream.release()
        return text
    }

    writeText(path, content) {
        var stream = _obj.call("CreateTextFile", path, true)
        stream.call("Write", content)
        stream.call("Close")
        stream.release()
    }

    release() { _obj.release() }
}
