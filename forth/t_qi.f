// t_qi.f - диагностика QI (вынесено в файл: AV на верхнем уровне = дамп)
VAR FS
S" Scripting.FileSystemObject" VB-CREATEOBJ FS !
FS @ IIDDISP QI .
CR ." QI-OK" CR
