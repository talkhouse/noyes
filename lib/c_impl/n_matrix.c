#include "noyes.h"
#include "memory.h"

// A 2 dimensional matrix "class".
NMat *nmat_new(int rows, int cols) {
  NMat *M = malloc(sizeof(NMat));
  M->data = malloc(rows * sizeof(double*));
  int i;
  for (i=0;i<rows;++i) {
    M->data[i] = malloc(cols * sizeof(double));
  }
  M->rows = rows;
  M->cols = cols;
  return M;
}

void nmat_free(NMat *M) {
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
NMat1 *nmat_new1(int rows) {
  NMat1 *M = malloc(sizeof(NMat1));
  M->data = malloc(rows * sizeof(double));
  M->rows = rows;
  return M;
}

void nmat_free1(NMat1 *M) {
  if (M) {
    free(M->data);
    free(M);
  }
}

// Converts a square matrix to a list of one dimensional matrices.
// Simultaneously frees the original square matrix.
NMat1 ** mat2arrs(NMat *M) {
  NMat1 **single = malloc(sizeof(NMat1*) * M->rows);
  int i;
  for (i=0;i<M->rows;++i) {
    single[i] = malloc(sizeof(NMat1));
    single[i]->data = M->data[i];
    single[i]->rows = M->cols;
  }
  free(M->data);
  free(M);
  return single;
}

// Does not delete the original matrix
NMat1 *nmat_flatten(NMat *M) {
  NMat1 *fmat = malloc(sizeof(NMat));
  fmat->rows = M->rows * M->cols;
  fmat->data = malloc(fmat->rows * sizeof(double));
  int i;
  for (i=0;i<M->rows; ++i)
    memcpy(fmat->data + (M->cols * i), M->data[i], sizeof(double) * M->cols);

  return fmat;
}

// Converts an array of one dimensional arrays into a square matrix.  It frees
// these arrays in the process.
NMat * arrs2mat(NMat1 **array, int size) {
  if (size ==0)
    return NULL;
  NMat *result = malloc(sizeof(NMat));
  result->data = malloc(sizeof(double*) * size);
  result->rows = size;
  int i;
  for (i=0; i<size; ++i) {
    result->data[i] = array[i]->data;
    free(array[i]);
  }

  return result;
}
