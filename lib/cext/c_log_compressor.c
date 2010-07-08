#include "c_noyes.h"
#include "math.h"

LogCompressor * new_log_compressor(double log_zero) {
  return malloc(sizeof(LogCompressor));
}

void free_log_compressor(LogCompressor *lc) {
  free(lc);
}

Cmat * log_compressor_apply(LogCompressor *self, Cmat *data) {
  Cmat *M = cmat_new(data->rows, data->cols);
  int i, j;
  for (i=0;i<M->rows;++i) {
      for (j=0;j<M->cols;++j) {
          M->data[i][j] = data->data[i][j] > 0 ? log(data->data[i][j]) : self->log_zero;
      }
  }
  return M;
}
