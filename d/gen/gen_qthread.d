/**
 * gen_qthread.d — D-обёртка для QThread и QMutex.
 *
 * DLL: qte56_thread.dll  |  Блок индексов: 20073–20095 (23 функции)
 *
 * $(H3 Содержание)
 * $(UL
 *   $(LI $(B QThread) — запуск кода в отдельном потоке (20073–20089))
 *   $(LI $(B QMutex)  — взаимное исключение для синхронизации (20090–20095))
 * )
 *
 * $(H3 Ключевой паттерн: трамплин)
 *
 * C++ QThread требует переопределения виртуального метода run().
 * Из DLL это невозможно напрямую. Решение:
 * $(UL
 *   $(LI C++ содержит `QThreadWorker` — хранит `void(*fn)(void*)` + ctx)
 *   $(LI D создаёт `DlgClosure` — обёртку вокруг D-делегата)
 *   $(LI `_trampoline` — статическая `extern(C)` функция, разворачивает замыкание)
 *   $(LI Пользователь передаёт обычный D-делегат в конструктор QThread)
 * )
 *
 * $(H3 Сигналы started/finished)
 *
 * Сигналы delivered через Qt event queue (AutoConnection).
 * Callback вызывается в главном потоке после `app.processEvents()` или `app.exec()`.
 * Для тестов без event loop: использовать `thread.wait()` + `app.processEvents()`.
 *
 * $(H3 Пример использования)
 *
 * ---
 * import gen_qthread;
 * import core.atomic;
 *
 * __gshared int g_result = 0;
 *
 * auto t = new QThread({
 *     // Любой D-код. GUI не трогать!
 *     foreach (i; 0 .. 1_000_000)
 *         atomicOp!"+="(g_result, 1);
 * });
 *
 * t.connect_finished({
 *     // Вызывается в главном потоке после завершения потока
 *     writeln("Готово: ", atomicLoad(g_result));
 * });
 *
 * t.start();
 * app.exec();   // event loop: ждём quit(), который вызовет connect_finished
 * ---
 *
 * $(H3 QMutex пример)
 *
 * ---
 * auto m = new QMutex();
 * m.lock();
 * sharedData ~= "item";
 * m.unlock();
 * ---
 *
 * See_Also: doc/threading.md — полное руководство по многопоточности в QTE56
 */
module gen_qthread;

import qte56_core;
import qte56_loader : loadFn, registerModule;

// Импортируем уже определённые alias из gen_qcore.
// Для gen_qthread нам нужны: t_qp__qp_qp, t_v__qp, t_i__qp, t_b__qp_i,
//                             t_v__qp_i, t_v__qp_qp, t_v__qp_qp_qp, t_qp__
import gen_qcore : t_qp__qp_qp, t_v__qp, t_i__qp, t_b__qp_i,
                   t_v__qp_i, t_v__qp_qp, t_v__qp_qp_qp, t_qp__;

// ── Новые alias для примитивов синхронизации ──────────────────────────────────

/// int function(void*, void*) — QWaitCondition::wait(mutex)
mixin(generateAlias("i__qp_qp"));

/// int function(void*, void*, int) — QWaitCondition::wait(mutex, msec)
mixin(generateAlias("i__qp_qp_i"));

/// void function(void*, int) — QSemaphore::acquire(n), release(n)
mixin(generateAlias("v__qp_i"));

/// int function(void*, int, int) — QSemaphore::tryAcquire(n, msec)
mixin(generateAlias("i__qp_i_i"));

// ── Новые alias для статических методов ───────────────────────────────────────

/// void function(int) — для msleep/usleep (принимают один int)
mixin(generateAlias("v__i"));

/// int function() — для idealThreadCount (без параметров)
mixin(generateAlias("i__"));

// ── Загрузка функций ──────────────────────────────────────────────────────────

/**
 * Загружает все функции QThread и QMutex из qte56_thread.dll.
 * Вызывается автоматически через registerModule при первом import.
 */
