#pragma once
#include <cstdint>

#ifdef _WIN32
  #ifdef QTE56_QWIDGET_BUILD
    #define QWIDGET_API __declspec(dllexport)
  #else
    #define QWIDGET_API __declspec(dllimport)
  #endif
#else
  #define QWIDGET_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QWIDGET_API void* qteQWidget_create(void* parent);
QWIDGET_API void  qteQWidget_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QWIDGET_API int qteQWidget_devType(void* _obj);
QWIDGET_API intptr_t qteQWidget_winId(void* _obj);
QWIDGET_API void qteQWidget_createWinId(void* _obj);
QWIDGET_API intptr_t qteQWidget_effectiveWinId(void* _obj);
QWIDGET_API void qteQWidget_setStyle(void* _obj, void* p0);
QWIDGET_API int qteQWidget_isTopLevel(void* _obj);
QWIDGET_API int qteQWidget_isWindow(void* _obj);
QWIDGET_API int qteQWidget_isModal(void* _obj);
QWIDGET_API int qteQWidget_windowModality(void* _obj);
QWIDGET_API void qteQWidget_setWindowModality(void* _obj, int windowModality);
QWIDGET_API int qteQWidget_isEnabled(void* _obj);
QWIDGET_API int qteQWidget_isEnabledTo(void* _obj, void* p0);
QWIDGET_API int qteQWidget_isEnabledToTLW(void* _obj);
QWIDGET_API void qteQWidget_setEnabled(void* _obj, int p0);
QWIDGET_API void qteQWidget_setDisabled(void* _obj, int p0);
QWIDGET_API void qteQWidget_setWindowModified(void* _obj, int p0);
QWIDGET_API void* qteQWidget_frameGeometry(void* _obj);
QWIDGET_API void* qteQWidget_normalGeometry(void* _obj);
QWIDGET_API int qteQWidget_x(void* _obj);
QWIDGET_API int qteQWidget_y(void* _obj);
QWIDGET_API void* qteQWidget_pos(void* _obj);
QWIDGET_API void* qteQWidget_frameSize(void* _obj);
QWIDGET_API void* qteQWidget_size(void* _obj);
QWIDGET_API int qteQWidget_width(void* _obj);
QWIDGET_API int qteQWidget_height(void* _obj);
QWIDGET_API void* qteQWidget_rect(void* _obj);
QWIDGET_API void* qteQWidget_childrenRect(void* _obj);
QWIDGET_API void* qteQWidget_minimumSize(void* _obj);
QWIDGET_API void* qteQWidget_maximumSize(void* _obj);
QWIDGET_API int qteQWidget_minimumWidth(void* _obj);
QWIDGET_API int qteQWidget_minimumHeight(void* _obj);
QWIDGET_API int qteQWidget_maximumWidth(void* _obj);
QWIDGET_API int qteQWidget_maximumHeight(void* _obj);
QWIDGET_API void qteQWidget_setMinimumSize_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setMinimumSize_ii(void* _obj, int minw, int minh);
QWIDGET_API void qteQWidget_setMaximumSize_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setMaximumSize_ii(void* _obj, int maxw, int maxh);
QWIDGET_API void qteQWidget_setMinimumWidth(void* _obj, int minw);
QWIDGET_API void qteQWidget_setMinimumHeight(void* _obj, int minh);
QWIDGET_API void qteQWidget_setMaximumWidth(void* _obj, int maxw);
QWIDGET_API void qteQWidget_setMaximumHeight(void* _obj, int maxh);
QWIDGET_API void* qteQWidget_sizeIncrement(void* _obj);
QWIDGET_API void qteQWidget_setSizeIncrement_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setSizeIncrement_ii(void* _obj, int w, int h);
QWIDGET_API void* qteQWidget_baseSize(void* _obj);
QWIDGET_API void qteQWidget_setBaseSize_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setBaseSize_ii(void* _obj, int basew, int baseh);
QWIDGET_API void qteQWidget_setFixedSize_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setFixedSize_ii(void* _obj, int w, int h);
QWIDGET_API void qteQWidget_setFixedWidth(void* _obj, int w);
QWIDGET_API void qteQWidget_setFixedHeight(void* _obj, int h);
QWIDGET_API void* qteQWidget_mapToGlobal(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_mapFromGlobal(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_mapToParent(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_mapFromParent(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_mapTo(void* _obj, void* p0, void* p1);
QWIDGET_API void* qteQWidget_mapFrom(void* _obj, void* p0, void* p1);
QWIDGET_API void qteQWidget_setBackgroundRole(void* _obj, int p0);
QWIDGET_API int qteQWidget_backgroundRole(void* _obj);
QWIDGET_API void qteQWidget_setForegroundRole(void* _obj, int p0);
QWIDGET_API int qteQWidget_foregroundRole(void* _obj);
QWIDGET_API void qteQWidget_unsetCursor(void* _obj);
QWIDGET_API void qteQWidget_setMouseTracking(void* _obj, int enable);
QWIDGET_API int qteQWidget_hasMouseTracking(void* _obj);
QWIDGET_API int qteQWidget_underMouse(void* _obj);
QWIDGET_API void qteQWidget_setTabletTracking(void* _obj, int enable);
QWIDGET_API int qteQWidget_hasTabletTracking(void* _obj);
QWIDGET_API void qteQWidget_clearMask(void* _obj);
QWIDGET_API void qteQWidget_setGraphicsEffect(void* _obj, void* effect);
QWIDGET_API void qteQWidget_ungrabGesture(void* _obj, int type);
QWIDGET_API void qteQWidget_setWindowTitle(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setStyleSheet(void* _obj, void* styleSheet);
QWIDGET_API void* qteQWidget_styleSheet(void* _obj);
QWIDGET_API void* qteQWidget_windowTitle(void* _obj);
QWIDGET_API void qteQWidget_setWindowIconText(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_windowIconText(void* _obj);
QWIDGET_API void qteQWidget_setWindowRole(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_windowRole(void* _obj);
QWIDGET_API void qteQWidget_setWindowFilePath(void* _obj, void* filePath);
QWIDGET_API void* qteQWidget_windowFilePath(void* _obj);
QWIDGET_API void qteQWidget_setWindowOpacity(void* _obj, double level);
QWIDGET_API double qteQWidget_windowOpacity(void* _obj);
QWIDGET_API int qteQWidget_isWindowModified(void* _obj);
QWIDGET_API void qteQWidget_setToolTip(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_toolTip(void* _obj);
QWIDGET_API void qteQWidget_setToolTipDuration(void* _obj, int msec);
QWIDGET_API int qteQWidget_toolTipDuration(void* _obj);
QWIDGET_API void qteQWidget_setStatusTip(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_statusTip(void* _obj);
QWIDGET_API void qteQWidget_setWhatsThis(void* _obj, void* p0);
QWIDGET_API void* qteQWidget_whatsThis(void* _obj);
QWIDGET_API void* qteQWidget_accessibleName(void* _obj);
QWIDGET_API void qteQWidget_setAccessibleName(void* _obj, void* name);
QWIDGET_API void* qteQWidget_accessibleDescription(void* _obj);
QWIDGET_API void qteQWidget_setAccessibleDescription(void* _obj, void* description);
QWIDGET_API void qteQWidget_setLayoutDirection(void* _obj, int direction);
QWIDGET_API int qteQWidget_layoutDirection(void* _obj);
QWIDGET_API void qteQWidget_unsetLayoutDirection(void* _obj);
QWIDGET_API void qteQWidget_unsetLocale(void* _obj);
QWIDGET_API int qteQWidget_isActiveWindow(void* _obj);
QWIDGET_API void qteQWidget_activateWindow(void* _obj);
QWIDGET_API void qteQWidget_clearFocus(void* _obj);
QWIDGET_API void qteQWidget_setFocus(void* _obj, int reason);
QWIDGET_API int qteQWidget_focusPolicy(void* _obj);
QWIDGET_API void qteQWidget_setFocusPolicy(void* _obj, int policy);
QWIDGET_API int qteQWidget_hasFocus(void* _obj);
QWIDGET_API void qteQWidget_setTabOrder(void* _obj, void* p0, void* p1);
QWIDGET_API void qteQWidget_setFocusProxy(void* _obj, void* p0);
QWIDGET_API int qteQWidget_contextMenuPolicy(void* _obj);
QWIDGET_API void qteQWidget_setContextMenuPolicy(void* _obj, int policy);
QWIDGET_API void qteQWidget_grabMouse(void* _obj);
QWIDGET_API void qteQWidget_releaseMouse(void* _obj);
QWIDGET_API void qteQWidget_grabKeyboard(void* _obj);
QWIDGET_API void qteQWidget_releaseKeyboard(void* _obj);
QWIDGET_API void qteQWidget_releaseShortcut(void* _obj, int id);
QWIDGET_API void qteQWidget_setShortcutEnabled(void* _obj, int id, int enable);
QWIDGET_API void qteQWidget_setShortcutAutoRepeat(void* _obj, int id, int enable);
QWIDGET_API int qteQWidget_updatesEnabled(void* _obj);
QWIDGET_API void qteQWidget_setUpdatesEnabled(void* _obj, int enable);
QWIDGET_API void qteQWidget_update_v(void* _obj);
QWIDGET_API void qteQWidget_repaint_v(void* _obj);
QWIDGET_API void qteQWidget_update_iiii(void* _obj, int x, int y, int w, int h);
QWIDGET_API void qteQWidget_repaint_iiii(void* _obj, int x, int y, int w, int h);
QWIDGET_API void qteQWidget_repaint_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setVisible(void* _obj, int visible);
QWIDGET_API void qteQWidget_setHidden(void* _obj, int hidden);
QWIDGET_API void qteQWidget_show(void* _obj);
QWIDGET_API void qteQWidget_hide(void* _obj);
QWIDGET_API void qteQWidget_showMinimized(void* _obj);
QWIDGET_API void qteQWidget_showMaximized(void* _obj);
QWIDGET_API void qteQWidget_showFullScreen(void* _obj);
QWIDGET_API void qteQWidget_showNormal(void* _obj);
QWIDGET_API int qteQWidget_close(void* _obj);
QWIDGET_API void qteQWidget_raise(void* _obj);
QWIDGET_API void qteQWidget_lower(void* _obj);
QWIDGET_API void qteQWidget_stackUnder(void* _obj, void* p0);
QWIDGET_API void qteQWidget_move_ii(void* _obj, int x, int y);
QWIDGET_API void qteQWidget_move_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_resize_ii(void* _obj, int w, int h);
QWIDGET_API void qteQWidget_resize_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_setGeometry_iiii(void* _obj, int x, int y, int w, int h);
QWIDGET_API void qteQWidget_setGeometry_p(void* _obj, void* p0);
QWIDGET_API void qteQWidget_adjustSize(void* _obj);
QWIDGET_API int qteQWidget_isVisible(void* _obj);
QWIDGET_API int qteQWidget_isVisibleTo(void* _obj, void* p0);
QWIDGET_API int qteQWidget_isHidden(void* _obj);
QWIDGET_API int qteQWidget_isMinimized(void* _obj);
QWIDGET_API int qteQWidget_isMaximized(void* _obj);
QWIDGET_API int qteQWidget_isFullScreen(void* _obj);
QWIDGET_API int qteQWidget_windowState(void* _obj);
QWIDGET_API void qteQWidget_setWindowState(void* _obj, int state);
QWIDGET_API void qteQWidget_overrideWindowState(void* _obj, int state);
QWIDGET_API void* qteQWidget_sizeHint(void* _obj);
QWIDGET_API void* qteQWidget_minimumSizeHint(void* _obj);
QWIDGET_API void qteQWidget_setSizePolicy(void* _obj, int horizontal, int vertical);
QWIDGET_API int qteQWidget_heightForWidth(void* _obj, int p0);
QWIDGET_API int qteQWidget_hasHeightForWidth(void* _obj);
QWIDGET_API void qteQWidget_setContentsMargins(void* _obj, int left, int top, int right, int bottom);
QWIDGET_API void qteQWidget_getContentsMargins(void* _obj, void* left, void* top, void* right, void* bottom);
QWIDGET_API void* qteQWidget_contentsRect(void* _obj);
QWIDGET_API void qteQWidget_setLayout(void* _obj, void* p0);
QWIDGET_API void qteQWidget_updateGeometry(void* _obj);
QWIDGET_API void qteQWidget_setParent_w(void* _obj, void* parent);
QWIDGET_API void qteQWidget_setParent_wp(void* _obj, void* parent, int f);
QWIDGET_API void qteQWidget_scroll(void* _obj, int dx, int dy);
QWIDGET_API int qteQWidget_acceptDrops(void* _obj);
QWIDGET_API void qteQWidget_setAcceptDrops(void* _obj, int on);
QWIDGET_API void qteQWidget_addAction(void* _obj, void* action);
QWIDGET_API void qteQWidget_insertAction(void* _obj, void* before, void* action);
QWIDGET_API void qteQWidget_removeAction(void* _obj, void* action);
QWIDGET_API void qteQWidget_setWindowFlags(void* _obj, int type);
QWIDGET_API int qteQWidget_windowFlags(void* _obj);
QWIDGET_API void qteQWidget_setWindowFlag(void* _obj, int p0, int on);
QWIDGET_API void qteQWidget_overrideWindowFlags(void* _obj, int type);
QWIDGET_API int qteQWidget_windowType(void* _obj);
QWIDGET_API void qteQWidget_setAttribute(void* _obj, int p0, int on);
QWIDGET_API int qteQWidget_testAttribute(void* _obj, int p0);
QWIDGET_API void qteQWidget_ensurePolished(void* _obj);
QWIDGET_API int qteQWidget_isAncestorOf(void* _obj, void* child);
QWIDGET_API int qteQWidget_autoFillBackground(void* _obj);
QWIDGET_API void qteQWidget_setAutoFillBackground(void* _obj, int enabled);
QWIDGET_API int qteQWidget_inputMethodHints(void* _obj);
QWIDGET_API void qteQWidget_setInputMethodHints(void* _obj, int hints);

// ── Event handler ────────────────────────────────────────────────────────────
QWIDGET_API void qteQWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

// ── Geometry persistence (QByteArray*) ───────────────────────────────────────
QWIDGET_API void* qteQWidget_saveGeometry(void* w);                    // 398
QWIDGET_API int   qteQWidget_restoreGeometry(void* w, const void* data, int len); // 399

} // extern "C"
