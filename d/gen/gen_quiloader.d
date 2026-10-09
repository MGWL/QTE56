/**
 * gen_quiloader.d — D bindings for QUiLoader and findChild.
 *
 * Позволяет загружать .ui-файлы Qt Designer в рантайме и находить
 * дочерние виджеты по имени объекта (objectName из Designer).
 *
 * Indices: 19812–19815 (qte56_uiloader.dll)
 */
module gen_quiloader;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : fromQString, toQString, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp;

// void* function(void*, void*, void*)  — load(loader, path_qs, parent)
mixin(generateAlias("qp__qp_qp_qp"));

// ── Load ──────────────────────────────────────────────────────────────────────

void loadQUiLoader() {
    mixin(generateFunQt(19812, "qteQUiLoader_create",         "QUiLoader"));
    mixin(generateFunQt(19813, "qteQUiLoader_delete",         "QUiLoader"));
    mixin(generateFunQt(19814, "qteQUiLoader_load",           "QUiLoader"));
    mixin(generateFunQt(19815, "qteQWidget_findChild",        "QUiLoader"));
    mixin(generateFunQt(20156, "qteQObject_findChildAction",  "QUiLoader"));
}

static this() {
    registerModule("QUiLoader", "qte56_uiloader.dll", &loadQUiLoader);
}

// ── QUiLoader D class ─────────────────────────────────────────────────────────

/// Low-level Qt Designer form loader.
/// Предпочитай высокоуровневый qte56_forms.QForm для удобства.
@live class QUiLoader {
private:
    void* _lh;

public:
    this() {
        _lh = (cast(t_qp__)pFunQt[19812])();
    }

    ~this() {
        if (_lh !is null && pFunQt[19813] !is null) {
            (cast(t_v__qp)pFunQt[19813])(_lh);
            _lh = null;
        }
    }

    /// Загрузить .ui файл, вернуть корневой QWidget* или null при ошибке.
    /// parent — указатель на родительский виджет (null для top-level).
    void* load(string path, void* parent = null) {
        auto qs = toQString(path);
        auto result = (cast(t_qp__qp_qp_qp)pFunQt[19814])(_lh, qs, parent);
        (cast(t_v__qp)pFunQt[22])(qs);
        return result;
    }

    void* getHandle() { return _lh; }
}

// ── findChild — свободные функции ─────────────────────────────────────────────

/// Рекурсивно найти дочерний QWidget по objectName в дереве parent.
/// Возвращает void* (QWidget*) или null если не найден.
void* findChildWidget(void* parentWH, string name) {
    auto qs = toQString(name);
    auto result = (cast(t_qp__qp_qp)pFunQt[19815])(parentWH, qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return result;
}

/// Рекурсивно найти дочерний QAction по objectName в дереве parent.
/// QAction наследуется от QObject (не QWidget) — `findChildWidget` его не находит,
/// поэтому используем отдельную C++ функцию с `findChild<QAction*>(name)`.
/// Возвращает void* (QAction*) или null если не найден.
void* findChildAction(void* parentWH, string name) {
    auto qs = toQString(name);
    auto result = (cast(t_qp__qp_qp)pFunQt[20156])(parentWH, qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    return result;
}
