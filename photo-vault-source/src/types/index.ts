export interface PhotoItem {
  id: string;
  seq: number;
  title: string;
  imageUrl: string;
  fileSize: number;
  mimeType: string;
  createdAt: string;
  userId: string;
  width?: number;
  height?: number;
  category?: string;
  isFavorite?: boolean;
  notes?: string;
}

export interface UserProfileData {
  userId: string;
  email?: string;
  displayName?: string;
  photoURL?: string;
  lastSeq: number;
  updatedAt: string;
}

export type ViewMode = 'table' | 'grid';
export type SortField = 'seq' | 'createdAt' | 'title' | 'fileSize';
export type SortOrder = 'asc' | 'desc';

export const PHOTO_CATEGORIES = [
  'الكل',
  'شخصي',
  'مستندات',
  'عائلي',
  'عمل',
  'ملاحظات',
] as const;

export type PhotoCategory = (typeof PHOTO_CATEGORIES)[number];
