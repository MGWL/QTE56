#ifndef QTE56_QSQL_BUILD
#define QTE56_QSQL_BUILD
#endif
#include "qte56_qsql.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QString>
#include <QStringList>
#include <QByteArray>
#include <QVariant>
#include <QCoreApplication>
#include <atomic>

// Helper: dereference heap QString* (may be null)
static inline QString qs(void* p) {
    if (!p) return QString();
    return *(QString*)p;
}

// ── Connection wrapper ───────────────────────────────────────────────────────

struct QteDbConn {
    QString connName;
    ~QteDbConn() {
        if (QSqlDatabase::contains(connName)) {
            QSqlDatabase::database(connName).close();
            QSqlDatabase::removeDatabase(connName);
        }
    }
};

static std::atomic<int> g_connCounter(0);

// ── Database lifecycle ───────────────────────────────────────────────────────

void* qteQSql_dbOpen(void* driver,
                      void* dbName,
                      void* host,
                      int port,
                      void* user,
                      void* pass)
{
    QString connName = QString("qte_conn_%1").arg(g_connCounter.fetch_add(1));
    QSqlDatabase db = QSqlDatabase::addDatabase(qs(driver), connName);
    db.setDatabaseName(qs(dbName));
    if (host) db.setHostName(qs(host));
    if (port > 0) db.setPort(port);
    if (user) db.setUserName(qs(user));
    if (pass) db.setPassword(qs(pass));

    if (!db.open()) {
        // cleanup on failure
        QSqlDatabase::removeDatabase(connName);
        return nullptr;
    }

    QteDbConn* conn = new QteDbConn;
    conn->connName = connName;
    return conn;
}

void qteQSql_dbClose(void* conn) {
    delete (QteDbConn*)conn;
}

int qteQSql_dbIsOpen(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return QSqlDatabase::database(c->connName).isOpen() ? 1 : 0;
}

void* qteQSql_dbLastError(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return new QString(QSqlDatabase::database(c->connName).lastError().text());
}

int qteQSql_dbTransaction(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return QSqlDatabase::database(c->connName).transaction() ? 1 : 0;
}

int qteQSql_dbCommit(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return QSqlDatabase::database(c->connName).commit() ? 1 : 0;
}

int qteQSql_dbRollback(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return QSqlDatabase::database(c->connName).rollback() ? 1 : 0;
}

void* qteQSql_dbTables(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    QStringList tables = QSqlDatabase::database(c->connName).tables();
    return new QString(tables.join(QChar('\x01')));
}

void* qteQSql_dbDriverName(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return new QString(QSqlDatabase::database(c->connName).driverName());
}

void qteQSql_addPluginPath(void* path) {
    QCoreApplication::addLibraryPath(qs(path));
}

// ── Query ────────────────────────────────────────────────────────────────────

void* qteQSql_qCreate(void* conn) {
    QteDbConn* c = (QteDbConn*)conn;
    return new QSqlQuery(QSqlDatabase::database(c->connName));
}

void qteQSql_qDelete(void* q) {
    delete (QSqlQuery*)q;
}

int qteQSql_qExec(void* q, void* sql) {
    return ((QSqlQuery*)q)->exec(qs(sql)) ? 1 : 0;
}

int qteQSql_qPrepare(void* q, void* sql) {
    return ((QSqlQuery*)q)->prepare(qs(sql)) ? 1 : 0;
}

int qteQSql_qExecPrepared(void* q) {
    return ((QSqlQuery*)q)->exec() ? 1 : 0;
}

void qteQSql_qBindInt(void* q, int idx, int val) {
    ((QSqlQuery*)q)->bindValue(idx, QVariant(val));
}

void qteQSql_qBindLong(void* q, int idx, long long val) {
    ((QSqlQuery*)q)->bindValue(idx, QVariant((qlonglong)val));
}

void qteQSql_qBindDouble(void* q, int idx, double val) {
    ((QSqlQuery*)q)->bindValue(idx, QVariant(val));
}

void qteQSql_qBindString(void* q, int idx, void* val) {
    ((QSqlQuery*)q)->bindValue(idx, QVariant(qs(val)));
}

// Привязывает параметр как QByteArray. См. .h: для записи cp1251 байт через
// CAST AS VARCHAR в legacy char/varchar-поля.
void qteQSql_qBindBytes(void* q, int idx, const char* data, int len) {
    QByteArray ba = (data && len > 0) ? QByteArray(data, len) : QByteArray();
    ((QSqlQuery*)q)->bindValue(idx, QVariant(ba));
}

void qteQSql_qBindNull(void* q, int idx) {
    ((QSqlQuery*)q)->bindValue(idx, QVariant());
}

int qteQSql_qNext(void* q) {
    return ((QSqlQuery*)q)->next() ? 1 : 0;
}

int qteQSql_qValueInt(void* q, int col) {
    return ((QSqlQuery*)q)->value(col).toInt();
}

long long qteQSql_qValueLong(void* q, int col) {
    return ((QSqlQuery*)q)->value(col).toLongLong();
}

double qteQSql_qValueDouble(void* q, int col) {
    return ((QSqlQuery*)q)->value(col).toDouble();
}

void* qteQSql_qValueString(void* q, int col) {
    return new QString(((QSqlQuery*)q)->value(col).toString());
}

// Возвращает значение как QByteArray (см. .h — для legacy-кодировок
// требуется CAST AS BINARY в SELECT, иначе байты теряются на этапе ODBC).
void* qteQSql_qValueBytes(void* q, int col) {
    return new QByteArray(((QSqlQuery*)q)->value(col).toByteArray());
}

int qteQSql_qIsNull(void* q, int col) {
    return ((QSqlQuery*)q)->isNull(col) ? 1 : 0;
}

int qteQSql_qNumRows(void* q) {
    return ((QSqlQuery*)q)->size();
}

int qteQSql_qNumCols(void* q) {
    return ((QSqlQuery*)q)->record().count();
}

void* qteQSql_qFieldName(void* q, int col) {
    return new QString(((QSqlQuery*)q)->record().fieldName(col));
}

void* qteQSql_qLastError(void* q) {
    return new QString(((QSqlQuery*)q)->lastError().text());
}

long long qteQSql_qLastInsertId(void* q) {
    return ((QSqlQuery*)q)->lastInsertId().toLongLong();
}

int qteQSql_qNumRowsAffected(void* q) {
    return ((QSqlQuery*)q)->numRowsAffected();
}

void qteQSql_qClear(void* q) {
    ((QSqlQuery*)q)->clear();
}
