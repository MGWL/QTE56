//  ========================================
//  BENCHMARK FORTHD ЧЕРЕЗ KERNEL32.DLL
//  Использует QueryPerformanceCounter для замера времени
//  Требует: heap.f strings.f console.f wincon.f repl.f
//  =======================================
DECIMAL

//  --- 1. ЗАГРУЗКА ФУНКЦИЙ ИЗ WINDOWS API ---

//  Создаем слово-библиотеку
Lib" kernel32.dll" k32

//  Регистрируем функции. 
//  ВАЖНО: GetTickCount тоже возьмем для сравнения (он возвращает миллисекунды в EAX)
Library@ k32 0 CDECL-Call" GetTickCount" sysGetTickCount
Library@ k32 1 WINAPI-Call" QueryPerformanceCounter"   sysQPC
Library@ k32 1 WINAPI-Call" QueryPerformanceFrequency" sysQPFreq

//  Загружаем саму библиотеку в память ОС
LibraryLoad k32

//  --- 2. СЛОВА ДЛЯ РАБОТЫ С LARGE_INTEGER ---
//  QPC принимает указатель на структуру { LowPart, HighPart }
//  Мы будем хранить её прямо в кодофайле HERE

: EVEN-NUMBERS 20  0 DO I .  2 +LOOP ;  //  0 2 4 6 8 10 12 14 16 18
: COUNT-DOWN    0 10 DO I . -1 +LOOP ;  // 10 9 8 7 6  5  4  3  2  1

VARIABLE qpc-start   //  здесь будет LOWORD результата start
VARIABLE qpc-end     //  здесь будет LOWORD результата end
VARIABLE qpc-freq    //  частота счетчика (тиков в секунду)

8 HALLOC CONST aa1 // Область памяти для частоты
8 HALLOC CONST aa-start
8 HALLOC CONST aa-end

: RESET-TIMER ( -- )
    //  Получаем частоту один раз при старте
    aa1 sysQPFreq DROP  ; //  Результат частоты нам сейчас не важен, просто инициируем вызов

: dump_aa // ( Adr -- ) Распечатка области в байтах
    8 0 DO DUP I + B@ . LOOP DROP CR ;

: set0_aa
    8 0 DO DUP I + 0 SWAP B! LOOP DROP CR ;

aa1 set0_aa aa-start set0_aa aa-end set0_aa

RESET-TIMER // Начальная установка таймера

: START-TIMER ( -- )
    aa-start sysQPC DROP ; //  Передаем адрес переменной, результат пишется по нему

: STOP-TIMER ( -- ticks )
    aa-end sysQPC DROP ;    //  Вызываем API

: test 1000000 0 DO I DROP LOOP ;

START-TIMER test STOP-TIMER

// Считаю разницу 
: speed aa-end @ aa-start @ - 10 / . ;

: f10 ." Время выполнения mks: " 10 0 DO START-TIMER test STOP-TIMER speed LOOP CR ;
f10 CR
EVEN-NUMBERS CR
COUNT-DOWN CR

