/**
 * qte56_enums.d — Qt namespace enums for QTE56.
 *
 * Mirrors the C++ Qt:: namespace via `class QtE`.
 * Ported from the original qte56.d with additions for arch_new.
 *
 * Usage:
 *   import qte56_enums;
 *   label.setAlignment(QtE.AlignmentFlag.AlignCenter);
 *   slider.setOrientation(QtE.Orientation.Horizontal);
 *   checkbox.setCheckState(QtE.CheckState.Checked);
 *   sep.setFrameStyle(QtE.FrameShape.HLine | QtE.FrameShadow.Sunken);
 */
module qte56_enums;

class QtE {

    // ── Alignment ─────────────────────────────────────────────────────────────
    enum AlignmentFlag {
        AlignNone    = 0,
        AlignLeft    = 0x0001,
        AlignLeading = AlignLeft,
        AlignRight   = 0x0002,
        AlignTrailing = AlignRight,
        AlignHCenter = 0x0004,
        AlignJustify = 0x0008,
        AlignAbsolute = 0x0010,
        AlignHorizontal_Mask = AlignLeft | AlignRight | AlignHCenter | AlignJustify | AlignAbsolute,

        AlignTop     = 0x0020,
        AlignBottom  = 0x0040,
        AlignVCenter = 0x0080,
        AlignBaseline = 0x0100,
        AlignVertical_Mask = AlignTop | AlignBottom | AlignVCenter | AlignBaseline,

        AlignCenter  = AlignVCenter | AlignHCenter,
    }

    // ── Orientation ───────────────────────────────────────────────────────────
    enum Orientation {
        Horizontal = 0x1,
        Vertical   = 0x2,
    }

    // ── CheckState ────────────────────────────────────────────────────────────
    enum CheckState {
        Unchecked        = 0,
        PartiallyChecked = 1,
        Checked          = 2,
    }

    // ── Focus ─────────────────────────────────────────────────────────────────
    enum FocusPolicy {
        NoFocus     = 0,
        TabFocus    = 0x1,
        ClickFocus  = 0x2,
        StrongFocus = TabFocus | ClickFocus | 0x8,
        WheelFocus  = StrongFocus | 0x4,
    }

    enum FocusReason {
        MouseFocusReason,
        TabFocusReason,
        BacktabFocusReason,
        ActiveWindowFocusReason,
        PopupFocusReason,
        ShortcutFocusReason,
        MenuBarFocusReason,
        OtherFocusReason,
        NoFocusReason,
    }

    // ── Window ────────────────────────────────────────────────────────────────
    enum WindowType {
        Widget     = 0x00000000,
        Window     = 0x00000001,
        Dialog     = 0x00000002 | Window,
        Sheet      = 0x00000004 | Window,
        Drawer     = Sheet | Dialog,
        Popup      = 0x00000008 | Window,
        Tool       = Popup | Dialog,
        ToolTip    = Popup | Sheet,
        SplashScreen = ToolTip | Dialog,
        Desktop    = 0x00000010 | Window,
        SubWindow  = 0x00000012,
        ForeignWindow  = 0x00000020 | Window,
        CoverWindow    = 0x00000040 | Window,
        WindowType_Mask = 0x000000ff,

