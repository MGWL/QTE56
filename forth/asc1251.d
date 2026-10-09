/*
 23.05.2026 10:03 - countCodePoints количество Unicode-символов
 22.01.2019 13:06 - Модификация снился по 32 и 64 разрядную модификацию
 26.05.2019 09:09 - Исправлена ошибка при выводе 1Csh ( a[123] -выкид одиночные скобки )
 20.07.2018 10:12 - секций/шаблонов + date
 07.07.2018 10:12 - Добавлен алгоритм секций/шаблонов
 19.03.2018 12:58 - Применен алгоритм Максима Шибнева для fromUtf8to1251 (3-x кратное ускорение)
 01.12.2017 17:57 - Темплате на toCON
 13.08.2017  6:32 - Проверка и ускорение cp1251 -- Utf-8 -- cp1251
 21.04.2016 18:13 - Проверка ИНН на корректность
 31.05.2014 7:36:58
 Add x64
 Repair LTrim and RTrim
 */
/*
 ё - 184  0451  d1-91
 Ё - 168  0401  d0-81
 » -      00BB
 « -      00AB
 */
module asc1251;

import std.ascii;
import std.conv;
import std.utf;
import std.datetime;
import std.string: split;

// import std.stdio;


/// Возвращает true если символ является цифрой 0–9
bool isDigit1251(char c)	pure nothrow { return (mm1251[c] & tDigit) != 0; }

/// Возвращает true если символ является строчной буквой латинского алфавита (a–z)
bool isLower1251E(char c)	pure nothrow { return (mm1251[c] & tEl) != 0;    }

/// Возвращает true если символ является заглавной буквой латинского алфавита (A–Z)
bool isUpper1251E(char c)	pure nothrow { return (mm1251[c] & tEu) != 0;    }

/// Возвращает true если символ является строчной русской буквой в CP1251 (а–я, ё)
bool isLower1251R(char c)	pure nothrow { return (mm1251[c] & tRl) != 0;    }

/// Возвращает true если символ является заглавной русской буквой в CP1251 (А–Я, Ё)
bool isUpper1251R(char c)	pure nothrow { return (mm1251[c] & tRu) != 0;    }

/// Возвращает true если символ является латинской буквой (A–Z или a–z)
bool isLetters1251E(char c)	pure nothrow { return (mm1251[c] & (tEu + tEl)) != 0; }

/// Возвращает true если символ является русской буквой в CP1251 (А–Я, а–я, Ё, ё)
bool isLetters1251R(char c)	pure nothrow { return (mm1251[c] & (tRu + tRl)) != 0; }

/// Возвращает true если символ является буквой — латинской или русской
bool isLetters1251(char c)	pure nothrow { return (mm1251[c] & (tRu + tRl + tEu + tEl)) != 0; }

/// Возвращает true если символ является «печатным» (код ≥ 33, не пробел и не управляющий).
/// Используется в Trim-функциях как признак значащего символа.
bool isPrintLetters1251(char c) pure nothrow {	return (mm1251[c] & (tPrint)) != 0; }

unittest {
	foreach (char c; "0123456789")
		assert(asc1251.isDigit1251(c));
	foreach (char c; lowercase)
		assert(asc1251.isLower1251E(c));
	foreach (char c; uppercase)
		assert(asc1251.isUpper1251E(c));
	foreach (char c; lowercase1251R)
		assert(asc1251.isLower1251R(c));
	foreach (char c; uppercase1251R)
		assert(asc1251.isUpper1251R(c));
	foreach (char c; uppercase ~ lowercase)
		assert(asc1251.isLetters1251E(c));
	foreach (char c; uppercase1251R ~ lowercase1251R)
		assert(asc1251.isLetters1251R(c));
	// isLetters1251 — латинские и русские буквы
	assert(isLetters1251('A'));
	assert(isLetters1251('z'));
	assert(isLetters1251('\xC0')); // А (CP1251)
	assert(isLetters1251('\xE0')); // а (CP1251)
	assert(!isLetters1251('1'));
	assert(!isLetters1251('!'));
	assert(!isLetters1251(' '));
	// isPrintLetters1251 — всё кроме управляющих и пробела
	assert(isPrintLetters1251('!'));
	assert(isPrintLetters1251('A'));
	assert(isPrintLetters1251('5'));
	assert(isPrintLetters1251('\xC0')); // А (CP1251)
	assert(!isPrintLetters1251('\x01'));
	assert(!isPrintLetters1251('\x00'));
	assert(!isPrintLetters1251(' '));   // пробел (32) — tBad
}

/// Удаляет непечатные символы (пробелы, управляющие коды) в начале строки CP1251.
/// Возвращает срез исходного буфера — без копирования.
char[] LTrim1251(char[] str) {
	char[] rez;
	if (str.length == 0)
		return rez;
	for (auto i = 0; i < str.length; i++) {
		if (!isPrintLetters1251(str[i]))
			continue;
		rez = str[i .. $];
		break;
	}
	return rez;
}

/// Удаляет непечатные символы (пробелы, управляющие коды) в конце строки CP1251.
/// Возвращает срез исходного буфера — без копирования.
char[] RTrim1251(char[] str) {
	char[] rez;
	if (str.length == 0)
		return rez;
	for (auto i = str.length; i != 0; i--) {
		if (!isPrintLetters1251(str[i - 1]))
			continue;
		rez = str[0 .. i];
		break;
	}
	return rez;
}

/// Удаляет непечатные символы с обоих концов строки CP1251 (LTrim + RTrim).
char[] Trim1251(char[] str) {
	return LTrim1251(RTrim1251(str));
}

unittest {
	assert(LTrim1251(cast(char[]) "") == cast(char[]) "");
	assert(RTrim1251(cast(char[]) "") == cast(char[]) "");
	assert(LTrim1251(cast(char[]) "   Hello  ") == cast(char[]) "Hello  ");
	assert(RTrim1251(cast(char[]) "   Hello  ") == cast(char[]) "   Hello");
	assert(LTrim1251(cast(char[]) "   " ~ uppercase1251R) == cast(char[]) uppercase1251R);
	assert(LTrim1251(cast(char[]) "   " ~ lowercase1251R) == cast(char[]) lowercase1251R);
	assert(RTrim1251(lowercase1251R ~ cast(char[]) "   ") == cast(char[]) lowercase1251R);
	assert(Trim1251(cast(char[]) "   " ~ "1234567890" ~ "\x0E\x0F") == cast(char[]) "1234567890");
	assert(LTrim1251(cast(char[]) " " ~ cast(char[]) "1") == cast(char[]) "1");
}

/// Переводит один символ в верхний регистр (латинский или русский CP1251).
/// Работает для a–z → A–Z и а–я → А–Я (оба диапазона отстоят на 32 в таблице CP1251).
char toUpper1251(char c) {
	return isLower1251E(c) | isLower1251R(c) ? cast(char)(c - 32) : c;
}

/// Переводит строку CP1251 в верхний регистр (латиница + кириллица).
char[] toUpper1251(char[] str) {
	char[] rez;
	foreach (char c; str) {
		rez ~= toUpper1251(c);
	}
	return rez;
}

/// Переводит один символ в нижний регистр (латинский или русский CP1251).
char toLower1251(char c) {
	return isUpper1251E(c) | isUpper1251R(c) ? cast(char)(c + 32) : c;
}

/// Переводит строку CP1251 в нижний регистр (латиница + кириллица).
char[] toLower1251(char[] str) {
	char[] rez;
	foreach (char c; str) {
		rez ~= toLower1251(c);
	}
	return rez;
}

/// Форматирует слово «как ФИО»: первый символ — заглавный, остальные — строчные.
/// Используется для нормализации фамилий, имён, отчеств в CP1251.
char[] toFio1251(char[] str) {
	if (str.length == 0) {
		return str;
	} else {
		if (str.length == 1) {
			char[] rez;
			return rez ~= toUpper1251(str[0]);
		} else {
			return toUpper1251(str[0]) ~ toLower1251(str[1 .. $]);
		}
	}
}

unittest {
	assert(toUpper1251('a') == 'A');
	foreach (char c; lowercase)
		assert(toUpper1251(c) == std.ascii.toUpper(c));
	foreach (char c; lowercase1251R)
		assert(toUpper1251(c) == uppercase1251R[c - 224]);
	assert(toUpper1251(cast(char[]) "hello[23]") == "HELLO[23]");
	assert(toUpper1251(cast(char[]) "") == "");
	assert(toLower1251(cast(char[]) "17(HELLO)") == "17(hello)");
	assert(toFio1251(cast(char[]) "HELLO!!!") == "Hello!!!");
	assert(toFio1251(cast(char[]) "") == "");
	assert(toFio1251(cast(char[]) "a") == "A");
}

/// Возвращает подстроку по номеру поля (poz, начиная с 0), разделённую символом rz.
/// Аналог Split() из 1С: Split1251("A|B|C", '|', 1) → "B".
/// Если поле отсутствует — возвращает пустую строку.
char[] Split1251(char[] from, char rz, int poz) {
	char[] rez;
	int i, b, e, k;
	auto dLfrom = from.length;
	for (i = 0; i < dLfrom; i++) {
		if (from[i] == rz) {
			e = i;
			if (k == poz) {
				rez = from[b .. e]; // Есть начало и есть конец. Надо переписать
				return rez;
			} else {
				b = i + 1;
				k++;
			}
		}
	}
	if (poz == k)
		rez ~= from[b .. $];
	return rez;
}

