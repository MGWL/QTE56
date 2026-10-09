"""
Парсер Qt заголовочных файлов (.h) на основе regex.
Извлекает: класс, родителей, методы, свойства, сигналы, слоты.
"""

import re
from dataclasses import dataclass, field
from typing import Optional
from type_map import cpp_type_to_d, UNSUPPORTED_TYPES


@dataclass
class QtParam:
    cpp_type: str       # C++ тип параметра
    name: str           # имя параметра
    default: str = ""   # значение по умолчанию
    d_type: str = ""    # D тип (заполняется после маппинга)


@dataclass
class QtMethod:
    name: str
    ret_type: str               # C++ тип возврата
    params: list[QtParam]
    is_virtual: bool = False
    is_const: bool = False
    is_slot: bool = False
    is_signal: bool = False
    is_static: bool = False
    is_override: bool = False
    is_protected: bool = False  # True если метод в секции protected:
    is_supported: bool = True   # False если тип не поддерживается
    d_ret_type: str = ""        # D тип возврата
    unsupported_reason: str = ""  # причина пропуска (для GENERATOR-INFO)


@dataclass
class QtProperty:
    name: str
    cpp_type: str
    read: str = ""
    write: str = ""


@dataclass
class QtConstructor:
    params: list[QtParam]           # параметры конструктора
    is_supported: bool = True       # False если есть неподдерживаемые типы
    index: int = 1                  # порядковый номер (1, 2, 3...)


@dataclass
class QtClass:
    name: str
    parents: list[str] = field(default_factory=list)
    constructors: list[QtConstructor] = field(default_factory=list)
    methods: list[QtMethod] = field(default_factory=list)
    properties: list[QtProperty] = field(default_factory=list)
    include: str = ""       # имя .h файла
    module: str = ""        # QtWidgets / QtCore / etc


# Regex для парсинга
RE_CLASS = re.compile(
    r'class\s+Q_\w+_EXPORT\s+(\w+)\s*(?::\s*(.+?))?\s*\n?\s*\{',
    re.MULTILINE
)
RE_PARENT = re.compile(r'(?:public|protected|private)\s+(Q\w+)')
RE_PROPERTY = re.compile(
    r'Q_PROPERTY\s*\(\s*(\S+)\s+(\w+)\s*(.*?)\)',
    re.DOTALL
)
RE_PROP_READ  = re.compile(r'READ\s+(\w+)')
RE_PROP_WRITE = re.compile(r'WRITE\s+(\w+)')

# Метод: тип_возврата имя(параметры) [const] [override] [= 0] [;]
RE_METHOD = re.compile(
    r'^[ \t]*((?:virtual\s+)?(?:static\s+)?(?:explicit\s+)?)'
    r'([\w:*&<> ]+?)\s+'         # возвращаемый тип
    r'(\w+)\s*'                  # имя
    r'\(([^)]*)\)\s*'            # параметры
    r'(const\s*)?'               # const?
    r'(override\s*)?'            # override?
    r'(?:Q_DECL_NOTHROW\s*)?'
    r'(?:noexcept\s*)?'
    r'(?:=\s*0\s*)?'
    r';',
    re.MULTILINE
)

RE_PARAM = re.compile(
    r'([\w:*& <>]+?)\s*(\w+)?\s*(?:=\s*[^,)]+)?$'
)


def _strip_comments(text: str) -> str:
    """Удаляет // и /* */ комментарии."""
    text = re.sub(r'//[^\n]*', '', text)
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)
    return text


def _strip_preprocessor(text: str) -> str:
    """Заменяет блоки #if...#endif на пустые строки (упрощённо)."""
    # Убираем строки Q_DECLARE_*, Q_DISABLE_*, Q_OBJECT и т.д.
    # НО сохраняем Q_SIGNALS: и Q_SLOTS: — они нужны для определения секций.
    text = re.sub(r'^\s*Q_(?!SIGNALS\b|SLOTS\b)\w+[^;(]*$', '', text, flags=re.MULTILINE)
    return text


# Платформенные #if-блоки, не относящиеся к нашим целям (Windows/Linux).
# Q_QDOC — объявления только для документации (нет реализации в библиотеке).
_RE_PLATFORM_BLOCK = re.compile(
    r'^[ \t]*#if[^\n]*(?:Q_OS_DARWIN|Q_OS_MAC|Q_OS_IOS|Q_QDOC)[^\n]*\n'
    r'.*?'
    r'^[ \t]*#endif[^\n]*\n?',
    re.MULTILINE | re.DOTALL
)


