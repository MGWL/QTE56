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
#define Uses_TSurfaceView
#define Uses_TDrawSurface
#include <tvision/tv.h>
#include <cstring>
#ifdef _WIN32
#include <windows.h>
#endif

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

// ═══════════════════════════════════════════════════════════════════
//  TermView — VT-100 terminal view
// ═══════════════════════════════════════════════════════════════════
//
// Minimal VT-100/ANSI stream parser over a TDrawSurface cell buffer.
// Input is UTF-8 (multibyte sequences are stored per-cell via
// TCellChar::moveMultiByteChar — this is how tvision keeps Unicode in
// TScreenCell). Supported:
//   printable chars, CR, LF (+scroll), BS, TAB(8), BEL (ignored),
//   CSI H/f (cup, 1-based), A/B/C/D (cursor moves),
//   CSI J (0=below, 1=above, 2=screen), CSI K (0=right, 1=left, 2=line),
//   CSI m (SGR: 0 reset, 1 bold, 4 underline, 7 reverse, 30-37 fg,
//   40-47 bg, 39/49 default, 90-97/100-107 bright),
//   ESC O <letter> (SS3) — consumed and ignored.
// Parser state (incomplete CSI/UTF-8) is kept between write calls.

class TermView : public TSurfaceView {
public:
    TermView(const TRect& bounds) : TSurfaceView(bounds, nullptr) {
        size_t w = bounds.b.x - bounds.a.x, h = bounds.b.y - bounds.a.y;
        TPoint sz; sz.x = (int)w; sz.y = (int)h;
        surf = new TDrawSurface(sz);
        surf->clear();
        surface = surf;
        cx = 0; cy = 0;
        defAttr = TColorAttr(0x07);   // BIOS: light gray on black
        curAttr = defAttr;
        state = ST_GROUND;
        nparams = 0; curParam = 0; hasParam = false;
        utf8len = 0; utf8expect = 0;
        cursorVis = true;
        keyFn = nullptr; keyUserData = nullptr;
        dirty = false;
        InitializeCriticalSection(&cs);
        fillSurface();
    }

    ~TermView() {
        DeleteCriticalSection(&cs);
        surface = nullptr;
        delete surf;
    }

    virtual void changeBounds(const TRect& bounds) override {
        TSurfaceView::changeBounds(bounds);
        EnterCriticalSection(&cs);
        surf->resize(size);
        clampCursor();
        fillSurface();
        dirty = true;
        LeaveCriticalSection(&cs);
    }

    virtual void draw() override {
        EnterCriticalSection(&cs);
        if (cursorVis && cy < surf->size.y && cx < surf->size.x) {
            // Temporarily draw cursor as a reversed cell, restore after.
            TScreenCell& cell = surf->at(cy, cx);
            TScreenCell saved = cell;
            setAttr(cell, reverseAttribute(getAttr(cell)));
            TSurfaceView::draw();
            cell = saved;
        } else {
            TSurfaceView::draw();
        }
        LeaveCriticalSection(&cs);
    }

    virtual void handleEvent(TEvent& ev) override {
        if (ev.what == evKeyDown && keyFn) {
            KeyDownEvent& kd = ev.keyDown;
            keyFn(keyUserData, (int)kd.keyCode, (int)kd.controlKeyState,
                  kd.text, (int)kd.textLength);
            clearEvent(ev);
            return;
        }
        TSurfaceView::handleEvent(ev);
    }

    void writeBytes(const char* data, int len) {
        EnterCriticalSection(&cs);
        for (int i = 0; i < len; i++) feed((uchar)data[i]);
        dirty = true;
        LeaveCriticalSection(&cs);
    }

    void clearScreen() {
        EnterCriticalSection(&cs);
        clearRegion(0, 0, surf->size.x, surf->size.y);
        cx = cy = 0;
        dirty = true;
        LeaveCriticalSection(&cs);
    }

    void setKeyHandler(TvTermKeyFn cb, void* userdata) {
        keyFn = cb; keyUserData = userdata;
    }

    void setCursorVisible(int v) { cursorVis = (v != 0); dirty = true; }

    bool flushDirty() {
        EnterCriticalSection(&cs);
        bool d = dirty; dirty = false;
        LeaveCriticalSection(&cs);
        if (d) { drawView(); return true; }
        return false;
    }

private:
    enum ParserState { ST_GROUND, ST_ESC, ST_CSI, ST_ESC_O };

    TDrawSurface* surf;
    int cx, cy;
    TColorAttr defAttr, curAttr;
    ParserState state;
    int params[8];
    int nparams;
    int curParam;
    bool hasParam;
    char utf8buf[4];
    int utf8len, utf8expect;
    bool cursorVis;
    bool dirty;
    TvTermKeyFn keyFn;
    void* keyUserData;
    CRITICAL_SECTION cs;

