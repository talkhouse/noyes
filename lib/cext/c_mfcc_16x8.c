#include "c_noyes.h"

// Mfcc16x8 is a convenience class that encapsulates an entire front end that
// takes 16kHz audio and transforms it to work with 8kHz models.
Mfcc16x8 * mfcc_16x8_new() {
  double factor = 0.97;
  int nfilt = 32;
  int min_freq = 200;
  int max_freq = 3700;
  int nfft = 256*2;
  int freq = 8000*2;
  int shift = 80*2;
  int frame_size = 205*2;
  double log_zero = -0.00001;
  int dimensions=13;
  int cmn_init_mean=45.0;
  int cmn_window_size=100;
  int cmn_shift=160;
  
  Mfcc16x8 *self = malloc(sizeof(Mfcc16x8));
  self->pre = new_preemphasizer(factor);
  self->seg = new_segmenter(frame_size, shift);
  self->ham = hamming_window_new(frame_size);
  self->pow = new_power_spectrum(nfft);
  self->mel = new_mel_filter(freq, nfft, nfilt, min_freq, max_freq);
  self->log = log_compressor_new(log_zero);
  self->dct = dct_new(dimensions, nfilt);
  self->cmn = live_cmn_new(dimensions, cmn_init_mean, cmn_window_size, cmn_shift);
  return self;
}

void mfcc_16x8_free(Mfcc16x8 *self) {
  free(self->seg);
  free(self->ham);
  free(self->pow);
  free(self->mel);
  free(self->log);
  free(self->dct);
  free(self->cmn);
  free(self);
}

Cmat *mfcc_16x8_apply(Mfcc16x8 *self, Carr * data) {
  Cmat *M = NULL;
  Cmat *N = NULL;
  Carr *data1 = preemphasizer_apply(self->pre, data);
  M = segmenter_apply(self->seg, data1); carr_free(data1);
  if (!M)
    return NULL;
  N = hamming_window_apply(self->ham, M); cmat_free(M);
  M = power_spectrum_apply(self->pow, N); cmat_free(N);
  N = mel_filter_apply(self->mel, M); cmat_free(M);
  M = log_compressor_apply(self->log, N); cmat_free(N);
  N = dct_apply(self->dct, M); cmat_free(M);
  M = live_cmn_apply(self->cmn, N); cmat_free(N);
  return M;
}
