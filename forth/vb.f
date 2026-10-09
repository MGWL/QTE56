// _____________________________________________________________________
// vb.f - диалоги/строки/COM для forthD: BSTR-механика + user32/shell32/ole32
//
// Загрузка:  console_forth.exe heap.f vb.f
//            (нужен heap.f - HALLOC/HFREE; stdlib грузится сам)
//
// ПОЧЕМУ НЕ msvbvm60.dll (rtc*):
// rtcBeep/rtcDoEvents работают (проверено), но ВСЕ функции с BSTR/VARIANT
// аргументами (rtcMsgBox, rtcInputBox, rtcShell, rtcEnvironBstr, rtcFileLen)
// падают с Access Violation: внутри они идут через __vba*-помощники, которым
// нужен контекст потока VB (TLS/EBX), создаваемый только входом ThunRTMain.
// Сигнатуры при этом известны точно (реверс Wine/openmsvbvm): строковые
// аргументы - VARIANT* (vt=VT_BSTR/VT_ERROR для пропущенных), это учтено в
// истории файла. Без инициализации VB-приложения рантайм недоступен.
// Поэтому: MsgBox/Shell - напрямую user32/shell32 (те же диалоги, без
// рантайма), а COM - через ole32 (COM-серверы контекст VB НЕ требуют).
//
// КОДИРОВКА: строки идут через CP_ACP (ANSI = 1251 на русской Windows).
// Этот файл в UTF-8, его литералы - английские. Для русских надписей
// сохраняйте ваши файлы в CP1251 (как strings.f): S" кириллица" -> asciiz
// -> MessageBoxA покажет её правильно.
//
// BSTR-механика (OLE-куча oleaut32):
//   >BSTR  ( addr u -- bstr )     ANSI -> BSTR (SysAllocStringLen)
//   FREEBSTR ( bstr -- )          вернуть OLE-куче (SysFreeString)
//   STR>BSTR ( s -- bstr )        то же для counted-строки S"
//   BSTR>  ( bstr -- addr u )     BSTR -> ANSI-копия в HALLOC; вызови HFREE!
//   $.B    ( bstr -- )            напечатать и освободить копию
//   SYSLEN - длина BSTR в символах (SysStringLen)
//
// СЛОВА:
//   VB-MB     ( addr u -- n )         MsgBox, одна кнопка OK
//   VB-MSGBOX ( addr u style -- n )   style = MB-* (OR иконки к кнопкам)
//   VB-SHELL  ( addr u -- hinst|err ) ShellExecute "open"; >32 = успех
//   VB-BEEP   ( -- )  VB-DOEVENTS ( -- )   (msvbvm60, работают без контекста)
//   VB-CREATEOBJ ( addr u -- iunk|0 )  CreateObject через ole32:
//     CLSIDFromProgID + CoCreateInstance(IUnknown); 0 = не создался.
//     Это же вход для fm20.dll (MSForms): "Forms.UserForm.1" и т.п.
//
// ВОЗВРАТЫ MsgBox: VB-OK=1 VB-CANCEL=2 VB-ABORT=3 VB-RETRY=4 VB-IGNORE=5
//                 VB-YES=6 VB-NO=7
// РАЗРЯДНОСТЬ: интерпретатор и все DLL - 32-бит.

// ==================== DLL ====================
// oleaut32 - куча OLE для BSTR
Lib" oleaut32.dll" ole
Library@ ole 2 WINAPI-Call" SysAllocStringLen" SYSALLOCLEN
Library@ ole 1 WINAPI-Call" SysFreeString"     SYSFREE
Library@ ole 1 WINAPI-Call" SysStringLen"      SYSLEN
LibraryLoad ole

// kernel32 - перекодировка ANSI <-> Unicode
Lib" kernel32.dll" k32v
Library@ k32v 6 WINAPI-Call" MultiByteToWideChar" MB2WC
Library@ k32v 8 WINAPI-Call" WideCharToMultiByte" WC2MB
LibraryLoad k32v

// user32 - MessageBoxA вместо недоступного rtcMsgBox
Lib" user32.dll" u32v
Library@ u32v 4 WINAPI-Call" MessageBoxA" MSGBOXA
LibraryLoad u32v

