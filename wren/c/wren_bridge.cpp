#include "wren_bridge.h"
#include "wren_inspector_glue.h"
extern "C" {
#include "wren.h"
}

#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QAbstractButton>
#include <QGroupBox>
#include <QSpinBox>
#include <QDoubleSpinBox>
#include <QAbstractSlider>
#include <QSlider>
#include <QProgressBar>
#include <QLCDNumber>
#include <QComboBox>
#include <QListWidget>
#include <QWidget>
#include <QFile>

#include <map>
#include <string>
#include <vector>
#include <cstring>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>   // usleep
#include <time.h>     // clock_gettime
#include <stdlib.h>   // getenv
#endif

// ─── Wren module source injected into every VM ────────────────────────────────

static const char* QT_MODULE_SRC = R"(
foreign class Widget {
    construct new(name) {}
    foreign setText(text)
    foreign text
    foreign setValue(n)
    foreign value
    foreign setChecked(b)
    foreign isChecked
    foreign setEnabled(b)
    foreign isEnabled
    foreign setVisible(b)
    foreign isVisible
    foreign addItem(text)
    foreign clearItems()
    foreign count
    foreign currentIndex
    foreign setCurrentIndex(n)
    foreign className
}

class Widgets {
    static get(name) {
        return Widget.new(name)
    }
}

foreign class Logger {
    foreign static print(msg)
    foreign static warn(msg)
}
)";

// ─── OLE module source (Windows only) ────────────────────────────────────────

static const char* OLE_MODULE_SRC = R"(
foreign class OleObject {
    construct create(progid) {}
    foreign get(prop)
    foreign set(prop, val)
    foreign call(method)
    foreign call(method, a)
    foreign call(method, a, b)
    foreign call(method, a, b, c)
    foreign call(method, a, b, c, d)
    foreign call(method, a, b, c, d, e)
    foreign call(method, a, b, c, d, e, f)
    foreign call(method, a, b, c, d, e, f, g)
    foreign call(method, a, b, c, d, e, f, g, h)
    foreign release()
    foreign isNull
    foreign static lastError
    foreign static connect(progid)
    foreign static isAvailable

    // Enumeration support (For Each equivalent)
    foreign enumBegin_()
    foreign enumNext_()
    foreign enumRelease_()

    each(fn) {
        enumBegin_()
        while (true) {
            var item = enumNext_()
            if (item == null) break
            fn.call(item)
        }
        enumRelease_()
    }

    // Convenience: collection count and indexing
    count { get("Count") }
    [index] { call("Item", index) }

    // get + auto-release self (for chaining)
    getR(prop) {
        var r = get(prop)
        release()
        return r
    }

    // call + auto-release self (for chaining, 0..8 args)
    callR(method) {
        var r = call(method)
        release()
        return r
    }
    callR(method, a) {
        var r = call(method, a)
        release()
        return r
    }
    callR(method, a, b) {
        var r = call(method, a, b)
        release()
        return r
    }
    callR(method, a, b, c) {
        var r = call(method, a, b, c)
        release()
        return r
    }
    callR(method, a, b, c, d) {
        var r = call(method, a, b, c, d)
        release()
        return r
    }
    callR(method, a, b, c, d, e) {
        var r = call(method, a, b, c, d, e)
        release()
        return r
    }
    callR(method, a, b, c, d, e, f) {
        var r = call(method, a, b, c, d, e, f)
        release()
        return r
    }
    callR(method, a, b, c, d, e, f, g) {
        var r = call(method, a, b, c, d, e, f, g)
        release()
        return r
    }
    callR(method, a, b, c, d, e, f, g, h) {
        var r = call(method, a, b, c, d, e, f, g, h)
        release()
        return r
    }
}
)";

// ─── IO module source (cross-platform) ───────────────────────────────────────

static const char* IO_MODULE_SRC = R"(
foreign class File {
    foreign static read(path)
    foreign static write(path, content)
    foreign static exists(path)
    foreign static delete(path)
    foreign static size(path)
}
)";

// ─── Sys module source (cross-platform utilities) ───────────────────────────

static const char* SYS_MODULE_SRC = R"(
foreign class Sys {
    foreign static sleep(ms)
    foreign static msgBox(text, title, flags)
    foreign static clock
    foreign static env(name)
}
)";

// ─── wrenNullOle: push a null OleObject into slot 0 (cross-platform) ─────────
// Used by both Windows OLE methods and Linux stubs to return a "null" OleObject
// so that .isNull always works for callers.
// NOTE: requires "ole" module to already be loaded in the VM.
static void wrenNullOle(WrenVM* vm) {
    wrenGetVariable(vm, "ole", "OleObject", 0);
    void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pp = nullptr;
}

// ─── OleObject.isAvailable (cross-platform) ───────────────────────────────────
static void wfn_ole_isAvailable(WrenVM* vm) {
#ifdef _WIN32
    wrenSetSlotBool(vm, 0, true);
#else
    wrenSetSlotBool(vm, 0, false);
#endif
}

// ─── Dynamic ole_helper.dll loading ──────────────────────────────────────────

#ifdef _WIN32

// ole_variant_t mirrors the C struct from ole_helper.h
struct ole_variant_t {
    unsigned short vt;
    unsigned short reserved[3];
    union {
        int     intVal;
        double  dblVal;
        void*   ptrVal;
        short   boolVal;
    };
};

#define OLE_VT_EMPTY     0
#define OLE_VT_I4        3
#define OLE_VT_R8        5
#define OLE_VT_DATE      7
#define OLE_VT_BSTR      8
#define OLE_VT_DISPATCH  9
#define OLE_VT_BOOL     11

