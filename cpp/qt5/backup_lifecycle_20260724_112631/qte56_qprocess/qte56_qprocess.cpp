#include "qte56_qprocess.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QProcess>
#include <QString>
#include <QStringList>
#include <QByteArray>
#include <cstring>

// ── Вспомогательная: строка с разделителем \x01 → QStringList ────────────────
// Если qs==null — возвращает пустой список (процесс без аргументов)
static QStringList qsListFromSep1(void* qs) {
    if (!qs) return QStringList();
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1)); // KeepEmptyParts — сохраняем пустые аргументы
}

// ── Вспомогательная: скопировать QByteArray в heap, вернуть указатель + длину ─
static void* baToHeap(const QByteArray& ba, int* len) {
    *len = ba.size();
    if (ba.size() == 0) return nullptr;
    char* buf = new char[ba.size()];
    memcpy(buf, ba.constData(), ba.size());
    return buf;
}

// ── Жизненный цикл ────────────────────────────────────────────────────────────

void* qteQProcess_create() {
    return qte_createTracked(new QProcess();
}

void qteQProcess_delete(void* proc) {
    delete (QProcess*)proc;
}

// ── Запуск ────────────────────────────────────────────────────────────────────

void qteQProcess_start(void* proc, void* program, void* args) {
    ((QProcess*)proc)->start(*(QString*)program, qsListFromSep1(args));
}

int qteQProcess_startDetached(void* program, void* args) {
    return QProcess::startDetached(*(QString*)program, qsListFromSep1(args)) ? 1 : 0;
}

// ── Ожидание ──────────────────────────────────────────────────────────────────

int qteQProcess_waitForStarted(void* proc, int msec) {
    return ((QProcess*)proc)->waitForStarted(msec) ? 1 : 0;
}

int qteQProcess_waitForFinished(void* proc, int msec) {
    return ((QProcess*)proc)->waitForFinished(msec) ? 1 : 0;
}

// ── Управление ────────────────────────────────────────────────────────────────

void qteQProcess_kill(void* proc) {
    ((QProcess*)proc)->kill();
}

void qteQProcess_terminate(void* proc) {
    ((QProcess*)proc)->terminate();
}

// ── Результат завершения ──────────────────────────────────────────────────────

int qteQProcess_exitCode(void* proc) {
    return ((QProcess*)proc)->exitCode();
}

int qteQProcess_exitStatus(void* proc) {
    return (int)((QProcess*)proc)->exitStatus(); // 0=Normal 1=Crash
}

int qteQProcess_state(void* proc) {
    return (int)((QProcess*)proc)->state(); // 0=NotRunning 1=Starting 2=Running
}

// ── Рабочий каталог ───────────────────────────────────────────────────────────

void qteQProcess_setWorkingDirectory(void* proc, void* path) {
    ((QProcess*)proc)->setWorkingDirectory(*(QString*)path);
}

// Возвращает новый QString* — освободить на стороне D через qteQString_free
void* qteQProcess_workingDirectory(void* proc) {
    return new QString(((QProcess*)proc)->workingDirectory());
}

// ── Чтение stdout / stderr ────────────────────────────────────────────────────

void* qteQProcess_readAllStdout(void* proc, int* len) {
    return baToHeap(((QProcess*)proc)->readAllStandardOutput(), len);
}

void* qteQProcess_readAllStderr(void* proc, int* len) {
    return baToHeap(((QProcess*)proc)->readAllStandardError(), len);
}

void qteQProcess_freeBuffer(void* buf) {
    delete[] (char*)buf;
}

// ── Запись в stdin ────────────────────────────────────────────────────────────

int qteQProcess_write(void* proc, void* data, int len) {
    return (int)((QProcess*)proc)->write((const char*)data, len);
}

void qteQProcess_closeWriteChannel(void* proc) {
    ((QProcess*)proc)->closeWriteChannel();
}

// ── Ошибка ────────────────────────────────────────────────────────────────────

int qteQProcess_error(void* proc) {
    return (int)((QProcess*)proc)->error();
}

void* qteQProcess_errorString(void* proc) {
    return new QString(((QProcess*)proc)->errorString());
}

// ── Сигнал finished ───────────────────────────────────────────────────────────
// cb — C-функция вида: void callback(int exitCode, int exitStatus)
void qteQProcess_connect_finished(void* proc, void* cb) {
    auto fn = (void(*)(int, int))cb;
    QObject::connect(
        (QProcess*)proc,
        QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [fn](int code, QProcess::ExitStatus st) { fn(code, (int)st); });
}
