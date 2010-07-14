#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cBentCentMarker;

static void _bent_cent_marker_free(void *p) {
  bent_cent_marker_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  double adjustment = 0.003;
  double average_number = 1.0;
  double background = 100.0;
  double level = 0.0;
  double min_signal = 0.0;
  double threshold = 10.0;
  int len = RARRAY_LEN(args);
  if (len > 0)
     threshold = NUM2INT(rb_ary_entry(args, 0));
  if (len > 1)
    adjustment = NUM2INT(rb_ary_entry(args, 1));
  if (len > 2)
    average_number = NUM2INT(rb_ary_entry(args, 2));
  if (len > 3)
    background = NUM2INT(rb_ary_entry(args, 3));
  if (len > 4)
    level = NUM2INT(rb_ary_entry(args, 4));
  if (len > 5)
    min_signal = NUM2INT(rb_ary_entry(args, 5));

  BentCentMarker *pre = bent_cent_marker_new(threshold, adjustment,
                        average_number, background, level, min_signal);

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
  rb_define_method(cBentCentMarker, "initialize", t_init, -2);
  rb_define_method(cBentCentMarker, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
