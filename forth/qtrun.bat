@echo off
rem qtrun.bat - демо forthD + QtE56 (окно с кнопкой, логика на Форте)
cd /d "%~dp0\.."
set PATH=C:\Users\Public\QTE56\bin513;%PATH%
forth\qtforth.exe