        MSWindowsFixedSizeDialogHint = 0x00000100,
        MSWindowsOwnDC              = 0x00000200,
        BypassWindowManagerHint      = 0x00000400,
        X11BypassWindowManagerHint   = BypassWindowManagerHint,
        FramelessWindowHint          = 0x00000800,
        WindowTitleHint              = 0x00001000,
        WindowSystemMenuHint         = 0x00002000,
        WindowMinimizeButtonHint     = 0x00004000,
        WindowMaximizeButtonHint     = 0x00008000,
        WindowMinMaxButtonsHint      = WindowMinimizeButtonHint | WindowMaximizeButtonHint,
        WindowContextHelpButtonHint  = 0x00010000,
        WindowShadeButtonHint        = 0x00020000,
        WindowStaysOnTopHint         = 0x00040000,
        WindowTransparentForInput    = 0x00080000,
        WindowOverridesSystemGestures = 0x00100000,
        WindowDoesNotAcceptFocus     = 0x00200000,
        MaximizeUsingFullscreenGeometryHint = 0x00400000,
        CustomizeWindowHint          = 0x02000000,
        WindowStaysOnBottomHint      = 0x04000000,
        WindowCloseButtonHint        = 0x08000000,
        MacWindowToolBarButtonHint   = 0x10000000,
        BypassGraphicsProxyWidget    = 0x20000000,
        NoDropShadowWindowHint       = 0x40000000,
        WindowFullscreenButtonHint   = 0x80000000,
    }
    alias WindowFlags = WindowType;

    enum WindowState {
        WindowNoState    = 0x00000000,
        WindowMinimized  = 0x00000001,
        WindowMaximized  = 0x00000002,
        WindowFullScreen = 0x00000004,
        WindowActive     = 0x00000008,
    }
    alias WindowStates = WindowState;

    enum WindowModality {
        NonModal         = 0,
        WindowModal      = 1,
        ApplicationModal = 2,
    }

    // ── Keyboard ──────────────────────────────────────────────────────────────
    enum KeyboardModifier {
        NoModifier          = 0x00000000,
        ShiftModifier       = 0x02000000,
        ControlModifier     = 0x04000000,
        AltModifier         = 0x08000000,
        MetaModifier        = 0x10000000,
        KeypadModifier      = 0x20000000,
        GroupSwitchModifier  = 0x40000000,
        KeyboardModifierMask = 0xfe000000,
    }

    enum Key {
        Key_Escape    = 0x01000000,
        Key_Tab       = 0x01000001,
        Key_Backtab   = 0x01000002,
        Key_Backspace = 0x01000003,
        Key_Return    = 0x01000004,
        Key_Enter     = 0x01000005,
        Key_Insert    = 0x01000006,
        Key_Delete    = 0x01000007,
        Key_Pause     = 0x01000008,
        Key_Print     = 0x01000009,
        Key_SysReq    = 0x0100000a,
        Key_Clear     = 0x0100000b,
        Key_Home      = 0x01000010,
        Key_End       = 0x01000011,
        Key_Left      = 0x01000012,
        Key_Up        = 0x01000013,
        Key_Right     = 0x01000014,
        Key_Down      = 0x01000015,
        Key_PageUp    = 0x01000016,
        Key_PageDown  = 0x01000017,
        Key_Shift     = 0x01000020,
        Key_Control   = 0x01000021,
        Key_Meta      = 0x01000022,
        Key_Alt       = 0x01000023,
        Key_CapsLock  = 0x01000024,
        Key_NumLock   = 0x01000025,
        Key_ScrollLock = 0x01000026,
        Key_F1  = 0x01000030, Key_F2  = 0x01000031, Key_F3  = 0x01000032,
        Key_F4  = 0x01000033, Key_F5  = 0x01000034, Key_F6  = 0x01000035,
        Key_F7  = 0x01000036, Key_F8  = 0x01000037, Key_F9  = 0x01000038,
        Key_F10 = 0x01000039, Key_F11 = 0x0100003a, Key_F12 = 0x0100003b,
        Key_Super_L = 0x01000053,
        Key_Super_R = 0x01000054,
        Key_Menu    = 0x01000055,
        Key_Help    = 0x01000058,
        Key_Space   = 0x20,
        Key_Any     = Key_Space,
        Key_Exclam  = 0x21, Key_QuoteDbl = 0x22, Key_NumberSign = 0x23,
        Key_Dollar  = 0x24, Key_Percent  = 0x25, Key_Ampersand  = 0x26,
        Key_Apostrophe = 0x27, Key_ParenLeft = 0x28, Key_ParenRight = 0x29,
        Key_Asterisk = 0x2a, Key_Plus = 0x2b, Key_Comma = 0x2c,
        Key_Minus  = 0x2d, Key_Period = 0x2e, Key_Slash = 0x2f,
        Key_0 = 0x30, Key_1 = 0x31, Key_2 = 0x32, Key_3 = 0x33, Key_4 = 0x34,
        Key_5 = 0x35, Key_6 = 0x36, Key_7 = 0x37, Key_8 = 0x38, Key_9 = 0x39,
        Key_Colon = 0x3a, Key_Semicolon = 0x3b, Key_Less = 0x3c,
        Key_Equal = 0x3d, Key_Greater   = 0x3e, Key_Question = 0x3f,
        Key_At = 0x40,
        Key_A = 0x41, Key_B = 0x42, Key_C = 0x43, Key_D = 0x44,
        Key_E = 0x45, Key_F = 0x46, Key_G = 0x47, Key_H = 0x48,
        Key_I = 0x49, Key_J = 0x4a, Key_K = 0x4b, Key_L = 0x4c,
        Key_M = 0x4d, Key_N = 0x4e, Key_O = 0x4f, Key_P = 0x50,
        Key_Q = 0x51, Key_R = 0x52, Key_S = 0x53, Key_T = 0x54,
        Key_U = 0x55, Key_V = 0x56, Key_W = 0x57, Key_X = 0x58,
        Key_Y = 0x59, Key_Z = 0x5a,
        Key_BracketLeft = 0x5b, Key_Backslash = 0x5c, Key_BracketRight = 0x5d,
        Key_AsciiCircum = 0x5e, Key_Underscore = 0x5f, Key_QuoteLeft = 0x60,
        Key_BraceLeft = 0x7b, Key_Bar = 0x7c, Key_BraceRight = 0x7d,
        Key_AsciiTilde = 0x7e,
    }

