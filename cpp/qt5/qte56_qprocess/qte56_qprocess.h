#pragma once

#ifdef _WIN32
#  ifdef QTE56_QPROCESS_BUILD
#    define QPROCESS_API __declspec(dllexport)
#  else
#    define QPROCESS_API __declspec(dllimport)
#  endif
#else
#  define QPROCESS_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QProcess (19816–19836) ────────────────────────────────────────────────────

QPROCESS_API void* qteQProcess_create();
QPROCESS_API void  qteQProcess_delete(void* proc);

// Запуск. args — строки, объединённые символом \x01 (или null если нет аргументов)
QPROCESS_API void  qteQProcess_start(void* proc, void* program, void* args);
// Статический запуск отсоединённого процесса. Возвращает 1=успех, 0=ошибка
QPROCESS_API int   qteQProcess_startDetached(void* program, void* args);

// Ожидание (мс). Возвращает 1=дождались, 0=таймаут
QPROCESS_API int   qteQProcess_waitForStarted(void* proc, int msec);
QPROCESS_API int   qteQProcess_waitForFinished(void* proc, int msec);

// Управление процессом
QPROCESS_API void  qteQProcess_kill(void* proc);
QPROCESS_API void  qteQProcess_terminate(void* proc);

// Состояние завершения
QPROCESS_API int   qteQProcess_exitCode(void* proc);
QPROCESS_API int   qteQProcess_exitStatus(void* proc); // 0=NormalExit 1=CrashExit
QPROCESS_API int   qteQProcess_state(void* proc);      // 0=NotRunning 1=Starting 2=Running

// Рабочий каталог
QPROCESS_API void  qteQProcess_setWorkingDirectory(void* proc, void* path);
QPROCESS_API void* qteQProcess_workingDirectory(void* proc); // → QString* (caller frees)

// Чтение вывода. Возвращает heap-буфер; освободить через qteQProcess_freeBuffer
QPROCESS_API void* qteQProcess_readAllStdout(void* proc, int* len);
QPROCESS_API void* qteQProcess_readAllStderr(void* proc, int* len);
QPROCESS_API void  qteQProcess_freeBuffer(void* buf);

// Запись в stdin
QPROCESS_API int   qteQProcess_write(void* proc, void* data, int len);
QPROCESS_API void  qteQProcess_closeWriteChannel(void* proc);

// Ошибка
QPROCESS_API int   qteQProcess_error(void* proc);
QPROCESS_API void* qteQProcess_errorString(void* proc); // → QString* (caller frees)

// Сигнал finished(exitCode, exitStatus) → прямой C-callback
QPROCESS_API void  qteQProcess_connect_finished(void* proc, void* cb);

} // extern "C"
