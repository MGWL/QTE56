#pragma once

#ifdef _WIN32
  #ifdef QTE56_QLINEEDIT_BUILD
    #define QLINEEDIT_API __declspec(dllexport)
  #else
    #define QLINEEDIT_API __declspec(dllimport)
  #endif
#else
  #define QLINEEDIT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QLINEEDIT_API void* qteQLineEdit_create(void* parent);
QLINEEDIT_API void  qteQLineEdit_delete(void* w);
QLINEEDIT_API void* qteQLineEdit_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QLINEEDIT_API void qteQLineEdit_show(void* _obj);
QLINEEDIT_API void qteQLineEdit_hide(void* _obj);
QLINEEDIT_API void qteQLineEdit_update(void* _obj);
QLINEEDIT_API void* qteQLineEdit_text(void* _obj);
QLINEEDIT_API void* qteQLineEdit_displayText(void* _obj);
QLINEEDIT_API void* qteQLineEdit_placeholderText(void* _obj);
QLINEEDIT_API void qteQLineEdit_setPlaceholderText(void* _obj, void* p0);
QLINEEDIT_API int qteQLineEdit_maxLength(void* _obj);
QLINEEDIT_API void qteQLineEdit_setMaxLength(void* _obj, int p0);
QLINEEDIT_API void qteQLineEdit_setFrame(void* _obj, int p0);
QLINEEDIT_API int qteQLineEdit_hasFrame(void* _obj);
QLINEEDIT_API void qteQLineEdit_setClearButtonEnabled(void* _obj, int enable);
QLINEEDIT_API int qteQLineEdit_isClearButtonEnabled(void* _obj);
QLINEEDIT_API int qteQLineEdit_echoMode(void* _obj);
QLINEEDIT_API void qteQLineEdit_setEchoMode(void* _obj, int p0);
QLINEEDIT_API int qteQLineEdit_isReadOnly(void* _obj);
QLINEEDIT_API void qteQLineEdit_setReadOnly(void* _obj, int p0);
QLINEEDIT_API void qteQLineEdit_setValidator(void* _obj, void* p0);
QLINEEDIT_API void* qteQLineEdit_validator(void* _obj);
QLINEEDIT_API void qteQLineEdit_setCompleter(void* _obj, void* completer);
QLINEEDIT_API void* qteQLineEdit_sizeHint(void* _obj);
QLINEEDIT_API void* qteQLineEdit_minimumSizeHint(void* _obj);
QLINEEDIT_API int qteQLineEdit_cursorPosition(void* _obj);
QLINEEDIT_API void qteQLineEdit_setCursorPosition(void* _obj, int p0);
QLINEEDIT_API int qteQLineEdit_cursorPositionAt(void* _obj, void* pos);
QLINEEDIT_API void qteQLineEdit_setAlignment(void* _obj, int flag);
QLINEEDIT_API int qteQLineEdit_alignment(void* _obj);
QLINEEDIT_API void qteQLineEdit_cursorForward(void* _obj, int mark, int steps);
QLINEEDIT_API void qteQLineEdit_cursorBackward(void* _obj, int mark, int steps);
QLINEEDIT_API void qteQLineEdit_cursorWordForward(void* _obj, int mark);
QLINEEDIT_API void qteQLineEdit_cursorWordBackward(void* _obj, int mark);
QLINEEDIT_API void qteQLineEdit_backspace(void* _obj);
QLINEEDIT_API void qteQLineEdit_del(void* _obj);
QLINEEDIT_API void qteQLineEdit_home(void* _obj, int mark);
QLINEEDIT_API void qteQLineEdit_end(void* _obj, int mark);
QLINEEDIT_API int qteQLineEdit_isModified(void* _obj);
QLINEEDIT_API void qteQLineEdit_setModified(void* _obj, int p0);
QLINEEDIT_API void qteQLineEdit_setSelection(void* _obj, int p0, int p1);
QLINEEDIT_API int qteQLineEdit_hasSelectedText(void* _obj);
QLINEEDIT_API void* qteQLineEdit_selectedText(void* _obj);
QLINEEDIT_API int qteQLineEdit_selectionStart(void* _obj);
QLINEEDIT_API int qteQLineEdit_selectionEnd(void* _obj);
QLINEEDIT_API int qteQLineEdit_selectionLength(void* _obj);
QLINEEDIT_API int qteQLineEdit_isUndoAvailable(void* _obj);
QLINEEDIT_API int qteQLineEdit_isRedoAvailable(void* _obj);
QLINEEDIT_API void qteQLineEdit_setDragEnabled(void* _obj, int b);
QLINEEDIT_API int qteQLineEdit_dragEnabled(void* _obj);
QLINEEDIT_API void qteQLineEdit_setCursorMoveStyle(void* _obj, int style);
QLINEEDIT_API int qteQLineEdit_cursorMoveStyle(void* _obj);
QLINEEDIT_API void* qteQLineEdit_inputMask(void* _obj);
QLINEEDIT_API void qteQLineEdit_setInputMask(void* _obj, void* inputMask);
QLINEEDIT_API int qteQLineEdit_hasAcceptableInput(void* _obj);
QLINEEDIT_API void qteQLineEdit_setTextMargins(void* _obj, int left, int top, int right, int bottom);
QLINEEDIT_API void qteQLineEdit_getTextMargins(void* _obj, void* left, void* top, void* right, void* bottom);
QLINEEDIT_API void qteQLineEdit_addAction(void* _obj, void* action, int position);
QLINEEDIT_API void qteQLineEdit_setText(void* _obj, void* p0);
QLINEEDIT_API void qteQLineEdit_clear(void* _obj);
QLINEEDIT_API void qteQLineEdit_selectAll(void* _obj);
QLINEEDIT_API void qteQLineEdit_undo(void* _obj);
QLINEEDIT_API void qteQLineEdit_redo(void* _obj);
QLINEEDIT_API void qteQLineEdit_cut(void* _obj);
QLINEEDIT_API void qteQLineEdit_copy(void* _obj);
QLINEEDIT_API void qteQLineEdit_paste(void* _obj);
QLINEEDIT_API void qteQLineEdit_deselect(void* _obj);
QLINEEDIT_API void qteQLineEdit_insert(void* _obj, void* p0);
QLINEEDIT_API int qteQLineEdit_event(void* _obj, void* p0);

// ── Event handler ────────────────────────────────────────────────────────────
QLINEEDIT_API void qteQLineEdit_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