def _strip_platform_blocks(text: str) -> str:
    """Удаляет #if Q_OS_DARWIN/Q_OS_MAC/Q_QDOC ... #endif блоки целиком.
    Без этого парсер подхватывает macOS-only методы (QPointF::toCGPoint и т.п.),
    а типы вроде CGPoint эвристика enum'ов принимает за int → нерабочий C++."""
    prev = None
    while prev != text:  # вложенные/соседние блоки — до фиксированной точки
        prev = text
        text = _RE_PLATFORM_BLOCK.sub('', text)
    return text


def _parse_params(params_str: str) -> list[QtParam]:
    """Парсит строку параметров в список QtParam."""
    params_str = params_str.strip()
    if not params_str or params_str in ("void", ""):
        return []

    result = []
    # Разбиваем по запятой (но не внутри скобок)
    depth = 0
    parts = []
    current = ""
    for ch in params_str:
        if ch in "(<":
            depth += 1
            current += ch
        elif ch in ")>":
            depth -= 1
            current += ch
        elif ch == "," and depth == 0:
            parts.append(current.strip())
            current = ""
        else:
            current += ch
    if current.strip():
        parts.append(current.strip())

    for i, part in enumerate(parts):
        part = part.strip()
        if not part:
            continue
        # Убираем значение по умолчанию
        default = ""
        if "=" in part:
            eq_idx = part.index("=")
            default = part[eq_idx+1:].strip()
            part = part[:eq_idx].strip()

        # Разделяем тип и имя
        # Имя — последнее слово (если оно не является частью типа)
        tokens = part.rsplit(None, 1)
        if len(tokens) == 2:
            cpp_type, name = tokens
            # Если имя выглядит как тип (начинается с Q, const и т.д.)
            if name in ("const", "int", "void", "bool", "char", "long",
                        "short", "double", "float", "unsigned", "signed"):
                cpp_type = part
                name = f"p{i}"
        elif len(tokens) == 1:
            cpp_type = tokens[0]
            name = f"p{i}"
        else:
            cpp_type = part
            name = f"p{i}"

        # Перенос * и & с имени на тип
        if name.startswith("*"):
            cpp_type = cpp_type + "*"
            name = name[1:]
        if name.startswith("&"):
            cpp_type = cpp_type + "&"
            name = name[1:]

        result.append(QtParam(
            cpp_type=cpp_type.strip(),
            name=name.strip() or f"p{i}",
            default=default
        ))

    return result


# Методы, объявленные в заголовках но недоступные в конкретной конфигурации:
# setupUi   — генерируется uic, не реальный метод QWidget
# hasEditFocus / setEditFocus — только при QT_KEYPAD_NAVIGATION (мобильный Qt)
_METHOD_BLACKLIST = frozenset({
    "setupUi",
    "hasEditFocus",
    "setEditFocus",
})


