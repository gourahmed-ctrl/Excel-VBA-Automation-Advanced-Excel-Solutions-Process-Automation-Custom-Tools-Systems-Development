# 管理者として実行
$paths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        $props = Get-ItemProperty -Path $path
        $props.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
            Set-ItemProperty -Path $path -Name $_.Name -Value ([byte[]](0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))
        }
    }
}