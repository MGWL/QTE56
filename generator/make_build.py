#!/usr/bin/env python3
"""
make_build.py — сканирует *.d файл и генерирует шаблон компиляции.

Алгоритм:
  1. Автоматически сканирует d/gen/gen_*.d — строит карту «Q-класс → модуль»
     и граф зависимостей (из import-строк каждого gen_*.d).
  2. Находит все Q... классы в исходнике и раскрывает транзитивные зависимости.
  3. Генерирует: список import-ов, .bat (Windows dmd -m32) и .sh (Linux ldc2/dmd).

Использование:
    py make_build.py path/to/myapp.d
    py make_build.py path/to/myapp.d --out myapp
    py make_build.py path/to/myapp.d --bat test/build_myapp.bat --sh test/build_myapp.sh
    py make_build.py path/to/myapp.d --bat test/build_myapp.bat --sh test/build_myapp.sh --out test/myapp
    py make_build.py path/to/myapp.d --qt-path D:\\arch_new\\bin513
    py make_build.py --update-all           # перегенерировать все test/build_*.bat
    py make_build.py --scanqt                  # показать найденные пути Qt без генерации
    py make_build.py path/to/myapp.d --scanqt  # генерировать с автоопределёнными путями
    py make_build.py --update-all --scanqt     # перегенерировать все + автопути
"""

import sys, os, re, argparse, stat
from pathlib import Path

