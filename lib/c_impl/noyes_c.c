#include "noyes.h"

NData2 *new_ndata2(int rows, int cols) {
  NData2 *d = malloc(sizeof(NData2));
  d->data = malloc(rows * sizeof(double));
  int i;
  for (i=0;i<rows;++i) {
    d->data[i] = malloc(cols * sizeof(double));
  }
  d->rows = rows;
  d->cols = cols;
  return d;
}

void free_ndata2(NData2 *d) {
  int i;
  for (i=0;i<d->rows;++i) {
    free(d->data[i]);
  }
  free(d->data);
  free(d);
}

void Init_noyes_c() {
  Init_segmenter();
  Init_preemphasis();
}
