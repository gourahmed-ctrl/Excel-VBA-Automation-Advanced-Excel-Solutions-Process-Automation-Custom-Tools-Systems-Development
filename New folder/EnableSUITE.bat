@echo off
title Enable SUITE
color 0A

:MENU
cls
echo ============================================================
echo                     Enable SUITE
echo ============================================================
echo.
echo   [1]  Enable Dark Mode
echo   [2]  Enable Activity Feed
echo   [3]  Enable Aero Shake
echo   [4]  Enable Animations
echo   [5]  Enable AutoPlay All Drives
echo   [6]  Enable Background Apps
echo   [7]  Enable Balloon Tips
echo   [8]  Enable Bing Search
echo   [9]  Enable Chat Icon
echo   [10] Enable Consumer Features
echo   [11] Enable Cortana
echo   [12] Enable Fast Startup
echo   [13] Enable Feedback Notifications
echo   [14] Enable First Logon Animation
echo   [15] Enable Game Bar
echo   [16] Enable Game Bar Tips
echo   [17] Enable Lock Screen Notifications
echo   [18] Enable Lock Screen
echo   [19] Enable News And Interests
echo   [20] Enable Recent Docs History
echo   [21] Enable Remote Assistance
echo   [22] Enable Snap Assist
echo   [23] Enable Startup Delay
echo   [24] Enable Sticky Keys Prompt
echo   [25] Enable Suggested Apps
echo   [26] Enable Tailored Experiences
echo   [27] Enable Taskbar Search Box
echo   [28] Enable Taskbar Transparency
echo   [29] Enable Taskbar Widgets
echo   [30] Enable Telemetry
echo.
echo   [F]  Enable All
echo   [X]  Exit
echo.
echo ============================================================
set /p CHOICE="Enter your choice (1-30): "

if "%CHOICE%"=="1"  goto EnableDarkMode
if "%CHOICE%"=="2"  goto EnableActivityFeed
if "%CHOICE%"=="3"  goto EnableAeroShake
if "%CHOICE%"=="4"  goto EnableAnimations
if "%CHOICE%"=="5"  goto EnableAutoplayAllDrives
if "%CHOICE%"=="6"  goto EnableBackgroundApps
if "%CHOICE%"=="7"  goto EnableBalloonTips
if "%CHOICE%"=="8"  goto EnableBingSearch
if "%CHOICE%"=="9"  goto EnableChatIcon
if "%CHOICE%"=="10" goto EnableConsumerFeatures
if "%CHOICE%"=="11" goto EnableCortana
if "%CHOICE%"=="12" goto EnableFastStartup
if "%CHOICE%"=="13" goto EnableFeedbackNotifications
if "%CHOICE%"=="14" goto EnableFirstLogonAnimation
if "%CHOICE%"=="15" goto EnableGameBar
if "%CHOICE%"=="16" goto EnableGameBarTips
if "%CHOICE%"=="17" goto EnableLockScreenNotifications
if "%CHOICE%"=="18" goto EnableLockScreen
if "%CHOICE%"=="19" goto EnableNewsAndInterests
if "%CHOICE%"=="20" goto EnableRecentDocsHistory
if "%CHOICE%"=="21" goto EnableRemoteAssistance
if "%CHOICE%"=="22" goto EnableSnapAssist
if "%CHOICE%"=="23" goto EnableStartupDelay
if "%CHOICE%"=="24" goto EnableStickyKeysPrompt
if "%CHOICE%"=="25" goto EnableSuggestedApps
if "%CHOICE%"=="26" goto EnableTailoredExperiences
if "%CHOICE%"=="27" goto EnableTaskbarSearchBox
if "%CHOICE%"=="28" goto EnableTaskbarTransparency
if "%CHOICE%"=="29" goto EnableTaskbarWidgets
if "%CHOICE%"=="30" goto EnableTelemetry
if /I "%CHOICE%"=="f" goto FULL
if /I "%CHOICE%"=="x" exit

echo.
echo Invalid choice.
timeout /t 2 >nul
goto MENU


:: ============================================================
::           Enable Dark Mode
:: ============================================================
:EnableDarkMode
echo [1] Enabling Dark Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Activity Feed
:: ============================================================
:EnableActivityFeed
echo [2] Enabling Activity Feed...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Aero Shake
:: ============================================================
:EnableAeroShake
echo [3] Enabling Aero Shake...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d 0 /f
pause
goto MENU
:: ============================================================
::           Enable Animations
:: ============================================================
:EnableAnimations
echo [4] Enabling Animations...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable AutoPlay All Drives
:: ============================================================
:EnableAutoplayAllDrives
echo [5] Enabling AutoPlay All Drives...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 91 /f
pause
goto MENU


