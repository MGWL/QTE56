// _____________________________________________________________________
// win.f - простейшее окно Windows средствами forthD (тест ядра: callback-мост)
//
// Загрузка: console_forth.exe heap.f strings.f console.f wincon.f repl.f win.f
// Вживую (cmd.exe):  WIN  - окно с заголовком, крестик закрывает (WM_QUIT)
//					   WIN2 - то же, но WndProc целиком на Форте (thunk
//					 MK-WINAPI-CB -> cbBridge -> WPH)
// Автотест:		  WTEST - окно мигает и закрывается само; WndProc =
//					 thunk -> cbBridge -> WPH, проверен синхронным
//					 SendMessage(WM_DESTROY) + posted WM_QUIT -> PUMP
//					 выходит. Если мост сломан - WTEST зависнет или упадёт.
//
// Механика: WINOPEN берёт lpfnWndProc параметром. WTEST передаёт thunk от
// MK-WINAPI-CB (stdlib.f) -> WPH исполняется НАСТОЯЩИМ Windows-колбэком
// через мост cbBridge (forth.d). Подробно про callback-механизм - callback.md. Контекст ФВМ мост берёт из снимка
// gCbSave*, который callD/callD2 обновляют перед каждым внешним вызовом, -
// старый запрет DLL-вызовов изнутри колбэка СНЯТ (вложенный Call" проверен
// CBNEST в test/cb_test.f). Живой WIN по-прежнему регистрирует D-функцию
// wndProcD (console_forth.d, ячейка 15) - обычный легальный WndProc.
// WNDCLASSEX (48 байт) и MSG (28 байт) в 32-битном Windows - все поля
// по 4 байта, поэтому наши плотные CELL-структуры совпадают с Windows
// автоматически, без выравнивания.
// CreateWindowExA имеет 12 параметров, а _-Call" stdlib.f умеет до 4 -
// поэтому CWIN12 гоняет аргументы на стек возвратов вручную через CALL_A,
// адрес функции даёт GADR-Call" (слово возвращает адрес, не вызывая).
//
// Старый мост wndProcBridge (GSAVE/MSGSAVE, общие ячейки 13/14) УДАЛЁН из
// console_forth.d - thunk-путь полностью его заменил (см. callback.md).

Lib" user32.dll" u32
Library@ u32 3 WINAPI-Call" InvalidateRect"	   InvalidateRect
Library@ u32 1 WINAPI-Call" RegisterClassExA"  RegisterClassEx
Library@ u32 2 WINAPI-Call" ShowWindow"		   ShowWindow
Library@ u32 1 WINAPI-Call" UpdateWindow"	   UpdateWindow
Library@ u32 4 WINAPI-Call" GetMessageA"	   GetMessageA
Library@ u32 1 WINAPI-Call" TranslateMessage"  TranslateMessage
Library@ u32 1 WINAPI-Call" DispatchMessageA"  DispatchMessageA
Library@ u32 4 WINAPI-Call" DefWindowProcA"	   DefWindowProc
Library@ u32 0	 GADR-Call" DefWindowProcA"	   XDWP
Library@ u32 4 WINAPI-Call" SendMessageA"	   SendMessageA
Library@ u32 1 WINAPI-Call" PostQuitMessage"   PostQuitMessage
Library@ u32 2 WINAPI-Call" LoadCursorA"	   LoadCursor
Library@ u32 1 WINAPI-Call" DestroyWindow"	   DestroyWindow
Library@ u32 1 WINAPI-Call" GetSystemMetrics"  GetSystemMetrics
Library@ u32 1 WINAPI-Call" IsWindowVisible"   IsWindowVisible
Library@ u32 5 WINAPI-Call" SetWindowPos"	   SetWindowPos
Library@ u32 1 WINAPI-Call" IsIconic"		   IsIconic
Library@ u32 2 WINAPI-Call" GetWindowRect"	   GetWindowRect
Library@ u32 2 WINAPI-Call" BeginPaint"		   BeginPaint
Library@ u32 2 WINAPI-Call" EndPaint"		   EndPaint
Library@ u32 0	 GADR-Call" CreateWindowExA"   XCW	 // адрес ф-ции, не вызов
Lib" gdi32.dll" g32
Library@ g32 1 WINAPI-Call" GetStockObject"	   GetStockObject
Library@ g32 5 WINAPI-Call" TextOutA"		   TextOut
Library@ g32 5 WINAPI-Call" Rectangle"		   Rectangle
Library@ g32 5 WINAPI-Call" Ellipse"		   Ellipse
Library@ g32 4 WINAPI-Call" MoveToEx"		   MoveToEx
Library@ g32 3 WINAPI-Call" LineTo"			   LineTo
LibraryLoad u32
LibraryLoad g32