unittest {
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 0) == "ABC");
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 1) == "DEF");
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 2) == "");
	assert(Split1251(cast(char[]) "ABC|DEF", '#', 2) == "");
	assert(Split1251(cast(char[]) "ABC|DEF", '#', 0) == "ABC|DEF");
}
/// Простой сдвиговый шифр для C-строки (AsciiZ) в буфере CP1251.
/// sh=true — зашифровать (каждый байт уменьшается на 1),
/// sh=false — расшифровать (каждый байт увеличивается на 1).
/// Модификация выполняется на месте (in-place) до NUL-терминатора.
/// Примечание: работает только с AsciiZ (null-terminated), не с D-слайсами.
void shifr(bool sh, char* str) {
	char ch;
	int z;

	if (sh) {
		z = -1;
	} else {
		z = +1;
	}
	for (char* i = str;; i++) {
		ch = *i;
		if (ch == 0)
			break;
		*i = cast(char)(ch + z);
	}
}
/* // Шифрует строки utf-8
 // T - зашифровать, F - расшифровать
 string shifr8(bool sh, string str) {
 string rez; ubyte b;
 if(str.length == 0) return rez;
 if(sh) {
 for(int i; i != str.length; i++) {
 b = cast(ubyte)str[i];
 if(b > 31) rez ~= "B" ~ (cast(char)(str[i]-1)); else rez ~= "A" ~ (cast(char)(str[i]+1));
 }
 }
 else {
 for(int i; i != str.length; i+=2) {
 b = cast(ubyte)str[i];
 if(b == 66) rez ~= (cast(char)(str[i+1]+1)); else rez ~= (cast(char)(str[i+1]-1));
 }
 }
 return rez;
 }
 */
 

/// Шифр для строк UTF-8 (или любых D-строк) — «безопасное» кодирование.
/// sh=true — зашифровать: каждый байт заменяется двумя: "B"+(byte-1) для кодов >31,
///           или "A"+(byte+1) для управляющих символов. Длина результата удваивается.
/// sh=false — расшифровать: обрабатывает пары байт ('B'→следующий+1, иначе следующий-1).
/// Шаблонный параметр T позволяет принимать string, char[], const(char)[] и т.п.
string shifr8n(T)(bool sh, T inStr) {
	string rez;
	ubyte b;
	string str = cast(string) inStr;
	if (str.length == 0) return rez;
	if (sh) {
		for (int i; i != str.length; i++) {
			b = cast(ubyte) str[i];
			if (b > 31)
				rez ~= "B" ~ (cast(char)(str[i] - 1));
			else
				rez ~= "A" ~ (cast(char)(str[i] + 1));
		}
	} else {
		for (int i; i != str.length; i += 2) {
			b = cast(ubyte) str[i];
			if (b == 66)
				rez ~= (cast(char)(str[i + 1] + 1));
			else
				rez ~= (cast(char)(str[i + 1] - 1));
		}
	}
	return rez;
}

unittest {
	// shifr — шифрование/дешифрование in-place (AsciiZ)
	char[] buf = "Hello\0".dup;
	shifr(true, buf.ptr);   // зашифровать: каждый байт -= 1
	assert(buf[0 .. 5] == "Gdkkn"); // H-1=G, e-1=d, l-1=k, l-1=k, o-1=n
	shifr(false, buf.ptr);  // расшифровать: каждый байт += 1
	assert(buf[0 .. 5] == "Hello");
	// пустая строка — без изменений
	char[] empty = "\0".dup;
	shifr(true, empty.ptr);
	assert(empty[0] == 0);

	// shifr8n — шифрование/дешифрование UTF-8 строк (длина удваивается при шифровании)
	assert(shifr8n(true, "") == "");
	assert(shifr8n(false, "") == "");
	// H=72>31 → "B"~cast(char)(72-1)="BG"; i=105>31 → "B"~cast(char)(105-1)="Bh"
	string enc = shifr8n(true, "Hi");
	assert(enc == "BGBh");
	string dec = shifr8n(false, enc);
	assert(dec == "Hi");
	// управляющий символ (код ≤ 31): '\x01' → "A"~'\x02'
	string enc2 = shifr8n(true, "\x01");
	assert(enc2[0] == 'A');
	assert(enc2[1] == '\x02');
	string dec2 = shifr8n(false, enc2);
	assert(dec2 == "\x01");
}

/// Перевод русского текста в транслитерал по алгоритму 1С 8.3.
/// Принимает UTF-8 строку, возвращает транслит UTF-8.
/// Ъ и Ь удаляются, Й/й → I/i, Ы/ы → I/i.
string translit(string s) {
	import std.string: replace;
	string str = s;
	str = str.replace("а","a");	str = str.replace("б","b");	str = str.replace("в","v");	str = str.replace("г","g");
	str = str.replace("д","d");	str = str.replace("е","e");	str = str.replace("ё","e");	str = str.replace("ж","zh");
	str = str.replace("з","z");	str = str.replace("и","i");	str = str.replace("к","k");	str = str.replace("л","l");
	str = str.replace("м","m");	str = str.replace("н","n");	str = str.replace("о","o");	str = str.replace("п","p");
	str = str.replace("р","r");	str = str.replace("с","s");	str = str.replace("т","t");	str = str.replace("у","u");
	str = str.replace("ф","f");	str = str.replace("х","h");	str = str.replace("ч","ch");	str = str.replace("ш","sh");
	str = str.replace("щ","sch");	str = str.replace("ъ","");	str = str.replace("ь","");	str = str.replace("э","e");
	str = str.replace("ю","yu");	str = str.replace("й","i");	str = str.replace("ц","c");	str = str.replace("я","ya");
	str = str.replace("ы","i");	str = str.replace("А","A");	str = str.replace("Б","B");	str = str.replace("В","V");
	str = str.replace("Г","G");	str = str.replace("Д","D");	str = str.replace("Е","E");	str = str.replace("Ё","E");
	str = str.replace("Ж","ZH");	str = str.replace("З","Z");	str = str.replace("И","I");	str = str.replace("К","K");
	str = str.replace("Л","L");	str = str.replace("М","M");	str = str.replace("Н","N");	str = str.replace("О","O");
	str = str.replace("П","P");	str = str.replace("Р","R");	str = str.replace("С","S");	str = str.replace("Т","T");
	str = str.replace("У","U");	str = str.replace("Ф","F");	str = str.replace("Х","H");	str = str.replace("Ч","CH");
	str = str.replace("Ш","SH");	str = str.replace("Щ","SCH");	str = str.replace("Ъ","");	str = str.replace("Ь","");
	str = str.replace("Ы","I");	str = str.replace("Ц","C");	str = str.replace("Э","E");	str = str.replace("Ю","YU");
	str = str.replace("Я","YA");	str = str.replace("Й","I");
	return str;
}

/// Преобразует строку вида "26.02.1916" (дд.мм.гггг) в тип std.datetime.Date.
/// При ошибке разбора возвращает Date(0, 0, 0) — внимание: Date может бросить исключение
/// при невалидных значениях; для надёжности используйте только корректные даты.
Date strToDate(string s) {
	int y, m, d;
	try {
		auto mm = split(s, "."); d = to!int(mm[0]); m = to!int(mm[1]); y = to!int(mm[2]);
	} catch(Throwable) {		d = 0; m = 0; y = 0;  	}
	return Date(y, m, d);
}

/// Проверяет, входит ли дата dk в период [d1, d2).
/// dk, d1, d2 — строки вида "дд.мм.гггг".
/// Если d1 или d2 пустые — возвращает true (период не ограничен).
/// Возвращает true если d1 ≤ dk < d2.
bool isSupport(string dk, string d1, string d2) {
	bool rez;
	if(d1.length == 0) 	return true;
	if(d2.length == 0) 	return true;
	Date ddk, dd1, dd2;	ddk = strToDate(dk);	 dd1 = strToDate(d1); dd2 = strToDate(d2);
	rez = (dd1 <= ddk) && (ddk < dd2);
	return rez;
}

/// Движок шаблонов «секция + замена» (упрощённый, без дат).
/// strShablon — текст шаблона, каждая строка имеет формат: "секция|содержимое".
/// nameSection — имя секции для выборки строк.
/// dict — словарь подстановки: [[ключ]] заменяется на dict[ключ].
/// Строки других секций игнорируются. Возвращает все строки нужной секции,
/// объединённые символом '\n', с выполненными подстановками.
/*
string shablonHtmlFile = 
`
    head1|  [[zg2]]Вопрос №</td>
    head1|  [[zg2]]Количество выборов</td>
    head1|  [[zg2]]Средний % истинности</td>
    head1|  [[zg2]]Среднее время в Сек</td>
    head1| </tr>
 strTable| <tr align="center">
 strTable|  [[zg2]][[vprosN]]</td>
 strTable|  [[zg2]][[kolPoint]]</td>
 strTable|  [[zg2]][[sredProc]]</td>
 strTable|  [[zg2]][[sredSek]]</td>
 strTable| </tr>
   podval|</table>
   podval|</body>
   podval|</html>
`;
*/
string sh1c(string strShablon, string nameSection, string[string] dict) {
	import std.string: split, join, strip;
	string rez;
	// Проверки входных параметров
	if(strShablon == "") return rez;
	if(nameSection == "") return rez;
	// Разделение шаблона
	auto strSh2 = split(strShablon, "\n");
	string[] rez2;
	int iSost; char predCh = 0;
	foreach(str; strSh2) {
		if(strip(str) == "") continue;
		auto fields = split(str, "|");
		string sek = strip(fields[0]); string nameField, strOut;
		if(sek == nameSection) {	
			foreach(ch; fields[1]) {
				if(iSost == 0) {
					if( (ch == 10)  || (ch == 13)) continue;
					if(ch == '[') iSost = 1;
				} else {
					if(iSost == 1) { if(ch == '[') 	iSost = 2; else	{ strOut ~= '['; iSost = 0;  nameField = ""; }
					} else {
						if(iSost == 2) {	if(ch == ']') { { iSost = 0; nameField = ""; }
							} else {	iSost = 3;
							}
						} else {
							if(iSost == 3) {	if(ch == ']')  iSost = 4;
							} else {
								if(iSost == 4) { if(ch == ']')  iSost = 5; else { iSost = 0; nameField = ""; }
								} else {	if(iSost == 5) { if(ch == '[') iSost = 1; else { iSost = 0; } nameField = "";	}}
							}
						}
					}
				}
				if(iSost == 0) strOut ~= ch;
				if(iSost == 3) nameField ~= ch;
				if(iSost == 5) { auto p = (nameField in dict); if (p !is null) strOut ~= dict[nameField]; }
				predCh = ch;
			}
			rez2 ~= strOut;
		}
	}
	rez = join(rez2, "\n"); 	return rez;
}

