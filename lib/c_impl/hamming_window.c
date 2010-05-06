#include "ruby.h"
#include "noyes.h"

static int id_push;

VALUE cHammingWindow;

static void hamming_window_free(void *p) {
  free_hamming_window(p);
}
static VALUE t_init(VALUE self, VALUE args) {
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
 return self;
}

void Init_hamming_window() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cHammingWindow = rb_define_class_under(m_noyes_c, "HammingWindow", rb_cObject);
  rb_define_method(cHammingWindow, "initialize", t_init, -2);
  rb_define_method(cHammingWindow, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
