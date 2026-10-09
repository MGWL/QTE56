/**
 * qte56_tvision.cpp — Thin C wrapper over magiblot/tvision (Turbo Vision 2.0)
 *
 * Architecture: subclass TApplication to forward virtual calls to D callbacks.
 */

#define Uses_TKeys
#define Uses_TApplication
#define Uses_TEvent
#define Uses_TRect
#define Uses_TDialog
#define Uses_TWindow
#define Uses_TDeskTop
#define Uses_TStaticText
#define Uses_TButton
#define Uses_TInputLine
#define Uses_TCheckBoxes
#define Uses_TRadioButtons
#define Uses_TLabel
#define Uses_TMenuBar
#define Uses_TSubMenu
#define Uses_TMenuItem
#define Uses_TStatusLine
#define Uses_TStatusItem
#define Uses_TStatusDef
#define Uses_TSItem
#define Uses_MsgBox
#include <tvision/tv.h>
#include <cstring>

#include "qte56_tvision.h"

// ═══════════════════════════════════════════════════════════════════
//  TvApp — subclass with callbacks
// ═══════════════════════════════════════════════════════════════════

static TvMenuBarInitFn    g_menuBarInit    = nullptr;
static TvStatusLineInitFn g_statusLineInit = nullptr;
static TvEventHandlerFn   g_eventHandler   = nullptr;
static TvIdleFn           g_idleFn         = nullptr;

class TvApp : public TApplication {
public:
    TvApp();

    virtual void handleEvent(TEvent& event) override;
    virtual void idle() override;

    static TMenuBar*    initMenuBar(TRect r);
    static TStatusLine* initStatusLine(TRect r);
};

TvApp::TvApp() :
    TProgInit(&TvApp::initStatusLine,
              &TvApp::initMenuBar,
              &TvApp::initDeskTop)
{
}

TMenuBar* TvApp::initMenuBar(TRect r) {
    if (g_menuBarInit) {
        return (TMenuBar*)g_menuBarInit((void*)&r);
    }
    // Default: empty menu bar
    r.b.y = r.a.y + 1;
    return new TMenuBar(r, (TMenu*)nullptr);
}

TStatusLine* TvApp::initStatusLine(TRect r) {
    if (g_statusLineInit) {
        return (TStatusLine*)g_statusLineInit((void*)&r);
    }
    // Default: Alt-X exit
    r.a.y = r.b.y - 1;
    return new TStatusLine(r,
        *new TStatusDef(0, 0xFFFF) +
            *new TStatusItem("~Alt-X~ Exit", kbAltX, cmQuit) +
            *new TStatusItem(0, kbF10, cmMenu)
    );
}

void TvApp::handleEvent(TEvent& event) {
    TApplication::handleEvent(event);
    if (g_eventHandler) {
        int cmd = 0;
        if (event.what == evCommand || event.what == evBroadcast)
            cmd = event.message.command;
        if (g_eventHandler(event.what, cmd))
            clearEvent(event);
    }
}

void TvApp::idle() {
    TApplication::idle();
    if (g_idleFn) g_idleFn();
}

// ═══════════════════════════════════════════════════════════════════
//  Menu builder state
// ═══════════════════════════════════════════════════════════════════

struct MenuBuilder {
    TRect rect;
    TSubMenu* currentSub;
    TSubMenu* firstSub;
    bool hasSub;
};

static MenuBuilder g_mb;

// ═══════════════════════════════════════════════════════════════════
//  API implementations
// ═══════════════════════════════════════════════════════════════════

// --- TApplication ---

TV_EXPORT void* tvApp_create(
    TvMenuBarInitFn    menuBarInit,
    TvStatusLineInitFn statusLineInit,
    TvEventHandlerFn   eventHandler)
{
    g_menuBarInit    = menuBarInit;
    g_statusLineInit = statusLineInit;
    g_eventHandler   = eventHandler;
    return new TvApp();
}