/// Движок шаблонов «секция + дата + замена» (полная версия).
/// strShablon — текст шаблона; каждая строка: "секция|дата_нач|дата_кон|содержимое".
/// nameSection — имя секции для выборки.
/// td — текущая дата ("дд.мм.гггг"); пустая строка отключает фильтр по датам.
/// dict — словарь подстановки [[ключ]] → значение.
/// Строки с секцией "@alias" добавляют значение в словарь (если ключ ещё не задан).
/// Строки с секцией "#..." считаются комментариями и игнорируются.
/*
string shablonHtmlFile = 
`
    @test|01.01.2000|01.01.2900|" This is wstavka "
    head1|01.01.2000|01.01.2900|  [[zg2]]Вопрос №</td>
    head1|01.01.2000|01.01.2900|  [[zg2]]Количество выборов</td>
    head1|01.01.2000|01.01.2900|  [[zg2]]Средний % истинности</td>
    head1|01.01.2030|01.01.2900|  [[zg2]]Среднее время в Сек[[test]]</td>
    head1|01.01.2000|01.01.2900| </tr>
 strTable|01.01.2000|01.01.2900| <tr align="center">
 strTable|01.01.2000|01.01.2900|  [[zg2]][[vprosN]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[kolPoint]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[sredProc]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[sredSek]]</td>
 strTable|01.01.2000|01.01.2900| </tr>
   podval|01.01.2000|01.01.2900|</table>
   podval|01.01.2000|01.01.2900|</body>
   podval|01.01.2000|01.01.2900|</html>
`;
*/
string shd1c(string strShablon, string nameSection, string td, string[string] dict) {
	import std.string: split, join, strip;
	string strip_td = strip(td);
	string rez;
	// Проверки входных параметров
	if(strShablon == "") return rez;
	if(nameSection == "") return rez;
	// Разделение шаблона
	auto strSh2 = split(strShablon, "\n");
	string[] rez2;
	int iSost; char predCh = 0;
	foreach(str; strSh2) {
		if(strip(str) == "") continue;
		auto fields = split(str, "|");
		string sek = strip(fields[0]); string nameField, strOut;
		if(sek == "") continue;
		if(sek == nameSection) {
			// Проверим дату вхождения
			if(strip_td != "") { if( !isSupport(td, strip(fields[1]), strip(fields[2]))  ) { continue; } }
			foreach(ch; fields[3]) {
				if(iSost == 0) {
					if( (ch == 10)  || (ch == 13)) continue;
					if(ch == '[') iSost = 1;
				} else {
					if(iSost == 1) { if(ch == '[') 	iSost = 2; else	{ strOut ~= '['; iSost = 0;  nameField = ""; }
					} else {
						if(iSost == 2) {	if(ch == ']') { { iSost = 0; nameField = ""; }
							} else {	iSost = 3;
							}
						} else {
							if(iSost == 3) {	if(ch == ']')  iSost = 4;
							} else {
								if(iSost == 4) { if(ch == ']')  iSost = 5; else { iSost = 0; nameField = ""; }
								} else {	if(iSost == 5) { if(ch == '[') iSost = 1; else { iSost = 0; } nameField = "";	}}
							}
						}
					}
				}
				if(iSost == 0) strOut ~= ch;
				if(iSost == 3) nameField ~= ch;
				if(iSost == 5) { auto p = (nameField in dict); if (p !is null) strOut ~= dict[nameField]; }
				predCh = ch;
			}
			rez2 ~= strOut;
		} else {
			if( sek[0] == '@' ) {	// Алиас
				if(strip_td != "") if( !isSupport(td, strip(fields[1]), strip(fields[2]))  ) { continue; }
				string nf = sek[1 .. $];
				auto p = (nf in dict); if(p is null) dict[nf] = strip(fields[3]);  // Дозапись в словарь алиаса
			} else {
				if( sek[0] == '#' ) continue;  // Комментарий
			}
		}
	}
	rez = join(rez2, "\n"); 	return rez;
}

unittest {
	assert(translit("") == "");
	assert(translit("Иванова Мария Константиновна") == "Ivanova Mariya Konstantinovna");
	assert(translit("Иванова Мария Константиновна") == "Ivanova Mariya Konstantinovna");
	assert(translit("АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя0123456789")
	== "ABVGDEZHZIIKLMNOPRSTUFHCCHSHSCHIEYUYAabvgdezhziiklmnoprstufhcchshschieyuya0123456789");
	assert(sh1c("s1|[[F]] [[I]]", "s1", ["F":"Иванова","I":"Мария"]) == "Иванова Мария");

	// strToDate — разбор строки вида "дд.мм.гггг"
	auto d = strToDate("26.02.1916");
	assert(d.year == 1916 && d.month == 2 && d.day == 26);
	auto d2 = strToDate("01.01.2000");
	assert(d2.year == 2000 && d2.month == 1 && d2.day == 1);

	// isSupport — проверка попадания даты в период
	assert(isSupport("15.06.2020", "01.01.2020", "01.01.2021") == true);
	assert(isSupport("15.06.2020", "01.07.2020", "01.01.2021") == false); // до начала
	assert(isSupport("01.01.2021", "01.01.2020", "01.01.2021") == false); // граница (< d2)
	assert(isSupport("15.06.2020", "",            "01.01.2021") == true);  // d1 пустой
	assert(isSupport("15.06.2020", "01.01.2020", "")            == true);  // d2 пустой

	// shd1c — шаблон с фильтрацией по датам
	string t = "s1|01.01.2000|01.01.2900|[[X]] done";
	assert(shd1c(t, "s1", "15.06.2020", ["X":"ok"]) == "ok done");
	assert(shd1c(t, "s1", "",            ["X":"ok"]) == "ok done"); // пустая дата — без фильтра
	assert(shd1c(t, "s2", "15.06.2020", ["X":"ok"]) == "");         // другая секция
	// дата вне периода — строка не попадает
	string t2 = "s1|01.01.2025|01.01.2030|val";
	assert(shd1c(t2, "s1", "15.06.2020", null) == "");
	// алиас @name добавляется в словарь и используется в подстановке
	string t3 = "@lbl|01.01.2000|01.01.2900| Hello\ns1|01.01.2000|01.01.2900|[[lbl]]";
	assert(shd1c(t3, "s1", "15.06.2020", null) == "Hello");
}

/// Проверяет корректность даты в CP1251-строке формата "дд.мм.гггг".
/// Требования: ровно 10 символов, день 1–31, месяц 1–12, год 1901–2999.
/// Не проверяет реальную существование дня в месяце (напр., 31.02 пройдёт).
bool TestDate1251(char[] str) {
	bool rez = true;
	char[] s;
	char r = '.';
	if (str.length != 10)
		return false;
	s = Split1251(str, r, 0);
	if (s.length != 2)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]))
			return false;
		int day = to!int(s);
		if (!(day > 0 && day < 32))
			return false;
	}
	s = Split1251(str, r, 1);
	if (s.length != 2)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]))
			return false;
		int mes = to!int(s);
		if (!(mes > 0 && mes < 13))
			return false;
	}
	s = Split1251(str, r, 2);
	if (s.length != 4)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]) || !isDigit1251(s[2]) || !isDigit1251(s[3]))
			return false;
		int yar = to!int(s);
		if (!(yar > 1900 && yar < 3000))
			return false;
	}
	return rez;
}

/// Проверяет, соответствует ли строка CP1251 формату «Фамилия И.О.»
/// (одно слово: первая буква заглавная, затем строчные, пробел, два инициала с точками).
/// Пример: "Иванов А.Н." или "Ivanov A.N." — true.
bool isFioii1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length < 6)
		return false;
	if (!(isUpper1251E(str[0]) || isUpper1251R(str[0])))
		return false;
	if (!((str[$ - 1] == '.') && (str[$ - 3] == '.')))
		return false;
	if (!(isUpper1251E(str[$ - 2]) || isUpper1251R(str[$ - 2])))
		return false;
	if (!(isUpper1251E(str[$ - 4]) || isUpper1251R(str[$ - 4])))
		return false;
	if (!(str[$ - 5] == ' '))
		return false;
	if (str.length > 6)
	foreach (char c; str[1 .. $ - 6]) {
		if (!(isLower1251E(c) || isLower1251R(c)))
			return false;
	}
	return rez;
}

/// Проверяет одно слово на формат ФИО: первая буква заглавная, остальные строчные.
/// Работает для латиницы и кириллицы CP1251. Пример: "Иванов", "Gena" — true.
bool isFio1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length == 0)
		return false;
	if (!(isUpper1251E(str[0]) || isUpper1251R(str[0])))
		return false;
	foreach (char c; str[1 .. $]) {
		if (!(isLower1251E(c) || isLower1251R(c)))
			return false;
	}
	return rez;
}
/// Проверяет, состоит ли строка CP1251 только из цифр (целое неотрицательное число).
/// Пустая строка → false. Пробелы, знаки, точки → false.
bool isInt1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length == 0)
		return false;
	foreach (char c; str[0 .. $]) {
		if (!isDigit(c))
			return false;
	}
	return rez;
}

unittest {
	assert(TestDate1251(cast(char[]) "12.10.1961") == true);
	assert(TestDate1251(cast(char[]) "10.10.161") == false);
	assert(TestDate1251(cast(char[]) "00.10.1621") == false);
	assert(TestDate1251(cast(char[]) "31.10.1621") == false);
	assert(TestDate1251(cast(char[]) "32.10.2001") == false);
	assert(TestDate1251(cast(char[]) "31.12.1621") == false);
	assert(TestDate1251(cast(char[]) "31.13.2621") == false);
	assert(TestDate1251(cast(char[]) "31.13.3001") == false);
	// ------------------
	assert(isFio1251(cast(char[]) "Gena") == true);
	assert(isFio1251(cast(char[]) "Ge na") == false);
	assert(isFio1251(cast(char[]) "\xC3\xE5\xED\xE0") == true); // Гена (CP1251)
	assert(isFio1251(cast(char[]) "GenA") == false);
	assert(isFio1251(cast(char[]) "\xC3\xE5\xED\xC0") == false); // ГенА — А большая

	// isFioii1251 — формат "Фамилия И.О."
	assert(isFioii1251(cast(char[]) "Ivanov A.N.") == true);
	// Иванов А.Н. в CP1251: \xC8\xE2\xE0\xED\xEE\xE2 \xC0.\xCD.
	assert(isFioii1251(cast(char[]) "\xC8\xE2\xE0\xED\xEE\xE2 \xC0.\xCD.") == true);
	assert(isFioii1251(cast(char[]) "ivanov A.N.") == false); // первая строчная
	assert(isFioii1251(cast(char[]) "Ivanov AN.") == false);  // нет второй точки
	assert(isFioii1251(cast(char[]) "Ab.") == false);         // слишком короткая

	// isInt1251 — только цифры
	assert(isInt1251(cast(char[]) "0") == true);
	assert(isInt1251(cast(char[]) "123") == true);
	assert(isInt1251(cast(char[]) "") == false);
	assert(isInt1251(cast(char[]) "12a") == false);
	assert(isInt1251(cast(char[]) "12.3") == false);
	assert(isInt1251(cast(char[]) "-1") == false);
	assert(isInt1251(cast(char[]) " 1") == false);
}