void loadQThread() {
    // ── QThread ────────────────────────────────────────────────────────────
    mixin(generateFunQt(20073, "qteQThread_create",                  "QThread"));
    mixin(generateFunQt(20074, "qteQThread_delete",                  "QThread"));
    mixin(generateFunQt(20075, "qteQThread_start",                   "QThread"));
    mixin(generateFunQt(20076, "qteQThread_quit",                    "QThread"));
    mixin(generateFunQt(20077, "qteQThread_wait",                    "QThread"));
    mixin(generateFunQt(20078, "qteQThread_wait_ms",                 "QThread"));
    mixin(generateFunQt(20079, "qteQThread_isRunning",               "QThread"));
    mixin(generateFunQt(20080, "qteQThread_isFinished",              "QThread"));
    mixin(generateFunQt(20081, "qteQThread_requestInterruption",     "QThread"));
    mixin(generateFunQt(20082, "qteQThread_isInterruptionRequested", "QThread"));
    mixin(generateFunQt(20083, "qteQThread_setPriority",             "QThread"));
    mixin(generateFunQt(20084, "qteQThread_connect_started",         "QThread"));
    mixin(generateFunQt(20085, "qteQThread_connect_finished",        "QThread"));
    mixin(generateFunQt(20086, "qteQThread_msleep",                  "QThread"));
    mixin(generateFunQt(20087, "qteQThread_usleep",                  "QThread"));
    mixin(generateFunQt(20088, "qteQThread_idealThreadCount",        "QThread"));
    mixin(generateFunQt(20089, "qteQThread_moveToThread",            "QThread"));
    // ── QMutex ────────────────────────────────────────────────────────────
    mixin(generateFunQt(20090, "qteQMutex_create",                   "QThread"));
    mixin(generateFunQt(20091, "qteQMutex_delete",                   "QThread"));
    mixin(generateFunQt(20092, "qteQMutex_lock",                     "QThread"));
    mixin(generateFunQt(20093, "qteQMutex_unlock",                   "QThread"));
    mixin(generateFunQt(20094, "qteQMutex_tryLock",                  "QThread"));
    mixin(generateFunQt(20095, "qteQMutex_tryLock_ms",               "QThread"));
    // ── QWaitCondition ────────────────────────────────────────────────────
    mixin(generateFunQt(20096, "qteQWaitCondition_create",           "QThread"));
    mixin(generateFunQt(20097, "qteQWaitCondition_delete",           "QThread"));
    mixin(generateFunQt(20098, "qteQWaitCondition_wait",             "QThread"));
    mixin(generateFunQt(20099, "qteQWaitCondition_wait_ms",          "QThread"));
    mixin(generateFunQt(20100, "qteQWaitCondition_wakeOne",          "QThread"));
    mixin(generateFunQt(20101, "qteQWaitCondition_wakeAll",          "QThread"));
    // ── QSemaphore ────────────────────────────────────────────────────────
    mixin(generateFunQt(20102, "qteQSemaphore_create",               "QThread"));
    mixin(generateFunQt(20103, "qteQSemaphore_delete",               "QThread"));
    mixin(generateFunQt(20104, "qteQSemaphore_acquire",              "QThread"));
    mixin(generateFunQt(20105, "qteQSemaphore_tryAcquire",           "QThread"));
    mixin(generateFunQt(20106, "qteQSemaphore_tryAcquire_ms",        "QThread"));
    mixin(generateFunQt(20107, "qteQSemaphore_release",              "QThread"));
    mixin(generateFunQt(20108, "qteQSemaphore_available",            "QThread"));
    // ── QReadWriteLock ────────────────────────────────────────────────────
    mixin(generateFunQt(20109, "qteQReadWriteLock_create",           "QThread"));
    mixin(generateFunQt(20110, "qteQReadWriteLock_delete",           "QThread"));
    mixin(generateFunQt(20111, "qteQReadWriteLock_lockForRead",      "QThread"));
    mixin(generateFunQt(20112, "qteQReadWriteLock_lockForWrite",     "QThread"));
    mixin(generateFunQt(20113, "qteQReadWriteLock_tryLockForRead",   "QThread"));
    mixin(generateFunQt(20114, "qteQReadWriteLock_tryLockForRead_ms","QThread"));
    mixin(generateFunQt(20115, "qteQReadWriteLock_tryLockForWrite",  "QThread"));
    mixin(generateFunQt(20116, "qteQReadWriteLock_tryLockForWrite_ms","QThread"));
    mixin(generateFunQt(20117, "qteQReadWriteLock_unlock",           "QThread"));
}

