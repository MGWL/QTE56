#pragma once

// ── Экспорт символов ──────────────────────────────────────────────────────────
#ifdef _WIN32
#  ifdef QTE56_THREAD_BUILD
#    define THREAD_API __declspec(dllexport)
#  else
#    define THREAD_API __declspec(dllimport)
#  endif
#else
#  define THREAD_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QThread (20073–20089) ────────────────────────────────────────────────────
//
// Паттерн: создать поток с C-callback, который будет вызван в run().
// Сигналы started/finished принимают (cb, ctx): cb(ctx) вызывается при событии.

// Создать объект потока. fn(ctx) будет вызван в теле нового потока.
THREAD_API void* qteQThread_create(void (*fn)(void*), void* ctx);
// Удалить объект потока (должен быть остановлен перед удалением).
THREAD_API void  qteQThread_delete(void* t);

// Запустить поток (вызывает run() в новом системном потоке).
THREAD_API void  qteQThread_start(void* t);
// Попросить event loop потока завершиться (для exec()-потоков).
THREAD_API void  qteQThread_quit(void* t);
// Ждать завершения потока (без таймаута). 1=завершился, 0=ошибка.
THREAD_API int   qteQThread_wait(void* t);
// Ждать завершения с таймаутом (мс). 1=завершился, 0=таймаут.
THREAD_API int   qteQThread_wait_ms(void* t, int msec);

// Проверить состояние потока.
THREAD_API int   qteQThread_isRunning(void* t);
THREAD_API int   qteQThread_isFinished(void* t);

// Флаг отмены: установить / проверить внутри run().
THREAD_API void  qteQThread_requestInterruption(void* t);
THREAD_API int   qteQThread_isInterruptionRequested(void* t);

// Приоритет планировщика (QThread::Priority, 0=IdlePriority..7=TimeCritical).
THREAD_API void  qteQThread_setPriority(void* t, int priority);

// Сигнал started: cb(ctx) вызывается когда поток начал выполнение.
THREAD_API void  qteQThread_connect_started(void* t, void (*cb)(void*), void* ctx);
// Сигнал finished: cb(ctx) вызывается когда поток завершил выполнение.
THREAD_API void  qteQThread_connect_finished(void* t, void (*cb)(void*), void* ctx);

// Статические методы.
THREAD_API void  qteQThread_msleep(int ms);   // приостановить текущий поток на N мс
THREAD_API void  qteQThread_usleep(int us);   // приостановить текущий поток на N мкс
THREAD_API int   qteQThread_idealThreadCount(); // рекомендуемое число потоков (логических CPU)

// Переместить QObject в поток (сигналы будут обрабатываться там).
THREAD_API void  qteQThread_moveToThread(void* obj, void* thread);

// ── QMutex (20090–20095) ─────────────────────────────────────────────────────
//
// Рекурсивный mutex не поддерживается (NonRecursive по умолчанию).

THREAD_API void* qteQMutex_create();
THREAD_API void  qteQMutex_delete(void* m);
// Захватить mutex (блокирует до получения).
THREAD_API void  qteQMutex_lock(void* m);
// Освободить mutex.
THREAD_API void  qteQMutex_unlock(void* m);
// Попытаться захватить без блокировки. 1=захвачен, 0=занят.
THREAD_API int   qteQMutex_tryLock(void* m);
// Попытаться захватить с таймаутом (мс). 1=захвачен, 0=таймаут.
THREAD_API int   qteQMutex_tryLock_ms(void* m, int msec);

// ── QWaitCondition (20096–20101) ─────────────────────────────────────────────
//
// Условная переменная: поток блокируется до пробуждения.
// Паттерн: захватить mutex → проверить условие → wait() → проверить снова.
// wait() атомарно освобождает mutex и блокируется, при пробуждении захватывает снова.

THREAD_API void* qteQWaitCondition_create();
THREAD_API void  qteQWaitCondition_delete(void* wc);
// Ждать пробуждения (без таймаута). Освобождает mutex на время ожидания.
// 1=пробуждён сигналом, 0=spurious wakeup или ошибка.
THREAD_API int   qteQWaitCondition_wait(void* wc, void* mutex);
// Ждать пробуждения с таймаутом (мс). 1=пробуждён, 0=таймаут.
THREAD_API int   qteQWaitCondition_wait_ms(void* wc, void* mutex, int msec);
// Пробудить один ожидающий поток.
THREAD_API void  qteQWaitCondition_wakeOne(void* wc);
// Пробудить все ожидающие потоки.
THREAD_API void  qteQWaitCondition_wakeAll(void* wc);

// ── QSemaphore (20102–20108) ─────────────────────────────────────────────────
//
// Семафор с лимитом ресурсов. Создаётся с начальным числом N доступных единиц.
// acquire(n) уменьшает счётчик (блокирует, если < n).
// release(n) увеличивает счётчик и будит ожидающие.

THREAD_API void* qteQSemaphore_create(int n);     // n = начальный счётчик
THREAD_API void  qteQSemaphore_delete(void* s);
// Захватить n единиц (блокирует, пока доступно < n).
THREAD_API void  qteQSemaphore_acquire(void* s, int n);
// Попытаться захватить n единиц без блокировки. 1=успех, 0=недостаточно.
THREAD_API int   qteQSemaphore_tryAcquire(void* s, int n);
// Попытаться захватить n единиц с таймаутом (мс). 1=успех, 0=таймаут.
THREAD_API int   qteQSemaphore_tryAcquire_ms(void* s, int n, int msec);
// Освободить n единиц (увеличить счётчик).
THREAD_API void  qteQSemaphore_release(void* s, int n);
// Текущее число доступных единиц.
THREAD_API int   qteQSemaphore_available(void* s);

// ── QReadWriteLock (20109–20117) ─────────────────────────────────────────────
//
// RW-lock: множество читателей ИЛИ один писатель.
// Оптимален когда чтений много, записей мало.
// lockForRead() совместим с другими читателями; lockForWrite() эксклюзивен.

THREAD_API void* qteQReadWriteLock_create();
THREAD_API void  qteQReadWriteLock_delete(void* rw);
// Захватить для чтения (совместно с другими читателями).
THREAD_API void  qteQReadWriteLock_lockForRead(void* rw);
// Захватить для записи (эксклюзивно).
THREAD_API void  qteQReadWriteLock_lockForWrite(void* rw);
// Попытаться захватить для чтения без блокировки. 1=успех, 0=занят писателем.
THREAD_API int   qteQReadWriteLock_tryLockForRead(void* rw);
// Попытаться захватить для чтения с таймаутом (мс). 1=успех, 0=таймаут.
THREAD_API int   qteQReadWriteLock_tryLockForRead_ms(void* rw, int msec);
// Попытаться захватить для записи без блокировки. 1=успех, 0=занят.
THREAD_API int   qteQReadWriteLock_tryLockForWrite(void* rw);
// Попытаться захватить для записи с таймаутом (мс). 1=успех, 0=таймаут.
THREAD_API int   qteQReadWriteLock_tryLockForWrite_ms(void* rw, int msec);
// Освободить (после lockForRead или lockForWrite).
THREAD_API void  qteQReadWriteLock_unlock(void* rw);

} // extern "C"
