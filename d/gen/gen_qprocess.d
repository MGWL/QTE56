/**
 * gen_qprocess.d — D wrapper for QProcess.
 * DLL: qte56_qprocess.dll  |  Index block: 19816–19836 (21 функция)
 *
 * Запуск внешних процессов через Qt QProcess.
 *
 * Особенности:
 *   - start(program, args): args передаётся как строки, разделённые \x01
 *   - readAllStdout/Stderr: возвращают ubyte[] без перекодировки
 *   - readStdoutText/StderrText: удобные обёртки, интерпретируют как UTF-8
 *   - connect_finished: прямой C-callback extern(C) void function(int exitCode, int exitStatus)
 *
 * Пример:
 *   auto p = new QProcess();
 *   p.start("ping", ["-n", "1", "localhost"]);
 *   p.waitForFinished(5000);
 *   writeln(p.readStdoutText());
 */
module gen_qprocess;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString, toQStringList, freeQStringList,
    t_b__qp_i, t_i__qp, t_i__qp_qp, t_i__qp_qp_i, t_qp__, t_qp__qp, t_qp__qp_ip,
    t_v__qp, t_v__qp_qp, t_v__qp_qp_qp;

// ── Загрузка функций ───────────────────────────────────────────────────────────

void loadQProcess() {
    mixin(generateFunQt(19816, "qteQProcess_create",             "QProcess"));
    mixin(generateFunQt(19817, "qteQProcess_delete",             "QProcess"));
    mixin(generateFunQt(19818, "qteQProcess_start",              "QProcess"));
    mixin(generateFunQt(19819, "qteQProcess_startDetached",      "QProcess"));
    mixin(generateFunQt(19820, "qteQProcess_waitForStarted",     "QProcess"));
    mixin(generateFunQt(19821, "qteQProcess_waitForFinished",    "QProcess"));
    mixin(generateFunQt(19822, "qteQProcess_kill",               "QProcess"));
    mixin(generateFunQt(19823, "qteQProcess_terminate",          "QProcess"));
    mixin(generateFunQt(19824, "qteQProcess_exitCode",           "QProcess"));
    mixin(generateFunQt(19825, "qteQProcess_exitStatus",         "QProcess"));
    mixin(generateFunQt(19826, "qteQProcess_state",              "QProcess"));
    mixin(generateFunQt(19827, "qteQProcess_setWorkingDirectory","QProcess"));
    mixin(generateFunQt(19828, "qteQProcess_workingDirectory",   "QProcess"));
    mixin(generateFunQt(19829, "qteQProcess_readAllStdout",      "QProcess"));
    mixin(generateFunQt(19830, "qteQProcess_readAllStderr",      "QProcess"));
    mixin(generateFunQt(19831, "qteQProcess_freeBuffer",         "QProcess"));
    mixin(generateFunQt(19832, "qteQProcess_write",              "QProcess"));
    mixin(generateFunQt(19833, "qteQProcess_closeWriteChannel",  "QProcess"));
    mixin(generateFunQt(19834, "qteQProcess_error",              "QProcess"));
    mixin(generateFunQt(19835, "qteQProcess_errorString",        "QProcess"));
    mixin(generateFunQt(19836, "qteQProcess_connect_finished",   "QProcess"));
}

static this() {
    registerModule("QProcess", "qte56_qprocess.dll", &loadQProcess);
}

// ── QProcess ──────────────────────────────────────────────────────────────────

/// Обёртка вокруг QProcess.
/// Жизненный цикл: create в конструкторе, delete в деструкторе.
@live class QProcess {
private:
    void* _wh;

    // Вспомогательная: прочитать буфер и освободить его
    ubyte[] _readBuf(size_t idx) {
        int len;
        void* buf = (cast(t_qp__qp_ip)pFunQt[idx])(_wh, &len);
        if (buf is null || len == 0) return [];
        ubyte[] result = (cast(ubyte*)buf)[0 .. len].dup;
        (cast(t_v__qp)pFunQt[19831])(buf);
        return result;
    }

public:
    /// Создать объект QProcess.
    this() {
        _wh = (cast(t_qp__)pFunQt[19816])();
    }

    ~this() {
        if (_wh !is null) {
            (cast(t_v__qp)pFunQt[19817])(_wh);
            _wh = null;
        }
    }

