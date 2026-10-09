// _____________________________________________________________________
// console.f - консольные слова по мотивам Forth-83 для forthD
//
// Загрузка:  console_forth.exe heap.f strings.f console.f wincon.f repl.f
//        или из REPL:  S" console.f" INCLUDED
//           (stdlib.f грузится автоматически; память и heap-строки -
//           heap.f и strings.f, грузятся ДО console.f)
//
// ВНИМАНИЕ: INCLUDED выполняет файл ПОСТРОЧНО. Определения могут занимать
//           несколько строк (STATE живёт в gpcb между строками), но
//           строковый литерал S" / ." обязан закрыться на своей строке.
//
// ВКЛЮЧЕНО: KEY EXPECT (редактор строки: ECHS EBACK ESHIFT EDELETE
//           EBACKSP EINSERT)
//           В ЯДРЕ (forth.d, блок "Шитые слова из console.f"): SPACE SPACES
//           COUNT TYPEC ." CONSTANT VARIABLE MOD /MOD 0< 0> NEGATE ABS
//           CASE OF ENDOF ENDCASE PAD #UK HOLD <# # #S #> SIGN U. . .R ?
//           DNEGATE DABS D. UD. STRLENZ .U
//           (EMIT CR DEPTH 0= 0<> ?DUP 2DUP 2DROP MIN MAX ( - теперь в ядре;
//           слова памяти MALLOC..MEMMOVE/HALLOC/HFREE/HFREEALL - в heap.f,
//           heap-строки SLEN $. >STR STR" S= S+ - в strings.f)
//
// ОТЛИЧИЯ от 83: TYPE остался системным ( Asciiz -- ), вариант 83
//   ( addr len -- ) называется TYPEC. Точка . печатает число и пробел,
//   без перевода строки (старая системная . задавлена новой). S"/."
//   включают пробел после открывающей кавычки в строку - как и системный S".
//   EXPECT принимает реальный размер буфера вторым параметром (ELIM) -
//   защита от переполнения привязана к КОНКРЕТНОМУ вызову, не к LINEBUF.
//   KEY без эха и без Enter: в консоли читает через _getch, при
//   перенаправленном stdin (пайп) через getchar; конец файла (EOF)
//   завершает процесс. EXPECT завершается и по CR(13), и по LF(10) -
//   для работы через пайп.
//   BASE влияет ТОЛЬКО на вывод: разбор чисел при вводе (number() в forth.d)
//   использует СВОЁ BASE (gpcb.base, слова BASE/HEX/DECIMAL в ядре) -
//   см. forth.d, число читается по текущей системе счисления.
//
// НЕ ВОШЛО (нужны доработки ядра forth.d): LEAVE ABORT QUIT.

// ====== Подключение msvcrt.dll ======
Lib" msvcrt.dll" crt
Library@ crt 1 CDECL-Call" putchar" _EMIT
Library@ crt 0 CDECL-Call" _getch" _KEY
Library@ crt 0 CDECL-Call" getchar" _GETCHAR
Library@ crt 1 CDECL-Call" _isatty" _ISATTY
Library@ crt 1 CDECL-Call" exit" _EXIT
Library@ crt 1 CDECL-Call" fflush" _FFLUSH
LibraryLoad crt
// Слова памяти (malloc/free/...) вынесены в heap.f (грузится ДО console.f)

// ====== Символьный ввод-вывод ======
// EMIT, CR, SPACE, SPACES, COUNT, TYPEC, ." - теперь в ядре (forth.d,
// блок "Шитые слова из console.f"). KEY - здесь, т.к. нужен msvcrt.
// KEY: консоль=_getch (байты cp1251), пайп=getchar, EOF=выход.
// ИЗВЕСТНАЯ ПРОБЛЕМА: 'а'=0xE0 совпадает с префиксом расширенных клавиш
// в EXPECT - русская 'а' не вводится. Попытка через _getwch+W2B откачена:
// работало не лучше (см. support_forth.md, раздел редактора строки).
: KEY 0 _ISATTY IF _KEY ELSE _GETCHAR DUP 0 < IF DROP 0 _EXIT DROP THEN THEN ;

// ====== Число -> heap-строка (нужен heap.f ДО console.f) ======
VAR zsN zsN ! 0   // scratch для N>S
: N>S ( n -- s ) DUP ABS 0 <# #S ROT SIGN #> DUP zsN ! 2 + HALLOC DUP zsN @ SWAP B! DUP >R 1+ SWAP zsN @ MEMMOVE DROP R> DUP zsN @ + 1+ 0 SWAP B! ;

