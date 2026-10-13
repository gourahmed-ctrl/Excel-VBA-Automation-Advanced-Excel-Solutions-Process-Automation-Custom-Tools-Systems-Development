@echo off
title Network Bandwidth Manager - Simplified
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo    Bandwidth Manager
echo ========================================
echo.
echo 1. Scan network devices
echo 2. Set bandwidth limit
echo 3. Remove bandwidth limit
echo 4. Show active limits
echo 5. Block device
echo 6. Exit
echo.
echo ========================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto scan
if "%choice%"=="2" goto set_limit
if "%choice%"=="3" goto remove_limit
if "%choice%"=="4" goto show_limits
if "%choice%"=="5" goto block
if "%choice%"=="6" exit
goto menu

:scan
cls
echo Scanning network...
echo.
echo ========================================
echo    Connected Devices
echo ========================================
echo.

powershell -Command "
$subnet = '192.168.1.'
$devices = @()
for ($i=1; $i -le 254; $i++) {
    $ip = $subnet + $i
    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($ping) {
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
        } catch {
            $hostname = 'Unknown'
        }
        $devices += [PSCustomObject]@{IP=$ip; Name=$hostname}
    }
}
$count = 0
Write-Host ('{0,-5} {1,-20} {2,-30}' -f 'No.', 'IP Address', 'Device Name')
Write-Host ('{0,-5} {1,-20} {2,-30}' -f '---', '----------', '-----------')
foreach ($d in $devices) {
    $count++
    Write-Host ('{0,-5} {1,-20} {2,-30}' -f $count, $d.IP, $d.Name)
}
Write-Host ''
Write-Host ('Total: ' + $count + ' devices found')
"

echo.
echo Press any key to return...
pause > nul
goto menu

:set_limit
cls
echo ========================================
echo    Set Bandwidth Limit
echo ========================================
echo.
echo First, let's scan for devices...
echo.

powershell -Command "
$subnet = '192.168.1.'
$devices = @()
for ($i=1; $i -le 254; $i++) {
    $ip = $subnet + $i
    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($ping) {
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
        } catch {
            $hostname = 'Unknown'
        }
        $devices += [PSCustomObject]@{IP=$ip; Name=$hostname}
    }
}
$count = 0
Write-Host ''
Write-Host ('{0,-5} {1,-20} {2,-30}' -f 'No.', 'IP Address', 'Device Name')
Write-Host ('{0,-5} {1,-20} {2,-30}' -f '---', '----------', '-----------')
foreach ($d in $devices) {
    $count++
    Write-Host ('{0,-5} {1,-20} {2,-30}' -f $count, $d.IP, $d.Name)
}
Write-Host ''
"

set /p dev_num="Enter device number to limit: "

set "target_ip="
for /f "tokens=1,2,* delims=," %%a in ('powershell -Command "
$subnet = '192.168.1.'
$devices = @()
for ($i=1; $i -le 254; $i++) {
    $ip = $subnet + $i
    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($ping) {
        $devices += $ip
    }
}
$count = 0
foreach ($ip in $devices) {
    $count++
    if ($count -eq %dev_num%) {
        Write-Host ('IP,' + $ip)
    }
}
"') do (
    set "target_ip=%%b"
)

if not defined target_ip (
    echo Invalid selection!
    pause
    goto menu
)

echo.
echo Selected IP: %target_ip%
echo.
echo Speed options:
echo 1. 128 Kbps (Slow)
echo 2. 512 Kbps (Medium)
echo 3. 1 Mbps
echo 4. 2 Mbps (Fast)
echo 5. Custom
echo.
set /p speed_choice="Choose: "

if "%speed_choice%"=="1" set speed=128
if "%speed_choice%"=="2" set speed=512
if "%speed_choice%"=="3" set speed=1024
if "%speed_choice%"=="4" set speed=2048
if "%speed_choice%"=="5" (
    set /p speed="Enter speed in Kbps: "
)

echo.
echo Applying limit of %speed% Kbps to %target_ip%...
powershell -Command "New-NetQosPolicy -Name 'Limit_%target_ip%' -IPDstPrefix %target_ip%/32 -ThrottleRateActionBitsPerSecond (%speed%*1024) -ErrorAction SilentlyContinue" >nul 2>&1

if %errorlevel% equ 0 (
    echo ✅ Limit applied successfully!
) else (
    echo ❌ Failed. Run as Administrator!
)

echo.
pause
goto menu

:remove_limit
cls
echo ========================================
echo    Remove Bandwidth Limit
echo ========================================
echo.

echo Active limits:
powershell -Command "Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'} | ForEach-Object { Write-Host $_.Name }"

echo.
set /p remove_ip="Enter IP to remove (or 'all'): "

if /i "%remove_ip%"=="all" (
    powershell -Command "Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'} | Remove-NetQosPolicy"
    echo ✅ All limits removed!
) else (
    powershell -Command "Remove-NetQosPolicy -Name 'Limit_%remove_ip%' -ErrorAction SilentlyContinue"
    echo ✅ Limit removed for %remove_ip%!
)

pause
goto menu

:show_limits
cls
echo ========================================
echo    Active Bandwidth Limits
echo ========================================
echo.

powershell -Command "
$policies = Get-NetQosPolicy | Where-Object {$_.Name -like 'Limit_*'}
if ($policies) {
    $policies | ForEach-Object {
        $ip = $_.Name.Replace('Limit_', '')
        $speed = $_.ThrottleRateActionBitsPerSecond / 1024
        Write-Host ('IP: ' + $ip + '  Speed: ' + $speed + ' Kbps')
    }
} else {
    Write-Host 'No active limits found.'
}
"

echo.
pause
goto menu

:block
cls
echo ========================================
echo    Block/Unblock Device
echo ========================================
echo.

set /p block_ip="Enter IP to block/unblock: "

netsh advfirewall firewall show rule name="Block_%block_ip%" >nul 2>&1
if errorlevel 1 (
    netsh advfirewall firewall add rule name="Block_%block_ip%" dir=in action=block remoteip=%block_ip% protocol=any >nul 2>&1
    netsh advfirewall firewall add rule name="Block_%block_ip%_out" dir=out action=block remoteip=%block_ip% protocol=any >nul 2>&1
    echo ✅ Device blocked!
) else (
    netsh advfirewall firewall delete rule name="Block_%block_ip%" >nul 2>&1
    netsh advfirewall firewall delete rule name="Block_%block_ip%_out" >nul 2>&1
    echo ✅ Device unblocked!
)

pause
goto menu