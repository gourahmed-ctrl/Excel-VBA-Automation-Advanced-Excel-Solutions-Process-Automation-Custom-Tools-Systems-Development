# سجل الصور السحابي الخاص - Private Photo Vault

تطبيق وقاعدة بيانات خاصة متكاملة لحفظ وأرشفة الصور الشخصية برقم تسلسلي، مع إمكانية الرفع والتنزيل والحذف في أي وقت، ومصادقة مستخدمين آمنة عبر حساب Google.

---

## 🚀 المميزات الرئيسية
1. **قاعدة بيانات خاصة:** كل مستخدم لديه قاعدة بياناته المشفرة الخاصة به في Firebase Firestore.
2. **عامود التسلسل (Sequence #):** ترقيم تلقائي متصاعد يبدأ من `#1` لكل صورة تُرفع.
3. **عامود الصور:** معالجة وضغط ذكي للصور وتخزين آمن وعرض فوري.
4. **التحكم الشامل:**
   - رفع من المعرض أو السحب والإفلات أو اللصق (Ctrl+V) أو كاميرا الهاتف مباشرة.
   - تنزيل فوري لأي صورة بجودتها الأصلية أو تنزيل جماعي.
   - حذف مؤكد لأي صورة أو حذف جماعي.
5. **تسجيل دخول وخروج بحساب Google:** حماية كاملة باستخدام Google Authentication وقواعد أمان Firestore ABAC.
6. **واجهة أندرويد متجاوبة:** تصميم متوافق مع الهواتف بأسلوب Material 3، وزر عائم (FAB)، ووضع تكبير الشاشة (Lightbox).

---

## 📦 كيفية رفع المشروع إلى GitHub

1. قم بفك الضغط عن هذا المجلد على جهازك.
2. افتح موجه الأوامر (Terminal أو Git Bash) داخل مجلد المشروع.
3. قم بتنفيذ الأوامر التالية:

```bash
git init
git add .
git commit -m "Initial commit: Private Photo Vault"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

---

## 📱 كيفية استخراج وتحويل المشروع إلى تطبيق أندرويد (APK)

لديك طريقتان سهلتان للحصول على ملف APK:

### الطريقة الأولى (الأسهل والأسرع - أونلاين مجاناً بدون تثبيت برامج):
1. افتح موقع **[PWABuilder](https://www.pwabuilder.com/)**.
2. ضع رابط التطبيق المنشور الخاص بك.
3. اضغط على **Build APK** لتحميل ملف الـ APK جاهزاً للتثبيت المباشر على هاتفك الأندرويد!

### الطريقة الثانية (باستخدام Capacitor و Android Studio):
1. قم بتثبيت حزم كاباسيتور:
```bash
npm install @capacitor/core @capacitor/cli @capacitor/android
npx cap init "PhotoVault" "com.photovault.app" --web-dir dist
npm run build
npx cap add android
npx cap copy
npx cap open android
```
2. سيفتح برنامج **Android Studio** تلقائياً.
3. من القائمة العلوية اضغط على: `Build` -> `Build Bundle(s) / APK(s)` -> `Build APK(s)`.
4. مبروك! ستجد ملف الـ `app-debug.apk` جاهزاً للتثبيت في مجلد `android/app/build/outputs/apk/debug/`.

---

## 💻 التشغيل المحلي والتطوير

1. تثبيت الحزم:
```bash
npm install
```

2. تشغيل السيرفر المحلي:
```bash
npm run dev
```

3. بناء النسخة الإنتاجية:
```bash
npm run build
```
