import React from 'react';
import {
  Database,
  UploadCloud,
  LogIn,
  ShieldCheck,
  CheckCircle,
  Hash,
  Sparkles,
} from 'lucide-react';

interface EmptyStateProps {
  isSignedIn: boolean;
  onLogin: () => void;
  onUpload: () => void;
}

export const EmptyState: React.FC<EmptyStateProps> = ({
  isSignedIn,
  onLogin,
  onUpload,
}) => {
  return (
    <div className="bg-slate-900/60 border border-slate-800/80 rounded-3xl p-8 sm:p-12 text-center max-w-2xl mx-auto shadow-xl">
      <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-3xl bg-gradient-to-tr from-teal-500/20 via-emerald-500/20 to-cyan-500/10 border border-teal-500/30 text-teal-400 mx-auto flex items-center justify-center mb-6 shadow-inner">
        <Database className="w-8 h-8 sm:w-10 sm:h-10" />
      </div>

      <h2 className="text-xl sm:text-2xl font-extrabold text-slate-100">
        {!isSignedIn
          ? 'مرحباً بك في سجل الصور وقاعدة البيانات الخاصة'
          : 'قاعدة بيانات الصور فارغة حالياً'}
      </h2>

      <p className="text-sm text-slate-400 mt-2.5 max-w-md mx-auto leading-relaxed">
        {!isSignedIn
          ? 'سجل دخولك بحساب Google للوصول إلى قاعدة بياناتك السحابية الخاصة. يتم حفظ صورك برقم تسلسلي منظم مع إمكانية التنزيل والرفع والحذف في أي وقت.'
          : 'ابدأ الآن برفع صورك الخاصة. سيتم ترتيبها وتخصيص عامود تسلسل تلقائي (#1، #2، ...) وتخزينها بأمان في حسابك.'}
      </p>

      {/* Feature Pills */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 my-8 text-right">
        <div className="p-3.5 rounded-2xl bg-slate-850/80 border border-slate-800 flex items-start gap-3">
          <div className="p-1.5 rounded-lg bg-teal-500/10 text-teal-400 shrink-0 mt-0.5">
            <Hash className="w-4 h-4" />
          </div>
          <div>
            <h4 className="text-xs font-bold text-slate-200">عامود التسلسل</h4>
            <p className="text-[11px] text-slate-400 mt-0.5">ترقيم تلقائي يبدأ من #1</p>
          </div>
        </div>

        <div className="p-3.5 rounded-2xl bg-slate-850/80 border border-slate-800 flex items-start gap-3">
          <div className="p-1.5 rounded-lg bg-emerald-500/10 text-emerald-400 shrink-0 mt-0.5">
            <UploadCloud className="w-4 h-4" />
          </div>
          <div>
            <h4 className="text-xs font-bold text-slate-200">رفع وتنزيل فوري</h4>
            <p className="text-[11px] text-slate-400 mt-0.5">تحميل وحفظ وقت ما تحب</p>
          </div>
        </div>

        <div className="p-3.5 rounded-2xl bg-slate-850/80 border border-slate-800 flex items-start gap-3">
          <div className="p-1.5 rounded-lg bg-cyan-500/10 text-cyan-400 shrink-0 mt-0.5">
            <ShieldCheck className="w-4 h-4" />
          </div>
          <div>
            <h4 className="text-xs font-bold text-slate-200">خاصة ومشفرة</h4>
            <p className="text-[11px] text-slate-400 mt-0.5">لا يراها إلا أنت بحسابك</p>
          </div>
        </div>
      </div>

      {/* Action Button */}
      {!isSignedIn ? (
        <button
          onClick={onLogin}
          className="inline-flex items-center gap-2.5 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white font-bold text-sm px-7 py-3.5 rounded-2xl shadow-xl shadow-teal-500/20 transition-all transform active:scale-95"
        >
          <LogIn className="w-5 h-5" />
          <span>تسجيل الدخول بحساب Google للبدء</span>
        </button>
      ) : (
        <button
          onClick={onUpload}
          className="inline-flex items-center gap-2.5 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white font-bold text-sm px-7 py-3.5 rounded-2xl shadow-xl shadow-teal-500/20 transition-all transform active:scale-95"
        >
          <UploadCloud className="w-5 h-5" />
          <span>رفع أول صورة في قاعدة البيانات</span>
        </button>
      )}
    </div>
  );
};
