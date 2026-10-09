#ifndef QTE56_QTEXTDOCUMENT_BUILD
#define QTE56_QTEXTDOCUMENT_BUILD
#endif
#include "qte56_qtextdocument.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTextDocument>
#include <QTextCursor>
#include <QString>
#include <QFont>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextDocument_create(void* parent) {
    return qte_createTracked(new QTextDocument((QObject*)parent);
}

void qteQTextDocument_delete(void* w) {
    delete (QTextDocument*)w;
}

void* qteQTextDocument_create_text(void* text, void* parent) {
    return qte_createTracked(new QTextDocument(*(QString*)text, (QObject*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQTextDocument_clone(void* _obj, void* parent) {
    return (void*)((QTextDocument*)_obj)->clone((QObject*)parent);
}

int qteQTextDocument_isEmpty(void* _obj) {
    return ((QTextDocument*)_obj)->isEmpty() ? 1 : 0;
}

void qteQTextDocument_clear(void* _obj) {
    ((QTextDocument*)_obj)->clear();
}

void qteQTextDocument_setUndoRedoEnabled(void* _obj, int enable) {
    ((QTextDocument*)_obj)->setUndoRedoEnabled((enable != 0));
}

int qteQTextDocument_isUndoRedoEnabled(void* _obj) {
    return ((QTextDocument*)_obj)->isUndoRedoEnabled() ? 1 : 0;
}

int qteQTextDocument_isUndoAvailable(void* _obj) {
    return ((QTextDocument*)_obj)->isUndoAvailable() ? 1 : 0;
}

int qteQTextDocument_isRedoAvailable(void* _obj) {
    return ((QTextDocument*)_obj)->isRedoAvailable() ? 1 : 0;
}

int qteQTextDocument_availableUndoSteps(void* _obj) {
    return ((QTextDocument*)_obj)->availableUndoSteps();
}

int qteQTextDocument_availableRedoSteps(void* _obj) {
    return ((QTextDocument*)_obj)->availableRedoSteps();
}

int qteQTextDocument_revision(void* _obj) {
    return ((QTextDocument*)_obj)->revision();
}

void qteQTextDocument_setDocumentLayout(void* _obj, void* layout) {
    ((QTextDocument*)_obj)->setDocumentLayout((QAbstractTextDocumentLayout*)layout);
}

void* qteQTextDocument_documentLayout(void* _obj) {
    return (void*)((QTextDocument*)_obj)->documentLayout();
}

void qteQTextDocument_setMetaInformation(void* _obj, int info, void* p1) {
    ((QTextDocument*)_obj)->setMetaInformation((QTextDocument::MetaInformation)info, *(QString*)p1);
}

void* qteQTextDocument_metaInformation(void* _obj, int info) {
    return new QString(((QTextDocument*)_obj)->metaInformation((QTextDocument::MetaInformation)info));
}

void* qteQTextDocument_toHtml(void* _obj) {
    return new QString(((QTextDocument*)_obj)->toHtml());
}

void qteQTextDocument_setHtml(void* _obj, void* html) {
    ((QTextDocument*)_obj)->setHtml(*(QString*)html);
}

void* qteQTextDocument_toRawText(void* _obj) {
    return new QString(((QTextDocument*)_obj)->toRawText());
}

void* qteQTextDocument_toPlainText(void* _obj) {
    return new QString(((QTextDocument*)_obj)->toPlainText());
}

void qteQTextDocument_setPlainText(void* _obj, void* text) {
    ((QTextDocument*)_obj)->setPlainText(*(QString*)text);
}

void* qteQTextDocument_frameAt(void* _obj, int pos) {
    return (void*)((QTextDocument*)_obj)->frameAt(pos);
}

void* qteQTextDocument_rootFrame(void* _obj) {
    return (void*)((QTextDocument*)_obj)->rootFrame();
}

void* qteQTextDocument_object(void* _obj, int objectIndex) {
    return (void*)((QTextDocument*)_obj)->object(objectIndex);
}

void qteQTextDocument_setDefaultFont(void* _obj, void* font) {
    ((QTextDocument*)_obj)->setDefaultFont(*(const QFont*)font);
}

void* qteQTextDocument_defaultFont(void* _obj) {
    return new QFont(((QTextDocument*)_obj)->defaultFont());
}

int qteQTextDocument_pageCount(void* _obj) {
    return ((QTextDocument*)_obj)->pageCount();
}

int qteQTextDocument_isModified(void* _obj) {
    return ((QTextDocument*)_obj)->isModified() ? 1 : 0;
}

// print() removed — requires QPrintSupport module

void qteQTextDocument_markContentsDirty(void* _obj, int from, int length) {
    ((QTextDocument*)_obj)->markContentsDirty(from, length);
}

void qteQTextDocument_setUseDesignMetrics(void* _obj, int b) {
    ((QTextDocument*)_obj)->setUseDesignMetrics((b != 0));
}

int qteQTextDocument_useDesignMetrics(void* _obj) {
    return ((QTextDocument*)_obj)->useDesignMetrics() ? 1 : 0;
}

void qteQTextDocument_setTextWidth(void* _obj, double width) {
    ((QTextDocument*)_obj)->setTextWidth(width);
}

double qteQTextDocument_textWidth(void* _obj) {
    return ((QTextDocument*)_obj)->textWidth();
}

double qteQTextDocument_idealWidth(void* _obj) {
    return ((QTextDocument*)_obj)->idealWidth();
}

double qteQTextDocument_indentWidth(void* _obj) {
    return ((QTextDocument*)_obj)->indentWidth();
}

void qteQTextDocument_setIndentWidth(void* _obj, double width) {
    ((QTextDocument*)_obj)->setIndentWidth(width);
}

double qteQTextDocument_documentMargin(void* _obj) {
    return ((QTextDocument*)_obj)->documentMargin();
}

void qteQTextDocument_setDocumentMargin(void* _obj, double margin) {
    ((QTextDocument*)_obj)->setDocumentMargin(margin);
}

void qteQTextDocument_adjustSize(void* _obj) {
    ((QTextDocument*)_obj)->adjustSize();
}

int qteQTextDocument_blockCount(void* _obj) {
    return ((QTextDocument*)_obj)->blockCount();
}

int qteQTextDocument_lineCount(void* _obj) {
    return ((QTextDocument*)_obj)->lineCount();
}

int qteQTextDocument_characterCount(void* _obj) {
    return ((QTextDocument*)_obj)->characterCount();
}

void qteQTextDocument_setDefaultStyleSheet(void* _obj, void* sheet) {
    ((QTextDocument*)_obj)->setDefaultStyleSheet(*(QString*)sheet);
}

void* qteQTextDocument_defaultStyleSheet(void* _obj) {
    return new QString(((QTextDocument*)_obj)->defaultStyleSheet());
}

void qteQTextDocument_undo_p(void* _obj, void* cursor) {
    ((QTextDocument*)_obj)->undo((QTextCursor*)cursor);
}

void qteQTextDocument_redo_p(void* _obj, void* cursor) {
    ((QTextDocument*)_obj)->redo((QTextCursor*)cursor);
}

void qteQTextDocument_clearUndoRedoStacks(void* _obj, int historyToClear) {
    ((QTextDocument*)_obj)->clearUndoRedoStacks((QTextDocument::Stacks)historyToClear);
}

int qteQTextDocument_maximumBlockCount(void* _obj) {
    return ((QTextDocument*)_obj)->maximumBlockCount();
}

void qteQTextDocument_setMaximumBlockCount(void* _obj, int maximum) {
    ((QTextDocument*)_obj)->setMaximumBlockCount(maximum);
}

int qteQTextDocument_defaultCursorMoveStyle(void* _obj) {
    return ((QTextDocument*)_obj)->defaultCursorMoveStyle();
}

void qteQTextDocument_setDefaultCursorMoveStyle(void* _obj, int style) {
    ((QTextDocument*)_obj)->setDefaultCursorMoveStyle((Qt::CursorMoveStyle)style);
}

void qteQTextDocument_undo_v(void* _obj) {
    ((QTextDocument*)_obj)->undo();
}

void qteQTextDocument_redo_v(void* _obj) {
    ((QTextDocument*)_obj)->redo();
}

void qteQTextDocument_appendUndoItem(void* _obj, void* p0) {
    ((QTextDocument*)_obj)->appendUndoItem((QAbstractUndoItem*)p0);
}

void qteQTextDocument_setModified(void* _obj, int m) {
    ((QTextDocument*)_obj)->setModified((m != 0));
}

// docHandle() removed — internal Qt type

} // extern "C"
