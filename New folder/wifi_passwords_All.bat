@echo off
title The Ultimate WiFi Tool
color 0A

:menu
cls
echo ============================================================
echo              THE ULTIMATE WIFI TOOL
echo ============================================================
echo.
echo  1. Show Available Networks (including hidden)
echo  2. Show Connected Devices
echo  3. Show Password for Any Saved Network
echo  4. Show Current Network Password
echo  5. Export Everything to File
echo  6. Exit
echo.
echo ============================================================
set /p c="Choose (1-6): "

if "%c%"=="1" goto networks
if "%c%"=="2" goto devices
if "%c%"=="3" goto password
if "%c%"=="4" goto current_pass
if "%c%"=="5" goto export
if "%c%"=="6" exit
goto menu

:networks
cls
netsh wlan show networks mode=Bssid
pause
goto menu

:devices
cls
echo Connected Devices:
echo.
arp -a
echo.
echo Total: 
arp -a | find /c "dynamic"
pause
goto menu

:password
cls
echo Saved Networks:
netsh wlan show profiles | findstr "All User Profile"
echo.
set /p ssid="Enter Network Name: "
netsh wlan show profile name="%ssid%" key=clear | findstr "Key Content"
pause
goto menu

:current_pass
cls
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr "SSID" ^| findstr /v "BSSID"') do set "cur=%%a"
set "cur=%cur: =%"
echo Current Network: %cur%
echo.
netsh wlan show profile name="%cur%" key=clear | findstr "Key Content"
pause
goto menu

:export
set "file=wifi_report_%date:/=%.txt"
(
echo ULTIMATE WIFI REPORT
echo Date: %date%
echo Time: %time%
echo ========================================
echo AVAILABLE NETWORKS
echo ========================================
netsh wlan show networks mode=Bssid
echo.
echo ========================================
echo CONNECTED DEVICES
echo ========================================
arp -a
echo.
echo ========================================
echo SAVED PASSWORDS
echo ========================================
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    echo.
    echo Network: %%a
    netsh wlan show profile name="%%a" key=clear | findstr "Key Content"
)
) > "%file%"
echo Saved to: %file%
pause
goto menu