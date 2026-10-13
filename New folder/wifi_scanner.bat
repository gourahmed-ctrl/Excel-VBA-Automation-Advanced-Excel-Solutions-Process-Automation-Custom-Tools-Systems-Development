@echo off
title WiFi Network Scanner Pro
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ============================================================
echo            WIFI NETWORK SCANNER PRO
echo ============================================================
echo.
echo  1. Show All Available WiFi Networks
echo  2. Show Hidden Networks Only
echo  3. Show Advanced Network Details
echo  4. Show Connected Devices
echo  5. Export Results to File
echo  6. Exit
echo.
echo ============================================================
set /p choice="Enter choice (1-6): "

if "%choice%"=="1" goto scan_all
if "%choice%"=="2" goto scan_hidden
if "%choice%"=="3" goto advanced_scan
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto export
if "%choice%"=="6" exit
goto menu

:scan_all
cls
echo ============================================================
echo         ALL AVAILABLE WIFI NETWORKS
echo ============================================================
echo.

echo [SCANNING] Please wait...
echo.

netsh wlan show networks mode=Bssid

echo.
echo ============================================================
echo Hidden networks appear as empty SSID
echo.

pause
goto menu

:scan_hidden
cls
echo ============================================================
echo         HIDDEN WIFI NETWORKS
echo ============================================================
echo.

echo [SCANNING] Looking for hidden networks...
echo.

:: Save to temp file
netsh wlan show networks mode=Bssid > "%temp%\hidden_temp.txt"

echo ----------------------------------------
echo   Hidden Networks Found:
echo ----------------------------------------
echo.

:: Find empty SSID (hidden networks)
findstr /i "SSID" "%temp%\hidden_temp.txt" | findstr /i "SSID.*:$"

if errorlevel 1 (
    echo No hidden networks found
) else (
    echo.
    echo Details for hidden networks:
    findstr /i "BSSID Signal Channel Authentication" "%temp%\hidden_temp.txt" | findstr /v "SSID"
)

del "%temp%\hidden_temp.txt" 2>nul

echo.
pause
goto menu

:advanced_scan
cls
echo ============================================================
echo         ADVANCED NETWORK DETAILS
echo ============================================================
echo.

echo [SCANNING] Advanced scan in progress...
echo.

:: Show full details
netsh wlan show networks mode=Bssid

echo.
echo ============================================================
echo Signal Strength Guide:
echo ============================================================
echo   80-100%% : Excellent (Green)
echo   60-79%%  : Good (Yellow)
echo   40-59%%  : Fair (Orange)
echo   0-39%%   : Weak (Red)
echo.
echo Security Types:
echo   WPA3-Personal  - Newest and most secure
echo   WPA2-Personal  - Most common
echo   WPA-Personal   - Older
echo   WEP            - Very insecure
echo   Open           - No password
echo.

pause
goto menu

:devices
cls
echo ============================================================
echo         CONNECTED DEVICES
echo ============================================================
echo.

echo [SCANNING] Detecting devices on your network...
echo.

:: Show ARP table
arp -a

echo.
echo ============================================================
echo Note: Devices shown are connected to your current network
echo.

pause
goto menu

:export
cls
echo ============================================================
echo         EXPORT RESULTS TO FILE
echo ============================================================
echo.

:: Create filename with date
set "filename=wifi_scan_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
set "filename=%filename: =%"

echo [EXPORTING] Saving results to: %filename%
echo.

(
echo ============================================================
echo   WIFI SCAN REPORT
echo ============================================================
echo.
echo Date: %date%
echo Time: %time%
echo.
echo ============================================================
echo   1. AVAILABLE NETWORKS
echo ============================================================
echo.
netsh wlan show networks mode=Bssid
echo.
echo ============================================================
echo   2. CONNECTED DEVICES
echo ============================================================
echo.
arp -a
echo.
echo ============================================================
echo   3. NETWORK ADAPTERS INFO
echo ============================================================
echo.
ipconfig /all
) > "%filename%"

echo [DONE] Report saved to: %filename%
echo.

set /p view="View file now? (y/n): "

if /i "%view%"=="y" (
    cls
    type "%filename%"
    echo.
)

pause
goto menu