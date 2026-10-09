# MIDE — mini IDE for M language

> ↑ Навигация: [AGENTS.md](../../AGENTS.md)
>
> См. также: [MINIMONO.md](MINIMONO.md) — архитектура и справка MiniMono 6.1.

Современная (QTE56) реинкарнация старого `src_m/mide5.d` — IDE для языка M
(вариант MUMPS/Caché) с подключением к runtime MiniMono.

## Статус

| Этап | Цель | Статус |
|---|---|---|
| 0 | Разведка покрытия QTE56 | ✅ |
| 1 | Скелет: QMainWindow + QMdiArea + меню/тулбар/statusbar | ✅ |
| 2 | CConsoleWin: консоль выполнения M (`console.d`) | ✅ |
| 3 | CEditWin: редактор + line-numbers + syntax highlight (`editor.d`) | ✅ (без автокомплита) |
| 4 | MDI интеграция, открытие файлов, шаблоны | ⏳ (текущий; MDI и открытие файлов есть, шаблоны — нет) |
| 5 | Полировка, конфиг, тесты на реальном M-сервере | ⏳ |

## Сборка и запуск

```cmd
apps\mide\build.bat              :: сборка + запуск
apps\mide\build.bat --norun      :: только сборка
apps\mide\build.bat --release    :: -O -release -inline
```

```bash
apps/mide/build.sh
apps/mide/build.sh --norun
```

## CLI

```
mide.exe                         GUI с дефолтным mide.ini
mide.exe project.ini             с указанным INI
mide.exe -h | --help             справка
mide.exe -v | --version          версия
```

## Конфиг

`mide.ini` рядом с .exe (или `apps/mide/mide.ini` при запуске из корня).
Загружается через `QSettings(IniFormat)`. Секции:

- `[UI]` — размеры/позиция окна, режим MDI (Tabbed / SubWindow)
- `[Main]` — путь к файлу шаблонов (этап 4)
- `[Project]` — главный исходник, БД MiniMono (этап 4)
- `[Server]` — параметры подключения к MiniMono (этап 2)

## Архитектура

OO-стиль: `dthis = this` в QAction-обработчиках (см. `AI_SIGNALS_REF.md` →
"OO-стиль"). Всё состояние в полях класса `CFormaMain`, никаких глобальных
`__gshared`-переменных бизнес-логики (только `_alive[]` для защиты от GC).

## Зависимости

- QTE56 (qte56_core, qte56_widgets, qte56_text, qte56_dialogs, qte56_views, qte56_mainwin, qte56_foundation)
- Qt 5.13.2 MinGW 32-bit
- На этапе 2: qte56_textcodec (для cp1251 от M-сервера)
- На этапах 2-3: переиспользуем `src_m/qte5prs.d` (парсер автокомплита) и
  `src_m/minimono.d` / `src_m/zdll.d` (биндинг к runtime).
