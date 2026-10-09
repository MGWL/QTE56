// Written in the D programming language. Мохов Геннадий Владимирович 2015
// Версия v1.0 - 30.04.15 10:45
// Попытка перенести на asm D форт реализацию >SPF-Fork 2005-2013 mOleg mOlegg@ya.ru
/**
 * <b><u>SPF-Fork 2005-2013 mOleg mOlegg@ya.ru для D.</u></b>
 */

// dmd -m32 forth.d console_forth.d -ofconsole_forth.exe

// initForth() - инициализировать Форт
// evalForth(string str) - выполнить строку как строку Форта
// (загрузка файлов Форта - на стороне хоста: читать файл и скармливать
//  строки в evalForth; слова INCLUDED и функции includedForth из ядра убраны)
// pp asr = getCommonAdr(int n) - Вернуть из общей таблицы (ячейка n) значение
// setCommonAdr(int n, pp adr) - Записать в ячейку общей таблицы n значение равное adr
// adrContext() - Указатель на adr[256] со списками слов
// extern (C) pp executeForth(pp adrexec, uint kolPar, ...) {

// История изменений
// 28.06.15 - BMOVE Копировать байты
// 05.07.15 - Пропускать в поиске слова из одних цифр
// 06.07.15 - Добавил DDUP
// 10.04.16 - Исправлена ошибка в EXECUTEFROMD

module forth;

// Два варианта сборки ядра:
//   консольный (по умолчанию) - весь вывод в консоль работает;
//   GUI: dmd -version=ForthNoConsole - слова с выводом в консоль получают
//   заглушки (выполняются, но ничего не выводят), ядро не тянет консольный CRT.
version(ForthNoConsole) {
    // GUI-вариант: консольный CRT не импортируется вовсе
} else {
    import std.stdio;
    import core.stdc.stdio: printf;
}
import std.conv;
// import std.c.stdio;

// Сюда executeForth складывает результат Форт-слова из asm-блока.
// Локальную переменную использовать нельзя: в момент выхода из Форт-кода
// EBP ещё указывает на стек данных Форта (локали адресуются через EBP),
// а модульная переменная адресуется абсолютно.
private
__gshared pp gExecuteRet;

// Код последнего THROW (0 = не было). evalForth проверяет после выполнения строки
// и делает "тёплый" сброс стеков.
private
__gshared int gThrowCode;
// Признак успешного разбора числа словом number() (читается из asm h_NUMBER)
private
__gshared int gNumberOk;
// Пустое значение указателя стека данных (запоминается в initForth)
private
__gshared pp gResetEBP;
// Цепочка CATCH: gCatchHandler = ESP фрейма верхнего CATCH (0 = нет активного CATCH)
private
__gshared pp gCatchHandler;
// Чекпойнт границы D<->Форт для THROW без CATCH: ESP и адрес продолжения
// (записываются при входе в evalForth/executeFromD, ближайший по стеку = правильный)
private
__gshared pp gEvalESP;
private
__gshared pp gEvalResume;

alias void* p;    // Просто указатель
alias void** pp;  // Указатель на указатель
alias ubyte* pb;  // Указатель на байт
alias char* ps;   // Указатель на char

// Стеки и кодофайл выделены в хипе и не пересекаются
private
const CELL = 4;
private
const sizeCodeFile = 40960;  // Количество CELL для кодофайла (40960*4 = 160 Кбайт)
private
const sizeStack = 1000;  // Количество CELL для стеков

// Таблица общих для F и D адресов. В неё можно помещать адреса переменных или функций.
// Контроля над тем, что лежит нет!
private
pp[100] commonTable;

// Выдать адрес context из структуры forth
void* adrContext() { return gpcb.context; }
// Выдать адрес начала стека SD
void* adr_cSD() { return gpcb.csd; }
// Выдать адрес сохраненого стека SP
void* adr_SD() { return gpcb.saveEBP; }

// Выдать адрес начала кодофайла
void* adr_begKDF() { return gpcb.akdf; }
// Выдать адрес HERE
void* adr_here() { return gpcb.here; }
// Выдать адрес конца кодофайла
void* adr_endKDF() { return gpcb.akdf + sizeCodeFile; }

// Контекст Fotrh процесса
private
struct NPcb {
    pp csd;     // указатель на начало стека SD
    pp csr;     // указатель на начало стека SR
    pp csc;     // указатель на начало стека SC
    pp akdf;    // указатель на начало кодофайла
    pb here;    // указатель начала свободной области кодофайла
    pp latest;  // указатель на аоследнее скомпилированное слово
    pp context;  // указатель на массив из 256 cell в каждой ячейке context на эту букву
    pp executeFromD;  // ' EXECUTEFROMD
    pp state;         // текущее состояние компиляции 0=интерпретация
    pp base;          // текущая система счисления для NUMBER (по умолчанию 10)
    byte imm;         // запомнить состояние IMM в последнем FIND

    pp adrCommonTable;  // адрес общий таблицы

    ps In;      // указатель на место интерпретации в вход. буфеpе
    ps Tib;     // указатель на сам входной буфеp
    int dlTib;  // Размер строки прочитанной в Tib
    // Регистры сохранения состояния
    pp saveEBP;  // Место под EBP форта
    pp saveEAX;  // Место под EAX форта
    pp saveESI;  // Место под ESI форта
    pp saveEDI;  // Место под EDI форта
}

/* private */ __gshared NPcb
    gpcb;  // Глобальное определение блока управления (нужен __gshared для прямого доступа из asm)
private
pb kdf;  // Сюда будем компилировать код
private
pp stSD, stSR, stSL;  // Указатели на стеки

private
ubyte[2048] tib;  // Буфер строки для иекстового разбора

// Распечатать дамп памяти для указанного адреса
/*
void dumpAdr(pp adr) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
    import std.stdio:writefln;
    ubyte* uk = cast(ubyte*) adr;
    ubyte* ur;
    for (int i; i != 5; i++) {
        ur = uk + (10 * i);
        writefln("[%10s]  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X", cast(void*) ur, *(cast(pb) ur + 0),
                 *(cast(pb) ur + 1), *(cast(pb) ur + 2), *(cast(pb) ur + 3), *(cast(pb) ur + 4), *(cast(pb) ur + 5),
                 *(cast(pb) ur + 6), *(cast(pb) ur + 7), *(cast(pb) ur + 8), *(cast(pb) ur + 9));
        writefln("[%10s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]", "--->",
                 *(cast(ps) ur + 0), *(cast(ps) ur + 1), *(cast(ps) ur + 2), *(cast(ps) ur + 3), *(cast(ps) ur + 4),
                 *(cast(ps) ur + 5), *(cast(ps) ur + 6), *(cast(ps) ur + 7), *(cast(ps) ur + 8), *(cast(ps) ur + 9));
    }
    }
}
*/
void dumpAdr(pp adr) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        import std.stdio: writefln;
        try {
            ubyte* uk = cast(ubyte*) adr;
            ubyte* ur;
            for (int i; i != 5; i++) {
                ur = uk + (10 * i);
                writefln("[%10s]  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X",
                         cast(void*) ur,
                         *(cast(pb) ur + 0),
                         *(cast(pb) ur + 1),
                         *(cast(pb) ur + 2),
                         *(cast(pb) ur + 3),
                         *(cast(pb) ur + 4),
                         *(cast(pb) ur + 5),
                         *(cast(pb) ur + 6),
                         *(cast(pb) ur + 7),
                         *(cast(pb) ur + 8),
                         *(cast(pb) ur + 9));
                writefln("[%10s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]",
                         "--->",
                         *(cast(ps) ur + 0),
                         *(cast(ps) ur + 1),
                         *(cast(ps) ur + 2),
                         *(cast(ps) ur + 3),
                         *(cast(ps) ur + 4),
                         *(cast(ps) ur + 5),
                         *(cast(ps) ur + 6),
                         *(cast(ps) ur + 7),
                         *(cast(ps) ur + 8),
                         *(cast(ps) ur + 9));
            }
        } catch (Throwable e) {
            writefln("?");
        }
    }
}

// ======================== defkern.f ========================

