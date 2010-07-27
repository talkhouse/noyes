#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

VALUE cLogCompressor;

static void _log_compressor_free(void *p) {
  log_compressor_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  double log_zero = -0.00001;
  if (len > 0) {
     log_zero = NUM2DBL(rb_ary_entry(args, 0));
  }
  LogCompressor *lc = log_compressor_new(log_zero);
  VALUE lcv = Data_Wrap_Struct(cLogCompressor, 0, _log_compressor_free, lc);
  rb_iv_set(self, "@log_compressor", lcv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Cmat *M = r2cmat(obj);
  LogCompressor *lc;
  VALUE lcv = rb_iv_get(self, "@log_compressor");
  Data_Get_Struct(lcv, LogCompressor, lc);
  Cmat *N = log_compressor_apply(lc, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  cmat_free(M);
  return result;
}

void Init_log_compressor() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cLogCompressor = rb_define_class_under(m_noyes_c, "LogCompressor", rb_cObject);
  rb_define_method(cLogCompressor, "initialize", t_init, -2);
  rb_define_method(cLogCompressor, "<<", t_left_shift, 1);
}
