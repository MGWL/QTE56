#pragma once
// qte56_filewatcher.h — C-обёртки для QFileSystemWatcher
// Индексы 20139–20148

#ifdef _WIN32
#  ifdef QTE56_FILEWATCHER_BUILD
#    define FW_API extern "C" __declspec(dllexport)
#  else
#    define FW_API extern "C" __declspec(dllimport)
#  endif
#else
#  define FW_API extern "C"
#endif

// 20139 — создать watcher
FW_API void* qteQFileSystemWatcher_create();

// 20140 — удалить watcher
FW_API void  qteQFileSystemWatcher_delete(void* w);

// 20141 — добавить путь; возвращает 1 если ОС взяла под наблюдение, 0 — ошибка/уже есть
FW_API int   qteQFileSystemWatcher_addPath(void* w, const wchar_t* path, int len);

// 20142 — добавить несколько путей (соединены через \x01)
FW_API void  qteQFileSystemWatcher_addPaths(void* w, const wchar_t* paths, int len);

// 20143 — убрать путь из наблюдения
FW_API void  qteQFileSystemWatcher_removePath(void* w, const wchar_t* path, int len);

// 20144 — убрать несколько путей (соединены через \x01)
FW_API void  qteQFileSystemWatcher_removePaths(void* w, const wchar_t* paths, int len);

// 20145 — список наблюдаемых файлов; возвращает new QString (пути через \x01)
FW_API void* qteQFileSystemWatcher_files(void* w);

// 20146 — список наблюдаемых директорий; возвращает new QString (пути через \x01)
FW_API void* qteQFileSystemWatcher_directories(void* w);

// 20147 — сигнал fileChanged(path); cb(wchar*, len, userdata)
FW_API void  qteQFileSystemWatcher_connect_fileChanged(void* w,
                  void (*cb)(const wchar_t*, int, void*), void* userdata);

// 20148 — сигнал directoryChanged(path); cb(wchar*, len, userdata)
FW_API void  qteQFileSystemWatcher_connect_directoryChanged(void* w,
                  void (*cb)(const wchar_t*, int, void*), void* userdata);
