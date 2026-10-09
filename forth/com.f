// _____________________________________________________________________
// com.f - COM-автоматизация forthD (уровень C): vtbl-вызовы + IDispatch
//
// Загрузка:  console_forth.exe heap.f vb.f com.f
//            (нужен vb.f: BSTR-слова, OLE-куча, CoInitialize, VB-CREATEOBJ)
//
// ============================ СТАТУС =================================
// РЕАЛИЗОВАНО: QI/RELEASE (>IDISP), >DISPID, ARG-*/DP-RESET/DP!,
//   IDINVOKE, PROPGET$/PROPSET$/DMETHOD$, OLE-CREATE, RES-*.
//
// ПРОВЕРЕНО РАБОТАЮЩИМ:
//   - CoCreateInstance через зарегистрированный _-Call" (vb.f,
//     VB-CREATEOBJ): FSO/WScript.Shell/контролы Forms.* создаются, S_OK.
//   - GUID-буферы корректны (CoCreateInstance их принимает).
//   - Форма маршаллинга аргументов верная: ручной вызов
//     "arg1..N >R*N  fn CALL_A DROP" ВОЗВРАЩАЕТ ПРАВИЛЬНЫЕ ЗНАЧЕНИЯ
//     (GetPrivateProfileIntA -> 42, lstrlenA -> 5).
//
// БЛОКЕР (не решён): ручные multi-arg stdcall-вызовы через CALL_A
//   НЕСТАБИЛЬНЫ: результат корректен, но после вызова остаётся
//   рассогласование стека -> "Access Violation" в конце строки/на
//   следующем вызове (1-аргументный lstrlenA - чист, 3-аргументный
//   GetPrivateProfileIntA - падает со 2-го-третьего вызова). На этом
//   строятся QI/RELEASE/>DISPID/IDINVOKE -> весь верхний слой
//   (OLE-CREATE/PROPGET$/DMETHOD$) пока падает. Зарегистрированные
//   _-Call" слова при той же форме (0..8 аргументов: SysFreeString,
//   MultiByteToWideChar, WideCharToMultiByte, CoCreateInstance)
//   СТАБИЛЬНЫ - проблема именно в ручном стейджинге/CALL_A.
//   Контракт CALL_A для ручных вызовов в stdlib.f описан только
//   косвенно (см. справку _-Call"), случай CWIN12 (win.f) - единственный
//   прецедент ручного вызова, он 12-аргументный и одиночный.
//
// ОТКРЫТЫЕ ШАГИ (в порядке проб):
//   1. Вариант с явной чисткой: "... >R*N  fn CALL_A  RDROP*N  DROP"
//      (противоречит справке stdlib.f "без RDROP", но её модель
//      "вызываемая функция снимает аргументы" не объясняет наблюдаемое).
//      Тест был прерван - повторить серией из 3+ вызовов подряд.
//   2. Точный контракт CALL_A (что он трёт, в каком порядке) - вопрос
//      автору ядра (forth.d): что отличает ручной вызов от _-Call".
//   3. Обход для создания объектов: CoCreateInstance сразу с
//      IID_IDispatch (зарегистрированный вызов, стабильный) - тогда
//      OLE-CREATE обходится без QI. RELEASE/IDispatch::Invoke от этого
//      не лечатся - vtbl-вызовы всё равно нужен рабочий контракт.
//
// ГРАБЛИ, УЖЕ СОБРАННЫЕ (не повторять):
//   - IID_IDispatch Data1 = $00020400 (не $400 - потеря "2" давала
//     E_NOINTERFACE, а дальше каскадный AV от obj=0).
//   - fn vtbl-вызова = var @ @ @ (ТРИ fetch: var->obj->vtbl->слот;
//     два @ дают vtbl, call по нему = AV внутри чужой DLL).
//   - TYPE в ядре - asciiz, не (addr u) - см. vb.f.
//
// НИЖЕ - целевая документация API (сработает, когда вопрос CALL_A
// будет закрыт).
//
// ЧТО ДАЁТ: полный COM-клиент на Форте. Любой зарегистрированный
// COM-сервер с IDispatch - из скриптов forthD:
//   Scripting.FileSystemObject  - файлы/папки/тексты
//   WScript.Shell               - реестр, ярлыки, спецпапки, Popup
//   Excel.Application / Word.*  - автоматизация Office (32-битный Office!)
//   WinHttp.Request / MSXML2.*  - HTTP/XML без внешних DLL
//   WMI (winmgmts:)             - железо, процессы, службы
//
// МЕХАНИКА (все вызовы - stdcall через CALL_A, шаблон как CWIN12 в win.f):
//   QI       ( obj iid -- iunk|0 )     QueryInterface (vtbl слот 0)
//   RELEASE  ( obj -- )                Release (слот 2), результат игнор
//   >IDISP   ( iunk -- idisp|0 )       QI на IDispatch
//   >DISPID  ( idisp bstr -- dispid|-1 )   GetIDsOfNames (слот 5); -1 = нет
//   IDINVOKE ( idisp dispid wflags named -- hr )  Invoke (слот 6);
//     DISPPARAMS собирается из буфера VARGS (заполняется ARG-* снизу вверх:
//     первый ARG! = последний параметр метода!), named<>0 добавляет
//     DISPID_PROPERTYPUT (-3) для записи свойств
//   OLE-CREATE ( addr u -- idisp|0 )   VB-CREATEOBJ + QI(IDispatch),
//     промежуточный IUnknown отпущен
//
// УДОБНАЯ ОБЁРТКА (имя - counted-строкой, bstr внутри создаётся/гасится):
//   PROPGET$ ( idisp addr u -- hr )    чтение свойства -> результат в vRES
//   PROPSET$ ( idisp addr u -- hr )    запись свойства; значение = ARG в VARGS
//   DMETHOD$ ( idisp addr u -- hr )    вызов метода; аргументы = ARG в VARGS
//   ARG-BSTR ( bstr -- ) / ARG-I4 ( n -- ) / ARG-ERR ( -- "пропущено" )
//     кладут аргумент (порядок: СНАЧАЛА последний параметр метода!)
//   DP-RESET ( -- )                    очистить список аргументов
//
// РЕЗУЛЬТАТ (VARIANT в vRES):
//   RES-VT ( -- vt )  RES-I4 ( -- n )  RES-BSTR ( -- bstr )
//   RES-$. ( -- )     печать BSTR-результата и его освобождение
//   (BSTR из RES-BSTR принадлежит вам - FREEBSTR обязателен,
//    если не печатали через RES-$.)
//
// WFLAGS: 1=метод 2=чтение свойства 4=запись свойства (CONST ниже).
// HRESULT (верхушка стека у PROPGET$/PROPSET$/DMETHOD$/IDINVOKE): 0 = ок.
// РАЗРЯДНОСТЬ: 32-бит (как всё в проекте).

