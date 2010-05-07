#include "ruby.h"
#include "noyes.h"

static int id_push;

VALUE cHammingWindow;

static void hamming_window_free(void *p) {
  free_hamming_window(p);
}
static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  int winsz = 205;
  if (len > 0) {
     winsz = NUM2INT(rb_ary_entry(args, 0));
  }
  HammingWindow *hw = new_hamming_window(winsz);
  VALUE hwv = Data_Wrap_Struct(cHammingWindow, 0, hamming_window_free, hw);
  rb_iv_set(self, "@hw", hwv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  NMatrix *M = v_2_nmatrix(obj);
  HammingWindow *hw;
  VALUE hwv = rb_iv_get(self, "@hw");
  Data_Get_Struct(hwv, HammingWindow, hw);
  NMatrix *N = hamming_window_apply(hw, M);
  return nmatrix_2_v(N);
}

void Init_hamming_window() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cHammingWindow = rb_define_class_under(m_noyes_c, "HammingWindow", rb_cObject);
  rb_define_method(cHammingWindow, "initialize", t_init, -2);
  rb_define_method(cHammingWindow, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
