#ifndef QTE56_QCLIPBOARD_H
#define QTE56_QCLIPBOARD_H

#ifdef _WIN32
#  define CLIPBOARD_API __declspec(dllexport)
#else
#  define CLIPBOARD_API
#endif

extern "C" {

// Returns QApplication::clipboard() — singleton, no destruction
CLIPBOARD_API void* qteQClipboard_get();

// text(mode) → new QString* (caller must free with qteQString_free or fromQString helper)
CLIPBOARD_API void* qteQClipboard_text(void* cb, int mode);

// setText(const char* utf8, mode)
CLIPBOARD_API void  qteQClipboard_setText(void* cb, const char* s, int mode);

// clear(mode)
CLIPBOARD_API void  qteQClipboard_clear(void* cb, int mode);

// queries
CLIPBOARD_API int   qteQClipboard_supportsSelection(void* cb);
CLIPBOARD_API int   qteQClipboard_ownsClipboard(void* cb);
CLIPBOARD_API int   qteQClipboard_ownsSelection(void* cb);

// signals
// dataChanged: extern(C) void cb(void* dthis)
CLIPBOARD_API void  qteQClipboard_connect_dataChanged(void* cb, void* callback, void* dthis);
// changed(mode): extern(C) void cb(void* dthis, int mode)
CLIPBOARD_API void  qteQClipboard_connect_changed(void* cb, void* callback, void* dthis);

} // extern "C"

#endif // QTE56_QCLIPBOARD_H
