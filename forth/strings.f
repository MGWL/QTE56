// _____________________________________________________________________
// strings.f - heap-строки на базе heap.f (HALLOC/HFREE/HFREEALL)
//
// Загрузка:  console_forth.exe heap.f strings.f ...
//            (нужен только heap.f и ядро; консоль НЕ требуется -
//            печать $. идёт через системный TYPE на printf)
//
// ФОРМАТ СТРОКИ: [len:1 байт][символы][0]. Всего len+2 байта.
// Осознанно: длина не более 255, чтобы байт длины был значим.
// Тот же формат выдаёт WORD - поэтому >STR копирует слово из потока
// в кучу как есть. Как и системный S", STR" включает пробел после
// открывающей кавычки в строку (особенность WORD).
//
// ВКЛЮЧЕНО: SLEN $. >STR STR" S= S+
// Освобождение строк - словами heap.f: HFREE ( addr -- ) / HFREEALL.
// Именованные строки:  STR" Hello" CONST HI   HI $.   HI W S+ $.

// SLEN ( s -- n )  длина строки
: SLEN B@ ;

// $. ( s -- )  печать (asciiz, системный TYPE)
: $. 1+ TYPE ;

// >STR ( a -- s )  копия counted-строки (например от WORD на HERE) в кучу
: >STR DUP B@ 2 + DUP HALLOC DUP NOT IF DROP DROP DROP 0 EXIT THEN ROT ROT MEMMOVE ;

// STR" ( -- s )  строка из входного потока в кучу (интерпретация/REPL;
// внутри определений НЕ использовать - WORD разбирает поток в момент
// компиляции, а исполняется позже)
: STR" [CHAR] " WORD >STR ;

// Рабочие ячейки (система однозадачная - переменные читаемее стековой акробатики)
VAR sA  VAR sB  VAR sC  VAR sN

// S= ( s1 s2 -- f )  сравнение: -1 = равны, 0 = нет; пустые равны пустым.
// Через sA/sB: на чистом стеке OVER не дотягивается до s1 после DUP B@
// (s1 оказывается третьим) - строка сравнивалась сама с собой.
// Ранний выход из DO: на L-стеке 2 ячейки (индекс+предел) - два LDROP.
: S= sB ! sA ! sA @ B@ sB @ B@ <> IF FALSE EXIT THEN sA @ B@ NOT IF TRUE EXIT THEN sA @ B@ 1+ 1 DO sA @ I + B@ sB @ I + B@ <> IF FALSE LDROP LDROP EXIT THEN LOOP TRUE ;

// S+ ( s1 s2 -- s3 )  конкатенация: новая строка в куче, длина <= 255
: S+ sB ! sA ! sA @ B@ sB @ B@ + DUP 255 > IF DROP 255 THEN DUP sN ! 2 + HALLOC sC ! sN @ sC @ B! sC @ 1+ sA @ 1+ sA @ B@ MEMMOVE DROP sC @ 1+ sA @ B@ + sB @ 1+ sN @ sA @ B@ - MEMMOVE DROP sC @ sN @ + 1+ 0 SWAP B! sC @ ;
