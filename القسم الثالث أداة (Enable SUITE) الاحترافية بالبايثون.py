# ====================================================================
# Enable SUITE (Python Edition) - Windows Tweaker
# ====================================================================
import winreg
import os
import time
import ctypes
import sys

os.system("")

class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    RESET = '\033[0m'
    CYAN = '\033[96m'

def is_admin():
    try: return ctypes.windll.shell32.IsUserAnAdmin()
    except: return False

def set_registry(hkey, path, key_name, value, reg_type=winreg.REG_DWORD):
    try:
        winreg.CreateKey(hkey, path)
        registry_key = winreg.OpenKey(hkey, path, 0, winreg.KEY_WRITE)
        winreg.SetValueEx(registry_key, key_name, 0, reg_type, value)
        winreg.CloseKey(registry_key)
        return True
    except Exception:
        return False

TWEAKS = {
    "1": ("Enable Dark Mode", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 0),
    "2": ("Enable Activity Feed", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\System", "EnableActivityFeed", 1),
    "3": ("Enable Aero Shake", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "DisallowShaking", 0),
    "4": ("Enable Animations", winreg.HKEY_CURRENT_USER, r"Control Panel\Desktop\WindowMetrics", "MinAnimate", "1"),
    "5": ("Enable AutoPlay All Drives", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoDriveTypeAutoRun", 91),
    "6": ("Enable Background Apps", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications", "GlobalUserDisabled", 0),
    "7": ("Enable Balloon Tips", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "EnableBalloonTips", 1),
    "8": ("Enable Bing Search", winreg.HKEY_CURRENT_USER, r"Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 0),
    "9": ("Enable Chat Icon", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarMn", 1),
    "10": ("Enable Consumer Features", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\CloudContent", "DisableWindowsConsumerFeatures", 0),
    "11": ("Enable Cortana", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\Windows Search", "AllowCortana", 1),
    "12": ("Enable Fast Startup", winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Session Manager\Power", "HiberbootEnabled", 1),
    "13": ("Enable Feedback Notifications", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Siuf\Rules", "NumberOfSIUFInPeriod", 1),
    "14": ("Enable First Logon Animation", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableFirstLogonAnimation", 1),
    "15": ("Enable Game Bar", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\GameDVR", "AppCaptureEnabled", 1),
    "16": ("Enable Game Bar Tips", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\GameBar", "ShowStartupPanel", 1),
    "17": ("Enable Lock Screen Notifications", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\PushNotifications", "LockScreenToastEnabled", 1),
    "18": ("Enable Lock Screen", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 0),
    "19": ("Enable News And Interests", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Feeds", "ShellFeedsTaskbarViewMode", 0),
    "20": ("Enable Recent Docs History", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoRecentDocsHistory", 0),
    "21": ("Enable Remote Assistance", winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Remote Assistance", "fAllowToGetHelp", 1),
    "22": ("Enable Snap Assist", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "SnapAssist", 1),
    "23": ("Enable Startup Delay", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize", "StartupDelayInMSec", 10),
    "24": ("Enable Sticky Keys Prompt", winreg.HKEY_CURRENT_USER, r"Control Panel\Accessibility\StickyKeys", "Flags", "510"),
    "25": ("Enable Suggested Apps", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SilentInstalledAppsEnabled", 1),
    "26": ("Enable Tailored Experiences", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Privacy", "TailoredExperiencesWithDiagnosticDataEnabled", 1),
    "27": ("Enable Taskbar Search Box", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Search", "SearchboxTaskbarMode", 2),
    "28": ("Enable Taskbar Transparency", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "EnableTransparency", 1),
    "29": ("Enable Taskbar Widgets", winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarDa", 1),
    "30": ("Enable Telemetry", winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Policies\Microsoft\Windows\DataCollection", "AllowTelemetry", 1)
}

def execute_tweak(choice):
    if choice not in TWEAKS: return
    name, hkey, path, key_name, value = TWEAKS[choice]
    reg_type = winreg.REG_SZ if isinstance(value, str) else winreg.REG_DWORD
    print(f"\n[{choice}] Enabling {name}...", end=" ")
    if set_registry(hkey, path, key_name, value, reg_type):
        print(f"{Colors.GREEN}[SUCCESS]{Colors.RESET}")
    else:
        print(f"{Colors.RED}[FAILED] (Run as Admin?){Colors.RESET}")

def main_menu():
    while True:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"{Colors.GREEN}============================================================{Colors.RESET}")
        print(f"{Colors.CYAN}                       Enable SUITE (Python Edition){Colors.RESET}")
        print(f"{Colors.GREEN}============================================================{Colors.RESET}\n")
        
        for i in range(1, 31):
            num = str(i)
            space = " " if i < 10 else ""
            print(f"   [{num}]{space} {TWEAKS[num][0]}")
            
        print("\n   [F]  Enable All\n   [X]  Exit\n")
        print(f"{Colors.GREEN}============================================================{Colors.RESET}")
        
        choice = input(f"{Colors.YELLOW}Enter your choice (1-30, F, X): {Colors.RESET}").strip().lower()
        
        if choice == 'x': break
        elif choice == 'f':
            print("\nExecuting FULL ENABLE...")
            for num in range(1, 31): execute_tweak(str(num))
            print(f"\n{Colors.GREEN}============================================================")
            print("           Full Enable completed successfully!")
            print(f"============================================================{Colors.RESET}")
            os.system("pause")
        elif choice in TWEAKS:
            execute_tweak(choice)
            os.system("pause")
        else:
            time.sleep(1)

if __name__ == "__main__":
    if not is_admin():
        print(f"{Colors.YELLOW}Requesting Administrative Privileges...{Colors.RESET}")
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()
    os.system("title Enable SUITE (Python Edition)")
    main_menu()