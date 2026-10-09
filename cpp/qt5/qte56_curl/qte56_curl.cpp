/*
 * qte56_curl.cpp — libcurl runtime wrapper (cross-platform: Windows + Linux)
 *
 * Windows: loads libcurl.dll at runtime via LoadLibraryA.
 *          libcurl.dll must be in PATH (LoadQt adds ./dll/ automatically).
 * Linux:   loads libcurl.so.4 at runtime via dlopen.
 *          Install: apt install libcurl4-openssl-dev (or libcurl4-gnutls-dev)
 *          For SFTP: libcurl must be built with libssh2 (standard in distro packages).
 *
 * String conversion: uses Qt's QString::fromUtf16() which always interprets
 * the D-side wstring (always 2-byte UTF-16) correctly on both platforms,
 * unlike fromWCharArray() which uses platform wchar_t size (4 bytes on Linux).
 *
 * Supported protocols: http  https  ftp  ftps  sftp  scp
 */

#include "qte56_curl.h"

#include <QString>
#include <string>
#include <cstdio>
#include <cstring>

/* ── Platform: dynamic loading ───────────────────────────────────────────── */

#ifdef _WIN32
#  define WIN32_LEAN_AND_MEAN
#  include <windows.h>
   typedef HMODULE lib_handle_t;
   static inline lib_handle_t lib_open(const char* name)          { return LoadLibraryA(name); }
   static inline void*        lib_sym (lib_handle_t h, const char* s) { return (void*)GetProcAddress(h, s); }
   static inline void         lib_close(lib_handle_t h)           { FreeLibrary(h); }
   static inline bool         lib_ok  (lib_handle_t h)            { return h != nullptr; }
#else
#  include <dlfcn.h>
   typedef void* lib_handle_t;
   static inline lib_handle_t lib_open(const char* name)          { return dlopen(name, RTLD_LAZY | RTLD_LOCAL); }
   static inline void*        lib_sym (lib_handle_t h, const char* s) { return dlsym(h, s); }
   static inline void         lib_close(lib_handle_t h)           { dlclose(h); }
   static inline bool         lib_ok  (lib_handle_t h)            { return h != nullptr; }
#endif

/* On Linux __cdecl doesn't exist — cdecl is the default calling convention */
#ifndef _WIN32
#  define __cdecl
#endif

/* ── libcurl option constants (stable since libcurl 7.x) ─────────────────── */

#define CURL_GLOBAL_DEFAULT      3
#define CURLOPT_WRITEFUNCTION    20011
#define CURLOPT_WRITEDATA        10001
#define CURLOPT_READFUNCTION     20012
#define CURLOPT_READDATA         10009
#define CURLOPT_ERRORBUFFER      10010
#define CURLOPT_URL              10002
#define CURLOPT_USERNAME         10173
#define CURLOPT_PASSWORD         10174
#define CURLOPT_SSL_VERIFYPEER   64
#define CURLOPT_SSL_VERIFYHOST   81
#define CURLOPT_CAINFO           10065
#define CURLOPT_SSH_PRIVATE_KEYFILE  10153
#define CURLOPT_SSH_PUBLIC_KEYFILE   10152
#define CURLOPT_SSH_KNOWNHOSTS   10183
#define CURLOPT_TIMEOUT          13
#define CURLOPT_FOLLOWLOCATION   52
#define CURLOPT_VERBOSE          41
#define CURLOPT_CUSTOMREQUEST    10036
#define CURLOPT_COPYPOSTFIELDS   10165
#define CURLOPT_POSTFIELDSIZE    60
#define CURLOPT_HTTPHEADER       10023
#define CURLOPT_UPLOAD           46
#define CURLOPT_INFILESIZE_LARGE 30115
#define CURLOPT_NOBODY           44
#define CURLOPT_HTTPGET          80
#define CURLOPT_POST             47
#define CURLINFO_RESPONSE_CODE   0x200002

typedef void   CURL;
typedef void*  curl_slist;
typedef size_t(*curl_cb)(char*, size_t, size_t, void*);

