#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTBROWSER_BUILD
    #define QTEXTBROWSER_API __declspec(dllexport)
  #else
    #define QTEXTBROWSER_API __declspec(dllimport)
  #endif
#else
  #define QTEXTBROWSER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTBROWSER_API void* qteQTextBrowser_create(void* parent);
QTEXTBROWSER_API void  qteQTextBrowser_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTBROWSER_API int qteQTextBrowser_isBackwardAvailable(void* _obj);
QTEXTBROWSER_API int qteQTextBrowser_isForwardAvailable(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_clearHistory(void* _obj);
QTEXTBROWSER_API void* qteQTextBrowser_historyTitle(void* _obj, int p0);
QTEXTBROWSER_API int qteQTextBrowser_backwardHistoryCount(void* _obj);
QTEXTBROWSER_API int qteQTextBrowser_forwardHistoryCount(void* _obj);
QTEXTBROWSER_API int qteQTextBrowser_openExternalLinks(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_setOpenExternalLinks(void* _obj, int open);
QTEXTBROWSER_API int qteQTextBrowser_openLinks(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_setOpenLinks(void* _obj, int open);
QTEXTBROWSER_API void qteQTextBrowser_backward(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_forward(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_home(void* _obj);
QTEXTBROWSER_API void qteQTextBrowser_reload(void* _obj);

// ── QUrl methods (manual, generator skips QUrl) ──────────────────────────────
QTEXTBROWSER_API void  qteQTextBrowser_setSource(void* _obj, void* url);
QTEXTBROWSER_API void* qteQTextBrowser_source(void* _obj);
QTEXTBROWSER_API void* qteQTextBrowser_historyUrl(void* _obj, int i);
QTEXTBROWSER_API void  qteQTextBrowser_connect_sourceChanged(void* w, void* cb, void* dthis);
QTEXTBROWSER_API void  qteQTextBrowser_connect_anchorClicked(void* w, void* cb, void* dthis);

// ── Event handler ────────────────────────────────────────────────────────────
QTEXTBROWSER_API void qteQTextBrowser_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
