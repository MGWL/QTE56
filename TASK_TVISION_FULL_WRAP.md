# ЗАДАНИЕ (на будущее): полная обёртка Turbo Vision для QTE56

> ↑ Навигация: [AGENTS.md](AGENTS.md)
> Статус: НЕ ВЫПОЛНЯТЬ без явной команды. Задание на будущее (составлено 2026-08-21).

## Цель

Обернуть все оставшиеся публичные классы magiblot/tvision (есть в исходниках
`tvision/`, скомпилированы внутрь `qte56_tvision.dll`, но не экспортированы):
C++ обёртки → пересборка DLL → биндинги в `d/gen/gen_tvision.d` → реестр → тесты.

## Доступ к C++ компилятору (ВАЖНО)

C++ toolchain на машине есть, но его нет в PATH:

- **Компилятор:** `C:\D\mingw32\bin\g++.exe` — GCC **14.2.0**, цель
  `i686-w64-mingw32` (32-bit, posix-dwarf). Там же `mingw32-make.exe`, `ar`.
- Перед сборкой: `set PATH=C:\D\mingw32\bin;%PATH%` и `set QTE56_ARCH=win32_qt5`,
  затем `tvision\build_tvision.bat` (BUILDDIR=`buildwin32_qt5`, DLLDIR=`dll32`).
- Проверено 2026-08-21: `teditor1.cpp` и `win32con.cpp` компилируются этим GCC
  с флагами из `build_tvision.bat` без ошибок.
- tvision собирается **без Qt** (голый `g++ -std=c++14` + инклуды tvision),
  поэтому GCC 14.2 вместо штатных 7.3 из Qt Tools — не проблема.
