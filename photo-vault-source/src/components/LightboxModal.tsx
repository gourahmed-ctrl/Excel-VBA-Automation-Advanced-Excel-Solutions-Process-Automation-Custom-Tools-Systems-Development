import React, { useEffect, useState } from 'react';
import { PhotoItem } from '../types/index.ts';
import {
  X,
  Download,
  Trash2,
  ChevronRight,
  ChevronLeft,
  Calendar,
  HardDrive,
  Hash,
  ZoomIn,
  ZoomOut,
  RotateCw,
  Share2,
} from 'lucide-react';
import { formatBytes, downloadImage, playHapticSound } from '../lib/imageUtils.ts';

interface LightboxModalProps {
  photo: PhotoItem | null;
  allPhotos: PhotoItem[];
  onClose: () => void;
  onNavigate: (photo: PhotoItem) => void;
  onDelete: (photo: PhotoItem) => void;
  soundEnabled: boolean;
}

export const LightboxModal: React.FC<LightboxModalProps> = ({
  photo,
  allPhotos,
  onClose,
  onNavigate,
  onDelete,
  soundEnabled,
}) => {
  const [zoomLevel, setZoomLevel] = useState<number>(1);
  const [rotation, setRotation] = useState<number>(0);

  useEffect(() => {
    setZoomLevel(1);
    setRotation(0);
  }, [photo?.id]);

  useEffect(() => {
    if (!photo) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
      if (e.key === 'ArrowRight') handlePrev();
      if (e.key === 'ArrowLeft') handleNext();
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [photo, allPhotos]);

  if (!photo) return null;

  const currentIndex = allPhotos.findIndex((p) => p.id === photo.id);
  const hasNext = currentIndex > 0;
  const hasPrev = currentIndex < allPhotos.length - 1;

  const handleNext = () => {
    if (hasNext) {
      if (soundEnabled) playHapticSound('pop');
      onNavigate(allPhotos[currentIndex - 1]);
    }
  };

  const handlePrev = () => {
    if (hasPrev) {
      if (soundEnabled) playHapticSound('pop');
      onNavigate(allPhotos[currentIndex + 1]);
    }
  };

  const handleDownload = () => {
    if (soundEnabled) playHapticSound('success');
    downloadImage(photo.imageUrl, photo.title, photo.seq);
  };

  const handleShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title: photo.title,
          text: `صورة برقم تسلسلي #${photo.seq}`,
          url: window.location.href,
        });
      } catch {
        // user canceled share
      }
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex flex-col bg-black/95 backdrop-blur-md animate-fade-in select-none">
      {/* Top Bar Controls */}
      <div className="h-16 px-4 sm:px-6 bg-slate-950/80 border-b border-slate-800/80 flex items-center justify-between text-slate-200">
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 bg-teal-500/15 border border-teal-500/30 text-teal-300 font-mono font-bold text-sm px-3 py-1 rounded-xl">
            <Hash className="w-4 h-4" />
            <span>{photo.seq}</span>
          </div>
          <div className="hidden sm:block">
            <h3 className="font-bold text-sm text-slate-100 truncate max-w-xs md:max-w-md">
              {photo.title}
            </h3>
            <p className="text-[11px] text-slate-400 font-mono">
              {formatBytes(photo.fileSize)} •{' '}
              {new Date(photo.createdAt).toLocaleString('ar-EG')}
            </p>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2">
          {/* Zoom In */}
          <button
            onClick={() => setZoomLevel((z) => Math.min(z + 0.25, 3))}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
            title="تكبير"
          >
            <ZoomIn className="w-5 h-5" />
          </button>

          {/* Zoom Out */}
          <button
            onClick={() => setZoomLevel((z) => Math.max(z - 0.25, 0.5))}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
            title="تصغير"
          >
            <ZoomOut className="w-5 h-5" />
          </button>

          {/* Rotate */}
          <button
            onClick={() => setRotation((r) => (r + 90) % 360)}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
            title="تدوير"
          >
            <RotateCw className="w-5 h-5" />
          </button>

          {/* Share on Android / Mobile */}
          {typeof navigator !== 'undefined' && 'share' in navigator && (
            <button
              onClick={handleShare}
              className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors"
              title="مشاركة"
            >
              <Share2 className="w-5 h-5" />
            </button>
          )}

          {/* Download */}
          <button
            onClick={handleDownload}
            className="flex items-center gap-1.5 bg-teal-500 hover:bg-teal-400 text-white font-bold text-xs sm:text-sm px-3.5 py-2 rounded-xl shadow-md transition-all active:scale-95"
            title="تنزيل إلى جهازك"
          >
            <Download className="w-4 h-4" />
            <span className="hidden sm:inline">تنزيل</span>
          </button>

          {/* Delete */}
          <button
            onClick={() => {
              if (soundEnabled) playHapticSound('delete');
              onDelete(photo);
            }}
            className="p-2 rounded-xl bg-rose-500/10 text-rose-400 hover:bg-rose-500 hover:text-white border border-rose-500/20 transition-all"
            title="حذف من قاعدة البيانات"
          >
            <Trash2 className="w-4 h-4" />
          </button>

          {/* Close */}
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 transition-colors mr-2"
            title="إغلاق"
          >
            <X className="w-6 h-6" />
          </button>
        </div>
      </div>

      {/* Main Image Stage */}
      <div className="flex-1 relative overflow-hidden flex items-center justify-center p-4">
        {/* Previous Button */}
        {hasPrev && (
          <button
            onClick={handlePrev}
            className="absolute right-4 top-1/2 -translate-y-1/2 z-20 p-3 rounded-full bg-slate-900/80 hover:bg-slate-800 text-slate-200 border border-slate-700/60 shadow-xl transition-all"
            title="الصورة السابقة"
          >
            <ChevronRight className="w-6 h-6" />
          </button>
        )}

        {/* Next Button */}
        {hasNext && (
          <button
            onClick={handleNext}
            className="absolute left-4 top-1/2 -translate-y-1/2 z-20 p-3 rounded-full bg-slate-900/80 hover:bg-slate-800 text-slate-200 border border-slate-700/60 shadow-xl transition-all"
            title="الصورة التالية"
          >
            <ChevronLeft className="w-6 h-6" />
          </button>
        )}

        {/* Display Image */}
        <div
          className="transition-transform duration-200 max-w-full max-h-full flex items-center justify-center"
          style={{
            transform: `scale(${zoomLevel}) rotate(${rotation}deg)`,
          }}
        >
          <img
            src={photo.imageUrl}
            alt={photo.title}
            className="max-h-[80vh] max-w-[90vw] object-contain rounded-lg shadow-2xl"
          />
        </div>
      </div>

      {/* Bottom Metadata Bar */}
      <div className="h-12 px-6 bg-slate-950/80 border-t border-slate-800/80 flex items-center justify-between text-xs text-slate-400">
        <span className="font-mono">
          الصورة {allPhotos.length - currentIndex} من {allPhotos.length}
        </span>
        <span className="sm:hidden font-semibold text-slate-300 truncate max-w-[200px]">
          #{photo.seq} - {photo.title}
        </span>
        <span className="font-mono">{formatBytes(photo.fileSize)}</span>
      </div>
    </div>
  );
};