// shell32 - ShellExecuteA вместо rtcShell
Lib" shell32.dll" sh32
Library@ sh32 6 WINAPI-Call" ShellExecuteA" SHELLEXECA
LibraryLoad sh32

// ole32 - COM без VB-рантайма (CoInitialize/CoCreateInstance)
Lib" ole32.dll" ole32
Library@ ole32 1 WINAPI-Call" CoInitialize" COINIT
Library@ ole32 1 WINAPI-Call" CoUninitialize" COUNINIT
Library@ ole32 2 WINAPI-Call" CLSIDFromProgID" CLSIDFP
Library@ ole32 5 WINAPI-Call" CoCreateInstance" COCREATE
LibraryLoad ole32

// msvbvm60 - только то, что работает без контекста VB (см. шапку)
Lib" msvbvm60.dll" vb6
Library@ vb6 0 WINAPI-Call" rtcDoEvents" RTC-DOEVENTS
Library@ vb6 0 WINAPI-Call" rtcBeep"     RTC-BEEP
LibraryLoad vb6

0 COINIT DROP    \ инициализация COM-апартамента (S_OK/S_FALSE - ок)

// ==================== BSTR-механика ====================
VAR vSrc   VAR vBs   VAR vAn

// >BSTR ( addr u -- bstr )  ANSI -> BSTR.
// SysAllocStringLen(NULL, u+1) сразу выделяет BSTR нужной длины,
// MultiByteToWideChar пишет юникод прямо в неё, дописываем wide-NUL.
: >BSTR ( addr u -- bstr )
    SWAP vSrc !                     \ адрес ANSI-источника
    1+ DUP >R                       \ cch = u+1 (место под NUL)  (R: cch)
    0 SWAP SYSALLOCLEN              \ bstr = SysAllocStringLen(NULL, cch)
    DUP vBs !
    DUP NOT IF DROP R> DROP 0 EXIT THEN
    DROP
    1 0 vSrc @ R@ 1- vBs @ R@ MB2WC DROP
    vBs @ R> 1- 2 * + 0 2 MEMSET DROP   \ wide-NUL (2 байта)
    vBs @ ;

// STR>BSTR ( s -- bstr )  counted-строка (от S"/WORD) -> BSTR
: STR>BSTR ( s -- bstr ) DUP 1+ SWAP B@ >BSTR ;

// FREEBSTR ( bstr -- )  вернуть BSTR OLE-куче
: FREEBSTR ( bstr -- ) SYSFREE DROP ;

// BSTR> ( bstr -- addr u )  BSTR -> ANSI-копия в HALLOC-куче.
// ВЫЗОВИ HFREE для результата! NULL -> (0 0).
// Буфер NUL-завершён (WC2MB пишет 0 после u байт) - печать: BSTR> DROP TYPE
// (TYPE в этом ядре - asciiz, НЕ (addr u)!), длина u при этом теряется.
: BSTR> ( bstr -- addr u )
    DUP vBs !
    DUP NOT IF 0 EXIT THEN
    SYSLEN DUP >R                   \ u                          (R: u)
    2 * 1+ HALLOC DUP vAn !         \ запас 2x - в ANSI влезет точно
    DUP NOT IF DROP R> DROP 0 0 EXIT THEN
    DROP
    1 0 vBs @ R@ vAn @ R@ 2 * 1+ 0 0 WC2MB DROP
    vAn @ R> ;

// $.B ( bstr -- )  печать ANSI-копии (asciiz) + освобождение копии
: $.B ( bstr -- ) DUP NOT IF DROP ." NULL" EXIT THEN BSTR> DROP TYPE ;

// ==================== MsgBox (user32 MessageBoxA) ====================
0  CONST MB-OK               \ кнопки
1  CONST MB-OKCANCEL
2  CONST MB-ABORTRETRYIGNORE
3  CONST MB-YESNOCANCEL
4  CONST MB-YESNO
5  CONST MB-RETRYCANCEL
16 CONST MB-ICONSTOP         \ иконки (OR-ятся к кнопкам)
32 CONST MB-ICONQUEST
48 CONST MB-ICONWARN
64 CONST MB-ICONINFO

