@echo off

rem CDIR v0.2.2

ver | findstr "5." > nul 2>&1
if %ERRORLEVEL% EQU 0 goto XP

rem �Ǘ��Ҍ����Ŏ��s����Ă��邩�m�F


for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
	if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
	if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ADMIN%" neq "yes" (
    echo Administrators�O���[�v�ł͂Ȃ����[�U�[�ł��D
    PAUSE
    exit
)
if "%ELEVATED%" neq "yes" (
    echo �v���Z�X�����i����Ă��܂���D
    PAUSE
    exit
)

:XP

pushd %~dp0

rem check cdir.exe, cscript.exe
if EXIST tools\cdir.exe (
    SET CDIR_CMDEXE="tools\cdir.exe"
) else (
    echo cdir.exe ��������܂���ł����D
    PAUSE
    exit
)

if EXIST tools\cscript.exe (
    SET CDIR_CSCRIPT="tools\cscript.exe"
) else (
    SET CDIR_CSCRIPT="%SYSTEMROOT%\System32\cscript.exe"
)

%CDIR_CMDEXE% /C tools\proc.bat
