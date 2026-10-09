#ifndef QTE56_QBUTTONGROUP_H
#define QTE56_QBUTTONGROUP_H

#ifdef _WIN32
#  define BTNGROUP_API __declspec(dllexport)
#else
#  define BTNGROUP_API
#endif

extern "C" {

// lifecycle
BTNGROUP_API void* qteQButtonGroup_create(void* parent);
BTNGROUP_API void  qteQButtonGroup_destroy(void* obj);

// exclusive
BTNGROUP_API void  qteQButtonGroup_setExclusive(void* obj, int v);
BTNGROUP_API int   qteQButtonGroup_exclusive(void* obj);

// buttons
// addButton(btn_ptr, id=-1): pass id=-1 for auto-assign
BTNGROUP_API void  qteQButtonGroup_addButton(void* obj, void* btn, int id);
BTNGROUP_API void  qteQButtonGroup_removeButton(void* obj, void* btn);
BTNGROUP_API void  qteQButtonGroup_setId(void* obj, void* btn, int id);
BTNGROUP_API int   qteQButtonGroup_id(void* obj, void* btn);
BTNGROUP_API int   qteQButtonGroup_checkedId(void* obj);

// signals
// buttonClicked(int id): extern(C) void cb(void* dthis, int id)
BTNGROUP_API void  qteQButtonGroup_connect_buttonClicked(void* obj, void* cb, void* dthis);
// buttonToggled(int id, bool checked): extern(C) void cb(void* dthis, int id, int checked)
BTNGROUP_API void  qteQButtonGroup_connect_buttonToggled(void* obj, void* cb, void* dthis);
// ── List queries ─────────────────────────────────────────────────────────────
BTNGROUP_API void* qteQButtonGroup_buttons(void* _obj);

} // extern "C"

#endif // QTE56_QBUTTONGROUP_H
