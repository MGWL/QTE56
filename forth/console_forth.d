//------------------------------
// Чисто консольный вариант forthD (cmd.exe), без QtE5
// REPL: читает строку, выполняет evalForth(), показывает стек
//------------------------------
import core.sys.windows.windows;
import std.stdio;
import std.conv;
import std.string: strip, chomp;
import std.file: exists;
import std.datetime.stopwatch: StopWatch;
import forth;			// Сам forth написан на 32 разрядном D (asm)

// dmd -m32 forth.d console_forth.d -Luser32.lib -ofconsole_forth.exe

// Мост для REPL на Форте (repl.f): выполнить строку Форта и сразу,
// пока Форт-код REPL'а не потоптал память стека данных, напечатать
// состояние стека (тот же момент времени, что в D-цикле ниже).
// Возвращает время выполнения строки в мкс.
extern (C) int evalC(char* s) {
	StopWatch sw; sw.start();
	evalForth(s);
	sw.stop();
	writeln();
	writeln(showSD());
	return cast(int)sw.peek().total!"usecs";
}

// Загрузить и выполнить файл Форта (построчно). Раньше это делало слово
// INCLUDED в ядре; загрузка файлов перенесена на сторону хоста.
void includedForth(string name) {
	File f = File(name, "r");
	foreach(line; f.byLine()) {
		if(cast(string)line == "__EOF__") break;
		evalForth(cast(string)line);
	}
}

// Дамп 256 байт памяти (для отладки структур слов): вызывается из Форта
// как cdecl-функция с одним аргументом (см. setCommonAdr(21) в main).
extern(C) void dumpMem(void* p) {
	ubyte* u = cast(ubyte*)p;
	for(int i = 0; i < 16; i++) {
		writef("%08X: ", cast(uint)(u + i*16));
		for(int j = 0; j < 16; j++) writef("%02X ", cast(uint)u[i*16+j]);
		writeln();
	}
}

// ================== D-обработчик окна (замена мосту) ==================
// Оконная процедура целиком на D - легальный контекст Windows: рамка,
// заголовок, кнопки, перемещение и WM_PAINT рисует/обрабатывает сама
// система через DefWindowProc. Из колбэка НИЧЕГО форта-специфичного не
// нужно: WM_DESTROY -> PostQuitMessage (законен внутри обычного WndProc),
// PUMP выходит по GetMessageA=0. События для Форта (если понадобятся):
// WndProc может PostMessage(WM_USER+n), PUMP диспетчеризует их фортовым
// словам - реакции в легальном контексте цикла.
extern(Windows) uint wndProcD(uint hwnd, uint msg, uint wp, uint lp) nothrow {
	if (msg == 2) PostQuitMessage(0);  // WM_DESTROY
	return DefWindowProcA(cast(HWND)hwnd, cast(UINT)msg, cast(WPARAM)wp, cast(LPARAM)lp);
}

// Старый мост wndProcBridge (GSAVE/ячейки 13/14), D-прокси d_CallFn4
// (ячейка 17) и отладочный wpcLog (ячейка 22) УДАЛЕНЫ: настоящие callback'и
// в Форт делает thunk-механизм MK-WINAPI-CB/MK-CDECL-CB + cbBridge
// (см. callback.md).

// Состояние стека данных (как showSD() в Qt-консоли)
string showSD() {
	string str, str1;
	// Дно стека
	pp a = cast(pp)adr_cSD;
	// Указатель стека
	pp b = cast(pp)adr_SD;
	// Разница
	auto r = a - (b-2);
	str = "[" ~ to!string(r) ~ "]-> ";
	if(r == 0) {
			// Стек пуст
	} else {
		if(r > 0) {
			// На стеке элементы ...
			for(int i; i != r; i++) {
				str1 ~= (to!string( cast(int)*(a-i) ) ~ "  ");
			}
		}
	}
	return str ~ str1;
}

// Обойти весь словарь и вернуть имена всех определённых слов (имена в cp1251)
string[] getAllWordsForth() {
	string[] rez;
	// Вектор из 256 цепочек словаря, по первому байту имени слова
	pp[256]* mContext = cast(pp[256]*)adrContext();
	for(int c; c != 256; c++) {
		ps nfa = cast(ps)(*mContext)[c]; // Мы на первом слове в цепочке
		while(nfa !is null) {
			rez ~= to!string(nfa + 1);	// Имя слова (asciiz сразу за байтом длины)
			// Идем на следующее слово в цепочке словаря (LFA)
			nfa = cast(ps)(*cast(pp)(nfa + (*nfa + 4)));
		}
	}
	return rez;
}

