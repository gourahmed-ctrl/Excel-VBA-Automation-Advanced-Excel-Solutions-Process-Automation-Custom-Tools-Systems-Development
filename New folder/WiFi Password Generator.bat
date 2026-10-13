@echo off
title WiFi Password Generator
color 0A
setlocal enabledelayedexpansion

set /p chars="Enter characters (e.g., 0123456789): "
set /p length="Enter length (e.g., 4): "

echo Generating combinations...
echo.

set count=0

:loop
:: This is just a concept - real brute force is complex
echo You entered: %chars% with length %length%
echo.
echo In real life, this would generate:
echo %chars% ^ %length% = huge number of combinations
echo.
pause