// 01-02-2008 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// Сравнение.
// CODE = ( A B --> T/F )
private
void f_RAWNO() {
    asm {		naked;
		xor EAX,dword ptr SS:[EBP];
		sub EAX, 1;
		sbb EAX,EAX;
		lea EBP,[EBP+CELL];
		ret;
    }
}
// Сравнение.
// CODE <> ( A B --> T/F )
private
void f_NRAWNO() {
    asm {		naked;
		xor EAX,dword ptr SS:[EBP];
		neg EAX;
		sbb EAX,EAX;
		lea EBP,[EBP+CELL];
		ret;
    }
}
// Сравнение.
// CODE < ( A B --> T/F )
private
void f_MENSHE() {
    asm {		naked;
		cmp EAX,dword ptr SS:[EBP];
		setle AL;
		and EAX, 1;
		dec EAX;
		lea EBP,[EBP+CELL];
		ret;
    }
}
// Сравнение.
// CODE > ( A B --> T/F )
private
void f_BOLSHE() {
    asm {		naked;
		cmp EAX,dword ptr SS:[EBP];
		setge AL;
		and EAX, 1;
		dec EAX;
		lea EBP,[EBP+CELL];
		ret;
    }
}
// ничего не делать.
// CODE NOOP ( --> )
private
void f_NOOP() {
    asm {		naked;
		ret;
    }
}
//  выполнить слова, представленного своим исполнимым адресом xt v
// CODE EXECUTE ( xt --> )
private
void f_EXECUTE() {
    asm {		naked;
		mov EBX, EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp EBX;
    }
}
// CODE CATCH ( xt -- exc# | 0 )  исполнить xt, перехватывая THROW.
// Фрейм из 3 ячеек на стеке возвратов: [savedEBP][savedESI][old HANDLER].
// Нормальный возврат xt: снять фрейм, положить 0 (успех) поверх результатов xt.
// THROW (f_THROW) разматывает вызовы до фрейма, сам исполняет тот же эпилог
// (адрес resume хранить не нужно - [ESP] после снятия фрейма = ret-адрес
// вызова слова CATCH) и делает ret прямо к вызывавшему CATCH с exc# в EAX.
private
void h_CATCH() {
    asm {	naked;
		mov EBX, EAX;  // xt
		mov EAX, dword ptr SS:[EBP];  // старый TOS
		lea EBP, [EBP+CELL];  // снять xt
		lea ESP, [ESP-CELL*3];
		mov [ESP], EBP;  // savedEBP (глубина без xt)
		mov [ESP+CELL], ESI;  // savedESI
		mov EDX, gCatchHandler;
		mov [ESP+CELL*2], EDX;  // old HANDLER
		mov gCatchHandler, ESP;
		call EBX;  // xt; ret-адрес = следующая инструкция
		// нормальное возвращение xt
		mov EDX, [ESP+CELL*2];  // old HANDLER
		mov gCatchHandler, EDX;
		lea ESP, [ESP+CELL*3];  // снять фрейм
		lea EBP, [EBP-CELL];  // сохранить результат xt (бывший TOS)
		mov [EBP], EAX;
		xor EAX, EAX;  // exc# = 0 (успех)
		ret;
    }
}
// выполнить слово, адрес которого хранится в ячейке памяти addr v
// то есть A@ EXECUTE
// CODE PERFORM ( addr --> )
// выполнить слово, адрес которого хранится в ячейке памяти addr √
// то есть A@ EXECUTE
private
void f_PERFORM() {
    asm {		naked;
		mov EBX,dword ptr DS:[EAX];
		mov EAX,dword ptr SS:[EBP];
		lea EBP, [EBP+CELL];
		jmp EBX;
    }
}
// безусловный переход на адрес без возможности возврата за точку JMP
// аналог  RDROP >R EXIT
// CODE JUMP ( addr --> )
private
void f_JUMP() {
    asm {		naked;
		mov dword ptr [ESP],EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// закончить выполнение текущего слова
// CODE EXIT ( --> )
private
void f_EXIT() {
    asm {		naked;
		pop EDX;
		ret;
    }
}
// выйти из текущего слова, если флаг отличен от нуля v
// CODE ?EXIT ( flag --> )
private
void f_Q_EXIT() {
    asm {		naked;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jz M1;
		pop EDX;  // снять адрес возврата = EXIT из текущего слова
M1:		
		ret;
    }
}
// выбор нужного варианта из списка v
// CODE (switch) ( n --> ) unfeasible
private
void f_s_switch_s() {
    asm {		naked;
		pop EBX;
		mov ECX,dword ptr DS:[EBX];
		lea EDX,[EBX+ECX+CELL];
		push EDX;
		lea EAX,[EAX*4+CELL];
		cmp ECX,EAX;
		jbe M2;
		lea EBX,[EBX+EAX+CELL];
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp [EBX];
M2:		lea EBX,[EBX+CELL];
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp [EBX];
    }
}
// вернуть значение литерала скомпилированного в коде за (LIT)
// CODE (LIT) ( r: addr --> d: n ) unfeasible
private
void h_s_LIT_s() {
    asm {		naked;
		pop EBX;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		mov EAX,dword ptr DS:[EBX];
		lea EBX,[EBX+CELL];
		jmp EBX;
    }
}
// вернуть значение литерала двойной длины скомпилированного в коде за (DLIT)
// CODE (DLIT) ( r: addr --> d ) unfeasible
private
void f_s_DLIT_s() {
    asm {		naked;
		pop EBX;
		lea EBP,[EBP-CELL*2];
		mov dword ptr SS:[EBP+CELL],EAX;
		mov EDX,dword ptr DS:[EBX+CELL];
		mov EAX,dword ptr DS:[EBX];
		lea EBX,[EBX+CELL*2];
		mov dword ptr SS:[EBP],EDX;
		jmp EBX;
    }
}
// выполнить переход на адрес, значение которого содержится в коде за (BRANCH)
// CODE BRANCH ( r: addr --> ) unfeasible
private
void f_BRANCH() {
    asm {		naked;
		pop EBX;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
    }
}
// условное ветвление по false, флаговое значение не удаляется
// адрес перехода хранится в коде следом за *BRANCH
// CODE *BRANCH ( r: addr d: flag --> flag ) unfeasible
private
void f_Z_BRANCH() {
    asm {		naked;
		pop EBX;
		or EAX,EAX;
		jnz M3;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M3:		lea EBX,[EBX+CELL];
		jmp EBX;
    }
}
// условное ветвление, если флаговое значение меньше нуля
// флаговое значение не удаляется с вершины стека данных
// адрес перехода хранится в коде следом за -BRANCH
// CODE -BRANCH ( r: addr d: flag --> flag ) unfeasible
private
void f_N_BRANCH() {
    asm {		naked;
		pop EBX;
		cmp EAX,0;
		js M4;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M4:		lea EBX,[EBX+CELL];
		jmp EBX;
    }
}
// условное ветвление, если флаговое значение нуль
// адрес перехода хранится в коде следом за ?BRANCH
// CODE ?BRANCH ( r: addr d: flag --> ) unfeasible
private
void f_ZW_BRANCH() {
    asm {		naked;
		pop EBX;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jnz M5;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M5:		lea EBX,[EBX+CELL];
		jmp EBX;
    }
}
// условное ветвление, если флаговое значение отлично от нуля
// адрес перехода хранится в коде следом за N?BRANCH
// CODE N?BRANCH ( r: addr d: flag --> ) unfeasible
private
void f_N_ZW_BRANCH() {
    asm {		naked;
		pop EBX;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jz M6;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M6:		lea EBX,[EBX+CELL];
		jmp EBX;
    }
}

// ======================== dtc.f ========================

// 01-02-2008 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// вернуть адрес данных, следующих в коде за (CREATE)
// CODE (CREATE) ( r: addr --> addr )
private
void f_s_CREATE_s() {
    asm {		naked;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		pop EAX;
		ret;
    }
}
// извлечь содержимое переменной, находящейся в коде за скомпилированным
// (value) (с неким фиксированным смещением, определяемым # методов),
// вернуть значение на вершину стека данных
// : (value) ( r: addr --> n ) R> [ 2 TOKEN * LIT, ] + @ ;
// CODE (value) ( --> n )
private
void f_s_value_s() {
    asm {		naked;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		pop EBX;
		mov EAX,dword ptr DS:[EBX+10];
		ret;
    }
}
// сохранить значение с вершины стека данных в коде за скомпилированным
// (store) ( с некоторым фиксированным смещением, определяемым # методов)
// : (store) ( r: addr  d: n --> ) R> TOKEN + ! ;
// CODE (store) ( n --> )
private
void f_s_store_s() {
    asm {		naked;
		pop EBX;
		mov dword ptr DS:[EBX+5],EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+4];
		ret;
    }
}
// ======================== token.f ========================
// \ 22.06.2009 ~mOleg
// \ Copyright [C] 2009-2013 mOleg mOlegg@ya.ru
// \ работа со скомпилированными токенами

// 5 CONSTANT CFL    ( --> cfl# )   \ длинна поля кода
private
void f_CFL() {
    asm {		naked;
		call h_DUP;
		mov EAX, 5;
		ret;
    }
}
// ALIAS CFL TOKEN ( --> token# ) \ размер одной ссылки в коде √
private
void f_TOKEN() {
    asm {		naked;
		call h_DUP;
		mov EAX, 5;
		ret;
    }
}
// \ вернуть адрес слова, скомпилированного в коде по указанному адресу
// : TOKEN@ ( addr --> xt ) DUP 1 + REF@ + TOKEN + ;
private
void f_TOKEN_get() {
    asm {		naked;
		call h_DUP;
		call h_s_LIT_s;
		add dword ptr DS:[EAX],EAX;
		add byte ptr DS:[EAX],AL;
		call h_PLUS;
		call h_getFromAdr;
		call h_PLUS;
		call f_TOKEN;
		jmp h_PLUS;
        // ret;
    }
}
// \ заменить значение токена dst на src
// : TOKEN! ( src dst --> ) TUCK TOKEN + - SWAP 1 + REF! ;
private
void f_TOKEN_set() {
    asm {		naked;
		call h_TUCK;
		call f_TOKEN;
		call h_PLUS;
		call h_MINUS;
		call h_SWAP;
		call h_s_LIT_s;
		add dword ptr DS:[EAX],EAX;
		add byte ptr DS:[EAX],AL;
		call h_PLUS;
		jmp h_setToAdr;
        // ret;
    }
}
// ======================== Быстрая арифметика ===============
// 1+  ( A -- A+1 )
private
void h_inc() {
    asm {		naked;
		inc EAX;
		ret;
    }
}
// 1-  ( A -- A-1 )
private
void h_dec() {
    asm {		naked;
		dec EAX;
		ret;
    }
}

// ======================== marks.f ========================

// %  ( A B -- A%B )
private
void h_ZP() {
    asm {		naked;
		mov ECX, EAX;
		mov EAX, [EBP];
		cdq;
		idiv ECX;
		lea EBP,[EBP+CELL];
		mov EAX, EDX;
		ret;
    }
}

// /  ( A B -- A/B )
private
void h_ZD() {
    asm {		naked;
		mov ECX, EAX;
		mov EAX, [EBP];
		cdq;
		idiv ECX;
		lea EBP,[EBP+CELL];
		ret;
    }
}

// *  ( A B -- A*B )
private
void h_ZW() {
    asm {		naked;
		imul dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// +  ( A B -- A+B )
private
void h_PLUS() {
    asm {		naked;
		add EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// -  ( A B -- A-B )
private
void h_MINUS() {
    asm {		naked;
		neg EAX;
		add EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// AND  ( A B -- A&B )
private
void h_AND() {
    asm {		naked;
		and EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// OR  ( A B -- A|B )
private
void h_OR() {
    asm {		naked;
		or EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// XOR  ( A B -- A^B )
private
void h_XOR() {
    asm {		naked;
		xor EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
    }
}
// INVERT  ( A -- ~A )  побитовое НЕ
private
void h_INVERT() {
    asm {		naked;
		not EAX;
		ret;
    }
}
// LSHIFT  ( x1 u -- x2 )  логический сдвиг влево (ANS). u >= 32: x86 берет u mod 32
private
void h_LSHIFT() {
    asm {	naked;
		mov ECX, EAX;  // ECX = u
		mov EAX, dword ptr SS:[EBP];  // x1
		lea EBP, [EBP+CELL];
		shl EAX, CL;
		ret;
    }
}
// RSHIFT  ( x1 u -- x2 )  логический сдвиг вправо, без знака (ANS)
private
void h_RSHIFT() {
    asm {	naked;
		mov ECX, EAX;  // ECX = u
		mov EAX, dword ptr SS:[EBP];  // x1
		lea EBP, [EBP+CELL];
		shr EAX, CL;
		ret;
    }
}
// 2*  ( x1 -- x2 )  сдвиг влево на 1 (ANS). Удвоение без проверки переполнения
private
void h_2MUL() {
    asm {	naked;
		add EAX, EAX;
		ret;
    }
}
// 2/  ( x1 -- x2 )  арифметический сдвиг вправо на 1 (ANS, округление к -inf,
// как у sar: -3 2/ -> -2)
private
void h_2DIV() {
    asm {	naked;
		sar EAX, 1;
		ret;
    }
}
// UM/MOD  ( ud u -- ur uq )  беззнаковое деление двойного числа на одинарное.
// ud на стеке: [EBP+CELL]=младшая часть, [EBP]=старшая, EAX=делитель.
// Внимание: если частное не влезает в 32 бита - аппаратное исключение #DE.
private
void h_UM_MOD() {
    asm {		naked;
		mov ECX, EAX;  // ECX = делитель u
		mov EDX, dword ptr SS:[EBP];  // EDX = старшая часть ud
		mov EAX, dword ptr SS:[EBP+CELL];  // EAX = младшая часть ud
		div ECX;  // EDX:EAX / ECX -> EAX=частное, EDX=остаток
		mov dword ptr SS:[EBP+CELL], EDX;  // остаток ur на место младшей части
		lea EBP, [EBP+CELL];  // стек: ur в памяти, uq в EAX (TOS)
		ret;
    }
}
// Выдать размер ячейки (32 разряда)
// 4 CONSTANT CELL
private
void f_CELL() {
    asm {		naked;
		call h_DUP;
		mov EAX, 4;
		ret;
    }
}
//   ALIAS CELL REF  ( --> const ) \ размер ссылки в байтах
private
void f_REF() {
    asm {		naked;
		call h_DUP;
		mov EAX, 4;
		ret;
    }
}
// \ компилировать ссылку на код
// : REF, ( ref --> ) REF PLACE REF! ;
private
void f_REFzpt() {
    asm {		naked;
		call f_REF;
		call h_PLACE;
		jmp h_setToAdr;
        // ret;
    }
}
// \ !!! часто используется и по сути выдает смещение от текущего
// \ адреса до указанного. Стоит вынести в отдельное слово.
// : atod ( addr --> disp ) HERE REF + - ;
private
void f_atod() {
    asm {		naked;
		call h_HERE;
		call f_REF;
		call h_PLUS;
		jmp  h_MINUS;
        // ret;
    }
}
// \ разрешить ссылку вперед(в коде)
// \ : >resolve ( addr --> ) HERE OVER - REF - SWAP ! ;
private
void f_R_RESOLVE() {
    asm {		naked;
		call h_HERE;
		call h_OVER;
		call h_MINUS;
		call f_REF;
		call h_MINUS;
		call h_SWAP;
		jmp h_setToAdr;
        // ret;
    }
}
// \ разрешить ссылку(в коде, то есть в поле данных команды JMP или CALL) назад
// : <resolve ( addr --> ) atod REF, ;
private
void f_L_resolve() {
    asm {		naked;
		call f_atod;
		jmp  f_REFzpt;
        // ret;
    }
}
// \ запомнить положение для ссылки вперед
// : >MARK ( --> addr ) HERE REF - ;
private
void f_R_MARK() {
    asm {		naked;
		call h_HERE;
		call f_REF;
		jmp h_MINUS;
        // ret;
    }
}
// \ заполнить положение для ссылки назад
// : <MARK ( --> addr ) HERE ;
private
void f_L_MARK() {
    asm {		naked;
		jmp h_HERE;
        // ret;
    }
}
// : <RESOLVE ( addr --> ) HERE - REF, ;
private
void f_L_RESOLVE() {
    asm {		naked;
		call h_HERE;
		call h_MINUS;
		jmp f_REFzpt;
        // ret;
    }
}
// : RESOLVE> ( addr --> ) HERE OVER - SWAP ! ;
private
void f_RESOLVE_R() {
    asm {		naked;
		call h_HERE;
		call h_OVER;
		call h_MINUS;
		call h_SWAP;
		jmp h_setToAdr;
        // ret;
    }
}
// 26-06-2005 ~mOleg
// Copyright [C] 2005-2013 mOleg mOlegg@ya.ru
// стековые манипуляции

// -- стек данных ------------------------------------------------------------

// установить новое значение указателя стека данных
//  SP! ( addr --> )
private
void SP_set() {
    asm {		naked;
    	lea  EBP,	[EAX+CELL];
    	mov  EAX,	[EBP-CELL];
    	ret;
    }
}
// прочесть на вершину стека текущее значение указателя стека данных
// SP@ ( --> addr )
private
void SP_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	EBP;
		ret;
    }
}
// Глубина стека данных (без учёта самого DEPTH)
// DEPTH ( --> n )
// Каждый элемент, включая слот TOS, опускает EBP на CELL от дна gResetEBP:
// пустой стек -> EBP == gResetEBP -> 0; один элемент -> gResetEBP-CELL -> 1
private
void h_DEPTH() {
    asm {	naked;
		mov ECX,	EBP;			// SP до h_DUP
		call h_DUP;					// освободить EAX под результат
		mov EAX,	gResetEBP;
		sub EAX,	ECX;
		sar EAX,	2;				// / CELL (знаково: при underflow < 0)
		ret;
    }
}
//       USER S0 ( --> addr ) \ ячейка хранит адрес дна стека данных

// -- Стек возвратов ---------------------------------------------------------
// установить новое значение указателя стека возвратов
// RP! ( addr --> )
private
void RP_set() {
    asm {		naked;
		pop EBX;  // адрес куда надо вернутся
		mov ESP,	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
    }
}
// прочесть на вершину стека данных текущее значение указателя стека возвратов
// RP@ ( --> addr )
private
void RP_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		lea EAX,	[ESP+CELL];
		ret;
    }
}
//       USER R0   ( --> addr ) \ ячейка хранит адрес дна стека возвратов
// -- локальный стек ------------------------------------------------------------
// установить новое значение указателя стека данных
// LP! ( addr --> )
private
void LP_set() {
    asm {		naked;
		mov ESI,	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// прочесть на вершину стека текущее значение указателя стека данных
// LP@ ( --> addr )
private
void LP_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	ESI;
		ret;
    }
}
//       USER L0   ( --> addr ) \ хранит адрес дна локального стека
// 26-06-2005 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// манипуляция данными на стеке данных - псевдоассемблер

// Продублировать верхнее значение на вершине стека данных.
// DUP ( n --> n n )
private
void h_DUP() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		ret;
    }
}
// Убрать верхнее значение со стека данных.
// DROP ( n --> )
// ВАЖНО: только mov/lea, флаги НЕ меняются - f_inter делает test/cmp ДО
// call h_DROP, а je/jne ПОСЛЕ него. Не заменять lea на add!
private
void h_DROP() {
    asm {		naked;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// поменять местами два верхних элемента стека
// SWAP ( a b --> b a )
private
void h_SWAP() {
    asm {		naked;
		mov EDX,	[EBP];
		mov [EBP],	EAX;
		mov EAX,	EDX;
		ret;
    }
}
// Положить копию x1 на вершину стека.
// OVER ( a b --> a b a )
private
void h_OVER() {
    asm {		naked;
		lea EBP, [EBP-CELL];
		mov dword ptr SS:[EBP],	EAX;
		mov EAX, dword ptr SS:[EBP+CELL];
		ret;
    }
}
// Убрать первый элемент под вершиной стека.
// NIP ( a b --> b )
private
void SP_nip() {
    asm {		naked;
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// Прокрутить три верхних элемента стека.
// ROT ( a b c --> b c a )
private
void SP_rot() {
    asm {		naked;
		mov EDX,	[EBP];
		mov [EBP],	EAX;
		mov EAX,	[EBP+CELL];
		mov [EBP+CELL],	EDX;
		ret;
    }
}
// Прокрутить три верхних элемента стека.
//  -ROT ( a b c --> c a b )
private
void SP_minusrot() {
    asm {		naked;
		mov EDX,	[EBP+CELL];
		mov [EBP+CELL],	EAX;
		mov EAX,	[EBP];
		mov [EBP],	EDX;
		ret;
    }
}
// Положить копию верхнего элемента стека под следующий за ним.
// TUCK ( a b --> b a b )
private
void h_TUCK() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov EDX,	[EBP+CELL];
		mov [EBP+CELL],	EAX;
		mov [EBP],	EDX;
		ret;
    }
}
// Сделать копию верхней пары элементов стека данных
// DDUP ( d --> d d )
private
void SP_ddup() {
    asm {		naked;
		mov EDX,	[EBP];
		mov [EBP-CELL],	EAX;
		mov [EBP-CELL*2],	EDX;
		lea EBP,	[EBP-CELL*2];
		ret;
    }
}
// Убрать со стека пару ячеек x1 x2.
// DDROP ( d --> )
private
void SP_ddrop() {
    asm {		naked;
		mov EAX,	[EBP+CELL];
		lea EBP,	[EBP+CELL*2];
		ret;
    }
}
// Удалить с вершины стека данных три верхних ячейки
// TDROP ( n n n --> )
private
void SP_tdrop() {
    asm {		naked;
		mov EAX,	[EBP+CELL*2];
		lea EBP,	[EBP+CELL*3];
		ret;
    }
}
// Поменять местами две верхние пары ячеек.
// DSWAP ( da db --> db da )
private
void SP_dswap() {
    asm {		naked;
		mov EDX,	[EBP];
		mov EBX,	[EBP+CELL];
		mov ECX,	[EBP+CELL*2];
		mov [EBP+CELL*2],	EDX;
		mov [EBP+CELL],	EAX;
		mov [EBP],	ECX;
		mov EAX,	EBX;
		ret;
    }
}
// 26-06-2005 ~mOleg
// Copyright [C] 2005-2013 mOleg mOlegg@ya.ru
// манипуляция числами на стеке возвратов

// прочесть верхнее значение со стека возвратов
// R@ ( r: n --> r: n d: n )
private
void h_R_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	[ESP+CELL];
		ret;
    }
}
// Удалить одно значение с вершины стека возвратов
// RDROP ( r: n --> )
private
void SR_rdrop() {
    asm {		naked;
		pop EBX;
		pop EDX;
		jmp EBX;
    }
}
// Перенести значение со стека данных на стек возвратов
// >R ( d: n --> r: n )
private
void h_toR() {
    asm {		naked;
		pop EBX;
		push EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
    }
}
// Перенести значение со стека возвратов на стек данных
// R> ( r: n --> d: n )
private
void h_Rto() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		pop EBX;
		pop EAX;
		jmp EBX;
    }
}
// Добавить значение к тому, что лежит на вершине стека возвратов
// R+ ( r: a d: b --> R: a+b )
private
void h_R_PLUS() {
    asm {		naked;
		pop EBX;
		add [ESP],	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
    }
}
// Поместить значение 0 на вершину ст возвратов, вернуть адрес значения
// 0>R' ( --> r: 0 d: RP@ )
private
void SR_SR_0toRadr() {
    asm {		naked;
		mov EBX,	[ESP];
		mov [ESP],	0;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	ESP;
		jmp EBX;
    }
}

// ======================== R2-стек (безопасный >R) ========================
// Фикс бага #6 arPanic.md. Старые >R/R>/R@/R+/RDROP/RP@/RP! работают
// ПОВЕРХ native ESP - это нужно самому ядру: (JOIN) `R> LATEST @`,
// (DOES) `R> R>`, COMPILE `R@ ... R+` и (BOX) `R@ ... R+` читают/двигают
// native адрес возврата, записанный инструкцией CALL (0xE8) в тело слова.
// Из-за этого любой вызов DOES>-слова (поле FIELD, VAR, CONST) между
// пользовательскими >R и R> съедал ячейки пользователя и рвал стек.
//
// НИЖЕ - параллельный стек на регистре EDI, НЕ связанный с ESP.
// Пользовательский код, смешивающий temporaries с DOES>-словами,
// должен использовать >R2/R2>/R2@/R2DROP (а >R/R> не трогать).

// прочесть верхнее значение R2-стека на стек данных
// R2@ ( r: n --> r: n d: n )
private
void h_R2_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	[EDI];
		ret;
    }
}
// снять одно значение с вершины R2-стека
// R2DROP ( r: n --> )
private
void h_R2_drop() {
    asm {		naked;
		lea EDI,	[EDI+CELL];
		ret;
    }
}
// перенести значение со стека данных на R2-стек
// >R2 ( d: n --> r: n )
private
void h_toR2() {
    asm {		naked;
		lea EDI,	[EDI-CELL];
		mov [EDI],	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// перенести значение с R2-стека на стек данных
// R2> ( r: n --> d: n )
private
void h_R2to() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	[EDI];
		lea EDI,	[EDI+CELL];
		ret;
    }
}
// прибавить значение к вершине R2-стека
// R2+ ( r: a d: b --> r: a+b )
private
void h_R2_PLUS() {
    asm {		naked;
		add [EDI],	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// прочесть указатель вершины R2-стека
// RP2@ ( --> addr )
private
void h_RP2_get() {
    asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	EDI;
		ret;
    }
}
// установить указатель вершины R2-стека
// RP2! ( addr --> )
private
void h_RP2_set() {
    asm {		naked;
		mov EDI,	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
    }
}
// D>R2 / DR2> - две ячейки за раз (аналог D>R/DR>, но на R2-стеке)
private
void h_DtoR2() {
    asm {        naked;
		mov EDX,	EAX;              // EDX = x2 (TOS)
		mov ECX,	[EBP];            // ECX = x1 (под TOS)
		lea EDI,	[EDI-CELL*2];
		mov [EDI],	ECX;              // наверх R2: x1
		mov [EDI+CELL],	EDX;        // глубже: x2
		lea EBP,	[EBP+CELL*2];
		mov EAX,	[EBP];
		ret;
    }
}
private
void h_DR2from() {
    asm {        naked;
		mov ECX,	[EDI];            // x1 (наверх R2)
		mov EAX,	[EDI+CELL];       // x2 (глубже)
		lea EDI,	[EDI+CELL*2];
		lea EBP,	[EBP-CELL*2];
		mov [EBP],	ECX;              // x1 — глубже на данных
		ret;                            // EAX = x2 — наверх (TOS)
    }
}
// : q   1 2 >R >R  DR> ;
// : D>R  SWAP >R >R ;  : q1  1 2 D>R DR> ;

// Перенести два значения на стек возвратов со стека данных
// D>R ( D: x1 x2 --> )  R: --> x1 x2
// x2 кладётся на R первой (глубже), x1 — второй (наверх R).
// Зеркало SR_DRfrom: при последующем вызове DR> её ret окажется
// по [ESP], x1 по [ESP+CELL], x2 по [ESP+CELL*2] - так читает DR>.
// D>R ... DR> - тождество. Новый TOS данных = элемент под x1.
// Только push/pop и чтения [EBP]: запись по [ESP+disp] в DMD asm
// не используем (исходный push-паттерн).
private
void SR_DtoR() {
    asm {        naked;
		pop EBX;             // ret
		push EAX;            // x2 - первой (глубже на R)
		mov EAX, [EBP];      // x1 - второй элемент данных
		push EAX;            // x1 - наверх R (DR> прочтёт первым)
		lea EBP, [EBP+CELL*2];  // снять x1 x2 со стека данных
		mov EAX, [EBP];      // новый TOS = элемент под x1
		jmp EBX;
    }
}
// Вернуть два значения со стека возвратов на стек данных
// DR> ( R: x1 x2 --> )  D: --> x1 x2
// x1 (TOS R) кладётся ГЛУБЖЕ, x2 — наверх (TOS)
private
void SR_DRfrom() {
    asm {		naked;
		mov EBX, [ESP];        // ret
		mov EAX, [ESP+CELL*2]; // x2 (TOS)
		mov EDX, [ESP+CELL];   // x1
		lea ESP, [ESP+CELL*3]; // снять ret + x1 + x2
		lea EBP, [EBP-CELL*2]; // освободить 2 ячейки
		mov [EBP], EDX;        // x1 — глубже
		jmp EBX;
    }
}
// Прочитать на вершину стека данных два верхних значения со ст возвратов
// DR@ ( r: d --> r: d d: d )
private
void SR_DRrazm() {
    asm {		naked;
		mov [EBP-CELL],EAX;
		mov EAX, [ESP+CELL];
		mov EDX, [ESP+CELL*2];
		mov [EBP-CELL*2],EDX;
		lea EBP, [EBP-8];
		ret;
    }
}

// локальный стек данных

// прочитать значение с вершины локального стека
// L@ ( l: n --> l: n d: n )
private
void SL_get() {
    asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI];
		ret;
    }
}
// прибавить значение с вершины стека данных, к значению на вершине локального стека
// L+ ( l: a d: b --> l: a+b )
private
void SL_add() {
    asm {		naked;
		add [ESI], EAX;
		mov EAX, [EBP];
		lea EBP, [EBP+CELL];
		ret;
    }
}
// переместить значение на вершину локального стека
// >L ( d: n --> l: n )
private
void SL_toL() {
    asm {		naked;
		lea ESI, [ESI-CELL];
		mov [ESI], EAX;
		mov EAX, [EBP];
		lea EBP, [EBP+CELL];
		ret;
    }
}
// переместить значение с вершины локального стека
// L> ( l: n --> d: n )
private
void SL_Lfrom() {
    asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI];
		lea ESI, [ESI+CELL];
		ret;
    }
}
// дублировать значение на вершине локального стека
// LDUP ( l: n --> l: n n )
private
void SL_Ldup() {
    asm {		naked;
		mov EDX, [ESI];
		lea ESI, [ESI-CELL];
		mov [ESI], EDX;
		ret;
    }
}
// удалить элемент с вершины локального стека
// LDROP ( l: n --> )
private
void SL_Ldrop() {
    asm {		naked;
		lea ESI, [ESI+4];
		ret;
    }
}