// GetModuleHandleA живёт в kernel32; свой хэндл (k32 wincon уже LibraryLoad'ен -
// поздние регистрации в чужой список не попадают)
Lib" kernel32.dll" k32w
Library@ k32w 1 WINAPI-Call" GetModuleHandleA"	GetModuleHandle
LibraryLoad k32w
0 GetModuleHandle CONST HINST

// ---- структуры (все поля CELL: раскладка совпадает с Win32) ----
STRUCT
	CELL FIELD F.SZ	  // cbSize
	CELL FIELD F.style	  // style
	CELL FIELD F.PR	  // lpfnWndProc
	CELL FIELD F.CX	  // cbClsExtra
	CELL FIELD F.WX	  // cbWndExtra
	CELL FIELD F.HI	  // hInstance
	CELL FIELD F.IC	  // hIcon
	CELL FIELD F.CU	  // hCursor
	CELL FIELD F.BR	  // hbrBackground
	CELL FIELD F.MU	  // lpszMenuName
	CELL FIELD F.CL	  // lpszClassName
	CELL FIELD F.SM	  // hIconSm
/STRUCT /WC

STRUCT
	CELL FIELD M.H	  // hwnd
	CELL FIELD M.M	  // message
	CELL FIELD M.W	  // wParam
	CELL FIELD M.L	  // lParam
	CELL FIELD M.T	  // time
	CELL FIELD M.X	  // pt.x
	CELL FIELD M.Y	  // pt.y
/STRUCT /MSG
// буфер аргументов обработчика (4 ячейки)
STRUCT
	CELL FIELD Q.H	CELL FIELD Q.M	CELL FIELD Q.W	CELL FIELD Q.L
/STRUCT /Q

HERE /WC ALLOT	 CONST WC	  // WNDCLASSEX
HERE /MSG ALLOT	 CONST MSG	  // MSG
HERE /Q ALLOT	 CONST MQ	  // аргументы WPH
HERE 80 ALLOT CONST PSPAD  // PAINTSTRUCT для BeginPaint

// ---------- Оконные константы ---------------
$00000000  CONST WS_OVERLAPPED
$80000000  CONST WS_POPUP
$40000000  CONST WS_CHILD
$20000000  CONST WS_MINIMIZE
$10000000  CONST WS_VISIBLE
$08000000  CONST WS_DISABLED
$04000000  CONST WS_CLIPSIBLINGS
$02000000  CONST WS_CLIPCHILDREN
$01000000  CONST WS_MAXIMIZE
$00C00000  CONST WS_CAPTION
$00800000  CONST WS_BORDER
$00400000  CONST WS_DLGFRAME
$00200000  CONST WS_VSCROLL
$00100000  CONST WS_HSCROLL
$00080000  CONST WS_SYSMENU
$00040000  CONST WS_THICKFRAME
$00020000  CONST WS_GROUP
$00010000  CONST WS_TABSTOP
$00020000  CONST WS_MINIMIZEBOX
$00010000  CONST WS_MAXIMIZEBOX