/// Авто-регистрация модуля: вызывается при загрузке модуля.
static this() {
    registerModule("QThread", "qte56_thread.dll", &loadQThread);
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательные типы трамплина
// ══════════════════════════════════════════════════════════════════════════════

/**
 * DlgClosure — GC-выделенная обёртка вокруг D-делегата.
 *
 * Используется как контекст (ctx) для C-трамплина. Хранится в полях класса,
 * чтобы GC не собрал делегат раньше времени.
 *
 * Паттерн:
 * ---
 * auto c = new DlgClosure(() { doWork(); });
 * create(&_trampoline, cast(void*)c);
 * ---
 */
private final class DlgClosure {
    void delegate() dg; /// Захваченный D-делегат
    this(void delegate() d) { dg = d; }
}

/**
 * _trampoline — статический extern(C) мост: C++ → D-делегат.
 *
 * C++ вызывает эту функцию по указателю (cdecl).
 * Функция разворачивает DlgClosure и вызывает сохранённый делегат.
 *
 * Params:
 *   ctx = указатель на DlgClosure, приведённый к void*
 */
extern(C) private static void _trampoline(void* ctx) {
    (cast(DlgClosure)cast(Object)ctx).dg();
}

// ══════════════════════════════════════════════════════════════════════════════
// QThread
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QThread — обёртка вокруг Qt-потока выполнения.
 *
 * $(H3 Использование)
 *
 * Создайте объект, передав D-делегат в конструктор. Делегат будет вызван
 * в новом потоке при вызове `start()`.
 *
 * ---
 * auto t = new QThread({
 *     // Тяжёлая работа
 *     foreach (i; 0 .. 10)
 *         QThread.msleep(100);
 *     atomicStore(g_done, true);
 * });
 * t.start();
 * t.wait();   // блокирует главный поток до завершения
 * ---
 *
 * $(H3 Важно)
 * $(UL
 *   $(LI GUI (Qt виджеты) можно трогать только из главного потока.)
 *   $(LI Для передачи данных используйте `core.atomic` + `core.sync.mutex`.)
 *   $(LI `connect_finished` требует event loop для доставки сигнала.)
 *   $(LI `wait()` перед удалением объекта обязателен — иначе краш.)
 * )
 *
 * See_Also: doc/threading.md
 */
@live class QThread {
private:
    void* _wh;             /// Указатель на C++ QThreadWorker

    // Замыкания хранятся в полях, чтобы GC не собрал их раньше завершения потока.
    DlgClosure _workClosure;     /// Замыкание рабочей функции
    DlgClosure _startedClosure;  /// Замыкание callback-а сигнала started
    DlgClosure _finishedClosure; /// Замыкание callback-а сигнала finished

public:

    /**
     * Создать поток с рабочей функцией.
     *
     * Params:
     *   work = D-делегат, который будет выполнен в теле нового потока.
     *          Может захватывать переменные. GUI не трогать!
     *
     * Examples:
     * ---
     * auto t = new QThread({
     *     import core.atomic;
     *     atomicStore(g_result, heavyComputation());
     *     atomicStore(g_done, true);
     * });
     * ---
     */
    this(void delegate() work) {
        _workClosure = new DlgClosure(work);
        _wh = (cast(t_qp__qp_qp)pFunQt[20073])(
            &_trampoline,
            cast(void*)cast(Object)_workClosure
        );
    }

    /// Уничтожить объект потока.
    /// Поток должен быть завершён (вызвать wait() или убедиться в isFinished()).
    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[20074])(_wh);
            _wh = null;
        }
    }

    // ── Управление ────────────────────────────────────────────────────────────

    /**
     * Запустить поток.
     * Рабочая функция (делегат из конструктора) начнёт выполняться асинхронно.
     */
    QThread start() { (cast(t_v__qp)pFunQt[20075])(_wh); return this; }

    /**
     * Попросить event loop потока завершиться.
     * Актуально только для потоков с собственным exec().
     * Для обычных run()-потоков использовать `requestInterruption()`.
     */
    QThread quit() { (cast(t_v__qp)pFunQt[20076])(_wh); return this; }

    /**
     * Ждать завершения потока (без таймаута).
     *
     * Блокирует вызывающий поток. Не вызывать в главном потоке при
     * активном Qt event loop — GUI замёрзнет.
     *
     * Returns:
     *   1 — поток завершился, 0 — произошла ошибка.
     */
    int wait() { return (cast(t_i__qp)pFunQt[20077])(_wh); }

    /**
     * Ждать завершения с таймаутом.
     *
     * Params:
     *   msec = максимальное время ожидания в миллисекундах.
     *
     * Returns:
     *   1 — поток завершился в срок, 0 — истёк таймаут.
     */
    int wait(int msec) { return (cast(t_b__qp_i)pFunQt[20078])(_wh, msec); }

    /**
     * Проверить, выполняется ли поток в данный момент.
     * Returns: 1 — выполняется, 0 — нет.
     */
    int isRunning()  { return (cast(t_i__qp)pFunQt[20079])(_wh); }

    /**
     * Проверить, завершён ли поток.
     * Returns: 1 — завершён, 0 — нет.
     */
    int isFinished() { return (cast(t_i__qp)pFunQt[20080])(_wh); }

    // ── Кооперативная отмена ─────────────────────────────────────────────────

    /**
     * Установить флаг прерывания.
     *
     * Главный поток вызывает этот метод, чтобы попросить рабочий поток
     * завершиться. Рабочий поток периодически проверяет `isInterruptionRequested()`.
     *
     * Examples:
     * ---
     * // Главный поток:
     * t.requestInterruption();
     *
     * // Рабочий поток:
     * auto t = new QThread({
     *     while (!QThread.currentIsInterruptionRequested()) {
     *         doStep();
     *     }
     * });
     * ---
     */
    QThread requestInterruption() { (cast(t_v__qp)pFunQt[20081])(_wh); return this; }

    /**
     * Проверить флаг прерывания.
     * Вызывать внутри рабочей функции для кооперативной отмены.
     * Returns: 1 — прерывание запрошено, 0 — нет.
     */
    int isInterruptionRequested() { return (cast(t_i__qp)pFunQt[20082])(_wh); }

    // ── Приоритет ────────────────────────────────────────────────────────────

    /**
     * Установить приоритет планировщика.
     *
     * Params:
     *   priority = QThread::Priority: 0=Idle, 1=Lowest, 2=Low, 3=Normal,
     *              4=High, 5=Highest, 6=TimeCritical, 7=Inherit
     */
    QThread setPriority(int priority) {
        (cast(t_v__qp_i)pFunQt[20083])(_wh, priority);
        return this;
    }

    // ── Сигналы ───────────────────────────────────────────────────────────────

    /**
     * Подключить callback к сигналу started.
     *
     * Callback будет вызван в главном потоке (AutoConnection),
     * когда поток начнёт выполнение. Требует processEvents() или exec().
     *
     * Params:
     *   cb = D-делегат без параметров.
     *
     * Examples:
     * ---
     * t.connect_started({
     *     statusLabel.setText("Поток запущен...");
     * });
     * ---
     */
    QThread connect_started(void delegate() cb) {
        _startedClosure = new DlgClosure(cb);
        (cast(t_v__qp_qp_qp)pFunQt[20084])(
            _wh,
            &_trampoline,
            cast(void*)cast(Object)_startedClosure
        );
        return this;
    }

    /**
     * Подключить callback к сигналу finished.
     *
     * Callback будет вызван в главном потоке (AutoConnection),
     * когда поток завершит выполнение. Требует processEvents() или exec().
     *
     * Params:
     *   cb = D-делегат без параметров.
     *
     * Examples:
     * ---
     * t.connect_finished({
     *     resultLabel.setText(atomicLoad(g_result));
     *     startBtn.setEnabled(true);
     *     app.quit();  // если нужно завершить exec()
     * });
     * t.start();
     * app.exec();   // ждём сигнала finished → quit
     * ---
     */
    QThread connect_finished(void delegate() cb) {
        _finishedClosure = new DlgClosure(cb);
        (cast(t_v__qp_qp_qp)pFunQt[20085])(
            _wh,
            &_trampoline,
            cast(void*)cast(Object)_finishedClosure
        );
        return this;
    }

    // ── Статические методы ────────────────────────────────────────────────────

    /**
     * Приостановить текущий поток на N миллисекунд.
     * Можно вызывать из любого потока (в том числе из рабочей функции).
     *
     * Params:
     *   ms = время паузы в миллисекундах.
     */
    static void msleep(int ms) {
        (cast(t_v__i)pFunQt[20086])(ms);
    }

    /**
     * Приостановить текущий поток на N микросекунд.
     *
     * Params:
     *   us = время паузы в микросекундах.
     */
    static void usleep(int us) {
        (cast(t_v__i)pFunQt[20087])(us);
    }

    /**
     * Получить рекомендуемое число потоков = количество логических CPU.
     *
     * Returns:
     *   Число логических процессоров. Используйте для создания пула потоков:
     *   `idealThreadCount()` потоков для CPU-bound задач,
     *   больше — для IO-bound.
     */
    static int idealThreadCount() {
        return (cast(t_i__)pFunQt[20088])();
    }

    // ── moveToThread ──────────────────────────────────────────────────────────

    /**
     * Переместить QObject в данный поток.
     *
     * После вызова сигналы объекта будут обрабатываться в event loop данного потока.
     * Поток должен быть запущен до или после вызова.
     *
     * Params:
     *   obj = указатель на QObject (getWH() любого Q-виджета/объекта).
     *
     * Examples:
     * ---
     * // Перемещаем таймер в рабочий поток (не рекомендуется для GUI)
     * t.moveToThread(timerObj.getWH());
     * ---
     */
    QThread moveToThread(void* obj) {
        (cast(t_v__qp_qp)pFunQt[20089])(obj, _wh);
        return this;
    }

    /// Получить нативный указатель на C++ QThread.
    void* getWH() { return _wh; }
}

