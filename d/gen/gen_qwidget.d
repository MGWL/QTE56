/**
 * gen_qwidget.d — GENERATED wrapper for QWidget.
 * Module: QWidget  |  DLL: qte56_widgets.dll
 * DO NOT EDIT MANUALLY — regenerate with generator/main.py
 */
module gen_qwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : DPoint, DRect, DSize, ESlot, connectQt, fromQString, t_i__qp, t_i__qp_qp, t_qp__, t_qp__qp, t_qp__qp_qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_i, t_v__qp_qp_qp, t_v__qp_qp_qp_qp, toQString;
import gen_qobject : QObject;
import gen_qfont : QFont;
import gen_qbytearray : QByteArray;

// New aliases for this module:
mixin(generateAlias("sz__qp"));
mixin(generateAlias("d__qp"));
mixin(generateAlias("i__qp_i"));
mixin(generateAlias("i__qp_qp"));
mixin(generateAlias("qp__qp_qp_qp"));
mixin(generateAlias("v__qp_d"));
mixin(generateAlias("v__qp_i_i"));
mixin(generateAlias("v__qp_i_i_i_i"));
mixin(generateAlias("v__qp_qp"));
mixin(generateAlias("v__qp_qp_qp"));
mixin(generateAlias("v__qp_qp_qp_qp_qp"));
mixin(generateAlias("i__qp_qp_i"));       // int(void*, void*, int) — restoreGeometry

// ====================================================================
// Load function addresses at runtime (call after LoadQt)
// ====================================================================

static this() { registerModule("QWidget", "qte56_widgets.dll", &loadQWidget); }