    // ── Mouse ─────────────────────────────────────────────────────────────────
    enum MouseButton {
        NoButton   = 0x00000000,
        LeftButton  = 0x00000001,
        RightButton = 0x00000002,
        MidButton   = 0x00000004,
        MiddleButton = MidButton,
        AllButtons  = 0x07ffffff,
    }

    // ── Text ──────────────────────────────────────────────────────────────────
    enum TextFormat {
        PlainText    = 0,
        RichText     = 1,
        AutoText     = 2,
        MarkdownText = 3,
    }

    enum TextInteractionFlag {
        NoTextInteraction         = 0,
        TextSelectableByMouse     = 1,
        TextSelectableByKeyboard  = 2,
        LinksAccessibleByMouse    = 4,
        LinksAccessibleByKeyboard = 8,
        TextEditable              = 16,
        TextEditorInteraction     = TextSelectableByMouse | TextSelectableByKeyboard | TextEditable,
        TextBrowserInteraction    = TextSelectableByMouse | LinksAccessibleByMouse | LinksAccessibleByKeyboard,
    }

    enum TextElideMode {
        ElideLeft   = 0,
        ElideRight  = 1,
        ElideMiddle = 2,
        ElideNone   = 3,
    }

    // ── Colors ────────────────────────────────────────────────────────────────
    enum GlobalColor {
        color0, color1,
        black, white,
        darkGray, gray, lightGray,
        red, green, blue,
        cyan, magenta, yellow,
        darkRed, darkGreen, darkBlue,
        darkCyan, darkMagenta, darkYellow,
        transparent,
    }

    // ── Pen / Brush ───────────────────────────────────────────────────────────
    enum PenStyle {
        NoPen          = 0,
        SolidLine      = 1,
        DashLine       = 2,
        DotLine        = 3,
        DashDotLine    = 4,
        DashDotDotLine = 5,
        CustomDashLine = 6,
    }

