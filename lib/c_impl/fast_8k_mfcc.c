#include "noyes.h"


Fast8kMfcc * new_fast_8k_mfcc() {
  double factor = 0.97;
  int nfilt = 32;
  int min_freq = 200;
  int max_freq = 3700;
  int nfft = 256;
  int freq = 8000;
  int shift = 80;
  int frame_size = 205;
  double log_zero = -0.00001;
  int dimensions=13;
  int cmn_init_mean=45.0;
  int cmn_window_size=100;
  int cmn_shift=160;
  
  Fast8kMfcc *self = malloc(sizeof(Fast8kMfcc));
  self->pre = new_preemphasizer(factor);
  self->seg = new_segmenter(frame_size, shift);
  self->ham = new_hamming_window(frame_size);
  self->pow = new_power_spectrum(nfft);
  self->mel = new_mel_filter(freq, nfft, nfilt, min_freq, max_freq);
  self->log = new_log_compressor(log_zero);
  self->dct = new_dct(dimensions, nfilt);
  self->cmn = new_live_cmn(dimensions, cmn_init_mean, cmn_window_size, cmn_shift);
  return self;
}

void free_fast8k_mfcc(Fast8kMfcc *self) {
  free(self->seg);
  free(self->ham);
  free(self->pow);
  free(self->mel);
  free(self->log);
  free(self->dct);
  free(self->cmn);
  free(self);
}

NMatrix *fast_8k_mfcc_apply(Fast8kMfcc *self, NMatrix1 * data) {
  NMatrix *M = NULL;
  NMatrix1 *data1 = preemphasizer_apply(self->pre, data);
  M = segmenter_apply(self->seg, data1);
  return M;
}
