#include "qte56_thread.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QSemaphore>
#include <QReadWriteLock>
#include <QObject>
#include <QCoreApplication>

// ── QThreadWorker ─────────────────────────────────────────────────────────────
//
// Внутренний класс-обёртка: позволяет вызвать произвольный C-callback как
// переопределение виртуального QThread::run().
//
// Не экспортируется наружу. Пользователь работает исключительно через void*.
//
// Наследуем QThread напрямую — нет нужды в Q_OBJECT, поскольку мы не
// добавляем собственных сигналов/слотов, только переопределяем run().

class QThreadWorker : public QThread {
public:
    typedef void (*WorkFn)(void*);

    explicit QThreadWorker(WorkFn fn, void* ctx)
        : QThread(nullptr), _fn(fn), _ctx(ctx) {}

protected:
    // Тело потока: вызывается Qt в новом системном потоке.
    void run() override {
        if (_fn) _fn(_ctx);
    }

private:
    WorkFn _fn;   // C-callback (трамплин из D)
    void*  _ctx;  // контекст (указатель на D DlgClosure)
};

// ── Жизненный цикл ────────────────────────────────────────────────────────────

void* qteQThread_create(void (*fn)(void*), void* ctx) {
    return qte_createTracked(new QThreadWorker(fn, ctx);
}

void qteQThread_delete(void* t) {
    // Перед удалением Qt требует, чтобы поток был завершён.
    // D-обёртка должна гарантировать это (вызвать wait() до delete).
    delete static_cast<QThreadWorker*>(t);
}

// ── Управление потоком ────────────────────────────────────────────────────────

void qteQThread_start(void* t) {
    static_cast<QThread*>(t)->start();
}

void qteQThread_quit(void* t) {
    static_cast<QThread*>(t)->quit();
}

// Ждать завершения потока (без таймаута).
// Возвращает 1 если поток завершился, 0 если произошла ошибка.
int qteQThread_wait(void* t) {
    return static_cast<QThread*>(t)->wait() ? 1 : 0;
}

// Ждать с таймаутом в миллисекундах.
int qteQThread_wait_ms(void* t, int msec) {
    return static_cast<QThread*>(t)->wait(static_cast<unsigned long>(msec)) ? 1 : 0;
}

int qteQThread_isRunning(void* t) {
    return static_cast<QThread*>(t)->isRunning() ? 1 : 0;
}

int qteQThread_isFinished(void* t) {
    return static_cast<QThread*>(t)->isFinished() ? 1 : 0;
}

// ── Флаг прерывания ───────────────────────────────────────────────────────────
//
// Паттерн кооперативной отмены: главный поток устанавливает флаг,
// рабочий поток периодически его проверяет и завершается самостоятельно.

void qteQThread_requestInterruption(void* t) {
    static_cast<QThread*>(t)->requestInterruption();
}

int qteQThread_isInterruptionRequested(void* t) {
    return static_cast<QThread*>(t)->isInterruptionRequested() ? 1 : 0;
}

// ── Приоритет планировщика ────────────────────────────────────────────────────

void qteQThread_setPriority(void* t, int priority) {
    static_cast<QThread*>(t)->setPriority(static_cast<QThread::Priority>(priority));
}

// ── Сигналы ───────────────────────────────────────────────────────────────────
//
// AutoConnection: сигналы, испускаемые из рабочего потока, доставляются
// в главный поток через очередь событий (Qt::QueuedConnection).
// Требуют QCoreApplication::processEvents() или exec() для доставки.

// Для обоих сигналов используем QCoreApplication::instance() как контекст.
// Это гарантирует QueuedConnection: callback исполняется в главном потоке
// (где живёт QApplication), а не в рабочем потоке (где испускается сигнал).
// Требует processEvents() или exec() в главном потоке для доставки.
void qteQThread_connect_started(void* t, void (*cb)(void*), void* ctx) {
    QObject::connect(
        static_cast<QThread*>(t), &QThread::started,
        QCoreApplication::instance(),   // контекст = главный поток
        [cb, ctx]() { cb(ctx); });
}

void qteQThread_connect_finished(void* t, void (*cb)(void*), void* ctx) {
    QObject::connect(
        static_cast<QThread*>(t), &QThread::finished,
        QCoreApplication::instance(),   // контекст = главный поток
        [cb, ctx]() { cb(ctx); });
}

// ── Статические методы ────────────────────────────────────────────────────────

// Приостановить текущий поток на ms миллисекунд.
void qteQThread_msleep(int ms) {
    QThread::msleep(static_cast<unsigned long>(ms));
}

// Приостановить текущий поток на us микросекунд.
void qteQThread_usleep(int us) {
    QThread::usleep(static_cast<unsigned long>(us));
}

// Рекомендуемое число потоков = число логических процессоров.
int qteQThread_idealThreadCount() {
    return QThread::idealThreadCount();
}

// ── moveToThread ──────────────────────────────────────────────────────────────
//
// Перемещает QObject в указанный поток. После этого сигналы QObject будут
// обрабатываться в event loop данного потока.

void qteQThread_moveToThread(void* obj, void* thread) {
    static_cast<QObject*>(obj)->moveToThread(static_cast<QThread*>(thread));
}

// ── QMutex ────────────────────────────────────────────────────────────────────

void* qteQMutex_create() {
    return new QMutex();
}

void qteQMutex_delete(void* m) {
    delete static_cast<QMutex*>(m);
}

void qteQMutex_lock(void* m) {
    static_cast<QMutex*>(m)->lock();
}

void qteQMutex_unlock(void* m) {
    static_cast<QMutex*>(m)->unlock();
}

int qteQMutex_tryLock(void* m) {
    return static_cast<QMutex*>(m)->tryLock() ? 1 : 0;
}

int qteQMutex_tryLock_ms(void* m, int msec) {
    return static_cast<QMutex*>(m)->tryLock(msec) ? 1 : 0;
}

// ── QWaitCondition ────────────────────────────────────────────────────────────

void* qteQWaitCondition_create() {
    return new QWaitCondition();
}

void qteQWaitCondition_delete(void* wc) {
    delete static_cast<QWaitCondition*>(wc);
}

// Ждать пробуждения (без таймаута).
// Mutex должен быть захвачен вызывающим потоком.
// wait() атомарно освобождает mutex и блокируется.
// При пробуждении mutex захватывается снова.
int qteQWaitCondition_wait(void* wc, void* mutex) {
    return static_cast<QWaitCondition*>(wc)->wait(
        static_cast<QMutex*>(mutex)) ? 1 : 0;
}

// Ждать пробуждения с таймаутом (мс).
int qteQWaitCondition_wait_ms(void* wc, void* mutex, int msec) {
    return static_cast<QWaitCondition*>(wc)->wait(
        static_cast<QMutex*>(mutex),
        static_cast<unsigned long>(msec)) ? 1 : 0;
}

// Пробудить один ожидающий поток.
void qteQWaitCondition_wakeOne(void* wc) {
    static_cast<QWaitCondition*>(wc)->wakeOne();
}

// Пробудить все ожидающие потоки.
void qteQWaitCondition_wakeAll(void* wc) {
    static_cast<QWaitCondition*>(wc)->wakeAll();
}

// ── QSemaphore ────────────────────────────────────────────────────────────────

void* qteQSemaphore_create(int n) {
    return new QSemaphore(n);
}

void qteQSemaphore_delete(void* s) {
    delete static_cast<QSemaphore*>(s);
}

// Захватить n единиц (блокирует, пока доступно < n).
void qteQSemaphore_acquire(void* s, int n) {
    static_cast<QSemaphore*>(s)->acquire(n);
}

// Попытаться захватить n единиц без блокировки. 1=успех, 0=нет.
int qteQSemaphore_tryAcquire(void* s, int n) {
    return static_cast<QSemaphore*>(s)->tryAcquire(n) ? 1 : 0;
}

// Попытаться захватить n единиц с таймаутом (мс). 1=успех, 0=таймаут.
int qteQSemaphore_tryAcquire_ms(void* s, int n, int msec) {
    return static_cast<QSemaphore*>(s)->tryAcquire(n, msec) ? 1 : 0;
}

// Освободить n единиц.
void qteQSemaphore_release(void* s, int n) {
    static_cast<QSemaphore*>(s)->release(n);
}

// Текущее число доступных единиц.
int qteQSemaphore_available(void* s) {
    return static_cast<QSemaphore*>(s)->available();
}

// ── QReadWriteLock ────────────────────────────────────────────────────────────

void* qteQReadWriteLock_create() {
    return new QReadWriteLock();
}

void qteQReadWriteLock_delete(void* rw) {
    delete static_cast<QReadWriteLock*>(rw);
}

void qteQReadWriteLock_lockForRead(void* rw) {
    static_cast<QReadWriteLock*>(rw)->lockForRead();
}

void qteQReadWriteLock_lockForWrite(void* rw) {
    static_cast<QReadWriteLock*>(rw)->lockForWrite();
}

int qteQReadWriteLock_tryLockForRead(void* rw) {
    return static_cast<QReadWriteLock*>(rw)->tryLockForRead() ? 1 : 0;
}

int qteQReadWriteLock_tryLockForRead_ms(void* rw, int msec) {
    return static_cast<QReadWriteLock*>(rw)->tryLockForRead(msec) ? 1 : 0;
}

int qteQReadWriteLock_tryLockForWrite(void* rw) {
    return static_cast<QReadWriteLock*>(rw)->tryLockForWrite() ? 1 : 0;
}

int qteQReadWriteLock_tryLockForWrite_ms(void* rw, int msec) {
    return static_cast<QReadWriteLock*>(rw)->tryLockForWrite(msec) ? 1 : 0;
}

void qteQReadWriteLock_unlock(void* rw) {
    static_cast<QReadWriteLock*>(rw)->unlock();
}
