@echo off
title Get Connected Devices from Router
color 0E

echo ========================================
echo    GET DEVICES FROM ROUTER
echo ========================================
echo.

:: Get gateway IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%a"
    set "gateway=!gateway: =!"
)

echo Router IP: %gateway%
echo.

:: Try to get device list from router (common models)
echo [INFO] Attempting to get device list...
echo.

:: For TP-Link routers
curl -s "http://%gateway%/data/device_list.json" 2>nul
if %errorlevel% equ 0 (
    echo [OK] Got device list from TP-Link router!
    pause
    goto :end
)

:: For Huawei routers
curl -s "http://%gateway%/api/device-list" 2>nul
if %errorlevel% equ 0 (
    echo [OK] Got device list from Huawei router!
    pause
    goto :end
)

:: Fallback to ARP
echo [INFO] Using ARP table...
arp -a

:end
pause