// ══════════════════════════════════════════════════════════════════════════════
// QMutex
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QMutex — взаимное исключение для синхронизации между потоками.
 *
 * Предотвращает одновременный доступ нескольких потоков к разделяемым данным.
 * Аналог `core.sync.mutex.Mutex`, но реализован через Qt.
 *
 * $(H3 Пример)
 *
 * ---
 * auto m = new QMutex();
 *
 * // Поток A:
 * m.lock();
 * sharedList ~= "item from A";
 * m.unlock();
 *
 * // Поток B:
 * if (m.tryLock(100)) {   // ждать не более 100 мс
 *     sharedList ~= "item from B";
 *     m.unlock();
 * }
 * ---
 *
 * $(H3 Важно)
 * $(UL
 *   $(LI Вызывать `unlock()` в том же потоке, что и `lock()`.)
 *   $(LI Не использовать QMutex в деструкторах D-классов (GC не гарантирует порядок).)
 *   $(LI Для автоматического снятия блокировки используйте паттерн scope(exit).)
 * )
 *
 * ---
 * m.lock();
 * scope(exit) m.unlock();   // гарантированно снимается при выходе из блока
 * // ... работа с разделяемыми данными ...
 * ---
 */
@live class QMutex {
private:
    void* _wh; /// Указатель на C++ QMutex

public:

