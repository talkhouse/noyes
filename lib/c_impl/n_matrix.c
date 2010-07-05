#include "noyes.h"
#include "memory.h"

// A 2 dimensional dense rectangular matrix "class".
Nmat *nmat_new(int rows, int cols) {
  Nmat *M = malloc(sizeof(Nmat));
  M->data = malloc(rows * sizeof(double*));
  int i;
  for (i=0;i<rows;++i) {
    M->data[i] = malloc(cols * sizeof(double));
  }
  M->rows = rows;
  M->cols = cols;
  return M;
}

void nmat_free(Nmat *M) {
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
Narr *narr_new(int rows) {
  Narr *M = malloc(sizeof(Narr));
  M->data = malloc(rows * sizeof(double));
  M->rows = rows;
  return M;
}

void narr_free(Narr *M) {
  if (M) {
    free(M->data);
    free(M);
  }
}

// Converts a rectangular matrix to a list of one dimensional matrices.
// Simultaneously frees the original rectangular matrix.
Narr ** mat2arrs(Nmat *M) {
  Narr **single = malloc(sizeof(Narr*) * M->rows);
  int i;
  for (i=0;i<M->rows;++i) {
    single[i] = malloc(sizeof(Narr));
    single[i]->data = M->data[i];
    single[i]->rows = M->cols;
  }
  free(M->data);
  free(M);
  return single;
}

// Creates an array by appending columns of a rectangular matrix.  Does not
// delete the original matrix.
Narr *nmat_flatten(Nmat *M) {
  Narr *fmat = malloc(sizeof(Nmat));
  fmat->rows = M->rows * M->cols;
  fmat->data = malloc(fmat->rows * sizeof(double));
  int i;
  for (i=0;i<M->rows; ++i)
    memcpy(fmat->data + (M->cols * i), M->data[i], sizeof(double) * M->cols);

  return fmat;
}

// Converts an array of one dimensional arrays into a rectangular matrix.  It
// frees these arrays in the process.  All arrays must have the same length.
Nmat * arrs2mat(Narr **array, int size) {
  if (size ==0)
    return NULL;
  Nmat *result = malloc(sizeof(Nmat));
  result->data = malloc(sizeof(double*) * size);
  result->rows = size;
  int i;
  for (i=0; i<size; ++i) {
    result->data[i] = array[i]->data;
    free(array[i]);
  }

  return result;
}
