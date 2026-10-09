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
    return qte_createTracked(new QShortcut(QKeySequence(ks), (QWidget*)parent);
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