/// Проверяет правильность ИНН физического лица (10 цифр) по контрольной сумме.
/// Алгоритм: взвешенная сумма первых 9 цифр по весам [2,4,10,3,5,9,4,6,8],
/// остаток от деления на 11 (если > 9, ещё раз % 10) должен совпасть с 10-й цифрой.
/// "0000000000" считается корректным (нулевой ИНН). Строки с нецифровыми символами → false.
bool tstINN(string s) {
	string s1;
	bool rez;
	int[10] weights = [2, 4, 10, 3, 5, 9, 4, 6, 8, 0];
	int summ;
	
	if((s.length == 0) || (s.length > 10) ) return rez;
	foreach(ch; s) {
		if(!isDigit1251(ch)) return rez;
	}
	import std.string: format, strip;
	import std.conv: to;
	try {
		s1 = format("%.10s", to!long(strip(s)));
	} catch(Throwable) {
		return rez;			// Ошибка конвертации
	}
	if(s1 == "0000000000") return true;
	// Перебор цифр и вычисление суммы
	for(int i; i != 9; i++) {
		auto digit = s1[i] - 48; 
		summ += digit * weights[i];
	}
	auto ost = summ % 11;
	if (ost > 9) ost = ost % 10;
	if (ost == (s1[9] - 48)) rez = true;
	return rez;
}

unittest {
	assert(tstINN("") == false);
	assert(tstINN("0000000000") == true);
	assert(tstINN("0") == true);
	assert(tstINN("0000A00000") == false);
	assert(tstINN("+000000000") == false);
	assert(tstINN("9999999999") == false);
	assert(tstINN("05911013765") == false);

	assert(tstINN("5905033450") == true);
	assert(tstINN("5913001268") == true);
	assert(tstINN("6607000556") == true);
	assert(tstINN("5911013765") == true);
}

/**
 * Считает количество кодовых точек UTF-8 в строке.
 * Каждый символ (включая русские буквы) = 1 единица.
 */
int countCodePoints(string s) {
    int count = 0;
    size_t i = 0;
    while (i < s.length) {
        ubyte b = cast(ubyte) s[i];
        if ((b & 0x80) == 0) {
            i += 1;  // 1-byte ASCII
        } else if ((b & 0xE0) == 0xC0) {
            i += 2;  // 2-byte
        } else if ((b & 0xF0) == 0xE0) {
            i += 3;  // 3-byte (русские буквы)
        } else if ((b & 0xF8) == 0xF0) {
            i += 4;  // 4-byte
        } else {
            i += 1;  // invalid, skip
        }
        count++;
    }
    return count;
}

/// Конвертирует строку из кодировки CP1251 в UTF-8 (версия для char[]).
/// Предварительно выделяет буфер size*3 (CP1251 → UTF-8: кириллица занимает 2 байта,
/// ASCII — 1 байт, спецсимволы — 3 байта: €, …, тире и т.д.), затем обрезает до реального размера.
char[] from1251toUtf8(char[] str) pure nothrow @trusted {
	if (str.length == 0) return str;
	auto rez = new char[str.length * 3]; // CP1251 → UTF-8: max 3 байта (евро, тире и т.д.)
	size_t pos = 0;
	foreach (char c1; str) {
		auto s = mm1251_Utf8[c1];
		rez[pos .. pos + s.length] = s[];
		pos += s.length;
	}
	return rez[0 .. pos];
}
/// Конвертирует строку из CP1251 в UTF-8 (шаблонная версия, возвращает string).
/// Принимает string, const(char)[], immutable(char)[] и т.п.
string from1251toUtf8(T)(T str) pure nothrow @trusted {
	if (str.length == 0) return "";
	auto src = cast(char[]) str;
	auto rez = new char[src.length * 3];
	size_t pos = 0;
	foreach (char c1; src) {
		auto s = mm1251_Utf8[c1];
		rez[pos .. pos + s.length] = s[];
		pos += s.length;
	}
	return cast(string) rez[0 .. pos];
}
/// Шаблонная обёртка: конвертирует строку из UTF-8 в CP1251, возвращает тип T1 (char[] или string).
/// Пример: fromUtf8to1251!(char[])("Гена") == "\xC3\xE5\xED\xE0"
T1 fromUtf8to1251(T1, T2)(T2 str) {
	return to!(T1)(fromUtf8to1251(to!(char[])(str)));
}

/// Вспомогательная: подсчёт числа Unicode-символов в UTF-8 буфере
/// (не байт, а кодовых точек — по признаку старших бит каждого байта).
pragma(inline) size_t utf8Length(char[] src) pure nothrow @trusted { size_t len; foreach (ref b; src) { if ((b & 0xC0) != 0x80) len++; } return len; }

/// Конвертирует строку из UTF-8 в CP1251 (основная реализация).
/// Алгоритм Максима Шибнева: обходит UTF-8 по stride, разбирает 1–3-байтовые последовательности.
/// Кириллица (U+0400..U+04FF) → CP1251 (0x80–0xFF), ASCII без изменений.
/// Неизвестные символы заменяются на '?'.
/// 
/// ИСПРАВЛЕНИЯ (2024):
/// - Защита от выхода за границы таблиц (tbl_xD0, tbl_xD1, tbl_xC2, tbl_x80)
/// - Всегда инициализируется ret[dstPos] (нет "провалов" через break без присваивания)
/// - Проверка что второй/третий байт многобайтовой последовательности внутри строки
char[] fromUtf8to1251(char[] str) pure
{
	if (str.length == 0) return str;

	auto ret = new char[str.utf8Length];
	size_t srcPos;
	size_t dstPos;
	size_t id;

	while(srcPos < str.length) {
		id = stride(str, srcPos);
		
		// Проверка: хватает ли байт в строке для многобайтовой последовательности
		if (srcPos + id > str.length) {
			// Обрезанная последовательность в конце — заменяем на '?'
			ret[dstPos] = '?';
			srcPos = str.length; // Прерываем цикл
			dstPos++;
			break;
		}
		
		switch (id) {
			case 1:
				ret[dstPos] = str[srcPos];
				break;
			case 2:
				switch (str[srcPos]) {
					case '\xD0':
						// Диапазон второго байта: 0x81..0xBF (кириллица А..п)
						// Таблица tbl_xD0: 63 элемента, индексы (byte - 129), диапазон 0..62
						// Значимые байты: 129..191 (63 значения)
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 129 && b2 <= 191) {
							immutable prb = tbl_xD0[b2 - 129];
							ret[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							ret[dstPos] = '?';
						}
						break;
					case '\xD1':
						// Диапазон второго байта: 0x80..0xBD (кириллица р..я, Ё, і, ї, є, ґ)
						// Таблица tbl_xD1: 62 элемента, индексы (byte - 128), диапазон 0..61
						// Значимые байты: 128..189 (62 значения)
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 128 && b2 <= 189) {
							immutable prb = tbl_xD1[b2 - 128];
							ret[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							ret[dstPos] = '?';
						}
						break;
					case '\xD2':
						switch (str[srcPos + 1]) {
							case '\x91':
								ret[dstPos] = cast(char)180;
								break;
							case '\x90':
								ret[dstPos] = cast(char)165;
								break;
							default:
								ret[dstPos] = '?';
								break;
						}
						break;
					case '\xD3':
						// Нет поддерживаемых символов в U+0500..U+053F
						ret[dstPos] = '?';
						break;
					case '\xC2':
						// Диапазон второго байта: 0x98..0xBB
						// Таблица tbl_xC2: 36 элементов, индексы (byte - 152), диапазон 0..35
						// Значимые байты: 152..187 (36 значений)
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 152 && b2 <= 187) {
							immutable prb = tbl_xC2[b2 - 152];
							ret[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							ret[dstPos] = '?';
						}
						break;
					default:
						ret[dstPos] = '?';
						break;
				}
				break;
			case 3:
				if (str[srcPos] == '\xE2') {
					switch (str[srcPos + 1]) {
						case '\x80':
							// Диапазон третьего байта: 0x93..0xBA
							// Таблица tbl_x80: 40 элементов, индексы (byte - 147), диапазон 0..39
							// Значимые байты: 147..186 (40 значений)
							ubyte b3 = cast(ubyte)str[srcPos + 2];
							if (b3 >= 147 && b3 <= 186) {
								immutable prb = tbl_x80[b3 - 147];
								ret[dstPos] = ((prb == 0) ? '?' : prb);
							} else {
								ret[dstPos] = '?';
							}
							break;
						case '\x82':
							ret[dstPos] = ((str[srcPos + 2] == '\xAC') ? cast(char)136 : '?');
							break;
						case '\x84':
							switch (str[srcPos + 2]) {
								case '\x96':
									ret[dstPos] = (cast(char)185);
									break;
								case '\xA2':
									ret[dstPos] = (cast(char)153);
									break;
								default:
									ret[dstPos] = '?';
									break;
							}
							break;
						default:
							ret[dstPos] = '?';
							break;
					}
				} else {
					ret[dstPos] = '?';
				}
				break;
			default: // 4, 5, 6 (эмодзи и т.д.)
				ret[dstPos] = '?';
				break;
		} // switch (id)

		srcPos += id;
		dstPos++;
	}

	return ret[0 .. dstPos];
}

