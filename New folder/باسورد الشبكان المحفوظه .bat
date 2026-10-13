@echo off
setlocal EnableDelayedExpansion

for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| find ":"') do (
    set "ssid=%%a"
    set "ssid=!ssid:~1!"

    echo.
    echo Network: !ssid!

    netsh wlan show profile name="!ssid!" key=clear | findstr /i "Key Content"
)

pause