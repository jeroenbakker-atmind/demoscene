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

dir *.com
