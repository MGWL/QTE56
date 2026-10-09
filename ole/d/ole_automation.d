/**
 * ole_automation.d — D bindings for ole_helper.dll (COM/OLE Automation)
 * Standalone module — no QTE56/pFunQt dependency.
 *
 * All method/property names passed as D strings (UTF-8).
 * Conversion to wchar_t* done in the C shim.
 */
module ole_automation;

import core.sys.windows.windows : LoadLibraryA, GetProcAddress, FreeLibrary,
                                   HMODULE;
import core.thread : Thread;
import core.time : msecs;
import std.string : toStringz;
import std.conv : to;

// ── OleVariant (matches C ole_variant_t / VARIANT layout, 16 bytes on 32-bit) ──

struct OleVariant {
    align(1):
    ushort    vt;
    ushort[3] _reserved;
    union {
        int    intVal;
        double dblVal;
        void*  ptrVal;
        short  boolVal;
    }

    enum : ushort {
        VT_EMPTY    = 0,
        VT_I4       = 3,
        VT_R8       = 5,
        VT_DATE     = 7,
        VT_BSTR     = 8,
        VT_DISPATCH = 9,
        VT_BOOL     = 11,
    }

    static OleVariant fromInt(int v) {
        OleVariant r;
        pVarSetInt(&r, v);
        return r;
    }

    static OleVariant fromDouble(double v) {
        OleVariant r;
        pVarSetDouble(&r, v);
        return r;
    }

    static OleVariant fromString(string s) {
        OleVariant r;
        pVarSetString(&r, toStringz(s));
        return r;
    }

    static OleVariant fromBool(bool v) {
        OleVariant r;
        pVarSetBool(&r, v ? 1 : 0);
        return r;
    }

    static OleVariant fromDate(double v) {
        OleVariant r;
        pVarSetDate(&r, v);
        return r;
    }

    static OleVariant fromDispatch(void* p) {
        OleVariant r;
        pVarSetDispatch(&r, p);
        return r;
    }

    static OleVariant empty() {
        OleVariant r;
        pVarInit(&r);
        return r;
    }

    void clear() {
        pVarClear(&this);
    }

    ushort type() const {
        return vt;
    }

    int asInt() {
        return pVarGetInt(&this);
    }

    double asDouble() {
        return pVarGetDouble(&this);
    }

    string asString() {
        char[2048] buf;
        int len = pVarGetString(&this, buf.ptr, 2048);
        if (len <= 0) return "";
        if (len >= 2048) len = 2047;  // Safety clamp
        return buf[0 .. len].idup;
    }

    void* asDispatch() {
        return pVarGetDispatch(&this);
    }

    bool asBool() {
        return pVarGetBool(&this) != 0;
    }

    double asDate() {
        return pVarGetDate(&this);
    }
}

static assert(OleVariant.sizeof == 16, "OleVariant must be 16 bytes (VARIANT layout)");

// ── Busy-retry: повторы при временной занятости COM-сервера ──
//
// COM-вызов синхронен, но сервер (Excel) имеет право ОТКЛОНИТЬ вызов, когда занят:
// режим редактирования ячейки, модальный диалог, пересчёт, старт процесса.
// В этом случае возвращается один из HRESULT'ов ниже. Отказ временный —
// через десятки-сотни миллисекунд сервер снова принимает вызовы.
// Правильная реакция — повторить вызов после короткой паузы (аналог
// IMessageFilter::RetryRejectedCall, который делает это за VBA/VBS/.NET).

/// HRESULT'ы «сервер занят» — временный отказ, вызов следует повторить.
enum : int {
    RPC_E_CALL_REJECTED         = cast(int)0x80010001,  /// сервер отклонил вызов (занят)
    RPC_E_SERVERCALL_RETRYLATER = cast(int)0x8001010A,  /// сервер просит повторить позже
    VBA_E_IGNORE                = cast(int)0x800AC472,  /// Excel/VBA игнорирует вызов (занят)
}

/// true, если HRESULT означает временную занятость сервера (вызов можно повторить).
bool isBusyHresult(int hr) {
    return hr == RPC_E_CALL_REJECTED
        || hr == RPC_E_SERVERCALL_RETRYLATER
        || hr == VBA_E_IGNORE;
}

/// Логгер повторов: (номер попытки, HRESULT). Устанавливается oleSetRetryLogger.
alias OleRetryLogger = void delegate(int attempt, int hr);

