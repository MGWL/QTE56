# Рекурсивный поиск DLL

Консольная утилита для Windows, которая рекурсивно анализирует зависимости DLL.

## Возможности

- Читает таблицу импорта PE-файла (EXE/DLL)
- Рекурсивно находит все зависимые DLL
- Показывает, какие DLL найдены, а какие — нет
- Выводит путь к найденным DLL
- Поддерживает список путей для поиска (PATH, custom)

## Сборка

```bash
cd apps/finddll
dmd -m32 finddll.d -of=finddll
```

## Использование

```bash
finddll.exe <путь_к_exe_или_dll>
```

Пример:
```bash
finddll.exe H:\qte56\arch_new\dll\dll32\qte56_qcore.dll
```

## Вывод

```
Анализ: qte56_qcore.dll
========================================
Зависимости (уровень 1):
  [OK]   Qt5Core.dll          → C:\Qt5_13_2\bin\Qt5Core.dll
  [OK]   kernel32.dll         → C:\Windows\System32\kernel32.dll
  [MISS] libgcc_s_dw2-1.dll   → не найдена

Рекурсивные зависимости Qt5Core.dll:
  [OK]   msvcrt.dll           → C:\Windows\System32\msvcrt.dll
  ...
```
