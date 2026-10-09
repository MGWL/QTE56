#ifndef QTE56_RESOURCE_H
#define QTE56_RESOURCE_H

#ifdef _WIN32
#  ifdef QTE56_RESOURCE_BUILD
#    define QTE56_RESOURCE_API __declspec(dllexport)
#  else
#    define QTE56_RESOURCE_API __declspec(dllimport)
#  endif
#else
#  define QTE56_RESOURCE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QResource: 19810–19811 ────────────────────────────────────────────────────

/// Register external .rcc binary. mapRoot — prefix in resource tree (default "/").
/// Returns 1 on success, 0 on failure.
QTE56_RESOURCE_API int qteQResource_registerResource(
    void* path,
    void* mapRoot);

/// Unregister previously registered .rcc binary.
/// Returns 1 on success, 0 on failure.
QTE56_RESOURCE_API int qteQResource_unregisterResource(
    void* path,
    void* mapRoot);

} // extern "C"

#endif // QTE56_RESOURCE_H
