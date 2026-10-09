#ifndef QTE56_QACTION_BUILD
#define QTE56_QACTION_BUILD
#endif
#include "qte56_qaction.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"

#include <QAction>
#include <QFont>
#include <QIcon>
#include <QKeySequence>
#include <QMenu>
#include <QString>

// ─────────────────────────────────────────────────────────────────────────────
// Lifecycle
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_create(void* parent) {
    return qte_createTracked(new QAction((QObject*)parent));
}

extern "C" QACTION_API void qteQAction_delete(void* _obj) {
    delete (QAction*)_obj;
}

extern "C" QACTION_API void* qteQAction_create_text(void* text,
                                                     void* parent) {
    return qte_createTracked(new QAction(*(QString*)text, (QObject*)parent));
}

// ─────────────────────────────────────────────────────────────────────────────
// Text
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_text(void* _obj) {
    return new QString(((QAction*)_obj)->text());
}

extern "C" QACTION_API void qteQAction_setText(void* _obj,
                                               void* p0) {
    ((QAction*)_obj)->setText(*(QString*)p0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Enable / visibility
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_isEnabled(void* _obj) {
    return ((QAction*)_obj)->isEnabled() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setEnabled(void* _obj, int p0) {
    ((QAction*)_obj)->setEnabled(p0 != 0);
}

extern "C" QACTION_API int qteQAction_isVisible(void* _obj) {
    return ((QAction*)_obj)->isVisible() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setVisible(void* _obj, int p0) {
    ((QAction*)_obj)->setVisible(p0 != 0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Check state
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_isChecked(void* _obj) {
    return ((QAction*)_obj)->isChecked() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setChecked(void* _obj, int p0) {
    ((QAction*)_obj)->setChecked(p0 != 0);
}

extern "C" QACTION_API int qteQAction_isCheckable(void* _obj) {
    return ((QAction*)_obj)->isCheckable() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setCheckable(void* _obj, int p0) {
    ((QAction*)_obj)->setCheckable(p0 != 0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Separator
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_isSeparator(void* _obj) {
    return ((QAction*)_obj)->isSeparator() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setSeparator(void* _obj, int p0) {
    ((QAction*)_obj)->setSeparator(p0 != 0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Actions
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void qteQAction_trigger(void* _obj) {
    ((QAction*)_obj)->trigger();
}

extern "C" QACTION_API void qteQAction_toggle(void* _obj) {
    ((QAction*)_obj)->toggle();
}

extern "C" QACTION_API void qteQAction_hover(void* _obj) {
    ((QAction*)_obj)->hover();
}

// ─────────────────────────────────────────────────────────────────────────────
// Tooltip / StatusTip / WhatsThis
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_toolTip(void* _obj) {
    return new QString(((QAction*)_obj)->toolTip());
}

extern "C" QACTION_API void qteQAction_setToolTip(void* _obj,
                                                   void* p0) {
    ((QAction*)_obj)->setToolTip(*(QString*)p0);
}

extern "C" QACTION_API void* qteQAction_statusTip(void* _obj) {
    return new QString(((QAction*)_obj)->statusTip());
}

extern "C" QACTION_API void qteQAction_setStatusTip(void* _obj,
                                                     void* p0) {
    ((QAction*)_obj)->setStatusTip(*(QString*)p0);
}

extern "C" QACTION_API void* qteQAction_whatsThis(void* _obj) {
    return new QString(((QAction*)_obj)->whatsThis());
}

extern "C" QACTION_API void qteQAction_setWhatsThis(void* _obj,
                                                     void* p0) {
    ((QAction*)_obj)->setWhatsThis(*(QString*)p0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Shortcut
// Represented as int bitmask: Qt::Key | Qt::Modifier
// e.g. Qt::CTRL | Qt::Key_S == 0x04000053
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_shortcut(void* _obj) {
    QKeySequence ks = ((QAction*)_obj)->shortcut();
    return ks.isEmpty() ? 0 : ks[0];
}

extern "C" QACTION_API void qteQAction_setShortcut(void* _obj, int key) {
    ((QAction*)_obj)->setShortcut(QKeySequence(key));
}

// Установить шорткат через строку (Qt::PortableText формат, напр. "Shift+F3")
extern "C" QACTION_API void qteQAction_setShortcutStr(void* _obj, const wchar_t* str, int len) {
    ((QAction*)_obj)->setShortcut(
        QKeySequence(dWstringToQString(str, len), QKeySequence::PortableText));
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon text
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_iconText(void* _obj) {
    return new QString(((QAction*)_obj)->iconText());
}

extern "C" QACTION_API void qteQAction_setIconText(void* _obj,
                                                    void* p0) {
    ((QAction*)_obj)->setIconText(*(QString*)p0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu role
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_menuRole(void* _obj) {
    return (int)((QAction*)_obj)->menuRole();
}

extern "C" QACTION_API void qteQAction_setMenuRole(void* _obj, int p0) {
    ((QAction*)_obj)->setMenuRole((QAction::MenuRole)p0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QACTION_API void qteQAction_setIcon(void* _obj, void* icon) {
    ((QAction*)_obj)->setIcon(*(const QIcon*)icon);
}

extern "C" QACTION_API void* qteQAction_icon(void* _obj) {
    return new QIcon(((QAction*)_obj)->icon());
}

// ── Constructor with icon ─────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_create_icon(void* icon, void* text, void* parent) {
    return qte_createTracked(new QAction(*(const QIcon*)icon, *(const QString*)text, (QObject*)parent));
}

// ── Font ──────────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_font(void* _obj) {
    return new QFont(((QAction*)_obj)->font());
}

extern "C" QACTION_API void qteQAction_setFont(void* _obj, void* font) {
    ((QAction*)_obj)->setFont(*(const QFont*)font);
}

// ── Icon visible in menu ──────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_iconVisibleInMenu(void* _obj) {
    return ((QAction*)_obj)->isIconVisibleInMenu() ? 1 : 0;
}

extern "C" QACTION_API void qteQAction_setIconVisibleInMenu(void* _obj, int p0) {
    ((QAction*)_obj)->setIconVisibleInMenu(p0 != 0);
}

// ── Shortcut context ──────────────────────────────────────────────────

extern "C" QACTION_API int qteQAction_shortcutContext(void* _obj) {
    return (int)((QAction*)_obj)->shortcutContext();
}

extern "C" QACTION_API void qteQAction_setShortcutContext(void* _obj, int p0) {
    ((QAction*)_obj)->setShortcutContext((Qt::ShortcutContext)p0);
}

// ── Sub-menu ──────────────────────────────────────────────────────────

extern "C" QACTION_API void* qteQAction_menu(void* _obj) {
    return (void*)((QAction*)_obj)->menu();
}

extern "C" QACTION_API void qteQAction_setMenu(void* _obj, void* menu) {
    ((QAction*)_obj)->setMenu((QMenu*)menu);
}
