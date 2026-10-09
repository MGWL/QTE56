// qt_app.f - логика демо forthD + QtE56 (загружает qtforth.d).
// FWST - адрес D-шима fw_setText (QLabel.setText), прочитан из ячейки 30
// общей таблицы (setCommonAdr сделан хостом ДО загрузки этого файла).
// Сборка строки счётчика - средствами heap.f/strings.f/console.f:
// N>S (число -> heap-строка), S+ (конкатенация), 1+ - asciiz для шима.

30 COMMONADR@ CONST FWST // FWST -- адрес C функции слота в D программе

VAR COUNTER

HERE 4 ALLOT CONST CrLf
: initCrLf 2  CrLf C! 13 CrLf 1+ C! 13 CrLf 2 + C! 0 CrLf 3 + C! ; initCrLf

: UPDATE-LABEL // ( -- )
    S" Счётчик нажатий: " COUNTER @ N>S S+ 1+   // heap-строка -> asciiz
    DUP >R FWST CALL_A RDROP DROP ;             // cdecl-вызов шима (соб кнопки), void -> один DROP

: RESTART // ( -- ) 
	0 COUNTER ! UPDATE-LABEL ;
