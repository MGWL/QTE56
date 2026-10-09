# План: тестовая DLL для проверки `_-Call"` в forthD

## 0. Цель и контекст

**Цель:** создать тестовую 32-битную DLL с функциями соглашений `cdecl`, `stdcall`, `pascal` (опционально `fastcall`, `thiscall`), принимающими **0..20 параметров**, и тест-скрипт на Форте, который проверяет корректность `_-Call"` из `stdlib.f` (forthD).

**Зачем:** перед оптимизацией и внесением `stdlib.f` в ядро нужно:
- зафиксировать текущее поведение `_-Call"` (baseline),
- поймать баги (`_CCN` нереентерабельна, ветки >4 параметров, порядок аргументов, баланс стеков),
- получить эталон для регрессии после оптимизации.

**Контекст проекта (минимум):**
- Каталог: `H:\qte56\arch_new\forth`
- Ядро: `forth.d` (~2190 строк, 32-бит, DMD `-m32` + naked asm).
- Консоль: `console_forth.d`, сборка `dmd -m32 forth.d console_forth.d -ofconsole_forth.exe`.
- `stdlib.f` — слова `Lib"`, `Library@`, `LibraryLoad`, `_-Call"`, `GADR-Call"`, `CDECL-Call"`, `WINAPI-Call"`.
- Загрузка: `console_forth.exe heap.f strings.f console.f wincon.f repl.f <файлы>`.
- `INCLUDED` из ядра убран — файлы грузятся **аргументами командной строки** (хост читает и скармливает `evalForth`).
- Стеки: TOS в `EAX`, стек данных на `EBP`, стек возвратов = `ESP`, локальный стек на `ESI`.
- `CALL_A` (callD) — полный шлюз Forth→D, `CALLB` (callD2) — упрощённый.
- `CONST`, `VAR`, `CREATE`, `DOES>`, `IF/ELSE/THEN`, `DO/LOOP`, `BEGIN/UNTIL`, `S"`, `[CHAR]`, `WORD` — в бутстрапе ядра.
- `S"` в интерпретации кладёт **две копии адреса** (WORD DUP) — учитывать в тестах.

---

## 1. Архитектура тестовой DLL

### 1.1. Соглашения вызова

| Соглашение | Кто чистит стек | Порядок аргументов | В D |
|---|---|---|---|
| `cdecl` | вызывающий | справа налево | `extern(C)` |
| `stdcall` (WINAPI) | callee | справа налево | `extern(Windows)` |
| `pascal` | callee | **слева направо** | нет → asm/naked |
| `fastcall` (опц.) | callee | первые 2 в ECX/EDX | нет → asm |
| `thiscall` (опц.) | callee | `this` в ECX | нет → asm |

**Обязательный минимум:** `cdecl`, `stdcall`. **Желательно:** `pascal` (проверка порядка). **Опционально:** `fastcall`, `thiscall` (если `_-Call"` их поддерживает — по коду не поддерживает, значит только для справки).

### 1.2. Число параметров

От **0 до 20** для каждого соглашения. Итого:
- cdecl: 21 функция
- stdcall: 21 функция
- pascal: 21 функция (или только 2..5 для проверки порядка)

**Итого ≥ 63 функции.**

### 1.3. Семантика функций

Каждая функция `name_N(a1, a2, ..., aN)` возвращает **свёртку, чувствительную к порядку**:

```
result = a1*1 + a2*2 + a3*3 + ... + aN*N
```

**Почему так:**
- коммутативная сумма (`a1+a2+...`) **не поймает** перепутанный порядок;
- взвешенная сумма (`a_i * i`) — поймает;
- лишний/недостающий аргумент — изменит результат;
- результат детерминирован и легко проверяется.

**Дополнительно:** для `pascal` использовать **вычитание**:
```
result = a1 - a2 - a3 - ... - aN
```
Это ещё чувствительнее к порядку.

**Крайний случай N=0:** возвращает `0` (нет аргументов).

**Крайний случай N=1:** возвращает `a1 * 1` = `a1`.

### 1.4. Утилитарные функции