private __gshared int g_busyMaxRetries  = 50;   // 50 × 100 мс = до ~5 с ожидания
private __gshared int g_busyRetryDelayMs = 100;
private __gshared OleRetryLogger g_retryLogger;

/// Настроить busy-retry: maxRetries повторов с паузой delayMs между ними.
/// maxRetries = 0 — повторы отключены (первое же «сервер занят» бросает исключение).
void oleSetBusyRetry(int maxRetries, int delayMs = 100) {
    g_busyMaxRetries  = maxRetries;
    g_busyRetryDelayMs = delayMs;
}

/// Прочитать текущие настройки busy-retry.
void oleGetBusyRetry(out int maxRetries, out int delayMs) {
    maxRetries = g_busyMaxRetries;
    delayMs    = g_busyRetryDelayMs;
}

/// Установить логгер повторов (для диагностики гонок). null — отключить.
void oleSetRetryLogger(OleRetryLogger logger) {
    g_retryLogger = logger;
}

/// Выполнить COM-операцию с повторами при занятости сервера.
/// op() возвращает HRESULT: >= 0 — успех, busy-HRESULT — повтор, прочие — выход.
/// Возвращает последний HRESULT (вызывающий код сам бросает исключение с контекстом).
private int oleRetryHresult(int delegate() op) {
    int attempt = 0;
    for (;;) {
        int hr = op();
        if (hr >= 0 || !isBusyHresult(hr)) return hr;
        if (attempt >= g_busyMaxRetries) return hr;
        attempt++;
        if (g_retryLogger !is null) g_retryLogger(attempt, hr);
        Thread.sleep(msecs(g_busyRetryDelayMs));
    }
}

/// Хвост сообщения об ошибке: для busy-HRESULT — понятное пояснение.
private string busyNote(int hr) {
    if (!isBusyHresult(hr)) return "";
    return " — сервер занят (RPC_E_CALL_REJECTED), повторы исчерпаны (" ~
           to!string(g_busyMaxRetries) ~ "×" ~ to!string(g_busyRetryDelayMs) ~ " мс)";
}

// ── OleObject — wraps IDispatch* ──

class OleObject {
private:
    void* _pDisp;

public:
    /// Create COM object by ProgID (e.g. "Excel.Application")
    this(string progid) {
        // Сервер может отклонять CoCreateInstance в момент собственного старта —
        // повторяем, пока HRESULT означает «занят» (busy-retry).
        int attempt = 0;
        for (;;) {
            _pDisp = pOleCreate(toStringz(progid));
            if (_pDisp !is null) break;
            int hr = lastHresult();
            if (!isBusyHresult(hr) || attempt >= g_busyMaxRetries) {
                throw new Exception("Cannot create COM object: " ~ progid ~ " — " ~
                                    lastError() ~ busyNote(hr));
            }
            attempt++;
            if (g_retryLogger !is null) g_retryLogger(attempt, hr);
            Thread.sleep(msecs(g_busyRetryDelayMs));
        }
    }

    /// Wrap existing IDispatch* (from property get)
    this(void* pDisp) {
        _pDisp = pDisp;
    }

    /// Attach to a running COM instance (GetActiveObject).
    /// Returns null if no instance is running (see lastError() for details).
    static OleObject attachActive(string progid) {
        auto p = pOleGetActive(toStringz(progid));
        if (p is null) return null;
        return new OleObject(p);
    }

    /// Attach to a running instance; create a new one if not running.
    /// (Equivalent of VBS: GetObject → fallback CreateObject)
    static OleObject attachOrCreate(string progid) {
        auto obj = attachActive(progid);
        if (obj !is null) return obj;
        return new OleObject(progid);
    }

    ~this() {
        if (_pDisp !is null && g_loaded) {
            pOleRelease(_pDisp);
            _pDisp = null;
        }
    }

    void release() {
        if (_pDisp !is null && g_loaded) {
            pOleRelease(_pDisp);
            _pDisp = null;
        }
    }

    void* handle() { return _pDisp; }

    // ── Property Get ──

    OleVariant get(string prop) {
        OleVariant result;
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({
            pVarInit(&result);
            return pOleGetProp(_pDisp, cname, null, 0, &result);
        });
        if (hr < 0)
            throw new Exception("get('" ~ prop ~ "') failed: " ~ lastError() ~ busyNote(hr));
        return result;
    }

