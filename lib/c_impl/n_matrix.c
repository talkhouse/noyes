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
// Simultaneously frees the original rectangular matrix.  Actually, the matrix
// does not have to be rectangular.  Column sizes may vary.
Narr ** mat2arrs(Nmat *M) {
  Narr **arrs = malloc(sizeof(Narr*) * M->rows);
  int i;
  for (i=0;i<M->rows;++i) {
    arrs[i] = malloc(sizeof(Narr));
    arrs[i]->data = M->data[i];
    arrs[i]->rows = M->cols;
  }
  free(M->data);
  free(M);
  return arrs;
}

// Creates an array by appending columns of a rectangular matrix.  Does not
// delete the original matrix.
Narr *nmat_flatten(Nmat *M) {
  Narr *flat = narr_new(M->rows * M->cols);
  int i;
  for (i=0;i<M->rows; ++i)
    memcpy(flat->data + (M->cols * i), M->data[i], sizeof(double) * M->cols);

  return flat;
}

// Converts an array of one dimensional arrays into a rectangular matrix.  It
// frees these arrays in the process.  All arrays must have the same length.
Nmat * arrs2mat(Narr **array, int size) {
  if (size ==0)
    return NULL;
  Nmat *mat = malloc(sizeof(Nmat));
  mat->data = malloc(sizeof(double*) * size);
  mat->rows = size;
  int i;
  for (i=0; i<size; ++i) {
    mat->data[i] = array[i]->data;
    free(array[i]);
  }

  return mat;
}