def _check_method_supported(method: QtMethod) -> bool:
    """Проверяет, поддерживаются ли все типы метода.
    При отказе заполняет method.unsupported_reason (для GENERATOR-INFO)."""
    # Пропускаем конструкторы, деструкторы, операторы
    if method.name.startswith("~") or method.name.startswith("operator"):
        method.unsupported_reason = "operator/destructor"
        return False
    # Пропускаем методы с 'Private' в имени
    if "Private" in method.name or "d_func" in method.name:
        method.unsupported_reason = "private API"
        return False
    # Пропускаем заблокированные методы
    if method.name in _METHOD_BLACKLIST:
        method.unsupported_reason = "blacklist"
        return False

    # Проверяем тип возврата
    ret = method.ret_type.strip()
    if ret in ("", "explicit"):
        method.unsupported_reason = "unparsed return type"
        return False

    d_ret = cpp_type_to_d(ret)
    if d_ret is None:
        # Точная проверка: enum по базе знаний (вложенные enum-типы)
        from knowledge_access import get_knowledge
        kb = get_knowledge()
        if kb is not None and kb.is_enum(ret):
            d_ret = ("int", "value", False)
        # Фолбэк: вложенные enum-типы (EchoMode, InsertPolicy и т.д.)
        # Одиночный CamelCase-идентификатор без пространства имён → int.
        # Ключевое правило: типы начинающиеся с Q (QRegion, QFontMetrics и т.д.)
        # — это Qt value-типы, а не enum-ы; они не поддерживаются → исключаем метод.
        elif (re.match(r'^[A-Z][A-Za-z0-9]+$', ret)
                and not ret.startswith("Q")):
            d_ret = ("int", "value", False)
        else:
            method.unsupported_reason = f"return type '{ret}'"
            return False
    method.d_ret_type = d_ret[0]

    # Проверяем параметры
    for i, param in enumerate(method.params):
        d_t = cpp_type_to_d(param.cpp_type)
        if d_t is None:
            # Фолбэк для int* out-параметров
            if param.cpp_type.strip() in ("int*", "const int*", "int *"):
                param.d_type = "int*"
                continue
            # Фолбэк для вложенных enum-параметров.
            # Типы с Q-префиксом — Qt value-типы, не enum-ы → не поддерживаем.
            pt = param.cpp_type.strip()
            # Точная проверка: enum по базе знаний
            from knowledge_access import get_knowledge
            kb = get_knowledge()
            if kb is not None and kb.is_enum(pt):
                param.d_type = "int"
                continue
            if re.match(r'^[A-Z][A-Za-z0-9]+$', pt) and not pt.startswith("Q"):
                param.d_type = "int"
                continue
            # Если все оставшиеся параметры (от i) имеют значения по умолчанию,
            # обрезаем список — C++ будет использовать эти defaults.
            remaining = method.params[i:]
            if all(p.default for p in remaining):
                method.params = method.params[:i]
                return True
            method.unsupported_reason = f"param type '{param.cpp_type}'"
            return False
        param.d_type = d_t[0]

    return True


def _extract_class_body(text: str, class_start: int) -> str:
    """Извлекает тело класса от { до соответствующего }."""
    depth = 0
    in_class = False
    for i in range(class_start, len(text)):
        if text[i] == '{':
            depth += 1
            in_class = True
        elif text[i] == '}':
            depth -= 1
            if in_class and depth == 0:
                return text[class_start:i+1]
    return text[class_start:]


