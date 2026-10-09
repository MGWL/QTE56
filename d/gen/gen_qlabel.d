/**
 * gen_qlabel.d — GENERATED wrapper for QLabel.
 * Module: QLabel  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qlabel;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, toQString;
import gen_qframe : QFrame;

// New aliases for this module:
mixin(generateAlias("qp__qp_i_qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_qp"));

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

void loadQLabel() {
    mixin(generateFunQt(800, "qteQLabel_create", "QLabel"));
    mixin(generateFunQt(801, "qteQLabel_delete", "QLabel"));
    mixin(generateFunQt(802, "qteQLabel_create_text", "QLabel"));
    mixin(generateFunQt(806, "qteQLabel_text", "QLabel"));
    mixin(generateFunQt(837, "qteQLabel_pixmap", "QLabel"));
    mixin(generateFunQt(838, "qteQLabel_picture", "QLabel"));
    mixin(generateFunQt(839, "qteQLabel_movie", "QLabel"));
    mixin(generateFunQt(831, "qteQLabel_textFormat", "QLabel"));
    mixin(generateFunQt(832, "qteQLabel_setTextFormat", "QLabel"));
    mixin(generateFunQt(833, "qteQLabel_alignment", "QLabel"));
    mixin(generateFunQt(834, "qteQLabel_setAlignment", "QLabel"));
    mixin(generateFunQt(807, "qteQLabel_setWordWrap", "QLabel"));
    mixin(generateFunQt(808, "qteQLabel_wordWrap", "QLabel"));
    mixin(generateFunQt(809, "qteQLabel_indent", "QLabel"));
    mixin(generateFunQt(810, "qteQLabel_setIndent", "QLabel"));
    mixin(generateFunQt(811, "qteQLabel_margin", "QLabel"));
    mixin(generateFunQt(812, "qteQLabel_setMargin", "QLabel"));
    mixin(generateFunQt(813, "qteQLabel_hasScaledContents", "QLabel"));
    mixin(generateFunQt(814, "qteQLabel_setScaledContents", "QLabel"));
    mixin(generateFunQt(817, "qteQLabel_setBuddy", "QLabel"));
    mixin(generateFunQt(840, "qteQLabel_buddy", "QLabel"));
    mixin(generateFunQt(819, "qteQLabel_openExternalLinks", "QLabel"));
    mixin(generateFunQt(820, "qteQLabel_setOpenExternalLinks", "QLabel"));
    mixin(generateFunQt(835, "qteQLabel_setTextInteractionFlags", "QLabel"));
    mixin(generateFunQt(836, "qteQLabel_textInteractionFlags", "QLabel"));
    mixin(generateFunQt(821, "qteQLabel_setSelection", "QLabel"));
    mixin(generateFunQt(822, "qteQLabel_hasSelectedText", "QLabel"));
    mixin(generateFunQt(823, "qteQLabel_selectedText", "QLabel"));
    mixin(generateFunQt(824, "qteQLabel_selectionStart", "QLabel"));
    mixin(generateFunQt(825, "qteQLabel_setText", "QLabel"));
    mixin(generateFunQt(826, "qteQLabel_setMovie", "QLabel"));
    mixin(generateFunQt(827, "qteQLabel_setNum_i", "QLabel"));
    mixin(generateFunQt(828, "qteQLabel_setNum_d", "QLabel"));
    mixin(generateFunQt(829, "qteQLabel_clear", "QLabel"));
    mixin(generateFunQt(830, "qteQLabel_setEventHandler", "QLabel"));
    // qteQLabel_setPixmap (17613) регистрируется через gen_qpixmap.d → требует import gen_qpixmap
}

static this() {
    registerModule("QLabel", "qte56_widgets.dll", &loadQLabel);
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QLabel.
@live class QLabel : QFrame {
public:
    /// Create QLabel. parent must be explicitly passed (null for top-level).
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[800])(parent);
    }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QLabel* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QLabel wrap(void* wh) {
        auto w = new QLabel(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    /// Create QLabel with initial text.
    this(string text, void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        auto _ws = toQString(text);
        _wh = (cast(t_qp__qp_qp)pFunQt[802])(
            _ws, parent);
    }

    /// text
    string text() {
        void* _qs = (cast(t_qp__qp)pFunQt[806])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// pixmap
    void* pixmap() {
        return cast(void*)(cast(t_qp__qp)pFunQt[837])(_wh);
    }

    /// picture
    void* picture() {
        return cast(void*)(cast(t_qp__qp)pFunQt[838])(_wh);
    }

    /// movie
    void* movie() {
        return cast(void*)(cast(t_qp__qp)pFunQt[839])(_wh);
    }

    /// textFormat
    int textFormat() {
        return cast(int)(cast(t_i__qp)pFunQt[831])(_wh);
    }

    /// setTextFormat
    QLabel setTextFormat(int p0) {
        (cast(t_v__qp_i)pFunQt[832])(_wh, p0);
        return this;
    }

    /// alignment
    int alignment() {
        return cast(int)(cast(t_i__qp)pFunQt[833])(_wh);
    }

    /// setAlignment
    QLabel setAlignment(int p0) {
        (cast(t_v__qp_i)pFunQt[834])(_wh, p0);
        return this;
    }

    /// setWordWrap
    QLabel setWordWrap(bool on) {
        (cast(t_v__qp_i)pFunQt[807])(_wh, on ? 1 : 0);
        return this;
    }

    /// wordWrap
    bool wordWrap() {
        return cast(bool)(cast(t_i__qp)pFunQt[808])(_wh);
    }

    /// indent
    int indent() {
        return cast(int)(cast(t_i__qp)pFunQt[809])(_wh);
    }

    /// setIndent
    QLabel setIndent(int p0) {
        (cast(t_v__qp_i)pFunQt[810])(_wh, p0);
        return this;
    }

    /// margin
    int margin() {
        return cast(int)(cast(t_i__qp)pFunQt[811])(_wh);
    }

    /// setMargin
    QLabel setMargin(int p0) {
        (cast(t_v__qp_i)pFunQt[812])(_wh, p0);
        return this;
    }

    /// hasScaledContents
    bool hasScaledContents() {
        return cast(bool)(cast(t_i__qp)pFunQt[813])(_wh);
    }

    /// setScaledContents
    QLabel setScaledContents(bool p0) {
        (cast(t_v__qp_i)pFunQt[814])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setPixmap — set image from a QPixmap.
    /// Requires gen_qpixmap to be imported and qte56_qpixmap.dll loaded.
    /// Usage: label.setPixmap(px.getWH())
    QLabel setPixmap(void* pixmapWH) {
        (cast(t_v__qp_qp)pFunQt[17613])(_wh, pixmapWH);
        return this;
    }

    /// setBuddy
    QLabel setBuddy(void* p0) {
        (cast(t_v__qp_qp)pFunQt[817])(_wh, p0);
        return this;
    }

    /// buddy
    void* buddy() {
        return cast(void*)(cast(t_qp__qp)pFunQt[840])(_wh);
    }

    /// openExternalLinks
    bool openExternalLinks() {
        return cast(bool)(cast(t_i__qp)pFunQt[819])(_wh);
    }

    /// setOpenExternalLinks
    QLabel setOpenExternalLinks(bool open) {
        (cast(t_v__qp_i)pFunQt[820])(_wh, open ? 1 : 0);
        return this;
    }

    /// setTextInteractionFlags
    QLabel setTextInteractionFlags(int flags) {
        (cast(t_v__qp_i)pFunQt[835])(_wh, flags);
        return this;
    }

    /// textInteractionFlags
    int textInteractionFlags() {
        return cast(int)(cast(t_i__qp)pFunQt[836])(_wh);
    }

    /// setSelection
    QLabel setSelection(int p0, int p1) {
        (cast(t_v__qp_i_i)pFunQt[821])(_wh, p0, p1);
        return this;
    }

    /// hasSelectedText
    bool hasSelectedText() {
        return cast(bool)(cast(t_i__qp)pFunQt[822])(_wh);
    }

    /// selectedText
    string selectedText() {
        void* _qs = (cast(t_qp__qp)pFunQt[823])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// selectionStart
    int selectionStart() {
        return cast(int)(cast(t_i__qp)pFunQt[824])(_wh);
    }

    /// setText
    QLabel setText(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[825])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// setMovie
    QLabel setMovie(void* movie) {
        (cast(t_v__qp_qp)pFunQt[826])(_wh, movie);
        return this;
    }

    /// setNum
    QLabel setNum(int p0) {
        (cast(t_v__qp_i)pFunQt[827])(_wh, p0);
        return this;
    }

    /// setNum
    QLabel setNum(double p0) {
        (cast(t_v__qp_d)pFunQt[828])(_wh, p0);
        return this;
    }

    /// clear
    QLabel clear() {
        (cast(t_v__qp)pFunQt[829])(_wh);
        return this;
    }

    /// Connect signal linkActivated → ESlot
    QLabel connect_linkActivated(ESlot eslot) {
        connectQt(_wh, "linkActivated(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal linkHovered → ESlot
    QLabel connect_linkHovered(ESlot eslot) {
        connectQt(_wh, "linkHovered(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    override QLabel setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[830])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLabel onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLabel onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    override QLabel onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLabel onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLabel onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    override QLabel onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    override QLabel onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    override QLabel onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    override QLabel onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    override QLabel onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    override QLabel onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    override QLabel onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    override QLabel onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    override QLabel onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLabel onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    override QLabel onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    override QLabel onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

} // class QLabel