// ==================== GUID ====================
// IID_IDispatch = {00020400-0000-0000-C000-000000000046}
HERE 16 ALLOT CONST IIDDISP
$20400    IIDDISP !
0         IIDDISP 4 + !
$C0       IIDDISP 8 + !
$46000000 IIDDISP 12 + !

// IID_NULL = {00000000-0000-0000-0000-000000000000} (резерв для Invoke)
HERE 16 ALLOT CONST IIDNULL
IIDNULL 0 16 MEMSET DROP

// ==================== скретч ====================
VAR QO   VAR DSP   VAR NAMP          \ QI / GetIDsOfNames
VAR vA   VAR vB   VAR vC   VAR vD   VAR vF   \ аргументы вызовов
VAR NARGS                           \ число ARG-* в VARGS

// ==================== vtbl-примитивы ====================
// СТАТУС: см. шапку - ручные multi-arg stdcall пока нестабильны (баг
// стейджинга CALL_A), QI/RELEASE на реальных объектах падают.
// QI ( obj iid -- iunk|0 )  QueryInterface: (this,riid,&QO), fn=[obj][0]
// fn = vA @ @ @ : var->obj->vtbl->слот0 (ДВА @ дадут vtbl = AV при call!)
: QI ( obj iid -- iunk|0 )
    0 QO ! vB ! vA !
    vA @ vB @ QO >R >R >R
    vA @ @ @ CALL_A DROP
    QO @ ;

