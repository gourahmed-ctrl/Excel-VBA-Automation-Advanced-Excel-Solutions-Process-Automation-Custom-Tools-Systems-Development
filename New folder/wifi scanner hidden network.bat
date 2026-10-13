@echo off
title WiFi Network Scanner - Complete
color 0E
setlocal enabledelayedexpansion

:menu
cls
echo ============================================================
echo         WIFI NETWORK SCANNER v3.0
echo ============================================================
echo.
echo  1. Scan All Available WiFi Networks (Detailed)
echo  2. Scan Hidden WiFi Networks
echo  3. Show All Networks with Signal Strength
echo  4. Show Devices on Current Network
echo  5. Export All Results
echo  6. Advanced WiFi Info
echo  7. Exit
echo.
echo ============================================================
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto scan_all
if "%choice%"=="2" goto scan_hidden
if "%choice%"=="3" goto signal_scan
if "%choice%"=="4" goto devices_scan
if "%choice%"=="5" goto export_all
if "%choice%"=="6" goto advanced_info
if "%choice%"=="7" exit
goto menu

:scan_all
cls
echo ============================================================
echo         ALL AVAILABLE WIFI NETWORKS
echo ============================================================
echo.

echo [INFO] Scanning for all WiFi networks...
echo.

:: Clean display using PowerShell
powershell -Command "
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '    AVAILABLE WIFI NETWORKS' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# Get networks with BSSID info
$networks = netsh wlan show networks mode=Bssid
$lines = $networks -split '`r`n'

$ssid = ''
$signal = ''
$channel = ''
$security = ''
$bssid = ''

foreach ($line in $lines) {
    if ($line -match 'SSID\s+:\s+(.+)') {
        $ssid = $Matches[1].Trim()
        if ($ssid -eq '') { $ssid = '[HIDDEN]' }
    }
    if ($line -match 'BSSID\s+:\s+(.+)') {
        $bssid = $Matches[1].Trim()
    }
    if ($line -match 'Signal\s+:\s+(.+)') {
        $signal = $Matches[1].Trim()
    }
    if ($line -match 'Channel\s+:\s+(.+)') {
        $channel = $Matches[1].Trim()
    }
    if ($line -match 'Authentication\s+:\s+(.+)') {
        $security = $Matches[1].Trim()
    }
    if ($line -match 'Radio type\s+:\s+(.+)') {
        $radio = $Matches[1].Trim()
        # Display network info
        Write-Host ('SSID: ' + $ssid) -ForegroundColor Yellow
        Write-Host ('  BSSID: ' + $bssid)
        Write-Host ('  Signal: ' + $signal + '%')
        Write-Host ('  Channel: ' + $channel)
        Write-Host ('  Security: ' + $security)
        Write-Host ('  Radio: ' + $radio)
        Write-Host ''
    }
}
"

echo.
pause
goto menu

:scan_hidden
cls
echo ============================================================
echo         HIDDEN WIFI NETWORKS
echo ============================================================
echo.

echo [INFO] Scanning for hidden networks...
echo.

powershell -Command "
Write-Host '========================================' -ForegroundColor Magenta
Write-Host '    HIDDEN WIFI NETWORKS' -ForegroundColor Magenta
Write-Host '========================================' -ForegroundColor Magenta
Write-Host ''

$networks = netsh wlan show networks mode=Bssid
$lines = $networks -split '`r`n'

$found = $false
$ssid = ''
$bssid = ''
$signal = ''
$channel = ''
$security = ''

foreach ($line in $lines) {
    if ($line -match 'SSID\s+:\s+') {
        $ssid = ($line -split ':')[1].Trim()
        if ($ssid -eq '') {
            $found = $true
            $ssid = '[HIDDEN NETWORK]'
        }
    }
    if ($line -match 'BSSID\s+:\s+(.+)') {
        $bssid = $Matches[1].Trim()
    }
    if ($line -match 'Signal\s+:\s+(.+)') {
        $signal = $Matches[1].Trim()
    }
    if ($line -match 'Channel\s+:\s+(.+)') {
        $channel = $Matches[1].Trim()
    }
    if ($line -match 'Authentication\s+:\s+(.+)') {
        $security = $Matches[1].Trim()
        if ($found) {
            Write-Host ('SSID: ' + $ssid) -ForegroundColor Red
            Write-Host ('  BSSID: ' + $bssid)
            Write-Host ('  Signal: ' + $signal + '%')
            Write-Host ('  Channel: ' + $channel)
            Write-Host ('  Security: ' + $security)
            Write-Host ''
            $found = $false
        }
    }
}
"

echo.
pause
goto menu

:signal_scan
cls
echo ============================================================
echo         WIFI SIGNAL STRENGTH
echo ============================================================
echo.

echo [INFO] Scanning signal strength...
echo.

powershell -Command "
Write-Host ('{0,-30} {1,-15} {2,-10} {3,-10}' -f 'SSID', 'Signal', 'Channel', 'Security') -ForegroundColor Cyan
Write-Host ('{0,-30} {1,-15} {2,-10} {3,-10}' -f '----', '------', '-------', '--------') -ForegroundColor Cyan

$networks = netsh wlan show networks mode=Bssid
$lines = $networks -split '`r`n'

$ssid = ''
$signal = ''
$channel = ''
$security = ''