/// Конвертирует строку из UTF-8 в CP1251, пишет результат в предоставленный буфер.
/// НЕ аллоцирует память — используется для экономии GC при массовых операциях.
/// Возвращает количество записанных байт.
/// Если буфер слишком мал — возвращает 0 (ничего не записывает).
size_t fromUtf8to1251Buf(char[] str, ref char[8096] buf) pure
{
	if (str.length == 0) return 0;
	
	size_t srcPos;
	size_t dstPos;
	size_t id;
	
	while(srcPos < str.length) {
		// Проверка: влезаем ли в буфер
		if (dstPos >= buf.length) return 0;
		
		id = stride(str, srcPos);
		
		// Проверка: хватает ли байт в строке для многобайтовой последовательности
		if (srcPos + id > str.length) {
			buf[dstPos] = '?';
			srcPos = str.length;
			dstPos++;
			break;
		}
		
		switch (id) {
			case 1:
				buf[dstPos] = str[srcPos];
				break;
			case 2:
				switch (str[srcPos]) {
					case '\xD0':
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 129 && b2 <= 191) {
							immutable prb = tbl_xD0[b2 - 129];
							buf[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							buf[dstPos] = '?';
						}
						break;
					case '\xD1':
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 128 && b2 <= 189) {
							immutable prb = tbl_xD1[b2 - 128];
							buf[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							buf[dstPos] = '?';
						}
						break;
					case '\xD2':
						switch (str[srcPos + 1]) {
							case '\x91':
								buf[dstPos] = cast(char)180;
								break;
							case '\x90':
								buf[dstPos] = cast(char)165;
								break;
							default:
								buf[dstPos] = '?';
								break;
						}
						break;
					case '\xD3':
						buf[dstPos] = '?';
						break;
					case '\xC2':
						ubyte b2 = cast(ubyte)str[srcPos + 1];
						if (b2 >= 152 && b2 <= 187) {
							immutable prb = tbl_xC2[b2 - 152];
							buf[dstPos] = ((prb == 0) ? '?' : prb);
						} else {
							buf[dstPos] = '?';
						}
						break;
					default:
						buf[dstPos] = '?';
						break;
				}
				break;
			case 3:
				if (str[srcPos] == '\xE2') {
					switch (str[srcPos + 1]) {
						case '\x80':
							ubyte b3 = cast(ubyte)str[srcPos + 2];
							if (b3 >= 147 && b3 <= 186) {
								immutable prb = tbl_x80[b3 - 147];
								buf[dstPos] = ((prb == 0) ? '?' : prb);
							} else {
								buf[dstPos] = '?';
							}
							break;
						case '\x82':
							buf[dstPos] = ((str[srcPos + 2] == '\xAC') ? cast(char)136 : '?');
							break;
						case '\x84':
							switch (str[srcPos + 2]) {
								case '\x96':
									buf[dstPos] = (cast(char)185);
									break;
								case '\xA2':
									buf[dstPos] = (cast(char)153);
									break;
								default:
									buf[dstPos] = '?';
									break;
							}
							break;
						default:
							buf[dstPos] = '?';
							break;
					}
				} else {
					buf[dstPos] = '?';
				}
				break;
			default:
				buf[dstPos] = '?';
				break;
		}
		
		srcPos += id;
		dstPos++;
	}
	
	return dstPos;
}


unittest {
	// from1251toUtf8 — CP1251 → UTF-8
	assert(from1251toUtf8(cast(char[]) "\xC3\xE5\xED\xE0") == "Гена");
	assert(from1251toUtf8(cast(char[]) "Gena123") == "Gena123");
	assert(from1251toUtf8(cast(char[]) "") == cast(char[]) "");
	// шаблонная версия (string)
	assert(from1251toUtf8("\xC3\xE5\xED\xE0") == "Гена");

	// === Расширенные тесты from1251toUtf8 ===
	// Все заглавные русские буквы А..Я (CP1251 0xC0..0xDF)
	assert(from1251toUtf8("\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF") == "АБВГДЕЖЗИЙКЛМНОП");
	assert(from1251toUtf8("\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF") == "РСТУФХЦЧШЩЪЫЬЭЮЯ");
	// Все строчные русские буквы а..я (CP1251 0xE0..0xFF)
	assert(from1251toUtf8("\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF") == "абвгдежзийклмноп");
	assert(from1251toUtf8("\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF") == "рстуфхцчшщъыьэюя");
	// Ё и ё (CP1251 специфичные коды)
	assert(from1251toUtf8("\xA8") == "Ё");   // Ё в CP1251 = 0xA8
	assert(from1251toUtf8("\xB8") == "ё");   // ё в CP1251 = 0xB8
	// Украинские/белорусские символы в CP1251
	assert(from1251toUtf8("\xB3") == "і");   // і (укр) — 0xB3
	assert(from1251toUtf8("\xB4") == "ґ");   // ґ (укр) — 0xB4
	assert(from1251toUtf8("\xA1") == "Ў");   // Ў (бел) — 0xA1
	assert(from1251toUtf8("\xA2") == "ў");   // ў (бел) — 0xA2
	assert(from1251toUtf8("\xB2") == "І");   // І (укр заглавная) — 0xB2
	assert(from1251toUtf8("\xAA") == "Є");   // Є (укр) — 0xAA
	assert(from1251toUtf8("\xBA") == "є");   // є (укр) — 0xBA
	assert(from1251toUtf8("\xBF") == "ї");   // ї (укр) — 0xBF
	assert(from1251toUtf8("\xAF") == "Ї");   // Ї (укр заглавная) — 0xAF
	assert(from1251toUtf8("\xEF") == "п");   // п (проверка границы 0xEF)
	// Спецсимволы CP1251
	assert(from1251toUtf8("\x80") == "Ђ");   // Ђ (серб) — 0x80
	assert(from1251toUtf8("\x88") == "\u20AC"); // Евро (€) → UTF-8 E2 82 AC, CP1251 = 0x88
	assert(from1251toUtf8("\x85") == "\u2026"); // Многоточие (…) → UTF-8 E2 80 A6
	assert(from1251toUtf8("\x91") == "\u2018"); // Левая одинарная кавычка ('') → UTF-8 E2 80 98
	assert(from1251toUtf8("\x92") == "\u2019"); // Правая одинарная кавычка (') → UTF-8 E2 80 99
	assert(from1251toUtf8("\x93") == "\u201C"); // Левая двойная кавычка (") → UTF-8 E2 80 9C
	assert(from1251toUtf8("\x94") == "\u201D"); // Правая двойная кавычка (") → UTF-8 E2 80 9D
	assert(from1251toUtf8("\x96") == "\u2013"); // Короткое тире (–) → UTF-8 E2 80 93
	assert(from1251toUtf8("\x97") == "\u2014"); // Длинное тире (—) → UTF-8 E2 80 94
	assert(from1251toUtf8("\x99") == "\u2122"); // Товарный знак (™) → UTF-8 E2 84 A2
	assert(from1251toUtf8("\xA9") == "\u00A9"); // Копирайт (©) → UTF-8 C2 A9
	assert(from1251toUtf8("\xAE") == "\u00AE"); // Зарегистрированный знак (®) → UTF-8 C2 AE
	assert(from1251toUtf8("\xB0") == "\u00B0"); // Градус (°) → UTF-8 C2 B0
	assert(from1251toUtf8("\xB7") == "\u00B7"); // Средняя точка (·) → UTF-8 C2 B7
	// Смешанные строки
	assert(from1251toUtf8("\xC0\xE1\xC2\xE3\xC4\xE5") == "АбВгДе");
	assert(from1251toUtf8("Test\xC0\xE1\xC2\xE3") == "TestАбВг");
	assert(from1251toUtf8("\xC0\xE1\xC2\xE3Test") == "АбВгTest");
	// Пустая строка и один символ
	assert(from1251toUtf8("") == "");
	assert(from1251toUtf8("\xC0") == "А");
	assert(from1251toUtf8("\xFF") == "я");
	// Длинная строка (все русские буквы подряд)
	assert(from1251toUtf8("\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF") == "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя");

	// fromUtf8to1251 — UTF-8 → CP1251
	assert(fromUtf8to1251(cast(char[]) "Гена") == "\xC3\xE5\xED\xE0");
	assert(fromUtf8to1251(cast(char[]) "Gena123") == "Gena123");
	char[] g = [ 'G', 'e', 'n', 'a', '1', '2', '3' ];
	assert(fromUtf8to1251!(char[])("Gena123") == g);
	assert(fromUtf8to1251!(char[])("Гена") == "\xC3\xE5\xED\xE0");

	// from1251to866 — CP1251 → CP866
	assert(from1251to866(cast(char[]) "") == cast(char[]) "");
	assert(from1251to866(cast(char[]) "123") == cast(char[]) "123"); // ASCII не меняется
	// А=0xC0 (CP1251) → 0x80 (CP866)
	assert(from1251to866(cast(char[]) "\xC0") == cast(char[]) "\x80");
	// а=0xE0 (CP1251) → 0xA0 (CP866)
	assert(from1251to866(cast(char[]) "\xE0") == cast(char[]) "\xA0");
	// Я=0xDF (CP1251) → 0x9F (CP866)
	assert(from1251to866(cast(char[]) "\xDF") == cast(char[]) "\x9F");

	// char1251toUtf8 — один символ CP1251 → UTF-8 строка
	assert(char1251toUtf8('A') == "A");        // ASCII без изменений
	assert(char1251toUtf8('\xC0') == "А");     // А (CP1251 0xC0 → UTF-8 D0 90)
	assert(char1251toUtf8('\xE0') == "а");     // а (CP1251 0xE0 → UTF-8 D0 B0)
	assert(char1251toUtf8('\xC3') == "Г");     // Г (CP1251 0xC3 → UTF-8 D0 93)

	// === Расширенные тесты fromUtf8to1251 ===
	// Все заглавные русские буквы А..Я (UTF-8 → CP1251)
	assert(fromUtf8to1251(cast(char[]) "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ") == "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF");
	// Все строчные русские буквы а..я (UTF-8 → CP1251)
	assert(fromUtf8to1251(cast(char[]) "абвгдежзийклмнопрстуфхцчшщъыьэюя") == "\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF");
	// Ё и ё
	assert(fromUtf8to1251(cast(char[]) "Ё") == "\xA8");
	assert(fromUtf8to1251(cast(char[]) "ё") == "\xB8");
	// Украинские/белорусские символы
	assert(fromUtf8to1251(cast(char[]) "і") == "\xB3");
	assert(fromUtf8to1251(cast(char[]) "ґ") == "\xB4");
	assert(fromUtf8to1251(cast(char[]) "Ў") == "\xA1");
	assert(fromUtf8to1251(cast(char[]) "ў") == "\xA2");
	assert(fromUtf8to1251(cast(char[]) "І") == "\xB2");
	assert(fromUtf8to1251(cast(char[]) "Є") == "\xAA");
	assert(fromUtf8to1251(cast(char[]) "є") == "\xBA");
	assert(fromUtf8to1251(cast(char[]) "ї") == "\xBF");
	assert(fromUtf8to1251(cast(char[]) "Ї") == "\xAF");
	// Спецсимволы UTF-8 → CP1251
	assert(fromUtf8to1251(cast(char[]) "€") == "\x88");
	assert(fromUtf8to1251(cast(char[]) "…") == "\x85");
	assert(fromUtf8to1251(cast(char[]) "\u2018") == "\x91");  // '
	assert(fromUtf8to1251(cast(char[]) "\u2019") == "\x92");  // '
	assert(fromUtf8to1251(cast(char[]) "\u201C") == "\x93");  // "
	assert(fromUtf8to1251(cast(char[]) "\u201D") == "\x94");  // "
	assert(fromUtf8to1251(cast(char[]) "–") == "\x96");
	assert(fromUtf8to1251(cast(char[]) "—") == "\x97");
	assert(fromUtf8to1251(cast(char[]) "™") == "\x99");
	assert(fromUtf8to1251(cast(char[]) "©") == "\xA9");
	assert(fromUtf8to1251(cast(char[]) "®") == "\xAE");
	assert(fromUtf8to1251(cast(char[]) "°") == "\xB0");
	assert(fromUtf8to1251(cast(char[]) "·") == "\xB7");
	// Смешанные строки
	assert(fromUtf8to1251(cast(char[]) "АбВгДе") == "\xC0\xE1\xC2\xE3\xC4\xE5");
	assert(fromUtf8to1251(cast(char[]) "TestАбВг") == "Test\xC0\xE1\xC2\xE3");
	assert(fromUtf8to1251(cast(char[]) "АбВгTest") == "\xC0\xE1\xC2\xE3Test");
	// ASCII без изменений
	assert(fromUtf8to1251(cast(char[]) "Hello123") == "Hello123");
	assert(fromUtf8to1251(cast(char[]) "") == "");
	// Полный алфавит подряд
	assert(fromUtf8to1251(cast(char[]) "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя") == "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF");
	// Неизвестные символы → '?'
	assert(fromUtf8to1251(cast(char[]) "α") == "?");  // греческая альфа
	assert(fromUtf8to1251(cast(char[]) "→") == "?");  // стрелка
	assert(fromUtf8to1251(cast(char[]) "♠") == "?");  // масть
	// Эмодзи (4-байтовые UTF-8) → '?'
	assert(fromUtf8to1251(cast(char[]) "😀") == "?");
	assert(fromUtf8to1251(cast(char[]) "🎉") == "?");
	// Китайские иероглифы → '?'
	assert(fromUtf8to1251(cast(char[]) "中") == "?");
	assert(fromUtf8to1251(cast(char[]) "文") == "?");
	// Японские символы → '?'
	assert(fromUtf8to1251(cast(char[]) "あ") == "?");
	assert(fromUtf8to1251(cast(char[]) "ア") == "?");
	// Арабские символы → '?'
	assert(fromUtf8to1251(cast(char[]) "م") == "?");
	// Длинная строка с разными символами
	assert(fromUtf8to1251(cast(char[]) "Hello Мир! €100") == "Hello \xCC\xE8\xF0! \x88100");
	// Граничные случаи
	assert(fromUtf8to1251(cast(char[]) "Я") == "\xDF");
	assert(fromUtf8to1251(cast(char[]) "я") == "\xFF");
	assert(fromUtf8to1251(cast(char[]) "А") == "\xC0");
	assert(fromUtf8to1251(cast(char[]) "а") == "\xE0");
	// Проверка шаблонной версии с явным типом
	assert(fromUtf8to1251!(char[])("Гена") == "\xC3\xE5\xED\xE0");
	assert(fromUtf8to1251!(string)("Гена") == "\xC3\xE5\xED\xE0");
}