:: ============================================================
::           Enable Background Apps
:: ============================================================
:EnableBackgroundApps
echo [6] Enabling Background Apps...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Balloon Tips
:: ============================================================
:EnableBalloonTips
echo [7] Enabling Balloon Tips...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Bing Search
:: ============================================================
:EnableBingSearch
echo [8] Enabling Bing Search...
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Chat Icon
:: ============================================================
:EnableChatIcon
echo [9] Enabling Chat Icon...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Consumer Features
:: ============================================================
:EnableConsumerFeatures
echo [10] Enabling Consumer Features...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Cortana
:: ============================================================
:EnableCortana
echo [11] Enabling Cortana...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Fast Startup
:: ============================================================
:EnableFastStartup
echo [12] Enabling Fast Startup...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Feedback Notifications
:: ============================================================
:EnableFeedbackNotifications
echo [13] Enabling Feedback Notifications...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable First Logon Animation
:: ============================================================
:EnableFirstLogonAnimation
echo [14] Enabling First Logon Animation...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 1 /f
pause
goto MENU
:: ============================================================
::           Enable Game Bar
:: ============================================================
:EnableGameBar
echo [15] Enabling Game Bar...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Game Bar Tips
:: ============================================================
:EnableGameBarTips
echo [16] Enabling Game Bar Tips...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Lock Screen Notifications
:: ============================================================
:EnableLockScreenNotifications
echo [17] Enabling Lock Screen Notifications...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Lock Screen
:: ============================================================
:EnableLockScreen
echo [18] Enabling Lock Screen...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable News And Interests
:: ============================================================
:EnableNewsAndInterests
echo [19] Enabling News And Interests...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Recent Docs History
:: ============================================================
:EnableRecentDocsHistory
echo [20] Enabling Recent Docs History...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Enable Remote Assistance
:: ============================================================
:EnableRemoteAssistance
echo [21] Enabling Remote Assistance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Snap Assist
:: ============================================================
:EnableSnapAssist
echo [22] Enabling Snap Assist...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Startup Delay
:: ============================================================
:EnableStartupDelay
echo [23] Enabling Startup Delay...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 10 /f
pause
goto MENU


:: ============================================================
::           Enable Sticky Keys Prompt
:: ============================================================
:EnableStickyKeysPrompt
echo [24] Enabling Sticky Keys Prompt...
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d 510 /f
pause
goto MENU


:: ============================================================
::           Enable Suggested Apps
:: ============================================================
:EnableSuggestedApps
echo [25] Enabling Suggested Apps...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 1 /f
pause
goto MENU
:: ============================================================
::           Enable Tailored Experiences
:: ============================================================
:EnableTailoredExperiences
echo [26] Enabling Tailored Experiences...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Taskbar Search Box
:: ============================================================
:EnableTaskbarSearchBox
echo [27] Enabling Taskbar Search Box...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 2 /f
pause
goto MENU


:: ============================================================
::           Enable Taskbar Transparency
:: ============================================================
:EnableTaskbarTransparency
echo [28] Enabling Taskbar Transparency...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Taskbar Widgets
:: ============================================================
:EnableTaskbarWidgets
echo [29] Enabling Taskbar Widgets...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Enable Telemetry
:: ============================================================
:EnableTelemetry
echo [30] Enabling Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::                     FULL ENABLE
:: ============================================================
:FULL
call :EnableDarkMode
call :EnableActivityFeed
call :EnableAeroShake
call :EnableAnimations
call :EnableAutoplayAllDrives
call :EnableBackgroundApps
call :EnableBalloonTips
call :EnableBingSearch
call :EnableChatIcon
call :EnableConsumerFeatures
call :EnableCortana
call :EnableFastStartup
call :EnableFeedbackNotifications
call :EnableFirstLogonAnimation
call :EnableGameBar
call :EnableGameBarTips
call :EnableLockScreenNotifications
call :EnableLockScreen
call :EnableNewsAndInterests
call :EnableRecentDocsHistory
call :EnableRemoteAssistance
call :EnableSnapAssist
call :EnableStartupDelay
call :EnableStickyKeysPrompt
call :EnableSuggestedApps
call :EnableTailoredExperiences
call :EnableTaskbarSearchBox
call :EnableTaskbarTransparency
call :EnableTaskbarWidgets
call :EnableTelemetry

echo.
echo ============================================================
echo          Full Enable completed successfully!
echo ============================================================
echo.
pause
goto MENU