// ---------------- SEE: декомпилятор слов Форта ----------------
// Формат словарной статьи (h_createST в forth.d):
//   NFA -> [len:1][имя:len][0:1][len:1][imm:1][LFA:4][машинный код...]
//   xt (CFA) = nfa + *nfa + 8
// По xt: у asm-слов ядра трамплин E9 rel32 (JMP на D-функцию), у колонок
// сразу тело - цепочка E8 rel32, конец - голый байт 0xC3 (";" через RET,).

// Найти xt слова по имени (обход 256 цепочек словаря), null если нет
pb findXT(const(char)[] name) {
	pp[256]* mContext = cast(pp[256]*)adrContext();
	for(int c; c != 256; c++) {
		ps nfa = cast(ps)(*mContext)[c];
		while(nfa !is null) {
			if(to!string(nfa + 1) == name)
				return cast(pb)(nfa + (*nfa) + 8);
			nfa = cast(ps)(*cast(pp)(nfa + (*nfa + 4)));
		}
	}
	return null;
}

// Имя слова по адресу кода. Совпадение, если addr == xt слова ИЛИ
// addr == цель трамплина E9 (прямой вызов D-функции минуя трамплин -
// так f_inter компилирует литералы: call h_s_LIT_s). null если не нашли
string nameByAddr(pb addr) {
	pp[256]* mContext = cast(pp[256]*)adrContext();
	for(int c; c != 256; c++) {
		ps nfa = cast(ps)(*mContext)[c];
		while(nfa !is null) {
			pb xt = cast(pb)(nfa + (*nfa) + 8);
			if(xt == addr) return to!string(nfa + 1);
			if(*xt == 0xE9) {					// трамплин asm-слова
				pb tgt = xt + 5 + *cast(int*)(xt + 1);
				if(tgt == addr) return to!string(nfa + 1) ~ " (asm)";
			}
			nfa = cast(ps)(*cast(pp)(nfa + (*nfa + 4)));
		}
	}
	return null;
}