/// Перекодирует строку из CP1251 в CP866 (DOS-кириллица) по таблице _1251_866.
/// Используется для вывода текста в консоль Windows (cmd.exe).
char[] from1251to866(char[] str) {
	if (str.length == 0) return str;
	size_t dlStr = str.length;
	auto ret = new char[dlStr]; for(int i; i != dlStr; i++) ret[i] = _1251_866[str[i]];
	return ret;
}

/// Преобразует строку UTF-8 для вывода в консоль: на Windows — UTF-8 → CP1251 → CP866,
/// на Linux/macOS — строка возвращается без изменений (терминалы принимают UTF-8).
string toCON(T)(T s) {
	version (Windows) {
		return to!string(from1251to866(fromUtf8to1251(cast(char[]) s)));
	}
	version (linux) {
		return cast(string)s;
	}
	version (OSX) {
		return cast(string)s;
	}
}

/// Возвращает UTF-8 представление одного символа в кодировке CP1251.
/// Использует таблицу mm1251_Utf8 — быстрый O(1) поиск.
string char1251toUtf8(char ch) {
	return mm1251_Utf8[ch];
}

/// Перекодирует дату из формата ANSI ("дд.мм.гггг") в SQL ("гггг-мм-дд").
/// Пример: "03.12.2017" → "2017-12-03".
string dateAnsiSql(string str) {
	if(str.length == 0) return "";
	auto mas = split(str, '.'); return mas[2] ~ "-" ~ mas[1] ~ "-" ~ mas[0];
}

/// Перекодирует дату из формата SQL ("гггг-мм-дд") в ANSI ("дд.мм.гггг").
/// Пример: "2017-12-03" → "03.12.2017".
string dateSqlAnsi(string str) {
	if(str.length == 0) return "";
	auto mas = split(str, '-'); return mas[2] ~ "." ~ mas[1] ~ "." ~ mas[0];
}

unittest {
	assert(dateAnsiSql("03.12.2017") == "2017-12-03");
	assert(dateAnsiSql("01.01.2000") == "2000-01-01");
	assert(dateAnsiSql("") == "");
	assert(dateSqlAnsi("2017-12-03") == "03.12.2017");
	assert(dateSqlAnsi("2000-01-01") == "01.01.2000");
	assert(dateSqlAnsi("") == "");
	// обратимость: ANSI → SQL → ANSI
	assert(dateSqlAnsi(dateAnsiSql("15.06.1990")) == "15.06.1990");
}

/// Проверяет СНИЛС на корректность (11 цифр, контрольная сумма).
/// Принимает строки в любом формате: "11223344595", "112-233-445 95" и т.п.
/// Из строки выбираются только цифры, затем проверяется длина и контрольная сумма.
bool isSnils(string snilsRaw) {
	bool rez;
	// Выделяем только цифры и проверяем на длину
	string snilsNum; foreach(ch; snilsRaw) if(isDigit1251(ch)) snilsNum ~= ch;
	if(snilsNum.length != 11) return false;
	// Выделяем 
	int workSnils = kSumSnils(snilsNum); // Это контрольная сумма = число
	int ksmSnils = to!int(snilsNum[$ - 2 .. $]);
	if(workSnils == ksmSnils) rez = true; else rez = false;
	// writeln("workSnils = ", workSnils, "  ksmSnils = ", ksmSnils);
	return rez;
}

/// Форматирует СНИЛС в стандартный вид "NNN-NNN-NNN NN".
/// Принимает строки в любом формате (цифры + любые разделители).
/// Если цифр не ровно 11 — возвращает пустую строку.
string formatSnils(string snilsRaw) {
	string rez;
	// Выделяем только цифры и проверяем на длину
	string snilsNum; foreach(ch; snilsRaw) if(isDigit1251(ch)) snilsNum ~= ch;
	if(snilsNum.length != 11) return rez;
    rez = snilsNum[0..3] ~ "-" ~ snilsNum[3..6] ~ "-" ~ snilsNum[6..9] ~ " " ~snilsNum[9..$];
    return rez;
}

unittest {
	assert(isSnils("")     == false);
	assert(isSnils("gena") == false);
	assert(isSnils("17")   == false);
	assert(isSnils("123456789017")   == false);  // 12 цифр — слишком длинный
	assert(isSnils("112-233-445 95") == true);   // 11 цифр, корректный
	assert(isSnils("112-234-445 95") == false);  // неверная контрольная сумма
	assert(isSnils("1234567890")     == false);  // 10 цифр — мало

	// formatSnils
	assert(formatSnils("11223344595")   == "112-233-445 95");
	assert(formatSnils("112-233-445 95") == "112-233-445 95"); // уже форматированный
	assert(formatSnils("")   == "");
	assert(formatSnils("123") == "");  // мало цифр
}


private:
int kSumSnils(string snilsRaw) {
	// Выделяем только цифры и проверяем на длину
	string snilsNum; foreach(ch; snilsRaw) if(isDigit1251(ch)) snilsNum ~= ch;
	if(snilsNum.length != 11) return false;
	// Выделяем 
	string workSnils = snilsNum[0 .. 9];
	// Считаем
	int totalSum = 0;
	long j = 0;
	for(long i = workSnils.length-1; i >= 0; i--) {
		totalSum += to!int(to!string(workSnils[to!uint(i)])) * ++j;
	}
	return kSumSnilsCkeck(totalSum);
}
int kSumSnilsCkeck(int controlSum) {
	int result;
	if(controlSum < 100) result = controlSum;
	else {
		if(controlSum <= 101) result = 0;
		else result = kSumSnilsCkeck(controlSum % 101);
	}
	return result;
}

const int sByte = ubyte.max + 1;

