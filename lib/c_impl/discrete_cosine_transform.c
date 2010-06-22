#include "ruby.h"
#include "noyes.h"
#include "rnoyes.h"

static int id_push;

VALUE cDiscreteCosineTransform;

static void dct_free(void *p) {
  free_dct(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  int rows=13,cols=32;
  if (len > 0)
     rows = NUM2INT(rb_ary_entry(args, 0));
  if (len > 1)
     cols = NUM2INT(rb_ary_entry(args, 1));

  DiscreteCosineTransform *dct = new_dct(rows,cols);
  VALUE dctv = Data_Wrap_Struct(cDiscreteCosineTransform, 0, dct_free, dct);
  rb_iv_set(self, "@dct", dctv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  NMatrix *M = v_2_nmatrix(obj);
  DiscreteCosineTransform *dct;
  VALUE dctv = rb_iv_get(self, "@dct");
  Data_Get_Struct(dctv, DiscreteCosineTransform, dct);
  NMatrix *N = dct_apply(dct, M);
  VALUE result = nmatrix_2_v(N);
  free_nmatrix(N);
  return result;
}

static VALUE t_melcos(VALUE self) {
  DiscreteCosineTransform *dct;
  VALUE dctv = rb_iv_get(self, "@dct");
  Data_Get_Struct(dctv, DiscreteCosineTransform, dct);
  NMatrix *N = new_nmatrix(dct->rows, dct->cols);
  int i;
  for (i=0;i<dct->rows;++i) {
    memcpy(N->data[i],dct->melcos[i], dct->cols * sizeof(double));
  }
  VALUE result = nmatrix_2_v(N);
  free_nmatrix(N);
  return result;
}

static VALUE t_dft(VALUE classmod, VALUE data, VALUE size) {
  NMatrix1 *M = v_2_nmatrix1(data);
  NMatrix *R = dft(M->data, M->rows, FIX2INT(size));
  VALUE result = rb_ary_new2(R->cols);
  int i;
  for (i=0;i<R->cols;++i) {
    VALUE real = rb_float_new(R->data[0][i]);
    VALUE imag = rb_float_new(R->data[1][i]);
    rb_ary_store(result, i, rb_complex_new(real, imag));
  }
  free_nmatrix1(M);
  free_nmatrix(R);
  return result;
}

void Init_dct() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cDiscreteCosineTransform = rb_define_class_under(m_noyes_c,
                        "DCT", rb_cObject);
  rb_define_method(cDiscreteCosineTransform, "initialize", t_init, -2);
  rb_define_method(cDiscreteCosineTransform, "<<", t_left_shift, 1);
  rb_define_method(cDiscreteCosineTransform, "melcos", t_melcos, 0);
  rb_define_module_function(m_noyes_c, "dft", t_dft, 2);
  id_push = rb_intern("push");
}
