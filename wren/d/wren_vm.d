/**
 * wren_vm.d — D-биндинги для wren_bridge.dll
 *
 * Загружает DLL динамически (LoadLibrary), предоставляет класс WrenVM.
 *
 * Пример:
 *   LoadWren();
 *   auto vm = new WrenVM();
 *   vm.interpret("main", `System.print("hello")`);
 *   vm.loadFile("logic.wren");
 *   vm.call("main", "Handler", "onButtonClick()");
 *   vm.free();
 */
module wren_vm;

import std.conv  : to;
import std.string : fromStringz, toStringz;

// ─── Callback types ───────────────────────────────────────────────────────────

/// Callback вывода текста от Wren (System.print, Logger.print)
alias WrenWriteCb = extern(C) void function(const(char)* text, int len, void* ud);
/// Callback ошибок компиляции/рантайма
alias WrenErrorCb = extern(C) void function(const(char)* msg, int len, void* ud);

// ─── Platform-specific DLL loading ───────────────────────────────────────────

version(Windows) {
    import core.sys.windows.windows : LoadLibraryW, GetProcAddress, FreeLibrary, HMODULE;
    private __gshared HMODULE _dll;
    private void* _sym(string name) {
        auto p = GetProcAddress(_dll, name.toStringz);
        if (!p) throw new Exception("wren_bridge: missing symbol " ~ name);
        return p;
    }
} else {
    import core.sys.posix.dlfcn : dlopen, dlsym, dlclose, RTLD_LAZY;
    private __gshared void* _dll;
    private void* _sym(string name) {
        auto p = dlsym(_dll, name.toStringz);
        if (!p) throw new Exception("wren_bridge: missing symbol " ~ name);
        return p;
    }
}

// ─── DLL function pointers ────────────────────────────────────────────────────

private __gshared extern(C) {
    // Inspector panel setters (winsp_* exported from wren_inspector_glue)
    void function(void*) _winsp_setMonitorWidget;
    void function(void*) _winsp_setConsoleWidget;
    // Named pointer registry
    void function(const(char)*, void*) _winsp_registerPointer;
    void function(const(char)*)        _winsp_unregisterPointer;
    void function()                    _winsp_clearPointers;
}

private __gshared extern(C) {
    void* function(WrenWriteCb, WrenErrorCb, void*) _create;
    void  function(void*) _free;
    int   function(void*, const(char)*, const(char)*) _interpret;
    int   function(void*, const(char)*, const(char)*) _loadFile;  // UTF-8 (cross-platform)
    void  function(void*, const(char)*, void*) _setWidget;
    void  function(void*) _clearWidgets;
    void  function(void*, const(char)*) _addLibPath;
    void  function(void*, int, double) _argDouble;
    void  function(void*, int, const(char)*) _argString;
    void  function(void*, int, int) _argBool;
    int   function(void*, const(char)*, const(char)*, const(char)*) _call;
    int         function(void*) _resultType;
    double      function(void*) _resultDouble;
    int         function(void*) _resultBool;
    const(char)* function(void*) _resultString;
    int   function(void*, const(char)*, const(char)*) _hasVariable;
}

