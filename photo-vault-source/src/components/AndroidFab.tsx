import React from 'react';
import { Plus, Camera, UploadCloud } from 'lucide-react';
import { playHapticSound } from '../lib/imageUtils.ts';

interface AndroidFabProps {
  onOpenUpload: () => void;
  soundEnabled: boolean;
}

export const AndroidFab: React.FC<AndroidFabProps> = ({
  onOpenUpload,
  soundEnabled,
}) => {
  return (
    <div className="fixed bottom-6 left-6 z-40 sm:hidden">
      <button
        onClick={() => {
          if (soundEnabled) playHapticSound('pop');
          onOpenUpload();
        }}
        className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-teal-500 to-emerald-500 text-white shadow-xl shadow-teal-500/30 flex items-center justify-center transition-transform active:scale-90 border border-teal-300/30"
        title="إضافة ورفع صورة جديدة"
        aria-label="Upload photo"
      >
        <Plus className="w-7 h-7" />
      </button>
    </div>
  );
};
