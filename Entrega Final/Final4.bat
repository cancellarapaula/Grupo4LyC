tasm numbers.asm
tasm Final.asm
pause
tlink /3 Final.obj numbers.obj /v /s /m
pause
Final.exe
pause
del Final.obj
del Final.map
del numbers.obj
del Final.exe