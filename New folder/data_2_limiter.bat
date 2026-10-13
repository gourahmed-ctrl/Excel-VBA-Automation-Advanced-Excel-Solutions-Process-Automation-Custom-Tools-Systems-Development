@echo off
title Data Usage Limiter
color 0E
setlocal enabledelayedexpansion

:: ========================================
:: Settings
:: ========================================
set "DATA_FILE=usage_data.txt"
set "LIMIT_FILE=limit_settings.txt"
set "MONITOR_FLAG=monitor_active.txt"

:: ========================================
:: Create files if not exist
:: ========================================
if not exist "%DATA_FILE%" echo 0> "%DATA_FILE%"
if not exist "%LIMIT_FILE%" (
    echo LIMIT_MB=1024> "%LIMIT_FILE%"
    echo RESET_DATE=%date%>> "%LIMIT_FILE%"
)

:menu
cls
echo ============================================================
echo            DATA USAGE LIMITER v3.0
echo ============================================================
echo.
echo  1. Set Data Limit (MB/GB)
echo  2. View Current Usage
echo  3. START Monitoring (Background)
echo  4. STOP Monitoring
echo  5. Reset Usage Counter
echo  6. Set Auto-Reset (Daily/Weekly/Monthly)
echo  7. View Connected Devices
echo  8. Check if Monitor is Running
echo  9. Exit
echo.
echo ============================================================
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto set_limit
if "%choice%"=="2" goto view_usage
if "%choice%"=="3" goto start_monitor
if "%choice%"=="4" goto stop_monitor
if "%choice%"=="5" goto reset_usage
if "%choice%"=="6" goto set_auto_reset
if "%choice%"=="7" goto view_devices
if "%choice%"=="8" goto check_monitor
if "%choice%"=="9" exit
goto menu

:set_limit
cls
echo ============================================================
echo              SET DATA LIMIT
echo ============================================================
echo.
call :show_current_limit
echo.
echo 1. 1 GB    2. 2 GB    3. 5 GB
echo 4. 10 GB   5. 20 GB   6. 50 GB
echo 7. 100 GB  8. Custom
echo.
set /p limit_choice="Choose (1-8): "

if "%limit_choice%"=="1" set limit_mb=1024
if "%limit_choice%"=="2" set limit_mb=2048
if "%limit_choice%"=="3" set limit_mb=5120
if "%limit_choice%"=="4" set limit_mb=10240
if "%limit_choice%"=="5" set limit_mb=20480
if "%limit_choice%"=="6" set limit_mb=51200
if "%limit_choice%"=="7" set limit_mb=102400
if "%limit_choice%"=="8" set /p limit_mb="Enter limit in MB: "

echo LIMIT_MB=%limit_mb%> "%LIMIT_FILE%"
echo RESET_DATE=%date%>> "%LIMIT_FILE%"
echo.
echo [OK] Data limit set to %limit_mb% MB
pause
goto menu

:start_monitor
cls
echo ============================================================
echo           STARTING DATA MONITOR...
echo ============================================================
echo.

:: Check if already running
if exist "%MONITOR_FLAG%" (
    echo [WARNING] Monitor is already running!
    echo.
    echo To stop it, use option 4 (STOP Monitoring)
    pause
    goto menu
)

:: Start monitor in a new window (background)
echo Starting monitor in background...
echo %date% %time%> "%MONITOR_FLAG%"

:: Launch monitor in separate window
start /min "Data Monitor" cmd /c call "%~f0" monitor_loop

echo.
echo [OK] Monitor started successfully!
echo [INFO] It's running in a separate window (minimized)
echo [INFO] To stop it, use option 4
echo.
pause
goto menu

:monitor_loop
:: This runs in separate window
title Data Monitor [RUNNING]
color 0A
echo ============================================================
echo    DATA MONITOR [RUNNING]
echo ============================================================
echo.
echo To STOP: Close this window or use option 4
echo.

:: Load limit
for /f "tokens=2 delims==" %%a in ('findstr "LIMIT_MB" "%LIMIT_FILE%" 2^>nul') do set "limit_mb=%%a"
if not defined limit_mb set "limit_mb=1024"

:: Get initial bytes
for /f "tokens=2" %%a in ('netstat -e ^| findstr "Bytes"') do set "start_bytes=%%a"
set "last_used=0"

:monitor_loop_inner
:: Check if we should stop
if not exist "%MONITOR_FLAG%" (
    echo [STOP] Monitor stopped by user.
    timeout /t 3 >nul
    exit
)

:: Get current bytes
for /f "tokens=2" %%a in ('netstat -e ^| findstr "Bytes"') do set "current_bytes=%%a"

