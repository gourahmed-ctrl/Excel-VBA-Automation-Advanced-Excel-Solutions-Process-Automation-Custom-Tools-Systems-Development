@echo off
title Quick WiFi Scan
color 0A

echo ========================================
echo    QUICK WIFI SCAN
echo ========================================
echo.

echo [INFO] Scanning all networks...
echo.

netsh wlan show networks mode=Bssid | findstr /i "SSID Signal Channel Authentication"

echo.
echo ========================================
echo Hidden networks appear as empty SSID
echo.

pause