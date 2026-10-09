#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDIALOG_BUILD
    #define QDIALOG_API __declspec(dllexport)
  #else
    #define QDIALOG_API __declspec(dllimport)
  #endif
#else
  #define QDIALOG_API __attribute__((visibility("default")))
#endif

extern "C" {

QDIALOG_API void* qteQDialog_create(void* parent, int flags);
QDIALOG_API void  qteQDialog_delete(void* _obj);
QDIALOG_API int   qteQDialog_exec(void* _obj);
QDIALOG_API void  qteQDialog_accept(void* _obj);
QDIALOG_API void  qteQDialog_reject(void* _obj);
QDIALOG_API void  qteQDialog_done(void* _obj, int result);
QDIALOG_API int   qteQDialog_result(void* _obj);
QDIALOG_API void  qteQDialog_setModal(void* _obj, int modal);
QDIALOG_API int   qteQDialog_isModal(void* _obj);
QDIALOG_API void  qteQDialog_open(void* _obj);
QDIALOG_API void  qteQDialog_setSizeGripEnabled(void* _obj, int enabled);
QDIALOG_API int   qteQDialog_isSizeGripEnabled(void* _obj);
QDIALOG_API void  qteQDialog_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
