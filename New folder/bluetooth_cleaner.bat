@echo off
title Quick Bluetooth Cleaner
color 0A

echo ========================================
echo    Quick Bluetooth Cleaner
echo ========================================
echo.

powershell -Command "
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
Function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
[Windows.Devices.Bluetooth.BluetoothDevice,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
[Windows.Devices.Enumeration.DeviceInformation,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null

$selector = Windows.Devices.Bluetooth.BluetoothDevice.GetDeviceSelector()
$devices = Await ([Windows.Devices.Enumeration.DeviceInformation]::FindAllAsync($selector)) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Enumeration.DeviceInformation]])

$count = 0
foreach ($d in $devices) {
    $btDevice = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::FromIdAsync($d.Id)) ([Windows.Devices.Bluetooth.BluetoothDevice])
    $name = $d.Name
    if ([string]::IsNullOrEmpty($name)) { $name = 'Unknown Device' }
    $conn = $btDevice.ConnectionStatus
    
    if ($conn -ne 'Connected') {
        Write-Host \"Removing: $name\"
        $result = Await ([Windows.Devices.Bluetooth.BluetoothDevice]::UnpairAsync($btDevice)) ([Windows.Devices.Bluetooth.BluetoothDeviceUnpairingResult])
        if ($result.Status -eq 'Unpaired') {
            $count++
        }
    }
}
Write-Host \"`nRemoved $count disconnected devices.\"
"

echo.
pause