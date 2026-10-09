#pragma once

#ifdef _WIN32
#  define WINSP_API extern "C" __declspec(dllexport)
#else
#  define WINSP_API extern "C" __attribute__((visibility("default")))
#endif

extern "C" {
#include "wren.h"
}

// Registration functions — called from wren_bridge.cpp's dispatch callbacks
WrenForeignMethodFn winsp_bindForeignMethod(const char* module, const char* className,
                                             bool isStatic, const char* signature);
WrenForeignClassMethods winsp_bindForeignClass(const char* module, const char* className);
const char* winsp_getModuleSource(const char* name);

// Exported to D-side: attach QPlainTextEdit panels for Monitor and Console output
WINSP_API void winsp_setMonitorWidget(void* plainTextEdit);
WINSP_API void winsp_setConsoleWidget(void* plainTextEdit);

// Named pointer registry — call from D to expose arbitrary memory to Wren Inspector
WINSP_API void winsp_registerPointer  (const char* name, void* ptr);
WINSP_API void winsp_unregisterPointer(const char* name);
WINSP_API void winsp_clearPointers    ();
