@echo off
title WiFi Password Revealer
color 0A
setlocal enabledelayedexpansion

:menu
cls
echo ============================================================
echo            WIFI PASSWORD REVEALER
echo ============================================================
echo.
echo  1. Show All Saved WiFi Networks
echo  2. Show Password for Specific Network
echo  3. Show Password for Current Connected Network
echo  4. Export All Saved Passwords to File
echo  5. Exit
echo.
echo ============================================================
set /p c="Choose (1-5): "

if "%c%"=="1" goto show_all
if "%c%"=="2" goto show_password
if "%c%"=="3" goto show_current
if "%c%"=="4" goto export_all
if "%c%"=="5" exit
goto menu

:show_all
cls
echo ============================================================
echo         ALL SAVED WIFI NETWORKS
echo ============================================================
echo.

echo [INFO] Networks you have connected to before:
echo.
netsh wlan show profiles | findstr "All User Profile"

echo.
echo ============================================================
pause
goto menu

:show_password
cls
echo ============================================================
echo         GET PASSWORD FOR SPECIFIC NETWORK
echo ============================================================
echo.

echo Available Networks:
echo ----------------------------------------
netsh wlan show profiles | findstr "All User Profile"
echo.
echo ============================================================
echo.

set /p ssid="Enter Network Name (SSID): "

if "%ssid%"=="" (
    echo [ERROR] SSID cannot be empty!
    pause
    goto menu
)

echo.
echo ============================================================
echo    PASSWORD FOR: %ssid%
echo ============================================================
echo.

:: Show password with key=clear to reveal it
netsh wlan show profile name="%ssid%" key=clear | findstr /i "Key Content"

if errorlevel 1 (
    echo [ERROR] Network not found or no password saved!
) else (
    echo.
    echo [SUCCESS] Password found!
)

echo.
pause
goto menu

:show_current
cls
echo ============================================================
echo         PASSWORD FOR CURRENT CONNECTION
echo ============================================================
echo.

:: Get current SSID
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr "SSID" ^| findstr /v "BSSID"') do (
    set "current_ssid=%%a"
    set "current_ssid=!current_ssid: =!"
)

if "%current_ssid%"=="" (
    echo [ERROR] Not connected to any WiFi network!
    pause
    goto menu
)

echo Current Network: %current_ssid%
echo.
echo ============================================================
echo    PASSWORD FOR: %current_ssid%
echo ============================================================
echo.

netsh wlan show profile name="%current_ssid%" key=clear | findstr /i "Key Content"

if errorlevel 1 (
    echo [ERROR] Password not found!
)

echo.
pause
goto menu

:export_all
cls
echo ============================================================
echo         EXPORT ALL PASSWORDS TO FILE
echo ============================================================
echo.

set "file=wifi_passwords_%date:/=%.txt"
set "file=%file: =0%"

echo [EXPORTING] To: %file%
echo.

(
echo ============================================================
echo    ALL SAVED WIFI PASSWORDS
echo ============================================================
echo.
echo Date: %date%
echo Time: %time%
echo.
echo ============================================================
echo.

for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set "ssid=%%a"
    set "ssid=!ssid: =!"
    echo ----------------------------------------
    echo Network: !ssid!
    echo.
    netsh wlan show profile name="!ssid!" key=clear | findstr "Key Content"
    echo.
)

) > "%file%"

echo [DONE] Saved to: %file%
echo.
echo ============================================================
pause
goto menu