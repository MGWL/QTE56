#pragma once

#ifdef _WIN32
  #ifdef QTE56_QACTION_BUILD
    #define QACTION_API __declspec(dllexport)
  #else
    #define QACTION_API __declspec(dllimport)
  #endif
#else
  #define QACTION_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QACTION_API void* qteQAction_create(void* parent);
QACTION_API void  qteQAction_delete(void* _obj);
QACTION_API void* qteQAction_create_text(void* text, void* parent);

// ── Text ─────────────────────────────────────────────────────────────────
QACTION_API void* qteQAction_text(void* _obj);
QACTION_API void  qteQAction_setText(void* _obj, void* p0);

// ── Enable / visibility ───────────────────────────────────────────────────
QACTION_API int  qteQAction_isEnabled(void* _obj);
QACTION_API void qteQAction_setEnabled(void* _obj, int p0);
QACTION_API int  qteQAction_isVisible(void* _obj);
QACTION_API void qteQAction_setVisible(void* _obj, int p0);

// ── Check state ───────────────────────────────────────────────────────────
QACTION_API int  qteQAction_isChecked(void* _obj);
QACTION_API void qteQAction_setChecked(void* _obj, int p0);
QACTION_API int  qteQAction_isCheckable(void* _obj);
QACTION_API void qteQAction_setCheckable(void* _obj, int p0);

// ── Separator ─────────────────────────────────────────────────────────────
QACTION_API int  qteQAction_isSeparator(void* _obj);
QACTION_API void qteQAction_setSeparator(void* _obj, int p0);

// ── Actions ───────────────────────────────────────────────────────────────
QACTION_API void qteQAction_trigger(void* _obj);
QACTION_API void qteQAction_toggle(void* _obj);
QACTION_API void qteQAction_hover(void* _obj);

// ── Tooltip / StatusTip / WhatsThis ──────────────────────────────────────
QACTION_API void* qteQAction_toolTip(void* _obj);
QACTION_API void  qteQAction_setToolTip(void* _obj, void* p0);
QACTION_API void* qteQAction_statusTip(void* _obj);
QACTION_API void  qteQAction_setStatusTip(void* _obj, void* p0);
QACTION_API void* qteQAction_whatsThis(void* _obj);
QACTION_API void  qteQAction_setWhatsThis(void* _obj, void* p0);

// ── Shortcut ─────────────────────────────────────────────────────────────
// Shortcut represented as int (Qt::Key | Qt::Modifier bitmask).
// e.g. Qt::CTRL | Qt::Key_S == 0x04000053
QACTION_API int  qteQAction_shortcut(void* _obj);
QACTION_API void qteQAction_setShortcut(void* _obj, int key);
QACTION_API void qteQAction_setShortcutStr(void* _obj, const wchar_t* str, int len);

// ── Icon text ─────────────────────────────────────────────────────────────
QACTION_API void* qteQAction_iconText(void* _obj);
QACTION_API void  qteQAction_setIconText(void* _obj, void* p0);

// ── Menu role ─────────────────────────────────────────────────────────────
QACTION_API int  qteQAction_menuRole(void* _obj);
QACTION_API void qteQAction_setMenuRole(void* _obj, int p0);

// ── Icon ──────────────────────────────────────────────────────────────
QACTION_API void  qteQAction_setIcon(void* _obj, void* icon);
QACTION_API void* qteQAction_icon(void* _obj);

// ── Constructor with icon ─────────────────────────────────────────────
QACTION_API void* qteQAction_create_icon(void* icon, void* text, void* parent);

// ── Font ──────────────────────────────────────────────────────────────
QACTION_API void* qteQAction_font(void* _obj);
QACTION_API void  qteQAction_setFont(void* _obj, void* font);

// ── Icon visible in menu ──────────────────────────────────────────────
QACTION_API int  qteQAction_iconVisibleInMenu(void* _obj);
QACTION_API void qteQAction_setIconVisibleInMenu(void* _obj, int p0);

// ── Shortcut context ──────────────────────────────────────────────────
// Qt::ShortcutContext: WidgetShortcut=0, WidgetWithChildrenShortcut=3,
//                      WindowShortcut=1, ApplicationShortcut=2
QACTION_API int  qteQAction_shortcutContext(void* _obj);
QACTION_API void qteQAction_setShortcutContext(void* _obj, int p0);

// ── Sub-menu ──────────────────────────────────────────────────────────
QACTION_API void* qteQAction_menu(void* _obj);
QACTION_API void  qteQAction_setMenu(void* _obj, void* menu);

} // extern "C"