    OleVariant get(string prop, OleVariant[] args...) {
        OleVariant result;
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({
            pVarInit(&result);
            return pOleGetProp(_pDisp, cname, args.ptr, cast(int) args.length, &result);
        });
        if (hr < 0)
            throw new Exception("get('" ~ prop ~ "') failed: " ~ lastError() ~ busyNote(hr));
        return result;
    }

    int getInt(string prop) { return get(prop).asInt(); }
    double getDouble(string prop) { return get(prop).asDouble(); }
    string getString(string prop) {
        auto v = get(prop);
        scope(exit) v.clear();   // освобождаем BSTR результата
        return v.asString();
    }
    bool getBool(string prop) { return get(prop).asBool(); }

    OleObject getObject(string prop) {
        auto v = get(prop);
        auto p = v.asDispatch();
        if (p is null)
            throw new Exception("getObject('" ~ prop ~ "') returned null");
        return new OleObject(p);
    }

    OleObject getObject(string prop, OleVariant[] args...) {
        auto v = get(prop, args);
        auto p = v.asDispatch();
        if (p is null)
            throw new Exception("getObject('" ~ prop ~ "') returned null");
        return new OleObject(p);
    }

    // ── Property Set ──

    void set(string prop, int val) {
        auto v = OleVariant.fromInt(val);
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({ return pOleSetProp(_pDisp, cname, &v, 1); });
        if (hr < 0)
            throw new Exception("set('" ~ prop ~ "', int) failed: " ~ lastError() ~ busyNote(hr));
    }

    void set(string prop, double val) {
        auto v = OleVariant.fromDouble(val);
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({ return pOleSetProp(_pDisp, cname, &v, 1); });
        if (hr < 0)
            throw new Exception("set('" ~ prop ~ "', double) failed: " ~ lastError() ~ busyNote(hr));
    }

    void set(string prop, string val) {
        auto v = OleVariant.fromString(val);
        scope(exit) v.clear();
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({ return pOleSetProp(_pDisp, cname, &v, 1); });
        if (hr < 0)
            throw new Exception("set('" ~ prop ~ "', string) failed: " ~ lastError() ~ busyNote(hr));
    }

    void set(string prop, bool val) {
        auto v = OleVariant.fromBool(val);
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({ return pOleSetProp(_pDisp, cname, &v, 1); });
        if (hr < 0)
            throw new Exception("set('" ~ prop ~ "', bool) failed: " ~ lastError() ~ busyNote(hr));
    }

    void set(string prop, OleVariant val) {
        auto cname = toStringz(prop);
        int hr = oleRetryHresult({ return pOleSetProp(_pDisp, cname, &val, 1); });
        if (hr < 0)
            throw new Exception("set('" ~ prop ~ "', variant) failed: " ~ lastError() ~ busyNote(hr));
    }

    // ── Method Call ──

    OleVariant call(string method, OleVariant[] args...) {
        OleVariant result;
        auto cname = toStringz(method);
        int hr = oleRetryHresult({
            pVarInit(&result);
            return pOleInvoke(_pDisp, cname, 1 /*DISPATCH_METHOD*/, args.ptr,
                              cast(int) args.length, &result);
        });
        if (hr < 0)
            throw new Exception("call('" ~ method ~ "') failed: " ~ lastError() ~ busyNote(hr));
        return result;
    }

    void callVoid(string method, OleVariant[] args...) {
        auto cname = toStringz(method);
        int hr = oleRetryHresult({
            return pOleInvoke(_pDisp, cname, 1 /*DISPATCH_METHOD*/, args.ptr,
                              cast(int) args.length, null);
        });
        if (hr < 0)
            throw new Exception("callVoid('" ~ method ~ "') failed: " ~ lastError() ~ busyNote(hr));
    }

    OleObject callObject(string method, OleVariant[] args...) {
        auto v = call(method, args);
        auto p = v.asDispatch();
        if (p is null)
            throw new Exception("callObject('" ~ method ~ "') returned null");
        return new OleObject(p);
    }

    string callString(string method, OleVariant[] args...) {
        auto v = call(method, args);
        auto s = v.asString();
        v.clear();
        return s;
    }

    int callInt(string method, OleVariant[] args...) {
        return call(method, args).asInt();
    }

    // ── Enumeration (_NewEnum / For Each) ──

