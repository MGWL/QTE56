// cb_test.f - тест callback-моста cbBridge (MK-WINAPI-CB / MK-CDECL-CB, stdlib.f)
// Запуск из КОРНЯ проекта (test/run_cb.bat делает это сам):
//   echo BYE | console_forth.exe heap.f strings.f console.f wincon.f test\cb_test.f
// DLL test/cbtest.dll сама вызывает thunk контролируемыми аргументами:
// проверяются порядок аргументов, оба соглашения, баланс ESP (cbw2_chk),
// серия вызовов (cbw2_loop) и вложенный Call" изнутри callback'а (CBNEST).

Lib" test\cbtest.dll" cbt
Library@ cbt 1 WINAPI-Call" cbw0" cbw0
Library@ cbt 2 WINAPI-Call" cbw1" cbw1
Library@ cbt 3 WINAPI-Call" cbw2" cbw2
Library@ cbt 4 WINAPI-Call" cbw3" cbw3
Library@ cbt 5 WINAPI-Call" cbw4" cbw4
Library@ cbt 9 WINAPI-Call" cbw8" cbw8
Library@ cbt 1 WINAPI-Call" cbc0" cbc0
Library@ cbt 2 WINAPI-Call" cbc1" cbc1
Library@ cbt 3 WINAPI-Call" cbc2" cbc2
Library@ cbt 5 WINAPI-Call" cbc4" cbc4
Library@ cbt 3 WINAPI-Call" cbw2_chk" cbw2_chk
Library@ cbt 0 WINAPI-Call" cb_esp_diff" cb_esp_diff
Library@ cbt 4 WINAPI-Call" cbw2_loop" cbw2_loop
LibraryLoad cbt

// Форт-слова с известным результатом (взвешенная сумма ловит порядок аргументов)
: TCB0 7 ;                                    // ( -- 7 )
: TCB1 ;                                      // ( a -- a )
: TCB2 2 * + ;                                // ( a b -- a+2b )
: TCB3 3 * SWAP 2 * + + ;                     // ( a b c -- a+2b+3c )
: TCB4 4 * SWAP 3 * + -ROT 2 * + + ;          // ( a b c d -- a+2b+3c+4d )
: TCB8 + + + + + + + ;                        // ( 8 аргументов -- сумма )

// thunk'и (адрес - в константе)
' TCB0 0 MK-WINAPI-CB CONST CB0W
' TCB1 1 MK-WINAPI-CB CONST CB1W
' TCB2 2 MK-WINAPI-CB CONST CB2W
' TCB3 3 MK-WINAPI-CB CONST CB3W
' TCB4 4 MK-WINAPI-CB CONST CB4W
' TCB8 8 MK-WINAPI-CB CONST CB8W
' TCB0 0 MK-CDECL-CB CONST CB0C
' TCB1 1 MK-CDECL-CB CONST CB1C
' TCB2 2 MK-CDECL-CB CONST CB2C
' TCB4 4 MK-CDECL-CB CONST CB4C

// Вложенность: callback сам вызывает DLL (Call" изнутри callback'а).
// CBNEST(a,b) = a + b + 2*(a+2b) = 3a+5b;  для (3,4) = 29.
: CBNEST DDUP CB2W -ROT cbw2 2 * + + ;
' CBNEST 2 MK-WINAPI-CB CONST CBNW

VAR FAILS  0 FAILS !
: CHECK DDUP = IF 2DROP ELSE ." FAIL got=" SWAP . ." want=" . CR 1 FAILS +! THEN ;
: VERDICT CR ." FAILS = " FAILS @ . CR FAILS @ 0= IF ." CB-TEST OK" ELSE ." CB-TEST FAIL" THEN CR ;

CB0W cbw0 7 CHECK
CB1W 5 cbw1 5 CHECK
CB2W 1 2 cbw2 5 CHECK
CB3W 1 2 3 cbw3 14 CHECK
CB4W 1 2 3 4 cbw4 30 CHECK
CB8W 1 2 3 4 5 6 7 8 cbw8 36 CHECK
CB0C cbc0 7 CHECK
CB1C 9 cbc1 9 CHECK
CB2C 1 2 cbc2 5 CHECK
CB4C 1 2 3 4 cbc4 30 CHECK
CB2W 11 22 cbw2_chk 55 CHECK
cb_esp_diff 0 CHECK
CB2W 1 2 100 cbw2_loop 500 CHECK
CBNW 3 4 cbw2 29 CHECK
DEPTH 0 CHECK
VERDICT