// Function pointer types for ole_helper.dll
typedef int   (*pfn_ole_init)(void);
typedef void  (*pfn_ole_uninit)(void);
typedef void* (*pfn_ole_create_object)(const char*);
typedef void* (*pfn_ole_get_active_object)(const char*);
typedef void  (*pfn_ole_release)(void*);
typedef int   (*pfn_ole_invoke)(void*, const char*, int, ole_variant_t*, int, ole_variant_t*);
typedef int   (*pfn_ole_get_property)(void*, const char*, ole_variant_t*, int, ole_variant_t*);
typedef int   (*pfn_ole_set_property)(void*, const char*, ole_variant_t*, int);
typedef void  (*pfn_ole_var_init)(ole_variant_t*);
typedef void  (*pfn_ole_var_clear)(ole_variant_t*);
typedef void  (*pfn_ole_var_set_int)(ole_variant_t*, int);
typedef void  (*pfn_ole_var_set_double)(ole_variant_t*, double);
typedef void  (*pfn_ole_var_set_string)(ole_variant_t*, const char*);
typedef void  (*pfn_ole_var_set_bool)(ole_variant_t*, int);
typedef void  (*pfn_ole_var_set_dispatch)(ole_variant_t*, void*);
typedef unsigned short (*pfn_ole_var_get_type)(const ole_variant_t*);
typedef int    (*pfn_ole_var_get_int)(const ole_variant_t*);
typedef double (*pfn_ole_var_get_double)(const ole_variant_t*);
typedef int    (*pfn_ole_var_get_string)(const ole_variant_t*, char*, int);
typedef void*  (*pfn_ole_var_get_dispatch)(const ole_variant_t*);
typedef int    (*pfn_ole_var_get_bool)(const ole_variant_t*);
typedef const char* (*pfn_ole_last_error)(void);
typedef void*  (*pfn_ole_enum_begin)(void*);
typedef int    (*pfn_ole_enum_next)(void*, ole_variant_t*);
typedef void   (*pfn_ole_enum_release)(void*);

static struct OleFuncs {
    HMODULE hDll;
    bool    loaded;
    bool    initDone;

    pfn_ole_init           init;
    pfn_ole_uninit         uninit;
    pfn_ole_create_object  create_object;
    pfn_ole_get_active_object get_active_object;
    pfn_ole_release        release;
    pfn_ole_invoke         invoke;
    pfn_ole_get_property   get_property;
    pfn_ole_set_property   set_property;
    pfn_ole_var_init       var_init;
    pfn_ole_var_clear      var_clear;
    pfn_ole_var_set_int    var_set_int;
    pfn_ole_var_set_double var_set_double;
    pfn_ole_var_set_string var_set_string;
    pfn_ole_var_set_bool   var_set_bool;
    pfn_ole_var_set_dispatch var_set_dispatch;
    pfn_ole_var_get_type   var_get_type;
    pfn_ole_var_get_int    var_get_int;
    pfn_ole_var_get_double var_get_double;
    pfn_ole_var_get_string var_get_string;
    pfn_ole_var_get_dispatch var_get_dispatch;
    pfn_ole_var_get_bool   var_get_bool;
    pfn_ole_last_error     last_error;
    pfn_ole_enum_begin     enum_begin;
    pfn_ole_enum_next      enum_next;
    pfn_ole_enum_release   enum_release;
} g_ole = {};

static bool oleEnsureLoaded() {
    if (g_ole.loaded) return true;
    g_ole.hDll = LoadLibraryA("ole_helper.dll");
    if (!g_ole.hDll) return false;

    #define LOAD_OLE(name) g_ole.name = (pfn_ole_##name)GetProcAddress(g_ole.hDll, "ole_" #name)
    LOAD_OLE(init);  LOAD_OLE(uninit);
    LOAD_OLE(create_object);  LOAD_OLE(get_active_object);  LOAD_OLE(release);
    LOAD_OLE(invoke);  LOAD_OLE(get_property);  LOAD_OLE(set_property);
    LOAD_OLE(var_init);  LOAD_OLE(var_clear);
    LOAD_OLE(var_set_int);  LOAD_OLE(var_set_double);  LOAD_OLE(var_set_string);
    LOAD_OLE(var_set_bool);  LOAD_OLE(var_set_dispatch);
    LOAD_OLE(var_get_type);  LOAD_OLE(var_get_int);  LOAD_OLE(var_get_double);
    LOAD_OLE(var_get_string);  LOAD_OLE(var_get_dispatch);  LOAD_OLE(var_get_bool);
    LOAD_OLE(last_error);
    LOAD_OLE(enum_begin);  LOAD_OLE(enum_next);  LOAD_OLE(enum_release);
    #undef LOAD_OLE

    if (!g_ole.init || !g_ole.create_object) {
        FreeLibrary(g_ole.hDll);
        g_ole.hDll = nullptr;
        return false;
    }

    g_ole.loaded = true;
    if (!g_ole.initDone) {
        g_ole.init();
        g_ole.initDone = true;
    }
    return true;
}

// Convert Wren slot value → ole_variant_t
static void wrenSlotToVariant(WrenVM* vm, int slot, ole_variant_t* v) {
    g_ole.var_init(v);
    WrenType t = wrenGetSlotType(vm, slot);
    switch (t) {
        case WREN_TYPE_NUM:    g_ole.var_set_double(v, wrenGetSlotDouble(vm, slot)); break;
        case WREN_TYPE_BOOL:   g_ole.var_set_bool(v, wrenGetSlotBool(vm, slot) ? 1 : 0); break;
        case WREN_TYPE_STRING: g_ole.var_set_string(v, wrenGetSlotString(vm, slot)); break;
        case WREN_TYPE_FOREIGN: {
            void** pp = (void**)wrenGetSlotForeign(vm, slot);
            if (pp && *pp) g_ole.var_set_dispatch(v, *pp);
            break;
        }
        default: break;
    }
}