// Это объеденённое слово специяльно для замены последовательности:

// было	        evalForth(": LOOP ?COMP <<<COMPILE (LOOP) COMPILE ?BRANCH>>> <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");
// оптимизация	evalForth(": LOOP ?COMP <<<COMPILE (LOOP?BRANCH)>>> <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");
 
//

// Увеличить индекс и сразу выполнить ветвление.
//
// Inline-ячейка после CALL содержит смещение относительно собственного адреса:
//   продолжение: addr += [addr]
//   выход:       addr += CELL
//
// Стек данных не изменяется.
private void f_s_LOOP_BRANCH_s()
{
    asm {
        naked;

        pop EBX;                       // адрес inline-смещения

        mov EDX, [ESI];                // индекс
        inc EDX;
        mov [ESI], EDX;                // на выходе значение сразу удалится
        cmp EDX, [ESI + CELL];         // индекс >= предел?
        jge loop_exit;

        // FALSE: продолжить цикл.
        add EBX, [EBX];                // адрес ячейки + относительное смещение
        jmp EBX;

    loop_exit:
        lea ESI, [ESI + CELL * 2];     // удалить индекс и предел
        lea EBX, [EBX + CELL];         // пропустить inline-смещение
        jmp EBX;
    }
}

// Увеличить индекс и сразу выполнить ветвление.
//
private void f_s_PLOOP_BRANCH_s()
{
    asm {
        naked;

        pop EBX;                       // адрес inline-смещения

        mov EDX, [ESI];                // текущий индекс
        add EDX, EAX;                  // новый индекс = index + step

        // Проверяем знак шага, пока он ещё находится в EAX.
        test EAX, EAX;

        // Удаляем шаг со стека данных.
        // MOV и LEA не изменяют флаги, установленные TEST.
        mov EAX, [EBP];                // восстановить предыдущий TOS
        lea EBP, [EBP + CELL];

        js negative_step_logic;

    positive_step_logic:
        cmp EDX, [ESI + CELL];         // new_index >= limit?
        jge exit_loop;

    continue_loop:
        mov [ESI], EDX;                // сохранить новый индекс
        add EBX, [EBX];                // перейти к началу тела
        jmp EBX;

    negative_step_logic:
        cmp EDX, [ESI + CELL];         // new_index <= limit?
        jl  exit_loop;                 // выход только после перехода ниже предела
        jmp continue_loop;

    exit_loop:
        lea ESI, [ESI + CELL * 2];     // снять index и limit
        lea EBX, [EBX + CELL];         // пропустить inline-смещение
        jmp EBX;
    }
}
// Продвинуть индекс счётного цикла и выдать флаг для ?BRANCH.
// (LOOP) ( --> flag )   FALSE(0) = продолжать цикл, TRUE(-1) = выйти
// L-стек: [ESI]=индекс, [ESI+CELL]=предел.
// Asm-версия бывшего шитого слова:
// : (LOOP) L> 1+ L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;

// Идея: хранить индекс и предел в регистрах,
// флаг возврата — в EAX (TOS), а не выделять ячейку в памяти.
/*  GifaChat ----------
private void f_s_LOOP_s() {
    asm { naked;
        push EBX;           // Сохраняем регистр, если ABI требует сохранности
        
        mov EBX, [ESI];     // Индекс -> EBX
        mov ECX, [ESI+CELL]; // Предел -> ECX
        
        inc EBX;            // Новый индекс
        cmp EBX, ECX;
        jge loop_exit;      // index >= limit ?

        // --- Продолжаем цикл ---
        mov [ESI], EBX;     // Обновляем только индекс. Предел остается на месте.
        pop EBX;
        xor EAX, EAX;       // FALSE (0)
        ret;

    loop_exit:
        // --- Выход из цикла ---
        add ESI, CELL*2;    // Корректно снимаем обе ячейки со стека возвратов
        pop EBX;
        mov EAX, -1;        // TRUE (-1)
        ret;
    }
}
*/
private
void f_s_LOOP_s() {
    asm {		naked;
		mov EDX, [ESI];  // индекс
		inc EDX;  // индекс+1
		cmp EDX, [ESI+CELL];  // сравнить с пределом (знаково, как < в ядре)
		jge loopex;  // индекс+1 >= предела -> выход
		mov [ESI], EDX;  // записать индекс обратно (предел не тронут)
		lea EBP, [EBP-CELL];  // положить флаг, сохранив старый TOS
		mov [EBP], EAX;
		xor EAX, EAX;  // FALSE = продолжать
		ret;
	loopex:
		lea ESI, [ESI+CELL*2];  // снять индекс и предел с L-стека
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, -1;  // TRUE = выход
		ret;
    }
}

// Положить параметры цикла на L-стек: (DO) ( предел индекс --> )
// Итоговая раскладка L-стека: [ESI]=индекс, [ESI+CELL]=предел.
// Asm-версия бывшего шитого слова:  : (DO) SWAP >L >L ;
private
void f_s_DO_s() {
    asm {		naked;
		mov EDX, [EBP];  // предел (под TOS)
		lea ESI, [ESI-CELL];
		mov [ESI], EDX;  // предел на L-стек
		lea ESI, [ESI-CELL];
		mov [ESI], EAX;  // индекс на L-стек (вершина)
		mov EAX, [EBP+CELL];  // восстановить TOS из памяти
		lea EBP, [EBP+CELL*2];  // снять предел и индекс со стека данных
		ret;
    }
}

// Рантайм ?DO: если предел = индекс - НЕ входить в цикл (нуль итераций).
// (?DO) ( предел индекс -- flag )  flag: FALSE(0) = пропустить тело (?BRANCH
// уводит за цикл), TRUE(-1) = войти. При входе кладёт пару на L-стек ровно
// как (DO) - (LOOP)/(LEAVE) не отличают DO от ?DO. Пропуск-прыжок связан
// в цепочку LVCHAIN и резолвится LOOP/+LOOP вместе с LEAVE (адрес тот же).
private
void f_s_QDO_s() {
    asm {		naked;
		cmp EAX, [EBP];  // индекс (TOS) vs предел
		jne qdo_go;
		// равны: снять пару, флаг FALSE = ?BRANCH уйдёт за цикл.
		// Под флаг кладём обратно прежний TOS - ?BRANCH флаг потребляет
		// (как (LOOP) на ветке выхода), без этого стек ушёл бы в минус.
		mov EDX, [EBP+CELL];  // старый TOS (до сдвига EBP!)
		lea EBP, [EBP+CELL*2];  // снять предел и индекс
		lea EBP, [EBP-CELL];  // ячейка под флаг
		mov [EBP], EDX;  // вернуть старый TOS в память
		xor EAX, EAX;  // FALSE = пропустить тело
		ret;
	qdo_go:
		mov EDX, [EBP+CELL];  // старый TOS (под парой)
		mov ECX, [EBP];  // предел (под TOS)
		lea ESI, [ESI-CELL];
		mov [ESI], ECX;  // предел на L-стек
		lea ESI, [ESI-CELL];
		mov [ESI], EAX;  // индекс на L-стек (вершина)
		lea EBP, [EBP+CELL*2];  // снять предел и индекс
		lea EBP, [EBP-CELL];  // ячейка под флаг
		mov [EBP], EDX;  // вернуть старый TOS
		mov EAX, -1;  // TRUE = войти в тело (?BRANCH не берёт ветку)
		ret;
    }
}

// Досрочный выход из цикла: снять индекс и предел с L-стека.
// (LEAVE) ( --> )  l: индекс предел -->
// Прыжок за тело цикла делает скомпилированный следом BRANCH (цепочка
// резолвится словом LOOP/+LOOP). Баланс L-стека: обе ветки выхода
// (естественная через (LOOP) и досрочная) снимают ровно одну пару.
// Asm-версия: : (LEAVE) LDROP LDROP ;
private
void f_s_LEAVE_s() {
    asm {		naked;
		lea ESI, [ESI+CELL*2];  // снять индекс и предел с L-стека
		ret;
    }
}

// Продвинуть индекс цикла на n и выдать флаг для ?BRANCH.
// (+LOOP) ( n --> flag )   FALSE(0) = продолжать, TRUE(-1) = выйти
// Стек данных по глубине не меняется: шаг n заменяется флагом.
// ВНИМАНИЕ: знаковое сравнение индекс>=предел, как и в бывшей шитой версии
// (цикл с отрицательным шагом завершается после первой итерации).
// Asm-версия: : (+LOOP) L> + L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;
private
void f_s_PLOOP_s() {
    asm {		naked;
		mov EDX, [ESI];  // индекс
		add EDX, EAX;  // индекс+шаг
		cmp EDX, [ESI+CELL];  // сравнить с пределом (знаково)
		jge ploopex;  // индекс+шаг >= предела -> выход
		mov [ESI], EDX;  // записать индекс обратно
		xor EAX, EAX;  // FALSE = продолжать
		ret;
	ploopex:
		lea ESI, [ESI+CELL*2];  // снять индекс и предел с L-стека
		mov EAX, -1;  // TRUE = выход
		ret;
    }
}

// Индекс текущего цикла:  I ( --> n )   читает [ESI]
// Asm-версия бывшего шитого слова:  : I L@ ;
private
void h_I() {
    asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI];
		ret;
    }
}

// Индекс внешнего цикла:  J ( --> n )   читает [ESI+CELL*2]
// (у внешнего цикла своя пара индекс/предел выше по L-стеку)
private
void h_J() {
    asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI+CELL*2];
		ret;
    }
}

// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// Записать значение по адресу
// ! ( x a-addr --> )
private
void h_setToAdr() {
    asm {		naked;
		mov EDX, dword ptr SS:[EBP];
		mov dword ptr DS:[EAX], EDX;
		mov EAX, dword ptr SS:[EBP+CELL];
		lea EBP, [EBP+CELL*2];
		ret;
    }
}
// Прибавить значение к ячейке
// +! ( n a-addr --> )  a-addr @ + a-addr !
private
void h_addToAdr() {
    asm {	naked;
		mov EDX, dword ptr SS:[EBP];  // n
		add dword ptr DS:[EAX], EDX;  // [a-addr] += n
		mov EAX, dword ptr SS:[EBP+CELL];  // TOS = под парой
		lea EBP, [EBP+CELL*2];
		ret;
    }
}
// Увеличить ячейку на 1
// 1+! ( a-addr --> )
private
void h_incToAdr() {
    asm {	naked;
		inc dword ptr DS:[EAX];
		mov EAX, dword ptr SS:[EBP];
		lea EBP, [EBP+CELL];
		ret;
    }
}
// Уменьшить ячейку на 1
// 1-! ( a-addr --> )
private
void h_decToAdr() {
    asm {	naked;
		dec dword ptr DS:[EAX];
		mov EAX, dword ptr SS:[EBP];
		lea EBP, [EBP+CELL];
		ret;
    }
}
// Прочитать значение по адресу
// @ ( a-addr --> x )
private
void h_getFromAdr() {
    asm {		naked;
		mov EAX,  DS:[EAX];
		ret;
    }
}
// Получить byte по адресу c-addr.
// Незначащие старшие биты ячейки нулевые.
// B@ ( c-addr --> byte )
private
void h_getFromAdrByte() {
    asm {		naked;
		movzx EAX, byte ptr DS:[EAX];
		ret;
    }
}
// Записать byte по адресу a-addr.
// CODE B! ( byte c-addr --> )
private
void h_setToAdrByte() {
    asm {		naked;
		mov EDX,  SS:[EBP];
		mov byte ptr DS:[EAX],DL;
		mov EAX, dword ptr SS:[EBP+CELL];
		lea EBP,[EBP+CELL*2];
		ret;
    }
}
// Забить u байт, начиная с addr, символом char.
// CODE FILL ( addr u char --> )
// EAX=char (TOS), [EBP]=u, [EBP+CELL]=addr. ECX/EDX - scratch (как в UM/MOD).
private
void h_FILL() {
    asm {	naked;
		mov ECX, EAX;                  // CL = char
		mov EDX, dword ptr SS:[EBP];   // EDX = u (счётчик)
		mov EAX, dword ptr SS:[EBP+CELL];  // EAX = addr (бегущий указатель)
		test EDX, EDX;
		jz FILL_END;
	FILL_LOOP:
		mov byte ptr DS:[EAX], CL;
		inc EAX;
		dec EDX;
		jnz FILL_LOOP;
	FILL_END:
		mov EAX, dword ptr SS:[EBP+CELL*2];  // новый TOS = ячейка под addr и u (как в B!, +1 ячейка)
		lea EBP, [EBP+CELL*3];             // снять addr и u (char был в EAX)
		ret;
    }
}

