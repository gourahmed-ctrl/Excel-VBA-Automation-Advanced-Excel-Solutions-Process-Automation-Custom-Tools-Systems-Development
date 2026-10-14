import React from 'react';
import { User } from 'firebase/auth';
import {
  Database,
  LogIn,
  LogOut,
  Sparkles,
  Volume2,
  VolumeX,
  ShieldCheck,
  Smartphone,
  Download,
  HelpCircle,
} from 'lucide-react';
import { playHapticSound } from '../lib/imageUtils.ts';

interface NavbarProps {
  user: User | null;
  loading: boolean;
  onLogin: () => void;
  onLogout: () => void;
  soundEnabled: boolean;
  onToggleSound: () => void;
  onOpenExport: () => void;
  totalPhotos: number;
}

export const Navbar: React.FC<NavbarProps> = ({
  user,
  loading,
  onLogin,
  onLogout,
  soundEnabled,
  onToggleSound,
  onOpenExport,
  totalPhotos,
}) => {
  return (
    <header className="sticky top-0 z-40 bg-slate-900/90 backdrop-blur-md border-b border-slate-800 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* Brand / Logo */}
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-emerald-600 via-teal-500 to-cyan-500 flex items-center justify-center shadow-lg shadow-teal-500/20 text-white font-bold ring-2 ring-white/10">
            <Database className="w-5 h-5 text-white" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="font-extrabold text-base sm:text-lg text-slate-100 tracking-tight leading-none">
                سجل الصور الخاص
              </h1>
              <span className="hidden md:inline-flex items-center gap-1 text-[11px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded-full">
                <ShieldCheck className="w-3 h-3" /> مشفر وخاص
              </span>
            </div>
            <p className="text-xs text-slate-400 mt-0.5 hidden xs:block">
              قاعدة بيانات للرفع والتنزيل والحفظ بالتسلسل
            </p>
          </div>
        </div>

        {/* Right side controls */}
        <div className="flex items-center gap-2 sm:gap-2.5">
          {/* Direct ZIP download button - downloads immediately with no redirects */}
          <a
            href="/photo-vault-source.zip"
            download="photo-vault-source.zip"
            onClick={() => {
              if (soundEnabled) playHapticSound('success');
            }}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-teal-500 hover:bg-teal-400 text-white text-xs font-bold transition-all shadow-md active:scale-95"
            title="تحميل كود المشروع وملفات أندرويد لـ GitHub"
          >
            <Download className="w-3.5 h-3.5" />
            <span className="hidden sm:inline">تحميل كود المشروع (ZIP)</span>
            <span className="sm:hidden">تحميل ZIP</span>
          </a>

          {/* Guide Modal Trigger */}
          <button
            onClick={() => {
              if (soundEnabled) playHapticSound('pop');
              onOpenExport();
            }}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors border border-transparent hover:border-slate-700"
            title="تعليمات الرفع على GitHub والمتجر"
          >
            <HelpCircle className="w-4 h-4" />
          </button>

          {/* Sound Toggle */}
          <button
            onClick={() => {
              if (!soundEnabled) playHapticSound('click');
              onToggleSound();
            }}
            title={soundEnabled ? 'كتم المؤثرات الصوتية' : 'تفعيل المؤثرات الصوتية'}
            className="p-2 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors border border-transparent hover:border-slate-700 text-xs flex items-center gap-1.5"
            aria-label="Sound toggle"
          >
            {soundEnabled ? (
              <Volume2 className="w-4 h-4 text-teal-400" />
            ) : (
              <VolumeX className="w-4 h-4 text-slate-500" />
            )}
          </button>

          {/* User Auth Section */}
          {loading ? (
            <div className="h-9 w-24 bg-slate-800 animate-pulse rounded-lg" />
          ) : user ? (
            <div className="flex items-center gap-2 sm:gap-2.5 bg-slate-800/80 pl-2 pr-3 py-1.5 rounded-xl border border-slate-700/60">
              {user.photoURL ? (
                <img
                  src={user.photoURL}
                  alt={user.displayName || 'المستخدم'}
                  className="w-7 h-7 rounded-full ring-2 ring-emerald-500/30 object-cover"
                  referrerPolicy="no-referrer"
                />
              ) : (
                <div className="w-7 h-7 rounded-full bg-slate-700 flex items-center justify-center text-xs font-bold text-slate-300">
                  {user.displayName ? user.displayName[0] : 'U'}
                </div>
              )}
              <div className="text-right hidden sm:block max-w-[100px] md:max-w-[140px] truncate">
                <p className="text-xs font-semibold text-slate-200 truncate">
                  {user.displayName || 'مستخدم مسجل'}
                </p>
                <p className="text-[10px] text-slate-400 truncate">{user.email}</p>
              </div>
              <button
                onClick={onLogout}
                title="تسجيل الخروج"
                className="p-1.5 rounded-lg text-rose-400 hover:text-rose-300 hover:bg-rose-500/10 transition-colors mr-1"
                aria-label="Logout"
              >
                <LogOut className="w-4 h-4" />
              </button>
            </div>
          ) : (
            <button
              onClick={onLogin}
              className="flex items-center gap-1.5 bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white text-xs sm:text-sm font-bold px-3 py-1.5 sm:px-3.5 sm:py-2 rounded-xl shadow-md shadow-emerald-900/30 transition-all transform active:scale-95"
            >
              <LogIn className="w-4 h-4" />
              <span>دخول Google</span>
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
