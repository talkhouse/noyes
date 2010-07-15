#include "c_noyes.h"
#include "math.h"

HammingWindow * hamming_window_new(int window_size) {
  HammingWindow *hw = malloc(sizeof(HammingWindow));
  hw->buf = malloc(window_size * sizeof(double));
  hw->buflen = window_size;
  double twopi = M_PI * 2;
  int i;
  for (i=0;i<window_size;++i) {
      hw->buf[i] = 0.54 - 0.46*cos(twopi*i/(window_size-1));
  }
  return hw;
}

void hamming_window_free(HammingWindow *hw) {
  free(hw->buf);
  free(hw);
}

Cmat * hamming_window_apply(HammingWindow *self, Cmat* N) {
  Cmat *M = cmat_new(N->rows, N->cols);
  int i,j;
  for (i=0;i<N->rows;++i) {
    for (j=0;j<N->cols;++j) {
        M->data[i][j] = self->buf[j] * N->data[i][j];
    }
  }
  return M;
}