// ======================== Проверочные слова =======================

// Проверим передачу 3 параметров
private
void t9(int a, int b, int c) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        writeln();
        writeln("~~~~> ", "3 param ", a, "  ", b, "  ", c);
    }
}
private
void exec_D() {
    asm {		naked;
        // mov EAX, 7;		call t1;  // t1(7);
		call h_DUP;
		push 2;
		push 3;
		mov EAX, 4;
        // mov EAX, 4;
		lea ECX, t9;
		call ECX;
        // call t9;
		call h_DROP;
		ret;
    }
}


// Снимок контекста ФВМ на момент внешнего вызова (для cbBridge).
// Заполняется callD/callD2 непосредственно перед внешним call: входные
// EBP/ESI/EDI мосту недоступны - между входом внешней функции и вызовом
// thunk'а там может быть кадр enter/leave или рабочие значения; ABI
// гарантирует восстановление callee-saved регистров лишь к ВОЗВРАТУ.
private __gshared pp gCbSaveEBP, gCbSaveESI, gCbSaveEDI;

// callD2 ("CALLB") - УПРОЩЁННЫЙ шлюз вызова по адресу без танцев callD
// (pop/SL_toL/h_DUP/SL_Lfrom/push). Контракт тот же, что у CALL_A: результат
// в EAX, +1 мусорная ячейка под ним (вызывающий делает DROP). Нужен для
// вызовов ВНУТРИ Windows-колбэка: там полный callD умирает (см.
// support_forth.md, раздел про окно), а прямой call - живёт (как d_emit).
private
void callD2() {
    asm {		naked;
		mov ECX, EAX;  // Адрес функции, для вызова CALL
		pop EAX;  // Забираем адрес возврата из callD
		call SL_toL;  // Прячем его во временный стек
		call h_DUP;
		mov [gCbSaveEBP], EBP;  // снимок контекста ФВМ для cbBridge
		mov [gCbSaveESI], ESI;
		mov [gCbSaveEDI], EDI;
		call ECX;  // Вызов функции по адресу
		mov ECX, EAX;  // Сохраним Return
		call SL_Lfrom;  // Вернем с доп стека в EAX адрес возврата из callD
		push EAX;  // Вернем его на место
		mov EAX, ECX;
		ret;
    }
}

// ======================== Мост callback'ов (cbBridge) ========================
// Универсальный вход внешний мир -> Форт. Вызывается ТОЛЬКО из thunk'а,
// сгенерированного MK-WINAPI-CB / MK-CDECL-CB (stdlib.f):
//   mov EDX, xt ; mov ECX, N ; call cbBridge ; ret 4*N (WINAPI) / ret (CDECL)
// Вход: [ESP]=ret->thunk, [ESP+4]=ret->caller, [ESP+8+i*4]=arg(i+1),
//       EDX = xt слова ( a1..aN -- res ), ECX = N.
// EBP/ESI/EDI на входе принадлежат ВНЕШНЕМУ коду и недостоверны: между
// входом внешней функции и вызовом thunk'а там может лежать кадр enter/leave
// или рабочие значения (поймано на cbw2_chk/cbw2_loop в test/cbtest.dll:
// запись "стека данных" ложилась поверх аргументов в native-стеке). Контекст
// ФВМ мост берёт из снимка gCbSave*, который callD/callD2 обновляют перед
// каждым внешним call. Реентерабельность: вложенный внешний вызов из
// callback'а перезаписывает снимок своим (внутренним) контекстом - вложенный
// мост берёт его, а после возврата работа продолжается на живых регистрах;
// снимок обратно не выгружается.
// THROW внутри callback'а НЕ перехватываем - программа падает (решение
// проекта: callback'и отлаживаются в REPL до регистрации thunk'а).
// Баланс стека данных: N>0 - кладём N ячеек (TOS-приёмник + a1..a(N-1),
// aN в EAX), слово снимает N и оставляет результат, выходной DROP снимает
// его; N=0 - h_DUP самого слова компенсирует выходной DROP. EBP на выходе
// всегда равен EBP на входе.
private
void cbBridge() {
    asm {	naked;
		push EBX;
		push ESI;
		push EDI;
		push EBP;  // args теперь по [ESP+24+...]
		lea EBX, [ESP+24];  // EBX = &a1
		// Контекст ФВМ - из снимка callD/callD2 (см. шапку)
		mov EBP, [gCbSaveEBP];
		mov ESI, [gCbSaveESI];
		mov EDI, [gCbSaveEDI];
		mov EAX, ESP;
		and ESP, -16;  // movaps-защита (SSE-код CRT/user32 требует выравнивания)
		push EAX;  // [ESP] = ESP до выравнивания
		test ECX, ECX;
		jz cbb_call;  // N=0: стек данных не трогаем
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;  // TOS-приёмник (don't-care ячейка)
		dec ECX;
		jz cbb_last;
	cbb_copy:
		mov EAX, [EBX];
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;  // a1..a(N-1) в память
		lea EBX, [EBX+CELL];
		dec ECX;
		jnz cbb_copy;
	cbb_last:
		mov EAX, [EBX];  // aN -> TOS
	cbb_call:
		call EDX;  // xt: ( a1..aN -- res ), res в EAX
		mov ECX, EAX;  // результат в ECX (volatile: переживёт восстановление
		               // callee-saved регистров; EBX для этого НЕЛЬЗЯ -
		               // его pop ниже затрёт результат)
		mov EAX, [EBP];
		lea EBP, [EBP+CELL];  // снять результат со стека данных
		mov ESP, [ESP];  // снять выравнивание
		pop EBP;
		pop EDI;
		pop ESI;
		pop EBX;
		mov EAX, ECX;  // результат -> EAX
		ret;  // -> thunk -> ret 4*N / ret -> caller
    }
}
// CBRIDGE ( -- addr ) Выдать адрес моста cbBridge (для фабрик thunk'ов)
private
void* d_CBBRIDGE() { return &cbBridge; }
private
void h_CBBRIDGE() {
    asm {	naked;	call h_DUP;  jmp d_CBBRIDGE; }
}

// Вызов внешних функций
// ( .... Af -- ... )
void callD() {
    asm {		naked;
		mov ECX, EAX;  // адрес функции (TOS)
		// pop/push ВАЖЕН: без него аргументы окажутся ниже ret callD2,
		// и callee увидит ret-адрес КАК ПЕРВЫЙ АРГУМЕНТ (сдвиг на ячейку).
		// Это же объясняет старую поломку загрузки от "упрощения" callD.
		pop EBX;       // сохранить ret callD2 в EBX (callee-saved! EDX callee порчёт)
		mov [gCbSaveEBP], EBP;  // снимок контекста ФВМ для cbBridge
		mov [gCbSaveESI], ESI;
		mov [gCbSaveEDI], EDI;
		call ECX;      // [аргументы][ret сюда]; stdcall чистит сам
		push EBX;      // вернуть ret
		call h_DUP;    // +1 мусорная ячейка под результатом (контракт DROP)
		ret;
    }
}
// LATEST ( -- Aexec)
// Выдать на стек данных F адрес CFA последнего изготовленного слова
private
void* d_LATEST() { return &(gpcb.latest); }
private
void h_LATEST() {
    asm {	naked;	call h_DUP;  jmp d_LATEST; }
}
// CONTEXT ( -- Alfa)
// Выдать на стек данных F адрес NFA последнего изготовленного слова. С этого
// адреса можно перебрать всю цепочку слов в словаре
private
void* d_CONTEXT() { return &(gpcb.context); }
private
void h_CONTEXT() {
    asm {	naked;	call h_DUP;  jmp d_CONTEXT; }
}
//  TIB ( -- Atib)
// Выдать на стек данных F адрес буфера, в котором содержится исходная строка форта
// для текстового разбора словом WORD
private
void* d_TIB() { return &(gpcb.Tib); }
private
void h_TIB() {
    asm {	naked;	call h_DUP;  jmp d_TIB; }
}
//  <IN ( -- A)
// Выдать на стек данных F адрес (позицию) того места, в строковом буфере, откуда
// будет начинаться поиск след слова (лексемы) словом WORD
private
void* d_IN() { return &(gpcb.In); }
private
void h_IN() {
    asm {	naked;	call h_DUP;  jmp d_IN; }
}
//  dlTib ( -- N )
// Выдать на стек данных размер строки в TIB
private
void* d_dlTib() { return cast(void*) gpcb.dlTib; }
private
void h_dlTib() {
    asm {	naked;	call h_DUP;  jmp d_dlTib; }
}
// ALLOT ( n -- )
// Зарезервировать в кодофайле n байт, под собственные нужды
private
void d_ALLOT(int n) { gpcb.here = gpcb.here + n; }
private
void h_ALLOT() {
    asm {	naked;	call d_ALLOT;	jmp h_DROP; }
}
// HERE ( -- Ahere)
// Выдать позицию в кодофайле, куда будут записываться новые определяемые слова
private
void* d_HERE() { return gpcb.here; }
private
void h_HERE() {
    asm {	naked;	call h_DUP;  jmp d_HERE; }
}
// STATE ( -- Ahere)
// Выдать состояние переменной, показывающий в компиляции или интерпретации сейчас
// мы находимся. TRUE=компиляция, FALSE=интерпретация
private
void* d_STATE() { return &gpcb.state; }
private
void h_STATE() {
    asm {	naked;	call h_DUP;  jmp d_STATE; }
}
// BASE ( -- Abase)
// Выдать адрес ячейки с текущей системой счисления для NUMBER (по умолчанию 10)
private
void* d_BASE() { return &gpcb.base; }
private
void h_BASE() {
    asm {	naked;	call h_DUP;  jmp d_BASE; }
}
// COMMONADR ( -- A )
// Выдать указатель на начало общей таблицы CommonAdr
private
void* d_COMMONADR() { return gpcb.adrCommonTable; }
private
void h_COMMONADR() {
    asm {	naked;	call h_DUP;  jmp d_COMMONADR; }
}
// : PLACE ( # --> addr ) HERE SWAP ALLOT ;
// Указатель на начало "дырки" свободной области в кодофайле
private
void h_PLACE() {
    asm {		naked;
		call h_HERE;
		call h_SWAP;
		jmp  h_ALLOT;
        // ret;
    }
}
// Зарезервировать одну ячейку в области данных и поместить x в эту ячейку.
// : , ( x --> ) CELL PLACE ! ;
private
void h_zpt() {
    asm {		naked;
        // int 3;
		call h_DUP; mov EAX, CELL;
		call h_PLACE;
		jmp  h_setToAdr;
        // ret;
    }
}
// Зарезервировать одну ячейку в области данных и поместить x в эту ячейку.
// : B, ( x --> ) 1 PLACE B! ;
private
void h_Bzpt() {
    asm {		naked;
		call h_DUP; mov EAX, 1;
		call h_PLACE;
		jmp h_setToAdrByte;
        // ret;
    }
}

// -------------------------- compie.f -------------------------

// \ 31-01-2007 ~mOleg
// \ Copyright [C] 1992-1999 A.Cherezov ac@forth.org
// \ Компиляция.

// \ скомпилировать адрес следующего токена в текущее определение
// \ классический не-immediate вариант. Не работает со immediate словами
// : COMPILE ( r: addr --> ) AR@ TOKEN@ TOKEN R+ COMPILE, ;
private
void h_COMPILE() {
    asm {		naked;
		call h_R_get;  // R@
		call f_TOKEN_get;
		call f_TOKEN;
		call h_R_PLUS;
		jmp h_COMPILEzpt;
                            // ret;
    }
}
// скомпилировать инструкцию INT3
// : INT3, ( --> ) 0xCC B, ;
private
void h_INT3zpt() {
    asm {		naked;
		call h_DUP; mov EAX, 0xCC;
		jmp h_Bzpt;
        // ret;
    }
}
// скомпилировать инструкцию RET
// : RET, ( --> ) 0xC3 B, ;
private
void h_RETzpt() {
    asm {		naked;
		call h_DUP; mov EAX, 0xC3;
		jmp h_Bzpt;
        // ret;
    }
}
// скомпилировать инструкцию CALL √
// : CALL, ( --> ) 0xE8 B, ;
private
void h_CALLzpt() {
    asm {		naked;
		call h_DUP; mov EAX, 0xE8;
		jmp h_Bzpt;
        // ret;
    }
}
// \ компилировать вызов указанного xt √
// : COMPILE, ( xt --> ) CALL, <resolve ;
private
void h_COMPILEzpt() {
    asm {		naked;
		call h_CALLzpt;
		jmp f_L_resolve;
        // ret;
    }
}
// \ компилировать безусловный переход на указанный адрес √
// : JUMP, ( addr --> )  0xE9 B, <resolve ;
private
void h_JUMPzpt() {
    asm {		naked;
		call h_DUP; mov EAX, 0xE9;
		call h_Bzpt;
		jmp f_L_resolve;
        // ret;
    }
}
// ???????????????????????? Возможно ошибочное словл
// \ компилировать код, возвращающий число в текущее определение
// : LIT, ( N --> ) COMPILE (LIT) , ;
private
void h_LITzpt() {
    asm {		naked;
	call h_COMPILE;
	call h_s_LIT_s;
	call h_zpt;
    }
}
// Шитое слово TRUE
// -1 CONSTANT TRUE
private
void f_TRUE() {
    asm {		naked;
		call h_DUP;
		mov EAX, -1;
		ret;
    }
}
// Шитое слово FALSE
// 0 CONSTANT FALSE
private
void f_FALSE() {
    asm {		naked;
		call h_DUP;
		mov EAX, 0;
		ret;
    }
}
// Шитое слово BL
// 32 CONSTANT BL
private
void f_BL() {
    asm {		naked;
		call h_DUP;
		mov EAX, 32;
		ret;
    }
}
// CODE [ - начать интерпретацию
private
void h_COMP_OFF() {
    asm {		naked;
		call f_FALSE;
		call h_STATE;
		jmp h_setToAdr;
        // ret;
    }
}
// CODE ] - начать компиляцию
private
void h_COMP_ON() {
    asm {		naked;
		call f_TRUE;
		call h_STATE;
		jmp h_setToAdr;
        // ret;
    }
}
// DUMP ( A -- ) Распечатать указанный адрес
void h_zz(pp adr) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        writeln("- dump -- dump -- dump -- dump -- dump -");
        dumpAdr(adr);
        writeln("- dump -- dump -- dump -- dump -- dump -");
    }
}
void h_dump() {
    asm {	naked;
		call h_zz;
		jmp h_DROP;
        // ret;
    }
}
// Выдать тип OS W - windows,  L - Linux
void h_osname() {
    version(Windows) {
        asm {	naked;
		call h_DUP;
		mov EAX, 87;
		ret;
        }
    }
    version(linux) {
        asm {	naked;
		call h_DUP;
		mov EAX, 76;
		ret;
        }
    }
}
// Вернуть на стек адрес функции LoadLibrary
pp h_LoadLibrary() {
    pp rez;
    version(Windows) {
import core.sys.windows.windows:LoadLibraryA;
        rez = cast(pp) & LoadLibraryA;
    }
    return rez;
}
void f_LoadLibraryA() {
    asm {	naked;
		call h_DUP;
		jmp h_LoadLibrary;
        // ret;
    }
}
pp h_DlOpen() {
    pp rez;
    version(linux) {
import core.sys.posix.dlfcn; // Определения dlopen() и dlsym()
        rez = cast(pp) & dlopen;
    }
    return rez;
}
void f_DlOpen() {
    asm {	naked;
		call h_DUP;
		jmp h_DlOpen;
        // ret;
    }
}
// Вернуть на стек адрес функции GetProcAdres
pp h_GetPrAdressA() {
    pp rez;
    version(Windows) {
import core.sys.windows.windows:GetProcAddress;
        rez = cast(pp) & GetProcAddress;
    }
    return rez;
}
void f_GetPrAdressA() {
    asm {	naked;
		call h_DUP;
		jmp h_GetPrAdressA;
        // ret;
    }
}
pp h_DlSym() {
    pp rez;
    version(linux) {
import core.sys.posix.dlfcn; // Определения dlopen() и dlsym()
        rez = cast(pp) & dlsym;
    }
    return rez;
}
void f_DlSym() {
    asm {	naked;
		call h_DUP;
		jmp h_DlSym;
        // ret;
    }
}

