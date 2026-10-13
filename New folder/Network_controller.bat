```bat
@echo off
title Bandwidth Controller
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo       BANDWIDTH CONTROLLER
echo ========================================
echo.
echo 1. Show connected devices
echo 2. Limit bandwidth for IP
echo 3. Remove limit for IP
echo 4. Show all limits
echo 5. Block / Unblock device
echo 6. Exit
echo.
echo ========================================
set /p choice="Enter choice: "

if "%choice%"=="1" goto show
if "%choice%"=="2" goto limit
if "%choice%"=="3" goto remove
if "%choice%"=="4" goto showlimits
if "%choice%"=="5" goto block
if "%choice%"=="6" exit

goto menu


:show
cls
echo ========================================
echo       CONNECTED DEVICES
echo ========================================
echo.

arp -a | findstr "dynamic"

echo.
pause
goto menu


:limit
cls
echo ========================================
echo       SET BANDWIDTH LIMIT
echo ========================================
echo.

arp -a | findstr "dynamic"

echo.
set /p target_ip="Enter IP address to limit: "

if "%target_ip%"=="" goto menu

echo.
echo Speed Options:
echo.
echo 1. 128 Kbps
echo 2. 256 Kbps
echo 3. 512 Kbps
echo 4. 1 Mbps
echo 5. 2 Mbps
echo 6. Custom
echo.

set /p speed_choice="Choose (1-6): "

if "%speed_choice%"=="1" set speed=128
if "%speed_choice%"=="2" set speed=256
if "%speed_choice%"=="3" set speed=512
if "%speed_choice%"=="4" set speed=1024
if "%speed_choice%"=="5" set speed=2048

if "%speed_choice%"=="6" (
    set /p speed="Enter speed in Kbps: "
)

if not defined speed (
    echo.
    echo [ERROR] Invalid speed selection.
    pause
    goto menu
)

echo.
echo ========================================
echo Applying limit...
echo IP    : %target_ip%
echo Speed : %speed% Kbps
echo ========================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"try { ^
    Remove-NetQosPolicy -Name 'Limit_%target_ip%' -ErrorAction SilentlyContinue; ^
    New-NetQosPolicy -Name 'Limit_%target_ip%' -IPDstPrefix '%target_ip%/32' -ThrottleRateActionBitsPerSecond ([uint64]%speed% * 1024) -ErrorAction Stop; ^
    Write-Host '[OK] Limit applied successfully!' ^
} catch { ^
    Write-Host '[FAILED] Could not apply the limit.'; ^
    Write-Host $_.Exception.Message; ^
    exit 1 ^
}"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [OK] LIMIT APPLIED
    echo IP    : %target_ip%
    echo Speed : %speed% Kbps
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [FAILED]
    echo.
    echo Make sure this BAT file is running
    echo as Administrator.
    echo ========================================
)

set speed=
echo.
pause
goto menu


:remove
cls
echo ========================================
echo       REMOVE BANDWIDTH LIMIT
echo ========================================
echo.

powershell -NoProfile -Command ^
"Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'} | Select-Object Name,ThrottleRateActionBitsPerSecond | Format-Table -AutoSize"

echo.
set /p target_ip="Enter IP to remove (or 'all'): "

if "%target_ip%"=="" goto menu

if /i "%target_ip%"=="all" (

    powershell -NoProfile -Command ^
    "Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'} | Remove-NetQosPolicy -Confirm:$false"

    if %errorlevel% equ 0 (
        echo.
        echo [OK] All limits removed!
    ) else (
        echo.
        echo [FAILED] Could not remove limits.
    )

) else (

    powershell -NoProfile -Command ^
    "Remove-NetQosPolicy -Name 'Limit_%target_ip%' -Confirm:$false -ErrorAction Stop"

    if %errorlevel% equ 0 (
        echo.
        echo [OK] Limit removed for %target_ip%!
    ) else (
        echo.
        echo [FAILED] No limit found for %target_ip%.
    )
)

echo.
pause
goto menu


:showlimits
cls
echo ========================================
echo          ACTIVE LIMITS
echo ========================================
echo.

powershell -NoProfile -Command ^
"$policies = Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'}; ^
if ($policies) { ^
    foreach ($p in $policies) { ^
        $ip = $p.Name -replace '^Limit_',''; ^
        $speed = $p.ThrottleRateActionBitsPerSecond / 1024; ^
        Write-Host ('IP: ' + $ip + '    Speed: ' + $speed + ' Kbps') ^
    } ^
} else { ^
    Write-Host 'No active limits found.' ^
}"

echo.
pause
goto menu


:block
cls
echo ========================================
echo       BLOCK / UNBLOCK DEVICE
echo ========================================
echo.

arp -a | findstr "dynamic"

echo.
set /p block_ip="Enter IP to block/unblock: "

if "%block_ip%"=="" goto menu

netsh advfirewall firewall show rule name="Block_%block_ip%" >nul 2>&1

if errorlevel 1 (

    netsh advfirewall firewall add rule ^
    name="Block_%block_ip%" ^
    dir=in ^
    action=block ^
    remoteip=%block_ip% ^
    protocol=any >nul 2>&1

    if %errorlevel% equ 0 (
        echo.
        echo [OK] Device blocked!
    ) else (
        echo.
        echo [FAILED] Could not block device.
    )

) else (

    netsh advfirewall firewall delete rule ^
    name="Block_%block_ip%" >nul 2>&1

    if %errorlevel% equ 0 (
        echo.
        echo [OK] Device unblocked!
    ) else (
        echo.
        echo [FAILED] Could not unblock device.
    )
)

echo.
pause
goto menu
```