void loadQWidget() {
    mixin(generateFunQt(200, "qteQWidget_create", "QWidget"));
    mixin(generateFunQt(201, "qteQWidget_delete", "QWidget"));
    mixin(generateFunQt(206, "qteQWidget_devType", "QWidget"));
    mixin(generateFunQt(207, "qteQWidget_winId", "QWidget"));
    mixin(generateFunQt(208, "qteQWidget_createWinId", "QWidget"));
    mixin(generateFunQt(209, "qteQWidget_effectiveWinId", "QWidget"));
    mixin(generateFunQt(210, "qteQWidget_setStyle", "QWidget"));
    mixin(generateFunQt(211, "qteQWidget_isTopLevel", "QWidget"));
    mixin(generateFunQt(212, "qteQWidget_isWindow", "QWidget"));
    mixin(generateFunQt(213, "qteQWidget_isModal", "QWidget"));
    mixin(generateFunQt(214, "qteQWidget_windowModality", "QWidget"));
    mixin(generateFunQt(215, "qteQWidget_setWindowModality", "QWidget"));
    mixin(generateFunQt(216, "qteQWidget_isEnabled", "QWidget"));
    mixin(generateFunQt(217, "qteQWidget_isEnabledTo", "QWidget"));
    mixin(generateFunQt(218, "qteQWidget_isEnabledToTLW", "QWidget"));
    mixin(generateFunQt(219, "qteQWidget_setEnabled", "QWidget"));
    mixin(generateFunQt(220, "qteQWidget_setDisabled", "QWidget"));
    mixin(generateFunQt(221, "qteQWidget_setWindowModified", "QWidget"));
    mixin(generateFunQt(222, "qteQWidget_frameGeometry", "QWidget"));
    mixin(generateFunQt(223, "qteQWidget_normalGeometry", "QWidget"));
    mixin(generateFunQt(224, "qteQWidget_x", "QWidget"));
    mixin(generateFunQt(225, "qteQWidget_y", "QWidget"));
    mixin(generateFunQt(226, "qteQWidget_pos", "QWidget"));
    mixin(generateFunQt(227, "qteQWidget_frameSize", "QWidget"));
    mixin(generateFunQt(228, "qteQWidget_size", "QWidget"));
    mixin(generateFunQt(229, "qteQWidget_width", "QWidget"));
    mixin(generateFunQt(230, "qteQWidget_height", "QWidget"));
    mixin(generateFunQt(231, "qteQWidget_rect", "QWidget"));
    mixin(generateFunQt(232, "qteQWidget_childrenRect", "QWidget"));
    mixin(generateFunQt(234, "qteQWidget_minimumSize", "QWidget"));
    mixin(generateFunQt(235, "qteQWidget_maximumSize", "QWidget"));
    mixin(generateFunQt(236, "qteQWidget_minimumWidth", "QWidget"));
    mixin(generateFunQt(237, "qteQWidget_minimumHeight", "QWidget"));
    mixin(generateFunQt(238, "qteQWidget_maximumWidth", "QWidget"));
    mixin(generateFunQt(239, "qteQWidget_maximumHeight", "QWidget"));
    mixin(generateFunQt(240, "qteQWidget_setMinimumSize_p", "QWidget"));
    mixin(generateFunQt(241, "qteQWidget_setMinimumSize_ii", "QWidget"));
    mixin(generateFunQt(242, "qteQWidget_setMaximumSize_p", "QWidget"));
    mixin(generateFunQt(243, "qteQWidget_setMaximumSize_ii", "QWidget"));
    mixin(generateFunQt(244, "qteQWidget_setMinimumWidth", "QWidget"));
    mixin(generateFunQt(245, "qteQWidget_setMinimumHeight", "QWidget"));
    mixin(generateFunQt(246, "qteQWidget_setMaximumWidth", "QWidget"));
    mixin(generateFunQt(247, "qteQWidget_setMaximumHeight", "QWidget"));
    mixin(generateFunQt(248, "qteQWidget_sizeIncrement", "QWidget"));
    mixin(generateFunQt(249, "qteQWidget_setSizeIncrement_p", "QWidget"));
    mixin(generateFunQt(250, "qteQWidget_setSizeIncrement_ii", "QWidget"));
    mixin(generateFunQt(251, "qteQWidget_baseSize", "QWidget"));
    mixin(generateFunQt(252, "qteQWidget_setBaseSize_p", "QWidget"));
    mixin(generateFunQt(253, "qteQWidget_setBaseSize_ii", "QWidget"));
    mixin(generateFunQt(254, "qteQWidget_setFixedSize_p", "QWidget"));
    mixin(generateFunQt(255, "qteQWidget_setFixedSize_ii", "QWidget"));
    mixin(generateFunQt(256, "qteQWidget_setFixedWidth", "QWidget"));
    mixin(generateFunQt(257, "qteQWidget_setFixedHeight", "QWidget"));
    mixin(generateFunQt(258, "qteQWidget_mapToGlobal", "QWidget"));
    mixin(generateFunQt(259, "qteQWidget_mapFromGlobal", "QWidget"));
    mixin(generateFunQt(260, "qteQWidget_mapToParent", "QWidget"));
    mixin(generateFunQt(261, "qteQWidget_mapFromParent", "QWidget"));
    mixin(generateFunQt(262, "qteQWidget_mapTo", "QWidget"));
    mixin(generateFunQt(263, "qteQWidget_mapFrom", "QWidget"));
    mixin(generateFunQt(264, "qteQWidget_setBackgroundRole", "QWidget"));
    mixin(generateFunQt(265, "qteQWidget_backgroundRole", "QWidget"));
    mixin(generateFunQt(266, "qteQWidget_setForegroundRole", "QWidget"));
    mixin(generateFunQt(267, "qteQWidget_foregroundRole", "QWidget"));
    mixin(generateFunQt(271, "qteQWidget_unsetCursor", "QWidget"));
    mixin(generateFunQt(272, "qteQWidget_setMouseTracking", "QWidget"));
    mixin(generateFunQt(273, "qteQWidget_hasMouseTracking", "QWidget"));
    mixin(generateFunQt(274, "qteQWidget_underMouse", "QWidget"));
    mixin(generateFunQt(275, "qteQWidget_setTabletTracking", "QWidget"));
    mixin(generateFunQt(276, "qteQWidget_hasTabletTracking", "QWidget"));
    mixin(generateFunQt(278, "qteQWidget_clearMask", "QWidget"));
    mixin(generateFunQt(279, "qteQWidget_setGraphicsEffect", "QWidget"));
    mixin(generateFunQt(280, "qteQWidget_ungrabGesture", "QWidget"));
    mixin(generateFunQt(203, "qteQWidget_setWindowTitle", "QWidget"));
    mixin(generateFunQt(281, "qteQWidget_setStyleSheet", "QWidget"));
    mixin(generateFunQt(282, "qteQWidget_styleSheet", "QWidget"));
    mixin(generateFunQt(283, "qteQWidget_windowTitle", "QWidget"));
    mixin(generateFunQt(284, "qteQWidget_setWindowIconText", "QWidget"));
    mixin(generateFunQt(285, "qteQWidget_windowIconText", "QWidget"));
    mixin(generateFunQt(286, "qteQWidget_setWindowRole", "QWidget"));
    mixin(generateFunQt(287, "qteQWidget_windowRole", "QWidget"));
    mixin(generateFunQt(288, "qteQWidget_setWindowFilePath", "QWidget"));
    mixin(generateFunQt(289, "qteQWidget_windowFilePath", "QWidget"));
    mixin(generateFunQt(290, "qteQWidget_setWindowOpacity", "QWidget"));
    mixin(generateFunQt(291, "qteQWidget_windowOpacity", "QWidget"));
    mixin(generateFunQt(292, "qteQWidget_isWindowModified", "QWidget"));
    mixin(generateFunQt(293, "qteQWidget_setToolTip", "QWidget"));
    mixin(generateFunQt(294, "qteQWidget_toolTip", "QWidget"));
    mixin(generateFunQt(295, "qteQWidget_setToolTipDuration", "QWidget"));
    mixin(generateFunQt(296, "qteQWidget_toolTipDuration", "QWidget"));
    mixin(generateFunQt(297, "qteQWidget_setStatusTip", "QWidget"));
    mixin(generateFunQt(298, "qteQWidget_statusTip", "QWidget"));
    mixin(generateFunQt(299, "qteQWidget_setWhatsThis", "QWidget"));
    mixin(generateFunQt(300, "qteQWidget_whatsThis", "QWidget"));
    mixin(generateFunQt(301, "qteQWidget_accessibleName", "QWidget"));
    mixin(generateFunQt(302, "qteQWidget_setAccessibleName", "QWidget"));
    mixin(generateFunQt(303, "qteQWidget_accessibleDescription", "QWidget"));
    mixin(generateFunQt(304, "qteQWidget_setAccessibleDescription", "QWidget"));
    mixin(generateFunQt(305, "qteQWidget_setLayoutDirection", "QWidget"));
    mixin(generateFunQt(306, "qteQWidget_layoutDirection", "QWidget"));
    mixin(generateFunQt(307, "qteQWidget_unsetLayoutDirection", "QWidget"));
    mixin(generateFunQt(309, "qteQWidget_unsetLocale", "QWidget"));
    mixin(generateFunQt(310, "qteQWidget_isActiveWindow", "QWidget"));
    mixin(generateFunQt(311, "qteQWidget_activateWindow", "QWidget"));
    mixin(generateFunQt(312, "qteQWidget_clearFocus", "QWidget"));
    mixin(generateFunQt(313, "qteQWidget_setFocus", "QWidget"));
    mixin(generateFunQt(314, "qteQWidget_focusPolicy", "QWidget"));
    mixin(generateFunQt(315, "qteQWidget_setFocusPolicy", "QWidget"));
    mixin(generateFunQt(316, "qteQWidget_hasFocus", "QWidget"));
    mixin(generateFunQt(317, "qteQWidget_setTabOrder", "QWidget"));
    mixin(generateFunQt(318, "qteQWidget_setFocusProxy", "QWidget"));
    mixin(generateFunQt(319, "qteQWidget_contextMenuPolicy", "QWidget"));
    mixin(generateFunQt(320, "qteQWidget_setContextMenuPolicy", "QWidget"));
    mixin(generateFunQt(321, "qteQWidget_grabMouse", "QWidget"));
    mixin(generateFunQt(322, "qteQWidget_releaseMouse", "QWidget"));
    mixin(generateFunQt(323, "qteQWidget_grabKeyboard", "QWidget"));
    mixin(generateFunQt(324, "qteQWidget_releaseKeyboard", "QWidget"));
    mixin(generateFunQt(325, "qteQWidget_releaseShortcut", "QWidget"));
    mixin(generateFunQt(326, "qteQWidget_setShortcutEnabled", "QWidget"));
    mixin(generateFunQt(327, "qteQWidget_setShortcutAutoRepeat", "QWidget"));
    mixin(generateFunQt(328, "qteQWidget_updatesEnabled", "QWidget"));
    mixin(generateFunQt(329, "qteQWidget_setUpdatesEnabled", "QWidget"));
    mixin(generateFunQt(330, "qteQWidget_update_v", "QWidget"));
    mixin(generateFunQt(331, "qteQWidget_repaint_v", "QWidget"));
    mixin(generateFunQt(332, "qteQWidget_update_iiii", "QWidget"));
    mixin(generateFunQt(333, "qteQWidget_repaint_iiii", "QWidget"));
    mixin(generateFunQt(334, "qteQWidget_repaint_p", "QWidget"));
    mixin(generateFunQt(335, "qteQWidget_setVisible", "QWidget"));
    mixin(generateFunQt(336, "qteQWidget_setHidden", "QWidget"));
    mixin(generateFunQt(202, "qteQWidget_show", "QWidget"));
    mixin(generateFunQt(337, "qteQWidget_hide", "QWidget"));
    mixin(generateFunQt(338, "qteQWidget_showMinimized", "QWidget"));
    mixin(generateFunQt(339, "qteQWidget_showMaximized", "QWidget"));
    mixin(generateFunQt(340, "qteQWidget_showFullScreen", "QWidget"));
    mixin(generateFunQt(341, "qteQWidget_showNormal", "QWidget"));
    mixin(generateFunQt(342, "qteQWidget_close", "QWidget"));
    mixin(generateFunQt(343, "qteQWidget_raise", "QWidget"));
    mixin(generateFunQt(344, "qteQWidget_lower", "QWidget"));
    mixin(generateFunQt(345, "qteQWidget_stackUnder", "QWidget"));
    mixin(generateFunQt(346, "qteQWidget_move_ii", "QWidget"));
    mixin(generateFunQt(347, "qteQWidget_move_p", "QWidget"));
    mixin(generateFunQt(348, "qteQWidget_resize_ii", "QWidget"));
    mixin(generateFunQt(349, "qteQWidget_resize_p", "QWidget"));
    mixin(generateFunQt(350, "qteQWidget_setGeometry_iiii", "QWidget"));
    mixin(generateFunQt(351, "qteQWidget_setGeometry_p", "QWidget"));
    mixin(generateFunQt(353, "qteQWidget_adjustSize", "QWidget"));
    mixin(generateFunQt(354, "qteQWidget_isVisible", "QWidget"));
    mixin(generateFunQt(355, "qteQWidget_isVisibleTo", "QWidget"));
    mixin(generateFunQt(356, "qteQWidget_isHidden", "QWidget"));
    mixin(generateFunQt(357, "qteQWidget_isMinimized", "QWidget"));
    mixin(generateFunQt(358, "qteQWidget_isMaximized", "QWidget"));
    mixin(generateFunQt(359, "qteQWidget_isFullScreen", "QWidget"));
    mixin(generateFunQt(360, "qteQWidget_windowState", "QWidget"));
    mixin(generateFunQt(361, "qteQWidget_setWindowState", "QWidget"));
    mixin(generateFunQt(362, "qteQWidget_overrideWindowState", "QWidget"));
    mixin(generateFunQt(363, "qteQWidget_sizeHint", "QWidget"));
    mixin(generateFunQt(364, "qteQWidget_minimumSizeHint", "QWidget"));
    mixin(generateFunQt(365, "qteQWidget_setSizePolicy", "QWidget"));
    mixin(generateFunQt(368, "qteQWidget_heightForWidth", "QWidget"));
    mixin(generateFunQt(369, "qteQWidget_hasHeightForWidth", "QWidget"));
    mixin(generateFunQt(371, "qteQWidget_setContentsMargins", "QWidget"));
    mixin(generateFunQt(372, "qteQWidget_getContentsMargins", "QWidget"));
    mixin(generateFunQt(374, "qteQWidget_contentsRect", "QWidget"));
    mixin(generateFunQt(205, "qteQWidget_setLayout", "QWidget"));
    mixin(generateFunQt(375, "qteQWidget_updateGeometry", "QWidget"));
    mixin(generateFunQt(376, "qteQWidget_setParent_w", "QWidget"));
    mixin(generateFunQt(377, "qteQWidget_setParent_wp", "QWidget"));
    mixin(generateFunQt(378, "qteQWidget_scroll", "QWidget"));
    mixin(generateFunQt(379, "qteQWidget_acceptDrops", "QWidget"));
    mixin(generateFunQt(380, "qteQWidget_setAcceptDrops", "QWidget"));
    mixin(generateFunQt(381, "qteQWidget_addAction", "QWidget"));
    mixin(generateFunQt(382, "qteQWidget_insertAction", "QWidget"));
    mixin(generateFunQt(383, "qteQWidget_removeAction", "QWidget"));
    mixin(generateFunQt(384, "qteQWidget_setWindowFlags", "QWidget"));
    mixin(generateFunQt(385, "qteQWidget_windowFlags", "QWidget"));
    mixin(generateFunQt(386, "qteQWidget_setWindowFlag", "QWidget"));
    mixin(generateFunQt(387, "qteQWidget_overrideWindowFlags", "QWidget"));
    mixin(generateFunQt(388, "qteQWidget_windowType", "QWidget"));
    mixin(generateFunQt(389, "qteQWidget_setAttribute", "QWidget"));
    mixin(generateFunQt(390, "qteQWidget_testAttribute", "QWidget"));
    mixin(generateFunQt(391, "qteQWidget_ensurePolished", "QWidget"));
    mixin(generateFunQt(392, "qteQWidget_isAncestorOf", "QWidget"));
    mixin(generateFunQt(393, "qteQWidget_autoFillBackground", "QWidget"));
    mixin(generateFunQt(394, "qteQWidget_setAutoFillBackground", "QWidget"));
    mixin(generateFunQt(395, "qteQWidget_inputMethodHints", "QWidget"));
    mixin(generateFunQt(396, "qteQWidget_setInputMethodHints", "QWidget"));
    mixin(generateFunQt(397, "qteQWidget_setEventHandler", "QWidget"));
    // Geometry persistence
    mixin(generateFunQt(398, "qteQWidget_saveGeometry",    "QWidget"));
    mixin(generateFunQt(399, "qteQWidget_restoreGeometry", "QWidget"));
}

