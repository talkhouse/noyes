#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cLiveCMN;

static void _live_cmn_free(void *p) {
  live_cmn_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  int dimensions=13, init_mean=45.0, window_size=100, shift=160;
  int len = RARRAY_LEN(args);
  if (len > 0)
     dimensions = NUM2INT(rb_ary_entry(args, 0));
  if (len > 1)
     init_mean= NUM2INT(rb_ary_entry(args, 1));
  if (len > 2)
     window_size = NUM2INT(rb_ary_entry(args, 2));
  if (len > 3)
     shift = NUM2INT(rb_ary_entry(args, 3));

  LiveCMN *cmn = live_cmn_new(dimensions, init_mean, window_size, shift);
  VALUE cmnv = Data_Wrap_Struct(cLiveCMN, 0, _live_cmn_free, cmn);
  rb_iv_set(self, "@cmn", cmnv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Cmat *M = r2cmat(obj);
  LiveCMN *cmn;
  VALUE cmnv = rb_iv_get(self, "@cmn");
  Data_Get_Struct(cmnv, LiveCMN, cmn);
  Cmat *N = live_cmn_apply(cmn, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  return result;
}

void Init_live_cmn() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cLiveCMN = rb_define_class_under(m_noyes_c, "LiveCMN", rb_cObject);
  rb_define_method(cLiveCMN, "initialize", t_init, -2);
  rb_define_method(cLiveCMN, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}

