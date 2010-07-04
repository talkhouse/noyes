#include "ruby.h"
#include "noyes.h"
#include "rnoyes.h"

static int id_push;

VALUE cBentCentMarker;

static void bent_cent_marker_free(void *p) {
  free_bent_cent_marker(p);
}

static VALUE t_init(VALUE self) {
  BentCentMarker *pre = new_bent_cent_marker();
  VALUE prev = Data_Wrap_Struct(cBentCentMarker, 0, bent_cent_marker_free, pre);
  rb_iv_set(self, "@bent_cent_marker", prev);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Narr *M = v_2_nmatrix1(obj);
  BentCentMarker *pre;
  VALUE prev = rb_iv_get(self, "@bent_cent_marker");
  Data_Get_Struct(prev, BentCentMarker, pre);
  int res = bent_cent_marker_apply(pre, M);
  nmat_free1(M);
  return res ? Qtrue : Qfalse;
}

void Init_bent_cent_marker() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cBentCentMarker = rb_define_class_under(m_noyes_c, "BentCentMarker", rb_cObject);
  rb_define_method(cBentCentMarker, "initialize", t_init, 0);
  rb_define_method(cBentCentMarker, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
