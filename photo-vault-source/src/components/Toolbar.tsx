import React from 'react';
import {
  Search,
  Table,
  LayoutGrid,
  UploadCloud,
  Download,
  Trash2,
  HardDrive,
  Hash,
  Layers,
  FileSpreadsheet,
  Star,
  Lock,
  Unlock,
  Filter,
} from 'lucide-react';
import { ViewMode, SortField, SortOrder, PHOTO_CATEGORIES } from '../types/index.ts';
import { formatBytes, playHapticSound } from '../lib/imageUtils.ts';

interface ToolbarProps {
  totalPhotos: number;
  totalBytes: number;
  maxSeq: number;
  searchQuery: string;
  onSearchChange: (query: string) => void;
  selectedCategory: string;
  onCategoryChange: (cat: string) => void;
  onlyFavorites: boolean;
  onToggleOnlyFavorites: () => void;
  viewMode: ViewMode;
  onViewModeChange: (mode: ViewMode) => void;
  sortField: SortField;
  sortOrder: SortOrder;
  onSortChange: (field: SortField, order: SortOrder) => void;
  selectedCount: number;
  onBatchDownload: () => void;
  onBatchDelete: () => void;
  onOpenUpload: () => void;
  onExportCSV: () => void;
  isPinLocked: boolean;
  hasPin: boolean;
  onOpenPinModal: () => void;
  soundEnabled: boolean;
}