def parse_qt_header(filepath: str, module: str = "Widgets",
                    target_class: str = None) -> Optional[QtClass]:
    """
    Парсит Qt заголовочный файл и возвращает QtClass.
    target_class: если указан — ищет именно этот класс (для файлов с несколькими классами).
    """
    with open(filepath, encoding="utf-8", errors="ignore") as f:
        text = f.read()

    text = _strip_comments(text)

    # Ищем объявление класса
    if target_class:
        # Ищем конкретный класс по имени
        m = None
        for candidate in RE_CLASS.finditer(text):
            if candidate.group(1) == target_class:
                m = candidate
                break
    else:
        m = RE_CLASS.search(text)

    if not m:
        return None

    class_name = m.group(1)
    parents_str = m.group(2) or ""

    # Извлекаем родителей
    parents = RE_PARENT.findall(parents_str)

    qt_class = QtClass(
        name=class_name,
        parents=parents,
        include=filepath.replace("\\", "/").split("/")[-1],
        module=module
    )

    # Тело класса
    body = _extract_class_body(text, m.start())
    body = _strip_preprocessor(body)
    body = _strip_platform_blocks(body)

    # Заменяем default-значения вида Xxx() на 0 до любого парсинга.
    # Это предотвращает остановку [^)]* на ')' внутри дефолта (QVariant(), Qt::X() и т.д.).
    body = re.sub(r'=\s*\w[\w:]*\(\)', '= 0', body)  # QVariant() / Qt::X() → 0
    body = re.sub(r'=\s*nullptr', '= 0', body)

    # Нормализуем: * и & без пробела ПЕРЕД ИМЕНЕМ МЕТОДА (т.е. перед word+скобкой).
    # Пример: "QWidget *currentWidget()" → "QWidget * currentWidget()"
    # Работаем только с паттерном name( чтобы не сломать парсинг параметров,
    # где "const QString &text" — имя параметра, а не имя метода.
    body = re.sub(r'([*&])(\w+)(\s*\()', lambda m: m.group(1) + ' ' + m.group(2) + m.group(3), body)

    # Парсим конструкторы.
    re_ctor = re.compile(
        r'^\s*(?:explicit\s+)?' + re.escape(class_name) + r'\s*\(([^)]*)\)\s*;',
        re.MULTILINE
    )
    ctor_index = 1
    for cm in re_ctor.finditer(body):
        params_s = cm.group(1).strip()
        params = _parse_params(params_s)
        # Пропускаем "private" конструкторы с XXXPrivate параметром
        if any("Private" in p.cpp_type or "Private" in p.name for p in params):
            continue
        # Проверяем поддержку типов
        supported = True
        for p in params:
            # Пропускаем Qt::WindowFlags — это optional параметр, упрощаем
            if "WindowFlags" in p.cpp_type:
                continue
            info = cpp_type_to_d(p.cpp_type)
            if info is None:
                supported = False
                break
            p.d_type = info[0]
        qt_class.constructors.append(QtConstructor(
            params=params,
            is_supported=supported,
            index=ctor_index,
        ))
        ctor_index += 1

    # Парсим Q_PROPERTY
    for pm in RE_PROPERTY.finditer(body):
        prop_type = pm.group(1)
        prop_name = pm.group(2)
        prop_rest = pm.group(3)
        read_m  = RE_PROP_READ.search(prop_rest)
        write_m = RE_PROP_WRITE.search(prop_rest)
        qt_class.properties.append(QtProperty(
            name=prop_name,
            cpp_type=prop_type,
            read=read_m.group(1) if read_m else "",
            write=write_m.group(1) if write_m else "",
        ))

    # Строим карту секций по позиции в тексте:
    # [(pos, is_protected, is_signal, is_slot), ...]
    #
    # Обрабатываем два варианта синтаксиса Qt-заголовков:
    #   1) "public Q_SIGNALS:" / "public signals:"  — квалификатор + маркер
    #   2) "Q_SIGNALS:" / "signals:"                — маркер отдельной строкой
    RE_SECTION = re.compile(
        r'^[ \t]*(?:'
        r'(protected|private|public)\s*(Q_SLOTS:|slots:|Q_SIGNALS:|signals:)?'
        r'|'
        r'(Q_SIGNALS:|signals:|Q_SLOTS:|slots:)'
        r')',
        re.MULTILINE
    )
    section_map = []  # [(pos, is_protected, is_signal, is_slot)]
    for sm in RE_SECTION.finditer(body):
        vis   = sm.group(1)                              # public/protected/private или None
        extra = (sm.group(2) or sm.group(3) or "").strip().lower()
        if vis is not None:
            is_prot = (vis in ("protected", "private"))
        else:
            # Standalone Q_SIGNALS:/Q_SLOTS: без квалификатора.
            # Сигналы всегда публичны; для слотов наследуем предыдущую секцию.
            prev_prot = section_map[-1][1] if section_map else False
            is_prot   = False if ("signals" in extra) else prev_prot
        is_signal = ("signals" in extra)
        is_slot   = ("slots" in extra)
        section_map.append((sm.start(), is_prot, is_signal, is_slot))

    def _section_at(pos: int) -> tuple[bool, bool, bool]:
        """Возвращает (is_protected, is_signal, is_slot) для позиции pos в body."""
        result = (False, False, False)
        for sec_pos, is_p, is_sig, is_sl in section_map:
            if sec_pos <= pos:
                result = (is_p, is_sig, is_sl)
            else:
                break
        return result

    # Парсим методы через regex по всему телу
    for mm in RE_METHOD.finditer(body):
        prefix   = mm.group(1).strip()
        ret_type = mm.group(2).strip()
        name     = mm.group(3).strip()
        params_s = mm.group(4).strip()
        is_const = bool(mm.group(5))
        is_over  = bool(mm.group(6))

        # Пропускаем конструкторы/деструкторы (ret_type == class_name)
        if name == class_name or name.startswith("~"):
            continue

        # Убираем лишние квалификаторы из ret_type
        for kw in ("explicit", "virtual", "static", "inline",
                   "Q_REQUIRED_RESULT", "Q_INVOKABLE", "Q_DECL_CONSTEXPR",
                   "Q_DECL_RELAXED_CONSTEXPR"):
            ret_type = ret_type.replace(kw, "")
        ret_type = ret_type.strip()

        if not ret_type:
            continue

        params = _parse_params(params_s)
        is_prot, is_sig, is_sl = _section_at(mm.start())

        method = QtMethod(
            name=name,
            ret_type=ret_type,
            params=params,
            is_virtual="virtual" in prefix,
            is_static="static" in prefix,
            is_const=is_const,
            is_override=is_over,
            is_protected=is_prot,
            is_signal=is_sig,
            is_slot=is_sl,
        )
        method.is_supported = _check_method_supported(method)
        qt_class.methods.append(method)

    return qt_class