| Функция | Назначение |
|---|---|
| `get_esp()` | вернуть `ESP` в момент вызова (проверка баланса машинного стека) |
| `get_ebp()` | вернуть `EBP` (проверка, что стек данных не тронут) |
| `marker(n)` | записать `n` в глобал `g_marker`, вернуть `n` (проверка порядка вызовов) |
| `get_marker()` | вернуть `g_marker` |
| `add_marker(n)` | `g_marker += n`, вернуть `g_marker` (проверка серии вызовов) |
| `identity(n)` | вернуть `n` (проверка передачи одного аргумента) |
| `sum_stack(n)` | вернуть сумму `n` верхних ячеек машинного стека (для отладки) |

---

## 2. Генерация DLL

### 2.1. Выбор инструмента

**Рекомендация:** D (`dmd -m32`) + Python-генератор `.d`-файла.

**Альтернатива:** DMC (Digital Mars C) — если нужен `.asm` для pascal/fastcall. Но D справляется через `naked asm`.

### 2.2. Структура проекта

```
test/
├── gen_testdll.py       # генератор .d-файла
├── testdll.d            # сгенерированный (не редактировать вручную)
├── testdll.dll          # скомпилированная DLL
├── testdll.lib          # импорт-библиотека (если нужна)
├── test_stdlib.f        # тест-скрипт на Форте
├── run_test.bat         # сборка + запуск
└── README.md            # описание
```

### 2.3. Генератор `gen_testdll.py`

**Вход:** `N_max = 20`, список соглашений `[cdecl, stdcall, pascal]`.

**Выход:** `testdll.d` с функциями.

**Шаблон для cdecl_N:**
```d
extern(C) int cdecl_N(int a1, int a2, ..., int aN) {
    return a1*1 + a2*2 + ... + aN*N;
}
```

**Шаблон для stdcall_N:**
```d
extern(Windows) int stdcall_N(int a1, int a2, ..., int aN) {
    return a1*1 + a2*2 + ... + aN*N;
}
```

**Шаблон для pascal_N (naked asm):**
```d
extern(Windows) int pascal_N() {
    asm { naked;
        // аргументы на стеке: [ESP+4]=a1, [ESP+8]=a2, ... [ESP+4*N]=aN
        // ВНИМАНИЕ: для истинного pascal порядок обратный, но D всё равно
        // передаёт как в сигнатуре. Для проверки порядка использовать
        // вычитание: a1 - a2 - ... - aN.
        mov EAX, [ESP+4];
        sub EAX, [ESP+8];
        sub EAX, [ESP+12];
        // ...
        ret 4*N;   // callee чистит
    }
}
```

**Проблема с pascal:** истинный pascal-порядок (слева направо) **не воспроизводится** через `extern(Windows)`. Чтобы проверить порядок, нужно:
- либо писать вызывающий код в asm (тогда не через `_-Call"`),
- либо использовать `extern(Windows)` с **обратным** порядком аргументов в сигнатуре:
  ```d
  extern(Windows) int pascal_N(int aN, ..., int a1) {
      return a1 - a2 - ... - aN;  // в теле a1 — последний аргумент
  }
  ```
  Тогда при вызове `1 2 3 pascal_3` аргументы лягут так, что `a1=3, a2=2, a3=1`, и результат `3-2-1=0`. Если `_-Call"` перепутает порядок — результат будет другим.

**Рекомендация:** для pascal использовать **обратный порядок в сигнатуре** + вычитание. Это проверит, что `_-Call"` кладёт аргументы **в правильном порядке**.

### 2.4. Утилитарные функции (вручную)

```d
extern(C) uint get_esp() {
    asm { naked; mov EAX, ESP; ret; }
}

extern(C) uint get_ebp() {
    asm { naked; mov EAX, EBP; ret; }
}

__gshared int g_marker = 0;

extern(C) int marker(int n) { g_marker = n; return n; }
extern(C) int get_marker() { return g_marker; }
extern(C) int add_marker(int n) { g_marker += n; return g_marker; }
extern(C) int identity(int n) { return n; }
```

### 2.5. Компиляция

```bat
dmd -m32 -shared -of=testdll.dll testdll.d
```

**Проверка:** `dumpbin /exports testdll.dll` (или `objdump -p testdll.dll`) — убедиться, что все функции экспортированы.