    // --- helpers ---

    void fillSurface() {
        // TDrawSurface::clear() zeroes cells (attr 0). Repaint with default
        // attr so the terminal area looks like a normal console.
        clearRegion(0, 0, surf->size.x, surf->size.y);
    }

    void clearRegion(int x1, int y1, int x2, int y2) {
        // [x1,x2) x [y1,y2), clipped
        if (x1 < 0) x1 = 0; if (y1 < 0) y1 = 0;
        if (x2 > surf->size.x) x2 = surf->size.x;
        if (y2 > surf->size.y) y2 = surf->size.y;
        TScreenCell blank;
        memset(&blank, 0, sizeof(blank));
        setCell(blank, ' ', curAttr);
        for (int y = y1; y < y2; y++)
            for (int x = x1; x < x2; x++)
                surf->at(y, x) = blank;
    }

    void clampCursor() {
        if (cx < 0) cx = 0; if (cx >= surf->size.x) cx = surf->size.x - 1;
        if (cy < 0) cy = 0; if (cy >= surf->size.y) cy = surf->size.y - 1;
    }

    void scrollUp(int lines) {
        int w = surf->size.x, h = surf->size.y;
        if (lines >= h) { fillSurface(); return; }
        memmove(&surf->at(0, 0), &surf->at(lines, 0),
                sizeof(TScreenCell) * w * (h - lines));
        clearRegion(0, h - lines, w, h);
    }

    void newLine() {
        cy++;
        if (cy >= surf->size.y) {
            scrollUp(1);
            cy = surf->size.y - 1;
        }
    }

    void putCharCell(const char* mbc, int len) {
        if (cx >= surf->size.x) { cx = 0; newLine(); }
        TScreenCell cell;
        memset(&cell, 0, sizeof(cell));
        if (len == 1)
            setChar(cell, mbc[0]);
        else
            cell._ch.moveMultiByteChar(TStringView(mbc, (size_t)len));
        setAttr(cell, curAttr);
        surf->at(cy, cx) = cell;
        cx++;
    }

    // --- parser ---

    void feed(uchar c) {
        // UTF-8 continuation accumulation (only in ground state)
        if (state == ST_GROUND && utf8expect > 0) {
            if ((c & 0xC0) == 0x80) {
                utf8buf[utf8len++] = (char)c;
                if (utf8len >= utf8expect) {
                    putCharCell(utf8buf, utf8len);
                    utf8expect = utf8len = 0;
                }
                return;
            }
            // broken sequence: flush as-is, reprocess byte
            utf8expect = utf8len = 0;
        }

        switch (state) {
        case ST_GROUND:
            if (c == 0x1B) { state = ST_ESC; return; }
            if (c == '\r') { cx = 0; return; }
            if (c == '\n') { newLine(); return; }
            if (c == '\b') { if (cx > 0) cx--; return; }
            if (c == '\t') {
                int next = ((cx / 8) + 1) * 8;
                while (cx < next && cx < surf->size.x) putCharCell(" ", 1);
                return;
            }
            if (c == 0x07) return;               // BEL: ignore
            if (c < 0x20 || c == 0x7F) return;   // other controls: ignore
            if (c < 0x80) { putCharCell((const char*)&c, 1); return; }
            // UTF-8 lead byte
            if ((c & 0xE0) == 0xC0)      utf8expect = 2;
            else if ((c & 0xF0) == 0xE0) utf8expect = 3;
            else if ((c & 0xF8) == 0xF0) utf8expect = 4;
            else return;                          // stray continuation: ignore
            utf8buf[0] = (char)c; utf8len = 1;
            return;

        case ST_ESC:
            if (c == '[') {
                state = ST_CSI;
                nparams = 0; curParam = 0; hasParam = false;
            } else if (c == 'O') {
                state = ST_ESC_O;
            } else {
                state = ST_GROUND;   // unknown ESC sequence: ignore
            }
            return;

        case ST_ESC_O:
            state = ST_GROUND;       // consume one letter (SS3)
            return;

        case ST_CSI:
            if (c >= '0' && c <= '9') {
                curParam = curParam * 10 + (c - '0');
                hasParam = true;
                return;
            }
            if (c == ';') {
                if (nparams < 8) params[nparams++] = curParam;
                curParam = 0; hasParam = true;
                return;
            }
            if (c >= 0x40 && c <= 0x7E) {
                if (nparams < 8) params[nparams++] = curParam;
                else if (nparams < 8) params[nparams++] = 0;
                doCsi((char)c);
                state = ST_GROUND;
                return;
            }
            // unexpected byte: abort sequence
            state = ST_GROUND;
            return;
        }
    }

    int param(int i, int def) {
        // Explicit 0 counts as "default" (VT-100 behaviour for cursor moves).
        if (i < nparams && params[i] > 0) return params[i];
        return def;
    }