    enum BrushStyle {
        NoBrush          = 0,
        SolidPattern     = 1,
        Dense1Pattern    = 2,
        Dense2Pattern    = 3,
        Dense3Pattern    = 4,
        Dense4Pattern    = 5,
        Dense5Pattern    = 6,
        Dense6Pattern    = 7,
        Dense7Pattern    = 8,
        HorPattern       = 9,
        VerPattern       = 10,
        CrossPattern     = 11,
        BDiagPattern     = 12,
        FDiagPattern     = 13,
        DiagCrossPattern = 14,
    }

    // ── Layout / Direction ────────────────────────────────────────────────────
    enum LayoutDirection {
        LeftToRight,
        RightToLeft,
        LayoutDirectionAuto,
    }

    // ── Context Menu ──────────────────────────────────────────────────────────
    enum ContextMenuPolicy {
        NoContextMenu      = 0,
        DefaultContextMenu = 1,
        ActionsContextMenu = 2,
        CustomContextMenu  = 3,
        PreventContextMenu = 4,
    }

    // ── Item Flags ────────────────────────────────────────────────────────────
    enum ItemFlag {
        NoItemFlags          = 0,
        ItemIsSelectable     = 1,
        ItemIsEditable       = 2,
        ItemIsDragEnabled    = 4,
        ItemIsDropEnabled    = 8,
        ItemIsUserCheckable  = 16,
        ItemIsEnabled        = 32,
        ItemIsAutoTristate   = 64,
        ItemNeverHasChildren = 128,
        ItemIsUserTristate   = 256,
    }

    // ── Dock / Toolbar Areas ──────────────────────────────────────────────────
    enum DockWidgetArea {
        NoDockWidgetArea   = 0,
        LeftDockWidgetArea   = 0x1,
        RightDockWidgetArea  = 0x2,
        TopDockWidgetArea    = 0x4,
        BottomDockWidgetArea = 0x8,
        DockWidgetArea_Mask  = 0xf,
        AllDockWidgetAreas   = DockWidgetArea_Mask,
    }

    enum ToolBarArea {
        NoToolBarArea     = 0,
        LeftToolBarArea   = 0x1,
        RightToolBarArea  = 0x2,
        TopToolBarArea    = 0x4,
        BottomToolBarArea = 0x8,
        ToolBarArea_Mask  = 0xf,
        AllToolBarAreas   = ToolBarArea_Mask,
    }

    // ── Sort ──────────────────────────────────────────────────────────────────
    enum SortOrder {
        AscendingOrder  = 0,
        DescendingOrder = 1,
    }

    // ── Scroll Bar ────────────────────────────────────────────────────────────
    enum ScrollBarPolicy {
        ScrollBarAsNeeded  = 0,
        ScrollBarAlwaysOff = 1,
        ScrollBarAlwaysOn  = 2,
    }

    // ── Size Policy ───────────────────────────────────────────────────────────
    enum SizePolicy {
        Fixed            = 0,
        Minimum          = 1,   // GrowFlag
        Maximum          = 4,   // ShrinkFlag
        Preferred        = 5,   // GrowFlag | ShrinkFlag
        MinimumExpanding = 3,   // GrowFlag | ExpandFlag
        Expanding        = 7,   // GrowFlag | ShrinkFlag | ExpandFlag
        Ignored          = 13,  // ShrinkFlag | GrowFlag | IgnoreFlag
    }

    // ── Aspect Ratio ──────────────────────────────────────────────────────────
    enum AspectRatioMode {
        IgnoreAspectRatio            = 0,
        KeepAspectRatio              = 1,
        KeepAspectRatioByExpanding   = 2,
    }

    // ── Transformation Mode ───────────────────────────────────────────────────
    enum TransformationMode {
        FastTransformation   = 0,
        SmoothTransformation = 1,
    }

    // ── Connection Type ───────────────────────────────────────────────────────
    enum ConnectionType {
        AutoConnection           = 0,
        DirectConnection         = 1,
        QueuedConnection         = 2,
        BlockingQueuedConnection = 4,
        UniqueConnection         = 0x80,
    }