/* ── Function pointer types ──────────────────────────────────────────────── */

typedef int         (__cdecl *fn_ginit)   (long flags);
typedef void        (__cdecl *fn_gclean)  ();
typedef CURL*       (__cdecl *fn_init)    ();
typedef void        (__cdecl *fn_cleanup) (CURL*);
typedef int         (__cdecl *fn_perform) (CURL*);
typedef void        (__cdecl *fn_reset)   (CURL*);
typedef int         (__cdecl *fn_sopt_ptr)(CURL*, int, const void*);
typedef int         (__cdecl *fn_sopt_lng)(CURL*, int, long);
typedef int         (__cdecl *fn_sopt_ll) (CURL*, int, long long);
typedef int         (__cdecl *fn_ginfo_l) (CURL*, int, long*);
typedef void*       (__cdecl *fn_slapp)   (void*, const char*);
typedef void        (__cdecl *fn_slfree)  (void*);
typedef const char* (__cdecl *fn_sterr)   (int);

/* ── Global libcurl function table ────────────────────────────────────────── */

static struct {
    lib_handle_t lib;
    fn_ginit    g_init;
    fn_gclean   g_cleanup;
    fn_init     easy_init;
    fn_cleanup  easy_cleanup;
    fn_perform  easy_perform;
    fn_reset    easy_reset;
    fn_sopt_ptr sopt_ptr;
    fn_sopt_lng sopt_lng;
    fn_sopt_ll  sopt_ll;
    fn_ginfo_l  ginfo_l;
    fn_slapp    slist_append;
    fn_slfree   slist_free;
    fn_sterr    strerror;
} g;

/* ── CurlSession ─────────────────────────────────────────────────────────── */

struct CurlSession {
    CURL*        easy;
    curl_slist*  headers;
    std::string  body_buf;
    FILE*        upload_fp;
    FILE*        download_fp;
    char         errbuf[256];   /* CURL_ERROR_SIZE = 256 */
    long         status_code;
    long long    transfer_size;
    std::string  url, user, pass, cainfo;
    std::string  ssh_priv, ssh_pub, known_hosts;
    std::string  method, post_body;
    std::string  upload_path, download_path;
    std::string  ret_error;
};

/* ── Write / read callbacks ──────────────────────────────────────────────── */

static size_t write_cb(char* ptr, size_t sz, size_t n, void* ud) {
    CurlSession* s = (CurlSession*)ud;
    size_t total = sz * n;
    if (s->download_fp)
        fwrite(ptr, sz, n, s->download_fp);
    else
        s->body_buf.append(ptr, total);
    s->transfer_size += (long long)total;
    return total;
}

static size_t read_cb(char* ptr, size_t sz, size_t n, void* ud) {
    CurlSession* s = (CurlSession*)ud;
    if (!s->upload_fp) return 0;
    return fread(ptr, sz, n, s->upload_fp);
}

/* ── String conversion ───────────────────────────────────────────────────── */
/*
 * D's wstring is always 2-byte UTF-16 regardless of platform.
 * fromUtf16() always reads 2-byte units — correct on both Windows (wchar_t=2)
 * and Linux (wchar_t=4). fromWCharArray() would be wrong on Linux.
 */
static std::string toUtf8(const wchar_t* w, int len) {
    if (!w || len == 0) return "";
    return QString::fromUtf16(reinterpret_cast<const ushort*>(w), len)
               .toUtf8().toStdString();
}

/* ── setopt helpers ──────────────────────────────────────────────────────── */

static void sopt_ptr(CURL* c, int opt, const void* val) {
    if (g.sopt_ptr) g.sopt_ptr(c, opt, val);
}
static void sopt_lng(CURL* c, int opt, long val) {
    if (g.sopt_lng) g.sopt_lng(c, opt, val);
}
static void sopt_ll(CURL* c, int opt, long long val) {
    if (g.sopt_ll) g.sopt_ll(c, opt, val);
}