// Push ole_variant_t result → Wren slot 0 (dispatch → new OleObject)
static void variantToWrenSlot(WrenVM* vm, ole_variant_t* v) {
    unsigned short vt = g_ole.var_get_type(v);
    switch (vt) {
        case OLE_VT_I4:
            wrenSetSlotDouble(vm, 0, g_ole.var_get_int(v));
            break;
        case OLE_VT_R8:
        case OLE_VT_DATE:
            wrenSetSlotDouble(vm, 0, g_ole.var_get_double(v));
            break;
        case OLE_VT_BSTR: {
            char buf[4096];
            int len = g_ole.var_get_string(v, buf, sizeof(buf));
            buf[len < (int)sizeof(buf) ? len : (int)sizeof(buf)-1] = '\0';
            wrenSetSlotString(vm, 0, buf);
            break;
        }
        case OLE_VT_BOOL:
            wrenSetSlotBool(vm, 0, g_ole.var_get_bool(v) != 0);
            break;
        case OLE_VT_DISPATCH: {
            void* pDisp = g_ole.var_get_dispatch(v);
            if (pDisp) {
                // Transfer ownership: prevent var_clear from releasing the dispatch
                v->vt = OLE_VT_EMPTY;
                v->ptrVal = nullptr;
                wrenGetVariable(vm, "ole", "OleObject", 0);
                void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
                *pp = pDisp;
            } else {
                wrenNullOle(vm);
            }
            break;
        }
        default:
            wrenNullOle(vm);
            break;
    }
    g_ole.var_clear(v);
}

// ─── OleObject foreign methods ───────────────────────────────────────────────

static void wfn_ole_new(WrenVM* vm) {
    void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pp = nullptr;
    if (!oleEnsureLoaded()) return;
    const char* progid = wrenGetSlotString(vm, 1);
    *pp = g_ole.create_object(progid);
}

static void wfn_ole_connect(WrenVM* vm) {
    if (!oleEnsureLoaded()) { wrenSetSlotNull(vm, 0); return; }
    const char* progid = wrenGetSlotString(vm, 1);
    void* pDisp = g_ole.get_active_object ? g_ole.get_active_object(progid) : nullptr;
    wrenGetVariable(vm, "ole", "OleObject", 0);
    void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pp = pDisp; // null if not found — caller checks .isNull
}

static void wfn_ole_finalize(void* data) {
    void** pp = (void**)data;
    if (pp && *pp && g_ole.loaded) {
        g_ole.release(*pp);
        *pp = nullptr;
    }
}

static void wfn_ole_release(WrenVM* vm) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    if (pp && *pp && g_ole.loaded) {
        g_ole.release(*pp);
        *pp = nullptr;
    }
}

static void wfn_ole_isNull(WrenVM* vm) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    wrenSetSlotBool(vm, 0, !pp || !*pp);
}

static void wfn_ole_get(WrenVM* vm) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    if (!pp || !*pp) { wrenNullOle(vm); return; }
    const char* prop = wrenGetSlotString(vm, 1);
    ole_variant_t result;
    g_ole.var_init(&result);
    int hr = g_ole.get_property(*pp, prop, nullptr, 0, &result);
    if (hr != 0) { wrenNullOle(vm); return; }
    variantToWrenSlot(vm, &result);
}

static void wfn_ole_set(WrenVM* vm) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    if (!pp || !*pp) return;
    const char* prop = wrenGetSlotString(vm, 1);
    ole_variant_t arg;
    wrenSlotToVariant(vm, 2, &arg);
    g_ole.set_property(*pp, prop, &arg, 1);
    g_ole.var_clear(&arg);
}

// call with 0..8 args
static void wfn_ole_call_impl(WrenVM* vm, int nArgs) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    if (!pp || !*pp) { wrenNullOle(vm); return; }
    const char* method = wrenGetSlotString(vm, 1);

    ole_variant_t args[8];
    for (int i = 0; i < nArgs; i++) {
        wrenSlotToVariant(vm, 2 + i, &args[i]);
    }

    ole_variant_t result;
    g_ole.var_init(&result);
    // Try DISPATCH_METHOD first, fallback to DISPATCH_PROPERTYGET for parameterized properties
    int hr = g_ole.invoke(*pp, method, 1/*DISPATCH_METHOD*/, args, nArgs, &result);
    if (hr != 0 && nArgs > 0) {
        g_ole.var_init(&result);
        hr = g_ole.get_property(*pp, method, args, nArgs, &result);
    }

    for (int i = 0; i < nArgs; i++) g_ole.var_clear(&args[i]);

    if (hr != 0) { wrenNullOle(vm); return; }
    variantToWrenSlot(vm, &result);
}

static void wfn_ole_call0(WrenVM* vm) { wfn_ole_call_impl(vm, 0); }
static void wfn_ole_call1(WrenVM* vm) { wfn_ole_call_impl(vm, 1); }
static void wfn_ole_call2(WrenVM* vm) { wfn_ole_call_impl(vm, 2); }
static void wfn_ole_call3(WrenVM* vm) { wfn_ole_call_impl(vm, 3); }
static void wfn_ole_call4(WrenVM* vm) { wfn_ole_call_impl(vm, 4); }
static void wfn_ole_call5(WrenVM* vm) { wfn_ole_call_impl(vm, 5); }
static void wfn_ole_call6(WrenVM* vm) { wfn_ole_call_impl(vm, 6); }
static void wfn_ole_call7(WrenVM* vm) { wfn_ole_call_impl(vm, 7); }
static void wfn_ole_call8(WrenVM* vm) { wfn_ole_call_impl(vm, 8); }

static void wfn_ole_lastError(WrenVM* vm) {
    if (g_ole.loaded && g_ole.last_error) {
        const char* err = g_ole.last_error();
        wrenSetSlotString(vm, 0, err ? err : "");
    } else {
        wrenSetSlotString(vm, 0, "");
    }
}

#endif // _WIN32

// ─── Linux OLE stubs (non-Windows) ───────────────────────────────────────────
// On Linux there is no COM/OLE. These stubs allow "import ole" to compile and
// return null OleObjects for every operation. Scripts should check
// OleObject.isAvailable before using OLE functionality.
#ifndef _WIN32

static void wfn_ole_new_stub(WrenVM* vm) {
    void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pp = nullptr;
}
static void wfn_ole_finalize_stub(void*) {}

// All get/call operations return a null OleObject
static void wfn_ole_nullreturn(WrenVM* vm) { wrenNullOle(vm); }