- `bin513\` — только Qt-runtime DLL + qmake.exe, компилятора там НЕТ.
- **dmc НЕ подходит** (нет C++14/исключений/RTTI нужного уровня) — не пытаться.
- Для DLL, линкующих Qt (`qte56_widgets` и др.), GCC 14.2 без дополнительной
  проверки ABI не использовать — это задание касается только tvision.

## Текущее состояние (снято 2026-08-21)

- DLL `dll/dll32/qte56_tvision.dll` экспортирует 43 функции `tv*` — все забиндены
  в `d/gen/gen_tvision.d` (индексы 19850–19884, 20155, 20169–20175).
- Свободные индексы: **20176–20999 (824 слота)** — продолжение tvision-блока.
- `build_tvision.bat` пропускает сборку `libtvision.a`, если она уже есть.
- Формат CSV: `index,name,Module,dll,kind` (5 колонок, UTF-8 без BOM, LF).
- В заголовке `cpp/qt5/qte56_tvision/qte56_tvision.h` есть мёртвая декларация
  `tvMenuBar_create` (нет в .cpp/DLL/реестре) — удалить при выполнении.

## Шаг 1. Подготовка и пересборка базы

1. Бэкапы: `tvision/buildwin32_qt5/libtvision.a` → `.bak`,
   `dll/dll32/qte56_tvision.dll` → `.bak`, `registry/functions.csv` → `.bak-<date>`.
2. Удалить `buildwin32_qt5/libtvision.a` и `*.o` → полная пересборка GCC 14.2
   (не смешивать объектники GCC 7.3 dwarf2 и GCC 14.2 posix-dwarf — исключения
   через границу .o опасны).
3. Сборка (см. «Доступ к компилятору»). Если отдельный файл не соберётся под
   GCC 14 — точечная правка флагов/дефайнов (TVISION_NO_STL уже задан).

## Шаг 2. C++ обёртки (cpp/qt5/qte56_tvision/qte56_tvision.{h,cpp})

Стиль существующий: `TV_EXPORT extern "C"`, имена `tv<Class>_<method>`,
строки `const char*` (кодировка — ответственность вызывающего, как сейчас),
вывод строк через `(void*, char* buf, int bufLen)`, bool→int, TRect → 4×int.

Распределение индексов (все блоки внутри 20176–20999):

| Блок | Классы | ~Функций |
|---|---|---|
| 20176–20225 | **TView-общее**: getBounds/setBounds/growMode/show/hide/focus/select/enable/disable/getOrigin/getSize, TGroup redraw, TDeskTop cascade/tile, TBackground create | 25 |
| 20226–20255 | **TScrollBar** (setParams/getValue/setValue/setRange), **TScroller** (scrollTo/setLimit) | 20 |
| 20256–20335 | **TEditor ядро**: insertText/insertFrom, delete/get/setSelection, getLineText, lineCount/charCount, cursor get/set, undo/redo/canUndo, search/replace, setBufLen | 50 |
| 20336–20365 | **TMemo** (create с scrollbar+indicator), **TFileEditor** (loadFile/saveFile/isModified), **TEditWindow**, **TIndicator** (setValue) | 20 |
| 20366–20425 | **Коллекции**: TStringCollection/TSortedCollection/TCollection (create/add/removeAt/count/at/free), **TListViewer** (focusItem/getFocused), **TListBox** (create/newList/getText), **TSortedListBox** | 35 |
| 20426–20465 | **stddlg**: TFileDialog (create+wildcards, exec → имя файла), TChDirDialog, TFileInputLine, TFileList, TFileInfoPane, TDirListBox, TDirCollection, TFileCollection | 30 |
| 20466–20495 | **textview**: TTextDevice, **TTerminal** (create/bufSize/next) | 15 |
| 20496–20545 | **outline**: TNode (create/add/remove), TOutlineViewer (focusNode/getNode), TOutline | 25 |
| 20546–20595 | **validate**: TValidator base, TFilterValidator, TRangeValidator (min/max), TPXPictureValidator, TStringLookupValidator, attach к TInputLine (setValidator) | 25 |
| 20596–20645 | **colorsel**: TColorSelector, TMonoSelector, TColorDisplay, TColorGroupList, TColorItemList, TColorDialog | 25 |
| 20646–20695 | **help**: THelpFile (open/close/getTopic), THelpTopic (параграфы/текст), THelpViewer, THelpWindow | 20 |
| 20696–20725 | **resource**: TResourceFile (open/close/get), TResourceCollection | 10 |
| 20726–20775 | **dialogs extras**: TParamText, TMultiCheckBoxes, THistory, THistoryWindow, THistoryViewer, **msgbox**: inputBox/inputBoxRect | 20 |
| 20776–20825 | **app extras**: TProgram getScreenSize, TWindow zoom/close, добор cmXXX-констант (cmYes/cmNo/cmCut/cmCopy/cmPaste/cmUndo...) через tvConst_* | 20 |

Итого ~330 функций (при 824 свободных). Точные сигнатуры — по заголовкам
`tvision/include/tvision/*.h` при написании.

Сознательное исключение из «буквально всё»: raw C++-стримы `tobjstrm.h`
(ipstream/opstream/fpstream) — оперируют `std::streambuf` и C++-объектами по
ссылке, из D невызываемы; вместо них фасады TResourceFile/THelpFile.

## Шаг 3. Реестр registry/functions.csv

Дописать строки блоками (модуль `Tvision`, dll `qte56_tvision.dll`).
Строго UTF-8, LF. Проверка: `tools/qte/qte.exe index check` + `qte trace`.

## Шаг 4. D-биндинги d/gen/gen_tvision.d

- `mixin(generateFunQt(idx, "tvX_y", "Tvision"))` для всех новых — в `loadTvision()`.
- Недостающие function-pointer алиасы — в private-блок.
- Типизированные обёртки в стиле существующих (`tvCheckBox`, `tvTerm*`):
  string → toStringz; строки-результаты → buf/fromStringz.
- Обновить header-комментарий файла (блоки индексов).

## Шаг 5. Сборка и верификация DLL

1. `tvision\build_tvision.bat` (PATH с mingw32).
2. PE-парсер экспортов (static parse PE-таблицы, НЕ ctypes — ctypes сегфолтится
   на этой DLL): экспорты DLL == generateFunQt 1:1 (43 + ~330).
3. Smoke: пересобрать `test/gui_tv_hello.d`, старт без crash.

## Шаг 6. Тесты

Новый `test/test_tv_widgets.d` (программный, стиль `test_qfilesystemwatcher.d`):
TvApp с пустыми коллбэками → создать каждый новый виджет → PASS/FAIL счётчик.
Editor (текст + getLineText), Memo, ListBox (3 строки + getText), ScrollBar,
FileDialog create, ParamText, MultiCheckBoxes, History, Terminal, Outline+TNode,
RangeValidator, ColorSelector. Сборка — `test/build_tv_widgets.bat`.

## Шаг 7. Документация

- `TVISION_KNOWLEDGE_TRANSFER.md`: §3 (таблица функций), §17.9 (новые блоки
  индексов), замечание про GCC 14.2 (`C:\D\mingw32`) в §2.1/§17.
- `AGENTS.md` §18: tvision-блок 19850–19884 + 20155 + 20169–20175 + 20176–20825.

## Риски

- **GCC 14.2 vs 7.3**: полная пересборка .a решает ABI-смешение; отдельные файлы
  могут потребовать точечных флагов.
- **Кодировка**: TV на Windows — CP866; тесты ASCII + явная конвертация.
- **Объём**: ~330 функций — работать блоками, компиляция C++ после каждого блока.
- Только 32-bit (dll64 tvision отсутствует — вне scope).

## Откат

Бэкапы .a/.dll/.csv из шага 1. Git-коммитов не делать без явной команды.