**Важно:** для `stdcall`-функций в 32-бит Windows имена экспортируются **декорированными** (`_stdcall_3@12`). Это надо учесть в `GetProcAddress` (в `LibraryLoad`). **Проверить:** как `stdlib.f` ищет функции — по точному имени. Если `stdcall_3` не найдётся, использовать `stdcall_3@12` или `extern(Windows) export` с `pragma(mangle, "stdcall_3")`.

**Решение:** в D использовать `pragma(mangle, "stdcall_N")` для отключения декорирования:
```d
pragma(mangle, "stdcall_3")
extern(Windows) int stdcall_3(int a, int b, int c) { ... }
```
Тогда `GetProcAddress("stdcall_3")` найдёт функцию.

**Альтернатива:** в `test_stdlib.f` регистрировать функции с декорированными именами.

---

## 3. Тест-скрипт на Форте

### 3.1. Структура `test_stdlib.f`

```forth
\ test_stdlib.f — проверка _-Call" из stdlib.f
\ Запуск: console_forth.exe heap.f strings.f console.f wincon.f repl.f test_stdlib.f

\ --- 1. Загрузка DLL ---
Lib" testdll.dll" td

\ --- 2. Регистрация cdecl (0..20) ---
Library@ td 0 CDECL-Call" cdecl_0" cdecl_0
Library@ td 1 CDECL-Call" cdecl_1" cdecl_1
Library@ td 2 CDECL-Call" cdecl_2" cdecl_2
... (до 20)

\ --- 3. Регистрация stdcall (0..20) ---
Library@ td 0 WINAPI-Call" stdcall_0" stdcall_0
Library@ td 1 WINAPI-Call" stdcall_1" stdcall_1
... (до 20)

\ --- 4. Регистрация pascal (0..20) ---
Library@ td 0 WINAPI-Call" pascal_0" pascal_0
... (до 20)

\ --- 5. Регистрация утилит ---
Library@ td 0 CDECL-Call" get_esp" get_esp
Library@ td 0 CDECL-Call" get_ebp" get_ebp
Library@ td 1 CDECL-Call" marker" marker
Library@ td 0 CDECL-Call" get_marker" get_marker
Library@ td 1 CDECL-Call" add_marker" add_marker
Library@ td 1 CDECL-Call" identity" identity

\ --- 6. LibraryLoad ---
LibraryLoad td

\ --- 7. Счётчик провалов ---
VAR FAILS
0 FAILS !
: OK? ( flag -- ) 0= IF 1 FAILS +! THEN ;
: CHECK ( actual expected -- ) = OK? ;
```

### 3.2. Тесты

#### 3.2.1. Базовые (cdecl, 0..4)

```forth
0 cdecl_0 0 CHECK
5 cdecl_1 5 CHECK
1 2 cdecl_2 5 CHECK          \ 1*1 + 2*2 = 5
1 2 3 cdecl_3 14 CHECK       \ 1 + 4 + 9 = 14
1 2 3 4 cdecl_4 30 CHECK     \ 1 + 4 + 9 + 16 = 30
```

#### 3.2.2. Базовые (stdcall, 0..4)

```forth
0 stdcall_0 0 CHECK
5 stdcall_1 5 CHECK
1 2 stdcall_2 5 CHECK
1 2 3 stdcall_3 14 CHECK
1 2 3 4 stdcall_4 30 CHECK
```

#### 3.2.3. Расширенные (5..20)

Для каждого `N` от 5 до 20:
```forth
1 2 3 4 5 cdecl_5 55 CHECK          \ 1+4+9+16+25 = 55
1 2 3 4 5 6 cdecl_6 91 CHECK        \ +36 = 91
... (до 20)
```

**Формула:** `sum(i*i for i in 1..N)`.

| N | Ожидаемый результат |
|---|---|
| 1 | 1 |
| 2 | 5 |
| 3 | 14 |
| 4 | 30 |
| 5 | 55 |
| 6 | 91 |
| 7 | 140 |
| 8 | 204 |
| 9 | 285 |
| 10 | 385 |
| 11 | 506 |
| 12 | 650 |
| 13 | 819 |
| 14 | 1015 |
| 15 | 1240 |
| 16 | 1496 |
| 17 | 1785 |
| 18 | 2109 |
| 19 | 2470 |
| 20 | 2870 |

#### 3.2.4. Pascal (порядок аргументов)

