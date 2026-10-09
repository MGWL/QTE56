/*
 * qte56_network.cpp — QUrl / QNetworkRequest / QNetworkReply / QNetworkAccessManager
 * Index block: 20005–20041
 *
 * Cross-platform notes:
 *  - Windows 32-bit (MinGW): long long = 64-bit, matches D's `long`
 *  - Linux 64-bit (gcc/clang): long long = 64-bit, matches D's `long`
 *  - Qt version: errorOccurred signal added in Qt 5.15; handled via #if QT_VERSION
 *  - SSL: Windows needs OpenSSL DLLs in ./dll/; Linux uses system libssl
 */

#include "qte56_network.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"

#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkProxy>
#include <QByteArray>
#include <QString>
#include <QStringList>
#include <QSslError>

/* ── callback typedefs ───────────────────────────────────────────────────── */

typedef void (*fn_v)   (void* dthis, int n);
typedef void (*fn_vi)  (void* dthis, int n, int val);
typedef void (*fn_vll) (void* dthis, int n, long long rx, long long total);
typedef void (*fn_vp)  (void* dthis, int n, void* ptr);

/* ── helpers ─────────────────────────────────────────────────────────────── */

static inline QString wstr(const wchar_t* s, int len) {
    return dWstringToQString(s, len);
}

static inline QString* newQString(const QString& s) {
    return new QString(s);
}

/* ============================================================
   QUrl (20005–20012)
   ============================================================ */

void* qteQUrl_create(const wchar_t* str, int len) {
    return new QUrl(wstr(str, len));
}
void  qteQUrl_delete  (void* url)  { delete (QUrl*)url; }
void* qteQUrl_toString(void* url)  { return newQString(((QUrl*)url)->toString()); }
int   qteQUrl_isValid (void* url)  { return ((QUrl*)url)->isValid() ? 1 : 0; }
void* qteQUrl_scheme  (void* url)  { return newQString(((QUrl*)url)->scheme()); }
void* qteQUrl_host    (void* url)  { return newQString(((QUrl*)url)->host()); }
void* qteQUrl_path    (void* url)  { return newQString(((QUrl*)url)->path()); }
int   qteQUrl_port    (void* url)  { return ((QUrl*)url)->port(); }  /* -1 if not set */

/* ============================================================
   QNetworkRequest (20013–20018)
   Heap-allocated value type so D can hold void* to it.
   ============================================================ */

void* qteQNetworkRequest_create(const wchar_t* url, int len) {
    return new QNetworkRequest(QUrl(wstr(url, len)));
}
void  qteQNetworkRequest_delete(void* req) { delete (QNetworkRequest*)req; }

void  qteQNetworkRequest_setRawHeader(void* req,
          const wchar_t* name, int nlen,
          const wchar_t* val,  int vlen)
{
    QByteArray headerName  = wstr(name, nlen).toLatin1();  /* HTTP names: ASCII   */
    QByteArray headerValue = wstr(val,  vlen).toUtf8();    /* values: UTF-8 safe  */
    ((QNetworkRequest*)req)->setRawHeader(headerName, headerValue);
}

void  qteQNetworkRequest_setUrl(void* req, const wchar_t* url, int len) {
    ((QNetworkRequest*)req)->setUrl(QUrl(wstr(url, len)));
}

void* qteQNetworkRequest_url(void* req) {
    return newQString(((QNetworkRequest*)req)->url().toString());
}

void  qteQNetworkRequest_setAttribute_followRedirects(void* req, int follow) {
#if QT_VERSION >= QT_VERSION_CHECK(5, 6, 0)
    ((QNetworkRequest*)req)->setAttribute(
        QNetworkRequest::FollowRedirectsAttribute, follow != 0);
#else
    (void)req; (void)follow;
#endif
}

/* ============================================================
   QNetworkReply (20019–20032)
   Qt-owned (returned by manager); D wraps with wrap() pattern.
   ============================================================ */

int   qteQNetworkReply_error(void* reply) {
    return (int)((QNetworkReply*)reply)->error();
}
void* qteQNetworkReply_errorString(void* reply) {
    return newQString(((QNetworkReply*)reply)->errorString());
}

void* qteQNetworkReply_readAll(void* reply) {
    /* Returns heap-allocated QByteArray* — caller must delete */
    return new QByteArray(((QNetworkReply*)reply)->readAll());
}

int   qteQNetworkReply_statusCode(void* reply) {
    /* Avoid QVariant binding: extract int directly */
    QVariant v = ((QNetworkReply*)reply)->attribute(
        QNetworkRequest::HttpStatusCodeAttribute);
    return v.isValid() ? v.toInt() : 0;
}

void* qteQNetworkReply_url(void* reply) {
    return newQString(((QNetworkReply*)reply)->url().toString());
}

void* qteQNetworkReply_rawHeader(void* reply, const wchar_t* name, int nlen) {
    QByteArray key = wstr(name, nlen).toLatin1();
    return newQString(QString::fromUtf8(((QNetworkReply*)reply)->rawHeader(key)));
}

void  qteQNetworkReply_deleteLater(void* reply) {
    ((QNetworkReply*)reply)->deleteLater();
}
void  qteQNetworkReply_abort(void* reply) {
    ((QNetworkReply*)reply)->abort();
}

