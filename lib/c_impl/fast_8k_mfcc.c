#include "ruby.h"
#include "noyes.h"
#include "rnoyes.h"

static int id_push;

VALUE cFast8kMfcc;

static void fast_8k_mfcc_free(Fast8kMfcc *p) {
  free_fast_8k_mfcc(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  Fast8kMfcc *s = new_fast_8k_mfcc();
  VALUE fast_8k_mfcc = Data_Wrap_Struct(cFast8kMfcc, 0, fast_8k_mfcc_free, s);
  rb_iv_set(self, "@fast_8k_mfcc", fast_8k_mfcc);

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  NMatrix1 *M = v_2_nmatrix1(obj); 
  VALUE fast_8k_mfcc = rb_iv_get(self, "@fast_8k_mfcc");
  Fast8kMfcc *s;
  Data_Get_Struct(fast_8k_mfcc, Fast8kMfcc, s);
  NMatrix *N = fast_8k_mfcc_apply(s, M);
  VALUE result = nmatrix_2_v(N);
  free_nmatrix(N);
  free_nmatrix1(M);
  return result;
}

void Init_fast_8k_mfcc() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cFast8kMfcc = rb_define_class_under(m_noyes_c, "Fast8kMfcc", rb_cObject);
  rb_define_method(cFast8kMfcc, "initialize", t_init, -2);
  rb_define_method(cFast8kMfcc, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