    /// Begin enumeration over a COM collection. Throws on failure.
    OleEnum beginEnum() {
        // ole_enum_begin возвращает NULL вместо HRESULT — смотрим lastHresult().
        int attempt = 0;
        for (;;) {
            auto p = pOleEnumBegin(_pDisp);
            if (p !is null) return new OleEnum(p);
            int hr = lastHresult();
            if (!isBusyHresult(hr) || attempt >= g_busyMaxRetries) {
                throw new Exception("beginEnum() failed: " ~ lastError() ~ busyNote(hr));
            }
            attempt++;
            if (g_retryLogger !is null) g_retryLogger(attempt, hr);
            Thread.sleep(msecs(g_busyRetryDelayMs));
        }
    }

    /// Collect all VT_DISPATCH items of a collection as OleObject[].
    OleObject[] collectObjects() {
        OleObject[] result;
        auto en = beginEnum();
        scope(exit) en.release();
        OleVariant v;
        while (en.next(v)) {
            if (v.type == OleVariant.VT_DISPATCH) {
                auto p = v.asDispatch();
                if (p !is null) {
                    result ~= new OleObject(p);  // takes ownership of the reference
                } else {
                    v.clear();
                }
            } else {
                v.clear();
            }
        }
        return result;
    }
}

// ── OleEnum — wraps IEnumVARIANT* (For Each) ──

class OleEnum {
private:
    void* _pEnum;

public:
    this(void* pEnum) {
        _pEnum = pEnum;
    }

    ~this() {
        release();
    }

    /// Fetch next item. Returns false at the end of enumeration.
    /// Caller must clear() the variant when done (if it holds a resource).
    bool next(out OleVariant v) {
        if (_pEnum is null) {
            v = OleVariant.empty();
            return false;
        }
        return pOleEnumNext(_pEnum, &v) != 0;
    }

    void release() {
        if (_pEnum !is null && g_loaded) {
            pOleEnumRelease(_pEnum);
            _pEnum = null;
        }
    }
}

// ── DLL Loading (standalone, no pFunQt) ──

private alias fp_int_void     = extern(C) int function();
private alias fp_void_void    = extern(C) void function();
private alias fp_create       = extern(C) void* function(const(char)*);
private alias fp_get_active   = extern(C) void* function(const(char)*);
private alias fp_release      = extern(C) void function(void*);
private alias fp_invoke       = extern(C) int function(void*, const(char)*, int,
                                                        OleVariant*, int, OleVariant*);
private alias fp_get_prop     = extern(C) int function(void*, const(char)*,
                                                        OleVariant*, int, OleVariant*);
private alias fp_set_prop     = extern(C) int function(void*, const(char)*,
                                                        OleVariant*, int);
private alias fp_var_init     = extern(C) void function(OleVariant*);
private alias fp_var_clear    = extern(C) void function(OleVariant*);
private alias fp_var_set_int  = extern(C) void function(OleVariant*, int);
private alias fp_var_set_dbl  = extern(C) void function(OleVariant*, double);
private alias fp_var_set_str  = extern(C) void function(OleVariant*, const(char)*);
private alias fp_var_set_disp = extern(C) void function(OleVariant*, void*);
private alias fp_var_set_bool = extern(C) void function(OleVariant*, int);
private alias fp_var_set_date = extern(C) void function(OleVariant*, double);
private alias fp_var_set_empt = extern(C) void function(OleVariant*);
private alias fp_var_get_type = extern(C) ushort function(const(OleVariant)*);
private alias fp_var_get_int  = extern(C) int function(const(OleVariant)*);
private alias fp_var_get_dbl  = extern(C) double function(const(OleVariant)*);
private alias fp_var_get_str  = extern(C) int function(const(OleVariant)*, char*, int);
private alias fp_var_get_disp = extern(C) void* function(const(OleVariant)*);
private alias fp_var_get_bool = extern(C) int function(const(OleVariant)*);
private alias fp_var_get_date = extern(C) double function(const(OleVariant)*);
private alias fp_enum_begin   = extern(C) void* function(void*);
private alias fp_enum_next    = extern(C) int function(void*, OleVariant*);
private alias fp_enum_release = extern(C) void function(void*);
private alias fp_last_error   = extern(C) const(char)* function();
private alias fp_last_hr      = extern(C) int function();

private __gshared HMODULE g_dll;
/*package*/ __gshared bool    g_loaded = false;