// .isNull → true (always, since ptr is null)
static void wfn_ole_isNull_stub(WrenVM* vm) {
    wrenSetSlotBool(vm, 0, true);
}

// .release() → no-op
static void wfn_ole_release_stub(WrenVM* vm) { (void)vm; }

// .set(_,_) → no-op
static void wfn_ole_set_stub(WrenVM* vm) { (void)vm; }

// .lastError → empty string
static void wfn_ole_lastError_stub(WrenVM* vm) {
    wrenSetSlotString(vm, 0, "OLE not available on this platform");
}

// enumBegin_ → false
static void wfn_ole_enumBegin_stub(WrenVM* vm) { wrenSetSlotBool(vm, 0, false); }

// enumNext_ → null
static void wfn_ole_enumNext_stub(WrenVM* vm) { wrenSetSlotNull(vm, 0); }

// enumRelease_ → no-op
static void wfn_ole_enumRelease_stub(WrenVM* vm) { (void)vm; }

#endif // !_WIN32

// ─── File foreign methods (cross-platform, uses QFile) ───────────────────────

static void wfn_file_read(WrenVM* vm) {
    const char* path = wrenGetSlotString(vm, 1);
    QFile f(QString::fromUtf8(path));
    if (!f.open(QFile::ReadOnly | QFile::Text)) {
        wrenSetSlotNull(vm, 0);
        return;
    }
    QByteArray data = f.readAll();
    f.close();
    wrenSetSlotString(vm, 0, data.constData());
}

static void wfn_file_write(WrenVM* vm) {
    const char* path = wrenGetSlotString(vm, 1);
    const char* content = wrenGetSlotString(vm, 2);
    QFile f(QString::fromUtf8(path));
    bool ok = f.open(QFile::WriteOnly | QFile::Text);
    if (ok) {
        f.write(content);
        f.close();
    }
    wrenSetSlotBool(vm, 0, ok);
}

static void wfn_file_exists(WrenVM* vm) {
    const char* path = wrenGetSlotString(vm, 1);
    wrenSetSlotBool(vm, 0, QFile::exists(QString::fromUtf8(path)));
}

static void wfn_file_delete(WrenVM* vm) {
    const char* path = wrenGetSlotString(vm, 1);
    wrenSetSlotBool(vm, 0, QFile::remove(QString::fromUtf8(path)));
}

static void wfn_file_size(WrenVM* vm) {
    const char* path = wrenGetSlotString(vm, 1);
    QFile f(QString::fromUtf8(path));
    if (f.exists()) {
        wrenSetSlotDouble(vm, 0, (double)f.size());
    } else {
        wrenSetSlotDouble(vm, 0, -1);
    }
}

// ─── Bridge struct ────────────────────────────────────────────────────────────

struct PendingArg {
    int    slot;
    int    type;   /* 0=double, 1=bool, 2=string */
    double dval;
    int    bval;
    std::string sval;
};

struct WrenBridge {
    WrenVM*  vm;
    std::map<std::string, void*> widgets;
    WrenWriteCb writeCb;
    WrenErrorCb errorCb;
    void*       ud;

    // result storage (filled after wrenBridge_call)
    int         resultType;    /* 0=num,1=bool,2=str,3=null,4=other */
    double      resultDouble;
    int         resultBool;
    std::string resultString;

    std::vector<PendingArg> pendingArgs;

    // Module search paths for file-based imports
    std::vector<std::string> libPaths;

    // Current IEnumVARIANT* for ForEach iteration
    void* currentEnum;
};

// Helper accessors for enum (used by forward-declared functions)
void bridgeSetEnum(WrenBridge* br, void* pEnum) { br->currentEnum = pEnum; }
void* bridgeGetEnum(WrenBridge* br) { return br->currentEnum; }

// ─── Helpers ──────────────────────────────────────────────────────────────────

static WrenBridge* getBridge(WrenVM* vm) {
    return (WrenBridge*)wrenGetUserData(vm);
}

// ─── OleObject enum foreign methods ──────────────────────────────────────────
#ifdef _WIN32

static void wfn_oleenumBegin_(WrenVM* vm) {
    void** pp = (void**)wrenGetSlotForeign(vm, 0);
    if (!pp || !*pp || !g_ole.enum_begin) { wrenSetSlotNull(vm, 0); return; }
    WrenBridge* br = getBridge(vm);
    void* pEnum = g_ole.enum_begin(*pp);
    bridgeSetEnum(br, pEnum);
    wrenSetSlotBool(vm, 0, pEnum != nullptr);
}

static void wfn_oleenumNext_(WrenVM* vm) {
    WrenBridge* br = getBridge(vm);
    void* pEnum = bridgeGetEnum(br);
    if (!pEnum || !g_ole.enum_next) { wrenSetSlotNull(vm, 0); return; }
    ole_variant_t result;
    g_ole.var_init(&result);
    int ok = g_ole.enum_next(pEnum, &result);
    if (!ok) { wrenSetSlotNull(vm, 0); return; }
    variantToWrenSlot(vm, &result);
}

static void wfn_oleenumRelease_(WrenVM* vm) {
    WrenBridge* br = getBridge(vm);
    void* pEnum = bridgeGetEnum(br);
    if (pEnum && g_ole.enum_release) {
        g_ole.enum_release(pEnum);
    }
    bridgeSetEnum(br, nullptr);
}

#endif // _WIN32

// ─── Sys foreign methods ─────────────────────────────────────────────────────

static void wfn_sys_sleep(WrenVM* vm) {
    int ms = (int)wrenGetSlotDouble(vm, 1);
    if (ms < 0) ms = 0;
#ifdef _WIN32
    Sleep((DWORD)ms);
#else
    usleep(ms * 1000);
#endif
}