Если pascal реализован с **обратным порядком** в сигнатуре + вычитание:
```forth
1 2 pascal_2 -1 CHECK       \ a1=2, a2=1, 2-1 = 1? или 1-2 = -1?
1 2 3 pascal_3 0 CHECK      \ a1=3, a2=2, a3=1, 3-2-1 = 0
```

**Точная формула зависит от реализации DLL** — согласовать с генератором.

#### 3.2.5. Баланс стека данных

```forth
DEPTH 0 CHECK                \ после всех тестов стек пуст

\ проверить, что вызовы не оставляют мусор
DEPTH 0 cdecl_0 DEPTH 0 CHECK
DEPTH 1 2 cdecl_2 DEPTH 0 CHECK
```

**Внимание:** `S"` в интерпретации кладёт 2 копии адреса — не использовать `S"` в тестах глубины.

#### 3.2.6. Баланс машинного стека

```forth
RP@ >R                        \ сохранить RP
1 2 3 cdecl_3 DROP
R> RP@ = CHECK                \ RP вернулся
```

**Внимание:** `RP@` возвращает `ESP+CELL` (см. `RP_get`). Сравнение до/после вызова должно дать `-1` (равны).

**Альтернатива:** использовать `get_esp` из DLL:
```forth
get_esp >R
1 2 3 cdecl_3 DROP
R> get_esp = CHECK
```
Но `get_esp` возвращает `ESP` **внутри** функции — не в момент вызова. Для точной проверки нужен маркер.

#### 3.2.7. Порядок аргументов

```forth
1 2 3 cdecl_3 14 CHECK       \ если порядок перепутан: 3*1 + 2*2 + 1*3 = 10
```

#### 3.2.8. Лишние аргументы

```forth
DEPTH 1 2 3 99 cdecl_3 DEPTH 1 CHECK   \ лишний 99 остался на стеке
DROP                                    \ убрать 99
```

**Ожидание (по журналу):** `_-Call"` снимает **ровно N** аргументов, лишние остаются. Глубина = 1.

#### 3.2.9. Недостающие аргументы

```forth
\ НЕ ТЕСТИРОВАТЬ - underflow, мусор, возможен краш
```

#### 3.2.10. Вложенность

```forth
1 2 cdecl_2  3 4 cdecl_2  cdecl_2 30 CHECK
\ 1*1+2*2=5; 3*1+4*2=11; 5*1+11*2=27? нет
\ Пересчитать: внешний cdecl_2(a=5, b=11) = 5*1 + 11*2 = 27
```

**Ожидание (по журналу):** `_CCN` не реентерабельна — тест **провалится** (или даст мусор). Это **баг**, который нужно зафиксировать.

**Осторожно:** вложенный вызов может упасть. Запускать в отдельном тесте.

#### 3.2.11. Вызов из `:`-определения

```forth
: TEST-CALL 1 2 3 cdecl_3 ;
TEST-CALL 14 CHECK
DEPTH 0 CHECK
```

#### 3.2.12. Вызов в цикле

```forth
: TEST-LOOP 100 0 DO 1 2 cdecl_2 DROP LOOP ;
TEST-LOOP
DEPTH 0 CHECK
```

**Проверка:** нет утечки машинного стека на 100 итерациях.

#### 3.2.13. `marker` (порядок вызовов)

```forth
1 marker DROP
2 marker DROP
get_marker 2 CHECK
```

#### 3.2.14. `identity` (один аргумент)

```forth
42 identity 42 CHECK
-17 identity -17 CHECK
0 identity 0 CHECK
```

#### 3.2.15. `add_marker` (серия вызовов)

```forth
0 marker DROP
5 add_marker DROP
3 add_marker DROP
get_marker 8 CHECK
```

### 3.3. Вывод результата

```forth
CR ." FAILS = " FAILS @ . CR
FAILS @ 0= IF ." ALL OK" CR ELSE ." SOME TESTS FAILED" CR THEN
```

---

## 4. Порядок выполнения

### 4.1. Подготовка

1. Создать каталог `test/`.
2. Написать `gen_testdll.py`.
3. Запустить: `python gen_testdll.py > testdll.d`.
4. Скомпилировать: `dmd -m32 -shared -of=testdll.dll testdll.d`.
5. Проверить экспорт: `dumpbin /exports testdll.dll`.

### 4.2. Baseline