private __gshared fp_int_void     pOleInitFn;
private __gshared fp_void_void    pOleUninitFn;
private __gshared fp_create       pOleCreate;
private __gshared fp_get_active   pOleGetActive;
private __gshared fp_release      pOleRelease;
private __gshared fp_invoke       pOleInvoke;
private __gshared fp_get_prop     pOleGetProp;
private __gshared fp_set_prop     pOleSetProp;
private __gshared fp_var_init     pVarInit;
private __gshared fp_var_clear    pVarClear;
private __gshared fp_var_set_int  pVarSetInt;
private __gshared fp_var_set_dbl  pVarSetDouble;
private __gshared fp_var_set_str  pVarSetString;
private __gshared fp_var_set_disp pVarSetDispatch;
private __gshared fp_var_set_bool pVarSetBool;
private __gshared fp_var_set_date pVarSetDate;
private __gshared fp_var_set_empt pVarSetEmpty;
private __gshared fp_var_get_type pVarGetType;
private __gshared fp_var_get_int  pVarGetInt;
private __gshared fp_var_get_dbl  pVarGetDouble;
private __gshared fp_var_get_str  pVarGetString;
private __gshared fp_var_get_disp pVarGetDispatch;
private __gshared fp_var_get_bool pVarGetBool;
private __gshared fp_var_get_date pVarGetDate;
private __gshared fp_enum_begin   pOleEnumBegin;
private __gshared fp_enum_next    pOleEnumNext;
private __gshared fp_enum_release pOleEnumRelease;
private __gshared fp_last_error   pLastError;
private __gshared fp_last_hr      pLastHR;

private T loadSym(T)(HMODULE dll, const(char)* name) {
    auto p = GetProcAddress(dll, name);
    if (p is null)
        throw new Exception("GetProcAddress failed: " ~ to!string(cast(const(char)*)name));
    return cast(T) p;
}

/// Load ole_helper.dll. Idempotent.
void loadOleHelper(string path = "ole_helper.dll") {
    if (g_loaded) return;

    g_dll = LoadLibraryA(toStringz(path));
    if (g_dll is null)
        throw new Exception("Cannot load " ~ path);

    pOleInitFn    = loadSym!fp_int_void    (g_dll, "ole_init");
    pOleUninitFn  = loadSym!fp_void_void   (g_dll, "ole_uninit");
    pOleCreate    = loadSym!fp_create      (g_dll, "ole_create_object");
    pOleGetActive = loadSym!fp_get_active  (g_dll, "ole_get_active_object");
    pOleRelease   = loadSym!fp_release     (g_dll, "ole_release");
    pOleInvoke    = loadSym!fp_invoke      (g_dll, "ole_invoke");
    pOleGetProp   = loadSym!fp_get_prop    (g_dll, "ole_get_property");
    pOleSetProp   = loadSym!fp_set_prop    (g_dll, "ole_set_property");
    pVarInit      = loadSym!fp_var_init    (g_dll, "ole_var_init");
    pVarClear     = loadSym!fp_var_clear   (g_dll, "ole_var_clear");
    pVarSetInt    = loadSym!fp_var_set_int (g_dll, "ole_var_set_int");
    pVarSetDouble = loadSym!fp_var_set_dbl (g_dll, "ole_var_set_double");
    pVarSetString = loadSym!fp_var_set_str (g_dll, "ole_var_set_string");
    pVarSetDispatch = loadSym!fp_var_set_disp(g_dll, "ole_var_set_dispatch");
    pVarSetBool   = loadSym!fp_var_set_bool(g_dll, "ole_var_set_bool");
    pVarSetDate   = loadSym!fp_var_set_date(g_dll, "ole_var_set_date");
    pVarSetEmpty  = loadSym!fp_var_set_empt(g_dll, "ole_var_set_empty");
    pVarGetType   = loadSym!fp_var_get_type(g_dll, "ole_var_get_type");
    pVarGetInt    = loadSym!fp_var_get_int (g_dll, "ole_var_get_int");
    pVarGetDouble = loadSym!fp_var_get_dbl (g_dll, "ole_var_get_double");
    pVarGetString = loadSym!fp_var_get_str (g_dll, "ole_var_get_string");
    pVarGetDispatch = loadSym!fp_var_get_disp(g_dll, "ole_var_get_dispatch");
    pVarGetBool   = loadSym!fp_var_get_bool(g_dll, "ole_var_get_bool");
    pVarGetDate   = loadSym!fp_var_get_date(g_dll, "ole_var_get_date");
    pOleEnumBegin   = loadSym!fp_enum_begin  (g_dll, "ole_enum_begin");
    pOleEnumNext    = loadSym!fp_enum_next   (g_dll, "ole_enum_next");
    pOleEnumRelease = loadSym!fp_enum_release(g_dll, "ole_enum_release");
    pLastError    = loadSym!fp_last_error  (g_dll, "ole_last_error");
    pLastHR       = loadSym!fp_last_hr     (g_dll, "ole_last_hresult");

    g_loaded = true;
}