TV_EXPORT void tvApp_run(void* app) {
    ((TvApp*)app)->run();
}

TV_EXPORT void tvApp_delete(void* app) {
    delete (TvApp*)app;
}

TV_EXPORT void tvApp_setIdle(void* app, TvIdleFn idleFn) {
    g_idleFn = idleFn;
}

// --- Menu bar builder ---

TV_EXPORT void* tvMenu_beginBar(void* rect) {
    g_mb.rect = *(TRect*)rect;
    g_mb.rect.b.y = g_mb.rect.a.y + 1;
    g_mb.currentSub = nullptr;
    g_mb.firstSub   = nullptr;
    g_mb.hasSub     = false;
    return nullptr; // handle not needed, uses global state
}

TV_EXPORT void tvMenu_addSubmenu(void* /*bar*/, const char* title, int hotkey) {
    auto* sub = new TSubMenu(title, (ushort)hotkey);
    if (!g_mb.hasSub) {
        g_mb.firstSub = sub;
    } else if (g_mb.currentSub) {
        *g_mb.currentSub + *sub; // chain submenus
    }
    g_mb.currentSub = sub;
    g_mb.hasSub = true;
}

TV_EXPORT void tvMenu_addItem(void* /*bar*/, const char* title,
    int command, int hotkey, const char* shortcut)
{
    if (!g_mb.currentSub) return;
    const char* sc = (shortcut && shortcut[0]) ? shortcut : nullptr;
    *g_mb.currentSub + *new TMenuItem(title, (ushort)command, (ushort)hotkey,
                                       hcNoContext, sc);
}

TV_EXPORT void tvMenu_addSeparator(void* /*bar*/) {
    if (!g_mb.currentSub) return;
    *g_mb.currentSub + newLine();
}

TV_EXPORT void* tvMenu_endBar(void* /*bar*/) {
    if (!g_mb.firstSub) {
        return new TMenuBar(g_mb.rect, (TMenu*)nullptr);
    }
    return new TMenuBar(g_mb.rect, *g_mb.firstSub);
}

// --- TStatusLine ---

TV_EXPORT void* tvStatusLine_create(void* rect,
    const char** labels, const int* hotkeys, const int* commands, int count)
{
    TRect r = *(TRect*)rect;
    r.a.y = r.b.y - 1;

    TStatusDef* def = new TStatusDef(0, 0xFFFF);
    for (int i = 0; i < count; i++) {
        *def = *def + *new TStatusItem(labels[i], (ushort)hotkeys[i], (ushort)commands[i]);
    }
    // always add F10 → menu
    *def = *def + *new TStatusItem(0, kbF10, cmMenu);

    return new TStatusLine(r, *def);
}

// --- TDialog ---

TV_EXPORT void* tvDialog_create(int x1, int y1, int x2, int y2, const char* title) {
    return new TDialog(TRect(x1, y1, x2, y2), title);
}

TV_EXPORT void tvDialog_delete(void* dlg) {
    // Note: TV dialogs are typically destroyed with TObject::destroy()
    TObject::destroy((TDialog*)dlg);
}

TV_EXPORT int tvDialog_exec(void* app, void* dlg) {
    return (int)((TvApp*)app)->deskTop->execView((TDialog*)dlg);
}

// --- Widget insertion ---

TV_EXPORT void tvView_insert(void* group, void* view) {
    ((TGroup*)group)->insert((TView*)view);
}

// --- TStaticText ---

TV_EXPORT void* tvStaticText_create(int x1, int y1, int x2, int y2, const char* text) {
    return new TStaticText(TRect(x1, y1, x2, y2), text);
}

// --- TButton ---

TV_EXPORT void* tvButton_create(int x1, int y1, int x2, int y2,
    const char* title, int command, int flags)
{
    return new TButton(TRect(x1, y1, x2, y2), title, (ushort)command, (ushort)flags);
}

