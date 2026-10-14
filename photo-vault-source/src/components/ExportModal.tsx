import React, { useState } from 'react';
import {
  X,
  Download,
  Github,
  Smartphone,
  Copy,
  Check,
  FileArchive,
  ExternalLink,
  Terminal,
  Layers,
  Sparkles,
} from 'lucide-react';
import { playHapticSound } from '../lib/imageUtils.ts';

interface ExportModalProps {
  isOpen: boolean;
  onClose: () => void;
  soundEnabled: boolean;
}

export const ExportModal: React.FC<ExportModalProps> = ({
  isOpen,
  onClose,
  soundEnabled,
}) => {
  const [copiedSection, setCopiedSection] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<'archive' | 'apk' | 'github'>('archive');

  if (!isOpen) return null;

  const handleCopy = (text: string, sectionId: string) => {
    navigator.clipboard.writeText(text);
    setCopiedSection(sectionId);
    if (soundEnabled) playHapticSound('pop');
    setTimeout(() => setCopiedSection(null), 2000);
  };

  const gitCommands = `# 1. فتح مجلد المشروع بعد فك الضغط عنه
git init
git add .
git commit -m "Initial commit: سجل الصور الخاص"
git branch -M main
git remote add origin https://github.com/USERNAME/REPO_NAME.git
git push -u origin main`;

  const capacitorCommands = `# خطوات إنشاء ملف APK رسمي عبر Capacitor و Android Studio:
npm install @capacitor/core @capacitor/cli @capacitor/android
npx cap init "PhotoVault" "com.photovault.app" --web-dir dist
npm run build
npx cap add android
npx cap copy
npx cap open android
# سيفتح Android Studio: اضغط Build -> Build APK(s)`;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-black/80 backdrop-blur-md animate-fade-in">
      <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-2xl max-h-[92vh] flex flex-col shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="px-6 py-4 border-b border-slate-800 flex items-center justify-between bg-slate-900/90">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-teal-500/10 border border-teal-500/20 text-teal-400 flex items-center justify-center">
              <FileArchive className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base sm:text-lg font-bold text-slate-100">
                تنزيل ملفات الإنشاء وتصدير APK
              </h2>
              <p className="text-xs text-slate-400 mt-0.5">
                جاهزة للرفع على GitHub وتثبيتها كبرنامج على هاتف أندرويد
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-slate-800 bg-slate-950/40 px-6">
          <button
            onClick={() => setActiveTab('archive')}
            className={`py-3 px-4 text-xs sm:text-sm font-bold border-b-2 transition-all flex items-center gap-2 ${
              activeTab === 'archive'
                ? 'border-teal-400 text-teal-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <FileArchive className="w-4 h-4" />
            <span>الملف المضغوط</span>
          </button>

          <button
            onClick={() => setActiveTab('github')}
            className={`py-3 px-4 text-xs sm:text-sm font-bold border-b-2 transition-all flex items-center gap-2 ${
              activeTab === 'github'
                ? 'border-teal-400 text-teal-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Github className="w-4 h-4" />
            <span>الرفع على GitHub</span>
          </button>

          <button
            onClick={() => setActiveTab('apk')}
            className={`py-3 px-4 text-xs sm:text-sm font-bold border-b-2 transition-all flex items-center gap-2 ${
              activeTab === 'apk'
                ? 'border-teal-400 text-teal-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Smartphone className="w-4 h-4" />
            <span>تثبيت APK لأندرويد</span>
          </button>
        </div>

        {/* Body Content */}
        <div className="p-6 overflow-y-auto space-y-5 flex-1 text-right">
          {/* TAB 1: Archive Download */}
          {activeTab === 'archive' && (
            <div className="space-y-4">
              <div className="p-5 rounded-2xl bg-gradient-to-r from-teal-950/40 via-slate-850 to-emerald-950/30 border border-teal-500/30 flex flex-col sm:flex-row items-center justify-between gap-4">
                <div className="space-y-1 text-center sm:text-right">
                  <span className="text-[11px] font-bold text-teal-400 bg-teal-500/10 px-2.5 py-0.5 rounded-full border border-teal-500/20">
                    ملف مضغوط جاهز للتحميل
                  </span>
                  <h3 className="text-base font-extrabold text-slate-100">
                    photo-vault-source.zip
                  </h3>
                  <p className="text-xs text-slate-400 max-w-sm">
                    يحتوي على جميع ملفات الكود المصدري وقاعدة البيانات وFirebase وتكوينات أندرويد لفتحه بواسطة WinRAR أو 7-Zip ورفعه على GitHub.
                  </p>
                </div>

                <a
                  href="/photo-vault-source.zip"
                  download="photo-vault-source.zip"
                  onClick={() => {
                    if (soundEnabled) playHapticSound('success');
                  }}
                  className="inline-flex items-center gap-2 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white font-bold text-sm px-6 py-3 rounded-xl shadow-lg shadow-teal-500/25 transition-all transform active:scale-95 shrink-0"
                >
                  <Download className="w-5 h-5" />
                  <span>تنزيل الملف المضغوط الآن</span>
                </a>
              </div>

              <div className="space-y-2 text-xs text-slate-300 bg-slate-950/50 p-4 rounded-xl border border-slate-800">
                <h4 className="font-bold text-teal-400 mb-2">
                  ماذا يحتوي الملف المضغوط؟
                </h4>
                <ul className="list-disc list-inside space-y-1.5 text-slate-400">
                  <li>كافة ملفات واجهة المستخدم والمكونات والتسلسل (`src/*`).</li>
                  <li>ملف إعدادات Firebase وتوصيف قواعد البيانات (`firebase-applet-config.json`).</li>
                  <li>قواعد الأمان الخاصة بالحسابات والتسلسل (`firestore.rules`).</li>
                  <li>ملف الـ Web App Manifest لأجهزة أندرويد (`public/manifest.json`).</li>
                  <li>ملف التعليمات الكامل مع أوامر Git وAPK (`README.md`).</li>
                </ul>
              </div>
            </div>
          )}

          {/* TAB 2: GitHub Guide */}
          {activeTab === 'github' && (
            <div className="space-y-4">
              <div className="text-xs text-slate-400 leading-relaxed">
                بعد تنزيل الملف المضغوط وفك الضغط عنه، يمكنك رفعه على GitHub مباشرة باتباع هذه الأوامر البسيطة:
              </div>

              <div className="relative bg-slate-950 rounded-2xl border border-slate-800 p-4 font-mono text-xs text-emerald-400 overflow-x-auto text-left dir-ltr">
                <button
                  onClick={() => handleCopy(gitCommands, 'git')}
                  className="absolute top-3 right-3 p-2 rounded-lg bg-slate-800 text-slate-300 hover:text-white transition-colors flex items-center gap-1.5"
                  title="نسخ الأوامر"
                >
                  {copiedSection === 'git' ? (
                    <>
                      <Check className="w-3.5 h-3.5 text-teal-400" />
                      <span className="text-[10px] text-teal-400 font-sans">تم النسخ!</span>
                    </>
                  ) : (
                    <>
                      <Copy className="w-3.5 h-3.5" />
                      <span className="text-[10px] font-sans">نسخ</span>
                    </>
                  )}
                </button>
                <pre>{gitCommands}</pre>
              </div>

              <div className="p-3.5 rounded-xl bg-slate-850 border border-slate-800 text-xs text-slate-400">
                💡 <span className="text-slate-200 font-bold">نصيحة:</span> استبدل <code className="text-teal-400 font-mono">USERNAME</code> و <code className="text-teal-400 font-mono">REPO_NAME</code> برابط مستودعك المنشأ حديثاً على GitHub.
              </div>
            </div>
          )}

          {/* TAB 3: Android APK & Google Play Store Guide */}
          {activeTab === 'apk' && (
            <div className="space-y-4">
              {/* Method 0: Instant Install on any phone right now */}
              <div className="p-4 rounded-2xl bg-gradient-to-r from-emerald-950/40 to-teal-950/30 border border-emerald-500/30 space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-emerald-400 bg-emerald-500/10 px-2.5 py-0.5 rounded-full border border-emerald-500/20">
                    أسرع طريقة: تثبيت فوري على أي هاتف في 5 ثوانٍ
                  </span>
                  <span className="text-[11px] text-teal-300 font-bold">بدون كمبيوتر</span>
                </div>
                <p className="text-xs text-slate-200 font-semibold leading-relaxed">
                  يمكنك تثبيت البرنامج على هاتفك (أو هاتف أي شخص) كتطبيق أندرويد حقيقي بأيقونة مستقلة فوراً:
                </p>
                <ol className="text-xs text-slate-300 list-decimal list-inside space-y-1.5 leading-relaxed">
                  <li>افتح هذا الرابط على متصفح <strong>Google Chrome</strong> في هاتفك.</li>
                  <li>اضغط على قائمة الثلاث نقاط في أعلى اليسار <span className="font-mono text-teal-300 bg-slate-900 px-1 py-0.5 rounded">⋮</span>.</li>
                  <li>اضغط على <strong>«تثبيت التطبيق» (Install App)</strong> أو «إضافة إلى الشاشة الرئيسية».</li>
                  <li>سيظهر التطبيق فوراً على شاشة هاتفك مثل أي تطبيق APK تم تنزيله من المتجر!</li>
                </ol>
              </div>

              {/* Method 1: PWABuilder (Generates signed APK and AAB for Google Play Store) */}
              <div className="p-4 rounded-2xl bg-slate-850 border border-slate-800 space-y-2.5">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-teal-400 bg-teal-500/10 px-2 py-0.5 rounded border border-teal-500/20">
                    لتوليد ملف APK وملف متجر جوجل بلاي (Google Play) أونلاين
                  </span>
                  <a
                    href="https://www.pwabuilder.com/"
                    target="_blank"
                    rel="noreferrer"
                    className="text-xs text-teal-400 hover:underline flex items-center gap-1 font-bold"
                  >
                    <span>فتح موقع PWABuilder</span>
                    <ExternalLink className="w-3.5 h-3.5" />
                  </a>
                </div>
                <p className="text-xs text-slate-300">
                  موقع رسمي معتمد من مايكروسوفت وجوجل لتحويل الموقع لملف APK و AAB للمتجر:
                </p>
                <ol className="text-xs text-slate-400 list-decimal list-inside space-y-1.5">
                  <li>انسخ رابط التطبيق: <span className="font-mono text-teal-300 bg-slate-900 px-1.5 py-0.5 rounded select-all">{window.location.origin}</span></li>
                  <li>الصق الرابط في موقع <strong>PWABuilder.com</strong> واضغط <strong>Start</strong>.</li>
                  <li>اضغط على زر <strong>Android Package</strong> ثم <strong>Download Package</strong>.</li>
                  <li>ستحصل على ملفين:
                    <ul className="list-disc list-inside mr-4 mt-1 space-y-1 text-slate-300">
                      <li>ملف <strong className="text-emerald-400">.apk</strong>: لتثبيته وإرساله لأي هاتف لتجربته.</li>
                      <li>ملف <strong className="text-teal-400">.aab</strong>: هو الملف الرسمي المطلوب لرفعه على <strong>Google Play Console</strong> لعرضه في متجر جوجل بلاي!</li>
                    </ul>
                  </li>
                </ol>
              </div>

              {/* Method 2: Ready-made Android Studio project inside the zip */}
              <div className="p-4 rounded-2xl bg-slate-850 border border-slate-800 space-y-2">
                <span className="text-xs font-bold text-cyan-400 bg-cyan-500/10 px-2 py-0.5 rounded border border-cyan-500/20">
                  مشروع أندرويد ستوديو المرفق مسبقاً في الملف المضغوط
                </span>
                <p className="text-xs text-slate-300 leading-relaxed">
                  لقد أنشأنا لك بالفعل مجلد <code className="text-teal-400 font-mono">android</code> كامل ومضبوط داخل ملف <code className="text-teal-400 font-mono">photo-vault-source.zip</code>! إذا فتحته في <strong>Android Studio</strong>، يمكنك الضغط مباشرة على:
                  <br />
                  <span className="font-mono text-teal-300 bg-slate-900 px-1.5 py-0.5 rounded text-[11px] mt-1 inline-block">Build &gt; Build Bundle(s) / APK(s) &gt; Build APK(s)</span>
                </p>
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-slate-800 bg-slate-900/90 flex items-center justify-between">
          <a
            href="/photo-vault-source.zip"
            download="photo-vault-source.zip"
            onClick={() => {
              if (soundEnabled) playHapticSound('success');
            }}
            className="text-xs font-bold text-teal-400 hover:text-teal-300 flex items-center gap-1.5"
          >
            <Download className="w-4 h-4" />
            <span>تحميل photo-vault-source.zip مباشرة</span>
          </a>

          <button
            onClick={onClose}
            className="px-5 py-2 rounded-xl text-xs font-bold bg-slate-800 text-slate-300 hover:bg-slate-700 hover:text-white transition-colors"
          >
            إغلاق
          </button>
        </div>
      </div>
    </div>
  );
};
