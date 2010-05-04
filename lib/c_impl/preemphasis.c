#include "ruby.h"
#include "n_preemphasis.h"

static int id_push;

static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  if (len ==1) {
    rb_iv_set(self, "@factor", rb_ary_entry(args, 0));
  } else {
    rb_iv_set(self, "@factor", rb_float_new(0.97));
  }
  rb_iv_set(self, "@prior", rb_float_new(0.0));

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  int len = RARRAY_LEN(obj);
  int *ptr = (int*)RARRAY_PTR(obj);
  int i;
  float *data = ALLOCA_N(float, len);
  for (i=0;i<len;++i) {
    data[i] = NUM2DBL(ptr[i]);
  }
  
  VALUE factor = rb_iv_get(self, "@factor");
  VALUE prior = rb_iv_get(self, "@prior");
  rb_iv_set(self, "@prior", rb_float_new(data[len-1]));
  data = preemphasize(data, len, NUM2DBL(factor), NUM2DBL(prior)); 
  VALUE result = rb_ary_new2(len);
  for (i=0;i<len;++i) {
    rb_ary_store(result, i, rb_float_new(data[i]));
  }
  return result;
}

VALUE cPreemphasis;

void Init_preemphasis() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cPreemphasis = rb_define_class_under(m_noyes_c, "Preemphasizer", rb_cObject);
  rb_define_method(cPreemphasis, "initialize", t_init, -2);
  rb_define_method(cPreemphasis, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
