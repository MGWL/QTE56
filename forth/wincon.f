// _____________________________________________________________________
// wincon.f - слова Windows-консоли: цвет, позиция курсора, псевдографика
//
// Требует загруженного console.f (EMIT, .", crt).
// Консоль должна быть в cp1251:  chcp 1251   (иначе русский текст - крякозябры)
// Загрузка:  console_forth.exe console.f wincon.f
// Демо:      DEMO      (запускать вживую в cmd.exe, не через пайп -
//            в конце ждёт клавишу)
//
// Псевдографика в cp1251 делается из ASCII: 43='+' 61='=' 124='|'
// Все слова Windows-консоли - обычные вызовы kernel32 через WINAPI-Call".

// ====== kernel32 console API + msvcrt system ======
Lib" kernel32.dll" k32
Library@ k32 1 WINAPI-Call" GetStdHandle" GetStdHandle
Library@ k32 2 WINAPI-Call" SetConsoleTextAttribute" SetConsoleTextAttribute
Library@ k32 2 WINAPI-Call" SetConsoleCursorPosition" SetConsoleCursorPosition
Library@ crt 1 CDECL-Call" system" SYSTEM
LibraryLoad k32
LibraryLoad crt

-11 GetStdHandle CONST HCON                   // хэндл стандартного вывода консоли

// ====== Базовые слова ======
// Цвет = фон*16 + текст. Текст: 0-черный 1-синий 2-зеленый 3-голубой 4-красный
// 5-пурпурный 6-коричневый 7-серый; +8 даёт яркость. Пример: 14 = ярко-жёлтый.
: COLOR HCON SWAP SetConsoleTextAttribute DROP ;              // ( attr -- )
// Курсор в позицию (x y). COORD упаковывается в одну ячейку: X + Y*65536
: GOTOXY 65536 * + HCON SWAP SetConsoleCursorPosition DROP ;  // ( x y -- )
: CLS S" cls" 1+ SYSTEM DROP ;                                // ( -- ) очистка экрана

// ====== Рамка из ASCII-псевдографики ======
VAR FX VAR FY VAR FW VAR FH
: RAMKA ( x y w h -- )                                        // рамка: x,y - левый верхний угол
  FH ! FW ! FY ! FX !
  FX @ FY @ GOTOXY 43 EMIT FW @ 2 - 0 DO 61 EMIT LOOP 43 EMIT
  FH @ 2 - 0 DO FX @ FY @ I + 1+ GOTOXY 124 EMIT FX @ FW @ + 1- FY @ I + 1+ GOTOXY [CHAR] | EMIT LOOP
  FX @ FY @ FH @ + 1- GOTOXY 43 EMIT FW @ 2 - 0 DO 61 EMIT LOOP 43 EMIT ;

// ====== Демо: рамка с цветным русским текстом ======
: DEMO
  CLS
  14 COLOR 5 2 70 10 RAMKA
  11 COLOR 8 4 GOTOXY ." forthD: консоль Windows из Форта"
  10 COLOR 8 6 GOTOXY ." COLOR + GOTOXY + псевдографика cp1251"
  13 COLOR 8 8 GOTOXY ." kernel32 через WINAPI-Call"
  7 COLOR 8 10 GOTOXY ." Нажмите любую клавишу..."
  KEY DROP 7 COLOR CLS ;