    // ── Input Method ──────────────────────────────────────────────────────────
    enum InputMethodHint {
        ImhNone                     = 0x0,
        ImhHiddenText               = 0x1,
        ImhSensitiveData            = 0x2,
        ImhNoAutoUppercase          = 0x4,
        ImhPreferNumbers            = 0x8,
        ImhPreferUppercase          = 0x10,
        ImhPreferLowercase          = 0x20,
        ImhNoPredictiveText         = 0x40,
        ImhDate                     = 0x80,
        ImhTime                     = 0x100,
        ImhPreferLatin              = 0x200,
        ImhMultiLine                = 0x400,
        ImhDigitsOnly               = 0x10000,
        ImhFormattedNumbersOnly     = 0x20000,
        ImhUppercaseOnly            = 0x40000,
        ImhLowercaseOnly            = 0x80000,
        ImhDialableCharactersOnly   = 0x100000,
        ImhEmailCharactersOnly      = 0x200000,
        ImhUrlCharactersOnly        = 0x400000,
        ImhLatinOnly                = 0x800000,
        ImhExclusiveInputMask       = 0xffff0000,
    }

    // ── Time Spec ─────────────────────────────────────────────────────────────
    enum TimeSpec {
        LocalTime = 0,
        UTC       = 1,
        OffsetFromUTC = 2,
        TimeZone  = 3,
    }

    // ── Widget Attribute (commonly used subset) ───────────────────────────────
    enum WidgetAttribute {
        WA_Disabled             = 0,
        WA_UnderMouse           = 1,
        WA_MouseTracking        = 2,
        WA_OpaquePaintEvent     = 4,
        WA_StaticContents       = 5,
        WA_NoSystemBackground   = 9,
        WA_UpdatesDisabled      = 10,
        WA_InputMethodEnabled   = 14,
        WA_KeyCompression       = 33,
        WA_SetFont              = 37,
        WA_SetCursor            = 38,
        WA_WindowModified       = 41,
        WA_TransparentForMouseEvents = 51,
        WA_SetWindowIcon        = 53,
        WA_DeleteOnClose        = 55,
        WA_RightToLeft          = 56,
        WA_QuitOnClose          = 76,
        WA_KeyboardFocusChange  = 77,
        WA_AcceptDrops          = 78,
        WA_AlwaysShowToolTips   = 84,
        WA_SetLocale            = 87,
        WA_StyleSheet           = 97,
        WA_ShowWithoutActivating = 98,
        WA_NativeWindow         = 100,
        WA_DontShowOnScreen     = 103,
        WA_TranslucentBackground = 120,
        WA_AcceptTouchEvents    = 121,
        WA_AlwaysStackOnTop     = 128,
        WA_TabletTracking       = 129,
    }

    // ── Cursor Shape ──────────────────────────────────────────────────────────
    enum CursorShape {
        ArrowCursor        = 0,
        UpArrowCursor      = 1,
        CrossCursor        = 2,
        WaitCursor         = 3,
        IBeamCursor        = 4,
        SizeVerCursor      = 5,
        SizeHorCursor      = 6,
        SizeBDiagCursor    = 7,
        SizeFDiagCursor    = 8,
        SizeAllCursor      = 9,
        BlankCursor        = 10,
        SplitVCursor       = 11,
        SplitHCursor       = 12,
        PointingHandCursor = 13,
        ForbiddenCursor    = 14,
        WhatsThisCursor    = 15,
        BusyCursor         = 16,
        OpenHandCursor     = 17,
        ClosedHandCursor   = 18,
        DragCopyCursor     = 19,
        DragMoveCursor     = 20,
        DragLinkCursor     = 21,
    }