WS_OVERLAPPED        CONST WS_TILED
WS_MINIMIZE          CONST WS_ICONIC
WS_THICKFRAME        CONST WS_SIZEBOX

// Комбинация для окна WS_OVERLAPPEDWINDOW
WS_TILED WS_SYSMENU OR CONST WS_мойСтиль
	 
// -------------------------

// .U - вывод беззнакового числа теперь в ядре (forth.d), локальная копия не нужна

// LOWORD/HIWORD  ( lparam -- x|y )	 выделение 16-битных полей из lParam
// сообщений Windows (координаты мыши, клавиши и т.п.). RSHIFT логический -
// знаковость lParam не важна.
: LOWORD 65535 AND ;
: HIWORD 16 RSHIFT 65535 AND ;

S" FORTHWIN" 1+ CONST CLSNAME
S" win forthD: clear WinAPI from ForthD" 1+ CONST TITLE

// Текст для отрисовки в окне: counted-строки (первый байт - длина).
// TextOutA берёт ( hdc x y addr len ) - адрес текста = WTXTn 1+,
// длина = WTXTn B@.
S" Hello from ForthD!"			  CONST WTXT1
S" WM_PAINT painted by WPH"		  CONST WTXT2
S" Win_callback -> cbBridge -> Forth" CONST WTXT3

// Для клика мышью
VAR CLICKX	VAR CLICKY	VAR HASCLICK
0 CLICKX !	0 CLICKY !	0 HASCLICK !
S" Click!" CONST WTXT4

VAR HW							  // hwnd окна

// Рисунок в клиентской области. ( hdc -- ), HDC сохраняем DUP'ом перед
// каждым GDI-вызовом (stdcall - аргументы снимает вызываемая функция).
// После фона, если был клик, выводим WTXT4 в точке клика.
: WDRAW ( hdc -- )
	DUP 4 4 300 157 Rectangle DROP			// рамка по краю клиентской области (~304x161)
	DUP 20 25 285 75 Ellipse DROP			// эллипс за текстом
	DUP 30 35 WTXT1 DUP 1+ SWAP B@ TextOut DROP
	DUP 30 55 WTXT2 DUP 1+ SWAP B@ TextOut DROP
	DUP 30 90 280 130 Rectangle DROP		// внутренний прямоугольник
	DUP 30 130 0 MoveToEx DROP				// NULL lppt: просто позиция пера
	DUP 280 90 LineTo DROP					// диагональ внутри прямоугольника
	DUP 30 140 WTXT3 DUP 1+ SWAP B@ TextOut DROP
	HASCLICK @ IF
		DUP CLICKX @ CLICKY @				// hdc x y
		WTXT4 DUP 1+ SWAP B@ TextOut DROP
	THEN
	DROP ;

// Оконная процедура Форта - вызывается настоящим Windows-колбэком через
// thunk (' WPH 4 MK-WINAPI-CB); мост cbBridge + снимок gCbSave* (см.
// callback.md) делают законными и обычные Call" изнутри неё (проверено
// CBNEST в test/cb_test.f). Разбор сообщений - CASE/OF/ENDOF/ENDCASE
// (console.f). WM_PAINT закрывает парой BeginPaint/EndPaint (иначе регион
// не валидируется и Windows шлет WM_PAINT бесконечно - PUMP превращается
// в сплошной цикл), ВСЕ прочие сообщения отдаются DefWindowProc - иначе
// фон не рисуется и поведение окна отличается от WIN.
VAR WQUIT							// флаг "окно уничтожено" (WM_DESTROY/WM_CLOSE)

// #define WM_LBUTTONDOWN				   0x0201
// #define WM_LBUTTONUP					   0x0202
// #define WM_LBUTTONDBLCLK				   0x0203
// #define WM_PAINT						   0x000F
// #define WM_CLOSE						   0x0010



$0201 CONST WM_LBUTTONDOWN
$000F CONST WM_PAINT

