#include "noyes.h"
#include "ruby.h"

NMatrix *new_nmatrix(int rows, int cols) {
  NMatrix *M = malloc(sizeof(NMatrix));
  M->data = malloc(rows * sizeof(double));
  int i;
  for (i=0;i<rows;++i) {
    M->data[i] = malloc(cols * sizeof(double));
  }
  M->rows = rows;
  M->cols = cols;
  return M;
}

void free_nmatrix(NMatrix *M) {
  int i;
  for (i=0;i<M->rows;++i) {
    free(M->data[i]);
  }
  free(M->data);
  free(M);
}

// Ruby wrapper specific stuff goes below here:
NMatrix * v_2_nmatrix(VALUE value) {
  NMatrix *M = NULL;
  int rows = RARRAY_LEN(value);
  int cols = 0;
  if (rows > 0) {
    VALUE colzero = rb_ary_entry(value, 0);
    colzero = rb_check_array_type(colzero);
    if (NIL_P(colzero)) {
      rb_raise(rb_eTypeError, "Matrix one dimensional instead of two");
    }
    cols = RARRAY_LEN(colzero);
    M = new_nmatrix(rows,cols);
     int i,j;
     for (i=0;i<rows;++i) {
       VALUE col = rb_ary_entry(value, i);
         for (j=0;j<cols;++j) {
           VALUE cell = rb_ary_entry(col, i);
           M->data[i][j] = NUM2DBL(rb_ary_entry(col, j));
         }
     }
  }
  return M;
}

VALUE nmatrix_2_v(NMatrix *M) {
  VALUE v = Qnil;
  if (M) {
    v = rb_ary_new2(M->rows);
    int i, j;
    for (i=0;i<M->rows;++i) {
      VALUE col = rb_ary_new2(M->cols);
      rb_ary_store(v, i, col);
      for (j=0;j<M->cols;++j) {
        rb_ary_store(col, j, rb_float_new(M->data[i][j]));
      }
    }
  }
  
  return v;
}

void Init_noyes_c() {
  Init_segmenter();
  Init_preemphasis();
  Init_hamming_window();
}
