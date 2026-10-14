import React from 'react';
import { Trash2, AlertTriangle, X, Loader2 } from 'lucide-react';
import { PhotoItem } from '../types/index.ts';

interface DeleteConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => Promise<void>;
  isDeleting: boolean;
  targetPhoto: PhotoItem | null;
  count: number;
}

export const DeleteConfirmModal: React.FC<DeleteConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  isDeleting,
  targetPhoto,
  count,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm animate-fade-in">
      <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-md p-6 shadow-2xl space-y-5">
        <div className="flex items-center justify-between">
          <div className="w-12 h-12 rounded-2xl bg-rose-500/15 border border-rose-500/30 text-rose-400 flex items-center justify-center">
            <Trash2 className="w-6 h-6" />
          </div>
          <button
            onClick={onClose}
            disabled={isDeleting}
            className="p-1.5 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <div>
          <h3 className="text-lg font-bold text-slate-100">
            تأكيد الحذف من قاعدة البيانات
          </h3>
          <p className="text-xs text-slate-400 mt-1 leading-relaxed">
            {targetPhoto ? (
              <>
                هل أنت متأكد من رغبتك في حذف الصورة{' '}
                <span className="text-teal-400 font-mono font-bold">
                  (تسلسل #{targetPhoto.seq})
                </span>{' '}
                «{targetPhoto.title}»؟ لن يمكنك التراجع عن هذه الخطوة.
              </>
            ) : (
              <>
                هل أنت متأكد من حذف{' '}
                <span className="text-rose-400 font-bold">{count} صور محددة</span>{' '}
                من قاعدة البيانات الخاصة بك؟
              </>
            )}
          </p>
        </div>

        {targetPhoto && (
          <div className="flex items-center gap-3 p-3 bg-slate-950 rounded-2xl border border-slate-800">
            <img
              src={targetPhoto.imageUrl}
              alt={targetPhoto.title}
              className="w-14 h-14 rounded-xl object-cover bg-black"
            />
            <div className="overflow-hidden">
              <span className="text-xs font-mono font-bold text-teal-400 bg-teal-500/10 px-2 py-0.5 rounded">
                تسلسل #{targetPhoto.seq}
              </span>
              <p className="text-xs text-slate-200 font-semibold truncate mt-1">
                {targetPhoto.title}
              </p>
            </div>
          </div>
        )}

        <div className="flex items-center justify-end gap-3 pt-2">
          <button
            onClick={onClose}
            disabled={isDeleting}
            className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors"
          >
            إلغاء
          </button>
          <button
            onClick={onConfirm}
            disabled={isDeleting}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-rose-600 hover:bg-rose-500 text-white text-xs sm:text-sm font-bold shadow-lg shadow-rose-900/30 transition-all active:scale-95"
          >
            {isDeleting ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>جاري الحذف...</span>
              </>
            ) : (
              <>
                <Trash2 className="w-4 h-4" />
                <span>تأكيد الحذف نهائياً</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
