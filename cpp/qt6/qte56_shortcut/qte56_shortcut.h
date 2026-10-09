#pragma once
// qte56_shortcut.h — C-обёртки для QShortcut
// Индексы 20132–20138

#ifdef _WIN32
#  ifdef QTE56_SHORTCUT_BUILD
#    define SHORTCUT_API extern "C" __declspec(dllexport)
#  else
#    define SHORTCUT_API extern "C" __declspec(dllimport)
#  endif
#else
#  define SHORTCUT_API extern "C"
#endif

// 20132 — создать шорткат (parent=QWidget, key=строка QKeySequence, len)
SHORTCUT_API void* qteQShortcut_create(void* parent, const wchar_t* key, int len);

// 20133 — удалить шорткат
SHORTCUT_API void  qteQShortcut_delete(void* qs);

// 20134 — включить/выключить шорткат (v=0 → disabled)
SHORTCUT_API void  qteQShortcut_setEnabled(void* qs, int v);

// 20135 — проверить: шорткат включён?
SHORTCUT_API int   qteQShortcut_isEnabled(void* qs);

// 20136 — установить контекст (Qt::ShortcutContext): 0=Widget,1=Window,2=Application,3=WidgetWithChildren
SHORTCUT_API void  qteQShortcut_setContext(void* qs, int ctx);

// 20137 — подключить сигнал activated; cb(userdata) вызывается при срабатывании
SHORTCUT_API void  qteQShortcut_connect_activated(void* qs, void (*cb)(void*), void* userdata);

// 20138 — разрешить/запретить авто-повтор при удержании клавиши
SHORTCUT_API void  qteQShortcut_setAutoRepeat(void* qs, int v);
