// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-08-29T10:08:01
// command: python main.py G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h --module QStyledItemDelegate --dll qte56_qstyleditemdelegate.dll --index-start 12100
// header: G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h
// qt: 5.13.2
// module: QStyledItemDelegate
// dll: qte56_qstyleditemdelegate.dll
// d-parent: QAbstractItemDelegate (knowledge)
// index-block: 12100 (--index-start)
// index-range: 12100-12103
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 2 wrapper(s), 0 signal(s), lifecycle=tracked
// skipped-unsupported: 7
//   void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'QPainter*'
//   QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QWidget * createEditor(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   void setEditorData(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setModelData(QWidget*, QAbstractItemModel*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void updateEditorGeometry(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QString displayText(const QVariant&, const QLocale&) [method] — param type 'const QVariant&'
// ===GENERATOR-INFO-END===
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QSTYLEDITEMDELEGATE_BUILD
    #define QSTYLEDITEMDELEGATE_API __declspec(dllexport)
  #else
    #define QSTYLEDITEMDELEGATE_API __declspec(dllimport)
  #endif
#else
  #define QSTYLEDITEMDELEGATE_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QSTYLEDITEMDELEGATE_API void* qteQStyledItemDelegate_create(void* parent);
QSTYLEDITEMDELEGATE_API void  qteQStyledItemDelegate_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QSTYLEDITEMDELEGATE_API void* qteQStyledItemDelegate_itemEditorFactory(void* _obj);
QSTYLEDITEMDELEGATE_API void qteQStyledItemDelegate_setItemEditorFactory(void* _obj, void* factory);

// ── Virtual callbacks (MANUAL) ────────────────────────────────────────────
// id: 1=paint 2=sizeHint 3=createEditor 4=setEditorData 5=setModelData
// Сигнатуры D-коллбэков (все extern(C)):
//   1 paint:         void cb(void* dthis, void* painter, void* option, void* index)
//   2 sizeHint:      int  cb(void* dthis, void* index, int* w, int* h)  // 1 = размер задан
//   3 createEditor:  void* cb(void* dthis, void* parentWidget, void* index) // handle QWidget или null
//   4 setEditorData: void cb(void* dthis, void* editor, void* index)
//   5 setModelData:  void cb(void* dthis, void* editor, void* model, void* index)
// painter/option/index — заимствованные указатели, валидны только внутри коллбэка!
QSTYLEDITEMDELEGATE_API void qteQStyledItemDelegate_setEventCallback(void* w, int id, void* cb, void* dthis);

// ── Helpers для коллбэков (MANUAL) ────────────────────────────────────────
// Вызвать базовую реализацию paint/sizeHint из D-обработчика
QSTYLEDITEMDELEGATE_API void qteQStyledItemDelegate_callBasePaint(void* w, void* painter, void* option, void* index);
QSTYLEDITEMDELEGATE_API void qteQStyledItemDelegate_callBaseSizeHint(void* w, void* option, void* index, int* w_, int* h_);
// Доступ к полям QStyleOptionViewItem* (только внутри коллбэка)
QSTYLEDITEMDELEGATE_API void qteQStyledItemDelegate_optionRect(void* option, int* x, int* y, int* w, int* h);
QSTYLEDITEMDELEGATE_API int  qteQStyledItemDelegate_optionState(void* option);

} // extern "C"
