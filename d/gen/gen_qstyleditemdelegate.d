/**
 * gen_qstyleditemdelegate.d — GENERATED wrapper for QStyledItemDelegate.
 * Module: QStyledItemDelegate  |  DLL: qte56_qstyleditemdelegate.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 * Use --patch to update only generated sections while keeping manual edits.
 */
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
module gen_qstyleditemdelegate;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__qp, t_v__qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip_ip, t_i__qp, t_v__qp_i_qp_qp, t_v__qp_qp_qp_qp, ESlot, connectQt, fromQString, DRect, DPoint, DSize;
import gen_qabstractitemdelegate : QAbstractItemDelegate;

// New aliases for this module:
mixin(generateAlias("v__qp_qp"));
// MANUAL: для callBaseSizeHint
mixin(generateAlias("v__qp_qp_qp_ip_ip"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================
// ===AUTO-GENERATED-LOAD-FUNC-START===

void loadQStyledItemDelegate() {
    mixin(generateFunQt(12100, "qteQStyledItemDelegate_create", "QStyledItemDelegate"));
    mixin(generateFunQt(12101, "qteQStyledItemDelegate_delete", "QStyledItemDelegate"));
    mixin(generateFunQt(12102, "qteQStyledItemDelegate_itemEditorFactory", "QStyledItemDelegate"));
    mixin(generateFunQt(12103, "qteQStyledItemDelegate_setItemEditorFactory", "QStyledItemDelegate"));
    // MANUAL: virtual callbacks + helpers (не удалять при --patch!)
    mixin(generateFunQt(12104, "qteQStyledItemDelegate_setEventCallback", "QStyledItemDelegate"));
    mixin(generateFunQt(12105, "qteQStyledItemDelegate_callBasePaint", "QStyledItemDelegate"));
    mixin(generateFunQt(12106, "qteQStyledItemDelegate_callBaseSizeHint", "QStyledItemDelegate"));
    mixin(generateFunQt(12107, "qteQStyledItemDelegate_optionRect", "QStyledItemDelegate"));
    mixin(generateFunQt(12108, "qteQStyledItemDelegate_optionState", "QStyledItemDelegate"));
}

static this() {
    registerModule("QStyledItemDelegate", "qte56_qstyleditemdelegate.dll", &loadQStyledItemDelegate);
}

// ===AUTO-GENERATED-LOAD-FUNC-END===

// ====================================================================
// Class wrapper
// ====================================================================
// ===AUTO-GENERATED-CLASS-START===

/// D wrapper for Qt class QStyledItemDelegate.
@live class QStyledItemDelegate : QAbstractItemDelegate {
public:
    /// Create QStyledItemDelegate. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[12100])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QStyledItemDelegate* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QStyledItemDelegate wrap(void* wh) {
        auto w = new QStyledItemDelegate(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }

    /// itemEditorFactory
    void* itemEditorFactory() {
        return cast(void*)(cast(t_qp__qp)pFunQt[12102])(_wh);
    }

    /// setItemEditorFactory
    QStyledItemDelegate setItemEditorFactory(void* factory) {
        (cast(t_v__qp_qp)pFunQt[12103])(_wh, factory);
        return this;
    }

    // ===MANUAL-METHODS-START===

    // ── Virtual callbacks ────────────────────────────────────────────────
    // Указатели painter/option/index/editor/model — заимствованные,
    // валидны только внутри коллбэка. Для чтения используйте
    // QPainter.wrapBorrowed / QModelIndex.wrapBorrowed.

    /// Установить delegate-callback по id:
    /// 1=paint, 2=sizeHint, 3=createEditor, 4=setEditorData, 5=setModelData.
    QStyledItemDelegate setEventCallback(int id, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[12104])(_wh, id, cb, dthis);
        return this;
    }

    /// Кастомная отрисовка ячейки.
    /// cb: extern(C) void function(void* dthis, void* painter, void* option, void* index)
    /// painter — активный (НЕ вызывать end()); option — для optionRect/optionState;
    /// index — QModelIndex.wrapBorrowed. Базовая отрисовка: callBasePaint(...).
    QStyledItemDelegate onPaint(void* cb, void* dthis = null) {
        return setEventCallback(1, cb, dthis);
    }

    /// Кастомный размер ячейки.
    /// cb: extern(C) int function(void* dthis, void* index, int* w, int* h)
    /// вернуть 1, если размер задан (иначе вызывается базовый sizeHint).
    QStyledItemDelegate onSizeHint(void* cb, void* dthis = null) {
        return setEventCallback(2, cb, dthis);
    }

    /// Кастомный редактор ячейки.
    /// cb: extern(C) void* function(void* dthis, void* parentWidget, void* index)
    /// вернуть handle виджета-редактора (с parent = parentWidget) или null —
    /// тогда создаётся редактор по умолчанию.
    QStyledItemDelegate onCreateEditor(void* cb, void* dthis = null) {
        return setEventCallback(3, cb, dthis);
    }

    /// Заполнение редактора данными из модели.
    /// cb: extern(C) void function(void* dthis, void* editor, void* index)
    QStyledItemDelegate onSetEditorData(void* cb, void* dthis = null) {
        return setEventCallback(4, cb, dthis);
    }

    /// Запись данных из редактора в модель.
    /// cb: extern(C) void function(void* dthis, void* editor, void* model, void* index)
    QStyledItemDelegate onSetModelData(void* cb, void* dthis = null) {
        return setEventCallback(5, cb, dthis);
    }

    // ── Helpers для коллбэков ────────────────────────────────────────────

    /// Вызвать базовую реализацию paint (из обработчика onPaint).
    void callBasePaint(void* painter, void* option, void* index) {
        (cast(t_v__qp_qp_qp_qp)pFunQt[12105])(_wh, painter, option, index);
    }

    /// Базовый sizeHint (из обработчика onSizeHint).
    void callBaseSizeHint(void* option, void* index, int* w, int* h) {
        (cast(t_v__qp_qp_qp_ip_ip)pFunQt[12106])(_wh, option, index, w, h);
    }

    /// rect из QStyleOptionViewItem* (только внутри коллбэка).
    static void optionRect(void* option, int* x, int* y, int* w, int* h) {
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[12107])(option, x, y, w, h);
    }

    /// state (QStyle::State) из QStyleOptionViewItem* (только внутри коллбэка).
    static int optionState(void* option) {
        return cast(int)(cast(t_i__qp)pFunQt[12108])(option);
    }

    // ===MANUAL-METHODS-END===

} // class QStyledItemDelegate
// ===AUTO-GENERATED-CLASS-END===
