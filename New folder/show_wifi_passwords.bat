@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo ==========================================
echo SSID                           PASSWORD
echo ==========================================

for /f "tokens=2 delims=:" %%A in ('netsh wlan show profiles ^| findstr /C:"All User Profile"') do (

    set "SSID=%%A"
    set "SSID=!SSID:~1!"

    set "PASS=[Not Found]"

    for /f "tokens=2 delims=:" %%B in ('netsh wlan show profile name^="!SSID!" key^=clear ^| findstr /C:"Key Content"') do (
        set "PASS=%%B"
        set "PASS=!PASS:~1!"
    )

    echo !SSID!  ^|  !PASS!
)

pause