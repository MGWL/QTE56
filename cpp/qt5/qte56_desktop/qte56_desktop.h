#pragma once
// qte56_desktop.h — C-обёртки для QDesktopWidget (статические запросы экранов)
// Индексы 20149–20154

#ifdef _WIN32
#  ifdef QTE56_DESKTOP_BUILD
#    define DESKTOP_API extern "C" __declspec(dllexport)
#  else
#    define DESKTOP_API extern "C" __declspec(dllimport)
#  endif
#else
#  define DESKTOP_API extern "C"
#endif

// 20149 — число подключённых мониторов
DESKTOP_API int  qteQDesktopWidget_screenCount();

// 20150 — индекс основного монитора (обычно 0)
DESKTOP_API int  qteQDesktopWidget_primaryScreen();

// 20151 — полная геометрия экрана (включая taskbar)
DESKTOP_API void qteQDesktopWidget_screenGeometry(int screen,
                     int* x, int* y, int* w, int* h);

// 20152 — рабочая область экрана (без taskbar, dock и т.д.)
DESKTOP_API void qteQDesktopWidget_availableGeometry(int screen,
                     int* x, int* y, int* w, int* h);

// 20153 — индекс экрана, содержащего точку (x, y) в глобальных координатах
DESKTOP_API int  qteQDesktopWidget_screenNumberAt(int x, int y);

// 20154 — индекс экрана, на котором находится виджет
DESKTOP_API int  qteQDesktopWidget_screenNumberOf(void* widget);
