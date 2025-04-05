@echo off
setlocal enabledelayedexpansion

rem === ÀÎÀÚ ÆÄ½Ì ===
set "PROJECT_DIR=%~1"
set "BUILD_MODE=%~2"
set "RUN=%~3"
set "BUILD_TYPE=%~4"

if "%PROJECT_DIR%"=="" (
    echo [USAGE] CBldr.bat "C:\Path\To\Project" [default|debug|release] [run] [rebuild|incremental]
    goto :exit_with_pause
)

cd /d "%PROJECT_DIR%" || (echo [ERROR] Invalid path & goto :exit_with_pause)

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set SRC_DIR=src
set OUT_DIR=out
set OBJ_DIR=obj
for %%I in ("%PROJECT_DIR%") do set "PROJECT_NAME=%%~nI"
set "TARGET=%PROJECT_NAME%.exe"

if not exist "%SRC_DIR%" (
    echo [ERROR] Source folder missing.
    goto :exit_with_pause
)
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
if not exist "%OBJ_DIR%" mkdir "%OBJ_DIR%"

set CFLAGS=
if "%BUILD_MODE%"=="debug" (
    set CFLAGS=/Od /Zi /DDEBUG
) else if "%BUILD_MODE%"=="release" (
    set CFLAGS=/O2 /DNDEBUG
)

if "%BUILD_TYPE%"=="rebuild" (
    del /q "%OUT_DIR%\%TARGET%" 2>nul
    del /q "%OBJ_DIR%\*.obj" 2>nul
)

set FOUND=0
for %%F in ("%SRC_DIR%\*.cpp" "%SRC_DIR%\*.c") do (
    findstr /C:"int main" "%%F" >nul && (
        echo [DEBUG] Found main in: %%F
        call :compile_and_link "%%F"
        echo [DEBUG] Returned from compile_and_link with errorlevel %errorlevel%
        if errorlevel 1 goto :exit_with_pause
        set FOUND=1
        goto :skip_compile
    )
)

if "%FOUND%"=="0" (
    echo [ERROR] No main function found.
    goto :exit_with_pause
)

goto :exit_with_pause

:compile_and_link
set "SRC_FILE=%~1"
set "OBJ_NAME=%~n1"
set "OBJ_PATH=%OBJ_DIR%\%OBJ_NAME%.obj"

echo [DEBUG] Compiling: %SRC_FILE%
cl /nologo /c /Fo"%OBJ_PATH%" /Fe"%OUT_DIR%\%TARGET%" %CFLAGS% "%SRC_FILE%"
if errorlevel 1 (
    echo [ERROR] Compilation failed.
    goto :exit_with_pause
)

link /OUT:"%OUT_DIR%\%TARGET%" "%OBJ_DIR%\*.obj"
if errorlevel 1 (
    echo [ERROR] Linking failed.
    goto :exit_with_pause
)

echo [DEBUG] compile_and_link success
exit /b 0

:skip_compile
echo [DEBUG] reached skip_compile
if /i "%RUN%"=="run" (
    echo [INFO] Running...
    echo ---------------------------
    "%OUT_DIR%\%TARGET%"
    echo ---------------------------
    echo.
)

:ask_again
set /p REPEAT=Run again without rebuilding? (Y/N): 
if /i "!REPEAT!"=="Y" (
    "%OUT_DIR%\%TARGET%"
    goto ask_again
)

:exit_with_pause
echo.
echo [DEBUG] Script exiting. Press any key to close.
pause
exit /b