/// Загрузить wren_bridge.dll / libwren_bridge.so. Вызвать один раз до создания WrenVM.
void LoadWren(string dllPath = null) {
    version(Windows) {
        import std.utf : toUTF16z;
        import std.file : exists;
        if (dllPath is null) dllPath = "./dll/wren_bridge.dll";
        // Fallback на архитектурную папку (как у LoadQt): ./dll/dll32 или ./dll/dll64
        if (!exists(dllPath)) {
            import std.process : environment;
            immutable arch = environment.get("QTE56_ARCH", "");
            immutable sub  = (arch == "win64_qt6") ? "dll64" : "dll32";
            immutable alt  = "./dll/" ~ sub ~ "/wren_bridge.dll";
            if (exists(alt)) dllPath = alt;
        }
        _dll = LoadLibraryW(dllPath.toUTF16z);
    } else {
        import std.file : exists;
        // Если путь не существует (например передан Windows-путь "./dll/...dll")
        // — строим Posix-путь: ./lib/libXXX.so (Linux) или ./lib/libXXX.dylib (macOS)
        if (dllPath is null || !exists(dllPath)) {
            import std.path : baseName, stripExtension;
            string base = dllPath is null ? "wren_bridge"
                                          : stripExtension(baseName(dllPath));
            version(OSX)
                dllPath = "./lib/lib" ~ base ~ ".dylib";
            else
                dllPath = "./lib/lib" ~ base ~ ".so";
        }
        _dll = dlopen(dllPath.toStringz, RTLD_LAZY);
    }
    if (!_dll) throw new Exception("Cannot load wren_bridge: " ~ dllPath);

    T sym(T)(string name) { return cast(T)_sym(name); }
    // Inspector setters — optional (old dll without them is still usable)
    try { _winsp_setMonitorWidget  = sym!(typeof(_winsp_setMonitorWidget)) ("winsp_setMonitorWidget");  } catch(Exception) {}
    try { _winsp_setConsoleWidget  = sym!(typeof(_winsp_setConsoleWidget)) ("winsp_setConsoleWidget");  } catch(Exception) {}
    try { _winsp_registerPointer   = sym!(typeof(_winsp_registerPointer))  ("winsp_registerPointer");   } catch(Exception) {}
    try { _winsp_unregisterPointer = sym!(typeof(_winsp_unregisterPointer))("winsp_unregisterPointer"); } catch(Exception) {}
    try { _winsp_clearPointers     = sym!(typeof(_winsp_clearPointers))    ("winsp_clearPointers");     } catch(Exception) {}
    _create      = sym!(typeof(_create))      ("wrenBridge_create");
    _free        = sym!(typeof(_free))        ("wrenBridge_free");
    _interpret   = sym!(typeof(_interpret))   ("wrenBridge_interpret");
    _loadFile    = sym!(typeof(_loadFile))    ("wrenBridge_loadFileUtf8");
    _setWidget   = sym!(typeof(_setWidget))   ("wrenBridge_setWidget");
    _clearWidgets= sym!(typeof(_clearWidgets))("wrenBridge_clearWidgets");
    _addLibPath  = sym!(typeof(_addLibPath))  ("wrenBridge_addLibPath");
    _argDouble   = sym!(typeof(_argDouble))   ("wrenBridge_argDouble");
    _argString   = sym!(typeof(_argString))   ("wrenBridge_argString");
    _argBool     = sym!(typeof(_argBool))     ("wrenBridge_argBool");
    _call        = sym!(typeof(_call))        ("wrenBridge_call");
    _resultType  = sym!(typeof(_resultType))  ("wrenBridge_resultType");
    _resultDouble= sym!(typeof(_resultDouble))("wrenBridge_resultDouble");
    _resultBool  = sym!(typeof(_resultBool))  ("wrenBridge_resultBool");
    _resultString= sym!(typeof(_resultString))("wrenBridge_resultString");
    _hasVariable = sym!(typeof(_hasVariable)) ("wrenBridge_hasVariable");
}

// ─── Default callbacks ────────────────────────────────────────────────────────

extern(C) private void defaultWrite(const(char)* text, int len, void* ud) {
    import std.stdio : write;
    import std.string : fromStringz;
    write(fromStringz(text));
}
extern(C) private void defaultError(const(char)* msg, int len, void* ud) {
    import std.stdio : writeln;
    import std.string : fromStringz;
    writeln("[wren error] ", fromStringz(msg));
}

// ─── WrenVM class ─────────────────────────────────────────────────────────────

class WrenVM {
    private void* _br;   // WrenBridge*

    /// Создать VM. writeCb/errorCb = null → вывод в stdout/stderr.
    this(WrenWriteCb writeCb = null, WrenErrorCb errorCb = null, void* ud = null) {
        _br = _create(
            writeCb ? writeCb : &defaultWrite,
            errorCb ? errorCb : &defaultError,
            ud);
        if (!_br) throw new Exception("wrenBridge_create failed");
    }

    /// Освободить VM.
    void free() {
        if (_br) { _free(_br); _br = null; }
    }
    ~this() { free(); }

    // ── Запуск кода ──────────────────────────────────────────────────────────

    /// Интерпретировать строку Wren-кода. Возвращает 0=ok, 1=compile, 2=runtime.
    int interpret(string module_, string source) {
        return _interpret(_br, module_.toStringz, source.toStringz);
    }