// RELEASE ( obj -- )  слот 2: (this) - возврат (refcount) игнорируем
// fn = [vtbl+8]
: RELEASE ( obj -- )
    vA !
    vA @ >R
    vA @ @ 8 + @ CALL_A DROP ;

// >IDISP ( iunk -- idisp|0 )
: >IDISP ( iunk -- idisp|0 ) IIDDISP QI ;

// ==================== GetIDsOfNames ====================
// >DISPID ( idisp bstr -- dispid | -1 )  слот 5:
// (this, IID_NULL, &name, 1, 0, &DSP)
: >DISPID ( idisp bstr -- dispid | -1 )
    NAMP ! vA !
    0 DSP !
    vA @ IIDNULL NAMP @ 1 0 DSP >R >R >R >R >R >R
    vA @ @ 5 CELLS + @ CALL_A DROP
    IF -1 EXIT THEN DSP @ ;

// ==================== DISPPARAMS + Invoke ====================
// VARGS: буфер до 8 VARIANT'ов; DPB: DISPPARAMS (4 ячейки);
// NAMEDP: DISPID_PROPERTYPUT (-3) для записи свойств
HERE 128 ALLOT CONST VARGS
HERE 16  ALLOT CONST DPB
HERE 4   ALLOT CONST NAMEDP
HERE 16  ALLOT CONST vRES      \ VARIANT-результат
HERE 64  ALLOT CONST vEX       \ EXCEPINFO
HERE 4   ALLOT CONST vERR      \ arg error index

-3 NAMEDP !                    \ DISPID_PROPERTYPUT

// DP-RESET ( -- )  очистить аргументы и результат
: DP-RESET ( -- )
    0 NARGS ! 0 vERR !
    vRES 0 16 MEMSET DROP ;

// ARG! ( vt data -- )  VARIANT в следующий слот VARGS
: ARG! ( vt data -- )
    vB ! vA !
    NARGS @ 16 * VARGS + DUP
    0 16 MEMSET DROP
    vA @ OVER C!  0 OVER 1+ C!
    vB @ SWAP 8 + !
    NARGS @ 1+ NARGS ! ;

// ARG-BSTR ( bstr -- ) / ARG-I4 ( n -- ) / ARG-ERR ( -- )
: ARG-BSTR ( bstr -- ) 8 SWAP ARG! ;
: ARG-I4   ( n -- )    3 SWAP ARG! ;
: ARG-ERR  ( -- )      10 $80020004 ARG! ;

// DP! ( named -- )  собрать DISPPARAMS из VARGS/NARGS
: DP! ( named -- )
    VARGS DPB !
    NAMEDP DPB 4 + !
    NARGS @ DPB 8 + !
    IF 1 ELSE 0 THEN DPB 12 + ! ;

// IDINVOKE ( idisp dispid wflags named -- hr )  слот 6:
// (this, dispid, IID_NULL, lcid=0, wflags, &DPB, &vRES, &vEX, &vERR)
: IDINVOKE ( idisp dispid wflags named -- hr )
    DP! vF ! vD ! vC !
    vC @ vD @ IIDNULL 0 vF @ DPB vRES vEX vERR
    >R >R >R >R >R >R >R >R >R
    vC @ @ 6 CELLS + @ CALL_A DROP ;

1 CONST DISP-METHOD
2 CONST DISP-GET
4 CONST DISP-PUT

