@echo off

del 001.com
..\masm\masm 001.asm;
..\masm\link 001.obj;
..\masm\exe2bin 001.exe 001.com
del 001.exe

del 001-rel.com
..\masm\masm /DRELEASE 001.asm;
..\masm\link 001.obj;
..\masm\exe2bin 001.exe 001-rel.com
del 001.exe

del 002.com
..\masm\masm 002.asm;
..\masm\link 002.obj;
..\masm\exe2bin 002.exe 002.com
del 002.exe
del 002-rel.com
..\masm\masm /DRELEASE 002.asm;
..\masm\link 002.obj;
..\masm\exe2bin 002.exe 002-rel.com
del 002.exe

del 003.exe
..\masm\masm 003.asm;
..\masm\link 003.obj;

del 004.exe
rem ..\masm\masm 004.asm;
rem ..\masm\link 004.obj;

del 005.exe
rem ..\masm\masm 005.asm;
rem ..\masm\link 005.obj;

dir *.com;*.exe
