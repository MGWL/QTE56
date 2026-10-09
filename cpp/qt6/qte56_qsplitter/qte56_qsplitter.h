#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSPLITTER_BUILD
    #define QSPLITTER_API __declspec(dllexport)
  #else
    #define QSPLITTER_API __declspec(dllimport)
  #endif
#else
  #define QSPLITTER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSPLITTER_API void* qteQSplitter_create(void* parent);
QSPLITTER_API void  qteQSplitter_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSPLITTER_API void qteQSplitter_addWidget(void* _obj, void* widget);
QSPLITTER_API void qteQSplitter_insertWidget(void* _obj, int index, void* widget);
QSPLITTER_API void* qteQSplitter_replaceWidget(void* _obj, int index, void* widget);
QSPLITTER_API void qteQSplitter_setOrientation(void* _obj, int p0);
QSPLITTER_API int qteQSplitter_orientation(void* _obj);
QSPLITTER_API void qteQSplitter_setChildrenCollapsible(void* _obj, int p0);
QSPLITTER_API int qteQSplitter_childrenCollapsible(void* _obj);
QSPLITTER_API void qteQSplitter_setCollapsible(void* _obj, int index, int p1);
QSPLITTER_API int qteQSplitter_isCollapsible(void* _obj, int index);
QSPLITTER_API void qteQSplitter_setOpaqueResize(void* _obj, int opaque);
QSPLITTER_API int qteQSplitter_opaqueResize(void* _obj);
QSPLITTER_API void qteQSplitter_refresh(void* _obj);
QSPLITTER_API int qteQSplitter_handleWidth(void* _obj);
QSPLITTER_API void qteQSplitter_setHandleWidth(void* _obj, int p0);
QSPLITTER_API int qteQSplitter_indexOf(void* _obj, void* w);
QSPLITTER_API void* qteQSplitter_widget(void* _obj, int index);
QSPLITTER_API int qteQSplitter_count(void* _obj);
QSPLITTER_API void qteQSplitter_getRange(void* _obj, int index, void* p1, void* p2);
QSPLITTER_API void* qteQSplitter_handle(void* _obj, int index);
QSPLITTER_API void qteQSplitter_setStretchFactor(void* _obj, int index, int stretch);
// ── List queries ─────────────────────────────────────────────────────────────
QSPLITTER_API void* qteQSplitter_sizes(void* _obj);
QSPLITTER_API void  qteQSplitter_setSizes(void* _obj, void* qs_sizes);

// ── Event handler ────────────────────────────────────────────────────────────
QSPLITTER_API void qteQSplitter_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
