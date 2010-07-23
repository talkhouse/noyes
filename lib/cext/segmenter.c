#include "ruby.h"
#include "c_noyes.h"
#include "r_noyes.h"

static int id_push;

VALUE cSegmenter;

static void _segmenter_free(void *p) {
  segmenter_free(p);
}
static VALUE t_init(VALUE self, VALUE args) {
  int winsz = 205;
  int winshift = 80;
  int len = RARRAY_LEN(args);
  if (len > 0) {
     winsz = NUM2INT(rb_ary_entry(args, 0));
  }
  if (len > 1) {
    winshift = NUM2INT(rb_ary_entry(args, 1));
  }

  Segmenter *s = new_segmenter(winsz, winshift);
  VALUE segmenter = Data_Wrap_Struct(cSegmenter, 0, _segmenter_free, s);
  rb_iv_set(self, "@segmenter", segmenter);

  return self;
}

static VALUE t_left_shift(VALUE self, VALUE obj) {
  Carr *M = r2carr(obj); 
  VALUE segmenter = rb_iv_get(self, "@segmenter");
  Segmenter *s;
  Data_Get_Struct(segmenter, Segmenter, s);
  Cmat *N = segmenter_apply(s, M);
  VALUE result = cmat2r(N);
  cmat_free(N);
  carr_free(M);
  return result;
}

void Init_segmenter() {
  VALUE m_noyes_c = rb_define_module("NoyesC");
  cSegmenter = rb_define_class_under(m_noyes_c, "Segmenter", rb_cObject);
  rb_define_method(cSegmenter, "initialize", t_init, -2);
  rb_define_method(cSegmenter, "<<", t_left_shift, 1);
  id_push = rb_intern("push");
}