int   qteQNetworkReply_bytesAvailable(void* reply) {
    return (int)((QNetworkReply*)reply)->bytesAvailable();
}
int   qteQNetworkReply_isFinished(void* reply) {
    return ((QNetworkReply*)reply)->isFinished() ? 1 : 0;
}

/* ── QNetworkReply signals ───────────────────────────────────────────────── */

void  qteQNetworkReply_connect_finished(void* reply, void* cb, void* dthis, int n) {
    fn_v fn = (fn_v)cb;
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::finished,
        [fn, dthis, n]() { fn(dthis, n); });
}

void  qteQNetworkReply_connect_readyRead(void* reply, void* cb, void* dthis, int n) {
    fn_v fn = (fn_v)cb;
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::readyRead,
        [fn, dthis, n]() { fn(dthis, n); });
}

void  qteQNetworkReply_connect_errorOccurred(void* reply, void* cb, void* dthis, int n) {
    fn_vi fn = (fn_vi)cb;
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::errorOccurred,
        [fn, dthis, n](QNetworkReply::NetworkError e) { fn(dthis, n, (int)e); });
#else
    /* Qt < 5.15: signal is QNetworkReply::error(NetworkError) — use QOverload to
       disambiguate from the error() accessor method */
    QObject::connect((QNetworkReply*)reply,
        QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
        [fn, dthis, n](QNetworkReply::NetworkError e) { fn(dthis, n, (int)e); });
#endif
}

void  qteQNetworkReply_connect_downloadProgress(void* reply, void* cb, void* dthis, int n) {
    /* long long is 64-bit on both Win32 (MinGW) and Linux64 — matches D's `long` */
    fn_vll fn = (fn_vll)cb;
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::downloadProgress,
        [fn, dthis, n](qint64 rx, qint64 total) {
            fn(dthis, n, (long long)rx, (long long)total);
        });
}

/* ============================================================
   QNetworkAccessManager (20033–20041)
   ============================================================ */

void* qteQNetworkAccessManager_create(void* parent) {
    return qte_createTracked(new QNetworkAccessManager((QObject*)parent);
}
void  qteQNetworkAccessManager_delete(void* mgr) {
    delete (QNetworkAccessManager*)mgr;
}

void* qteQNetworkAccessManager_get(void* mgr, void* req) {
    return (void*)((QNetworkAccessManager*)mgr)->get(*(QNetworkRequest*)req);
}
void* qteQNetworkAccessManager_post(void* mgr, void* req, void* body_ba) {
    return (void*)((QNetworkAccessManager*)mgr)->post(
        *(QNetworkRequest*)req, *(QByteArray*)body_ba);
}
void* qteQNetworkAccessManager_put(void* mgr, void* req, void* body_ba) {
    return (void*)((QNetworkAccessManager*)mgr)->put(
        *(QNetworkRequest*)req, *(QByteArray*)body_ba);
}
void* qteQNetworkAccessManager_deleteResource(void* mgr, void* req) {
    return (void*)((QNetworkAccessManager*)mgr)->deleteResource(*(QNetworkRequest*)req);
}
void* qteQNetworkAccessManager_head(void* mgr, void* req) {
    return (void*)((QNetworkAccessManager*)mgr)->head(*(QNetworkRequest*)req);
}

void  qteQNetworkAccessManager_setUseSystemProxy(void* mgr) {
    /* Tell Qt to use OS-level proxy settings (env vars on Linux, IE/system on Windows) */
    QNetworkProxy proxy = QNetworkProxy::applicationProxy();
    if (proxy.type() == QNetworkProxy::DefaultProxy) {
        QNetworkProxyFactory::setUseSystemConfiguration(true);
    }
    (void)mgr;
}

/* ── QNetworkReply extras (20042–20045) ─────────────────────────────────── */

void  qteQNetworkReply_ignoreSslErrors(void* reply) {
    ((QNetworkReply*)reply)->ignoreSslErrors();
}

void  qteQNetworkReply_connect_sslErrors(void* reply, void* cb, void* dthis, int n) {
    fn_vi fn = (fn_vi)cb;
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::sslErrors,
        [fn, dthis, n](const QList<QSslError>& errors) {
            fn(dthis, n, errors.size());
        });
}

void  qteQNetworkReply_connect_uploadProgress(void* reply, void* cb, void* dthis, int n) {
    fn_vll fn = (fn_vll)cb;
    QObject::connect((QNetworkReply*)reply, &QNetworkReply::uploadProgress,
        [fn, dthis, n](qint64 sent, qint64 total) {
            fn(dthis, n, (long long)sent, (long long)total);
        });
}

void* qteQNetworkReply_rawHeaderList(void* reply) {
    QList<QByteArray> headers = ((QNetworkReply*)reply)->rawHeaderList();
    QStringList parts;
    for (const QByteArray& h : headers)
        parts << QString::fromLatin1(h);
    return new QString(parts.join('\x01'));
}

/* ── QNetworkAccessManager ────────────────────────────────────────────────── */

void  qteQNetworkAccessManager_connect_finished(void* mgr, void* cb, void* dthis, int n) {
    fn_vp fn = (fn_vp)cb;
    QObject::connect((QNetworkAccessManager*)mgr, &QNetworkAccessManager::finished,
        [fn, dthis, n](QNetworkReply* reply) { fn(dthis, n, (void*)reply); });
}
