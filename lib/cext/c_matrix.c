#include "c_noyes.h"
#include "memory.h"

// A 2 dimensional dense rectangular matrix "class".
Cmat *cmat_new(int rows, int cols) {
  Cmat *M = malloc(sizeof(Cmat));
  M->data = malloc(rows * sizeof(double*));
  int i;
  for (i=0;i<rows;++i) {
    M->data[i] = malloc(cols * sizeof(double));
  }
  M->rows = rows;
  M->cols = cols;
  return M;
}

void cmat_free(Cmat *M) {
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
Carr *carr_new(int rows) {
  Carr *M = malloc(sizeof(Carr));
  M->data = malloc(rows * sizeof(double));
  M->rows = rows;
  return M;
}

void carr_free(Carr *M) {
  if (M) {
    free(M->data);
    free(M);
  }
}

// Converts a rectangular matrix to a list of one dimensional matrices.
// Simultaneously frees the original rectangular matrix.  Actually, the matrix
// does not have to be rectangular.  Column sizes may vary.
Carr ** mat2arrs(Cmat *M) {
  Carr **arrs = malloc(sizeof(Carr*) * M->rows);
  int i;
  for (i=0;i<M->rows;++i) {
    arrs[i] = malloc(sizeof(Carr));
    arrs[i]->data = M->data[i];
    arrs[i]->rows = M->cols;
  }
  free(M->data);
  free(M);
  return arrs;
}

// Creates an array by appending columns of a rectangular matrix.  Does not
// delete the original matrix.
Carr *cmat_flatten(Cmat *M) {
  Carr *flat = carr_new(M->rows * M->cols);
  int i;
  for (i=0;i<M->rows; ++i)
    memcpy(flat->data + (M->cols * i), M->data[i], sizeof(double) * M->cols);

  return flat;
}

// Converts an array of one dimensional arrays into a rectangular matrix.  It
// frees these arrays in the process.  All arrays must have the same length.
Cmat * arrs2mat(Carr **array, int size) {
  if (size == 0) {
    if (array != NULL)
      free(array);
    return NULL;
  }
  Cmat *mat = malloc(sizeof(Cmat));
  mat->data = malloc(sizeof(double*) * size);
  mat->rows = size;
  mat->cols = array[0]->rows;
  int i;
  for (i=0; i<size; ++i) {
    mat->data[i] = array[i]->data;
    free(array[i]);
  }
  free(array);

  return mat;
}
