@echo off
title Bluetooth Paired Devices Cleaner
color 0E
setlocal enabledelayedexpansion

echo ========================================
echo    Bluetooth Paired Devices Cleaner
echo ========================================
echo.
echo This script will REMOVE ALL paired Bluetooth devices
echo that are NOT currently connected.
echo.
echo Even if the same device appears multiple times,
echo only the CONNECTED one will be kept.
echo.
echo ========================================
echo.

echo Scanning for Bluetooth devices...
echo.

set "connected_list="

REM First pass: Collect connected devices
echo [INFO] Detecting connected devices...
for /f "tokens=1,2,* delims=," %%a in ('powershell -Command "
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
    Function Await($WinRtTask, $ResultType) {
        $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
        $netTask = $asTask.Invoke($null, @($WinRtTask))
        $netTask.Wait(-1) | Out-Null
        $netTask.Result
    }
    [Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    [Windows.Devices.Bluetooth.BluetoothAdapter,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    [Windows.Devices.Enumeration.DeviceInformation,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    
    $selector = Windows.Devices.Bluetooth.BluetoothDevice.GetDeviceSelector()
    $devices = Await ([Windows.Devices.Enumeration.DeviceInformation]::FindAllAsync($selector)) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Enumeration.DeviceInformation]])
    
    foreach ($d in $devices) {
        $btDevice = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::FromIdAsync($d.Id)) ([Windows.Devices.Bluetooth.BluetoothDevice])
        $name = $d.Name
        if ([string]::IsNullOrEmpty($name)) { $name = 'Unknown Device' }
        $conn = $btDevice.ConnectionStatus
        if ($conn -eq 'Connected') {
            Write-Host "CONNECTED,$name,$($d.Id)"
        } else {
            Write-Host "DISCONNECTED,$name,$($d.Id)"
        }
    }
"') do (
    set "status=%%a"
    set "devname=%%b"
    set "devid=%%c"
    
    if "!status!"=="CONNECTED" (
        echo [CONNECTED] !devname!
        set "connected_list=!connected_list!|!devname!"
    )
)

echo.
echo ========================================
echo.

REM Second pass: Remove ALL disconnected devices
for /f "tokens=1,2,* delims=," %%a in ('powershell -Command "
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
    Function Await($WinRtTask, $ResultType) {
        $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
        $netTask = $asTask.Invoke($null, @($WinRtTask))
        $netTask.Wait(-1) | Out-Null
        $netTask.Result
    }
    [Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    [Windows.Devices.Bluetooth.BluetoothAdapter,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    [Windows.Devices.Enumeration.DeviceInformation,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    
    $selector = Windows.Devices.Bluetooth.BluetoothDevice.GetDeviceSelector()
    $devices = Await ([Windows.Devices.Enumeration.DeviceInformation]::FindAllAsync($selector)) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Enumeration.DeviceInformation]])
    
    foreach ($d in $devices) {
        $btDevice = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::FromIdAsync($d.Id)) ([Windows.Devices.Bluetooth.BluetoothDevice])
        $name = $d.Name
        if ([string]::IsNullOrEmpty($name)) { $name = 'Unknown Device' }
        $conn = $btDevice.ConnectionStatus
        if ($conn -eq 'Connected') {
            Write-Host "CONNECTED,$name,$($d.Id)"
        } else {
            Write-Host "DISCONNECTED,$name,$($d.Id)"
        }
    }
"') do (
    set "status=%%a"
    set "devname=%%b"
    set "devid=%%c"
    
    if "!status!"=="DISCONNECTED" (
        echo [REMOVE] !devname!
        powershell -Command "
            Add-Type -AssemblyName System.Runtime.WindowsRuntime
            \$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { \$_.Name -eq 'AsTask' -and \$_.GetParameters().Count -eq 1 -and \$_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
            Function Await(\$WinRtTask, \$ResultType) {
                \$asTask = \$asTaskGeneric.MakeGenericMethod(\$ResultType)
                \$netTask = \$asTask.Invoke(\$null, @(\$WinRtTask))
                \$netTask.Wait(-1) | Out-Null
                \$netTask.Result
            }
            [Windows.Devices.Bluetooth.BluetoothDevice,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
            \$device = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::FromIdAsync('!devid!')) ([Windows.Devices.Bluetooth.BluetoothDevice])
            if (\$device) {
                \$result = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::UnpairAsync(\$device)) ([Windows.Devices.Bluetooth.BluetoothDeviceUnpairingResult])
                if (\$result.Status -eq 'Unpaired') {
                    Write-Host '  -> Successfully removed'
                } else {
                    Write-Host '  -> Failed: ' \$result.Status
                }
            }
        "
    )
)

echo.
echo ========================================
echo Cleanup complete!
echo.
echo All disconnected Bluetooth devices have been removed.
echo Only currently connected devices remain.
echo.
echo If you have multiple entries of the same device name,
echo only the connected one is kept.
echo.
pause