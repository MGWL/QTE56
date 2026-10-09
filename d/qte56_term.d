/**
 * qte56_term.d — кросс-платформенный модуль для работы с терминалом.
 *
 * Backend: arsd.terminal (Win7/8/10/11/Linux — всё из коробки)
 *
 * Возможности:
 *   • Позиционирование курсора (moveTo, moveBy, save/restore, hide/show)
 *   • Цвет текста и фона (16 / 256 / TrueColor)
 *   • Атрибуты текста (bold, dim, italic, underline, reverse, strike)
 *   • Очистка экрана / строки / области
 *   • Прокрутка (scrollUp, scrollDown, scrollRegion)
 *   • Символы разграфки (Single / Double / Rounded / Heavy)
 *   • Рисование рамок и линий (drawBox, drawHLine, drawVLine)
 *   • TermTable — форматированные таблицы с разграфкой
 *   • readAt — чтение символов с экрана (Windows)
 *   • Alternate screen buffer (Win10+/Linux)
 *
 * Платформы: Win7, Win8, Win10, Win11, Linux/Mac
 * Зависимости: arsd.terminal (один файл, d/arsd/terminal.d)
 */
module qte56_term;

import arsd.terminal;

// ═══════════════════════════════════════════════════════════════════
//  Win32 API для readAt (ReadConsoleOutputCharacterW)
// ═══════════════════════════════════════════════════════════════════

version(Windows) {
    private {
        import core.sys.windows.windows :
            HANDLE, DWORD, BOOL, COORD,
            GetStdHandle, STD_OUTPUT_HANDLE;

        extern(Windows) nothrow @nogc
        BOOL ReadConsoleOutputCharacterW(
            HANDLE hConsoleOutput,
            wchar* lpCharacter,
            DWORD nLength,
            COORD dwReadCoord,
            DWORD* lpNumberOfCharsRead
        ) @system;
    }
}

// ═══════════════════════════════════════════════════════════════════
//  Enums
// ═══════════════════════════════════════════════════════════════════

/// Стандартные цвета терминала (16 цветов).
/// Значения — ANSI порядок (0–15), маппинг в arsd.terminal внутри.
enum Color : int {
    Black        = 0,  Red        = 1,  Green      = 2,  Yellow  = 3,
    Blue         = 4,  Magenta    = 5,  Cyan       = 6,  White   = 7,
    BrightBlack  = 8,  BrightRed  = 9,  BrightGreen = 10, BrightYellow = 11,
    BrightBlue   = 12, BrightMagenta = 13, BrightCyan = 14, BrightWhite = 15,
    Default      = -1,
}

/// Атрибуты текста (комбинируются через |).
enum Attr : uint {
    None      = 0,
    Bold      = 1 << 0,
    Dim       = 1 << 1,
    Italic    = 1 << 2,
    Underline = 1 << 3,
    Blink     = 1 << 4,
    Reverse   = 1 << 5,
    Strike    = 1 << 6,
}

/// Стиль линий для рамок и таблиц.
enum BoxStyle : int { Single = 0, Double = 1, Rounded = 2, Heavy = 3 }

/// Выравнивание текста в ячейке таблицы.
enum Align : int { Left = 0, Center = 1, Right = 2 }

// ═══════════════════════════════════════════════════════════════════
//  BoxChars — набор символов разграфки
// ═══════════════════════════════════════════════════════════════════

struct BoxChars {
    dchar hLine, vLine;
    dchar topLeft, topRight, bottomLeft, bottomRight;
    dchar teeLeft, teeRight, teeDown, teeUp;
    dchar cross;
}

private immutable BoxChars[4] _boxSets = [
    BoxChars('─','│', '┌','┐','└','┘', '├','┤','┬','┴', '┼'),  // Single
    BoxChars('═','║', '╔','╗','╚','╝', '╠','╣','╦','╩', '╬'),  // Double
    BoxChars('─','│', '╭','╮','╰','╯', '├','┤','┬','┴', '┼'),  // Rounded
    BoxChars('━','┃', '┏','┓','┗','┛', '┣','┫','┳','┻', '╋'),  // Heavy
];

/// Получить набор символов для заданного стиля.
BoxChars boxChars(BoxStyle style) {
    return _boxSets[cast(int)style];
}