const tBad = 0; // Бяка
const tDigit = 1; // Цифра
const tEl = 2; // Анг Маленькие
const tEu = 4; // Анг Большие
const tPrint = 8; // Печатные
const tRl = 16; // Рус Маленькие
const tRu = 32; // Рус Большие

private immutable char[][sByte]  mm1251_Utf8= [
	/* 0 */
	"\x00", /* 1 */ "\x01", /* 2 */ "\x02", /* 3 */ "\x03", /* 4 */ "\x04",/* 5 */
	"\x05", /* 6 */ "\x06", /* 7 */ "\x07", /* 8 */ "\x08", /* 9 */ "\x09",/* 10 */
	"\x0A", /* 11 */ "\x0B", /* 12 */ "\x0C", /* 13 */ "\x0D", /* 14 */ "\x0E",/* 15 */
	"\x0F", /* 16 */ "\x10", /* 17 */ "\x11", /* 18 */ "\x12", /* 19 */ "\x13",/* 20 */
	"\x14", /* 21 */ "\x15", /* 22 */ "\x16", /* 23 */ "\x17", /* 24 */ "\x18",/* 25 */
	"\x19", /* 26 */ "\x1A", /* 27 */ "\x1B", /* 28 */ "\x1C", /* 29 */ "\x1D",/* 30 */
	"\x1E", /* 31 */ "\x1F", /* 32 */ "\x20", /* 33 */ "\x21", /* 34 */ "\x22",/* 35 */
	"\x23", /* 36 */ "\x24", /* 37 */ "\x25", /* 38 */ "\x26", /* 39 */ "\x27",/* 40 */
	"\x28", /* 41 */ "\x29", /* 42 */ "\x2A", /* 43 */ "\x2B", /* 44 */ "\x2C",/* 45 */
	"\x2D", /* 46 */ "\x2E", /* 47 */ "\x2F", /* 48 */ "\x30", /* 49 */ "\x31",/* 50 */
	"\x32", /* 51 */ "\x33", /* 52 */ "\x34", /* 53 */ "\x35", /* 54 */ "\x36",/* 55 */
	"\x37", /* 56 */ "\x38", /* 57 */ "\x39", /* 58 */ "\x3A", /* 59 */ "\x3B",/* 60 */
	"\x3C", /* 61 */ "\x3D", /* 62 */ "\x3E", /* 63 */ "\x3F", /* 64 */ "\x40",/* 65 */
	"\x41", /* 66 */ "\x42", /* 67 */ "\x43", /* 68 */ "\x44", /* 69 */ "\x45",/* 70 */
	"\x46", /* 71 */ "\x47", /* 72 */ "\x48", /* 73 */ "\x49", /* 74 */ "\x4A",/* 75 */
	"\x4B", /* 76 */ "\x4C", /* 77 */ "\x4D", /* 78 */ "\x4E", /* 79 */ "\x4F",/* 80 */
	"\x50", /* 81 */ "\x51", /* 82 */ "\x52", /* 83 */ "\x53", /* 84 */ "\x54",/* 85 */
	"\x55", /* 86 */ "\x56", /* 87 */ "\x57", /* 88 */ "\x58", /* 89 */ "\x59",/* 90 */
	"\x5A", /* 91 */ "\x5B", /* 92 */ "\x5C", /* 93 */ "\x5D", /* 94 */ "\x5E",/* 95 */
	"\x5F", /* 96 */ "\x60", /* 97 */ "\x61", /* 98 */ "\x62", /* 99 */ "\x63",/* 100 */
	"\x64", /* 101 */ "\x65", /* 102 */ "\x66", /* 103 */ "\x67", /* 104 */ "\x68",/* 105 */
	"\x69", /* 106 */ "\x6A", /* 107 */ "\x6B", /* 108 */ "\x6C", /* 109 */ "\x6D",/* 110 */
	"\x6E", /* 111 */ "\x6F", /* 112 */ "\x70", /* 113 */ "\x71", /* 114 */ "\x72",/* 115 */
	"\x73", /* 116 */ "\x74", /* 117 */ "\x75", /* 118 */ "\x76", /* 119 */ "\x77",/* 120 */
	"\x78", /* 121 */ "\x79", /* 122 */ "\x7A", /* 123 */ "\x7B", /* 124 */ "\x7C",/* 125 */
	"\x7D", /* 126 */ "\x7E", /* 127 */ "\x7F", /* 128 */ "\xD0\x82", /* 129 */ "\xD0\x83",
	/* 130 */
	"\xE2\x80\x9A", /* 131 */ "\xD1\x93", /* 132 */ "\xE2\x80\x9E", /* 133 */ "\xE2\x80\xA6", /* 134 */ "\xE2\x80\xA0", /* 135 */ "\xE2\x80\xA1",
	/* 136 */
	"\xE2\x82\xAC", /* 137 */ "\xE2\x80\xB0", /* 138 */ "\xD0\x89", /* 139 */ "\xE2\x80\xB9", /* 140 */ "\xD0\x8A", /* 141 */ "\xD0\x8C",
	/* 142 */
	"\xD0\x8B", /* 143 */ "\xD0\x8F", /* 144 */ "\xD1\x92", /* 145 */ "\xE2\x80\x98", /* 146 */ "\xE2\x80\x99", /* 147 */ "\xE2\x80\x9C",
	/* 148 */
	"\xE2\x80\x9D", /* 149 */ "\xE2\x80\xA2", /* 150 */ "\xE2\x80\x93", /* 151 */ "\xE2\x80\x94", /* 152 */ "\xC2\x98", /* 153 */ "\xE2\x84\xA2",
	/* 154 */
	"\xD1\x99", /* 155 */ "\xE2\x80\xBA", /* 156 */ "\xD1\x9A", /* 157 */ "\xD1\x9C", /* 158 */ "\xD1\x9B", /* 159 */ "\xD1\x9F",
	/* 160 */
	"\xC2\xA0", /* 161 */ "\xD0\x8E", /* 162 */ "\xD1\x9E", /* 163 */ "\xD0\x88", /* 164 */ "\xC2\xA4", /* 165 */ "\xD2\x90",
	/* 166 */
	"\xC2\xA6", /* 167 */ "\xC2\xA7", /* 168 */ "\xD0\x81", /* 169 */ "\xC2\xA9", /* 170 */ "\xD0\x84", /* 171 */ "\xC2\xAB",
	/* 172 */
	"\xC2\xAC", /* 173 */ "\xC2\xAD", /* 174 */ "\xC2\xAE", /* 175 */ "\xD0\x87", /* 176 */ "\xC2\xB0", /* 177 */ "\xC2\xB1",
	/* 178 */
	"\xD0\x86", /* 179 */ "\xD1\x96", /* 180 */ "\xD2\x91", /* 181 */ "\xC2\xB5", /* 182 */ "\xC2\xB6", /* 183 */ "\xC2\xB7",
	/* 184 */
	"\xD1\x91", /* 185 */ "\xE2\x84\x96", /* 186 */ "\xD1\x94", /* 187 */ "\xC2\xBB", /* 188 */ "\xD1\x98", /* 189 */ "\xD0\x85",
	/* 190 */
	"\xD1\x95", /* 191 */ "\xD1\x97", /* 192 */ "\xD0\x90", /* 193 */ "\xD0\x91",/* 194 */
	"\xD0\x92", /* 195 */ "\xD0\x93", /* 196 */ "\xD0\x94", /* 197 */ "\xD0\x95",
	/* 198 */
	"\xD0\x96", /* 199 */ "\xD0\x97", /* 200 */ "\xD0\x98", /* 201 */ "\xD0\x99",/* 202 */
	"\xD0\x9A", /* 203 */ "\xD0\x9B", /* 204 */ "\xD0\x9C", /* 205 */ "\xD0\x9D",
	/* 206 */
	"\xD0\x9E", /* 207 */ "\xD0\x9F", /* 208 */ "\xD0\xA0", /* 209 */ "\xD0\xA1",/* 210 */
	"\xD0\xA2", /* 211 */ "\xD0\xA3", /* 212 */ "\xD0\xA4", /* 213 */ "\xD0\xA5",
	/* 214 */
	"\xD0\xA6", /* 215 */ "\xD0\xA7", /* 216 */ "\xD0\xA8", /* 217 */ "\xD0\xA9",/* 218 */
	"\xD0\xAA", /* 219 */ "\xD0\xAB", /* 220 */ "\xD0\xAC", /* 221 */ "\xD0\xAD",
	/* 222 */
	"\xD0\xAE", /* 223 */ "\xD0\xAF", /* 224 */ "\xD0\xB0", /* 225 */ "\xD0\xB1",/* 226 */
	"\xD0\xB2", /* 227 */ "\xD0\xB3", /* 228 */ "\xD0\xB4", /* 229 */ "\xD0\xB5",
	/* 230 */
	"\xD0\xB6", /* 231 */ "\xD0\xB7", /* 232 */ "\xD0\xB8", /* 233 */ "\xD0\xB9",/* 234 */
	"\xD0\xBA", /* 235 */ "\xD0\xBB", /* 236 */ "\xD0\xBC", /* 237 */ "\xD0\xBD",
	/* 238 */
	"\xD0\xBE", /* 239 */ "\xD0\xBF", /* 240 */ "\xD1\x80", /* 241 */ "\xD1\x81",/* 242 */
	"\xD1\x82", /* 243 */ "\xD1\x83", /* 244 */ "\xD1\x84", /* 245 */ "\xD1\x85",
	/* 246 */
	"\xD1\x86", /* 247 */ "\xD1\x87", /* 248 */ "\xD1\x88", /* 249 */ "\xD1\x89",/* 250 */
	"\xD1\x8A", /* 251 */ "\xD1\x8B", /* 252 */ "\xD1\x8C", /* 253 */ "\xD1\x8D",
	/* 254 */
	"\xD1\x8E", /* 255 */ "\xD1\x8F"
];

