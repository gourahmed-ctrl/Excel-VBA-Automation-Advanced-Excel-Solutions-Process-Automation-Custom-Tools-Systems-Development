import React, { useState } from 'react';
import { PhotoItem } from '../types/index.ts';
import {
  Download,
  Trash2,
  Maximize2,
  Hash,
  Image as ImageIcon,
  HardDrive,
  Calendar,
  CheckSquare,
  Square,
  Edit2,
  Check,
  X,
  Star,
  Tag,
} from 'lucide-react';
import { formatBytes, downloadImage, playHapticSound } from '../lib/imageUtils.ts';

interface TableViewProps {
  photos: PhotoItem[];
  selectedIds: string[];
  onToggleSelect: (id: string) => void;
  onSelectAll: () => void;
  onViewPhoto: (photo: PhotoItem) => void;
  onDeletePhoto: (photo: PhotoItem) => void;
  onUpdateTitle: (id: string, newTitle: string) => Promise<void>;
  onToggleFavorite?: (photo: PhotoItem) => void;
  soundEnabled: boolean;
}

const getCategoryColor = (category?: string) => {
  switch (category) {
    case 'شخصي':
      return 'bg-purple-500/15 text-purple-300 border-purple-500/30';
    case 'مستندات':
      return 'bg-amber-500/15 text-amber-300 border-amber-500/30';
    case 'عائلي':
      return 'bg-rose-500/15 text-rose-300 border-rose-500/30';
    case 'عمل':
      return 'bg-blue-500/15 text-blue-300 border-blue-500/30';
    case 'ملاحظات':
      return 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30';
    default:
      return 'bg-teal-500/15 text-teal-300 border-teal-500/30';
  }
};

