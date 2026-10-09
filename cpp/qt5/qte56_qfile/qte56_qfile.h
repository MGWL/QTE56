#pragma once
#ifdef _WIN32
#  ifdef QTE56_QFILE_BUILD
#    define QFILE_API __declspec(dllexport)
#  else
#    define QFILE_API __declspec(dllimport)
#  endif
#else
#  define QFILE_API __attribute__((visibility("default")))
#endif
extern "C" {

// ── Lifecycle ─────────────────────────────────────────────────────────────────
QFILE_API void* qteQFile_create();
QFILE_API void* qteQFile_create_path(void* path);
QFILE_API void  qteQFile_delete(void* f);

// ── Open / Close ──────────────────────────────────────────────────────────────
QFILE_API int   qteQFile_open(void* f, int mode);
QFILE_API void  qteQFile_close(void* f);
QFILE_API int   qteQFile_isOpen(void* f);

// ── File name ─────────────────────────────────────────────────────────────────
QFILE_API void* qteQFile_fileName(void* f);
QFILE_API void  qteQFile_setFileName(void* f, void* path);

// ── Existence ─────────────────────────────────────────────────────────────────
QFILE_API int   qteQFile_exists(void* f);
QFILE_API int   qteQFile_exists_static(void* path);

// ── Size / Position ───────────────────────────────────────────────────────────
QFILE_API int   qteQFile_size(void* f);
QFILE_API int   qteQFile_pos(void* f);
QFILE_API int   qteQFile_seek(void* f, int pos);
QFILE_API int   qteQFile_atEnd(void* f);

// ── Read / Write ──────────────────────────────────────────────────────────────
QFILE_API void* qteQFile_readAll(void* f, int* outLen);
QFILE_API void  qteQFile_freeBuffer(void* buf);
QFILE_API int   qteQFile_write(void* f, const void* data, int len);
QFILE_API int   qteQFile_flush(void* f);

// ── File operations ───────────────────────────────────────────────────────────
QFILE_API int   qteQFile_remove(void* f);
QFILE_API int   qteQFile_remove_static(void* path);
QFILE_API int   qteQFile_rename(void* f, void* newName);
QFILE_API int   qteQFile_copy(void* f, void* newName);
QFILE_API int   qteQFile_copy_static(void* src,
                                      void* dst);

// ── Error ─────────────────────────────────────────────────────────────────────
QFILE_API int   qteQFile_error(void* f);
QFILE_API void* qteQFile_errorString(void* f);

// ── Permissions / Resize ──────────────────────────────────────────────────────
QFILE_API int   qteQFile_permissions(void* f);
QFILE_API int   qteQFile_setPermissions(void* f, int perms);
QFILE_API int   qteQFile_resize(void* f, int sz);

// ── Text convenience ──────────────────────────────────────────────────────────
QFILE_API void* qteQFile_readAll_text(void* f);

} // extern "C"
