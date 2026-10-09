/*
 * ole_helper.c — COM/OLE Automation shim (IDispatch)
 * Standalone, no Qt dependencies. Links: -lole32 -loleaut32 -luuid
 *
 * All name/string parameters are UTF-8 (const char*).
 * Conversion to wchar_t* done internally via MultiByteToWideChar.
 */
#define OLE_HELPER_EXPORTS
#define COBJMACROS
#define CINTERFACE

#include <windows.h>
#include <ole2.h>
#include <oleauto.h>
#include <stdio.h>
#include <string.h>
#include "ole_helper.h"

/* ── UTF-8 → wchar_t conversion helper ── */

/* Convert UTF-8 to wchar_t on the stack (buf) or heap (if too big).
   Returns pointer to wchar_t string (caller must call wide_free if != buf). */
static wchar_t* utf8_to_wide(const char* utf8, wchar_t* buf, int bufChars, int* outLen) {
    if (!utf8 || !utf8[0]) {
        buf[0] = 0;
        if (outLen) *outLen = 0;
        return buf;
    }
    int needed = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
    wchar_t* dst;
    if (needed <= bufChars) {
        dst = buf;
    } else {
        dst = (wchar_t*)malloc(needed * sizeof(wchar_t));
    }
    MultiByteToWideChar(CP_UTF8, 0, utf8, -1, dst, needed);
    if (outLen) *outLen = needed - 1; /* exclude null terminator */
    return dst;
}

static void wide_free(wchar_t* p, wchar_t* stackBuf) {
    if (p && p != stackBuf) free(p);
}

/* wchar_t → UTF-8 into caller buffer. Returns bytes written (excl. null). */
static int wide_to_utf8(const wchar_t* wide, int wideLen, char* buf, int bufSize) {
    if (!wide || wideLen == 0) {
        if (buf && bufSize > 0) buf[0] = 0;
        return 0;
    }
    int needed = WideCharToMultiByte(CP_UTF8, 0, wide, wideLen, NULL, 0, NULL, NULL);
    if (needed >= bufSize) needed = bufSize - 1;
    int written = WideCharToMultiByte(CP_UTF8, 0, wide, wideLen, buf, needed, NULL, NULL);
    buf[written] = 0;
    return written;
}

/* ── Thread-local error state (UTF-8) ── */
static __thread char g_lastError[1024] = {0};
static __thread HRESULT g_lastHR = S_OK;

static void set_error(HRESULT hr, const char* msg) {
    g_lastHR = hr;
    _snprintf(g_lastError, sizeof(g_lastError) - 1, "%s (HRESULT=0x%08X)", msg, (unsigned)hr);
    g_lastError[sizeof(g_lastError) - 1] = 0;
}

static void clear_error(void) {
    g_lastHR = S_OK;
    g_lastError[0] = 0;
}

/* ── IID_IDispatch (defined manually for MinGW compatibility) ── */
static const IID LOCAL_IID_IDispatch =
    {0x00020400, 0x0000, 0x0000, {0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}};

/* ── Lifecycle ── */

OLE_API int ole_init(void) {
    HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
    if (FAILED(hr) && hr != RPC_E_CHANGED_MODE) {
        set_error(hr, "CoInitializeEx failed");
        return (int)hr;
    }
    clear_error();
    return (int)S_OK;
}

OLE_API void ole_uninit(void) {
    CoUninitialize();
}

OLE_API void* ole_create_object(const char* progid) {
    wchar_t wbuf[256];
    wchar_t* wprogid = utf8_to_wide(progid, wbuf, 256, NULL);

    CLSID clsid;
    HRESULT hr = CLSIDFromProgID(wprogid, &clsid);
    wide_free(wprogid, wbuf);

    if (FAILED(hr)) {
        set_error(hr, "CLSIDFromProgID failed");
        return NULL;
    }
    IDispatch* pDisp = NULL;
    hr = CoCreateInstance(&clsid, NULL,
                          CLSCTX_LOCAL_SERVER | CLSCTX_INPROC_SERVER,
                          &LOCAL_IID_IDispatch, (void**)&pDisp);
    if (FAILED(hr)) {
        set_error(hr, "CoCreateInstance failed");
        return NULL;
    }
    clear_error();
    return (void*)pDisp;
}

