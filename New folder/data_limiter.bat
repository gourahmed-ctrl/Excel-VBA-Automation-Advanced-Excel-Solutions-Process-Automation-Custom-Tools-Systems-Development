@echo off
title Data Usage Limiter
color 0E
setlocal enabledelayedexpansion

:: ========================================
:: Settings File
:: ========================================
set "DATA_FILE=usage_data.txt"
set "LIMIT_FILE=limit_settings.txt"

:: ========================================
:: Create files if not exist
:: ========================================
if not exist "%DATA_FILE%" (
    echo 0> "%DATA_FILE%"
    echo %date% %time% - Initialized> "%DATA_FILE%"
)

if not exist "%LIMIT_FILE%" (
    echo LIMIT_MB=1024> "%LIMIT_FILE%"
    echo RESET_DATE=%date%>> "%LIMIT_FILE%"
)

:menu
cls
echo ============================================================
echo            DATA USAGE LIMITER v2.0
echo ============================================================
echo.
echo  1. Set Data Limit (MB/GB)
echo  2. View Current Usage
echo  3. Start Monitoring
echo  4. Stop Monitoring
echo  5. Reset Usage Counter
echo  6. Set Auto-Reset (Daily/Weekly/Monthly)
echo  7. View Connected Devices
echo  8. Exit
echo.
echo ============================================================
echo.
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto set_limit
if "%choice%"=="2" goto view_usage
if "%choice%"=="3" goto start_monitor
if "%choice%"=="4" goto stop_monitor
if "%choice%"=="5" goto reset_usage
if "%choice%"=="6" goto set_auto_reset
if "%choice%"=="7" goto view_devices
if "%choice%"=="8" exit
goto menu

:set_limit
cls
echo ============================================================
echo              SET DATA LIMIT
echo ============================================================
echo.
echo Current Limit:
call :show_current_limit

echo.
echo Enter new limit:
echo  1. 1 GB
echo  2. 2 GB
echo  3. 5 GB
echo  4. 10 GB
echo  5. 20 GB
echo  6. 50 GB
echo  7. 100 GB
echo  8. Custom
echo.
set /p limit_choice="Choose (1-8): "

if "%limit_choice%"=="1" set limit_mb=1024
if "%limit_choice%"=="2" set limit_mb=2048
if "%limit_choice%"=="3" set limit_mb=5120
if "%limit_choice%"=="4" set limit_mb=10240
if "%limit_choice%"=="5" set limit_mb=20480
if "%limit_choice%"=="6" set limit_mb=51200
if "%limit_choice%"=="7" set limit_mb=102400
if "%limit_choice%"=="8" (
    set /p limit_mb="Enter limit in MB: "
)

echo LIMIT_MB=%limit_mb%> "%LIMIT_FILE%"
echo RESET_DATE=%date%>> "%LIMIT_FILE%"
echo.
echo [OK] Data limit set to %limit_mb% MB (%limit_mb%/1024 GB)
echo.
pause
goto menu

:view_usage
cls
echo ============================================================
echo              CURRENT DATA USAGE
echo ============================================================
echo.

set "used_mb=0"
if exist "%DATA_FILE%" (
    for /f "usebackq tokens=1" %%a in ("%DATA_FILE%") do (
        set "used_mb=%%a"
    )
)

call :show_current_limit

echo [USAGE]
echo   Total Used: %used_mb% MB
echo.
echo   Percentage: 
call :calculate_percentage %used_mb%

echo.
echo ============================================================
echo Recent Network Activity:
echo ============================================================
netstat -e | findstr "Bytes"

echo.
pause
goto menu

:start_monitor
cls
echo ============================================================
echo           STARTING DATA MONITOR...
echo ============================================================
echo.

:: Get current network stats
for /f "tokens=2" %%a in ('netstat -e ^| findstr "Bytes"') do (
    set "start_bytes=%%a"
    goto :found_start
)
:found_start

echo Monitoring started at: %time%
echo Data limit: %limit_mb% MB
echo.
echo [RUNNING] Press any key to check usage or Ctrl+C to stop...
echo.

:monitor_loop
timeout /t 10 /nobreak >nul

:: Get current bytes
for /f "tokens=2" %%a in ('netstat -e ^| findstr "Bytes"') do (
    set "current_bytes=%%a"
)

:: Calculate used MB
set /a "used_bytes=!current_bytes!-!start_bytes!"
set /a "used_mb=!used_bytes! / 1048576"

:: Save usage
echo !used_mb!> "%DATA_FILE%"

:: Check if limit exceeded
if !used_mb! GEQ %limit_mb% (
    echo.
    echo ============================================================
    echo [WARNING] DATA LIMIT EXCEEDED!
    echo ============================================================
    echo Used: !used_mb! MB / Limit: %limit_mb% MB
    echo.
    echo [ACTION] Disabling internet connection...
    call :disable_internet
    echo.
    echo [OK] Internet disabled.
    echo.
    echo Press any key to return to menu...
    pause > nul
    goto menu
)

:: Show progress every 5 checks
set /a "check_count+=1"
if !check_count! GEQ 5 (
    set "check_count=0"
    set /a "percent=!used_mb!*100/%limit_mb%"
    echo [!time!] Used: !used_mb! MB / %limit_mb% MB (!percent!%%)
)

goto monitor_loop

