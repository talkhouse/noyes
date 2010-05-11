#include "noyes.h"
#include "math.h"

DiscreteCosineTransform * new_dct(int rows, int cols) {
  DiscreteCosineTransform *dct = malloc(sizeof(DiscreteCosineTransform));
  dct->melcos = malloc(rows *sizeof(double*));
  dct->rows = rows;
  dct->cols = cols;
  int i,j;
  for (i=0;i<rows;++i) {
      double freq = M_PI * i / cols;
      double * ldct = malloc(sizeof(double) * cols);
      for (j=0;j<cols;++j) {
          ldct[j] = cos(freq * (j + 0.5)) / rows;
      }
      dct->melcos[i] = ldct;
  }
  return dct;
}

void free_dct(DiscreteCosineTransform *dct) {
  int i;
  for (i=0;i<dct->rows;++i) {
    free(dct->melcos[i]);
  }
  free(dct->melcos);
  free(dct);
}

NMatrix * dct_apply(DiscreteCosineTransform *self, NMatrix *data) {
  NMatrix *M = new_nmatrix(data->rows, self->rows);
  int i,j,k;
  for (i=0;i<data->rows;++i) {
      for (j=0;j<self->rows;++j) {
          for (k=0;k<self->cols; ++k) {
              M->data[i][j] += M->data[i][k] * self->melcos[j][k];
          }
      }
  }
  return M;
}