static void wfn_sys_msgBox(WrenVM* vm) {
#ifdef _WIN32
    const char* text  = wrenGetSlotString(vm, 1);
    const char* title = wrenGetSlotString(vm, 2);
    int flags = (int)wrenGetSlotDouble(vm, 3);
    // Convert UTF-8 to wide for proper Unicode (including Cyrillic) support
    int tlen  = MultiByteToWideChar(CP_UTF8, 0, text,  -1, nullptr, 0);
    int ntlen = MultiByteToWideChar(CP_UTF8, 0, title, -1, nullptr, 0);
    std::vector<wchar_t> wtext(tlen), wtitle(ntlen);
    MultiByteToWideChar(CP_UTF8, 0, text,  -1, wtext.data(),  tlen);
    MultiByteToWideChar(CP_UTF8, 0, title, -1, wtitle.data(), ntlen);
    int result = MessageBoxW(nullptr, wtext.data(), wtitle.data(), (UINT)flags);
    wrenSetSlotDouble(vm, 0, result);
#else
    wrenSetSlotDouble(vm, 0, 0);
#endif
}

static void wfn_sys_clock(WrenVM* vm) {
#ifdef _WIN32
    wrenSetSlotDouble(vm, 0, (double)GetTickCount());
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    wrenSetSlotDouble(vm, 0, ts.tv_sec * 1000.0 + ts.tv_nsec / 1e6);
#endif
}

static void wfn_sys_env(WrenVM* vm) {
    const char* name = wrenGetSlotString(vm, 1);
#ifdef _WIN32
    char buf[4096];
    DWORD len = GetEnvironmentVariableA(name, buf, sizeof(buf));
    if (len > 0 && len < sizeof(buf)) {
        wrenSetSlotString(vm, 0, buf);
    } else {
        wrenSetSlotNull(vm, 0);
    }
#else
    const char* val = getenv(name);
    if (val) wrenSetSlotString(vm, 0, val);
    else wrenSetSlotNull(vm, 0);
#endif
}

static void* getWidgetFromSlot(WrenVM* vm, int slot) {
    void** pp = (void**)wrenGetSlotForeign(vm, slot);
    return pp ? *pp : nullptr;
}

// ─── Widget foreign methods ───────────────────────────────────────────────────

static void wfn_setText(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    QString s = QString::fromUtf8(wrenGetSlotString(vm, 1));
    QWidget* w = (QWidget*)wh;
    if (auto* l = qobject_cast<QLabel*>(w))          { l->setText(s); return; }
    if (auto* e = qobject_cast<QLineEdit*>(w))        { e->setText(s); return; }
    if (auto* b = qobject_cast<QAbstractButton*>(w))  { b->setText(s); return; }
    if (auto* g = qobject_cast<QGroupBox*>(w))        { g->setTitle(s); return; }
}

static void wfn_getText(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) { wrenSetSlotString(vm, 0, ""); return; }
    QWidget* w = (QWidget*)wh;
    QString r;
    if (auto* l = qobject_cast<QLabel*>(w))          r = l->text();
    else if (auto* e = qobject_cast<QLineEdit*>(w))   r = e->text();
    else if (auto* b = qobject_cast<QAbstractButton*>(w)) r = b->text();
    else if (auto* g = qobject_cast<QGroupBox*>(w))   r = g->title();
    wrenSetSlotString(vm, 0, r.toUtf8().constData());
}

static void wfn_setValue(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    double val = wrenGetSlotDouble(vm, 1);
    QWidget* w = (QWidget*)wh;
    if (auto* s = qobject_cast<QSpinBox*>(w))        { s->setValue((int)val); return; }
    if (auto* d = qobject_cast<QDoubleSpinBox*>(w))  { d->setValue(val); return; }
    if (auto* s = qobject_cast<QAbstractSlider*>(w)) { s->setValue((int)val); return; }
    if (auto* p = qobject_cast<QProgressBar*>(w))    { p->setValue((int)val); return; }
    if (auto* l = qobject_cast<QLCDNumber*>(w))      { l->display(val); return; }
}

static void wfn_getValue(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    double r = 0;
    if (wh) {
        QWidget* w = (QWidget*)wh;
        if (auto* s = qobject_cast<QSpinBox*>(w))        r = s->value();
        else if (auto* d = qobject_cast<QDoubleSpinBox*>(w)) r = d->value();
        else if (auto* s = qobject_cast<QAbstractSlider*>(w)) r = s->value();
        else if (auto* p = qobject_cast<QProgressBar*>(w)) r = p->value();
    }
    wrenSetSlotDouble(vm, 0, r);
}

static void wfn_setChecked(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    if (auto* b = qobject_cast<QAbstractButton*>((QWidget*)wh))
        b->setChecked(wrenGetSlotBool(vm, 1));
}
static void wfn_isChecked(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    bool r = false;
    if (wh) if (auto* b = qobject_cast<QAbstractButton*>((QWidget*)wh)) r = b->isChecked();
    wrenSetSlotBool(vm, 0, r);
}

static void wfn_setEnabled(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (wh) ((QWidget*)wh)->setEnabled(wrenGetSlotBool(vm, 1));
}
static void wfn_isEnabled(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    wrenSetSlotBool(vm, 0, wh ? ((QWidget*)wh)->isEnabled() : false);
}

static void wfn_setVisible(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (wh) ((QWidget*)wh)->setVisible(wrenGetSlotBool(vm, 1));
}
static void wfn_isVisible(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    wrenSetSlotBool(vm, 0, wh ? ((QWidget*)wh)->isVisible() : false);
}

static void wfn_addItem(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    QString s = QString::fromUtf8(wrenGetSlotString(vm, 1));
    QWidget* w = (QWidget*)wh;
    if (auto* c = qobject_cast<QComboBox*>(w))    c->addItem(s);
    else if (auto* l = qobject_cast<QListWidget*>(w)) l->addItem(s);
}
static void wfn_clearItems(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    QWidget* w = (QWidget*)wh;
    if (auto* c = qobject_cast<QComboBox*>(w))    c->clear();
    else if (auto* l = qobject_cast<QListWidget*>(w)) l->clear();
}
static void wfn_count(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    int n = 0;
    if (wh) {
        QWidget* w = (QWidget*)wh;
        if (auto* c = qobject_cast<QComboBox*>(w))    n = c->count();
        else if (auto* l = qobject_cast<QListWidget*>(w)) n = l->count();
    }
    wrenSetSlotDouble(vm, 0, n);
}
static void wfn_currentIndex(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    int n = -1;
    if (wh) if (auto* c = qobject_cast<QComboBox*>((QWidget*)wh)) n = c->currentIndex();
    wrenSetSlotDouble(vm, 0, n);
}
static void wfn_setCurrentIndex(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    if (!wh) return;
    if (auto* c = qobject_cast<QComboBox*>((QWidget*)wh))
        c->setCurrentIndex((int)wrenGetSlotDouble(vm, 1));
}
static void wfn_className(WrenVM* vm) {
    void* wh = getWidgetFromSlot(vm, 0);
    const char* name = "(null)";
    if (wh) name = ((QWidget*)wh)->metaObject()->className();
    wrenSetSlotString(vm, 0, name);
}

