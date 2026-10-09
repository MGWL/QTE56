// qte56_shortcut.cpp — реализация C-обёрток для QShortcut
#include "qte56_shortcut.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QShortcut>
#include <QKeySequence>
#include <QWidget>

// 20132
void* qteQShortcut_create(void* parent, const wchar_t* key, int len) {
    QString ks = dWstringToQString(key, len);
    return qte_createTracked(new QShortcut(QKeySequence(ks), (QWidget*)parent));
}

// 20133
void qteQShortcut_delete(void* qs) {
    delete (QShortcut*)qs;
}

// 20134
void qteQShortcut_setEnabled(void* qs, int v) {
    ((QShortcut*)qs)->setEnabled(v != 0);
}

// 20135
int qteQShortcut_isEnabled(void* qs) {
    return ((QShortcut*)qs)->isEnabled() ? 1 : 0;
}

// 20136
void qteQShortcut_setContext(void* qs, int ctx) {
    ((QShortcut*)qs)->setContext((Qt::ShortcutContext)ctx);
}

// 20137
void qteQShortcut_connect_activated(void* qs, void (*cb)(void*), void* userdata) {
    QObject::connect((QShortcut*)qs, &QShortcut::activated,
        [cb, userdata](){ cb(userdata); });
}

// 20138
void qteQShortcut_setAutoRepeat(void* qs, int v) {
    ((QShortcut*)qs)->setAutoRepeat(v != 0);
}

// ── Дополнено 2026-07-26 (augment, генератор v2) ─────────────────────────────

// 20163
int qteQShortcut_context(void* qs) {
    return (int)((QShortcut*)qs)->context();
}

// 20164
void qteQShortcut_setWhatsThis(void* qs, const wchar_t* text, int len) {
    ((QShortcut*)qs)->setWhatsThis(dWstringToQString(text, len));
}

// 20165
void* qteQShortcut_whatsThis(void* qs) {
    return new QString(((QShortcut*)qs)->whatsThis());
}

// 20166
int qteQShortcut_autoRepeat(void* qs) {
    return ((QShortcut*)qs)->autoRepeat() ? 1 : 0;
}

// 20167
int qteQShortcut_id(void* qs) {
    return ((QShortcut*)qs)->id();
}

// 20168
void qteQShortcut_connect_activatedAmbiguously(void* qs, void (*cb)(void*), void* userdata) {
    QObject::connect((QShortcut*)qs, &QShortcut::activatedAmbiguously,
        [cb, userdata](){ cb(userdata); });
}
