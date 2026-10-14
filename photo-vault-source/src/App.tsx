/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useEffect, useState, useMemo } from 'react';
import { User, onAuthStateChanged } from 'firebase/auth';
import { auth, signInWithGoogle, logoutUser } from './lib/firebase.ts';
import {
  subscribeToUserPhotos,
  uploadPhotoRecord,
  deletePhotoRecord,
  batchDeletePhotoRecords,
  updatePhotoTitle,
  updatePhotoMetadata,
  exportPhotosToCSV,
} from './lib/photoService.ts';
import { PhotoItem, ViewMode, SortField, SortOrder } from './types/index.ts';
import { Navbar } from './components/Navbar.tsx';
import { Toolbar } from './components/Toolbar.tsx';
import { TableView } from './components/TableView.tsx';
import { GridView } from './components/GridView.tsx';
import { UploadModal } from './components/UploadModal.tsx';
import { LightboxModal } from './components/LightboxModal.tsx';
import { DeleteConfirmModal } from './components/DeleteConfirmModal.tsx';
import { ExportModal } from './components/ExportModal.tsx';
import { InstallBanner } from './components/InstallBanner.tsx';
import { PinVaultModal } from './components/PinVaultModal.tsx';
import { EmptyState } from './components/EmptyState.tsx';
import { AndroidFab } from './components/AndroidFab.tsx';
import { downloadImage, playHapticSound } from './lib/imageUtils.ts';
import { AlertCircle, Loader2, Lock, Unlock, ShieldCheck } from 'lucide-react';

