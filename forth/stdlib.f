// _____________________________________________________________________
// =========== stdlib - стандартное окружение Форт D системы ===========
//
// MGW 30.05.15 18.35

// ====================================================================
// СПРАВКА: как вызывать функции DLL (для генерации вызовов ИИ)
// ====================================================================
// Регистрация (порядок КРИТИЧЕН):
//   Lib" kernel32.dll" k32                  (1) слово библиотеки
//   Library@ k32 2 WINAPI-Call" Beep" Beep  (2) слово вызова для КАЖДОЙ ф-ции
//   LibraryLoad k32                         (3) загрузить DLL + разрешить адреса
//   750 300 Beep .                          (4) вызов: результат на стеке
// Функции, зарегистрированные ПОСЛЕ LibraryLoad, не разрешатся -
// повторить LibraryLoad.
//
// ПОРЯДОК АРГУМЕНТОВ - естественный, как в C:
//   750 300 Beep   ==   Beep(750, 300)
// Первый аргумент кладётся на стек ПЕРВЫМ (глубже), вершина стека -
// ПОСЛЕДНИЙ аргумент. Внутри аргументы переносятся на машинный стек
// так, что C-функция видит стандартный порядок (первый аргумент по
// [ESP+4]). Это верно для ВСЕХ соглашений (cdecl/stdcall/pascal).
//
// СОГЛАШЕНИЯ (тип задаётся словом регистрации):
//   CDECL-Call"   тип 1 - cdecl: стек чистит ВЫЗЫВАЮЩИЙ (RDROP внутри слова)
//   WINAPI-Call"  тип 2 - stdcall: стек чистит САМА функция (ret N в DLL)
//   GADR-Call"    тип 0 - НЕ вызывает: кладёт на стек АДРЕС функции
// ИМЕНА stdcall/pascal-экспортов в DLL ДЕКОРИРОВАНЫ (Win32): "_Beep@8".
// GetProcAddress ищет имя ТОЧНО (регистр важен): для stdcall/pascal
// регистрируйте декорированное имя "_Name@N" (N = байты аргументов);
// cdecl-имена без декорации ("abs"). Системные DLL Windows экспортируют
// stdcall-функции ОБЫЧНО без декорации ("Beep", "LoadCursorA") - смотрите
// реальные имена (dumpbin /exports, objdump -p, или разбор PE-таблицы
// экспорта). Не найдено -> печать "Error find function: <имя>".
//
// ЧИСЛО ПАРАМЕТРОВ: фиксированные ветки 0..4; 5 и больше - универсальная
// ветка (цикл >R/RDROP), снимается РОВНО N зарегистрированных аргументов;
// лишние значения остаются на стеке данных (глубина растёт).
//
// КОНТРАКТ CALL_A (используется словами вызова и для ручных вызовов):
// результат возвращается ДВАЖДЫ - в EAX (TOS) и в ячейке стека под ним.
// Ветки _-Call" заканчиваются DROP, снимающим дубль. При ручном вызове
// через GADR-адрес DROP делает сам вызывающий:
//   stdcall:  arg1 .. argN >R >R .. (N раз)  fn CALL_A DROP   (без RDROP!)
//   cdecl:    arg1 .. argN >R >R .. (N раз)  fn CALL_A RDROPxN DROP
//   >R идёт подряд от вершины данных: ( a1..aN ) -> ">R >R ..." N раз.
//   НЕ писать "a1 >R a2 >R" - это переставит аргументы местами!
// В цикле помнить: CALL_A DROP оставляет РЕЗУЛЬТАТ на стеке - для
// вызова ради эффекта в цикле нужен второй DROP (или DROP DROP сразу).
// Вариант CALLB (callD2) - то же, но безопасен внутри Windows-колбэков.
//
// РАЗРЯДНОСТЬ: интерпретатор 32-битный, DLL должны быть 32-битными.
//
// ПРИМЕРЫ (проверены тестом test/test_stdlib.f):
//   Lib" msvcrt.dll" crt                      (cdecl, 1 пар.)
//   Library@ crt 1 CDECL-Call" abs" myabs
//   LibraryLoad crt
//   -42 myabs .                               -> 42
//   Lib" user32.dll" u32                      (winapi/stdcall, 2 пар.)
//   Library@ u32 2 WINAPI-Call" Beep" Beep
//   LibraryLoad u32
//   750 300 Beep .                            -> 1 (Beep(750Hz, 300ms))
// ====================================================================