// ─── Widget allocator/finalizer ───────────────────────────────────────────────

static void wfn_widget_new(WrenVM* vm) {
    const char* name = wrenGetSlotString(vm, 1);
    WrenBridge* br = getBridge(vm);
    void* wh = nullptr;
    auto it = br->widgets.find(name);
    if (it != br->widgets.end()) wh = it->second;
    void** pp = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pp = wh;
}
static void wfn_widget_finalize(void*) {}

// ─── Logger foreign methods ───────────────────────────────────────────────────

static void wfn_logger_print(WrenVM* vm) {
    WrenBridge* br = getBridge(vm);
    const char* msg = wrenGetSlotString(vm, 1);
    if (br->writeCb) br->writeCb(msg, (int)strlen(msg), br->ud);
}
static void wfn_logger_warn(WrenVM* vm) {
    WrenBridge* br = getBridge(vm);
    std::string msg = "[WARN] ";
    msg += wrenGetSlotString(vm, 1);
    if (br->writeCb) br->writeCb(msg.c_str(), (int)msg.size(), br->ud);
}

// ─── Wren configuration callbacks ─────────────────────────────────────────────

static void writeFn(WrenVM* vm, const char* text) {
    WrenBridge* br = getBridge(vm);
    if (br->writeCb) br->writeCb(text, (int)strlen(text), br->ud);
}

static void errorFn(WrenVM* vm, WrenErrorType type,
                    const char* module, int line, const char* message) {
    WrenBridge* br = getBridge(vm);
    if (!br->errorCb) return;
    char buf[1024];
    switch (type) {
        case WREN_ERROR_COMPILE:
            snprintf(buf, sizeof(buf), "[%s line %d] Compile: %s", module ? module : "?", line, message);
            break;
        case WREN_ERROR_RUNTIME:
            snprintf(buf, sizeof(buf), "Runtime: %s", message);
            break;
        case WREN_ERROR_STACK_TRACE:
            snprintf(buf, sizeof(buf), "  at [%s line %d]", module ? module : "?", line);
            break;
    }
    br->errorCb(buf, (int)strlen(buf), br->ud);
}

