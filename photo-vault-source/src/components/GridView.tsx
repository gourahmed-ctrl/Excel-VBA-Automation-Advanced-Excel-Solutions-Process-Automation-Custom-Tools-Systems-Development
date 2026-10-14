import React from 'react';
import { PhotoItem } from '../types/index.ts';
import {
  Download,
  Trash2,
  Maximize2,
  CheckCircle2,
  Circle,
  Hash,
} from 'lucide-react';
import { formatBytes, downloadImage, playHapticSound } from '../lib/imageUtils.ts';

interface GridViewProps {
  photos: PhotoItem[];
  selectedIds: string[];
  onToggleSelect: (id: string) => void;
  onViewPhoto: (photo: PhotoItem) => void;
  onDeletePhoto: (photo: PhotoItem) => void;
  soundEnabled: boolean;
}

export const GridView: React.FC<GridViewProps> = ({
  photos,
  selectedIds,
  onToggleSelect,
  onViewPhoto,
  onDeletePhoto,
  soundEnabled,
}) => {
  const handleDownload = (photo: PhotoItem, e: React.MouseEvent) => {
    e.stopPropagation();
    if (soundEnabled) playHapticSound('success');
    downloadImage(photo.imageUrl, photo.title, photo.seq);
  };

  return (
    <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 sm:gap-4">
      {photos.map((photo) => {
        const isSelected = selectedIds.includes(photo.id);

        return (
          <div
            key={photo.id}
            onClick={() => onToggleSelect(photo.id)}
            className={`group relative rounded-2xl overflow-hidden bg-slate-900 border transition-all duration-200 cursor-pointer shadow-md flex flex-col ${
              isSelected
                ? 'border-teal-400 ring-2 ring-teal-400/40 shadow-teal-500/10'
                : 'border-slate-800 hover:border-slate-700 hover:shadow-xl'
            }`}
          >
            {/* Image Preview Container */}
            <div className="relative aspect-square w-full bg-slate-950 overflow-hidden">
              <img
                src={photo.imageUrl}
                alt={photo.title}
                className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                loading="lazy"
              />

              {/* Gradient Overlay for Top Badges */}
              <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-transparent to-black/60 opacity-60 group-hover:opacity-80 transition-opacity pointer-events-none" />

              {/* Sequence Badge (عامود التسلسل) */}
              <div className="absolute top-2.5 right-2.5 z-10 flex items-center gap-1 bg-slate-900/90 backdrop-blur-md text-teal-400 border border-teal-500/40 font-mono font-extrabold text-xs px-2.5 py-1 rounded-lg shadow-md">
                <Hash className="w-3.5 h-3.5" />
                <span>{photo.seq}</span>
              </div>

              {/* Selection Checkbox (Top Left) */}
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  if (soundEnabled) playHapticSound('click');
                  onToggleSelect(photo.id);
                }}
                className="absolute top-2.5 left-2.5 z-10 p-1 rounded-full bg-slate-900/80 backdrop-blur-sm text-slate-300 hover:text-white transition-colors"
                title="تحديد الصورة"
              >
                {isSelected ? (
                  <CheckCircle2 className="w-5 h-5 text-teal-400 fill-teal-400/20" />
                ) : (
                  <Circle className="w-5 h-5 text-slate-400/80 group-hover:text-slate-200" />
                )}
              </button>

              {/* Quick Hover Action Bar */}
              <div className="absolute bottom-2 inset-x-2 z-10 flex items-center justify-between opacity-0 group-hover:opacity-100 transition-opacity">
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    if (soundEnabled) playHapticSound('pop');
                    onViewPhoto(photo);
                  }}
                  className="p-2 rounded-xl bg-slate-900/90 backdrop-blur-md text-slate-200 hover:text-white hover:bg-slate-850 shadow-md transition-all"
                  title="تكبير ومعاينة"
                >
                  <Maximize2 className="w-4 h-4" />
                </button>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={(e) => handleDownload(photo, e)}
                    className="p-2 rounded-xl bg-teal-500/90 backdrop-blur-md text-white hover:bg-teal-400 shadow-md transition-all"
                    title="تنزيل الصورة"
                  >
                    <Download className="w-4 h-4" />
                  </button>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      if (soundEnabled) playHapticSound('delete');
                      onDeletePhoto(photo);
                    }}
                    className="p-2 rounded-xl bg-rose-500/90 backdrop-blur-md text-white hover:bg-rose-400 shadow-md transition-all"
                    title="حذف الصورة"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>

            {/* Bottom Card Info */}
            <div className="p-3 bg-slate-900 flex-1 flex flex-col justify-between border-t border-slate-800/80">
              <h4 className="text-xs font-bold text-slate-200 truncate" title={photo.title}>
                {photo.title}
              </h4>
              <div className="flex items-center justify-between mt-1 text-[11px] text-slate-400 font-mono">
                <span>{formatBytes(photo.fileSize)}</span>
                <span>
                  {new Date(photo.createdAt).toLocaleDateString('ar-EG', {
                    month: 'numeric',
                    day: 'numeric',
                  })}
                </span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
