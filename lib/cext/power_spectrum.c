#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

VALUE cPowerSpectrum;

static void _power_spectrum_free(void *p) {
  power_spectrum_free(p);
}

static VALUE t_init(VALUE self, VALUE args) {
  int len = RARRAY_LEN(args);
  int nfft = 256;
  if (len > 0) {
     nfft = NUM2INT(rb_ary_entry(args, 0));
  }
  PowerSpectrum *ps = new_power_spectrum(nfft);
  VALUE psv = Data_Wrap_Struct(cPowerSpectrum, 0, _power_spectrum_free, ps);
  rb_iv_set(self, "@ps", psv);
  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Cmat *M = r2cmat(obj);
  PowerSpectrum *ps;
  VALUE psv = rb_iv_get(self, "@ps");
  Data_Get_Struct(psv, PowerSpectrum, ps);
  Cmat *N = power_spectrum_apply(ps, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  cmat_free(M);
  return result;
}

void Init_power_spectrum() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cPowerSpectrum = rb_define_class_under(m_noyes_c, "PowerSpectrumFilter", rb_cObject);
  rb_define_method(cPowerSpectrum, "initialize", t_init, -2);
  rb_define_method(cPowerSpectrum, "<<", t_left_shift, 1);
}
