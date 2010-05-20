#include "noyes.h"
#include "math.h"

HammingWindow * new_hamming_window(int window_size) {
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

void free_hamming_window(HammingWindow *hw) {
  free(hw->buf);
  free(hw);
}

NMatrix * hamming_window_apply(HammingWindow *self, NMatrix* N) {
  NMatrix *M = new_nmatrix(N->rows, N->cols);
  int i,j;
  for (i=0;i<N->rows;++i) {
    for (j=0;j<N->cols;++j) {
        M->data[i][j] = self->buf[j] * N->data[i][j];
    }
  }
  return M;
}
