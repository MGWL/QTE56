"""
type_map.py — маппинг C++ типов Qt → D типы и alias-ключи.
"""

from typing import Optional

# ──────────────────────────────────────────────────────────────────────────────
# Главная таблица маппинга
#
# cpp_type → (d_type, pass_as, needs_conv)
#   d_type    : тип в D коде
#   pass_as   : "value" | "out" | "ptr"
#   needs_conv: True если нужна конвертация (напр. QString → toQString())
# ──────────────────────────────────────────────────────────────────────────────

_TYPE_MAP: dict[str, tuple[str, str, bool]] = {
    # Void
    "void":                     ("void",    "value", False),

    # Булев
    "bool":                     ("bool",    "value", False),

    # Целые
    "int":                      ("int",     "value", False),
    "unsigned int":              ("uint",    "value", False),
    "uint":                     ("uint",    "value", False),
    "long":                     ("int",     "value", False),  # Windows LLP64: long=4 bytes on both 32/64-bit
    "unsigned long":            ("uint",    "value", False),  # Windows LLP64: unsigned long=4 bytes
    "qint64":                   ("long",    "value", False),
    "quint64":                  ("ulong",   "value", False),
    "short":                    ("int",     "value", False),
    "qreal":                    ("double",  "value", False),
    "size_t":                   ("size_t",  "value", False),  # pointer-sized unsigned
    "intptr_t":                 ("size_t",  "value", False),  # pointer-sized signed (D: ptrdiff_t)
    "WId":                      ("size_t",  "value", False),  # Qt window handle: pointer-sized

    # Вещественные
    "double":                   ("double",  "value", False),
    "float":                    ("float",   "value", False),

    # Указатели на примитивы (out-параметры)
    "int*":                     ("void*",   "out",   False),  # передаётся как void*, C++ кастует в int*
    "const int*":               ("void*",   "out",   False),
    "bool*":                    ("void*",   "out",   False),
    "double*":                  ("void*",   "out",   False),

    # Qt строки
    "QString":                  ("string",  "value", True),
    "const QString&":           ("string",  "value", True),
    "QString&":                 ("string",  "value", True),

    # Qt объекты — передаются как void* (QtObjH)
    "QWidget*":                 ("void*",   "ptr",   False),
    "const QWidget*":           ("void*",   "ptr",   False),
    "QObject*":                 ("void*",   "ptr",   False),
    "const QObject*":           ("void*",   "ptr",   False),
    "QFrame*":                  ("void*",   "ptr",   False),
    "QLabel*":                  ("void*",   "ptr",   False),
    "QPushButton*":             ("void*",   "ptr",   False),
    "QLayout*":                 ("void*",   "ptr",   False),
    "QBoxLayout*":              ("void*",   "ptr",   False),
    "QVBoxLayout*":             ("void*",   "ptr",   False),
    "QHBoxLayout*":             ("void*",   "ptr",   False),
    "QStyle*":                  ("void*",   "ptr",   False),
    "QAction*":                 ("void*",   "ptr",   False),
    "const QAction*":           ("void*",   "ptr",   False),
    "QMenu*":                   ("void*",   "ptr",   False),
    "QMenuBar*":                ("void*",   "ptr",   False),
    "QStatusBar*":              ("void*",   "ptr",   False),
    "QGraphicsEffect*":         ("void*",   "ptr",   False),
    "QPaintDevice*":            ("void*",   "ptr",   False),
    "const QPaintDevice*":      ("void*",   "ptr",   False),

    # QIcon — value type passed as opaque void* (heap-allocated QIcon*)
    "const QIcon&":             ("void*",   "ptr",   False),
    "QIcon":                    ("void*",   "ptr",   False),

    # Qt Multimedia value types
    "QUrl":                     ("void*",   "ptr",   False),
    "const QUrl&":              ("void*",   "ptr",   False),
    "QMediaContent":            ("void*",   "ptr",   False),
    "const QMediaContent&":     ("void*",   "ptr",   False),
    "QNetworkConfiguration":    ("void*",   "ptr",   False),
    "const QNetworkConfiguration&": ("void*", "ptr", False),
    "QIODevice*":               ("void*",   "ptr",   False),

    # QFont — value type passed by const reference; return = heap-allocated copy
    "const QFont&":             ("void*",   "ptr",   False),
    "QFont&":                   ("void*",   "ptr",   False),
    "QFont":                    ("QFont_v", "value", False),   # return: new QFont(...)

    # QColor — value type passed by const reference; return = heap-allocated copy
    "const QColor&":            ("void*",   "ptr",   False),
    "QColor&":                  ("void*",   "ptr",   False),
    "QColor":                   ("QColor_v","value", False),   # return: new QColor(...)

    # QRgb — typedef for unsigned int (QColor::rgba(), rgb())
    "QRgb":                     ("uint",    "value", False),

    # Qt value-types (возвращаются как heap-allocated, нужны pack/unpack)
    "QRect":                    ("DRect",   "value", False),
    "const QRect&":             ("DRect",   "value", False),
    "QPoint":                   ("DPoint",  "value", False),
    "const QPoint&":            ("DPoint",  "value", False),
    "QSize":                    ("DSize",   "value", False),
    "const QSize&":             ("DSize",   "value", False),

    # QPixmap / QImage — opaque void* (heap-allocated); модули gen_qpixmap /
    # gen_qimage существуют, паттерн передачи — сырой указатель (как QIcon).
    "QPixmap":                  ("void*",   "ptr",   False),
    "const QPixmap&":           ("void*",   "ptr",   False),
    "QImage":                   ("void*",   "ptr",   False),
    "const QImage&":            ("void*",   "ptr",   False),

    # QPointF / QRectF — qreal-версии геометрии. Возврат по значению:
    # heap-allocated копия (паттерн QFont_v), D получает opaque void*.
    "QPointF":                  ("QPointF_v", "value", False),
    "const QPointF&":           ("void*",   "ptr",   False),
    "QPointF&":                 ("void*",   "ptr",   False),
    "QRectF":                   ("QRectF_v",  "value", False),
    "const QRectF&":            ("void*",   "ptr",   False),
    "QRectF&":                  ("void*",   "ptr",   False),

    # QStringList — opaque void*; на D-стороне toQStringList/freeQStringList
    # (см. AGENTS.md §5). Передаётся как сырой указатель.
    "QStringList":              ("void*",   "ptr",   False),
    "const QStringList&":       ("void*",   "ptr",   False),

    # Qt enum types — передаём как int
    "Qt::WindowModality":       ("int",     "value", False),
    "Qt::WindowFlags":          ("int",     "value", False),
    "Qt::WindowType":           ("int",     "value", False),
    "Qt::WindowState":          ("int",     "value", False),
    "Qt::WindowStates":         ("int",     "value", False),
    "Qt::FocusPolicy":          ("int",     "value", False),
    "Qt::FocusReason":          ("int",     "value", False),
    "Qt::ContextMenuPolicy":    ("int",     "value", False),
    "Qt::LayoutDirection":      ("int",     "value", False),
    "Qt::InputMethodHints":     ("int",     "value", False),
    "Qt::WidgetAttribute":      ("int",     "value", False),
    "Qt::GestureType":          ("int",     "value", False),
    "Qt::ConnectionType":       ("int",     "value", False),
    "QFrame::Shape":            ("int",     "value", False),
    "QFrame::Shadow":           ("int",     "value", False),
    "QFrame::StyleMask":        ("int",     "value", False),
    "QPalette::ColorRole":      ("int",     "value", False),
    "QSizePolicy::Policy":      ("int",     "value", False),
}

