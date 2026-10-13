@echo off
title تسريع النظام
color 0A
echo جاري تحسين أداء النظام...
echo.
echo [1] إعادة تشغيل مستكشف الملفات...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo تم.
echo.
echo [2] تحرير الذاكرة...
%windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
echo تم.
echo.
echo [3] تنظيف القرص...
cleanmgr /sagerun:1 >nul 2>&1
echo تم.
echo.
pause