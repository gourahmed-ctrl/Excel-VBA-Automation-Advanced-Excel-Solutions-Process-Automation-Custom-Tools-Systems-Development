@echo off
title WiFi Network Scanner & Devices Detector
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ============================================================
echo         WIFI NETWORK SCANNER & DEVICE DETECTOR
echo ============================================================
echo.
echo  1. Scan Available WiFi Networks
echo  2. Scan Specific WiFi Network for Devices
echo  3. Auto-Scan All Networks for Devices
echo  4. Show WiFi Signal Strength
echo  5. Show WiFi Security Type
echo  6. Export Results to File
echo  7. Advanced Network Info
echo  8. Exit
echo.
echo ============================================================
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto scan_wifi
if "%choice%"=="2" goto scan_devices
if "%choice%"=="3" goto auto_scan
if "%choice%"=="4" goto signal_strength
if "%choice%"=="5" goto security_info
if "%choice%"=="6" goto export_results
if "%choice%"=="7" goto advanced_info
if "%choice%"=="8" exit
goto menu

:scan_wifi
cls
echo ============================================================
echo         SCANNING AVAILABLE WIFI NETWORKS
echo ============================================================
echo.

echo [INFO] Scanning for WiFi networks...
echo.

:: Get WiFi networks
powershell -Command "
$networks = netsh wlan show networks mode=Bssid
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '    AVAILABLE WIFI NETWORKS' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''
Write-Host ('{0,-25} {1,-10} {2,-10} {3,-15}' -f 'SSID', 'Signal', 'Channel', 'Security')
Write-Host ('{0,-25} {1,-10} {2,-10} {3,-15}' -f '----', '------', '-------', '--------')
"

:: Parse and display networks
for /f "tokens=1,* delims=:" %%a in ('netsh wlan show networks mode=Bssid ^| findstr /i "SSID BSSID Signal Channel Authentication"') do (
    set "key=%%a"
    set "value=%%b"
    set "value=!value: =!"
    
    if "!key!"=="SSID" (
        set "current_ssid=!value!"
        echo !current_ssid! - Found
    )
    
    if "!key!"=="Signal" (
        set "signal=!value!"
    )
    
    if "!key!"=="Channel" (
        set "channel=!value!"
    )
    
    if "!key!"=="Authentication" (
        set "security=!value!"
        echo.
    )
)

echo.
echo ============================================================
echo To see detailed network info, use option 7
echo.
pause
goto menu

:scan_devices
cls
echo ============================================================
echo         SCAN NETWORK FOR DEVICES
echo ============================================================
echo.

:: First show available networks
echo Available WiFi Networks:
echo ============================================================
netsh wlan show networks | findstr "SSID"
echo.
echo ============================================================
echo.

set /p target_ssid="Enter WiFi Network Name (SSID) to scan: "

if "%target_ssid%"=="" (
    echo [ERROR] SSID cannot be empty!
    pause
    goto menu
)

echo.
echo [INFO] Scanning for devices on: %target_ssid%
echo [INFO] This may take 30-60 seconds...
echo.

:: Try to find the network and connected devices
powershell -Command "
$ssid = '%target_ssid%'
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '    DEVICES ON: ' $ssid -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# Try using ARP to find devices on same network
$arpTable = arp -a | Select-String '([0-9]{1,3}\.){3}[0-9]{1,3}\s+([0-9a-f]{2}-){5}[0-9a-f]{2}'
$devices = @()
$count = 0

foreach ($line in $arpTable) {
    $parts = $line -split '\s+'
    $ip = $parts[1]
    $mac = $parts[2]
    
    if ($ip -eq '255.255.255.255') { continue }
    if ($mac -eq 'ff-ff-ff-ff-ff-ff') { continue }
    if ($mac -eq '00-00-00-00-00-00') { continue }
    
    $count++
    $hostname = 'Unknown'
    try {
        $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
    } catch {
        $hostname = 'Unknown'
    }
    
    $devices += [PSCustomObject]@{
        Number = $count
        IP = $ip
        MAC = $mac
        Name = $hostname
    }
}

Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f 'No.', 'IP Address', 'MAC Address', 'Device Name')
Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f '---', '----------', '-----------', '-----------')
foreach ($d in $devices) {
    Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f $d.Number, $d.IP, $d.MAC, $d.Name)
}
Write-Host ''
Write-Host ('Total devices found: ' + $count)
"

echo.
pause
goto menu

:auto_scan
cls
echo ============================================================
echo         AUTO-SCAN ALL WIFI NETWORKS
echo ============================================================
echo.

echo [INFO] Scanning all available WiFi networks...
echo [INFO] This will take 1-2 minutes...
echo.

