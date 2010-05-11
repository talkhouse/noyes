#include "ruby.h"
#include "noyes.h"

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
  return nmatrix_2_v(N);
}

void Init_dct() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cDiscreteCosineTransform = rb_define_class_under(m_noyes_c,
                        "DiscreteCosineTransform", rb_cObject);
  rb_define_method(cDiscreteCosineTransform, "initialize", t_init, -2);
  rb_define_method(cDiscreteCosineTransform, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}