// use std.stdout instead of std.c.stdio.stdout

pp h_getSTDOUT() {
    version(ForthNoConsole) {
        // GUI-вариант: консоль отключена, stdout нет
        return null;
    } else {
    // Linux
import core.stdc.stdio;
    return cast(pp)(core.stdc.stdio.stdout);
    }
}
// Выдать на стек стандартный указатель на stdout
void getSTDOUT() {
    asm {	naked;
		call h_DUP;
		jmp h_getSTDOUT;
        // ret;
    }
}

// TYPE ( A -- ) Распечатать строку на консоли
/*
void h_TYPE(ps adr) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        printf("%s", adr);
        stdout.flush();
    }
}
*/
void h_TYPE(ps adr) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        printf("%s", adr);
        stdout.flush();
/*
        // --- дамп байтов, начиная с adr, включая нулевой байт ---
        import core.stdc.stdio: printf;
        ubyte* p = cast(ubyte*) adr;
        int n = 0;

        // Сначала посчитаем длину до нулевого байта включительно
        // (ограничим 256 байтами, чтобы не уйти в бесконечность на мусоре)
        while (n < 256 && p[n] != 0) n++;
        if (n < 256) n++;  // включить сам нулевой байт

        // Печатаем по 16 байт в строке
        for (int i = 0; i < n; i += 16) {
            printf("  %08X  ", cast(uint)(p + i));

            // hex-часть
            for (int j = 0; j < 16; j++) {
                if (i + j < n)
                    printf("%02X ", p[i + j]);
                else
                    printf("   ");
            }

            printf(" |");

            // символьная часть
            for (int j = 0; j < 16; j++) {
                if (i + j < n) {
                    ubyte b = p[i + j];
                    if (b >= 32 && b < 127)
                        printf("%c", b);
                    else
						if(b == 0) printf("~"); else printf(".");
                } else {
                    printf(" ");
                }
            }

            printf("|\n");
        }

        stdout.flush();
*/		
    }
}


void f_TYPE() {
    asm {	naked;
		call h_TYPE;
		jmp h_DROP;
        // ret;
    }
}
// EMIT ( char -- ) Выдать символ на консоль (putchar + сброс буфера)
private
void d_emit(int ch) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
import core.stdc.stdio:putchar, fflush, stdout;
	putchar(ch);
	fflush(stdout);
    }
}
void f_EMIT() {
    asm {	naked;
		call d_emit;
		jmp h_DROP;
        // ret;
    }
}

// CMOVE ( Afrom Ato N -- ) Скопировать байты
private
void h_bmove(int n, ps to, ps from) {
import core.stdc.string:memcpy;
    memcpy(to, from, n);
}
private
void f_bmove() {
    asm {	naked;
		push EAX;
		call h_DROP;
		push EAX;
		call h_DROP;
		call h_bmove;
		jmp h_DROP;
        // ret;
    }
}

// h_THROW (n) - D-часть: печать кода и запись gThrowCode (для хоста).
// f_THROW ( n -- ) - настоящий THROW. n=0 - no-op. n!=0:
//  - есть активный CATCH (gCatchHandler) - размотка native-вызовов до его
//    фрейма, восстановление EBP/ESI, exc# в EAX, переход в resume фрейма;
//  - CATCH нет - печать через h_THROW и unwind до границы D<->Форт
//    (чекпойнт gEvalESP/gEvalResume из evalForth/executeFromD), строка
//    прерывается, тёплый сброс делает D-эпилог evalForth.
// В обоих случаях f_THROW не возвращается в точку вызова.
private
void h_THROW(int n) {
    if (n == 0) return;
    gThrowCode = n;
    version(ForthNoConsole) {
        // GUI-вариант: не печатаем; код доступен хосту в gThrowCode
    } else {
        writeln();
        writeln("[", n, "]", " THROW - error");
    }
}
private
void f_THROW() {
    asm {	naked;
		test EAX, EAX;
		jnz thr_go;
		jmp h_DROP;  // 0 THROW - no-op (ANS)
thr_go:
		mov EDX, gCatchHandler;
		test EDX, EDX;
		jnz thr_unw;
		// нет CATCH: сообщить и уйти на границу D<->Форт
		call h_THROW;
		mov ESP, gEvalESP;
		mov EBX, gEvalResume;
		jmp EBX;
thr_unw:
		// есть CATCH: ECX = старый TOS (до восстановления EBP!)
		mov ECX, dword ptr SS:[EBP];
		mov EBP, [EDX];  // savedEBP
		mov ESI, [EDX+CELL];  // savedESI
		mov EBX, [EDX+CELL*2];  // old HANDLER
		mov gCatchHandler, EBX;
		lea ESP, [EDX+CELL*3];  // снять фрейм; [ESP] = ret-адрес вызова CATCH
		lea EBP, [EBP-CELL];  // положить старый TOS под exc#
		mov [EBP], ECX;
		// EAX = n (exc#) - на вершине; ret - прямо к вызывавшему CATCH
		ret;
    }
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// _______________________________________
// Слова для работы с динамической памятью

private
void* h_gc_malloc(size_t sz) {
import core.memory:GC;
    return cast(void*) GC.malloc(sz);
}
private
void f_GC_MALLOC() {
    asm {	naked;
		call h_gc_malloc;
		ret;
    }
}
private
void h_gc_free(void* uk) {
import core.memory:GC;
    // printf("%d\n", uk);
    GC.free(uk);
}
private
void f_GC_FREE() {
    asm {	naked;
		call h_gc_free;
		call h_DROP;
		ret;
    }
}

private
void h_sd_writeln(string* uk) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        writeln(*uk);
    }
}
private
void f_SD_WRITELN() {
    asm {	naked;
		call h_sd_writeln;
		jmp h_DROP;
        // ret;
    }
}

// Обработка вызова слота Slot_A_N_v
// Выдать адрес обработчика для вызова функции с параметрами A и N
private
void* h_A_CALL_AN() { return &executeForth_A_N; }
// Forth слово: выдать адрес обработчика для вызова функции с параметрами A и N
private
void f_A_CALL_AN() {
    asm {	naked;
		call h_DUP;
		jmp h_A_CALL_AN;
        // ret;
    }
}
// Обработка вызова слота Slot_A_N_v
extern(C) void executeForth_A_N(pp adr, int n) {
    executeForth(adr, 1, n);
}

// Выполнить адрес через EXECUTE
extern(C) pp executeForth(pp adrexec, uint kolPar, ...) {
    pp Adr_execD = gpcb.executeFromD;  // ' EXECUTEFROMD
    // writeln("Adr_execD = ", Adr_execD, "   adrexec = ", adrexec, "  kolPar = ", kolPar);
    NPcb npcb = gpcb;  // Возможность работы с PCB (контекст) переменными в ASM
    pp adrKolPar = cast(pp) & kolPar;  // Адрес количества параметров
	gCatchHandler = null;  // песочница: фреймы CATCH не живут между вызовами
    asm {
		align 4;
        // Сохраним регистры D
		push EBX; push ESI; push EAX; push ECX; push EDX; push EBP;
        // --------------------
        // Запишем наши параметры
		push Adr_execD;  // Адрес xt специальный слова в Forth (EXECUTEFROMD)
		push adrexec;  // Адпес слова Forth которое будет выполнено из EXECUTEFROMD
		push adrKolPar;  // Адрес количества параметров для передачи в Форт
        // Востановим регитры F
		mov EAX, npcb.saveEAX.offsetof[npcb];
		mov ESI, npcb.saveESI.offsetof[npcb];
		mov EDI, npcb.saveEDI.offsetof[npcb];
		mov EBP, npcb.saveEBP.offsetof[npcb];
  		call h_DUP;  // Сохраним то что было на вершине стека Форта
		pop  EAX;  // На веншину SD количество пораметров
  		call h_DUP;  // Сохраним,освободив вершину SD
		pop  EAX;  // На веншину SD адрес вызываемого слова
  		call h_DUP;  // Сохраним,освободив вершину SD
		pop  EAX;  // На вершине SD адрес EXECUTEFROMD
		mov gEvalESP, ESP;  // Чекпойнт для THROW без CATCH
		call f_EXECUTE;  // Вызов EXECUTEFROMD
		call exf_cap;  // захват адреса продолжения
		jmp  exf_res;
	exf_cap: pop EBX;
		mov gEvalResume, EBX;
	exf_res:
        // Результат — в модульную переменную: локаль ret адресуется через EBP,
        // а EBP здесь ещё указывает на стек данных Форта
		mov gExecuteRet, EAX;
		call h_DROP;  // Выкинуть со стека в форте, так как вызов внешний

        // Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
                                             // mov ret, EBX;
                                             // ----------------------
                                             // Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop ESI; pop EBX;
    }
    gpcb.saveEBP = npcb.saveEBP;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveEAX = npcb.saveEAX;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveESI = npcb.saveESI;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveEDI = npcb.saveEDI;  // Возможность работы с PCB (контекст) переменными в ASM
    if (gThrowCode != 0) {
        // Слово оборвалось THROW без CATCH: тёплый сброс. Хосту возвращаем
        // код THROW (иначе в gExecuteRet - мусор из D-функции h_THROW)
        pp code = cast(pp) gThrowCode;
        gThrowCode = 0;
        gCatchHandler = null;
        gpcb.saveEBP = gResetEBP;
        gpcb.saveESI = gpcb.csc;
        gpcb.saveEDI = gpcb.csr;  // R2-стек на вершину (как saveESI/csc)
        gpcb.state = null;
        return code;
    }
    return gExecuteRet;
}



void evalForth(char* str) { evalForth(to !string(str)); }
void evalForth(string str) {
    // Linux корректировка
    if (str.length > 0 && str[$ - 1] == 13) str.length = str.length - 1;

    gpcb.dlTib = str.length;      // Запишем длину строки в gpcb
    gpcb.In = cast(ps) gpcb.Tib;  // указатель смещения во входном буфере

    // Копируем входную строку в TIB[2048]
    h_bmove(str.length, cast(char*) tib.ptr, cast(char*) str.ptr);

    /*
            {
            import core.stdc.string : memcpy;
            memcpy(to, from, n);
    }

            for(int i; i != str.length; i++) tib[i] = cast(ubyte)str[i];
    */
    NPcb npcb = gpcb;  // Возможность работы с PCB (контекст) переменными в ASM
	gCatchHandler = null;  // песочница: фреймы CATCH не живут между строками
    asm {
		align 4;
        // Сохраним регистры D
		push EBX; push ESI; push EAX; push ECX; push EDX; push EBP;
		mov gEvalESP, ESP;  // Чекпойнт для THROW без CATCH (позиция сохранённых D-регистров)
        // --------------------
        // Востановим регитры F
        //		int 3;
		mov EAX, npcb.saveEAX.offsetof[npcb];
		mov ESI, npcb.saveESI.offsetof[npcb];
		mov EDI, npcb.saveEDI.offsetof[npcb];
		mov EBP, npcb.saveEBP.offsetof[npcb];
		
		call f_inter;
		call evf_cap;  // захват адреса продолжения
		jmp  evf_res;
	evf_cap: pop EBX;
		mov gEvalResume, EBX;
	evf_res:

        // Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
                                             // ----------------------
                                             // Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop ESI; pop EBX;
    }
    gpcb.saveEBP = npcb.saveEBP;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveEAX = npcb.saveEAX;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveESI = npcb.saveESI;  // Возможность работы с PCB (контекст) переменными в ASM
    gpcb.saveEDI = npcb.saveEDI;  // Возможность работы с PCB (контекст) переменными в ASM
    if (gThrowCode != 0) {
        // Был THROW: тёплый сброс - стеки на исходные, режим интерпретации
        gThrowCode = 0;
        gCatchHandler = null;
        gpcb.saveEBP = gResetEBP;  // стек данных на дно
        gpcb.saveESI = gpcb.csc;   // локальный стек на вершину (как LP_set)
        gpcb.saveEDI = gpcb.csr;   // R2-стек на вершину (как saveESI/csc)
        gpcb.state = null;         // режим интерпретации
    }
}
// Записать в общую таблицу адрес adr в ячейку с номером n
void setCommonAdr(int n, pp adr) { commonTable[n] = adr; }
// Прочитать из общий таблицы адрес в ячейке n
pp getCommonAdr(int n) { return commonTable[n]; }
// Инициализировать Forth и подготовить его к работе

