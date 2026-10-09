"""
events.py — описание виртуальных Qt-событий для генерации proxy-класса.

Для каждого события определены:
  id           — EventId (1..N), совпадает с D-side EventId enum
  qt_type      — C++ тип аргумента события ("QMouseEvent", "QEvent", ...)
  cpp_extract  — выражения для передачи в D callback через запятую
                 (пустая строка = нет параметров кроме dthis)
  cb_cast      — C++ cast для callback
  d_params     — [(d_type, param_name), ...] — параметры D callback после dthis
  headers      — Qt заголовки для #include в .cpp (без угловых скобок)

Специальный случай closeEvent:
  cpp_extract = "CLOSE_SPECIAL" — proxy генерирует int accept = 1; ... e->ignore()
"""

from dataclasses import dataclass, field
from typing import List, Tuple


@dataclass
class EventSpec:
    id: int
    qt_type: str
    cpp_extract: str               # "CLOSE_SPECIAL" или список выражений
    cb_cast: str
    d_params: List[Tuple[str, str]]
    headers: List[str]


# ─────────────────────────────────────────────────────────────────────────────
# Таблица событий. Порядок = EventId в D enum.

EVENT_SPECS = {
    "mousePressEvent": EventSpec(
        id=1, qt_type="QMouseEvent",
        cpp_extract="e->x(), e->y(), (int)e->button()",
        cb_cast="void(*)(void*,int,int,int)",
        d_params=[("int","x"), ("int","y"), ("int","button")],
        headers=["QMouseEvent"],
    ),
    "mouseReleaseEvent": EventSpec(
        id=2, qt_type="QMouseEvent",
        cpp_extract="e->x(), e->y(), (int)e->button()",
        cb_cast="void(*)(void*,int,int,int)",
        d_params=[("int","x"), ("int","y"), ("int","button")],
        headers=["QMouseEvent"],
    ),
    "mouseDoubleClickEvent": EventSpec(
        id=3, qt_type="QMouseEvent",
        cpp_extract="e->x(), e->y(), (int)e->button()",
        cb_cast="void(*)(void*,int,int,int)",
        d_params=[("int","x"), ("int","y"), ("int","button")],
        headers=["QMouseEvent"],
    ),
    "mouseMoveEvent": EventSpec(
        id=4, qt_type="QMouseEvent",
        cpp_extract="e->x(), e->y()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","x"), ("int","y")],
        headers=["QMouseEvent"],
    ),
    "keyPressEvent": EventSpec(
        id=5, qt_type="QKeyEvent",
        cpp_extract="(int)e->key(), (int)e->modifiers()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","key"), ("int","modifiers")],
        headers=["QKeyEvent"],
    ),
    "keyReleaseEvent": EventSpec(
        id=6, qt_type="QKeyEvent",
        cpp_extract="(int)e->key(), (int)e->modifiers()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","key"), ("int","modifiers")],
        headers=["QKeyEvent"],
    ),
    "resizeEvent": EventSpec(
        id=7, qt_type="QResizeEvent",
        cpp_extract="e->size().width(), e->size().height()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","w"), ("int","h")],
        headers=["QResizeEvent"],
    ),
    "moveEvent": EventSpec(
        id=8, qt_type="QMoveEvent",
        cpp_extract="e->pos().x(), e->pos().y()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","x"), ("int","y")],
        headers=["QMoveEvent"],
    ),
    "closeEvent": EventSpec(
        id=9, qt_type="QCloseEvent",
        cpp_extract="CLOSE_SPECIAL",
        cb_cast="void(*)(void*,int*)",
        d_params=[("int*","accept")],
        headers=["QCloseEvent"],
    ),
    "showEvent": EventSpec(
        id=10, qt_type="QShowEvent",
        cpp_extract="",
        cb_cast="void(*)(void*)",
        d_params=[],
        headers=["QShowEvent"],
    ),
    "hideEvent": EventSpec(
        id=11, qt_type="QHideEvent",
        cpp_extract="",
        cb_cast="void(*)(void*)",
        d_params=[],
        headers=["QHideEvent"],
    ),
    "enterEvent": EventSpec(
        id=12, qt_type="QEvent",
        cpp_extract="",
        cb_cast="void(*)(void*)",
        d_params=[],
        headers=[],
    ),
    "leaveEvent": EventSpec(
        id=13, qt_type="QEvent",
        cpp_extract="",
        cb_cast="void(*)(void*)",
        d_params=[],
        headers=[],
    ),
    "wheelEvent": EventSpec(
        id=14, qt_type="QWheelEvent",
        cpp_extract="e->angleDelta().x(), e->angleDelta().y()",
        cb_cast="void(*)(void*,int,int)",
        d_params=[("int","dx"), ("int","dy")],
        headers=["QWheelEvent"],
    ),
    "focusInEvent": EventSpec(
        id=15, qt_type="QFocusEvent",
        cpp_extract="(int)e->reason()",
        cb_cast="void(*)(void*,int)",
        d_params=[("int","reason")],
        headers=["QFocusEvent"],
    ),
    "focusOutEvent": EventSpec(
        id=16, qt_type="QFocusEvent",
        cpp_extract="(int)e->reason()",
        cb_cast="void(*)(void*,int)",
        d_params=[("int","reason")],
        headers=["QFocusEvent"],
    ),
    "contextMenuEvent": EventSpec(
        id=17, qt_type="QContextMenuEvent",
        cpp_extract="e->x(), e->y(), (int)e->reason()",
        cb_cast="void(*)(void*,int,int,int)",
        d_params=[("int","x"), ("int","y"), ("int","reason")],
        headers=["QContextMenuEvent"],
    ),
}

# Уникальные Qt-заголовки для всех событий (без дублей)
ALL_EVENT_HEADERS = sorted({
    h for spec in EVENT_SPECS.values() for h in spec.headers
})

# D-имя обёртки для каждого события (метода onXxx в классе)
EVENT_D_METHOD = {
    "mousePressEvent":       "onMousePress",
    "mouseReleaseEvent":     "onMouseRelease",
    "mouseDoubleClickEvent": "onMouseDoubleClick",
    "mouseMoveEvent":        "onMouseMove",
    "keyPressEvent":         "onKeyPress",
    "keyReleaseEvent":       "onKeyRelease",
    "resizeEvent":           "onResize",
    "moveEvent":             "onMove",
    "closeEvent":            "onClose",
    "showEvent":             "onShow",
    "hideEvent":             "onHide",
    "enterEvent":            "onEnter",
    "leaveEvent":            "onLeave",
    "wheelEvent":            "onWheel",
    "focusInEvent":          "onFocusIn",
    "focusOutEvent":         "onFocusOut",
    "contextMenuEvent":      "onContextMenu",
}
