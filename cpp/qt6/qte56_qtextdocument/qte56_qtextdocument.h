#pragma once

#ifdef _WIN32
  #ifdef QTE56_QTEXTDOCUMENT_BUILD
    #define QTEXTDOCUMENT_API __declspec(dllexport)
  #else
    #define QTEXTDOCUMENT_API __declspec(dllimport)
  #endif
#else
  #define QTEXTDOCUMENT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QTEXTDOCUMENT_API void* qteQTextDocument_create(void* parent);
QTEXTDOCUMENT_API void  qteQTextDocument_delete(void* w);
QTEXTDOCUMENT_API void* qteQTextDocument_create_text(void* text, void* parent);

// ── Methods ──────────────────────────────────────────────────────────────
QTEXTDOCUMENT_API void* qteQTextDocument_clone(void* _obj, void* parent);
QTEXTDOCUMENT_API int qteQTextDocument_isEmpty(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_clear(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setUndoRedoEnabled(void* _obj, int enable);
QTEXTDOCUMENT_API int qteQTextDocument_isUndoRedoEnabled(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_isUndoAvailable(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_isRedoAvailable(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_availableUndoSteps(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_availableRedoSteps(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_revision(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setDocumentLayout(void* _obj, void* layout);
QTEXTDOCUMENT_API void* qteQTextDocument_documentLayout(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setMetaInformation(void* _obj, int info, void* p1);
QTEXTDOCUMENT_API void* qteQTextDocument_metaInformation(void* _obj, int info);
QTEXTDOCUMENT_API void* qteQTextDocument_toHtml(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setHtml(void* _obj, void* html);
QTEXTDOCUMENT_API void* qteQTextDocument_toRawText(void* _obj);
QTEXTDOCUMENT_API void* qteQTextDocument_toPlainText(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setPlainText(void* _obj, void* text);
QTEXTDOCUMENT_API void* qteQTextDocument_frameAt(void* _obj, int pos);
QTEXTDOCUMENT_API void* qteQTextDocument_rootFrame(void* _obj);
QTEXTDOCUMENT_API void* qteQTextDocument_object(void* _obj, int objectIndex);
QTEXTDOCUMENT_API void qteQTextDocument_setDefaultFont(void* _obj, void* font);
QTEXTDOCUMENT_API void* qteQTextDocument_defaultFont(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_pageCount(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_isModified(void* _obj);
// print() removed — requires QPrintSupport
QTEXTDOCUMENT_API void qteQTextDocument_markContentsDirty(void* _obj, int from, int length);
QTEXTDOCUMENT_API void qteQTextDocument_setUseDesignMetrics(void* _obj, int b);
QTEXTDOCUMENT_API int qteQTextDocument_useDesignMetrics(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setTextWidth(void* _obj, double width);
QTEXTDOCUMENT_API double qteQTextDocument_textWidth(void* _obj);
QTEXTDOCUMENT_API double qteQTextDocument_idealWidth(void* _obj);
QTEXTDOCUMENT_API double qteQTextDocument_indentWidth(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setIndentWidth(void* _obj, double width);
QTEXTDOCUMENT_API double qteQTextDocument_documentMargin(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setDocumentMargin(void* _obj, double margin);
QTEXTDOCUMENT_API void qteQTextDocument_adjustSize(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_blockCount(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_lineCount(void* _obj);
QTEXTDOCUMENT_API int qteQTextDocument_characterCount(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setDefaultStyleSheet(void* _obj, void* sheet);
QTEXTDOCUMENT_API void* qteQTextDocument_defaultStyleSheet(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_undo_p(void* _obj, void* cursor);
QTEXTDOCUMENT_API void qteQTextDocument_redo_p(void* _obj, void* cursor);
QTEXTDOCUMENT_API void qteQTextDocument_clearUndoRedoStacks(void* _obj, int historyToClear);
QTEXTDOCUMENT_API int qteQTextDocument_maximumBlockCount(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setMaximumBlockCount(void* _obj, int maximum);
QTEXTDOCUMENT_API int qteQTextDocument_defaultCursorMoveStyle(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_setDefaultCursorMoveStyle(void* _obj, int style);
QTEXTDOCUMENT_API void qteQTextDocument_undo_v(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_redo_v(void* _obj);
QTEXTDOCUMENT_API void qteQTextDocument_appendUndoItem(void* _obj, void* p0);
QTEXTDOCUMENT_API void qteQTextDocument_setModified(void* _obj, int m);
// docHandle() removed — internal Qt type

} // extern "C"