1   CONST LibraryLoad    // Загрузить DLL и загрузить функции в связанном списке
2   CONST Library@       // Выдать адрес структуры Library
257 CONST DLOPEN-FLAG    // В Linux нужен аргумент для dlopen()

// ( Слово_из_потока -- Astrz ) вставить строку и обойти. NUL пишем ЯВНО: байт после имени - не обнулённый мусор кодофайла
// (иначе имя "расползается" в asciiz и GetProcAddress не находит функцию)
: ASCIIZ" [CHAR] " WORD DUP B@ 1+ 1+ ALLOT HERE 1- 0 SWAP B! ; 

// Создаёт слово для создания активных слов загрузки динамич библиотек
// Использование:  Library" fqt.dll" fqt   // создать слово fqt
//                 LibraryLoad fqt         // загрузить библиотеку и иниц список функций
// Внутренняя структура library:
//  +----------- CELL ----------+----------- CELL ------------------+---- длина + 0 в конце --+
//  | адрес загрузки библиотеки | Указатель на слова функций        | имя библиотеки (ascciz) |
//  +---------------------------+-----------------------------------+-------------------------+
: Lib"                                                // "
    HERE >R 0 HERE ! CELL ALLOT 0 HERE ! CELL ALLOT   // выделить две ячейки и занулить их
    ASCIIZ" DROP                                      // "сохранение имени DLL
    R> CREATE COMPILE (CREATE) ,
  DOES> @
    SWAP DUP                                          // Анализируем параметр
    1 = IF DROP                                       // Идем по списку, грузим адреса функций
            DUP 2 CELL * + 1+                         // Alibrary Astrz без байта длины
IF=W        >R LOADLIBRARYA CALL_A RDROP DROP
IF=L        DLOPEN-FLAG >R >R DLOPEN CALL_A RDROP RDROP DROP
            DUP 0 = 
            IF S" Error load DLL " 1+ TYPE DROP 2 CELL * + 1+ TYPE EXIT THEN
            // В этом месте уже есть адрес загруженной DLL
            DUP >R OVER !                // Сохраним адр загруженной DLL в структуре и в SP                                    
            CELL + @                     // Берем структуру Call по указателю
            // Если функции для этой библ не определены УказНаСлова=0 то выйти
            DUP 0 = IF DROP RDROP EXIT THEN
            // В этот момент на стеке Astruk
            BEGIN  
                // ---- Грузим функции из списка ---------
                DUP 4 CELLS + 1+ DUP >L R@ //  Acall Aстроки Adll
                SWAP >R >R 
IF=W            GPADRESS CALL_A DROP
IF=L            DLSYM CALL_A RDROP RDROP DROP
                DUP 0 = IF DROP S" Error find function: " 1+ TYPE L> TYPE RDROP DROP RDROP 0 . EXIT
                        ELSE L> DROP    // Найден адрес
                        THEN
                OVER !                  //  Сохраним адрес функции в структуре Call
                // ---------------------------------------
                2 CELLS + @ DUP 0 =     // След структура в списке или последняя
            UNTIL DROP
            RDROP
        ELSE
            2 = IF ELSE S" Error parametr for Library: AdrTable on stack. " 1+ TYPE  THEN
        THEN
    ;