export const TableView: React.FC<TableViewProps> = ({
  photos,
  selectedIds,
  onToggleSelect,
  onSelectAll,
  onViewPhoto,
  onDeletePhoto,
  onUpdateTitle,
  onToggleFavorite,
  soundEnabled,
}) => {
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editingTitle, setEditingTitle] = useState<string>('');
  const [savingEdit, setSavingEdit] = useState<boolean>(false);

  const isAllSelected = photos.length > 0 && selectedIds.length === photos.length;

  const handleStartEdit = (photo: PhotoItem) => {
    setEditingId(photo.id);
    setEditingTitle(photo.title);
  };

  const handleSaveEdit = async (id: string) => {
    if (!editingTitle.trim()) return;
    try {
      setSavingEdit(true);
      await onUpdateTitle(id, editingTitle.trim());
      setEditingId(null);
      if (soundEnabled) playHapticSound('pop');
    } finally {
      setSavingEdit(false);
    }
  };

  const handleDownload = (photo: PhotoItem, e: React.MouseEvent) => {
    e.stopPropagation();
    if (soundEnabled) playHapticSound('success');
    downloadImage(photo.imageUrl, photo.title, photo.seq);
  };

  return (
    <div className="w-full bg-slate-900 border border-slate-800 rounded-2xl shadow-xl overflow-hidden">
      {/* Table Header Summary */}
      <div className="px-5 py-3.5 bg-slate-850/80 border-b border-slate-800 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="w-2.5 h-2.5 rounded-full bg-teal-400 animate-pulse" />
          <h3 className="text-sm font-bold text-slate-200">
            جدول قاعدة البيانات (التسلسل، الصور، التصنيفات)
          </h3>
          <span className="text-xs bg-slate-800 text-teal-300 px-2 py-0.5 rounded-md font-mono border border-slate-700">
            {photos.length} سجل
          </span>
        </div>
        <p className="text-xs text-slate-400 hidden sm:block">
          انقر لتكبير الصورة أو تنزيلها مباشرة بجودتها الكاملة
        </p>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full text-right text-sm">
          {/* Header Row */}
          <thead>
            <tr className="bg-slate-950/60 border-b border-slate-800 text-slate-400 text-xs font-semibold select-none">
              <th className="py-3.5 px-3 w-10 text-center">
                <button
                  onClick={onSelectAll}
                  className="p-1 rounded hover:bg-slate-800 text-slate-400 hover:text-slate-200 transition-colors"
                  title={isAllSelected ? 'إلغاء تحديد الكل' : 'تحديد الكل'}
                >
                  {isAllSelected ? (
                    <CheckSquare className="w-4 h-4 text-teal-400" />
                  ) : (
                    <Square className="w-4 h-4" />
                  )}
                </button>
              </th>
              {/* Sequence Column */}
              <th className="py-3.5 px-3 font-bold text-teal-400 w-24 whitespace-nowrap">
                <div className="flex items-center gap-1.5">
                  <Hash className="w-4 h-4 text-teal-400" />
                  <span>التسلسل</span>
                </div>
              </th>
              {/* Photo Column */}
              <th className="py-3.5 px-3 font-bold text-teal-400 w-24 whitespace-nowrap">
                <div className="flex items-center gap-1.5">
                  <ImageIcon className="w-4 h-4 text-teal-400" />
                  <span>الصورة</span>
                </div>
              </th>
              {/* Title / Description */}
              <th className="py-3.5 px-3 font-semibold text-slate-300 min-w-[180px]">
                اسم الملف / العنوان
              </th>
              {/* Category */}
              <th className="py-3.5 px-3 font-semibold text-slate-400 w-24 whitespace-nowrap">
                <div className="flex items-center gap-1">
                  <Tag className="w-3.5 h-3.5" />
                  <span>التصنيف</span>
                </div>
              </th>
              {/* Size */}
              <th className="py-3.5 px-3 font-semibold text-slate-400 w-24 whitespace-nowrap">
                <div className="flex items-center gap-1">
                  <HardDrive className="w-3.5 h-3.5" />
                  <span>الحجم</span>
                </div>
              </th>
              {/* Date */}
              <th className="py-3.5 px-3 font-semibold text-slate-400 w-32 whitespace-nowrap">
                <div className="flex items-center gap-1">
                  <Calendar className="w-3.5 h-3.5" />
                  <span>تاريخ الرفع</span>
                </div>
              </th>
              {/* Actions */}
              <th className="py-3.5 px-3 font-bold text-slate-300 text-center w-36 whitespace-nowrap">
                الإجراءات والتحكم
              </th>
            </tr>
          </thead>

          {/* Table Body */}
          <tbody className="divide-y divide-slate-800/60 font-medium">
            {photos.map((photo) => {
              const isSelected = selectedIds.includes(photo.id);
              const isEditing = editingId === photo.id;
              const dateStr = new Date(photo.createdAt).toLocaleDateString('ar-EG', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
              });

              return (
                <tr
                  key={photo.id}
                  onClick={() => onToggleSelect(photo.id)}
                  className={`group transition-colors cursor-pointer ${
                    isSelected
                      ? 'bg-teal-950/30 hover:bg-teal-950/40'
                      : 'hover:bg-slate-800/40'
                  }`}
                >
                  {/* Select Checkbox */}
                  <td className="py-3 px-3 text-center" onClick={(e) => e.stopPropagation()}>
                    <button
                      onClick={() => {
                        if (soundEnabled) playHapticSound('click');
                        onToggleSelect(photo.id);
                      }}
                      className="p-1 rounded text-slate-400 hover:text-slate-200 transition-colors"
                    >
                      {isSelected ? (
                        <CheckSquare className="w-4 h-4 text-teal-400" />
                      ) : (
                        <Square className="w-4 h-4 text-slate-600 group-hover:text-slate-400" />
                      )}
                    </button>
                  </td>

                  {/* Sequence Column (تسلسل) */}
                  <td className="py-3 px-3">
                    <div className="inline-flex items-center justify-center px-2.5 py-1 rounded-lg bg-teal-500/10 text-teal-400 font-mono font-bold text-xs border border-teal-500/30 group-hover:bg-teal-500/20 group-hover:border-teal-400/50 transition-all shadow-sm">
                      #{photo.seq}
                    </div>
                  </td>

                  {/* Photo Column (صورة) */}
                  <td className="py-3 px-3" onClick={(e) => e.stopPropagation()}>
                    <div
                      onClick={() => {
                        if (soundEnabled) playHapticSound('pop');
                        onViewPhoto(photo);
                      }}
                      className="relative w-14 h-14 rounded-xl overflow-hidden bg-slate-950 border border-slate-700/80 group/thumb cursor-pointer shadow-md hover:ring-2 hover:ring-teal-400 transition-all"
                      title="انقر لمعاينة الصورة بالحجم الكامل"
                    >
                      <img
                        src={photo.imageUrl}
                        alt={photo.title}
                        className="w-full h-full object-cover group-hover/thumb:scale-110 transition-transform duration-300"
                        loading="lazy"
                      />
                      <div className="absolute inset-0 bg-black/40 opacity-0 group-hover/thumb:opacity-100 flex items-center justify-center transition-opacity text-white">
                        <Maximize2 className="w-3.5 h-3.5" />
                      </div>
                    </div>
                  </td>

                  {/* Title / Description */}
                  <td className="py-3 px-3" onClick={(e) => e.stopPropagation()}>
                    {isEditing ? (
                      <div className="flex items-center gap-1 max-w-xs">
                        <input
                          type="text"
                          value={editingTitle}
                          onChange={(e) => setEditingTitle(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter') handleSaveEdit(photo.id);
                            if (e.key === 'Escape') setEditingId(null);
                          }}
                          disabled={savingEdit}
                          className="bg-slate-950 text-slate-100 text-xs px-2 py-1 rounded-lg border border-teal-500 focus:outline-none focus:ring-1 focus:ring-teal-400 w-full"
                          autoFocus
                        />
                        <button
                          onClick={() => handleSaveEdit(photo.id)}
                          disabled={savingEdit}
                          className="p-1 rounded-md bg-teal-500 text-white hover:bg-teal-400"
                          title="حفظ"
                        >
                          <Check className="w-3 h-3" />
                        </button>
                        <button
                          onClick={() => setEditingId(null)}
                          disabled={savingEdit}
                          className="p-1 rounded-md bg-slate-800 text-slate-400 hover:text-slate-200"
                          title="إلغاء"
                        >
                          <X className="w-3 h-3" />
                        </button>
                      </div>
                    ) : (
                      <div className="flex items-center gap-1.5 group/edit">
                        <span className="text-slate-200 text-xs font-semibold truncate max-w-xs block">
                          {photo.title}
                        </span>
                        <button
                          onClick={() => handleStartEdit(photo)}
                          className="opacity-0 group-hover/edit:opacity-100 p-0.5 text-slate-400 hover:text-teal-400 transition-opacity"
                          title="تعديل الاسم"
                        >
                          <Edit2 className="w-3 h-3" />
                        </button>
                      </div>
                    )}
                    {photo.width && photo.height ? (
                      <span className="text-[10px] text-slate-500 font-mono mt-0.5 block">
                        {photo.width} × {photo.height} بكسل
                      </span>
                    ) : null}
                  </td>

                  {/* Category Column */}
                  <td className="py-3 px-3 whitespace-nowrap">
                    <span
                      className={`text-[11px] font-bold px-2 py-0.5 rounded-lg border ${getCategoryColor(
                        photo.category
                      )}`}
                    >
                      {photo.category || 'عام'}
                    </span>
                  </td>

                  {/* Size Column */}
                  <td className="py-3 px-3 font-mono text-xs text-slate-400 whitespace-nowrap">
                    {formatBytes(photo.fileSize)}
                  </td>

                  {/* Date Column */}
                  <td className="py-3 px-3 text-xs text-slate-400 whitespace-nowrap">
                    {dateStr}
                  </td>

                  {/* Actions Column (تنزيل / معاينة / حذف) */}
                  <td className="py-3 px-3 text-center" onClick={(e) => e.stopPropagation()}>
                    <div className="flex items-center justify-center gap-1">
                      {/* Favorite button */}
                      {onToggleFavorite && (
                        <button
                          onClick={() => {
                            if (soundEnabled) playHapticSound('click');
                            onToggleFavorite(photo);
                          }}
                          className={`p-1.5 rounded-lg border transition-all ${
                            photo.isFavorite
                              ? 'bg-amber-500/20 text-amber-300 border-amber-500/40'
                              : 'bg-slate-800 text-slate-500 hover:text-amber-400 border-transparent'
                          }`}
                          title="تفضيل الصورة"
                        >
                          <Star className="w-3.5 h-3.5 fill-current" />
                        </button>
                      )}

                      {/* Download */}
                      <button
                        onClick={(e) => handleDownload(photo, e)}
                        className="p-1.5 rounded-lg bg-teal-500/10 text-teal-400 hover:bg-teal-500 hover:text-white border border-teal-500/20 transition-all"
                        title="تنزيل الصورة بجودتها الكاملة"
                        aria-label="تنزيل"
                      >
                        <Download className="w-3.5 h-3.5" />
                      </button>

                      {/* View / Zoom */}
                      <button
                        onClick={() => {
                          if (soundEnabled) playHapticSound('pop');
                          onViewPhoto(photo);
                        }}
                        className="p-1.5 rounded-lg bg-slate-800 text-slate-300 hover:bg-slate-700 hover:text-white transition-all"
                        title="معاينة بالحجم الكامل"
                        aria-label="معاينة"
                      >
                        <Maximize2 className="w-3.5 h-3.5" />
                      </button>

                      {/* Delete */}
                      <button
                        onClick={() => {
                          if (soundEnabled) playHapticSound('delete');
                          onDeletePhoto(photo);
                        }}
                        className="p-1.5 rounded-lg bg-rose-500/10 text-rose-400 hover:bg-rose-500 hover:text-white border border-rose-500/20 transition-all"
                        title="حذف الصورة من قاعدة البيانات"
                        aria-label="حذف"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};
