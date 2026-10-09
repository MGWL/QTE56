#pragma once

#ifdef _WIN32
  #ifdef QTE56_QLAYOUT_BUILD
    #define QLAYOUT_API __declspec(dllexport)
  #else
    #define QLAYOUT_API __declspec(dllimport)
  #endif
#else
  #define QLAYOUT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QBoxLayout shared operations (index 6000-6003) ───────────────────────────
// Used by both QVBoxLayout and QHBoxLayout (both inherit QBoxLayout).

QLAYOUT_API void  qteQBoxLayout_addWidget(void* layout, void* widget, int stretch);
QLAYOUT_API void  qteQBoxLayout_addStretch(void* layout, int stretch);
QLAYOUT_API void  qteQBoxLayout_setSpacing(void* layout, int spacing);
QLAYOUT_API void  qteQBoxLayout_setContentsMargins(void* layout, int l, int t, int r, int b);
QLAYOUT_API void  qteQBoxLayout_addLayout(void* layout, void* sublayout, int stretch);
QLAYOUT_API int   qteQBoxLayout_count(void* layout);

// ── QVBoxLayout (index 7000-7001) ─────────────────────────────────────────────
// If parent != nullptr, Qt installs this layout on parent automatically.

QLAYOUT_API void* qteQVBoxLayout_create(void* parent);
QLAYOUT_API void  qteQVBoxLayout_delete(void* layout);

// ── QHBoxLayout (index 8000-8001) ─────────────────────────────────────────────

QLAYOUT_API void* qteQHBoxLayout_create(void* parent);
QLAYOUT_API void  qteQHBoxLayout_delete(void* layout);

// ── QGridLayout (index 9000-9005) ─────────────────────────────────────────────

QLAYOUT_API void* qteQGridLayout_create(void* parent);
QLAYOUT_API void  qteQGridLayout_delete(void* layout);

// addWidget(layout, widget, row, col)
QLAYOUT_API void  qteQGridLayout_addWidget(void* layout, void* widget, int row, int col);

// addWidget with span: addWidget(layout, widget, row, col, rowspan, colspan)
QLAYOUT_API void  qteQGridLayout_addWidget5(void* layout, void* widget,
                                             int row, int col, int rowspan, int colspan);
QLAYOUT_API void  qteQGridLayout_setSpacing(void* layout, int spacing);
QLAYOUT_API void  qteQGridLayout_setContentsMargins(void* layout, int l, int t, int r, int b);
QLAYOUT_API void  qteQGridLayout_addLayout(void* layout, void* sublayout, int row, int col);
QLAYOUT_API void  qteQGridLayout_addLayout5(void* layout, void* sublayout, int row, int col,
                                              int rowspan, int colspan);
QLAYOUT_API void  qteQGridLayout_setRowStretch(void* layout, int row, int stretch);
QLAYOUT_API void  qteQGridLayout_setColumnStretch(void* layout, int col, int stretch);
QLAYOUT_API int   qteQGridLayout_rowCount(void* layout);
QLAYOUT_API int   qteQGridLayout_columnCount(void* layout);

// ── QFormLayout (index 10000-10004) ───────────────────────────────────────────

QLAYOUT_API void* qteQFormLayout_create(void* parent);
QLAYOUT_API void  qteQFormLayout_delete(void* layout);

// addRow(layout, label_utf16, label_len, field_widget)
QLAYOUT_API void  qteQFormLayout_addRow(void* layout,
                                         void* label,
                                         void* widget);
QLAYOUT_API void  qteQFormLayout_setSpacing(void* layout, int spacing);
QLAYOUT_API void  qteQFormLayout_setContentsMargins(void* layout, int l, int t, int r, int b);
QLAYOUT_API void  qteQFormLayout_addRowWW(void* layout, void* label_widget, void* field_widget);
QLAYOUT_API int   qteQFormLayout_rowCount(void* layout);

// ── QLayout base extras (629–631) ─────────────────────────────────────────────

QLAYOUT_API void  qteQLayout_removeWidget(void* layout, void* widget);
QLAYOUT_API int   qteQLayout_activate(void* layout);
QLAYOUT_API void  qteQLayout_update(void* layout);

// ── QBoxLayout extras (632–636) ───────────────────────────────────────────────

QLAYOUT_API void  qteQBoxLayout_insertWidget(void* layout, int idx, void* widget, int stretch);
QLAYOUT_API void  qteQBoxLayout_addSpacing(void* layout, int size);
QLAYOUT_API void  qteQBoxLayout_insertSpacing(void* layout, int idx, int size);
QLAYOUT_API void  qteQBoxLayout_setStretch(void* layout, int idx, int stretch);
QLAYOUT_API int   qteQBoxLayout_stretchAt(void* layout, int idx);

// ── QGridLayout extras (637–640) ──────────────────────────────────────────────

QLAYOUT_API int   qteQGridLayout_rowStretch(void* layout, int row);
QLAYOUT_API int   qteQGridLayout_columnStretch(void* layout, int col);
QLAYOUT_API void  qteQGridLayout_setRowMinimumHeight(void* layout, int row, int h);
QLAYOUT_API void  qteQGridLayout_setColumnMinimumWidth(void* layout, int col, int w);

// ── QFormLayout extras (641–642) ──────────────────────────────────────────────

QLAYOUT_API void  qteQFormLayout_removeRow(void* layout, int row);
QLAYOUT_API void  qteQFormLayout_insertRow(void* layout, int row,
                                            void* label,
                                            void* widget);

} // extern "C"