:: Calculate used MB
set /a "used_bytes=!current_bytes!-!start_bytes!"
if !used_bytes! LSS 0 set "used_bytes=0"
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
    echo [INFO] To re-enable, reset usage (option 5)
    echo.
    
    :: Keep showing warning
    :warning_loop
    if not exist "%MONITOR_FLAG%" exit
    timeout /t 60 >nul
    goto warning_loop
)

:: Show progress every 10 seconds
set /a "percent=!used_mb!*100/%limit_mb%"
if !percent! GTR 100 set percent=100
echo [!time!] Used: !used_mb! MB / %limit_mb% MB (!percent!%%)

timeout /t 10 >nul
goto monitor_loop_inner

:stop_monitor
cls
echo ============================================================
echo           STOPPING DATA MONITOR...
echo ============================================================
echo.

if not exist "%MONITOR_FLAG%" (
    echo [INFO] Monitor is not running.
    pause
    goto menu
)

:: Delete flag file to stop monitor
del "%MONITOR_FLAG%" 2>nul

echo [OK] Monitor stopped.
echo.
echo Total used:
for /f "usebackq tokens=1" %%a in ("%DATA_FILE%") do echo   %%a MB

:: Enable internet if disabled
call :enable_internet

echo.
pause
goto menu

:reset_usage
cls
echo ============================================================
echo           RESET USAGE COUNTER
echo ============================================================
echo.
echo Current usage:
for /f "usebackq tokens=1" %%a in ("%DATA_FILE%") do echo   %%a MB
echo.
set /p confirm="Reset usage and enable internet? (y/n): "

if /i "%confirm%"=="y" (
    echo 0> "%DATA_FILE%"
    echo [OK] Usage counter reset.
    call :enable_internet
    echo [OK] Internet re-enabled.
) else (
    echo [CANCELLED]
)

pause
goto menu

:view_usage
cls
echo ============================================================
echo              CURRENT DATA USAGE
echo ============================================================
echo.
for /f "usebackq tokens=1" %%a in ("%DATA_FILE%") do set "used_mb=%%a"
if not defined used_mb set used_mb=0

call :show_current_limit
echo.
echo [USAGE]
echo   Total Used: %used_mb% MB
echo.
echo [PERCENTAGE]
call :calculate_percentage %used_mb%

echo.
echo [MONITOR STATUS]
if exist "%MONITOR_FLAG%" (
    echo   RUNNING
) else (
    echo   STOPPED
)

pause
goto menu

:set_auto_reset
cls
echo ============================================================
echo           AUTO-RESET SETTINGS
echo ============================================================
echo.
echo 1. Daily (reset every day)
echo 2. Weekly (reset every Monday)
echo 3. Monthly (reset on 1st of each month)
echo 4. Disable auto-reset
echo.
set /p reset_choice="Choose (1-4): "

if "%reset_choice%"=="1" echo AUTO_RESET=DAILY>> "%LIMIT_FILE%"
if "%reset_choice%"=="2" echo AUTO_RESET=WEEKLY>> "%LIMIT_FILE%"
if "%reset_choice%"=="3" echo AUTO_RESET=MONTHLY>> "%LIMIT_FILE%"
if "%reset_choice%"=="4" echo AUTO_RESET=DISABLED>> "%LIMIT_FILE%"

echo [OK] Auto-reset configured.
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
pause
goto menu

:check_monitor
cls
echo ============================================================
echo           MONITOR STATUS
echo ============================================================
echo.
if exist "%MONITOR_FLAG%" (
    echo STATUS: RUNNING
    echo.
    echo Started: 
    type "%MONITOR_FLAG%"
) else (
    echo STATUS: STOPPED
)
echo.
pause
goto menu

:: ========================================
:: FUNCTIONS
:: ========================================

:show_current_limit
for /f "tokens=2 delims==" %%a in ('findstr "LIMIT_MB" "%LIMIT_FILE%" 2^>nul') do set "limit_mb=%%a"
if not defined limit_mb set "limit_mb=1024"
echo   Data Limit: %limit_mb% MB
exit /b

:calculate_percentage
set "used=%~1"
if not defined used set used=0
if %limit_mb% GTR 0 (
    set /a "percent=!used!*100/%limit_mb%"
    if !percent! GTR 100 set percent=100
    echo   !percent!%% used
) else (
    echo   N/A
)
exit /b

:disable_internet
echo [ACTION] Disabling internet...
netsh interface set interface "Wi-Fi" admin=disable >nul 2>&1
netsh interface set interface "Ethernet" admin=disable >nul 2>&1
exit /b

:enable_internet
echo [ACTION] Enabling internet...
netsh interface set interface "Wi-Fi" admin=enable >nul 2>&1
netsh interface set interface "Ethernet" admin=enable >nul 2>&1
exit /b

:: ========================================
:: Entry point for monitor_loop
:: ========================================
if "%~1"=="monitor_loop" goto monitor_loop