// ═══════════════════════════════════════════════════════════════════
//  Cell — одна ячейка экрана
// ═══════════════════════════════════════════════════════════════════

struct Cell {
    dchar ch   = ' ';
    Color fg   = Color.Default;
    Color bg   = Color.Default;
    Attr  attr = Attr.None;
}

// ═══════════════════════════════════════════════════════════════════
//  Private: arsd.terminal backend + Color mapping
// ═══════════════════════════════════════════════════════════════════

private {
    arsd.terminal.Terminal* _term;
    bool _inited;

    // Маппинг наших Color (ANSI order) → arsd.terminal Color (BGR order)
    // arsd: black=0, red=4, green=2, yellow=6, blue=1, magenta=5, cyan=3, white=7
    // Bright добавляется через | arsd.terminal.Bright (0x08)
    immutable int[16] _colorMap = [
        arsd.terminal.Color.black,                                     // 0  Black
        arsd.terminal.Color.red,                                       // 1  Red
        arsd.terminal.Color.green,                                     // 2  Green
        arsd.terminal.Color.yellow,                                    // 3  Yellow
        arsd.terminal.Color.blue,                                      // 4  Blue
        arsd.terminal.Color.magenta,                                   // 5  Magenta
        arsd.terminal.Color.cyan,                                      // 6  Cyan
        arsd.terminal.Color.white,                                     // 7  White
        arsd.terminal.Color.black   | arsd.terminal.Bright,            // 8  BrightBlack
        arsd.terminal.Color.red     | arsd.terminal.Bright,            // 9  BrightRed
        arsd.terminal.Color.green   | arsd.terminal.Bright,            // 10 BrightGreen
        arsd.terminal.Color.yellow  | arsd.terminal.Bright,            // 11 BrightYellow
        arsd.terminal.Color.blue    | arsd.terminal.Bright,            // 12 BrightBlue
        arsd.terminal.Color.magenta | arsd.terminal.Bright,            // 13 BrightMagenta
        arsd.terminal.Color.cyan    | arsd.terminal.Bright,            // 14 BrightCyan
        arsd.terminal.Color.white   | arsd.terminal.Bright,            // 15 BrightWhite
    ];

    int _toArsdColor(Color c) {
        if (c == Color.Default) return arsd.terminal.Color.DEFAULT;
        if (c >= 0 && c <= 15) return _colorMap[c];
        return arsd.terminal.Color.DEFAULT;
    }

    // Текущие цвета (для поддержки раздельных setFg/setBg)
    Color _curFg = Color.Default;
    Color _curBg = Color.Default;

    void _applyColor() {
        if (_term is null) return;
        _term.color(_toArsdColor(_curFg), _toArsdColor(_curBg));
    }

    // ── String helpers (platform-independent) ──

    size_t _displayWidth(string s) {
        size_t w = 0;
        foreach (dchar _; s) w++;
        return w;
    }

    string _spaces(int n) {
        if (n <= 0) return "";
        auto s = new char[n];
        s[] = ' ';
        return cast(immutable)s;
    }

    string _repeatDchar(dchar ch, int n) {
        if (n <= 0) return "";
        import std.utf : encode;
        char[4] enc;
        auto elen = encode(enc, ch);
        auto s = new char[elen * n];
        for (int i = 0; i < n; i++)
            s[i * elen .. (i + 1) * elen] = enc[0 .. elen];
        return cast(immutable)s;
    }

    string _fitWidth(string s, int width, Align al = Align.Left) {
        auto dw = cast(int)_displayWidth(s);
        if (dw > width) {
            if (width <= 1) return width == 1 ? "…" : "";
            import std.array : appender;
            auto app = appender!string;
            int w = 0;
            foreach (dchar c; s) {
                if (w >= width - 1) break;
                import std.utf : encode;
                char[4] buf;
                auto n = encode(buf, c);
                app ~= buf[0 .. n];
                w++;
            }
            app ~= "…";
            return app[];
        }
        int pad = width - dw;
        final switch (al) {
            case Align.Left:   return s ~ _spaces(pad);
            case Align.Right:  return _spaces(pad) ~ s;
            case Align.Center:
                int left = pad / 2;
                return _spaces(left) ~ s ~ _spaces(pad - left);
        }
    }
}

