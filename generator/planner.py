"""
planner.py — планирование методов класса: фильтрация, именование,
суффиксы перегрузок, регистрация функций в реестре.

Выделено из main.py. Ничего не знает про CLI и запись файлов;
единственный побочный эффект — добавление записей в переданный Registry
(in-memory; сохранение CSV — ответственность вызывающего).
"""

from dataclasses import dataclass
from collections import Counter

from registry import Registry
from qt_parser import QtClass, QtMethod


# ─────────────────────────────────────────────────────────────────────────────
# MethodSpec — описание одного метода

@dataclass
class MethodSpec:
    qt_name:   str          # имя метода в D/Qt ("setText")
    func_name: str          # имя C++ функции ("qteQLabel_setText")
    idx:       int          # pFunQt индекс
    params:    list         # список QtParam (оригинальные Qt параметры)
    ret_d:     str          # D тип возврата ("void", "string", "int", ...)
    category:  str = "method"


# ─────────────────────────────────────────────────────────────────────────────
# Стандартные QWidget-методы, добавляемые во все подклассы QWidget

# Tuple: (method_name, ret_d, [(cpp_type, param_name)])
# Добавляются если NOT уже найдены в заголовке
_STANDARD_QWIDGET = [
    ("show",    "void",  []),
    ("hide",    "void",  []),
    ("update",  "void",  []),
]

# Виртуальные методы QWidget, которые НЕ генерируются в D классе-потомке.
# QWidget.sizeHint() → C++ vtable → реализация дочернего класса.
# heightForWidth — виртуальный, D конфликт без override. QWidget vtable диспатчит.
_QWIDGET_VIRTUAL_SKIP = frozenset({
    "show", "hide", "update",
    "sizeHint", "minimumSizeHint",
    "heightForWidth", "hasHeightForWidth",
    "setVisible",   # QMenuBar overrides this slot; QWidget vtable dispatches correctly
})


def _compute_skip_methods(d_parent: str) -> frozenset:
    """Collect methods to skip: QWidget virtuals + all ancestor intermediate methods.

    Walks the D_PARENT_FULL chain from d_parent up to QWidget,
    collecting INTERMEDIATE_METHODS for each ancestor along the way.
    Example: d_parent=QFrame → skip QWidget virtuals + QFrame methods (13).
    """
    from qt_hierarchy import INTERMEDIATE_METHODS, D_PARENT_FULL
    skip = set(_QWIDGET_VIRTUAL_SKIP)
    current = d_parent
    while current and current != "QWidget":
        if current in INTERMEDIATE_METHODS:
            skip.update(INTERMEDIATE_METHODS[current])
        current = D_PARENT_FULL.get(current, "")
    return frozenset(skip)


class _SyntheticParam:
    """Простой контейнер для синтетического параметра (без QtParam)."""
    def __init__(self, cpp_type: str, name: str):
        self.cpp_type = cpp_type
        self.name = name
        self.default = ""
        self.d_type = ""


def _is_qwidget_subclass(qt_class: QtClass) -> bool:
    """True если класс — подкласс QWidget.
    При наличии базы знаний — точная проверка по транзитивному замыканию,
    иначе — прежняя эвристика."""
    from knowledge_access import get_knowledge
    kb = get_knowledge()
    if kb is not None:
        return kb.is_widget_subclass(qt_class.name)
    # Эвристика (fallback без knowledge)
    all_parents = [p.lower() for p in qt_class.parents]
    qwidget_hierarchy = {
        "qwidget", "qframe", "qlabel", "qabstractscrollarea",
        "qabstractbutton", "qpushbutton", "qcheckbox", "qradiobutton",
        "qdialog", "qmainwindow", "qgroupbox", "qcombobox",
        "qlineedit", "qtextedit", "qplaintextedit", "qspinbox",
        "qdoublespinbox", "qslider", "qprogressbar", "qscrollbar",
        "qtoolbar", "qstatusbar", "qmenu", "qmenubar",
    }
    name_lower = qt_class.name.lower()
    if name_lower in qwidget_hierarchy:
        return True
    for p in all_parents:
        if p in qwidget_hierarchy:
            return True
    # Эвристика: если имя заканчивается на Widget или содержит widget
    if "widget" in name_lower or "button" in name_lower or "label" in name_lower:
        return True
    return False


