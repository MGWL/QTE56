#include "qte56_qlayout.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QLayout>
#include <QBoxLayout>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QFormLayout>
#include <QWidget>
#include <QString>

// ── QBoxLayout shared ─────────────────────────────────────────────────────────

extern "C" QLAYOUT_API void qteQBoxLayout_addWidget(void* layout, void* widget, int stretch) {
    ((QBoxLayout*)layout)->addWidget((QWidget*)widget, stretch);
}

extern "C" QLAYOUT_API void qteQBoxLayout_addStretch(void* layout, int stretch) {
    ((QBoxLayout*)layout)->addStretch(stretch);
}

extern "C" QLAYOUT_API void qteQBoxLayout_setSpacing(void* layout, int spacing) {
    ((QBoxLayout*)layout)->setSpacing(spacing);
}

extern "C" QLAYOUT_API void qteQBoxLayout_setContentsMargins(void* layout,
                                                               int l, int t, int r, int b) {
    ((QBoxLayout*)layout)->setContentsMargins(l, t, r, b);
}

extern "C" QLAYOUT_API void qteQBoxLayout_addLayout(void* layout, void* sublayout, int stretch) {
    ((QBoxLayout*)layout)->addLayout((QLayout*)sublayout, stretch);
}

extern "C" QLAYOUT_API int qteQBoxLayout_count(void* layout) {
    return ((QBoxLayout*)layout)->count();
}

// ── QVBoxLayout ───────────────────────────────────────────────────────────────

