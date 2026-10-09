/**
 * qte56_tvision.h — Thin C wrapper over magiblot/tvision (Turbo Vision 2.0)
 *
 * Provides extern "C" functions for creating TV applications from D.
 * The key challenge: TApplication/TDialog require virtual method overrides
 * (handleEvent, initMenuBar, initStatusLine). We solve this with callbacks.
 */

#ifndef QTE56_TVISION_H
#define QTE56_TVISION_H

#ifdef _WIN32
  #define TV_EXPORT extern "C" __declspec(dllexport)
#else
  #define TV_EXPORT extern "C" __attribute__((visibility("default")))
#endif

// ═══════════════════════════════════════════════════════════════════
//  Callback types (D → C++)
// ═══════════════════════════════════════════════════════════════════

// Menu bar builder: receives (TRect* r) → returns TMenuBar*
typedef void* (*TvMenuBarInitFn)(void* rect);
// Status line builder: receives (TRect* r) → returns TStatusLine*
typedef void* (*TvStatusLineInitFn)(void* rect);
// Event handler: receives (what, command) — simplified event info
// Returns 1 if handled, 0 if not
typedef int (*TvEventHandlerFn)(int what, int command);
// Idle handler
typedef void (*TvIdleFn)(void);

// ═══════════════════════════════════════════════════════════════════
//  TApplication
// ═══════════════════════════════════════════════════════════════════

// Create app with callbacks for menu/status/events
TV_EXPORT void* tvApp_create(
    TvMenuBarInitFn    menuBarInit,
    TvStatusLineInitFn statusLineInit,
    TvEventHandlerFn   eventHandler
);
TV_EXPORT void  tvApp_run(void* app);
TV_EXPORT void  tvApp_delete(void* app);
TV_EXPORT void  tvApp_setIdle(void* app, TvIdleFn idleFn);

// ═══════════════════════════════════════════════════════════════════
//  TMenuBar / TMenu helpers
// ═══════════════════════════════════════════════════════════════════

// Build a menu bar from simple description arrays.
// items: array of { label, command, hotkey, isSubmenu, isSeparator }
TV_EXPORT void* tvMenuBar_create(void* rect, const char* json);

// Simpler API: structured builder
TV_EXPORT void* tvMenu_beginBar(void* rect);
TV_EXPORT void  tvMenu_addSubmenu(void* bar, const char* title, int hotkey);
TV_EXPORT void  tvMenu_addItem(void* bar, const char* title, int command, int hotkey, const char* shortcut);
TV_EXPORT void  tvMenu_addSeparator(void* bar);
TV_EXPORT void* tvMenu_endBar(void* bar);

// ═══════════════════════════════════════════════════════════════════
//  TStatusLine helpers
// ═══════════════════════════════════════════════════════════════════

TV_EXPORT void* tvStatusLine_create(void* rect,
    const char** labels, const int* hotkeys, const int* commands, int count);

// ═══════════════════════════════════════════════════════════════════
//  TDialog
// ═══════════════════════════════════════════════════════════════════

TV_EXPORT void* tvDialog_create(int x1, int y1, int x2, int y2, const char* title);
TV_EXPORT void  tvDialog_delete(void* dlg);
TV_EXPORT int   tvDialog_exec(void* app, void* dlg); // execView, returns result command

// ═══════════════════════════════════════════════════════════════════
//  Widgets (placed into TDialog/TWindow via insert)
// ═══════════════════════════════════════════════════════════════════

TV_EXPORT void  tvView_insert(void* group, void* view);

// TStaticText
TV_EXPORT void* tvStaticText_create(int x1, int y1, int x2, int y2, const char* text);

// TButton
TV_EXPORT void* tvButton_create(int x1, int y1, int x2, int y2,
    const char* title, int command, int flags);

// TInputLine
TV_EXPORT void* tvInputLine_create(int x1, int y1, int x2, int y2, int maxLen);
TV_EXPORT void  tvInputLine_getText(void* input, char* buf, int bufLen);
TV_EXPORT void  tvInputLine_setText(void* input, const char* text);

// TCheckBoxes (single checkbox)
TV_EXPORT void* tvCheckBox_create(int x1, int y1, int x2, int y2, const char* label);
TV_EXPORT int   tvCheckBox_getValue(void* cb);
TV_EXPORT void  tvCheckBox_setValue(void* cb, int val);

// TRadioButtons
TV_EXPORT void* tvRadioButtons_create(int x1, int y1, int x2, int y2,
    const char** labels, int count);
TV_EXPORT int   tvRadioButtons_getValue(void* rb);
TV_EXPORT void  tvRadioButtons_setValue(void* rb, int val);

// TLabel (attached to another view)
TV_EXPORT void* tvLabel_create(int x1, int y1, int x2, int y2,
    const char* text, void* linkedView);

// ═══════════════════════════════════════════════════════════════════
//  TWindow
// ═══════════════════════════════════════════════════════════════════

TV_EXPORT void* tvWindow_create(int x1, int y1, int x2, int y2,
    const char* title, int number);
TV_EXPORT void  tvDesktop_insert(void* app, void* win);

// ═══════════════════════════════════════════════════════════════════
//  Constants
// ═══════════════════════════════════════════════════════════════════

TV_EXPORT int tvConst_cmQuit(void);
TV_EXPORT int tvConst_cmCancel(void);
TV_EXPORT int tvConst_cmOK(void);
TV_EXPORT int tvConst_bfDefault(void);
TV_EXPORT int tvConst_bfNormal(void);

// Event types
TV_EXPORT int tvConst_evCommand(void);
TV_EXPORT int tvConst_evBroadcast(void);

// ═══════════════════════════════════════════════════════════════════
//  MessageBox (high-level, built-in TV dialog)
// ═══════════════════════════════════════════════════════════════════
//
// options = message class | button flags:
//   Classes : mfWarning(0), mfError(1), mfInformation(2), mfConfirmation(3)
//   Buttons : mfYesButton(0x100), mfNoButton(0x200),
//             mfOKButton(0x400),  mfCancelButton(0x800)
//   Combos  : mfYesNoCancel(0xE00), mfOKCancel(0xC00)
//
// Returns the command that closed the dialog:
//   cmOK(10), cmCancel(11), cmYes(12), cmNo(13)
//
TV_EXPORT int tvMessageBox(const char* msg, int options);

#endif // QTE56_TVISION_H