foreach ($line in $lines) {
    if ($line -match 'SSID\s+:\s+(.+)') {
        $ssid = $Matches[1].Trim()
        if ($ssid -eq '') { $ssid = '[HIDDEN]' }
    }
    if ($line -match 'Signal\s+:\s+(.+)') {
        $signal = $Matches[1].Trim()
    }
    if ($line -match 'Channel\s+:\s+(.+)') {
        $channel = $Matches[1].Trim()
    }
    if ($line -match 'Authentication\s+:\s+(.+)') {
        $security = $Matches[1].Trim()
        # Color based on signal
        $sigNum = [int]($signal -replace '%','')
        if ($sigNum -ge 80) { $color = 'Green' }
        elseif ($sigNum -ge 60) { $color = 'Yellow' }
        elseif ($sigNum -ge 40) { $color = 'DarkYellow' }
        else { $color = 'Red' }
        Write-Host ('{0,-30} {1,-15} {2,-10} {3,-10}' -f $ssid, $signal, $channel, $security) -ForegroundColor $color
    }
}
"

echo.
echo ============================================================
echo Signal Guide:
echo   Green = Excellent (80-100%%)
echo   Yellow = Good (60-79%%)
echo   Orange = Fair (40-59%%)
echo   Red = Weak (0-39%%)
echo.

pause
goto menu

:devices_scan
cls
echo ============================================================
echo         DEVICES ON CURRENT NETWORK
echo ============================================================
echo.

echo [INFO] Scanning for devices on your network...
echo.

powershell -Command "
Write-Host '========================================' -ForegroundColor Green
Write-Host '    CONNECTED DEVICES' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Green
Write-Host ''

# Get ARP table
$arpTable = arp -a | Select-String '([0-9]{1,3}\.){3}[0-9]{1,3}\s+([0-9a-f]{2}-){5}[0-9a-f]{2}'
$devices = @()
$count = 0

foreach ($line in $arpTable) {
    $parts = $line -split '\s+'
    $ip = $parts[1]
    $mac = $parts[2]
    
    if ($ip -eq '255.255.255.255' -or $mac -eq 'ff-ff-ff-ff-ff-ff' -or $mac -eq '00-00-00-00-00-00') { continue }
    
    $count++
    $hostname = 'Unknown'
    try {
        $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
    } catch {
        $hostname = 'Unknown'
    }
    
    # Try to get device manufacturer from MAC
    $vendor = 'Unknown'
    $macPrefix = $mac.Substring(0, 8).ToUpper()
    $ouiUrl = 'https://api.macvendors.com/' + $macPrefix
    try {
        $vendor = (Invoke-WebRequest -Uri $ouiUrl -UseBasicParsing).Content
    } catch {
        $vendor = 'Unknown'
    }
    
    $devices += [PSCustomObject]@{
        Number = $count
        IP = $ip
        MAC = $mac
        Name = $hostname
        Vendor = $vendor
    }
}

Write-Host ('{0,-5} {1,-20} {2,-20} {3,-25} {4,-20}' -f 'No.', 'IP Address', 'MAC Address', 'Device Name', 'Vendor')
Write-Host ('{0,-5} {1,-20} {2,-20} {3,-25} {4,-20}' -f '---', '----------', '-----------', '-----------', '------')
foreach ($d in $devices) {
    Write-Host ('{0,-5} {1,-20} {2,-20} {3,-25} {4,-20}' -f $d.Number, $d.IP, $d.MAC, $d.Name, $d.Vendor)
}
Write-Host ''
Write-Host ('Total devices: ' + $count)
"

echo.
pause
goto menu

:export_all
cls
echo ============================================================
echo         EXPORT ALL RESULTS
echo ============================================================
echo.

set "export_file=wifi_full_scan_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
set "export_file=!export_file: =0!"

echo [INFO] Exporting to: %export_file%
echo.

(
echo ============================================================
echo    COMPLETE WIFI SCAN REPORT
echo ============================================================
echo Date: %date%
echo Time: %time%
echo.
echo ============================================================
echo    1. AVAILABLE WIFI NETWORKS
echo ============================================================
echo.
netsh wlan show networks mode=Bssid
echo.
echo ============================================================
echo    2. CURRENT WIFI CONNECTION
echo ============================================================
echo.
netsh wlan show interfaces
echo.
echo ============================================================
echo    3. DEVICES ON NETWORK
echo ============================================================
echo.
arp -a
echo.
echo ============================================================
echo    4. NETWORK ADAPTERS
echo ============================================================
echo.
ipconfig /all
) > "%export_file%"

echo [OK] Export complete!
echo.
echo File saved as: %export_file%
echo.

set /p view="View file now? (y/n): "
if /i "!view!"=="y" type "%export_file%"

pause
goto menu

:advanced_info
cls
echo ============================================================
echo         ADVANCED WIFI INFORMATION
echo ============================================================
echo.

echo [1] All WiFi Networks:
netsh wlan show networks

echo.
echo [2] WiFi Interfaces:
netsh wlan show interfaces

echo.
echo [3] WiFi Drivers:
netsh wlan show drivers

echo.
echo [4] WiFi Profiles (Saved Networks):
netsh wlan show profiles

echo.
echo [5] Hosted Network Info:
netsh wlan show hostednetwork

echo.
pause
goto menu