# ─────────────────────────────────────────────────────────────────────────────
# Суффикс для перегружённых методов
#
# Длинная форма (2026-07-26): полное имя типа вместо 1–2 букв.
# Короткие суффиксы (_p, _r, _pt) давали повторяющиеся коллизии:
# setPen(const QColor&) и setPen(Qt::PenStyle) → оба "_p";
# fillRect(QRect,QColor/BrushStyle/GlobalColor/Preset) → все "_rp".
# Длинные суффиксы делают имя самодокументируемым и почти исключают
# коллизии; счётный суффикс (…2, …3) остаётся как страховка.
# ВАЖНО: существующие имена в реестре не меняются — длинная форма
# применяется только к новым функциям.

_TYPE_SUFFIX = {
    "const QString&": "qstring",
    "QString":        "qstring",
    "int":            "int",
    "unsigned int":   "uint",
    "bool":           "bool",
    "double":         "double",
    "qreal":          "qreal",
    "float":          "float",
    "QWidget*":       "qwidget",
    "const QWidget*": "qwidget",
    "QObject*":       "qobject",
    "QPoint":         "qpoint",
    "QPointF":        "qpointf",
    "QRect":          "qrect",
    "QRectF":         "qrectf",
    "QSize":          "qsize",
    "QSizeF":         "qsizef",
    "QStringList":    "qstringlist",
    "QIcon":          "qicon",
    "QUrl":           "qurl",
}


def _type_suffix_one(cpp_type: str) -> str:
    """Суффикс одного параметра: точное совпадение → нормализация → имя типа.

    Fallback: очищенное имя типа в lowercase:
      const QPixmap&   → qpixmap
      Qt::PenStyle     → qt_penstyle
      QGradient::Preset → qgradient_preset
    """
    t = cpp_type.strip()
    s = _TYPE_SUFFIX.get(t)
    if s:
        return s
    t_norm = t.replace("const ", "").replace("&", "").strip()
    s = _TYPE_SUFFIX.get(t_norm)
    if s:
        return s
    # Общая нормализация: убираем const/&/*, :: → _, пробелы → _
    t_norm = (t.replace("const ", "").replace("&", "").replace("*", "")
               .strip())
    t_norm = t_norm.replace("::", "_").replace(" ", "_").replace("<", "_").replace(">", "")
    return t_norm.lower() or "p"


def _overload_suffix(method: QtMethod) -> str:
    """Строит суффикс из типов параметров: _qpoint_qpoint, _qrectf и т.д."""
    parts = [_type_suffix_one(p.cpp_type) for p in method.params]
    return "_" + "_".join(parts) if parts else "_v"


# ─────────────────────────────────────────────────────────────────────────────
# Сбор методов из родительских заголовков

def _collect_parent_methods(parent_header_paths: list) -> tuple:
    """
    Парсит заголовки родительских классов и возвращает
    (extra_methods, extra_signals) — все поддерживаемые публичные методы и сигналы.
    Дедупликация по имени выполняется позже в _plan_methods.
    """
    from qt_parser import parse_qt_header
    all_methods = []
    all_signals = []
    for path in parent_header_paths:
        parent_cls = parse_qt_header(path)
        if parent_cls is None:
            print(f"WARNING: Could not parse parent header: {path}")
            continue
        print(f"  Parent: {parent_cls.name}  "
              f"(+{sum(1 for m in parent_cls.methods if m.is_supported and not m.is_signal and not m.is_protected)} methods, "
              f"+{sum(1 for m in parent_cls.methods if m.is_signal and m.is_supported)} signals)")
        for m in parent_cls.methods:
            if not m.is_supported or m.is_protected:
                continue
            if m.is_signal:
                all_signals.append(m)
            else:
                all_methods.append(m)
    return all_methods, all_signals


# ─────────────────────────────────────────────────────────────────────────────
# Обработка методов: фильтрация + именование

