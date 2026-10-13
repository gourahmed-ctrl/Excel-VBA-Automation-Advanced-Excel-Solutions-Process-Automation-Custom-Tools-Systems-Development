@echo off
title My First Cyber Tool
color 0A

echo ============================================================
echo    WELCOME TO MY FIRST CYBER TOOL
echo ============================================================
echo.
echo This is where it all started...
echo.
echo 1. Show Networks
echo 2. Show Devices
echo 3. Show Saved Passwords
echo 4. Exit
echo.
set /p c="Choose: "

if "%c%"=="1" netsh wlan show networks mode=Bssid & pause
if "%c%"=="2" arp -a & pause
if "%c%"=="3" (
    for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
        netsh wlan show profile name="%%a" key=clear | findstr "Key Content"
    )
    pause
)
if "%c%"=="4" exit