extern "C" QLAYOUT_API void* qteQVBoxLayout_create(void* parent) {
    return qte_createTracked(new QVBoxLayout((QWidget*)parent);
}

extern "C" QLAYOUT_API void qteQVBoxLayout_delete(void* layout) {
    delete (QVBoxLayout*)layout;
}

// ── QHBoxLayout ───────────────────────────────────────────────────────────────

extern "C" QLAYOUT_API void* qteQHBoxLayout_create(void* parent) {
    return qte_createTracked(new QHBoxLayout((QWidget*)parent);
}

extern "C" QLAYOUT_API void qteQHBoxLayout_delete(void* layout) {
    delete (QHBoxLayout*)layout;
}

// ── QGridLayout ───────────────────────────────────────────────────────────────

extern "C" QLAYOUT_API void* qteQGridLayout_create(void* parent) {
    return qte_createTracked(new QGridLayout((QWidget*)parent);
}

extern "C" QLAYOUT_API void qteQGridLayout_delete(void* layout) {
    delete (QGridLayout*)layout;
}

extern "C" QLAYOUT_API void qteQGridLayout_addWidget(void* layout, void* widget,
                                                       int row, int col) {
    ((QGridLayout*)layout)->addWidget((QWidget*)widget, row, col);
}

extern "C" QLAYOUT_API void qteQGridLayout_addWidget5(void* layout, void* widget,
                                                        int row, int col,
                                                        int rowspan, int colspan) {
    ((QGridLayout*)layout)->addWidget((QWidget*)widget, row, col, rowspan, colspan);
}

extern "C" QLAYOUT_API void qteQGridLayout_setSpacing(void* layout, int spacing) {
    ((QGridLayout*)layout)->setSpacing(spacing);
}

extern "C" QLAYOUT_API void qteQGridLayout_setContentsMargins(void* layout,
                                                                int l, int t, int r, int b) {
    ((QGridLayout*)layout)->setContentsMargins(l, t, r, b);
}

extern "C" QLAYOUT_API void qteQGridLayout_addLayout(void* layout, void* sublayout,
                                                       int row, int col) {
    ((QGridLayout*)layout)->addLayout((QLayout*)sublayout, row, col);
}

extern "C" QLAYOUT_API void qteQGridLayout_addLayout5(void* layout, void* sublayout,
                                                        int row, int col,
                                                        int rowspan, int colspan) {
    ((QGridLayout*)layout)->addLayout((QLayout*)sublayout, row, col, rowspan, colspan);
}

extern "C" QLAYOUT_API void qteQGridLayout_setRowStretch(void* layout, int row, int stretch) {
    ((QGridLayout*)layout)->setRowStretch(row, stretch);
}

extern "C" QLAYOUT_API void qteQGridLayout_setColumnStretch(void* layout, int col, int stretch) {
    ((QGridLayout*)layout)->setColumnStretch(col, stretch);
}

extern "C" QLAYOUT_API int qteQGridLayout_rowCount(void* layout) {
    return ((QGridLayout*)layout)->rowCount();
}

extern "C" QLAYOUT_API int qteQGridLayout_columnCount(void* layout) {
    return ((QGridLayout*)layout)->columnCount();
}

// ── QFormLayout ───────────────────────────────────────────────────────────────

extern "C" QLAYOUT_API void* qteQFormLayout_create(void* parent) {
    return qte_createTracked(new QFormLayout((QWidget*)parent);
}

extern "C" QLAYOUT_API void qteQFormLayout_delete(void* layout) {
    delete (QFormLayout*)layout;
}

extern "C" QLAYOUT_API void qteQFormLayout_addRow(void* layout,
                                                    void* label,
                                                    void* widget) {
    ((QFormLayout*)layout)->addRow(
        *(QString*)label,
        (QWidget*)widget);
}

extern "C" QLAYOUT_API void qteQFormLayout_setSpacing(void* layout, int spacing) {
    ((QFormLayout*)layout)->setSpacing(spacing);
}

extern "C" QLAYOUT_API void qteQFormLayout_setContentsMargins(void* layout,
                                                                int l, int t, int r, int b) {
    ((QFormLayout*)layout)->setContentsMargins(l, t, r, b);
}

extern "C" QLAYOUT_API void qteQFormLayout_addRowWW(void* layout,
                                                      void* label_widget, void* field_widget) {
    ((QFormLayout*)layout)->addRow((QWidget*)label_widget, (QWidget*)field_widget);
}

extern "C" QLAYOUT_API int qteQFormLayout_rowCount(void* layout) {
    return ((QFormLayout*)layout)->rowCount();
}

// ── QLayout base extras (629–631) ─────────────────────────────────────────────

extern "C" QLAYOUT_API void qteQLayout_removeWidget(void* layout, void* widget) {
    ((QLayout*)layout)->removeWidget((QWidget*)widget);
}

extern "C" QLAYOUT_API int qteQLayout_activate(void* layout) {
    return ((QLayout*)layout)->activate() ? 1 : 0;
}

extern "C" QLAYOUT_API void qteQLayout_update(void* layout) {
    ((QLayout*)layout)->update();
}

// ── QBoxLayout extras (632–636) ───────────────────────────────────────────────

extern "C" QLAYOUT_API void qteQBoxLayout_insertWidget(void* layout, int idx,
                                                         void* widget, int stretch) {
    ((QBoxLayout*)layout)->insertWidget(idx, (QWidget*)widget, stretch);
}

extern "C" QLAYOUT_API void qteQBoxLayout_addSpacing(void* layout, int size) {
    ((QBoxLayout*)layout)->addSpacing(size);
}

extern "C" QLAYOUT_API void qteQBoxLayout_insertSpacing(void* layout, int idx, int size) {
    ((QBoxLayout*)layout)->insertSpacing(idx, size);
}

extern "C" QLAYOUT_API void qteQBoxLayout_setStretch(void* layout, int idx, int stretch) {
    ((QBoxLayout*)layout)->setStretch(idx, stretch);
}

extern "C" QLAYOUT_API int qteQBoxLayout_stretchAt(void* layout, int idx) {
    return ((QBoxLayout*)layout)->stretch(idx);
}

// ── QGridLayout extras (637–640) ──────────────────────────────────────────────

extern "C" QLAYOUT_API int qteQGridLayout_rowStretch(void* layout, int row) {
    return ((QGridLayout*)layout)->rowStretch(row);
}

extern "C" QLAYOUT_API int qteQGridLayout_columnStretch(void* layout, int col) {
    return ((QGridLayout*)layout)->columnStretch(col);
}

extern "C" QLAYOUT_API void qteQGridLayout_setRowMinimumHeight(void* layout, int row, int h) {
    ((QGridLayout*)layout)->setRowMinimumHeight(row, h);
}

extern "C" QLAYOUT_API void qteQGridLayout_setColumnMinimumWidth(void* layout, int col, int w) {
    ((QGridLayout*)layout)->setColumnMinimumWidth(col, w);
}

// ── QFormLayout extras (641–642) ──────────────────────────────────────────────

extern "C" QLAYOUT_API void qteQFormLayout_removeRow(void* layout, int row) {
    ((QFormLayout*)layout)->removeRow(row);
}

extern "C" QLAYOUT_API void qteQFormLayout_insertRow(void* layout, int row,
                                                       void* label,
                                                       void* widget) {
    ((QFormLayout*)layout)->insertRow(row,
        *(QString*)label,
        (QWidget*)widget);
}
