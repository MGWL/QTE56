#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTSCROLLAREA_BUILD
    #define QABSTRACTSCROLLAREA_API __declspec(dllexport)
  #else
    #define QABSTRACTSCROLLAREA_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTSCROLLAREA_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_create(void* parent);
QABSTRACTSCROLLAREA_API void  qteQAbstractScrollArea_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QABSTRACTSCROLLAREA_API int qteQAbstractScrollArea_verticalScrollBarPolicy(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setVerticalScrollBarPolicy(void* _obj, int p0);
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_verticalScrollBar(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setVerticalScrollBar(void* _obj, void* scrollbar);
QABSTRACTSCROLLAREA_API int qteQAbstractScrollArea_horizontalScrollBarPolicy(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setHorizontalScrollBarPolicy(void* _obj, int p0);
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_horizontalScrollBar(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setHorizontalScrollBar(void* _obj, void* scrollbar);
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_cornerWidget(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setCornerWidget(void* _obj, void* widget);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_addScrollBarWidget(void* _obj, void* widget, int alignment);
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_viewport(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setViewport(void* _obj, void* widget);
QABSTRACTSCROLLAREA_API void* qteQAbstractScrollArea_maximumViewportSize(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setupViewport(void* _obj, void* viewport);
QABSTRACTSCROLLAREA_API int qteQAbstractScrollArea_sizeAdjustPolicy(void* _obj);
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setSizeAdjustPolicy(void* _obj, int policy);

// ── Event handler ────────────────────────────────────────────────────────────
QABSTRACTSCROLLAREA_API void qteQAbstractScrollArea_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