// Создаёт слово для работы с адресом функции DLL и выполнением вызова
// Перед использованием необходима инициализация:  LibraryLoad fqt   // загрузить библиотеку и иниц
// Использование: Library@ fqt #Кол_вход_параметров CDECL-Call" QT_App" QT_App  // Добавить в список вызова
// Вызов функции:          аргументы  QT_App  // Перед 
// Внутренняя структура call:
//  +--- CELL ------+------ CELL ------+----- CELL --------+-----CELL ----+-- длина + 0 в конце --+
//  | адрес функции | Кол входн парам  | адрес след или 0  | тип вызова   | имя функции (ascciz)  |
//  +---------------+------------------+-------------------+--------------+-----------------------+
//
: _-Call"   // "( Aструкт_library #Кол_параметров #типвызова -- )
    HERE >R 0 HERE ! CELL ALLOT SWAP HERE ! CELL ALLOT
    R@ 3 CELLS + ! R@ SWAP CELL + DUP
    >R @ HERE ! R> ! 2 CELLS ALLOT ASCIIZ" DROP    // " сохранение имени вызываемой функции
    R> CREATE COMPILE (CREATE) , 
  DOES> @
    DUP >R 3 CELLS + @ 
    DUP 0 = IF DROP R> DUP CELL + @ SWAP @
                SWAP DROP  // Заберем глобальный адрес
            ELSE
    DUP 1 = IF DROP R> DUP CELL + @ SWAP @
                >L                // адрес -> L     L: AdrExecFun
                >L                // count -> L     L: AdrExecFun  Count
                L@ 0 ?DO >R LOOP
                L> L> SWAP >L     // count -> R     L:  AdrExecFun
                CALL_A DROP
                L> 0 ?DO RDROP LOOP
            ELSE    
    DUP 9 = IF         // Число параметров кладется непосредственно во время вызова
            ELSE
    DUP 2 = IF DROP R> DUP CELL + @ SWAP @
                >L                // Сохраним адрес вызова
                0 ?DO >R LOOP
                L> CALL_A DROP              
            ELSE
                RDROP DROP DROP DROP DROP
            THEN
            THEN
            THEN
            THEN
    ;      
: GADR-Call"    0 _-Call" ;
: CDECL-Call"   1 _-Call" ;
: CDECL-Call-N" 9 _-Call" ;
// WINAPI-CALL - Всё со стека снимает сама. Самый первый Форта - последний С++
: WINAPI-Call"  2 _-Call" ;

// ==================== Callback'и: внешний мир -> Форт ====================
// MK-WINAPI-CB ( xt n -- addr ) - создать stdcall-callback (callee чистит
//   машинный стек: ret 4*n в thunk'е). Ограничение: n <= 63.
// MK-CDECL-CB  ( xt n -- addr ) - создать cdecl-callback (caller чистит).
// Слово по xt - обычное форт-слово ( a1..aN -- res ), всегда ровно один
// результат (для void-callback'ов вызывающий игнорирует EAX).
// Возвращаемый addr отдавать наружу (lpfnWndProc, тестовая DLL и т.п.).
// thunk генерируется в кодофайле; время жизни - как у словаря (FORGET).
// Мост cbBridge - примитив ядра (forth.d), адрес даёт слово CBRIDGE.
// Внутри callback'а THROW не перехватывается - программа падает;
// callback-слово отлаживать в REPL ДО создания thunk'а.
// Отладка thunk'а без Windows: обратный вызов ручным паттерном CALL_A
// (см. шапку файла): a1..aN >R xN addr CALL_A DROP (stdcall).
: (MKCB)  ( xt n -- addr n )
    HERE -ROT
    $BA B, SWAP ,                  // mov EDX, xt
    $B9 B, DUP ,                   // mov ECX, n
    $E8 B, CBRIDGE HERE 4 + - , ;  // call cbBridge (rel32)
: MK-WINAPI-CB ( xt n -- addr )
    (MKCB) $C2 B, 4 * DUP B, DROP 0 B, ;   // ret 4*n
: MK-CDECL-CB ( xt n -- addr )
    (MKCB) DROP $C3 B, ;                   // ret
