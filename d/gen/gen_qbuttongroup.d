/**
 * gen_qbuttongroup.d — обёртка для QButtonGroup.
 * DLL: qte56_foundation.dll  |  Индексы: 17500–17510
 *
 * QButtonGroup — логическое объединение кнопок (QAbstractButton-наследников).
 * Не является виджетом (нет setEventHandler, нет _wh vis-à-vis QWidget).
 * parent — любой QObject* (передавать getWH() от QWidget).
 *
 * Передача кнопок: btn.getWH() → void*
 * addButton(btn.getWH(), id) — id=-1 для авто-назначения
 *
 * Сигнальные прототипы:
 *   buttonClicked(int id):       extern(C) void cb(void* dthis, int id)
 *   buttonToggled(int id, bool): extern(C) void cb(void* dthis, int id, int checked)
 */
module gen_qbuttongroup;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ptrListFromQStr, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp;

// int function(void*, void*) — id(obj, btn)
mixin(generateAlias("i__qp_qp"));     // t_i__qp_qp

// ── Загрузка адресов функций ──────────────────────────────────────────────────

void loadQButtonGroup() {
    mixin(generateFunQt(17500, "qteQButtonGroup_create",                 "QButtonGroup"));
    mixin(generateFunQt(17501, "qteQButtonGroup_destroy",                "QButtonGroup"));
    mixin(generateFunQt(17502, "qteQButtonGroup_setExclusive",           "QButtonGroup"));
    mixin(generateFunQt(17503, "qteQButtonGroup_exclusive",              "QButtonGroup"));
    mixin(generateFunQt(17504, "qteQButtonGroup_addButton",              "QButtonGroup"));
    mixin(generateFunQt(17505, "qteQButtonGroup_removeButton",           "QButtonGroup"));
    mixin(generateFunQt(17506, "qteQButtonGroup_setId",                  "QButtonGroup"));
    mixin(generateFunQt(17507, "qteQButtonGroup_id",                     "QButtonGroup"));
    mixin(generateFunQt(17508, "qteQButtonGroup_checkedId",              "QButtonGroup"));
    mixin(generateFunQt(17509, "qteQButtonGroup_connect_buttonClicked",  "QButtonGroup"));
    mixin(generateFunQt(17510, "qteQButtonGroup_connect_buttonToggled",  "QButtonGroup"));
    mixin(generateFunQt(17511, "qteQButtonGroup_buttons",                "QButtonGroup"));
}

static this() {
    registerModule("QButtonGroup", "qte56_foundation.dll", &loadQButtonGroup);
}

// ─────────────────────────────────────────────────────────────────────────────
// QButtonGroup
// ─────────────────────────────────────────────────────────────────────────────

@live class QButtonGroup {
private:
    void* _wh;
    bool  _owned = true;

public:
    /// parent — getWH() любого QObject/QWidget, или null
    this(void* parent = null) {
        _wh = (cast(t_qp__qp)pFunQt[17500])(parent);
    }
    ~this() {
        if (_owned && _wh !is null && pFunQt[17501] !is null) {
            (cast(t_v__qp)pFunQt[17501])(_wh);
            _wh = null;
        }
    }

    void* getWH() { return _wh; }

    // ── exclusive ─────────────────────────────────────────────────────────────
    QButtonGroup setExclusive(bool v) { (cast(t_v__qp_i)pFunQt[17502])(_wh, v ? 1 : 0); return this; }
    bool exclusive()          { return (cast(t_i__qp)pFunQt[17503])(_wh) != 0; }

    // ── buttons ───────────────────────────────────────────────────────────────
    /// Добавить кнопку в группу. id=-1 → Qt назначит автоматически (отрицательный).
    QButtonGroup addButton(void* btnWH, int id = -1) {
        (cast(t_v__qp_qp_i)pFunQt[17504])(_wh, btnWH, id);
        return this;
    }
    QButtonGroup removeButton(void* btnWH) {
        (cast(t_v__qp_qp)pFunQt[17505])(_wh, btnWH);
        return this;
    }
    QButtonGroup setId(void* btnWH, int id) {
        (cast(t_v__qp_qp_i)pFunQt[17506])(_wh, btnWH, id);
        return this;
    }
    int id(void* btnWH) {
        return (cast(t_i__qp_qp)pFunQt[17507])(_wh, btnWH);
    }
    /// id текущей нажатой/выбранной кнопки (-1 если нет)
    int checkedId() {
        return (cast(t_i__qp)pFunQt[17508])(_wh);
    }

    // ── signals ───────────────────────────────────────────────────────────────
    /// buttonClicked(int id): extern(C) void cb(void* dthis, int id)
    QButtonGroup connect_buttonClicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17509])(_wh, cb, dthis);
        return this;
    }
    /// buttonToggled(int id, bool): extern(C) void cb(void* dthis, int id, int checked)
    QButtonGroup connect_buttonToggled(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17510])(_wh, cb, dthis);
        return this;
    }
    /// buttons — список QAbstractButton* в группе
    void*[] buttons() {
        return ptrListFromQStr((cast(t_qp__qp)pFunQt[17511])(_wh));
    }
}
