#include "noyes.h"

// A 2 dimensional matrix "class".
NMatrix *new_nmatrix(int rows, int cols) {
  NMatrix *M = malloc(sizeof(NMatrix));
  M->data = malloc(rows * sizeof(double*));
  int i;
  for (i=0;i<rows;++i) {
    M->data[i] = malloc(cols * sizeof(double));
  }
  M->rows = rows;
  M->cols = cols;
  return M;
}

void free_nmatrix(NMatrix *M) {
  if (M) {
    int i;
    for (i=0;i<M->rows;++i) {
      free(M->data[i]);
    }
    free(M->data);
    free(M);
  }
}

// A 1 dimensional matrix "class".
NMatrix1 *new_nmatrix1(int rows) {
  NMatrix1 *M = malloc(sizeof(NMatrix1));
  M->data = malloc(rows * sizeof(double));
  M->rows = rows;
  return M;
}

void free_nmatrix1(NMatrix1 *M) {
  if (M) {
    free(M->data);
    free(M);
  }
}
