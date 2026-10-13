@echo off
title Disable SUITE
color 0C

:MENU
cls
echo ============================================================
echo                    Disable SUITE
echo ============================================================
echo.
echo   [1]  Disable Dark Mode
echo   [2]  Disable Activity Feed
echo   [3]  Disable Aero Shake
echo   [4]  Disable Animations
echo   [5]  Disable AutoPlay All Drives
echo   [6]  Disable Background Apps
echo   [7]  Disable Balloon Tips
echo   [8]  Disable Bing Search
echo   [9]  Disable Chat Icon
echo   [10] Disable Consumer Features
echo   [11] Disable Cortana
echo   [12] Disable Fast Startup
echo   [13] Disable Feedback Notifications
echo   [14] Disable First Logon Animation
echo   [15] Disable Game Bar
echo   [16] Disable Game Bar Tips
echo   [17] Disable Lock Screen Notifications
echo   [18] Disable Lock Screen
echo   [19] Disable News And Interests
echo   [20] Disable Recent Docs History
echo   [21] Disable Remote Assistance
echo   [22] Disable Snap Assist
echo   [23] Disable Startup Delay
echo   [24] Disable Sticky Keys Prompt
echo   [25] Disable Suggested Apps
echo   [26] Disable Tailored Experiences
echo   [27] Disable Taskbar Search Box
echo   [28] Disable Taskbar Transparency
echo   [29] Disable Taskbar Widgets
echo   [30] Disable Telemetry
echo.
echo   [F]  Disable All
echo   [X]  Exit
echo.
echo ============================================================
set /p CHOICE="Enter your choice (1-30): "

if "%CHOICE%"=="1"  goto DisableDarkMode
if "%CHOICE%"=="2"  goto DisableActivityFeed
if "%CHOICE%"=="3"  goto DisableAeroShake
if "%CHOICE%"=="4"  goto DisableAnimations
if "%CHOICE%"=="5"  goto DisableAutoplayAllDrives
if "%CHOICE%"=="6"  goto DisableBackgroundApps
if "%CHOICE%"=="7"  goto DisableBalloonTips
if "%CHOICE%"=="8"  goto DisableBingSearch
if "%CHOICE%"=="9"  goto DisableChatIcon
if "%CHOICE%"=="10" goto DisableConsumerFeatures
if "%CHOICE%"=="11" goto DisableCortana
if "%CHOICE%"=="12" goto DisableFastStartup
if "%CHOICE%"=="13" goto DisableFeedbackNotifications
if "%CHOICE%"=="14" goto DisableFirstLogonAnimation
if "%CHOICE%"=="15" goto DisableGameBar
if "%CHOICE%"=="16" goto DisableGameBarTips
if "%CHOICE%"=="17" goto DisableLockScreenNotifications
if "%CHOICE%"=="18" goto DisableLockScreen
if "%CHOICE%"=="19" goto DisableNewsAndInterests
if "%CHOICE%"=="20" goto DisableRecentDocsHistory
if "%CHOICE%"=="21" goto DisableRemoteAssistance
if "%CHOICE%"=="22" goto DisableSnapAssist
if "%CHOICE%"=="23" goto DisableStartupDelay
if "%CHOICE%"=="24" goto DisableStickyKeysPrompt
if "%CHOICE%"=="25" goto DisableSuggestedApps
if "%CHOICE%"=="26" goto DisableTailoredExperiences
if "%CHOICE%"=="27" goto DisableTaskbarSearchBox
if "%CHOICE%"=="28" goto DisableTaskbarTransparency
if "%CHOICE%"=="29" goto DisableTaskbarWidgets
if "%CHOICE%"=="30" goto DisableTelemetry
if /I "%CHOICE%"=="f" goto FULL
if /I "%CHOICE%"=="x" exit

echo.
echo Invalid choice.
timeout /t 2 >nul
goto MENU