export default function App() {
  const [user, setUser] = useState<User | null>(null);
  const [authLoading, setAuthLoading] = useState<boolean>(true);

  const [photos, setPhotos] = useState<PhotoItem[]>([]);
  const [photosLoading, setPhotosLoading] = useState<boolean>(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // UI state
  const [viewMode, setViewMode] = useState<ViewMode>('table');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [sortField, setSortField] = useState<SortField>('seq');
  const [sortOrder, setSortOrder] = useState<SortOrder>('desc');
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>('الكل');
  const [onlyFavorites, setOnlyFavorites] = useState<boolean>(false);

  // PIN Vault Protection
  const [savedPin, setSavedPin] = useState<string | null>(() => localStorage.getItem('vault_pin'));
  const [isPinLocked, setIsPinLocked] = useState<boolean>(() => !!localStorage.getItem('vault_pin'));
  const [isPinModalOpen, setIsPinModalOpen] = useState<boolean>(false);

  // Modals
  const [isUploadOpen, setIsUploadOpen] = useState<boolean>(false);
  const [isExportOpen, setIsExportOpen] = useState<boolean>(false);
  const [lightboxPhoto, setLightboxPhoto] = useState<PhotoItem | null>(null);
  const [deleteModal, setDeleteModal] = useState<{
    isOpen: boolean;
    targetPhoto: PhotoItem | null;
    isBatch: boolean;
  }>({
    isOpen: false,
    targetPhoto: null,
    isBatch: false,
  });
  const [isDeleting, setIsDeleting] = useState<boolean>(false);

  // PWA Install Prompt State
  const [deferredPrompt, setDeferredPrompt] = useState<any>(null);
  const [showInstallBanner, setShowInstallBanner] = useState<boolean>(() => {
    return localStorage.getItem('hide_install_banner') !== 'true';
  });

  useEffect(() => {
    const handleBeforeInstall = (e: Event) => {
      e.preventDefault();
      setDeferredPrompt(e);
      setShowInstallBanner(true);
    };

    window.addEventListener('beforeinstallprompt', handleBeforeInstall);
    return () => window.removeEventListener('beforeinstallprompt', handleBeforeInstall);
  }, []);

  const handleTriggerInstall = async () => {
    if (deferredPrompt) {
      deferredPrompt.prompt();
      const choice = await deferredPrompt.userChoice;
      if (choice?.outcome === 'accepted') {
        setShowInstallBanner(false);
        setDeferredPrompt(null);
      }
    } else {
      setIsExportOpen(true);
    }
  };

  const handleDismissInstallBanner = () => {
    setShowInstallBanner(false);
    localStorage.setItem('hide_install_banner', 'true');
  };

  // Settings
  const [soundEnabled, setSoundEnabled] = useState<boolean>(() => {
    return localStorage.getItem('app_sound_enabled') !== 'false';
  });

  const toggleSound = () => {
    setSoundEnabled((prev) => {
      const next = !prev;
      localStorage.setItem('app_sound_enabled', String(next));
      return next;
    });
  };

  // Auth Listener
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setAuthLoading(false);
      if (!currentUser) {
        setPhotos([]);
        setSelectedIds([]);
      }
    });
    return () => unsubscribe();
  }, []);

  // Photos Firestore Subscription
  useEffect(() => {
    if (!user) {
      setPhotos([]);
      setPhotosLoading(false);
      return;
    }

    setPhotosLoading(true);
    setErrorMsg(null);

    const unsubscribe = subscribeToUserPhotos(
      user.uid,
      (data) => {
        setPhotos(data);
        setPhotosLoading(false);
      },
      (err) => {
        console.error('Subscription error:', err);
        setErrorMsg('حدث خطأ أثناء مزامنة بيانات الصور مع السحابة');
        setPhotosLoading(false);
      }
    );

    return () => unsubscribe();
  }, [user]);

  // Derived stats
  const totalPhotos = photos.length;
  const totalBytes = useMemo(() => {
    return photos.reduce((acc, curr) => acc + (curr.fileSize || 0), 0);
  }, [photos]);

  const maxSeq = useMemo(() => {
    if (photos.length === 0) return 0;
    return Math.max(...photos.map((p) => p.seq || 0));
  }, [photos]);

  const nextSeqEstimate = maxSeq + 1;

  // Filtered & Sorted Photos
  const filteredPhotos = useMemo(() => {
    let result = [...photos];

    if (selectedCategory !== 'الكل') {
      result = result.filter((p) => (p.category || 'عام') === selectedCategory);
    }

    if (onlyFavorites) {
      result = result.filter((p) => !!p.isFavorite);
    }

    if (searchQuery.trim()) {
      const q = searchQuery.trim().toLowerCase();
      result = result.filter((p) => {
        const matchesSeq = String(p.seq).includes(q) || `#${p.seq}`.includes(q);
        const matchesTitle = p.title.toLowerCase().includes(q);
        const matchesCategory = (p.category || '').toLowerCase().includes(q);
        return matchesSeq || matchesTitle || matchesCategory;
      });
    }

    result.sort((a, b) => {
      let comparison = 0;
      if (sortField === 'seq') {
        comparison = a.seq - b.seq;
      } else if (sortField === 'title') {
        comparison = a.title.localeCompare(b.title);
      } else if (sortField === 'fileSize') {
        comparison = a.fileSize - b.fileSize;
      } else {
        comparison = new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime();
      }
      return sortOrder === 'desc' ? -comparison : comparison;
    });

    return result;
  }, [photos, searchQuery, sortField, sortOrder, selectedCategory, onlyFavorites]);

  // Actions
  const handleLogin = async () => {
    try {
      setErrorMsg(null);
      await signInWithGoogle();
      if (soundEnabled) playHapticSound('success');
    } catch (err) {
      console.error('Login error:', err);
      setErrorMsg('تعذر تسجيل الدخول بحساب Google. يرجى المحاولة مرة أخرى.');
    }
  };

  const handleLogout = async () => {
    try {
      await logoutUser();
      if (soundEnabled) playHapticSound('click');
    } catch (err) {
      console.error('Logout error:', err);
    }
  };

  const handleUploadPhotos = async (
    items: {
      title: string;
      imageUrl: string;
      fileSize: number;
      mimeType: string;
      width: number;
      height: number;
      category: string;
    }[]
  ) => {
    if (!user) return;
    for (const item of items) {
      await uploadPhotoRecord(user.uid, item);
    }
  };

  const handleToggleSelect = (id: string) => {
    setSelectedIds((prev) =>
      prev.includes(id) ? prev.filter((item) => item !== id) : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    if (selectedIds.length === filteredPhotos.length) {
      setSelectedIds([]);
    } else {
      setSelectedIds(filteredPhotos.map((p) => p.id));
    }
    if (soundEnabled) playHapticSound('click');
  };

  const handlePromptDeleteSingle = (photo: PhotoItem) => {
    setDeleteModal({
      isOpen: true,
      targetPhoto: photo,
      isBatch: false,
    });
  };

  const handlePromptDeleteBatch = () => {
    if (selectedIds.length === 0) return;
    setDeleteModal({
      isOpen: true,
      targetPhoto: null,
      isBatch: true,
    });
  };

  const handleConfirmDelete = async () => {
    if (!user) return;
    setIsDeleting(true);
    try {
      if (deleteModal.isBatch) {
        await batchDeletePhotoRecords(user.uid, selectedIds);
        setSelectedIds([]);
      } else if (deleteModal.targetPhoto) {
        await deletePhotoRecord(user.uid, deleteModal.targetPhoto.id);
        setSelectedIds((prev) => prev.filter((id) => id !== deleteModal.targetPhoto?.id));
        if (lightboxPhoto?.id === deleteModal.targetPhoto.id) {
          setLightboxPhoto(null);
        }
      }
      if (soundEnabled) playHapticSound('delete');
      setDeleteModal({ isOpen: false, targetPhoto: null, isBatch: false });
    } catch (err) {
      console.error('Delete error:', err);
      setErrorMsg('تعذر حذف الصورة من قاعدة البيانات');
    } finally {
      setIsDeleting(false);
    }
  };

  const handleBatchDownload = () => {
    const selectedPhotos = photos.filter((p) => selectedIds.includes(p.id));
    selectedPhotos.forEach((photo, idx) => {
      setTimeout(() => {
        downloadImage(photo.imageUrl, photo.title, photo.seq);
      }, idx * 250);
    });
  };

  const handleUpdateTitle = async (id: string, newTitle: string) => {
    if (!user) return;
    await updatePhotoTitle(user.uid, id, newTitle);
  };

  const handleToggleFavorite = async (photo: PhotoItem) => {
    if (!user) return;
    await updatePhotoMetadata(user.uid, photo.id, { isFavorite: !photo.isFavorite });
  };

  const handleSetPin = (newPin: string) => {
    setSavedPin(newPin);
    setIsPinLocked(false);
    localStorage.setItem('vault_pin', newPin);
  };

  const handleUnlockPin = () => {
    setIsPinLocked(false);
  };

  const handleLockPin = () => {
    setIsPinLocked(true);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-['Cairo',sans-serif] selection:bg-teal-500 selection:text-white pb-20 sm:pb-8">
      {/* Navbar */}
      <Navbar
        user={user}
        loading={authLoading}
        onLogin={handleLogin}
        onLogout={handleLogout}
        soundEnabled={soundEnabled}
        onToggleSound={toggleSound}
        onOpenExport={() => setIsExportOpen(true)}
        totalPhotos={totalPhotos}
      />

      {/* Main Container */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 pt-6 space-y-6">
        {/* PWA Direct Mobile Install Banner */}
        {showInstallBanner && (
          <InstallBanner
            hasPrompt={!!deferredPrompt}
            onInstallPrompt={handleTriggerInstall}
            onDismiss={handleDismissInstallBanner}
            soundEnabled={soundEnabled}
          />
        )}

        {/* Global Error Banner */}
        {errorMsg && (
          <div className="p-4 rounded-2xl bg-rose-500/10 border border-rose-500/20 text-rose-300 text-sm flex items-center justify-between animate-fade-in shadow-md">
            <div className="flex items-center gap-3">
              <AlertCircle className="w-5 h-5 text-rose-400 shrink-0" />
              <span>{errorMsg}</span>
            </div>
            <button
              onClick={() => setErrorMsg(null)}
              className="text-xs text-rose-400 hover:text-rose-200 underline"
            >
              إغلاق
            </button>
          </div>
        )}

        {/* Content Flow */}
        {authLoading ? (
          <div className="flex flex-col items-center justify-center min-h-[50vh] gap-3">
            <Loader2 className="w-8 h-8 animate-spin text-teal-400" />
            <p className="text-sm text-slate-400 font-medium">جاري فحص حالة المصادقة...</p>
          </div>
        ) : !user ? (
          <div className="pt-6 sm:pt-12">
            <EmptyState
              isSignedIn={false}
              onLogin={handleLogin}
              onUpload={() => setIsUploadOpen(true)}
            />
          </div>
        ) : isPinLocked ? (
          /* PIN Locked State */
          <div className="bg-slate-900/90 border border-slate-800 rounded-3xl p-10 text-center max-w-md mx-auto shadow-2xl space-y-5 animate-fade-in my-10">
            <div className="w-16 h-16 rounded-2xl bg-rose-500/15 border border-rose-500/30 text-rose-400 mx-auto flex items-center justify-center">
              <Lock className="w-8 h-8" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-slate-100">
                الخزنة مقفلة برمز حماية (PIN)
              </h3>
              <p className="text-xs text-slate-400 mt-1">
                صورك وقاعدة بياناتك محمية برمز سري خاص. أدخل الرمز السري لعرض الصور والتحكم بها.
              </p>
            </div>
            <button
              onClick={() => setIsPinModalOpen(true)}
              className="w-full py-3 rounded-xl bg-teal-500 hover:bg-teal-400 text-white font-bold text-sm shadow-lg shadow-teal-500/25 transition-all flex items-center justify-center gap-2"
            >
              <Unlock className="w-4 h-4" />
              <span>إلغاء قفل الخزنة</span>
            </button>
          </div>
        ) : photosLoading ? (
          <div className="flex flex-col items-center justify-center min-h-[40vh] gap-3">
            <Loader2 className="w-8 h-8 animate-spin text-teal-400" />
            <p className="text-sm text-slate-400 font-medium">
              جاري مزامنة قاعدة بيانات الصور الخاصة...
            </p>
          </div>
        ) : photos.length === 0 ? (
          <div className="pt-6 sm:pt-12">
            <EmptyState
              isSignedIn={true}
              onLogin={handleLogin}
              onUpload={() => setIsUploadOpen(true)}
            />
          </div>
        ) : (
          <div className="space-y-6 animate-fade-in">
            {/* Toolbar & Stats & Categories */}
            <Toolbar
              totalPhotos={totalPhotos}
              totalBytes={totalBytes}
              maxSeq={maxSeq}
              searchQuery={searchQuery}
              onSearchChange={setSearchQuery}
              selectedCategory={selectedCategory}
              onCategoryChange={setSelectedCategory}
              onlyFavorites={onlyFavorites}
              onToggleOnlyFavorites={() => setOnlyFavorites((prev) => !prev)}
              viewMode={viewMode}
              onViewModeChange={setViewMode}
              sortField={sortField}
              sortOrder={sortOrder}
              onSortChange={(f, o) => {
                setSortField(f);
                setSortOrder(o);
              }}
              selectedCount={selectedIds.length}
              onBatchDownload={handleBatchDownload}
              onBatchDelete={handlePromptDeleteBatch}
              onOpenUpload={() => setIsUploadOpen(true)}
              onExportCSV={() => exportPhotosToCSV(filteredPhotos)}
              isPinLocked={isPinLocked}
              hasPin={!!savedPin}
              onOpenPinModal={() => setIsPinModalOpen(true)}
              soundEnabled={soundEnabled}
            />

            {/* No search results fallback */}
            {filteredPhotos.length === 0 ? (
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-10 text-center">
                <p className="text-sm text-slate-300 font-bold">
                  لا توجد صور مطابقة لبحثك أو التصنيف المحدد
                </p>
                <button
                  onClick={() => {
                    setSearchQuery('');
                    setSelectedCategory('الكل');
                    setOnlyFavorites(false);
                  }}
                  className="mt-3 text-xs text-teal-400 hover:underline"
                >
                  إعادة ضبط الفلاتر
                </button>
              </div>
            ) : viewMode === 'table' ? (
              /* Database Table View */
              <TableView
                photos={filteredPhotos}
                selectedIds={selectedIds}
                onToggleSelect={handleToggleSelect}
                onSelectAll={handleSelectAll}
                onViewPhoto={(p) => setLightboxPhoto(p)}
                onDeletePhoto={handlePromptDeleteSingle}
                onUpdateTitle={handleUpdateTitle}
                onToggleFavorite={handleToggleFavorite}
                soundEnabled={soundEnabled}
              />
            ) : (
              /* Visual Gallery Grid View */
              <GridView
                photos={filteredPhotos}
                selectedIds={selectedIds}
                onToggleSelect={handleToggleSelect}
                onViewPhoto={(p) => setLightboxPhoto(p)}
                onDeletePhoto={handlePromptDeleteSingle}
                soundEnabled={soundEnabled}
              />
            )}
          </div>
        )}
      </main>

      {/* Floating Action Button for Mobile Android */}
      {user && !isPinLocked && (
        <AndroidFab
          onOpenUpload={() => setIsUploadOpen(true)}
          soundEnabled={soundEnabled}
        />
      )}

      {/* Upload Modal */}
      <UploadModal
        isOpen={isUploadOpen}
        onClose={() => setIsUploadOpen(false)}
        nextSeqEstimate={nextSeqEstimate}
        onUpload={handleUploadPhotos}
        soundEnabled={soundEnabled}
      />

      {/* Lightbox Modal */}
      <LightboxModal
        photo={lightboxPhoto}
        allPhotos={filteredPhotos}
        onClose={() => setLightboxPhoto(null)}
        onNavigate={(p) => setLightboxPhoto(p)}
        onDelete={handlePromptDeleteSingle}
        soundEnabled={soundEnabled}
      />

      {/* Delete Confirmation Modal */}
      <DeleteConfirmModal
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ isOpen: false, targetPhoto: null, isBatch: false })}
        onConfirm={handleConfirmDelete}
        isDeleting={isDeleting}
        targetPhoto={deleteModal.targetPhoto}
        count={selectedIds.length}
      />

      {/* Export & APK / GitHub Modal */}
      <ExportModal
        isOpen={isExportOpen}
        onClose={() => setIsExportOpen(false)}
        soundEnabled={soundEnabled}
      />

      {/* PIN Vault Locker Modal */}
      <PinVaultModal
        isOpen={isPinModalOpen}
        isLocked={isPinLocked}
        savedPin={savedPin}
        onSetPin={handleSetPin}
        onUnlock={handleUnlockPin}
        onLock={handleLockPin}
        onClose={() => setIsPinModalOpen(false)}
        soundEnabled={soundEnabled}
      />
    </div>
  );
}
