@echo off
title Router Devices
color 0A

:: Get gateway IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%a"
    set "gateway=!gateway: =!"
)

echo Gateway: %gateway%
echo.
echo Trying to get devices from router...
echo.

:: Try TP-Link
curl -s "http://%gateway%/data/device_list.json" 2>nul
if %errorlevel% equ 0 (
    echo TP-Link router detected!
    curl -s "http://%gateway%/data/device_list.json"
    pause
    exit
)

:: Try Huawei
curl -s "http://%gateway%/api/device-list" 2>nul
if %errorlevel% equ 0 (
    echo Huawei router detected!
    curl -s "http://%gateway%/api/device-list"
    pause
    exit
)

echo Could not auto-detect. Please check router manually.
pause