OLE_API void* ole_get_active_object(const char* progid) {
    wchar_t wbuf[256];
    wchar_t* wprogid = utf8_to_wide(progid, wbuf, 256, NULL);

    CLSID clsid;
    HRESULT hr = CLSIDFromProgID(wprogid, &clsid);
    wide_free(wprogid, wbuf);

    if (FAILED(hr)) {
        set_error(hr, "CLSIDFromProgID failed");
        return NULL;
    }

    IUnknown* pUnk = NULL;
    hr = GetActiveObject(&clsid, NULL, &pUnk);
    if (FAILED(hr)) {
        set_error(hr, "GetActiveObject failed (no running instance?)");
        return NULL;
    }

    IDispatch* pDisp = NULL;
    hr = IUnknown_QueryInterface(pUnk, &LOCAL_IID_IDispatch, (void**)&pDisp);
    IUnknown_Release(pUnk);
    if (FAILED(hr)) {
        set_error(hr, "QueryInterface(IDispatch) failed");
        return NULL;
    }

    clear_error();
    return (void*)pDisp;
}

OLE_API void ole_release(void* pDisp) {
    if (pDisp) {
        IDispatch_Release((IDispatch*)pDisp);
    }
}

/* ── Internal invoke helper ── */

static HRESULT _invoke(IDispatch* pDisp, const wchar_t* wname,
                       WORD wFlags, ole_variant_t* args, int nArgs,
                       ole_variant_t* result)
{
    DISPID dispid;
    LPOLESTR namePtr = (LPOLESTR)wname;
    HRESULT hr = IDispatch_GetIDsOfNames(pDisp, &IID_NULL, &namePtr, 1,
                                          LOCALE_USER_DEFAULT, &dispid);
    if (FAILED(hr)) {
        set_error(hr, "GetIDsOfNames failed");
        return hr;
    }

    /* Build DISPPARAMS — COM expects args in reverse order */
    VARIANT reversedBuf[16];
    VARIANT* reversed = reversedBuf;
    if (nArgs > 16) {
        reversed = (VARIANT*)malloc(nArgs * sizeof(VARIANT));
        if (!reversed) {
            set_error(E_OUTOFMEMORY, "malloc failed for args");
            return E_OUTOFMEMORY;
        }
    }

    for (int i = 0; i < nArgs; i++) {
        memcpy(&reversed[nArgs - 1 - i], &args[i], sizeof(VARIANT));
    }

    DISPPARAMS dp;
    dp.rgvarg = reversed;
    dp.cArgs = (UINT)nArgs;
    dp.rgdispidNamedArgs = NULL;
    dp.cNamedArgs = 0;

    DISPID putId = DISPID_PROPERTYPUT;
    if (wFlags & DISPATCH_PROPERTYPUT) {
        dp.rgdispidNamedArgs = &putId;
        dp.cNamedArgs = 1;
    }

    EXCEPINFO excepInfo;
    memset(&excepInfo, 0, sizeof(excepInfo));
    UINT argErr = 0;

    VARIANT vtResult;
    VariantInit(&vtResult);

    hr = IDispatch_Invoke(pDisp, dispid, &IID_NULL, LOCALE_USER_DEFAULT,
                          wFlags, &dp, result ? &vtResult : NULL,
                          &excepInfo, &argErr);

    if (nArgs > 16 && reversed != reversedBuf) {
        free(reversed);
    }

    if (FAILED(hr)) {
        if (hr == DISP_E_EXCEPTION && excepInfo.bstrDescription) {
            /* Convert exception to UTF-8 */
            int elen = (int)SysStringLen(excepInfo.bstrDescription);
            char ebuf[512];
            wide_to_utf8(excepInfo.bstrDescription, elen, ebuf, sizeof(ebuf));
            _snprintf(g_lastError, sizeof(g_lastError) - 1, "Exception: %s", ebuf);
            g_lastError[sizeof(g_lastError) - 1] = 0;
            g_lastHR = hr;
            SysFreeString(excepInfo.bstrSource);
            SysFreeString(excepInfo.bstrDescription);
            SysFreeString(excepInfo.bstrHelpFile);
        } else {
            set_error(hr, "IDispatch::Invoke failed");
        }
        VariantClear(&vtResult);
        return hr;
    }

    if (result) {
        memcpy(result, &vtResult, sizeof(VARIANT));
    } else {
        VariantClear(&vtResult);
    }

    clear_error();
    return S_OK;
}

/* ── Core Invoke (UTF-8 names) ── */

OLE_API int ole_invoke(void* pDisp, const char* name, int wFlags,
                       ole_variant_t* args, int nArgs, ole_variant_t* result)
{
    if (!pDisp) { set_error(E_POINTER, "pDisp is NULL"); return (int)E_POINTER; }
    wchar_t wbuf[128];
    wchar_t* wname = utf8_to_wide(name, wbuf, 128, NULL);
    HRESULT hr = _invoke((IDispatch*)pDisp, wname, (WORD)wFlags, args, nArgs, result);
    wide_free(wname, wbuf);
    return (int)hr;
}