// --- TInputLine ---

TV_EXPORT void* tvInputLine_create(int x1, int y1, int x2, int y2, int maxLen) {
    return new TInputLine(TRect(x1, y1, x2, y2), maxLen);
}

TV_EXPORT void tvInputLine_getText(void* input, char* buf, int bufLen) {
    TInputLine* inp = (TInputLine*)input;
    // TInputLine stores data in 'data' member (char array)
    const char* src = inp->data;
    if (src) {
        int len = (int)strlen(src);
        if (len >= bufLen) len = bufLen - 1;
        memcpy(buf, src, len);
        buf[len] = 0;
    } else {
        buf[0] = 0;
    }
}

TV_EXPORT void tvInputLine_setText(void* input, const char* text) {
    TInputLine* inp = (TInputLine*)input;
    int len = (int)strlen(text);
    if (len > inp->maxLen) len = inp->maxLen;
    memcpy(inp->data, text, len);
    inp->data[len] = 0;
    inp->curPos = len;
    inp->selStart = 0;
    inp->selEnd = 0;
    inp->drawView();
}

// --- TCheckBoxes ---

TV_EXPORT void* tvCheckBox_create(int x1, int y1, int x2, int y2, const char* label) {
    return new TCheckBoxes(TRect(x1, y1, x2, y2),
        new TSItem(label, nullptr));
}

TV_EXPORT int tvCheckBox_getValue(void* cb) {
    ushort val = 0;
    ((TCheckBoxes*)cb)->getData(&val);
    return (int)val;
}

TV_EXPORT void tvCheckBox_setValue(void* cb, int val) {
    ushort v = (ushort)val;
    ((TCheckBoxes*)cb)->setData(&v);
}

// --- TRadioButtons ---

TV_EXPORT void* tvRadioButtons_create(int x1, int y1, int x2, int y2,
    const char** labels, int count)
{
    TSItem* items = nullptr;
    // Build list in reverse (TSItem is a linked list)
    for (int i = count - 1; i >= 0; i--) {
        items = new TSItem(labels[i], items);
    }
    return new TRadioButtons(TRect(x1, y1, x2, y2), items);
}

TV_EXPORT int tvRadioButtons_getValue(void* rb) {
    ushort val = 0;
    ((TRadioButtons*)rb)->getData(&val);
    return (int)val;
}

TV_EXPORT void tvRadioButtons_setValue(void* rb, int val) {
    ushort v = (ushort)val;
    ((TRadioButtons*)rb)->setData(&v);
}

// --- TLabel ---

TV_EXPORT void* tvLabel_create(int x1, int y1, int x2, int y2,
    const char* text, void* linkedView)
{
    return new TLabel(TRect(x1, y1, x2, y2), text, (TView*)linkedView);
}

// --- TWindow ---

TV_EXPORT void* tvWindow_create(int x1, int y1, int x2, int y2,
    const char* title, int number)
{
    return new TWindow(TRect(x1, y1, x2, y2), title, number);
}

TV_EXPORT void tvDesktop_insert(void* app, void* win) {
    ((TvApp*)app)->deskTop->insert((TView*)win);
}

// --- Constants ---

TV_EXPORT int tvConst_cmQuit(void)     { return cmQuit; }
TV_EXPORT int tvConst_cmCancel(void)   { return cmCancel; }
TV_EXPORT int tvConst_cmOK(void)       { return cmOK; }
TV_EXPORT int tvConst_bfDefault(void)  { return bfDefault; }
TV_EXPORT int tvConst_bfNormal(void)   { return bfNormal; }
TV_EXPORT int tvConst_evCommand(void)  { return evCommand; }
TV_EXPORT int tvConst_evBroadcast(void){ return evBroadcast; }

// --- MessageBox ---

TV_EXPORT int tvMessageBox(const char* msg, int options) {
    return (int) messageBox(msg, (ushort)options);
}
