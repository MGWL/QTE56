#pragma once

#ifdef _WIN32
  #ifdef QTE56_QMENU_BUILD
    #define QMENU_API __declspec(dllexport)
  #else
    #define QMENU_API __declspec(dllimport)
  #endif
#else
  #define QMENU_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QMENU_API void* qteQMenu_create(void* parent);
QMENU_API void  qteQMenu_delete(void* w);
QMENU_API void* qteQMenu_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QMENU_API void* qteQMenu_addAction_s(void* _obj, void* text);
QMENU_API void* qteQMenu_addAction_sp(void* _obj, void* text, int functor);
QMENU_API void* qteQMenu_addAction_sop(void* _obj, void* text, void* context, int functor);
QMENU_API void* qteQMenu_addMenu_p(void* _obj, void* menu);
QMENU_API void* qteQMenu_addMenu_s(void* _obj, void* title);
QMENU_API void* qteQMenu_addSeparator(void* _obj);
QMENU_API void* qteQMenu_addSection(void* _obj, void* text);
QMENU_API void* qteQMenu_insertMenu(void* _obj, void* before, void* menu);
QMENU_API void* qteQMenu_insertSeparator(void* _obj, void* before);
QMENU_API void* qteQMenu_insertSection(void* _obj, void* before, void* text);
QMENU_API int qteQMenu_isEmpty(void* _obj);
QMENU_API void qteQMenu_clear(void* _obj);
QMENU_API void qteQMenu_setTearOffEnabled(void* _obj, int p0);
QMENU_API int qteQMenu_isTearOffEnabled(void* _obj);
QMENU_API int qteQMenu_isTearOffMenuVisible(void* _obj);
QMENU_API void qteQMenu_showTearOffMenu_v(void* _obj);
QMENU_API void qteQMenu_showTearOffMenu_p(void* _obj, void* pos);
QMENU_API void qteQMenu_hideTearOffMenu(void* _obj);
QMENU_API void qteQMenu_setDefaultAction(void* _obj, void* p0);
QMENU_API void* qteQMenu_defaultAction(void* _obj);
QMENU_API void qteQMenu_setActiveAction(void* _obj, void* act);
QMENU_API void* qteQMenu_activeAction(void* _obj);
QMENU_API void qteQMenu_popup(void* _obj, void* pos, void* at);
QMENU_API void* qteQMenu_exec_v(void* _obj);
QMENU_API void* qteQMenu_exec_pp(void* _obj, void* pos, void* at);
QMENU_API void* qteQMenu_actionGeometry(void* _obj, void* p0);
QMENU_API void* qteQMenu_actionAt(void* _obj, void* p0);
QMENU_API void* qteQMenu_menuAction(void* _obj);
QMENU_API void* qteQMenu_title(void* _obj);
QMENU_API void qteQMenu_setTitle(void* _obj, void* title);
QMENU_API void qteQMenu_setNoReplayFor(void* _obj, void* widget);
QMENU_API void* qteQMenu_platformMenu(void* _obj);
QMENU_API void qteQMenu_setPlatformMenu(void* _obj, void* platformMenu);
QMENU_API void qteQMenu_setAsDockMenu(void* _obj);
QMENU_API int qteQMenu_separatorsCollapsible(void* _obj);
QMENU_API void qteQMenu_setSeparatorsCollapsible(void* _obj, int collapse);
QMENU_API int qteQMenu_toolTipsVisible(void* _obj);
QMENU_API void qteQMenu_setToolTipsVisible(void* _obj, int visible);

// ── Icon-based methods ───────────────────────────────────────────────────────
QMENU_API void* qteQMenu_addAction_is(void* _obj, void* icon, void* text);
QMENU_API void  qteQMenu_addAction_p(void* _obj, void* action);
QMENU_API void  qteQMenu_setIcon(void* _obj, void* icon);
QMENU_API void* qteQMenu_icon(void* _obj);
QMENU_API void* qteQMenu_addMenu_is(void* _obj, void* icon, void* title);

// ── Signals with QAction* ─────────────────────────────────────────────────────
QMENU_API void qteQMenu_connect_triggered(void* obj, void (*cb)(void*, void*), void* ud);
QMENU_API void qteQMenu_connect_hovered(void* obj, void (*cb)(void*, void*), void* ud);
QMENU_API void qteQMenu_actionGeometry_xywh(void* obj, void* action, int* x, int* y, int* w, int* h);
// ── List queries ─────────────────────────────────────────────────────────────
QMENU_API void* qteQMenu_actions(void* _obj);

// ── Event handler ────────────────────────────────────────────────────────────
QMENU_API void qteQMenu_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
