@echo off
title WiFi Scanner
color 0A

echo =====================================
echo Available WiFi Networks
echo =====================================
echo.

netsh wlan show networks mode=bssid | findstr /R /C:"SSID [0-9]" /C:"Authentication" /C:"Signal"

echo.
pause