/* ── Helper: fill function table from loaded library ─────────────────────── */

static bool fill_fn_table() {
#define SYM(field, name) g.field = (decltype(g.field))lib_sym(g.lib, name); if (!g.field) return false;
    SYM(g_init,       "curl_global_init")
    SYM(g_cleanup,    "curl_global_cleanup")
    SYM(easy_init,    "curl_easy_init")
    SYM(easy_cleanup, "curl_easy_cleanup")
    SYM(easy_perform, "curl_easy_perform")
    SYM(easy_reset,   "curl_easy_reset")
    SYM(ginfo_l,      "curl_easy_getinfo")
    SYM(slist_append, "curl_slist_append")
    SYM(slist_free,   "curl_slist_free_all")
    SYM(strerror,     "curl_easy_strerror")
#undef SYM
    /* curl_easy_setopt is variadic — assign same address to all typed wrappers */
    void* setopt = lib_sym(g.lib, "curl_easy_setopt");
    if (!setopt) return false;
    g.sopt_ptr = (fn_sopt_ptr)setopt;
    g.sopt_lng = (fn_sopt_lng)setopt;
    g.sopt_ll  = (fn_sopt_ll) setopt;
    return true;
}

/* ── Session defaults ────────────────────────────────────────────────────── */

static void apply_session_defaults(CurlSession* s) {
    sopt_ptr(s->easy, CURLOPT_WRITEFUNCTION, (const void*)write_cb);
    sopt_ptr(s->easy, CURLOPT_WRITEDATA,     s);
    sopt_ptr(s->easy, CURLOPT_READFUNCTION,  (const void*)read_cb);
    sopt_ptr(s->easy, CURLOPT_READDATA,      s);
    sopt_ptr(s->easy, CURLOPT_ERRORBUFFER,   s->errbuf);
    sopt_lng(s->easy, CURLOPT_SSL_VERIFYPEER, 1L);
    sopt_lng(s->easy, CURLOPT_SSL_VERIFYHOST, 2L);
    sopt_lng(s->easy, CURLOPT_FOLLOWLOCATION, 1L);
    sopt_lng(s->easy, CURLOPT_TIMEOUT,       30L);
}

/* ── API implementation ──────────────────────────────────────────────────── */

void qteCurl_globalInit() {
    if (lib_ok(g.lib)) return;

#ifdef _WIN32
    /* LoadQt("./dll") adds ./dll/ to PATH, so libcurl.dll is found by name */
    g.lib = lib_open("libcurl.dll");
#else
    /* Try versioned name first (most reliable on Linux), then unversioned */
    g.lib = lib_open("libcurl.so.4");
    if (!lib_ok(g.lib)) g.lib = lib_open("libcurl.so");
#endif

    if (!lib_ok(g.lib)) return;
    if (!fill_fn_table()) {
        lib_close(g.lib);
        g.lib = {};
        return;
    }
    g.g_init(CURL_GLOBAL_DEFAULT);
}

void qteCurl_globalCleanup() {
    if (g.g_cleanup) g.g_cleanup();
    if (lib_ok(g.lib)) { lib_close(g.lib); g.lib = {}; }
}

void* qteCurl_create() {
    if (!lib_ok(g.lib)) return nullptr;
    auto* s = new CurlSession{};
    s->easy = g.easy_init();
    if (!s->easy) { delete s; return nullptr; }
    apply_session_defaults(s);
    return s;
}

void qteCurl_destroy(void* h) {
    auto* s = (CurlSession*)h;
    if (!s) return;
    if (s->headers)     g.slist_free(s->headers);
    if (s->upload_fp)   fclose(s->upload_fp);
    if (s->download_fp) fclose(s->download_fp);
    if (s->easy)        g.easy_cleanup(s->easy);
    delete s;
}