:: Get all SSIDs
set "ssid_count=0"
for /f "tokens=1,* delims=:" %%a in ('netsh wlan show networks ^| findstr "SSID"') do (
    set /a ssid_count+=1
    set "ssid_!ssid_count!=%%b"
    set "ssid_!ssid_count!=!ssid_%ssid_count%: =!"
    echo [!ssid_count!] %%b
)

if %ssid_count% equ 0 (
    echo [ERROR] No WiFi networks found!
    pause
    goto menu
)

echo.
echo ============================================================
echo Select network to scan for devices:
echo.
set /p network_choice="Enter network number (1-%ssid_count%): "

if %network_choice% gtr %ssid_count% (
    echo [ERROR] Invalid choice!
    pause
    goto menu
)

:: Get selected SSID
for /f "tokens=*" %%a in ('set ssid_%network_choice%') do set "selected_ssid=%%a"
set "selected_ssid=!selected_ssid:*==!"

echo.
echo [INFO] Scanning devices on: !selected_ssid!
echo.

:: Get device list
powershell -Command "
$ssid = '!selected_ssid!'
Write-Host '========================================' -ForegroundColor Green
Write-Host '    DEVICES ON: ' $ssid -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Green
Write-Host ''

$devices = @()
$count = 0

# Get ARP table
$arpTable = arp -a | Select-String '([0-9]{1,3}\.){3}[0-9]{1,3}\s+([0-9a-f]{2}-){5}[0-9a-f]{2}'
foreach ($line in $arpTable) {
    $parts = $line -split '\s+'
    $ip = $parts[1]
    $mac = $parts[2]
    
    if ($ip -eq '255.255.255.255' -or $mac -eq 'ff-ff-ff-ff-ff-ff' -or $mac -eq '00-00-00-00-00-00') { continue }
    
    $count++
    $hostname = 'Unknown'
    try {
        $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
    } catch {}
    
    $devices += [PSCustomObject]@{Number=$count; IP=$ip; MAC=$mac; Name=$hostname}
}

Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f 'No.', 'IP Address', 'MAC Address', 'Device Name')
Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f '---', '----------', '-----------', '-----------')
foreach ($d in $devices) {
    Write-Host ('{0,-5} {1,-20} {2,-20} {3,-30}' -f $d.Number, $d.IP, $d.MAC, $d.Name)
}
Write-Host ''
Write-Host ('Total devices: ' + $count)
"

echo.
pause
goto menu

:signal_strength
cls
echo ============================================================
echo         WIFI SIGNAL STRENGTH
echo ============================================================
echo.

netsh wlan show networks mode=Bssid | findstr /i "SSID Signal"

echo.
echo ============================================================
echo Signal Strength Guide:
echo ============================================================
echo   Excellent: 80-100% (Full bars)
echo   Good:      60-79%  (3 bars)
echo   Fair:      40-59%  (2 bars)
echo   Weak:      20-39%  (1 bar)
echo   Very Weak: 0-19%   (No bars)
echo.

pause
goto menu

:security_info
cls
echo ============================================================
echo         WIFI SECURITY INFORMATION
echo ============================================================
echo.

netsh wlan show networks | findstr /i "SSID Authentication"

echo.
echo ============================================================
echo Security Types:
echo ============================================================
echo   WPA2-Personal   - Most common, secure
echo   WPA3-Personal   - Newest, most secure
echo   WPA-Personal    - Older, less secure
echo   WEP            - Very old, insecure
echo   Open           - No password, insecure
echo.

pause
goto menu

:export_results
cls
echo ============================================================
echo         EXPORT RESULTS TO FILE
echo ============================================================
echo.

set "export_file=wifi_scan_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
set "export_file=!export_file: =0!"

echo [INFO] Scanning networks...
netsh wlan show networks > "%export_file%"
echo [INFO] Adding device list...
echo. >> "%export_file%"
echo ======================================== >> "%export_file%"
echo DEVICES ON NETWORK >> "%export_file%"
echo ======================================== >> "%export_file%"
arp -a >> "%export_file%"

echo.
echo [OK] Results exported to: %export_file%
echo.
type "%export_file%"
echo.
pause
goto menu

:advanced_info
cls
echo ============================================================
echo         ADVANCED NETWORK INFORMATION
echo ============================================================
echo.

echo [1] WiFi Networks Details:
netsh wlan show networks mode=Bssid | findstr /i "SSID BSSID Signal Channel Authentication"

echo.
echo [2] Current WiFi Connection:
netsh wlan show interfaces

echo.
echo [3] WiFi Drivers:
netsh wlan show drivers | findstr /i "Name Version"

echo.
echo [4] MAC Addresses in Network:
arp -a | findstr "dynamic"

echo.
pause
goto menu