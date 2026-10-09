// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-08-29T10:07:49
// command: python main.py G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qabstractitemdelegate.h --module QAbstractItemDelegate --dll qte56_qstyleditemdelegate.dll --index-start 12018
// header: G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qabstractitemdelegate.h
// qt: 5.13.2
// module: QAbstractItemDelegate
// dll: qte56_qstyleditemdelegate.dll
// d-parent: QObject (knowledge)
// index-block: 12018 (--index-start)
// index-range: 12018-12020
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 0 wrapper(s), 2 signal(s), lifecycle=tracked
// skipped-unsupported: 12
//   void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'QPainter*'
//   QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QWidget * createEditor(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   void destroyEditor(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setEditorData(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setModelData(QWidget*, QAbstractItemModel*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void updateEditorGeometry(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   bool editorEvent(QEvent*, QAbstractItemModel*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QString elidedText(const QFontMetrics&, int, Qt::TextElideMode, const QString&) [method] — param type 'const QFontMetrics&'
//   bool helpEvent(QHelpEvent*, QAbstractItemView*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QVector<int> paintingRoles() [method] — return type 'QVector<int>'
//   void sizeHintChanged(const QModelIndex&) [signal] — param type 'const QModelIndex&'
// ===GENERATOR-INFO-END===
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QABSTRACTITEMDELEGATE_BUILD
    #define QABSTRACTITEMDELEGATE_API __declspec(dllexport)
  #else
    #define QABSTRACTITEMDELEGATE_API __declspec(dllimport)
  #endif
#else
  #define QABSTRACTITEMDELEGATE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QABSTRACTITEMDELEGATE_API void* qteQAbstractItemDelegate_create(void* parent);
QABSTRACTITEMDELEGATE_API void  qteQAbstractItemDelegate_delete(void* w);


// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
QABSTRACTITEMDELEGATE_API void qteQAbstractItemDelegate_connect_commitData(void* w, void* cb, void* dthis);

} // extern "C"