// ═══════════════════════════════════════════════════════════════════
//  Term — основной интерфейс (static namespace)
// ═══════════════════════════════════════════════════════════════════

struct Term {
static:
    /// Доступ к backend-терминалу (для продвинутого использования).
    arsd.terminal.Terminal* backend() { return _term; }

    // ── Инициализация / завершение ───────────────────────────

    void setup() {
        if (_inited) return;
        try {
            _term = new arsd.terminal.Terminal(ConsoleOutputType.linear);
        } catch (Exception) {
            _term = null;  // не удалось — stdout перенаправлен или нет консоли
        }
        _inited = true;
    }

    /// true если backend-терминал доступен.
    bool isAvailable() { return _term !is null; }

    void cleanup() {
        if (!_inited) return;
        resetStyle();
        showCursor();
        flush();
        if (_term !is null) {
            _term._suppressDestruction = true;
            destroy(*_term);
            _term = null;
        }
        _inited = false;
    }

    // ── Размер терминала ─────────────────────────────────────

    int width() {
        if (_term is null) return 0;
        return _term.width;
    }

    int height() {
        if (_term is null) return 0;
        return _term.height;
    }

    // ── Курсор ──────────────────────────────────────────────

    void moveTo(int col, int row) {
        if (_term is null) return;
        _term.moveTo(col, row, ForceOption.alwaysSend);
    }

    void moveBy(int dcol, int drow) {
        if (_term is null) return;
        // arsd.terminal не имеет moveBy — реализуем через writeStringRaw
        if (drow < 0) _term.writeStringRaw(_csiStr(-drow, 'A'));
        if (drow > 0) _term.writeStringRaw(_csiStr( drow, 'B'));
        if (dcol > 0) _term.writeStringRaw(_csiStr( dcol, 'C'));
        if (dcol < 0) _term.writeStringRaw(_csiStr(-dcol, 'D'));
    }

    void saveCursor() {
        if (_term is null) return;
        _term.writeStringRaw("\0337");
    }

    void restoreCursor() {
        if (_term is null) return;
        _term.writeStringRaw("\0338");
    }

    void hideCursor() {
        if (_term is null) return;
        _term.hideCursor();
    }

    void showCursor() {
        if (_term is null) return;
        _term.showCursor();
    }

    // ── Цвета ───────────────────────────────────────────────

    void setFg(Color c) {
        _curFg = c;
        _applyColor();
    }

    void setBg(Color c) {
        _curBg = c;
        _applyColor();
    }

    void setFg256(int c) {
        if (c < 16) { setFg(cast(Color)c); return; }
        if (_term is null) return;
        import std.format : format;
        _term.writeStringRaw(format("\033[38;5;%dm", c));
    }

    void setBg256(int c) {
        if (c < 16) { setBg(cast(Color)c); return; }
        if (_term is null) return;
        import std.format : format;
        _term.writeStringRaw(format("\033[48;5;%dm", c));
    }

    void setFgRGB(ubyte r, ubyte g, ubyte b) {
        if (_term is null) return;
        _term.setTrueColor(arsd.terminal.RGB(r, g, b), arsd.terminal.RGB(0, 0, 0));
    }

    void setBgRGB(ubyte r, ubyte g, ubyte b) {
        if (_term is null) return;
        _term.setTrueColor(arsd.terminal.RGB(0, 0, 0), arsd.terminal.RGB(r, g, b));
    }

    void style(Color fg, Color bg = Color.Default, Attr attr = Attr.None) {
        setAttr(attr);
        setFg(fg);
        setBg(bg);
    }

    // ── Атрибуты ────────────────────────────────────────────

    void setAttr(Attr a) {
        if (a == Attr.None || _term is null) return;
        // arsd.terminal не имеет прямого API для атрибутов — отправим ESC напрямую
        if (a & Attr.Bold)      _term.writeStringRaw("\033[1m");
        if (a & Attr.Dim)       _term.writeStringRaw("\033[2m");
        if (a & Attr.Italic)    _term.writeStringRaw("\033[3m");
        if (a & Attr.Underline) _term.writeStringRaw("\033[4m");
        if (a & Attr.Blink)     _term.writeStringRaw("\033[5m");
        if (a & Attr.Reverse)   _term.writeStringRaw("\033[7m");
        if (a & Attr.Strike)    _term.writeStringRaw("\033[9m");
    }

