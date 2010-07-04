#include "noyes.h"
#include "rnoyes.h"

// Wrappers for matrix class
Nmat * v_2_nmatrix(VALUE value) {
  Nmat *M = NULL;
  int rows = RARRAY_LEN(value);
  int cols = 0;
  if (rows > 0) {
    VALUE colzero = rb_ary_entry(value, 0);
    colzero = rb_check_array_type(colzero);
    if (NIL_P(colzero)) {
      rb_raise(rb_eTypeError, "Matrix one dimensional instead of two");
    }
    cols = RARRAY_LEN(colzero);
    M = nmat_new(rows,cols);
     int i,j;
     for (i=0;i<rows;++i) {
       VALUE col = rb_ary_entry(value, i);
         for (j=0;j<cols;++j) {
           M->data[i][j] = NUM2DBL(rb_ary_entry(col, j));
         }
     }
  }
  return M;
}

VALUE nmatrix_2_v(Nmat *M) {
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

Narr * v_2_nmatrix1(VALUE value) {
  Narr *M = NULL;
  int rows = RARRAY_LEN(value);
  if (rows > 0) {
    VALUE colzero = rb_ary_entry(value, 0);
    colzero = rb_check_array_type(colzero);
    if (!NIL_P(colzero)) {
      rb_raise(rb_eTypeError, "Matrix two dimensional instead of one");
    }
    M = nmat_new1(rows);
     int i;
     for (i=0;i<rows;++i) {
       VALUE val = rb_ary_entry(value, i);
       M->data[i] = NUM2DBL(val);
     }
  }
  return M;
}

VALUE nmatrix1_2_v(Narr *M) {
  VALUE v = Qnil;
  if (M) {
    v = rb_ary_new2(M->rows);
    int i;
    for (i=0;i<M->rows;++i) {
      rb_ary_store(v, i, rb_float_new(M->data[i]));
    }
  }
  
  return v;
}

// Initialize Ruby API wrappers.
void Init_noyes_c() {
  Init_segmenter();
  Init_preemphasis();
  Init_hamming_window();
  Init_power_spectrum();
  Init_mel_filter();
  Init_log_compressor();
  Init_live_cmn();
  Init_fast_8k_mfcc();
  Init_dct();
  Init_bent_cent_marker();
  Init_speech_trimmer();
  Init_n_list();
}