static WrenForeignMethodFn bindForeignMethodFn(WrenVM* vm, const char* module,
    const char* className, bool isStatic, const char* signature)
{
    // Inspector modules (cross-platform)
    {
        WrenForeignMethodFn f = winsp_bindForeignMethod(module, className, isStatic, signature);
        if (f) return f;
    }

    if (strcmp(module, "ole") == 0 && strcmp(className, "OleObject") == 0) {
        // isAvailable is cross-platform (true on Windows, false on Linux)
        if (isStatic && strcmp(signature, "isAvailable") == 0) return wfn_ole_isAvailable;
#ifdef _WIN32
        if (!isStatic) {
            if (strcmp(signature, "get(_)") == 0)                    return wfn_ole_get;
            if (strcmp(signature, "set(_,_)") == 0)                  return wfn_ole_set;
            if (strcmp(signature, "call(_)") == 0)                    return wfn_ole_call0;
            if (strcmp(signature, "call(_,_)") == 0)                  return wfn_ole_call1;
            if (strcmp(signature, "call(_,_,_)") == 0)                return wfn_ole_call2;
            if (strcmp(signature, "call(_,_,_,_)") == 0)              return wfn_ole_call3;
            if (strcmp(signature, "call(_,_,_,_,_)") == 0)            return wfn_ole_call4;
            if (strcmp(signature, "call(_,_,_,_,_,_)") == 0)          return wfn_ole_call5;
            if (strcmp(signature, "call(_,_,_,_,_,_,_)") == 0)        return wfn_ole_call6;
            if (strcmp(signature, "call(_,_,_,_,_,_,_,_)") == 0)      return wfn_ole_call7;
            if (strcmp(signature, "call(_,_,_,_,_,_,_,_,_)") == 0)    return wfn_ole_call8;
            if (strcmp(signature, "release()") == 0)                  return wfn_ole_release;
            if (strcmp(signature, "isNull") == 0)                     return wfn_ole_isNull;
            if (strcmp(signature, "enumBegin_()") == 0)               return wfn_oleenumBegin_;
            if (strcmp(signature, "enumNext_()") == 0)                return wfn_oleenumNext_;
            if (strcmp(signature, "enumRelease_()") == 0)             return wfn_oleenumRelease_;
        }
        if (isStatic) {
            if (strcmp(signature, "lastError") == 0)                  return wfn_ole_lastError;
            if (strcmp(signature, "connect(_)") == 0)                 return wfn_ole_connect;
        }
#else
        // Linux stubs — all operations return null OleObjects or no-op
        if (!isStatic) {
            if (strcmp(signature, "isNull") == 0)        return wfn_ole_isNull_stub;
            if (strcmp(signature, "release()") == 0)     return wfn_ole_release_stub;
            if (strcmp(signature, "set(_,_)") == 0)      return wfn_ole_set_stub;
            if (strcmp(signature, "enumBegin_()") == 0)  return wfn_ole_enumBegin_stub;
            if (strcmp(signature, "enumNext_()") == 0)   return wfn_ole_enumNext_stub;
            if (strcmp(signature, "enumRelease_()") == 0) return wfn_ole_enumRelease_stub;
            // get(_) and all call(...) variants → null OleObject
            return wfn_ole_nullreturn;
        }
        if (isStatic) {
            if (strcmp(signature, "lastError") == 0)     return wfn_ole_lastError_stub;
            if (strcmp(signature, "connect(_)") == 0)    return wfn_ole_nullreturn;
        }
#endif
    }

    // io module — File class
    if (strcmp(module, "io") == 0 && strcmp(className, "File") == 0 && isStatic) {
        if (strcmp(signature, "read(_)") == 0)   return wfn_file_read;
        if (strcmp(signature, "write(_,_)") == 0) return wfn_file_write;
        if (strcmp(signature, "exists(_)") == 0)  return wfn_file_exists;
        if (strcmp(signature, "delete(_)") == 0)  return wfn_file_delete;
        if (strcmp(signature, "size(_)") == 0)    return wfn_file_size;
    }

    // sys module — Sys class
    if (strcmp(module, "sys") == 0 && strcmp(className, "Sys") == 0 && isStatic) {
        if (strcmp(signature, "sleep(_)") == 0)      return wfn_sys_sleep;
        if (strcmp(signature, "msgBox(_,_,_)") == 0)  return wfn_sys_msgBox;
        if (strcmp(signature, "clock") == 0)           return wfn_sys_clock;
        if (strcmp(signature, "env(_)") == 0)          return wfn_sys_env;
    }

    if (strcmp(module, "qt") != 0) return nullptr;

    if (strcmp(className, "Widget") == 0 && !isStatic) {
        if (strcmp(signature, "setText(_)") == 0)       return wfn_setText;
        if (strcmp(signature, "text") == 0)             return wfn_getText;
        if (strcmp(signature, "setValue(_)") == 0)      return wfn_setValue;
        if (strcmp(signature, "value") == 0)            return wfn_getValue;
        if (strcmp(signature, "setChecked(_)") == 0)    return wfn_setChecked;
        if (strcmp(signature, "isChecked") == 0)        return wfn_isChecked;
        if (strcmp(signature, "setEnabled(_)") == 0)    return wfn_setEnabled;
        if (strcmp(signature, "isEnabled") == 0)        return wfn_isEnabled;
        if (strcmp(signature, "setVisible(_)") == 0)    return wfn_setVisible;
        if (strcmp(signature, "isVisible") == 0)        return wfn_isVisible;
        if (strcmp(signature, "addItem(_)") == 0)       return wfn_addItem;
        if (strcmp(signature, "clearItems()") == 0)     return wfn_clearItems;
        if (strcmp(signature, "count") == 0)            return wfn_count;
        if (strcmp(signature, "currentIndex") == 0)     return wfn_currentIndex;
        if (strcmp(signature, "setCurrentIndex(_)") == 0) return wfn_setCurrentIndex;
        if (strcmp(signature, "className") == 0)        return wfn_className;
    }
    if (strcmp(className, "Logger") == 0 && isStatic) {
        if (strcmp(signature, "print(_)") == 0) return wfn_logger_print;
        if (strcmp(signature, "warn(_)") == 0)  return wfn_logger_warn;
    }
    return nullptr;
}

static WrenForeignClassMethods bindForeignClassFn(WrenVM* vm,
    const char* module, const char* className)
{
    // Inspector foreign classes
    {
        WrenForeignClassMethods m = winsp_bindForeignClass(module, className);
        if (m.allocate) return m;
    }

    WrenForeignClassMethods m = {nullptr, nullptr};
    if (strcmp(module, "qt") == 0 && strcmp(className, "Widget") == 0) {
        m.allocate = wfn_widget_new;
        m.finalize = wfn_widget_finalize;
    }
    if (strcmp(module, "ole") == 0 && strcmp(className, "OleObject") == 0) {
#ifdef _WIN32
        m.allocate = wfn_ole_new;
        m.finalize = wfn_ole_finalize;
#else
        m.allocate = wfn_ole_new_stub;
        m.finalize = wfn_ole_finalize_stub;
#endif
    }
    if (strcmp(module, "io") == 0 && strcmp(className, "File") == 0) {
        m.allocate = [](WrenVM* vm) { wrenSetSlotNewForeign(vm, 0, 0, 0); };
        m.finalize = [](void*) {};
    }
    if (strcmp(module, "sys") == 0 && strcmp(className, "Sys") == 0) {
        m.allocate = [](WrenVM* vm) { wrenSetSlotNewForeign(vm, 0, 0, 0); };
        m.finalize = [](void*) {};
    }
    return m;
}

// Called by Wren when it's done with a dynamically loaded module source
static void loadModuleComplete(WrenVM* vm, const char* name, WrenLoadModuleResult result) {
    if (result.userData) {
        free(result.userData);  // free the malloc'd source buffer
    }
}

static WrenLoadModuleResult loadModuleFn(WrenVM* vm, const char* name) {
    WrenLoadModuleResult r = {nullptr, nullptr, nullptr};

    // Built-in modules (static strings, no free needed)
    if (strcmp(name, "qt") == 0)  { r.source = QT_MODULE_SRC;  return r; }
    if (strcmp(name, "io") == 0)  { r.source = IO_MODULE_SRC;  return r; }
    if (strcmp(name, "sys") == 0) { r.source = SYS_MODULE_SRC; return r; }
    if (strcmp(name, "ole") == 0) { r.source = OLE_MODULE_SRC; return r; }  // stub on Linux

    // Inspector modules (inspector, log, out, check)
    { const char* s = winsp_getModuleSource(name); if (s) { r.source = s; return r; } }

    // File-based module resolution: search libPaths for <name>.wren
    WrenBridge* br = getBridge(vm);
    std::string filename = std::string(name) + ".wren";

    for (const auto& dir : br->libPaths) {
        QString path = QString::fromUtf8(dir.c_str());
        if (!path.endsWith('/') && !path.endsWith('\\')) path += '/';
        path += QString::fromUtf8(filename.c_str());

        QFile f(path);
        if (!f.exists()) continue;
        if (!f.open(QFile::ReadOnly | QFile::Text)) continue;

        QByteArray data = f.readAll();
        f.close();

        // Wren needs the source to stay alive until onComplete is called
        char* src = (char*)malloc(data.size() + 1);
        memcpy(src, data.constData(), data.size());
        src[data.size()] = '\0';

        r.source     = src;
        r.onComplete = loadModuleComplete;
        r.userData   = src;  // so onComplete can free it
        return r;
    }

    return r;  // not found → source=nullptr
}

