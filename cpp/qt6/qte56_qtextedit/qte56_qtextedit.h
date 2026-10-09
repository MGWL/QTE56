#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTEDIT_BUILD
    #define QTEXTEDIT_API __declspec(dllexport)
  #else
    #define QTEXTEDIT_API __declspec(dllimport)
  #endif
#else
  #define QTEXTEDIT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTEDIT_API void* qteQTextEdit_create(void* parent);
QTEXTEDIT_API void  qteQTextEdit_delete(void* w);
QTEXTEDIT_API void* qteQTextEdit_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTEDIT_API void qteQTextEdit_setDocument(void* _obj, void* document);
QTEXTEDIT_API void* qteQTextEdit_document(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setPlaceholderText(void* _obj, void* placeholderText);
QTEXTEDIT_API void* qteQTextEdit_placeholderText(void* _obj);
QTEXTEDIT_API int qteQTextEdit_isReadOnly(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setReadOnly(void* _obj, int ro);
QTEXTEDIT_API void qteQTextEdit_setTextInteractionFlags(void* _obj, int flags);
QTEXTEDIT_API int qteQTextEdit_textInteractionFlags(void* _obj);
QTEXTEDIT_API double qteQTextEdit_fontPointSize(void* _obj);
QTEXTEDIT_API void* qteQTextEdit_fontFamily(void* _obj);
QTEXTEDIT_API int qteQTextEdit_fontWeight(void* _obj);
QTEXTEDIT_API int qteQTextEdit_fontUnderline(void* _obj);
QTEXTEDIT_API int qteQTextEdit_fontItalic(void* _obj);
QTEXTEDIT_API int qteQTextEdit_alignment(void* _obj);
QTEXTEDIT_API int qteQTextEdit_autoFormatting(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setAutoFormatting(void* _obj, int features);
QTEXTEDIT_API int qteQTextEdit_tabChangesFocus(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setTabChangesFocus(void* _obj, int b);
QTEXTEDIT_API int qteQTextEdit_lineWrapMode(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setLineWrapMode(void* _obj, int mode);
QTEXTEDIT_API int qteQTextEdit_lineWrapColumnOrWidth(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setLineWrapColumnOrWidth(void* _obj, int w);
QTEXTEDIT_API int qteQTextEdit_wordWrapMode(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setWordWrapMode(void* _obj, int policy);
QTEXTEDIT_API int qteQTextEdit_find(void* _obj, void* exp, int options);
QTEXTEDIT_API void* qteQTextEdit_toPlainText(void* _obj);
QTEXTEDIT_API void* qteQTextEdit_toHtml(void* _obj);
QTEXTEDIT_API void qteQTextEdit_ensureCursorVisible(void* _obj);
QTEXTEDIT_API void* qteQTextEdit_createStandardContextMenu_v(void* _obj);
QTEXTEDIT_API void* qteQTextEdit_createStandardContextMenu_p(void* _obj, void* position);
QTEXTEDIT_API void* qteQTextEdit_cursorRect(void* _obj);
QTEXTEDIT_API void* qteQTextEdit_anchorAt(void* _obj, void* pos);
QTEXTEDIT_API int qteQTextEdit_overwriteMode(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setOverwriteMode(void* _obj, int overwrite);
QTEXTEDIT_API double qteQTextEdit_tabStopDistance(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setTabStopDistance(void* _obj, double distance);
QTEXTEDIT_API int qteQTextEdit_cursorWidth(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setCursorWidth(void* _obj, int width);
QTEXTEDIT_API int qteQTextEdit_acceptRichText(void* _obj);
QTEXTEDIT_API void qteQTextEdit_setAcceptRichText(void* _obj, int accept);
QTEXTEDIT_API void qteQTextEdit_moveCursor(void* _obj, int operation, int mode);
QTEXTEDIT_API int qteQTextEdit_canPaste(void* _obj);
QTEXTEDIT_API void qteQTextEdit_print(void* _obj, void* printer);
QTEXTEDIT_API void qteQTextEdit_setFontPointSize(void* _obj, double s);
QTEXTEDIT_API void qteQTextEdit_setFontFamily(void* _obj, void* fontFamily);
QTEXTEDIT_API void qteQTextEdit_setFontWeight(void* _obj, int w);
QTEXTEDIT_API void qteQTextEdit_setFontUnderline(void* _obj, int b);
QTEXTEDIT_API void qteQTextEdit_setFontItalic(void* _obj, int b);
QTEXTEDIT_API void qteQTextEdit_setAlignment(void* _obj, int a);
QTEXTEDIT_API void qteQTextEdit_setPlainText(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_setHtml(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_setText(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_cut(void* _obj);
QTEXTEDIT_API void qteQTextEdit_copy(void* _obj);
QTEXTEDIT_API void qteQTextEdit_paste(void* _obj);
QTEXTEDIT_API void qteQTextEdit_undo(void* _obj);
QTEXTEDIT_API void qteQTextEdit_redo(void* _obj);
QTEXTEDIT_API void qteQTextEdit_clear(void* _obj);
QTEXTEDIT_API void qteQTextEdit_selectAll(void* _obj);
QTEXTEDIT_API void qteQTextEdit_insertPlainText(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_insertHtml(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_append(void* _obj, void* text);
QTEXTEDIT_API void qteQTextEdit_scrollToAnchor(void* _obj, void* name);
QTEXTEDIT_API void qteQTextEdit_zoomIn(void* _obj, int range);
QTEXTEDIT_API void qteQTextEdit_zoomOut(void* _obj, int range);

// ── TextCursor ───────────────────────────────────────────────────────────────
QTEXTEDIT_API void* qteQTextEdit_textCursor(void* _obj);
QTEXTEDIT_API void  qteQTextEdit_setTextCursor(void* _obj, void* cursor);

// ── Event handler ────────────────────────────────────────────────────────────
QTEXTEDIT_API void qteQTextEdit_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
