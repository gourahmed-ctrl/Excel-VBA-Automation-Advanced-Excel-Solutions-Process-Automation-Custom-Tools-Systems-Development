@echo off
title تحليل الشبكة
color 0A
echo ========================================
echo         تحليل الشبكة
echo ========================================
echo.
echo [1] معلومات الـ IP:
ipconfig | findstr "IPv4"
echo.
echo [2] الأجهزة المتصلة:
arp -a
echo.
echo [3] اختبار الاتصال بالبوابة:
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%a"
    set "gateway=!gateway: =!"
)
ping -n 2 !gateway!
echo.
pause