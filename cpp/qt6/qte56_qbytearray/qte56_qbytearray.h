#pragma once

#ifdef _WIN32
  #ifdef QTE56_QBYTEARRAY_BUILD
    #define QBYTEARRAY_API __declspec(dllexport)
  #else
    #define QBYTEARRAY_API __declspec(dllimport)
  #endif
#else
  #define QBYTEARRAY_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ───────────────────────────────────────────────────────────────
QBYTEARRAY_API void* qteQByteArray_create();                               // 19969
QBYTEARRAY_API void* qteQByteArray_fromPtr(const void* data, int len);     // 19970
QBYTEARRAY_API void  qteQByteArray_delete(void* ba);                       // 19971
QBYTEARRAY_API void* qteQByteArray_copy(void* ba);                         // 19972

// ── Size / access ───────────────────────────────────────────────────────────
QBYTEARRAY_API int         qteQByteArray_size(void* ba);                   // 19973
QBYTEARRAY_API int         qteQByteArray_isEmpty(void* ba);                // 19974
QBYTEARRAY_API const void* qteQByteArray_constData(void* ba);              // 19975
QBYTEARRAY_API int         qteQByteArray_at(void* ba, int i);              // 19976
QBYTEARRAY_API void        qteQByteArray_set(void* ba, int i, int byte);   // 19977

// ── Mutation ────────────────────────────────────────────────────────────────
QBYTEARRAY_API void qteQByteArray_append (void* ba, const void* data, int len); // 19978
QBYTEARRAY_API void qteQByteArray_prepend(void* ba, const void* data, int len); // 19979
QBYTEARRAY_API void qteQByteArray_resize (void* ba, int size);             // 19980
QBYTEARRAY_API void qteQByteArray_clear  (void* ba);                       // 19981
QBYTEARRAY_API void qteQByteArray_chop   (void* ba, int n);                // 19982

// ── Slicing / transform (return new heap-allocated QByteArray*) ─────────────
QBYTEARRAY_API void* qteQByteArray_mid     (void* ba, int pos, int len);   // 19983  len=-1→to end
QBYTEARRAY_API void* qteQByteArray_left    (void* ba, int n);              // 19984
QBYTEARRAY_API void* qteQByteArray_right   (void* ba, int n);              // 19985
QBYTEARRAY_API void* qteQByteArray_toUpper (void* ba);                     // 19986
QBYTEARRAY_API void* qteQByteArray_toLower (void* ba);                     // 19987
QBYTEARRAY_API void* qteQByteArray_trimmed (void* ba);                     // 19988

// ── Search ──────────────────────────────────────────────────────────────────
QBYTEARRAY_API int qteQByteArray_indexOf    (void* ba, const void* data, int len, int from); // 19989
QBYTEARRAY_API int qteQByteArray_contains   (void* ba, const void* data, int len);           // 19990
QBYTEARRAY_API int qteQByteArray_startsWith (void* ba, const void* data, int len);           // 19991
QBYTEARRAY_API int qteQByteArray_endsWith   (void* ba, const void* data, int len);           // 19992

// ── Encoding ────────────────────────────────────────────────────────────────
QBYTEARRAY_API void* qteQByteArray_toHex      (void* ba);                  // 19993
QBYTEARRAY_API void* qteQByteArray_toBase64   (void* ba);                  // 19994
QBYTEARRAY_API void* qteQByteArray_fromBase64 (void* ba);                  // 19995  static: ba = QByteArray*(base64 text)

// ── QString interop ─────────────────────────────────────────────────────────
QBYTEARRAY_API void* qteQByteArray_toQString  (void* ba);                  // 19996  UTF-8 → new QString*
QBYTEARRAY_API void* qteQByteArray_fromQString(void* qs);                  // 19997  QString → new QByteArray* (UTF-8)

// ── Comparison ──────────────────────────────────────────────────────────────
QBYTEARRAY_API int qteQByteArray_equal(void* a, void* b);                  // 19998

} // extern "C"
