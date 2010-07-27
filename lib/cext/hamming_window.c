#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

VALUE cHammingWindow;

static void _hamming_window_free(void *p) {
  hamming_window_free(p);
}
static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  int winsz = 205;
  if (len > 0) {
     winsz = NUM2INT(rb_ary_entry(args, 0));
  }
  HammingWindow *hw = hamming_window_new(winsz);
  VALUE hwv = Data_Wrap_Struct(cHammingWindow, 0, _hamming_window_free, hw);
  rb_iv_set(self, "@hw", hwv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Cmat *M = r2cmat(obj);
  HammingWindow *hw;
  VALUE hwv = rb_iv_get(self, "@hw");
  Data_Get_Struct(hwv, HammingWindow, hw);
  Cmat *N = hamming_window_apply(hw, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  cmat_free(M);
  return result;
}

void Init_hamming_window() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cHammingWindow = rb_define_class_under(m_noyes_c, "HammingWindow", rb_cObject);
  rb_define_method(cHammingWindow, "initialize", t_init, -2);
  rb_define_method(cHammingWindow, "<<", t_left_shift, 1);
}
