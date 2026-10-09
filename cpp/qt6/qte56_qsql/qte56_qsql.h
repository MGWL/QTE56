#pragma once
#ifdef _WIN32
#  ifdef QTE56_QSQL_BUILD
#    define QSQL_API __declspec(dllexport)
#  else
#    define QSQL_API __declspec(dllimport)
#  endif
#else
#  define QSQL_API __attribute__((visibility("default")))
#endif
extern "C" {

// ── Database lifecycle ───────────────────────────────────────────────────────
// driver/dbName/host/user/pass as char16_t+len pairs; host/user/pass may be null
QSQL_API void* qteQSql_dbOpen(void* driver,
                               void* dbName,
                               void* host,
                               int port,
                               void* user,
                               void* pass);
QSQL_API void  qteQSql_dbClose(void* conn);
QSQL_API int   qteQSql_dbIsOpen(void* conn);
QSQL_API void* qteQSql_dbLastError(void* conn);
QSQL_API int   qteQSql_dbTransaction(void* conn);
QSQL_API int   qteQSql_dbCommit(void* conn);
QSQL_API int   qteQSql_dbRollback(void* conn);
QSQL_API void* qteQSql_dbTables(void* conn);
QSQL_API void* qteQSql_dbDriverName(void* conn);
QSQL_API void  qteQSql_addPluginPath(void* path);

// ── Query ────────────────────────────────────────────────────────────────────
QSQL_API void* qteQSql_qCreate(void* conn);
QSQL_API void  qteQSql_qDelete(void* q);
QSQL_API int   qteQSql_qExec(void* q, void* sql);
QSQL_API int   qteQSql_qPrepare(void* q, void* sql);
QSQL_API int   qteQSql_qExecPrepared(void* q);
QSQL_API void  qteQSql_qBindInt(void* q, int idx, int val);
QSQL_API void  qteQSql_qBindLong(void* q, int idx, long long val);
QSQL_API void  qteQSql_qBindDouble(void* q, int idx, double val);
QSQL_API void  qteQSql_qBindString(void* q, int idx, void* val);
// Привязывает параметр как QByteArray (сырые байты, без перекодировки).
// Используется для записи cp1251/cp866-данных в legacy char/varchar-поля
// через `INSERT ... VALUES (CAST(? AS VARCHAR(N)))`.
// data может быть NULL если len == 0 (тогда привязывается пустой QByteArray).
QSQL_API void  qteQSql_qBindBytes(void* q, int idx, const char* data, int len);
QSQL_API void  qteQSql_qBindNull(void* q, int idx);
QSQL_API int   qteQSql_qNext(void* q);
QSQL_API int   qteQSql_qValueInt(void* q, int col);
QSQL_API long long qteQSql_qValueLong(void* q, int col);
QSQL_API double qteQSql_qValueDouble(void* q, int col);
QSQL_API void* qteQSql_qValueString(void* q, int col);
// Возвращает значение колонки как сырой QByteArray (новый, владелец — caller).
// Для полей-байтов (BLOB/VARBINARY/RAW) — даёт оригинальные байты драйвера.
// Для строковых полей — UTF-8 (как QVariant::toByteArray для QString).
// Чтобы получить байты в legacy-кодировке (cp1251 и т.п.) для VARCHAR-полей,
// нужно в SELECT делать CAST(field AS BINARY/VARBINARY) — иначе драйвер ODBC
// уже сконвертирует их в QString с применением своего кодека.
QSQL_API void* qteQSql_qValueBytes(void* q, int col);
QSQL_API int   qteQSql_qIsNull(void* q, int col);
QSQL_API int   qteQSql_qNumRows(void* q);
QSQL_API int   qteQSql_qNumCols(void* q);
QSQL_API void* qteQSql_qFieldName(void* q, int col);
QSQL_API void* qteQSql_qLastError(void* q);
QSQL_API long long qteQSql_qLastInsertId(void* q);
QSQL_API int   qteQSql_qNumRowsAffected(void* q);
QSQL_API void  qteQSql_qClear(void* q);

} // extern "C"
