#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPLAINTEXTEDIT_BUILD
    #define QPLAINTEXTEDIT_API __declspec(dllexport)
  #else
    #define QPLAINTEXTEDIT_API __declspec(dllimport)
  #endif
#else
  #define QPLAINTEXTEDIT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_create(void* parent);
QPLAINTEXTEDIT_API void  qteQPlainTextEdit_delete(void* w);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setDocument(void* _obj, void* document);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_document(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setPlaceholderText(void* _obj, void* placeholderText);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_placeholderText(void* _obj);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_isReadOnly(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setReadOnly(void* _obj, int ro);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setTextInteractionFlags(void* _obj, int flags);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_textInteractionFlags(void* _obj);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_tabChangesFocus(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setTabChangesFocus(void* _obj, int b);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_lineWrapMode(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setLineWrapMode(void* _obj, int mode);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_wordWrapMode(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setWordWrapMode(void* _obj, int policy);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setBackgroundVisible(void* _obj, int visible);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_backgroundVisible(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setCenterOnScroll(void* _obj, int enabled);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_centerOnScroll(void* _obj);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_find(void* _obj, void* exp, int options);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_ensureCursorVisible(void* _obj);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_createStandardContextMenu_v(void* _obj);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_createStandardContextMenu_p(void* _obj, void* position);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_cursorRect(void* _obj);
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_anchorAt(void* _obj, void* pos);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_overwriteMode(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setOverwriteMode(void* _obj, int overwrite);
QPLAINTEXTEDIT_API double qteQPlainTextEdit_tabStopDistance(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setTabStopDistance(void* _obj, double distance);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_cursorWidth(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setCursorWidth(void* _obj, int width);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_moveCursor(void* _obj, int operation, int mode);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_canPaste(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_print(void* _obj, void* printer);
QPLAINTEXTEDIT_API int qteQPlainTextEdit_blockCount(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setPlainText(void* _obj, void* text);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_cut(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_copy(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_paste(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_undo(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_redo(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_clear(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_selectAll(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_insertPlainText(void* _obj, void* text);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_appendPlainText(void* _obj, void* text);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_appendHtml(void* _obj, void* html);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_centerCursor(void* _obj);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_zoomIn(void* _obj, int range);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_zoomOut(void* _obj, int range);

// ── TextCursor ───────────────────────────────────────────────────────────────
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_textCursor(void* _obj);
QPLAINTEXTEDIT_API void  qteQPlainTextEdit_setTextCursor(void* _obj, void* cursor);

// ── Protected viewport / scroll API (открыто через subclass eQPlainTextEdit) ─
// setViewportMargins(l,t,r,b) — резервирует область внутри scroll-area рядом
//   с viewport. Используется для line-number area (классический паттерн).
// getViewportMargins выдаёт текущие отступы через 4 out-параметра.
// scrollContentsBy(dx,dy) — программно прокрутить содержимое.
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setViewportMargins(
    void* _obj, int left, int top, int right, int bottom);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_getViewportMargins(
    void* _obj, int* left, int* top, int* right, int* bottom);
QPLAINTEXTEDIT_API void qteQPlainTextEdit_scrollContentsBy(
    void* _obj, int dx, int dy);

// ── Public API для line-number area ──────────────────────────────────────────
// firstVisibleBlock — указатель на первый видимый QTextBlock (heap copy).
// blockBoundingGeometry — y и height блока (в координатах viewport),
//   нужен blockNumber вместо QTextBlock-указателя для удобства.
// contentOffset — смещение содержимого относительно viewport (для скролла).
// connect_updateRequest — сигнал когда нужно перерисовать viewport.
QPLAINTEXTEDIT_API void* qteQPlainTextEdit_firstVisibleBlock(void* _obj);
QPLAINTEXTEDIT_API void  qteQPlainTextEdit_blockBoundingGeometry(
    void* _obj, int blockNumber, int* y, int* height);
QPLAINTEXTEDIT_API void  qteQPlainTextEdit_contentOffset(
    void* _obj, int* x, int* y);
QPLAINTEXTEDIT_API void  qteQPlainTextEdit_connect_updateRequest(
    void* _obj, void* eslot);

// ── Event handler ────────────────────────────────────────────────────────────
QPLAINTEXTEDIT_API void qteQPlainTextEdit_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
