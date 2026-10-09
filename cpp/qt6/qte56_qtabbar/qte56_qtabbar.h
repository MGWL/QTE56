#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTABBAR_BUILD
    #define QTABBAR_API __declspec(dllexport)
  #else
    #define QTABBAR_API __declspec(dllimport)
  #endif
#else
  #define QTABBAR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTABBAR_API void* qteQTabBar_create(void* parent);
QTABBAR_API void  qteQTabBar_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTABBAR_API void qteQTabBar_show(void* _obj);
QTABBAR_API void qteQTabBar_hide(void* _obj);
QTABBAR_API void qteQTabBar_update(void* _obj);
QTABBAR_API int qteQTabBar_shape(void* _obj);
QTABBAR_API void qteQTabBar_setShape(void* _obj, int shape);
QTABBAR_API int qteQTabBar_addTab_s(void* _obj, void* text);
QTABBAR_API int qteQTabBar_addTab_ps(void* _obj, void* icon, void* text);
QTABBAR_API int qteQTabBar_insertTab(void* _obj, int index, void* text);
QTABBAR_API void qteQTabBar_removeTab(void* _obj, int index);
QTABBAR_API void qteQTabBar_moveTab(void* _obj, int from, int to);
QTABBAR_API int qteQTabBar_isTabEnabled(void* _obj, int index);
QTABBAR_API void qteQTabBar_setTabEnabled(void* _obj, int index, int p1);
QTABBAR_API void* qteQTabBar_tabText(void* _obj, int index);
QTABBAR_API void qteQTabBar_setTabText(void* _obj, int index, void* text);
QTABBAR_API void* qteQTabBar_tabTextColor(void* _obj, int index);
QTABBAR_API void qteQTabBar_setTabTextColor(void* _obj, int index, void* color);
QTABBAR_API void* qteQTabBar_tabIcon(void* _obj, int index);
QTABBAR_API void qteQTabBar_setTabIcon(void* _obj, int index, void* icon);
QTABBAR_API int qteQTabBar_elideMode(void* _obj);
QTABBAR_API void qteQTabBar_setElideMode(void* _obj, int p0);
QTABBAR_API void qteQTabBar_setTabToolTip(void* _obj, int index, void* tip);
QTABBAR_API void* qteQTabBar_tabToolTip(void* _obj, int index);
QTABBAR_API void qteQTabBar_setTabWhatsThis(void* _obj, int index, void* text);
QTABBAR_API void* qteQTabBar_tabWhatsThis(void* _obj, int index);
QTABBAR_API void* qteQTabBar_tabRect(void* _obj, int index);
QTABBAR_API int qteQTabBar_tabAt(void* _obj, void* pos);
QTABBAR_API int qteQTabBar_currentIndex(void* _obj);
QTABBAR_API int qteQTabBar_count(void* _obj);
QTABBAR_API void* qteQTabBar_sizeHint(void* _obj);
QTABBAR_API void* qteQTabBar_minimumSizeHint(void* _obj);
QTABBAR_API void qteQTabBar_setDrawBase(void* _obj, int drawTheBase);
QTABBAR_API int qteQTabBar_drawBase(void* _obj);
QTABBAR_API void* qteQTabBar_iconSize(void* _obj);
QTABBAR_API void qteQTabBar_setIconSize(void* _obj, void* size);
QTABBAR_API int qteQTabBar_usesScrollButtons(void* _obj);
QTABBAR_API void qteQTabBar_setUsesScrollButtons(void* _obj, int useButtons);
QTABBAR_API int qteQTabBar_tabsClosable(void* _obj);
QTABBAR_API void qteQTabBar_setTabsClosable(void* _obj, int closable);
QTABBAR_API void qteQTabBar_setTabButton(void* _obj, int index, int position, void* widget);
QTABBAR_API void* qteQTabBar_tabButton(void* _obj, int index, int position);
QTABBAR_API int qteQTabBar_selectionBehaviorOnRemove(void* _obj);
QTABBAR_API void qteQTabBar_setSelectionBehaviorOnRemove(void* _obj, int behavior);
QTABBAR_API int qteQTabBar_expanding(void* _obj);
QTABBAR_API void qteQTabBar_setExpanding(void* _obj, int enabled);
QTABBAR_API int qteQTabBar_isMovable(void* _obj);
QTABBAR_API void qteQTabBar_setMovable(void* _obj, int movable);
QTABBAR_API int qteQTabBar_documentMode(void* _obj);
QTABBAR_API void qteQTabBar_setDocumentMode(void* _obj, int set);
QTABBAR_API int qteQTabBar_autoHide(void* _obj);
QTABBAR_API void qteQTabBar_setAutoHide(void* _obj, int hide);
QTABBAR_API int qteQTabBar_changeCurrentOnDrag(void* _obj);
QTABBAR_API void qteQTabBar_setChangeCurrentOnDrag(void* _obj, int change);
QTABBAR_API void* qteQTabBar_accessibleTabName(void* _obj, int index);
QTABBAR_API void qteQTabBar_setAccessibleTabName(void* _obj, int index, void* name);
QTABBAR_API void qteQTabBar_setCurrentIndex(void* _obj, int index);

// ── Event handler ────────────────────────────────────────────────────────────
QTABBAR_API void qteQTabBar_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
