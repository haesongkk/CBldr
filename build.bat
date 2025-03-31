@echo off
setlocal enabledelayedexpansion

:: ======================================
:: ���� ���� �ε�
:: ======================================
for /f "tokens=1,* delims==" %%A in (settings.txt) do (
    set %%A=%%B
)

:: ======================================
:: �ҽ� ���� ���� ����
:: ======================================
for %%F in ("!SRC!") do (
    set "SRCDIR=%%~dpF"
    set "SRCNAME=%%~nxF"
    set "SRCBASENAME=%%~nF"
)

:: ======================================
:: run.bat ��ġ �������� output ���� ����
:: ======================================
set "BASEDIR=%~dp0"
set "OUTDIR=%BASEDIR%out"
if not exist "!OUTDIR!" mkdir "!OUTDIR!"

:: ======================================
:: ���� ��� ���� (�⺻, release, debug)
:: ======================================
:: �⺻: ����ȭ�� ����뵵 ���� cl �⺻ ����
:: release: /O2 /MD
:: debug: /Od /Zi /MDd

set "BUILD_MODE=%1"
if /i "!BUILD_MODE!"=="release" (
    set "CLOPTS=/O2 /MD"
) else if /i "!BUILD_MODE!"=="debug" (
    set "CLOPTS=/Od /Zi /MDd"
) else (
    set "CLOPTS="
)

:: ======================================
:: ȯ�� ���� �� ����
:: ======================================
call "!VCVARS!" amd64 || goto error
cd /d !SRCDIR!

cl !SRCNAME! !CLOPTS! /Fo:"!OUTDIR!\!SRCBASENAME!.obj" /Fe:"!OUTDIR!\!SRCBASENAME!.exe" || goto error

:: ======================================
:: obj ����
:: ======================================
del /q "!OUTDIR!\!SRCBASENAME!.obj"

:: ======================================
:: ����
:: ======================================
echo.
echo �� !SRCBASENAME!.exe ���� ����...
echo.
"!OUTDIR!\!SRCBASENAME!.exe"
pause
exit /b

:error
echo ? ���� �Ǵ� ���� �� ���� �߻�!
pause