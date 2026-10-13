<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>لوحة تحكم سكريبتات ويندوز</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
        body {
            background: #0b0e14;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
        }
        .container {
            background: #1a1f2b;
            border-radius: 32px;
            padding: 40px 35px;
            max-width: 900px;
            width: 100%;
            border: 1px solid #2b3342;
            box-shadow: 0 20px 40px rgba(0,0,0,0.7);
        }
        h1 {
            color: #00e6b0;
            font-size: 28px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .sub {
            color: #8892a6;
            font-size: 14px;
            margin-bottom: 30px;
            border-left: 4px solid #00e6b0;
            padding-left: 14px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 16px;
        }
        .btn-card {
            background: #10151f;
            border: 1px solid #28303f;
            border-radius: 18px;
            padding: 22px 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            color: #d3dcec;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 0 #0e121b;
        }
        .btn-card:hover {
            background: #1a212e;
            transform: translateY(-3px);
            border-color: #00e6b0;
            box-shadow: 0 8px 0 #0e121b;
        }
        .btn-card:active {
            transform: translateY(4px);
            box-shadow: 0 2px 0 #0e121b;
        }
        .btn-card .icon {
            font-size: 32px;
        }
        .btn-card .label {
            font-size: 16px;
            font-weight: 600;
        }
        .btn-card .desc {
            font-size: 12px;
            color: #6b8ba4;
        }
        .log-box {
            background: #0a0e17;
            border-radius: 16px;
            padding: 16px 20px;
            margin-top: 28px;
            max-height: 120px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 13px;
            color: #7b8da3;
            border: 1px solid #1e2a3a;
            white-space: pre-wrap;
            line-height: 1.6;
        }
        .log-box .done { color: #00e6b0; }
        .log-box .err { color: #e64a4a; }
        .log-box .info { color: #5b9bd5; }

        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #0a0e17; }
        ::-webkit-scrollbar-thumb { background: #2b3342; border-radius: 10px; }
    </style>
</head>
<body>

<div class="container">

    <h1>🖥️ لوحة تحكم ويندوز</h1>
    <div class="sub">تشغيل سكريبتات النظام • ملفات .bat</div>

    <div class="grid" id="scriptGrid"></div>

    <div class="log-box" id="log">💡 اضغط على أي زر لتشغيل السكريبت...</div>

</div>

<script>
    // قائمة السكريبتات
    const scripts = [
        {
            name: 'مسح الملفات المؤقتة',
            icon: '🧹',
            desc: 'حذف Temp و Prefetch',
            file: 'clean_temp.bat'
        },
        {
            name: 'مسح كاش المتصفحات',
            icon: '🌐',
            desc: 'Chrome / Firefox / Edge',
            file: 'clean_browser_cache.bat'
        },
        {
            name: 'تحليل الشبكة',
            icon: '📡',
            desc: 'IP + ARP + Ping',
            file: 'network_scan.bat'
        },
        {
            name: 'باسوردات الواي فاي',
            icon: '🔑',
            desc: 'عرض كلمات السر المحفوظة',
            file: 'show_wifi_passwords.bat'
        },
        {
            name: 'تسريع النظام',
            icon: '⚡',
            desc: 'تحسين الأداء والذاكرة',
            file: 'speed_up_pc.bat'
        },
        {
            name: 'نسخ احتياطي',
            icon: '💾',
            desc: 'نسخ مجلدات مهمة',
            file: 'backup_files.bat'
        }
    ];

    const grid = document.getElementById('scriptGrid');
    const logBox = document.getElementById('log');

    function log(msg, type = '') {
        const line = document.createElement('div');
        line.textContent = msg;
        if (type) line.className = type;
        logBox.appendChild(line);
        logBox.scrollTop = logBox.scrollHeight;
        while (logBox.children.length > 30) {
            logBox.removeChild(logBox.firstChild);
        }
    }

    function runScript(scriptName, label) {
        log(`⏳ جاري تشغيل: ${label}...`, 'info');

        // إنشاء عنصر <a> مؤقت لتحميل الملف
        const link = document.createElement('a');
        link.href = scriptName;
        link.download = scriptName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        log(`✅ تم تشغيل: ${label} (تم تحميل الملف)`, 'done');
    }

    // إنشاء الأزرار
    scripts.forEach(script => {
        const card = document.createElement('div');
        card.className = 'btn-card';
        card.innerHTML = `
            <div class="icon">${script.icon}</div>
            <div class="label">${script.name}</div>
            <div class="desc">${script.desc}</div>
        `;
        card.addEventListener('click', () => {
            runScript(script.file, script.name);
        });
        grid.appendChild(card);
    });

    log('🟢 لوحة التحكم جاهزة', 'done');
</script>

</body>
</html>