// SEE: разобрать тело слова по xt. Вызывается из repl.f:
//   : SEE ' >R SEED CALL_A RDROP DROP DROP ;
// Спецслова с inline-данными (иначе разбор рассинхронизируется):
//   (LIT)    + 4 байта число      (call идёт прямо на h_s_LIT_s!)
//   BRANCH, ?BRANCH + 4 байта смещение (dest = p+5+off, см. f_BRANCH)
//   (BOX)    + counted-строка (len+2 байта, см. бутстрап forth.d:2000)
//   (CREATE) + данные неизвестной длины -> печатаем и останавливаемся
extern (C) void seeC(void* pv) {
	if(pv is null) {					// слово не найдено (' вернул 0)
		writeln("-- SEE: xt = 0 (word not found)");
		return;
	}
	pb p = cast(pb)pv;
	writefln("-- SEE xt=0x%08X", cast(uint)p);
	if(*p == 0xE9) {						// asm-слово ядра
		writefln("0x%08X  JMP -> 0x%08X   (asm word)",
			cast(uint)p, cast(uint)(p + 5 + *cast(int*)(p + 1)));
		return;
	}
	// xt спецслов ищем один раз на входе (прямые адреса D-функций
	// недоступны - private, поэтому разрешение только через словарь)
	pb xtLIT = findXT("(LIT)");
	pb xtBR  = findXT("BRANCH");
	pb xtQBR = findXT("?BRANCH");
	pb xtBOX = findXT("(BOX)");
	pb xtCRE = findXT("(CREATE)");
	// цель t совпала со словом? (и с xt, и с целью его трамплина)
	bool hit(pb xt, pb t) {
		return xt !is null &&
			(t == xt || (*xt == 0xE9 && t == xt + 5 + *cast(int*)(xt + 1)));
	}
	for(int n; n != 500; n++) {				// лимит от зацикливания
		ubyte op = *p;
		if(op == 0xC3) {					// RET - конец слова
			writefln("0x%08X  EXIT", cast(uint)p);
			return;
		}
		if(op == 0xE9) {					// хвостовой JMP (DOES>)
			pb t = p + 5 + *cast(int*)(p + 1);
			string nm = nameByAddr(t);
			writefln("0x%08X  JMP -> 0x%08X %s", cast(uint)p, cast(uint)t,
				nm is null ? "?" : nm);
			return;
		}
		if(op != 0xE8) {					// не CALL - рассинхрон
			writefln("0x%08X  ?? byte %02X - parsing stopped",
				cast(uint)p, op);
			return;
		}
		pb t = p + 5 + *cast(int*)(p + 1);	// цель CALL
		if(hit(xtLIT, t)) {					// (LIT) + 4 байта число
			writefln("0x%08X  (LIT) %d", cast(uint)p, *cast(int*)(p + 5));
			p += 9;
			continue;
		}
		if(hit(xtBR, t) || hit(xtQBR, t)) {	// ветвление + 4 байта смещение
			int off = *cast(int*)(p + 5);
			writefln("0x%08X  %s %+d -> 0x%08X", cast(uint)p,
				hit(xtQBR, t) ? "?BRANCH" : "BRANCH",
				off, cast(uint)(p + 5 + off));
			p += 9;
			continue;
		}
		if(hit(xtBOX, t)) {					// (BOX) + counted-строка
			pb s = p + 5;
			writefln(`0x%08X  (BOX) "%s"`, cast(uint)p,
				cast(string)((s + 1)[0 .. *s]));
			p = s + (*s) + 2;
			continue;
		}
		if(hit(xtCRE, t)) {					// (CREATE) + данные: стоп
			writefln("0x%08X  (CREATE) ... data follows - parsing stopped",
				cast(uint)p);
			return;
		}
		string nm = nameByAddr(t);
		if(nm is null)
			writefln("0x%08X  call 0x%08X (?)", cast(uint)p, cast(uint)t);
		else
			writefln("0x%08X  %s", cast(uint)p, nm);
		p += 5;
	}
	writeln("-- stopped at 500 instruction limit");
}

int main(string[] args) {
	// Активизируем Форт
	initForth();
	// Стандартная библиотека грузится сразу при инициализации
	if(exists("stdlib.f")) includedForth("stdlib.f");

	// Адрес для repl.f (REPL на Форте) - ДО загрузки файлов из аргументов:
	// repl.f читает ячейку 10 общей таблицы в момент своей загрузки
	setCommonAdr(10, cast(pp)&evalC);			// evalC(char*) -> мкс, печатает стек
	setCommonAdr(11, cast(pp)&seeC);			// seeC(xt) - декомпилятор SEE
	setCommonAdr(21, cast(pp)&dumpMem);		// dumpMem(addr) - дамп 256 байт для отладки
	setCommonAdr(15, cast(pp)&wndProcD);			// WndProc окна - на D (легальный контекст; см. wndProcD)

	// Аргументы командной строки: файлы *.f для INCLUDE
	foreach(arg; args[1 .. $]) {
		if(!exists(arg)) {
			writeln("Not found file for INCLUDE: [", arg, "]");
			continue;
		}
		includedForth(arg);
		writeln("INCLUDED ", arg);
	}

	writeln("--- forthD console (32 bit) ---  BYE - exit");
	// Если загружен repl.f, слово REPL забирает управление и не возвращается
	// (выход - слово BYE или EOF). Иначе ниже работает старый цикл на D.
	evalForth("REPL");
	// Цикл REPL
	for(;;) {
		write("F> "); stdout.flush();
		string line = readln();
		if(line is null) break;				// Ctrl+Z / конец потока
		line = chomp(line);
		if(strip(line) == "") continue;
		if(line == "BYE" || line == "bye") break;
		if(line == "WORDS") {					// Список всех слов словаря
			string[] mWords = getAllWordsForth();
			foreach(w; mWords) write(w, "  ");
			writeln("\n-- ", mWords.length, " words");
			continue;
		}
		try {
			evalForth(line);
			writeln();
			writeln(showSD());
		} catch(Throwable e) {
			writeln("\nError: ", e.msg);
		}
	}
	return 0;
}