    /// Загрузить и интерпретировать файл (UTF-8 путь). Возвращает 0=ok, 1=compile, 2=runtime.
    int loadFile(string path, string module_ = "main") {
        return _loadFile(_br, module_.toStringz, path.toStringz);
    }

    // ── Реестр виджетов ──────────────────────────────────────────────────────

    /// Зарегистрировать Qt-виджет под именем (Wren видит его через Widgets.get("name")).
    void setWidget(string name, void* wh) {
        _setWidget(_br, name.toStringz, wh);
    }
    /// Очистить реестр виджетов.
    void clearWidgets() { _clearWidgets(_br); }

    /// Добавить директорию для поиска .wren модулей (import "foo" → <path>/foo.wren).
    void addLibPath(string path) { _addLibPath(_br, path.toStringz); }

    // ── Вызов Wren из D ──────────────────────────────────────────────────────

    /// Установить числовой аргумент для следующего call (слот ≥ 1).
    void argDouble(int slot, double val)  { _argDouble(_br, slot, val); }
    /// Установить строковый аргумент (UTF-8).
    void argString(int slot, string val)  { _argString(_br, slot, val.toStringz); }
    /// Установить булев аргумент.
    void argBool(int slot, bool val)      { _argBool(_br, slot, val ? 1 : 0); }

    /// Вызвать статический метод класса. Возвращает 0=ok, 1=compile, 2=runtime.
    /// sig — сигнатура Wren, напр. "onButtonClick()" или "compute(_,_)".
    int call(string module_, string className, string sig) {
        return _call(_br, module_.toStringz, className.toStringz, sig.toStringz);
    }

    // ── Чтение результата ────────────────────────────────────────────────────

    /// Тип последнего результата: 0=num, 1=bool, 2=str, 3=null, 4=other.
    int    resultType()   { return _resultType(_br); }
    double resultDouble() { return _resultDouble(_br); }
    bool   resultBool()   { return _resultBool(_br) != 0; }
    string resultString() { return fromStringz(_resultString(_br)).idup; }

    /// Удобный метод: вызвать и вернуть строку (или "" при ошибке).
    string callStr(string module_, string className, string sig) {
        if (call(module_, className, sig) != 0) return "";
        return resultType() == 2 ? resultString() : "";
    }
    /// Вызвать и вернуть число.
    double callNum(string module_, string className, string sig) {
        if (call(module_, className, sig) != 0) return 0;
        return resultType() == 0 ? resultDouble() : 0;
    }
    /// Вызвать и вернуть bool.
    bool callBool(string module_, string className, string sig) {
        if (call(module_, className, sig) != 0) return false;
        return resultType() == 1 ? resultBool() : false;
    }

    // ── Прочее ───────────────────────────────────────────────────────────────

    /// Проверить наличие переменной/класса в модуле.
    bool hasVariable(string module_, string name) {
        return _hasVariable(_br, module_.toStringz, name.toStringz) != 0;
    }

    /// Внутренний указатель (для отладки).
    void* handle() { return _br; }

    // ── Inspector панели ─────────────────────────────────────────────────────

    /// Подключить QPlainTextEdit как Monitor-панель (лог D-кода).
    static void setMonitorWidget(void* plainTextEdit) {
        if (_winsp_setMonitorWidget) _winsp_setMonitorWidget(plainTextEdit);
    }
    /// Подключить QPlainTextEdit как Console-панель (REPL-вывод).
    static void setConsoleWidget(void* plainTextEdit) {
        if (_winsp_setConsoleWidget) _winsp_setConsoleWidget(plainTextEdit);
    }

    // ── Named pointer registry ────────────────────────────────────────────────

    /// Зарегистрировать указатель под именем — доступен из Wren как
    /// Inspector.namedPtr("name") → Num-адрес.
    static void registerPointer(string name, void* ptr) {
        import std.string : toStringz;
        if (_winsp_registerPointer) _winsp_registerPointer(name.toStringz, ptr);
    }

    /// Удалить регистрацию по имени.
    static void unregisterPointer(string name) {
        import std.string : toStringz;
        if (_winsp_unregisterPointer) _winsp_unregisterPointer(name.toStringz);
    }

    /// Очистить все зарегистрированные указатели.
    static void clearPointers() {
        if (_winsp_clearPointers) _winsp_clearPointers();
    }
}