: WPH ( hwnd msg wparam lparam -- result )
	MQ Q.L ! MQ Q.W ! MQ Q.M ! MQ Q.H !
	MQ Q.M @ CASE
		 2 OF 1 WQUIT ! 0 ENDOF						 // WM_DESTROY
		16 OF 1 WQUIT ! 0 ENDOF						 // WM_CLOSE

		WM_PAINT OF									 // WM_PAINT
			MQ Q.H @ PSPAD BeginPaint WDRAW			 // весь рисунок (вкл. клик)
			MQ Q.H @ PSPAD EndPaint DROP 0			 // EndPaint валидирует регион
		ENDOF

		WM_LBUTTONDOWN OF							 // WM_LBUTTONDOWN
			MQ Q.L @ LOWORD CLICKX !				 // X = LOWORD(lParam)
			MQ Q.L @ HIWORD CLICKY !				 // Y = HIWORD(lParam)
			1 HASCLICK !
			MQ Q.H @ 0 1 InvalidateRect DROP		 // hwnd, NULL, TRUE
			0
		ENDOF

		512 OF 0 ENDOF								 // WM_MOUSEMOVE: пока едим
		// default: DefWindowProc, результат ПОД селектором - ENDCASE
		// скомпилированный DROP снимет селектор, результат уйдёт в Windows
		MQ Q.H @ MQ Q.M @ MQ Q.W @ MQ Q.L @ DefWindowProc SWAP
	ENDCASE ;

// CreateWindowExA руками: 12 параметров через стек возвратов (CALL_A).
// ВНИМАНИЕ: stdcall - Windows сама снимает аргументы с машинного стека
// (ret 48 внутри CreateWindowExA), наши копии НЕ снимаем (RDROP не нужен -
// иначе съедаются 48 байт чужого фрейма и процесс молча уходит в main).
: CWIN12 ( exSt class title style x y w h parent menu inst param -- hwnd )
	>R >R >R >R >R >R >R >R >R >R >R >R
	XCW CALL_A DROP ;

// Зарегистрировать класс и создать окно (HW), показать.
// pfn - адрес оконной процедуры: thunk от MK-WINAPI-CB (настоящий
// Windows-колбэк в Форт) или 15 COMMONADR@ (D-функция wndProcD).
: WINOPEN ( pfn -- )
	/WC		   WC F.SZ !
	0  WC F.style !
	WC F.PR !						   // lpfnWndProc = заданный вызывающим
	0 WC F.CX !	 0 WC F.WX !
	HINST	  WC F.HI !
	0 WC F.IC !
	0 32512 LoadCursor WC F.CU !	   // IDC_ARROW
	0 GetStockObject  WC F.BR !		   // WHITE_BRUSH (1 параметр!)
	0 WC F.MU !
	CLSNAME	  WC F.CL !
	0 WC F.SM !
	WC RegisterClassEx 0= IF ." RegisterClassEx failed" CR EXIT THEN
	// CreateWindowExA(exSt, class, title, style, x, y, w, h, parent, menu, inst, param)
	// центрируем окно на экране (0,0 может быть вне видимой области)
	0 CLSNAME TITLE WS_мойСтиль  // exSt class title style
	0 GetSystemMetrics 320 - 2 /	   // x = (CXSCREEN-320)/2
	1 GetSystemMetrics 200 - 2 /	   // y = (CYSCREEN-200)/2
	320 200 0 0 HINST 0 CWIN12
	DUP HW ! 0= IF ." CreateWindowEx failed" CR EXIT THEN  // 0= съела копию hwnd
	HW @ 1 ShowWindow DROP
	HW @ UpdateWindow DROP ;

