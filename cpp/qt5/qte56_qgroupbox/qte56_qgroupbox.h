#pragma once

#ifdef _WIN32
  #ifdef QTE56_QGROUPBOX_BUILD
    #define QGROUPBOX_API __declspec(dllexport)
  #else
    #define QGROUPBOX_API __declspec(dllimport)
  #endif
#else
  #define QGROUPBOX_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QGROUPBOX_API void* qteQGroupBox_create(void* parent);
QGROUPBOX_API void  qteQGroupBox_delete(void* w);
QGROUPBOX_API void* qteQGroupBox_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QGROUPBOX_API void qteQGroupBox_show(void* _obj);
QGROUPBOX_API void qteQGroupBox_hide(void* _obj);
QGROUPBOX_API void qteQGroupBox_update(void* _obj);
QGROUPBOX_API void* qteQGroupBox_title(void* _obj);
QGROUPBOX_API void qteQGroupBox_setTitle(void* _obj, void* title);
QGROUPBOX_API int qteQGroupBox_alignment(void* _obj);
QGROUPBOX_API void qteQGroupBox_setAlignment(void* _obj, int alignment);
QGROUPBOX_API void* qteQGroupBox_minimumSizeHint(void* _obj);
QGROUPBOX_API int qteQGroupBox_isFlat(void* _obj);
QGROUPBOX_API void qteQGroupBox_setFlat(void* _obj, int flat);
QGROUPBOX_API int qteQGroupBox_isCheckable(void* _obj);
QGROUPBOX_API void qteQGroupBox_setCheckable(void* _obj, int checkable);
QGROUPBOX_API int qteQGroupBox_isChecked(void* _obj);
QGROUPBOX_API void qteQGroupBox_setChecked(void* _obj, int checked);

// ── Event handler ────────────────────────────────────────────────────────────
QGROUPBOX_API void qteQGroupBox_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
