@echo off
title WiFi Scanner
color 0A

:menu
cls
echo ========================================
echo    WIFI NETWORK SCANNER
echo ========================================
echo.
echo 1. Show All Networks (including hidden)
echo 2. Show Only Connected Devices
echo 3. Show Network Details
echo 4. Export to File
echo 5. Exit
echo.
set /p c="Choose (1-5): "

if "%c%"=="1" goto all
if "%c%"=="2" goto devices
if "%c%"=="3" goto details
if "%c%"=="4" goto export
if "%c%"=="5" exit
goto menu

:all
cls
echo ========================================
echo    ALL AVAILABLE NETWORKS
echo ========================================
echo.
netsh wlan show networks mode=Bssid
echo.
echo ========================================
pause
goto menu

:devices
cls
echo ========================================
echo    CONNECTED DEVICES
echo ========================================
echo.
arp -a
echo.
echo ========================================
pause
goto menu

:details
cls
echo ========================================
echo    NETWORK DETAILS
echo ========================================
echo.
netsh wlan show networks mode=Bssid | findstr /i "SSID BSSID Signal Channel Authentication"
echo.
echo ========================================
pause
goto menu

:export
cls
set "file=wifi_scan_%date:/=%.txt"
(
echo WIFI SCAN REPORT
echo Date: %date%
echo Time: %time%
echo ========================================
netsh wlan show networks mode=Bssid
echo.
echo ========================================
echo CONNECTED DEVICES
echo ========================================
arp -a
) > "%file%"
echo Saved to: %file%
echo.
pause
goto menu