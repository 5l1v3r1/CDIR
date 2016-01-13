@echo off

rem CDIR v0.2.2

rem if����ERRORLEVEL���펞���f�����邽�߂�ENABLEDELAYEDEXPANSION���Z�b�g
setlocal ENABLEDELAYEDEXPANSION


echo ���C�u�f�[�^���W�c�[�����s�J�n


FOR /F "usebackq" %%i IN (`%CDIR_CSCRIPT% tools\preproc.vbs`) DO SET foldername=%%i

if %ERRORLEVEL% NEQ 0 (
    echo VBScript�̎��s�Ɏ��s���܂����D
    PAUSE
    exit
)


FOR /F "usebackq" %%i IN (`type %foldername%\info\computername`) DO SET computername=%%i
FOR /F "usebackq" %%i IN (`type %foldername%\info\osvolume`) DO SET osvolume=%%i
FOR /F "usebackq" %%i IN (`type %foldername%\info\pagefilepath`) DO SET pagefilepath=%%i
FOR /F "usebackq" %%i IN (`type %foldername%\info\osarchitecture`) DO SET osarchitecture=%%i
FOR /F "usebackq" %%i IN (`type %foldername%\info\version`) DO SET version=%%i


echo "�������_���v���擾:1 �������_���v���擾���Ȃ�:2 �I��:0"
set /p input=">"

if %input%==1 goto memdump
if %input%==2 goto forecopy

goto SKIP


:memdump

echo �������_���v�擾�J�n
rem Windows XP/2003�p
if %version% lss 6 (
    if %osarchitecture% equ 64 (
        tools\RamCapture64.exe %foldername%\RAM_%COMPUTERNAME%.raw
    ) else (
        tools\RamCapture.exe %foldername%\RAM_%COMPUTERNAME%.raw
    )
) else (
    if %osarchitecture% equ 64 (
        tools\RamCapture64.exe %foldername%\RAM_%COMPUTERNAME%.raw
    ) else (
        tools\RamCapture.exe %foldername%\RAM_%COMPUTERNAME%.raw
    )

    rem winpmem�����s�����Ƃ���RamCapture�Ŏ擾����
    if "!ERRORLEVEL!" NEQ "0" (
        rem pagefile.sys��OS�̃{�����[���z���ɂ���Έꏏ�Ɏ擾����
        tools\winpmem.exe -p %pagefilepath% -o %foldername%\RAM_%COMPUTERNAME%.aff4
    )
)
echo �������_���v�擾�I��
echo.

:forecopy

echo ��͗p�f�[�^�擾�J�n

rem $MFT, �v���t�F�b�`�A�C�x���g���O�A���W�X�g�����擾
tools\forecopy.exe -mpeg %foldername%\
move forecopy_handy.log %foldername%\forecopy.log
echo ��͗p�f�[�^�擾�I��
echo.
echo �f�[�^�擾���������܂����B
echo.


:SKIP


PAUSE
exit
