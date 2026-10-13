@echo off
echo يتم حذف اختصارات بدء التشغيل...
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.*"
echo تم الانتهاء.
pause