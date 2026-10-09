#pragma once
#ifdef _WIN32
#  ifdef QTE56_QSETTINGS_BUILD
#    define QSETTINGS_API __declspec(dllexport)
#  else
#    define QSETTINGS_API __declspec(dllimport)
#  endif
#else
#  define QSETTINGS_API __attribute__((visibility("default")))
#endif
extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────────
// create_app: QSettings(organization, application, parent)
QSETTINGS_API void* qteQSettings_create_app(void* org,
                                             void* app,
                                             void* parent);
// create_file: QSettings(filename, format=IniFormat, parent)
// format: 0=NativeFormat, 1=IniFormat, 2=InvalidFormat
QSETTINGS_API void* qteQSettings_create_file(void* fname,
                                              int format, void* parent);
QSETTINGS_API void  qteQSettings_delete(void* s);

// ── Read/Write values ─────────────────────────────────────────────────────────
// setValue stores any QVariant — these helpers work with string/int/bool/double
QSETTINGS_API void  qteQSettings_setValue_s(void* s, void* key,
                                             void* val);
QSETTINGS_API void* qteQSettings_value_s(void* s, void* key,
                                          void* defval);
QSETTINGS_API void  qteQSettings_setValue_i(void* s, void* key, int val);
QSETTINGS_API int   qteQSettings_value_i(void* s, void* key, int defval);
QSETTINGS_API void  qteQSettings_setValue_b(void* s, void* key, int val);
QSETTINGS_API int   qteQSettings_value_b(void* s, void* key, int defval);
QSETTINGS_API void  qteQSettings_setValue_d(void* s, void* key, double val);
QSETTINGS_API double qteQSettings_value_d(void* s, void* key, double defval);

// ── Key management ────────────────────────────────────────────────────────────
QSETTINGS_API int   qteQSettings_contains(void* s, void* key);
QSETTINGS_API void  qteQSettings_remove(void* s, void* key);
QSETTINGS_API void  qteQSettings_clear(void* s);
QSETTINGS_API void  qteQSettings_sync(void* s);

// ── Groups ────────────────────────────────────────────────────────────────────
QSETTINGS_API void  qteQSettings_beginGroup(void* s, void* prefix);
QSETTINGS_API void  qteQSettings_endGroup(void* s);
QSETTINGS_API void* qteQSettings_group(void* s);

// ── Status ────────────────────────────────────────────────────────────────────
// status: 0=NoError, 1=AccessError, 2=FormatError
QSETTINGS_API int   qteQSettings_status(void* s);
QSETTINGS_API int   qteQSettings_isWritable(void* s);
QSETTINGS_API void* qteQSettings_fileName(void* s);

// ── Binary values (QByteArray*) ───────────────────────────────────────────────
QSETTINGS_API void  qteQSettings_setValue_ba(void* s, void* key, const void* data, int len); // 7221
QSETTINGS_API void* qteQSettings_value_ba(void* s, void* key);                               // 7222 → new QByteArray* or nullptr

} // extern "C"
