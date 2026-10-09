#pragma once

/*
 * qte56_network.h — QUrl / QNetworkRequest / QNetworkReply / QNetworkAccessManager
 * Index block: 20005–20041
 * DLL: qte56_network.dll / libqte56_network.so
 * QT += network
 */

#ifdef _WIN32
  #ifdef QTE56_NETWORK_BUILD
    #define NET_API __declspec(dllexport)
  #else
    #define NET_API __declspec(dllimport)
  #endif
#else
  #define NET_API __attribute__((visibility("default")))
#endif

extern "C" {

/* ── QUrl (20005–20012) ──────────────────────────────────────────────────── */

NET_API void* qteQUrl_create    (const wchar_t* str, int len);   /* new QUrl(str)       */
NET_API void  qteQUrl_delete    (void* url);
NET_API void* qteQUrl_toString  (void* url);                     /* → new QString*      */
NET_API int   qteQUrl_isValid   (void* url);
NET_API void* qteQUrl_scheme    (void* url);                     /* → new QString*      */
NET_API void* qteQUrl_host      (void* url);                     /* → new QString*      */
NET_API void* qteQUrl_path      (void* url);                     /* → new QString*      */
NET_API int   qteQUrl_port      (void* url);                     /* -1 if not set       */

/* ── QNetworkRequest (20013–20018) ──────────────────────────────────────── */

NET_API void* qteQNetworkRequest_create  (const wchar_t* url, int len); /* heap-allocate */
NET_API void  qteQNetworkRequest_delete  (void* req);
NET_API void  qteQNetworkRequest_setRawHeader (void* req,
                  const wchar_t* name, int nlen,
                  const wchar_t* val,  int vlen);
NET_API void  qteQNetworkRequest_setUrl  (void* req, const wchar_t* url, int len);
NET_API void* qteQNetworkRequest_url     (void* req);            /* → new QString*      */
NET_API void  qteQNetworkRequest_setAttribute_followRedirects(void* req, int follow);

/* ── QNetworkReply (20019–20032) ────────────────────────────────────────── */

NET_API int   qteQNetworkReply_error         (void* reply);     /* NetworkError enum   */
NET_API void* qteQNetworkReply_errorString   (void* reply);     /* → new QString*      */
NET_API void* qteQNetworkReply_readAll       (void* reply);     /* → new QByteArray*   */
NET_API int   qteQNetworkReply_statusCode    (void* reply);     /* HTTP status (no QVariant) */
NET_API void* qteQNetworkReply_url           (void* reply);     /* → new QString*      */
NET_API void* qteQNetworkReply_rawHeader     (void* reply,
                  const wchar_t* name, int nlen);               /* → new QString*      */
NET_API void  qteQNetworkReply_deleteLater   (void* reply);
NET_API void  qteQNetworkReply_abort         (void* reply);
NET_API int   qteQNetworkReply_bytesAvailable(void* reply);     /* cast qint64→int     */
NET_API int   qteQNetworkReply_isFinished    (void* reply);

/* Direct callbacks — no ESlot dependency:
 *   cb signature for finished/readyRead : void(void* dthis, int n)
 *   cb signature for errorOccurred      : void(void* dthis, int n, int errorCode)
 *   cb signature for downloadProgress   : void(void* dthis, int n, long long rx, long long total)
 *   cb signature for uploadProgress     : void(void* dthis, int n, long long sent, long long total)
 *   cb signature for sslErrors          : void(void* dthis, int n, int errorCount)
 */
NET_API void  qteQNetworkReply_connect_finished         (void* reply, void* cb, void* dthis, int n);
NET_API void  qteQNetworkReply_connect_readyRead         (void* reply, void* cb, void* dthis, int n);
NET_API void  qteQNetworkReply_connect_errorOccurred     (void* reply, void* cb, void* dthis, int n);
NET_API void  qteQNetworkReply_connect_downloadProgress  (void* reply, void* cb, void* dthis, int n);

/* ── QNetworkReply extras (20042–20045) ─────────────────────────────────── */

NET_API void  qteQNetworkReply_ignoreSslErrors           (void* reply);
NET_API void  qteQNetworkReply_connect_sslErrors         (void* reply, void* cb, void* dthis, int n);
NET_API void  qteQNetworkReply_connect_uploadProgress    (void* reply, void* cb, void* dthis, int n);
NET_API void* qteQNetworkReply_rawHeaderList              (void* reply); /* → QString* \x01-joined */

/* ── QNetworkAccessManager (20033–20041) ────────────────────────────────── */

NET_API void* qteQNetworkAccessManager_create       (void* parent);
NET_API void  qteQNetworkAccessManager_delete       (void* mgr);
NET_API void* qteQNetworkAccessManager_get          (void* mgr, void* req);
NET_API void* qteQNetworkAccessManager_post         (void* mgr, void* req, void* body_ba);
NET_API void* qteQNetworkAccessManager_put          (void* mgr, void* req, void* body_ba);
NET_API void* qteQNetworkAccessManager_deleteResource(void* mgr, void* req);
NET_API void* qteQNetworkAccessManager_head         (void* mgr, void* req);
NET_API void  qteQNetworkAccessManager_setUseSystemProxy(void* mgr);

/* cb signature: void(void* dthis, int n, void* replyPtr) */
NET_API void  qteQNetworkAccessManager_connect_finished(void* mgr, void* cb, void* dthis, int n);

} /* extern "C" */
