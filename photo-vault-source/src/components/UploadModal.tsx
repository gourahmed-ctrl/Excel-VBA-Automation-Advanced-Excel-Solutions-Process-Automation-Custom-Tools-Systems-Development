import React, { useState, useRef, useEffect } from 'react';
import {
  X,
  UploadCloud,
  Camera,
  Image as ImageIcon,
  CheckCircle2,
  AlertCircle,
  Loader2,
  Trash2,
  Sparkles,
  Hash,
  Tag,
} from 'lucide-react';
import { processImageFile, formatBytes, playHapticSound, ProcessedImage } from '../lib/imageUtils.ts';
import { PHOTO_CATEGORIES } from '../types/index.ts';

interface UploadModalProps {
  isOpen: boolean;
  onClose: () => void;
  nextSeqEstimate: number;
  onUpload: (items: { title: string; imageUrl: string; fileSize: number; mimeType: string; width: number; height: number; category: string }[]) => Promise<void>;
  soundEnabled: boolean;
}

interface PendingItem {
  id: string;
  processed: ProcessedImage;
  title: string;
  category: string;
}

export const UploadModal: React.FC<UploadModalProps> = ({
  isOpen,
  onClose,
  nextSeqEstimate,
  onUpload,
  soundEnabled,
}) => {
  const [pendingItems, setPendingItems] = useState<PendingItem[]>([]);
  const [processingFiles, setProcessingFiles] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [selectedDefaultCategory, setSelectedDefaultCategory] = useState<string>('عام');

  const fileInputRef = useRef<HTMLInputElement>(null);
  const cameraInputRef = useRef<HTMLInputElement>(null);

  // Clipboard paste listener
  useEffect(() => {
    if (!isOpen) return;

    const handlePaste = (e: ClipboardEvent) => {
      const items = e.clipboardData?.items;
      if (!items) return;

      const files: File[] = [];
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.startsWith('image/')) {
          const file = items[i].getAsFile();
          if (file) files.push(file);
        }
      }

      if (files.length > 0) {
        handleFilesSelected(files);
      }
    };

    window.addEventListener('paste', handlePaste);
    return () => window.removeEventListener('paste', handlePaste);
  }, [isOpen, selectedDefaultCategory]);

  if (!isOpen) return null;

  const handleFilesSelected = async (fileList: FileList | File[]) => {
    const files = Array.from(fileList);
    if (files.length === 0) return;

    setProcessingFiles(true);
    setErrorMessage(null);

    const newPending: PendingItem[] = [];

    try {
      for (const file of files) {
        if (!file.type.startsWith('image/')) continue;
        const processed = await processImageFile(file);
        newPending.push({
          id: Math.random().toString(36).substring(2, 9),
          processed,
          title: processed.name,
          category: selectedDefaultCategory,
        });
      }

      if (newPending.length > 0) {
        setPendingItems((prev) => [...prev, ...newPending]);
        if (soundEnabled) playHapticSound('pop');
      }
    } catch (err) {
      setErrorMessage(err instanceof Error ? err.message : 'حدث خطأ أثناء معالجة الصور');
    } finally {
      setProcessingFiles(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
      if (cameraInputRef.current) cameraInputRef.current.value = '';
    }
  };

  const handleRemovePending = (id: string) => {
    setPendingItems((prev) => prev.filter((p) => p.id !== id));
    if (soundEnabled) playHapticSound('click');
  };

  const handleTitleChange = (id: string, newTitle: string) => {
    setPendingItems((prev) =>
      prev.map((item) => (item.id === id ? { ...item, title: newTitle } : item))
    );
  };

  const handleCategoryChange = (id: string, newCat: string) => {
    setPendingItems((prev) =>
      prev.map((item) => (item.id === id ? { ...item, category: newCat } : item))
    );
  };

  const handleSubmit = async () => {
    if (pendingItems.length === 0 || uploading) return;

    try {
      setUploading(true);
      setErrorMessage(null);

      const itemsToUpload = pendingItems.map((item) => ({
        title: item.title.trim() || 'صورة خاصة',
        imageUrl: item.processed.dataUrl,
        fileSize: item.processed.sizeBytes,
        mimeType: item.processed.mimeType,
        width: item.processed.width,
        height: item.processed.height,
        category: item.category || 'عام',
      }));

      await onUpload(itemsToUpload);

      if (soundEnabled) playHapticSound('success');
      setPendingItems([]);
      onClose();
    } catch (err) {
      setErrorMessage(err instanceof Error ? err.message : 'فشل الرفع لقاعدة البيانات');
    } finally {
      setUploading(false);
    }
  };

  const availableCategories = PHOTO_CATEGORIES.filter((c) => c !== 'الكل');

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-black/80 backdrop-blur-sm animate-fade-in">
      <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-2xl max-h-[90vh] flex flex-col shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="px-6 py-4 border-b border-slate-800 flex items-center justify-between bg-slate-900/90">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-teal-500/10 border border-teal-500/20 text-teal-400 flex items-center justify-center">
              <UploadCloud className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base sm:text-lg font-bold text-slate-100">
                رفع صور جديدة لقاعدة البيانات
              </h2>
              <div className="flex items-center gap-2 mt-0.5">
                <span className="text-xs text-slate-400">
                  التسلسل التلقائي:
                </span>
                <span className="text-xs font-mono font-bold text-teal-400 bg-teal-500/10 px-2 py-0.5 rounded border border-teal-500/20">
                  يبدأ من #{nextSeqEstimate}
                </span>
              </div>
            </div>
          </div>
          <button
            onClick={onClose}
            disabled={uploading}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 overflow-y-auto space-y-5 flex-1">
          {/* Error Message */}
          {errorMessage && (
            <div className="p-3.5 rounded-xl bg-rose-500/10 border border-rose-500/20 text-rose-300 text-xs flex items-center gap-2.5">
              <AlertCircle className="w-4 h-4 shrink-0 text-rose-400" />
              <span>{errorMessage}</span>
            </div>
          )}

          {/* Default Category selector */}
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-300 flex items-center gap-1.5">
              <Tag className="w-3.5 h-3.5 text-teal-400" />
              <span>التصنيف الافتراضي للصور:</span>
            </label>
            <div className="flex flex-wrap gap-2">
              {availableCategories.map((cat) => (
                <button
                  key={cat}
                  type="button"
                  onClick={() => setSelectedDefaultCategory(cat)}
                  className={`text-xs px-3 py-1.5 rounded-xl font-bold transition-all ${
                    selectedDefaultCategory === cat
                      ? 'bg-teal-500 text-white shadow-md'
                      : 'bg-slate-800 text-slate-400 hover:text-slate-200'
                  }`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>

          {/* Action Pickers (Gallery & Android Camera) */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {/* Pick from device gallery / computer */}
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading || processingFiles}
              className="p-4 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border-2 border-dashed border-teal-500/30 hover:border-teal-500/60 flex flex-col items-center justify-center gap-2 text-center transition-all group cursor-pointer"
            >
              <div className="w-10 h-10 rounded-full bg-teal-500/10 group-hover:bg-teal-500/20 text-teal-400 flex items-center justify-center transition-colors">
                <ImageIcon className="w-5 h-5" />
              </div>
              <span className="text-sm font-bold text-slate-200">
                اختيار من المعرض / الملفات
              </span>
              <span className="text-[11px] text-slate-400">
                أو اسحب وأفلت الصور هنا أو الصق (Ctrl+V)
              </span>
            </button>

            {/* Android Camera Capture Button */}
            <button
              onClick={() => cameraInputRef.current?.click()}
              disabled={uploading || processingFiles}
              className="p-4 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border-2 border-dashed border-emerald-500/30 hover:border-emerald-500/60 flex flex-col items-center justify-center gap-2 text-center transition-all group cursor-pointer"
            >
              <div className="w-10 h-10 rounded-full bg-emerald-500/10 group-hover:bg-emerald-500/20 text-emerald-400 flex items-center justify-center transition-colors">
                <Camera className="w-5 h-5" />
              </div>
              <span className="text-sm font-bold text-slate-200">
                التقاط صورة بكاميرا الهاتف
              </span>
              <span className="text-[11px] text-slate-400">
                فتح الكاميرا والرفع المباشر
              </span>
            </button>
          </div>

          {/* Hidden File Inputs */}
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            multiple
            className="hidden"
            onChange={(e) => e.target.files && handleFilesSelected(e.target.files)}
          />
          <input
            ref={cameraInputRef}
            type="file"
            accept="image/*"
            capture="environment"
            className="hidden"
            onChange={(e) => e.target.files && handleFilesSelected(e.target.files)}
          />

          {/* Processing Indicator */}
          {processingFiles && (
            <div className="flex items-center justify-center gap-2 py-4 text-teal-400 text-sm font-semibold">
              <Loader2 className="w-5 h-5 animate-spin" />
              <span>جاري تحسين ومعالجة الصور للرفع الفوري...</span>
            </div>
          )}

          {/* Pending items list */}
          {pendingItems.length > 0 && (
            <div className="space-y-3">
              <div className="flex items-center justify-between text-xs text-slate-400">
                <span className="font-semibold text-slate-200">
                  الصور الجاهزة للرفع ({pendingItems.length}):
                </span>
                <span>تعديل الاسم والتصنيف قبل الحفظ</span>
              </div>

              <div className="space-y-2.5 max-h-64 overflow-y-auto pr-1">
                {pendingItems.map((item, idx) => (
                  <div
                    key={item.id}
                    className="flex items-center gap-3 p-3 bg-slate-850 rounded-xl border border-slate-700/60"
                  >
                    <div className="w-8 text-center font-mono font-bold text-teal-400 text-xs bg-teal-500/10 py-1 rounded">
                      #{nextSeqEstimate + idx}
                    </div>
                    <img
                      src={item.processed.dataUrl}
                      alt="معاينة"
                      className="w-12 h-12 rounded-lg object-cover bg-black"
                    />
                    <div className="flex-1 min-w-0 space-y-1.5">
                      <input
                        type="text"
                        value={item.title}
                        onChange={(e) => handleTitleChange(item.id, e.target.value)}
                        placeholder="عنوان الصورة"
                        className="w-full text-xs bg-slate-900 border border-slate-700 rounded-lg px-2.5 py-1 text-slate-100 focus:outline-none focus:border-teal-400"
                      />
                      <div className="flex items-center justify-between text-[10px] text-slate-400 font-mono">
                        <span>{formatBytes(item.processed.sizeBytes)}</span>
                        <select
                          value={item.category}
                          onChange={(e) => handleCategoryChange(item.id, e.target.value)}
                          className="bg-slate-900 text-teal-300 border border-slate-700 rounded px-1.5 py-0.5 text-[10px] focus:outline-none"
                        >
                          {availableCategories.map((c) => (
                            <option key={c} value={c}>
                              {c}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                    <button
                      onClick={() => handleRemovePending(item.id)}
                      disabled={uploading}
                      className="p-1.5 rounded-lg text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 transition-colors"
                      title="إزالة"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-slate-800 bg-slate-900/90 flex items-center justify-between">
          <button
            onClick={onClose}
            disabled={uploading}
            className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition-colors"
          >
            إلغاء
          </button>

          <button
            onClick={handleSubmit}
            disabled={pendingItems.length === 0 || uploading}
            className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs sm:text-sm font-bold shadow-lg transition-all ${
              pendingItems.length === 0 || uploading
                ? 'bg-slate-800 text-slate-500 cursor-not-allowed'
                : 'bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white shadow-teal-500/20 active:scale-95'
            }`}
          >
            {uploading ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>جاري الحفظ في قاعدة البيانات...</span>
              </>
            ) : (
              <>
                <CheckCircle2 className="w-4 h-4" />
                <span>
                  حفظ ورفع {pendingItems.length > 0 ? `(${pendingItems.length}) صور` : ''}
                </span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