# ──────────────────────────────────────────────────────────────────────────────
# Типы, которые принципиально не поддерживаются
# ──────────────────────────────────────────────────────────────────────────────

UNSUPPORTED_TYPES = frozenset({
    "QVariant", "QVariant&", "const QVariant&",
    "QModelIndex", "const QModelIndex&",
    "QPainter*",
    "QRegion", "const QRegion&",
    "QBitmap",
    "QByteArray", "const QByteArray&",
    "QList", "QVector", "QMap", "QHash",
    "std::function",
    # Note: QUrl, QMediaContent, QNetworkConfiguration, QPixmap, QImage,
    #       QStringList are supported as opaque void*
})

# ──────────────────────────────────────────────────────────────────────────────
# D value-type структуры (для unpack)
# ──────────────────────────────────────────────────────────────────────────────

# cpp_type → (d_struct_name, [(cpp_getter, field_name)], unpack_args)
D_STRUCT_TYPES: dict[str, tuple] = {
    "QRect":  ("DRect",  [("x","x"),("y","y"),("width","w"),("height","h")]),
    "QPoint": ("DPoint", [("x","x"),("y","y")]),
    "QSize":  ("DSize",  [("width","w"),("height","h")]),
}

# ──────────────────────────────────────────────────────────────────────────────
# Публичный API
# ──────────────────────────────────────────────────────────────────────────────

def cpp_type_to_d(cpp_type: str) -> Optional[tuple[str, str, bool]]:
    """
    Возвращает (d_type, pass_as, needs_conv) или None если тип не поддерживается.
    """
    import re
    t = cpp_type.strip()
    if t in UNSUPPORTED_TYPES:
        return None
    result = _TYPE_MAP.get(t)
    if result:
        return result
    # Неизвестные указатели на Q-объекты → void*
    if t.endswith("*") and (t.startswith("Q") or "const Q" in t):
        return ("void*", "ptr", False)
    # Общий фоллбэк для Qt:: и QClass:: enum/flags → int.
    # Примеры: Qt::Alignment, Qt::TextFormat, Qt::CursorMoveStyle,
    #          QFrame::Shape (уже в _TYPE_MAP, но сюда не дойдёт),
    #          Qt::TextInteractionFlags и т.д.
    # Условие: нет '<' (не шаблон), нет '*'/'&' (не указатель/ссылка).
    if (re.match(r'^(?:Qt|Q\w+)::\w+$', t)
            and '<' not in t and '*' not in t and '&' not in t):
        return ("int", "value", False)
    return None


def is_value_type(cpp_type: str) -> bool:
    """True если тип является Qt value-type (QRect, QPoint, QSize)."""
    t = cpp_type.strip().replace("const ", "").replace("&", "").strip()
    return t in D_STRUCT_TYPES


def get_d_struct_info(raw_type: str) -> Optional[tuple]:
    """Возвращает (d_struct_name, fields) или None."""
    return D_STRUCT_TYPES.get(raw_type)


def type_to_alias_key(d_type: str) -> str:
    """Преобразует D тип в ключ для generateAlias."""
    _MAP = {
        "void":   "v",
        "bool":   "b",
        "int":    "i",
        "uint":   "ui",
        "long":   "l",
        "ulong":  "ul",
        "double": "d",
        "float":  "f",
        "size_t": "sz",
        "void*":  "qp",
        "string": "qp",   # QString передаётся как void*
        "int*":   "ip",
        "bool*":  "bp",
        "double*":"qp",
        "DRect":  "qp",
        "DPoint": "qp",
        "DSize":  "qp",
    }
    return _MAP.get(d_type, "qp")