def _plan_methods(cls_name: str, qt_class: QtClass, reg: Registry,
                   module_name: str, dll_file: str,
                   parent_methods: list | None = None,
                   parent_signals: list | None = None,
                   index_start: int | None = None) -> tuple:
    """
    Возвращает (method_specs, signals, ctor_idx, dtor_idx, has_text_ctor, text_ctor_idx).
    parent_methods / parent_signals — унаследованные методы из --parent-header.
    index_start — явное начало блока индексов (--index-start).
    """
    # 1. Собираем поддерживаемые публичные не-сигнальные методы
    methods = [
        m for m in qt_class.methods
        if m.is_supported and not m.is_signal and not m.is_protected
    ]

    # 2. Собираем сигналы
    signals = [
        m for m in qt_class.methods
        if m.is_signal and m.is_supported
    ]

    # 3. Определяем стандартные QWidget методы для добавления
    existing_names = {m.name for m in methods}
    extra_methods = []
    if _is_qwidget_subclass(qt_class):
        for name, ret_d, params in _STANDARD_QWIDGET:
            if name not in existing_names:
                # Создаём синтетический QtMethod
                from qt_parser import QtMethod as QM
                syn = QM(
                    name=name,
                    ret_type="void" if ret_d == "void" else ret_d,
                    params=[_SyntheticParam(ct, pn) for ct, pn in params],
                    is_supported=True,
                )
                syn.d_ret_type = ret_d
                extra_methods.append(syn)

    all_methods = extra_methods + methods  # стандартные методы первыми

    # 3b. Добавляем методы из родительских заголовков (--parent-header)
    if parent_methods:
        current_names = {m.name for m in all_methods}
        # Исключаем методы, переопределённые как protected в дочернем классе
        # (например, QSpinBox::event и QSpinBox::fixup переопределяют public QAbstractSpinBox методы как protected)
        child_protected_names = {m.name for m in qt_class.methods if m.is_protected}
        for pm in parent_methods:
            if pm.name not in current_names and pm.name not in child_protected_names:
                all_methods.append(pm)
                current_names.add(pm.name)

    # 3c. Добавляем сигналы из родительских заголовков
    if parent_signals:
        sig_names = {m.name for m in signals}
        for ps in parent_signals:
            if ps.name not in sig_names:
                signals.append(ps)
                sig_names.add(ps.name)

    # 4. Определяем перегрузки
    name_count = Counter(m.name for m in all_methods)

    # 5. Строим список func_names для регистрации (create, delete + методы)
    func_names = [
        f"qte{cls_name}_create",
        f"qte{cls_name}_delete",
    ]
    categories = ["lifecycle", "lifecycle"]

    # Проверяем наличие конструктора с текстом (QString как первый параметр)
    has_text_ctor = False
    for ctor in qt_class.constructors:
        if ctor.params and "QString" in ctor.params[0].cpp_type:
            has_text_ctor = True
            break

    if has_text_ctor:
        func_names.append(f"qte{cls_name}_create_text")
        categories.append("lifecycle")

    # Методы
    method_func_names = []
    for m in all_methods:
        name = m.name
        if name_count[name] > 1:
            func_name = f"qte{cls_name}_{name}{_overload_suffix(m)}"
        else:
            func_name = f"qte{cls_name}_{name}"
        # Остаточная коллизия суффиксов: разные типы дают одинаковый суффикс
        # (напр. setPen(const QColor&) и setPen(Qt::PenStyle) → оба "_p").
        # Раньше второй перегруз молча выбрасывался из реестра, но попадал
        # в C++ → duplicate extern "C" symbol. Даём счётный суффикс: _p2, _p3.
        base_name = func_name
        k = 2
        while func_name in func_names:
            func_name = f"{base_name}{k}"
            k += 1
        method_func_names.append(func_name)
        func_names.append(func_name)
        categories.append("method")

    # 6. Регистрируем в реестре (сохранение CSV выполняется позже в main())
    idx_map = reg.add_class_functions(module_name, dll_file, func_names, categories,
                                      force_block_start=index_start)

    ctor_idx = idx_map[f"qte{cls_name}_create"]
    dtor_idx = idx_map[f"qte{cls_name}_delete"]
    text_ctor_idx = idx_map.get(f"qte{cls_name}_create_text", 0)

    # 7. Строим MethodSpec
    specs = []
    for m, func_name in zip(all_methods, method_func_names):
        idx = idx_map.get(func_name)
        if idx is None:
            continue
        ret_d = m.d_ret_type or "void"
        specs.append(MethodSpec(
            qt_name=m.name,
            func_name=func_name,
            idx=idx,
            params=list(m.params),
            ret_d=ret_d,
        ))

    # 8. Регистрируем setEventHandler если класс — подкласс QWidget
    event_handler_idx = 0
    if _is_qwidget_subclass(qt_class):
        eh_name = f"qte{cls_name}_setEventHandler"
        eh_map  = reg.add_class_functions(module_name, dll_file, [eh_name], ["event"],
                                          force_block_start=index_start)
        event_handler_idx = eh_map[eh_name]

    return specs, signals, ctor_idx, dtor_idx, has_text_ctor, text_ctor_idx, event_handler_idx