private immutable int[sByte]  mm1251= [/* 0 */
	tBad, /* 1 */ tBad, /* 2 */ tBad, /* 3 */ tBad, /* 4 */ tBad, /* 5 */ tBad, /* 6 */ tBad, /* 7 */ tBad, /* 8 */ tBad,
	/* 9 */
	tBad, /* 10 */ tBad, /* 11 */ tBad, /* 12 */ tBad, /* 13 */ tBad, /* 14 */ tBad, /* 15 */ tBad, /* 16 */ tBad, /* 17 */ tBad,
	/* 18 */
	tBad, /* 19 */ tBad, /* 20 */ tBad, /* 21 */ tBad, /* 22 */ tBad, /* 23 */ tBad, /* 24 */ tBad, /* 25 */ tBad, /* 26 */ tBad,
	/* 27 */
	tBad, /* 28 */ tBad, /* 29 */ tBad, /* 30 */ tBad, /* 31 */ tBad, /* 32 */ tBad, /* 33 */ tPrint, /* 34 */ tPrint, /* 35 */ tPrint,
	/* 36 */
	tPrint, /* 37 */ tPrint, /* 38 */ tPrint, /* 39 */ tPrint, /* 40 */ tPrint, /* 41 */ tPrint, /* 42 */ tPrint, /* 43 */ tPrint, /* 44 */ tPrint,
	/* 45 */
	tPrint, /* 46 */ tPrint, /* 47 */ tPrint, /* 48 */ tPrint + tDigit, /* 49 */ tPrint + tDigit, /* 50 */ tPrint + tDigit, /* 51 */ tPrint + tDigit,
	/* 52 */
	tPrint + tDigit, /* 53 */ tPrint + tDigit, /* 54 */ tPrint + tDigit, /* 55 */ tPrint + tDigit,
	/* 56 */
	tPrint + tDigit, /* 57 */ tPrint + tDigit, /* 58 */ tPrint, /* 59 */ tPrint, /* 60 */ tPrint, /* 61 */ tPrint,
	/* 62 */
	tPrint, /* 63 */ tPrint, /* 64 */ tPrint,/* 65 */
	tPrint + tEu, /* 66 */ tPrint + tEu, /* 67 */ tPrint + tEu, /* 68 */ tPrint + tEu, /* 69 */ tPrint + tEu, /* 70 */ tPrint + tEu,
	/* 71 */
	tPrint + tEu, /* 72 */ tPrint + tEu, /* 73 */ tPrint + tEu, /* 74 */ tPrint + tEu, /* 75 */ tPrint + tEu, /* 76 */ tPrint + tEu,
	/* 77 */
	tPrint + tEu, /* 78 */ tPrint + tEu, /* 79 */ tPrint + tEu, /* 80 */ tPrint + tEu, /* 81 */ tPrint + tEu, /* 82 */ tPrint + tEu,
	/* 83 */
	tPrint + tEu, /* 84 */ tPrint + tEu, /* 85 */ tPrint + tEu, /* 86 */ tPrint + tEu, /* 87 */ tPrint + tEu, /* 88 */ tPrint + tEu,
	/* 89 */
	tPrint + tEu, /* 90 */ tPrint + tEu,/* 91 */
	tPrint, /* 92 */ tPrint, /* 93 */ tPrint, /* 94 */ tPrint, /* 95 */ tPrint,
	/* 96 */
	tPrint,/* 97 */
	tPrint + tEl, /* 98 */ tPrint + tEl, /* 99 */ tPrint + tEl, /* 100 */ tPrint + tEl, /* 101 */ tPrint + tEl, /* 102 */ tPrint + tEl,
	/* 103 */
	tPrint + tEl, /* 104 */ tPrint + tEl, /* 105 */ tPrint + tEl, /* 106 */ tPrint + tEl, /* 107 */ tPrint + tEl, /* 108 */ tPrint + tEl,
	/* 109 */
	tPrint + tEl, /* 110 */ tPrint + tEl, /* 111 */ tPrint + tEl, /* 112 */ tPrint + tEl, /* 113 */ tPrint + tEl, /* 114 */ tPrint + tEl,
	/* 115 */
	tPrint + tEl, /* 116 */ tPrint + tEl, /* 117 */ tPrint + tEl, /* 118 */ tPrint + tEl, /* 119 */ tPrint + tEl, /* 120 */ tPrint + tEl,
	/* 121 */
	tPrint + tEl, /* 122 */ tPrint + tEl, /* 123 */ tPrint, /* 124 */ tPrint, /* 125 */ tPrint, /* 126 */ tPrint, /* 127 */ tPrint, /* 128 */ tPrint,
	/* 129 */
	tPrint,/* 130 */
	tPrint, /* 131 */ tPrint, /* 132 */ tPrint, /* 133 */ tPrint, /* 134 */ tPrint, /* 135 */ tPrint, /* 136 */ tPrint, /* 137 */ tPrint,/* 138 */
	tPrint, /* 139 */ tPrint, /* 140 */ tPrint, /* 141 */ tPrint, /* 142 */ tPrint, /* 143 */ tPrint, /* 144 */ tPrint, /* 145 */ tPrint,/* 146 */
	tPrint, /* 147 */ tPrint, /* 148 */ tPrint, /* 149 */ tPrint, /* 150 */ tPrint, /* 151 */ tPrint, /* 152 */ tPrint, /* 153 */ tPrint,/* 154 */
	tPrint, /* 155 */ tPrint, /* 156 */ tPrint, /* 157 */ tPrint, /* 158 */ tPrint, /* 159 */ tPrint, /* 160 */ tPrint, /* 161 */ tPrint,/* 162 */
	tPrint, /* 163 */ tPrint, /* 164 */ tPrint, /* 165 */ tPrint, /* 166 */ tPrint, /* 167 */ tPrint, /* 168 */ tPrint + tRu, /* 169 */ tPrint,
	/* 170 */
	tPrint, /* 171 */ tPrint, /* 172 */ tPrint, /* 173 */ tPrint, /* 174 */ tPrint, /* 175 */ tPrint, /* 176 */ tPrint, /* 177 */ tPrint,/* 178 */
	tPrint, /* 179 */ tPrint, /* 180 */ tPrint, /* 181 */ tPrint, /* 182 */ tPrint, /* 183 */ tPrint, /* 184 */ tPrint + tRl, /* 185 */ tPrint,
	/* 186 */
	tPrint, /* 187 */ tPrint, /* 188 */ tPrint, /* 189 */ tPrint, /* 190 */ tPrint, /* 191 */ tPrint, /* 192 */ tPrint + tRu,
	/* 193 */
	tPrint + tRu, /* 194 */ tPrint + tRu, /* 195 */ tPrint + tRu, /* 196 */ tPrint + tRu, /* 197 */ tPrint + tRu, /* 198 */ tPrint + tRu,
	/* 199 */
	tPrint + tRu, /* 200 */ tPrint + tRu, /* 201 */ tPrint + tRu, /* 202 */ tPrint + tRu, /* 203 */ tPrint + tRu, /* 204 */ tPrint + tRu,
	/* 205 */
	tPrint + tRu, /* 206 */ tPrint + tRu, /* 207 */ tPrint + tRu, /* 208 */ tPrint + tRu, /* 209 */ tPrint + tRu, /* 210 */ tPrint + tRu,
	/* 211 */
	tPrint + tRu, /* 212 */ tPrint + tRu, /* 213 */ tPrint + tRu, /* 214 */ tPrint + tRu, /* 215 */ tPrint + tRu, /* 216 */ tPrint + tRu,
	/* 217 */
	tPrint + tRu, /* 218 */ tPrint + tRu, /* 219 */ tPrint + tRu, /* 220 */ tPrint + tRu, /* 221 */ tPrint + tRu, /* 222 */ tPrint + tRu,
	/* 223 */
	tPrint + tRu, /* 224 */ tPrint + tRl, /* 225 */ tPrint + tRl, /* 226 */ tPrint + tRl, /* 227 */ tPrint + tRl, /* 228 */ tPrint + tRl,
	/* 229 */
	tPrint + tRl, /* 230 */ tPrint + tRl, /* 231 */ tPrint + tRl, /* 232 */ tPrint + tRl, /* 233 */ tPrint + tRl, /* 234 */ tPrint + tRl,
	/* 235 */
	tPrint + tRl, /* 236 */ tPrint + tRl, /* 237 */ tPrint + tRl, /* 238 */ tPrint + tRl, /* 239 */ tPrint + tRl, /* 240 */ tPrint + tRl,
	/* 241 */
	tPrint + tRl, /* 242 */ tPrint + tRl, /* 243 */ tPrint + tRl, /* 244 */ tPrint + tRl, /* 245 */ tPrint + tRl, /* 246 */ tPrint + tRl,
	/* 247 */
	tPrint + tRl, /* 248 */ tPrint + tRl, /* 249 */ tPrint + tRl, /* 250 */ tPrint + tRl, /* 251 */ tPrint + tRl, /* 252 */ tPrint + tRl,
	/* 253 */
	tPrint + tRl, /* 254 */ tPrint + tRl, /* 255 */ tPrint + tRl];

// char mm1251u[sByte];
private immutable uppercase1251R = "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF"; /// А..Я
private immutable lowercase1251R = "\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"; /// А..Я
private immutable _1251_866 = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x18\x19\x1A\x1B......\x20!\x22#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~.+++++++++++++++++++++++++++++++++++++++1\xF0345+++++++++++1\xF1\xFC++++++\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF";
private immutable char[62] tbl_xD1 = [
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,  0,184,144,131,186,190,
179,191,188,154,156,158,157,  0,162,159,  0,  0,210,211,212,213,214,215,216,217,218,219,
220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237
];
private immutable char[63] tbl_xD0 = [
168,128,129,170,189,178,175,163,138,140,142,141,  0,161,143,192,193,194,195,196,197,198,
199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,
221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239
];
private immutable char[40] tbl_x80 = [
150,151,  0,  0,  0,145,146,130,  0,147,148,132,  0,134,135,149,  0,  0,  0,133,  0,  0,
  0,  0,  0,  0,  0,  0,  0,137,  0,  0,  0,  0,  0,  0,  0,  0,139,155
];
private immutable char[36] tbl_xC2 = [
152,  0,  0,  0,  0,  0,  0,  0,160,  0,  0,  0,164,  0,166,167,  0,169,  0,171,172,173,
174,  0,176,177,  0,  0,  0,181,182,183,  0,  0,  0,187
];

bool isAtr1251(char c, int atr) {
	return (mm1251[c] & atr) != 0;
}