    /// Запустить процесс. args — массив строк (передаётся через \x01-разделитель).
    QProcess start(string program, string[] args = null) {
        void* wp = toQString(program);
        void* wa = toQStringList(args);
        (cast(t_v__qp_qp_qp)pFunQt[19818])(_wh, wp, wa);
        (cast(t_v__qp)pFunQt[22])(wp);
        freeQStringList(wa);
        return this;
    }

    /// Запустить процесс отдельно (без родителя). Возвращает 1=успех, 0=ошибка.
    static int startDetached(string program, string[] args = null) {
        void* wp = toQString(program);
        void* wa = toQStringList(args);
        int r = (cast(t_i__qp_qp)pFunQt[19819])(wp, wa);
        (cast(t_v__qp)pFunQt[22])(wp);
        freeQStringList(wa);
        return r;
    }

    /// Ждать запуска (мс). Возвращает 1=запустился, 0=таймаут.
    int waitForStarted(int msec = 30000) {
        return (cast(t_b__qp_i)pFunQt[19820])(_wh, msec);
    }

    /// Ждать завершения (мс). Возвращает 1=завершился, 0=таймаут.
    int waitForFinished(int msec = 30000) {
        return (cast(t_b__qp_i)pFunQt[19821])(_wh, msec);
    }

    /// Убить процесс сигналом SIGKILL (немедленно).
    QProcess kill()      { (cast(t_v__qp)pFunQt[19822])(_wh); return this; }

    /// Завершить процесс сигналом SIGTERM (мягко).
    QProcess terminate() { (cast(t_v__qp)pFunQt[19823])(_wh); return this; }

    /// Код завершения процесса (только после waitForFinished).
    int exitCode()   { return (cast(t_i__qp)pFunQt[19824])(_wh); }

    /// Статус завершения: 0=NormalExit, 1=CrashExit.
    int exitStatus() { return (cast(t_i__qp)pFunQt[19825])(_wh); }

    /// Состояние: 0=NotRunning, 1=Starting, 2=Running.
    int state()      { return (cast(t_i__qp)pFunQt[19826])(_wh); }

    /// Установить рабочий каталог для запускаемого процесса.
    QProcess setWorkingDirectory(string path) {
        void* wp = toQString(path);
        (cast(t_v__qp_qp)pFunQt[19827])(_wh, wp);
        (cast(t_v__qp)pFunQt[22])(wp);
        return this;
    }

    /// Получить рабочий каталог.
    string workingDirectory() {
        void* qs = (cast(t_qp__qp)pFunQt[19828])(_wh);
        return fromQString(qs);
    }

    /// Прочитать stdout как сырые байты (без перекодировки).
    ubyte[] readAllStdout() { return _readBuf(19829); }

    /// Прочитать stderr как сырые байты (без перекодировки).
    ubyte[] readAllStderr() { return _readBuf(19830); }

    /// Прочитать stdout как UTF-8 строку.
    string readStdoutText() {
        ubyte[] b = readAllStdout();
        return cast(string)b;
    }

    /// Прочитать stderr как UTF-8 строку.
    string readStderrText() {
        ubyte[] b = readAllStderr();
        return cast(string)b;
    }

    /// Записать данные в stdin процесса. Возвращает число записанных байт.
    int write(const(ubyte)[] data) {
        if (data.length == 0) return 0;
        return (cast(t_i__qp_qp_i)pFunQt[19832])(_wh, cast(void*)data.ptr, cast(int)data.length);
    }

    /// Записать строку в stdin (UTF-8).
    int writeText(string s) {
        return write(cast(const(ubyte)[])s);
    }

    /// Закрыть канал записи в stdin (сигнализирует EOF процессу).
    QProcess closeWriteChannel() { (cast(t_v__qp)pFunQt[19833])(_wh); return this; }

    /// Код ошибки QProcess::ProcessError (0=FailedToStart,1=Crashed,2=Timedout,…).
    int error() { return (cast(t_i__qp)pFunQt[19834])(_wh); }

    /// Человекочитаемое описание последней ошибки.
    string errorString() {
        void* qs = (cast(t_qp__qp)pFunQt[19835])(_wh);
        return fromQString(qs);
    }

    /// Подключить сигнал finished(exitCode, exitStatus).
    /// cb должен быть: extern(C) void function(int exitCode, int exitStatus)
    QProcess connect_finished(void* cb) {
        (cast(t_v__qp_qp)pFunQt[19836])(_wh, cb);
        return this;
    }

    void* getWH() { return _wh; }
}