void qteCurl_setUrl(void* h, const wchar_t* url, int len) {
    auto* s = (CurlSession*)h;
    s->url = toUtf8(url, len);
    sopt_ptr(s->easy, CURLOPT_URL, s->url.c_str());
}
void qteCurl_setUser(void* h, const wchar_t* u, int l) {
    auto* s = (CurlSession*)h;
    s->user = toUtf8(u, l);
    sopt_ptr(s->easy, CURLOPT_USERNAME, s->user.c_str());
}
void qteCurl_setPassword(void* h, const wchar_t* p, int l) {
    auto* s = (CurlSession*)h;
    s->pass = toUtf8(p, l);
    sopt_ptr(s->easy, CURLOPT_PASSWORD, s->pass.c_str());
}
void qteCurl_setSslVerify(void* h, int verify) {
    auto* s = (CurlSession*)h;
    sopt_lng(s->easy, CURLOPT_SSL_VERIFYPEER, verify ? 1L : 0L);
    sopt_lng(s->easy, CURLOPT_SSL_VERIFYHOST, verify ? 2L : 0L);
}
void qteCurl_setCaInfo(void* h, const wchar_t* path, int len) {
    auto* s = (CurlSession*)h;
    s->cainfo = toUtf8(path, len);
    sopt_ptr(s->easy, CURLOPT_CAINFO, s->cainfo.c_str());
}
void qteCurl_setSshPrivateKey(void* h, const wchar_t* p, int l) {
    auto* s = (CurlSession*)h;
    s->ssh_priv = toUtf8(p, l);
    sopt_ptr(s->easy, CURLOPT_SSH_PRIVATE_KEYFILE, s->ssh_priv.c_str());
}
void qteCurl_setSshPublicKey(void* h, const wchar_t* p, int l) {
    auto* s = (CurlSession*)h;
    s->ssh_pub = toUtf8(p, l);
    sopt_ptr(s->easy, CURLOPT_SSH_PUBLIC_KEYFILE, s->ssh_pub.c_str());
}
void qteCurl_setKnownHosts(void* h, const wchar_t* p, int l) {
    auto* s = (CurlSession*)h;
    s->known_hosts = toUtf8(p, l);
    sopt_ptr(s->easy, CURLOPT_SSH_KNOWNHOSTS, s->known_hosts.c_str());
}
void qteCurl_setTimeout(void* h, int secs) {
    sopt_lng(((CurlSession*)h)->easy, CURLOPT_TIMEOUT, (long)secs);
}
void qteCurl_setFollowRedirects(void* h, int follow) {
    sopt_lng(((CurlSession*)h)->easy, CURLOPT_FOLLOWLOCATION, follow ? 1L : 0L);
}
void qteCurl_setVerbose(void* h, int v) {
    sopt_lng(((CurlSession*)h)->easy, CURLOPT_VERBOSE, v ? 1L : 0L);
}
void qteCurl_setMethod(void* h, const wchar_t* method, int len) {
    auto* s = (CurlSession*)h;
    s->method = toUtf8(method, len);
    if      (s->method == "GET")  { sopt_lng(s->easy, CURLOPT_HTTPGET, 1L); }
    else if (s->method == "POST") { sopt_lng(s->easy, CURLOPT_POST,    1L); }
    else if (s->method == "HEAD") { sopt_lng(s->easy, CURLOPT_NOBODY,  1L); }
    else if (s->method == "PUT")  { sopt_lng(s->easy, CURLOPT_UPLOAD,  1L); }
    else /* DELETE, PATCH, etc.*/ { sopt_ptr(s->easy, CURLOPT_CUSTOMREQUEST, s->method.c_str()); }
}
void qteCurl_setPostBody(void* h, const wchar_t* body, int len) {
    auto* s = (CurlSession*)h;
    s->post_body = toUtf8(body, len);
    sopt_ptr(s->easy, CURLOPT_COPYPOSTFIELDS, s->post_body.c_str());
    sopt_lng(s->easy, CURLOPT_POST, 1L);
}
void qteCurl_addHeader(void* h, const wchar_t* header, int len) {
    auto* s = (CurlSession*)h;
    std::string hdr = toUtf8(header, len);
    s->headers = (curl_slist*)g.slist_append(s->headers, hdr.c_str());
    sopt_ptr(s->easy, CURLOPT_HTTPHEADER, s->headers);
}
void qteCurl_clearHeaders(void* h) {
    auto* s = (CurlSession*)h;
    if (s->headers) { g.slist_free(s->headers); s->headers = nullptr; }
    sopt_ptr(s->easy, CURLOPT_HTTPHEADER, nullptr);
}
void qteCurl_setUploadFile(void* h, const wchar_t* path, int len) {
    ((CurlSession*)h)->upload_path = toUtf8(path, len);
}
void qteCurl_setDownloadFile(void* h, const wchar_t* path, int len) {
    ((CurlSession*)h)->download_path = toUtf8(path, len);
}

