// t_call.f - detailed test matrix for _-Call" branches and derived words
// Run: console_forth.exe heap.f strings.f console.f t_call.f
// Check line format:  DEPTH . <args> CALL . DEPTH .
//   -> "D result D" = stack balanced; "D result D+1" = LEAK.
// -----------------------------------------------------------------

// ---------- registrations (own lib words: late registrations need own LibraryLoad)
Lib" msvcrt.dll" crt2
Library@ crt2 1 CDECL-Call" abs"       cabs
Library@ crt2 2 CDECL-Call" strchr"    cstrchr
Library@ crt2 3 CDECL-Call" memset"    cmemset
Library@ crt2 4 CDECL-Call" _snprintf" csnpr4
Library@ crt2 5 CDECL-Call" _snprintf" csnpr5
Library@ crt2 0 GADR-Call" abs"        XABS
LibraryLoad crt2

Lib" kernel32.dll" k32t
Library@ k32t 0 WINAPI-Call" GetTickCount"       GetTickCount
Library@ k32t 1 WINAPI-Call" GetModuleHandleA"   GetModuleHandle
Library@ k32t 3 WINAPI-Call" GetModuleFileNameA" GetModuleFileName
LibraryLoad k32t

Lib" user32.dll" u32t
Library@ u32t 1 WINAPI-Call" GetSystemMetrics" GetSystemMetrics
Library@ u32t 2 WINAPI-Call" LoadCursorA"      LoadCursor
Library@ u32t 4 WINAPI-Call" SendMessageA"     SendMessage
Library@ u32t 4 WINAPI-Call" DefWindowProcA"   DefWindowProc
Library@ u32t 7 WINAPI-Call" SetWindowPos"     SetWindowPos
Library@ u32t 0 GADR-Call" DefWindowProcA"     XDWP
Library@ u32t 0 GADR-Call" LoadCursorA"        XLC
LibraryLoad u32t

// ---------- buffers and strings (DROP cleans S" dup artifact)
HERE 256 ALLOT CONST BUF
S" hello" 1+ CONST S1   DROP
S" %d" 1+    CONST FMT1 DROP
S" %d%d" 1+  CONST FMT2 DROP

." ================= CDECL =================" CR
." T01 cdecl-1 abs(-7)      expect: 1 7 1" CR
DEPTH . -7 cabs . DEPTH . CR
." T02 cdecl-2 strchr(hi,o) expect: 1 nonzero 1" CR
DEPTH . S1 111 cstrchr . DEPTH . CR
." T03 cdecl-3 memset       expect: 1 bufaddr 1, then 65 65" CR
DEPTH . BUF 65 3 cmemset . DEPTH . BUF B@ . BUF 1+ B@ . CR
." T04 cdecl-4 _snprintf    expect: 1 2 1, buf=<42>" CR
DEPTH . BUF 63 FMT1 42 csnpr4 . DEPTH . BUF TYPE CR
." T05 cdecl-5 _snprintf    expect: 1 4 1, buf=<7,8> (universal branch)" CR
DEPTH . BUF 63 FMT2 7 8 csnpr5 . DEPTH . BUF TYPE CR

." ================= WINAPI =================" CR
." T06 winapi-0 GetTickCount    expect: 1 nonzero 1" CR
DEPTH . GetTickCount . DEPTH . CR
." T07 winapi-1 GetSystemMetrics expect: 1 nonzero 1" CR
DEPTH . 0 GetSystemMetrics . DEPTH . CR
." T08 winapi-2 LoadCursor(IDC_ARROW) expect: 1 nonzero 1" CR
DEPTH . 0 32512 LoadCursor . DEPTH . CR
." T09 winapi-3 GetModuleFileName expect: 1 nonzero 1" CR
DEPTH . 0 BUF 260 GetModuleFileName . DEPTH . CR
." T10 winapi-4 SendMessage(0..) expect: 1 0 1" CR
DEPTH . 0 0 0 0 SendMessage . DEPTH . CR
." T11 winapi-4 DefWindowProc(0..) expect: 1 0 1" CR
DEPTH . 0 0 0 0 DefWindowProc . DEPTH . CR
." T12 winapi-7 SetWindowPos(0..) expect: 1 0 1 (universal branch)" CR
DEPTH . 0 0 0 0 0 0 0 SetWindowPos . DEPTH . CR

." ================= GADR (type 0) =================" CR
." T13 GADR DefWindowProcA  expect: 1 nonzero 1" CR
DEPTH . XDWP . DEPTH . CR
." T14 GADR LoadCursorA     expect: 1 nonzero 1" CR
DEPTH . XLC . DEPTH . CR

." ================= manual CALL_A / CALLB (derived patterns) =================" CR
." T15 stdcall-2 manual: 0 32512 >R>R XLC CALL_A DROP  expect: 1 nonzero 1" CR
DEPTH . 0 >R 32512 >R XLC CALL_A DROP . DEPTH . CR
." T16 cdecl-1 manual: -7 >R XABS CALL_A RDROP DROP    expect: 1 7 1" CR
DEPTH . -7 >R XABS CALL_A RDROP DROP . DEPTH . CR
." T17 stdcall-2 via CALLB: 0 32512 >R>R XLC CALLB DROP expect: 1 nonzero 1" CR
DEPTH . 0 >R 32512 >R XLC CALLB DROP . DEPTH . CR

." ================= calls inside colon definitions =================" CR
: TC1 -7 cabs ;
: TC5 BUF 63 FMT2 1 2 csnpr5 ;
: TW2 0 32512 LoadCursor ;
: TW7 0 0 0 0 0 0 0 SetWindowPos ;
." T18 : TC1 -7 cabs ; TC1   expect: 1 7 1" CR
DEPTH . TC1 . DEPTH . CR
." T19 : TC5 .. csnpr5 ; TC5 expect: 1 4 1" CR
DEPTH . TC5 . DEPTH . CR
." T20 : TW2 .. LoadCursor ; TW2 expect: 1 nonzero 1" CR
DEPTH . TW2 . DEPTH . CR
." T21 : TW7 .. SetWindowPos ; TW7 expect: 1 0 1" CR
DEPTH . TW7 . DEPTH . CR

." ================= machine stack stress (loops) =================" CR
." T22 loop 50000 winapi-0   (survive = machine stack ok)" CR
: TL0 50000 0 DO GetTickCount DROP LOOP ;
DEPTH . TL0 DEPTH . CR
." T23 loop 50000 winapi-2" CR
: TL2 50000 0 DO 0 32512 LoadCursor DROP LOOP ;
DEPTH . TL2 DEPTH . CR
." T24 loop 50000 cdecl-1" CR
: TLC 50000 0 DO -7 cabs DROP LOOP ;
DEPTH . TLC DEPTH . CR
." T25 loop 20000 cdecl-5 (universal)" CR
: TL5 20000 0 DO BUF 63 FMT2 1 2 csnpr5 DROP LOOP ;
DEPTH . TL5 DEPTH . CR

." ================= done =================" CR
