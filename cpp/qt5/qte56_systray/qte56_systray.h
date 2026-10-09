#pragma once

#ifdef _WIN32
  #ifdef QTE56_SYSTRAY_BUILD
    #define SYSTRAY_API __declspec(dllexport)
  #else
    #define SYSTRAY_API __declspec(dllimport)
  #endif
#else
  #define SYSTRAY_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QSplashScreen (19788–19796) ───────────────────────────────────────────────

SYSTRAY_API void* qteQSplashScreen_create(void* pixmap);
SYSTRAY_API void  qteQSplashScreen_delete(void* ss);
SYSTRAY_API void  qteQSplashScreen_show(void* ss);
SYSTRAY_API void  qteQSplashScreen_close(void* ss);
SYSTRAY_API void  qteQSplashScreen_showMessage(void* ss, void* msg,
                                                int alignment, unsigned int rgba);
SYSTRAY_API void  qteQSplashScreen_clearMessage(void* ss);
SYSTRAY_API void  qteQSplashScreen_finish(void* ss, void* main_window);
SYSTRAY_API void  qteQSplashScreen_repaint(void* ss);
SYSTRAY_API void  qteQSplashScreen_setPixmap(void* ss, void* pixmap);

// ── QSystemTrayIcon (19797–19809) ─────────────────────────────────────────────

SYSTRAY_API void* qteQSystemTrayIcon_create();
SYSTRAY_API void  qteQSystemTrayIcon_delete(void* tray);
SYSTRAY_API void  qteQSystemTrayIcon_setIcon(void* tray, void* icon);
SYSTRAY_API void  qteQSystemTrayIcon_setToolTip(void* tray, void* tip);
SYSTRAY_API void  qteQSystemTrayIcon_show(void* tray);
SYSTRAY_API void  qteQSystemTrayIcon_hide(void* tray);
SYSTRAY_API int   qteQSystemTrayIcon_isVisible(void* tray);
SYSTRAY_API void  qteQSystemTrayIcon_showMessage(void* tray,
                                                  void* title,
                                                  void* msg,
                                                  int icon, int msec);
SYSTRAY_API void  qteQSystemTrayIcon_setContextMenu(void* tray, void* menu);
SYSTRAY_API void  qteQSystemTrayIcon_connect_activated(void* tray, void (*cb)(int));
SYSTRAY_API void  qteQSystemTrayIcon_connect_messageClicked(void* tray, void (*cb)());
SYSTRAY_API void  qteQSystemTrayIcon_geometry(void* tray,
                                               int* x, int* y, int* w, int* h);
SYSTRAY_API int   qteQSystemTrayIcon_supportsMessages();

} // extern "C"