export const Toolbar: React.FC<ToolbarProps> = ({
  totalPhotos,
  totalBytes,
  maxSeq,
  searchQuery,
  onSearchChange,
  selectedCategory,
  onCategoryChange,
  onlyFavorites,
  onToggleOnlyFavorites,
  viewMode,
  onViewModeChange,
  sortField,
  sortOrder,
  onSortChange,
  selectedCount,
  onBatchDownload,
  onBatchDelete,
  onOpenUpload,
  onExportCSV,
  isPinLocked,
  hasPin,
  onOpenPinModal,
  soundEnabled,
}) => {
  return (
    <div className="space-y-4">
      {/* Top Stats Cards with Glassmorphism */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {/* Total Records */}
        <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-3.5 flex items-center gap-3 shadow-md">
          <div className="w-10 h-10 rounded-xl bg-teal-500/10 border border-teal-500/20 text-teal-400 flex items-center justify-center shrink-0">
            <Layers className="w-5 h-5" />
          </div>
          <div>
            <p className="text-[11px] text-slate-400 font-medium">إجمالي السجلات</p>
            <p className="text-lg font-extrabold text-slate-100 font-mono leading-tight">
              {totalPhotos}
            </p>
          </div>
        </div>

        {/* Highest Sequence Number */}
        <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-3.5 flex items-center gap-3 shadow-md">
          <div className="w-10 h-10 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 flex items-center justify-center shrink-0">
            <Hash className="w-5 h-5" />
          </div>
          <div>
            <p className="text-[11px] text-slate-400 font-medium">أعلى تسلسل</p>
            <p className="text-lg font-extrabold text-cyan-400 font-mono leading-tight">
              #{maxSeq}
            </p>
          </div>
        </div>

        {/* Total Storage Used */}
        <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-3.5 flex items-center gap-3 shadow-md">
          <div className="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
            <HardDrive className="w-5 h-5" />
          </div>
          <div>
            <p className="text-[11px] text-slate-400 font-medium">حجم البيانات</p>
            <p className="text-sm sm:text-base font-extrabold text-slate-100 font-mono leading-tight">
              {formatBytes(totalBytes)}
            </p>
          </div>
        </div>

        {/* PIN Locker Button */}
        <button
          onClick={() => {
            if (soundEnabled) playHapticSound('click');
            onOpenPinModal();
          }}
          className={`border rounded-2xl p-3.5 flex items-center justify-between text-right transition-all shadow-md active:scale-95 ${
            isPinLocked
              ? 'bg-rose-950/40 border-rose-500/40 text-rose-300 hover:bg-rose-950/60'
              : hasPin
              ? 'bg-slate-900/90 border-teal-500/30 text-teal-300 hover:bg-slate-850'
              : 'bg-slate-900/90 border-slate-800 text-slate-300 hover:bg-slate-850'
          }`}
        >
          <div>
            <p className="text-[11px] text-slate-400 font-medium">حماية الخزنة</p>
            <p className="text-xs font-bold mt-0.5">
              {isPinLocked ? 'الخزنة مقفلة' : hasPin ? 'مقفلة برمز' : 'تفعيل قفل PIN'}
            </p>
          </div>
          <div className="p-2 rounded-xl bg-slate-800 text-teal-400">
            {isPinLocked ? <Lock className="w-4 h-4 text-rose-400" /> : <Unlock className="w-4 h-4" />}
          </div>
        </button>
      </div>

      {/* Categories & Filter Bar */}
      <div className="flex items-center justify-between gap-2 overflow-x-auto pb-1 text-xs">
        <div className="flex items-center gap-1.5 shrink-0">
          <span className="text-slate-400 text-xs font-bold flex items-center gap-1 ml-1">
            <Filter className="w-3.5 h-3.5 text-teal-400" /> التصنيف:
          </span>
          {PHOTO_CATEGORIES.map((cat) => (
            <button
              key={cat}
              onClick={() => {
                if (soundEnabled) playHapticSound('click');
                onCategoryChange(cat);
              }}
              className={`px-3 py-1.5 rounded-xl font-bold transition-all ${
                selectedCategory === cat
                  ? 'bg-teal-500 text-white shadow-md shadow-teal-500/20'
                  : 'bg-slate-900/80 text-slate-400 hover:text-slate-200 border border-slate-800 hover:border-slate-700'
              }`}
            >
              {cat}
            </button>
          ))}

          {/* Favorites Filter */}
          <button
            onClick={() => {
              if (soundEnabled) playHapticSound('click');
              onToggleOnlyFavorites();
            }}
            className={`px-3 py-1.5 rounded-xl font-bold transition-all flex items-center gap-1.5 ${
              onlyFavorites
                ? 'bg-amber-500 text-white shadow-md shadow-amber-500/20'
                : 'bg-slate-900/80 text-slate-400 hover:text-amber-400 border border-slate-800'
            }`}
          >
            <Star className={`w-3.5 h-3.5 ${onlyFavorites ? 'fill-current' : ''}`} />
            <span>المفضلة</span>
          </button>
        </div>

        {/* CSV Export & Upload CTA */}
        <div className="flex items-center gap-2 shrink-0">
          <button
            onClick={() => {
              if (soundEnabled) playHapticSound('success');
              onExportCSV();
            }}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-900/90 hover:bg-slate-850 text-slate-300 border border-slate-800 text-xs font-bold transition-all"
            title="تصدير جدول قاعدة البيانات كملف Excel / CSV"
          >
            <FileSpreadsheet className="w-3.5 h-3.5 text-emerald-400" />
            <span className="hidden sm:inline">تصدير CSV</span>
          </button>

          <button
            onClick={() => {
              if (soundEnabled) playHapticSound('pop');
              onOpenUpload();
            }}
            className="bg-gradient-to-r from-teal-500 to-emerald-600 hover:from-teal-400 hover:to-emerald-500 text-white rounded-xl px-4 py-1.5 flex items-center gap-1.5 shadow-md shadow-teal-500/20 font-bold text-xs active:scale-95"
          >
            <UploadCloud className="w-3.5 h-3.5" />
            <span>رفع صورة</span>
          </button>
        </div>
      </div>

      {/* Main Control Strip */}
      <div className="bg-slate-900 border border-slate-800 rounded-2xl p-3 flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3 shadow-md">
        {/* Search Bar */}
        <div className="relative flex-1 max-w-md">
          <Search className="w-4 h-4 text-slate-400 absolute right-3.5 top-1/2 -translate-y-1/2 pointer-events-none" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            placeholder="بحث برقم التسلسل (مثلاً: 3) أو بالاسم..."
            className="w-full bg-slate-950 text-slate-100 text-xs sm:text-sm pl-4 pr-10 py-2.5 rounded-xl border border-slate-800 focus:outline-none focus:border-teal-400 placeholder:text-slate-500"
          />
          {searchQuery && (
            <button
              onClick={() => onSearchChange('')}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-xs text-slate-400 hover:text-slate-200"
            >
              مسح
            </button>
          )}
        </div>

        {/* Selected Batch Actions Strip */}
        {selectedCount > 0 ? (
          <div className="flex items-center gap-2 bg-teal-950/40 border border-teal-500/30 px-3 py-1.5 rounded-xl animate-fade-in">
            <span className="text-xs font-bold text-teal-300">
              {selectedCount} صور محددة:
            </span>
            <button
              onClick={() => {
                if (soundEnabled) playHapticSound('success');
                onBatchDownload();
              }}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-teal-500 text-white text-xs font-bold hover:bg-teal-400 transition-colors shadow"
              title="تنزيل الصور المحددة"
            >
              <Download className="w-3.5 h-3.5" />
              <span>تنزيل</span>
            </button>
            <button
              onClick={() => {
                if (soundEnabled) playHapticSound('delete');
                onBatchDelete();
              }}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-rose-500/20 text-rose-300 border border-rose-500/30 text-xs font-bold hover:bg-rose-500 hover:text-white transition-colors"
              title="حذف الصور المحددة"
            >
              <Trash2 className="w-3.5 h-3.5" />
              <span>حذف</span>
            </button>
          </div>
        ) : null}

        {/* View Mode Toggle (Table vs Grid) */}
        <div className="flex items-center justify-between md:justify-end gap-2">
          <div className="flex items-center bg-slate-950 p-1 rounded-xl border border-slate-800">
            <button
              onClick={() => {
                if (soundEnabled) playHapticSound('click');
                onViewModeChange('table');
              }}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                viewMode === 'table'
                  ? 'bg-teal-500 text-white shadow'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
              title="عرض جدول قاعدة البيانات"
            >
              <Table className="w-4 h-4" />
              <span>جدول البيانات</span>
            </button>

            <button
              onClick={() => {
                if (soundEnabled) playHapticSound('click');
                onViewModeChange('grid');
              }}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                viewMode === 'grid'
                  ? 'bg-teal-500 text-white shadow'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
              title="عرض شبكة المعرض"
            >
              <LayoutGrid className="w-4 h-4" />
              <span>المعرض</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