    // ── Image Conversion ──────────────────────────────────────────────────────
    enum ImageConversionFlag {
        AutoColor       = 0x00000000,
        ColorOnly       = 0x00000003,
        MonoOnly        = 0x00000002,
        DiffuseDither   = 0x00000000,
        OrderedDither   = 0x00000010,
        ThresholdDither = 0x00000020,
        AutoDither      = 0x00000000,
        PreferDither    = 0x00000040,
        AvoidDither     = 0x00000080,
        NoOpaqueDetection   = 0x00000100,
        NoFormatConversion  = 0x00000200,
    }

    // ── QTextCursor::MoveOperation ─────────────────────────────────────────
    enum MoveOperation {
        NoMove            = 0,
        Start             = 1,
        Up                = 2,
        StartOfLine       = 3,
        StartOfBlock      = 4,
        StartOfWord       = 5,
        PreviousBlock     = 6,
        PreviousCharacter = 7,
        PreviousWord      = 8,
        Left              = 9,
        WordLeft          = 10,
        End               = 11,
        Down              = 12,
        EndOfLine         = 13,
        EndOfWord         = 14,
        EndOfBlock        = 15,
        NextBlock         = 16,
        NextCharacter     = 17,
        NextWord          = 18,
        Right             = 19,
        WordRight         = 20,
    }

    // ── QTextCursor::MoveMode ───────────────────────────────────────────
    enum MoveMode {
        MoveAnchor = 0,
        KeepAnchor = 1,
    }

    // ── QTextCursor::SelectionType ──────────────────────────────────────
    enum SelectionType {
        WordUnderCursor   = 0,
        LineUnderCursor   = 1,
        BlockUnderCursor  = 2,
        Document          = 3,
    }

    // ── QTextCharFormat::UnderlineStyle ──────────────────────────────────
    enum UnderlineStyle {
        NoUnderline         = 0,
        SingleUnderline     = 1,
        DashUnderline       = 2,
        DotLine             = 3,
        DashDotLine         = 4,
        DashDotDotLine      = 5,
        WaveUnderline       = 6,
        SpellCheckUnderline = 7,
    }

    // ── QTextBlockFormat::LineHeightType ─────────────────────────────────
    enum LineHeightType {
        SingleHeight         = 0,
        ProportionalHeight   = 1,
        FixedHeight          = 2,
        MinimumHeight        = 3,
    }

} // class QtE

// ── QFrame enums (not in Qt:: namespace, in QFrame::) ─────────────────────────

enum FrameShape {
    NoFrame  = 0,
    Box      = 0x0001,
    Panel    = 0x0002,
    WinPanel = 0x0003,
    HLine    = 0x0004,
    VLine    = 0x0005,
    StyledPanel = 0x0006,
}

enum FrameShadow {
    Plain  = 0x0010,
    Raised = 0x0020,
    Sunken = 0x0030,
}

// ── QSizePolicy enums (class scope in Qt, here module level) ──────────────────

enum SizePolicyFlag {
    GrowFlag   = 1,
    ExpandFlag = 2,
    ShrinkFlag = 4,
    IgnoreFlag = 8,
}

// ── QTabWidget / QTabBar ──────────────────────────────────────────────────────

enum TabPosition {
    North = 0,
    South = 1,
    West  = 2,
    East  = 3,
}

// ── QScintilla / Scintilla constants ─────────────────────────────────────────

/// Scintilla message codes (most commonly used subset).
/// Full list: QScintilla_gpl-2.11.2/include/Scintilla.h
enum SCI : uint {
    // Text
    SCI_SETTEXT         = 2181,
    SCI_GETTEXT         = 2182,
    SCI_APPENDTEXT      = 2282,
    SCI_CLEARALL        = 2004,
    SCI_GETLENGTH       = 2006,
    SCI_GETLINECOUNT    = 2154,
    SCI_GETCURLINE      = 2027,

