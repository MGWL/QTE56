@echo off
rem winrun.bat - живое окно Windows из forthD (WIN, закрытие - крестик)
chcp 1251 >nul
cd /d "%~dp0"
console_forth.exe heap.f strings.f console.f wincon.f repl.f win.f
pause
