@echo off
netsh interface set interface "Wi-Fi" admin=enable
netsh interface set interface "Ethernet" admin=enable
echo ✅ Internet enabled!
pause