int qteCurl_perform(void* h) {
    auto* s = (CurlSession*)h;
    s->body_buf.clear();
    s->transfer_size = 0;
    s->status_code   = 0;
    memset(s->errbuf, 0, sizeof(s->errbuf));

    if (!s->upload_path.empty()) {
        s->upload_fp = fopen(s->upload_path.c_str(), "rb");
        if (!s->upload_fp) {
            s->ret_error = "Cannot open upload file: " + s->upload_path;
            return -1;
        }
        fseek(s->upload_fp, 0, SEEK_END);
        long long fsize = (long long)ftell(s->upload_fp);
        fseek(s->upload_fp, 0, SEEK_SET);
        sopt_lng(s->easy, CURLOPT_UPLOAD, 1L);
        sopt_ll (s->easy, CURLOPT_INFILESIZE_LARGE, fsize);
    }

    if (!s->download_path.empty()) {
        s->download_fp = fopen(s->download_path.c_str(), "wb");
        if (!s->download_fp) {
            s->ret_error = "Cannot open download file: " + s->download_path;
            if (s->upload_fp) { fclose(s->upload_fp); s->upload_fp = nullptr; }
            return -1;
        }
    }

    int rc = g.easy_perform(s->easy);

    if (s->upload_fp)   { fclose(s->upload_fp);   s->upload_fp   = nullptr; }
    if (s->download_fp) { fclose(s->download_fp); s->download_fp = nullptr; }

    long code = 0;
    g.ginfo_l(s->easy, CURLINFO_RESPONSE_CODE, &code);
    s->status_code = code;

    if (rc != 0) {
        s->ret_error = s->errbuf[0]
            ? std::string(s->errbuf)
            : (g.strerror ? std::string(g.strerror(rc))
                          : "curl error " + std::to_string(rc));
    } else {
        s->ret_error.clear();
    }

    return rc;
}

const char* qteCurl_getBody(void* h)        { return ((CurlSession*)h)->body_buf.c_str(); }
int         qteCurl_getStatusCode(void* h)  { return (int)((CurlSession*)h)->status_code; }
const char* qteCurl_getError(void* h)       { return ((CurlSession*)h)->ret_error.c_str(); }
long long   qteCurl_getTransferSize(void* h){ return ((CurlSession*)h)->transfer_size; }

void qteCurl_reset(void* h) {
    auto* s = (CurlSession*)h;
    if (s->headers)     { g.slist_free(s->headers); s->headers = nullptr; }
    if (s->upload_fp)   { fclose(s->upload_fp);   s->upload_fp   = nullptr; }
    if (s->download_fp) { fclose(s->download_fp); s->download_fp = nullptr; }
    if (s->easy)        g.easy_reset(s->easy);
    s->body_buf.clear(); s->transfer_size = 0; s->status_code = 0;
    s->url.clear();  s->user.clear();  s->pass.clear();    s->cainfo.clear();
    s->ssh_priv.clear(); s->ssh_pub.clear(); s->known_hosts.clear();
    s->method.clear(); s->post_body.clear();
    s->upload_path.clear(); s->download_path.clear();
    s->ret_error.clear();
    memset(s->errbuf, 0, sizeof(s->errbuf));
    apply_session_defaults(s);
}