// ====================================================================
// Class wrapper
// ====================================================================

/// D wrapper for Qt class QWidget.
@live class QWidget : QObject {
public:
    /// Create QWidget. parent must be explicitly passed (null for top-level).
    /// Syntax: new QWidget(null) — not new QWidget()
    this(void* parent) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[200])(parent);
    }

    /// Create QWidget without parent (top-level widget).
    this() { this(cast(void*)null); }

    /// No-op constructor for super() calls from child classes.
    protected this(bool _noOp) { super(_noOp); }
    /// Wrap an existing Qt-owned QWidget* (e.g. from QUiLoader or findChild).
    /// The D object does NOT delete the Qt pointer — Qt owns it.
    static QWidget wrap(void* wh) {
        auto w = new QWidget(true);
        w._wh = wh;
        w._qt_owned = true;
        return w;
    }


    ~this() {
        if (!_qt_owned && _wh !is null && pFunQt[201] !is null) {
            (cast(t_v__qp)pFunQt[201])(_wh);
            _wh = null;
        }
    }

    /// devType
    int devType() {
        return cast(int)(cast(t_i__qp)pFunQt[206])(_wh);
    }

    /// winId (returns WId — pointer-sized on 64-bit)
    size_t winId() {
        return cast(size_t)(cast(t_sz__qp)pFunQt[207])(_wh);
    }

    /// createWinId
    QWidget createWinId() {
        (cast(t_v__qp)pFunQt[208])(_wh);
        return this;
    }

    /// effectiveWinId (returns WId — pointer-sized on 64-bit)
    size_t effectiveWinId() {
        return cast(size_t)(cast(t_sz__qp)pFunQt[209])(_wh);
    }

    /// setStyle
    QWidget setStyle(void* p0) {
        (cast(t_v__qp_qp)pFunQt[210])(_wh, p0);
        return this;
    }

    /// isTopLevel
    bool isTopLevel() {
        return cast(bool)(cast(t_i__qp)pFunQt[211])(_wh);
    }

    /// isWindow
    bool isWindow() {
        return cast(bool)(cast(t_i__qp)pFunQt[212])(_wh);
    }

    /// isModal
    bool isModal() {
        return cast(bool)(cast(t_i__qp)pFunQt[213])(_wh);
    }

    /// windowModality
    int windowModality() {
        return cast(int)(cast(t_i__qp)pFunQt[214])(_wh);
    }

    /// setWindowModality
    QWidget setWindowModality(int windowModality) {
        (cast(t_v__qp_i)pFunQt[215])(_wh, windowModality);
        return this;
    }

    /// isEnabled
    bool isEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[216])(_wh);
    }

    /// isEnabledTo
    bool isEnabledTo(void* p0) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[217])(_wh, p0);
    }

    /// isEnabledToTLW
    bool isEnabledToTLW() {
        return cast(bool)(cast(t_i__qp)pFunQt[218])(_wh);
    }

    /// setEnabled
    QWidget setEnabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[219])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setDisabled
    QWidget setDisabled(bool p0) {
        (cast(t_v__qp_i)pFunQt[220])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// setWindowModified
    QWidget setWindowModified(bool p0) {
        (cast(t_v__qp_i)pFunQt[221])(_wh, p0 ? 1 : 0);
        return this;
    }

    /// frameGeometry
    DRect frameGeometry() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[222])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// normalGeometry
    DRect normalGeometry() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[223])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// x
    int x() {
        return cast(int)(cast(t_i__qp)pFunQt[224])(_wh);
    }

    /// y
    int y() {
        return cast(int)(cast(t_i__qp)pFunQt[225])(_wh);
    }

    /// pos
    DPoint pos() {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[226])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// frameSize
    DSize frameSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[227])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// size
    DSize size() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[228])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// width
    int width() {
        return cast(int)(cast(t_i__qp)pFunQt[229])(_wh);
    }

    /// height
    int height() {
        return cast(int)(cast(t_i__qp)pFunQt[230])(_wh);
    }

    /// rect
    DRect rect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[231])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// childrenRect
    DRect childrenRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[232])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// minimumSize
    DSize minimumSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[234])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// maximumSize
    DSize maximumSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[235])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// minimumWidth
    int minimumWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[236])(_wh);
    }

    /// minimumHeight
    int minimumHeight() {
        return cast(int)(cast(t_i__qp)pFunQt[237])(_wh);
    }

    /// maximumWidth
    int maximumWidth() {
        return cast(int)(cast(t_i__qp)pFunQt[238])(_wh);
    }

    /// maximumHeight
    int maximumHeight() {
        return cast(int)(cast(t_i__qp)pFunQt[239])(_wh);
    }

    /// setMinimumSize
    QWidget setMinimumSize(void* p0) {
        (cast(t_v__qp_qp)pFunQt[240])(_wh, p0);
        return this;
    }

    /// setMinimumSize
    QWidget setMinimumSize(int minw, int minh) {
        (cast(t_v__qp_i_i)pFunQt[241])(_wh, minw, minh);
        return this;
    }

    /// setMaximumSize
    QWidget setMaximumSize(void* p0) {
        (cast(t_v__qp_qp)pFunQt[242])(_wh, p0);
        return this;
    }

    /// setMaximumSize
    QWidget setMaximumSize(int maxw, int maxh) {
        (cast(t_v__qp_i_i)pFunQt[243])(_wh, maxw, maxh);
        return this;
    }

    /// setMinimumWidth
    QWidget setMinimumWidth(int minw) {
        (cast(t_v__qp_i)pFunQt[244])(_wh, minw);
        return this;
    }

    /// setMinimumHeight
    QWidget setMinimumHeight(int minh) {
        (cast(t_v__qp_i)pFunQt[245])(_wh, minh);
        return this;
    }

    /// setMaximumWidth
    QWidget setMaximumWidth(int maxw) {
        (cast(t_v__qp_i)pFunQt[246])(_wh, maxw);
        return this;
    }

    /// setMaximumHeight
    QWidget setMaximumHeight(int maxh) {
        (cast(t_v__qp_i)pFunQt[247])(_wh, maxh);
        return this;
    }

    /// sizeIncrement
    DSize sizeIncrement() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[248])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setSizeIncrement
    QWidget setSizeIncrement(void* p0) {
        (cast(t_v__qp_qp)pFunQt[249])(_wh, p0);
        return this;
    }

    /// setSizeIncrement
    QWidget setSizeIncrement(int w, int h) {
        (cast(t_v__qp_i_i)pFunQt[250])(_wh, w, h);
        return this;
    }

    /// baseSize
    DSize baseSize() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[251])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setBaseSize
    QWidget setBaseSize(void* p0) {
        (cast(t_v__qp_qp)pFunQt[252])(_wh, p0);
        return this;
    }

    /// setBaseSize
    QWidget setBaseSize(int basew, int baseh) {
        (cast(t_v__qp_i_i)pFunQt[253])(_wh, basew, baseh);
        return this;
    }

    /// setFixedSize
    QWidget setFixedSize(void* p0) {
        (cast(t_v__qp_qp)pFunQt[254])(_wh, p0);
        return this;
    }

    /// setFixedSize
    QWidget setFixedSize(int w, int h) {
        (cast(t_v__qp_i_i)pFunQt[255])(_wh, w, h);
        return this;
    }

    /// setFixedWidth
    QWidget setFixedWidth(int w) {
        (cast(t_v__qp_i)pFunQt[256])(_wh, w);
        return this;
    }

    /// setFixedHeight
    QWidget setFixedHeight(int h) {
        (cast(t_v__qp_i)pFunQt[257])(_wh, h);
        return this;
    }

    /// mapToGlobal
    DPoint mapToGlobal(void* p0) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[258])(_wh, p0);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// mapFromGlobal
    DPoint mapFromGlobal(void* p0) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[259])(_wh, p0);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// mapToParent
    DPoint mapToParent(void* p0) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[260])(_wh, p0);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// mapFromParent
    DPoint mapFromParent(void* p0) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp)pFunQt[261])(_wh, p0);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// mapTo
    DPoint mapTo(void* p0, void* p1) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp_qp)pFunQt[262])(_wh, p0, p1);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// mapFrom
    DPoint mapFrom(void* p0, void* p1) {
        DPoint _vt;
        void* _vtp = (cast(t_qp__qp_qp_qp)pFunQt[263])(_wh, p0, p1);
        (cast(t_v__qp_ip_ip)pFunQt[34])(_vtp, &_vt.x, &_vt.y);
        return _vt;
    }

    /// setBackgroundRole
    QWidget setBackgroundRole(int p0) {
        (cast(t_v__qp_i)pFunQt[264])(_wh, p0);
        return this;
    }

    /// backgroundRole
    int backgroundRole() {
        return cast(int)(cast(t_i__qp)pFunQt[265])(_wh);
    }

    /// setForegroundRole
    QWidget setForegroundRole(int p0) {
        (cast(t_v__qp_i)pFunQt[266])(_wh, p0);
        return this;
    }

    /// foregroundRole
    int foregroundRole() {
        return cast(int)(cast(t_i__qp)pFunQt[267])(_wh);
    }

    /// unsetCursor
    QWidget unsetCursor() {
        (cast(t_v__qp)pFunQt[271])(_wh);
        return this;
    }

    /// setMouseTracking
    QWidget setMouseTracking(bool enable) {
        (cast(t_v__qp_i)pFunQt[272])(_wh, enable ? 1 : 0);
        return this;
    }

    /// hasMouseTracking
    bool hasMouseTracking() {
        return cast(bool)(cast(t_i__qp)pFunQt[273])(_wh);
    }

    /// underMouse
    bool underMouse() {
        return cast(bool)(cast(t_i__qp)pFunQt[274])(_wh);
    }

    /// setTabletTracking
    QWidget setTabletTracking(bool enable) {
        (cast(t_v__qp_i)pFunQt[275])(_wh, enable ? 1 : 0);
        return this;
    }

    /// hasTabletTracking
    bool hasTabletTracking() {
        return cast(bool)(cast(t_i__qp)pFunQt[276])(_wh);
    }

    /// clearMask
    QWidget clearMask() {
        (cast(t_v__qp)pFunQt[278])(_wh);
        return this;
    }

    /// setGraphicsEffect
    QWidget setGraphicsEffect(void* effect) {
        (cast(t_v__qp_qp)pFunQt[279])(_wh, effect);
        return this;
    }

    /// ungrabGesture
    QWidget ungrabGesture(int type) {
        (cast(t_v__qp_i)pFunQt[280])(_wh, type);
        return this;
    }

    /// setWindowTitle
    QWidget setWindowTitle(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[203])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// setStyleSheet
    QWidget setStyleSheet(string styleSheet) {
        auto _ws_styleSheet = toQString(styleSheet);
        (cast(t_v__qp_qp)pFunQt[281])(_wh, _ws_styleSheet);
        (cast(t_v__qp)pFunQt[22])(_ws_styleSheet);
        return this;
    }

    /// styleSheet
    string styleSheet() {
        void* _qs = (cast(t_qp__qp)pFunQt[282])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// windowTitle
    string windowTitle() {
        void* _qs = (cast(t_qp__qp)pFunQt[283])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setWindowIconText
    QWidget setWindowIconText(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[284])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// windowIconText
    string windowIconText() {
        void* _qs = (cast(t_qp__qp)pFunQt[285])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setWindowRole
    QWidget setWindowRole(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[286])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// windowRole
    string windowRole() {
        void* _qs = (cast(t_qp__qp)pFunQt[287])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setWindowFilePath
    QWidget setWindowFilePath(string filePath) {
        auto _ws_filePath = toQString(filePath);
        (cast(t_v__qp_qp)pFunQt[288])(_wh, _ws_filePath);
        (cast(t_v__qp)pFunQt[22])(_ws_filePath);
        return this;
    }

    /// windowFilePath
    string windowFilePath() {
        void* _qs = (cast(t_qp__qp)pFunQt[289])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setWindowOpacity
    QWidget setWindowOpacity(double level) {
        (cast(t_v__qp_d)pFunQt[290])(_wh, level);
        return this;
    }

    /// windowOpacity
    double windowOpacity() {
        return cast(double)(cast(t_d__qp)pFunQt[291])(_wh);
    }

    /// isWindowModified
    bool isWindowModified() {
        return cast(bool)(cast(t_i__qp)pFunQt[292])(_wh);
    }

    /// setToolTip
    QWidget setToolTip(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[293])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// toolTip
    string toolTip() {
        void* _qs = (cast(t_qp__qp)pFunQt[294])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setToolTipDuration
    QWidget setToolTipDuration(int msec) {
        (cast(t_v__qp_i)pFunQt[295])(_wh, msec);
        return this;
    }

    /// toolTipDuration
    int toolTipDuration() {
        return cast(int)(cast(t_i__qp)pFunQt[296])(_wh);
    }

    /// setStatusTip
    QWidget setStatusTip(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[297])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// statusTip
    string statusTip() {
        void* _qs = (cast(t_qp__qp)pFunQt[298])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setWhatsThis
    QWidget setWhatsThis(string p0) {
        auto _ws_p0 = toQString(p0);
        (cast(t_v__qp_qp)pFunQt[299])(_wh, _ws_p0);
        (cast(t_v__qp)pFunQt[22])(_ws_p0);
        return this;
    }

    /// whatsThis
    string whatsThis() {
        void* _qs = (cast(t_qp__qp)pFunQt[300])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// accessibleName
    string accessibleName() {
        void* _qs = (cast(t_qp__qp)pFunQt[301])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setAccessibleName
    QWidget setAccessibleName(string name) {
        auto _ws_name = toQString(name);
        (cast(t_v__qp_qp)pFunQt[302])(_wh, _ws_name);
        (cast(t_v__qp)pFunQt[22])(_ws_name);
        return this;
    }

    /// accessibleDescription
    string accessibleDescription() {
        void* _qs = (cast(t_qp__qp)pFunQt[303])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }

    /// setAccessibleDescription
    QWidget setAccessibleDescription(string description) {
        auto _ws_description = toQString(description);
        (cast(t_v__qp_qp)pFunQt[304])(_wh, _ws_description);
        (cast(t_v__qp)pFunQt[22])(_ws_description);
        return this;
    }

    /// setLayoutDirection
    QWidget setLayoutDirection(int direction) {
        (cast(t_v__qp_i)pFunQt[305])(_wh, direction);
        return this;
    }

    /// layoutDirection
    int layoutDirection() {
        return cast(int)(cast(t_i__qp)pFunQt[306])(_wh);
    }

    /// unsetLayoutDirection
    QWidget unsetLayoutDirection() {
        (cast(t_v__qp)pFunQt[307])(_wh);
        return this;
    }

    /// unsetLocale
    QWidget unsetLocale() {
        (cast(t_v__qp)pFunQt[309])(_wh);
        return this;
    }

    /// isActiveWindow
    bool isActiveWindow() {
        return cast(bool)(cast(t_i__qp)pFunQt[310])(_wh);
    }

    /// activateWindow
    QWidget activateWindow() {
        (cast(t_v__qp)pFunQt[311])(_wh);
        return this;
    }

    /// clearFocus
    QWidget clearFocus() {
        (cast(t_v__qp)pFunQt[312])(_wh);
        return this;
    }

    /// setFocus
    QWidget setFocus(int reason) {
        (cast(t_v__qp_i)pFunQt[313])(_wh, reason);
        return this;
    }

    /// focusPolicy
    int focusPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[314])(_wh);
    }

    /// setFocusPolicy
    QWidget setFocusPolicy(int policy) {
        (cast(t_v__qp_i)pFunQt[315])(_wh, policy);
        return this;
    }

    /// hasFocus
    bool hasFocus() {
        return cast(bool)(cast(t_i__qp)pFunQt[316])(_wh);
    }

    /// setTabOrder
    QWidget setTabOrder(void* p0, void* p1) {
        (cast(t_v__qp_qp_qp)pFunQt[317])(_wh, p0, p1);
        return this;
    }

    /// setFocusProxy
    QWidget setFocusProxy(void* p0) {
        (cast(t_v__qp_qp)pFunQt[318])(_wh, p0);
        return this;
    }

    /// contextMenuPolicy
    int contextMenuPolicy() {
        return cast(int)(cast(t_i__qp)pFunQt[319])(_wh);
    }

    /// setContextMenuPolicy
    QWidget setContextMenuPolicy(int policy) {
        (cast(t_v__qp_i)pFunQt[320])(_wh, policy);
        return this;
    }

    /// grabMouse
    QWidget grabMouse() {
        (cast(t_v__qp)pFunQt[321])(_wh);
        return this;
    }

    /// releaseMouse
    QWidget releaseMouse() {
        (cast(t_v__qp)pFunQt[322])(_wh);
        return this;
    }

    /// grabKeyboard
    QWidget grabKeyboard() {
        (cast(t_v__qp)pFunQt[323])(_wh);
        return this;
    }

    /// releaseKeyboard
    QWidget releaseKeyboard() {
        (cast(t_v__qp)pFunQt[324])(_wh);
        return this;
    }

    /// releaseShortcut
    QWidget releaseShortcut(int id) {
        (cast(t_v__qp_i)pFunQt[325])(_wh, id);
        return this;
    }

    /// setShortcutEnabled
    QWidget setShortcutEnabled(int id, bool enable) {
        (cast(t_v__qp_i_i)pFunQt[326])(_wh, id, enable ? 1 : 0);
        return this;
    }

    /// setShortcutAutoRepeat
    QWidget setShortcutAutoRepeat(int id, bool enable) {
        (cast(t_v__qp_i_i)pFunQt[327])(_wh, id, enable ? 1 : 0);
        return this;
    }

    /// updatesEnabled
    bool updatesEnabled() {
        return cast(bool)(cast(t_i__qp)pFunQt[328])(_wh);
    }

    /// setUpdatesEnabled
    QWidget setUpdatesEnabled(bool enable) {
        (cast(t_v__qp_i)pFunQt[329])(_wh, enable ? 1 : 0);
        return this;
    }

    /// update
    QWidget update() {
        (cast(t_v__qp)pFunQt[330])(_wh);
        return this;
    }

    /// repaint
    QWidget repaint() {
        (cast(t_v__qp)pFunQt[331])(_wh);
        return this;
    }

    /// update
    QWidget update(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[332])(_wh, x, y, w, h);
        return this;
    }

    /// repaint
    QWidget repaint(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[333])(_wh, x, y, w, h);
        return this;
    }

    /// repaint
    QWidget repaint(void* p0) {
        (cast(t_v__qp_qp)pFunQt[334])(_wh, p0);
        return this;
    }

    /// setVisible
    QWidget setVisible(bool visible) {
        (cast(t_v__qp_i)pFunQt[335])(_wh, visible ? 1 : 0);
        return this;
    }

    /// setHidden
    QWidget setHidden(bool hidden) {
        (cast(t_v__qp_i)pFunQt[336])(_wh, hidden ? 1 : 0);
        return this;
    }

    /// show
    QWidget show() {
        (cast(t_v__qp)pFunQt[202])(_wh);
        return this;
    }

    /// hide
    QWidget hide() {
        (cast(t_v__qp)pFunQt[337])(_wh);
        return this;
    }

    /// showMinimized
    QWidget showMinimized() {
        (cast(t_v__qp)pFunQt[338])(_wh);
        return this;
    }

    /// showMaximized
    QWidget showMaximized() {
        (cast(t_v__qp)pFunQt[339])(_wh);
        return this;
    }

    /// showFullScreen
    QWidget showFullScreen() {
        (cast(t_v__qp)pFunQt[340])(_wh);
        return this;
    }

    /// showNormal
    QWidget showNormal() {
        (cast(t_v__qp)pFunQt[341])(_wh);
        return this;
    }

    /// close
    bool close() {
        return cast(bool)(cast(t_i__qp)pFunQt[342])(_wh);
    }

    /// raise
    QWidget raise() {
        (cast(t_v__qp)pFunQt[343])(_wh);
        return this;
    }

    /// lower
    QWidget lower() {
        (cast(t_v__qp)pFunQt[344])(_wh);
        return this;
    }

    /// stackUnder
    QWidget stackUnder(void* p0) {
        (cast(t_v__qp_qp)pFunQt[345])(_wh, p0);
        return this;
    }

    /// move
    QWidget move(int x, int y) {
        (cast(t_v__qp_i_i)pFunQt[346])(_wh, x, y);
        return this;
    }

    /// move
    QWidget move(void* p0) {
        (cast(t_v__qp_qp)pFunQt[347])(_wh, p0);
        return this;
    }

    /// resize
    QWidget resize(int w, int h) {
        (cast(t_v__qp_i_i)pFunQt[348])(_wh, w, h);
        return this;
    }

    /// resize
    QWidget resize(void* p0) {
        (cast(t_v__qp_qp)pFunQt[349])(_wh, p0);
        return this;
    }

    /// setGeometry
    QWidget setGeometry(int x, int y, int w, int h) {
        (cast(t_v__qp_i_i_i_i)pFunQt[350])(_wh, x, y, w, h);
        return this;
    }

    /// setGeometry
    QWidget setGeometry(void* p0) {
        (cast(t_v__qp_qp)pFunQt[351])(_wh, p0);
        return this;
    }

    /// adjustSize
    QWidget adjustSize() {
        (cast(t_v__qp)pFunQt[353])(_wh);
        return this;
    }

    /// isVisible
    bool isVisible() {
        return cast(bool)(cast(t_i__qp)pFunQt[354])(_wh);
    }

    /// isVisibleTo
    bool isVisibleTo(void* p0) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[355])(_wh, p0);
    }

    /// isHidden
    bool isHidden() {
        return cast(bool)(cast(t_i__qp)pFunQt[356])(_wh);
    }

    /// isMinimized
    bool isMinimized() {
        return cast(bool)(cast(t_i__qp)pFunQt[357])(_wh);
    }

    /// isMaximized
    bool isMaximized() {
        return cast(bool)(cast(t_i__qp)pFunQt[358])(_wh);
    }

    /// isFullScreen
    bool isFullScreen() {
        return cast(bool)(cast(t_i__qp)pFunQt[359])(_wh);
    }

    /// windowState
    int windowState() {
        return cast(int)(cast(t_i__qp)pFunQt[360])(_wh);
    }

    /// setWindowState
    QWidget setWindowState(int state) {
        (cast(t_v__qp_i)pFunQt[361])(_wh, state);
        return this;
    }

    /// overrideWindowState
    QWidget overrideWindowState(int state) {
        (cast(t_v__qp_i)pFunQt[362])(_wh, state);
        return this;
    }

    /// sizeHint
    DSize sizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[363])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// minimumSizeHint
    DSize minimumSizeHint() {
        DSize _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[364])(_wh);
        (cast(t_v__qp_ip_ip)pFunQt[37])(_vtp, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setSizePolicy
    QWidget setSizePolicy(int horizontal, int vertical) {
        (cast(t_v__qp_i_i)pFunQt[365])(_wh, horizontal, vertical);
        return this;
    }

    /// heightForWidth
    int heightForWidth(int p0) {
        return cast(int)(cast(t_i__qp_i)pFunQt[368])(_wh, p0);
    }

    /// hasHeightForWidth
    bool hasHeightForWidth() {
        return cast(bool)(cast(t_i__qp)pFunQt[369])(_wh);
    }

    /// setContentsMargins
    QWidget setContentsMargins(int left, int top, int right, int bottom) {
        (cast(t_v__qp_i_i_i_i)pFunQt[371])(_wh, left, top, right, bottom);
        return this;
    }

    /// getContentsMargins
    QWidget getContentsMargins(void* left, void* top, void* right, void* bottom) {
        (cast(t_v__qp_qp_qp_qp_qp)pFunQt[372])(_wh, left, top, right, bottom);
        return this;
    }

    /// contentsRect
    DRect contentsRect() {
        DRect _vt;
        void* _vtp = (cast(t_qp__qp)pFunQt[374])(_wh);
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[31])(_vtp, &_vt.x, &_vt.y, &_vt.w, &_vt.h);
        return _vt;
    }

    /// setLayout
    QWidget setLayout(void* p0) {
        (cast(t_v__qp_qp)pFunQt[205])(_wh, p0);
        return this;
    }

    /// Типизированная версия setLayout: работает с QVBoxLayout, QHBoxLayout,
    /// QGridLayout, QFormLayout — любым D-типом у которого есть disown()/getWH().
    QWidget setLayout(L)(L layout)
        if (is(typeof(layout.disown())) && !is(L == void*))
    {
        if (layout is null) return null;
        auto lh = layout.getWH();
        layout.disown();
        (cast(t_v__qp_qp)pFunQt[205])(_wh, lh);
        return this;
    }

    /// updateGeometry
    QWidget updateGeometry() {
        (cast(t_v__qp)pFunQt[375])(_wh);
        return this;
    }

    /// setParent
    override QWidget setParent(void* parent) {
        (cast(t_v__qp_qp)pFunQt[376])(_wh, parent);
        return this;
    }

    /// Типизированная версия setParent: передаёт ownership если parent != null.
    /// setParent(null) возвращает виджет из Qt — disown() не вызывается.
    override QWidget setParent(QObject parent) {
        if (parent !is null) this.disown();
        auto ph = (parent !is null) ? parent.getWH() : null;
        (cast(t_v__qp_qp)pFunQt[376])(_wh, ph);
        return this;
    }

    /// setParent
    QWidget setParent(void* parent, int f) {
        (cast(t_v__qp_qp_i)pFunQt[377])(_wh, parent, f);
        return this;
    }

    /// scroll
    QWidget scroll(int dx, int dy) {
        (cast(t_v__qp_i_i)pFunQt[378])(_wh, dx, dy);
        return this;
    }

    /// acceptDrops
    bool acceptDrops() {
        return cast(bool)(cast(t_i__qp)pFunQt[379])(_wh);
    }

    /// setAcceptDrops
    QWidget setAcceptDrops(bool on) {
        (cast(t_v__qp_i)pFunQt[380])(_wh, on ? 1 : 0);
        return this;
    }

    /// addAction
    QWidget addAction(void* action) {
        (cast(t_v__qp_qp)pFunQt[381])(_wh, action);
        return this;
    }

    /// insertAction
    QWidget insertAction(void* before, void* action) {
        (cast(t_v__qp_qp_qp)pFunQt[382])(_wh, before, action);
        return this;
    }

    /// removeAction
    QWidget removeAction(void* action) {
        (cast(t_v__qp_qp)pFunQt[383])(_wh, action);
        return this;
    }

    /// setWindowFlags
    QWidget setWindowFlags(int type) {
        (cast(t_v__qp_i)pFunQt[384])(_wh, type);
        return this;
    }

    /// windowFlags
    int windowFlags() {
        return cast(int)(cast(t_i__qp)pFunQt[385])(_wh);
    }

    /// setWindowFlag
    QWidget setWindowFlag(int p0, bool on) {
        (cast(t_v__qp_i_i)pFunQt[386])(_wh, p0, on ? 1 : 0);
        return this;
    }

    /// overrideWindowFlags
    QWidget overrideWindowFlags(int type) {
        (cast(t_v__qp_i)pFunQt[387])(_wh, type);
        return this;
    }

    /// windowType
    int windowType() {
        return cast(int)(cast(t_i__qp)pFunQt[388])(_wh);
    }

    /// setAttribute
    QWidget setAttribute(int p0, bool on) {
        (cast(t_v__qp_i_i)pFunQt[389])(_wh, p0, on ? 1 : 0);
        return this;
    }

    /// testAttribute
    bool testAttribute(int p0) {
        return cast(bool)(cast(t_i__qp_i)pFunQt[390])(_wh, p0);
    }

    /// ensurePolished
    QWidget ensurePolished() {
        (cast(t_v__qp)pFunQt[391])(_wh);
        return this;
    }

    /// isAncestorOf
    bool isAncestorOf(void* child) {
        return cast(bool)(cast(t_i__qp_qp)pFunQt[392])(_wh, child);
    }

    /// autoFillBackground
    bool autoFillBackground() {
        return cast(bool)(cast(t_i__qp)pFunQt[393])(_wh);
    }

    /// setAutoFillBackground
    QWidget setAutoFillBackground(bool enabled) {
        (cast(t_v__qp_i)pFunQt[394])(_wh, enabled ? 1 : 0);
        return this;
    }

    /// inputMethodHints
    int inputMethodHints() {
        return cast(int)(cast(t_i__qp)pFunQt[395])(_wh);
    }

    /// setInputMethodHints
    QWidget setInputMethodHints(int hints) {
        (cast(t_v__qp_i)pFunQt[396])(_wh, hints);
        return this;
    }

    /// Connect signal windowTitleChanged → ESlot
    QWidget connect_windowTitleChanged(ESlot eslot) {
        connectQt(_wh, "windowTitleChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal windowIconTextChanged → ESlot
    QWidget connect_windowIconTextChanged(ESlot eslot) {
        connectQt(_wh, "windowIconTextChanged(const QString&)", eslot, "invoke_s(const QString&)");
        return this;
    }

    /// Connect signal customContextMenuRequested → ESlot
    QWidget connect_customContextMenuRequested(ESlot eslot) {
        connectQt(_wh, "customContextMenuRequested(const QPoint&)", eslot, "invoke_p(const QPoint&)");
        return this;
    }

    // ── Event handlers ──────────────────────────────────────────────────────
    /// Установить callback для Qt-события по EventId.
    /// cb и dthis можно передавать null для отмены обработки.
    QWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[397])(_wh, eventId, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QWidget onMousePress(void* cb, void* dthis = null) {
        setEventHandler(1, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QWidget onMouseRelease(void* cb, void* dthis = null) {
        setEventHandler(2, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int button)
    QWidget onMouseDoubleClick(void* cb, void* dthis = null) {
        setEventHandler(3, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QWidget onMouseMove(void* cb, void* dthis = null) {
        setEventHandler(4, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QWidget onKeyPress(void* cb, void* dthis = null) {
        setEventHandler(5, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent
    /// cb: extern(C) void function(void* dthis, int key, int modifiers)
    QWidget onKeyRelease(void* cb, void* dthis = null) {
        setEventHandler(6, cb, dthis);
        return this;
    }

    /// Qt event: resizeEvent
    /// cb: extern(C) void function(void* dthis, int w, int h)
    QWidget onResize(void* cb, void* dthis = null) {
        setEventHandler(7, cb, dthis);
        return this;
    }

    /// Qt event: moveEvent
    /// cb: extern(C) void function(void* dthis, int x, int y)
    QWidget onMove(void* cb, void* dthis = null) {
        setEventHandler(8, cb, dthis);
        return this;
    }

    /// Qt event: closeEvent
    /// cb: extern(C) void function(void* dthis, int* accept)
    QWidget onClose(void* cb, void* dthis = null) {
        setEventHandler(9, cb, dthis);
        return this;
    }

    /// Qt event: showEvent
    /// cb: extern(C) void function(void* dthis)
    QWidget onShow(void* cb, void* dthis = null) {
        setEventHandler(10, cb, dthis);
        return this;
    }

    /// Qt event: hideEvent
    /// cb: extern(C) void function(void* dthis)
    QWidget onHide(void* cb, void* dthis = null) {
        setEventHandler(11, cb, dthis);
        return this;
    }

    /// Qt event: enterEvent
    /// cb: extern(C) void function(void* dthis)
    QWidget onEnter(void* cb, void* dthis = null) {
        setEventHandler(12, cb, dthis);
        return this;
    }

    /// Qt event: leaveEvent
    /// cb: extern(C) void function(void* dthis)
    QWidget onLeave(void* cb, void* dthis = null) {
        setEventHandler(13, cb, dthis);
        return this;
    }

    /// Qt event: wheelEvent
    /// cb: extern(C) void function(void* dthis, int dx, int dy)
    QWidget onWheel(void* cb, void* dthis = null) {
        setEventHandler(14, cb, dthis);
        return this;
    }

    /// Qt event: focusInEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QWidget onFocusIn(void* cb, void* dthis = null) {
        setEventHandler(15, cb, dthis);
        return this;
    }

    /// Qt event: focusOutEvent
    /// cb: extern(C) void function(void* dthis, int reason)
    QWidget onFocusOut(void* cb, void* dthis = null) {
        setEventHandler(16, cb, dthis);
        return this;
    }

    /// Qt event: contextMenuEvent
    /// cb: extern(C) void function(void* dthis, int x, int y, int reason)
    QWidget onContextMenu(void* cb, void* dthis = null) {
        setEventHandler(17, cb, dthis);
        return this;
    }

    /// Qt event: paintEvent
    /// cb: extern(C) void function(void* dthis, void* widget)
    /// In callback: create QPainter, draw, call p.end() before returning.
    /// Example:
    ///   extern(C) void myPaint(void* dthis, void* widget) {
    ///       auto p = new QPainter(widget, true); // begin on widget
    ///       p.drawRect(10, 10, 100, 50);
    ///       p.end();
    ///   }
    QWidget onPaint(void* cb, void* dthis = null) {
        setEventHandler(18, cb, dthis);
        return this;
    }

    // ── Full event handlers (id 19..25) ──────────────────────────────────────
    // Расширенный API: callback получает указатель на EventInfo-структуру со
    // ВСЕМИ полями события и возвращает int consumed
    //   1 = обработано (Qt не вызывает default-handler),
    //   0 = passthrough (Qt продолжает обработку).
    // Если установлены ОБА callback'а (старый и Full) — приоритет у Full.
    // Если Full вернул 0, событие проходит к простому callback'у / Qt-default.

    /// Qt event: wheelEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, WheelEventInfo* info)
    /// return 1 = consumed, 0 = passthrough к default Qt-скроллу.
    QWidget onWheelFull(void* cb, void* dthis = null) {
        setEventHandler(19, cb, dthis);
        return this;
    }

    /// Qt event: mousePressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    QWidget onMousePressFull(void* cb, void* dthis = null) {
        setEventHandler(20, cb, dthis);
        return this;
    }

    /// Qt event: mouseReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    QWidget onMouseReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(21, cb, dthis);
        return this;
    }

    /// Qt event: mouseMoveEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    QWidget onMouseMoveFull(void* cb, void* dthis = null) {
        setEventHandler(22, cb, dthis);
        return this;
    }

    /// Qt event: mouseDoubleClickEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, MouseEventInfo* info)
    QWidget onMouseDoubleClickFull(void* cb, void* dthis = null) {
        setEventHandler(23, cb, dthis);
        return this;
    }

    /// Qt event: keyPressEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    /// info.text — QString* с введённым символом (Unicode), read-only.
    QWidget onKeyPressFull(void* cb, void* dthis = null) {
        setEventHandler(24, cb, dthis);
        return this;
    }

    /// Qt event: keyReleaseEvent (расширенный)
    /// cb: extern(C) int function(void* dthis, KeyEventInfo* info)
    QWidget onKeyReleaseFull(void* cb, void* dthis = null) {
        setEventHandler(25, cb, dthis);
        return this;
    }

    // ── QFont helpers ────────────────────────────────────────────────────────

    /// Apply a QFont to this widget.
    QWidget setFont(QFont f) {
        (cast(t_v__qp_qp)pFunQt[10258])(_wh, f.getWH());
        return this;
    }

    /// Get the current font of this widget — returns caller-owned QFont copy.
    QFont fontObj() {
        void* p = (cast(t_qp__qp)pFunQt[10259])(_wh);
        return QFont.wrap(p);
    }


    // ── Geometry persistence ─────────────────────────────────────────────────

    /// Save window geometry (position, size, state) to a QByteArray.
    /// Persist with QSettings.setBytes(); restore with restoreGeometry().
    QByteArray saveGeometry() {
        void* ba = (cast(t_qp__qp)pFunQt[398])(_wh);
        return QByteArray.wrap(ba);
    }

    /// Restore window geometry from a previously saved QByteArray.
    /// Returns true on success.
    bool restoreGeometry(QByteArray geo) {
        auto sl = geo.toSlice();
        return (cast(t_i__qp_qp_i)pFunQt[399])(
            _wh, cast(void*)sl.ptr, cast(int)sl.length) != 0;
    }

    /// Convenience: restore from raw bytes.
    bool restoreGeometry(const(ubyte)[] data) {
        return (cast(t_i__qp_qp_i)pFunQt[399])(
            _wh, cast(void*)data.ptr, cast(int)data.length) != 0;
    }

} // class QWidget