OLE_API int ole_get_property(void* pDisp, const char* name,
                             ole_variant_t* args, int nArgs, ole_variant_t* result)
{
    if (!pDisp) { set_error(E_POINTER, "pDisp is NULL"); return (int)E_POINTER; }
    wchar_t wbuf[128];
    wchar_t* wname = utf8_to_wide(name, wbuf, 128, NULL);
    HRESULT hr = _invoke((IDispatch*)pDisp, wname, DISPATCH_PROPERTYGET, args, nArgs, result);
    wide_free(wname, wbuf);
    return (int)hr;
}

OLE_API int ole_set_property(void* pDisp, const char* name,
                             ole_variant_t* args, int nArgs)
{
    if (!pDisp) { set_error(E_POINTER, "pDisp is NULL"); return (int)E_POINTER; }
    wchar_t wbuf[128];
    wchar_t* wname = utf8_to_wide(name, wbuf, 128, NULL);
    HRESULT hr = _invoke((IDispatch*)pDisp, wname, DISPATCH_PROPERTYPUT, args, nArgs, NULL);
    wide_free(wname, wbuf);
    return (int)hr;
}

/* ── Variant Helpers ── */

OLE_API void ole_var_init(ole_variant_t* v) {
    VariantInit((VARIANT*)v);
}

OLE_API void ole_var_clear(ole_variant_t* v) {
    VariantClear((VARIANT*)v);
}

OLE_API void ole_var_set_int(ole_variant_t* v, int val) {
    v->vt = VT_I4;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->intVal = val;
}

OLE_API void ole_var_set_double(ole_variant_t* v, double val) {
    v->vt = VT_R8;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->dblVal = val;
}

OLE_API void ole_var_set_string(ole_variant_t* v, const char* utf8) {
    wchar_t wbuf[512];
    int wlen;
    wchar_t* wstr = utf8_to_wide(utf8, wbuf, 512, &wlen);
    v->vt = VT_BSTR;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->ptrVal = (void*)SysAllocStringLen(wstr, (UINT)wlen);
    wide_free(wstr, wbuf);
}

OLE_API void ole_var_set_dispatch(ole_variant_t* v, void* pDisp) {
    v->vt = VT_DISPATCH;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->ptrVal = pDisp;
}

OLE_API void ole_var_set_bool(ole_variant_t* v, int val) {
    v->vt = VT_BOOL;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->boolVal = val ? VARIANT_TRUE : VARIANT_FALSE;
}

OLE_API void ole_var_set_empty(ole_variant_t* v) {
    v->vt = VT_EMPTY;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->ptrVal = NULL;
}

OLE_API unsigned short ole_var_get_type(const ole_variant_t* v) {
    return v->vt;
}

OLE_API int ole_var_get_int(const ole_variant_t* v) {
    return v->intVal;
}

OLE_API double ole_var_get_double(const ole_variant_t* v) {
    return v->dblVal;
}

OLE_API int ole_var_get_string(const ole_variant_t* v, char* buf, int bufSize) {
    // Handle EMPTY/NULL — return empty string
    if (v->vt == VT_EMPTY || v->vt == VT_NULL) {
        if (buf && bufSize > 0) buf[0] = 0;
        return 0;
    }

    // Already BSTR — direct UTF-8 conversion
    if (v->vt == VT_BSTR && v->ptrVal != NULL) {
        BSTR bstr = (BSTR)v->ptrVal;
        int wlen = (int)SysStringLen(bstr);
        return wide_to_utf8((const wchar_t*)bstr, wlen, buf, bufSize);
    }

    // Other types (VT_I4, VT_R8, VT_DATE, VT_BOOL, etc.)
    // Convert via VariantChangeType → BSTR → UTF-8
    VARIANT varBstr;
    VariantInit(&varBstr);

    HRESULT hr = VariantChangeType(&varBstr, (VARIANTARG*)v, 0, VT_BSTR);
    if (FAILED(hr)) {
        if (buf && bufSize > 0) buf[0] = 0;
        return 0;
    }

    BSTR bstr = varBstr.bstrVal;
    int wlen = (int)SysStringLen(bstr);
    int result = wide_to_utf8((const wchar_t*)bstr, wlen, buf, bufSize);

    VariantClear(&varBstr);  // Free temporary BSTR
    return result;
}