    void resetStyle() {
        _curFg = Color.Default;
        _curBg = Color.Default;
        if (_term is null) return;
        _term.color(_toArsdColor(Color.Default), _toArsdColor(Color.Default));
    }

    // ── Очистка ─────────────────────────────────────────────

    void clear() {
        if (_term is null) return;
        _term.clear();
    }

    void clearLine() {
        if (_term is null) return;
        _term.writeStringRaw("\033[2K");
    }

    void clearToEOL() {
        if (_term is null) return;
        _term.writeStringRaw("\033[K");
    }

    void clearToEOS() {
        if (_term is null) return;
        _term.writeStringRaw("\033[J");
    }

    void clearRegion(int x, int y, int w, int h) {
        string blank = _spaces(w);
        foreach (row; y .. y + h) {
            moveTo(x, row);
            put(blank);
        }
    }

    // ── Прокрутка ───────────────────────────────────────────

    void setScrollRegion(int top, int bottom) {
        if (_term is null) return;
        import std.format : format;
        _term.writeStringRaw(format("\033[%d;%dr", top + 1, bottom + 1));
    }

    void resetScrollRegion() {
        if (_term is null) return;
        _term.writeStringRaw("\033[r");
    }

    void scrollUp(int n = 1) {
        if (_term is null) return;
        import std.format : format;
        _term.writeStringRaw(format("\033[%dS", n));
    }

    void scrollDown(int n = 1) {
        if (_term is null) return;
        import std.format : format;
        _term.writeStringRaw(format("\033[%dT", n));
    }

    // ── Alternate screen ────────────────────────────────────

    void enterAltScreen() {
        if (_term is null) return;
        _term.writeStringRaw("\033[?1049h");
    }

    void leaveAltScreen() {
        if (_term is null) return;
        _term.writeStringRaw("\033[?1049l");
    }

    // ── Вывод текста ────────────────────────────────────────

    void put(dchar ch) {
        if (_term is null) return;
        char[4] tmp;
        import std.utf : encode;
        auto n = encode(tmp, ch);
        _term.write(cast(string)tmp[0 .. n].idup);
    }

    void put(string text) {
        if (_term is null) return;
        _term.write(text);
    }

    void putAt(int col, int row, string text) {
        moveTo(col, row);
        put(text);
    }

    void putStyled(string text, Color fg, Color bg = Color.Default, Attr attr = Attr.None) {
        style(fg, bg, attr);
        put(text);
        resetStyle();
    }

    void putStyledAt(int col, int row, string text, Color fg,
                     Color bg = Color.Default, Attr attr = Attr.None) {
        moveTo(col, row);
        putStyled(text, fg, bg, attr);
    }

    void flush() {
        if (_term is null) return;
        _term.flush();
    }

    // ── Чтение с экрана (readAt) ────────────────────────────

    /// Прочитать len символов с экрана начиная с позиции (col, row).
    /// Работает на Windows (Console API). На Linux возвращает "".
    string readAt(int col, int row, int len) {
        if (len <= 0) return "";
        flush(); // убедиться что всё записано
        version(Windows) {
            auto buf = new wchar[len];
            DWORD read;
            auto hOut = GetStdHandle(STD_OUTPUT_HANDLE);
            auto ok = ReadConsoleOutputCharacterW(
                hOut, buf.ptr, cast(DWORD)len,
                COORD(cast(short)col, cast(short)row), &read);
            if (ok == 0 || read == 0) return "";
            // wchar[] → string (UTF-8)
            import std.utf : toUTF8;
            return toUTF8(buf[0 .. read]);
        } else {
            return "";
        }
    }

    // ── Рисование рамок ─────────────────────────────────────

    void drawHLine(int x, int y, int len, BoxStyle bs = BoxStyle.Single) {
        auto b = boxChars(bs);
        moveTo(x, y);
        foreach (_; 0 .. len) put(b.hLine);
    }

    void drawVLine(int x, int y, int len, BoxStyle bs = BoxStyle.Single) {
        auto b = boxChars(bs);
        foreach (i; 0 .. len) {
            moveTo(x, y + i);
            put(b.vLine);
        }
    }

