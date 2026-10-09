//  test_nfa.f - проверка CFA>NFA / CFA>LFA / LFA>NFA / NFA>LFA / NFA>CFA
//  Запуск: console_forth.exe heap.f strings.f console.f wincon.f repl.f test_nfa.f
//  или в REPL: S" test_nfa.f" ... (INCLUDED убран из ядра - грузить хостом)

//  --- счётчик провалов ---
VAR FAILS 0 FAILS !

: OK? ( flag -- ) 0= IF 1 FAILS +! THEN ;

//  --- подопытное слово ---
: TEST123 DUP * ;

//  === 1. LATEST @ = CFA подопытного ===
//  (проверим, что LATEST действительно указывает на TEST123)
LATEST @ CONST CFA0

//  === 2. CFA>NFA: NFA = CFA - len - 8 ===
CFA0 CFA>NFA CONST NFA0

//  NFA+0 = len = 7 (TEST123)
NFA0 C@ 7 = OK?

//  NFA+1..len = "TEST123" (проверим первые 3 байта)
NFA0 1 + C@ [CHAR] T = OK?
NFA0 2 + C@ [CHAR] E = OK?
NFA0 3 + C@ [CHAR] S = OK?

// [    7C47E2]    7   54   45   53   54   31   32   33    0    7
//  NFA+1+len = 0 (терминатор)
NFA0 DUP C@ 1+ + C@ 0 = OK?

//  NFA+2+len = len (повтор)
NFA0 DUP C@ 2 + + C@ 7 = OK?

//  NFA+3+len = imm = 0 (не immediate)
NFA0 DUP C@ 3 + + C@ 0 = OK?

//  === 3. CFA>LFA: LFA = CFA - 4 ===
CFA0 CFA>LFA CONST LFA0
CFA0 4 - LFA0 = OK?

//  === 4. NFA>LFA: LFA = NFA + len + 4 ===
NFA0 NFA>LFA LFA0 = OK?

//  === 5. LFA>NFA: NFA = LFA - len - 4 ===
LFA0 LFA>NFA NFA0 = OK?

//  === 6. NFA>CFA: CFA = NFA + len + 8 ===
NFA0 NFA>CFA CFA0 = OK?

//  === 7. Круговые проверки ===
//  (a) CFA>NFA NFA>CFA = CFA>LFA ... нет, = CFA
CFA0 CFA>NFA NFA>CFA CFA0 = OK?

//  (b) CFA>LFA LFA>NFA = CFA>NFA
CFA0 CFA>LFA LFA>NFA CFA0 CFA>NFA = OK?

//  (c) NFA>LFA LFA>NFA = id (на NFA)
NFA0 NFA>LFA LFA>NFA NFA0 = OK?

//  (d) NFA>CFA CFA>NFA = id (на NFA)
NFA0 NFA>CFA CFA>NFA NFA0 = OK?

//  === 8. IMMEDIATE: установка и чтение imm ===
//  поставим immediate на тестовое слово и прочитаем imm через формат
: TESTIMM ;
TESTIMM IMMEDIATE
LATEST @ CFA>NFA DUP C@ + 3 + C@ 1 = OK?

//  (не забыть снять immediate - необязательно, но для чистоты)
//  снять: 0 LATEST @ CFA>NFA DUP C@ + 3 + B!  -- но LATEST теперь TESTIMM

//  === 9. IMMEDIATE на самом TEST123 (проверка, что IMMEDIATE
//        действительно ставит imm=1 на фортовом слове) ===
: TESTIMM2 ;
TESTIMM2 IMMEDIATE
LATEST @ CFA>NFA DUP C@ + 3 + C@ 1 = OK?

//  === 10. asm-слово (DUP) - проверка, что формат тот же ===
' DUP CONST DUPCFA
DUPCFA CFA>NFA CONST DUPNFA
DUPNFA C@ 3 = OK?                //  len("DUP") = 3
DUPNFA NFA>LFA DUPCFA CFA>LFA = OK?
DUPNFA NFA>CFA DUPCFA = OK?
DUPCFA CFA>LFA LFA>NFA DUPNFA = OK?

//  === 11. imm asm-слова: у `;` imm=1 ===
' ; CONST SEMICFA
SEMICFA CFA>NFA DUP C@ + 3 + C@ 1 = OK?

//  --- итог ---
CR ." FAILS = " FAILS @ . CR
: z FAILS @ 0= IF ." ALL OK" CR ELSE ." SOME TESTS FAILED" CR THEN ;
z