/// Unload ole_helper.dll.
void unloadOleHelper() {
    if (g_dll) {
        FreeLibrary(g_dll);
        g_dll = null;
    }
    g_loaded = false;
}

/// Call CoInitializeEx (STA). Throws on failure.
void oleInit() {
    int hr = pOleInitFn();
    if (hr < 0)
        throw new Exception("oleInit failed: " ~ lastError());
}

/// Call CoUninitialize.
void oleUninit() {
    pOleUninitFn();
}

/// Get last error message from C shim (UTF-8).
string lastError() {
    auto p = pLastError();
    if (p is null) return "";
    import core.stdc.string : strlen;
    auto len = strlen(p);
    if (len == 0) return "";
    return p[0 .. len].idup;
}

/// Get last HRESULT from C shim.
int lastHresult() {
    return pLastHR();
}

// ── Unittest: busy-retry (без COM, чистая логика) ──

unittest {
    // isBusyHresult: классификация HRESULT
    assert(isBusyHresult(RPC_E_CALL_REJECTED));          // 0x80010001
    assert(isBusyHresult(RPC_E_SERVERCALL_RETRYLATER));  // 0x8001010A
    assert(isBusyHresult(VBA_E_IGNORE));                 // 0x800AC472
    assert(!isBusyHresult(cast(int)0x80020003));         // DISP_E_MEMBERNOTFOUND
    assert(!isBusyHresult(cast(int)0x80020009));         // DISP_E_EXCEPTION
    assert(!isBusyHresult(cast(int)0x80040154));         // REGDB_E_CLASSNOTREG
    assert(!isBusyHresult(0));                           // S_OK

    // Сохраняем и восстанавливаем глобальные настройки
    int savedMax, savedDelay;
    oleGetBusyRetry(savedMax, savedDelay);
    scope(exit) oleSetBusyRetry(savedMax, savedDelay);

    // oleRetryHresult: busy → успех после N попыток
    oleSetBusyRetry(5, 1);
    int calls = 0;
    int hr = oleRetryHresult({
        calls++;
        return calls < 3 ? RPC_E_CALL_REJECTED : 0;
    });
    assert(hr == 0 && calls == 3);

    // oleRetryHresult: busy дольше лимита → возврат busy-HRESULT
    oleSetBusyRetry(2, 1);
    calls = 0;
    hr = oleRetryHresult({
        calls++;
        return RPC_E_CALL_REJECTED;
    });
    assert(hr == RPC_E_CALL_REJECTED && calls == 3);  // 1 + 2 повтора

    // oleRetryHresult: не-busy ошибка НЕ повторяется
    oleSetBusyRetry(5, 1);
    calls = 0;
    hr = oleRetryHresult({
        calls++;
        return cast(int)0x80020003;  // DISP_E_MEMBERNOTFOUND
    });
    assert(hr == cast(int)0x80020003 && calls == 1);

    // oleRetryHresult: maxRetries=0 — повторы отключены
    oleSetBusyRetry(0, 1);
    calls = 0;
    hr = oleRetryHresult({
        calls++;
        return RPC_E_CALL_REJECTED;
    });
    assert(hr == RPC_E_CALL_REJECTED && calls == 1);

    // oleRetryHresult: логгер получает каждую попытку
    oleSetBusyRetry(3, 1);
    int logged = 0;
    oleSetRetryLogger((int attempt, int h) { logged++; });
    scope(exit) oleSetRetryLogger(null);
    oleRetryHresult({ return RPC_E_SERVERCALL_RETRYLATER; });
    assert(logged == 3);

    // busyNote: текст только для busy-HRESULT
    assert(busyNote(RPC_E_CALL_REJECTED).length > 0);
    assert(busyNote(cast(int)0x80020003).length == 0);
}
