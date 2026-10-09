#include "qte56_qcompleter.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QCompleter>
#include <QStringListModel>
#include <QLineEdit>
#include <QComboBox>
#include <QString>
#include <QStringList>

// ── Жизненный цикл ────────────────────────────────────────────────────────────

void* qteQCompleter_create() {
    return qte_createTracked(new QCompleter());
}

void* qteQCompleter_createList(const wchar_t* joined, int len) {
    QStringList lst = dWstringToQStringList(joined, len);
    return qte_createTracked(new QCompleter(lst));
}

void qteQCompleter_delete(void* c) {
    delete static_cast<QCompleter*>(c);
}

// ── Настройка ─────────────────────────────────────────────────────────────────

void qteQCompleter_setCompletionMode(void* c, int mode) {
    static_cast<QCompleter*>(c)->setCompletionMode(
        static_cast<QCompleter::CompletionMode>(mode));
}

void qteQCompleter_setCaseSensitivity(void* c, int cs) {
    static_cast<QCompleter*>(c)->setCaseSensitivity(
        static_cast<Qt::CaseSensitivity>(cs));
}

void qteQCompleter_setMaxVisibleItems(void* c, int n) {
    static_cast<QCompleter*>(c)->setMaxVisibleItems(n);
}

void qteQCompleter_setPrefix(void* c, const wchar_t* prefix, int len) {
    static_cast<QCompleter*>(c)->setCompletionPrefix(
        dWstringToQString(prefix, len));
}

// ── Запросы ───────────────────────────────────────────────────────────────────

int qteQCompleter_completionCount(void* c) {
    return static_cast<QCompleter*>(c)->completionCount();
}

// Возвращает новый QString* — освободить через qteQString_free.
void* qteQCompleter_currentCompletion(void* c) {
    return new QString(static_cast<QCompleter*>(c)->currentCompletion());
}

void qteQCompleter_complete(void* c) {
    static_cast<QCompleter*>(c)->complete();
}

// ── Динамическое обновление модели ───────────────────────────────────────────

void qteQCompleter_setModelFromList(void* c, const wchar_t* joined, int len) {
    QStringList lst = dWstringToQStringList(joined, len);
    // QStringListModel позволяет обновить список без пересоздания комплитера.
    QCompleter* comp = static_cast<QCompleter*>(c);
    QStringListModel* model = qobject_cast<QStringListModel*>(comp->model());
    if (model) {
        model->setStringList(lst);
    } else {
        comp->setModel(new QStringListModel(lst, comp));
    }
}

// ── Сигнал activated ─────────────────────────────────────────────────────────
//
// QCompleter::activated(const QString&) — пользователь выбрал вариант.
// cb(wchar_t*, len, ctx) вызывается в потоке, где живёт QCompleter (главный).

void qteQCompleter_connect_activated(void* c,
                                     void (*cb)(const wchar_t*, int, void*),
                                     void* ctx) {
    QObject::connect(
        static_cast<QCompleter*>(c),
        QOverload<const QString&>::of(&QCompleter::activated),
        [cb, ctx](const QString& text) {
            // D wchar is always 2-byte UTF-16; pass utf16 data directly.
            cb(qstringToDWstringPtr(text), text.length(), ctx);
        });
}

// ── Привязка к виджетам ───────────────────────────────────────────────────────

void qteQLineEdit_setCompleter(void* lineEdit, void* completer) {
    static_cast<QLineEdit*>(lineEdit)->setCompleter(
        static_cast<QCompleter*>(completer));
}

void qteQComboBox_setCompleter(void* comboBox, void* completer) {
    static_cast<QComboBox*>(comboBox)->setCompleter(
        static_cast<QCompleter*>(completer));
}