def print_class_summary(qt_class: QtClass):
    """Печатает краткую информацию о распарсенном классе."""
    print(f"\n=== {qt_class.name} : {', '.join(qt_class.parents)} ===")
    print(f"Файл: {qt_class.include}  |  Модуль: {qt_class.module}")
    print(f"Свойства: {len(qt_class.properties)}")

    all_m = qt_class.methods

    # Группируем методы по категориям
    signals   = [m for m in all_m if m.is_signal]
    protected = [m for m in all_m if m.is_protected and not m.is_signal]
    public    = [m for m in all_m if not m.is_protected and not m.is_signal]

    pub_supported   = [m for m in public if m.is_supported]
    pub_unsupported = [m for m in public if not m.is_supported]
    pub_virtual     = [m for m in pub_supported if m.is_virtual]
    pub_slots       = [m for m in pub_supported if m.is_slot]

    print(f"Методы всего: {len(all_m)}  |  "
          f"публичных: {len(public)}  "
          f"(генерируется: {len(pub_supported)}, пропущено: {len(pub_unsupported)})  |  "
          f"сигналов: {len(signals)}  |  "
          f"protected: {len(protected)}")

    # --- Публичные методы (попадут в D-класс) ---
    print(f"\nПУБЛИЧНЫЕ методы ({len(pub_supported)} генерируется):")
    for m in pub_supported:
        tags = []
        if m.is_virtual: tags.append("virtual")
        if m.is_slot:    tags.append("slot")
        if m.is_const:   tags.append("const")
        tag_str = f"  [{', '.join(tags)}]" if tags else ""
        params = ", ".join(f"{p.cpp_type} {p.name}" for p in m.params)
        print(f"  {m.d_ret_type} {m.name}({params}){tag_str}")

    # --- Сигналы (фильтруются, в D-класс не попадают) ---
    if signals:
        print(f"\nСИГНАЛЫ ({len(signals)}, в D-класс не попадают):")
        for m in signals:
            sup = "" if m.is_supported else "  [неподдерживаемый тип]"
            params = ", ".join(f"{p.cpp_type} {p.name}" for p in m.params)
            print(f"  {m.ret_type} {m.name}({params}){sup}")

    # --- Protected (фильтруются) ---
    if protected:
        prot_sup = [m for m in protected if m.is_supported]
        prot_uns = [m for m in protected if not m.is_supported]
        print(f"\nPROTECTED ({len(protected)}, в D-класс не попадают):")
        for m in prot_sup:
            v = "virtual " if m.is_virtual else ""
            params = ", ".join(f"{p.cpp_type} {p.name}" for p in m.params)
            print(f"  {v}{m.ret_type} {m.name}({params})")
        for m in prot_uns:
            params = ", ".join(f"{p.cpp_type}" for p in m.params)
            print(f"  {m.ret_type} {m.name}({params})  [неподдерживаемый тип]")

    # --- Пропущенные публичные ---
    if pub_unsupported:
        print(f"\nПРОПУЩЕНО (неподдерживаемые типы, {len(pub_unsupported)}):")
        for m in pub_unsupported:
            params = ", ".join(f"{p.cpp_type}" for p in m.params)
            print(f"  {m.ret_type} {m.name}({params})")

    # --- Итоговая статистика виртуальных ---
    if pub_virtual:
        print(f"\nВИРТУАЛЬНЫЕ публичные ({len(pub_virtual)}, нужны D-callback сеттеры):")
        for m in pub_virtual:
            params = ", ".join(f"{p.cpp_type} {p.name}" for p in m.params)
            print(f"  {m.d_ret_type} {m.name}({params})")


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Использование: py qt_parser.py <путь_к_заголовку.h>")
        sys.exit(1)
    result = parse_qt_header(sys.argv[1])
    if result:
        print_class_summary(result)
    else:
        print("Класс не найден в файле")
