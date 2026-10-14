import {
  collection,
  doc,
  getDoc,
  getDocs,
  onSnapshot,
  orderBy,
  query,
  runTransaction,
  serverTimestamp,
  setDoc,
  updateDoc,
  writeBatch,
} from 'firebase/firestore';
import { PhotoItem, UserProfileData } from '../types/index.ts';
import { auth, db } from './firebase.ts';
import { OperationType, handleFirestoreError } from './firebaseError.ts';

/**
 * Real-time subscription to the user's private photos collection
 */
export function subscribeToUserPhotos(
  userId: string,
  onData: (photos: PhotoItem[]) => void,
  onError: (error: Error) => void
) {
  const photosCollectionPath = `users/${userId}/photos`;
  const photosQuery = query(collection(db, photosCollectionPath), orderBy('seq', 'desc'));

  return onSnapshot(
    photosQuery,
    (snapshot) => {
      const photos: PhotoItem[] = snapshot.docs.map((docSnap) => {
        const data = docSnap.data();
        return {
          id: docSnap.id,
          seq: data.seq ?? 0,
          title: data.title || 'بدون عنوان',
          imageUrl: data.imageUrl,
          fileSize: data.fileSize || 0,
          mimeType: data.mimeType || 'image/jpeg',
          createdAt: data.createdAt ? (typeof data.createdAt === 'string' ? data.createdAt : new Date().toISOString()) : new Date().toISOString(),
          userId: data.userId || userId,
          width: data.width,
          height: data.height,
          category: data.category || 'عام',
          isFavorite: data.isFavorite || false,
          notes: data.notes || '',
        };
      });
      onData(photos);
    },
    (error) => {
      handleFirestoreError(error, OperationType.LIST, photosCollectionPath);
      onError(error);
    }
  );
}

/**
 * Uploads a photo with an auto-incremented sequence number (تسلسل)
 */
export async function uploadPhotoRecord(
  userId: string,
  photoData: {
    title: string;
    imageUrl: string;
    fileSize: number;
    mimeType: string;
    width?: number;
    height?: number;
    category?: string;
  }
): Promise<PhotoItem> {
  const userDocRef = doc(db, 'users', userId);
  const photosCollRef = collection(db, 'users', userId, 'photos');
  const newPhotoDocRef = doc(photosCollRef);

  try {
    let assignedSeq = 1;

    // Run transaction to atomically assign the next sequential number
    await runTransaction(db, async (transaction) => {
      const userSnap = await transaction.get(userDocRef);
      if (userSnap.exists()) {
        const currentLastSeq = userSnap.data()?.lastSeq ?? 0;
        assignedSeq = currentLastSeq + 1;
        transaction.update(userDocRef, {
          lastSeq: assignedSeq,
          updatedAt: new Date().toISOString(),
        });
      } else {
        assignedSeq = 1;
        transaction.set(userDocRef, {
          userId,
          email: auth.currentUser?.email || '',
          displayName: auth.currentUser?.displayName || '',
          photoURL: auth.currentUser?.photoURL || '',
          lastSeq: 1,
          updatedAt: new Date().toISOString(),
        });
      }

      const newPhotoPayload = {
        userId,
        seq: assignedSeq,
        title: photoData.title.slice(0, 256),
        imageUrl: photoData.imageUrl,
        fileSize: photoData.fileSize,
        mimeType: photoData.mimeType,
        createdAt: new Date().toISOString(),
        width: photoData.width || 0,
        height: photoData.height || 0,
        category: photoData.category || 'عام',
        isFavorite: false,
      };

      transaction.set(newPhotoDocRef, newPhotoPayload);
    });

    return {
      id: newPhotoDocRef.id,
      seq: assignedSeq,
      title: photoData.title,
      imageUrl: photoData.imageUrl,
      fileSize: photoData.fileSize,
      mimeType: photoData.mimeType,
      createdAt: new Date().toISOString(),
      userId,
      width: photoData.width,
      height: photoData.height,
      category: photoData.category || 'عام',
      isFavorite: false,
    };
  } catch (error) {
    handleFirestoreError(error, OperationType.WRITE, `users/${userId}/photos/${newPhotoDocRef.id}`);
  }
}

/**
 * Deletes a single photo document
 */
export async function deletePhotoRecord(userId: string, photoId: string): Promise<void> {
  const docPath = `users/${userId}/photos/${photoId}`;
  const photoDocRef = doc(db, 'users', userId, 'photos', photoId);
  try {
    const batch = writeBatch(db);
    batch.delete(photoDocRef);
    await batch.commit();
  } catch (error) {
    handleFirestoreError(error, OperationType.DELETE, docPath);
  }
}

/**
 * Batch deletes multiple photo documents
 */
export async function batchDeletePhotoRecords(userId: string, photoIds: string[]): Promise<void> {
  if (photoIds.length === 0) return;
  const basePath = `users/${userId}/photos`;
  try {
    const batch = writeBatch(db);
    photoIds.forEach((id) => {
      const ref = doc(db, 'users', userId, 'photos', id);
      batch.delete(ref);
    });
    await batch.commit();
  } catch (error) {
    handleFirestoreError(error, OperationType.DELETE, basePath);
  }
}

/**
 * Updates a photo title or sequence note
 */
export async function updatePhotoTitle(userId: string, photoId: string, title: string): Promise<void> {
  const docPath = `users/${userId}/photos/${photoId}`;
  const photoDocRef = doc(db, 'users', userId, 'photos', photoId);
  try {
    await updateDoc(photoDocRef, {
      title: title.slice(0, 256),
    });
  } catch (error) {
    handleFirestoreError(error, OperationType.UPDATE, docPath);
  }
}

/**
 * Updates category or favorite status
 */
export async function updatePhotoMetadata(
  userId: string,
  photoId: string,
  updates: Partial<Pick<PhotoItem, 'category' | 'isFavorite' | 'title'>>
): Promise<void> {
  const docPath = `users/${userId}/photos/${photoId}`;
  const photoDocRef = doc(db, 'users', userId, 'photos', photoId);
  try {
    await updateDoc(photoDocRef, updates);
  } catch (error) {
    handleFirestoreError(error, OperationType.UPDATE, docPath);
  }
}

/**
 * Exports database records to CSV
 */
export function exportPhotosToCSV(photos: PhotoItem[]) {
  const headers = ['التسلسل (Seq)', 'العنوان (Title)', 'التصنيف (Category)', 'الحجم (Bytes)', 'التاريخ (Date)'];
  const rows = photos.map((p) => [
    p.seq,
    `"${(p.title || '').replace(/"/g, '""')}"`,
    `"${p.category || 'عام'}"`,
    p.fileSize,
    `"${p.createdAt}"`,
  ]);

  const csvContent = '\uFEFF' + [headers.join(','), ...rows.map((r) => r.join(','))].join('\n');
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', `قاعدة_بيانات_الصور_${new Date().toISOString().slice(0, 10)}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