    /**
     * Создать mutex.
     * По умолчанию NonRecursive: одна и та же нить не может захватить дважды.
     */
    this() {
        _wh = (cast(t_qp__)pFunQt[20090])();
    }

    /// Уничтожить mutex. Не уничтожать захваченный mutex!
    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[20091])(_wh);
            _wh = null;
        }
    }

    /**
     * Захватить mutex. Блокирует вызывающий поток, пока mutex не освободится.
     *
     * Throws:
     *   Нет исключений, но может заблокироваться навсегда при deadlock.
     */
    QMutex lock()   { (cast(t_v__qp)pFunQt[20092])(_wh); return this; }

    /**
     * Освободить mutex. Должен быть вызван из того же потока, что и lock().
     */
    QMutex unlock() { (cast(t_v__qp)pFunQt[20093])(_wh); return this; }

    /**
     * Попытаться захватить mutex без блокировки.
     *
     * Returns:
     *   1 — mutex захвачен, 0 — уже занят другим потоком.
     */
    int tryLock() { return (cast(t_i__qp)pFunQt[20094])(_wh); }

    /**
     * Попытаться захватить mutex с таймаутом.
     *
     * Params:
     *   msec = максимальное время ожидания в миллисекундах.
     *
     * Returns:
     *   1 — mutex захвачен, 0 — таймаут истёк.
     */
    int tryLock(int msec) { return (cast(t_b__qp_i)pFunQt[20095])(_wh, msec); }

    /// Получить нативный указатель на C++ QMutex.
    void* getWH() { return _wh; }
}

