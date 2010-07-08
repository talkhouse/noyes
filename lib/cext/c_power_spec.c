#include "noyes.h"
#include "stdlib.h"
#include "math.h"

PowerSpectrum * new_power_spectrum(int nfft) {
  PowerSpectrum *ps = malloc(sizeof(PowerSpectrum));
  ps->nfft = nfft;
  ps->n_uniq_fft_points = nfft/2 + 1;
  return ps;
}

void free_power_spectrum(PowerSpectrum * self) {
  free(self);
}

Cmat *power_spectrum_apply(PowerSpectrum *self, Cmat *data) {
  Cmat *ps = cmat_new(data->rows, self->n_uniq_fft_points);
  int i,j;
  for (i=0;i<data->rows;++i) {
      Cmat * ffts = dft(data->data[i], data->cols, self->nfft);
      for (j=0;j<self->n_uniq_fft_points;++j) {
          ps->data[i][j] = pow(ffts->data[0][j],2) + pow(ffts->data[1][j],2);
      }
      cmat_free(ffts);
  } 
  return ps;
}
