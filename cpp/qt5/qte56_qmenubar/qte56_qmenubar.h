#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMENUBAR_BUILD
    #define QMENUBAR_API __declspec(dllexport)
  #else
    #define QMENUBAR_API __declspec(dllimport)
  #endif
#else
  #define QMENUBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMENUBAR_API void* qteQMenuBar_create(void* parent);
QMENUBAR_API void  qteQMenuBar_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QMENUBAR_API void* qteQMenuBar_addAction_s(void* _obj, void* text);
QMENUBAR_API void* qteQMenuBar_addAction_sp(void* _obj, void* text, int functor);
QMENUBAR_API void* qteQMenuBar_addMenu_p(void* _obj, void* menu);
QMENUBAR_API void* qteQMenuBar_addMenu_s(void* _obj, void* title);
QMENUBAR_API void* qteQMenuBar_addSeparator(void* _obj);
QMENUBAR_API void* qteQMenuBar_insertSeparator(void* _obj, void* before);
QMENUBAR_API void* qteQMenuBar_insertMenu(void* _obj, void* before, void* menu);
QMENUBAR_API void qteQMenuBar_clear(void* _obj);
QMENUBAR_API void* qteQMenuBar_activeAction(void* _obj);
QMENUBAR_API void qteQMenuBar_setActiveAction(void* _obj, void* action);
QMENUBAR_API void qteQMenuBar_setDefaultUp(void* _obj, int p0);
QMENUBAR_API int qteQMenuBar_isDefaultUp(void* _obj);
QMENUBAR_API void* qteQMenuBar_actionGeometry(void* _obj, void* p0);
QMENUBAR_API void* qteQMenuBar_actionAt(void* _obj, void* p0);
QMENUBAR_API void qteQMenuBar_setCornerWidget(void* _obj, void* w, int corner);
QMENUBAR_API void* qteQMenuBar_cornerWidget(void* _obj, int corner);
QMENUBAR_API int qteQMenuBar_isNativeMenuBar(void* _obj);
QMENUBAR_API void qteQMenuBar_setNativeMenuBar(void* _obj, int nativeMenuBar);
QMENUBAR_API void* qteQMenuBar_platformMenuBar(void* _obj);
// ── List queries ─────────────────────────────────────────────────────────────
QMENUBAR_API void* qteQMenuBar_actions(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QMENUBAR_API void qteQMenuBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