// ══════════════════════════════════════════════════════════════════════════════
// Псевдонимы типов функций для новых примитивов
// ══════════════════════════════════════════════════════════════════════════════

/// int function(void*, void*)      — QWaitCondition::wait(wc, mutex)
private alias i__qp_qp   = extern(C) @nogc int function(void*, void*);
/// int function(void*, void*, int) — QWaitCondition::wait(wc, mutex, msec)
private alias i__qp_qp_i = extern(C) @nogc int function(void*, void*, int);
/// void function(void*, int)       — acquire/release
private alias v__qp_i    = extern(C) @nogc void function(void*, int);
/// int function(void*, int, int)   — tryAcquire(n, msec)
private alias i__qp_i_i  = extern(C) @nogc int function(void*, int, int);
/// void* function(int)             — QSemaphore::create(n)
private alias t_qp__i    = extern(C) @nogc void* function(int);

// ══════════════════════════════════════════════════════════════════════════════
// QWaitCondition
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QWaitCondition — условная переменная для синхронизации между потоками.
 *
 * Позволяет потоку заблокироваться до тех пор, пока не выполнится
 * некоторое условие, о котором сигнализирует другой поток.
 *
 * $(H3 Паттерн использования)
 *
 * Всегда используется совместно с QMutex. Рабочий цикл:
 * $(OL
 *   $(LI Захватить mutex.)
 *   $(LI Проверить условие. Если выполнено — снять mutex и работать.)
 *   $(LI Если не выполнено — вызвать wait(mutex). Qt атомарно освобождает mutex
 *        и блокирует поток.)
 *   $(LI При пробуждении mutex захватывается снова, вернуться к шагу 2.)
 * )
 *
 * $(H3 Пример: producer-consumer)
 *
 * ---
 * __gshared QMutex         g_m;
 * __gshared QWaitCondition g_cv;
 * __gshared int[]          g_queue;
 *
 * // Producer:
 * auto producer = new QThread({
 *     foreach (i; 1 .. 6) {
 *         g_m.lock();
 *         g_queue ~= i;
 *         g_cv.wakeOne();
 *         g_m.unlock();
 *         QThread.msleep(10);
 *     }
 *     g_m.lock();
 *     g_queue ~= -1;    // sentinel: конец данных
 *     g_cv.wakeOne();
 *     g_m.unlock();
 * });
 *
 * // Consumer:
 * auto consumer = new QThread({
 *     while (true) {
 *         g_m.lock();
 *         while (g_queue.length == 0)
 *             g_cv.wait(g_m);     // ждём, mutex освобождается
 *         int v = g_queue[0];
 *         g_queue = g_queue[1..$];
 *         g_m.unlock();
 *         if (v < 0) break;
 *         processItem(v);
 *     }
 * });
 * ---
 *
 * $(H3 Важно)
 * $(UL
 *   $(LI Mutex ДОЛЖЕН быть захвачен перед вызовом wait().)
 *   $(LI Spurious wakeup возможен — всегда проверяйте условие в цикле while.)
 *   $(LI wakeOne/wakeAll можно вызывать без захваченного mutex.)
 * )
 */
@live class QWaitCondition {
private:
    void* _wh; /// Указатель на C++ QWaitCondition

public:

    /// Создать условную переменную.
    this() {
        _wh = (cast(t_qp__)pFunQt[20096])();
    }

