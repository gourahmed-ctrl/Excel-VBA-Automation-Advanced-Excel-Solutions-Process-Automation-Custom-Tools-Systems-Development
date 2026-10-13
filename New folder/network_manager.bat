@echo off
title Network Scanner
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo    Network Scanner & Manager
echo ========================================
echo.
echo 1. Show all connected devices (Ping Scan)
echo 2. Show all connected devices (ARP Scan)
echo 3. Find my device IP
echo 4. Show network information
echo 5. Test device connectivity
echo 6. Exit
echo.
echo ========================================
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto ping_scan
if "%choice%"=="2" goto arp_scan
if "%choice%"=="3" goto my_ip
if "%choice%"=="4" goto net_info
if "%choice%"=="5" goto test_device
if "%choice%"=="6" exit
goto menu

:ping_scan
cls
echo ========================================
echo    Ping Scan - Connected Devices
echo ========================================
echo.
echo Scanning network (this may take a moment)...
echo.

set "count=0"
echo IP Address          Hostname
echo ----------          --------

for /L %%i in (1,1,254) do (
    set "ip=192.168.1.%%i"
    ping -n 1 -w 100 !ip! >nul 2>&1
    if !errorlevel! equ 0 (
        set /a count+=1
        for /f "tokens=*" %%a in ('ping -a !ip! -n 1 ^| find "Pinging"') do (
            set "host=%%a"
            set "host=!host:*Pinging =!"
            set "host=!host:[=!"
            set "host=!host:]=!"
            for /f "tokens=1" %%b in ("!host!") do set "hostname=%%b"
        )
        if not defined hostname set "hostname=Unknown"
        echo !ip!        !hostname!
        set "hostname="
    )
)

echo.
echo ========================================
echo Total active devices found: %count%
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:arp_scan
cls
echo ========================================
echo    ARP Scan - Connected Devices
echo ========================================
echo.

arp -a

echo.
echo ========================================
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:my_ip
cls
echo ========================================
echo    My Device Information
echo ========================================
echo.

ipconfig | findstr "IPv4 Address Default Gateway"

echo.
echo ========================================
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:net_info
cls
echo ========================================
echo    Network Information
echo ========================================
echo.

echo [1] IP Configuration:
ipconfig | findstr "IPv4 Subnet Mask Default Gateway"

echo.
echo [2] Network Adapters:
wmic nic where "NetEnabled=true" get Name, Speed

echo.
echo [3] Active Connections:
netstat -an | findstr "ESTABLISHED"

echo.
echo ========================================
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:test_device
cls
echo ========================================
echo    Test Device Connectivity
echo ========================================
echo.

set /p test_ip="Enter IP address to test (e.g., 192.168.1.1): "

echo.
echo Testing %test_ip%...
ping -n 4 %test_ip%

echo.
echo ========================================
echo.
echo Press any key to return to menu...
pause > nul
goto menu