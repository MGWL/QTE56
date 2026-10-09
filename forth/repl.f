// _____________________________________________________________________
// repl.f - основной цикл (REPL) на самом Форте: цвет, статус, многострочность
//
// Требует console.f и wincon.f. Загрузка:
//    console_forth.exe console.f wincon.f repl.f
// console_forth.d регистрирует в общей таблице (setCommonAdr) ДО загрузки
// этого файла:
//    ячейка 10 = evalC(char*) - выполнить строку Форта, напечатать
//               состояние стека (как showSD) и вернуть время в мкс.
//    ячейка 11 = seeC(xt) - декомпилятор: разобрать тело слова по xt
//               (формат статьи и спецслова см. в console_forth.d).
// Печать стека делается внутри D-функции evalC намеренно: сразу после
// выполнения строки память стека актуальна. Если читать её словами Форта
// позже, рабочий стек самого REPL уже затрёт эти ячейки.
// После загрузки всех файлов console_forth.d выполняет слово REPL.
// REPL не возвращается: выход - слово BYE (в пайпе - EOF).
// Многострочность: STATE хранится в gpcb между вызовами evalC, поэтому
// незакрытое ":" продолжается на следующей строке ввода; промпт меняется:
// F> - интерпретация (жёлтый),  ..> - компиляция (голубой).
// ВНИМАНИЕ: каждое определение занимает ровно одну строку (INCLUDED
//           выполняет файл построчно).

// Запуск на выполнение
// dmd -m32 -O forth.d console_forth.d -ofconsole_forth.exe
// console_forth.exe heap.f strings.f console.f wincon.f repl.f

10 COMMONADR@ CONST EVALD
11 COMMONADR@ CONST SEED

// Вызов extern(C) функции D через общую таблицу (cdecl, как в stdlib.f)
: EVALF >R EVALD CALL_A RDROP DROP ;          // ( astr -- mks ) выполнить строку
: BYE 0 _EXIT DROP ;                          // ( -- ) выход из процесса

// Декомпилятор: SEE имя  - печатает тело слова (call'ы, литералы, ветвления).
// BL WORD FIND вместо ' - чтобы на несуществующем слове НЕ было THROW,
// а было чистое "not found". ДВЕ защиты DUP IF: WORD возвращает 0, если
// после SEE нет слова (конец строки), а FIND возвращает 0, если слова нет
// в словаре - иначе seeC(0) дал бы AV.
// CALL_A передаёт xt в seeC через стек возвратов (как EVALF).
// Два DROP: CALL_A оставляет ячейку-фантом + void-результат seeC.
: SEE BL WORD DUP IF FIND DUP IF >R SEED CALL_A RDROP DROP DROP ELSE DROP ." not found" THEN ELSE DROP ." not found" THEN ;

HERE 300 ALLOT CONST LINEBUF                  // буфер ввода строки

// Список всех слов словаря (обход 256 цепочек context; CONTEXT - адрес
// поля gpcb.context, поэтому сначала @, затем индекс цепочки)
: WORDS 256 0 DO CONTEXT @ I CELLS + @ BEGIN DUP WHILE DUP 1+ TYPE SPACE DUP C@ 4 + + @ REPEAT DROP LOOP CR ;

// Основной цикл: промпт -> ввод -> выполнение (evalC печатает стек) -> мкс.
// ВАЖНО: первым делом указатели стеков данных (EBP) и локального (ESI)
// сдвигаются на 2КБ вниз. Нить REPL и нить строк пользователя стартуют с
// ОДНИХ адресов (обе из gpcb.saveEBP/saveESI); без разделения рабочие ячейки
// REPL затирают память стека пользователя, а слова типа DO LOOP затирают
// адрес возврата, сохранённый CALL_A на L-стеке (ret уходил на 0x5 -
// по пределу цикла). Резерв 2КБ = 512 ячеек на каждую нить.
: REPL SP@ 2048 - SP! LP@ 2048 - LP! BEGIN STATE @ IF 11 COLOR ." ..> " ELSE 14 COLOR ." F=> " THEN 7 COLOR LINEBUF 300 EXPECT CR 10 COLOR LINEBUF EVALF 7 COLOR ."  " . ." mks" CR 0 UNTIL ;


// Тест проверки с обычным консольном входом и выходом
: WITHIN // ( n low high -- flag ) 0= если ложно
    OVER - >R - R> < ;

HERE 80 ALLOT CONST IBUF          // буфер ввода (один раз)

: ASK  CR ." Сколько вам лет? "
    IBUF 80 EXPECT              // читать строку в IBUF (с эхом, Backspace работает)
    IBUF 1- NUMBER              // разобрать в число -> ( n flag )
    IF CR ." Ваш возраст: " . CR   // flag=-1: число на стеке, печатаем
    ELSE DROP THEN ;            // flag=0: снять мусор, ругательство уже напечатано