6. Написать `test_stdlib.f`.
7. Собрать консоль: `dmd -m32 forth.d console_forth.d -ofconsole_forth.exe`.
8. Запустить: `console_forth.exe heap.f strings.f console.f wincon.f repl.f test_stdlib.f`.
9. **Зафиксировать** вывод (FAILS = N, какие именно провалились).

### 4.3. Оптимизация `_-Call"`

10. Внести изменения в `stdlib.f`:
    - убрать `_CCN` (или сделать реентерабельной),
    - объединить ветки CDECL/WINAPI,
    - упростить цепочку `IF/ELSE/THEN`.
11. Перезапустить тест.
12. Сравнить с baseline — все проверки должны пройти (или улучшиться).

### 4.4. Внесение в ядро

13. Добавить `evalForth`-строки в `initForth`.
14. Убрать `includedForth("stdlib.f")` из хоста.
15. Перезапустить тест **без** `stdlib.f` в аргументах.
16. Прогнать регрессии: `test.f`, `heap.f`, `strings.f`, REPL, `SEE`, `WTEST`.

---

## 5. Критерии успеха

| Критерий | Ожидание |
|---|---|
| DLL компилируется | `dmd -m32 -shared` без ошибок |
| Все функции экспортированы | `dumpbin /exports` показывает 63+ функций |
| `LibraryLoad td` | без ошибок «Error find function» |
| cdecl 0..20 | все `CHECK` проходят |
| stdcall 0..20 | все `CHECK` проходят |
| pascal 0..20 | все `CHECK` проходят (или задокументировать расхождение) |
| Баланс стека данных | `DEPTH` = 0 после каждого теста |
| Баланс машинного стека | `RP@` до/после совпадает |
| Лишние аргументы | остаются на стеке, `DEPTH` = число лишних |
| Вложенность | **либо** работает, **либо** задокументировано как ограничение |
| Цикл 100 итераций | без утечки |

---

## 6. Известные риски и как их обойти

| Риск | Обход |
|---|---|
| `stdcall`-имена декорированы (`_stdcall_3@12`) | `pragma(mangle, "stdcall_3")` в D |
| `pascal` нет в D | naked asm + `extern(Windows)` с обратным порядком |
| `_CCN` нереентерабельна | тест вложенности в отдельном запуске; зафиксировать как баг |
| `S"` кладёт 2 копии адреса | не использовать `S"` в тестах глубины |
| `CONST`/`VAR` в бутстрапе | использовать, не определять заново |
| `INCLUDED` убран из ядра | грузить файлы аргументами |
| `RP@` возвращает `ESP+CELL` | учитывать в сравнении |
| `get_esp` возвращает `ESP` внутри функции | использовать `RP@` или маркер |
| Длинные строки `evalForth` (TIB 2048) | разбивать регистрацию на несколько строк |
| `test_stdlib.f` > 2048 байт | грузить хостом (byLine) — работает |

---

## 7. Артефакты

После выполнения должны быть:

1. `test/gen_testdll.py` — генератор.
2. `test/testdll.d` — сгенерированный D-код.
3. `test/testdll.dll` — скомпилированная DLL.
4. `test/test_stdlib.f` — тест-скрипт.
5. `test/run_test.bat` — сборка + запуск.
6. `test/README.md` — описание.
7. `test/baseline.txt` — вывод до оптимизации.
8. `test/after.txt` — вывод после оптимизации.

---

## 8. Что делать после теста

1. Если тест **прошёл** — оптимизировать `_-Call"`:
   - убрать `_CCN` (через L-стек или локальную ячейку),
   - объединить ветки CDECL/WINAPI,
   - упростить `IF/ELSE/THEN`.
2. Если тест **провалился** — зафиксировать баги:
   - вложенность (`_CCN`),
   - лишние аргументы,
   - порядок (pascal),
   - баланс стеков.
3. Внести `stdlib.f` в ядро (после успешной оптимизации).
4. Обновить журнал (`support_forth.md`) разделом «Тест `_-Call"`».

---

## 9. Пример `gen_testdll.py` (скелет)