// ==================== удобные обёртки ====================
// PROPGET$ ( idisp addr u -- hr )   чтение свойства -> vRES
: PROPGET$ ( idisp addr u -- hr )
    STR>BSTR SWAP vC !        \ (bstr), idisp в vC
    DUP >R vC @ SWAP >DISPID  \ (dispid|-1) R:bstr
    R> FREEBSTR
    DUP -1 = IF DROP -1 EXIT THEN
    vC @ SWAP DISP-GET 0 IDINVOKE ;

// PROPSET$ ( idisp addr u -- hr )   запись свойства; значение уже в VARGS
: PROPSET$ ( idisp addr u -- hr )
    STR>BSTR SWAP vC !
    DUP >R vC @ SWAP >DISPID
    R> FREEBSTR
    DUP -1 = IF DROP -1 EXIT THEN
    vC @ SWAP DISP-PUT 1 IDINVOKE ;

// DMETHOD$ ( idisp addr u -- hr )   вызов метода; аргументы уже в VARGS
: DMETHOD$ ( idisp addr u -- hr )
    STR>BSTR SWAP vC !
    DUP >R vC @ SWAP >DISPID
    R> FREEBSTR
    DUP -1 = IF DROP -1 EXIT THEN
    vC @ SWAP DISP-METHOD 0 IDINVOKE ;

// OLE-CREATE ( addr u -- idisp|0 )  ProgID -> IDispatch (IUnknown отпущен)
: OLE-CREATE ( addr u -- idisp|0 )
    VB-CREATEOBJ DUP IF DUP >IDISP SWAP RELEASE ELSE DROP 0 THEN ;

// ==================== чтение результата ====================
// RES-VT ( -- vt )  RES-I4 ( -- n )  RES-BSTR ( -- bstr, ваш - FREEBSTR! )
: RES-VT   ( -- vt )   vRES C@ ;
: RES-I4   ( -- n )    vRES 8 + @ ;
: RES-BSTR ( -- bstr ) vRES 8 + @ ;

// RES-$. ( -- )  печать BSTR-результата с освобождением
: RES-$. ( -- ) RES-BSTR DUP IF DUP $.B FREEBSTR ELSE DROP ." NULL" THEN ;

__EOF__

// ================== демо (за __EOF__ - не выполняются при загрузке) ==================
// Загрузка:   console_forth.exe heap.f vb.f com.f
//
// Пока НЕ проходит (блокер vtbl-вызовов, см. шапку). Цель автотеста:
//   VAR FS
//   S" Scripting.FileSystemObject" OLE-CREATE FS !
//   FS @ S" CurrentDirectory" PROPGET$ .  RES-$. CR        \ 0 + текущий каталог
//   DP-RESET
//   S" file.txt" STR>BSTR ARG-BSTR   \ BuildPath(Path, Name):
//   S" C:\"      STR>BSTR ARG-BSTR   \   ARG сначала = ПОСЛЕДНИЙ параметр!
//   FS @ S" BuildPath" DMETHOD$ .  RES-$. CR               \ 0 + C:\file.txt
//
// Запись свойства (WScript.Shell, CurrentDirectory R/W):
//   VAR SH  VAR B1
//   S" WScript.Shell" OLE-CREATE SH !
//   SH @ S" CurrentDirectory" PROPGET$ DROP RES-BSTR DUP B1 ! ARG-BSTR
//   SH @ S" CurrentDirectory" PROPSET$ .                   \ 0
//   B1 @ FREEBSTR
//
// Excel (32-битный Office; тяжёлый запуск - только интерактивно):
//   VAR XL
//   S" Excel.Application" OLE-CREATE XL !
//   XL @ S" Version" PROPGET$ DROP RES-$. CR
//
// Гигиена: объекты RELEASE после использования (процесс умрёт - не страшно,
// но в долгоживущем REPL накапливаются).
