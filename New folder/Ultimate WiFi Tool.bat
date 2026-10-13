@echo off
title Ultimate WiFi Tool
color 0A

:menu
cls
echo ============================================================
echo         ULTIMATE WIFI TOOL
echo ============================================================
echo.
echo  1. Show All Networks
echo  2. Show Connected Devices
echo  3. Show Saved Passwords
echo  4. Show My IP Info
echo  5. Export Everything
echo  6. Exit
echo.
echo ============================================================
set /p c="Choose (1-6): "

if "%c%"=="1" goto net
if "%c%"=="2" goto dev
if "%c%"=="3" goto pass
if "%c%"=="4" goto ip
if "%c%"=="5" goto exp
if "%c%"=="6" exit
goto menu

:net
cls
netsh wlan show networks mode=Bssid
pause
goto menu

:dev
cls
arp -a
pause
goto menu

:pass
cls
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    echo.
    echo Network: %%a
    netsh wlan show profile name="%%a" key=clear | findstr "Key Content"
)
pause
goto menu

:ip
cls
ipconfig | findstr IPv4
pause
goto menu

:exp
set "file=report_%date:/=%.txt"
(
echo ULTIMATE WIFI REPORT
echo Date: %date%
echo Time: %time%
echo ============================================================
netsh wlan show networks mode=Bssid
echo.
echo ============================================================
arp -a
echo.
echo ============================================================
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    echo Network: %%a
    netsh wlan show profile name="%%a" key=clear | findstr "Key Content"
    echo.
)
) > "%file%"
echo Saved to: %file%
pause
goto menu