HERE 80 ALLOT CONST NBUF    // буфер для имени
HERE 80 ALLOT CONST SBUF    // буфер для фамилии
HERE 80 ALLOT CONST ABUF    // буфер для возраста

: INFO
    CR ." Введите имя: "     NBUF 80 EXPECT
    CR ." Введите фамилию: " SBUF 80 EXPECT
    CR ." Сколько вам лет? " ABUF 80 EXPECT
    ABUF 1- NUMBER DROP      // ( n flag ) -> ( n ) флаг сбросили
    CR
    SBUF TYPE ."  "
    NBUF TYPE ."  имеет возраст "
    . CR ;

// =============================================================================

: .S ( -- )                         // распечатать стек не меняя его
    DEPTH >L                        // глубину - на L-стек (глубина ниже, L сверху)
    ." Stack S [" L@ . ." ]->"              // печать "[N]->"
    L@ 0 DO >R LOOP                 // все значения -> стек возвратов (TOS первым)
    L@ 0 DO R> DUP . LOOP           // обратно: R> DUP . (печать копии, оригинал остаётся)
    L> DROP ;

// print_lib.f — печать структуры Library по её адресу со стека
// Запуск: console_forth.exe heap.f strings.f console.f wincon.f repl.f print_lib.f
// Использование: <адрес структуры> PRINT-LIB

// ====== Ширины колонок ======
14 CONST W1   \ "адрес загрузки"  = 18 байт (hex) + запас
14 CONST W2   \ "указатель списка" = 18 байт (hex) + запас
28 CONST W3   \ "имя библиотеки"  = до 30 байт

7  CONST W4   \ тип (число)
25 CONST W5   \ имя функции

// ====== Печать строки (asciiz) в поле ширины w ======
// ( addr w -- )
VAR _SW
: .STR-W ( addr w -- )
    _SW !
    [CHAR] | EMIT SPACE
    1+ DUP STRLENZ          // addr len (STRLENZ из console.f)
    DUP _SW @ > IF
        TYPEC
    ELSE
        _SW @ OVER - SPACES TYPEC
    THEN
    SPACE [CHAR] | EMIT ;

// ====== Печать десятичного числа в поле ширины w ======
VAR _DW
: .DEC-W ( n w -- )
    _DW ! [CHAR] | EMIT SPACE
    0 <# #S #> DUP _DW @ > IF TYPEC
    ELSE _DW @ OVER - SPACES TYPEC THEN
    BL EMIT ;

// ====== Имя типа как строка ======
: .TYPE-NAME // ( type -- )
    [CHAR] | EMIT
    DUP  0 = IF ."     GADR " THEN
    DUP  1 = IF ."    CDECL " THEN
    DUP  2 = IF ."   WINAPI " THEN
    DUP  9 = IF ."    DEBUG " THEN
    DUP -1 = IF ."      ??? " THEN DROP ;

// Рисует строку шапки распечатки таблицы
: згСтруктурLibrary // ( № строки -- )
    DUP 1 = IF
        ." +----------------+----------------+------------------------------+" CR
    THEN
    DUP 2 = IF
        ." | адрес загрузки | начало  списка | имя библиотеки (asciiz)      |" CR
    THEN
    DUP 3 = IF
        ." +----------------+---------+---------+---------------------------+" CR
    THEN
    DUP 4 = IF
        ." | адрес функции  | N парам | Т.вызов | имя функции (asciiz)      |" CR
    THEN
    DROP ;

// Распечатать структуру таблицы DLL Library
: printTableDll // ( Aтаблицы -- )
    DUP >R
    CR ." Структура Library:" CR
    1 згСтруктурLibrary 2 згСтруктурLibrary 1 згСтруктурLibrary
    // поле +0 — адрес загрузки (hex)
    R@ @ W1 .DEC-W
    // поле +4 — указатель на список
    R@ CELL + @ W2 .DEC-W
    // поле +8 — имя (asciiz)
    R@ 2 CELLS + W3 .STR-W CR
    1 згСтруктурLibrary
    RDROP  DROP ;           // снять addr

// Распечатать структуру таблицы DLL Cells
: printCallDll // ( Aтаблицы -- )
    CELL + @                           // +4 = указатель на список Call
    DUP >R
    ." Структура Cells:" CR
    3 згСтруктурLibrary 4 згСтруктурLibrary 3 згСтруктурLibrary
    BEGIN DUP WHILE
        // Распечатка одной ячейки
        R@ @ W1 .DEC-W
        R@ CELL + @ W4 .DEC-W           //  +4 N параметров
        R@ 3 CELLS + @  .TYPE-NAME      // +12 тип (число)
        R@ 4 CELLS + W5 .STR-W CR       // +16 имя (asciiz)
        2 CELLS + @ RDROP DUP >R      // +8 = следующий Call
    REPEAT 
    R> DROP DROP 3 згСтруктурLibrary ;

// Распечатать таблицы функций
// Library@ td DUP printTableDll printCallDll

__EOF__
