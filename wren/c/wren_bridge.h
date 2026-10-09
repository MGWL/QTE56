#pragma once
#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#  define WREN_API __declspec(dllexport)
#else
#  define WREN_API __attribute__((visibility("default")))
#endif

/* Callbacks (called from DLL into D) */
typedef void (*WrenWriteCb)(const char* text, int len, void* ud);
typedef void (*WrenErrorCb)(const char* message, int len, void* ud);

/* VM lifecycle */
WREN_API void* wrenBridge_create(WrenWriteCb writeCb, WrenErrorCb errorCb, void* ud);
WREN_API void  wrenBridge_free(void* br);

/* Run Wren code */
WREN_API int   wrenBridge_interpret(void* br, const char* module, const char* source); /* 0=ok,1=compile,2=runtime */
WREN_API int   wrenBridge_loadFile(void* br, const char* module, const wchar_t* path, int pathLen); /* Windows UTF-16 */
WREN_API int   wrenBridge_loadFileUtf8(void* br, const char* module, const char* path); /* cross-platform UTF-8 */

/* Widget registry */
WREN_API void  wrenBridge_setWidget(void* br, const char* name, void* wh);
WREN_API void  wrenBridge_clearWidgets(void* br);

/* Module search paths — import "foo" will look for <path>/foo.wren */
WREN_API void  wrenBridge_addLibPath(void* br, const char* path);

/* Calling a static Wren method from D.
   Set args BEFORE calling, read result AFTER. */
WREN_API void  wrenBridge_argDouble(void* br, int slot, double val);
WREN_API void  wrenBridge_argString(void* br, int slot, const char* str);
WREN_API void  wrenBridge_argBool(void* br, int slot, int val);
WREN_API int   wrenBridge_call(void* br, const char* module, const char* className, const char* sig);

/* Read result (valid after successful call) */
WREN_API int         wrenBridge_resultType(void* br);   /* 0=num,1=bool,2=str,3=null,4=other */
WREN_API double      wrenBridge_resultDouble(void* br);
WREN_API int         wrenBridge_resultBool(void* br);
WREN_API const char* wrenBridge_resultString(void* br);

/* Check if a variable exists in a module */
WREN_API int wrenBridge_hasVariable(void* br, const char* module, const char* name);

#ifdef __cplusplus
}
#endif
