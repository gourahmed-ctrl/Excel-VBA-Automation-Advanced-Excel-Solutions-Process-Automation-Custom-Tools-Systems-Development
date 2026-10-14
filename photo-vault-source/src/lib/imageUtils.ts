export interface ProcessedImage {
  dataUrl: string;
  width: number;
  height: number;
  sizeBytes: number;
  mimeType: string;
  name: string;
}

/**
 * Optimizes an image file for storage within document limits (max 850KB target),
 * maintaining sharp quality and responsive dimensions.
 */
export async function processImageFile(file: File, maxDimension = 1400, quality = 0.82): Promise<ProcessedImage> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onerror = () => reject(new Error('فشل في قراءة ملف الصورة'));

    reader.onload = () => {
      const img = new Image();
      img.onerror = () => reject(new Error('تعذر تحميل الصورة لمعالجتها'));

      img.onload = () => {
        let width = img.width;
        let height = img.height;

        if (width > maxDimension || height > maxDimension) {
          if (width > height) {
            height = Math.round((height * maxDimension) / width);
            width = maxDimension;
          } else {
            width = Math.round((width * maxDimension) / height);
            height = maxDimension;
          }
        }

        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;
        const ctx = canvas.getContext('2d');

        if (!ctx) {
          reject(new Error('تعذر معالجة الكانفاس'));
          return;
        }

        // Smoother rendering
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';
        ctx.drawImage(img, 0, 0, width, height);

        // Attempt WebP first, fallback to JPEG
        let mime = 'image/webp';
        let dataUrl = canvas.toDataURL(mime, quality);

        // If webp produced a larger or default png or unsupported, test jpeg
        if (!dataUrl.startsWith('data:image/webp')) {
          mime = 'image/jpeg';
          dataUrl = canvas.toDataURL(mime, quality);
        }

        // If still exceeding 850KB, reduce quality step-down
        if (dataUrl.length > 850000) {
          dataUrl = canvas.toDataURL(mime, 0.65);
        }
        if (dataUrl.length > 850000) {
          dataUrl = canvas.toDataURL(mime, 0.5);
        }

        const approxBytes = Math.round((dataUrl.length * 3) / 4);

        resolve({
          dataUrl,
          width,
          height,
          sizeBytes: approxBytes,
          mimeType: mime,
          name: file.name.replace(/\.[^/.]+$/, '') || 'صورة_خاصة',
        });
      };

      img.src = reader.result as string;
    };

    reader.readAsDataURL(file);
  });
}

/**
 * Downloads a single image to the user's device
 */
export function downloadImage(dataUrl: string, filename: string, seq?: number) {
  const link = document.createElement('a');
  link.href = dataUrl;
  const cleanName = filename.replace(/[^a-zA-Z0-9_\u0600-\u06FF-]/g, '_');
  const seqPrefix = seq !== undefined ? `تسلسل_${seq}_` : '';
  link.download = `${seqPrefix}${cleanName}.jpg`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

/**
 * Formats bytes to human readable format (كيلوبايت / ميجابايت)
 */
export function formatBytes(bytes: number, decimals = 1): string {
  if (bytes === 0) return '0 بايت';
  const k = 1024;
  const dm = decimals < 0 ? 0 : decimals;
  const sizes = ['بايت', 'كيلوبايت', 'ميجابايت', 'جيجابايت'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
}

/**
 * Plays a subtle modern tactile sound effect (synthesized via Web Audio API)
 */
export function playHapticSound(type: 'click' | 'success' | 'delete' | 'pop') {
  try {
    const AudioContextClass = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
    if (!AudioContextClass) return;
    const ctx = new AudioContextClass();

    if (type === 'click') {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = 'sine';
      osc.frequency.setValueAtTime(440, ctx.currentTime);
      gain.gain.setValueAtTime(0.05, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.05);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(ctx.currentTime + 0.05);
    } else if (type === 'success') {
      const now = ctx.currentTime;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(523.25, now); // C5
      osc.frequency.exponentialRampToValueAtTime(783.99, now + 0.15); // G5
      gain.gain.setValueAtTime(0.08, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.2);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(now + 0.2);
    } else if (type === 'delete') {
      const now = ctx.currentTime;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(300, now);
      osc.frequency.exponentialRampToValueAtTime(120, now + 0.12);
      gain.gain.setValueAtTime(0.06, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.12);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(now + 0.12);
    } else if (type === 'pop') {
      const now = ctx.currentTime;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = 'sine';
      osc.frequency.setValueAtTime(800, now);
      gain.gain.setValueAtTime(0.04, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      osc.stop(now + 0.04);
    }
  } catch {
    // Audio might be blocked by browser policy until interaction
  }
}