    void drawBox(int x, int y, int w, int h, BoxStyle bs = BoxStyle.Single) {
        if (w < 2 || h < 2) return;
        auto b = boxChars(bs);

        moveTo(x, y);
        put(b.topLeft);
        foreach (_; 0 .. w - 2) put(b.hLine);
        put(b.topRight);

        foreach (i; 1 .. h - 1) {
            moveTo(x, y + i);     put(b.vLine);
            moveTo(x + w - 1, y + i); put(b.vLine);
        }

        moveTo(x, y + h - 1);
        put(b.bottomLeft);
        foreach (_; 0 .. w - 2) put(b.hLine);
        put(b.bottomRight);
    }

    void drawHSep(int x, int y, int[] colWidths, BoxStyle bs = BoxStyle.Single) {
        auto b = boxChars(bs);
        moveTo(x, y);
        put(b.teeLeft);
        foreach (i, cw; colWidths) {
            foreach (_; 0 .. cw + 2) put(b.hLine);
            put(i + 1 < colWidths.length ? b.cross : b.teeRight);
        }
    }

    // ── Private helper ──────────────────────────────────────

    private string _csiStr(int n, char cmd) {
        import std.format : format;
        return format("\033[%d%s", n, cmd);
    }
}

// ═══════════════════════════════════════════════════════════════════
//  TermTable — форматированная таблица с разграфкой
// ═══════════════════════════════════════════════════════════════════

struct TermTable {
    int[]      colWidths;
    Align[]    colAligns;
    BoxStyle   style;
    string[]   headers;
    string[][] rows;

    this(int[] colWidths, BoxStyle style = BoxStyle.Single) {
        this.colWidths = colWidths.dup;
        this.style = style;
        this.colAligns.length = colWidths.length;
        this.colAligns[] = Align.Left;
    }

    void setHeader(string[] titles) {
        headers = titles.dup;
    }

    void setAligns(Align[] aligns) {
        colAligns = aligns.dup;
    }

    void addRow(string[] cells) {
        rows ~= cells.dup;
    }

    string toString() const {
        auto b = boxChars(style);
        string[] lines;

        lines ~= _buildBorder(b.topLeft, b.hLine, b.teeDown, b.topRight);

        if (headers.length > 0) {
            lines ~= _buildDataRow(headers, true);
            lines ~= _buildBorder(b.teeLeft, b.hLine, b.cross, b.teeRight);
        }

        foreach (row; rows)
            lines ~= _buildDataRow(row, false);

        lines ~= _buildBorder(b.bottomLeft, b.hLine, b.teeUp, b.bottomRight);

        import std.array : join;
        return lines.join("\n");
    }

    void render(int x, int y) const {
        string text = toString();
        int row = y;
        size_t start = 0;
        foreach (i, ch; text) {
            if (ch == '\n') {
                Term.putAt(x, row, text[start .. i]);
                row++;
                start = i + 1;
            }
        }
        if (start < text.length)
            Term.putAt(x, row, text[start .. $]);
    }

    // ── Private helpers ─────────────────────────────────────

    private string _buildBorder(dchar left, dchar hLine, dchar mid, dchar right) const {
        string s;
        s ~= _dcharToStr(left);
        foreach (i, cw; colWidths) {
            s ~= _repeatDchar(hLine, cw + 2);
            s ~= _dcharToStr(i + 1 < colWidths.length ? mid : right);
        }
        return s;
    }

    private string _buildDataRow(const string[] cells, bool centerAll) const {
        auto b = boxChars(style);
        string s;
        s ~= _dcharToStr(b.vLine);
        foreach (i, cw; colWidths) {
            string cell = (i < cells.length) ? cells[i] : "";
            Align al = centerAll ? Align.Center :
                        (i < colAligns.length ? colAligns[i] : Align.Left);
            s ~= " " ~ _fitWidth(cell, cw, al) ~ " ";
            s ~= _dcharToStr(b.vLine);
        }
        return s;
    }

    private static string _dcharToStr(dchar ch) {
        char[4] tmp;
        import std.utf : encode;
        auto n = encode(tmp, ch);
        return tmp[0 .. n].idup;
    }
}