```python
#!/usr/bin/env python3
# gen_testdll.py - генератор testdll.d

N_MAX = 20
CONVENTIONS = ["cdecl", "stdcall", "pascal"]

def gen_args(n):
    return ", ".join(f"int a{i}" for i in range(1, n+1))

def gen_sum(n):
    if n == 0:
        return "0"
    return " + ".join(f"a{i}*{i}" for i in range(1, n+1))

def gen_diff(n):
    if n == 0:
        return "0"
    return " - ".join(f"a{i}" for i in range(1, n+1))

def gen_cdecl(n):
    args = gen_args(n)
    body = gen_sum(n)
    return f"extern(C) int cdecl_{n}({args}) {{ return {body}; }}"

def gen_stdcall(n):
    args = gen_args(n)
    body = gen_sum(n)
    return f"pragma(mangle, \"stdcall_{n}\")\nextern(Windows) int stdcall_{n}({args}) {{ return {body}; }}"

def gen_pascal(n):
    # обратный порядок в сигнатуре + вычитание
    if n == 0:
        return "extern(Windows) int pascal_0() { return 0; }"
    args = ", ".join(f"int a{n-i}" for i in range(n))  # aN, aN-1, ..., a1
    body = " - ".join(f"a{i}" for i in range(n, 0, -1))
    return f"pragma(mangle, \"pascal_{n}\")\nextern(Windows) int pascal_{n}({args}) {{ return {body}; }}"

print("module testdll;")
print()
print("// АВТОГЕНЕРАЦИЯ - не редактировать вручную")
print()
for n in range(N_MAX + 1):
    print(gen_cdecl(n))
    print(gen_stdcall(n))
    print(gen_pascal(n))
    print()
print("""
// утилиты
extern(C) uint get_esp() { asm { naked; mov EAX, ESP; ret; } }
extern(C) uint get_ebp() { asm { naked; mov EAX, EBP; ret; } }
__gshared int g_marker = 0;
extern(C) int marker(int n) { g_marker = n; return n; }
extern(C) int get_marker() { return g_marker; }
extern(C) int add_marker(int n) { g_marker += n; return g_marker; }
extern(C) int identity(int n) { return n; }
""")
```

---

## 10. Пример `run_test.bat`

```bat
@echo off
echo === Генерация testdll.d ===
python gen_testdll.py > testdll.d

echo === Компиляция testdll.dll ===
dmd -m32 -shared -of=testdll.dll testdll.d
if errorlevel 1 goto :error

echo === Экспорт функций ===
dumpbin /exports testdll.dll | findstr /C:"cdecl_" /C:"stdcall_" /C:"pascal_"

echo === Сборка консоли ===
dmd -m32 ..\forth.d ..\console_forth.d -of=console_forth.exe
if errorlevel 1 goto :error

echo === Запуск теста ===
console_forth.exe ..\heap.f ..\strings.f ..\console.f ..\wincon.f ..\repl.f test_stdlib.f > baseline.txt
type baseline.txt

goto :eof
:error
echo ОШИБКА СБОРКИ
exit /b 1
```

---

## 11. Формат отчёта для KIMI-агента

По завершении агент должен предоставить:

1. **Список созданных файлов** с путями.
2. **Вывод `dumpbin /exports`** — сколько функций экспортировано.
3. **Вывод `test_stdlib.f`** (baseline) — `FAILS = N`, какие проверки провалились.
4. **Список найденных багов** `_-Call"`:
   - вложенность,
   - лишние аргументы,
   - порядок pascal,
   - баланс стеков.
5. **Предложения по оптимизации** `_-Call"`:
   - убрать `_CCN` (как),
   - объединить ветки (как),
   - упростить `IF/ELSE/THEN` (как).
6. **Diff** для `stdlib.f` (если правки внесены).
7. **Повторный прогон** теста после правок — `FAILS = 0`?

---

## 12. Ссылки на существующие материалы

- Журнал `support_forth.md` — разделы:
  - «Поведение CDECL-Call" / WINAPI-Call" — проверено тестами (файл t21-t25)»,
  - «_-Call" расширен до ЛЮБОГО числа параметров (stdlib.f, сделано)»,
  - «CALLB (callD2) ВЕРИФИЦИРОВАН в обычных контекстах (универсален)».
- `forth.d` — `callD`, `callD2`, `h_CATCH`, `f_THROW`, `executeForth`.
- `stdlib.f` — `Lib"`, `_-Call"`, `GADR-Call"`, `CDECL-Call"`, `WINAPI-Call"`.

---

**Конец плана.**
