import React, { useState } from 'react';
import { Lock, Unlock, KeyRound, X, Check, ShieldAlert } from 'lucide-react';
import { playHapticSound } from '../lib/imageUtils.ts';

interface PinVaultModalProps {
  isOpen: boolean;
  isLocked: boolean;
  savedPin: string | null;
  onSetPin: (pin: string) => void;
  onUnlock: () => void;
  onLock: () => void;
  onClose: () => void;
  soundEnabled: boolean;
}

export const PinVaultModal: React.FC<PinVaultModalProps> = ({
  isOpen,
  isLocked,
  savedPin,
  onSetPin,
  onUnlock,
  onLock,
  onClose,
  soundEnabled,
}) => {
  const [enteredPin, setEnteredPin] = useState('');
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [isSettingNewPin, setIsSettingNewPin] = useState(!savedPin);

  if (!isOpen) return null;

  const handleKeyPress = (digit: string) => {
    if (enteredPin.length < 4) {
      if (soundEnabled) playHapticSound('click');
      const next = enteredPin + digit;
      setEnteredPin(next);
      setErrorMsg(null);

      if (next.length === 4) {
        if (isSettingNewPin) {
          onSetPin(next);
          if (soundEnabled) playHapticSound('success');
          onClose();
        } else {
          if (next === savedPin) {
            onUnlock();
            if (soundEnabled) playHapticSound('success');
            onClose();
          } else {
            if (soundEnabled) playHapticSound('delete');
            setErrorMsg('الرمز السري غير صحيح');
            setEnteredPin('');
          }
        }
      }
    }
  };

  const handleClear = () => {
    setEnteredPin('');
    setErrorMsg(null);
    if (soundEnabled) playHapticSound('click');
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in">
      <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-sm p-6 shadow-2xl space-y-6 text-center">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="w-12 h-12 rounded-2xl bg-teal-500/15 border border-teal-500/30 text-teal-400 mx-auto flex items-center justify-center">
            {isLocked ? <Lock className="w-6 h-6" /> : <Unlock className="w-6 h-6" />}
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-xl text-slate-400 hover:text-slate-100 hover:bg-slate-800 absolute top-5 left-5"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <div>
          <h3 className="text-lg font-extrabold text-slate-100">
            {isSettingNewPin
              ? 'تعيين رمز سري للخزنة (PIN)'
              : isLocked
              ? 'الخزنة مقفلة برمز سري'
              : 'إدارة قفل الخزنة'}
          </h3>
          <p className="text-xs text-slate-400 mt-1">
            {isSettingNewPin
              ? 'اختر 4 أرقام لحماية الصور الخاصة من المشاهدة غير المصرح بها'
              : isLocked
              ? 'أدخل الرمز السري المكون من 4 أرقام لإظهار الصور'
              : 'الخزنة مفتوحة حالياً، يمكنك قفلها بنقرة واحدة'}
          </p>
        </div>

        {!isLocked && savedPin && !isSettingNewPin ? (
          <div className="space-y-3 pt-2">
            <button
              onClick={() => {
                onLock();
                if (soundEnabled) playHapticSound('delete');
                onClose();
              }}
              className="w-full py-3 rounded-xl bg-rose-600 hover:bg-rose-500 text-white font-bold text-sm shadow-lg shadow-rose-900/30 transition-all flex items-center justify-center gap-2"
            >
              <Lock className="w-4 h-4" />
              <span>قفل الخزنة الآن</span>
            </button>
            <button
              onClick={() => {
                setIsSettingNewPin(true);
                setEnteredPin('');
              }}
              className="w-full py-2.5 rounded-xl bg-slate-800 hover:bg-slate-750 text-slate-300 text-xs font-semibold"
            >
              تغيير الرمز السري الحالي
            </button>
          </div>
        ) : (
          <>
            {/* PIN Dots Display */}
            <div className="flex items-center justify-center gap-4 py-2">
              {[0, 1, 2, 3].map((idx) => (
                <div
                  key={idx}
                  className={`w-4 h-4 rounded-full transition-all duration-200 ${
                    enteredPin.length > idx
                      ? 'bg-teal-400 ring-4 ring-teal-400/30 scale-110'
                      : 'bg-slate-800 border border-slate-700'
                  }`}
                />
              ))}
            </div>

            {errorMsg && (
              <p className="text-xs text-rose-400 font-semibold animate-shake">
                {errorMsg}
              </p>
            )}

            {/* Numeric Keypad */}
            <div className="grid grid-cols-3 gap-3 pt-2 max-w-[240px] mx-auto">
              {['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((digit) => (
                <button
                  key={digit}
                  onClick={() => handleKeyPress(digit)}
                  className="w-16 h-16 rounded-2xl bg-slate-800/80 hover:bg-slate-750 active:bg-teal-500 active:text-white border border-slate-700/60 font-mono font-extrabold text-xl text-slate-200 transition-all flex items-center justify-center shadow-md active:scale-95"
                >
                  {digit}
                </button>
              ))}
              <button
                onClick={handleClear}
                className="w-16 h-16 rounded-2xl bg-slate-850 hover:bg-slate-800 text-slate-400 font-bold text-xs flex items-center justify-center transition-all"
              >
                مسح
              </button>
              <button
                onClick={() => handleKeyPress('0')}
                className="w-16 h-16 rounded-2xl bg-slate-800/80 hover:bg-slate-750 active:bg-teal-500 active:text-white border border-slate-700/60 font-mono font-extrabold text-xl text-slate-200 transition-all flex items-center justify-center shadow-md active:scale-95"
              >
                0
              </button>
              <div className="w-16 h-16" />
            </div>
          </>
        )}
      </div>
    </div>
  );
};