1  CONST VB-OK               \ возвраты
2  CONST VB-CANCEL
3  CONST VB-ABORT
4  CONST VB-RETRY
5  CONST VB-IGNORE
6  CONST VB-YES
7  CONST VB-NO

// VB-MSGBOX ( addr u style -- n )  counted-строка: 1+ = asciiz (NUL уже
// есть в формате [len][chars][0]). Заголовок - "ForthD".
: VB-MSGBOX ( addr u style -- n )
    >R DROP 1+
    0 SWAP S" ForthD" 1+ R>
    MSGBOXA ;

// VB-MB ( addr u -- n )  просто OK
: VB-MB ( addr u -- n ) 0 VB-MSGBOX ;

// ==================== Shell (shell32 ShellExecuteA) ====================
// VB-SHELL ( addr u -- hinst | <=32 ошибка )  глагол "open", show=1.
// Результат >32 = успех (НЕ pid: ShellExecute возвращает HINSTANCE).
: VB-SHELL ( addr u -- hinst | err )
    >R DROP 1+
    0 S" open" 1+ SWAP 0 0 R>
    SHELLEXECA ;

// ==================== COM (ole32) ====================
// VB-CREATEOBJ ( addr u -- iunk | 0 )  ProgID -> сырой IUnknown*.
// Вызовы через vtbl/IDispatch - следующий слой; Release обязателен
// позже (пока процесс жив, утечка не страшна). 0 = ProgID не найден.
HERE 16 ALLOT CONST CLSIDBUF
HERE 16 ALLOT CONST IIDIUNK
VAR VBUNK

0 IIDIUNK !                 \ IID_IUnknown = {00000000-0000-0000-
0 IIDIUNK 4 + !             \                    0000-000000000046}
$C0 IIDIUNK 8 + !           \ байты C0 00 00 00 00 00 00 46 (LE)
$46000000 IIDIUNK 12 + !

: VB-CREATEOBJ ( addr u -- iunk | 0 )
    0 VBUNK !
    STR>BSTR DUP >R CLSIDBUF CLSIDFP DROP   \ ProgID -> CLSID
    R> FREEBSTR
    CLSIDBUF 0 5 IIDIUNK VBUNK COCREATE DROP
    VBUNK @ ;

// ==================== msvbvm60: работающий минимум ====================
: VB-DOEVENTS ( -- ) RTC-DOEVENTS DROP ;
: VB-BEEP ( -- ) RTC-BEEP DROP ;

__EOF__

// ================== демо (за __EOF__ - не выполняются при загрузке) ==================
// Загрузка:   console_forth.exe heap.f vb.f
//
// BSTR-механика:
//   S" Hello, BSTR!" STR>BSTR DUP . SYSLEN . FREEBSTR       \ адрес, 14
//   S" W" STR>BSTR DUP $.B FREEBSTR                          \ W
//
// Диалоги:
//   S" Just say it" DUP 1+ SWAP B@ VB-MB DROP                \ MsgBox OK
//   S" Continue?" DUP 1+ SWAP B@ MB-YESNO MB-ICONQUEST + VB-MSGBOX .
//                                                            \ 6=Да 7=Нет
// Запуск программы:
//   S" notepad.exe" DUP 1+ SWAP B@ VB-SHELL .                 \ >32 = ок
// COM (проверено, все <>0 кроме UserForm):
//   S" Scripting.FileSystemObject" VB-CREATEOBJ .     \ автоматизация
//   S" WScript.Shell" VB-CREATEOBJ .
//   S" Forms.TextBox.1" VB-CREATEOBJ .                \ контролы MSForms
//   S" Forms.CommandButton.1" VB-CREATEOBJ .          \   креатабельны!
//   S" Forms.UserForm.1" VB-CREATEOBJ .               \ 0: форма вне VBA
//     не создаётся; показ контролов требует OLE-контейнера (след. слой)
//
// Прочее:
//   VB-BEEP  VB-DOEVENTS
