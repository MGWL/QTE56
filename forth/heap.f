// _____________________________________________________________________
// heap.f - память (CRT-куча msvcrt) + учёт выделений связанным списком
//
// Загрузка:  console_forth.exe heap.f ...   (нужен только stdlib.f,
//            который грузится автоматически; консоль НЕ требуется)
//
// msvcrt открывается под своим именем crtm со своим LibraryLoad -
// console.f открывает ту же DLL под именем crt, конфликта нет
// (LoadLibrary считает ссылки).
//
// ВКЛЮЧЕНО: MALLOC CALLOC REALLOC FREE MSIZE MEMSET MEMMOVE
//           HALLOC HSIZE HFREE HFREEALL HCOUNT HBYTES
//
// Учёт выделений: каждый блок HALLOC встаёт в связанный список HPLIST.
// Заголовок встроен в сам блок (одна аллокация вместо двух):
//    блок+0: next (4 байта, следующий БЛОК, 0 = конец списка)
//    блок+4: size (4 байта, размер данных в байтах)
//    блок+8: данные -> этот адрес получает пользователь
// HFREEALL освобождает ВСЕ блоки и обнуляет список ("забыть всё и
// начать сначала"). ВНИМАНИЕ: после HFREEALL все ранее выданные
// адреса - висячие указатели, использовать их нельзя!

// ====== Подключение msvcrt.dll (только память) ======
Lib" msvcrt.dll" crtm
Library@ crtm 1 CDECL-Call" malloc" MALLOC
Library@ crtm 2 CDECL-Call" calloc" CALLOC
Library@ crtm 2 CDECL-Call" realloc" REALLOC
Library@ crtm 1 CDECL-Call" free" _FREE
Library@ crtm 1 CDECL-Call" _msize" MSIZE
Library@ crtm 3 CDECL-Call" memset" MEMSET
Library@ crtm 3 CDECL-Call" memmove" MEMMOVE
LibraryLoad crtm

// MALLOC  ( size -- addr )         выделить size байт, 0 при нехватке
// CALLOC  ( n size -- addr )       выделить n*size байт и обнулить
// REALLOC ( addr size -- addr2 )   перевыделить блок (addr2 может отличаться!)
// MSIZE   ( addr -- n )            фактический размер блока
// MEMSET  ( addr char n -- addr )  заполнить n байт значением char
// MEMMOVE ( Ato Afrom n -- addr )  копировать n байт (области могут пересекаться)
: FREE _FREE DROP ;                           // ( addr -- ) free() ничего не возвращает

// ====== Связанный список выделений ======
VAR HPLIST                                    // голова списка (0 = пусто)

// HALLOC ( size -- addr )  выделить и встать в список.
// Ошибка -> печать и 0 (THROW не подходит: он не прерывает выполнение)
: HALLOC DUP 8 + MALLOC DUP NOT IF DROP DROP S" HALLOC: no memory" 1+ TYPE 0 EXIT THEN HPLIST @ OVER ! DUP HPLIST ! DUP 4 + ROT SWAP ! 8 + ;

// HSIZE ( addr -- size )  размер данных блока из заголовка
: HSIZE 4 - @ ;

// HFREE ( addr -- )  выцепить блок из списка и освободить (addr - от HALLOC)
: HFREE 8 - >R HPLIST @ R@ = IF R@ @ HPLIST ! R> FREE EXIT THEN HPLIST @ BEGIN DUP @ R@ <> WHILE @ REPEAT R@ @ OVER ! DROP R> FREE ;

// HFREEALL ( -- )  ЗАБЫТЬ ВСЁ: освободить все блоки, список обнулить
: HFREEALL HPLIST @ BEGIN DUP WHILE DUP @ SWAP FREE REPEAT DROP 0 HPLIST ! ;

// HCOUNT ( -- n )  число живых блоков (диагностика)
: HCOUNT 0 HPLIST @ BEGIN DUP WHILE @ SWAP 1+ SWAP REPEAT DROP ;

// HBYTES ( -- n )  суммарный размер данных всех блоков
: HBYTES 0 HPLIST @ BEGIN DUP WHILE DUP 4 + @ ROT + SWAP @ REPEAT DROP ;
