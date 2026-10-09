/*
 * ole_helper.h — C shim for COM/OLE Automation (IDispatch)
 * Standalone DLL, no Qt/QTE56 dependencies.
 * Build: gcc -shared -o ole_helper.dll ole_helper.c -lole32 -loleaut32 -luuid
 *
 * All name/string parameters are UTF-8 (const char*).
 * Conversion to wchar_t* is done internally in the C shim.
 */
#ifndef OLE_HELPER_H
#define OLE_HELPER_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef OLE_HELPER_EXPORTS
#define OLE_API __declspec(dllexport)
#else
#define OLE_API __declspec(dllimport)
#endif

/* ── OLE Variant (matches Windows VARIANT layout, 16 bytes on 32-bit) ── */
typedef struct {
    unsigned short vt;
    unsigned short reserved[3];
    union {
        int     intVal;     /* VT_I4   = 3  */
        double  dblVal;     /* VT_R8   = 5  */
        void*   ptrVal;     /* VT_BSTR = 8, VT_DISPATCH = 9 */
        short   boolVal;    /* VT_BOOL = 11 */
    };
} ole_variant_t;

/* VT constants */
#define OLE_VT_EMPTY     0
#define OLE_VT_I4         3
#define OLE_VT_R8         5
#define OLE_VT_BSTR       8
#define OLE_VT_DISPATCH   9
#define OLE_VT_BOOL      11

/* ── Lifecycle (5) ── */
OLE_API int   ole_init(void);
OLE_API void  ole_uninit(void);
OLE_API void* ole_create_object(const char* progid);   /* UTF-8 ProgID */
OLE_API void* ole_get_active_object(const char* progid); /* attach to running instance */
OLE_API void  ole_release(void* pDisp);

/* ── Core Invoke (3) — names are UTF-8 ── */
OLE_API int ole_invoke(void* pDisp, const char* name, int wFlags,
                       ole_variant_t* args, int nArgs, ole_variant_t* result);
OLE_API int ole_get_property(void* pDisp, const char* name,
                             ole_variant_t* args, int nArgs, ole_variant_t* result);
OLE_API int ole_set_property(void* pDisp, const char* name,
                             ole_variant_t* args, int nArgs);

/* ── Variant Helpers (14) ── */
OLE_API void          ole_var_init(ole_variant_t* v);
OLE_API void          ole_var_clear(ole_variant_t* v);
OLE_API void          ole_var_set_int(ole_variant_t* v, int val);
OLE_API void          ole_var_set_double(ole_variant_t* v, double val);
OLE_API void          ole_var_set_string(ole_variant_t* v, const char* utf8); /* UTF-8 → BSTR */
OLE_API void          ole_var_set_dispatch(ole_variant_t* v, void* pDisp);
OLE_API void          ole_var_set_bool(ole_variant_t* v, int val);
OLE_API void          ole_var_set_empty(ole_variant_t* v);
OLE_API unsigned short ole_var_get_type(const ole_variant_t* v);
OLE_API int           ole_var_get_int(const ole_variant_t* v);
OLE_API double        ole_var_get_double(const ole_variant_t* v);
OLE_API int           ole_var_get_string(const ole_variant_t* v, char* buf, int bufSize); /* BSTR → UTF-8, returns len */
OLE_API void*         ole_var_get_dispatch(const ole_variant_t* v);
OLE_API int           ole_var_get_bool(const ole_variant_t* v);

/* ── Enumeration — For Each (3) ── */
OLE_API void* ole_enum_begin(void* pDisp);                       /* → IEnumVARIANT* */
OLE_API int   ole_enum_next(void* pEnum, ole_variant_t* result); /* 1=ok, 0=end */
OLE_API void  ole_enum_release(void* pEnum);

/* VT_DATE (7) — OLE Automation date as double */
#define OLE_VT_DATE      7
OLE_API void   ole_var_set_date(ole_variant_t* v, double val);
OLE_API double ole_var_get_date(const ole_variant_t* v);

/* ── Error Info (2) ── */
OLE_API const char* ole_last_error(void);   /* UTF-8 error string */
OLE_API int         ole_last_hresult(void);

#ifdef __cplusplus
}
#endif

#endif /* OLE_HELPER_H */
