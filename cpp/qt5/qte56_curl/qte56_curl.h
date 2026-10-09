#pragma once
/*
 * qte56_curl.h — libcurl wrapper for QTE56
 * Index block: 20046–20072
 * DLL: qte56_curl.dll
 *
 * NO Qt dependency. Loads libcurl.dll at runtime via LoadLibrary.
 * libcurl.dll must be in the same directory as qte56_curl.dll.
 *
 * String return values (getBody/getError) are valid until the next
 * qteCurl_perform() or qteCurl_reset() call on the same session.
 */

#ifdef _WIN32
  #ifdef QTE56_CURL_BUILD
    #define CAPI __declspec(dllexport)
  #else
    #define CAPI __declspec(dllimport)
  #endif
#else
  #define CAPI __attribute__((visibility("default")))
#endif

extern "C" {

/* 20046 — load libcurl.dll + curl_global_init. Call once before create(). */
CAPI void  qteCurl_globalInit    ();
/* 20047 */
CAPI void  qteCurl_globalCleanup ();

/* 20048 — create session handle */
CAPI void* qteCurl_create        ();
/* 20049 */
CAPI void  qteCurl_destroy       (void* h);

/* ── Target URL ──────────────────────────────────────────────────────────── */
/* 20050  Protocol determined by URL scheme:
 *   http://   https://   ftp://   ftps://   sftp://   scp://    */
CAPI void  qteCurl_setUrl        (void* h, const wchar_t* url,  int len);

/* ── Authentication ──────────────────────────────────────────────────────── */
/* 20051 */ CAPI void qteCurl_setUser        (void* h, const wchar_t* user, int len);
/* 20052 */ CAPI void qteCurl_setPassword    (void* h, const wchar_t* pass, int len);

/* ── SSL ─────────────────────────────────────────────────────────────────── */
/* 20053  verify=1 (default), verify=0 skips certificate check */
CAPI void  qteCurl_setSslVerify  (void* h, int verify);
/* 20054  path to cacert.pem */
CAPI void  qteCurl_setCaInfo     (void* h, const wchar_t* path, int len);

/* ── SSH / SFTP ───────────────────────────────────────────────────────────  */
/* 20055 */ CAPI void qteCurl_setSshPrivateKey(void* h, const wchar_t* path, int len);
/* 20056 */ CAPI void qteCurl_setSshPublicKey (void* h, const wchar_t* path, int len);
/* 20057 */ CAPI void qteCurl_setKnownHosts   (void* h, const wchar_t* path, int len);

/* ── Transfer options ────────────────────────────────────────────────────── */
/* 20058  timeout in seconds (0 = no timeout) */
CAPI void  qteCurl_setTimeout         (void* h, int seconds);
/* 20059 */ CAPI void qteCurl_setFollowRedirects(void* h, int follow);
/* 20060 */ CAPI void qteCurl_setVerbose        (void* h, int verbose);

/* ── HTTP-specific ───────────────────────────────────────────────────────── */
/* 20061  method: "GET" "POST" "PUT" "DELETE" "HEAD" "PATCH" */
CAPI void  qteCurl_setMethod     (void* h, const wchar_t* method, int len);
/* 20062  POST/PUT body (UTF-8). curl copies internally. */
CAPI void  qteCurl_setPostBody   (void* h, const wchar_t* body,   int len);
/* 20063  add single header: "Name: Value" */
CAPI void  qteCurl_addHeader     (void* h, const wchar_t* header, int len);
/* 20064 */
CAPI void  qteCurl_clearHeaders  (void* h);

/* ── File transfer ───────────────────────────────────────────────────────── */
/* 20065  upload local file → remote URL (FTP/SFTP/HTTP PUT) */
CAPI void  qteCurl_setUploadFile  (void* h, const wchar_t* localPath, int len);
/* 20066  download remote URL → local file */
CAPI void  qteCurl_setDownloadFile(void* h, const wchar_t* localPath, int len);

/* ── Execute ─────────────────────────────────────────────────────────────── */
/* 20067  returns CURLcode: 0=CURLE_OK */
CAPI int   qteCurl_perform        (void* h);

/* ── Results (valid until next perform/reset) ────────────────────────────── */
/* 20068 */ CAPI const char* qteCurl_getBody        (void* h);  /* UTF-8 response body */
/* 20069 */ CAPI int         qteCurl_getStatusCode  (void* h);  /* HTTP/FTP status     */
/* 20070 */ CAPI const char* qteCurl_getError       (void* h);  /* error description   */
/* 20071 */ CAPI long long   qteCurl_getTransferSize(void* h);  /* bytes transferred   */

/* 20072  reset options for reuse (keeps handle, clears all setXxx state) */
CAPI void  qteCurl_reset         (void* h);

} /* extern "C" */
