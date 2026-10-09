#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTCURSOR_BUILD
    #define QTEXTCURSOR_API __declspec(dllexport)
  #else
    #define QTEXTCURSOR_API __declspec(dllimport)
  #endif
#else
  #define QTEXTCURSOR_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTCURSOR_API void* qteQTextCursor_create(void* document);
QTEXTCURSOR_API void  qteQTextCursor_delete(void* c);
QTEXTCURSOR_API void* qteQTextCursor_copy(void* c);

// ── Position ─────────────────────────────────────────────────────────────
QTEXTCURSOR_API int  qteQTextCursor_position(void* c);
QTEXTCURSOR_API void qteQTextCursor_setPosition(void* c, int pos, int mode);
QTEXTCURSOR_API int  qteQTextCursor_movePosition(void* c, int op, int mode, int n);
QTEXTCURSOR_API int  qteQTextCursor_anchor(void* c);

// ── Selection ────────────────────────────────────────────────────────────
QTEXTCURSOR_API int   qteQTextCursor_hasSelection(void* c);
QTEXTCURSOR_API void* qteQTextCursor_selectedText(void* c);
QTEXTCURSOR_API void  qteQTextCursor_removeSelectedText(void* c);
QTEXTCURSOR_API void  qteQTextCursor_select(void* c, int selection);
QTEXTCURSOR_API int   qteQTextCursor_selectionStart(void* c);
QTEXTCURSOR_API int   qteQTextCursor_selectionEnd(void* c);
QTEXTCURSOR_API void  qteQTextCursor_clearSelection(void* c);

// ── Insert ───────────────────────────────────────────────────────────────
QTEXTCURSOR_API void  qteQTextCursor_insertText(void* c, void* text);
QTEXTCURSOR_API void  qteQTextCursor_insertHtml(void* c, void* html);
QTEXTCURSOR_API void  qteQTextCursor_insertBlock(void* c);

// ── At-position queries ──────────────────────────────────────────────────
QTEXTCURSOR_API int   qteQTextCursor_atStart(void* c);
QTEXTCURSOR_API int   qteQTextCursor_atEnd(void* c);
QTEXTCURSOR_API int   qteQTextCursor_atBlockStart(void* c);
QTEXTCURSOR_API int   qteQTextCursor_atBlockEnd(void* c);

// ── Block info ───────────────────────────────────────────────────────────
QTEXTCURSOR_API int   qteQTextCursor_blockNumber(void* c);
QTEXTCURSOR_API int   qteQTextCursor_columnNumber(void* c);
QTEXTCURSOR_API int   qteQTextCursor_positionInBlock(void* c);

// ── Formatting ───────────────────────────────────────────────────────────
QTEXTCURSOR_API void* qteQTextCursor_charFormat(void* c);
QTEXTCURSOR_API void  qteQTextCursor_setCharFormat(void* c, void* fmt);
QTEXTCURSOR_API void  qteQTextCursor_mergeCharFormat(void* c, void* fmt);
QTEXTCURSOR_API void* qteQTextCursor_blockFormat(void* c);
QTEXTCURSOR_API void  qteQTextCursor_setBlockFormat(void* c, void* fmt);
QTEXTCURSOR_API void  qteQTextCursor_mergeBlockFormat(void* c, void* fmt);

// ── Block ────────────────────────────────────────────────────────────────
QTEXTCURSOR_API void* qteQTextCursor_block(void* c);

// ── Edit blocks ──────────────────────────────────────────────────────────
QTEXTCURSOR_API void  qteQTextCursor_beginEditBlock(void* c);
QTEXTCURSOR_API void  qteQTextCursor_endEditBlock(void* c);

// ── Misc ─────────────────────────────────────────────────────────────────
QTEXTCURSOR_API int   qteQTextCursor_isNull(void* c);
QTEXTCURSOR_API void  qteQTextCursor_insertText_fmt(void* c, void* text, void* fmt);
QTEXTCURSOR_API void  qteQTextCursor_insertBlock_fmt(void* c, void* blockFmt);

} // extern "C"
