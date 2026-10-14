import React, { useState } from 'react';
import { Smartphone, Download, X, HelpCircle, CheckCircle2, ArrowUpRight } from 'lucide-react';
import { playHapticSound } from '../lib/imageUtils.ts';

interface InstallBannerProps {
  hasPrompt: boolean;
  onInstallPrompt: () => void;
  onDismiss: () => void;
  soundEnabled: boolean;
}

export const InstallBanner: React.FC<InstallBannerProps> = ({
  hasPrompt,
  onInstallPrompt,
  onDismiss,
  soundEnabled,
}) => {
  const [showManualTip, setShowManualTip] = useState(false);

  const handleClickInstall = () => {
    if (soundEnabled) playHapticSound('success');
    if (hasPrompt) {
      onInstallPrompt();
    } else {
      setShowManualTip(true);
    }
  };

  return (
    <div className="bg-gradient-to-r from-teal-950 via-slate-900 to-emerald-950 border border-teal-500/40 rounded-2xl p-4 shadow-xl space-y-3 animate-fade-in">
      <div className="flex flex-col sm:flex-row items-center justify-between gap-3">
        <div className="flex items-center gap-3 text-right w-full sm:w-auto">
          <div className="w-10 h-10 rounded-xl bg-teal-500/20 border border-teal-500/40 text-teal-300 flex items-center justify-center shrink-0 shadow-inner">
            <Smartphone className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h4 className="text-xs sm:text-sm font-extrabold text-slate-100">
                تثبيت البرنامج على الموبايل كأيقونة مستقلة
              </h4>
              <span className="text-[10px] font-bold bg-emerald-500/20 text-emerald-300 px-2 py-0.5 rounded-full border border-emerald-500/30">
                أندرويد
              </span>
            </div>
            <p className="text-[11px] text-slate-400 mt-0.5">
              تشغيل سريع ومباشر على الشاشة بدون فتح المتصفح كل مرة
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
          {/* Direct Install Button */}
          <button
            onClick={handleClickInstall}
            className="flex-1 sm:flex-none flex items-center justify-center gap-2 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white font-bold text-xs sm:text-sm px-4 py-2 rounded-xl shadow-lg shadow-teal-500/25 transition-all transform active:scale-95"
          >
            <Smartphone className="w-4 h-4" />
            <span>تثبيت البرنامج على الهاتف</span>
          </button>

          {/* Direct Download ZIP Button */}
          <a
            href="/photo-vault-source.zip"
            download="photo-vault-source.zip"
            onClick={() => {
              if (soundEnabled) playHapticSound('success');
            }}
            className="flex items-center gap-1.5 bg-slate-850 hover:bg-slate-800 text-teal-300 border border-teal-500/30 font-bold text-xs px-3 py-2 rounded-xl transition-all"
            title="تحميل كود المشروع المضغوط لـ GitHub مباشرة"
          >
            <Download className="w-4 h-4" />
            <span className="hidden md:inline">تحميل كود المشروع (ZIP)</span>
          </a>

          <button
            onClick={onDismiss}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors"
            title="إخفاء"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Manual Tip if browser doesn't support auto-prompt */}
      {showManualTip && (
        <div className="p-3 bg-slate-950/90 rounded-xl border border-teal-500/30 text-xs text-slate-200 flex items-start gap-2.5 animate-fade-in">
          <ArrowUpRight className="w-4 h-4 text-teal-400 shrink-0 mt-0.5" />
          <div>
            <p className="font-bold text-teal-300">
              طريقة التثبيت المباشرة من متصفحك:
            </p>
            <p className="text-[11px] text-slate-400 mt-0.5">
              اضغط على قائمة الثلاث نقاط <strong className="text-white bg-slate-800 px-1.5 py-0.5 rounded font-mono">⋮</strong> في أعلى زاوية المتصفح في هاتفك، ثم اختر <strong className="text-teal-300">«تثبيت التطبيق» (Install app)</strong> أو «إضافة إلى الشاشة الرئيسية».
            </p>
          </div>
        </div>
      )}
    </div>
  );
};