    // Navigation
    SCI_GETCURRENTPOS   = 2008,
    SCI_GOTOPOS         = 2025,
    SCI_GOTOLINE        = 2024,
    SCI_SETSEL          = 2160,
    SCI_GETSELTEXT      = 2161,
    SCI_SELECTALL       = 2013,
    SCI_REPLACESEL      = 2170,

    // Editing
    SCI_UNDO            = 2176,
    SCI_REDO            = 2011,
    SCI_CUT             = 2177,
    SCI_COPY            = 2178,
    SCI_PASTE           = 2179,
    SCI_CLEAR           = 2180,
    SCI_EMPTYUNDOBUFFER = 2175,
    SCI_SETSAVEPOINT    = 2014,

    // Read-only
    SCI_SETREADONLY      = 2171,
    SCI_GETREADONLY      = 2140,

    // Settings
    SCI_SETTABWIDTH      = 2036,
    SCI_SETINDENT        = 2122,
    SCI_SETUSETABS       = 2124,
    SCI_SETCODEPAGE      = 2037,

    // Margins
    SCI_SETMARGINTYPEN   = 2240,
    SCI_SETMARGINWIDTHN  = 2242,
    SCI_SETFOLDFLAGS     = 2233,

    // Style
    SCI_STYLESETFORE     = 2051,
    SCI_STYLESETBACK     = 2052,
    SCI_STYLESETBOLD     = 2053,
    SCI_STYLESETITALIC   = 2054,
    SCI_STYLESETSIZE     = 2055,
    SCI_STYLESETFONT     = 2056,

    // Selection
    SCI_SETSELECTIONSTART = 2135,
    SCI_SETSELECTIONEND   = 2136,
    SCI_GETSELECTIONSTART = 2143,
    SCI_GETSELECTIONEND   = 2145,

    // Style
    SCI_STYLECLEARALL    = 2050,

    // Target (for low-level search)
    SCI_SETTARGETSTART   = 2190,
    SCI_SETTARGETEND     = 2191,
    SCI_SEARCHINTARGET   = 2197,
    SCI_GETTARGETSTART   = 2192,
    SCI_GETTARGETEND     = 2193,
    SCI_REPLACETARGET    = 2194,

    // Search
    SCI_SEARCHNEXT       = 2367,
    SCI_SEARCHPREV       = 2368,
    SCI_SETSEARCHFLAGS   = 2198,

    // Autocomplete
    SCI_AUTOCSHOW        = 2100,
    SCI_AUTOCCANCEL      = 2101,
    SCI_AUTOCCOMPLETE    = 2104,
    SCI_AUTOCSETMAXWIDTH = 2208,

    // Lexer
    SCI_SETLEXER         = 4001,
    SCI_GETLEXER         = 4002,
    SCI_SETKEYWORDS      = 4005,
}

/// Scintilla lexer IDs. Used with SCI_SETLEXER.
enum SCLEX : int {
    SCLEX_CONTAINER  = 0,
    SCLEX_NULL       = 1,
    SCLEX_PYTHON     = 2,
    SCLEX_CPP        = 3,
    SCLEX_HTML       = 4,
    SCLEX_SQL        = 7,
    SCLEX_VB         = 8,
    SCLEX_VBSCRIPT   = 28,
    SCLEX_D          = 79,
    SCLEX_JSON       = 120,
}

/// VB/VBA style tokens (SCE_B_*). Used with SCI_STYLESETFORE etc.
enum SCE_B : int {
    SCE_B_DEFAULT      = 0,
    SCE_B_COMMENT      = 1,
    SCE_B_NUMBER       = 2,
    SCE_B_KEYWORD      = 3,
    SCE_B_STRING       = 4,
    SCE_B_PREPROCESSOR = 5,
    SCE_B_OPERATOR     = 6,
    SCE_B_IDENTIFIER   = 7,
    SCE_B_DATE         = 8,
    SCE_B_STRINGEOL    = 9,
    SCE_B_KEYWORD2     = 10,
    SCE_B_KEYWORD3     = 11,
    SCE_B_KEYWORD4     = 12,
    SCE_B_CONSTANT     = 13,
    SCE_B_ASM          = 14,
    SCE_B_LABEL        = 15,
    SCE_B_ERROR        = 16,
    SCE_B_HEXNUMBER    = 17,
    SCE_B_BINNUMBER    = 18,
    SCE_B_COMMENTBLOCK = 19,
    SCE_B_DOCLINE      = 20,
    SCE_B_DOCBLOCK     = 21,
    SCE_B_DOCKEYWORD   = 22,
}