# Принудительный UTF-8 вывод на Windows-консоли
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ('utf-8', 'utf8'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


# ── Найти корень arch_new/ ─────────────────────────────────────────────────────
def find_arch_root(hint: Path) -> Path:
    p = hint.resolve()
    while p != p.parent:
        if (p / 'd' / 'qte56_core.d').exists() and (p / 'd' / 'gen').is_dir():
            return p
        p = p.parent
    raise SystemExit(
        "ERROR: не найден корень проекта (arch_new/).\n"
        "       Запустите скрипт из папки проекта или передайте абсолютный путь к .d файлу."
    )


# ── Сканирование gen_*.d ───────────────────────────────────────────────────────
def scan_gen_modules(arch_root: Path):
    """
    Возвращает три словаря:
      class_map  {ClassName -> module_stem}    e.g. 'QLabel' -> 'gen_qlabel'
      dep_map    {module_stem -> [dep_stems]}  из import gen_* в каждом файле
      file_map   {module_stem -> Path}
    """
    gen_dir = arch_root / 'd' / 'gen'
    class_map, dep_map, file_map = {}, {}, {}

    for f in sorted(gen_dir.glob('gen_*.d')):
        mod  = f.stem
        text = f.read_text(encoding='utf-8', errors='replace')
        file_map[mod] = f
        deps = []

        # class QFoo или class QFoo : QBar  (только CamelCase имена)
        # возможна аннотация @live перед class
        for m in re.finditer(r'^\s*(?:@live\s+)?class\s+(Q[A-Z][a-z]\w+)', text, re.MULTILINE):
            cls = m.group(1)
            if cls not in class_map:
                class_map[cls] = mod

        # import gen_xxx  (зависимости модуля)
        for m in re.finditer(r'^import\s+(gen_\w+)', text, re.MULTILINE):
            dep = m.group(1)
            if dep != mod and dep not in deps:
                deps.append(dep)

        dep_map[mod] = deps

    return class_map, dep_map, file_map


# ── Транзитивное замыкание ─────────────────────────────────────────────────────
def resolve_deps(modules: set, dep_map: dict) -> set:
    result, queue = set(), list(modules)
    while queue:
        m = queue.pop()
        if m in result:
            continue
        result.add(m)
        for dep in dep_map.get(m, []):
            if dep not in result:
                queue.append(dep)
    return result


# ── Порядок модулей (базовые вперёд) ──────────────────────────────────────────
BASE_ORDER = [
    'gen_qcore', 'gen_qobject', 'gen_qfont', 'gen_qbytearray', 'gen_qdate',
    'gen_qwidget', 'gen_qframe',
    'gen_qabstractbutton', 'gen_qabstractslider',
    'gen_qabstractspinbox', 'gen_qabstractscrollarea', 'gen_qabstractitemview',
]

def order_modules(modules: set) -> list:
    result = [m for m in BASE_ORDER if m in modules]
    result += sorted(m for m in modules if m not in result)
    return result


# ── Скан исходника ─────────────────────────────────────────────────────────────

# Имена из gen_qcore — отдельный модуль не нужен, всегда включён
QCORE_BUILTINS = {'QApplication', 'ESlot', 'DPoint', 'DRect', 'DSize', 'connectQt'}

# Qt-внутренние типы — не являются D-классами в нашем проекте
QCLASS_BLACKLIST = {
    'QCore', 'QString', 'QVariant', 'QList', 'QVector', 'QMap', 'QHash',
    'QSet', 'QChar', 'QUrl', 'QDir', 'QSize', 'QPoint', 'QRect', 'QLine',
    'QThread', 'QMutex', 'QFuture', 'QDebug', 'QIODevice',
}

# Высокоуровневые d/*.d модули (детектируем по идентификаторам)
EXTRA_D_MODULES = [
    ({'QForm', 'findLabel', 'findButton', 'findWidget'},   'd/qte56_forms.d'),
    ({'applyQss', 'appendQss', 'QssTheme', 'knownStyles'}, 'd/qte56_style.d'),
    ({'registerRcc', 'QssThemeRes', 'applyQssRes'},        'd/qte56_resource.d'),
    ({'WrenVM', 'LoadWren', 'wren_vm'},                    'wren/d/wren_vm.d'),
    ({'Term', 'TermTable', 'BoxChars'},                    'd/qte56_term.d'),
]

# Идентификаторы, при наличии которых нужен d/qte56_enums.d
ENUMS_TRIGGERS = {
    'QtE', 'FrameShape', 'FrameShadow', 'TabPosition',
    'AlignmentFlag', 'WindowFlags', 'WindowType',
    'ScrollBarPolicy', 'SortOrder', 'MatchFlag',
}

def scan_source(source: Path):
    text = source.read_text(encoding='utf-8', errors='replace')
    # Убираем комментарии
    text_nc = re.sub(r'//.*$', '', text, flags=re.MULTILINE)
    text_nc = re.sub(r'/\*.*?\*/', '', text_nc, flags=re.DOTALL)

    # Только CamelCase Q-классы (Q + заглавная + строчная + ...), без blacklist
    q_classes     = {c for c in re.findall(r'\b(Q[A-Z][a-z]\w+)\b', text_nc)
                     if c not in QCLASS_BLACKLIST}
    explicit_mods = set(re.findall(r'\bimport\s+(gen_\w+)', text_nc))
    all_idents    = set(re.findall(r'\b(\w+)\b', text_nc))
    return q_classes, explicit_mods, all_idents


# ── Конфигурация путей Qt ──────────────────────────────────────────────────────
DEFAULT_QT_BIN   = r'C:\Qt5_13_2\5.13.2\mingw73_32\bin'
DEFAULT_QT_MINGW = r'C:\Qt5_13_2\Tools\mingw730_32\bin'

def qt_plugins_path(qt_bin: str) -> str:
    r"""Вывести путь к platforms из qt_bin: ..\plugins\platforms"""
    return str(Path(qt_bin).parent / 'plugins' / 'platforms')


# ── Сканирование Qt-путей в файловой системе ──────────────────────────────────
# Маркеры для каждой категории: (Windows-файлы, Linux-файлы)
_QT_MARKERS = {
    'qt_bin':    (['Qt5Core.dll', 'Qt5Widgets.dll'],
                  ['libQt5Core.so.5', 'libQt5Widgets.so.5']),
    'qt_mingw':  (['libgcc_s_dw2-1.dll', 'libstdc++-6.dll'], []),
    'platforms': (['qwindows.dll'],
                  ['libqxcb.so', 'libqwayland-generic.so']),
}

# Папки, которые заведомо не содержат Qt — пропускаем для скорости
_SKIP_DIRS = {'.git', '__pycache__', 'node_modules', '.svn', '.hg',
              'Windows', 'System32', 'SysWOW64', '$Recycle.Bin'}

def scan_qt_paths(start_dir: Path, max_depth: int = 8) -> dict:
    """
    Рекурсивно обходит start_dir (глубина до max_depth) и ищет Qt-файлы.
    Возвращает dict {'qt_bin': path|None, 'qt_mingw': path|None, 'platforms': path|None}.
    """
    found = {k: None for k in _QT_MARKERS}

    def _walk(path: Path, depth: int):
        if depth > max_depth:
            return
        if all(v is not None for v in found.values()):
            return
        try:
            entries = list(path.iterdir())
        except (PermissionError, OSError):
            return

        # имена файлов в нижнем регистре для сравнения
        file_names = {e.name.lower() for e in entries if e.is_file()}

        for key, (win_m, lin_m) in _QT_MARKERS.items():
            if found[key] is None:
                if any(m.lower() in file_names for m in win_m + lin_m):
                    found[key] = str(path)

        for e in entries:
            if e.is_dir() and e.name not in _SKIP_DIRS and not e.name.startswith('.'):
                _walk(e, depth + 1)

    _walk(start_dir, 0)
    return found


def print_scan_result(found: dict, qt_bin_default: str, qt_mingw_default: str):
    labels = {
        'qt_bin':    'Qt bin (DLL)',
        'qt_mingw':  'MinGW bin   ',
        'platforms': 'platforms   ',
    }
    for key, label in labels.items():
        val = found[key]
        if val:
            print(f"  {label} : {val}  [найден]")
        else:
            default = qt_bin_default if key == 'qt_bin' else \
                      qt_mingw_default if key == 'qt_mingw' else \
                      qt_plugins_path(qt_bin_default)
            print(f"  {label} : {default}  [не найден, используется default]")


# ── Вспомогательные функции для bat ───────────────────────────────────────────
def _to_win(path: str) -> str:
    """Конвертировать слэши в обратные для Windows-путей."""
    return path.replace('/', '\\')


# ── Проверка существования файлов проекта ─────────────────────────────────────
def check_project_files(arch_root: Path, gen_mods: list, extra_d: list,
                        need_enums: bool) -> list[str]:
    """
    Проверяет наличие всех файлов, которые будут включены в команду компиляции.
    Возвращает список отсутствующих путей (относительно arch_root).
    """
    missing = []
    always = ['d/qte56_core.d', 'd/qte56_loader.d']
    if need_enums:
        always.append('d/qte56_enums.d')
    for rel in always:
        if not (arch_root / rel).exists():
            missing.append(rel)
    for mod in gen_mods:
        rel = f'd/gen/{mod}.d'
        if not (arch_root / rel).exists():
            missing.append(rel)
    for ed in extra_d:
        if not (arch_root / ed).exists():
            missing.append(ed)
    return missing


# ── Генерация .bat ─────────────────────────────────────────────────────────────
def gen_bat(source_rel: str, out_rel: str, gen_mods: list, extra_d: list,
            need_enums: bool, levels_up: int = 1) -> str:
    """
    levels_up: сколько уровней вверх делать cd от места расположения .bat до arch_root.
      1 (default) — bat в подпапке (test/, scripts/): cd "%~dp0.."
      0           — bat прямо в arch_root:            cd "%~dp0."
    Qt-пути (DMD, QT_BIN, MINGW_BIN, QT_PLUGINS) берутся из local.env.bat.
    """
    name = Path(source_rel).name

    # Все пути в bat-файле — с обратными слэшами
    src_w = _to_win(source_rel)
    out_w = _to_win(out_rel)

    # cd: %~dp0 уже содержит завершающий \
    #   levels_up=0 → cd /d "%~dp0."      (оставаться в папке bat)
    #   levels_up=1 → cd /d "%~dp0.."     (на 1 уровень вверх)
    #   levels_up=2 → cd /d "%~dp0..\.."  (на 2 уровня вверх)
    if levels_up == 0:
        cd_suffix = '.'
    else:
        cd_suffix = '\\'.join(['..'] * levels_up)
    cd_line = f'cd /d "%~dp0{cd_suffix}"'

    # Путь к local.env.bat относительно bat-файла:
    #   levels_up=0 → bat в arch_root     → "%~dp0local.env.bat"
    #   levels_up=1 → bat в test/         → "%~dp0..\local.env.bat"
    #   levels_up=2 → bat на 2 уровня вниз→ "%~dp0..\..\local.env.bat"
    if levels_up == 0:
        local_env_rel = 'local.env.bat'
    else:
        local_env_rel = '\\'.join(['..'] * levels_up) + '\\local.env.bat'
    local_env_line = f'if exist "%~dp0{local_env_rel}" call "%~dp0{local_env_rel}"'

    lines = [
        '@echo off',
        cd_line,
        local_env_line,
        '',
        f'echo === Compiling {name} ===',
        '%DMD% -m32 -i ^',
        f'    {src_w} ^',
        '    d\\qte56_core.d ^',
        '    d\\qte56_loader.d ^',
    ]
    if need_enums:
        lines.append('    d\\qte56_enums.d ^')
    for mod in gen_mods:
        lines.append(f'    d\\gen\\{mod}.d ^')
    for ed in extra_d:
        lines.append(f'    {_to_win(ed)} ^')
    lines += [
        '    -I. -Id -Id\\gen ^',
        f'    -of={out_w}.exe',
        '',
        'if %ERRORLEVEL% NEQ 0 (',
        '    echo ERROR: compilation failed!',
        '    pause & exit /b 1',
        ')',
        '',
        'echo === Running ===',
        'set PATH=dll\\dll32;%QT_BIN%;%MINGW_BIN%;%PATH%',
        'set QT_QPA_PLATFORM_PLUGIN_PATH=%QT_PLUGINS%',
        f'{out_w}.exe',
        '',
        'pause',
    ]
    return '\r\n'.join(lines) + '\r\n'


# ── Генерация .sh ──────────────────────────────────────────────────────────────
def gen_sh(source_rel: str, out_rel: str, gen_mods: list, extra_d: list,
           need_enums: bool, levels_up: int = 1) -> str:
    """
    levels_up: сколько уровней вверх от места .sh до arch_root.
      1 (default) — sh в подпапке (test/): cd "$(dirname "$0")/.."
      0           — sh прямо в arch_root:  cd "$(dirname "$0")"
    """
    name = Path(source_rel).name

    # rpath: $ORIGIN относительно бинаря; lib/ всегда рядом с arch_root
    # при levels_up=1 бинарь в test/ → $ORIGIN/../lib; при 0 → $ORIGIN/lib
    rpath_suffix = '/../lib' if levels_up >= 1 else '/lib'

    if levels_up == 0:
        cd_line = 'cd "$(dirname "$0")"'
    else:
        ups = '/'.join(['..'] * levels_up)
        cd_line = f'cd "$(dirname "$0")/{ups}"'

    lines = [
        '#!/bin/bash',
        'set -e',
        cd_line,
        '',
        'DMD=$(which ldc2 2>/dev/null || which dmd 2>/dev/null)',
        'if [ -z "$DMD" ]; then',
        '    echo "ERROR: D compiler not found (install ldc2 or dmd)"',
        '    exit 1',
        'fi',
        '',
        f'echo "=== Compiling {name} ==="',
        '"$DMD" -i \\',
        f'    {source_rel} \\',
        '    d/qte56_core.d \\',
        '    d/qte56_loader.d \\',
    ]
    if need_enums:
        lines.append('    d/qte56_enums.d \\')
    for mod in gen_mods:
        lines.append(f'    d/gen/{mod}.d \\')
    for ed in extra_d:
        lines.append(f'    {ed} \\')
    lines += [
        '    -I. -Id -Id/gen \\',
        f"    -L-Wl,-rpath,'\\$ORIGIN{rpath_suffix}' \\",
        f'    -of={out_rel}',
        '',
        'echo "=== Running ==="',
        f'LD_LIBRARY_PATH=./lib ./{out_rel}',
    ]
    return '\n'.join(lines) + '\n'


# ══════════════════════════════════════════════════════════════════════════════
# ──  --info / --snippet / --new-app  ─────────────────────────────────────────
# ══════════════════════════════════════════════════════════════════════════════

# Callback-сигнатуры для известных сигналов Qt.
# Суффикс _i = int, _s = string.  None = неизвестно.
KNOWN_CALLBACKS: dict[str, list[tuple[str,str]]] = {
    'connect_clicked':                   [],
    'connect_pressed':                   [],
    'connect_released':                  [],
    'connect_toggled':                   [('bool', 'checked')],
    'connect_textChanged':               [('string', 'text')],
    'connect_textEdited':                [('string', 'text')],
    'connect_currentIndexChanged':       [('int', 'index')],
    'connect_currentIndexChanged_i':     [('int', 'index')],
    'connect_currentIndexChanged_s':     [('string', 'text')],
    'connect_currentTextChanged':        [('string', 'text')],
    'connect_editTextChanged':           [('string', 'text')],
    'connect_activated_i':               [('int', 'index')],
    'connect_activated_s':               [('string', 'text')],
    'connect_highlighted_i':             [('int', 'index')],
    'connect_highlighted_s':             [('string', 'text')],
    'connect_valueChanged':              [('int', 'value')],
    'connect_sliderMoved':               [('int', 'value')],
    'connect_rangeChanged':              [('int', 'min_'), ('int', 'max_')],
    'connect_timeout':                   [],
    'connect_finished':                  [('int', 'exitCode')],
    'connect_accepted':                  [],
    'connect_rejected':                  [],
    'connect_stateChanged':              [('int', 'state')],
    'connect_returnPressed':             [],
    'connect_editingFinished':           [],
    'connect_inputRejected':             [],
    'connect_selectionChanged':          [],
    'connect_cursorPositionChanged':     [('int', 'old_'), ('int', 'new_')],
    'connect_triggered':                 [],
    'connect_hovered':                   [],
    'connect_aboutToShow':               [],
    'connect_aboutToHide':               [],
    'connect_tabChanged':                [('int', 'index')],
    'connect_currentChanged':            [('int', 'index')],
    'connect_splitterMoved':             [('int', 'pos'), ('int', 'index')],
    'connect_itemSelectionChanged':      [],
    'connect_windowTitleChanged':        [('string', 'title')],
    'connect_customContextMenuRequested':[('int', 'x'), ('int', 'y')],
    'connect_activated':                 [('int', 'reason')],   # QSystemTrayIcon
    'connect_messageClicked':            [],
}

# Известные события (on*) с сигнатурой коллбэка
KNOWN_EVENTS: dict[str, list[tuple[str,str]]] = {
    'onMousePress':   [('int', 'x'), ('int', 'y'), ('int', 'button')],
    'onMouseRelease': [('int', 'x'), ('int', 'y'), ('int', 'button')],
    'onMouseDoubleClick': [('int', 'x'), ('int', 'y'), ('int', 'button')],
    'onMouseMove':    [('int', 'x'), ('int', 'y')],
    'onKeyPress':     [('int', 'key'), ('int', 'mods')],
    'onKeyRelease':   [('int', 'key'), ('int', 'mods')],
    'onResize':       [('int', 'w'), ('int', 'h')],
    'onMove':         [('int', 'x'), ('int', 'y')],
    'onClose':        [],
    'onShow':         [],
    'onHide':         [],
    'onEnter':        [],
    'onLeave':        [],
    'onWheel':        [('int', 'dx'), ('int', 'dy')],
    'onFocusIn':      [('int', 'reason')],
    'onFocusOut':     [('int', 'reason')],
    'onContextMenu':  [('int', 'x'), ('int', 'y'), ('int', 'reason')],
    'onPaint':        [('void*', 'painter')],
}


def _cb_params_str(params: list[tuple[str,str]], include_dthis=False) -> str:
    """'(void* dthis, int x, int y)' или '()' """
    parts = []
    if include_dthis:
        parts.append('void* dthis')
    parts += [f'{t} {n}' for t, n in params]
    return '(' + ', '.join(parts) + ')'


# ── Парсинг gen_*.d для извлечения метаданных класса ─────────────────────────
def scan_class_info(class_name: str, class_map: dict, arch_root: Path) -> dict | None:
    if class_name not in class_map:
        return None
    mod  = class_map[class_name]
    path = arch_root / 'd' / 'gen' / f'{mod}.d'
    text = path.read_text(encoding='utf-8', errors='replace')

    # Родительский класс
    parent = None
    m = re.search(rf'\bclass\s+{re.escape(class_name)}\s*:\s*(Q\w+)', text)
    if m:
        parent = m.group(1)

    # connect_* (сигналы через ESlot); возвращаемый тип любой:
    # раньше void, после method chaining — класс (QComboBox connect_...(ESlot))
    connects = list(dict.fromkeys(re.findall(r'\b(?:void|Q\w+)\s+(connect_\w+)\s*\(', text)))

    # on* события (прямые коллбэки)
    events = list(dict.fromkeys(re.findall(r'\b(?:void|Q\w+)\s+(on[A-Z]\w+)\s*\(void\* cb', text)))

    # Публичные методы (строки с отступом 4, тип + имя + скобка);
    # тип — скаляр или класс (method chaining: QComboBox addItem(...))
    methods = list(dict.fromkeys(
        re.findall(
            r'^\s{4}(?:override\s+)?(?:void|int|bool|string|auto|void\*|QByteArray[*]?|Q[A-Z]\w*[*]?)\s+(\w+)\s*\(',
            text, re.MULTILINE)
    ))
    # убрать служебные
    skip = {'wrap', 'getWH', 'disown'}
    methods = [m for m in methods if not m.startswith('connect_') and
               not m.startswith('on') and m not in skip]

    return {
        'class':   class_name,
        'module':  mod,
        'file':    path,
        'parent':  parent,
        'connects': connects,
        'events':  events,
        'methods': methods,
    }


def get_class_indices(class_name: str, arch_root: Path) -> tuple[int|None, int|None, int]:
    """Диапазон индексов из registry/functions.csv → (min, max, count)."""
    csv = arch_root / 'registry' / 'functions.csv'
    if not csv.exists():
        return None, None, 0
    idxs = []
    for line in csv.read_text(encoding='utf-8', errors='replace').splitlines():
        if line.startswith('#') or not line.strip():
            continue
        parts = line.split(',')
        if len(parts) >= 3 and parts[2].strip() == class_name:
            try:
                idxs.append(int(parts[0]))
            except ValueError:
                pass
    if not idxs:
        return None, None, 0
    return min(idxs), max(idxs), len(idxs)


def _build_hierarchy(class_name: str, class_map: dict, arch_root: Path) -> list[str]:
    """Цепочка наследования: QFoo → QBar → QWidget → ..."""
    chain, visited = [class_name], set()
    current = class_name
    while True:
        if current in visited:
            break
        visited.add(current)
        info = scan_class_info(current, class_map, arch_root)
        if not info or not info['parent']:
            break
        chain.append(info['parent'])
        current = info['parent']
    return chain


# ── --info ────────────────────────────────────────────────────────────────────
def cmd_info(class_name: str, class_map: dict, dep_map: dict, arch_root: Path):
    info = scan_class_info(class_name, class_map, arch_root)
    if not info:
        print(f"ERROR: класс '{class_name}' не найден среди {len(class_map)} классов.")
        sys.exit(1)

    idx_min, idx_max, idx_cnt = get_class_indices(class_name, arch_root)
    hierarchy = _build_hierarchy(class_name, class_map, arch_root)

    W = 64
    print('=' * W)
    print(f"  Класс    : {class_name}")
    print(f"  Модуль   : {info['module']}")
    print(f"  Файл     : {info['file']}")
    if idx_min is not None:
        rng = f"{idx_min}–{idx_max}" if idx_min != idx_max else str(idx_min)
        print(f"  Индексы  : {rng}  ({idx_cnt} функций)")
    print(f"  Иерархия : {' -> '.join(hierarchy)}")
    print()

    if info['connects']:
        print("  Сигналы (connect_*):")
        for c in info['connects']:
            params = KNOWN_CALLBACKS.get(c)
            sig = _cb_params_str(params) if params is not None else '(???)'
            print(f"    {c:<44} cb{sig}")
        print()

    if info['events']:
        print("  События (on*):")
        for e in info['events']:
            params = KNOWN_EVENTS.get(e, [])
            sig = _cb_params_str(params, include_dthis=True)
            print(f"    {e:<44} cb{sig}")
        print()

    if info['methods']:
        cols, col_w = 3, 24
        print("  Методы:")
        chunk = [info['methods'][i:i+cols] for i in range(0, len(info['methods']), cols)]
        for row in chunk:
            print('    ' + ''.join(f"{m:<{col_w}}" for m in row))
        print()

    print('=' * W)


# ── --snippet ─────────────────────────────────────────────────────────────────
_SNIPPET_HELP = (
    "  signal-slot CLASS   — ESlot-блок для всех сигналов класса\n"
    "  event CLASS         — extern(C) обработчики событий\n"
    "  app-min [TITLE]     — минимальный скелет приложения\n"
    "  layout [CLASS]      — виджет + layout + дочерние элементы\n"
    "  dialog              — QDialog с кнопками OK/Cancel\n"
    "  mdi                 — QMdiArea + QMdiSubWindow (правильный паттерн)\n"
    "  model-view [CLASS]  — CLASS=table|tree: виджет с данными\n"
    "  settings            — сохранение/восстановление геометрии через QSettings\n"
    "  file-io             — чтение/запись файла через QFile\n"
    "  timer               — QTimer + connect_timeout\n"
    "  painter             — onPaint + QPainter draw-блок\n"
    "  tray                — QSystemTrayIcon полный блок\n"
    "  splash              — QSplashScreen загрузочный экран\n"
    "  check-funcs CLASS   — диагностика pFunQt[N] для класса\n"
    "  wren-bridge         — скелет WrenVM + interpret + call\n"
)

def cmd_snippet(snip_type: str, target: str | None,
                class_map: dict, arch_root: Path):

    dispatch = {
        'signal-slot':  lambda: _require(target, 'signal-slot') or _snippet_signal_slot(target, class_map, arch_root),
        'event':        lambda: _require(target, 'event')        or _snippet_events(target, class_map, arch_root),
        'app-min':      lambda: _snippet_app_min(target),
        'layout':       lambda: _snippet_layout(target),
        'dialog':       lambda: _snippet_dialog(),
        'mdi':          lambda: _snippet_mdi(),
        'model-view':   lambda: _snippet_model_view(target or 'table'),
        'settings':     lambda: _snippet_settings(),
        'file-io':      lambda: _snippet_file_io(),
        'timer':        lambda: _snippet_timer(),
        'painter':      lambda: _snippet_painter(),
        'tray':         lambda: _snippet_tray(),
        'splash':       lambda: _snippet_splash(),
        'check-funcs':  lambda: _require(target, 'check-funcs') or _snippet_check_funcs(target, class_map, arch_root),
        'wren-bridge':  lambda: _snippet_wren_bridge(),
    }
    fn = dispatch.get(snip_type)
    if fn is None:
        print(f"ERROR: неизвестный тип сниппета '{snip_type}'.\nДоступные:\n{_SNIPPET_HELP}")
        sys.exit(1)
    fn()


def _require(target, snip_type):
    if not target:
        print(f"ERROR: укажите класс:  --snippet {snip_type} QClassName")
        sys.exit(1)


def _snippet_signal_slot(class_name: str, class_map: dict, arch_root: Path):
    info = scan_class_info(class_name, class_map, arch_root)
    if not info:
        print(f"ERROR: класс '{class_name}' не найден.")
        sys.exit(1)

    var = class_name[1].lower() + class_name[2:]   # QComboBox → omboBox → cb

    print(f"\n// ── signal-slot: {class_name} ──────────────────────────────")
    print(f"auto {var} = new {class_name}(parent.getWH());")
    print()

    if not info['connects']:
        print("// (нет connect_* сигналов в этом классе)")
        return

    for conn in info['connects']:
        params = KNOWN_CALLBACKS.get(conn)
        fn_name = conn[8:]                            # strip 'connect_'
        if params is None:
            # попробуем угадать по суффиксу
            if conn.endswith('_i'):
                params = [('int', 'value')]
            elif conn.endswith('_s'):
                params = [('string', 'text')]
            else:
                params = []
            unknown = True
        else:
            unknown = False

        # ABI биндингов (AGENTS.md §4.4): второй параметр всегда int n;
        # string-параметр приходит как void* qs (fromQString — конвертирует и освобождает).
        # ESlot — только __gshared (§4.3), иначе GC удалит → crash.
        cb_parts = ['void* dthis', 'int n']
        for t, nm in params:
            cb_parts.append('void* qs' if t == 'string' else f'{t} {nm}')
        print(f"__gshared ESlot sl_{fn_name};")
        print(f"extern(C) void {fn_name}({', '.join(cb_parts)}) {{")
        str_convs = [nm for t, nm in params if t == 'string']
        for nm in str_convs:
            print(f"    string {nm} = fromQString(qs);")
        show_args = [nm for _, nm in params]
        if show_args:
            print(f"    writefln(\"{fn_name}: %s\", {show_args[0]});")
        else:
            print(f"    writeln(\"{fn_name}\");")
        print("}")
        print(f"sl_{fn_name} = new ESlot({var}.getWH());")
        print(f"sl_{fn_name}.set(cast(void*)&{fn_name});")
        print(f"{var}.{conn}(sl_{fn_name});")
        if unknown:
            print(f"// ^ callback-параметры уточните по документации Qt (int n — обязателен)")
        print()


def _snippet_events(class_name: str, class_map: dict, arch_root: Path):
    info = scan_class_info(class_name, class_map, arch_root)
    if not info:
        print(f"ERROR: класс '{class_name}' не найден.")
        sys.exit(1)

    var = class_name[1].lower() + class_name[2:]

    print(f"\n// ── events: {class_name} ──────────────────────────────────")
    print(f"// dthis — ваш указатель контекста (может быть null)")
    print()

    for ev in info['events']:
        params = KNOWN_EVENTS.get(ev, [])
        cb_sig = _cb_params_str(params, include_dthis=True)
        print(f"extern(C) void {ev[2:].lower()}_handler{cb_sig} {{")
        print(f"    writeln(\"{ev}\");")
        print("}")
        print(f"{var}.{ev}(cast(void*)&{ev[2:].lower()}_handler);")
        print()


def _snippet_app_min(title: str | None):
    t = title or "MyApp"
    print(f"""
// ── minimal app skeleton ─────────────────────────────────────────
import qte56_core;
import qte56_loader;
import gen_qcore;
import gen_qwidget;
import std.stdio : writeln;

void main() {{
    LoadQt("./dll");
    auto app = new QApplication("{t}");

    auto win = new QWidget(cast(void*)null);
    win.setWindowTitle("{t}");
    win.resize(640, 480);
    win.show();

    app.exec();
    app.deleteApp();
}}
""")


# ── layout ────────────────────────────────────────────────────────────────────
def _snippet_layout(target: str | None):
    cls = target or 'QVBoxLayout'
    box_cls = cls if cls in ('QVBoxLayout', 'QHBoxLayout', 'QGridLayout') else 'QVBoxLayout'
    print(f"""
// ── layout: {box_cls} ────────────────────────────────────────
auto win = new QWidget(cast(void*)null);
win.setWindowTitle("Layout Demo");
win.resize(400, 300);

auto lbl  = new QLabel("Label",     win.getWH());
auto edit = new QLineEdit(          win.getWH());
auto btn  = new QPushButton("OK",   win.getWH());

auto layout = new {box_cls}();
layout.addWidget(lbl.getWH());
layout.addWidget(edit.getWH());
layout.addWidget(btn.getWH());
win.setLayout(layout.getWH());
layout.disown();   // Qt owns layout after setLayout

win.show();
""")


# ── dialog ────────────────────────────────────────────────────────────────────
def _snippet_dialog():
    print("""
// ── QDialog with OK/Cancel ──────────────────────────────────
auto dlg = new QDialog(parent.getWH());
dlg.setWindowTitle("Dialog");
dlg.resize(300, 150);

auto lbl  = new QLabel("Are you sure?", dlg.getWH());
auto btnOk     = new QPushButton("OK",     dlg.getWH());
auto btnCancel = new QPushButton("Cancel", dlg.getWH());

auto hbox = new QHBoxLayout();
hbox.addWidget(btnOk.getWH());
hbox.addWidget(btnCancel.getWH());
hbox.disown();

auto vbox = new QVBoxLayout();
vbox.addWidget(lbl.getWH());
vbox.addLayout(hbox.getWH());
dlg.setLayout(vbox.getWH());
vbox.disown();

extern(C) void onOk()     { writeln("OK");     }
extern(C) void onCancel() { writeln("Cancel"); }
auto slOk     = new ESlot(btnOk.getWH());     slOk.set(cast(void*)&onOk);
auto slCancel = new ESlot(btnCancel.getWH()); slCancel.set(cast(void*)&onCancel);
btnOk.connect_clicked(slOk);
btnCancel.connect_clicked(slCancel);

// Modal: dlg.exec(); or Modeless: dlg.show();
int result = dlg.exec();   // returns QDialog.Accepted(1) / Rejected(0)
writefln("Dialog result: %d", result);
""")


# ── mdi ───────────────────────────────────────────────────────────────────────
def _snippet_mdi():
    print("""
// ── QMdiArea + QMdiSubWindow ─────────────────────────────────
// GOTCHA: addSubWindow() returns plain void* — do NOT use eQMdiSubWindow.
// Correct pattern: create QMdiSubWindow manually, then setWidget.
auto win = new QMainWindow(cast(void*)null);
win.resize(900, 600);

auto mdi = new QMdiArea(win.getWH());
win.setCentralWidget(mdi.getWH());

// Create subwindow: container widget + your child widget
auto container = new QWidget(cast(void*)null);
auto editor    = new QTextEdit(container.getWH());
editor.resize(400, 300);

auto msw = new QMdiSubWindow(mdi.getWH());
msw.setWidget(container.getWH());
msw.setWindowTitle("Document");
msw.resize(420, 320);
mdi.addSubWindow(msw.getWH(), 0);
msw.show();

// Close handler — set parent to null BEFORE close to avoid crash
extern(C) void onSubClose(void* dthis) {
    (cast(QTextEdit)dthis).setParent(null);
}
msw.onClose(cast(void*)&onSubClose, cast(void*)editor);

win.show();
""")


# ── model-view ────────────────────────────────────────────────────────────────
def _snippet_model_view(target: str):
    kind = target.lower()
    if 'tree' in kind or kind == 'qtreewidget':
        print("""
// ── QTreeWidget ───────────────────────────────────────────────
auto tree = new QTreeWidget(parent.getWH());
tree.setColumnCount(2);
tree.setHeaderLabels(["Name", "Value"]);

// Top-level item
auto root = new QTreeWidgetItem();
root.setText(0, "Root");
root.setText(1, "root_val");
tree.addTopLevelItem(root.getWH()); root.disown();

// Child item
auto child = new QTreeWidgetItem();
child.setText(0, "Child");
child.setText(1, "child_val");
root.addChild(child.getWH()); child.disown();

tree.expandAll();

// Selection signal
extern(C) void onItemClicked(void* item, int col) {
    auto it = QTreeWidgetItem.wrap(item);
    writefln("clicked: %s  col=%d", it.text(0), col);
}
tree.onItemClicked(cast(void*)&onItemClicked);
""")
    else:
        print("""
// ── QTableWidget ─────────────────────────────────────────────
auto tw = new QTableWidget(parent.getWH());
tw.setRowCount(4);
tw.setColumnCount(3);
tw.setHorizontalHeaderLabels(["Name", "Value", "Note"]);

foreach (r; 0 .. 4) {
    foreach (c; 0 .. 3) {
        auto item = new QTableWidgetItem();
        item.setText(format("r%d c%d", r, c));
        tw.setItem(r, c, item);   // Qt owns item after setItem
    }
}
tw.resizeColumnsToContents();

// Selection signal
extern(C) void onCellClicked(int row, int col) {
    writefln("cell [%d,%d]", row, col);
}
auto slCell = new ESlot(tw.getWH());
slCell.set(cast(void*)&onCellClicked);
tw.connect_cellClicked(slCell);
""")


# ── settings ──────────────────────────────────────────────────────────────────
def _snippet_settings():
    print("""
// ── QSettings: save/restore geometry ────────────────────────
// Save (on close or any point):
auto s = new QSettings("./myapp.ini", 1);   // 1 = IniFormat
auto geo = win.saveGeometry();
s.setBytes("geometry", geo);
auto state = win.saveState();               // QMainWindow only
s.setBytes("state", state);
s.sync();

// Restore (after win creation, before show):
auto storedGeo = s.getBytes("geometry");
if (storedGeo.length > 0)
    win.restoreGeometry(storedGeo);
auto storedState = s.getBytes("state");
if (storedState.length > 0)
    win.restoreState(storedState);

// Other value types:
s.setValue("fontSize", 12);
s.setValue("theme",    "dark");
int   fontSize = s.getInt("fontSize",    12);
string theme   = s.getString("theme",  "light");
""")


# ── file-io ───────────────────────────────────────────────────────────────────
def _snippet_file_io():
    print("""
// ── QFile: read / write ──────────────────────────────────────
import gen_qfile;

// Write text
{
    auto f = new QFile("output.txt");
    if (!f.open(0x2))   // WriteOnly = 0x2
        writeln("Cannot open for write: ", f.errorString());
    else {
        f.writeText("Hello, World!\\n");
        f.close();
    }
}

// Read text
{
    auto f = new QFile("output.txt");
    if (!f.open(0x1))   // ReadOnly = 0x1
        writeln("Cannot open for read: ", f.errorString());
    else {
        string text = f.readAllText();
        writeln("Read: ", text);
        f.close();
    }
}

// Read binary
{
    auto f = new QFile("data.bin");
    if (f.open(0x1)) {
        ubyte[] data = f.readAll();
        writefln("Read %d bytes", data.length);
        f.close();
    }
}

// Check / size / delete
if (QFile.exists("output.txt")) {
    writefln("size = %d", QFile.fileSize("output.txt"));
    QFile.remove("output.txt");
}
""")


# ── timer ─────────────────────────────────────────────────────────────────────
def _snippet_timer():
    print("""
// ── QTimer ───────────────────────────────────────────────────
import gen_qtimer;

int tickCount = 0;

extern(C) void onTick() {
    tickCount++;
    writefln("tick #%d", tickCount);
    // if (tickCount >= 10) timer.stop();  // access via closure or global
}

auto timer = new QTimer();
auto slTick = new ESlot(timer.getWH());
slTick.set(cast(void*)&onTick);
timer.connect_timeout(slTick);

timer.start(500);       // every 500 ms
// timer.setSingleShot(true); timer.start(2000);  // one-shot after 2s

// Don't forget: timer.stop() before app exit if needed
""")


# ── painter ───────────────────────────────────────────────────────────────────
def _snippet_painter():
    print("""
// ── QPainter in onPaint ──────────────────────────────────────
import gen_qpainter;
import gen_qcolor;

// onPaint callback — painter is created internally by Qt,
// wrap it and draw, then call end() before returning.
extern(C) void paintHandler(void* dthis, void* painterPtr) {
    auto p = new QPainter(painterPtr, true);  // true = begin already called

    // Background
    p.fillRect(0, 0, 400, 300, 0xFF1E1E2E);  // ARGB dark bg

    // Text
    auto color = new QColor(255, 255, 255, 255);  // white
    p.setPen(color.getWH());
    p.drawText(20, 40, "Hello from QPainter");

    // Rectangle outline
    p.setPen(1);             // Qt::SolidLine
    p.drawRect(20, 60, 200, 100);

    // Filled rectangle
    p.fillRect(20, 180, 100, 50, 0xFF336699);

    // Line
    p.drawLine(0, 0, 400, 300);

    p.end();
}

widget.onPaint(cast(void*)&paintHandler);

// Trigger repaint:
widget.update();
""")


# ── tray ──────────────────────────────────────────────────────────────────────
def _snippet_tray():
    print("""
// ── QSystemTrayIcon ──────────────────────────────────────────
import gen_qsystemtrayicon;
import gen_qicon;
import gen_qmenu;

auto tray = new QSystemTrayIcon();

// Icon (load from file or resource)
auto icon = new QIcon();
icon.addFile(":/icons/app.png");
tray.setIcon(icon.getWH());
tray.setToolTip("My Application");

// Context menu
auto menu    = new QMenu(cast(void*)null);
auto actShow = menu.addAction("Show");
auto actQuit = menu.addAction("Quit");
tray.setContextMenu(menu.getWH());

// Signals
extern(C) void onActivated(int reason) {
    // reason: 1=Context, 2=DoubleClick, 3=Trigger, 4=MiddleClick
    if (reason == 2)   // DoubleClick
        writeln("tray double-clicked");
}
extern(C) void onMsgClicked() {
    writeln("notification clicked");
}
tray.connect_activated(cast(void*)&onActivated);
tray.connect_messageClicked(cast(void*)&onMsgClicked);

tray.show();

// Balloon notification
tray.showMessage("Hello", "App is running", 1, 3000);  // 1=Info, 3000ms
""")


# ── splash ────────────────────────────────────────────────────────────────────
def _snippet_splash():
    print("""
// ── QSplashScreen ────────────────────────────────────────────
import gen_qsplashscreen;
import gen_qpixmap;

// Create splash before QApplication.exec()
auto pxm = new QPixmap(480, 280);
pxm.fill(0xFF003366);   // dark blue background

auto splash = new QSplashScreen(pxm.getWH());
splash.show();
splash.showMessage("Loading...", 0x44, 0xFFFFFFFF);
// 0x44 = Qt::AlignHCenter | Qt::AlignBottom, white text
app.processEvents();   // ensure splash is painted

// --- your heavy init here ---
// loadPlugins();
// connectDatabase();

splash.showMessage("Connecting to database...", 0x44, 0xFFFFFFFF);
app.processEvents();

// --- end of init ---

auto win = new QMainWindow(cast(void*)null);
win.resize(800, 600);
win.show();

splash.finish(win.getWH());  // closes splash when main window is ready
""")


# ── check-funcs ───────────────────────────────────────────────────────────────
def _snippet_check_funcs(class_name: str, class_map: dict, arch_root: Path):
    idx_min, idx_max, idx_cnt = get_class_indices(class_name, arch_root)
    if idx_min is None:
        print(f"ERROR: индексы для '{class_name}' не найдены в functions.csv")
        sys.exit(1)

    # Читаем реальные индексы для этого класса
    csv = arch_root / 'registry' / 'functions.csv'
    indices = []
    for line in csv.read_text(encoding='utf-8', errors='replace').splitlines():
        if line.startswith('#') or not line.strip():
            continue
        parts = line.split(',')
        if len(parts) >= 3 and parts[2].strip() == class_name:
            try:
                indices.append(int(parts[0]))
            except ValueError:
                pass

    idx_list = ', '.join(str(i) for i in sorted(indices))
    print(f"""
// ── check pFunQt indices: {class_name} ──────────────────────
// Проверяет что все {idx_cnt} функций {class_name} загружены корректно.
// Вставьте после LoadQt() перед первым использованием класса.
{{
    import std.format : format;
    static immutable int[] {class_name}_indices = [
        {idx_list}
    ];
    int nullCount = 0;
    foreach (i; {class_name}_indices) {{
        if (pFunQt[i] is null) {{
            writefln("  pFunQt[%d] = null  ({class_name})", i);
            nullCount++;
        }}
    }}
    if (nullCount == 0)
        writeln("  {class_name}: all {idx_cnt} functions OK");
    else
        writefln("  {class_name}: %d / {idx_cnt} functions MISSING", nullCount);
}}
""")


# ── wren-bridge ───────────────────────────────────────────────────────────────
def _snippet_wren_bridge():
    print("""
// ── WrenVM bridge skeleton ───────────────────────────────────
import wren_vm;     // d/wren/wren_vm.d (or path adjusted in bat)
import std.string : toStringz;

// Optional: custom output handlers
extern(C) void wrenWrite(void* ud, const(char)* text) {
    import std.stdio : write;
    import core.stdc.string : strlen;
    write(text[0 .. strlen(text)]);
}
extern(C) void wrenError(void* ud, int type,
                          const(char)* mod, int line,
                          const(char)* msg) {
    import std.stdio : writefln;
    writefln("[wren error] %s:%d  %s",
        mod[0..core.stdc.string.strlen(mod)], line,
        msg[0..core.stdc.string.strlen(msg)]);
}

// Create VM
LoadWren();
auto vm = new WrenVM(&wrenWrite, &wrenError);

// Optional: add .wren library search path
vm.addLibPath("wren/lib");

// Register Qt widget so Wren can access it:
// vm.setWidget("mainWindow", win.getWH());

// Run inline script
int rc = vm.interpret("main", `
    import "qt" for Widget
    class App {
        static run() {
            System.print("Hello from Wren!")
        }
    }
`);
if (rc != 0) writeln("Wren error");

// Call static method from D:
vm.argString(1, "world");
rc = vm.call("main", "App", "run()");
if (rc == 0 && vm.resultType() == 2)   // 2 = string
    writeln("result: ", vm.resultString());

// Load from file:
// rc = vm.loadFile("scripts/main.wren");

vm.free();
""")


# ── --new-app ─────────────────────────────────────────────────────────────────

# Шаблоны минимального кода для популярных классов
_WIDGET_SETUP: dict[str, str] = {
    'QMainWindow':   'auto {v} = new QMainWindow(cast(void*)null);\n'
                     '    {v}.setWindowTitle("{app}");\n'
                     '    {v}.resize(800, 600);',
    'QWidget':       'auto {v} = new QWidget(cast(void*)null);\n'
                     '    {v}.setWindowTitle("{app}");\n'
                     '    {v}.resize(640, 480);',
    'QDialog':       'auto {v} = new QDialog(cast(void*)null);\n'
                     '    {v}.setWindowTitle("{app}");',
    'QTextEdit':     'auto {v} = new QTextEdit(win.getWH());\n'
                     '    {v}.setPlainText("Hello from {app}");',
    'QPlainTextEdit':'auto {v} = new QPlainTextEdit(win.getWH());',
    'QPushButton':   'auto {v} = new QPushButton("Click me", win.getWH());',
    'QLabel':        'auto {v} = new QLabel("Label", win.getWH());',
    'QLineEdit':     'auto {v} = new QLineEdit(win.getWH());',
    'QListWidget':   'auto {v} = new QListWidget(win.getWH());',
    'QTreeWidget':   'auto {v} = new QTreeWidget(win.getWH());\n'
                     '    {v}.setColumnCount(2);\n'
                     '    {v}.setHeaderLabels(["Name", "Value"]);',
    'QTableWidget':  'auto {v} = new QTableWidget(win.getWH());\n'
                     '    {v}.setRowCount(5);\n'
                     '    {v}.setColumnCount(3);',
    'QVBoxLayout':   'auto {v} = new QVBoxLayout();\n'
                     '    win.setLayout({v}.getWH()); {v}.disown();',
    'QHBoxLayout':   'auto {v} = new QHBoxLayout();\n'
                     '    win.setLayout({v}.getWH()); {v}.disown();',
    'QMenuBar':      'auto {v} = win.menuBar();\n'
                     '    auto menuFile = {v}.addMenu("File");\n'
                     '    menuFile.addAction("Exit");',
    'QStatusBar':    'auto {v} = win.statusBar();\n'
                     '    {v}.showMessage("Ready");',
    'QToolBar':      'auto {v} = win.addToolBar("Main");\n'
                     '    {v}.addAction("Action");',
    'QSplitter':     'auto {v} = new QSplitter(0, win.getWH()); // 0=Horizontal',
    'QTabWidget':    'auto {v} = new QTabWidget(win.getWH());\n'
                     '    auto tab1 = new QWidget({v}.getWH());\n'
                     '    {v}.addTab(tab1.getWH(), "Tab 1");',
    'QComboBox':     'auto {v} = new QComboBox(win.getWH());\n'
                     '    {v}.addItem("Item 1");\n'
                     '    {v}.addItem("Item 2");',
}

_MAIN_CLASSES = {'QMainWindow', 'QWidget', 'QDialog'}


def cmd_new_app(app_name: str, use_classes: list[str],
                class_map: dict, dep_map: dict, arch_root: Path):
    # Определяем "главный" класс окна
    main_cls = next((c for c in use_classes if c in _MAIN_CLASSES), None)
    if main_cls is None:
        main_cls = 'QWidget'
        if main_cls not in use_classes:
            use_classes = [main_cls] + use_classes

    # Собираем нужные модули
    all_classes = set(use_classes)
    needed_mods = set()
    for cls in all_classes:
        if cls in class_map:
            needed_mods.add(class_map[cls])
    needed_mods = resolve_deps(needed_mods, dep_map)
    gen_mods    = order_modules(needed_mods)

    # Строки import
    imports = ['import qte56_core;', 'import qte56_loader;']
    for m in gen_mods:
        imports.append(f'import {m};')
    imports.append('import std.stdio : writeln, writefln;')
    imports_str = '\n'.join(imports)

    # Блок setup-кода
    setup_lines = []
    main_var = None
    for cls in use_classes:
        v = cls[1].lower() + cls[2:]    # QMainWindow → ainWindow → mw? just lowercase[1:]
        # короткое имя переменной
        short = {
            'QMainWindow': 'win', 'QWidget': 'win', 'QDialog': 'dlg',
            'QVBoxLayout': 'vbox', 'QHBoxLayout': 'hbox',
            'QMenuBar': 'menuBar', 'QStatusBar': 'statusBar', 'QToolBar': 'toolBar',
            'QTextEdit': 'editor', 'QPlainTextEdit': 'editor',
            'QPushButton': 'btn', 'QLabel': 'lbl', 'QLineEdit': 'edit',
            'QComboBox': 'combo', 'QListWidget': 'list_',
            'QTreeWidget': 'tree', 'QTableWidget': 'table',
            'QSplitter': 'splitter', 'QTabWidget': 'tabs',
        }.get(cls, v[:8])

        if cls == main_cls and main_var is None:
            main_var = short

        tmpl = _WIDGET_SETUP.get(cls,
               f'auto {short} = new {cls}(win.getWH()); // TODO: setup {cls}')
        line = tmpl.format(v=short, app=app_name)
        setup_lines.append(line)

    if main_var is None:
        main_var = 'win'

    setup_str = '\n    '.join(setup_lines)

    # Генерируем .d файл
    d_text = f"""\
/**
 * {app_name}.d — generated by make_build.py
 */
{imports_str}

void main() {{
    LoadQt("./dll");
    auto app = new QApplication("{app_name}");

    {setup_str}

    {main_var}.show();
    app.exec();
    app.deleteApp();
}}
"""

    d_path = arch_root / f'{app_name}.d'
    d_path.write_text(d_text, encoding='utf-8')
    print(f"Создан: {d_path}")

    # Генерируем build-скрипты
    source_rel = f'{app_name}.d'
    out_rel    = app_name
    need_enums = False
    extra_d    = []

    # bat/sh размещаются в корне arch_root → levels_up=0
    bat_text = gen_bat(source_rel, out_rel, gen_mods, extra_d, need_enums, levels_up=0)
    sh_text  = gen_sh (source_rel, out_rel, gen_mods, extra_d, need_enums, levels_up=0)

    bat_path = arch_root / f'build_{app_name}.bat'
    sh_path  = arch_root / f'build_{app_name}.sh'
    bat_path.write_text(bat_text, encoding='utf-8')
    sh_path.write_text(sh_text, encoding='utf-8')
    sh_path.chmod(sh_path.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP)
    print(f"Создан: {bat_path}")
    print(f"Создан: {sh_path}")
    print(f"\nИспользуемые классы : {', '.join(use_classes)}")
    print(f"gen_* модулей       : {len(gen_mods)}")


# ── Ядро: обработка одного .d файла ───────────────────────────────────────────
def process_source(source: Path, arch_root: Path,
                   class_map: dict, dep_map: dict, file_map: dict = None,
                   args_out=None, quiet=False):
    try:
        source_rel = source.resolve().relative_to(arch_root).as_posix()
    except ValueError:
        source_rel = source.as_posix()

    if args_out:
        out_rel = args_out.replace('\\', '/')
    else:
        src_rel_parts = Path(source_rel)
        out_rel = (src_rel_parts.parent / src_rel_parts.stem).as_posix()

    q_classes, explicit_mods, all_idents = scan_source(source)

    needed       = set(explicit_mods)
    not_found    = []
    class_origin = {}

    for cls in sorted(q_classes):
        if cls in QCORE_BUILTINS:
            class_origin[cls] = 'gen_qcore  (base)'
            continue
        if cls in class_map:
            mod = class_map[cls]
            class_origin[cls] = mod
            needed.add(mod)
        else:
            class_origin[cls] = '???'
            not_found.append(cls)

    needed = resolve_deps(needed, dep_map)

    extra_d = []
    for triggers, path in EXTRA_D_MODULES:
        if triggers & all_idents:
            extra_d.append(path)

    need_enums = bool(ENUMS_TRIGGERS & all_idents)

    gen_mods = order_modules(needed)

    if not quiet:
        W = 60
        SEP = '=' * W
        print()
        print(SEP)
        print('  Найденные Q-классы:')
        for cls in sorted(class_origin):
            print(f"    {cls:<34} -> {class_origin[cls]}")
        if not_found:
            print()
            print(f"  ВНИМАНИЕ: не распознано {len(not_found)} классов:")
            for c in not_found:
                print(f"    {c}")
        print()
        print("  Рекомендуемые import в .d файле:")
        print("    import qte56_core;")
        print("    import qte56_loader;")
        if need_enums:
            print("    import qte56_enums;")
        for mod in gen_mods:
            print(f"    import {mod};")
        for ed in extra_d:
            print(f"    import {Path(ed).stem};")
        print()
        print(f"  gen_* модулей: {len(gen_mods)}" +
              (" + enums" if need_enums else ""))
        for mod in gen_mods:
            print(f"    d/gen/{mod}.d")
        print(SEP)
        print()

    # ── Проверка существования файлов ────────────────────────────────────────
    missing = check_project_files(arch_root, gen_mods, extra_d, need_enums)
    if missing:
        print(f"  ПРЕДУПРЕЖДЕНИЕ: {len(missing)} файлов не найдено в {arch_root}:")
        for m in missing:
            print(f"    MISSING: {m}")
        print()

    return source_rel, out_rel, gen_mods, extra_d, need_enums


# ── main ───────────────────────────────────────────────────────────────────────
def main():
    ap = argparse.ArgumentParser(
        description='Генератор команды компиляции D/Qt файла'
    )
    ap.add_argument('source', nargs='?', default=None,
                    help='Путь к .d файлу (не нужен при --update-all)')
    ap.add_argument('--out',  default=None,
                    help='Имя выходного файла без расширения')
    ap.add_argument('--bat',  default=None, help='Записать .bat в файл')
    ap.add_argument('--sh',   default=None, help='Записать .sh в файл')
    ap.add_argument('--update-all', action='store_true',
                    help='Перегенерировать test/build_*.bat для всех test/test_*.d')
    ap.add_argument('--scanqt', action='store_true',
                    help='Сканировать дочерние папки CWD для автоопределения путей Qt')
    ap.add_argument('--info', metavar='CLASSNAME', default=None,
                    help='Показать информацию о Q-классе (методы, сигналы, индексы)')
    ap.add_argument('--snippet', metavar='TYPE', nargs='+',
                    help='Генерировать сниппет: signal-slot CLASS | event CLASS | app-min [TITLE]')
    ap.add_argument('--new-app', metavar='APPNAME', default=None,
                    help='Создать скелет приложения APPNAME.d + build-скрипты')
    ap.add_argument('--use', metavar='CLASSES', default=None,
                    help='Классы для --new-app через запятую: QMainWindow,QTextEdit,...')
    args = ap.parse_args()

    # Поиск корня
    if args.source:
        search_start = Path(args.source).resolve().parent
    else:
        search_start = Path.cwd()
    arch_root = find_arch_root(search_start)

    # ── --scanqt: показать где установлен Qt (информационно) ─────────────────
    if args.scanqt:
        scan_root = Path.cwd()
        print(f"\nСканирование Qt в: {scan_root}")
        found = scan_qt_paths(scan_root)
        print_scan_result(found, DEFAULT_QT_BIN, DEFAULT_QT_MINGW)
        print("  (пути Qt в bat-файлах задаются через local.env.bat)")
        print()

        # Если запустили --scanqt без файла и без --update-all — только показать
        if not args.source and not args.update_all:
            return

    # Сканирование gen_* один раз
    print(f"Корень проекта : {arch_root}")
    print("Сканирование gen_*.d ...", end=' ', flush=True)
    class_map, dep_map, file_map = scan_gen_modules(arch_root)
    print(f"{len(class_map)} классов, {len(file_map)} модулей")

    # ── --info ─────────────────────────────────────────────────────────────────
    if args.info:
        cmd_info(args.info, class_map, dep_map, arch_root)
        return

    # ── --snippet ──────────────────────────────────────────────────────────────
    if args.snippet:
        snip_args = args.snippet
        snip_type = snip_args[0]
        snip_target = snip_args[1] if len(snip_args) > 1 else None
        cmd_snippet(snip_type, snip_target, class_map, arch_root)
        return

    # ── --new-app ──────────────────────────────────────────────────────────────
    if args.new_app:
        use_raw = args.use or 'QWidget'
        use_classes = [c.strip() for c in use_raw.split(',') if c.strip()]
        cmd_new_app(args.new_app, use_classes, class_map, dep_map, arch_root)
        return

    # ── Режим --update-all ─────────────────────────────────────────────────────
    if args.update_all:
        test_dir = arch_root / 'test'
        sources  = sorted(test_dir.glob('test_*.d'))
        print(f"\nОбновление {len(sources)} build-скриптов...\n")
        updated = 0
        for src in sources:
            stem = src.stem  # test_qwidget
            # bat/sh called build_<name> where name strips the test_ prefix
            name = stem[5:] if stem.startswith('test_') else stem  # qwidget
            bat_path = test_dir / f'build_{name}.bat'
            sh_path  = test_dir / f'build_{name}.sh'

            source_rel, out_rel, gen_mods, extra_d, need_enums = process_source(
                src, arch_root, class_map, dep_map, file_map,
                args_out=f'test/{stem}', quiet=True
            )

            bat_text = gen_bat(source_rel, out_rel, gen_mods, extra_d, need_enums)
            sh_text  = gen_sh (source_rel, out_rel, gen_mods, extra_d, need_enums)

            bat_path.write_text(bat_text, encoding='utf-8')
            sh_path.write_text(sh_text,   encoding='utf-8')
            sh_path.chmod(sh_path.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP)
            print(f"  {stem:<40} {len(gen_mods)} модулей")
            updated += 1

        print(f"\nОбновлено: {updated} пар bat/sh")
        return

    # ── Обычный режим: один файл ───────────────────────────────────────────────
    if not args.source:
        ap.print_help()
        sys.exit(1)

    source = Path(args.source)
    if not source.exists():
        sys.exit(f"ERROR: файл не найден: {source}")

    print(f"Исходник       : {source.resolve()}")
    print()

    source_rel, out_rel, gen_mods, extra_d, need_enums = process_source(
        source, arch_root, class_map, dep_map, file_map,
        args_out=args.out, quiet=False
    )

    bat_text = gen_bat(source_rel, out_rel, gen_mods, extra_d, need_enums)
    sh_text  = gen_sh (source_rel, out_rel, gen_mods, extra_d, need_enums)

    W = 60
    if args.bat:
        Path(args.bat).write_text(bat_text, encoding='utf-8')
        print(f"Записан: {args.bat}")
    else:
        print('-- Windows .bat ' + '-' * (W - 16))
        print(bat_text)

    if args.sh:
        sh_path = Path(args.sh)
        sh_path.write_text(sh_text, encoding='utf-8')
        sh_path.chmod(sh_path.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP)
        print(f"Записан: {args.sh}")
    else:
        print('-- Linux .sh ' + '-' * (W - 13))
        print(sh_text)


if __name__ == '__main__':
    main()