:stop_monitor
cls
echo ============================================================
echo           STOPPING DATA MONITOR...
echo ============================================================
echo.
echo [OK] Monitoring stopped.
echo Total used: 
for /f "usebackq tokens=1" %%a in ("%DATA_FILE%") do (
    echo   %%a MB
)
echo.
pause
goto menu

:reset_usage
cls
echo ============================================================
echo           RESET USAGE COUNTER
echo ============================================================
echo.
set /p confirm="Are you sure you want to reset usage? (y/n): "

if /i "%confirm%"=="y" (
    echo 0> "%DATA_FILE%"
    echo [OK] Usage counter reset.
    echo [OK] Internet re-enabled.
    call :enable_internet
) else (
    echo [CANCELLED]
)

pause
goto menu

:set_auto_reset
cls
echo ============================================================
echo           AUTO-RESET SETTINGS
echo ============================================================
echo.
echo 1. Daily (reset every day at midnight)
echo 2. Weekly (reset every Monday)
echo 3. Monthly (reset on 1st of each month)
echo 4. Disable auto-reset
echo.
set /p reset_choice="Choose (1-4): "

if "%reset_choice%"=="1" (
    echo AUTO_RESET=DAILY>> "%LIMIT_FILE%"
    echo [OK] Auto-reset set to DAILY
)
if "%reset_choice%"=="2" (
    echo AUTO_RESET=WEEKLY>> "%LIMIT_FILE%"
    echo [OK] Auto-reset set to WEEKLY
)
if "%reset_choice%"=="3" (
    echo AUTO_RESET=MONTHLY>> "%LIMIT_FILE%"
    echo [OK] Auto-reset set to MONTHLY
)
if "%reset_choice%"=="4" (
    echo AUTO_RESET=DISABLED>> "%LIMIT_FILE%"
    echo [OK] Auto-reset DISABLED
)

pause
goto menu

:view_devices
cls
echo ============================================================
echo           CONNECTED DEVICES
echo ============================================================
echo.

arp -a | findstr "dynamic"

echo.
echo ============================================================
echo To block a specific device, use the Block option in main menu.
echo.
pause
goto menu

:: ========================================
:: FUNCTIONS
:: ========================================

:show_current_limit
for /f "tokens=2 delims==" %%a in ('findstr "LIMIT_MB" "%LIMIT_FILE%"') do (
    set "limit_mb=%%a"
)
if not defined limit_mb set "limit_mb=1024"
echo   Data Limit: %limit_mb% MB (%limit_mb%/1024 GB)
exit /b

:calculate_percentage
set "used=%~1"
if not defined used set "used=0"
if %limit_mb% GTR 0 (
    set /a "percent=!used!*100/%limit_mb%"
    if !percent! GTR 100 set "percent=100"
    echo   !percent!%% used
) else (
    echo   N/A
)
exit /b

:disable_internet
echo Disabling internet...
netsh interface set interface "Wi-Fi" admin=disable >nul 2>&1
netsh interface set interface "Ethernet" admin=disable >nul 2>&1
echo.
echo [OK] Internet disabled. To re-enable, reset usage or restart PC.
exit /b

:enable_internet
echo Enabling internet...
netsh interface set interface "Wi-Fi" admin=enable >nul 2>&1
netsh interface set interface "Ethernet" admin=enable >nul 2>&1
echo [OK] Internet re-enabled.
exit /b

:: ========================================
:: Auto-reset check on startup
:: ========================================
:check_auto_reset
for /f "tokens=2 delims==" %%a in ('findstr "AUTO_RESET" "%LIMIT_FILE%" 2^>nul') do (
    set "auto_reset=%%a"
)

if "%auto_reset%"=="DAILY" (
    for /f "tokens=2 delims==" %%a in ('findstr "RESET_DATE" "%LIMIT_FILE%"') do (
        set "reset_date=%%a"
    )
    if not "!reset_date!"=="%date%" (
        echo 0> "%DATA_FILE%"
        echo RESET_DATE=%date%>> "%LIMIT_FILE%"
        echo [AUTO-RESET] Usage reset (Daily)
    )
)

if "%auto_reset%"=="WEEKLY" (
    :: Check if Monday
    for /f %%a in ('powershell -Command "(Get-Date).DayOfWeek"') do set "day=%%a"
    if "!day!"=="Monday" (
        for /f "tokens=2 delims==" %%a in ('findstr "RESET_DATE" "%LIMIT_FILE%"') do (
            set "reset_date=%%a"
        )
        if not "!reset_date!"=="%date%" (
            echo 0> "%DATA_FILE%"
            echo RESET_DATE=%date%>> "%LIMIT_FILE%"
            echo [AUTO-RESET] Usage reset (Weekly - Monday)
        )
    )
)

if "%auto_reset%"=="MONTHLY" (
    :: Check if 1st of month
    for /f %%a in ('powershell -Command "(Get-Date).Day"') do set "day_num=%%a"
    if "!day_num!"=="1" (
        for /f "tokens=2 delims==" %%a in ('findstr "RESET_DATE" "%LIMIT_FILE%"') do (
            set "reset_date=%%a"
        )
        if not "!reset_date!"=="%date%" (
            echo 0> "%DATA_FILE%"
            echo RESET_DATE=%date%>> "%LIMIT_FILE%"
            echo [AUTO-RESET] Usage reset (Monthly - 1st day)
        )
    )
)

exit /b