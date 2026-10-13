@echo off
title WiFi Password Cracker (Demo)
color 0A

echo ========================================
echo    WIFI PASSWORD CRACKER (DEMO)
echo ========================================
echo.
echo This is just for educational purposes!
echo.

set /p target="Enter network name: "

:: Use a password list
echo Trying common passwords...
echo.

for %%p in (
    "password"
    "12345678"
    "00000000"
    "admin"
    "wifi123"
    "password123"
    "qwerty"
    "letmein"
    "welcome"
    "123456789"
) do (
    echo Trying: %%p
    :: In real life, you would try to connect here
    timeout /t 1 >nul
)

echo.
echo [DEMO] This would take hours/days in real life!
pause