// STRLENZ ( addr -- n ) — считает количество ненулевых байтов до первого нуля
// STRLENZ теперь в ядре (forth.d)

// ====== Ввод строки с редактором ======
// Раскладка: EBUF = адрес буфера, ELEN = длина, ECUR = позиция курсора,
// ELIM = реальный размер буфера (передан вызывающим в EXPECT).
// Буфер - asciiz (NUL пишется по Enter), договор как у старого EXPECT.
// Стрелки <- -> (скан 75/77), Home/End (71/79), Del (83) - двухбайтовые
// последовательности (префикс 0 или 0xE0 + скан-код). Backspace - 8.
// Перерисовка хвоста после вставки/удаления: ECHS + EBACK.
VAR EBUF  VAR ELEN  VAR ECUR  VAR ELIM   // ELIM = реальный размер буфера, переданный в EXPECT

: ECHS ( addr n -- )  // напечатать n байт
    0 ?DO DUP I + B@ EMIT LOOP DROP ;

: EBACK ( n -- )     // курсор влево на n позиций
    0 ?DO 8 EMIT LOOP ;

: ESHIFT ( -- )      // сдвинуть хвост после курсора влево на 1 (для Del/BkSp)
    ELEN @ ECUR @ - 1- DUP IF
        0 ?DO EBUF @ ECUR @ + I 1+ + B@ EBUF @ ECUR @ + I + B! LOOP
    ELSE DROP THEN ;
    
: EDELETE ( -- )     // удалить символ ПОД курсором, хвост перерисовать
    ECUR @ ELEN @ < IF
        ESHIFT ELEN 1-!
        EBUF @ ECUR @ + ELEN @ ECUR @ - DUP IF
            DUP >R ECHS BL EMIT R> 1+ EBACK
        ELSE 2DROP 8 EMIT BL EMIT 8 EMIT THEN
    THEN ;

: EBACKSP ( -- )  // Backspace: курсор влево, удалить символ под курсором
    ECUR @ IF ECUR 1-! EDELETE THEN ;

: EINSERT ( c -- )  // вставить символ В позицию курсора
    ELEN @ ELIM @ 2 - > IF DROP EXIT THEN  \ защита буфера (граница - реальный размер EXPECT'u len, -2 под NUL+запас)
    ELEN @ ECUR @ - DUP IF  \ есть хвост - сдвинуть вправо
        0 DO EBUF @ ELEN @ + I - DUP 1- B@ SWAP B! LOOP
    ELSE DROP THEN
    DUP EBUF @ ECUR @ + B! EMIT  \ запись + эхо
    ELEN @ ECUR @ - DUP IF  \ хвост справа напечатать и вернуть курсор
        EBUF @ ECUR @ + 1+ OVER ECHS EBACK
    ELSE DROP THEN
    ECUR 1+! ELEN 1+! ;

: EXPECT // ( addr len -- ) ввод до Enter: стрелки, вставка, Del Home End
    ELIM !  EBUF ! 0 ELEN ! 0 ECUR !
    BEGIN
        KEY DUP 13 = OVER 10 = OR NOT
    WHILE
        DUP 0= OVER 224 = OR IF  // префикс расширенных клавиш
            DROP KEY  // скан-код
            DUP 75 = IF DROP       // влево
                ECUR @ IF ECUR 1-! 8 EMIT THEN
            ELSE DUP 77 = IF DROP  // вправо
                ECUR @ ELEN @ < IF
                    EBUF @ ECUR @ + B@ EMIT ECUR 1+!
                THEN
            ELSE DUP 71 = IF DROP  // Home
                ECUR @ DUP IF EBACK ELSE DROP THEN DROP 0 ECUR !
            ELSE DUP 79 = IF DROP  // End
                EBUF @ ECUR @ + ELEN @ ECUR @ - ECHS ELEN @ ECUR !
            ELSE DUP 83 = IF DROP EDELETE  // Del
            ELSE DROP
            THEN THEN THEN THEN THEN
        ELSE DUP 8 = IF DROP EBACKSP
        ELSE EINSERT
        THEN THEN
    REPEAT DROP 0 EBUF @ ELEN @ + B! ;