    /// Уничтожить условную переменную.
    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[20097])(_wh);
            _wh = null;
        }
    }

    /**
     * Ждать пробуждения (без таймаута).
     *
     * Вызывать только при захваченном mutex!
     * Атомарно освобождает mutex и блокирует поток.
     * При пробуждении mutex захватывается снова.
     *
     * Params:
     *   mutex = захваченный QMutex.
     *
     * Returns:
     *   1 — пробуждён сигналом, 0 — spurious wakeup.
     */
    int wait(QMutex mutex) {
        return (cast(i__qp_qp)pFunQt[20098])(_wh, mutex.getWH());
    }

    /**
     * Ждать пробуждения с таймаутом.
     *
     * Params:
     *   mutex = захваченный QMutex.
     *   msec  = максимальное время ожидания в миллисекундах.
     *
     * Returns:
     *   1 — пробуждён сигналом, 0 — таймаут.
     */
    int wait(QMutex mutex, int msec) {
        return (cast(i__qp_qp_i)pFunQt[20099])(_wh, mutex.getWH(), msec);
    }

    /**
     * Пробудить один ожидающий поток.
     * Если ни один поток не ждёт — вызов игнорируется.
     */
    QWaitCondition wakeOne() { (cast(t_v__qp)pFunQt[20100])(_wh); return this; }

    /**
     * Пробудить все ожидающие потоки.
     * Каждый поток проверит своё условие и либо продолжит, либо заснёт снова.
     */
    QWaitCondition wakeAll() { (cast(t_v__qp)pFunQt[20101])(_wh); return this; }

    /// Получить нативный указатель на C++ QWaitCondition.
    void* getWH() { return _wh; }
}

// ══════════════════════════════════════════════════════════════════════════════
// QSemaphore
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QSemaphore — семафор с лимитом ресурсов.
 *
 * Хранит счётчик доступных единиц ресурса. acquire(n) уменьшает счётчик
 * (блокирует, если недостаточно). release(n) увеличивает и будит ожидающих.
 *
 * $(H3 Применение)
 * $(UL
 *   $(LI Ограничение числа одновременных операций / подключений.)
 *   $(LI Кольцевой буфер с синхронизацией Producer-Consumer.)
 *   $(LI Подсчёт доступных ресурсов (слотов пула, дескрипторов).)
 * )
 *
 * $(H3 Пример: не более 3 потоков одновременно)
 *
 * ---
 * __gshared QSemaphore g_sem;
 * g_sem = new QSemaphore(3);   // 3 слота
 *
 * foreach (i; 0 .. 10) {
 *     int idx = i;
 *     auto t = new QThread({
 *         g_sem.acquire(1);
 *         scope(exit) g_sem.release(1);
 *         heavyWork(idx);
 *     });
 *     t.start();
 * }
 * ---
 *
 * $(H3 Пример: кольцевой буфер)
 *
 * ---
 * enum BUFSIZE = 8;
 * __gshared QSemaphore g_free;   // свободные ячейки
 * __gshared QSemaphore g_used;   // заполненные ячейки
 * g_free = new QSemaphore(BUFSIZE);
 * g_used = new QSemaphore(0);
 *
 * // Producer:
 * g_free.acquire(1);
 * buf[wpos % BUFSIZE] = item;
 * g_used.release(1);
 *
 * // Consumer:
 * g_used.acquire(1);
 * auto item = buf[rpos % BUFSIZE];
 * g_free.release(1);
 * ---
 */
@live class QSemaphore {
private:
    void* _wh; /// Указатель на C++ QSemaphore

public:

    /**
     * Создать семафор с начальным счётчиком n.
     *
     * Params:
     *   n = начальное число доступных единиц (>= 0, по умолчанию 0).
     */
    this(int n = 0) {
        _wh = (cast(t_qp__i)pFunQt[20102])(n);
    }

    /// Уничтожить семафор.
    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[20103])(_wh);
            _wh = null;
        }
    }

    /**
     * Захватить n единиц. Блокирует, пока доступно < n.
     *
     * Params:
     *   n = число единиц (по умолчанию 1).
     */
    QSemaphore acquire(int n = 1) {
        (cast(v__qp_i)pFunQt[20104])(_wh, n);
        return this;
    }

    /**
     * Попытаться захватить n единиц без блокировки.
     *
     * Returns:
     *   1 — захвачено, 0 — недостаточно единиц прямо сейчас.
     */
    int tryAcquire(int n = 1) {
        return (cast(t_b__qp_i)pFunQt[20105])(_wh, n);
    }

    /**
     * Попытаться захватить n единиц с таймаутом.
     *
     * Params:
     *   n    = число единиц.
     *   msec = максимальное время ожидания в миллисекундах.
     *
     * Returns:
     *   1 — захвачено, 0 — таймаут.
     */
    int tryAcquire(int n, int msec) {
        return (cast(i__qp_i_i)pFunQt[20106])(_wh, n, msec);
    }

    /**
     * Освободить n единиц (увеличить счётчик).
     * Будит ожидающие потоки, которым теперь хватит единиц.
     *
     * Params:
     *   n = число освобождаемых единиц (по умолчанию 1).
     */
    QSemaphore release(int n = 1) {
        (cast(v__qp_i)pFunQt[20107])(_wh, n);
        return this;
    }

    /**
     * Текущее число доступных единиц.
     *
     * Returns:
     *   Количество единиц, которые можно захватить прямо сейчас без блокировки.
     */
    int available() {
        return (cast(t_i__qp)pFunQt[20108])(_wh);
    }

    /// Получить нативный указатель на C++ QSemaphore.
    void* getWH() { return _wh; }
}

