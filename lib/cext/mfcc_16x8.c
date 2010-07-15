#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cMfcc16x8;

static void _mfcc_16x8_free(Mfcc16x8 *p) {
  mfcc_16x8_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  Mfcc16x8 *s = mfcc_16x8_new();
  VALUE mfcc_16x8 = Data_Wrap_Struct(cMfcc16x8, 0, _mfcc_16x8_free, s);
  rb_iv_set(self, "@mfcc_16x8", mfcc_16x8);

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Carr *M = r2carr(obj);
  VALUE mfcc_16x8 = rb_iv_get(self, "@mfcc_16x8");
  Mfcc16x8 *s;
  Data_Get_Struct(mfcc_16x8, Mfcc16x8, s);
  Cmat *N = mfcc_16x8_apply(s, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  narr_free(M);
  return result;
}

void Init_mfcc_16x8() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cMfcc16x8 = rb_define_class_under(m_noyes_c, "Mfcc16x8", rb_cObject);
  rb_define_method(cMfcc16x8, "initialize", t_init, -2);
  rb_define_method(cMfcc16x8, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