:: ============================================================
::           Disable Dark Mode
:: ============================================================
:DisableDarkMode
echo [1] Disabling Dark Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable Activity Feed
:: ============================================================
:DisableActivityFeed
echo [2] Disabling Activity Feed...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Aero Shake
:: ============================================================
:DisableAeroShake
echo [3] Disabling Aero Shake...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d 1 /f
pause
goto MENU
:: ============================================================
::           Disable Animations
:: ============================================================
:DisableAnimations
echo [4] Disabling Animations...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable AutoPlay All Drives
:: ============================================================
:DisableAutoplayAllDrives
echo [5] Disabling AutoPlay All Drives...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
pause
goto MENU


:: ============================================================
::           Disable Background Apps
:: ============================================================
:DisableBackgroundApps
echo [6] Disabling Background Apps...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable Balloon Tips
:: ============================================================
:DisableBalloonTips
echo [7] Disabling Balloon Tips...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Bing Search
:: ============================================================
:DisableBingSearch
echo [8] Disabling Bing Search...
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable Chat Icon
:: ============================================================
:DisableChatIcon
echo [9] Disabling Chat Icon...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Consumer Features
:: ============================================================
:DisableConsumerFeatures
echo [10] Disabling Consumer Features...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable Cortana
:: ============================================================
:DisableCortana
echo [11] Disabling Cortana...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Fast Startup
:: ============================================================
:DisableFastStartup
echo [12] Disabling Fast Startup...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Feedback Notifications
:: ============================================================
:DisableFeedbackNotifications
echo [13] Disabling Feedback Notifications...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable First Logon Animation
:: ============================================================
:DisableFirstLogonAnimation
echo [14] Disabling First Logon Animation...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f
pause
goto MENU
:: ============================================================
::           Disable Game Bar
:: ============================================================
:DisableGameBar
echo [15] Disabling Game Bar...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Game Bar Tips
:: ============================================================
:DisableGameBarTips
echo [16] Disabling Game Bar Tips...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Lock Screen Notifications
:: ============================================================
:DisableLockScreenNotifications
echo [17] Disabling Lock Screen Notifications...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Lock Screen
:: ============================================================
:DisableLockScreen
echo [18] Disabling Lock Screen...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable News And Interests
:: ============================================================
:DisableNewsAndInterests
echo [19] Disabling News And Interests...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
pause
goto MENU


:: ============================================================
::           Disable Recent Docs History
:: ============================================================
:DisableRecentDocsHistory
echo [20] Disabling Recent Docs History...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f
pause
goto MENU


:: ============================================================
::           Disable Remote Assistance
:: ============================================================
:DisableRemoteAssistance
echo [21] Disabling Remote Assistance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Snap Assist
:: ============================================================
:DisableSnapAssist
echo [22] Disabling Snap Assist...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Startup Delay
:: ============================================================
:DisableStartupDelay
echo [23] Disabling Startup Delay...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Sticky Keys Prompt
:: ============================================================
:DisableStickyKeysPrompt
echo [24] Disabling Sticky Keys Prompt...
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d 506 /f
pause
goto MENU


:: ============================================================
::           Disable Suggested Apps
:: ============================================================
:DisableSuggestedApps
echo [25] Disabling Suggested Apps...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f
pause
goto MENU
:: ============================================================
::           Disable Tailored Experiences
:: ============================================================
:DisableTailoredExperiences
echo [26] Disabling Tailored Experiences...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Taskbar Search Box
:: ============================================================
:DisableTaskbarSearchBox
echo [27] Disabling Taskbar Search Box...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Taskbar Transparency
:: ============================================================
:DisableTaskbarTransparency
echo [28] Disabling Taskbar Transparency...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Taskbar Widgets
:: ============================================================
:DisableTaskbarWidgets
echo [29] Disabling Taskbar Widgets...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::           Disable Telemetry
:: ============================================================
:DisableTelemetry
echo [30] Disabling Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
pause
goto MENU


:: ============================================================
::                     FULL DISABLE
:: ============================================================
:FULL
echo.
echo ============================================================
echo                    Disable ALL
echo ============================================================
echo.

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d 506 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

echo.
echo ============================================================
echo          Full Disable completed successfully!
echo ============================================================
echo.
pause
goto MENU