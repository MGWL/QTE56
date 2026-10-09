# QTE56 — Linux (Fedora) — Руководство по сборке и запуску

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [BUILD_KNOWLEDGE_TRANSFER.md](BUILD_KNOWLEDGE_TRANSFER.md)

## Статус

Linux-порт **полностью реализован** и протестирован.
Все консольные тесты проходят (34/34 PASS на Windows, аналогично на Linux).

| Компонент | Статус |
|-----------|--------|
| `qte56_loader.d` — dlopen/dlsym | ✅ Готов |
| `soName()` — auto-convert dll → libXXX.so | ✅ Готов |
| `LoadQt()` fallback dll→lib | ✅ Готов |
| `wren_vm.d` — Linux поддержка | ✅ Готов |
| `build_merged_dlls.sh` | ✅ Готов |
| `test/build_linux.sh` | ✅ Готов |
| QScintilla — системная (pkg-config) | ✅ Готов |
| GUI тесты под Linux | ✅ Работают |

---

## Шаг 1 — Зависимости (Fedora)

```bash
# Qt5 + build tools
sudo dnf install qt5-qtbase-devel qt5-qttools-devel gcc-c++ make

# D компилятор (ldc2 — рекомендуется)
sudo dnf install ldc

# Qt SQL
sudo dnf install qt5-qtsql qt5-qtsql-devel

# Qt UI Designer (для qte56_uiloader)
sudo dnf install qt5-designer

# QScintilla (системная библиотека — build_merged_dlls.sh обнаружит автоматически)
sudo dnf install qscintilla-qt5-devel
```

---

## Шаг 2 — Сборка всех .so

```bash
cd arch_new/
bash build_merged_dlls.sh
```

Скрипт автоматически:
- Находит `qmake` (qmake-qt5 или qmake)
- Очищает artеfакты предыдущей сборки (`*.o`, `Makefile`)
- Определяет системную QScintilla через `pkg-config`
- Собирает все группы: core, foundation, widgets, views, text, dialogs, mainwin
- Собирает специальные: sql, drawing, systray, resource, uiloader, qscintilla
- Собирает Wren bridge

Результат: `arch_new/lib/libqte56_*.so` и `arch_new/lib/libwren_bridge.so`

Параметры:
```bash
bash build_merged_dlls.sh --verbose       # подробный вывод
bash build_merged_dlls.sh --no-wren       # без Wren
bash build_merged_dlls.sh --no-scintilla  # без QScintilla
```

---

## Шаг 3 — Сборка и запуск консольных тестов

```bash
cd arch_new/

# Один тест:
bash test/build_linux.sh test_qsql

# Все тесты:
bash test/build_linux.sh all

# Только сборка (без запуска):
bash test/build_linux.sh all --no-run
```

---

## Шаг 4 — Запуск GUI тестов/демо вручную

```bash
cd arch_new/

# Сборка одного GUI теста:
py generator/make_build.py test/gui_qmainwindow.d --sh /tmp/b.sh
bash /tmp/b.sh

# Или вручную:
ldc2 test/gui_qmainwindow.d \
    d/qte56_core.d d/qte56_loader.d d/qte56_enums.d d/gen/*.d \
    d/qte56_style.d \
    -I. -Id/gen \
    -L-Wl,-rpath,'$ORIGIN/../lib' \
    -of=test/gui_qmainwindow

LD_LIBRARY_PATH=./lib ./test/gui_qmainwindow
```

> **KDE warning** `kf.windowsystem: Could not find any platform plugin` — безвредно,
> появляется на Fedora с KDE, не влияет на работу приложения.

---

## Различия Windows ↔ Linux

| Аспект | Windows | Linux |
|--------|---------|-------|
| Компилятор | `dmd -m32` | `ldc2` (64-бит) |
| Библиотеки | `dll/*.dll` | `lib/lib*.so` |
| Загрузка | `LoadLibrary` | `dlopen` |
| Символы | `GetProcAddress` | `dlsym` |
| Запуск | `PATH=dll;...` | `LD_LIBRARY_PATH=./lib` |
| imя DLL в D | `"qte56_widgets.dll"` | автоконвертируется → `"libqte56_widgets.so"` |
| LoadQt путь | `LoadQt("./dll")` | `LoadQt("./dll")` — loader сам найдёт `./lib` |

---

## Особенности ldc2

ldc2 строже DMD в следующих случаях:

### 1. Конструктор no-arg у родителя

DMD разрешает `this() {}` даже если родитель не имеет `this()`.
ldc2 выдаёт ошибку: _«cannot implicitly call base class constructor»_.

**Исправление**: вместо `this() {}` использовать:
```d
protected this(bool _noOp) { super(_noOp); }
```

### 2. Несовпадение числа аргументов в cast

DMD (32-bit cdecl) иногда не замечает когда function pointer cast имеет
неверное количество аргументов. ldc2 — замечает.

**Проверка**: `py generator/scan_ldc2_bugs.py` сканирует все `gen_*.d` на такие баги.

---

## Wren на Linux

```bash
# Wren bridge собирается автоматически в build_merged_dlls.sh
# Или отдельно:
cd arch_new/wren/c
qmake-qt5 wren_bridge.pro -spec linux-g++ CONFIG+=release
make -j$(nproc)
# Результат: arch_new/lib/libwren_bridge.so

# Тест Wren:
bash test/build_linux.sh test_wren_loader
```
