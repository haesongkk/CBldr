@echo off
setlocal enabledelayedexpansion

:: ======================================
:: 설정 파일 로딩
:: ======================================
for /f "tokens=1,* delims==" %%A in (settings.txt) do (
    set %%A=%%B
)

:: ======================================
:: 소스 파일 정보 추출
:: ======================================
for %%F in ("!SRC!") do (
    set "SRCDIR=%%~dpF"
    set "SRCNAME=%%~nxF"
    set "SRCBASENAME=%%~nF"
)

:: ======================================
:: run.bat 위치 기준으로 output 폴더 생성
:: ======================================
set "BASEDIR=%~dp0"
set "OUTDIR=%BASEDIR%out"
if not exist "!OUTDIR!" mkdir "!OUTDIR!"

:: ======================================
:: 빌드 모드 선택 (기본, release, debug)
:: ======================================
:: 기본: 최적화도 디버깅도 없는 cl 기본 설정
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
:: 환경 설정 및 빌드
:: ======================================
call "!VCVARS!" amd64 || goto error
cd /d !SRCDIR!

cl !SRCNAME! !CLOPTS! /Fo:"!OUTDIR!\!SRCBASENAME!.obj" /Fe:"!OUTDIR!\!SRCBASENAME!.exe" || goto error

:: ======================================
:: obj 정리
:: ======================================
del /q "!OUTDIR!\!SRCBASENAME!.obj"

:: ======================================
:: 실행
:: ======================================
echo.
echo ▶ !SRCBASENAME!.exe 실행 시작...
echo.
"!OUTDIR!\!SRCBASENAME!.exe"
pause
exit /b

:error
echo ? 빌드 또는 실행 중 오류 발생!
pause