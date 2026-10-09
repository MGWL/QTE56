#pragma once

#ifdef _WIN32
  #ifdef QTE56_QOBJECT_BUILD
    #define QOBJECT_API __declspec(dllexport)
  #else
    #define QOBJECT_API __declspec(dllimport)
  #endif
#else
  #define QOBJECT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QOBJECT_API void* qteQObject_create(void* parent);
QOBJECT_API void  qteQObject_delete(void* _obj);

// ── Methods ──────────────────────────────────────────────────────────────
QOBJECT_API void* qteQObject_objectName(void* _obj);
QOBJECT_API void  qteQObject_setObjectName(void* _obj, void* p0);
QOBJECT_API void  qteQObject_deleteLater(void* _obj);
QOBJECT_API int   qteQObject_blockSignals(void* _obj, int block);
QOBJECT_API int   qteQObject_signalsBlocked(void* _obj);
QOBJECT_API void* qteQObject_parent(void* _obj);
QOBJECT_API int   qteQObject_inherits(void* _obj, const char* className);

// ── Thread affinity ─────────────────────────────────────────────────────────
QOBJECT_API void* qteQObject_thread(void* _obj);
QOBJECT_API void  qteQObject_moveToThread(void* _obj, void* thread);

// ── Timers ──────────────────────────────────────────────────────────────────
QOBJECT_API int   qteQObject_startTimer(void* _obj, int interval, int timerType);
QOBJECT_API void  qteQObject_killTimer(void* _obj, int id);

// ── Object tree ─────────────────────────────────────────────────────────────
QOBJECT_API void  qteQObject_setParent(void* _obj, void* parent);
QOBJECT_API int   qteQObject_isWidgetType(void* _obj);
QOBJECT_API int   qteQObject_isWindowType(void* _obj);
QOBJECT_API int   qteQObject_childrenCount(void* _obj);
QOBJECT_API void* qteQObject_childrenAt(void* _obj, int index);

// ── Event handling ──────────────────────────────────────────────────────────
QOBJECT_API int   qteQObject_event(void* _obj, void* event);
QOBJECT_API int   qteQObject_eventFilter(void* _obj, void* watched, void* event);
QOBJECT_API void  qteQObject_installEventFilter(void* _obj, void* filterObj);
QOBJECT_API void  qteQObject_removeEventFilter(void* _obj, void* filterObj);

// ── Debug/introspection ─────────────────────────────────────────────────────
QOBJECT_API void  qteQObject_dumpObjectTree(void* _obj);
QOBJECT_API void  qteQObject_dumpObjectInfo(void* _obj);

// ── Signals (lambda-connect for Qt-pointer parameters) ──────────────────────
QOBJECT_API void  qteQObject_connect_destroyed(void* _obj, void* cb, void* dthis);

} // extern "C"