// ══════════════════════════════════════════════════════════════════════════════
// QReadWriteLock
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QReadWriteLock — RW-блокировка: множество читателей ИЛИ один писатель.
 *
 * Оптимальна для структур с частым чтением и редкой записью.
 * Несколько потоков могут одновременно держать блокировку для чтения.
 * Блокировка для записи эксклюзивна: ждёт, пока все читатели уйдут.
 *
 * $(H3 Правила)
 * $(UL
 *   $(LI После lockForRead/lockForWrite — вызвать unlock().)
 *   $(LI Не захватывать для чтения, если уже захвачено для записи (deadlock).)
 *   $(LI NonRecursive по умолчанию — нельзя захватывать дважды в одном потоке.)
 *   $(LI Использовать scope(exit) rw.unlock() для надёжности.)
 * )
 *
 * $(H3 Пример)
 *
 * ---
 * __gshared QReadWriteLock g_rw;
 * __gshared string[]       g_data;
 * g_rw = new QReadWriteLock();
 *
 * // Читатель (несколько потоков параллельно):
 * g_rw.lockForRead();
 * scope(exit) g_rw.unlock();
 * auto snapshot = g_data.dup;
 *
 * // Писатель (эксклюзивно):
 * g_rw.lockForWrite();
 * scope(exit) g_rw.unlock();
 * g_data ~= "new item";
 * ---
 */
@live class QReadWriteLock {
private:
    void* _wh; /// Указатель на C++ QReadWriteLock

public:

    /// Создать RW-блокировку.
    this() {
        _wh = (cast(t_qp__)pFunQt[20109])();
    }

    /// Уничтожить RW-блокировку.
    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[20110])(_wh);
            _wh = null;
        }
    }

    /**
     * Захватить для чтения.
     * Блокирует, пока есть активный писатель.
     * Несколько читателей могут держать одновременно.
     */
    QReadWriteLock lockForRead()  { (cast(t_v__qp)pFunQt[20111])(_wh); return this; }

    /**
     * Захватить для записи (эксклюзивно).
     * Блокирует, пока есть любые другие читатели или писатели.
     */
    QReadWriteLock lockForWrite() { (cast(t_v__qp)pFunQt[20112])(_wh); return this; }

    /**
     * Попытаться захватить для чтения без блокировки.
     * Returns: 1 — успех, 0 — занят писателем.
     */
    int tryLockForRead()  { return (cast(t_i__qp)pFunQt[20113])(_wh); }

    /**
     * Попытаться захватить для чтения с таймаутом.
     * Params:
     *   msec = максимальное время ожидания.
     * Returns: 1 — захвачено, 0 — таймаут.
     */
    int tryLockForRead(int msec)  { return (cast(t_b__qp_i)pFunQt[20114])(_wh, msec); }

    /**
     * Попытаться захватить для записи без блокировки.
     * Returns: 1 — успех, 0 — занято.
     */
    int tryLockForWrite() { return (cast(t_i__qp)pFunQt[20115])(_wh); }

    /**
     * Попытаться захватить для записи с таймаутом.
     * Params:
     *   msec = максимальное время ожидания.
     * Returns: 1 — захвачено, 0 — таймаут.
     */
    int tryLockForWrite(int msec) { return (cast(t_b__qp_i)pFunQt[20116])(_wh, msec); }

    /**
     * Освободить блокировку (после lockForRead или lockForWrite).
     */
    QReadWriteLock unlock() { (cast(t_v__qp)pFunQt[20117])(_wh); return this; }

    /// Получить нативный указатель на C++ QReadWriteLock.
    void* getWH() { return _wh; }
}
