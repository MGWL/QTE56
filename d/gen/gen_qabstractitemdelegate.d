/**
 * gen_qabstractitemdelegate.d — GENERATED wrapper for QAbstractItemDelegate.
 * Module: QAbstractItemDelegate  |  DLL: qte56_qstyleditemdelegate.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 * Use --patch to update only generated sections while keeping manual edits.
 */
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
module gen_qabstractitemdelegate;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__qp, t_v__qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp_qp, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qobject : QObject;

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================
// ===AUTO-GENERATED-LOAD-FUNC-START===

void loadQAbstractItemDelegate() {
    mixin(generateFunQt(12018, "qteQAbstractItemDelegate_create", "QAbstractItemDelegate"));
    mixin(generateFunQt(12019, "qteQAbstractItemDelegate_delete", "QAbstractItemDelegate"));
    mixin(generateFunQt(12020, "qteQAbstractItemDelegate_connect_commitData", "QAbstractItemDelegate"));
}

static this() {
    registerModule("QAbstractItemDelegate", "qte56_qstyleditemdelegate.dll", &loadQAbstractItemDelegate);
}

// ===AUTO-GENERATED-LOAD-FUNC-END===

// ====================================================================
// Class wrapper
// ====================================================================
// ===AUTO-GENERATED-CLASS-START===

/// D wrapper for Qt class QAbstractItemDelegate.
@live class QAbstractItemDelegate : QObject {
public:
    /// Create QAbstractItemDelegate. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[12018])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QAbstractItemDelegate* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QAbstractItemDelegate wrap(void* wh) {
        auto w = new QAbstractItemDelegate(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// Connect signal commitData → прямой callback (DSlot_ptr)
    /// cb: extern(C) void function(void* dthis, int n, void* ptr)
    QAbstractItemDelegate connect_commitData(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[12020])(_wh, cb, dthis);
        return this;
    }

    // Signal closeEditor — unsupported parameter types
    // ===MANUAL-METHODS-START===
    // ===MANUAL-METHODS-END===

} // class QAbstractItemDelegate
// ===AUTO-GENERATED-CLASS-END===
