# ====================================================================
# Ultimate Windows App Installer (Python Edition)
# أداة تفاعلية لتحديد وتثبيت برامج الويندوز دفعة واحدة
# ====================================================================

import os
import subprocess
import time

# تفعيل الألوان في كونسول الويندوز
os.system("")

class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    CYAN = '\033[96m'
    RESET = '\033[0m'

# قاعدة بيانات البرامج (يمكنك إضافة أو حذف أي برنامج تريده هنا)
# التنسيق: "الرقم": ("اسم البرنامج", "Winget ID")
APPS = {
    # برامج الجرافيك والمونتاج
    "1": ("GIMP (Photo Editor)", "GIMP.GIMP"),
    "2": ("Inkscape (Vector Design)", "Inkscape.Inkscape"),
    "3": ("Krita (Digital Painting)", "KDE.Krita"),
    "4": ("Blender (3D & Animation)", "BlenderFoundation.Blender"),
    "5": ("DaVinci Resolve (Video Editor)", "BlackmagicDesign.DaVinciResolve"),
    "6": ("Kdenlive (Video Editor)", "KDE.Kdenlive"),
    "7": ("OBS Studio (Screen Record)", "OBSProject.OBSStudio"),
    "8": ("HandBrake (Video Converter)", "HandBrake.HandBrake"),
    
    # أدوات النظام والمتصفحات
    "9": ("Google Chrome", "Google.Chrome"),
    "10": ("Brave Browser", "Brave.Brave"),
    "11": ("VLC Media Player", "VideoLAN.VLC"),
    "12": ("7-Zip", "7zip.7zip"),
    "13": ("Rufus (Bootable USB)", "Rufus.Rufus"),
    
    # برامج المطورين (Dev Tools)
    "14": ("Python 3", "Python.Python.3.11"),
    "15": ("Visual Studio Code", "Microsoft.VisualStudioCode"),
    "16": ("Git", "Git.Git"),
    "17": ("Notepad++", "Notepad++.Notepad++")
}

def install_app(app_name, app_id):
    print(f"\n{Colors.CYAN}[+] جاري تثبيت: {app_name}...{Colors.RESET}")
    # أمر التثبيت الصامت عبر winget والموافقة التلقائية على الشروط
    command = f'winget install -e --id {app_id} --accept-package-agreements --accept-source-agreements'
    
    try:
        # تشغيل الأمر وانتظار انتهائه
        process = subprocess.run(command, shell=True, capture_output=True, text=True)
        if process.returncode == 0:
            print(f"{Colors.GREEN}[SUCCESS] تم تثبيت {app_name} بنجاح!{Colors.RESET}")
        else:
            print(f"{Colors.RED}[FAILED] حدث خطأ أثناء تثبيت {app_name}. قد يكون مثبتاً بالفعل.{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}[ERROR] {e}{Colors.RESET}")

def main_menu():
    while True:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"{Colors.GREEN}============================================================{Colors.RESET}")
        print(f"{Colors.CYAN}             Ultimate App Installer (Python){Colors.RESET}")
        print(f"{Colors.GREEN}============================================================{Colors.RESET}\n")
        
        # طباعة قائمة البرامج مقسمة لعمودين لشكل جمالي
        items = list(APPS.items())
        for i in range(0, len(items), 2):
            col1 = f"[{items[i][0]}] {items[i][1][0]}"
            if i + 1 < len(items):
                col2 = f"[{items[i+1][0]}] {items[i+1][1][0]}"
                print(f" {col1:<35} {col2}")
            else:
                print(f" {col1}")
                
        print(f"\n{Colors.GREEN}============================================================{Colors.RESET}")
        print(" [A] تثبيت جميع البرامج")
        print(" [X] خروج")
        print(f"{Colors.GREEN}============================================================{Colors.RESET}")
        
        choice = input(f"{Colors.YELLOW}\nأدخل أرقام البرامج مفصولة بفاصلة (مثال: 1,4,15) أو A للكل: {Colors.RESET}").strip().upper()
        
        if choice == 'X':
            break
        elif choice == 'A':
            print(f"\n{Colors.CYAN}سيتم تثبيت جميع البرامج...{Colors.RESET}")
            for key, (name, app_id) in APPS.items():
                install_app(name, app_id)
            os.system("pause")
        else:
            # تحليل الأرقام المدخلة
            selected_keys = [k.strip() for k in choice.split(',')]
            valid_keys = [k for k in selected_keys if k in APPS]
            
            if not valid_keys:
                print(f"{Colors.RED}اختيار غير صحيح، حاول مرة أخرى.{Colors.RESET}")
                time.sleep(2)
                continue
                
            print(f"\n{Colors.CYAN}بدأ تثبيت {len(valid_keys)} برنامج...{Colors.RESET}")
            for key in valid_keys:
                name, app_id = APPS[key]
                install_app(name, app_id)
            
            print(f"\n{Colors.GREEN}============================================================{Colors.RESET}")
            print("                تم الانتهاء من التثبيت المخصص!")
            print(f"{Colors.GREEN}============================================================{Colors.RESET}")
            os.system("pause")

if __name__ == "__main__":
    os.system("title Ultimate App Installer")
    main_menu()