/// QsciScintilla::FoldStyle — folding margin styles.
enum SciFolding : int {
    NoFoldStyle          = 0,
    PlainFoldStyle       = 1,
    CircledFoldStyle     = 2,
    BoxedFoldStyle       = 3,
    CircledTreeFoldStyle = 4,
    BoxedTreeFoldStyle   = 5,
}

/// QsciScintilla::BraceMatch — brace matching modes.
enum SciBraceMatch : int {
    NoBraceMatch     = 0,
    StrictBraceMatch = 1,
    SloppyBraceMatch = 2,
}

/// Scintilla search flags for SCI_SETSEARCHFLAGS / findFirst.
/// Combine with | for multiple options.
enum SCFIND : int {
    SCFIND_NONE      = 0,
    SCFIND_WHOLEWORD = 2,
    SCFIND_MATCHCASE = 4,
    SCFIND_REGEXP    = 0x00200000,
    SCFIND_POSIX     = 0x00400000,
}

/// QsciScintilla::AutoCompletionSource — source for autocomplete popup.
enum SciAutoComplete : int {
    AcsNone     = 0,   /// No autocomplete
    AcsAll      = 1,   /// Words from document + APIs
    AcsDocument = 2,   /// Words from current document only
    AcsAPIs     = 3,   /// Words from attached QsciAPIs only
}

// ── QPen enums ────────────────────────────────────────────────────────────────

/// Qt::PenCapStyle — line end caps.
enum PenCapStyle : int {
    FlatCap   = 0x00,
    SquareCap = 0x10,
    RoundCap  = 0x20,
}

/// Qt::PenJoinStyle — line join styles.
enum PenJoinStyle : int {
    MiterJoin    = 0x00,
    BevelJoin    = 0x40,
    RoundJoin    = 0x80,
    SvgMiterJoin = 0x100,
}

// ── QPalette enums ────────────────────────────────────────────────────────────

/// QPalette::ColorGroup — which state of a widget palette to address.
enum ColorGroup : int {
    Active   = 0,
    Disabled = 1,
    Inactive = 2,
    NColorGroups = 3,
    Current  = Active,
    All      = 3,
    Normal   = Active,
}

/// QPalette::ColorRole — semantic role within a palette.
enum ColorRole : int {
    WindowText      = 0,
    Button          = 1,
    Light           = 2,
    Midlight        = 3,
    Dark            = 4,
    Mid             = 5,
    Text            = 6,
    BrightText      = 7,
    ButtonText      = 8,
    Base            = 9,
    Window          = 10,
    Shadow          = 11,
    Highlight       = 12,
    HighlightedText = 13,
    Link            = 14,
    LinkVisited     = 15,
    AlternateBase   = 16,
    NoRole          = 17,
    ToolTipBase     = 18,
    ToolTipText     = 19,
}

// ── QSystemTrayIcon enums ─────────────────────────────────────────────────────

/// QSystemTrayIcon::ActivationReason — how the tray icon was activated
enum TrayActivationReason : int {
    Unknown     = 0,
    Context     = 1,
    DoubleClick = 2,
    Trigger     = 3,
    MiddleClick = 4,
}

/// QSystemTrayIcon::MessageIcon — icon shown in balloon message
enum TrayMessageIcon : int {
    NoIcon      = 0,
    Information = 1,
    Warning     = 2,
    Critical    = 3,
}
