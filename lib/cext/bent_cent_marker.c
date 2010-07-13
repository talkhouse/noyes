#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cBentCentMarker;

static void _bent_cent_marker_free(void *p) {
  bent_cent_marker_free(p);
}

static VALUE t_init(VALUE self) {
  BentCentMarker *pre = bent_cent_marker_new();
  VALUE prev = Data_Wrap_Struct(cBentCentMarker, 0, _bent_cent_marker_free, pre);
  rb_iv_set(self, "@bent_cent_marker", prev);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Carr *M = r2carr(obj);
  BentCentMarker *pre;
  VALUE prev = rb_iv_get(self, "@bent_cent_marker");
  Data_Get_Struct(prev, BentCentMarker, pre);
  int res = bent_cent_marker_apply(pre, M);
  narr_free(M);
  return res ? Qtrue : Qfalse;
}

void Init_bent_cent_marker() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cBentCentMarker = rb_define_class_under(m_noyes_c, "BentCentMarker", rb_cObject);
  rb_define_method(cBentCentMarker, "initialize", t_init, 0);
  rb_define_method(cBentCentMarker, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