    void doCsi(char final) {
        switch (final) {
        case 'H': case 'f': {       // cursor position, 1-based
            int row = param(0, 1), col = param(1, 1);
            cy = row - 1; cx = col - 1;
            clampCursor();
            break;
        }
        case 'A': cy -= param(0, 1); clampCursor(); break;
        case 'B': cy += param(0, 1); clampCursor(); break;
        case 'C': cx += param(0, 1); clampCursor(); break;
        case 'D': cx -= param(0, 1); clampCursor(); break;
        case 'J': {                 // erase in display
            int mode = (nparams > 0) ? params[0] : 0;
            if (mode == 2) {
                clearRegion(0, 0, surf->size.x, surf->size.y);
            } else if (mode == 1) {
                clearRegion(0, 0, surf->size.x, cy);
                clearRegion(0, cy, cx + 1, cy + 1);
            } else {
                clearRegion(cx, cy, surf->size.x, cy + 1);
                clearRegion(0, cy + 1, surf->size.x, surf->size.y);
            }
            break;
        }
        case 'K': {                 // erase in line
            int mode = (nparams > 0) ? params[0] : 0;
            if (mode == 2)      clearRegion(0, cy, surf->size.x, cy + 1);
            else if (mode == 1) clearRegion(0, cy, cx + 1, cy + 1);
            else                clearRegion(cx, cy, surf->size.x, cy + 1);
            break;
        }
        case 'm':                   // SGR
            if (nparams == 0 || (nparams == 1 && params[0] == 0 && !hasParam))
                { curAttr = defAttr; break; }
            if (nparams == 0) { curAttr = defAttr; break; }
            for (int i = 0; i < nparams; i++) applySgr(params[i]);
            break;
        default:
            break;                  // unsupported CSI: ignore
        }
    }

    static int ansiToBiosFg(int ansi) {
        // ANSI color order (red=1,green=2,blue=4) → BIOS (blue=1,green=2,red=4)
        return ((ansi & 1) << 2) | (ansi & 2) | ((ansi & 4) >> 2);
    }

    void applySgr(int p) {
        int bios = curAttr.toBIOS();
        int fg = bios & 0x0F, bg = bios & 0xF0;
        if (p == 0)       { curAttr = defAttr; return; }
        if (p == 1)       fg |= 0x08;                       // bold → bright fg
        else if (p == 4)  setStyle(curAttr, getStyle(curAttr) | slUnderline);
        else if (p == 7)  { curAttr = reverseAttribute(curAttr); return; }
        else if (p == 22) fg &= ~0x08;
        else if (p == 24) setStyle(curAttr, getStyle(curAttr) & ~slUnderline);
        else if (p == 27) { /* reverse off: reset */ curAttr = defAttr; return; }
        else if (p >= 30 && p <= 37)  fg = (fg & 0x08) | ansiToBiosFg(p - 30);
        else if (p == 39)             fg = defAttr.toBIOS() & 0x0F;
        else if (p >= 40 && p <= 47)  bg = ansiToBiosFg(p - 40) << 4;
        else if (p == 49)             bg = defAttr.toBIOS() & 0xF0;
        else if (p >= 90 && p <= 97)  fg = 0x08 | ansiToBiosFg(p - 90);
        else if (p >= 100 && p <= 107) bg = (0x08 | ansiToBiosFg(p - 100)) << 4;
        else return;
        curAttr = TColorAttr((uchar)(bg | fg));
        if (p == 4) setStyle(curAttr, getStyle(curAttr) | slUnderline);
    }
};

// --- TermView exports ---

TV_EXPORT void* tvTerm_create(int x1, int y1, int x2, int y2) {
    return new TermView(TRect(x1, y1, x2, y2));
}

TV_EXPORT void tvTerm_write(void* h, const char* bytes, int len) {
    if (h && bytes && len > 0) ((TermView*)h)->writeBytes(bytes, len);
}

TV_EXPORT void tvTerm_clear(void* h) {
    if (h) ((TermView*)h)->clearScreen();
}

TV_EXPORT void tvTerm_setKeyHandler(void* h, TvTermKeyFn cb, void* userdata) {
    if (h) ((TermView*)h)->setKeyHandler(cb, userdata);
}

TV_EXPORT void tvTerm_setCursorVisible(void* h, int vis) {
    if (h) ((TermView*)h)->setCursorVisible(vis);
}

TV_EXPORT void tvTerm_size(void* h, int* w, int* hgt) {
    if (!h) return;
    TermView* t = (TermView*)h;
    if (w)   *w   = t->size.x;
    if (hgt) *hgt = t->size.y;
}

TV_EXPORT void tvTerm_flush(void* h) {
    if (h) ((TermView*)h)->flushDirty();
}