// ─── Public API ───────────────────────────────────────────────────────────────

extern "C" {

WREN_API void* wrenBridge_create(WrenWriteCb writeCb, WrenErrorCb errorCb, void* ud) {
    WrenBridge* br = new WrenBridge();
    br->writeCb = writeCb;
    br->errorCb = errorCb;
    br->ud      = ud;
    br->resultType = 3; // null
    br->currentEnum = nullptr;

    WrenConfiguration cfg;
    wrenInitConfiguration(&cfg);
    cfg.writeFn             = writeFn;
    cfg.errorFn             = errorFn;
    cfg.bindForeignMethodFn = bindForeignMethodFn;
    cfg.bindForeignClassFn  = bindForeignClassFn;
    cfg.loadModuleFn        = loadModuleFn;

    br->vm = wrenNewVM(&cfg);
    wrenSetUserData(br->vm, br);
    return br;
}

WREN_API void wrenBridge_free(void* p) {
    WrenBridge* br = (WrenBridge*)p;
    if (!br) return;
    wrenFreeVM(br->vm);
    delete br;
}

WREN_API int wrenBridge_interpret(void* p, const char* module, const char* source) {
    WrenBridge* br = (WrenBridge*)p;
    return (int)wrenInterpret(br->vm, module, source);
}

WREN_API int wrenBridge_loadFile(void* p, const char* module, const wchar_t* path, int pathLen) {
    WrenBridge* br = (WrenBridge*)p;
    QString qpath = QString::fromWCharArray(path, pathLen);
    QFile f(qpath);
    if (!f.open(QFile::ReadOnly | QFile::Text)) return 2;
    QByteArray data = f.readAll();
    f.close();
    return (int)wrenInterpret(br->vm, module, data.constData());
}

WREN_API int wrenBridge_loadFileUtf8(void* p, const char* module, const char* path) {
    WrenBridge* br = (WrenBridge*)p;
    QFile f(QString::fromUtf8(path));
    if (!f.open(QFile::ReadOnly | QFile::Text)) return 2;
    QByteArray data = f.readAll();
    f.close();
    return (int)wrenInterpret(br->vm, module, data.constData());
}

WREN_API void wrenBridge_setWidget(void* p, const char* name, void* wh) {
    ((WrenBridge*)p)->widgets[name] = wh;
}
WREN_API void wrenBridge_clearWidgets(void* p) {
    ((WrenBridge*)p)->widgets.clear();
}

WREN_API void wrenBridge_addLibPath(void* p, const char* path) {
    ((WrenBridge*)p)->libPaths.push_back(path ? path : "");
}

WREN_API void wrenBridge_argDouble(void* p, int slot, double val) {
    PendingArg a; a.slot = slot; a.type = 0; a.dval = val;
    ((WrenBridge*)p)->pendingArgs.push_back(a);
}
WREN_API void wrenBridge_argString(void* p, int slot, const char* str) {
    PendingArg a; a.slot = slot; a.type = 2; a.sval = str ? str : "";
    ((WrenBridge*)p)->pendingArgs.push_back(a);
}
WREN_API void wrenBridge_argBool(void* p, int slot, int val) {
    PendingArg a; a.slot = slot; a.type = 1; a.bval = val;
    ((WrenBridge*)p)->pendingArgs.push_back(a);
}

WREN_API int wrenBridge_call(void* p, const char* module, const char* className, const char* sig) {
    WrenBridge* br = (WrenBridge*)p;
    WrenVM* vm = br->vm;
    wrenEnsureSlots(vm, 16);
    wrenGetVariable(vm, module, className, 0);

    for (auto& a : br->pendingArgs) {
        switch (a.type) {
            case 0: wrenSetSlotDouble(vm, a.slot, a.dval); break;
            case 1: wrenSetSlotBool(vm, a.slot, a.bval);   break;
            case 2: wrenSetSlotString(vm, a.slot, a.sval.c_str()); break;
        }
    }
    br->pendingArgs.clear();

    WrenHandle* h = wrenMakeCallHandle(vm, sig);
    WrenInterpretResult res = wrenCall(vm, h);
    wrenReleaseHandle(vm, h);

    // store result
    WrenType t = wrenGetSlotType(vm, 0);
    switch (t) {
        case WREN_TYPE_NUM:
            br->resultType   = 0;
            br->resultDouble = wrenGetSlotDouble(vm, 0);
            break;
        case WREN_TYPE_BOOL:
            br->resultType = 1;
            br->resultBool = wrenGetSlotBool(vm, 0) ? 1 : 0;
            break;
        case WREN_TYPE_STRING:
            br->resultType   = 2;
            br->resultString = wrenGetSlotString(vm, 0);
            break;
        case WREN_TYPE_NULL:
            br->resultType = 3;
            break;
        default:
            br->resultType = 4;
            break;
    }
    return (int)res;
}

WREN_API int wrenBridge_resultType(void* p) {
    return ((WrenBridge*)p)->resultType;
}
WREN_API double wrenBridge_resultDouble(void* p) {
    return ((WrenBridge*)p)->resultDouble;
}
WREN_API int wrenBridge_resultBool(void* p) {
    return ((WrenBridge*)p)->resultBool;
}
WREN_API const char* wrenBridge_resultString(void* p) {
    return ((WrenBridge*)p)->resultString.c_str();
}
WREN_API int wrenBridge_hasVariable(void* p, const char* module, const char* name) {
    return wrenHasVariable(((WrenBridge*)p)->vm, module, name) ? 1 : 0;
}

} // extern "C"