void initForth() {
    // Кодофайл содержит исполняемый машинный код (слова компилируются в x86-код).
    // В GC-куче страницы не исполняемые: при включённом DEP (NXCOMPAT, дефолт у
    // современных линкеров) первый же EXECUTE в кодофайл даёт Access Violation.
    // Поэтому на Windows выделяем кодофайл через VirtualAlloc(PAGE_EXECUTE_READWRITE).
    version(Windows) {
import core.sys.windows.winbase:VirtualAlloc;
import core.sys.windows.winnt:MEM_COMMIT, MEM_RESERVE, PAGE_EXECUTE_READWRITE;
        kdf = cast(pb) VirtualAlloc(null, sizeCodeFile * CELL, MEM_COMMIT | MEM_RESERVE,
                                    PAGE_EXECUTE_READWRITE);  // Кодофайл на sizeCodeFile ячеек
        if (kdf is null) throw new Error("initForth: VirtualAlloc failed");
    }
    else {
        kdf = cast(pb)(new uint[sizeCodeFile]).ptr;  // Изготовим кодофайл на sizeCodeFile адр
    }
    NPcb npcb = gpcb;
    npcb.adrCommonTable = cast(pp) commonTable.ptr;
    const sizeSt = sizeStack;  // По sizeStack CELL на каждый стек
    // uint[sizeSt] stSD, stSR, stSL;  		// Память под стеки
    stSD = cast(pp)(new uint[sizeSt]);  // Запомнить начало области SP в глобальной переменной
    npcb.csd = stSD + sizeSt - 1;  // Запомнить вершину стека SP в контексте

    // Отдельный пользовательский R2-стек (>R2/R2>/R2@/R2DROP/R2+/RP2@/RP2!)
    // на EDI - НЕ совмещён с native ESP. Старые >R/R>/R@/RDROP/R+/RP@/RP!
    // остаются на ESP (на них завязаны (JOIN)/(DOES)/COMPILE/(BOX) - они
    // читают native адрес возврата после call). Новый стек устраняет баг #6
    // arPanic.md: DOES>-слова между >R/R> больше не рвут пользовательские
    // временные значения, если пользоваться >R2/R2> вместо >R/R>.
    stSR = cast(pp)(new uint[sizeSt]);  // R2-стек (EDI)
    npcb.csr = stSR + sizeSt - 1;  // вершина R2-стека

    stSL = cast(pp)(new uint[sizeSt]);  // Запомнить начало SP в глобальной переменной
    npcb.csc = stSL + sizeSt - 1;       // Запомнить вершину SL в контексте

    npcb.here = kdf;              // HERE на начало буфера
    npcb.context = cast(pp) kdf;  // Вектор context лежит в начале кодофайла
    npcb.akdf = cast(pp) kdf;     // Указатель на кодофайл
    npcb.Tib = cast(ps) & tib;    // Указатель на входной буфер текста
    // npcb._Tib = cast(ps)&_tib;	// ??? не используется // Указатель на входной буфер WORD
    npcb.In = cast(ps) & tib;  // указатель смещения во входном буфере
    asm {
		align 4;
        // Сохраним регистры D
		push EBX; push ESI; push EDI; push EAX; push ECX;	push EDX; push EBP;
        // --------------------
        // В ESI запомним указатель на доп стек SL
		lea EAX, npcb.csc.offsetof[npcb]; 
		mov ESI,  DS:[EAX];
        // В EDI запомним указатель на отдельный R2-стек (слова >R2/R2>/...)
		lea EAX, npcb.csr.offsetof[npcb];
		mov EDI,  DS:[EAX];
        // Из контекста возьмем указатель на стек данных ...
		lea EAX, npcb.csd.offsetof[npcb]; 
		mov EAX,  DS:[EAX];
		call SP_set;  // ... и инициализируем его
		mov EAX, ESI;	call LP_set;                          // Стек дополнительный для Форк
        // Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
                                             // ----------------------
                                             // Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop EDI; pop ESI; pop EBX;
    }
    // writeln("Local PCB: ", npcb);
    gpcb = npcb;
    gpcb.base = cast(pp) 10;  // система счисления по умолчанию - десятичная
    gResetEBP = npcb.saveEBP;  // пустой стек данных (для сброса по THROW)
    // Надо выделить 256 CELL для хранения цепочек context
    pb u = gpcb.here;
    for (int i; i != (256 * CELL); i++) *u = 0;
    gpcb.here = gpcb.here + (256 * CELL);
    // Перенесём сюда определение HARD слов
    CreateVocItem(cast(char*) "\3EXD".ptr, cast(pp) & exec_D, &gpcb.context);
    CreateVocItem(cast(char*) "\6CALL_A".ptr, cast(pp) & callD, &gpcb.context);
    CreateVocItem(cast(char*) "\5CALLB".ptr, cast(pp) & callD2, &gpcb.context);
    CreateVocItem(cast(char*) "\7CBRIDGE".ptr, cast(pp) & h_CBBRIDGE, &gpcb.context);
    CreateVocItem(cast(char*) "\7CONTEXT".ptr, cast(pp) & h_CONTEXT, &gpcb.context);
    CreateVocItem(cast(char*) "\4JUMP".ptr, cast(pp) & f_JUMP, &gpcb.context);
    CreateVocItem(cast(char*) "\4EXIT".ptr, cast(pp) & f_EXIT, &gpcb.context);
    CreateVocItem(cast(char*) "\5?EXIT".ptr, cast(pp) & f_Q_EXIT, &gpcb.context);
    CreateVocItem(cast(char*) "\3NIP".ptr, cast(pp) & SP_nip, &gpcb.context);
    CreateVocItem(cast(char*) "\3ROT".ptr, cast(pp) & SP_rot, &gpcb.context);
    CreateVocItem(cast(char*) "\4-ROT".ptr, cast(pp) & SP_minusrot, &gpcb.context);
    CreateVocItem(cast(char*) "\3D>R".ptr, cast(pp) & SR_DtoR, &gpcb.context);
    CreateVocItem(cast(char*) "\3DR>".ptr, cast(pp) & SR_DRfrom, &gpcb.context);

    CreateVocItem(cast(char*) "\6OSNAME".ptr, cast(pp) & h_osname, &gpcb.context);

    CreateVocItem(cast(char*) "\10(STDOUT)".ptr, cast(pp) & getSTDOUT, &gpcb.context);

    CreateVocItem(cast(char*) "\14LOADLIBRARYA".ptr, cast(pp) & f_LoadLibraryA, &gpcb.context);
    CreateVocItem(cast(char*) "\10GPADRESS".ptr, cast(pp) & f_GetPrAdressA, &gpcb.context);
    CreateVocItem(cast(char*) "\6DLOPEN".ptr, cast(pp) & f_DlOpen, &gpcb.context);
    CreateVocItem(cast(char*) "\5DLSYM".ptr, cast(pp) & f_DlSym, &gpcb.context);

    CreateVocItem(cast(char*) "\2L@".ptr, cast(pp) & SL_get, &gpcb.context);
    CreateVocItem(cast(char*) "\2L+".ptr, cast(pp) & SL_add, &gpcb.context);
    CreateVocItem(cast(char*) "\2>L".ptr, cast(pp) & SL_toL, &gpcb.context);
    CreateVocItem(cast(char*) "\2L>".ptr, cast(pp) & SL_Lfrom, &gpcb.context);
    CreateVocItem(cast(char*) "\4LDUP".ptr, cast(pp) & SL_Ldup, &gpcb.context);
    CreateVocItem(cast(char*) "\5LDROP".ptr, cast(pp) & SL_Ldrop, &gpcb.context);

    CreateVocItem(cast(char*) "\3SP!".ptr, cast(pp) & SP_set, &gpcb.context);
    CreateVocItem(cast(char*) "\3SP@".ptr, cast(pp) & SP_get, &gpcb.context);
    CreateVocItem(cast(char*) "\5DEPTH".ptr, cast(pp) & h_DEPTH, &gpcb.context);
    CreateVocItem(cast(char*) "\3RP!".ptr, cast(pp) & RP_set, &gpcb.context);
    CreateVocItem(cast(char*) "\3RP@".ptr, cast(pp) & RP_get, &gpcb.context);
    CreateVocItem(cast(char*) "\3LP!".ptr, cast(pp) & LP_set, &gpcb.context);
    CreateVocItem(cast(char*) "\3LP@".ptr, cast(pp) & LP_get, &gpcb.context);
    //	CreateVocItem(cast(char*)"\2T5".ptr, 		cast(pp)&t5, 			&gpcb.context);
    //	CreateVocItem(cast(char*)"\3TCW".ptr, 		cast(pp)&TestCompileWord, &gpcb.context);
    CreateVocItem(cast(char*) "\5INT3,".ptr, cast(pp) & h_INT3zpt, &gpcb.context);
    CreateVocItem(cast(char*) "\3<IN".ptr, cast(pp) & h_IN, &gpcb.context);
    CreateVocItem(cast(char*) "\3TIB".ptr, cast(pp) & h_TIB, &gpcb.context);
    CreateVocItem(cast(char*) "\5DLTIB".ptr, cast(pp) & h_dlTib, &gpcb.context);
    CreateVocItem(cast(char*) "\4NOOP".ptr, cast(pp) & f_NOOP, &gpcb.context);

    CreateVocItem(cast(char*) "\4DUMP".ptr, cast(pp) & h_dump, &gpcb.context);
    CreateVocItem(cast(char*) "\5RDROP".ptr, cast(pp) & SR_rdrop, &gpcb.context);
    CreateVocItem(cast(char*) "\5DDROP".ptr, cast(pp) & SP_ddrop, &gpcb.context);
    CreateVocItem(cast(char*) "\4DDUP".ptr, cast(pp) & SP_ddup, &gpcb.context);
    CreateVocItem(cast(char*) "\2>R".ptr, cast(pp) & h_toR, &gpcb.context);
    CreateVocItem(cast(char*) "\2R>".ptr, cast(pp) & h_Rto, &gpcb.context);
    CreateVocItem(cast(char*) "\2R+".ptr, cast(pp) & h_R_PLUS, &gpcb.context);
    CreateVocItem(cast(char*) "\2R@".ptr, cast(pp) & h_R_get, &gpcb.context);
    // Новые слова на отдельном R2-стеке (EDI) - фикс бага #6 arPanic.md.
    // Не трогают старые >R/R>/R@/R+ (на них завязаны (JOIN)/(DOES)/COMPILE/(BOX)).
    CreateVocItem(cast(char*) "\3>R2".ptr, cast(pp) & h_toR2, &gpcb.context);
    CreateVocItem(cast(char*) "\3R2>".ptr, cast(pp) & h_R2to, &gpcb.context);
    CreateVocItem(cast(char*) "\3R2+".ptr, cast(pp) & h_R2_PLUS, &gpcb.context);
    CreateVocItem(cast(char*) "\3R2@".ptr, cast(pp) & h_R2_get, &gpcb.context);
    CreateVocItem(cast(char*) "\6R2DROP".ptr, cast(pp) & h_R2_drop, &gpcb.context);
    CreateVocItem(cast(char*) "\4RP2!".ptr, cast(pp) & h_RP2_set, &gpcb.context);
    CreateVocItem(cast(char*) "\4RP2@".ptr, cast(pp) & h_RP2_get, &gpcb.context);
    CreateVocItem(cast(char*) "\4D>R2".ptr, cast(pp) & h_DtoR2, &gpcb.context);
    CreateVocItem(cast(char*) "\4DR2>".ptr, cast(pp) & h_DR2from, &gpcb.context);
    CreateVocItem(cast(char*) "\2B,".ptr, cast(pp) & h_Bzpt, &gpcb.context);
    CreateVocItem(cast(char*) "\4REF,".ptr, cast(pp) & f_REFzpt, &gpcb.context);

    CreateVocItem(cast(char*) "\5(LIT)".ptr, cast(pp) & h_s_LIT_s, &gpcb.context);
	
	// Обычная реализация
    CreateVocItem(cast(char*) "\6(LOOP)".ptr, cast(pp) & f_s_LOOP_s, &gpcb.context);
    CreateVocItem(cast(char*) "\7(+LOOP)".ptr, cast(pp) & f_s_PLOOP_s, &gpcb.context);
	// Оптимизация циклов
    CreateVocItem(cast(char*) "\15(LOOP?BRANCH)".ptr, cast(pp)  & f_s_LOOP_BRANCH_s,  &gpcb.context);
    CreateVocItem(cast(char*) "\16(+LOOP?BRANCH)".ptr, cast(pp) & f_s_PLOOP_BRANCH_s, &gpcb.context);

    CreateVocItem(cast(char*) "\7(LEAVE)".ptr, cast(pp) & f_s_LEAVE_s, &gpcb.context);
    CreateVocItem(cast(char*) "\5(?DO)".ptr, cast(pp) & f_s_QDO_s, &gpcb.context);
    CreateVocItem(cast(char*) "\4(DO)".ptr, cast(pp) & f_s_DO_s, &gpcb.context);
    CreateVocItem(cast(char*) "\1I".ptr, cast(pp) & h_I, &gpcb.context);
    CreateVocItem(cast(char*) "\1J".ptr, cast(pp) & h_J, &gpcb.context);
    CreateVocItem(cast(char*) "\4RET,".ptr, cast(pp) & h_RETzpt, &gpcb.context);
    // ????? CreateVocItem(cast(char*)"\4LIT,".ptr,  	cast(pp)&h_LITzpt,  	&gpcb.context);
    CreateVocItem(cast(char*) "\4TUCK".ptr, cast(pp) & h_TUCK, &gpcb.context);
    CreateVocItem(cast(char*) "\3DUP".ptr, cast(pp) & h_DUP, &gpcb.context);
    CreateVocItem(cast(char*) "\4SWAP".ptr, cast(pp) & h_SWAP, &gpcb.context);
    CreateVocItem(cast(char*) "\4DROP".ptr, cast(pp) & h_DROP, &gpcb.context);
    CreateVocItem(cast(char*) "\4OVER".ptr, cast(pp) & h_OVER, &gpcb.context);
    CreateVocItem(cast(char*) "\1+".ptr, cast(pp) & h_PLUS, &gpcb.context);
    CreateVocItem(cast(char*) "\1*".ptr, cast(pp) & h_ZW, &gpcb.context);
    CreateVocItem(cast(char*) "\1/".ptr, cast(pp) & h_ZD, &gpcb.context);
    CreateVocItem(cast(char*) "\1%".ptr, cast(pp) & h_ZP, &gpcb.context);
    CreateVocItem(cast(char*) "\1-".ptr, cast(pp) & h_MINUS, &gpcb.context);
    CreateVocItem(cast(char*) "\1=".ptr, cast(pp) & f_RAWNO, &gpcb.context);
    CreateVocItem(cast(char*) "\2<>".ptr, cast(pp) & f_NRAWNO, &gpcb.context);
    CreateVocItem(cast(char*) "\1<".ptr, cast(pp) & f_MENSHE, &gpcb.context);
    CreateVocItem(cast(char*) "\1>".ptr, cast(pp) & f_BOLSHE, &gpcb.context);

    CreateVocItem(cast(char*) "\3AND".ptr, cast(pp) & h_AND, &gpcb.context);
    CreateVocItem(cast(char*) "\2OR".ptr, cast(pp) & h_OR, &gpcb.context);
    CreateVocItem(cast(char*) "\3XOR".ptr, cast(pp) & h_XOR, &gpcb.context);
    CreateVocItem(cast(char*) "\6INVERT".ptr, cast(pp) & h_INVERT, &gpcb.context);
    CreateVocItem(cast(char*) "\6LSHIFT".ptr, cast(pp) & h_LSHIFT, &gpcb.context);
    CreateVocItem(cast(char*) "\6RSHIFT".ptr, cast(pp) & h_RSHIFT, &gpcb.context);
    CreateVocItem(cast(char*)("\2" ~"2*").ptr, cast(pp) & h_2MUL, &gpcb.context);
    CreateVocItem(cast(char*)("\2" ~"2/").ptr, cast(pp) & h_2DIV, &gpcb.context);
    CreateVocItem(cast(char*) "\6UM/MOD".ptr, cast(pp) & h_UM_MOD, &gpcb.context);

    CreateVocItem(cast(char*)("\2" ~"1+").ptr, cast(pp) & h_inc, &gpcb.context);
    CreateVocItem(cast(char*)("\2" ~"1-").ptr, cast(pp) & h_dec, &gpcb.context);

    CreateVocItem(cast(char*) "\4CELL".ptr, cast(pp) & f_CELL, &gpcb.context);
    CreateVocItem(cast(char*) "\3REF".ptr, cast(pp) & f_REF, &gpcb.context);
    CreateVocItem(cast(char*) "\5PLACE".ptr, cast(pp) & h_PLACE, &gpcb.context);
    CreateVocItem(cast(char*) "\5ALLOT".ptr, cast(pp) & h_ALLOT, &gpcb.context);

    // ========== Странные шитые слова =============
    CreateVocItem(cast(char*) "\4TRUE".ptr, cast(pp) & f_TRUE, &gpcb.context);
    CreateVocItem(cast(char*) "\5FALSE".ptr, cast(pp) & f_FALSE, &gpcb.context);
    CreateVocItem(cast(char*) "\5STATE".ptr, cast(pp) & h_STATE, &gpcb.context);
    CreateVocItem(cast(char*) "\4BASE".ptr, cast(pp) & h_BASE, &gpcb.context);
    CreateVocItem(cast(char*) "\3IMM".ptr, cast(pp) & f_getIMM, &gpcb.context);
    CreateVocItem(cast(char*) "\2BL".ptr, cast(pp) & f_BL, &gpcb.context);
    CreateVocItem(cast(char*) "\3CFL".ptr, cast(pp) & f_CFL, &gpcb.context);
    CreateVocItem(cast(char*) "\5TOKEN".ptr, cast(pp) & f_TOKEN, &gpcb.context);
    CreateVocItem(cast(char*) "\6TOKEN@".ptr, cast(pp) & f_TOKEN_get, &gpcb.context);
    CreateVocItem(cast(char*) "\6TOKEN!".ptr, cast(pp) & f_TOKEN_set, &gpcb.context);
    CreateVocItem(cast(char*) "\4WORD".ptr, cast(pp) & f_word, &gpcb.context);
    CreateVocItem(cast(char*) "\4FIND".ptr, cast(pp) & f_find, &gpcb.context);
    CreateVocItem(cast(char*) "\4HERE".ptr, cast(pp) & h_HERE, &gpcb.context);
    CreateVocItem(cast(char*) "\6NUMBER".ptr, cast(pp) & h_NUMBER, &gpcb.context);
    CreateVocItem(cast(char*) "\11COMMONADR".ptr, cast(pp) & h_COMMONADR, &gpcb.context);
    CreateVocItem(cast(char*) "\1.".ptr, cast(pp) & h_tck, &gpcb.context);
    CreateVocItem(cast(char*) "\1[".ptr, cast(pp) & h_COMP_OFF, &gpcb.context, 1);
    CreateVocItem(cast(char*) "\1]".ptr, cast(pp) & h_COMP_ON, &gpcb.context);
    CreateVocItem(cast(char*) "\1:".ptr, cast(pp) & h_dwoetoc, &gpcb.context);
    CreateVocItem(cast(char*) "\1;".ptr, cast(pp) & h_tckzpt, &gpcb.context, 1);

    // ========== kernel\vm\STC\BASE\memory.f =============
    CreateVocItem(cast(char*) "\1@".ptr, cast(pp) & h_getFromAdr, &gpcb.context);
    CreateVocItem(cast(char*) "\1!".ptr, cast(pp) & h_setToAdr, &gpcb.context);
    CreateVocItem(cast(char*) "\2+!".ptr, cast(pp) & h_addToAdr, &gpcb.context);
    CreateVocItem(cast(char*) "\0031+!".ptr, cast(pp) & h_incToAdr, &gpcb.context);
    CreateVocItem(cast(char*) "\0031-!".ptr, cast(pp) & h_decToAdr, &gpcb.context);
    CreateVocItem(cast(char*) "\2B@".ptr, cast(pp) & h_getFromAdrByte, &gpcb.context);
    CreateVocItem(cast(char*) "\2B!".ptr, cast(pp) & h_setToAdrByte, &gpcb.context);
    CreateVocItem(cast(char*) "\4FILL".ptr, cast(pp) & h_FILL, &gpcb.context);
    CreateVocItem(cast(char*) "\5BMOVE".ptr, cast(pp) & f_bmove, &gpcb.context);

    // ========== List words for call from C++ QtE5 =============
    CreateVocItem(cast(char*) "\11A_CALL_AN".ptr, cast(pp) & f_A_CALL_AN, &gpcb.context);
    CreateVocItem(cast(char*) "\11GC_MALLOC".ptr, cast(pp) & f_GC_MALLOC, &gpcb.context);
    CreateVocItem(cast(char*) "\7GC_FREE".ptr, cast(pp) & f_GC_FREE, &gpcb.context);
    CreateVocItem(cast(char*) "\12SD_WRITELN".ptr, cast(pp) & f_SD_WRITELN, &gpcb.context);

    // ========== kernel\vm\STC\BASE\  ...... ============= ссылки
    CreateVocItem(cast(char*) "\5>MARK".ptr, cast(pp) & f_R_MARK, &gpcb.context);
    CreateVocItem(cast(char*) "\5<MARK".ptr, cast(pp) & f_L_MARK, &gpcb.context);
    CreateVocItem(cast(char*) "\10<RESOLVE".ptr, cast(pp) & f_L_RESOLVE, &gpcb.context);
    CreateVocItem(cast(char*) "\10RESOLVE>".ptr, cast(pp) & f_RESOLVE_R, &gpcb.context);
    CreateVocItem(cast(char*) "\7?BRANCH".ptr, cast(pp) & f_ZW_BRANCH, &gpcb.context);
    CreateVocItem(cast(char*) "\6BRANCH".ptr, cast(pp) & f_BRANCH, &gpcb.context);
    CreateVocItem(cast(char*) "\6LATEST".ptr, cast(pp) & h_LATEST, &gpcb.context);
    CreateVocItem(cast(char*) "\5THROW".ptr, cast(pp) & f_THROW, &gpcb.context);
    CreateVocItem(cast(char*) "\5CATCH".ptr, cast(pp) & h_CATCH, &gpcb.context);

    // ========== Компиляция =============
    CreateVocItem(cast(char*) "\1,".ptr, cast(pp) & h_zpt, &gpcb.context);
    CreateVocItem(cast(char*) "\5JUMP,".ptr, cast(pp) & h_JUMPzpt, &gpcb.context);
    CreateVocItem(cast(char*) "\10COMPILE,".ptr, cast(pp) & h_COMPILEzpt, &gpcb.context);
    CreateVocItem(cast(char*) "\7COMPILE".ptr, cast(pp) & h_COMPILE, &gpcb.context);
    CreateVocItem(cast(char*) "\10(CREATE)".ptr, cast(pp) & f_s_CREATE_s, &gpcb.context);

    CreateVocItem(cast(char*) "\6CREATE".ptr, cast(pp) & h_CREATE, &gpcb.context);
    CreateVocItem(cast(char*) "\7EXECUTE".ptr, cast(pp) & f_EXECUTE, &gpcb.context);

    CreateVocItem(cast(char*) "\4TYPE".ptr, cast(pp) & f_TYPE, &gpcb.context);
    CreateVocItem(cast(char*) "\4EMIT".ptr, cast(pp) & f_EMIT, &gpcb.context);

	// Работа со словарной статьёй
	// evalForth(": C@ B@ ; : C! B! ; : CFA>NFA DUP 6 - C@ 8 + - ; : CFA>LFA CELL - ; : NFA>LFA DUP C@ DUP + + ; : LFA>NFA CELL + CFA>NFA ; : NFA>CFA NFA>LFA CELL + ;");
	evalForth(": C@ B@ ; : C! B! ; : CFA>NFA DUP 6 - C@ 8 + - ; : CFA>LFA CELL - ; : LFA>NFA CELL + CFA>NFA ;");
	evalForth(": NFA>LFA DUP C@ + 4 + ; : NFA>CFA NFA>LFA CELL + ;");

	// Классический Immediate
//	evalForth(": IMMEDIATE 1 LATEST @ 1 CELL + - B! ;");
	evalForth(": IMMEDIATE 1 LATEST @ CFA>NFA DUP C@ + 3 + B! ;");

	// Create Does> - классика
	evalForth(": (JOIN) R> LATEST @ TOKEN! ; : (DOES) R> R> SWAP EXECUTE ; : DOES>  COMPILE (JOIN) COMPILE (DOES) ; IMMEDIATE");
	// Constant и Variable
	evalForth(": CONST CREATE COMPILE (CREATE) , DOES> @ ; : VAR CREATE 0 COMPILE (CREATE) , DOES> ;");
	// BUFFER ( n -- ) создать слово, возвращающее адрес области из
	// n зарезервированных байт (идея BUFFER: из ANS). Тело слова:
	// (CREATE) + n байт; DOES> пустой - на стеке адрес области.
	// 100 BUFFER BUF   BUF ( -- addr )  BUF 99 + B! - легально.
	evalForth(": BUFFER CREATE COMPILE (CREATE) ALLOT DOES> ;");
	// Комментарий
	evalForth(r": \  TIB @ DLTIB + <IN ! ; IMMEDIATE : // TIB @ DLTIB + <IN ! ; IMMEDIATE");
	// IF ELSE THEN
	evalForth(": IF COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": ELSE COMPILE BRANCH CELL ALLOT >MARK SWAP RESOLVE> ; IMMEDIATE");
	evalForth(": THEN RESOLVE> ; IMMEDIATE");
	// BEGIN WHILE UNTIL
	evalForth(": BEGIN <MARK ; IMMEDIATE : WHILE COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": REPEAT COMPILE BRANCH SWAP <RESOLVE RESOLVE> ; IMMEDIATE");
	evalForth(": UNTIL COMPILE ?BRANCH <RESOLVE ; IMMEDIATE");
	// Работа с символами
	// LITERAL ( n --> \\ --> n ) I (ни чего не делать), С (закомпилировать код выкл на стек)
	evalForth(": LIT, COMPILE (LIT) , ; : LITERAL STATE @ IF LIT, THEN ; : [CHAR] BL WORD 1+ C@ LITERAL ; IMMEDIATE");
	evalForth(": ' BL WORD DUP IF FIND DUP IF ELSE 3 THROW DROP THEN ELSE 2 THROW DROP THEN ;");
	// ['] Найти xt идущего следом слова и закомпилировать его в новое определение
	// BOX -  обойти данные в коде, начинающиеся со следующей ячейки, вернуть адрес начала данных
	evalForth(": ['] ' LIT, ; IMMEDIATE : (BOX) R@ DUP B@ 2 + R+ ;");
	evalForth(`: S" [CHAR] " STATE @ IF COMPILE (BOX) WORD ELSE WORD DUP THEN B@ 2 + ALLOT ; IMMEDIATE`);
	// Работа с векторами
	// VECT ( / name --> ) Создать слово, которое передаёт управление по JMP на NOOP
	evalForth(": VECT CREATE ['] NOOP JUMP, ;");
	// LITERAL ( n --> \\ --> n ) I (ни чего не делать), С (закомпилировать код выкл на стек)
	// evalForth(": LITERAL STATE @ IF LIT, THEN ;");
	// REGULAR ( xt --> ) I (исполнить слово), С (закомпилировать в определение)
	evalForth(": REGULAR STATE @ IF COMPILE, ELSE EXECUTE THEN ; : CELLS CELL * ; ");
	// IS ( xt / name --> ) Присвоить значение вектору, HAS ( / name --> xt ) получить значение вектора
	evalForth(": IS ' LITERAL ['] TOKEN! REGULAR ; : HAS ' LITERAL ['] TOKEN@ REGULAR ;");
	// COMMONADR@ ( n -- Value ) Значение в ячейке n общй таблицы. COMMONADR! ( Value n -- ) Запись значения в ячейку n
	evalForth(": COMMONADR! CELL * COMMONADR + ! ; : COMMONADR@ CELL * COMMONADR + @ ;");
	evalForth(": IF=W OSNAME 76 = IF TIB @ DLTIB + <IN ! THEN ; IMMEDIATE");
	evalForth(": IF=L OSNAME 87 = IF TIB @ DLTIB + <IN ! THEN ; IMMEDIATE");
	evalForth(": NOT IF FALSE ELSE TRUE THEN ;");
	// ====== Словарный минимум (раньше жил в console.f - нужен ДО консоли) ======
	evalForth(": 0= NOT ; : 0<> NOT NOT ; : ?DUP DUP IF DUP THEN ; : 2DUP DDUP ; : 2DROP DDROP ;");
	evalForth(": MIN DDUP < IF DROP ELSE NIP THEN ; : MAX DDUP < IF NIP ELSE DROP THEN ;");
	evalForth(": ( [CHAR] ) WORD DROP ; IMMEDIATE");
	evalForth(": CR 13 EMIT 10 EMIT ;");
	// Структуры (идиома SPF): STRUCT CELL FIELD MODE CELL FIELD SPEED
	//   CELL FIELD FLAGS /STRUCT /CFG - имя структуры создаёт ТОЛЬКО
	//   /STRUCT (имени после самого STRUCT нет - он лишь кладёт 0).
	//   Поле: ( base -- base+off ), /CFG = размер.
	//   Экземпляр: HERE /CFG ALLOT CONST cfg (проверенный идиомой test.f
	//   паттерн) или /CFG HALLOC CONST cfg. ВНИМАНИЕ: голый CREATE в этой
	//   системе даёт слово, которое НЕЛЬЗЯ исполнять напрямую - оборачивайте
	//   CONST/VAR (иначе CFA-рантайм съедает адрес возврата -> AV).
	//   Раскладка ПЛОТНАЯ (без выравнивания): для D-структур из int'ов
	//   (все поля CELL) совпадает с D автоматически; смешавая CELL и байтовые
	//   поля, выравнивание контролирует пользователь.
	//   Реализация FIELD: CREATE НЕ оставляет body-addr (системная
	//   особенность!), поэтому `,` пишет смещение прямо в body (HERE),
	//   а не через адрес со стека - классический вид `CREATE OVER , +`.
	evalForth(": STRUCT 0 ; : FIELD CREATE OVER COMPILE (CREATE) , + DOES> @ + ; : /STRUCT CONST ;");
	// Проверить, что мы в режиме компиляции или интерпретации (STATE даёт адрес, поэтому @)
	evalForth(": ?COMP STATE @ NOT IF 1 THROW THEN ; : ?EXEC STATE @ IF 2 THROW THEN ;");
	// Системы счисления для NUMBER (BASE даёт адрес, поэтому @/!)
	evalForth(": HEX 16 BASE ! ; : DECIMAL 10 BASE ! ; : OCTAL 8 BASE ! ; : BINARY 2 BASE ! ;");
	// Слова поверх CATCH/THROW (SPF-стиль): ABORT, парность, обработчики
	evalForth(": ABORT -1 THROW ;");
	evalForth(": ?PAIRS DDUP = IF 2DROP EXIT THEN -22 THROW ;");
	evalForth(": ?PAIRS\" [CHAR] \" WORD >R DDUP = IF 2DROP RDROP EXIT THEN 2DROP R> 1+ TYPE CR -22 THROW ; IMMEDIATE");
	evalForth(": ON-ERROR CATCH ; : EXIT-ERROR DUP IF THROW THEN DROP ;");
	// Compile-only слова с проверкой режима: переопределяют версии выше
	// (FIND находит новейшую). Без ?COMP DO/LOOP в интерпретации молча
	// компилировали мусор. THROW пока только печатает предупреждение.
	evalForth(": IF ?COMP COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": ELSE ?COMP COMPILE BRANCH CELL ALLOT >MARK SWAP RESOLVE> ; IMMEDIATE");
	evalForth(": THEN ?COMP RESOLVE> ; IMMEDIATE");
	evalForth(": BEGIN ?COMP <MARK ; IMMEDIATE : WHILE ?COMP COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": REPEAT ?COMP COMPILE BRANCH SWAP <RESOLVE RESOLVE> ; IMMEDIATE");
	evalForth(": UNTIL ?COMP COMPILE ?BRANCH <RESOLVE ; IMMEDIATE");
	// ( -- ) Забрать из потока слово немедленного исполнения и закомпилировать его
	evalForth(": [COMPILE] ?COMP ' COMPILE, ; IMMEDIATE");
	// Счетный цикл 10 0 DO .. I .. LOOP - 10 раз от 0 до 9 - в любом случае 1 раз выполнение
	// Для работы использует стек L. (DO), (LOOP), (+LOOP), I, J - теперь asm-слова
	// (зарегистрированы выше через CreateVocItem). Шитые варианты оставлены
	// для понимания логики:
	// evalForth(": (DO) SWAP >L >L ; : I L@ ;");
	// evalForth(": (LOOP) L> 1+ L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;");
	// evalForth(": (+LOOP) L> + L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;");
	// LEAVE: досрочный выход из цикла. LVCHAIN - голова цепочки неразрешённых
	// LEAVE текущего компилируемого цикла (звенья - ячейки смещения BRANCH,
	// внутри звена - адрес предыдущего звена, 0 = конец). DO сохраняет
	// чужую цепочку на стеке компиляции под меткой цикла и начинает новую;
	// LOOP/+LOOP резолвят свою цепочку и восстанавливают чужую - вложенные
	// циклы не пересекаются. LEAVE вне DO..LOOP - UB (примкнёт к чужой цепи).
	evalForth("VAR LVCHAIN");
	evalForth(": LVRES LVCHAIN @ BEGIN DUP WHILE DUP @ SWAP RESOLVE> REPEAT DROP ;");
	evalForth(": LEAVE ?COMP COMPILE (LEAVE) COMPILE BRANCH CELL ALLOT >MARK DUP LVCHAIN @ SWAP ! LVCHAIN ! ; IMMEDIATE");
	evalForth(": DO ?COMP LVCHAIN @ 0 LVCHAIN ! COMPILE (DO) <MARK ; IMMEDIATE");
	// ?DO: (?DO) сам снимает пару и даёт флаг; ?BRANCH при равенстве уводит
	// за цикл. Ячейка пропуска связывается В ЦЕПОЧКУ LVCHAIN (как звено
	// LEAVE) и резолвится LOOP/+LOOP тем же LVRES - отдельного ?LOOP не надо,
	// стек компиляции у ?DO и DO одинаков (чужая цепь + метка).
	evalForth(": ?DO ?COMP LVCHAIN @ 0 LVCHAIN ! COMPILE (?DO) COMPILE ?BRANCH CELL ALLOT >MARK DUP LVCHAIN @ SWAP ! LVCHAIN ! <MARK ; IMMEDIATE");
	// UNLOOP: снять пару цикла с L-стека перед EXIT из тела (ANS)
	evalForth(": UNLOOP (LEAVE) ;");
	
	// Было
	// evalForth(":  LOOP ?COMP COMPILE  (LOOP) COMPILE ?BRANCH <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");
	// evalForth(": +LOOP ?COMP COMPILE (+LOOP) COMPILE ?BRANCH <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");

	// Оптимизация
	evalForth(":  LOOP ?COMP COMPILE  (LOOP?BRANCH) <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");
	evalForth(": +LOOP ?COMP COMPILE (+LOOP?BRANCH) <RESOLVE LVRES LVCHAIN ! ; IMMEDIATE");
	// FILL ( addr u char -- ) - примитив в ядре (h_FILL, рядом с B!).
	// ERASE ( addr u -- ) = 0 FILL.
	evalForth(": ERASE 0 FILL ;");
	
	// EXECUTEFROMD ( Aколпарамтровcpp Aсловафорта -- Rez ) Выполнить из D слово по EXECUTE
	evalForth(": EXECUTEFROMD >R DUP @ BEGIN DUP WHILE DDUP CELL * + @ -ROT 1- REPEAT DDROP R> EXECUTE ;");
	gpcb.executeFromD = gpcb.latest; // Сохраним адрес EXECUTEFROMD
	
	// +++ Шитые слова из console.f +++
	// (стандартные имена, CASE, строки, форматирование чисел - унифицировано
	// на ядерном BASE: ввод и вывод чисел идут по одной базе gpcb.base)
	evalForth(": SPACE BL EMIT ;");
	evalForth(": SPACES BEGIN DUP 0 > WHILE SPACE 1- REPEAT DROP ;");
	evalForth(": COUNT DUP 1+ SWAP B@ ;");
	evalForth(": TYPEC OVER + SWAP BEGIN DDUP <> WHILE DUP B@ EMIT 1+ REPEAT DDROP ;");
	evalForth(": .\" [CHAR] \" STATE @ IF COMPILE (BOX) WORD DUP B@ 2 + ALLOT DROP ['] 1+ COMPILE, ['] TYPE COMPILE, ELSE WORD 1+ TYPE THEN ; IMMEDIATE");
	evalForth(": CONSTANT CONST ; : VARIABLE VAR ; : MOD % ; : /MOD DDUP % -ROT / ;");
	evalForth(": 0< 0 < ; : 0> 0 > ; : NEGATE 0 SWAP - ; : ABS DUP 0< IF NEGATE THEN ;");
	evalForth(": CASE ?COMP 0 ; IMMEDIATE");
	evalForth(": OF ?COMP 1+ >R COMPILE OVER COMPILE = COMPILE ?BRANCH CELL ALLOT >MARK COMPILE DROP R> ; IMMEDIATE");
	evalForth(": ENDOF ?COMP >R COMPILE BRANCH CELL ALLOT >MARK SWAP RESOLVE> R> ; IMMEDIATE");
	evalForth(": ENDCASE ?COMP COMPILE DROP BEGIN DUP WHILE SWAP RESOLVE> 1- REPEAT DROP ; IMMEDIATE");
	evalForth("HERE 40 ALLOT CONST PAD VAR #UK");
	evalForth(": HOLD #UK 1-! #UK @ B! ; : <# PAD 40 + #UK ! ;");
	evalForth(": # 0 BASE @ UM/MOD >R BASE @ UM/MOD SWAP DUP 9 > IF 7 + THEN 48 + HOLD R> ;");
	evalForth(": #S BEGIN # DDUP OR 0= UNTIL ; : #> DDROP #UK @ PAD 40 + OVER - ;");
	evalForth(": SIGN 0< IF [CHAR] - HOLD THEN ;");
	evalForth(": U. 0 <# #S #> TYPEC SPACE ;");
	evalForth(": . DUP ABS 0 <# #S ROT SIGN #> TYPEC SPACE ;");
	evalForth(": .R >R DUP ABS 0 <# #S ROT SIGN #> R> OVER - SPACES TYPEC ;");
	evalForth(": ? @ . ;");
	evalForth(": DNEGATE SWAP DUP 0= >R INVERT 1+ SWAP INVERT R> NEGATE + ;");
	evalForth(": DABS DUP 0< IF DNEGATE THEN ;");
	evalForth(": D. DUP >R DABS <# #S R> SIGN #> TYPEC SPACE ;");
	evalForth(": UD. <# #S #> TYPEC SPACE ;");
	evalForth(": STRLENZ DUP BEGIN DUP B@ WHILE 1+ REPEAT SWAP - ;");
	evalForth(": .U 0 <# # # # # # # # # # # #> TYPEC ;");
	// CREATE-BYTES (n -- ) Работает как CONST но резервирует место в кодофайле на n байт и адрес на стек
	// evalForth(": CREATE-BYTES CREATE COMPILE (CREATE) ALLOT ;");

}

// CODE WORD ( Rz -- A/0) Выдать адрес на начало следующей лексемы в формате
// \4ABCD\0\4 Причем эта лексема находится по адресу HERE
private
ps h_word(char rz) {
    // Указатель на TIB
    ps adr = null;
    ps uTib = cast(char*) gpcb.Tib;
    ps uIn = cast(char*) gpcb.In;
    int dlTib = gpcb.dlTib;
    ps maxTib = uTib + dlTib - 1;  // Это максимальный знак в Tib
    // Строка сейчас кладется в специальный бцфер _Tib
    // ps _tib = gpcb._Tib + 1;
    // Строка кладется по HERE
    ps _tib = cast(ps) gpcb.here + 1;

    int kps;
    // dumpAdr(cast(pp)uIn);
    for (;;) {
        // writeln();
        // writeln("[", *uIn,"]  uIn+1 = ", *(uIn+1), "   *uIn = ", cast(ubyte)*uIn);
        // writeln(uIn, " ~ ", maxTib);

        if (uIn > maxTib + 1) {
            adr = null;
            goto en;
        }
        // TAB (9) - полный эквивалент пробела как разделитель лексем
        if ((*uIn == rz) || (*uIn == 9 && rz == 32) || (uIn > maxTib)) {
            if (adr != null) {
                *_tib++ = 0;
                // *gpcb._Tib = cast(char)kps;  // Это если в буфер
                *gpcb.here = cast(char) kps;  // Это если в HERE
                *_tib = cast(char) kps;
                gpcb.In = ++uIn;
                // adr = gpcb._Tib;				// Это если в буфер
                adr = cast(ps) gpcb.here;  // Это если HERE
                goto en;
            }
        } else {
            if (adr == null) adr = _tib;
            *_tib++ = *uIn;
            kps++;
        }
        uIn++;
    }
en:
    return adr;
}
void f_word() {
    asm {	naked;
		call h_word;
		ret;
    }
}
// CODE FIND - ( Astr -- Acfa/0 ) Найти в словаре CFA (если не нашли, то 0)

private
ps h_find(ps s) {
    char* str = s;
    // printf("\n Start find [%s]  STATE = %d\n", s+1, gpcb.state);
    ps _nfa;
    pp[256] * vect;
    ubyte b1b;
    // Надо проверить, может это число? Если строго в строке одни цифры, то пропускаем и не ищем в словаре
    char* ss = s + 1;
    bool isNoDig = false;
    for (; *ss != 0; ss++) {
        if (!((*ss > 47) && (*ss < 58))) {
            isNoDig = true;
            break;
        }
    }
    if (!isNoDig) {
        goto kn;
    }

    b1b = *(cast(ubyte*)(s + 1));
    _nfa = cast(ps)(cast(pp*)gpcb.context)[b1b];

    while (_nfa) {
        ubyte len = *cast(ubyte*)_nfa;          // кэшируем длину — было 4 разыменования *_nfa

        // Быстрая отбраковка по длине перед cmpString
        if (len == *cast(ubyte*)s && cmpString(s, _nfa)) {
            gpcb.imm = *(cast(ubyte*)_nfa + len + 3);
            return _nfa + len + 8;
        }
        _nfa = *cast(ps*)(_nfa + len + 4);       // LFA за один шаг вместо двух
    }

kn:
    return null;
}

private
void f_find() {
    asm {	naked;
		jmp h_find;
        // ret;
    }
}
// CODE IMM ( -- N ) Выдать на стек байт IMM для анализа
private
pp h_getIMM() { return cast(pp) gpcb.imm; }
// Выдать IMM на стек
private
void f_getIMM() {
    asm {	naked;
		call h_DUP;
		jmp h_getIMM;
        // ret;
    }
}
// Первый (простейший) интерпретатор на основе asm
private
void f_inter() {
    asm {	naked;
        //		int 3;
        //		mov EAX, 7;				// По этой 7 будем контролировать стек   ... 7
ms:		call f_BL;  // Положить на стек 32 0x20;             ... 7 32
		call f_word;
		test EAX, EAX;
		je me;  // WORD выдало 0 - входной поток исчерпан
		call f_find;  // 7 Адр_найденного_слова 
		test EAX, EAX;
		je m2;          // FIND не нашло слово в словаре
                       // Читаем gpcb.state напрямую (без захода в Форт-слова STATE/@):
        // xt остаётся в EAX, стек данных вообще не трогаем
		cmp dword ptr gpcb.state.offsetof[gpcb], 0;
		je m1;  // Мы в интерпретации и идем на выполнение слова
		cmp byte ptr gpcb.imm.offsetof[gpcb], 1;
		je m1;  // IMMEDIATE-слово: выполнить даже в компиляции
		call h_COMPILEzpt;  // Закомпилируем вызов этого слова
		jmp ms;  // Начинаем всё сначала
m1:		call f_EXECUTE;  // Выполним слово
		jmp ms;  // Начинаем всё сначала
m2:		call h_DROP;  // Сбросим 0 после не найденного Find слова
		call h_HERE;  // слово не найдено, может это цифра?
		call h_NUMBER;  // попытка преобразовать в число
        // call f_TRUE;
		test EAX, EAX;
		call h_DROP;  // сбросим возврат NUMBER
		jne m4;  // число распознано - продолжить
		call h_DROP;  // ошибка разбора - снять фантомную ячейку, стек как был
		// Не слово и не число: THROW -13 (ANS "Undefined word") - прерывает
		// строку (в CATCH если есть, иначе unwind до границы evalForth).
		// "Not find word [X]" уже напечатано в number().
		mov EAX, -13;
		call f_THROW;  // не возвращается
		jmp me;  // недостижимо, страховка
m4:		cmp dword ptr gpcb.state.offsetof[gpcb], 0;
		je ms;          // интерпретация: число уже на вершине стека (EAX)
		call h_COMPILE;
		call h_s_LIT_s;
		call h_zpt;
		jmp ms;
me:		jmp h_DROP;
                       // ret;
    }
}
// Значение цифры в системе счисления: '0'..'9' -> 0..9, 'A'..'Z'/'a'..'z' -> 10..35.
// -1, если символ не является цифрой ни в какой системе счисления (base проверяет вызывающий).
private
int digitValue(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'A' && c <= 'Z') return c - 'A' + 10;
    if (c >= 'a' && c <= 'z') return c - 'a' + 10;
    return -1;
}
// Слово NUMBER. Задача, положить на стек число 32 разр знаковое.
// Классический разбор "по цифрам" с учётом текущего BASE (2..36), без
// исключений хоста. Поддержаны: знак '-' в начале, префиксы '$' (hex),
// '%' (binary) независимо от текущего BASE (SPF/fig-Forth конвенция).
// Признак успеха разбора кладётся в gNumberOk (читает h_NUMBER).
private
int number(ps str) {
    int len = cast(int) *cast(ubyte*) str;
    char* s = cast(char*)(str + 1);
    gNumberOk = 0;
    int rez = 0;

    int i = 0;
    int base = cast(int) gpcb.base;
    if (base < 2 || base > 36) base = 10;  // защита от повреждённого BASE

    if (i < len && (s[i] == '$' || s[i] == '%')) {
        base = (s[i] == '$') ? 16 : 2;
        i++;
    }

    bool neg = false;
    if (i < len && s[i] == '-') { neg = true; i++; }

    if (i >= len) {
        // пустая строка (или только знак/префикс без цифр) - не число
        reportNotFound(str, len);
        return 0;
    }

    for (; i < len; i++) {
        int d = digitValue(s[i]);
        if (d < 0 || d >= base) {
            reportNotFound(str, len);
            return 0;
        }
        rez = rez * base + d;
    }

    gNumberOk = 1;
    return neg ? -rez : rez;
}
private
void reportNotFound(ps str, int len) {
    version(ForthNoConsole) {
        // GUI-вариант: не печатаем; признак ошибки разбора - gNumberOk
    } else {
        import std.conv: to;
        writeln("Not find word [", cast(string) str[1 .. 1 + len], "]");
    }
}
private
int d_numberOk() { return gNumberOk; }
// Контракт со f_inter (метка m2): EAX = флаг успеха, под ним на стеке - число.
// Флаг снимается там через h_DROP, число остаётся в EAX.
private
void h_NUMBER() {
    asm {	naked;
		call number;  // EAX = число (или 0 при ошибке)
		mov EBX, EAX;  // спасти число (EBX сохраняется D-функциями)
		call d_numberOk;  // EAX = флаг 0/1
		lea EBP, [EBP-CELL];  // положить число на стек данных под флаг
		mov dword ptr SS:[EBP], EBX;
		ret;
    }
}

private
void tck(int n) {
    version(ForthNoConsole) {
        // GUI-вариант: вывод в консоль отключён
    } else {
        writeln(n);
    }
}
private
void h_tck() {
    asm {	naked;
		call tck;
		jmp h_DROP;
        // ret;
    }
}

// Формат словарной статьи (унифицирован для CreateVocItem и h_createST):
//   NFA+0        : len
//   NFA+1..len   : имя
//   NFA+1+len    : 0
//   NFA+2+len    : len (повтор; пишется WORD/CreateVocItem)
//   NFA+3+len    : imm
//   NFA+4+len    : LFA
//   NFA+8+len    : CFA
// Слова-навигаторы (бутстрап):
//   CFA>LFA = CFA-4
//   CFA>NFA = CFA-len-8
//   NFA>LFA = NFA+len+4
//   LFA>NFA = LFA-len-4 (через CFA>NFA)
//   NFA>CFA = NFA+len+8
//
// Часть слова CREATE ( Astr -- ) Создаёт словарную статью, с LFA, но дальше ни чего не делает
// т.к. дальнейшее изготовление кода последует позже
private
void h_createST(ps name) {
    pb con_tmp = gpcb.here;  // Контекст на начало Here
    // Нужно обойти имя
    gpcb.here = gpcb.here + (*gpcb.here + 3);  // Перейти на Imm
    *gpcb.here = cast(ubyte) 0;                // запись Immediate
    gpcb.here = gpcb.here + 1;                 // обходим Imm

    // Тут надо подумать. В этот момент context ulfa показывает на вектор
    ubyte b1b = *(name + 1);  // смещение в векторе context
    pp[256]* vect = cast(pp[256]*) gpcb.context;
    // printf("[%s]  - %d\n", name, b1b);
    // writeln("[", cast(string)name ,"] b1b = ", b1b);
    *cast(pp)(gpcb.here) = (*vect)[b1b];  // запись LFA, то что лежало в ячейке vect[69]

    // *cast(pp)(gpcb.here) = cast(pp)gpcb.context;	// запись LFA
    // gpcb.context = cast(pp)con_tmp;
    (*vect)[b1b] = cast(pp) con_tmp;  // фактически управляем Context

    gpcb.here = gpcb.here + CELL;  // обходим LFA
}
private
void h_CREATE() {
    asm {	naked;
		call f_BL;  // Положить на стек 32 0x20;             ... 7 32
		call f_word;
		call h_createST;
		call h_DROP;
		call h_HERE;
		call h_LATEST;
		jmp h_setToAdr;
                         // ret;
    }
}
// CODE : ( слово читает имя из входного потока и создаёт новое слово )
private
void h_dwoetoc() {
    asm {	naked;
		call h_CREATE;
		jmp h_COMP_ON;
        // ret;
    }
}
// CODE ; ( заканчивает компиляцию слова начатаю : )
private
void h_tckzpt() {
    asm {	naked;
		call h_RETzpt;
		jmp h_COMP_OFF;
        // ret;
    }
}
// Создаёт список в кодофайле начальных "hard" слов
private
void CreateVocItem(ps name, pp ucfa, p ulfa, ubyte imm = 0) {
    //   ps name - указатель на строку со счетчиком (имея,типа \4gena)
    //   p ucfa - указатель на процедуру C++
    //   p ulfa - указатель на предыдущее слово ( NFA )
    //   unsigned char imm - признак Immediate (+1=немедленная,0=обычная)

import core.stdc.string:memcpy;
    // import asc1251;
    // Отладочное слово
    /* 	writeln(toCON("Начало кодофайла = "), cast(uint)gpcb.akdf);
            writeln(toCON("НERE показывает  = "), cast(uint)gpcb.here);
            writeln(toCON("ulfa показывает  = "), cast(uint)*cast(pp)ulfa);
     */
    pb con_tmp = gpcb.here;              // Контекст на начало Here
    int dlina = *name;                   // Запомним длину имени созд слова
    memcpy(gpcb.here, name, dlina + 1);  // копируем строку по Here
    // uprString(ps(mTakeHERE));				// конвертируем в большие быквы
    gpcb.here = gpcb.here + dlina + 1;  // сдвигаем Here за имя
    *gpcb.here = 0;                     // Пишем 0
    gpcb.here = gpcb.here + 1;          // обходим 0
    *gpcb.here = cast(ubyte) dlina;     // запись длины имени
    gpcb.here = gpcb.here + 1;          // обходим длину имени
    *gpcb.here = cast(ubyte) imm;       // запись Immediate
    gpcb.here = gpcb.here + 1;          // обходим Imm

    // Тут надо подумать. В этот момент context ulfa показывает на вектор
    ubyte b1b = *(con_tmp + 1);  // смещение в векторе context
    pp[256]* vect = cast(pp[256]*) gpcb.context;
    *cast(pp)(gpcb.here) = (*vect)[b1b];  // запись LFA, то что лежало в ячейке vect[69]

    // (*vect)[b1b] = cast(pp)7;
    // writeln(toCON("Записываю в (*vect)[b1b] по адресу = "), cast(uint)&((*vect)[b1b]), "     b1b = ", b1b);

    gpcb.here = gpcb.here + CELL;                                         // обходим LFA
    gpcb.latest = cast(pp)(gpcb.here);                                    // запомним LATEST
    *gpcb.here = cast(ubyte) 0xE9;                                        // компиляция кода JMP
    gpcb.here = gpcb.here + 1;                                            // обходим JAMP
    *cast(pp)(gpcb.here) = cast(pp)(cast(pb) ucfa - (gpcb.here + CELL));  // и смещения для JMP
    gpcb.here = gpcb.here + CELL;                                         // обходим CFA
    //    *cast(pp)ulfa = cast(pp)con_tmp;			// фактически управляем Context
    (*vect)[b1b] = cast(pp) con_tmp;  // фактически управляем Context
}

// Выдать 1 - если строки равны
private
int cmpString(const char* s1, const char* s2) {
    char* s11 = cast(char*) s1;
    char* s22 = cast(char*) s2;
    byte d1 = cast(byte) * s11++;
    byte d2 = cast(byte) * s22++;
    if (d1 != d2) return 0;
    for (int i = 0; i < d1; i++) {
        if (*s11 != *s22) return 0;
        s11++;
        s22++;
    }
    return 1;
}

