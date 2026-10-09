#ifndef QTE56_UILOADER_H
#define QTE56_UILOADER_H

#ifdef _WIN32
#  ifdef QTE56_UILOADER_BUILD
#    define QTE56_UILOADER_API __declspec(dllexport)
#  else
#    define QTE56_UILOADER_API __declspec(dllimport)
#  endif
#else
#  define QTE56_UILOADER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QUiLoader: 19812–19815 ────────────────────────────────────────────────────

/// Create a QUiLoader instance.
QTE56_UILOADER_API void* qteQUiLoader_create();

/// Delete a QUiLoader instance.
QTE56_UILOADER_API void  qteQUiLoader_delete(void* loader);

/// Load a .ui file and return the root QWidget*.
/// parent  — parent widget pointer (null for top-level).
/// Returns null on error (file not found, parse error, etc.).
QTE56_UILOADER_API void* qteQUiLoader_load(
    void* loader,
    void* path,
    void* parent);

/// Find a child widget by objectName (set in Qt Designer's Property Editor).
/// Searches the entire subtree of parent recursively.
/// Returns null if not found.
QTE56_UILOADER_API void* qteQWidget_findChild(
    void* parent,
    void* name);

// ── QAction lookup: 20156 ─────────────────────────────────────────────────────

/// Find a child QAction by objectName.
/// QAction inherits QObject (not QWidget), so qteQWidget_findChild won't find it —
/// this function uses findChild<QAction*>(name) explicitly.
/// Searches the entire subtree of parent recursively. Returns nullptr if not found.
QTE56_UILOADER_API void* qteQObject_findChildAction(
    void* parent,
    void* name);

} // extern "C"

#endif // QTE56_UILOADER_H