OLE_API void* ole_var_get_dispatch(const ole_variant_t* v) {
    return v->ptrVal;
}

OLE_API int ole_var_get_bool(const ole_variant_t* v) {
    return v->boolVal != 0 ? 1 : 0;
}

/* ── VT_DATE helpers ── */

OLE_API void ole_var_set_date(ole_variant_t* v, double val) {
    v->vt = VT_DATE;
    v->reserved[0] = v->reserved[1] = v->reserved[2] = 0;
    v->dblVal = val;
}

OLE_API double ole_var_get_date(const ole_variant_t* v) {
    return v->dblVal;
}

/* ── Enumeration — For Each ── */

/* IID_IEnumVARIANT for MinGW */
static const IID LOCAL_IID_IEnumVARIANT =
    {0x00020404, 0x0000, 0x0000, {0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}};

OLE_API void* ole_enum_begin(void* pDisp) {
    if (!pDisp) { set_error(E_POINTER, "pDisp is NULL"); return NULL; }

    /* Try DISPID_NEWENUM (-4) first, then GetIDsOfNames("_NewEnum") */
    DISPID dispid = DISPID_NEWENUM;
    DISPPARAMS dp = {NULL, NULL, 0, 0};
    VARIANT vtResult;
    VariantInit(&vtResult);
    EXCEPINFO excep;
    memset(&excep, 0, sizeof(excep));

    /* Try DISPATCH_PROPERTYGET | DISPATCH_METHOD with DISPID_NEWENUM */
    HRESULT hr = IDispatch_Invoke((IDispatch*)pDisp, dispid, &IID_NULL,
        LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET | DISPATCH_METHOD,
        &dp, &vtResult, &excep, NULL);

    if (FAILED(hr)) {
        /* Fallback: resolve _NewEnum by name */
        wchar_t enumName[] = L"_NewEnum";
        LPOLESTR pName = enumName;
        HRESULT hr2 = IDispatch_GetIDsOfNames((IDispatch*)pDisp, &IID_NULL, &pName, 1,
                                      LOCALE_USER_DEFAULT, &dispid);
        if (SUCCEEDED(hr2)) {
            VariantInit(&vtResult);
            memset(&excep, 0, sizeof(excep));
            hr = IDispatch_Invoke((IDispatch*)pDisp, dispid, &IID_NULL,
                LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET | DISPATCH_METHOD,
                &dp, &vtResult, &excep, NULL);
        }
    }

    if (FAILED(hr)) {
        set_error(hr, "_NewEnum failed");
        return NULL;
    }

    /* QI for IEnumVARIANT */
    IEnumVARIANT* pEnum = NULL;
    if (V_VT(&vtResult) == VT_UNKNOWN && V_UNKNOWN(&vtResult)) {
        hr = IUnknown_QueryInterface(V_UNKNOWN(&vtResult),
            &LOCAL_IID_IEnumVARIANT, (void**)&pEnum);
        IUnknown_Release(V_UNKNOWN(&vtResult));
    } else if (V_VT(&vtResult) == VT_DISPATCH && V_DISPATCH(&vtResult)) {
        hr = IDispatch_QueryInterface(V_DISPATCH(&vtResult),
            &LOCAL_IID_IEnumVARIANT, (void**)&pEnum);
        IDispatch_Release(V_DISPATCH(&vtResult));
    } else {
        VariantClear(&vtResult);
        set_error(E_NOINTERFACE, "_NewEnum returned unexpected type");
        return NULL;
    }

    if (FAILED(hr) || !pEnum) {
        set_error(hr, "QI(IEnumVARIANT) failed");
        return NULL;
    }

    clear_error();
    return (void*)pEnum;
}

OLE_API int ole_enum_next(void* pEnum, ole_variant_t* result) {
    if (!pEnum) return 0;
    VARIANT vt;
    VariantInit(&vt);
    ULONG fetched = 0;
    HRESULT hr = IEnumVARIANT_Next((IEnumVARIANT*)pEnum, 1, &vt, &fetched);
    if (hr != S_OK || fetched == 0) {
        return 0;  /* end of enumeration */
    }
    if (result) {
        memcpy(result, &vt, sizeof(VARIANT));
    } else {
        VariantClear(&vt);
    }
    return 1;
}

OLE_API void ole_enum_release(void* pEnum) {
    if (pEnum) {
        IEnumVARIANT_Release((IEnumVARIANT*)pEnum);
    }
}

/* ── Error Info ── */

OLE_API const char* ole_last_error(void) {
    return g_lastError;
}

OLE_API int ole_last_hresult(void) {
    return (int)g_lastHR;
}