// Цикл сообщений. GetMessageA=0 (WM_QUIT) - выход. После DispatchMessage
// проверяем флаг WQUIT (WPH перехватывает WM_CLOSE/WM_DESTROY и сама НЕ
// зовет DestroyWindow/PostQuitMessage) и постим выход сами. Внешний код
// после PUMP обязан сделать DestroyWindow (так делают WIN/WIN2/WTEST).
: PUMP ( -- )
	BEGIN MSG 0 0 0 GetMessageA			 // 0 = WM_QUIT
		DUP 0< IF DROP ." GetMessageA error " MSG M.H @ . CR EXIT THEN // -1 = ошибка: иначе цикл съест стек
		0= IF EXIT THEN
		MSG TranslateMessage DROP	// слово _-Call" уже сняло дубль: результат
		MSG DispatchMessageA DROP	// снимаем явным DROP - итого void
		WQUIT @ IF 0 PostQuitMessage DROP THEN 0 UNTIL ;

// Живой режим: окно до крестика. WndProc - D-функция wndProcD (самый
// безопасный путь: обычный легальный WndProc без заходов в Форт).
: WIN ( -- ) 15 COMMONADR@ WINOPEN
	." vis=" HW @ IsWindowVisible . ." iconic=" HW @ IsIconic .
	HW @ PSPAD GetWindowRect DROP
	." rect=" PSPAD @ . PSPAD 4 + @ . PSPAD 8 + @ . PSPAD 12 + @ . CR
	PUMP HW @ DestroyWindow DROP ." Window closed" CR ;

// Автотест без мыши: WndProc - thunk на WPH (настоящий Windows-колбэк в
// Форт через cbBridge). WM_DESTROY синхронно гоняет весь путь
// SendMessageA -> Windows -> thunk -> cbBridge -> WPH, затем posted
// WM_QUIT завершает PUMP. Если мост сломан - WTEST зависнет или упадёт.
// Thunk изготавливается при загрузке (интерпретация): слово ' здесь не
// immediate и внутри определения читает входной поток на исполнении.
' WPH 4 MK-WINAPI-CB CONST WTHUNK
: WTEST ( -- )
	WTHUNK WINOPEN
	HW @ 2 0 0 SendMessageA DROP	 // WM_DESTROY
	0 PostQuitMessage DROP PUMP
	HW @ DestroyWindow DROP
	." WTEST OK" CR ;

// Живой режим Форт-окна: WndProc - thunk от MK-WINAPI-CB на WPH, т.е.
// настоящий Windows-колбэк, исполняющий Форт-слово через cbBridge.
// Окно живёт до крестика (WM_CLOSE -> WQUIT -> PostQuitMessage в PUMP).
// Отличие от WIN: там WndProc - D-функция wndProcD (15 COMMONADR@),
// здесь обработка сообщений целиком на Форте. Блокирует до закрытия окна.
: WIN2 ( -- )
	WTHUNK WINOPEN
	." vis=" HW @ IsWindowVisible . ." iconic=" HW @ IsIconic .
	HW @ PSPAD GetWindowRect DROP
	." rect=" PSPAD @ . PSPAD 4 + @ . PSPAD 8 + @ . PSPAD 12 + @ . CR
	PUMP HW @ DestroyWindow DROP ;


// Window and exit from app
: myTest WIN2 CR CR ." Stack == " .S CR	BYE ;
myTest

__EOF__
// Это комментарий 
: WPH ( hwnd msg wparam lparam -- result )
	MQ Q.L ! MQ Q.W ! MQ Q.M ! MQ Q.H !
	MQ Q.M @ 2 = MQ Q.M @ 16 = OR		  // ( isDestroyOrClose ), MQ.M читается заново - без хранения msg на стеке
	IF 1 WQUIT ! 0						  // WM_DESTROY/WM_CLOSE -> флаг выхода
	ELSE MQ Q.M @ 15 = IF				  // WM_PAINT
		MQ Q.H @ PSPAD BeginPaint WDRAW	  // рисуем по HDC от BeginPaint
		MQ Q.H @ PSPAD EndPaint DROP 0	  // EndPaint валидирует регион
	ELSE MQ Q.H @ MQ Q.M @ MQ Q.W @ MQ Q.L @ DefWindowProc
	THEN THEN ;
