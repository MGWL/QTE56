#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTBLOCK_BUILD
    #define QTEXTBLOCK_API __declspec(dllexport)
  #else
    #define QTEXTBLOCK_API __declspec(dllimport)
  #endif
#else
  #define QTEXTBLOCK_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTBLOCK_API void* qteQTextBlock_copy(void* block);
QTEXTBLOCK_API void  qteQTextBlock_delete(void* block);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTBLOCK_API void*  qteQTextBlock_text(void* block);
QTEXTBLOCK_API int    qteQTextBlock_length(void* block);
QTEXTBLOCK_API int    qteQTextBlock_blockNumber(void* block);
QTEXTBLOCK_API int    qteQTextBlock_position(void* block);
QTEXTBLOCK_API int    qteQTextBlock_isValid(void* block);
QTEXTBLOCK_API int    qteQTextBlock_isVisible(void* block);
QTEXTBLOCK_API int    qteQTextBlock_revision(void* block);
QTEXTBLOCK_API void*  qteQTextBlock_next(void* block);
QTEXTBLOCK_API void*  qteQTextBlock_previous(void* block);
QTEXTBLOCK_API void*  qteQTextBlock_charFormat(void* block);
QTEXTBLOCK_API void*  qteQTextBlock_blockFormat(void* block);
QTEXTBLOCK_API int    qteQTextBlock_lineCount(void* block);
QTEXTBLOCK_API int    qteQTextBlock_firstLineNumber(void* block);

} // extern "C"
